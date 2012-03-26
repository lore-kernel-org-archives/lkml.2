Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2CZBqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 21:46:55 -0400
Received: from mta103.odn.ne.jp ([143.90.14.143]:58701 "EHLO cmta103.odn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab2CZBqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 21:46:52 -0400
Message-ID: <4F6FCA89.9060807@yahoo.co.jp>
Date: Mon, 26 Mar 2012 10:46:49 +0900
From: "ANEZAKI, Akira" <fireblade1230@yahoo.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Gwendal Grignou <gwendal@google.com>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Fwd: libata-pmp patch for 3.2.x and later for eSATA Port Multiplier
 Sil3726
References: <4F5ECD06.3000608@yahoo.co.jp> <4F5F7C4C.7080800@teksavvy.com> <4F662AFB.9050106@yahoo.co.jp> <CAMHSBOWg+rxxrVjf05r1tYDpW1S75XzdrLQ+U8TrjC9okRYtuA@mail.gmail.com> <4F6AAC37.7040907@yahoo.co.jp> <4F6B30D9.2070805@yahoo.co.jp> <CAMHSBOVD4wAtwAravVkDjyWV+Nwtuybt=yae=26PcGxxirw=Lg@mail.gmail.com> <4F6B679C.60004@yahoo.co.jp> <CAMHSBOWDYyLRREZNGqhBtvF_gSrvB-b=PVx3qULCqpc7yeJCcQ@mail.gmail.com> <4F6C1AE5.5060405@yahoo.co.jp> <CAMHSBOXuX1U8uPyN136AQ_LRW85Ex8EUu1-_hdBqnSMtdmg+0Q@mail.gmail.com> <4F6C4967.80309@yahoo.co.jp> <4F6E728A.3090203@yahoo.co.jp> <CAMHSBOVtj8pXVtSK7qUmzSzXTCJWTK6-m7ZY6TB3gj-dT70ptw@mail.gmail.com> <4F6FBB3E.8060409@yahoo.co.jp>
In-Reply-To: <4F6FBB3E.8060409@yahoo.co.jp>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Gwendal,

I'm sorry for using the wrong e-mail address.

(2012/03/26 09:41), ANEZAKI, Akira wrote:
>> If possible, could you switch 2 of the 4 enclosures [with their disks]
>> that fails to the port controlled by the Sil3132 controller, reboot
>> the machine with all its 30 drives and see if the failures follow the
>> controller or the enclosure.
> 
> Yes, I will do it as soon as possible. (Sorry, resyncing is runnning now.)

I'm trying it but it isn't stable. Boot fails frequently in warm reboot.
When boot fails, I can only see a swap partition. So, I can get no logs.
I'll try little more.

I have attached the log of power cycle. Boot was successful. This log
contains all ata1 -- ata10 information.

I think that I have switched like this:
ata5 <--> ata7
ata6 <--> ata8

ata7,ata8 : 4+4=8 HDDs.
ata5,ata6,ata9,ata10 : 5+5+5+5=20 HDDs.

But from log,
ata5: 2 HDDs -- lost 3 HDDs.
ata6: 3 HDDs -- lost 2 HDDs.
ata7: 4 HDDs -- OK.
ata8: 4 HDDs -- OK.
ata9: 3 HDDs -- lost 2 HDDs.
ata10: 4 HDDs -- lost 1 HDD.

Thank you for your help.

Best Regards,
Akira

--- 3.2.10 power cycle log ( unpatched ) ---
   :
> [    0.000000] Linux version 3.2.10-3.fc16.i686.PAE (mockbuild@x86-02.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 15 20:37:01 UTC 2012
   :
> [    1.587669] ata1: SATA max UDMA/133 cmd 0xac00 ctl 0xa880 bmdma 0xa400 irq 19
> [    1.587674] ata2: SATA max UDMA/133 cmd 0xa800 ctl 0xa480 bmdma 0xa408 irq 19
> [    1.588676] ata3: SATA max UDMA/133 cmd 0x9c00 ctl 0x9880 bmdma 0x9400 irq 19
> [    1.588679] ata4: SATA max UDMA/133 cmd 0x9800 ctl 0x9480 bmdma 0x9408 irq 19
> [    1.905936] ata4: SATA link down (SStatus 0 SControl 300)
> [    2.056494] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    2.075617] ata3.00: ATAPI: HL-DT-ST DVDRAM GH22NS40, NL02, max UDMA/100
> [    2.097614] ata3.00: configured for UDMA/100
> [    2.210257] ata2.00: SATA link down (SStatus 0 SControl 300)
> [    2.210274] ata2.01: SATA link down (SStatus 0 SControl 300)
> [    2.349849] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.349866] ata1.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.356076] ata1.00: ATA-8: WDC WD10EADS-00M2B0, 01.00A01, max UDMA/133
> [    2.356083] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    2.356364] ata1.01: ATA-8: Hitachi HDS721010CLA332, JP4OA39C, max UDMA/133
> [    2.356370] ata1.01: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    2.360095] ata1.00: configured for UDMA/133
> [    2.366164] ata1.01: configured for UDMA/133
> [    2.704858] ata5: SATA max UDMA/100 host m128@0xfbeffc00 port 0xfbef8000 irq 18
> [    2.704863] ata6: SATA max UDMA/100 host m128@0xfbeffc00 port 0xfbefa000 irq 18
> [    2.707166] ata7: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff0000 irq 17
> [    2.707169] ata8: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff2000 irq 17
> [    2.707172] ata9: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff4000 irq 17
> [    2.707175] ata10: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff6000 irq 17
> [    4.832327] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [    4.832797] ata5.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [    4.834150] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [    4.834575] ata7.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [    4.835395] ata5.00: hard resetting link
> [    4.837802] ata7.00: hard resetting link
> [    5.152555] ata7.00: softreset failed (SRST command error)
> [    5.262339] ata7.00: failed to read SCR 0 (Emask=0x1)
> [    5.262344] ata7.00: reset failed (errno=-85), retrying in 10 secs
> [   14.815165] ata7.00: reset failed, giving up
> [   14.815171] ata7.15: hard resetting link
> [   14.815175] ata7: controller in dubious state, performing PORT_RST
> [   14.820175] ata5.00: softreset failed (timeout)
> [   16.964600] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   16.965001] ata7.00: hard resetting link
> [   17.367759] ata7.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   17.367814] ata7.01: hard resetting link
> [   17.682822] ata7.01: softreset failed (SRST command error)
> [   17.792567] ata7.01: failed to read SCR 0 (Emask=0x1)
> [   17.792573] ata7.01: reset failed (errno=-85), retrying in 10 secs
> [   17.813530] ata5.15: qc timeout (cmd 0xe4)
> [   17.813559] ata5.00: failed to read SCR 0 (Emask=0x5)
> [   17.813563] ata5.00: reset failed, giving up
> [   17.813568] ata5.15: hard resetting link
> [   19.940831] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   19.941484] ata5.00: hard resetting link
> [   27.345384] ata7.01: reset failed, giving up
> [   27.345390] ata7.15: hard resetting link
> [   27.345394] ata7: controller in dubious state, performing PORT_RST
> [   29.494623] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   29.495062] ata7.00: hard resetting link
> [   29.897955] ata7.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   29.897988] ata7.01: hard resetting link
> [   29.926685] ata5.00: softreset failed (timeout)
> [   30.301043] ata7.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   30.301100] ata7.02: hard resetting link
> [   30.616151] ata7.02: softreset failed (SRST command error)
> [   30.616227] ata7.02: failed to read SCR 0 (Emask=0x1)
> [   30.616233] ata7.02: reset failed (errno=-85), retrying in 10 secs
> [   32.920112] ata5.15: qc timeout (cmd 0xe4)
> [   32.920141] ata5.00: failed to read SCR 0 (Emask=0x5)
> [   32.920145] ata5.00: reset failed, giving up
> [   32.920150] ata5.15: hard resetting link
> [   35.047384] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   35.047933] ata5.00: hard resetting link
> [   40.278817] ata7.02: reset failed, giving up
> [   40.278823] ata7.15: hard resetting link
> [   42.395047] ata7.15: softreset failed (SRST command error)
> [   42.395052] ata7.15: reset failed (errno=-5), retrying in 8 secs
> [   45.033200] ata5.00: softreset failed (timeout)
> [   48.026551] ata5.15: qc timeout (cmd 0xe4)
> [   48.026580] ata5.00: failed to read SCR 0 (Emask=0x5)
> [   48.026584] ata5.00: reset failed, giving up
> [   48.026588] ata5.00: failed to recover link after 3 tries, disabling
> [   48.026593] ata5.15: hard resetting link
> [   50.153760] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   50.256590] ata7.15: hard resetting link
> [   50.458340] ata5.01: hard resetting link
> [   50.861391] ata5.01: link resume succeeded after 1 retries
> [   50.974034] ata5.01: softreset failed (SRST command error)
> [   50.974148] ata5.01: failed to read SCR 0 (Emask=0x1)
> [   50.974154] ata5.01: reset failed (errno=-85), retrying in 10 secs
> [   52.372952] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   52.372960] ata7.15: PMP revalidation failed (errno=-19)
> [   57.361873] ata7.15: hard resetting link
> [   59.489164] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   59.489750] ata7.00: hard resetting link
> [   59.892441] ata7.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   59.892475] ata7.01: hard resetting link
> [   60.295568] ata7.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   60.295601] ata7.02: hard resetting link
> [   60.436071] ata5.01: reset failed, giving up
> [   60.436077] ata5.15: hard resetting link
> [   60.698722] ata7.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   60.698778] ata7.03: hard resetting link
> [   61.123499] ata7.03: softreset failed (SRST command error)
> [   61.233263] ata7.03: failed to read SCR 0 (Emask=0x1)
> [   61.233269] ata7.03: reset failed (errno=-85), retrying in 10 secs
> [   62.552395] ata5.15: softreset failed (SRST command error)
> [   62.552400] ata5.15: reset failed (errno=-5), retrying in 8 secs
> [   70.414115] ata5.15: hard resetting link
> [   70.676320] ata7.03: reset failed, giving up
> [   70.676326] ata7.15: hard resetting link
> [   70.676330] ata7: controller in dubious state, performing PORT_RST
> [   72.530270] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   72.530278] ata5.15: PMP revalidation failed (errno=-19)
> [   72.825581] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   72.825989] ata7.00: hard resetting link
> [   73.228918] ata7.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   73.228973] ata7.01: hard resetting link
> [   73.632025] ata7.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   73.632059] ata7.02: hard resetting link
> [   74.035109] ata7.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   74.035164] ata7.03: hard resetting link
> [   74.438209] ata7.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   74.438265] ata7.04: hard resetting link
> [   74.742670] ata7.04: SATA link down (SStatus 0 SControl 320)
> [   74.742724] ata7.05: hard resetting link
> [   75.046967] ata7.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [   75.072685] ata7.00: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [   75.072692] ata7.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   75.073746] ata7.00: configured for UDMA/100
> [   75.092679] ata7.01: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [   75.092686] ata7.01: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   75.093818] ata7.01: configured for UDMA/100
> [   75.110657] ata7.02: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [   75.110663] ata7.02: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   75.111760] ata7.02: configured for UDMA/100
> [   75.121174] ata7.03: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [   75.121180] ata7.03: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   75.122307] ata7.03: configured for UDMA/100
> [   75.122376] ata7: EH complete
> [   77.519188] ata5.15: hard resetting link
> [   79.646506] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   79.951897] ata5.01: hard resetting link
> [   80.354972] ata5.01: link resume succeeded after 1 retries
> [   80.577379] ata5.01: softreset failed (SRST command error)
> [   80.577503] ata5.01: failed to read SCR 0 (Emask=0x1)
> [   80.577509] ata5.01: reset failed (errno=-85), retrying in 10 secs
> [   89.929712] ata5.01: reset failed, giving up
> [   89.929720] ata5.15: hard resetting link
> [   89.929723] ata5: controller in dubious state, performing PORT_RST
> [   92.078919] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   92.384345] ata5.01: hard resetting link
> [   92.787407] ata5.01: link resume succeeded after 1 retries
> [   93.009813] ata5.01: softreset failed (SRST command error)
> [   93.009946] ata5.01: failed to read SCR 0 (Emask=0x1)
> [   93.009951] ata5.01: reset failed (errno=-85), retrying in 10 secs
> [  102.362090] ata5.01: reset failed, giving up
> [  102.362095] ata5.01: failed to recover link after 3 tries, disabling
> [  102.362101] ata5.15: hard resetting link
> [  102.362105] ata5: controller in dubious state, performing PORT_RST
> [  104.511301] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  105.218826] ata5.01: link resume succeeded after 1 retries
> [  105.320733] ata5.02: hard resetting link
> [  105.723707] ata5.02: link resume succeeded after 1 retries
> [  105.858731] ata5.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  105.858773] ata5.03: hard resetting link
> [  106.261505] ata5.03: link resume succeeded after 1 retries
> [  106.396525] ata5.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  106.396584] ata5.04: hard resetting link
> [  106.799348] ata5.04: link resume succeeded after 1 retries
> [  106.934211] ata5.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  106.934270] ata5.05: hard resetting link
> [  107.238655] ata5.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  107.279217] ata5.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  107.279223] ata5.02: 625142448 sectors, multi 0: LBA48 
> [  107.279229] ata5.02: applying bridge limits
> [  107.337301] ata5.02: configured for UDMA/100
> [  107.374742] ata5.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  107.374748] ata5.03: 625142448 sectors, multi 0: LBA48 
> [  107.432823] ata5.03: configured for UDMA/100
> [  107.472369] ata5.04: ATA-7: ST3320620A, 3.AAC, max UDMA/100
> [  107.472375] ata5.04: 625142448 sectors, multi 0: LBA48 
> [  107.530476] ata5.04: configured for UDMA/100
> [  107.530550] ata5: EH complete
> [  109.659967] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  109.660428] ata6.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [  109.662404] ata6.00: hard resetting link
> [  119.646792] ata6.00: softreset failed (timeout)
> [  122.640137] ata6.15: qc timeout (cmd 0xe4)
> [  122.640166] ata6.00: failed to read SCR 0 (Emask=0x5)
> [  122.640170] ata6.00: reset failed, giving up
> [  122.640175] ata6.15: hard resetting link
> [  124.767465] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  124.767953] ata6.00: hard resetting link
> [  134.753239] ata6.00: softreset failed (timeout)
> [  137.746585] ata6.15: qc timeout (cmd 0xe4)
> [  137.746614] ata6.00: failed to read SCR 0 (Emask=0x5)
> [  137.746618] ata6.00: reset failed, giving up
> [  137.746623] ata6.15: hard resetting link
> [  139.873980] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  139.874664] ata6.00: hard resetting link
> [  149.859880] ata6.00: softreset failed (timeout)
> [  152.853256] ata6.15: qc timeout (cmd 0xe4)
> [  152.853285] ata6.00: failed to read SCR 0 (Emask=0x5)
> [  152.853289] ata6.00: reset failed, giving up
> [  152.853293] ata6.00: failed to recover link after 3 tries, disabling
> [  152.853298] ata6.15: hard resetting link
> [  154.980470] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  155.284894] ata6.01: hard resetting link
> [  155.687942] ata6.01: link resume succeeded after 1 retries
> [  155.822938] ata6.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  155.822997] ata6.02: hard resetting link
> [  156.225772] ata6.02: link resume succeeded after 1 retries
> [  156.448182] ata6.02: softreset failed (SRST command error)
> [  156.557938] ata6.02: failed to read SCR 0 (Emask=0x1)
> [  156.557944] ata6.02: reset failed (errno=-85), retrying in 10 secs
> [  165.800793] ata6.02: reset failed, giving up
> [  165.800800] ata6.15: hard resetting link
> [  165.800803] ata6: controller in dubious state, performing PORT_RST
> [  167.949758] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  168.255149] ata6.01: hard resetting link
> [  168.658188] ata6.01: link resume succeeded after 1 retries
> [  168.793185] ata6.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  168.793244] ata6.02: hard resetting link
> [  169.196018] ata6.02: link resume succeeded after 1 retries
> [  169.418428] ata6.02: softreset failed (SRST command error)
> [  169.528182] ata6.02: failed to read SCR 0 (Emask=0x1)
> [  169.528188] ata6.02: reset failed (errno=-85), retrying in 10 secs
> [  178.770689] ata6.02: reset failed, giving up
> [  178.770696] ata6.15: hard resetting link
> [  178.770699] ata6: controller in dubious state, performing PORT_RST
> [  180.919978] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  181.224464] ata6.01: hard resetting link
> [  181.627416] ata6.01: link resume succeeded after 1 retries
> [  181.762409] ata6.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  181.762468] ata6.02: hard resetting link
> [  182.165272] ata6.02: link resume succeeded after 1 retries
> [  182.387677] ata6.02: softreset failed (SRST command error)
> [  182.497428] ata6.02: failed to read SCR 0 (Emask=0x1)
> [  182.497434] ata6.02: reset failed (errno=-85), retrying in 10 secs
> [  191.739821] ata6.02: reset failed, giving up
> [  191.739826] ata6.02: failed to recover link after 3 tries, disabling
> [  191.739832] ata6.15: hard resetting link
> [  191.739836] ata6: controller in dubious state, performing PORT_RST
> [  193.889226] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  194.596707] ata6.02: link resume succeeded after 1 retries
> [  194.698516] ata6.01: hard resetting link
> [  195.101567] ata6.01: link resume succeeded after 1 retries
> [  195.236530] ata6.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  195.236590] ata6.03: hard resetting link
> [  195.639396] ata6.03: link resume succeeded after 1 retries
> [  195.818236] ata6.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  195.818295] ata6.04: hard resetting link
> [  196.221084] ata6.04: link resume succeeded after 1 retries
> [  196.356102] ata6.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  196.356161] ata6.05: hard resetting link
> [  196.660379] ata6.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  196.696157] ata6.01: ATA-7: ST3320620A, 3.AAC, max UDMA/100
> [  196.696163] ata6.01: 625142448 sectors, multi 0: LBA48 
> [  196.754273] ata6.01: configured for UDMA/100
> [  196.795365] ata6.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  196.795371] ata6.03: 625142448 sectors, multi 0: LBA48 
> [  196.853523] ata6.03: configured for UDMA/100
> [  196.899696] ata6.04: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  196.899703] ata6.04: 625142448 sectors, multi 0: LBA48 
> [  196.957871] ata6.04: configured for UDMA/100
> [  196.957946] ata6: EH complete
> [  199.090700] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  199.091128] ata8.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [  199.093812] ata8.00: hard resetting link
> [  199.431193] ata8.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [  199.431226] ata8.01: hard resetting link
> [  199.855996] ata8.01: softreset failed (SRST command error)
> [  199.856109] ata8.01: failed to read SCR 0 (Emask=0x1)
> [  199.856115] ata8.01: reset failed (errno=-85), retrying in 10 secs
> [  209.408935] ata8.01: reset failed, giving up
> [  209.408941] ata8.15: hard resetting link
> [  209.408945] ata8: controller in dubious state, performing PORT_RST
> [  211.558047] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  211.558450] ata8.00: hard resetting link
> [  211.895535] ata8.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [  211.895590] ata8.01: hard resetting link
> [  212.232771] ata8.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  212.232805] ata8.02: hard resetting link
> [  212.547832] ata8.02: softreset failed (SRST command error)
> [  212.547909] ata8.02: failed to read SCR 0 (Emask=0x1)
> [  212.547915] ata8.02: reset failed (errno=-85), retrying in 10 secs
> [  222.210538] ata8.02: reset failed, giving up
> [  222.210544] ata8.15: hard resetting link
> [  224.326768] ata8.15: softreset failed (SRST command error)
> [  224.326774] ata8.15: reset failed (errno=-5), retrying in 8 secs
> [  232.188262] ata8.15: hard resetting link
> [  234.304631] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  234.304639] ata8.15: PMP revalidation failed (errno=-19)
> [  239.293528] ata8.15: hard resetting link
> [  241.420828] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  241.421222] ata8.00: hard resetting link
> [  241.758372] ata8.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [  241.758428] ata8.01: hard resetting link
> [  242.095611] ata8.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  242.095666] ata8.02: hard resetting link
> [  242.432765] ata8.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  242.432799] ata8.03: hard resetting link
> [  242.747884] ata8.03: softreset failed (SRST command error)
> [  242.747943] ata8.03: failed to read SCR 0 (Emask=0x1)
> [  242.747948] ata8.03: reset failed (errno=-85), retrying in 10 secs
> [  252.410561] ata8.03: reset failed, giving up
> [  252.410567] ata8.15: hard resetting link
> [  254.526811] ata8.15: softreset failed (SRST command error)
> [  254.526817] ata8.15: reset failed (errno=-5), retrying in 8 secs
> [  262.388616] ata8.15: hard resetting link
> [  264.504672] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  264.504680] ata8.15: PMP revalidation failed (errno=-19)
> [  269.493568] ata8.15: hard resetting link
> [  271.620869] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  271.621541] ata8.00: hard resetting link
> [  271.959402] ata8.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [  271.959435] ata8.01: hard resetting link
> [  272.296658] ata8.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  272.296691] ata8.02: hard resetting link
> [  272.633838] ata8.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  272.633893] ata8.03: hard resetting link
> [  272.971197] ata8.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  272.971230] ata8.04: hard resetting link
> [  273.275495] ata8.04: SATA link down (SStatus 0 SControl 320)
> [  273.275549] ata8.05: hard resetting link
> [  273.579798] ata8.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  273.608607] ata8.00: ATA-8: ST31000333AS, SD15, max UDMA/133
> [  273.608613] ata8.00: 1953525168 sectors, multi 0: LBA48 NCQ (not used)
> [  273.608619] ata8.00: WARNING: device requires firmware update to be fully functional
> [  273.608623] ata8.00:          contact the vendor or visit http://ata.wiki.kernel.org
> [  273.650662] ata8.00: configured for UDMA/100
> [  273.679546] ata8.01: ATA-8: ST31000333AS, SD15, max UDMA/133
> [  273.679552] ata8.01: 1953525168 sectors, multi 0: LBA48 NCQ (not used)
> [  273.679559] ata8.01: WARNING: device requires firmware update to be fully functional
> [  273.679563] ata8.01:          contact the vendor or visit http://ata.wiki.kernel.org
> [  273.721651] ata8.01: configured for UDMA/100
> [  273.750504] ata8.02: ATA-8: ST31000333AS, SD15, max UDMA/133
> [  273.750510] ata8.02: 1953525168 sectors, multi 0: LBA48 NCQ (not used)
> [  273.750516] ata8.02: WARNING: device requires firmware update to be fully functional
> [  273.750520] ata8.02:          contact the vendor or visit http://ata.wiki.kernel.org
> [  273.792594] ata8.02: configured for UDMA/100
> [  273.821356] ata8.03: ATA-8: ST31000333AS, SD15, max UDMA/133
> [  273.821362] ata8.03: 1953525168 sectors, multi 0: LBA48 NCQ (not used)
> [  273.821368] ata8.03: WARNING: device requires firmware update to be fully functional
> [  273.821372] ata8.03:          contact the vendor or visit http://ata.wiki.kernel.org
> [  273.863400] ata8.03: configured for UDMA/100
> [  273.863467] ata8: EH complete
> [  275.994193] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  275.994784] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [  275.997485] ata9.00: hard resetting link
> [  285.984026] ata9.00: softreset failed (timeout)
> [  288.977472] ata9.15: qc timeout (cmd 0xe4)
> [  288.977488] ata9.00: failed to read SCR 0 (Emask=0x5)
> [  288.977492] ata9.00: reset failed, giving up
> [  288.977497] ata9.15: hard resetting link
> [  291.104604] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  291.105202] ata9.00: hard resetting link
> [  301.089450] ata9.00: softreset failed (timeout)
> [  304.082908] ata9.15: qc timeout (cmd 0xe4)
> [  304.082925] ata9.00: failed to read SCR 0 (Emask=0x5)
> [  304.082932] ata9.00: reset failed, giving up
> [  304.082938] ata9.15: hard resetting link
> [  306.210218] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  306.210717] ata9.00: hard resetting link
> [  316.194987] ata9.00: softreset failed (timeout)
> [  319.188348] ata9.15: qc timeout (cmd 0xe4)
> [  319.188365] ata9.00: failed to read SCR 0 (Emask=0x5)
> [  319.188369] ata9.00: reset failed, giving up
> [  319.188372] ata9.00: failed to recover link after 3 tries, disabling
> [  319.188378] ata9.15: hard resetting link
> [  321.315756] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  321.620191] ata9.01: hard resetting link
> [  322.023178] ata9.01: link resume succeeded after 1 retries
> [  322.158126] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  322.158160] ata9.02: hard resetting link
> [  322.560976] ata9.02: link resume succeeded after 1 retries
> [  322.695900] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  322.695934] ata9.03: hard resetting link
> [  323.098788] ata9.03: link resume succeeded after 1 retries
> [  323.233757] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  323.233790] ata9.04: hard resetting link
> [  323.636557] ata9.04: link resume succeeded after 1 retries
> [  323.749309] ata9.04: softreset failed (SRST command error)
> [  323.859049] ata9.04: failed to read SCR 0 (Emask=0x1)
> [  323.859055] ata9.04: reset failed (errno=-85), retrying in 10 secs
> [  333.211390] ata9.04: reset failed, giving up
> [  333.211397] ata9.15: hard resetting link
> [  333.211400] ata9: controller in dubious state, performing PORT_RST
> [  335.360620] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  335.666238] ata9.01: hard resetting link
> [  336.069058] ata9.01: link resume succeeded after 1 retries
> [  336.204019] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  336.204053] ata9.02: hard resetting link
> [  336.606854] ata9.02: link resume succeeded after 1 retries
> [  336.741795] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  336.741850] ata9.03: hard resetting link
> [  337.144658] ata9.03: link resume succeeded after 1 retries
> [  337.279528] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  337.279562] ata9.04: hard resetting link
> [  337.682467] ata9.04: link resume succeeded after 1 retries
> [  337.904854] ata9.04: softreset failed (SRST command error)
> [  337.904966] ata9.04: failed to read SCR 0 (Emask=0x1)
> [  337.904971] ata9.04: reset failed (errno=-85), retrying in 10 secs
> [  347.257313] ata9.04: reset failed, giving up
> [  347.257320] ata9.15: hard resetting link
> [  347.257323] ata9: controller in dubious state, performing PORT_RST
> [  349.406456] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  349.710905] ata9.01: hard resetting link
> [  350.113925] ata9.01: link resume succeeded after 1 retries
> [  350.248876] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  350.248909] ata9.02: hard resetting link
> [  350.651713] ata9.02: link resume succeeded after 1 retries
> [  350.786654] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  350.786709] ata9.03: hard resetting link
> [  351.189524] ata9.03: link resume succeeded after 1 retries
> [  351.324514] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  351.324547] ata9.04: hard resetting link
> [  351.727346] ata9.04: link resume succeeded after 1 retries
> [  351.840017] ata9.04: softreset failed (SRST command error)
> [  351.949778] ata9.04: failed to read SCR 0 (Emask=0x1)
> [  351.949784] ata9.04: reset failed (errno=-85), retrying in 10 secs
> [  361.302128] ata9.04: reset failed, giving up
> [  361.302133] ata9.04: failed to recover link after 3 tries, disabling
> [  361.302139] ata9.15: hard resetting link
> [  361.302142] ata9: controller in dubious state, performing PORT_RST
> [  363.451296] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  364.159770] ata9.04: link resume succeeded after 1 retries
> [  364.261578] ata9.01: hard resetting link
> [  364.664650] ata9.01: link resume succeeded after 1 retries
> [  364.799521] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  364.799576] ata9.02: hard resetting link
> [  365.202441] ata9.02: link resume succeeded after 1 retries
> [  365.337463] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  365.337497] ata9.03: hard resetting link
> [  365.740246] ata9.03: link resume succeeded after 1 retries
> [  365.875039] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  365.875072] ata9.05: hard resetting link
> [  366.179543] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  366.230992] ata9.01: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  366.230998] ata9.01: 625142448 sectors, multi 0: LBA48 
> [  366.231004] ata9.01: applying bridge limits
> [  366.289145] ata9.01: configured for UDMA/100
> [  366.330307] ata9.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  366.330313] ata9.02: 625142448 sectors, multi 0: LBA48 
> [  366.330319] ata9.02: applying bridge limits
> [  366.388360] ata9.02: configured for UDMA/100
> [  366.432420] ata9.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  366.432426] ata9.03: 625142448 sectors, multi 0: LBA48 
> [  366.432432] ata9.03: applying bridge limits
> [  366.490740] ata9.03: configured for UDMA/100
> [  366.490803] ata9: EH complete
> [  368.619861] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  368.620301] ata10.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [  368.624045] ata10.00: hard resetting link
> [  378.608665] ata10.00: softreset failed (timeout)
> [  381.602109] ata10.15: qc timeout (cmd 0xe4)
> [  381.602125] ata10.00: failed to read SCR 0 (Emask=0x5)
> [  381.602130] ata10.00: reset failed, giving up
> [  381.602135] ata10.15: hard resetting link
> [  383.729362] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  383.730054] ata10.00: hard resetting link
> [  393.715134] ata10.00: softreset failed (timeout)
> [  396.708497] ata10.15: qc timeout (cmd 0xe4)
> [  396.708513] ata10.00: failed to read SCR 0 (Emask=0x5)
> [  396.708517] ata10.00: reset failed, giving up
> [  396.708522] ata10.15: hard resetting link
> [  398.835857] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  398.836649] ata10.00: hard resetting link
> [  408.821709] ata10.00: softreset failed (timeout)
> [  411.815072] ata10.15: qc timeout (cmd 0xe4)
> [  411.815088] ata10.00: failed to read SCR 0 (Emask=0x5)
> [  411.815093] ata10.00: reset failed, giving up
> [  411.815096] ata10.00: failed to recover link after 3 tries, disabling
> [  411.815101] ata10.15: hard resetting link
> [  413.942387] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  414.246825] ata10.01: hard resetting link
> [  414.649800] ata10.01: link resume succeeded after 1 retries
> [  414.784764] ata10.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  414.784797] ata10.02: hard resetting link
> [  415.187643] ata10.02: link resume succeeded after 1 retries
> [  415.322566] ata10.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  415.322621] ata10.03: hard resetting link
> [  415.725449] ata10.03: link resume succeeded after 1 retries
> [  415.860370] ata10.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  415.860403] ata10.04: hard resetting link
> [  416.263259] ata10.04: link resume succeeded after 1 retries
> [  416.398200] ata10.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  416.398258] ata10.05: hard resetting link
> [  416.702573] ata10.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  416.748206] ata10.01: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  416.748212] ata10.01: 625142448 sectors, multi 0: LBA48 
> [  416.806352] ata10.01: configured for UDMA/100
> [  416.845697] ata10.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  416.845703] ata10.02: 625142448 sectors, multi 0: LBA48 
> [  416.903833] ata10.02: configured for UDMA/100
> [  416.949334] ata10.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  416.949340] ata10.03: 625142448 sectors, multi 0: LBA48 
> [  417.007519] ata10.03: configured for UDMA/100
> [  417.058495] ata10.04: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  417.058503] ata10.04: 625142448 sectors, multi 0: LBA48 
> [  417.116501] ata10.04: configured for UDMA/100
> [  417.116568] ata10: EH complete
   :
> [  509.264886] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> [  509.322433] NFSD: starting 90-second grace period
   :
-------
