Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075Ab0GBR4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 13:56:50 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:38052 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab0GBR4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 13:56:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=uVfXNtppJ34Z1mgOuVgH9CiVIA8ogcbeMUqh04OTtl+W+5F3AXT2fgdXCTmosbwrgJ
         QDQJyxcJbhm7FlUfJol+2+CimkD82y8eXmKha/FsQSrhn4cnLBDhHL8vSAE0OpmbSKfy
         HkBdgEEkzMAYX0o+2Ja7iLMharMfvLv+FMuJY=
MIME-Version: 1.0
Date: Fri, 2 Jul 2010 10:56:45 -0700
Message-ID: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
Subject: Drives missing at boot
From: Mark Knecht <markknecht@gmail.com>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd30a9271caac048a6b4fe8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd30a9271caac048a6b4fe8
Content-Type: text/plain; charset=UTF-8

Hi,
   I have a newish machine - maybe 3 months old - which unreliably
finds its disk drives at each boot. Probably 40% of the time booting 1
or more drives will be missing.

   So far I've been unable to determine what might be wrong. Sometimes
it finds all 5 drives, sometimes only 4 or 3 drives. It's not always
the same drives that are missing. Shown below are two successive warm
boots. The machien had been running with all 5 drives working. The
first time through it missed both /dev/sdd and /dev/sde while the very
next time it found all 5 drives. Each of the 5 drives has been missing
one or more times at different boots. (I.e. - it's not always drive
sdd for instance.)

   Every time I boot the AMI BIOS screen says all 5 drives are there.
I have found that if I drop into BIOS before going to grub that
selecting each drive one at a time and reading through it's setup
seems to make the boot more reliable, but not 100%. Probably 80%
reliable.

   I don't know what info is required to look at this. I'm running the
newest Gentoo kernel but it's been happening with all kernels I've
tried since I built the machine. I'm attaching the kernel config as
well as dmesg from the last boot which had all the drives. The only
difference in dmesg when the drives don't show up (that I've spotted)
is that the missing drive just isn't in dmesg. (I.e. no error messages
that I could spot.)

   Let me know what I might try or what other info you might want. The
motherboard is an Asus Rampage II Extreme with an i7-980x 6 core/12
thread processor. sda, sdb & sdc are part of a RAID1, sdd & sde are
part of a RAID0.

Thanks,
Mark

mark@c2stable ~ $ uname -a
Linux c2stable 2.6.34-gentoo-r1 #1 SMP PREEMPT Fri Jul 2 10:04:52 PDT
2010 x86_64 Intel(R) Core(TM) i7 CPU X 980 @ 3.33GHz GenuineIntel
GNU/Linux
mark@c2stable ~ $
mark@c2stable ~ $ ls -la /dev/sd*
brw-rw---- 1 root disk 8,  0 Jul  2  2010 /dev/sda
brw-rw---- 1 root disk 8,  1 Jul  2  2010 /dev/sda1
brw-rw---- 1 root disk 8,  2 Jul  2  2010 /dev/sda2
brw-rw---- 1 root disk 8,  3 Jul  2  2010 /dev/sda3
brw-rw---- 1 root disk 8,  4 Jul  2  2010 /dev/sda4
brw-rw---- 1 root disk 8,  5 Jul  2  2010 /dev/sda5
brw-rw---- 1 root disk 8,  6 Jul  2  2010 /dev/sda6
brw-rw---- 1 root disk 8, 16 Jul  2  2010 /dev/sdb
brw-rw---- 1 root disk 8, 17 Jul  2  2010 /dev/sdb1
brw-rw---- 1 root disk 8, 18 Jul  2  2010 /dev/sdb2
brw-rw---- 1 root disk 8, 19 Jul  2  2010 /dev/sdb3
brw-rw---- 1 root disk 8, 20 Jul  2  2010 /dev/sdb4
brw-rw---- 1 root disk 8, 21 Jul  2  2010 /dev/sdb5
brw-rw---- 1 root disk 8, 22 Jul  2  2010 /dev/sdb6
brw-rw---- 1 root disk 8, 32 Jul  2  2010 /dev/sdc
brw-rw---- 1 root disk 8, 33 Jul  2  2010 /dev/sdc1
brw-rw---- 1 root disk 8, 34 Jul  2  2010 /dev/sdc2
brw-rw---- 1 root disk 8, 35 Jul  2  2010 /dev/sdc3
brw-rw---- 1 root disk 8, 36 Jul  2  2010 /dev/sdc4
brw-rw---- 1 root disk 8, 37 Jul  2  2010 /dev/sdc5
brw-rw---- 1 root disk 8, 38 Jul  2  2010 /dev/sdc6
mark@c2stable ~ $

[AFTER A REBOOT]

mark@c2stable ~ $ ls -la /dev/sd*
brw-rw---- 1 root disk 8,  0 Jul  2  2010 /dev/sda
brw-rw---- 1 root disk 8,  1 Jul  2  2010 /dev/sda1
brw-rw---- 1 root disk 8,  2 Jul  2  2010 /dev/sda2
brw-rw---- 1 root disk 8,  3 Jul  2  2010 /dev/sda3
brw-rw---- 1 root disk 8,  4 Jul  2  2010 /dev/sda4
brw-rw---- 1 root disk 8,  5 Jul  2  2010 /dev/sda5
brw-rw---- 1 root disk 8,  6 Jul  2  2010 /dev/sda6
brw-rw---- 1 root disk 8, 16 Jul  2  2010 /dev/sdb
brw-rw---- 1 root disk 8, 17 Jul  2  2010 /dev/sdb1
brw-rw---- 1 root disk 8, 18 Jul  2  2010 /dev/sdb2
brw-rw---- 1 root disk 8, 19 Jul  2  2010 /dev/sdb3
brw-rw---- 1 root disk 8, 20 Jul  2  2010 /dev/sdb4
brw-rw---- 1 root disk 8, 21 Jul  2  2010 /dev/sdb5
brw-rw---- 1 root disk 8, 22 Jul  2  2010 /dev/sdb6
brw-rw---- 1 root disk 8, 32 Jul  2  2010 /dev/sdc
brw-rw---- 1 root disk 8, 33 Jul  2  2010 /dev/sdc1
brw-rw---- 1 root disk 8, 34 Jul  2  2010 /dev/sdc2
brw-rw---- 1 root disk 8, 35 Jul  2  2010 /dev/sdc3
brw-rw---- 1 root disk 8, 36 Jul  2  2010 /dev/sdc4
brw-rw---- 1 root disk 8, 37 Jul  2  2010 /dev/sdc5
brw-rw---- 1 root disk 8, 38 Jul  2  2010 /dev/sdc6
brw-rw---- 1 root disk 8, 48 Jul  2  2010 /dev/sdd
brw-rw---- 1 root disk 8, 49 Jul  2  2010 /dev/sdd1
brw-rw---- 1 root disk 8, 64 Jul  2  2010 /dev/sde
brw-rw---- 1 root disk 8, 65 Jul  2  2010 /dev/sde1
mark@c2stable ~ $
c2stable ~ # lspci -v
00:00.0 Host bridge: Intel Corporation X58 I/O Hub to ESI Port (rev 13)
        Subsystem: ASUSTeK Computer Inc. Device 836b
        Flags: fast devsel
        Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
        Capabilities: [90] Express Root Port (Slot-), MSI 00
        Capabilities: [e0] Power Management version 3
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [150] Access Control Services
        Capabilities: [160] Vendor Specific Information <?>

00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 1 (rev 13) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device
836b
        Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
        Capabilities: [90] Express Root Port (Slot+), MSI 00
        Capabilities: [e0] Power Management version 3
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [150] Access Control Services
        Capabilities: [160] Vendor Specific Information <?>
        Kernel driver in use: pcieport

00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 3 (rev 13) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 836b
        Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
        Capabilities: [90] Express Root Port (Slot+), MSI 00
        Capabilities: [e0] Power Management version 3
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [150] Access Control Services
        Capabilities: [160] Vendor Specific Information <?>
        Kernel driver in use: pcieport

00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 7 (rev 13) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 0000a000-0000afff
        Memory behind bridge: fba00000-fbafffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
        Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 836b
        Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
        Capabilities: [90] Express Root Port (Slot+), MSI 00
        Capabilities: [e0] Power Management version 3
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [150] Access Control Services
        Capabilities: [160] Vendor Specific Information <?>
        Kernel driver in use: pcieport

00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management
Registers (rev 13) (prog-if 00 [8259])
        Flags: fast devsel
        Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch
Pad Registers (rev 13) (prog-if 00 [8259])
        Flags: fast devsel
        Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status
and RAS Registers (rev 13) (prog-if 00 [8259])
        Flags: fast devsel
        Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle
Registers (rev 13) (prog-if 00 [8259])
        Flags: fast devsel

00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #4 (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4
        Flags: bus master, medium devsel, latency 0, IRQ 16
        I/O ports at 9800 [size=32]
        Capabilities: [50] PCI Advanced Features
        Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #5 (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4
        Flags: bus master, medium devsel, latency 0, IRQ 21
        I/O ports at 9880 [size=32]
        Capabilities: [50] PCI Advanced Features
        Kernel driver in use: uhci_hcd

00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #6 (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4
        Flags: bus master, medium devsel, latency 0, IRQ 19
        I/O ports at 9c00 [size=32]
        Capabilities: [50] PCI Advanced Features
        Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #2 (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4
        Flags: bus master, medium devsel, latency 0, IRQ 18
        Memory at fb9ff000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCI Advanced Features
        Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD
Audio Controller
        Subsystem: ASUSTeK Computer Inc. Device 82ea
        Flags: bus master, fast devsel, latency 0, IRQ 57
        Memory at fb9f8000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
        Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [130] Root Complex Link <?>
        Kernel driver in use: HDA Intel
        Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
Express Port 1 (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
        I/O behind bridge: 00001000-00001fff
        Memory behind bridge: c0000000-c03fffff
        Prefetchable memory behind bridge: 00000000faf00000-00000000faffffff
        Capabilities: [40] Express Root Port (Slot+), MSI 00
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 82ea
        Capabilities: [a0] Power Management version 2
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
Express Port 3 (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fbd00000-fbdfffff
        Prefetchable memory behind bridge: 00000000c0400000-00000000c05fffff
        Capabilities: [40] Express Root Port (Slot+), MSI 00
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 82ea
        Capabilities: [a0] Power Management version 2
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
Express Port 5 (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: fbc00000-fbcfffff
        Prefetchable memory behind bridge: 00000000c0600000-00000000c07fffff
        Capabilities: [40] Express Root Port (Slot+), MSI 00
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 82ea
        Capabilities: [a0] Power Management version 2
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport

00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
Express Port 6 (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: fbb00000-fbbfffff
        Prefetchable memory behind bridge: 00000000c0800000-00000000c09fffff
        Capabilities: [40] Express Root Port (Slot+), MSI 00
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 82ea
        Capabilities: [a0] Power Management version 2
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #1 (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4
        Flags: bus master, medium devsel, latency 0, IRQ 23
        I/O ports at 9080 [size=32]
        Capabilities: [50] PCI Advanced Features
        Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #2 (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4
        Flags: bus master, medium devsel, latency 0, IRQ 19
        I/O ports at 9400 [size=32]
        Capabilities: [50] PCI Advanced Features
        Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #3 (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4
        Flags: bus master, medium devsel, latency 0, IRQ 18
        I/O ports at 9480 [size=32]
        Capabilities: [50] PCI Advanced Features
        Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #1 (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Device 82d4
        Flags: bus master, medium devsel, latency 0, IRQ 23
        Memory at fb9fe000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCI Advanced Features
        Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
(prog-if 01 [Subtractive decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=08, subordinate=08, sec-latency=32
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: fbe00000-fbefffff
        Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Device 82d4

00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
        Subsystem: ASUSTeK Computer Inc. Device 82d4
        Flags: bus master, medium devsel, latency 0
        Capabilities: [e0] Vendor Specific Information <?>

00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port
SATA IDE Controller (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: ASUSTeK Computer Inc. Device 82d4
        Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 20
        I/O ports at 8000 [size=8]
        I/O ports at 7c00 [size=4]
        I/O ports at 7880 [size=8]
        I/O ports at 7800 [size=4]
        I/O ports at 7480 [size=16]
        I/O ports at 7400 [size=16]
        Capabilities: [70] Power Management version 3
        Capabilities: [b0] PCI Advanced Features
        Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
        Subsystem: ASUSTeK Computer Inc. Device 82d4
        Flags: medium devsel, IRQ 18
        Memory at fb9fd000 (64-bit, non-prefetchable) [size=256]
        I/O ports at 0400 [size=32]
        Kernel modules: i2c-i801

00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port
SATA IDE Controller (prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. Device 82d4
        Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 20
        I/O ports at 9000 [size=8]
        I/O ports at 8c00 [size=4]
        I/O ports at 8880 [size=8]
        I/O ports at 8800 [size=4]
        I/O ports at 8480 [size=16]
        I/O ports at 8400 [size=16]
        Capabilities: [70] Power Management version 3
        Capabilities: [b0] PCI Advanced Features
        Kernel driver in use: ata_piix

03:00.0 VGA compatible controller: ATI Technologies Inc Device 68b8
(prog-if 00 [VGA controller])
        Subsystem: XFX Pine Group Inc. Device 2991
        Flags: bus master, fast devsel, latency 0, IRQ 30
        Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Memory at fbac0000 (64-bit, non-prefetchable) [size=128K]
        I/O ports at a000 [size=256]
        Expansion ROM at fbaa0000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 3
        Capabilities: [58] Express Legacy Endpoint, MSI 00
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [100] Vendor Specific Information <?>
        Capabilities: [150] Advanced Error Reporting
        Kernel driver in use: radeon
        Kernel modules: radeon

03:00.1 Audio device: ATI Technologies Inc Device aa58
        Subsystem: XFX Pine Group Inc. Device aa58
        Flags: bus master, fast devsel, latency 0, IRQ 58
        Memory at fbafc000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 3
        Capabilities: [58] Express Legacy Endpoint, MSI 00
        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [100] Vendor Specific Information <?>
        Capabilities: [150] Advanced Error Reporting
        Kernel driver in use: HDA Intel
        Kernel modules: snd-hda-intel

04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056
PCI-E Gigabit Ethernet Controller (rev 12)
        Subsystem: ASUSTeK Computer Inc. Device 81f8
        Flags: bus master, fast devsel, latency 0, IRQ 56
        Memory at fbbfc000 (64-bit, non-prefetchable) [size=16K]
        I/O ports at b800 [size=256]
        Expansion ROM at fbbc0000 [disabled] [size=128K]
        Capabilities: [48] Power Management version 3
        Capabilities: [50] Vital Product Data
        Capabilities: [5c] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [e0] Express Legacy Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Kernel driver in use: sky2
        Kernel modules: sky2

05:00.0 SATA controller: JMicron Technology Corp. 20360/20363 Serial
ATA Controller (rev 03) (prog-if 01 [AHCI 1.0])
        Subsystem: ASUSTeK Computer Inc. Device 824f
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at fbcfe000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [68] Power Management version 2
        Capabilities: [50] Express Legacy Endpoint, MSI 01
        Kernel driver in use: ahci

05:00.1 IDE interface: JMicron Technology Corp. 20360/20363 Serial ATA
Controller (rev 03) (prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. Device 824f
        Flags: fast devsel
        I/O ports at cc00 [disabled] [size=8]
        I/O ports at c880 [disabled] [size=4]
        I/O ports at c800 [disabled] [size=8]
        I/O ports at c480 [disabled] [size=4]
        I/O ports at c400 [disabled] [size=16]
        Capabilities: [68] Power Management version 2

06:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056
PCI-E Gigabit Ethernet Controller (rev 12)
        Subsystem: ASUSTeK Computer Inc. Device 81f8
        Flags: bus master, fast devsel, latency 0, IRQ 55
        Memory at fbdfc000 (64-bit, non-prefetchable) [size=16K]
        I/O ports at d800 [size=256]
        Expansion ROM at fbdc0000 [disabled] [size=128K]
        Capabilities: [48] Power Management version 3
        Capabilities: [50] Vital Product Data
        Capabilities: [5c] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [e0] Express Legacy Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Kernel driver in use: sky2
        Kernel modules: sky2

08:02.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306 Fire II
IEEE 1394 OHCI Link Layer Controller (rev c0) (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. Device 81fe
        Flags: bus master, medium devsel, latency 64, IRQ 11
        Memory at fbeff000 (32-bit, non-prefetchable) [size=2K]
        I/O ports at ec00 [size=128]
        Capabilities: [50] Power Management version 2

c2stable ~ #



c2stable ~ # dmesg
Linux version 2.6.34-gentoo-r1 (root@c2stable) (gcc version 4.4.3
(Gentoo 4.4.3-r2 p1.2) ) #1 SMP PREEMPT Fri Jul 2 10:04:52 PDT 2010
Command line: root=/dev/md5
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf780000 (usable)
 BIOS-e820: 00000000bf780000 - 00000000bf798000 (ACPI data)
 BIOS-e820: 00000000bf798000 - 00000000bf7dc000 (ACPI NVS)
 BIOS-e820: 00000000bf7dc000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000340000000 (usable)
NX (Execute Disable) protection: active
DMI 2.5 present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x340000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-DFFFF write-protect
  E0000-E7FFF write-through
  E8000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask E00000000 write-back
  1 base 200000000 mask F00000000 write-back
  2 base 300000000 mask FC0000000 write-back
  3 base 0C0000000 mask FC0000000 uncachable
  4 base 0BF800000 mask FFF800000 uncachable
  5 disabled
  6 disabled
  7 disabled
  8 disabled
  9 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000bf800000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xbf780 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
found SMP MP-table at [ffff8800000ff780] ff780
Using GB pages for direct mapping
init_memory_mapping: 0000000000000000-00000000bf780000
 0000000000 - 0080000000 page 1G
 0080000000 - 00bf600000 page 2M
 00bf600000 - 00bf780000 page 4k
kernel direct mapping tables up to bf780000 @ 12000-15000
init_memory_mapping: 0000000100000000-0000000340000000
 0100000000 - 0340000000 page 1G
kernel direct mapping tables up to 340000000 @ 14000-15000
ACPI: RSDP 00000000000fb0c0 00014 (v00 ACPIAM)
ACPI: RSDT 00000000bf780000 00040 (v01 012810 RSDT1341 20100128 MSFT 00000097)
ACPI: FACP 00000000bf780200 00084 (v01 012810 FACP1341 20100128 MSFT 00000097)
ACPI: DSDT 00000000bf7804b0 0D2BA (v01  A1088 A1088000 00000000 INTL 20060113)
ACPI: FACS 00000000bf798000 00040
ACPI: APIC 00000000bf780390 000D8 (v01 012810 APIC1341 20100128 MSFT 00000097)
ACPI: MCFG 00000000bf780470 0003C (v01 012810 OEMMCFG  20100128 MSFT 00000097)
ACPI: OEMB 00000000bf798040 00072 (v01 012810 OEMB1341 20100128 MSFT 00000097)
ACPI: HPET 00000000bf78f4b0 00038 (v01 012810 OEMHPET  20100128 MSFT 00000097)
ACPI: OSFR 00000000bf78f4f0 000B0 (v01 012810 OEMOSFR  20100128 MSFT 00000097)
ACPI: SSDT 00000000bf79ba40 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea000b5fffff] PMD ->
[ffff880002000000-ffff88000c7fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00340000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000bf780
    0: 0x00100000 -> 0x00340000
On node 0 totalpages: 3143439
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3927 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 765880 pages, LIFO batch:31
  Normal zone: 32256 pages used for memmap
  Normal zone: 2327040 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x14] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x11] enabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x15] enabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 6, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x07] address[0xfec8a000] gsi_base[24])
IOAPIC[1]: apic_id 7, version 32, address 0xfec8a000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
16 Processors exceeds NR_CPUS limit of 12
SMP: Allowing 12 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 48
early_res array is doubled to 64 at [14000 - 147ff]
Allocating PCI resources starting at c0000000 (gap: c0000000:3ee00000)
setup_percpu: NR_CPUS:12 nr_cpumask_bits:12 nr_cpu_ids:12 nr_node_ids:1
PERCPU: Embedded 26 pages/cpu @ffff880001800000 s75176 r8192 d23128 u131072
pcpu-alloc: s75176 r8192 d23128 u131072 alloc=1*2097152
pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 -- -- -- --
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3096847
Kernel command line: root=/dev/md5
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
early_res array is doubled to 128 at [14800 - 157ff]
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Checking aperture...
No AGP bridge found
Subtract (60 early reservations)
  #1 [0001000000 - 0001771244]   TEXT DATA BSS
  #2 [0001772000 - 0001772298]             BRK
  #3 [00000ff790 - 0000100000]   BIOS reserved
  #4 [00000ff780 - 00000ff790]    MP-table mpf
  #5 [000009fc00 - 00000f1310]   BIOS reserved
  #6 [00000f14fc - 00000ff780]   BIOS reserved
  #7 [00000f1310 - 00000f14fc]    MP-table mpc
  #8 [0000010000 - 0000012000]      TRAMPOLINE
  #9 [0000012000 - 0000014000]         PGTABLE
  #10 [00017722c0 - 00017732c0]         BOOTMEM
  #11 [0001771280 - 0001771880]         BOOTMEM
  #12 [0001f74000 - 0001f75000]         BOOTMEM
  #13 [0001f75000 - 0001f76000]         BOOTMEM
  #14 [0002000000 - 000c800000]        MEMMAP 0
  #15 [0001771880 - 0001771a00]         BOOTMEM
  #16 [00017732c0 - 000178b2c0]         BOOTMEM
  #17 [000178b2c0 - 00017a32c0]         BOOTMEM
  #18 [00017a4000 - 00017a5000]         BOOTMEM
  #19 [0001771a00 - 0001771a41]         BOOTMEM
  #20 [0001771a80 - 0001771b06]         BOOTMEM
  #21 [0001771b40 - 0001771da8]         BOOTMEM
  #22 [0001771dc0 - 0001771e28]         BOOTMEM
  #23 [0001771e40 - 0001771ea8]         BOOTMEM
  #24 [0001771ec0 - 0001771f28]         BOOTMEM
  #25 [0001771f40 - 0001771fa8]         BOOTMEM
  #26 [00017a32c0 - 00017a3328]         BOOTMEM
  #27 [00017a3340 - 00017a33a8]         BOOTMEM
  #28 [00017a33c0 - 00017a3428]         BOOTMEM
  #29 [00017a3440 - 00017a34a8]         BOOTMEM
  #30 [00017a34c0 - 00017a3528]         BOOTMEM
  #31 [00017a3540 - 00017a35a8]         BOOTMEM
  #32 [0001771fc0 - 0001771fce]         BOOTMEM
  #33 [00017a35c0 - 00017a35ce]         BOOTMEM
  #34 [0001800000 - 000181a000]         BOOTMEM
  #35 [0001820000 - 000183a000]         BOOTMEM
  #36 [0001840000 - 000185a000]         BOOTMEM
  #37 [0001860000 - 000187a000]         BOOTMEM
  #38 [0001880000 - 000189a000]         BOOTMEM
  #39 [00018a0000 - 00018ba000]         BOOTMEM
  #40 [00018c0000 - 00018da000]         BOOTMEM
  #41 [00018e0000 - 00018fa000]         BOOTMEM
  #42 [0001900000 - 000191a000]         BOOTMEM
  #43 [0001920000 - 000193a000]         BOOTMEM
  #44 [0001940000 - 000195a000]         BOOTMEM
  #45 [0001960000 - 000197a000]         BOOTMEM
  #46 [00017a3600 - 00017a3608]         BOOTMEM
  #47 [00017a3640 - 00017a3648]         BOOTMEM
  #48 [00017a3680 - 00017a36b0]         BOOTMEM
  #49 [00017a36c0 - 00017a3720]         BOOTMEM
  #50 [00017a3740 - 00017a3850]         BOOTMEM
  #51 [00017a3880 - 00017a38c8]         BOOTMEM
  #52 [00017a3900 - 00017a3948]         BOOTMEM
  #53 [00017a5000 - 00017ad000]         BOOTMEM
  #54 [000c800000 - 000d800000]         BOOTMEM
  #55 [000d800000 - 000e000000]         BOOTMEM
  #56 [000e000000 - 0012000000]         BOOTMEM
  #57 [00017ad000 - 00017cd000]         BOOTMEM
  #58 [000197a000 - 00019ba000]         BOOTMEM
  #59 [0000015800 - 000001d800]         BOOTMEM
Memory: 12302060k/13631488k available (3665k kernel code, 1057732k
absent, 271696k reserved, 2924k data, 476k init)
Experimental preemptable hierarchical RCU implementation.
NR_IRQS:640
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 3337.884 MHz processor.
Calibrating delay loop (skipped), value calculated using timer
frequency.. 6675.76 BogoMIPS (lpj=3337884)
Security Framework initialized
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Performance Events: Westmere events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
Freeing SMP alternatives: 36k freed
ACPI: Core revision 20100121
Setting APIC routing to physical flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM) i7 CPU       X 980  @ 3.33GHz stepping 02
Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 #8 #9 #10 #11 Ok.
Brought up 12 CPUs
Total of 12 processors activated (81162.38 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: SSDT 00000000bf7980c0 03978 (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI
motherboard resources
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:1a.0: reg 20: [io  0x9800-0x981f]
pci 0000:00:1a.1: reg 20: [io  0x9880-0x989f]
pci 0000:00:1a.2: reg 20: [io  0x9c00-0x9c1f]
pci 0000:00:1a.7: reg 10: [mem 0xfb9ff000-0xfb9ff3ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10: [mem 0xfb9f8000-0xfb9fbfff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: reg 20: [io  0x9080-0x909f]
pci 0000:00:1d.1: reg 20: [io  0x9400-0x941f]
pci 0000:00:1d.2: reg 20: [io  0x9480-0x949f]
pci 0000:00:1d.7: reg 10: [mem 0xfb9fe000-0xfb9fe3ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
pci 0000:00:1f.2: reg 10: [io  0x8000-0x8007]
pci 0000:00:1f.2: reg 14: [io  0x7c00-0x7c03]
pci 0000:00:1f.2: reg 18: [io  0x7880-0x7887]
pci 0000:00:1f.2: reg 1c: [io  0x7800-0x7803]
pci 0000:00:1f.2: reg 20: [io  0x7480-0x748f]
pci 0000:00:1f.2: reg 24: [io  0x7400-0x740f]
pci 0000:00:1f.3: reg 10: [mem 0xfb9fd000-0xfb9fd0ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
pci 0000:00:1f.5: reg 10: [io  0x9000-0x9007]
pci 0000:00:1f.5: reg 14: [io  0x8c00-0x8c03]
pci 0000:00:1f.5: reg 18: [io  0x8880-0x8887]
pci 0000:00:1f.5: reg 1c: [io  0x8800-0x8803]
pci 0000:00:1f.5: reg 20: [io  0x8480-0x848f]
pci 0000:00:1f.5: reg 24: [io  0x8400-0x840f]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:03:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:03:00.0: reg 18: [mem 0xfbac0000-0xfbadffff 64bit]
pci 0000:03:00.0: reg 20: [io  0xa000-0xa0ff]
pci 0000:03:00.0: reg 30: [mem 0xfbaa0000-0xfbabffff pref]
pci 0000:03:00.0: supports D1 D2
pci 0000:03:00.1: reg 10: [mem 0xfbafc000-0xfbafffff 64bit]
pci 0000:03:00.1: supports D1 D2
pci 0000:00:07.0: PCI bridge to [bus 03-03]
pci 0000:00:07.0:   bridge window [io  0xa000-0xafff]
pci 0000:00:07.0:   bridge window [mem 0xfba00000-0xfbafffff]
pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 07-07]
pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfaf00000-0xfaffffff 64bit pref]
pci 0000:06:00.0: reg 10: [mem 0xfbdfc000-0xfbdfffff 64bit]
pci 0000:06:00.0: reg 18: [io  0xd800-0xd8ff]
pci 0000:06:00.0: reg 30: [mem 0xfbdc0000-0xfbddffff pref]
pci 0000:06:00.0: supports D1 D2
pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:06:00.0: PME# disabled
pci 0000:00:1c.2: PCI bridge to [bus 06-06]
pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1c.2:   bridge window [mem 0xfbd00000-0xfbdfffff]
pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:05:00.0: reg 24: [mem 0xfbcfe000-0xfbcfffff]
pci 0000:05:00.0: PME# supported from D3hot
pci 0000:05:00.0: PME# disabled
pci 0000:05:00.1: reg 10: [io  0xcc00-0xcc07]
pci 0000:05:00.1: reg 14: [io  0xc880-0xc883]
pci 0000:05:00.1: reg 18: [io  0xc800-0xc807]
pci 0000:05:00.1: reg 1c: [io  0xc480-0xc483]
pci 0000:05:00.1: reg 20: [io  0xc400-0xc40f]
pci 0000:00:1c.4: PCI bridge to [bus 05-05]
pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
pci 0000:00:1c.4:   bridge window [mem 0xfbc00000-0xfbcfffff]
pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:04:00.0: reg 10: [mem 0xfbbfc000-0xfbbfffff 64bit]
pci 0000:04:00.0: reg 18: [io  0xb800-0xb8ff]
pci 0000:04:00.0: reg 30: [mem 0xfbbc0000-0xfbbdffff pref]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:1c.5: PCI bridge to [bus 04-04]
pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
pci 0000:00:1c.5:   bridge window [mem 0xfbb00000-0xfbbfffff]
pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:08:02.0: reg 10: [mem 0xfbeff000-0xfbeff7ff]
pci 0000:08:02.0: reg 14: [io  0xec00-0xec7f]
pci 0000:08:02.0: supports D2
pci 0000:08:02.0: PME# supported from D2 D3hot D3cold
pci 0000:08:02.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 08-08] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:1e.0:   bridge window [mem 0xfbe00000-0xfbefffff]
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff]
(subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 6 7 10 11 12 14 15)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009fc00 - 000000000009ffff
reserve RAM buffer: 00000000bf780000 - 00000000bfffffff
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 17 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
system 00:01: [mem 0xfec8a000-0xfec8afff] could not be reserved
system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
system 00:07: [io  0x0290-0x029f] has been reserved
system 00:08: [io  0x04d0-0x04d1] has been reserved
system 00:08: [io  0x0800-0x087f] has been reserved
system 00:08: [io  0x0500-0x057f] could not be reserved
system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:08: [mem 0xfed40000-0xfed8ffff] has been reserved
system 00:0b: [mem 0xffc00000-0xffdfffff] has been reserved
system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0f: [mem 0xe0000000-0xefffffff] has been reserved
system 00:10: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:10: [mem 0x000c0000-0x000cffff] has been reserved
system 00:10: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:10: [mem 0x00100000-0xbfffffff] could not be reserved
system 00:10: [mem 0xfed90000-0xffffffff] could not be reserved
pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc03fffff]
pci 0000:00:1c.2: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
pci 0000:00:1c.4: BAR 9: assigned [mem 0xc0600000-0xc07fffff 64bit pref]
pci 0000:00:1c.5: BAR 9: assigned [mem 0xc0800000-0xc09fffff 64bit pref]
pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem disabled]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  disabled]
pci 0000:00:03.0:   bridge window [mem disabled]
pci 0000:00:03.0:   bridge window [mem pref disabled]
pci 0000:00:07.0: PCI bridge to [bus 03-03]
pci 0000:00:07.0:   bridge window [io  0xa000-0xafff]
pci 0000:00:07.0:   bridge window [mem 0xfba00000-0xfbafffff]
pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 07-07]
pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc03fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfaf00000-0xfaffffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 06-06]
pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1c.2:   bridge window [mem 0xfbd00000-0xfbdfffff]
pci 0000:00:1c.2:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 05-05]
pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
pci 0000:00:1c.4:   bridge window [mem 0xfbc00000-0xfbcfffff]
pci 0000:00:1c.4:   bridge window [mem 0xc0600000-0xc07fffff 64bit pref]
pci 0000:00:1c.5: PCI bridge to [bus 04-04]
pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
pci 0000:00:1c.5:   bridge window [mem 0xfbb00000-0xfbbfffff]
pci 0000:00:1c.5:   bridge window [mem 0xc0800000-0xc09fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 08-08]
pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:1e.0:   bridge window [mem 0xfbe00000-0xfbefffff]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:07.0: setting latency timer to 64
pci 0000:00:1c.0: enabling device (0106 -> 0107)
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:00: resource 8 [mem 0xc0000000-0xdfffffff]
pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
pci_bus 0000:03: resource 0 [io  0xa000-0xafff]
pci_bus 0000:03: resource 1 [mem 0xfba00000-0xfbafffff]
pci_bus 0000:03: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
pci_bus 0000:07: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:07: resource 1 [mem 0xc0000000-0xc03fffff]
pci_bus 0000:07: resource 2 [mem 0xfaf00000-0xfaffffff 64bit pref]
pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:06: resource 1 [mem 0xfbd00000-0xfbdfffff]
pci_bus 0000:06: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:05: resource 1 [mem 0xfbc00000-0xfbcfffff]
pci_bus 0000:05: resource 2 [mem 0xc0600000-0xc07fffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
pci_bus 0000:04: resource 1 [mem 0xfbb00000-0xfbbfffff]
pci_bus 0000:04: resource 2 [mem 0xc0800000-0xc09fffff 64bit pref]
pci_bus 0000:08: resource 0 [io  0xe000-0xefff]
pci_bus 0000:08: resource 1 [mem 0xfbe00000-0xfbefffff]
pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:08: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:08: resource 8 [mem 0xc0000000-0xdfffffff]
pci_bus 0000:08: resource 9 [mem 0xf0000000-0xfed8ffff]
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 8192 (order: 6, 262144 bytes)
UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:03:00.0: Boot video device
PCI: CLS 256 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff88000e000000 - ffff880012000000
software IO TLB at phys 0xe000000 - 0x12000000
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
NTFS driver 2.1.29 [Flags: R/W].
fuse init (API version 7.13)
msgmni has been set to 24027
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: setting latency timer to 64
pcieport 0000:00:01.0: irq 48 for MSI/MSI-X
pcieport 0000:00:03.0: setting latency timer to 64
pcieport 0000:00:03.0: irq 49 for MSI/MSI-X
pcieport 0000:00:07.0: setting latency timer to 64
pcieport 0000:00:07.0: irq 50 for MSI/MSI-X
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 51 for MSI/MSI-X
pcieport 0000:00:1c.2: setting latency timer to 64
pcieport 0000:00:1c.2: irq 52 for MSI/MSI-X
pcieport 0000:00:1c.4: setting latency timer to 64
pcieport 0000:00:1c.4: irq 53 for MSI/MSI-X
pcieport 0000:00:1c.5: setting latency timer to 64
pcieport 0000:00:1c.5: irq 54 for MSI/MSI-X
aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
Non-volatile memory driver v1.3
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
ahci 0000:05:00.0: version 3.0
ahci 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ahci 0000:05:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:05:00.0: flags: 64bit ncq pm led clo pmp pio slum part
ahci 0000:05:00.0: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
ata1: SATA max UDMA/133 abar m8192@0xfbcfe000 port 0xfbcfe100 irq 16
ata2: SATA max UDMA/133 abar m8192@0xfbcfe000 port 0xfbcfe180 irq 16
ata_piix 0000:00:1f.2: version 2.13
ata_piix 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) -> IRQ 20
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x8000 ctl 0x7c00 bmdma 0x7480 irq 20
ata4: SATA max UDMA/133 cmd 0x7880 ctl 0x7800 bmdma 0x7488 irq 20
ata_piix 0000:00:1f.5: PCI INT B -> GSI 20 (level, low) -> IRQ 20
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
ata_piix 0000:00:1f.5: setting latency timer to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: SATA max UDMA/133 cmd 0x9000 ctl 0x8c00 bmdma 0x8480 irq 20
ata6: SATA max UDMA/133 cmd 0x8880 ctl 0x8800 bmdma 0x8488 irq 20
console [netcon0] enabled
netconsole: network logging started
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 256 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfb9ff000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.34-gentoo-r1 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfb9fe000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.34-gentoo-r1 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00009800
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.34-gentoo-r1 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00009880
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.34-gentoo-r1 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 19, io base 0x00009c00
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.34-gentoo-r1 uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009080
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.34-gentoo-r1 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009400
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.34-gentoo-r1 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00009480
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.34-gentoo-r1 uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
NET: Registered protocol family 17
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input2
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
ata6: link resume succeeded after 1 retries
ata5: link resume succeeded after 1 retries
usb 3-2: new full speed USB device using uhci_hcd and address 2
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-8: WDC WD5002ABYS-02B1B0, 02.03B03, max UDMA/133
ata5.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata6.00: ATA-8: WDC WD5002ABYS-02B1B0, 02.03B03, max UDMA/133
ata6.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata6.00: configured for UDMA/133
ata5.00: configured for UDMA/133
usb 3-2: New USB device found, idVendor=051d, idProduct=0002
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 3-2: Product: Back-UPS BX1000G FW:869.L1 .D USB FW:L1
usb 3-2: Manufacturer: American Power Conversion
usb 3-2: SerialNumber: 3B1007X44377
generic-usb 0003:051D:0002.0001: hiddev96,hidraw0: USB HID v1.00
Device [American Power Conversion Back-UPS BX1000G FW:869.L1 .D USB
FW:L1  ] on usb-0000:00:1a.0-2/input0
ata3.00: SATA link down (SStatus 0 SControl 301)
ata3.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.01: ATA-8: WDC WD5002ABYS-02B1B0, 02.03B03, max UDMA/133
ata3.01: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.01: configured for UDMA/133
scsi 2:0:1:0: Direct-Access     ATA      WDC WD5002ABYS-0 02.0 PQ: 0 ANSI: 5
sd 2:0:1:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 2:0:1:0: Attached scsi generic sg0 type 0
sd 2:0:1:0: [sda] Write Protect is off
sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3 sda4 <
ata4.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-8: WDC WD5002ABYS-02B1B0, 02.03B03, max UDMA/133
ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.01: ATA-8: WDC WD5002ABYS-02B1B0, 02.03B03, max UDMA/133
ata4.01: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
 sda5
