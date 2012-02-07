Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab2BGDeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 22:34:23 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:42298 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755996Ab2BGDeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 22:34:22 -0500
MIME-Version: 1.0
Date: Tue, 7 Feb 2012 11:34:21 +0800
Message-ID: <CAAJw_ZsryUFFFRCKdd9sQ7_38hjpVq37b6hhZDX5=qz8x1B+EQ@mail.gmail.com>
Subject: mmc sdhci mmcblk0: error -110 sending status command, retrying
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Adrian Hunter <adrian.hunter@nokia.com>, Chris Ball <cjb@laptop.org>,
        Pierre Ossman <pierre@ossman.eu>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SD slot on the Lenovo X220 is doesn't seems to work on
Linux-3.3.0-rc2. I haven't use SD for a while, so don't know which
linux version will work on the X220.


# cat .config
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
CONFIG_MMC_CLKGATE=y
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y


# lspcpi -v

0d:00.0 System peripheral: Ricoh Co Ltd Device e823 (rev 04) (prog-if 01)
        Subsystem: Lenovo Device 21da
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at f1500000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [78] Power Management version 3
        Capabilities: [80] Express Endpoint, MSI 00
        Kernel driver in use: sdhci-pci
        Kernel modules: sdhci-pci


# dmesg
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e823] (rev 4)
sdhci-pci 0000:0d:00.0: found 1 slot(s)
sdhci [sdhci_add_host()]: mmc0: Auto-CMD23 unavailable
sdhci: =========== REGISTER DUMP (mmc0)===========
sdhci: Sys addr: 0x00000000 | Version:  0x00000502
sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
sdhci: Present:  0x01f70000 | Host ctl: 0x00000000
sdhci: Power:    0x00000000 | Blk gap:  0x00000000
sdhci: Wake-up:  0x00000000 | Clock:    0x00000000
sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
sdhci: Int enab: 0x00ff0003 | Sig enab: 0x00ff0003
sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
sdhci: Caps:     0x21e832b2 | Caps_1:   0x00008073
sdhci: Cmd:      0x00000000 | Max curr: 0x00000040
sdhci: Host ctl2: 0x00000000
sdhci: ===========================================

mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
mmc0:     0 bytes transferred: -84
mmc0:     (CMD12): -110: 00000000 00000000 00000000 00000000
mmc0: starting CMD13 arg b3680000 flags 00000195
sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
mmcblk0: error -110 sending status command, retrying
mmc0: starting CMD13 arg b3680000 flags 00000195
sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
mmcblk0: error -110 sending status command, retrying
mmc0: starting CMD13 arg b3680000 flags 00000195
sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
mmc0: req done (CMD13): 0: 00800b00 00000000 00000000 00000000
mmc0: starting CMD12 arg 00000000 flags 0000049d
sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
mmc0: req done (CMD12): 0: 00000b00 00000000 00000000 00000000
mmcblk0: error -110 sending stop command, original cmd response 0x900,
card status 0x800b00
mmcblk0: error -84 transferring data, sector 0, nr 32, cmd response
0x900, card status 0xb00
mmcblk0: retrying using single block read
mmc0: starting CMD17 arg 00000000 flags 000000b5
mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
mmc0:     512 bytes transferred: 0
mmc0: starting CMD17 arg 00000001 flags 000000b5
mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002


Any help will be very much appreciated.

Thanks,
Jeff
