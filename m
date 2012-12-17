Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2LQKwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 05:52:10 -0500
Received: from smtp1.uu.se ([130.238.7.54]:37451 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2LQKwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 05:52:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20686.63778.840426.61474@pilspetsen.it.uu.se>
Date: Mon, 17 Dec 2012 11:51:14 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [3.7.0 regression] rt2x00lib_probe_dev: Error - Failed to initialize hw
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just updated an old 1st gen AMD64 laptop from kernel 3.6.0 to 3.7.0,
Fedora 15 user-space, and was greeted by the following kernel warning:

WARNING: at net/wireless/core.c:389 wiphy_register+0x5c3/0x600 [cfg80211]()
Hardware name: SAM#451B
Modules linked in: rt2500pci(+) snd_mpu401_uart rt2x00pci snd_rawmidi rt2x00lib sg snd_seq_device mac80211 cfg80211 amd64_agp agpgart snd eeprom_93cx6 soundcore via_rhine mii evdev ipv6 ehci_hcd uhci_hcd sr_mod cdrom usbcore usb_common
Pid: 378, comm: modprobe Not tainted 3.7.0 #1
Call Trace:
 [<ffffffff810260b9>] ? warn_slowpath_common+0x79/0xc0
 [<ffffffffa0115773>] ? wiphy_register+0x5c3/0x600 [cfg80211]
 [<ffffffff810c5b3f>] ? __kmalloc+0xef/0x170
 [<ffffffffa013ac97>] ? ieee80211_register_hw+0x347/0x6d0 [mac80211]
 [<ffffffffa00f92ed>] ? rt2x00lib_probe_dev+0x53d/0x720 [rt2x00lib]
 [<ffffffffa0060888>] ? rt2x00pci_probe+0x168/0x2e4 [rt2x00pci]
 [<ffffffff81194cd0>] ? pci_device_probe+0xd0/0x170
 [<ffffffff811f2934>] ? driver_probe_device+0x64/0x210
 [<ffffffff811f2b73>] ? __driver_attach+0x93/0xa0
 [<ffffffff811f2ae0>] ? driver_probe_device+0x210/0x210
 [<ffffffff811f0f95>] ? bus_for_each_dev+0x45/0x80
 [<ffffffff811f20d8>] ? bus_add_driver+0x178/0x250
 [<ffffffff811f314e>] ? driver_register+0x6e/0x170
 [<ffffffff81048a14>] ? notifier_call_chain+0x44/0x60
 [<ffffffffa0196000>] ? 0xffffffffa0195fff
 [<ffffffff810002ca>] ? do_one_initcall+0x11a/0x160
 [<ffffffff81069786>] ? sys_init_module+0x76/0x1c0
 [<ffffffff812c15d0>] ? system_call_fastpath+0x16/0x1b
---[ end trace f8413f27de31929d ]---
phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
rt2500pci: probe of 0000:00:0c.0 failed with error -22

Rebooting into 3.6.0 shows no such error, booting 3.7.0 again shows the error,
so it's completely reproducible.

lspci -v for the device in question:

00:0c.0 Network controller: Ralink corp. RT2500 802.11g (rev 01)
	Subsystem: Micro-Star International Co., Ltd. Unknown 802.11g mini-PCI Adapter
	Flags: bus master, slow devsel, latency 64, IRQ 18
	Memory at d0000000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [40] Power Management version 2
	Kernel driver in use: rt2500pci
	Kernel modules: rt2500pci

I've never actually used or configured this device (the laptop is always
on wired ethernet), but thought you should know about this possible driver
regression.

/Mikael
