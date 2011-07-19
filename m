Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab1GSTnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 15:43:14 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36960 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1GSTnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 15:43:13 -0400
Date: Tue, 19 Jul 2011 14:43:04 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: Chris Ball <cjb@laptop.org>
cc: Manoj Iyer <manoj.iyer@canonical.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        matsumur@nts.ricoh.co.jp, linux-pci@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock
 frequency
In-Reply-To: <m2d3h7b8pv.fsf@bob.laptop.org>
Message-ID: <alpine.DEB.2.02.1107181619310.1677@lazy>
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com> <m2sjqa2q93.fsf@bob.laptop.org> <alpine.DEB.2.02.1107131031360.3174@lazy> <201107131835.25217.arnd@arndb.de> <alpine.DEB.2.02.1107131144250.3174@lazy> <m21uxu2k96.fsf@bob.laptop.org>
 <alpine.DEB.2.02.1107131157440.3174@lazy> <m2wrfm1537.fsf@bob.laptop.org> <alpine.DEB.2.02.1107181535250.1677@lazy> <m2zkkbb9vn.fsf@bob.laptop.org> <alpine.DEB.2.02.1107181546100.1677@lazy> <m2d3h7b8pv.fsf@bob.laptop.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-472274656-1311024371=:1677"
Content-ID: <alpine.DEB.2.02.1107191442460.3126@lazy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-472274656-1311024371=:1677
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.02.1107191442461.3126@lazy>


Here is flashbench data on Ricoh R5C822 for SanDisk SDSDXP1-016G-A75 16GB=
=20
Extreme Pro SDHC Memory Card. Dell XPS 1330M (Ubuntu Natty).

manjo@sleepy:~/Projects/flashbench$ sudo ./flashbench -a /dev/mmcblk0p1
[sudo] password for manjo:
align 4294967296        pre 1.91ms      on 1.92ms       post 1.92ms=20
diff 4.46=B5s
align 2147483648        pre 1.99ms      on 1.99ms       post 1.99ms=20
diff -642ns
align 1073741824        pre 1.99ms      on 1.99ms       post 1.99ms=20
diff 435ns
align 536870912 pre 1.99ms      on 1.99ms       post 1.99ms     diff=20
-1003ns
align 268435456 pre 1.99ms      on 1.99ms       post 1.99ms     diff=20
-283ns
align 134217728 pre 1.99ms      on 1.99ms       post 1.99ms     diff 539ns
align 67108864  pre 1.92ms      on 1.91ms       post 1.91ms     diff 75ns
align 33554432  pre 1.97ms      on 2.01ms       post 1.97ms     diff 41=B5s
align 16777216  pre 1.98ms      on 2.02ms       post 1.97ms     diff=20
43.9=B5s
align 8388608   pre 1.97ms      on 1.97ms       post 1.98ms     diff=20
-3481ns
align 4194304   pre 2.22ms      on 2.39ms       post 1.97ms     diff 292=B5=
s
align 2097152   pre 2.29ms      on 2.29ms       post 2.3ms      diff=20
-3058ns
align 1048576   pre 2.22ms      on 2.22ms       post 2.21ms     diff 100ns
align 524288    pre 2.22ms      on 2.21ms       post 2.21ms     diff=20
-728ns
align 262144    pre 2.24ms      on 2.24ms       post 2.24ms     diff=20
5.13=B5s
align 131072    pre 2.25ms      on 2.24ms       post 2.24ms     diff 275ns
align 65536     pre 2.23ms      on 2.23ms       post 2.23ms     diff 1.7=B5=
s
align 32768     pre 2.24ms      on 2.23ms       post 2.23ms     diff=20
-2799ns

manjo@sleepy:~/Projects/flashbench$ sudo ./flashbench -O --erasesize=3D$[4 =
*=20
1024 * 1024] --blocksize=3D$[256 * 1024] /dev/mmcblk0p1 --open-au-nr=3D2
4MiB    9.96M/s
2MiB    11.2M/s
1MiB    11.2M/s
512KiB  11.2M/s
256KiB  11.2M/s
manjo@sleepy:~/Projects/flashbench$


> Hi Manoj,
>
> On Mon, Jul 18 2011, Manoj Iyer wrote:
>> Right, without the patch I get..
>>
>> [   52.526665] mmc0: new SDHC card at address e624
>> [   52.571228] mmcblk0: mmc0:e624 SD16G 14.8 GiB
>> [   52.591071] mmcblk0: retrying using single block read
>> [   52.593105] mmcblk0: error -84 transferring data, sector 0, nr 8,
>> card status 0x900
>> [   52.593109] end_request: I/O error, dev mmcblk0, sector 0
>> [   52.594594] mmcblk0: error -84 transferring data, sector 1, nr 7,
>> card status 0x900
>> [   52.594604] end_request: I/O error, dev mmcblk0, sector 1
>> [   52.602893] quiet_error: 24 callbacks suppressed
>> [   52.602902] Buffer I/O error on device mmcblk0, logical block 0
>> [   52.605349] ldm_validate_partition_table(): Disk read failed.
>> [   52.605384] Dev mmcblk0: unable to read RDB block 0
>> [   52.607729]  mmcblk0: unable to read partition table
>> u@u:~$
>>
>> So, I cannot generate any comparison data with this SD card.
>
> I see, thanks.  So we're lacking any data on what speed the card would
> normally provide.  Perhaps you could try that card on a different
> controller, just so we're able to see whether it's usually possible
> to get closer to 45M/sec with it?
>
> I think I'll take your patch as-is for 3.1 -- since if there is a
> performance degradation, it's on cards that simply don't work at all
> right now -- and if you're able to work on a followup patch that only
> performs the clock-lowering after the first error, I think that'd be a
> handy patch to have around.  Does that sound good?
>
> Thanks!
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
--8323329-472274656-1311024371=:1677--
