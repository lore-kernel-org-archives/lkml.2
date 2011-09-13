Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab1IMA33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 20:29:29 -0400
Received: from claw.goop.org ([74.207.240.146]:34609 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab1IMA31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 20:29:27 -0400
Message-ID: <4E6EA3E4.5080401@goop.org>
Date: Mon, 12 Sep 2011 17:29:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-mmc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: SDHCI regression since 2.6.39
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.39, the SD card slot in my Lenovo X220 has stopped working.  
When I insert a card with current linux.git kernel (3.1-rc6), I get:

[ 3891.745549] mmc0: new SDHC card at address b368
[ 3891.790704] mmcblk0: mmc0:b368 PNY   7.51 GiB 
[ 3891.795568] mmc0: Got data interrupt 0x00200000 even though no data operation was in progress.
[ 3891.795571] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3891.795577] sdhci: Sys addr: 0xfffff400 | Version:  0x00000502
[ 3891.795582] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3891.795587] sdhci: Argument: 0x00000000 | Trn mode: 0x00000033
[ 3891.795592] sdhci: Present:  0x014f0001 | Host ctl: 0x00000007
[ 3891.795597] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3891.795602] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
[ 3891.795607] sdhci: Timeout:  0x0000000e | Int stat: 0x00000000
[ 3891.795612] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
[ 3891.795617] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3891.795621] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3891.795626] sdhci: Cmd:      0x00000c1b | Max curr: 0x00000040
[ 3891.795629] sdhci: Host ctl2: 0x00000000
[ 3891.795630] sdhci: ===========================================
[ 3891.795742] mmcblk0: error -110 sending stop command, original cmd response 0x900, card status 0x800b00
[ 3891.795744] mmcblk0: error -84 transferring data, sector 0, nr 8, cmd response 0x900, card status 0x800b00
[ 3891.795746] mmcblk0: retrying using single block read
[ 3891.796136] mmcblk0: error -84 transferring data, sector 0, nr 8, cmd response 0x900, card status 0x0
[ 3891.796146] end_request: I/O error, dev mmcblk0, sector 0
[ 3891.796531] mmcblk0: error -84 transferring data, sector 1, nr 7, cmd response 0x900, card status 0x0
[ 3891.796538] end_request: I/O error, dev mmcblk0, sector 1
[ 3891.796972] mmcblk0: error -84 transferring data, sector 2, nr 6, cmd response 0x900, card status 0x0
[ 3891.796979] end_request: I/O error, dev mmcblk0, sector 2
[ 3891.797062] mmcblk0: error -110 sending status command, retrying
[ 3891.797107] mmcblk0: error -110 sending status command, retrying
[ 3891.797128] mmcblk0: timed out sending r/w cmd command, card status 0x800900
[ 3891.797503] mmcblk0: error -84 transferring data, sector 3, nr 5, cmd response 0x900, card status 0x0
[ 3891.797509] end_request: I/O error, dev mmcblk0, sector 3
[ 3891.797709] mmcblk0: error -110 sending status command, retrying
[ 3891.797732] mmcblk0: timed out sending r/w cmd command, card status 0xc00900
[ 3891.798109] mmcblk0: error -84 transferring data, sector 4, nr 4, cmd response 0x900, card status 0x0
[ 3891.798115] end_request: I/O error, dev mmcblk0, sector 4
[ 3891.798191] mmcblk0: timed out sending r/w cmd command, card status 0x800900
[ 3891.798592] mmcblk0: error -84 transferring data, sector 5, nr 3, cmd response 0x900, card status 0x0
[ 3891.798604] end_request: I/O error, dev mmcblk0, sector 5
[ 3891.798996] mmcblk0: error -84 transferring data, sector 6, nr 2, cmd response 0x900, card status 0x0
[ 3891.799004] end_request: I/O error, dev mmcblk0, sector 6
[ 3891.799388] mmcblk0: error -84 transferring data, sector 7, nr 1, cmd response 0x900, card status 0x0
[ 3891.799394] end_request: I/O error, dev mmcblk0, sector 7
[ 3891.799400] Buffer I/O error on device mmcblk0, logical block 0
[ 3891.799838] mmcblk0: error -84 transferring data, sector 0, nr 8, cmd response 0x900, card status 0xb00
[ 3891.799844] mmcblk0: retrying using single block read
[ 3891.800228] mmcblk0: error -84 transferring data, sector 0, nr 8, cmd response 0x900, card status 0x0
[ 3891.800234] end_request: I/O error, dev mmcblk0, sector 0
[ 3891.800628] mmcblk0: error -84 transferring data, sector 1, nr 7, cmd response 0x900, card status 0x0
[ 3891.800639] end_request: I/O error, dev mmcblk0, sector 1
[ 3891.801031] mmcblk0: error -84 transferring data, sector 2, nr 6, cmd response 0x900, card status 0x0
[ 3891.801037] end_request: I/O error, dev mmcblk0, sector 2
[ 3891.801420] mmcblk0: error -84 transferring data, sector 3, nr 5, cmd response 0x900, card status 0x0
[ 3891.801425] end_request: I/O error, dev mmcblk0, sector 3
[ 3891.801502] mmcblk0: timed out sending r/w cmd command, card status 0x400900
[ 3891.801895] mmcblk0: error -84 transferring data, sector 4, nr 4, cmd response 0x900, card status 0x0
[ 3891.801902] end_request: I/O error, dev mmcblk0, sector 4
[ 3891.802283] mmcblk0: error -84 transferring data, sector 5, nr 3, cmd response 0x900, card status 0x0
[ 3891.802289] end_request: I/O error, dev mmcblk0, sector 5
[ 3891.802674] mmcblk0: error -84 transferring data, sector 6, nr 2, cmd response 0x900, card status 0x0
[ 3891.802680] end_request: I/O error, dev mmcblk0, sector 6
[ 3891.803068] mmcblk0: error -84 transferring data, sector 7, nr 1, cmd response 0x900, card status 0x0
[ 3891.803074] end_request: I/O error, dev mmcblk0, sector 7
[ 3891.803079] Buffer I/O error on device mmcblk0, logical block 0
[ 3891.803105]  mmcblk0: unable to read partition table
[ 3891.835306] mmcblk0: error -110 sending status command, retrying
[ 3891.835351] mmcblk0: error -110 sending status command, retrying
[ 3891.835392] mmcblk0: error -110 sending status command, aborting
[ 3891.835401] end_request: I/O error, dev mmcblk0, sector 15759232
[ 3891.835409] Buffer I/O error on device mmcblk0, logical block 1969904
[ 3891.835589] mmcblk0: error -110 sending status command, retrying
[ 3891.835640] mmcblk0: error -110 sending status command, retrying
[ 3891.835697] mmcblk0: error -110 sending status command, aborting
[ 3891.835708] end_request: I/O error, dev mmcblk0, sector 15759232
[ 3891.835716] Buffer I/O error on device mmcblk0, logical block 1969904
[ 3891.835892] mmcblk0: error -110 sending status command, retrying
[ 3891.835945] mmcblk0: error -110 sending status command, retrying
[ 3891.836001] mmcblk0: error -110 sending status command, aborting
[ 3891.836012] end_request: I/O error, dev mmcblk0, sector 15759344
[ 3891.836021] Buffer I/O error on device mmcblk0, logical block 1969918
[ 3891.836148] mmcblk0: error -110 sending status command, retrying
[ 3891.836177] mmcblk0: error -110 sending status command, retrying
[ 3891.836224] mmcblk0: error -110 sending status command, aborting
[ 3891.836231] end_request: I/O error, dev mmcblk0, sector 15759344
[ 3891.836237] Buffer I/O error on device mmcblk0, logical block 1969918
[ 3891.836383] mmcblk0: error -110 sending status command, retrying
[ 3891.836422] mmcblk0: error -110 sending status command, retrying
[ 3891.836479] mmcblk0: error -110 sending status command, aborting
[ 3891.836485] end_request: I/O error, dev mmcblk0, sector 0
[ 3891.836490] Buffer I/O error on device mmcblk0, logical block 0
[ 3891.836613] mmcblk0: error -110 sending status command, retrying
[ 3891.836660] mmcblk0: error -110 sending status command, retrying
[ 3891.836705] mmcblk0: error -110 sending status command, aborting
[ 3891.836716] end_request: I/O error, dev mmcblk0, sector 0
[ 3891.836724] Buffer I/O error on device mmcblk0, logical block 0
[ 3891.837111] mmcblk0: error -110 sending status command, retrying
[ 3891.837168] mmcblk0: error -110 sending status command, retrying
[ 3891.837216] mmcblk0: error -110 sending status command, aborting
[ 3891.837224] end_request: I/O error, dev mmcblk0, sector 8
[ 3891.837230] Buffer I/O error on device mmcblk0, logical block 1
[ 3891.837351] mmcblk0: error -110 sending status command, retrying
[ 3891.837391] mmcblk0: error -110 sending status command, retrying
[...]

lspci shows the device is:

0d:00.0 System peripheral: Ricoh Co Ltd Device e823 (rev 04) (prog-if 01)
	Subsystem: Lenovo Device 21da
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at f1400000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [78] Power Management version 3
	Capabilities: [80] Express Endpoint, MSI 00
	Capabilities: [100] Virtual Channel
	Capabilities: [800] Advanced Error Reporting
	Kernel driver in use: sdhci-pci
	Kernel modules: sdhci-pci


The same card in an external USB reader works fine.

How can I help fix this?

Thanks,
	J

