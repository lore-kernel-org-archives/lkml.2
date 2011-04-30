Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab1D3Qjl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 12:39:41 -0400
Received: from www17.your-server.de ([213.133.104.17]:48666 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab1D3Qji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 12:39:38 -0400
Subject: WARNING: at arch/x86/mm/ioremap.c and mm/page_alloc.c
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Apr 2011 10:39:31 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1304152775.1837.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while trying to get an x86_64 kernel to run on an Fedora 15 32-bit
userland I get these warning in the dmesg. compiling this kernel for x86
with a similar config file doesn't show these warning.

any ideas?

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38.4 (thomas@localhost.localdomain) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #11 Sat Apr 30 12:32:25 CEST 2011
[    0.000000] Command line: ro root=UUID=54c1f2-f119-4f97-b8e2-d827b8655edb LANG=de_DE.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=de-latin1-nodeadkeys kgdboc=kms,kbd 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e000 (usable)
[    0.000000]  BIOS-e820: 000000000009e000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ba63000 (usable)
[    0.000000]  BIOS-e820: 000000007ba63000 - 000000007babf000 (reserved)
[    0.000000]  BIOS-e820: 000000007babf000 - 000000007bb80000 (usable)
[    0.000000]  BIOS-e820: 000000007bb80000 - 000000007bbbf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007bbbf000 - 000000007bbe0000 (usable)
[    0.000000]  BIOS-e820: 000000007bbe0000 - 000000007bbf7000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007bbf7000 - 000000007bc00000 (usable)
[    0.000000]  BIOS-e820: 000000007bc00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Acer Aspire 1810T/JM11-MS, BIOS v1.3310 03/25/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x7bc00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   2 base 040000000 mask FC0000000 write-back
[    0.000000]   3 base 07C000000 mask FFC000000 uncachable
[    0.000000]   4 base 07BC00000 mask FFFC00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007bc00000
[    0.000000]  0000000000 - 007bc00000 page 2M
[    0.000000] kernel direct mapping tables up to 7bc00000 @ 1fffd000-20000000
[    0.000000] RAMDISK: 377a8000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 ACRSYS)
[    0.000000] ACPI: XSDT 000000007bbf6120 0007C (v01 ACRSYS ACRPRDCT 00000001      01000013)
[    0.000000] ACPI: FACP 000000007bbf4000 000F4 (v04 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: DSDT 000000007bbe8000 073EA (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: FACS 000000007bb8d000 00040
[    0.000000] ACPI: DMAR 000000007bbf5000 00068 (v01               ? 00000001      00000000)
[    0.000000] ACPI: HPET 000000007bbf3000 00038 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: APIC 000000007bbf2000 0006C (v02 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: MCFG 000000007bbf1000 0003C (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: ASF! 000000007bbf0000 000A5 (v32 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: SLIC 000000007bbe7000 00176 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: BOOT 000000007bbe6000 00028 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: SSDT 000000007bbe2000 00223 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 000000007bbe1000 00537 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.000000] ACPI: SSDT 000000007bbe0000 00655 (v01  PmRef    CpuPm 00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880079200000-ffff88007adfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0007ba63
[    0.000000]     0: 0x0007babf -> 0x0007bb80
[    0.000000]     0: 0x0007bbbf -> 0x0007bbe0
[    0.000000]     0: 0x0007bbf7 -> 0x0007bc00
[    0.000000] On node 0 totalpages: 506588
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6874 pages used for memmap
[    0.000000]   DMA32 zone: 495732 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007ba63000 - 000000007babf000
[    0.000000] PM: Registered nosave memory: 000000007bb80000 - 000000007bbbf000
[    0.000000] PM: Registered nosave memory: 000000007bbe0000 - 000000007bbf7000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:78000000)
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 499652
[    0.000000] Kernel command line: ro root=UUID=54c1f2-f119-4f97-b8e2-d827b8655edb LANG=de_DE.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=de-latin1-nodeadkeys kgdboc=kms,kbd 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at drivers/pci/dmar.c:634 warn_invalid_dmar+0x8a/0xa0()
[    0.000000] Hardware name: Aspire 1810T
[    0.000000] Your BIOS is broken; DMAR reported at address 0!
[    0.000000] BIOS vendor: INSYDE; Ver: v1.3310; Product Version: v1.3310
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.38.4 #11
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8103175a>] ? warn_slowpath_common+0x7a/0xb0
[    0.000000]  [<ffffffff8146fa8b>] ? _etext+0x0/0x1ff575
[    0.000000]  [<ffffffff810317ea>] ? warn_slowpath_fmt_taint+0x3a/0x40
[    0.000000]  [<ffffffff8167db6c>] ? early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816783bd>] ? __acpi_map_table+0x13/0x19
[    0.000000]  [<ffffffff811fbe1a>] ? warn_invalid_dmar+0x8a/0xa0
[    0.000000]  [<ffffffff8123a785>] ? acpi_tb_verify_checksum+0x11/0x49
[    0.000000]  [<ffffffff8168d684>] ? check_zero_address+0x5d/0x116
[    0.000000]  [<ffffffff81239f14>] ? acpi_get_table_with_size+0x53/0xb4
[    0.000000]  [<ffffffff8167d1cd>] ? pci_swiotlb_init+0x0/0x21
[    0.000000]  [<ffffffff8146fa8b>] ? _etext+0x0/0x1ff575
[    0.000000]  [<ffffffff8168d754>] ? detect_intel_iommu+0x17/0x84
[    0.000000]  [<ffffffff81674511>] ? pci_iommu_alloc+0x8d/0xb8
[    0.000000]  [<ffffffff8167d649>] ? mem_init+0x19/0xe3
[    0.000000]  [<ffffffff8166f9d4>] ? start_kernel+0x1c1/0x392
[    0.000000]  [<ffffffff8166f322>] ? x86_64_start_reservations+0x132/0x136
[    0.000000]  [<ffffffff8166f41c>] ? x86_64_start_kernel+0xf6/0xfd
[    0.000000] ---[ end trace a7919e7f17c0a725 ]---
[    0.000000] Disabling lock debugging due to kernel taint
[    0.000000] Memory: 1978368k/2027520k available (4542k kernel code, 1168k absent, 47984k reserved, 2041k data, 388k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:288
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1396.557 MHz processor.
[    0.003337] Calibrating delay loop (skipped), value calculated using timer frequency.. 2794.49 BogoMIPS (lpj=4655190)
[    0.003517] pid_max: default: 32768 minimum: 301
[    0.003640] Security Framework initialized
[    0.003730] SELinux:  Initializing.
[    0.003821] SELinux:  Starting in permissive mode
[    0.003839] Mount-cache hash table entries: 256
[    0.004074] Initializing cgroup subsys cpuacct
[    0.004164] Initializing cgroup subsys devices
[    0.004252] Initializing cgroup subsys freezer
[    0.004339] Initializing cgroup subsys net_cls
[    0.004425] Initializing cgroup subsys blkio
[    0.006710] mce: CPU supports 6 MCE banks
[    0.006804] CPU0: Thermal monitoring enabled (TM2)
[    0.006891] using mwait in idle threads.
[    0.006976] CPU: Intel(R) Core(TM)2 Solo CPU    U3500  @ 1.40GHz stepping 0a
[    0.007201] ACPI: Core revision 20110112
[    0.016730] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.016948] ... version:                2
[    0.017034] ... bit width:              40
[    0.017121] ... generic registers:      2
[    0.017206] ... value mask:             000000ffffffffff
[    0.017294] ... max period:             000000007fffffff
[    0.017383] ... fixed-purpose events:   3
[    0.017469] ... event mask:             0000000700000003
[    0.017660] DMAR: Host address width 36
[    0.017747] DMAR: DRHD base: 0x00000000000000 flags: 0x1
[    0.017837] DMAR: parse DMAR table failure.
[    0.017925] Setting APIC routing to flat
[    0.018363] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.053330] APIC calibration not consistent with PM-Timer: 449ms instead of 100ms
[    0.053330] APIC delta adjusted to PM-Timer: 1246872 (5610906)
[    0.053330] print_constraints: dummy: 
[    0.053330] NET: Registered protocol family 16
[    0.053330] ACPI: bus type pci registered
[    0.053330] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.053330] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.066950] PCI: Using configuration type 1 for base access
[    0.068104] bio: create slab <bio-0> at 0
[    0.070211] ACPI: EC: Look up EC in DSDT
[    0.072117] ACPI: Executed 1 blocks of module-level executable AML code
[    0.074966] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.075944] ------------[ cut here ]------------
[    0.076039] WARNING: at arch/x86/mm/ioremap.c:109 __ioremap_caller+0x360/0x370()
[    0.076169] Hardware name: Aspire 1810T
[    0.076255] Modules linked in:
[    0.076380] Pid: 1, comm: swapper Tainted: G          I 2.6.38.4 #11
[    0.076470] Call Trace:
[    0.076558]  [<ffffffff8103175a>] ? warn_slowpath_common+0x7a/0xb0
[    0.076653]  [<ffffffff8145edd1>] ? acpi_os_map_memory+0x70/0x12d
[    0.076666]  [<ffffffff810317a5>] ? warn_slowpath_null+0x15/0x20
[    0.076757]  [<ffffffff81021340>] ? __ioremap_caller+0x360/0x370
[    0.076849]  [<ffffffff810c5d4f>] ? kmem_cache_alloc+0x8f/0xb0
[    0.076939]  [<ffffffff8102137f>] ? ioremap_cache+0xf/0x20
[    0.077029]  [<ffffffff8145edd1>] ? acpi_os_map_memory+0x70/0x12d
[    0.077122]  [<ffffffff8122fc42>] ? acpi_ex_system_memory_space_handler+0xe2/0x1e3
[    0.077255]  [<ffffffff8122fb60>] ? acpi_ex_system_memory_space_handler+0x0/0x1e3
[    0.077388]  [<ffffffff81228327>] ? acpi_ev_address_space_dispatch+0x174/0x1c3
[    0.077519]  [<ffffffff81229138>] ? acpi_ev_system_memory_region_setup+0x0/0x6e
[    0.077650]  [<ffffffff8122b5ee>] ? acpi_ex_region_read+0x36/0x5d
[    0.077741]  [<ffffffff8122b824>] ? acpi_ex_load_op+0x9f/0x256
[    0.077832]  [<ffffffff8122d8a3>] ? acpi_ex_opcode_1A_1T_0R+0x25/0x4b
[    0.077924]  [<ffffffff81225625>] ? acpi_ds_exec_end_op+0xf5/0x3e4
[    0.078803]  [<ffffffff81237ce0>] ? acpi_ps_parse_loop+0x7b8/0x950
[    0.078895]  [<ffffffff81225eca>] ? acpi_ds_call_control_method+0x106/0x198
[    0.078988]  [<ffffffff812370df>] ? acpi_ps_parse_aml+0x93/0x274
[    0.079078]  [<ffffffff81238526>] ? acpi_ps_execute_method+0x1c9/0x273
[    0.079171]  [<ffffffff81233a06>] ? acpi_ns_evaluate+0xda/0x1a5
[    0.079261]  [<ffffffff8123348a>] ? acpi_evaluate_object+0xfa/0x1f3
[    0.079355]  [<ffffffff8121ead1>] ? acpi_processor_set_pdc+0x174/0x19a
[    0.079447]  [<ffffffff8121eb79>] ? early_init_pdc+0x82/0x85
[    0.079538]  [<ffffffff81235214>] ? acpi_ns_walk_namespace+0xbb/0x17b
[    0.079630]  [<ffffffff8121eaf7>] ? early_init_pdc+0x0/0x85
[    0.079721]  [<ffffffff8121eaf7>] ? early_init_pdc+0x0/0x85
[    0.079811]  [<ffffffff8123332e>] ? acpi_walk_namespace+0x8e/0xc8
[    0.079903]  [<ffffffff8168ffd8>] ? acpi_init+0x0/0xd8
[    0.079998]  [<ffffffff816902d6>] ? acpi_early_processor_set_pdc+0x3a/0x53
[    0.080091]  [<ffffffff8168feb1>] ? acpi_bus_init+0xb6/0x1dd
[    0.080183]  [<ffffffff811cca7e>] ? kobject_create_and_add+0x3e/0x80
[    0.080275]  [<ffffffff81690049>] ? acpi_init+0x71/0xd8
[    0.080364]  [<ffffffff810002ae>] ? do_one_initcall+0x3e/0x170
[    0.080457]  [<ffffffff8166fc5d>] ? kernel_init+0xb8/0x139
[    0.080547]  [<ffffffff8102cb96>] ? schedule_tail+0x16/0x50
[    0.080638]  [<ffffffff81003834>] ? kernel_thread_helper+0x4/0x10
[    0.080730]  [<ffffffff8166fba5>] ? kernel_init+0x0/0x139
[    0.080819]  [<ffffffff81003830>] ? kernel_thread_helper+0x0/0x10
[    0.080910] ---[ end trace a7919e7f17c0a726 ]---
[    0.081015] ------------[ cut here ]------------
[    0.081107] WARNING: at mm/page_alloc.c:2012 __alloc_pages_nodemask+0x620/0x7e0()
[    0.081236] Hardware name: Aspire 1810T
[    0.081321] Modules linked in:
[    0.081445] Pid: 1, comm: swapper Tainted: G        W I 2.6.38.4 #11
[    0.081535] Call Trace:
[    0.081620]  [<ffffffff8103175a>] ? warn_slowpath_common+0x7a/0xb0
[    0.081712]  [<ffffffff810317a5>] ? warn_slowpath_null+0x15/0x20
[    0.081803]  [<ffffffff81097d50>] ? __alloc_pages_nodemask+0x620/0x7e0
[    0.081896]  [<ffffffff8145ee74>] ? acpi_os_map_memory+0x113/0x12d
[    0.081987]  [<ffffffff8122fc42>] ? acpi_ex_system_memory_space_handler+0xe2/0x1e3
[    0.082118]  [<ffffffff81228327>] ? acpi_ev_address_space_dispatch+0x174/0x1c3
[    0.082250]  [<ffffffff81229138>] ? acpi_ev_system_memory_region_setup+0x0/0x6e
[    0.082381]  [<ffffffff81097f22>] ? __get_free_pages+0x12/0x50
[    0.082473]  [<ffffffff810c5f38>] ? __kmalloc+0x118/0x150
[    0.082563]  [<ffffffff8122b635>] ? acpi_os_allocate+0x20/0x22
[    0.082652]  [<ffffffff8122b859>] ? acpi_ex_load_op+0xd4/0x256
[    0.082744]  [<ffffffff8122d8a3>] ? acpi_ex_opcode_1A_1T_0R+0x25/0x4b
[    0.082835]  [<ffffffff81225625>] ? acpi_ds_exec_end_op+0xf5/0x3e4
[    0.082927]  [<ffffffff81237ce0>] ? acpi_ps_parse_loop+0x7b8/0x950
[    0.083018]  [<ffffffff81225eca>] ? acpi_ds_call_control_method+0x106/0x198
[    0.083111]  [<ffffffff812370df>] ? acpi_ps_parse_aml+0x93/0x274
[    0.083202]  [<ffffffff81238526>] ? acpi_ps_execute_method+0x1c9/0x273
[    0.083332]  [<ffffffff81233a06>] ? acpi_ns_evaluate+0xda/0x1a5
[    0.083423]  [<ffffffff8123348a>] ? acpi_evaluate_object+0xfa/0x1f3
[    0.083515]  [<ffffffff8121ead1>] ? acpi_processor_set_pdc+0x174/0x19a
[    0.083608]  [<ffffffff8121eb79>] ? early_init_pdc+0x82/0x85
[    0.083698]  [<ffffffff81235214>] ? acpi_ns_walk_namespace+0xbb/0x17b
[    0.083790]  [<ffffffff8121eaf7>] ? early_init_pdc+0x0/0x85
[    0.083881]  [<ffffffff8121eaf7>] ? early_init_pdc+0x0/0x85
[    0.083970]  [<ffffffff8123332e>] ? acpi_walk_namespace+0x8e/0xc8
[    0.084061]  [<ffffffff8168ffd8>] ? acpi_init+0x0/0xd8
[    0.084150]  [<ffffffff816902d6>] ? acpi_early_processor_set_pdc+0x3a/0x53
[    0.084243]  [<ffffffff8168feb1>] ? acpi_bus_init+0xb6/0x1dd
[    0.084334]  [<ffffffff811cca7e>] ? kobject_create_and_add+0x3e/0x80
[    0.084426]  [<ffffffff81690049>] ? acpi_init+0x71/0xd8
[    0.084516]  [<ffffffff810002ae>] ? do_one_initcall+0x3e/0x170
[    0.084606]  [<ffffffff8166fc5d>] ? kernel_init+0xb8/0x139
[    0.084696]  [<ffffffff8102cb96>] ? schedule_tail+0x16/0x50
[    0.084786]  [<ffffffff81003834>] ? kernel_thread_helper+0x4/0x10
[    0.084878]  [<ffffffff8166fba5>] ? kernel_init+0x0/0x139
[    0.084967]  [<ffffffff81003830>] ? kernel_thread_helper+0x0/0x10
[    0.085057] ---[ end trace a7919e7f17c0a727 ]---
[    0.085146] ACPI Error: Method parse/execution failed [\_PR_.CPU1.APPT] (Node ffff880078c6ac58), AE_NO_MEMORY (20110112/psparse-536)
[    0.085454] ACPI Error: Method parse/execution failed [\_PR_.CPU1.GCAP] (Node ffff880078c6ac08), AE_NO_MEMORY (20110112/psparse-536)
[    0.085756] ACPI Error: Method parse/execution failed [\_PR_.CPU1._PDC] (Node ffff880078c6abb8), AE_NO_MEMORY (20110112/psparse-536)
[    0.086471] ACPI Error: Method parse/execution failed [\_PR_.CPU1.APCT] (Node ffff880078c6ac30), AE_NO_MEMORY (20110112/psparse-536)
[    0.086791] ACPI Error: Method parse/execution failed [\_PR_.CPU2.GCAP] (Node ffff880078c6acd0), AE_NO_MEMORY (20110112/psparse-536)
[    0.087093] ACPI Error: Method parse/execution failed [\_PR_.CPU2._PDC] (Node ffff880078c6ac80), AE_NO_MEMORY (20110112/psparse-536)
[    0.088016] ACPI: Interpreter enabled
[    0.088103] ACPI: (supports S0 S3 S4 S5)
[    0.088388] ACPI: Using IOAPIC for interrupt routing
[    0.094731] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.095031] ACPI: No dock devices found.
[    0.095117] HEST: Table not found.
[    0.095203] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.095755] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.096655] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.096664] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.096756] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.096888] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff]
[    0.097031] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.097056] DMAR: Forcing write-buffer flush capability
[    0.097144] DMAR: Disabling IOMMU for graphics on this chipset
[    0.097256] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    0.097271] pci 0000:00:02.0: reg 10: [mem 0x90000000-0x903fffff 64bit]
[    0.097281] pci 0000:00:02.0: reg 18: [mem 0x80000000-0x8fffffff 64bit pref]
[    0.097288] pci 0000:00:02.0: reg 20: [io  0x30d0-0x30d7]
[    0.097325] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    0.097338] pci 0000:00:02.1: reg 10: [mem 0x92400000-0x924fffff 64bit]
[    0.097425] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.097488] pci 0000:00:1a.0: reg 20: [io  0x30a0-0x30bf]
[    0.097569] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.099996] pci 0000:00:1a.7: reg 10: [mem 0x94504c00-0x94504fff]
[    0.123360] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.123367] pci 0000:00:1a.7: PME# disabled
[    0.123401] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.123423] pci 0000:00:1b.0: reg 10: [mem 0x94500000-0x94503fff 64bit]
[    0.123504] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.123510] pci 0000:00:1b.0: PME# disabled
[    0.123537] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.123621] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.123627] pci 0000:00:1c.0: PME# disabled
[    0.123660] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.123744] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.123749] pci 0000:00:1c.3: PME# disabled
[    0.123790] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.123869] pci 0000:00:1d.0: reg 20: [io  0x3080-0x309f]
[    0.123947] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.124026] pci 0000:00:1d.1: reg 20: [io  0x3060-0x307f]
[    0.124108] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.124188] pci 0000:00:1d.2: reg 20: [io  0x3040-0x305f]
[    0.124275] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.128607] pci 0000:00:1d.7: reg 10: [mem 0x94504800-0x94504bff]
[    0.151972] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.151978] pci 0000:00:1d.7: PME# disabled
[    0.152005] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.153329] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.153486] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.153515] pci 0000:00:1f.2: reg 10: [io  0x30c8-0x30cf]
[    0.153527] pci 0000:00:1f.2: reg 14: [io  0x30dc-0x30df]
[    0.153540] pci 0000:00:1f.2: reg 18: [io  0x30c0-0x30c7]
[    0.153552] pci 0000:00:1f.2: reg 1c: [io  0x30d8-0x30db]
[    0.153563] pci 0000:00:1f.2: reg 20: [io  0x3020-0x303f]
[    0.153576] pci 0000:00:1f.2: reg 24: [mem 0x94504000-0x945047ff]
[    0.153627] pci 0000:00:1f.2: PME# supported from D3hot
[    0.153632] pci 0000:00:1f.2: PME# disabled
[    0.153657] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.153680] pci 0000:00:1f.3: reg 10: [mem 0x94505000-0x945050ff 64bit]
[    0.153712] pci 0000:00:1f.3: reg 20: [io  0x3000-0x301f]
[    0.153828] pci 0000:01:00.0: [1969:1063] type 0 class 0x000200
[    0.153858] pci 0000:01:00.0: reg 10: [mem 0x93500000-0x9353ffff 64bit]
[    0.153874] pci 0000:01:00.0: reg 18: [io  0x2000-0x207f]
[    0.153973] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.153979] pci 0000:01:00.0: PME# disabled
[    0.160008] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.160100] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.160106] pci 0000:00:1c.0:   bridge window [mem 0x93500000-0x944fffff]
[    0.160115] pci 0000:00:1c.0:   bridge window [mem 0x90400000-0x913fffff 64bit pref]
[    0.160205] pci 0000:02:00.0: [8086:4232] type 0 class 0x000280
[    0.160246] pci 0000:02:00.0: reg 10: [mem 0x92500000-0x92501fff 64bit]
[    0.160405] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.160413] pci 0000:02:00.0: PME# disabled
[    0.166678] pci 0000:00:1c.3: PCI bridge to [bus 02-02]
[    0.166769] pci 0000:00:1c.3:   bridge window [io  0x1000-0x1fff]
[    0.166775] pci 0000:00:1c.3:   bridge window [mem 0x92500000-0x934fffff]
[    0.166783] pci 0000:00:1c.3:   bridge window [mem 0x91400000-0x923fffff 64bit pref]
[    0.166870] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
[    0.166966] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.166973] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.166982] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.166986] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.166989] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.166993] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.166996] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xfebfffff] (subtractive decode)
[    0.167018] pci_bus 0000:00: on NUMA node 0
[    0.167023] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.167328] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.167407] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.167483]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.173038] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.175757] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12)
[    0.176319] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.176886] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 *10 11 12)
[    0.177447] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.178123] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.178804] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 *11 12)
[    0.179364] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    0.180007] SCSI subsystem initialized
[    0.180134] libata version 3.00 loaded.
[    0.180204] usbcore: registered new interface driver usbfs
[    0.180309] usbcore: registered new interface driver hub
[    0.180419] usbcore: registered new device driver usb
[    0.180552] PCI: Using ACPI for IRQ routing
[    0.180639] PCI: pci_cache_line_size set to 64 bytes
[    0.180722] reserve RAM buffer: 000000000009e000 - 000000000009ffff 
[    0.180725] reserve RAM buffer: 000000007ba63000 - 000000007bffffff 
[    0.180729] reserve RAM buffer: 000000007bb80000 - 000000007bffffff 
[    0.180733] reserve RAM buffer: 000000007bbe0000 - 000000007bffffff 
[    0.180736] reserve RAM buffer: 000000007bc00000 - 000000007bffffff 
[    0.180840] NetLabel: Initializing
[    0.180925] NetLabel:  domain hash size = 128
[    0.181010] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.181110] NetLabel:  unlabeled traffic allowed by default
[    0.181203] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.181298] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.181587] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.186686] Switching to clocksource hpet
[    0.186806] pnp: PnP ACPI init
[    0.186905] ACPI: bus type pnp registered
[    0.187423] pnp 00:00: [bus 00-ff]
[    0.187427] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.187430] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.187433] pnp 00:00: [io  0x0d00-0xffff window]
[    0.187436] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.187439] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.187442] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.187444] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.187447] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.187450] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.187453] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.187456] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.187459] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.187462] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.187464] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.187467] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.187470] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.187473] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.187476] pnp 00:00: [mem 0x80000000-0xfebfffff window]
[    0.187479] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.187532] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.187714] pnp 00:01: [io  0x002e-0x002f]
[    0.187717] pnp 00:01: [io  0x004e-0x004f]
[    0.187720] pnp 00:01: [io  0x164e-0x164f]
[    0.187722] pnp 00:01: [io  0x0061]
[    0.187724] pnp 00:01: [io  0x0070]
[    0.187727] pnp 00:01: [io  0x0080]
[    0.187729] pnp 00:01: [io  0x0092]
[    0.187731] pnp 00:01: [io  0x00b2-0x00b3]
[    0.187734] pnp 00:01: [io  0x0063]
[    0.187739] pnp 00:01: [io  0x0065]
[    0.187741] pnp 00:01: [io  0x0067]
[    0.187743] pnp 00:01: [io  0x0600-0x060f]
[    0.187746] pnp 00:01: [io  0x0610]
[    0.187748] pnp 00:01: [io  0x0800-0x080f]
[    0.187750] pnp 00:01: [io  0x0810-0x0817]
[    0.187753] pnp 00:01: [io  0x0820-0x0823]
[    0.187755] pnp 00:01: [io  0x0400-0x047f]
[    0.187758] pnp 00:01: [io  0x0500-0x053f]
[    0.187760] pnp 00:01: [mem 0xf8000000-0xfbffffff]
[    0.187763] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    0.187765] pnp 00:01: [mem 0xfed10000-0xfed13fff]
[    0.187768] pnp 00:01: [mem 0xfed18000-0xfed18fff]
[    0.187771] pnp 00:01: [mem 0xfed19000-0xfed19fff]
[    0.187773] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    0.187776] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    0.187778] pnp 00:01: [mem 0xfed40000-0xfed44fff]
[    0.187781] pnp 00:01: [mem 0xfed45000-0xfed8ffff]
[    0.187783] pnp 00:01: [mem 0xfee00000-0xfee00fff]
[    0.187811] pnp 00:01: disabling [io  0x164e-0x164f] because it overlaps 0000:00:1c.3 BAR 13 [io  0x1000-0x1fff]
[    0.188016] system 00:01: [io  0x0600-0x060f] has been reserved
[    0.188108] system 00:01: [io  0x0610] has been reserved
[    0.188199] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.188290] system 00:01: [io  0x0810-0x0817] has been reserved
[    0.188381] system 00:01: [io  0x0820-0x0823] has been reserved
[    0.188473] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.188563] system 00:01: [io  0x0500-0x053f] has been reserved
[    0.188655] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.188748] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.188841] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.188934] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.189027] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.189119] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.189212] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.189305] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.189398] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.189491] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.189584] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.189599] pnp 00:02: [io  0x0000-0x001f]
[    0.189601] pnp 00:02: [io  0x0081-0x0091]
[    0.189604] pnp 00:02: [io  0x0093-0x009f]
[    0.189606] pnp 00:02: [io  0x00c0-0x00df]
[    0.189609] pnp 00:02: [dma 4]
[    0.189644] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.189676] pnp 00:03: [io  0x0070-0x0077]
[    0.189711] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.189804] pnp 00:04: [irq 0 disabled]
[    0.189813] pnp 00:04: [irq 8]
[    0.189816] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.189852] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.189870] pnp 00:05: [io  0x00f0]
[    0.189876] pnp 00:05: [irq 13]
[    0.189912] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.189926] pnp 00:06: [mem 0xff800000-0xffffffff]
[    0.189967] pnp 00:06: Plug and Play ACPI device, IDs INT0800 (active)
[    0.189967] Switched to NOHz mode on CPU #0
[    0.189977] pnp 00:07: [io  0x0060]
[    0.189980] pnp 00:07: [io  0x0064]
[    0.189985] pnp 00:07: [irq 1]
[    0.190034] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.190059] pnp 00:08: [irq 12]
[    0.190105] pnp 00:08: Plug and Play ACPI device, IDs SYN1b20 PNP0f13 (active)
[    0.190216] pnp: PnP ACPI: found 9 devices
[    0.190302] ACPI: ACPI bus type pnp unregistered
[    0.196722] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.196814] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.196908] pci 0000:00:1c.0:   bridge window [mem 0x93500000-0x944fffff]
[    0.197002] pci 0000:00:1c.0:   bridge window [mem 0x90400000-0x913fffff 64bit pref]
[    0.197137] pci 0000:00:1c.3: PCI bridge to [bus 02-02]
[    0.197227] pci 0000:00:1c.3:   bridge window [io  0x1000-0x1fff]
[    0.197321] pci 0000:00:1c.3:   bridge window [mem 0x92500000-0x934fffff]
[    0.197415] pci 0000:00:1c.3:   bridge window [mem 0x91400000-0x923fffff 64bit pref]
[    0.197550] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
[    0.197637] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.197729] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.197820] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.197925] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.198019] pci 0000:00:1c.0: setting latency timer to 64
[    0.198029] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.198122] pci 0000:00:1c.3: setting latency timer to 64
[    0.198130] pci 0000:00:1e.0: setting latency timer to 64
[    0.198135] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.198138] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.198141] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.198144] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.198148] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.198151] pci_bus 0000:01: resource 1 [mem 0x93500000-0x944fffff]
[    0.198154] pci_bus 0000:01: resource 2 [mem 0x90400000-0x913fffff 64bit pref]
[    0.198158] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.198161] pci_bus 0000:02: resource 1 [mem 0x92500000-0x934fffff]
[    0.198164] pci_bus 0000:02: resource 2 [mem 0x91400000-0x923fffff 64bit pref]
[    0.198168] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.198171] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.198174] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.198177] pci_bus 0000:03: resource 7 [mem 0x80000000-0xfebfffff]
[    0.198206] NET: Registered protocol family 2
[    0.198333] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.198791] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.201454] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.201905] TCP: Hash tables configured (established 262144 bind 65536)
[    0.201997] TCP reno registered
[    0.202083] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.202196] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.202452] NET: Registered protocol family 1
[    0.202562] pci 0000:00:02.0: Boot video device
[    0.230047] PCI: CLS 64 bytes, default 64
[    0.230119] Trying to unpack rootfs image as initramfs...
[    0.481407] Freeing initrd memory: 8480k freed
[    0.486315] Simple Boot Flag value 0x5 read from CMOS RAM was invalid
[    0.487199] Simple Boot Flag at 0x44 set to 0x1
[    0.488002] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
[    0.488116] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.488396] audit: initializing netlink socket (disabled)
[    0.488504] type=2000 audit(1304171775.486:1): initialized
[    0.501304] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.503902] VFS: Disk quotas dquot_6.5.2
[    0.504037] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.504657] msgmni has been set to 3880
[    0.504804] SELinux:  Registering netfilter hooks
[    0.505084] alg: No test for stdrng (krng)
[    0.505230] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.505379] io scheduler noop registered
[    0.505467] io scheduler deadline registered
[    0.505603] io scheduler cfq registered (default)
[    0.505773] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.505832] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.505921] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.505974] pcieport 0000:00:1c.3: irq 41 for MSI/MSI-X
[    0.506085] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.506203] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.506296] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.506730] intel_idle: MWAIT substates: 0x3122220
[    0.506733] intel_idle: does not run on family 6 model 23
[    0.507180] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.507635] ACPI: AC Adapter [ACAD] (on-line)
[    0.507990] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.508127] ACPI: Power Button [PWRB]
[    0.508267] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    0.510054] ACPI: Lid Switch [LID0]
[    0.510197] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.510331] ACPI: Sleep Button [SLPB]
[    0.510481] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.510613] ACPI: Power Button [PWRF]
[    0.510853] ACPI: acpi_idle registered with cpuidle
[    0.510996] Monitor-Mwait will be used to enter C-1 state
[    0.510999] Monitor-Mwait will be used to enter C-2 state
[    0.511002] Monitor-Mwait will be used to enter C-3 state
[    0.511006] Marking TSC unstable due to TSC halts in idle
[    0.512655] ERST: Table is not found!
[    0.512798] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.513492] Non-volatile memory driver v1.3
[    0.513582] Linux agpgart interface v0.103
[    0.513710] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    0.513972] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.515350] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    0.515544] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x80000000
[    0.515693] [drm] Initialized drm 1.1.0 20060810
[    0.515808] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.515905] i915 0000:00:02.0: setting latency timer to 64
[    0.517906] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.518058] ACPI: Battery Slot [BAT1] (battery absent)
[    0.596643] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.596650] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.596770] [drm] Driver supports precise vblank timestamp query.
[    1.121220] fbcon: inteldrmfb (fb0) is primary device
[    1.135288] Console: switching to colour frame buffer device 170x48
[    1.139569] fb0: inteldrmfb frame buffer device
[    1.139601] drm: registered panic notifier
[    1.141192] acpi device:03: registered as cooling_device1
[    1.141407] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    1.141474] ACPI: Video Device [OVGA] (multi-head: yes  rom: no  post: no)
[    1.141653] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.142846] brd: module loaded
[    1.142962] ahci 0000:00:1f.2: version 3.0
[    1.142975] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.143068] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    1.143113] ahci: SSS flag set, parallel bus scan disabled
[    1.143196] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    1.143254] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led pmp pio slum part ccc ems 
[    1.143314] ahci 0000:00:1f.2: setting latency timer to 64
[    1.163983] scsi0 : ahci
[    1.164101] scsi1 : ahci
[    1.164192] scsi2 : ahci
[    1.164283] scsi3 : ahci
[    1.164379] scsi4 : ahci
[    1.164469] scsi5 : ahci
[    1.164550] ata1: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504100 irq 43
[    1.164604] ata2: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504180 irq 43
[    1.164654] ata3: DUMMY
[    1.164674] ata4: DUMMY
[    1.164695] ata5: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504300 irq 43
[    1.164749] ata6: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504380 irq 43
[    1.166529] atl1c 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.168206] atl1c 0000:01:00.0: setting latency timer to 64
[    1.253587] atl1c 0000:01:00.0: version 1.0.1.0-NAPI
[    1.255266] console [netcon0] enabled
[    1.256917] netconsole: network logging started
[    1.258589] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.260246] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.261914] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.261919] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.263622] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.265294] ehci_hcd 0000:00:1a.7: debug port 1
[    1.270798] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    1.270811] ehci_hcd 0000:00:1a.7: irq 19, io mem 0x94504c00
[    1.283350] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.284979] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.286628] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.288243] usb usb1: Product: EHCI Host Controller
[    1.289827] usb usb1: Manufacturer: Linux 2.6.38.4 ehci_hcd
[    1.291452] usb usb1: SerialNumber: 0000:00:1a.7
[    1.293112] hub 1-0:1.0: USB hub found
[    1.294683] hub 1-0:1.0: 2 ports detected
[    1.296319] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.297880] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.297884] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.299458] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.301045] ehci_hcd 0000:00:1d.7: debug port 1
[    1.306439] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.306450] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x94504800
[    1.320023] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.321552] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.323079] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.324597] usb usb2: Product: EHCI Host Controller
[    1.326122] usb usb2: Manufacturer: Linux 2.6.38.4 ehci_hcd
[    1.327631] usb usb2: SerialNumber: 0000:00:1d.7
[    1.329191] hub 2-0:1.0: USB hub found
[    1.330639] hub 2-0:1.0: 6 ports detected
[    1.332115] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.333555] uhci_hcd: USB Universal Host Controller Interface driver
[    1.335012] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.336446] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.336451] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.337874] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.339281] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000030a0
[    1.340722] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.342138] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.343600] usb usb3: Product: UHCI Host Controller
[    1.345056] usb usb3: Manufacturer: Linux 2.6.38.4 uhci_hcd
[    1.346538] usb usb3: SerialNumber: 0000:00:1a.0
[    1.348089] hub 3-0:1.0: USB hub found
[    1.349582] hub 3-0:1.0: 2 ports detected
[    1.351119] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.352655] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.352659] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.354234] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    1.355866] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003080
[    1.357586] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.359146] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.360744] usb usb4: Product: UHCI Host Controller
[    1.362252] usb usb4: Manufacturer: Linux 2.6.38.4 uhci_hcd
[    1.363787] usb usb4: SerialNumber: 0000:00:1d.0
[    1.365424] hub 4-0:1.0: USB hub found
[    1.366945] hub 4-0:1.0: 2 ports detected
[    1.368488] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.370071] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.370076] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.371656] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    1.373321] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003060
[    1.374924] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.376486] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.378042] usb usb5: Product: UHCI Host Controller
[    1.379572] usb usb5: Manufacturer: Linux 2.6.38.4 uhci_hcd
[    1.381085] usb usb5: SerialNumber: 0000:00:1d.1
[    1.382734] hub 5-0:1.0: USB hub found
[    1.384290] hub 5-0:1.0: 2 ports detected
[    1.385866] uhci_hcd 0000:00:1d.2: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    1.387416] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.387421] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.388958] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    1.390513] uhci_hcd 0000:00:1d.2: irq 16, io base 0x00003040
[    1.392072] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.393613] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.395167] usb usb6: Product: UHCI Host Controller
[    1.396717] usb usb6: Manufacturer: Linux 2.6.38.4 uhci_hcd
[    1.398233] usb usb6: SerialNumber: 0000:00:1d.2
[    1.399847] hub 6-0:1.0: USB hub found
[    1.401382] hub 6-0:1.0: 2 ports detected
[    1.403026] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUE] at 0x60,0x64 irq 1,12
[    1.412131] i8042: Detected active multiplexing controller, rev 1.1
[    1.417271] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.418830] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.420399] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.421947] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.423453] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.424955] mousedev: PS/2 mouse device common for all mice
[    1.426758] rtc_cmos 00:03: RTC can wake from S4
[    1.428281] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.429776] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.431460] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.433169] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    1.434762] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x0460)
[    1.436372] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    1.437887] iTCO_vendor_support: vendor-support=0
[    1.439658] device-mapper: uevent: version 1.0.3
[    1.441211] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    1.442932] device-mapper: multipath: version 1.2.0 loaded
[    1.444448] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.445975] device-mapper: multipath queue-length: version 0.1.0 loaded
[    1.447587] device-mapper: multipath service-time: version 0.2.0 loaded
[    1.449198] cpuidle: using governor ladder
[    1.450799] cpuidle: using governor menu
[    1.452522] usbcore: registered new interface driver usbhid
[    1.454025] usbhid: USB HID core driver
[    1.455532] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.457421] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.458957] TCP cubic registered
[    1.460455] Initializing XFRM netlink socket
[    1.462019] NET: Registered protocol family 17
[    1.463600] registered taskstats version 1
[    1.465592] rtc_cmos 00:03: setting system clock to 2011-04-30 13:56:17 UTC (1304171777)
[    1.636706] usb 2-4: new high speed USB device using ehci_hcd and address 2
[    1.643377] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.692461] ata1.00: ATA-8: TOSHIBA MK2555GSX, FG001J, max UDMA/100
[    1.694094] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.696460] ata1.00: configured for UDMA/100
[    1.698153] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK2555GS FG00 PQ: 0 ANSI: 5
[    1.699903] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.701605] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.703265] sd 0:0:0:0: [sda] Write Protect is off
[    1.704871] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.704897] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.757677]  sda: sda1 sda2 sda3 sda4
[    1.759612] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.762790] usb 2-4: New USB device found, idVendor=058f, idProduct=6366
[    1.764521] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.766271] usb 2-4: Product: Mass Storage Device
[    1.767965] usb 2-4: Manufacturer: Generic
[    1.769666] usb 2-4: SerialNumber: 058F63666433
[    1.876701] usb 2-5: new high speed USB device using ehci_hcd and address 3
[    2.020046] ata2: SATA link down (SStatus 0 SControl 300)
[    2.041055] usb 2-5: New USB device found, idVendor=064e, idProduct=a102
[    2.042819] usb 2-5: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    2.044589] usb 2-5: Product: WebCam
[    2.046360] usb 2-5: Manufacturer: SuYin
[    2.048114] usb 2-5: SerialNumber: CN0316-S30C-OV061-VA-R02.02.02
[    2.238499] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa40000/0xa0000
[    2.285052] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio2/input/input5
[    2.315143] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input6
[    2.340066] ata5: SATA link down (SStatus 0 SControl 300)
[    2.660100] ata6: SATA link down (SStatus 0 SControl 300)
[    2.662777] Freeing unused kernel memory: 388k freed
[    2.707782] <30>dracut: dracut-009-6.fc15
[    2.733258] <30>udev[121]: starting version 167
[    2.834647] <30>dracut: Starting plymouth daemon
[    3.114162] Initializing USB Mass Storage driver...
[    3.115983] scsi6 : usb-storage 2-4:1.0
[    3.118050] usbcore: registered new interface driver usb-storage
[    3.119787] USB Mass Storage support registered.
[    3.449844] <30>dracut: luksOpen /dev/sda3 luksHome
[    4.248702] scsi 6:0:0:0: Direct-Access     Multiple Card  Reader     1.00 PQ: 0 ANSI: 0
[    4.253584] sd 6:0:0:0: Attached scsi generic sg1 type 0
[    4.833573] sd 6:0:0:0: [sdb] 246016 512-byte logical blocks: (125 MB/120 MiB)
[    4.836187] sd 6:0:0:0: [sdb] Write Protect is off
[    4.838061] sd 6:0:0:0: [sdb] Mode Sense: 03 00 00 00
[    4.838809] sd 6:0:0:0: [sdb] No Caching mode page present
[    4.840662] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    4.845556] sd 6:0:0:0: [sdb] No Caching mode page present
[    4.847384] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    4.850322]  sdb: sdb1
[    4.859682] sd 6:0:0:0: [sdb] No Caching mode page present
[    4.861461] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    4.863213] sd 6:0:0:0: [sdb] Attached SCSI removable disk


