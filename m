Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab1CDRyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:54:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:55058 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab1CDRyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:54:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,264,1297065600"; 
   d="txt'?scan'208";a="609153894"
Date: Fri, 4 Mar 2011 09:52:10 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
Subject: Re: [PATCH 0/2] Re: 2.6.38 regression caused by commit 415e12b
Message-ID: <20110304175210.GA3798@xanatos>
References: <20110228014218.GA11083@xanatos>
 <20110302034140.GA2205@xanatos>
 <201103021221.06312.rjw@sisk.pl>
 <201103022330.49297.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <201103022330.49297.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 02, 2011 at 11:30:49PM +0100, Rafael J. Wysocki wrote:
> On Wednesday, March 02, 2011, Rafael J. Wysocki wrote:
> > There are two problems.  First, your BIOS says that ASPM is not supported
> > by it, so we don't call _OSC, which should be fixed by the previous patch.
> > Second, pci_msi_enabled() returns 0 on your system, which is kind of strange,
> > because it evidently uses MSIs (as visible in the dmesg).
> > 
> > While I think we can safely request _OSC control even if ASPM is not supported
> > by the hardware (according to the BIOS), which is done after the first patch,
> > we need to figure out why 0 is returned by pci_msi_enabled() on your system
> > and try to work around that.
> 
> Regardless, I think we should report MSI and ASPM support to the BIOS unless
> directly disabled via the kernel command line or .config.
> 
> I'm going to send two patches in replies to this message.  Please apply them
> both on top of 2.6.38-rc7 and report back.

I applied your patches on top of 2.6.38-rc6 again and tested them.
dmesg is attached.  Let me know if you need me to test Linus' latest
instead.

