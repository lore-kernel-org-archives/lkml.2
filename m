Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2CZCan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 22:30:43 -0400
Received: from mta103.odn.ne.jp ([143.90.14.143]:36748 "EHLO cmta103.odn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404Ab2CZCak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 22:30:40 -0400
Message-ID: <4F6FD4CD.5040608@yahoo.co.jp>
Date: Mon, 26 Mar 2012 11:30:37 +0900
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

(2012/03/26 09:41), ANEZAKI, Akira wrote:

>> If possible, could you switch 2 of the 4 enclosures [with their disks]
>> that fails to the port controlled by the Sil3132 controller, reboot
>> the machine with all its 30 drives and see if the failures follow the
>> controller or the enclosure.
> 
> Yes, I will do it as soon as possible. (Sorry, resyncing is runnning now.)

This is a log when warm reboot is successful. I will try warm reboot
more but I'm fixing RAIDs again.

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

--- 3.2.10 warm reboot log ( unpatched ) ---
   :
> [    0.000000] Linux version 3.2.10-3.fc16.i686.PAE (mockbuild@x86-02.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 15 20:37:01 UTC 2012
   :
> [    1.589480] ata1: SATA max UDMA/133 cmd 0xac00 ctl 0xa880 bmdma 0xa400 irq 19
> [    1.589484] ata2: SATA max UDMA/133 cmd 0xa800 ctl 0xa480 bmdma 0xa408 irq 19
> [    1.590487] ata3: SATA max UDMA/133 cmd 0x9c00 ctl 0x9880 bmdma 0x9400 irq 19
> [    1.590491] ata4: SATA max UDMA/133 cmd 0x9800 ctl 0x9480 bmdma 0x9408 irq 19
> [    1.907600] ata4: SATA link down (SStatus 0 SControl 300)
> [    2.058210] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    2.077498] ata3.00: ATAPI: HL-DT-ST DVDRAM GH22NS40, NL02, max UDMA/100
> [    2.099331] ata3.00: configured for UDMA/100
> [    2.211895] ata2.00: SATA link down (SStatus 0 SControl 300)
> [    2.211912] ata2.01: SATA link down (SStatus 0 SControl 300)
> [    2.362481] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.362499] ata1.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.368859] ata1.00: ATA-8: WDC WD10EADS-00M2B0, 01.00A01, max UDMA/133
> [    2.368866] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    2.369140] ata1.01: ATA-8: Hitachi HDS721010CLA332, JP4OA39C, max UDMA/133
> [    2.369147] ata1.01: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    2.374886] ata1.00: configured for UDMA/133
> [    2.380989] ata1.01: configured for UDMA/133
> [    2.729560] ata5: SATA max UDMA/100 host m128@0xfbeffc00 port 0xfbef8000 irq 18
> [    2.729564] ata6: SATA max UDMA/100 host m128@0xfbeffc00 port 0xfbefa000 irq 18
> [    2.732356] ata7: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff0000 irq 17
> [    2.732360] ata8: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff2000 irq 17
> [    2.732364] ata9: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff4000 irq 17
> [    2.732367] ata10: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff6000 irq 17
> [    4.857966] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [    4.858355] ata5.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [    4.859795] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [    4.860189] ata5.00: hard resetting link
> [    4.860287] ata7.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [    4.862439] ata7.00: hard resetting link
> [    5.265296] ata7.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [    5.265352] ata7.01: hard resetting link
> [    5.668362] ata7.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    5.668417] ata7.02: hard resetting link
> [    6.071495] ata7.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    6.071529] ata7.03: hard resetting link
> [    6.474581] ata7.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    6.474613] ata7.04: hard resetting link
> [    6.779060] ata7.04: SATA link down (SStatus 0 SControl 320)
> [    6.779114] ata7.05: hard resetting link
> [    7.083360] ata7.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [    7.084277] ata7.00: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [    7.084286] ata7.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [    7.085547] ata7.00: configured for UDMA/100
> [    7.086553] ata7.01: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [    7.086559] ata7.01: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    7.087660] ata7.01: configured for UDMA/100
> [    7.088553] ata7.02: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [    7.088558] ata7.02: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    7.089654] ata7.02: configured for UDMA/100
> [    7.090546] ata7.03: ATA-8: Hitachi HDP725050GLA360, GM4OA50E, max UDMA/133
> [    7.090551] ata7.03: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    7.091650] ata7.03: configured for UDMA/100
> [    7.091733] ata7: EH complete
> [   14.844826] ata5.00: softreset failed (timeout)
> [   17.838181] ata5.15: qc timeout (cmd 0xe4)
> [   17.838210] ata5.00: failed to read SCR 0 (Emask=0x4)
> [   17.838214] ata5.00: reset failed, giving up
> [   17.838219] ata5.15: hard resetting link
> [   19.965502] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   19.966145] ata5.00: hard resetting link
> [   29.951336] ata5.00: softreset failed (timeout)
> [   32.944766] ata5.15: qc timeout (cmd 0xe4)
> [   32.944795] ata5.00: failed to read SCR 0 (Emask=0x4)
> [   32.944799] ata5.00: reset failed, giving up
> [   32.944804] ata5.15: hard resetting link
> [   35.072012] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   35.072530] ata5.00: hard resetting link
> [   45.056855] ata5.00: softreset failed (timeout)
> [   48.050254] ata5.15: qc timeout (cmd 0xe4)
> [   48.050283] ata5.00: failed to read SCR 0 (Emask=0x4)
> [   48.050287] ata5.00: reset failed, giving up
> [   48.050290] ata5.00: failed to recover link after 3 tries, disabling
> [   48.050295] ata5.15: hard resetting link
> [   50.177517] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   50.482010] ata5.01: hard resetting link
> [   50.884985] ata5.01: link resume succeeded after 1 retries
> [   51.107352] ata5.01: softreset failed (SRST command error)
> [   51.107487] ata5.01: failed to read SCR 0 (Emask=0x1)
> [   51.107492] ata5.01: reset failed (errno=-85), retrying in 10 secs
> [   60.459742] ata5.01: reset failed, giving up
> [   60.459749] ata5.15: hard resetting link
> [   60.459752] ata5: controller in dubious state, performing PORT_RST
> [   62.608949] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   62.914448] ata5.01: hard resetting link
> [   63.317427] ata5.01: link resume succeeded after 1 retries
> [   63.539790] ata5.01: softreset failed (SRST command error)
> [   63.539919] ata5.01: failed to read SCR 0 (Emask=0x1)
> [   63.539925] ata5.01: reset failed (errno=-85), retrying in 10 secs
> [   72.892173] ata5.01: reset failed, giving up
> [   72.892180] ata5.15: hard resetting link
> [   72.892184] ata5: controller in dubious state, performing PORT_RST
> [   75.041389] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   75.345889] ata5.01: hard resetting link
> [   75.748866] ata5.01: link resume succeeded after 1 retries
> [   75.971297] ata5.01: softreset failed (SRST command error)
> [   75.971431] ata5.01: failed to read SCR 0 (Emask=0x1)
> [   75.971437] ata5.01: reset failed (errno=-85), retrying in 10 secs
> [   85.323630] ata5.01: reset failed, giving up
> [   85.323637] ata5.01: failed to recover link after 3 tries, disabling
> [   85.323645] ata5.15: hard resetting link
> [   85.323650] ata5: controller in dubious state, performing PORT_RST
> [   87.472842] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   88.181286] ata5.01: link resume succeeded after 1 retries
> [   88.283133] ata5.02: hard resetting link
> [   88.686176] ata5.02: link resume succeeded after 1 retries
> [   88.821104] ata5.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [   88.821164] ata5.03: hard resetting link
> [   89.223975] ata5.03: link resume succeeded after 1 retries
> [   89.358829] ata5.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [   89.358888] ata5.04: hard resetting link
> [   89.783557] ata5.04: softreset failed (SRST command error)
> [   89.893432] ata5.04: failed to read SCR 0 (Emask=0x1)
> [   89.893438] ata5.04: reset failed (errno=-85), retrying in 10 secs
> [   99.336365] ata5.04: reset failed, giving up
> [   99.336372] ata5.15: hard resetting link
> [   99.336376] ata5: controller in dubious state, performing PORT_RST
> [  101.485757] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  102.193240] ata5.01: link resume succeeded after 1 retries
> [  102.295073] ata5.02: hard resetting link
> [  102.698122] ata5.02: link resume succeeded after 1 retries
> [  102.833073] ata5.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  102.833133] ata5.03: hard resetting link
> [  103.235928] ata5.03: link resume succeeded after 1 retries
> [  103.370761] ata5.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  103.370820] ata5.04: hard resetting link
> [  103.795611] ata5.04: softreset failed (SRST command error)
> [  103.905366] ata5.04: failed to read SCR 0 (Emask=0x1)
> [  103.905371] ata5.04: reset failed (errno=-85), retrying in 10 secs
> [  113.348314] ata5.04: reset failed, giving up
> [  113.348320] ata5.15: hard resetting link
> [  113.348324] ata5: controller in dubious state, performing PORT_RST
> [  115.497700] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  116.205181] ata5.01: link resume succeeded after 1 retries
> [  116.307080] ata5.02: hard resetting link
> [  116.710044] ata5.02: link resume succeeded after 1 retries
> [  116.845018] ata5.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  116.845077] ata5.03: hard resetting link
> [  117.247869] ata5.03: link resume succeeded after 1 retries
> [  117.382765] ata5.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  117.382824] ata5.04: hard resetting link
> [  117.807545] ata5.04: softreset failed (SRST command error)
> [  117.917306] ata5.04: failed to read SCR 0 (Emask=0x1)
> [  117.917312] ata5.04: reset failed (errno=-85), retrying in 10 secs
> [  127.360526] ata5.04: reset failed, giving up
> [  127.360531] ata5.04: failed to recover link after 3 tries, disabling
> [  127.360537] ata5.15: hard resetting link
> [  127.360540] ata5: controller in dubious state, performing PORT_RST
> [  129.509655] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  130.217118] ata5.01: link resume succeeded after 1 retries
> [  130.722001] ata5.04: link resume succeeded after 1 retries
> [  130.823901] ata5.02: hard resetting link
> [  131.226876] ata5.02: link resume succeeded after 1 retries
> [  131.361766] ata5.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  131.361825] ata5.03: hard resetting link
> [  131.764660] ata5.03: link resume succeeded after 1 retries
> [  131.899662] ata5.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  131.899721] ata5.05: hard resetting link
> [  132.205038] ata5.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  132.244958] ata5.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  132.244964] ata5.02: 625142448 sectors, multi 0: LBA48 
> [  132.244970] ata5.02: applying bridge limits
> [  132.303046] ata5.02: configured for UDMA/100
> [  132.342980] ata5.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  132.342986] ata5.03: 625142448 sectors, multi 0: LBA48 
> [  132.401061] ata5.03: configured for UDMA/100
> [  132.401136] ata5: EH complete
> [  134.530494] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  134.531008] ata6.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [  134.532983] ata6.00: hard resetting link
> [  144.517362] ata6.00: softreset failed (timeout)
> [  147.510713] ata6.15: qc timeout (cmd 0xe4)
> [  147.510742] ata6.00: failed to read SCR 0 (Emask=0x5)
> [  147.510746] ata6.00: reset failed, giving up
> [  147.510751] ata6.15: hard resetting link
> [  149.638015] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  149.638490] ata6.00: hard resetting link
> [  159.623868] ata6.00: softreset failed (timeout)
> [  162.617261] ata6.15: qc timeout (cmd 0xe4)
> [  162.617290] ata6.00: failed to read SCR 0 (Emask=0x5)
> [  162.617294] ata6.00: reset failed, giving up
> [  162.617298] ata6.15: hard resetting link
> [  164.744527] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  164.745175] ata6.00: hard resetting link
> [  174.730383] ata6.00: softreset failed (timeout)
> [  177.723774] ata6.15: qc timeout (cmd 0xe4)
> [  177.723803] ata6.00: failed to read SCR 0 (Emask=0x5)
> [  177.723807] ata6.00: reset failed, giving up
> [  177.723811] ata6.00: failed to recover link after 3 tries, disabling
> [  177.723816] ata6.15: hard resetting link
> [  179.851035] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  180.156552] ata6.01: hard resetting link
> [  180.559477] ata6.01: link resume succeeded after 1 retries
> [  180.694563] ata6.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  180.694606] ata6.02: hard resetting link
> [  181.097289] ata6.02: link resume succeeded after 1 retries
> [  181.319751] ata6.02: softreset failed (SRST command error)
> [  181.429509] ata6.02: failed to read SCR 0 (Emask=0x1)
> [  181.429515] ata6.02: reset failed (errno=-85), retrying in 10 secs
> [  190.672324] ata6.02: reset failed, giving up
> [  190.672330] ata6.15: hard resetting link
> [  190.672334] ata6: controller in dubious state, performing PORT_RST
> [  192.821300] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  193.125786] ata6.01: hard resetting link
> [  193.528727] ata6.01: link resume succeeded after 1 retries
> [  193.663686] ata6.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  193.663812] ata6.02: hard resetting link
> [  194.066567] ata6.02: link resume succeeded after 1 retries
> [  194.288962] ata6.02: softreset failed (SRST command error)
> [  194.398756] ata6.02: failed to read SCR 0 (Emask=0x1)
> [  194.398762] ata6.02: reset failed (errno=-85), retrying in 10 secs
> [  203.641295] ata6.02: reset failed, giving up
> [  203.641303] ata6.15: hard resetting link
> [  203.641309] ata6: controller in dubious state, performing PORT_RST
> [  205.790546] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  206.094966] ata6.01: hard resetting link
> [  206.498015] ata6.01: link resume succeeded after 1 retries
> [  206.633061] ata6.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  206.633120] ata6.02: hard resetting link
> [  207.035819] ata6.02: link resume succeeded after 1 retries
> [  207.258245] ata6.02: softreset failed (SRST command error)
> [  207.368006] ata6.02: failed to read SCR 0 (Emask=0x1)
> [  207.368012] ata6.02: reset failed (errno=-85), retrying in 10 secs
> [  216.610620] ata6.02: reset failed, giving up
> [  216.610626] ata6.02: failed to recover link after 3 tries, disabling
> [  216.610632] ata6.15: hard resetting link
> [  216.610635] ata6: controller in dubious state, performing PORT_RST
> [  218.759779] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  219.467254] ata6.02: link resume succeeded after 1 retries
> [  219.569163] ata6.01: hard resetting link
> [  219.972113] ata6.01: link resume succeeded after 1 retries
> [  220.107129] ata6.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  220.107188] ata6.03: hard resetting link
> [  220.509917] ata6.03: link resume succeeded after 1 retries
> [  220.644966] ata6.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  220.645026] ata6.04: hard resetting link
> [  221.047757] ata6.04: link resume succeeded after 1 retries
> [  221.182778] ata6.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  221.182837] ata6.05: hard resetting link
> [  221.487112] ata6.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  221.526612] ata6.01: ATA-7: ST3320620A, 3.AAC, max UDMA/100
> [  221.526618] ata6.01: 625142448 sectors, multi 0: LBA48 
> [  221.584762] ata6.01: configured for UDMA/100
> [  221.631071] ata6.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  221.631077] ata6.03: 625142448 sectors, multi 0: LBA48 
> [  221.689230] ata6.03: configured for UDMA/100
> [  221.727356] ata6.04: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  221.727362] ata6.04: 625142448 sectors, multi 0: LBA48 
> [  221.785541] ata6.04: configured for UDMA/100
> [  221.785615] ata6: EH complete
> [  223.918343] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  223.918775] ata8.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [  223.921937] ata8.00: hard resetting link
> [  224.259862] ata8.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [  224.259917] ata8.01: hard resetting link
> [  224.597085] ata8.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  224.597141] ata8.02: hard resetting link
> [  224.934516] ata8.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  224.934572] ata8.03: hard resetting link
> [  225.271591] ata8.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  225.271624] ata8.04: hard resetting link
> [  225.575989] ata8.04: SATA link down (SStatus 0 SControl 320)
> [  225.576042] ata8.05: hard resetting link
> [  225.880279] ata8.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  225.909034] ata8.00: ATA-8: ST31000333AS, SD15, max UDMA/133
> [  225.909041] ata8.00: 1953525168 sectors, multi 16: LBA48 NCQ (not used)
> [  225.909047] ata8.00: WARNING: device requires firmware update to be fully functional
> [  225.909051] ata8.00:          contact the vendor or visit http://ata.wiki.kernel.org
> [  225.950939] ata8.00: configured for UDMA/100
> [  225.979588] ata8.01: ATA-8: ST31000333AS, SD15, max UDMA/133
> [  225.979594] ata8.01: 1953525168 sectors, multi 0: LBA48 NCQ (not used)
> [  225.979600] ata8.01: WARNING: device requires firmware update to be fully functional
> [  225.979604] ata8.01:          contact the vendor or visit http://ata.wiki.kernel.org
> [  226.021473] ata8.01: configured for UDMA/100
> [  226.050141] ata8.02: ATA-8: ST31000333AS, SD15, max UDMA/133
> [  226.050147] ata8.02: 1953525168 sectors, multi 0: LBA48 NCQ (not used)
> [  226.050154] ata8.02: WARNING: device requires firmware update to be fully functional
> [  226.050158] ata8.02:          contact the vendor or visit http://ata.wiki.kernel.org
> [  226.091995] ata8.02: configured for UDMA/100
> [  226.120548] ata8.03: ATA-8: ST31000333AS, SD15, max UDMA/133
> [  226.120554] ata8.03: 1953525168 sectors, multi 0: LBA48 NCQ (not used)
> [  226.120561] ata8.03: WARNING: device requires firmware update to be fully functional
> [  226.120565] ata8.03:          contact the vendor or visit http://ata.wiki.kernel.org
> [  226.162385] ata8.03: configured for UDMA/100
> [  226.162453] ata8: EH complete
> [  228.292632] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  228.293002] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [  228.296050] ata9.00: hard resetting link
> [  238.280486] ata9.00: softreset failed (timeout)
> [  241.274023] ata9.15: qc timeout (cmd 0xe4)
> [  241.274040] ata9.00: failed to read SCR 0 (Emask=0x5)
> [  241.274044] ata9.00: reset failed, giving up
> [  241.274049] ata9.15: hard resetting link
> [  243.401137] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  243.401599] ata9.00: hard resetting link
> [  253.387991] ata9.00: softreset failed (timeout)
> [  256.381414] ata9.15: qc timeout (cmd 0xe4)
> [  256.381430] ata9.00: failed to read SCR 0 (Emask=0x5)
> [  256.381434] ata9.00: reset failed, giving up
> [  256.381439] ata9.15: hard resetting link
> [  258.508673] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  258.509048] ata9.00: hard resetting link
> [  268.494505] ata9.00: softreset failed (timeout)
> [  271.487878] ata9.15: qc timeout (cmd 0xe4)
> [  271.487895] ata9.00: failed to read SCR 0 (Emask=0x5)
> [  271.487899] ata9.00: reset failed, giving up
> [  271.487903] ata9.00: failed to recover link after 3 tries, disabling
> [  271.487908] ata9.15: hard resetting link
> [  273.615201] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  273.919608] ata9.01: hard resetting link
> [  274.322603] ata9.01: link resume succeeded after 1 retries
> [  274.457553] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  274.457586] ata9.02: hard resetting link
> [  274.860444] ata9.02: link resume succeeded after 1 retries
> [  274.995367] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  274.995400] ata9.03: hard resetting link
> [  275.398299] ata9.03: link resume succeeded after 1 retries
> [  275.533164] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  275.533197] ata9.04: hard resetting link
> [  275.936074] ata9.04: link resume succeeded after 1 retries
> [  276.158501] ata9.04: softreset failed (SRST command error)
> [  276.268262] ata9.04: failed to read SCR 0 (Emask=0x1)
> [  276.268268] ata9.04: reset failed (errno=-85), retrying in 10 secs
> [  285.510770] ata9.04: reset failed, giving up
> [  285.510776] ata9.15: hard resetting link
> [  285.510780] ata9: controller in dubious state, performing PORT_RST
> [  287.660034] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  287.964508] ata9.01: hard resetting link
> [  288.367491] ata9.01: link resume succeeded after 1 retries
> [  288.502430] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  288.502463] ata9.02: hard resetting link
> [  288.905305] ata9.02: link resume succeeded after 1 retries
> [  289.040255] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  289.040288] ata9.03: hard resetting link
> [  289.443108] ata9.03: link resume succeeded after 1 retries
> [  289.578057] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  289.578090] ata9.04: hard resetting link
> [  289.980918] ata9.04: link resume succeeded after 1 retries
> [  290.203369] ata9.04: softreset failed (SRST command error)
> [  290.203485] ata9.04: failed to read SCR 0 (Emask=0x1)
> [  290.203491] ata9.04: reset failed (errno=-85), retrying in 10 secs
> [  299.555660] ata9.04: reset failed, giving up
> [  299.555666] ata9.15: hard resetting link
> [  299.555670] ata9: controller in dubious state, performing PORT_RST
> [  301.704918] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  302.009409] ata9.01: hard resetting link
> [  302.412365] ata9.01: link resume succeeded after 1 retries
> [  302.547281] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  302.547314] ata9.02: hard resetting link
> [  302.950171] ata9.02: link resume succeeded after 1 retries
> [  303.085117] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  303.085150] ata9.03: hard resetting link
> [  303.487982] ata9.03: link resume succeeded after 1 retries
> [  303.622902] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  303.622958] ata9.04: hard resetting link
> [  304.025789] ata9.04: link resume succeeded after 1 retries
> [  304.138473] ata9.04: softreset failed (SRST command error)
> [  304.248235] ata9.04: failed to read SCR 0 (Emask=0x1)
> [  304.248241] ata9.04: reset failed (errno=-85), retrying in 10 secs
> [  313.600501] ata9.04: reset failed, giving up
> [  313.600507] ata9.04: failed to recover link after 3 tries, disabling
> [  313.600513] ata9.15: hard resetting link
> [  313.600516] ata9: controller in dubious state, performing PORT_RST
> [  315.749752] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  316.457271] ata9.04: link resume succeeded after 1 retries
> [  316.559076] ata9.01: hard resetting link
> [  316.962068] ata9.01: link resume succeeded after 1 retries
> [  317.097054] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  317.097088] ata9.02: hard resetting link
> [  317.499918] ata9.02: link resume succeeded after 1 retries
> [  317.634858] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  317.634914] ata9.03: hard resetting link
> [  318.037724] ata9.03: link resume succeeded after 1 retries
> [  318.172660] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  318.172693] ata9.05: hard resetting link
> [  318.477013] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  318.516456] ata9.01: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  318.516462] ata9.01: 625142448 sectors, multi 0: LBA48 
> [  318.516468] ata9.01: applying bridge limits
> [  318.574613] ata9.01: configured for UDMA/100
> [  318.619314] ata9.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  318.619320] ata9.02: 625142448 sectors, multi 0: LBA48 
> [  318.619326] ata9.02: applying bridge limits
> [  318.677370] ata9.02: configured for UDMA/100
> [  318.722829] ata9.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  318.722835] ata9.03: 625142448 sectors, multi 0: LBA48 
> [  318.722841] ata9.03: applying bridge limits
> [  318.780997] ata9.03: configured for UDMA/100
> [  318.781065] ata9: EH complete
> [  320.910331] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  320.910716] ata10.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [  320.914444] ata10.00: hard resetting link
> [  330.899026] ata10.00: softreset failed (timeout)
> [  333.892559] ata10.15: qc timeout (cmd 0xe4)
> [  333.892575] ata10.00: failed to read SCR 0 (Emask=0x5)
> [  333.892579] ata10.00: reset failed, giving up
> [  333.892584] ata10.15: hard resetting link
> [  336.019804] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  336.020217] ata10.00: hard resetting link
> [  346.005672] ata10.00: softreset failed (timeout)
> [  348.999080] ata10.15: qc timeout (cmd 0xe4)
> [  348.999097] ata10.00: failed to read SCR 0 (Emask=0x5)
> [  348.999101] ata10.00: reset failed, giving up
> [  348.999106] ata10.15: hard resetting link
> [  351.126351] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  351.126798] ata10.00: hard resetting link
> [  361.111185] ata10.00: softreset failed (timeout)
> [  364.104592] ata10.15: qc timeout (cmd 0xe4)
> [  364.104608] ata10.00: failed to read SCR 0 (Emask=0x5)
> [  364.104613] ata10.00: reset failed, giving up
> [  364.104616] ata10.00: failed to recover link after 3 tries, disabling
> [  364.104621] ata10.15: hard resetting link
> [  366.231861] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  366.536337] ata10.01: hard resetting link
> [  366.939336] ata10.01: link resume succeeded after 1 retries
> [  367.074226] ata10.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  367.074260] ata10.02: hard resetting link
> [  367.477128] ata10.02: link resume succeeded after 1 retries
> [  367.612045] ata10.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  367.612079] ata10.03: hard resetting link
> [  368.014946] ata10.03: link resume succeeded after 1 retries
> [  368.149882] ata10.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  368.149916] ata10.04: hard resetting link
> [  368.552715] ata10.04: link resume succeeded after 1 retries
> [  368.687685] ata10.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  368.687740] ata10.05: hard resetting link
> [  368.992079] ata10.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> [  369.039408] ata10.01: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  369.039414] ata10.01: 625142448 sectors, multi 0: LBA48 
> [  369.097549] ata10.01: configured for UDMA/100
> [  369.134364] ata10.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  369.134370] ata10.02: 625142448 sectors, multi 0: LBA48 
> [  369.192501] ata10.02: configured for UDMA/100
> [  369.231060] ata10.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  369.231066] ata10.03: 625142448 sectors, multi 0: LBA48 
> [  369.289253] ata10.03: configured for UDMA/100
> [  369.328511] ata10.04: ATA-7: ST3320620A, 3.AAD, max UDMA/100
> [  369.328517] ata10.04: 625142448 sectors, multi 0: LBA48 
> [  369.386487] ata10.04: configured for UDMA/100
> [  369.386557] ata10: EH complete
   :
> [  394.946096] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> [  395.043631] NFSD: starting 90-second grace period
   :
------
