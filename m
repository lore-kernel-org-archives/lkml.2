Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab1FJWiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 18:38:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:44296 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758029Ab1FJWis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 18:38:48 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19yTt9pGA1yEihjN+rfcOViNwf4iyK3/ooKViR+R1
	aDMzU3d1aMBtBn
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: non-printable characters in /proc/interrupts
Date: Sat, 11 Jun 2011 00:38:42 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39.1; KDE/4.6.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201106101040.20282.toralf.foerster@gmx.de> <20110610091132.90531e0e.randy.dunlap@oracle.com>
In-Reply-To: <20110610091132.90531e0e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_zzp8NB8zgtlBkNh"
Message-Id: <201106110038.43139.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_zzp8NB8zgtlBkNh
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable


Randy Dunlap wrote at 18:11:32
> On Fri, 10 Jun 2011 10:40:19 +0200 Toralf F=C3=B6rster wrote:
> > I've wondering about this entry at my ThinkPad T400 (kernel 2.6.39.1):
> >=20
> > n22 ~ # grep 47: /proc/interrupts
> >=20
> >  47:      44041      69740   PCI-MSI-edge      l=E2=96=92=EF=BF=BD=EF=
=BF=BD@=EF=BF=BDE=EF=BF=BD
> >=20
> > I attached the output of
> > $>grep 47: /proc/interrupts > /tmp/int47
> > onto this email, the complete table looks like this :
> >=20
> > n22 ~ # cat /proc/interrupts
> >=20
> >            CPU0       CPU1
> >  =20
> >   0:     605293      71393   IO-APIC-edge      timer
> >   1:      13432          4   IO-APIC-edge      i8042
> >   8:         55         64   IO-APIC-edge      rtc0
> >   9:       6248        509   IO-APIC-fasteoi   acpi
> > =20
> >  12:       1389         72   IO-APIC-edge      i8042
> >  16:          0          0   IO-APIC-fasteoi   uhci_hcd:usb6
> >  17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb7
> >  18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb8
> >  19:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2
> >  20:      52881          0   IO-APIC-fasteoi   uhci_hcd:usb3
> >  21:        329         37   IO-APIC-fasteoi   uhci_hcd:usb4
> >  22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
> >  23:      30046       8743   IO-APIC-fasteoi   ehci_hcd:usb1
> >  40:          0          0   PCI-MSI-edge      PCIe PME
> >  41:          0          0   PCI-MSI-edge      PCIe PME
> >  42:          0          0   PCI-MSI-edge      PCIe PME
> >  43:          0          0   PCI-MSI-edge      PCIe PME
> >  44:     484163      55698   PCI-MSI-edge      ahci
> >  45:        750       1809   PCI-MSI-edge      eth0
> >  46:         94        213   PCI-MSI-edge      hda_intel
> >  47:      44399      70713   PCI-MSI-edge      l=E2=96=92=EF=BF=BD=EF=
=BF=BD@=EF=BF=BDE=EF=BF=BD
> >  48:      71969     102457   PCI-MSI-edge      iwlagn
> >=20
> > NMI:          0          0   Non-maskable interrupts
> > LOC:   10167789   10321319   Local timer interrupts
> > SPU:          0          0   Spurious interrupts
> > PMI:          0          0   Performance monitoring interrupts
> > IWI:        213        200   IRQ work interrupts
> > RES:     289390     333102   Rescheduling interrupts
> > CAL:       4677       4542   Function call interrupts
> > TLB:      22261      16007   TLB shootdowns
> > TRM:          0          0   Thermal event interrupts
> > THR:          0          0   Threshold APIC interrupts
> > MCE:          0          0   Machine check exceptions
> > MCP:         41         41   Machine check polls
> > ERR:          0
> > MIS:          0
>=20
> Is there any other info (like dmesg or boot log) that tells what
> device/driver uses interrupt 47 ?

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio=20
Controller (rev 03)
        Subsystem: Lenovo Device 20f2
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
=20
Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=20
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 47
        Region 0: Memory at fc020000 (64-bit, non-prefetchable) [size=3D16K]
        Capabilities: <access denied>
        Kernel driver in use: HDA Intel
        Kernel modules: snd-hda-intel

I attached the dmesg output

