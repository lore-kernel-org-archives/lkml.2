Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556Ab0LOEfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 23:35:18 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:64195 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760455Ab0LOEfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 23:35:16 -0500
Date: Tue, 14 Dec 2010 23:35:05 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Jack Steiner <steiner@sgi.com>
Cc: hpa@zytor.com, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        tony.luck@gmail.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, gbeshers@sgi.com
Subject: Re: [PATCH] - Mapping ACPI tables as CACHED
In-reply-to: <alpine.LFD.2.00.1012142302110.4878@x980>
Message-id: <alpine.LFD.2.00.1012142317450.4878@x980>
References: <20101214220932.GA1206@sgi.com>
 <alpine.LFD.2.00.1012141903210.25387@x980> <20101215024136.GB19601@sgi.com>
 <alpine.LFD.2.00.1012142302110.4878@x980>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[    1.444475] LENB: free_initmem() NOT!
is where free_initmem(); would have been called.

So the calls to acpi_os_map_memory() at 2.586160, kill the machine.

My guess is that they are related to the opregion stuff used by i915;
but there is no reason that acpi_os_map_memory can't be called
as a result of AML at run-time any-time later.

BTW. what, exactly does this notation do for us?

void __iomem *__init_refok acpi_os_map_memory(...) {

Also, I see no calls within E820_RAM.

I see a call at 0.534537 which is not in E820_RAM, ACPI, or NVS,
but is in a reserved region.

I'm not sure the concept of checking against E820
is better than simply calling ioremap_cache() always.

thanks,
Len Brown, Intel Open Source Technology Center

[    0.000000] Linux version 2.6.37-rc5-dirty (lenb@x980) (gcc version 4.4.5 20101112 (Red Hat 4.4.5-2) (GCC) ) #43 SMP Tue Dec 14 23:07:07 EST 2010
[    0.000000] Command line: root=/dev/sda5 selinux=0 debug initcall_debug
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000775c2000 (usable)
[    0.000000]  BIOS-e820: 00000000775c2000 - 0000000077607000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000077607000 - 0000000077611000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000077611000 - 0000000077614000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000077614000 - 0000000077626000 (reserved)
[    0.000000]  BIOS-e820: 0000000077626000 - 0000000077632000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000077632000 - 0000000077653000 (reserved)
[    0.000000]  BIOS-e820: 0000000077653000 - 0000000077696000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000077696000 - 0000000077800000 (usable)
[    0.000000]  BIOS-e820: 0000000079e00000 - 000000007c000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: To be filled by O.E.M./Spring Peak, BIOS Spring Peak 15  0700 05/25/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x77800 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 078000000 mask FF8000000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [ffff8800000fcd20] fcd20
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-0000000077800000
[    0.000000]  0000000000 - 0077800000 page 2M
[    0.000000] kernel direct mapping tables up to 77800000 @ 1fffd000-20000000
[    0.000000] LENB acpi_os_map_memory(0x000000000000040e, 0x0000000000000002)
[    0.000000] LENB acpi_os_map_memory(0x000000000009d800, 0x0000000000000400)
[    0.000000] LENB acpi_os_map_memory(0x00000000000e0000, 0x0000000000020000)
[    0.000000] LENB acpi_os_map_memory(0x00000000000f0410, 0x0000000000000024)
[    0.000000] ACPI: RSDP 00000000000f0410 00024 (v03 ALASKA)
[    0.000000] LENB acpi_os_map_memory(0x0000000077607080, 0x0000000000000024)
[    0.000000] LENB acpi_os_map_memory(0x0000000077607080, 0x0000000000000054)
[    0.000000] LENB acpi_os_map_memory(0x0000000077607080, 0x0000000000000024)
[    0.000000] ACPI: XSDT 0000000077607080 00054 (v01 ALASKA   A M I  01072009 AMI  00010013)
[    0.000000] LENB acpi_os_map_memory(0x0000000077607080, 0x0000000000000054)
[    0.000000] LENB acpi_os_map_memory(0x000000007760fd78, 0x0000000000000024)
[    0.000000] ACPI: FACP 000000007760fd78 000F4 (v04 ALASKA   A M I  01072009 AMI  00010013)
[    0.000000] LENB acpi_os_map_memory(0x000000007760fd78, 0x00000000000000f4)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20101013/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0x7762FE40/0x000000007762FE80, using 32 (20101013/tbfadt-486)
[    0.000000] LENB acpi_os_map_memory(0x0000000077607168, 0x0000000000000024)
[    0.000000] ACPI: DSDT 0000000077607168 08C0D (v02 ALASKA   A M I  00000009 INTL 20051117)
[    0.000000] LENB acpi_os_map_memory(0x000000007762fe40, 0x0000000000000024)
[    0.000000] ACPI: FACS 000000007762fe40 00040
[    0.000000] LENB acpi_os_map_memory(0x000000007760fe70, 0x0000000000000024)
[    0.000000] ACPI: APIC 000000007760fe70 00072 (v01 ALASKA   A M I  01072009 AMI  00010013)
[    0.000000] LENB acpi_os_map_memory(0x000000007760fee8, 0x0000000000000024)
[    0.000000] ACPI: SSDT 000000007760fee8 0050E (v01 AMICPU     PROC 00000001 MSFT 03000001)
[    0.000000] LENB acpi_os_map_memory(0x00000000776103f8, 0x0000000000000024)
[    0.000000] ACPI: MCFG 00000000776103f8 0003C (v01 ALASKA   A M I  01072009 MSFT 00000097)
[    0.000000] LENB acpi_os_map_memory(0x0000000077610438, 0x0000000000000024)
[    0.000000] ACPI: HPET 0000000077610438 00038 (v01 ALASKA   A M I  01072009 AMI. 00000003)
[    0.000000] LENB acpi_os_map_memory(0x0000000077610470, 0x0000000000000024)
[    0.000000] ACPI: ECDT 0000000077610470 000C1 (v01 ALASKA   A M I  01072009 AMI. 00000003)
[    0.000000] LENB acpi_os_map_memory(0x0000000077607168, 0x0000000000000024)
[    0.000000] LENB acpi_os_map_memory(0x0000000077607168, 0x0000000000000024)
[    0.000000] LENB acpi_os_map_memory(0x0000000077607168, 0x0000000000000024)
[    0.000000] LENB acpi_os_map_memory(0x0000000077607168, 0x0000000000000024)
[    0.000000] LENB acpi_os_map_memory(0x000000007760fe70, 0x0000000000000072)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] LENB acpi_os_map_memory(0x000000007760fe70, 0x0000000000000072)
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880074e00000-ffff8800769fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000775c2
[    0.000000]     0: 0x00077696 -> 0x00077800
[    0.000000] On node 0 totalpages: 489145
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2 pages reserved
[    0.000000]   DMA zone: 3923 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6636 pages used for memmap
[    0.000000]   DMA32 zone: 478528 pages, LIFO batch:31
[    0.000000] LENB acpi_os_map_memory(0x000000007760fd78, 0x00000000000000f4)
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] LENB acpi_os_map_memory(0x000000007760fe70, 0x0000000000000072)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] LENB acpi_os_map_memory(0x000000007760fe70, 0x0000000000000072)
[    0.000000] LENB acpi_os_map_memory(0x000000007760fe70, 0x0000000000000072)
[    0.000000] LENB acpi_os_map_memory(0x000000007760fe70, 0x0000000000000072)
[    0.000000] LENB acpi_os_map_memory(0x000000007760fe70, 0x0000000000000072)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
[    0.000000] LENB acpi_os_map_memory(0x000000007760fe70, 0x0000000000000072)
[    0.000000] LENB acpi_os_map_memory(0x000000007760fe70, 0x0000000000000072)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] LENB acpi_os_map_memory(0x000000007760fe70, 0x0000000000000072)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] LENB acpi_os_map_memory(0x000000007760fe70, 0x0000000000000072)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] LENB acpi_os_map_memory(0x000000007760fe70, 0x0000000000000072)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] LENB acpi_os_map_memory(0x0000000077610438, 0x0000000000000038)
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] Allocating PCI resources starting at 7c000000 (gap: 7c000000:82d1c000)
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880077200000 s74304 r8192 d24000 u524288
[    0.000000] pcpu-alloc: s74304 r8192 d24000 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 482451
[    0.000000] Kernel command line: root=/dev/sda5 selinux=0 debug initcall_debug
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 1915692k/1957888k available (4247k kernel code, 1308k absent, 40888k reserved, 2919k data, 448k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:1280
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2660.109 MHz processor.
[    0.000008] Calibrating delay loop (skipped), value calculated using timer frequency.. 5320.21 BogoMIPS (lpj=2660109)
[    0.000268] pid_max: default: 32768 minimum: 301
[    0.000566] Mount-cache hash table entries: 256
[    0.000940] CPU: Physical Processor ID: 0
[    0.001061] CPU: Processor Core ID: 0
[    0.001186] mce: CPU supports 9 MCE banks
[    0.001317] CPU0: Thermal monitoring enabled (TM1)
[    0.001459] using mwait in idle threads.
[    0.001583] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.001900] ... version:                3
[    0.002025] ... bit width:              48
[    0.002151] ... generic registers:      4
[    0.002277] ... value mask:             0000ffffffffffff
[    0.002409] ... max period:             000000007fffffff
[    0.002537] ... fixed-purpose events:   3
[    0.002662] ... event mask:             000000070000000f
[    0.002860] ACPI: Core revision 20101013
[    0.003065] LENB acpi_os_map_memory(0x0000000077607168, 0x0000000000008c0d)
[    0.003196] LENB E820_RAM 0
[    0.003317] LENB E820_ACPI 1
[    0.003443] LENB E820_NVS 0
[    0.003571] LENB 0xffffc90000010000 = __acpi_map_table_permanent(0x0000000077607000, 0x9000)
[    0.014157] LENB acpi_os_map_memory(0x000000007760fee8, 0x000000000000050e)
[    0.014289] LENB E820_RAM 0
[    0.014415] LENB E820_ACPI 1
[    0.016954] LENB E820_NVS 0
[    0.017082] LENB 0xffffc90000004000 = __acpi_map_table_permanent(0x000000007760f000, 0x2000)
[    0.019384] LENB acpi_os_map_memory(0x000000007762fe40, 0x0000000000000040)
[    0.019513] LENB E820_RAM 0
[    0.019631] LENB E820_ACPI 0
[    0.019749] LENB E820_NVS 1
[    0.019876] LENB 0xffffc90000008000 = __acpi_map_table_permanent(0x000000007762f000, 0x1000)
[    0.020165] Setting APIC routing to flat
[    0.020645] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.030751] CPU0: Intel(R) Core(TM) i7 CPU       M 620  @ 2.67GHz stepping 02
[    0.132042] calling  migration_init+0x0/0x71 @ 1
[    0.132171] initcall migration_init+0x0/0x71 returned 0 after 0 usecs
[    0.132304] calling  spawn_ksoftirqd+0x0/0x57 @ 1
[    0.132459] initcall spawn_ksoftirqd+0x0/0x57 returned 0 after 0 usecs
[    0.132592] calling  init_workqueues+0x0/0x306 @ 1
[    0.132817] initcall init_workqueues+0x0/0x306 returned 0 after 0 usecs
[    0.132956] calling  init_call_single_data+0x0/0x89 @ 1
[    0.133089] initcall init_call_single_data+0x0/0x89 returned 0 after 0 usecs
[    0.133220] calling  cpu_stop_init+0x0/0xac @ 1
[    0.133367] initcall cpu_stop_init+0x0/0xac returned 0 after 0 usecs
[    0.133498] calling  tracer_alloc_buffers+0x0/0x170 @ 1
[    0.133654] initcall tracer_alloc_buffers+0x0/0x170 returned 0 after 0 usecs
[    0.133785] calling  init_trace_printk+0x0/0x12 @ 1
[    0.133913] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.134463] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.406420] Brought up 4 CPUs
[    0.406544] Total of 4 processors activated (21279.36 BogoMIPS).
[    0.407853] devtmpfs: initialized
[    0.408406] calling  init_mmap_min_addr+0x0/0x16 @ 1
[    0.408535] initcall init_mmap_min_addr+0x0/0x16 returned 0 after 0 usecs
[    0.408671] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.408809] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.409029] calling  net_ns_init+0x0/0x1ec @ 1
[    0.409157] initcall net_ns_init+0x0/0x1ec returned 0 after 0 usecs
[    0.409291] calling  cpufreq_tsc+0x0/0x37 @ 1
[    0.409421] initcall cpufreq_tsc+0x0/0x37 returned 0 after 0 usecs
[    0.409556] calling  pci_reboot_init+0x0/0x14 @ 1
[    0.409687] initcall pci_reboot_init+0x0/0x14 returned 0 after 0 usecs
[    0.409823] calling  init_lapic_sysfs+0x0/0x30 @ 1
[    0.410052] initcall init_lapic_sysfs+0x0/0x30 returned 0 after 0 usecs
[    0.410191] calling  init_smp_flush+0x0/0x38 @ 1
[    0.410320] initcall init_smp_flush+0x0/0x38 returned 0 after 0 usecs
[    0.410459] calling  sysctl_init+0x0/0x32 @ 1
[    0.410621] initcall sysctl_init+0x0/0x32 returned 0 after 0 usecs
[    0.410757] calling  ksysfs_init+0x0/0x94 @ 1
[    0.410896] initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
[    0.411029] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.411159] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.411380] calling  pm_init+0x0/0x5a @ 1
[    0.411513] initcall pm_init+0x0/0x5a returned 0 after 0 usecs
[    0.411645] calling  init_zero_pfn+0x0/0x35 @ 1
[    0.411772] initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
[    0.411906] calling  fsnotify_init+0x0/0x26 @ 1
[    0.412033] initcall fsnotify_init+0x0/0x26 returned 0 after 0 usecs
[    0.412168] calling  filelock_init+0x0/0x2e @ 1
[    0.412313] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
[    0.412450] calling  init_script_binfmt+0x0/0x14 @ 1
[    0.412581] initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.412717] calling  init_elf_binfmt+0x0/0x14 @ 1
[    0.412845] initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.412978] calling  init_compat_elf_binfmt+0x0/0x14 @ 1
[    0.413110] initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.413250] calling  debugfs_init+0x0/0x5c @ 1
[    0.413388] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
[    0.413521] calling  random32_init+0x0/0xd8 @ 1
[    0.413648] initcall random32_init+0x0/0xd8 returned 0 after 0 usecs
[    0.413783] calling  sfi_sysfs_init+0x0/0xd4 @ 1
[    0.413911] initcall sfi_sysfs_init+0x0/0xd4 returned 0 after 0 usecs
[    0.414047] calling  cpufreq_core_init+0x0/0xa3 @ 1
[    0.414179] initcall cpufreq_core_init+0x0/0xa3 returned 0 after 0 usecs
[    0.414317] calling  cpuidle_init+0x0/0x40 @ 1
[    0.414450] initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
[    0.414584] calling  sock_init+0x0/0x59 @ 1
[    0.414766] initcall sock_init+0x0/0x59 returned 0 after 0 usecs
[    0.414896] calling  netpoll_init+0x0/0x31 @ 1
[    0.415021] initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
[    0.415155] calling  netlink_proto_init+0x0/0x251 @ 1
[    0.415299] NET: Registered protocol family 16
[    0.415445] initcall netlink_proto_init+0x0/0x251 returned 0 after 976 usecs
[    0.415583] calling  bdi_class_init+0x0/0x4d @ 1
[    0.415776] initcall bdi_class_init+0x0/0x4d returned 0 after 0 usecs
[    0.415912] calling  kobject_uevent_init+0x0/0x21 @ 1
[    0.416050] initcall kobject_uevent_init+0x0/0x21 returned 0 after 0 usecs
[    0.416187] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.416374] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.416509] calling  pci_driver_init+0x0/0x12 @ 1
[    0.416692] initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
[    0.416828] calling  backlight_class_init+0x0/0x5d @ 1
[    0.417007] initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
[    0.417143] calling  video_output_class_init+0x0/0x19 @ 1
[    0.417324] initcall video_output_class_init+0x0/0x19 returned 0 after 976 usecs
[    0.417541] calling  tty_class_init+0x0/0x38 @ 1
[    0.417720] initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
[    0.417857] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    0.418112] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 usecs
[    0.418249] calling  i2c_init+0x0/0x6b @ 1
[    0.418489] initcall i2c_init+0x0/0x6b returned 0 after 0 usecs
[    0.418623] calling  amd_postcore_init+0x0/0x77 @ 1
[    0.418751] initcall amd_postcore_init+0x0/0x77 returned 0 after 0 usecs
[    0.418886] calling  arch_kdebugfs_init+0x0/0x240 @ 1
[    0.419028] initcall arch_kdebugfs_init+0x0/0x240 returned 0 after 0 usecs
[    0.419164] calling  mtrr_if_init+0x0/0x78 @ 1
[    0.419294] initcall mtrr_if_init+0x0/0x78 returned 0 after 0 usecs
[    0.419432] calling  ffh_cstate_init+0x0/0x2a @ 1
[    0.419562] initcall ffh_cstate_init+0x0/0x2a returned 0 after 0 usecs
[    0.419697] calling  dynamic_debug_init+0x0/0x10b @ 1
[    0.419901] initcall dynamic_debug_init+0x0/0x10b returned 0 after 0 usecs
[    0.420037] calling  acpi_pci_init+0x0/0x5c @ 1
[    0.420165] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.420382] ACPI: bus type pci registered
[    0.420508] initcall acpi_pci_init+0x0/0x5c returned 0 after 976 usecs
[    0.420642] calling  dma_bus_init+0x0/0x3f @ 1
[    0.420822] initcall dma_bus_init+0x0/0x3f returned 0 after 0 usecs
[    0.420956] calling  dma_channel_table_init+0x0/0x116 @ 1
[    0.421094] initcall dma_channel_table_init+0x0/0x116 returned 0 after 0 usecs
[    0.421314] calling  dmi_id_init+0x0/0x361 @ 1
[    0.421583] initcall dmi_id_init+0x0/0x361 returned 0 after 0 usecs
[    0.421718] calling  pci_arch_init+0x0/0x69 @ 1
[    0.421855] LENB acpi_os_map_memory(0x00000000776103f8, 0x000000000000003c)
[    0.421991] LENB E820_RAM 0
[    0.422112] LENB E820_ACPI 1
[    0.422235] LENB E820_NVS 0
[    0.422371] LENB 0xffffc9000000c000 = __acpi_map_table_permanent(0x0000000077610000, 0x1000)
[    0.422597] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.422820] PCI: not using MMCONFIG
[    0.422943] PCI: Using configuration type 1 for base access
[    0.423074] initcall pci_arch_init+0x0/0x69 returned 0 after 976 usecs
[    0.423209] calling  topology_init+0x0/0x40 @ 1
[    0.423532] initcall topology_init+0x0/0x40 returned 0 after 0 usecs
[    0.423667] calling  mtrr_init_finialize+0x0/0x3d @ 1
[    0.423797] initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 usecs
[    0.423935] calling  init_vdso_vars+0x0/0x221 @ 1
[    0.424068] initcall init_vdso_vars+0x0/0x221 returned 0 after 0 usecs
[    0.424201] calling  sysenter_setup+0x0/0x2d8 @ 1
[    0.424335] initcall sysenter_setup+0x0/0x2d8 returned 0 after 0 usecs
[    0.424473] calling  param_sysfs_init+0x0/0x232 @ 1
[    0.432263] initcall param_sysfs_init+0x0/0x232 returned 0 after 6835 usecs
[    0.432406] calling  pm_sysrq_init+0x0/0x19 @ 1
[    0.432536] initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 usecs
[    0.432670] calling  default_bdi_init+0x0/0xa8 @ 1
[    0.432917] initcall default_bdi_init+0x0/0xa8 returned 0 after 0 usecs
[    0.433053] calling  init_bio+0x0/0x149 @ 1
[    0.433237] bio: create slab <bio-0> at 0
[    0.433389] initcall init_bio+0x0/0x149 returned 0 after 976 usecs
[    0.433523] calling  fsnotify_notification_init+0x0/0x8b @ 1
[    0.433686] initcall fsnotify_notification_init+0x0/0x8b returned 0 after 0 usecs
[    0.433905] calling  blk_settings_init+0x0/0x2a @ 1
[    0.434034] initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
[    0.434169] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.434310] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.434446] calling  blk_softirq_init+0x0/0x6e @ 1
[    0.434578] initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
[    0.434711] calling  blk_iopoll_setup+0x0/0x6e @ 1
[    0.434838] initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
[    0.434971] calling  genhd_device_init+0x0/0x7b @ 1
[    0.435204] initcall genhd_device_init+0x0/0x7b returned 0 after 0 usecs
[    0.435345] calling  pci_slot_init+0x0/0x46 @ 1
[    0.435475] initcall pci_slot_init+0x0/0x46 returned 0 after 0 usecs
[    0.435609] calling  fbmem_init+0x0/0x98 @ 1
[    0.435793] initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
[    0.435926] calling  acpi_init+0x0/0x116 @ 1
[    0.437899] LENB acpi_os_map_memory(0x0000000077610470, 0x00000000000000c1)
[    0.438033] LENB E820_RAM 0
[    0.438154] LENB E820_ACPI 1
[    0.438278] LENB E820_NVS 0
[    0.438408] LENB 0xffffc9000001e000 = __acpi_map_table_permanent(0x0000000077610000, 0x1000)
[    0.438629] ACPI: EC: EC description table is found, configuring boot EC
[    0.461190] LENB acpi_os_map_memory(0x0000000077629f77, 0x0000000000000013)
[    0.461330] LENB E820_RAM 0
[    0.463869] LENB E820_ACPI 0
[    0.463991] LENB E820_NVS 1
[    0.464121] LENB 0xffffc9000000c000 = __acpi_map_table_permanent(0x0000000077629000, 0x1000)
[    0.477296] ACPI: Executed 2 blocks of module-level executable AML code
[    0.486138] LENB acpi_os_map_memory(0x0000000077629ec2, 0x00000000000000c8)
[    0.486282] LENB E820_RAM 0
[    0.486404] LENB E820_ACPI 0
[    0.486524] LENB E820_NVS 1
[    0.486653] LENB 0xffffc9000001c000 = __acpi_map_table_permanent(0x0000000077629000, 0x1000)
[    0.488056] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.488706] LENB acpi_os_map_memory(0x000000007760fd78, 0x00000000000000f4)
[    0.488840] LENB E820_RAM 0
[    0.488959] LENB E820_ACPI 1
[    0.489079] LENB E820_NVS 0
[    0.489207] LENB 0xffffc9000000c000 = __acpi_map_table_permanent(0x000000007760f000, 0x1000)
[    0.489432] LENB acpi_os_map_memory(0x000000007760fe70, 0x0000000000000072)
[    0.489569] LENB E820_RAM 0
[    0.489691] LENB E820_ACPI 1
[    0.489814] LENB E820_NVS 0
[    0.489942] LENB 0xffffc90000020000 = __acpi_map_table_permanent(0x000000007760f000, 0x1000)
[    0.490170] LENB acpi_os_map_memory(0x0000000077610438, 0x0000000000000038)
[    0.490308] LENB E820_RAM 0
[    0.490430] LENB E820_ACPI 1
[    0.490552] LENB E820_NVS 0
[    0.490681] LENB 0xffffc9000000c000 = __acpi_map_table_permanent(0x0000000077610000, 0x1000)
[    0.491209] LENB acpi_os_map_memory(0x0000000077628c18, 0x000000000000038c)
[    0.491346] LENB E820_RAM 0
[    0.491467] LENB E820_ACPI 0
[    0.491587] LENB E820_NVS 1
[    0.491714] LENB 0xffffc90000020000 = __acpi_map_table_permanent(0x0000000077628000, 0x1000)
[    0.491972] ACPI: SSDT 0000000077628c18 0038C (v01    AMI      IST 00000001 MSFT 03000001)
[    0.492882] ACPI: Dynamic OEM Table Load:
[    0.493074] ACPI: SSDT           (null) 0038C (v01    AMI      IST 00000001 MSFT 03000001)
[    0.494486] ACPI: Interpreter enabled
[    0.494611] ACPI: (supports S0 S5)
[    0.494810] ACPI: Using IOAPIC for interrupt routing
[    0.494971] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.495290] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.525039] LENB acpi_os_map_memory(0x0000000077629e81, 0x0000000000000109)
[    0.525185] LENB E820_RAM 0
[    0.525306] LENB E820_ACPI 0
[    0.525427] LENB E820_NVS 1
[    0.525556] LENB 0xffffc9000000c000 = __acpi_map_table_permanent(0x0000000077629000, 0x1000)
[    0.534537] LENB acpi_os_map_memory(0x00000000fed1f404, 0x0000000000000004)
[    0.534672] LENB E820_RAM 0
[    0.534792] LENB E820_ACPI 0
[    0.534913] LENB E820_NVS 0
[    0.535041] LENB 0xffffc9000001c000 = __acpi_map_table_permanent(0x00000000fed1f000, 0x1000)
[    0.540000] LENB acpi_os_map_memory(0x0000000077629e5f, 0x000000000000012b)
[    0.540143] LENB E820_RAM 0
[    0.540265] LENB E820_ACPI 0
[    0.540386] LENB E820_NVS 1
[    0.540514] LENB 0xffffc90000024000 = __acpi_map_table_permanent(0x0000000077629000, 0x1000)
[    0.549278] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.549535] initcall acpi_init+0x0/0x116 returned 0 after 110351 usecs
[    0.549671] calling  dock_init+0x0/0xa5 @ 1
[    0.550425] ACPI: No dock devices found.
[    0.550549] initcall dock_init+0x0/0xa5 returned 0 after 976 usecs
[    0.550680] calling  acpi_pci_root_init+0x0/0x2d @ 1
[    0.550808] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.551301] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.551651] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.551788] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.551921] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.552139] pci_root PNP0A08:00: host bridge window [mem 0x7c000000-0xffffffff]
[    0.552372] pci 0000:00:00.0: [8086:0044] type 0 class 0x000600
[    0.552516] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
[    0.552751] pci 0000:00:02.0: [8086:0046] type 0 class 0x000300
[    0.552891] pci 0000:00:02.0: reg 10: [mem 0xfb000000-0xfb3fffff 64bit]
[    0.553034] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.553171] pci 0000:00:02.0: reg 20: [io  0xf080-0xf087]
[    0.553356] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
[    0.553512] pci 0000:00:16.0: reg 10: [mem 0xfb609000-0xfb60900f 64bit]
[    0.553720] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.553857] pci 0000:00:16.0: PME# disabled
[    0.554021] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    0.554171] pci 0000:00:1a.0: reg 10: [mem 0xfb608000-0xfb6083ff]
[    0.554366] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.554500] pci 0000:00:1a.0: PME# disabled
[    0.554651] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    0.554796] pci 0000:00:1b.0: reg 10: [mem 0xfb600000-0xfb603fff 64bit]
[    0.554982] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.555115] pci 0000:00:1b.0: PME# disabled
[    0.555258] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    0.555441] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.555577] pci 0000:00:1c.0: PME# disabled
[    0.555725] pci 0000:00:1c.1: [8086:3b44] type 1 class 0x000604
[    0.555905] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.556039] pci 0000:00:1c.1: PME# disabled
[    0.556185] pci 0000:00:1c.2: [8086:3b46] type 1 class 0x000604
[    0.556368] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.556503] pci 0000:00:1c.2: PME# disabled
[    0.556651] pci 0000:00:1c.3: [8086:3b48] type 1 class 0x000604
[    0.556831] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.556969] pci 0000:00:1c.3: PME# disabled
[    0.557126] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    0.557278] pci 0000:00:1d.0: reg 10: [mem 0xfb607000-0xfb6073ff]
[    0.557472] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.557607] pci 0000:00:1d.0: PME# disabled
[    0.557750] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.557937] pci 0000:00:1f.0: [8086:3b09] type 0 class 0x000601
[    0.558184] pci 0000:00:1f.2: [8086:3b29] type 0 class 0x000106
[    0.558337] pci 0000:00:1f.2: reg 10: [io  0xf070-0xf077]
[    0.558476] pci 0000:00:1f.2: reg 14: [io  0xf060-0xf063]
[    0.558612] pci 0000:00:1f.2: reg 18: [io  0xf050-0xf057]
[    0.558749] pci 0000:00:1f.2: reg 1c: [io  0xf040-0xf043]
[    0.558887] pci 0000:00:1f.2: reg 20: [io  0xf020-0xf03f]
[    0.559027] pci 0000:00:1f.2: reg 24: [mem 0xfb606000-0xfb6067ff]
[    0.559198] pci 0000:00:1f.2: PME# supported from D3hot
[    0.559331] pci 0000:00:1f.2: PME# disabled
[    0.559479] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    0.559621] pci 0000:00:1f.3: reg 10: [mem 0xfb605000-0xfb6050ff 64bit]
[    0.559775] pci 0000:00:1f.3: reg 20: [io  0xf000-0xf01f]
[    0.559940] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
[    0.560091] pci 0000:00:1f.6: reg 10: [mem 0xfb604000-0xfb604fff 64bit]
[    0.560350] pci 0000:01:00.0: [8086:422b] type 0 class 0x000280
[    0.560511] pci 0000:01:00.0: reg 10: [mem 0xfb500000-0xfb501fff 64bit]
[    0.560764] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.560899] pci 0000:01:00.0: PME# disabled
[    0.561050] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.561183] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.561322] pci 0000:00:1c.0:   bridge window [mem 0xfb500000-0xfb5fffff]
[    0.561460] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.561714] pci 0000:00:1c.1: PCI bridge to [bus 02-03]
[    0.561845] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    0.561980] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfaffffff]
[    0.562118] pci 0000:00:1c.1:   bridge window [mem 0xd2000000-0xd2ffffff 64bit pref]
[    0.562374] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
[    0.562507] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.562641] pci 0000:00:1c.2:   bridge window [mem 0xf9000000-0xf9ffffff]
[    0.562777] pci 0000:00:1c.2:   bridge window [mem 0xd0000000-0xd0ffffff 64bit pref]
[    0.563057] pci 0000:06:00.0: [1969:1026] type 0 class 0x000200
[    0.563210] pci 0000:06:00.0: reg 10: [mem 0xfb400000-0xfb43ffff 64bit]
[    0.563353] pci 0000:06:00.0: reg 18: [io  0xc000-0xc07f]
[    0.563558] pci 0000:06:00.0: PME# supported from D3hot D3cold
[    0.563693] pci 0000:06:00.0: PME# disabled
[    0.563838] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.564064] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.564198] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    0.564333] pci 0000:00:1c.3:   bridge window [mem 0xfb400000-0xfb4fffff]
[    0.564470] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.564743] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
[    0.564882] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.565020] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.565242] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.565462] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.565679] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.565895] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.566120] pci 0000:00:1e.0:   bridge window [mem 0x7c000000-0xffffffff] (subtractive decode)
[    0.566358] pci_bus 0000:00: on NUMA node 0
[    0.566489] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.567106] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR20._PRT]
[    0.569867] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.570075] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.570324] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.570608] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.617459] initcall acpi_pci_root_init+0x0/0x2d returned 0 after 64453 usecs
[    0.617594] calling  acpi_pci_link_init+0x0/0x43 @ 1
[    0.617796] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.618404] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.619013] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.619581] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *4 5 6 10 11 12 14 15)
[    0.620157] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.620882] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.621602] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.622212] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.622824] initcall acpi_pci_link_init+0x0/0x43 returned 0 after 5859 usecs
[    0.622962] calling  pnp_init+0x0/0x12 @ 1
[    0.623146] initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
[    0.623280] calling  misc_init+0x0/0xb7 @ 1
[    0.623463] initcall misc_init+0x0/0xb7 returned 0 after 0 usecs
[    0.623599] calling  vga_arb_device_init+0x0/0x80 @ 1
[    0.623820] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.624047] vgaarb: loaded
[    0.624170] initcall vga_arb_device_init+0x0/0x80 returned 0 after 976 usecs
[    0.624307] calling  init_scsi+0x0/0x81 @ 1
[    0.624786] SCSI subsystem initialized
[    0.624914] initcall init_scsi+0x0/0x81 returned 0 after 976 usecs
[    0.625048] calling  ata_init+0x0/0x33a @ 1
[    0.625347] libata version 3.00 loaded.
[    0.625474] initcall ata_init+0x0/0x33a returned 0 after 0 usecs
[    0.625607] calling  phy_init+0x0/0x2e @ 1
[    0.625884] initcall phy_init+0x0/0x2e returned 0 after 976 usecs
[    0.626018] calling  init_pcmcia_cs+0x0/0x36 @ 1
[    0.626194] initcall init_pcmcia_cs+0x0/0x36 returned 0 after 0 usecs
[    0.626330] calling  usb_init+0x0/0x15f @ 1
[    0.626575] usbcore: registered new interface driver usbfs
[    0.626768] usbcore: registered new interface driver hub
[    0.626969] usbcore: registered new device driver usb
[    0.627100] initcall usb_init+0x0/0x15f returned 0 after 976 usecs
[    0.627232] calling  serio_init+0x0/0x86 @ 1
[    0.627429] initcall serio_init+0x0/0x86 returned 0 after 0 usecs
[    0.627561] calling  input_init+0x0/0x10c @ 1
[    0.627744] initcall input_init+0x0/0x10c returned 0 after 0 usecs
[    0.627881] calling  rtc_init+0x0/0x6c @ 1
[    0.628062] initcall rtc_init+0x0/0x6c returned 0 after 0 usecs
[    0.628195] calling  power_supply_class_init+0x0/0x44 @ 1
[    0.628376] initcall power_supply_class_init+0x0/0x44 returned 0 after 0 usecs
[    0.628594] calling  thermal_init+0x0/0x3f @ 1
[    0.628770] initcall thermal_init+0x0/0x3f returned 0 after 976 usecs
[    0.628906] calling  leds_init+0x0/0x48 @ 1
[    0.629083] initcall leds_init+0x0/0x48 returned 0 after 0 usecs
[    0.629218] calling  init_soundcore+0x0/0x95 @ 1
[    0.629396] initcall init_soundcore+0x0/0x95 returned 0 after 0 usecs
[    0.629532] calling  alsa_sound_init+0x0/0x95 @ 1
[    0.629688] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.629827] initcall alsa_sound_init+0x0/0x95 returned 0 after 976 usecs
[    0.629965] calling  pci_subsys_init+0x0/0x4d @ 1
[    0.630093] PCI: Using ACPI for IRQ routing
[    0.630219] PCI: pci_cache_line_size set to 64 bytes
[    0.630414] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    0.630468] reserve RAM buffer: 00000000775c2000 - 0000000077ffffff 
[    0.630640] reserve RAM buffer: 0000000077800000 - 0000000077ffffff 
[    0.630812] initcall pci_subsys_init+0x0/0x4d returned 0 after 976 usecs
[    0.631058] calling  proto_init+0x0/0x12 @ 1
[    0.631189] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    0.631324] calling  net_dev_init+0x0/0x1c2 @ 1
[    0.631694] initcall net_dev_init+0x0/0x1c2 returned 0 after 0 usecs
[    0.631835] calling  neigh_init+0x0/0x71 @ 1
[    0.631964] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
[    0.632096] calling  genl_init+0x0/0x84 @ 1
[    0.632240] initcall genl_init+0x0/0x84 returned 0 after 0 usecs
[    0.632374] calling  wireless_nlevent_init+0x0/0x12 @ 1
[    0.632505] initcall wireless_nlevent_init+0x0/0x12 returned 0 after 0 usecs
[    0.632641] calling  rfkill_init+0x0/0x79 @ 1
[    0.632888] initcall rfkill_init+0x0/0x79 returned 0 after 0 usecs
[    0.633022] calling  sysctl_init+0x0/0x48 @ 1
[    0.633150] initcall sysctl_init+0x0/0x48 returned 0 after 0 usecs
[    0.633286] calling  print_ICs+0x0/0x526 @ 1
[    0.633412] initcall print_ICs+0x0/0x526 returned 0 after 0 usecs
[    0.633544] calling  hpet_late_init+0x0/0xf7 @ 1
[    0.633677] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.634108] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.636243] initcall hpet_late_init+0x0/0xf7 returned 0 after 2929 usecs
[    0.636379] calling  init_k8_nbs+0x0/0x28 @ 1
[    0.636518] initcall init_k8_nbs+0x0/0x28 returned 0 after 0 usecs
[    0.636653] calling  clocksource_done_booting+0x0/0x5a @ 1
[    0.636786] Switching to clocksource tsc
[    0.636918] initcall clocksource_done_booting+0x0/0x5a returned 0 after 1 usecs
[    0.637136] calling  rb_init_debugfs+0x0/0x2f @ 1
[    0.637270] initcall rb_init_debugfs+0x0/0x2f returned 0 after 5 usecs
[    0.637405] calling  tracer_init_debugfs+0x0/0x348 @ 1
[    0.637655] initcall tracer_init_debugfs+0x0/0x348 returned 0 after 118 usecs
[    0.637793] calling  init_trace_printk_function_export+0x0/0x2f @ 1
[    0.637933] initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 2 usecs
[    0.638153] calling  event_trace_init+0x0/0x2c0 @ 1
[    0.641347] initcall event_trace_init+0x0/0x2c0 returned 0 after 3000 usecs
[    0.641485] calling  init_kprobe_trace+0x0/0x78 @ 1
[    0.641621] initcall init_kprobe_trace+0x0/0x78 returned 0 after 5 usecs
[    0.641760] calling  init_pipe_fs+0x0/0x4c @ 1
[    0.641909] initcall init_pipe_fs+0x0/0x4c returned 0 after 19 usecs
[    0.642046] calling  eventpoll_init+0x0/0xba @ 1
[    0.642207] initcall eventpoll_init+0x0/0xba returned 0 after 29 usecs
[    0.642342] calling  anon_inode_init+0x0/0x143 @ 1
[    0.642482] initcall anon_inode_init+0x0/0x143 returned 0 after 10 usecs
[    0.642618] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
[    0.642752] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
[    0.642890] calling  acpi_event_init+0x0/0x81 @ 1
[    0.643042] initcall acpi_event_init+0x0/0x81 returned 0 after 23 usecs
[    0.643179] calling  pnpacpi_init+0x0/0x8c @ 1
[    0.643307] pnp: PnP ACPI init
[    0.643442] ACPI: bus type pnp registered
[    0.643665] pnp 00:00: [bus 00-ff]
[    0.643795] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.643924] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.644054] pnp 00:00: [io  0x0d00-0xffff window]
[    0.644183] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.644313] pnp 00:00: [mem 0x00000000 window]
[    0.644440] pnp 00:00: [mem 0x7c000000-0xffffffff window]
[    0.644702] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.645019] pnp 00:01: [mem 0xfed14000-0xfed19fff]
[    0.645149] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.645280] pnp 00:01: [mem 0xfed90000-0xfed93fff]
[    0.645411] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    0.645541] pnp 00:01: [mem 0xfee00000-0xfee0ffff]
[    0.645757] pnp 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.645946] pnp 00:02: [dma 4]
[    0.646067] pnp 00:02: [io  0x0000-0x000f]
[    0.646192] pnp 00:02: [io  0x0081-0x0083]
[    0.646316] pnp 00:02: [io  0x0087]
[    0.646437] pnp 00:02: [io  0x0089-0x008b]
[    0.646560] pnp 00:02: [io  0x008f]
[    0.646682] pnp 00:02: [io  0x00c0-0x00df]
[    0.646883] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.647032] pnp 00:03: [io  0x0070-0x0071]
[    0.647167] pnp 00:03: [irq 8]
[    0.647363] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.647511] pnp 00:04: [io  0x0061]
[    0.647701] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.647874] pnp 00:05: [io  0x0010-0x001f]
[    0.648000] pnp 00:05: [io  0x0022-0x003f]
[    0.648129] pnp 00:05: [io  0x0044-0x005f]
[    0.648254] pnp 00:05: [io  0x0062-0x0063]
[    0.648380] pnp 00:05: [io  0x0065-0x006f]
[    0.648504] pnp 00:05: [io  0x0072-0x007f]
[    0.648628] pnp 00:05: [io  0x0080]
[    0.648753] pnp 00:05: [io  0x0084-0x0086]
[    0.648878] pnp 00:05: [io  0x0088]
[    0.649001] pnp 00:05: [io  0x008c-0x008e]
[    0.649126] pnp 00:05: [io  0x0090-0x009f]
[    0.649251] pnp 00:05: [io  0x00a2-0x00bf]
[    0.649375] pnp 00:05: [io  0x00e0-0x00ef]
[    0.649499] pnp 00:05: [io  0x04d0-0x04d1]
[    0.649715] pnp 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.649866] pnp 00:06: [io  0x00f0-0x00ff]
[    0.649997] pnp 00:06: [irq 13]
[    0.650188] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.650390] pnp 00:07: [irq 12]
[    0.650588] pnp 00:07: Plug and Play ACPI device, IDs STLc003 PNP0f03 (active)
[    0.650848] pnp 00:08: [io  0x0060]
[    0.650973] pnp 00:08: [io  0x0064]
[    0.651101] pnp 00:08: [irq 1]
[    0.651299] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.651867] pnp 00:09: [io  0x0400-0x047f]
[    0.651993] pnp 00:09: [io  0x1180-0x119f]
[    0.652118] pnp 00:09: [io  0x0500-0x057f]
[    0.652243] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
[    0.652370] pnp 00:09: [mem 0xfec00000-0xfecfffff]
[    0.652497] pnp 00:09: [mem 0xfed08000-0xfed08fff]
[    0.652624] pnp 00:09: [mem 0xff000000-0xffffffff]
[    0.652845] pnp 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.653223] pnp 00:0a: [mem 0xfed00000-0xfed003ff]
[    0.653445] pnp 00:0a: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.658036] pnp: PnP ACPI: found 11 devices
[    0.658160] ACPI: ACPI bus type pnp unregistered
[    0.658288] initcall pnpacpi_init+0x0/0x8c returned 0 after 14664 usecs
[    0.658424] calling  pnp_system_init+0x0/0x12 @ 1
[    0.658562] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
[    0.658701] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.658839] system 00:01: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.658974] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.659108] system 00:01: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.659247] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.659386] system 00:09: [io  0x0400-0x047f] has been reserved
[    0.659520] system 00:09: [io  0x1180-0x119f] has been reserved
[    0.659651] system 00:09: [io  0x0500-0x057f] has been reserved
[    0.659785] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.659922] system 00:09: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.660059] system 00:09: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.660196] system 00:09: [mem 0xff000000-0xffffffff] has been reserved
[    0.660384] initcall pnp_system_init+0x0/0x12 returned 0 after 1792 usecs
[    0.660519] calling  chr_dev_init+0x0/0xc5 @ 1
[    0.666344] initcall chr_dev_init+0x0/0xc5 returned 0 after 5576 usecs
[    0.666482] calling  firmware_class_init+0x0/0x19 @ 1
[    0.666669] initcall firmware_class_init+0x0/0x19 returned 0 after 53 usecs
[    0.666807] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    0.666939] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
[    0.667155] calling  cpufreq_gov_dbs_init+0x0/0xae @ 1
[    0.667314] initcall cpufreq_gov_dbs_init+0x0/0xae returned 0 after 26 usecs
[    0.667452] calling  init_acpi_pm_clocksource+0x0/0xdc @ 1
[    0.672093] initcall init_acpi_pm_clocksource+0x0/0xdc returned 0 after 4414 usecs
[    0.672312] calling  ssb_modinit+0x0/0x59 @ 1
[    0.672496] initcall ssb_modinit+0x0/0x59 returned 0 after 55 usecs
[    0.672628] calling  pcibios_assign_resources+0x0/0x74 @ 1
[    0.672805] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.672937] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.673070] pci 0000:00:1c.0:   bridge window [mem 0xfb500000-0xfb5fffff]
[    0.673205] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.673342] pci 0000:00:1c.1: PCI bridge to [bus 02-03]
[    0.673476] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    0.673611] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfaffffff]
[    0.673748] pci 0000:00:1c.1:   bridge window [mem 0xd2000000-0xd2ffffff 64bit pref]
[    0.673968] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
[    0.674100] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.674235] pci 0000:00:1c.2:   bridge window [mem 0xf9000000-0xf9ffffff]
[    0.674371] pci 0000:00:1c.2:   bridge window [mem 0xd0000000-0xd0ffffff 64bit pref]
[    0.674594] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.674730] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    0.674864] pci 0000:00:1c.3:   bridge window [mem 0xfb400000-0xfb4fffff]
[    0.675000] pci 0000:00:1c.3:   bridge window [mem pref disabled]
[    0.675136] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    0.675266] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.675400] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.675533] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.675683] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.675819] pci 0000:00:1c.0: setting latency timer to 64
[    0.675956] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.676093] pci 0000:00:1c.1: setting latency timer to 64
[    0.676230] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.676366] pci 0000:00:1c.2: setting latency timer to 64
[    0.676506] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.676646] pci 0000:00:1c.3: setting latency timer to 64
[    0.676782] pci 0000:00:1e.0: setting latency timer to 64
[    0.676914] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.677046] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.677177] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.677309] pci_bus 0000:00: resource 7 [mem 0x7c000000-0xffffffff]
[    0.677441] pci_bus 0000:01: resource 1 [mem 0xfb500000-0xfb5fffff]
[    0.677577] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.677711] pci_bus 0000:02: resource 1 [mem 0xfa000000-0xfaffffff]
[    0.677846] pci_bus 0000:02: resource 2 [mem 0xd2000000-0xd2ffffff 64bit pref]
[    0.678062] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.678193] pci_bus 0000:04: resource 1 [mem 0xf9000000-0xf9ffffff]
[    0.678328] pci_bus 0000:04: resource 2 [mem 0xd0000000-0xd0ffffff 64bit pref]
[    0.678545] pci_bus 0000:06: resource 0 [io  0xc000-0xcfff]
[    0.678677] pci_bus 0000:06: resource 1 [mem 0xfb400000-0xfb4fffff]
[    0.678809] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    0.678939] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    0.679071] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    0.679207] pci_bus 0000:07: resource 7 [mem 0x7c000000-0xffffffff]
[    0.679342] initcall pcibios_assign_resources+0x0/0x74 returned 0 after 6442 usecs
[    0.679560] calling  sysctl_core_init+0x0/0x38 @ 1
[    0.679706] initcall sysctl_core_init+0x0/0x38 returned 0 after 13 usecs
[    0.679844] calling  inet_init+0x0/0x27f @ 1
[    0.680052] NET: Registered protocol family 2
[    0.680251] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.680713] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.682100] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.682519] TCP: Hash tables configured (established 262144 bind 65536)
[    0.682660] TCP reno registered
[    0.682784] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.682929] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.683198] initcall inet_init+0x0/0x27f returned 0 after 3155 usecs
[    0.683334] calling  af_unix_init+0x0/0x55 @ 1
[    0.683475] NET: Registered protocol family 1
[    0.683607] initcall af_unix_init+0x0/0x55 returned 0 after 142 usecs
[    0.683745] calling  init_sunrpc+0x0/0x73 @ 1
[    0.684074] RPC: Registered udp transport module.
[    0.684203] RPC: Registered tcp transport module.
[    0.684332] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.684464] initcall init_sunrpc+0x0/0x73 returned 0 after 578 usecs
[    0.684598] calling  pci_apply_final_quirks+0x0/0x106 @ 1
[    0.684741] pci 0000:00:02.0: Boot video device
[    0.728550] PCI: CLS 64 bytes, default 64
[    0.728684] initcall pci_apply_final_quirks+0x0/0x106 returned 0 after 43027 usecs
[    0.728908] calling  populate_rootfs+0x0/0x100 @ 1
[    0.729230] initcall populate_rootfs+0x0/0x100 returned 0 after 186 usecs
[    0.729368] calling  pci_iommu_init+0x0/0x41 @ 1
[    0.729498] initcall pci_iommu_init+0x0/0x41 returned 0 after 0 usecs
[    0.729639] calling  i8259A_init_sysfs+0x0/0x31 @ 1
[    0.729894] initcall i8259A_init_sysfs+0x0/0x31 returned 0 after 119 usecs
[    0.730033] calling  vsyscall_init+0x0/0x6c @ 1
[    0.730171] initcall vsyscall_init+0x0/0x6c returned 0 after 7 usecs
[    0.730307] calling  sbf_init+0x0/0xe9 @ 1
[    0.730436] initcall sbf_init+0x0/0xe9 returned 0 after 0 usecs
[    0.730573] calling  i8237A_init_sysfs+0x0/0x22 @ 1
[    0.730804] initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 95 usecs
[    0.730943] calling  add_rtc_cmos+0x0/0x97 @ 1
[    0.731076] initcall add_rtc_cmos+0x0/0x97 returned 0 after 2 usecs
[    0.731213] calling  cache_sysfs_init+0x0/0x64 @ 1
[    0.732415] initcall cache_sysfs_init+0x0/0x64 returned 0 after 1047 usecs
[    0.732557] calling  mcheck_init_device+0x0/0x106 @ 1
[    0.733081] initcall mcheck_init_device+0x0/0x106 returned 0 after 381 usecs
[    0.733219] calling  threshold_init_device+0x0/0x8c @ 1
[    0.733353] initcall threshold_init_device+0x0/0x8c returned 0 after 0 usecs
[    0.733496] calling  thermal_throttle_init_device+0x0/0x9b @ 1
[    0.733639] initcall thermal_throttle_init_device+0x0/0x9b returned 0 after 8 usecs
[    0.733862] calling  msr_init+0x0/0x14a @ 1
[    0.734357] initcall msr_init+0x0/0x14a returned 0 after 359 usecs
[    0.734497] calling  cpuid_init+0x0/0x14a @ 1
[    0.734975] initcall cpuid_init+0x0/0x14a returned 0 after 341 usecs
[    0.735113] calling  ioapic_init_sysfs+0x0/0xb3 @ 1
[    0.735341] initcall ioapic_init_sysfs+0x0/0xb3 returned 0 after 94 usecs
[    0.735480] calling  add_pcspkr+0x0/0x3a @ 1
[    0.735679] initcall add_pcspkr+0x0/0x3a returned 0 after 66 usecs
[    0.735815] calling  microcode_init+0x0/0x138 @ 1
[    0.736007] microcode: CPU0 sig=0x20652, pf=0x10, revision=0x9
[    0.736145] microcode: CPU1 sig=0x20652, pf=0x10, revision=0x0
[    0.736284] microcode: CPU2 sig=0x20652, pf=0x10, revision=0x9
[    0.736420] microcode: CPU3 sig=0x20652, pf=0x10, revision=0x0
[    0.736628] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.736854] initcall microcode_init+0x0/0x138 returned 0 after 889 usecs
[    0.736993] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    0.737126] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 2 usecs
[    0.737264] calling  init_aout_binfmt+0x0/0x14 @ 1
[    0.737395] initcall init_aout_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.737537] calling  init_sched_debug_procfs+0x0/0x2c @ 1
[    0.737671] initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 4 usecs
[    0.737891] calling  proc_schedstat_init+0x0/0x22 @ 1
[    0.738025] initcall proc_schedstat_init+0x0/0x22 returned 0 after 2 usecs
[    0.738163] calling  proc_execdomains_init+0x0/0x22 @ 1
[    0.738299] initcall proc_execdomains_init+0x0/0x22 returned 0 after 2 usecs
[    0.738437] calling  ioresources_init+0x0/0x3c @ 1
[    0.738575] initcall ioresources_init+0x0/0x3c returned 0 after 4 usecs
[    0.738712] calling  uid_cache_init+0x0/0x87 @ 1
[    0.738862] initcall uid_cache_init+0x0/0x87 returned 0 after 17 usecs
[    0.738999] calling  init_posix_timers+0x0/0x17a @ 1
[    0.739145] initcall init_posix_timers+0x0/0x17a returned 0 after 12 usecs
[    0.739283] calling  init_posix_cpu_timers+0x0/0xe5 @ 1
[    0.739416] initcall init_posix_cpu_timers+0x0/0xe5 returned 0 after 0 usecs
[    0.739557] calling  nsproxy_cache_init+0x0/0x2d @ 1
[    0.739705] initcall nsproxy_cache_init+0x0/0x2d returned 0 after 14 usecs
[    0.739845] calling  create_proc_profile+0x0/0x245 @ 1
[    0.739978] initcall create_proc_profile+0x0/0x245 returned 0 after 0 usecs
[    0.740116] calling  timekeeping_init_device+0x0/0x22 @ 1
[    0.740347] initcall timekeeping_init_device+0x0/0x22 returned 0 after 94 usecs
[    0.740571] calling  init_clocksource_sysfs+0x0/0x50 @ 1
[    0.740801] initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 93 usecs
[    0.741020] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    0.743627] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 2 usecs
[    0.743766] calling  init_tstats_procfs+0x0/0x2c @ 1
[    0.743900] initcall init_tstats_procfs+0x0/0x2c returned 0 after 2 usecs
[    0.744036] calling  futex_init+0x0/0x68 @ 1
[    0.744171] initcall futex_init+0x0/0x68 returned 0 after 4 usecs
[    0.744305] calling  proc_dma_init+0x0/0x22 @ 1
[    0.744437] initcall proc_dma_init+0x0/0x22 returned 0 after 2 usecs
[    0.744574] calling  proc_modules_init+0x0/0x22 @ 1
[    0.744707] initcall proc_modules_init+0x0/0x22 returned 0 after 2 usecs
[    0.744844] calling  kallsyms_init+0x0/0x25 @ 1
[    0.744976] initcall kallsyms_init+0x0/0x25 returned 0 after 2 usecs
[    0.745112] calling  ikconfig_init+0x0/0x3a @ 1
[    0.745244] initcall ikconfig_init+0x0/0x3a returned 0 after 1 usecs
[    0.745379] calling  init_kprobes+0x0/0x163 @ 1
[    0.765250] initcall init_kprobes+0x0/0x163 returned 0 after 19324 usecs
[    0.765387] calling  hung_task_init+0x0/0x53 @ 1
[    0.765542] initcall hung_task_init+0x0/0x53 returned 0 after 22 usecs
[    0.765680] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    0.765819] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 7 usecs
[    0.765959] calling  init_tracepoints+0x0/0x12 @ 1
[    0.766089] initcall init_tracepoints+0x0/0x12 returned 0 after 0 usecs
[    0.766226] calling  init_lstats_procfs+0x0/0x25 @ 1
[    0.766361] initcall init_lstats_procfs+0x0/0x25 returned 0 after 3 usecs
[    0.766501] calling  init_events+0x0/0x61 @ 1
[    0.766633] initcall init_events+0x0/0x61 returned 0 after 2 usecs
[    0.766768] calling  init_sched_switch_trace+0x0/0x12 @ 1
[    0.766902] initcall init_sched_switch_trace+0x0/0x12 returned 0 after 0 usecs
[    0.767121] calling  init_per_zone_wmark_min+0x0/0x67 @ 1
[    0.767310] initcall init_per_zone_wmark_min+0x0/0x67 returned 0 after 55 usecs
[    0.767530] calling  kswapd_init+0x0/0x20 @ 1
[    0.767684] initcall kswapd_init+0x0/0x20 returned 0 after 24 usecs
[    0.767821] calling  setup_vmstat+0x0/0xc5 @ 1
[    0.767966] initcall setup_vmstat+0x0/0xc5 returned 0 after 14 usecs
[    0.768102] calling  mm_sysfs_init+0x0/0x29 @ 1
[    0.768236] initcall mm_sysfs_init+0x0/0x29 returned 0 after 3 usecs
[    0.768372] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    0.768509] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 2 usecs
[    0.768647] calling  procswaps_init+0x0/0x22 @ 1
[    0.768780] initcall procswaps_init+0x0/0x22 returned 0 after 2 usecs
[    0.768917] calling  slab_proc_init+0x0/0x3f @ 1
[    0.769051] initcall slab_proc_init+0x0/0x3f returned 0 after 4 usecs
[    0.769187] calling  cpucache_init+0x0/0x40 @ 1
[    0.769318] initcall cpucache_init+0x0/0x40 returned 0 after 0 usecs
[    0.769455] calling  fcntl_init+0x0/0x2a @ 1
[    0.769598] initcall fcntl_init+0x0/0x2a returned 0 after 14 usecs
[    0.769734] calling  proc_filesystems_init+0x0/0x22 @ 1
[    0.769869] initcall proc_filesystems_init+0x0/0x22 returned 0 after 2 usecs
[    0.770008] calling  fsnotify_mark_init+0x0/0x3d @ 1
[    0.770160] initcall fsnotify_mark_init+0x0/0x3d returned 0 after 20 usecs
[    0.770298] calling  dnotify_init+0x0/0x7b @ 1
[    0.770458] initcall dnotify_init+0x0/0x7b returned 0 after 27 usecs
[    0.770595] calling  inotify_user_setup+0x0/0x70 @ 1
[    0.770758] initcall inotify_user_setup+0x0/0x70 returned 0 after 29 usecs
[    0.770896] calling  aio_setup+0x0/0xbd @ 1
[    0.771078] initcall aio_setup+0x0/0xbd returned 0 after 51 usecs
[    0.771213] calling  proc_locks_init+0x0/0x22 @ 1
[    0.771346] initcall proc_locks_init+0x0/0x22 returned 0 after 2 usecs
[    0.771485] calling  init_sys32_ioctl+0x0/0x28 @ 1
[    0.771693] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 73 usecs
[    0.771831] calling  init_mbcache+0x0/0x14 @ 1
[    0.771961] initcall init_mbcache+0x0/0x14 returned 0 after 0 usecs
[    0.772096] calling  proc_cmdline_init+0x0/0x22 @ 1
[    0.772230] initcall proc_cmdline_init+0x0/0x22 returned 0 after 2 usecs
[    0.772368] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    0.772503] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 2 usecs
[    0.772641] calling  proc_devices_init+0x0/0x22 @ 1
[    0.772775] initcall proc_devices_init+0x0/0x22 returned 0 after 2 usecs
[    0.772913] calling  proc_interrupts_init+0x0/0x22 @ 1
[    0.773047] initcall proc_interrupts_init+0x0/0x22 returned 0 after 2 usecs
[    0.773186] calling  proc_loadavg_init+0x0/0x22 @ 1
[    0.773319] initcall proc_loadavg_init+0x0/0x22 returned 0 after 2 usecs
[    0.773458] calling  proc_meminfo_init+0x0/0x22 @ 1
[    0.773592] initcall proc_meminfo_init+0x0/0x22 returned 0 after 2 usecs
[    0.773729] calling  proc_stat_init+0x0/0x22 @ 1
[    0.773862] initcall proc_stat_init+0x0/0x22 returned 0 after 2 usecs
[    0.774000] calling  proc_uptime_init+0x0/0x22 @ 1
[    0.774136] initcall proc_uptime_init+0x0/0x22 returned 0 after 4 usecs
[    0.774272] calling  proc_version_init+0x0/0x22 @ 1
[    0.774408] initcall proc_version_init+0x0/0x22 returned 0 after 2 usecs
[    0.774546] calling  proc_softirqs_init+0x0/0x22 @ 1
[    0.774680] initcall proc_softirqs_init+0x0/0x22 returned 0 after 2 usecs
[    0.774819] calling  proc_kcore_init+0x0/0xa9 @ 1
[    0.774955] initcall proc_kcore_init+0x0/0xa9 returned 0 after 6 usecs
[    0.775092] calling  proc_kmsg_init+0x0/0x25 @ 1
[    0.775225] initcall proc_kmsg_init+0x0/0x25 returned 0 after 2 usecs
[    0.775361] calling  proc_page_init+0x0/0x42 @ 1
[    0.775498] initcall proc_page_init+0x0/0x42 returned 0 after 4 usecs
[    0.775634] calling  init_devpts_fs+0x0/0x4c @ 1
[    0.775779] initcall init_devpts_fs+0x0/0x4c returned 0 after 14 usecs
[    0.775916] calling  init_reiserfs_fs+0x0/0x63 @ 1
[    0.776061] initcall init_reiserfs_fs+0x0/0x63 returned 0 after 13 usecs
[    0.776198] calling  init_ext3_fs+0x0/0x72 @ 1
[    0.776363] initcall init_ext3_fs+0x0/0x72 returned 0 after 34 usecs
[    0.776502] calling  init_ext2_fs+0x0/0x71 @ 1
[    0.776665] initcall init_ext2_fs+0x0/0x71 returned 0 after 33 usecs
[    0.776802] calling  ext4_init_fs+0x0/0x138 @ 1
[    0.777063] initcall ext4_init_fs+0x0/0x138 returned 0 after 127 usecs
[    0.777200] calling  journal_init+0x0/0x99 @ 1
[    0.777386] initcall journal_init+0x0/0x99 returned 0 after 54 usecs
[    0.777523] calling  journal_init+0x0/0xaf @ 1
[    0.777710] initcall journal_init+0x0/0xaf returned 0 after 55 usecs
[    0.777846] calling  init_ramfs_fs+0x0/0x12 @ 1
[    0.777977] initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
[    0.778113] calling  init_fat_fs+0x0/0x4f @ 1
[    0.778270] initcall init_fat_fs+0x0/0x4f returned 0 after 27 usecs
[    0.778408] calling  init_vfat_fs+0x0/0x12 @ 1
[    0.778539] initcall init_vfat_fs+0x0/0x12 returned 0 after 0 usecs
[    0.778675] calling  init_msdos_fs+0x0/0x12 @ 1
[    0.778805] initcall init_msdos_fs+0x0/0x12 returned 0 after 0 usecs
[    0.778941] calling  init_iso9660_fs+0x0/0x63 @ 1
[    0.779087] initcall init_iso9660_fs+0x0/0x63 returned 0 after 15 usecs
[    0.779225] calling  init_nfs_fs+0x0/0x145 @ 1
[    0.779629] initcall init_nfs_fs+0x0/0x145 returned 0 after 268 usecs
[    0.779766] calling  init_nfsd+0x0/0xbb @ 1
[    0.779895] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.780534] initcall init_nfsd+0x0/0xbb returned 0 after 623 usecs
[    0.780670] calling  init_nlm+0x0/0x22 @ 1
[    0.780805] initcall init_nlm+0x0/0x22 returned 0 after 6 usecs
[    0.780940] calling  init_nls_cp437+0x0/0x12 @ 1
[    0.781071] initcall init_nls_cp437+0x0/0x12 returned 0 after 0 usecs
[    0.781208] calling  init_nls_ascii+0x0/0x12 @ 1
[    0.781339] initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
[    0.781477] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    0.781609] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 usecs
[    0.781748] calling  init_nls_iso8859_15+0x0/0x12 @ 1
[    0.781879] initcall init_nls_iso8859_15+0x0/0x12 returned 0 after 0 usecs
[    0.782018] calling  init_nls_utf8+0x0/0x29 @ 1
[    0.782148] initcall init_nls_utf8+0x0/0x29 returned 0 after 0 usecs
[    0.782285] calling  init_autofs4_fs+0x0/0x26 @ 1
[    0.782494] initcall init_autofs4_fs+0x0/0x26 returned 0 after 74 usecs
[    0.782633] calling  ipc_init+0x0/0x23 @ 1
[    0.782765] msgmni has been set to 3741
[    0.782899] initcall ipc_init+0x0/0x23 returned 0 after 134 usecs
[    0.783035] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    0.783177] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 11 usecs
[    0.783315] calling  init_mqueue_fs+0x0/0xb4 @ 1
[    0.783482] initcall init_mqueue_fs+0x0/0xb4 returned 0 after 33 usecs
[    0.783618] calling  proc_genhd_init+0x0/0x3c @ 1
[    0.783755] initcall proc_genhd_init+0x0/0x3c returned 0 after 5 usecs
[    0.783892] calling  noop_init+0x0/0x14 @ 1
[    0.784020] io scheduler noop registered
[    0.784147] initcall noop_init+0x0/0x14 returned 0 after 124 usecs
[    0.784282] calling  deadline_init+0x0/0x14 @ 1
[    0.784414] io scheduler deadline registered
[    0.784544] initcall deadline_init+0x0/0x14 returned 0 after 126 usecs
[    0.784680] calling  cfq_init+0x0/0x9e @ 1
[    0.784838] io scheduler cfq registered (default)
[    0.784968] initcall cfq_init+0x0/0x9e returned 0 after 156 usecs
[    0.785103] calling  percpu_counter_startup+0x0/0x19 @ 1
[    0.785236] initcall percpu_counter_startup+0x0/0x19 returned 0 after 0 usecs
[    0.785378] calling  dynamic_debug_init_debugfs+0x0/0x6a @ 1
[    0.785518] initcall dynamic_debug_init_debugfs+0x0/0x6a returned 0 after 6 usecs
[    0.785738] calling  pci_proc_init+0x0/0x6a @ 1
[    0.785928] initcall pci_proc_init+0x0/0x6a returned 0 after 59 usecs
[    0.786064] calling  pcie_portdrv_init+0x0/0x6d @ 1
[    0.786833] pcieport 0000:00:1c.0: ACPI _OSC control granted for 0x1c
[    0.786979] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.787148] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.787892] pcieport 0000:00:1c.1: ACPI _OSC control granted for 0x1c
[    0.788036] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.788199] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.788939] pcieport 0000:00:1c.2: ACPI _OSC control granted for 0x1c
[    0.789082] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.789247] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    0.789992] pcieport 0000:00:1c.3: ACPI _OSC control granted for 0x1c
[    0.790136] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.790300] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    0.790591] initcall pcie_portdrv_init+0x0/0x6d returned 0 after 4303 usecs
[    0.790730] calling  aer_service_init+0x0/0x22 @ 1
[    0.790910] initcall aer_service_init+0x0/0x22 returned 0 after 47 usecs
[    0.791048] calling  pcie_pme_service_init+0x0/0x12 @ 1
[    0.791210] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.791352] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.791492] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.791652] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    0.791793] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    0.791956] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    0.794578] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
[    0.794738] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    0.794875] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
[    0.795014] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    0.795201] initcall pcie_pme_service_init+0x0/0x12 returned 0 after 3935 usecs
[    0.795424] calling  ioapic_init+0x0/0x1b @ 1
[    0.795610] initcall ioapic_init+0x0/0x1b returned 0 after 55 usecs
[    0.795747] calling  genericbl_init+0x0/0x12 @ 1
[    0.795927] initcall genericbl_init+0x0/0x12 returned 0 after 48 usecs
[    0.796065] calling  intel_idle_init+0x0/0x300 @ 1
[    0.796196] intel_idle: MWAIT substates: 0x1120
[    0.796325] intel_idle: v0.4 model 0x25
[    0.796456] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.796780] initcall intel_idle_init+0x0/0x300 returned 0 after 570 usecs
[    0.796919] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    0.797056] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 3 usecs
[    0.797195] calling  irqrouter_init_sysfs+0x0/0x38 @ 1
[    0.797423] initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 94 usecs
[    0.797565] calling  acpi_button_init+0x0/0x56 @ 1
[    0.797846] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0A08:00/PNP0C0D:00/input/input0
[    0.914101] ACPI: Lid Switch [LID]
[    0.914340] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.914565] ACPI: Sleep Button [SLPB]
[    0.914791] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    0.915015] ACPI: Power Button [PWRB]
[    0.915253] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.915474] ACPI: Power Button [PWRF]
[    0.915656] initcall acpi_button_init+0x0/0x56 returned 0 after 115478 usecs
[    0.915795] calling  acpi_processor_init+0x0/0x10b @ 1
[    0.915929] ACPI: acpi_idle yielding to intel_idle
[    0.917468] initcall acpi_processor_init+0x0/0x10b returned 0 after 1506 usecs
[    0.917688] calling  acpi_container_init+0x0/0x4a @ 1
[    0.923664] initcall acpi_container_init+0x0/0x4a returned 0 after 5720 usecs
[    0.923805] calling  acpi_battery_init+0x0/0x16 @ 1
[    0.923939] initcall acpi_battery_init+0x0/0x16 returned 0 after 2 usecs
[    0.923943] calling  1_acpi_battery_init_async+0x0/0x3c @ 5
[    0.924219] calling  pty_init+0x0/0x50d @ 1
[    0.960772] power_supply BAT0: uevent
[    0.960898] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    0.972150] initcall pty_init+0x0/0x50d returned 0 after 46793 usecs
[    0.972288] calling  sysrq_init+0x0/0x78 @ 1
[    0.972426] initcall sysrq_init+0x0/0x78 returned 0 after 8 usecs
[    0.972563] calling  rand_initialize+0x0/0x2c @ 1
[    0.972702] initcall rand_initialize+0x0/0x2c returned 0 after 9 usecs
[    0.972839] calling  raw_init+0x0/0xe5 @ 1
[    0.973166] initcall raw_init+0x0/0xe5 returned 0 after 185 usecs
[    0.973303] calling  hpet_init+0x0/0x6a @ 1
[    0.993050] power_supply BAT0: prop STATUS=Discharging
[    0.993184] power_supply BAT0: prop PRESENT=1
[    0.993313] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    0.993445] power_supply BAT0: prop CYCLE_COUNT=0
[    0.993575] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[    0.993710] power_supply BAT0: prop VOLTAGE_NOW=10678000
[    0.993845] power_supply BAT0: prop CURRENT_NOW=2589000
[    0.993978] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[    0.994113] power_supply BAT0: prop CHARGE_FULL=4508000
[    0.994246] power_supply BAT0: prop CHARGE_NOW=2441000
[    0.994377] power_supply BAT0: prop MODEL_NAME=SP624
[    0.994509] power_supply BAT0: prop MANUFACTURER=PEGATRON
[    0.994642] power_supply BAT0: prop SERIAL_NUMBER= 
[    0.994826] power_supply BAT0: power_supply_changed
[    0.994962] power_supply BAT0: power_supply_changed_work
[    0.995096] power_supply BAT0: power_supply_update_bat_leds 2
[    0.995238] power_supply BAT0: uevent
[    0.995365] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    0.995497] power_supply BAT0: prop STATUS=Discharging
[    0.995631] power_supply BAT0: prop PRESENT=1
[    0.995760] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    0.995894] power_supply BAT0: prop CYCLE_COUNT=0
[    0.996026] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[    0.996160] power_supply BAT0: prop VOLTAGE_NOW=10678000
[    0.996294] power_supply BAT0: prop CURRENT_NOW=2589000
[    0.996425] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[    0.996560] power_supply BAT0: prop CHARGE_FULL=4508000
[    0.996692] power_supply BAT0: prop CHARGE_NOW=2441000
[    0.996827] power_supply BAT0: prop MODEL_NAME=SP624
[    0.996960] power_supply BAT0: prop MANUFACTURER=PEGATRON
[    0.996975] ACPI: Battery Slot [BAT0] (battery present)
[    0.997076] initcall 1_acpi_battery_init_async+0x0/0x3c returned 0 after 71589 usecs
[    0.997145] initcall hpet_init+0x0/0x6a returned 0 after 23212 usecs
[    0.997147] calling  timeriomem_rng_init+0x0/0x12 @ 1
[    0.997212] initcall timeriomem_rng_init+0x0/0x12 returned 0 after 60 usecs
[    0.997215] calling  mod_init+0x0/0x22e @ 1
[    0.997257] initcall mod_init+0x0/0x22e returned -19 after 39 usecs
[    0.997259] calling  mod_init+0x0/0xba @ 1
[    0.997274] initcall mod_init+0x0/0xba returned -19 after 12 usecs
[    0.997276] calling  mod_init+0x0/0x5a @ 1
[    0.997278] initcall mod_init+0x0/0x5a returned -19 after 0 usecs
[    0.997280] calling  agp_init+0x0/0x26 @ 1
[    0.997281] Linux agpgart interface v0.103
[    0.997283] initcall agp_init+0x0/0x26 returned 0 after 1 usecs
[    0.997285] calling  agp_amd64_mod_init+0x0/0x22 @ 1
[    0.997360] initcall agp_amd64_mod_init+0x0/0x22 returned -19 after 70 usecs
[    0.997362] calling  agp_intel_init+0x0/0x29 @ 1
[    0.997419] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    0.997479] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
[    1.000284] power_supply BAT0: prop SERIAL_NUMBER= 
[    1.000394] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    1.016507] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    1.016726] initcall agp_intel_init+0x0/0x29 returned 0 after 18950 usecs
[    1.016867] calling  serial8250_init+0x0/0x183 @ 1
[    1.016998] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.017792] initcall serial8250_init+0x0/0x183 returned 0 after 775 usecs
[    1.017930] calling  serial8250_pnp_init+0x0/0x12 @ 1
[    1.018195] initcall serial8250_pnp_init+0x0/0x12 returned 0 after 128 usecs
[    1.018334] calling  serial8250_pci_init+0x0/0x1b @ 1
[    1.018529] initcall serial8250_pci_init+0x0/0x1b returned 0 after 60 usecs
[    1.018671] calling  topology_sysfs_init+0x0/0x50 @ 1
[    1.018835] initcall topology_sysfs_init+0x0/0x50 returned 0 after 31 usecs
[    1.018975] calling  brd_init+0x0/0x1a5 @ 1
[    1.021959] brd: module loaded
[    1.022085] initcall brd_init+0x0/0x1a5 returned 0 after 2917 usecs
[    1.022222] calling  loop_init+0x0/0x1b2 @ 1
[    1.023757] loop: module loaded
[    1.023887] initcall loop_init+0x0/0x1b2 returned 0 after 1501 usecs
[    1.024024] calling  spi_transport_init+0x0/0x79 @ 1
[    1.024267] initcall spi_transport_init+0x0/0x79 returned 0 after 108 usecs
[    1.024406] calling  fc_transport_init+0x0/0x8a @ 1
[    1.024731] initcall fc_transport_init+0x0/0x8a returned 0 after 188 usecs
[    1.024875] calling  ahd_linux_init+0x0/0x80 @ 1
[    1.025073] initcall ahd_linux_init+0x0/0x80 returned 0 after 65 usecs
[    1.025211] calling  init_sd+0x0/0x142 @ 1
[    1.025473] initcall init_sd+0x0/0x142 returned 0 after 130 usecs
[    1.025609] calling  init_sr+0x0/0x46 @ 1
[    1.025788] initcall init_sr+0x0/0x46 returned 0 after 47 usecs
[    1.025926] calling  init_sg+0x0/0xc6 @ 1
[    1.026106] initcall init_sg+0x0/0xc6 returned 0 after 49 usecs
[    1.026241] calling  ahci_init+0x0/0x1b @ 1
[    1.026383] ahci 0000:00:1f.2: version 3.0
[    1.026526] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.026709] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    1.037813] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    1.038038] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck pm led clo pio slum part ems sxs apst 
[    1.038265] ahci 0000:00:1f.2: setting latency timer to 64
[    1.045207] scsi0 : ahci
[    1.045537] scsi1 : ahci
[    1.045824] scsi2 : ahci
[    1.046108] scsi3 : ahci
[    1.046391] scsi4 : ahci
[    1.046671] scsi5 : ahci
[    1.047165] ata1: SATA max UDMA/133 abar m2048@0xfb606000 port 0xfb606100 irq 44
[    1.047386] ata2: SATA max UDMA/133 abar m2048@0xfb606000 port 0xfb606180 irq 44
[    1.047605] ata3: DUMMY
[    1.047727] ata4: DUMMY
[    1.047852] ata5: SATA max UDMA/133 abar m2048@0xfb606000 port 0xfb606300 irq 44
[    1.048074] ata6: SATA max UDMA/133 abar m2048@0xfb606000 port 0xfb606380 irq 44
[    1.048302] calling  2_async_port_probe+0x0/0xad @ 5
[    1.048305] calling  3_async_port_probe+0x0/0xad @ 18
[    1.048342] calling  4_async_port_probe+0x0/0xad @ 559
[    1.048349] async_waiting @ 559
[    1.048366] calling  5_async_port_probe+0x0/0xad @ 1187
[    1.048372] async_waiting @ 1187
[    1.048391] calling  6_async_port_probe+0x0/0xad @ 1188
[    1.048421] calling  7_async_port_probe+0x0/0xad @ 1189
[    1.048493] initcall ahci_init+0x0/0x1b returned 0 after 21655 usecs
[    1.048495] calling  piix_init+0x0/0x29 @ 1
[    1.048561] initcall piix_init+0x0/0x29 returned 0 after 61 usecs
[    1.048564] calling  nv_init+0x0/0x1b @ 1
[    1.048628] initcall nv_init+0x0/0x1b returned 0 after 59 usecs
[    1.048630] calling  sil_init+0x0/0x1b @ 1
[    1.048692] initcall sil_init+0x0/0x1b returned 0 after 57 usecs
[    1.048694] calling  k2_sata_init+0x0/0x1b @ 1
[    1.048762] initcall k2_sata_init+0x0/0x1b returned 0 after 63 usecs
[    1.048765] calling  svia_init+0x0/0x1b @ 1
[    1.048854] initcall svia_init+0x0/0x1b returned 0 after 83 usecs
[    1.048856] calling  amd_init+0x0/0x1b @ 1
[    1.048914] initcall amd_init+0x0/0x1b returned 0 after 54 usecs
[    1.048916] calling  pacpi_init+0x0/0x1b @ 1
[    1.048974] initcall pacpi_init+0x0/0x1b returned 0 after 53 usecs
[    1.048976] calling  ata_generic_init+0x0/0x1b @ 1
[    1.049034] initcall ata_generic_init+0x0/0x1b returned 0 after 53 usecs
[    1.049036] calling  e1000_init_module+0x0/0x87 @ 1
[    1.049038] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.049039] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.049102] initcall e1000_init_module+0x0/0x87 returned 0 after 61 usecs
[    1.049104] calling  vortex_init+0x0/0xac @ 1
[    1.049165] initcall vortex_init+0x0/0xac returned 0 after 57 usecs
[    1.049167] calling  e100_init_module+0x0/0x5d @ 1
[    1.049168] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.049169] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.049226] initcall e100_init_module+0x0/0x5d returned 0 after 56 usecs
[    1.049228] calling  tg3_init+0x0/0x1b @ 1
[    1.049286] initcall tg3_init+0x0/0x1b returned 0 after 54 usecs
[    1.049288] calling  bnx2_init+0x0/0x1b @ 1
[    1.049345] initcall bnx2_init+0x0/0x1b returned 0 after 53 usecs
[    1.049347] calling  net_olddevs_init+0x0/0x9e @ 1
[    1.049352] initcall net_olddevs_init+0x0/0x9e returned 0 after 3 usecs
[    1.049353] calling  b44_init+0x0/0x48 @ 1
[    1.049460] initcall b44_init+0x0/0x48 returned 0 after 102 usecs
[    1.049462] calling  init_nic+0x0/0x1b @ 1
[    1.049519] initcall init_nic+0x0/0x1b returned 0 after 54 usecs
[    1.049521] calling  cp_init+0x0/0x1b @ 1
[    1.049581] initcall cp_init+0x0/0x1b returned 0 after 56 usecs
[    1.049583] calling  rtl8139_init_module+0x0/0x1b @ 1
[    1.049640] initcall rtl8139_init_module+0x0/0x1b returned 0 after 53 usecs
[    1.049642] calling  tun_init+0x0/0x93 @ 1
[    1.049643] tun: Universal TUN/TAP device driver, 1.6
[    1.049644] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.049755] initcall tun_init+0x0/0x93 returned 0 after 107 usecs
[    1.049757] calling  tulip_init+0x0/0x33 @ 1
[    1.049822] initcall tulip_init+0x0/0x33 returned 0 after 61 usecs
[    1.049824] calling  init_netconsole+0x0/0x23a @ 1
[    1.058072] console [netcon0] enabled
[    1.058203] netconsole: network logging started
[    1.058334] initcall init_netconsole+0x0/0x23a returned 0 after 8329 usecs
[    1.058472] calling  cdrom_init+0x0/0x6a @ 1
[    1.058613] initcall cdrom_init+0x0/0x6a returned 0 after 11 usecs
[    1.058751] calling  nonstatic_sysfs_init+0x0/0x12 @ 1
[    1.058884] initcall nonstatic_sysfs_init+0x0/0x12 returned 0 after 0 usecs
[    1.059023] calling  usb_stor_init+0x0/0x46 @ 1
[    1.059152] Initializing USB Mass Storage driver...
[    1.059354] usbcore: registered new interface driver usb-storage
[    1.059488] USB Mass Storage support registered.
[    1.059619] initcall usb_stor_init+0x0/0x46 returned 0 after 455 usecs
[    1.059760] calling  i8042_init+0x0/0x388 @ 1
[    1.060021] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.065724] i8042.c: Detected active multiplexing controller, rev 1.1.
[    1.068045] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.068180] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.068311] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.068446] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.068579] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.068791] initcall i8042_init+0x0/0x388 returned 0 after 8712 usecs
[    1.068929] calling  mousedev_init+0x0/0x8d @ 1
[    1.069243] mice: PS/2 mouse device common for all mice
[    1.069376] initcall mousedev_init+0x0/0x8d returned 0 after 310 usecs
[    1.069513] calling  evdev_init+0x0/0x12 @ 1
[    1.069996] initcall evdev_init+0x0/0x12 returned 0 after 345 usecs
[    1.070133] calling  atkbd_init+0x0/0x27 @ 1
[    1.070331] initcall atkbd_init+0x0/0x27 returned 0 after 66 usecs
[    1.070472] calling  psmouse_init+0x0/0x79 @ 1
[    1.070689] initcall psmouse_init+0x0/0x79 returned 0 after 84 usecs
[    1.070837] calling  init_ladder+0x0/0x12 @ 1
[    1.071810] cpuidle: using governor ladder
[    1.071939] initcall init_ladder+0x0/0x12 returned 0 after 946 usecs
[    1.072078] calling  init_menu+0x0/0x12 @ 1
[    1.072204] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.073894] cpuidle: using governor menu
[    1.074023] initcall init_menu+0x0/0x12 returned 0 after 1783 usecs
[    1.074160] calling  dcdbas_init+0x0/0x67 @ 1
[    1.074428] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    1.074646] initcall dcdbas_init+0x0/0x67 returned 0 after 348 usecs
[    1.074783] calling  hid_init+0x0/0x4d @ 1
[    1.074985] initcall hid_init+0x0/0x4d returned 0 after 71 usecs
[    1.075116] calling  a4_init+0x0/0x1b @ 1
[    1.075305] initcall a4_init+0x0/0x1b returned 0 after 60 usecs
[    1.075438] calling  apple_init+0x0/0x39 @ 1
[    1.075640] initcall apple_init+0x0/0x39 returned 0 after 71 usecs
[    1.075956] calling  belkin_init+0x0/0x1b @ 1
[    1.076146] initcall belkin_init+0x0/0x1b returned 0 after 63 usecs
[    1.076278] calling  ch_init+0x0/0x1b @ 1
[    1.076465] initcall ch_init+0x0/0x1b returned 0 after 59 usecs
[    1.076598] calling  ch_init+0x0/0x1b @ 1
[    1.076790] initcall ch_init+0x0/0x1b returned 0 after 60 usecs
[    1.076923] calling  cp_init+0x0/0x1b @ 1
[    1.077111] initcall cp_init+0x0/0x1b returned 0 after 58 usecs
[    1.077243] calling  dr_init+0x0/0x1b @ 1
[    1.077429] initcall dr_init+0x0/0x1b returned 0 after 57 usecs
[    1.077559] calling  ez_init+0x0/0x1b @ 1
[    1.077825] initcall ez_init+0x0/0x1b returned 0 after 130 usecs
[    1.077955] calling  gyration_init+0x0/0x1b @ 1
[    1.078150] initcall gyration_init+0x0/0x1b returned 0 after 63 usecs
[    1.078282] calling  ks_init+0x0/0x1b @ 1
[    1.078469] initcall ks_init+0x0/0x1b returned 0 after 58 usecs
[    1.078600] calling  kye_init+0x0/0x1b @ 1
[    1.078792] initcall kye_init+0x0/0x1b returned 0 after 60 usecs
[    1.078924] calling  lg_init+0x0/0x1b @ 1
[    1.079114] initcall lg_init+0x0/0x1b returned 0 after 59 usecs
[    1.079248] calling  ms_init+0x0/0x1b @ 1
[    1.079439] initcall ms_init+0x0/0x1b returned 0 after 64 usecs
[    1.079572] calling  mr_init+0x0/0x1b @ 1
[    1.079766] initcall mr_init+0x0/0x1b returned 0 after 59 usecs
[    1.079896] calling  ntrig_init+0x0/0x1b @ 1
[    1.080091] initcall ntrig_init+0x0/0x1b returned 0 after 65 usecs
[    1.080225] calling  ortek_init+0x0/0x1b @ 1
[    1.080418] initcall ortek_init+0x0/0x1b returned 0 after 63 usecs
[    1.080551] calling  pl_init+0x0/0x1b @ 1
[    1.080742] initcall pl_init+0x0/0x1b returned 0 after 59 usecs
[    1.080878] calling  pl_init+0x0/0x1b @ 1
[    1.081067] initcall pl_init+0x0/0x1b returned 0 after 58 usecs
[    1.081202] calling  samsung_init+0x0/0x1b @ 1
[    1.081394] initcall samsung_init+0x0/0x1b returned 0 after 60 usecs
[    1.081529] calling  sjoy_init+0x0/0x1b @ 1
[    1.081725] initcall sjoy_init+0x0/0x1b returned 0 after 66 usecs
[    1.081857] calling  sony_init+0x0/0x1b @ 1
[    1.082048] initcall sony_init+0x0/0x1b returned 0 after 59 usecs
[    1.082182] calling  sp_init+0x0/0x1b @ 1
[    1.082369] initcall sp_init+0x0/0x1b returned 0 after 58 usecs
[    1.082505] calling  ga_init+0x0/0x1b @ 1
[    1.082699] initcall ga_init+0x0/0x1b returned 0 after 65 usecs
[    1.082831] calling  tm_init+0x0/0x1b @ 1
[    1.083021] initcall tm_init+0x0/0x1b returned 0 after 60 usecs
[    1.083155] calling  ts_init+0x0/0x1b @ 1
[    1.083344] initcall ts_init+0x0/0x1b returned 0 after 58 usecs
[    1.083478] calling  twinhan_init+0x0/0x1b @ 1
[    1.083668] initcall twinhan_init+0x0/0x1b returned 0 after 60 usecs
[    1.083803] calling  zp_init+0x0/0x1b @ 1
[    1.083994] initcall zp_init+0x0/0x1b returned 0 after 61 usecs
[    1.084126] calling  hid_init+0x0/0xb0 @ 1
[    1.084421] usbcore: registered new interface driver usbhid
[    1.084552] usbhid: USB HID core driver
[    1.084681] initcall hid_init+0x0/0xb0 returned 0 after 419 usecs
[    1.084816] calling  staging_init+0x0/0x8 @ 1
[    1.084946] initcall staging_init+0x0/0x8 returned 0 after 0 usecs
[    1.085082] calling  alsa_sound_last_init+0x0/0x6f @ 1
[    1.085211] ALSA device list:
[    1.085335]   No soundcards found.
[    1.085462] initcall alsa_sound_last_init+0x0/0x6f returned 0 after 244 usecs
[    1.085595] calling  oprofile_init+0x0/0x42 @ 1
[    1.085843] oprofile: using NMI interrupt.
[    1.085980] initcall oprofile_init+0x0/0x42 returned 0 after 246 usecs
[    1.086113] calling  sysctl_ipv4_init+0x0/0x8b @ 1
[    1.086394] initcall sysctl_ipv4_init+0x0/0x8b returned 0 after 149 usecs
[    1.086527] calling  inet_diag_init+0x0/0xca @ 1
[    1.086675] initcall inet_diag_init+0x0/0xca returned 0 after 13 usecs
[    1.086810] calling  tcp_diag_init+0x0/0x12 @ 1
[    1.086939] initcall tcp_diag_init+0x0/0x12 returned 0 after 0 usecs
[    1.087072] calling  cubictcp_register+0x0/0x5c @ 1
[    1.087201] TCP cubic registered
[    1.087326] initcall cubictcp_register+0x0/0x5c returned 0 after 121 usecs
[    1.087459] calling  packet_init+0x0/0x47 @ 1
[    1.087585] NET: Registered protocol family 17
[    1.087724] initcall packet_init+0x0/0x47 returned 0 after 136 usecs
[    1.087858] calling  mcheck_debugfs_init+0x0/0x3c @ 1
[    1.087995] initcall mcheck_debugfs_init+0x0/0x3c returned 0 after 8 usecs
[    1.088128] calling  severities_debugfs_init+0x0/0x3c @ 1
[    1.088261] initcall severities_debugfs_init+0x0/0x3c returned 0 after 2 usecs
[    1.088479] calling  hpet_insert_resource+0x0/0x23 @ 1
[    1.088612] initcall hpet_insert_resource+0x0/0x23 returned 0 after 1 usecs
[    1.088748] calling  update_mp_table+0x0/0x5fa @ 1
[    1.088877] initcall update_mp_table+0x0/0x5fa returned 0 after 0 usecs
[    1.089013] calling  lapic_insert_resource+0x0/0x3f @ 1
[    1.089144] initcall lapic_insert_resource+0x0/0x3f returned 0 after 0 usecs
[    1.089283] calling  init_lapic_nmi_sysfs+0x0/0x39 @ 1
[    1.089413] initcall init_lapic_nmi_sysfs+0x0/0x39 returned 0 after 0 usecs
[    1.089549] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[    1.089680] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
[    1.089815] calling  check_early_ioremap_leak+0x0/0x65 @ 1
[    1.089946] initcall check_early_ioremap_leak+0x0/0x65 returned 0 after 0 usecs
[    1.090163] calling  pat_memtype_list_init+0x0/0x32 @ 1
[    1.090296] initcall pat_memtype_list_init+0x0/0x32 returned 0 after 3 usecs
[    1.092916] calling  sched_init_debug+0x0/0x24 @ 1
[    1.093051] initcall sched_init_debug+0x0/0x24 returned 0 after 2 usecs
[    1.093189] calling  init_oops_id+0x0/0x31 @ 1
[    1.093323] initcall init_oops_id+0x0/0x31 returned 0 after 4 usecs
[    1.093462] calling  printk_late_init+0x0/0x50 @ 1
[    1.093595] initcall printk_late_init+0x0/0x50 returned 0 after 1 usecs
[    1.093741] calling  pm_qos_power_init+0x0/0xca @ 1
[    1.094188] initcall pm_qos_power_init+0x0/0xca returned 0 after 311 usecs
[    1.094325] calling  debugfs_kprobe_init+0x0/0x8a @ 1
[    1.094464] initcall debugfs_kprobe_init+0x0/0x8a returned 0 after 10 usecs
[    1.094597] calling  clear_boot_tracer+0x0/0x2d @ 1
[    1.094731] initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
[    1.094868] calling  max_swapfiles_check+0x0/0x8 @ 1
[    1.094996] initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
[    1.095133] calling  random32_reseed+0x0/0xb3 @ 1
[    1.095282] initcall random32_reseed+0x0/0xb3 returned 0 after 18 usecs
[    1.095416] calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
[    1.095551] initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 2 usecs
[    1.095769] calling  pci_sysfs_init+0x0/0x51 @ 1
[    1.096148] initcall pci_sysfs_init+0x0/0x51 returned 0 after 243 usecs
[    1.096283] calling  seqgen_init+0x0/0xf @ 1
[    1.096424] initcall seqgen_init+0x0/0xf returned 0 after 11 usecs
[    1.096560] calling  scsi_complete_async_scans+0x0/0x170 @ 1
[    1.096695] initcall scsi_complete_async_scans+0x0/0x170 returned 0 after 0 usecs
[    1.096914] calling  rtc_hctosys+0x0/0x10d @ 1
[    1.097043] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    1.097177] initcall rtc_hctosys+0x0/0x10d returned -19 after 131 usecs
[    1.097313] calling  memmap_init+0x0/0x3b @ 1
[    1.097516] initcall memmap_init+0x0/0x3b returned 0 after 73 usecs
[    1.097652] calling  pci_mmcfg_late_insert_resources+0x0/0x66 @ 1
[    1.097784] initcall pci_mmcfg_late_insert_resources+0x0/0x66 returned 0 after 0 usecs
[    1.098005] calling  tcp_congestion_default+0x0/0x12 @ 1
[    1.098140] initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 usecs
[    1.098278] calling  ip_auto_config+0x0/0xda2 @ 1
[    1.098412] initcall ip_auto_config+0x0/0xda2 returned 0 after 4 usecs
[    1.098544] calling  initialize_hashrnd+0x0/0x19 @ 1
[    1.098678] initcall initialize_hashrnd+0x0/0x19 returned 0 after 2 usecs
[    1.114393] async_waiting @ 1
[    1.324306] ata5: SATA link down (SStatus 0 SControl 300)
[    1.324456] async_waiting @ 1188
[    1.324466] ata6: SATA link down (SStatus 0 SControl 300)
[    1.324490] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.324501] async_waiting @ 1189
[    1.326900] ata2.00: ATAPI: Slimtype DVD A  DS8A4S, JA22, max UDMA/100
[    1.328314] ata2.00: configured for UDMA/100
[    1.329744] async_waiting @ 18
[    1.334281] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.334748] ata1.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102HD, max UDMA/133
[    1.334892] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.335434] ata1.00: configured for UDMA/133
[    1.335575] async_waiting @ 5
[    1.335714] async_continuing @ 5 after 0 usec
[    1.336044] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
[    1.336879] calling  8_sd_probe_async+0x0/0x1c0 @ 1190
[    1.337095] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.337163] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.337173] initcall 2_async_port_probe+0x0/0xad returned 0 after 273227 usecs
[    1.337183] async_continuing @ 18 after 7154 usec
[    1.337995] sd 0:0:0:0: [sda] Write Protect is off
[    1.338132] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.338310] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.339867]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    1.341287] scsi 1:0:0:0: CD-ROM            Slimtype DVD A  DS8A4S    JA22 PQ: 0 ANSI: 5
[    1.341290] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.341294] initcall 8_sd_probe_async+0x0/0x1c0 returned 0 after 4184 usecs
[    1.352250] sr0: scsi3-mmc drive: 24x/8x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.352475] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.352818] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.353156] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.353300] initcall 3_async_port_probe+0x0/0xad returned 0 after 298577 usecs
[    1.353529] async_continuing @ 559 after 298760 usec
[    1.353667] initcall 4_async_port_probe+0x0/0xad returned 0 after 298900 usecs
[    1.353917] async_continuing @ 1187 after 299117 usec
[    1.354055] initcall 5_async_port_probe+0x0/0xad returned 0 after 299256 usecs
[    1.354285] async_continuing @ 1188 after 28696 usec
[    1.354420] initcall 6_async_port_probe+0x0/0xad returned 0 after 299590 usecs
[    1.354646] async_continuing @ 1189 after 29508 usec
[    1.354782] initcall 7_async_port_probe+0x0/0xad returned 0 after 299915 usecs
[    1.355010] async_continuing @ 1 after 235424 usec
[    1.436095] EXT3-fs (sda5): error: couldn't mount because of unsupported optional features (240)
[    1.436630] EXT2-fs (sda5): error: couldn't mount because of unsupported optional features (240)
[    1.442481] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[    1.442786] VFS: Mounted root (ext4 filesystem) readonly on device 8:5.
[    1.444076] devtmpfs: mounted
[    1.444222] async_waiting @ 1
[    1.444346] async_continuing @ 1 after 0 usec
[    1.444475] LENB: free_initmem() NOT!
[    1.781994] readahead: starting
[    2.035218] udev: starting version 153
[    2.035283] udevd (1415): /proc/1415/oom_adj is deprecated, please use /proc/1415/oom_score_adj instead.
[    2.088282] power_supply BAT0: uevent
[    2.088286] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    2.097906] calling  cmpc_init+0x0/0x83 [classmate_laptop] @ 1428
[    2.099065] initcall cmpc_init+0x0/0x83 [classmate_laptop] returned 0 after 1128 usecs
[    2.099248] calling  acpi_ac_init+0x0/0x45 [ac] @ 1434
[    2.099313] calling  acpi_video_init+0x0/0x77 [video] @ 1433
[    2.099328] initcall acpi_video_init+0x0/0x77 [video] returned 0 after 6 usecs
[    2.121416] power_supply AC0: uevent
[    2.121419] power_supply AC0: POWER_SUPPLY_NAME=AC0
[    2.121422] power_supply AC0: prop ONLINE=0
[    2.121433] power_supply AC0: power_supply_changed
[    2.121436] ACPI: AC Adapter [AC0] (off-line)
[    2.121440] power_supply AC0: power_supply_changed_work
[    2.121443] power_supply AC0: power_supply_update_gen_leds 0
[    2.121453] power_supply AC0: uevent
[    2.121454] power_supply AC0: POWER_SUPPLY_NAME=AC0
[    2.121457] power_supply AC0: prop ONLINE=0
[    2.121488] initcall acpi_ac_init+0x0/0x45 [ac] returned 0 after 21768 usecs
[    2.192692] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio2/input/input5
[    2.242262] power_supply BAT0: prop STATUS=Discharging
[    2.242266] power_supply BAT0: prop PRESENT=1
[    2.242269] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    2.242272] power_supply BAT0: prop CYCLE_COUNT=0
[    2.242274] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[    2.242277] power_supply BAT0: prop VOLTAGE_NOW=10763000
[    2.242279] power_supply BAT0: prop CURRENT_NOW=2589000
[    2.242282] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[    2.242285] power_supply BAT0: prop CHARGE_FULL=4508000
[    2.242287] power_supply BAT0: prop CHARGE_NOW=2441000
[    2.242290] power_supply BAT0: prop MODEL_NAME=SP624
[    2.242292] power_supply BAT0: prop MANUFACTURER=PEGATRON
[    2.242295] power_supply BAT0: prop SERIAL_NUMBER= 
[    2.257143] calling  cmos_init+0x0/0x6a [rtc_cmos] @ 1457
[    2.257181] rtc_cmos 00:03: RTC can wake from S4
[    2.257272] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.257310] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    2.257343] initcall cmos_init+0x0/0x6a [rtc_cmos] returned 0 after 190 usecs
[    2.266586] calling  acpi_wmi_init+0x0/0x72 [wmi] @ 1470
[    2.267333] wmi: Mapper loaded
[    2.267339] initcall acpi_wmi_init+0x0/0x72 [wmi] returned 0 after 731 usecs
[    2.277286] calling  ehci_hcd_init+0x0/0xb5 [ehci_hcd] @ 1484
[    2.277289] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.277329] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.277358] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.277362] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    2.277371] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.277434] ehci_hcd 0000:00:1a.0: debug port 2
[    2.281413] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    2.287695] calling  snd_mem_init+0x0/0x2c [snd_page_alloc] @ 1475
[    2.287710] initcall snd_mem_init+0x0/0x2c [snd_page_alloc] returned 0 after 8 usecs
[    2.293389] calling  alsa_timer_init+0x0/0x1bf [snd_timer] @ 1475
[    2.293593] initcall alsa_timer_init+0x0/0x1bf [snd_timer] returned 0 after 193 usecs
[    2.297562] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xfb608000
[    2.309550] calling  atl1e_init_module+0x0/0x20 [atl1e] @ 1488
[    2.309595] ATL1E 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.309608] ATL1E 0000:06:00.0: setting latency timer to 64
[    2.326286] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.326344] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.326347] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.326350] usb usb1: Product: EHCI Host Controller
[    2.326352] usb usb1: Manufacturer: Linux 2.6.37-rc5-dirty ehci_hcd
[    2.326355] usb usb1: SerialNumber: 0000:00:1a.0
[    2.337670] calling  drm_core_init+0x0/0x137 [drm] @ 1474
[    2.337735] [drm] Initialized drm 1.1.0 20060810
[    2.337746] initcall drm_core_init+0x0/0x137 [drm] returned 0 after 62 usecs
[    2.349158] initcall atl1e_init_module+0x0/0x20 [atl1e] returned 0 after 38765 usecs
[    2.350410] hub 1-0:1.0: USB hub found
[    2.350427] hub 1-0:1.0: 2 ports detected
[    2.350536] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.350566] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.350570] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    2.350580] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.350643] ehci_hcd 0000:00:1d.0: debug port 2
[    2.354535] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    2.362778] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xfb607000
[    2.380419] calling  alsa_pcm_init+0x0/0x71 [snd_pcm] @ 1571
[    2.380437] initcall alsa_pcm_init+0x0/0x71 [snd_pcm] returned 0 after 10 usecs
[    2.380824] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.380879] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.380882] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.380885] usb usb2: Product: EHCI Host Controller
[    2.380888] usb usb2: Manufacturer: Linux 2.6.37-rc5-dirty ehci_hcd
[    2.380890] usb usb2: SerialNumber: 0000:00:1d.0
[    2.381217] hub 2-0:1.0: USB hub found
[    2.381230] hub 2-0:1.0: 2 ports detected
[    2.381359] initcall ehci_hcd_init+0x0/0xb5 [ehci_hcd] returned 0 after 101875 usecs
[    2.408871] calling  i915_init+0x0/0x96 [i915] @ 1474
[    2.408947] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.408951] i915 0000:00:02.0: setting latency timer to 64
[    2.420912] microcode: CPU0 updated to revision 0xc, date = 2010-06-10
[    2.421444] microcode: CPU1 updated to revision 0xc, date = 2010-06-10
[    2.421982] microcode: CPU2 updated to revision 0xc, date = 2010-06-10
[    2.422512] microcode: CPU3 updated to revision 0xc, date = 2010-06-10
[    2.448006] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[    2.506695] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.575578] fb0: inteldrmfb frame buffer device
[    2.575580] drm: registered panic notifier
[    2.586160] LENB acpi_os_map_memory(0x0000000077629e5e, 0x000000000000012c)
[    2.586166] LENB E820_RAM 0
[    2.586168] LENB E820_ACPI 0
[    2.586170] LENB E820_NVS 1
[    2.586211] LENB 0xffffc90000038000 = __acpi_map_table_permanent(0x0000000077629000, 0x1000)
[    2.586278] LENB acpi_os_map_memory(0x0000000077611138, 0x0000000000000ec8)
[    2.586285] LENB E820_RAM 0
[    2.586286] LENB E820_ACPI 0
[    2.586287] LENB E820_NVS 1
[    2.586295] LENB 0xffffc90000024000 = __acpi_map_table_permanent(0x0000000077611000, 0x1000)
[    2.587567] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[    2.603465] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[    2.620315] acpi device:4f: registered as cooling_device4
[    2.620827] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
[    2.620910] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.620934] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.620982] initcall i915_init+0x0/0x96 [i915] returned 0 after 207632 usecs
[    2.624187] calling  alsa_seq_device_init+0x0/0x60 [snd_seq_device] @ 1605
[    2.624201] initcall alsa_seq_device_init+0x0/0x60 [snd_seq_device] returned 0 after 8 usecs
[    2.627939] calling  alsa_seq_init+0x0/0x4c [snd_seq] @ 1605
[    2.628710] initcall alsa_seq_init+0x0/0x4c [snd_seq] returned 0 after 748 usecs
[    2.650857] calling  alsa_card_azx_init+0x0/0x20 [snd_hda_intel] @ 1475
[    2.650946] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.650976] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    2.651038] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    2.651080] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    2.677226] calling  patch_realtek_init+0x0/0x12 [snd_hda_codec_realtek] @ 1649
[    2.677235] initcall patch_realtek_init+0x0/0x12 [snd_hda_codec_realtek] returned 0 after 0 usecs
[    2.677798] hda_codec: ALC269VB: BIOS auto-probing.
[    2.680824] initcall alsa_card_azx_init+0x0/0x20 [snd_hda_intel] returned 0 after 29328 usecs
[    2.766107] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    2.766113] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.766496] hub 1-1:1.0: USB hub found
[    2.766564] hub 1-1:1.0: 6 ports detected
[    2.784107] calling  wait_scan_init+0x0/0x12 [scsi_wait_scan] @ 1714
[    2.784112] initcall wait_scan_init+0x0/0x12 [scsi_wait_scan] returned 0 after 1 usecs
[    2.868146] EXT4-fs (sda5): re-mounted. Opts: (null)
[    2.868439] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    2.905848] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    2.969867] Adding 4194300k swap on /dev/sda6.  Priority:-1 extents:1 across:4194300k SS
[    2.982553] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    2.982556] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.982969] hub 2-1:1.0: USB hub found
[    2.983024] hub 2-1:1.0: 8 ports detected
[    3.057123] usb 1-1.6: new high speed USB device using ehci_hcd and address 3
[    3.149875] calling  acpi_cpufreq_init+0x0/0x10d [acpi_cpufreq] @ 1885
[    3.151330] initcall acpi_cpufreq_init+0x0/0x10d [acpi_cpufreq] returned 0 after 1419 usecs
[    3.174089] usb 1-1.6: New USB device found, idVendor=064e, idProduct=a118
[    3.174095] usb 1-1.6: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    3.174099] usb 1-1.6: Product: USB 2.0 UVC 1.3M WebCam
[    3.174103] usb 1-1.6: Manufacturer: SuYin
[    3.174106] usb 1-1.6: SerialNumber: CN1315-S30B-OV03-VS-R01.01.01
[    3.258607] usb 2-1.6: new full speed USB device using ehci_hcd and address 3
[    3.289359] ATL1E 0000:06:00.0: irq 47 for MSI/MSI-X
[    3.346988] usb 2-1.6: New USB device found, idVendor=13d3, idProduct=3250
[    3.346991] usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.346993] usb 2-1.6: Product: Bluetooth2.1module
[    3.346995] usb 2-1.6: Manufacturer: Broadcom Corp
[    3.346997] usb 2-1.6: SerialNumber: 0025D3B17A59
[    3.614518] power_supply AC0: uevent
[    3.614520] power_supply AC0: POWER_SUPPLY_NAME=AC0
[    3.614524] power_supply AC0: prop ONLINE=0
[    3.615512] power_supply BAT0: uevent
[    3.615514] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    3.648939] power_supply BAT0: prop STATUS=Discharging
[    3.648947] power_supply BAT0: prop PRESENT=1
[    3.648954] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    3.648959] power_supply BAT0: prop CYCLE_COUNT=0
[    3.648965] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[    3.648970] power_supply BAT0: prop VOLTAGE_NOW=10565000
[    3.648976] power_supply BAT0: prop CURRENT_NOW=2529000
[    3.648981] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[    3.648986] power_supply BAT0: prop CHARGE_FULL=4508000
[    3.648991] power_supply BAT0: prop CHARGE_NOW=2439000
[    3.648996] power_supply BAT0: prop MODEL_NAME=SP624
[    3.649001] power_supply BAT0: prop MANUFACTURER=PEGATRON
[    3.649007] power_supply BAT0: prop SERIAL_NUMBER= 
[    4.314377] calling  fb_console_init+0x0/0x11d [fbcon] @ 2306
[    4.315230] Console: switching to colour frame buffer device 170x48
[    4.315245] initcall fb_console_init+0x0/0x11d [fbcon] returned 0 after 841 usecs
[    4.405643] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[    4.466883] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[    4.485998] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[    4.611902] power_supply AC0: uevent
[    4.611907] power_supply AC0: POWER_SUPPLY_NAME=AC0
[    4.611915] power_supply AC0: prop ONLINE=0
[    4.622154] power_supply BAT0: uevent
[    4.622158] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    4.622166] power_supply BAT0: prop STATUS=Discharging
[    4.622171] power_supply BAT0: prop PRESENT=1
[    4.622176] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    4.622180] power_supply BAT0: prop CYCLE_COUNT=0
[    4.622184] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[    4.622189] power_supply BAT0: prop VOLTAGE_NOW=10565000
[    4.622193] power_supply BAT0: prop CURRENT_NOW=2529000
[    4.622198] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[    4.622202] power_supply BAT0: prop CHARGE_FULL=4508000
[    4.622206] power_supply BAT0: prop CHARGE_NOW=2439000
[    4.622211] power_supply BAT0: prop MODEL_NAME=SP624
[    4.622215] power_supply BAT0: prop MANUFACTURER=PEGATRON
[    4.622219] power_supply BAT0: prop SERIAL_NUMBER= 
[    4.637201] ATL1E 0000:06:00.0: eth0: NIC Link is Up <1000 Mbps Full Duplex>
[    4.878845] power_supply BAT0: uevent
[    4.878847] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    4.911820] power_supply BAT0: prop STATUS=Discharging
[    4.911827] power_supply BAT0: prop PRESENT=1
[    4.911832] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    4.911836] power_supply BAT0: prop CYCLE_COUNT=0
[    4.911841] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[    4.911846] power_supply BAT0: prop VOLTAGE_NOW=10624000
[    4.911850] power_supply BAT0: prop CURRENT_NOW=2178000
[    4.911855] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[    4.911859] power_supply BAT0: prop CHARGE_FULL=4508000
[    4.911863] power_supply BAT0: prop CHARGE_NOW=2438000
[    4.911867] power_supply BAT0: prop MODEL_NAME=SP624
[    4.911871] power_supply BAT0: prop MANUFACTURER=PEGATRON
[    4.911876] power_supply BAT0: prop SERIAL_NUMBER= 
[    4.912050] power_supply AC0: uevent
[    4.912053] power_supply AC0: POWER_SUPPLY_NAME=AC0
[    4.912058] power_supply AC0: prop ONLINE=0
[    5.022550] power_supply BAT0: uevent
[    5.022556] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    5.022563] power_supply BAT0: prop STATUS=Discharging
[    5.022568] power_supply BAT0: prop PRESENT=1
[    5.022573] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    5.022579] power_supply BAT0: prop CYCLE_COUNT=0
[    5.022584] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[    5.022589] power_supply BAT0: prop VOLTAGE_NOW=10624000
[    5.022595] power_supply BAT0: prop CURRENT_NOW=2178000
[    5.022600] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[    5.022605] power_supply BAT0: prop CHARGE_FULL=4508000
[    5.022610] power_supply BAT0: prop CHARGE_NOW=2438000
[    5.022615] power_supply BAT0: prop MODEL_NAME=SP624
[    5.022620] power_supply BAT0: prop MANUFACTURER=PEGATRON
[    5.022625] power_supply BAT0: prop SERIAL_NUMBER= 
[    5.431729] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[    5.449946] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[    5.468812] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[    5.489803] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[    5.521354] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[    5.545621] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[   14.722635] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[   14.739817] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[   14.761107] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[   14.786438] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[   14.810144] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[   14.833020] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.

