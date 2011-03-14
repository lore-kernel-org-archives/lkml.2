Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab1CNXrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 19:47:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:46573 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab1CNXrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 19:47:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,319,1297065600"; 
   d="txt'?scan'208";a="720136279"
Date: Mon, 14 Mar 2011 16:47:25 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFT][PATCH] PCI / ACPI: Do not require MSI support for PCIe
 native features
Message-ID: <20110314234725.GA4145@xanatos>
References: <201103052254.48515.rjw@sisk.pl>
 <201103142102.11164.rjw@sisk.pl>
 <20110314201909.GA4937@xanatos>
 <201103142137.41607.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <201103142137.41607.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 14, 2011 at 09:37:41PM +0100, Rafael J. Wysocki wrote:
> On Monday, March 14, 2011, Sarah Sharp wrote:
> > On Mon, Mar 14, 2011 at 09:02:11PM +0100, Rafael J. Wysocki wrote:
> > > On Monday, March 14, 2011, Sarah Sharp wrote:
> > > > Hi Rafael,
> > > > 
> > > > I applied this patch, on top of this patch:
> > > > PCI/ACPI: Report ASPM support to BIOS if not disabled from command line
> > > > 
> > > > Unfortunately, the Express Card still doesn't show up.  The trace looks
> > > > slightly different, but the irq still gets disabled.  dmesg is attached.
> > > 
> > > Hmm.  It looks like, for some reason, the check against
> > > pcie_aspm_support_enabled() returns false on your system.  Do you have
> > > ASPM enabled in .config?
> > 
> > My .config is attached.  Looks like CONFIG_PCIEASPM=y.
> 
> Does it help if you replace "pcie_aspm_support_enabled()" with "true" in
> drivers/acpi/pci_root.c:acpi_pci_root_add() ?

No, it doesn't.  dmesg is attached.

