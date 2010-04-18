Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab0DRWjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 18:39:14 -0400
Received: from pc175e.fzu.cz ([147.231.127.175]:55091 "EHLO postak-1.fzu.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab0DRWjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 18:39:11 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Apr 2010 18:39:10 EDT
Message-ID: <4BCB87E2.4090807@gentoo.org>
Date: Mon, 19 Apr 2010 00:29:54 +0200
From: =?ISO-8859-1?Q?Jan_Kundr=E1t?= <jkt@gentoo.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: boot device order troubleshooting without an initrd
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig42EA94BDC6A32B2545CBEC5C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig42EA94BDC6A32B2545CBEC5C
Content-Type: multipart/mixed;
 boundary="------------040603080400010703050907"

This is a multi-part message in MIME format.
--------------040603080400010703050907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi folks,
I'm looking for a way to pass a correct "root" parameter to the kernel
from the bootloader, independently on the number of attached disks. My
machine (VIA EPIA SN-1800) has four SATA ports and one CF card slot. The
CF slot is visible as an IDE device. The BIOS is configured for booting
from the CF card, and Grub2 has absolutely no problems booting the kernel=
=2E

The problem I'm facing is that if there are no SATA disks attached, my
CF card gets called /dev/sda, while if I attach two SATA drives, the CF
card gets called /dev/sdc. I can solve that "in userspace" without much
problem thanks to udev's names like
/dev/disk/by-id/scsi-SATA_ELITE_PRO_CF_..., but I have no idea about how
to pass the correct "root" argument to the kernel. If I use
"root=3D/dev/sda1", kernel will boot if and only if I don't have any SATA=

devices attached; on the other hand, having two SATA drives attached
requires "root=3D/dev/sdc1". I've tried to use the by-id naming, but it i=
s
apparently provided by udev much later in the "boot process", and the
document by gregkh [1] doesn't mention it, either.

I have disabled modules, and don't use initrd. Such a setup has worked
for me for a few years. Not having modules enabled makes me feel
"safer", and I have not ever needed an initrd, so far. If I was using
initrd, I'd probably be able to use the "root=3DLABEL=3Dfoo" stuff.

Relevant part of `lspci`:

00:0f.0 SATA controller: VIA Technologies, Inc. SATA RAID Controller
(rev 20)
00:0f.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 07)

I'm attaching full dmesg, as the output seems to be interleaved from
more drivers, and I'm afraid I'd skip something if I tried to include
only relevant parts. The kernel I'm using is 2.6.32-gentoo-r1.

What I'm looking for is an advice if it's possible to tell kernel to
"use the BIOS-provided HDD ordering". I suspect I'm likely going to be
told "you are supposed to use initrd"; if that is the case, I'd love to
see a technical argument about why.

Anyway, I'm looking for any input. I'd much appreciate if you could Cc
me on replies, as I'm not subscribed to the list.

Have fun,
-jkt

[1]
http://www.kernel.org/pub/linux/kernel/people/gregkh/lkn/lkn_pdf/ch09.pdf=


--=20
cd /local/pub && more beer > /dev/mouth

--------------040603080400010703050907
Content-Type: text/plain;
 name="dmesg-plejtvak"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="dmesg-plejtvak"

Linux version 2.6.32-gentoo-r1 (root@plejtvak) (gcc version 4.3.4 (Gentoo=
 4.3.4 p1.0, pie-10.1.5) ) #2 Wed Apr 14 01:29:36 CEST 2010
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009b400 (usable)
 BIOS-e820: 000000000009b400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dbeb0000 (usable)
 BIOS-e820: 00000000dbeb0000 - 00000000dbebe000 (ACPI data)
 BIOS-e820: 00000000dbebe000 - 00000000dbf00000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fecc0000 - 00000000fecc1000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
