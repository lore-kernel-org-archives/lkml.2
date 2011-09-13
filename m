Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab1IMAgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 20:36:49 -0400
Received: from claw.goop.org ([74.207.240.146]:34629 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab1IMAgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 20:36:47 -0400
Message-ID: <4E6EA59D.6000402@goop.org>
Date: Mon, 12 Sep 2011 17:36:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-mmc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SDHCI regression since 2.6.39
References: <4E6EA3E4.5080401@goop.org>
In-Reply-To: <4E6EA3E4.5080401@goop.org>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2011 05:29 PM, Jeremy Fitzhardinge wrote:
> Since 2.6.39, the SD card slot in my Lenovo X220 has stopped working.  
> When I insert a card with current linux.git kernel (3.1-rc6), I get:
>
> [ 3891.745549] mmc0: new SDHC card at address b368
> [ 3891.790704] mmcblk0: mmc0:b368 PNY   7.51 GiB 
> [ 3891.795568] mmc0: Got data interrupt 0x00200000 even though no data operation was in progress.
> [ 3891.795571] sdhci: =========== REGISTER DUMP (mmc0)===========
> [ 3891.795577] sdhci: Sys addr: 0xfffff400 | Version:  0x00000502
> [ 3891.795582] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
> [ 3891.795587] sdhci: Argument: 0x00000000 | Trn mode: 0x00000033
> [ 3891.795592] sdhci: Present:  0x014f0001 | Host ctl: 0x00000007
> [ 3891.795597] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
> [ 3891.795602] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
> [ 3891.795607] sdhci: Timeout:  0x0000000e | Int stat: 0x00000000
> [ 3891.795612] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
> [ 3891.795617] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
> [ 3891.795621] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
> [ 3891.795626] sdhci: Cmd:      0x00000c1b | Max curr: 0x00000040
> [ 3891.795629] sdhci: Host ctl2: 0x00000000
> [ 3891.795630] sdhci: ===========================================
> [ 3891.795742] mmcblk0: error -110 sending stop command, original cmd response 0x900, card status 0x800b00
> [ 3891.795744] mmcblk0: error -84 transferring data, sector 0, nr 8, cmd response 0x900, card status 0x800b00
> [ 3891.795746] mmcblk0: retrying using single block read
> [ 3891.796136] mmcblk0: error -84 transferring data, sector 0, nr 8, cmd response 0x900, card status 0x0
> [ 3891.796146] end_request: I/O error, dev mmcblk0, sector 0
> [ 3891.796531] mmcblk0: error -84 transferring data, sector 1, nr 7, cmd response 0x900, card status 0x0
> [ 3891.796538] end_request: I/O error, dev mmcblk0, sector 1
> [ 3891.796972] mmcblk0: error -84 transferring data, sector 2, nr 6, cmd response 0x900, card status 0x0
> [ 3891.796979] end_request: I/O error, dev mmcblk0, sector 2
> [ 3891.797062] mmcblk0: error -110 sending status command, retrying
> [ 3891.797107] mmcblk0: error -110 sending status command, retrying
> [ 3891.797128] mmcblk0: timed out sending r/w cmd command, card status 0x800900
> [ 3891.797503] mmcblk0: error -84 transferring data, sector 3, nr 5, cmd response 0x900, card status 0x0
> [ 3891.797509] end_request: I/O error, dev mmcblk0, sector 3
> [ 3891.797709] mmcblk0: error -110 sending status command, retrying
> [ 3891.797732] mmcblk0: timed out sending r/w cmd command, card status 0xc00900
> [ 3891.798109] mmcblk0: error -84 transferring data, sector 4, nr 4, cmd response 0x900, card status 0x0
> [ 3891.798115] end_request: I/O error, dev mmcblk0, sector 4
> [ 3891.798191] mmcblk0: timed out sending r/w cmd command, card status 0x800900
> [ 3891.798592] mmcblk0: error -84 transferring data, sector 5, nr 3, cmd response 0x900, card status 0x0
> [ 3891.798604] end_request: I/O error, dev mmcblk0, sector 5
> [ 3891.798996] mmcblk0: error -84 transferring data, sector 6, nr 2, cmd response 0x900, card status 0x0
> [ 3891.799004] end_request: I/O error, dev mmcblk0, sector 6
> [ 3891.799388] mmcblk0: error -84 transferring data, sector 7, nr 1, cmd response 0x900, card status 0x0
> [ 3891.799394] end_request: I/O error, dev mmcblk0, sector 7
> [ 3891.799400] Buffer I/O error on device mmcblk0, logical block 0
> [ 3891.799838] mmcblk0: error -84 transferring data, sector 0, nr 8, cmd response 0x900, card status 0xb00
> [ 3891.799844] mmcblk0: retrying using single block read
> [ 3891.800228] mmcblk0: error -84 transferring data, sector 0, nr 8, cmd response 0x900, card status 0x0
> [ 3891.800234] end_request: I/O error, dev mmcblk0, sector 0
> [ 3891.800628] mmcblk0: error -84 transferring data, sector 1, nr 7, cmd response 0x900, card status 0x0
> [ 3891.800639] end_request: I/O error, dev mmcblk0, sector 1
> [ 3891.801031] mmcblk0: error -84 transferring data, sector 2, nr 6, cmd response 0x900, card status 0x0
> [ 3891.801037] end_request: I/O error, dev mmcblk0, sector 2
> [ 3891.801420] mmcblk0: error -84 transferring data, sector 3, nr 5, cmd response 0x900, card status 0x0
> [ 3891.801425] end_request: I/O error, dev mmcblk0, sector 3
> [ 3891.801502] mmcblk0: timed out sending r/w cmd command, card status 0x400900
> [ 3891.801895] mmcblk0: error -84 transferring data, sector 4, nr 4, cmd response 0x900, card status 0x0
> [ 3891.801902] end_request: I/O error, dev mmcblk0, sector 4
> [ 3891.802283] mmcblk0: error -84 transferring data, sector 5, nr 3, cmd response 0x900, card status 0x0
> [ 3891.802289] end_request: I/O error, dev mmcblk0, sector 5
> [ 3891.802674] mmcblk0: error -84 transferring data, sector 6, nr 2, cmd response 0x900, card status 0x0
> [ 3891.802680] end_request: I/O error, dev mmcblk0, sector 6
> [ 3891.803068] mmcblk0: error -84 transferring data, sector 7, nr 1, cmd response 0x900, card status 0x0
> [ 3891.803074] end_request: I/O error, dev mmcblk0, sector 7
> [ 3891.803079] Buffer I/O error on device mmcblk0, logical block 0
> [ 3891.803105]  mmcblk0: unable to read partition table
> [ 3891.835306] mmcblk0: error -110 sending status command, retrying
> [ 3891.835351] mmcblk0: error -110 sending status command, retrying
> [ 3891.835392] mmcblk0: error -110 sending status command, aborting
> [ 3891.835401] end_request: I/O error, dev mmcblk0, sector 15759232
> [ 3891.835409] Buffer I/O error on device mmcblk0, logical block 1969904
> [ 3891.835589] mmcblk0: error -110 sending status command, retrying
> [ 3891.835640] mmcblk0: error -110 sending status command, retrying
> [ 3891.835697] mmcblk0: error -110 sending status command, aborting
> [ 3891.835708] end_request: I/O error, dev mmcblk0, sector 15759232
> [ 3891.835716] Buffer I/O error on device mmcblk0, logical block 1969904
> [ 3891.835892] mmcblk0: error -110 sending status command, retrying
> [ 3891.835945] mmcblk0: error -110 sending status command, retrying
> [ 3891.836001] mmcblk0: error -110 sending status command, aborting
> [ 3891.836012] end_request: I/O error, dev mmcblk0, sector 15759344
> [ 3891.836021] Buffer I/O error on device mmcblk0, logical block 1969918
> [ 3891.836148] mmcblk0: error -110 sending status command, retrying
> [ 3891.836177] mmcblk0: error -110 sending status command, retrying
> [ 3891.836224] mmcblk0: error -110 sending status command, aborting
> [ 3891.836231] end_request: I/O error, dev mmcblk0, sector 15759344
> [ 3891.836237] Buffer I/O error on device mmcblk0, logical block 1969918
> [ 3891.836383] mmcblk0: error -110 sending status command, retrying
> [ 3891.836422] mmcblk0: error -110 sending status command, retrying
> [ 3891.836479] mmcblk0: error -110 sending status command, aborting
> [ 3891.836485] end_request: I/O error, dev mmcblk0, sector 0
> [ 3891.836490] Buffer I/O error on device mmcblk0, logical block 0
> [ 3891.836613] mmcblk0: error -110 sending status command, retrying
> [ 3891.836660] mmcblk0: error -110 sending status command, retrying
> [ 3891.836705] mmcblk0: error -110 sending status command, aborting
> [ 3891.836716] end_request: I/O error, dev mmcblk0, sector 0
> [ 3891.836724] Buffer I/O error on device mmcblk0, logical block 0
> [ 3891.837111] mmcblk0: error -110 sending status command, retrying
> [ 3891.837168] mmcblk0: error -110 sending status command, retrying
> [ 3891.837216] mmcblk0: error -110 sending status command, aborting
> [ 3891.837224] end_request: I/O error, dev mmcblk0, sector 8
> [ 3891.837230] Buffer I/O error on device mmcblk0, logical block 1
> [ 3891.837351] mmcblk0: error -110 sending status command, retrying
> [ 3891.837391] mmcblk0: error -110 sending status command, retrying
> [...]
>
> lspci shows the device is:
>
> 0d:00.0 System peripheral: Ricoh Co Ltd Device e823 (rev 04) (prog-if 01)
> 	Subsystem: Lenovo Device 21da
> 	Flags: bus master, fast devsel, latency 0, IRQ 16
> 	Memory at f1400000 (32-bit, non-prefetchable) [size=256]
> 	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
> 	Capabilities: [78] Power Management version 3
> 	Capabilities: [80] Express Endpoint, MSI 00
> 	Capabilities: [100] Virtual Channel
> 	Capabilities: [800] Advanced Error Reporting
> 	Kernel driver in use: sdhci-pci
> 	Kernel modules: sdhci-pci
>
>
> The same card in an external USB reader works fine.
>
> How can I help fix this?

I enabled MMC_DEBUG=y, and when I modprobe the sdhci-pci driver, it outputs:

[ 4435.127525] sdhci: Secure Digital Host Controller Interface driver
[ 4435.127534] sdhci: Copyright(c) Pierre Ossman
[ 4435.128253] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e823] (rev 4)
[ 4435.128476] sdhci-pci 0000:0d:00.0: found 1 slot(s)
[ 4435.128542] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 4435.129011] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[ 4435.129065] sdhci [sdhci_add_host()]: mmc0: Auto-CMD23 unavailable
[ 4435.129208] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 4435.129219] sdhci: Sys addr: 0xfff68000 | Version:  0x00000502
[ 4435.129233] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 4435.129242] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 4435.129252] sdhci: Present:  0x01f20000 | Host ctl: 0x00000004
[ 4435.129266] sdhci: Power:    0x00000000 | Blk gap:  0x00000000
[ 4435.129276] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a500
[ 4435.129290] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 4435.129300] sdhci: Int enab: 0x00ff0003 | Sig enab: 0x00ff0003
[ 4435.129314] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 4435.129323] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 4435.129337] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 4435.129345] sdhci: Host ctl2: 0x00000000
[ 4435.129349] sdhci: ===========================================
[ 4435.129433] Registered led device: mmc0::
[ 4435.130639] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[ 4435.130831] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[ 4435.130901] mmc0: mmc_rescan_try_freq: trying to init card at 400000 Hz
[ 4435.130911] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[ 4435.141164] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 4435.152135] mmc0: starting CMD52 arg 00000c00 flags 00000195
[ 4435.152259] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 4435.152288] mmc0: starting CMD52 arg 80000c08 flags 00000195
[ 4435.152315] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 4435.152335] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[ 4435.154102] mmc0: starting CMD0 arg 00000000 flags 000000c0
[ 4435.154136] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 00000000
[ 4435.156077] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 4435.158073] mmc0: starting CMD8 arg 000001aa flags 000002f5
[ 4435.158092] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 00000000
[ 4435.158101] mmc0: starting CMD5 arg 00000000 flags 000002e1
[ 4435.158117] mmc0: req failed (CMD5): -123, retrying...
[ 4435.158127] mmc0: req failed (CMD5): -123, retrying...
[ 4435.158137] mmc0: req failed (CMD5): -123, retrying...
[ 4435.158148] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 00000000
[ 4435.163662] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.163682] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.163694] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.163713] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.163720] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.163737] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.163743] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.163760] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.163766] mmc0: starting CMD1 arg 00000000 flags 000000e1
[ 4435.163782] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 00000000
[ 4435.163789] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[ 4435.163809] mmc0: mmc_rescan_try_freq: trying to init card at 300000 Hz
[ 4435.163812] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[ 4435.174059] mmc0: clock 300000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 4435.185030] mmc0: starting CMD52 arg 00000c00 flags 00000195
[ 4435.185054] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 4435.185066] mmc0: starting CMD52 arg 80000c08 flags 00000195
[ 4435.185085] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 4435.185093] mmc0: clock 300000Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[ 4435.187008] mmc0: starting CMD0 arg 00000000 flags 000000c0
[ 4435.187026] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 00000000
[ 4435.189001] mmc0: clock 300000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 4435.190994] mmc0: starting CMD8 arg 000001aa flags 000002f5
[ 4435.191014] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 00000000
[ 4435.191026] mmc0: starting CMD5 arg 00000000 flags 000002e1
[ 4435.191041] mmc0: req failed (CMD5): -123, retrying...
[ 4435.191052] mmc0: req failed (CMD5): -123, retrying...
[ 4435.191062] mmc0: req failed (CMD5): -123, retrying...
[ 4435.191074] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 00000000
[ 4435.196581] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.196599] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.196609] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.196626] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.196633] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.196649] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.196656] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.196671] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.196678] mmc0: starting CMD1 arg 00000000 flags 000000e1
[ 4435.196694] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 00000000
[ 4435.196701] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[ 4435.196722] mmc0: mmc_rescan_try_freq: trying to init card at 200000 Hz
[ 4435.196725] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[ 4435.206968] mmc0: clock 200000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 4435.217944] mmc0: starting CMD52 arg 00000c00 flags 00000195
[ 4435.217965] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 4435.217977] mmc0: starting CMD52 arg 80000c08 flags 00000195
[ 4435.217995] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 4435.218004] mmc0: clock 200000Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[ 4435.219933] mmc0: starting CMD0 arg 00000000 flags 000000c0
[ 4435.219952] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 00000000
[ 4435.221962] mmc0: clock 200000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 4435.223921] mmc0: starting CMD8 arg 000001aa flags 000002f5
[ 4435.223939] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 00000000
[ 4435.223951] mmc0: starting CMD5 arg 00000000 flags 000002e1
[ 4435.223966] mmc0: req failed (CMD5): -123, retrying...
[ 4435.223977] mmc0: req failed (CMD5): -123, retrying...
[ 4435.223987] mmc0: req failed (CMD5): -123, retrying...
[ 4435.223999] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 00000000
[ 4435.229330] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.229351] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.229365] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.229385] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.229393] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.229410] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.229417] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.229433] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.229440] mmc0: starting CMD1 arg 00000000 flags 000000e1
[ 4435.229456] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 00000000
[ 4435.229463] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[ 4435.229483] mmc0: mmc_rescan_try_freq: trying to init card at 100000 Hz
[ 4435.229486] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[ 4435.239901] mmc0: clock 100000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 4435.250879] mmc0: starting CMD52 arg 00000c00 flags 00000195
[ 4435.250901] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 4435.250911] mmc0: starting CMD52 arg 80000c08 flags 00000195
[ 4435.250931] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 4435.250939] mmc0: clock 100000Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[ 4435.252857] mmc0: starting CMD0 arg 00000000 flags 000000c0
[ 4435.252878] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 00000000
[ 4435.254854] mmc0: clock 100000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 4435.256849] mmc0: starting CMD8 arg 000001aa flags 000002f5
[ 4435.256870] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 00000000
[ 4435.256877] mmc0: starting CMD5 arg 00000000 flags 000002e1
[ 4435.256894] mmc0: req failed (CMD5): -123, retrying...
[ 4435.256907] mmc0: req failed (CMD5): -123, retrying...
[ 4435.256920] mmc0: req failed (CMD5): -123, retrying...
[ 4435.256940] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 00000000
[ 4435.262223] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.262240] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.262251] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.262269] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.262276] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.262294] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.262300] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 4435.262317] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 4435.262324] mmc0: starting CMD1 arg 00000000 flags 000000e1
[ 4435.262341] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 00000000
[ 4435.262348] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0

