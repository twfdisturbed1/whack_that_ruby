require 'gosu'

class WhackARuby < Gosu::Window
    def initialize
        super(800, 600)
        self.caption = 'Shoot that Pikachu! & Eevee'
        @image = Gosu::Image.new('Pikachu_small.png')
        @eevee_image = Gosu::Image.new('Eevee_small.png')
        @BG_image = Gosu::Image.new('BG.jpg')
        @x = 200
        @y = 200
        @x_2 = 300
        @y_2 = 300
        @width = 50
        @height = 43
        @velocity_x = 5
        @velocity_y = 5
        @velocity_x_2 = 4
        @velocity_y_2 = 4
        @visible = 0
        @hammer_image = Gosu::Image.new('crosshair_2.png')
        @hit = 0
        @score = 0
        @font = Gosu::Font.new(30)
        @playing = true
        @start_time = 0

    end
    def update
        if @playing
            @x += @velocity_x
            @y += @velocity_y
            @x_2 += @velocity_x_2
            @y_2 += @velocity_y_2
            @visible -= 1
            @time_left = (60 - ((Gosu.milliseconds - @start_time) / 1000))
            @playing = false if @time_left < 0
            @velocity_x *= -1 if @x + @width/2 > 800 || @x - @width / 2 < 0
            @velocity_y *= -1 if @y + @height/2 > 600 || @y - @height / 2 < 0
            @velocity_x_2 *= -1 if @x_2 + @width/2 > 800 || @x_2 - @width / 2 < 0
            @velocity_y_2 *= -1 if @y_2 + @height/2 > 600 || @y_2 - @height / 2 < 0
            @visible = 90 if @visible < -10 && rand < 0.01
        end
    end

    def button_down(id)
        if @playing 
            if (id == Gosu::MsLeft)
                if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible >=0 or Gosu.distance(mouse_x, mouse_y, @x_2, @y_2) < 50 && @visible >=0
                    @hit = 1
                    @score += 5
                else
                    @hit = -1
                    @score -= 1
                end
            end
        else
            if (id == Gosu::KbSpace)
                @playing = true
                @visible = -10
                @start_time = Gosu.milliseconds
                @score = 0
        end
    end
    end

    def draw
@BG_image.draw(0, 0, 0)
        if @visible > 0
        @image.draw(@x - @width / 2, @y - @height / 2, 1)
        @eevee_image.draw(@x_2 - @width / 2, @y_2 - @height / 2, 1)
        end
        @hammer_image.draw(mouse_x - 40, mouse_y - 10, 1)
        if @hit == 0
            c = Gosu::Color::NONE
        elsif @hit == 1
            c = Gosu::Color::GREEN
        elsif @hit == -1
            c = Gosu::Color::RED
        end
        draw_quad(0, 0, c, 800, 0, c, 800, 600, c, 0, 600, c)
        @hit = 0
        @font.draw("Time: " + @time_left.to_s, 20, 20, 2)
        @font.draw("Score: " + @score.to_s, 600, 20, 2)
        unless @playing
            @font.draw('Game Over', 300, 300, 3)
            @font.draw('Press the Space Bar to Playing Again', 175, 350, 3)
            @visible = 20
        end
    end
    
end

window = WhackARuby.new
window.show
