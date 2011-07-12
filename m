Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1GLRJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 13:09:21 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60765 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab1GLRJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 13:09:20 -0400
Date: Tue, 12 Jul 2011 12:09:10 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: Chris Ball <cjb@laptop.org>
cc: Manoj Iyer <manoj.iyer@canonical.com>, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org, matsumur@nts.ricoh.co.jp,
        linux-pci@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock
 frequency
In-Reply-To: <m2ipr779oe.fsf@bob.laptop.org>
Message-ID: <alpine.DEB.2.02.1107121123140.1767@lazy>
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com> <1310419715-13254-2-git-send-email-manoj.iyer@canonical.com> <m2wrfofpro.fsf@bob.laptop.org> <alpine.DEB.2.02.1107121050480.1767@lazy> <m2ipr779oe.fsf@bob.laptop.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-862678198-1310490555=:1767"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-862678198-1310490555=:1767
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE


Chris,

btw only the 1st write was slower, subsequent writes looks ok.

  =3D=3D=3D before =3D=3D        =3D=3D=3D after =3D=3D
real    0m0.480s vs real    0m0.757s
real    0m0.476s vs real    0m0.488s
real    0m0.484s vs real    0m0.484s
real    0m0.480s vs real    0m0.486s

I have attached the output of flashbench and the time test to

http://launchpad.net/bugs/773524

Might be easier for side by side comparison. But I have it pasted here as=
=20
well.

=3D=3D=3D FLASHBENCH =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D BEFORE PATCH =3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=3D Guess erase block and page sizes =3D=3D
u@u:~/flash/flashbench$ sudo ./flashbench -a /dev/mmcblk0=20
--blocksize=3D1024
align 536870912 pre 1.49ms      on 3.42ms       post 3.06ms     diff=20
1.15ms
align 268435456 pre 1.51ms      on 3.7ms        post 3.09ms     diff 1.4ms
align 134217728 pre 2.19ms      on 3.64ms       post 3.05ms     diff=20
1.03ms
align 67108864  pre 1.49ms      on 3.53ms       post 3.1ms      diff=20
1.23ms
align 33554432  pre 2.45ms      on 3.79ms       post 3.12ms     diff 999=C2=
=B5s
align 16777216  pre 1.46ms      on 3.52ms       post 3.1ms      diff=20
1.24ms
align 8388608   pre 1.46ms      on 3.52ms       post 3.1ms      diff=20
1.24ms
align 4194304   pre 1.46ms      on 3.52ms       post 3.1ms      diff=20
1.24ms
align 2097152   pre 1.46ms      on 3.52ms       post 3.1ms      diff=20
1.24ms
align 1048576   pre 2.02ms      on 3.79ms       post 3.12ms     diff=20
1.22ms
align 524288    pre 2.22ms      on 2.39ms       post 2.41ms     diff=20
77.6=C2=B5s
align 262144    pre 2.43ms      on 2.61ms       post 2.61ms     diff=20
95.8=C2=B5s
align 131072    pre 2.58ms      on 2.77ms       post 2.73ms     diff 111=C2=
=B5s
align 65536     pre 2.65ms      on 2.87ms       post 2.74ms     diff 169=C2=
=B5s
align 32768     pre 2.7ms       on 2.88ms       post 2.84ms     diff 107=C2=
=B5s
align 16384     pre 2.73ms      on 2.91ms       post 2.87ms     diff 111=C2=
=B5s
align 8192      pre 2.74ms      on 2.92ms       post 2.88ms     diff 109=C2=
=B5s
align 4096      pre 2.9ms       on 2.86ms       post 2.83ms     diff=20
-7395ns
align 2048      pre 2.88ms      on 2.87ms       post 2.86ms     diff=20
2.28=C2=B5s
u@u:~/flash/flashbench$

=3D=3D Finding the number of open erase blocks =3D=3D
u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=3D$[4 * 1024 *=20
1024] --blocksize=3D$[256 * 1024] /dev/mmcblk0  --open-au-nr=3D2
4MiB    6.36M/s
2MiB    6.24M/s
1MiB    6.17M/s
512KiB  6.19M/s
256KiB  6.22M/s
u@u:~/flash/flashbench$

u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=3D$[4 * 1024 *=20
1024] --blocksize=3D$[256 * 1024] /dev/mmcblk0  --open-au-nr=3D3
4MiB    6.25M/s
2MiB    6.25M/s
1MiB    6.24M/s
512KiB  2.53M/s
256KiB  1.14M/s
u@u:~/flash/flashbench$