Sarah Sharp

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-2011-03-04-08-37.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-rc6+ (sarah@xanatos) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu9) ) #768 SMP PREEMPT Thu Mar 3 16:01:44 PST 2011
[    0.000000] Command line: root=UUID=17b05cc8-db3c-4770-8c5e-8702f049f6d1 ro  
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
[    0.000000] RAMDISK: 35dce000 - 37ff0000
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
[    0.000000] Kernel command line: root=UUID=17b05cc8-db3c-4770-8c5e-8702f049f6d1 ro  
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3905952k/5177344k available (4764k kernel code, 1089568k absent, 181824k reserved, 3941k data, 524k init)
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
[    0.000000] Detected 1862.179 MHz processor.
[    0.004007] Calibrating delay loop (skipped), value calculated using timer frequency.. 3724.35 BogoMIPS (lpj=7448716)
[    0.004148] pid_max: default: 32768 minimum: 301
[    0.008659] Mount-cache hash table entries: 256
[    0.011572] Initializing cgroup subsys ns
[    0.011643] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.011745] Initializing cgroup subsys cpuacct
[    0.011842] Initializing cgroup subsys memory
[    0.012170] Initializing cgroup subsys freezer
[    0.012626] CPU: Physical Processor ID: 0
[    0.012691] CPU: Processor Core ID: 0
[    0.012754] using mwait in idle threads.
[    0.012929] ACPI: Core revision 20110112
[    0.364616] Setting APIC routing to flat
[    0.368462] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.408245] CPU0: Intel(R) Core(TM)2 Duo CPU     L9400  @ 1.86GHz stepping 0a
[    0.412025] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.412025] ... version:                2
[    0.412025] ... bit width:              40
[    0.412025] ... generic registers:      2
[    0.412025] ... value mask:             000000ffffffffff
[    0.412025] ... max period:             000000007fffffff
[    0.412025] ... fixed-purpose events:   3
[    0.412025] ... event mask:             0000000700000003
[    0.420379] NMI watchdog enabled, takes one hw-pmu counter.
[    0.432063] lockdep: fixing up alternatives.
[    0.436248] Booting Node   0, Processors  #1 Ok.
[    0.532185] NMI watchdog enabled, takes one hw-pmu counter.
[    0.536057] Brought up 2 CPUs
[    0.536125] Total of 2 processors activated (7448.34 BogoMIPS).
[    0.547049] NET: Registered protocol family 16
[    0.552411] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.552515] ACPI: bus type pci registered
[    0.554054] PCI: Using configuration type 1 for base access
[    0.585419] bio: create slab <bio-0> at 0
[    0.606847] ACPI: EC: EC description table is found, configuring boot EC
[    0.952507] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.040431] ACPI: SSDT 00000000bd8d7c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    1.047389] ACPI: Dynamic OEM Table Load:
[    1.047544] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    1.056855] ACPI: SSDT 00000000bd8d5020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    1.068795] ACPI: Dynamic OEM Table Load:
[    1.068949] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    1.118280] ACPI: SSDT 00000000bd8d6ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    1.127668] ACPI: Dynamic OEM Table Load:
[    1.127822] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    1.148587] ACPI: SSDT 00000000bd8d6f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    1.154742] ACPI: Dynamic OEM Table Load:
[    1.154895] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    1.183847] ACPI: Interpreter enabled
[    1.183917] ACPI: (supports S0 S3 S4 S5)
[    1.185084] ACPI: Using IOAPIC for interrupt routing
[    1.349111] ACPI: Power Resource [PUBS] (on)
[    1.489326] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    1.553557] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    1.553634] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.569926] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.571854] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.571932] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.572007] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.572223] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    1.572312] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    1.572401] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    1.572685] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    1.572895] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    1.572943] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    1.572973] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.572995] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    1.573148] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    1.573189] pci 0000:00:02.1: reg 10: [mem 0xf2400000-0xf24fffff 64bit]
[    1.573399] pci 0000:00:03.0: [8086:2a44] type 0 class 0x000780
[    1.573449] pci 0000:00:03.0: reg 10: [mem 0xf2826800-0xf282680f 64bit]
[    1.573582] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.573593] pci 0000:00:03.0: PME# disabled
[    1.573682] pci 0000:00:03.2: [8086:2a46] type 0 class 0x000101
[    1.573724] pci 0000:00:03.2: reg 10: [io  0x1828-0x182f]
[    1.573746] pci 0000:00:03.2: reg 14: [io  0x180c-0x180f]
[    1.573769] pci 0000:00:03.2: reg 18: [io  0x1820-0x1827]
[    1.573792] pci 0000:00:03.2: reg 1c: [io  0x1808-0x180b]
[    1.573814] pci 0000:00:03.2: reg 20: [io  0x1810-0x181f]
[    1.573981] pci 0000:00:03.3: [8086:2a47] type 0 class 0x000700
[    1.574023] pci 0000:00:03.3: reg 10: [io  0x1830-0x1837]
[    1.574045] pci 0000:00:03.3: reg 14: [mem 0xf2624000-0xf2624fff]
[    1.574354] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    1.574410] pci 0000:00:19.0: reg 10: [mem 0xf2600000-0xf261ffff]
[    1.574438] pci 0000:00:19.0: reg 14: [mem 0xf2625000-0xf2625fff]
[    1.574465] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    1.574619] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.574632] pci 0000:00:19.0: PME# disabled
[    1.574726] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    1.574850] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    1.575020] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    1.575144] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    1.575314] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    1.575438] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    1.575634] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    1.575691] pci 0000:00:1a.7: reg 10: [mem 0xf2826c00-0xf2826fff]
[    1.575887] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.575900] pci 0000:00:1a.7: PME# disabled
[    1.576010] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    1.576056] pci 0000:00:1b.0: reg 10: [mem 0xf2620000-0xf2623fff 64bit]
[    1.576275] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.576288] pci 0000:00:1b.0: PME# disabled
[    1.576384] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    1.576581] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.576593] pci 0000:00:1c.0: PME# disabled
[    1.576694] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    1.576890] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.576902] pci 0000:00:1c.1: PME# disabled
[    1.577008] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    1.577204] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.577216] pci 0000:00:1c.3: PME# disabled
[    1.577330] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    1.577455] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    1.577625] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    1.577749] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    1.577919] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    1.578043] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    1.578240] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    1.578297] pci 0000:00:1d.7: reg 10: [mem 0xf2827000-0xf28273ff]
[    1.578492] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.578506] pci 0000:00:1d.7: PME# disabled
[    1.578606] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    1.578822] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    1.579160] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    1.579222] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    1.579249] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    1.579275] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    1.579302] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    1.579328] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    1.579355] pci 0000:00:1f.2: reg 24: [mem 0xf2826000-0xf28267ff]
[    1.579466] pci 0000:00:1f.2: PME# supported from D3hot
[    1.579478] pci 0000:00:1f.2: PME# disabled
[    1.579571] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    1.579619] pci 0000:00:1f.3: reg 10: [mem 0xf2827400-0xf28274ff 64bit]
[    1.579685] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    1.579933] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.580012] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.580025] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.580044] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.580457] pci 0000:03:00.0: [8086:4237] type 0 class 0x000280
[    1.580523] pci 0000:03:00.0: reg 10: [mem 0xf2500000-0xf2501fff 64bit]
[    1.580796] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.580811] pci 0000:03:00.0: PME# disabled
[    1.580936] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.581014] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    1.581027] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    1.581046] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.581215] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    1.581292] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.581305] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    1.581323] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.581557] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d] (subtractive decode)
[    1.581640] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.581653] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.581672] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.581700] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.581727] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.581754] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.581783] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    1.581810] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    1.581837] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    1.581896] pci_bus 0000:00: on NUMA node 0
[    1.581949] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.597523] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    1.600892] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    1.604584] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    2.106138] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    2.111169] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    2.116117] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    2.121158] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    2.126236] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    2.131160] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    2.136231] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    2.141295] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    2.143858] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.144391] vgaarb: loaded
[    2.147699] SCSI subsystem initialized
[    2.148407] libata version 3.00 loaded.
[    2.149554] PCI: Using ACPI for IRQ routing
[    2.149554] PCI: pci_cache_line_size set to 64 bytes
[    2.149687] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    2.149714] reserve RAM buffer: 00000000bd6a1000 - 00000000bfffffff 
[    2.150073] reserve RAM buffer: 00000000bd7b7000 - 00000000bfffffff 
[    2.150376] reserve RAM buffer: 00000000bd8c7000 - 00000000bfffffff 
[    2.152292] reserve RAM buffer: 00000000bdc00000 - 00000000bfffffff 
[    2.155026] Bluetooth: Core ver 2.15
[    2.155293] NET: Registered protocol family 31
[    2.155361] Bluetooth: HCI device and connection manager initialized
[    2.155465] Bluetooth: HCI socket layer initialized
[    2.156449] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    2.164634] Switching to clocksource hpet
[    2.164897] pnp: PnP ACPI init
[    2.165311] ACPI: bus type pnp registered
[    2.167421] Switched to NOHz mode on CPU #0
[    2.167518] Switched to NOHz mode on CPU #1
[    2.217713] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    2.217737] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    2.217759] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    2.217786] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    2.217808] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    2.217830] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    2.217852] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    2.217874] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    2.217896] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    2.217919] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    2.217940] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    2.217962] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    2.217984] pnp 00:00: [mem 0x000ec000-0x000effff]
[    2.218006] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    2.218032] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    2.218054] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    2.218076] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    2.219710] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    2.219833] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    2.219951] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    2.220102] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    2.220221] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    2.220343] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    2.220473] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    2.220603] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    2.220734] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    2.220864] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    2.220995] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    2.221125] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    2.221256] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    2.221387] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    2.221518] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    2.221601] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.222084] pnp 00:01: [bus 00-ff]
[    2.222107] pnp 00:01: [io  0x0cf8-0x0cff]
[    2.222130] pnp 00:01: [io  0x0000-0x0cf7 window]
[    2.222153] pnp 00:01: [io  0x0d00-0xffff window]
[    2.222175] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    2.222201] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    2.222224] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    2.222247] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    2.222269] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    2.222291] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    2.222314] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    2.222336] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    2.222358] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    2.222380] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    2.222403] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    2.222425] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    2.222447] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    2.222469] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
[    2.222492] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    2.223359] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    2.249011] pnp 00:02: [io  0x0010-0x001f]
[    2.249035] pnp 00:02: [io  0x0090-0x009f]
[    2.249057] pnp 00:02: [io  0x0024-0x0025]
[    2.249079] pnp 00:02: [io  0x0028-0x0029]
[    2.249100] pnp 00:02: [io  0x002c-0x002d]
[    2.249123] pnp 00:02: [io  0x0030-0x0031]
[    2.249144] pnp 00:02: [io  0x0034-0x0035]
[    2.249166] pnp 00:02: [io  0x0038-0x0039]
[    2.249187] pnp 00:02: [io  0x003c-0x003d]
[    2.249209] pnp 00:02: [io  0x00a4-0x00a5]
[    2.249230] pnp 00:02: [io  0x00a8-0x00a9]
[    2.249252] pnp 00:02: [io  0x00ac-0x00ad]
[    2.249273] pnp 00:02: [io  0x00b0-0x00b5]
[    2.249295] pnp 00:02: [io  0x00b8-0x00b9]
[    2.249316] pnp 00:02: [io  0x00bc-0x00bd]
[    2.249337] pnp 00:02: [io  0x0050-0x0053]
[    2.249359] pnp 00:02: [io  0x0072-0x0077]
[    2.249380] pnp 00:02: [io  0x002e-0x002f]
[    2.249402] pnp 00:02: [io  0x1000-0x107f]
[    2.249424] pnp 00:02: [io  0x1180-0x11ff]
[    2.249450] pnp 00:02: [io  0x0800-0x080f]
[    2.249473] pnp 00:02: [io  0x15e0-0x15ef]
[    2.249495] pnp 00:02: [io  0x1600-0x167f]
[    2.249517] pnp 00:02: [io  0x1680-0x169f]
[    2.249539] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    2.249561] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    2.249583] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    2.249605] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    2.249627] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    2.249649] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    2.251344] system 00:02: [io  0x1000-0x107f] has been reserved
[    2.251464] system 00:02: [io  0x1180-0x11ff] has been reserved
[    2.251580] system 00:02: [io  0x0800-0x080f] has been reserved
[    2.251698] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    2.251814] system 00:02: [io  0x1600-0x167f] has been reserved
[    2.251931] system 00:02: [io  0x1680-0x169f] has been reserved
[    2.252078] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    2.252207] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.252328] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    2.252446] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    2.252565] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    2.252683] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    2.252765] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.254247] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    2.255094] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.255406] pnp 00:04: [io  0x0000-0x000f]
[    2.255429] pnp 00:04: [io  0x0080-0x008f]
[    2.255452] pnp 00:04: [io  0x00c0-0x00df]
[    2.255478] pnp 00:04: [dma 4]
[    2.256349] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.256658] pnp 00:05: [io  0x0061]
[    2.257496] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    2.257808] pnp 00:06: [io  0x00f0]
[    2.257848] pnp 00:06: [irq 13]
[    2.258698] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.259009] pnp 00:07: [io  0x0070-0x0071]
[    2.259044] pnp 00:07: [irq 8]
[    2.259899] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.260370] pnp 00:08: [io  0x0060]
[    2.260392] pnp 00:08: [io  0x0064]
[    2.260426] pnp 00:08: [irq 1]
[    2.261266] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.261588] pnp 00:09: [irq 12]
[    2.262456] pnp 00:09: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    2.287485] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    2.288355] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
[    2.297590] pnp: PnP ACPI: found 11 devices
[    2.297661] ACPI: ACPI bus type pnp unregistered
[    2.356594] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc01fffff]
[    2.356687] pci 0000:00:1c.0: BAR 9: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    2.356788] pci 0000:00:1c.1: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    2.356887] pci 0000:00:1c.0: BAR 7: assigned [io  0x3000-0x3fff]
[    2.356970] pci 0000:00:1c.1: BAR 7: assigned [io  0x4000-0x4fff]
[    2.357049] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.357123] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    2.357205] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    2.357286] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    2.357385] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    2.357459] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    2.357540] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    2.357621] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    2.357720] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    2.357794] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    2.357875] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    2.357955] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    2.358055] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
[    2.358125] pci 0000:00:1e.0:   bridge window [io  disabled]
[    2.358205] pci 0000:00:1e.0:   bridge window [mem disabled]
[    2.358281] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    2.358409] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.358492] pci 0000:00:1c.0: setting latency timer to 64
[    2.358538] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.358619] pci 0000:00:1c.1: setting latency timer to 64
[    2.358663] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    2.358743] pci 0000:00:1c.3: setting latency timer to 64
[    2.358762] pci 0000:00:1e.0: setting latency timer to 64
[    2.358773] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.358780] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.358787] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.358795] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    2.358802] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    2.358809] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    2.358816] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    2.358823] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    2.358831] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    2.358838] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    2.358845] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
[    2.358852] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    2.358860] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    2.358866] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    2.358874] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
[    2.358881] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
[    2.358888] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
[    2.358895] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
[    2.358902] pci_bus 0000:0d: resource 7 [mem 0x000d4000-0x000d7fff]
[    2.358909] pci_bus 0000:0d: resource 8 [mem 0x000d8000-0x000dbfff]
[    2.358916] pci_bus 0000:0d: resource 9 [mem 0xc0000000-0xfebfffff]
[    2.359242] NET: Registered protocol family 2
[    2.359890] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.363519] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    2.366585] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    2.374684] TCP: Hash tables configured (established 262144 bind 65536)
[    2.374818] TCP reno registered
[    2.374927] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    2.375560] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    2.377193] NET: Registered protocol family 1
[    2.377413] pci 0000:00:02.0: Boot video device
[    2.377575] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    2.377582] pci 0000:00:1a.0: Performing full reset
[    2.377637] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    2.377643] pci 0000:00:1a.1: Performing full reset
[    2.377696] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    2.377702] pci 0000:00:1a.2: Performing full reset
[    2.378025] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    2.378032] pci 0000:00:1d.0: Performing full reset
[    2.378085] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    2.378091] pci 0000:00:1d.1: Performing full reset
[    2.378145] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    2.378151] pci 0000:00:1d.2: Performing full reset
[    2.378445] PCI: CLS 64 bytes, default 64
[    2.379304] Trying to unpack rootfs image as initramfs...
[    4.646233] Freeing initrd memory: 34952k freed
[    5.008364] DMA-API: preallocated 32768 debug entries
[    5.008444] DMA-API: debugging enabled by kernel config
[    5.008529] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    5.008605] Placing 64MB software IO TLB between ffff8800b8c9d000 - ffff8800bcc9d000
[    5.008692] software IO TLB at phys 0xb8c9d000 - 0xbcc9d000
[    5.009138] Simple Boot Flag at 0x35 set to 0x1
[    5.012488] Scanning for low memory corruption every 60 seconds
[    5.014431] audit: initializing netlink socket (disabled)
[    5.014674] type=2000 audit(1299256265.008:1): initialized
[    5.054598] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.113642] fuse init (API version 7.16)
[    5.115835] msgmni has been set to 7697
[    5.118754] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    5.118861] io scheduler noop registered
[    5.118928] io scheduler deadline registered
[    5.119738] io scheduler cfq registered (default)
[    5.123196] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.124283] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    5.125997] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    5.128650] ACPI: AC Adapter [AC] (off-line)
[    5.131892] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    5.168047] ACPI: Lid Switch [LID]
[    5.169647] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    5.232044] ACPI: Sleep Button [SLPB]
[    5.233701] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    5.233819] ACPI: Power Button [PWRF]
[    5.234311] ACPI: acpi_idle registered with cpuidle
[    5.518026] Monitor-Mwait will be used to enter C-1 state
[    5.520359] Monitor-Mwait will be used to enter C-2 state
[    5.524041] Monitor-Mwait will be used to enter C-3 state
[    5.524069] Marking TSC unstable due to TSC halts in idle
[    5.699776] thermal LNXTHERM:00: registered as thermal_zone0
[    5.699851] ACPI: Thermal Zone [THM0] (27 C)
[    5.722028] thermal LNXTHERM:01: registered as thermal_zone1
[    5.722102] ACPI: Thermal Zone [THM1] (31 C)
[    5.723286] Linux agpgart interface v0.103
[    5.760897] brd: module loaded
[    5.779658] loop: module loaded
[    5.783037] ahci 0000:00:1f.2: version 3.0
[    5.783153] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    5.783757] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
[    5.784205] ahci: SSS flag set, parallel bus scan disabled
[    5.784407] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    5.784586] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    5.784781] ahci 0000:00:1f.2: setting latency timer to 64
[    5.806738] scsi0 : ahci
[    5.809594] scsi1 : ahci
[    5.812271] scsi2 : ahci
[    5.815132] scsi3 : ahci
[    5.826274] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    5.826576] ACPI: Battery Slot [BAT0] (battery present)
[    5.838962] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 40
[    5.839053] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 40
[    5.839139] ata3: DUMMY
[    5.839200] ata4: DUMMY
[    5.840513] ata_generic 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.840897] ata_generic 0000:00:03.2: setting latency timer to 64
[    5.855386] scsi4 : ata_generic
[    5.857794] scsi5 : ata_generic
[    5.859884] ata5: PATA max UDMA/100 cmd 0x1828 ctl 0x180c bmdma 0x1810 irq 18
[    5.859962] ata6: PATA max UDMA/100 cmd 0x1820 ctl 0x1808 bmdma 0x1818 irq 18
[    5.860709] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-k2
[    5.860782] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    5.861028] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    5.861154] e1000e 0000:00:19.0: setting latency timer to 64
[    5.861727] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    6.156055] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.164509] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    6.164521] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    6.164615] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    6.185510] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:1d:fb:eb
[    6.185604] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    6.185709] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[    6.186145] PPP generic driver version 2.4.2
[    6.188095] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    6.198853] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.199826] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.202111] mousedev: PS/2 mouse device common for all mice
[    6.205498] rtc_cmos 00:07: RTC can wake from S4
[    6.211353] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    6.212368] ata1.00: ATA-8: ST9250410AS, 0002SDM1, max UDMA/133
[    6.212444] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    6.222291] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    6.222303] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    6.222395] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    6.224385] ata1.00: configured for UDMA/133
[    6.225468] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    6.225671] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    6.225889] Linux video capture interface: v2.00
[    6.227039] device-mapper: uevent: version 1.0.3
[    6.228616] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    6.229129] device-mapper: multipath: version 1.2.0 loaded
[    6.229231] device-mapper: multipath round-robin: version 1.0.0 loaded
[    6.232720] cpuidle: using governor ladder
[    6.236298] cpuidle: using governor menu
[    6.238498] TCP cubic registered
[    6.241517] NET: Registered protocol family 10
[    6.242210] scsi 0:0:0:0: Direct-Access     ATA      ST9250410AS      0002 PQ: 0 ANSI: 5
[    6.247917] NET: Registered protocol family 17
[    6.248351] Bluetooth: L2CAP ver 2.15
[    6.248423] Bluetooth: L2CAP socket layer initialized
[    6.248541] Bluetooth: SCO (Voice Link) ver 0.6
[    6.248612] Bluetooth: SCO socket layer initialized
[    6.249866] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.251834] Bluetooth: RFCOMM TTY layer initialized
[    6.251943] Bluetooth: RFCOMM socket layer initialized
[    6.252129] Bluetooth: RFCOMM ver 1.11
[    6.252197] Registering the dns_resolver key type
[    6.252205] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    6.253974] sd 0:0:0:0: [sda] Write Protect is off
[    6.254048] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.254667] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.297231]  sda: sda1 sda2 < sda5 >
[    6.304501] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.568166] ata2: SATA link down (SStatus 0 SControl 300)
[    6.719647] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    6.746807] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
[    6.753469] registered taskstats version 1
[    6.753788] kmemleak: Kernel memory leak detector initialized
[    6.753799] kmemleak: Automatic memory scanning thread started
[    6.756745] rtc_cmos 00:07: setting system clock to 2011-03-04 16:31:07 UTC (1299256267)
[    6.756836] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    6.756907] EDD information not available.
[    6.763371] Freeing unused kernel memory: 524k freed
[    6.763716] Write protecting the kernel read-only data: 8192k
[    6.777366] Freeing unused kernel memory: 1360k freed
[    6.778364] Freeing unused kernel memory: 8k freed
[    7.089143] udevd (119): /proc/119/oom_adj is deprecated, please use /proc/119/oom_score_adj instead.
[    7.462546] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    7.463534] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    7.510024] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    7.537831] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    7.927324] usbcore: registered new interface driver usbfs
[    7.931245] usbcore: registered new interface driver hub
[    7.948831] usbcore: registered new device driver usb
[    8.012304] [drm] Initialized drm 1.1.0 20060810
[    8.015113] uhci_hcd: USB Universal Host Controller Interface driver
[    8.016432] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    8.016546] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    8.016635] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    8.016767] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    8.016777] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    8.017061] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    8.038976] uhci_hcd 0000:00:1a.0: detected 2 ports
[    8.039059] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    8.039066] uhci_hcd 0000:00:1a.0: Performing full reset
[    8.039091] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    8.039464] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    8.040708] usb usb1: default language 0x0409
[    8.041082] usb usb1: udev 1, busnum 1, minor = 0
[    8.041090] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    8.041167] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.041254] usb usb1: Product: UHCI Host Controller
[    8.041323] usb usb1: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    8.041394] usb usb1: SerialNumber: 0000:00:1a.0
[    8.043620] usb usb1: usb_probe_device
[    8.043629] usb usb1: configuration #1 chosen from 1 choice
[    8.043909] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    8.044673] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    8.044751] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    8.044844] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    8.046464] hub 1-0:1.0: usb_probe_interface
[    8.046473] hub 1-0:1.0: usb_probe_interface - got id
[    8.046484] hub 1-0:1.0: USB hub found
[    8.046780] hub 1-0:1.0: 2 ports detected
[    8.046886] hub 1-0:1.0: standalone hub
[    8.046892] hub 1-0:1.0: no power switching (usb 1.0)
[    8.046898] hub 1-0:1.0: individual port over-current protection
[    8.046905] hub 1-0:1.0: power on to power good time: 2ms
[    8.047294] hub 1-0:1.0: local power source is good
[    8.047339] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    8.052205] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    8.052339] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    8.052349] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    8.052540] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    8.068147] uhci_hcd 0000:00:1a.1: detected 2 ports
[    8.068235] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    8.068241] uhci_hcd 0000:00:1a.1: Performing full reset
[    8.068633] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    8.069503] usb usb2: default language 0x0409
[    8.069894] usb usb2: udev 1, busnum 2, minor = 128
[    8.069902] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    8.069983] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.070075] usb usb2: Product: UHCI Host Controller
[    8.070149] usb usb2: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    8.070225] usb usb2: SerialNumber: 0000:00:1a.1
[    8.074981] usb usb2: usb_probe_device
[    8.074993] usb usb2: configuration #1 chosen from 1 choice
[    8.075191] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    8.077269] hub 2-0:1.0: usb_probe_interface
[    8.077277] hub 2-0:1.0: usb_probe_interface - got id
[    8.077288] hub 2-0:1.0: USB hub found
[    8.077591] hub 2-0:1.0: 2 ports detected
[    8.077697] hub 2-0:1.0: standalone hub
[    8.077703] hub 2-0:1.0: no power switching (usb 1.0)
[    8.077709] hub 2-0:1.0: individual port over-current protection
[    8.077716] hub 2-0:1.0: power on to power good time: 2ms
[    8.077943] hub 2-0:1.0: local power source is good
[    8.077986] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    8.087910] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    8.088192] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    8.088329] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    8.088468] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    8.088479] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    8.088683] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    8.096601] uhci_hcd 0000:00:1a.2: detected 2 ports
[    8.096686] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    8.096693] uhci_hcd 0000:00:1a.2: Performing full reset
[    8.096717] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    8.097091] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    8.097949] usb usb3: default language 0x0409
[    8.098329] usb usb3: udev 1, busnum 3, minor = 256
[    8.098337] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    8.098413] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.098500] usb usb3: Product: UHCI Host Controller
[    8.098569] usb usb3: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    8.098641] usb usb3: SerialNumber: 0000:00:1a.2
[    8.103015] usb usb3: usb_probe_device
[    8.103026] usb usb3: configuration #1 chosen from 1 choice
[    8.103215] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    8.104552] hub 3-0:1.0: usb_probe_interface
[    8.104560] hub 3-0:1.0: usb_probe_interface - got id
[    8.104571] hub 3-0:1.0: USB hub found
[    8.104867] hub 3-0:1.0: 2 ports detected
[    8.104974] hub 3-0:1.0: standalone hub
[    8.104980] hub 3-0:1.0: no power switching (usb 1.0)
[    8.104985] hub 3-0:1.0: individual port over-current protection
[    8.104993] hub 3-0:1.0: power on to power good time: 2ms
[    8.105223] hub 3-0:1.0: local power source is good
[    8.105266] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    8.117244] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    8.117359] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    8.117445] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.118184] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    8.118194] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    8.118476] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    8.132064] uhci_hcd 0000:00:1d.0: detected 2 ports
[    8.132143] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    8.132150] uhci_hcd 0000:00:1d.0: Performing full reset
[    8.132174] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    8.132548] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    8.133506] usb usb4: default language 0x0409
[    8.133898] usb usb4: udev 1, busnum 4, minor = 384
[    8.133905] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    8.133981] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.134069] usb usb4: Product: UHCI Host Controller
[    8.134138] usb usb4: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    8.134210] usb usb4: SerialNumber: 0000:00:1d.0
[    8.136743] usb usb4: usb_probe_device
[    8.136752] usb usb4: configuration #1 chosen from 1 choice
[    8.136938] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    8.138231] hub 4-0:1.0: usb_probe_interface
[    8.138238] hub 4-0:1.0: usb_probe_interface - got id
[    8.138249] hub 4-0:1.0: USB hub found
[    8.138544] hub 4-0:1.0: 2 ports detected
[    8.138650] hub 4-0:1.0: standalone hub
[    8.138655] hub 4-0:1.0: no power switching (usb 1.0)
[    8.138661] hub 4-0:1.0: individual port over-current protection
[    8.138669] hub 4-0:1.0: power on to power good time: 2ms
[    8.138893] hub 4-0:1.0: local power source is good
[    8.138936] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    8.144328] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.147617] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    8.147732] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    8.147819] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    8.148105] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    8.148115] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    8.148316] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 5
[    8.164643] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    8.164657] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    8.165050] ehci_hcd 0000:00:1a.7: debug port 1
[    8.165127] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    8.169041] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    8.169048] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    8.169412] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    8.169491] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    8.173397] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    8.176157] uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
[    8.184093] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    8.184990] usb usb5: default language 0x0409
[    8.185371] usb usb5: udev 1, busnum 5, minor = 512
[    8.185379] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    8.185455] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.185542] usb usb5: Product: EHCI Host Controller
[    8.185611] usb usb5: Manufacturer: Linux 2.6.38-rc6+ ehci_hcd
[    8.185683] usb usb5: SerialNumber: 0000:00:1a.7
[    8.187591] usb usb5: usb_probe_device
[    8.187600] usb usb5: configuration #1 chosen from 1 choice
[    8.187786] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    8.189180] hub 5-0:1.0: usb_probe_interface
[    8.189188] hub 5-0:1.0: usb_probe_interface - got id
[    8.189198] hub 5-0:1.0: USB hub found
[    8.189532] hub 5-0:1.0: 6 ports detected
[    8.189634] hub 5-0:1.0: standalone hub
[    8.189640] hub 5-0:1.0: no power switching (usb 1.0)
[    8.189645] hub 5-0:1.0: individual port over-current protection
[    8.189653] hub 5-0:1.0: power on to power good time: 20ms
[    8.189882] hub 5-0:1.0: local power source is good
[    8.189923] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    8.194097] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    8.194134] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    8.194168] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    8.194789] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    8.194922] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    8.194933] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    8.195156] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    8.204309] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.208108] uhci_hcd 0000:00:1d.1: detected 2 ports
[    8.208191] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    8.208197] uhci_hcd 0000:00:1d.1: Performing full reset
[    8.208600] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    8.209451] usb usb6: default language 0x0409
[    8.209839] usb usb6: udev 1, busnum 6, minor = 640
[    8.209847] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    8.209924] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.210009] usb usb6: Product: UHCI Host Controller
[    8.210079] usb usb6: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    8.210151] usb usb6: SerialNumber: 0000:00:1d.1
[    8.212268] usb usb6: usb_probe_device
[    8.212277] usb usb6: configuration #1 chosen from 1 choice
[    8.212466] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    8.213790] hub 6-0:1.0: usb_probe_interface
[    8.213798] hub 6-0:1.0: usb_probe_interface - got id
[    8.213808] hub 6-0:1.0: USB hub found
[    8.214104] hub 6-0:1.0: 2 ports detected
[    8.214210] hub 6-0:1.0: standalone hub
[    8.214215] hub 6-0:1.0: no power switching (usb 1.0)
[    8.214221] hub 6-0:1.0: individual port over-current protection
[    8.214228] hub 6-0:1.0: power on to power good time: 2ms
[    8.214458] hub 6-0:1.0: local power source is good
[    8.214503] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    8.218910] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    8.219049] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    8.219059] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    8.219249] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    8.232245] uhci_hcd 0000:00:1d.2: detected 2 ports
[    8.232329] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    8.232336] uhci_hcd 0000:00:1d.2: Performing full reset
[    8.232463] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    8.233331] usb usb7: default language 0x0409
[    8.233726] usb usb7: udev 1, busnum 7, minor = 768
[    8.233733] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    8.233810] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.233896] usb usb7: Product: UHCI Host Controller
[    8.233965] usb usb7: Manufacturer: Linux 2.6.38-rc6+ uhci_hcd
[    8.234037] usb usb7: SerialNumber: 0000:00:1d.2
[    8.235994] usb usb7: usb_probe_device
[    8.236200] usb usb7: configuration #1 chosen from 1 choice
[    8.236328] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.238678] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    8.240044] hub 7-0:1.0: usb_probe_interface
[    8.240052] hub 7-0:1.0: usb_probe_interface - got id
[    8.240063] hub 7-0:1.0: USB hub found
[    8.240360] hub 7-0:1.0: 2 ports detected
[    8.240467] hub 7-0:1.0: standalone hub
[    8.240473] hub 7-0:1.0: no power switching (usb 1.0)
[    8.240479] hub 7-0:1.0: individual port over-current protection
[    8.240486] hub 7-0:1.0: power on to power good time: 2ms
[    8.240719] hub 7-0:1.0: local power source is good
[    8.240763] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    8.245864] i915 0000:00:02.0: power state changed by ACPI to D0
[    8.245986] i915 0000:00:02.0: power state changed by ACPI to D0
[    8.246074] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.246156] i915 0000:00:02.0: setting latency timer to 64
[    8.276115] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.288270] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[    8.288298] hub 5-0:1.0: port 3: status 0501 change 0001
[    8.312222] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.340206] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.388089] hub 5-0:1.0: state 7 ports 6 chg 0008 evt 0000
[    8.388165] hub 5-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    8.444300] ehci_hcd 0000:00:1a.7: port 3 full speed --> companion
[    8.444314] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    8.444340] hub 5-0:1.0: port 3 not reset yet, waiting 50ms
[    8.500118] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    8.500350] hub 5-0:1.0: state 7 ports 6 chg 0000 evt 0008
[    8.584166] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    8.584225] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    8.584304] hub 2-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    8.657362] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    8.657552] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    8.657632] [drm] Driver supports precise vblank timestamp query.
[    8.712144] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    8.824129] usb 2-1: new full speed USB device using uhci_hcd and address 2
[    8.908624] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    8.960290] usb 2-1: ep0 maxpacket = 8
[    8.987116] usb 2-1: default language 0x0409
[    8.996383] usb 2-1: udev 2, busnum 2, minor = 129
[    8.996394] usb 2-1: New USB device found, idVendor=08ff, idProduct=2810
[    8.996476] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    8.996553] usb 2-1: Product: Fingerprint Sensor
[    8.998224] usb 2-1: usb_probe_device
[    8.998234] usb 2-1: configuration #1 chosen from 1 choice
[    9.001107] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    9.006076] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    9.080266] usb usb1: suspend_rh (auto-stop)
[    9.316772] fb0: inteldrmfb frame buffer device
[    9.316847] drm: registered panic notifier
[    9.328082] usb usb3: suspend_rh (auto-stop)
[    9.328121] usb usb4: suspend_rh (auto-stop)
[    9.328155] usb usb6: suspend_rh (auto-stop)
[    9.328190] usb usb7: suspend_rh (auto-stop)
[    9.562906] acpi device:02: registered as cooling_device2
[    9.571336] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    9.573034] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    9.574714] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    9.575019] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    9.575137] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    9.575266] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    9.575488] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    9.575499] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    9.575689] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    9.588627] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    9.588641] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    9.589047] ehci_hcd 0000:00:1d.7: debug port 1
[    9.589124] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    9.593027] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    9.593034] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    9.593424] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    9.593504] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    9.597385] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    9.608341] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    9.609287] usb usb8: default language 0x0409
[    9.609707] usb usb8: udev 1, busnum 8, minor = 896
[    9.609715] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[    9.609791] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.609878] usb usb8: Product: EHCI Host Controller
[    9.609948] usb usb8: Manufacturer: Linux 2.6.38-rc6+ ehci_hcd
[    9.610019] usb usb8: SerialNumber: 0000:00:1d.7
[    9.612442] usb usb8: usb_probe_device
[    9.612452] usb usb8: configuration #1 chosen from 1 choice
[    9.612653] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    9.614031] hub 8-0:1.0: usb_probe_interface
[    9.614038] hub 8-0:1.0: usb_probe_interface - got id
[    9.614049] hub 8-0:1.0: USB hub found
[    9.614415] hub 8-0:1.0: 6 ports detected
[    9.614520] hub 8-0:1.0: standalone hub
[    9.614526] hub 8-0:1.0: no power switching (usb 1.0)
[    9.614532] hub 8-0:1.0: individual port over-current protection
[    9.614540] hub 8-0:1.0: power on to power good time: 20ms
[    9.614781] hub 8-0:1.0: local power source is good
[    9.614825] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    9.621622] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    9.621660] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    9.621699] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    9.637519] Console: switching to colour frame buffer device 180x56
[    9.712537] hub 8-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   10.515093] PM: Starting manual resume from disk
[   10.574701] EXT3-fs: barriers not enabled
[   10.593317] kjournald starting.  Commit interval 5 seconds
[   10.593780] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   10.808224] hub 1-0:1.0: hub_suspend
[   10.808329] usb usb1: bus auto-suspend
[   10.808338] usb usb1: suspend_rh
[   10.808374] hub 3-0:1.0: hub_suspend
[   10.808388] usb usb3: bus auto-suspend
[   10.808394] usb usb3: suspend_rh
[   10.808424] hub 4-0:1.0: hub_suspend
[   10.808437] usb usb4: bus auto-suspend
[   10.808444] usb usb4: suspend_rh
[   10.808474] hub 6-0:1.0: hub_suspend
[   10.808487] usb usb6: bus auto-suspend
[   10.808493] usb usb6: suspend_rh
[   10.808523] hub 7-0:1.0: hub_suspend
[   10.808536] usb usb7: bus auto-suspend
[   10.808542] usb usb7: suspend_rh
[   10.824201] hub 5-0:1.0: hub_suspend
[   10.824221] usb usb5: bus auto-suspend
[   10.824228] ehci_hcd 0000:00:1a.7: suspend root hub
[   11.808105] hub 8-0:1.0: hub_suspend
[   11.808133] usb usb8: bus auto-suspend
[   11.808141] ehci_hcd 0000:00:1d.7: suspend root hub
[   13.170151] Adding 5791396k swap on /dev/sda5.  Priority:-1 extents:1 across:5791396k 
[   13.678918] EXT3-fs (sda1): using internal journal
[   13.755148] udev: starting version 147
[   17.249810] ip_tables: (C) 2000-2006 Netfilter Core Team
[   17.838049] cfg80211: Calling CRDA to update world regulatory domain
[   19.188576] cfg80211: World regulatory domain updated:
[   19.188586] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   19.188595] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   19.188604] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   19.188611] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   19.188619] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   19.188627] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   23.468701] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   23.469299] HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[   23.469706] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   23.581704] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   23.581713] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   23.582129] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   23.582148] iwlagn 0000:03:00.0: setting latency timer to 64
[   23.582319] iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   23.603794] iwlagn 0000:03:00.0: device EEPROM VER=0x11f, CALIB=0x4
[   23.603801] iwlagn 0000:03:00.0: Device SKU: 0Xb
[   23.603893] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   23.604135] iwlagn 0000:03:00.0: irq 44 for MSI/MSI-X
[   24.085764] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   24.140226] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[   24.141792] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   24.914758] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[   25.006479] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   36.568181] usb usb8: usb auto-resume
[   36.568194] ehci_hcd 0000:00:1d.7: resume root hub
[   36.596093] hub 8-0:1.0: hub_resume
[   36.596704] hub 8-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   36.597426] usb usb1: usb auto-resume
[   36.597435] usb usb1: wakeup_rh
[   36.636048] hub 1-0:1.0: hub_resume
[   36.636521] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   36.636670] usb usb7: usb auto-resume
[   36.636680] usb usb7: wakeup_rh
[   36.680089] hub 7-0:1.0: hub_resume
[   36.680727] usb usb6: usb auto-resume
[   36.680736] usb usb6: wakeup_rh
[   36.680758] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   36.720161] hub 6-0:1.0: hub_resume
[   36.720768] usb usb5: usb auto-resume
[   36.720780] ehci_hcd 0000:00:1a.7: resume root hub
[   36.720819] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   36.772049] hub 5-0:1.0: hub_resume
[   36.773023] usb usb4: usb auto-resume
[   36.773034] usb usb4: wakeup_rh
[   36.774480] hub 5-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   36.816080] hub 4-0:1.0: hub_resume
[   36.816340] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   36.816771] usb usb3: usb auto-resume
[   36.816782] usb usb3: wakeup_rh
[   36.856125] hub 3-0:1.0: hub_resume
[   36.860127] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   37.848052] usb usb6: suspend_rh (auto-stop)
[   37.848082] usb usb1: suspend_rh (auto-stop)
[   37.848121] usb usb7: suspend_rh (auto-stop)
[   37.848156] usb usb4: suspend_rh (auto-stop)
[   37.848192] usb usb3: suspend_rh (auto-stop)
[   38.980191] hub 1-0:1.0: hub_suspend
[   38.980218] usb usb1: bus auto-suspend
[   38.980226] usb usb1: suspend_rh
[   38.980260] hub 7-0:1.0: hub_suspend
[   38.980274] usb usb7: bus auto-suspend
[   38.980280] usb usb7: suspend_rh
[   38.980310] hub 6-0:1.0: hub_suspend
[   38.980323] usb usb6: bus auto-suspend
[   38.980329] usb usb6: suspend_rh
[   38.980359] hub 5-0:1.0: hub_suspend
[   38.980372] usb usb5: bus auto-suspend
[   38.980379] ehci_hcd 0000:00:1a.7: suspend root hub
[   38.980425] hub 8-0:1.0: hub_suspend
[   38.980438] usb usb8: bus auto-suspend
[   38.980444] ehci_hcd 0000:00:1d.7: suspend root hub
[   38.980487] hub 4-0:1.0: hub_suspend
[   38.980500] usb usb4: bus auto-suspend
[   38.980506] usb usb4: suspend_rh
[   38.980536] hub 3-0:1.0: hub_suspend
[   38.980549] usb usb3: bus auto-suspend
[   38.980555] usb usb3: suspend_rh
[   39.424124] usb usb8: usb auto-resume
[   39.424139] ehci_hcd 0000:00:1d.7: resume root hub
[   39.452090] hub 8-0:1.0: hub_resume
[   39.452723] hub 8-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   39.453098] usb usb1: usb auto-resume
[   39.453108] usb usb1: wakeup_rh
[   39.492396] hub 1-0:1.0: hub_resume
[   39.493070] usb usb7: usb auto-resume
[   39.493079] usb usb7: wakeup_rh
[   39.493170] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   39.532106] hub 7-0:1.0: hub_resume
[   39.532370] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   39.532698] usb usb6: usb auto-resume
[   39.532707] usb usb6: wakeup_rh
[   39.572131] hub 6-0:1.0: hub_resume
[   39.572412] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   39.572784] usb usb5: usb auto-resume
[   39.572796] ehci_hcd 0000:00:1a.7: resume root hub
[   39.624151] hub 5-0:1.0: hub_resume
[   39.624929] hub 5-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   39.625120] usb usb4: usb auto-resume
[   39.625130] usb usb4: wakeup_rh
[   39.664055] hub 4-0:1.0: hub_resume
[   39.664314] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   39.664692] usb usb3: usb auto-resume
[   39.664702] usb usb3: wakeup_rh
[   39.704288] hub 3-0:1.0: hub_resume
[   39.704620] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   40.576063] usb usb1: suspend_rh (auto-stop)
[   40.576103] usb usb7: suspend_rh (auto-stop)
[   40.576138] usb usb6: suspend_rh (auto-stop)
[   40.824070] usb usb4: suspend_rh (auto-stop)
[   40.824112] usb usb3: suspend_rh (auto-stop)
[   41.808121] hub 8-0:1.0: hub_suspend
[   41.808149] usb usb8: bus auto-suspend
[   41.808157] ehci_hcd 0000:00:1d.7: suspend root hub
[   41.808206] hub 1-0:1.0: hub_suspend
[   41.808220] usb usb1: bus auto-suspend
[   41.808228] usb usb1: suspend_rh
[   41.808259] hub 7-0:1.0: hub_suspend
[   41.808274] usb usb7: bus auto-suspend
[   41.808281] usb usb7: suspend_rh
[   41.808310] hub 6-0:1.0: hub_suspend
[   41.808322] usb usb6: bus auto-suspend
[   41.808329] usb usb6: suspend_rh
[   41.808359] hub 5-0:1.0: hub_suspend
[   41.808372] usb usb5: bus auto-suspend
[   41.808378] ehci_hcd 0000:00:1a.7: suspend root hub
[   41.808421] hub 4-0:1.0: hub_suspend
[   41.808435] usb usb4: bus auto-suspend
[   41.808441] usb usb4: suspend_rh
[   41.808470] hub 3-0:1.0: hub_suspend
[   41.808483] usb usb3: bus auto-suspend
[   41.808489] usb usb3: suspend_rh
[  114.586822] kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[  161.540661] irq 23: nobody cared (try booting with the "irqpoll" option)
[  161.540674] Pid: 0, comm: kworker/0:0 Not tainted 2.6.38-rc6+ #768
[  161.540680] Call Trace:
[  161.540686]  <IRQ>  [<ffffffff8109a2a6>] ? __report_bad_irq+0x26/0xa0
[  161.540710]  [<ffffffff8109a4ac>] ? note_interrupt+0x18c/0x1d0
[  161.540721]  [<ffffffff8109ae2d>] ? handle_fasteoi_irq+0xcd/0x100
[  161.540732]  [<ffffffff8100543d>] ? handle_irq+0x1d/0x30
[  161.540740]  [<ffffffff81004bb8>] ? do_IRQ+0x58/0xd0
[  161.540751]  [<ffffffff8149fad3>] ? ret_from_intr+0x0/0xe
[  161.540756]  <EOI>  [<ffffffff8126f5d0>] ? acpi_idle_enter_c1+0x7e/0x99
[  161.540776]  [<ffffffff8126f5b2>] ? acpi_idle_enter_c1+0x60/0x99
[  161.540787]  [<ffffffff8138b0c2>] ? cpuidle_idle_call+0x82/0xf0
[  161.540797]  [<ffffffff81001906>] ? cpu_idle+0x56/0xb0
[  161.540808]  [<ffffffff81498b4a>] ? start_secondary+0x1c1/0x1c8
[  161.540818]  [<ffffffff812658c2>] ? acpi_ps_parse_loop+0x2cb/0x95d
[  161.540828]  [<ffffffff8126363b>] ? acpi_ns_one_complete_parse+0x103/0x120
[  161.540835] handlers:
[  161.540840] [<ffffffffa00f34c0>] (usb_hcd_irq+0x0/0x70 [usbcore])
[  161.540870] Disabling IRQ #23

--ReaqsoxgOBHFXBhH--
