Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab1DNRcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:32:53 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:35478
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266Ab1DNRcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:32:50 -0400
Date: Thu, 14 Apr 2011 19:32:39 +0200
From: Michael Guntsche <mike@it-loops.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Bug] Boot hangs with 2.6.39-rc[123]
Message-ID: <20110414191945@it-loops.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

Apparently all the 2.6.39-rc kernels up to current git HEAD hang on my setup
here during boot. They survive the initramfs step, but after or during the root
file system mount it just hangs.
This is a software RAID-5->LVM setup. The machine itself boots without
any problems with a 2.6.38 kernel.

The hardware:
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 1
model name	: Intel(R) Pentium(R) 4 CPU 1.70GHz
stepping	: 2
cpu MHz		: 1699.523
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pebs bts
bogomips	: 3399.04
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 32 bits virtual
power management:

I hooked up a working serial console to capture the boot messages...

As I said initramfs and kernel loads fine it also enters runlevel "S"

Linux version 2.6.39-rc3+ (root@gibson) (gcc version 4.5.2 (Debian 4.5.2-9) ) #2 Thu Apr 14 08:26:52 CEST 2011
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bffb0000 (usable)
 BIOS-e820: 00000000bffb0000 - 00000000bffc0000 (ACPI data)
 BIOS-e820: 00000000bffc0000 - 00000000bfff0000 (ACPI NVS)
 BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection missing in CPU!
