Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab1KLKCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 05:02:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44161 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1KLKCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 05:02:50 -0500
Message-ID: <4EBE4445.6020106@gmail.com>
Date: Sat, 12 Nov 2011 11:02:45 +0100
From: carla <carla.sella@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: BUG: suspend/resume does not work on G62 notebook PC
References: <4EB53C46.1060301@gmail.com> <20111108010406.GC16800@kroah.com>
In-Reply-To: <20111108010406.GC16800@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> Can you try the 3.2-rc1 release?
>

Hello,
I installed kernel 3.2.0-rc1 but I'm having the same problems, this is 
the output of "sudo /usr/share/checkbox/scripts/suspend_test --full":

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
letozaf@letozaf-HP-G62:~$ sudo /usr/share/checkbox/scripts/suspend_test 
--full
This script will attempt to suspend and resume your computer a number of 
times.
Should the machine fail to resume, first attempt to manually resume it.  If
that fails power your system off and on which will generate an apport bug
report automatically.

Press CTRL-C now to abort testing ...

*** TEST 1 -- suspend triggered via dbus message
*** please ensure your AC cord is attached
*** machine will suspend for 20 seconds
*** press return when ready


SUSPEND FAILED, did not go to sleep

*** TEST 2 -- suspend with AC disconnected
*** please ensure your AC cord is detached
*** machine will suspend for 20 seconds
*** press return when ready


SUSPEND FAILED, did not go to sleep

*** TEST 3 -- suspend with AC connected
*** please ensure your AC cord is attached
*** machine will suspend for 20 seconds
*** press return when ready


SUSPEND FAILED, did not go to sleep

*** TEST 4 -- loss of AC while suspended
*** please remove the AC cord while the machine is suspended
*** machine will suspend for 20 seconds
*** press return when ready


SUSPEND FAILED, did not go to sleep

*** TEST 5 -- return of AC while suspended
*** please insert the AC cord while the machine is suspended
*** machine will suspend for 20 seconds
*** press return when ready


SUSPEND FAILED, did not go to sleep

*** TEST 6 -- battery drain during suspend
*** calculates overall power drain during a long-term suspend
*** please ensure your AC cord is detached
*** machine will suspend for 20 minutes
*** press return when ready


SUSPEND FAILED, did not go to sleep
before: 3872 mWh
after: 3840 mWh
consumed: 32 mW
sleep seconds: 1236 sec
overall usage: 93 mW

*** TEST 7 -- 30 iteration variable delay suspend/resume stress test
*** please ensure your AC cord is attached
*** machine will suspend for 20 seconds
*** NOTE: there will be no further user interaction from this point
*** press return when ready

delay 60 ...
SUSPEND FAILED, did not go to sleep
wait for 60 seconds
delay 58 ...
SUSPEND FAILED, did not go to sleep
wait for 58 seconds
delay 56 ...
SUSPEND FAILED, did not go to sleep
wait for 56 seconds
delay 54 ...
SUSPEND FAILED, did not go to sleep
wait for 54 seconds
delay 52 ...
SUSPEND FAILED, did not go to sleep
wait for 52 seconds
delay 50 ...
SUSPEND FAILED, did not go to sleep
wait for 50 seconds
delay 48 ...
SUSPEND FAILED, did not go to sleep
wait for 48 seconds
delay 46 ...
SUSPEND FAILED, did not go to sleep
wait for 46 seconds
delay 44 ...
SUSPEND FAILED, did not go to sleep
wait for 44 seconds
delay 42 ...
SUSPEND FAILED, did not go to sleep
wait for 42 seconds
delay 40 ...
SUSPEND FAILED, did not go to sleep
wait for 40 seconds
delay 38 ...
SUSPEND FAILED, did not go to sleep
wait for 38 seconds
delay 36 ...
SUSPEND FAILED, did not go to sleep
wait for 36 seconds
delay 34 ...
SUSPEND FAILED, did not go to sleep
wait for 34 seconds
delay 32 ...
SUSPEND FAILED, did not go to sleep
wait for 32 seconds
delay 30 ...
SUSPEND FAILED, did not go to sleep
wait for 30 seconds
delay 28 ...
SUSPEND FAILED, did not go to sleep
wait for 28 seconds
delay 26 ...
SUSPEND FAILED, did not go to sleep
wait for 26 seconds
delay 24 ...
SUSPEND FAILED, did not go to sleep
wait for 24 seconds
delay 22 ...
SUSPEND FAILED, did not go to sleep
wait for 22 seconds
delay 20 ...
SUSPEND FAILED, did not go to sleep
wait for 20 seconds
delay 18 ...
SUSPEND FAILED, did not go to sleep
wait for 18 seconds
delay 16 ...
SUSPEND FAILED, did not go to sleep
wait for 16 seconds
delay 14 ...
SUSPEND FAILED, did not go to sleep
wait for 14 seconds
delay 12 ...
SUSPEND FAILED, did not go to sleep
wait for 12 seconds
delay 10 ...
SUSPEND FAILED, did not go to sleep
wait for 10 seconds
delay 8 ...
SUSPEND FAILED, did not go to sleep
wait for 8 seconds
delay 6 ...
SUSPEND FAILED, did not go to sleep
wait for 6 seconds
delay 4 ...
SUSPEND FAILED, did not go to sleep
wait for 4 seconds
delay 2 ...
SUSPEND FAILED, did not go to sleep
wait for 2 seconds

*** Please report your results on the Ubuntu WIKI:
     https://wiki.ubuntu.com/KernelTeam/SuspendResumeTesting

       Battery Consumption: 93 mW
letozaf@letozaf-HP-G62:~$


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Test 1 did not work.
But all the other tests seemed to work as my laptop went on suspension, 
but when it come back from suspension, after about 30 seconds I got the 
message : "SUSPEND FAILED, did not go to sleep".
As it did this also on the last test, this test lasted very long like 
about 50 minutes, more or less.

Also the "Hibernate/Resume smoke test " did not work, my laptop's screen 
went black for about 5 seconds and then I got the lock screen asking me 
for my password to go back to my session.

Carla Sella
email:carla.sella@gmail.com
https://launchpad.net/~carla-sella



