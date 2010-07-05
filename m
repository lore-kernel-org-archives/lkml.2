Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab0GEIaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:30:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64474 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab0GEIaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:30:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:subject:to:cc:message-id:user-agent;
        b=SR+Jq/KoW3h8tqB9eq+HaYJynIWJ5t5pQ0dkhM4XmrGeHa/ulZ8d6Jzyf0wS0l05Rp
         GEwpptumPzSUlJMpHSoLkEHl4OmrgVni0EjGeKEVzKa3EBc53ep+tUxSq61WYS8hSQPO
         e8o8K4NQcbFl/tr4d9+2hS+rQVJctqYvxgijs=
Date: Mon, 05 Jul 2010 07:51:28 +0000
From: Ali Gholami Rudi <ali@rudi.ir>
Subject: [regression] commit 6a4f3b52 causes invalid memtype
To: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venki@google.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Xiaotian Feng <dfeng@redhat.com>
Message-ID: <20100507075128@tarekhel>
User-Agent: git://repo.or.cz/mailx.git
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In -rc4 kernel these messages appear in my dmesg (complete dmesg
at the end of this mail):

	[    0.400777] swapper:1 freeing invalid memtype e0000000-e0040000
	...
	[    0.453489] swapper:1 freeing invalid memtype e0000000-e0010000
	[    0.453585] swapper:1 freeing invalid memtype e0041000-e0045000
	[    0.453673] swapper:1 freeing invalid memtype e0045000-e0049000
	...
	[   12.662571] fbpad:980 conflicting memory types e0049000-e0549000 uncached-minus<->write-combining
	[   12.662579] reserve_memtype failed 0xe0049000-0xe0549000, track uncached-minus, req uncached-minus
	[   13.303389] fbpad:980 map pfn expected mapping type uncached-minus for e0049000-e0549000, got write-combining

The last 3 lines appear when mmap()ing nouveau framebuffer.

I reverted this commit and everything seems ok once more:

	commit 6a4f3b523779b67e7d560ed42652f8a59f2f9782
	Author: Venkatesh Pallipadi <venki@google.com>
	Date:   Thu Jun 10 17:45:01 2010 -0700
	
	    x86, pat: Proper init of memtype subtree_max_end

Thanks,
Ali

