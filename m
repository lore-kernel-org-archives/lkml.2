Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0DSTbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:31:13 -0400
Received: from ns.unixsol.org ([193.110.159.2]:49761 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab0DSTbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:31:10 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2010 15:31:09 EDT
Message-ID: <4BCCAE49.4020105@unixsol.org>
Date: Mon, 19 Apr 2010 22:26:01 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
Organization: Unix Solutions Ltd.
User-Agent: Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10.4; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.31.6 - swapper: page allocation failure. order:3, mode:0x4020
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This morning I have found this in the logs, and couple of processes that
multicast video were hanging. The machine have plenty of swap, so can
somebody give me a hint if there is something I can do to avoid the
following errors:

[11935.628090] swapper: page allocation failure. order:3, mode:0x4020
[11935.628330] Pid: 0, comm: swapper Not tainted 2.6.31.6 #6
[11935.628562] Call Trace:
[11935.628796]  <IRQ>  [<ffffffff810a1505>] __alloc_pages_nodemask+0x537/0x57e
[11935.629042]  [<ffffffff8103a45e>] ? try_to_wake_up+0x2b0/0x2c2
[11935.629285]  [<ffffffff810dc7b0>] ? pollwake+0x57/0x5b
[11935.629513]  [<ffffffff810c816d>] kmalloc_large_node+0x5d/0x9a
[11935.629741]  [<ffffffff810c8eac>] __kmalloc_node_track_caller+0x2d/0xed
[11935.629968]  [<ffffffff814085af>] ? igmpv3_newpack+0x46/0x1c4
[11935.630217]  [<ffffffff813bf417>] __alloc_skb+0x6f/0x168
[11935.630440]  [<ffffffff813ba7b2>] ? sock_def_readable+0x42/0x6f
[11935.630666]  [<ffffffff814085af>] igmpv3_newpack+0x46/0x1c4
[11935.630900]  [<ffffffff81056cfc>] ? ktime_get_ts+0x49/0x4e
[11935.631129]  [<ffffffff81056d12>] ? ktime_get+0x11/0x42
[11935.631358]  [<ffffffff8140875a>] add_grhead+0x2d/0x81
[11935.631585]  [<ffffffff81408c21>] ? igmp_ifc_timer_expire+0x0/0x272
[11935.631824]  [<ffffffff81408b03>] add_grec+0x355/0x38a
[11935.632060]  [<ffffffff8101db0c>] ? lapic_next_event+0x18/0x1c
[11935.632300]  [<ffffffff8105eb79>] ? tick_dev_program_event+0x37/0xa5
[11935.632524]  [<ffffffff81408c21>] ? igmp_ifc_timer_expire+0x0/0x272
[11935.632756]  [<ffffffff81408cd1>] igmp_ifc_timer_expire+0xb0/0x272
[11935.632980]  [<ffffffff81408c21>] ? igmp_ifc_timer_expire+0x0/0x272
[11935.633225]  [<ffffffff81048b74>] run_timer_softirq+0x193/0x208
[11935.633451]  [<ffffffff81044796>] __do_softirq+0xd1/0x195
[11935.633674]  [<ffffffff8100cbdc>] call_softirq+0x1c/0x28
[11935.633901]  [<ffffffff8100e04c>] do_softirq+0x34/0x72
[11935.634139]  [<ffffffff810444df>] irq_exit+0x3f/0x7e
[11935.634361]  [<ffffffff8100d74d>] do_IRQ+0xa3/0xba
[11935.634592]  [<ffffffff8100c453>] ret_from_intr+0x0/0xa
[11935.634827]  <EOI>  [<ffffffff812b1573>] ? acpi_idle_enter_simple+0x101/0x12f
[11935.635076]  [<ffffffff812b1569>] ? acpi_idle_enter_simple+0xf7/0x12f
[11935.635314]  [<ffffffff813a47c2>] ? cpuidle_idle_call+0x92/0xcc
[11935.635540]  [<ffffffff8100ae16>] ? cpu_idle+0x52/0x93
[11935.635774]  [<ffffffff8144c641>] ? start_secondary+0x179/0x17e
[11935.636005] Mem-Info:
[11935.636239] Node 0 DMA per-cpu:
[11935.636466] CPU    0: hi:    0, btch:   1 usd:   0
[11935.636705] CPU    1: hi:    0, btch:   1 usd:   0
[11935.636929] CPU    2: hi:    0, btch:   1 usd:   0
[11935.637173] CPU    3: hi:    0, btch:   1 usd:   0
[11935.637403] Node 0 DMA32 per-cpu:
[11935.637630] CPU    0: hi:  186, btch:  31 usd: 119
[11935.637858] CPU    1: hi:  186, btch:  31 usd:  50
[11935.638097] CPU    2: hi:  186, btch:  31 usd: 170
[11935.638326] CPU    3: hi:  186, btch:  31 usd: 122
[11935.638563] Active_anon:204900 active_file:55608 inactive_anon:69022
[11935.638565]  inactive_file:160938 unevictable:0 dirty:1143 writeback:0 unstable:0
[11935.638566]  free:3925 slab:13219 mapped:1058 pagetables:1271 bounce:0
[11935.645747] Node 0 DMA free:8020kB min:40kB low:48kB high:60kB active_anon:904kB inactive_anon:1016kB active_file:3852kB inactive_file:2092kB unevictable:0kB present:15344kB pages_scanned:0 all_unreclaimable? no
[11935.645754] lowmem_reserve[]: 0 1998 1998 1998
[11935.645758] Node 0 DMA32 free:7680kB min:5696kB low:7120kB high:8544kB active_anon:818696kB inactive_anon:275072kB active_file:218580kB inactive_file:641660kB unevictable:0kB present:2046728kB pages_scanned:0 all_unreclaimable? no
[11935.645764] lowmem_reserve[]: 0 0 0 0
[11935.645769] Node 0 DMA: 1*4kB 2*8kB 2*16kB 3*32kB 3*64kB 2*128kB 3*256kB 3*512kB 3*1024kB 1*2048kB 0*4096kB = 8020kB
[11935.645777] Node 0 DMA32: 1660*4kB 2*8kB 0*16kB 4*32kB 2*64kB 2*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 7680kB
[11935.645785] 216703 total pagecache pages
[11935.645787] 0 pages in swap cache
[11935.645788] Swap cache stats: add 0, delete 0, find 0/0
[11935.645790] Free swap  = 2047984kB
[11935.645792] Total swap = 2047984kB
[11935.658121] 523264 pages RAM
[11935.658356] 9885 pages reserved
[11935.658579] 78158 pages shared
[11935.658801] 441578 pages non-shared


Full dmesg, /proc/meminfo and /proc/cpuinfo are bellow:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31.6 (root@shifter) (gcc version 4.3.3 (GCC) ) #6 SMP Wed Dec 2 00:17:50 EET 2009
[    0.000000] Command line: auto BOOT_IMAGE=Linux ro root=900 scsihosts=ahci:3w-9xxx
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
[    0.000000]  BIOS-e820: 000000000009e400 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007e296000 (usable)
[    0.000000]  BIOS-e820: 000000007e296000 - 000000007e34d000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007e34d000 - 000000007fa32000 (usable)
[    0.000000]  BIOS-e820: 000000007fa32000 - 000000007fa9a000 (reserved)
[    0.000000]  BIOS-e820: 000000007fa9a000 - 000000007fac9000 (usable)
[    0.000000]  BIOS-e820: 000000007fac9000 - 000000007fb1a000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fb1a000 - 000000007fb26000 (usable)
[    0.000000]  BIOS-e820: 000000007fb26000 - 000000007fb3a000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007fb3a000 - 000000007fc00000 (usable)
[    0.000000]  BIOS-e820: 000000007fc00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 00000000ffe0c000 (reserved)
[    0.000000] DMI 2.5 present.
[    0.000000] last_pfn = 0x7fc00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07FC00000 mask FFFC00000 uncachable
[    0.000000]   2 base 100000000 mask F00000000 write-back
[    0.000000]   3 base 200000000 mask E00000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 000000007fc00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009e400 (usable)
[    0.000000]  modified: 000000000009e400 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007e296000 (usable)
[    0.000000]  modified: 000000007e296000 - 000000007e34d000 (ACPI NVS)
[    0.000000]  modified: 000000007e34d000 - 000000007fa32000 (usable)
[    0.000000]  modified: 000000007fa32000 - 000000007fa9a000 (reserved)
[    0.000000]  modified: 000000007fa9a000 - 000000007fac9000 (usable)
[    0.000000]  modified: 000000007fac9000 - 000000007fb1a000 (ACPI NVS)
[    0.000000]  modified: 000000007fb1a000 - 000000007fb26000 (usable)
[    0.000000]  modified: 000000007fb26000 - 000000007fb3a000 (ACPI data)
[    0.000000]  modified: 000000007fb3a000 - 000000007fc00000 (usable)
[    0.000000]  modified: 000000007fc00000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 00000000ffe0c000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007fc00000
[    0.000000]  0000000000 - 007fc00000 page 2M
[    0.000000] kernel direct mapping tables up to 7fc00000 @ 8000-b000
[    0.000000] ACPI: RSDP 00000000000f03f0 00024 (v02 INTEL )
[    0.000000] ACPI: XSDT 000000007fb39120 00084 (v01 INTEL  S5000PSL 00000000 INTL 01000013)
[    0.000000] ACPI: FACP 000000007fb37000 000F4 (v03 INTEL  S5000PSL 00000000 INTL 01000013)
[    0.000000] ACPI: DSDT 000000007fb30000 057F6 (v02 INTEL  S5000PSL 00000001 INTL 01000013)
[    0.000000] ACPI: FACS 000000007fac9000 00040
[    0.000000] ACPI: APIC 000000007fb36000 000C8 (v01 INTEL  S5000PSL 00000000 INTL 01000013)
[    0.000000] ACPI: SPCR 000000007fb2f000 00050 (v01 INTEL  S5000PSL 00000000 INTL 01000013)
[    0.000000] ACPI: HPET 000000007fb2e000 00038 (v01 INTEL  S5000PSL 00000001 INTL 01000013)
[    0.000000] ACPI: MCFG 000000007fb2d000 0003C (v01 INTEL  S5000PSL 00000001 INTL 01000013)
[    0.000000] ACPI: SSDT 000000007fb2c000 00A14 (v02  INTEL EIST     00004000 INTL 20060317)
[    0.000000] ACPI: SSDT 000000007fb2b000 00193 (v02  INTEL IPMI     00004000 INTL 20060317)
[    0.000000] ACPI: SSDT 000000007fb2a000 002D4 (v02  INTEL CST      00004000 INTL 20060317)
[    0.000000] ACPI: HEST 000000007fb29000 000A8 (v01 INTEL  S5000PSL 00000001 INTL 00000001)
[    0.000000] ACPI: BERT 000000007fb28000 00030 (v01 INTEL  S5000PSL 00000001 INTL 00000001)
[    0.000000] ACPI: ERST 000000007fb27000 00230 (v01 INTEL  S5000PSL 00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 000000007fb26000 00130 (v01 INTEL  S5000PSL 00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007fc00000
[    0.000000] Bootmem setup node 0 0000000000000000-000000007fc00000
[    0.000000]   NODE_DATA [0000000000009000 - 000000000000dfff]
[    0.000000]   bootmap [000000000000e000 -  000000000001df7f] pages 10
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 007fc00000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001828658]    TEXT DATA BSS ==> [0001000000 - 0001828658]
[    0.000000]   #3 [000009e400 - 0000100000]    BIOS reserved ==> [000009e400 - 0000100000]
[    0.000000]   #4 [0001829000 - 0001829264]              BRK ==> [0001829000 - 0001829264]
[    0.000000]   #5 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
[    0.000000] found SMP MP-table at [ffff8800000fd970] fd970
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880001e00000-ffff8800039fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0007e296
[    0.000000]     0: 0x0007e34d -> 0x0007fa32
[    0.000000]     0: 0x0007fa9a -> 0x0007fac9
[    0.000000]     0: 0x0007fb1a -> 0x0007fb26
[    0.000000]     0: 0x0007fb3a -> 0x0007fc00
[    0.000000] On node 0 totalpages: 522773
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 101 pages reserved
[    0.000000]   DMA zone: 3836 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7098 pages used for memmap
[    0.000000]   DMA32 zone: 511682 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x85] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x86] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x87] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 48
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages at ffff88000183a000, static data 82464 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 515518
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: auto BOOT_IMAGE=Linux ro root=900 scsihosts=ahci:3w-9xxx
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 2053016k/2093056k available (4446k kernel code, 1964k absent, 38076k reserved, 2481k data, 500k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:880
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1862.241 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 3724.48 BogoMIPS (lpj=1862241)
[    0.000999] Security Framework initialized
[    0.001016] SELinux:  Initializing.
[    0.001287] SELinux:  Starting in permissive mode
[    0.001498] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003240] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.004163] Mount-cache hash table entries: 256
[    0.004660] Initializing cgroup subsys ns
[    0.004927] Initializing cgroup subsys cpuacct
[    0.005007] Initializing cgroup subsys freezer
[    0.005292] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.005601] CPU: L2 cache: 4096K
[    0.006004] CPU 0/0x0 -> Node 0
[    0.006264] CPU: Physical Processor ID: 0
[    0.006525] CPU: Processor Core ID: 0
[    0.006788] mce: CPU supports 6 MCE banks
[    0.007009] CPU0: Thermal monitoring enabled (TM2)
[    0.007275] using mwait in idle threads.
[    0.007537] Performance Counters: Core2 events, Intel PMU driver.
[    0.008003] ... version:                 2
[    0.008267] ... bit width:               40
[    0.008531] ... generic counters:        2
[    0.008796] ... value mask:              000000ffffffffff
[    0.009001] ... max period:              000000007fffffff
[    0.009265] ... fixed-purpose counters:  3
[    0.009529] ... counter mask:            0000000700000003
[    0.009817] ACPI: Core revision 20090521
[    0.022103] Setting APIC routing to flat
[    0.023198] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.033473] CPU0: Intel(R) Xeon(R) CPU            5120  @ 1.86GHz stepping 06
[    0.033994] Booting processor 1 APIC 0x6 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 3723.87 BogoMIPS (lpj=1861938)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 4096K
[    0.000999] CPU 1/0x6 -> Node 0
[    0.000999] CPU: Physical Processor ID: 3
[    0.000999] CPU: Processor Core ID: 0
[    0.000999] mce: CPU supports 6 MCE banks
[    0.000999] CPU1: Thermal monitoring enabled (TM2)
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.105947] CPU1: Intel(R) Xeon(R) CPU            5120  @ 1.86GHz stepping 06
[    0.106302] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.107085] Booting processor 2 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#2
[    0.000999] Calibrating delay using timer specific routine.. 3723.87 BogoMIPS (lpj=1861935)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 4096K
[    0.000999] CPU 2/0x1 -> Node 0
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] mce: CPU supports 6 MCE banks
[    0.000999] CPU2: Thermal monitoring enabled (TM2)
[    0.000999] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.180960] CPU2: Intel(R) Xeon(R) CPU            5120  @ 1.86GHz stepping 06
[    0.181976] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.183134] Booting processor 3 APIC 0x7 ip 0x6000
[    0.000999] Initializing CPU#3
[    0.000999] Calibrating delay using timer specific routine.. 3723.86 BogoMIPS (lpj=1861934)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 4096K
[    0.000999] CPU 3/0x7 -> Node 0
[    0.000999] CPU: Physical Processor ID: 3
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] mce: CPU supports 6 MCE banks
[    0.000999] CPU3: Thermal monitoring enabled (TM2)
[    0.000999] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.255890] CPU3: Intel(R) Xeon(R) CPU            5120  @ 1.86GHz stepping 06
[    0.256964] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.257976] Brought up 4 CPUs
[    0.258240] Total of 4 processors activated (14896.09 BogoMIPS).
[    0.259076] khelper used greatest stack depth: 5936 bytes left
[    0.260130] xor: automatically using best checksumming function: generic_sse
[    0.264963]    generic_sse:  6792.000 MB/sec
[    0.265227] xor: using function: generic_sse (6792.000 MB/sec)
[    0.265548] NET: Registered protocol family 16
[    0.266051] ACPI: bus type pci registered
[    0.267010] PCI: Using configuration type 1 for base access
[    0.277001] bio: create slab <bio-0> at 0
[    0.278672] ACPI: EC: Look up EC in DSDT
[    0.281485] ACPI Warning: Package List length (6) larger than NumElements count (2), truncated
[    0.281960]  20090521 dsobject-502
[    0.282408] ACPI Warning: Package List length (6) larger than NumElements count (2), truncated
[    0.282960]  20090521 dsobject-502
[    0.283410] ACPI Warning: Package List length (6) larger than NumElements count (2), truncated
[    0.283959]  20090521 dsobject-502
[    0.284402] ACPI Warning: Package List length (6) larger than NumElements count (2), truncated
[    0.284959]  20090521 dsobject-502
[    0.291031] ACPI: Interpreter enabled
[    0.291293] ACPI: (supports S0 S5)
[    0.291654] ACPI: Using IOAPIC for interrupt routing
[    0.301585] ACPI: No dock devices found.
[    0.305461] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.305764] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.305958] pci 0000:00:00.0: PME# disabled
[    0.306279] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.306547] pci 0000:00:02.0: PME# disabled
[    0.307003] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.307271] pci 0000:00:03.0: PME# disabled
[    0.307577] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.307846] pci 0000:00:04.0: PME# disabled
[    0.307998] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.308266] pci 0000:00:05.0: PME# disabled
[    0.308572] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.308956] pci 0000:00:06.0: PME# disabled
[    0.309262] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.309530] pci 0000:00:07.0: PME# disabled
[    0.310159] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.310427] pci 0000:00:1c.0: PME# disabled
[    0.310742] pci 0000:00:1d.0: reg 20 io port: [0x40a0-0x40bf]
[    0.310793] pci 0000:00:1d.1: reg 20 io port: [0x4080-0x409f]
[    0.310844] pci 0000:00:1d.2: reg 20 io port: [0x4060-0x407f]
[    0.310899] pci 0000:00:1d.3: reg 20 io port: [0x4040-0x405f]
[    0.310960] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfac00400-0xfac007ff]
[    0.311013] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.311282] pci 0000:00:1d.7: PME# disabled
[    0.311675] pci 0000:00:1f.1: reg 10 io port: [0x40e8-0x40ef]
[    0.311682] pci 0000:00:1f.1: reg 14 io port: [0x40fc-0x40ff]
[    0.311689] pci 0000:00:1f.1: reg 18 io port: [0x40e0-0x40e7]
[    0.311696] pci 0000:00:1f.1: reg 1c io port: [0x40f8-0x40fb]
[    0.311703] pci 0000:00:1f.1: reg 20 io port: [0x40c0-0x40cf]
[    0.311752] pci 0000:00:1f.2: reg 10 io port: [0x40d8-0x40df]
[    0.311758] pci 0000:00:1f.2: reg 14 io port: [0x40f4-0x40f7]
[    0.311764] pci 0000:00:1f.2: reg 18 io port: [0x40d0-0x40d7]
[    0.311770] pci 0000:00:1f.2: reg 1c io port: [0x40f0-0x40f3]
[    0.311777] pci 0000:00:1f.2: reg 20 io port: [0x4020-0x403f]
[    0.311783] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfac00000-0xfac003ff]
[    0.311808] pci 0000:00:1f.2: PME# supported from D3hot
[    0.311956] pci 0000:00:1f.2: PME# disabled
[    0.312267] pci 0000:00:1f.3: reg 20 io port: [0x4000-0x401f]
[    0.314226] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.314547] pci 0000:01:00.0: PME# disabled
[    0.317154] pci 0000:01:00.3: PME# supported from D0 D3hot D3cold
[    0.317475] pci 0000:01:00.3: PME# disabled
[    0.318393] pci 0000:00:02.0: bridge io port: [0x3000-0x3fff]
[    0.318397] pci 0000:00:02.0: bridge 32bit mmio: [0xfa000000-0xfa9fffff]
[    0.320595] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.320915] pci 0000:02:00.0: PME# disabled
[    0.323687] pci 0000:02:02.0: PME# supported from D0 D3hot D3cold
[    0.324045] pci 0000:02:02.0: PME# disabled
[    0.326137] pci 0000:01:00.0: bridge io port: [0x3000-0x3fff]
[    0.326229] pci 0000:01:00.0: bridge 32bit mmio: [0xfa000000-0xfa8fffff]
[    0.329687] pci 0000:04:00.0: reg 10 32bit mmio: [0xfa820000-0xfa83ffff]
[    0.329871] pci 0000:04:00.0: reg 14 32bit mmio: [0xfa400000-0xfa7fffff]
[    0.330045] pci 0000:04:00.0: reg 18 io port: [0x3020-0x303f]
[    0.331733] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.332052] pci 0000:04:00.0: PME# disabled
[    0.333779] pci 0000:04:00.1: reg 10 32bit mmio: [0xfa800000-0xfa81ffff]
[    0.333962] pci 0000:04:00.1: reg 14 32bit mmio: [0xfa000000-0xfa3fffff]
[    0.334137] pci 0000:04:00.1: reg 18 io port: [0x3000-0x301f]
[    0.335824] pci 0000:04:00.1: PME# supported from D0 D3hot D3cold
[    0.336053] pci 0000:04:00.1: PME# disabled
[    0.338549] pci 0000:02:02.0: bridge io port: [0x3000-0x3fff]
[    0.338641] pci 0000:02:02.0: bridge 32bit mmio: [0xfa000000-0xfa8fffff]
[    0.341908] pci 0000:0b:00.0: reg 10 64bit mmio: [0xf8000000-0xf9ffffff]
[    0.341921] pci 0000:0b:00.0: reg 18 64bit mmio: [0xfab00000-0xfab00fff]
[    0.341929] pci 0000:0b:00.0: reg 20 io port: [0x2000-0x20ff]
[    0.341941] pci 0000:0b:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.342011] pci 0000:0b:00.0: supports D1 D2
[    0.342059] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    0.342063] pci 0000:00:1c.0: bridge 32bit mmio: [0xfab00000-0xfabfffff]
[    0.342070] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf8000000-0xf9ffffff]
[    0.342126] pci 0000:0c:0c.0: reg 10 32bit mmio: [0xf0000000-0xf7ffffff]
[    0.342133] pci 0000:0c:0c.0: reg 14 io port: [0x1000-0x10ff]
[    0.342141] pci 0000:0c:0c.0: reg 18 32bit mmio: [0xfaa00000-0xfaa0ffff]
[    0.342164] pci 0000:0c:0c.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.342185] pci 0000:0c:0c.0: supports D1 D2
[    0.342219] pci 0000:00:1e.0: transparent bridge
[    0.342485] pci 0000:00:1e.0: bridge io port: [0x1000-0x1fff]
[    0.342489] pci 0000:00:1e.0: bridge 32bit mmio: [0xfaa00000-0xfaafffff]
[    0.342496] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xf0000000-0xf7ffffff]
[    0.342527] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.343026] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC32._PRT]
[    0.343079] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.343213] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.343294] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIX._PRT]
[    0.343414] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW._PRT]
[    0.343577] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW.PCIO._PRT]
[    0.343668] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW.PCIQ._PRT]
[    0.343745] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIF._PRT]
[    0.343837] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIG._PRT]
[    0.343929] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIH._PRT]
[    0.353129] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 *10 11)
[    0.353811] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 *11)
[    0.354563] ACPI: PCI Interrupt Link [LNKC] (IRQs *5 7 10 11)
[    0.355121] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 *11)
[    0.355784] ACPI: PCI Interrupt Link [LNKE] (IRQs 5 7 *10 11)
[    0.356563] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 10 *11)
[    0.357121] ACPI: PCI Interrupt Link [LNKG] (IRQs *5 7 10 11)
[    0.357783] ACPI: PCI Interrupt Link [LNKH] (IRQs 5 7 10 *11)
[    0.359005] SCSI subsystem initialized
[    0.359311] libata version 3.00 loaded.
[    0.359311] usbcore: registered new interface driver usbfs
[    0.360030] usbcore: registered new interface driver hub
[    0.360303] usbcore: registered new device driver usb
[    0.378011] raid6: int64x1   1679 MB/s
[    0.395021] raid6: int64x2   2097 MB/s
[    0.412037] raid6: int64x4   1609 MB/s
[    0.429006] raid6: int64x8   1433 MB/s
[    0.446030] raid6: sse2x1    2300 MB/s
[    0.463012] raid6: sse2x2    4691 MB/s
[    0.480014] raid6: sse2x4    5253 MB/s
[    0.480277] raid6: using algorithm sse2x4 (5253 MB/s)
[    0.480551] PCI: Using ACPI for IRQ routing
[    0.484009] NetLabel: Initializing
[    0.484274] NetLabel:  domain hash size = 128
[    0.484549] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.484828] NetLabel:  unlabeled traffic allowed by default
[    0.494080] pnp: PnP ACPI init
[    0.494357] ACPI: bus type pnp registered
[    0.500498] Switched to high resolution mode on CPU 3
[    0.500696] Switched to high resolution mode on CPU 2
[    0.500800] Switched to high resolution mode on CPU 1
[    0.501175] Switched to high resolution mode on CPU 0
[    0.502028] pnp: PnP ACPI: found 14 devices
[    0.502303] ACPI: ACPI bus type pnp unregistered
[    0.502577] system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
[    0.502847] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.503123] system 00:01: iomem range 0xffc00000-0xffffffff could not be reserved
[    0.503604] system 00:01: iomem range 0xfec00000-0xfecfffff could not be reserved
[    0.504088] system 00:01: iomem range 0xfee00000-0xfeefffff has been reserved
[    0.504358] system 00:01: iomem range 0xfe600000-0xfe6fffff has been reserved
[    0.504626] system 00:01: iomem range 0xfe000000-0xfe01ffff has been reserved
[    0.504895] system 00:01: iomem range 0x0-0x9ffff could not be reserved
[    0.505171] system 00:06: ioport range 0x500-0x53f has been reserved
[    0.505438] system 00:06: ioport range 0x400-0x47f has been reserved
[    0.505705] system 00:06: ioport range 0x800-0x87f has been reserved
[    0.505973] system 00:06: ioport range 0xca0-0xcaf has been reserved
[    0.506244] system 00:06: ioport range 0x161-0x161 has been reserved
[    0.506513] system 00:06: ioport range 0x162-0x162 has been reserved
[    0.512461] pci 0000:0b:00.0: BAR 6: no parent found for of device [0xfffe0000-0xffffffff]
[    0.514049] pci 0000:02:00.0: PCI bridge, secondary bus 0000:03
[    0.514317] pci 0000:02:00.0:   IO window: disabled
[    0.514675] pci 0000:02:00.0:   MEM window: disabled
[    0.514996] pci 0000:02:00.0:   PREFETCH window: disabled
[    0.515320] pci 0000:02:02.0: PCI bridge, secondary bus 0000:04
[    0.515595] pci 0000:02:02.0:   IO window: 0x3000-0x3fff
[    0.515961] pci 0000:02:02.0:   MEM window: 0xfa000000-0xfa8fffff
[    0.516283] pci 0000:02:02.0:   PREFETCH window: disabled
[    0.516604] pci 0000:01:00.0: PCI bridge, secondary bus 0000:02
[    0.516879] pci 0000:01:00.0:   IO window: 0x3000-0x3fff
[    0.517248] pci 0000:01:00.0:   MEM window: 0xfa000000-0xfa8fffff
[    0.517568] pci 0000:01:00.0:   PREFETCH window: disabled
[    0.517889] pci 0000:01:00.3: PCI bridge, secondary bus 0000:05
[    0.518161] pci 0000:01:00.3:   IO window: disabled
[    0.518521] pci 0000:01:00.3:   MEM window: disabled
[    0.518842] pci 0000:01:00.3:   PREFETCH window: disabled
[    0.519164] pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
[    0.519430] pci 0000:00:02.0:   IO window: 0x3000-0x3fff
[    0.519697] pci 0000:00:02.0:   MEM window: 0xfa000000-0xfa9fffff
[    0.519964] pci 0000:00:02.0:   PREFETCH window: disabled
[    0.520234] pci 0000:00:03.0: PCI bridge, secondary bus 0000:06
[    0.520502] pci 0000:00:03.0:   IO window: disabled
[    0.520767] pci 0000:00:03.0:   MEM window: disabled
[    0.521036] pci 0000:00:03.0:   PREFETCH window: disabled
[    0.521304] pci 0000:00:04.0: PCI bridge, secondary bus 0000:07
[    0.521571] pci 0000:00:04.0:   IO window: disabled
[    0.521837] pci 0000:00:04.0:   MEM window: disabled
[    0.522108] pci 0000:00:04.0:   PREFETCH window: disabled
[    0.522377] pci 0000:00:05.0: PCI bridge, secondary bus 0000:08
[    0.522644] pci 0000:00:05.0:   IO window: disabled
[    0.522910] pci 0000:00:05.0:   MEM window: disabled
[    0.523179] pci 0000:00:05.0:   PREFETCH window: disabled
[    0.523446] pci 0000:00:06.0: PCI bridge, secondary bus 0000:09
[    0.523714] pci 0000:00:06.0:   IO window: disabled
[    0.523980] pci 0000:00:06.0:   MEM window: disabled
[    0.524249] pci 0000:00:06.0:   PREFETCH window: disabled
[    0.524517] pci 0000:00:07.0: PCI bridge, secondary bus 0000:0a
[    0.524784] pci 0000:00:07.0:   IO window: disabled
[    0.525053] pci 0000:00:07.0:   MEM window: disabled
[    0.525319] pci 0000:00:07.0:   PREFETCH window: disabled
[    0.525589] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
[    0.532223] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.532491] pci 0000:00:1c.0:   MEM window: 0xfab00000-0xfabfffff
[    0.532762] pci 0000:00:1c.0:   PREFETCH window: 0x000000f8000000-0x000000f9ffffff
[    0.533246] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
[    0.533512] pci 0000:00:1e.0:   IO window: 0x1000-0x1fff
[    0.533779] pci 0000:00:1e.0:   MEM window: 0xfaa00000-0xfaafffff
[    0.534050] pci 0000:00:1e.0:   PREFETCH window: 0x000000f0000000-0x000000f7ffffff
[    0.534538]   alloc irq_desc for 16 on node 0
[    0.534540]   alloc kstat_irqs on node 0
[    0.534547] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.534818] pci 0000:00:02.0: setting latency timer to 64
[    0.534917] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.535237] pci 0000:01:00.0: setting latency timer to 64
[    0.535421] pci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.535741] pci 0000:02:00.0: setting latency timer to 64
[    0.535925]   alloc irq_desc for 18 on node 0
[    0.535927]   alloc kstat_irqs on node 0
[    0.535931] pci 0000:02:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.536292] pci 0000:02:02.0: setting latency timer to 64
[    0.536567] pci 0000:01:00.3: setting latency timer to 64
[    0.536616] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.536886] pci 0000:00:03.0: setting latency timer to 64
[    0.536892] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.537166] pci 0000:00:04.0: setting latency timer to 64
[    0.537172] pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.537442] pci 0000:00:05.0: setting latency timer to 64
[    0.537448] pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.537719] pci 0000:00:06.0: setting latency timer to 64
[    0.537725] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.537995] pci 0000:00:07.0: setting latency timer to 64
[    0.538006] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.538276] pci 0000:00:1c.0: setting latency timer to 64
[    0.538283] pci 0000:00:1e.0: setting latency timer to 64
[    0.538287] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.538290] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.538293] pci_bus 0000:01: resource 0 io:  [0x3000-0x3fff]
[    0.538296] pci_bus 0000:01: resource 1 mem: [0xfa000000-0xfa9fffff]
[    0.538299] pci_bus 0000:02: resource 0 io:  [0x3000-0x3fff]
[    0.538301] pci_bus 0000:02: resource 1 mem: [0xfa000000-0xfa8fffff]
[    0.538304] pci_bus 0000:04: resource 0 io:  [0x3000-0x3fff]
[    0.538307] pci_bus 0000:04: resource 1 mem: [0xfa000000-0xfa8fffff]
[    0.538310] pci_bus 0000:0b: resource 0 io:  [0x2000-0x2fff]
[    0.538313] pci_bus 0000:0b: resource 1 mem: [0xfab00000-0xfabfffff]
[    0.538316] pci_bus 0000:0b: resource 2 pref mem [0xf8000000-0xf9ffffff]
[    0.538318] pci_bus 0000:0c: resource 0 io:  [0x1000-0x1fff]
[    0.538321] pci_bus 0000:0c: resource 1 mem: [0xfaa00000-0xfaafffff]
[    0.538324] pci_bus 0000:0c: resource 2 pref mem [0xf0000000-0xf7ffffff]
[    0.538326] pci_bus 0000:0c: resource 3 io:  [0x00-0xffff]
[    0.538329] pci_bus 0000:0c: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.538379] NET: Registered protocol family 2
[    0.538783] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.539909] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.542636] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.543533] TCP: Hash tables configured (established 262144 bind 65536)
[    0.543802] TCP reno registered
[    0.544257] NET: Registered protocol family 1
[    0.548015] microcode: CPU0 sig=0x6f6, pf=0x4, revision=0xcd
[    0.548335] microcode: CPU1 sig=0x6f6, pf=0x4, revision=0xcd
[    0.548612] microcode: CPU2 sig=0x6f6, pf=0x4, revision=0xcd
[    0.548892] microcode: CPU3 sig=0x6f6, pf=0x4, revision=0xcd
[    0.549251] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.549752] Scanning for low memory corruption every 60 seconds
[    0.550445] audit: initializing netlink socket (disabled)
[    0.550735] type=2000 audit(1271680032.550:1): initialized
[    0.558636] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.565964] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.566693] NTFS driver 2.1.29 [Flags: R/O].
[    0.567168] SGI XFS with security attributes, large block/inode numbers, no debug enabled
[    0.568771] msgmni has been set to 4009
[    0.570208] alg: No test for stdrng (krng)
[    0.570511] async_tx: api initialized (sync-only)
[    0.570992] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.571489] io scheduler noop registered
[    0.571752] io scheduler anticipatory registered
[    0.572019] io scheduler deadline registered
[    0.572407] io scheduler cfq registered (default)
[    0.572722] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x1f30
[    0.572724] pci 0000:00:1d.0: Performing full reset
[    0.572742] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.572745] pci 0000:00:1d.1: Performing full reset
[    0.572762] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.572764] pci 0000:00:1d.2: Performing full reset
[    0.572781] pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x0030
[    0.572783] pci 0000:00:1d.3: Performing full reset
[    0.572924] PCI quirk: reroute interrupts for 0x8086:0x2670
[    0.573229] pci 0000:0c:0c.0: Boot video device
[    0.573503]   alloc irq_desc for 48 on node 0
[    0.573506]   alloc kstat_irqs on node 0
[    0.573518] pcieport-driver 0000:00:02.0: irq 48 for MSI/MSI-X
[    0.573527] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.573721]   alloc irq_desc for 49 on node 0
[    0.573724]   alloc kstat_irqs on node 0
[    0.573732] pcieport-driver 0000:00:03.0: irq 49 for MSI/MSI-X
[    0.573739] pcieport-driver 0000:00:03.0: setting latency timer to 64
[    0.573967]   alloc irq_desc for 50 on node 0
[    0.573970]   alloc kstat_irqs on node 0
[    0.573977] pcieport-driver 0000:00:04.0: irq 50 for MSI/MSI-X
[    0.573985] pcieport-driver 0000:00:04.0: setting latency timer to 64
[    0.574170]   alloc irq_desc for 51 on node 0
[    0.574172]   alloc kstat_irqs on node 0
[    0.574180] pcieport-driver 0000:00:05.0: irq 51 for MSI/MSI-X
[    0.574187] pcieport-driver 0000:00:05.0: setting latency timer to 64
[    0.574381]   alloc irq_desc for 52 on node 0
[    0.574383]   alloc kstat_irqs on node 0
[    0.574391] pcieport-driver 0000:00:06.0: irq 52 for MSI/MSI-X
[    0.574398] pcieport-driver 0000:00:06.0: setting latency timer to 64
[    0.574623]   alloc irq_desc for 53 on node 0
[    0.574626]   alloc kstat_irqs on node 0
[    0.574633] pcieport-driver 0000:00:07.0: irq 53 for MSI/MSI-X
[    0.574640] pcieport-driver 0000:00:07.0: setting latency timer to 64
[    0.574838]   alloc irq_desc for 54 on node 0
[    0.574841]   alloc kstat_irqs on node 0
[    0.574849] pcieport-driver 0000:00:1c.0: irq 54 for MSI/MSI-X
[    0.574858] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.576458] pcieport-driver 0000:01:00.0: setting latency timer to 64
[    0.578662]   alloc irq_desc for 55 on node 0
[    0.578664]   alloc kstat_irqs on node 0
[    0.578891] pcieport-driver 0000:02:00.0: irq 55 for MSI/MSI-X
[    0.579167] pcieport-driver 0000:02:00.0: setting latency timer to 64
[    0.581142]   alloc irq_desc for 56 on node 0
[    0.581144]   alloc kstat_irqs on node 0
[    0.581370] pcieport-driver 0000:02:02.0: irq 56 for MSI/MSI-X
[    0.581645] pcieport-driver 0000:02:02.0: setting latency timer to 64
[    0.581842] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.582501] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.582991] ACPI: Power Button [PWRF]
[    0.583414] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.583909] ACPI: Sleep Button [SLPB]
[    0.584288] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    0.584769] ACPI: Power Button [PWRB]
[    0.585295] Marking TSC unstable due to TSC halts in idle
[    0.585646] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    0.586153] processor LNXCPU:00: registered as cooling_device0
[    0.586432] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.586982] ACPI: CPU1 (power states: C1[C1] C2[C2])
[    0.587528] processor LNXCPU:01: registered as cooling_device1
[    0.587802] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.588429] ACPI: CPU2 (power states: C1[C1] C2[C2])
[    0.588947] processor LNXCPU:02: registered as cooling_device2
[    0.589228] ACPI: Processor [CPU2] (supports 8 throttling states)
[    0.589741] ACPI: CPU3 (power states: C1[C1] C2[C2])
[    0.590264] processor LNXCPU:03: registered as cooling_device3
[    0.590534] ACPI: Processor [CPU3] (supports 8 throttling states)
[    0.599229] Non-volatile memory driver v1.3
[    0.599504] Linux agpgart interface v0.103
[    0.599874] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.844150] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.088174] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.089161] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.089722] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.093469] brd: module loaded
[    1.095436] loop: module loaded
[    1.095796] input: Macintosh mouse button emulation as /devices/virtual/input/input3
[    1.096926] 3ware 9000 Storage Controller device driver for Linux v2.26.02.012.
[    1.097532] 3w-9xxx 0000:0b:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.097810] 3w-9xxx 0000:0b:00.0: setting latency timer to 64
[    1.302040] scsi0 : 3ware 9000 Storage Controller
[    1.302582] 3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xfab00000, IRQ: 16.
[    1.609365] 3w-9xxx: scsi0: Firmware FE9X 3.08.00.016, BIOS BE9X 3.08.00.004, Ports: 4.
[    1.610272] scsi 0:0:0:0: Direct-Access     AMCC     9650SE-4LP DISK  3.08 PQ: 0 ANSI: 5
[    1.611790] scsi 0:0:1:0: Direct-Access     AMCC     9650SE-4LP DISK  3.08 PQ: 0 ANSI: 5
[    1.613357] scsi 0:0:2:0: Direct-Access     AMCC     9650SE-4LP DISK  3.08 PQ: 0 ANSI: 5
[    1.614771] scsi 0:0:3:0: Direct-Access     AMCC     9650SE-4LP DISK  3.08 PQ: 0 ANSI: 5
[    1.623927] work_for_cpu used greatest stack depth: 5336 bytes left
[    1.624436] sd 0:0:0:0: [sda] 976541696 512-byte logical blocks: (499 GB/465 GiB)
[    1.624470] sd 0:0:1:0: [sdb] 976541696 512-byte logical blocks: (499 GB/465 GiB)
[    1.624691] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.624757] sd 0:0:1:0: Attached scsi generic sg1 type 0
[    1.624824] sd 0:0:2:0: Attached scsi generic sg2 type 0
[    1.624888] sd 0:0:3:0: Attached scsi generic sg3 type 0
[    1.624985] ahci 0000:00:1f.2: version 3.0
[    1.625000]   alloc irq_desc for 20 on node 0
[    1.625002]   alloc kstat_irqs on node 0
[    1.625009] ahci 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    1.625152] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.625156] ahci 0000:00:1f.2: flags: 64bit ncq pm led pmp slum part
[    1.625161] ahci 0000:00:1f.2: setting latency timer to 64
[    1.625684] scsi1 : ahci
[    1.625907] scsi2 : ahci
[    1.626139] scsi3 : ahci
[    1.626347] scsi4 : ahci
[    1.626563] scsi5 : ahci
[    1.626781] scsi6 : ahci
[    1.627085] ata1: SATA max UDMA/133 abar m1024@0xfac00000 port 0xfac00100 irq 20
[    1.627089] ata2: SATA max UDMA/133 abar m1024@0xfac00000 port 0xfac00180 irq 20
[    1.627092] ata3: SATA max UDMA/133 abar m1024@0xfac00000 port 0xfac00200 irq 20
[    1.627096] ata4: SATA max UDMA/133 abar m1024@0xfac00000 port 0xfac00280 irq 20
[    1.627100] ata5: SATA max UDMA/133 abar m1024@0xfac00000 port 0xfac00300 irq 20
[    1.627103] ata6: SATA max UDMA/133 abar m1024@0xfac00000 port 0xfac00380 irq 20
[    1.627281] ata_piix 0000:00:1f.1: version 2.13
[    1.627290] ata_piix 0000:00:1f.1: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.627345] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.627436] scsi7 : ata_piix
[    1.627649] scsi8 : ata_piix
[    1.629552] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40c0 irq 14
[    1.629555] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40c8 irq 15
[    1.629568] work_for_cpu used greatest stack depth: 5224 bytes left
[    1.629829] console [netcon0] enabled
[    1.633868] netconsole: network logging started
[    1.634225] sd 0:0:2:0: [sdc] 1953103872 512-byte logical blocks: (999 GB/931 GiB)
[    1.634483] sd 0:0:1:0: [sdb] Write Protect is off
[    1.634486] sd 0:0:1:0: [sdb] Mode Sense: 23 00 00 00
[    1.634512] sd 0:0:3:0: [sdd] 1953103872 512-byte logical blocks: (999 GB/931 GiB)
[    1.634527] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.634529] ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96
[    1.634584]   alloc irq_desc for 23 on node 0
[    1.634586]   alloc kstat_irqs on node 0
[    1.634592] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.634608] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.634612] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.634641] drivers/usb/core/inode.c: creating file 'devices'
[    1.634646] drivers/usb/core/inode.c: creating file '001'
[    1.634721] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.634733] ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
[    1.634738] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    1.634763] ehci_hcd 0000:00:1d.7: reset command 080012 (park)=0 ithresh=8 Periodic period=1024 Reset HALT
[    1.637046] sd 0:0:0:0: [sda] Write Protect is off
[    1.637386] sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
[    1.637781] sd 0:0:0:0: [sda] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
[    1.637901] sd 0:0:2:0: [sdc] Write Protect is off
[    1.637904] sd 0:0:2:0: [sdc] Mode Sense: 23 00 00 00
[    1.638649] ehci_hcd 0000:00:1d.7: debug port 1
[    1.638944] sd 0:0:2:0: [sdc] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
[    1.638950] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.638952] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    1.638966] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfac00400
[    1.638972] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.640741]  sda:
[    1.641166]  sdc: sdc1
[    1.642852] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    1.643096] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
[    1.643461] sd 0:0:3:0: [sdd] Write Protect is off
[    1.643464] sd 0:0:3:0: [sdd] Mode Sense: 23 00 00 00
[    1.643885] sd 0:0:2:0: [sdc] Attached SCSI disk
[    1.644352] sd 0:0:3:0: [sdd] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
[    1.645051]  sdb:
[    1.645973]  sdd: sdd1
[    1.648024] sd 0:0:3:0: [sdd] Attached SCSI disk
[    1.648034] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.648072] usb usb1: default language 0x0409
[    1.648082] usb usb1: udev 1, busnum 1, minor = 0
[    1.648084] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.648087] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.648090] usb usb1: Product: EHCI Host Controller
[    1.648092] usb usb1: Manufacturer: Linux 2.6.31.6 ehci_hcd
[    1.648095] usb usb1: SerialNumber: 0000:00:1d.7
[    1.648140] usb usb1: uevent
[    1.649808]  sda1
[    1.650460] usb usb1: usb_probe_device
[    1.650464] usb usb1: configuration #1 chosen from 1 choice
[    1.650742] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    1.650762] usb 1-0:1.0: uevent
[    1.650825] hub 1-0:1.0: usb_probe_interface
[    1.650828] hub 1-0:1.0: usb_probe_interface - got id
[    1.650831] hub 1-0:1.0: USB hub found
[    1.651123] hub 1-0:1.0: 8 ports detected
[    1.651252]  sdb1
[    1.658025] hub 1-0:1.0: standalone hub
[    1.658027] hub 1-0:1.0: no power switching (usb 1.0)
[    1.658029] hub 1-0:1.0: individual port over-current protection
[    1.658032] hub 1-0:1.0: power on to power good time: 20ms
[    1.658038] hub 1-0:1.0: local power source is good
[    1.658041] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    1.658081] drivers/usb/core/inode.c: creating file '001'
[    1.658107] work_for_cpu used greatest stack depth: 5144 bytes left
[    1.658474] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.658759] ohci_hcd: block sizes: ed 80 td 96
[    1.658854] uhci_hcd: USB Universal Host Controller Interface driver
[    1.659373] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.659456] sd 0:0:1:0: [sdb] Attached SCSI disk
[    1.659934] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.659937] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.660228] drivers/usb/core/inode.c: creating file '002'
[    1.660339] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.660363] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.661108] uhci_hcd 0000:00:1d.0: detected 2 ports
[    1.661377] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    1.661379] uhci_hcd 0000:00:1d.0: Performing full reset
[    1.661393] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    1.661399] uhci_hcd 0000:00:1d.0: irq 23, io base 0x000040a0
[    1.661701] usb usb2: default language 0x0409
[    1.661709] usb usb2: udev 1, busnum 2, minor = 128
[    1.661711] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.661981] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.662472] usb usb2: Product: UHCI Host Controller
[    1.662735] usb usb2: Manufacturer: Linux 2.6.31.6 uhci_hcd
[    1.663005] usb usb2: SerialNumber: 0000:00:1d.0
[    1.663306] usb usb2: uevent
[    1.663396] usb usb2: usb_probe_device
[    1.663399] usb usb2: configuration #1 chosen from 1 choice
[    1.663670] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    1.663689] usb 2-0:1.0: uevent
[    1.663753] hub 2-0:1.0: usb_probe_interface
[    1.663755] hub 2-0:1.0: usb_probe_interface - got id
[    1.663757] hub 2-0:1.0: USB hub found
[    1.664045] hub 2-0:1.0: 2 ports detected
[    1.664311] hub 2-0:1.0: standalone hub
[    1.664313] hub 2-0:1.0: no power switching (usb 1.0)
[    1.664314] hub 2-0:1.0: individual port over-current protection
[    1.664317] hub 2-0:1.0: power on to power good time: 2ms
[    1.664321] hub 2-0:1.0: local power source is good
[    1.664323] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    1.664340] drivers/usb/core/inode.c: creating file '001'
[    1.664436]   alloc irq_desc for 22 on node 0
[    1.664439]   alloc kstat_irqs on node 0
[    1.664446] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    1.664722] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.664725] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.665006] drivers/usb/core/inode.c: creating file '003'
[    1.665113] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    1.665609] uhci_hcd 0000:00:1d.1: detected 2 ports
[    1.665877] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    1.665879] uhci_hcd 0000:00:1d.1: Performing full reset
[    1.665892] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    1.665906] uhci_hcd 0000:00:1d.1: irq 22, io base 0x00004080
[    1.666222] usb usb3: default language 0x0409
[    1.666229] usb usb3: udev 1, busnum 3, minor = 256
[    1.666232] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.666500] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.666979] usb usb3: Product: UHCI Host Controller
[    1.667254] usb usb3: Manufacturer: Linux 2.6.31.6 uhci_hcd
[    1.667522] usb usb3: SerialNumber: 0000:00:1d.1
[    1.667816] usb usb3: uevent
[    1.667888] usb usb3: usb_probe_device
[    1.667891] usb usb3: configuration #1 chosen from 1 choice
[    1.668176] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    1.668198] usb 3-0:1.0: uevent
[    1.668278] hub 3-0:1.0: usb_probe_interface
[    1.668281] hub 3-0:1.0: usb_probe_interface - got id
[    1.668283] hub 3-0:1.0: USB hub found
[    1.668564] hub 3-0:1.0: 2 ports detected
[    1.668826] hub 3-0:1.0: standalone hub
[    1.668828] hub 3-0:1.0: no power switching (usb 1.0)
[    1.668830] hub 3-0:1.0: individual port over-current protection
[    1.668832] hub 3-0:1.0: power on to power good time: 2ms
[    1.668836] hub 3-0:1.0: local power source is good
[    1.668838] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    1.668855] drivers/usb/core/inode.c: creating file '001'
[    1.668948] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 23 (level, low) -> IRQ 23
[    1.669233] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.669237] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.669517] drivers/usb/core/inode.c: creating file '004'
[    1.669617] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    1.670122] uhci_hcd 0000:00:1d.2: detected 2 ports
[    1.670401] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    1.670403] uhci_hcd 0000:00:1d.2: Performing full reset
[    1.670416] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    1.670422] uhci_hcd 0000:00:1d.2: irq 23, io base 0x00004060
[    1.670731] usb usb4: default language 0x0409
[    1.670739] usb usb4: udev 1, busnum 4, minor = 384
[    1.670741] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.671019] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.671501] usb usb4: Product: UHCI Host Controller
[    1.671765] usb usb4: Manufacturer: Linux 2.6.31.6 uhci_hcd
[    1.672039] usb usb4: SerialNumber: 0000:00:1d.2
[    1.672353] usb usb4: uevent
[    1.672437] usb usb4: usb_probe_device
[    1.672440] usb usb4: configuration #1 chosen from 1 choice
[    1.672712] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    1.672737] usb 4-0:1.0: uevent
[    1.672802] hub 4-0:1.0: usb_probe_interface
[    1.672804] hub 4-0:1.0: usb_probe_interface - got id
[    1.672807] hub 4-0:1.0: USB hub found
[    1.673098] hub 4-0:1.0: 2 ports detected
[    1.673363] hub 4-0:1.0: standalone hub
[    1.673364] hub 4-0:1.0: no power switching (usb 1.0)
[    1.673366] hub 4-0:1.0: individual port over-current protection
[    1.673368] hub 4-0:1.0: power on to power good time: 2ms
[    1.673373] hub 4-0:1.0: local power source is good
[    1.673375] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    1.673400] drivers/usb/core/inode.c: creating file '001'
[    1.673498] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 22 (level, low) -> IRQ 22
[    1.673774] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    1.673777] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.674065] drivers/usb/core/inode.c: creating file '005'
[    1.674172] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    1.674667] uhci_hcd 0000:00:1d.3: detected 2 ports
[    1.674934] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
[    1.674936] uhci_hcd 0000:00:1d.3: Performing full reset
[    1.674949] uhci_hcd 0000:00:1d.3: supports USB remote wakeup
[    1.674955] uhci_hcd 0000:00:1d.3: irq 22, io base 0x00004040
[    1.675267] usb usb5: default language 0x0409
[    1.675275] usb usb5: udev 1, busnum 5, minor = 512
[    1.675277] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.675547] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.676033] usb usb5: Product: UHCI Host Controller
[    1.676300] usb usb5: Manufacturer: Linux 2.6.31.6 uhci_hcd
[    1.676565] usb usb5: SerialNumber: 0000:00:1d.3
[    1.676867] usb usb5: uevent
[    1.676942] usb usb5: usb_probe_device
[    1.676945] usb usb5: configuration #1 chosen from 1 choice
[    1.677226] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    1.677245] usb 5-0:1.0: uevent
[    1.677314] hub 5-0:1.0: usb_probe_interface
[    1.677316] hub 5-0:1.0: usb_probe_interface - got id
[    1.677319] hub 5-0:1.0: USB hub found
[    1.677597] hub 5-0:1.0: 2 ports detected
[    1.677859] hub 5-0:1.0: standalone hub
[    1.677860] hub 5-0:1.0: no power switching (usb 1.0)
[    1.677862] hub 5-0:1.0: individual port over-current protection
[    1.677864] hub 5-0:1.0: power on to power good time: 2ms
[    1.677868] hub 5-0:1.0: local power source is good
[    1.677871] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    1.677894] drivers/usb/core/inode.c: creating file '001'
[    1.678132] usbcore: registered new interface driver usblp
[    1.678402] Initializing USB Mass Storage driver...
[    1.678793] usbcore: registered new interface driver usb-storage
[    1.679071] USB Mass Storage support registered.
[    1.679461] usbcore: registered new interface driver libusual
[    1.679943] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.683408] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.683678] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.684200] mice: PS/2 mouse device common for all mice
[    1.685133] rtc_cmos 00:03: RTC can wake from S4
[    1.685516] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.685809] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.686255] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    1.687087] coretemp coretemp.0: Using relative temperature scale!
[    1.687589] coretemp coretemp.1: Using relative temperature scale!
[    1.688073] coretemp coretemp.2: Using relative temperature scale!
[    1.688563] coretemp coretemp.3: Using relative temperature scale!
[    1.688938] md: raid0 personality registered for level 0
[    1.689242] md: raid1 personality registered for level 1
[    1.689520] md: raid10 personality registered for level 10
[    1.689786] md: raid6 personality registered for level 6
[    1.690059] md: raid5 personality registered for level 5
[    1.690326] md: raid4 personality registered for level 4
[    1.690988] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    1.692557] cpuidle: using governor ladder
[    1.694618] cpuidle: using governor menu
[    1.697893] usbcore: registered new interface driver hiddev
[    1.698313] usbcore: registered new interface driver usbhid
[    1.698582] usbhid: v2.6:USB HID core driver
[    1.699170] TCP cubic registered
[    1.699439] NET: Registered protocol family 17
[    1.700246] RPC: Registered udp transport module.
[    1.700523] RPC: Registered tcp transport module.
[    1.700799] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    1.701080] All bugs added by David S. Miller <davem@redhat.com>
[    1.701695] registered taskstats version 1
[    1.758072] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
[    1.764055] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.768054] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.773050] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.777051] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.805370] ata7.01: ATAPI: MATSHITADVD-ROM SR-8178, PZ16, max UDMA/66
[    1.811345] ata7.01: configured for UDMA/66
[    1.939034] ata6: SATA link down (SStatus 0 SControl 300)
[    1.939346] ata3: SATA link down (SStatus 0 SControl 300)
[    1.939632] ata4: SATA link down (SStatus 0 SControl 300)
[    1.939909] ata5: SATA link down (SStatus 0 SControl 300)
[    2.092035] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.092331] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.106213] ata2.00: ATA-7: HDS728080PLA380, PF2OA6EA, max UDMA/133
[    2.106494] ata2.00: 160836480 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.107630] ata2.00: configured for UDMA/133
[    2.111640] ata1.00: ATA-7: HDS728080PLA380, PF2OA6EA, max UDMA/133
[    2.111919] ata1.00: 160836480 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.113045] ata1.00: configured for UDMA/133
[    2.124137] scsi 1:0:0:0: Direct-Access     ATA      HDS728080PLA380  PF2O PQ: 0 ANSI: 5
[    2.125023] sd 1:0:0:0: [sde] 160836480 512-byte logical blocks: (82.3 GB/76.6 GiB)
[    2.125578] sd 1:0:0:0: [sde] Write Protect is off
[    2.125845] sd 1:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    2.125871] sd 1:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.126525]  sde:
[    2.126751] sd 1:0:0:0: Attached scsi generic sg4 type 0
[    2.127502] scsi 2:0:0:0: Direct-Access     ATA      HDS728080PLA380  PF2O PQ: 0 ANSI: 5
[    2.128376] sd 2:0:0:0: [sdf] 160836480 512-byte logical blocks: (82.3 GB/76.6 GiB)
[    2.128509] sd 2:0:0:0: Attached scsi generic sg5 type 0
[    2.129220] sd 2:0:0:0: [sdf] Write Protect is off
[    2.129503] sd 2:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    2.129529] sd 2:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.130170]  sdf:
[    2.130258] scsi 7:0:1:0: CD-ROM            MATSHITA DVD-ROM SR-8178  PZ16 PQ: 0 ANSI: 5
[    2.134523] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[    2.134802] Uniform CD-ROM driver Revision: 3.20
[    2.135301] sr 7:0:1:0: Attached scsi CD-ROM sr0
[    2.135490] sr 7:0:1:0: Attached scsi generic sg6 type 5
[    2.144510]  sde1 sde2
[    2.145266] sd 1:0:0:0: [sde] Attached SCSI disk
[    2.147397]  sdf1 sdf2
[    2.148297] sd 2:0:0:0: [sdf] Attached SCSI disk
[    2.148603] md: Waiting for all devices to be available before autodetect
[    2.148871] md: If you don't use raid, use raid=noautodetect
[    2.149420] md: Autodetecting RAID arrays.
[    2.278749] md: Scanned 8 and added 8 devices.
[    2.279024] md: autorun ...
[    2.279296] md: considering sdf2 ...
[    2.279567] md:  adding sdf2 ...
[    2.279832] md: sdf1 has different UUID to sdf2
[    2.280103] md:  adding sde2 ...
[    2.280375] md: sde1 has different UUID to sdf2
[    2.280643] md: sdb1 has different UUID to sdf2
[    2.280909] md: sda1 has different UUID to sdf2
[    2.281182] md: sdd1 has different UUID to sdf2
[    2.281457] md: sdc1 has different UUID to sdf2
[    2.282021] md: created md1
[    2.282298] md: bind<sde2>
[    2.282580] md: bind<sdf2>
[    2.282850] md: running: <sdf2><sde2>
[    2.283577] raid1: raid set md1 active with 2 out of 2 mirrors
[    2.283881] md1: detected capacity change from 0 to 72341258240
[    2.284268] md: considering sdf1 ...
[    2.284536] md:  adding sdf1 ...
[    2.284811] md:  adding sde1 ...
[    2.285077] md: sdb1 has different UUID to sdf1
[    2.285353] md: sda1 has different UUID to sdf1
[    2.285618] md: sdd1 has different UUID to sdf1
[    2.285885] md: sdc1 has different UUID to sdf1
[    2.286161] md: created md0
[    2.286430] md: bind<sde1>
[    2.286703] md: bind<sdf1>
[    2.286975] md: running: <sdf1><sde1>
[    2.287651] raid1: raid set md0 active with 2 out of 2 mirrors
[    2.287941] md0: detected capacity change from 0 to 10001842176
[    2.288345] md: considering sdb1 ...
[    2.294972] md:  adding sdb1 ...
[    2.295260] md:  adding sda1 ...
[    2.295523] md: sdd1 has different UUID to sdb1
[    2.295789] md: sdc1 has different UUID to sdb1
[    2.296336] md: created md2
[    2.296599] md: bind<sda1>
[    2.296879] md: bind<sdb1>
[    2.297156] md: running: <sdb1><sda1>
[    2.297817] raid1: raid set md2 active with 2 out of 2 mirrors
[    2.298114] md2: detected capacity change from 0 to 499981746176
[    2.298500] md: considering sdd1 ...
[    2.298768] md:  adding sdd1 ...
[    2.299048] md:  adding sdc1 ...
[    2.299598] md: created md3
[    2.299861] md: bind<sdc1>
[    2.300155] md: bind<sdd1>
[    2.300431] md: running: <sdd1><sdc1>
[    2.301085] raid1: raid set md3 active with 2 out of 2 mirrors
[    2.301386] md3: detected capacity change from 0 to 999988264960
[    2.301768] md: ... autorun DONE.
[    2.302157]  md0: unknown partition table
[    2.341383] kjournald starting.  Commit interval 5 seconds
[    2.341684] EXT3-fs: mounted filesystem with writeback data mode.
[    2.341964] VFS: Mounted root (ext3 filesystem) readonly on device 9:0.
[    2.342287] Freeing unused kernel memory: 500k freed
[    2.342756] Write protecting the kernel read-only data: 6412k
[    2.704030] usb usb2: suspend_rh (auto-stop)
[    2.704052] usb usb3: suspend_rh (auto-stop)
[    2.704072] usb usb4: suspend_rh (auto-stop)
[    2.704091] usb usb5: suspend_rh (auto-stop)
[    2.951962] mount used greatest stack depth: 4424 bytes left
[    3.417909] usb usb2: uevent
[    3.417943] usb 2-0:1.0: uevent
[    3.418007] usb usb3: uevent
[    3.418030] usb 3-0:1.0: uevent
[    3.418094] usb usb4: uevent
[    3.418117] usb 4-0:1.0: uevent
[    3.418184] usb usb5: uevent
[    3.418216] usb 5-0:1.0: uevent
[    3.418295] usb usb1: uevent
[    3.418318] usb 1-0:1.0: uevent
[    3.431157] udevadm used greatest stack depth: 4328 bytes left
[    3.768707] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    3.768984] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    3.769832] e1000e 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.770144] e1000e 0000:04:00.0: pci_enable_pcie_error_reporting failed 0xfffffffb
[    3.770674] e1000e 0000:04:00.0: setting latency timer to 64
[    3.773159]   alloc irq_desc for 57 on node 0
[    3.773161]   alloc kstat_irqs on node 0
[    3.773384] e1000e 0000:04:00.0: irq 57 for MSI/MSI-X
[    3.835311] 0000:04:00.0: eth0: (PCI Express:2.5GB/s:Width x4) 00:15:17:2f:60:04
[    3.835788] 0000:04:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.836143] 0000:04:00.0: eth1: MAC: 5, PHY: 5, PBA No: 301000-001
[    3.836245] udev: renamed network interface eth0 to eth1
[    3.837235]   alloc irq_desc for 19 on node 0
[    3.837238]   alloc kstat_irqs on node 0
[    3.837246] e1000e 0000:04:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.837528] e1000e 0000:04:00.1: pci_enable_pcie_error_reporting failed 0xfffffffb
[    3.838063] e1000e 0000:04:00.1: setting latency timer to 64
[    3.840536]   alloc irq_desc for 58 on node 0
[    3.840538]   alloc kstat_irqs on node 0
[    3.840764] e1000e 0000:04:00.1: irq 58 for MSI/MSI-X
[    3.907631] 0000:04:00.1: eth0: (PCI Express:2.5GB/s:Width x4) 00:15:17:2f:60:05
[    3.908118] 0000:04:00.1: eth0: Intel(R) PRO/1000 Network Connection
[    3.908480] 0000:04:00.1: eth0: MAC: 5, PHY: 5, PBA No: 301000-001
[    4.603344] EXT3 FS on md0, internal journal
[    7.918459]  md2: unknown partition table
[    8.091066] XFS mounting filesystem md2
[    8.307250] Ending clean XFS mount for filesystem: md2
[    8.308104]  md3: unknown partition table
[    8.415148] XFS mounting filesystem md3
[    8.694304] Ending clean XFS mount for filesystem: md3
[   10.356916] Adding 1023992k swap on /.swap1.  Priority:-1 extents:668 across:1311232k
[   12.031589] Adding 1023992k swap on /.swap2.  Priority:-2 extents:1919 across:2929128k
[   12.210629] rc.S used greatest stack depth: 4168 bytes left
[   12.637043] e1000e 0000:04:00.1: irq 58 for MSI/MSI-X
[   12.689316] e1000e 0000:04:00.1: irq 58 for MSI/MSI-X
[   15.459259] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   19.568789]  md1: unknown partition table
[  775.004121] pdflush used greatest stack depth: 3568 bytes left
[  892.256515] pdflush used greatest stack depth: 2400 bytes left
[ 2449.342342] cut used greatest stack depth: 1712 bytes left
[11809.506388] basename used greatest stack depth: 1488 bytes left
[11935.628090] swapper: page allocation failure. order:3, mode:0x4020
[11935.628330] Pid: 0, comm: swapper Not tainted 2.6.31.6 #6
[11935.628562] Call Trace:
[11935.628796]  <IRQ>  [<ffffffff810a1505>] __alloc_pages_nodemask+0x537/0x57e
[11935.629042]  [<ffffffff8103a45e>] ? try_to_wake_up+0x2b0/0x2c2
[11935.629285]  [<ffffffff810dc7b0>] ? pollwake+0x57/0x5b
[11935.629513]  [<ffffffff810c816d>] kmalloc_large_node+0x5d/0x9a
[11935.629741]  [<ffffffff810c8eac>] __kmalloc_node_track_caller+0x2d/0xed
[11935.629968]  [<ffffffff814085af>] ? igmpv3_newpack+0x46/0x1c4
[11935.630217]  [<ffffffff813bf417>] __alloc_skb+0x6f/0x168
[11935.630440]  [<ffffffff813ba7b2>] ? sock_def_readable+0x42/0x6f
[11935.630666]  [<ffffffff814085af>] igmpv3_newpack+0x46/0x1c4
[11935.630900]  [<ffffffff81056cfc>] ? ktime_get_ts+0x49/0x4e
[11935.631129]  [<ffffffff81056d12>] ? ktime_get+0x11/0x42
[11935.631358]  [<ffffffff8140875a>] add_grhead+0x2d/0x81
[11935.631585]  [<ffffffff81408c21>] ? igmp_ifc_timer_expire+0x0/0x272
[11935.631824]  [<ffffffff81408b03>] add_grec+0x355/0x38a
[11935.632060]  [<ffffffff8101db0c>] ? lapic_next_event+0x18/0x1c
[11935.632300]  [<ffffffff8105eb79>] ? tick_dev_program_event+0x37/0xa5
[11935.632524]  [<ffffffff81408c21>] ? igmp_ifc_timer_expire+0x0/0x272
[11935.632756]  [<ffffffff81408cd1>] igmp_ifc_timer_expire+0xb0/0x272
[11935.632980]  [<ffffffff81408c21>] ? igmp_ifc_timer_expire+0x0/0x272
[11935.633225]  [<ffffffff81048b74>] run_timer_softirq+0x193/0x208
[11935.633451]  [<ffffffff81044796>] __do_softirq+0xd1/0x195
[11935.633674]  [<ffffffff8100cbdc>] call_softirq+0x1c/0x28
[11935.633901]  [<ffffffff8100e04c>] do_softirq+0x34/0x72
[11935.634139]  [<ffffffff810444df>] irq_exit+0x3f/0x7e
[11935.634361]  [<ffffffff8100d74d>] do_IRQ+0xa3/0xba
[11935.634592]  [<ffffffff8100c453>] ret_from_intr+0x0/0xa
[11935.634827]  <EOI>  [<ffffffff812b1573>] ? acpi_idle_enter_simple+0x101/0x12f
[11935.635076]  [<ffffffff812b1569>] ? acpi_idle_enter_simple+0xf7/0x12f
[11935.635314]  [<ffffffff813a47c2>] ? cpuidle_idle_call+0x92/0xcc
[11935.635540]  [<ffffffff8100ae16>] ? cpu_idle+0x52/0x93
[11935.635774]  [<ffffffff8144c641>] ? start_secondary+0x179/0x17e
[11935.636005] Mem-Info:
[11935.636239] Node 0 DMA per-cpu:
[11935.636466] CPU    0: hi:    0, btch:   1 usd:   0
[11935.636705] CPU    1: hi:    0, btch:   1 usd:   0
[11935.636929] CPU    2: hi:    0, btch:   1 usd:   0
[11935.637173] CPU    3: hi:    0, btch:   1 usd:   0
[11935.637403] Node 0 DMA32 per-cpu:
[11935.637630] CPU    0: hi:  186, btch:  31 usd: 119
[11935.637858] CPU    1: hi:  186, btch:  31 usd:  50
[11935.638097] CPU    2: hi:  186, btch:  31 usd: 170
[11935.638326] CPU    3: hi:  186, btch:  31 usd: 122
[11935.638563] Active_anon:204900 active_file:55608 inactive_anon:69022
[11935.638565]  inactive_file:160938 unevictable:0 dirty:1143 writeback:0 unstable:0
[11935.638566]  free:3925 slab:13219 mapped:1058 pagetables:1271 bounce:0
[11935.645747] Node 0 DMA free:8020kB min:40kB low:48kB high:60kB active_anon:904kB inactive_anon:1016kB active_file:3852kB inactive_file:2092kB unevictable:0kB present:15344kB pages_scanned:0 all_unreclaimable? no
[11935.645754] lowmem_reserve[]: 0 1998 1998 1998
[11935.645758] Node 0 DMA32 free:7680kB min:5696kB low:7120kB high:8544kB active_anon:818696kB inactive_anon:275072kB active_file:218580kB inactive_file:641660kB unevictable:0kB present:2046728kB pages_scanned:0 all_unreclaimable? no
[11935.645764] lowmem_reserve[]: 0 0 0 0
[11935.645769] Node 0 DMA: 1*4kB 2*8kB 2*16kB 3*32kB 3*64kB 2*128kB 3*256kB 3*512kB 3*1024kB 1*2048kB 0*4096kB = 8020kB
[11935.645777] Node 0 DMA32: 1660*4kB 2*8kB 0*16kB 4*32kB 2*64kB 2*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 7680kB
[11935.645785] 216703 total pagecache pages
[11935.645787] 0 pages in swap cache
[11935.645788] Swap cache stats: add 0, delete 0, find 0/0
[11935.645790] Free swap  = 2047984kB
[11935.645792] Total swap = 2047984kB
[11935.658121] 523264 pages RAM
[11935.658356] 9885 pages reserved
[11935.658579] 78158 pages shared
[11935.658801] 441578 pages non-shared
[23972.738152] swapper: page allocation failure. order:3, mode:0x4020
[23972.738410] Pid: 0, comm: swapper Not tainted 2.6.31.6 #6
[23972.738653] Call Trace:
[23972.738871]  <IRQ>  [<ffffffff810a1505>] __alloc_pages_nodemask+0x537/0x57e
[23972.739118]  [<ffffffff8103a45e>] ? try_to_wake_up+0x2b0/0x2c2
[23972.739393]  [<ffffffff810dc7b0>] ? pollwake+0x57/0x5b
[23972.739629]  [<ffffffff810c816d>] kmalloc_large_node+0x5d/0x9a
[23972.739864]  [<ffffffff810c8eac>] __kmalloc_node_track_caller+0x2d/0xed
[23972.739870]  [<ffffffff814085af>] ? igmpv3_newpack+0x46/0x1c4
[23972.739875]  [<ffffffff813bf417>] __alloc_skb+0x6f/0x168
[23972.739879]  [<ffffffff813ba7b2>] ? sock_def_readable+0x42/0x6f
[23972.739883]  [<ffffffff814085af>] igmpv3_newpack+0x46/0x1c4
[23972.739887]  [<ffffffff81056cfc>] ? ktime_get_ts+0x49/0x4e
[23972.739890]  [<ffffffff81056d12>] ? ktime_get+0x11/0x42
[23972.739893]  [<ffffffff8140875a>] add_grhead+0x2d/0x81
[23972.739897]  [<ffffffff81408c21>] ? igmp_ifc_timer_expire+0x0/0x272
[23972.739900]  [<ffffffff81408b03>] add_grec+0x355/0x38a
[23972.739905]  [<ffffffff8101db0c>] ? lapic_next_event+0x18/0x1c
[23972.739909]  [<ffffffff8105eb79>] ? tick_dev_program_event+0x37/0xa5
[23972.739912]  [<ffffffff81408c21>] ? igmp_ifc_timer_expire+0x0/0x272
[23972.739915]  [<ffffffff81408cd1>] igmp_ifc_timer_expire+0xb0/0x272
[23972.739918]  [<ffffffff81408c21>] ? igmp_ifc_timer_expire+0x0/0x272
[23972.739923]  [<ffffffff81048b74>] run_timer_softirq+0x193/0x208
[23972.739926]  [<ffffffff81044796>] __do_softirq+0xd1/0x195
[23972.739930]  [<ffffffff8100cbdc>] call_softirq+0x1c/0x28
[23972.739933]  [<ffffffff8100e04c>] do_softirq+0x34/0x72
[23972.739936]  [<ffffffff810444df>] irq_exit+0x3f/0x7e
[23972.739938]  [<ffffffff8100d74d>] do_IRQ+0xa3/0xba
[23972.739943]  [<ffffffff8100c453>] ret_from_intr+0x0/0xa
[23972.739945]  <EOI>  [<ffffffff812b1573>] ? acpi_idle_enter_simple+0x101/0x12f
[23972.739954]  [<ffffffff812b1569>] ? acpi_idle_enter_simple+0xf7/0x12f
[23972.739958]  [<ffffffff813a47c2>] ? cpuidle_idle_call+0x92/0xcc
[23972.739962]  [<ffffffff8100ae16>] ? cpu_idle+0x52/0x93
[23972.739967]  [<ffffffff8144c641>] ? start_secondary+0x179/0x17e
[23972.739969] Mem-Info:
[23972.739971] Node 0 DMA per-cpu:
[23972.739974] CPU    0: hi:    0, btch:   1 usd:   0
[23972.739976] CPU    1: hi:    0, btch:   1 usd:   0
[23972.739978] CPU    2: hi:    0, btch:   1 usd:   0
[23972.739980] CPU    3: hi:    0, btch:   1 usd:   0
[23972.739982] Node 0 DMA32 per-cpu:
[23972.739984] CPU    0: hi:  186, btch:  31 usd: 154
[23972.739987] CPU    1: hi:  186, btch:  31 usd: 161
[23972.739989] CPU    2: hi:  186, btch:  31 usd:  87
[23972.739991] CPU    3: hi:  186, btch:  31 usd: 135
[23972.739995] Active_anon:206359 active_file:62146 inactive_anon:69271
[23972.739996]  inactive_file:147680 unevictable:0 dirty:5536 writeback:0 unstable:0
[23972.739998]  free:3826 slab:18192 mapped:1457 pagetables:1348 bounce:0
[23972.740000] Node 0 DMA free:8016kB min:40kB low:48kB high:60kB active_anon:888kB inactive_anon:1008kB active_file:2328kB inactive_file:3356kB unevictable:0kB present:15344kB pages_scanned:0 all_unreclaimable? no
[23972.740006] lowmem_reserve[]: 0 1998 1998 1998
[23972.740009] Node 0 DMA32 free:7288kB min:5696kB low:7120kB high:8544kB active_anon:824548kB inactive_anon:276076kB active_file:246256kB inactive_file:587364kB unevictable:0kB present:2046728kB pages_scanned:0 all_unreclaimable? no
[23972.740015] lowmem_reserve[]: 0 0 0 0
[23972.740018] Node 0 DMA: 2*4kB 1*8kB 10*16kB 3*32kB 5*64kB 2*128kB 2*256kB 3*512kB 3*1024kB 1*2048kB 0*4096kB = 8016kB
[23972.740026] Node 0 DMA32: 1666*4kB 2*8kB 0*16kB 1*32kB 1*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 7288kB
[23972.740033] 209934 total pagecache pages
[23972.740035] 0 pages in swap cache
[23972.740037] Swap cache stats: add 0, delete 0, find 0/0
[23972.740039] Free swap  = 2047984kB
[23972.740040] Total swap = 2047984kB
[23972.752160] 523264 pages RAM
[23972.752162] 9885 pages reserved
[23972.752163] 97422 pages shared
[23972.752164] 423239 pages non-shared
[24033.088048] swapper: page allocation failure. order:3, mode:0x4020
[24033.088296] Pid: 0, comm: swapper Not tainted 2.6.31.6 #6
[24033.088534] Call Trace:
[24033.088756]  <IRQ>  [<ffffffff810a1505>] __alloc_pages_nodemask+0x537/0x57e
[24033.089000]  [<ffffffff810c816d>] kmalloc_large_node+0x5d/0x9a
[24033.089243]  [<ffffffff810c8eac>] __kmalloc_node_track_caller+0x2d/0xed
[24033.089470]  [<ffffffff814085af>] ? igmpv3_newpack+0x46/0x1c4
[24033.089701]  [<ffffffff813bf417>] __alloc_skb+0x6f/0x168
[24033.089924]  [<ffffffff813c0046>] ? __netdev_alloc_skb+0x31/0x4d
[24033.090155]  [<ffffffff814085af>] igmpv3_newpack+0x46/0x1c4
[24033.090389]  [<ffffffff81056cfc>] ? ktime_get_ts+0x49/0x4e
[24033.090614]  [<ffffffff810340b5>] ? resched_cpu+0x55/0x5e
[24033.090837]  [<ffffffff8140875a>] add_grhead+0x2d/0x81
[24033.091075]  [<ffffffff81408c21>] ? igmp_ifc_timer_expire+0x0/0x272
[24033.091301]  [<ffffffff81408b03>] add_grec+0x355/0x38a
[24033.091525]  [<ffffffff8101db0c>] ? lapic_next_event+0x18/0x1c
[24033.091755]  [<ffffffff8105eb79>] ? tick_dev_program_event+0x37/0xa5
[24033.091982]  [<ffffffff81408c21>] ? igmp_ifc_timer_expire+0x0/0x272
[24033.092215]  [<ffffffff81408cd1>] igmp_ifc_timer_expire+0xb0/0x272
[24033.092444]  [<ffffffff81408c21>] ? igmp_ifc_timer_expire+0x0/0x272
[24033.092669]  [<ffffffff81048b74>] run_timer_softirq+0x193/0x208
[24033.092893]  [<ffffffff81044796>] __do_softirq+0xd1/0x195
[24033.093131]  [<ffffffff8100cbdc>] call_softirq+0x1c/0x28
[24033.093352]  [<ffffffff8100e04c>] do_softirq+0x34/0x72
[24033.093573]  [<ffffffff810444df>] irq_exit+0x3f/0x7e
[24033.093806]  [<ffffffff8100d74d>] do_IRQ+0xa3/0xba
[24033.094042]  [<ffffffff8100c453>] ret_from_intr+0x0/0xa
[24033.094270]  <EOI>  [<ffffffff812b1573>] ? acpi_idle_enter_simple+0x101/0x12f
[24033.094503]  [<ffffffff812b1569>] ? acpi_idle_enter_simple+0xf7/0x12f
[24033.094728]  [<ffffffff813a47c2>] ? cpuidle_idle_call+0x92/0xcc
[24033.094958]  [<ffffffff8100ae16>] ? cpu_idle+0x52/0x93
[24033.095199]  [<ffffffff8143e5b2>] ? rest_init+0x66/0x68
[24033.095423]  [<ffffffff816dae7e>] ? start_kernel+0x357/0x362
[24033.095659]  [<ffffffff816da4ba>] ? x86_64_start_reservations+0xaa/0xae
[24033.095888]  [<ffffffff816da59f>] ? x86_64_start_kernel+0xe1/0xe8
[24033.096128] Mem-Info:
[24033.096351] Node 0 DMA per-cpu:
[24033.096576] CPU    0: hi:    0, btch:   1 usd:   0
[24033.096796] CPU    1: hi:    0, btch:   1 usd:   0
[24033.097033] CPU    2: hi:    0, btch:   1 usd:   0
[24033.097269] CPU    3: hi:    0, btch:   1 usd:   0
[24033.097495] Node 0 DMA32 per-cpu:
[24033.097714] CPU    0: hi:  186, btch:  31 usd:  68
[24033.097939] CPU    1: hi:  186, btch:  31 usd: 170
[24033.098171] CPU    2: hi:  186, btch:  31 usd:  85
[24033.098392] CPU    3: hi:  186, btch:  31 usd: 149
[24033.098615] Active_anon:149811 active_file:22395 inactive_anon:61548
[24033.098616]  inactive_file:252048 unevictable:0 dirty:7449 writeback:0 unstable:0
[24033.098617]  free:4084 slab:17771 mapped:1459 pagetables:1241 bounce:0
[24033.099518] Node 0 DMA free:8036kB min:40kB low:48kB high:60kB active_anon:432kB inactive_anon:744kB active_file:256kB inactive_file:6096kB unevictable:0kB present:15344kB pages_scanned:0 all_unreclaimable? no
[24033.100205] lowmem_reserve[]: 0 1998 1998 1998
[24033.100434] Node 0 DMA32 free:8300kB min:5696kB low:7120kB high:8544kB active_anon:598812kB inactive_anon:245448kB active_file:89324kB inactive_file:1002096kB unevictable:0kB present:2046728kB pages_scanned:0 all_unreclaimable? no
[24033.101123] lowmem_reserve[]: 0 0 0 0
[24033.101365] Node 0 DMA: 1*4kB 2*8kB 3*16kB 3*32kB 3*64kB 4*128kB 2*256kB 3*512kB 3*1024kB 1*2048kB 0*4096kB = 8036kB
[24033.101836] Node 0 DMA32: 1887*4kB 2*8kB 0*16kB 5*32kB 1*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 8300kB
[24033.102324] 274560 total pagecache pages
[24033.102551] 0 pages in swap cache
[24033.102768] Swap cache stats: add 0, delete 0, find 0/0
[24033.102991] Free swap  = 2047984kB
[24033.103223] Total swap = 2047984kB
[24033.115729] 523264 pages RAM
[24033.115954] 9885 pages reserved
[24033.116187] 63198 pages shared
[24033.116419] 457186 pages non-shared
[24045.369208] swapper: page allocation failure. order:3, mode:0x4020
[24045.369459] Pid: 0, comm: swapper Not tainted 2.6.31.6 #6
[24045.369680] Call Trace:
[24045.369910]  <IRQ>  [<ffffffff810a1505>] __alloc_pages_nodemask+0x537/0x57e
[24045.370155]  [<ffffffff810c816d>] kmalloc_large_node+0x5d/0x9a
[24045.370394]  [<ffffffff810c8eac>] __kmalloc_node_track_caller+0x2d/0xed
[24045.370629]  [<ffffffff814085af>] ? igmpv3_newpack+0x46/0x1c4
[24045.370863]  [<ffffffff813bf417>] __alloc_skb+0x6f/0x168
[24045.370868]  [<ffffffff812712d9>] ? rb_insert_color+0xbd/0xe6
[24045.370871]  [<ffffffff814085af>] igmpv3_newpack+0x46/0x1c4
[24045.370877]  [<ffffffff81033cf4>] ? enqueue_task_fair+0x25/0x87
[24045.370883]  [<ffffffff8102e759>] ? enqueue_task+0x5b/0x66
[24045.370888]  [<ffffffff8140875a>] add_grhead+0x2d/0x81
[24045.370891]  [<ffffffff81408c21>] ? igmp_ifc_timer_expire+0x0/0x272
[24045.370894]  [<ffffffff81408b03>] add_grec+0x355/0x38a
[24045.370899]  [<ffffffff8101db0c>] ? lapic_next_event+0x18/0x1c
[24045.370904]  [<ffffffff8105eb79>] ? tick_dev_program_event+0x37/0xa5
[24045.370907]  [<ffffffff81408c21>] ? igmp_ifc_timer_expire+0x0/0x272
[24045.370910]  [<ffffffff81408cd1>] igmp_ifc_timer_expire+0xb0/0x272
[24045.370913]  [<ffffffff81408c21>] ? igmp_ifc_timer_expire+0x0/0x272
[24045.370918]  [<ffffffff81048b74>] run_timer_softirq+0x193/0x208
[24045.370921]  [<ffffffff81044796>] __do_softirq+0xd1/0x195
[24045.370925]  [<ffffffff8100cbdc>] call_softirq+0x1c/0x28
[24045.370928]  [<ffffffff8100e04c>] do_softirq+0x34/0x72
[24045.370931]  [<ffffffff810444df>] irq_exit+0x3f/0x7e
[24045.370934]  [<ffffffff8100d74d>] do_IRQ+0xa3/0xba
[24045.370938]  [<ffffffff8100c453>] ret_from_intr+0x0/0xa
[24045.370940]  <EOI>  [<ffffffff812b1573>] ? acpi_idle_enter_simple+0x101/0x12f
[24045.370949]  [<ffffffff812b1569>] ? acpi_idle_enter_simple+0xf7/0x12f
[24045.370953]  [<ffffffff813a47c2>] ? cpuidle_idle_call+0x92/0xcc
[24045.370957]  [<ffffffff8100ae16>] ? cpu_idle+0x52/0x93
[24045.370962]  [<ffffffff8144c641>] ? start_secondary+0x179/0x17e
[24045.370964] Mem-Info:
[24045.370966] Node 0 DMA per-cpu:
[24045.370969] CPU    0: hi:    0, btch:   1 usd:   0
[24045.370971] CPU    1: hi:    0, btch:   1 usd:   0
[24045.370973] CPU    2: hi:    0, btch:   1 usd:   0
[24045.370975] CPU    3: hi:    0, btch:   1 usd:   0
[24045.370977] Node 0 DMA32 per-cpu:
[24045.370979] CPU    0: hi:  186, btch:  31 usd: 158
[24045.370982] CPU    1: hi:  186, btch:  31 usd: 153
[24045.370984] CPU    2: hi:  186, btch:  31 usd:  81
[24045.370986] CPU    3: hi:  186, btch:  31 usd: 112
[24045.370991] Active_anon:149811 active_file:10515 inactive_anon:61548
[24045.370992]  inactive_file:265156 unevictable:0 dirty:12931 writeback:0 unstable:0
[24045.370994]  free:4017 slab:16610 mapped:1459 pagetables:1241 bounce:0
[24045.370995] Node 0 DMA free:8020kB min:40kB low:48kB high:60kB active_anon:432kB inactive_anon:744kB active_file:228kB inactive_file:6140kB unevictable:0kB present:15344kB pages_scanned:0 all_unreclaimable? no
[24045.371002] lowmem_reserve[]: 0 1998 1998 1998
[24045.371005] Node 0 DMA32 free:8048kB min:5696kB low:7120kB high:8544kB active_anon:598812kB inactive_anon:245448kB active_file:41832kB inactive_file:1054484kB unevictable:0kB present:2046728kB pages_scanned:0 all_unreclaimable? no
[24045.371011] lowmem_reserve[]: 0 0 0 0
[24045.371014] Node 0 DMA: 1*4kB 2*8kB 2*16kB 3*32kB 3*64kB 4*128kB 2*256kB 3*512kB 3*1024kB 1*2048kB 0*4096kB = 8020kB
[24045.371021] Node 0 DMA32: 1742*4kB 31*8kB 6*16kB 5*32kB 1*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 8048kB
[24045.371029] 275762 total pagecache pages
[24045.371031] 0 pages in swap cache
[24045.371033] Swap cache stats: add 0, delete 0, find 0/0
[24045.371034] Free swap  = 2047984kB
[24045.371036] Total swap = 2047984kB
[24045.382441] 523264 pages RAM
[24045.382443] 9885 pages reserved
[24045.382444] 51862 pages shared
[24045.382445] 468567 pages non-shared

