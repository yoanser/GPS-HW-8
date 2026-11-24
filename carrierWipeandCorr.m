function [magS,chip_idx] = carrierWipeandCorr(signal,signalTime,PRNCode,intTime,dopplerDelay,k)
%{
Function carrierWipeandCorr
AUTHOR: Yoan Serafimov
INPUTS: signal - signal array
signalTime - how long signal was collected for
PRNCode - PRN code array for satellite of interest
intTime - integration time in seconds
dopplerDelay - doppler delay in Hz
k - time delay in samples

OUTPUTS: magS = magnitude of "integrate and dump" method

%}


f_chip = 1.023e6;          % GPS L1 C/A chip rate (1.023 MHz)
Nchip = 1023;             % Chips per 1 ms 
%Creating time vector
deltat = signalTime/length(signal);

timeVec = 0:deltat:intTime-deltat;



%map prn code to time vector
chip_idx = mod(floor(timeVec * f_chip), Nchip) + 1;
x = PRNCode(chip_idx);   % 1-by-n vector aligned with t



% k = timeDelay./deltat; % must be integer

%Doppler effect
theta = 2*pi*(20e3 + dopplerDelay).*timeVec;

%Vector of local replica

S_L = x.*exp(-1i.*theta);

%Integrate and dump output use matlab circ shift to circularly shift local replica
S_r = signal;
S=sum(S_r.*circshift(S_L,k));
magS = abs(S);

end