[    0.000000] Linux version 2.6.35-rc4 (root@tarekhel) (gcc version 4.4.1 (GCC) ) #94 SMP Mon Jul 5 11:51:34 IRDT 2010
[    0.000000] Command line: auto BOOT_IMAGE=tarekhel ro root=802 rootflags=data=writeback
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
[    0.000000]  BIOS-e820: 000000007ff90000 - 000000007ff9e000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ff9e000 - 000000007ffd0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ffd0000 - 000000007ffde000 (reserved)
[    0.000000]  BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7ff90 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-000000007ff90000
[    0.000000]  0000000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007ff90000 page 4k
[    0.000000] kernel direct mapping tables up to 7ff90000 @ 16000-1a000
[    0.000000] ACPI: RSDP 00000000000fb7e0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 000000007ff90000 00034 (v01 120508 RSDT1037 20081205 MSFT 00000097)
[    0.000000] ACPI: FACP 000000007ff90200 00084 (v02 120508 FACP1037 20081205 MSFT 00000097)
[    0.000000] ACPI: DSDT 000000007ff905c0 066E7 (v01  A1016 A1016000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 000000007ff9e000 00040
[    0.000000] ACPI: APIC 000000007ff90390 0006C (v01 120508 APIC1037 20081205 MSFT 00000097)
[    0.000000] ACPI: MCFG 000000007ff90400 0003C (v01 120508 OEMMCFG  20081205 MSFT 00000097)
[    0.000000] ACPI: OEMB 000000007ff9e040 00061 (v01 120508 OEMB1037 20081205 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880002400000-ffff880003ffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007ff90
[    0.000000] On node 0 totalpages: 524063
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7111 pages used for memmap
[    0.000000]   DMA32 zone: 512969 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [18000 - 187ff]
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:7ee00000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880001c00000 s76992 r8192 d21312 u524288
[    0.000000] pcpu-alloc: s76992 r8192 d21312 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 516896
[    0.000000] Kernel command line: auto BOOT_IMAGE=tarekhel ro root=802 rootflags=data=writeback
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (47 early reservations)
[    0.000000]   #1 [0001000000 - 0001bc39ac]   TEXT DATA BSS
[    0.000000]   #2 [0001bc4000 - 0001bc4298]             BRK
[    0.000000]   #3 [00000ff790 - 0000100000]   BIOS reserved
[    0.000000]   #4 [00000ff780 - 00000ff790]    MP-table mpf
[    0.000000]   #5 [000009fc00 - 00000f16d0]   BIOS reserved
[    0.000000]   #6 [00000f1814 - 00000ff780]   BIOS reserved
[    0.000000]   #7 [00000f16d0 - 00000f1814]    MP-table mpc
[    0.000000]   #8 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #9 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #10 [0000016000 - 0000018000]         PGTABLE
[    0.000000]   #11 [0001bc42c0 - 0001bc52c0]         BOOTMEM
[    0.000000]   #12 [0001bc39c0 - 0001bc3b40]         BOOTMEM
[    0.000000]   #13 [00023c6000 - 00023c7000]         BOOTMEM
[    0.000000]   #14 [00023c7000 - 00023c8000]         BOOTMEM
[    0.000000]   #15 [0002400000 - 0004000000]        MEMMAP 0
[    0.000000]   #16 [0001bc3b40 - 0001bc3cc0]         BOOTMEM
[    0.000000]   #17 [0001bc52c0 - 0001bd12c0]         BOOTMEM
[    0.000000]   #18 [0001bd2000 - 0001bd3000]         BOOTMEM
[    0.000000]   #19 [0001bc3cc0 - 0001bc3d03]         BOOTMEM
[    0.000000]   #20 [0001bc3d40 - 0001bc3fa8]         BOOTMEM
[    0.000000]   #21 [0001bd12c0 - 0001bd1328]         BOOTMEM
[    0.000000]   #22 [0001bd1340 - 0001bd13a8]         BOOTMEM
[    0.000000]   #23 [0001bd13c0 - 0001bd1428]         BOOTMEM
[    0.000000]   #24 [0001bd1440 - 0001bd14a8]         BOOTMEM
[    0.000000]   #25 [0001bd14c0 - 0001bd1528]         BOOTMEM
[    0.000000]   #26 [0001bd1540 - 0001bd15a8]         BOOTMEM
[    0.000000]   #27 [0001bd15c0 - 0001bd1628]         BOOTMEM
[    0.000000]   #28 [0001bd1640 - 0001bd16a8]         BOOTMEM
[    0.000000]   #29 [0001bd16c0 - 0001bd1728]         BOOTMEM
[    0.000000]   #30 [0001bd1740 - 0001bd17a8]         BOOTMEM
[    0.000000]   #31 [0001bc3fc0 - 0001bc3ffe]         BOOTMEM
[    0.000000]   #32 [0001bd17c0 - 0001bd17fe]         BOOTMEM
[    0.000000]   #33 [0001c00000 - 0001c1a000]         BOOTMEM
[    0.000000]   #34 [0001c80000 - 0001c9a000]         BOOTMEM
[    0.000000]   #35 [0001d00000 - 0001d1a000]         BOOTMEM
[    0.000000]   #36 [0001d80000 - 0001d9a000]         BOOTMEM
[    0.000000]   #37 [0001bd1800 - 0001bd1808]         BOOTMEM
[    0.000000]   #38 [0001bd1840 - 0001bd1848]         BOOTMEM
[    0.000000]   #39 [0001bd1880 - 0001bd1890]         BOOTMEM
[    0.000000]   #40 [0001bd18c0 - 0001bd18e0]         BOOTMEM
[    0.000000]   #41 [0001bd1900 - 0001bd1a30]         BOOTMEM
[    0.000000]   #42 [0001bd1a40 - 0001bd1a90]         BOOTMEM
[    0.000000]   #43 [0001bd1ac0 - 0001bd1b10]         BOOTMEM
[    0.000000]   #44 [0001bd3000 - 0001bdb000]         BOOTMEM
[    0.000000]   #45 [0001d9a000 - 0001f9a000]         BOOTMEM
[    0.000000]   #46 [0001f9a000 - 000209a000]         BOOTMEM
[    0.000000] Memory: 2051912k/2096704k available (5201k kernel code, 452k absent, 44340k reserved, 5867k data, 460k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:384
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2666.836 MHz processor.
[    0.001009] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.67 BogoMIPS (lpj=2666836)
[    0.002002] pid_max: default: 32768 minimum: 301
[    0.002105] Mount-cache hash table entries: 256
[    0.002314] CPU: Physical Processor ID: 0
[    0.002394] CPU: Processor Core ID: 0
[    0.002473] using mwait in idle threads.
[    0.002552] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.002718] ... version:                2
[    0.002797] ... bit width:              40
[    0.002876] ... generic registers:      2
[    0.002955] ... value mask:             000000ffffffffff
[    0.003002] ... max period:             000000007fffffff
[    0.003082] ... fixed-purpose events:   3
[    0.003161] ... event mask:             0000000700000003
[    0.003282] ACPI: Core revision 20100428
[    0.009050] Setting APIC routing to flat
[    0.009430] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.019578] CPU0: Intel(R) Core(TM)2 Duo CPU     E7300  @ 2.66GHz stepping 06
[    0.019999] Booting Node   0, Processors  #1
[    0.091015] Brought up 2 CPUs
[    0.091174] Total of 2 processors activated (10577.41 BogoMIPS).
[    0.091809] devtmpfs: initialized
[    0.092035] khelper used greatest stack depth: 6736 bytes left
[    0.092294] Time: 11:55:35  Date: 07/05/10
[    0.092359] NET: Registered protocol family 16
[    0.092732] ACPI: bus type pci registered
[    0.092897] dca service started, version 1.12.1
[    0.093009] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.093009] PCI: not using MMCONFIG
[    0.093081] PCI: Using configuration type 1 for base access
[    0.093353] khelper used greatest stack depth: 6168 bytes left
[    0.097684] bio: create slab <bio-0> at 0
[    0.098556] ACPI: EC: Look up EC in DSDT
[    0.099623] ACPI: Executed 1 blocks of module-level executable AML code
[    0.104109] ACPI: SSDT 000000007ff9e0b0 00214 (v01    AMI   CPU1PM 00000001 INTL 20060113)
[    0.104513] ACPI: Dynamic OEM Table Load:
[    0.104646] ACPI: SSDT (null) 00214 (v01    AMI   CPU1PM 00000001 INTL 20060113)
[    0.105092] ACPI: SSDT 000000007ff9e2d0 00143 (v01    AMI   CPU2PM 00000001 INTL 20060113)
[    0.105488] ACPI: Dynamic OEM Table Load:
[    0.105621] ACPI: SSDT (null) 00143 (v01    AMI   CPU2PM 00000001 INTL 20060113)
[    0.105868] ACPI: Interpreter enabled
[    0.105950] ACPI: (supports S0 S1 S3 S5)
[    0.106135] ACPI: Using IOAPIC for interrupt routing
[    0.106256] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.107923] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in ACPI motherboard resources
[    0.121578] ACPI: No dock devices found.
[    0.121660] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.122027] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.122299] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.122383] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.122466] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.122598] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.122729] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xffffffff]
[    0.124001] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.124004] pci 0000:00:01.0: PME# disabled
[    0.124046] pci 0000:00:1b.0: reg 10: [mem 0xfbffc000-0xfbffffff 64bit]
[    0.124080] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.124083] pci 0000:00:1b.0: PME# disabled
[    0.124115] pci 0000:00:1d.0: reg 20: [io  0xd480-0xd49f]
[    0.124153] pci 0000:00:1d.1: reg 20: [io  0xd800-0xd81f]
[    0.124191] pci 0000:00:1d.2: reg 20: [io  0xd880-0xd89f]
[    0.124228] pci 0000:00:1d.3: reg 20: [io  0xdc00-0xdc1f]
[    0.124265] pci 0000:00:1d.7: reg 10: [mem 0xfbffbc00-0xfbffbfff]
[    0.124307] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.124310] pci 0000:00:1d.7: PME# disabled
[    0.124407] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.124412] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.124547] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
[    0.124633] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
[    0.124798] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.124803] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.124808] pci 0000:00:1f.1: reg 18: [io  0x08f0-0x08f7]
[    0.124813] pci 0000:00:1f.1: reg 1c: [io  0x08f8-0x08fb]
[    0.124818] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
[    0.124848] pci 0000:00:1f.2: reg 10: [io  0xd400-0xd407]
[    0.124852] pci 0000:00:1f.2: reg 14: [io  0xd080-0xd083]
[    0.124856] pci 0000:00:1f.2: reg 18: [io  0xd000-0xd007]
[    0.124861] pci 0000:00:1f.2: reg 1c: [io  0xcc00-0xcc03]
[    0.124865] pci 0000:00:1f.2: reg 20: [io  0xc880-0xc88f]
[    0.124884] pci 0000:00:1f.2: PME# supported from D3hot
[    0.124886] pci 0000:00:1f.2: PME# disabled
[    0.124922] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.124974] pci 0000:01:00.0: reg 10: [mem 0xfd000000-0xfdffffff]
[    0.124981] pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.124988] pci 0000:01:00.0: reg 1c: [mem 0xfc000000-0xfcffffff 64bit]
[    0.124994] pci 0000:01:00.0: reg 30: [mem 0xfeae0000-0xfeafffff pref]
[    0.125020] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.125102] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.125105] pci 0000:00:01.0:   bridge window [mem 0xfc000000-0xfeafffff]
[    0.125108] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.125143] pci 0000:02:00.0: reg 10: [io  0xec00-0xec7f]
[    0.125148] pci 0000:02:00.0: reg 14: [mem 0xfebffc00-0xfebffc7f]
[    0.125169] pci 0000:02:00.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.125185] pci 0000:02:00.0: supports D1 D2
[    0.125186] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.125190] pci 0000:02:00.0: PME# disabled
[    0.125217] pci 0000:02:05.0: reg 10: [io  0xe800-0xe8ff]
[    0.125223] pci 0000:02:05.0: reg 14: [mem 0xfebff800-0xfebff8ff]
[    0.125243] pci 0000:02:05.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    0.125259] pci 0000:02:05.0: supports D1 D2
[    0.125260] pci 0000:02:05.0: PME# supported from D1 D2 D3hot D3cold
[    0.125264] pci 0000:02:05.0: PME# disabled
[    0.125297] pci 0000:00:1e.0: PCI bridge to [bus 02-02] (subtractive decode)
[    0.125382] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    0.125385] pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.125390] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.125392] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.125394] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.125395] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.125397] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.125399] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xffffffff] (subtractive decode)
[    0.125407] pci_bus 0000:00: on NUMA node 0
[    0.125410] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.125490] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.131661] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.132087] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.132666] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.133180] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.133655] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.134080] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.134657] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.135283] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.135910] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.135948] vgaarb: loaded
[    0.136239] SCSI subsystem initialized
[    0.136356] libata version 3.00 loaded.
[    0.136412] usbcore: registered new interface driver usbfs
[    0.136517] usbcore: registered new interface driver hub
[    0.136625] usbcore: registered new device driver usb
[    0.136843] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.136947] PCI: Using ACPI for IRQ routing
[    0.137002] PCI: pci_cache_line_size set to 64 bytes
[    0.137050] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.137052] reserve RAM buffer: 000000007ff90000 - 000000007fffffff 
[    0.137269] hpet clockevent registered
[    0.137273] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.137359] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.137545] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.140118] Switching to clocksource tsc
[    0.140222] pnp: PnP ACPI init
[    0.140305] ACPI: bus type pnp registered
[    0.143567] pnp: PnP ACPI: found 17 devices
[    0.143649] ACPI: ACPI bus type pnp unregistered
[    0.143738] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
[    0.143835] system 00:08: [io  0x0290-0x0297] has been reserved
[    0.143923] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.144008] system 00:09: [io  0x0800-0x087f] has been reserved
[    0.144091] system 00:09: [io  0x0480-0x04bf] has been reserved
[    0.144176] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.144261] system 00:09: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.144347] system 00:0b: [mem 0xffc00000-0xffefffff] has been reserved
[    0.144434] system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.144519] system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.144606] system 00:0f: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.144691] system 00:10: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.144777] system 00:10: [mem 0x000c0000-0x000cffff] has been reserved
[    0.144873] system 00:10: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.144958] system 00:10: [mem 0x00100000-0x7fffffff] could not be reserved
[    0.149899] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.149983] pci 0000:00:01.0:   bridge window [io  disabled]
[    0.150068] pci 0000:00:01.0:   bridge window [mem 0xfc000000-0xfeafffff]
[    0.150152] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.150286] pci 0000:00:1e.0: PCI bridge to [bus 02-02]
[    0.150368] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    0.150453] pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.150538] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.150630] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.150714] pci 0000:00:01.0: setting latency timer to 64
[    0.150719] pci 0000:00:1e.0: setting latency timer to 64
[    0.150722] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.150723] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.150725] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.150727] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.150728] pci_bus 0000:00: resource 8 [mem 0x80000000-0xffffffff]
[    0.150730] pci_bus 0000:01: resource 1 [mem 0xfc000000-0xfeafffff]
[    0.150732] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
[    0.150733] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.150735] pci_bus 0000:02: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.150737] pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
[    0.150738] pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
[    0.150740] pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
[    0.150741] pci_bus 0000:02: resource 7 [mem 0x000d0000-0x000dffff]
[    0.150743] pci_bus 0000:02: resource 8 [mem 0x80000000-0xffffffff]
[    0.150762] NET: Registered protocol family 2
[    0.150896] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.151214] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.153374] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.154058] TCP: Hash tables configured (established 262144 bind 65536)
[    0.154143] TCP reno registered
[    0.154224] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.154326] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.154566] NET: Registered protocol family 1
[    0.154675] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.154677] pci 0000:00:1d.0: Performing full reset
[    0.154692] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.154694] pci 0000:00:1d.1: Performing full reset
[    0.154708] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.154710] pci 0000:00:1d.2: Performing full reset
[    0.154725] pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x0030
[    0.154727] pci 0000:00:1d.3: Performing full reset
[    0.154783] pci 0000:01:00.0: Boot video device
[    0.154806] PCI: CLS 32 bytes, default 64
[    0.155841] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.158309] msgmni has been set to 4007
[    0.158677] alg: No test for stdrng (krng)
[    0.158843] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.158978] io scheduler noop registered
[    0.159060] io scheduler deadline registered
[    0.159185] io scheduler cfq registered (default)
[    0.159335] pcieport 0000:00:01.0: setting latency timer to 64
[    0.159360] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.159759] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.159910] ACPI: Power Button [PWRB]
[    0.160040] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.160173] ACPI: Power Button [PWRF]
[    0.160311] ACPI: acpi_idle registered with cpuidle
[    0.164599] Non-volatile memory driver v1.3
[    0.164748] intel_rng: FWH not detected
[    0.164861] Linux agpgart interface v0.103
[    0.165076] [drm] Initialized drm 1.1.0 20060810
[    0.165199] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.165285] nouveau 0000:01:00.0: setting latency timer to 64
[    0.169178] [drm] nouveau 0000:01:00.0: Detected an NV40 generation card (0x044a00b2)
[    0.171315] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PROM
[    0.368990] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    0.369074] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    0.369157] [drm] nouveau 0000:01:00.0: Bios version 05.44.02.67
[    0.369241] [drm] nouveau 0000:01:00.0: BIT table 'd' not found
[    0.369325] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 3.0
[    0.369462] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 01010300 00000028
[    0.369548] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 01010302 00000020
[    0.369632] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02001310 00000028
[    0.369717] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 020223f1 00a0c030
[    0.369807] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x30 5 7 2
[    0.369893] [drm] nouveau 0000:01:00.0:   0: 0x00001030: type 0x30 idx 0 tag 0x07
[    0.370027] [drm] nouveau 0000:01:00.0:   1: 0x00000100: type 0x00 idx 1 tag 0xff
[    0.370161] [drm] nouveau 0000:01:00.0:   2: 0x00000210: type 0x10 idx 2 tag 0xff
[    0.370294] [drm] nouveau 0000:01:00.0:   3: 0x00000211: type 0x11 idx 3 tag 0xff
[    0.370438] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xDCEA
[    0.370662] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xE04F
[    0.390954] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xE589
[    0.391099] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xE6DE
[    0.392868] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xE888
[    0.393002] [drm] nouveau 0000:01:00.0: Detected 128MiB VRAM
[    0.400542] [TTM] Zone  kernel: Available graphics memory: 1025956 kiB.
[    0.400625] [TTM] Initializing pool allocator.
[    0.400777] swapper:1 freeing invalid memtype e0000000-e0040000
[    0.401870] [drm] nouveau 0000:01:00.0: 64 MiB GART (aperture)
[    0.402971] [drm] nouveau 0000:01:00.0: Allocating FIFO number 0
[    0.403632] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 0
[    0.403782] [drm] nouveau 0000:01:00.0: Initial CRTC_OWNER is 0
[    0.403869] [drm] nouveau 0000:01:00.0: Saving VGA fonts
[    0.453489] swapper:1 freeing invalid memtype e0000000-e0010000
[    0.453585] swapper:1 freeing invalid memtype e0041000-e0045000
[    0.453673] swapper:1 freeing invalid memtype e0045000-e0049000
[    0.453757] [drm] nouveau 0000:01:00.0: Detected a DVI-I connector
[    0.453943] [drm] nouveau 0000:01:00.0: Detected a VGA connector
[    0.454069] [drm] nouveau 0000:01:00.0: Detected a TV connector
[    0.455778] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on vga encoder (output 0)
[    0.455904] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on tmds encoder (output 1)
[    0.456024] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on vga encoder (output 2)
[    0.456144] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on TV encoder (output 3)
[    0.614447] [drm] nouveau 0000:01:00.0: allocated 1280x1024 fb: 0x49000, bo ffff88007fa41400
[    0.625681] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga encoder (output 2)
[    0.625684] [drm] nouveau 0000:01:00.0: Output VGA-1 is running on CRTC 0 using output B
[    0.630396] Console: switching to colour frame buffer device 160x64
[    0.633490] fb0: nouveaufb frame buffer device
[    0.633494] drm: registered panic notifier
[    0.633499] Slow work thread pool: Starting up
[    0.633528] Slow work thread pool: Ready
[    0.633535] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[    0.633575] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.877917] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.878346] 00:0e: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.879711] brd: module loaded
[    0.880342] loop: module loaded
[    0.880372] Uniform Multi-Platform E-IDE driver
[    0.880441] piix 0000:00:1f.1: IDE controller (0x8086:0x27df rev 0x01)
[    0.880462] pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.880484] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
[    0.880494]     ide0: BM-DMA at 0xffa0-0xffa7
[    0.880505]     ide1: BM-DMA at 0xffa8-0xffaf
[    0.880512] Probing IDE interface ide0...
[    1.399177] Probing IDE interface ide1...
[    1.918188] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    1.918209] ide1 at 0x170-0x177,0x376 on irq 15
[    1.918328] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    1.918341] ide-gd driver 1.18
[    1.918371] ide-cd driver 5.00
[    1.918433] Loading iSCSI transport class v2.0-870.
[    1.918696] ata_piix 0000:00:1f.2: version 2.13
[    1.918708] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.918717] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    1.918746] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.918783] scsi0 : ata_piix
[    1.918864] scsi1 : ata_piix
[    1.920035] ata1: SATA max UDMA/133 cmd 0xd400 ctl 0xd080 bmdma 0xc880 irq 19
[    1.920043] ata2: SATA max UDMA/133 cmd 0xd000 ctl 0xcc00 bmdma 0xc888 irq 19
[    1.920206] 3c59x 0000:02:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.920222] 3c59x: Donald Becker and others.
[    1.920231] 0000:02:00.0: 3Com PCI 3c905B Cyclone 100baseTx at ffffc9000007ec00.
[    1.941546] tun: Universal TUN/TAP device driver, 1.6
[    1.941551] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.941604] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.941618] r8169 0000:02:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.941635] r8169 0000:02:05.0: (unregistered net_device): no PCI Express capability
[    1.941791] r8169 0000:02:05.0: eth1: RTL8169sc/8110sc at 0xffffc90004484800, 00:23:54:e3:50:ff, XID 18000000 IRQ 18
[    1.946555] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.946720] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    1.946737] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.946942] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.946945] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.947881] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.948758] ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
[    1.948761] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    1.948771] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    1.949698] ehci_hcd 0000:00:1d.7: debug port 1
[    1.950631] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.954516] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.954518] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    1.954529] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfbffbc00
[    1.954705] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.958603] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    1.964133] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.964420] usb usb1: default language 0x0409
[    1.964425] usb usb1: udev 1, busnum 1, minor = 0
[    1.964427] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.964742] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.965757] usb usb1: Product: EHCI Host Controller
[    1.966780] usb usb1: Manufacturer: Linux 2.6.35-rc4 ehci_hcd
[    1.967818] usb usb1: SerialNumber: 0000:00:1d.7
[    1.968925] usb usb1: usb_probe_device
[    1.968928] usb usb1: configuration #1 chosen from 1 choice
[    1.968933] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    1.968966] hub 1-0:1.0: usb_probe_interface
[    1.968967] hub 1-0:1.0: usb_probe_interface - got id
[    1.968969] hub 1-0:1.0: USB hub found
[    1.969928] hub 1-0:1.0: 8 ports detected
[    1.970993] hub 1-0:1.0: standalone hub
[    1.970994] hub 1-0:1.0: no power switching (usb 1.0)
[    1.970996] hub 1-0:1.0: individual port over-current protection
[    1.970997] hub 1-0:1.0: power on to power good time: 20ms
[    1.971001] hub 1-0:1.0: local power source is good
[    1.971003] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    1.971066] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.972091] ohci_hcd: block sizes: ed 80 td 96
[    1.972117] uhci_hcd: USB Universal Host Controller Interface driver
[    1.973259] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.974341] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.974343] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.975523] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.976666] uhci_hcd 0000:00:1d.0: detected 2 ports
[    1.977717] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.977719] uhci_hcd 0000:00:1d.0: Performing full reset
[    1.977730] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    1.977734] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d480
[    1.978923] usb usb2: default language 0x0409
[    1.978928] usb usb2: udev 1, busnum 2, minor = 128
[    1.978929] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.980129] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.981338] usb usb2: Product: UHCI Host Controller
[    1.982531] usb usb2: Manufacturer: Linux 2.6.35-rc4 uhci_hcd
[    1.983726] usb usb2: SerialNumber: 0000:00:1d.0
[    1.984962] usb usb2: usb_probe_device
[    1.984965] usb usb2: configuration #1 chosen from 1 choice
[    1.984969] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    1.984999] hub 2-0:1.0: usb_probe_interface
[    1.985001] hub 2-0:1.0: usb_probe_interface - got id
[    1.985002] hub 2-0:1.0: USB hub found
[    1.986089] hub 2-0:1.0: 2 ports detected
[    1.987261] hub 2-0:1.0: standalone hub
[    1.987262] hub 2-0:1.0: no power switching (usb 1.0)
[    1.987263] hub 2-0:1.0: individual port over-current protection
[    1.987265] hub 2-0:1.0: power on to power good time: 2ms
[    1.987268] hub 2-0:1.0: local power source is good
[    1.987270] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    1.987299] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    1.987310] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.988470] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.988473] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.989693] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    1.990850] uhci_hcd 0000:00:1d.1: detected 2 ports
[    1.992027] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.992029] uhci_hcd 0000:00:1d.1: Performing full reset
[    1.992040] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    1.992044] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d800
[    1.993223] usb usb3: default language 0x0409
[    1.993228] usb usb3: udev 1, busnum 3, minor = 256
[    1.993229] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.994277] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.995448] usb usb3: Product: UHCI Host Controller
[    1.996645] usb usb3: Manufacturer: Linux 2.6.35-rc4 uhci_hcd
[    1.997822] usb usb3: SerialNumber: 0000:00:1d.1
[    1.999043] usb usb3: usb_probe_device
[    1.999045] usb usb3: configuration #1 chosen from 1 choice
[    1.999049] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    1.999079] hub 3-0:1.0: usb_probe_interface
[    1.999081] hub 3-0:1.0: usb_probe_interface - got id
[    1.999082] hub 3-0:1.0: USB hub found
[    2.000164] hub 3-0:1.0: 2 ports detected
[    2.001317] hub 3-0:1.0: standalone hub
[    2.001318] hub 3-0:1.0: no power switching (usb 1.0)
[    2.001320] hub 3-0:1.0: individual port over-current protection
[    2.001321] hub 3-0:1.0: power on to power good time: 2ms
[    2.001324] hub 3-0:1.0: local power source is good
[    2.001326] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    2.001355] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    2.001367] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.002510] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.002512] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.003725] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.004897] uhci_hcd 0000:00:1d.2: detected 2 ports
[    2.006066] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    2.006068] uhci_hcd 0000:00:1d.2: Performing full reset
[    2.006079] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    2.006090] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d880
[    2.007240] usb usb4: default language 0x0409
[    2.007244] usb usb4: udev 1, busnum 4, minor = 384
[    2.007246] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.008387] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.009557] usb usb4: Product: UHCI Host Controller
[    2.010650] usb usb4: Manufacturer: Linux 2.6.35-rc4 uhci_hcd
[    2.011754] usb usb4: SerialNumber: 0000:00:1d.2
[    2.012964] usb usb4: usb_probe_device
[    2.012966] usb usb4: configuration #1 chosen from 1 choice
[    2.012970] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    2.013001] hub 4-0:1.0: usb_probe_interface
[    2.013002] hub 4-0:1.0: usb_probe_interface - got id
[    2.013004] hub 4-0:1.0: USB hub found
[    2.014088] hub 4-0:1.0: 2 ports detected
[    2.015221] hub 4-0:1.0: standalone hub
[    2.015222] hub 4-0:1.0: no power switching (usb 1.0)
[    2.015223] hub 4-0:1.0: individual port over-current protection
[    2.015225] hub 4-0:1.0: power on to power good time: 2ms
[    2.015228] hub 4-0:1.0: local power source is good
[    2.015229] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    2.015255] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    2.015266] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    2.016397] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.016399] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.017589] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.018724] uhci_hcd 0000:00:1d.3: detected 2 ports
[    2.019858] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
[    2.019859] uhci_hcd 0000:00:1d.3: Performing full reset
[    2.019871] uhci_hcd 0000:00:1d.3: supports USB remote wakeup
[    2.019875] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000dc00
[    2.021015] usb usb5: default language 0x0409
[    2.021019] usb usb5: udev 1, busnum 5, minor = 512
[    2.021021] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.022142] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.023288] usb usb5: Product: UHCI Host Controller
[    2.024417] usb usb5: Manufacturer: Linux 2.6.35-rc4 uhci_hcd
[    2.025550] usb usb5: SerialNumber: 0000:00:1d.3
[    2.026722] usb usb5: usb_probe_device
[    2.026724] usb usb5: configuration #1 chosen from 1 choice
[    2.026729] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    2.026759] hub 5-0:1.0: usb_probe_interface
[    2.026761] hub 5-0:1.0: usb_probe_interface - got id
[    2.026762] hub 5-0:1.0: USB hub found
[    2.027644] hub 5-0:1.0: 2 ports detected
[    2.028713] hub 5-0:1.0: standalone hub
[    2.028714] hub 5-0:1.0: no power switching (usb 1.0)
[    2.028716] hub 5-0:1.0: individual port over-current protection
[    2.028717] hub 5-0:1.0: power on to power good time: 2ms
[    2.028720] hub 5-0:1.0: local power source is good
[    2.028722] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    2.028748] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.3
[    2.028803] usbcore: registered new interface driver usblp
[    2.029803] Initializing USB Mass Storage driver...
[    2.030923] usbcore: registered new interface driver usb-storage
[    2.031982] USB Mass Storage support registered.
[    2.033103] usbcore: registered new interface driver libusual
[    2.034246] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    2.035281] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    2.036987] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.037620] mice: PS/2 mouse device common for all mice
[    2.038817] I2O subsystem v1.325
[    2.039816] i2o: max drivers = 8
[    2.041044] rtc_cmos 00:03: RTC can wake from S4
[    2.042123] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.043242] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.044279] i2c /dev entries driver
[    2.045505] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.046684] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    2.047794] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0860)
[    2.048944] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.050082] cpuidle: using governor ladder
[    2.051258] No iBFT detected.
[    2.052420] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    2.054304] usbcore: registered new interface driver usbhid
[    2.054785] usbhid: USB HID core driver
[    2.056271] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.057195] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[    2.057214] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    2.058997] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    2.071105] ata2.01: NODEV after polling detection
[    2.071244] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001803 POWER sig=j CSC CONNECT
[    2.071247] hub 1-0:1.0: port 5: status 0501 change 0001
[    2.072227] ALSA device list:
[    2.072436]   #0: HDA Intel at 0xfbffc000 irq 41
[    2.073314] Netfilter messages via NETLINK v0.30.
[    2.074529] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.075436] ata2.00: ATAPI: PIONEER DVD-RW  DVR-217, 1.07, max UDMA/66
[    2.077119] ctnetlink v0.93: registering with nfnetlink.
[    2.078365] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.079283] TCP cubic registered
[    2.080466] Initializing XFRM netlink socket
[    2.081270] ata2.00: configured for UDMA/66
[    2.083038] NET: Registered protocol family 10
[    2.084763] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.085326] IPv6 over IPv4 tunneling driver
[    2.086894] NET: Registered protocol family 17
[    2.088144] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.088370]   Magic number: 2:437:933
[    2.101143] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.101424] ata1.00: ATA-8: STM3320418AS, CC34, max UDMA/133
[    2.101666] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.115136] uhci_hcd 0000:00:1d.2: port 1 portsc 0082,00
[    2.128143] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.150274] ata1.00: configured for UDMA/133
[    2.150610] scsi 0:0:0:0: Direct-Access     ATA      STM3320418AS     CC34 PQ: 0 ANSI: 5
[    2.151522] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.152618] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    2.153881] sd 0:0:0:0: [sda] Write Protect is off
[    2.155055] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.155072] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.156399]  sda:
[    2.171136] hub 1-0:1.0: state 7 ports 8 chg 0020 evt 0000
[    2.171434] hub 1-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
[    2.173048]  sda1 sda2 sda3 sda4 <
[    2.184648] scsi 1:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-217  1.07 PQ: 0 ANSI: 5
[    2.185810]  sda5 sda6 sda7 >
[    2.209005] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.222246] ehci_hcd 0000:00:1d.7: port 5 high speed
[    2.222250] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
[    2.273010] usb 1-5: new high speed USB device using ehci_hcd and address 2
[    2.279031] sr0: scsi3-mmc drive: 16x/16x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.279288] Uniform CD-ROM driver Revision: 3.20
[    2.280361] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.280426] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.305662] EXT3-fs: barriers not enabled
[    2.311665] kjournald starting.  Commit interval 5 seconds
[    2.311689] EXT3-fs (sda2): mounted filesystem with writeback data mode
[    2.311700] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
[    2.324243] ehci_hcd 0000:00:1d.7: port 5 high speed
[    2.324247] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
[    2.329238] devtmpfs: mounted
[    2.329530] Freeing unused kernel memory: 460k freed
[    2.330700] Write protecting the kernel read-only data: 10240k
[    2.332042] Freeing unused kernel memory: 920k freed
[    2.333593] Freeing unused kernel memory: 1968k freed
[    2.388128] usb 1-5: default language 0x0409
[    2.389376] usb 1-5: udev 2, busnum 1, minor = 1
[    2.389380] usb 1-5: New USB device found, idVendor=058f, idProduct=6362
[    2.389648] usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.390719] usb 1-5: Product: Mass Storage Device
[    2.391960] usb 1-5: Manufacturer: Generic
[    2.393227] usb 1-5: SerialNumber: 058F312D81B
[    2.394494] khelper used greatest stack depth: 6144 bytes left
[    2.395634] usb 1-5: usb_probe_device
[    2.395637] usb 1-5: configuration #1 chosen from 1 choice
[    2.396007] usb 1-5: adding 1-5:1.0 (config #1, interface 0)
[    2.396081] usb-storage 1-5:1.0: usb_probe_interface
[    2.396087] usb-storage 1-5:1.0: usb_probe_interface - got id
[    2.396187] scsi2 : usb-storage 1-5:1.0
[    2.396997] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.663888] fsck.ext3 used greatest stack depth: 4032 bytes left
[    3.144245] EXT3-fs (sda2): using internal journal
[    3.204138] usb usb2: suspend_rh (auto-stop)
[    3.204158] usb usb3: suspend_rh (auto-stop)
[    3.204176] usb usb5: suspend_rh (auto-stop)
[    3.204195] usb usb4: suspend_rh (auto-stop)
[    3.240905] EXT2-fs (sda1): warning: mounting ext3 filesystem as ext2
[    3.269063] EXT3-fs: barriers not enabled
[    3.269451] kjournald starting.  Commit interval 5 seconds
[    3.269652] EXT3-fs (sda3): using internal journal
[    3.269655] EXT3-fs (sda3): mounted filesystem with writeback data mode
[    3.300332] EXT3-fs: barriers not enabled
[    3.300736] kjournald starting.  Commit interval 5 seconds
[    3.300952] EXT3-fs (sda5): using internal journal
[    3.300954] EXT3-fs (sda5): mounted filesystem with writeback data mode
[    3.396737] scsi 2:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[    3.398269] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    3.399366] scsi 2:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[    3.399796] sd 2:0:0:1: Attached scsi generic sg3 type 0
[    3.400849] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[    3.402862] scsi 2:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
[    3.403324] sd 2:0:0:2: Attached scsi generic sg4 type 0
[    3.404727] sd 2:0:0:1: [sdc] Attached SCSI removable disk
[    3.406737] scsi 2:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[    3.407208] sd 2:0:0:3: Attached scsi generic sg5 type 0
[    3.408601] sd 2:0:0:2: [sdd] Attached SCSI removable disk
[    3.411226] sd 2:0:0:3: [sde] Attached SCSI removable disk
[    3.552823] ldconfig used greatest stack depth: 3984 bytes left
[    3.995175] rc used greatest stack depth: 3760 bytes left
[    4.119443] eth0:  setting full-duplex.
[   12.662571] fbpad:980 conflicting memory types e0049000-e0549000 uncached-minus<->write-combining
[   12.662579] reserve_memtype failed 0xe0049000-0xe0549000, track uncached-minus, req uncached-minus
[   13.303389] fbpad:980 map pfn expected mapping type uncached-minus for e0049000-e0549000, got write-combining