=2D-=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--Boundary-00=_zzp8NB8zgtlBkNh
Content-Type: text/plain;
  charset="UTF-8";
  name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.txt"

Initializing cgroup subsys cpu
Linux version 2.6.39.1 (root@n22) (gcc version 4.4.5 (Gentoo 4.4.5 p1.2, pie-0.4.5) ) #2 SMP Tue Jun 7 18:02:49 CEST 2011
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000794a1000 (usable)
 BIOS-e820: 00000000794a1000 - 00000000794a7000 (reserved)
 BIOS-e820: 00000000794a7000 - 00000000795b7000 (usable)
 BIOS-e820: 00000000795b7000 - 000000007960f000 (reserved)
 BIOS-e820: 000000007960f000 - 00000000796c6000 (usable)
 BIOS-e820: 00000000796c6000 - 00000000796d1000 (ACPI NVS)
 BIOS-e820: 00000000796d1000 - 00000000796d4000 (ACPI data)
 BIOS-e820: 00000000796d4000 - 00000000796d8000 (reserved)
 BIOS-e820: 00000000796d8000 - 00000000796dc000 (ACPI NVS)
 BIOS-e820: 00000000796dc000 - 00000000796df000 (reserved)
 BIOS-e820: 00000000796df000 - 0000000079706000 (ACPI NVS)
 BIOS-e820: 0000000079706000 - 0000000079708000 (ACPI data)
 BIOS-e820: 0000000079708000 - 000000007990f000 (reserved)
 BIOS-e820: 000000007990f000 - 000000007999f000 (ACPI NVS)
 BIOS-e820: 000000007999f000 - 00000000799ff000 (ACPI data)
 BIOS-e820: 00000000799ff000 - 0000000079a00000 (usable)
 BIOS-e820: 0000000079c00000 - 000000007c000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
 BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI present.
DMI: LENOVO 6474B84/6474B84, BIOS 7UET92WW (3.22 ) 03/11/2011
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x79a00 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-D3FFF write-protect
  D4000-DBFFF uncachable
  DC000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 07D000000 mask FFF000000 uncachable
  1 base 07E000000 mask FFE000000 uncachable
  2 base 000000000 mask F80000000 write-back
  3 base 079E00000 mask FFFE00000 uncachable
  4 disabled
  5 disabled
  6 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 0000000079e00000 - 000000007a000000 (usable) ==> (reserved)
initial memory mapped : 0 - 01800000
Base memory trampoline at [c009a000] 9a000 size 16384
init_memory_mapping: 0000000000000000-00000000377fe000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037400000 page 2M
 0037400000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 17fb000-1800000
ACPI: RSDP 000f6440 00024 (v02 LENOVO)
ACPI: XSDT 79949b5a 0009C (v01 LENOVO TP-7U    00003220  LTP 00000000)
ACPI: FACP 79949d00 000F4 (v03 LENOVO TP-7U    00003220 LNVO 00000001)
ACPI: DSDT 7994a10e 0FAE1 (v01 LENOVO TP-7U    00003220 MSFT 03000000)
ACPI: FACS 7998e000 00040
ACPI: SSDT 79949eb4 0025A (v01 LENOVO TP-7U    00003220 MSFT 03000000)
ACPI: ECDT 79959bef 00052 (v01 LENOVO TP-7U    00003220 LNVO 00000001)
ACPI: APIC 79959c41 00078 (v01 LENOVO TP-7U    00003220 LNVO 00000001)
ACPI: MCFG 79959cb9 0003C (v01 LENOVO TP-7U    00003220 LNVO 00000001)
ACPI: HPET 79959cf5 00038 (v01 LENOVO TP-7U    00003220 LNVO 00000001)
ACPI: SLIC 79959dc2 00176 (v01 LENOVO TP-7U    00003220  LTP 00000000)
ACPI: BOOT 79959f38 00028 (v01 LENOVO TP-7U    00003220  LTP 00000001)
ACPI: ASF! 79959f60 000A0 (v16 LENOVO TP-7U    00003220 PTL  00000001)
ACPI: SSDT 7998d1fa 00568 (v01 LENOVO TP-7U    00003220 INTL 20050513)
ACPI: TCPA 79707000 00032 (v00                 00000000      00000000)
ACPI: DMAR 79706000 00120 (v01               ? 00000001      00000000)
ACPI: SSDT 796d3000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
ACPI: SSDT 796d2000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
ACPI: SSDT 796d1000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
ACPI: DMI detected: Lenovo ThinkPad T400
ACPI: Local APIC address 0xfee00000
1058MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x00079a00
Movable zone start PFN for each node
early_node_map[5] active PFN ranges
    0: 0x00000010 -> 0x0000009e
    0: 0x00000100 -> 0x000794a1
    0: 0x000794a7 -> 0x000795b7
    0: 0x0007960f -> 0x000796c6
    0: 0x000799ff -> 0x00079a00
