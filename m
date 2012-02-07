Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab2BGDjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 22:39:10 -0500
Received: from void.printf.net ([89.145.121.20]:58659 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab2BGDjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 22:39:07 -0500
From: Chris Ball <cjb@laptop.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>, Pierre Ossman <pierre@ossman.eu>,
        lkml <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org
Subject: Re: mmc sdhci mmcblk0: error -110 sending status command, retrying
References: <CAAJw_ZsryUFFFRCKdd9sQ7_38hjpVq37b6hhZDX5=qz8x1B+EQ@mail.gmail.com>
Date: Mon, 06 Feb 2012 22:38:53 -0500
In-Reply-To: <CAAJw_ZsryUFFFRCKdd9sQ7_38hjpVq37b6hhZDX5=qz8x1B+EQ@mail.gmail.com>
	(Jeff Chua's message of "Tue, 7 Feb 2012 11:34:21 +0800")
Message-ID: <m2pqdr2tyq.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, adding linux-mmc@ to the thread,

On Mon, Feb 06 2012, Jeff Chua wrote:
> The SD slot on the Lenovo X220 is doesn't seems to work on
> Linux-3.3.0-rc2. I haven't use SD for a while, so don't know which
> linux version will work on the X220.
>
>
> # cat .config
> CONFIG_MMC=m
> CONFIG_MMC_DEBUG=y
> CONFIG_MMC_CLKGATE=y
> CONFIG_MMC_BLOCK=m
> CONFIG_MMC_BLOCK_MINORS=8
> CONFIG_MMC_BLOCK_BOUNCE=y
> CONFIG_MMC_SDHCI=m
> CONFIG_MMC_SDHCI_PCI=m
> CONFIG_MMC_RICOH_MMC=y
>
>
> # lspcpi -v
>
> 0d:00.0 System peripheral: Ricoh Co Ltd Device e823 (rev 04) (prog-if 01)
>         Subsystem: Lenovo Device 21da
>         Flags: bus master, fast devsel, latency 0, IRQ 16
>         Memory at f1500000 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
>         Capabilities: [78] Power Management version 3
>         Capabilities: [80] Express Endpoint, MSI 00
>         Kernel driver in use: sdhci-pci
>         Kernel modules: sdhci-pci
>
>
> # dmesg
> sdhci: Secure Digital Host Controller Interface driver
> sdhci: Copyright(c) Pierre Ossman
> sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e823] (rev 4)
> sdhci-pci 0000:0d:00.0: found 1 slot(s)
> sdhci [sdhci_add_host()]: mmc0: Auto-CMD23 unavailable
> sdhci: =========== REGISTER DUMP (mmc0)===========
> sdhci: Sys addr: 0x00000000 | Version:  0x00000502
> sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
> sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
> sdhci: Present:  0x01f70000 | Host ctl: 0x00000000
> sdhci: Power:    0x00000000 | Blk gap:  0x00000000
> sdhci: Wake-up:  0x00000000 | Clock:    0x00000000
> sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
> sdhci: Int enab: 0x00ff0003 | Sig enab: 0x00ff0003
> sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
> sdhci: Caps:     0x21e832b2 | Caps_1:   0x00008073
> sdhci: Cmd:      0x00000000 | Max curr: 0x00000040
> sdhci: Host ctl2: 0x00000000
> sdhci: ===========================================
>
> mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> mmc0:     0 bytes transferred: -84
> mmc0:     (CMD12): -110: 00000000 00000000 00000000 00000000
> mmc0: starting CMD13 arg b3680000 flags 00000195
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
> mmcblk0: error -110 sending status command, retrying
> mmc0: starting CMD13 arg b3680000 flags 00000195
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
> mmcblk0: error -110 sending status command, retrying
> mmc0: starting CMD13 arg b3680000 flags 00000195
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> mmc0: req done (CMD13): 0: 00800b00 00000000 00000000 00000000
> mmc0: starting CMD12 arg 00000000 flags 0000049d
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> mmc0: req done (CMD12): 0: 00000b00 00000000 00000000 00000000
> mmcblk0: error -110 sending stop command, original cmd response 0x900,
> card status 0x800b00
> mmcblk0: error -84 transferring data, sector 0, nr 32, cmd response
> 0x900, card status 0xb00
> mmcblk0: retrying using single block read
> mmc0: starting CMD17 arg 00000000 flags 000000b5
> mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> mmc0:     512 bytes transferred: 0
> mmc0: starting CMD17 arg 00000001 flags 000000b5
> mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
>
>
> Any help will be very much appreciated.

Could you try another SD card to confirm that it's the controller?
If it is, a bisect (at least between kernel versions) is probably
a good idea.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