MemTotal:        2053516 kB
MemFree:           15764 kB
Buffers:            6612 kB
Cached:           856836 kB
SwapCached:            0 kB
Active:           862760 kB
Inactive:        1102296 kB
Active(anon):     824916 kB
Inactive(anon):   277328 kB
Active(file):      37844 kB
Inactive(file):   824968 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       2047984 kB
SwapFree:        2047984 kB
Dirty:             21908 kB
Writeback:             0 kB
AnonPages:       1101916 kB
Mapped:             5804 kB
Slab:              49864 kB
SReclaimable:      36868 kB
SUnreclaim:        12996 kB
PageTables:         5328 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     3074740 kB
Committed_AS:    1568604 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       10844 kB
VmallocChunk:   34359709991 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        8192 kB
DirectMap2M:     2084864 kB


processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Xeon(R) CPU            5120  @ 1.86GHz
stepping	: 6
cpu MHz		: 1862.241
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow
bogomips	: 3724.48
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Xeon(R) CPU            5120  @ 1.86GHz
stepping	: 6
cpu MHz		: 1862.241
cache size	: 4096 KB
physical id	: 3
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 6
initial apicid	: 6
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow
bogomips	: 3723.87
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Xeon(R) CPU            5120  @ 1.86GHz
stepping	: 6
cpu MHz		: 1862.241
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow
bogomips	: 3723.87
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Xeon(R) CPU            5120  @ 1.86GHz
stepping	: 6
cpu MHz		: 1862.241
cache size	: 4096 KB
physical id	: 3
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 7
initial apicid	: 7
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca lahf_lm tpr_shadow
bogomips	: 3723.86
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/

