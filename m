Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab1CNX4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 19:56:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:4851 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab1CNX4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 19:56:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,319,1297065600"; 
   d="txt'?scan'208";a="612939485"
Date: Mon, 14 Mar 2011 16:56:34 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
Subject: Re: [PATCH 0/2] Re: 2.6.38 regression caused by commit 415e12b
Message-ID: <20110314235634.GC4145@xanatos>
References: <20110228014218.GA11083@xanatos>
 <201103022330.49297.rjw@sisk.pl>
 <20110304175210.GA3798@xanatos>
 <201103042132.35711.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hOcCNbCCxyk/YU74"
Content-Disposition: inline
In-Reply-To: <201103042132.35711.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hOcCNbCCxyk/YU74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 04, 2011 at 09:32:35PM +0100, Rafael J. Wysocki wrote:
> I don't understand why pci_no_msi_support() is called on your system even
> though pci=nomsi is not in the kernel command line.
> 
> Please apply this patch on top of the previous two and send me dmesg.

Ok, here's the dmesg with your two previous patches applied, plus the
patch below.  I don't see any stack trace though.

Sarah Sharp

> 
> ---
>  drivers/pci/msi.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6/drivers/pci/msi.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/msi.c
> +++ linux-2.6/drivers/pci/msi.c
> @@ -858,6 +858,8 @@ void pci_no_msi(void)
>  
>  void pci_no_msi_support(void)
>  {
> +	dump_stack();
> +
>  	msi_support_enabled = false;
>  	pci_no_msi();
>  }