DMI 2.3 present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) =3D=3D> (=
reserved)
last_pfn =3D 0xdbeb0 max_arch_pfn =3D 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-DFFFF uncachable
  E0000-E3FFF write-protect
  E4000-EFFFF write-through
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 080000000 mask FC0000000 write-back
  2 base 0C0000000 mask FF0000000 write-back
  3 base 0D0000000 mask FF8000000 write-back
  4 base 0D8000000 mask FFC000000 write-back
  5 base 0DBF00000 mask FFFF00000 uncachable
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 01c00000
init_memory_mapping: 0000000000000000-00000000377fe000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037400000 page 2M
 0037400000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 10000-15000
ACPI: RSDP 000f9460 00024 (v02 ACPIAM)
ACPI: XSDT dbeb0100 0004C (v01 060109 XSDT1205 20090601 MSFT 00000097)
ACPI: FACP dbeb0290 000F4 (v03 060109 FACP1205 20090601 MSFT 00000097)
ACPI: DSDT dbeb0430 0459E (v01  1ADTQ 1ADTQ003 00000003 INTL 20051117)
ACPI: FACS dbebe000 00040
ACPI: APIC dbeb0390 00060 (v01 060109 APIC1205 20090601 MSFT 00000097)
ACPI: MCFG dbeb03f0 0003C (v01 060109 OEMMCFG  20090601 MSFT 00000097)
ACPI: OEMB dbebe040 00061 (v01 060109 OEMB1205 20090601 MSFT 00000097)
ACPI: SSDT dbebe0b0 0023A (v01    AMI   P001PM 00000001 INTL 20051117)
ACPI: Local APIC address 0xfee00000
2630MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
  node 0 low ram: 00000000 - 377fe000
  node 0 bootmap 00011000 - 00017f00
(6 early reservations) =3D=3D> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000000000 - 000=
0001000]
  #1 [0001000000 - 00017387c0]    TEXT DATA BSS =3D=3D> [0001000000 - 000=
17387c0]
  #2 [000009b400 - 0000100000]    BIOS reserved =3D=3D> [000009b400 - 000=
0100000]
  #3 [0001739000 - 00017401c1]              BRK =3D=3D> [0001739000 - 000=
17401c1]
  #4 [0000010000 - 0000011000]          PGTABLE =3D=3D> [0000010000 - 000=
0011000]
  #5 [0000011000 - 0000018000]          BOOTMAP =3D=3D> [0000011000 - 000=
0018000]
found SMP MP-table at [c00ff780] ff780
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x000dbeb0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009b
    0: 0x00000100 -> 0x000dbeb0
On node 0 totalpages: 900667
free_area_init_node: node 0, pgdat c1650b60, node_mem_map c1742200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3947 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 5262 pages used for memmap
  HighMem zone: 668196 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 3, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x02] address[0xfecc0000] gsi_base[24])
