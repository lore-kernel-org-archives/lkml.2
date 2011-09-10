Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab1IJAyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 20:54:54 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:48525 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab1IJAyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 20:54:49 -0400
Date: Fri, 9 Sep 2011 20:54:39 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-X220
To: linux-kernel@vger.kernel.org
cc: yinghai@kernel.org
Subject: MTRR allocation failure
Message-ID: <alpine.DEB.2.02.1109092042540.11756@parag-X220>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I had the below messages in log and not other noticeable slowness.

mtrr: no more MTRRs available
[drm] MTRR allocation failed.  Graphics performance may suffer. 

I was able to pass mtrr_gran_size=128M enable_mtrr_cleanup to kernel 
command line and those messages went away but I lost 143MB of RAM.

I recently did a BIOS upgrade to resolve some other unrelated issues and 
now even with the above command line options the MTRR allocaiton failure 
is back but I don't have any lost RAM - this time too without any 
notieceable slowness. I tried various options for mtrr_gran_size and 
mtrr_spare_reg_nr with no change.

cat /proc/mtrr :

reg00: base=0x0ffc00000 ( 4092MB), size=    4MB, count=1: write-protect
reg01: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg02: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg03: base=0x0c0000000 ( 3072MB), size=  512MB, count=1: write-back
reg04: base=0x0dc000000 ( 3520MB), size=   64MB, count=1: uncachable
reg05: base=0x0db000000 ( 3504MB), size=   16MB, count=1: uncachable
reg06: base=0x100000000 ( 4096MB), size= 4096MB, count=1: write-back
reg07: base=0x200000000 ( 8192MB), size=  512MB, count=1: write-back
reg08: base=0x21f000000 ( 8688MB), size=   16MB, count=1: uncachable
reg09: base=0x21e800000 ( 8680MB), size=    8MB, count=1: uncachable

Sounds like some uncachable entries can be merged? I disabled #08, 09, 04 
and 05 with no immediate side effects. 

Is there any other option combo I can try to have some free entries for 
X/drm? 

