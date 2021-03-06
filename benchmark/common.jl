using RNGTest
using RandomNumbers

function bigcrush{T<:Number}(rng::RNG.AbstractRNG{T})
    p = RNGTest.wrap(r, T)
    RNGTest.bigcrushTestU01(p)
end

function speed_test{T<:Number}(rng::RNG.AbstractRNG{T}, n=100_000_000)
    A = Array{T}(n)
    rand!(rng, A)
    elapsed = @elapsed rand!(rng, A)
    elapsed * 1e9 / n * 8 / sizeof(T)
end

function bigcrush(rng::MersenneTwister)
    p = RNGTest.wrap(r, UInt64)
    RNGTest.bigcrushTestU01(p)
end

function speed_test(rng::MersenneTwister, n=100_000_000)
    T = UInt64
    A = Array{T}(n)
    rand!(rng, A)
    elapsed = @elapsed rand!(rng, A)
    elapsed * 1e9 / n * 8 / sizeof(T)
end

function test_all(rng::Base.AbstractRNG, n=100_000_000)
    fo = open("$TEST_NAME.log", "w")
    redirect_stdout(fo)
    println(TEST_NAME)
    speed = speed_test(rng, n)
    @printf "Speed Test: %.3f ns/64 bits\n" speed
    flush(fo)
    bigcrush(rng)
    close(fo)
end
