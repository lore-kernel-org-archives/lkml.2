Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab2ADJu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 04:50:58 -0500
Received: from smtp24.services.sfr.fr ([93.17.128.84]:56097 "EHLO
	smtp24.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab2ADJuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 04:50:55 -0500
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jan 2012 04:50:54 EST
X-SFR-UUID: 20120104094132388.5EE1E700019C@msfrf2401.sfr.fr
Message-ID: <1325670091.2354.6.camel@milan>
Subject: hp-wmi: disabling Bluetooth also kills WiFi
From: Milan Bouchet-Valat <nalimilan@club.fr>
To: linux-kernel@vger.kernel.org
Date: Wed, 04 Jan 2012 10:41:31 +0100
Content-Type: multipart/mixed; boundary="=-enhxGr0oUUOtJue130o3"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
X-sfr-mailing: LEGIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-enhxGr0oUUOtJue130o3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi!

(I asked before on linux-bluetooth, but I was said hp-wmi developers
didn't hang there... Hope this is the right place.)

With kernels 3.1 and 3.2rc7, disabling Bluetooth via rfkill also disables
my wireless card on my HP Pavilion dm4. This didn't happen with 2.6.41
(I upgraded from Fedora 15 to 16).

My devices are set up as this (see attached output of lspci -vnn for
details about devices):
# rfkill list
0: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no
2: hp-wifi: Wireless LAN
	Soft blocked: no
	Hard blocked: no
3: hp-bluetooth: Bluetooth
	Soft blocked: no
	Hard blocked: no
11: hci0: Bluetooth
	Soft blocked: no
	Hard blocked: no

The problem is, these commands also stop the WiFi:
rfkill block bluetooth
and
rfkill block 3 [for hp-bluetooth]

But this one only kills the Bluetooth:
rfkill block 11


Running
rfkill block wifi
does kill the WiFi, but leaves the Bluetooth up.


(If it matters, running 'rfkill block bluetooth' makes hci0 disappear,
and after unblocking bluetooth, it reappears with the ID increased by 1.
This doesn't happen with the WiFi.)


Please ask if I can provide more information/testing.


Thanks for your help.


PS : Please keep me in CC: as I'm not subscribed to the list.

--=-enhxGr0oUUOtJue130o3
Content-Disposition: attachment; filename="lspci.log"
Content-Type: text/x-log; name="lspci.log"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

00:00.0 Host bridge [0600]: Intel Corporation Core Processor DRAM Controller [8086:0044] (rev 02)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller [0300]: Intel Corporation Core Processor Integrated Graphics Controller [8086:0046] (rev 02) (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0, IRQ 41
	Memory at b0000000 (64-bit, non-prefetchable) [size=4M]
	Memory at a0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at 3050 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: i915
	Kernel modules: i915

00:16.0 Communication controller [0780]: Intel Corporation 5 Series/3400 Series Chipset HECI Controller [8086:3b64] (rev 06)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0, IRQ 5
	Memory at b4406100 (64-bit, non-prefetchable) [size=16]
	Capabilities: <access denied>

00:1a.0 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b3c] (rev 05) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, medium devsel, latency 0, IRQ 16
	Memory at b4405c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device [0403]: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio [8086:3b56] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0, IRQ 43
	Memory at b4400000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 [8086:3b42] (rev 05) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: b3400000-b43fffff
	Prefetchable memory behind bridge: 00000000b0400000-00000000b13fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.1 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 [8086:3b44] (rev 05) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: b2400000-b33fffff
	Prefetchable memory behind bridge: 00000000b1400000-00000000b23fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1d.0 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b34] (rev 05) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, medium devsel, latency 0, IRQ 20
	Memory at b4405800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev a5) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
	Capabilities: <access denied>

00:1f.0 ISA bridge [0601]: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller [8086:3b09] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, medium devsel, latency 0
	Capabilities: <access denied>
	Kernel modules: iTCO_wdt

00:1f.2 SATA controller [0106]: Intel Corporation 5 Series/3400 Series Chipset 4 port SATA AHCI Controller [8086:3b29] (rev 05) (prog-if 01 [AHCI 1.0])
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 40
	I/O ports at 3048 [size=8]
	I/O ports at 305c [size=4]
	I/O ports at 3040 [size=8]
	I/O ports at 3058 [size=4]
	I/O ports at 3020 [size=32]
	Memory at b4405000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: ahci

00:1f.3 SMBus [0c05]: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller [8086:3b30] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: medium devsel, IRQ 19
	Memory at b4406000 (64-bit, non-prefetchable) [size=256]
	I/O ports at 3000 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801

00:1f.6 Signal processing controller [1180]: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem [8086:3b32] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0, IRQ 21
	Memory at b4404000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: intel ips
	Kernel modules: intel_ips

01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 03)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0, IRQ 42
	I/O ports at 2000 [size=256]
	Memory at b0404000 (64-bit, prefetchable) [size=4K]
	Memory at b0400000 (64-bit, prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: r8169
	Kernel modules: r8169

02:00.0 Network controller [0280]: Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller [14e4:4727] (rev 01)
	Subsystem: Hewlett-Packard Company Device [103c:1483]
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at b2400000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: brcmsmac
	Kernel modules: brcmsmac

ff:00.0 Host bridge [0600]: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers [8086:2c62] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0

ff:00.1 Host bridge [0600]: Intel Corporation Core Processor QuickPath Architecture System Address Decoder [8086:2d01] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0

ff:02.0 Host bridge [0600]: Intel Corporation Core Processor QPI Link 0 [8086:2d10] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0

ff:02.1 Host bridge [0600]: Intel Corporation Core Processor QPI Physical 0 [8086:2d11] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0

ff:02.2 Host bridge [0600]: Intel Corporation Core Processor Reserved [8086:2d12] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0

ff:02.3 Host bridge [0600]: Intel Corporation Core Processor Reserved [8086:2d13] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0


--=-enhxGr0oUUOtJue130o3--
