require 'open-uri'
require 'json'
class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ("a".."z").to_a.sample
    end
  end

  def score
    @attempt = params[:word].downcase
    @letters = params[:grid].split('')
    if letters_included?(@attempt, @letters)
      if english_word?(@attempt)
        @result = "Congratulations !! #{@attempt.upcase} is an English word!"
      else
        @result = "Sorry #{@attempt.upcase} doesn't seem to be an English word"
      end
    else
      @result = "Sorry #{@attempt.upcase} can't be built out of #{@letters.join(',')}"
    end
  end

  private

  def english_word?(attempt)
    check_url = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
    check_up = JSON.parse(open(check_url).read)
    return check_up["found"]
  end

  def letters_included?(attempt, grid)
    # attempt_array.all? { |letter| grid.delete(letter) if grid.include?(letter) }
    fake_grid = grid.dup
    attempt_array = attempt.split('')
    attempt_array.each do |letter|
      if fake_grid.include? letter
        fake_grid.delete_at(fake_grid.index(letter))
      else
        return false
      end
    end
  end
end