Sarah Sharp

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-rc8+ (sarah@xanatos) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #776 SMP PREEMPT Mon Mar 14 14:41:16 PDT 2011
[    0.000000] Command line: root=UUID=7b14f772-a799-415f-a4c9-931ef81f6f0d ro  
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd6a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6a1000 - 00000000bd6a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6a7000 - 00000000bd7b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd7b7000 - 00000000bd80f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd80f000 - 00000000bd8c7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd8c7000 - 00000000bd8d2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd8d2000 - 00000000bd8d5000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd8d5000 - 00000000bd8d9000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd8d9000 - 00000000bd8dd000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd8dd000 - 00000000bd8e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd8e0000 - 00000000bd907000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd907000 - 00000000bd908000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd908000 - 00000000bdb0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bdb0f000 - 00000000bdb9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdb9f000 - 00000000bdbff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdbff000 - 00000000bdc00000 (usable)
[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: LENOVO 74663HU/74663HU, BIOS 6DET44WW (2.08 ) 04/22/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bde00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbdc00 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bdc00000
[    0.000000]  0000000000 - 00bdc00000 page 2M
[    0.000000] kernel direct mapping tables up to bdc00000 @ 1fffc000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ bd8c1000-bd8c7000
[    0.000000] RAMDISK: 3600e000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7380 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bdb7bdd4 00094 (v01 LENOVO TP-6D    00002080  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bdb7bf00 000F4 (v03 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bdb7c2f4 0D881 (v01 LENOVO TP-6D    00002080 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bdb8e000 00040
[    0.000000] ACPI: SSDT 00000000bdb7c0b4 00240 (v01 LENOVO TP-6D    00002080 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bdb89b75 00052 (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bdb89bc7 00078 (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bdb89c3f 0003C (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bdb89c7b 00038 (v01 LENOVO TP-6D    00002080 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bdb89dc2 00176 (v01 LENOVO TP-6D    00002080  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bdb89f38 00028 (v01 LENOVO TP-6D    00002080  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bdb89f60 000A0 (v16 LENOVO TP-6D    00002080 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bdb8d203 0055F (v01 LENOVO TP-6D    00002080 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd907000 00032 (v00                 00000000      00000000)
[    0.000000] ACPI: SSDT 00000000bd8d4000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd8d3000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd8d2000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff8800b0000000-ffff8800b37fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd6a1
[    0.000000]     0: 0x000bd6a7 -> 0x000bd7b7
[    0.000000]     0: 0x000bd80f -> 0x000bd8c7
[    0.000000]     0: 0x000bdbff -> 0x000bdc00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1021944
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 757922 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd6a1000 - 00000000bd6a7000
[    0.000000] PM: Registered nosave memory: 00000000bd7b7000 - 00000000bd80f000
[    0.000000] PM: Registered nosave memory: 00000000bd8c7000 - 00000000bd8d2000
[    0.000000] PM: Registered nosave memory: 00000000bd8d2000 - 00000000bd8d5000
[    0.000000] PM: Registered nosave memory: 00000000bd8d5000 - 00000000bd8d9000
[    0.000000] PM: Registered nosave memory: 00000000bd8d9000 - 00000000bd8dd000
[    0.000000] PM: Registered nosave memory: 00000000bd8dd000 - 00000000bd8e0000
[    0.000000] PM: Registered nosave memory: 00000000bd8e0000 - 00000000bd907000
[    0.000000] PM: Registered nosave memory: 00000000bd907000 - 00000000bd908000
[    0.000000] PM: Registered nosave memory: 00000000bd908000 - 00000000bdb0f000
[    0.000000] PM: Registered nosave memory: 00000000bdb0f000 - 00000000bdb9f000
[    0.000000] PM: Registered nosave memory: 00000000bdb9f000 - 00000000bdbff000
[    0.000000] PM: Registered nosave memory: 00000000bdc00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8800bd400000 s75840 r8192 d22464 u1048576
[    0.000000] pcpu-alloc: s75840 r8192 d22464 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1004242
[    0.000000] Kernel command line: root=UUID=7b14f772-a799-415f-a4c9-931ef81f6f0d ro  
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3908256k/5177344k available (4769k kernel code, 1089568k absent, 179520k reserved, 3936k data, 524k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1862.079 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 3724.15 BogoMIPS (lpj=7448316)
[    0.008054] pid_max: default: 32768 minimum: 301
[    0.008421] Mount-cache hash table entries: 256
[    0.009709] Initializing cgroup subsys ns
[    0.009757] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.009824] Initializing cgroup subsys cpuacct
[    0.009885] Initializing cgroup subsys memory
[    0.010034] Initializing cgroup subsys freezer
[    0.010250] CPU: Physical Processor ID: 0
[    0.010297] CPU: Processor Core ID: 0
[    0.010342] using mwait in idle threads.
[    0.010440] ACPI: Core revision 20110112
[    0.156288] Setting APIC routing to flat
[    0.156802] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.199397] CPU0: Intel(R) Core(TM)2 Duo CPU     L9400  @ 1.86GHz stepping 0a
[    0.200011] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.200011] ... version:                2
[    0.200011] ... bit width:              40
[    0.200011] ... generic registers:      2
[    0.200011] ... value mask:             000000ffffffffff
[    0.200011] ... max period:             000000007fffffff
[    0.200011] ... fixed-purpose events:   3
[    0.200011] ... event mask:             0000000700000003
[    0.208175] NMI watchdog enabled, takes one hw-pmu counter.
[    0.220029] lockdep: fixing up alternatives.
[    0.224109] Booting Node   0, Processors  #1 Ok.
[    0.316089] NMI watchdog enabled, takes one hw-pmu counter.
[    0.320030] Brought up 2 CPUs
[    0.320078] Total of 2 processors activated (7448.10 BogoMIPS).
[    0.324820] NET: Registered protocol family 16
[    0.327106] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.327176] ACPI: bus type pci registered
[    0.327862] PCI: Using configuration type 1 for base access
[    0.341091] bio: create slab <bio-0> at 0
[    0.350220] ACPI: EC: EC description table is found, configuring boot EC
[    0.495771] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.540777] ACPI: SSDT 00000000bd8d7c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.543687] ACPI: Dynamic OEM Table Load:
[    0.543800] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.547919] ACPI: SSDT 00000000bd8d5020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.553040] ACPI: Dynamic OEM Table Load:
[    0.553153] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.589247] ACPI: SSDT 00000000bd8d6ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.593288] ACPI: Dynamic OEM Table Load:
[    0.593401] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.611624] ACPI: SSDT 00000000bd8d6f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.614264] ACPI: Dynamic OEM Table Load:
[    0.614377] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.634565] ACPI: Interpreter enabled
[    0.634615] ACPI: (supports S0 S3 S4 S5)
[    0.635183] ACPI: Using IOAPIC for interrupt routing
[    0.712765] ACPI: Power Resource [PUBS] (on)
[    0.774856] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.813400] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.813453] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.820369] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.821204] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.821257] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.821310] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.821373] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.821436] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.821500] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.821645] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.821736] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    0.821757] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.821770] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.821780] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.821846] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    0.821864] pci 0000:00:02.1: reg 10: [mem 0xf2400000-0xf24fffff 64bit]
[    0.821956] pci 0000:00:03.0: [8086:2a44] type 0 class 0x000780
[    0.821981] pci 0000:00:03.0: reg 10: [mem 0xf2826800-0xf282680f 64bit]
[    0.822045] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.822051] pci 0000:00:03.0: PME# disabled
[    0.822094] pci 0000:00:03.2: [8086:2a46] type 0 class 0x000101
[    0.822115] pci 0000:00:03.2: reg 10: [io  0x1828-0x182f]
[    0.822125] pci 0000:00:03.2: reg 14: [io  0x180c-0x180f]
[    0.822136] pci 0000:00:03.2: reg 18: [io  0x1820-0x1827]
[    0.822147] pci 0000:00:03.2: reg 1c: [io  0x1808-0x180b]
[    0.822157] pci 0000:00:03.2: reg 20: [io  0x1810-0x181f]
[    0.822237] pci 0000:00:03.3: [8086:2a47] type 0 class 0x000700
[    0.822257] pci 0000:00:03.3: reg 10: [io  0x1830-0x1837]
[    0.822268] pci 0000:00:03.3: reg 14: [mem 0xf2624000-0xf2624fff]
[    0.822428] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    0.822461] pci 0000:00:19.0: reg 10: [mem 0xf2600000-0xf261ffff]
[    0.822476] pci 0000:00:19.0: reg 14: [mem 0xf2625000-0xf2625fff]
[    0.822492] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.822583] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.822590] pci 0000:00:19.0: PME# disabled
[    0.822638] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.822712] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.822804] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.822879] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.822970] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    0.823045] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    0.823152] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.823185] pci 0000:00:1a.7: reg 10: [mem 0xf2826c00-0xf2826fff]
[    0.823302] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.823310] pci 0000:00:1a.7: PME# disabled
[    0.823366] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.823392] pci 0000:00:1b.0: reg 10: [mem 0xf2620000-0xf2623fff 64bit]
[    0.823503] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.823510] pci 0000:00:1b.0: PME# disabled
[    0.823560] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.823673] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.823679] pci 0000:00:1c.0: PME# disabled
[    0.823731] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    0.823844] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.823850] pci 0000:00:1c.1: PME# disabled
[    0.823904] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.824017] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.824023] pci 0000:00:1c.3: PME# disabled
[    0.824217] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.824292] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    0.824384] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.824458] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    0.824551] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.824625] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    0.824733] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.824766] pci 0000:00:1d.7: reg 10: [mem 0xf2827000-0xf28273ff]
[    0.824883] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.824890] pci 0000:00:1d.7: PME# disabled
[    0.824938] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.825061] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.825267] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.825304] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    0.825319] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    0.825334] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    0.825349] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    0.825364] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.825379] pci 0000:00:1f.2: reg 24: [mem 0xf2826000-0xf28267ff]
[    0.825445] pci 0000:00:1f.2: PME# supported from D3hot
[    0.825451] pci 0000:00:1f.2: PME# disabled
[    0.825497] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.825525] pci 0000:00:1f.3: reg 10: [mem 0xf2827400-0xf28274ff 64bit]
[    0.825564] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.825703] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.825757] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.825764] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.825774] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.826002] pci 0000:03:00.0: [8086:4237] type 0 class 0x000280
[    0.826065] pci 0000:03:00.0: reg 10: [mem 0xf2500000-0xf2501fff 64bit]
[    0.826305] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.826333] pci 0000:03:00.0: PME# disabled
[    0.826452] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.826506] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.826513] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.826523] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.826616] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.826670] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.826676] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.826686] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.826822] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d] (subtractive decode)
[    0.826879] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.826886] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.826896] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.826908] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.826920] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.826931] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.826943] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.826954] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.826966] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.827000] pci_bus 0000:00: on NUMA node 0
[    0.827023] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.833648] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.835070] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.836566] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    1.045011] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    1.047232] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    1.049586] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    1.051806] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    1.054024] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    1.056363] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    1.058583] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    1.060816] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    1.062065] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.062314] vgaarb: loaded
[    1.063765] SCSI subsystem initialized
[    1.064217] libata version 3.00 loaded.
[    1.064697] PCI: Using ACPI for IRQ routing
[    1.064697] PCI: pci_cache_line_size set to 64 bytes
[    1.064773] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    1.064785] reserve RAM buffer: 00000000bd6a1000 - 00000000bfffffff 
[    1.064931] reserve RAM buffer: 00000000bd7b7000 - 00000000bfffffff 
[    1.065054] reserve RAM buffer: 00000000bd8c7000 - 00000000bfffffff 
[    1.065157] reserve RAM buffer: 00000000bdc00000 - 00000000bfffffff 
[    1.066326] Bluetooth: Core ver 2.15
[    1.066472] NET: Registered protocol family 31
[    1.066521] Bluetooth: HCI device and connection manager initialized
[    1.066587] Bluetooth: HCI socket layer initialized
[    1.066974] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.072274] Switching to clocksource hpet
[    1.072392] pnp: PnP ACPI init
[    1.072594] ACPI: bus type pnp registered
[    1.075689] Switched to NOHz mode on CPU #0
[    1.075765] Switched to NOHz mode on CPU #1
[    1.106031] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    1.106042] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    1.106052] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    1.106062] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    1.106072] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    1.106082] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    1.106091] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    1.106101] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    1.106110] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    1.106120] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    1.106130] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    1.106140] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    1.106149] pnp 00:00: [mem 0x000ec000-0x000effff]
[    1.106159] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    1.106169] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    1.106178] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    1.106188] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    1.106893] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.106965] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    1.107037] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    1.107107] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    1.107177] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    1.107248] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    1.107323] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    1.107399] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    1.107475] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    1.107551] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    1.107626] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    1.107702] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    1.107777] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    1.107853] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    1.107928] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    1.107984] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.108206] pnp 00:01: [bus 00-ff]
[    1.108216] pnp 00:01: [io  0x0cf8-0x0cff]
[    1.108226] pnp 00:01: [io  0x0000-0x0cf7 window]
[    1.108235] pnp 00:01: [io  0x0d00-0xffff window]
[    1.108245] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    1.108255] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    1.108264] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    1.108275] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    1.108285] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    1.108295] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    1.108304] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    1.108314] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    1.108324] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    1.108333] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    1.108343] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    1.108353] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    1.108362] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    1.108372] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
[    1.108381] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    1.108748] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.130832] pnp 00:02: [io  0x0010-0x001f]
[    1.130842] pnp 00:02: [io  0x0090-0x009f]
[    1.130852] pnp 00:02: [io  0x0024-0x0025]
[    1.130861] pnp 00:02: [io  0x0028-0x0029]
[    1.130870] pnp 00:02: [io  0x002c-0x002d]
[    1.130880] pnp 00:02: [io  0x0030-0x0031]
[    1.130889] pnp 00:02: [io  0x0034-0x0035]
[    1.130898] pnp 00:02: [io  0x0038-0x0039]
[    1.130907] pnp 00:02: [io  0x003c-0x003d]
[    1.130917] pnp 00:02: [io  0x00a4-0x00a5]
[    1.130927] pnp 00:02: [io  0x00a8-0x00a9]
[    1.130936] pnp 00:02: [io  0x00ac-0x00ad]
[    1.130945] pnp 00:02: [io  0x00b0-0x00b5]
[    1.130954] pnp 00:02: [io  0x00b8-0x00b9]
[    1.130963] pnp 00:02: [io  0x00bc-0x00bd]
[    1.130973] pnp 00:02: [io  0x0050-0x0053]
[    1.130982] pnp 00:02: [io  0x0072-0x0077]
[    1.130991] pnp 00:02: [io  0x002e-0x002f]
[    1.131001] pnp 00:02: [io  0x1000-0x107f]
[    1.131010] pnp 00:02: [io  0x1180-0x11ff]
[    1.131019] pnp 00:02: [io  0x0800-0x080f]
[    1.131029] pnp 00:02: [io  0x15e0-0x15ef]
[    1.131038] pnp 00:02: [io  0x1600-0x167f]
[    1.131047] pnp 00:02: [io  0x1680-0x169f]
[    1.131057] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    1.131066] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    1.131076] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    1.131085] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    1.131095] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    1.131104] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    1.131831] system 00:02: [io  0x1000-0x107f] has been reserved
[    1.131902] system 00:02: [io  0x1180-0x11ff] has been reserved
[    1.131972] system 00:02: [io  0x0800-0x080f] has been reserved
[    1.132058] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    1.132128] system 00:02: [io  0x1600-0x167f] has been reserved
[    1.132198] system 00:02: [io  0x1680-0x169f] has been reserved
[    1.132268] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    1.132340] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.132410] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    1.132481] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.132552] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.132622] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    1.132677] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.133298] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.133658] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.133790] pnp 00:04: [io  0x0000-0x000f]
[    1.133800] pnp 00:04: [io  0x0080-0x008f]
[    1.133809] pnp 00:04: [io  0x00c0-0x00df]
[    1.133819] pnp 00:04: [dma 4]
[    1.134176] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.134307] pnp 00:05: [io  0x0061]
[    1.134668] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.134798] pnp 00:06: [io  0x00f0]
[    1.134816] pnp 00:06: [irq 13]
[    1.135177] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.135308] pnp 00:07: [io  0x0070-0x0071]
[    1.135324] pnp 00:07: [irq 8]
[    1.135684] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.135816] pnp 00:08: [io  0x0060]
[    1.135825] pnp 00:08: [io  0x0064]
[    1.135840] pnp 00:08: [irq 1]
[    1.136225] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.136360] pnp 00:09: [irq 12]
[    1.136732] pnp 00:09: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    1.158595] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    1.158955] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
[    1.162993] pnp: PnP ACPI: found 11 devices
[    1.163042] ACPI: ACPI bus type pnp unregistered
[    1.190817] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc01fffff]
[    1.190876] pci 0000:00:1c.0: BAR 9: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.190944] pci 0000:00:1c.1: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.191012] pci 0000:00:1c.0: BAR 7: assigned [io  0x3000-0x3fff]
[    1.191067] pci 0000:00:1c.1: BAR 7: assigned [io  0x4000-0x4fff]
[    1.191121] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.191173] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    1.191230] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    1.191286] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.191356] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.191408] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    1.191464] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    1.191520] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.191590] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    1.191642] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.191698] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    1.191754] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.191824] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
[    1.191874] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.191930] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.191984] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.192081] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.192138] pci 0000:00:1c.0: setting latency timer to 64
[    1.192159] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.192215] pci 0000:00:1c.1: setting latency timer to 64
[    1.192236] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.192292] pci 0000:00:1c.3: setting latency timer to 64
[    1.192302] pci 0000:00:1e.0: setting latency timer to 64
[    1.192307] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.192310] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.192313] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.192316] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.192319] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.192322] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.192325] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    1.192328] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    1.192332] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.192335] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    1.192338] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
[    1.192341] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.192344] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    1.192347] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    1.192350] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.192353] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
[    1.192356] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
[    1.192359] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
[    1.192362] pci_bus 0000:0d: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.192365] pci_bus 0000:0d: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.192368] pci_bus 0000:0d: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.192501] NET: Registered protocol family 2
[    1.192800] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.194331] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.196102] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    1.199432] TCP: Hash tables configured (established 262144 bind 65536)
[    1.199520] TCP reno registered
[    1.199588] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    1.199882] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    1.200622] NET: Registered protocol family 1
[    1.200740] pci 0000:00:02.0: Boot video device
[    1.200812] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.200815] pci 0000:00:1a.0: Performing full reset
[    1.200846] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.200849] pci 0000:00:1a.1: Performing full reset
[    1.200879] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.200882] pci 0000:00:1a.2: Performing full reset
[    1.201039] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.201042] pci 0000:00:1d.0: Performing full reset
[    1.201072] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.201075] pci 0000:00:1d.1: Performing full reset
[    1.201105] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.201108] pci 0000:00:1d.2: Performing full reset
[    1.201250] PCI: CLS 64 bytes, default 64
[    1.201625] Trying to unpack rootfs image as initramfs...
[    2.119565] Freeing initrd memory: 32648k freed
[    2.275853] DMA-API: preallocated 32768 debug entries
[    2.275910] DMA-API: debugging enabled by kernel config
[    2.275969] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.276042] Placing 64MB software IO TLB between ffff8800b8c9d000 - ffff8800bcc9d000
[    2.276105] software IO TLB at phys 0xb8c9d000 - 0xbcc9d000
[    2.276337] Simple Boot Flag at 0x35 set to 0x1
[    2.277806] Scanning for low memory corruption every 60 seconds
[    2.278671] audit: initializing netlink socket (disabled)
[    2.278799] type=2000 audit(1300141136.272:1): initialized
[    2.295809] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.321025] fuse init (API version 7.16)
[    2.321992] msgmni has been set to 7697
[    2.323276] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.323348] io scheduler noop registered
[    2.323396] io scheduler deadline registered
[    2.323764] io scheduler cfq registered (default)
[    2.325345] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.325756] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.326581] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.327780] ACPI: AC Adapter [AC] (on-line)
[    2.329305] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    2.364029] ACPI: Lid Switch [LID]
[    2.364737] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    2.428020] ACPI: Sleep Button [SLPB]
[    2.428743] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    2.428819] ACPI: Power Button [PWRF]
[    2.429050] ACPI: acpi_idle registered with cpuidle
[    2.546331] Monitor-Mwait will be used to enter C-1 state
[    2.546409] Monitor-Mwait will be used to enter C-2 state
[    2.546483] Monitor-Mwait will be used to enter C-3 state
[    2.546496] Marking TSC unstable due to TSC halts in idle
[    2.643064] thermal LNXTHERM:00: registered as thermal_zone0
[    2.643116] ACPI: Thermal Zone [THM0] (62 C)
[    2.652727] thermal LNXTHERM:01: registered as thermal_zone1
[    2.652779] ACPI: Thermal Zone [THM1] (65 C)
[    2.653364] Linux agpgart interface v0.103
[    2.669897] brd: module loaded
[    2.678003] loop: module loaded
[    2.679447] ahci 0000:00:1f.2: version 3.0
[    2.679499] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.679716] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
[    2.679825] ahci: SSS flag set, parallel bus scan disabled
[    2.679903] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    2.679969] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    2.680126] ahci 0000:00:1f.2: setting latency timer to 64
[    2.690592] scsi0 : ahci
[    2.694659] scsi1 : ahci
[    2.695829] scsi2 : ahci
[    2.696986] scsi3 : ahci
[    2.706756] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.706912] ACPI: Battery Slot [BAT0] (battery present)
[    2.708163] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 40
[    2.708228] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 40
[    2.708290] ata3: DUMMY
[    2.708336] ata4: DUMMY
[    2.709041] ata_generic 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.709234] ata_generic 0000:00:03.2: setting latency timer to 64
[    2.715450] scsi4 : ata_generic
[    2.716561] scsi5 : ata_generic
[    2.717469] ata5: PATA max UDMA/100 cmd 0x1828 ctl 0x180c bmdma 0x1810 irq 18
[    2.717522] ata6: PATA max UDMA/100 cmd 0x1820 ctl 0x1808 bmdma 0x1818 irq 18
[    2.717808] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-k2
[    2.717860] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    2.717988] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.718064] e1000e 0000:00:19.0: setting latency timer to 64
[    2.718328] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    3.028032] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.031429] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.031434] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.031499] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.031801] ata1.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102M3, max UDMA/133
[    3.031854] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.035346] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.035351] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.035417] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.035719] ata1.00: configured for UDMA/133
[    3.036637] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
[    3.039477] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.039517] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:1d:fb:eb
[    3.039520] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.039553] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[    3.039712] PPP generic driver version 2.4.2
[    3.040614] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.040652] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    3.041551] sd 0:0:0:0: [sda] Write Protect is off
[    3.041603] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.041864] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.045220]  sda: sda1 sda2
[    3.048135] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.051544] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.051975] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.052996] mousedev: PS/2 mouse device common for all mice
[    3.054459] rtc_cmos 00:07: RTC can wake from S4
[    3.059982] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    3.068626] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    3.068743] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.068856] Linux video capture interface: v2.00
[    3.069370] device-mapper: uevent: version 1.0.3
[    3.070039] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    3.070297] device-mapper: multipath: version 1.2.0 loaded
[    3.070362] device-mapper: multipath round-robin: version 1.0.0 loaded
[    3.072020] cpuidle: using governor ladder
[    3.073546] cpuidle: using governor menu
[    3.074504] TCP cubic registered
[    3.075715] NET: Registered protocol family 10
[    3.078210] NET: Registered protocol family 17
[    3.078448] Bluetooth: L2CAP ver 2.15
[    3.078496] Bluetooth: L2CAP socket layer initialized
[    3.078562] Bluetooth: SCO (Voice Link) ver 0.6
[    3.078610] Bluetooth: SCO socket layer initialized
[    3.078842] Bluetooth: RFCOMM TTY layer initialized
[    3.078909] Bluetooth: RFCOMM socket layer initialized
[    3.078959] Bluetooth: RFCOMM ver 1.11
[    3.079007] Registering the dns_resolver key type
[    3.079955] registered taskstats version 1
[    3.080162] kmemleak: Kernel memory leak detector initialized
[    3.080187] kmemleak: Automatic memory scanning thread started
[    3.081710] rtc_cmos 00:07: setting system clock to 2011-03-14 22:18:57 UTC (1300141137)
[    3.081775] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.081826] EDD information not available.
[    3.364108] ata2: SATA link down (SStatus 0 SControl 300)
[    3.532103] Freeing unused kernel memory: 524k freed
[    3.532353] Write protecting the kernel read-only data: 8192k
[    3.537673] Freeing unused kernel memory: 1356k freed
[    3.538431] Freeing unused kernel memory: 16k freed
[    3.558499] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    3.578107] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
[    4.010244] usbcore: registered new interface driver usbfs
[    4.011253] usbcore: registered new interface driver hub
[    4.011879] usbcore: registered new device driver usb
[    4.018682] uhci_hcd: USB Universal Host Controller Interface driver
[    4.019354] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.019423] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.019482] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.019590] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.019596] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.019726] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.022420] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.022473] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    4.022540] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    4.028196] uhci_hcd 0000:00:1a.0: detected 2 ports
[    4.028255] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.028258] uhci_hcd 0000:00:1a.0: Performing full reset
[    4.028275] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    4.028418] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    4.028848] usb usb1: default language 0x0409
[    4.028988] usb usb1: udev 1, busnum 1, minor = 0
[    4.028991] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.029043] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.029104] usb usb1: Product: UHCI Host Controller
[    4.029153] usb usb1: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.029202] usb usb1: SerialNumber: 0000:00:1a.0
[    4.029942] usb usb1: usb_probe_device
[    4.029946] usb usb1: configuration #1 chosen from 1 choice
[    4.030060] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.030552] hub 1-0:1.0: usb_probe_interface
[    4.030555] hub 1-0:1.0: usb_probe_interface - got id
[    4.030560] hub 1-0:1.0: USB hub found
[    4.030701] hub 1-0:1.0: 2 ports detected
[    4.030768] hub 1-0:1.0: standalone hub
[    4.030770] hub 1-0:1.0: no power switching (usb 1.0)
[    4.030772] hub 1-0:1.0: individual port over-current protection
[    4.030775] hub 1-0:1.0: power on to power good time: 2ms
[    4.030877] hub 1-0:1.0: local power source is good
[    4.030892] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.032686] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.032765] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.032770] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.032861] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    4.052159] uhci_hcd 0000:00:1a.1: detected 2 ports
[    4.052213] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.052216] uhci_hcd 0000:00:1a.1: Performing full reset
[    4.052381] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    4.052711] usb usb2: default language 0x0409
[    4.052850] usb usb2: udev 1, busnum 2, minor = 128
[    4.052853] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.052904] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.052966] usb usb2: Product: UHCI Host Controller
[    4.053015] usb usb2: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.053064] usb usb2: SerialNumber: 0000:00:1a.1
[    4.053788] usb usb2: usb_probe_device
[    4.053791] usb usb2: configuration #1 chosen from 1 choice
[    4.053868] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.054444] hub 2-0:1.0: usb_probe_interface
[    4.054447] hub 2-0:1.0: usb_probe_interface - got id
[    4.054452] hub 2-0:1.0: USB hub found
[    4.054596] hub 2-0:1.0: 2 ports detected
[    4.054661] hub 2-0:1.0: standalone hub
[    4.054663] hub 2-0:1.0: no power switching (usb 1.0)
[    4.054665] hub 2-0:1.0: individual port over-current protection
[    4.054669] hub 2-0:1.0: power on to power good time: 2ms
[    4.054763] hub 2-0:1.0: local power source is good
[    4.054781] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    4.056672] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    4.056741] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    4.056813] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.056889] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.056894] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.056994] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    4.072162] uhci_hcd 0000:00:1a.2: detected 2 ports
[    4.072217] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.072220] uhci_hcd 0000:00:1a.2: Performing full reset
[    4.072237] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    4.072387] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    4.072720] usb usb3: default language 0x0409
[    4.072860] usb usb3: udev 1, busnum 3, minor = 256
[    4.072863] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.072914] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.072976] usb usb3: Product: UHCI Host Controller
[    4.073024] usb usb3: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.073074] usb usb3: SerialNumber: 0000:00:1a.2
[    4.073797] usb usb3: usb_probe_device
[    4.073801] usb usb3: configuration #1 chosen from 1 choice
[    4.073876] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    4.074345] hub 3-0:1.0: usb_probe_interface
[    4.074348] hub 3-0:1.0: usb_probe_interface - got id
[    4.074353] hub 3-0:1.0: USB hub found
[    4.074493] hub 3-0:1.0: 2 ports detected
[    4.074563] hub 3-0:1.0: standalone hub
[    4.074565] hub 3-0:1.0: no power switching (usb 1.0)
[    4.074567] hub 3-0:1.0: individual port over-current protection
[    4.074570] hub 3-0:1.0: power on to power good time: 2ms
[    4.074651] hub 3-0:1.0: local power source is good
[    4.074666] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    4.076327] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.076395] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.076451] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.076526] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.076531] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.076626] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    4.088071] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.088137] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.088140] uhci_hcd 0000:00:1d.0: Performing full reset
[    4.088156] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    4.088292] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    4.088621] usb usb4: default language 0x0409
[    4.088759] usb usb4: udev 1, busnum 4, minor = 384
[    4.088762] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.088814] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.088875] usb usb4: Product: UHCI Host Controller
[    4.088923] usb usb4: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.088973] usb usb4: SerialNumber: 0000:00:1d.0
[    4.089691] usb usb4: usb_probe_device
[    4.089694] usb usb4: configuration #1 chosen from 1 choice
[    4.089769] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.090235] hub 4-0:1.0: usb_probe_interface
[    4.090238] hub 4-0:1.0: usb_probe_interface - got id
[    4.090242] hub 4-0:1.0: USB hub found
[    4.090383] hub 4-0:1.0: 2 ports detected
[    4.090452] hub 4-0:1.0: standalone hub
[    4.090454] hub 4-0:1.0: no power switching (usb 1.0)
[    4.090456] hub 4-0:1.0: individual port over-current protection
[    4.090459] hub 4-0:1.0: power on to power good time: 2ms
[    4.090540] hub 4-0:1.0: local power source is good
[    4.090556] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    4.092184] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.092260] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.092265] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.092362] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    4.108100] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.108153] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.108156] uhci_hcd 0000:00:1d.1: Performing full reset
[    4.108328] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    4.108656] usb usb5: default language 0x0409
[    4.108793] usb usb5: udev 1, busnum 5, minor = 512
[    4.108795] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.108847] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.108909] usb usb5: Product: UHCI Host Controller
[    4.108957] usb usb5: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.109007] usb usb5: SerialNumber: 0000:00:1d.1
[    4.109734] usb usb5: usb_probe_device
[    4.109737] usb usb5: configuration #1 chosen from 1 choice
[    4.109814] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    4.110382] hub 5-0:1.0: usb_probe_interface
[    4.110385] hub 5-0:1.0: usb_probe_interface - got id
[    4.110389] hub 5-0:1.0: USB hub found
[    4.110532] hub 5-0:1.0: 2 ports detected
[    4.110596] hub 5-0:1.0: standalone hub
[    4.110599] hub 5-0:1.0: no power switching (usb 1.0)
[    4.110601] hub 5-0:1.0: individual port over-current protection
[    4.110604] hub 5-0:1.0: power on to power good time: 2ms
[    4.110698] hub 5-0:1.0: local power source is good
[    4.110715] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    4.112411] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.112487] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.112492] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.112590] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    4.128208] uhci_hcd 0000:00:1a.0: port 1 portsc 01a3,00
[    4.128220] hub 1-0:1.0: port 1: status 0301 change 0001
[    4.128233] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.128296] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.128299] uhci_hcd 0000:00:1d.2: Performing full reset
[    4.128355] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    4.128697] usb usb6: default language 0x0409
[    4.128836] usb usb6: udev 1, busnum 6, minor = 640
[    4.128839] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.128891] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.128952] usb usb6: Product: UHCI Host Controller
[    4.129001] usb usb6: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.129051] usb usb6: SerialNumber: 0000:00:1d.2
[    4.129771] usb usb6: usb_probe_device
[    4.129775] usb usb6: configuration #1 chosen from 1 choice
[    4.129850] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    4.130320] hub 6-0:1.0: usb_probe_interface
[    4.130323] hub 6-0:1.0: usb_probe_interface - got id
[    4.130327] hub 6-0:1.0: USB hub found
[    4.130469] hub 6-0:1.0: 2 ports detected
[    4.130538] hub 6-0:1.0: standalone hub
[    4.130540] hub 6-0:1.0: no power switching (usb 1.0)
[    4.130542] hub 6-0:1.0: individual port over-current protection
[    4.130545] hub 6-0:1.0: power on to power good time: 2ms
[    4.130627] hub 6-0:1.0: local power source is good
[    4.130642] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    4.132311] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.132382] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.132440] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    4.132570] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.132575] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.132677] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 7
[    4.148223] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.148229] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.148380] ehci_hcd 0000:00:1a.7: debug port 1
[    4.148432] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.152406] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    4.152418] hub 2-0:1.0: port 1: status 0101 change 0001
[    4.152468] uhci_hcd 0000:00:1a.1: port 2 portsc 0093,00
[    4.152479] hub 2-0:1.0: port 2: status 0101 change 0001
[    4.152523] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    4.152526] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    4.152683] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    4.152736] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.156607] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.168103] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.168495] usb usb7: default language 0x0409
[    4.168631] usb usb7: udev 1, busnum 7, minor = 768
[    4.168634] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    4.168686] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.168747] usb usb7: Product: EHCI Host Controller
[    4.168796] usb usb7: Manufacturer: Linux 2.6.38-rc8+ ehci_hcd
[    4.168846] usb usb7: SerialNumber: 0000:00:1a.7
[    4.169557] usb usb7: usb_probe_device
[    4.169561] usb usb7: configuration #1 chosen from 1 choice
[    4.169636] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    4.170095] hub 7-0:1.0: usb_probe_interface
[    4.170098] hub 7-0:1.0: usb_probe_interface - got id
[    4.170102] hub 7-0:1.0: USB hub found
[    4.170257] hub 7-0:1.0: 6 ports detected
[    4.170323] hub 7-0:1.0: standalone hub
[    4.170325] hub 7-0:1.0: no power switching (usb 1.0)
[    4.170327] hub 7-0:1.0: individual port over-current protection
[    4.170330] hub 7-0:1.0: power on to power good time: 20ms
[    4.170410] hub 7-0:1.0: local power source is good
[    4.170424] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    4.171881] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    4.171894] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    4.171907] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    4.172117] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.172229] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.172305] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.172375] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.172481] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.172486] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.172577] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    4.188122] uhci_hcd 0000:00:1d.0: port 1 portsc 01a3,00
[    4.188133] hub 4-0:1.0: port 1: status 0301 change 0001
[    4.188196] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.188202] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.188368] ehci_hcd 0000:00:1d.7: debug port 1
[    4.188419] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.192318] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.192321] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.192452] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    4.192505] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.196403] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.208089] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.208105] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.208476] usb usb8: default language 0x0409
[    4.208632] usb usb8: udev 1, busnum 8, minor = 896
[    4.208635] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[    4.208688] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.208750] usb usb8: Product: EHCI Host Controller
[    4.208799] usb usb8: Manufacturer: Linux 2.6.38-rc8+ ehci_hcd
[    4.208850] usb usb8: SerialNumber: 0000:00:1d.7
[    4.209630] usb usb8: usb_probe_device
[    4.209634] usb usb8: configuration #1 chosen from 1 choice
[    4.209708] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    4.210188] hub 8-0:1.0: usb_probe_interface
[    4.210191] hub 8-0:1.0: usb_probe_interface - got id
[    4.210195] hub 8-0:1.0: USB hub found
[    4.210350] hub 8-0:1.0: 6 ports detected
[    4.210412] hub 8-0:1.0: standalone hub
[    4.210414] hub 8-0:1.0: no power switching (usb 1.0)
[    4.210417] hub 8-0:1.0: individual port over-current protection
[    4.210420] hub 8-0:1.0: power on to power good time: 20ms
[    4.210510] hub 8-0:1.0: local power source is good
[    4.210528] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    4.212282] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    4.212297] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    4.212311] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    4.216024] Monitor-Mwait will be used to enter C-3 state
[    4.228170] hub 1-0:1.0: state 7 ports 2 chg 0002 evt 0000
[    4.228198] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[    4.228233] hub 1-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
[    4.268128] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001403 0  ACK POWER sig=k CSC CONNECT
[    4.268142] hub 7-0:1.0: port 1: status 0501 change 0001
[    4.268224] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.268236] hub 7-0:1.0: port 3: status 0501 change 0001
[    4.268286] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.268295] hub 7-0:1.0: port 4: status 0501 change 0001
[    4.308151] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001403 0  ACK POWER sig=k CSC CONNECT
[    4.308164] hub 8-0:1.0: port 1: status 0501 change 0001
[    4.356162] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
[    4.356174] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.356182] hub 2-0:1.0: state 7 ports 2 chg 0006 evt 0006
[    4.356209] uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
[    4.356248] hub 2-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
[    4.484161] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
[    4.484187] uhci_hcd 0000:00:1a.1: port 2 portsc 0082,00
[    4.484225] hub 2-0:1.0: port 2, status 0100, change 0001, 12 Mb/s
[    4.612161] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
[    4.612166] hub 4-0:1.0: state 7 ports 2 chg 0002 evt 0002
[    4.612193] uhci_hcd 0000:00:1d.0: port 1 portsc 0082,00
[    4.612231] hub 4-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
[    4.740162] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
[    4.740172] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.740180] hub 7-0:1.0: state 7 ports 6 chg 001a evt 0000
[    4.740212] hub 7-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    4.740288] ehci_hcd 0000:00:1a.7: port 1 low speed --> companion
[    4.796098] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.796219] hub 7-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    4.852258] ehci_hcd 0000:00:1a.7: port 3 full speed --> companion
[    4.852263] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    4.852273] hub 7-0:1.0: port 3 not reset yet, waiting 50ms
[    4.908122] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.908238] hub 7-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    4.964384] ehci_hcd 0000:00:1a.7: port 4 full speed --> companion
[    4.964388] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    4.964398] hub 7-0:1.0: port 4 not reset yet, waiting 50ms
[    5.020121] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    5.020215] hub 8-0:1.0: state 7 ports 6 chg 0002 evt 0000
[    5.020243] hub 8-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    5.020280] ehci_hcd 0000:00:1d.7: port 1 low speed --> companion
[    5.076120] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    5.076214] hub 7-0:1.0: state 7 ports 6 chg 0000 evt 0010
[    5.076253] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    5.076278] uhci_hcd 0000:00:1a.0: port 1 portsc 01a3,00
[    5.076316] hub 1-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    5.112094] usb usb3: suspend_rh (auto-stop)
[    5.112120] usb usb5: suspend_rh (auto-stop)
[    5.204117] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    5.316123] usb 1-1: new low speed USB device using uhci_hcd and address 2
[    5.360066] usb usb6: suspend_rh (auto-stop)
[    5.470672] usb 1-1: skipped 1 descriptor after interface
[    5.475668] usb 1-1: default language 0x0409
[    5.491670] usb 1-1: udev 2, busnum 1, minor = 1
[    5.491673] usb 1-1: New USB device found, idVendor=046d, idProduct=c018
[    5.491725] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.491777] usb 1-1: Product: USB Optical Mouse
[    5.491825] usb 1-1: Manufacturer: Logitech
[    5.492623] usb 1-1: usb_probe_device
[    5.492627] usb 1-1: configuration #1 chosen from 1 choice
[    5.495678] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    5.497227] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0006
[    5.497252] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    5.497288] hub 2-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    5.507437] usbhid 1-1:1.0: usb_probe_interface
[    5.507441] usbhid 1-1:1.0: usb_probe_interface - got id
[    5.521694] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1:1.0/input/input5
[    5.523282] generic-usb 0003:046D:C018.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1a.0-1/input0
[    5.523471] usbcore: registered new interface driver usbhid
[    5.523522] usbhid: USB HID core driver
[    5.624089] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    5.736125] usb 2-1: new full speed USB device using uhci_hcd and address 2
[    5.868091] usb 2-1: ep0 maxpacket = 8
[    5.894584] usb 2-1: default language 0x0409
[    5.903600] usb 2-1: udev 2, busnum 2, minor = 129
[    5.903604] usb 2-1: New USB device found, idVendor=08ff, idProduct=2810
[    5.903657] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    5.903715] usb 2-1: Product: Fingerprint Sensor
[    5.904382] usb 2-1: usb_probe_device
[    5.904386] usb 2-1: configuration #1 chosen from 1 choice
[    5.905610] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    5.907709] uhci_hcd 0000:00:1a.1: port 2 portsc 0093,00
[    5.907744] hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    6.032102] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    6.144124] usb 2-2: new full speed USB device using uhci_hcd and address 3
[    6.296684] usb 2-2: skipped 1 descriptor after interface
[    6.299594] usb 2-2: default language 0x0409
[    6.310600] usb 2-2: udev 3, busnum 2, minor = 130
[    6.310604] usb 2-2: New USB device found, idVendor=0a5c, idProduct=2145
[    6.310657] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.310710] usb 2-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[    6.310767] usb 2-2: Manufacturer: Lenovo Computer Corp
[    6.311383] usb 2-2: usb_probe_device
[    6.311386] usb 2-2: configuration #1 chosen from 1 choice
[    6.312649] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[    6.314271] usb 2-2: adding 2-2:1.1 (config #1, interface 1)
[    6.315408] usb 2-2: adding 2-2:1.2 (config #1, interface 2)
[    6.316503] usb 2-2: adding 2-2:1.3 (config #1, interface 3)
[    6.317656] hub 8-0:1.0: state 7 ports 6 chg 0000 evt 0002
[    6.317700] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    6.317726] uhci_hcd 0000:00:1d.0: port 1 portsc 01a3,00
[    6.317764] hub 4-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    6.444119] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    6.556119] usb 4-1: new low speed USB device using uhci_hcd and address 2
[    6.713517] usb 4-1: skipped 1 descriptor after interface
[    6.713529] usb 4-1: skipped 1 descriptor after interface
[    6.718500] usb 4-1: default language 0x0409
[    6.735518] usb 4-1: udev 2, busnum 4, minor = 385
[    6.735521] usb 4-1: New USB device found, idVendor=046d, idProduct=c30a
[    6.735574] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.735627] usb 4-1: Product: Logitech USB Keyboard
[    6.735676] usb 4-1: Manufacturer: Logitech
[    6.736365] usb 4-1: usb_probe_device
[    6.736369] usb 4-1: configuration #1 chosen from 1 choice
[    6.739527] usb 4-1: adding 4-1:1.0 (config #1, interface 0)
[    6.739944] usbhid 4-1:1.0: usb_probe_interface
[    6.739947] usbhid 4-1:1.0: usb_probe_interface - got id
[    6.740886] usb 4-1: adding 4-1:1.1 (config #1, interface 1)
[    6.741268] usbhid 4-1:1.1: usb_probe_interface
[    6.741271] usbhid 4-1:1.1: usb_probe_interface - got id
[    6.743187] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    6.743233] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.743239] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    6.784728] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1:1.0/input/input6
[    6.784852] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    6.785875] logitech 0003:046D:C30A.0002: input,hidraw1: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:1d.0-1/input0
[    6.808118] hub 6-0:1.0: hub_suspend
[    6.808154] usb usb6: bus auto-suspend
[    6.808157] usb usb6: suspend_rh
[    6.824052] hub 3-0:1.0: hub_suspend
[    6.824061] usb usb3: bus auto-suspend
[    6.824064] usb usb3: suspend_rh
[    6.824085] hub 5-0:1.0: hub_suspend
[    6.824091] usb usb5: bus auto-suspend
[    6.824094] usb usb5: suspend_rh
[    6.824234] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1:1.1/input/input7
[    6.824347] uhci_hcd 0000:00:1d.0: reserve dev 2 ep82-INT, period 32, phase 16, 118 us
[    6.825812] logitech 0003:046D:C30A.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech Logitech USB Keyboard] on usb-0000:00:1d.0-1/input1
[    7.808084] hub 7-0:1.0: hub_suspend
[    7.808092] usb usb7: bus auto-suspend
[    7.808096] ehci_hcd 0000:00:1a.7: suspend root hub
[    8.808035] hub 8-0:1.0: hub_suspend
[    8.808043] usb usb8: bus auto-suspend
[    8.808046] ehci_hcd 0000:00:1d.7: suspend root hub
[    8.814688] EXT3-fs: barriers not enabled
[    8.815217] kjournald starting.  Commit interval 5 seconds
[    8.815411] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   13.963023] Adding 1871568k swap on /dev/sda2.  Priority:-1 extents:1 across:1871568k SS
[   13.985675] EXT3-fs (sda1): using internal journal
[   14.044968] udev[2723]: starting version 163
[   14.453105] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[   14.453491] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[   14.515056] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[   14.515591] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[   15.030453] cfg80211: Calling CRDA to update world regulatory domain
[   15.113800] cfg80211: World regulatory domain updated:
[   15.113805] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   15.113809] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.113812] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.113816] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.113819] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.113823] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.133763] [drm] Initialized drm 1.1.0 20060810
[   15.329639] i915 0000:00:02.0: power state changed by ACPI to D0
[   15.329663] i915 0000:00:02.0: power state changed by ACPI to D0
[   15.329673] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   15.329679] i915 0000:00:02.0: setting latency timer to 64
[   15.365990] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   15.365994] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   15.366183] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   15.366194] iwlagn 0000:03:00.0: setting latency timer to 64
[   15.366270] iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   15.412979] iwlagn 0000:03:00.0: device EEPROM VER=0x11f, CALIB=0x4
[   15.412984] iwlagn 0000:03:00.0: Device SKU: 0Xb
[   15.413027] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   15.413147] iwlagn 0000:03:00.0: irq 42 for MSI/MSI-X
[   15.441795] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-5.ucode' failed.
[   15.462948] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-4.ucode' failed.
[   15.477980] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-3.ucode' failed.
[   15.502355] iwlagn 0000:03:00.0: Firmware has old API version. Expected v5, got v2. New firmware can be obtained from http://www.intellinuxwireless.org.
[   15.502433] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[   15.566684] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   15.674909] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[   15.675024] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   15.675027] [drm] Driver supports precise vblank timestamp query.
[   15.865521] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   16.217865] fb0: inteldrmfb frame buffer device
[   16.217868] drm: registered panic notifier
[   16.356555] acpi device:02: registered as cooling_device2
[   16.361692] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input8
[   16.362599] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   16.364110] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   16.364247] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   16.364392] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[   16.364578] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   16.436750] Console: switching to colour frame buffer device 180x56
[   16.831668] sshd (3155): /proc/3155/oom_adj is deprecated, please use /proc/3155/oom_score_adj instead.
[   17.184414] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   17.240272] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   17.241395] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   17.573382] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   17.984113] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 99 us
[   18.920887] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[   18.920893] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   18.921436] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   29.796055] eth0: no IPv6 routers present
[   77.496947] kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[   99.023707] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   99.024074] wlan0: Trigger new scan to find an IBSS to join
[  101.615390] wlan0: Selected IBSS BSSID 2e:25:b3:96:d5:f9 based on configured SSID
[  101.631736] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[  101.633246] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[  109.064041] wlan0: no IPv6 routers present
[  112.060801] iwlagn 0000:03:00.0: PCI INT A disabled
[  191.990285] irq 23: nobody cared (try booting with the "irqpoll" option)
[  191.990291] Pid: 0, comm: swapper Not tainted 2.6.38-rc8+ #776
[  191.990294] Call Trace:
[  191.990296]  <IRQ>  [<ffffffff81099d36>] ? __report_bad_irq+0x26/0xa0
[  191.990306]  [<ffffffff81099f3c>] ? note_interrupt+0x18c/0x1d0
[  191.990311]  [<ffffffff8109a8bd>] ? handle_fasteoi_irq+0xcd/0x100
[  191.990316]  [<ffffffff8100543d>] ? handle_irq+0x1d/0x30
[  191.990320]  [<ffffffff81004bb8>] ? do_IRQ+0x58/0xd0
[  191.990325]  [<ffffffff814a0e93>] ? ret_from_intr+0x0/0xe
[  191.990327]  <EOI>  [<ffffffff8100a5a7>] ? native_sched_clock+0x27/0x80
[  191.990337]  [<ffffffff8127004e>] ? acpi_idle_enter_simple+0xbe/0xf0
[  191.990341]  [<ffffffff81270049>] ? acpi_idle_enter_simple+0xb9/0xf0
[  191.990346]  [<ffffffff8138bc82>] ? cpuidle_idle_call+0x82/0xf0
[  191.990351]  [<ffffffff810018d6>] ? cpu_idle+0x56/0xb0
[  191.990355]  [<ffffffff8148bd0b>] ? rest_init+0xcb/0xe0
[  191.990359]  [<ffffffff8148bc40>] ? rest_init+0x0/0xe0
[  191.990364]  [<ffffffff81895d6f>] ? start_kernel+0x38a/0x395
[  191.990369]  [<ffffffff81895321>] ? x86_64_start_reservations+0x131/0x135
[  191.990374]  [<ffffffff81895417>] ? x86_64_start_kernel+0xf2/0xf9
[  191.990376] handlers:
[  191.990378] [<ffffffffa0006dc0>] (usb_hcd_irq+0x0/0x70 [usbcore])
[  191.990394] Disabling IRQ #23

--UugvWAfsgieZRqgk--
