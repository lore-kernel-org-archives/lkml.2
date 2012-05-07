Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab2EGN6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:58:48 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47287 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab2EGN6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:58:38 -0400
Date: Mon, 7 May 2012 09:52:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: JBottomley@Parallels.com, ming.m.lin@intel.com, joerg@alea.gnuu.de,
        linux-kernel@vger.kernel.org
Subject: Regression introduced by 6f381fa344911d5a234b13574433cf23036f9467
 [[SCSI] scsi_lib: use correct DMA device in __scsi_alloc_queue]
Message-ID: <20120507135238.GC361@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey James,

I am using iSCSI and I keep on getting this:

scsi4 : iSCSI Initiator over TCP/IP
BUG: unable to handle kernel NULL pointer dereference at 0000000000000118
IP: [<ffffffffa0056da1>] __scsi_alloc_queue+0xa1/0x190 [scsi_mod]
PGD 226cfb067 PUD 229300067 PMD 0 
Oops: 0000 [#1] SMP 
CPU 3 
Modules linked in: dm_multipath dm_mod iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi libcrc32c crc32c nouveau mxm_wmi wmi radeon ttm sg sr_mod sd_mod cdrom ata_generic ata_piix libata fbcon i915 tileblit font bitblit softcursor atl1c drm_kms_helper scsi_mod crc32c_intel e1000e video acpi_cpufreq mperf [last unloaded: dump_dma]

Pid: 3065, comm: iscsid Tainted: G           O 3.4.0-rc6upstream-00007-gf4f77c4 #1 MSI MS-7680/H61M-P23 (MS-7680)
RIP: 0010:[<ffffffffa0056da1>]  [<ffffffffa0056da1>] __scsi_alloc_queue+0xa1/0x190 [scsi_mod]
RSP: 0018:ffff88022e92fa78  EFLAGS: 00010296
RAX: 000000000023fe00 RBX: ffff88022748f800 RCX: 0000000000000010
RDX: 0000000000000067 RSI: 00000000ffffffff RDI: ffff8802292ca078
RBP: ffff88022e92fa98 R08: 0000000000000000 R09: 0000000000000008
R10: ffff8802292b5000 R11: 0000000000000001 R12: 0000000000000000
R13: ffff8802292ca078 R14: ffff880229094828 R15: 0000000000000000
FS:  00007ffb5eea6700(0000) GS:ffff88023fb80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000118 CR3: 000000022924e000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process iscsid (pid: 3065, threadinfo ffff88022e92e000, task ffff88022736d820)
Stack:
 ffff88022e92fb78 ffff88022f182000 ffff880229094800 ffff88022748f800
 ffff88022e92fab8 ffffffffa0056ea8 ffff88022e92fab8 ffff88022f182000
 ffff88022e92fb08 ffffffffa0058faf 0000000000000282 0000000000000000
Call Trace:
 [<ffffffffa0056ea8>] scsi_alloc_queue+0x18/0x70 [scsi_mod]
 [<ffffffffa0058faf>] scsi_alloc_sdev+0x19f/0x280 [scsi_mod]
 [<ffffffffa0059508>] scsi_probe_and_add_lun+0x478/0xd50 [scsi_mod]

reverting above mentioned git commit fixes the issue.


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.0-rc6upstream-00007-gf4f77c4 (konrad@phenom.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Mon May 7 06:58:23 EDT 2012
[    0.000000] Command line: initrd=initramfs.cpio.gz debug loglevel=8 selinux=0 initcall_debug sysrq_always_enable console=ttyS0,115200 BOOT_IMAGE=vmlinuz 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
[    0.000000]  BIOS-e820: 0000000040200000 - 00000000bad80000 (usable)
[    0.000000]  BIOS-e820: 00000000bad80000 - 00000000badc9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000badc9000 - 00000000badd1000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000badd1000 - 00000000badf4000 (reserved)
[    0.000000]  BIOS-e820: 00000000badf4000 - 00000000badf6000 (usable)
[    0.000000]  BIOS-e820: 00000000badf6000 - 00000000bae06000 (reserved)
[    0.000000]  BIOS-e820: 00000000bae06000 - 00000000bae14000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bae14000 - 00000000bae3c000 (reserved)
[    0.000000]  BIOS-e820: 00000000bae3c000 - 00000000bae7f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bae7f000 - 00000000bb000000 (usable)
[    0.000000]  BIOS-e820: 00000000bb800000 - 00000000bfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed40000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000023fe00000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: MSI MS-7680/H61M-P23 (MS-7680), BIOS V17.0 03/14/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x23fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FC0000000 write-back
[    0.000000]   2 base 0BB800000 mask FFF800000 uncachable
[    0.000000]   3 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   5 base 23FE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bb800000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbb000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fcde0] fcde0
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bb000000
[    0.000000]  0000000000 - 00bb000000 page 2M
[    0.000000] kernel direct mapping tables up to bb000000 @ 1fffc000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000023fe00000
[    0.000000]  0100000000 - 023fe00000 page 2M
[    0.000000] kernel direct mapping tables up to 23fe00000 @ baff6000-bb000000
[    0.000000] RAMDISK: 1c02a000 - 1ffdf000
[    0.000000] ACPI: RSDP 00000000000f0450 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000badc9068 00054 (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000badd0308 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000badc9150 071B5 (v02 ALASKA    A M I 00000015 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bae0bf80 00040
[    0.000000] ACPI: APIC 00000000badd0400 00072 (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000badd0478 00102 (v01 AMICPU     PROC 00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 00000000badd0580 0003C (v01 ALASKA    A M I 01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000badd05c0 00038 (v01 ALASKA    A M I 01072009 AMI. 00000004)
[    0.000000] ACPI: ASF! 00000000badd05f8 000A0 (v32 INTEL       HCG 00000001 TFSM 000F4240)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000023fe00000
[    0.000000] Initmem setup node 0 0000000000000000-000000023fe00000
[    0.000000]   NODE_DATA [000000023fdfc000 - 000000023fdfffff]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880237400000-ffff88023e3fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0023fe00
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040000
[    0.000000]     0: 0x00040200 -> 0x000bad80
[    0.000000]     0: 0x000badf4 -> 0x000badf6
[    0.000000]     0: 0x000bae7f -> 0x000bb000
[    0.000000]     0: 0x00100000 -> 0x0023fe00
[    0.000000] On node 0 totalpages: 2074769
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 746299 pages, LIFO batch:31
[    0.000000]   Normal zone: 17913 pages used for memmap
[    0.000000]   Normal zone: 1292295 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
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
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 00000000bad80000 - 00000000badc9000
[    0.000000] PM: Registered nosave memory: 00000000badc9000 - 00000000badd1000
[    0.000000] PM: Registered nosave memory: 00000000badd1000 - 00000000badf4000
[    0.000000] PM: Registered nosave memory: 00000000badf6000 - 00000000bae06000
[    0.000000] PM: Registered nosave memory: 00000000bae06000 - 00000000bae14000
[    0.000000] PM: Registered nosave memory: 00000000bae14000 - 00000000bae3c000
[    0.000000] PM: Registered nosave memory: 00000000bae3c000 - 00000000bae7f000
[    0.000000] PM: Registered nosave memory: 00000000bb000000 - 00000000bb800000
[    0.000000] PM: Registered nosave memory: 00000000bb800000 - 00000000bfa00000
[    0.000000] PM: Registered nosave memory: 00000000bfa00000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed40000
[    0.000000] PM: Registered nosave memory: 00000000fed40000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at bfa00000 (gap: bfa00000:3f31c000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88023fa00000 s78400 r8192 d24000 u524288
[    0.000000] pcpu-alloc: s78400 r8192 d24000 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2042515
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: initrd=initramfs.cpio.gz debug loglevel=8 selinux=0 initcall_debug sysrq_always_enable console=ttyS0,115200 BOOT_IMAGE=vmlinuz 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8042080k/9435136k available (5829k kernel code, 1136060k absent, 256996k reserved, 2888k data, 692k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.001000] Fast TSC calibration using PIT
[    0.002000] Detected 3093.118 MHz processor.
[    0.000001] Calibrating delay loop (skipped), value calculated using timer frequency.. 6186.23 BogoMIPS (lpj=3093118)
[    0.010611] pid_max: default: 32768 minimum: 301
[    0.015243] Security Framework initialized
[    0.019337] SELinux:  Disabled at boot.
[    0.023518] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.032196] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.039940] Mount-cache hash table entries: 256
[    0.044590] Initializing cgroup subsys cpuacct
[    0.049032] Initializing cgroup subsys freezer
[    0.053490] CPU: Physical Processor ID: 0
[    0.057496] CPU: Processor Core ID: 0
[    0.061154] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.061155] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.074181] mce: CPU supports 7 MCE banks
[    0.078195] CPU0: Thermal monitoring enabled (TM1)
[    0.082982] using mwait in idle threads.
[    0.088853] ACPI: Core revision 20120320
[    0.320173] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.336163] CPU0: Intel(R) Core(TM) i3-2100 CPU @ 3.10GHz stepping 07
[    0.443822] calling  init_hw_perf_events+0x0/0x44f @ 1
[    0.448947] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.457590] PEBS disabled due to CPU errata.
[    0.461849] ... version:                3
[    0.465848] ... bit width:              48
[    0.469934] ... generic registers:      4
[    0.473933] ... value mask:             0000ffffffffffff
[    0.479230] ... max period:             000000007fffffff
[    0.484528] ... fixed-purpose events:   3
[    0.488527] ... event mask:             000000070000000f
[    0.493834] initcall init_hw_perf_events+0x0/0x44f returned 0 after 12693 usecs
[    0.501129] calling  register_trigger_all_cpu_backtrace+0x0/0x1f @ 1
[    0.507470] initcall register_trigger_all_cpu_backtrace+0x0/0x1f returned 0 after 0 usecs
[    0.515627] calling  spawn_ksoftirqd+0x0/0x57 @ 1
[    0.520329] initcall spawn_ksoftirqd+0x0/0x57 returned 0 after 0 usecs
[    0.526840] calling  init_workqueues+0x0/0x313 @ 1
[    0.531646] initcall init_workqueues+0x0/0x313 returned 0 after 0 usecs
[    0.538246] calling  migration_init+0x0/0x72 @ 1
[    0.542853] initcall migration_init+0x0/0x72 returned 0 after 0 usecs
[    0.549278] calling  cpu_stop_init+0x0/0xb4 @ 1
[    0.553803] initcall cpu_stop_init+0x0/0xb4 returned 0 after 0 usecs
[    0.560144] calling  rcu_scheduler_really_started+0x0/0x12 @ 1
[    0.565965] initcall rcu_scheduler_really_started+0x0/0x12 returned 0 after 0 usecs
[    0.573604] calling  jump_label_init_module+0x0/0x12 @ 1
[    0.578901] initcall jump_label_init_module+0x0/0x12 returned 0 after 0 usecs
[    0.586021] calling  mce_amd_init+0x0/0x10b @ 1
[    0.590544] initcall mce_amd_init+0x0/0x10b returned 0 after 0 usecs
[    0.596909] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.602628] Booting Node   0, Processors  #1
[    0.619957] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.625858]  #2
[    0.640664] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.646574]  #3 Ok.
[    0.661897] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.667569] Brought up 4 CPUs
[    0.670530] Total of 4 processors activated (24744.94 BogoMIPS).
[    0.679256] calling  ipc_ns_init+0x0/0x14 @ 1
[    0.683608] initcall ipc_ns_init+0x0/0x14 returned 0 after 0 usecs
[    0.689775] calling  init_mmap_min_addr+0x0/0x26 @ 1
[    0.694727] initcall init_mmap_min_addr+0x0/0x26 returned 0 after 0 usecs
[    0.701499] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.708099] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.716518] calling  net_ns_init+0x0/0xea @ 1
[    0.720883] initcall net_ns_init+0x0/0xea returned 0 after 0 usecs
[    0.727071] calling  e820_mark_nvs_memory+0x0/0x41 @ 1
[    0.732198] PM: Registering ACPI NVS region [mem 0xbad80000-0xbadc8fff] (299008 bytes)
[    0.740099] PM: Registering ACPI NVS region [mem 0xbae06000-0xbae13fff] (57344 bytes)
[    0.747913] PM: Registering ACPI NVS region [mem 0xbae3c000-0xbae7efff] (274432 bytes)
[    0.755818] initcall e820_mark_nvs_memory+0x0/0x41 returned 0 after 2929 usecs
[    0.763023] calling  cpufreq_tsc+0x0/0x37 @ 1
[    0.767367] initcall cpufreq_tsc+0x0/0x37 returned 0 after 0 usecs
[    0.773532] calling  pci_reboot_init+0x0/0x1d @ 1
[    0.778225] initcall pci_reboot_init+0x0/0x1d returned 0 after 0 usecs
[    0.784740] calling  init_lapic_sysfs+0x0/0x20 @ 1
[    0.789520] initcall init_lapic_sysfs+0x0/0x20 returned 0 after 0 usecs
[    0.796118] calling  init_smp_flush+0x0/0x34 @ 1
[    0.800728] initcall init_smp_flush+0x0/0x34 returned 0 after 0 usecs
[    0.807156] calling  cpu_hotplug_pm_sync_init+0x0/0x2f @ 1
[    0.812628] initcall cpu_hotplug_pm_sync_init+0x0/0x2f returned 0 after 0 usecs
[    0.819918] calling  alloc_frozen_cpus+0x0/0x8 @ 1
[    0.824697] initcall alloc_frozen_cpus+0x0/0x8 returned 0 after 0 usecs
[    0.831295] calling  ksysfs_init+0x0/0x94 @ 1
[    0.835645] initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
[    0.841809] calling  pm_init+0x0/0x3e @ 1
[    0.845813] initcall pm_init+0x0/0x3e returned 0 after 0 usecs
[    0.851632] calling  pm_disk_init+0x0/0x19 @ 1
[    0.856065] initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
[    0.862319] calling  swsusp_header_init+0x0/0x30 @ 1
[    0.867272] initcall swsusp_header_init+0x0/0x30 returned 0 after 0 usecs
[    0.874043] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.879515] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.886807] calling  init_zero_pfn+0x0/0x35 @ 1
[    0.891325] initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
[    0.897662] calling  fsnotify_init+0x0/0x26 @ 1
[    0.902183] initcall fsnotify_init+0x0/0x26 returned 0 after 0 usecs
[    0.908519] calling  filelock_init+0x0/0x2a @ 1
[    0.913042] initcall filelock_init+0x0/0x2a returned 0 after 0 usecs
[    0.919381] calling  init_misc_binfmt+0x0/0x31 @ 1
[    0.924161] initcall init_misc_binfmt+0x0/0x31 returned 0 after 0 usecs
[    0.930758] calling  init_script_binfmt+0x0/0x16 @ 1
[    0.935710] initcall init_script_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.942480] calling  init_elf_binfmt+0x0/0x16 @ 1
[    0.947173] initcall init_elf_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.953684] calling  init_compat_elf_binfmt+0x0/0x16 @ 1
[    0.958983] initcall init_compat_elf_binfmt+0x0/0x16 returned 0 after 0 usecs
[    0.966101] calling  debugfs_init+0x0/0x5c @ 1
[    0.970535] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
[    0.976790] calling  securityfs_init+0x0/0x53 @ 1
[    0.981482] initcall securityfs_init+0x0/0x53 returned 0 after 0 usecs
[    0.987994] calling  random32_init+0x0/0xd9 @ 1
[    0.992515] initcall random32_init+0x0/0xd9 returned 0 after 0 usecs
[    0.998854] calling  virtio_init+0x0/0x30 @ 1
[    1.003249] kworker/u:0 used greatest stack depth: 6000 bytes left
[    1.003254] initcall virtio_init+0x0/0x30 returned 0 after 0 usecs
[    1.003257] calling  __gnttab_init+0x0/0x22 @ 1
[    1.003260] initcall __gnttab_init+0x0/0x22 returned -19 after 0 usecs
[    1.003262] calling  early_resume_init+0x0/0x1d0 @ 1
[    1.003294] RTC time: 12:31:53, date: 05/07/12
[    1.003295] initcall early_resume_init+0x0/0x1d0 returned 0 after 0 usecs
[    1.003298] calling  cpufreq_core_init+0x0/0xc7 @ 1
[    1.003301] initcall cpufreq_core_init+0x0/0xc7 returned 0 after 0 usecs
[    1.003304] calling  cpuidle_init+0x0/0x40 @ 1
[    1.003311] initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
[    1.003313] calling  sock_init+0x0/0x83 @ 1
[    1.069171] initcall sock_init+0x0/0x83 returned 0 after 64443 usecs
[    1.075511] calling  net_inuse_init+0x0/0x26 @ 1
[    1.080117] initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
[    1.086545] calling  netpoll_init+0x0/0x31 @ 1
[    1.090978] initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
[    1.097228] calling  netlink_proto_init+0x0/0x1a6 @ 1
[    1.102268] NET: Registered protocol family 16
[    1.106709] initcall netlink_proto_init+0x0/0x1a6 returned 0 after 976 usecs
[    1.113764] calling  bdi_class_init+0x0/0x4d @ 1
[    1.118400] initcall bdi_class_init+0x0/0x4d returned 0 after 0 usecs
[    1.124827] calling  kobject_uevent_init+0x0/0x21 @ 1
[    1.129870] initcall kobject_uevent_init+0x0/0x21 returned 0 after 0 usecs
[    1.136730] calling  pcibus_class_init+0x0/0x19 @ 1
[    1.141613] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    1.148301] calling  pci_driver_init+0x0/0x19 @ 1
[    1.153016] initcall pci_driver_init+0x0/0x19 returned 0 after 0 usecs
[    1.159530] calling  backlight_class_init+0x0/0x5d @ 1
[    1.164674] initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
[    1.171620] calling  video_output_class_init+0x0/0x19 @ 1
[    1.177020] initcall video_output_class_init+0x0/0x19 returned 0 after 0 usecs
[    1.184227] calling  xenbus_init+0x0/0x2b7 @ 1
[    1.188660] initcall xenbus_init+0x0/0x2b7 returned -19 after 0 usecs
[    1.195088] calling  tty_class_init+0x0/0x38 @ 1
[    1.199709] initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
[    1.206137] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    1.211304] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 usecs
[    1.218249] calling  wakeup_sources_debugfs_init+0x0/0x2b @ 1
[    1.223981] initcall wakeup_sources_debugfs_init+0x0/0x2b returned 0 after 0 usecs
[    1.231536] calling  register_node_type+0x0/0x19 @ 1
[    1.236513] initcall register_node_type+0x0/0x19 returned 0 after 0 usecs
[    1.243286] calling  i2c_init+0x0/0x77 @ 1
[    1.247414] initcall i2c_init+0x0/0x77 returned 0 after 0 usecs
[    1.253319] calling  amd_postcore_init+0x0/0x143 @ 1
[    1.258271] initcall amd_postcore_init+0x0/0x143 returned 0 after 0 usecs
[    1.265066] calling  arch_kdebugfs_init+0x0/0x226 @ 1
[    1.270113] initcall arch_kdebugfs_init+0x0/0x226 returned 0 after 0 usecs
[    1.276974] calling  configure_trampolines+0x0/0x26 @ 1
[    1.282187] initcall configure_trampolines+0x0/0x26 returned 0 after 0 usecs
[    1.289221] calling  mtrr_if_init+0x0/0x78 @ 1
[    1.293654] initcall mtrr_if_init+0x0/0x78 returned 0 after 0 usecs
[    1.299910] calling  ffh_cstate_init+0x0/0x2a @ 1
[    1.304606] initcall ffh_cstate_init+0x0/0x2a returned 0 after 0 usecs
[    1.311121] calling  activate_jump_labels+0x0/0x32 @ 1
[    1.316245] initcall activate_jump_labels+0x0/0x32 returned 0 after 0 usecs
[    1.323192] calling  acpi_pci_init+0x0/0x5c @ 1
[    1.327709] ACPI: bus type pci registered
[    1.331708] initcall acpi_pci_init+0x0/0x5c returned 0 after 976 usecs
[    1.338219] calling  dma_bus_init+0x0/0x19 @ 1
[    1.342670] initcall dma_bus_init+0x0/0x19 returned 0 after 0 usecs
[    1.348925] calling  dma_channel_table_init+0x0/0x119 @ 1
[    1.354315] initcall dma_channel_table_init+0x0/0x119 returned 0 after 0 usecs
[    1.361524] calling  setup_vcpu_hotplug_event+0x0/0x22 @ 1
[    1.366996] initcall setup_vcpu_hotplug_event+0x0/0x22 returned -19 after 0 usecs
[    1.374465] calling  register_xen_pci_notifier+0x0/0x33 @ 1
[    1.380026] initcall register_xen_pci_notifier+0x0/0x33 returned 0 after 0 usecs
[    1.387404] calling  dmi_id_init+0x0/0x314 @ 1
[    1.391883] initcall dmi_id_init+0x0/0x314 returned 0 after 0 usecs
[    1.398138] calling  dca_init+0x0/0x20 @ 1
[    1.402225] dca service started, version 1.12.1
[    1.406760] initcall dca_init+0x0/0x20 returned 0 after 976 usecs
[    1.412840] calling  pci_arch_init+0x0/0x69 @ 1
[    1.417368] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.426651] PCI: not using MMCONFIG
[    1.430129] PCI: Using configuration type 1 for base access
[    1.435692] initcall pci_arch_init+0x0/0x69 returned 0 after 2929 usecs
[    1.442311] calling  topology_init+0x0/0x98 @ 1
[    1.446938] kworker/u:0 used greatest stack depth: 5504 bytes left
[    1.446985] initcall topology_init+0x0/0x98 returned 0 after 0 usecs
[    1.446988] calling  mtrr_init_finialize+0x0/0x36 @ 1
[    1.446990] initcall mtrr_init_finialize+0x0/0x36 returned 0 after 0 usecs
[    1.446992] calling  init_vdso+0x0/0x135 @ 1
[    1.446995] initcall init_vdso+0x0/0x135 returned 0 after 0 usecs
[    1.446997] calling  sysenter_setup+0x0/0x2dd @ 1
[    1.447000] initcall sysenter_setup+0x0/0x2dd returned 0 after 0 usecs
[    1.447002] calling  param_sysfs_init+0x0/0x192 @ 1
[    1.501033] initcall param_sysfs_init+0x0/0x192 returned 0 after 52726 usecs
[    1.508069] calling  pm_sysrq_init+0x0/0x20 @ 1
[    1.512590] initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 usecs
[    1.518932] calling  default_bdi_init+0x0/0xaa @ 1
[    1.523774] initcall default_bdi_init+0x0/0xaa returned 0 after 0 usecs
[    1.530376] calling  init_bio+0x0/0xe3 @ 1
[    1.534490] bio: create slab <bio-0> at 0
[    1.538493] initcall init_bio+0x0/0xe3 returned 0 after 976 usecs
[    1.544573] calling  fsnotify_notification_init+0x0/0x8b @ 1
[    1.550230] initcall fsnotify_notification_init+0x0/0x8b returned 0 after 0 usecs
[    1.557698] calling  cryptomgr_init+0x0/0x12 @ 1
[    1.562305] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
[    1.568730] calling  blk_settings_init+0x0/0x2c @ 1
[    1.573597] initcall blk_settings_init+0x0/0x2c returned 0 after 0 usecs
[    1.580286] calling  blk_ioc_init+0x0/0x2a @ 1
[    1.584723] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    1.590978] calling  blk_softirq_init+0x0/0x6e @ 1
[    1.595763] initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
[    1.602364] calling  blk_iopoll_setup+0x0/0x6e @ 1
[    1.607141] initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
[    1.613738] calling  genhd_device_init+0x0/0x85 @ 1
[    1.618646] initcall genhd_device_init+0x0/0x85 returned 0 after 0 usecs
[    1.625337] calling  pci_slot_init+0x0/0x50 @ 1
[    1.629858] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
[    1.636200] calling  fbmem_init+0x0/0x98 @ 1
[    1.640483] initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
[    1.646564] calling  acpi_init+0x0/0xbc @ 1
[    1.650744] ACPI: Added _OSI(Module Device)
[    1.654920] ACPI: Added _OSI(Processor Device)
[    1.659354] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.664048] ACPI: Added _OSI(Processor Aggregator Device)
[    1.670454] ACPI: EC: Look up EC in DSDT
[    1.675577] ACPI: Executed 1 blocks of module-level executable AML code
[    1.684792] ACPI: SSDT 00000000bae0ac18 0038C (v01    AMI      IST 00000001 MSFT 03000001)
[    1.693375] ACPI: Dynamic OEM Table Load:
[    1.697405] ACPI: SSDT           (null) 0038C (v01    AMI      IST 00000001 MSFT 03000001)
[    1.705696] ACPI: SSDT 00000000bae0be18 00084 (v01    AMI      CST 00000001 MSFT 03000001)
[    1.714218] ACPI: Dynamic OEM Table Load:
[    1.718242] ACPI: SSDT           (null) 00084 (v01    AMI      CST 00000001 MSFT 03000001)
[    1.727008] ACPI: Interpreter enabled
[    1.730663] ACPI: (supports S0 S1 S3 S4 S5)
[    1.734910] ACPI: Using IOAPIC for interrupt routing
[    1.739880] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.749231] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    1.802369] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.813403] initcall acpi_init+0x0/0xbc returned 0 after 82018 usecs
[    1.819744] calling  dock_init+0x0/0xa5 @ 1
[    1.824037] ACPI: No dock devices found.
[    1.827949] initcall dock_init+0x0/0xa5 returned 0 after 976 usecs
[    1.834118] calling  acpi_pci_root_init+0x0/0x2d @ 1
[    1.839070] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.848415] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.854785] pci_root PNP0A08:00: host bridge window [io  0x0000-0x03af]
[    1.861386] pci_root PNP0A08:00: host bridge window [io  0x03e0-0x0cf7]
[    1.867983] pci_root PNP0A08:00: host bridge window [io  0x03b0-0x03df]
[    1.874582] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.881179] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.888471] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff]
[    1.895761] pci_root PNP0A08:00: host bridge window [mem 0xbfa00000-0xffffffff]
[    1.903087] PCI host bridge to bus 0000:00
[    1.907175] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    1.913342] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    1.919508] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    1.925672] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.931839] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.938700] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    1.945559] pci_bus 0000:00: root bus resource [mem 0xbfa00000-0xffffffff]
[    1.952422] pci 0000:00:00.0: [8086:0100] type 00 class 0x060000
[    1.958418] calling  quirk_mmio_always_on+0x0/0xa @ 1 for 0000:00:00.0
[    1.964932] pci fixup quirk_mmio_always_on+0x0/0xa returned after 0 usecs for 0000:00:00.0
[    1.973203] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
[    1.979207] calling  pci_fixup_transparent_bridge+0x0/0x1d @ 1 for 0000:00:01.0
[    1.986501] pci fixup pci_fixup_transparent_bridge+0x0/0x1d returned after 0 usecs for 0000:00:01.0
[    1.995541] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    2.001634] pci 0000:00:02.0: [8086:0102] type 00 class 0x030000
[    2.007635] pci 0000:00:02.0: reg 10: [mem 0xfe000000-0xfe3fffff 64bit]
[    2.014239] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    2.021273] pci 0000:00:02.0: reg 20: [io  0xf000-0xf03f]
[    2.026704] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    2.032718] pci 0000:00:16.0: reg 10: [mem 0xfe607000-0xfe60700f 64bit]
[    2.039390] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    2.045499] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    2.051510] pci 0000:00:1a.0: reg 10: [mem 0xfe606000-0xfe6063ff]
[    2.057672] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    2.063772] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    2.069778] pci 0000:00:1b.0: reg 10: [mem 0xfe600000-0xfe603fff 64bit]
[    2.076439] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    2.082540] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    2.088597] calling  pci_fixup_transparent_bridge+0x0/0x1d @ 1 for 0000:00:1c.0
[    2.095892] pci fixup pci_fixup_transparent_bridge+0x0/0x1d returned after 0 usecs for 0000:00:1c.0
[    2.104988] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.111099] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
[    2.117129] calling  pci_fixup_transparent_bridge+0x0/0x1d @ 1 for 0000:00:1c.4
[    2.124419] pci fixup pci_fixup_transparent_bridge+0x0/0x1d returned after 0 usecs for 0000:00:1c.4
[    2.133483] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    2.139587] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    2.145598] pci 0000:00:1d.0: reg 10: [mem 0xfe605000-0xfe6053ff]
[    2.151762] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    2.157860] pci 0000:00:1f.0: [8086:1c5c] type 00 class 0x060100
[    2.163963] pci 0000:00:1f.2: [8086:1c00] type 00 class 0x01018a
[    2.169970] pci 0000:00:1f.2: reg 10: [io  0xf110-0xf117]
[    2.175360] pci 0000:00:1f.2: reg 14: [io  0xf100-0xf103]
[    2.180753] pci 0000:00:1f.2: reg 18: [io  0xf0f0-0xf0f7]
[    2.186144] pci 0000:00:1f.2: reg 1c: [io  0xf0e0-0xf0e3]
[    2.191538] pci 0000:00:1f.2: reg 20: [io  0xf0d0-0xf0df]
[    2.196931] pci 0000:00:1f.2: reg 24: [io  0xf0c0-0xf0cf]
[    2.202355] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    2.208358] pci 0000:00:1f.3: reg 10: [mem 0xfe604000-0xfe6040ff 64bit]
[    2.214974] pci 0000:00:1f.3: reg 20: [io  0xf040-0xf05f]
[    2.220388] pci 0000:00:1f.5: [8086:1c08] type 00 class 0x010185
[    2.226393] pci 0000:00:1f.5: reg 10: [io  0xf0b0-0xf0b7]
[    2.231784] pci 0000:00:1f.5: reg 14: [io  0xf0a0-0xf0a3]
[    2.237175] pci 0000:00:1f.5: reg 18: [io  0xf090-0xf097]
[    2.242568] pci 0000:00:1f.5: reg 1c: [io  0xf080-0xf083]
[    2.247961] pci 0000:00:1f.5: reg 20: [io  0xf070-0xf07f]
[    2.253351] pci 0000:00:1f.5: reg 24: [io  0xf060-0xf06f]
[    2.258813] pci 0000:01:00.0: [8086:10d3] type 00 class 0x020000
[    2.264821] pci 0000:01:00.0: reg 10: [mem 0xfe5c0000-0xfe5dffff]
[    2.270913] pci 0000:01:00.0: reg 14: [mem 0xfe500000-0xfe57ffff]
[    2.277002] pci 0000:01:00.0: reg 18: [io  0xe000-0xe01f]
[    2.282403] pci 0000:01:00.0: reg 1c: [mem 0xfe5e0000-0xfe5e3fff]
[    2.288516] pci 0000:01:00.0: reg 30: [mem 0xfe580000-0xfe5bffff pref]
[    2.295098] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    2.303178] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.308395] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    2.314476] pci 0000:00:01.0:   bridge window [mem 0xfe500000-0xfe5fffff]
[    2.321313] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.326603] pci 0000:03:00.0: [1969:1083] type 00 class 0x020000
[    2.332624] pci 0000:03:00.0: reg 10: [mem 0xfe400000-0xfe43ffff 64bit]
[    2.339234] pci 0000:03:00.0: reg 18: [io  0xd000-0xd07f]
[    2.344741] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.353161] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    2.358377] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    2.364459] pci 0000:00:1c.4:   bridge window [mem 0xfe400000-0xfe4fffff]
[    2.371252] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.377251] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    2.383617] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    2.389985] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    2.396429]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    2.402208]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x0d
[    2.410540] ACPI _OSC control for PCIe not granted, disabling ASPM
[    2.420084] initcall acpi_pci_root_init+0x0/0x2d returned 0 after 97641 usecs
[    2.427204] calling  acpi_pci_link_init+0x0/0x43 @ 1
[    2.432191] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    2.439400] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    2.446624] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
[    2.453653] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[    2.460685] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    2.468075] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    2.475478] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    2.482689] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    2.489905] initcall acpi_pci_link_init+0x0/0x43 returned 0 after 27339 usecs
[    2.497025] calling  pnp_init+0x0/0x19 @ 1
[    2.501133] initcall pnp_init+0x0/0x19 returned 0 after 0 usecs
[    2.507041] calling  xen_setup_shutdown_event+0x0/0x30 @ 1
[    2.512516] initcall xen_setup_shutdown_event+0x0/0x30 returned -19 after 0 usecs
[    2.519981] calling  balloon_init+0x0/0x133 @ 1
[    2.524499] initcall balloon_init+0x0/0x133 returned -19 after 0 usecs
[    2.531012] calling  xenbus_probe_backend_init+0x0/0x34 @ 1
[    2.536592] initcall xenbus_probe_backend_init+0x0/0x34 returned 0 after 0 usecs
[    2.543973] calling  xenbus_probe_frontend_init+0x0/0x34 @ 1
[    2.549636] initcall xenbus_probe_frontend_init+0x0/0x34 returned 0 after 0 usecs
[    2.557106] calling  balloon_init+0x0/0xfa @ 1
[    2.561540] initcall balloon_init+0x0/0xfa returned -19 after 0 usecs
[    2.567966] calling  xen_selfballoon_init+0x0/0x82 @ 1
[    2.573090] initcall xen_selfballoon_init+0x0/0x82 returned -19 after 0 usecs
[    2.580209] calling  misc_init+0x0/0xba @ 1
[    2.584400] initcall misc_init+0x0/0xba returned 0 after 0 usecs
[    2.590396] calling  vga_arb_device_init+0x0/0xde @ 1
[    2.595462] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.603538] vgaarb: loaded
[    2.606237] vgaarb: bridge control possible 0000:00:02.0
[    2.611537] initcall vga_arb_device_init+0x0/0xde returned 0 after 2929 usecs
[    2.618658] calling  cn_init+0x0/0x9e @ 1
[    2.622664] initcall cn_init+0x0/0x9e returned 0 after 0 usecs
[    2.628484] calling  phy_init+0x0/0x2e @ 1
[    2.632618] initcall phy_init+0x0/0x2e returned 0 after 0 usecs
[    2.638528] calling  init_pcmcia_cs+0x0/0x3d @ 1
[    2.643152] initcall init_pcmcia_cs+0x0/0x3d returned 0 after 0 usecs
[    2.649579] calling  usb_init+0x0/0x17a @ 1
[    2.653801] usbcore: registered new interface driver usbfs
[    2.659295] usbcore: registered new interface driver hub
[    2.664617] usbcore: registered new device driver usb
[    2.669661] initcall usb_init+0x0/0x17a returned 0 after 2929 usecs
[    2.675914] calling  serio_init+0x0/0x38 @ 1
[    2.680194] initcall serio_init+0x0/0x38 returned 0 after 0 usecs
[    2.686273] calling  input_init+0x0/0x10c @ 1
[    2.690639] initcall input_init+0x0/0x10c returned 0 after 0 usecs
[    2.696807] calling  rtc_init+0x0/0x71 @ 1
[    2.700910] initcall rtc_init+0x0/0x71 returned 0 after 0 usecs
[    2.706818] calling  power_supply_class_init+0x0/0x44 @ 1
[    2.712224] initcall power_supply_class_init+0x0/0x44 returned 0 after 0 usecs
[    2.719430] calling  hwmon_init+0x0/0xee @ 1
[    2.723709] initcall hwmon_init+0x0/0xee returned 0 after 0 usecs
[    2.729789] calling  leds_init+0x0/0x48 @ 1
[    2.733981] initcall leds_init+0x0/0x48 returned 0 after 0 usecs
[    2.739974] calling  pci_subsys_init+0x0/0x4f @ 1
[    2.744667] PCI: Using ACPI for IRQ routing
[    2.754852] PCI: pci_cache_line_size set to 64 bytes
[    2.759850] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    2.766014] reserve RAM buffer: 00000000bad80000 - 00000000bbffffff 
[    2.772365] reserve RAM buffer: 00000000badf6000 - 00000000bbffffff 
[    2.778717] reserve RAM buffer: 00000000bb000000 - 00000000bbffffff 
[    2.785066] reserve RAM buffer: 000000023fe00000 - 000000023fffffff 
[    2.791419] initcall pci_subsys_init+0x0/0x4f returned 0 after 12693 usecs
[    2.798464] calling  proto_init+0x0/0x12 @ 1
[    2.802724] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    2.808804] calling  net_dev_init+0x0/0x1b1 @ 1
[    2.813429] initcall net_dev_init+0x0/0x1b1 returned 0 after 0 usecs
[    2.819772] calling  neigh_init+0x0/0x80 @ 1
[    2.824033] initcall neigh_init+0x0/0x80 returned 0 after 0 usecs
[    2.830111] calling  fib_rules_init+0x0/0xaf @ 1
[    2.834718] initcall fib_rules_init+0x0/0xaf returned 0 after 0 usecs
[    2.841147] calling  pktsched_init+0x0/0xfe @ 1
[    2.845669] initcall pktsched_init+0x0/0xfe returned 0 after 0 usecs
[    2.852006] calling  tc_filter_init+0x0/0x55 @ 1
[    2.856613] initcall tc_filter_init+0x0/0x55 returned 0 after 0 usecs
[    2.863037] calling  tc_action_init+0x0/0x55 @ 1
[    2.867643] initcall tc_action_init+0x0/0x55 returned 0 after 0 usecs
[    2.874066] calling  genl_init+0x0/0x84 @ 1
[    2.878244] initcall genl_init+0x0/0x84 returned 0 after 0 usecs
[    2.884238] calling  cipso_v4_init+0x0/0x61 @ 1
[    2.888759] initcall cipso_v4_init+0x0/0x61 returned 0 after 0 usecs
[    2.895096] calling  netlbl_init+0x0/0x81 @ 1
[    2.899440] NetLabel: Initializing
[    2.902835] NetLabel:  domain hash size = 128
[    2.907183] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.912141] NetLabel:  unlabeled traffic allowed by default
[    2.917699] initcall netlbl_init+0x0/0x81 returned 0 after 3905 usecs
[    2.924123] calling  rfkill_init+0x0/0x79 @ 1
[    2.928506] initcall rfkill_init+0x0/0x79 returned 0 after 0 usecs
[    2.934674] calling  net_sysctl_init+0x0/0x49 @ 1
[    2.939370] initcall net_sysctl_init+0x0/0x49 returned 0 after 0 usecs
[    2.945908] calling  hpet_late_init+0x0/0x101 @ 1
[    2.950609] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    2.956888] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    2.964714] initcall hpet_late_init+0x0/0x101 returned 0 after 5858 usecs
[    2.971490] calling  init_amd_nbs+0x0/0xb8 @ 1
[    2.975929] initcall init_amd_nbs+0x0/0xb8 returned 0 after 0 usecs
[    2.982182] calling  clocksource_done_booting+0x0/0x5a @ 1
[    2.987656] Switching to clocksource hpet
[    2.991668] initcall clocksource_done_booting+0x0/0x5a returned 0 after 980 usecs
[    2.999137] calling  init_pipe_fs+0x0/0x4c @ 1
[    3.003585] initcall init_pipe_fs+0x0/0x4c returned 0 after 11 usecs
[    3.009927] calling  eventpoll_init+0x0/0xda @ 1
[    3.014557] initcall eventpoll_init+0x0/0xda returned 0 after 18 usecs
[    3.021069] calling  anon_inode_init+0x0/0x5b @ 1
[    3.025769] initcall anon_inode_init+0x0/0x5b returned 0 after 4 usecs
[    3.032282] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
[    3.037413] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
[    3.044360] calling  acpi_event_init+0x0/0x81 @ 1
[    3.049064] initcall acpi_event_init+0x0/0x81 returned 0 after 5 usecs
[    3.055576] calling  pnp_system_init+0x0/0x12 @ 1
[    3.060302] initcall pnp_system_init+0x0/0x12 returned 0 after 31 usecs
[    3.066907] calling  pnpacpi_init+0x0/0x8c @ 1
[    3.071342] pnp: PnP ACPI init
[    3.074396] ACPI: bus type pnp registered
[    3.078525] pnp 00:00: [bus 00-ff]
[    3.081922] pnp 00:00: [io  0x0cf8-0x0cff]
[    3.086011] pnp 00:00: [io  0x0000-0x03af window]
[    3.090707] pnp 00:00: [io  0x03e0-0x0cf7 window]
[    3.095403] pnp 00:00: [io  0x03b0-0x03df window]
[    3.100099] pnp 00:00: [io  0x0d00-0xffff window]
[    3.104792] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    3.110181] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    3.115567] pnp 00:00: [mem 0xbfa00000-0xffffffff window]
[    3.120955] pnp 00:00: [mem 0x00000000 window]
[    3.125444] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    3.132709] pnp 00:01: [mem 0xfed10000-0xfed19fff]
[    3.137490] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    3.142272] pnp 00:01: [mem 0xfed90000-0xfed93fff]
[    3.147053] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    3.151832] pnp 00:01: [mem 0xfee00000-0xfee0ffff]
[    3.156661] system 00:01: [mem 0xfed10000-0xfed19fff] has been reserved
[    3.163263] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    3.169863] system 00:01: [mem 0xfed90000-0xfed93fff] has been reserved
[    3.176463] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    3.183064] system 00:01: [mem 0xfee00000-0xfee0ffff] has been reserved
[    3.189663] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    3.196537] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    3.202446] pnp 00:02: [io  0x0a00-0x0a1f]
[    3.206533] pnp 00:02: [io  0x0a30-0x0a3f]
[    3.210623] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    3.216577] system 00:02: [io  0x0a00-0x0a1f] has been reserved
[    3.222487] system 00:02: [io  0x0a30-0x0a3f] has been reserved
[    3.228394] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.235189] pnp 00:03: [io  0x0060]
[    3.238670] pnp 00:03: [io  0x0064]
[    3.242160] pnp 00:03: [irq 1]
[    3.245245] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    3.252482] pnp 00:04: [irq 12]
[    3.255655] pnp 00:04: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    3.263064] pnp 00:05: [io  0x03f8-0x03ff]
[    3.267155] pnp 00:05: [irq 4]
[    3.270202] pnp 00:05: [dma 0 disabled]
[    3.274089] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    3.280613] pnp 00:06: [dma 4]
[    3.283663] pnp 00:06: [io  0x0000-0x000f]
[    3.287751] pnp 00:06: [io  0x0081-0x0083]
[    3.291841] pnp 00:06: [io  0x0087]
[    3.295324] pnp 00:06: [io  0x0089-0x008b]
[    3.299414] pnp 00:06: [io  0x008f]
[    3.302897] pnp 00:06: [io  0x00c0-0x00df]
[    3.307021] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    3.313541] pnp 00:07: [io  0x0070-0x0071]
[    3.317631] pnp 00:07: [irq 8]
[    3.320714] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    3.327234] pnp 00:08: [io  0x0061]
[    3.330746] pnp 00:08: Plug and Play ACPI device, IDs PNP0800 (active)
[    3.337283] pnp 00:09: [io  0x0010-0x001f]
[    3.341368] pnp 00:09: [io  0x0022-0x003f]
[    3.345459] pnp 00:09: [io  0x0044-0x005f]
[    3.349549] pnp 00:09: [io  0x0062-0x0063]
[    3.353637] pnp 00:09: [io  0x0065-0x006f]
[    3.357728] pnp 00:09: [io  0x0072-0x007f]
[    3.361820] pnp 00:09: [io  0x0080]
[    3.365300] pnp 00:09: [io  0x0084-0x0086]
[    3.369387] pnp 00:09: [io  0x0088]
[    3.372868] pnp 00:09: [io  0x008c-0x008e]
[    3.376953] pnp 00:09: [io  0x0090-0x009f]
[    3.381039] pnp 00:09: [io  0x00a2-0x00bf]
[    3.385129] pnp 00:09: [io  0x00e0-0x00ef]
[    3.389220] pnp 00:09: [io  0x04d0-0x04d1]
[    3.393356] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    3.399269] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.406048] pnp 00:0a: [io  0x00f0-0x00ff]
[    3.410138] pnp 00:0a: [irq 13]
[    3.413307] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    3.420089] pnp 00:0b: [io  0x0378-0x037f]
[    3.424181] pnp 00:0b: [irq 5]
[    3.427226] pnp 00:0b: [dma 3]
[    3.430397] pnp 00:0b: Plug and Play ACPI device, IDs PNP0400 (active)
[    3.437071] pnp 00:0c: [io  0x0400-0x0453]
[    3.441161] pnp 00:0c: [io  0x0458-0x047f]
[    3.445248] pnp 00:0c: [io  0x1180-0x119f]
[    3.449335] pnp 00:0c: [io  0x0500-0x057f]
[    3.453419] pnp 00:0c: [mem 0xfed1c000-0xfed1ffff]
[    3.458200] pnp 00:0c: [mem 0xfec00000-0xfecfffff]
[    3.462981] pnp 00:0c: [mem 0xfed08000-0xfed08fff]
[    3.467761] pnp 00:0c: [mem 0xff000000-0xffffffff]
[    3.472587] system 00:0c: [io  0x0400-0x0453] has been reserved
[    3.478497] system 00:0c: [io  0x0458-0x047f] has been reserved
[    3.484405] system 00:0c: [io  0x1180-0x119f] has been reserved
[    3.490315] system 00:0c: [io  0x0500-0x057f] has been reserved
[    3.496224] system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    3.502824] system 00:0c: [mem 0xfec00000-0xfecfffff] could not be reserved
[    3.509770] system 00:0c: [mem 0xfed08000-0xfed08fff] has been reserved
[    3.516370] system 00:0c: [mem 0xff000000-0xffffffff] has been reserved
[    3.522973] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    3.529780] pnp 00:0d: [io  0x0454-0x0457]
[    3.533913] system 00:0d: [io  0x0454-0x0457] has been reserved
[    3.539821] system 00:0d: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    3.547388] pnp 00:0e: [mem 0xfed00000-0xfed003ff]
[    3.552210] pnp 00:0e: Plug and Play ACPI device, IDs PNP0103 (active)
[    3.558848] pnp: PnP ACPI: found 15 devices
[    3.563026] ACPI: ACPI bus type pnp unregistered
[    3.567644] initcall pnpacpi_init+0x0/0x8c returned 0 after 484775 usecs
[    3.574333] calling  pcistub_init+0x0/0x1d7 @ 1
[    3.578912] initcall pcistub_init+0x0/0x1d7 returned 0 after 54 usecs
[    3.585341] calling  chr_dev_init+0x0/0xc6 @ 1
[    3.591822] initcall chr_dev_init+0x0/0xc6 returned 0 after 1996 usecs
[    3.598340] calling  firmware_class_init+0x0/0x19 @ 1
[    3.603409] initcall firmware_class_init+0x0/0x19 returned 0 after 25 usecs
[    3.610356] calling  init_pcmcia_bus+0x0/0x6c @ 1
[    3.615080] initcall init_pcmcia_bus+0x0/0x6c returned 0 after 26 usecs
[    3.621681] calling  thermal_init+0x0/0x75 @ 1
[    3.626145] initcall thermal_init+0x0/0x75 returned 0 after 27 usecs
[    3.632486] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    3.638310] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
[    3.645951] calling  init_acpi_pm_clocksource+0x0/0xec @ 1
[    3.655943] initcall init_acpi_pm_clocksource+0x0/0xec returned 0 after 4410 usecs
[    3.663497] calling  pcibios_assign_resources+0x0/0xf8 @ 1
[    3.669002] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    3.674215] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    3.680297] pci 0000:00:01.0:   bridge window [mem 0xfe500000-0xfe5fffff]
[    3.687075] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    3.692303] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    3.697520] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    3.703608] pci 0000:00:1c.4:   bridge window [mem 0xfe400000-0xfe4fffff]
[    3.710407] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    3.715968] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    3.721528] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    3.727090] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    3.732653] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    3.738909] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    3.745165] pci_bus 0000:00: resource 10 [mem 0xbfa00000-0xffffffff]
[    3.751506] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    3.757066] pci_bus 0000:01: resource 1 [mem 0xfe500000-0xfe5fffff]
[    3.763323] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    3.768885] pci_bus 0000:03: resource 1 [mem 0xfe400000-0xfe4fffff]
[    3.775142] initcall pcibios_assign_resources+0x0/0xf8 returned 0 after 103703 usecs
[    3.782870] calling  sysctl_core_init+0x0/0x38 @ 1
[    3.787669] initcall sysctl_core_init+0x0/0x38 returned 0 after 14 usecs
[    3.794355] calling  inet_init+0x0/0x2a3 @ 1
[    3.798659] NET: Registered protocol family 2
[    3.803135] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    3.811017] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    3.819681] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    3.826516] TCP: Hash tables configured (established 524288 bind 65536)
[    3.833115] TCP: reno registered
[    3.836342] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    3.842448] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    3.849053] initcall inet_init+0x0/0x2a3 returned 0 after 49260 usecs
[    3.855482] calling  af_unix_init+0x0/0x55 @ 1
[    3.859924] NET: Registered protocol family 1
[    3.864276] initcall af_unix_init+0x0/0x55 returned 0 after 4258 usecs
[    3.870791] calling  init_sunrpc+0x0/0x69 @ 1
[    3.875215] RPC: Registered named UNIX socket transport module.
[    3.881123] RPC: Registered udp transport module.
[    3.885819] RPC: Registered tcp transport module.
[    3.890516] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.896945] initcall init_sunrpc+0x0/0x69 returned 0 after 21298 usecs
[    3.903461] calling  pci_apply_final_quirks+0x0/0x10c @ 1
[    3.908858] calling  disable_igfx_irq+0x0/0x6b @ 1 for 0000:00:02.0
[    3.915834] pci 0000:00:02.0: BIOS left Intel GPU interrupts enabled; disabling
[    3.923474] pci fixup disable_igfx_irq+0x0/0x6b returned after 8164 usecs for 0000:00:02.0
[    3.931723] calling  pci_fixup_video+0x0/0xa0 @ 1 for 0000:00:02.0
[    3.937890] pci 0000:00:02.0: Boot video device
[    3.942415] pci fixup pci_fixup_video+0x0/0xa0 returned after 4419 usecs for 0000:00:02.0
[    3.950578] calling  quirk_usb_early_handoff+0x0/0x617 @ 1 for 0000:00:1a.0
[    3.957556] pci fixup quirk_usb_early_handoff+0x0/0x617 returned after 30 usecs for 0000:00:1a.0
[    3.966333] calling  quirk_usb_early_handoff+0x0/0x617 @ 1 for 0000:00:1d.0
[    3.973307] pci fixup quirk_usb_early_handoff+0x0/0x617 returned after 24 usecs for 0000:00:1d.0
[    3.982088] calling  quirk_e100_interrupt+0x0/0x15e @ 1 for 0000:01:00.0
[    3.988776] pci fixup quirk_e100_interrupt+0x0/0x15e returned after 0 usecs for 0000:01:00.0
[    3.997201] PCI: CLS 64 bytes, default 64
[    4.001204] initcall pci_apply_final_quirks+0x0/0x10c returned 0 after 90207 usecs
[    4.008759] calling  populate_rootfs+0x0/0xd3 @ 1
[    4.013514] Trying to unpack rootfs image as initramfs...
[    4.948406] Freeing initrd memory: 65236k freed
[    4.959705] initcall populate_rootfs+0x0/0xd3 returned 0 after 924271 usecs
[    4.966670] calling  pci_iommu_init+0x0/0x41 @ 1
[    4.971277] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.977708] Placing 64MB software IO TLB between ffff8800b6d80000 - ffff8800bad80000
[    4.985436] software IO TLB at phys 0xb6d80000 - 0xbad80000
[    4.991001] initcall pci_iommu_init+0x0/0x41 returned 0 after 19264 usecs
[    4.997777] calling  calgary_fixup_tce_spaces+0x0/0x105 @ 1
[    5.003345] initcall calgary_fixup_tce_spaces+0x0/0x105 returned -19 after 0 usecs
[    5.010925] calling  irqfd_module_init+0x0/0x33 @ 1
[    5.015899] initcall irqfd_module_init+0x0/0x33 returned 0 after 101 usecs
[    5.022767] calling  i8259A_init_ops+0x0/0x21 @ 1
[    5.027466] initcall i8259A_init_ops+0x0/0x21 returned 0 after 0 usecs
[    5.033980] calling  vsyscall_init+0x0/0x27 @ 1
[    5.038511] initcall vsyscall_init+0x0/0x27 returned 0 after 5 usecs
[    5.044856] calling  sbf_init+0x0/0xf6 @ 1
[    5.048945] initcall sbf_init+0x0/0xf6 returned 0 after 0 usecs
[    5.054854] calling  init_tsc_clocksource+0x0/0x89 @ 1
[    5.059986] initcall init_tsc_clocksource+0x0/0x89 returned 0 after 1 usecs
[    5.066937] calling  add_rtc_cmos+0x0/0x96 @ 1
[    5.071376] initcall add_rtc_cmos+0x0/0x96 returned 0 after 3 usecs
[    5.077632] calling  i8237A_init_ops+0x0/0x14 @ 1
[    5.082329] initcall i8237A_init_ops+0x0/0x14 returned 0 after 0 usecs
[    5.088847] calling  cache_sysfs_init+0x0/0x6c @ 1
[    5.093712] initcall cache_sysfs_init+0x0/0x6c returned 0 after 80 usecs
[    5.100399] calling  mcheck_init_device+0x0/0x120 @ 1
[    5.105655] initcall mcheck_init_device+0x0/0x120 returned 0 after 206 usecs
[    5.112689] calling  threshold_init_device+0x0/0x8f @ 1
[    5.117906] initcall threshold_init_device+0x0/0x8f returned 0 after 0 usecs
[    5.124942] calling  inject_init+0x0/0x40 @ 1
[    5.129299] Machine check injector initialized
[    5.133737] initcall inject_init+0x0/0x40 returned 0 after 4333 usecs
[    5.140164] calling  thermal_throttle_init_device+0x0/0x9d @ 1
[    5.145998] initcall thermal_throttle_init_device+0x0/0x9d returned 0 after 10 usecs
[    5.153726] calling  amd_ibs_init+0x0/0x442 @ 1
[    5.158249] initcall amd_ibs_init+0x0/0x442 returned -19 after 0 usecs
[    5.164764] calling  msr_init+0x0/0x14c @ 1
[    5.169082] initcall msr_init+0x0/0x14c returned 0 after 137 usecs
[    5.175252] calling  cpuid_init+0x0/0x14c @ 1
[    5.179736] initcall cpuid_init+0x0/0x14c returned 0 after 130 usecs
[    5.186080] calling  ioapic_init_ops+0x0/0x14 @ 1
[    5.190777] initcall ioapic_init_ops+0x0/0x14 returned 0 after 1 usecs
[    5.197291] calling  add_pcspkr+0x0/0x60 @ 1
[    5.201583] initcall add_pcspkr+0x0/0x60 returned 0 after 28 usecs
[    5.207754] calling  microcode_init+0x0/0x182 @ 1
[    5.212481] microcode: CPU0 sig=0x206a7, pf=0x2, revision=0x12
[    5.218307] microcode: CPU1 sig=0x206a7, pf=0x2, revision=0x12
[    5.224129] microcode: CPU2 sig=0x206a7, pf=0x2, revision=0x12
[    5.229954] microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x12
[    5.235800] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    5.244572] initcall microcode_init+0x0/0x182 returned 0 after 31374 usecs
[    5.251433] calling  start_periodic_check_for_corruption+0x0/0x50 @ 1
[    5.257861] initcall start_periodic_check_for_corruption+0x0/0x50 returned 0 after 0 usecs
[    5.266110] calling  audit_classes_init+0x0/0xaf @ 1
[    5.271071] initcall audit_classes_init+0x0/0xaf returned 0 after 2 usecs
[    5.277847] calling  pt_dump_init+0x0/0x30 @ 1
[    5.282289] initcall pt_dump_init+0x0/0x30 returned 0 after 4 usecs
[    5.288544] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    5.293331] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 3 usecs
[    5.299932] calling  proc_execdomains_init+0x0/0x22 @ 1
[    5.305148] initcall proc_execdomains_init+0x0/0x22 returned 0 after 3 usecs
[    5.312180] calling  ioresources_init+0x0/0x3c @ 1
[    5.316967] initcall ioresources_init+0x0/0x3c returned 0 after 1 usecs
[    5.323569] calling  uid_cache_init+0x0/0xa5 @ 1
[    5.328192] initcall uid_cache_init+0x0/0xa5 returned 0 after 12 usecs
[    5.334709] calling  init_posix_timers+0x0/0x1f4 @ 1
[    5.339673] initcall init_posix_timers+0x0/0x1f4 returned 0 after 7 usecs
[    5.346450] calling  init_posix_cpu_timers+0x0/0xbf @ 1
[    5.351666] initcall init_posix_cpu_timers+0x0/0xbf returned 0 after 0 usecs
[    5.358701] calling  proc_schedstat_init+0x0/0x22 @ 1
[    5.363747] initcall proc_schedstat_init+0x0/0x22 returned 0 after 1 usecs
[    5.370607] calling  snapshot_device_init+0x0/0x12 @ 1
[    5.375772] initcall snapshot_device_init+0x0/0x12 returned 0 after 33 usecs
[    5.382808] calling  create_proc_profile+0x0/0x2f0 @ 1
[    5.387937] initcall create_proc_profile+0x0/0x2f0 returned 0 after 0 usecs
[    5.394885] calling  timekeeping_init_ops+0x0/0x14 @ 1
[    5.400015] initcall timekeeping_init_ops+0x0/0x14 returned 0 after 0 usecs
[    5.406964] calling  init_clocksource_sysfs+0x0/0x52 @ 1
[    5.412322] initcall init_clocksource_sysfs+0x0/0x52 returned 0 after 54 usecs
[    5.419532] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    5.424838] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 1 usecs
[    5.431961] calling  alarmtimer_init+0x0/0x182 @ 1
[    5.436800] initcall alarmtimer_init+0x0/0x182 returned 0 after 54 usecs
[    5.443489] calling  init_tstats_procfs+0x0/0x2c @ 1
[    5.448449] initcall init_tstats_procfs+0x0/0x2c returned 0 after 1 usecs
[    5.455228] calling  futex_init+0x0/0x65 @ 1
[    5.459493] initcall futex_init+0x0/0x65 returned 0 after 3 usecs
[    5.465576] calling  proc_dma_init+0x0/0x22 @ 1
[    5.470100] initcall proc_dma_init+0x0/0x22 returned 0 after 1 usecs
[    5.476441] calling  proc_modules_init+0x0/0x22 @ 1
[    5.481313] initcall proc_modules_init+0x0/0x22 returned 0 after 1 usecs
[    5.488000] calling  kallsyms_init+0x0/0x25 @ 1
[    5.492524] initcall kallsyms_init+0x0/0x25 returned 0 after 1 usecs
[    5.498867] calling  crash_save_vmcoreinfo_init+0x0/0x4a9 @ 1
[    5.504617] initcall crash_save_vmcoreinfo_init+0x0/0x4a9 returned 0 after 13 usecs
[    5.512257] calling  crash_notes_memory_init+0x0/0x36 @ 1
[    5.517651] initcall crash_notes_memory_init+0x0/0x36 returned 0 after 2 usecs
[    5.524861] calling  user_namespaces_init+0x0/0x2d @ 1
[    5.530000] initcall user_namespaces_init+0x0/0x2d returned 0 after 8 usecs
[    5.536946] calling  pid_namespaces_init+0x0/0x40 @ 1
[    5.542001] initcall pid_namespaces_init+0x0/0x40 returned 0 after 9 usecs
[    5.548861] calling  ikconfig_init+0x0/0x3a @ 1
[    5.553386] initcall ikconfig_init+0x0/0x3a returned 0 after 1 usecs
[    5.559725] calling  audit_init+0x0/0x133 @ 1
[    5.564073] audit: initializing netlink socket (disabled)
[    5.569468] type=2000 audit(1336393914.289:1): initialized
[    5.574944] initcall audit_init+0x0/0x133 returned 0 after 10617 usecs
[    5.581459] calling  audit_watch_init+0x0/0x3a @ 1
[    5.586243] initcall audit_watch_init+0x0/0x3a returned 0 after 0 usecs
[    5.592844] calling  audit_tree_init+0x0/0x49 @ 1
[    5.597542] initcall audit_tree_init+0x0/0x49 returned 0 after 1 usecs
[    5.604055] calling  init_kprobes+0x0/0x16c @ 1
[    5.618655] initcall init_kprobes+0x0/0x16c returned 0 after 9841 usecs
[    5.625258] calling  irq_pm_init_ops+0x0/0x14 @ 1
[    5.629955] initcall irq_pm_init_ops+0x0/0x14 returned 0 after 0 usecs
[    5.636470] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    5.641518] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 4 usecs
[    5.648378] calling  perf_event_sysfs_init+0x0/0x9a @ 1
[    5.653713] initcall perf_event_sysfs_init+0x0/0x9a returned 0 after 112 usecs
[    5.660923] calling  init_per_zone_wmark_min+0x0/0x8c @ 1
[    5.666528] initcall init_per_zone_wmark_min+0x0/0x8c returned 0 after 211 usecs
[    5.673910] calling  kswapd_init+0x0/0x76 @ 1
[    5.678283] initcall kswapd_init+0x0/0x76 returned 0 after 21 usecs
[    5.684539] calling  extfrag_debug_init+0x0/0x72 @ 1
[    5.689498] initcall extfrag_debug_init+0x0/0x72 returned 0 after 4 usecs
[    5.696275] calling  setup_vmstat+0x0/0xc8 @ 1
[    5.700718] initcall setup_vmstat+0x0/0xc8 returned 0 after 6 usecs
[    5.706975] calling  mm_sysfs_init+0x0/0x29 @ 1
[    5.711500] initcall mm_sysfs_init+0x0/0x29 returned 0 after 2 usecs
[    5.717841] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    5.722711] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 1 usecs
[    5.729400] calling  procswaps_init+0x0/0x22 @ 1
[    5.734010] initcall procswaps_init+0x0/0x22 returned 0 after 1 usecs
[    5.740436] calling  hugetlb_init+0x0/0x430 @ 1
[    5.744960] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.751310] initcall hugetlb_init+0x0/0x430 returned 0 after 6202 usecs
[    5.757910] calling  slab_proc_init+0x0/0x25 @ 1
[    5.762522] initcall slab_proc_init+0x0/0x25 returned 0 after 1 usecs
[    5.768948] calling  cpucache_init+0x0/0x48 @ 1
[    5.773474] initcall cpucache_init+0x0/0x48 returned 0 after 1 usecs
[    5.779814] calling  init_cleancache+0x0/0x96 @ 1
[    5.784517] initcall init_cleancache+0x0/0x96 returned 0 after 7 usecs
[    5.791030] calling  fcntl_init+0x0/0x2a @ 1
[    5.795301] initcall fcntl_init+0x0/0x2a returned 0 after 7 usecs
[    5.801381] calling  proc_filesystems_init+0x0/0x22 @ 1
[    5.806598] initcall proc_filesystems_init+0x0/0x22 returned 0 after 1 usecs
[    5.813633] calling  dio_init+0x0/0x2d @ 1
[    5.817730] initcall dio_init+0x0/0x2d returned 0 after 7 usecs
[    5.823640] calling  fsnotify_mark_init+0x0/0x40 @ 1
[    5.828615] initcall fsnotify_mark_init+0x0/0x40 returned 0 after 17 usecs
[    5.835477] calling  dnotify_init+0x0/0x7b @ 1
[    5.839926] initcall dnotify_init+0x0/0x7b returned 0 after 13 usecs
[    5.846267] calling  inotify_user_setup+0x0/0x70 @ 1
[    5.851238] initcall inotify_user_setup+0x0/0x70 returned 0 after 12 usecs
[    5.858098] calling  aio_setup+0x0/0x7c @ 1
[    5.862287] initcall aio_setup+0x0/0x7c returned 0 after 14 usecs
[    5.868366] calling  proc_locks_init+0x0/0x22 @ 1
[    5.873067] initcall proc_locks_init+0x0/0x22 returned 0 after 1 usecs
[    5.879583] calling  init_sys32_ioctl+0x0/0x28 @ 1
[    5.884425] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 57 usecs
[    5.891111] calling  dquot_init+0x0/0x121 @ 1
[    5.895460] VFS: Disk quotas dquot_6.5.2
[    5.899390] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.905818] initcall dquot_init+0x0/0x121 returned 0 after 10116 usecs
[    5.912333] calling  init_v2_quota_format+0x0/0x22 @ 1
[    5.917462] initcall init_v2_quota_format+0x0/0x22 returned 0 after 0 usecs
[    5.924410] calling  quota_init+0x0/0x26 @ 1
[    5.928678] initcall quota_init+0x0/0x26 returned 0 after 4 usecs
[    5.934761] calling  proc_cmdline_init+0x0/0x22 @ 1
[    5.939632] initcall proc_cmdline_init+0x0/0x22 returned 0 after 1 usecs
[    5.946319] calling  proc_consoles_init+0x0/0x22 @ 1
[    5.951278] initcall proc_consoles_init+0x0/0x22 returned 0 after 1 usecs
[    5.958051] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    5.962922] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 1 usecs
[    5.969610] calling  proc_devices_init+0x0/0x22 @ 1
[    5.974481] initcall proc_devices_init+0x0/0x22 returned 0 after 1 usecs
[    5.981168] calling  proc_interrupts_init+0x0/0x22 @ 1
[    5.986301] initcall proc_interrupts_init+0x0/0x22 returned 0 after 2 usecs
[    5.993247] calling  proc_loadavg_init+0x0/0x22 @ 1
[    5.998119] initcall proc_loadavg_init+0x0/0x22 returned 0 after 1 usecs
[    6.004806] calling  proc_meminfo_init+0x0/0x22 @ 1
[    6.009677] initcall proc_meminfo_init+0x0/0x22 returned 0 after 1 usecs
[    6.016363] calling  proc_stat_init+0x0/0x22 @ 1
[    6.020971] initcall proc_stat_init+0x0/0x22 returned 0 after 1 usecs
[    6.027398] calling  proc_uptime_init+0x0/0x22 @ 1
[    6.032184] initcall proc_uptime_init+0x0/0x22 returned 0 after 1 usecs
[    6.038783] calling  proc_version_init+0x0/0x22 @ 1
[    6.043653] initcall proc_version_init+0x0/0x22 returned 0 after 1 usecs
[    6.050339] calling  proc_softirqs_init+0x0/0x22 @ 1
[    6.055296] initcall proc_softirqs_init+0x0/0x22 returned 0 after 1 usecs
[    6.062070] calling  proc_kcore_init+0x0/0xa9 @ 1
[    6.066774] initcall proc_kcore_init+0x0/0xa9 returned 0 after 5 usecs
[    6.073287] calling  vmcore_init+0x0/0x36b @ 1
[    6.077725] initcall vmcore_init+0x0/0x36b returned 0 after 0 usecs
[    6.083979] calling  proc_kmsg_init+0x0/0x25 @ 1
[    6.088591] initcall proc_kmsg_init+0x0/0x25 returned 0 after 1 usecs
[    6.095017] calling  proc_page_init+0x0/0x42 @ 1
[    6.099630] initcall proc_page_init+0x0/0x42 returned 0 after 2 usecs
[    6.106057] calling  init_devpts_fs+0x0/0x62 @ 1
[    6.110680] initcall init_devpts_fs+0x0/0x62 returned 0 after 12 usecs
[    6.117196] calling  init_ramfs_fs+0x0/0x12 @ 1
[    6.121720] initcall init_ramfs_fs+0x0/0x12 returned 0 after 1 usecs
[    6.128061] calling  init_hugetlbfs_fs+0x0/0x99 @ 1
[    6.132949] initcall init_hugetlbfs_fs+0x0/0x99 returned 0 after 16 usecs
[    6.139724] calling  init_fat_fs+0x0/0x4f @ 1
[    6.144090] initcall init_fat_fs+0x0/0x4f returned 0 after 12 usecs
[    6.150347] calling  init_vfat_fs+0x0/0x12 @ 1
[    6.154785] initcall init_vfat_fs+0x0/0x12 returned 0 after 1 usecs
[    6.161040] calling  init_msdos_fs+0x0/0x12 @ 1
[    6.165563] initcall init_msdos_fs+0x0/0x12 returned 0 after 0 usecs
[    6.171906] calling  init_iso9660_fs+0x0/0x77 @ 1
[    6.176616] initcall init_iso9660_fs+0x0/0x77 returned 0 after 13 usecs
[    6.183215] calling  init_nfs_fs+0x0/0x18b @ 1
[    6.187652] NFS: Registering the id_resolver key type
[    6.192709] Refined TSC clocksource calibration: 3092.973 MHz.
[    6.198536] Switching to clocksource tsc
[    6.202474] initcall init_nfs_fs+0x0/0x18b returned 0 after 14475 usecs
[    6.209079] calling  init_nlm+0x0/0x4c @ 1
[    6.213174] initcall init_nlm+0x0/0x4c returned 0 after 4 usecs
[    6.219086] calling  init_nls_cp437+0x0/0x12 @ 1
[    6.223699] initcall init_nls_cp437+0x0/0x12 returned 0 after 0 usecs
[    6.230130] calling  init_nls_ascii+0x0/0x12 @ 1
[    6.234740] initcall init_nls_ascii+0x0/0x12 returned 0 after 0 usecs
[    6.241173] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    6.246130] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 usecs
[    6.252910] calling  init_nls_utf8+0x0/0x2b @ 1
[    6.257439] initcall init_nls_utf8+0x0/0x2b returned 0 after 0 usecs
[    6.263783] calling  init_ntfs_fs+0x0/0x1d1 @ 1
[    6.268307] NTFS driver 2.1.30 [Flags: R/W].
[    6.272598] initcall init_ntfs_fs+0x0/0x1d1 returned 0 after 4190 usecs
[    6.279203] calling  init_autofs4_fs+0x0/0x2a @ 1
[    6.283941] initcall init_autofs4_fs+0x0/0x2a returned 0 after 36 usecs
[    6.290541] calling  ipc_init+0x0/0x23 @ 1
[    6.294632] msgmni has been set to 15834
[    6.298549] initcall ipc_init+0x0/0x23 returned 0 after 3827 usecs
[    6.304716] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    6.309412] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 5 usecs
[    6.315924] calling  init_mqueue_fs+0x0/0xa2 @ 1
[    6.320543] initcall init_mqueue_fs+0x0/0xa2 returned 0 after 14 usecs
[    6.327059] calling  key_proc_init+0x0/0x5e @ 1
[    6.331582] initcall key_proc_init+0x0/0x5e returned 0 after 1 usecs
[    6.337924] calling  selinux_nf_ip_init+0x0/0x69 @ 1
[    6.342879] initcall selinux_nf_ip_init+0x0/0x69 returned 0 after 0 usecs
[    6.349650] calling  init_sel_fs+0x0/0x9e @ 1
[    6.353996] initcall init_sel_fs+0x0/0x9e returned 0 after 0 usecs
[    6.360163] calling  selnl_init+0x0/0x4d @ 1
[    6.364428] initcall selnl_init+0x0/0x4d returned 0 after 3 usecs
[    6.370507] calling  sel_netif_init+0x0/0x66 @ 1
[    6.375111] initcall sel_netif_init+0x0/0x66 returned 0 after 0 usecs
[    6.381537] calling  sel_netnode_init+0x0/0x75 @ 1
[    6.386315] initcall sel_netnode_init+0x0/0x75 returned 0 after 0 usecs
[    6.392913] calling  sel_netport_init+0x0/0x75 @ 1
[    6.397690] initcall sel_netport_init+0x0/0x75 returned 0 after 0 usecs
[    6.404289] calling  aurule_init+0x0/0x37 @ 1
[    6.408635] initcall aurule_init+0x0/0x37 returned 0 after 0 usecs
[    6.414799] calling  crypto_wq_init+0x0/0x33 @ 1
[    6.419420] initcall crypto_wq_init+0x0/0x33 returned 0 after 12 usecs
[    6.425936] calling  crypto_algapi_init+0x0/0xd @ 1
[    6.430806] initcall crypto_algapi_init+0x0/0xd returned 0 after 1 usecs
[    6.437493] calling  skcipher_module_init+0x0/0x35 @ 1
[    6.442617] initcall skcipher_module_init+0x0/0x35 returned 0 after 0 usecs
[    6.449563] calling  chainiv_module_init+0x0/0x12 @ 1
[    6.454602] initcall chainiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    6.461459] calling  eseqiv_module_init+0x0/0x12 @ 1
[    6.466411] initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    6.473184] calling  hmac_module_init+0x0/0x12 @ 1
[    6.477961] initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
[    6.484559] calling  md5_mod_init+0x0/0x12 @ 1
[    6.489007] initcall md5_mod_init+0x0/0x12 returned 0 after 12 usecs
[    6.495348] calling  sha1_generic_mod_init+0x0/0x12 @ 1
[    6.500572] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 11 usecs
[    6.507691] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    6.512989] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 usecs
[    6.520107] calling  des_generic_mod_init+0x0/0x3f @ 1
[    6.525256] initcall des_generic_mod_init+0x0/0x3f returned 0 after 23 usecs
[    6.532290] calling  zlib_mod_init+0x0/0x12 @ 1
[    6.536821] initcall zlib_mod_init+0x0/0x12 returned 0 after 11 usecs
[    6.543246] calling  crypto_authenc_module_init+0x0/0x12 @ 1
[    6.548890] initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 0 usecs
[    6.556356] calling  crypto_authenc_esn_module_init+0x0/0x12 @ 1
[    6.562348] initcall crypto_authenc_esn_module_init+0x0/0x12 returned 0 after 0 usecs
[    6.570164] calling  lzo_mod_init+0x0/0x12 @ 1
[    6.574611] initcall lzo_mod_init+0x0/0x12 returned 0 after 12 usecs
[    6.580950] calling  krng_mod_init+0x0/0x12 @ 1
[    6.585481] initcall krng_mod_init+0x0/0x12 returned 0 after 11 usecs
[    6.591909] calling  proc_genhd_init+0x0/0x3c @ 1
[    6.596604] initcall proc_genhd_init+0x0/0x3c returned 0 after 2 usecs
[    6.603119] calling  bsg_init+0x0/0x12e @ 1
[    6.607316] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    6.614697] initcall bsg_init+0x0/0x12e returned 0 after 7234 usecs
[    6.620951] calling  noop_init+0x0/0x12 @ 1
[    6.625122] io scheduler noop registered
[    6.629034] initcall noop_init+0x0/0x12 returned 0 after 3820 usecs
[    6.635287] calling  deadline_init+0x0/0x12 @ 1
[    6.639808] io scheduler deadline registered
[    6.644067] initcall deadline_init+0x0/0x12 returned 0 after 4160 usecs
[    6.650665] calling  cfq_init+0x0/0x8b @ 1
[    6.654761] io scheduler cfq registered (default)
[    6.659452] initcall cfq_init+0x0/0x8b returned 0 after 4590 usecs
[    6.665617] calling  percpu_counter_startup+0x0/0x38 @ 1
[    6.670918] initcall percpu_counter_startup+0x0/0x38 returned 0 after 0 usecs
[    6.678038] calling  pci_proc_init+0x0/0x6a @ 1
[    6.682581] initcall pci_proc_init+0x0/0x6a returned 0 after 23 usecs
[    6.689008] calling  pcie_portdrv_init+0x0/0x7a @ 1
[    6.693926] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    6.699305] initcall pcie_portdrv_init+0x0/0x7a returned 0 after 5304 usecs
[    6.706252] calling  aer_service_init+0x0/0x22 @ 1
[    6.711052] initcall aer_service_init+0x0/0x22 returned 0 after 18 usecs
[    6.717741] calling  pci_hotplug_init+0x0/0x1d @ 1
[    6.722522] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    6.728081] initcall pci_hotplug_init+0x0/0x1d returned 0 after 5428 usecs
[    6.734941] calling  pcifront_init+0x0/0x3a @ 1
[    6.739463] initcall pcifront_init+0x0/0x3a returned -19 after 0 usecs
[    6.745975] calling  genericbl_driver_init+0x0/0x12 @ 1
[    6.751211] initcall genericbl_driver_init+0x0/0x12 returned 0 after 20 usecs
[    6.758331] calling  cirrusfb_init+0x0/0xcc @ 1
[    6.762874] initcall cirrusfb_init+0x0/0xcc returned 0 after 21 usecs
[    6.769299] calling  efifb_init+0x0/0x1fc @ 1
[    6.773648] initcall efifb_init+0x0/0x1fc returned -19 after 2 usecs
[    6.779988] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    6.785292] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 1 usecs
[    6.792412] calling  irqrouter_init_ops+0x0/0x26 @ 1
[    6.797364] initcall irqrouter_init_ops+0x0/0x26 returned 0 after 0 usecs
[    6.804135] calling  acpi_ac_init+0x0/0x28 @ 1
[    6.808599] initcall acpi_ac_init+0x0/0x28 returned 0 after 30 usecs
[    6.814940] calling  acpi_button_init+0x0/0x12 @ 1
[    6.819765] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    6.827927] ACPI: Power Button [PWRB]
[    6.831621] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    6.839002] ACPI: Power Button [PWRF]
[    6.842678] initcall acpi_button_init+0x0/0x12 returned 0 after 22424 usecs
[    6.849624] calling  acpi_fan_init+0x0/0x18 @ 1
[    6.854166] initcall acpi_fan_init+0x0/0x18 returned 0 after 22 usecs
[    6.860594] calling  acpi_processor_init+0x0/0x7e @ 1
[    6.865669] ACPI: Requesting acpi_cpufreq
[    6.869951] Monitor-Mwait will be used to enter C-3 state
[    6.875347] ACPI: acpi_idle registered with cpuidle
[    6.880223] async_waiting @ 541
[    6.883358] async_continuing @ 541 after 0 usec
[    6.888238] calling  acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] @ 541
[    6.890147] initcall acpi_processor_init+0x0/0x7e returned 0 after 23943 usecs
[    6.890149] calling  acpi_container_init+0x0/0x4a @ 1
[    6.891265] initcall acpi_container_init+0x0/0x4a returned 0 after 1087 usecs
[    6.891267] calling  acpi_thermal_init+0x0/0x42 @ 1
[    6.891298] initcall acpi_thermal_init+0x0/0x42 returned 0 after 28 usecs
[    6.891300] calling  acpi_battery_init+0x0/0x16 @ 1
[    6.891303] initcall acpi_battery_init+0x0/0x16 returned 0 after 1 usecs
[    6.891306] calling  1_acpi_battery_init_async+0x0/0x1b @ 5
[    6.891308] calling  ioat_init_module+0x0/0x80 @ 1
[    6.891309] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    6.891360] initcall 1_acpi_battery_init_async+0x0/0x1b returned 0 after 50 usecs
[    6.960930] initcall ioat_init_module+0x0/0x80 returned 0 after 68003 usecs
[    6.967947] calling  init+0x0/0x12 @ 1
[    6.971713] initcall init+0x0/0x12 returned 0 after 21 usecs
[    6.971937] initcall acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] returned 0 after 10778 usecs
[    6.971939] async_waiting @ 541
[    6.971940] async_continuing @ 541 after 0 usec
[    6.993521] calling  xenbus_probe_initcall+0x0/0x3b @ 1
[    6.993568] modprobe used greatest stack depth: 5096 bytes left
[    7.004642] initcall xenbus_probe_initcall+0x0/0x3b returned -19 after 0 usecs
[    7.011851] calling  xenbus_init+0x0/0x3d @ 1
[    7.016195] initcall xenbus_init+0x0/0x3d returned -19 after 0 usecs
[    7.022534] calling  xenbus_backend_init+0x0/0x4c @ 1
[    7.027572] initcall xenbus_backend_init+0x0/0x4c returned -19 after 0 usecs
[    7.034603] calling  gntdev_init+0x0/0x4d @ 1
[    7.038949] initcall gntdev_init+0x0/0x4d returned -19 after 0 usecs
[    7.045287] calling  gntalloc_init+0x0/0x3d @ 1
[    7.049805] initcall gntalloc_init+0x0/0x3d returned -19 after 0 usecs
[    7.056316] calling  hypervisor_subsys_init+0x0/0x25 @ 1
[    7.061615] initcall hypervisor_subsys_init+0x0/0x25 returned -19 after 0 usecs
[    7.068906] calling  hyper_sysfs_init+0x0/0xfb @ 1
[    7.073685] initcall hyper_sysfs_init+0x0/0xfb returned -19 after 0 usecs
[    7.080458] calling  platform_pci_module_init+0x0/0x1b @ 1
[    7.085958] initcall platform_pci_module_init+0x0/0x1b returned 0 after 25 usecs
[    7.093340] calling  xen_tmem_init+0x0/0x5c @ 1
[    7.097861] initcall xen_tmem_init+0x0/0x5c returned 0 after 0 usecs
[    7.104203] calling  xen_pcibk_init+0x0/0x136 @ 1
[    7.108893] initcall xen_pcibk_init+0x0/0x136 returned -19 after 0 usecs
[    7.115580] calling  xen_acpi_processor_init+0x0/0x403 @ 1
[    7.121052] initcall xen_acpi_processor_init+0x0/0x403 returned -19 after 0 usecs
[    7.128516] calling  pty_init+0x0/0x4f1 @ 1
[    7.142335] initcall pty_init+0x0/0x4f1 returned 0 after 9420 usecs
[    7.148592] calling  sysrq_init+0x0/0x78 @ 1
[    7.152857] initcall sysrq_init+0x0/0x78 returned 0 after 5 usecs
[    7.158937] calling  xen_hvc_init+0x0/0x244 @ 1
[    7.163455] initcall xen_hvc_init+0x0/0x244 returned -19 after 0 usecs
[    7.169969] calling  serial8250_init+0x0/0x193 @ 1
[    7.174749] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    7.201552] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.207694] initcall serial8250_init+0x0/0x193 returned 0 after 32178 usecs
[    7.214640] calling  serial8250_pnp_init+0x0/0x12 @ 1
[    7.240310] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.245979] initcall serial8250_pnp_init+0x0/0x12 returned 0 after 25690 usecs
[    7.253186] calling  serial8250_pci_init+0x0/0x1b @ 1
[    7.258262] initcall serial8250_pci_init+0x0/0x1b returned 0 after 31 usecs
[    7.265208] calling  init_kgdboc+0x0/0x16 @ 1
[    7.269553] initcall init_kgdboc+0x0/0x16 returned 0 after 0 usecs
[    7.275719] calling  rand_initialize+0x0/0x30 @ 1
[    7.280423] initcall rand_initialize+0x0/0x30 returned 0 after 10 usecs
[    7.287021] calling  hpet_init+0x0/0x6a @ 1
[    7.291325] initcall hpet_init+0x0/0x6a returned 0 after 127 usecs
[    7.297493] calling  nvram_init+0x0/0x82 @ 1
[    7.301775] Non-volatile memory driver v1.3
[    7.305949] initcall nvram_init+0x0/0x82 returned 0 after 4099 usecs
[    7.312288] calling  mod_init+0x0/0x5a @ 1
[    7.316372] initcall mod_init+0x0/0x5a returned -19 after 0 usecs
[    7.322452] calling  agp_init+0x0/0x26 @ 1
[    7.326535] Linux agpgart interface v0.103
[    7.330621] initcall agp_init+0x0/0x26 returned 0 after 3990 usecs
[    7.336787] calling  agp_amd64_mod_init+0x0/0x22 @ 1
[    7.341782] initcall agp_amd64_mod_init+0x0/0x22 returned -19 after 41 usecs
[    7.348814] calling  agp_intel_init+0x0/0x29 @ 1
[    7.353455] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    7.359630] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    7.368852] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    7.375371] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    7.382178] initcall agp_intel_init+0x0/0x29 returned 0 after 28084 usecs
[    7.388954] calling  agp_sis_init+0x0/0x29 @ 1
[    7.393410] initcall agp_sis_init+0x0/0x29 returned 0 after 21 usecs
[    7.399749] calling  agp_via_init+0x0/0x29 @ 1
[    7.404204] initcall agp_via_init+0x0/0x29 returned 0 after 21 usecs
[    7.410547] calling  drm_core_init+0x0/0x139 @ 1
[    7.415185] [drm] Initialized drm 1.1.0 20060810
[    7.419790] initcall drm_core_init+0x0/0x139 returned 0 after 4526 usecs
[    7.426474] calling  cn_proc_init+0x0/0x3d @ 1
[    7.430909] initcall cn_proc_init+0x0/0x3d returned 0 after 0 usecs
[    7.437165] calling  topology_sysfs_init+0x0/0x58 @ 1
[    7.442218] initcall topology_sysfs_init+0x0/0x58 returned 0 after 12 usecs
[    7.449163] calling  brd_init+0x0/0x1d5 @ 1
[    7.454309] brd: module loaded
[    7.457359] initcall brd_init+0x0/0x1d5 returned 0 after 3929 usecs
[    7.463612] calling  loop_init+0x0/0x13a @ 1
[    7.468382] loop: module loaded
[    7.471515] initcall loop_init+0x0/0x13a returned 0 after 3559 usecs
[    7.477854] calling  xen_blkif_init+0x0/0x25f @ 1
[    7.482550] initcall xen_blkif_init+0x0/0x25f returned -19 after 0 usecs
[    7.489238] calling  mac_hid_init+0x0/0x22 @ 1
[    7.493675] initcall mac_hid_init+0x0/0x22 returned 0 after 5 usecs
[    7.499925] calling  net_olddevs_init+0x0/0x9f @ 1
[    7.504705] initcall net_olddevs_init+0x0/0x9f returned 0 after 1 usecs
[    7.511307] calling  fixed_mdio_bus_init+0x0/0x12e @ 1
[    7.516479] Fixed MDIO Bus: probed
[    7.519872] initcall fixed_mdio_bus_init+0x0/0x12e returned 0 after 3361 usecs
[    7.527076] calling  tun_init+0x0/0x93 @ 1
[    7.531161] tun: Universal TUN/TAP device driver, 1.6
[    7.536198] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    7.542388] initcall tun_init+0x0/0x93 returned 0 after 10964 usecs
[    7.548644] calling  tg3_init+0x0/0x1b @ 1
[    7.552760] initcall tg3_init+0x0/0x1b returned 0 after 25 usecs
[    7.558758] calling  ixgbevf_init_module+0x0/0x4c @ 1
[    7.563797] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.2.0-k
[    7.573082] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[    7.579184] initcall ixgbevf_init_module+0x0/0x4c returned 0 after 15027 usecs
[    7.586391] calling  init_nic+0x0/0x1b @ 1
[    7.590499] initcall init_nic+0x0/0x1b returned 0 after 20 usecs
[    7.596493] calling  netback_init+0x0/0x210 @ 1
[    7.601011] initcall netback_init+0x0/0x210 returned -19 after 0 usecs
[    7.607525] calling  nonstatic_sysfs_init+0x0/0x12 @ 1
[    7.612649] initcall nonstatic_sysfs_init+0x0/0x12 returned 0 after 0 usecs
[    7.619593] calling  yenta_socket_init+0x0/0x1b @ 1
[    7.624484] initcall yenta_socket_init+0x0/0x1b returned 0 after 23 usecs
[    7.631257] calling  mon_init+0x0/0xfe @ 1
[    7.635387] initcall mon_init+0x0/0xfe returned 0 after 44 usecs
[    7.641382] calling  ehci_hcd_init+0x0/0xef @ 1
[    7.645899] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.652410] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    7.658427] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    7.664250] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    7.669473] /home/konrad/ssd/linux/drivers/usb/core/inode.c: creating file 'devices'
[    7.677204] /home/konrad/ssd/linux/drivers/usb/core/inode.c: creating file '001'
[    7.684611] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    7.691997] ehci_hcd 0000:00:1a.0: reset hcs_params 0x200002 dbg=2 cc=0 pcc=0 ordered !ppc ports=2
[    7.700939] ehci_hcd 0000:00:1a.0: reset hcc_params 36881 caching frame 1024 64 bit addr
[    7.709022] ehci_hcd 0000:00:1a.0: support lpm
[    7.713460] ehci_hcd 0000:00:1a.0: debug port 2
[    7.717982] ehci_hcd 0000:00:1a.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    7.730805] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    7.737576] ehci_hcd 0000:00:1a.0: supports USB remote wakeup
[    7.743320] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xfe606000
[    7.748968] ehci_hcd 0000:00:1a.0: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    7.762718] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    7.768477] usb usb1: default language 0x0409
[    7.772827] usb usb1: udev 1, busnum 1, minor = 0
[    7.777520] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.784291] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.791496] usb usb1: Product: EHCI Host Controller
[    7.796361] usb usb1: Manufacturer: Linux 3.4.0-rc6upstream-00007-gf4f77c4 ehci_hcd
[    7.803999] usb usb1: SerialNumber: 0000:00:1a.0
[    7.808652] usb usb1: usb_probe_device
[    7.812392] usb usb1: configuration #1 chosen from 1 choice
[    7.817953] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    7.823717] hub 1-0:1.0: usb_probe_interface
[    7.827976] hub 1-0:1.0: usb_probe_interface - got id
[    7.833013] hub 1-0:1.0: USB hub found
[    7.836754] hub 1-0:1.0: 2 ports detected
[    7.840756] hub 1-0:1.0: standalone hub
[    7.844581] hub 1-0:1.0: no power switching (usb 1.0)
[    7.849620] hub 1-0:1.0: individual port over-current protection
[    7.855611] hub 1-0:1.0: power on to power good time: 20ms
[    7.861085] hub 1-0:1.0: local power source is good
[    7.865953] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    7.872822] /home/konrad/ssd/linux/drivers/usb/core/inode.c: creating file '001'
[    7.880231] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    7.886051] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    7.891265] /home/konrad/ssd/linux/drivers/usb/core/inode.c: creating file '002'
[    7.898676] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    7.906060] ehci_hcd 0000:00:1d.0: reset hcs_params 0x200002 dbg=2 cc=0 pcc=0 ordered !ppc ports=2
[    7.914999] ehci_hcd 0000:00:1d.0: reset hcc_params 36881 caching frame 1024 64 bit addr
[    7.923078] ehci_hcd 0000:00:1d.0: support lpm
[    7.927518] ehci_hcd 0000:00:1d.0: debug port 2
[    7.932040] ehci_hcd 0000:00:1d.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    7.944867] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    7.951638] ehci_hcd 0000:00:1d.0: supports USB remote wakeup
[    7.957379] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xfe605000
[    7.963024] ehci_hcd 0000:00:1d.0: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    7.972677] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    7.981447] hub 1-0:1.0: port 1: status 0501 change 0001
[    7.981478] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    7.981494] usb usb2: default language 0x0409
[    7.981498] usb usb2: udev 1, busnum 2, minor = 128
[    7.981499] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    7.981500] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.981501] usb usb2: Product: EHCI Host Controller
[    7.981502] usb usb2: Manufacturer: Linux 3.4.0-rc6upstream-00007-gf4f77c4 ehci_hcd
[    7.981504] usb usb2: SerialNumber: 0000:00:1d.0
[    7.981554] usb usb2: usb_probe_device
[    7.981555] usb usb2: configuration #1 chosen from 1 choice
[    7.981559] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    7.981587] hub 2-0:1.0: usb_probe_interface
[    7.981589] hub 2-0:1.0: usb_probe_interface - got id
[    7.981590] hub 2-0:1.0: USB hub found
[    7.981592] hub 2-0:1.0: 2 ports detected
[    7.981593] hub 2-0:1.0: standalone hub
[    7.981594] hub 2-0:1.0: no power switching (usb 1.0)
[    7.981595] hub 2-0:1.0: individual port over-current protection
[    7.981596] hub 2-0:1.0: power on to power good time: 20ms
[    7.981599] hub 2-0:1.0: local power source is good
[    7.981600] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    7.981613] /home/konrad/ssd/linux/drivers/usb/core/inode.c: creating file '001'
[    7.981658] initcall ehci_hcd_init+0x0/0xef returned 0 after 327959 usecs
[    7.981660] calling  ohci_hcd_mod_init+0x0/0xbf @ 1
[    7.981669] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.981670] ohci_hcd: block sizes: ed 80 td 96
[    7.981696] initcall ohci_hcd_mod_init+0x0/0xbf returned 0 after 25 usecs
[    7.981698] calling  uhci_hcd_init+0x0/0x124 @ 1
[    7.981699] uhci_hcd: USB Universal Host Controller Interface driver
[    8.144184] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    8.144202] initcall uhci_hcd_init+0x0/0x124 returned 0 after 158727 usecs
[    8.144205] calling  usblp_driver_init+0x0/0x1b @ 1
[    8.144237] usbcore: registered new interface driver usblp
[    8.144239] initcall usblp_driver_init+0x0/0x1b returned 0 after 31 usecs
[    8.144241] calling  usb_usual_init+0x0/0x3e @ 1
[    8.144272] usbcore: registered new interface driver libusual
[    8.144274] initcall usb_usual_init+0x0/0x3e returned 0 after 30 usecs
[    8.144276] calling  kgdbdbgp_start_thread+0x0/0x4f @ 1
[    8.144278] initcall kgdbdbgp_start_thread+0x0/0x4f returned 0 after 0 usecs
[    8.144280] calling  i8042_init+0x0/0x3ab @ 1
[    8.144353] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    8.144807] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.144810] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.144833] initcall i8042_init+0x0/0x3ab returned 0 after 537 usecs
[    8.144836] calling  serport_init+0x0/0x34 @ 1
[    8.144839] initcall serport_init+0x0/0x34 returned 0 after 0 usecs
[    8.144841] calling  mousedev_init+0x0/0x61 @ 1
[    8.144870] mousedev: PS/2 mouse device common for all mice
[    8.144873] initcall mousedev_init+0x0/0x61 returned 0 after 28 usecs
[    8.144876] calling  evdev_init+0x0/0x12 @ 1
[    8.144931] initcall evdev_init+0x0/0x12 returned 0 after 51 usecs
[    8.144933] calling  atkbd_init+0x0/0x27 @ 1
[    8.144957] initcall atkbd_init+0x0/0x27 returned 0 after 21 usecs
[    8.144959] calling  psmouse_init+0x0/0x7b @ 1
[    8.145006] initcall psmouse_init+0x0/0x7b returned 0 after 42 usecs
[    8.145008] calling  cmos_init+0x0/0x6a @ 1
[    8.145029] rtc_cmos 00:07: RTC can wake from S4
[    8.145217] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    8.145257] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    8.145284] initcall cmos_init+0x0/0x6a returned 0 after 266 usecs
[    8.145286] calling  i2c_i801_init+0x0/0xad @ 1
[    8.145373] initcall i2c_i801_init+0x0/0xad returned 0 after 83 usecs
[    8.145375] calling  cpufreq_gov_dbs_init+0x0/0x78 @ 1
[    8.145378] initcall cpufreq_gov_dbs_init+0x0/0x78 returned 0 after 0 usecs
[    8.145380] calling  init_ladder+0x0/0x12 @ 1
[    8.145416] cpuidle: using governor ladder
[    8.145418] initcall init_ladder+0x0/0x12 returned 0 after 35 usecs
[    8.145420] calling  init_menu+0x0/0x12 @ 1
[    8.243610] hub 1-0:1.0: state 7 ports 2 chg 0002 evt 0000
[    8.243616] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    8.294872] ehci_hcd 0000:00:1a.0: port 1 high speed
[    8.294875] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    8.345588] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    8.395254] hub 2-0:1.0: port 1: status 0501 change 0001
[    8.395290] cpuidle: using governor menu
[    8.395293] initcall init_menu+0x0/0x12 returned 0 after 244068 usecs
[    8.395295] calling  efivars_init+0x0/0xf7 @ 1
[    8.395295] EFI Variables Facility v0.08 2004-May-17
[    8.395297] initcall efivars_init+0x0/0xf7 returned 0 after 1 usecs
[    8.395300] calling  vhost_net_init+0x0/0x30 @ 1
[    8.395335] initcall vhost_net_init+0x0/0x30 returned 0 after 32 usecs
[    8.395337] calling  staging_init+0x0/0x8 @ 1
[    8.395338] initcall staging_init+0x0/0x8 returned 0 after 0 usecs
[    8.395340] calling  zram_init+0x0/0x2e4 @ 1
[    8.395341] zram: num_devices not specified. Using default: 1
[    8.395342] zram: Creating 1 devices ...
[    8.395429] initcall zram_init+0x0/0x2e4 returned 0 after 85 usecs
[    8.395431] calling  zcache_init+0x0/0x279 @ 1
[    8.396847] ehci_hcd 0000:00:1a.0: port 1 high speed
[    8.396850] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    8.460714] ehci_hcd 0000:00:1a.0: set dev address 2 for port 1
[    8.460719] ehci_hcd 0000:00:1a.0: LPM: no device attached
[    8.460964] usb 1-1: udev 2, busnum 1, minor = 1
[    8.460966] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    8.460968] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    8.461014] usb 1-1: usb_probe_device
[    8.461016] usb 1-1: configuration #1 chosen from 1 choice
[    8.461095] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    8.461126] hub 1-1:1.0: usb_probe_interface
[    8.461128] hub 1-1:1.0: usb_probe_interface - got id
[    8.461129] hub 1-1:1.0: USB hub found
[    8.461214] hub 1-1:1.0: 4 ports detected
[    8.461215] hub 1-1:1.0: standalone hub
[    8.461216] hub 1-1:1.0: individual port power switching
[    8.461218] hub 1-1:1.0: individual port over-current protection
[    8.461219] hub 1-1:1.0: Single TT
[    8.461221] hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    8.461222] hub 1-1:1.0: power on to power good time: 100ms
[    8.461461] hub 1-1:1.0: local power source is good
[    8.461463] hub 1-1:1.0: enabling power on all ports
[    8.461970] /home/konrad/ssd/linux/drivers/usb/core/inode.c: creating file '002'
[    8.561943] usb 1-1: link qh256-0001/ffff880227378dc0 start 1 [1/0 us]
[    8.561951] hub 1-1:1.0: state 7 ports 4 chg 0000 evt 0000
[    8.607564] initcall zcache_init+0x0/0x279 returned 0 after 207203 usecs
[    8.614254] calling  eeepc_laptop_init+0x0/0x58 @ 1
[    8.619313] initcall eeepc_laptop_init+0x0/0x58 returned -19 after 180 usecs
[    8.626352] calling  sock_diag_init+0x0/0x36 @ 1
[    8.630963] initcall sock_diag_init+0x0/0x36 returned 0 after 4 usecs
[    8.637388] calling  flow_cache_init_global+0x0/0x19d @ 1
[    8.642818] initcall flow_cache_init_global+0x0/0x19d returned 0 after 42 usecs
[    8.650113] calling  llc_init+0x0/0x20 @ 1
[    8.654197] initcall llc_init+0x0/0x20 returned 0 after 0 usecs
[    8.660102] calling  snap_init+0x0/0x38 @ 1
[    8.664275] initcall snap_init+0x0/0x38 returned 0 after 1 usecs
[    8.670267] calling  blackhole_module_init+0x0/0x12 @ 1
[    8.675478] initcall blackhole_module_init+0x0/0x12 returned 0 after 0 usecs
[    8.682511] calling  nfnetlink_init+0x0/0x27 @ 1
[    8.687119] Netfilter messages via NETLINK v0.30.
[    8.691813] initcall nfnetlink_init+0x0/0x27 returned 0 after 4583 usecs
[    8.698500] calling  nfnetlink_log_init+0x0/0xd6 @ 1
[    8.703457] initcall nfnetlink_log_init+0x0/0xd6 returned 0 after 4 usecs
[    8.707525] hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0000
[    8.707531] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    8.721947] calling  nf_conntrack_standalone_init+0x0/0x12 @ 1
[    8.727765] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    8.733958] initcall nf_conntrack_standalone_init+0x0/0x12 returned 0 after 6047 usecs
[    8.741858] calling  ctnetlink_init+0x0/0xa2 @ 1
[    8.746463] ctnetlink v0.93: registering with nfnetlink.
[    8.751762] initcall ctnetlink_init+0x0/0xa2 returned 0 after 5174 usecs
[    8.758446] calling  nf_conntrack_ftp_init+0x0/0x19e @ 1
[    8.758765] ehci_hcd 0000:00:1d.0: port 1 high speed
[    8.758768] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    8.777550] initcall nf_conntrack_ftp_init+0x0/0x19e returned 0 after 1 usecs
[    8.784672] calling  nf_conntrack_irc_init+0x0/0x165 @ 1
[    8.789976] initcall nf_conntrack_irc_init+0x0/0x165 returned 0 after 1 usecs
[    8.797096] calling  nf_conntrack_sip_init+0x0/0x1f9 @ 1
[    8.802394] initcall nf_conntrack_sip_init+0x0/0x1f9 returned 0 after 0 usecs
[    8.809511] calling  xt_init+0x0/0x113 @ 1
[    8.810487] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    8.820108] initcall xt_init+0x0/0x113 returned 0 after 1 usecs
[    8.826015] calling  tcpudp_mt_init+0x0/0x17 @ 1
[    8.830624] initcall tcpudp_mt_init+0x0/0x17 returned 0 after 0 usecs
[    8.837048] calling  connsecmark_tg_init+0x0/0x12 @ 1
[    8.842088] initcall connsecmark_tg_init+0x0/0x12 returned 0 after 0 usecs
[    8.848945] calling  nflog_tg_init+0x0/0x12 @ 1
[    8.853464] initcall nflog_tg_init+0x0/0x12 returned 0 after 0 usecs
[    8.859803] calling  secmark_tg_init+0x0/0x12 @ 1
[    8.862741] ehci_hcd 0000:00:1d.0: port 1 high speed
[    8.862744] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    8.878295] initcall secmark_tg_init+0x0/0x12 returned 0 after 0 usecs
[    8.884809] calling  tcpmss_tg_init+0x0/0x17 @ 1
[    8.889413] initcall tcpmss_tg_init+0x0/0x17 returned 0 after 0 usecs
[    8.895839] calling  conntrack_mt_init+0x0/0x17 @ 1
[    8.900703] initcall conntrack_mt_init+0x0/0x17 returned 0 after 0 usecs
[    8.907389] calling  policy_mt_init+0x0/0x17 @ 1
[    8.911994] initcall policy_mt_init+0x0/0x17 returned 0 after 0 usecs
[    8.918419] calling  state_mt_init+0x0/0x12 @ 1
[    8.922938] initcall state_mt_init+0x0/0x12 returned 0 after 0 usecs
[    8.927609] ehci_hcd 0000:00:1d.0: set dev address 2 for port 1
[    8.927613] ehci_hcd 0000:00:1d.0: LPM: no device attached
[    8.927860] usb 2-1: udev 2, busnum 2, minor = 129
[    8.927862] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    8.927863] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    8.927968] usb 2-1: usb_probe_device
[    8.927970] usb 2-1: configuration #1 chosen from 1 choice
[    8.928115] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    8.928199] hub 2-1:1.0: usb_probe_interface
[    8.928201] hub 2-1:1.0: usb_probe_interface - got id
[    8.928202] hub 2-1:1.0: USB hub found
[    8.928233] hub 2-1:1.0: 6 ports detected
[    8.928234] hub 2-1:1.0: standalone hub
[    8.928235] hub 2-1:1.0: individual port power switching
[    8.928236] hub 2-1:1.0: individual port over-current protection
[    8.928237] hub 2-1:1.0: Single TT
[    8.928238] hub 2-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    8.928240] hub 2-1:1.0: power on to power good time: 100ms
[    8.928484] hub 2-1:1.0: local power source is good
[    8.928485] hub 2-1:1.0: enabling power on all ports
[    8.929240] /home/konrad/ssd/linux/drivers/usb/core/inode.c: creating file '002'
[    9.030212] usb 2-1: link qh256-0001/ffff880227378cc0 start 1 [1/0 us]
[    9.030263] hub 2-1:1.0: state 7 ports 6 chg 0000 evt 0000
[    9.050584] calling  sysctl_ipv4_init+0x0/0x8b @ 1
[    9.055402] initcall sysctl_ipv4_init+0x0/0x8b returned 0 after 36 usecs
[    9.062088] calling  init_syncookies+0x0/0x19 @ 1
[    9.066792] initcall init_syncookies+0x0/0x19 returned 0 after 10 usecs
[    9.073391] calling  tunnel4_init+0x0/0x72 @ 1
[    9.077823] initcall tunnel4_init+0x0/0x72 returned 0 after 0 usecs
[    9.084075] calling  ipv4_netfilter_init+0x0/0x20 @ 1
[    9.089119] initcall ipv4_netfilter_init+0x0/0x20 returned 0 after 0 usecs
[    9.095980] calling  nf_conntrack_l3proto_ipv4_init+0x0/0x14b @ 1
[    9.102169] initcall nf_conntrack_l3proto_ipv4_init+0x0/0x14b returned 0 after 106 usecs
[    9.110243] calling  nf_nat_init+0x0/0x124 @ 1
[    9.114685] initcall nf_nat_init+0x0/0x124 returned 0 after 10 usecs
[    9.121026] calling  nf_defrag_init+0x0/0x17 @ 1
[    9.125636] initcall nf_defrag_init+0x0/0x17 returned 0 after 0 usecs
[    9.132065] calling  nf_nat_ftp_init+0x0/0x21 @ 1
[    9.136755] initcall nf_nat_ftp_init+0x0/0x21 returned 0 after 0 usecs
[    9.143268] calling  nf_nat_irc_init+0x0/0x21 @ 1
[    9.147959] initcall nf_nat_irc_init+0x0/0x21 returned 0 after 0 usecs
[    9.154471] calling  nf_nat_sip_init+0x0/0xc3 @ 1
[    9.159163] initcall nf_nat_sip_init+0x0/0xc3 returned 0 after 0 usecs
[    9.165674] calling  ip_tables_init+0x0/0xaa @ 1
[    9.170282] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.175582] initcall ip_tables_init+0x0/0xaa returned 0 after 5179 usecs
[    9.182267] calling  iptable_filter_init+0x0/0x51 @ 1
[    9.187367] initcall iptable_filter_init+0x0/0x51 returned 0 after 59 usecs
[    9.194312] calling  iptable_mangle_init+0x0/0x51 @ 1
[    9.199355] initcall iptable_mangle_init+0x0/0x51 returned 0 after 5 usecs
[    9.206218] calling  nf_nat_standalone_init+0x0/0x82 @ 1
[    9.211525] initcall nf_nat_standalone_init+0x0/0x82 returned 0 after 5 usecs
[    9.218648] calling  masquerade_tg_init+0x0/0x39 @ 1
[    9.223605] initcall masquerade_tg_init+0x0/0x39 returned 0 after 1 usecs
[    9.230378] calling  reject_tg_init+0x0/0x12 @ 1
[    9.234983] initcall reject_tg_init+0x0/0x12 returned 0 after 0 usecs
[    9.241410] calling  ulog_tg_init+0x0/0xed @ 1
[    9.245847] initcall ulog_tg_init+0x0/0xed returned 0 after 2 usecs
[    9.252101] calling  cubictcp_register+0x0/0x5c @ 1
[    9.256964] TCP: cubic registered
[    9.260273] initcall cubictcp_register+0x0/0x5c returned 0 after 3231 usecs
[    9.267220] calling  xfrm_user_init+0x0/0x4a @ 1
[    9.271826] Initializing XFRM netlink socket
[    9.276086] initcall xfrm_user_init+0x0/0x4a returned 0 after 4159 usecs
[    9.282774] calling  inet6_init+0x0/0x32d @ 1
[    9.287182] NET: Registered protocol family 10
[    9.291771] initcall inet6_init+0x0/0x32d returned 0 after 4543 usecs
[    9.298199] calling  ah6_init+0x0/0x6b @ 1
[    9.302287] initcall ah6_init+0x0/0x6b returned 0 after 0 usecs
[    9.308197] calling  esp6_init+0x0/0x6b @ 1
[    9.312374] initcall esp6_init+0x0/0x6b returned 0 after 0 usecs
[    9.318371] calling  xfrm6_transport_init+0x0/0x17 @ 1
[    9.323498] initcall xfrm6_transport_init+0x0/0x17 returned 0 after 0 usecs
[    9.330442] calling  xfrm6_mode_tunnel_init+0x0/0x17 @ 1
[    9.335742] initcall xfrm6_mode_tunnel_init+0x0/0x17 returned 0 after 0 usecs
[    9.342865] calling  xfrm6_beet_init+0x0/0x17 @ 1
[    9.347560] initcall xfrm6_beet_init+0x0/0x17 returned 0 after 0 usecs
[    9.354072] calling  ip6_tables_init+0x0/0xaa @ 1
[    9.358771] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    9.364157] initcall ip6_tables_init+0x0/0xaa returned 0 after 5262 usecs
[    9.370929] calling  ip6table_filter_init+0x0/0x51 @ 1
[    9.376158] initcall ip6table_filter_init+0x0/0x51 returned 0 after 101 usecs
[    9.383283] calling  ip6table_mangle_init+0x0/0x51 @ 1
[    9.388493] initcall ip6table_mangle_init+0x0/0x51 returned 0 after 78 usecs
[    9.395528] calling  nf_conntrack_l3proto_ipv6_init+0x0/0xfc @ 1
[    9.401524] initcall nf_conntrack_l3proto_ipv6_init+0x0/0xfc returned 0 after 4 usecs
[    9.409334] calling  nf_defrag_init+0x0/0x54 @ 1
[    9.413943] initcall nf_defrag_init+0x0/0x54 returned 0 after 2 usecs
[    9.420368] calling  ipv6header_mt6_init+0x0/0x12 @ 1
[    9.425408] initcall ipv6header_mt6_init+0x0/0x12 returned 0 after 0 usecs
[    9.432266] calling  reject_tg6_init+0x0/0x12 @ 1
[    9.436958] initcall reject_tg6_init+0x0/0x12 returned 0 after 0 usecs
[    9.443468] calling  sit_init+0x0/0x60 @ 1
[    9.447553] IPv6 over IPv4 tunneling driver
[    9.452166] initcall sit_init+0x0/0x60 returned 0 after 4502 usecs
[    9.458335] calling  packet_init+0x0/0x47 @ 1
[    9.462682] NET: Registered protocol family 17
[    9.467118] initcall packet_init+0x0/0x47 returned 0 after 4331 usecs
[    9.473544] calling  br_init+0x0/0xa2 @ 1
[    9.477589] initcall br_init+0x0/0xa2 returned 0 after 44 usecs
[    9.483496] calling  init_rpcsec_gss+0x0/0x64 @ 1
[    9.488195] initcall init_rpcsec_gss+0x0/0x64 returned 0 after 7 usecs
[    9.494708] calling  dcbnl_init+0x0/0x4d @ 1
[    9.498968] initcall dcbnl_init+0x0/0x4d returned 0 after 0 usecs
[    9.505048] calling  init_dns_resolver+0x0/0x113 @ 1
[    9.510000] Registering the dns_resolver key type
[    9.514696] initcall init_dns_resolver+0x0/0x113 returned 0 after 4586 usecs
[    9.521753] calling  tboot_late_init+0x0/0x216 @ 1
[    9.526533] initcall tboot_late_init+0x0/0x216 returned 0 after 0 usecs
[    9.533130] calling  mcheck_debugfs_init+0x0/0x3c @ 1
[    9.538173] initcall mcheck_debugfs_init+0x0/0x3c returned 0 after 4 usecs
[    9.545033] calling  severities_debugfs_init+0x0/0x3c @ 1
[    9.550418] initcall severities_debugfs_init+0x0/0x3c returned 0 after 1 usecs
[    9.557623] calling  hpet_insert_resource+0x0/0x23 @ 1
[    9.562752] initcall hpet_insert_resource+0x0/0x23 returned 0 after 1 usecs
[    9.569697] calling  update_mp_table+0x0/0x56d @ 1
[    9.574475] initcall update_mp_table+0x0/0x56d returned 0 after 0 usecs
[    9.581074] calling  lapic_insert_resource+0x0/0x3f @ 1
[    9.586289] initcall lapic_insert_resource+0x0/0x3f returned 0 after 0 usecs
[    9.593320] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[    9.598445] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
[    9.605390] calling  print_ICs+0x0/0x516 @ 1
[    9.609650] initcall print_ICs+0x0/0x516 returned 0 after 0 usecs
[    9.615733] calling  check_early_ioremap_leak+0x0/0x65 @ 1
[    9.621205] initcall check_early_ioremap_leak+0x0/0x65 returned 0 after 0 usecs
[    9.628500] calling  pat_memtype_list_init+0x0/0x32 @ 1
[    9.633712] initcall pat_memtype_list_init+0x0/0x32 returned 0 after 1 usecs
[    9.640749] calling  init_oops_id+0x0/0x40 @ 1
[    9.645185] initcall init_oops_id+0x0/0x40 returned 0 after 1 usecs
[    9.651439] calling  printk_late_init+0x0/0x59 @ 1
[    9.656219] initcall printk_late_init+0x0/0x59 returned 0 after 0 usecs
[    9.662821] calling  pm_qos_power_init+0x0/0x7b @ 1
[    9.668098] initcall pm_qos_power_init+0x0/0x7b returned 0 after 401 usecs
[    9.674962] calling  pm_debugfs_init+0x0/0x24 @ 1
[    9.679659] initcall pm_debugfs_init+0x0/0x24 returned 0 after 2 usecs
[    9.686173] calling  software_resume+0x0/0x250 @ 1
[    9.690955] PM: Hibernation image not present or could not be loaded.
[    9.697381] initcall software_resume+0x0/0x250 returned -2 after 6275 usecs
[    9.704329] initcall software_resume+0x0/0x250 returned with error code -2 
[    9.711274] calling  debugfs_kprobe_init+0x0/0x90 @ 1
[    9.716321] initcall debugfs_kprobe_init+0x0/0x90 returned 0 after 4 usecs
[    9.723184] calling  taskstats_init+0x0/0x95 @ 1
[    9.727794] registered taskstats version 1
[    9.731882] initcall taskstats_init+0x0/0x95 returned 0 after 3995 usecs
[    9.738568] calling  max_swapfiles_check+0x0/0x8 @ 1
[    9.743524] initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
[    9.750300] calling  fail_make_request_debugfs+0x0/0x2a @ 1
[    9.755869] initcall fail_make_request_debugfs+0x0/0x2a returned 0 after 6 usecs
[    9.763251] calling  random32_reseed+0x0/0xb4 @ 1
[    9.767952] initcall random32_reseed+0x0/0xb4 returned 0 after 7 usecs
[    9.774466] calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
[    9.780724] initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 1 usecs
[    9.788796] calling  pci_sysfs_init+0x0/0x51 @ 1
[    9.793599] initcall pci_sysfs_init+0x0/0x51 returned 0 after 192 usecs
[    9.800201] calling  boot_wait_for_devices+0x0/0x30 @ 1
[    9.805416] initcall boot_wait_for_devices+0x0/0x30 returned 0 after 0 usecs
[    9.812451] calling  random_int_secret_init+0x0/0x19 @ 1
[    9.817755] initcall random_int_secret_init+0x0/0x19 returned 0 after 5 usecs
[    9.824877] calling  deferred_probe_initcall+0x0/0x60 @ 1
[    9.830347] initcall deferred_probe_initcall+0x0/0x60 returned 0 after 80 usecs
[    9.837646] calling  late_resume_init+0x0/0x1d0 @ 1
[    9.842511]   Magic number: 12:268:531
[    9.846336] initcall late_resume_init+0x0/0x1d0 returned 0 after 3734 usecs
[    9.853284] calling  memmap_init+0x0/0x38 @ 1
[    9.857669] initcall memmap_init+0x0/0x38 returned 0 after 34 usecs
[    9.863923] calling  pci_mmcfg_late_insert_resources+0x0/0x60 @ 1
[    9.870003] initcall pci_mmcfg_late_insert_resources+0x0/0x60 returned 0 after 0 usecs
[    9.877904] calling  net_secret_init+0x0/0x19 @ 1
[    9.882602] initcall net_secret_init+0x0/0x19 returned 0 after 6 usecs
[    9.889118] calling  tcp_congestion_default+0x0/0x12 @ 1
[    9.894419] initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 usecs
[    9.901536] calling  ip_auto_config+0x0/0xe2a @ 1
[    9.906230] initcall ip_auto_config+0x0/0xe2a returned 0 after 2 usecs
[    9.912744] calling  initialize_hashrnd+0x0/0x19 @ 1
[    9.917697] initcall initialize_hashrnd+0x0/0x19 returned 0 after 1 usecs
[    9.924588] async_waiting @ 1
[    9.927551] async_continuing @ 1 after 0 usec
[    9.932712] Freeing unused kernel memory: 692k freed
[    9.937731] Write protecting the kernel read-only data: 8192k
[    9.944238] Freeing unused kernel memory: 292k freed
[    9.950078] Freeing unused kernel memory: 400k freed
[   10.040232] core_filesystem used greatest stack depth: 5016 bytes left
[   10.052001] udevd (1231): /proc/1231/oom_adj is deprecated, please use /proc/1231/oom_score_adj instead.
[   10.072318] calling  acpi_video_init+0x0/0xfee [video] @ 1454
[   10.078428] initcall acpi_video_init+0x0/0xfee [video] returned 0 after 6 usecs
[   10.078493] calling  crc32c_intel_mod_init+0x0/0x1000 [crc32c_intel] @ 1479
[   10.078503] calling  e1000_init_module+0x0/0x1000 [e1000e] @ 1459
[   10.078505] e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
[   10.078506] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[   10.078525] e1000e 0000:01:00.0: Disabling ASPM L0s 
[   10.078653] e1000e 0000:01:00.0: (unregistered net_device): Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   10.078726] e1000e 0000:01:00.0: irq 41 for MSI/MSI-X
[   10.078732] e1000e 0000:01:00.0: irq 42 for MSI/MSI-X
[   10.078737] e1000e 0000:01:00.0: irq 43 for MSI/MSI-X
[   10.079403] initcall crc32c_intel_mod_init+0x0/0x1000 [crc32c_intel] returned 0 after 882 usecs
[   10.151895] calling  init_scsi+0x0/0x91 [scsi_mod] @ 1467
[   10.157288] calling  drm_fb_helper_modinit+0x0/0x1000 [drm_kms_helper] @ 1454
[   10.164463] calling  atl1c_init_module+0x0/0x1000 [atl1c] @ 1464
[   10.164647] initcall drm_fb_helper_modinit+0x0/0x1000 [drm_kms_helper] returned 0 after 226 usecs
[   10.181411] SCSI subsystem initialized
[   10.185808] initcall init_scsi+0x0/0x91 [scsi_mod] returned 0 after 27849 usecs
[   10.194564] calling  i915_init+0x0/0x8d [i915] @ 1454
[   10.200977] calling  fb_console_init+0x0/0x1000 [fbcon] @ 1491
[   10.201898] i915 0000:00:02.0: setting latency timer to 64
[   10.213657] calling  ata_init+0x0/0x4ce [libata] @ 1467
[   10.216254] libata version 3.00 loaded.
[   10.216266] initcall ata_init+0x0/0x4ce [libata] returned 0 after 2537 usecs
[   10.232495] calling  piix_init+0x0/0x1000 [ata_piix] @ 1467
[   10.232518] initcall fb_console_init+0x0/0x1000 [fbcon] returned 0 after 18427 usecs
[   10.249557] e1000e 0000:01:00.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1b:21:ab:c6:13
[   10.252903] ip used greatest stack depth: 3784 bytes left
[   10.262938] e1000e 0000:01:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   10.268327] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[   10.268329] [drm] MTRR allocation failed.  Graphics performance may suffer.
[   10.269920] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[   10.269930] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   10.269931] [drm] Driver supports precise vblank timestamp query.
[   10.269968] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   10.299063] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   10.303657] atl1c 0000:03:00.0: version 1.0.1.0-NAPI
[   10.303712] initcall atl1c_init_module+0x0/0x1000 [atl1c] returned 0 after 120150 usecs
[   10.331299] e1000e 0000:01:00.0: eth0: MAC: 3, PHY: 8, PBA No: E46981-005
[   10.339682] initcall e1000_init_module+0x0/0x1000 [e1000e] returned 0 after 255101 usecs
[   10.392172] No connectors reported connected with modes
[   10.397391] [drm] Cannot find any crtc or sizes - going 1024x768
[   10.406570] fbcon: inteldrmfb (fb0) is primary device
[   10.413443] Console: switching to colour frame buffer device 128x48
[   10.421078] fb0: inteldrmfb frame buffer device
[   10.425602] drm: registered panic notifier
[   10.429744] No ACPI video bus found
[   10.433791] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   10.442300] ata_piix 0000:00:1f.2: version 2.13
[   10.442388] initcall i915_init+0x0/0x8d [i915] returned 0 after 235779 usecs
[   10.454042] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   10.611176] ata_piix 0000:00:1f.2: setting latency timer to 64
[   10.617824] scsi0 : ata_piix
[   10.620993] scsi1 : ata_piix
[   10.624961] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf0d0 irq 14
[   10.631910] ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf0d8 irq 15
[   10.638872] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[   10.794122] ata_piix 0000:00:1f.5: setting latency timer to 64
[   10.800691] scsi2 : ata_piix
[   10.803758] scsi3 : ata_piix
[   10.807562] ata3: SATA max UDMA/133 cmd 0xf0b0 ctl 0xf0a0 bmdma 0xf070 irq 19
[   10.814688] ata4: SATA max UDMA/133 cmd 0xf090 ctl 0xf080 bmdma 0xf078 irq 19
[   10.822016] initcall piix_init+0x0/0x1000 [ata_piix] returned 0 after 562460 usecs
[   10.882416] calling  ata_generic_init+0x0/0x1000 [ata_generic] @ 1468
[   10.888942] initcall ata_generic_init+0x0/0x1000 [ata_generic] returned 0 after 90 usecs
[   11.277024] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   11.302147] ata3.00: ATAPI: HL-DT-ST DVDRAM GH24NS50, XP01, max UDMA/100
[   11.315194] ata3.00: configured for UDMA/100
[   11.644952] ata2.00: failed to resume link (SControl 0)
[   11.834874] ata4: failed to resume link (SControl 0)
[   11.850570] ata4: SATA link down (SStatus 4 SControl 0)
[   11.949841] ata1.01: failed to resume link (SControl 0)
[   12.105878] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   12.112316] ata1.01: SATA link down (SStatus 0 SControl 0)
[   12.169842] ata1.00: ATA-7: ST3808110AS, 3.ADH, max UDMA/133
[   12.175496] ata1.00: 156250000 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   12.236462] ata1.00: configured for UDMA/133
[   12.240869] scsi 0:0:0:0: Direct-Access     ATA      ST3808110AS      3.AD PQ: 0 ANSI: 5
[   12.656695] ata2.01: failed to resume link (SControl 0)
[   12.672658] ata2.00: SATA link down (SStatus 4 SControl 0)
[   12.678140] ata2.01: SATA link down (SStatus 0 SControl 0)
[   12.687305] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVDRAM GH24NS50  XP01 PQ: 0 ANSI: 5
[   12.697340] calling  cdrom_init+0x0/0x1000 [cdrom] @ 2385
[   12.702748] initcall cdrom_init+0x0/0x1000 [cdrom] returned 0 after 7 usecs
[   12.702753] calling  init_sd+0x0/0x1000 [sd_mod] @ 2384
[   12.702917] sd 0:0:0:0: [sda] 156250000 512-byte logical blocks: (80.0 GB/74.5 GiB)
[   12.702957] sd 0:0:0:0: [sda] Write Protect is off
[   12.702959] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   12.702974] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   12.741379] initcall init_sd+0x0/0x1000 [sd_mod] returned 0 after 37725 usecs
[   12.749404]  sda: sda1 sda2 sda3 sda4
[   12.753334] sd 0:0:0:0: [sda] Attached SCSI disk
[   12.758382] calling  init_sr+0x0/0x1000 [sr_mod] @ 2385
[   12.763633] calling  init_sg+0x0/0x1000 [sg] @ 2397
[   12.768618] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   12.772478] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   12.772480] cdrom: Uniform CD-ROM driver Revision: 3.20
[   12.772608] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   12.772704] initcall init_sr+0x0/0x1000 [sr_mod] returned 0 after 8889 usecs
[   12.798283] sr 2:0:0:0: Attached scsi generic sg1 type 5
[   12.803599] initcall init_sg+0x0/0x1000 [sg] returned 0 after 34274 usecs
[   13.074266] calling  ttm_init+0x0/0x1000 [ttm] @ 2468
[   13.080379] initcall ttm_init+0x0/0x1000 [ttm] returned 0 after 52 usecs
[   13.093998] calling  radeon_init+0x0/0x1000 [radeon] @ 2468
[   13.099565] [drm] radeon kernel modesetting enabled.
[   13.104657] initcall radeon_init+0x0/0x1000 [radeon] returned 0 after 4963 usecs
[   13.113314] calling  acpi_wmi_init+0x0/0x1000 [wmi] @ 2474
[   13.118867] wmi: Mapper loaded
[   13.121925] initcall acpi_wmi_init+0x0/0x1000 [wmi] returned 0 after 3060 usecs
[   13.129423] calling  mxm_wmi_init+0x0/0x1000 [mxm_wmi] @ 2474
[   13.135164] initcall mxm_wmi_init+0x0/0x1000 [mxm_wmi] returned 0 after 0 usecs
[   13.149710] calling  nouveau_init+0x0/0x1000 [nouveau] @ 2474
[   13.155512] initcall nouveau_init+0x0/0x1000 [nouveau] returned 0 after 48 usecs
[   13.368448] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.374412] device eth0 entered promiscuous mode
[   13.398779] atl1c 0000:03:00.0: irq 45 for MSI/MSI-X
[   13.477269] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   16.171452] atl1c 0000:03:00.0: atl1c: eth1 NIC Link is Up<1000 Mbps Full Duplex>
[   16.179321] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   16.609756] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   16.617882] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   17.324193] switch: port 1(eth0) entered forwarding state
[   17.330796] switch: port 1(eth0) entered forwarding state
[   23.626935] calling  dump_dma_init+0x0/0x1000 [dump_dma] @ 2969
[   23.634092] initcall dump_dma_init+0x0/0x1000 [dump_dma] returned 0 after 0 usecs
[   23.649562] calling  crc32c_mod_init+0x0/0x1000 [crc32c] @ 2986
[   23.655554] initcall crc32c_mod_init+0x0/0x1000 [crc32c] returned 0 after 70 usecs
[   23.663939] calling  libcrc32c_mod_init+0x0/0x1000 [libcrc32c] @ 2989
[   23.670986] initcall libcrc32c_mod_init+0x0/0x1000 [libcrc32c] returned 0 after 1 usecs
[   23.680175] calling  iscsi_transport_init+0x0/0x1000 [scsi_transport_iscsi] @ 2991
[   23.687963] Loading iSCSI transport class v2.0-870.
[   23.693117] initcall iscsi_transport_init+0x0/0x1000 [scsi_transport_iscsi] returned 0 after 5030 usecs
[   23.703444] calling  iscsi_sw_tcp_init+0x0/0x1000 [iscsi_tcp] @ 2991
[   23.709848] iscsi: registered transport (tcp)
[   23.714199] initcall iscsi_sw_tcp_init+0x0/0x1000 [iscsi_tcp] returned 0 after 4300 usecs
[   24.144130] mount.nfs used greatest stack depth: 3760 bytes left
[   24.278714] calling  dm_init+0x0/0x48 [dm_mod] @ 3048
[   24.285359] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[   24.294996] initcall dm_init+0x0/0x48 [dm_mod] returned 0 after 9614 usecs
[   24.302290] calling  dm_multipath_init+0x0/0x1000 [dm_multipath] @ 3048
[   24.309976] device-mapper: multipath: version 1.3.0 loaded
[   24.316782] initcall dm_multipath_init+0x0/0x1000 [dm_multipath] returned 0 after 6739 usecs
[   24.580882] scsi4 : iSCSI Initiator over TCP/IP
[   24.837814] BUG: unable to handle kernel NULL pointer dereference at 0000000000000118
[   24.845654] IP: [<ffffffffa0056da1>] __scsi_alloc_queue+0xa1/0x190 [scsi_mod]
[   24.852789] PGD 226cfb067 PUD 229300067 PMD 0 
[   24.857253] Oops: 0000 [#1] SMP 
[   24.860493] CPU 3 
[   24.862325] Modules linked in: dm_multipath dm_mod iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi libcrc32c crc32c nouveau mxm_wmi wmi radeon ttm sg sr_mod sd_mod cdrom ata_generic ata_piix libata fbcon i915 tileblit font bitblit softcursor atl1c drm_kms_helper scsi_mod crc32c_intel e1000e video acpi_cpufreq mperf [last unloaded: dump_dma]
[   24.894914] 
[   24.896399] Pid: 3065, comm: iscsid Tainted: G           O 3.4.0-rc6upstream-00007-gf4f77c4 #1 MSI MS-7680/H61M-P23 (MS-7680)
[   24.907707] RIP: 0010:[<ffffffffa0056da1>]  [<ffffffffa0056da1>] __scsi_alloc_queue+0xa1/0x190 [scsi_mod]
[   24.917264] RSP: 0018:ffff88022e92fa78  EFLAGS: 00010296
[   24.922561] RAX: 000000000023fe00 RBX: ffff88022748f800 RCX: 0000000000000010
[   24.929681] RDX: 0000000000000067 RSI: 00000000ffffffff RDI: ffff8802292ca078
[   24.936797] RBP: ffff88022e92fa98 R08: 0000000000000000 R09: 0000000000000008
[   24.943917] R10: ffff8802292b5000 R11: 0000000000000001 R12: 0000000000000000
[   24.951034] R13: ffff8802292ca078 R14: ffff880229094828 R15: 0000000000000000
[   24.958152] FS:  00007ffb5eea6700(0000) GS:ffff88023fb80000(0000) knlGS:0000000000000000
[   24.966223] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   24.971955] CR2: 0000000000000118 CR3: 000000022924e000 CR4: 00000000000407e0
[   24.979073] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   24.986190] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   24.993310] Process iscsid (pid: 3065, threadinfo ffff88022e92e000, task ffff88022736d820)
[   25.001553] Stack:
[   25.003560]  ffff88022e92fb78 ffff88022f182000 ffff880229094800 ffff88022748f800
[   25.010987]  ffff88022e92fab8 ffffffffa0056ea8 ffff88022e92fab8 ffff88022f182000
[   25.010990]  ffff88022e92fb08 ffffffffa0058faf 0000000000000282 0000000000000000
[   25.010993] Call Trace:
[   25.010999]  [<ffffffffa0056ea8>] scsi_alloc_queue+0x18/0x70 [scsi_mod]
[   25.011003]  [<ffffffffa0058faf>] scsi_alloc_sdev+0x19f/0x280 [scsi_mod]
[   25.011007]  [<ffffffffa0059508>] scsi_probe_and_add_lun+0x478/0xd50 [scsi_mod]
[   25.011010]  [<ffffffffa032f065>] ? iscsi_host_match+0x15/0x60 [scsi_transport_iscsi]
[   25.011015]  [<ffffffff8138017c>] ? attribute_container_add_device+0x10c/0x170
[   25.011019]  [<ffffffffa005a24e>] ? scsi_alloc_target+0x29e/0x2d0 [scsi_mod]
[   25.011022]  [<ffffffff815a62c9>] ? _raw_spin_lock+0x19/0x20
[   25.011026]  [<ffffffffa005a42e>] __scsi_scan_target+0xfe/0x710 [scsi_mod]
[   25.011030]  [<ffffffffa005b135>] scsi_scan_target+0xd5/0xf0 [scsi_mod]
[   25.011033]  [<ffffffffa032f1f9>] iscsi_user_scan_session+0x149/0x180 [scsi_transport_iscsi]
[   25.011036]  [<ffffffffa032f0b0>] ? iscsi_host_match+0x60/0x60 [scsi_transport_iscsi]
[   25.011040]  [<ffffffff81378c74>] device_for_each_child+0x44/0x70
[   25.011043]  [<ffffffffa032c6d8>] iscsi_user_scan+0x28/0x30 [scsi_transport_iscsi]
[   25.011047]  [<ffffffffa005bd23>] store_scan+0xc3/0xf0 [scsi_mod]
[   25.011050]  [<ffffffff81138b91>] ? alloc_pages_current+0xb1/0x110
[   25.011053]  [<ffffffff813783ab>] dev_attr_store+0x1b/0x20
[   25.011055]  [<ffffffff811b18f4>] sysfs_write_file+0xf4/0x170
[   25.011058]  [<ffffffff811449e8>] vfs_write+0xc8/0x190
[   25.011060]  [<ffffffff81144b9c>] sys_write+0x4c/0x90
[   25.011063]  [<ffffffff815acfb9>] system_call_fastpath+0x16/0x1b
[   25.011064] Code: ef e8 94 7d 21 e1 f6 83 28 01 00 00 04 be ff ff ff 00 74 7e 4c 89 ef e8 2e 82 21 e1 48 8b b3 18 01 00 00 4c 89 ef e8 bf 7b 21 e1 <49> 8b 84 24 18 01 00 00 48 8b 93 18 01 00 00 48 85 c0 0f 84 bf 
[   25.011082] RIP  [<ffffffffa0056da1>] __scsi_alloc_queue+0xa1/0x190 [scsi_mod]
[   25.011086]  RSP <ffff88022e92fa78>
[   25.011087] CR2: 0000000000000118
[   25.011098] ---[ end trace 6de5bb4dd0c1d5cd ]---
[   26.580632] eth1: no IPv6 routers present
[   27.028508] eth0: no IPv6 routers present
[   28.308235] switch: no IPv6 routers present
[   29.539961] xenbr0: no IPv6 routers present
[   32.385322] switch: port 1(eth0) entered forwarding state
