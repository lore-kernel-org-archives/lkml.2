Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab2INTPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 15:15:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44514 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab2INTP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 15:15:27 -0400
Date: Fri, 14 Sep 2012 21:15:35 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Sami Liedes <sami.liedes@iki.fi>
Cc: Vegard Nossum <vegardno@ifi.uio.no>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: kmemcheck: Fatal error; system fails to boot when kmemcheck
 enabled
Message-ID: <20120914191535.GA5992@joi.lan>
References: <20120712213305.GA11128@sli.dy.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712213305.GA11128@sli.dy.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 12:33:07AM +0300, Sami Liedes wrote:
> Hi,
> 
> Kernel 3.4.4 with kmemcheck enabled does not correctly boot on my
> system, which is a x86-64, Core i7 Sandy Bridge computer with Asus
> P8P67-EVO motherboard. The errors seem to be related to ACPI, but
> there may be other things wrong. Userspace programs, particularly init
> and in other cases some other binaries run from initramfs die with
> SIGTRAP.
> 

I have similar stacktraces and I'm unable to boot with kmemcheck
on 3.6-rc5 kernel.

It's interesting that there are no lockdep/smp errors with kmemcheck disabled,
so kmemcheck probably messes up irq state.

[    0.000000] Linux version 3.6.0-rc5+ (marcin@joi) (gcc version 4.6.3 (Gentoo 4.6.3 p1.6, pie-0.5.2) ) #1147 SMP PREEMPT Fri Sep 14 19:11:15 CEST 2012
[    0.000000] Command line: root=UUID=a55f9cc0-8726-4a17-9198-a153da676c85 netconsole=33333@192.168.1.123/eth0,8888@192.168.1.102/00:06:5b:6a:a5:74 no_console_suspend
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e4c00-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf77ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf780000-0x00000000bf797fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf798000-0x00000000bf7dbfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf7dc000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000001bfffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.5 present.
[    0.000000] DMI: System manufacturer System Product Name/P6T SE, BIOS 0603    09/02/2009
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1c0000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E3FFF write-protect
[    0.000000]   E4000-EBFFF write-through
[    0.000000]   EC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 1C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 000000000 mask E00000000 write-back
[    0.000000]   2 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   3 base 0BF800000 mask FFF800000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 7GB, range: 1GB, type UC
[    0.000000] reg 1, base: 0GB, range: 8GB, type WB
[    0.000000] reg 2, base: 3GB, range: 1GB, type UC
[    0.000000] reg 3, base: 3064MB, range: 8MB, type UC
[    0.000000] total RAM covered: 6136M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 5  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3064MB, range: 8MB, type UC
[    0.000000] reg 3, base: 4GB, range: 2GB, type WB
[    0.000000] reg 4, base: 6GB, range: 1GB, type WB
[    0.000000] e820: update [mem 0xbf800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbf780 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xbf77ffff]
[    0.000000]  [mem 0x00000000-0xbf77ffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xbf77ffff @ [mem 0x1fa00000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1bfffffff]
[    0.000000]  [mem 0x100000000-0x1bfffffff] page 4k
[    0.000000] kernel direct mapping tables up to 0x1bfffffff @ [mem 0xbe978000-0xbf77ffff]
[    0.000000] ACPI: RSDP 00000000000fb250 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf780100 00064 (v01 090209 XSDT1920 20090902 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf780290 000F4 (v03 090209 FACP1920 20090902 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7804b0 0C2E4 (v01  A1279 A1279001 00000001 INTL 20060113)
[    0.000000] ACPI: FACS 00000000bf798000 00040
[    0.000000] ACPI: APIC 00000000bf780390 000D8 (v01 090209 APIC1920 20090902 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf780470 0003C (v01 090209 OEMMCFG  20090902 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf798040 00072 (v01 090209 OEMB1920 20090902 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf78f4b0 00038 (v01 090209 OEMHPET  20090902 MSFT 00000097)
[    0.000000] ACPI: DMAR 00000000bf7980c0 00138 (v01    AMI  OEMDMAR 00000001 MSFT 00000097)
[    0.000000] ACPI: OSFR 00000000bf78f4f0 000B0 (v01 090209 OEMOSFR  20090902 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf79a280 0249F (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0006ffffff] PMD -> [ffff8801b9600000-ffff8801bf5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x1bfffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xbf77ffff]
[    0.000000]   node   0: [mem 0x100000000-0x1bfffffff]
[    0.000000] On node 0 totalpages: 1570575
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 763840 pages, LIFO batch:31
[    0.000000]   Normal zone: 12288 pages used for memmap
[    0.000000]   Normal zone: 774144 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec8a000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec8a000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: 16 Processors exceeds NR_CPUS limit of 8
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] e820: [mem 0xc0000000-0xfedfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8801bfc00000 s76800 r8192 d21504 u262144
[    0.000000] pcpu-alloc: s76800 r8192 d21504 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1541897
[    0.000000] Kernel command line: root=UUID=a55f9cc0-8726-4a17-9198-a153da676c85 netconsole=33333@192.168.1.123/eth0,8888@192.168.1.102/00:06:5b:6a:a5:74 no_console_suspend
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 6065372k/7340032k available (6296k kernel code, 1057732k absent, 216928k reserved, 6493k data, 1760k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] NR_IRQS:4352 nr_irqs:1152 16
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
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] ODEBUG: 19 of 19 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] kmemleak: Early log buffer exceeded (751), please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.010000] tsc: Detected 2672.950 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 5345.90 BogoMIPS (lpj=26729500)
[    0.000973] pid_max: default: 32768 minimum: 301
[    0.017065] Mount-cache hash table entries: 256
[    0.073948] CPU: Physical Processor ID: 0
[    0.074341] CPU: Processor Core ID: 0
[    0.074713] mce: CPU supports 9 MCE banks
[    0.075299] CPU0: Thermal monitoring enabled (TM1)
[    0.075783] process: using mwait in idle threads
[    0.076215] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.076215] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.076215] tlb_flushall_shift is 0x6
[    0.077618] ACPI: Core revision 20120711
[    1.957659] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    2.058160] smpboot: CPU0: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
[    2.176802] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events, Intel PMU driver.
[    2.177810] perf_event_intel: CPU erratum AAJ80 worked around
[    2.178311] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    2.178887] ... version:                3
[    2.179279] ... bit width:              48
[    2.179676] ... generic registers:      4
[    2.180068] ... value mask:             0000ffffffffffff
[    2.180541] ... max period:             000000007fffffff
[    2.181014] ... fixed-purpose events:   3
[    2.181406] ... event mask:             000000070000000f
[    2.182254] kmemcheck: Limiting number of CPUs to 1.
[    2.182706] kmemcheck: Initialized
[    2.213167] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    2.216026] Brought up 1 CPUs
[    2.216354] smpboot: Total of 1 processors activated (5345.90 BogoMIPS)
[    2.239681] devtmpfs: initialized
[    2.269979] PM: Registering ACPI NVS region [mem 0xbf798000-0xbf7dbfff] (278528 bytes)
[    2.291778] NET: Registered protocol family 16
[    2.339190] ACPI: bus type pci registered
[    2.351369] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    2.352193] PCI: not using MMCONFIG
[    2.352595] PCI: Using configuration type 1 for base access
[    3.017200] ------------[ cut here ]------------
[    3.017203] ------------[ cut here ]------------
[    3.017208] WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_fault+0xb9/0xd0()

this is WARN_ON_ONCE(in_nmi());

