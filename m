Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab2APM6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:58:44 -0500
Received: from host86-147-20-157.range86-147.btcentralplus.com ([86.147.20.157]:42535
	"EHLO oak.selfip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab2APM6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:58:41 -0500
X-Greylist: delayed 1132 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jan 2012 07:58:41 EST
Message-ID: <4F141A8D.5070007@oak.selfip.net>
Date: Mon, 16 Jan 2012 12:39:41 +0000
From: Dave Haywood <tla@oak.selfip.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0) Gecko/20120111 Thunderbird/10.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: PROBLEM: mdadm: sending ioctl 1261 to a partition!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   Booted latest git kernel (3.2.0-08694-g53999bf) for the first time today and noticed in the dmesg several instances of:

	mdadm: sending ioctl 1261 to a partition!

   The system runs software RAID 1 over two disks.

   Full dmesg below (see time index: [    5.933222]):

$ dmesg
[    0.000000] Linux version 3.2.0-08694-g53999bf (tla@s1) (gcc version 4.6.2 (Gentoo Hardened 4.6.2 p1.1, pie-0.4.5) ) #130 SMP Mon Jan 16 09:13:32 GMT 2012
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000000fed0000 (usable)
[    0.000000]  BIOS-e820: 000000000fed0000 - 000000000fef0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000000fef0000 - 000000000ff00000 (usable)
[    0.000000]  BIOS-e820: 00000000feea0000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] DMI 2.3 present.
[    0.000000] DMI: Compaq Deskpro/06C4h, BIOS 686P0 v2.04 06/12/2001
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==>  (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0xff00 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-back
[    0.000000]   E8000-E8FFF uncachable
[    0.000000]   E9000-EFFFF write-back
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00FF00000 mask FFFF00000 uncachable
[    0.000000]   1 base 000000000 mask FF0000000 write-back
[    0.000000]   2 base 0FEEA0000 mask FFFFE0000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] e820 update range: 000000000ff00000 - 00000000feea0000 (usable) ==>  (reserved)
[    0.000000] found SMP MP-table at [c00f9bf0] f9bf0
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-000000000ff00000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 000fc00000 page 2M
[    0.000000]  000fc00000 - 000ff00000 page 4k
[    0.000000] kernel direct mapping tables up to ff00000 @ 1bfb000-1c00000
[    0.000000] ACPI: RSDP 000e0010 00014 (v00 COMPAQ)
[    0.000000] ACPI: RSDT 000e0080 00054 (v01 COMPAQ CPQ0014  20010612      00000000)
[    0.000000] ACPI: FACP 000e0130 00074 (v01 COMPAQ SOLANO   00000001      00000000)
[    0.000000] ACPI: DSDT 000e0204 00CE6 (v01 COMPAQ     DSDT 00000001 MSFT 0100000D)
[    0.000000] ACPI: FACS 000e0040 00040
[    0.000000] ACPI: SSDT 000e0eea 00174 (v01 COMPAQ CORE_UTL 00000001 MSFT 0100000D)
[    0.000000] ACPI: SSDT 000e105e 00D3D (v01 COMPAQ VILLTBL1 00000001 MSFT 0100000D)
[    0.000000] ACPI: APIC 000e01a4 00060 (v01 COMPAQ SOLANO   00000001      00000000)
[    0.000000] ACPI: SSDT 000e2d4f 00076 (v01 COMPAQ     APIC 00000001 MSFT 0100000D)
[    0.000000] ACPI: SSDT 000e1d9b 006AD (v01 COMPAQ PNP_PRSS 00000001 MSFT 0100000D)
[    0.000000] ACPI: SSDT 000e24a6 001A4 (v01 COMPAQ       S3 00000001 MSFT 0100000D)
[    0.000000] ACPI: SSDT 000e264a 00158 (v01 COMPAQ   PIDETM 00000001 MSFT 0100000D)
[    0.000000] ACPI: SSDT 000e28ff 0010B (v01 COMPAQ     GTF0 00000001 MSFT 0100000D)
[    0.000000] ACPI: SSDT 000e27a2 0015D (v01 COMPAQ   SIDETM 00000001 MSFT 0100000D)
[    0.000000] ACPI: SSDT 000e2b21 00117 (v01 COMPAQ     GTF2 00000001 MSFT 0100000D)
[    0.000000] ACPI: SSDT 000e2ead 0004E (v01 COMPAQ    FINIS 00000001 MSFT 0100000D)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0ff00000
[    0.000000]   low ram: 0 - 0ff00000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 ->  0x00001000
[    0.000000]   Normal   0x00001000 ->  0x0000ff00
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 ->  0x0000009f
[    0.000000]     0: 0x00000100 ->  0x0000fed0
[    0.000000]     0: 0x0000fef0 ->  0x0000ff00
[    0.000000] On node 0 totalpages: 65135
[    0.000000] free_area_init_node: node 0, pgdat c1815480, node_mem_map cfcd0200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 478 pages used for memmap
[    0.000000]   Normal zone: 60674 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xf808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000000fed0000 - 000000000fef0000
[    0.000000] Allocating PCI resources starting at ff00000 (gap: ff00000:eefa0000)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @cf800000 s29216 r0 d15840 u4194304
[    0.000000] pcpu-alloc: s29216 r0 d15840 u4194304 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64625
[    0.000000] Kernel command line: root=/dev/md4 console=ttyS0,115200
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 248760k/261120k available (6447k kernel code, 11780k reserved, 1874k data, 436k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     vmalloc : 0xd0700000 - 0xfff14000   ( 760 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcff00000   ( 255 MB)
[    0.000000]       .init : 0xc1821000 - 0xc188e000   ( 436 kB)
[    0.000000]       .data : 0xc164bea0 - 0xc1820740   (1874 kB)
[    0.000000]       .text : 0xc1000000 - 0xc164bea0   (6447 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=cf408000 soft=cf40a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 930.343 MHz processor.
[    0.003005] Calibrating delay loop (skipped), value calculated using timer frequency.. 1860.68 BogoMIPS (lpj=930343)
[    0.005006] pid_max: default: 32768 minimum: 301
[    0.006088] Security Framework initialized
[    0.007020] SELinux:  Initializing.
[    0.008026] SELinux:  Starting in permissive mode
[    0.008085] Mount-cache hash table entries: 512
[    0.010465] mce: CPU supports 5 MCE banks
[    0.011139] SMP alternatives: switching to UP code
[    0.019816] Freeing SMP alternatives: 24k freed
[    0.020032] ACPI: Core revision 20110623
[    0.027226] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.028387] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.039054] CPU0: Intel Pentium III (Coppermine) stepping 06
[    0.043996] Performance Events: p6 PMU driver.
[    0.045004] ... version:                0
[    0.046000] ... bit width:              32
[    0.047000] ... generic registers:      2
[    0.048000] ... value mask:             00000000ffffffff
[    0.048999] ... max period:             000000007fffffff
[    0.049999] ... fixed-purpose events:   0
[    0.050999] ... event mask:             0000000000000003
[    0.053138] Brought up 1 CPUs
[    0.054004] Total of 1 processors activated (1860.68 BogoMIPS).
[    0.056843] PM: Registering ACPI NVS region at fed0000 (131072 bytes)
[    0.057328] RTC time: 12:28:43, date: 01/16/12
[    0.058149] NET: Registered protocol family 16
[    0.060046] kworker/u:0 used greatest stack depth: 7132 bytes left
[    0.062715] ACPI: bus type pci registered
[    0.065048] PCI: PCI BIOS revision 2.10 entry at 0xe8316, last bus=2
[    0.065999] PCI: Using configuration type 1 for base access
[    0.103557] bio: create slab<bio-0>  at 0
[    0.105276] ACPI: Added _OSI(Module Device)
[    0.106022] ACPI: Added _OSI(Processor Device)
[    0.106996] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.107996] ACPI: Added _OSI(Processor Aggregator Device)
[    0.110131] ACPI: EC: Look up EC in DSDT
[    0.114915] ACPI: Interpreter enabled
[    0.115007] ACPI: (supports S0 S1 S3 S4 S5)
[    0.117825] ACPI: Using IOAPIC for interrupt routing
[    0.131124] ACPI: No dock devices found.
[    0.132006] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.134040] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.135412] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.135422] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.135431] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.135439] pci_root PNP0A03:00: host bridge window [mem 0x000c8000-0x000dffff] (ignored)
[    0.135447] pci_root PNP0A03:00: host bridge window [mem 0x0ff00000-0xfebfffff] (ignored)
[    0.135456] PCI: root bus 00: using default resources
[    0.135759] PCI host bridge to bus 0000:00
[    0.136015] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.136993] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.138020] pci 0000:00:00.0: [8086:1130] type 0 class 0x000600
[    0.138113] pci 0000:00:02.0: [8086:1132] type 0 class 0x000300
[    0.138136] pci 0000:00:02.0: reg 10: [mem 0x44000000-0x47ffffff pref]
[    0.138150] pci 0000:00:02.0: reg 14: [mem 0x40800000-0x4087ffff]
[    0.138257] pci 0000:00:1e.0: [8086:2418] type 1 class 0x000604
[    0.138318] pci 0000:00:1f.0: [8086:2410] type 0 class 0x000601
[    0.138404] pci 0000:00:1f.0: quirk: [io  0xf800-0xf87f] claimed by ICH4 ACPI/GPIO/TCO
[    0.138997] pci 0000:00:1f.0: quirk: [io  0xfa00-0xfa3f] claimed by ICH4 GPIO
[    0.140036] pci 0000:00:1f.1: [8086:2411] type 0 class 0x000101
[    0.140091] pci 0000:00:1f.1: reg 20: [io  0x2460-0x246f]
[    0.140143] pci 0000:00:1f.2: [8086:2412] type 0 class 0x000c03
[    0.140199] pci 0000:00:1f.2: reg 20: [io  0x2440-0x245f]
[    0.140251] pci 0000:00:1f.5: [8086:2415] type 0 class 0x000401
[    0.140272] pci 0000:00:1f.5: reg 10: [io  0x2000-0x20ff]
[    0.140288] pci 0000:00:1f.5: reg 14: [io  0x2400-0x243f]
[    0.141039] pci 0000:02:08.0: [14f1:1610] type 0 class 0x000880
[    0.141063] pci 0000:02:08.0: reg 10: [mem 0x40500000-0x4050003f]
[    0.141079] pci 0000:02:08.0: reg 14: [mem 0x40000000-0x4000ffff]
[    0.141153] pci 0000:02:08.0: PME# supported from D3hot D3cold
[    0.141184] pci 0000:02:08.1: [14f1:1611] type 0 class 0x000203
[    0.141208] pci 0000:02:08.1: reg 10: [mem 0x40400000-0x4040007f]
[    0.141223] pci 0000:02:08.1: reg 14: [mem 0x40100000-0x40100fff]
[    0.141296] pci 0000:02:08.1: PME# supported from D3hot D3cold
[    0.141334] pci 0000:02:09.0: [1186:1300] type 0 class 0x000200
[    0.141358] pci 0000:02:09.0: reg 10: [io  0x1000-0x10ff]
[    0.141374] pci 0000:02:09.0: reg 14: [mem 0x40200000-0x402000ff]
[    0.141450] pci 0000:02:09.0: supports D1 D2
[    0.141457] pci 0000:02:09.0: PME# supported from D1 D2 D3hot D3cold
[    0.141487] pci 0000:02:0a.0: [1113:1211] type 0 class 0x000200
[    0.141511] pci 0000:02:0a.0: reg 10: [io  0x1400-0x14ff]
[    0.141527] pci 0000:02:0a.0: reg 14: [mem 0x40300000-0x403000ff]
[    0.141602] pci 0000:02:0a.0: supports D1 D2
[    0.141609] pci 0000:02:0a.0: PME# supported from D1 D2 D3hot D3cold
[    0.141652] pci 0000:00:1e.0: PCI bridge to [bus 02-02] (subtractive decode)
[    0.141997] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    0.142008] pci 0000:00:1e.0:   bridge window [mem 0x40000000-0x407fffff]
[    0.142019] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.142027] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
[    0.142044] pci_bus 0000:00: on NUMA node 0
[    0.142063] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.142998] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
[    0.143296]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
[    0.150233] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.154146] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 14 15) *9
[    0.158306] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.161392] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.165165] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.166025] vgaarb: loaded
[    0.166987] vgaarb: bridge control possible 0000:00:02.0
[    0.169108] SCSI subsystem initialized
[    0.171291] libata version 3.00 loaded.
[    0.172101] usbcore: registered new interface driver usbfs
[    0.173204] usbcore: registered new interface driver hub
[    0.174211] usbcore: registered new device driver usb
[    0.176552] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.178000] PCI: Using ACPI for IRQ routing
[    0.179030] PCI: pci_cache_line_size set to 32 bytes
[    0.179118] reserve RAM buffer: 000000000009fc00 - 000000000009ffff
[    0.179126] reserve RAM buffer: 000000000fed0000 - 000000000fffffff
[    0.179134] reserve RAM buffer: 000000000ff00000 - 000000000fffffff
[    0.180815] cfg80211: Calling CRDA to update world regulatory domain
[    0.181510] NetLabel: Initializing
[    0.182021] NetLabel:  domain hash size = 128
[    0.182984] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.184038] NetLabel:  unlabeled traffic allowed by default
[    0.200362] pnp: PnP ACPI init
[    0.201062] ACPI: bus type pnp registered
[    0.203204] pnp 00:00: [bus 00-ff]
[    0.203215] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.203234] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.203241] pnp 00:00: [io  0x0d00-0xffff window]
[    0.203249] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.203256] pnp 00:00: [mem 0x000c8000-0x000dffff window]
[    0.203263] pnp 00:00: [mem 0x0ff00000-0xfebfffff window]
[    0.203685] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.203761] pnp 00:01: [io  0x00f0-0x00ff]
[    0.203803] pnp 00:01: [irq 13]
[    0.204079] pnp 00:01: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.204141] pnp 00:02: [io  0x0000-0x000f]
[    0.204148] pnp 00:02: [io  0x0080-0x008f]
[    0.204155] pnp 00:02: [io  0x00c0-0x00df]
[    0.204162] pnp 00:02: [dma 4]
[    0.204364] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.204408] pnp 00:03: [io  0x0070-0x0071]
[    0.204432] pnp 00:03: [irq 8]
[    0.204634] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.204673] pnp 00:04: [io  0x0061]
[    0.204878] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.204955] pnp 00:05: [irq 12]
[    0.205248] pnp 00:05: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    0.205296] pnp 00:06: [io  0x0060]
[    0.205303] pnp 00:06: [io  0x0064]
[    0.205319] pnp 00:06: [irq 1]
[    0.205553] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.206429] pnp 00:07: [irq 7]
[    0.206438] pnp 00:07: [dma 3]
[    0.206446] pnp 00:07: [io  0x0378-0x037f]
[    0.206452] pnp 00:07: [io  0x0778-0x077d]
[    0.206897] pnp 00:07: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.207517] pnp 00:08: [irq 4]
[    0.207525] pnp 00:08: [io  0x03f8-0x03ff]
[    0.207944] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.208430] pnp 00:09: [irq 3]
[    0.208439] pnp 00:09: [io  0x02f8-0x02ff]
[    0.208872] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.209388] pnp 00:0a: [irq 6]
[    0.209397] pnp 00:0a: [dma 2]
[    0.209404] pnp 00:0a: [io  0x03f0-0x03f5]
[    0.209410] pnp 00:0a: [io  0x03f7]
[    0.209662] pnp 00:0a: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.209758] pnp 00:0b: [mem 0xfec00000-0xfec00fff]
[    0.209957] pnp 00:0b: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.210082] pnp 00:0c: [io  0x0010-0x001f]
[    0.210089] pnp 00:0c: [io  0x002e-0x002f]
[    0.210096] pnp 00:0c: [io  0x0050-0x0053]
[    0.210102] pnp 00:0c: [io  0x0072-0x0077]
[    0.210108] pnp 00:0c: [io  0x0090-0x009f]
[    0.210114] pnp 00:0c: [io  0x04d0-0x04d1]
[    0.210377] system 00:0c: [io  0x04d0-0x04d1] has been reserved
[    0.211014] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.211066] pnp 00:0d: [io  0x0400-0x041f]
[    0.211073] pnp 00:0d: [io  0x0420-0x043f]
[    0.211079] pnp 00:0d: [io  0x0440-0x045f]
[    0.211085] pnp 00:0d: [io  0x0460-0x047f]
[    0.211092] pnp 00:0d: [io  0xf800-0xf81f]
[    0.211098] pnp 00:0d: [io  0xf820-0xf83f]
[    0.211104] pnp 00:0d: [io  0xf840-0xf85f]
[    0.211110] pnp 00:0d: [io  0xf860-0xf87f]
[    0.211116] pnp 00:0d: [io  0xfa00-0xfa3f]
[    0.211122] pnp 00:0d: [io  0xfc00-0xfc7f]
[    0.211129] pnp 00:0d: [io  0xfc80-0xfcff]
[    0.211135] pnp 00:0d: [io  0xfe00-0xfe7f]
[    0.211141] pnp 00:0d: [io  0xfe80-0xfeff]
[    0.211162] pnp 00:0d: disabling [io  0xf800-0xf81f] because it overlaps 0000:00:1f.0 BAR 7 [io  0xf800-0xf87f]
[    0.211985] pnp 00:0d: disabling [io  0xf820-0xf83f] because it overlaps 0000:00:1f.0 BAR 7 [io  0xf800-0xf87f]
[    0.212984] pnp 00:0d: disabling [io  0xf840-0xf85f] because it overlaps 0000:00:1f.0 BAR 7 [io  0xf800-0xf87f]
[    0.213984] pnp 00:0d: disabling [io  0xf860-0xf87f] because it overlaps 0000:00:1f.0 BAR 7 [io  0xf800-0xf87f]
[    0.216105] system 00:0d: [io  0x0400-0x041f] has been reserved
[    0.216993] system 00:0d: [io  0x0420-0x043f] has been reserved
[    0.217983] system 00:0d: [io  0x0440-0x045f] has been reserved
[    0.218983] system 00:0d: [io  0x0460-0x047f] has been reserved
[    0.219998] system 00:0d: [io  0xfa00-0xfa3f] has been reserved
[    0.220987] system 00:0d: [io  0xfc00-0xfc7f] has been reserved
[    0.221982] system 00:0d: [io  0xfc80-0xfcff] has been reserved
[    0.222982] system 00:0d: [io  0xfe00-0xfe7f] has been reserved
[    0.223984] system 00:0d: [io  0xfe80-0xfeff] has been reserved
[    0.224990] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.225416] pnp 00:0e: [mem 0x00000000-0x0009ffff]
[    0.225425] pnp 00:0e: [mem 0x000e0000-0x000fffff]
[    0.225431] pnp 00:0e: [mem 0x00100000-0x0fefffff]
[    0.225438] pnp 00:0e: [mem 0xfff80000-0xffffffff]
[    0.225445] pnp 00:0e: [mem 0xfeea0000-0xfeebffff]
[    0.225452] pnp 00:0e: [mem 0xffb80000-0xffbfffff]
[    0.226206] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.226991] system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.227981] system 00:0e: [mem 0x00100000-0x0fefffff] could not be reserved
[    0.228982] system 00:0e: [mem 0xfff80000-0xffffffff] has been reserved
[    0.229998] system 00:0e: [mem 0xfeea0000-0xfeebffff] has been reserved
[    0.230989] system 00:0e: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.231983] system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.232982] pnp: PnP ACPI: found 15 devices
[    0.233982] ACPI: ACPI bus type pnp unregistered
[    0.240099] kworker/u:0 used greatest stack depth: 7108 bytes left
[    0.285319] Switching to clocksource acpi_pm
[    0.286060] PCI: max bus depth: 1 pci_try_num: 2
[    0.286109] pci 0000:00:1e.0: PCI bridge to [bus 02-02]
[    0.291334] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    0.297441] pci 0000:00:1e.0:   bridge window [mem 0x40000000-0x407fffff]
[    0.304260] pci 0000:00:1e.0: setting latency timer to 64
[    0.304272] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.304280] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.304288] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.304295] pci_bus 0000:02: resource 1 [mem 0x40000000-0x407fffff]
[    0.304303] pci_bus 0000:02: resource 4 [io  0x0000-0xffff]
[    0.304310] pci_bus 0000:02: resource 5 [mem 0x00000000-0xffffffff]
[    0.304473] NET: Registered protocol family 2
[    0.309072] IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.316611] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.323945] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.330623] TCP: Hash tables configured (established 8192 bind 8192)
[    0.336988] TCP reno registered
[    0.340139] UDP hash table entries: 128 (order: 0, 4096 bytes)
[    0.346024] UDP-Lite hash table entries: 128 (order: 0, 4096 bytes)
[    0.352623] NET: Registered protocol family 1
[    0.357462] RPC: Registered named UNIX socket transport module.
[    0.363416] RPC: Registered udp transport module.
[    0.368121] RPC: Registered tcp transport module.
[    0.372825] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.379323] pci 0000:00:02.0: Boot video device
[    0.379354] pci 0000:00:1f.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.379361] pci 0000:00:1f.2: Performing full reset
[    0.379399] PCI: CLS 0 bytes, default 32
[    0.381482] microcode: CPU0 sig=0x686, pf=0x10, revision=0x8
[    0.387422] microcode: Microcode Update Driver: v2.00<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.396348] SSE2 instructions are not detected.
[    0.402002] audit: initializing netlink socket (disabled)
[    0.407539] type=2000 audit(1326716923.406:1): initialized
[    0.414375] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.436506] VFS: Disk quotas dquot_6.5.2
[    0.440892] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.453228] msgmni has been set to 485
[    0.457498] SELinux:  Registering netfilter hooks
[    0.459267] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.466726] io scheduler noop registered
[    0.470655] io scheduler deadline registered
[    0.474984] io scheduler cfq registered (default)
[    0.480507] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.486958] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.495231] ACPI: Power Button [PBTN]
[    0.499187] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.506620] ACPI: Power Button [PWRF]
[    0.514315] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.785130] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.055127] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.082782] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.109191] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.115985] Non-volatile memory driver v1.3
[    1.120316] intel_rng: FWH not detected
[    1.124228] Linux agpgart interface v0.103
[    1.128651] agpgart-intel 0000:00:00.0: Intel i815 Chipset
[    1.134215] agpgart-intel 0000:00:00.0: detected gtt size: 65536K total, 65536K mappable
[    1.143255] agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0x44000000
[    1.150361] [drm] Initialized drm 1.1.0 20060810
[    1.198636] fbcon:  (fb0) is primary device
[    1.226968] Console: switching to colour frame buffer device 80x30
[    1.237610] I810FB: fb0         : Intel(R) 815 (Internal Graphics with AGP) Framebuffer Device v0.9.0
[    1.237615] I810FB: Video RAM   : 4096K
[    1.237618] I810FB: Monitor     : H: 29-30 KHz V: 60-60 Hz
[    1.237621] I810FB: Mode        : 640x480-8bpp@60Hz
[    1.269124] brd: module loaded
[    1.274937] kworker/u:0 used greatest stack depth: 6984 bytes left
[    1.282863] loop: module loaded
[    1.287322] ata_piix 0000:00:1f.1: version 2.13
[    1.287503] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.289380] scsi0 : ata_piix
[    1.292844] scsi1 : ata_piix
[    1.296512] ata1: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0x2460 irq 14
[    1.303422] ata2: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0x2468 irq 15
[    1.311659] 8139too: 8139too Fast Ethernet driver 0.9.28
[    1.318544] 8139too 0000:02:09.0: eth0: RealTek RTL8139 at 0xd0714000, 00:05:5d:49:eb:21, IRQ 17
[    1.328840] 8139too 0000:02:0a.0: eth1: RealTek RTL8139 at 0xd0716000, 00:10:b5:ac:ea:7d, IRQ 18
[    1.338532] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.345110] ehci_hcd: block sizes: qh 64 qtd 96 itd 160 sitd 96
[    1.345286] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.351497] ohci_hcd: block sizes: ed 64 td 64
[    1.351644] uhci_hcd: USB Universal Host Controller Interface driver
[    1.358223] uhci_hcd 0000:00:1f.2: setting latency timer to 64
[    1.358235] uhci_hcd 0000:00:1f.2: UHCI Host Controller
[    1.363542] drivers/usb/core/inode.c: creating file 'devices'
[    1.363557] drivers/usb/core/inode.c: creating file '001'
[    1.363813] uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
[    1.371260] uhci_hcd 0000:00:1f.2: detected 2 ports
[    1.376153] uhci_hcd 0000:00:1f.2: uhci_check_and_reset_hc: cmd = 0x0000
[    1.376160] uhci_hcd 0000:00:1f.2: Performing full reset
[    1.376178] uhci_hcd 0000:00:1f.2: supports USB remote wakeup
[    1.376230] uhci_hcd 0000:00:1f.2: irq 19, io base 0x00002440
[    1.382044] Refined TSC clocksource calibration: 930.314 MHz.
[    1.387899] usb usb1: default language 0x0409
[    1.387920] usb usb1: udev 1, busnum 1, minor = 0
[    1.387927] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    1.394724] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.401946] usb usb1: Product: UHCI Host Controller
[    1.406832] usb usb1: Manufacturer: Linux 3.2.0-08694-g53999bf uhci_hcd
[    1.413445] usb usb1: SerialNumber: 0000:00:1f.2
[    1.418072] Switching to clocksource tsc
[    1.422412] usb usb1: usb_probe_device
[    1.422424] usb usb1: configuration #1 chosen from 1 choice
[    1.422455] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    1.422652] hub 1-0:1.0: usb_probe_interface
[    1.422660] hub 1-0:1.0: usb_probe_interface - got id
[    1.422668] hub 1-0:1.0: USB hub found
[    1.426463] hub 1-0:1.0: 2 ports detected
[    1.430490] hub 1-0:1.0: standalone hub
[    1.430497] hub 1-0:1.0: no power switching (usb 1.0)
[    1.430504] hub 1-0:1.0: individual port over-current protection
[    1.430511] hub 1-0:1.0: power on to power good time: 2ms
[    1.430525] hub 1-0:1.0: local power source is good
[    1.430533] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    1.430588] drivers/usb/core/inode.c: creating file '001'
[    1.430943] usbcore: registered new interface driver usblp
[    1.436454] Initializing USB Mass Storage driver...
[    1.441490] usbcore: registered new interface driver usb-storage
[    1.447511] USB Mass Storage support registered.
[    1.452250] usbcore: registered new interface driver libusual
[    1.458379] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    1.470497] ata1.00: ATA-7: Maxtor 6G160P0, KA201V00, max UDMA/133
[    1.476714] ata1.00: 312581808 sectors, multi 16: LBA48
[    1.482135] ata2.00: ATA-7: Maxtor 6G160P0, KA201V00, max UDMA/133
[    1.488319] ata2.00: 312581808 sectors, multi 16: LBA48
[    1.494102] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.499248] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.505180] mousedev: PS/2 mouse device common for all mice
[    1.510850] ata1.00: configured for UDMA/66
[    1.515450] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6G160P0   KA20 PQ: 0 ANSI: 5
[    1.525291] rtc_cmos 00:03: RTC can wake from S4
[    1.530320] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.530776] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.538388] ata2.00: configured for UDMA/66
[    1.543339] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.548818] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.555210] sd 0:0:0:0: [sda] Write Protect is off
[    1.560029] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.560594] scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6G160P0   KA20 PQ: 0 ANSI: 5
[    1.568797] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    1.575066] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.584206] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    1.593835] sd 1:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.601681] md: raid1 personality registered for level 1
[    1.607941] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.613539] sd 1:0:0:0: [sdb] Write Protect is off
[    1.618391] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.620485] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.630164] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    1.638913] cpuidle: using governor ladder
[    1.643512] cpuidle: using governor menu
[    1.647542] EFI Variables Facility v0.08 2004-May-17
[    1.652679]  sda: sda1 sda2 sda3 sda4
[    1.660003] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.667269] usbcore: registered new interface driver usbhid
[    1.672912] usbhid: USB HID core driver
[    1.678342] ALSA device list:
[    1.681373]   No soundcards found.
[    1.684969]  sdb: sdb1 sdb2 sdb3 sdb4
[    1.689597] Netfilter messages via NETLINK v0.30.
[    1.694788] nf_conntrack version 0.5.0 (3887 buckets, 15548 max)
[    1.701431] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.706899] ctnetlink v0.93: registering with nfnetlink.
[    1.713494] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.718956] TCP cubic registered
[    1.722195] Initializing XFRM netlink socket
[    1.727615] NET: Registered protocol family 10
[    1.735178] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    1.740778] IPv6 over IPv4 tunneling driver
[    1.747229] NET: Registered protocol family 17
[    1.751747] Registering the dns_resolver key type
[    1.756580] Using IPI No-Shortcut mode
[    1.760875] PM: Hibernation image not present or could not be loaded.
[    1.760910] registered taskstats version 1
[    1.765433]   Magic number: 12:368:481
[    1.769261] ata_device dev1.0: hash matches
[    1.773445]  dev1.0: hash matches
[    1.776918] console [netcon0] enabled
[    1.780588] netconsole: network logging started
[    1.785621] md: Waiting for all devices to be available before autodetect
[    1.792428] md: If you don't use raid, use raid=noautodetect
[    1.798792] md: Autodetecting RAID arrays.
[    1.930516] md: Scanned 8 and added 8 devices.
[    1.934964] md: autorun ...
[    1.937759] md: considering sdb4 ...
[    1.941369] md:  adding sdb4 ...
[    1.944609] md: sdb3 has different UUID to sdb4
[    1.949145] md: sdb2 has different UUID to sdb4
[    1.953684] md: sdb1 has different UUID to sdb4
[    1.958245] md:  adding sda4 ...
[    1.961484] md: sda3 has different UUID to sdb4
[    1.966021] md: sda2 has different UUID to sdb4
[    1.970561] md: sda1 has different UUID to sdb4
[    1.975789] md: created md4
[    1.978610] md: bind<sda4>
[    1.981356] md: bind<sdb4>
[    1.984107] md: running:<sdb4><sda4>
[    1.987897] bio: create slab<bio-1>  at 1
[    1.992101] md/raid1:md4: active with 2 out of 2 mirrors
[    1.997708] created bitmap (169 pages) for device md4
[    2.015799] md4: bitmap initialized from disk: read 11/11 pages, set 0 of 344990 bits
[    2.031120] md4: detected capacity change from 0 to 90436861952
[    2.037283] md: considering sdb3 ...
[    2.040939] md:  adding sdb3 ...
[    2.044200] md: sdb2 has different UUID to sdb3
[    2.048754] md: sdb1 has different UUID to sdb3
[    2.053313] md:  adding sda3 ...
[    2.056573] md: sda2 has different UUID to sdb3
[    2.061126] md: sda1 has different UUID to sdb3
[    2.066304] md: created md3
[    2.069121] md: bind<sda3>
[    2.071868] md: bind<sdb3>
[    2.074616] md: running:<sdb3><sda3>
[    2.078552] md/raid1:md3: active with 2 out of 2 mirrors
[    2.084173] created bitmap (233 pages) for device md3
[    2.106983] md3: bitmap initialized from disk: read 15/15 pages, set 0 of 476364 bits
[    2.141716] md3: detected capacity change from 0 to 62437982208
[    2.147862] md: considering sdb2 ...
[    2.151517] md:  adding sdb2 ...
[    2.154775] md: sdb1 has different UUID to sdb2
[    2.159336] md:  adding sda2 ...
[    2.162596] md: sda1 has different UUID to sdb2
[    2.167712] md: created md2
[    2.170534] md: bind<sda2>
[    2.173289] md: bind<sdb2>
[    2.176043] md: running:<sdb2><sda2>
[    2.179970] md/raid1:md2: active with 2 out of 2 mirrors
[    2.185572] created bitmap (123 pages) for device md2
[    2.200001] md2: bitmap initialized from disk: read 8/8 pages, set 1 of 250000 bits
[    2.231433] md2: detected capacity change from 0 to 2048000000
[    2.237503] md: considering sdb1 ...
[    2.241162] md:  adding sdb1 ...
[    2.244431] md:  adding sda1 ...
[    2.248327] md: created md1
[    2.251147] md: bind<sda1>
[    2.253894] md: bind<sdb1>
[    2.256635] md: running:<sdb1><sda1>
[    2.260591] md/raid1:md1: active with 2 out of 2 mirrors
[    2.266222] created bitmap (153 pages) for device md1
[    2.282944] md1: bitmap initialized from disk: read 10/10 pages, set 0 of 312256 bits
[    2.305702] md1: detected capacity change from 0 to 5116002304
[    2.311769] md: ... autorun DONE.
[    2.316625]  md4: unknown partition table
[    2.333665] kjournald starting.  Commit interval 5 seconds
[    2.339353] EXT3-fs (md4): mounted filesystem with writeback data mode
[    2.345926] VFS: Mounted root (ext3 filesystem) readonly on device 9:4.
[    2.352598] Freeing unused kernel memory: 436k freed
[    2.359296] Write protecting the kernel text: 6448k
[    2.364295] Write protecting the kernel read-only data: 1548k
[    2.454034] usb usb1: suspend_rh (auto-stop)
[    3.039006] cat used greatest stack depth: 6464 bytes left
[    3.078319] setfont used greatest stack depth: 6460 bytes left
[    3.165467] loadkeys used greatest stack depth: 5900 bytes left
[    3.172073] init-early.sh used greatest stack depth: 5672 bytes left
[    4.901376] udev[954]: starting version 164
[    5.920301]  md3: unknown partition table
[    5.933222] mdadm: sending ioctl 1261 to a partition!
[    5.933239] mdadm: sending ioctl 1261 to a partition!
[    5.934716] mdadm: sending ioctl 1261 to a partition!
[    5.934727] mdadm: sending ioctl 1261 to a partition!
[    5.940425]  md1: unknown partition table
[    5.947561] mdadm: sending ioctl 1261 to a partition!
[    5.947577] mdadm: sending ioctl 1261 to a partition!
[    5.949161]  md2: unknown partition table
[    5.958450] mdadm: sending ioctl 1261 to a partition!
[    5.958466] mdadm: sending ioctl 1261 to a partition!
[    5.959314] mdadm: sending ioctl 1261 to a partition!
[    5.959326] mdadm: sending ioctl 1261 to a partition!
[   11.541914] scsi_verify_blk_ioctl: 288 callbacks suppressed
[   11.541927] mdadm: sending ioctl 1261 to a partition!
[   11.541936] mdadm: sending ioctl 1261 to a partition!
[   12.008059] mdadm: sending ioctl 1261 to a partition!
[   12.008075] mdadm: sending ioctl 1261 to a partition!
[   12.165784] EXT3-fs (md4): using internal journal
[   12.413966] kjournald starting.  Commit interval 5 seconds
[   12.447406] EXT3-fs (md3): using internal journal
[   12.447418] EXT3-fs (md3): mounted filesystem with writeback data mode
[   15.568968] Adding 1999996k swap on /dev/md2.  Priority:-1 extents:1 across:1999996k
[   17.096065] 8139too 0000:02:09.0: eth0: link up, 100Mbps, full-duplex, lpa 0xC5E1
[   28.098021] eth0: no IPv6 routers present
[   55.060056] kjournald starting.  Commit interval 5 seconds
[   55.184550] EXT3-fs (md1): using internal journal
[   55.184572] EXT3-fs (md1): mounted filesystem with writeback data mode
[  259.545044] kjournald starting.  Commit interval 5 seconds
[  259.586623] EXT3-fs (md1): using internal journal
[  259.586643] EXT3-fs (md1): mounted filesystem with writeback data mode