Full dmesg below - it's for 2.6.38 but I have tried 3.1 from 31st Aug with 
identical results.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-11-generic (buildd@allspice) (gcc version 4.5.2 (Ubuntu/Linaro 4.5.2-8ubuntu4) ) #48-Ubuntu SMP Fri Jul 29 19:02:55 UTC 2011 (Ubuntu 2.6.38-11.48-generic 2.6.38.8)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.38-11-generic root=UUID=c1a0f7d1-87ec-4927-b1fb-5d738d4bd489 ro mtrr_gran_size=128M enable_mtrr_cleanup mtrr_spare_reg_nr=1 quiet splash vt.handoff=7
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
[    0.000000]  BIOS-e820: 0000000040200000 - 00000000da99f000 (usable)
[    0.000000]  BIOS-e820: 00000000da99f000 - 00000000dae9f000 (reserved)
[    0.000000]  BIOS-e820: 00000000dae9f000 - 00000000daf9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000daf9f000 - 00000000dafff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dafff000 - 00000000db000000 (usable)
[    0.000000]  BIOS-e820: 00000000db000000 - 00000000dfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed08000 - 00000000fed09000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffd20000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000021e600000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: LENOVO 4286CTO/4286CTO, BIOS 8DET51WW (1.21 ) 08/02/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x21e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask F00000000 write-back
[    0.000000]   7 base 200000000 mask FE0000000 write-back
[    0.000000]   8 base 21F000000 mask FFF000000 uncachable
[    0.000000]   9 base 21E800000 mask FFF800000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000db000000
[    0.000000]  0000000000 - 00db000000 page 2M
[    0.000000] kernel direct mapping tables up to db000000 @ 1fffb000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000021e600000
[    0.000000]  0100000000 - 021e600000 page 2M
[    0.000000] kernel direct mapping tables up to 21e600000 @ da995000-da99f000
[    0.000000] RAMDISK: 366ca000 - 3735d000
[    0.000000] ACPI: RSDP 00000000000f00e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000daffe120 000AC (v01 LENOVO TP-8D    00001210 PTEC 00000002)
[    0.000000] ACPI: FACP 00000000dafe7000 000F4 (v04 LENOVO TP-8D    00001210 PTL  00000002)
[    0.000000] ACPI: DSDT 00000000dafea000 0F643 (v01 LENOVO TP-8D    00001210 INTL 20061109)
[    0.000000] ACPI: FACS 00000000daf2d000 00040
[    0.000000] ACPI: SLIC 00000000daffd000 00176 (v01 LENOVO TP-8D    00001210 PTEC 00000001)
[    0.000000] ACPI: SSDT 00000000daffc000 00249 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffb000 00033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffa000 007A7 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET 00000000dafe6000 00038 (v01 LENOVO TP-8D    00001210 PTL  00000002)
[    0.000000] ACPI: APIC 00000000dafe5000 00098 (v01 LENOVO TP-8D    00001210 PTL  00000002)
[    0.000000] ACPI: MCFG 00000000dafe4000 0003C (v01 LENOVO TP-8D    00001210 PTL  00000002)
[    0.000000] ACPI: ECDT 00000000dafe3000 00052 (v01 LENOVO TP-8D    00001210 PTL  00000002)
[    0.000000] ACPI: ASF! 00000000dafe9000 000A5 (v32 LENOVO TP-8D    00001210 PTL  00000002)
[    0.000000] ACPI: TCPA 00000000dafe2000 00032 (v02    PTL   LENOVO 06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT 00000000dafe1000 00A69 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000dafe0000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: DMAR 00000000dafdf000 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 00000000dafde000 0003E (v01 LENOVO TP-8D    00001210 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dafdd000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: UEFI 00000000dafdc000 00292 (v01 LENOVO TP-8D    00001210 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000021e600000
[    0.000000] Initmem setup node 0 0000000000000000-000000021e600000
[    0.000000]   NODE_DATA [000000021e5fb000 - 000000021e5fffff]
[    0.000000]  [ffffea0000000000-ffffea00077fffff] PMD -> [ffff880216400000-ffff88021d5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0021e600
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040000
[    0.000000]     0: 0x00040200 -> 0x000da99f
[    0.000000]     0: 0x000dafff -> 0x000db000
[    0.000000]     0: 0x00100000 -> 0x0021e600
[    0.000000] On node 0 totalpages: 2067245
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3919 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 875992 pages, LIFO batch:31
[    0.000000]   Normal zone: 16037 pages used for memmap
[    0.000000]   Normal zone: 1156955 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 00000000da99f000 - 00000000dae9f000
[    0.000000] PM: Registered nosave memory: 00000000dae9f000 - 00000000daf9f000
[    0.000000] PM: Registered nosave memory: 00000000daf9f000 - 00000000dafff000
[    0.000000] PM: Registered nosave memory: 00000000db000000 - 00000000dfa00000
[    0.000000] PM: Registered nosave memory: 00000000dfa00000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed08000
[    0.000000] PM: Registered nosave memory: 00000000fed08000 - 00000000fed09000
[    0.000000] PM: Registered nosave memory: 00000000fed09000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffd20000
[    0.000000] PM: Registered nosave memory: 00000000ffd20000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at dfa00000 (gap: dfa00000:18600000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88001fc00000 s84416 r8192 d22080 u262144
[    0.000000] pcpu-alloc: s84416 r8192 d22080 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2036866
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.38-11-generic root=UUID=c1a0f7d1-87ec-4927-b1fb-5d738d4bd489 ro mtrr_gran_size=128M enable_mtrr_cleanup mtrr_spare_reg_nr=1 quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.000000] Memory: 8058880k/8886272k available (5942k kernel code, 617292k absent, 210100k reserved, 5016k data, 956k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:16640 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] vt handoff: transparent VT on vt#7
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 83886080 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.010000] Detected 2691.160 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 5382.32 BogoMIPS (lpj=26911600)
[    0.000005] pid_max: default: 32768 minimum: 301
[    0.000024] Security Framework initialized
[    0.000035] AppArmor: AppArmor initialized
[    0.000036] Yama: becoming mindful.
[    0.000683] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.002229] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002848] Mount-cache hash table entries: 256
[    0.002933] Initializing cgroup subsys ns
[    0.002936] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.002938] Initializing cgroup subsys cpuacct
[    0.002941] Initializing cgroup subsys memory
[    0.002946] Initializing cgroup subsys devices
[    0.002948] Initializing cgroup subsys freezer
[    0.002949] Initializing cgroup subsys net_cls
[    0.002951] Initializing cgroup subsys blkio
[    0.002974] CPU: Physical Processor ID: 0
[    0.002975] CPU: Processor Core ID: 0
[    0.002980] mce: CPU supports 7 MCE banks
[    0.002990] CPU0: Thermal monitoring enabled (TM1)
[    0.002995] using mwait in idle threads.
[    0.005098] ACPI: Core revision 20110112
[    0.022469] ftrace: allocating 24325 entries in 96 pages
[    0.030779] DMAR: Host address width 36
[    0.030781] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.030786] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.030788] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.030793] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.030794] DMAR: RMRR base: 0x000000dacd5000 end: 0x000000dacebfff
[    0.030795] DMAR: RMRR base: 0x000000db800000 end: 0x000000df9fffff
[    0.030797] DMAR: No ATSR found
[    0.030866] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.030868] HPET id 0 under DRHD base 0xfed91000
[    0.030869] HPET id 0 under DRHD base 0xfed91000
[    0.030870] HPET id 0 under DRHD base 0xfed91000
[    0.030871] HPET id 0 under DRHD base 0xfed91000
[    0.030872] HPET id 0 under DRHD base 0xfed91000
[    0.030873] HPET id 0 under DRHD base 0xfed91000
[    0.030874] HPET id 0 under DRHD base 0xfed91000
[    0.030875] HPET id 0 under DRHD base 0xfed91000
[    0.031074] Enabled Interrupt-remapping
[    0.031076] Enabling x2apic
[    0.031076] Enabled x2apic
[    0.031081] Setting APIC routing to cluster x2apic
[    0.031455] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.131329] CPU0: Intel(R) Core(TM) i7-2620M CPU @ 2.70GHz stepping 07
[    0.248063] Performance Events: PEBS fmt1+, generic architected perfmon, Intel PMU driver.
[    0.248068] ... version:                3
[    0.248069] ... bit width:              48
[    0.248070] ... generic registers:      4
[    0.248071] ... value mask:             0000ffffffffffff
[    0.248072] ... max period:             000000007fffffff
[    0.248073] ... fixed-purpose events:   3
[    0.248074] ... event mask:             000000070000000f
[    0.248441] Booting Node   0, Processors  #1 #2 #3
[    0.787494] Brought up 4 CPUs
[    0.787497] Total of 4 processors activated (21529.78 BogoMIPS).
[    0.790069] devtmpfs: initialized
[    0.790785] print_constraints: dummy: 
[    0.790810] Time: 23:30:36  Date: 09/09/11
[    0.790833] NET: Registered protocol family 16
[    0.790908] Trying to unpack rootfs image as initramfs...
[    0.790913] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.790914] ACPI: bus type pci registered
[    0.791132] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.791135] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.801634] PCI: Using configuration type 1 for base access
[    0.802211] bio: create slab <bio-0> at 0
[    0.803831] ACPI: EC: EC description table is found, configuring boot EC
[    0.808283] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.967654] ACPI: SSDT 00000000dae8c018 008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.968052] ACPI: Dynamic OEM Table Load:
[    0.968054] ACPI: SSDT           (null) 008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.976613] Freeing initrd memory: 12876k freed
[    1.007405] ACPI: SSDT 00000000dae8da98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    1.007829] ACPI: Dynamic OEM Table Load:
[    1.007831] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    1.037220] ACPI: SSDT 00000000dae8bd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    1.037605] ACPI: Dynamic OEM Table Load:
[    1.037607] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    1.067606] ACPI: Interpreter enabled
[    1.067609] ACPI: (supports S0 S3 S4 S5)
[    1.067626] ACPI: Using IOAPIC for interrupt routing
[    1.097443] ACPI: Power Resource [PUBS] (on)
[    1.100196] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    1.157979] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    1.157981] HEST: Table not found.
[    1.157983] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.158080] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    1.158122] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.158124] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.158125] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.158128] pci_root PNP0A08:00: host bridge window [mem 0xdfa00000-0xfebfffff]
[    1.158130] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed4bfff]
[    1.158139] pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
[    1.158170] pci 0000:00:02.0: [8086:0126] type 0 class 0x000300
[    1.158180] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    1.158185] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    1.158189] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
[    1.158237] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    1.158260] pci 0000:00:16.0: reg 10: [mem 0xf2625000-0xf262500f 64bit]
[    1.158321] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.158325] pci 0000:00:16.0: PME# disabled
[    1.158355] pci 0000:00:19.0: [8086:1502] type 0 class 0x000200
[    1.158372] pci 0000:00:19.0: reg 10: [mem 0xf2600000-0xf261ffff]
[    1.158381] pci 0000:00:19.0: reg 14: [mem 0xf262b000-0xf262bfff]
[    1.158390] pci 0000:00:19.0: reg 18: [io  0x5080-0x509f]
[    1.158437] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.158441] pci 0000:00:19.0: PME# disabled
[    1.158464] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    1.158484] pci 0000:00:1a.0: reg 10: [mem 0xf262a000-0xf262a3ff]
[    1.158556] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.158560] pci 0000:00:1a.0: PME# disabled
[    1.158582] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    1.158597] pci 0000:00:1b.0: reg 10: [mem 0xf2620000-0xf2623fff 64bit]
[    1.158650] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.158654] pci 0000:00:1b.0: PME# disabled
[    1.158677] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    1.158775] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.158780] pci 0000:00:1c.0: PME# disabled
[    1.158813] pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
[    1.158910] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.158915] pci 0000:00:1c.1: PME# disabled
[    1.158948] pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
[    1.159049] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.159054] pci 0000:00:1c.3: PME# disabled
[    1.159083] pci 0000:00:1c.4: [8086:1c18] type 1 class 0x000604
[    1.159142] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.159146] pci 0000:00:1c.4: PME# disabled
[    1.159170] pci 0000:00:1c.6: [8086:1c1c] type 1 class 0x000604
[    1.159229] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    1.159233] pci 0000:00:1c.6: PME# disabled
[    1.159260] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    1.159281] pci 0000:00:1d.0: reg 10: [mem 0xf2629000-0xf26293ff]
[    1.159352] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.159356] pci 0000:00:1d.0: PME# disabled
[    1.159380] pci 0000:00:1f.0: [8086:1c4f] type 0 class 0x000601
[    1.159493] pci 0000:00:1f.2: [8086:1c03] type 0 class 0x000106
[    1.159511] pci 0000:00:1f.2: reg 10: [io  0x50a8-0x50af]
[    1.159519] pci 0000:00:1f.2: reg 14: [io  0x50b4-0x50b7]
[    1.159527] pci 0000:00:1f.2: reg 18: [io  0x50a0-0x50a7]
[    1.159535] pci 0000:00:1f.2: reg 1c: [io  0x50b0-0x50b3]
[    1.159543] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
[    1.159550] pci 0000:00:1f.2: reg 24: [mem 0xf2628000-0xf26287ff]
[    1.159582] pci 0000:00:1f.2: PME# supported from D3hot
[    1.159585] pci 0000:00:1f.2: PME# disabled
[    1.159603] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    1.159617] pci 0000:00:1f.3: reg 10: [mem 0xf2624000-0xf26240ff 64bit]
[    1.159638] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    1.159733] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.159739] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.159744] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.159753] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.159975] pci 0000:03:00.0: [8086:0085] type 0 class 0x000280
[    1.160122] pci 0000:03:00.0: reg 10: [mem 0xf2500000-0xf2501fff 64bit]
[    1.160665] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.160700] pci 0000:03:00.0: PME# disabled
[    1.160887] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.160891] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    1.160895] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    1.160901] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.160944] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    1.160948] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    1.160953] pci 0000:00:1c.3:   bridge window [mem 0xf1d00000-0xf24fffff]
[    1.160959] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    1.161074] pci 0000:0d:00.0: [1180:e823] type 0 class 0x000880
[    1.161099] pci 0000:0d:00.0: reg 10: [mem 0xf1500000-0xf15000ff]
[    1.161260] pci 0000:0d:00.0: supports D1 D2
[    1.161262] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.161267] pci 0000:0d:00.0: PME# disabled
[    1.161313] pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
[    1.161316] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    1.161320] pci 0000:00:1c.4:   bridge window [mem 0xf1500000-0xf1cfffff]
[    1.161327] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    1.161393] pci 0000:0e:00.0: [1033:0194] type 0 class 0x000c03
[    1.161419] pci 0000:0e:00.0: reg 10: [mem 0xf1400000-0xf1401fff 64bit]
[    1.161523] pci 0000:0e:00.0: PME# supported from D0 D3hot D3cold
[    1.161528] pci 0000:0e:00.0: PME# disabled
[    1.161569] pci 0000:00:1c.6: PCI bridge to [bus 0e-0e]
[    1.161573] pci 0000:00:1c.6:   bridge window [io  0xf000-0x0000] (disabled)
[    1.161577] pci 0000:00:1c.6:   bridge window [mem 0xf1400000-0xf14fffff]
[    1.161583] pci 0000:00:1c.6:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.161607] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.161684] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    1.161708] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    1.161729] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    1.161752] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    1.161776] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP7._PRT]
[    1.161882]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.163883] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    1.163933] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 9 10 11)
[    1.163980] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 9 10 11)
[    1.164027] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    1.164073] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11)
[    1.164112] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    1.164159] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    1.164207] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11)
[    1.164285] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.164291] vgaarb: loaded
[    1.164409] SCSI subsystem initialized
[    1.164449] libata version 3.00 loaded.
[    1.164478] usbcore: registered new interface driver usbfs
[    1.164485] usbcore: registered new interface driver hub
[    1.164503] usbcore: registered new device driver usb
[    1.164721] wmi: Mapper loaded
[    1.164722] PCI: Using ACPI for IRQ routing
[    1.164724] PCI: pci_cache_line_size set to 64 bytes
[    1.164805] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    1.164806] reserve RAM buffer: 00000000da99f000 - 00000000dbffffff 
[    1.164808] reserve RAM buffer: 00000000db000000 - 00000000dbffffff 
[    1.164810] reserve RAM buffer: 000000021e600000 - 000000021fffffff 
[    1.164873] NetLabel: Initializing
[    1.164875] NetLabel:  domain hash size = 128
[    1.164876] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.164884] NetLabel:  unlabeled traffic allowed by default
[    1.164910] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.164915] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.166929] Switching to clocksource hpet
[    1.166964] Switched to NOHz mode on CPU #2
[    1.167000] Switched to NOHz mode on CPU #3
[    1.171309] AppArmor: AppArmor Filesystem Enabled
[    1.171327] pnp: PnP ACPI init
[    1.171338] ACPI: bus type pnp registered
[    1.171653] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    1.171655] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    1.171656] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    1.171657] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    1.171659] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    1.171660] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    1.171662] pnp 00:00: [mem 0x000d4000-0x000d7fff]
[    1.171663] pnp 00:00: [mem 0x000d8000-0x000dbfff]
[    1.171664] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    1.171665] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    1.171667] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    1.171668] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    1.171669] pnp 00:00: [mem 0x000ec000-0x000effff]
[    1.171671] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    1.171672] pnp 00:00: [mem 0x00100000-0xdf9fffff]
[    1.171673] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    1.171675] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    1.171721] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.171723] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    1.171725] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    1.171727] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    1.171728] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    1.171730] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    1.171732] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    1.171734] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    1.171735] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    1.171737] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    1.171739] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    1.171741] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    1.171743] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    1.171744] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    1.171746] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
[    1.171748] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    1.171750] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    1.171753] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.171769] pnp 00:01: [bus 00-fe]
[    1.171770] pnp 00:01: [io  0x0cf8-0x0cff]
[    1.171772] pnp 00:01: [io  0x0000-0x0cf7 window]
[    1.171773] pnp 00:01: [io  0x0d00-0xffff window]
[    1.171775] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    1.171776] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    1.171778] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    1.171779] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    1.171781] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    1.171782] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    1.171784] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    1.171785] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    1.171786] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    1.171788] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    1.171789] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    1.171791] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    1.171792] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    1.171794] pnp 00:01: [mem 0xdfa00000-0xfebfffff window]
[    1.171795] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    1.171841] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.171892] pnp 00:02: [io  0x0010-0x001f]
[    1.171893] pnp 00:02: [io  0x0090-0x009f]
[    1.171894] pnp 00:02: [io  0x0024-0x0025]
[    1.171896] pnp 00:02: [io  0x0028-0x0029]
[    1.171897] pnp 00:02: [io  0x002c-0x002d]
[    1.171898] pnp 00:02: [io  0x0030-0x0031]
[    1.171899] pnp 00:02: [io  0x0034-0x0035]
[    1.171901] pnp 00:02: [io  0x0038-0x0039]
[    1.171902] pnp 00:02: [io  0x003c-0x003d]
[    1.171903] pnp 00:02: [io  0x00a4-0x00a5]
[    1.171904] pnp 00:02: [io  0x00a8-0x00a9]
[    1.171905] pnp 00:02: [io  0x00ac-0x00ad]
[    1.171907] pnp 00:02: [io  0x00b0-0x00b5]
[    1.171908] pnp 00:02: [io  0x00b8-0x00b9]
[    1.171909] pnp 00:02: [io  0x00bc-0x00bd]
[    1.171910] pnp 00:02: [io  0x0050-0x0053]
[    1.171912] pnp 00:02: [io  0x0072-0x0077]
[    1.171913] pnp 00:02: [io  0x0400-0x047f]
[    1.171914] pnp 00:02: [io  0x0500-0x057f]
[    1.171915] pnp 00:02: [io  0x0800-0x080f]
[    1.171917] pnp 00:02: [io  0x15e0-0x15ef]
[    1.171918] pnp 00:02: [io  0x1600-0x167f]
[    1.171919] pnp 00:02: [mem 0xf8000000-0xfbffffff]
[    1.171921] pnp 00:02: [mem 0x00000000-0x00000fff]
[    1.171922] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    1.171923] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    1.171925] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    1.171926] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    1.171927] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    1.171975] system 00:02: [io  0x0400-0x047f] has been reserved
[    1.171977] system 00:02: [io  0x0500-0x057f] has been reserved
[    1.171979] system 00:02: [io  0x0800-0x080f] has been reserved
[    1.171982] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    1.171984] system 00:02: [io  0x1600-0x167f] has been reserved
[    1.171986] system 00:02: [mem 0xf8000000-0xfbffffff] has been reserved
[    1.171989] system 00:02: [mem 0x00000000-0x00000fff] could not be reserved
[    1.171991] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.171993] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    1.171995] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.171997] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.171999] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    1.172001] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.172034] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.172055] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.172061] pnp 00:04: [io  0x0000-0x000f]
[    1.172063] pnp 00:04: [io  0x0080-0x008f]
[    1.172064] pnp 00:04: [io  0x00c0-0x00df]
[    1.172066] pnp 00:04: [dma 4]
[    1.172086] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.172092] pnp 00:05: [io  0x0061]
[    1.172111] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.172117] pnp 00:06: [io  0x00f0]
[    1.172128] pnp 00:06: [irq 13]
[    1.172149] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.172155] pnp 00:07: [io  0x0070-0x0071]
[    1.172160] pnp 00:07: [irq 8]
[    1.172180] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.172186] pnp 00:08: [io  0x0060]
[    1.172187] pnp 00:08: [io  0x0064]
[    1.172192] pnp 00:08: [irq 1]
[    1.172213] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.172224] pnp 00:09: [irq 12]
[    1.172245] pnp 00:09: Plug and Play ACPI device, IDs LEN0020 PNP0f13 (active)
[    1.172270] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    1.172292] pnp 00:0a: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    1.172753] pnp: PnP ACPI: found 11 devices
[    1.172755] ACPI: ACPI bus type pnp unregistered
[    1.176861] Switched to NOHz mode on CPU #0
[    1.176906] Switched to NOHz mode on CPU #1
[    1.178362] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.178364] pci 0000:00:1c.0:   bridge window [io  disabled]
[    1.178369] pci 0000:00:1c.0:   bridge window [mem disabled]
[    1.178373] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    1.178379] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.178380] pci 0000:00:1c.1:   bridge window [io  disabled]
[    1.178385] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    1.178389] pci 0000:00:1c.1:   bridge window [mem pref disabled]
[    1.178395] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    1.178398] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    1.178404] pci 0000:00:1c.3:   bridge window [mem 0xf1d00000-0xf24fffff]
[    1.178408] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    1.178414] pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
[    1.178417] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    1.178422] pci 0000:00:1c.4:   bridge window [mem 0xf1500000-0xf1cfffff]
[    1.178427] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    1.178433] pci 0000:00:1c.6: PCI bridge to [bus 0e-0e]
[    1.178434] pci 0000:00:1c.6:   bridge window [io  disabled]
[    1.178439] pci 0000:00:1c.6:   bridge window [mem 0xf1400000-0xf14fffff]
[    1.178443] pci 0000:00:1c.6:   bridge window [mem pref disabled]
[    1.178462] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.178468] pci 0000:00:1c.0: setting latency timer to 64
[    1.178478] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.178482] pci 0000:00:1c.1: setting latency timer to 64
[    1.178492] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.178496] pci 0000:00:1c.3: setting latency timer to 64
[    1.178502] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.178506] pci 0000:00:1c.4: setting latency timer to 64
[    1.178516] pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.178520] pci 0000:00:1c.6: setting latency timer to 64
[    1.178524] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.178525] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.178527] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.178528] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff]
[    1.178530] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    1.178531] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
[    1.178533] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    1.178535] pci_bus 0000:05: resource 1 [mem 0xf1d00000-0xf24fffff]
[    1.178536] pci_bus 0000:05: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    1.178538] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    1.178539] pci_bus 0000:0d: resource 1 [mem 0xf1500000-0xf1cfffff]
[    1.178541] pci_bus 0000:0d: resource 2 [mem 0xf0c00000-0xf13fffff 64bit pref]
[    1.178543] pci_bus 0000:0e: resource 1 [mem 0xf1400000-0xf14fffff]
[    1.178561] NET: Registered protocol family 2
[    1.178750] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.180312] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.181391] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.181511] TCP: Hash tables configured (established 524288 bind 65536)
[    1.181513] TCP reno registered
[    1.181525] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    1.181555] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    1.181638] NET: Registered protocol family 1
[    1.181652] pci 0000:00:02.0: Boot video device
[    1.181764] PCI: CLS 64 bytes, default 64
[    1.181769] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.181771] Placing 64MB software IO TLB between ffff88001bc00000 - ffff88001fc00000
[    1.181773] software IO TLB at phys 0x1bc00000 - 0x1fc00000
[    1.182121] audit: initializing netlink socket (disabled)
[    1.182127] type=2000 audit(1315611036.040:1): initialized
[    1.192527] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.193687] VFS: Disk quotas dquot_6.5.2
[    1.193725] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.194134] fuse init (API version 7.16)
[    1.194192] msgmni has been set to 15765
[    1.194359] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.194380] io scheduler noop registered
[    1.194381] io scheduler deadline registered
[    1.194406] io scheduler cfq registered (default)
[    1.194683] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.194697] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.194726] intel_idle: MWAIT substates: 0x21120
[    1.194728] intel_idle: v0.4 model 0x2A
[    1.194729] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.194967] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    1.195128] ACPI: AC Adapter [AC] (on-line)
[    1.195213] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    1.346725] ACPI: Lid Switch [LID]
[    1.346828] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    1.436633] ACPI: Sleep Button [SLPB]
[    1.436745] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.436748] ACPI: Power Button [PWRF]
[    1.436837] ACPI: acpi_idle yielding to intel_idle
[    1.439309] thermal LNXTHERM:00: registered as thermal_zone0
[    1.439310] ACPI: Thermal Zone [THM0] (63 C)
[    1.439339] ERST: Table is not found!
[    1.439403] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.455493] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    1.455497] ACPI: Battery Slot [BAT0] (battery present)
[    1.467442] Linux agpgart interface v0.103
[    1.467505] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    1.467608] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    1.468771] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    1.468862] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    1.469583] brd: module loaded
[    1.469916] loop: module loaded
[    1.469976] i2c-core: driver [adp5520] using legacy suspend method
[    1.469977] i2c-core: driver [adp5520] using legacy resume method
[    1.470232] Fixed MDIO Bus: probed
[    1.470251] PPP generic driver version 2.4.2
[    1.470275] tun: Universal TUN/TAP device driver, 1.6
[    1.470276] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.470326] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.470339] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    1.470343] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    1.470350] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.470365] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.470368] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    1.470391] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.470445] ehci_hcd 0000:00:1a.0: debug port 2
[    1.474338] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    1.474353] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf262a000
[    1.496538] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.496704] hub 1-0:1.0: USB hub found
[    1.496707] hub 1-0:1.0: 3 ports detected
[    1.496755] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    1.496759] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    1.496771] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.496782] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.496785] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    1.496812] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.496852] ehci_hcd 0000:00:1d.0: debug port 2
[    1.500732] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    1.500743] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf2629000
[    1.516516] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.516670] hub 2-0:1.0: USB hub found
[    1.516672] hub 2-0:1.0: 3 ports detected
[    1.516716] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.516724] uhci_hcd: USB Universal Host Controller Interface driver
[    1.516794] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.520162] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.520167] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.520242] mousedev: PS/2 mouse device common for all mice
[    1.520346] rtc_cmos 00:07: RTC can wake from S4
[    1.520393] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    1.520418] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.520481] device-mapper: uevent: version 1.0.3
[    1.520530] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    1.520585] device-mapper: multipath: version 1.2.0 loaded
[    1.520586] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.520752] cpuidle: using governor ladder
[    1.520893] cpuidle: using governor menu
[    1.521039] TCP cubic registered
[    1.521118] NET: Registered protocol family 10
[    1.521423] NET: Registered protocol family 17
[    1.521433] Registering the dns_resolver key type
[    1.528283] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.528674] PM: Hibernation image not present or could not be loaded.
[    1.528680] registered taskstats version 1
[    1.528910]   Magic number: 11:612:554
[    1.528936] acpi PNP0C01:00: hash matches
[    1.528938] pci_link PNP0C0F:05: hash matches
[    1.529001] rtc_cmos 00:07: setting system clock to 2011-09-09 23:30:37 UTC (1315611037)
[    1.529003] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.529004] EDD information not available.
[    1.530046] Freeing unused kernel memory: 956k freed
[    1.530144] Write protecting the kernel read-only data: 10240k
[    1.530683] Freeing unused kernel memory: 184k freed
[    1.533552] Freeing unused kernel memory: 1440k freed
[    1.544029] <30>udev[68]: starting version 167
[    1.562299] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-k2
[    1.562302] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    1.562338] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.562350] e1000e 0000:00:19.0: setting latency timer to 64
[    1.562457] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[    1.578487] sdhci: Secure Digital Host Controller Interface driver
[    1.578491] sdhci: Copyright(c) Pierre Ossman
[    1.578522] xhci_hcd 0000:0e:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.578548] xhci_hcd 0000:0e:00.0: setting latency timer to 64
[    1.578552] xhci_hcd 0000:0e:00.0: xHCI Host Controller
[    1.578592] xhci_hcd 0000:0e:00.0: new USB bus registered, assigned bus number 3
[    1.579903] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e823] (rev 4)
[    1.579919] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.579943] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[    1.579954] mmc0: no vmmc regulator found
[    1.579981] Registered led device: mmc0::
[    1.580022] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[    1.626742] xhci_hcd 0000:0e:00.0: irq 18, io mem 0xf1400000
[    1.626819] xhci_hcd 0000:0e:00.0: irq 43 for MSI/MSI-X
[    1.626823] xhci_hcd 0000:0e:00.0: irq 44 for MSI/MSI-X
[    1.626827] xhci_hcd 0000:0e:00.0: irq 45 for MSI/MSI-X
[    1.626831] xhci_hcd 0000:0e:00.0: irq 46 for MSI/MSI-X
[    1.626834] xhci_hcd 0000:0e:00.0: irq 47 for MSI/MSI-X
[    1.630145] usb usb3: No SuperSpeed endpoint companion for config 1  interface 0 altsetting 0 ep 129: using minimum values
[    1.630226] xHCI xhci_add_endpoint called for root hub
[    1.630227] xHCI xhci_check_bandwidth called for root hub
[    1.630246] hub 3-0:1.0: USB hub found
[    1.630249] hub 3-0:1.0: 4 ports detected
[    1.816220] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    1.850978] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) f0:de:f1:7e:39:1b
[    1.850981] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.851032] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: 1000FF-0FF
[    1.851047] ahci 0000:00:1f.2: version 3.0
[    1.851060] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.851139] ahci 0000:00:1f.2: irq 48 for MSI/MSI-X
[    1.851163] ahci: SSS flag set, parallel bus scan disabled
[    1.866166] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x13 impl SATA mode
[    1.866178] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
[    1.866190] ahci 0000:00:1f.2: setting latency timer to 64
[    1.906657] scsi0 : ahci
[    1.906780] scsi1 : ahci
[    1.906872] scsi2 : ahci
[    1.906964] scsi3 : ahci
[    1.907056] scsi4 : ahci
[    1.907151] scsi5 : ahci
[    1.907455] ata1: SATA max UDMA/133 abar m2048@0xf2628000 port 0xf2628100 irq 48
[    1.907458] ata2: SATA max UDMA/133 abar m2048@0xf2628000 port 0xf2628180 irq 48
[    1.907459] ata3: DUMMY
[    1.907459] ata4: DUMMY
[    1.907462] ata5: SATA max UDMA/133 abar m2048@0xf2628000 port 0xf2628300 irq 48
[    1.907463] ata6: DUMMY
[    1.966798] hub 1-1:1.0: USB hub found
[    1.966890] hub 1-1:1.0: 6 ports detected
[    2.085886] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    2.175737] Refined TSC clocksource calibration: 2691.258 MHz.
[    2.175749] Switching to clocksource tsc
[    2.236309] hub 2-1:1.0: USB hub found
[    2.236413] hub 2-1:1.0: 8 ports detected
[    2.255645] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.256734] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.256745] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.256754] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.257736] ata1.00: ATA-8: HITACHI HTS723232A7A364, EC2ZB70B, max UDMA/100
[    2.257745] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.258905] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.258916] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.258924] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.259909] ata1.00: configured for UDMA/100
[    2.260070] scsi 0:0:0:0: Direct-Access     ATA      HITACHI HTS72323 EC2Z PQ: 0 ANSI: 5
[    2.260213] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.260246] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    2.260304] sd 0:0:0:0: [sda] Write Protect is off
[    2.260306] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.260324] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.288197]  sda: sda1 sda2 < sda5 >
[    2.288545] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.315772] usb 1-1.3: new full speed USB device using ehci_hcd and address 3
[    2.505517] usb 1-1.6: new high speed USB device using ehci_hcd and address 4
[    2.625105] ata2: SATA link down (SStatus 0 SControl 300)
[    2.974712] ata5: SATA link down (SStatus 0 SControl 300)
[    3.289405] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   11.854090] <30>udev[287]: starting version 167
[   11.863350] lp: driver loaded but no devices found
[   11.886091] Non-volatile memory driver v1.3
[   11.891663] tpm_tis 00:0a: 1.2 TPM (device-id 0x0, rev-id 78)
[   11.935873] Adding 8267772k swap on /dev/sda5.  Priority:-1 extents:1 across:8267772k 
[   11.946110] [drm] Initialized drm 1.1.0 20060810
[   11.981128] cfg80211: Calling CRDA to update world regulatory domain
[   11.997253] i915 0000:00:02.0: power state changed by ACPI to D0
[   11.997259] i915 0000:00:02.0: power state changed by ACPI to D0
[   11.997264] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   11.997268] i915 0000:00:02.0: setting latency timer to 64
[   12.021029] Linux video capture interface: v2.00
[   12.062025] mtrr: no more MTRRs available
[   12.062028] [drm] MTRR allocation failed.  Graphics performance may suffer.
[   12.062375] i915 0000:00:02.0: irq 49 for MSI/MSI-X
[   12.062379] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   12.062380] [drm] Driver supports precise vblank timestamp query.
[   12.090062] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   12.090064] thinkpad_acpi: http://ibm-acpi.sf.net/
[   12.090066] thinkpad_acpi: ThinkPad BIOS 8DET51WW (1.21 ), EC unknown
[   12.090068] thinkpad_acpi: Lenovo ThinkPad X220, model 4286CTO
[   12.092038] cfg80211: World regulatory domain updated:
[   12.092041] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   12.092043] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.092046] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   12.092048] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   12.092051] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.092053] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.097736] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   12.098094] thinkpad_acpi: radio switch found; radios are enabled
[   12.098232] thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
[   12.099859] Registered led device: tpacpi::thinklight
[   12.099945] Registered led device: tpacpi::power
[   12.100167] Registered led device: tpacpi::standby
[   12.100389] Registered led device: tpacpi::thinkvantage
[   12.100476] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[   12.100983] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   12.102445] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input4
[   12.124409] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b217)
[   12.136775] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   12.136778] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   12.136827] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   12.136837] iwlagn 0000:03:00.0: setting latency timer to 64
[   12.136870] iwlagn 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205 AGN, REV=0xB0
[   12.147387] iwlagn 0000:03:00.0: device EEPROM VER=0x715, CALIB=0x6
[   12.147390] iwlagn 0000:03:00.0: Device SKU: 0Xb
[   12.147392] iwlagn 0000:03:00.0: Valid Tx ant: 0X3, Valid Rx ant: 0X3
[   12.149631] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   12.149721] iwlagn 0000:03:00.0: irq 50 for MSI/MSI-X
[   12.162845] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input5
[   12.162891] usbcore: registered new interface driver uvcvideo
[   12.162893] USB Video Class driver (v1.0.0)
[   12.209558] iwlagn 0000:03:00.0: loaded firmware version 17.168.5.2 build 35905
[   12.209723] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain 
[   12.272606] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   12.293419] type=1400 audit(1315611048.273:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=488 comm="apparmor_parser"
[   12.293453] type=1400 audit(1315611048.273:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=488 comm="apparmor_parser"
[   12.293484] type=1400 audit(1315611048.273:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=488 comm="apparmor_parser"
[   12.308669] type=1400 audit(1315611048.283:5): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=386 comm="apparmor_parser"
[   12.308722] type=1400 audit(1315611048.283:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=386 comm="apparmor_parser"
[   12.308768] type=1400 audit(1315611048.283:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=386 comm="apparmor_parser"
[   12.336040] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   12.521245] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   12.528332] type=1400 audit(1315611048.503:8): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=617 comm="apparmor_parser"
[   12.528369] type=1400 audit(1315611048.503:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=617 comm="apparmor_parser"
[   12.528400] type=1400 audit(1315611048.503:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=617 comm="apparmor_parser"
[   12.581726] fbcon: inteldrmfb (fb0) is primary device
[   12.581787] Console: switching to colour frame buffer device 170x48
[   12.581805] fb0: inteldrmfb frame buffer device
[   12.581806] drm: registered panic notifier
[   12.644086] acpi device:01: registered as cooling_device4
[   12.644303] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
[   12.644410] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   12.644624] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   12.644669] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   12.644755] HDA Intel 0000:00:1b.0: irq 51 for MSI/MSI-X
[   12.644773] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.812143] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   12.871880] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   12.872467] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.944677] Synaptics Touchpad, model: 1, fw: 8.0, id: 0x1e2b1, caps: 0xd001a3/0x940300/0x120c00
[   12.944681] serio: Synaptics pass-through port at isa0060/serio1/input0
[   12.994365] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[   13.239993] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   13.405948] ppdev: user-space parallel port driver
[   13.602488] type=1400 audit(1315611049.583:11): apparmor="STATUS" operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" pid=829 comm="apparmor_parser"
[   16.218296] cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on phy0
[   18.438860] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
[   19.347278] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   19.594549] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input8
[   28.995479] wlan0: authenticate with b8:c7:5d:08:a2:f8 (try 1)
[   29.190817] wlan0: authenticate with b8:c7:5d:08:a2:f8 (try 2)
[   29.191685] wlan0: authenticated
[   29.191822] wlan0: associate with b8:c7:5d:08:a2:f8 (try 1)
[   29.192550] wlan0: RX AssocResp from b8:c7:5d:08:a2:f8 (capab=0x511 status=0 aid=4)
[   29.192553] wlan0: associated
[   29.196741] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   29.196793] cfg80211: Calling CRDA for country: US
[   29.198867] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[   29.198869] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
[   29.198871] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[   29.198872] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
[   29.198873] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[   29.198875] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
[   29.198876] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[   29.198877] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
[   29.198878] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[   29.198880] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
[   29.198881] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[   29.198882] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
[   29.198884] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[   29.198885] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
[   29.198886] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[   29.198888] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
[   29.198889] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[   29.198890] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
[   29.198891] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[   29.198893] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
[   29.198894] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[   29.198895] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2700 mBm)
[   29.198896] cfg80211: Disabling freq 2467 MHz
[   29.198897] cfg80211: Disabling freq 2472 MHz
[   29.198898] cfg80211: Updating information on frequency 5180 MHz for a 20 MHz width channel with regulatory rule:
[   29.198899] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (300 mBi, 1700 mBm)
[   29.198901] cfg80211: Updating information on frequency 5200 MHz for a 20 MHz width channel with regulatory rule:
[   29.198902] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (300 mBi, 1700 mBm)
[   29.198903] cfg80211: Updating information on frequency 5220 MHz for a 20 MHz width channel with regulatory rule:
[   29.198905] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (300 mBi, 1700 mBm)
[   29.198906] cfg80211: Updating information on frequency 5240 MHz for a 20 MHz width channel with regulatory rule:
[   29.198907] cfg80211: 5170000 KHz - 5250000 KHz @  KHz), (300 mBi, 1700 mBm)
[   29.198908] cfg80211: Updating information on frequency 5260 MHz for a 20 MHz width channel with regulatory rule:
[   29.198910] cfg80211: 5250000 KHz - 5330000 KHz @  KHz), (300 mBi, 2000 mBm)
[   29.198911] cfg80211: Updating information on frequency 5280 MHz for a 20 MHz width channel with regulatory rule:
[   29.198912] cfg80211: 5250000 KHz - 5330000 KHz @  KHz), (300 mBi, 2000 mBm)
[   29.198913] cfg80211: Updating information on frequency 5300 MHz for a 20 MHz width channel with regulatory rule:
[   29.198915] cfg80211: 5250000 KHz - 5330000 KHz @  KHz), (300 mBi, 2000 mBm)
[   29.198916] cfg80211: Updating information on frequency 5320 MHz for a 20 MHz width channel with regulatory rule:
[   29.198917] cfg80211: 5250000 KHz - 5330000 KHz @  KHz), (300 mBi, 2000 mBm)
[   29.198918] cfg80211: Updating information on frequency 5500 MHz for a 20 MHz width channel with regulatory rule:
[   29.198920] cfg80211: 5490000 KHz - 5600000 KHz @  KHz), (300 mBi, 2000 mBm)
[   29.198921] cfg80211: Updating information on frequency 5520 MHz for a 20 MHz width channel with regulatory rule:
[   29.198922] cfg80211: 5490000 KHz - 5600000 KHz @  KHz), (300 mBi, 2000 mBm)
[   29.198923] cfg80211: Updating information on frequency 5540 MHz for a 20 MHz width channel with regulatory rule:
[   29.198925] cfg80211: 5490000 KHz - 5600000 KHz @  KHz), (300 mBi, 2000 mBm)
[   29.198926] cfg80211: Updating information on frequency 5560 MHz for a 20 MHz width channel with regulatory rule:
[   29.198927] cfg80211: 5490000 KHz - 5600000 KHz @  KHz), (300 mBi, 2000 mBm)
[   29.198928] cfg80211: Updating information on frequency 5580 MHz for a 20 MHz width channel with regulatory rule:
[   29.198930] cfg80211: 5490000 KHz - 5600000 KHz @  KHz), (300 mBi, 2000 mBm)
[   29.198931] cfg80211: Disabling freq 5600 MHz
[   29.198931] cfg80211: Disabling freq 5620 MHz
[   29.198932] cfg80211: Disabling freq 5640 MHz
[   29.198933] cfg80211: Updating information on frequency 5660 MHz for a 20 MHz width channel with regulatory rule:
[   29.198935] cfg80211: 5650000 KHz - 5710000 KHz @  KHz), (300 mBi, 2000 mBm)
[   29.198936] cfg80211: Updating information on frequency 5680 MHz for a 20 MHz width channel with regulatory rule:
[   29.198937] cfg80211: 5650000 KHz - 5710000 KHz @  KHz), (300 mBi, 2000 mBm)
[   29.198938] cfg80211: Updating information on frequency 5700 MHz for a 20 MHz width channel with regulatory rule:
[   29.198940] cfg80211: 5650000 KHz - 5710000 KHz @  KHz), (300 mBi, 2000 mBm)
[   29.198941] cfg80211: Updating information on frequency 5745 MHz for a 20 MHz width channel with regulatory rule:
[   29.198942] cfg80211: 5735000 KHz - 5835000 KHz @  KHz), (300 mBi, 3000 mBm)
[   29.198943] cfg80211: Updating information on frequency 5765 MHz for a 20 MHz width channel with regulatory rule:
[   29.198945] cfg80211: 5735000 KHz - 5835000 KHz @  KHz), (300 mBi, 3000 mBm)
[   29.198946] cfg80211: Updating information on frequency 5785 MHz for a 20 MHz width channel with regulatory rule:
[   29.198947] cfg80211: 5735000 KHz - 5835000 KHz @  KHz), (300 mBi, 3000 mBm)
[   29.198948] cfg80211: Updating information on frequency 5805 MHz for a 20 MHz width channel with regulatory rule:
[   29.198950] cfg80211: 5735000 KHz - 5835000 KHz @  KHz), (300 mBi, 3000 mBm)
[   29.198951] cfg80211: Updating information on frequency 5825 MHz for a 20 MHz width channel with regulatory rule:
[   29.198952] cfg80211: 5735000 KHz - 5835000 KHz @  KHz), (300 mBi, 3000 mBm)
[   29.198955] cfg80211: Regulatory domain changed to country: US
[   29.198956] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   29.198957] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[   29.198958] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[   29.198960] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   29.198961] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   29.198962] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   29.198964] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[   29.309523] padlock_aes: VIA PadLock not detected.
[   39.677189] wlan0: no IPv6 routers present
[  149.577862] iwlagn 0000:03:00.0: Aggregation not enabled for tid 0 because load = 1
[  216.886558] iwlagn 0000:03:00.0: Aggregation not enabled for tid 0 because load = 0
[  217.293590] exe (1899): /proc/1899/oom_adj is deprecated, please use /proc/1899/oom_score_adj instead.
[  224.034144] iwlagn 0000:03:00.0: Aggregation not enabled for tid 0 because load = 5
[  227.124887] iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra = b8:c7:5d:08:a2:f8 tid = 0