[    3.017209] Hardware name: System Product Name
[    3.017210] Modules linked in:
[    3.017211] Pid: 1, comm: swapper/0 Not tainted 3.6.0-rc5+ #1147
[    3.017212] Call Trace:
[    3.017217]  <NMI>  [<ffffffff9006f12a>] warn_slowpath_common+0x7a/0xb0
[    3.017219]  [<ffffffff9006f175>] warn_slowpath_null+0x15/0x20
[    3.017220]  [<ffffffff90069c89>] kmemcheck_fault+0xb9/0xd0
[    3.017222]  [<ffffffff90063d9e>] do_page_fault+0x3ae/0x490
[    3.017225]  [<ffffffff90364bd2>] ? put_dec+0x72/0x90
[    3.017226]  [<ffffffff903656f4>] ? number.isra.2+0x304/0x330
[    3.017228]  [<ffffffff90368cad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    3.017232]  [<ffffffff906206ef>] page_fault+0x1f/0x30
[    3.017235]  [<ffffffff903f136f>] ? vt_console_print+0x9f/0x3a0
[    3.017237]  [<ffffffff903f1334>] ? vt_console_print+0x64/0x3a0
[    3.017239]  [<ffffffff9006faf8>] ? msg_print_text+0x158/0x1b0
[    3.017241]  [<ffffffff90070983>] call_console_drivers.constprop.12+0x93/0xb0
[    3.017242]  [<ffffffff90070b94>] console_unlock+0x1f4/0x460
[    3.017244]  [<ffffffff900710ae>] vprintk_emit+0x19e/0x520
[    3.017246]  [<ffffffff90069c89>] ? kmemcheck_fault+0xb9/0xd0
[    3.017248]  [<ffffffff90615523>] printk+0x5c/0x5e
[    3.017250]  [<ffffffff90069c89>] ? kmemcheck_fault+0xb9/0xd0
[    3.017252]  [<ffffffff9006f0e8>] warn_slowpath_common+0x38/0xb0
[    3.017253]  [<ffffffff9006f175>] warn_slowpath_null+0x15/0x20
[    3.017255]  [<ffffffff90069c89>] kmemcheck_fault+0xb9/0xd0
[    3.017256]  [<ffffffff90063d9e>] do_page_fault+0x3ae/0x490
[    3.017258]  [<ffffffff90368cad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    3.017260]  [<ffffffff906206ef>] page_fault+0x1f/0x30
[    3.017263]  [<ffffffff90048ad2>] ? x86_perf_event_update+0x2/0x70
[    3.017265]  [<ffffffff9004e591>] ? intel_pmu_save_and_restart+0x11/0x20
[    3.017266]  [<ffffffff9004e6c1>] intel_pmu_handle_irq+0x121/0x300
[    3.017268]  [<ffffffff900489d1>] perf_event_nmi_handler+0x21/0x30
[    3.017271]  [<ffffffff9003c9b6>] nmi_handle.isra.1+0xa6/0x1f0
[    3.017272]  [<ffffffff9003c910>] ? __register_nmi_handler+0x190/0x190
[    3.017274]  [<ffffffff9003cc18>] do_nmi+0x118/0x390
[    3.017277]  [<ffffffff9015fb06>] ? __d_free+0x46/0x70
[    3.017278]  [<ffffffff90620a76>] end_repeat_nmi+0x1e/0x2e
[    3.017280]  [<ffffffff9015fb06>] ? __d_free+0x46/0x70
[    3.017282]  [<ffffffff90069800>] ? kmemcheck_show_all+0x50/0x60
[    3.017283]  [<ffffffff90069800>] ? kmemcheck_show_all+0x50/0x60
[    3.017285]  [<ffffffff90069800>] ? kmemcheck_show_all+0x50/0x60
[    3.017288]  <<EOE>>  <IRQ>  [<ffffffff90069896>] kmemcheck_show+0x36/0x90
[    3.017290]  [<ffffffff90069c5a>] kmemcheck_fault+0x8a/0xd0
[    3.017291]  [<ffffffff90063d9e>] do_page_fault+0x3ae/0x490
[    3.017293]  [<ffffffff90063d9e>] ? do_page_fault+0x3ae/0x490
[    3.017294]  [<ffffffff90368cad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    3.017296]  [<ffffffff9015fb06>] ? __d_free+0x46/0x70
[    3.017297]  [<ffffffff906206ef>] page_fault+0x1f/0x30
[    3.017299]  [<ffffffff9015fb06>] ? __d_free+0x46/0x70
[    3.017302]  [<ffffffff9013da60>] ? kmemcheck_slab_free+0x10/0x30
[    3.017303]  [<ffffffff9013b0a5>] kmem_cache_free+0x75/0x150
[    3.017305]  [<ffffffff9015fb06>] __d_free+0x46/0x70
[    3.017307]  [<ffffffff900eb314>] rcu_process_callbacks+0x244/0x550
[    3.017309]  [<ffffffff90077c40>] __do_softirq+0xc0/0x180
[    3.017311]  [<ffffffff9062205c>] call_softirq+0x1c/0x30
[    3.017312]  [<ffffffff9003ac65>] do_softirq+0x85/0xc0
[    3.017313]  [<ffffffff90078056>] irq_exit+0xa6/0xe0
[    3.017316]  [<ffffffff9005a799>] smp_apic_timer_interrupt+0x69/0xa0
[    3.017318]  [<ffffffff906218dc>] apic_timer_interrupt+0x6c/0x80
[    3.017320]  <EOI>  [<ffffffff90620939>] ? error_exit+0x29/0xb0
[    3.017323]  [<ffffffff9035f93a>] ? kset_find_obj+0x2a/0x90
[    3.017326]  [<ffffffff90ca519b>] locate_module_kobject+0x1d/0xcc
[    3.017327]  [<ffffffff90ca5350>] param_sysfs_init+0x106/0x183
[    3.017329]  [<ffffffff90ca3fb5>] ? sysenter_setup+0xcb/0x2d1
[    3.017330]  [<ffffffff90ca524a>] ? locate_module_kobject+0xcc/0xcc
[    3.017333]  [<ffffffff900001ba>] do_one_initcall+0x3a/0x170
[    3.017336]  [<ffffffff90c92c22>] kernel_init+0x106/0x18a
[    3.017337]  [<ffffffff90c92573>] ? do_early_param+0x86/0x86
[    3.017339]  [<ffffffff90621f64>] kernel_thread_helper+0x4/0x10
[    3.017340]  [<ffffffff906204dd>] ? retint_restore_args+0xe/0xe
[    3.017342]  [<ffffffff90c92b1c>] ? start_kernel+0x34f/0x34f
[    3.017343]  [<ffffffff90621f60>] ? gs_change+0xb/0xb
[    3.017348] ---[ end trace bf05093e9b9b8a7e ]---
[    3.055692] WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_fault+0xb9/0xd0()
[    3.056441] Hardware name: System Product Name
[    3.056860] Modules linked in:
[    3.057248] Pid: 1, comm: swapper/0 Tainted: G        W    3.6.0-rc5+ #1147
[    3.057825] Call Trace:
[    3.058119]  <NMI>  [<ffffffff9006f12a>] warn_slowpath_common+0x7a/0xb0
[    3.058795]  [<ffffffff9006f175>] warn_slowpath_null+0x15/0x20
[    3.059303]  [<ffffffff90069c89>] kmemcheck_fault+0xb9/0xd0
[    3.059795]  [<ffffffff90063d9e>] do_page_fault+0x3ae/0x490
[    3.060286]  [<ffffffff90368cad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    3.060838]  [<ffffffff906206ef>] page_fault+0x1f/0x30
[    3.061302]  [<ffffffff90048ad2>] ? x86_perf_event_update+0x2/0x70
[    3.061831]  [<ffffffff9004e591>] ? intel_pmu_save_and_restart+0x11/0x20
[    3.062393]  [<ffffffff9004e6c1>] intel_pmu_handle_irq+0x121/0x300
[    3.062923]  [<ffffffff900489d1>] perf_event_nmi_handler+0x21/0x30
[    3.063452]  [<ffffffff9003c9b6>] nmi_handle.isra.1+0xa6/0x1f0
[    3.063960]  [<ffffffff9003c910>] ? __register_nmi_handler+0x190/0x190
[    3.064511]  [<ffffffff9003cc18>] do_nmi+0x118/0x390
[    3.064964]  [<ffffffff9015fb06>] ? __d_free+0x46/0x70
[    3.065428]  [<ffffffff90620a76>] end_repeat_nmi+0x1e/0x2e
[    3.065914]  [<ffffffff9015fb06>] ? __d_free+0x46/0x70
[    3.066378]  [<ffffffff90069800>] ? kmemcheck_show_all+0x50/0x60
[    3.066897]  [<ffffffff90069800>] ? kmemcheck_show_all+0x50/0x60
[    3.067416]  [<ffffffff90069800>] ? kmemcheck_show_all+0x50/0x60
[    3.067933]  <<EOE>>  <IRQ>  [<ffffffff90069896>] kmemcheck_show+0x36/0x90
[    3.068689]  [<ffffffff90069c5a>] kmemcheck_fault+0x8a/0xd0
[    3.069180]  [<ffffffff90063d9e>] do_page_fault+0x3ae/0x490
[    3.069671]  [<ffffffff90063d9e>] ? do_page_fault+0x3ae/0x490
[    3.070174]  [<ffffffff90368cad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    3.070725]  [<ffffffff9015fb06>] ? __d_free+0x46/0x70
[    3.071189]  [<ffffffff906206ef>] page_fault+0x1f/0x30
[    3.071653]  [<ffffffff9015fb06>] ? __d_free+0x46/0x70
[    3.072117]  [<ffffffff9013da60>] ? kmemcheck_slab_free+0x10/0x30
[    3.072641]  [<ffffffff9013b0a5>] kmem_cache_free+0x75/0x150
[    3.073137]  [<ffffffff9015fb06>] __d_free+0x46/0x70
[    3.073590]  [<ffffffff900eb314>] rcu_process_callbacks+0x244/0x550
[    3.074125]  [<ffffffff90077c40>] __do_softirq+0xc0/0x180
[    3.074605]  [<ffffffff9062205c>] call_softirq+0x1c/0x30
[    3.075080]  [<ffffffff9003ac65>] do_softirq+0x85/0xc0
[    3.075544]  [<ffffffff90078056>] irq_exit+0xa6/0xe0
[    3.075996]  [<ffffffff9005a799>] smp_apic_timer_interrupt+0x69/0xa0
[    3.076537]  [<ffffffff906218dc>] apic_timer_interrupt+0x6c/0x80
[    3.077054]  <EOI>  [<ffffffff90620939>] ? error_exit+0x29/0xb0
[    3.077687]  [<ffffffff9035f93a>] ? kset_find_obj+0x2a/0x90
[    3.078178]  [<ffffffff90ca519b>] locate_module_kobject+0x1d/0xcc
[    3.078702]  [<ffffffff90ca5350>] param_sysfs_init+0x106/0x183
[    3.079209]  [<ffffffff90ca3fb5>] ? sysenter_setup+0xcb/0x2d1
[    3.079711]  [<ffffffff90ca524a>] ? locate_module_kobject+0xcc/0xcc
[    3.080246]  [<ffffffff900001ba>] do_one_initcall+0x3a/0x170
[    3.080743]  [<ffffffff90c92c22>] kernel_init+0x106/0x18a
[    3.081223]  [<ffffffff90c92573>] ? do_early_param+0x86/0x86
[    3.081720]  [<ffffffff90621f64>] kernel_thread_helper+0x4/0x10
[    3.082233]  [<ffffffff906204dd>] ? retint_restore_args+0xe/0xe
[    3.082746]  [<ffffffff90c92b1c>] ? start_kernel+0x34f/0x34f
[    3.083242]  [<ffffffff90621f60>] ? gs_change+0xb/0xb
[    3.083700] ---[ end trace bf05093e9b9b8a7f ]---
[    3.084414] ERROR: kmemcheck: Fatal error
[    3.084808] Pid: 1, comm: swapper/0 Tainted: G        W    3.6.0-rc5+ #1147 System manufacturer System Product Name/P6T SE
[    3.085736] RIP: 0010:[<ffffffff9013da60>]  [<ffffffff9013da60>] kmemcheck_slab_free+0x10/0x30
[    3.086579] RSP: 0018:ffff8801bfc03e00  EFLAGS: 00010146
[    3.087053] RAX: ffff8801b84189b0 RBX: ffff8801b84189b0 RCX: 0000000000000024
[    3.087642] RDX: 00000000000000f8 RSI: ffff8801b84189b0 RDI: ffff8801b880ad80
[    3.088230] RBP: ffff8801bfc03e00 R08: ffffffffffd8000a R09: 0000000000000001
[    3.088819] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801b880ad80
[    3.089407] R13: ffffea0006e10600 R14: ffffffff9015fb06 R15: 0000000000000246
[    3.089996] FS:  0000000000000000(0000) GS:ffff8801bfc00000(0000) knlGS:0000000000000000
[    3.090740] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.091240] CR2: ffff8801b88182e4 CR3: 0000000001c0c000 CR4: 00000000000007f0
[    3.091829] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.092418] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[    3.093007]  [<ffffffff90069197>] kmemcheck_error_save_bug+0x77/0xb0
[    3.093609]  [<ffffffff900698e3>] kmemcheck_show+0x83/0x90
[    3.094157]  [<ffffffff90069c5a>] kmemcheck_fault+0x8a/0xd0
[    3.094710]  [<ffffffff90063d9e>] do_page_fault+0x3ae/0x490
[    3.095263]  [<ffffffff906206ef>] page_fault+0x1f/0x30
[    3.095789]  [<ffffffff9013b0a5>] kmem_cache_free+0x75/0x150
[    3.096347]  [<ffffffff9015fb06>] __d_free+0x46/0x70
[    3.096865]  [<ffffffff900eb314>] rcu_process_callbacks+0x244/0x550
[    3.097461]  [<ffffffff90077c40>] __do_softirq+0xc0/0x180
[    3.098003]  [<ffffffff9062205c>] call_softirq+0x1c/0x30
[    3.098540]  [<ffffffff9003ac65>] do_softirq+0x85/0xc0
[    3.099065]  [<ffffffff90078056>] irq_exit+0xa6/0xe0
[    3.099580]  [<ffffffff9005a799>] smp_apic_timer_interrupt+0x69/0xa0
[    3.100182]  [<ffffffff906218dc>] apic_timer_interrupt+0x6c/0x80
[    3.100763]  [<ffffffff90ca519b>] locate_module_kobject+0x1d/0xcc
[    3.101349]  [<ffffffff90ca5350>] param_sysfs_init+0x106/0x183
[    3.101918]  [<ffffffff900001ba>] do_one_initcall+0x3a/0x170
[    3.102477]  [<ffffffff90c92c22>] kernel_init+0x106/0x18a
[    3.103020]  [<ffffffff90621f64>] kernel_thread_helper+0x4/0x10
[    3.103594]  [<ffffffffffffffff>] 0xffffffffffffffff
[    3.426060] bio: create slab <bio-0> at 0
[    3.442322] ACPI: Added _OSI(Module Device)
[    3.442820] ACPI: Added _OSI(Processor Device)
[    3.443339] ACPI: Added _OSI(3.0 _SCP Extensions)
[    3.443896] ACPI: Added _OSI(Processor Aggregator Device)
[    3.920801] ACPI: EC: Look up EC in DSDT
[    4.446807] ACPI: Executed 1 blocks of module-level executable AML code
[    6.645857] ------------[ cut here ]------------
[    6.646296] WARNING: at kernel/lockdep.c:2739 lockdep_trace_alloc+0xb5/0xc0()

