Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762606Ab2DLTmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:42:02 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:34130 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab2DLTl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:41:57 -0400
Date: Thu, 12 Apr 2012 22:41:53 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: x86: runtime waring in pcibios_fwaddrmap_lookup
Message-ID: <alpine.SOC.1.00.1204122238400.16365@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------[ cut here ]------------
Got this in amd64 PC running 3.4.0-rc2. Full dmesg below.

WARNING: at arch/x86/pci/i386.c:60 pcibios_fwaddrmap_lookup+0x1a/0x3a()
Hardware name: 939Dual-SATA2
Modules linked in:
Pid: 1, comm: swapper Not tainted 3.4.0-rc2 #194
Call Trace:
 [<ffffffff81023c0a>] warn_slowpath_common+0x7e/0x96
 [<ffffffff81023c37>] warn_slowpath_null+0x15/0x17
 [<ffffffff8121f2b5>] pcibios_fwaddrmap_lookup+0x1a/0x3a
 [<ffffffff812dd345>] pcibios_save_fw_addr+0x3d/0xcb
 [<ffffffff8168006d>] pcibios_allocate_resources+0xc8/0x15f
 [<ffffffff81681109>] ? pci_legacy_init+0x3e/0x3e
 [<ffffffff8168011b>] pcibios_resource_survey+0x17/0x2d
 [<ffffffff81681a15>] pcibios_init+0x28/0x3a
 [<ffffffff8168114d>] pci_subsys_init+0x44/0x4a
 [<ffffffff81681109>] ? pci_legacy_init+0x3e/0x3e
 [<ffffffff81000208>] do_one_initcall+0x78/0x128
 [<ffffffff8165fb00>] do_basic_setup+0x91/0xaf
 [<ffffffff8165f44e>] ? rdinit_setup+0x28/0x28
 [<ffffffff8168996c>] ? setup_APIC_timer+0x50/0x52
 [<ffffffff8165fb83>] kernel_init+0x65/0xd6
 [<ffffffff812e0fc4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8165fb1e>] ? do_basic_setup+0xaf/0xaf
 [<ffffffff812e0fc0>] ? gs_change+0xb/0xb
---[ end trace 6d450e935ee1897c ]---


Linux version 3.4.0-rc2 (mroos@vaarikas) (gcc version 4.6.3 (Debian 4.6.3-2) ) #194 PREEMPT Sun Apr 8 17:40:51 EEST 2012
Command line: BOOT_IMAGE=/boot/vmlinuz-3.4.0-rc2 root=/dev/sda1 ro pata_ali.atapi_dma=1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000009efb0000 (usable)
 BIOS-e820: 000000009efb0000 - 000000009efc0000 (ACPI data)
 BIOS-e820: 000000009efc0000 - 000000009eff0000 (ACPI NVS)
 BIOS-e820: 000000009eff0000 - 000000009f000000 (reserved)
 BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI 2.3 present.
DMI:          939Dual-SATA2/939Dual-SATA2, BIOS P2.30 09/25/2006
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
AGP bridge at 00:04:00
Aperture from AGP @ d0000000 old size 32 MB
Aperture size 4096 MB (APSIZE 0) is not right, using settings from NB
Aperture from AGP @ d0000000 size 32 MB (APSIZE 0)
last_pfn = 0x9efb0 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0000000000 mask FF80000000 write-back
  1 base 0080000000 mask FFF0000000 write-back
  2 base 0090000000 mask FFF8000000 write-back
  3 base 0098000000 mask FFFC000000 write-back
  4 base 009C000000 mask FFFE000000 write-back
  5 base 009E000000 mask FFFF000000 write-back
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
found SMP MP-table at [ffff8800000ff780] ff780
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff88000009a000] 9a000 size 20480
init_memory_mapping: 0000000000000000-000000009efb0000
 0000000000 - 009ee00000 page 2M
 009ee00000 - 009efb0000 page 4k
kernel direct mapping tables up to 9efb0000 @ 1fffb000-20000000
ACPI: RSDP 00000000000f9a50 00014 (v00 ACPIAM)
ACPI: RSDT 000000009efb0000 00034 (v01 A M I  OEMRSDT  09000625 MSFT 00000097)
ACPI: FACP 000000009efb0200 00084 (v02 A M I  OEMFACP  09000625 MSFT 00000097)
ACPI: DSDT 000000009efb0440 0474D (v01  939M2 939M2222 00000222 INTL 02002026)
ACPI: FACS 000000009efc0000 00040
ACPI: APIC 000000009efb0390 00068 (v01 A M I  OEMAPIC  09000625 MSFT 00000097)
ACPI: MCFG 000000009efb0400 0003C (v01 A M I  OEMMCFG  09000625 MSFT 00000097)
ACPI: OEMB 000000009efc0040 00057 (v01 A M I  AMI_OEM  09000625 MSFT 00000097)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea00023fffff] PMD -> [ffff88009be00000-ffff88009e1fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
Early memory PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0009efb0
On node 0 totalpages: 651071
  DMA zone: 56 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3922 pages, LIFO batch:0
  DMA32 zone: 8847 pages used for memmap
  DMA32 zone: 638241 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x02] address[0xfec10000] gsi_base[24])