On node 0 totalpages: 497143
free_area_init_node: node 0, pgdat c13ae380, node_mem_map f68c5200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3950 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 2117 pages used for memmap
  HighMem zone: 267814 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
4 Processors exceeds NR_CPUS limit of 2
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009e000 - 000000000009f000
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 7c000000 (gap: 7c000000:64000000)
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 12 pages/cpu @f6400000 s25984 r0 d23168 u2097152
pcpu-alloc: s25984 r0 d23168 u2097152 alloc=1*4194304
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 493250
Kernel command line: root=/dev/sda7 reboot=pci
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:00079a00)
Memory: 1967400k/1992704k available (2797k kernel code, 21172k reserved, 990k data, 392k init, 1079724k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff8f000 - 0xfffff000   ( 448 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc13b3000 - 0xc1415000   ( 392 kB)
      .data : 0xc12bb5dd - 0xc13b2e00   ( 990 kB)
      .text : 0xc1000000 - 0xc12bb5dd   (2797 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
NR_IRQS:320
CPU 0 irqstacks, hard=f6008000 soft=f600a000
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2393.997 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.99 BogoMIPS (lpj=2393997)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20110316
ftrace: allocating 12333 entries in 25 pages
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz stepping 06
APIC calibration not consistent with PM-Timer: 108ms instead of 100ms
APIC delta adjusted to PM-Timer: 1662498 (1812096)
Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
CPU 1 irqstacks, hard=f60cc000 soft=f60ce000
Booting Node   0, Processors  #1 Ok.
smpboot cpu 1: start_ip = 9a000
Initializing CPU#1
Brought up 2 CPUs
Total of 2 processors activated (9575.74 BogoMIPS).
PM: Registering ACPI NVS region at 796c6000 (45056 bytes)
PM: Registering ACPI NVS region at 796d8000 (16384 bytes)
PM: Registering ACPI NVS region at 796df000 (159744 bytes)
PM: Registering ACPI NVS region at 7990f000 (589824 bytes)
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Linux)
ACPI: EC: EC description table is found, configuring boot EC
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via DMI
ACPI: SSDT 796d6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
ACPI: SSDT 796d4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
ACPI: SSDT 796d5ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
ACPI: SSDT 796d5f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Power Resource [PUBS] (on)
ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
ACPI: ACPI Dock Station Driver: 3 docks/bays found
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
pci_root PNP0A08:00: host bridge window [mem 0x7c000000-0xfebfffff]
pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xf4400000-0xf47fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
pci 0000:00:02.1: reg 10: [mem 0xf4200000-0xf42fffff 64bit]
pci 0000:00:03.0: [8086:2a44] type 0 class 0x000780
pci 0000:00:03.0: reg 10: [mem 0xfc226800-0xfc22680f 64bit]
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.3: [8086:2a47] type 0 class 0x000700
pci 0000:00:03.3: reg 10: [io  0x1830-0x1837]
pci 0000:00:03.3: reg 14: [mem 0xfc024000-0xfc024fff]
pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
pci 0000:00:19.0: reg 10: [mem 0xfc000000-0xfc01ffff]
pci 0000:00:19.0: reg 14: [mem 0xfc025000-0xfc025fff]
pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
pci 0000:00:1a.7: reg 10: [mem 0xfc226c00-0xfc226fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xfc020000-0xfc023fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1c.4: [8086:2948] type 1 class 0x000604
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xfc227000-0xfc2273ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
pci 0000:00:1f.2: reg 24: [mem 0xfc226000-0xfc2267ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
pci 0000:00:1f.3: reg 10: [mem 0xfc227400-0xfc2274ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:03:00.0: [8086:4237] type 0 class 0x000280
pci 0000:03:00.0: reg 10: [mem 0xf4300000-0xf4301fff 64bit]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
pci 0000:15:00.0: [1180:0476] type 2 class 0x000607
pci 0000:15:00.0: reg 10: [mem 0xf4800000-0xf4800fff]
pci 0000:15:00.0: supports D1 D2
pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.0: PME# disabled
pci 0000:15:00.1: [1180:0832] type 0 class 0x000c00
pci 0000:15:00.1: reg 10: [mem 0xf4801000-0xf48017ff]
pci 0000:15:00.1: supports D1 D2
pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.1: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x7c000000-0xfebfffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC control (0x1d) granted
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
reserve RAM buffer: 00000000794a1000 - 000000007bffffff 
reserve RAM buffer: 00000000795b7000 - 000000007bffffff 
reserve RAM buffer: 00000000796c6000 - 000000007bffffff 
reserve RAM buffer: 0000000079a00000 - 000000007bffffff 
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [mem 0x00000000-0x0009ffff]
pnp 00:00: [mem 0x000c0000-0x000c3fff]
pnp 00:00: [mem 0x000c4000-0x000c7fff]
pnp 00:00: [mem 0x000c8000-0x000cbfff]
pnp 00:00: [mem 0x000cc000-0x000cffff]
pnp 00:00: [mem 0x000d0000-0x000d3fff]
pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
pnp 00:00: [mem 0x000dc000-0x000dffff]
pnp 00:00: [mem 0x000e0000-0x000e3fff]
pnp 00:00: [mem 0x000e4000-0x000e7fff]
pnp 00:00: [mem 0x000e8000-0x000ebfff]
pnp 00:00: [mem 0x000ec000-0x000effff]
pnp 00:00: [mem 0x000f0000-0x000fffff]
pnp 00:00: [mem 0x00100000-0x7bffffff]
pnp 00:00: [mem 0xfec00000-0xfed3ffff]
pnp 00:00: [mem 0xfed4c000-0xffffffff]
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0x7bffffff] could not be reserved
system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:01: [bus 00-ff]
pnp 00:01: [io  0x0cf8-0x0cff]
pnp 00:01: [io  0x0000-0x0cf7 window]
pnp 00:01: [io  0x0d00-0xffff window]
pnp 00:01: [mem 0x000a0000-0x000bffff window]
pnp 00:01: [mem 0x000c0000-0x000c3fff window]
pnp 00:01: [mem 0x000c4000-0x000c7fff window]
pnp 00:01: [mem 0x000c8000-0x000cbfff window]
pnp 00:01: [mem 0x000cc000-0x000cffff window]
pnp 00:01: [mem 0x000d0000-0x000d3fff window]
pnp 00:01: [mem 0x000d4000-0x000d7fff window]
pnp 00:01: [mem 0x000d8000-0x000dbfff window]
pnp 00:01: [mem 0x000dc000-0x000dffff window]
pnp 00:01: [mem 0x000e0000-0x000e3fff window]
pnp 00:01: [mem 0x000e4000-0x000e7fff window]
pnp 00:01: [mem 0x000e8000-0x000ebfff window]
pnp 00:01: [mem 0x000ec000-0x000effff window]
pnp 00:01: [mem 0x7c000000-0xfebfffff window]
pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:02: [io  0x0010-0x001f]
pnp 00:02: [io  0x0090-0x009f]
pnp 00:02: [io  0x0024-0x0025]
pnp 00:02: [io  0x0028-0x0029]
pnp 00:02: [io  0x002c-0x002d]
pnp 00:02: [io  0x0030-0x0031]
pnp 00:02: [io  0x0034-0x0035]
pnp 00:02: [io  0x0038-0x0039]
pnp 00:02: [io  0x003c-0x003d]
pnp 00:02: [io  0x00a4-0x00a5]
pnp 00:02: [io  0x00a8-0x00a9]
pnp 00:02: [io  0x00ac-0x00ad]
pnp 00:02: [io  0x00b0-0x00b5]
pnp 00:02: [io  0x00b8-0x00b9]
pnp 00:02: [io  0x00bc-0x00bd]
pnp 00:02: [io  0x0050-0x0053]
pnp 00:02: [io  0x0072-0x0077]
pnp 00:02: [io  0x002e-0x002f]
pnp 00:02: [io  0x1000-0x107f]
pnp 00:02: [io  0x1180-0x11ff]
pnp 00:02: [io  0x0800-0x080f]
pnp 00:02: [io  0x15e0-0x15ef]
pnp 00:02: [io  0x1600-0x167f]
pnp 00:02: [io  0x1680-0x169f]
pnp 00:02: [mem 0xe0000000-0xefffffff]
pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
pnp 00:02: [mem 0xfed10000-0xfed13fff]
pnp 00:02: [mem 0xfed18000-0xfed18fff]
pnp 00:02: [mem 0xfed19000-0xfed19fff]
pnp 00:02: [mem 0xfed45000-0xfed4bfff]
system 00:02: [io  0x1000-0x107f] has been reserved
system 00:02: [io  0x1180-0x11ff] has been reserved
system 00:02: [io  0x0800-0x080f] has been reserved
system 00:02: [io  0x15e0-0x15ef] has been reserved
system 00:02: [io  0x1600-0x167f] has been reserved
system 00:02: [io  0x1680-0x169f] has been reserved
system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:03: [mem 0xfed00000-0xfed003ff]
pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:04: [io  0x0000-0x000f]
pnp 00:04: [io  0x0080-0x008f]
pnp 00:04: [io  0x00c0-0x00df]
pnp 00:04: [dma 4]
pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:05: [io  0x0061]
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: [io  0x00f0]
pnp 00:06: [irq 13]
pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:07: [io  0x0070-0x0071]
pnp 00:07: [irq 8]
pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:08: [io  0x0060]
pnp 00:08: [io  0x0064]
pnp 00:08: [irq 1]
pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:09: [irq 12]
pnp 00:09: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (active)
pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (disabled)
pnp 00:0b: [io  0x0378-0x037f]
pnp 00:0b: [io  0x0778-0x077f]
pnp 00:0b: [irq 7]
pnp 00:0b: [dma 0]
pnp 00:0b: Plug and Play ACPI device, IDs PNP0401 (active)
pnp 00:0c: [mem 0xfed40000-0xfed44fff]
pnp 00:0c: Plug and Play ACPI device, IDs PNP0c31 (active)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:00:1c.1: BAR 9: assigned [mem 0x7c000000-0x7c1fffff 64bit pref]
pci 0000:00:1c.1: BAR 7: assigned [io  0x8000-0x8fff]
pci 0000:00:1c.0: BAR 8: assigned [mem 0x7c200000-0x7c3fffff]
pci 0000:00:1c.0: BAR 9: assigned [mem 0x7c400000-0x7c5fffff 64bit pref]
pci 0000:00:1c.0: BAR 7: assigned [io  0x9000-0x9fff]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x9000-0x9fff]
pci 0000:00:1c.0:   bridge window [mem 0x7c200000-0x7c3fffff]
pci 0000:00:1c.0:   bridge window [mem 0x7c400000-0x7c5fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [io  0x8000-0x8fff]
pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
pci 0000:00:1c.1:   bridge window [mem 0x7c000000-0x7c1fffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
pci 0000:15:00.0: BAR 9: assigned [mem 0xf0000000-0xf3ffffff pref]
pci 0000:15:00.0: BAR 10: assigned [mem 0x80000000-0x83ffffff]
pci 0000:15:00.0: BAR 7: assigned [io  0x4000-0x40ff]
pci 0000:15:00.0: BAR 8: assigned [io  0x4400-0x44ff]
pci 0000:15:00.0: CardBus bridge to [bus 16-17]
pci 0000:15:00.0:   bridge window [io  0x4000-0x40ff]
pci 0000:15:00.0:   bridge window [io  0x4400-0x44ff]
pci 0000:15:00.0:   bridge window [mem 0xf0000000-0xf3ffffff pref]
pci 0000:15:00.0:   bridge window [mem 0x80000000-0x83ffffff]
pci 0000:00:1e.0: PCI bridge to [bus 15-18]
pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: resource 9 [mem 0x7c000000-0xfebfffff]
pci_bus 0000:02: resource 0 [io  0x9000-0x9fff]
pci_bus 0000:02: resource 1 [mem 0x7c200000-0x7c3fffff]
pci_bus 0000:02: resource 2 [mem 0x7c400000-0x7c5fffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x8000-0x8fff]
pci_bus 0000:03: resource 1 [mem 0xf4300000-0xf43fffff]
pci_bus 0000:03: resource 2 [mem 0x7c000000-0x7c1fffff 64bit pref]
pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:05: resource 1 [mem 0xf8000000-0xf9ffffff]
pci_bus 0000:05: resource 2 [mem 0xf4000000-0xf40fffff 64bit pref]
pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:0d: resource 1 [mem 0xfa000000-0xfbffffff]
pci_bus 0000:0d: resource 2 [mem 0xf4100000-0xf41fffff 64bit pref]
pci_bus 0000:15: resource 0 [io  0x4000-0x7fff]
pci_bus 0000:15: resource 1 [mem 0xf4800000-0xf7ffffff]
pci_bus 0000:15: resource 2 [mem 0xf0000000-0xf3ffffff 64bit pref]
pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:15: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:15: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:15: resource 9 [mem 0x7c000000-0xfebfffff]
pci_bus 0000:16: resource 0 [io  0x4000-0x40ff]
pci_bus 0000:16: resource 1 [io  0x4400-0x44ff]
pci_bus 0000:16: resource 2 [mem 0xf0000000-0xf3ffffff pref]
pci_bus 0000:16: resource 3 [mem 0x80000000-0x83ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
Simple Boot Flag at 0x35 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1307752220.282:1): initialized
highmem bounce pool size: 64 pages
msgmni has been set to 1733
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.3: setting latency timer to 64
pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
pcieport 0000:00:1c.4: setting latency timer to 64
pcieport 0000:00:1c.4: irq 43 for MSI/MSI-X
pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226100 irq 44
ata2: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226180 irq 44
ata3: DUMMY
ata4: DUMMY
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
Registering the dns_resolver key type
Using IPI No-Shortcut mode
PM: Checking hibernation image partition /dev/sda6
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ATA-8: HITACHI HTS723216L9SA60, FC2ZC50A, max UDMA/100
ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      HITACHI HTS72321 FC2Z PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 >
sd 0:0:0:0: [sda] Attached SCSI disk
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ACPI cmd e3/00:79:00:00:00:a0 (IDLE) succeeded
ata2.00: ACPI cmd e3/00:01:00:00:00:a0 (IDLE) succeeded
ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX12, max UDMA/133
ata2.00: ACPI cmd e3/00:79:00:00:00:a0 (IDLE) succeeded
ata2.00: ACPI cmd e3/00:01:00:00:00:a0 (IDLE) succeeded
ata2.00: configured for UDMA/133
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX12 PQ: 0 ANSI: 5
PM: Hibernation image partition 8:6 present
PM: Looking for hibernation image.
PM: Image not found (code -22)
PM: Hibernation image not present or could not be loaded.
registered taskstats version 1
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda7): mounted filesystem with ordered data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:7.
Freeing unused kernel memory: 392k freed
Write protecting the kernel text: 2800k
Write protecting the kernel read-only data: 792k
Refined TSC clocksource calibration: 2393.999 MHz.
Switching to clocksource tsc
udev: starting version 151
udevd (576): /proc/576/oom_adj is deprecated, please use /proc/576/oom_score_adj instead.
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
Marking TSC unstable due to TSC halts in idle
Switching to clocksource hpet
wmi: Mapper loaded
ACPI: Battery Slot [BAT0] (battery present)
Non-volatile memory driver v1.3
ACPI: AC Adapter [AC] (on-line)
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (49 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [THM1] (46 C)
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel GM45 Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 32768K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
rtc_cmos 00:07: RTC can wake from S4
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:24:7e:11:75:c4
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: irq 23, io mem 0xfc226c00
serial 00:0a: [io  0x03f8-0x03ff]
serial 00:0a: [irq 4]
serial 00:0a: activated
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.39.1 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
0000:00:03.3: ttyS1 at I/O 0x1830 (irq = 17) is a 16550A
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.39.1 uhci_hcd
usb usb2: SerialNumber: 0000:00:1a.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.39.1 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.39.1 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.39.1 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.39.1 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.39.1 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfc227000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: EHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.39.1 ehci_hcd
usb usb8: SerialNumber: 0000:00:1d.7
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 6 ports detected
i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
usb 1-5: new high speed USB device number 3 using ehci_hcd
thinkpad_acpi: ThinkPad ACPI Extras v0.24
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7UET92WW (3.22 ), EC 7VHT16WW-1.06
thinkpad_acpi: Lenovo ThinkPad T400, model 6474B84
thinkpad_acpi: detected a 8-level brightness capable ThinkPad
thinkpad_acpi: radio switch found; radios are enabled
cfg80211: Calling CRDA to update world regulatory domain
thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
Registered led device: tpacpi::thinklight
Registered led device: tpacpi::power
Registered led device: tpacpi::standby
Registered led device: tpacpi::thinkvantage
thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input5
usb 1-5: New USB device found, idVendor=04b3, idProduct=4485
usb 1-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-5:1.0: USB hub found
hub 1-5:1.0: 4 ports detected
[drm] Initialized drm 1.1.0 20060810
usb 3-2: new full speed USB device number 2 using uhci_hcd
usb 3-2: New USB device found, idVendor=0a5c, idProduct=2145
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
usb 3-2: Manufacturer: Lenovo Computer Corp
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:03:00.0: setting latency timer to 64
iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
iwlagn 0000:03:00.0: device EEPROM VER=0x11e, CALIB=0x4
iwlagn 0000:03:00.0: Device SKU: 0Xb
iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:03:00.0: irq 46 for MSI/MSI-X
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
usb 1-5.1: new low speed USB device number 4 using ehci_hcd
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
usb 1-5.1: New USB device found, idVendor=046a, idProduct=0023
usb 1-5.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usb 1-5.3: new full speed USB device number 5 using ehci_hcd
usb 1-5.3: New USB device found, idVendor=043d, idProduct=0078
usb 1-5.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5.3: Product: Lexmark Z600 Series
usb 1-5.3: Manufacturer: Lexmark 
usb 1-5.3: SerialNumber: 18K670127065550
input: HID 046a:0023 as /devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5.1/1-5.1:1.0/input/input6
cherry 0003:046A:0023.0001: input: USB HID v1.11 Keyboard [HID 046a:0023] on usb-0000:00:1a.7-5.1/input0
input: HID 046a:0023 as /devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5.1/1-5.1:1.1/input/input7
cherry 0003:046A:0023.0002: input: USB HID v1.11 Device [HID 046a:0023] on usb-0000:00:1a.7-5.1/input1
usb 1-5.4: new low speed USB device number 6 using ehci_hcd
usb 1-5.4: New USB device found, idVendor=046d, idProduct=c062
usb 1-5.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-5.4: Product: USB Laser Mouse
usb 1-5.4: Manufacturer: Logitech
input: Logitech USB Laser Mouse as /devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5.4/1-5.4:1.0/input/input8
generic-usb 0003:046D:C062.0003: input: USB HID v1.10 Mouse [Logitech USB Laser Mouse] on usb-0000:00:1a.7-5.4/input0
input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
usblp0: USB Bidirectional printer dev 5 if 0 alt 0 proto 2 vid 0x043D pid 0x0078
usbcore: registered new interface driver usblp
iwlagn 0000:03:00.0: loaded firmware version 8.83.5.1 build 33692
Registered led device: phy0-led
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
i915 0000:00:02.0: irq 48 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 180x56
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
acpi device:02: registered as cooling_device2
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input13
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
EXT3-fs (sda7): using internal journal
fuse init (API version 7.16)
microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60f
microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60f
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
microcode: Microcode Update Driver: v2.00 removed.
Adding 2003364k swap on /dev/sda6.  Priority:-1 extents:1 across:2003364k 
e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
PPP generic driver version 2.4.2
NET: Registered protocol family 24
NET: Registered protocol family 17
e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ata1.00: configured for UDMA/100
ata1: EH complete

--Boundary-00=_zzp8NB8zgtlBkNh--
