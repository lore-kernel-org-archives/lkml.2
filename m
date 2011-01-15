Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1AOLlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 06:41:23 -0500
Received: from lucidpixels.com ([75.144.35.66]:45344 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab1AOLlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 06:41:21 -0500
Date: Sat, 15 Jan 2011 06:41:20 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-raid@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: ata8.00: irq_stat 0xffffffff, unknown FIS / HSM violation?
Message-ID: <alpine.DEB.2.00.1101150638440.8724@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently I replaced some 750GB disks with 2TB drives and using mdadm & 
software RAID-6, on two of the disks (ata7,ata8), on the same controller, 
I also added two disks to an on-board gigabyte controller, which uses the 
jmicron chipset, it is configured as AHCI in the BIOS, should I configure 
it as IDE?

I see the following below..

Does anyone know what is causing this?

[35427.980287] ata8.00: exception Emask 0x32 SAct 0x0 SErr 0x0 action 0xe frozen
[35427.980291] ata8.00: irq_stat 0xffffffff, unknown FIS 00000000 00000000 00000000 00000000, host bus 
[35427.980294] ata8.00: failed command: READ DMA EXT
[35427.980299] ata8.00: cmd 25/00:00:00:88:e1/00:04:16:00:00/e0 tag 0 dma 524288 in
[35427.980300]          res 50/00:00:ff:8b:e1/00:00:16:00:00/e0 Emask 0x32 (host bus error)
[35427.980303] ata8.00: status: { DRDY }
[35427.980307] ata8: hard resetting link
[35428.703074] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[35428.713280] ata8.00: configured for UDMA/133
[35428.713293] ata8: EH complete
[35676.319203] ata8.00: exception Emask 0x32 SAct 0x0 SErr 0x0 action 0xe frozen
[35676.319208] ata8.00: irq_stat 0xffffffff, unknown FIS 00000000 00000000 00000000 00000000, host bus 
[35676.319211] ata8.00: failed command: READ DMA EXT
[35676.319216] ata8.00: cmd 25/00:00:00:34:79/00:04:18:00:00/e0 tag 0 dma 524288 in
[35676.319217]          res 50/00:00:ff:37:79/00:00:18:00:00/e0 Emask 0x32 (host bus error)
[35676.319220] ata8.00: status: { DRDY }
[35676.319223] ata8: hard resetting link
[35677.044041] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[35677.052903] ata8.00: configured for UDMA/133
[35677.052917] ata8: EH complete
[35850.290143] ata7: illegal qc_active transition (00000001->ffffffff)
[35850.290199] ata7.00: exception Emask 0x2 SAct 0x0 SErr 0x0 action 0x6 frozen
[35850.290203] ata7.00: failed command: READ DMA EXT
[35850.290208] ata7.00: cmd 25/00:00:00:cb:95/00:04:19:00:00/e0 tag 0 dma 524288 in
[35850.290209]          res 50/00:00:ff:ce:95/00:00:19:00:00/e0 Emask 0x2 (HSM violation)
[35850.290211] ata7.00: status: { DRDY }
[35850.290214] ata7: hard resetting link
[35850.595048] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[35850.603626] ata7.00: configured for UDMA/133
[35850.603637] ata7: EH complete


# cat /proc/interrupts
            CPU0       CPU1       CPU2       CPU3
   0:        134         30          5         72   IO-APIC-edge      timer
   1:       4372          7          5       1971   IO-APIC-edge      i8042
   6:          1          1          2          1   IO-APIC-edge      floppy
   8:          1          0          0          0   IO-APIC-edge      rtc0
   9:          0          0          0          0   IO-APIC-fasteoi   acpi
  12:      27097         27         29       9917   IO-APIC-edge      i8042
  16:    8372549         47         45     219280   IO-APIC-fasteoi   ahci, uhci_hcd:usb3
  17:    7728904         57         65     601137   IO-APIC-fasteoi   sata_sil24, pata_jmicron
  18:        175        258         15        118   IO-APIC-fasteoi   firewire_ohci, ehci_hcd:usb1, uhci_hcd:usb5, uhci_hcd:usb8
  19:    7607987        228     656375        215   IO-APIC-fasteoi   sata_sil24, uhci_hcd:usb7, eth1
  21:      37460        158         99       3002   IO-APIC-fasteoi   uhci_hcd:usb4
  23:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb6
  40:   15855310    9115190    3156452    8222077   PCI-MSI-edge      ahci
  41:      72697         40     981886         37   PCI-MSI-edge      eth0
  42:   75050166         10          6      16828   PCI-MSI-edge      eth3-TxRx-0
  43:      24424      10996         45         41   PCI-MSI-edge      eth3-TxRx-1
  44:       2220      19532         47      13965   PCI-MSI-edge      eth3-TxRx-2
  45:      51675   17913287      48901  133968374   PCI-MSI-edge      eth3-TxRx-3
  46:          1          0          0          1   PCI-MSI-edge      eth3:lsc
  47:      10120         74         75       8950   PCI-MSI-edge      hda_intel
NMI:      15289      13689      13586      13325   Non-maskable interrupts
LOC:   36178162   36050592   36069446   36123166   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:      15289      13689      13586      13325   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RES:    1014433    1363410    2039796    2327312   Rescheduling interrupts
CAL:    4357727   30245919       6541       5027   Function call interrupts
TLB:      20359      24898      30093      32351   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:        120        120        120        120   Machine check polls
ERR:          3
MIS:          0

# lspci
# lspci
00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM Controller (rev 02)
00:01.0 PCI bridge: Intel Corporation 82G33/G31/P35/P31 Express PCI Express Root Port (rev 02)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 02)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 3 (rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 02)
00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
00:1f.0 ISA bridge: Intel Corporation 82801IR (ICH9R) LPC Interface Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)
01:00.0 Ethernet controller: Intel Corporation 82598EB 10-Gigabit AT2 Server Adapter (rev 01)
03:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)
04:00.0 Ethernet controller: Intel Corporation 82572EI Gigabit Ethernet Controller (Copper) (rev 06)
05:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)
06:00.0 SATA controller: JMicron Technology Corp. JMB362/JMB363 Serial ATA Controller (rev 02)
06:00.1 IDE interface: JMicron Technology Corp. JMB362/JMB363 Serial ATA Controller (rev 02)
07:00.0 VGA compatible controller: nVidia Corporation NV44A [GeForce 6200] (rev a1)
07:01.0 PCI bridge: Digital Equipment Corporation DECchip 21152 (rev 03)
07:06.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 Controller (PHY/Link)
08:04.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 05)
08:05.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 05)

