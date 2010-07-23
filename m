Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277Ab0GWPNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:13:24 -0400
Received: from www17.your-server.de ([213.133.104.17]:42742 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab0GWPNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:13:19 -0400
Subject: Re: [Bug #15673] 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
From: Thomas Meyer <thomas@m3y3r.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
In-Reply-To: <PRbv8sgxY6G.A.nKH.yYYSMB@chimera>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
	 <PRbv8sgxY6G.A.nKH.yYYSMB@chimera>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 17:12:13 +0200
Message-ID: <1279897933.3126.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 23.07.2010, 14:15 +0200 schrieb Rafael J. Wysocki:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15673
> Subject		: 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
> Submitter	: Thomas Meyer <thomas@m3y3r.de>
> Date		: 2010-03-28 11:31 (118 days old)
> Message-ID	: <1269775909.5301.4.camel@localhost.localdomain>
> References	: http://marc.info/?l=linux-kernel&m=126977593326800&w=2
> 
> 

I also see this message in 2.6.35-rc6:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-rc6 (thomas@localhost.localdomain) (gcc version 4.4.4 20100630 (Red Hat 4.4.4-10) (GCC) ) #112 Thu Jul 22 21:59:35 CEST 2010
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.6 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x7bc00 max_arch_pfn = 0x100000
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
[    0.000000] initial memory mapped : 0 - 01000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] RAMDISK: 37942000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 00ba7000 - 01254073
[    0.000000] Move RAMDISK from 0000000037942000 - 0000000037fef072 to 00ba7000 - 01254072
[    0.000000] ACPI: RSDP 000fe020 00024 (v02 ACRSYS)
[    0.000000] ACPI: XSDT 7bbf6120 0007C (v01 ACRSYS ACRPRDCT 00000001      01000013)
[    0.000000] ACPI: FACP 7bbf4000 000F4 (v04 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: DSDT 7bbe8000 073EA (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: FACS 7bb8d000 00040
[    0.000000] ACPI: DMAR 7bbf5000 00068 (v01               ? 00000001      00000000)
[    0.000000] ACPI: HPET 7bbf3000 00038 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: APIC 7bbf2000 0006C (v02 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: MCFG 7bbf1000 0003C (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: ASF! 7bbf0000 000A5 (v32 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: SLIC 7bbe7000 00176 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: BOOT 7bbe6000 00028 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: SSDT 7bbe2000 00223 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 7bbe1000 00537 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.000000] ACPI: SSDT 7bbe0000 00655 (v01  PmRef    CpuPm 00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1092MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0007bc00
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0007ba63
[    0.000000]     0: 0x0007babf -> 0x0007bb80
[    0.000000]     0: 0x0007bbbf -> 0x0007bbe0
[    0.000000]     0: 0x0007bbf7 -> 0x0007bc00
[    0.000000] On node 0 totalpages: 506603
[    0.000000] free_area_init_node: node 0, pgdat c0a8dc60, node_mem_map c1256020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3965 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2185 pages used for memmap
[    0.000000]   HighMem zone: 277191 pages, LIFO batch:31
[    0.000000] Using APIC driver default
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
[    0.000000] early_res array is doubled to 64 at [5000 - 57ff]
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:78000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 502642
[    0.000000] Kernel command line: ro root=UUID=5764c1f2-f119-4f97-b8e2-d827b8655edb LANG=de_DE.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=de-latin1-nodeadkeys rhgb quiet resume=/dev/mapper/luks-swap
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] allocated 10137580 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at drivers/pci/dmar.c:633 warn_invalid_dmar+0x96/0xa0()
[    0.000000] Hardware name: Aspire 1810T
[    0.000000] Your BIOS is broken; DMAR reported at address 0!
[    0.000000] BIOS vendor: INSYDE; Ver: v1.3310; Product Version: v1.3310
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.35-rc6 #112
[    0.000000] Call Trace:
[    0.000000]  [<c0430e42>] warn_slowpath_common+0x72/0xa0
[    0.000000]  [<c0651926>] ? warn_invalid_dmar+0x96/0xa0
[    0.000000]  [<c0651926>] ? warn_invalid_dmar+0x96/0xa0
[    0.000000]  [<c0430ed2>] warn_slowpath_fmt_taint+0x32/0x40
[    0.000000]  [<c0651926>] warn_invalid_dmar+0x96/0xa0
[    0.000000]  [<c0ab7bba>] check_zero_address+0x53/0x12d
[    0.000000]  [<c068e45c>] ? acpi_tb_verify_table+0x4b/0x4e
[    0.000000]  [<c068dddc>] ? acpi_get_table_with_size+0x58/0xa6
[    0.000000]  [<c0ab7ca5>] detect_intel_iommu+0x11/0x69
[    0.000000]  [<c0a9d23a>] pci_iommu_alloc+0x8/0xa
[    0.000000]  [<c0aa7b8e>] mem_init+0xe/0x28c
[    0.000000]  [<c0aadc06>] ? __alloc_bootmem_node_nopanic+0x72/0x99
[    0.000000]  [<c0894a76>] ? printk+0x1d/0x1f
[    0.000000]  [<c0ab0267>] ? page_cgroup_init_flatmem+0xa0/0xe3
[    0.000000]  [<c0a97682>] start_kernel+0x18e/0x313
[    0.000000]  [<c0a97323>] ? unknown_bootoption+0x0/0x19b
[    0.000000]  [<c0a970b4>] i386_start_kernel+0xb4/0xbc
[    0.000000] ---[ end trace a7919e7f17c0a725 ]---
[    0.000000] Disabling lock debugging due to kernel taint
[    0.000000] Subtract (44 early reservations)
[    0.000000]   #1 [0000400000 - 0000ba1058]   TEXT DATA BSS
[    0.000000]   #2 [000009e000 - 0000100000]   BIOS reserved
[    0.000000]   #3 [0000ba2000 - 0000ba6258]             BRK
[    0.000000]   #4 [0000001000 - 0000005000]     ACPI WAKEUP
[    0.000000]   #5 [0000007000 - 0000008000]         PGTABLE
[    0.000000]   #6 [0000ba7000 - 0001255000]     NEW RAMDISK
[    0.000000]   #7 [0001255000 - 0001256000]         BOOTMEM
[    0.000000]   #8 [0001256000 - 00021ce000]         BOOTMEM
[    0.000000]   #9 [00021ce000 - 00021ce004]         BOOTMEM
[    0.000000]   #10 [00021ce040 - 00021ce0c0]         BOOTMEM
[    0.000000]   #11 [00021ce0c0 - 00021ce114]         BOOTMEM
[    0.000000]   #12 [00021ce140 - 00021d0140]         BOOTMEM
[    0.000000]   #13 [00021d0140 - 00021d01a8]         BOOTMEM
[    0.000000]   #14 [00021d01c0 - 00021d41c0]         BOOTMEM
[    0.000000]   #15 [00021d41c0 - 00021d41e5]         BOOTMEM
[    0.000000]   #16 [00021d4200 - 00021d4227]         BOOTMEM
[    0.000000]   #17 [00021d4240 - 00021d4454]         BOOTMEM
[    0.000000]   #18 [00021d4480 - 00021d44c0]         BOOTMEM
[    0.000000]   #19 [00021d44c0 - 00021d4500]         BOOTMEM
[    0.000000]   #20 [00021d4500 - 00021d4540]         BOOTMEM
[    0.000000]   #21 [00021d4540 - 00021d4580]         BOOTMEM
[    0.000000]   #22 [00021d4580 - 00021d45c0]         BOOTMEM
[    0.000000]   #23 [00021d45c0 - 00021d4600]         BOOTMEM
[    0.000000]   #24 [00021d4600 - 00021d4640]         BOOTMEM
[    0.000000]   #25 [00021d4640 - 00021d4680]         BOOTMEM
[    0.000000]   #26 [00021d4680 - 00021d46c0]         BOOTMEM
[    0.000000]   #27 [00021d46c0 - 00021d4700]         BOOTMEM
[    0.000000]   #28 [00021d4700 - 00021d4740]         BOOTMEM
[    0.000000]   #29 [00021d4740 - 00021d4780]         BOOTMEM
[    0.000000]   #30 [00021d4780 - 00021d47c0]         BOOTMEM
[    0.000000]   #31 [00021d47c0 - 00021d4800]         BOOTMEM
[    0.000000]   #32 [00021d4800 - 00021d4840]         BOOTMEM
[    0.000000]   #33 [00021d4840 - 00021d4880]         BOOTMEM
[    0.000000]   #34 [00021d4880 - 00021d48c0]         BOOTMEM
[    0.000000]   #35 [00021d48c0 - 00021d4900]         BOOTMEM
[    0.000000]   #36 [00021d4900 - 00021d4910]         BOOTMEM
[    0.000000]   #37 [00021d4940 - 00021d49f3]         BOOTMEM
[    0.000000]   #38 [00021d4a00 - 00021d4ab3]         BOOTMEM
[    0.000000]   #39 [00021d4ac0 - 00021d8ac0]         BOOTMEM
[    0.000000]   #40 [00021d8ac0 - 0002258ac0]         BOOTMEM
[    0.000000]   #41 [0002258ac0 - 0002298ac0]         BOOTMEM
[    0.000000]   #42 [0002298ac0 - 0002298d00]         BOOTMEM
[    0.000000]   #43 [0002299000 - 0002c43fec]         BOOTMEM
[    0.000000] Initializing HighMem for node 0 (000377fe:0007bc00)
[    0.000000] Memory: 1985160k/2027520k available (4720k kernel code, 41252k reserved, 2026k data, 484k init, 1117504k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc0a97000 - 0xc0b10000   ( 484 kB)
[    0.000000]       .data : 0xc089c218 - 0xc0a96cc8   (2026 kB)
[    0.000000]       .text : 0xc0400000 - 0xc089c218   (4720 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:288
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1396.379 MHz processor.
[    0.003338] Calibrating delay loop (skipped), value calculated using timer frequency.. 2793.12 BogoMIPS (lpj=4654596)
[    0.003344] pid_max: default: 32768 minimum: 301
[    0.003360] Security Framework initialized
[    0.003366] SELinux:  Initializing.
[    0.003373] SELinux:  Starting in permissive mode
[    0.003381] Mount-cache hash table entries: 512
[    0.003531] Initializing cgroup subsys ns
[    0.003539] Initializing cgroup subsys cpuacct
[    0.003542] Initializing cgroup subsys memory
[    0.003550] Initializing cgroup subsys devices
[    0.003553] Initializing cgroup subsys freezer
[    0.003556] Initializing cgroup subsys net_cls
[    0.003558] Initializing cgroup subsys blkio
[    0.003591] mce: CPU supports 6 MCE banks
[    0.003601] CPU0: Thermal monitoring enabled (TM2)
[    0.003605] using mwait in idle threads.
[    0.003613] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.003622] ... version:                2
[    0.003624] ... bit width:              40
[    0.003626] ... generic registers:      2
[    0.003628] ... value mask:             000000ffffffffff
[    0.003631] ... max period:             000000007fffffff
[    0.003633] ... fixed-purpose events:   3
[    0.003635] ... event mask:             0000000700000003
[    0.003639] CPU: Intel(R) Core(TM)2 Solo CPU    U3500  @ 1.40GHz stepping 0a
[    0.006899] ACPI: Core revision 20100428
[    0.026675] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.026681] ftrace: allocating 19569 entries in 39 pages
[    0.030123] DMAR: Host address width 36
[    0.030128] DMAR: DRHD base: 0x00000000000000 flags: 0x1
[    0.030131] DMAR: parse DMAR table failure.
[    0.030134] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.030491] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.066666] regulator: core version 0.5
[    0.066666] NET: Registered protocol family 16
[    0.066666] ACPI: bus type pci registered
[    0.066666] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.066666] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.066666] PCI: Using MMCONFIG for extended config space
[    0.066666] PCI: Using configuration type 1 for base access
[    0.066666] bio: create slab <bio-0> at 0
[    0.066912] ACPI: EC: Look up EC in DSDT
[    0.068868] ACPI: Executed 1 blocks of module-level executable AML code
[    0.073021] ACPI: BIOS _OSI(Linux) query ignored
[    0.074004] ACPI: Interpreter enabled
[    0.074009] ACPI: (supports S0 S3 S4 S5)
[    0.074051] ACPI: Using IOAPIC for interrupt routing
[    0.084281] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.084809] ACPI: No dock devices found.
[    0.084813] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.085599] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.087115] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.087120] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.087124] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.087129] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff]
[    0.087164] DMAR: Forcing write-buffer flush capability
[    0.087166] DMAR: Disabling IOMMU for graphics on this chipset
[    0.087201] pci 0000:00:02.0: reg 10: [mem 0x90000000-0x903fffff 64bit]
[    0.087209] pci 0000:00:02.0: reg 18: [mem 0x80000000-0x8fffffff 64bit pref]
[    0.087216] pci 0000:00:02.0: reg 20: [io  0x30d0-0x30d7]
[    0.087256] pci 0000:00:02.1: reg 10: [mem 0x92400000-0x924fffff 64bit]
[    0.087389] pci 0000:00:1a.0: reg 20: [io  0x30a0-0x30bf]
[    0.087494] pci 0000:00:1a.7: reg 10: [mem 0x94504c00-0x94504fff]
[    0.087576] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.087582] pci 0000:00:1a.7: PME# disabled
[    0.087631] pci 0000:00:1b.0: reg 10: [mem 0x94500000-0x94503fff 64bit]
[    0.087691] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.087697] pci 0000:00:1b.0: PME# disabled
[    0.087794] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.087800] pci 0000:00:1c.0: PME# disabled
[    0.087903] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.087908] pci 0000:00:1c.3: PME# disabled
[    0.087996] pci 0000:00:1d.0: reg 20: [io  0x3080-0x309f]
[    0.088112] pci 0000:00:1d.1: reg 20: [io  0x3060-0x307f]
[    0.088229] pci 0000:00:1d.2: reg 20: [io  0x3040-0x305f]
[    0.088322] pci 0000:00:1d.7: reg 10: [mem 0x94504800-0x94504bff]
[    0.088394] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.088400] pci 0000:00:1d.7: PME# disabled
[    0.088633] pci 0000:00:1f.2: reg 10: [io  0x30c8-0x30cf]
[    0.088642] pci 0000:00:1f.2: reg 14: [io  0x30dc-0x30df]
[    0.088649] pci 0000:00:1f.2: reg 18: [io  0x30c0-0x30c7]
[    0.088658] pci 0000:00:1f.2: reg 1c: [io  0x30d8-0x30db]
[    0.088666] pci 0000:00:1f.2: reg 20: [io  0x3020-0x303f]
[    0.088675] pci 0000:00:1f.2: reg 24: [mem 0x94504000-0x945047ff]
[    0.088722] pci 0000:00:1f.2: PME# supported from D3hot
[    0.088727] pci 0000:00:1f.2: PME# disabled
[    0.088767] pci 0000:00:1f.3: reg 10: [mem 0x94505000-0x945050ff 64bit]
[    0.088786] pci 0000:00:1f.3: reg 20: [io  0x3000-0x301f]
[    0.088914] pci 0000:01:00.0: reg 10: [mem 0x93500000-0x9353ffff 64bit]
[    0.088924] pci 0000:01:00.0: reg 18: [io  0x2000-0x207f]
[    0.089000] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.089007] pci 0000:01:00.0: PME# disabled
[    0.093353] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.093359] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.093365] pci 0000:00:1c.0:   bridge window [mem 0x93500000-0x944fffff]
[    0.093373] pci 0000:00:1c.0:   bridge window [mem 0x90400000-0x913fffff 64bit pref]
[    0.093540] pci 0000:02:00.0: reg 10: [mem 0x92500000-0x92501fff 64bit]
[    0.093698] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.093726] pci 0000:02:00.0: PME# disabled
[    0.100043] pci 0000:00:1c.3: PCI bridge to [bus 02-02]
[    0.100049] pci 0000:00:1c.3:   bridge window [io  0x1000-0x1fff]
[    0.100055] pci 0000:00:1c.3:   bridge window [mem 0x92500000-0x934fffff]
[    0.100064] pci 0000:00:1c.3:   bridge window [mem 0x91400000-0x923fffff 64bit pref]
[    0.100153] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
[    0.100159] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.100165] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.100174] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.100178] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.100181] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.100185] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.100188] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xfebfffff] (subtractive decode)
[    0.100210] pci_bus 0000:00: on NUMA node 0
[    0.100219] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.100764] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.100944] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.121373] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.121578] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12)
[    0.121778] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.121977] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 *10 11 12)
[    0.122177] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.122377] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.122579] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 *11 12)
[    0.122778] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    0.122867] HEST: Table is not found!
[    0.122914] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.122924] vgaarb: loaded
[    0.123035] SCSI subsystem initialized
[    0.123066] libata version 3.00 loaded.
[    0.123103] usbcore: registered new interface driver usbfs
[    0.123123] usbcore: registered new interface driver hub
[    0.123147] usbcore: registered new device driver usb
[    0.123216] PCI: Using ACPI for IRQ routing
[    0.123219] PCI: pci_cache_line_size set to 64 bytes
[    0.123338] reserve RAM buffer: 000000000009e000 - 000000000009ffff 
[    0.123342] reserve RAM buffer: 000000007ba63000 - 000000007bffffff 
[    0.123346] reserve RAM buffer: 000000007bb80000 - 000000007bffffff 
[    0.123350] reserve RAM buffer: 000000007bbe0000 - 000000007bffffff 
[    0.123354] reserve RAM buffer: 000000007bc00000 - 000000007bffffff 
[    0.123452] NetLabel: Initializing
[    0.123455] NetLabel:  domain hash size = 128
[    0.123457] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.123471] NetLabel:  unlabeled traffic allowed by default
[    0.123477] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.123485] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.123491] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.126682] Switching to clocksource tsc
[    0.129723] pnp: PnP ACPI init
[    0.129734] ACPI: bus type pnp registered
[    0.131288] pnp 00:01: disabling [io  0x164e-0x164f] because it overlaps 0000:00:1c.3 BAR 13 [io  0x1000-0x1fff]
[    0.132197] pnp: PnP ACPI: found 9 devices
[    0.132200] ACPI: ACPI bus type pnp unregistered
[    0.132211] system 00:01: [io  0x0600-0x060f] has been reserved
[    0.132215] system 00:01: [io  0x0610] has been reserved
[    0.132219] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.132223] system 00:01: [io  0x0810-0x0817] has been reserved
[    0.132227] system 00:01: [io  0x0820-0x0823] has been reserved
[    0.132231] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.132234] system 00:01: [io  0x0500-0x053f] has been reserved
[    0.132239] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.132243] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.132247] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.132251] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.132255] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.132259] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.132263] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.132267] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.132271] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.132275] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.167021] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.167026] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.167033] pci 0000:00:1c.0:   bridge window [mem 0x93500000-0x944fffff]
[    0.167039] pci 0000:00:1c.0:   bridge window [mem 0x90400000-0x913fffff 64bit pref]
[    0.167048] pci 0000:00:1c.3: PCI bridge to [bus 02-02]
[    0.167052] pci 0000:00:1c.3:   bridge window [io  0x1000-0x1fff]
[    0.167059] pci 0000:00:1c.3:   bridge window [mem 0x92500000-0x934fffff]
[    0.167064] pci 0000:00:1c.3:   bridge window [mem 0x91400000-0x923fffff 64bit pref]
[    0.167073] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
[    0.167075] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.167081] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.167086] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.167106] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.167113] pci 0000:00:1c.0: setting latency timer to 64
[    0.167128] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.167134] pci 0000:00:1c.3: setting latency timer to 64
[    0.167143] pci 0000:00:1e.0: setting latency timer to 64
[    0.167148] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.167151] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.167154] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.167158] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.167161] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.167164] pci_bus 0000:01: resource 1 [mem 0x93500000-0x944fffff]
[    0.167168] pci_bus 0000:01: resource 2 [mem 0x90400000-0x913fffff 64bit pref]
[    0.167171] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.167174] pci_bus 0000:02: resource 1 [mem 0x92500000-0x934fffff]
[    0.167178] pci_bus 0000:02: resource 2 [mem 0x91400000-0x923fffff 64bit pref]
[    0.167181] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.167184] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.167187] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.167190] pci_bus 0000:03: resource 7 [mem 0x80000000-0xfebfffff]
[    0.167208] NET: Registered protocol family 2
[    0.167233] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.167350] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.167888] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[    0.168035] TCP: Hash tables configured (established 131072 bind 65536)
[    0.168038] TCP reno registered
[    0.168042] UDP hash table entries: 512 (order: 1, 8192 bytes)
[    0.168050] UDP-Lite hash table entries: 512 (order: 1, 8192 bytes)
[    0.168092] NET: Registered protocol family 1
[    0.168107] pci 0000:00:02.0: Boot video device
[    0.196702] PCI: CLS 64 bytes, default 64
[    0.196765] Trying to unpack rootfs image as initramfs...
[    0.432570] Freeing initrd memory: 6840k freed
[    0.436276] Simple Boot Flag value 0x5 read from CMOS RAM was invalid
[    0.436280] Simple Boot Flag at 0x44 set to 0x1
[    0.436510] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
[    0.436528] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.436639] audit: initializing netlink socket (disabled)
[    0.436682] type=2000 audit(1279829160.433:1): initialized
[    0.447676] highmem bounce pool size: 64 pages
[    0.447683] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.449684] VFS: Disk quotas dquot_6.5.2
[    0.449733] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.450369] Btrfs loaded
[    0.450375] msgmni has been set to 1708
[    0.450445] SELinux:  Registering netfilter hooks
[    0.450751] alg: No test for stdrng (krng)
[    0.450815] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.450819] io scheduler noop registered
[    0.450822] io scheduler deadline registered
[    0.450840] io scheduler cfq registered (default)
[    0.450933] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.450992] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.451102] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.451157] pcieport 0000:00:1c.3: irq 41 for MSI/MSI-X
[    0.451282] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.451445] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.451448] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.451834] pci-stub: invalid id string ""
[    0.451858] intel_idle: MWAIT substates: 0x3122220
[    0.451861] intel_idle: does not run on family 6 model 23
[    0.452284] ACPI: AC Adapter [ACAD] (off-line)
[    0.452373] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.452377] ACPI: Power Button [PWRB]
[    0.452431] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    0.453538] ACPI: Lid Switch [LID0]
[    0.453599] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    0.453602] ACPI: Sleep Button [SLPB]
[    0.453666] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.453669] ACPI: Power Button [PWRF]
[    0.454078] ACPI: acpi_idle registered with cpuidle
[    0.454372] Marking TSC unstable due to TSC halts in idle
[    0.457748] Switching to clocksource hpet
[    0.458187] ERST: Table is not found!
[    0.459743] Non-volatile memory driver v1.3
[    0.459746] Linux agpgart interface v0.103
[    0.459787] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    0.461099] agpgart-intel 0000:00:00.0: detected 65532K stolen memory
[    0.489906] ACPI: Battery Slot [BAT1] (battery absent)
[    0.489980] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x80000000
[    0.490079] [drm] Initialized drm 1.1.0 20060810
[    0.490110] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.490115] i915 0000:00:02.0: setting latency timer to 64
[    0.522764] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.522777] [drm] set up 63M of stolen space
[    1.263749] fbcon: inteldrmfb (fb0) is primary device
[    2.278442] Console: switching to colour frame buffer device 170x48
[    2.284210] fb0: inteldrmfb frame buffer device
[    2.284212] drm: registered panic notifier
[    2.284251] Slow work thread pool: Starting up
[    2.284288] Slow work thread pool: Ready
[    2.287455] acpi device:02: registered as cooling_device1
[    2.287836] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    2.287843] ACPI: Video Device [OVGA] (multi-head: yes  rom: no  post: no)
[    2.287865] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.287892] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.289388] brd: module loaded
[    2.289472] ahci 0000:00:1f.2: version 3.0
[    2.289488] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.289534] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    2.289584] ahci: SSS flag set, parallel bus scan disabled
[    2.289629] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    2.289634] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led pmp pio slum part ccc ems 
[    2.289642] ahci 0000:00:1f.2: setting latency timer to 64
[    2.306713] scsi0 : ahci
[    2.306803] scsi1 : ahci
[    2.306869] scsi2 : ahci
[    2.306933] scsi3 : ahci
[    2.306997] scsi4 : ahci
[    2.307062] scsi5 : ahci
[    2.307116] ata1: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504100 irq 43
[    2.307121] ata2: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504180 irq 43
[    2.307124] ata3: DUMMY
[    2.307126] ata4: DUMMY
[    2.307129] ata5: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504300 irq 43
[    2.307134] ata6: SATA max UDMA/133 abar m2048@0x94504000 port 0x94504380 irq 43
[    2.307211] atl1c 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.307220] atl1c 0000:01:00.0: setting latency timer to 64
[    2.383645] atl1c 0000:01:00.0: version 1.0.0.2-NAPI
[    2.383680] console [netcon0] enabled
[    2.383682] netconsole: network logging started
[    2.383723] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.383743] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.383757] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.383762] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.383816] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.383847] ehci_hcd 0000:00:1a.7: debug port 1
[    2.387724] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    2.387736] ehci_hcd 0000:00:1a.7: irq 19, io mem 0x94504c00
[    2.400019] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.400043] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.400047] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.400050] usb usb1: Product: EHCI Host Controller
[    2.400053] usb usb1: Manufacturer: Linux 2.6.35-rc6 ehci_hcd
[    2.400055] usb usb1: SerialNumber: 0000:00:1a.7
[    2.400149] hub 1-0:1.0: USB hub found
[    2.400156] hub 1-0:1.0: 2 ports detected
[    2.400226] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.400240] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.400244] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.400284] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.400315] ehci_hcd 0000:00:1d.7: debug port 1
[    2.404204] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    2.404217] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x94504800
[    2.416685] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.416712] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.416716] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.416719] usb usb2: Product: EHCI Host Controller
[    2.416722] usb usb2: Manufacturer: Linux 2.6.35-rc6 ehci_hcd
[    2.416724] usb usb2: SerialNumber: 0000:00:1d.7
[    2.416814] hub 2-0:1.0: USB hub found
[    2.416819] hub 2-0:1.0: 6 ports detected
[    2.416893] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.416910] uhci_hcd: USB Universal Host Controller Interface driver
[    2.416933] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.416941] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.416945] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.416986] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    2.417022] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000030a0
[    2.417059] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.417063] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.417066] usb usb3: Product: UHCI Host Controller
[    2.417068] usb usb3: Manufacturer: Linux 2.6.35-rc6 uhci_hcd
[    2.417071] usb usb3: SerialNumber: 0000:00:1a.0
[    2.417160] hub 3-0:1.0: USB hub found
[    2.417165] hub 3-0:1.0: 2 ports detected
[    2.417229] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.417237] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.417241] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.417278] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    2.417308] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003080
[    2.417344] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.417347] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.417351] usb usb4: Product: UHCI Host Controller
[    2.417353] usb usb4: Manufacturer: Linux 2.6.35-rc6 uhci_hcd
[    2.417356] usb usb4: SerialNumber: 0000:00:1d.0
[    2.417446] hub 4-0:1.0: USB hub found
[    2.417451] hub 4-0:1.0: 2 ports detected
[    2.417513] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.417520] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.417525] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.417565] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    2.417595] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003060
[    2.417631] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.417635] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.417638] usb usb5: Product: UHCI Host Controller
[    2.417641] usb usb5: Manufacturer: Linux 2.6.35-rc6 uhci_hcd
[    2.417644] usb usb5: SerialNumber: 0000:00:1d.1
[    2.417731] hub 5-0:1.0: USB hub found
[    2.417736] hub 5-0:1.0: 2 ports detected
[    2.417802] uhci_hcd 0000:00:1d.2: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    2.417809] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.417814] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.417852] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    2.417882] uhci_hcd 0000:00:1d.2: irq 16, io base 0x00003040
[    2.417919] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.417923] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.417926] usb usb6: Product: UHCI Host Controller
[    2.417929] usb usb6: Manufacturer: Linux 2.6.35-rc6 uhci_hcd
[    2.417931] usb usb6: SerialNumber: 0000:00:1d.2
[    2.418019] hub 6-0:1.0: USB hub found
[    2.418024] hub 6-0:1.0: 2 ports detected
[    2.418161] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUE] at 0x60,0x64 irq 1,12
[    2.426800] i8042.c: Detected active multiplexing controller, rev 1.1.
[    2.430435] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.430441] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    2.430472] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    2.430499] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    2.430524] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    2.430599] mice: PS/2 mouse device common for all mice
[    2.430808] rtc_cmos 00:03: RTC can wake from S4
[    2.430848] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.430878] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    2.431007] device-mapper: uevent: version 1.0.3
[    2.431102] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    2.431206] cpuidle: using governor ladder
[    2.431272] cpuidle: using governor menu
[    2.431608] usbcore: registered new interface driver hiddev
[    2.431625] usbcore: registered new interface driver usbhid
[    2.431627] usbhid: USB HID core driver
[    2.431678] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.431812] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[    2.431815] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[    2.431818] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    2.431904] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.431918] TCP cubic registered
[    2.431920] Initializing XFRM netlink socket
[    2.431931] NET: Registered protocol family 17
[    2.431946] Using IPI Shortcut mode
[    2.452185] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    2.723376] usb 2-5: new high speed USB device using ehci_hcd and address 2
[    2.786730] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.836664] ata1.00: ATA-8: TOSHIBA MK2555GSX, FG001J, max UDMA/100
[    2.836677] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.837566] ata1.00: configured for UDMA/100
[    2.850145] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK2555GS FG00 PQ: 0 ANSI: 5
[    2.850276] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.850357] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    2.850406] sd 0:0:0:0: [sda] Write Protect is off
[    2.850410] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.850433] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.850558]  sda:
[    2.887666] usb 2-5: New USB device found, idVendor=064e, idProduct=a102
[    2.887670] usb 2-5: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    2.887673] usb 2-5: Product: WebCam
[    2.887676] usb 2-5: Manufacturer: SuYin
[    2.887678] usb 2-5: SerialNumber: CN0316-S30C-OV061-VA-R02.02.02
[    2.901855]  sda1 sda2 sda3 sda4
[    2.902125] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.170116] ata2: SATA link down (SStatus 0 SControl 300)
[    3.216288] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04731/0xa40000/0xa0000
[    3.261310] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio2/input/input6
[    3.503384] ata5: SATA link down (SStatus 0 SControl 300)
[    3.836770] ata6: SATA link down (SStatus 0 SControl 300)
[    3.850110] registered taskstats version 1
[    3.850114] IMA: No TPM chip found, activating TPM-bypass!
[    3.850475] rtc_cmos 00:03: setting system clock to 2010-07-22 20:06:04 UTC (1279829164)
[    3.850539] Initalizing network drop monitor service
[    3.850585] Freeing unused kernel memory: 484k freed
[    3.850780] Write protecting the kernel text: 4724k
[    3.850809] Write protecting the kernel read-only data: 1680k
[    3.871652] dracut: dracut-005-3.fc13
[    3.885542] udev: starting version 151
[    3.971874] dracut: Starting plymouth daemon
[    4.869942] dracut: luksOpen /dev/sda3 luks-home
[   15.065437] padlock: VIA PadLock not detected.
[   15.414004] dracut: luksOpen /dev/sda4 luks-swap
[   16.136588] PM: Starting manual resume from disk
[   16.220490] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[   16.253091] dracut: Remounting /dev/disk/by-uuid/5764c1f2-f119-4f97-b8e2-d827b8655edb with -o noatime,data=writeback,ro
[   16.298270] EXT4-fs (sda2): mounted filesystem with writeback data mode. Opts: data=writeback
[   16.311781] dracut: Mounted root filesystem /dev/sda2
[   16.494442] dracut: Loading SELinux policy
[   16.861684] type=1404 audit(1279829177.509:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[   16.977507] SELinux: 2048 avtab hash slots, 196917 rules.
[   17.074420] SELinux: 2048 avtab hash slots, 196917 rules.
[   17.305045] SELinux:  9 users, 13 roles, 3276 types, 160 bools, 1 sens, 1024 cats
[   17.305052] SELinux:  77 classes, 196917 rules
[   17.311485] SELinux:  Completing initialization.
[   17.311487] SELinux:  Setting up existing superblocks.
[   17.311497] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   17.311505] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[   17.311691] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[   17.311699] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   17.311714] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   17.311739] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[   17.311745] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[   17.311918] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[   17.311925] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[   17.311930] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[   17.311953] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[   17.311961] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   17.311969] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[   17.311983] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[   17.311991] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   17.311999] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[   17.312005] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   17.312263] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   17.313100] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   17.313112] SELinux: initialized (dev sda2, type ext4), uses xattr
[   17.315939] type=1403 audit(1279829177.959:3): policy loaded auid=4294967295 ses=4294967295
[   17.433981] dracut: Switching root
[   18.635793] readahead: starting
[   20.683517] udev: starting version 151
[   20.991192] type=1400 audit(1279829181.636:4): avc:  denied  { mmap_zero } for  pid=555 comm="vbetool" scontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023 tcontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023 tclass=memprotect
[   22.113041] input: PC Speaker as /devices/platform/pcspkr/input/input7
[   22.137069] ACPI: WMI: Mapper loaded
[   22.140259] iTCO_vendor_support: vendor-support=0
[   22.238832] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   22.271345] Linux video capture interface: v2.00
[   22.274703] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[   22.275235] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x0460)
[   22.276565] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   22.288885] uvcvideo: Found UVC 1.00 device WebCam (064e:a102)
[   22.305847] input: WebCam as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5:1.0/input/input8
[   22.306169] usbcore: registered new interface driver uvcvideo
[   22.306172] USB Video Class driver (v0.1.0)
[   22.418896] cfg80211: Calling CRDA to update world regulatory domain
[   22.878024] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   22.878098] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[   22.878120] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   22.907173] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[   22.907176] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   22.907297] iwlagn 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   22.907335] iwlagn 0000:02:00.0: setting latency timer to 64
[   22.907413] iwlagn 0000:02:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   22.935709] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   22.935890] iwlagn 0000:02:00.0: irq 45 for MSI/MSI-X
[   22.991586] iwlagn 0000:02:00.0: loaded firmware version 8.24.2.12
[   23.016881] ALSA sound/pci/hda/patch_realtek.c:1308: SKU: Nid=0x1d sku_cfg=0x4015812d
[   23.016887] ALSA sound/pci/hda/patch_realtek.c:1310: SKU: port_connectivity=0x1
[   23.016891] ALSA sound/pci/hda/patch_realtek.c:1311: SKU: enable_pcbeep=0x1
[   23.016894] ALSA sound/pci/hda/patch_realtek.c:1312: SKU: check_sum=0x00000005
[   23.016898] ALSA sound/pci/hda/patch_realtek.c:1313: SKU: customization=0x00000081
[   23.016902] ALSA sound/pci/hda/patch_realtek.c:1314: SKU: external_amp=0x5
[   23.016905] ALSA sound/pci/hda/patch_realtek.c:1315: SKU: platform_type=0x1
[   23.016908] ALSA sound/pci/hda/patch_realtek.c:1316: SKU: swap=0x0
[   23.016911] ALSA sound/pci/hda/patch_realtek.c:1317: SKU: override=0x1
[   23.017054] hda_codec: ALC269: BIOS auto-probing.
[   23.017059] ALSA sound/pci/hda/hda_codec.c:4435: autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0)
[   23.017064] ALSA sound/pci/hda/hda_codec.c:4439:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   23.017069] ALSA sound/pci/hda/hda_codec.c:4443:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[   23.017073] ALSA sound/pci/hda/hda_codec.c:4444:    mono: mono_out=0x0
[   23.017076] ALSA sound/pci/hda/hda_codec.c:4447:    dig-out=0x1e/0x0
[   23.017080] ALSA sound/pci/hda/hda_codec.c:4455:    inputs: mic=0x18, fmic=0x12, line=0x0, fline=0x0, cd=0x0, aux=0x0
[   23.017526] ALSA sound/pci/hda/patch_realtek.c:1358: realtek: No valid SSID, checking pincfg 0x4015812d for NID 0x1d
[   23.017531] ALSA sound/pci/hda/patch_realtek.c:1374: realtek: Enabling init ASM_ID=0x812d CODEC_ID=10ec0269
[   23.018370] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
[   23.366072] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   23.548078] cfg80211: World regulatory domain updated:
[   23.548082]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   23.548086]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   23.548090]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   23.548093]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   23.548096]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   23.548100]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   23.705782] cfg80211: Calling CRDA for country: DE
[   23.708569] cfg80211: Regulatory domain changed to country: DE
[   23.708573]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   23.708577]     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   23.708580]     (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   23.708584]     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[   29.133636] EXT4-fs (sda2): re-mounted. Opts: data=writeback
[   29.598670] EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
[   29.599078] SELinux: initialized (dev sda1, type ext2), uses xattr
[   29.668155] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[   29.668164] SELinux: initialized (dev dm-0, type ext4), uses xattr
[   31.435172] Adding 2007604k swap on /dev/mapper/luks-swap.  Priority:-1 extents:1 across:2007604k 
[   31.438102] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   32.006119] NET: Registered protocol family 10
[   32.006286] lo: Disabled Privacy Extensions
[   32.035720] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   34.715637] atl1c 0000:01:00.0: irq 46 for MSI/MSI-X
[   34.716408] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   34.903020] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   52.216411] fuse init (API version 7.14)
[   52.276422] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[   76.961665] wlan0: direct probe to 00:23:08:1d:f2:bb (try 1)
[   77.160396] wlan0: direct probe to 00:23:08:1d:f2:bb (try 2)
[   77.360117] wlan0: direct probe to 00:23:08:1d:f2:bb (try 3)
[   77.560020] wlan0: direct probe to 00:23:08:1d:f2:bb timed out
[  103.222399] wlan0: direct probe to 00:23:08:1d:f2:bb (try 1)
[  103.420020] wlan0: direct probe to 00:23:08:1d:f2:bb (try 2)
[  103.620025] wlan0: direct probe to 00:23:08:1d:f2:bb (try 3)
[  103.820023] wlan0: direct probe to 00:23:08:1d:f2:bb timed out
[  125.909205] wlan0: direct probe to 00:23:08:1d:f2:bb (try 1)
[  126.106779] wlan0: direct probe to 00:23:08:1d:f2:bb (try 2)
[  126.306789] wlan0: direct probe to 00:23:08:1d:f2:bb (try 3)
[  126.506767] wlan0: direct probe to 00:23:08:1d:f2:bb timed out
[  134.265647] atl1c 0000:01:00.0: irq 46 for MSI/MSI-X
[  134.266933] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  134.305222] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  134.789041] wlan0: direct probe to 00:23:08:1d:f2:bb (try 1)
[  134.986710] wlan0: direct probe to 00:23:08:1d:f2:bb (try 2)
[  135.186698] wlan0: direct probe to 00:23:08:1d:f2:bb (try 3)
[  135.386715] wlan0: direct probe to 00:23:08:1d:f2:bb timed out
[  157.336807] wlan0: authenticate with 00:23:08:1d:f2:bb (try 1)
[  157.536918] wlan0: authenticate with 00:23:08:1d:f2:bb (try 2)
[  157.560946] wlan0: authenticated
[  157.564656] wlan0: associate with 00:23:08:1d:f2:bb (try 1)
[  157.763384] wlan0: associate with 00:23:08:1d:f2:bb (try 2)
[  157.797560] wlan0: RX AssocResp from 00:23:08:1d:f2:bb (capab=0x431 status=0 aid=1)
[  157.797569] wlan0: associated
[  157.800320] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  168.030010] wlan0: no IPv6 routers present
[  224.316225] wlan0: deauthenticating from 00:23:08:1d:f2:bb by local choice (reason=3)
[  224.326762] cfg80211: Calling CRDA to update world regulatory domain
[  224.326783] cfg80211: Calling CRDA for country: DE
[  224.363955] cfg80211: Regulatory domain changed to country: DE
[  224.363959]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  224.363963]     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  224.363967]     (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  224.363970]     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[  225.171396] PM: Syncing filesystems ... done.
[  225.254851] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  225.266752] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  225.280105] Suspending console(s) (use no_console_suspend to debug)
[  225.280431] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  225.280559] sd 0:0:0:0: [sda] Stopping disk
[  225.330580] atl1c 0000:01:00.0: PCI INT A disabled
[  225.330850] uhci_hcd 0000:00:1d.2: PCI INT D disabled
[  225.330861] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  225.330871] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  225.330933] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  225.330978] ACPI handle has no context!
[  225.331006] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[  225.331017] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  225.331077] IMA: unmeasured files on fsmagic: 1021994
[  225.331080] ima_dec_counts: open/free imbalance (r:0 w:-1 o:-1)
[  225.331084] Pid: 2375, comm: async/10 Tainted: G          I 2.6.35-rc6 #112
[  225.331087] Call Trace:
[  225.331095]  [<c0894a76>] ? printk+0x1d/0x1f
[  225.331102]  [<c05fedbf>] ima_file_free+0x16f/0x220
[  225.331106]  [<c04da652>] fput+0x112/0x210
[  225.331112]  [<c06d5fff>] drm_gem_object_release+0x1f/0x40
[  225.331118]  [<c06f4cc0>] i915_gem_free_object+0x60/0x100
[  225.331122]  [<c06d5f30>] ? drm_gem_object_free+0x0/0x40
[  225.331126]  [<c06d5f55>] drm_gem_object_free+0x25/0x40
[  225.331131]  [<c062422c>] kref_put+0x2c/0x60
[  225.331136]  [<c070fbc3>] intel_cleanup_ring_buffer+0x43/0x60
[  225.331141]  [<c06f2e22>] i915_gem_cleanup_ringbuffer+0x22/0x70
[  225.331145]  [<c06f4a62>] i915_gem_idle+0xa2/0x130
[  225.331150]  [<c06e767d>] i915_drm_freeze+0x3d/0xb0
[  225.331154]  [<c06e785e>] i915_pm_suspend+0x2e/0x80
[  225.331158]  [<c089518a>] ? wait_for_common+0x1a/0xf0
[  225.331163]  [<c042825f>] ? check_preempt_wakeup+0xef/0x170
[  225.331167]  [<c063d399>] pci_pm_suspend+0x49/0x110
[  225.331171]  [<c063d350>] ? pci_pm_suspend+0x0/0x110
[  225.331176]  [<c07251b1>] pm_op+0x181/0x1d0
[  225.331181]  [<c071dde4>] ? device_for_each_child+0x54/0x60
[  225.331186]  [<c0725b9f>] __device_suspend+0xbf/0x110
[  225.331190]  [<c0725fe3>] async_suspend+0x23/0x60
[  225.331194]  [<c044fbf5>] async_thread+0xc5/0x210
[  225.331198]  [<c0894da1>] ? schedule+0x1a1/0x420
[  225.331203]  [<c042d6c0>] ? default_wake_function+0x0/0x20
[  225.331207]  [<c044fb30>] ? async_thread+0x0/0x210
[  225.331211]  [<c0449504>] kthread+0x74/0x80
[  225.331214]  [<c0449490>] ? kthread+0x0/0x80
[  225.331219]  [<c040347e>] kernel_thread_helper+0x6/0x10
[  225.336657] iint_free: writecount: -1
[  225.336659] iint_free: opencount: -1
[  225.336661] iint_free: writecount: -1
[  225.336663] iint_free: opencount: -1
[  225.336666] iint_free: writecount: -1
[  225.336668] iint_free: opencount: -1
[  225.336670] iint_free: writecount: -1
[  225.336672] iint_free: opencount: -1
[  225.343380] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  226.040002] PM: suspend of devices complete after 759.768 msecs
[  226.066721] PM: late suspend of devices complete after 26.713 msecs
[  226.067315] ACPI: Preparing to enter system sleep state S3
[  226.067449] PM: Saving platform NVS memory
[  226.073316] Back to C!
[  226.073316] PM: Restoring platform NVS memory
[  226.073316] ACPI: Waking up from system sleep state S3
[  226.178461] i915 0000:00:02.0: restoring config space at offset 0x6 (was 0xc, writing 0x8000000c)
[  226.178469] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
[  226.178529] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  226.178579] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[  226.178632] HDA Intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0x4, writing 0x94500004)
[  226.178638] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  226.178646] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100002)
[  226.178679] pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
[  226.178693] pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0x91319041)
[  226.178699] pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0x94409350)
[  226.178705] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20000000, writing 0x2020)
[  226.178716] pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  226.178723] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  226.178773] pcieport 0000:00:1c.3: restoring config space at offset 0xf (was 0x400, writing 0x4ff)
[  226.178787] pcieport 0000:00:1c.3: restoring config space at offset 0x9 (was 0x10001, writing 0x92319141)
[  226.178793] pcieport 0000:00:1c.3: restoring config space at offset 0x8 (was 0x0, writing 0x93409250)
[  226.178799] pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20000000, writing 0x1010)
[  226.178810] pcieport 0000:00:1c.3: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  226.178818] pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  226.178881] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  226.178923] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  226.178964] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  226.179013] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[  226.179048] pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[  226.179055] pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xfff0)
[  226.179061] pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x22800000, writing 0x228000f0)
[  226.179075] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  226.179173] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[  226.179261] atl1c 0000:01:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  226.179296] atl1c 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  226.179360] iwlagn 0000:02:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  226.179397] iwlagn 0000:02:00.0: restoring config space at offset 0x4 (was 0x4, writing 0x92500004)
[  226.179412] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
[  226.179511] PM: early resume of devices complete after 1.090 msecs
[  226.209235] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  226.209244] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  226.209272] usb usb3: root hub lost power or was reset
[  226.209295] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[  226.209302] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[  226.209332] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[  226.209339] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  226.209383] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[  226.209414] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  226.209421] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  226.209447] usb usb4: root hub lost power or was reset
[  226.209468] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  226.209475] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  226.209501] usb usb5: root hub lost power or was reset
[  226.209521] uhci_hcd 0000:00:1d.2: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[  226.209528] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  226.209554] usb usb6: root hub lost power or was reset
[  226.209574] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  226.209581] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  226.209628] pci 0000:00:1e.0: setting latency timer to 64
[  226.209641] ahci 0000:00:1f.2: setting latency timer to 64
[  226.209747] sd 0:0:0:0: [sda] Starting disk
[  226.210028] i915 0000:00:02.0: setting latency timer to 64
[  226.443411] usb 2-5: reset high speed USB device using ehci_hcd and address 2
[  226.533416] ata2: SATA link down (SStatus 0 SControl 300)
[  226.540083] ata6: SATA link down (SStatus 0 SControl 300)
[  226.546745] ata5: SATA link down (SStatus 0 SControl 300)
[  227.646746] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  227.648582] ata1.00: configured for UDMA/100
[  227.673192] PM: resume of devices complete after 1493.577 msecs
[  227.673294] Restarting tasks ... done.
[  227.673505] video LNXVIDEO:00: Restoring backlight state
[  228.407602] atl1c 0000:01:00.0: irq 46 for MSI/MSI-X
[  228.408304] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  228.447424] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  268.869026] PM: Syncing filesystems ... done.
[  268.941577] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  268.953412] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  268.966765] Suspending console(s) (use no_console_suspend to debug)
[  268.967089] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  268.967216] sd 0:0:0:0: [sda] Stopping disk
[  269.018015] uhci_hcd 0000:00:1d.2: PCI INT D disabled
[  269.018026] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  269.018036] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  269.018084] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  269.018131] ACPI handle has no context!
[  269.018158] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[  269.018169] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  269.030039] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  269.713332] PM: suspend of devices complete after 746.443 msecs
[  269.740050] PM: late suspend of devices complete after 26.712 msecs
[  269.740643] ACPI: Preparing to enter system sleep state S3
[  269.740779] PM: Saving platform NVS memory
[  269.746645] Back to C!
[  269.746645] PM: Restoring platform NVS memory
[  269.750035] ACPI: Waking up from system sleep state S3
[  269.865020] i915 0000:00:02.0: restoring config space at offset 0x6 (was 0xc, writing 0x8000000c)
[  269.865028] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
[  269.865088] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  269.865139] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[  269.865192] HDA Intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0x4, writing 0x94500004)
[  269.865198] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  269.865206] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100002)
[  269.865239] pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
[  269.865253] pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0x91319041)
[  269.865259] pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0x94409350)
[  269.865265] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20000000, writing 0x20002020)
[  269.865276] pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  269.865284] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  269.865334] pcieport 0000:00:1c.3: restoring config space at offset 0xf (was 0x400, writing 0x4ff)
[  269.865347] pcieport 0000:00:1c.3: restoring config space at offset 0x9 (was 0x10001, writing 0x92319141)
[  269.865354] pcieport 0000:00:1c.3: restoring config space at offset 0x8 (was 0x0, writing 0x93409250)
[  269.865360] pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20000000, writing 0x20001010)
[  269.865371] pcieport 0000:00:1c.3: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  269.865379] pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  269.865442] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  269.865484] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  269.865525] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  269.865574] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[  269.865610] pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[  269.865616] pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xfff0)
[  269.865622] pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x22800000, writing 0x228000f0)
[  269.865636] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  269.865734] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[  269.865823] atl1c 0000:01:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  269.865859] atl1c 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  269.865923] iwlagn 0000:02:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  269.865960] iwlagn 0000:02:00.0: restoring config space at offset 0x4 (was 0x4, writing 0x92500004)
[  269.865975] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100406)
[  269.866071] PM: early resume of devices complete after 1.091 msecs
[  269.895626] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  269.895635] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  269.895662] usb usb3: root hub lost power or was reset
[  269.895685] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[  269.895692] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[  269.895721] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[  269.895728] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  269.895773] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[  269.895804] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  269.895811] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  269.895838] usb usb4: root hub lost power or was reset
[  269.895859] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  269.895866] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  269.895892] usb usb5: root hub lost power or was reset
[  269.895913] uhci_hcd 0000:00:1d.2: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[  269.895920] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  269.895946] usb usb6: root hub lost power or was reset
[  269.895967] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  269.895974] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  269.896021] pci 0000:00:1e.0: setting latency timer to 64
[  269.896034] ahci 0000:00:1f.2: setting latency timer to 64
[  269.896140] sd 0:0:0:0: [sda] Starting disk
[  269.896466] i915 0000:00:02.0: setting latency timer to 64
[  270.130071] usb 2-5: reset high speed USB device using ehci_hcd and address 2
[  270.220077] ata2: SATA link down (SStatus 0 SControl 300)
[  270.226743] ata6: SATA link down (SStatus 0 SControl 300)
[  270.233407] ata5: SATA link down (SStatus 0 SControl 300)
[  271.226741] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  271.228628] ata1.00: configured for UDMA/100
[  271.254343] PM: resume of devices complete after 1388.206 msecs
[  271.254435] Restarting tasks ... done.
[  271.254618] video LNXVIDEO:00: Restoring backlight state
[  271.775772] atl1c 0000:01:00.0: irq 46 for MSI/MSI-X
[  271.776511] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  271.821403] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  287.017515] PM: Syncing filesystems ... done.
[  287.088280] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  287.100077] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  287.113431] Suspending console(s) (use no_console_suspend to debug)
[  287.113762] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  287.113885] sd 0:0:0:0: [sda] Stopping disk
[  287.163995] uhci_hcd 0000:00:1d.2: PCI INT D disabled
[  287.164006] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  287.164015] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  287.164063] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  287.164108] ACPI handle has no context!
[  287.164136] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[  287.164146] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  287.176704] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  287.859997] PM: suspend of devices complete after 746.442 msecs
[  287.886714] PM: late suspend of devices complete after 26.712 msecs
[  287.887308] ACPI: Preparing to enter system sleep state S3
[  287.887441] PM: Saving platform NVS memory
[  287.893310] Back to C!
[  287.893310] PM: Restoring platform NVS memory
[  287.896915] ACPI: Waking up from system sleep state S3
[  288.001687] i915 0000:00:02.0: restoring config space at offset 0x6 (was 0xc, writing 0x8000000c)
[  288.001695] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
[  288.001755] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  288.001805] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[  288.001858] HDA Intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0x4, writing 0x94500004)
[  288.001864] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  288.001872] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100002)
[  288.001905] pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
[  288.001919] pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0x91319041)
[  288.001925] pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0x94409350)
[  288.001931] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20000000, writing 0x2020)
[  288.001942] pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  288.001950] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  288.002000] pcieport 0000:00:1c.3: restoring config space at offset 0xf (was 0x400, writing 0x4ff)
[  288.002013] pcieport 0000:00:1c.3: restoring config space at offset 0x9 (was 0x10001, writing 0x92319141)
[  288.002020] pcieport 0000:00:1c.3: restoring config space at offset 0x8 (was 0x0, writing 0x93409250)
[  288.002027] pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20000000, writing 0x1010)
[  288.002037] pcieport 0000:00:1c.3: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  288.002045] pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  288.002109] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  288.002151] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  288.002192] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  288.002241] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[  288.002276] pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[  288.002282] pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xfff0)
[  288.002289] pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x22800000, writing 0x228000f0)
[  288.002302] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  288.002401] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[  288.002490] atl1c 0000:01:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  288.002525] atl1c 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  288.002589] iwlagn 0000:02:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  288.002626] iwlagn 0000:02:00.0: restoring config space at offset 0x4 (was 0x4, writing 0x92500004)
[  288.002641] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100406)
[  288.002737] PM: early resume of devices complete after 1.091 msecs
[  288.032296] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  288.032305] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  288.032332] usb usb3: root hub lost power or was reset
[  288.032355] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[  288.032362] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[  288.032392] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[  288.032400] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  288.032445] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[  288.032475] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  288.032482] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  288.032508] usb usb4: root hub lost power or was reset
[  288.032529] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  288.032536] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  288.032563] usb usb5: root hub lost power or was reset
[  288.032583] uhci_hcd 0000:00:1d.2: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[  288.032590] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  288.032616] usb usb6: root hub lost power or was reset
[  288.032637] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  288.032644] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  288.032691] pci 0000:00:1e.0: setting latency timer to 64
[  288.032704] ahci 0000:00:1f.2: setting latency timer to 64
[  288.032811] sd 0:0:0:0: [sda] Starting disk
[  288.033099] i915 0000:00:02.0: setting latency timer to 64
[  288.266739] usb 2-5: reset high speed USB device using ehci_hcd and address 2
[  288.356740] ata2: SATA link down (SStatus 0 SControl 300)
[  288.363405] ata6: SATA link down (SStatus 0 SControl 300)
[  288.370073] ata5: SATA link down (SStatus 0 SControl 300)
[  289.256737] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  289.258606] ata1.00: configured for UDMA/100
[  289.284981] PM: resume of devices complete after 1282.172 msecs
[  289.285070] Restarting tasks ... done.
[  289.285258] video LNXVIDEO:00: Restoring backlight state
[  289.799452] atl1c 0000:01:00.0: irq 46 for MSI/MSI-X
[  289.800221] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  289.843392] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  300.299834] PM: Syncing filesystems ... done.
[  300.371490] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  300.383410] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  300.396766] Suspending console(s) (use no_console_suspend to debug)
[  300.397198] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  300.397331] sd 0:0:0:0: [sda] Stopping disk
[  300.447301] uhci_hcd 0000:00:1d.2: PCI INT D disabled
[  300.447311] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  300.447321] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  300.447375] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  300.447420] ACPI handle has no context!
[  300.447453] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[  300.447464] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  300.460035] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  301.143328] PM: suspend of devices complete after 746.432 msecs
[  301.170046] PM: late suspend of devices complete after 26.713 msecs
[  301.170642] ACPI: Preparing to enter system sleep state S3
[  301.170777] PM: Saving platform NVS memory
[  301.176642] Back to C!
[  301.176642] PM: Restoring platform NVS memory
[  301.180498] ACPI: Waking up from system sleep state S3
[  301.285017] i915 0000:00:02.0: restoring config space at offset 0x6 (was 0xc, writing 0x8000000c)
[  301.285025] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
[  301.285085] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  301.285134] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[  301.285187] HDA Intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0x4, writing 0x94500004)
[  301.285193] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  301.285201] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100002)
[  301.285235] pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
[  301.285248] pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0x91319041)
[  301.285255] pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0x94409350)
[  301.285261] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20000000, writing 0x20002020)
[  301.285272] pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  301.285280] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  301.285330] pcieport 0000:00:1c.3: restoring config space at offset 0xf (was 0x400, writing 0x4ff)
[  301.285344] pcieport 0000:00:1c.3: restoring config space at offset 0x9 (was 0x10001, writing 0x92319141)
[  301.285350] pcieport 0000:00:1c.3: restoring config space at offset 0x8 (was 0x0, writing 0x93409250)
[  301.285357] pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20000000, writing 0x20001010)
[  301.285367] pcieport 0000:00:1c.3: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  301.285375] pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  301.285439] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  301.285480] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  301.285522] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  301.285571] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[  301.285606] pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[  301.285613] pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xfff0)
[  301.285619] pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x22800000, writing 0x228000f0)
[  301.285632] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  301.285730] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[  301.285818] atl1c 0000:01:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  301.285853] atl1c 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  301.285917] iwlagn 0000:02:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  301.285954] iwlagn 0000:02:00.0: restoring config space at offset 0x4 (was 0x4, writing 0x92500004)
[  301.285969] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100406)
[  301.286066] PM: early resume of devices complete after 1.090 msecs
[  301.315622] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  301.315631] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  301.315659] usb usb3: root hub lost power or was reset
[  301.315681] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[  301.315688] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[  301.315718] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[  301.315725] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  301.315770] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[  301.315800] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  301.315807] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  301.315833] usb usb4: root hub lost power or was reset
[  301.315854] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  301.315861] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  301.315887] usb usb5: root hub lost power or was reset
[  301.315907] uhci_hcd 0000:00:1d.2: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[  301.315914] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  301.315940] usb usb6: root hub lost power or was reset
[  301.315961] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  301.315968] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  301.316015] pci 0000:00:1e.0: setting latency timer to 64
[  301.316028] ahci 0000:00:1f.2: setting latency timer to 64
[  301.316134] sd 0:0:0:0: [sda] Starting disk
[  301.316460] i915 0000:00:02.0: setting latency timer to 64
[  301.550070] usb 2-5: reset high speed USB device using ehci_hcd and address 2
[  301.640075] ata2: SATA link down (SStatus 0 SControl 300)
[  301.646736] ata6: SATA link down (SStatus 0 SControl 300)
[  301.653404] ata5: SATA link down (SStatus 0 SControl 300)
[  302.806740] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  302.808624] ata1.00: configured for UDMA/100
[  302.837860] PM: resume of devices complete after 1551.727 msecs
[  302.837952] Restarting tasks ... done.
[  302.838141] video LNXVIDEO:00: Restoring backlight state
[  303.447606] atl1c 0000:01:00.0: irq 46 for MSI/MSI-X
[  303.448198] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  303.496727] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  303.821175] wlan0: direct probe to 00:23:08:1d:f2:bb (try 1)
[  304.019994] wlan0: direct probe to 00:23:08:1d:f2:bb (try 2)
[  304.220075] wlan0: direct probe to 00:23:08:1d:f2:bb (try 3)
[  304.421230] wlan0: direct probe to 00:23:08:1d:f2:bb timed out
[  326.383644] wlan0: authenticate with 00:23:08:1d:f2:bb (try 1)
[  326.386757] wlan0: authenticated
[  326.386796] wlan0: associate with 00:23:08:1d:f2:bb (try 1)
[  326.411569] wlan0: RX AssocResp from 00:23:08:1d:f2:bb (capab=0x431 status=0 aid=1)
[  326.411577] wlan0: associated
[  326.415820] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  337.336863] wlan0: no IPv6 routers present