=3D=3D=3D=3D=3D=3D AFTER PATCH =3D=3D=3D=3D=3D=3D=3D=3D
=3D=3D Guess erase block and page sizes =3D=3D
u@u:~/flash/flashbench$ sudo ./flashbench -a /dev/mmcblk0 --blocksize=3D102=
4
[sudo] password for u:
align 536870912 pre 1.56ms      on 3.53ms       post 3.14ms     diff=20
1.18ms
align 268435456 pre 1.54ms      on 3.52ms       post 3.12ms     diff=20
1.19ms
align 134217728 pre 1.5ms       on 3.5ms        post 3.1ms      diff 1.2ms
align 67108864  pre 1.56ms      on 3.68ms       post 3.2ms      diff 1.3ms
align 33554432  pre 1.55ms      on 3.6ms        post 3.15ms     diff=20
1.25ms
align 16777216  pre 1.57ms      on 3.62ms       post 3.18ms     diff=20
1.25ms
align 8388608   pre 1.57ms      on 3.61ms       post 3.16ms     diff=20
1.24ms
align 4194304   pre 1.55ms      on 3.6ms        post 3.16ms     diff=20
1.24ms
align 2097152   pre 1.56ms      on 3.61ms       post 3.22ms     diff=20
1.22ms
align 1048576   pre 1.57ms      on 3.62ms       post 3.16ms     diff=20
1.25ms
align 524288    pre 2.23ms      on 2.42ms       post 2.44ms     diff 81=C2=
=B5s
align 262144    pre 2.49ms      on 2.67ms       post 2.61ms     diff 115=C2=
=B5s
align 131072    pre 2.68ms      on 2.87ms       post 2.8ms      diff 129=C2=
=B5s
align 65536     pre 2.78ms      on 2.98ms       post 2.85ms     diff 172=C2=
=B5s
align 32768     pre 2.8ms       on 2.99ms       post 2.94ms     diff 117=C2=
=B5s
align 16384     pre 2.81ms      on 2.99ms       post 2.95ms     diff 117=C2=
=B5s
align 8192      pre 2.86ms      on 3ms  post 3.01ms     diff 68.6=C2=B5s
align 4096      pre 2.96ms      on 2.93ms       post 2.93ms     diff=20
-14207n
align 2048      pre 2.98ms      on 3ms  post 2.98ms     diff 20.1=C2=B5s
u@u:~/flash/flashbench$

=3D=3D Finding the number of open erase blocks =3D=3D
u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=3D$[4 * 1024 *=20
1024]         --blocksize=3D$[256 * 1024] /dev/mmcblk0  --open-au-nr=3D2
[sudo] password for u:
4MiB    5.49M/s
2MiB    6.22M/s
1MiB    6.22M/s
512KiB  6.21M/s
256KiB  6.21M/s
u@u:~/flash/flashbench$

u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=3D$[4 * 1024 *=20
1024] --blocksize=3D$[256 * 1024] /dev/mmcblk0  --open-au-nr=3D3
[sudo] password for u:
4MiB    5.31M/s
2MiB    6.16M/s
1MiB    6.2M/s
512KiB  2.53M/s
256KiB  1.14M/s
u@u:~/flash/flashbench$



On Tue, 12 Jul 2011, Chris Ball wrote:

> Hi Manoj,
>
> On Tue, Jul 12 2011, Manoj Iyer wrote:
>> Test System: ThinkPad X220 Tablet, using Sandisk 2GB Class 2 SD, I did
>> not see any considerable change in read/write times. Also, tested a
>> Transcend MMCPlus 2GB card, before the patch was applied it would not
>> mount the card, and would cause IO errors on read/write, but after the
>> patch it mounts and works correctly.
>> [..]
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D BEFORE THE PATCH =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> Sandisk 2GB Class2 SD
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> =3D=3D=3D WRITE =3D=3D=3D
>> u@u:~$ ls -lh test.file
>> -rw-r--r-- 1 u u 10M 2011-07-12 10:19 test.file
>> u@u:~$ time cp test.file /media/E0FD-1813/copyto
>>
>> real    0m0.480s
>> user    0m0.000s
>> sys     0m0.024s
>> [..]
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D AFTER THE PATCH =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>> Sandisk 2GB Class2 SD
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> =3D=3D=3D WRITE =3D=3D=3D
>> u@u:~$ time cp ./test.file /media/E0FD-1813/copyto1
>>
>> real    0m0.757s
>> user    0m0.000s
>> sys     0m0.044s
>
> This suggests that there *was* a considerable difference in write speed, =
no?
>
> It might be helpful to use Arnd's flashbench tool=C2=B9 for further bench=
marking,
> since it does the right thing with using direct I/O access without caches=
=2E
>
> Thanks,
>
> - Chris.
>
> =C2=B9: http://git.linaro.org/gitweb?p=3Dpeople/arnd/flashbench.git
> --=20
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
>
>

--
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--8323329-862678198-1310490555=:1767--