DMI 2.3 present.
last_pfn = 0xbffb0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
found SMP MP-table at [c00ff780] ff780
init_memory_mapping: 0000000000000000-00000000377fe000
RAMDISK: 376ca000 - 37b5d000
Allocated new RAMDISK: 37237000 - 376c97de
Move RAMDISK from 00000000376ca000 - 0000000037b5c7dd to 37237000 - 376c97dd
ACPI: RSDP 000fad60 00021 (v02 ACPIAM)
ACPI: XSDT bffb0100 0003C (v01 A M I  OEMXSDT  12000513 MSFT 00000097)
ACPI: FACP bffb0290 000F4 (v03 A M I  OEMFACP  12000513 MSFT 00000097)
ACPI: DSDT bffb03f0 03763 (v01  A0049 A0049000 00000000 INTL 02002026)
ACPI: FACS bffc0000 00040
ACPI: APIC bffb0390 0005C (v01 A M I  OEMAPIC  12000513 MSFT 00000097)
ACPI: OEMB bffc0040 0003F (v01 A M I  OEMBIOS  12000513 MSFT 00000097)
2183MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x000bffb0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000bffb0
Using APIC driver default
ACPI: PM-Timer IO Port: 0x808
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at c0000000 (gap: c0000000:3fb80000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 780095
Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.39-rc3+ root=/dev/mapper/HotFuzz-root ro video=matroxfb:vesa:0x118,fv:90 console=ttyS0,115200 console=tty0
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:000bffb0)
Memory: 3110888k/3145408k available (2160k kernel code, 34068k reserved, 1241k data, 320k init, 2236104k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc1353000 - 0xc13a3000   ( 320 kB)
      .data : 0xc121c3a7 - 0xc1352b00   (1241 kB)
      .text : 0xc1000000 - 0xc121c3a7   (2160 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:288
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Fast TSC calibration using PIT
Detected 1699.419 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3398.83 BogoMIPS (lpj=6797676)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
mce: CPU supports 4 MCE banks
CPU: Intel(R) Pentium(R) 4 CPU 1.70GHz stepping 02
ACPI: Core revision 20110316
Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
... version:                0
... bit width:              40
... generic registers:      18
... value mask:             000000ffffffffff
... max period:             0000007fffffffff
... fixed-purpose events:   0
... event mask:             000000000003ffff
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  :  2243.000 MB/sec
xor: using function: pIII_sse (2243.000 MB/sec)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=2
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
raid6: int32x1    387 MB/s
raid6: int32x2    454 MB/s
raid6: int32x4    458 MB/s
raid6: int32x8    335 MB/s
raid6: mmxx1     1401 MB/s
raid6: mmxx2     1795 MB/s
raid6: sse1x1     925 MB/s
raid6: sse1x2    1453 MB/s
raid6: sse2x1    1837 MB/s
raid6: sse2x2    1793 MB/s
raid6: using algorithm sse2x1 (1837 MB/s)
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci 0000:00:00.0: Enabling MCH 'Overflow' Device
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:1e.0: PCI bridge to [bus 02-02] (subtractive decode)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15)
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
Switched to NOHz mode on CPU #0
system 00:09: [io  0x0680-0x06ff] has been reserved
system 00:09: [io  0x0290-0x0297] has been reserved
system 00:0a: [io  0x04d0-0x04d1] has been reserved
system 00:0a: [io  0x0800-0x087f] has been reserved
system 00:0a: [io  0x0480-0x04bf] has been reserved
system 00:0a: [mem 0xfed20000-0xfed8ffff] has been reserved
system 00:0a: [mem 0xffb00000-0xffbfffff] could not be reserved
system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0c: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0c: [mem 0x000c0000-0x000dffff] could not be reserved
system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0c: [mem 0x00100000-0xbffeffff] could not be reserved
system 00:0c: [mem 0xfff00000-0xffffffff] has been reserved
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:00:1f.1: BAR 5: assigned [mem 0xc0000000-0xc00003ff]
pci 0000:00:1f.1: BAR 5: set to [mem 0xc0000000-0xc00003ff] (PCI address [0xc0000000-0xc00003ff])
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem 0xfd800000-0xfe8fffff]
pci 0000:00:01.0:   bridge window [mem 0xf3f00000-0xf7efffff pref]
pci 0000:00:1e.0: PCI bridge to [bus 02-02]
pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1e.0:   bridge window [mem 0xfe900000-0xfeafffff]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 1, 8192 bytes)
UDP-Lite hash table entries: 512 (order: 1, 8192 bytes)
pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
Unpacking initramfs...
Freeing initrd memory: 4684k freed
highmem bounce pool size: 64 pages
msgmni has been set to 1717
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
ata_piix 0000:00:1f.2: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0xeff0 ctl 0xefe4 bmdma 0xef90 irq 18
ata4: SATA max UDMA/133 cmd 0xefa8 ctl 0xefe0 bmdma 0xef98 irq 18
sata_sil 0000:02:09.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
sata_sil 0000:02:09.0: Applying R_ERR on DMA activate FIS errata fix
scsi4 : sata_sil
scsi5 : sata_sil
scsi6 : sata_sil
scsi7 : sata_sil
ata5: SATA max UDMA/100 mmio m1024@0xfeafbc00 tf 0xfeafbc80 irq 21
ata6: SATA max UDMA/100 mmio m1024@0xfeafbc00 tf 0xfeafbcc0 irq 21
ata7: SATA max UDMA/100 mmio m1024@0xfeafbc00 tf 0xfeafbe80 irq 21
ata8: SATA max UDMA/100 mmio m1024@0xfeafbc00 tf 0xfeafbec0 irq 21
i8042: PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:02: RTC can wake from S4
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
md: raid1 personality registered for level 1
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
Registering the dns_resolver key type
Using IPI Shortcut mode
ata3.00: ATA-8: ST3500410SV, CV12, max UDMA/133
ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: ATA-7: SAMSUNG HD401LJ, ZZ100-15, max UDMA7
ata4.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      ST3500410SV      CV12 PQ: 0 ANSI: 5
ata4.00: configured for UDMA/133
sd 2:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD401LJ  ZZ10 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 781422768 512-byte logical blocks: (400 GB/372 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
 sda: sda1 sda2
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] Attached SCSI disk
 sdb: sdb1
