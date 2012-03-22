Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030947Ab2CVQQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 12:16:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59300 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab2CVQQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 12:16:25 -0400
MIME-Version: 1.0
In-Reply-To: <4F6B30D9.2070805@yahoo.co.jp>
References: <4F5ECD06.3000608@yahoo.co.jp>
	<4F5F7C4C.7080800@teksavvy.com>
	<4F662AFB.9050106@yahoo.co.jp>
	<CAMHSBOWg+rxxrVjf05r1tYDpW1S75XzdrLQ+U8TrjC9okRYtuA@mail.gmail.com>
	<4F6AAC37.7040907@yahoo.co.jp>
	<4F6B30D9.2070805@yahoo.co.jp>
Date: Thu, 22 Mar 2012 09:16:20 -0700
Message-ID: <CAMHSBOVD4wAtwAravVkDjyWV+Nwtuybt=yae=26PcGxxirw=Lg@mail.gmail.com>
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

Akira,

Now I see your problem. Indeed on ata7, ata10, we have a problem.
I notice however some messages I did not see before:
>> [    4.856382] ata7.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [    4.858742] ata7.00: hard resetting link
>> [   14.843039] ata7.00: softreset failed (timeout)
>> [   17.836402] ata7.15: qc timeout (cmd 0xe4)
The later indicates that the PMP is stuck and the host can not read
its internal register.
Is it possible that the PMP in these 4 enclosures you are using have a
different firmware than the other ones?
Firmware 1.0114 is available at:
http://www.siliconimage.com/support/searchresults.aspx?pid=26&cat=23

>From the release notes:
"""- Fix SRST and initial two RegFIS Problem."""

Gwendal.

