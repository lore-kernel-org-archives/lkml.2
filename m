Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030253Ab2CVMwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 08:52:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64342 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab2CVMv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 08:51:57 -0400
MIME-Version: 1.0
In-Reply-To: <4F6AAC37.7040907@yahoo.co.jp>
References: <4F5ECD06.3000608@yahoo.co.jp>
	<4F5F7C4C.7080800@teksavvy.com>
	<4F662AFB.9050106@yahoo.co.jp>
	<CAMHSBOWg+rxxrVjf05r1tYDpW1S75XzdrLQ+U8TrjC9okRYtuA@mail.gmail.com>
	<4F6AAC37.7040907@yahoo.co.jp>
Date: Thu, 22 Mar 2012 05:51:56 -0700
Message-ID: <CAMHSBOXXKHmDHdQx1CFDfLi6gZNGU4snVxGejPF15t=mxceF8w@mail.gmail.com>
Subject: Re: Fwd: libata-pmp patch for 3.2.x and later for eSATA Port
 Multiplier Sil3726
From: Gwendal Grignou <gwendal@google.com>
To: "ANEZAKI, Akira" <fireblade1230@yahoo.co.jp>
Cc: "IDE/ATA development list" <linux-ide@vger.kernel.org>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 9:36 PM, ANEZAKI, Akira
<fireblade1230@yahoo.co.jp> wrote:
> Hello Gwendal,
>
> (2012/03/21 18:09), Gwendal Grignou wrote:
>
>> - When you do the test between 3.1 and 3.2, do you cold boot the
>> machine every time?
>
> Yes, I did. I switched off main switch ( AC power line side. PC,
> display, all HDD boxes, etc. ) and wait more than 10 sec.
>
> On the PC that has 6 PMPs with 38 HDDs ( and 2 non PMP HDDs ) :
> 3.1 -- I can boot every time both of warm reboot and cold boot.
> 3.2 -- I can't boot at all.
> 3.2 with my patch -- I can boot every time both of warm reboot and cold
> boot.
>
> On the PC that has 2 PMPs with 8 HDDs ( and 2 non PMP HDDs ) :
> 3.1 -- I can boot smoothly both of warm reboot and cold boot.
> 3.2 -- I can boot but slowly at the cold boot. Sometimes I cannot boot
> at the power cycle but I can't get log until now. And when boot for
> power cycle is succeeded, sometimes metadatas for RAIDs are broken.
> 3.2 with my patch -- I can boot smoothly both of warm reboot and power
> cycle.
>
>> - does the problem with 3.2 happens when you just reboot the machine
>> instead of cold booting?
> About the PC with 6 PMPs, I can't boot at all. But about the PC with 2
> PMPs, usually it looks no problems.
>
>> Looking at your log, it seems you are using old drives that take a
>> long time to spinup.
>
> Both logs are results of unpatched driver. Pathced or 3.1.x driver boots
> smoothly.
> The log I sent first is on the PC that has 6 PMPs with 38 HDDs. It can't
> boot.
> The log I sent second is on the PC that has 2 PMPs with 8 HDDs. Usually
> it can boot but takes longer time. 3.1.x or patched driver can boot
> smoothly.
>
>> We can see there are progress between 3.2.3 and 3.2.9:
>> In 3.2.3, we fail with qc_timeout and some drives are disabled.
>> In 3.2.9, we take time to spinup the drives, but finally all are found.
>
> The log I sent first is from 3.2.9 kernel with 6 PMPs and 38 HDDs.
> The log I sent second is from 3.2.10 kernel with 2 PMPs and 8 HDDs.
> I thought that it may be a sample for usual case so I sent it. I'm sorry
> because it made you confused.
>
>> The patch you proposed seems to only have been tested with warm
>> reboot, not power cycle.
>
> I test power cycle first. I sent original kernel logs only to explain
> the problem. Logs of patched kernel are attached below.
> 3.2.x kernel sometimes breaks metadata and I have to fix them. I feel it
> strange and cannot understand that the kernel sometimes breaks
> metadatas/superblocks of RAIDs/file systems those don't include any HDDs
> those don't connected to any PMP.
> On PC that has 6 PMPs with 38 HDDs, the original 3.2.x kernel usually
> breaks metadata and I have to fix the problems before next test. So each
> test takes very long time ( a few days ).
>
>> Please see http://www.spinics.net/lists/linux-ide/msg41699.html and
>> http://www.spinics.net/lists/linux-ide/msg41700.html for an
>> explanation why this patch is need.
>
> Because:
> 1. kernel 3.1.x and before, the driver works fine.
> 2. From 3.2.x, booting becomes slow in power cycle.
> 3. From 3.2.x, the driver sometimes fails to boot. and the driver makes
> impossible to boot for some PCs.
>
> The logs below are from a PC that has 2 PMPs with 8 HDDs.
>
> --- 3.2.10 power cycle log ( not patched ) ---
>   :
>> [    0.000000] Linux version 3.2.10-3.fc16.i686.PAE (mockbuild@x86-02.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 15 20:37:01 UTC 2012
>   :
>> [    2.055030] ata9: SATA max UDMA/100 host m128@0xfe9ffc00 port 0xfe9f8000 irq 18
>   :
>> [    4.187038] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [    4.187382] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [    4.189167] ata9.00: hard resetting link
>> [    4.527250] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [    4.527288] ata9.01: hard resetting link
>> [    4.953017] ata9.01: softreset failed (SRST command error)
>> [    5.063019] ata9.01: failed to read SCR 0 (Emask=0x1)
>> [    5.063024] ata9.01: reset failed (errno=-85), retrying in 10 secs
>> [   14.527034] ata9.01: reset failed, giving up
>> [   14.527039] ata9.15: hard resetting link
>> [   14.527042] ata9: controller in dubious state, performing PORT_RST
>> [   16.681042] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   16.681425] ata9.00: hard resetting link
>> [   17.019250] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   17.019288] ata9.01: hard resetting link
>> [   17.357250] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   17.357288] ata9.02: hard resetting link
>> [   17.783013] ata9.02: softreset failed (SRST command error)
>> [   17.783032] ata9.02: failed to read SCR 0 (Emask=0x40)
>> [   17.783035] ata9.02: reset failed (errno=-85), retrying in 10 secs
>> [   27.357085] ata9.02: reset failed, giving up
>> [   27.357089] ata9.15: hard resetting link
>> [   27.357092] ata9: controller in dubious state, performing PORT_RST
>> [   29.511060] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   29.511428] ata9.00: hard resetting link
>> [   29.849253] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   29.849289] ata9.01: hard resetting link
>> [   30.187252] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   30.187287] ata9.02: hard resetting link
>> [   30.525253] ata9.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   30.525288] ata9.03: hard resetting link
>> [   30.951013] ata9.03: softreset failed (SRST command error)
>> [   31.061019] ata9.03: failed to read SCR 0 (Emask=0x1)
>> [   31.061023] ata9.03: reset failed (errno=-85), retrying in 10 secs
>> [   40.525046] ata9.03: reset failed, giving up
>> [   40.525050] ata9.15: hard resetting link
>> [   40.525053] ata9: controller in dubious state, performing PORT_RST
>> [   42.679035] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   42.679419] ata9.00: hard resetting link
>> [   43.017251] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   43.017289] ata9.01: hard resetting link
>> [   43.355251] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   43.355288] ata9.02: hard resetting link
>> [   43.693249] ata9.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   43.693286] ata9.03: hard resetting link
>> [   44.031249] ata9.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   44.031286] ata9.04: hard resetting link
>> [   44.336389] ata9.04: SATA link down (SStatus 0 SControl 320)
>> [   44.336456] ata9.05: hard resetting link
>> [   44.641358] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   44.670114] ata9.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [   44.670119] ata9.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
>> [   44.712074] ata9.00: configured for UDMA/100
>> [   44.740733] ata9.01: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [   44.740737] ata9.01: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [   44.782660] ata9.01: configured for UDMA/100
>> [   44.811357] ata9.02: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [   44.811361] ata9.02: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [   44.853315] ata9.02: configured for UDMA/100
>> [   44.882014] ata9.03: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [   44.882019] ata9.03: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [   44.923982] ata9.03: configured for UDMA/100
>> [   44.924061] ata9: EH complete
>   :
>> [  109.607470] fedora-storage-init[1315]: [  OK  ]
>> [  109.781735] lvm[1322]: No volume groups found
>   :
>> [  124.179756] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
>> [  124.268048] NFSD: starting 90-second grace period
>   :
This is the expected behavior. For instance, At 5.063024, because the
drive at ata9.01 has not fully spun up yet, SRST fails and we wait 10s
to try again, while still in the initialization part of libata.
Also you notice that disks are spining up one after the other.
>
> --- 3.2.10 warm reset log ( not patched ) ---
>   :
>> [    0.000000] Linux version 3.2.10-3.fc16.i686.PAE (mockbuild@x86-02.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 15 20:37:01 UTC 2012
>   :
>> [    2.048967] ata9: SATA max UDMA/100 host m128@0xfe9ffc00 port 0xfe9f8000 irq 18
>   :
>> [    4.181039] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [    4.181374] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [    4.184153] ata9.00: hard resetting link
>> [    4.522255] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [    4.522292] ata9.01: hard resetting link
>> [    4.860255] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    4.860290] ata9.02: hard resetting link
>> [    5.198254] ata9.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    5.198290] ata9.03: hard resetting link
>> [    5.536254] ata9.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    5.536289] ata9.04: hard resetting link
>> [    5.841392] ata9.04: SATA link down (SStatus 0 SControl 320)
>> [    5.841459] ata9.05: hard resetting link
>> [    6.146363] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [    6.175178] ata9.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [    6.175183] ata9.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
>> [    6.217150] ata9.00: configured for UDMA/100
>> [    6.245808] ata9.01: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [    6.245813] ata9.01: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [    6.287734] ata9.01: configured for UDMA/100
>> [    6.316420] ata9.02: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [    6.316424] ata9.02: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [    6.358401] ata9.02: configured for UDMA/100
>> [    6.387135] ata9.03: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [    6.387140] ata9.03: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [    6.429104] ata9.03: configured for UDMA/100
>> [    6.429184] ata9: EH complete
This is also a good behavior. All disks are already spinning, so the
system initializes the disks fast.
>   :
>> [   18.318618] fedora-storage-init[1080]: [  OK  ]
>> [   18.509550] lvm[1087]: No volume groups found
>   :
>> [   27.093615] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
>> [   27.327036] NFSD: starting 90-second grace period
>   :
> --------
>
> ---- 3.2.10 power cycle log ( patched ) ----
>   :
>> [    0.000000] Linux version 3.2.10-3.aa.fc16.i686.PAE (anezaki@server4) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 22 08:14:54 JST 2012
>   :
>> [    2.064607] ata9: SATA max UDMA/100 host m128@0xfe9ffc00 port 0xfe9f8000 irq 18
>   :
>> [    4.196041] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [    4.196368] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [    4.198669] ata9.00: hard resetting link
>> [    4.504366] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [    4.504402] ata9.01: hard resetting link
>> [    4.809359] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    4.809398] ata9.02: hard resetting link
>> [    5.114363] ata9.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    5.114399] ata9.03: hard resetting link
>> [    5.419359] ata9.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    5.419397] ata9.04: hard resetting link
>> [    5.724362] ata9.04: SATA link down (SStatus 0 SControl 320)
>> [    5.724429] ata9.05: hard resetting link
>> [    6.029365] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [    6.059901] ata9.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [    6.059906] ata9.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
>> [    6.101867] ata9.00: configured for UDMA/100
>> [    6.211019] ata9.01: failed to IDENTIFY (I/O error, err_mask=0x11)
1st problem: because the drive did not spin up yet, we can not send
command to it. The time we wait for the drives to spin up is not
deterministic, it depends on how long it takes to reset the port
multiplier and send hard reset to the ports.
>> [    6.211024] ata9.15: hard resetting link
>> [    6.211027] ata9: controller in dubious state, performing PORT_RST
>> [    8.365040] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [    8.365383] ata9.00: hard resetting link
>> [    8.670359] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [    9.809089] ata9.01: hard resetting link
>> [   10.114362] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   10.114400] ata9.02: hard resetting link
>> [   10.419408] ata9.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   10.419453] ata9.03: hard resetting link
>> [   10.724360] ata9.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   11.029024] ata9.05: hard resetting link
>> [   11.334363] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   11.405154] ata9.00: configured for UDMA/100
>> [   11.515017] ata9.01: failed to IDENTIFY (I/O error, err_mask=0x11)
We fail again, we have waited only ~5s.
You are lucky that the disk spin up in less than 10s, otherwise, the
third attempt would have failed and the drive would have been ignored.
>> [   11.515022] ata9.15: hard resetting link
>> [   11.515025] ata9: controller in dubious state, performing PORT_RST
>> [   13.669034] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   13.669416] ata9.00: hard resetting link
>> [   13.974361] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   15.114068] ata9.01: hard resetting link
>> [   15.419359] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   15.419397] ata9.02: hard resetting link
>> [   15.724362] ata9.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   15.724397] ata9.03: hard resetting link
>> [   16.029360] ata9.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   16.029398] ata9.04: hard resetting link
>> [   16.334360] ata9.04: SATA link down (SStatus 0 SControl 320)
>> [   16.334427] ata9.05: hard resetting link
>> [   16.639364] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   16.710155] ata9.00: configured for UDMA/100
>> [   16.738845] ata9.01: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [   16.738850] ata9.01: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [   16.780714] ata9.01: configured for UDMA/100
>> [   16.809457] ata9.02: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [   16.809462] ata9.02: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [   16.851386] ata9.02: configured for UDMA/100
>> [   16.880135] ata9.03: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [   16.880139] ata9.03: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [   16.922064] ata9.03: configured for UDMA/100
>> [   16.922144] ata9: EH complete
2nd problem: you may not see it, but without SRST, all the disks spun
up in parallel. This can be a problem with enclosure with small power
supply: the load on the 12V rail is mostly for the disk motors which
need a lot of energy at spin-up. With SRST, disks spin up one at a
time [staggered spin-up].
- problem with overloaded power supply are difficult to reproduce and debug.
- we can save by using smaller power supply with staggered disk spin-up.
>   :
>> [   38.783294] fedora-storage-init[1085]: [  OK  ]
>> [   38.924664] lvm[1092]: No volume groups found
>   :
>> [   47.241280] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
>> [   47.331673] NFSD: starting 90-second grace period
>   :
>
> --- 3.2.10 warm reboot log ( patched ) ---
>   :
>> [    0.000000] Linux version 3.2.10-3.aa.fc16.i686.PAE (anezaki@server4) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 22 08:14:54 JST 2012
>   :
>> [    2.053718] ata9: SATA max UDMA/100 host m128@0xfe9ffc00 port 0xfe9f8000 irq 18
>   :
>> [    4.185038] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [    4.185391] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [    4.188529] ata9.00: hard resetting link
>> [    4.493361] ata9.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [    4.493400] ata9.01: hard resetting link
>> [    4.798359] ata9.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    4.798395] ata9.02: hard resetting link
>> [    5.103358] ata9.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    5.103396] ata9.03: hard resetting link
>> [    5.408359] ata9.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    5.408395] ata9.04: hard resetting link
>> [    5.713358] ata9.04: SATA link down (SStatus 0 SControl 320)
>> [    5.713425] ata9.05: hard resetting link
>> [    6.018361] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [    6.048989] ata9.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [    6.048994] ata9.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
>> [    6.091016] ata9.00: configured for UDMA/100
>> [    6.119634] ata9.01: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [    6.119638] ata9.01: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [    6.161506] ata9.01: configured for UDMA/100
>> [    6.190229] ata9.02: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [    6.190233] ata9.02: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [    6.232186] ata9.02: configured for UDMA/100
>> [    6.260887] ata9.03: ATA-8: ST31500341AS, CC1H, max UDMA/133
>> [    6.260892] ata9.03: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [    6.302885] ata9.03: configured for UDMA/100
>> [    6.302963] ata9: EH complete
Same as unpatched.
>   :
>> [   17.439980] fedora-storage-init[1099]: [  OK  ]
>> [   17.615373] lvm[1106]: No volume groups found
>   :
>> [   25.864708] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
>> [   26.006311] NFSD: starting 90-second grace period
>   :
>
> ---------
>
> On the PC that has 6 PMPs and 38HDDs, the situation is terrible. But I
> have been fixing the broken RAID metadata and it will take long time.
> I'll send it later.
I still think unpatched 3.2.10 behaves as it should.
I hope you can deal with long cold boot init time.

Gwendal.
>
> Regards,
> Akira