this is:
 /*
  * Oi! Can't be having __GFP_FS allocations with IRQs disabled.
  */
 if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags)))
   return;

[    6.646884] Hardware name: System Product Name
[    6.647302] Modules linked in:
[    6.647690] Pid: 1, comm: swapper/0 Tainted: G        W    3.6.0-rc5+ #1147
[    6.648266] Call Trace:
[    6.648564]  [<ffffffff9006f12a>] warn_slowpath_common+0x7a/0xb0
[    6.649084]  [<ffffffff90600747>] ? acpi_os_map_memory+0x68/0x150
[    6.649607]  [<ffffffff9006f175>] warn_slowpath_null+0x15/0x20
[    6.650113]  [<ffffffff900ba9d5>] lockdep_trace_alloc+0xb5/0xc0
[    6.650626]  [<ffffffff9013bbb3>] kmem_cache_alloc+0x33/0x150
[    6.651129]  [<ffffffff90620939>] ? error_exit+0x29/0xb0
[    6.651603]  [<ffffffff90600747>] acpi_os_map_memory+0x68/0x150
[    6.652116]  [<ffffffff903ba5b0>] acpi_ex_system_memory_space_handler+0xe0/0x1e1
[    6.652817]  [<ffffffff903ba4d0>] ? acpi_ex_do_logical_op+0x170/0x170
[    6.653362]  [<ffffffff903b42b7>] acpi_ev_address_space_dispatch+0x1b2/0x200
[    6.653944]  [<ffffffff90620939>] ? error_exit+0x29/0xb0
[    6.654418]  [<ffffffff903b4978>] ? acpi_ev_initialize_op_regions+0x8d/0x8d
[    6.654995]  [<ffffffff903b7826>] acpi_ex_access_region+0x282/0x28f
[    6.655529]  [<ffffffff90620939>] ? error_exit+0x29/0xb0
[    6.656003]  [<ffffffff903b7b6a>] acpi_ex_field_datum_io+0x107/0x1b1
[    6.656542]  [<ffffffff903b7ed5>] acpi_ex_write_with_update_rule+0xb0/0xbb
[    6.657114]  [<ffffffff903b7982>] acpi_ex_insert_into_field+0x14f/0x230
[    6.657669]  [<ffffffff903b7578>] acpi_ex_write_data_to_field+0x1b1/0x1dd
[    6.658236]  [<ffffffff903bb3a6>] acpi_ex_store_object_to_node+0x9e/0xdd
[    6.659985]  [<ffffffff903bb4a3>] acpi_ex_store+0xbe/0x253
[    6.660471]  [<ffffffff903b8b07>] acpi_ex_opcode_1A_1T_1R+0x34e/0x4a0
[    6.661016]  [<ffffffff903b13a9>] acpi_ds_exec_end_op+0xf2/0x3e1
[    6.661534]  [<ffffffff903c264c>] acpi_ps_parse_loop+0x7b8/0x948
[    6.662052]  [<ffffffff903c2b7c>] acpi_ps_parse_aml+0x91/0x271
[    6.662558]  [<ffffffff903c33a9>] acpi_ps_execute_method+0x1c9/0x270
[    6.663097]  [<ffffffff903bddea>] acpi_ns_evaluate+0xda/0x1a5
[    6.663599]  [<ffffffff903be0c1>] acpi_ns_init_one_device+0x8d/0xc2
[    6.664132]  [<ffffffff903c044c>] acpi_ns_walk_namespace+0xbb/0x17b
[    6.664666]  [<ffffffff903be034>] ? acpi_ns_exec_module_code_list+0x17f/0x17f
[    6.665256]  [<ffffffff90cb6899>] ? acpi_sleep_proc_init+0x2a/0x2a
[    6.665785]  [<ffffffff903be391>] acpi_ns_initialize_devices+0xec/0x137
[    6.666340]  [<ffffffff903ca05e>] acpi_initialize_objects+0x34/0x4a
[    6.666874]  [<ffffffff90cb69a8>] acpi_init+0x10f/0x29b
[    6.667343]  [<ffffffff90cb4e7e>] ? video_setup+0x7d/0x7d
[    6.667823]  [<ffffffff900001ba>] do_one_initcall+0x3a/0x170
[    6.668319]  [<ffffffff90c92c22>] kernel_init+0x106/0x18a
[    6.668798]  [<ffffffff90c92573>] ? do_early_param+0x86/0x86
[    6.669294]  [<ffffffff90621f64>] kernel_thread_helper+0x4/0x10
[    6.669806]  [<ffffffff906204dd>] ? retint_restore_args+0xe/0xe
[    6.670318]  [<ffffffff90c92b1c>] ? start_kernel+0x34f/0x34f
[    6.670813]  [<ffffffff90621f60>] ? gs_change+0xb/0xb
[    6.671270] ---[ end trace bf05093e9b9b8a80 ]---
[    7.010202] ------------[ cut here ]------------
[    7.010642] WARNING: at kernel/smp.c:461 smp_call_function_many+0xb5/0x230()

this is:
  WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
     && !oops_in_progress && !early_boot_irqs_disabled);