IOAPIC[1]: apic_id 2, version 17, address 0xfec10000, GSI 24-39
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
nr_irqs_gsi: 56
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
Allocating PCI resources starting at 9f000000 (gap: 9f000000:607c0000)
pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
pcpu-alloc: [0] 0 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 642163
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.4.0-rc2 root=/dev/sda1 ro pata_ali.atapi_dma=1
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
AGP bridge at 00:04:00
Aperture from AGP @ d0000000 old size 32 MB
Aperture size 4096 MB (APSIZE 0) is not right, using settings from NB
Aperture from AGP @ d0000000 size 32 MB (APSIZE 0)
Node 0: aperture @ d0000000 size 256 MB
Memory: 2553652k/2604736k available (2956k kernel code, 452k absent, 50632k reserved, 3562k data, 396k init)
NR_IRQS:4352 nr_irqs:256 16
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Fast TSC calibration using PIT
Detected 2199.907 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4399.81 BogoMIPS (lpj=8799628)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Mount-cache hash table entries: 256
tseg: 0000000000
mce: CPU supports 5 MCE banks
CPU: AMD Athlon(tm) 64 Processor 3500+ stepping 02
ACPI: Core revision 20120320
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
NMI watchdog: enabled, takes one hw-pmu counter.
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
PM: Registering ACPI NVS region [mem 0x9efc0000-0x9efeffff] (196608 bytes)
NET: Registered protocol family 16
node 0 link 0: io port [1000, ffffff]
TOM: 000000009f000000 aka 2544M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [9f000000, ffffffff]
bus: [00, ff] on node 0 link 0
bus: 00 index 0 [io  0x0000-0xffff]
bus: 00 index 1 [mem 0x9f000000-0xfcffffffff]
bus: 00 index 2 [mem 0x000a0000-0x000bffff]
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x9f000000-0xffffffff] (ignored)
PCI: root bus 00: hardware-probed resources
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
pci_bus 0000:00: root bus resource [mem 0x9f000000-0xfcffffffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci 0000:00:00.0: [10b9:1695] type 00 class 0x060000
pci 0000:00:01.0: [10b9:524b] type 01 class 0x060400
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: [10b9:524c] type 01 class 0x060400
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: [10b9:524d] type 01 class 0x060400
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: [10b9:1689] type 00 class 0x060000
pci 0000:00:04.0: reg 10: [mem 0xd0000000-0xdfffffff pref]
pci 0000:00:05.0: [10b9:5246] type 01 class 0x060400
pci 0000:00:06.0: [10b9:5249] type 01 class 0x060401
pci 0000:00:07.0: [10b9:1563] type 00 class 0x060100
pci 0000:00:07.1: [10b9:7101] type 00 class 0x068000
pci 0000:00:07.1: quirk: [io  0x0800-0x083f] claimed by ali7101 ACPI
pci 0000:00:12.0: [10b9:5229] type 00 class 0x01018a
pci 0000:00:12.0: reg 20: [io  0xff00-0xff0f]
pci 0000:00:12.1: [10b9:5289] type 00 class 0x01018f
pci 0000:00:12.1: reg 10: [io  0xec00-0xec07]
pci 0000:00:12.1: reg 14: [io  0xe880-0xe883]
pci 0000:00:12.1: reg 18: [io  0xe800-0xe807]
pci 0000:00:12.1: reg 1c: [io  0xe480-0xe483]
pci 0000:00:12.1: reg 20: [io  0xe400-0xe40f]
pci 0000:00:13.0: [10b9:5237] type 00 class 0x0c0310
pci 0000:00:13.0: reg 10: [mem 0xff6ff000-0xff6fffff]
pci 0000:00:13.1: [10b9:5237] type 00 class 0x0c0310
pci 0000:00:13.1: reg 10: [mem 0xff6fe000-0xff6fefff]
pci 0000:00:13.2: [10b9:5237] type 00 class 0x0c0310
pci 0000:00:13.2: reg 10: [mem 0xff6fd000-0xff6fdfff]
pci 0000:00:13.3: [10b9:5239] type 00 class 0x0c0320
pci 0000:00:13.3: reg 10: [mem 0xff6fcc00-0xff6fccff]
pci 0000:00:13.3: PME# supported from D0 D3hot D3cold
pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
pci 0000:01:00.0: [1002:954f] type 00 class 0x030000
pci 0000:01:00.0: reg 10: [mem 0xa0000000-0xafffffff 64bit pref]
pci 0000:01:00.0: reg 18: [mem 0xff0f0000-0xff0fffff 64bit]
pci 0000:01:00.0: reg 20: [io  0xa000-0xa0ff]
pci 0000:01:00.0: reg 30: [mem 0xff0c0000-0xff0dffff pref]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: [1002:aa38] type 00 class 0x040300
pci 0000:01:00.1: reg 10: [mem 0xff0ec000-0xff0effff 64bit]
pci 0000:01:00.1: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x8000-0xafff]
pci 0000:00:01.0:   bridge window [mem 0xff000000-0xff0fffff]
pci 0000:00:01.0:   bridge window [mem 0x9fe00000-0xbfdfffff pref]
pci 0000:00:02.0: PCI bridge to [bus 02-02]
pci 0000:00:02.0:   bridge window [mem 0xff100000-0xff1fffff]
pci 0000:03:00.0: [197b:2360] type 00 class 0x010601
pci 0000:03:00.0: reg 10: [io  0xbc00-0xbc07]
pci 0000:03:00.0: reg 14: [io  0xb880-0xb883]
pci 0000:03:00.0: reg 18: [io  0xb800-0xb807]
pci 0000:03:00.0: reg 1c: [io  0xb480-0xb483]
pci 0000:03:00.0: reg 20: [io  0xb400-0xb40f]
pci 0000:03:00.0: reg 24: [mem 0x00000000-0x00001fff]
pci 0000:03:00.0: PME# supported from D3hot
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:03.0: PCI bridge to [bus 03-03]
pci 0000:00:03.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:03.0:   bridge window [mem 0xff200000-0xff2fffff]
pci 0000:00:05.0: PCI bridge to [bus 04-04]
pci 0000:00:05.0:   bridge window [mem 0xff300000-0xff3fffff]
pci 0000:05:05.0: [1102:0002] type 00 class 0x000100
pci 0000:05:05.0: reg 10: [io  0xd880-0xd89f]
pci 0000:05:05.0: supports D1 D2
pci 0000:05:05.1: [1102:7002] type 00 class 0x098000
pci 0000:05:05.1: reg 10: [io  0xdc00-0xdc07]
pci 0000:05:05.1: supports D1 D2
pci 0000:05:06.0: [8086:b154] type 01 class 0x060400
pci 0000:05:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:05:07.0: [109e:036e] type 00 class 0x040000
pci 0000:05:07.0: reg 10: [mem 0xbfeff000-0xbfefffff pref]
pci 0000:05:07.1: [109e:0878] type 00 class 0x048000
pci 0000:05:07.1: reg 10: [mem 0xbfefe000-0xbfefefff pref]
pci 0000:00:06.0: PCI bridge to [bus 05-06] (subtractive decode)
pci 0000:00:06.0:   bridge window [io  0xc000-0xdfff]
pci 0000:00:06.0:   bridge window [mem 0xff400000-0xff5fffff]
pci 0000:00:06.0:   bridge window [mem 0xbfe00000-0xbfefffff pref]
pci 0000:00:06.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:06.0:   bridge window [mem 0x9f000000-0xfcffffffff] (subtractive decode)
pci 0000:00:06.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:06:04.0: [8086:1229] type 00 class 0x020000
pci 0000:06:04.0: reg 10: [mem 0xff4ff000-0xff4fffff]
pci 0000:06:04.0: reg 14: [io  0xcc00-0xcc3f]
pci 0000:06:04.0: reg 18: [mem 0xff4c0000-0xff4dffff]
pci 0000:06:04.0: supports D1 D2
pci 0000:06:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:06:05.0: [8086:1229] type 00 class 0x020000
pci 0000:06:05.0: reg 10: [mem 0xff4fe000-0xff4fefff]
pci 0000:06:05.0: reg 14: [io  0xc880-0xc8bf]
pci 0000:06:05.0: reg 18: [mem 0xff4a0000-0xff4bffff]
pci 0000:06:05.0: supports D1 D2
pci 0000:06:05.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:05:06.0: PCI bridge to [bus 06-06]
pci 0000:05:06.0:   bridge window [io  0xc000-0xcfff]
pci 0000:05:06.0:   bridge window [mem 0xff400000-0xff4fffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HTT_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB3._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
ACPI _OSC control for PCIe not granted, disabling ASPM
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 12 14 *15), disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKP] (IRQs 3 4 *5 6 7 10 11 12 14 15)
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:01:00.0
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
pci 0000:00:04.0: address space collision: [mem 0xd0000000-0xdfffffff pref] conflicts with GART [mem 0xd0000000-0xdfffffff]
------------[ cut here ]------------
WARNING: at arch/x86/pci/i386.c:60 pcibios_fwaddrmap_lookup+0x1a/0x3a()
Hardware name: 939Dual-SATA2
Modules linked in:
Pid: 1, comm: swapper Not tainted 3.4.0-rc2 #194
Call Trace:
 [<ffffffff81023c0a>] warn_slowpath_common+0x7e/0x96
 [<ffffffff81023c37>] warn_slowpath_null+0x15/0x17
 [<ffffffff8121f2b5>] pcibios_fwaddrmap_lookup+0x1a/0x3a
 [<ffffffff812dd345>] pcibios_save_fw_addr+0x3d/0xcb
 [<ffffffff8168006d>] pcibios_allocate_resources+0xc8/0x15f
 [<ffffffff81681109>] ? pci_legacy_init+0x3e/0x3e
 [<ffffffff8168011b>] pcibios_resource_survey+0x17/0x2d
 [<ffffffff81681a15>] pcibios_init+0x28/0x3a
 [<ffffffff8168114d>] pci_subsys_init+0x44/0x4a
 [<ffffffff81681109>] ? pci_legacy_init+0x3e/0x3e
 [<ffffffff81000208>] do_one_initcall+0x78/0x128
 [<ffffffff8165fb00>] do_basic_setup+0x91/0xaf
 [<ffffffff8165f44e>] ? rdinit_setup+0x28/0x28
 [<ffffffff8168996c>] ? setup_APIC_timer+0x50/0x52
 [<ffffffff8165fb83>] kernel_init+0x65/0xd6
 [<ffffffff812e0fc4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8165fb1e>] ? do_basic_setup+0xaf/0xaf
 [<ffffffff812e0fc0>] ? gs_change+0xb/0xb
