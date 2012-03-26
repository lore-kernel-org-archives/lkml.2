Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab2CZLeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 07:34:14 -0400
Received: from mta109.odn.ne.jp ([143.90.14.72]:33909 "EHLO cmta109.odn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365Ab2CZLeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 07:34:13 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Mar 2012 07:34:12 EDT
Message-ID: <4F70527A.4000005@world.odn.ne.jp>
Date: Mon, 26 Mar 2012 20:26:50 +0900
From: "ANEZAKI, Akira" <blackfire@world.odn.ne.jp>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Gwendal Grignou <gwendal@google.com>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Fwd: libata-pmp patch for 3.2.x and later for eSATA Port Multiplier
 Sil3726
References: <4F5ECD06.3000608@yahoo.co.jp> <4F5F7C4C.7080800@teksavvy.com> <4F662AFB.9050106@yahoo.co.jp> <CAMHSBOWg+rxxrVjf05r1tYDpW1S75XzdrLQ+U8TrjC9okRYtuA@mail.gmail.com> <4F6AAC37.7040907@yahoo.co.jp> <4F6B30D9.2070805@yahoo.co.jp> <CAMHSBOVD4wAtwAravVkDjyWV+Nwtuybt=yae=26PcGxxirw=Lg@mail.gmail.com> <4F6B679C.60004@yahoo.co.jp> <CAMHSBOWDYyLRREZNGqhBtvF_gSrvB-b=PVx3qULCqpc7yeJCcQ@mail.gmail.com> <4F6C1AE5.5060405@yahoo.co.jp> <CAMHSBOXuX1U8uPyN136AQ_LRW85Ex8EUu1-_hdBqnSMtdmg+0Q@mail.gmail.com> <4F6C4967.80309@yahoo.co.jp> <4F6E728A.3090203@yahoo.co.jp> <CAMHSBOVtj8pXVtSK7qUmzSzXTCJWTK6-m7ZY6TB3gj-dT70ptw@mail.gmail.com> <4F6FBB3E.8060409@yahoo.co.jp> <4F6FD4CD.5040608@yahoo.co.jp> <4F703BEB.1040309@yahoo.co.jp>
In-Reply-To: <4F703BEB.1040309@yahoo.co.jp>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Gwendal,

I got a log that failed to power cycle boot on the PC with 2PMPs. All
HDDs weren't use JM20330.

All HDDs were detected and attached. But root RAID is not built. So, the
boot failed. Next rebooting was successful.

The next power cycle had problem. Root RAID, etc. were built only one
partition.

These RAIDs are composed only with PC internal. PMPs don't matter.
I think it very strange. Maybe there is a bug, SRST might trigger the
problem. Of course, 3.1.x driver works fine.

Best Regards,
Akira

(2012/03/26 18:50), ANEZAKI, Akira wrote:
> Hello Gwendal,
> 
> (2012/03/26 11:30), ANEZAKI, Akira wrote:
>> Hello Gwendal,
>>
>> (2012/03/26 09:41), ANEZAKI, Akira wrote:
>>
>>>> If possible, could you switch 2 of the 4 enclosures [with their disks]
>>>> that fails to the port controlled by the Sil3132 controller, reboot
>>>> the machine with all its 30 drives and see if the failures follow the
>>>> controller or the enclosure.
>>>
>>> Yes, I will do it as soon as possible. (Sorry, resyncing is runnning now.)

--- 3.2.10 power cycle log ( unpatched ) ---
   :
> [    0.000000] Linux version 3.2.10-3.fc16.i686.PAE (mockbuild@x86-02.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 15 20:37:01 UTC 2012
   :
> [    1.109107] ata1: SATA max UDMA/133 cmd 0x9000 ctl 0x8c00 bmdma 0x8480 irq 19
> [    1.109111] ata2: SATA max UDMA/133 cmd 0x8880 ctl 0x8800 bmdma 0x8488 irq 19
> [    1.110534] ata3: SATA max UDMA/133 cmd 0x8000 ctl 0x7c00 bmdma 0x7480 irq 19
> [    1.110538] ata4: SATA max UDMA/133 cmd 0x7880 ctl 0x7800 bmdma 0x7488 irq 19
> [    1.425771] ata3: SATA link down (SStatus 0 SControl 300)
> [    1.565064] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    1.565168] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    1.576064] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.580317] ata4.00: ATA-7: Maxtor 7V250F0, VA111630, max UDMA/133
> [    1.580321] ata4.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    1.587163] ata4.00: configured for UDMA/133
> [    1.608220] ata2.00: ATA-7: ST3320620AS, 3.AAJ, max UDMA/133
> [    1.608223] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    1.616082] ata1.00: ATA-7: ST3320620AS, 3.AAJ, max UDMA/133
> [    1.616086] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    1.683190] ata2.00: configured for UDMA/133
> [    1.691047] ata1.00: configured for UDMA/133
> [    2.062830] ata5: SATA max UDMA/100 host m128@0xfe8ffc00 port 0xfe8f8000 irq 17
> [    2.062835] ata6: SATA max UDMA/100 host m128@0xfe8ffc00 port 0xfe8fa000 irq 17
> [    2.062948] ata7: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 16
> [    2.062952] ata8: PATA max UDMA/133 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 16
> [    2.065259] ata9: SATA max UDMA/100 host m128@0xfe9ffc00 port 0xfe9f8000 irq 18
> [    2.065263] ata10: SATA max UDMA/100 host m128@0xfe9ffc00 port 0xfe9fa000 irq 18
> [    2.217434] ata7.00: ATAPI: HL-DT-STDVD-RAM GSA-H58N, 1.03, max UDMA/66
> [    2.223422] ata7.00: configured for UDMA/66
> [    4.082034] ata5: SATA link down (SStatus 0 SControl 0)
> [    4.197035] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [    4.197372] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [    4.199141] ata9.00: hard resetting link
> [    4.537254] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [    4.537290] ata9.01: hard resetting link
> [    4.963015] ata9.01: softreset failed (SRST command error)
> [    5.073014] ata9.01: failed to read SCR 0 (Emask=0x1)
> [    5.073019] ata9.01: reset failed (errno=-85), retrying in 10 secs
> [    6.102041] ata6: SATA link down (SStatus 0 SControl 0)
> [   14.537112] ata9.01: reset failed, giving up
> [   14.537117] ata9.15: hard resetting link
> [   14.537120] ata9: controller in dubious state, performing PORT_RST
> [   16.691040] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   16.691389] ata9.00: hard resetting link
> [   17.029255] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   17.029290] ata9.01: hard resetting link
> [   17.367252] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   17.367287] ata9.02: hard resetting link
> [   17.683040] ata9.02: softreset failed (SRST command error)
> [   17.683099] ata9.02: failed to read SCR 0 (Emask=0x1)
> [   17.683103] ata9.02: reset failed (errno=-85), retrying in 10 secs
> [   27.367023] ata9.02: reset failed, giving up
> [   27.367028] ata9.15: hard resetting link
> [   29.488078] ata9.15: softreset failed (SRST command error)
> [   29.488082] ata9.15: reset failed (errno=-5), retrying in 8 secs
> [   37.367018] ata9.15: hard resetting link
> [   39.488071] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   39.488077] ata9.15: PMP revalidation failed (errno=-19)
> [   44.488012] ata9.15: hard resetting link
> [   46.620040] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   46.620470] ata9.00: hard resetting link
> [   46.958247] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   46.958285] ata9.01: hard resetting link
> [   47.296247] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   47.296284] ata9.02: hard resetting link
> [   47.634249] ata9.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   47.634286] ata9.03: hard resetting link
> [   48.060017] ata9.03: softreset failed (SRST command error)
> [   48.060035] ata9.03: failed to read SCR 0 (Emask=0x40)
> [   48.060038] ata9.03: reset failed (errno=-85), retrying in 10 secs
> [   57.634037] ata9.03: reset failed, giving up
> [   57.634041] ata9.15: hard resetting link
> [   57.634043] ata9: controller in dubious state, performing PORT_RST
> [   59.788039] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   59.788377] ata9.00: hard resetting link
> [   60.126253] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   60.126289] ata9.01: hard resetting link
> [   60.464250] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   60.464285] ata9.02: hard resetting link
> [   60.802251] ata9.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   60.802286] ata9.03: hard resetting link
> [   61.140252] ata9.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   61.140287] ata9.04: hard resetting link
> [   61.445390] ata9.04: SATA link down (SStatus 0 SControl 320)
> [   61.445457] ata9.05: hard resetting link
> [   61.750359] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [   61.779136] ata9.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
> [   61.779141] ata9.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [   61.821129] ata9.00: configured for UDMA/100
> [   61.849775] ata9.01: ATA-8: ST31500341AS, CC1H, max UDMA/133
> [   61.849779] ata9.01: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   61.891640] ata9.01: configured for UDMA/100
> [   61.920328] ata9.02: ATA-8: ST31500341AS, CC1H, max UDMA/133
> [   61.920333] ata9.02: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   61.962282] ata9.02: configured for UDMA/100
> [   61.990999] ata9.03: ATA-8: ST31500341AS, CC1H, max UDMA/133
> [   61.991009] ata9.03: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   62.032997] ata9.03: configured for UDMA/100
> [   62.033088] ata9: EH complete
> [   64.167041] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   64.167363] ata10.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [   64.169254] ata10.00: hard resetting link
> [   64.573260] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   64.573299] ata10.01: hard resetting link
> [   64.999017] ata10.01: softreset failed (SRST command error)
> [   64.999034] ata10.01: failed to read SCR 0 (Emask=0x40)
> [   64.999038] ata10.01: reset failed (errno=-85), retrying in 10 secs
> [   74.573049] ata10.01: reset failed, giving up
> [   74.573058] ata10.15: hard resetting link
> [   74.573061] ata10: controller in dubious state, performing PORT_RST
> [   76.727039] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   76.727371] ata10.00: hard resetting link
> [   77.131252] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   77.131287] ata10.01: hard resetting link
> [   77.535261] ata10.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   77.535297] ata10.02: hard resetting link
> [   77.851041] ata10.02: softreset failed (SRST command error)
> [   77.961014] ata10.02: failed to read SCR 0 (Emask=0x1)
> [   77.961018] ata10.02: reset failed (errno=-85), retrying in 10 secs
> [   87.535028] ata10.02: reset failed, giving up
> [   87.535033] ata10.15: hard resetting link
> [   87.535035] ata10: controller in dubious state, performing PORT_RST
> [   89.689041] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   89.689414] ata10.00: hard resetting link
> [   90.093265] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   90.093303] ata10.01: hard resetting link
> [   90.497259] ata10.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   90.497296] ata10.02: hard resetting link
> [   90.901259] ata10.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   90.901296] ata10.03: hard resetting link
> [   91.327009] ata10.03: softreset failed (SRST command error)
> [   91.327024] ata10.03: failed to read SCR 0 (Emask=0x40)
> [   91.327026] ata10.03: reset failed (errno=-85), retrying in 10 secs
> [  100.901043] ata10.03: reset failed, giving up
> [  100.901048] ata10.15: hard resetting link
> [  100.901051] ata10: controller in dubious state, performing PORT_RST
> [  103.055046] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  103.055433] ata10.00: hard resetting link
> [  103.459260] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [  103.459296] ata10.01: hard resetting link
> [  103.863260] ata10.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  103.863296] ata10.02: hard resetting link
> [  104.267287] ata10.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  104.267332] ata10.03: hard resetting link
> [  104.671261] ata10.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  104.671297] ata10.04: hard resetting link
> [  104.976391] ata10.04: SATA link down (SStatus 0 SControl 320)
> [  104.976458] ata10.05: hard resetting link
> [  105.281363] ata10.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  105.282235] ata10.00: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [  105.282240] ata10.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [  105.283269] ata10.00: configured for UDMA/100
> [  105.303836] ata10.01: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [  105.303840] ata10.01: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [  105.304715] ata10.01: configured for UDMA/100
> [  105.319063] ata10.02: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [  105.319067] ata10.02: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [  105.319948] ata10.02: configured for UDMA/100
> [  105.333306] ata10.03: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [  105.333310] ata10.03: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [  105.334189] ata10.03: configured for UDMA/100
> [  105.334259] ata10: EH complete
   :
