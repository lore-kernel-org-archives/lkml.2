Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab0KUKXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 05:23:45 -0500
Received: from relay.ptn-ipout02.plus.net ([212.159.7.36]:27292 "EHLO
	relay.ptn-ipout02.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114Ab0KUKXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 05:23:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFqB6EzUnw4T/2dsb2JhbACiZ3G7JoVLBIpegw4
Date: Sun, 21 Nov 2010 10:23:44 +0000
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel 2.6.37-rc2 breaks i915 graphics
Message-ID: <20101121102344.7c590b99@laptop.homenet>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With kernel 2.6.37-rc2, i915 graphics usually fails on boot-up after
modesetting with my Lenovo S12 netbook which uses the Intel 945GME
Express Integrated Graphics Controller.  It displays up to the point at
which modesetting takes place and then usually goes blank.

There may be some kind of race at work here: first, sometimes (maybe 1
times in 4) graphics comes up correctly on a first cold boot, but I
have never managed to get it to come up on a warm reboot. Secondly,
graphics can be restored when I know (but cannot see) that boot-up has
concluded, simply by suspending the laptop and then resuming.  Resuming
the laptop after a suspend always brings up the graphics correctly.

I have not tested against 2.6.37-rc1, so I cannot say whether the
problem is there as well.

lspci -v gives this:

00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory
Controller Hub (rev 03)
	Subsystem: Lenovo Device 386f
	Flags: bus master, fast devsel, latency 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel driver in use: agpgart-intel
	Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME
Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA
controller])
	Subsystem: Lenovo Device 3870
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at fc000000 (32-bit, non-prefetchable) [size=512K]
	I/O ports at 1800 [size=8]
	Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Memory at fc100000 (32-bit, non-prefetchable) [size=256K]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [d0] Power Management version 2
	Kernel driver in use: i915
	Kernel modules: i915

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
943/940GML Express Integrated Graphics Controller (rev 03)
	Subsystem: Lenovo Device 3870
	Flags: bus master, fast devsel, latency 0
	Memory at fc080000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: [d0] Power Management version 2

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 02)
	Subsystem: Lenovo Device 3be9
	Flags: bus master, fast devsel, latency 0, IRQ 22
	Memory at fc140000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Root Complex Integrated Endpoint,
MSI 00
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: f6000000-f7ffffff
	Prefetchable memory behind bridge:
00000000f0000000-00000000f1ffffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Lenovo Device 3bea
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 2 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: f8000000-f9ffffff
	Prefetchable memory behind bridge:
00000000f2000000-00000000f3ffffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Lenovo Device 3cb4
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>

00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 3 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 00005000-00005fff
	Memory behind bridge: 40000000-401fffff
	Prefetchable memory behind bridge:
0000000040200000-00000000403fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Lenovo Device 3beb
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>

00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 4 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: fa000000-fbffffff
	Prefetchable memory behind bridge:
00000000f4000000-00000000f5ffffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Lenovo Device 3cb6
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
Controller #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device 3bec
	Flags: bus master, medium devsel, latency 0, IRQ 23
	I/O ports at 1820 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
Controller #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device 3bcd
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at 1840 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
Controller #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device 3bee
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 1860 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
Controller #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device 3bef
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at 1880 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
EHCI Controller (rev 02) (prog-if 20 [EHCI])
	Subsystem: Lenovo Device 3bf0
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at fc344000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
(prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=32
	Capabilities: [50] Subsystem: Lenovo Device 3bf1

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
Bridge (rev 02)
	Subsystem: Lenovo Device 3bf2
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: leds-ss4200, intel-rng

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Lenovo Device 3bf3
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 1810 [size=16]
	Kernel driver in use: ata_piix

00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family)
SATA AHCI Controller (rev 02) (prog-if 01 [AHCI 1.0])
	Subsystem: Lenovo Device 3bf4
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
	I/O ports at 18c8 [size=8]
	I/O ports at 18c0 [size=4]
	I/O ports at 18a8 [size=8]
	I/O ports at 180c [size=4]
	I/O ports at 18b0 [size=16]
	Memory at fc344400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [70] Power Management version 2
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller
(rev 02)
	Subsystem: Lenovo Device 3bf5
	Flags: medium devsel, IRQ 19
	I/O ports at 18e0 [size=32]
	Kernel modules: i2c-i801

02:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5906M Fast
Ethernet PCI Express (rev 02)
	Subsystem: Lenovo Device 3a2a
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at f6000000 (64-bit, non-prefetchable) [size=64K]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [48] Power Management version 3
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Vendor Specific Information <?>
	Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [d0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [13c] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 00-1f-16-ff-fe-1f-85-a4
	Kernel driver in use: tg3
	Kernel modules: tg3

03:00.0 Network controller: Broadcom Corporation BCM4312 802.11b/g (rev
01)
	Subsystem: Broadcom Corporation Device 04b5
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at f8000000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [58] Vendor Specific Information <?>
	Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [d0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [13c] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 97-ac-00-ff-ff-f4-00-21
	Capabilities: [16c] Power Budgeting <?>
	Kernel driver in use: wl
	Kernel modules: wl, ssb

Chris