--hOcCNbCCxyk/YU74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-rc8+ (sarah@xanatos) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #777 SMP PREEMPT Mon Mar 14 16:35:28 PDT 2011
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
[    0.000000] RAMDISK: 3600d000 - 37ff0000
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
[    0.000000] Memory: 3908248k/5177344k available (4768k kernel code, 1089568k absent, 179528k reserved, 3936k data, 524k init)
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
[    0.000000] Detected 1861.737 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 3723.47 BogoMIPS (lpj=7446948)
[    0.004097] pid_max: default: 32768 minimum: 301
[    0.004466] Mount-cache hash table entries: 256
[    0.005753] Initializing cgroup subsys ns
[    0.005801] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.005870] Initializing cgroup subsys cpuacct
[    0.005931] Initializing cgroup subsys memory
[    0.006081] Initializing cgroup subsys freezer
[    0.006296] CPU: Physical Processor ID: 0
[    0.006343] CPU: Processor Core ID: 0
[    0.006390] using mwait in idle threads.
[    0.006488] ACPI: Core revision 20110112
[    0.156287] Setting APIC routing to flat
[    0.156802] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.197629] CPU0: Intel(R) Core(TM)2 Duo CPU     L9400  @ 1.86GHz stepping 0a
[    0.200011] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.200011] ... version:                2
[    0.200011] ... bit width:              40
[    0.200011] ... generic registers:      2
[    0.200011] ... value mask:             000000ffffffffff
[    0.200011] ... max period:             000000007fffffff
[    0.200011] ... fixed-purpose events:   3
[    0.200011] ... event mask:             0000000700000003
[    0.208159] NMI watchdog enabled, takes one hw-pmu counter.
[    0.220029] lockdep: fixing up alternatives.
[    0.224110] Booting Node   0, Processors  #1 Ok.
[    0.316092] NMI watchdog enabled, takes one hw-pmu counter.
[    0.320030] Brought up 2 CPUs
[    0.320079] Total of 2 processors activated (7447.36 BogoMIPS).
[    0.324885] NET: Registered protocol family 16
[    0.327183] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.327253] ACPI: bus type pci registered
[    0.327941] PCI: Using configuration type 1 for base access
[    0.341314] bio: create slab <bio-0> at 0
[    0.350333] ACPI: EC: EC description table is found, configuring boot EC
[    0.480754] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.526381] ACPI: SSDT 00000000bd8d7c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.529295] ACPI: Dynamic OEM Table Load:
[    0.529408] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.533333] ACPI: SSDT 00000000bd8d5020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.538540] ACPI: Dynamic OEM Table Load:
[    0.538654] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.573285] ACPI: SSDT 00000000bd8d6ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.577298] ACPI: Dynamic OEM Table Load:
[    0.577410] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.595637] ACPI: SSDT 00000000bd8d6f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.598273] ACPI: Dynamic OEM Table Load:
[    0.598385] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.618603] ACPI: Interpreter enabled
[    0.618654] ACPI: (supports S0 S3 S4 S5)
[    0.619216] ACPI: Using IOAPIC for interrupt routing
[    0.697099] ACPI: Power Resource [PUBS] (on)
[    0.759704] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.793557] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.793610] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.800590] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.801433] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.801486] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.801539] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.801602] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.801665] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.801729] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.801875] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.801967] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    0.801988] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.802001] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.802011] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.802077] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    0.802094] pci 0000:00:02.1: reg 10: [mem 0xf2400000-0xf24fffff 64bit]
[    0.802188] pci 0000:00:03.0: [8086:2a44] type 0 class 0x000780
[    0.802212] pci 0000:00:03.0: reg 10: [mem 0xf2826800-0xf282680f 64bit]
[    0.802277] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.802282] pci 0000:00:03.0: PME# disabled
[    0.802326] pci 0000:00:03.2: [8086:2a46] type 0 class 0x000101
[    0.802347] pci 0000:00:03.2: reg 10: [io  0x1828-0x182f]
[    0.802358] pci 0000:00:03.2: reg 14: [io  0x180c-0x180f]
[    0.802368] pci 0000:00:03.2: reg 18: [io  0x1820-0x1827]
[    0.802379] pci 0000:00:03.2: reg 1c: [io  0x1808-0x180b]
[    0.802390] pci 0000:00:03.2: reg 20: [io  0x1810-0x181f]
[    0.802469] pci 0000:00:03.3: [8086:2a47] type 0 class 0x000700
[    0.802490] pci 0000:00:03.3: reg 10: [io  0x1830-0x1837]
[    0.802501] pci 0000:00:03.3: reg 14: [mem 0xf2624000-0xf2624fff]
[    0.802661] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    0.802694] pci 0000:00:19.0: reg 10: [mem 0xf2600000-0xf261ffff]
[    0.802709] pci 0000:00:19.0: reg 14: [mem 0xf2625000-0xf2625fff]
[    0.802725] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.802816] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.802823] pci 0000:00:19.0: PME# disabled
[    0.802871] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.802945] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.803038] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.803113] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.803205] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    0.803280] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    0.803387] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.803421] pci 0000:00:1a.7: reg 10: [mem 0xf2826c00-0xf2826fff]
[    0.803537] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.803545] pci 0000:00:1a.7: PME# disabled
[    0.803600] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.803627] pci 0000:00:1b.0: reg 10: [mem 0xf2620000-0xf2623fff 64bit]
[    0.803737] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.803744] pci 0000:00:1b.0: PME# disabled
[    0.803794] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.803907] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.803913] pci 0000:00:1c.0: PME# disabled
[    0.803965] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    0.804205] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.804212] pci 0000:00:1c.1: PME# disabled
[    0.804267] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.804380] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.804387] pci 0000:00:1c.3: PME# disabled
[    0.804448] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.804522] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    0.804615] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.804690] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    0.804782] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.804857] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    0.804965] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.804998] pci 0000:00:1d.7: reg 10: [mem 0xf2827000-0xf28273ff]
[    0.805115] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.805122] pci 0000:00:1d.7: PME# disabled
[    0.805171] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.805294] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.805500] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.805536] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    0.805551] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    0.805567] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    0.805582] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    0.805597] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.805612] pci 0000:00:1f.2: reg 24: [mem 0xf2826000-0xf28267ff]
[    0.805678] pci 0000:00:1f.2: PME# supported from D3hot
[    0.805684] pci 0000:00:1f.2: PME# disabled
[    0.805730] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.805758] pci 0000:00:1f.3: reg 10: [mem 0xf2827400-0xf28274ff 64bit]
[    0.805797] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.805935] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.805989] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.805996] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.806007] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.806214] pci 0000:03:00.0: [8086:4237] type 0 class 0x000280
[    0.806290] pci 0000:03:00.0: reg 10: [mem 0xf2500000-0xf2501fff 64bit]
[    0.806545] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.806574] pci 0000:03:00.0: PME# disabled
[    0.806693] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.806747] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.806754] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.806764] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.806857] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.806911] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.806918] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.806928] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.807063] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d] (subtractive decode)
[    0.807119] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.807126] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.807136] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.807148] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.807160] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.807172] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.807184] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.807195] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.807208] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.807241] pci_bus 0000:00: on NUMA node 0
[    0.807265] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.813942] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.815373] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.816872] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    1.027024] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    1.029406] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    1.031656] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    1.033903] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    1.036259] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    1.038512] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    1.040770] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    1.043025] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    1.044411] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.044661] vgaarb: loaded
[    1.046123] SCSI subsystem initialized
[    1.046199] libata version 3.00 loaded.
[    1.046199] PCI: Using ACPI for IRQ routing
[    1.046199] PCI: pci_cache_line_size set to 64 bytes
[    1.046199] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    1.046199] reserve RAM buffer: 00000000bd6a1000 - 00000000bfffffff 
[    1.046199] reserve RAM buffer: 00000000bd7b7000 - 00000000bfffffff 
[    1.046199] reserve RAM buffer: 00000000bd8c7000 - 00000000bfffffff 
[    1.048135] reserve RAM buffer: 00000000bdc00000 - 00000000bfffffff 
[    1.049313] Bluetooth: Core ver 2.15
[    1.049460] NET: Registered protocol family 31
[    1.049509] Bluetooth: HCI device and connection manager initialized
[    1.049574] Bluetooth: HCI socket layer initialized
[    1.049964] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.052274] Switching to clocksource hpet
[    1.052395] pnp: PnP ACPI init
[    1.052600] ACPI: bus type pnp registered
[    1.055523] Switched to NOHz mode on CPU #0
[    1.055647] Switched to NOHz mode on CPU #1
[    1.085978] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    1.085989] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    1.085999] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    1.086008] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    1.086017] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    1.086027] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    1.086037] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    1.086046] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    1.086055] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    1.086065] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    1.086075] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    1.086084] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    1.086094] pnp 00:00: [mem 0x000ec000-0x000effff]
[    1.086103] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    1.086113] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    1.086123] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    1.086133] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    1.086839] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.086912] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    1.086983] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    1.087054] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    1.087125] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    1.087195] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    1.087272] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    1.087349] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    1.087425] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    1.087501] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    1.087578] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    1.087654] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    1.087730] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    1.087807] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    1.087883] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    1.087939] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.088155] pnp 00:01: [bus 00-ff]
[    1.088165] pnp 00:01: [io  0x0cf8-0x0cff]
[    1.088175] pnp 00:01: [io  0x0000-0x0cf7 window]
[    1.088184] pnp 00:01: [io  0x0d00-0xffff window]
[    1.088195] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    1.088204] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    1.088214] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    1.088225] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    1.088235] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    1.088245] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    1.088254] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    1.088264] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    1.088273] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    1.088283] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    1.088292] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    1.088302] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    1.088312] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    1.088322] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
[    1.088332] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    1.088704] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.110893] pnp 00:02: [io  0x0010-0x001f]
[    1.110903] pnp 00:02: [io  0x0090-0x009f]
[    1.110913] pnp 00:02: [io  0x0024-0x0025]
[    1.110923] pnp 00:02: [io  0x0028-0x0029]
[    1.110932] pnp 00:02: [io  0x002c-0x002d]
[    1.110942] pnp 00:02: [io  0x0030-0x0031]
[    1.110951] pnp 00:02: [io  0x0034-0x0035]
[    1.110961] pnp 00:02: [io  0x0038-0x0039]
[    1.110970] pnp 00:02: [io  0x003c-0x003d]
[    1.110980] pnp 00:02: [io  0x00a4-0x00a5]
[    1.110989] pnp 00:02: [io  0x00a8-0x00a9]
[    1.110999] pnp 00:02: [io  0x00ac-0x00ad]
[    1.111008] pnp 00:02: [io  0x00b0-0x00b5]
[    1.111018] pnp 00:02: [io  0x00b8-0x00b9]
[    1.111027] pnp 00:02: [io  0x00bc-0x00bd]
[    1.111036] pnp 00:02: [io  0x0050-0x0053]
[    1.111046] pnp 00:02: [io  0x0072-0x0077]
[    1.111055] pnp 00:02: [io  0x002e-0x002f]
[    1.111065] pnp 00:02: [io  0x1000-0x107f]
[    1.111075] pnp 00:02: [io  0x1180-0x11ff]
[    1.111084] pnp 00:02: [io  0x0800-0x080f]
[    1.111093] pnp 00:02: [io  0x15e0-0x15ef]
[    1.111103] pnp 00:02: [io  0x1600-0x167f]
[    1.111112] pnp 00:02: [io  0x1680-0x169f]
[    1.111122] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    1.111132] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    1.111142] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    1.111151] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    1.111161] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    1.111170] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    1.111905] system 00:02: [io  0x1000-0x107f] has been reserved
[    1.111977] system 00:02: [io  0x1180-0x11ff] has been reserved
[    1.112059] system 00:02: [io  0x0800-0x080f] has been reserved
[    1.112130] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    1.112200] system 00:02: [io  0x1600-0x167f] has been reserved
[    1.112270] system 00:02: [io  0x1680-0x169f] has been reserved
[    1.112341] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    1.112413] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.112484] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    1.112555] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.112627] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.112699] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    1.112754] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.113380] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.113742] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.113875] pnp 00:04: [io  0x0000-0x000f]
[    1.113885] pnp 00:04: [io  0x0080-0x008f]
[    1.113894] pnp 00:04: [io  0x00c0-0x00df]
[    1.113904] pnp 00:04: [dma 4]
[    1.114264] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.114396] pnp 00:05: [io  0x0061]
[    1.114759] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.114890] pnp 00:06: [io  0x00f0]
[    1.114908] pnp 00:06: [irq 13]
[    1.115270] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.115403] pnp 00:07: [io  0x0070-0x0071]
[    1.115419] pnp 00:07: [irq 8]
[    1.115784] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.115916] pnp 00:08: [io  0x0060]
[    1.115925] pnp 00:08: [io  0x0064]
[    1.115940] pnp 00:08: [irq 1]
[    1.116317] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.116454] pnp 00:09: [irq 12]
[    1.116830] pnp 00:09: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    1.138728] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    1.139093] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
[    1.143061] pnp: PnP ACPI: found 11 devices
[    1.143111] ACPI: ACPI bus type pnp unregistered
[    1.171014] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc01fffff]
[    1.171073] pci 0000:00:1c.0: BAR 9: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.171143] pci 0000:00:1c.1: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.171211] pci 0000:00:1c.0: BAR 7: assigned [io  0x3000-0x3fff]
[    1.171267] pci 0000:00:1c.1: BAR 7: assigned [io  0x4000-0x4fff]
[    1.171322] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.171374] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    1.171431] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    1.171487] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.171558] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.171610] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    1.171666] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    1.171722] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.171793] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    1.171845] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.171901] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    1.171957] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.172039] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
[    1.172089] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.172145] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.172199] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.172278] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.172335] pci 0000:00:1c.0: setting latency timer to 64
[    1.172356] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.172412] pci 0000:00:1c.1: setting latency timer to 64
[    1.172433] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.172489] pci 0000:00:1c.3: setting latency timer to 64
[    1.172499] pci 0000:00:1e.0: setting latency timer to 64
[    1.172505] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.172508] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.172511] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.172514] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.172517] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.172520] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.172524] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    1.172527] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    1.172530] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    1.172533] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    1.172536] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
[    1.172539] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    1.172542] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    1.172545] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    1.172548] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.172552] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
[    1.172555] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
[    1.172557] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
[    1.172560] pci_bus 0000:0d: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.172563] pci_bus 0000:0d: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.172567] pci_bus 0000:0d: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.172702] NET: Registered protocol family 2
[    1.173005] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.174541] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.176264] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    1.179695] TCP: Hash tables configured (established 262144 bind 65536)
[    1.179783] TCP reno registered
[    1.179854] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    1.180167] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    1.180889] NET: Registered protocol family 1
[    1.181006] pci 0000:00:02.0: Boot video device
[    1.181078] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.181081] pci 0000:00:1a.0: Performing full reset
[    1.181113] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.181116] pci 0000:00:1a.1: Performing full reset
[    1.181146] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.181149] pci 0000:00:1a.2: Performing full reset
[    1.181306] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.181309] pci 0000:00:1d.0: Performing full reset
[    1.181339] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.181342] pci 0000:00:1d.1: Performing full reset
[    1.181373] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.181375] pci 0000:00:1d.2: Performing full reset
[    1.181517] PCI: CLS 64 bytes, default 64
[    1.181892] Trying to unpack rootfs image as initramfs...
[    2.101327] Freeing initrd memory: 32652k freed
[    2.259448] DMA-API: preallocated 32768 debug entries
[    2.259505] DMA-API: debugging enabled by kernel config
[    2.259564] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.259617] Placing 64MB software IO TLB between ffff8800b8c9d000 - ffff8800bcc9d000
[    2.259681] software IO TLB at phys 0xb8c9d000 - 0xbcc9d000
[    2.259912] Simple Boot Flag at 0x35 set to 0x1
[    2.261413] Scanning for low memory corruption every 60 seconds
[    2.262283] audit: initializing netlink socket (disabled)
[    2.262412] type=2000 audit(1300146364.256:1): initialized
[    2.279525] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.304822] fuse init (API version 7.16)
[    2.305788] msgmni has been set to 7697
[    2.307068] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.307139] io scheduler noop registered
[    2.307188] io scheduler deadline registered
[    2.307556] io scheduler cfq registered (default)
[    2.309127] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.309543] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.310363] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.311564] ACPI: AC Adapter [AC] (on-line)
[    2.313092] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    2.348029] ACPI: Lid Switch [LID]
[    2.348741] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    2.412021] ACPI: Sleep Button [SLPB]
[    2.412745] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    2.412821] ACPI: Power Button [PWRF]
[    2.413053] ACPI: acpi_idle registered with cpuidle
[    2.531388] Monitor-Mwait will be used to enter C-1 state
[    2.531467] Monitor-Mwait will be used to enter C-2 state
[    2.531542] Monitor-Mwait will be used to enter C-3 state
[    2.531554] Marking TSC unstable due to TSC halts in idle
[    2.628609] thermal LNXTHERM:00: registered as thermal_zone0
[    2.628661] ACPI: Thermal Zone [THM0] (60 C)
[    2.638091] thermal LNXTHERM:01: registered as thermal_zone1
[    2.638143] ACPI: Thermal Zone [THM1] (63 C)
[    2.638735] Linux agpgart interface v0.103
[    2.655586] brd: module loaded
[    2.663776] loop: module loaded
[    2.665239] ahci 0000:00:1f.2: version 3.0
[    2.665293] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.665510] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
[    2.665623] ahci: SSS flag set, parallel bus scan disabled
[    2.665775] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    2.665901] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    2.666056] ahci 0000:00:1f.2: setting latency timer to 64
[    2.676336] scsi0 : ahci
[    2.680054] scsi1 : ahci
[    2.681205] scsi2 : ahci
[    2.682394] scsi3 : ahci
[    2.689441] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.689597] ACPI: Battery Slot [BAT0] (battery present)
[    2.693713] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 40
[    2.693778] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 40
[    2.693841] ata3: DUMMY
[    2.693887] ata4: DUMMY
[    2.694410] ata_generic 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.694594] ata_generic 0000:00:03.2: setting latency timer to 64
[    2.700769] scsi4 : ata_generic
[    2.701812] scsi5 : ata_generic
[    2.702726] ata5: PATA max UDMA/100 cmd 0x1828 ctl 0x180c bmdma 0x1810 irq 18
[    2.702780] ata6: PATA max UDMA/100 cmd 0x1820 ctl 0x1808 bmdma 0x1818 irq 18
[    2.703064] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-k2
[    2.703117] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    2.703246] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.703322] e1000e 0000:00:19.0: setting latency timer to 64
[    2.703592] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    3.012031] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.015447] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.015452] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.015517] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.015818] ata1.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102M3, max UDMA/133
[    3.015872] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.019418] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.019423] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.019431] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:1d:fb:eb
[    3.019435] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.019462] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[    3.019622] PPP generic driver version 2.4.2
[    3.019708] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.020021] ata1.00: configured for UDMA/133
[    3.020447] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.030792] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.031229] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.032224] mousedev: PS/2 mouse device common for all mice
[    3.033683] rtc_cmos 00:07: RTC can wake from S4
[    3.036868] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
[    3.039384] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    3.039784] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.039951] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    3.041240] sd 0:0:0:0: [sda] Write Protect is off
[    3.041291] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.041556] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.044860]  sda: sda1 sda2
[    3.047670] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.048636] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    3.048766] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.048882] Linux video capture interface: v2.00
[    3.049399] device-mapper: uevent: version 1.0.3
[    3.050080] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    3.050330] device-mapper: multipath: version 1.2.0 loaded
[    3.050397] device-mapper: multipath round-robin: version 1.0.0 loaded
[    3.052052] cpuidle: using governor ladder
[    3.053582] cpuidle: using governor menu
[    3.054548] TCP cubic registered
[    3.055768] NET: Registered protocol family 10
[    3.058166] NET: Registered protocol family 17
[    3.058400] Bluetooth: L2CAP ver 2.15
[    3.058449] Bluetooth: L2CAP socket layer initialized
[    3.058515] Bluetooth: SCO (Voice Link) ver 0.6
[    3.058564] Bluetooth: SCO socket layer initialized
[    3.058793] Bluetooth: RFCOMM TTY layer initialized
[    3.058860] Bluetooth: RFCOMM socket layer initialized
[    3.058910] Bluetooth: RFCOMM ver 1.11
[    3.058957] Registering the dns_resolver key type
[    3.059976] registered taskstats version 1
[    3.060199] kmemleak: Kernel memory leak detector initialized
[    3.060224] kmemleak: Automatic memory scanning thread started
[    3.061460] rtc_cmos 00:07: setting system clock to 2011-03-14 23:46:05 UTC (1300146365)
[    3.061526] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.061576] EDD information not available.
[    3.360084] ata2: SATA link down (SStatus 0 SControl 300)
[    3.528132] Freeing unused kernel memory: 524k freed
[    3.528393] Write protecting the kernel read-only data: 8192k
[    3.533643] Freeing unused kernel memory: 1356k freed
[    3.534403] Freeing unused kernel memory: 16k freed
[    3.556175] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    3.575840] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
[    4.013673] usbcore: registered new interface driver usbfs
[    4.018813] usbcore: registered new interface driver hub
[    4.019076] usbcore: registered new device driver usb
[    4.022149] uhci_hcd: USB Universal Host Controller Interface driver
[    4.022938] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.023008] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    4.023067] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.023148] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.023153] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.023288] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.027250] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.027304] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    4.027370] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    4.036128] uhci_hcd 0000:00:1a.0: detected 2 ports
[    4.036183] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.036186] uhci_hcd 0000:00:1a.0: Performing full reset
[    4.036203] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    4.036363] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    4.036799] usb usb1: default language 0x0409
[    4.036936] usb usb1: udev 1, busnum 1, minor = 0
[    4.036939] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.036991] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.037053] usb usb1: Product: UHCI Host Controller
[    4.037101] usb usb1: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.037151] usb usb1: SerialNumber: 0000:00:1a.0
[    4.037895] usb usb1: usb_probe_device
[    4.037899] usb usb1: configuration #1 chosen from 1 choice
[    4.038013] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.038503] hub 1-0:1.0: usb_probe_interface
[    4.038506] hub 1-0:1.0: usb_probe_interface - got id
[    4.038510] hub 1-0:1.0: USB hub found
[    4.038651] hub 1-0:1.0: 2 ports detected
[    4.038718] hub 1-0:1.0: standalone hub
[    4.038720] hub 1-0:1.0: no power switching (usb 1.0)
[    4.038723] hub 1-0:1.0: individual port over-current protection
[    4.038725] hub 1-0:1.0: power on to power good time: 2ms
[    4.038827] hub 1-0:1.0: local power source is good
[    4.038842] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.040524] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.040601] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.040606] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.040704] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    4.056116] uhci_hcd 0000:00:1a.1: detected 2 ports
[    4.056170] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.056173] uhci_hcd 0000:00:1a.1: Performing full reset
[    4.056345] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    4.056673] usb usb2: default language 0x0409
[    4.056812] usb usb2: udev 1, busnum 2, minor = 128
[    4.056815] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.056866] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.056928] usb usb2: Product: UHCI Host Controller
[    4.056976] usb usb2: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.057026] usb usb2: SerialNumber: 0000:00:1a.1
[    4.057752] usb usb2: usb_probe_device
[    4.057755] usb usb2: configuration #1 chosen from 1 choice
[    4.057830] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.058306] hub 2-0:1.0: usb_probe_interface
[    4.058310] hub 2-0:1.0: usb_probe_interface - got id
[    4.058314] hub 2-0:1.0: USB hub found
[    4.058454] hub 2-0:1.0: 2 ports detected
[    4.058523] hub 2-0:1.0: standalone hub
[    4.058525] hub 2-0:1.0: no power switching (usb 1.0)
[    4.058527] hub 2-0:1.0: individual port over-current protection
[    4.058530] hub 2-0:1.0: power on to power good time: 2ms
[    4.058609] hub 2-0:1.0: local power source is good
[    4.058624] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    4.060421] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    4.060488] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    4.060560] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.060634] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.060639] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.060736] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    4.072098] uhci_hcd 0000:00:1a.2: detected 2 ports
[    4.072157] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.072159] uhci_hcd 0000:00:1a.2: Performing full reset
[    4.072176] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    4.072312] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    4.072644] usb usb3: default language 0x0409
[    4.072781] usb usb3: udev 1, busnum 3, minor = 256
[    4.072784] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.072835] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.072897] usb usb3: Product: UHCI Host Controller
[    4.072945] usb usb3: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.072995] usb usb3: SerialNumber: 0000:00:1a.2
[    4.073711] usb usb3: usb_probe_device
[    4.073714] usb usb3: configuration #1 chosen from 1 choice
[    4.073789] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    4.074258] hub 3-0:1.0: usb_probe_interface
[    4.074261] hub 3-0:1.0: usb_probe_interface - got id
[    4.074265] hub 3-0:1.0: USB hub found
[    4.074407] hub 3-0:1.0: 2 ports detected
[    4.074476] hub 3-0:1.0: standalone hub
[    4.074478] hub 3-0:1.0: no power switching (usb 1.0)
[    4.074480] hub 3-0:1.0: individual port over-current protection
[    4.074483] hub 3-0:1.0: power on to power good time: 2ms
[    4.074564] hub 3-0:1.0: local power source is good
[    4.074579] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    4.076201] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.076269] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.076329] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.076400] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.076404] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.076495] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    4.092079] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.092140] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.092143] uhci_hcd 0000:00:1d.0: Performing full reset
[    4.092159] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    4.092319] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    4.092648] usb usb4: default language 0x0409
[    4.092785] usb usb4: udev 1, busnum 4, minor = 384
[    4.092787] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.092839] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.092901] usb usb4: Product: UHCI Host Controller
[    4.092949] usb usb4: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.092999] usb usb4: SerialNumber: 0000:00:1d.0
[    4.093722] usb usb4: usb_probe_device
[    4.093725] usb usb4: configuration #1 chosen from 1 choice
[    4.093801] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.094269] hub 4-0:1.0: usb_probe_interface
[    4.094272] hub 4-0:1.0: usb_probe_interface - got id
[    4.094276] hub 4-0:1.0: USB hub found
[    4.094417] hub 4-0:1.0: 2 ports detected
[    4.094486] hub 4-0:1.0: standalone hub
[    4.094488] hub 4-0:1.0: no power switching (usb 1.0)
[    4.094490] hub 4-0:1.0: individual port over-current protection
[    4.094493] hub 4-0:1.0: power on to power good time: 2ms
[    4.094575] hub 4-0:1.0: local power source is good
[    4.094590] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    4.096204] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.096282] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.096287] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.096383] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    4.108096] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.108154] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.108157] uhci_hcd 0000:00:1d.1: Performing full reset
[    4.108306] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    4.108632] usb usb5: default language 0x0409
[    4.108770] usb usb5: udev 1, busnum 5, minor = 512
[    4.108772] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.108824] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.108886] usb usb5: Product: UHCI Host Controller
[    4.108934] usb usb5: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.108984] usb usb5: SerialNumber: 0000:00:1d.1
[    4.109705] usb usb5: usb_probe_device
[    4.109709] usb usb5: configuration #1 chosen from 1 choice
[    4.109784] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    4.110287] hub 5-0:1.0: usb_probe_interface
[    4.110290] hub 5-0:1.0: usb_probe_interface - got id
[    4.110294] hub 5-0:1.0: USB hub found
[    4.110437] hub 5-0:1.0: 2 ports detected
[    4.110502] hub 5-0:1.0: standalone hub
[    4.110505] hub 5-0:1.0: no power switching (usb 1.0)
[    4.110507] hub 5-0:1.0: individual port over-current protection
[    4.110510] hub 5-0:1.0: power on to power good time: 2ms
[    4.110605] hub 5-0:1.0: local power source is good
[    4.110622] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    4.112318] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.112394] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.112399] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.112498] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    4.128149] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.128204] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.128207] uhci_hcd 0000:00:1d.2: Performing full reset
[    4.128262] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    4.128603] usb usb6: default language 0x0409
[    4.128740] usb usb6: udev 1, busnum 6, minor = 640
[    4.128743] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.128795] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.128857] usb usb6: Product: UHCI Host Controller
[    4.128905] usb usb6: Manufacturer: Linux 2.6.38-rc8+ uhci_hcd
[    4.128955] usb usb6: SerialNumber: 0000:00:1d.2
[    4.129727] usb usb6: usb_probe_device
[    4.129731] usb usb6: configuration #1 chosen from 1 choice
[    4.129806] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    4.130274] hub 6-0:1.0: usb_probe_interface
[    4.130277] hub 6-0:1.0: usb_probe_interface - got id
[    4.130281] hub 6-0:1.0: USB hub found
[    4.130421] hub 6-0:1.0: 2 ports detected
[    4.130490] hub 6-0:1.0: standalone hub
[    4.130492] hub 6-0:1.0: no power switching (usb 1.0)
[    4.130494] hub 6-0:1.0: individual port over-current protection
[    4.130497] hub 6-0:1.0: power on to power good time: 2ms
[    4.130579] hub 6-0:1.0: local power source is good
[    4.130594] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    4.132259] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.132342] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.132400] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    4.132529] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.132534] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.132634] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 7
[    4.136133] uhci_hcd 0000:00:1a.0: port 1 portsc 01a3,00
[    4.136145] hub 1-0:1.0: port 1: status 0301 change 0001
[    4.144226] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.144233] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.144401] ehci_hcd 0000:00:1a.7: debug port 1
[    4.144453] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.148339] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    4.148342] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    4.148481] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    4.148534] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.152423] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.156095] uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
[    4.156153] uhci_hcd 0000:00:1a.1: port 2 portsc 0082,00
[    4.164091] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.164499] usb usb7: default language 0x0409
[    4.164634] usb usb7: udev 1, busnum 7, minor = 768
[    4.164637] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    4.164689] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.164751] usb usb7: Product: EHCI Host Controller
[    4.164800] usb usb7: Manufacturer: Linux 2.6.38-rc8+ ehci_hcd
[    4.164850] usb usb7: SerialNumber: 0000:00:1a.7
[    4.165560] usb usb7: usb_probe_device
[    4.165564] usb usb7: configuration #1 chosen from 1 choice
[    4.165639] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    4.166102] hub 7-0:1.0: usb_probe_interface
[    4.166105] hub 7-0:1.0: usb_probe_interface - got id
[    4.166109] hub 7-0:1.0: USB hub found
[    4.166268] hub 7-0:1.0: 6 ports detected
[    4.166334] hub 7-0:1.0: standalone hub
[    4.166336] hub 7-0:1.0: no power switching (usb 1.0)
[    4.166338] hub 7-0:1.0: individual port over-current protection
[    4.166341] hub 7-0:1.0: power on to power good time: 20ms
[    4.166423] hub 7-0:1.0: local power source is good
[    4.166437] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    4.167907] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    4.167921] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    4.167934] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    4.168184] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.168253] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.168329] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.168462] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.168467] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.168565] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    4.172161] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.184118] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.184124] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.184286] ehci_hcd 0000:00:1d.7: debug port 1
[    4.184338] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.188226] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.188229] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.188377] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    4.188429] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.192078] uhci_hcd 0000:00:1d.0: port 1 portsc 01a3,00
[    4.192089] hub 4-0:1.0: port 1: status 0301 change 0001
[    4.192308] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.204023] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.204402] usb usb8: default language 0x0409
[    4.204556] usb usb8: udev 1, busnum 8, minor = 896
[    4.204559] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[    4.204612] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.204675] usb usb8: Product: EHCI Host Controller
[    4.204724] usb usb8: Manufacturer: Linux 2.6.38-rc8+ ehci_hcd
[    4.204775] usb usb8: SerialNumber: 0000:00:1d.7
[    4.205563] usb usb8: usb_probe_device
[    4.205566] usb usb8: configuration #1 chosen from 1 choice
[    4.205641] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    4.206128] hub 8-0:1.0: usb_probe_interface
[    4.206131] hub 8-0:1.0: usb_probe_interface - got id
[    4.206135] hub 8-0:1.0: USB hub found
[    4.206293] hub 8-0:1.0: 6 ports detected
[    4.206356] hub 8-0:1.0: standalone hub
[    4.206358] hub 8-0:1.0: no power switching (usb 1.0)
[    4.206361] hub 8-0:1.0: individual port over-current protection
[    4.206364] hub 8-0:1.0: power on to power good time: 20ms
[    4.206456] hub 8-0:1.0: local power source is good
[    4.206473] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    4.208090] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.208342] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    4.208357] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    4.208372] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    4.216023] Monitor-Mwait will be used to enter C-3 state
[    4.228093] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.236063] hub 1-0:1.0: state 7 ports 2 chg 0002 evt 0000
[    4.236092] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[    4.236128] hub 1-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
[    4.264191] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001403 0  ACK POWER sig=k CSC CONNECT
[    4.264205] hub 7-0:1.0: port 1: status 0501 change 0001
[    4.264285] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.264294] hub 7-0:1.0: port 3: status 0501 change 0001
[    4.264335] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.264344] hub 7-0:1.0: port 4: status 0501 change 0001
[    4.304158] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001403 0  ACK POWER sig=k CSC CONNECT
[    4.304171] hub 8-0:1.0: port 1: status 0501 change 0001
[    4.364164] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
[    4.364173] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.364182] hub 4-0:1.0: state 7 ports 2 chg 0002 evt 0002
[    4.364209] uhci_hcd 0000:00:1d.0: port 1 portsc 0082,00
[    4.364247] hub 4-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
[    4.492150] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
[    4.492160] hub 7-0:1.0: state 7 ports 6 chg 001a evt 0000
[    4.492192] hub 7-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    4.492263] ehci_hcd 0000:00:1a.7: port 1 low speed --> companion
[    4.548113] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.548222] hub 7-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    4.604325] ehci_hcd 0000:00:1a.7: port 3 full speed --> companion
[    4.604330] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    4.604340] hub 7-0:1.0: port 3 not reset yet, waiting 50ms
[    4.660121] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.660238] hub 7-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    4.716325] ehci_hcd 0000:00:1a.7: port 4 full speed --> companion
[    4.716330] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    4.716339] hub 7-0:1.0: port 4 not reset yet, waiting 50ms
[    4.772108] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.772204] hub 8-0:1.0: state 7 ports 6 chg 0002 evt 0000
[    4.772233] hub 8-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    4.772271] ehci_hcd 0000:00:1d.7: port 1 low speed --> companion
[    4.828109] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.828206] hub 7-0:1.0: state 7 ports 6 chg 0000 evt 0010
[    4.828240] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    4.828265] uhci_hcd 0000:00:1a.0: port 1 portsc 01a3,00
[    4.828299] hub 1-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    4.956125] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    5.068125] usb 1-1: new low speed USB device using uhci_hcd and address 2
[    5.112065] usb usb3: suspend_rh (auto-stop)
[    5.112094] usb usb5: suspend_rh (auto-stop)
[    5.222623] usb 1-1: skipped 1 descriptor after interface
[    5.227618] usb 1-1: default language 0x0409
[    5.243622] usb 1-1: udev 2, busnum 1, minor = 1
[    5.243625] usb 1-1: New USB device found, idVendor=046d, idProduct=c018
[    5.243678] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.243729] usb 1-1: Product: USB Optical Mouse
[    5.243778] usb 1-1: Manufacturer: Logitech
[    5.244596] usb 1-1: usb_probe_device
[    5.244600] usb 1-1: configuration #1 chosen from 1 choice
[    5.247631] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    5.249152] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0006
[    5.249179] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    5.249214] hub 2-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    5.259571] usbhid 1-1:1.0: usb_probe_interface
[    5.259576] usbhid 1-1:1.0: usb_probe_interface - got id
[    5.273652] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1:1.0/input/input5
[    5.275269] generic-usb 0003:046D:C018.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1a.0-1/input0
[    5.275465] usbcore: registered new interface driver usbhid
[    5.275522] usbhid: USB HID core driver
[    5.360081] usb usb6: suspend_rh (auto-stop)
[    5.376090] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    5.488126] usb 2-1: new full speed USB device using uhci_hcd and address 2
[    5.620075] usb 2-1: ep0 maxpacket = 8
[    5.646548] usb 2-1: default language 0x0409
[    5.655560] usb 2-1: udev 2, busnum 2, minor = 129
[    5.655563] usb 2-1: New USB device found, idVendor=08ff, idProduct=2810
[    5.655616] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    5.655669] usb 2-1: Product: Fingerprint Sensor
[    5.656353] usb 2-1: usb_probe_device
[    5.656357] usb 2-1: configuration #1 chosen from 1 choice
[    5.657576] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    5.659559] uhci_hcd 0000:00:1a.1: port 2 portsc 0093,00
[    5.659590] hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    5.788115] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    5.900123] usb 2-2: new full speed USB device using uhci_hcd and address 3
[    6.052636] usb 2-2: skipped 1 descriptor after interface
[    6.055547] usb 2-2: default language 0x0409
[    6.066565] usb 2-2: udev 3, busnum 2, minor = 130
[    6.066569] usb 2-2: New USB device found, idVendor=0a5c, idProduct=2145
[    6.066623] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.066676] usb 2-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[    6.066733] usb 2-2: Manufacturer: Lenovo Computer Corp
[    6.067354] usb 2-2: usb_probe_device
[    6.067358] usb 2-2: configuration #1 chosen from 1 choice
[    6.068614] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[    6.070221] usb 2-2: adding 2-2:1.1 (config #1, interface 1)
[    6.071322] usb 2-2: adding 2-2:1.2 (config #1, interface 2)
[    6.072523] usb 2-2: adding 2-2:1.3 (config #1, interface 3)
[    6.073653] hub 8-0:1.0: state 7 ports 6 chg 0000 evt 0002
[    6.073698] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    6.073724] uhci_hcd 0000:00:1d.0: port 1 portsc 01a3,00
[    6.073761] hub 4-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    6.200115] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    6.312120] usb 4-1: new low speed USB device using uhci_hcd and address 2
[    6.469546] usb 4-1: skipped 1 descriptor after interface
[    6.469559] usb 4-1: skipped 1 descriptor after interface
[    6.474534] usb 4-1: default language 0x0409
[    6.491545] usb 4-1: udev 2, busnum 4, minor = 385
[    6.491548] usb 4-1: New USB device found, idVendor=046d, idProduct=c30a
[    6.491601] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.491654] usb 4-1: Product: Logitech USB Keyboard
[    6.491704] usb 4-1: Manufacturer: Logitech
[    6.492393] usb 4-1: usb_probe_device
[    6.492397] usb 4-1: configuration #1 chosen from 1 choice
[    6.495556] usb 4-1: adding 4-1:1.0 (config #1, interface 0)
[    6.495977] usbhid 4-1:1.0: usb_probe_interface
[    6.495980] usbhid 4-1:1.0: usb_probe_interface - got id
[    6.496935] usb 4-1: adding 4-1:1.1 (config #1, interface 1)
[    6.497322] usbhid 4-1:1.1: usb_probe_interface
[    6.497326] usbhid 4-1:1.1: usb_probe_interface - got id
[    6.499227] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    6.499263] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    6.499269] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    6.536718] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1:1.0/input/input6
[    6.536843] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    6.537896] logitech 0003:046D:C30A.0002: input,hidraw1: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:1d.0-1/input0
[    6.576270] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1:1.1/input/input7
[    6.576383] uhci_hcd 0000:00:1d.0: reserve dev 2 ep82-INT, period 32, phase 16, 118 us
[    6.577867] logitech 0003:046D:C30A.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech Logitech USB Keyboard] on usb-0000:00:1d.0-1/input1
[    6.808135] hub 5-0:1.0: hub_suspend
[    6.808176] usb usb5: bus auto-suspend
[    6.808179] usb usb5: suspend_rh
[    6.808201] hub 6-0:1.0: hub_suspend
[    6.808207] usb usb6: bus auto-suspend
[    6.808210] usb usb6: suspend_rh
[    6.824089] hub 3-0:1.0: hub_suspend
[    6.824098] usb usb3: bus auto-suspend
[    6.824101] usb usb3: suspend_rh
[    6.828089] hub 7-0:1.0: hub_suspend
[    6.828095] usb usb7: bus auto-suspend
[    6.828098] ehci_hcd 0000:00:1a.7: suspend root hub
[    8.808136] hub 8-0:1.0: hub_suspend
[    8.808143] usb usb8: bus auto-suspend
[    8.808146] ehci_hcd 0000:00:1d.7: suspend root hub
[    8.954783] EXT3-fs: barriers not enabled
[    8.955311] kjournald starting.  Commit interval 5 seconds
[    8.955496] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   14.118948] Adding 1871568k swap on /dev/sda2.  Priority:-1 extents:1 across:1871568k SS
[   14.140570] EXT3-fs (sda1): using internal journal
[   14.193340] udev[2722]: starting version 163
[   14.640466] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[   14.640842] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[   14.643771] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[   14.722783] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[   15.191022] sshd (2848): /proc/2848/oom_adj is deprecated, please use /proc/2848/oom_score_adj instead.
[   15.287030] cfg80211: Calling CRDA to update world regulatory domain
[   15.299854] [drm] Initialized drm 1.1.0 20060810
[   15.403057] cfg80211: World regulatory domain updated:
[   15.403062] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   15.403066] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.403069] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.403073] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.403076] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.403080] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.585232] i915 0000:00:02.0: power state changed by ACPI to D0
[   15.585256] i915 0000:00:02.0: power state changed by ACPI to D0
[   15.585266] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   15.585272] i915 0000:00:02.0: setting latency timer to 64
[   15.719900] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   15.719904] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   15.730045] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   15.731860] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   15.731871] iwlagn 0000:03:00.0: setting latency timer to 64
[   15.731954] iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   15.767031] iwlagn 0000:03:00.0: device EEPROM VER=0x11f, CALIB=0x4
[   15.767036] iwlagn 0000:03:00.0: Device SKU: 0Xb
[   15.767081] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   15.767230] iwlagn 0000:03:00.0: irq 42 for MSI/MSI-X
[   15.784222] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   15.785186] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.805941] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-5.ucode' failed.
[   15.825149] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-4.ucode' failed.
[   15.846159] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-3.ucode' failed.
[   15.877967] iwlagn 0000:03:00.0: Firmware has old API version. Expected v5, got v2. New firmware can be obtained from http://www.intellinuxwireless.org.
[   15.878046] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[   15.938965] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   15.986157] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[   15.986271] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   15.986274] [drm] Driver supports precise vblank timestamp query.
[   16.265231] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   16.283614] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   16.636775] fb0: inteldrmfb frame buffer device
[   16.636779] drm: registered panic notifier
[   16.782123] acpi device:02: registered as cooling_device2
[   16.787901] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input8
[   16.789704] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   16.790723] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   16.790862] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   16.791010] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[   16.791194] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   16.861841] Console: switching to colour frame buffer device 180x56
[   17.460926] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[   17.460932] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   17.461495] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   17.824294] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 99 us
[   27.656017] eth0: no IPv6 routers present
[   32.720753] wlan0: authenticate with 1c:17:d3:cb:d3:11 (try 1)
[   32.724608] wlan0: authenticated
[   32.740088] wlan0: waiting for beacon from 1c:17:d3:cb:d3:11
[   45.371224] wlan0: authenticate with 1c:17:d3:cb:d3:11 (try 1)
[   45.388200] wlan0: authenticated
[   45.388291] wlan0: waiting for beacon from 1c:17:d3:cb:d3:11
[   45.470793] wlan0: beacon received
[   45.484112] wlan0: associate with 1c:17:d3:cb:d3:11 (try 1)
[   45.486525] wlan0: RX AssocResp from 1c:17:d3:cb:d3:11 (capab=0x431 status=0 aid=4)
[   45.486529] wlan0: associated
[   45.491363] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   45.491679] cfg80211: Calling CRDA for country: US
[   45.502547] cfg80211: Regulatory domain changed to country: US
[   45.502551] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   45.502555] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[   45.502559] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[   45.502562] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   45.502566] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   45.502569] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   45.502573] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[   45.918703] Intel AES-NI instructions are not detected.
[   49.726080] irq 23: nobody cared (try booting with the "irqpoll" option)
[   49.726087] Pid: 4072, comm: avahi-daemon-ch Not tainted 2.6.38-rc8+ #777
[   49.726090] Call Trace:
[   49.726092]  <IRQ>  [<ffffffff81099ce6>] ? __report_bad_irq+0x26/0xa0
[   49.726103]  [<ffffffff81099eec>] ? note_interrupt+0x18c/0x1d0
[   49.726108]  [<ffffffff8109a86d>] ? handle_fasteoi_irq+0xcd/0x100
[   49.726113]  [<ffffffff8100543d>] ? handle_irq+0x1d/0x30
[   49.726117]  [<ffffffff81004bb8>] ? do_IRQ+0x58/0xd0
[   49.726122]  [<ffffffff814a0d13>] ? ret_from_intr+0x0/0xe
[   49.726124]  <EOI>  [<ffffffff810739bb>] ? is_module_text_address+0x2b/0x60
[   49.726134]  [<ffffffff81055788>] ? __kernel_text_address+0x58/0x80
[   49.726138]  [<ffffffff81006be4>] ? print_context_stack+0x74/0xd0
[   49.726142]  [<ffffffff81005a89>] ? dump_trace+0x189/0x3c0
[   49.726147]  [<ffffffff8100f938>] ? save_stack_trace+0x28/0x50
[   49.726153]  [<ffffffff810f1345>] ? create_object+0x145/0x2d0
[   49.726157]  [<ffffffff8102ea51>] ? get_parent_ip+0x11/0x50
[   49.726162]  [<ffffffff810d78e9>] ? anon_vma_fork+0x59/0xc0
[   49.726166]  [<ffffffff8148d4b9>] ? kmemleak_alloc+0x59/0xc0
[   49.726170]  [<ffffffff810e9100>] ? kmem_cache_alloc+0xa0/0xf0
[   49.726174]  [<ffffffff810d78e9>] ? anon_vma_fork+0x59/0xc0
[   49.726179]  [<ffffffff81038ad3>] ? dup_mm+0x1f3/0x480
[   49.726184]  [<ffffffff81039b4d>] ? copy_process+0xd9d/0x1210
[   49.726188]  [<ffffffff8103a021>] ? do_fork+0x61/0x330
[   49.726193]  [<ffffffff810f9251>] ? sys_newstat+0x31/0x50
[   49.726198]  [<ffffffff8100ae03>] ? sys_clone+0x23/0x30
[   49.726203]  [<ffffffff81003173>] ? stub_clone+0x13/0x20
[   49.726207]  [<ffffffff81002e3b>] ? system_call_fastpath+0x16/0x1b
[   49.726210] handlers:
[   49.726212] [<ffffffffa0006db0>] (usb_hcd_irq+0x0/0x70 [usbcore])
[   49.726232] Disabling IRQ #23
[   56.320095] wlan0: no IPv6 routers present
[   80.086433] kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

--hOcCNbCCxyk/YU74--