> [  105.366782] md/raid1:md0: active with 2 out of 2 mirrors
> [  105.366819] md0: detected capacity change from 0 to 314507264
> [  105.385841]  md0:
   :
> [  140.072536] dracut Warning: No root device "block:/dev/disk/by-uuid/773cb4b3-4bb0-4705-b494-08cb9c2b5d73" found
------

All HDDs are detected and attached. But root RAID was not built. And
boot failed.

--- 3.2.10 power cycle with RAID error ( unpatched ) ---
   :
> [    0.000000] Linux version 3.2.10-3.fc16.i686.PAE (mockbuild@x86-02.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 15 20:37:01 UTC 2012
   :
> [    1.110108] ata1: SATA max UDMA/133 cmd 0x9000 ctl 0x8c00 bmdma 0x8480 irq 19
> [    1.110112] ata2: SATA max UDMA/133 cmd 0x8880 ctl 0x8800 bmdma 0x8488 irq 19
> [    1.111539] ata3: SATA max UDMA/133 cmd 0x8000 ctl 0x7c00 bmdma 0x7480 irq 19
> [    1.111543] ata4: SATA max UDMA/133 cmd 0x7880 ctl 0x7800 bmdma 0x7488 irq 19
> [    1.426760] ata3: SATA link down (SStatus 0 SControl 300)
> [    1.566064] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    1.566167] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    1.577063] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.581172] ata4.00: ATA-7: Maxtor 7V250F0, VA111630, max UDMA/133
> [    1.581175] ata4.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    1.588394] ata4.00: configured for UDMA/133
> [    1.609231] ata1.00: ATA-7: ST3320620AS, 3.AAJ, max UDMA/133
> [    1.609235] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    1.614032] ata2.00: ATA-7: ST3320620AS, 3.AAJ, max UDMA/133
> [    1.614037] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    1.684197] ata1.00: configured for UDMA/133
> [    1.688994] ata2.00: configured for UDMA/133
> [    2.064237] ata5: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 16
> [    2.064240] ata6: PATA max UDMA/133 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 16
> [    2.065434] ata7: SATA max UDMA/100 host m128@0xfe8ffc00 port 0xfe8f8000 irq 17
> [    2.065438] ata8: SATA max UDMA/100 host m128@0xfe8ffc00 port 0xfe8fa000 irq 17
> [    2.069205] ata9: SATA max UDMA/100 host m128@0xfe9ffc00 port 0xfe9f8000 irq 18
> [    2.069210] ata10: SATA max UDMA/100 host m128@0xfe9ffc00 port 0xfe9fa000 irq 18
> [    2.218490] ata5.00: ATAPI: HL-DT-STDVD-RAM GSA-H58N, 1.03, max UDMA/66
> [    2.224448] ata5.00: configured for UDMA/66
> [    4.085035] ata7: SATA link down (SStatus 0 SControl 0)
> [    4.201038] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [    4.201371] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [    4.204304] ata9.00: hard resetting link
> [    4.542250] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [    4.542289] ata9.01: hard resetting link
> [    4.968018] ata9.01: softreset failed (SRST command error)
> [    4.968036] ata9.01: failed to read SCR 0 (Emask=0x40)
> [    4.968039] ata9.01: reset failed (errno=-85), retrying in 10 secs
> [    6.105031] ata8: SATA link down (SStatus 0 SControl 0)
> [   14.542045] ata9.01: reset failed, giving up
> [   14.542050] ata9.15: hard resetting link
> [   14.542053] ata9: controller in dubious state, performing PORT_RST
> [   16.696039] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   16.696373] ata9.00: hard resetting link
> [   17.034255] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   17.034291] ata9.01: hard resetting link
> [   17.372252] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   17.372288] ata9.02: hard resetting link
> [   17.798016] ata9.02: softreset failed (SRST command error)
> [   17.908018] ata9.02: failed to read SCR 0 (Emask=0x1)
> [   17.908022] ata9.02: reset failed (errno=-85), retrying in 10 secs
> [   27.372093] ata9.02: reset failed, giving up
> [   27.372097] ata9.15: hard resetting link
> [   27.372100] ata9: controller in dubious state, performing PORT_RST
> [   29.526040] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   29.526371] ata9.00: hard resetting link
> [   29.864252] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   29.864289] ata9.01: hard resetting link
> [   30.202250] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   30.202287] ata9.02: hard resetting link
> [   30.540251] ata9.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   30.540289] ata9.03: hard resetting link
> [   30.966013] ata9.03: softreset failed (SRST command error)
> [   31.076018] ata9.03: failed to read SCR 0 (Emask=0x1)
> [   31.076022] ata9.03: reset failed (errno=-85), retrying in 10 secs
> [   40.540022] ata9.03: reset failed, giving up
> [   40.540027] ata9.15: hard resetting link
> [   40.540029] ata9: controller in dubious state, performing PORT_RST
> [   42.694040] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   42.694389] ata9.00: hard resetting link
> [   43.032252] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   43.032287] ata9.01: hard resetting link
> [   43.370251] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   43.370286] ata9.02: hard resetting link
> [   43.708250] ata9.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   43.708286] ata9.03: hard resetting link
> [   44.046253] ata9.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   44.046289] ata9.04: hard resetting link
> [   44.351390] ata9.04: SATA link down (SStatus 0 SControl 320)
> [   44.351457] ata9.05: hard resetting link
> [   44.656361] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [   44.685158] ata9.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
> [   44.685163] ata9.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [   44.727185] ata9.00: configured for UDMA/100
> [   44.755818] ata9.01: ATA-8: ST31500341AS, CC1H, max UDMA/133
> [   44.755822] ata9.01: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   44.797689] ata9.01: configured for UDMA/100
> [   44.826404] ata9.02: ATA-8: ST31500341AS, CC1H, max UDMA/133
> [   44.826409] ata9.02: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   44.868366] ata9.02: configured for UDMA/100
> [   44.897084] ata9.03: ATA-8: ST31500341AS, CC1H, max UDMA/133
> [   44.897089] ata9.03: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   44.939073] ata9.03: configured for UDMA/100
> [   44.939152] ata9: EH complete
> [   47.072046] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   47.072428] ata10.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [   47.075710] ata10.00: hard resetting link
> [   47.479256] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   47.479296] ata10.01: hard resetting link
> [   47.905017] ata10.01: softreset failed (SRST command error)
> [   47.905035] ata10.01: failed to read SCR 0 (Emask=0x40)
> [   47.905039] ata10.01: reset failed (errno=-85), retrying in 10 secs
> [   57.479018] ata10.01: reset failed, giving up
> [   57.479023] ata10.15: hard resetting link
> [   57.479026] ata10: controller in dubious state, performing PORT_RST
> [   59.633039] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   59.633480] ata10.00: hard resetting link
> [   60.037260] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   60.037296] ata10.01: hard resetting link
> [   60.441258] ata10.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   60.441293] ata10.02: hard resetting link
> [   60.867016] ata10.02: softreset failed (SRST command error)
> [   60.977018] ata10.02: failed to read SCR 0 (Emask=0x1)
> [   60.977022] ata10.02: reset failed (errno=-85), retrying in 10 secs
> [   70.441017] ata10.02: reset failed, giving up
> [   70.441023] ata10.15: hard resetting link
> [   70.441026] ata10: controller in dubious state, performing PORT_RST
> [   72.595047] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   72.595436] ata10.00: hard resetting link
> [   72.999257] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   72.999295] ata10.01: hard resetting link
> [   73.403258] ata10.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   73.403296] ata10.02: hard resetting link
> [   73.807256] ata10.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   73.807293] ata10.03: hard resetting link
> [   74.233017] ata10.03: softreset failed (SRST command error)
> [   74.343014] ata10.03: failed to read SCR 0 (Emask=0x1)
> [   74.343018] ata10.03: reset failed (errno=-85), retrying in 10 secs
> [   83.807022] ata10.03: reset failed, giving up
> [   83.807027] ata10.15: hard resetting link
> [   83.807030] ata10: controller in dubious state, performing PORT_RST
> [   85.961042] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   85.961498] ata10.00: hard resetting link
> [   86.365267] ata10.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   86.365303] ata10.01: hard resetting link
> [   86.769251] ata10.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   86.769288] ata10.02: hard resetting link
> [   87.173252] ata10.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   87.173287] ata10.03: hard resetting link
> [   87.577251] ata10.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   87.577286] ata10.04: hard resetting link
> [   87.882390] ata10.04: SATA link down (SStatus 0 SControl 320)
> [   87.882457] ata10.05: hard resetting link
> [   88.187364] ata10.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [   88.188237] ata10.00: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [   88.188241] ata10.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [   88.189269] ata10.00: configured for UDMA/100
> [   88.210802] ata10.01: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [   88.210807] ata10.01: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   88.211684] ata10.01: configured for UDMA/100
> [   88.231774] ata10.02: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [   88.231779] ata10.02: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   88.232656] ata10.02: configured for UDMA/100
> [   88.242663] ata10.03: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [   88.242668] ata10.03: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   88.243540] ata10.03: configured for UDMA/100
> [   88.243611] ata10: EH complete
   :
> [   88.279749] md/raid1:md0: active with 2 out of 2 mirrors
> [   88.279779] md0: detected capacity change from 0 to 314507264
> [   88.298379]  md0:
   :
> [  100.905944] md/raid1:md1: active with 1 out of 2 mirrors
> [  100.905973] md1: detected capacity change from 0 to 311163576320
> [  100.908115] dracut: mdadm: started /dev/md1
   :
> [  100.922165] md/raid1:md2: active with 1 out of 2 mirrors
> [  100.922198] md2: detected capacity change from 0 to 8589869056
> [  100.924335] dracut: mdadm: started /dev/md2
   :
> [  123.802802] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> [  123.821298] NFSD: starting 90-second grace period
   :
------

All HDDs were detected and attached. But md1 and md2 were build with
single partition.