ata4.00: configured for UDMA/133
ata4.01: configured for UDMA/133
scsi 3:0:0:0: Direct-Access     ATA      WDC WD5002ABYS-0 02.0 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 3:0:0:0: Attached scsi generic sg1 type 0
scsi 3:0:1:0: Direct-Access     ATA      WDC WD5002ABYS-0 02.0 PQ: 0 ANSI: 5
sd 3:0:1:0: [sdc] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 3:0:1:0: [sdc] Write Protect is off
sd 3:0:1:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:1:0: Attached scsi generic sg2 type 0
sd 3:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
scsi 4:0:0:0: Direct-Access     ATA      WDC WD5002ABYS-0 02.0 PQ: 0 ANSI: 5
 sdc:
sd 4:0:0:0: [sdd] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 4:0:0:0: Attached scsi generic sg3 type 0
 sdd:
scsi 5:0:0:0: Direct-Access     ATA      WDC WD5002ABYS-0 02.0 PQ: 0 ANSI: 5
sd 5:0:0:0: [sde] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 5:0:0:0: Attached scsi generic sg4 type 0
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sde: sda6 >
 sde1
sd 5:0:0:0: [sde] Attached SCSI disk
 sdc1
sd 3:0:0:0: [sdb] Write Protect is off
 sdc2 sdc3 sdc4 < sdd1
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdd] Attached SCSI disk
sd 2:0:1:0: [sda] Attached SCSI disk
 sdc5
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdc6 >
 sdb:
sd 3:0:1:0: [sdc] Attached SCSI disk
 sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 >
sd 3:0:0:0: [sdb] Attached SCSI disk
usb 8-2: new low speed USB device using uhci_hcd and address 2
usb 8-2: New USB device found, idVendor=045e, idProduct=0039
usb 8-2: New USB device strings: Mfr=1, Product=3, SerialNumber=0
usb 8-2: Product: Microsoft 5-Button Mouse with IntelliEye(TM)
usb 8-2: Manufacturer: Microsoft
input: Microsoft Microsoft 5-Button Mouse with IntelliEye(TM) as
/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input3
generic-usb 0003:045E:0039.0002: input,hidraw1: USB HID v1.10 Mouse
[Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)] on
usb-0000:00:1d.2-2/input0
input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input4
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 6 and added 6 devices.
md: autorun ...
md: considering sdb5 ...
md:  adding sdb5 ...
md: sdb3 has different UUID to sdb5
md:  adding sdc5 ...
md: sdc3 has different UUID to sdb5
md:  adding sda5 ...
md: sda3 has different UUID to sdb5
md: created md5
md: bind<sda5>
md: bind<sdc5>
md: bind<sdb5>
md: running: <sdb5><sdc5><sda5>
raid1: raid set md5 active with 3 out of 3 mirrors
md5: detected capacity change from 0 to 53694496768
md: considering sdb3 ...
md:  adding sdb3 ...
md:  adding sdc3 ...
md:  adding sda3 ...
md: created md3
md: bind<sda3>
md: bind<sdc3>
md: bind<sdb3>
md: running: <sdb3><sdc3><sda3>
raid1: raid set md3 active with 3 out of 3 mirrors
md3: detected capacity change from 0 to 53694562304
md: ... autorun DONE.
 md5: unknown partition table
kjournald starting.  Commit interval 5 seconds
EXT3-fs (md5): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 9:5.
Freeing unused kernel memory: 476k freed
Write protecting the kernel read-only data: 6144k
Freeing unused kernel memory: 412k freed
Freeing unused kernel memory: 224k freed
udev: starting version 149
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ACPI: resource 0000:00:1f.3 [io  0x0400-0x041f] conflicts with ACPI
region SMRG [mem 0x00000400-0x0000040f pref disabled]
ACPI: If an ACPI driver is available for this device, you should use
it instead of the native driver
 md3: unknown partition table
