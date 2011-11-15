Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1KOPP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:15:29 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53560 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab1KOPP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:15:27 -0500
Date: Tue, 15 Nov 2011 13:14:46 -0200 (BRST)
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
X-X-Sender: marcos@darkstar.example.net
To: linux-kernel@vger.kernel.org
cc: keithp@keithp.com, airlied@linux.ie, dri-devel@lists.freedesktop.org
Subject: max PWM is zero
Message-ID: <alpine.LNX.2.00.1111151301410.2693@darkstar.example.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1037641694-1321370092=:2693"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1037641694-1321370092=:2693
Content-Type: TEXT/PLAIN; format=flowed; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Hi lkml,

I'm using the kernel 3.2-rc1 and I'm getting the following message in my 
dmesg:
fixme: max PWM is zero.

I don't remember if this message was here before...

I'm trying to verify what is causing this. I found this waring message in 
the drivers/gpu/drm/i915/intel_panel.c.

There is a comment above  this message, talking about put a code to query 
mode clock or hw clock to set the max PWM.

Bellow is my lspci.

I will be happy if you continue to cc me, and if you need any test, I'm 
able to do this.

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 09)
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, fast devsel, latency 0
 	Capabilities: [e0] Vendor Specific Information: Len=0a <?>
 	Kernel driver in use: agpgart-intel
 	Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 09) (prog-if 00 [VGA controller])
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, fast devsel, latency 0, IRQ 44
 	Memory at f8000000 (64-bit, non-prefetchable) [size=4M]
 	Memory at d0000000 (64-bit, prefetchable) [size=256M]
 	I/O ports at 1800 [size=8]
 	Expansion ROM at <unassigned> [disabled]
 	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
 	Capabilities: [d0] Power Management version 3
 	Kernel driver in use: i915
 	Kernel modules: i915

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 09)
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, fast devsel, latency 0
 	Memory at f8400000 (64-bit, non-prefetchable) [size=1M]
 	Capabilities: [d0] Power Management version 3

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03) (prog-if 00 [UHCI])
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, medium devsel, latency 0, IRQ 16
 	I/O ports at 1820 [size=32]
 	Capabilities: [50] PCI Advanced Features
 	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03) (prog-if 00 [UHCI])
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, medium devsel, latency 0, IRQ 21
 	I/O ports at 1840 [size=32]
 	Capabilities: [50] PCI Advanced Features
 	Kernel driver in use: uhci_hcd

00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03) (prog-if 00 [UHCI])
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, medium devsel, latency 0, IRQ 19
 	I/O ports at 1860 [size=32]
 	Capabilities: [50] PCI Advanced Features
 	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03) (prog-if 20 [EHCI])
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, medium devsel, latency 0, IRQ 19
 	Memory at f8704000 (32-bit, non-prefetchable) [size=1K]
 	Capabilities: [50] Power Management version 2
 	Capabilities: [58] Debug port: BAR=1 offset=00a0
 	Capabilities: [98] PCI Advanced Features
 	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, fast devsel, latency 0, IRQ 43
 	Memory at f8700000 (64-bit, non-prefetchable) [size=16K]
 	Capabilities: [50] Power Management version 2
 	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
 	Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
 	Capabilities: [100] Virtual Channel
 	Capabilities: [130] Root Complex Link
 	Kernel driver in use: snd_hda_intel
 	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03) (prog-if 00 [Normal decode])
 	Flags: bus master, fast devsel, latency 0
 	Bus: primary=00, secondary=02, subordinate=03, sec-latency=0
 	I/O behind bridge: 00002000-00002fff
 	Memory behind bridge: f4000000-f5ffffff
 	Prefetchable memory behind bridge: 00000000f0000000-00000000f1ffffff
 	Capabilities: [40] Express Root Port (Slot+), MSI 00
 	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
 	Capabilities: [90] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
 	Capabilities: [a0] Power Management version 2
 	Capabilities: [100] Virtual Channel
 	Capabilities: [180] Root Complex Link
 	Kernel driver in use: pcieport
 	Kernel modules: shpchp