[    7.011225] Hardware name: System Product Name
[    7.011644] Modules linked in:
[    7.012033] Pid: 1, comm: swapper/0 Tainted: G        W    3.6.0-rc5+ #1147
[    7.012610] Call Trace:
[    7.012908]  [<ffffffff9006f12a>] warn_slowpath_common+0x7a/0xb0
[    7.013427]  [<ffffffff9013af40>] ? unfreeze_partials+0x390/0x390
[    7.013951]  [<ffffffff9006f175>] warn_slowpath_null+0x15/0x20
[    7.014458]  [<ffffffff900c0545>] smp_call_function_many+0xb5/0x230
[    7.014991]  [<ffffffff9013af40>] ? unfreeze_partials+0x390/0x390
[    7.015514]  [<ffffffff900c0702>] on_each_cpu_mask+0x42/0xb0
[    7.016011]  [<ffffffff90137dc0>] ? __mmu_notifier_mm_destroy+0x40/0x40
[    7.016567]  [<ffffffff9013af40>] ? unfreeze_partials+0x390/0x390
[    7.017090]  [<ffffffff900c0803>] on_each_cpu_cond+0x93/0xd0
[    7.017585]  [<ffffffff90138b65>] flush_all+0x25/0x30
[    7.018043]  [<ffffffff9013c9e3>] kmem_cache_shrink+0x43/0x1a0
[    7.018552]  [<ffffffff90cb6899>] ? acpi_sleep_proc_init+0x2a/0x2a
[    7.019080]  [<ffffffff90cb6899>] ? acpi_sleep_proc_init+0x2a/0x2a
[    7.019610]  [<ffffffff903a62d2>] acpi_os_purge_cache+0x9/0xd
[    7.020112]  [<ffffffff903c9e04>] acpi_purge_cached_objects+0x10/0x38
[    7.020656]  [<ffffffff903ca067>] acpi_initialize_objects+0x3d/0x4a
[    7.021191]  [<ffffffff90cb69a8>] acpi_init+0x10f/0x29b
[    7.021660]  [<ffffffff90cb4e7e>] ? video_setup+0x7d/0x7d
[    7.022141]  [<ffffffff900001ba>] do_one_initcall+0x3a/0x170
[    7.022638]  [<ffffffff90c92c22>] kernel_init+0x106/0x18a
[    7.023117]  [<ffffffff90c92573>] ? do_early_param+0x86/0x86
[    7.023614]  [<ffffffff90621f64>] kernel_thread_helper+0x4/0x10
[    7.024127]  [<ffffffff906204dd>] ? retint_restore_args+0xe/0xe
[    7.024640]  [<ffffffff90c92b1c>] ? start_kernel+0x34f/0x34f
[    7.025135]  [<ffffffff90621f60>] ? gs_change+0xb/0xb
[    7.025592] ---[ end trace bf05093e9b9b8a81 ]---
[    7.026293] ERROR: kmemcheck: Fatal error
[    7.026686] Pid: 1, comm: swapper/0 Tainted: G        W    3.6.0-rc5+ #1147 System manufacturer System Product Name/P6T SE
[    7.027614] RIP: 0010:[<ffffffff903c2e96>]  [<ffffffff903c2e96>] acpi_ps_pop_scope+0x46/0x6d
[    7.028444] RSP: 0018:ffff8801b8923b30  EFLAGS: 00010182
[    7.028917] RAX: ffff8801b8896140 RBX: ffff8801b8ab0830 RCX: ffff8801b8ab0884
[    7.029505] RDX: ffffc90000011004 RSI: ffff8801b8923bd0 RDI: ffff8801b8896140
[    7.030092] RBP: ffff8801b8923b50 R08: 0000000000015690 R09: ffff8801b8a94360
[    7.030680] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8801b8923bd0
[    7.031268] R13: ffff8801b8ab081c R14: ffff8801b8ab0884 R15: ffff8801b8ab0830
[    7.031856] FS:  0000000000000000(0000) GS:ffff8801bfc00000(0000) knlGS:0000000000000000
[    7.032599] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    7.033099] CR2: ffff8801b88182e4 CR3: 0000000001c0c000 CR4: 00000000000007f0
[    7.033687] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    7.034275] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[    7.034863]  [<ffffffff90069197>] kmemcheck_error_save_bug+0x77/0xb0
[    7.035468]  [<ffffffff900698e3>] kmemcheck_show+0x83/0x90
[    7.036015]  [<ffffffff90069c5a>] kmemcheck_fault+0x8a/0xd0
[    7.036569]  [<ffffffff90063d9e>] do_page_fault+0x3ae/0x490
[    7.037121]  [<ffffffff906206ef>] page_fault+0x1f/0x30
[    7.037646]  [<ffffffff903c1e73>] acpi_ps_complete_op+0x23b/0x25c
[    7.038231]  [<ffffffff903c267a>] acpi_ps_parse_loop+0x7e6/0x948
[    7.038811]  [<ffffffff903c2b7c>] acpi_ps_parse_aml+0x91/0x271
[    7.039379]  [<ffffffff903ae51a>] acpi_ds_execute_arguments+0x9a/0x138
[    7.039992]  [<ffffffff903ae6c5>] acpi_ds_get_package_arguments+0x49/0x4b
[    7.040621]  [<ffffffff903be1a5>] acpi_ns_init_one_object+0xaf/0xfe
[    7.041216]  [<ffffffff903c044c>] acpi_ns_walk_namespace+0xbb/0x17b
[    7.041812]  [<ffffffff903c0bdb>] acpi_walk_namespace+0x8e/0xcb
[    7.042386]  [<ffffffff903be281>] acpi_ns_initialize_objects+0x38/0x5c
[    7.042998]  [<ffffffff903ca050>] acpi_initialize_objects+0x26/0x4a
[    7.043594]  [<ffffffff90cb69a8>] acpi_init+0x10f/0x29b
[    7.044124]  [<ffffffff900001ba>] do_one_initcall+0x3a/0x170
[    7.044682]  [<ffffffff90c92c22>] kernel_init+0x106/0x18a
[    7.045225]  [<ffffffff90621f64>] kernel_thread_helper+0x4/0x10
[    7.045799]  [<ffffffffffffffff>] 0xffffffffffffffff
[    7.105046] ERROR: kmemcheck: Fatal error
[    7.105443] Pid: 1, comm: swapper/0 Tainted: G        W    3.6.0-rc5+ #1147 System manufacturer System Product Name/P6T SE
[    7.106372] RIP: 0010:[<ffffffff90048ad2>]  [<ffffffff90048ad2>] x86_perf_event_update+0x2/0x70
[    7.107220] RSP: 0018:ffff8801bfc07d70  EFLAGS: 00010046
[    7.107693] RAX: 00000000ffffffff RBX: ffff8801b88b9400 RCX: ffff8801b88b9400
[    7.108281] RDX: 0000000000000000 RSI: 0000000000000040 RDI: ffff8801b88b9400
[    7.108868] RBP: ffff8801bfc07d88 R08: 0000000000000000 R09: 0000000000000000
[    7.109456] R10: 0000000000000001 R11: 44474643b88fea00 R12: ffff8801bfc0ba60
[    7.110044] R13: 0000000000000064 R14: ffff8801bfc07ef8 R15: 0000000000000021
[    7.110632] FS:  0000000000000000(0000) GS:ffff8801bfc00000(0000) knlGS:0000000000000000
[    7.111376] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    7.111875] CR2: ffff8801b88182e4 CR3: 0000000001c0c000 CR4: 00000000000007f0
[    7.112463] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    7.113051] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[    7.113638]  [<ffffffff90069197>] kmemcheck_error_save_bug+0x77/0xb0
[    7.114241]  [<ffffffff90069570>] kmemcheck_access+0x1e0/0x420
[    7.114810]  [<ffffffff90069c6d>] kmemcheck_fault+0x9d/0xd0
[    7.115365]  [<ffffffff90063d9e>] do_page_fault+0x3ae/0x490
[    7.115917]  [<ffffffff906206ef>] page_fault+0x1f/0x30
[    7.116443]  [<ffffffff9004e6c1>] intel_pmu_handle_irq+0x121/0x300
[    7.117034]  [<ffffffff900489d1>] perf_event_nmi_handler+0x21/0x30
[    7.117624]  [<ffffffff9003c9b6>] nmi_handle.isra.1+0xa6/0x1f0
[    7.118194]  [<ffffffff9003cc18>] do_nmi+0x118/0x390
[    7.118708]  [<ffffffff90620a76>] end_repeat_nmi+0x1e/0x2e
[    7.119255]  [<ffffffff90069229>] kmemcheck_read_strict+0x29/0xa0
[    7.119840]  [<ffffffff900692e2>] kmemcheck_read+0x42/0x70
[    7.120387]  [<ffffffff90069412>] kmemcheck_access+0x82/0x420
[    7.120950]  [<ffffffff90069c6d>] kmemcheck_fault+0x9d/0xd0
[    7.121503]  [<ffffffff90063d9e>] do_page_fault+0x3ae/0x490
[    7.122055]  [<ffffffff906206ef>] page_fault+0x1f/0x30
[    7.122580]  [<ffffffff903bfd07>] acpi_ns_search_and_enter+0x113/0x174
[    7.123193]  [<ffffffff903bd672>] acpi_ns_lookup+0x20e/0x336
[    7.123750]  [<ffffffff903c15fe>] acpi_ps_get_next_namepath+0x70/0x1d8
[    7.124362]  [<ffffffff903c2358>] acpi_ps_parse_loop+0x4c4/0x948
[    7.124942]  [<ffffffff903c2b7c>] acpi_ps_parse_aml+0x91/0x271
[    7.125513]  [<ffffffff903c33a9>] acpi_ps_execute_method+0x1c9/0x270
[    7.126114]  [<ffffffff903bddea>] acpi_ns_evaluate+0xda/0x1a5
[    7.126677]  [<ffffffff903c0653>] acpi_evaluate_object+0x147/0x240
[    7.127267]  [<ffffffff9061234c>] acpi_processor_set_pdc+0x181/0x1a7
[    7.127870]  [<ffffffff90cb6e1c>] early_init_pdc+0xa2/0xa4
[    7.128419]  [<ffffffff903c044c>] acpi_ns_walk_namespace+0xbb/0x17b
[    7.129015]  [<ffffffff903c0bdb>] acpi_walk_namespace+0x8e/0xcb
[    7.129589]  [<ffffffff90cb6e58>] acpi_early_processor_set_pdc+0x3a/0x53
[    7.130212]  [<ffffffff90cb69bf>] acpi_init+0x126/0x29b
[    7.130743]  [<ffffffff900001ba>] do_one_initcall+0x3a/0x170
[    7.131302]  [<ffffffff90c92c22>] kernel_init+0x106/0x18a
[    7.213371] ACPI: SSDT 00000000bf798200 00403 (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
[    7.323696] ACPI: Dynamic OEM Table Load:
[    7.324221] ACPI: SSDT           (null) 00403 (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
[    7.469717] ACPI: SSDT 00000000bf798610 00403 (v01 DpgPmm  P002Ist 00000012 INTL 20060113)
[    7.580538] ACPI: Dynamic OEM Table Load:
[    7.581064] ACPI: SSDT           (null) 00403 (v01 DpgPmm  P002Ist 00000012 INTL 20060113)
[    7.726527] ACPI: SSDT 00000000bf798a20 00403 (v01 DpgPmm  P003Ist 00000012 INTL 20060113)
[    7.838088] ACPI: Dynamic OEM Table Load:
[    7.838614] ACPI: SSDT           (null) 00403 (v01 DpgPmm  P003Ist 00000012 INTL 20060113)
[    7.984408] ACPI: SSDT 00000000bf798e30 00403 (v01 DpgPmm  P004Ist 00000012 INTL 20060113)
[    8.096055] ACPI: Dynamic OEM Table Load:
[    8.096581] ACPI: SSDT           (null) 00403 (v01 DpgPmm  P004Ist 00000012 INTL 20060113)
[    8.259265] ACPI: SSDT 00000000bf799240 00403 (v01 DpgPmm  P005Ist 00000012 INTL 20060113)
[    8.371404] ACPI: Dynamic OEM Table Load:
[    8.371929] ACPI: SSDT           (null) 00403 (v01 DpgPmm  P005Ist 00000012 INTL 20060113)
[    8.528883] ACPI: SSDT 00000000bf799650 00403 (v01 DpgPmm  P006Ist 00000012 INTL 20060113)
[    8.641522] ACPI: Dynamic OEM Table Load:
[    8.642047] ACPI: SSDT           (null) 00403 (v01 DpgPmm  P006Ist 00000012 INTL 20060113)
[    8.798897] ACPI: SSDT 00000000bf799a60 00403 (v01 DpgPmm  P007Ist 00000012 INTL 20060113)
[    8.911905] ACPI: Dynamic OEM Table Load:
[    8.912431] ACPI: SSDT           (null) 00403 (v01 DpgPmm  P007Ist 00000012 INTL 20060113)
[    9.097172] ACPI: SSDT 00000000bf799e70 00403 (v01 DpgPmm  P008Ist 00000012 INTL 20060113)
[    9.210615] ACPI: Dynamic OEM Table Load:
[    9.211138] ACPI: SSDT           (null) 00403 (v01 DpgPmm  P008Ist 00000012 INTL 20060113)
[    9.283497] ACPI: Interpreter enabled
[    9.283870] ACPI: (supports S0 S1 S3 S5)
[    9.289375] ACPI: Using IOAPIC for interrupt routing
[    9.294526] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    9.726143] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[   11.859829] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[   11.895856] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   11.963710] PCI host bridge to bus 0000:00
[   11.964230] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[   11.965017] pci_bus 0000:00: root bus resource [bus 00-ff]
[   11.965589] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[   11.966205] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[   11.966821] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[   11.967480] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[   11.968140] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xdfffffff]
[   11.968797] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfed8ffff]
[   11.969866] pci 0000:00:00.0: [8086:3405] type 00 class 0x060000
[   11.971643] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[   11.972791] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[   11.974811] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[   11.975947] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[   11.977733] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[   11.978902] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[   11.980690] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[   11.981988] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[   11.984427] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[   11.986732] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[   11.989006] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[   11.991391] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[   11.992423] pci 0000:00:1a.0: reg 20: [io  0xb800-0xb81f]
[   11.994470] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[   11.995507] pci 0000:00:1a.1: reg 20: [io  0xb880-0xb89f]
[   11.997364] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[   11.998397] pci 0000:00:1a.2: reg 20: [io  0xbc00-0xbc1f]
[   12.000400] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[   12.001234] pci 0000:00:1a.7: reg 10: [mem 0xf7fff000-0xf7fff3ff]
[   12.003018] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[   12.004161] pci 0000:00:1b.0: [8086:3a3e] type 00 class 0x040300
[   12.004987] pci 0000:00:1b.0: reg 10: [mem 0xf7ff8000-0xf7ffbfff 64bit]
[   12.006748] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[   12.007868] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[   12.009675] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[   12.010842] pci 0000:00:1c.2: [8086:3a44] type 01 class 0x060400
[   12.012648] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[   12.013975] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[   12.015783] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[   12.017026] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[   12.018059] pci 0000:00:1d.0: reg 20: [io  0xb080-0xb09f]
[   12.019930] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[   12.020963] pci 0000:00:1d.1: reg 20: [io  0xb400-0xb41f]
[   12.022837] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[   12.023872] pci 0000:00:1d.2: reg 20: [io  0xb480-0xb49f]
[   12.025960] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[   12.026795] pci 0000:00:1d.7: reg 10: [mem 0xf7ffe000-0xf7ffe3ff]
[   12.028577] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[   12.029696] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[   12.031818] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[   12.033442] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
[   12.034232] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 001f)
[   12.035854] pci 0000:00:1f.2: [8086:3a20] type 00 class 0x01018f
[   12.036660] pci 0000:00:1f.2: reg 10: [io  0xa000-0xa007]
[   12.037290] pci 0000:00:1f.2: reg 14: [io  0x9c00-0x9c03]
[   12.037920] pci 0000:00:1f.2: reg 18: [io  0x9880-0x9887]
[   12.038551] pci 0000:00:1f.2: reg 1c: [io  0x9800-0x9803]
[   12.039181] pci 0000:00:1f.2: reg 20: [io  0x9480-0x948f]
[   12.039811] pci 0000:00:1f.2: reg 24: [io  0x9400-0x940f]
[   12.041687] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[   12.042511] pci 0000:00:1f.3: reg 10: [mem 0xf7ffd000-0xf7ffd0ff 64bit]
[   12.043330] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[   12.045176] pci 0000:00:1f.5: [8086:3a26] type 00 class 0x010185
[   12.045981] pci 0000:00:1f.5: reg 10: [io  0xb000-0xb007]
[   12.046612] pci 0000:00:1f.5: reg 14: [io  0xac00-0xac03]
[   12.047242] pci 0000:00:1f.5: reg 18: [io  0xa880-0xa887]
[   12.047873] pci 0000:00:1f.5: reg 1c: [io  0xa800-0xa803]
[   12.048503] pci 0000:00:1f.5: reg 20: [io  0xa480-0xa48f]
[   12.049133] pci 0000:00:1f.5: reg 24: [io  0xa400-0xa40f]
[   12.051225] pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-ff]
[   12.051997] pci 0000:00:01.0: PCI bridge to [bus 01]
[   12.053116] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-ff]
[   12.054216] pci 0000:02:00.0: [10de:0614] type 00 class 0x030000
[   12.055004] pci 0000:02:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
[   12.055723] pci 0000:02:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[   12.056507] pci 0000:02:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
[   12.057214] pci 0000:02:00.0: reg 24: [io  0xcc00-0xcc7f]
[   12.057868] pci 0000:02:00.0: reg 30: [mem 0xfbce0000-0xfbcfffff pref]
[   12.059674] pci 0000:00:03.0: PCI bridge to [bus 02]
[   12.060246] pci 0000:00:03.0:   bridge window [io  0xc000-0xcfff]
[   12.060896] pci 0000:00:03.0:   bridge window [mem 0xf8000000-0xfbcfffff]
[   12.061601] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[   12.062928] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-ff]
[   12.063702] pci 0000:00:07.0: PCI bridge to [bus 03]
[   12.064839] pci_bus 0000:06: busn_res: [bus 06] is inserted under [bus 00-ff]
[   12.065612] pci 0000:00:1c.0: PCI bridge to [bus 06]
[   12.066254] pci 0000:00:1c.0:   bridge window [mem 0xf6f00000-0xf6ffffff 64bit pref]
[   12.067572] pci_bus 0000:05: busn_res: [bus 05] is inserted under [bus 00-ff]
[   12.068677] pci 0000:05:00.0: [10ec:8168] type 00 class 0x020000
[   12.069449] pci 0000:05:00.0: reg 10: [io  0xe800-0xe8ff]
[   12.070200] pci 0000:05:00.0: reg 18: [mem 0xfbeff000-0xfbefffff 64bit]
[   12.070965] pci 0000:05:00.0: reg 20: [mem 0xf6ef0000-0xf6efffff 64bit pref]
[   12.071727] pci 0000:05:00.0: reg 30: [mem 0xfbec0000-0xfbedffff pref]
[   12.073142] pci 0000:05:00.0: supports D1 D2
[   12.073615] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[   12.074801] pci 0000:00:1c.2: PCI bridge to [bus 05]
[   12.075373] pci 0000:00:1c.2:   bridge window [io  0xe000-0xefff]
[   12.076023] pci 0000:00:1c.2:   bridge window [mem 0xfbe00000-0xfbefffff]
[   12.076735] pci 0000:00:1c.2:   bridge window [mem 0xf6e00000-0xf6efffff 64bit pref]
[   12.078061] pci_bus 0000:04: busn_res: [bus 04] is inserted under [bus 00-ff]
[   12.079157] pci 0000:04:00.0: [197b:2363] type 00 class 0x010185
[   12.080340] pci 0000:04:00.0: reg 24: [mem 0xfbdfe000-0xfbdfffff]
[   12.081044] pci 0000:04:00.0: reg 30: [mem 0xfbde0000-0xfbdeffff pref]
[   12.082374] pci 0000:04:00.0: PME# supported from D3hot
[   12.083413] pci 0000:04:00.1: [197b:2363] type 00 class 0x010185
[   12.084220] pci 0000:04:00.1: reg 10: [io  0xdc00-0xdc07]
[   12.084858] pci 0000:04:00.1: reg 14: [io  0xd880-0xd883]
[   12.085495] pci 0000:04:00.1: reg 18: [io  0xd800-0xd807]
[   12.086132] pci 0000:04:00.1: reg 1c: [io  0xd480-0xd483]
[   12.086769] pci 0000:04:00.1: reg 20: [io  0xd400-0xd40f]
[   12.088224] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[   12.089404] pci 0000:00:1c.4: PCI bridge to [bus 04]
[   12.089975] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[   12.090626] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfffff]
[   12.091748] pci_bus 0000:07: busn_res: [bus 07] is inserted under [bus 00-ff]
[   12.092696] pci 0000:00:1e.0: PCI bridge to [bus 07] (subtractive decode)
[   12.093445] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[   12.094276] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[   12.095107] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[   12.095982] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[   12.096860] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[   12.097737] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff] (subtractive decode)
[   12.098918] pci_bus 0000:00: on NUMA node 0
[   12.099474] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   12.210708] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   12.237315] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[   12.249434] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[   12.261573] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[   12.276444] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[   12.287864] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[   12.299303] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[   12.312666]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[   12.313417]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[   16.945513] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 *11 12 14 15)
[   16.959798] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[   16.973553] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11 12 14 15)
[   16.987805] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 *14 15)
[   17.002258] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 *15)
[   17.016550] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 6 7 10 11 12 14 15)
[   17.030874] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 *7 10 11 12 14 15)
[   17.047365] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 6 7 10 11 12 14 15)
[   17.070856] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[   17.073520] vgaarb: loaded
[   17.073861] vgaarb: bridge control possible 0000:02:00.0
[   17.097493] SCSI subsystem initialized
[   17.097889] ACPI: bus type scsi registered
[   17.108416] libata version 3.00 loaded.
[   17.109580] ACPI: bus type usb registered
[   17.119502] usbcore: registered new interface driver usbfs
[   17.125306] usbcore: registered new interface driver hub
[   17.128787] usbcore: registered new device driver usb
[   17.159484] wmi: Mapper loaded
[   17.167270] Advanced Linux Sound Architecture Driver Version 1.0.25.
[   17.168997] PCI: Using ACPI for IRQ routing
[   17.184200] PCI: Discovered peer bus ff
[   17.184596] PCI: root bus ff: using default resources
[   17.185093] PCI: Probing PCI hardware (bus ff)
[   17.190840] PCI host bridge to bus 0000:ff
[   17.191320] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[   17.192190] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xfffffffff]
[   17.192813] pci_bus 0000:ff: No busn resource found for root bus, will use [bus ff-ff]
[   17.193653] pci_bus 0000:ff: busn_res: [bus ff] is inserted under domain [bus 00-ff]
[   17.194826] pci 0000:ff:00.0: [8086:2c41] type 00 class 0x060000
[   17.196899] pci 0000:ff:00.1: [8086:2c01] type 00 class 0x060000
[   17.198940] pci 0000:ff:02.0: [8086:2c10] type 00 class 0x060000
[   17.200909] pci 0000:ff:02.1: [8086:2c11] type 00 class 0x060000
[   17.203395] pci 0000:ff:03.0: [8086:2c18] type 00 class 0x060000
[   17.205368] pci 0000:ff:03.1: [8086:2c19] type 00 class 0x060000
[   17.207381] pci 0000:ff:03.4: [8086:2c1c] type 00 class 0x060000
[   17.209423] pci 0000:ff:04.0: [8086:2c20] type 00 class 0x060000
[   17.211402] pci 0000:ff:04.1: [8086:2c21] type 00 class 0x060000
[   17.213439] pci 0000:ff:04.2: [8086:2c22] type 00 class 0x060000
[   17.215423] pci 0000:ff:04.3: [8086:2c23] type 00 class 0x060000
[   17.217528] pci 0000:ff:05.0: [8086:2c28] type 00 class 0x060000
[   17.219516] pci 0000:ff:05.1: [8086:2c29] type 00 class 0x060000
[   17.221688] pci 0000:ff:05.2: [8086:2c2a] type 00 class 0x060000
[   17.223680] pci 0000:ff:05.3: [8086:2c2b] type 00 class 0x060000
[   17.225830] pci 0000:ff:06.0: [8086:2c30] type 00 class 0x060000
[   17.227826] pci 0000:ff:06.1: [8086:2c31] type 00 class 0x060000
[   17.229931] pci 0000:ff:06.2: [8086:2c32] type 00 class 0x060000
[   17.231936] pci 0000:ff:06.3: [8086:2c33] type 00 class 0x060000
[   17.235009] pci_bus 0000:ff: busn_res: [bus ff] end is updated to ff
[   17.362637] PCI: pci_cache_line_size set to 64 bytes
[   17.380798] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[   17.381353] e820: reserve RAM buffer [mem 0xbf780000-0xbfffffff]
[   17.406898] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[   17.407647] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[   17.408426] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[   17.428762] Switching to clocksource hpet
[   17.436482] pnp: PnP ACPI init
[   17.437286] ACPI: bus type pnp registered
[   17.471065] pnp 00:00: [bus 00-ff]
[   17.471501] pnp 00:00: [io  0x0cf8-0x0cff]
[   17.472003] pnp 00:00: [io  0x0000-0x0cf7 window]
[   17.472543] pnp 00:00: [io  0x0d00-0xffff window]
[   17.473083] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[   17.473666] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[   17.474250] pnp 00:00: [mem 0xc0000000-0xdfffffff window]
[   17.474833] pnp 00:00: [mem 0xf0000000-0xfed8ffff window]
[   17.486950] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[   17.489562] pnp 00:01: [mem 0xfbf00000-0xfbffffff]
[   17.490085] pnp 00:01: [mem 0xfc000000-0xfcffffff]
[   17.490607] pnp 00:01: [mem 0xfd000000-0xfdffffff]
[   17.491128] pnp 00:01: [mem 0xfe000000-0xfebfffff]
[   17.491650] pnp 00:01: [mem 0xfec8a000-0xfec8afff]
[   17.492172] pnp 00:01: [mem 0xfed10000-0xfed10fff]
[   17.507954] system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
[   17.508668] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[   17.509402] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[   17.510126] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[   17.510876] system 00:01: [mem 0xfec8a000-0xfec8afff] could not be reserved
[   17.511628] system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
[   17.512370] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[   17.522361] pnp 00:02: [dma 4]
[   17.522775] pnp 00:02: [io  0x0000-0x000f]
[   17.523253] pnp 00:02: [io  0x0081-0x0083]
[   17.523731] pnp 00:02: [io  0x0087]
[   17.524171] pnp 00:02: [io  0x0089-0x008b]
[   17.524648] pnp 00:02: [io  0x008f]
[   17.525088] pnp 00:02: [io  0x00c0-0x00df]
[   17.531913] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[   17.534372] pnp 00:03: [io  0x0070-0x0071]
[   17.534925] pnp 00:03: [irq 8]
[   17.542449] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[   17.546558] pnp 00:04: [io  0x0061]
[   17.554070] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[   17.556136] pnp 00:05: [io  0x00f0-0x00ff]
[   17.556689] pnp 00:05: [irq 13]
[   17.564482] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[   17.629561] pnp 00:06: [io  0x0000-0xffffffffffffffff disabled]
[   17.630154] pnp 00:06: [io  0x0000-0xffffffffffffffff disabled]
[   17.630747] pnp 00:06: [io  0x0290-0x029f]
[   17.646471] system 00:06: [io  0x0290-0x029f] has been reserved
[   17.647172] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[   17.704928] pnp 00:07: [io  0x0010-0x001f]
[   17.705407] pnp 00:07: [io  0x0022-0x003f]
[   17.705886] pnp 00:07: [io  0x0044-0x004d]
[   17.706602] pnp 00:07: [io  0x0050-0x005f]
[   17.707081] pnp 00:07: [io  0x0062-0x0063]
[   17.707559] pnp 00:07: [io  0x0065-0x006f]
[   17.708037] pnp 00:07: [io  0x0072-0x007f]
[   17.708514] pnp 00:07: [io  0x0080]
[   17.708955] pnp 00:07: [io  0x0084-0x0086]
[   17.709445] pnp 00:07: [io  0x0088]
[   17.709886] pnp 00:07: [io  0x008c-0x008e]
[   17.710364] pnp 00:07: [io  0x0090-0x009f]
[   17.710842] pnp 00:07: [io  0x00a2-0x00bf]
[   17.711320] pnp 00:07: [io  0x00e0-0x00ef]
[   17.711799] pnp 00:07: [io  0x04d0-0x04d1]
[   17.712277] pnp 00:07: [io  0x0800-0x087f]
[   17.712755] pnp 00:07: [io  0x0400-0x03ff disabled]
[   17.713282] pnp 00:07: [io  0x0500-0x057f]
[   17.713761] pnp 00:07: [mem 0xfed1c000-0xfed1ffff]
[   17.714282] pnp 00:07: [mem 0xfed20000-0xfed3ffff]
[   17.714804] pnp 00:07: [mem 0xfed40000-0xfed8ffff]
[   17.746170] system 00:07: [io  0x04d0-0x04d1] has been reserved
[   17.746841] system 00:07: [io  0x0800-0x087f] has been reserved
[   17.747554] system 00:07: [io  0x0500-0x057f] has been reserved
[   17.748319] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[   17.749278] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[   17.750051] system 00:07: [mem 0xfed40000-0xfed8ffff] has been reserved
[   17.750826] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[   17.770821] pnp 00:08: [mem 0xfed00000-0xfed003ff]
[   17.778457] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
[   17.793277] pnp 00:09: [mem 0xffa00000-0xffbfffff]
[   17.793800] pnp 00:09: [mem 0xffe00000-0xffffffff]
[   17.803479] pnp 00:09: Plug and Play ACPI device, IDs INT0800 (active)
[   17.817441] pnp 00:0a: [mem 0xffc00000-0xffdfffff]
[   17.833248] system 00:0a: [mem 0xffc00000-0xffdfffff] has been reserved
[   17.833981] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[   17.861375] pnp 00:0b: [io  0x0060]
[   17.861815] pnp 00:0b: [io  0x0064]
[   17.862255] pnp 00:0b: [mem 0xfec00000-0xfec00fff]
[   17.862777] pnp 00:0b: [mem 0xfee00000-0xfee00fff]
[   17.879397] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[   17.880101] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[   17.880840] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[   17.907075] pnp 00:0c: [mem 0xe0000000-0xefffffff]
[   17.922704] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[   17.923437] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[   17.982527] pnp 00:0d: [mem 0x00000000-0x0009ffff]
[   17.983051] pnp 00:0d: [mem 0x000c0000-0x000cffff]
[   17.983573] pnp 00:0d: [mem 0x000e0000-0x000fffff]
[   17.984095] pnp 00:0d: [mem 0x00100000-0xbfffffff]
[   17.984616] pnp 00:0d: [mem 0xfed90000-0xffffffff]
[   18.004707] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[   18.005416] system 00:0d: [mem 0x000c0000-0x000cffff] could not be reserved
[   18.006129] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[   18.006845] system 00:0d: [mem 0x00100000-0xbfffffff] could not be reserved
[   18.007574] system 00:0d: [mem 0xfed90000-0xffffffff] could not be reserved
[   18.008337] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[   18.051961] pnp: PnP ACPI: found 14 devices
[   18.052365] ACPI: ACPI bus type pnp unregistered
[   18.544175] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 06] add_size 1000
[   18.545307] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 06] add_size 400000
[   18.546456] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000
[   18.548223] pci 0000:00:1c.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 400000
[   18.549580] pci 0000:00:1c.4: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[   18.550515] pci 0000:00:1c.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[   18.551441] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc03fffff]
[   18.552254] pci 0000:00:1c.4: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[   18.553228] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[   18.554014] pci 0000:00:01.0: PCI bridge to [bus 01]
[   18.554731] pci 0000:00:03.0: PCI bridge to [bus 02]
[   18.555287] pci 0000:00:03.0:   bridge window [io  0xc000-0xcfff]
[   18.555946] pci 0000:00:03.0:   bridge window [mem 0xf8000000-0xfbcfffff]
[   18.556637] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[   18.557466] pci 0000:00:07.0: PCI bridge to [bus 03]
[   18.558179] pci 0000:00:1c.0: PCI bridge to [bus 06]
[   18.558736] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[   18.559640] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc03fffff]
[   18.560338] pci 0000:00:1c.0:   bridge window [mem 0xf6f00000-0xf6ffffff 64bit pref]
[   18.561188] pci 0000:00:1c.2: PCI bridge to [bus 05]
[   18.561744] pci 0000:00:1c.2:   bridge window [io  0xe000-0xefff]
[   18.562404] pci 0000:00:1c.2:   bridge window [mem 0xfbe00000-0xfbefffff]
[   18.563102] pci 0000:00:1c.2:   bridge window [mem 0xf6e00000-0xf6efffff 64bit pref]
[   18.563971] pci 0000:00:1c.4: PCI bridge to [bus 04]
[   18.564527] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[   18.565187] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfffff]
[   18.565879] pci 0000:00:1c.4:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[   18.570088] pci 0000:00:1e.0: PCI bridge to [bus 07]
[   18.571119] pci 0000:00:1c.0: enabling device (0106 -> 0107)
[   18.573098] pci 0000:00:1e.0: setting latency timer to 64
[   18.573699] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[   18.574243] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[   18.574788] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[   18.575377] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[   18.575968] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xdfffffff]
[   18.576560] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
[   18.577170] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[   18.577711] pci_bus 0000:02: resource 1 [mem 0xf8000000-0xfbcfffff]
[   18.578298] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[   18.579140] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
[   18.579681] pci_bus 0000:06: resource 1 [mem 0xc0000000-0xc03fffff]
[   18.580268] pci_bus 0000:06: resource 2 [mem 0xf6f00000-0xf6ffffff 64bit pref]
[   18.581017] pci_bus 0000:05: resource 0 [io  0xe000-0xefff]
[   18.581558] pci_bus 0000:05: resource 1 [mem 0xfbe00000-0xfbefffff]
[   18.582145] pci_bus 0000:05: resource 2 [mem 0xf6e00000-0xf6efffff 64bit pref]
[   18.582895] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[   18.583437] pci_bus 0000:04: resource 1 [mem 0xfbd00000-0xfbdfffff]
[   18.584024] pci_bus 0000:04: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[   18.584795] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[   18.585338] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[   18.585883] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[   18.586472] pci_bus 0000:07: resource 7 [mem 0x000d0000-0x000dffff]
[   18.587062] pci_bus 0000:07: resource 8 [mem 0xc0000000-0xdfffffff]
[   18.587653] pci_bus 0000:07: resource 9 [mem 0xf0000000-0xfed8ffff]
[   18.588255] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[   18.588803] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xfffffffff]
[   18.595313] NET: Registered protocol family 2
[   18.617014] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[   18.618301] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[   18.622106] TCP: Hash tables configured (established 262144 bind 65536)
[   18.622686] TCP: reno registered
[   18.623062] UDP hash table entries: 4096 (order: 7, 655360 bytes)
[   18.624030] UDP-Lite hash table entries: 4096 (order: 7, 655360 bytes)
[   18.634163] NET: Registered protocol family 1
[   18.642679] RPC: Registered named UNIX socket transport module.
[   18.643191] RPC: Registered udp transport module.
[   18.643626] RPC: Registered tcp transport module.
[   18.644061] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   18.665256] pci 0000:02:00.0: Boot video device
[   18.677419] PCI: CLS 64 bytes, default 64
[   18.750332] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   18.750878] software IO TLB [mem 0xba978000-0xbe977fff] (64MB) mapped at [ffff8800ba978000-ffff8800be977fff]
[   18.753682] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[   18.837544] audit: initializing netlink socket (disabled)
[   18.840361] type=2000 audit(1347642816.320:1): initialized
[   19.724566] fuse init (API version 7.20)
[   19.779380] tsc: Refined TSC clocksource calibration: 2672.726 MHz
[   19.779934] Switching to clocksource tsc
[   19.839830] Btrfs loaded
[   19.840440] msgmni has been set to 11846
[   19.882950] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[   19.883651] io scheduler noop registered
[   19.903441] io scheduler cfq registered (default)
[   19.933875] pcieport 0000:00:1c.0: irq 64 for MSI/MSI-X
[   19.941192] pcieport 0000:00:1c.2: irq 65 for MSI/MSI-X
[   19.947978] pcieport 0000:00:1c.4: irq 66 for MSI/MSI-X
[   20.011170] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[   20.012216] ACPI: Power Button [PWRB]
[   20.023000] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[   20.024001] ACPI: Power Button [PWRF]
[   20.063367] ACPI: Requesting acpi_cpufreq
[   20.398169] ERROR: kmemcheck: Fatal error
[   20.398565] Pid: 1, comm: swapper/0 Tainted: G        W    3.6.0-rc5+ #1147 System manufacturer System Product Name/P6T SE
[   20.399493] RIP: 0010:[<ffffffff903c2d65>]  [<ffffffff903c2d65>] acpi_ps_get_parent_scope+0x9/0xe
[   20.400352] RSP: 0018:ffff8801b8923b28  EFLAGS: 00010297
[   20.400826] RAX: ffff8801b8a90410 RBX: ffff8801b776d400 RCX: 00000000000080d0
[   20.401413] RDX: 0000000000000001 RSI: 0000000000000030 RDI: ffff8801b776d430
[   20.402001] RBP: ffff8801b8923ba0 R08: 0000000000014ce0 R09: ffff8801b88981b0
[   20.402589] R10: 0000000000000000 R11: 0000000000000000 R12: ffffc900000107da
[   20.403177] R13: ffffc900000107d9 R14: ffff8801b88981b0 R15: ffff8801b776d430
[   20.403765] FS:  0000000000000000(0000) GS:ffff8801bfc00000(0000) knlGS:0000000000000000
[   20.404508] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   20.405008] CR2: ffff8801b88182e4 CR3: 0000000001c0c000 CR4: 00000000000007f0
[   20.405596] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   20.406184] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[   20.406771]  [<ffffffff90069197>] kmemcheck_error_save_bug+0x77/0xb0
[   20.407375]  [<ffffffff900698e3>] kmemcheck_show+0x83/0x90
[   20.407922]  [<ffffffff90069c5a>] kmemcheck_fault+0x8a/0xd0
[   20.408485]  [<ffffffff90063d9e>] do_page_fault+0x3ae/0x490
[   20.409037]  [<ffffffff906206ef>] page_fault+0x1f/0x30
[   20.409564]  [<ffffffff903c2b7c>] acpi_ps_parse_aml+0x91/0x271
[   20.410133]  [<ffffffff903c33a9>] acpi_ps_execute_method+0x1c9/0x270
[   20.410734]  [<ffffffff903bddea>] acpi_ns_evaluate+0xda/0x1a5
[   20.411298]  [<ffffffff903c7d60>] acpi_ut_evaluate_object+0x74/0x19d
[   20.411900]  [<ffffffff903c7f5c>] acpi_ut_execute_power_methods+0x3f/0x7b
[   20.412528]  [<ffffffff903c0e2f>] acpi_get_object_info+0x1de/0x324
[   20.413119]  [<ffffffff903cd425>] processor_walk_namespace_cb+0x21/0xc8
[   20.413738]  [<ffffffff903c044c>] acpi_ns_walk_namespace+0xbb/0x17b
[   20.414333]  [<ffffffff903c0bdb>] acpi_walk_namespace+0x8e/0xcb
[   20.414907]  [<ffffffff90cb7a36>] acpi_processor_init+0x5f/0x7e
[   20.415482]  [<ffffffff900001ba>] do_one_initcall+0x3a/0x170
[   20.416041]  [<ffffffff90c92c22>] kernel_init+0x106/0x18a
[   20.416584]  [<ffffffff90621f64>] kernel_thread_helper+0x4/0x10
[   20.417158]  [<ffffffffffffffff>] 0xffffffffffffffff
[   21.207893] ERROR: kmemcheck: Fatal error
[   21.208287] Pid: 1, comm: swapper/0 Tainted: G        W    3.6.0-rc5+ #1147 System manufacturer System Product Name/P6T SE
[   21.209214] RIP: 0010:[<ffffffff90048ad2>]  [<ffffffff90048ad2>] x86_perf_event_update+0x2/0x70
[   21.210061] RSP: 0018:ffff8801bfc07d70  EFLAGS: 00010046
[   21.210534] RAX: 00000000ffffffff RBX: ffff8801b88b9400 RCX: ffff8801b88b9400
[   21.211122] RDX: 0000000000000000 RSI: 0000000000000040 RDI: ffff8801b88b9400
[   21.211710] RBP: ffff8801bfc07d88 R08: 0000000000000000 R09: 0000000000000000
[   21.212297] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8801bfc0ba60
[   21.212885] R13: 0000000000000064 R14: ffff8801bfc07ef8 R15: 0000000000000021
[   21.213473] FS:  0000000000000000(0000) GS:ffff8801bfc00000(0000) knlGS:0000000000000000
[   21.214216] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   21.214716] CR2: ffff8801b88182e4 CR3: 0000000001c0c000 CR4: 00000000000007f0
[   21.215304] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   21.215892] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[   21.216480]  [<ffffffff90069197>] kmemcheck_error_save_bug+0x77/0xb0
[   21.217082]  [<ffffffff90069570>] kmemcheck_access+0x1e0/0x420
[   21.217651]  [<ffffffff90069c6d>] kmemcheck_fault+0x9d/0xd0
[   21.218213]  [<ffffffff90063d9e>] do_page_fault+0x3ae/0x490
[   21.218766]  [<ffffffff906206ef>] page_fault+0x1f/0x30
[   21.219292]  [<ffffffff9004e6c1>] intel_pmu_handle_irq+0x121/0x300
[   21.219883]  [<ffffffff900489d1>] perf_event_nmi_handler+0x21/0x30
[   21.220473]  [<ffffffff9003c9b6>] nmi_handle.isra.1+0xa6/0x1f0
[   21.221043]  [<ffffffff9003cc18>] do_nmi+0x118/0x390
[   21.221557]  [<ffffffff90620a76>] end_repeat_nmi+0x1e/0x2e
[   21.222104]  [<ffffffff90069412>] kmemcheck_access+0x82/0x420
[   21.222668]  [<ffffffff90069c6d>] kmemcheck_fault+0x9d/0xd0
[   21.223220]  [<ffffffff90063d9e>] do_page_fault+0x3ae/0x490
[   21.223772]  [<ffffffff906206ef>] page_fault+0x1f/0x30
[   21.224298]  [<ffffffff903c29f4>] acpi_ps_complete_this_op+0x181/0x18d
[   21.224910]  [<ffffffff903c1c61>] acpi_ps_complete_op+0x29/0x25c
[   21.225489]  [<ffffffff903c267a>] acpi_ps_parse_loop+0x7e6/0x948
[   21.226069]  [<ffffffff903c2b7c>] acpi_ps_parse_aml+0x91/0x271
[   21.226637]  [<ffffffff903c33a9>] acpi_ps_execute_method+0x1c9/0x270
[   21.227238]  [<ffffffff903bddea>] acpi_ns_evaluate+0xda/0x1a5
[   21.227801]  [<ffffffff903c7d60>] acpi_ut_evaluate_object+0x74/0x19d
[   21.228412]  [<ffffffff903c7eee>] acpi_ut_execute_STA+0x21/0x50
[   21.228987]  [<ffffffff903c0dc8>] acpi_get_object_info+0x177/0x324
[   21.229577]  [<ffffffff903d065c>] container_walk_namespace_cb+0x1c/0xc2
[   21.230195]  [<ffffffff903c044c>] acpi_ns_walk_namespace+0xbb/0x17b
[   21.230791]  [<ffffffff903c0bdb>] acpi_walk_namespace+0x8e/0xcb
[   21.231365]  [<ffffffff90cb7a9b>] acpi_container_init+0x46/0x4a
[   21.231939]  [<ffffffff900001ba>] do_one_initcall+0x3a/0x170
[   21.232497]  [<ffffffff90c92c22>] kernel_init+0x106/0x18a
[   21.233039]  [<ffffffff90621f64>] kernel_thread_helper+0x4/0x10
[   21.233613]  [<ffffffffffffffff>] 0xffffffffffffffff
[   24.171963] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   24.268745] Linux agpgart interface v0.103
[   24.441868] loop: module loaded
[   24.466435] ahci 0000:04:00.0: version 3.0
[   24.487353] ahci 0000:04:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[   24.488161] ahci 0000:04:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[   24.528102] scsi0 : ahci
[   24.544828] scsi1 : ahci
[   24.558322] ata1: SATA max UDMA/133 abar m8192@0xfbdfe000 port 0xfbdfe100 irq 16
[   24.559029] ata2: SATA max UDMA/133 abar m8192@0xfbdfe000 port 0xfbdfe180 irq 16
[   24.576629] ata_piix 0000:00:1f.2: version 2.13
[   24.578576] ata_piix 0000:00:1f.2: MAP [
[   24.578963]  P0 P2 P1 P3 ]
[   24.585351] ata_piix 0000:00:1f.2: setting latency timer to 64
[   24.641832] scsi2 : ata_piix
[   24.837276] scsi3 : ata_piix
[   24.906746] ata1: SATA link down (SStatus 0 SControl 300)
[   24.916743] ata2: SATA link down (SStatus 0 SControl 300)
[   25.114003] ata3: SATA max UDMA/133 cmd 0xa000 ctl 0x9c00 bmdma 0x9480 irq 20
[   25.114615] ata4: SATA max UDMA/133 cmd 0x9880 ctl 0x9800 bmdma 0x9488 irq 20
[   25.118072] ata_piix 0000:00:1f.5: MAP [
[   25.118459]  P0 -- P1 -- ]
[   25.122183] ata_piix 0000:00:1f.5: setting latency timer to 64
[   25.162344] scsi4 : ata_piix
[   25.357350] scsi5 : ata_piix
[   25.547911] ata5: SATA max UDMA/133 cmd 0xb000 ctl 0xac00 bmdma 0xa480 irq 20
[   25.548509] ata6: SATA max UDMA/133 cmd 0xa880 ctl 0xa800 bmdma 0xa488 irq 20
[   25.560321] pata_jmicron 0000:04:00.1: enabling device (0000 -> 0001)
[   25.563114] pata_jmicron 0000:04:00.1: setting latency timer to 64
[   25.621896] scsi6 : pata_jmicron
[   25.710500] scsi7 : pata_jmicron
[   25.786253] ata7: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 17
[   25.787193] ata8: PATA max UDMA/100 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 17
[   25.793558] tun: Universal TUN/TAP device driver, 1.6
[   25.794016] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   25.802654] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   25.819355] r8169 0000:05:00.0: irq 67 for MSI/MSI-X
[   25.826484] ata3.00: SATA link down (SStatus 0 SControl 300)
[   25.827033] ata3.01: SATA link down (SStatus 0 SControl 300)
[   25.844210] r8169 0000:05:00.0: eth0: RTL8168c/8111c at 0xffffc9000000e000, 90:e6:ba:78:06:e6, XID 1c4000c0 IRQ 67
[   25.845171] r8169 0000:05:00.0: eth0: jumbo features [frames: 6128 bytes, tx checksumming: ko]
[   25.852091] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   25.854870] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   25.855449] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   25.857237] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   25.866995] ehci_hcd 0000:00:1a.7: debug port 1
[   25.867519] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[   25.869778] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf7fff000
[   25.886559] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   25.889821] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   25.890408] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   25.891158] usb usb1: Product: EHCI Host Controller
[   25.891676] usb usb1: Manufacturer: Linux 3.6.0-rc5+ ehci_hcd
[   25.892220] usb usb1: SerialNumber: 0000:00:1a.7
[   25.914797] ata5: SATA link down (SStatus 0 SControl 300)
[   25.933738] hub 1-0:1.0: USB hub found
[   25.934705] hub 1-0:1.0: 6 ports detected
[   25.947644] ata6: SATA link down (SStatus 0 SControl 300)
[   25.951906] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   25.952485] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   25.953571] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   25.962835] ehci_hcd 0000:00:1d.7: debug port 1
[   25.963358] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[   25.965605] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7ffe000
[   25.975558] ata7.00: ATAPI: HL-DT-ST DVDRAM GSA-4163B, A102, max UDMA/33
[   25.976438] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   25.979547] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   25.980134] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   25.980884] usb usb2: Product: EHCI Host Controller
[   25.981402] usb usb2: Manufacturer: Linux 3.6.0-rc5+ ehci_hcd
[   25.981947] usb usb2: SerialNumber: 0000:00:1d.7
[   25.986446] ata4.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   25.987043] ata4.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   26.002618] hub 2-0:1.0: USB hub found
[   26.003636] hub 2-0:1.0: 6 ports detected
[   26.014512] ata4.00: ATA-9: INTEL SSDSC2CW060A3, 400i, max UDMA/133
[   26.015046] ata4.00: 117231408 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   26.025497] ata7.00: configured for UDMA/33
[   26.053563] ata4.01: ATA-7: SAMSUNG HD753LJ, 1AA01118, max UDMA7
[   26.054081] ata4.01: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   26.055957] uhci_hcd: USB Universal Host Controller Interface driver
[   26.059330] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   26.059909] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   26.060811] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   26.062422] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000b800
[   26.070347] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   26.070934] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   26.071684] usb usb3: Product: UHCI Host Controller
[   26.072202] usb usb3: Manufacturer: Linux 3.6.0-rc5+ uhci_hcd
[   26.072747] usb usb3: SerialNumber: 0000:00:1a.0
[   26.095596] ata4.00: configured for UDMA/133
[   26.101002] hub 3-0:1.0: USB hub found
[   26.101990] hub 3-0:1.0: 2 ports detected
[   26.116756] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   26.117335] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   26.118426] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   26.121413] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b880
[   26.140074] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   26.140661] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   26.141412] usb usb4: Product: UHCI Host Controller
[   26.141929] usb usb4: Manufacturer: Linux 3.6.0-rc5+ uhci_hcd
[   26.142474] usb usb4: SerialNumber: 0000:00:1a.1
[   26.154868] ata4.01: configured for UDMA/133
[   26.162974] hub 4-0:1.0: USB hub found
[   26.163991] hub 4-0:1.0: 2 ports detected
[   26.185827] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   26.192725] scsi 3:0:0:0: Direct-Access     ATA      INTEL SSDSC2CW06 400i PQ: 0 ANSI: 5
[   26.196174] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   26.200311] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[   26.203215] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000bc00
[   26.220469] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   26.221056] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   26.221807] usb usb5: Product: UHCI Host Controller
[   26.222324] usb usb5: Manufacturer: Linux 3.6.0-rc5+ uhci_hcd
[   26.222869] usb usb5: SerialNumber: 0000:00:1a.2
[   26.262132] sd 3:0:0:0: [sda] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[   26.274350] hub 5-0:1.0: USB hub found
[   26.275319] hub 5-0:1.0: 2 ports detected
[   26.288411] sd 3:0:0:0: [sda] Write Protect is off
[   26.288908] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   26.297370] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   26.312205] sd 3:0:0:0: Attached scsi generic sg0 type 0
[   26.317306] usb 1-3: new high-speed USB device number 3 using ehci_hcd
[   26.333017] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   26.333597] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   26.334505] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[   26.336118] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b080
[   26.373899] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   26.374487] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   26.375237] usb usb6: Product: UHCI Host Controller
[   26.375755] usb usb6: Manufacturer: Linux 3.6.0-rc5+ uhci_hcd
[   26.379363] usb usb6: SerialNumber: 0000:00:1d.0
[   26.380535]  sda: sda1 sda2
[   26.390718] ACPI: Invalid Power Resource to register!
[   26.438987] scsi 3:0:1:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[   26.448772] hub 6-0:1.0: USB hub found
[   26.449728] hub 6-0:1.0: 2 ports detected
[   26.474803] usb 1-3: New USB device found, idVendor=058f, idProduct=6362
[   26.475383] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   26.476029] usb 1-3: Product: Mass Storage Device
[   26.476577] usb 1-3: Manufacturer: Generic
[   26.477016] usb 1-3: SerialNumber: 058F312D81B
[   26.514940] sd 3:0:0:0: [sda] Attached SCSI disk
[   26.517162] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   26.517742] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   26.518655] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[   26.520506] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b400
[   26.554521] sd 3:0:1:0: [sdb] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[   26.563665] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   26.564252] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   26.565003] usb usb7: Product: UHCI Host Controller
[   26.565521] usb usb7: Manufacturer: Linux 3.6.0-rc5+ uhci_hcd
[   26.566065] usb usb7: SerialNumber: 0000:00:1d.1
[   26.575343] sd 3:0:1:0: [sdb] Write Protect is off
[   26.575840] sd 3:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[   26.592238] sd 3:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   26.599142] sd 3:0:1:0: Attached scsi generic sg1 type 0
[   26.637693] hub 7-0:1.0: USB hub found
[   26.638649] hub 7-0:1.0: 2 ports detected
[   26.685562] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   26.689093] scsi 6:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4163B A102 PQ: 0 ANSI: 5
[   26.692270] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   26.693225] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   26.694893] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b480
[   26.727186]  sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 sdb7 sdb8 sdb9 > sdb4
[   26.730945] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   26.731587] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   26.732392] usb usb8: Product: UHCI Host Controller
[   26.732964] usb usb8: Manufacturer: Linux 3.6.0-rc5+ uhci_hcd
[   26.733564] usb usb8: SerialNumber: 0000:00:1d.2
[   26.773100] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[   26.775084] cdrom: Uniform CD-ROM driver Revision: 3.20
[   26.787741] hub 8-0:1.0: USB hub found
[   26.788800] hub 8-0:1.0: 2 ports detected
[   26.847524] sr 6:0:0:0: Attached scsi CD-ROM sr0
[   26.851792] Initializing USB Mass Storage driver...
[   26.869790] sr 6:0:0:0: Attached scsi generic sg2 type 5
[   26.907467] scsi8 : usb-storage 1-3:1.0
[   26.957340] usbcore: registered new interface driver usb-storage
[   26.957912] USB Mass Storage support registered.
[   26.662865] ACPI: Invalid Power Resource to register!
[   26.965546] ACPI: Invalid Power Resource to register![   26.990826] sd 3:0:1:0: [sdb] Attached SCSI disk
[   26.992745] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   27.003148] serio: i8042 KBD port at 0x60,0x64 irq 1
[   27.008388] serio: i8042 AUX port at 0x60,0x64 irq 12
[   27.024716] mousedev: PS/2 mouse device common for all mice
[   27.037411] usb 3-1: new low-speed USB device number 2 using uhci_hcd
[   27.053052] rtc_cmos 00:03: RTC can wake from S4
[   27.065415] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   27.067031] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   27.073045] i2c /dev entries driver
[   27.080351] ACPI Warning: 0x0000000000000400-0x000000000000041f SystemIO conflicts with Region \SMRG 1 (20120711/utaddress-251)
[   27.082064] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   27.108761] EDAC MC: Ver: 3.0.0
[   27.210928] EDAC MC0: Giving out device to 'i7core_edac.c' 'i7 core #0': DEV 0000:ff:03.0
[   27.230921] usb 3-1: New USB device found, idVendor=046d, idProduct=c018
[   27.231502] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   27.232144] usb 3-1: Product: USB Optical Mouse
[   27.232778] usb 3-1: Manufacturer: Logitech
[   27.235698] EDAC PCI0: Giving out device to module 'i7core_edac' controller 'EDAC PCI controller': DEV '0000:ff:03.0' (POLLED)
[   27.236932] EDAC i7core: Driver loaded, 1 memory controller(s) found.
[   27.249766] cpuidle: using governor ladder
[   27.250164] cpuidle: using governor menu
[   27.362638] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input2
[   27.375278] hid-generic 0003:046D:C018.0001: input: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1a.0-1/input0
[   27.381080] usbcore: registered new interface driver usbhid
[   27.381570] usbhid: USB HID core driver
[   27.430740] snd_hda_intel 0000:00:1b.0: irq 68 for MSI/MSI-X
[   27.556950] usb 4-2: new low-speed USB device number 2 using uhci_hcd
[   27.807314] oprofile: using NMI interrupt.
[   27.831909] ip_tables: (C) 2000-2006 Netfilter Core Team
[   27.836757] TCP: cubic registered
[   27.837106] Initializing XFRM netlink socket
[   27.838167] NET: Registered protocol family 17
[   27.841857] Bridge firewalling registered
[   27.880060] registered taskstats version 1
[   27.902077] usb 4-2: New USB device found, idVendor=046d, idProduct=c30e
[   27.902657] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   27.903310] usb 4-2: Product: HID compliant keyboard
[   27.903965] usb 4-2: Manufacturer: Logitech
[   27.953886] scsi 8:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[   27.966840] netpoll: netconsole: local port 33333
[   27.967281] netpoll: netconsole: local IP 192.168.1.123
[   27.967759] netpoll: netconsole: interface 'eth0'
[   27.968196] netpoll: netconsole: remote port 8888
[   27.968636] netpoll: netconsole: remote IP 192.168.1.102
[   27.969116] netpoll: netconsole: remote ethernet address 00:06:5b:6a:a5:74
[   27.969720] netpoll: netconsole: device eth0 not up yet, forcing it
[   27.982629] scsi 8:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[   27.997893] scsi 8:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
[   28.008481] r8169 0000:05:00.0: eth0: link down
[   28.009527] r8169 0000:05:00.0: eth0: link down
[   28.013716] scsi 8:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[   28.066845] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.0/input/input3
[   28.083026] hid-generic 0003:046D:C30E.0002: input: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1a.1-2/input0
[   28.241851] sd 8:0:0:0: Attached scsi generic sg3 type 0
[   28.260863] sd 8:0:0:0: [sdc] Attached SCSI removable disk
[   28.282899] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.1/input/input4
[   28.292752] hid-generic 0003:046D:C30E.0003: input: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1a.1-2/input1
[   28.331593] sd 8:0:0:1: Attached scsi generic sg4 type 0
[   28.360126] sd 8:0:0:1: [sdd] Attached SCSI removable disk
[   28.403558] sd 8:0:0:2: Attached scsi generic sg5 type 0
[   28.449549] sd 8:0:0:2: [sde] Attached SCSI removable disk
[   28.480605] sd 8:0:0:3: Attached scsi generic sg6 type 0
[   28.503911] sd 8:0:0:3: [sdf] Attached SCSI removable disk
[   29.739673] r8169 0000:05:00.0: eth0: link up
[   30.334080] console [netcon0] enabled
[   30.334903] netconsole: network logging started
[   30.335913] rtc_cmos 00:03: setting system clock to 2012-09-14 17:13:50 UTC (1347642830)
[   30.456822] ALSA device list:
[   30.457664]   #0: HDA Intel at 0xf7ff8000 irq 68
[   30.459116] Warning: unable to open an initial console.
[   30.460610] Freeing unused kernel memory: 1760k freed
[   30.461913] Write protecting the kernel read-only data: 12288k
[   30.468055] Freeing unused kernel memory: 1884k freed
[   30.473719] Freeing unused kernel memory: 1836k freed
[   30.479236] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000005
[   30.479236] 
[   30.480394] Pid: 1, comm: init Tainted: G        W    3.6.0-rc5+ #1147
[   30.481194] Call Trace:
[   30.481728]  [<ffffffff906153b2>] panic+0xbb/0x1d0
[   30.482415]  [<ffffffff90075982>] ? do_exit+0x832/0x920
[   30.483131]  [<ffffffff90075a1a>] do_exit+0x8ca/0x920
[   30.483835]  [<ffffffff90075cf9>] do_group_exit+0x49/0xb0
[   30.484563]  [<ffffffff90082fb1>] get_signal_to_deliver+0x1d1/0x7e0
[   30.485348]  [<ffffffff9007ffe4>] ? signal_wake_up+0x34/0x40
[   30.486268]  [<ffffffff900381e7>] do_signal+0x37/0x960
[   30.486978]  [<ffffffff900ba4dd>] ? trace_hardirqs_on+0xd/0x10
[   30.487733]  [<ffffffff900461b2>] ? syscall_trace_leave+0x122/0x130
[   30.488519]  [<ffffffff900baff8>] ? lockdep_sys_exit+0x28/0x90
[   30.489273]  [<ffffffff90038ba5>] do_notify_resume+0x75/0xa0
[   30.490017]  [<ffffffff90368c6e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   30.490815]  [<ffffffff90620f72>] int_signal+0x12/0x17
[   30.491523]  [<ffffffff906135a1>] ? run_init_process+0x1e/0x20
[   30.492277]  [<ffffffff906135ed>] ? init_post+0x4a/0xc3
[   30.492994]  [<ffffffff90c92ca6>] ? kernel_init+0x18a/0x18a
[   30.493733]  [<ffffffff90c92573>] ? do_early_param+0x86/0x86
[   30.494476]  [<ffffffff90621f64>] ? kernel_thread_helper+0x4/0x10
[   30.495428]  [<ffffffff906204dd>] ? retint_restore_args+0xe/0xe
[   30.496191]  [<ffffffff90c92b1c>] ? start_kernel+0x34f/0x34f
[   30.496933]  [<ffffffff90621f60>] ? gs_change+0xb/0xb