sd 3:0:0:0: [sdb] Attached SCSI disk
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata5.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
ata5.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata5.00: configured for UDMA/100
scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
sd 4:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2
sd 4:0:0:0: [sdc] Attached SCSI disk
Refined TSC clocksource calibration: 1699.182 MHz.
Switching to clocksource tsc
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata6.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
ata6.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata6.00: configured for UDMA/100
scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
sd 5:0:0:0: [sdd] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 5:0:0:0: [sdd] Write Protect is off
sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1 sdd2
sd 5:0:0:0: [sdd] Attached SCSI disk
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata7.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
ata7.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata7.00: configured for UDMA/100
scsi 6:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
sd 6:0:0:0: [sde] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 6:0:0:0: [sde] Write Protect is off
sd 6:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1 sde2
sd 6:0:0:0: [sde] Attached SCSI disk
ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata8.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
ata8.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata8.00: configured for UDMA/100
scsi 7:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
sd 7:0:0:0: [sdf] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 7:0:0:0: [sdf] Write Protect is off
sd 7:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdf: sdf1 sdf2
sd 7:0:0:0: [sdf] Attached SCSI disk
Freeing unused kernel memory: 320k freed
matroxfb 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
matroxfb: Matrox G550 detected
PInS memtype = 5
matroxfb: MTRR's turned on
matroxfb: 1024x768x32bpp (virtual: 1024x4096)
matroxfb: framebuffer at 0xF4000000, mapped to 0xf8180000, size 33554432
Console: switching to colour frame buffer device 128x48
fb0: MATROX frame buffer device
NET: Registered protocol family 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
Floppy drive(s): fd0 is 1.44M
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfebff800
skge 0000:02:05.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
skge: 1.13 addr 0xfeafc000 irq 22 chip Yukon-Lite rev 9
FDC 0 is a post-1991 82077
skge 0000:02:05.0: eth0: addr 00:13:d4:4f:a2:dc
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
firewire_ohci 0000:02:0b.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000eec0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
firewire_ohci: Added fw-ohci device 0000:02:0b.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x2
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000ef00
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 2-1: new low speed USB device number 2 using uhci_hcd
firewire_core: created device fw0: GUID 00000000005000d2, S800
input: Fujitsu Siemens Computers Fujitsu Siemens Computers GmbH USB/PS2 Keyboard v1.1 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input0
generic-usb 0003:08D4:0006.0001: input: USB HID v1.10 Keyboard [Fujitsu Siemens Computers Fujitsu Siemens Computers GmbH USB/PS2 Keyboard v1.1] on usb-0000:00:1d.0-1/input0
input: Fujitsu Siemens Computers Fujitsu Siemens Computers GmbH USB/PS2 Keyboard v1.1 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.1/input/input1
generic-usb 0003:08D4:0006.0002: input: USB HID v1.10 Device [Fujitsu Siemens Computers Fujitsu Siemens Computers GmbH USB/PS2 Keyboard v1.1] on usb-0000:00:1d.0-1/input1
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
Btrfs loaded
md: md0 stopped.
md: bind<sdd1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sda1>
md: bind<sdc1>
bio: create slab <bio-1> at 1
md/raid1:md0: active with 5 out of 5 mirrors
md0: detected capacity change from 0 to 57475072
 md0:
md: md1 stopped.
md: bind<sdd2>
md: bind<sde2>
md: bind<sdf2>
md: bind<sda2>
md: bind<sdc2>
md/raid:md1: device sdc2 operational as raid disk 0
md/raid:md1: device sda2 operational as raid disk 4
md/raid:md1: device sdf2 operational as raid disk 3
md/raid:md1: device sde2 operational as raid disk 2
md/raid:md1: device sdd2 operational as raid disk 1
md/raid:md1: allocated 5258kB
md/raid:md1: raid level 5 active with 5 out of 5 devices, algorithm 2
created bitmap (4 pages) for device md1
md1: bitmap initialized from disk: read 1/1 pages, set 0 bits
md1: detected capacity change from 0 to 2000189128704
 md1: unknown partition table
device fsid d64bac2f4cf259ba-326da6041632dd9c devid 1 transid 557 /dev/sdb1
end_request: I/O error, dev fd0, sector 0
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (dm-0): mounted filesystem with writeback data mode
udev[1333]: starting version 167
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
ACPI: Power Button [PWRF]
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
intel_rng: FWH not detected
Linux agpgart interface v0.103
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
agpgart-intel 0000:00:00.0: Intel 865 Chipset
agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
intel8x0: white list rate for 1043:80f3 is 48000

Here the mount hangs. It does show /dev/root ... Done but since I use
concurrent mounts I think the done is from an earlier task.