sky2: driver version 1.27
sky2 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
sky2 0000:06:00.0: setting latency timer to 64
sky2 0000:06:00.0: Yukon-2 EC Ultra chip revision 3
sky2 0000:06:00.0: irq 55 for MSI/MSI-X
sky2 0000:06:00.0: eth0: addr e0:cb:4e:97:7a:09
sky2 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
sky2 0000:04:00.0: setting latency timer to 64
sky2 0000:04:00.0: Yukon-2 EC Ultra chip revision 3
sky2 0000:04:00.0: irq 56 for MSI/MSI-X
sky2 0000:04:00.0: eth1: addr e0:cb:4e:97:80:fd
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: irq 57 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
radeon 0000:03:00.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
radeon 0000:03:00.0: setting latency timer to 64
[drm] initializing kernel modesetting (JUNIPER 0x1002:0x68B8).
[drm] register mmio base: 0xFBAC0000
[drm] register mmio size: 131072
ATOM BIOS: JUNIPER
[drm] Clocks initialized !
[drm] 1 Power State(s)
[drm] State 0 Default (default)
[drm]   16 PCIE Lanes
[drm]   1 Clock Mode(s)
[drm]           0 engine/memory: 850000/1200000
[drm] radeon: power management initialized
radeon 0000:03:00.0: VRAM: 256M 0x00000000 - 0x0FFFFFFF (256M used)
radeon 0000:03:00.0: GTT: 512M 0x10000000 - 0x2FFFFFFF
mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[drm] Detected VRAM RAM=256M, BAR=256M
[drm] RAM width 128bits DDR
[TTM] Zone  kernel: Available graphics memory: 6151604 kiB.
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[drm] radeon: 256M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   DisplayPort
[drm]   HPD4
[drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448 0x644c 0x644c
[drm]   Encoders:
[drm]     DFP1: INTERNAL_UNIPHY2
[drm] Connector 1:
[drm]   HDMI-A
[drm]   HPD5
[drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[drm]   Encoders:
[drm]     DFP2: INTERNAL_UNIPHY2
[drm] Connector 2:
[drm]   DVI-I
[drm]   HPD1
[drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c 0x646c
[drm]   Encoders:
[drm]     DFP3: INTERNAL_UNIPHY1
[drm]     CRT2: INTERNAL_KLDSCP_DAC2
[drm] Connector 3:
[drm]   DVI-I
[drm]   HPD6
[drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458 0x645c 0x645c
[drm]   Encoders:
[drm]     DFP4: INTERNAL_UNIPHY
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
[drm] fb mappable at 0xD0040000
[drm] vram apper at 0xD0000000
[drm] size 8294400
[drm] fb depth is 24
[drm]    pitch is 7680
Console: switching to colour frame buffer device 240x67
hda_codec: AD1989B: BIOS auto-probing.
fb0: radeondrmfb frame buffer device
registered panic notifier
[drm] Initialized radeon 2.3.0 20080528 for 0000:03:00.0 on minor 0
HDA Intel 0000:03:00.1: PCI INT B -> GSI 37 (level, low) -> IRQ 37
HDA Intel 0000:03:00.1: irq 58 for MSI/MSI-X
HDA Intel 0000:03:00.1: setting latency timer to 64
EXT3-fs (md5): using internal journal
md: md11 stopped.
md: bind<sde1>
md: bind<sdd1>
raid0: looking at sdd1
raid0:   comparing sdd1(104871936)
 with sdd1(104871936)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at sde1
raid0:   comparing sde1(104871936)
 with sdd1(104871936)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: done.
raid0 : md_size is 209743872 sectors.
******* md11 configuration *********
zone0=[sdd1/sde1/]
        zone offset=0kb device offset=0kb size=104871936kb
**********************************

md11: detected capacity change from 0 to 107388862464
 md11: unknown partition table
md: md6 stopped.
md: bind<sdb6>
md: bind<sdc6>
md: bind<sda6>
raid1: raid set md6 active with 3 out of 3 mirrors
md6: detected capacity change from 0 to 253354939392
 md6: unknown partition table
kjournald starting.  Commit interval 5 seconds
EXT3-fs (md11): warning: maximal mount count reached, running e2fsck
is recommended
EXT3-fs (md11): using internal journal
EXT3-fs (md11): mounted filesystem with writeback data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (md6): warning: maximal mount count reached, running e2fsck is
recommended
EXT3-fs (md6): using internal journal
EXT3-fs (md6): mounted filesystem with writeback data mode
Adding 4200992k swap on /dev/sda2.  Priority:-1 extents:1 across:4200992k
Adding 4200992k swap on /dev/sdb2.  Priority:-2 extents:1 across:4200992k
Adding 4200992k swap on /dev/sdc2.  Priority:-3 extents:1 across:4200992k
sky2 0000:06:00.0: eth0: enabling interface
sky2 0000:06:00.0: eth0: Link is up at 100 Mbps, full duplex, flow control both
NET: Registered protocol family 10
/dev/vmmon[4187]: Module vmmon: registered with major=10 minor=165
/dev/vmmon[4187]: Initial HV check: anyNotCapable=0 anyUnlocked=0
anyEnabled=1 anyDisabled=0
/dev/vmmon[4187]: HV check: anyNotCapable=0 anyUnlocked=0 anyEnabled=1
anyDisabled=0
/dev/vmmon[4187]: Module vmmon: initialized
/dev/vmci[4206]: VMCI: Driver initialized.
/dev/vmci[4206]: Module vmci: registered with major=10 minor=59
/dev/vmci[4206]: Module vmci: initialized
/dev/vmnet: open called by PID 4288 (vmnet-bridge)
/dev/vmnet: hub 0 does not exist, allocating memory.
/dev/vmnet: port on hub 0 successfully opened
bridge-eth0: up
bridge-eth0: attached
/dev/vmnet: open called by PID 4295 (vmnet-dhcpd)
/dev/vmnet: hub 1 does not exist, allocating memory.
/dev/vmnet: port on hub 1 successfully opened
/dev/vmnet: open called by PID 4297 (vmnet-netifup)
/dev/vmnet: port on hub 1 successfully opened
/dev/vmnet: open called by PID 4300 (vmnet-dhcpd)
/dev/vmnet: hub 8 does not exist, allocating memory.
/dev/vmnet: port on hub 8 successfully opened
/dev/vmnet: open called by PID 4304 (vmnet-natd)
/dev/vmnet: port on hub 8 successfully opened
/dev/vmnet: open called by PID 4305 (vmnet-netifup)
/dev/vmnet: port on hub 8 successfully opened
eth0: no IPv6 routers present
vmnet1: no IPv6 routers present
vmnet8: no IPv6 routers present
c2stable ~ #

--000e0cd30a9271caac048a6b4fe8
Content-Type: application/octet-stream; name="i980.2.6.34-gentoo-r1.config"
Content-Disposition: attachment; filename="i980.2.6.34-gentoo-r1.config"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gb5b98y50

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIG1ha2UgY29uZmlnOiBkb24ndCBlZGl0CiMgTGlu
dXgga2VybmVsIHZlcnNpb246IDIuNi4zNC1nZW50b28tcjEKIyBGcmkgSnVsICAyIDA5OjU2OjUy
IDIwMTAKIwpDT05GSUdfNjRCSVQ9eQojIENPTkZJR19YODZfMzIgaXMgbm90IHNldApDT05GSUdf
WDg2XzY0PXkKQ09ORklHX1g4Nj15CkNPTkZJR19PVVRQVVRfRk9STUFUPSJlbGY2NC14ODYtNjQi
CkNPTkZJR19BUkNIX0RFRkNPTkZJRz0iYXJjaC94ODYvY29uZmlncy94ODZfNjRfZGVmY29uZmln
IgpDT05GSUdfR0VORVJJQ19USU1FPXkKQ09ORklHX0dFTkVSSUNfQ01PU19VUERBVEU9eQpDT05G
SUdfQ0xPQ0tTT1VSQ0VfV0FUQ0hET0c9eQpDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5UUz15CkNP
TkZJR19HRU5FUklDX0NMT0NLRVZFTlRTX0JST0FEQ0FTVD15CkNPTkZJR19MT0NLREVQX1NVUFBP
UlQ9eQpDT05GSUdfU1RBQ0tUUkFDRV9TVVBQT1JUPXkKQ09ORklHX0hBVkVfTEFURU5DWVRPUF9T
VVBQT1JUPXkKQ09ORklHX01NVT15CkNPTkZJR19aT05FX0RNQT15CkNPTkZJR19ORUVEX0RNQV9N
QVBfU1RBVEU9eQpDT05GSUdfR0VORVJJQ19JU0FfRE1BPXkKQ09ORklHX0dFTkVSSUNfSU9NQVA9
eQpDT05GSUdfR0VORVJJQ19CVUc9eQpDT05GSUdfR0VORVJJQ19CVUdfUkVMQVRJVkVfUE9JTlRF
UlM9eQpDT05GSUdfR0VORVJJQ19IV0VJR0hUPXkKQ09ORklHX0FSQ0hfTUFZX0hBVkVfUENfRkRD
PXkKIyBDT05GSUdfUldTRU1fR0VORVJJQ19TUElOTE9DSyBpcyBub3Qgc2V0CkNPTkZJR19SV1NF
TV9YQ0hHQUREX0FMR09SSVRITT15CkNPTkZJR19BUkNIX0hBU19DUFVfSURMRV9XQUlUPXkKQ09O
RklHX0dFTkVSSUNfQ0FMSUJSQVRFX0RFTEFZPXkKQ09ORklHX0dFTkVSSUNfVElNRV9WU1lTQ0FM
TD15CkNPTkZJR19BUkNIX0hBU19DUFVfUkVMQVg9eQpDT05GSUdfQVJDSF9IQVNfREVGQVVMVF9J
RExFPXkKQ09ORklHX0FSQ0hfSEFTX0NBQ0hFX0xJTkVfU0laRT15CkNPTkZJR19IQVZFX1NFVFVQ
X1BFUl9DUFVfQVJFQT15CkNPTkZJR19ORUVEX1BFUl9DUFVfRU1CRURfRklSU1RfQ0hVTks9eQpD
T05GSUdfTkVFRF9QRVJfQ1BVX1BBR0VfRklSU1RfQ0hVTks9eQpDT05GSUdfSEFWRV9DUFVNQVNL
X09GX0NQVV9NQVA9eQpDT05GSUdfQVJDSF9ISUJFUk5BVElPTl9QT1NTSUJMRT15CkNPTkZJR19B
UkNIX1NVU1BFTkRfUE9TU0lCTEU9eQpDT05GSUdfWk9ORV9ETUEzMj15CkNPTkZJR19BUkNIX1BP
UFVMQVRFU19OT0RFX01BUD15CkNPTkZJR19BVURJVF9BUkNIPXkKQ09ORklHX0FSQ0hfU1VQUE9S
VFNfT1BUSU1JWkVEX0lOTElOSU5HPXkKQ09ORklHX0FSQ0hfU1VQUE9SVFNfREVCVUdfUEFHRUFM
TE9DPXkKQ09ORklHX0hBVkVfRUFSTFlfUkVTPXkKQ09ORklHX0hBVkVfSU5URUxfVFhUPXkKQ09O
RklHX0dFTkVSSUNfSEFSRElSUVM9eQpDT05GSUdfR0VORVJJQ19IQVJESVJRU19OT19fRE9fSVJR
PXkKQ09ORklHX0dFTkVSSUNfSVJRX1BST0JFPXkKQ09ORklHX0dFTkVSSUNfUEVORElOR19JUlE9
eQpDT05GSUdfVVNFX0dFTkVSSUNfU01QX0hFTFBFUlM9eQpDT05GSUdfWDg2XzY0X1NNUD15CkNP
TkZJR19YODZfSFQ9eQpDT05GSUdfWDg2X1RSQU1QT0xJTkU9eQojIENPTkZJR19LVElNRV9TQ0FM
QVIgaXMgbm90IHNldApDT05GSUdfREVGQ09ORklHX0xJU1Q9Ii9saWIvbW9kdWxlcy8kVU5BTUVf
UkVMRUFTRS8uY29uZmlnIgpDT05GSUdfQ09OU1RSVUNUT1JTPXkKCiMKIyBHZW5lcmFsIHNldHVw
CiMKQ09ORklHX0VYUEVSSU1FTlRBTD15CkNPTkZJR19MT0NLX0tFUk5FTD15CkNPTkZJR19JTklU
X0VOVl9BUkdfTElNSVQ9MzIKQ09ORklHX0xPQ0FMVkVSU0lPTj0iIgojIENPTkZJR19MT0NBTFZF
UlNJT05fQVVUTyBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0tFUk5FTF9HWklQPXkKQ09ORklHX0hB
VkVfS0VSTkVMX0JaSVAyPXkKQ09ORklHX0hBVkVfS0VSTkVMX0xaTUE9eQpDT05GSUdfSEFWRV9L
RVJORUxfTFpPPXkKQ09ORklHX0tFUk5FTF9HWklQPXkKIyBDT05GSUdfS0VSTkVMX0JaSVAyIGlz
IG5vdCBzZXQKIyBDT05GSUdfS0VSTkVMX0xaTUEgaXMgbm90IHNldAojIENPTkZJR19LRVJORUxf
TFpPIGlzIG5vdCBzZXQKQ09ORklHX1NXQVA9eQpDT05GSUdfU1lTVklQQz15CkNPTkZJR19TWVNW
SVBDX1NZU0NUTD15CiMgQ09ORklHX1BPU0lYX01RVUVVRSBpcyBub3Qgc2V0CiMgQ09ORklHX0JT
RF9QUk9DRVNTX0FDQ1QgaXMgbm90IHNldAojIENPTkZJR19UQVNLU1RBVFMgaXMgbm90IHNldAoj
IENPTkZJR19BVURJVCBpcyBub3Qgc2V0CgojCiMgUkNVIFN1YnN5c3RlbQojCiMgQ09ORklHX1RS
RUVfUkNVIGlzIG5vdCBzZXQKQ09ORklHX1RSRUVfUFJFRU1QVF9SQ1U9eQojIENPTkZJR19USU5Z
X1JDVSBpcyBub3Qgc2V0CiMgQ09ORklHX1JDVV9UUkFDRSBpcyBub3Qgc2V0CkNPTkZJR19SQ1Vf
RkFOT1VUPTY0CiMgQ09ORklHX1JDVV9GQU5PVVRfRVhBQ1QgaXMgbm90IHNldAojIENPTkZJR19U
UkVFX1JDVV9UUkFDRSBpcyBub3Qgc2V0CkNPTkZJR19JS0NPTkZJRz15CkNPTkZJR19JS0NPTkZJ
R19QUk9DPXkKQ09ORklHX0xPR19CVUZfU0hJRlQ9MTgKQ09ORklHX0hBVkVfVU5TVEFCTEVfU0NI
RURfQ0xPQ0s9eQojIENPTkZJR19DR1JPVVBTIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lTRlNfREVQ
UkVDQVRFRF9WMiBpcyBub3Qgc2V0CiMgQ09ORklHX1JFTEFZIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkFNRVNQQUNFUyBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX0lOSVRSRD15CkNPTkZJR19JTklU
UkFNRlNfU09VUkNFPSIiCkNPTkZJR19SRF9HWklQPXkKIyBDT05GSUdfUkRfQlpJUDIgaXMgbm90
IHNldAojIENPTkZJR19SRF9MWk1BIGlzIG5vdCBzZXQKIyBDT05GSUdfUkRfTFpPIGlzIG5vdCBz
ZXQKQ09ORklHX0NDX09QVElNSVpFX0ZPUl9TSVpFPXkKQ09ORklHX1NZU0NUTD15CkNPTkZJR19B
Tk9OX0lOT0RFUz15CkNPTkZJR19FTUJFRERFRD15CkNPTkZJR19VSUQxNj15CkNPTkZJR19TWVND
VExfU1lTQ0FMTD15CkNPTkZJR19LQUxMU1lNUz15CkNPTkZJR19LQUxMU1lNU19BTEw9eQpDT05G
SUdfS0FMTFNZTVNfRVhUUkFfUEFTUz15CkNPTkZJR19IT1RQTFVHPXkKQ09ORklHX1BSSU5USz15
CkNPTkZJR19CVUc9eQpDT05GSUdfRUxGX0NPUkU9eQpDT05GSUdfUENTUEtSX1BMQVRGT1JNPXkK
Q09ORklHX0JBU0VfRlVMTD15CkNPTkZJR19GVVRFWD15CkNPTkZJR19FUE9MTD15CkNPTkZJR19T
SUdOQUxGRD15CkNPTkZJR19USU1FUkZEPXkKQ09ORklHX0VWRU5URkQ9eQpDT05GSUdfU0hNRU09
eQpDT05GSUdfQUlPPXkKQ09ORklHX0hBVkVfUEVSRl9FVkVOVFM9eQoKIwojIEtlcm5lbCBQZXJm
b3JtYW5jZSBFdmVudHMgQW5kIENvdW50ZXJzCiMKQ09ORklHX1BFUkZfRVZFTlRTPXkKIyBDT05G
SUdfUEVSRl9DT1VOVEVSUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1BFUkZfVVNFX1ZNQUxM
T0MgaXMgbm90IHNldApDT05GSUdfVk1fRVZFTlRfQ09VTlRFUlM9eQpDT05GSUdfUENJX1FVSVJL
Uz15CkNPTkZJR19DT01QQVRfQlJLPXkKQ09ORklHX1NMQUI9eQojIENPTkZJR19TTFVCIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0xPQiBpcyBub3Qgc2V0CiMgQ09ORklHX1BST0ZJTElORyBpcyBub3Qg
c2V0CkNPTkZJR19IQVZFX09QUk9GSUxFPXkKIyBDT05GSUdfS1BST0JFUyBpcyBub3Qgc2V0CkNP
TkZJR19IQVZFX0VGRklDSUVOVF9VTkFMSUdORURfQUNDRVNTPXkKQ09ORklHX0hBVkVfSU9SRU1B
UF9QUk9UPXkKQ09ORklHX0hBVkVfS1BST0JFUz15CkNPTkZJR19IQVZFX0tSRVRQUk9CRVM9eQpD
T05GSUdfSEFWRV9PUFRQUk9CRVM9eQpDT05GSUdfSEFWRV9BUkNIX1RSQUNFSE9PSz15CkNPTkZJ
R19IQVZFX0RNQV9BVFRSUz15CkNPTkZJR19IQVZFX1JFR1NfQU5EX1NUQUNLX0FDQ0VTU19BUEk9
eQpDT05GSUdfSEFWRV9ETUFfQVBJX0RFQlVHPXkKQ09ORklHX0hBVkVfSFdfQlJFQUtQT0lOVD15
CkNPTkZJR19IQVZFX1VTRVJfUkVUVVJOX05PVElGSUVSPXkKCiMKIyBHQ09WLWJhc2VkIGtlcm5l
bCBwcm9maWxpbmcKIwojIENPTkZJR19HQ09WX0tFUk5FTCBpcyBub3Qgc2V0CiMgQ09ORklHX1NM
T1dfV09SSyBpcyBub3Qgc2V0CiMgQ09ORklHX0hBVkVfR0VORVJJQ19ETUFfQ09IRVJFTlQgaXMg
bm90IHNldApDT05GSUdfU0xBQklORk89eQpDT05GSUdfUlRfTVVURVhFUz15CkNPTkZJR19CQVNF
X1NNQUxMPTAKQ09ORklHX01PRFVMRVM9eQojIENPTkZJR19NT0RVTEVfRk9SQ0VfTE9BRCBpcyBu
b3Qgc2V0CkNPTkZJR19NT0RVTEVfVU5MT0FEPXkKIyBDT05GSUdfTU9EVUxFX0ZPUkNFX1VOTE9B
RCBpcyBub3Qgc2V0CkNPTkZJR19NT0RWRVJTSU9OUz15CiMgQ09ORklHX01PRFVMRV9TUkNWRVJT
SU9OX0FMTCBpcyBub3Qgc2V0CkNPTkZJR19TVE9QX01BQ0hJTkU9eQpDT05GSUdfQkxPQ0s9eQpD
T05GSUdfQkxLX0RFVl9CU0c9eQojIENPTkZJR19CTEtfREVWX0lOVEVHUklUWSBpcyBub3Qgc2V0
CkNPTkZJR19CTE9DS19DT01QQVQ9eQoKIwojIElPIFNjaGVkdWxlcnMKIwpDT05GSUdfSU9TQ0hF
RF9OT09QPXkKQ09ORklHX0lPU0NIRURfREVBRExJTkU9eQpDT05GSUdfSU9TQ0hFRF9DRlE9eQoj
IENPTkZJR19ERUZBVUxUX0RFQURMSU5FIGlzIG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfQ0ZRPXkK
IyBDT05GSUdfREVGQVVMVF9OT09QIGlzIG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfSU9TQ0hFRD0i
Y2ZxIgojIENPTkZJR19JTkxJTkVfU1BJTl9UUllMT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5M
SU5FX1NQSU5fVFJZTE9DS19CSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9TUElOX0xPQ0sg
aXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfU1BJTl9MT0NLX0JIIGlzIG5vdCBzZXQKIyBDT05G
SUdfSU5MSU5FX1NQSU5fTE9DS19JUlEgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfU1BJTl9M
T0NLX0lSUVNBVkUgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfU1BJTl9VTkxPQ0sgaXMgbm90
IHNldAojIENPTkZJR19JTkxJTkVfU1BJTl9VTkxPQ0tfQkggaXMgbm90IHNldAojIENPTkZJR19J
TkxJTkVfU1BJTl9VTkxPQ0tfSVJRIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1NQSU5fVU5M
T0NLX0lSUVJFU1RPUkUgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfUkVBRF9UUllMT0NLIGlz
IG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1JFQURfTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX0lO
TElORV9SRUFEX0xPQ0tfQkggaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfUkVBRF9MT0NLX0lS
USBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9SRUFEX0xPQ0tfSVJRU0FWRSBpcyBub3Qgc2V0
CiMgQ09ORklHX0lOTElORV9SRUFEX1VOTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9S
RUFEX1VOTE9DS19CSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9SRUFEX1VOTE9DS19JUlEg
aXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfUkVBRF9VTkxPQ0tfSVJRUkVTVE9SRSBpcyBub3Qg
c2V0CiMgQ09ORklHX0lOTElORV9XUklURV9UUllMT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5M
SU5FX1dSSVRFX0xPQ0sgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVfTE9DS19CSCBp
cyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9XUklURV9MT0NLX0lSUSBpcyBub3Qgc2V0CiMgQ09O
RklHX0lOTElORV9XUklURV9MT0NLX0lSUVNBVkUgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVf
V1JJVEVfVU5MT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1dSSVRFX1VOTE9DS19CSCBp
cyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9XUklURV9VTkxPQ0tfSVJRIGlzIG5vdCBzZXQKIyBD
T05GSUdfSU5MSU5FX1dSSVRFX1VOTE9DS19JUlFSRVNUT1JFIGlzIG5vdCBzZXQKQ09ORklHX01V
VEVYX1NQSU5fT05fT1dORVI9eQojIENPTkZJR19GUkVFWkVSIGlzIG5vdCBzZXQKCiMKIyBQcm9j
ZXNzb3IgdHlwZSBhbmQgZmVhdHVyZXMKIwpDT05GSUdfVElDS19PTkVTSE9UPXkKQ09ORklHX05P
X0haPXkKQ09ORklHX0hJR0hfUkVTX1RJTUVSUz15CkNPTkZJR19HRU5FUklDX0NMT0NLRVZFTlRT
X0JVSUxEPXkKQ09ORklHX1NNUD15CiMgQ09ORklHX1NQQVJTRV9JUlEgaXMgbm90IHNldApDT05G
SUdfWDg2X01QUEFSU0U9eQojIENPTkZJR19YODZfRVhURU5ERURfUExBVEZPUk0gaXMgbm90IHNl
dApDT05GSUdfWDg2X1NVUFBPUlRTX01FTU9SWV9GQUlMVVJFPXkKQ09ORklHX1NDSEVEX09NSVRf
RlJBTUVfUE9JTlRFUj15CiMgQ09ORklHX1BBUkFWSVJUX0dVRVNUIGlzIG5vdCBzZXQKQ09ORklH
X05PX0JPT1RNRU09eQojIENPTkZJR19NRU1URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfTTM4NiBp
cyBub3Qgc2V0CiMgQ09ORklHX000ODYgaXMgbm90IHNldAojIENPTkZJR19NNTg2IGlzIG5vdCBz
ZXQKIyBDT05GSUdfTTU4NlRTQyBpcyBub3Qgc2V0CiMgQ09ORklHX001ODZNTVggaXMgbm90IHNl
dAojIENPTkZJR19NNjg2IGlzIG5vdCBzZXQKIyBDT05GSUdfTVBFTlRJVU1JSSBpcyBub3Qgc2V0
CiMgQ09ORklHX01QRU5USVVNSUlJIGlzIG5vdCBzZXQKIyBDT05GSUdfTVBFTlRJVU1NIGlzIG5v
dCBzZXQKIyBDT05GSUdfTVBFTlRJVU00IGlzIG5vdCBzZXQKIyBDT05GSUdfTUs2IGlzIG5vdCBz
ZXQKIyBDT05GSUdfTUs3IGlzIG5vdCBzZXQKIyBDT05GSUdfTUs4IGlzIG5vdCBzZXQKIyBDT05G
SUdfTUNSVVNPRSBpcyBub3Qgc2V0CiMgQ09ORklHX01FRkZJQ0VPTiBpcyBub3Qgc2V0CiMgQ09O
RklHX01XSU5DSElQQzYgaXMgbm90IHNldAojIENPTkZJR19NV0lOQ0hJUDNEIGlzIG5vdCBzZXQK
IyBDT05GSUdfTUdFT0RFR1gxIGlzIG5vdCBzZXQKIyBDT05GSUdfTUdFT0RFX0xYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTUNZUklYSUlJIGlzIG5vdCBzZXQKIyBDT05GSUdfTVZJQUMzXzIgaXMgbm90
IHNldAojIENPTkZJR19NVklBQzcgaXMgbm90IHNldAojIENPTkZJR19NUFNDIGlzIG5vdCBzZXQK
Q09ORklHX01DT1JFMj15CiMgQ09ORklHX01BVE9NIGlzIG5vdCBzZXQKIyBDT05GSUdfR0VORVJJ
Q19DUFUgaXMgbm90IHNldApDT05GSUdfWDg2X0NQVT15CkNPTkZJR19YODZfSU5URVJOT0RFX0NB
Q0hFX1NISUZUPTYKQ09ORklHX1g4Nl9DTVBYQ0hHPXkKQ09ORklHX1g4Nl9MMV9DQUNIRV9TSElG
VD02CkNPTkZJR19YODZfWEFERD15CkNPTkZJR19YODZfV1BfV09SS1NfT0s9eQpDT05GSUdfWDg2
X0lOVEVMX1VTRVJDT1BZPXkKQ09ORklHX1g4Nl9VU0VfUFBST19DSEVDS1NVTT15CkNPTkZJR19Y
ODZfUDZfTk9QPXkKQ09ORklHX1g4Nl9UU0M9eQpDT05GSUdfWDg2X0NNUFhDSEc2ND15CkNPTkZJ
R19YODZfQ01PVj15CkNPTkZJR19YODZfTUlOSU1VTV9DUFVfRkFNSUxZPTY0CkNPTkZJR19YODZf
REVCVUdDVExNU1I9eQojIENPTkZJR19QUk9DRVNTT1JfU0VMRUNUIGlzIG5vdCBzZXQKQ09ORklH
X0NQVV9TVVBfSU5URUw9eQpDT05GSUdfQ1BVX1NVUF9BTUQ9eQpDT05GSUdfQ1BVX1NVUF9DRU5U
QVVSPXkKIyBDT05GSUdfWDg2X0RTIGlzIG5vdCBzZXQKQ09ORklHX0hQRVRfVElNRVI9eQpDT05G
SUdfSFBFVF9FTVVMQVRFX1JUQz15CkNPTkZJR19ETUk9eQpDT05GSUdfR0FSVF9JT01NVT15CiMg
Q09ORklHX0NBTEdBUllfSU9NTVUgaXMgbm90IHNldAojIENPTkZJR19BTURfSU9NTVUgaXMgbm90
IHNldApDT05GSUdfU1dJT1RMQj15CkNPTkZJR19JT01NVV9IRUxQRVI9eQpDT05GSUdfSU9NTVVf
QVBJPXkKIyBDT05GSUdfTUFYU01QIGlzIG5vdCBzZXQKQ09ORklHX05SX0NQVVM9MTIKQ09ORklH
X1NDSEVEX1NNVD15CkNPTkZJR19TQ0hFRF9NQz15CiMgQ09ORklHX1BSRUVNUFRfTk9ORSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BSRUVNUFRfVk9MVU5UQVJZIGlzIG5vdCBzZXQKQ09ORklHX1BSRUVN
UFQ9eQpDT05GSUdfWDg2X0xPQ0FMX0FQSUM9eQpDT05GSUdfWDg2X0lPX0FQSUM9eQojIENPTkZJ
R19YODZfUkVST1VURV9GT1JfQlJPS0VOX0JPT1RfSVJRUyBpcyBub3Qgc2V0CkNPTkZJR19YODZf
TUNFPXkKQ09ORklHX1g4Nl9NQ0VfSU5URUw9eQojIENPTkZJR19YODZfTUNFX0FNRCBpcyBub3Qg
c2V0CkNPTkZJR19YODZfTUNFX1RIUkVTSE9MRD15CiMgQ09ORklHX1g4Nl9NQ0VfSU5KRUNUIGlz
IG5vdCBzZXQKQ09ORklHX1g4Nl9USEVSTUFMX1ZFQ1RPUj15CiMgQ09ORklHX0k4SyBpcyBub3Qg
c2V0CiMgQ09ORklHX01JQ1JPQ09ERSBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9NU1IgaXMgbm90
IHNldApDT05GSUdfWDg2X0NQVUlEPXkKQ09ORklHX0FSQ0hfUEhZU19BRERSX1RfNjRCSVQ9eQpD
T05GSUdfRElSRUNUX0dCUEFHRVM9eQojIENPTkZJR19OVU1BIGlzIG5vdCBzZXQKQ09ORklHX0FS
Q0hfU1BBUlNFTUVNX0RFRkFVTFQ9eQpDT05GSUdfQVJDSF9TUEFSU0VNRU1fRU5BQkxFPXkKQ09O
RklHX0FSQ0hfU0VMRUNUX01FTU9SWV9NT0RFTD15CkNPTkZJR19JTExFR0FMX1BPSU5URVJfVkFM
VUU9MHhkZWFkMDAwMDAwMDAwMDAwCkNPTkZJR19TRUxFQ1RfTUVNT1JZX01PREVMPXkKIyBDT05G
SUdfRkxBVE1FTV9NQU5VQUwgaXMgbm90IHNldAojIENPTkZJR19ESVNDT05USUdNRU1fTUFOVUFM
IGlzIG5vdCBzZXQKQ09ORklHX1NQQVJTRU1FTV9NQU5VQUw9eQpDT05GSUdfU1BBUlNFTUVNPXkK
Q09ORklHX0hBVkVfTUVNT1JZX1BSRVNFTlQ9eQpDT05GSUdfU1BBUlNFTUVNX0VYVFJFTUU9eQpD
T05GSUdfU1BBUlNFTUVNX1ZNRU1NQVBfRU5BQkxFPXkKQ09ORklHX1NQQVJTRU1FTV9BTExPQ19N
RU1fTUFQX1RPR0VUSEVSPXkKQ09ORklHX1NQQVJTRU1FTV9WTUVNTUFQPXkKIyBDT05GSUdfTUVN
T1JZX0hPVFBMVUcgaXMgbm90IHNldApDT05GSUdfUEFHRUZMQUdTX0VYVEVOREVEPXkKQ09ORklH
X1NQTElUX1BUTE9DS19DUFVTPTQKQ09ORklHX1BIWVNfQUREUl9UXzY0QklUPXkKQ09ORklHX1pP
TkVfRE1BX0ZMQUc9MQpDT05GSUdfQk9VTkNFPXkKQ09ORklHX1ZJUlRfVE9fQlVTPXkKIyBDT05G
SUdfS1NNIGlzIG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfTU1BUF9NSU5fQUREUj00MDk2CkNPTkZJ
R19BUkNIX1NVUFBPUlRTX01FTU9SWV9GQUlMVVJFPXkKIyBDT05GSUdfTUVNT1JZX0ZBSUxVUkUg
aXMgbm90IHNldAojIENPTkZJR19YODZfQ0hFQ0tfQklPU19DT1JSVVBUSU9OIGlzIG5vdCBzZXQK
Q09ORklHX1g4Nl9SRVNFUlZFX0xPV182NEs9eQpDT05GSUdfTVRSUj15CkNPTkZJR19NVFJSX1NB
TklUSVpFUj15CkNPTkZJR19NVFJSX1NBTklUSVpFUl9FTkFCTEVfREVGQVVMVD0wCkNPTkZJR19N
VFJSX1NBTklUSVpFUl9TUEFSRV9SRUdfTlJfREVGQVVMVD0xCkNPTkZJR19YODZfUEFUPXkKQ09O
RklHX0FSQ0hfVVNFU19QR19VTkNBQ0hFRD15CkNPTkZJR19FRkk9eQpDT05GSUdfU0VDQ09NUD15
CiMgQ09ORklHX0NDX1NUQUNLUFJPVEVDVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfSFpfMTAwIGlz
IG5vdCBzZXQKIyBDT05GSUdfSFpfMjUwIGlzIG5vdCBzZXQKIyBDT05GSUdfSFpfMzAwIGlzIG5v
dCBzZXQKQ09ORklHX0haXzEwMDA9eQpDT05GSUdfSFo9MTAwMApDT05GSUdfU0NIRURfSFJUSUNL
PXkKIyBDT05GSUdfS0VYRUMgaXMgbm90IHNldAojIENPTkZJR19DUkFTSF9EVU1QIGlzIG5vdCBz
ZXQKQ09ORklHX1BIWVNJQ0FMX1NUQVJUPTB4MTAwMDAwMApDT05GSUdfUkVMT0NBVEFCTEU9eQpD
T05GSUdfUEhZU0lDQUxfQUxJR049MHgxMDAwMDAwCiMgQ09ORklHX0hPVFBMVUdfQ1BVIGlzIG5v
dCBzZXQKIyBDT05GSUdfQ09NUEFUX1ZEU08gaXMgbm90IHNldAojIENPTkZJR19DTURMSU5FX0JP
T0wgaXMgbm90IHNldApDT05GSUdfQVJDSF9FTkFCTEVfTUVNT1JZX0hPVFBMVUc9eQoKIwojIFBv
d2VyIG1hbmFnZW1lbnQgYW5kIEFDUEkgb3B0aW9ucwojCkNPTkZJR19QTT15CiMgQ09ORklHX1BN
X0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfU1VTUEVORCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJ
QkVSTkFUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfUE1fUlVOVElNRSBpcyBub3Qgc2V0CkNPTkZJ
R19BQ1BJPXkKQ09ORklHX0FDUElfUFJPQ0ZTPXkKQ09ORklHX0FDUElfUFJPQ0ZTX1BPV0VSPXkK
IyBDT05GSUdfQUNQSV9QT1dFUl9NRVRFUiBpcyBub3Qgc2V0CkNPTkZJR19BQ1BJX1NZU0ZTX1BP
V0VSPXkKQ09ORklHX0FDUElfUFJPQ19FVkVOVD15CkNPTkZJR19BQ1BJX0FDPW0KQ09ORklHX0FD
UElfQkFUVEVSWT1tCkNPTkZJR19BQ1BJX0JVVFRPTj15CkNPTkZJR19BQ1BJX1ZJREVPPW0KQ09O
RklHX0FDUElfRkFOPXkKQ09ORklHX0FDUElfRE9DSz15CkNPTkZJR19BQ1BJX1BST0NFU1NPUj15
CkNPTkZJR19BQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SPXkKQ09ORklHX0FDUElfVEhFUk1BTD15
CiMgQ09ORklHX0FDUElfQ1VTVE9NX0RTRFQgaXMgbm90IHNldApDT05GSUdfQUNQSV9CTEFDS0xJ
U1RfWUVBUj0wCiMgQ09ORklHX0FDUElfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19BQ1BJX1BD
SV9TTE9UIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9QTV9USU1FUj15CiMgQ09ORklHX0FDUElfQ09O
VEFJTkVSIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQSV9TQlMgaXMgbm90IHNldAojIENPTkZJR19T
RkkgaXMgbm90IHNldAoKIwojIENQVSBGcmVxdWVuY3kgc2NhbGluZwojCkNPTkZJR19DUFVfRlJF
UT15CkNPTkZJR19DUFVfRlJFUV9UQUJMRT1tCkNPTkZJR19DUFVfRlJFUV9ERUJVRz15CiMgQ09O
RklHX0NQVV9GUkVRX1NUQVQgaXMgbm90IHNldApDT05GSUdfQ1BVX0ZSRVFfREVGQVVMVF9HT1Zf
UEVSRk9STUFOQ0U9eQojIENPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9QT1dFUlNBVkUgaXMg
bm90IHNldAojIENPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9VU0VSU1BBQ0UgaXMgbm90IHNl
dAojIENPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9PTkRFTUFORCBpcyBub3Qgc2V0CiMgQ09O
RklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX0NPTlNFUlZBVElWRSBpcyBub3Qgc2V0CkNPTkZJR19D
UFVfRlJFUV9HT1ZfUEVSRk9STUFOQ0U9eQpDT05GSUdfQ1BVX0ZSRVFfR09WX1BPV0VSU0FWRT1t
CkNPTkZJR19DUFVfRlJFUV9HT1ZfVVNFUlNQQUNFPW0KQ09ORklHX0NQVV9GUkVRX0dPVl9PTkRF
TUFORD1tCkNPTkZJR19DUFVfRlJFUV9HT1ZfQ09OU0VSVkFUSVZFPW0KCiMKIyBDUFVGcmVxIHBy
b2Nlc3NvciBkcml2ZXJzCiMKIyBDT05GSUdfWDg2X1BDQ19DUFVGUkVRIGlzIG5vdCBzZXQKQ09O
RklHX1g4Nl9BQ1BJX0NQVUZSRVE9bQojIENPTkZJR19YODZfUE9XRVJOT1dfSzggaXMgbm90IHNl
dAojIENPTkZJR19YODZfU1BFRURTVEVQX0NFTlRSSU5PIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9Q
NF9DTE9DS01PRD1tCgojCiMgc2hhcmVkIG9wdGlvbnMKIwpDT05GSUdfWDg2X1NQRUVEU1RFUF9M
SUI9bQpDT05GSUdfQ1BVX0lETEU9eQpDT05GSUdfQ1BVX0lETEVfR09WX0xBRERFUj15CkNPTkZJ
R19DUFVfSURMRV9HT1ZfTUVOVT15CgojCiMgTWVtb3J5IHBvd2VyIHNhdmluZ3MKIwpDT05GSUdf
STczMDBfSURMRV9JT0FUX0NIQU5ORUw9eQpDT05GSUdfSTczMDBfSURMRT1tCgojCiMgQnVzIG9w
dGlvbnMgKFBDSSBldGMuKQojCkNPTkZJR19QQ0k9eQpDT05GSUdfUENJX0RJUkVDVD15CkNPTkZJ
R19QQ0lfTU1DT05GSUc9eQpDT05GSUdfUENJX0RPTUFJTlM9eQpDT05GSUdfRE1BUj15CiMgQ09O
RklHX0RNQVJfREVGQVVMVF9PTiBpcyBub3Qgc2V0CkNPTkZJR19ETUFSX0ZMT1BQWV9XQT15CiMg
Q09ORklHX0lOVFJfUkVNQVAgaXMgbm90IHNldApDT05GSUdfUENJRVBPUlRCVVM9eQpDT05GSUdf
UENJRUFFUj15CkNPTkZJR19QQ0lFX0VDUkM9eQojIENPTkZJR19QQ0lFQUVSX0lOSkVDVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BDSUVBU1BNIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfU1VQUE9SVFNf
TVNJPXkKQ09ORklHX1BDSV9NU0k9eQojIENPTkZJR19QQ0lfREVCVUcgaXMgbm90IHNldAojIENP
TkZJR19QQ0lfU1RVQiBpcyBub3Qgc2V0CkNPTkZJR19IVF9JUlE9eQojIENPTkZJR19QQ0lfSU9W
IGlzIG5vdCBzZXQKQ09ORklHX1BDSV9JT0FQSUM9eQpDT05GSUdfSVNBX0RNQV9BUEk9eQpDT05G
SUdfSzhfTkI9eQpDT05GSUdfUENDQVJEPW0KQ09ORklHX1BDTUNJQT1tCkNPTkZJR19QQ01DSUFf
TE9BRF9DSVM9eQpDT05GSUdfQ0FSREJVUz15CgojCiMgUEMtY2FyZCBicmlkZ2VzCiMKQ09ORklH
X1lFTlRBPW0KQ09ORklHX1lFTlRBX08yPXkKQ09ORklHX1lFTlRBX1JJQ09IPXkKQ09ORklHX1lF
TlRBX1RJPXkKQ09ORklHX1lFTlRBX0VORV9UVU5FPXkKQ09ORklHX1lFTlRBX1RPU0hJQkE9eQpD
T05GSUdfUEQ2NzI5PW0KQ09ORklHX0k4MjA5Mj1tCkNPTkZJR19QQ0NBUkRfTk9OU1RBVElDPW0K
IyBDT05GSUdfSE9UUExVR19QQ0kgaXMgbm90IHNldAoKIwojIEV4ZWN1dGFibGUgZmlsZSBmb3Jt
YXRzIC8gRW11bGF0aW9ucwojCkNPTkZJR19CSU5GTVRfRUxGPXkKQ09ORklHX0NPTVBBVF9CSU5G
TVRfRUxGPXkKIyBDT05GSUdfQ09SRV9EVU1QX0RFRkFVTFRfRUxGX0hFQURFUlMgaXMgbm90IHNl
dAojIENPTkZJR19IQVZFX0FPVVQgaXMgbm90IHNldApDT05GSUdfQklORk1UX01JU0M9eQpDT05G
SUdfSUEzMl9FTVVMQVRJT049eQpDT05GSUdfSUEzMl9BT1VUPXkKQ09ORklHX0NPTVBBVD15CkNP
TkZJR19DT01QQVRfRk9SX1U2NF9BTElHTk1FTlQ9eQpDT05GSUdfU1lTVklQQ19DT01QQVQ9eQpD
T05GSUdfTkVUPXkKCiMKIyBOZXR3b3JraW5nIG9wdGlvbnMKIwpDT05GSUdfUEFDS0VUPXkKQ09O
RklHX1VOSVg9eQpDT05GSUdfWEZSTT15CkNPTkZJR19YRlJNX1VTRVI9bQojIENPTkZJR19YRlJN
X1NVQl9QT0xJQ1kgaXMgbm90IHNldAojIENPTkZJR19YRlJNX01JR1JBVEUgaXMgbm90IHNldAoj
IENPTkZJR19YRlJNX1NUQVRJU1RJQ1MgaXMgbm90IHNldApDT05GSUdfTkVUX0tFWT1tCiMgQ09O
RklHX05FVF9LRVlfTUlHUkFURSBpcyBub3Qgc2V0CkNPTkZJR19JTkVUPXkKQ09ORklHX0lQX01V
TFRJQ0FTVD15CkNPTkZJR19JUF9BRFZBTkNFRF9ST1VURVI9eQpDT05GSUdfQVNLX0lQX0ZJQl9I
QVNIPXkKIyBDT05GSUdfSVBfRklCX1RSSUUgaXMgbm90IHNldApDT05GSUdfSVBfRklCX0hBU0g9
eQpDT05GSUdfSVBfTVVMVElQTEVfVEFCTEVTPXkKQ09ORklHX0lQX1JPVVRFX01VTFRJUEFUSD15
CkNPTkZJR19JUF9ST1VURV9WRVJCT1NFPXkKQ09ORklHX0lQX1BOUD15CkNPTkZJR19JUF9QTlBf
REhDUD15CkNPTkZJR19JUF9QTlBfQk9PVFA9eQpDT05GSUdfSVBfUE5QX1JBUlA9eQojIENPTkZJ
R19ORVRfSVBJUCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9JUEdSRSBpcyBub3Qgc2V0CkNPTkZJ
R19JUF9NUk9VVEU9eQpDT05GSUdfSVBfUElNU01fVjE9eQpDT05GSUdfSVBfUElNU01fVjI9eQoj
IENPTkZJR19BUlBEIGlzIG5vdCBzZXQKQ09ORklHX1NZTl9DT09LSUVTPXkKIyBDT05GSUdfSU5F
VF9BSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfRVNQIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5F
VF9JUENPTVAgaXMgbm90IHNldAojIENPTkZJR19JTkVUX1hGUk1fVFVOTkVMIGlzIG5vdCBzZXQK
Q09ORklHX0lORVRfVFVOTkVMPW0KIyBDT05GSUdfSU5FVF9YRlJNX01PREVfVFJBTlNQT1JUIGlz
IG5vdCBzZXQKIyBDT05GSUdfSU5FVF9YRlJNX01PREVfVFVOTkVMIGlzIG5vdCBzZXQKIyBDT05G
SUdfSU5FVF9YRlJNX01PREVfQkVFVCBpcyBub3Qgc2V0CkNPTkZJR19JTkVUX0xSTz15CiMgQ09O
RklHX0lORVRfRElBRyBpcyBub3Qgc2V0CiMgQ09ORklHX1RDUF9DT05HX0FEVkFOQ0VEIGlzIG5v
dCBzZXQKQ09ORklHX1RDUF9DT05HX0NVQklDPXkKQ09ORklHX0RFRkFVTFRfVENQX0NPTkc9ImN1
YmljIgojIENPTkZJR19UQ1BfTUQ1U0lHIGlzIG5vdCBzZXQKQ09ORklHX0lQVjY9bQojIENPTkZJ
R19JUFY2X1BSSVZBQ1kgaXMgbm90IHNldAojIENPTkZJR19JUFY2X1JPVVRFUl9QUkVGIGlzIG5v
dCBzZXQKIyBDT05GSUdfSVBWNl9PUFRJTUlTVElDX0RBRCBpcyBub3Qgc2V0CkNPTkZJR19JTkVU
Nl9BSD1tCkNPTkZJR19JTkVUNl9FU1A9bQojIENPTkZJR19JTkVUNl9JUENPTVAgaXMgbm90IHNl
dAojIENPTkZJR19JUFY2X01JUDYgaXMgbm90IHNldAojIENPTkZJR19JTkVUNl9YRlJNX1RVTk5F
TCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVQ2X1RVTk5FTCBpcyBub3Qgc2V0CkNPTkZJR19JTkVU
Nl9YRlJNX01PREVfVFJBTlNQT1JUPW0KQ09ORklHX0lORVQ2X1hGUk1fTU9ERV9UVU5ORUw9bQpD
T05GSUdfSU5FVDZfWEZSTV9NT0RFX0JFRVQ9bQojIENPTkZJR19JTkVUNl9YRlJNX01PREVfUk9V
VEVPUFRJTUlaQVRJT04gaXMgbm90IHNldApDT05GSUdfSVBWNl9TSVQ9bQojIENPTkZJR19JUFY2
X1NJVF82UkQgaXMgbm90IHNldApDT05GSUdfSVBWNl9ORElTQ19OT0RFVFlQRT15CiMgQ09ORklH
X0lQVjZfVFVOTkVMIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBWNl9NVUxUSVBMRV9UQUJMRVMgaXMg
bm90IHNldAojIENPTkZJR19JUFY2X01ST1VURSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVExBQkVM
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUV09SS19TRUNNQVJLIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkVURklMVEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfRENDUCBpcyBub3Qgc2V0CkNPTkZJR19J
UF9TQ1RQPW0KIyBDT05GSUdfU0NUUF9EQkdfTVNHIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NUUF9E
QkdfT0JKQ05UIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NUUF9ITUFDX05PTkUgaXMgbm90IHNldAoj
IENPTkZJR19TQ1RQX0hNQUNfU0hBMSBpcyBub3Qgc2V0CkNPTkZJR19TQ1RQX0hNQUNfTUQ1PXkK
IyBDT05GSUdfUkRTIGlzIG5vdCBzZXQKIyBDT05GSUdfVElQQyBpcyBub3Qgc2V0CiMgQ09ORklH
X0FUTSBpcyBub3Qgc2V0CiMgQ09ORklHX0JSSURHRSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9E
U0EgaXMgbm90IHNldAojIENPTkZJR19WTEFOXzgwMjFRIGlzIG5vdCBzZXQKIyBDT05GSUdfREVD
TkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfTExDMiBpcyBub3Qgc2V0CiMgQ09ORklHX0lQWCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FUQUxLIGlzIG5vdCBzZXQKIyBDT05GSUdfWDI1IGlzIG5vdCBzZXQK
IyBDT05GSUdfTEFQQiBpcyBub3Qgc2V0CiMgQ09ORklHX0VDT05FVCBpcyBub3Qgc2V0CiMgQ09O
RklHX1dBTl9ST1VURVIgaXMgbm90IHNldAojIENPTkZJR19QSE9ORVQgaXMgbm90IHNldAojIENP
TkZJR19JRUVFODAyMTU0IGlzIG5vdCBzZXQKQ09ORklHX05FVF9TQ0hFRD15CgojCiMgUXVldWVp
bmcvU2NoZWR1bGluZwojCiMgQ09ORklHX05FVF9TQ0hfQ0JRIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkVUX1NDSF9IVEIgaXMgbm90IHNldAojIENPTkZJR19ORVRfU0NIX0hGU0MgaXMgbm90IHNldAoj
IENPTkZJR19ORVRfU0NIX1BSSU8gaXMgbm90IHNldAojIENPTkZJR19ORVRfU0NIX01VTFRJUSBp
cyBub3Qgc2V0CiMgQ09ORklHX05FVF9TQ0hfUkVEIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ND
SF9TRlEgaXMgbm90IHNldAojIENPTkZJR19ORVRfU0NIX1RFUUwgaXMgbm90IHNldAojIENPTkZJ
R19ORVRfU0NIX1RCRiBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9TQ0hfR1JFRCBpcyBub3Qgc2V0
CiMgQ09ORklHX05FVF9TQ0hfRFNNQVJLIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1NDSF9ORVRF
TSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9TQ0hfRFJSIGlzIG5vdCBzZXQKCiMKIyBDbGFzc2lm
aWNhdGlvbgojCiMgQ09ORklHX05FVF9DTFNfQkFTSUMgaXMgbm90IHNldAojIENPTkZJR19ORVRf
Q0xTX1RDSU5ERVggaXMgbm90IHNldAojIENPTkZJR19ORVRfQ0xTX1JPVVRFNCBpcyBub3Qgc2V0
CiMgQ09ORklHX05FVF9DTFNfRlcgaXMgbm90IHNldAojIENPTkZJR19ORVRfQ0xTX1UzMiBpcyBu
b3Qgc2V0CiMgQ09ORklHX05FVF9DTFNfUlNWUCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9DTFNf
UlNWUDYgaXMgbm90IHNldAojIENPTkZJR19ORVRfQ0xTX0ZMT1cgaXMgbm90IHNldAojIENPTkZJ
R19ORVRfRU1BVENIIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0NMU19BQ1QgaXMgbm90IHNldApD
T05GSUdfTkVUX1NDSF9GSUZPPXkKIyBDT05GSUdfRENCIGlzIG5vdCBzZXQKCiMKIyBOZXR3b3Jr
IHRlc3RpbmcKIwojIENPTkZJR19ORVRfUEtUR0VOIGlzIG5vdCBzZXQKIyBDT05GSUdfSEFNUkFE
SU8gaXMgbm90IHNldAojIENPTkZJR19DQU4gaXMgbm90IHNldAojIENPTkZJR19JUkRBIGlzIG5v
dCBzZXQKIyBDT05GSUdfQlQgaXMgbm90IHNldAojIENPTkZJR19BRl9SWFJQQyBpcyBub3Qgc2V0
CkNPTkZJR19GSUJfUlVMRVM9eQpDT05GSUdfV0lSRUxFU1M9eQojIENPTkZJR19DRkc4MDIxMSBp
cyBub3Qgc2V0CiMgQ09ORklHX0xJQjgwMjExIGlzIG5vdCBzZXQKCiMKIyBDRkc4MDIxMSBuZWVk
cyB0byBiZSBlbmFibGVkIGZvciBNQUM4MDIxMQojCiMgQ09ORklHX1dJTUFYIGlzIG5vdCBzZXQK
IyBDT05GSUdfUkZLSUxMIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUXzlQIGlzIG5vdCBzZXQKCiMK
IyBEZXZpY2UgRHJpdmVycwojCgojCiMgR2VuZXJpYyBEcml2ZXIgT3B0aW9ucwojCkNPTkZJR19V
RVZFTlRfSEVMUEVSX1BBVEg9Ii9zYmluL2hvdHBsdWciCiMgQ09ORklHX0RFVlRNUEZTIGlzIG5v
dCBzZXQKQ09ORklHX1NUQU5EQUxPTkU9eQpDT05GSUdfUFJFVkVOVF9GSVJNV0FSRV9CVUlMRD15
CkNPTkZJR19GV19MT0FERVI9eQpDT05GSUdfRklSTVdBUkVfSU5fS0VSTkVMPXkKQ09ORklHX0VY
VFJBX0ZJUk1XQVJFPSIiCiMgQ09ORklHX0RFQlVHX0RSSVZFUiBpcyBub3Qgc2V0CkNPTkZJR19E
RUJVR19ERVZSRVM9eQojIENPTkZJR19TWVNfSFlQRVJWSVNPUiBpcyBub3Qgc2V0CkNPTkZJR19D
T05ORUNUT1I9eQpDT05GSUdfUFJPQ19FVkVOVFM9eQojIENPTkZJR19NVEQgaXMgbm90IHNldApD
T05GSUdfUEFSUE9SVD1tCkNPTkZJR19QQVJQT1JUX1BDPW0KIyBDT05GSUdfUEFSUE9SVF9TRVJJ
QUwgaXMgbm90IHNldAojIENPTkZJR19QQVJQT1JUX1BDX0ZJRk8gaXMgbm90IHNldAojIENPTkZJ
R19QQVJQT1JUX1BDX1NVUEVSSU8gaXMgbm90IHNldAojIENPTkZJR19QQVJQT1JUX1BDX1BDTUNJ
QSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBUlBPUlRfR1NDIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFS
UE9SVF9BWDg4Nzk2IGlzIG5vdCBzZXQKIyBDT05GSUdfUEFSUE9SVF8xMjg0IGlzIG5vdCBzZXQK
Q09ORklHX1BOUD15CkNPTkZJR19QTlBfREVCVUdfTUVTU0FHRVM9eQoKIwojIFByb3RvY29scwoj
CkNPTkZJR19QTlBBQ1BJPXkKQ09ORklHX0JMS19ERVY9eQojIENPTkZJR19CTEtfREVWX0ZEIGlz
IG5vdCBzZXQKIyBDT05GSUdfUEFSSURFIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0NQUV9EQSBp
cyBub3Qgc2V0CiMgQ09ORklHX0JMS19DUFFfQ0lTU19EQSBpcyBub3Qgc2V0CiMgQ09ORklHX0JM
S19ERVZfREFDOTYwIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9VTUVNIGlzIG5vdCBzZXQK
IyBDT05GSUdfQkxLX0RFVl9DT1dfQ09NTU9OIGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZfTE9P
UD15CiMgQ09ORklHX0JMS19ERVZfQ1JZUFRPTE9PUCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19E
RVZfRFJCRCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfTkJEIGlzIG5vdCBzZXQKIyBDT05G
SUdfQkxLX0RFVl9TWDggaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1VCIGlzIG5vdCBzZXQK
Q09ORklHX0JMS19ERVZfUkFNPXkKQ09ORklHX0JMS19ERVZfUkFNX0NPVU5UPTE2CkNPTkZJR19C
TEtfREVWX1JBTV9TSVpFPTE2Mzg0CiMgQ09ORklHX0JMS19ERVZfWElQIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ0RST01fUEtUQ0RWRCBpcyBub3Qgc2V0CiMgQ09ORklHX0FUQV9PVkVSX0VUSCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfSEQgaXMgbm90IHNldApDT05GSUdfTUlTQ19ERVZJQ0VT
PXkKIyBDT05GSUdfQUQ1MjVYX0RQT1QgaXMgbm90IHNldAojIENPTkZJR19JQk1fQVNNIGlzIG5v
dCBzZXQKIyBDT05GSUdfUEhBTlRPTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NHSV9JT0M0IGlzIG5v
dCBzZXQKIyBDT05GSUdfVElGTV9DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfSUNTOTMyUzQwMSBp
cyBub3Qgc2V0CiMgQ09ORklHX0VOQ0xPU1VSRV9TRVJWSUNFUyBpcyBub3Qgc2V0CiMgQ09ORklH
X0NTNTUzNV9NRkdQVCBpcyBub3Qgc2V0CiMgQ09ORklHX0hQX0lMTyBpcyBub3Qgc2V0CiMgQ09O
RklHX0lTTDI5MDAzIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19UU0wyNTUwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRFMxNjgyIGlzIG5vdCBzZXQKIyBDT05GSUdfVk1XQVJFX0JBTExPT04gaXMg
bm90IHNldAojIENPTkZJR19DMlBPUlQgaXMgbm90IHNldAoKIwojIEVFUFJPTSBzdXBwb3J0CiMK
IyBDT05GSUdfRUVQUk9NX0FUMjQgaXMgbm90IHNldAojIENPTkZJR19FRVBST01fTEVHQUNZIGlz
IG5vdCBzZXQKIyBDT05GSUdfRUVQUk9NX01BWDY4NzUgaXMgbm90IHNldAojIENPTkZJR19FRVBS
T01fOTNDWDYgaXMgbm90IHNldAojIENPTkZJR19DQjcxMF9DT1JFIGlzIG5vdCBzZXQKQ09ORklH
X0hBVkVfSURFPXkKQ09ORklHX0lERT15CgojCiMgUGxlYXNlIHNlZSBEb2N1bWVudGF0aW9uL2lk
ZS9pZGUudHh0IGZvciBoZWxwL2luZm8gb24gSURFIGRyaXZlcwojCiMgQ09ORklHX0JMS19ERVZf
SURFX1NBVEEgaXMgbm90IHNldApDT05GSUdfSURFX0dEPXkKQ09ORklHX0lERV9HRF9BVEE9eQoj
IENPTkZJR19JREVfR0RfQVRBUEkgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0lERUNTIGlz
IG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9ERUxLSU4gaXMgbm90IHNldAojIENPTkZJR19CTEtf
REVWX0lERUNEIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9JREVUQVBFIGlzIG5vdCBzZXQK
IyBDT05GSUdfQkxLX0RFVl9JREVBQ1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfSURFX1RBU0tfSU9D
VEwgaXMgbm90IHNldApDT05GSUdfSURFX1BST0NfRlM9eQoKIwojIElERSBjaGlwc2V0IHN1cHBv
cnQvYnVnZml4ZXMKIwojIENPTkZJR19JREVfR0VORVJJQyBpcyBub3Qgc2V0CiMgQ09ORklHX0JM
S19ERVZfUExBVEZPUk0gaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0NNRDY0MCBpcyBub3Qg
c2V0CiMgQ09ORklHX0JMS19ERVZfSURFUE5QIGlzIG5vdCBzZXQKCiMKIyBQQ0kgSURFIGNoaXBz
ZXRzIHN1cHBvcnQKIwojIENPTkZJR19CTEtfREVWX0dFTkVSSUMgaXMgbm90IHNldAojIENPTkZJ
R19CTEtfREVWX09QVEk2MjEgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1JaMTAwMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfQUVDNjJYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19E
RVZfQUxJMTVYMyBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfQU1ENzRYWCBpcyBub3Qgc2V0
CiMgQ09ORklHX0JMS19ERVZfQVRJSVhQIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9DTUQ2
NFggaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1RSSUZMRVggaXMgbm90IHNldAojIENPTkZJ
R19CTEtfREVWX0NTNTUyMCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfQ1M1NTMwIGlzIG5v
dCBzZXQKIyBDT05GSUdfQkxLX0RFVl9IUFQzNjYgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVW
X0pNSUNST04gaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1NDMTIwMCBpcyBub3Qgc2V0CiMg
Q09ORklHX0JMS19ERVZfUElJWCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfSVQ4MTcyIGlz
IG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9JVDgyMTMgaXMgbm90IHNldAojIENPTkZJR19CTEtf
REVWX0lUODIxWCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfTlM4NzQxNSBpcyBub3Qgc2V0
CiMgQ09ORklHX0JMS19ERVZfUERDMjAyWFhfT0xEIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RF
Vl9QREMyMDJYWF9ORVcgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1NWV0tTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQkxLX0RFVl9TSUlNQUdFIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9T
SVM1NTEzIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9TTEM5MEU2NiBpcyBub3Qgc2V0CiMg
Q09ORklHX0JMS19ERVZfVFJNMjkwIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9WSUE4MkNY
WFggaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1RDODZDMDAxIGlzIG5vdCBzZXQKIyBDT05G
SUdfQkxLX0RFVl9JREVETUEgaXMgbm90IHNldAoKIwojIFNDU0kgZGV2aWNlIHN1cHBvcnQKIwpD
T05GSUdfU0NTSV9NT0Q9eQojIENPTkZJR19SQUlEX0FUVFJTIGlzIG5vdCBzZXQKQ09ORklHX1ND
U0k9eQpDT05GSUdfU0NTSV9ETUE9eQojIENPTkZJR19TQ1NJX1RHVCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NDU0lfTkVUTElOSyBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX1BST0NfRlM9eQoKIwojIFND
U0kgc3VwcG9ydCB0eXBlIChkaXNrLCB0YXBlLCBDRC1ST00pCiMKQ09ORklHX0JMS19ERVZfU0Q9
eQojIENPTkZJR19DSFJfREVWX1NUIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0hSX0RFVl9PU1NUIGlz
IG5vdCBzZXQKQ09ORklHX0JMS19ERVZfU1I9eQpDT05GSUdfQkxLX0RFVl9TUl9WRU5ET1I9eQpD
T05GSUdfQ0hSX0RFVl9TRz15CiMgQ09ORklHX0NIUl9ERVZfU0NIIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0NTSV9NVUxUSV9MVU4gaXMgbm90IHNldApDT05GSUdfU0NTSV9DT05TVEFOVFM9eQojIENP
TkZJR19TQ1NJX0xPR0dJTkcgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1NDQU5fQVNZTkMgaXMg
bm90IHNldApDT05GSUdfU0NTSV9XQUlUX1NDQU49bQoKIwojIFNDU0kgVHJhbnNwb3J0cwojCkNP
TkZJR19TQ1NJX1NQSV9BVFRSUz15CiMgQ09ORklHX1NDU0lfRkNfQVRUUlMgaXMgbm90IHNldAoj
IENPTkZJR19TQ1NJX0lTQ1NJX0FUVFJTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9TQVNfQVRU
UlMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1NBU19MSUJTQVMgaXMgbm90IHNldAojIENPTkZJ
R19TQ1NJX1NSUF9BVFRSUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfTE9XTEVWRUwgaXMgbm90
IHNldAojIENPTkZJR19TQ1NJX0xPV0xFVkVMX1BDTUNJQSBpcyBub3Qgc2V0CiMgQ09ORklHX1ND
U0lfREggaXMgbm90IHNldAojIENPTkZJR19TQ1NJX09TRF9JTklUSUFUT1IgaXMgbm90IHNldApD
T05GSUdfQVRBPXkKIyBDT05GSUdfQVRBX05PTlNUQU5EQVJEIGlzIG5vdCBzZXQKQ09ORklHX0FU
QV9WRVJCT1NFX0VSUk9SPXkKQ09ORklHX0FUQV9BQ1BJPXkKQ09ORklHX1NBVEFfUE1QPXkKQ09O
RklHX1NBVEFfQUhDST15CiMgQ09ORklHX1NBVEFfU0lMMjQgaXMgbm90IHNldApDT05GSUdfQVRB
X1NGRj15CiMgQ09ORklHX1NBVEFfU1ZXIGlzIG5vdCBzZXQKQ09ORklHX0FUQV9QSUlYPXkKIyBD
T05GSUdfU0FUQV9NViBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfTlYgaXMgbm90IHNldAojIENP
TkZJR19QRENfQURNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfUVNUT1IgaXMgbm90IHNldAoj
IENPTkZJR19TQVRBX1BST01JU0UgaXMgbm90IHNldAojIENPTkZJR19TQVRBX1NYNCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NBVEFfU0lMIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9TSVMgaXMgbm90
IHNldAojIENPTkZJR19TQVRBX1VMSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfVklBIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0FUQV9WSVRFU1NFIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9JTklD
MTYyWCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQUNQSSBpcyBub3Qgc2V0CiMgQ09ORklHX1BB
VEFfQUxJIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9BTUQgaXMgbm90IHNldAojIENPTkZJR19Q
QVRBX0FSVE9QIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9BVFA4NjdYIGlzIG5vdCBzZXQKIyBD
T05GSUdfUEFUQV9BVElJWFAgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0NNRDY0MF9QQ0kgaXMg
bm90IHNldAojIENPTkZJR19QQVRBX0NNRDY0WCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQ1M1
NTIwIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9DUzU1MzAgaXMgbm90IHNldAojIENPTkZJR19Q
QVRBX0NZUFJFU1MgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0VGQVIgaXMgbm90IHNldApDT05G
SUdfQVRBX0dFTkVSSUM9eQojIENPTkZJR19QQVRBX0hQVDM2NiBpcyBub3Qgc2V0CiMgQ09ORklH
X1BBVEFfSFBUMzdYIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9IUFQzWDJOIGlzIG5vdCBzZXQK
IyBDT05GSUdfUEFUQV9IUFQzWDMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0lUODIxWCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BBVEFfSVQ4MjEzIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9KTUlD
Uk9OIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9MRUdBQ1kgaXMgbm90IHNldAojIENPTkZJR19Q
QVRBX1RSSUZMRVggaXMgbm90IHNldAojIENPTkZJR19QQVRBX01BUlZFTEwgaXMgbm90IHNldAoj
IENPTkZJR19QQVRBX01QSUlYIGlzIG5vdCBzZXQKQ09ORklHX1BBVEFfT0xEUElJWD15CiMgQ09O
RklHX1BBVEFfTkVUQ0VMTCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfTklOSkEzMiBpcyBub3Qg
c2V0CiMgQ09ORklHX1BBVEFfTlM4NzQxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfTlM4NzQx
NSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfT1BUSSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFf
T1BUSURNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfUENNQ0lBIGlzIG5vdCBzZXQKIyBDT05G
SUdfUEFUQV9QREMyMDI3WCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfUERDX09MRCBpcyBub3Qg
c2V0CiMgQ09ORklHX1BBVEFfUkFESVNZUyBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfUkRDIGlz
IG5vdCBzZXQKIyBDT05GSUdfUEFUQV9SWjEwMDAgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1ND
MTIwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfU0VSVkVSV09SS1MgaXMgbm90IHNldAojIENP
TkZJR19QQVRBX1NJTDY4MCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfU0lTIGlzIG5vdCBzZXQK
IyBDT05GSUdfUEFUQV9UT1NISUJBIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9WSUEgaXMgbm90
IHNldAojIENPTkZJR19QQVRBX1dJTkJPTkQgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1BMQVRG
T1JNIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9TQ0ggaXMgbm90IHNldApDT05GSUdfTUQ9eQpD
T05GSUdfQkxLX0RFVl9NRD15CkNPTkZJR19NRF9BVVRPREVURUNUPXkKIyBDT05GSUdfTURfTElO
RUFSIGlzIG5vdCBzZXQKQ09ORklHX01EX1JBSUQwPXkKQ09ORklHX01EX1JBSUQxPXkKIyBDT05G
SUdfTURfUkFJRDEwIGlzIG5vdCBzZXQKIyBDT05GSUdfTURfUkFJRDQ1NiBpcyBub3Qgc2V0CiMg
Q09ORklHX01EX01VTFRJUEFUSCBpcyBub3Qgc2V0CiMgQ09ORklHX01EX0ZBVUxUWSBpcyBub3Qg
c2V0CkNPTkZJR19CTEtfREVWX0RNPXkKIyBDT05GSUdfRE1fREVCVUcgaXMgbm90IHNldAojIENP
TkZJR19ETV9DUllQVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RNX1NOQVBTSE9UIGlzIG5vdCBzZXQK
IyBDT05GSUdfRE1fTUlSUk9SIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1fWkVSTyBpcyBub3Qgc2V0
CiMgQ09ORklHX0RNX01VTFRJUEFUSCBpcyBub3Qgc2V0CiMgQ09ORklHX0RNX0RFTEFZIGlzIG5v
dCBzZXQKIyBDT05GSUdfRE1fVUVWRU5UIGlzIG5vdCBzZXQKIyBDT05GSUdfRlVTSU9OIGlzIG5v
dCBzZXQKCiMKIyBJRUVFIDEzOTQgKEZpcmVXaXJlKSBzdXBwb3J0CiMKCiMKIyBZb3UgY2FuIGVu
YWJsZSBvbmUgb3IgYm90aCBGaXJlV2lyZSBkcml2ZXIgc3RhY2tzLgojCgojCiMgVGhlIG5ld2Vy
IHN0YWNrIGlzIHJlY29tbWVuZGVkLgojCiMgQ09ORklHX0ZJUkVXSVJFIGlzIG5vdCBzZXQKIyBD
T05GSUdfSUVFRTEzOTQgaXMgbm90IHNldAojIENPTkZJR19JMk8gaXMgbm90IHNldAojIENPTkZJ
R19NQUNJTlRPU0hfRFJJVkVSUyBpcyBub3Qgc2V0CkNPTkZJR19ORVRERVZJQ0VTPXkKIyBDT05G
SUdfRFVNTVkgaXMgbm90IHNldAojIENPTkZJR19CT05ESU5HIGlzIG5vdCBzZXQKIyBDT05GSUdf
TUFDVkxBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0VRVUFMSVpFUiBpcyBub3Qgc2V0CiMgQ09ORklH
X1RVTiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZFVEggaXMgbm90IHNldAojIENPTkZJR19ORVRfU0Ix
MDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDTkVUIGlzIG5vdCBzZXQKQ09ORklHX1BIWUxJQj15
CgojCiMgTUlJIFBIWSBkZXZpY2UgZHJpdmVycwojCkNPTkZJR19NQVJWRUxMX1BIWT1tCiMgQ09O
RklHX0RBVklDT01fUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfUVNFTUlfUEhZIGlzIG5vdCBzZXQK
Q09ORklHX0xYVF9QSFk9bQojIENPTkZJR19DSUNBREFfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdf
VklURVNTRV9QSFkgaXMgbm90IHNldAojIENPTkZJR19TTVNDX1BIWSBpcyBub3Qgc2V0CiMgQ09O
RklHX0JST0FEQ09NX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX0lDUExVU19QSFkgaXMgbm90IHNl
dApDT05GSUdfUkVBTFRFS19QSFk9bQojIENPTkZJR19OQVRJT05BTF9QSFkgaXMgbm90IHNldAoj
IENPTkZJR19TVEUxMFhQIGlzIG5vdCBzZXQKIyBDT05GSUdfTFNJX0VUMTAxMUNfUEhZIGlzIG5v
dCBzZXQKIyBDT05GSUdfTUlDUkVMX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZJWEVEX1BIWSBp
cyBub3Qgc2V0CkNPTkZJR19NRElPX0JJVEJBTkc9bQpDT05GSUdfTkVUX0VUSEVSTkVUPXkKQ09O
RklHX01JST15CiMgQ09ORklHX0hBUFBZTUVBTCBpcyBub3Qgc2V0CiMgQ09ORklHX1NVTkdFTSBp
cyBub3Qgc2V0CiMgQ09ORklHX0NBU1NJTkkgaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl8z
Q09NPXkKQ09ORklHX1ZPUlRFWD1tCkNPTkZJR19UWVBIT09OPW0KIyBDT05GSUdfRVRIT0MgaXMg
bm90IHNldAojIENPTkZJR19ETkVUIGlzIG5vdCBzZXQKQ09ORklHX05FVF9UVUxJUD15CiMgQ09O
RklHX0RFMjEwNFggaXMgbm90IHNldAojIENPTkZJR19UVUxJUCBpcyBub3Qgc2V0CiMgQ09ORklH
X0RFNFg1IGlzIG5vdCBzZXQKIyBDT05GSUdfV0lOQk9ORF84NDAgaXMgbm90IHNldAojIENPTkZJ
R19ETTkxMDIgaXMgbm90IHNldAojIENPTkZJR19VTEk1MjZYIGlzIG5vdCBzZXQKIyBDT05GSUdf
UENNQ0lBX1hJUkNPTSBpcyBub3Qgc2V0CiMgQ09ORklHX0hQMTAwIGlzIG5vdCBzZXQKIyBDT05G
SUdfSUJNX05FV19FTUFDX1pNSUkgaXMgbm90IHNldAojIENPTkZJR19JQk1fTkVXX0VNQUNfUkdN
SUkgaXMgbm90IHNldAojIENPTkZJR19JQk1fTkVXX0VNQUNfVEFIIGlzIG5vdCBzZXQKIyBDT05G
SUdfSUJNX05FV19FTUFDX0VNQUM0IGlzIG5vdCBzZXQKIyBDT05GSUdfSUJNX05FV19FTUFDX05P
X0ZMT1dfQ1RSTCBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTV9ORVdfRU1BQ19NQUxfQ0xSX0lDSU5U
U1RBVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTV9ORVdfRU1BQ19NQUxfQ09NTU9OX0VSUiBpcyBu
b3Qgc2V0CkNPTkZJR19ORVRfUENJPXkKIyBDT05GSUdfUENORVQzMiBpcyBub3Qgc2V0CiMgQ09O
RklHX0FNRDgxMTFfRVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfQURBUFRFQ19TVEFSRklSRSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0tTWjg4NFhfUENJIGlzIG5vdCBzZXQKIyBDT05GSUdfQjQ0IGlzIG5v
dCBzZXQKIyBDT05GSUdfRk9SQ0VERVRIIGlzIG5vdCBzZXQKQ09ORklHX0UxMDA9bQojIENPTkZJ
R19GRUFMTlggaXMgbm90IHNldAojIENPTkZJR19OQVRTRU1JIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkUyS19QQ0kgaXMgbm90IHNldAojIENPTkZJR184MTM5Q1AgaXMgbm90IHNldApDT05GSUdfODEz
OVRPTz1tCkNPTkZJR184MTM5VE9PX1BJTz15CiMgQ09ORklHXzgxMzlUT09fVFVORV9UV0lTVEVS
IGlzIG5vdCBzZXQKIyBDT05GSUdfODEzOVRPT184MTI5IGlzIG5vdCBzZXQKIyBDT05GSUdfODEz
OV9PTERfUlhfUkVTRVQgaXMgbm90IHNldAojIENPTkZJR19SNjA0MCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NJUzkwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0VQSUMxMDAgaXMgbm90IHNldAojIENPTkZJ
R19TTVNDOTQyMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NVTkRBTkNFIGlzIG5vdCBzZXQKIyBDT05G
SUdfVExBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0tTODg0MiBpcyBub3Qgc2V0CiMgQ09ORklHX0tT
ODg1MV9NTEwgaXMgbm90IHNldAojIENPTkZJR19WSUFfUkhJTkUgaXMgbm90IHNldAojIENPTkZJ
R19TQzkyMDMxIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1BPQ0tFVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0FUTDIgaXMgbm90IHNldApDT05GSUdfTkVUREVWXzEwMDA9eQojIENPTkZJR19BQ0VOSUMg
aXMgbm90IHNldAojIENPTkZJR19ETDJLIGlzIG5vdCBzZXQKQ09ORklHX0UxMDAwPW0KQ09ORklH
X0UxMDAwRT1tCiMgQ09ORklHX0lQMTAwMCBpcyBub3Qgc2V0CkNPTkZJR19JR0I9bQpDT05GSUdf
SUdCVkY9bQojIENPTkZJR19OUzgzODIwIGlzIG5vdCBzZXQKIyBDT05GSUdfSEFNQUNISSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1lFTExPV0ZJTiBpcyBub3Qgc2V0CiMgQ09ORklHX1I4MTY5IGlzIG5v
dCBzZXQKIyBDT05GSUdfU0lTMTkwIGlzIG5vdCBzZXQKQ09ORklHX1NLR0U9bQojIENPTkZJR19T
S0dFX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1NLWTI9bQojIENPTkZJR19TS1kyX0RFQlVHIGlz
IG5vdCBzZXQKIyBDT05GSUdfVklBX1ZFTE9DSVRZIGlzIG5vdCBzZXQKIyBDT05GSUdfVElHT04z
IGlzIG5vdCBzZXQKIyBDT05GSUdfQk5YMiBpcyBub3Qgc2V0CiMgQ09ORklHX0NOSUMgaXMgbm90
IHNldAojIENPTkZJR19RTEEzWFhYIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRMMSBpcyBub3Qgc2V0
CiMgQ09ORklHX0FUTDFFIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRMMUMgaXMgbm90IHNldAojIENP
TkZJR19KTUUgaXMgbm90IHNldAojIENPTkZJR19ORVRERVZfMTAwMDAgaXMgbm90IHNldAojIENP
TkZJR19UUiBpcyBub3Qgc2V0CiMgQ09ORklHX1dMQU4gaXMgbm90IHNldAoKIwojIEVuYWJsZSBX
aU1BWCAoTmV0d29ya2luZyBvcHRpb25zKSB0byBzZWUgdGhlIFdpTUFYIGRyaXZlcnMKIwoKIwoj
IFVTQiBOZXR3b3JrIEFkYXB0ZXJzCiMKIyBDT05GSUdfVVNCX0NBVEMgaXMgbm90IHNldAojIENP
TkZJR19VU0JfS0FXRVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1BFR0FTVVMgaXMgbm90IHNl
dAojIENPTkZJR19VU0JfUlRMODE1MCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9VU0JORVQgaXMg
bm90IHNldAojIENPTkZJR19VU0JfSVBIRVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1BDTUNJ
QSBpcyBub3Qgc2V0CiMgQ09ORklHX1dBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZEREkgaXMgbm90
IHNldAojIENPTkZJR19ISVBQSSBpcyBub3Qgc2V0CiMgQ09ORklHX1BMSVAgaXMgbm90IHNldAoj
IENPTkZJR19QUFAgaXMgbm90IHNldAojIENPTkZJR19TTElQIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkVUX0ZDIGlzIG5vdCBzZXQKQ09ORklHX05FVENPTlNPTEU9eQojIENPTkZJR19ORVRDT05TT0xF
X0RZTkFNSUMgaXMgbm90IHNldApDT05GSUdfTkVUUE9MTD15CiMgQ09ORklHX05FVFBPTExfVFJB
UCBpcyBub3Qgc2V0CkNPTkZJR19ORVRfUE9MTF9DT05UUk9MTEVSPXkKQ09ORklHX1ZNWE5FVDM9
bQojIENPTkZJR19JU0ROIGlzIG5vdCBzZXQKIyBDT05GSUdfUEhPTkUgaXMgbm90IHNldAoKIwoj
IElucHV0IGRldmljZSBzdXBwb3J0CiMKQ09ORklHX0lOUFVUPXkKQ09ORklHX0lOUFVUX0ZGX01F
TUxFU1M9eQpDT05GSUdfSU5QVVRfUE9MTERFVj15CiMgQ09ORklHX0lOUFVUX1NQQVJTRUtNQVAg
aXMgbm90IHNldAoKIwojIFVzZXJsYW5kIGludGVyZmFjZXMKIwpDT05GSUdfSU5QVVRfTU9VU0VE
RVY9eQojIENPTkZJR19JTlBVVF9NT1VTRURFVl9QU0FVWCBpcyBub3Qgc2V0CkNPTkZJR19JTlBV
VF9NT1VTRURFVl9TQ1JFRU5fWD0xMDI0CkNPTkZJR19JTlBVVF9NT1VTRURFVl9TQ1JFRU5fWT03
NjgKIyBDT05GSUdfSU5QVVRfSk9ZREVWIGlzIG5vdCBzZXQKQ09ORklHX0lOUFVUX0VWREVWPXkK
IyBDT05GSUdfSU5QVVRfRVZCVUcgaXMgbm90IHNldAoKIwojIElucHV0IERldmljZSBEcml2ZXJz
CiMKQ09ORklHX0lOUFVUX0tFWUJPQVJEPXkKIyBDT05GSUdfS0VZQk9BUkRfQURQNTU4OCBpcyBu
b3Qgc2V0CkNPTkZJR19LRVlCT0FSRF9BVEtCRD15CiMgQ09ORklHX1FUMjE2MCBpcyBub3Qgc2V0
CiMgQ09ORklHX0tFWUJPQVJEX0xLS0JEIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTE04
MzIzIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTUFYNzM1OSBpcyBub3Qgc2V0CiMgQ09O
RklHX0tFWUJPQVJEX05FV1RPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX09QRU5DT1JF
UyBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1NUT1dBV0FZIGlzIG5vdCBzZXQKIyBDT05G
SUdfS0VZQk9BUkRfU1VOS0JEIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfWFRLQkQgaXMg
bm90IHNldApDT05GSUdfSU5QVVRfTU9VU0U9eQpDT05GSUdfTU9VU0VfUFMyPXkKQ09ORklHX01P
VVNFX1BTMl9BTFBTPXkKQ09ORklHX01PVVNFX1BTMl9MT0dJUFMyUFA9eQpDT05GSUdfTU9VU0Vf
UFMyX1NZTkFQVElDUz15CkNPTkZJR19NT1VTRV9QUzJfTElGRUJPT0s9eQpDT05GSUdfTU9VU0Vf
UFMyX1RSQUNLUE9JTlQ9eQojIENPTkZJR19NT1VTRV9QUzJfRUxBTlRFQ0ggaXMgbm90IHNldAoj
IENPTkZJR19NT1VTRV9QUzJfU0VOVEVMSUMgaXMgbm90IHNldAojIENPTkZJR19NT1VTRV9QUzJf
VE9VQ0hLSVQgaXMgbm90IHNldAojIENPTkZJR19NT1VTRV9TRVJJQUwgaXMgbm90IHNldAojIENP
TkZJR19NT1VTRV9BUFBMRVRPVUNIIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9VU0VfQkNNNTk3NCBp
cyBub3Qgc2V0CiMgQ09ORklHX01PVVNFX1ZTWFhYQUEgaXMgbm90IHNldAojIENPTkZJR19NT1VT
RV9TWU5BUFRJQ1NfSTJDIGlzIG5vdCBzZXQKQ09ORklHX0lOUFVUX0pPWVNUSUNLPXkKIyBDT05G
SUdfSk9ZU1RJQ0tfQU5BTE9HIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfQTNEIGlzIG5v
dCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfQURJIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tf
Q09CUkEgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19HRjJLIGlzIG5vdCBzZXQKIyBDT05G
SUdfSk9ZU1RJQ0tfR1JJUCBpcyBub3Qgc2V0CiMgQ09ORklHX0pPWVNUSUNLX0dSSVBfTVAgaXMg
bm90IHNldAojIENPTkZJR19KT1lTVElDS19HVUlMTEVNT1QgaXMgbm90IHNldAojIENPTkZJR19K
T1lTVElDS19JTlRFUkFDVCBpcyBub3Qgc2V0CiMgQ09ORklHX0pPWVNUSUNLX1NJREVXSU5ERVIg
aXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19UTURDIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9Z
U1RJQ0tfSUZPUkNFIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfV0FSUklPUiBpcyBub3Qg
c2V0CiMgQ09ORklHX0pPWVNUSUNLX01BR0VMTEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJ
Q0tfU1BBQ0VPUkIgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19TUEFDRUJBTEwgaXMgbm90
IHNldAojIENPTkZJR19KT1lTVElDS19TVElOR0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJ
Q0tfVFdJREpPWSBpcyBub3Qgc2V0CiMgQ09ORklHX0pPWVNUSUNLX1pIRU5IVUEgaXMgbm90IHNl
dAojIENPTkZJR19KT1lTVElDS19EQjkgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19HQU1F
Q09OIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfVFVSQk9HUkFGWCBpcyBub3Qgc2V0CiMg
Q09ORklHX0pPWVNUSUNLX0pPWURVTVAgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19YUEFE
IGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfV0FMS0VSQTA3MDEgaXMgbm90IHNldApDT05G
SUdfSU5QVVRfVEFCTEVUPXkKIyBDT05GSUdfVEFCTEVUX1VTQl9BQ0VDQUQgaXMgbm90IHNldAoj
IENPTkZJR19UQUJMRVRfVVNCX0FJUFRFSyBpcyBub3Qgc2V0CiMgQ09ORklHX1RBQkxFVF9VU0Jf
R1RDTyBpcyBub3Qgc2V0CiMgQ09ORklHX1RBQkxFVF9VU0JfS0JUQUIgaXMgbm90IHNldAojIENP
TkZJR19UQUJMRVRfVVNCX1dBQ09NIGlzIG5vdCBzZXQKQ09ORklHX0lOUFVUX1RPVUNIU0NSRUVO
PXkKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fQUQ3ODc5X0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1RP
VUNIU0NSRUVOX0FENzg3OSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0RZTkFQUk8g
aXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9FRVRJIGlzIG5vdCBzZXQKIyBDT05GSUdf
VE9VQ0hTQ1JFRU5fRlVKSVRTVSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0dVTlpF
IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fRUxPIGlzIG5vdCBzZXQKIyBDT05GSUdf
VE9VQ0hTQ1JFRU5fV0FDT01fVzgwMDEgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9N
Q1M1MDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fTVRPVUNIIGlzIG5vdCBzZXQK
IyBDT05GSUdfVE9VQ0hTQ1JFRU5fSU5FWElPIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JF
RU5fTUs3MTIgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9QRU5NT1VOVCBpcyBub3Qg
c2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1RPVUNIUklHSFQgaXMgbm90IHNldAojIENPTkZJR19U
T1VDSFNDUkVFTl9UT1VDSFdJTiBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1VTQl9D
T01QT1NJVEUgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9UT1VDSElUMjEzIGlzIG5v
dCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVFNDMjAwNyBpcyBub3Qgc2V0CkNPTkZJR19JTlBV
VF9NSVNDPXkKIyBDT05GSUdfSU5QVVRfUENTUEtSIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRf
QVBBTkVMIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfQVRMQVNfQlROUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0lOUFVUX0FUSV9SRU1PVEUgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9BVElfUkVN
T1RFMiBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0tFWVNQQU5fUkVNT1RFIGlzIG5vdCBzZXQK
IyBDT05GSUdfSU5QVVRfUE9XRVJNQVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfWUVBTElO
SyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0NNMTA5IGlzIG5vdCBzZXQKIyBDT05GSUdfSU5Q
VVRfVUlOUFVUIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfV0lOQk9ORF9DSVIgaXMgbm90IHNl
dAoKIwojIEhhcmR3YXJlIEkvTyBwb3J0cwojCkNPTkZJR19TRVJJTz15CkNPTkZJR19TRVJJT19J
ODA0Mj15CkNPTkZJR19TRVJJT19TRVJQT1JUPXkKIyBDT05GSUdfU0VSSU9fQ1Q4MkM3MTAgaXMg
bm90IHNldAojIENPTkZJR19TRVJJT19QQVJLQkQgaXMgbm90IHNldAojIENPTkZJR19TRVJJT19Q
Q0lQUzIgaXMgbm90IHNldApDT05GSUdfU0VSSU9fTElCUFMyPXkKIyBDT05GSUdfU0VSSU9fUkFX
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSU9fQUxURVJBX1BTMiBpcyBub3Qgc2V0CiMgQ09ORklH
X0dBTUVQT1JUIGlzIG5vdCBzZXQKCiMKIyBDaGFyYWN0ZXIgZGV2aWNlcwojCkNPTkZJR19WVD15
CkNPTkZJR19DT05TT0xFX1RSQU5TTEFUSU9OUz15CkNPTkZJR19WVF9DT05TT0xFPXkKQ09ORklH
X0hXX0NPTlNPTEU9eQpDT05GSUdfVlRfSFdfQ09OU09MRV9CSU5ESU5HPXkKQ09ORklHX0RFVktN
RU09eQpDT05GSUdfU0VSSUFMX05PTlNUQU5EQVJEPXkKIyBDT05GSUdfQ09NUFVUT05FIGlzIG5v
dCBzZXQKIyBDT05GSUdfUk9DS0VUUE9SVCBpcyBub3Qgc2V0CiMgQ09ORklHX0NZQ0xBREVTIGlz
IG5vdCBzZXQKIyBDT05GSUdfRElHSUVQQ0EgaXMgbm90IHNldAojIENPTkZJR19NT1hBX0lOVEVM
TElPIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9YQV9TTUFSVElPIGlzIG5vdCBzZXQKIyBDT05GSUdf
SVNJIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lOQ0xJTksgaXMgbm90IHNldAojIENPTkZJR19TWU5D
TElOS01QIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lOQ0xJTktfR1QgaXMgbm90IHNldAojIENPTkZJ
R19OX0hETEMgaXMgbm90IHNldAojIENPTkZJR19SSVNDT004IGlzIG5vdCBzZXQKIyBDT05GSUdf
U1BFQ0lBTElYIGlzIG5vdCBzZXQKIyBDT05GSUdfU1RBTERSViBpcyBub3Qgc2V0CiMgQ09ORklH
X05PWk9NSSBpcyBub3Qgc2V0CgojCiMgU2VyaWFsIGRyaXZlcnMKIwpDT05GSUdfU0VSSUFMXzgy
NTA9eQpDT05GSUdfU0VSSUFMXzgyNTBfQ09OU09MRT15CkNPTkZJR19GSVhfRUFSTFlDT05fTUVN
PXkKQ09ORklHX1NFUklBTF84MjUwX1BDST15CkNPTkZJR19TRVJJQUxfODI1MF9QTlA9eQojIENP
TkZJR19TRVJJQUxfODI1MF9DUyBpcyBub3Qgc2V0CkNPTkZJR19TRVJJQUxfODI1MF9OUl9VQVJU
Uz0zMgpDT05GSUdfU0VSSUFMXzgyNTBfUlVOVElNRV9VQVJUUz00CkNPTkZJR19TRVJJQUxfODI1
MF9FWFRFTkRFRD15CkNPTkZJR19TRVJJQUxfODI1MF9NQU5ZX1BPUlRTPXkKQ09ORklHX1NFUklB
TF84MjUwX1NIQVJFX0lSUT15CkNPTkZJR19TRVJJQUxfODI1MF9ERVRFQ1RfSVJRPXkKQ09ORklH
X1NFUklBTF84MjUwX1JTQT15CgojCiMgTm9uLTgyNTAgc2VyaWFsIHBvcnQgc3VwcG9ydAojCkNP
TkZJR19TRVJJQUxfQ09SRT15CkNPTkZJR19TRVJJQUxfQ09SRV9DT05TT0xFPXkKIyBDT05GSUdf
U0VSSUFMX0pTTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9USU1CRVJEQUxFIGlzIG5vdCBz
ZXQKQ09ORklHX1VOSVg5OF9QVFlTPXkKIyBDT05GSUdfREVWUFRTX01VTFRJUExFX0lOU1RBTkNF
UyBpcyBub3Qgc2V0CiMgQ09ORklHX0xFR0FDWV9QVFlTIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJJ
TlRFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1BQREVWIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBNSV9I
QU5ETEVSIGlzIG5vdCBzZXQKQ09ORklHX0hXX1JBTkRPTT15CiMgQ09ORklHX0hXX1JBTkRPTV9U
SU1FUklPTUVNIGlzIG5vdCBzZXQKIyBDT05GSUdfSFdfUkFORE9NX0lOVEVMIGlzIG5vdCBzZXQK
IyBDT05GSUdfSFdfUkFORE9NX0FNRCBpcyBub3Qgc2V0CkNPTkZJR19IV19SQU5ET01fVklBPXkK
Q09ORklHX05WUkFNPXkKIyBDT05GSUdfUjM5NjQgaXMgbm90IHNldAojIENPTkZJR19BUFBMSUNP
TSBpcyBub3Qgc2V0CgojCiMgUENNQ0lBIGNoYXJhY3RlciBkZXZpY2VzCiMKIyBDT05GSUdfU1lO
Q0xJTktfQ1MgaXMgbm90IHNldAojIENPTkZJR19DQVJETUFOXzQwMDAgaXMgbm90IHNldAojIENP
TkZJR19DQVJETUFOXzQwNDAgaXMgbm90IHNldAojIENPTkZJR19JUFdJUkVMRVNTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTVdBVkUgaXMgbm90IHNldAojIENPTkZJR19QQzg3MzZ4X0dQSU8gaXMgbm90
IHNldAojIENPTkZJR19SQVdfRFJJVkVSIGlzIG5vdCBzZXQKQ09ORklHX0hQRVQ9eQojIENPTkZJ
R19IUEVUX01NQVAgaXMgbm90IHNldAojIENPTkZJR19IQU5HQ0hFQ0tfVElNRVIgaXMgbm90IHNl
dAojIENPTkZJR19UQ0dfVFBNIGlzIG5vdCBzZXQKIyBDT05GSUdfVEVMQ0xPQ0sgaXMgbm90IHNl
dApDT05GSUdfREVWUE9SVD15CkNPTkZJR19JMkM9eQpDT05GSUdfSTJDX0JPQVJESU5GTz15CkNP
TkZJR19JMkNfQ09NUEFUPXkKQ09ORklHX0kyQ19DSEFSREVWPXkKQ09ORklHX0kyQ19IRUxQRVJf
QVVUTz15CkNPTkZJR19JMkNfQUxHT0JJVD1tCgojCiMgSTJDIEhhcmR3YXJlIEJ1cyBzdXBwb3J0
CiMKCiMKIyBQQyBTTUJ1cyBob3N0IGNvbnRyb2xsZXIgZHJpdmVycwojCiMgQ09ORklHX0kyQ19B
TEkxNTM1IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0FMSTE1NjMgaXMgbm90IHNldAojIENPTkZJ
R19JMkNfQUxJMTVYMyBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19BTUQ3NTYgaXMgbm90IHNldAoj
IENPTkZJR19JMkNfQU1EODExMSBpcyBub3Qgc2V0CkNPTkZJR19JMkNfSTgwMT1tCkNPTkZJR19J
MkNfSVNDSD1tCkNPTkZJR19JMkNfUElJWDQ9bQojIENPTkZJR19JMkNfTkZPUkNFMiBpcyBub3Qg
c2V0CiMgQ09ORklHX0kyQ19TSVM1NTk1IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1NJUzYzMCBp
cyBub3Qgc2V0CiMgQ09ORklHX0kyQ19TSVM5NlggaXMgbm90IHNldAojIENPTkZJR19JMkNfVklB
IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1ZJQVBSTyBpcyBub3Qgc2V0CgojCiMgQUNQSSBkcml2
ZXJzCiMKIyBDT05GSUdfSTJDX1NDTUkgaXMgbm90IHNldAoKIwojIEkyQyBzeXN0ZW0gYnVzIGRy
aXZlcnMgKG1vc3RseSBlbWJlZGRlZCAvIHN5c3RlbS1vbi1jaGlwKQojCiMgQ09ORklHX0kyQ19P
Q09SRVMgaXMgbm90IHNldAojIENPTkZJR19JMkNfU0lNVEVDIGlzIG5vdCBzZXQKIyBDT05GSUdf
STJDX1hJTElOWCBpcyBub3Qgc2V0CgojCiMgRXh0ZXJuYWwgSTJDL1NNQnVzIGFkYXB0ZXIgZHJp
dmVycwojCiMgQ09ORklHX0kyQ19QQVJQT1JUIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1BBUlBP
UlRfTElHSFQgaXMgbm90IHNldAojIENPTkZJR19JMkNfVEFPU19FVk0gaXMgbm90IHNldAojIENP
TkZJR19JMkNfVElOWV9VU0IgaXMgbm90IHNldAoKIwojIE90aGVyIEkyQy9TTUJ1cyBidXMgZHJp
dmVycwojCiMgQ09ORklHX0kyQ19QQ0FfUExBVEZPUk0gaXMgbm90IHNldAojIENPTkZJR19JMkNf
U1RVQiBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19ERUJVR19DT1JFIGlzIG5vdCBzZXQKIyBDT05G
SUdfSTJDX0RFQlVHX0FMR08gaXMgbm90IHNldAojIENPTkZJR19JMkNfREVCVUdfQlVTIGlzIG5v
dCBzZXQKIyBDT05GSUdfU1BJIGlzIG5vdCBzZXQKCiMKIyBQUFMgc3VwcG9ydAojCiMgQ09ORklH
X1BQUyBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX1dBTlRfT1BUSU9OQUxfR1BJT0xJQj15CiMgQ09O
RklHX0dQSU9MSUIgaXMgbm90IHNldAojIENPTkZJR19XMSBpcyBub3Qgc2V0CkNPTkZJR19QT1dF
Ul9TVVBQTFk9eQojIENPTkZJR19QT1dFUl9TVVBQTFlfREVCVUcgaXMgbm90IHNldAojIENPTkZJ
R19QREFfUE9XRVIgaXMgbm90IHNldAojIENPTkZJR19CQVRURVJZX0RTMjc2MCBpcyBub3Qgc2V0
CiMgQ09ORklHX0JBVFRFUllfRFMyNzgyIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9CUTI3
eDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9NQVgxNzA0MCBpcyBub3Qgc2V0CkNPTkZJ
R19IV01PTj15CiMgQ09ORklHX0hXTU9OX1ZJRCBpcyBub3Qgc2V0CiMgQ09ORklHX0hXTU9OX0RF
QlVHX0NISVAgaXMgbm90IHNldAoKIwojIE5hdGl2ZSBkcml2ZXJzCiMKIyBDT05GSUdfU0VOU09S
U19BQklUVUdVUlUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FCSVRVR1VSVTMgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX0FENzQxNCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
QUQ3NDE4IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDIxIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19BRE0xMDI1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDI2
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDI5IGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19BRE0xMDMxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE05MjQwIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDExIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19BRFQ3NDYyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDcwIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19BRFQ3NDc1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BU0M3
NjIxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19LOFRFTVAgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX0sxMFRFTVAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FTQjEwMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQVRYUDEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JT
X0RTMTYyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSTVLX0FNQiBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfRjcxODA1RiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRjcxODgy
RkcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0Y3NTM3NVMgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX0ZTQ0hNRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRzc2MEEgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX0dMNTE4U00gaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JT
X0dMNTIwU00gaXMgbm90IHNldApDT05GSUdfU0VOU09SU19DT1JFVEVNUD1tCiMgQ09ORklHX1NF
TlNPUlNfSVQ4NyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE02MyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfTE03MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03NSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03NyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
TE03OCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04MCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfTE04MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04NSBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFTlNPUlNfTE04NyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05MCBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfTE05MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTFRDNDIxNSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfTFRDNDI0NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05NTI0
MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYMTYxOSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfTUFYNjY1MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfUEM4NzM2MCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfUEM4NzQyNyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfUENGODU5MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU0lTNTU5NSBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFTlNPUlNfRE1FMTczNyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU01T
QzQ3TTEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1NNU0M0N00xOTIgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX1NNU0M0N0IzOTcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FE
Uzc4MjggaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FNQzY4MjEgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX1RITUM1MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVE1QNDAxIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19UTVA0MjEgaXMgbm90IHNldAojIENPTkZJR19TRU5T
T1JTX1ZJQV9DUFVURU1QIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19WSUE2ODZBIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19WVDEyMTEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JT
X1ZUODIzMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzgxRCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfVzgzNzkxRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzky
RCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzkzIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19XODNMNzg1VFMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4M0w3ODZORyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNjI3SEYgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX1c4MzYyN0VIRiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSERBUFMgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX0xJUzNfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19BUFBMRVNNQyBpcyBub3Qgc2V0CgojCiMgQUNQSSBkcml2ZXJzCiMKIyBDT05GSUdfU0VOU09S
U19BVEswMTEwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MSVMzTFYwMkQgaXMgbm90IHNl
dApDT05GSUdfVEhFUk1BTD15CkNPTkZJR19USEVSTUFMX0hXTU9OPXkKQ09ORklHX1dBVENIRE9H
PXkKIyBDT05GSUdfV0FUQ0hET0dfTk9XQVlPVVQgaXMgbm90IHNldAoKIwojIFdhdGNoZG9nIERl
dmljZSBEcml2ZXJzCiMKIyBDT05GSUdfU09GVF9XQVRDSERPRyBpcyBub3Qgc2V0CiMgQ09ORklH
X0FDUVVJUkVfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfQURWQU5URUNIX1dEVCBpcyBub3Qgc2V0
CiMgQ09ORklHX0FMSU0xNTM1X1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0FMSU03MTAxX1dEVCBp
cyBub3Qgc2V0CiMgQ09ORklHX1NDNTIwX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NCQ19GSVRQ
QzJfV0FUQ0hET0cgaXMgbm90IHNldAojIENPTkZJR19FVVJPVEVDSF9XRFQgaXMgbm90IHNldAoj
IENPTkZJR19JQjcwMF9XRFQgaXMgbm90IHNldAojIENPTkZJR19JQk1BU1IgaXMgbm90IHNldAoj
IENPTkZJR19XQUZFUl9XRFQgaXMgbm90IHNldAojIENPTkZJR19JNjMwMEVTQl9XRFQgaXMgbm90
IHNldAojIENPTkZJR19JVENPX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lUODcxMkZfV0RUIGlz
IG5vdCBzZXQKIyBDT05GSUdfSVQ4N19XRFQgaXMgbm90IHNldAojIENPTkZJR19IUF9XQVRDSERP
RyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDMTIwMF9XRFQgaXMgbm90IHNldAojIENPTkZJR19QQzg3
NDEzX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHXzYwWFhfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0JDODM2MF9XRFQgaXMgbm90IHNldAojIENPTkZJR19DUFU1X1dEVCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NNU0NfU0NIMzExWF9XRFQgaXMgbm90IHNldAojIENPTkZJR19TTVNDMzdCNzg3X1dEVCBp
cyBub3Qgc2V0CiMgQ09ORklHX1c4MzYyN0hGX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1c4MzY5
N0hGX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1c4MzY5N1VHX1dEVCBpcyBub3Qgc2V0CiMgQ09O
RklHX1c4Mzg3N0ZfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfVzgzOTc3Rl9XRFQgaXMgbm90IHNl
dAojIENPTkZJR19NQUNIWl9XRFQgaXMgbm90IHNldAojIENPTkZJR19TQkNfRVBYX0MzX1dBVENI
RE9HIGlzIG5vdCBzZXQKCiMKIyBQQ0ktYmFzZWQgV2F0Y2hkb2cgQ2FyZHMKIwojIENPTkZJR19Q
Q0lQQ1dBVENIRE9HIGlzIG5vdCBzZXQKIyBDT05GSUdfV0RUUENJIGlzIG5vdCBzZXQKCiMKIyBV
U0ItYmFzZWQgV2F0Y2hkb2cgQ2FyZHMKIwojIENPTkZJR19VU0JQQ1dBVENIRE9HIGlzIG5vdCBz
ZXQKQ09ORklHX1NTQl9QT1NTSUJMRT15CgojCiMgU29uaWNzIFNpbGljb24gQmFja3BsYW5lCiMK
IyBDT05GSUdfU1NCIGlzIG5vdCBzZXQKCiMKIyBNdWx0aWZ1bmN0aW9uIGRldmljZSBkcml2ZXJz
CiMKQ09ORklHX01GRF9DT1JFPW0KIyBDT05GSUdfTUZEXzg4UE04NjBYIGlzIG5vdCBzZXQKIyBD
T05GSUdfTUZEX1NNNTAxIGlzIG5vdCBzZXQKIyBDT05GSUdfSFRDX1BBU0lDMyBpcyBub3Qgc2V0
CiMgQ09ORklHX1RXTDQwMzBfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9UTUlPIGlzIG5v
dCBzZXQKIyBDT05GSUdfUE1JQ19EQTkwM1ggaXMgbm90IHNldAojIENPTkZJR19QTUlDX0FEUDU1
MjAgaXMgbm90IHNldAojIENPTkZJR19NRkRfTUFYODkyNSBpcyBub3Qgc2V0CiMgQ09ORklHX01G
RF9XTTg0MDAgaXMgbm90IHNldAojIENPTkZJR19NRkRfV004MzFYIGlzIG5vdCBzZXQKIyBDT05G
SUdfTUZEX1dNODM1MF9JMkMgaXMgbm90IHNldAojIENPTkZJR19NRkRfV004OTk0IGlzIG5vdCBz
ZXQKIyBDT05GSUdfTUZEX1BDRjUwNjMzIGlzIG5vdCBzZXQKIyBDT05GSUdfQUIzMTAwX0NPUkUg
aXMgbm90IHNldApDT05GSUdfTFBDX1NDSD1tCiMgQ09ORklHX1JFR1VMQVRPUiBpcyBub3Qgc2V0
CiMgQ09ORklHX01FRElBX1NVUFBPUlQgaXMgbm90IHNldAoKIwojIEdyYXBoaWNzIHN1cHBvcnQK
IwpDT05GSUdfQUdQPW0KQ09ORklHX0FHUF9BTUQ2ND1tCkNPTkZJR19BR1BfSU5URUw9bQojIENP
TkZJR19BR1BfU0lTIGlzIG5vdCBzZXQKIyBDT05GSUdfQUdQX1ZJQSBpcyBub3Qgc2V0CiMgQ09O
RklHX1ZHQV9BUkIgaXMgbm90IHNldAojIENPTkZJR19WR0FfU1dJVENIRVJPTyBpcyBub3Qgc2V0
CkNPTkZJR19EUk09bQpDT05GSUdfRFJNX0tNU19IRUxQRVI9bQpDT05GSUdfRFJNX1RUTT1tCiMg
Q09ORklHX0RSTV9UREZYIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1IxMjggaXMgbm90IHNldApD
T05GSUdfRFJNX1JBREVPTj1tCkNPTkZJR19EUk1fUkFERU9OX0tNUz15CiMgQ09ORklHX0RSTV9J
ODEwIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX0k4MzAgaXMgbm90IHNldApDT05GSUdfRFJNX0k5
MTU9bQpDT05GSUdfRFJNX0k5MTVfS01TPXkKIyBDT05GSUdfRFJNX01HQSBpcyBub3Qgc2V0CiMg
Q09ORklHX0RSTV9TSVMgaXMgbm90IHNldAojIENPTkZJR19EUk1fVklBIGlzIG5vdCBzZXQKIyBD
T05GSUdfRFJNX1NBVkFHRSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZHQVNUQVRFIGlzIG5vdCBzZXQK
Q09ORklHX1ZJREVPX09VVFBVVF9DT05UUk9MPW0KQ09ORklHX0ZCPXkKQ09ORklHX0ZJUk1XQVJF
X0VESUQ9eQojIENPTkZJR19GQl9EREMgaXMgbm90IHNldAojIENPTkZJR19GQl9CT09UX1ZFU0Ff
U1VQUE9SVCBpcyBub3Qgc2V0CkNPTkZJR19GQl9DRkJfRklMTFJFQ1Q9bQpDT05GSUdfRkJfQ0ZC
X0NPUFlBUkVBPW0KQ09ORklHX0ZCX0NGQl9JTUFHRUJMSVQ9bQojIENPTkZJR19GQl9DRkJfUkVW
X1BJWEVMU19JTl9CWVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU1lTX0ZJTExSRUNUIGlzIG5v
dCBzZXQKIyBDT05GSUdfRkJfU1lTX0NPUFlBUkVBIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU1lT
X0lNQUdFQkxJVCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0ZPUkVJR05fRU5ESUFOIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRkJfU1lTX0ZPUFMgaXMgbm90IHNldAojIENPTkZJR19GQl9TVkdBTElCIGlz
IG5vdCBzZXQKIyBDT05GSUdfRkJfTUFDTU9ERVMgaXMgbm90IHNldAojIENPTkZJR19GQl9CQUNL
TElHSFQgaXMgbm90IHNldAojIENPTkZJR19GQl9NT0RFX0hFTFBFUlMgaXMgbm90IHNldAojIENP
TkZJR19GQl9USUxFQkxJVFRJTkcgaXMgbm90IHNldAoKIwojIEZyYW1lIGJ1ZmZlciBoYXJkd2Fy
ZSBkcml2ZXJzCiMKIyBDT05GSUdfRkJfQ0lSUlVTIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUE0y
IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQ1lCRVIyMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJf
QVJDIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQVNJTElBTlQgaXMgbm90IHNldAojIENPTkZJR19G
Ql9JTVNUVCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1ZHQTE2IGlzIG5vdCBzZXQKIyBDT05GSUdf
RkJfVVZFU0EgaXMgbm90IHNldAojIENPTkZJR19GQl9WRVNBIGlzIG5vdCBzZXQKIyBDT05GSUdf
RkJfRUZJIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfTjQxMSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZC
X0hHQSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1MxRDEzWFhYIGlzIG5vdCBzZXQKIyBDT05GSUdf
RkJfTlZJRElBIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUklWQSBpcyBub3Qgc2V0CiMgQ09ORklH
X0ZCX0xFODA1NzggaXMgbm90IHNldAojIENPTkZJR19GQl9JTlRFTCBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZCX01BVFJPWCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1JBREVPTiBpcyBub3Qgc2V0CiMg
Q09ORklHX0ZCX0FUWTEyOCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0FUWSBpcyBub3Qgc2V0CiMg
Q09ORklHX0ZCX1MzIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU0FWQUdFIGlzIG5vdCBzZXQKIyBD
T05GSUdfRkJfU0lTIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfVklBIGlzIG5vdCBzZXQKIyBDT05G
SUdfRkJfTkVPTUFHSUMgaXMgbm90IHNldAojIENPTkZJR19GQl9LWVJPIGlzIG5vdCBzZXQKIyBD
T05GSUdfRkJfM0RGWCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1ZPT0RPTzEgaXMgbm90IHNldAoj
IENPTkZJR19GQl9WVDg2MjMgaXMgbm90IHNldAojIENPTkZJR19GQl9UUklERU5UIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRkJfQVJLIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUE0zIGlzIG5vdCBzZXQK
IyBDT05GSUdfRkJfQ0FSTUlORSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0dFT0RFIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRkJfVE1JTyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1ZJUlRVQUwgaXMgbm90
IHNldAojIENPTkZJR19GQl9NRVRST05PTUUgaXMgbm90IHNldAojIENPTkZJR19GQl9NQjg2MlhY
IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQlJPQURTSEVFVCBpcyBub3Qgc2V0CiMgQ09ORklHX0JB
Q0tMSUdIVF9MQ0RfU1VQUE9SVCBpcyBub3Qgc2V0CkNPTkZJR19CQUNLTElHSFRfQ0xBU1NfREVW
SUNFPW0KQ09ORklHX0JBQ0tMSUdIVF9HRU5FUklDPW0KIyBDT05GSUdfQkFDS0xJR0hUX1BST0dF
QVIgaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfTUJQX05WSURJQSBpcyBub3Qgc2V0CiMg
Q09ORklHX0JBQ0tMSUdIVF9TQUhBUkEgaXMgbm90IHNldAoKIwojIERpc3BsYXkgZGV2aWNlIHN1
cHBvcnQKIwojIENPTkZJR19ESVNQTEFZX1NVUFBPUlQgaXMgbm90IHNldAoKIwojIENvbnNvbGUg
ZGlzcGxheSBkcml2ZXIgc3VwcG9ydAojCkNPTkZJR19WR0FfQ09OU09MRT15CkNPTkZJR19WR0FD
T05fU09GVF9TQ1JPTExCQUNLPXkKQ09ORklHX1ZHQUNPTl9TT0ZUX1NDUk9MTEJBQ0tfU0laRT02
NApDT05GSUdfRFVNTVlfQ09OU09MRT15CkNPTkZJR19GUkFNRUJVRkZFUl9DT05TT0xFPXkKIyBD
T05GSUdfRlJBTUVCVUZGRVJfQ09OU09MRV9ERVRFQ1RfUFJJTUFSWSBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZSQU1FQlVGRkVSX0NPTlNPTEVfUk9UQVRJT04gaXMgbm90IHNldAojIENPTkZJR19GQl9D
T05fREVDT1IgaXMgbm90IHNldAojIENPTkZJR19GT05UUyBpcyBub3Qgc2V0CkNPTkZJR19GT05U
Xzh4OD15CkNPTkZJR19GT05UXzh4MTY9eQojIENPTkZJR19MT0dPIGlzIG5vdCBzZXQKQ09ORklH
X1NPVU5EPW0KQ09ORklHX1NPVU5EX09TU19DT1JFPXkKQ09ORklHX1NPVU5EX09TU19DT1JFX1BS
RUNMQUlNPXkKQ09ORklHX1NORD1tCkNPTkZJR19TTkRfVElNRVI9bQpDT05GSUdfU05EX1BDTT1t
CkNPTkZJR19TTkRfSFdERVA9bQpDT05GSUdfU05EX1JBV01JREk9bQpDT05GSUdfU05EX1NFUVVF
TkNFUj1tCkNPTkZJR19TTkRfU0VRX0RVTU1ZPW0KQ09ORklHX1NORF9PU1NFTVVMPXkKQ09ORklH
X1NORF9NSVhFUl9PU1M9bQpDT05GSUdfU05EX1BDTV9PU1M9bQpDT05GSUdfU05EX1BDTV9PU1Nf
UExVR0lOUz15CkNPTkZJR19TTkRfU0VRVUVOQ0VSX09TUz15CkNPTkZJR19TTkRfSFJUSU1FUj1t
CkNPTkZJR19TTkRfU0VRX0hSVElNRVJfREVGQVVMVD15CkNPTkZJR19TTkRfRFlOQU1JQ19NSU5P
UlM9eQpDT05GSUdfU05EX1NVUFBPUlRfT0xEX0FQST15CkNPTkZJR19TTkRfVkVSQk9TRV9QUk9D
RlM9eQojIENPTkZJR19TTkRfVkVSQk9TRV9QUklOVEsgaXMgbm90IHNldAojIENPTkZJR19TTkRf
REVCVUcgaXMgbm90IHNldApDT05GSUdfU05EX1ZNQVNURVI9eQpDT05GSUdfU05EX0RNQV9TR0JV
Rj15CkNPTkZJR19TTkRfUkFXTUlESV9TRVE9bQojIENPTkZJR19TTkRfT1BMM19MSUJfU0VRIGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX09QTDRfTElCX1NFUSBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9TQkFXRV9TRVEgaXMgbm90IHNldAojIENPTkZJR19TTkRfRU1VMTBLMV9TRVEgaXMgbm90IHNl
dApDT05GSUdfU05EX0RSSVZFUlM9eQojIENPTkZJR19TTkRfUENTUCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NORF9EVU1NWSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9WSVJNSURJIGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX01UUEFWIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX01UUzY0IGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX1NFUklBTF9VMTY1NTAgaXMgbm90IHNldAojIENPTkZJR19TTkRfTVBV
NDAxIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1BPUlRNQU4yWDQgaXMgbm90IHNldApDT05GSUdf
U05EX1BDST15CiMgQ09ORklHX1NORF9BRDE4ODkgaXMgbm90IHNldAojIENPTkZJR19TTkRfQUxT
MzAwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0FMUzQwMDAgaXMgbm90IHNldAojIENPTkZJR19T
TkRfQUxJNTQ1MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9BVElJWFAgaXMgbm90IHNldAojIENP
TkZJR19TTkRfQVRJSVhQX01PREVNIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0FVODgxMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NORF9BVTg4MjAgaXMgbm90IHNldAojIENPTkZJR19TTkRfQVU4ODMw
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0FXMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9BWlQz
MzI4IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0JUODdYIGlzIG5vdCBzZXQKIyBDT05GSUdfU05E
X0NBMDEwNiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9DTUlQQ0kgaXMgbm90IHNldAojIENPTkZJ
R19TTkRfT1hZR0VOIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0NTNDI4MSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9DUzQ2WFggaXMgbm90IHNldAojIENPTkZJR19TTkRfQ1M1NTMwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX0NTNTUzNUFVRElPIGlzIG5vdCBzZXQKQ09ORklHX1NORF9DVFhGST1t
CiMgQ09ORklHX1NORF9EQVJMQTIwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0dJTkEyMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NORF9MQVlMQTIwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0RBUkxB
MjQgaXMgbm90IHNldAojIENPTkZJR19TTkRfR0lOQTI0IGlzIG5vdCBzZXQKIyBDT05GSUdfU05E
X0xBWUxBMjQgaXMgbm90IHNldAojIENPTkZJR19TTkRfTU9OQSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9NSUEgaXMgbm90IHNldAojIENPTkZJR19TTkRfRUNITzNHIGlzIG5vdCBzZXQKIyBDT05G
SUdfU05EX0lORElHTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9JTkRJR09JTyBpcyBub3Qgc2V0
CiMgQ09ORklHX1NORF9JTkRJR09ESiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9JTkRJR09JT1gg
aXMgbm90IHNldAojIENPTkZJR19TTkRfSU5ESUdPREpYIGlzIG5vdCBzZXQKIyBDT05GSUdfU05E
X0VNVTEwSzEgaXMgbm90IHNldAojIENPTkZJR19TTkRfRU1VMTBLMVggaXMgbm90IHNldAojIENP
TkZJR19TTkRfRU5TMTM3MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9FTlMxMzcxIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX0VTMTkzOCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9FUzE5NjggaXMg
bm90IHNldAojIENPTkZJR19TTkRfRk04MDEgaXMgbm90IHNldApDT05GSUdfU05EX0hEQV9JTlRF
TD1tCkNPTkZJR19TTkRfSERBX0hXREVQPXkKIyBDT05GSUdfU05EX0hEQV9SRUNPTkZJRyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NORF9IREFfSU5QVVRfQkVFUCBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9IREFfSU5QVVRfSkFDSyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9IREFfUEFUQ0hfTE9BREVS
IGlzIG5vdCBzZXQKQ09ORklHX1NORF9IREFfQ09ERUNfUkVBTFRFSz15CkNPTkZJR19TTkRfSERB
X0NPREVDX0FOQUxPRz15CkNPTkZJR19TTkRfSERBX0NPREVDX1NJR01BVEVMPXkKQ09ORklHX1NO
RF9IREFfQ09ERUNfVklBPXkKQ09ORklHX1NORF9IREFfQ09ERUNfQVRJSERNST15CkNPTkZJR19T
TkRfSERBX0NPREVDX05WSERNST15CkNPTkZJR19TTkRfSERBX0NPREVDX0lOVEVMSERNST15CkNP
TkZJR19TTkRfSERBX0VMRD15CkNPTkZJR19TTkRfSERBX0NPREVDX0NJUlJVUz15CkNPTkZJR19T
TkRfSERBX0NPREVDX0NPTkVYQU5UPXkKQ09ORklHX1NORF9IREFfQ09ERUNfQ0EwMTEwPXkKQ09O
RklHX1NORF9IREFfQ09ERUNfQ01FRElBPXkKQ09ORklHX1NORF9IREFfQ09ERUNfU0kzMDU0PXkK
Q09ORklHX1NORF9IREFfR0VORVJJQz15CiMgQ09ORklHX1NORF9IREFfUE9XRVJfU0FWRSBpcyBu
b3Qgc2V0CkNPTkZJR19TTkRfSERTUD1tCiMgQ09ORklHX1NORF9IRFNQTSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9ISUZJRVIgaXMgbm90IHNldAojIENPTkZJR19TTkRfSUNFMTcxMiBpcyBub3Qg
c2V0CiMgQ09ORklHX1NORF9JQ0UxNzI0IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0lOVEVMOFgw
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0lOVEVMOFgwTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9LT1JHMTIxMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9MWDY0NjRFUyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9NQUVTVFJPMyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9NSVhBUlQgaXMgbm90
IHNldAojIENPTkZJR19TTkRfTk0yNTYgaXMgbm90IHNldAojIENPTkZJR19TTkRfUENYSFIgaXMg
bm90IHNldAojIENPTkZJR19TTkRfUklQVElERSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9STUUz
MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9STUU5NiBpcyBub3Qgc2V0CkNPTkZJR19TTkRfUk1F
OTY1Mj1tCiMgQ09ORklHX1NORF9TT05JQ1ZJQkVTIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1RS
SURFTlQgaXMgbm90IHNldAojIENPTkZJR19TTkRfVklBODJYWCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9WSUE4MlhYX01PREVNIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1ZJUlRVT1NPIGlzIG5v
dCBzZXQKIyBDT05GSUdfU05EX1ZYMjIyIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1lNRlBDSSBp
cyBub3Qgc2V0CkNPTkZJR19TTkRfVVNCPXkKIyBDT05GSUdfU05EX1VTQl9BVURJTyBpcyBub3Qg
c2V0CiMgQ09ORklHX1NORF9VU0JfVUExMDEgaXMgbm90IHNldAojIENPTkZJR19TTkRfVVNCX1VT
WDJZIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1VTQl9DQUlBUSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9VU0JfVVMxMjJMIGlzIG5vdCBzZXQKQ09ORklHX1NORF9QQ01DSUE9eQojIENPTkZJR19T
TkRfVlhQT0NLRVQgaXMgbm90IHNldAojIENPTkZJR19TTkRfUERBVURJT0NGIGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX1NPQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NPVU5EX1BSSU1FIGlzIG5vdCBz
ZXQKQ09ORklHX0hJRF9TVVBQT1JUPXkKQ09ORklHX0hJRD15CkNPTkZJR19ISURSQVc9eQoKIwoj
IFVTQiBJbnB1dCBEZXZpY2VzCiMKQ09ORklHX1VTQl9ISUQ9eQpDT05GSUdfSElEX1BJRD15CkNP
TkZJR19VU0JfSElEREVWPXkKCiMKIyBTcGVjaWFsIEhJRCBkcml2ZXJzCiMKIyBDT05GSUdfSElE
XzNNX1BDVCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9BNFRFQ0ggaXMgbm90IHNldAojIENPTkZJ
R19ISURfQVBQTEUgaXMgbm90IHNldAojIENPTkZJR19ISURfQkVMS0lOIGlzIG5vdCBzZXQKIyBD
T05GSUdfSElEX0NIRVJSWSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9DSElDT05ZIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSElEX0NZUFJFU1MgaXMgbm90IHNldAojIENPTkZJR19ISURfRFJBR09OUklT
RSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9FWktFWSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9L
WUUgaXMgbm90IHNldAojIENPTkZJR19ISURfR1lSQVRJT04gaXMgbm90IHNldAojIENPTkZJR19I
SURfVFdJTkhBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9LRU5TSU5HVE9OIGlzIG5vdCBzZXQK
IyBDT05GSUdfSElEX0xPR0lURUNIIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX01JQ1JPU09GVCBp
cyBub3Qgc2V0CiMgQ09ORklHX0hJRF9NT1NBUlQgaXMgbm90IHNldAojIENPTkZJR19ISURfTU9O
VEVSRVkgaXMgbm90IHNldApDT05GSUdfSElEX05UUklHPXkKIyBDT05GSUdfSElEX09SVEVLIGlz
IG5vdCBzZXQKIyBDT05GSUdfSElEX1BBTlRIRVJMT1JEIGlzIG5vdCBzZXQKIyBDT05GSUdfSElE
X1BFVEFMWU5YIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1FVQU5UQSBpcyBub3Qgc2V0CiMgQ09O
RklHX0hJRF9TQU1TVU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1NPTlkgaXMgbm90IHNldAoj
IENPTkZJR19ISURfU1RBTlRVTSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9TVU5QTFVTIGlzIG5v
dCBzZXQKIyBDT05GSUdfSElEX0dSRUVOQVNJQSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9TTUFS
VEpPWVBMVVMgaXMgbm90IHNldAojIENPTkZJR19ISURfVE9QU0VFRCBpcyBub3Qgc2V0CiMgQ09O
RklHX0hJRF9USFJVU1RNQVNURVIgaXMgbm90IHNldAojIENPTkZJR19ISURfWkVST1BMVVMgaXMg
bm90IHNldApDT05GSUdfVVNCX1NVUFBPUlQ9eQpDT05GSUdfVVNCX0FSQ0hfSEFTX0hDRD15CkNP
TkZJR19VU0JfQVJDSF9IQVNfT0hDST15CkNPTkZJR19VU0JfQVJDSF9IQVNfRUhDST15CkNPTkZJ
R19VU0I9eQojIENPTkZJR19VU0JfREVCVUcgaXMgbm90IHNldApDT05GSUdfVVNCX0FOTk9VTkNF
X05FV19ERVZJQ0VTPXkKCiMKIyBNaXNjZWxsYW5lb3VzIFVTQiBvcHRpb25zCiMKQ09ORklHX1VT
Ql9ERVZJQ0VGUz15CiMgQ09ORklHX1VTQl9ERVZJQ0VfQ0xBU1MgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfRFlOQU1JQ19NSU5PUlMgaXMgbm90IHNldAojIENPTkZJR19VU0JfT1RHX1dISVRFTElT
VCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9PVEdfQkxBQ0tMSVNUX0hVQiBpcyBub3Qgc2V0CkNP
TkZJR19VU0JfTU9OPXkKIyBDT05GSUdfVVNCX1dVU0IgaXMgbm90IHNldAojIENPTkZJR19VU0Jf
V1VTQl9DQkFGIGlzIG5vdCBzZXQKCiMKIyBVU0IgSG9zdCBDb250cm9sbGVyIERyaXZlcnMKIwoj
IENPTkZJR19VU0JfQzY3WDAwX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9YSENJX0hDRCBp
cyBub3Qgc2V0CkNPTkZJR19VU0JfRUhDSV9IQ0Q9eQojIENPTkZJR19VU0JfRUhDSV9ST09UX0hV
Ql9UVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9FSENJX1RUX05FV1NDSEVEIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX09YVTIxMEhQX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU1AxMTZY
X0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU1AxNzYwX0hDRCBpcyBub3Qgc2V0CiMgQ09O
RklHX1VTQl9JU1AxMzYyX0hDRCBpcyBub3Qgc2V0CkNPTkZJR19VU0JfT0hDSV9IQ0Q9eQojIENP
TkZJR19VU0JfT0hDSV9CSUdfRU5ESUFOX0RFU0MgaXMgbm90IHNldAojIENPTkZJR19VU0JfT0hD
SV9CSUdfRU5ESUFOX01NSU8gaXMgbm90IHNldApDT05GSUdfVVNCX09IQ0lfTElUVExFX0VORElB
Tj15CkNPTkZJR19VU0JfVUhDSV9IQ0Q9eQojIENPTkZJR19VU0JfU0w4MTFfSENEIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX1I4QTY2NTk3X0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9XSENJ
X0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9IV0FfSENEIGlzIG5vdCBzZXQKCiMKIyBVU0Ig
RGV2aWNlIENsYXNzIGRyaXZlcnMKIwojIENPTkZJR19VU0JfQUNNIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX1BSSU5URVIgaXMgbm90IHNldAojIENPTkZJR19VU0JfV0RNIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX1RNQyBpcyBub3Qgc2V0CgojCiMgTk9URTogVVNCX1NUT1JBR0UgZGVwZW5kcyBv
biBTQ1NJIGJ1dCBCTEtfREVWX1NEIG1heQojCgojCiMgYWxzbyBiZSBuZWVkZWQ7IHNlZSBVU0Jf
U1RPUkFHRSBIZWxwIGZvciBtb3JlIGluZm8KIwpDT05GSUdfVVNCX1NUT1JBR0U9eQojIENPTkZJ
R19VU0JfU1RPUkFHRV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0RBVEFG
QUIgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9GUkVFQ09NIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX1NUT1JBR0VfSVNEMjAwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0Vf
VVNCQVQgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9TRERSMDkgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfU1RPUkFHRV9TRERSNTUgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFH
RV9KVU1QU0hPVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0FMQVVEQSBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX09ORVRPVUNIIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X1NUT1JBR0VfS0FSTUEgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9DWVBSRVNTX0FU
QUNCIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9MSUJVU1VBTD15CgojCiMgVVNCIEltYWdpbmcgZGV2
aWNlcwojCiMgQ09ORklHX1VTQl9NREM4MDAgaXMgbm90IHNldAojIENPTkZJR19VU0JfTUlDUk9U
RUsgaXMgbm90IHNldAoKIwojIFVTQiBwb3J0IGRyaXZlcnMKIwojIENPTkZJR19VU0JfVVNTNzIw
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTCBpcyBub3Qgc2V0CgojCiMgVVNCIE1pc2Nl
bGxhbmVvdXMgZHJpdmVycwojCiMgQ09ORklHX1VTQl9FTUk2MiBpcyBub3Qgc2V0CiMgQ09ORklH
X1VTQl9FTUkyNiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9BRFVUVVggaXMgbm90IHNldAojIENP
TkZJR19VU0JfU0VWU0VHIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1JJTzUwMCBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9MRUdPVE9XRVIgaXMgbm90IHNldAojIENPTkZJR19VU0JfTENEIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX0xFRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9DWVBSRVNTX0NZ
N0M2MyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9DWVRIRVJNIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX0lETU9VU0UgaXMgbm90IHNldAojIENPTkZJR19VU0JfRlRESV9FTEFOIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX0FQUExFRElTUExBWSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TSVNVU0JW
R0EgaXMgbm90IHNldAojIENPTkZJR19VU0JfTEQgaXMgbm90IHNldAojIENPTkZJR19VU0JfVFJB
TkNFVklCUkFUT1IgaXMgbm90IHNldAojIENPTkZJR19VU0JfSU9XQVJSSU9SIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX1RFU1QgaXMgbm90IHNldAojIENPTkZJR19VU0JfSVNJR0hURlcgaXMgbm90
IHNldAojIENPTkZJR19VU0JfR0FER0VUIGlzIG5vdCBzZXQKCiMKIyBPVEcgYW5kIHJlbGF0ZWQg
aW5mcmFzdHJ1Y3R1cmUKIwojIENPTkZJR19OT1BfVVNCX1hDRUlWIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVdCIGlzIG5vdCBzZXQKIyBDT05GSUdfTU1DIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVNU1RJ
Q0sgaXMgbm90IHNldApDT05GSUdfTkVXX0xFRFM9eQpDT05GSUdfTEVEU19DTEFTUz15CgojCiMg
TEVEIGRyaXZlcnMKIwojIENPTkZJR19MRURTX0FMSVgyIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVE
U19QQ0E5NTMyIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19MUDM5NDQgaXMgbm90IHNldAojIENP
TkZJR19MRURTX0NMRVZPX01BSUwgaXMgbm90IHNldAojIENPTkZJR19MRURTX1BDQTk1NVggaXMg
bm90IHNldAojIENPTkZJR19MRURTX0JEMjgwMiBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfSU5U
RUxfU1M0MjAwIGlzIG5vdCBzZXQKQ09ORklHX0xFRFNfVFJJR0dFUlM9eQoKIwojIExFRCBUcmln
Z2VycwojCiMgQ09ORklHX0xFRFNfVFJJR0dFUl9USU1FUiBpcyBub3Qgc2V0CiMgQ09ORklHX0xF
RFNfVFJJR0dFUl9JREVfRElTSyBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfVFJJR0dFUl9IRUFS
VEJFQVQgaXMgbm90IHNldAojIENPTkZJR19MRURTX1RSSUdHRVJfQkFDS0xJR0hUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTEVEU19UUklHR0VSX0RFRkFVTFRfT04gaXMgbm90IHNldAoKIwojIGlwdGFi
bGVzIHRyaWdnZXIgaXMgdW5kZXIgTmV0ZmlsdGVyIGNvbmZpZyAoTEVEIHRhcmdldCkKIwojIENP
TkZJR19BQ0NFU1NJQklMSVRZIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5GSU5JQkFORCBpcyBub3Qg
c2V0CkNPTkZJR19FREFDPXkKCiMKIyBSZXBvcnRpbmcgc3Vic3lzdGVtcwojCiMgQ09ORklHX0VE
QUNfREVCVUcgaXMgbm90IHNldApDT05GSUdfRURBQ19ERUNPREVfTUNFPXkKIyBDT05GSUdfRURB
Q19NTV9FREFDIGlzIG5vdCBzZXQKQ09ORklHX1JUQ19MSUI9eQpDT05GSUdfUlRDX0NMQVNTPXkK
Q09ORklHX1JUQ19IQ1RPU1lTPXkKQ09ORklHX1JUQ19IQ1RPU1lTX0RFVklDRT0icnRjMCIKIyBD
T05GSUdfUlRDX0RFQlVHIGlzIG5vdCBzZXQKCiMKIyBSVEMgaW50ZXJmYWNlcwojCkNPTkZJR19S
VENfSU5URl9TWVNGUz15CkNPTkZJR19SVENfSU5URl9QUk9DPXkKQ09ORklHX1JUQ19JTlRGX0RF
Vj15CiMgQ09ORklHX1JUQ19JTlRGX0RFVl9VSUVfRU1VTCBpcyBub3Qgc2V0CiMgQ09ORklHX1JU
Q19EUlZfVEVTVCBpcyBub3Qgc2V0CgojCiMgSTJDIFJUQyBkcml2ZXJzCiMKIyBDT05GSUdfUlRD
X0RSVl9EUzEzMDcgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTM3NCBpcyBub3Qgc2V0
CiMgQ09ORklHX1JUQ19EUlZfRFMxNjcyIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9NQVg2
OTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9SUzVDMzcyIGlzIG5vdCBzZXQKIyBDT05G
SUdfUlRDX0RSVl9JU0wxMjA4IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9YMTIwNSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUENGODU2MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19E
UlZfUENGODU4MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTTQxVDgwIGlzIG5vdCBzZXQK
IyBDT05GSUdfUlRDX0RSVl9CUTMySyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUzM1Mzkw
QSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRk0zMTMwIGlzIG5vdCBzZXQKIyBDT05GSUdf
UlRDX0RSVl9SWDg1ODEgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1JYODAyNSBpcyBub3Qg
c2V0CgojCiMgU1BJIFJUQyBkcml2ZXJzCiMKCiMKIyBQbGF0Zm9ybSBSVEMgZHJpdmVycwojCkNP
TkZJR19SVENfRFJWX0NNT1M9bQojIENPTkZJR19SVENfRFJWX0RTMTI4NiBpcyBub3Qgc2V0CiMg
Q09ORklHX1JUQ19EUlZfRFMxNTExIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzE1NTMg
aXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTc0MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JU
Q19EUlZfU1RLMTdUQTggaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX000OFQ4NiBpcyBub3Qg
c2V0CiMgQ09ORklHX1JUQ19EUlZfTTQ4VDM1IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9N
NDhUNTkgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX01TTTYyNDIgaXMgbm90IHNldAojIENP
TkZJR19SVENfRFJWX0JRNDgwMiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlA1QzAxIGlz
IG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9WMzAyMCBpcyBub3Qgc2V0CgojCiMgb24tQ1BVIFJU
QyBkcml2ZXJzCiMKQ09ORklHX0RNQURFVklDRVM9eQojIENPTkZJR19ETUFERVZJQ0VTX0RFQlVH
IGlzIG5vdCBzZXQKCiMKIyBETUEgRGV2aWNlcwojCiMgQ09ORklHX0lOVEVMX0lPQVRETUEgaXMg
bm90IHNldAojIENPTkZJR19BVVhESVNQTEFZIGlzIG5vdCBzZXQKQ09ORklHX1VJTz1tCiMgQ09O
RklHX1VJT19DSUYgaXMgbm90IHNldAojIENPTkZJR19VSU9fUERSViBpcyBub3Qgc2V0CiMgQ09O
RklHX1VJT19QRFJWX0dFTklSUSBpcyBub3Qgc2V0CiMgQ09ORklHX1VJT19BRUMgaXMgbm90IHNl
dAojIENPTkZJR19VSU9fU0VSQ09TMyBpcyBub3Qgc2V0CiMgQ09ORklHX1VJT19QQ0lfR0VORVJJ
QyBpcyBub3Qgc2V0CiMgQ09ORklHX1VJT19ORVRYIGlzIG5vdCBzZXQKCiMKIyBUSSBWTFlOUQoj
CiMgQ09ORklHX1NUQUdJTkcgaXMgbm90IHNldAojIENPTkZJR19YODZfUExBVEZPUk1fREVWSUNF
UyBpcyBub3Qgc2V0CgojCiMgRmlybXdhcmUgRHJpdmVycwojCiMgQ09ORklHX0VERCBpcyBub3Qg
c2V0CkNPTkZJR19GSVJNV0FSRV9NRU1NQVA9eQpDT05GSUdfRUZJX1ZBUlM9eQojIENPTkZJR19E
RUxMX1JCVSBpcyBub3Qgc2V0CiMgQ09ORklHX0RDREJBUyBpcyBub3Qgc2V0CkNPTkZJR19ETUlJ
RD15CiMgQ09ORklHX0lTQ1NJX0lCRlRfRklORCBpcyBub3Qgc2V0CgojCiMgRmlsZSBzeXN0ZW1z
CiMKQ09ORklHX0VYVDJfRlM9eQpDT05GSUdfRVhUMl9GU19YQVRUUj15CkNPTkZJR19FWFQyX0ZT
X1BPU0lYX0FDTD15CiMgQ09ORklHX0VYVDJfRlNfU0VDVVJJVFkgaXMgbm90IHNldAojIENPTkZJ
R19FWFQyX0ZTX1hJUCBpcyBub3Qgc2V0CkNPTkZJR19FWFQzX0ZTPXkKIyBDT05GSUdfRVhUM19E
RUZBVUxUU19UT19PUkRFUkVEIGlzIG5vdCBzZXQKQ09ORklHX0VYVDNfRlNfWEFUVFI9eQpDT05G
SUdfRVhUM19GU19QT1NJWF9BQ0w9eQpDT05GSUdfRVhUM19GU19TRUNVUklUWT15CkNPTkZJR19F
WFQ0X0ZTPXkKQ09ORklHX0VYVDRfRlNfWEFUVFI9eQpDT05GSUdfRVhUNF9GU19QT1NJWF9BQ0w9
eQpDT05GSUdfRVhUNF9GU19TRUNVUklUWT15CiMgQ09ORklHX0VYVDRfREVCVUcgaXMgbm90IHNl
dApDT05GSUdfSkJEPXkKIyBDT05GSUdfSkJEX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0pCRDI9
eQojIENPTkZJR19KQkQyX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0ZTX01CQ0FDSEU9eQojIENP
TkZJR19SRUlTRVJGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0pGU19GUyBpcyBub3Qgc2V0CkNP
TkZJR19GU19QT1NJWF9BQ0w9eQojIENPTkZJR19YRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19H
RlMyX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfT0NGUzJfRlMgaXMgbm90IHNldAojIENPTkZJR19C
VFJGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX05JTEZTMl9GUyBpcyBub3Qgc2V0CkNPTkZJR19G
SUxFX0xPQ0tJTkc9eQpDT05GSUdfRlNOT1RJRlk9eQpDT05GSUdfRE5PVElGWT15CkNPTkZJR19J
Tk9USUZZPXkKQ09ORklHX0lOT1RJRllfVVNFUj15CkNPTkZJR19RVU9UQT15CiMgQ09ORklHX1FV
T1RBX05FVExJTktfSU5URVJGQUNFIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJJTlRfUVVPVEFfV0FS
TklORyBpcyBub3Qgc2V0CiMgQ09ORklHX1FVT1RBX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdf
UUZNVF9WMSBpcyBub3Qgc2V0CiMgQ09ORklHX1FGTVRfVjIgaXMgbm90IHNldApDT05GSUdfUVVP
VEFDVEw9eQpDT05GSUdfUVVPVEFDVExfQ09NUEFUPXkKIyBDT05GSUdfQVVUT0ZTX0ZTIGlzIG5v
dCBzZXQKIyBDT05GSUdfQVVUT0ZTNF9GUyBpcyBub3Qgc2V0CkNPTkZJR19GVVNFX0ZTPXkKQ09O
RklHX0NVU0U9bQpDT05GSUdfR0VORVJJQ19BQ0w9eQoKIwojIENhY2hlcwojCiMgQ09ORklHX0ZT
Q0FDSEUgaXMgbm90IHNldAoKIwojIENELVJPTS9EVkQgRmlsZXN5c3RlbXMKIwpDT05GSUdfSVNP
OTY2MF9GUz15CkNPTkZJR19KT0xJRVQ9eQpDT05GSUdfWklTT0ZTPXkKQ09ORklHX1VERl9GUz15
CkNPTkZJR19VREZfTkxTPXkKCiMKIyBET1MvRkFUL05UIEZpbGVzeXN0ZW1zCiMKQ09ORklHX0ZB
VF9GUz15CkNPTkZJR19NU0RPU19GUz15CkNPTkZJR19WRkFUX0ZTPXkKQ09ORklHX0ZBVF9ERUZB
VUxUX0NPREVQQUdFPTQzNwpDT05GSUdfRkFUX0RFRkFVTFRfSU9DSEFSU0VUPSJpc284ODU5LTEi
CkNPTkZJR19OVEZTX0ZTPXkKIyBDT05GSUdfTlRGU19ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19O
VEZTX1JXPXkKCiMKIyBQc2V1ZG8gZmlsZXN5c3RlbXMKIwpDT05GSUdfUFJPQ19GUz15CiMgQ09O
RklHX1BST0NfS0NPUkUgaXMgbm90IHNldApDT05GSUdfUFJPQ19TWVNDVEw9eQpDT05GSUdfUFJP
Q19QQUdFX01PTklUT1I9eQpDT05GSUdfU1lTRlM9eQpDT05GSUdfVE1QRlM9eQpDT05GSUdfVE1Q
RlNfUE9TSVhfQUNMPXkKIyBDT05GSUdfSFVHRVRMQkZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSFVH
RVRMQl9QQUdFIGlzIG5vdCBzZXQKQ09ORklHX0NPTkZJR0ZTX0ZTPW0KQ09ORklHX01JU0NfRklM
RVNZU1RFTVM9eQojIENPTkZJR19BREZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQUZGU19GUyBp
cyBub3Qgc2V0CiMgQ09ORklHX0hGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hGU1BMVVNfRlMg
aXMgbm90IHNldAojIENPTkZJR19CRUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQkZTX0ZTIGlz
IG5vdCBzZXQKIyBDT05GSUdfRUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfTE9HRlMgaXMgbm90
IHNldAojIENPTkZJR19DUkFNRlMgaXMgbm90IHNldAojIENPTkZJR19TUVVBU0hGUyBpcyBub3Qg
c2V0CiMgQ09ORklHX1ZYRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19NSU5JWF9GUyBpcyBub3Qg
c2V0CiMgQ09ORklHX09NRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19IUEZTX0ZTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUU5YNEZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfUk9NRlNfRlMgaXMgbm90
IHNldAojIENPTkZJR19TWVNWX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfVUZTX0ZTIGlzIG5vdCBz
ZXQKQ09ORklHX05FVFdPUktfRklMRVNZU1RFTVM9eQpDT05GSUdfTkZTX0ZTPXkKQ09ORklHX05G
U19WMz15CkNPTkZJR19ORlNfVjNfQUNMPXkKQ09ORklHX05GU19WND15CiMgQ09ORklHX05GU19W
NF8xIGlzIG5vdCBzZXQKQ09ORklHX1JPT1RfTkZTPXkKIyBDT05GSUdfTkZTRCBpcyBub3Qgc2V0
CkNPTkZJR19MT0NLRD15CkNPTkZJR19MT0NLRF9WND15CkNPTkZJR19ORlNfQUNMX1NVUFBPUlQ9
eQpDT05GSUdfTkZTX0NPTU1PTj15CkNPTkZJR19TVU5SUEM9eQpDT05GSUdfU1VOUlBDX0dTUz15
CkNPTkZJR19SUENTRUNfR1NTX0tSQjU9eQojIENPTkZJR19SUENTRUNfR1NTX1NQS00zIGlzIG5v
dCBzZXQKIyBDT05GSUdfU01CX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0VQSF9GUyBpcyBub3Qg
c2V0CiMgQ09ORklHX0NJRlMgaXMgbm90IHNldAojIENPTkZJR19OQ1BfRlMgaXMgbm90IHNldAoj
IENPTkZJR19DT0RBX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQUZTX0ZTIGlzIG5vdCBzZXQKCiMK
IyBQYXJ0aXRpb24gVHlwZXMKIwpDT05GSUdfUEFSVElUSU9OX0FEVkFOQ0VEPXkKIyBDT05GSUdf
QUNPUk5fUEFSVElUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfT1NGX1BBUlRJVElPTiBpcyBub3Qg
c2V0CiMgQ09ORklHX0FNSUdBX1BBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0FUQVJJX1BB
UlRJVElPTiBpcyBub3Qgc2V0CkNPTkZJR19NQUNfUEFSVElUSU9OPXkKQ09ORklHX01TRE9TX1BB
UlRJVElPTj15CkNPTkZJR19CU0RfRElTS0xBQkVMPXkKIyBDT05GSUdfTUlOSVhfU1VCUEFSVElU
SU9OIGlzIG5vdCBzZXQKQ09ORklHX1NPTEFSSVNfWDg2X1BBUlRJVElPTj15CiMgQ09ORklHX1VO
SVhXQVJFX0RJU0tMQUJFTCBpcyBub3Qgc2V0CkNPTkZJR19MRE1fUEFSVElUSU9OPXkKIyBDT05G
SUdfTERNX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfU0dJX1BBUlRJVElPTiBpcyBub3Qgc2V0
CiMgQ09ORklHX1VMVFJJWF9QQVJUSVRJT04gaXMgbm90IHNldAojIENPTkZJR19TVU5fUEFSVElU
SU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfS0FSTUFfUEFSVElUSU9OIGlzIG5vdCBzZXQKQ09ORklH
X0VGSV9QQVJUSVRJT049eQojIENPTkZJR19TWVNWNjhfUEFSVElUSU9OIGlzIG5vdCBzZXQKQ09O
RklHX05MUz15CkNPTkZJR19OTFNfREVGQVVMVD0idXRmOCIKQ09ORklHX05MU19DT0RFUEFHRV80
Mzc9eQojIENPTkZJR19OTFNfQ09ERVBBR0VfNzM3IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NP
REVQQUdFXzc3NSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NTAgaXMgbm90IHNl
dAojIENPTkZJR19OTFNfQ09ERVBBR0VfODUyIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQ
QUdFXzg1NSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NTcgaXMgbm90IHNldAoj
IENPTkZJR19OTFNfQ09ERVBBR0VfODYwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdF
Xzg2MSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjIgaXMgbm90IHNldAojIENP
TkZJR19OTFNfQ09ERVBBR0VfODYzIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2
NCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjUgaXMgbm90IHNldAojIENPTkZJ
R19OTFNfQ09ERVBBR0VfODY2IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2OSBp
cyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV85MzYgaXMgbm90IHNldAojIENPTkZJR19O
TFNfQ09ERVBBR0VfOTUwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzkzMiBpcyBu
b3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV85NDkgaXMgbm90IHNldAojIENPTkZJR19OTFNf
Q09ERVBBR0VfODc0IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfOCBpcyBub3Qgc2V0
CiMgQ09ORklHX05MU19DT0RFUEFHRV8xMjUwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQ
QUdFXzEyNTEgaXMgbm90IHNldApDT05GSUdfTkxTX0FTQ0lJPXkKQ09ORklHX05MU19JU084ODU5
XzE9eQojIENPTkZJR19OTFNfSVNPODg1OV8yIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4
NTlfMyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzQgaXMgbm90IHNldAojIENPTkZJ
R19OTFNfSVNPODg1OV81IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfNiBpcyBub3Qg
c2V0CiMgQ09ORklHX05MU19JU084ODU5XzcgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1
OV85IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMTMgaXMgbm90IHNldAojIENPTkZJ
R19OTFNfSVNPODg1OV8xNCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzE1IGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX0tPSThfUiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19LT0k4X1Ug
aXMgbm90IHNldApDT05GSUdfTkxTX1VURjg9eQojIENPTkZJR19ETE0gaXMgbm90IHNldAoKIwoj
IEtlcm5lbCBoYWNraW5nCiMKQ09ORklHX1RSQUNFX0lSUUZMQUdTX1NVUFBPUlQ9eQojIENPTkZJ
R19QUklOVEtfVElNRSBpcyBub3Qgc2V0CiMgQ09ORklHX0VOQUJMRV9XQVJOX0RFUFJFQ0FURUQg
aXMgbm90IHNldApDT05GSUdfRU5BQkxFX01VU1RfQ0hFQ0s9eQpDT05GSUdfRlJBTUVfV0FSTj0y
MDQ4CkNPTkZJR19NQUdJQ19TWVNSUT15CiMgQ09ORklHX1NUUklQX0FTTV9TWU1TIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVU5VU0VEX1NZTUJPTFMgaXMgbm90IHNldApDT05GSUdfREVCVUdfRlM9eQoj
IENPTkZJR19IRUFERVJTX0NIRUNLIGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX0tFUk5FTD15CiMg
Q09ORklHX0RFQlVHX1NISVJRIGlzIG5vdCBzZXQKQ09ORklHX0RFVEVDVF9TT0ZUTE9DS1VQPXkK
IyBDT05GSUdfQk9PVFBBUkFNX1NPRlRMT0NLVVBfUEFOSUMgaXMgbm90IHNldApDT05GSUdfQk9P
VFBBUkFNX1NPRlRMT0NLVVBfUEFOSUNfVkFMVUU9MApDT05GSUdfREVURUNUX0hVTkdfVEFTSz15
CiMgQ09ORklHX0JPT1RQQVJBTV9IVU5HX1RBU0tfUEFOSUMgaXMgbm90IHNldApDT05GSUdfQk9P
VFBBUkFNX0hVTkdfVEFTS19QQU5JQ19WQUxVRT0wCkNPTkZJR19TQ0hFRF9ERUJVRz15CiMgQ09O
RklHX1NDSEVEU1RBVFMgaXMgbm90IHNldAojIENPTkZJR19USU1FUl9TVEFUUyBpcyBub3Qgc2V0
CiMgQ09ORklHX0RFQlVHX09CSkVDVFMgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19TTEFCIGlz
IG5vdCBzZXQKIyBDT05GSUdfREVCVUdfS01FTUxFQUsgaXMgbm90IHNldApDT05GSUdfREVCVUdf
UFJFRU1QVD15CiMgQ09ORklHX0RFQlVHX1JUX01VVEVYRVMgaXMgbm90IHNldAojIENPTkZJR19S
VF9NVVRFWF9URVNURVIgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19TUElOTE9DSyBpcyBub3Qg
c2V0CiMgQ09ORklHX0RFQlVHX01VVEVYRVMgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19MT0NL
X0FMTE9DIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJPVkVfTE9DS0lORyBpcyBub3Qgc2V0CiMgQ09O
RklHX0xPQ0tfU1RBVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1NQSU5MT0NLX1NMRUVQIGlz
IG5vdCBzZXQKIyBDT05GSUdfREVCVUdfTE9DS0lOR19BUElfU0VMRlRFU1RTIGlzIG5vdCBzZXQK
IyBDT05GSUdfREVCVUdfS09CSkVDVCBpcyBub3Qgc2V0CkNPTkZJR19ERUJVR19CVUdWRVJCT1NF
PXkKIyBDT05GSUdfREVCVUdfSU5GTyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1ZNIGlzIG5v
dCBzZXQKIyBDT05GSUdfREVCVUdfVklSVFVBTCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1dS
SVRFQ09VTlQgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19NRU1PUllfSU5JVCBpcyBub3Qgc2V0
CiMgQ09ORklHX0RFQlVHX0xJU1QgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19TRyBpcyBub3Qg
c2V0CiMgQ09ORklHX0RFQlVHX05PVElGSUVSUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0NS
RURFTlRJQUxTIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfV0FOVF9GUkFNRV9QT0lOVEVSUz15CkNP
TkZJR19GUkFNRV9QT0lOVEVSPXkKIyBDT05GSUdfQk9PVF9QUklOVEtfREVMQVkgaXMgbm90IHNl
dAojIENPTkZJR19SQ1VfVE9SVFVSRV9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfUkNVX0NQVV9T
VEFMTF9ERVRFQ1RPUiBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tUUkFDRV9TRUxGX1RFU1QgaXMg
bm90IHNldAojIENPTkZJR19ERUJVR19CTE9DS19FWFRfREVWVCBpcyBub3Qgc2V0CiMgQ09ORklH
X0RFQlVHX0ZPUkNFX1dFQUtfUEVSX0NQVSBpcyBub3Qgc2V0CiMgQ09ORklHX0xLRFRNIGlzIG5v
dCBzZXQKIyBDT05GSUdfRkFVTFRfSU5KRUNUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfTEFURU5D
WVRPUCBpcyBub3Qgc2V0CkNPTkZJR19TWVNDVExfU1lTQ0FMTF9DSEVDSz15CiMgQ09ORklHX0RF
QlVHX1BBR0VBTExPQyBpcyBub3Qgc2V0CkNPTkZJR19VU0VSX1NUQUNLVFJBQ0VfU1VQUE9SVD15
CkNPTkZJR19IQVZFX0ZVTkNUSU9OX1RSQUNFUj15CkNPTkZJR19IQVZFX0ZVTkNUSU9OX0dSQVBI
X1RSQUNFUj15CkNPTkZJR19IQVZFX0ZVTkNUSU9OX0dSQVBIX0ZQX1RFU1Q9eQpDT05GSUdfSEFW
RV9GVU5DVElPTl9UUkFDRV9NQ09VTlRfVEVTVD15CkNPTkZJR19IQVZFX0RZTkFNSUNfRlRSQUNF
PXkKQ09ORklHX0hBVkVfRlRSQUNFX01DT1VOVF9SRUNPUkQ9eQpDT05GSUdfSEFWRV9TWVNDQUxM
X1RSQUNFUE9JTlRTPXkKQ09ORklHX1RSQUNJTkdfU1VQUE9SVD15CiMgQ09ORklHX0ZUUkFDRSBp
cyBub3Qgc2V0CiMgQ09ORklHX1BST1ZJREVfT0hDSTEzOTRfRE1BX0lOSVQgaXMgbm90IHNldAoj
IENPTkZJR19EWU5BTUlDX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1BX0FQSV9ERUJVRyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NBTVBMRVMgaXMgbm90IHNldApDT05GSUdfSEFWRV9BUkNIX0tH
REI9eQojIENPTkZJR19LR0RCIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfQVJDSF9LTUVNQ0hFQ0s9
eQojIENPTkZJR19TVFJJQ1RfREVWTUVNIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9WRVJCT1NFX0JP
T1RVUD15CkNPTkZJR19FQVJMWV9QUklOVEs9eQojIENPTkZJR19FQVJMWV9QUklOVEtfREJHUCBp
cyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1NUQUNLT1ZFUkZMT1cgaXMgbm90IHNldAojIENPTkZJ
R19ERUJVR19TVEFDS19VU0FHRSBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1BFUl9DUFVfTUFQ
UyBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9QVERVTVAgaXMgbm90IHNldApDT05GSUdfREVCVUdf
Uk9EQVRBPXkKIyBDT05GSUdfREVCVUdfUk9EQVRBX1RFU1QgaXMgbm90IHNldAojIENPTkZJR19E
RUJVR19OWF9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfSU9NTVVfREVCVUcgaXMgbm90IHNldAoj
IENPTkZJR19JT01NVV9TVFJFU1MgaXMgbm90IHNldApDT05GSUdfSEFWRV9NTUlPVFJBQ0VfU1VQ
UE9SVD15CkNPTkZJR19JT19ERUxBWV9UWVBFXzBYODA9MApDT05GSUdfSU9fREVMQVlfVFlQRV8w
WEVEPTEKQ09ORklHX0lPX0RFTEFZX1RZUEVfVURFTEFZPTIKQ09ORklHX0lPX0RFTEFZX1RZUEVf
Tk9ORT0zCkNPTkZJR19JT19ERUxBWV8wWDgwPXkKIyBDT05GSUdfSU9fREVMQVlfMFhFRCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lPX0RFTEFZX1VERUxBWSBpcyBub3Qgc2V0CiMgQ09ORklHX0lPX0RF
TEFZX05PTkUgaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9JT19ERUxBWV9UWVBFPTAKIyBDT05G
SUdfREVCVUdfQk9PVF9QQVJBTVMgaXMgbm90IHNldAojIENPTkZJR19DUEFfREVCVUcgaXMgbm90
IHNldAojIENPTkZJR19PUFRJTUlaRV9JTkxJTklORyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVH
X1NUUklDVF9VU0VSX0NPUFlfQ0hFQ0tTIGlzIG5vdCBzZXQKCiMKIyBTZWN1cml0eSBvcHRpb25z
CiMKIyBDT05GSUdfS0VZUyBpcyBub3Qgc2V0CkNPTkZJR19TRUNVUklUWT15CiMgQ09ORklHX1NF
Q1VSSVRZRlMgaXMgbm90IHNldAojIENPTkZJR19TRUNVUklUWV9ORVRXT1JLIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VDVVJJVFlfUEFUSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOVEVMX1RYVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFQ1VSSVRZX1RPTU9ZTyBpcyBub3Qgc2V0CiMgQ09ORklHX0lNQSBp
cyBub3Qgc2V0CiMgQ09ORklHX0RFRkFVTFRfU0VDVVJJVFlfU0VMSU5VWCBpcyBub3Qgc2V0CiMg
Q09ORklHX0RFRkFVTFRfU0VDVVJJVFlfU01BQ0sgaXMgbm90IHNldAojIENPTkZJR19ERUZBVUxU
X1NFQ1VSSVRZX1RPTU9ZTyBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX1NFQ1VSSVRZX0RBQz15
CkNPTkZJR19ERUZBVUxUX1NFQ1VSSVRZPSIiCkNPTkZJR19DUllQVE89eQoKIwojIENyeXB0byBj
b3JlIG9yIGhlbHBlcgojCkNPTkZJR19DUllQVE9fQUxHQVBJPXkKQ09ORklHX0NSWVBUT19BTEdB
UEkyPXkKQ09ORklHX0NSWVBUT19BRUFEPXkKQ09ORklHX0NSWVBUT19BRUFEMj15CkNPTkZJR19D
UllQVE9fQkxLQ0lQSEVSPXkKQ09ORklHX0NSWVBUT19CTEtDSVBIRVIyPXkKQ09ORklHX0NSWVBU
T19IQVNIPXkKQ09ORklHX0NSWVBUT19IQVNIMj15CkNPTkZJR19DUllQVE9fUk5HMj15CkNPTkZJ
R19DUllQVE9fUENPTVA9eQpDT05GSUdfQ1JZUFRPX01BTkFHRVI9eQpDT05GSUdfQ1JZUFRPX01B
TkFHRVIyPXkKQ09ORklHX0NSWVBUT19HRjEyOE1VTD1tCkNPTkZJR19DUllQVE9fTlVMTD1tCiMg
Q09ORklHX0NSWVBUT19QQ1JZUFQgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX1dPUktRVUVVRT15
CkNPTkZJR19DUllQVE9fQ1JZUFREPW0KQ09ORklHX0NSWVBUT19BVVRIRU5DPXkKQ09ORklHX0NS
WVBUT19URVNUPW0KCiMKIyBBdXRoZW50aWNhdGVkIEVuY3J5cHRpb24gd2l0aCBBc3NvY2lhdGVk
IERhdGEKIwojIENPTkZJR19DUllQVE9fQ0NNIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0dD
TSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19TRVFJViBpcyBub3Qgc2V0CgojCiMgQmxvY2sg
bW9kZXMKIwpDT05GSUdfQ1JZUFRPX0NCQz15CiMgQ09ORklHX0NSWVBUT19DVFIgaXMgbm90IHNl
dAojIENPTkZJR19DUllQVE9fQ1RTIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0VDQiBpcyBu
b3Qgc2V0CkNPTkZJR19DUllQVE9fTFJXPW0KQ09ORklHX0NSWVBUT19QQ0JDPW0KQ09ORklHX0NS
WVBUT19YVFM9bQoKIwojIEhhc2ggbW9kZXMKIwpDT05GSUdfQ1JZUFRPX0hNQUM9eQpDT05GSUdf
Q1JZUFRPX1hDQkM9bQojIENPTkZJR19DUllQVE9fVk1BQyBpcyBub3Qgc2V0CgojCiMgRGlnZXN0
CiMKQ09ORklHX0NSWVBUT19DUkMzMkM9eQpDT05GSUdfQ1JZUFRPX0NSQzMyQ19JTlRFTD15CiMg
Q09ORklHX0NSWVBUT19HSEFTSCBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fTUQ0PW0KQ09ORklH
X0NSWVBUT19NRDU9eQpDT05GSUdfQ1JZUFRPX01JQ0hBRUxfTUlDPW0KIyBDT05GSUdfQ1JZUFRP
X1JNRDEyOCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19STUQxNjAgaXMgbm90IHNldAojIENP
TkZJR19DUllQVE9fUk1EMjU2IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1JNRDMyMCBpcyBu
b3Qgc2V0CkNPTkZJR19DUllQVE9fU0hBMT15CkNPTkZJR19DUllQVE9fU0hBMjU2PW0KQ09ORklH
X0NSWVBUT19TSEE1MTI9bQpDT05GSUdfQ1JZUFRPX1RHUjE5Mj1tCkNPTkZJR19DUllQVE9fV1A1
MTI9bQojIENPTkZJR19DUllQVE9fR0hBU0hfQ0xNVUxfTklfSU5URUwgaXMgbm90IHNldAoKIwoj
IENpcGhlcnMKIwpDT05GSUdfQ1JZUFRPX0FFUz1tCkNPTkZJR19DUllQVE9fQUVTX1g4Nl82ND1t
CiMgQ09ORklHX0NSWVBUT19BRVNfTklfSU5URUwgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX0FO
VUJJUz1tCkNPTkZJR19DUllQVE9fQVJDND1tCkNPTkZJR19DUllQVE9fQkxPV0ZJU0g9bQpDT05G
SUdfQ1JZUFRPX0NBTUVMTElBPW0KQ09ORklHX0NSWVBUT19DQVNUNT1tCkNPTkZJR19DUllQVE9f
Q0FTVDY9bQpDT05GSUdfQ1JZUFRPX0RFUz15CkNPTkZJR19DUllQVE9fRkNSWVBUPW0KQ09ORklH
X0NSWVBUT19LSEFaQUQ9bQojIENPTkZJR19DUllQVE9fU0FMU0EyMCBpcyBub3Qgc2V0CkNPTkZJ
R19DUllQVE9fU0FMU0EyMF9YODZfNjQ9bQpDT05GSUdfQ1JZUFRPX1NFRUQ9bQpDT05GSUdfQ1JZ
UFRPX1NFUlBFTlQ9bQpDT05GSUdfQ1JZUFRPX1RFQT1tCkNPTkZJR19DUllQVE9fVFdPRklTSD1t
CkNPTkZJR19DUllQVE9fVFdPRklTSF9DT01NT049bQpDT05GSUdfQ1JZUFRPX1RXT0ZJU0hfWDg2
XzY0PW0KCiMKIyBDb21wcmVzc2lvbgojCkNPTkZJR19DUllQVE9fREVGTEFURT1tCiMgQ09ORklH
X0NSWVBUT19aTElCIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0xaTyBpcyBub3Qgc2V0Cgoj
CiMgUmFuZG9tIE51bWJlciBHZW5lcmF0aW9uCiMKIyBDT05GSUdfQ1JZUFRPX0FOU0lfQ1BSTkcg
aXMgbm90IHNldApDT05GSUdfQ1JZUFRPX0hXPXkKIyBDT05GSUdfQ1JZUFRPX0RFVl9QQURMT0NL
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0RFVl9ISUZOXzc5NVggaXMgbm90IHNldApDT05G
SUdfSEFWRV9LVk09eQpDT05GSUdfVklSVFVBTElaQVRJT049eQojIENPTkZJR19LVk0gaXMgbm90
IHNldAojIENPTkZJR19WSE9TVF9ORVQgaXMgbm90IHNldAojIENPTkZJR19WSVJUSU9fUENJIGlz
IG5vdCBzZXQKIyBDT05GSUdfVklSVElPX0JBTExPT04gaXMgbm90IHNldAojIENPTkZJR19CSU5B
UllfUFJJTlRGIGlzIG5vdCBzZXQKCiMKIyBMaWJyYXJ5IHJvdXRpbmVzCiMKQ09ORklHX0JJVFJF
VkVSU0U9eQpDT05GSUdfR0VORVJJQ19GSU5EX0ZJUlNUX0JJVD15CkNPTkZJR19HRU5FUklDX0ZJ
TkRfTkVYVF9CSVQ9eQpDT05GSUdfR0VORVJJQ19GSU5EX0xBU1RfQklUPXkKQ09ORklHX0NSQ19D
Q0lUVD1tCkNPTkZJR19DUkMxNj15CkNPTkZJR19DUkNfVDEwRElGPXkKQ09ORklHX0NSQ19JVFVf
VD15CkNPTkZJR19DUkMzMj15CiMgQ09ORklHX0NSQzcgaXMgbm90IHNldApDT05GSUdfTElCQ1JD
MzJDPXkKQ09ORklHX1pMSUJfSU5GTEFURT15CkNPTkZJR19aTElCX0RFRkxBVEU9bQpDT05GSUdf
REVDT01QUkVTU19HWklQPXkKQ09ORklHX0hBU19JT01FTT15CkNPTkZJR19IQVNfSU9QT1JUPXkK
Q09ORklHX0hBU19ETUE9eQpDT05GSUdfTkxBVFRSPXkK
--000e0cd30a9271caac048a6b4fe8--