On Thu, Mar 22, 2012 at 7:02 AM, ANEZAKI, Akira
<fireblade1230@yahoo.co.jp> wrote:
> Hello Gwendal,
>
> I attached the dmesg logs of the PC that has 6 PMPs and 38 HDDs.
> ata5 and ata6 are SiI3124. 4 HDDs are connected to each port via PMP.
> These 8 HDDs require spin up.
> From ata7 to ata10 are SiI3132. 5 HDDs are connected to each port via
> PMP. And these 20 HDDs are always spin up while power is on. All HDDs
> connected to ata5 and ata6 are identified but slow with original 3.2.x
> driver. Some of HDDs connected to ata7,..., ata10 are not identified.
> So, I deleted ata5/6 messages from logs because logs become very long.
>
> --- 3.2.10 power cycle log ( not patched ) ---
>   :
>> [    0.000000] Linux version 3.2.10-3.fc16.i686.PAE (mockbuild@x86-02.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 15 20:37:01 UTC 2012
>   :
>> [    2.728377] ata7: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff0000 irq 17
>> [    2.728381] ata8: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff2000 irq 17
>> [    2.728385] ata9: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff4000 irq 17
>> [    2.728388] ata10: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff6000 irq 17
>   :
>> [    4.856020] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [    4.856382] ata7.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [    4.858742] ata7.00: hard resetting link
>> [   14.843039] ata7.00: softreset failed (timeout)
>> [   17.836402] ata7.15: qc timeout (cmd 0xe4)
>> [   17.836418] ata7.00: failed to read SCR 0 (Emask=0x5)
>> [   17.836422] ata7.00: reset failed, giving up
>> [   17.836427] ata7.15: hard resetting link
>> [   19.963714] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   19.964339] ata7.00: hard resetting link
>> [   29.949543] ata7.00: softreset failed (timeout)
>> [   32.942886] ata7.15: qc timeout (cmd 0xe4)
>> [   32.942902] ata7.00: failed to read SCR 0 (Emask=0x5)
>> [   32.942906] ata7.00: reset failed, giving up
>> [   32.942911] ata7.15: hard resetting link
>> [   35.070205] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   35.070883] ata7.00: hard resetting link
>> [   45.055960] ata7.00: softreset failed (timeout)
>> [   48.049443] ata7.15: qc timeout (cmd 0xe4)
>> [   48.049460] ata7.00: failed to read SCR 0 (Emask=0x5)
>> [   48.049464] ata7.00: reset failed, giving up
>> [   48.049467] ata7.00: failed to recover link after 3 tries, disabling
>> [   48.049472] ata7.15: hard resetting link
>> [   50.176735] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   50.481193] ata7.01: hard resetting link
>> [   50.884173] ata7.01: link resume succeeded after 1 retries
>> [   50.996894] ata7.01: softreset failed (SRST command error)
>> [   50.996972] ata7.01: failed to read SCR 0 (Emask=0x1)
>> [   50.996978] ata7.01: reset failed (errno=-85), retrying in 10 secs
>> [   60.459007] ata7.01: reset failed, giving up
>> [   60.459013] ata7.15: hard resetting link
>> [   62.575241] ata7.15: softreset failed (SRST command error)
>> [   62.575247] ata7.15: reset failed (errno=-5), retrying in 8 secs
>> [   70.436781] ata7.15: hard resetting link
>> [   72.553168] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   72.553176] ata7.15: PMP revalidation failed (errno=-19)
>> [   77.542029] ata7.15: hard resetting link
>> [   79.669334] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   79.973812] ata7.01: hard resetting link
>> [   80.376789] ata7.01: link resume succeeded after 1 retries
>> [   80.489507] ata7.01: softreset failed (SRST command error)
>> [   80.489553] ata7.01: failed to read SCR 0 (Emask=0x1)
>> [   80.489559] ata7.01: reset failed (errno=-85), retrying in 10 secs
>> [   89.951587] ata7.01: reset failed, giving up
>> [   89.951594] ata7.15: hard resetting link
>> [   92.067853] ata7.15: softreset failed (SRST command error)
>> [   92.067859] ata7.15: reset failed (errno=-5), retrying in 8 secs
>> [   99.929408] ata7.15: hard resetting link
>> [  102.045764] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  102.045772] ata7.15: PMP revalidation failed (errno=-19)
>> [  107.034803] ata7.15: hard resetting link
>> [  109.161947] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  109.466423] ata7.01: hard resetting link
>> [  109.869323] ata7.01: link resume succeeded after 1 retries
>> [  110.091871] ata7.01: softreset failed (SRST command error)
>> [  110.091987] ata7.01: failed to read SCR 0 (Emask=0x1)
>> [  110.091993] ata7.01: reset failed (errno=-85), retrying in 10 secs
>> [  119.444232] ata7.01: reset failed, giving up
>> [  119.444238] ata7.01: failed to recover link after 3 tries, disabling
>> [  119.444243] ata7.15: hard resetting link
>> [  119.444247] ata7: controller in dubious state, performing PORT_RST
>> [  121.593366] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  122.300882] ata7.01: link resume succeeded after 1 retries
>> [  122.402786] ata7.02: hard resetting link
>> [  122.805748] ata7.02: link resume succeeded after 1 retries
>> [  123.028249] ata7.02: softreset failed (SRST command error)
>> [  123.127975] ata7.02: failed to read SCR 0 (Emask=0x1)
>> [  123.127981] ata7.02: reset failed (errno=-85), retrying in 10 secs
>> [  132.380480] ata7.02: reset failed, giving up
>> [  132.380487] ata7.15: hard resetting link
>> [  132.380492] ata7: controller in dubious state, performing PORT_RST
>> [  134.529730] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  135.237187] ata7.01: link resume succeeded after 1 retries
>> [  135.339040] ata7.02: hard resetting link
>> [  135.742069] ata7.02: link resume succeeded after 1 retries
>> [  135.854773] ata7.02: softreset failed (SRST command error)
>> [  135.964517] ata7.02: failed to read SCR 0 (Emask=0x1)
>> [  135.964523] ata7.02: reset failed (errno=-85), retrying in 10 secs
>> [  145.316864] ata7.02: reset failed, giving up
>> [  145.316870] ata7.15: hard resetting link
>> [  145.316874] ata7: controller in dubious state, performing PORT_RST
>> [  147.466039] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  148.173548] ata7.01: link resume succeeded after 1 retries
>> [  148.275398] ata7.02: hard resetting link
>> [  148.678350] ata7.02: link resume succeeded after 1 retries
>> [  148.791012] ata7.02: softreset failed (SRST command error)
>> [  148.791027] ata7.02: failed to read SCR 0 (Emask=0x40)
>> [  148.791031] ata7.02: reset failed (errno=-85), retrying in 10 secs
>> [  158.253189] ata7.02: reset failed, giving up
>> [  158.253194] ata7.02: failed to recover link after 3 tries, disabling
>> [  158.253200] ata7.15: hard resetting link
>> [  160.369472] ata7.15: softreset failed (SRST command error)
>> [  160.369479] ata7.15: reset failed (errno=-5), retrying in 8 secs
>> [  168.230986] ata7.15: hard resetting link
>> [  170.347310] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  170.347320] ata7.15: PMP revalidation failed (errno=-19)
>> [  175.336294] ata7.15: hard resetting link
>> [  177.463536] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  178.171042] ata7.01: link resume succeeded after 1 retries
>> [  178.675862] ata7.02: link resume succeeded after 1 retries
>> [  178.777741] ata7.03: hard resetting link
>> [  179.180751] ata7.03: link resume succeeded after 1 retries
>> [  179.326643] ata7.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  179.326676] ata7.04: hard resetting link
>> [  179.729532] ata7.04: link resume succeeded after 1 retries
>> [  179.842249] ata7.04: softreset failed (SRST command error)
>> [  179.842266] ata7.04: failed to read SCR 0 (Emask=0x40)
>> [  179.842271] ata7.04: reset failed (errno=-85), retrying in 10 secs
>> [  189.304267] ata7.04: reset failed, giving up
>> [  189.304274] ata7.15: hard resetting link
>> [  191.420632] ata7.15: softreset failed (SRST command error)
>> [  191.420638] ata7.15: reset failed (errno=-5), retrying in 8 secs
>> [  199.282157] ata7.15: hard resetting link
>> [  201.398523] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  201.398530] ata7.15: PMP revalidation failed (errno=-19)
>> [  206.387708] ata7.15: hard resetting link
>> [  208.514709] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  209.222203] ata7.01: link resume succeeded after 1 retries
>> [  209.727084] ata7.02: link resume succeeded after 1 retries
>> [  209.828920] ata7.03: hard resetting link
>> [  210.231971] ata7.03: link resume succeeded after 1 retries
>> [  210.366787] ata7.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  210.366845] ata7.04: hard resetting link
>> [  210.769750] ata7.04: link resume succeeded after 1 retries
>> [  210.882448] ata7.04: softreset failed (SRST command error)
>> [  210.992171] ata7.04: failed to read SCR 0 (Emask=0x1)
>> [  210.992178] ata7.04: reset failed (errno=-85), retrying in 10 secs
>> [  220.344472] ata7.04: reset failed, giving up
>> [  220.344480] ata7.15: hard resetting link
>> [  220.344485] ata7: controller in dubious state, performing PORT_RST
>> [  222.493730] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  223.201162] ata7.01: link resume succeeded after 1 retries
>> [  223.706048] ata7.02: link resume succeeded after 1 retries
>> [  223.807935] ata7.03: hard resetting link
>> [  224.210944] ata7.03: link resume succeeded after 1 retries
>> [  224.357054] ata7.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  224.357092] ata7.04: hard resetting link
>> [  224.759727] ata7.04: link resume succeeded after 1 retries
>> [  224.872381] ata7.04: softreset failed (SRST command error)
>> [  224.982171] ata7.04: failed to read SCR 0 (Emask=0x1)
>> [  224.982177] ata7.04: reset failed (errno=-85), retrying in 10 secs
>> [  234.334455] ata7.04: reset failed, giving up
>> [  234.334460] ata7.04: failed to recover link after 3 tries, disabling
>> [  234.334466] ata7.15: hard resetting link
>> [  234.334470] ata7: controller in dubious state, performing PORT_RST
>> [  236.483626] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  237.191170] ata7.01: link resume succeeded after 1 retries
>> [  237.696026] ata7.02: link resume succeeded after 1 retries
>> [  238.200931] ata7.04: link resume succeeded after 1 retries
>> [  238.302815] ata7.03: hard resetting link
>> [  238.705815] ata7.03: link resume succeeded after 1 retries
>> [  238.851663] ata7.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  238.851697] ata7.05: hard resetting link
>> [  239.156074] ata7.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [  239.171748] ata7.03: ATA-7: WDC WD2500BB-22RDA0, 20.00K20, max UDMA/100
>> [  239.171755] ata7.03: 488397168 sectors, multi 0: LBA48
>> [  239.172994] ata7.03: configured for UDMA/100
>> [  239.173063] ata7: EH complete
>> [  241.301015] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  241.301401] ata8.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [  241.304393] ata8.00: hard resetting link
>> [  251.288864] ata8.00: softreset failed (timeout)
>> [  254.282482] ata8.15: qc timeout (cmd 0xe4)
>> [  254.282498] ata8.00: failed to read SCR 0 (Emask=0x5)
>> [  254.282502] ata8.00: reset failed, giving up
>> [  254.282507] ata8.15: hard resetting link
>> [  256.308766] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  256.309087] ata8.00: hard resetting link
>> [  266.294599] ata8.00: softreset failed (timeout)
>> [  269.287996] ata8.15: qc timeout (cmd 0xe4)
>> [  269.288012] ata8.00: failed to read SCR 0 (Emask=0x5)
>> [  269.288016] ata8.00: reset failed, giving up
>> [  269.288021] ata8.15: hard resetting link
>> [  271.415256] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  271.415676] ata8.00: hard resetting link
>> [  281.400112] ata8.00: softreset failed (timeout)
>> [  284.393557] ata8.15: qc timeout (cmd 0xe4)
>> [  284.393574] ata8.00: failed to read SCR 0 (Emask=0x5)
>> [  284.393578] ata8.00: reset failed, giving up
>> [  284.393581] ata8.00: failed to recover link after 3 tries, disabling
>> [  284.393586] ata8.15: hard resetting link
>> [  286.520673] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  286.825285] ata8.01: hard resetting link
>> [  287.228273] ata8.01: link resume succeeded after 1 retries
>> [  287.340950] ata8.01: softreset failed (SRST command error)
>> [  287.341009] ata8.01: failed to read SCR 0 (Emask=0x1)
>> [  287.341014] ata8.01: reset failed (errno=-85), retrying in 10 secs
>> [  296.802999] ata8.01: reset failed, giving up
>> [  296.803006] ata8.15: hard resetting link
>> [  298.919298] ata8.15: softreset failed (SRST command error)
>> [  298.919304] ata8.15: reset failed (errno=-5), retrying in 8 secs
>> [  306.780857] ata8.15: hard resetting link
>> [  308.897206] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  308.897213] ata8.15: PMP revalidation failed (errno=-19)
>> [  313.886328] ata8.15: hard resetting link
>> [  316.013386] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  316.317852] ata8.01: hard resetting link
>> [  316.720861] ata8.01: link resume succeeded after 1 retries
>> [  316.833555] ata8.01: softreset failed (SRST command error)
>> [  316.943305] ata8.01: failed to read SCR 0 (Emask=0x1)
>> [  316.943310] ata8.01: reset failed (errno=-85), retrying in 10 secs
>> [  326.295601] ata8.01: reset failed, giving up
>> [  326.295609] ata8.15: hard resetting link
>> [  326.295614] ata8: controller in dubious state, performing PORT_RST
>> [  328.444830] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  328.749267] ata8.01: hard resetting link
>> [  329.152302] ata8.01: link resume succeeded after 1 retries
>> [  329.264987] ata8.01: softreset failed (SRST command error)
>> [  329.374746] ata8.01: failed to read SCR 0 (Emask=0x1)
>> [  329.374751] ata8.01: reset failed (errno=-85), retrying in 10 secs
>> [  338.727034] ata8.01: reset failed, giving up
>> [  338.727039] ata8.01: failed to recover link after 3 tries, disabling
>> [  338.727045] ata8.15: hard resetting link
>> [  338.727048] ata8: controller in dubious state, performing PORT_RST
>> [  340.876275] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  341.583749] ata8.01: link resume succeeded after 1 retries
>> [  341.685751] ata8.02: hard resetting link
>> [  342.088629] ata8.02: link resume succeeded after 1 retries
>> [  342.223408] ata8.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  342.223441] ata8.03: hard resetting link
>> [  342.626462] ata8.03: link resume succeeded after 1 retries
>> [  342.761370] ata8.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  342.761404] ata8.04: hard resetting link
>> [  343.076391] ata8.04: softreset failed (SRST command error)
>> [  343.076449] ata8.04: failed to read SCR 0 (Emask=0x1)
>> [  343.076455] ata8.04: reset failed (errno=-85), retrying in 10 secs
>> [  352.738995] ata8.04: reset failed, giving up
>> [  352.739001] ata8.15: hard resetting link
>> [  354.855321] ata8.15: softreset failed (SRST command error)
>> [  354.855327] ata8.15: reset failed (errno=-5), retrying in 8 secs
>> [  362.716861] ata8.15: hard resetting link
>> [  364.834209] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  364.834217] ata8.15: PMP revalidation failed (errno=-19)
>> [  369.823118] ata8.15: hard resetting link
>> [  371.950402] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  372.657852] ata8.01: link resume succeeded after 1 retries
>> [  372.759682] ata8.02: hard resetting link
>> [  373.162733] ata8.02: link resume succeeded after 1 retries
>> [  373.297762] ata8.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  373.297795] ata8.03: hard resetting link
>> [  373.700539] ata8.03: link resume succeeded after 1 retries
>> [  373.835515] ata8.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  373.835549] ata8.04: hard resetting link
>> [  374.150481] ata8.04: softreset failed (SRST command error)
>> [  374.150528] ata8.04: failed to read SCR 0 (Emask=0x1)
>> [  374.150533] ata8.04: reset failed (errno=-85), retrying in 10 secs
>> [  383.813191] ata8.04: reset failed, giving up
>> [  383.813198] ata8.15: hard resetting link
>> [  385.929331] ata8.15: softreset failed (SRST command error)
>> [  385.929337] ata8.15: reset failed (errno=-5), retrying in 8 secs
>> [  393.790968] ata8.15: hard resetting link
>> [  395.907164] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  395.907172] ata8.15: PMP revalidation failed (errno=-19)
>> [  400.896325] ata8.15: hard resetting link
>> [  403.023517] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  403.731005] ata8.01: link resume succeeded after 1 retries
>> [  403.832842] ata8.02: hard resetting link
>> [  404.235865] ata8.02: link resume succeeded after 1 retries
>> [  404.370794] ata8.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  404.370849] ata8.03: hard resetting link
>> [  404.773633] ata8.03: link resume succeeded after 1 retries
>> [  404.908669] ata8.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  404.908703] ata8.04: hard resetting link
>> [  405.223579] ata8.04: softreset failed (SRST command error)
>> [  405.333350] ata8.04: failed to read SCR 0 (Emask=0x1)
>> [  405.333356] ata8.04: reset failed (errno=-85), retrying in 10 secs
>> [  414.886197] ata8.04: reset failed, giving up
>> [  414.886202] ata8.04: failed to recover link after 3 tries, disabling
>> [  414.886208] ata8.15: hard resetting link
>> [  414.886211] ata8: controller in dubious state, performing PORT_RST
>> [  417.035450] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  417.742943] ata8.01: link resume succeeded after 1 retries
>> [  418.247823] ata8.04: link resume succeeded after 1 retries
>> [  418.349670] ata8.02: hard resetting link
>> [  418.752703] ata8.02: link resume succeeded after 1 retries
>> [  418.887633] ata8.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  418.887669] ata8.03: hard resetting link
>> [  419.290512] ata8.03: link resume succeeded after 1 retries
>> [  419.425418] ata8.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  419.425451] ata8.05: hard resetting link
>> [  419.729769] ata8.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [  419.774605] ata8.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  419.774611] ata8.02: 625142448 sectors, multi 0: LBA48
>> [  419.774617] ata8.02: applying bridge limits
>> [  419.832687] ata8.02: configured for UDMA/100
>> [  419.873220] ata8.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  419.873226] ata8.03: 625142448 sectors, multi 0: LBA48
>> [  419.931259] ata8.03: configured for UDMA/100
>> [  419.931327] ata8: EH complete
>> [  422.060283] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  422.060785] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [  422.064165] ata9.00: hard resetting link
>> [  432.051137] ata9.00: softreset failed (timeout)
>> [  435.044561] ata9.15: qc timeout (cmd 0xe4)
>> [  435.044578] ata9.00: failed to read SCR 0 (Emask=0x5)
>> [  435.044582] ata9.00: reset failed, giving up
>> [  435.044587] ata9.15: hard resetting link
>> [  437.171811] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  437.172249] ata9.00: hard resetting link
>> [  447.156648] ata9.00: softreset failed (timeout)
>> [  450.149961] ata9.15: qc timeout (cmd 0xe4)
>> [  450.149979] ata9.00: failed to read SCR 0 (Emask=0x5)
>> [  450.149985] ata9.00: reset failed, giving up
>> [  450.149992] ata9.15: hard resetting link
>> [  452.277364] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  452.277711] ata9.00: hard resetting link
>> [  462.262159] ata9.00: softreset failed (timeout)
>> [  465.255619] ata9.15: qc timeout (cmd 0xe4)
>> [  465.255635] ata9.00: failed to read SCR 0 (Emask=0x5)
>> [  465.255639] ata9.00: reset failed, giving up
>> [  465.255643] ata9.00: failed to recover link after 3 tries, disabling
>> [  465.255648] ata9.15: hard resetting link
>> [  467.382834] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  467.688287] ata9.01: hard resetting link
>> [  468.091305] ata9.01: link resume succeeded after 1 retries
>> [  468.226246] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  468.226301] ata9.02: hard resetting link
>> [  468.629118] ata9.02: link resume succeeded after 1 retries
>> [  468.764014] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  468.764047] ata9.03: hard resetting link
>> [  469.166941] ata9.03: link resume succeeded after 1 retries
>> [  469.301843] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  469.301877] ata9.04: hard resetting link
>> [  469.704728] ata9.04: link resume succeeded after 1 retries
>> [  469.927155] ata9.04: softreset failed (SRST command error)
>> [  469.927269] ata9.04: failed to read SCR 0 (Emask=0x1)
>> [  469.927275] ata9.04: reset failed (errno=-85), retrying in 10 secs
>> [  479.279534] ata9.04: reset failed, giving up
>> [  479.279540] ata9.15: hard resetting link
>> [  479.279544] ata9: controller in dubious state, performing PORT_RST
>> [  481.428685] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  481.733166] ata9.01: hard resetting link
>> [  482.136168] ata9.01: link resume succeeded after 1 retries
>> [  482.271032] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  482.271066] ata9.02: hard resetting link
>> [  482.673977] ata9.02: link resume succeeded after 1 retries
>> [  482.808905] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  482.808938] ata9.03: hard resetting link
>> [  483.211797] ata9.03: link resume succeeded after 1 retries
>> [  483.346679] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  483.346735] ata9.04: hard resetting link
>> [  483.749592] ata9.04: link resume succeeded after 1 retries
>> [  483.862225] ata9.04: softreset failed (SRST command error)
>> [  483.862301] ata9.04: failed to read SCR 0 (Emask=0x1)
>> [  483.862306] ata9.04: reset failed (errno=-85), retrying in 10 secs
>> [  493.324567] ata9.04: reset failed, giving up
>> [  493.324574] ata9.15: hard resetting link
>> [  495.440632] ata9.15: softreset failed (SRST command error)
>> [  495.440638] ata9.15: reset failed (errno=-5), retrying in 8 secs
>> [  503.302208] ata9.15: hard resetting link
>> [  505.418541] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  505.418549] ata9.15: PMP revalidation failed (errno=-19)
>> [  510.407473] ata9.15: hard resetting link
>> [  512.534721] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  512.839192] ata9.01: hard resetting link
>> [  513.242191] ata9.01: link resume succeeded after 1 retries
>> [  513.377113] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  513.377168] ata9.02: hard resetting link
>> [  513.779948] ata9.02: link resume succeeded after 1 retries
>> [  513.914918] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  513.914951] ata9.03: hard resetting link
>> [  514.317810] ata9.03: link resume succeeded after 1 retries
>> [  514.452725] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  514.452759] ata9.04: hard resetting link
>> [  514.855616] ata9.04: link resume succeeded after 1 retries
>> [  514.968324] ata9.04: softreset failed (SRST command error)
>> [  515.078062] ata9.04: failed to read SCR 0 (Emask=0x1)
>> [  515.078068] ata9.04: reset failed (errno=-85), retrying in 10 secs
>> [  524.430341] ata9.04: reset failed, giving up
>> [  524.430346] ata9.04: failed to recover link after 3 tries, disabling
>> [  524.430352] ata9.15: hard resetting link
>> [  524.430355] ata9: controller in dubious state, performing PORT_RST
>> [  526.579506] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  527.287026] ata9.04: link resume succeeded after 1 retries
>> [  527.388982] ata9.01: hard resetting link
>> [  527.791958] ata9.01: link resume succeeded after 1 retries
>> [  527.926873] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  527.926906] ata9.02: hard resetting link
>> [  528.329747] ata9.02: link resume succeeded after 1 retries
>> [  528.464667] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  528.464723] ata9.03: hard resetting link
>> [  528.867555] ata9.03: link resume succeeded after 1 retries
>> [  529.002500] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  529.002537] ata9.05: hard resetting link
>> [  529.306850] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [  529.349846] ata9.01: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  529.349852] ata9.01: 625142448 sectors, multi 0: LBA48
>> [  529.349858] ata9.01: applying bridge limits
>> [  529.407928] ata9.01: configured for UDMA/100
>> [  529.454790] ata9.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  529.454796] ata9.02: 625142448 sectors, multi 0: LBA48
>> [  529.454802] ata9.02: applying bridge limits
>> [  529.512845] ata9.02: configured for UDMA/100
>> [  529.557037] ata9.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  529.557043] ata9.03: 625142448 sectors, multi 0: LBA48
>> [  529.557049] ata9.03: applying bridge limits
>> [  529.615208] ata9.03: configured for UDMA/100
>> [  529.615276] ata9: EH complete
>> [  531.745132] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  531.745518] ata10.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [  531.748378] ata10.00: hard resetting link
>> [  541.732981] ata10.00: softreset failed (timeout)
>> [  544.726484] ata10.15: qc timeout (cmd 0xe4)
>> [  544.726500] ata10.00: failed to read SCR 0 (Emask=0x5)
>> [  544.726504] ata10.00: reset failed, giving up
>> [  544.726509] ata10.15: hard resetting link
>> [  546.853639] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  546.854296] ata10.00: hard resetting link
>> [  556.839495] ata10.00: softreset failed (timeout)
>> [  559.832859] ata10.15: qc timeout (cmd 0xe4)
>> [  559.832875] ata10.00: failed to read SCR 0 (Emask=0x5)
>> [  559.832879] ata10.00: reset failed, giving up
>> [  559.832884] ata10.15: hard resetting link
>> [  561.960149] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  561.960603] ata10.00: hard resetting link
>> [  571.944967] ata10.00: softreset failed (timeout)
>> [  574.938480] ata10.15: qc timeout (cmd 0xe4)
>> [  574.938496] ata10.00: failed to read SCR 0 (Emask=0x5)
>> [  574.938500] ata10.00: reset failed, giving up
>> [  574.938504] ata10.00: failed to recover link after 3 tries, disabling
>> [  574.938509] ata10.15: hard resetting link
>> [  577.065685] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  577.370126] ata10.01: hard resetting link
>> [  577.773138] ata10.01: link resume succeeded after 1 retries
>> [  577.908044] ata10.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  577.908100] ata10.02: hard resetting link
>> [  578.310944] ata10.02: link resume succeeded after 1 retries
>> [  578.445975] ata10.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  578.446011] ata10.03: hard resetting link
>> [  578.848752] ata10.03: link resume succeeded after 1 retries
>> [  578.983663] ata10.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  578.983696] ata10.04: hard resetting link
>> [  579.386604] ata10.04: link resume succeeded after 1 retries
>> [  579.521504] ata10.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  579.521537] ata10.05: hard resetting link
>> [  579.825806] ata10.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [  579.867413] ata10.01: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  579.867419] ata10.01: 625142448 sectors, multi 0: LBA48
>> [  579.925564] ata10.01: configured for UDMA/100
>> [  579.976084] ata10.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  579.976093] ata10.02: 625142448 sectors, multi 0: LBA48
>> [  580.034256] ata10.02: configured for UDMA/100
>> [  580.079872] ata10.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  580.079880] ata10.03: 625142448 sectors, multi 0: LBA48
>> [  580.138089] ata10.03: configured for UDMA/100
>> [  580.181012] ata10.04: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  580.181018] ata10.04: 625142448 sectors, multi 0: LBA48
>> [  580.238994] ata10.04: configured for UDMA/100
>> [  580.239060] ata10: EH complete
>   :
>> [  673.269722] systemd[1]: Startup finished in 2s 215ms 631us (kernel) + 9min 41s 253ms 808us (initrd) + 1min 31s 95ms 965us (userspace) = 11min 14s 565ms 404us.
> --------
>
> --- 3.2.10 warm reset log ( not patched ) ---
>   :
>> [    0.000000] Linux version 3.2.10-3.fc16.i686.PAE (mockbuild@x86-02.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 15 20:37:01 UTC 2012
>   :
>> [    2.728305] ata7: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff0000 irq 17
>> [    2.728309] ata8: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff2000 irq 17
>> [    2.728313] ata9: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff4000 irq 17
>> [    2.728317] ata10: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff6000 irq 17
>   :
>> [    4.857114] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [    4.857429] ata7.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [    4.860366] ata7.00: hard resetting link
>> [   14.847053] ata7.00: softreset failed (timeout)
>> [   17.840588] ata7.15: qc timeout (cmd 0xe4)
>> [   17.840605] ata7.00: failed to read SCR 0 (Emask=0x5)
>> [   17.840609] ata7.00: reset failed, giving up
>> [   17.840614] ata7.15: hard resetting link
>> [   19.967586] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   19.967961] ata7.00: hard resetting link
>> [   29.952563] ata7.00: softreset failed (timeout)
>> [   32.946005] ata7.15: qc timeout (cmd 0xe4)
>> [   32.946021] ata7.00: failed to read SCR 0 (Emask=0x5)
>> [   32.946025] ata7.00: reset failed, giving up
>> [   32.946030] ata7.15: hard resetting link
>> [   35.073261] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   35.073643] ata7.00: hard resetting link
>> [   45.058071] ata7.00: softreset failed (timeout)
>> [   48.051483] ata7.15: qc timeout (cmd 0xe4)
>> [   48.051499] ata7.00: failed to read SCR 0 (Emask=0x5)
>> [   48.051503] ata7.00: reset failed, giving up
>> [   48.051507] ata7.00: failed to recover link after 3 tries, disabling
>> [   48.051512] ata7.15: hard resetting link
>> [   50.178736] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   50.483203] ata7.01: hard resetting link
>> [   50.886209] ata7.01: link resume succeeded after 1 retries
>> [   51.108651] ata7.01: softreset failed (SRST command error)
>> [   51.108762] ata7.01: failed to read SCR 0 (Emask=0x1)
>> [   51.108768] ata7.01: reset failed (errno=-85), retrying in 10 secs
>> [   60.460919] ata7.01: reset failed, giving up
>> [   60.460925] ata7.15: hard resetting link
>> [   60.460929] ata7: controller in dubious state, performing PORT_RST
>> [   62.610196] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   62.914676] ata7.01: hard resetting link
>> [   63.317656] ata7.01: link resume succeeded after 1 retries
>> [   63.540078] ata7.01: softreset failed (SRST command error)
>> [   63.540189] ata7.01: failed to read SCR 0 (Emask=0x1)
>> [   63.540195] ata7.01: reset failed (errno=-85), retrying in 10 secs
>> [   72.892375] ata7.01: reset failed, giving up
>> [   72.892381] ata7.15: hard resetting link
>> [   72.892385] ata7: controller in dubious state, performing PORT_RST
>> [   75.041637] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   75.346105] ata7.01: hard resetting link
>> [   75.749094] ata7.01: link resume succeeded after 1 retries
>> [   75.861794] ata7.01: softreset failed (SRST command error)
>> [   75.971535] ata7.01: failed to read SCR 0 (Emask=0x1)
>> [   75.971541] ata7.01: reset failed (errno=-85), retrying in 10 secs
>> [   85.323801] ata7.01: reset failed, giving up
>> [   85.323806] ata7.01: failed to recover link after 3 tries, disabling
>> [   85.323812] ata7.15: hard resetting link
>> [   85.323815] ata7: controller in dubious state, performing PORT_RST
>> [   87.473057] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   88.180573] ata7.01: link resume succeeded after 1 retries
>> [   88.282411] ata7.02: hard resetting link
>> [   88.685408] ata7.02: link resume succeeded after 1 retries
>> [   88.907856] ata7.02: softreset failed (SRST command error)
>> [   89.017611] ata7.02: failed to read SCR 0 (Emask=0x1)
>> [   89.017617] ata7.02: reset failed (errno=-85), retrying in 10 secs
>> [   98.260156] ata7.02: reset failed, giving up
>> [   98.260162] ata7.15: hard resetting link
>> [   98.260166] ata7: controller in dubious state, performing PORT_RST
>> [  100.409394] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  101.116820] ata7.01: link resume succeeded after 1 retries
>> [  101.218781] ata7.02: hard resetting link
>> [  101.621721] ata7.02: link resume succeeded after 1 retries
>> [  101.734438] ata7.02: softreset failed (SRST command error)
>> [  101.734497] ata7.02: failed to read SCR 0 (Emask=0x1)
>> [  101.734503] ata7.02: reset failed (errno=-85), retrying in 10 secs
>> [  111.196658] ata7.02: reset failed, giving up
>> [  111.196665] ata7.15: hard resetting link
>> [  113.312791] ata7.15: softreset failed (SRST command error)
>> [  113.312796] ata7.15: reset failed (errno=-5), retrying in 8 secs
>> [  121.174424] ata7.15: hard resetting link
>> [  123.290728] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  123.290735] ata7.15: PMP revalidation failed (errno=-19)
>> [  128.279611] ata7.15: hard resetting link
>> [  130.406891] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  131.114346] ata7.01: link resume succeeded after 1 retries
>> [  131.216223] ata7.02: hard resetting link
>> [  131.619242] ata7.02: link resume succeeded after 1 retries
>> [  131.841674] ata7.02: softreset failed (SRST command error)
>> [  131.841789] ata7.02: failed to read SCR 0 (Emask=0x1)
>> [  131.841795] ata7.02: reset failed (errno=-85), retrying in 10 secs
>> [  141.194111] ata7.02: reset failed, giving up
>> [  141.194116] ata7.02: failed to recover link after 3 tries, disabling
>> [  141.194122] ata7.15: hard resetting link
>> [  141.194126] ata7: controller in dubious state, performing PORT_RST
>> [  143.343218] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  144.050671] ata7.01: link resume succeeded after 1 retries
>> [  144.555590] ata7.02: link resume succeeded after 1 retries
>> [  144.657379] ata7.03: hard resetting link
>> [  145.060433] ata7.03: link resume succeeded after 1 retries
>> [  145.206413] ata7.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  145.206446] ata7.04: hard resetting link
>> [  145.609232] ata7.04: link resume succeeded after 1 retries
>> [  145.721921] ata7.04: softreset failed (SRST command error)
>> [  145.721997] ata7.04: failed to read SCR 0 (Emask=0x1)
>> [  145.722003] ata7.04: reset failed (errno=-85), retrying in 10 secs
>> [  155.184070] ata7.04: reset failed, giving up
>> [  155.184076] ata7.15: hard resetting link
>> [  157.300201] ata7.15: softreset failed (SRST command error)
>> [  157.300206] ata7.15: reset failed (errno=-5), retrying in 8 secs
>> [  165.161929] ata7.15: hard resetting link
>> [  167.278086] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  167.278094] ata7.15: PMP revalidation failed (errno=-19)
>> [  172.267085] ata7.15: hard resetting link
>> [  174.394357] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  175.101835] ata7.01: link resume succeeded after 1 retries
>> [  175.606735] ata7.02: link resume succeeded after 1 retries
>> [  175.708593] ata7.03: hard resetting link
>> [  176.111610] ata7.03: link resume succeeded after 1 retries
>> [  176.257481] ata7.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  176.257514] ata7.04: hard resetting link
>> [  176.660366] ata7.04: link resume succeeded after 1 retries
>> [  176.882825] ata7.04: softreset failed (SRST command error)
>> [  176.882943] ata7.04: failed to read SCR 0 (Emask=0x1)
>> [  176.882948] ata7.04: reset failed (errno=-85), retrying in 10 secs
>> [  186.235215] ata7.04: reset failed, giving up
>> [  186.235221] ata7.15: hard resetting link
>> [  186.235225] ata7: controller in dubious state, performing PORT_RST
>> [  188.384387] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  189.091824] ata7.01: link resume succeeded after 1 retries
>> [  189.596721] ata7.02: link resume succeeded after 1 retries
>> [  189.698575] ata7.03: hard resetting link
>> [  190.101579] ata7.03: link resume succeeded after 1 retries
>> [  190.236540] ata7.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  190.236573] ata7.04: hard resetting link
>> [  190.639411] ata7.04: link resume succeeded after 1 retries
>> [  190.861835] ata7.04: softreset failed (SRST command error)
>> [  190.861952] ata7.04: failed to read SCR 0 (Emask=0x1)
>> [  190.861958] ata7.04: reset failed (errno=-85), retrying in 10 secs
>> [  200.214230] ata7.04: reset failed, giving up
>> [  200.214235] ata7.04: failed to recover link after 3 tries, disabling
>> [  200.214241] ata7.15: hard resetting link
>> [  200.214245] ata7: controller in dubious state, performing PORT_RST
>> [  202.363386] ata7.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  203.070830] ata7.01: link resume succeeded after 1 retries
>> [  203.575726] ata7.02: link resume succeeded after 1 retries
>> [  204.080613] ata7.04: link resume succeeded after 1 retries
>> [  204.182486] ata7.03: hard resetting link
>> [  204.585489] ata7.03: link resume succeeded after 1 retries
>> [  204.731415] ata7.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  204.731470] ata7.05: hard resetting link
>> [  205.035777] ata7.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [  205.048761] ata7.03: ATA-7: WDC WD2500BB-22RDA0, 20.00K20, max UDMA/100
>> [  205.048767] ata7.03: 488397168 sectors, multi 0: LBA48
>> [  205.050024] ata7.03: configured for UDMA/100
>> [  205.050091] ata7: EH complete
>> [  207.178745] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  207.179371] ata8.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [  207.182429] ata8.00: hard resetting link
>> [  217.168525] ata8.00: softreset failed (timeout)
>> [  220.161929] ata8.15: qc timeout (cmd 0xe4)
>> [  220.161945] ata8.00: failed to read SCR 0 (Emask=0x5)
>> [  220.161949] ata8.00: reset failed, giving up
>> [  220.161954] ata8.15: hard resetting link
>> [  222.289193] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  222.289669] ata8.00: hard resetting link
>> [  232.274042] ata8.00: softreset failed (timeout)
>> [  235.267413] ata8.15: qc timeout (cmd 0xe4)
>> [  235.267430] ata8.00: failed to read SCR 0 (Emask=0x5)
>> [  235.267434] ata8.00: reset failed, giving up
>> [  235.267439] ata8.15: hard resetting link
>> [  237.394721] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  237.395117] ata8.00: hard resetting link
>> [  247.381547] ata8.00: softreset failed (timeout)
>> [  250.375186] ata8.15: qc timeout (cmd 0xe4)
>> [  250.375202] ata8.00: failed to read SCR 0 (Emask=0x5)
>> [  250.375206] ata8.00: reset failed, giving up
>> [  250.375210] ata8.00: failed to recover link after 3 tries, disabling
>> [  250.375215] ata8.15: hard resetting link
>> [  252.502205] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  252.806698] ata8.01: hard resetting link
>> [  253.209687] ata8.01: link resume succeeded after 1 retries
>> [  253.322366] ata8.01: softreset failed (SRST command error)
>> [  253.432126] ata8.01: failed to read SCR 0 (Emask=0x1)
>> [  253.432132] ata8.01: reset failed (errno=-85), retrying in 10 secs
>> [  262.784386] ata8.01: reset failed, giving up
>> [  262.784393] ata8.15: hard resetting link
>> [  262.784396] ata8: controller in dubious state, performing PORT_RST
>> [  264.933544] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  265.238130] ata8.01: hard resetting link
>> [  265.641134] ata8.01: link resume succeeded after 1 retries
>> [  265.863530] ata8.01: softreset failed (SRST command error)
>> [  265.863649] ata8.01: failed to read SCR 0 (Emask=0x1)
>> [  265.863656] ata8.01: reset failed (errno=-85), retrying in 10 secs
>> [  275.215940] ata8.01: reset failed, giving up
>> [  275.215947] ata8.15: hard resetting link
>> [  275.215950] ata8: controller in dubious state, performing PORT_RST
>> [  277.365109] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  277.669544] ata8.01: hard resetting link
>> [  278.072561] ata8.01: link resume succeeded after 1 retries
>> [  278.185268] ata8.01: softreset failed (SRST command error)
>> [  278.185345] ata8.01: failed to read SCR 0 (Emask=0x1)
>> [  278.185350] ata8.01: reset failed (errno=-85), retrying in 10 secs
>> [  287.647375] ata8.01: reset failed, giving up
>> [  287.647380] ata8.01: failed to recover link after 3 tries, disabling
>> [  287.647386] ata8.15: hard resetting link
>> [  289.763635] ata8.15: softreset failed (SRST command error)
>> [  289.763641] ata8.15: reset failed (errno=-5), retrying in 8 secs
>> [  297.625370] ata8.15: hard resetting link
>> [  299.741510] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  299.741517] ata8.15: PMP revalidation failed (errno=-19)
>> [  304.730436] ata8.15: hard resetting link
>> [  306.857730] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  307.565198] ata8.01: link resume succeeded after 1 retries
>> [  307.667104] ata8.02: hard resetting link
>> [  308.070064] ata8.02: link resume succeeded after 1 retries
>> [  308.204919] ata8.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  308.204959] ata8.03: hard resetting link
>> [  308.607881] ata8.03: link resume succeeded after 1 retries
>> [  308.742869] ata8.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  308.742925] ata8.04: hard resetting link
>> [  309.167567] ata8.04: softreset failed (SRST command error)
>> [  309.167683] ata8.04: failed to read SCR 0 (Emask=0x1)
>> [  309.167689] ata8.04: reset failed (errno=-85), retrying in 10 secs
>> [  318.720492] ata8.04: reset failed, giving up
>> [  318.720498] ata8.15: hard resetting link
>> [  318.720502] ata8: controller in dubious state, performing PORT_RST
>> [  320.869657] ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  321.577152] ata8.01: link resume succeeded after 1 retries
>> [  321.679005] ata8.02: hard resetting link
>> [  322.081996] ata8.02: link resume succeeded after 1 retries
>> [  322.216966] ata8.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  322.216999] ata8.03: hard resetting link
>> [  322.619825] ata8.03: link resume succeeded after 1 retries
>> [  322.754896] ata8.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  322.754930] ata8.04: hard resetting link
>> [  323.157612] ata8.04: link resume succeeded after 1 retries
>> [  323.292583] ata8.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  323.292616] ata8.05: hard resetting link
>> [  323.596925] ata8.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [  323.640767] ata8.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  323.640773] ata8.02: 625142448 sectors, multi 0: LBA48
>> [  323.640779] ata8.02: applying bridge limits
>> [  323.698858] ata8.02: configured for UDMA/100
>> [  323.745674] ata8.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  323.745680] ata8.03: 625142448 sectors, multi 0: LBA48
>> [  323.803639] ata8.03: configured for UDMA/100
>> [  323.842716] ata8.04: ATA-7: ST3320620A, 3.AAC, max UDMA/100
>> [  323.842722] ata8.04: 625142448 sectors, multi 0: LBA48
>> [  323.900831] ata8.04: configured for UDMA/100
>> [  323.900899] ata8: EH complete
>> [  326.030208] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  326.030699] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [  326.033845] ata9.00: hard resetting link
>> [  336.019051] ata9.00: softreset failed (timeout)
>> [  339.012488] ata9.15: qc timeout (cmd 0xe4)
>> [  339.012504] ata9.00: failed to read SCR 0 (Emask=0x5)
>> [  339.012508] ata9.00: reset failed, giving up
>> [  339.012513] ata9.15: hard resetting link
>> [  341.139699] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  341.140064] ata9.00: hard resetting link
>> [  351.124563] ata9.00: softreset failed (timeout)
>> [  354.117970] ata9.15: qc timeout (cmd 0xe4)
>> [  354.117986] ata9.00: failed to read SCR 0 (Emask=0x5)
>> [  354.117991] ata9.00: reset failed, giving up
>> [  354.117995] ata9.15: hard resetting link
>> [  356.245238] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  356.245646] ata9.00: hard resetting link
>> [  366.232072] ata9.00: softreset failed (timeout)
>> [  369.225622] ata9.15: qc timeout (cmd 0xe4)
>> [  369.225639] ata9.00: failed to read SCR 0 (Emask=0x5)
>> [  369.225643] ata9.00: reset failed, giving up
>> [  369.225646] ata9.00: failed to recover link after 3 tries, disabling
>> [  369.225651] ata9.15: hard resetting link
>> [  371.352723] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  371.658238] ata9.01: hard resetting link
>> [  372.061197] ata9.01: link resume succeeded after 1 retries
>> [  372.196197] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  372.196231] ata9.02: hard resetting link
>> [  372.599024] ata9.02: link resume succeeded after 1 retries
>> [  372.734004] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  372.734059] ata9.03: hard resetting link
>> [  373.136813] ata9.03: link resume succeeded after 1 retries
>> [  373.271772] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  373.271991] ata9.04: hard resetting link
>> [  373.674613] ata9.04: link resume succeeded after 1 retries
>> [  373.897067] ata9.04: softreset failed (SRST command error)
>> [  373.897181] ata9.04: failed to read SCR 0 (Emask=0x1)
>> [  373.897186] ata9.04: reset failed (errno=-85), retrying in 10 secs
>> [  383.249478] ata9.04: reset failed, giving up
>> [  383.249485] ata9.15: hard resetting link
>> [  383.249488] ata9: controller in dubious state, performing PORT_RST
>> [  385.398590] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  385.703106] ata9.01: hard resetting link
>> [  386.106062] ata9.01: link resume succeeded after 1 retries
>> [  386.241016] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  386.241049] ata9.02: hard resetting link
>> [  386.643858] ata9.02: link resume succeeded after 1 retries
>> [  386.778833] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  386.778867] ata9.03: hard resetting link
>> [  387.181678] ata9.03: link resume succeeded after 1 retries
>> [  387.316679] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  387.316712] ata9.04: hard resetting link
>> [  387.719469] ata9.04: link resume succeeded after 1 retries
>> [  387.941933] ata9.04: softreset failed (SRST command error)
>> [  388.051691] ata9.04: failed to read SCR 0 (Emask=0x1)
>> [  388.051697] ata9.04: reset failed (errno=-85), retrying in 10 secs
>> [  397.294204] ata9.04: reset failed, giving up
>> [  397.294211] ata9.15: hard resetting link
>> [  397.294215] ata9: controller in dubious state, performing PORT_RST
>> [  399.443466] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  399.748924] ata9.01: hard resetting link
>> [  400.151923] ata9.01: link resume succeeded after 1 retries
>> [  400.286954] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  400.287009] ata9.02: hard resetting link
>> [  400.602829] ata9.02: softreset failed (SRST command error)
>> [  400.602873] ata9.02: failed to read SCR 0 (Emask=0x1)
>> [  400.602878] ata9.02: reset failed (errno=-85), retrying in 10 secs
>> [  410.264596] ata9.02: reset failed, giving up
>> [  410.264602] ata9.15: hard resetting link
>> [  412.380787] ata9.15: softreset failed (SRST command error)
>> [  412.380793] ata9.15: reset failed (errno=-5), retrying in 8 secs
>> [  420.242419] ata9.15: hard resetting link
>> [  422.358667] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  422.358674] ata9.15: PMP revalidation failed (errno=-19)
>> [  427.347591] ata9.15: hard resetting link
>> [  429.474906] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  429.779395] ata9.01: hard resetting link
>> [  430.182351] ata9.01: link resume succeeded after 1 retries
>> [  430.317296] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  430.317351] ata9.02: hard resetting link
>> [  430.720197] ata9.02: link resume succeeded after 1 retries
>> [  430.855159] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  430.855193] ata9.03: hard resetting link
>> [  431.257981] ata9.03: link resume succeeded after 1 retries
>> [  431.392905] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  431.392939] ata9.04: hard resetting link
>> [  431.795778] ata9.04: link resume succeeded after 1 retries
>> [  432.018221] ata9.04: softreset failed (SRST command error)
>> [  432.127979] ata9.04: failed to read SCR 0 (Emask=0x1)
>> [  432.127985] ata9.04: reset failed (errno=-85), retrying in 10 secs
>> [  441.370492] ata9.04: reset failed, giving up
>> [  441.370497] ata9.04: failed to recover link after 3 tries, disabling
>> [  441.370503] ata9.15: hard resetting link
>> [  441.370506] ata9: controller in dubious state, performing PORT_RST
>> [  443.519744] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  444.228219] ata9.04: link resume succeeded after 1 retries
>> [  444.330047] ata9.01: hard resetting link
>> [  444.733074] ata9.01: link resume succeeded after 1 retries
>> [  444.868066] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  444.868100] ata9.02: hard resetting link
>> [  445.270895] ata9.02: link resume succeeded after 1 retries
>> [  445.405825] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  445.405858] ata9.03: hard resetting link
>> [  445.808708] ata9.03: link resume succeeded after 1 retries
>> [  445.943636] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  445.943670] ata9.05: hard resetting link
>> [  446.247941] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [  446.296913] ata9.01: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  446.296919] ata9.01: 625142448 sectors, multi 0: LBA48
>> [  446.296925] ata9.01: applying bridge limits
>> [  446.355077] ata9.01: configured for UDMA/100
>> [  446.395040] ata9.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  446.395046] ata9.02: 625142448 sectors, multi 0: LBA48
>> [  446.395052] ata9.02: applying bridge limits
>> [  446.452939] ata9.02: configured for UDMA/100
>> [  446.495345] ata9.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  446.495351] ata9.03: 625142448 sectors, multi 0: LBA48
>> [  446.495357] ata9.03: applying bridge limits
>> [  446.553517] ata9.03: configured for UDMA/100
>> [  446.553584] ata9: EH complete
>> [  448.683166] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  448.683486] ata10.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [  448.687214] ata10.00: hard resetting link
>> [  458.672134] ata10.00: softreset failed (timeout)
>> [  461.665544] ata10.15: qc timeout (cmd 0xe4)
>> [  461.665560] ata10.00: failed to read SCR 0 (Emask=0x5)
>> [  461.665564] ata10.00: reset failed, giving up
>> [  461.665569] ata10.15: hard resetting link
>> [  463.792817] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  463.793226] ata10.00: hard resetting link
>> [  473.777653] ata10.00: softreset failed (timeout)
>> [  476.771082] ata10.15: qc timeout (cmd 0xe4)
>> [  476.771098] ata10.00: failed to read SCR 0 (Emask=0x5)
>> [  476.771103] ata10.00: reset failed, giving up
>> [  476.771107] ata10.15: hard resetting link
>> [  478.899314] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  478.899908] ata10.00: hard resetting link
>> [  488.887138] ata10.00: softreset failed (timeout)
>> [  491.880576] ata10.15: qc timeout (cmd 0xe4)
>> [  491.880592] ata10.00: failed to read SCR 0 (Emask=0x5)
>> [  491.880596] ata10.00: reset failed, giving up
>> [  491.880600] ata10.00: failed to recover link after 3 tries, disabling
>> [  491.880605] ata10.15: hard resetting link
>> [  494.007817] ata10.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  494.312333] ata10.01: hard resetting link
>> [  494.715272] ata10.01: link resume succeeded after 1 retries
>> [  494.850280] ata10.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  494.850313] ata10.02: hard resetting link
>> [  495.253111] ata10.02: link resume succeeded after 1 retries
>> [  495.388016] ata10.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  495.388049] ata10.03: hard resetting link
>> [  495.790830] ata10.03: link resume succeeded after 1 retries
>> [  495.925873] ata10.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  495.925907] ata10.04: hard resetting link
>> [  496.328734] ata10.04: link resume succeeded after 1 retries
>> [  496.463716] ata10.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [  496.463771] ata10.05: hard resetting link
>> [  496.768009] ata10.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [  496.807384] ata10.01: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  496.807390] ata10.01: 625142448 sectors, multi 0: LBA48
>> [  496.865535] ata10.01: configured for UDMA/100
>> [  496.906478] ata10.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  496.906484] ata10.02: 625142448 sectors, multi 0: LBA48
>> [  496.964626] ata10.02: configured for UDMA/100
>> [  497.006300] ata10.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  497.006306] ata10.03: 625142448 sectors, multi 0: LBA48
>> [  497.072809] ata10.03: configured for UDMA/100
>> [  497.114788] ata10.04: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [  497.114794] ata10.04: 625142448 sectors, multi 0: LBA48
>> [  497.181051] ata10.04: configured for UDMA/100
>> [  497.181118] ata10: EH complete
>   :
>> [  590.217860] systemd[1]: Startup finished in 2s 202ms 781us (kernel) + 8min 18s 52ms 150us (initrd) + 1min 31s 63ms 470us (userspace) = 9min 51s 318ms 401us.
> --------
>
> --- 3.2.10 power cycle log ( patch is applied ) ---
>   :
>> [    0.000000] Linux version 3.2.10-3.aa.fc16.i686.PAE (anezaki@server4) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 22 08:14:54 JST 2012
>   :
>> [    2.729562] ata7: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff0000 irq 17
>> [    2.729566] ata8: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff2000 irq 17
>> [    2.729570] ata9: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff4000 irq 17
>> [    2.729573] ata10: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff6000 irq 17
>   :
>> [    4.856167] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [    4.856555] ata7.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [    4.860371] ata7.00: hard resetting link
>> [    5.164779] ata7.00: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [    5.164812] ata7.01: hard resetting link
>> [    5.567672] ata7.01: link resume succeeded after 1 retries
>> [    5.669657] ata7.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    5.669687] ata7.02: hard resetting link
>> [    6.072522] ata7.02: link resume succeeded after 1 retries
>> [    6.174570] ata7.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    6.174601] ata7.03: hard resetting link
>> [    6.577435] ata7.03: link resume succeeded after 1 retries
>> [    6.679594] ata7.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    6.679625] ata7.04: hard resetting link
>> [    7.082306] ata7.04: link resume succeeded after 1 retries
>> [    7.184388] ata7.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    7.184419] ata7.05: hard resetting link
>> [    7.488718] ata7.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [    7.534065] ata7.00: ATA-7: ST3320620A, 3.AAC, max UDMA/100
>> [    7.534071] ata7.00: 625142448 sectors, multi 0: LBA48
>> [    7.534090] ata7.00: applying bridge limits
>> [    7.592213] ata7.00: configured for UDMA/100
>> [    7.596737] ata7.01: ATA-6: WDC WD2500BB-55GUC0, 08.02D08, max UDMA/100
>> [    7.596743] ata7.01: 488397168 sectors, multi 0: LBA48
>> [    7.602618] ata7.01: configured for UDMA/100
>> [    7.606381] ata7.02: ATA-7: Maxtor 7L250R0, BAJ41G20, max UDMA/133
>> [    7.606387] ata7.02: 490234752 sectors, multi 0: LBA48
>> [    7.606393] ata7.02: applying bridge limits
>> [    7.611626] ata7.02: configured for UDMA/100
>> [    7.623764] ata7.03: ATA-7: WDC WD2500BB-22RDA0, 20.00K20, max UDMA/100
>> [    7.623770] ata7.03: 488397168 sectors, multi 0: LBA48
>> [    7.624811] ata7.03: configured for UDMA/100
>> [    7.629200] ata7.04: ATA-6: WDC WD1600BB-55GUA0, 08.02D08, max UDMA/100
>> [    7.629205] ata7.04: 312581808 sectors, multi 0: LBA48
>> [    7.634917] ata7.04: configured for UDMA/100
>> [    7.635002] ata7: EH complete
>> [   34.285986] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   34.286427] ata8.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [   34.288785] ata8.00: hard resetting link
>> [   34.593587] ata8.00: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   34.593617] ata8.01: hard resetting link
>> [   34.996435] ata8.01: link resume succeeded after 1 retries
>> [   35.098512] ata8.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   35.098543] ata8.02: hard resetting link
>> [   35.501314] ata8.02: link resume succeeded after 1 retries
>> [   35.603259] ata8.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   35.603290] ata8.03: hard resetting link
>> [   36.006195] ata8.03: link resume succeeded after 1 retries
>> [   36.108256] ata8.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   36.108287] ata8.04: hard resetting link
>> [   36.412602] ata8.04: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   36.412632] ata8.05: hard resetting link
>> [   36.717004] ata8.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   36.762712] ata8.00: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   36.762719] ata8.00: 625142448 sectors, multi 0: LBA48
>> [   36.845768] ata8.00: configured for UDMA/100
>> [   36.849244] ata8.01: ATA-5: WDC WD1200AB-22CBA1, 04.07B04, max UDMA/100
>> [   36.849250] ata8.01: 234441648 sectors, multi 0: LBA
>> [   36.849256] ata8.01: applying bridge limits
>> [   36.853680] ata8.01: configured for UDMA/100
>> [   36.891680] ata8.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   36.891686] ata8.02: 625142448 sectors, multi 0: LBA48
>> [   36.891692] ata8.02: applying bridge limits
>> [   36.949795] ata8.02: configured for UDMA/100
>> [   36.987189] ata8.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   36.987195] ata8.03: 625142448 sectors, multi 0: LBA48
>> [   37.045271] ata8.03: configured for UDMA/100
>> [   37.085915] ata8.04: ATA-7: ST3320620A, 3.AAC, max UDMA/100
>> [   37.085921] ata8.04: 625142448 sectors, multi 0: LBA48
>> [   37.144042] ata8.04: configured for UDMA/100
>> [   37.144107] ata8: EH complete
>> [   39.274927] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   39.275464] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [   39.278021] ata9.00: hard resetting link
>> [   39.582515] ata9.00: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   39.582546] ata9.01: hard resetting link
>> [   39.985368] ata9.01: link resume succeeded after 1 retries
>> [   40.087368] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   40.087403] ata9.02: hard resetting link
>> [   40.490243] ata9.02: link resume succeeded after 1 retries
>> [   40.592245] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   40.592276] ata9.03: hard resetting link
>> [   40.995137] ata9.03: link resume succeeded after 1 retries
>> [   41.097150] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   41.097180] ata9.04: hard resetting link
>> [   41.500012] ata9.04: link resume succeeded after 1 retries
>> [   41.602003] ata9.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   41.602034] ata9.05: hard resetting link
>> [   41.906397] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   42.014200] ata9.00: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   42.014206] ata9.00: 625142448 sectors, multi 0: LBA48
>> [   42.072324] ata9.00: configured for UDMA/100
>> [   42.111485] ata9.01: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   42.111491] ata9.01: 625142448 sectors, multi 0: LBA48
>> [   42.111497] ata9.01: applying bridge limits
>> [   42.169647] ata9.01: configured for UDMA/100
>> [   42.218013] ata9.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   42.218019] ata9.02: 625142448 sectors, multi 0: LBA48
>> [   42.218025] ata9.02: applying bridge limits
>> [   42.276087] ata9.02: configured for UDMA/100
>> [   42.320248] ata9.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   42.320254] ata9.03: 625142448 sectors, multi 0: LBA48
>> [   42.320260] ata9.03: applying bridge limits
>> [   42.378414] ata9.03: configured for UDMA/100
>> [   42.379847] ata9.04: ATA-6: Maxtor 96147H6, ZAH814Y0, max UDMA/100
>> [   42.379853] ata9.04: 120064896 sectors, multi 0: LBA
>> [   42.379858] ata9.04: applying bridge limits
>> [   42.381615] ata9.04: configured for UDMA/100
>> [   42.381680] ata9: EH complete
>> [   44.512318] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   44.512925] ata10.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [   44.515715] ata10.00: hard resetting link
>> [   44.819948] ata10.00: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   44.819979] ata10.01: hard resetting link
>> [   45.222761] ata10.01: link resume succeeded after 1 retries
>> [   45.324781] ata10.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   45.324812] ata10.02: hard resetting link
>> [   45.727639] ata10.02: link resume succeeded after 1 retries
>> [   45.829636] ata10.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   45.829666] ata10.03: hard resetting link
>> [   46.232522] ata10.03: link resume succeeded after 1 retries
>> [   46.334558] ata10.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   46.334589] ata10.04: hard resetting link
>> [   46.737368] ata10.04: link resume succeeded after 1 retries
>> [   46.839471] ata10.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   46.839501] ata10.05: hard resetting link
>> [   47.143791] ata10.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   47.248372] ata10.00: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   47.248378] ata10.00: 625142448 sectors, multi 0: LBA48
>> [   47.306392] ata10.00: configured for UDMA/100
>> [   47.353307] ata10.01: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   47.353313] ata10.01: 625142448 sectors, multi 0: LBA48
>> [   47.411454] ata10.01: configured for UDMA/100
>> [   47.456257] ata10.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   47.456263] ata10.02: 625142448 sectors, multi 0: LBA48
>> [   47.514395] ata10.02: configured for UDMA/100
>> [   47.553006] ata10.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   47.553012] ata10.03: 625142448 sectors, multi 0: LBA48
>> [   47.611199] ata10.03: configured for UDMA/100
>> [   47.652126] ata10.04: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   47.652132] ata10.04: 625142448 sectors, multi 0: LBA48
>> [   47.710076] ata10.04: configured for UDMA/100
>> [   47.710143] ata10: EH complete
>   :
>> [   68.114484] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
>> [   68.129524] NFSD: starting 90-second grace period
>   :
> --------
>
> --- 3.2.10 warm reboot log ( patch is applied ) ---
>   :
>> [    0.000000] Linux version 3.2.10-3.aa.fc16.i686.PAE (anezaki@server4) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 22 08:14:54 JST 2012
>   :
>> [    2.699127] ata7: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff0000 irq 17
>> [    2.699131] ata8: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff2000 irq 17
>> [    2.699135] ata9: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff4000 irq 17
>> [    2.699139] ata10: SATA max UDMA/100 host m128@0xfbfff400 port 0xfbff6000 irq 17
>   :
>> [    4.826250] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [    4.826612] ata7.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [    4.830596] ata7.00: hard resetting link
>> [    5.134832] ata7.00: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [    5.134863] ata7.01: hard resetting link
>> [    5.537729] ata7.01: link resume succeeded after 1 retries
>> [    5.639812] ata7.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    5.639843] ata7.02: hard resetting link
>> [    6.042561] ata7.02: link resume succeeded after 1 retries
>> [    6.144687] ata7.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    6.144717] ata7.03: hard resetting link
>> [    6.547490] ata7.03: link resume succeeded after 1 retries
>> [    6.649674] ata7.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    6.649705] ata7.04: hard resetting link
>> [    7.052371] ata7.04: link resume succeeded after 1 retries
>> [    7.154419] ata7.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    7.154449] ata7.05: hard resetting link
>> [    7.458756] ata7.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [    7.503939] ata7.00: ATA-7: ST3320620A, 3.AAC, max UDMA/100
>> [    7.503945] ata7.00: 625142448 sectors, multi 0: LBA48
>> [    7.503951] ata7.00: applying bridge limits
>> [    7.562109] ata7.00: configured for UDMA/100
>> [    7.783927] ata7.01: ATA-6: WDC WD2500BB-55GUC0, 08.02D08, max UDMA/100
>> [    7.783934] ata7.01: 488397168 sectors, multi 0: LBA48
>> [    7.789650] ata7.01: configured for UDMA/100
>> [    7.793380] ata7.02: ATA-7: Maxtor 7L250R0, BAJ41G20, max UDMA/133
>> [    7.793386] ata7.02: 490234752 sectors, multi 0: LBA48
>> [    7.793392] ata7.02: applying bridge limits
>> [    7.798892] ata7.02: configured for UDMA/100
>> [    7.811970] ata7.03: ATA-7: WDC WD2500BB-22RDA0, 20.00K20, max UDMA/100
>> [    7.811976] ata7.03: 488397168 sectors, multi 0: LBA48
>> [    7.813162] ata7.03: configured for UDMA/100
>> [    7.817674] ata7.04: ATA-6: WDC WD1600BB-55GUA0, 08.02D08, max UDMA/100
>> [    7.817680] ata7.04: 312581808 sectors, multi 0: LBA48
>> [    7.823575] ata7.04: configured for UDMA/100
>> [    7.823643] ata7: EH complete
>> [   13.041087] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   13.041499] ata8.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [   13.044606] ata8.00: hard resetting link
>> [   13.348670] ata8.00: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   13.348701] ata8.01: hard resetting link
>> [   13.751514] ata8.01: link resume succeeded after 1 retries
>> [   13.853570] ata8.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   13.853602] ata8.02: hard resetting link
>> [   14.256455] ata8.02: link resume succeeded after 1 retries
>> [   14.358436] ata8.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   14.358467] ata8.03: hard resetting link
>> [   14.761281] ata8.03: link resume succeeded after 1 retries
>> [   14.863336] ata8.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   14.863367] ata8.04: hard resetting link
>> [   15.167619] ata8.04: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   15.167650] ata8.05: hard resetting link
>> [   15.471979] ata8.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   15.516626] ata8.00: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   15.516632] ata8.00: 625142448 sectors, multi 0: LBA48
>> [   15.574797] ata8.00: configured for UDMA/100
>> [   15.578265] ata8.01: ATA-5: WDC WD1200AB-22CBA1, 04.07B04, max UDMA/100
>> [   15.578271] ata8.01: 234441648 sectors, multi 0: LBA
>> [   15.578277] ata8.01: applying bridge limits
>> [   15.582726] ata8.01: configured for UDMA/100
>> [   15.628882] ata8.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   15.628888] ata8.02: 625142448 sectors, multi 0: LBA48
>> [   15.628894] ata8.02: applying bridge limits
>> [   15.686967] ata8.02: configured for UDMA/100
>> [   15.730640] ata8.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   15.730646] ata8.03: 625142448 sectors, multi 0: LBA48
>> [   15.788720] ata8.03: configured for UDMA/100
>> [   15.835469] ata8.04: ATA-7: ST3320620A, 3.AAC, max UDMA/100
>> [   15.835475] ata8.04: 625142448 sectors, multi 0: LBA48
>> [   15.893578] ata8.04: configured for UDMA/100
>> [   15.893644] ata8: EH complete
>> [   18.024017] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   18.024436] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [   18.026843] ata9.00: hard resetting link
>> [   18.331659] ata9.00: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   18.331690] ata9.01: hard resetting link
>> [   18.734523] ata9.01: link resume succeeded after 1 retries
>> [   18.836552] ata9.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   18.836583] ata9.02: hard resetting link
>> [   19.239387] ata9.02: link resume succeeded after 1 retries
>> [   19.341569] ata9.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   19.341600] ata9.03: hard resetting link
>> [   19.744289] ata9.03: link resume succeeded after 1 retries
>> [   19.846327] ata9.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   19.846359] ata9.04: hard resetting link
>> [   20.249125] ata9.04: link resume succeeded after 1 retries
>> [   20.351165] ata9.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   20.351196] ata9.05: hard resetting link
>> [   20.655534] ata9.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   20.697625] ata9.00: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   20.697631] ata9.00: 625142448 sectors, multi 0: LBA48
>> [   20.755791] ata9.00: configured for UDMA/100
>> [   20.803812] ata9.01: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   20.803820] ata9.01: 625142448 sectors, multi 0: LBA48
>> [   20.803828] ata9.01: applying bridge limits
>> [   20.861999] ata9.01: configured for UDMA/100
>> [   20.907473] ata9.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   20.907481] ata9.02: 625142448 sectors, multi 0: LBA48
>> [   20.907489] ata9.02: applying bridge limits
>> [   20.965567] ata9.02: configured for UDMA/100
>> [   21.009201] ata9.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   21.009208] ata9.03: 625142448 sectors, multi 0: LBA48
>> [   21.009235] ata9.03: applying bridge limits
>> [   21.067373] ata9.03: configured for UDMA/100
>> [   21.068864] ata9.04: ATA-6: Maxtor 96147H6, ZAH814Y0, max UDMA/100
>> [   21.068870] ata9.04: 120064896 sectors, multi 0: LBA
>> [   21.068875] ata9.04: applying bridge limits
>> [   21.070684] ata9.04: configured for UDMA/100
>> [   21.070764] ata9: EH complete
>> [   23.200571] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   23.200949] ata10.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [   23.203737] ata10.00: hard resetting link
>> [   23.508163] ata10.00: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   23.508194] ata10.01: hard resetting link
>> [   23.911059] ata10.01: link resume succeeded after 1 retries
>> [   24.013053] ata10.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   24.013084] ata10.02: hard resetting link
>> [   24.415910] ata10.02: link resume succeeded after 1 retries
>> [   24.517980] ata10.02: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   24.518012] ata10.03: hard resetting link
>> [   24.920928] ata10.03: link resume succeeded after 1 retries
>> [   25.022770] ata10.03: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   25.022801] ata10.04: hard resetting link
>> [   25.425701] ata10.04: link resume succeeded after 1 retries
>> [   25.527681] ata10.04: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [   25.527712] ata10.05: hard resetting link
>> [   25.832000] ata10.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>> [   25.879126] ata10.00: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   25.879132] ata10.00: 625142448 sectors, multi 0: LBA48
>> [   25.937192] ata10.00: configured for UDMA/100
>> [   25.978792] ata10.01: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   25.978798] ata10.01: 625142448 sectors, multi 0: LBA48
>> [   26.036936] ata10.01: configured for UDMA/100
>> [   26.077728] ata10.02: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   26.077734] ata10.02: 625142448 sectors, multi 0: LBA48
>> [   26.136026] ata10.02: configured for UDMA/100
>> [   26.183072] ata10.03: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   26.183078] ata10.03: 625142448 sectors, multi 0: LBA48
>> [   26.241261] ata10.03: configured for UDMA/100
>> [   26.279920] ata10.04: ATA-7: ST3320620A, 3.AAD, max UDMA/100
>> [   26.279926] ata10.04: 625142448 sectors, multi 0: LBA48
>> [   26.337727] ata10.04: configured for UDMA/100
>> [   26.337793] ata10: EH complete
>   :
>> [   50.854018] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
>> [   50.910997] NFSD: starting 90-second grace period
>   :
> --------
>
> Best Regards,
> Akira
