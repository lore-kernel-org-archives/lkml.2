Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab0LOClE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 21:41:04 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:38447 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab0LOCk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 21:40:58 -0500
Date: Tue, 14 Dec 2010 21:40:36 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jack Steiner <steiner@sgi.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, tony.luck@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Subject: Re: [PATCH] - Mapping ACPI tables as CACHED
In-reply-to: <4D081767.3050104@zytor.com>
Message-id: <alpine.LFD.2.00.1012142137210.4878@x980>
References: <20101214220932.GA1206@sgi.com>
 <alpine.LFD.2.00.1012141903210.25387@x980> <4D081767.3050104@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Where are the ACPI tables mapped from?  I'd like to get a feel for what
> the memory map looks like vs. the e820 data.

Here is the dmesg from a top of tree kernel on the arrandale.

[    0.000000] Linux version 2.6.37-rc5 (lenb@x980) (gcc version 4.4.5 20101112 (Red Hat 4.4.5-2) (GCC) ) #21 SMP Tue Dec 14 18:42:30 EST 2010
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
[    0.000000] ACPI: RSDP 00000000000f0410 00024 (v03 ALASKA)
[    0.000000] ACPI: XSDT 0000000077607080 00054 (v01 ALASKA   A M I  01072009 AMI  00010013)
[    0.000000] ACPI: FACP 000000007760fd78 000F4 (v04 ALASKA   A M I  01072009 AMI  00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20101013/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0x7762FE40/0x000000007762FE80, using 32 (20101013/tbfadt-486)
[    0.000000] ACPI: DSDT 0000000077607168 08C0D (v02 ALASKA   A M I  00000009 INTL 20051117)
[    0.000000] ACPI: FACS 000000007762fe40 00040
[    0.000000] ACPI: APIC 000000007760fe70 00072 (v01 ALASKA   A M I  01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 000000007760fee8 0050E (v01 AMICPU     PROC 00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 00000000776103f8 0003C (v01 ALASKA   A M I  01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0000000077610438 00038 (v01 ALASKA   A M I  01072009 AMI. 00000003)
[    0.000000] ACPI: ECDT 0000000077610470 000C1 (v01 ALASKA   A M I  01072009 AMI. 00000003)
[    0.000000] ACPI: Local APIC address 0xfee00000
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
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
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
[    0.000000] Memory: 1915692k/1957888k available (4247k kernel code, 1308k absent, 40888k reserved, 2920k data, 448k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:1280
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2659.848 MHz processor.
[    0.000007] Calibrating delay loop (skipped), value calculated using timer frequency.. 5319.69 BogoMIPS (lpj=2659848)
[    0.000261] pid_max: default: 32768 minimum: 301
[    0.000558] Mount-cache hash table entries: 256
[    0.000935] CPU: Physical Processor ID: 0
[    0.001059] CPU: Processor Core ID: 0
[    0.001185] mce: CPU supports 9 MCE banks
[    0.001321] CPU0: Thermal monitoring enabled (TM1)
[    0.001462] using mwait in idle threads.
[    0.001586] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.001905] ... version:                3
[    0.002029] ... bit width:              48
[    0.002152] ... generic registers:      4
[    0.002275] ... value mask:             0000ffffffffffff
[    0.002407] ... max period:             000000007fffffff
[    0.002533] ... fixed-purpose events:   3
[    0.002658] ... event mask:             000000070000000f
[    0.002855] ACPI: Core revision 20101013
[    0.022518] Setting APIC routing to flat
[    0.022989] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.033093] CPU0: Intel(R) Core(TM) i7 CPU       M 620  @ 2.67GHz stepping 02
[    0.135040] calling  migration_init+0x0/0x71 @ 1
[    0.135167] initcall migration_init+0x0/0x71 returned 0 after 0 usecs
[    0.135302] calling  spawn_ksoftirqd+0x0/0x57 @ 1
[    0.135454] initcall spawn_ksoftirqd+0x0/0x57 returned 0 after 0 usecs
[    0.135589] calling  init_workqueues+0x0/0x306 @ 1
[    0.135813] initcall init_workqueues+0x0/0x306 returned 0 after 0 usecs
[    0.135948] calling  init_call_single_data+0x0/0x89 @ 1
[    0.136081] initcall init_call_single_data+0x0/0x89 returned 0 after 0 usecs
[    0.136213] calling  cpu_stop_init+0x0/0xac @ 1
[    0.136361] initcall cpu_stop_init+0x0/0xac returned 0 after 0 usecs
[    0.136494] calling  tracer_alloc_buffers+0x0/0x170 @ 1
[    0.136650] initcall tracer_alloc_buffers+0x0/0x170 returned 0 after 0 usecs
[    0.136780] calling  init_trace_printk+0x0/0x12 @ 1
[    0.136904] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.137456] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.409384] Brought up 4 CPUs
[    0.409511] Total of 4 processors activated (21278.83 BogoMIPS).
[    0.410824] devtmpfs: initialized
[    0.411382] calling  init_mmap_min_addr+0x0/0x16 @ 1
[    0.411514] initcall init_mmap_min_addr+0x0/0x16 returned 0 after 0 usecs
[    0.411651] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.411787] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.412008] calling  net_ns_init+0x0/0x1ec @ 1
[    0.412138] initcall net_ns_init+0x0/0x1ec returned 0 after 0 usecs
[    0.412275] calling  cpufreq_tsc+0x0/0x37 @ 1
[    0.412404] initcall cpufreq_tsc+0x0/0x37 returned 0 after 0 usecs
[    0.412538] calling  pci_reboot_init+0x0/0x14 @ 1
[    0.412669] initcall pci_reboot_init+0x0/0x14 returned 0 after 0 usecs
[    0.412807] calling  init_lapic_sysfs+0x0/0x30 @ 1
[    0.413038] initcall init_lapic_sysfs+0x0/0x30 returned 0 after 0 usecs
[    0.413179] calling  init_smp_flush+0x0/0x38 @ 1
[    0.413310] initcall init_smp_flush+0x0/0x38 returned 0 after 0 usecs
[    0.413450] calling  sysctl_init+0x0/0x32 @ 1
[    0.413610] initcall sysctl_init+0x0/0x32 returned 0 after 0 usecs
[    0.413744] calling  ksysfs_init+0x0/0x94 @ 1
[    0.413881] initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
[    0.414016] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.414149] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.414366] calling  pm_init+0x0/0x5a @ 1
[    0.416924] initcall pm_init+0x0/0x5a returned 0 after 0 usecs
[    0.417059] calling  init_zero_pfn+0x0/0x35 @ 1
[    0.417187] initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
[    0.417322] calling  fsnotify_init+0x0/0x26 @ 1
[    0.417450] initcall fsnotify_init+0x0/0x26 returned 0 after 0 usecs
[    0.417584] calling  filelock_init+0x0/0x2e @ 1
[    0.417730] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
[    0.417865] calling  init_script_binfmt+0x0/0x14 @ 1
[    0.417995] initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.418131] calling  init_elf_binfmt+0x0/0x14 @ 1
[    0.418259] initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.418395] calling  init_compat_elf_binfmt+0x0/0x14 @ 1
[    0.418524] initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.418664] calling  debugfs_init+0x0/0x5c @ 1
[    0.418801] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
[    0.418933] calling  random32_init+0x0/0xd8 @ 1
[    0.419060] initcall random32_init+0x0/0xd8 returned 0 after 0 usecs
[    0.419194] calling  sfi_sysfs_init+0x0/0xd4 @ 1
[    0.419324] initcall sfi_sysfs_init+0x0/0xd4 returned 0 after 0 usecs
[    0.419458] calling  cpufreq_core_init+0x0/0xa3 @ 1
[    0.419591] initcall cpufreq_core_init+0x0/0xa3 returned 0 after 0 usecs
[    0.419726] calling  cpuidle_init+0x0/0x40 @ 1
[    0.419858] initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
[    0.419993] calling  sock_init+0x0/0x59 @ 1
[    0.420177] initcall sock_init+0x0/0x59 returned 0 after 0 usecs
[    0.420311] calling  netpoll_init+0x0/0x31 @ 1
[    0.420438] initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
[    0.420571] calling  netlink_proto_init+0x0/0x251 @ 1
[    0.420715] NET: Registered protocol family 16
[    0.420857] initcall netlink_proto_init+0x0/0x251 returned 0 after 0 usecs
[    0.420994] calling  bdi_class_init+0x0/0x4d @ 1
[    0.421189] initcall bdi_class_init+0x0/0x4d returned 0 after 0 usecs
[    0.421327] calling  kobject_uevent_init+0x0/0x21 @ 1
[    0.421465] initcall kobject_uevent_init+0x0/0x21 returned 0 after 0 usecs
[    0.421602] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.421788] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.421923] calling  pci_driver_init+0x0/0x12 @ 1
[    0.422107] initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
[    0.422243] calling  backlight_class_init+0x0/0x5d @ 1
[    0.422426] initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
[    0.422564] calling  video_output_class_init+0x0/0x19 @ 1
[    0.422744] initcall video_output_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.422958] calling  tty_class_init+0x0/0x38 @ 1
[    0.423134] initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
[    0.423269] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    0.423529] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 usecs
[    0.423665] calling  i2c_init+0x0/0x6b @ 1
[    0.423900] initcall i2c_init+0x0/0x6b returned 0 after 0 usecs
[    0.424037] calling  amd_postcore_init+0x0/0x77 @ 1
[    0.424166] initcall amd_postcore_init+0x0/0x77 returned 0 after 0 usecs
[    0.424304] calling  arch_kdebugfs_init+0x0/0x240 @ 1
[    0.424448] initcall arch_kdebugfs_init+0x0/0x240 returned 0 after 0 usecs
[    0.424585] calling  mtrr_if_init+0x0/0x78 @ 1
[    0.424716] initcall mtrr_if_init+0x0/0x78 returned 0 after 0 usecs
[    0.424850] calling  ffh_cstate_init+0x0/0x2a @ 1
[    0.424980] initcall ffh_cstate_init+0x0/0x2a returned 0 after 0 usecs
[    0.425116] calling  dynamic_debug_init+0x0/0x10b @ 1
[    0.425324] initcall dynamic_debug_init+0x0/0x10b returned 0 after 976 usecs
[    0.425462] calling  acpi_pci_init+0x0/0x5c @ 1
[    0.425591] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.425805] ACPI: bus type pci registered
[    0.425929] initcall acpi_pci_init+0x0/0x5c returned 0 after 0 usecs
[    0.426064] calling  dma_bus_init+0x0/0x3f @ 1
[    0.426247] initcall dma_bus_init+0x0/0x3f returned 0 after 0 usecs
[    0.426381] calling  dma_channel_table_init+0x0/0x116 @ 1
[    0.426521] initcall dma_channel_table_init+0x0/0x116 returned 0 after 0 usecs
[    0.426738] calling  dmi_id_init+0x0/0x361 @ 1
[    0.427010] initcall dmi_id_init+0x0/0x361 returned 0 after 0 usecs
[    0.427147] calling  pci_arch_init+0x0/0x69 @ 1
[    0.427310] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.427534] PCI: not using MMCONFIG
[    0.427658] PCI: Using configuration type 1 for base access
[    0.427791] initcall pci_arch_init+0x0/0x69 returned 0 after 976 usecs
[    0.427925] calling  topology_init+0x0/0x40 @ 1
[    0.428241] initcall topology_init+0x0/0x40 returned 0 after 0 usecs
[    0.428377] calling  mtrr_init_finialize+0x0/0x3d @ 1
[    0.428509] initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 usecs
[    0.428648] calling  init_vdso_vars+0x0/0x221 @ 1
[    0.428782] initcall init_vdso_vars+0x0/0x221 returned 0 after 0 usecs
[    0.428915] calling  sysenter_setup+0x0/0x2d8 @ 1
[    0.429044] initcall sysenter_setup+0x0/0x2d8 returned 0 after 0 usecs
[    0.429178] calling  param_sysfs_init+0x0/0x232 @ 1
[    0.437074] initcall param_sysfs_init+0x0/0x232 returned 0 after 6835 usecs
[    0.437215] calling  pm_sysrq_init+0x0/0x19 @ 1
[    0.437346] initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 usecs
[    0.437481] calling  default_bdi_init+0x0/0xa8 @ 1
[    0.437731] initcall default_bdi_init+0x0/0xa8 returned 0 after 0 usecs
[    0.437870] calling  init_bio+0x0/0x149 @ 1
[    0.438057] bio: create slab <bio-0> at 0
[    0.438205] initcall init_bio+0x0/0x149 returned 0 after 0 usecs
[    0.438340] calling  fsnotify_notification_init+0x0/0x8b @ 1
[    0.438546] initcall fsnotify_notification_init+0x0/0x8b returned 0 after 0 usecs
[    0.438762] calling  blk_settings_init+0x0/0x2a @ 1
[    0.438890] initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
[    0.439023] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.439162] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.439298] calling  blk_softirq_init+0x0/0x6e @ 1
[    0.439429] initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
[    0.439564] calling  blk_iopoll_setup+0x0/0x6e @ 1
[    0.439694] initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
[    0.439829] calling  genhd_device_init+0x0/0x7b @ 1
[    0.440063] initcall genhd_device_init+0x0/0x7b returned 0 after 0 usecs
[    0.440201] calling  pci_slot_init+0x0/0x46 @ 1
[    0.440334] initcall pci_slot_init+0x0/0x46 returned 0 after 0 usecs
[    0.440466] calling  fbmem_init+0x0/0x98 @ 1
[    0.440649] initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
[    0.440783] calling  acpi_init+0x0/0x116 @ 1
[    0.442766] ACPI: EC: EC description table is found, configuring boot EC
[    0.479313] ACPI: Executed 2 blocks of module-level executable AML code
[    0.490522] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.492023] ACPI: SSDT 0000000077628c18 0038C (v01    AMI      IST 00000001 MSFT 03000001)
[    0.492922] ACPI: Dynamic OEM Table Load:
[    0.493119] ACPI: SSDT           (null) 0038C (v01    AMI      IST 00000001 MSFT 03000001)
[    0.494767] ACPI: Interpreter enabled
[    0.494891] ACPI: (supports S0 S5)
[    0.495094] ACPI: Using IOAPIC for interrupt routing
[    0.495276] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.495621] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.548345] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.548602] initcall acpi_init+0x0/0x116 returned 0 after 105468 usecs
[    0.548737] calling  dock_init+0x0/0xa5 @ 1
[    0.549484] ACPI: No dock devices found.
[    0.549609] initcall dock_init+0x0/0xa5 returned 0 after 976 usecs
[    0.549741] calling  acpi_pci_root_init+0x0/0x2d @ 1
[    0.549869] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.550429] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.550818] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.550957] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.551098] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.551313] pci_root PNP0A08:00: host bridge window [mem 0x7c000000-0xffffffff]
[    0.551543] pci 0000:00:00.0: [8086:0044] type 0 class 0x000600
[    0.551690] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
[    0.551928] pci 0000:00:02.0: [8086:0046] type 0 class 0x000300
[    0.552067] pci 0000:00:02.0: reg 10: [mem 0xfb000000-0xfb3fffff 64bit]
[    0.552208] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.552347] pci 0000:00:02.0: reg 20: [io  0xf080-0xf087]
[    0.552532] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
[    0.552689] pci 0000:00:16.0: reg 10: [mem 0xfb609000-0xfb60900f 64bit]
[    0.552898] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.553038] pci 0000:00:16.0: PME# disabled
[    0.553202] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    0.553354] pci 0000:00:1a.0: reg 10: [mem 0xfb608000-0xfb6083ff]
[    0.553549] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.553683] pci 0000:00:1a.0: PME# disabled
[    0.553832] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    0.553978] pci 0000:00:1b.0: reg 10: [mem 0xfb600000-0xfb603fff 64bit]
[    0.554161] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.554295] pci 0000:00:1b.0: PME# disabled
[    0.554438] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    0.554623] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.554758] pci 0000:00:1c.0: PME# disabled
[    0.554905] pci 0000:00:1c.1: [8086:3b44] type 1 class 0x000604
[    0.555091] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.555225] pci 0000:00:1c.1: PME# disabled
[    0.555370] pci 0000:00:1c.2: [8086:3b46] type 1 class 0x000604
[    0.555553] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.555687] pci 0000:00:1c.2: PME# disabled
[    0.555835] pci 0000:00:1c.3: [8086:3b48] type 1 class 0x000604
[    0.556018] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.556153] pci 0000:00:1c.3: PME# disabled
[    0.556311] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    0.556463] pci 0000:00:1d.0: reg 10: [mem 0xfb607000-0xfb6073ff]
[    0.556659] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.556792] pci 0000:00:1d.0: PME# disabled
[    0.556935] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.557125] pci 0000:00:1f.0: [8086:3b09] type 0 class 0x000601
[    0.557368] pci 0000:00:1f.2: [8086:3b29] type 0 class 0x000106
[    0.559931] pci 0000:00:1f.2: reg 10: [io  0xf070-0xf077]
[    0.560073] pci 0000:00:1f.2: reg 14: [io  0xf060-0xf063]
[    0.560210] pci 0000:00:1f.2: reg 18: [io  0xf050-0xf057]
[    0.560347] pci 0000:00:1f.2: reg 1c: [io  0xf040-0xf043]
[    0.560484] pci 0000:00:1f.2: reg 20: [io  0xf020-0xf03f]
[    0.560622] pci 0000:00:1f.2: reg 24: [mem 0xfb606000-0xfb6067ff]
[    0.560795] pci 0000:00:1f.2: PME# supported from D3hot
[    0.560929] pci 0000:00:1f.2: PME# disabled
[    0.561081] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    0.561223] pci 0000:00:1f.3: reg 10: [mem 0xfb605000-0xfb6050ff 64bit]
[    0.561376] pci 0000:00:1f.3: reg 20: [io  0xf000-0xf01f]
[    0.561541] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
[    0.561695] pci 0000:00:1f.6: reg 10: [mem 0xfb604000-0xfb604fff 64bit]
[    0.561953] pci 0000:01:00.0: [8086:422b] type 0 class 0x000280
[    0.562114] pci 0000:01:00.0: reg 10: [mem 0xfb500000-0xfb501fff 64bit]
[    0.562367] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.562506] pci 0000:01:00.0: PME# disabled
[    0.562658] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.562789] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.562930] pci 0000:00:1c.0:   bridge window [mem 0xfb500000-0xfb5fffff]
[    0.563072] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.563327] pci 0000:00:1c.1: PCI bridge to [bus 02-03]
[    0.563458] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    0.563593] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfaffffff]
[    0.563732] pci 0000:00:1c.1:   bridge window [mem 0xd2000000-0xd2ffffff 64bit pref]
[    0.563987] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
[    0.564120] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.564256] pci 0000:00:1c.2:   bridge window [mem 0xf9000000-0xf9ffffff]
[    0.564394] pci 0000:00:1c.2:   bridge window [mem 0xd0000000-0xd0ffffff 64bit pref]
[    0.564669] pci 0000:06:00.0: [1969:1026] type 0 class 0x000200
[    0.564823] pci 0000:06:00.0: reg 10: [mem 0xfb400000-0xfb43ffff 64bit]
[    0.564969] pci 0000:06:00.0: reg 18: [io  0xc000-0xc07f]
[    0.565172] pci 0000:06:00.0: PME# supported from D3hot D3cold
[    0.565308] pci 0000:06:00.0: PME# disabled
[    0.565452] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.565680] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.565812] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    0.565947] pci 0000:00:1c.3:   bridge window [mem 0xfb400000-0xfb4fffff]
[    0.566086] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.566360] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
[    0.566500] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.566638] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.566856] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.567074] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.567292] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.567511] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.567730] pci 0000:00:1e.0:   bridge window [mem 0x7c000000-0xffffffff] (subtractive decode)
[    0.567967] pci_bus 0000:00: on NUMA node 0
[    0.568096] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.568713] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR20._PRT]
[    0.569070] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.569281] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.569537] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.569830] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.618464] initcall acpi_pci_root_init+0x0/0x2d returned 0 after 66406 usecs
[    0.618603] calling  acpi_pci_link_init+0x0/0x43 @ 1
[    0.618813] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.619437] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.620067] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.620656] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *4 5 6 10 11 12 14 15)
[    0.621251] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.621992] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.622727] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.623350] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.623971] initcall acpi_pci_link_init+0x0/0x43 returned 0 after 5859 usecs
[    0.624109] calling  pnp_init+0x0/0x12 @ 1
[    0.624288] initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
[    0.624420] calling  misc_init+0x0/0xb7 @ 1
[    0.624599] initcall misc_init+0x0/0xb7 returned 0 after 0 usecs
[    0.624733] calling  vga_arb_device_init+0x0/0x80 @ 1
[    0.624956] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.625181] vgaarb: loaded
[    0.625301] initcall vga_arb_device_init+0x0/0x80 returned 0 after 0 usecs
[    0.625437] calling  init_scsi+0x0/0x81 @ 1
[    0.625919] SCSI subsystem initialized
[    0.626043] initcall init_scsi+0x0/0x81 returned 0 after 976 usecs
[    0.626174] calling  ata_init+0x0/0x33a @ 1
[    0.626467] libata version 3.00 loaded.
[    0.626594] initcall ata_init+0x0/0x33a returned 0 after 0 usecs
[    0.626728] calling  phy_init+0x0/0x2e @ 1
[    0.627013] initcall phy_init+0x0/0x2e returned 0 after 0 usecs
[    0.627148] calling  init_pcmcia_cs+0x0/0x36 @ 1
[    0.627325] initcall init_pcmcia_cs+0x0/0x36 returned 0 after 0 usecs
[    0.627460] calling  usb_init+0x0/0x15f @ 1
[    0.627703] usbcore: registered new interface driver usbfs
[    0.627896] usbcore: registered new interface driver hub
[    0.628094] usbcore: registered new device driver usb
[    0.628225] initcall usb_init+0x0/0x15f returned 0 after 976 usecs
[    0.628358] calling  serio_init+0x0/0x86 @ 1
[    0.628557] initcall serio_init+0x0/0x86 returned 0 after 0 usecs
[    0.628692] calling  input_init+0x0/0x10c @ 1
[    0.628882] initcall input_init+0x0/0x10c returned 0 after 0 usecs
[    0.629018] calling  rtc_init+0x0/0x6c @ 1
[    0.629201] initcall rtc_init+0x0/0x6c returned 0 after 0 usecs
[    0.629335] calling  power_supply_class_init+0x0/0x44 @ 1
[    0.629515] initcall power_supply_class_init+0x0/0x44 returned 0 after 0 usecs
[    0.629731] calling  thermal_init+0x0/0x3f @ 1
[    0.629912] initcall thermal_init+0x0/0x3f returned 0 after 0 usecs
[    0.630046] calling  leds_init+0x0/0x48 @ 1
[    0.630219] initcall leds_init+0x0/0x48 returned 0 after 0 usecs
[    0.630352] calling  init_soundcore+0x0/0x95 @ 1
[    0.630529] initcall init_soundcore+0x0/0x95 returned 0 after 0 usecs
[    0.630660] calling  alsa_sound_init+0x0/0x95 @ 1
[    0.630814] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.630949] initcall alsa_sound_init+0x0/0x95 returned 0 after 0 usecs
[    0.631084] calling  pci_subsys_init+0x0/0x4d @ 1
[    0.631212] PCI: Using ACPI for IRQ routing
[    0.631338] PCI: pci_cache_line_size set to 64 bytes
[    0.631535] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    0.631593] reserve RAM buffer: 00000000775c2000 - 0000000077ffffff 
[    0.631766] reserve RAM buffer: 0000000077800000 - 0000000077ffffff 
[    0.631938] initcall pci_subsys_init+0x0/0x4d returned 0 after 976 usecs
[    0.632186] calling  proto_init+0x0/0x12 @ 1
[    0.632318] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    0.632453] calling  net_dev_init+0x0/0x1c2 @ 1
[    0.632824] initcall net_dev_init+0x0/0x1c2 returned 0 after 976 usecs
[    0.632962] calling  neigh_init+0x0/0x71 @ 1
[    0.633091] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
[    0.633223] calling  genl_init+0x0/0x84 @ 1
[    0.633369] initcall genl_init+0x0/0x84 returned 0 after 0 usecs
[    0.633504] calling  wireless_nlevent_init+0x0/0x12 @ 1
[    0.633636] initcall wireless_nlevent_init+0x0/0x12 returned 0 after 0 usecs
[    0.633773] calling  rfkill_init+0x0/0x79 @ 1
[    0.634014] initcall rfkill_init+0x0/0x79 returned 0 after 0 usecs
[    0.634146] calling  sysctl_init+0x0/0x48 @ 1
[    0.634271] initcall sysctl_init+0x0/0x48 returned 0 after 0 usecs
[    0.634406] calling  print_ICs+0x0/0x526 @ 1
[    0.634531] initcall print_ICs+0x0/0x526 returned 0 after 0 usecs
[    0.634665] calling  hpet_late_init+0x0/0xf7 @ 1
[    0.634804] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.635234] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.637370] initcall hpet_late_init+0x0/0xf7 returned 0 after 1953 usecs
[    0.637506] calling  init_k8_nbs+0x0/0x28 @ 1
[    0.637645] initcall init_k8_nbs+0x0/0x28 returned 0 after 0 usecs
[    0.637780] calling  clocksource_done_booting+0x0/0x5a @ 1
[    0.637914] Switching to clocksource tsc
[    0.638048] initcall clocksource_done_booting+0x0/0x5a returned 0 after 1 usecs
[    0.638262] calling  rb_init_debugfs+0x0/0x2f @ 1
[    0.638394] initcall rb_init_debugfs+0x0/0x2f returned 0 after 5 usecs
[    0.638528] calling  tracer_init_debugfs+0x0/0x348 @ 1
[    0.638781] initcall tracer_init_debugfs+0x0/0x348 returned 0 after 120 usecs
[    0.638920] calling  init_trace_printk_function_export+0x0/0x2f @ 1
[    0.639058] initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 2 usecs
[    0.639274] calling  event_trace_init+0x0/0x2c0 @ 1
[    0.642467] initcall event_trace_init+0x0/0x2c0 returned 0 after 2996 usecs
[    0.642607] calling  init_kprobe_trace+0x0/0x78 @ 1
[    0.642747] initcall init_kprobe_trace+0x0/0x78 returned 0 after 5 usecs
[    0.642882] calling  init_pipe_fs+0x0/0x4c @ 1
[    0.643027] initcall init_pipe_fs+0x0/0x4c returned 0 after 18 usecs
[    0.643162] calling  eventpoll_init+0x0/0xba @ 1
[    0.643322] initcall eventpoll_init+0x0/0xba returned 0 after 30 usecs
[    0.643455] calling  anon_inode_init+0x0/0x143 @ 1
[    0.643595] initcall anon_inode_init+0x0/0x143 returned 0 after 10 usecs
[    0.643734] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
[    0.643866] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
[    0.644000] calling  acpi_event_init+0x0/0x81 @ 1
[    0.644150] initcall acpi_event_init+0x0/0x81 returned 0 after 23 usecs
[    0.644287] calling  pnpacpi_init+0x0/0x8c @ 1
[    0.644414] pnp: PnP ACPI init
[    0.644550] ACPI: bus type pnp registered
[    0.644796] pnp 00:00: [bus 00-ff]
[    0.644922] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.645049] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.647602] pnp 00:00: [io  0x0d00-0xffff window]
[    0.647733] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.647862] pnp 00:00: [mem 0x00000000 window]
[    0.647988] pnp 00:00: [mem 0x7c000000-0xffffffff window]
[    0.648247] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.648594] pnp 00:01: [mem 0xfed14000-0xfed19fff]
[    0.648728] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.648856] pnp 00:01: [mem 0xfed90000-0xfed93fff]
[    0.648982] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    0.649109] pnp 00:01: [mem 0xfee00000-0xfee0ffff]
[    0.649318] pnp 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.649511] pnp 00:02: [dma 4]
[    0.649635] pnp 00:02: [io  0x0000-0x000f]
[    0.649765] pnp 00:02: [io  0x0081-0x0083]
[    0.649892] pnp 00:02: [io  0x0087]
[    0.650016] pnp 00:02: [io  0x0089-0x008b]
[    0.650143] pnp 00:02: [io  0x008f]
[    0.650267] pnp 00:02: [io  0x00c0-0x00df]
[    0.650464] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.650614] pnp 00:03: [io  0x0070-0x0071]
[    0.650749] pnp 00:03: [irq 8]
[    0.650943] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.651092] pnp 00:04: [io  0x0061]
[    0.651284] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.651452] pnp 00:05: [io  0x0010-0x001f]
[    0.651580] pnp 00:05: [io  0x0022-0x003f]
[    0.651714] pnp 00:05: [io  0x0044-0x005f]
[    0.651842] pnp 00:05: [io  0x0062-0x0063]
[    0.651969] pnp 00:05: [io  0x0065-0x006f]
[    0.652096] pnp 00:05: [io  0x0072-0x007f]
[    0.652221] pnp 00:05: [io  0x0080]
[    0.652344] pnp 00:05: [io  0x0084-0x0086]
[    0.652470] pnp 00:05: [io  0x0088]
[    0.652594] pnp 00:05: [io  0x008c-0x008e]
[    0.652722] pnp 00:05: [io  0x0090-0x009f]
[    0.652847] pnp 00:05: [io  0x00a2-0x00bf]
[    0.652971] pnp 00:05: [io  0x00e0-0x00ef]
[    0.653096] pnp 00:05: [io  0x04d0-0x04d1]
[    0.653311] pnp 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.653460] pnp 00:06: [io  0x00f0-0x00ff]
[    0.653592] pnp 00:06: [irq 13]
[    0.653787] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.653995] pnp 00:07: [irq 12]
[    0.654193] pnp 00:07: Plug and Play ACPI device, IDs STLc003 PNP0f03 (active)
[    0.654455] pnp 00:08: [io  0x0060]
[    0.654581] pnp 00:08: [io  0x0064]
[    0.654714] pnp 00:08: [irq 1]
[    0.654914] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.655600] pnp 00:09: [io  0x0400-0x047f]
[    0.655727] pnp 00:09: [io  0x1180-0x119f]
[    0.655853] pnp 00:09: [io  0x0500-0x057f]
[    0.655977] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
[    0.656105] pnp 00:09: [mem 0xfec00000-0xfecfffff]
[    0.656233] pnp 00:09: [mem 0xfed08000-0xfed08fff]
[    0.656361] pnp 00:09: [mem 0xff000000-0xffffffff]
[    0.656579] pnp 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.656966] pnp 00:0a: [mem 0xfed00000-0xfed003ff]
[    0.657184] pnp 00:0a: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.660067] pnp: PnP ACPI: found 11 devices
[    0.660195] ACPI: ACPI bus type pnp unregistered
[    0.660324] initcall pnpacpi_init+0x0/0x8c returned 0 after 15575 usecs
[    0.660459] calling  pnp_system_init+0x0/0x12 @ 1
[    0.660595] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
[    0.660736] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.660872] system 00:01: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.661009] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.661145] system 00:01: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.661283] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.661418] system 00:09: [io  0x0400-0x047f] has been reserved
[    0.661553] system 00:09: [io  0x1180-0x119f] has been reserved
[    0.661691] system 00:09: [io  0x0500-0x057f] has been reserved
[    0.661824] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.661959] system 00:09: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.662096] system 00:09: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.662233] system 00:09: [mem 0xff000000-0xffffffff] has been reserved
[    0.662422] initcall pnp_system_init+0x0/0x12 returned 0 after 1797 usecs
[    0.662561] calling  chr_dev_init+0x0/0xc5 @ 1
[    0.668407] initcall chr_dev_init+0x0/0xc5 returned 0 after 5593 usecs
[    0.668545] calling  firmware_class_init+0x0/0x19 @ 1
[    0.668733] initcall firmware_class_init+0x0/0x19 returned 0 after 50 usecs
[    0.668871] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    0.669004] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
[    0.669219] calling  cpufreq_gov_dbs_init+0x0/0xae @ 1
[    0.669378] initcall cpufreq_gov_dbs_init+0x0/0xae returned 0 after 28 usecs
[    0.669514] calling  init_acpi_pm_clocksource+0x0/0xdc @ 1
[    0.674153] initcall init_acpi_pm_clocksource+0x0/0xdc returned 0 after 4414 usecs
[    0.674370] calling  ssb_modinit+0x0/0x59 @ 1
[    0.674554] initcall ssb_modinit+0x0/0x59 returned 0 after 56 usecs
[    0.674691] calling  pcibios_assign_resources+0x0/0x74 @ 1
[    0.674864] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.674993] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.675125] pci 0000:00:1c.0:   bridge window [mem 0xfb500000-0xfb5fffff]
[    0.675261] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.675399] pci 0000:00:1c.1: PCI bridge to [bus 02-03]
[    0.675532] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    0.675669] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfaffffff]
[    0.675806] pci 0000:00:1c.1:   bridge window [mem 0xd2000000-0xd2ffffff 64bit pref]
[    0.676029] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
[    0.676160] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.676293] pci 0000:00:1c.2:   bridge window [mem 0xf9000000-0xf9ffffff]
[    0.676429] pci 0000:00:1c.2:   bridge window [mem 0xd0000000-0xd0ffffff 64bit pref]
[    0.676654] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.676785] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    0.676919] pci 0000:00:1c.3:   bridge window [mem 0xfb400000-0xfb4fffff]
[    0.677055] pci 0000:00:1c.3:   bridge window [mem pref disabled]
[    0.677192] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    0.677322] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.677457] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.677589] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.677740] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.677877] pci 0000:00:1c.0: setting latency timer to 64
[    0.678015] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.678153] pci 0000:00:1c.1: setting latency timer to 64
[    0.678288] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.678422] pci 0000:00:1c.2: setting latency timer to 64
[    0.678561] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.678699] pci 0000:00:1c.3: setting latency timer to 64
[    0.678836] pci 0000:00:1e.0: setting latency timer to 64
[    0.678967] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.679099] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.679230] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.679363] pci_bus 0000:00: resource 7 [mem 0x7c000000-0xffffffff]
[    0.679496] pci_bus 0000:01: resource 1 [mem 0xfb500000-0xfb5fffff]
[    0.679632] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.679767] pci_bus 0000:02: resource 1 [mem 0xfa000000-0xfaffffff]
[    0.679900] pci_bus 0000:02: resource 2 [mem 0xd2000000-0xd2ffffff 64bit pref]
[    0.680118] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.680250] pci_bus 0000:04: resource 1 [mem 0xf9000000-0xf9ffffff]
[    0.680386] pci_bus 0000:04: resource 2 [mem 0xd0000000-0xd0ffffff 64bit pref]
[    0.680603] pci_bus 0000:06: resource 0 [io  0xc000-0xcfff]
[    0.680733] pci_bus 0000:06: resource 1 [mem 0xfb400000-0xfb4fffff]
[    0.680866] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    0.680999] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    0.681131] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    0.681267] pci_bus 0000:07: resource 7 [mem 0x7c000000-0xffffffff]
[    0.681401] initcall pcibios_assign_resources+0x0/0x74 returned 0 after 6441 usecs
[    0.681617] calling  sysctl_core_init+0x0/0x38 @ 1
[    0.681765] initcall sysctl_core_init+0x0/0x38 returned 0 after 14 usecs
[    0.681901] calling  inet_init+0x0/0x27f @ 1
[    0.682108] NET: Registered protocol family 2
[    0.682310] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.682774] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.684162] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.684582] TCP: Hash tables configured (established 262144 bind 65536)
[    0.684720] TCP reno registered
[    0.684842] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.684986] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.685254] initcall inet_init+0x0/0x27f returned 0 after 3155 usecs
[    0.685388] calling  af_unix_init+0x0/0x55 @ 1
[    0.685530] NET: Registered protocol family 1
[    0.685667] initcall af_unix_init+0x0/0x55 returned 0 after 148 usecs
[    0.685803] calling  init_sunrpc+0x0/0x73 @ 1
[    0.686128] RPC: Registered udp transport module.
[    0.686257] RPC: Registered tcp transport module.
[    0.686385] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.686518] initcall init_sunrpc+0x0/0x73 returned 0 after 574 usecs
[    0.686655] calling  pci_apply_final_quirks+0x0/0x106 @ 1
[    0.686796] pci 0000:00:02.0: Boot video device
[    0.730550] PCI: CLS 64 bytes, default 64
[    0.730684] initcall pci_apply_final_quirks+0x0/0x106 returned 0 after 42978 usecs
[    0.730907] calling  populate_rootfs+0x0/0x100 @ 1
[    0.731229] initcall populate_rootfs+0x0/0x100 returned 0 after 186 usecs
[    0.731367] calling  pci_iommu_init+0x0/0x41 @ 1
[    0.731497] initcall pci_iommu_init+0x0/0x41 returned 0 after 0 usecs
[    0.731637] calling  i8259A_init_sysfs+0x0/0x31 @ 1
[    0.731892] initcall i8259A_init_sysfs+0x0/0x31 returned 0 after 120 usecs
[    0.732031] calling  vsyscall_init+0x0/0x6c @ 1
[    0.732170] initcall vsyscall_init+0x0/0x6c returned 0 after 8 usecs
[    0.734788] calling  sbf_init+0x0/0xe9 @ 1
[    0.734917] initcall sbf_init+0x0/0xe9 returned 0 after 0 usecs
[    0.735053] calling  i8237A_init_sysfs+0x0/0x22 @ 1
[    0.735282] initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 95 usecs
[    0.735421] calling  add_rtc_cmos+0x0/0x97 @ 1
[    0.735556] initcall add_rtc_cmos+0x0/0x97 returned 0 after 2 usecs
[    0.735695] calling  cache_sysfs_init+0x0/0x64 @ 1
[    0.736902] initcall cache_sysfs_init+0x0/0x64 returned 0 after 1051 usecs
[    0.737042] calling  mcheck_init_device+0x0/0x106 @ 1
[    0.737570] initcall mcheck_init_device+0x0/0x106 returned 0 after 386 usecs
[    0.737710] calling  threshold_init_device+0x0/0x8c @ 1
[    0.737843] initcall threshold_init_device+0x0/0x8c returned 0 after 0 usecs
[    0.737983] calling  thermal_throttle_init_device+0x0/0x9b @ 1
[    0.738124] initcall thermal_throttle_init_device+0x0/0x9b returned 0 after 6 usecs
[    0.738344] calling  msr_init+0x0/0x14a @ 1
[    0.738849] initcall msr_init+0x0/0x14a returned 0 after 367 usecs
[    0.738984] calling  cpuid_init+0x0/0x14a @ 1
[    0.739457] initcall cpuid_init+0x0/0x14a returned 0 after 335 usecs
[    0.739596] calling  ioapic_init_sysfs+0x0/0xb3 @ 1
[    0.739822] initcall ioapic_init_sysfs+0x0/0xb3 returned 0 after 92 usecs
[    0.739961] calling  add_pcspkr+0x0/0x3a @ 1
[    0.740155] initcall add_pcspkr+0x0/0x3a returned 0 after 63 usecs
[    0.740291] calling  microcode_init+0x0/0x138 @ 1
[    0.740486] microcode: CPU0 sig=0x20652, pf=0x10, revision=0x9
[    0.740624] microcode: CPU1 sig=0x20652, pf=0x10, revision=0x0
[    0.740763] microcode: CPU2 sig=0x20652, pf=0x10, revision=0x9
[    0.740898] microcode: CPU3 sig=0x20652, pf=0x10, revision=0x0
[    0.741105] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.741332] initcall microcode_init+0x0/0x138 returned 0 after 891 usecs
[    0.741470] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    0.741604] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 2 usecs
[    0.741741] calling  init_aout_binfmt+0x0/0x14 @ 1
[    0.741873] initcall init_aout_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.742011] calling  init_sched_debug_procfs+0x0/0x2c @ 1
[    0.742148] initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 4 usecs
[    0.742367] calling  proc_schedstat_init+0x0/0x22 @ 1
[    0.742503] initcall proc_schedstat_init+0x0/0x22 returned 0 after 2 usecs
[    0.742641] calling  proc_execdomains_init+0x0/0x22 @ 1
[    0.742776] initcall proc_execdomains_init+0x0/0x22 returned 0 after 2 usecs
[    0.742915] calling  ioresources_init+0x0/0x3c @ 1
[    0.743050] initcall ioresources_init+0x0/0x3c returned 0 after 4 usecs
[    0.743188] calling  uid_cache_init+0x0/0x87 @ 1
[    0.743335] initcall uid_cache_init+0x0/0x87 returned 0 after 17 usecs
[    0.743474] calling  init_posix_timers+0x0/0x17a @ 1
[    0.743621] initcall init_posix_timers+0x0/0x17a returned 0 after 13 usecs
[    0.743759] calling  init_posix_cpu_timers+0x0/0xe5 @ 1
[    0.743892] initcall init_posix_cpu_timers+0x0/0xe5 returned 0 after 0 usecs
[    0.744030] calling  nsproxy_cache_init+0x0/0x2d @ 1
[    0.744177] initcall nsproxy_cache_init+0x0/0x2d returned 0 after 13 usecs
[    0.744316] calling  create_proc_profile+0x0/0x245 @ 1
[    0.744448] initcall create_proc_profile+0x0/0x245 returned 0 after 0 usecs
[    0.744591] calling  timekeeping_init_device+0x0/0x22 @ 1
[    0.744823] initcall timekeeping_init_device+0x0/0x22 returned 0 after 95 usecs
[    0.745043] calling  init_clocksource_sysfs+0x0/0x50 @ 1
[    0.745271] initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 92 usecs
[    0.745493] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    0.745628] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 2 usecs
[    0.745767] calling  init_tstats_procfs+0x0/0x2c @ 1
[    0.745901] initcall init_tstats_procfs+0x0/0x2c returned 0 after 2 usecs
[    0.746039] calling  futex_init+0x0/0x68 @ 1
[    0.746172] initcall futex_init+0x0/0x68 returned 0 after 4 usecs
[    0.746307] calling  proc_dma_init+0x0/0x22 @ 1
[    0.746439] initcall proc_dma_init+0x0/0x22 returned 0 after 2 usecs
[    0.746576] calling  proc_modules_init+0x0/0x22 @ 1
[    0.746710] initcall proc_modules_init+0x0/0x22 returned 0 after 2 usecs
[    0.746849] calling  kallsyms_init+0x0/0x25 @ 1
[    0.746981] initcall kallsyms_init+0x0/0x25 returned 0 after 2 usecs
[    0.747117] calling  ikconfig_init+0x0/0x3a @ 1
[    0.747249] initcall ikconfig_init+0x0/0x3a returned 0 after 1 usecs
[    0.747385] calling  init_kprobes+0x0/0x163 @ 1
[    0.768209] initcall init_kprobes+0x0/0x163 returned 0 after 20258 usecs
[    0.768347] calling  hung_task_init+0x0/0x53 @ 1
[    0.768502] initcall hung_task_init+0x0/0x53 returned 0 after 22 usecs
[    0.768640] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    0.768780] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 7 usecs
[    0.768919] calling  init_tracepoints+0x0/0x12 @ 1
[    0.769049] initcall init_tracepoints+0x0/0x12 returned 0 after 0 usecs
[    0.769187] calling  init_lstats_procfs+0x0/0x25 @ 1
[    0.769320] initcall init_lstats_procfs+0x0/0x25 returned 0 after 3 usecs
[    0.769460] calling  init_events+0x0/0x61 @ 1
[    0.769591] initcall init_events+0x0/0x61 returned 0 after 1 usecs
[    0.769726] calling  init_sched_switch_trace+0x0/0x12 @ 1
[    0.769860] initcall init_sched_switch_trace+0x0/0x12 returned 0 after 0 usecs
[    0.770080] calling  init_per_zone_wmark_min+0x0/0x67 @ 1
[    0.770270] initcall init_per_zone_wmark_min+0x0/0x67 returned 0 after 55 usecs
[    0.770491] calling  kswapd_init+0x0/0x20 @ 1
[    0.770645] initcall kswapd_init+0x0/0x20 returned 0 after 24 usecs
[    0.770780] calling  setup_vmstat+0x0/0xc5 @ 1
[    0.770925] initcall setup_vmstat+0x0/0xc5 returned 0 after 14 usecs
[    0.771062] calling  mm_sysfs_init+0x0/0x29 @ 1
[    0.771195] initcall mm_sysfs_init+0x0/0x29 returned 0 after 3 usecs
[    0.771332] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    0.771468] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 2 usecs
[    0.771606] calling  procswaps_init+0x0/0x22 @ 1
[    0.771738] initcall procswaps_init+0x0/0x22 returned 0 after 2 usecs
[    0.771875] calling  slab_proc_init+0x0/0x3f @ 1
[    0.772010] initcall slab_proc_init+0x0/0x3f returned 0 after 4 usecs
[    0.772147] calling  cpucache_init+0x0/0x40 @ 1
[    0.772278] initcall cpucache_init+0x0/0x40 returned 0 after 0 usecs
[    0.772416] calling  fcntl_init+0x0/0x2a @ 1
[    0.772561] initcall fcntl_init+0x0/0x2a returned 0 after 15 usecs
[    0.772697] calling  proc_filesystems_init+0x0/0x22 @ 1
[    0.772832] initcall proc_filesystems_init+0x0/0x22 returned 0 after 2 usecs
[    0.772971] calling  fsnotify_mark_init+0x0/0x3d @ 1
[    0.773124] initcall fsnotify_mark_init+0x0/0x3d returned 0 after 20 usecs
[    0.773262] calling  dnotify_init+0x0/0x7b @ 1
[    0.773421] initcall dnotify_init+0x0/0x7b returned 0 after 29 usecs
[    0.773559] calling  inotify_user_setup+0x0/0x70 @ 1
[    0.773721] initcall inotify_user_setup+0x0/0x70 returned 0 after 29 usecs
[    0.773858] calling  aio_setup+0x0/0xbd @ 1
[    0.774039] initcall aio_setup+0x0/0xbd returned 0 after 52 usecs
[    0.774174] calling  proc_locks_init+0x0/0x22 @ 1
[    0.774308] initcall proc_locks_init+0x0/0x22 returned 0 after 2 usecs
[    0.774448] calling  init_sys32_ioctl+0x0/0x28 @ 1
[    0.774654] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 73 usecs
[    0.774791] calling  init_mbcache+0x0/0x14 @ 1
[    0.774920] initcall init_mbcache+0x0/0x14 returned 0 after 0 usecs
[    0.775056] calling  proc_cmdline_init+0x0/0x22 @ 1
[    0.775189] initcall proc_cmdline_init+0x0/0x22 returned 0 after 2 usecs
[    0.775326] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    0.775460] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 2 usecs
[    0.775599] calling  proc_devices_init+0x0/0x22 @ 1
[    0.775733] initcall proc_devices_init+0x0/0x22 returned 0 after 2 usecs
[    0.775871] calling  proc_interrupts_init+0x0/0x22 @ 1
[    0.776005] initcall proc_interrupts_init+0x0/0x22 returned 0 after 2 usecs
[    0.776143] calling  proc_loadavg_init+0x0/0x22 @ 1
[    0.776277] initcall proc_loadavg_init+0x0/0x22 returned 0 after 2 usecs
[    0.776416] calling  proc_meminfo_init+0x0/0x22 @ 1
[    0.776549] initcall proc_meminfo_init+0x0/0x22 returned 0 after 2 usecs
[    0.776686] calling  proc_stat_init+0x0/0x22 @ 1
[    0.776819] initcall proc_stat_init+0x0/0x22 returned 0 after 2 usecs
[    0.776955] calling  proc_uptime_init+0x0/0x22 @ 1
[    0.777090] initcall proc_uptime_init+0x0/0x22 returned 0 after 4 usecs
[    0.777227] calling  proc_version_init+0x0/0x22 @ 1
[    0.777360] initcall proc_version_init+0x0/0x22 returned 0 after 2 usecs
[    0.777499] calling  proc_softirqs_init+0x0/0x22 @ 1
[    0.777634] initcall proc_softirqs_init+0x0/0x22 returned 0 after 2 usecs
[    0.777772] calling  proc_kcore_init+0x0/0xa9 @ 1
[    0.777909] initcall proc_kcore_init+0x0/0xa9 returned 0 after 5 usecs
[    0.778045] calling  proc_kmsg_init+0x0/0x25 @ 1
[    0.778178] initcall proc_kmsg_init+0x0/0x25 returned 0 after 2 usecs
[    0.778314] calling  proc_page_init+0x0/0x42 @ 1
[    0.778450] initcall proc_page_init+0x0/0x42 returned 0 after 4 usecs
[    0.778588] calling  init_devpts_fs+0x0/0x4c @ 1
[    0.778733] initcall init_devpts_fs+0x0/0x4c returned 0 after 14 usecs
[    0.778871] calling  init_reiserfs_fs+0x0/0x63 @ 1
[    0.779015] initcall init_reiserfs_fs+0x0/0x63 returned 0 after 13 usecs
[    0.779153] calling  init_ext3_fs+0x0/0x72 @ 1
[    0.779316] initcall init_ext3_fs+0x0/0x72 returned 0 after 33 usecs
[    0.779455] calling  init_ext2_fs+0x0/0x71 @ 1
[    0.779619] initcall init_ext2_fs+0x0/0x71 returned 0 after 33 usecs
[    0.779756] calling  ext4_init_fs+0x0/0x138 @ 1
[    0.780016] initcall ext4_init_fs+0x0/0x138 returned 0 after 126 usecs
[    0.780153] calling  journal_init+0x0/0x99 @ 1
[    0.780337] initcall journal_init+0x0/0x99 returned 0 after 53 usecs
[    0.780475] calling  journal_init+0x0/0xaf @ 1
[    0.780662] initcall journal_init+0x0/0xaf returned 0 after 56 usecs
[    0.780799] calling  init_ramfs_fs+0x0/0x12 @ 1
[    0.780930] initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
[    0.781066] calling  init_fat_fs+0x0/0x4f @ 1
[    0.781223] initcall init_fat_fs+0x0/0x4f returned 0 after 27 usecs
[    0.781359] calling  init_vfat_fs+0x0/0x12 @ 1
[    0.781493] initcall init_vfat_fs+0x0/0x12 returned 0 after 0 usecs
[    0.781629] calling  init_msdos_fs+0x0/0x12 @ 1
[    0.781760] initcall init_msdos_fs+0x0/0x12 returned 0 after 0 usecs
[    0.781896] calling  init_iso9660_fs+0x0/0x63 @ 1
[    0.782042] initcall init_iso9660_fs+0x0/0x63 returned 0 after 15 usecs
[    0.782180] calling  init_nfs_fs+0x0/0x145 @ 1
[    0.782583] initcall init_nfs_fs+0x0/0x145 returned 0 after 266 usecs
[    0.782720] calling  init_nfsd+0x0/0xbb @ 1
[    0.782847] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.783479] initcall init_nfsd+0x0/0xbb returned 0 after 616 usecs
[    0.783615] calling  init_nlm+0x0/0x22 @ 1
[    0.786234] initcall init_nlm+0x0/0x22 returned 0 after 6 usecs
[    0.786370] calling  init_nls_cp437+0x0/0x12 @ 1
[    0.786502] initcall init_nls_cp437+0x0/0x12 returned 0 after 0 usecs
[    0.786638] calling  init_nls_ascii+0x0/0x12 @ 1
[    0.786768] initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
[    0.786905] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    0.787037] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 usecs
[    0.787175] calling  init_nls_iso8859_15+0x0/0x12 @ 1
[    0.787307] initcall init_nls_iso8859_15+0x0/0x12 returned 0 after 0 usecs
[    0.787447] calling  init_nls_utf8+0x0/0x29 @ 1
[    0.787577] initcall init_nls_utf8+0x0/0x29 returned 0 after 0 usecs
[    0.787713] calling  init_autofs4_fs+0x0/0x26 @ 1
[    0.787922] initcall init_autofs4_fs+0x0/0x26 returned 0 after 74 usecs
[    0.788059] calling  ipc_init+0x0/0x23 @ 1
[    0.788192] msgmni has been set to 3741
[    0.788325] initcall ipc_init+0x0/0x23 returned 0 after 134 usecs
[    0.788464] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    0.788607] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 11 usecs
[    0.788745] calling  init_mqueue_fs+0x0/0xb4 @ 1
[    0.788910] initcall init_mqueue_fs+0x0/0xb4 returned 0 after 32 usecs
[    0.789046] calling  proc_genhd_init+0x0/0x3c @ 1
[    0.789181] initcall proc_genhd_init+0x0/0x3c returned 0 after 4 usecs
[    0.789318] calling  noop_init+0x0/0x14 @ 1
[    0.789449] io scheduler noop registered
[    0.789575] initcall noop_init+0x0/0x14 returned 0 after 124 usecs
[    0.789710] calling  deadline_init+0x0/0x14 @ 1
[    0.789840] io scheduler deadline registered
[    0.789968] initcall deadline_init+0x0/0x14 returned 0 after 125 usecs
[    0.790104] calling  cfq_init+0x0/0x9e @ 1
[    0.790262] io scheduler cfq registered (default)
[    0.790394] initcall cfq_init+0x0/0x9e returned 0 after 158 usecs
[    0.790529] calling  percpu_counter_startup+0x0/0x19 @ 1
[    0.790661] initcall percpu_counter_startup+0x0/0x19 returned 0 after 0 usecs
[    0.790800] calling  dynamic_debug_init_debugfs+0x0/0x6a @ 1
[    0.790941] initcall dynamic_debug_init_debugfs+0x0/0x6a returned 0 after 6 usecs
[    0.791161] calling  pci_proc_init+0x0/0x6a @ 1
[    0.791353] initcall pci_proc_init+0x0/0x6a returned 0 after 61 usecs
[    0.791490] calling  pcie_portdrv_init+0x0/0x6d @ 1
[    0.792401] pcieport 0000:00:1c.0: ACPI _OSC control granted for 0x1c
[    0.792549] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.792718] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.793609] pcieport 0000:00:1c.1: ACPI _OSC control granted for 0x1c
[    0.793753] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.793918] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.794804] pcieport 0000:00:1c.2: ACPI _OSC control granted for 0x1c
[    0.794948] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.795113] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    0.796003] pcieport 0000:00:1c.3: ACPI _OSC control granted for 0x1c
[    0.796146] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.796311] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    0.796600] initcall pcie_portdrv_init+0x0/0x6d returned 0 after 4874 usecs
[    0.796739] calling  aer_service_init+0x0/0x22 @ 1
[    0.796920] initcall aer_service_init+0x0/0x22 returned 0 after 48 usecs
[    0.797058] calling  pcie_pme_service_init+0x0/0x12 @ 1
[    0.797219] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.797361] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.797500] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.797660] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    0.797800] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    0.797962] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    0.798102] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
[    0.798260] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    0.798401] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
[    0.798540] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    0.798726] initcall pcie_pme_service_init+0x0/0x12 returned 0 after 1503 usecs
[    0.798946] calling  ioapic_init+0x0/0x1b @ 1
[    0.799132] initcall ioapic_init+0x0/0x1b returned 0 after 55 usecs
[    0.799268] calling  genericbl_init+0x0/0x12 @ 1
[    0.799452] initcall genericbl_init+0x0/0x12 returned 0 after 49 usecs
[    0.799589] calling  intel_idle_init+0x0/0x300 @ 1
[    0.799719] intel_idle: MWAIT substates: 0x1120
[    0.799848] intel_idle: v0.4 model 0x25
[    0.799975] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.800298] initcall intel_idle_init+0x0/0x300 returned 0 after 565 usecs
[    0.800439] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    0.800577] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 4 usecs
[    0.800716] calling  irqrouter_init_sysfs+0x0/0x38 @ 1
[    0.800941] initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 90 usecs
[    0.801081] calling  acpi_button_init+0x0/0x56 @ 1
[    0.801363] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0A08:00/PNP0C0D:00/input/input0
[    0.916115] ACPI: Lid Switch [LID]
[    0.916351] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.916577] ACPI: Sleep Button [SLPB]
[    0.916802] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    0.917030] ACPI: Power Button [PWRB]
[    0.917264] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.917484] ACPI: Power Button [PWRF]
[    0.917666] initcall acpi_button_init+0x0/0x56 returned 0 after 114015 usecs
[    0.917806] calling  acpi_processor_init+0x0/0x10b @ 1
[    0.917940] ACPI: acpi_idle yielding to intel_idle
[    0.919483] initcall acpi_processor_init+0x0/0x10b returned 0 after 1510 usecs
[    0.919704] calling  acpi_container_init+0x0/0x4a @ 1
[    0.924692] initcall acpi_container_init+0x0/0x4a returned 0 after 4753 usecs
[    0.924832] calling  acpi_battery_init+0x0/0x16 @ 1
[    0.924965] initcall acpi_battery_init+0x0/0x16 returned 0 after 2 usecs
[    0.924970] calling  1_acpi_battery_init_async+0x0/0x3c @ 5
[    0.925244] calling  pty_init+0x0/0x50d @ 1
[    0.962930] power_supply BAT0: uevent
[    0.963059] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    0.973567] initcall pty_init+0x0/0x50d returned 0 after 47182 usecs
[    0.973705] calling  sysrq_init+0x0/0x78 @ 1
[    0.973841] initcall sysrq_init+0x0/0x78 returned 0 after 7 usecs
[    0.973985] calling  rand_initialize+0x0/0x2c @ 1
[    0.974123] initcall rand_initialize+0x0/0x2c returned 0 after 9 usecs
[    0.974260] calling  raw_init+0x0/0xe5 @ 1
[    0.974544] initcall raw_init+0x0/0xe5 returned 0 after 151 usecs
[    0.974681] calling  hpet_init+0x0/0x6a @ 1
[    0.998033] power_supply BAT0: prop STATUS=Unknown
[    0.998165] power_supply BAT0: prop PRESENT=1
[    0.998295] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    0.998427] power_supply BAT0: prop CYCLE_COUNT=0
[    0.998558] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[    0.998693] power_supply BAT0: prop VOLTAGE_NOW=12428000
[    0.998828] power_supply BAT0: prop CURRENT_NOW=0
[    0.998960] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[    0.999095] power_supply BAT0: prop CHARGE_FULL=4508000
[    0.999227] power_supply BAT0: prop CHARGE_NOW=4407000
[    0.999359] power_supply BAT0: prop MODEL_NAME=SP624
[    0.999490] power_supply BAT0: prop MANUFACTURER=PEGATRON
[    0.999623] power_supply BAT0: prop SERIAL_NUMBER= 
[    0.999803] power_supply BAT0: power_supply_changed
[    0.999941] power_supply BAT0: power_supply_changed_work
[    1.000071] power_supply BAT0: power_supply_update_bat_leds 0
[    1.000214] power_supply BAT0: uevent
[    1.000340] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    1.000473] power_supply BAT0: prop STATUS=Unknown
[    1.000604] power_supply BAT0: prop PRESENT=1
[    1.000734] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    1.000867] power_supply BAT0: prop CYCLE_COUNT=0
[    1.000946] ACPI: Battery Slot [BAT0] (battery present)
[    1.001037] initcall 1_acpi_battery_init_async+0x0/0x3c returned 0 after 74469 usecs
[    1.001141] initcall hpet_init+0x0/0x6a returned 0 after 25779 usecs
[    1.001143] calling  timeriomem_rng_init+0x0/0x12 @ 1
[    1.001203] initcall timeriomem_rng_init+0x0/0x12 returned 0 after 54 usecs
[    1.001205] calling  mod_init+0x0/0x22e @ 1
[    1.001246] initcall mod_init+0x0/0x22e returned -19 after 37 usecs
[    1.001247] calling  mod_init+0x0/0xba @ 1
[    1.001262] initcall mod_init+0x0/0xba returned -19 after 12 usecs
[    1.001264] calling  mod_init+0x0/0x5a @ 1
[    1.001266] initcall mod_init+0x0/0x5a returned -19 after 0 usecs
[    1.001268] calling  agp_init+0x0/0x26 @ 1
[    1.001269] Linux agpgart interface v0.103
[    1.001271] initcall agp_init+0x0/0x26 returned 0 after 1 usecs
[    1.001273] calling  agp_amd64_mod_init+0x0/0x22 @ 1
[    1.001347] initcall agp_amd64_mod_init+0x0/0x22 returned -19 after 69 usecs
[    1.001349] calling  agp_intel_init+0x0/0x29 @ 1
[    1.001407] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    1.001469] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
[    1.004127] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[    1.004236] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    1.004406] power_supply BAT0: prop VOLTAGE_NOW=12428000
[    1.004541] power_supply BAT0: prop CURRENT_NOW=0
[    1.004668] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[    1.004796] power_supply BAT0: prop CHARGE_FULL=4508000
[    1.004927] power_supply BAT0: prop CHARGE_NOW=4407000
[    1.005056] power_supply BAT0: prop MODEL_NAME=SP624
[    1.005182] power_supply BAT0: prop MANUFACTURER=PEGATRON
[    1.005312] power_supply BAT0: prop SERIAL_NUMBER= 
[    1.020855] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    1.021065] initcall agp_intel_init+0x0/0x29 returned 0 after 19295 usecs
[    1.021204] calling  serial8250_init+0x0/0x183 @ 1
[    1.021335] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.022125] initcall serial8250_init+0x0/0x183 returned 0 after 772 usecs
[    1.022264] calling  serial8250_pnp_init+0x0/0x12 @ 1
[    1.022527] initcall serial8250_pnp_init+0x0/0x12 returned 0 after 126 usecs
[    1.022666] calling  serial8250_pci_init+0x0/0x1b @ 1
[    1.022869] initcall serial8250_pci_init+0x0/0x1b returned 0 after 69 usecs
[    1.023011] calling  topology_sysfs_init+0x0/0x50 @ 1
[    1.023170] initcall topology_sysfs_init+0x0/0x50 returned 0 after 26 usecs
[    1.023310] calling  brd_init+0x0/0x1a5 @ 1
[    1.026254] brd: module loaded
[    1.028864] initcall brd_init+0x0/0x1a5 returned 0 after 5311 usecs
[    1.029000] calling  loop_init+0x0/0x1b2 @ 1
[    1.030535] loop: module loaded
[    1.030661] initcall loop_init+0x0/0x1b2 returned 0 after 1499 usecs
[    1.030802] calling  spi_transport_init+0x0/0x79 @ 1
[    1.031043] initcall spi_transport_init+0x0/0x79 returned 0 after 104 usecs
[    1.031183] calling  fc_transport_init+0x0/0x8a @ 1
[    1.031503] initcall fc_transport_init+0x0/0x8a returned 0 after 184 usecs
[    1.031642] calling  ahd_linux_init+0x0/0x80 @ 1
[    1.031843] initcall ahd_linux_init+0x0/0x80 returned 0 after 67 usecs
[    1.031980] calling  init_sd+0x0/0x142 @ 1
[    1.032243] initcall init_sd+0x0/0x142 returned 0 after 132 usecs
[    1.032380] calling  init_sr+0x0/0x46 @ 1
[    1.032561] initcall init_sr+0x0/0x46 returned 0 after 51 usecs
[    1.032695] calling  init_sg+0x0/0xc6 @ 1
[    1.032882] initcall init_sg+0x0/0xc6 returned 0 after 53 usecs
[    1.033016] calling  ahci_init+0x0/0x1b @ 1
[    1.033158] ahci 0000:00:1f.2: version 3.0
[    1.033300] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.033483] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    1.044786] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    1.045009] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck pm led clo pio slum part ems sxs apst 
[    1.045236] ahci 0000:00:1f.2: setting latency timer to 64
[    1.052171] scsi0 : ahci
[    1.052500] scsi1 : ahci
[    1.052782] scsi2 : ahci
[    1.053064] scsi3 : ahci
[    1.053345] scsi4 : ahci
[    1.053629] scsi5 : ahci
[    1.054120] ata1: SATA max UDMA/133 abar m2048@0xfb606000 port 0xfb606100 irq 44
[    1.054340] ata2: SATA max UDMA/133 abar m2048@0xfb606000 port 0xfb606180 irq 44
[    1.054559] ata3: DUMMY
[    1.054680] ata4: DUMMY
[    1.054805] ata5: SATA max UDMA/133 abar m2048@0xfb606000 port 0xfb606300 irq 44
[    1.055024] ata6: SATA max UDMA/133 abar m2048@0xfb606000 port 0xfb606380 irq 44
[    1.055253] calling  2_async_port_probe+0x0/0xad @ 5
[    1.055256] calling  3_async_port_probe+0x0/0xad @ 18
[    1.055291] calling  4_async_port_probe+0x0/0xad @ 559
[    1.055298] async_waiting @ 559
[    1.055315] calling  5_async_port_probe+0x0/0xad @ 1187
[    1.055321] async_waiting @ 1187
[    1.055339] calling  6_async_port_probe+0x0/0xad @ 1188
[    1.055370] calling  7_async_port_probe+0x0/0xad @ 1189
[    1.055441] initcall ahci_init+0x0/0x1b returned 0 after 21828 usecs
[    1.055444] calling  piix_init+0x0/0x29 @ 1
[    1.055509] initcall piix_init+0x0/0x29 returned 0 after 61 usecs
[    1.055511] calling  nv_init+0x0/0x1b @ 1
[    1.055577] initcall nv_init+0x0/0x1b returned 0 after 62 usecs
[    1.055580] calling  sil_init+0x0/0x1b @ 1
[    1.055641] initcall sil_init+0x0/0x1b returned 0 after 57 usecs
[    1.055644] calling  k2_sata_init+0x0/0x1b @ 1
[    1.055705] initcall k2_sata_init+0x0/0x1b returned 0 after 57 usecs
[    1.055707] calling  svia_init+0x0/0x1b @ 1
[    1.055831] initcall svia_init+0x0/0x1b returned 0 after 118 usecs
[    1.055833] calling  amd_init+0x0/0x1b @ 1
[    1.055892] initcall amd_init+0x0/0x1b returned 0 after 55 usecs
[    1.055895] calling  pacpi_init+0x0/0x1b @ 1
[    1.055952] initcall pacpi_init+0x0/0x1b returned 0 after 53 usecs
[    1.055955] calling  ata_generic_init+0x0/0x1b @ 1
[    1.056016] initcall ata_generic_init+0x0/0x1b returned 0 after 57 usecs
[    1.056019] calling  e1000_init_module+0x0/0x87 @ 1
[    1.056020] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.056021] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.056084] initcall e1000_init_module+0x0/0x87 returned 0 after 61 usecs
[    1.056086] calling  vortex_init+0x0/0xac @ 1
[    1.056146] initcall vortex_init+0x0/0xac returned 0 after 55 usecs
[    1.056147] calling  e100_init_module+0x0/0x5d @ 1
[    1.056149] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.056150] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.056208] initcall e100_init_module+0x0/0x5d returned 0 after 56 usecs
[    1.056210] calling  tg3_init+0x0/0x1b @ 1
[    1.056268] initcall tg3_init+0x0/0x1b returned 0 after 54 usecs
[    1.056270] calling  bnx2_init+0x0/0x1b @ 1
[    1.056327] initcall bnx2_init+0x0/0x1b returned 0 after 53 usecs
[    1.056328] calling  net_olddevs_init+0x0/0x9e @ 1
[    1.056333] initcall net_olddevs_init+0x0/0x9e returned 0 after 3 usecs
[    1.056335] calling  b44_init+0x0/0x48 @ 1
[    1.056446] initcall b44_init+0x0/0x48 returned 0 after 106 usecs
[    1.056448] calling  init_nic+0x0/0x1b @ 1
[    1.056506] initcall init_nic+0x0/0x1b returned 0 after 54 usecs
[    1.056507] calling  cp_init+0x0/0x1b @ 1
[    1.056563] initcall cp_init+0x0/0x1b returned 0 after 52 usecs
[    1.056565] calling  rtl8139_init_module+0x0/0x1b @ 1
[    1.056623] initcall rtl8139_init_module+0x0/0x1b returned 0 after 53 usecs
[    1.056625] calling  tun_init+0x0/0x93 @ 1
[    1.056626] tun: Universal TUN/TAP device driver, 1.6
[    1.056627] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.056747] initcall tun_init+0x0/0x93 returned 0 after 117 usecs
[    1.056749] calling  tulip_init+0x0/0x33 @ 1
[    1.056809] initcall tulip_init+0x0/0x33 returned 0 after 56 usecs
[    1.056811] calling  init_netconsole+0x0/0x23a @ 1
[    1.062541] console [netcon0] enabled
[    1.062672] netconsole: network logging started
[    1.062803] initcall init_netconsole+0x0/0x23a returned 0 after 5864 usecs
[    1.062941] calling  cdrom_init+0x0/0x6a @ 1
[    1.063082] initcall cdrom_init+0x0/0x6a returned 0 after 12 usecs
[    1.063217] calling  nonstatic_sysfs_init+0x0/0x12 @ 1
[    1.063349] initcall nonstatic_sysfs_init+0x0/0x12 returned 0 after 0 usecs
[    1.063487] calling  usb_stor_init+0x0/0x46 @ 1
[    1.063616] Initializing USB Mass Storage driver...
[    1.063819] usbcore: registered new interface driver usb-storage
[    1.063954] USB Mass Storage support registered.
[    1.064084] initcall usb_stor_init+0x0/0x46 returned 0 after 457 usecs
[    1.064220] calling  i8042_init+0x0/0x388 @ 1
[    1.064476] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.071711] i8042.c: Detected active multiplexing controller, rev 1.1.
[    1.074773] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.074909] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.075042] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.075177] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.075311] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.075515] initcall i8042_init+0x0/0x388 returned 0 after 10930 usecs
[    1.075653] calling  mousedev_init+0x0/0x8d @ 1
[    1.075975] mice: PS/2 mouse device common for all mice
[    1.076108] initcall mousedev_init+0x0/0x8d returned 0 after 310 usecs
[    1.076245] calling  evdev_init+0x0/0x12 @ 1
[    1.076724] initcall evdev_init+0x0/0x12 returned 0 after 342 usecs
[    1.076861] calling  atkbd_init+0x0/0x27 @ 1
[    1.077060] initcall atkbd_init+0x0/0x27 returned 0 after 67 usecs
[    1.077199] calling  psmouse_init+0x0/0x79 @ 1
[    1.077413] initcall psmouse_init+0x0/0x79 returned 0 after 82 usecs
[    1.077551] calling  init_ladder+0x0/0x12 @ 1
[    1.078533] cpuidle: using governor ladder
[    1.078673] initcall init_ladder+0x0/0x12 returned 0 after 967 usecs
[    1.078810] calling  init_menu+0x0/0x12 @ 1
[    1.079238] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.080658] cpuidle: using governor menu
[    1.080789] initcall init_menu+0x0/0x12 returned 0 after 1810 usecs
[    1.080925] calling  dcdbas_init+0x0/0x67 @ 1
[    1.081195] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    1.081415] initcall dcdbas_init+0x0/0x67 returned 0 after 351 usecs
[    1.081549] calling  hid_init+0x0/0x4d @ 1
[    1.081931] initcall hid_init+0x0/0x4d returned 0 after 246 usecs
[    1.082062] calling  a4_init+0x0/0x1b @ 1
[    1.082256] initcall a4_init+0x0/0x1b returned 0 after 65 usecs
[    1.082391] calling  apple_init+0x0/0x39 @ 1
[    1.082584] initcall apple_init+0x0/0x39 returned 0 after 65 usecs
[    1.082720] calling  belkin_init+0x0/0x1b @ 1
[    1.082911] initcall belkin_init+0x0/0x1b returned 0 after 59 usecs
[    1.083044] calling  ch_init+0x0/0x1b @ 1
[    1.083234] initcall ch_init+0x0/0x1b returned 0 after 60 usecs
[    1.083368] calling  ch_init+0x0/0x1b @ 1
[    1.083555] initcall ch_init+0x0/0x1b returned 0 after 58 usecs
[    1.083928] calling  cp_init+0x0/0x1b @ 1
[    1.084120] initcall cp_init+0x0/0x1b returned 0 after 63 usecs
[    1.084255] calling  dr_init+0x0/0x1b @ 1
[    1.084444] initcall dr_init+0x0/0x1b returned 0 after 59 usecs
[    1.084577] calling  ez_init+0x0/0x1b @ 1
[    1.084773] initcall ez_init+0x0/0x1b returned 0 after 64 usecs
[    1.084904] calling  gyration_init+0x0/0x1b @ 1
[    1.085093] initcall gyration_init+0x0/0x1b returned 0 after 58 usecs
[    1.085228] calling  ks_init+0x0/0x1b @ 1
[    1.085417] initcall ks_init+0x0/0x1b returned 0 after 59 usecs
[    1.085547] calling  kye_init+0x0/0x1b @ 1
[    1.085745] initcall kye_init+0x0/0x1b returned 0 after 66 usecs
[    1.085879] calling  lg_init+0x0/0x1b @ 1
[    1.086065] initcall lg_init+0x0/0x1b returned 0 after 59 usecs
[    1.086197] calling  ms_init+0x0/0x1b @ 1
[    1.086383] initcall ms_init+0x0/0x1b returned 0 after 58 usecs
[    1.086518] calling  mr_init+0x0/0x1b @ 1
[    1.086710] initcall mr_init+0x0/0x1b returned 0 after 63 usecs
[    1.086841] calling  ntrig_init+0x0/0x1b @ 1
[    1.087045] initcall ntrig_init+0x0/0x1b returned 0 after 71 usecs
[    1.087175] calling  ortek_init+0x0/0x1b @ 1
[    1.087363] initcall ortek_init+0x0/0x1b returned 0 after 58 usecs
[    1.087495] calling  pl_init+0x0/0x1b @ 1
[    1.087695] initcall pl_init+0x0/0x1b returned 0 after 69 usecs
[    1.087827] calling  pl_init+0x0/0x1b @ 1
[    1.088015] initcall pl_init+0x0/0x1b returned 0 after 60 usecs
[    1.088147] calling  samsung_init+0x0/0x1b @ 1
[    1.088334] initcall samsung_init+0x0/0x1b returned 0 after 58 usecs
[    1.090939] calling  sjoy_init+0x0/0x1b @ 1
[    1.091130] initcall sjoy_init+0x0/0x1b returned 0 after 61 usecs
[    1.091264] calling  sony_init+0x0/0x1b @ 1
[    1.091451] initcall sony_init+0x0/0x1b returned 0 after 59 usecs
[    1.091582] calling  sp_init+0x0/0x1b @ 1
[    1.091778] initcall sp_init+0x0/0x1b returned 0 after 64 usecs
[    1.091908] calling  ga_init+0x0/0x1b @ 1
[    1.092098] initcall ga_init+0x0/0x1b returned 0 after 59 usecs
[    1.092228] calling  tm_init+0x0/0x1b @ 1
[    1.092415] initcall tm_init+0x0/0x1b returned 0 after 58 usecs
[    1.092546] calling  ts_init+0x0/0x1b @ 1
[    1.092741] initcall ts_init+0x0/0x1b returned 0 after 61 usecs
[    1.092875] calling  twinhan_init+0x0/0x1b @ 1
[    1.093067] initcall twinhan_init+0x0/0x1b returned 0 after 59 usecs
[    1.093200] calling  zp_init+0x0/0x1b @ 1
[    1.093390] initcall zp_init+0x0/0x1b returned 0 after 59 usecs
[    1.093520] calling  hid_init+0x0/0xb0 @ 1
[    1.093817] usbcore: registered new interface driver usbhid
[    1.093946] usbhid: USB HID core driver
[    1.094072] initcall hid_init+0x0/0xb0 returned 0 after 412 usecs
[    1.094202] calling  staging_init+0x0/0x8 @ 1
[    1.094333] initcall staging_init+0x0/0x8 returned 0 after 0 usecs
[    1.094468] calling  alsa_sound_last_init+0x0/0x6f @ 1
[    1.094598] ALSA device list:
[    1.094722]   No soundcards found.
[    1.094847] initcall alsa_sound_last_init+0x0/0x6f returned 0 after 242 usecs
[    1.094986] calling  oprofile_init+0x0/0x42 @ 1
[    1.095231] oprofile: using NMI interrupt.
[    1.095367] initcall oprofile_init+0x0/0x42 returned 0 after 245 usecs
[    1.095503] calling  sysctl_ipv4_init+0x0/0x8b @ 1
[    1.095789] initcall sysctl_ipv4_init+0x0/0x8b returned 0 after 151 usecs
[    1.095925] calling  inet_diag_init+0x0/0xca @ 1
[    1.096065] initcall inet_diag_init+0x0/0xca returned 0 after 12 usecs
[    1.096202] calling  tcp_diag_init+0x0/0x12 @ 1
[    1.096330] initcall tcp_diag_init+0x0/0x12 returned 0 after 0 usecs
[    1.096461] calling  cubictcp_register+0x0/0x5c @ 1
[    1.096588] TCP cubic registered
[    1.096716] initcall cubictcp_register+0x0/0x5c returned 0 after 124 usecs
[    1.096852] calling  packet_init+0x0/0x47 @ 1
[    1.096980] NET: Registered protocol family 17
[    1.097115] initcall packet_init+0x0/0x47 returned 0 after 132 usecs
[    1.097252] calling  mcheck_debugfs_init+0x0/0x3c @ 1
[    1.097391] initcall mcheck_debugfs_init+0x0/0x3c returned 0 after 8 usecs
[    1.097525] calling  severities_debugfs_init+0x0/0x3c @ 1
[    1.097662] initcall severities_debugfs_init+0x0/0x3c returned 0 after 2 usecs
[    1.097880] calling  hpet_insert_resource+0x0/0x23 @ 1
[    1.098012] initcall hpet_insert_resource+0x0/0x23 returned 0 after 1 usecs
[    1.098150] calling  update_mp_table+0x0/0x5fa @ 1
[    1.098278] initcall update_mp_table+0x0/0x5fa returned 0 after 0 usecs
[    1.098412] calling  lapic_insert_resource+0x0/0x3f @ 1
[    1.098544] initcall lapic_insert_resource+0x0/0x3f returned 0 after 0 usecs
[    1.098683] calling  init_lapic_nmi_sysfs+0x0/0x39 @ 1
[    1.098812] initcall init_lapic_nmi_sysfs+0x0/0x39 returned 0 after 0 usecs
[    1.098949] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[    1.099077] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
[    1.099211] calling  check_early_ioremap_leak+0x0/0x65 @ 1
[    1.099340] initcall check_early_ioremap_leak+0x0/0x65 returned 0 after 0 usecs
[    1.099556] calling  pat_memtype_list_init+0x0/0x32 @ 1
[    1.099693] initcall pat_memtype_list_init+0x0/0x32 returned 0 after 3 usecs
[    1.099831] calling  sched_init_debug+0x0/0x24 @ 1
[    1.099965] initcall sched_init_debug+0x0/0x24 returned 0 after 2 usecs
[    1.100101] calling  init_oops_id+0x0/0x31 @ 1
[    1.100234] initcall init_oops_id+0x0/0x31 returned 0 after 4 usecs
[    1.100367] calling  printk_late_init+0x0/0x50 @ 1
[    1.100497] initcall printk_late_init+0x0/0x50 returned 0 after 1 usecs
[    1.100631] calling  pm_qos_power_init+0x0/0xca @ 1
[    1.101098] initcall pm_qos_power_init+0x0/0xca returned 0 after 330 usecs
[    1.101233] calling  debugfs_kprobe_init+0x0/0x8a @ 1
[    1.101374] initcall debugfs_kprobe_init+0x0/0x8a returned 0 after 10 usecs
[    1.101508] calling  clear_boot_tracer+0x0/0x2d @ 1
[    1.101639] initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
[    1.101777] calling  max_swapfiles_check+0x0/0x8 @ 1
[    1.101909] initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
[    1.102043] calling  random32_reseed+0x0/0xb3 @ 1
[    1.102191] initcall random32_reseed+0x0/0xb3 returned 0 after 17 usecs
[    1.102323] calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
[    1.102458] initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 2 usecs
[    1.102678] calling  pci_sysfs_init+0x0/0x51 @ 1
[    1.103060] initcall pci_sysfs_init+0x0/0x51 returned 0 after 247 usecs
[    1.103197] calling  seqgen_init+0x0/0xf @ 1
[    1.103337] initcall seqgen_init+0x0/0xf returned 0 after 12 usecs
[    1.103474] calling  scsi_complete_async_scans+0x0/0x170 @ 1
[    1.103608] initcall scsi_complete_async_scans+0x0/0x170 returned 0 after 0 usecs
[    1.103824] calling  rtc_hctosys+0x0/0x10d @ 1
[    1.103952] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    1.104086] initcall rtc_hctosys+0x0/0x10d returned -19 after 131 usecs
[    1.104219] calling  memmap_init+0x0/0x3b @ 1
[    1.104418] initcall memmap_init+0x0/0x3b returned 0 after 68 usecs
[    1.104549] calling  pci_mmcfg_late_insert_resources+0x0/0x66 @ 1
[    1.104683] initcall pci_mmcfg_late_insert_resources+0x0/0x66 returned 0 after 0 usecs
[    1.104899] calling  tcp_congestion_default+0x0/0x12 @ 1
[    1.105032] initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 usecs
[    1.105169] calling  ip_auto_config+0x0/0xda2 @ 1
[    1.105304] initcall ip_auto_config+0x0/0xda2 returned 0 after 4 usecs
[    1.105436] calling  initialize_hashrnd+0x0/0x19 @ 1
[    1.105569] initcall initialize_hashrnd+0x0/0x19 returned 0 after 2 usecs
[    1.333358] ata6: SATA link down (SStatus 0 SControl 300)
[    1.333509] async_waiting @ 1189
[    1.333523] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.333545] ata5: SATA link down (SStatus 0 SControl 300)
[    1.333555] async_waiting @ 1188
[    1.335973] ata2.00: ATAPI: Slimtype DVD A  DS8A4S, JA22, max UDMA/100
[    1.337358] ata2.00: configured for UDMA/100
[    1.338828] async_waiting @ 18
[    1.340295] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.340729] ata1.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102HD, max UDMA/133
[    1.340872] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.341463] ata1.00: configured for UDMA/133
[    1.341667] async_waiting @ 5
[    1.341796] async_continuing @ 5 after 0 usec
[    1.342127] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
[    1.343223] calling  8_sd_probe_async+0x0/0x1c0 @ 1190
[    1.343457] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.343619] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.343629] initcall 2_async_port_probe+0x0/0xad returned 0 after 275200 usecs
[    1.343637] async_continuing @ 18 after 4578 usec
[    1.344269] sd 0:0:0:0: [sda] Write Protect is off
[    1.344410] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.344586] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.346292]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    1.347499] scsi 1:0:0:0: CD-ROM            Slimtype DVD A  DS8A4S    JA22 PQ: 0 ANSI: 5
[    1.347637] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.347641] initcall 8_sd_probe_async+0x0/0x1c0 returned 0 after 4189 usecs
[    1.358848] sr0: scsi3-mmc drive: 24x/8x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.359077] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.359809] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.360428] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.360582] initcall 3_async_port_probe+0x0/0xad returned 0 after 298930 usecs
[    1.360806] async_continuing @ 559 after 299110 usec
[    1.360946] initcall 4_async_port_probe+0x0/0xad returned 0 after 299253 usecs
[    1.361169] async_continuing @ 1187 after 299443 usec
[    1.361312] initcall 5_async_port_probe+0x0/0xad returned 0 after 299589 usecs
[    1.361562] async_continuing @ 1188 after 27417 usec
[    1.361703] initcall 6_async_port_probe+0x0/0xad returned 0 after 299947 usecs
[    1.361923] async_continuing @ 1189 after 27245 usec
[    1.362054] initcall 7_async_port_probe+0x0/0xad returned 0 after 300261 usecs
[    2.186299] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio2/input/input5
[    2.234032] async_waiting @ 1
[    2.234164] async_continuing @ 1 after 0 usec
[    2.235203] EXT3-fs (sda5): error: couldn't mount because of unsupported optional features (240)
[    2.235752] EXT2-fs (sda5): error: couldn't mount because of unsupported optional features (240)
[    2.241518] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[    2.241820] VFS: Mounted root (ext4 filesystem) readonly on device 8:5.
[    2.243058] devtmpfs: mounted
[    2.243207] async_waiting @ 1
[    2.243331] async_continuing @ 1 after 0 usec
[    2.243469] Freeing unused kernel memory: 448k freed
[    2.328433] readahead: starting
[    2.525527] udev: starting version 153
[    2.525600] udevd (1418): /proc/1418/oom_adj is deprecated, please use /proc/1418/oom_score_adj instead.
[    2.579229] power_supply BAT0: uevent
[    2.579232] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    2.586669] calling  cmpc_init+0x0/0x83 [classmate_laptop] @ 1432
[    2.587184] calling  acpi_ac_init+0x0/0x45 [ac] @ 1437
[    2.587550] initcall cmpc_init+0x0/0x83 [classmate_laptop] returned 0 after 856 usecs
[    2.588149] calling  acpi_video_init+0x0/0x77 [video] @ 1435
[    2.588159] initcall acpi_video_init+0x0/0x77 [video] returned 0 after 6 usecs
[    2.594202] power_supply AC0: uevent
[    2.594205] power_supply AC0: POWER_SUPPLY_NAME=AC0
[    2.594208] power_supply AC0: prop ONLINE=1
[    2.594220] power_supply AC0: power_supply_changed
[    2.594224] ACPI: AC Adapter [AC0] (on-line)
[    2.594256] initcall acpi_ac_init+0x0/0x45 [ac] returned 0 after 6917 usecs
[    2.594309] power_supply AC0: power_supply_changed_work
[    2.594313] power_supply AC0: power_supply_update_gen_leds 1
[    2.594327] power_supply AC0: uevent
[    2.594329] power_supply AC0: POWER_SUPPLY_NAME=AC0
[    2.594333] power_supply AC0: prop ONLINE=1
[    2.637223] power_supply BAT0: prop STATUS=Unknown
[    2.637228] power_supply BAT0: prop PRESENT=1
[    2.637232] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    2.637235] power_supply BAT0: prop CYCLE_COUNT=0
[    2.637239] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[    2.637242] power_supply BAT0: prop VOLTAGE_NOW=12428000
[    2.637245] power_supply BAT0: prop CURRENT_NOW=0
[    2.637249] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[    2.637252] power_supply BAT0: prop CHARGE_FULL=4508000
[    2.637256] power_supply BAT0: prop CHARGE_NOW=4407000
[    2.637260] power_supply BAT0: prop MODEL_NAME=SP624
[    2.637263] power_supply BAT0: prop MANUFACTURER=PEGATRON
[    2.637267] power_supply BAT0: prop SERIAL_NUMBER= 
[    2.650820] calling  cmos_init+0x0/0x6a [rtc_cmos] @ 1453
[    2.650851] rtc_cmos 00:03: RTC can wake from S4
[    2.651656] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.651690] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    2.651724] initcall cmos_init+0x0/0x6a [rtc_cmos] returned 0 after 879 usecs
[    2.668036] calling  acpi_wmi_init+0x0/0x72 [wmi] @ 1473
[    2.668329] wmi: Mapper loaded
[    2.668333] initcall acpi_wmi_init+0x0/0x72 [wmi] returned 0 after 285 usecs
[    2.673016] calling  snd_mem_init+0x0/0x2c [snd_page_alloc] @ 1478
[    2.673029] initcall snd_mem_init+0x0/0x2c [snd_page_alloc] returned 0 after 7 usecs
[    2.692779] calling  drm_core_init+0x0/0x137 [drm] @ 1474
[    2.692840] [drm] Initialized drm 1.1.0 20060810
[    2.692851] initcall drm_core_init+0x0/0x137 [drm] returned 0 after 56 usecs
[    2.694070] calling  ehci_hcd_init+0x0/0xb5 [ehci_hcd] @ 1477
[    2.694073] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.694112] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.694138] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.694143] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    2.694153] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.694214] ehci_hcd 0000:00:1a.0: debug port 2
[    2.698092] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    2.698265] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xfb608000
[    2.703183] calling  atl1e_init_module+0x0/0x20 [atl1e] @ 1480
[    2.703213] ATL1E 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.703222] ATL1E 0000:06:00.0: setting latency timer to 64
[    2.708565] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.708618] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.708620] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.708623] usb usb1: Product: EHCI Host Controller
[    2.708625] usb usb1: Manufacturer: Linux 2.6.37-rc5 ehci_hcd
[    2.708627] usb usb1: SerialNumber: 0000:00:1a.0
[    2.708973] hub 1-0:1.0: USB hub found
[    2.708986] hub 1-0:1.0: 2 ports detected
[    2.709090] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.709119] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.709123] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    2.709133] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.709196] ehci_hcd 0000:00:1d.0: debug port 2
[    2.710450] calling  alsa_timer_init+0x0/0x1bf [snd_timer] @ 1478
[    2.710552] initcall alsa_timer_init+0x0/0x1bf [snd_timer] returned 0 after 94 usecs
[    2.713070] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    2.715720] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xfb607000
[    2.729720] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.729777] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.729780] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.729783] usb usb2: Product: EHCI Host Controller
[    2.729785] usb usb2: Manufacturer: Linux 2.6.37-rc5 ehci_hcd
[    2.729787] usb usb2: SerialNumber: 0000:00:1d.0
[    2.730085] hub 2-0:1.0: USB hub found
[    2.730095] hub 2-0:1.0: 2 ports detected
[    2.730215] initcall ehci_hcd_init+0x0/0xb5 [ehci_hcd] returned 0 after 35378 usecs
[    2.732112] initcall atl1e_init_module+0x0/0x20 [atl1e] returned 0 after 28313 usecs
[    2.739581] calling  i915_init+0x0/0x96 [i915] @ 1474
[    2.739631] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.739636] i915 0000:00:02.0: setting latency timer to 64
[    2.785960] calling  alsa_pcm_init+0x0/0x71 [snd_pcm] @ 1520
[    2.787057] initcall alsa_pcm_init+0x0/0x71 [snd_pcm] returned 0 after 1065 usecs
[    2.801076] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[    2.811919] microcode: CPU0 updated to revision 0xc, date = 2010-06-10
[    2.812494] microcode: CPU1 updated to revision 0xc, date = 2010-06-10
[    2.813021] microcode: CPU2 updated to revision 0xc, date = 2010-06-10
[    2.813551] microcode: CPU3 updated to revision 0xc, date = 2010-06-10
[    2.862009] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.928694] fb0: inteldrmfb frame buffer device
[    2.928696] drm: registered panic notifier
[    2.937873] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[    2.956486] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[    2.972378] acpi device:4f: registered as cooling_device4
[    2.972909] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
[    2.973069] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.973114] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.973177] initcall i915_init+0x0/0x96 [i915] returned 0 after 228687 usecs
[    3.036948] calling  alsa_seq_device_init+0x0/0x60 [snd_seq_device] @ 1573
[    3.036958] initcall alsa_seq_device_init+0x0/0x60 [snd_seq_device] returned 0 after 5 usecs
[    3.041335] calling  alsa_seq_init+0x0/0x4c [snd_seq] @ 1573
[    3.041529] initcall alsa_seq_init+0x0/0x4c [snd_seq] returned 0 after 183 usecs
[    3.060175] calling  alsa_card_azx_init+0x0/0x20 [snd_hda_intel] @ 1478
[    3.060260] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    3.060304] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    3.060339] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    3.061857] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    3.087464] calling  patch_realtek_init+0x0/0x12 [snd_hda_codec_realtek] @ 1621
[    3.087473] initcall patch_realtek_init+0x0/0x12 [snd_hda_codec_realtek] returned 0 after 0 usecs
[    3.088035] hda_codec: ALC269VB: BIOS auto-probing.
[    3.091049] initcall alsa_card_azx_init+0x0/0x20 [snd_hda_intel] returned 0 after 30198 usecs
[    3.177026] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    3.177032] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.177429] hub 1-1:1.0: USB hub found
[    3.177488] hub 1-1:1.0: 6 ports detected
[    3.188272] calling  wait_scan_init+0x0/0x12 [scsi_wait_scan] @ 1688
[    3.188276] initcall wait_scan_init+0x0/0x12 [scsi_wait_scan] returned 0 after 1 usecs
[    3.280314] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    3.286282] EXT4-fs (sda5): re-mounted. Opts: (null)
[    3.322002] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    3.388675] Adding 4194300k swap on /dev/sda6.  Priority:-1 extents:1 across:4194300k SS
[    3.396341] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    3.396344] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.396764] hub 2-1:1.0: USB hub found
[    3.396810] hub 2-1:1.0: 8 ports detected
[    3.471901] usb 1-1.6: new high speed USB device using ehci_hcd and address 3
[    3.568412] calling  acpi_cpufreq_init+0x0/0x10d [acpi_cpufreq] @ 1861
[    3.570149] initcall acpi_cpufreq_init+0x0/0x10d [acpi_cpufreq] returned 0 after 1696 usecs
[    3.599095] usb 1-1.6: New USB device found, idVendor=064e, idProduct=a118
[    3.599101] usb 1-1.6: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    3.599105] usb 1-1.6: Product: USB 2.0 UVC 1.3M WebCam
[    3.599109] usb 1-1.6: Manufacturer: SuYin
[    3.599112] usb 1-1.6: SerialNumber: CN1315-S30B-OV03-VS-R01.01.01
[    3.675387] usb 2-1.6: new full speed USB device using ehci_hcd and address 3
[    3.717199] ATL1E 0000:06:00.0: irq 47 for MSI/MSI-X
[    3.763909] usb 2-1.6: New USB device found, idVendor=13d3, idProduct=3250
[    3.763912] usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.763914] usb 2-1.6: Product: Bluetooth2.1module
[    3.763916] usb 2-1.6: Manufacturer: Broadcom Corp
[    3.763918] usb 2-1.6: SerialNumber: 0025D3B17A59
[    4.050603] power_supply AC0: uevent
[    4.050605] power_supply AC0: POWER_SUPPLY_NAME=AC0
[    4.050608] power_supply AC0: prop ONLINE=1
[    4.051589] power_supply BAT0: uevent
[    4.051591] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    4.088644] power_supply BAT0: prop STATUS=Unknown
[    4.088652] power_supply BAT0: prop PRESENT=1
[    4.088658] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    4.088663] power_supply BAT0: prop CYCLE_COUNT=0
[    4.088669] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[    4.088674] power_supply BAT0: prop VOLTAGE_NOW=12429000
[    4.088680] power_supply BAT0: prop CURRENT_NOW=0
[    4.088685] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[    4.088691] power_supply BAT0: prop CHARGE_FULL=4508000
[    4.088696] power_supply BAT0: prop CHARGE_NOW=4407000
[    4.088701] power_supply BAT0: prop MODEL_NAME=SP624
[    4.088706] power_supply BAT0: prop MANUFACTURER=PEGATRON
[    4.088712] power_supply BAT0: prop SERIAL_NUMBER= 
[    4.760196] calling  fb_console_init+0x0/0x11d [fbcon] @ 2280
[    4.761163] Console: switching to colour frame buffer device 170x48
[    4.761177] initcall fb_console_init+0x0/0x11d [fbcon] returned 0 after 951 usecs
[    4.852261] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[    4.908872] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[    4.927615] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[    5.060020] power_supply AC0: uevent
[    5.060025] power_supply AC0: POWER_SUPPLY_NAME=AC0
[    5.060032] power_supply AC0: prop ONLINE=1
[    5.071708] power_supply BAT0: uevent
[    5.071712] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    5.071718] power_supply BAT0: prop STATUS=Unknown
[    5.071723] power_supply BAT0: prop PRESENT=1
[    5.071728] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    5.071732] power_supply BAT0: prop CYCLE_COUNT=0
[    5.071737] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[    5.071742] power_supply BAT0: prop VOLTAGE_NOW=12429000
[    5.071746] power_supply BAT0: prop CURRENT_NOW=0
[    5.071750] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[    5.071755] power_supply BAT0: prop CHARGE_FULL=4508000
[    5.071759] power_supply BAT0: prop CHARGE_NOW=4407000
[    5.071764] power_supply BAT0: prop MODEL_NAME=SP624
[    5.071768] power_supply BAT0: prop MANUFACTURER=PEGATRON
[    5.071772] power_supply BAT0: prop SERIAL_NUMBER= 
[    5.124027] ATL1E 0000:06:00.0: eth0: NIC Link is Up <1000 Mbps Full Duplex>
[    5.339956] power_supply BAT0: uevent
[    5.339959] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    5.375309] power_supply BAT0: prop STATUS=Unknown
[    5.375315] power_supply BAT0: prop PRESENT=1
[    5.375320] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    5.375325] power_supply BAT0: prop CYCLE_COUNT=0
[    5.375329] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[    5.375334] power_supply BAT0: prop VOLTAGE_NOW=12428000
[    5.375338] power_supply BAT0: prop CURRENT_NOW=0
[    5.375343] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[    5.375347] power_supply BAT0: prop CHARGE_FULL=4508000
[    5.375351] power_supply BAT0: prop CHARGE_NOW=4407000
[    5.375355] power_supply BAT0: prop MODEL_NAME=SP624
[    5.375360] power_supply BAT0: prop MANUFACTURER=PEGATRON
[    5.375364] power_supply BAT0: prop SERIAL_NUMBER= 
[    5.375538] power_supply AC0: uevent
[    5.375541] power_supply AC0: POWER_SUPPLY_NAME=AC0
[    5.375546] power_supply AC0: prop ONLINE=1
[    5.489368] power_supply BAT0: uevent
[    5.489373] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    5.489380] power_supply BAT0: prop STATUS=Unknown
[    5.489385] power_supply BAT0: prop PRESENT=1
[    5.489391] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    5.489396] power_supply BAT0: prop CYCLE_COUNT=0
[    5.489401] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[    5.489407] power_supply BAT0: prop VOLTAGE_NOW=12428000
[    5.489412] power_supply BAT0: prop CURRENT_NOW=0
[    5.489417] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[    5.489423] power_supply BAT0: prop CHARGE_FULL=4508000
[    5.489428] power_supply BAT0: prop CHARGE_NOW=4407000
[    5.489433] power_supply BAT0: prop MODEL_NAME=SP624
[    5.489438] power_supply BAT0: prop MANUFACTURER=PEGATRON
[    5.489443] power_supply BAT0: prop SERIAL_NUMBER= 
[    5.920190] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
[   22.803808] power_supply BAT0: uevent
[   22.803811] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[   22.839753] power_supply BAT0: prop STATUS=Unknown
[   22.839761] power_supply BAT0: prop PRESENT=1
[   22.839767] power_supply BAT0: prop TECHNOLOGY=Li-ion
[   22.839772] power_supply BAT0: prop CYCLE_COUNT=0
[   22.839778] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[   22.839783] power_supply BAT0: prop VOLTAGE_NOW=12428000
[   22.839789] power_supply BAT0: prop CURRENT_NOW=0
[   22.839794] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[   22.839799] power_supply BAT0: prop CHARGE_FULL=4508000
[   22.839804] power_supply BAT0: prop CHARGE_NOW=4407000
[   22.839810] power_supply BAT0: prop MODEL_NAME=SP624
[   22.839815] power_supply BAT0: prop MANUFACTURER=PEGATRON
[   22.839821] power_supply BAT0: prop SERIAL_NUMBER= 
[   22.840031] power_supply AC0: uevent
[   22.840035] power_supply AC0: POWER_SUPPLY_NAME=AC0
[   22.840041] power_supply AC0: prop ONLINE=1
[   22.955407] power_supply BAT0: uevent
[   22.955410] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[   22.955414] power_supply BAT0: prop STATUS=Unknown
[   22.955416] power_supply BAT0: prop PRESENT=1
[   22.955418] power_supply BAT0: prop TECHNOLOGY=Li-ion
[   22.955420] power_supply BAT0: prop CYCLE_COUNT=0
[   22.955422] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=11100000
[   22.955424] power_supply BAT0: prop VOLTAGE_NOW=12428000
[   22.955426] power_supply BAT0: prop CURRENT_NOW=0
[   22.955428] power_supply BAT0: prop CHARGE_FULL_DESIGN=4800000
[   22.955430] power_supply BAT0: prop CHARGE_FULL=4508000
[   22.955432] power_supply BAT0: prop CHARGE_NOW=4407000
[   22.955434] power_supply BAT0: prop MODEL_NAME=SP624
[   22.955436] power_supply BAT0: prop MANUFACTURER=PEGATRON
[   22.955438] power_supply BAT0: prop SERIAL_NUMBER= 
[   22.955508] power_supply AC0: uevent
[   22.955510] power_supply AC0: POWER_SUPPLY_NAME=AC0
[   22.955513] power_supply AC0: prop ONLINE=1
[   23.806070] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
