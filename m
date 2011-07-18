Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab1GRUrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 16:47:42 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35203 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1GRUrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:47:40 -0400
Date: Mon, 18 Jul 2011 15:47:33 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: Chris Ball <cjb@laptop.org>
cc: Manoj Iyer <manoj.iyer@canonical.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        matsumur@nts.ricoh.co.jp, linux-pci@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock
 frequency
In-Reply-To: <m2zkkbb9vn.fsf@bob.laptop.org>
Message-ID: <alpine.DEB.2.02.1107181546100.1677@lazy>
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com> <m2sjqa2q93.fsf@bob.laptop.org> <alpine.DEB.2.02.1107131031360.3174@lazy> <201107131835.25217.arnd@arndb.de> <alpine.DEB.2.02.1107131144250.3174@lazy> <m21uxu2k96.fsf@bob.laptop.org>
 <alpine.DEB.2.02.1107131157440.3174@lazy> <m2wrfm1537.fsf@bob.laptop.org> <alpine.DEB.2.02.1107181535250.1677@lazy> <m2zkkbb9vn.fsf@bob.laptop.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-513804810-1311022057=:1677"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-513804810-1311022057=:1677
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



Chris,

Right, without the patch I get..

[   52.526665] mmc0: new SDHC card at address e624
[   52.571228] mmcblk0: mmc0:e624 SD16G 14.8 GiB
[   52.591071] mmcblk0: retrying using single block read
[   52.593105] mmcblk0: error -84 transferring data, sector 0, nr 8, card=
=20
status 0x900
[   52.593109] end_request: I/O error, dev mmcblk0, sector 0
[   52.594594] mmcblk0: error -84 transferring data, sector 1, nr 7, card=
=20
status 0x900
[   52.594604] end_request: I/O error, dev mmcblk0, sector 1
[   52.602893] quiet_error: 24 callbacks suppressed
[   52.602902] Buffer I/O error on device mmcblk0, logical block 0
[   52.605349] ldm_validate_partition_table(): Disk read failed.
[   52.605384] Dev mmcblk0: unable to read RDB block 0
[   52.607729]  mmcblk0: unable to read partition table
u@u:~$

So, I cannot generate any comparison data with this SD card.

On Mon, 18 Jul 2011, Chris Ball wrote:

> Hi Manoj,
>
> On Mon, Jul 18 2011, Manoj Iyer wrote:
>> Here are the results with SanDisk SDSDXP1-016G-A75 16GB Extreme Pro
>> SDHC Memory Card.
>>
>> u@u:~/flashbench$ sudo ./flashbench -a /dev/mmcblk0p1
>> [sudo] password for u:
>> align 4294967296        pre 1.16ms      on 1.15ms       post 1.15ms
>> diff -2024ns
>> align 2147483648        pre 1.2ms       on 1.2ms        post 1.2ms
>> diff 522ns
>> align 1073741824        pre 1.21ms      on 1.2ms        post 1.2ms
>> diff 570ns
>> align 536870912 pre 1.2ms       on 1.2ms        post 1.2ms      diff 662=
ns
>> align 268435456 pre 1.2ms       on 1.2ms        post 1.2ms      diff 404=
ns
>> align 134217728 pre 1.2ms       on 1.2ms        post 1.2ms      diff
>> -1692ns
>> align 67108864  pre 1.15ms      on 1.16ms       post 1.16ms     diff
>> 1.37=C2=B5s
>> align 33554432  pre 1.18ms      on 1.19ms       post 1.15ms     diff
>> 31.3=C2=B5s
>> align 16777216  pre 1.17ms      on 1.19ms       post 1.15ms     diff
>> 31.5=C2=B5s
>> align 8388608   pre 1.17ms      on 1.21ms       post 1.18ms     diff
>> 32.9=C2=B5s
>> align 4194304   pre 1.37ms      on 1.55ms       post 1.17ms     diff 274=
=C2=B5s
>> align 2097152   pre 1.37ms      on 1.37ms       post 1.39ms     diff
>> -7992ns
>> align 1048576   pre 1.33ms      on 1.33ms       post 1.34ms     diff
>> -7793ns
>> align 524288    pre 1.33ms      on 1.33ms       post 1.34ms     diff
>> -6641ns
>> align 262144    pre 1.34ms      on 1.38ms       post 1.35ms     diff
>> 33.8=C2=B5s
>> align 131072    pre 1.35ms      on 1.37ms       post 1.34ms     diff
>> 27.2=C2=B5s
>> align 65536     pre 1.34ms      on 1.37ms       post 1.34ms     diff
>> 31.7=C2=B5s
>> align 32768     pre 1.33ms      on 1.37ms       post 1.34ms     diff
>> 32.5=C2=B5s
>>
>> u@u:~/flashbench$ sudo ./flashbench -O --erasesize=3D$[4 * 1024 * 1024]
>> --blocksize=3D$[256 * 1024] /dev/mmcblk0p1 --open-au-nr=3D2
>> 4MiB    23.2M/s
>> 2MiB    23.6M/s
>> 1MiB    23.5M/s
>> 512KiB  23.2M/s
>> 256KiB  23.2M/s
>> u@u:~/flashbench$
>
> I don't understand whether these measurements are before or after your
> patch -- we're looking to see what the *difference* in performance is
> with the patch applied, right?
>
> Thanks,
>
> - Chris.
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
--8323329-513804810-1311022057=:1677--