and when I insert the card it overran the dmesg buffer so I lost the start, but it's
basically all:

[...]
[ 4558.264873] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.264885] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.264889] mmcblk0: error -110 sending status command, retrying
[ 4558.264891] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.264907] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.264920] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.264924] mmcblk0: error -110 sending status command, aborting
[ 4558.264926] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.264939] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.264941] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.264943] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.264966] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.264979] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.264980] mmc0:     0 bytes transferred: 0
[ 4558.264981] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.264986] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265002] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265014] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265019] mmcblk0: error -110 sending status command, retrying
[ 4558.265021] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265037] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265050] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265055] mmcblk0: error -110 sending status command, retrying
[ 4558.265056] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265073] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265086] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265090] mmcblk0: error -110 sending status command, aborting
[ 4558.265093] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.265111] mmc0: starting CMD18 arg 00002010 flags 000000b5
[ 4558.265112] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.265114] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.265137] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265150] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.265152] mmc0:     0 bytes transferred: 0
[ 4558.265153] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.265157] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265174] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265188] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265192] mmcblk0: error -110 sending status command, retrying
[ 4558.265194] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265211] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265224] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265228] mmcblk0: error -110 sending status command, retrying
[ 4558.265230] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265246] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265259] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265263] mmcblk0: error -110 sending status command, aborting
[ 4558.265266] end_request: I/O error, dev mmcblk0, sector 8208
[ 4558.265281] mmc0: starting CMD18 arg 00002080 flags 000000b5
[ 4558.265283] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.265284] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.265306] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265319] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.265320] mmc0:     0 bytes transferred: 0
[ 4558.265321] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.265325] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265342] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265354] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265358] mmcblk0: error -110 sending status command, retrying
[ 4558.265360] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265376] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265389] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265393] mmcblk0: error -110 sending status command, retrying
[ 4558.265395] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265411] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265424] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265428] mmcblk0: error -110 sending status command, aborting
[ 4558.265430] end_request: I/O error, dev mmcblk0, sector 8320
[ 4558.265443] mmc0: starting CMD18 arg 00002080 flags 000000b5
[ 4558.265445] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.265447] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.265470] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265483] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.265484] mmc0:     0 bytes transferred: 0
[ 4558.265485] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.265489] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265505] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265521] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265526] mmcblk0: error -110 sending status command, retrying
[ 4558.265528] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265544] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265558] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265562] mmcblk0: error -110 sending status command, retrying
[ 4558.265564] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265580] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265594] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265598] mmcblk0: error -110 sending status command, aborting
[ 4558.265601] end_request: I/O error, dev mmcblk0, sector 8320
[ 4558.265617] mmc0: starting CMD18 arg 00002080 flags 000000b5
[ 4558.265619] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.265621] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.265643] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265657] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.265658] mmc0:     0 bytes transferred: 0
[ 4558.265659] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.265663] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265680] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265693] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265698] mmcblk0: error -110 sending status command, retrying
[ 4558.265700] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265716] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265729] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265733] mmcblk0: error -110 sending status command, retrying
[ 4558.265735] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265752] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265765] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265770] mmcblk0: error -110 sending status command, aborting
[ 4558.265773] end_request: I/O error, dev mmcblk0, sector 8320
[ 4558.265788] mmc0: starting CMD18 arg 00002010 flags 000000b5
[ 4558.265790] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.265792] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.265815] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265829] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.265830] mmc0:     0 bytes transferred: 0
[ 4558.265831] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.265835] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265851] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265864] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265868] mmcblk0: error -110 sending status command, retrying
[ 4558.265870] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265886] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265899] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265903] mmcblk0: error -110 sending status command, retrying
[ 4558.265905] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.265920] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265933] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.265937] mmcblk0: error -110 sending status command, aborting
[ 4558.265940] end_request: I/O error, dev mmcblk0, sector 8208
[ 4558.265953] mmc0: starting CMD18 arg 00002080 flags 000000b5
[ 4558.265955] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.265957] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.265980] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.265993] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.265994] mmc0:     0 bytes transferred: 0
[ 4558.265995] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.265999] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266015] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266028] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266032] mmcblk0: error -110 sending status command, retrying
[ 4558.266034] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266049] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266063] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266066] mmcblk0: error -110 sending status command, retrying
[ 4558.266068] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266084] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266097] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266101] mmcblk0: error -110 sending status command, aborting
[ 4558.266103] end_request: I/O error, dev mmcblk0, sector 8320
[ 4558.266117] mmc0: starting CMD18 arg 00002040 flags 000000b5
[ 4558.266119] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.266121] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.266144] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266157] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.266158] mmc0:     0 bytes transferred: 0
[ 4558.266159] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.266164] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266179] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266196] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266200] mmcblk0: error -110 sending status command, retrying
[ 4558.266202] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266219] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266232] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266236] mmcblk0: error -110 sending status command, retrying
[ 4558.266238] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266254] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266267] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266272] mmcblk0: error -110 sending status command, aborting
[ 4558.266274] end_request: I/O error, dev mmcblk0, sector 8256
[ 4558.266290] mmc0: starting CMD18 arg 00002040 flags 000000b5
[ 4558.266292] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.266294] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.266317] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266330] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.266331] mmc0:     0 bytes transferred: 0
[ 4558.266333] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.266337] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266354] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266367] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266371] mmcblk0: error -110 sending status command, retrying
[ 4558.266373] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266389] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266402] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266406] mmcblk0: error -110 sending status command, retrying
[ 4558.266408] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266424] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266437] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266441] mmcblk0: error -110 sending status command, aborting
[ 4558.266444] end_request: I/O error, dev mmcblk0, sector 8256
[ 4558.266457] mmc0: starting CMD18 arg 00002040 flags 000000b5
[ 4558.266459] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.266460] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.266483] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266496] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.266497] mmc0:     0 bytes transferred: 0
[ 4558.266498] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.266502] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266519] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266532] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266536] mmcblk0: error -110 sending status command, retrying
[ 4558.266538] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266554] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266567] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266571] mmcblk0: error -110 sending status command, retrying
[ 4558.266573] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266589] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266602] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266606] mmcblk0: error -110 sending status command, aborting
[ 4558.266608] end_request: I/O error, dev mmcblk0, sector 8256
[ 4558.266621] mmc0: starting CMD18 arg 00002040 flags 000000b5
[ 4558.266623] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.266625] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.266647] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266660] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.266661] mmc0:     0 bytes transferred: 0
[ 4558.266662] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.266666] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266682] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266698] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266702] mmcblk0: error -110 sending status command, retrying
[ 4558.266704] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266721] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266733] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266737] mmcblk0: error -110 sending status command, retrying
[ 4558.266739] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266756] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266769] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266773] mmcblk0: error -110 sending status command, aborting
[ 4558.266775] end_request: I/O error, dev mmcblk0, sector 8256
[ 4558.266791] mmc0: starting CMD18 arg 00002040 flags 000000b5
[ 4558.266793] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.266795] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.266818] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266832] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.266833] mmc0:     0 bytes transferred: 0
[ 4558.266835] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.266839] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266855] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266868] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266872] mmcblk0: error -110 sending status command, retrying
[ 4558.266874] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266891] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266903] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266908] mmcblk0: error -110 sending status command, retrying
[ 4558.266910] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.266925] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.266938] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.266942] mmcblk0: error -110 sending status command, aborting
[ 4558.266945] end_request: I/O error, dev mmcblk0, sector 8256
[ 4558.266969] mmc0: starting CMD18 arg 00002040 flags 000000b5
[ 4558.266971] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.266973] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.266996] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267010] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.267011] mmc0:     0 bytes transferred: 0
[ 4558.267012] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.267016] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267032] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267044] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267048] mmcblk0: error -110 sending status command, retrying
[ 4558.267050] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267066] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267079] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267083] mmcblk0: error -110 sending status command, retrying
[ 4558.267085] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267100] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267113] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267117] mmcblk0: error -110 sending status command, aborting
[ 4558.267119] end_request: I/O error, dev mmcblk0, sector 8256
[ 4558.267131] mmc0: starting CMD18 arg 00002040 flags 000000b5
[ 4558.267133] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.267135] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.267158] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267171] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.267172] mmc0:     0 bytes transferred: 0
[ 4558.267173] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.267177] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267193] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267205] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267209] mmcblk0: error -110 sending status command, retrying
[ 4558.267211] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267228] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267242] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267247] mmcblk0: error -110 sending status command, retrying
[ 4558.267249] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267266] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267279] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267283] mmcblk0: error -110 sending status command, aborting
[ 4558.267286] end_request: I/O error, dev mmcblk0, sector 8256
[ 4558.267302] mmc0: starting CMD18 arg 00002040 flags 000000b5
[ 4558.267304] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.267306] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.267329] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267342] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.267343] mmc0:     0 bytes transferred: 0
[ 4558.267344] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.267349] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267365] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267377] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267382] mmcblk0: error -110 sending status command, retrying
[ 4558.267384] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267400] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267414] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267418] mmcblk0: error -110 sending status command, retrying
[ 4558.267420] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267437] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267450] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267455] mmcblk0: error -110 sending status command, aborting
[ 4558.267457] end_request: I/O error, dev mmcblk0, sector 8256
[ 4558.267470] mmc0: starting CMD18 arg 00002040 flags 000000b5
[ 4558.267471] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.267473] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.267494] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267511] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.267512] mmc0:     0 bytes transferred: 0
[ 4558.267513] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.267518] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267535] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267549] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267553] mmcblk0: error -110 sending status command, retrying
[ 4558.267555] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267571] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267584] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267588] mmcblk0: error -110 sending status command, retrying
[ 4558.267590] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267606] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267618] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267622] mmcblk0: error -110 sending status command, aborting
[ 4558.267625] end_request: I/O error, dev mmcblk0, sector 8256
[ 4558.267638] mmc0: starting CMD18 arg 00002040 flags 000000b5
[ 4558.267640] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.267642] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.267663] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267680] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.267681] mmc0:     0 bytes transferred: 0
[ 4558.267682] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.267686] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267702] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267715] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267719] mmcblk0: error -110 sending status command, retrying
[ 4558.267721] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267737] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267750] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267754] mmcblk0: error -110 sending status command, retrying
[ 4558.267756] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267771] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267784] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267788] mmcblk0: error -110 sending status command, aborting
[ 4558.267791] end_request: I/O error, dev mmcblk0, sector 8256
[ 4558.267814] mmc0: starting CMD18 arg 00002100 flags 000000b5
[ 4558.267816] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.267818] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.267841] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267855] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.267857] mmc0:     0 bytes transferred: 0
[ 4558.267859] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.267865] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267881] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267894] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267899] mmcblk0: error -110 sending status command, retrying
[ 4558.267901] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267917] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267931] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267935] mmcblk0: error -110 sending status command, retrying
[ 4558.267937] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.267953] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.267966] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.267970] mmcblk0: error -110 sending status command, aborting
[ 4558.267973] end_request: I/O error, dev mmcblk0, sector 8448
[ 4558.267990] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.267992] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.267993] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.268015] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268028] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.268029] mmc0:     0 bytes transferred: 0
[ 4558.268030] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.268035] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268051] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268064] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268068] mmcblk0: error -110 sending status command, retrying
[ 4558.268070] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268086] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268099] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268103] mmcblk0: error -110 sending status command, retrying
[ 4558.268105] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268121] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268134] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268137] mmcblk0: error -110 sending status command, aborting
[ 4558.268140] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.268153] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.268155] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.268157] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.268181] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268193] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.268195] mmc0:     0 bytes transferred: 0
[ 4558.268196] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.268200] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268215] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268228] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268233] mmcblk0: error -110 sending status command, retrying
[ 4558.268235] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268251] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268264] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268268] mmcblk0: error -110 sending status command, retrying
[ 4558.268270] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268286] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268299] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268303] mmcblk0: error -110 sending status command, aborting
[ 4558.268306] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.268318] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.268320] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.268322] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.268344] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268357] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.268358] mmc0:     0 bytes transferred: 0
[ 4558.268359] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.268364] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268380] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268393] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268397] mmcblk0: error -110 sending status command, retrying
[ 4558.268399] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268415] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268428] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268433] mmcblk0: error -110 sending status command, retrying
[ 4558.268435] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268450] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268463] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268466] mmcblk0: error -110 sending status command, aborting
[ 4558.268469] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.268483] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.268485] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.268486] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.268510] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268524] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.268525] mmc0:     0 bytes transferred: 0
[ 4558.268527] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.268532] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268549] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268562] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268566] mmcblk0: error -110 sending status command, retrying
[ 4558.268568] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268584] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268597] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268601] mmcblk0: error -110 sending status command, retrying
[ 4558.268603] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268619] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268632] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268636] mmcblk0: error -110 sending status command, aborting
[ 4558.268638] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.268653] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.268655] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.268657] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.268680] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268696] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.268697] mmc0:     0 bytes transferred: 0
[ 4558.268698] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.268703] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268718] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268731] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268735] mmcblk0: error -110 sending status command, retrying
[ 4558.268737] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268754] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268767] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268771] mmcblk0: error -110 sending status command, retrying
[ 4558.268773] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268788] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268802] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268807] mmcblk0: error -110 sending status command, aborting
[ 4558.268809] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.268823] mmc0: starting CMD18 arg 00002010 flags 000000b5
[ 4558.268825] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.268826] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.268849] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268862] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.268863] mmc0:     0 bytes transferred: 0
[ 4558.268864] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.268869] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268885] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268898] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268902] mmcblk0: error -110 sending status command, retrying
[ 4558.268904] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268919] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268933] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268937] mmcblk0: error -110 sending status command, retrying
[ 4558.268939] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.268955] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.268968] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.268971] mmcblk0: error -110 sending status command, aborting
[ 4558.268974] end_request: I/O error, dev mmcblk0, sector 8208
[ 4558.268986] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.268988] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.268990] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.269012] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269025] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.269026] mmc0:     0 bytes transferred: 0
[ 4558.269027] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.269031] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269047] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269060] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269064] mmcblk0: error -110 sending status command, retrying
[ 4558.269066] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269082] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269095] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269100] mmcblk0: error -110 sending status command, retrying
[ 4558.269102] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269118] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269131] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269135] mmcblk0: error -110 sending status command, aborting
[ 4558.269137] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.269150] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.269152] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.269154] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.269176] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269189] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.269190] mmc0:     0 bytes transferred: 0
[ 4558.269191] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.269196] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269212] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269228] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269232] mmcblk0: error -110 sending status command, retrying
[ 4558.269234] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269250] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269263] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269267] mmcblk0: error -110 sending status command, retrying
[ 4558.269269] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269285] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269298] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269302] mmcblk0: error -110 sending status command, aborting
[ 4558.269305] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.269317] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.269319] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.269321] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.269342] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269355] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.269356] mmc0:     0 bytes transferred: 0
[ 4558.269357] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.269361] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269379] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269391] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269395] mmcblk0: error -110 sending status command, retrying
[ 4558.269397] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269413] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269427] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269431] mmcblk0: error -110 sending status command, retrying
[ 4558.269432] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269448] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269461] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269465] mmcblk0: error -110 sending status command, aborting
[ 4558.269467] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.269479] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.269481] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.269483] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.269507] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269523] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.269525] mmc0:     0 bytes transferred: 0
[ 4558.269527] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.269532] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269548] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269561] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269566] mmcblk0: error -110 sending status command, retrying
[ 4558.269568] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269584] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269597] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269601] mmcblk0: error -110 sending status command, retrying
[ 4558.269603] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269619] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269633] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269637] mmcblk0: error -110 sending status command, aborting
[ 4558.269640] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.269651] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.269653] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.269655] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.269676] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269689] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.269690] mmc0:     0 bytes transferred: 0
[ 4558.269691] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.269696] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269712] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269725] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269729] mmcblk0: error -110 sending status command, retrying
[ 4558.269731] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269747] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269760] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269764] mmcblk0: error -110 sending status command, retrying
[ 4558.269766] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269781] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269794] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269798] mmcblk0: error -110 sending status command, aborting
[ 4558.269801] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.269812] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.269814] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.269816] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.269838] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269851] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.269852] mmc0:     0 bytes transferred: 0
[ 4558.269854] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.269858] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269874] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269887] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269890] mmcblk0: error -110 sending status command, retrying
[ 4558.269892] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269907] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269920] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269924] mmcblk0: error -110 sending status command, retrying
[ 4558.269926] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.269942] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.269955] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.269959] mmcblk0: error -110 sending status command, aborting
[ 4558.269962] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.269972] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.269974] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.269976] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.269999] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270012] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.270013] mmc0:     0 bytes transferred: 0
[ 4558.270014] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.270019] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270034] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270047] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270052] mmcblk0: error -110 sending status command, retrying
[ 4558.270054] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270069] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270082] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270087] mmcblk0: error -110 sending status command, retrying
[ 4558.270089] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270104] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270117] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270122] mmcblk0: error -110 sending status command, aborting
[ 4558.270124] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.270137] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.270139] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.270141] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.270164] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270178] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.270179] mmc0:     0 bytes transferred: 0
[ 4558.270180] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.270184] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270200] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270213] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270217] mmcblk0: error -110 sending status command, retrying
[ 4558.270219] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270235] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270248] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270252] mmcblk0: error -110 sending status command, retrying
[ 4558.270254] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270269] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270282] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270286] mmcblk0: error -110 sending status command, aborting
[ 4558.270288] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.270300] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.270302] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.270304] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.270327] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270340] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.270341] mmc0:     0 bytes transferred: 0
[ 4558.270342] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.270346] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270361] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270374] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270378] mmcblk0: error -110 sending status command, retrying
[ 4558.270380] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270396] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270409] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270413] mmcblk0: error -110 sending status command, retrying
[ 4558.270415] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270431] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270444] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270448] mmcblk0: error -110 sending status command, aborting
[ 4558.270451] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.270464] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.270466] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.270468] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.270491] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270507] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.270508] mmc0:     0 bytes transferred: 0
[ 4558.270509] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.270515] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270531] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270545] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270549] mmcblk0: error -110 sending status command, retrying
[ 4558.270551] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270567] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270580] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270584] mmcblk0: error -110 sending status command, retrying
[ 4558.270586] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270602] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270615] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270619] mmcblk0: error -110 sending status command, aborting
[ 4558.270622] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.270634] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.270636] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.270638] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.270660] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270674] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.270675] mmc0:     0 bytes transferred: 0
[ 4558.270676] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.270680] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270696] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270709] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270713] mmcblk0: error -110 sending status command, retrying
[ 4558.270714] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270730] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270743] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270747] mmcblk0: error -110 sending status command, retrying
[ 4558.270749] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270765] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270778] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270784] mmcblk0: error -110 sending status command, aborting
[ 4558.270786] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.270798] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.270800] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.270802] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.270824] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270837] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.270839] mmc0:     0 bytes transferred: 0
[ 4558.270840] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.270844] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270860] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270873] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270877] mmcblk0: error -110 sending status command, retrying
[ 4558.270879] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270896] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270909] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270913] mmcblk0: error -110 sending status command, retrying
[ 4558.270915] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.270932] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.270948] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.270953] mmcblk0: error -110 sending status command, aborting
[ 4558.270955] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.270966] mmc0: starting CMD18 arg 00002080 flags 000000b5
[ 4558.270968] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.270970] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.270992] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271006] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.271007] mmc0:     0 bytes transferred: 0
[ 4558.271008] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.271013] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.271029] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271042] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.271047] mmcblk0: error -110 sending status command, retrying
[ 4558.271049] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.271065] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271078] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.271082] mmcblk0: error -110 sending status command, retrying
[ 4558.271084] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.271101] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271115] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.271119] mmcblk0: error -110 sending status command, aborting
[ 4558.271121] end_request: I/O error, dev mmcblk0, sector 8320
[ 4558.271132] mmc0: starting CMD18 arg 00002080 flags 000000b5
[ 4558.271134] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.271136] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.271158] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271171] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.271173] mmc0:     0 bytes transferred: 0
[ 4558.271174] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.271178] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.271194] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271207] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.271211] mmcblk0: error -110 sending status command, retrying
[ 4558.271213] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.271228] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271241] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.271245] mmcblk0: error -110 sending status command, retrying
[ 4558.271247] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.271263] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271276] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.271280] mmcblk0: error -110 sending status command, aborting
[ 4558.271282] end_request: I/O error, dev mmcblk0, sector 8320
[ 4558.271299] mmc0: starting CMD18 arg 00002010 flags 000000b5
[ 4558.271301] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.271303] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.271325] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271338] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.271339] mmc0:     0 bytes transferred: 0
[ 4558.271340] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.271344] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.271360] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271374] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.271378] mmcblk0: error -110 sending status command, retrying
[ 4558.271380] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.271397] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271410] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.271414] mmcblk0: error -110 sending status command, retrying
[ 4558.271416] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.271432] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271445] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.271449] mmcblk0: error -110 sending status command, aborting
[ 4558.271452] end_request: I/O error, dev mmcblk0, sector 8208
[ 4558.271465] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.271467] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.271469] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.271491] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271507] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.271509] mmc0:     0 bytes transferred: 0
[ 4558.271510] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.271514] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.271531] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271544] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.271548] mmcblk0: error -110 sending status command, retrying
[ 4558.271551] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.271567] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271580] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.271585] mmcblk0: error -110 sending status command, retrying
[ 4558.271587] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.271602] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271616] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.271619] mmcblk0: error -110 sending status command, aborting
[ 4558.271622] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.271635] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.271637] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.271639] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.271661] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271674] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.271675] mmc0:     0 bytes transferred: 0
[ 4558.271676] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.271680] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.271699] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.271712] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.272502] mmcblk0: error -110 sending status command, retrying
[ 4558.272506] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.272525] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.272540] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.272545] mmcblk0: error -110 sending status command, retrying
[ 4558.272547] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.272563] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.272576] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.272581] mmcblk0: error -110 sending status command, aborting
[ 4558.272585] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.272604] mmc0: starting CMD18 arg 00002008 flags 000000b5
[ 4558.272607] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.272609] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.272633] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.272646] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.272647] mmc0:     0 bytes transferred: 0
[ 4558.272648] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.272653] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.272668] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.272681] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.272685] mmcblk0: error -110 sending status command, retrying
[ 4558.272688] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.272703] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.272716] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.272719] mmcblk0: error -110 sending status command, retrying
[ 4558.272721] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.272737] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.272750] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.272754] mmcblk0: error -110 sending status command, aborting
[ 4558.272757] end_request: I/O error, dev mmcblk0, sector 8200
[ 4558.272768] mmc0: starting CMD18 arg 00002010 flags 000000b5
[ 4558.272770] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.272772] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.272796] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.272809] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.272810] mmc0:     0 bytes transferred: 0
[ 4558.272811] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.272816] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.272832] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.272845] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.272849] mmcblk0: error -110 sending status command, retrying
[ 4558.272850] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.272866] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.272879] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.272883] mmcblk0: error -110 sending status command, retrying
[ 4558.272885] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.272901] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.272914] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.272918] mmcblk0: error -110 sending status command, aborting
[ 4558.272921] end_request: I/O error, dev mmcblk0, sector 8208
[ 4558.272933] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.272934] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.272936] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.272959] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.272972] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.272973] mmc0:     0 bytes transferred: 0
[ 4558.272974] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.272979] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.272994] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.273008] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.273011] mmcblk0: error -110 sending status command, retrying
[ 4558.273013] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.273029] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.273042] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.273046] mmcblk0: error -110 sending status command, retrying
[ 4558.273048] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.273064] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.273077] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.273081] mmcblk0: error -110 sending status command, aborting
[ 4558.273084] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.273095] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.273097] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.273098] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.273122] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.273134] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.273136] mmc0:     0 bytes transferred: 0
[ 4558.273137] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.273141] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.273157] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.273171] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.273175] mmcblk0: error -110 sending status command, retrying
[ 4558.273178] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.273193] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.273206] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.273210] mmcblk0: error -110 sending status command, retrying
[ 4558.273212] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.273228] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.273241] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.273245] mmcblk0: error -110 sending status command, aborting
[ 4558.273247] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.273258] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.273260] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.273262] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.273285] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.273298] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.273300] mmc0:     0 bytes transferred: 0
[ 4558.273301] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.273305] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.273322] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.273334] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.273339] mmcblk0: error -110 sending status command, retrying
[ 4558.273341] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.273359] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.273373] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.274032] mmcblk0: error -110 sending status command, retrying
[ 4558.274035] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.274054] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274069] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.274074] mmcblk0: error -110 sending status command, aborting
[ 4558.274077] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.274098] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.274100] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.274102] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.274127] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274141] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.274143] mmc0:     0 bytes transferred: 0
[ 4558.274145] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.274149] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.274165] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274178] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.274181] mmcblk0: error -110 sending status command, retrying
[ 4558.274182] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.274199] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274211] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.274214] mmcblk0: error -110 sending status command, retrying
[ 4558.274215] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.274230] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274243] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.274245] mmcblk0: error -110 sending status command, aborting
[ 4558.274247] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.274258] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.274259] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.274260] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.274282] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274296] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.274297] mmc0:     0 bytes transferred: 0
[ 4558.274298] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.274301] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.274317] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274330] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.274332] mmcblk0: error -110 sending status command, retrying
[ 4558.274333] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.274349] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274362] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.274364] mmcblk0: error -110 sending status command, retrying
[ 4558.274366] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.274382] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274395] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.274397] mmcblk0: error -110 sending status command, aborting
[ 4558.274399] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.274427] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.274428] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.274429] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.274452] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274465] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.274471] mmc0:     0 bytes transferred: 0
[ 4558.274472] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.274476] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.274498] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274514] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.274741] mmcblk0: error -110 sending status command, retrying
[ 4558.274744] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.274762] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274777] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.274782] mmcblk0: error -110 sending status command, retrying
[ 4558.274784] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.274800] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274813] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.274818] mmcblk0: error -110 sending status command, aborting
[ 4558.274821] end_request: I/O error, dev mmcblk0, sector 8192
[ 4558.274838] mmc0: starting CMD18 arg 00002008 flags 000000b5
[ 4558.274841] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.274842] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.274865] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274878] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.274879] mmc0:     0 bytes transferred: 0
[ 4558.274880] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.274886] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.274902] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274916] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.274920] mmcblk0: error -110 sending status command, retrying
[ 4558.274922] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.274937] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274950] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.274954] mmcblk0: error -110 sending status command, retrying
[ 4558.274956] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.274972] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.274985] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.274989] mmcblk0: error -110 sending status command, aborting
[ 4558.274992] end_request: I/O error, dev mmcblk0, sector 8200
[ 4558.275008] mmc0: starting CMD18 arg 00002080 flags 000000b5
[ 4558.275010] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.275012] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.275035] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.275051] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.275052] mmc0:     0 bytes transferred: 0
[ 4558.275053] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.275058] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.275074] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.275087] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.275092] mmcblk0: error -110 sending status command, retrying
[ 4558.275094] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.275110] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.275123] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.275127] mmcblk0: error -110 sending status command, retrying
[ 4558.275129] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.275146] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.275161] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.275166] mmcblk0: error -110 sending status command, aborting
[ 4558.275169] end_request: I/O error, dev mmcblk0, sector 8320
[ 4558.275185] mmc0: starting CMD18 arg 00002000 flags 000000b5
[ 4558.275187] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 4558.275189] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 4558.275211] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.275224] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 4558.275226] mmc0:     0 bytes transferred: 0
[ 4558.275227] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 4558.275231] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 4558.275247] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 4558.275260] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 4558.275264] mmcblk0: error -110 sending status command, retrying
[...]

Thanks,
	J