IOAPIC[1]: apic_id 2, version 3, address 0xfecc0000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 2 I/O APICs
Using ACPI (MADT) for SMP configuration information
nr_irqs_gsi: 48
Allocating PCI resources starting at dbf00000 (gap: dbf00000:22d00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8936=
29
Kernel command line: BOOT_IMAGE=3D/boot/bzImage-2.6.32-gentoo-r1 root=3D/=
dev/sdc1 ro
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:000dbeb0)
Memory: 3565388k/3603136k available (4911k kernel code, 36424k reserved, =
1599k data, 356k init, 2693832k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa4000 - 0xfffff000   ( 364 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc165c000 - 0xc16b5000   ( 356 kB)
      .data : 0xc14cbc29 - 0xc165b860   (1599 kB)
      .text : 0xc1000000 - 0xc14cbc29   (4911 kB)
Checking if this processor honours the WP bit even in supervisor mode...O=
k.
SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1,=
 Nodes=3D1
Hierarchical RCU implementation.
NR_IRQS:288
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
Fast TSC calibration using PIT
Detected 1817.678 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.=
=2E 3635.35 BogoMIPS (lpj=3D18176780)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 128K (64 bytes/line)
CPU: Centaur VIA C7 Processor 1800MHz stepping 00
Checking 'hlt' instruction... OK.
ACPI: Core revision 20090903
=2E.TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
khelper used greatest stack depth: 7452 bytes left
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3D3
PCI: Using configuration type 1 for base access
khelper used greatest stack depth: 7148 bytes left
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG for extended config space
ACPI: Power Resource [SVPR] (on)
ACPI Warning: Incorrect checksum in table [OEMB] - 0A, should be 07 (2009=
0903/tbutils-314)
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio pref: [0xfc000000-0xfdffffff]
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:0f.0: reg 10 io port: [0xdc00-0xdc07]
pci 0000:00:0f.0: reg 14 io port: [0xd880-0xd883]
pci 0000:00:0f.0: reg 18 io port: [0xd800-0xd807]
pci 0000:00:0f.0: reg 1c io port: [0xd480-0xd483]
pci 0000:00:0f.0: reg 20 io port: [0xd400-0xd40f]
pci 0000:00:0f.0: reg 24 32bit mmio: [0xfafffc00-0xfaffffff]
pci 0000:00:0f.0: PME# supported from D3hot
pci 0000:00:0f.0: PME# disabled
pci 0000:00:0f.1: reg 20 io port: [0xfc00-0xfc0f]
pci 0000:00:10.0: reg 20 io port: [0xcc00-0xcc1f]
pci 0000:00:10.0: supports D1 D2
pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.0: PME# disabled
pci 0000:00:10.1: reg 20 io port: [0xd000-0xd01f]
pci 0000:00:10.1: supports D1 D2
pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.1: PME# disabled
pci 0000:00:10.2: reg 20 io port: [0xd080-0xd09f]
pci 0000:00:10.2: supports D1 D2
pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.2: PME# disabled
pci 0000:00:10.4: reg 10 32bit mmio: [0xfafff800-0xfafff8ff]
pci 0000:00:10.4: supports D1 D2
pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.4: PME# disabled
pci 0000:00:12.0: reg 10 io port: [0xc800-0xc8ff]
pci 0000:00:12.0: reg 14 32bit mmio: [0xfafff400-0xfafff4ff]
pci 0000:00:12.0: supports D1 D2
pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:12.0: PME# disabled
pci 0000:01:00.0: reg 10 32bit mmio pref: [0xf4000000-0xf7ffffff]
pci 0000:01:00.0: reg 14 32bit mmio: [0xfb000000-0xfbffffff]
pci 0000:01:00.0: reg 30 32bit mmio pref: [0xfe9f0000-0xfe9fffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:00:01.0: bridge 32bit mmio: [0xfb000000-0xfe9fffff]
pci 0000:00:01.0: bridge 32bit mmio pref: [0xf4000000-0xf7ffffff]
pci 0000:00:02.0: bridge 64bit mmio pref: [0xf9f00000-0xf9ffffff]
pci 0000:03:00.0: reg 10 io port: [0xe800-0xe8ff]
pci 0000:03:00.0: reg 14 64bit mmio: [0xfeaffc00-0xfeaffcff]
pci 0000:03:00.0: supports D1 D2
pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:03.0: bridge io port: [0xe000-0xefff]
pci 0000:00:03.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBPG._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:80)
pci 0000:80:00.0: PME# supported from D0 D3hot D3cold
pci 0000:80:00.0: PME# disabled
pci 0000:80:00.1: PME# supported from D0 D3hot D3cold
pci 0000:80:00.1: PME# disabled
pci 0000:80:01.0: reg 10 32bit mmio: [0xfebfc000-0xfebfffff]
pci 0000:80:01.0: PME# supported from D0 D3hot D3cold
pci 0000:80:01.0: PME# disabled
pci_bus 0000:80: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disab=
led.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disab=
led.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disab=
led.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disab=
led.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,owns=3Dio+mem,loc=
ks=3Dnone
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pci 0000:00:00.0: BAR 0: address space collision on of device [0xfc000000=
-0xfdffffff]
pci 0000:00:00.0: BAR 0: can't allocate resource
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:05: IRQ 3 override to edge, high
pnp 00:06: IRQ 3 override to edge, high
pnp 00:0b: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 0 (0x0-0x=
1ffffff), disabling
pnp 00:0b: mem resource (0xc0000-0xcffff) overlaps 0000:00:00.0 BAR 0 (0x=
0-0x1ffffff), disabling
pnp 00:0b: mem resource (0xe0000-0xfffff) overlaps 0000:00:00.0 BAR 0 (0x=
0-0x1ffffff), disabling
pnp 00:0b: mem resource (0x100000-0xdbefffff) overlaps 0000:00:00.0 BAR 0=
 (0x0-0x1ffffff), disabling
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
system 00:07: ioport range 0x162e-0x162f has been reserved
system 00:07: ioport range 0xa00-0xa7f has been reserved
system 00:08: ioport range 0x3e0-0x3e7 has been reserved
system 00:08: ioport range 0x4d0-0x4d1 has been reserved
system 00:08: ioport range 0x800-0x87f has been reserved
system 00:08: ioport range 0x400-0x41f has been reserved
system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0b: iomem range 0xfec00000-0xffffffff could not be reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: 0xfb000000-0xfe9fffff
pci 0000:00:01.0:   PREFETCH window: 0xf4000000-0xf7ffffff
pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
pci 0000:00:02.0:   IO window: 0x2000-0x2fff
pci 0000:00:02.0:   MEM window: 0xdc000000-0xdc3fffff
pci 0000:00:02.0:   PREFETCH window: 0x000000f9f00000-0x000000f9ffffff
pci 0000:00:03.0: PCI bridge, secondary bus 0000:03
pci 0000:00:03.0:   IO window: 0xe000-0xefff
pci 0000:00:03.0:   MEM window: 0xfea00000-0xfeafffff
pci 0000:00:03.0:   PREFETCH window: 0x000000dc400000-0x000000dc5fffff
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:02.0: enabling device (0106 -> 0107)
pci 0000:00:02.0: PCI INT A -> GSI 27 (level, low) -> IRQ 27
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:03.0: PCI INT A -> GSI 31 (level, low) -> IRQ 31
pci 0000:00:03.0: setting latency timer to 64
pci 0000:80:00.0: PCI bridge, secondary bus 0000:82
pci 0000:80:00.0:   IO window: disabled
pci 0000:80:00.0:   MEM window: disabled
pci 0000:80:00.0:   PREFETCH window: disabled
pci 0000:80:00.1: PCI bridge, secondary bus 0000:81
pci 0000:80:00.1:   IO window: disabled
pci 0000:80:00.1:   MEM window: disabled
pci 0000:80:00.1:   PREFETCH window: disabled
pci 0000:80:00.0: setting latency timer to 64
pci 0000:80:00.1: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 1 mem: [0xfb000000-0xfe9fffff]
pci_bus 0000:01: resource 2 pref mem [0xf4000000-0xf7ffffff]
pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:02: resource 1 mem: [0xdc000000-0xdc3fffff]
pci_bus 0000:02: resource 2 pref mem [0xf9f00000-0xf9ffffff]
pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
pci_bus 0000:03: resource 1 mem: [0xfea00000-0xfeafffff]
pci_bus 0000:03: resource 2 pref mem [0xdc400000-0xdc5fffff]
pci_bus 0000:80: resource 0 io:  [0x00-0xffff]
pci_bus 0000:80: resource 1 mem: [0x000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:00.0: MSI quirk detected; MSI disabled
pci 0000:00:01.0: disabling DAC on VIA PCI bridge
pci 0000:00:10.0: uhci_check_and_reset_hc: legsup =3D 0x8030
pci 0000:00:10.0: Performing full reset
pci 0000:00:10.1: uhci_check_and_reset_hc: legsup =3D 0x8030
pci 0000:00:10.1: Performing full reset
pci 0000:00:10.2: uhci_check_and_reset_hc: legsup =3D 0x8030
pci 0000:00:10.2: Performing full reset
pci 0000:00:10.4: EHCI: BIOS handoff
pci 0000:01:00.0: Boot video device
eps: Detected VIA Model D C7
eps: Current voltage =3D 1196mV
eps: Current multiplier =3D 9
eps: Highest voltage =3D 1196mV
eps: Highest multiplier =3D 9
eps: Lowest voltage =3D 956mV
eps: Lowest multiplier =3D 4
microcode: no support for this CPU vendor
audit: initializing netlink socket (disabled)
type=3D2000 audit(1271627252.332:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
khelper used greatest stack depth: 7144 bytes left
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Slow work thread pool: Starting up
Slow work thread pool: Ready
NTFS driver 2.1.29 [Flags: R/W].
SGI XFS with ACLs, security attributes, large block/inode numbers, no deb=
ug enabled
msgmni has been set to 1703
cryptomgr_test used greatest stack depth: 6868 bytes left
cryptomgr_test used greatest stack depth: 6344 bytes left
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler cfq registered (default)
pcieport 0000:00:02.0: setting latency timer to 64
pcieport 0000:00:03.0: setting latency timer to 64
pcieport 0000:80:00.0: setting latency timer to 64
pcieport 0000:80:00.1: setting latency timer to 64
Non-volatile memory driver v1.3
VIA RNG detected
input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/=
input0
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/=
input1
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
processor LNXCPU:00: registered as cooling_device0
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Marking TSC unstable due to cpufreq changes
Switching to clocksource acpi_pm
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 3) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq =3D 3) is a 16550A
00:06: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
brd: module loaded
loop: module loaded
Loading iSCSI transport class v2.0-870.
ahci 0000:00:0f.0: version 3.0
ahci 0000:00:0f.0: PCI INT B -> GSI 21 (level, low) -> IRQ 21
ahci 0000:00:0f.0: controller can't do NCQ, turning off CAP_NCQ
ahci 0000:00:0f.0: controller can't do PMP, turning off CAP_PMP
ahci 0000:00:0f.0: PCI: Disallowing DAC for device
ahci 0000:00:0f.0: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl SATA m=
ode
ahci 0000:00:0f.0: flags: 64bit pm led clo pio slum part=20
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xfafffc00 port 0xfafffd00 irq 21
ata2: SATA max UDMA/133 abar m1024@0xfafffc00 port 0xfafffd80 irq 21
ata3: SATA max UDMA/133 irq_stat 0x00400040, connection status changed ir=
q 21
ata4: SATA max UDMA/133 irq_stat 0x00400040, connection status changed ir=
q 21
pata_via 0000:00:0f.1: version 0.3.4
scsi4 : pata_via
scsi5 : pata_via
ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
via-rhine 0000:00:12.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
eth0: VIA Rhine II at 0xfafff400, 00:40:63:fa:c8:e8, IRQ 23.
eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link 45e=
1.
VIA Networking Velocity Family Gigabit Ethernet Adapter Driver Ver. 1.14
Copyright (c) 2002, 2003 VIA Networking Technologies, Inc.
Copyright (c) 2004 Red Hat Inc.
via-velocity 0000:03:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
via-velocity 0000:03:00.0: setting latency timer to 64
eth1: VIA Networking Velocity Family Gigabit Ethernet Adapter
eth1: Ethernet Address: 00:40:63:FA:C8:E9
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 60 qtd 96 itd 160 sitd 96
ehci_hcd 0000:00:10.4: PCI INT C -> GSI 22 (level, low) -> IRQ 22
ehci_hcd 0000:00:10.4: EHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.4: reset hcs_params 0x103206 dbg=3D1 cc=3D3 pcc=3D2 o=
rdered !ppc ports=3D6
ehci_hcd 0000:00:10.4: reset hcc_params 6872 thresh 7 uframes 256/512/102=
4
ehci_hcd 0000:00:10.4: debug port 1
ehci_hcd 0000:00:10.4: reset command 080002 (park)=3D0 ithresh=3D8 period=
=3D1024 Reset HALT
ehci_hcd 0000:00:10.4: MWI active
ehci_hcd 0000:00:10.4: supports USB remote wakeup
ehci_hcd 0000:00:10.4: irq 22, io mem 0xfafff800
ehci_hcd 0000:00:10.4: reset command 080002 (park)=3D0 ithresh=3D8 period=
=3D1024 Reset HALT
ehci_hcd 0000:00:10.4: init command 010009 (park)=3D0 ithresh=3D1 period=3D=
256 RUN
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
usb usb1: default language 0x0409
usb usb1: udev 1, busnum 1, minor =3D 0
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.32-gentoo-r1 ehci_hcd
usb usb1: SerialNumber: 0000:00:10.4
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:10.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:10.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: detected 2 ports
uhci_hcd 0000:00:10.0: uhci_check_and_reset_hc: cmd =3D 0x0000
uhci_hcd 0000:00:10.0: Performing full reset
uhci_hcd 0000:00:10.0: supports USB remote wakeup
uhci_hcd 0000:00:10.0: irq 20, io base 0x0000cc00
usb usb2: default language 0x0409
usb usb2: udev 1, busnum 2, minor =3D 128
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.32-gentoo-r1 uhci_hcd
usb usb2: SerialNumber: 0000:00:10.0
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:10.1: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:10.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: detected 2 ports
uhci_hcd 0000:00:10.1: uhci_check_and_reset_hc: cmd =3D 0x0000
uhci_hcd 0000:00:10.1: Performing full reset
uhci_hcd 0000:00:10.1: supports USB remote wakeup
uhci_hcd 0000:00:10.1: irq 22, io base 0x0000d000
usb usb3: default language 0x0409
usb usb3: udev 1, busnum 3, minor =3D 256
usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.32-gentoo-r1 uhci_hcd
usb usb3: SerialNumber: 0000:00:10.1
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:10.2: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: detected 2 ports
uhci_hcd 0000:00:10.2: uhci_check_and_reset_hc: cmd =3D 0x0000
uhci_hcd 0000:00:10.2: Performing full reset
uhci_hcd 0000:00:10.2: supports USB remote wakeup
uhci_hcd 0000:00:10.2: irq 21, io base 0x0000d080
usb usb4: default language 0x0409
usb usb4: udev 1, busnum 4, minor =3D 384
usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb4: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.32-gentoo-r1 uhci_hcd
usb usb4: SerialNumber: 0000:00:10.2
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
Driver 'rtc_cmos' needs updating - please use bus_type methods
rtc_cmos 00:02: RTC can wake from S4
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@red=
hat.com
cpuidle: using governor ladder
cpuidle: using governor menu
padlock: Using VIA PadLock ACE for AES algorithm.
padlock: Using VIA PadLock ACE for SHA1/SHA256 algorithms.
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.21.
ALSA device list:
  No soundcards found.
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 10
ip6_tables: (C) 2000-2006 Netfilter Core Team
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
Bridge firewalling registered
Ebtables v2.0 registered
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
Using IPI Shortcut mode
registered taskstats version 1
ehci_hcd 0000:00:10.4: GetStatus port 3 status 001403 POWER sig=3Dk CSC C=
ONNECT
hub 1-0:1.0: port 3: status 0501 change 0001
uhci_hcd 0000:00:10.0: port 1 portsc 008a,00
uhci_hcd 0000:00:10.0: port 2 portsc 008a,00
uhci_hcd 0000:00:10.1: port 1 portsc 01aa,00
uhci_hcd 0000:00:10.1: port 2 portsc 008a,00
uhci_hcd 0000:00:10.2: port 1 portsc 008a,00
uhci_hcd 0000:00:10.2: port 2 portsc 008a,00
ata5.00: ATA-0: ELITE PRO CF CARD 16GB, Ver2.22K, max UDMA/100
ata5.00: 31522176 sectors, multi 0: LBA=20
ata5.00: configured for UDMA/100
hub 1-0:1.0: state 7 ports 6 chg 0008 evt 0000
hub 1-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:10.4: port 3 low speed --> companion
ata5.00: configured for UDMA/100
ata5: EH complete
ehci_hcd 0000:00:10.4: GetStatus port 3 status 003402 POWER OWNER sig=3Dk=
 CSC
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
uhci_hcd 0000:00:10.1: port 1 portsc 01a3,00
hub 3-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
ata2: SATA link down (SStatus 0 SControl 300)
ata1: SATA link down (SStatus 0 SControl 300)
hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
usb 3-1: new low speed USB device using uhci_hcd and address 2
usb 3-1: skipped 1 descriptor after interface
usb 3-1: skipped 1 descriptor after interface
usb 3-1: default language 0x0409
usb 3-1: udev 2, busnum 3, minor =3D 257
usb 3-1: New USB device found, idVendor=3D046d, idProduct=3Dc30e
usb 3-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 3-1: Product: HID compliant keyboard
usb 3-1: Manufacturer: Logitech
usb 3-1: uevent
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
usb 3-1: usb_probe_device
usb 3-1: configuration #1 chosen from 1 choice
ata4.00: ATA-8: WDC WD15EADS-00P8B0, 01.00A01, max UDMA/133
ata4.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
ata3.00: ATA-7: WDC WD5000ABYS-01TNA0, 12.01C01, max UDMA/133
ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
usb 3-1: adding 3-1:1.0 (config #1, interface 0)
usb 3-1:1.0: uevent
usbhid 3-1:1.0: usb_probe_interface
usbhid 3-1:1.0: usb_probe_interface - got id
ata3.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      WDC WD5000ABYS-0 12.0 PQ: 0 ANSI=
: 5
sd 2:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't supp=
ort DPO or FUA
 sda:
sd 2:0:0:0: Attached scsi generic sg0 type 0
scsi 3:0:0:0: Direct-Access     ATA      WDC WD15EADS-00P 01.0 PQ: 0 ANSI=
: 5
sd 3:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't supp=
ort DPO or FUA
 sdb:
sd 3:0:0:0: Attached scsi generic sg1 type 0
scsi 4:0:0:0: Direct-Access     ATA      ELITE PRO CF CAR Ver2 PQ: 0 ANSI=
: 5
sd 4:0:0:0: [sdc] 31522176 512-byte logical blocks: (16.1 GB/15.0 GiB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't sup=
port DPO or FUA
 sdc:
sd 4:0:0:0: Attached scsi generic sg2 type 0
 sdc1
sd 4:0:0:0: [sdc] Attached SCSI disk
 sda1
sd 2:0:0:0: [sda] Attached SCSI disk
input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:10.=
1/usb3/3-1/3-1:1.0/input/input3
uhci_hcd 0000:00:10.1: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
generic-usb 0003:046D:C30E.0001: input,hidraw0: USB HID v1.10 Keyboard [L=
ogitech HID compliant keyboard] on usb-0000:00:10.1-1/input0
usb 3-1: adding 3-1:1.1 (config #1, interface 1)
usb 3-1:1.1: uevent
usbhid 3-1:1.1: usb_probe_interface
usbhid 3-1:1.1: usb_probe_interface - got id
input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:10.=
1/usb3/3-1/3-1:1.1/input/input4
uhci_hcd 0000:00:10.1: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
generic-usb 0003:046D:C30E.0002: input,hidraw1: USB HID v1.10 Device [Log=
itech HID compliant keyboard] on usb-0000:00:10.1-1/input1
drivers/usb/core/inode.c: creating file '002'
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0008
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
usb usb2: suspend_rh (auto-stop)
usb usb4: suspend_rh (auto-stop)
 sdb1
sd 3:0:0:0: [sdb] Attached SCSI disk
EXT3-fs: sdc1: couldn't mount because of unsupported optional features (2=
40).
EXT4-fs (sdc1): mounted filesystem with writeback data mode
VFS: Mounted root (ext4 filesystem) readonly on device 8:33.
Freeing unused kernel memory: 356k freed
Write protecting the kernel text: 4912k
Write protecting the kernel read-only data: 1272k
stty used greatest stack depth: 6092 bytes left
ln used greatest stack depth: 6088 bytes left
udevadm used greatest stack depth: 6028 bytes left
udev: starting version 146
usb usb2: uevent
usb 2-0:1.0: uevent
usb usb3: uevent
usb 3-0:1.0: uevent
usb 3-1: uevent
usb 3-1:1.0: uevent
usb 3-1:1.1: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
usb usb2: uevent
usb usb3: uevent
usb usb4: uevent
usb usb1: uevent
usb 3-1: uevent
scsi_id used greatest stack depth: 6024 bytes left
usb 3-1:1.0: uevent
usb 3-1: uevent
usb 3-1:1.1: uevent
usb 3-1: uevent
usb 3-1:1.1: uevent
usb 3-1:1.0: uevent
mount used greatest stack depth: 5544 bytes left
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
usb usb2: suspend_rh
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
XFS mounting filesystem sdb1
Ending clean XFS mount for filesystem: sdb1
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:10.4: suspend root hub
usb 3-1: uhci_result_common: failed with status 440000
uhci_hcd 0000:00:10.1: release dev 2 ep81-INT, period 8, phase 4, 118 us
usb 3-1: uhci_result_common: failed with status 440000
uhci_hcd 0000:00:10.1: release dev 2 ep82-INT, period 8, phase 4, 118 us
uhci_hcd 0000:00:10.1: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
uhci_hcd 0000:00:10.1: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
usb 3-1: uhci_result_common: failed with status 440000
uhci_hcd 0000:00:10.1: release dev 2 ep81-INT, period 8, phase 4, 118 us
usb 3-1: uhci_result_common: failed with status 440000
uhci_hcd 0000:00:10.1: release dev 2 ep82-INT, period 8, phase 4, 118 us
uhci_hcd 0000:00:10.1: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
uhci_hcd 0000:00:10.1: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
usb 3-1: uhci_result_common: failed with status 440000
uhci_hcd 0000:00:10.1: release dev 2 ep81-INT, period 8, phase 4, 118 us
usb 3-1: uhci_result_common: failed with status 440000
uhci_hcd 0000:00:10.1: release dev 2 ep82-INT, period 8, phase 4, 118 us
uhci_hcd 0000:00:10.1: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
uhci_hcd 0000:00:10.1: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
uhci_hcd 0000:00:10.1: port 1 portsc 018a,00
hub 3-0:1.0: port 1, status 0300, change 0003, 1.5 Mb/s
usb 3-1: USB disconnect, address 2
usb 3-1: unregistering device
usb 3-1: usb_disable_device nuking all URBs
uhci_hcd 0000:00:10.1: shutdown urb f72d1180 ep1in-intr
uhci_hcd 0000:00:10.1: release dev 2 ep81-INT, period 8, phase 4, 118 us
uhci_hcd 0000:00:10.1: shutdown urb f6816c80 ep2in-intr
uhci_hcd 0000:00:10.1: release dev 2 ep82-INT, period 8, phase 4, 118 us
usb 3-1: unregistering interface 3-1:1.0
usb 3-1:1.0: uevent
usb 3-1: unregistering interface 3-1:1.1
usb 3-1:1.1: uevent
usb 3-1: uevent
hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x300
usb usb3: suspend_rh (auto-stop)
Velocity is AUTO mode
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
device eth0 entered promiscuous mode
device eth1 entered promiscuous mode
br0: port 2(eth1) entering forwarding state
br0: port 1(eth0) entering forwarding state
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
eth1: Link auto-negotiation speed 1000M bps full duplex
svc: failed to register lockdv1 RPC service (errno 97).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory=

NFSD: starting 90-second grace period
rpc.nfsd used greatest stack depth: 5160 bytes left
eth1: no IPv6 routers present
br0: no IPv6 routers present
eth0: no IPv6 routers present
wget used greatest stack depth: 4840 bytes left

--------------040603080400010703050907--

--------------enig42EA94BDC6A32B2545CBEC5C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkvLh+gACgkQamXfqERyJRctKgCfRoUf4XJ/D4YNg5/sR7o9gNRU
6JUAmgJOQQRo+Ou9P60T9w8aosFEWqXY
=7IQi
-----END PGP SIGNATURE-----

--------------enig42EA94BDC6A32B2545CBEC5C--