SysRq : Show Blocked State
  task                PC stack   pid father
mount           D f4cfde00     0  1765   1745 0x00000000
 f4c23dd0 00000086 f44aa800 f4cfde00 f44aa500 0000004d f4c23d74 c11a35f9
 f4c23d80 f4c23dd0 f4431760 8416416f 00000004 f4431760 00000041 ffffffff
 00000001 00000008 00100800 f4431760 00000008 00000000 e8da47f8 00000000
Call Trace:
 [<c11a35f9>] ? dm_request+0x8a/0xf6
 [<c105c63b>] ? mempool_alloc_slab+0xe/0x10
 [<c12197b9>] io_schedule+0x2b/0x42
 [<c109cbad>] sleep_on_buffer+0x8/0xc
 [<c1219ad3>] __wait_on_bit+0x43/0x60
 [<c109cba5>] ? __wait_on_buffer+0x27/0x27
 [<c1219b46>] out_of_line_wait_on_bit+0x56/0x5e
 [<c109cba5>] ? __wait_on_buffer+0x27/0x27
 [<c1038e76>] ? autoremove_wake_function+0x36/0x36
 [<c109cba3>] __wait_on_buffer+0x25/0x27
 [<c109d367>] __sync_dirty_buffer+0x6b/0x8b
 [<c109d394>] sync_dirty_buffer+0xd/0xf
 [<fa8d7d80>] ext3_commit_super.clone.24+0x4b/0xb0 [ext3]
 [<c10ed9c7>] ? match_token+0xfd/0x1a2
 [<fa8d8585>] ext3_setup_super+0xb4/0x20d [ext3]
 [<fa8d776d>] ? parse_options+0x32/0x4b0 [ext3]
 [<c121a2e0>] ? __mutex_lock_slowpath+0x124/0x1b2
 [<c121a379>] ? mutex_lock+0xb/0x22
 [<fa8da100>] ext3_remount+0x1df/0x27e [ext3]
 [<fa8d9f21>] ? ext3_fill_super+0x1843/0x1843 [ext3]
 [<c10811d9>] do_remount_sb+0x7d/0xf6
 [<c1094379>] do_mount+0x44f/0x633
 [<c1093e9e>] ? copy_mount_options+0x8d/0xee
 [<c10947bf>] sys_mount+0x66/0x9b
 [<c121af1d>] syscall_call+0x7/0xb
Sched Debug Version: v0.10, 2.6.39-rc3+ #2
ktime                                   : 37933.056186
sched_clk                               : 38008.731563
cpu_clk                                 : 37806.036844
jiffies                                 : 4294901746
sched_clock_stable                      : 0

sysctl_sched
  .sysctl_sched_latency                    : 6.000000
  .sysctl_sched_min_granularity            : 0.750000
  .sysctl_sched_wakeup_granularity         : 1.000000
  .sysctl_sched_child_runs_first           : 0
  .sysctl_sched_features                   : 7279
  .sysctl_sched_tunable_scaling            : 1 (logaritmic)

cpu#0, 1699.419 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 19596
  .nr_load_updates               : 3167
  .nr_uninterruptible            : 1
  .next_balance                  : 0.000000
  .curr->pid                     : 0
  .clock                         : 37680.038704
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 4
  .cpu_load[4]                   : 17
  .yld_count                     : 3
  .sched_switch                  : 0
  .sched_count                   : 19620
  .sched_goidle                  : 1555
  .ttwu_count                    : 1
  .ttwu_local                    : 1
  .bkl_count                     : 0

cfs_rq[0]:
  .exec_clock                    : 6548.484099
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 6269.914000
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0

rt_rq[0]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 200.624789
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

SysRq : Emergency Sync
SysRq : Emergency Sync
SysRq : Emergency Sync
SysRq : Emergency Remount R/O
SysRq : Resetting

This problem started somewhere between 2.6.38 and 2.6.39-rc1 but due to
the fast number of commits bisecting everything would take a long time. 
I am thinking of only bisecting the block or dm layer but maybe someone
has a better idea or a fix already. :)

Please tell me if you need additional information about my setup, etc.


Kind regards,
Michael Guntsche