---[ end trace 6d450e935ee1897c ]---
reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
reserve RAM buffer: 000000009efb0000 - 000000009fffffff 
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000d0000-0x000dffff window]
pnp 00:00: [mem 0x9f000000-0xffffffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: [dma 4]
pnp 00:01: [io  0x0000-0x000f]
pnp 00:01: [io  0x0081-0x0083]
pnp 00:01: [io  0x0087]
pnp 00:01: [io  0x0089-0x008b]
pnp 00:01: [io  0x008f]
pnp 00:01: [io  0x00c0-0x00df]
pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:02: [io  0x0070-0x0071]
pnp 00:02: [irq 8]
pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:03: [io  0x0061]
pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:04: [io  0x00f0-0x00ff]
pnp 00:04: [irq 13]
pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:05: [io  0x03f0-0x03f5]
pnp 00:05: [io  0x03f7]
pnp 00:05: [irq 6]
pnp 00:05: [dma 2]
pnp 00:05: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:06: [io  0x0378-0x037f]
pnp 00:06: [io  0x0778-0x077f]
pnp 00:06: [irq 7]
pnp 00:06: [dma 3]
pnp 00:06: Plug and Play ACPI device, IDs PNP0401 (active)
pnp 00:07: [io  0x0010-0x001f]
pnp 00:07: [io  0x0022-0x003f]
pnp 00:07: [io  0x0044-0x005f]
pnp 00:07: [io  0x0062-0x0063]
pnp 00:07: [io  0x0065-0x006f]
pnp 00:07: [io  0x0072-0x007f]
pnp 00:07: [io  0x0080]
pnp 00:07: [io  0x0084-0x0086]
pnp 00:07: [io  0x0088]
pnp 00:07: [io  0x008c-0x008e]
pnp 00:07: [io  0x0090-0x009f]
pnp 00:07: [io  0x00a2-0x00bf]
pnp 00:07: [io  0x00e0-0x00ef]
pnp 00:07: [io  0x0480-0x048f]
pnp 00:07: [io  0x04d0-0x04d1]
pnp 00:07: [io  0x0800-0x087f]
pnp 00:07: [io  0x0400-0x040f]
system 00:07: [io  0x0480-0x048f] has been reserved
system 00:07: [io  0x04d0-0x04d1] has been reserved
system 00:07: [io  0x0800-0x087f] could not be reserved
system 00:07: [io  0x0400-0x040f] has been reserved
system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:08: [mem 0xfec00000-0xfec00fff]
pnp 00:08: [mem 0xfee00000-0xfee00fff]
pnp 00:08: [mem 0xe0000000-0xefffffff]
pnp 00:08: [mem 0xfec10000-0xfec10fff]
pnp 00:08: [mem 0xffb00000-0xffffffff]
system 00:08: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:08: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
system 00:08: [mem 0xfec10000-0xfec10fff] could not be reserved
system 00:08: [mem 0xffb00000-0xffffffff] has been reserved
system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:09: [io  0x0060]
pnp 00:09: [io  0x0064]
pnp 00:09: [irq 1]
pnp 00:09: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
pnp 00:0a: [io  0x03f8-0x03ff]
pnp 00:0a: [irq 4]
pnp 00:0a: [dma 0 disabled]
pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
pnp 00:0b: [io  0x0290-0x029f]
system 00:0b: [io  0x0290-0x029f] has been reserved
system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0c: [mem 0x00000000-0x0009ffff]
pnp 00:0c: [mem 0x000c0000-0x000cffff]
pnp 00:0c: [mem 0x000e0000-0x000fffff]
pnp 00:0c: [mem 0x00100000-0x9effffff]
pnp 00:0c: [mem 0x00000000-0xffffffffffffffff disabled]
pnp 00:0c: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:04.0 BAR 0 [mem 0x00000000-0x0fffffff pref]
pnp 00:0c: disabling [mem 0x000c0000-0x000cffff] because it overlaps 0000:00:04.0 BAR 0 [mem 0x00000000-0x0fffffff pref]
pnp 00:0c: disabling [mem 0x000e0000-0x000fffff] because it overlaps 0000:00:04.0 BAR 0 [mem 0x00000000-0x0fffffff pref]
pnp 00:0c: disabling [mem 0x00100000-0x9effffff] because it overlaps 0000:00:04.0 BAR 0 [mem 0x00000000-0x0fffffff pref]
system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x8000-0xafff]
pci 0000:00:01.0:   bridge window [mem 0xff000000-0xff0fffff]
pci 0000:00:01.0:   bridge window [mem 0x9fe00000-0xbfdfffff pref]
pci 0000:00:02.0: PCI bridge to [bus 02-02]
pci 0000:00:02.0:   bridge window [mem 0xff100000-0xff1fffff]
pci 0000:03:00.0: BAR 5: assigned [mem 0xff200000-0xff201fff]
pci 0000:00:03.0: PCI bridge to [bus 03-03]
pci 0000:00:03.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:03.0:   bridge window [mem 0xff200000-0xff2fffff]
pci 0000:00:05.0: PCI bridge to [bus 04-04]
pci 0000:00:05.0:   bridge window [mem 0xff300000-0xff3fffff]
pci 0000:05:06.0: PCI bridge to [bus 06-06]
pci 0000:05:06.0:   bridge window [io  0xc000-0xcfff]
pci 0000:05:06.0:   bridge window [mem 0xff400000-0xff4fffff]
pci 0000:00:06.0: PCI bridge to [bus 05-06]
pci 0000:00:06.0:   bridge window [io  0xc000-0xdfff]
pci 0000:00:06.0:   bridge window [mem 0xff400000-0xff5fffff]
pci 0000:00:06.0:   bridge window [mem 0xbfe00000-0xbfefffff pref]
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:06.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
pci_bus 0000:00: resource 5 [mem 0x9f000000-0xfcffffffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:01: resource 0 [io  0x8000-0xafff]
pci_bus 0000:01: resource 1 [mem 0xff000000-0xff0fffff]
pci_bus 0000:01: resource 2 [mem 0x9fe00000-0xbfdfffff pref]
pci_bus 0000:02: resource 1 [mem 0xff100000-0xff1fffff]
pci_bus 0000:03: resource 0 [io  0xb000-0xbfff]
pci_bus 0000:03: resource 1 [mem 0xff200000-0xff2fffff]
pci_bus 0000:04: resource 1 [mem 0xff300000-0xff3fffff]
pci_bus 0000:05: resource 0 [io  0xc000-0xdfff]
pci_bus 0000:05: resource 1 [mem 0xff400000-0xff5fffff]
pci_bus 0000:05: resource 2 [mem 0xbfe00000-0xbfefffff pref]
pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
pci_bus 0000:05: resource 5 [mem 0x9f000000-0xfcffffffff]
pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:06: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:06: resource 1 [mem 0xff400000-0xff4fffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP: reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:01.0: Enabling HT MSI Mapping
pci 0000:00:02.0: Enabling HT MSI Mapping
pci 0000:00:03.0: Enabling HT MSI Mapping
Switching to clocksource acpi_pm
pci 0000:01:00.0: Boot video device
pci 0000:06:04.0: Firmware left e100 interrupts enabled; disabling
pci 0000:06:05.0: Firmware left e100 interrupts enabled; disabling
PCI: CLS 64 bytes, default 64
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 4987
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
start plist test
end plist test
pcieport 0000:00:01.0: irq 56 for MSI/MSI-X
pcieport 0000:00:02.0: irq 57 for MSI/MSI-X
pcieport 0000:00:03.0: irq 58 for MSI/MSI-X
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Non-volatile memory driver v1.3
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
ahci 0000:03:00.0: version 3.0
ahci 0000:03:00.0: AHCI 0001.0000 32 slots 1 ports 3 Gbps 0x1 impl SATA mode
ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
scsi0 : ahci
ata1: SATA max UDMA/133 abar m8192@0xff200000 port 0xff200100 irq 35
PPP generic driver version 2.4.2
i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:02: RTC can wake from S4
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 114 bytes nvram
cpuidle: using governor ladder
cpuidle: using governor menu
TCP: cubic registered
NET: Registered protocol family 10
NET: Registered protocol family 17
Registering the dns_resolver key type
registered taskstats version 1
rtc_cmos 00:02: setting system clock to 2012-04-12 15:37:18 UTC (1334245038)
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: WDC WD7500AAKS-00RBA0, 30.04G30, max UDMA/133
ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD7500AAKS-0 30.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
EXT4-fs (sda1): couldn't mount as ext3 due to feature incompatibilities
EXT4-fs (sda1): couldn't mount as ext2 due to feature incompatibilities
EXT4-fs (sda1): INFO: recovery required on readonly filesystem
EXT4-fs (sda1): write access will be enabled during recovery
Refined TSC clocksource calibration: 2200.081 MHz.
Switching to clocksource tsc
EXT4-fs (sda1): orphan cleanup on readonly fs
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 922401
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 280767
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 262214
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 285084
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 285105
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 285091
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 285096
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 276141
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 263192
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 285081
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 285078
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 285077
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 558852
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 285074
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 262200
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 285102
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 285098
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 281781
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 788827
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 809507
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 809505
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 820672
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 820576
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 919067
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 790424
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 794630
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 793823
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 922402
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 528027
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 820515
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 394027
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 528670
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 1185453
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 800185
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 790730
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 790729
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 790728
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 921539
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 919123
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 926537
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 926535
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 926052
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 532972
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 264585
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 820716
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 791815
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 535282
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 810833
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 810818
EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 810888
EXT4-fs (sda1): 50 orphan inodes deleted
EXT4-fs (sda1): recovery complete
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
Freeing unused kernel memory: 396k freed
Write protecting the kernel read-only data: 6144k
Freeing unused kernel memory: 1124k freed
Freeing unused kernel memory: 472k freed
Linux agpgart interface v0.103
agpgart-amd64 0000:00:04.0: AGP bridge [10b9/1689]
agpgart-amd64 0000:00:04.0: aperture size 4096 MB is not right, using settings from NB
agpgart-amd64 0000:00:04.0: setting up ULi AGP
agpgart-amd64 0000:00:04.0: AGP aperture is 256M @ 0xd0000000
input: PC Speaker as /devices/platform/pcspkr/input/input3
ali1535_smbus 0000:00:07.1: enabling device (0000 -> 0001)
ali1535_smbus 0000:00:07.1: ALI1535_smb region uninitialized - upgrade BIOS?
ali1535_smbus 0000:00:07.1: ALI1535 not detected, module not inserted.
ACPI Warning: 0x0000000000000400-0x000000000000040f SystemIO conflicts with Region \SMIO 1 (20120320/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
ali1563_smbus 0000:00:07.0: ALi1563 SMBus probe failed (-19)
ali15x3_smbus 0000:00:07.1: ALI15X3_smb region uninitialized - upgrade BIOS or use force_addr=0xaddr
ali15x3_smbus 0000:00:07.1: ALI15X3 not detected, module not inserted.
microcode: CPU0: family 15 not supported
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3500+ (1 cpu cores) (version 2.20.00)
powernow-k8: fid 0xe (2200 MHz), vid 0x6
powernow-k8: fid 0xc (2000 MHz), vid 0x8
powernow-k8: fid 0xa (1800 MHz), vid 0xa
powernow-k8: fid 0x2 (1000 MHz), vid 0x12
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
e100 0000:06:04.0: eth0: addr 0xff4ff000, irq 21, MAC addr 00:02:b3:bc:9f:dd
e100 0000:06:05.0: eth1: addr 0xff4fe000, irq 22, MAC addr 00:02:b3:bc:9f:de
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Linux media interface: v0.10
parport_pc 00:06: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[drm] Initialized drm 1.1.0 20060810
udevd[548]: renamed network interface eth0 to rename2
udevd[546]: renamed network interface eth1 to eth0
scsi1 : pata_ali
scsi2 : pata_ali
ata2: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
ata3: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:13.3: EHCI Host Controller
ehci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:13.3: debug port 1
Linux video capture interface: v2.00
udevd[548]: renamed network interface rename2 to eth1
ehci_hcd 0000:00:13.3: irq 23, io mem 0xff6fcc00
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ehci_hcd 0000:00:13.3: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.4.0-rc2 ehci_hcd
usb usb1: SerialNumber: 0000:00:13.3
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.0: irq 20, io mem 0xff6ff000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 3.4.0-rc2 ohci_hcd
usb usb2: SerialNumber: 0000:00:13.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
sata_uli 0000:00:12.1: version 1.3
scsi3 : sata_uli
scsi4 : sata_uli
ata4: SATA max UDMA/133 cmd 0xec00 ctl 0xe880 bmdma 0xe400 irq 19
ata5: SATA max UDMA/133 cmd 0xe800 ctl 0xe480 bmdma 0xe408 irq 19
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 21, io mem 0xff6fe000
ata2.00: ATAPI: _NEC DVD_RW ND-4571A, 1-01, max UDMA/33
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 3.4.0-rc2 ohci_hcd
usb usb3: SerialNumber: 0000:00:13.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.2: irq 22, io mem 0xff6fd000
ata2.00: configured for UDMA/33
scsi 1:0:0:0: CD-ROM            _NEC     DVD_RW ND-4571A  1-01 PQ: 0 ANSI: 5
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 3.4.0-rc2 ohci_hcd
usb usb4: SerialNumber: 0000:00:13.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 3 ports detected
Marking TSC unstable due to cpufreq changes
Switching to clocksource acpi_pm
usb 3-1: new low-speed USB device number 2 using ohci_hcd
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
usb 3-1: New USB device found, idVendor=0592, idProduct=0002
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: Powerware UPS
usb 3-1: Manufacturer: Powerware
bttv: driver version 0.9.19 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0)
bttv: 0: Bt878 (rev 2) at 0000:05:07.0, irq: 22, latency: 64, mmio: 0xbfeff000
bttv: 0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv: 0: using: Hauppauge (bt878) [card=10,autodetected]
bttv: 0: Hauppauge/Voodoo msp34xx: reset line init [5]
[drm] radeon kernel modesetting enabled.
[drm] initializing kernel modesetting (RV710 0x1002:0x954F 0x1787:0x2271).
[drm] register mmio base: 0xFF0F0000
[drm] register mmio size: 65536
ATOM BIOS: 113
radeon 0000:01:00.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
radeon 0000:01:00.0: GTT: 512M 0x0000000020000000 - 0x000000003FFFFFFF
[drm] Detected VRAM RAM=512M, BAR=256M
[drm] RAM width 64bits DDR
[TTM] Zone  kernel: Available graphics memory: 1277822 kiB
[TTM] Initializing pool allocator
[TTM] Initializing DMA pool allocator
[drm] radeon: 512M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
radeon 0000:01:00.0: irq 59 for MSI/MSI-X
radeon 0000:01:00.0: radeon: using MSI.
[drm] radeon: irq initialized.
[drm] GART: num cpu pages 131072, num gpu pages 131072
tveeprom 0-0050: Hauppauge model 37284, rev B121, serial# 3520921
tveeprom 0-0050: tuner model is Philips FM1216 (idx 21, type 5)
tveeprom 0-0050: TV standards PAL(B/G) (eeprom 0x04)
tveeprom 0-0050: audio processor is MSP3410D (idx 5)
tveeprom 0-0050: has radio
bttv: 0: Hauppauge eeprom indicates model#37284
bttv: 0: tuner type=5
[drm] radeon: ib pool ready.
[drm] Loading RV710 Microcode
i2c-core: driver [msp3400] using legacy suspend method
i2c-core: driver [msp3400] using legacy resume method
msp3400 0-0040: MSP3410D-B4 found @ 0x80 (bt878 #0 [sw])
msp3400 0-0040: msp3400 supports nicam, mode is autodetect
usb 2-1: new full-speed USB device number 2 using ohci_hcd
i2c-core: driver [tuner] using legacy suspend method
i2c-core: driver [tuner] using legacy resume method
usb 2-1: New USB device found, idVendor=03f0, idProduct=7404
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1: Product: Deskjet 3740
usb 2-1: Manufacturer: HP
usb 2-1: SerialNumber: CN4CJ150T3040Q
tda9887 0-0042: creating new instance
tda9887 0-0042: tda988[5/6/7] found
tuner 0-0042: Tuner 74 found with type(s) Radio TV.
tuner 0-0061: Tuner -1 found with type(s) Radio TV.
tuner-simple 0-0061: creating new instance
tuner-simple 0-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
bttv: 0: registered device video0
bttv: 0: registered device vbi0
bttv: 0: registered device radio0
bttv: 0: Setting PLL: 28636363 => 35468950 (needs up to 100ms)
bttv: PLL set ok
bt87x0: Using board 1, analog, digital (rate 32000 Hz)
snd_emu10k1 0000:05:05.0: enabling device (0000 -> 0001)
[drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
radeon 0000:01:00.0: WB enabled
[drm] fence driver on ring 0 use gpu addr 0x20000c00 and cpu addr 0xffff88009afc4c00
usb 2-2: new low-speed USB device number 3 using ohci_hcd
[drm] ring test on 0 succeeded in 1 usecs
[drm] ib test on ring 0 succeeded in 0 usecs
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA
[drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[drm]   Encoders:
[drm]     CRT2: INTERNAL_KLDSCP_DAC2
[drm] Connector 1:
[drm]   HDMI-A
[drm]   HPD1
[drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[drm]   Encoders:
[drm]     DFP1: INTERNAL_UNIPHY
[drm] Connector 2:
[drm]   DVI-I
[drm]   HPD4
[drm]   DDC: 0x7f10 0x7f10 0x7f14 0x7f14 0x7f18 0x7f18 0x7f1c 0x7f1c
[drm]   Encoders:
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
[drm]     DFP2: INTERNAL_UNIPHY2
[drm] Internal thermal controller with fan control
[drm] radeon: power management initialized
usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x03F0 pid 0x7404
usbcore: registered new interface driver usblp
[drm] fb mappable at 0xA0142000
[drm] vram apper at 0xA0000000
[drm] size 7680000
[drm] fb depth is 24
[drm]    pitch is 6400
fbcon: radeondrmfb (fb0) is primary device
usb 2-2: New USB device found, idVendor=046d, idProduct=c00c
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: USB Mouse
usb 2-2: Manufacturer: Logitech
input: Logitech USB Mouse as /devices/pci0000:00/0000:00:13.0/usb2/2-2/2-2:1.0/input/input4
generic-usb 0003:046D:C00C.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB Mouse] on usb-0000:00:13.0-2/input0
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
Console: switching to colour frame buffer device 200x75
fb0: radeondrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized radeon 2.15.0 20080528 for 0000:01:00.0 on minor 0
hda-intel: Using LPIB position fix
snd_hda_intel 0000:01:00.1: irq 60 for MSI/MSI-X
hda-intel: Enable sync_write for stable communication
HDMI status: Codec=0 Pin=3 Presence_Detect=0 ELD_Valid=0
input: HDA ATI HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card2/input5
Adding 4891788k swap on /dev/sda2.  Priority:-1 extents:1 across:4891788k 
EXT4-fs (sda1): re-mounted. Opts: (null)
EXT4-fs (sda1): re-mounted. Opts: (null)
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
w83627hf: w83627hf: Found W83627HF chip at 0x290
ACPI Warning: 0x0000000000000295-0x0000000000000296 SystemIO conflicts with Region \SMIO 1 (20120320/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
8021q: 802.1Q VLAN Support v1.8
EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
ADDRCONF(NETDEV_UP): eth0: link is not ready
e100 0000:06:05.0: eth0: NIC Link is Up 100 Mbps Full Duplex
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ADDRCONF(NETDEV_UP): eth1: link is not ready
e100 0000:06:04.0: eth1: NIC Link is Up 100 Mbps Full Duplex
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
IPv6 over IPv4 tunneling driver
fuse init (API version 7.18)
input: ACPI Virtual Keyboard Device as /devices/virtual/input/input6
Netfilter messages via NETLINK v0.30.
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
JFS: nTxBlock = 8192, nTxLock = 65536
NTFS driver 2.1.30 [Flags: R/W MODULE].

-- 
Meelis Roos (mroos@linux.ee)