00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 03) (prog-if 00 [Normal decode])
 	Flags: bus master, fast devsel, latency 0
 	Bus: primary=00, secondary=04, subordinate=05, sec-latency=0
 	I/O behind bridge: 00003000-00003fff
 	Memory behind bridge: f6000000-f7ffffff
 	Prefetchable memory behind bridge: 00000000f2000000-00000000f3ffffff
 	Capabilities: [40] Express Root Port (Slot+), MSI 00
 	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
 	Capabilities: [90] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
 	Capabilities: [a0] Power Management version 2
 	Capabilities: [100] Virtual Channel
 	Capabilities: [180] Root Complex Link
 	Kernel driver in use: pcieport
 	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, medium devsel, latency 0, IRQ 23
 	I/O ports at 1880 [size=32]
 	Capabilities: [50] PCI Advanced Features
 	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, medium devsel, latency 0, IRQ 19
 	I/O ports at 18a0 [size=32]
 	Capabilities: [50] PCI Advanced Features
 	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03) (prog-if 00 [UHCI])
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, medium devsel, latency 0, IRQ 18
 	I/O ports at 18c0 [size=32]
 	Capabilities: [50] PCI Advanced Features
 	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, medium devsel, latency 0, IRQ 23
 	Memory at f8704400 (32-bit, non-prefetchable) [size=1K]
 	Capabilities: [50] Power Management version 2
 	Capabilities: [58] Debug port: BAR=1 offset=00a0
 	Capabilities: [98] PCI Advanced Features
 	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93) (prog-if 01 [Subtractive decode])
 	Flags: bus master, fast devsel, latency 0
 	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
 	Capabilities: [50] Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009

00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller (rev 03)
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, medium devsel, latency 0
 	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
 	Kernel modules: iTCO_wdt

00:1f.2 IDE interface: Intel Corporation ICH9M/M-E 2 port SATA IDE Controller (rev 03) (prog-if 8f [Master SecP SecO PriP PriO])
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
 	I/O ports at 18f8 [size=8]
 	I/O ports at 180c [size=4]
 	I/O ports at 18f0 [size=8]
 	I/O ports at 1808 [size=4]
 	I/O ports at 18e0 [size=16]
 	I/O ports at 1810 [size=16]
 	Capabilities: [70] Power Management version 3
 	Capabilities: [b0] PCI Advanced Features
 	Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: medium devsel, IRQ 19
 	Memory at c0000000 (64-bit, non-prefetchable) [size=256]
 	I/O ports at 1c00 [size=32]
 	Kernel driver in use: i801_smbus
 	Kernel modules: i2c-i801

00:1f.5 IDE interface: Intel Corporation ICH9M/M-E 2 port SATA IDE Controller (rev 03) (prog-if 85 [Master SecO PriO])
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
 	I/O ports at 1c50 [size=8]
 	I/O ports at 1c44 [size=4]
 	I/O ports at 1c48 [size=8]
 	I/O ports at 1c40 [size=4]
 	I/O ports at 1c30 [size=16]
 	I/O ports at 1c20 [size=16]
 	Capabilities: [70] Power Management version 3
 	Capabilities: [b0] PCI Advanced Features
 	Kernel driver in use: ata_piix

04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
 	Subsystem: FIRST INTERNATIONAL Computer Inc Device 3009
 	Flags: bus master, fast devsel, latency 0, IRQ 42
 	I/O ports at 3000 [size=256]
 	Memory at f6000000 (64-bit, non-prefetchable) [size=4K]
 	Memory at f2000000 (64-bit, prefetchable) [size=64K]
 	[virtual] Expansion ROM at f2020000 [disabled] [size=128K]
 	Capabilities: [40] Power Management version 3
 	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
 	Capabilities: [70] Express Endpoint, MSI 01
 	Capabilities: [b0] MSI-X: Enable- Count=2 Masked-
 	Capabilities: [d0] Vital Product Data
 	Capabilities: [100] Advanced Error Reporting
 	Capabilities: [140] Virtual Channel
 	Capabilities: [160] Device Serial Number 71-00-00-00-68-4c-e0-00
 	Kernel driver in use: r8169
 	Kernel modules: r8169


* Uma vida sem desafios é uma vida sem razão *
* A life without challanges is a non reason life *
--8323328-1037641694-1321370092=:2693--
