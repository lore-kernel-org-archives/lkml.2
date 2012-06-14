Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab2FNEmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 00:42:51 -0400
Received: from outbound04.telus.net ([199.185.220.223]:38583 "EHLO
	defout.telus.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750926Ab2FNEmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 00:42:49 -0400
X-Authority-Analysis: v=1.1 cv=wkBup0WkMydMoKkTbziYo/XPEWT17JaY6W1ymNmqUIo=
 c=1 sm=2 a=d5aLr75umSEA:10 a=LGgl8L9ij00A:10 a=lXe-43oFB1roVBdz0kAA:9
 a=UAVRJdkkkM0A:10 a=9fFfuLTvkG4Xlg-v8QkA:9
X-Telus-Outbound-IP: 209.121.28.192
From: "Doug Smythies" <dsmythies@telus.net>
To: "'Charles Wang'" <muming.wq@gmail.com>
Cc: "'Peter Zijlstra'" <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Charles Wang'" <muming.wq@taobao.com>, "'Tao Ma'" <tm@tao.ma>,
        =?iso-2022-jp?B?JxskQjReQmMbKEIn?= <handai.szj@taobao.com>,
        "Doug Smythies" <dsmythies@telus.net>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>	 <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com> <1339494970.31548.66.camel@twins> <004701cd4929$200d4600$6027d200$@net> <4FD84795.20409@gmail.com>
In-Reply-To: <4FD84795.20409@gmail.com>
Subject: RE: [PATCH] sched: Folding nohz load accounting more accurate
Date: Wed, 13 Jun 2012 21:41:50 -0700
Message-ID: <000301cd49e8$1dbd2db0$59378910$@net>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0004_01CD49AD.715E55B0"
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac1JOgEo4BlicYfDRFSjy0RDzmQ6EAAofIwg
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0004_01CD49AD.715E55B0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit

> On 2012.06.13 00:56 - 0700, Charles Wang wrote:

> Every cpu's load should be the load right on the time executing
> calculation.
> This is what my patch expected to do.

> After my patch, it's supposed to let every cpu's load calculation be
> independent from
> its idle and other cpus' influence when the calculation is finished.
> But it seems other problem exists.

> I recorded some trace, show as below:

Charles thanks for your detailed reply.
I am not sure I agree.

On purpose, I have left out your trace detail from this reply.
Why? Because I want to take a step back and answer a more fundamental
question first:
Is there (or was there) actually a problem that needed to be solved?

I am still not understanding what your expected reported load averages
for your 16 processes should be. How do you know that the 8 to 10 that
was being reported was incorrect?

I want to understand so that I can re-create your same reported load
averages are still to low situation on my test computer, before your patch.
Then show that it is fixed after your patch.
I have tried to re-create it and have been unsuccessful. Today, and since
you
showed at least 16 CPUs on your system, and I only have 8 CPUs, I tried with
8 processes at high duty cycle. The reported load average was always pretty
close to the actual load (see also attachment).

Perhaps I have some fundamental misunderstanding as to how reported load
averages should work. I have always used kernels compiled with
CONFIG_NO_HZ=no (tick based, rather than tickless) as the control reference.


------=_NextPart_000_0004_01CD49AD.715E55B0
Content-Type: text/plain;
	name="wang_high_load_example.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="wang_high_load_example.txt"

2012.06.13 Smythies: Top showing Reported load averages and data to =
calculate
it manually.

.997 * 8 =3D 7.97 actual load

Note: the 15 minute reported load average is still lagging behind.

top - 21:22:01 up 22:53,  4 users,  load average: 8.00, 7.99, 7.75
Tasks: 144 total,   9 running, 135 sleeping,   0 stopped,   0 zombie
Cpu0  : 99.7%us,  0.0%sy,  0.0%ni,  0.3%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Cpu1  : 99.7%us,  0.0%sy,  0.0%ni,  0.3%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Cpu2  : 99.7%us,  0.0%sy,  0.0%ni,  0.3%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Cpu3  : 99.7%us,  0.0%sy,  0.0%ni,  0.3%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Cpu4  : 99.3%us,  0.0%sy,  0.0%ni,  0.7%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Cpu5  : 99.3%us,  0.0%sy,  0.0%ni,  0.7%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Cpu6  : 99.3%us,  0.0%sy,  0.0%ni,  0.7%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Cpu7  : 99.7%us,  0.0%sy,  0.0%ni,  0.3%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Mem:   7956184k total,  1093384k used,  6862800k free,   345772k buffers
Swap:  8294396k total,        0k used,  8294396k free,   386956k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 4743 doug      20   0  4156   92    0 R   99  0.0  31:43.75 waiter
 4744 doug      20   0  4156   92    0 R   99  0.0  31:43.22 waiter
 4746 doug      20   0  4156   92    0 R   99  0.0  31:43.77 waiter
 4747 doug      20   0  4156   92    0 R   99  0.0  31:42.88 waiter
 4748 doug      20   0  4156   92    0 R   99  0.0  31:43.67 waiter
 4749 doug      20   0  4156   92    0 R   99  0.0  31:43.58 waiter
 4750 doug      20   0  4156   92    0 R   99  0.0  31:44.06 waiter
 4745 doug      20   0  4156   92    0 R   99  0.0  31:42.22 waiter
 2851 doug      20   0 17332 1452 1064 S    0  0.0   2:23.77 top
 4728 doug      20   0 17332 1332  960 R    0  0.0   0:07.02 top
    1 root      20   0 24464 2360 1344 S    0  0.0   0:00.88 init


Loading program output:

Child  0 lp  149 of 1800: Elapsed:1951.14 s. Delta:  13.15 s. user =
cpu:1938.20 s. sys cpu:   0.10 s. load:0.9934  last sleep freq.:  27.376 =
Hz. average sleep freq.:  27.492 Hz.
Child  3 lp  150 of 1800: Elapsed:1951.60 s. Delta:  13.16 s. user =
cpu:1938.84 s. sys cpu:   0.09 s. load:0.9935  last sleep freq.:  27.356 =
Hz. average sleep freq.:  27.670 Hz.
Child  1 lp  151 of 1800: Elapsed:1955.15 s. Delta:  13.17 s. user =
cpu:1941.74 s. sys cpu:   0.05 s. load:0.9932  last sleep freq.:  27.335 =
Hz. average sleep freq.:  27.803 Hz.
Child  6 lp  151 of 1800: Elapsed:1957.17 s. Delta:  12.74 s. user =
cpu:1944.34 s. sys cpu:   0.07 s. load:0.9935  last sleep freq.:  28.257 =
Hz. average sleep freq.:  27.775 Hz.
Child  5 lp  152 of 1800: Elapsed:1957.65 s. Delta:  12.96 s. user =
cpu:1944.84 s. sys cpu:   0.06 s. load:0.9935  last sleep freq.:  27.778 =
Hz. average sleep freq.:  27.952 Hz.
Child  7 lp  151 of 1800: Elapsed:1958.06 s. Delta:  12.74 s. user =
cpu:1945.80 s. sys cpu:   0.03 s. load:0.9938  last sleep freq.:  28.257 =
Hz. average sleep freq.:  27.762 Hz.
Child  4 lp  152 of 1800: Elapsed:1958.47 s. Delta:  13.01 s. user =
cpu:1944.70 s. sys cpu:   0.06 s. load:0.9930  last sleep freq.:  27.671 =
Hz. average sleep freq.:  27.940 Hz.
Child  2 lp  152 of 1800: Elapsed:1959.97 s. Delta:  12.75 s. user =
cpu:1945.56 s. sys cpu:   0.07 s. load:0.9927  last sleep freq.:  28.235 =
Hz. average sleep freq.:  27.919 Hz.

0.993 * 8 =3D 7.94 actual load

------=_NextPart_000_0004_01CD49AD.715E55B0--


