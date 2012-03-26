Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab2CZJul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 05:50:41 -0400
Received: from mta103.odn.ne.jp ([143.90.14.143]:56171 "EHLO cmta103.odn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab2CZJuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 05:50:37 -0400
Message-ID: <4F703BEB.1040309@yahoo.co.jp>
Date: Mon, 26 Mar 2012 18:50:35 +0900
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
References: <4F5ECD06.3000608@yahoo.co.jp> <4F5F7C4C.7080800@teksavvy.com> <4F662AFB.9050106@yahoo.co.jp> <CAMHSBOWg+rxxrVjf05r1tYDpW1S75XzdrLQ+U8TrjC9okRYtuA@mail.gmail.com> <4F6AAC37.7040907@yahoo.co.jp> <4F6B30D9.2070805@yahoo.co.jp> <CAMHSBOVD4wAtwAravVkDjyWV+Nwtuybt=yae=26PcGxxirw=Lg@mail.gmail.com> <4F6B679C.60004@yahoo.co.jp> <CAMHSBOWDYyLRREZNGqhBtvF_gSrvB-b=PVx3qULCqpc7yeJCcQ@mail.gmail.com> <4F6C1AE5.5060405@yahoo.co.jp> <CAMHSBOXuX1U8uPyN136AQ_LRW85Ex8EUu1-_hdBqnSMtdmg+0Q@mail.gmail.com> <4F6C4967.80309@yahoo.co.jp> <4F6E728A.3090203@yahoo.co.jp> <CAMHSBOVtj8pXVtSK7qUmzSzXTCJWTK6-m7ZY6TB3gj-dT70ptw@mail.gmail.com> <4F6FBB3E.8060409@yahoo.co.jp> <4F6FD4CD.5040608@yahoo.co.jp>
In-Reply-To: <4F6FD4CD.5040608@yahoo.co.jp>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Gwendal,

(2012/03/26 11:30), ANEZAKI, Akira wrote:
> Hello Gwendal,
> 
> (2012/03/26 09:41), ANEZAKI, Akira wrote:
> 
>>> If possible, could you switch 2 of the 4 enclosures [with their disks]
>>> that fails to the port controlled by the Sil3132 controller, reboot
>>> the machine with all its 30 drives and see if the failures follow the
>>> controller or the enclosure.
>>
>> Yes, I will do it as soon as possible. (Sorry, resyncing is runnning now.)

I got the log of the first warm reboot. I have attached the log. I had
operated to build some RAIDs for getting log.

ata7,ata8 : 4+4=8 HDDs.
ata5,ata6,ata9,ata10 : 5+5+5+5=20 HDDs.

But from log,
ata5: 2 HDDs -- lost 3 HDDs.
ata6: 3 HDDs -- lost 2 HDDs.
ata7: 4 HDDs -- OK.
ata8: 4 HDDs -- OK.
ata9: 3 HDDs -- lost 2 HDDs.
ata10: 4 HDDs -- lost 1 HDD.

Boot failed because root RAID didn't be built. But, I was able to build
root RAID by tools and mdadm.conf in dracut disk. The root RAID, etc.
were built in 2nd warm reboot and boot was successful. It is strange.

Thank you for your help.

Best Regards,
Akira

--- 3.2.10 first warm reboot log ( unpatched ) ---
   :
> [    0.000000] Linux version 3.2.10-3.fc16.i686.PAE (mockbuild@x86-02.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 15 20:37:01 UTC 2012
   :
> [    1.586715] ata1: SATA max UDMA/133 cmd 0xac00 ctl 0xa880 bmdma 0xa400 irq 19
> [    1.586719] ata2: SATA max UDMA/133 cmd 0xa800 ctl 0xa480 bmdma 0xa408 irq 19
> [    1.587721] ata3: SATA max UDMA/133 cmd 0x9c00 ctl 0x9880 bmdma 0x9400 irq 19
> [    1.587724] ata4: SATA max UDMA/133 cmd 0x9800 ctl 0x9480 bmdma 0x9408 irq 19
> [    1.904866] ata4: SATA link down (SStatus 0 SControl 300)
> [    2.055449] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    2.074587] ata3.00: ATAPI: HL-DT-ST DVDRAM GH22NS40, NL02, max UDMA/100
> [    2.080518] ata3.00: configured for UDMA/100
> [    2.209188] ata2.00: SATA link down (SStatus 0 SControl 300)
> [    2.209206] ata2.01: SATA link down (SStatus 0 SControl 300)
> [    2.348745] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.348762] ata1.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.355703] ata1.00: ATA-8: WDC WD10EADS-00M2B0, 01.00A01, max UDMA/133
> [    2.355709] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    2.355987] ata1.01: ATA-8: Hitachi HDS721010CLA332, JP4OA39C, max UDMA/133
> [    2.355994] ata1.01: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    2.359078] ata1.00: configured for UDMA/133
> [    2.365107] ata1.01: configured for UDMA/133
> [    2.691194] ata5: SATA max UDMA/100 host m128@0xfbeffc00 port 0xfbef8000 irq 18
> [    2.691198] ata6: SATA max UDMA/100 host m128@0xfbeffc00 port 0xfbefa000 irq 18
> [    2.692067] ata7: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff0000 irq 17
> [    2.692070] ata8: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff2000 irq 17
> [    2.692073] ata9: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff4000 irq 17
> [    2.692075] ata10: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff6000 irq 17
> [    4.818290] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [    4.818754] ata5.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [    4.820179] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [    4.820600] ata7.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [    4.820628] ata5.00: hard resetting link
> [    4.823254] ata7.00: hard resetting link
> [    5.226588] ata7.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [    5.226627] ata7.01: hard resetting link
> [    5.629728] ata7.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    5.629784] ata7.02: hard resetting link
> [    6.032779] ata7.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    6.032818] ata7.03: hard resetting link
> [    6.435908] ata7.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    6.435963] ata7.04: hard resetting link
> [    6.740328] ata7.04: SATA link down (SStatus 0 SControl 320)
> [    6.740385] ata7.05: hard resetting link
> [    7.044672] ata7.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [    7.045760] ata7.00: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [    7.045766] ata7.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    7.047019] ata7.00: configured for UDMA/100
> [    7.048008] ata7.01: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [    7.048014] ata7.01: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    7.049138] ata7.01: configured for UDMA/100
> [    7.050041] ata7.02: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [    7.050046] ata7.02: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    7.051051] ata7.02: configured for UDMA/100
> [    7.051877] ata7.03: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [    7.051882] ata7.03: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    7.052881] ata7.03: configured for UDMA/100
> [    7.052936] ata7: EH complete
> [   14.805149] ata5.00: softreset failed (timeout)
> [   17.798535] ata5.15: qc timeout (cmd 0xe4)
> [   17.798719] ata5.00: failed to read SCR 0 (Emask=0x4)
> [   17.798725] ata5.00: reset failed, giving up
> [   17.798730] ata5.15: hard resetting link
> [   19.925820] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   19.926277] ata5.00: hard resetting link
> [   29.910836] ata5.00: softreset failed (timeout)
> [   32.904094] ata5.15: qc timeout (cmd 0xe4)
> [   32.904123] ata5.00: failed to read SCR 0 (Emask=0x4)
> [   32.904127] ata5.00: reset failed, giving up
> [   32.904132] ata5.15: hard resetting link
> [   35.031348] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   35.031803] ata5.00: hard resetting link
> [   45.017041] ata5.00: softreset failed (timeout)
> [   48.010568] ata5.15: qc timeout (cmd 0xe4)
> [   48.010754] ata5.00: failed to read SCR 0 (Emask=0x4)
> [   48.010759] ata5.00: reset failed, giving up
> [   48.010763] ata5.00: failed to recover link after 3 tries, disabling
> [   48.010768] ata5.15: hard resetting link
> [   50.137826] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   50.442334] ata5.01: hard resetting link
> [   50.845326] ata5.01: link resume succeeded after 1 retries
> [   50.957956] ata5.01: softreset failed (SRST command error)
> [   51.067736] ata5.01: failed to read SCR 0 (Emask=0x1)
> [   51.067742] ata5.01: reset failed (errno=-85), retrying in 10 secs
> [   60.420020] ata5.01: reset failed, giving up
> [   60.420027] ata5.15: hard resetting link
> [   60.420030] ata5: controller in dubious state, performing PORT_RST
> [   62.569262] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   62.873773] ata5.01: hard resetting link
> [   63.276789] ata5.01: link resume succeeded after 1 retries
> [   63.499176] ata5.01: softreset failed (SRST command error)
> [   63.499306] ata5.01: failed to read SCR 0 (Emask=0x1)
> [   63.499312] ata5.01: reset failed (errno=-85), retrying in 10 secs
> [   72.851517] ata5.01: reset failed, giving up
> [   72.851523] ata5.15: hard resetting link
> [   72.851527] ata5: controller in dubious state, performing PORT_RST
> [   75.000728] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   75.305210] ata5.01: hard resetting link
> [   75.708226] ata5.01: link resume succeeded after 1 retries
> [   75.930774] ata5.01: softreset failed (SRST command error)
> [   75.930850] ata5.01: failed to read SCR 0 (Emask=0x1)
> [   75.930856] ata5.01: reset failed (errno=-85), retrying in 10 secs
> [   85.282977] ata5.01: reset failed, giving up
> [   85.282982] ata5.01: failed to recover link after 3 tries, disabling
> [   85.282988] ata5.15: hard resetting link
> [   85.282991] ata5: controller in dubious state, performing PORT_RST
> [   87.432170] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   88.139621] ata5.01: link resume succeeded after 1 retries
> [   88.241458] ata5.02: hard resetting link
> [   88.644547] ata5.02: link resume succeeded after 1 retries
> [   88.779488] ata5.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [   88.779548] ata5.03: hard resetting link
> [   89.182363] ata5.03: link resume succeeded after 1 retries
> [   89.317344] ata5.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [   89.317404] ata5.04: hard resetting link
> [   89.742002] ata5.04: softreset failed (SRST command error)
> [   89.742021] ata5.04: failed to read SCR 0 (Emask=0x40)
> [   89.742027] ata5.04: reset failed (errno=-85), retrying in 10 secs
> [   99.294931] ata5.04: reset failed, giving up
> [   99.294937] ata5.15: hard resetting link
> [   99.294941] ata5: controller in dubious state, performing PORT_RST
> [  101.444108] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  102.151608] ata5.01: link resume succeeded after 1 retries
> [  102.253397] ata5.02: hard resetting link
> [  102.656488] ata5.02: link resume succeeded after 1 retries
> [  102.791359] ata5.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  102.791403] ata5.03: hard resetting link
> [  103.194279] ata5.03: link resume succeeded after 1 retries
> [  103.329256] ata5.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  103.329315] ata5.04: hard resetting link
> [  103.753939] ata5.04: softreset failed (SRST command error)
> [  103.863697] ata5.04: failed to read SCR 0 (Emask=0x1)
> [  103.863703] ata5.04: reset failed (errno=-85), retrying in 10 secs
> [  113.306870] ata5.04: reset failed, giving up
> [  113.306876] ata5.15: hard resetting link
> [  113.306880] ata5: controller in dubious state, performing PORT_RST
> [  115.456026] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  116.164541] ata5.01: link resume succeeded after 1 retries
> [  116.266267] ata5.02: hard resetting link
> [  116.669582] ata5.02: link resume succeeded after 1 retries
> [  116.804348] ata5.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  116.804407] ata5.03: hard resetting link
> [  117.207171] ata5.03: link resume succeeded after 1 retries
> [  117.342204] ata5.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  117.342263] ata5.04: hard resetting link
> [  117.766874] ata5.04: softreset failed (SRST command error)
> [  117.876578] ata5.04: failed to read SCR 0 (Emask=0x1)
> [  117.876585] ata5.04: reset failed (errno=-85), retrying in 10 secs
> [  127.319750] ata5.04: reset failed, giving up
> [  127.319755] ata5.04: failed to recover link after 3 tries, disabling
> [  127.319761] ata5.15: hard resetting link
> [  127.319764] ata5: controller in dubious state, performing PORT_RST
> [  129.468974] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  130.177439] ata5.01: link resume succeeded after 1 retries
> [  130.682317] ata5.04: link resume succeeded after 1 retries
> [  130.784221] ata5.02: hard resetting link
> [  131.187201] ata5.02: link resume succeeded after 1 retries
> [  131.322210] ata5.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  131.322269] ata5.03: hard resetting link
> [  131.724976] ata5.03: link resume succeeded after 1 retries
> [  131.859973] ata5.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  131.860032] ata5.05: hard resetting link
> [  132.164262] ata5.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  132.198572] ata5.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  132.198580] ata5.02: 625142448 sectors, multi 0: LBA48 
> [  132.198588] ata5.02: applying bridge limits
> [  132.256546] ata5.02: configured for UDMA/100
> [  132.302071] ata5.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  132.302078] ata5.03: 625142448 sectors, multi 0: LBA48 
> [  132.360106] ata5.03: configured for UDMA/100
> [  132.360180] ata5: EH complete
> [  134.488849] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  134.489351] ata6.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [  134.492028] ata6.00: hard resetting link
> [  144.476685] ata6.00: softreset failed (timeout)
> [  147.470049] ata6.15: qc timeout (cmd 0xe4)
> [  147.470078] ata6.00: failed to read SCR 0 (Emask=0x5)
> [  147.470082] ata6.00: reset failed, giving up
> [  147.470087] ata6.15: hard resetting link
> [  149.597329] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  149.597797] ata6.00: hard resetting link
> [  159.584193] ata6.00: softreset failed (timeout)
> [  162.577508] ata6.15: qc timeout (cmd 0xe4)
> [  162.577538] ata6.00: failed to read SCR 0 (Emask=0x5)
> [  162.577544] ata6.00: reset failed, giving up
> [  162.577551] ata6.15: hard resetting link
> [  164.704864] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  164.705334] ata6.00: hard resetting link
> [  174.689708] ata6.00: softreset failed (timeout)
> [  177.683110] ata6.15: qc timeout (cmd 0xe4)
> [  177.683139] ata6.00: failed to read SCR 0 (Emask=0x5)
> [  177.683143] ata6.00: reset failed, giving up
> [  177.683147] ata6.00: failed to recover link after 3 tries, disabling
> [  177.683152] ata6.15: hard resetting link
> [  179.810368] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  180.115863] ata6.01: hard resetting link
> [  180.518860] ata6.01: link resume succeeded after 1 retries
> [  180.653808] ata6.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  180.653845] ata6.02: hard resetting link
> [  181.056646] ata6.02: link resume succeeded after 1 retries
> [  181.279078] ata6.02: softreset failed (SRST command error)
> [  181.388836] ata6.02: failed to read SCR 0 (Emask=0x1)
> [  181.388841] ata6.02: reset failed (errno=-85), retrying in 10 secs
> [  190.631407] ata6.02: reset failed, giving up
> [  190.631413] ata6.15: hard resetting link
> [  190.631417] ata6: controller in dubious state, performing PORT_RST
> [  192.780624] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  193.085045] ata6.01: hard resetting link
> [  193.488086] ata6.01: link resume succeeded after 1 retries
> [  193.623076] ata6.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  193.623117] ata6.02: hard resetting link
> [  194.025894] ata6.02: link resume succeeded after 1 retries
> [  194.138511] ata6.02: softreset failed (SRST command error)
> [  194.248321] ata6.02: failed to read SCR 0 (Emask=0x1)
> [  194.248327] ata6.02: reset failed (errno=-85), retrying in 10 secs
> [  203.600600] ata6.02: reset failed, giving up
> [  203.600607] ata6.15: hard resetting link
> [  203.600611] ata6: controller in dubious state, performing PORT_RST
> [  205.749784] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  206.054356] ata6.01: hard resetting link
> [  206.457332] ata6.01: link resume succeeded after 1 retries
> [  206.592298] ata6.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  206.592357] ata6.02: hard resetting link
> [  206.995144] ata6.02: link resume succeeded after 1 retries
> [  207.217570] ata6.02: softreset failed (SRST command error)
> [  207.327330] ata6.02: failed to read SCR 0 (Emask=0x1)
> [  207.327335] ata6.02: reset failed (errno=-85), retrying in 10 secs
> [  216.569868] ata6.02: reset failed, giving up
> [  216.569874] ata6.02: failed to recover link after 3 tries, disabling
> [  216.569880] ata6.15: hard resetting link
> [  216.569883] ata6: controller in dubious state, performing PORT_RST
> [  218.719096] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  219.426552] ata6.02: link resume succeeded after 1 retries
> [  219.528485] ata6.01: hard resetting link
> [  219.931419] ata6.01: link resume succeeded after 1 retries
> [  220.066440] ata6.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  220.066499] ata6.03: hard resetting link
> [  220.469296] ata6.03: link resume succeeded after 1 retries
> [  220.604198] ata6.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  220.604256] ata6.04: hard resetting link
> [  221.007077] ata6.04: link resume succeeded after 1 retries
> [  221.142088] ata6.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  221.142147] ata6.05: hard resetting link
> [  221.446360] ata6.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  221.493629] ata6.01: ATA-7: ST3320620A, 3.AAC, max UDMA/100
> [  221.493635] ata6.01: 625142448 sectors, multi 0: LBA48 
> [  221.551703] ata6.01: configured for UDMA/100
> [  221.594630] ata6.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  221.594637] ata6.03: 625142448 sectors, multi 0: LBA48 
> [  221.652792] ata6.03: configured for UDMA/100
> [  221.688149] ata6.04: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  221.688155] ata6.04: 625142448 sectors, multi 0: LBA48 
> [  221.746331] ata6.04: configured for UDMA/100
> [  221.746405] ata6: EH complete
> [  223.878659] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  223.878948] ata8.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [  223.881975] ata8.00: hard resetting link
> [  224.219209] ata8.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [  224.219246] ata8.01: hard resetting link
> [  224.556424] ata8.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  224.556480] ata8.02: hard resetting link
> [  224.893723] ata8.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  224.893760] ata8.03: hard resetting link
> [  225.230955] ata8.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  225.230989] ata8.04: hard resetting link
> [  225.535344] ata8.04: SATA link down (SStatus 0 SControl 320)
> [  225.535398] ata8.05: hard resetting link
> [  225.839577] ata8.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  225.868512] ata8.00: ATA-8: ST31000333AS, SD15, max UDMA/133
> [  225.868518] ata8.00: 1953525168 sectors, multi 0: LBA48 NCQ (not used)
> [  225.868525] ata8.00: WARNING: device requires firmware update to be fully functional
> [  225.868528] ata8.00:          contact the vendor or visit http://ata.wiki.kernel.org
> [  225.910566] ata8.00: configured for UDMA/100
> [  225.939471] ata8.01: ATA-8: ST31000333AS, SD15, max UDMA/133
> [  225.939477] ata8.01: 1953525168 sectors, multi 0: LBA48 NCQ (not used)
> [  225.939483] ata8.01: WARNING: device requires firmware update to be fully functional
> [  225.939487] ata8.01:          contact the vendor or visit http://ata.wiki.kernel.org
> [  225.981687] ata8.01: configured for UDMA/100
> [  226.010538] ata8.02: ATA-8: ST31000333AS, SD15, max UDMA/133
> [  226.010544] ata8.02: 1953525168 sectors, multi 0: LBA48 NCQ (not used)
> [  226.010550] ata8.02: WARNING: device requires firmware update to be fully functional
> [  226.010554] ata8.02:          contact the vendor or visit http://ata.wiki.kernel.org
> [  226.052546] ata8.02: configured for UDMA/100
> [  226.081303] ata8.03: ATA-8: ST31000333AS, SD15, max UDMA/133
> [  226.081309] ata8.03: 1953525168 sectors, multi 0: LBA48 NCQ (not used)
> [  226.081316] ata8.03: WARNING: device requires firmware update to be fully functional
> [  226.081320] ata8.03:          contact the vendor or visit http://ata.wiki.kernel.org
> [  226.123296] ata8.03: configured for UDMA/100
> [  226.123363] ata8: EH complete
> [  228.252977] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  228.253388] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [  228.255999] ata9.00: hard resetting link
> [  238.240809] ata9.00: softreset failed (timeout)
> [  241.234285] ata9.15: qc timeout (cmd 0xe4)
> [  241.234301] ata9.00: failed to read SCR 0 (Emask=0x5)
> [  241.234306] ata9.00: reset failed, giving up
> [  241.234311] ata9.15: hard resetting link
> [  243.361529] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  243.361905] ata9.00: hard resetting link
> [  253.346319] ata9.00: softreset failed (timeout)
> [  256.339710] ata9.15: qc timeout (cmd 0xe4)
> [  256.339727] ata9.00: failed to read SCR 0 (Emask=0x5)
> [  256.339731] ata9.00: reset failed, giving up
> [  256.339736] ata9.15: hard resetting link
> [  258.466978] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  258.467292] ata9.00: hard resetting link
> [  268.452831] ata9.00: softreset failed (timeout)
> [  271.446301] ata9.15: qc timeout (cmd 0xe4)
> [  271.446317] ata9.00: failed to read SCR 0 (Emask=0x5)
> [  271.446321] ata9.00: reset failed, giving up
> [  271.446325] ata9.00: failed to recover link after 3 tries, disabling
> [  271.446330] ata9.15: hard resetting link
> [  273.573498] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  273.877944] ata9.01: hard resetting link
> [  274.280962] ata9.01: link resume succeeded after 1 retries
> [  274.415952] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  274.415985] ata9.02: hard resetting link
> [  274.818728] ata9.02: link resume succeeded after 1 retries
> [  274.953721] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  274.953755] ata9.03: hard resetting link
> [  275.356608] ata9.03: link resume succeeded after 1 retries
> [  275.491493] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  275.491526] ata9.04: hard resetting link
> [  275.894322] ata9.04: link resume succeeded after 1 retries
> [  276.007093] ata9.04: softreset failed (SRST command error)
> [  276.007152] ata9.04: failed to read SCR 0 (Emask=0x1)
> [  276.007158] ata9.04: reset failed (errno=-85), retrying in 10 secs
> [  285.469105] ata9.04: reset failed, giving up
> [  285.469112] ata9.15: hard resetting link
> [  287.585436] ata9.15: softreset failed (SRST command error)
> [  287.585442] ata9.15: reset failed (errno=-5), retrying in 8 secs
> [  295.446922] ata9.15: hard resetting link
> [  297.563327] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  297.563335] ata9.15: PMP revalidation failed (errno=-19)
> [  302.552242] ata9.15: hard resetting link
> [  304.679550] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  304.984013] ata9.01: hard resetting link
> [  305.386991] ata9.01: link resume succeeded after 1 retries
> [  305.521916] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  305.521949] ata9.02: hard resetting link
> [  305.924851] ata9.02: link resume succeeded after 1 retries
> [  306.059728] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  306.059761] ata9.03: hard resetting link
> [  306.462619] ata9.03: link resume succeeded after 1 retries
> [  306.597566] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  306.597604] ata9.04: hard resetting link
> [  307.000395] ata9.04: link resume succeeded after 1 retries
> [  307.113131] ata9.04: softreset failed (SRST command error)
> [  307.113205] ata9.04: failed to read SCR 0 (Emask=0x1)
> [  307.113211] ata9.04: reset failed (errno=-85), retrying in 10 secs
> [  316.575159] ata9.04: reset failed, giving up
> [  316.575166] ata9.15: hard resetting link
> [  318.693499] ata9.15: softreset failed (SRST command error)
> [  318.693505] ata9.15: reset failed (errno=-5), retrying in 8 secs
> [  326.553031] ata9.15: hard resetting link
> [  328.669394] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  328.669402] ata9.15: PMP revalidation failed (errno=-19)
> [  333.658344] ata9.15: hard resetting link
> [  335.785578] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  336.090035] ata9.01: hard resetting link
> [  336.493042] ata9.01: link resume succeeded after 1 retries
> [  336.628080] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  336.628135] ata9.02: hard resetting link
> [  337.030857] ata9.02: link resume succeeded after 1 retries
> [  337.165822] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  337.165855] ata9.03: hard resetting link
> [  337.568668] ata9.03: link resume succeeded after 1 retries
> [  337.703606] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  337.703639] ata9.04: hard resetting link
> [  338.106494] ata9.04: link resume succeeded after 1 retries
> [  338.219163] ata9.04: softreset failed (SRST command error)
> [  338.219210] ata9.04: failed to read SCR 0 (Emask=0x1)
> [  338.219216] ata9.04: reset failed (errno=-85), retrying in 10 secs
> [  347.681185] ata9.04: reset failed, giving up
> [  347.681190] ata9.04: failed to recover link after 3 tries, disabling
> [  347.681196] ata9.15: hard resetting link
> [  349.797550] ata9.15: softreset failed (SRST command error)
> [  349.797556] ata9.15: reset failed (errno=-5), retrying in 8 secs
> [  357.659140] ata9.15: hard resetting link
> [  359.775419] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  359.775426] ata9.15: PMP revalidation failed (errno=-19)
> [  364.764347] ata9.15: hard resetting link
> [  366.891612] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  367.599084] ata9.04: link resume succeeded after 1 retries
> [  367.700964] ata9.01: hard resetting link
> [  368.104127] ata9.01: link resume succeeded after 1 retries
> [  368.238972] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  368.239006] ata9.02: hard resetting link
> [  368.641778] ata9.02: link resume succeeded after 1 retries
> [  368.776746] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  368.776802] ata9.03: hard resetting link
> [  369.179660] ata9.03: link resume succeeded after 1 retries
> [  369.314547] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  369.314581] ata9.05: hard resetting link
> [  369.619666] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  369.661879] ata9.01: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  369.661885] ata9.01: 625142448 sectors, multi 0: LBA48 
> [  369.661891] ata9.01: applying bridge limits
> [  369.720041] ata9.01: configured for UDMA/100
> [  369.756546] ata9.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  369.756552] ata9.02: 625142448 sectors, multi 0: LBA48 
> [  369.756558] ata9.02: applying bridge limits
> [  369.814602] ata9.02: configured for UDMA/100
> [  369.864633] ata9.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  369.864639] ata9.03: 625142448 sectors, multi 0: LBA48 
> [  369.864645] ata9.03: applying bridge limits
> [  369.922803] ata9.03: configured for UDMA/100
> [  369.922871] ata9: EH complete
> [  372.052190] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  372.052599] ata10.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [  372.055259] ata10.00: hard resetting link
> [  382.040022] ata10.00: softreset failed (timeout)
> [  385.033553] ata10.15: qc timeout (cmd 0xe4)
> [  385.033570] ata10.00: failed to read SCR 0 (Emask=0x5)
> [  385.033574] ata10.00: reset failed, giving up
> [  385.033578] ata10.15: hard resetting link
> [  387.160756] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  387.161158] ata10.00: hard resetting link
> [  397.145523] ata10.00: softreset failed (timeout)
> [  400.138997] ata10.15: qc timeout (cmd 0xe4)
> [  400.139013] ata10.00: failed to read SCR 0 (Emask=0x5)
> [  400.139017] ata10.00: reset failed, giving up
> [  400.139022] ata10.15: hard resetting link
> [  402.266213] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  402.266619] ata10.00: hard resetting link
> [  412.251044] ata10.00: softreset failed (timeout)
> [  415.244411] ata10.15: qc timeout (cmd 0xe4)
> [  415.244427] ata10.00: failed to read SCR 0 (Emask=0x5)
> [  415.244431] ata10.00: reset failed, giving up
> [  415.244435] ata10.00: failed to recover link after 3 tries, disabling
> [  415.244440] ata10.15: hard resetting link
> [  417.371707] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  417.676219] ata10.01: hard resetting link
> [  418.079140] ata10.01: link resume succeeded after 1 retries
> [  418.214139] ata10.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  418.214172] ata10.02: hard resetting link
> [  418.617016] ata10.02: link resume succeeded after 1 retries
> [  418.751952] ata10.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  418.751986] ata10.03: hard resetting link
> [  419.154794] ata10.03: link resume succeeded after 1 retries
> [  419.289803] ata10.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  419.289841] ata10.04: hard resetting link
> [  419.692661] ata10.04: link resume succeeded after 1 retries
> [  419.827582] ata10.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  419.827616] ata10.05: hard resetting link
> [  420.131840] ata10.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  420.173936] ata10.01: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  420.173942] ata10.01: 625142448 sectors, multi 0: LBA48 
> [  420.232080] ata10.01: configured for UDMA/100
> [  420.278236] ata10.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  420.278243] ata10.02: 625142448 sectors, multi 0: LBA48 
> [  420.336354] ata10.02: configured for UDMA/100
> [  420.374703] ata10.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  420.374709] ata10.03: 625142448 sectors, multi 0: LBA48 
> [  420.432897] ata10.03: configured for UDMA/100
> [  420.471911] ata10.04: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  420.471917] ata10.04: 625142448 sectors, multi 0: LBA48 
> [  420.529892] ata10.04: configured for UDMA/100
> [  420.529958] ata10: EH complete
   :
> [  453.357292] dracut Warning: No root device "block:/dev/disk/by-uuid/e9b72b01-749e-4d82-9b9e-4a48afc7b202" found
------

