Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab1HPJnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 05:43:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43915 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab1HPJnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 05:43:19 -0400
Date: Tue, 16 Aug 2011 11:42:45 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 3.0-rc2 failed s2ram: Freezing of tasks failed after 20.00 seconds
Message-ID: <20110816094245.GA2042@Pilar.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started testing 3.0-rc2 yesterday and after a few successful suspend to ram
it did not suspend anymore and I got this:

 PM: Syncing filesystems ... done.
 PM: Preparing system for mem sleep
 Freezing user space processes ... 
 Freezing of tasks failed after 20.00 seconds (1 tasks refusing to freeze, wq_busy=0):
 udisks-daemon   D ffff8800a641e5d0     0  5848   5845 0x00800004
  ffff8800a6741928 0000000000000082 ffff880000000000 00000000000105c0
  ffff8800a641e200 00000000000105c0 ffff8800a6741fd8 00000000000105c0
  00000000000105c0 ffff8800a6740000 ffff8800a6741fd8 00000000000105c0
 Call Trace:
  [<ffffffff814cf355>] schedule_timeout+0x1c5/0x230
  [<ffffffff814ce8c9>] ? schedule+0x399/0x8a0
  [<ffffffff814ce3e0>] wait_for_common+0xc0/0x160
  [<ffffffff8103ec60>] ? try_to_wake_up+0x290/0x290
  [<ffffffff814d10ba>] ? _raw_spin_unlock_irq+0x2a/0x40
  [<ffffffff814ce528>] wait_for_completion+0x18/0x20
  [<ffffffff81059afb>] flush_work+0x2b/0x40
  [<ffffffff81058fd0>] ? do_work_for_cpu+0x30/0x30
  [<ffffffff8105a076>] flush_delayed_work+0x46/0x50
  [<ffffffff8121e6b6>] disk_clear_events+0x76/0x110
  [<ffffffff81106052>] check_disk_change+0x32/0x80
  [<ffffffff812ee649>] sd_open+0xb9/0x190
  [<ffffffff81106f81>] __blkdev_get+0x91/0x3d0
  [<ffffffff81107600>] ? blkdev_get+0x340/0x340
  [<ffffffff8110730e>] blkdev_get+0x4e/0x340
  [<ffffffff810e1b17>] ? do_lookup+0xb7/0x380
  [<ffffffff81107600>] ? blkdev_get+0x340/0x340
  [<ffffffff8110765d>] blkdev_open+0x5d/0x80
  [<ffffffff810d3d80>] __dentry_open+0x130/0x320
  [<ffffffff810d5021>] nameidata_to_filp+0x71/0x80
  [<ffffffff810e2ab1>] do_last+0xb1/0x800
  [<ffffffff810e4603>] path_openat+0xd3/0x3f0
  [<ffffffff81229077>] ? kobject_put+0x27/0x60
  [<ffffffff812ced62>] ? put_device+0x12/0x20
  [<ffffffff810e4984>] do_filp_open+0x44/0xa0
  [<ffffffff810f0a44>] ? alloc_fd+0xf4/0x150
  [<ffffffff810d512c>] do_sys_open+0xfc/0x1e0
  [<ffffffff810d3a86>] ? filp_close+0x56/0x80
  [<ffffffff810d522b>] sys_open+0x1b/0x20
  [<ffffffff814d1c3b>] system_call_fastpath+0x16/0x1b
 
 Restarting tasks ... done.
 video LNXVIDEO:01: Restoring backlight state
 acpid: 1 client rule loaded
 EXT4-fs (sda2): re-mounted. Opts: discard,commit=600
 INFO: task udisks-daemon:5848 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 udisks-daemon   D ffff8800a641e5d0     0  5848   5845 0x00000004
  ffff8800a6741928 0000000000000082 ffff880000000000 00000000000105c0
  ffff8800a641e200 00000000000105c0 ffff8800a6741fd8 00000000000105c0
  00000000000105c0 ffff8800a6740000 ffff8800a6741fd8 00000000000105c0
 Call Trace:
  [<ffffffff814cf355>] schedule_timeout+0x1c5/0x230
  [<ffffffff814ce8c9>] ? schedule+0x399/0x8a0
  [<ffffffff814ce3e0>] wait_for_common+0xc0/0x160
  [<ffffffff8103ec60>] ? try_to_wake_up+0x290/0x290
  [<ffffffff814d10ba>] ? _raw_spin_unlock_irq+0x2a/0x40
  [<ffffffff814ce528>] wait_for_completion+0x18/0x20
  [<ffffffff81059afb>] flush_work+0x2b/0x40
  [<ffffffff81058fd0>] ? do_work_for_cpu+0x30/0x30
  [<ffffffff8105a076>] flush_delayed_work+0x46/0x50
  [<ffffffff8121e6b6>] disk_clear_events+0x76/0x110
  [<ffffffff81106052>] check_disk_change+0x32/0x80
  [<ffffffff812ee649>] sd_open+0xb9/0x190
  [<ffffffff81106f81>] __blkdev_get+0x91/0x3d0
  [<ffffffff81107600>] ? blkdev_get+0x340/0x340
  [<ffffffff8110730e>] blkdev_get+0x4e/0x340
  [<ffffffff810e1b17>] ? do_lookup+0xb7/0x380
  [<ffffffff81107600>] ? blkdev_get+0x340/0x340
  [<ffffffff8110765d>] blkdev_open+0x5d/0x80
  [<ffffffff810d3d80>] __dentry_open+0x130/0x320
  [<ffffffff810d5021>] nameidata_to_filp+0x71/0x80
  [<ffffffff810e2ab1>] do_last+0xb1/0x800
  [<ffffffff810e4603>] path_openat+0xd3/0x3f0
  [<ffffffff81229077>] ? kobject_put+0x27/0x60
  [<ffffffff812ced62>] ? put_device+0x12/0x20
  [<ffffffff810e4984>] do_filp_open+0x44/0xa0
  [<ffffffff810f0a44>] ? alloc_fd+0xf4/0x150
  [<ffffffff810d512c>] do_sys_open+0xfc/0x1e0
  [<ffffffff810d3a86>] ? filp_close+0x56/0x80
  [<ffffffff810d522b>] sys_open+0x1b/0x20
  [<ffffffff814d1c3b>] system_call_fastpath+0x16/0x1b
  

and there are some more of these traces in the logs, but they all look the 
same.

The laptop is a 64-bit Vaio VPCEB4X1E and suspend works flawlessly in 2.6.39
(haven't tested 3.0).

The following dmesg is from the boot with the failed suspend to ram, and 
should provide more details about the laptop. In case more information is
needed, please just ask.


klogd 1.4.1, log source = ksyslog started.
 0.000000] Initializing cgroup subsys cpu
 0.000000] Linux version 3.1.0-rc2 (mafra@Pilar.site) (gcc version 4.5.1 20101208 [gcc-4_5-branch revision 167585] (SUSE Linux) ) #47 SMP PREEMPT Mon Aug 15 22:48:27 CEST 2011
 0.000000] Command line: root=/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO946601BB160AGN-part2 resume=/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO946601BB160AGN-part1 splash=silent quiet
 0.000000] BIOS-provided physical RAM map:
 0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
 0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
 0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 0.000000]  BIOS-e820: 0000000000100000 - 00000000dee7c000 (usable)
 0.000000]  BIOS-e820: 00000000dee7c000 - 00000000deebc000 (ACPI NVS)
 0.000000]  BIOS-e820: 00000000deebc000 - 00000000deecd000 (reserved)
 0.000000]  BIOS-e820: 00000000deecd000 - 00000000deedf000 (ACPI NVS)
 0.000000]  BIOS-e820: 00000000deedf000 - 00000000deee0000 (reserved)
 0.000000]  BIOS-e820: 00000000deee0000 - 00000000deee3000 (ACPI NVS)
 0.000000]  BIOS-e820: 00000000deee3000 - 00000000def11000 (reserved)
 0.000000]  BIOS-e820: 00000000def11000 - 00000000def12000 (ACPI NVS)
 0.000000]  BIOS-e820: 00000000def12000 - 00000000def15000 (reserved)
 0.000000]  BIOS-e820: 00000000def15000 - 00000000def17000 (ACPI NVS)
 0.000000]  BIOS-e820: 00000000def17000 - 00000000def1b000 (reserved)
 0.000000]  BIOS-e820: 00000000def1b000 - 00000000def1e000 (ACPI data)
 0.000000]  BIOS-e820: 00000000def1e000 - 00000000def22000 (reserved)
 0.000000]  BIOS-e820: 00000000def22000 - 00000000def31000 (ACPI NVS)
 0.000000]  BIOS-e820: 00000000def31000 - 00000000e0000000 (reserved)
 0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
 0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
 0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
 0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 0.000000]  BIOS-e820: 00000000ffa00000 - 00000000ffc00000 (reserved)
 0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
 0.000000]  BIOS-e820: 0000000100000000 - 0000000118000000 (usable)
 0.000000] NX (Execute Disable) protection: active
 0.000000] DMI 2.6 present.
 0.000000] DMI: Sony Corporation VPCEB4X1E/VAIO, BIOS R1140Y8 10/06/2010
 0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
 0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
 0.000000] No AGP bridge found
 0.000000] last_pfn = 0x118000 max_arch_pfn = 0x400000000
 0.000000] MTRR default type: uncachable
 0.000000] MTRR fixed ranges enabled:
 0.000000]   00000-9FFFF write-back
 0.000000]   A0000-BFFFF uncachable
 0.000000]   C0000-CFFFF write-protect
 0.000000]   D0000-E7FFF uncachable
 0.000000]   E8000-FFFFF write-protect
 0.000000] MTRR variable ranges enabled:
 0.000000]   0 base 000000000 mask F80000000 write-back
 0.000000]   1 base 080000000 mask FC0000000 write-back
 0.000000]   2 base 0C0000000 mask FE0000000 write-back
 0.000000]   3 base 100000000 mask FE0000000 write-back
 0.000000]   4 base 118000000 mask FF8000000 uncachable
 0.000000]   5 base 0FFE00000 mask FFFE00000 write-protect
 0.000000]   6 disabled
 0.000000]   7 disabled
 0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
 0.000000] last_pfn = 0xdee7c max_arch_pfn = 0x400000000
 0.000000] initial memory mapped : 0 - 20000000
 0.000000] Base memory trampoline at [ffff880000099000] 99000 size 20480
 0.000000] init_memory_mapping: 0000000000000000-00000000dee7c000
 0.000000]  0000000000 - 00dee00000 page 2M
 0.000000]  00dee00000 - 00dee7c000 page 4k
 0.000000] kernel direct mapping tables up to dee7c000 @ dee76000-dee7c000
 0.000000] init_memory_mapping: 0000000100000000-0000000118000000
 0.000000]  0100000000 - 0118000000 page 2M
 0.000000] kernel direct mapping tables up to 118000000 @ 117ffa000-118000000
 0.000000] RAMDISK: 37575000 - 37ff0000
 0.000000] ACPI: RSDP 00000000000f0410 00024 (v02   Sony)
 0.000000] ACPI: XSDT 00000000def1ce18 0005C (v01   Sony     VAIO 20101006 MSFT 00010013)
 0.000000] ACPI: FACP 00000000def15d98 000F4 (v04   Sony     VAIO 20101006 MSFT 00010013)
 0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20110623/tbfadt-369)
 0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xDEF2DF40/0x00000000DEF30D40, using 32 (20110623/tbfadt-489)
 0.000000] ACPI: DSDT 00000000deecd018 0AE05 (v01   Sony     VAIO 20101006 INTL 20051117)
 0.000000] ACPI: FACS 00000000def2df40 00040
 0.000000] ACPI: APIC 00000000def1bf18 0008C (v02   Sony     VAIO 20101006 MSFT 00010013)
 0.000000] ACPI: MCFG 00000000def2fd18 0003C (v01   Sony     VAIO 20101006 MSFT 00000097)
 0.000000] ACPI: HPET 00000000def2fc98 00038 (v01   Sony     VAIO 20101006 MSFT 00000003)
 0.000000] ACPI: SLIC 00000000def28a18 00176 (v01   Sony     VAIO 20101006 Sony 01000000)
 0.000000] ACPI: SSDT 00000000def16018 009F1 (v01   Sony     VAIO 20101006 INTL 20051117)
 0.000000] ACPI: SSDT 00000000def15c18 0014B (v01   Sony     VAIO 20101006 INTL 20051117)
 0.000000] ACPI: Local APIC address 0xfee00000
 0.000000]  [ffffea0000000000-ffffea0003dfffff] PMD -> [ffff880113800000-ffff880116ffffff] on node 0
 0.000000] Zone PFN ranges:
 0.000000]   DMA      0x00000010 -> 0x00001000
 0.000000]   DMA32    0x00001000 -> 0x00100000
 0.000000]   Normal   0x00100000 -> 0x00118000
 0.000000] Movable zone start PFN for each node
 0.000000] early_node_map[3] active PFN ranges
 0.000000]     0: 0x00000010 -> 0x0000009e
 0.000000]     0: 0x00000100 -> 0x000dee7c
 0.000000]     0: 0x00100000 -> 0x00118000
 0.000000] On node 0 totalpages: 1011210
 0.000000]   DMA zone: 56 pages used for memmap
 0.000000]   DMA zone: 5 pages reserved
 0.000000]   DMA zone: 3921 pages, LIFO batch:0
 0.000000]   DMA32 zone: 14280 pages used for memmap
 0.000000]   DMA32 zone: 894644 pages, LIFO batch:31
 0.000000]   Normal zone: 1344 pages used for memmap
 0.000000]   Normal zone: 96960 pages, LIFO batch:31
 0.000000] ACPI: PM-Timer IO Port: 0x408
 0.000000] ACPI: Local APIC address 0xfee00000
 0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
 0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
 0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
 0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
 0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] disabled)
 0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] disabled)
 0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] disabled)
 0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] disabled)
 0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
 0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
 0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
 0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
 0.000000] ACPI: IRQ0 used by override.
 0.000000] ACPI: IRQ2 used by override.
 0.000000] ACPI: IRQ9 used by override.
 0.000000] Using ACPI (MADT) for SMP configuration information
 0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
 0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
 0.000000] nr_irqs_gsi: 40
 0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:18000000)
 0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
 0.000000] PERCPU: Embedded 25 pages/cpu @ffff880117c00000 s70208 r8192 d24000 u262144
 0.000000] pcpu-alloc: s70208 r8192 d24000 u262144 alloc=1*2097152
 0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
 0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 995525
 0.000000] Kernel command line: root=/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO946601BB160AGN-part2 resume=/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO946601BB160AGN-part1 splash=silent quiet
 0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
 0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
 0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
 0.000000] Checking aperture...
 0.000000] No AGP bridge found
 0.000000] Memory: 3891408k/4587520k available (4952k kernel code, 542680k absent, 153432k reserved, 5243k data, 460k init)
 0.000000] Preemptible hierarchical RCU implementation.
 0.000000] NR_IRQS:4352
 0.000000] Extended CMOS year: 2000
 0.000000] Console: colour VGA+ 80x25
 0.000000] console [tty0] enabled
 0.000000] hpet clockevent registered
 0.000000] Fast TSC calibration using PIT
 0.001000] spurious 8259A interrupt: IRQ7.
 0.001000] Detected 2659.829 MHz processor.
 0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5319.65 BogoMIPS (lpj=2659829)
 0.000006] pid_max: default: 32768 minimum: 301
 0.000073] Mount-cache hash table entries: 256
 0.000514] CPU: Physical Processor ID: 0
 0.000515] CPU: Processor Core ID: 0
 0.000519] mce: CPU supports 9 MCE banks
 0.000527] CPU0: Thermal monitoring handled by SMI
 0.000533] using mwait in idle threads.
 0.000562] ACPI: Core revision 20110623
 0.008809] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
 0.018786] CPU0: Intel(R) Core(TM) i5 CPU       M 480  @ 2.67GHz stepping 05
 0.120142] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
 0.120148] ... version:                3
 0.120149] ... bit width:              48
 0.120150] ... generic registers:      4
 0.120151] ... value mask:             0000ffffffffffff
 0.120152] ... max period:             000000007fffffff
 0.120153] ... fixed-purpose events:   3
 0.120154] ... event mask:             000000070000000f
 0.132129] Booting Node   0, Processors  #1
 0.132134] smpboot cpu 1: start_ip = 99000
 0.202948] CPU1: Thermal monitoring handled by SMI
 0.226892]  #2
 0.226896] smpboot cpu 2: start_ip = 99000
 0.297706] CPU2: Thermal monitoring handled by SMI
 0.321650]  #3
 0.321654] smpboot cpu 3: start_ip = 99000
 0.392461] CPU3: Thermal monitoring handled by SMI
 0.412452] Brought up 4 CPUs
 0.412454] Total of 4 processors activated (21278.81 BogoMIPS).
 0.414213] devtmpfs: initialized
 0.415213] NET: Registered protocol family 16
 0.415288] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
 0.415290] ACPI: bus type pci registered
 0.415337] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
 0.415340] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
 0.424271] PCI: Using configuration type 1 for base access
 0.425179] bio: create slab <bio-0> at 0
 0.425287] ACPI: Added _OSI(Module Device)
 0.425289] ACPI: Added _OSI(Processor Device)
 0.425290] ACPI: Added _OSI(3.0 _SCP Extensions)
 0.425292] ACPI: Added _OSI(Processor Aggregator Device)
 0.427221] ACPI: EC: Look up EC in DSDT
 0.431499] ACPI: Executed 2 blocks of module-level executable AML code
 0.441363] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
 0.441760] ACPI: SSDT 00000000def1aa18 00474 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
 0.442233] ACPI: Dynamic OEM Table Load:
 0.442235] ACPI: SSDT           (null) 00474 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
 0.442398] ACPI: SSDT 00000000def18018 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
 0.442856] ACPI: Dynamic OEM Table Load:
 0.442858] ACPI: SSDT           (null) 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
 0.449598] ACPI: SSDT 00000000def19a98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
 0.450124] ACPI: Dynamic OEM Table Load:
 0.450126] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
 0.452448] ACPI: SSDT 00000000def17d98 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
 0.452932] ACPI: Dynamic OEM Table Load:
 0.452934] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
 0.857475] ACPI: Interpreter enabled
 0.857478] ACPI: (supports S0 S3 S5)
 0.857494] ACPI: Using IOAPIC for interrupt routing
 0.885447] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
 0.885479] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
 0.885810] \_SB_.PCI0:_OSC invalid UUID
 0.885811] _OSC request data:1 8 1f 
 0.885814] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
 0.886331] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
 0.886333] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
 0.886335] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
 0.886337] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
 0.886339] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
 0.886340] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
 0.886342] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
 0.886344] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e3fff]
 0.886345] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e7fff]
 0.886347] pci_root PNP0A08:00: host bridge window [mem 0xe0000000-0xfeafffff]
 0.886358] pci 0000:00:00.0: [8086:0044] type 0 class 0x000600
 0.886388] pci 0000:00:01.0: [8086:0045] type 1 class 0x000604
 0.886410] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
 0.886412] pci 0000:00:01.0: PME# disabled
 0.886456] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
 0.886482] pci 0000:00:16.0: reg 10: [mem 0xf5e0a000-0xf5e0a00f 64bit]
 0.886555] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
 0.886559] pci 0000:00:16.0: PME# disabled
 0.886598] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
 0.886622] pci 0000:00:1a.0: reg 10: [mem 0xf5e08000-0xf5e083ff]
 0.886708] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
 0.886712] pci 0000:00:1a.0: PME# disabled
 0.886739] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
 0.886759] pci 0000:00:1b.0: reg 10: [mem 0xf5e00000-0xf5e03fff 64bit]
 0.886834] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
 0.886838] pci 0000:00:1b.0: PME# disabled
 0.886861] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
 0.886936] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
 0.886940] pci 0000:00:1c.0: PME# disabled
 0.886965] pci 0000:00:1c.1: [8086:3b44] type 1 class 0x000604
 0.887040] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
 0.887045] pci 0000:00:1c.1: PME# disabled
 0.887070] pci 0000:00:1c.2: [8086:3b46] type 1 class 0x000604
 0.887145] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
 0.887150] pci 0000:00:1c.2: PME# disabled
 0.887178] pci 0000:00:1c.5: [8086:3b4c] type 1 class 0x000604
 0.887254] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
 0.887259] pci 0000:00:1c.5: PME# disabled
 0.887294] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
 0.887318] pci 0000:00:1d.0: reg 10: [mem 0xf5e07000-0xf5e073ff]
 0.887403] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
 0.887407] pci 0000:00:1d.0: PME# disabled
 0.887431] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
 0.887504] pci 0000:00:1f.0: [8086:3b09] type 0 class 0x000601
 0.887619] pci 0000:00:1f.2: [8086:3b29] type 0 class 0x000106
 0.887645] pci 0000:00:1f.2: reg 10: [io  0xe070-0xe077]
 0.887656] pci 0000:00:1f.2: reg 14: [io  0xe060-0xe063]
 0.887666] pci 0000:00:1f.2: reg 18: [io  0xe050-0xe057]
 0.887677] pci 0000:00:1f.2: reg 1c: [io  0xe040-0xe043]
 0.887687] pci 0000:00:1f.2: reg 20: [io  0xe020-0xe03f]
 0.887697] pci 0000:00:1f.2: reg 24: [mem 0xf5e06000-0xf5e067ff]
 0.887743] pci 0000:00:1f.2: PME# supported from D3hot
 0.887748] pci 0000:00:1f.2: PME# disabled
 0.887770] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
 0.887790] pci 0000:00:1f.3: reg 10: [mem 0xf5e05000-0xf5e050ff 64bit]
 0.887818] pci 0000:00:1f.3: reg 20: [io  0xe000-0xe01f]
 0.887862] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
 0.887889] pci 0000:00:1f.6: reg 10: [mem 0xf5e04000-0xf5e04fff 64bit]
 0.887996] pci 0000:01:00.0: [1002:68c1] type 0 class 0x000300
 0.888008] pci 0000:01:00.0: reg 10: [mem 0xe0000000-0xefffffff 64bit pref]
 0.888017] pci 0000:01:00.0: reg 18: [mem 0xf0020000-0xf003ffff 64bit]
 0.888024] pci 0000:01:00.0: reg 20: [io  0xd000-0xd0ff]
 0.888035] pci 0000:01:00.0: reg 30: [mem 0xf0000000-0xf001ffff pref]
 0.888052] pci 0000:01:00.0: supports D1 D2
 0.888067] pci 0000:01:00.1: [1002:aa60] type 0 class 0x000403
 0.888079] pci 0000:01:00.1: reg 10: [mem 0xf0040000-0xf0043fff 64bit]
 0.888118] pci 0000:01:00.1: supports D1 D2
 0.888138] pci 0000:00:01.0: PCI bridge to [bus 01-01]
 0.888140] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
 0.888142] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf00fffff]
 0.888213] pci 0000:02:00.0: [168c:002b] type 0 class 0x000280
 0.888234] pci 0000:02:00.0: reg 10: [mem 0xf4a00000-0xf4a0ffff 64bit]
 0.888318] pci 0000:02:00.0: supports D1
 0.888319] pci 0000:02:00.0: PME# supported from D0 D1 D3hot D3cold
 0.888323] pci 0000:02:00.0: PME# disabled
 0.888350] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
 0.888354] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
 0.888358] pci 0000:00:1c.0:   bridge window [mem 0xf4a00000-0xf5dfffff]
 0.888472] pci 0000:03:00.0: [1180:e822] type 0 class 0x000805
 0.888494] pci 0000:03:00.0: reg 10: [mem 0xf3602000-0xf36020ff]
 0.888626] pci 0000:03:00.0: supports D1 D2
 0.888627] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
 0.888633] pci 0000:03:00.0: PME# disabled
 0.888679] pci 0000:03:00.1: [1180:e230] type 0 class 0x000880
 0.888700] pci 0000:03:00.1: reg 10: [mem 0xf3601000-0xf36010ff]
 0.888832] pci 0000:03:00.1: supports D1 D2
 0.888833] pci 0000:03:00.1: PME# supported from D0 D1 D2 D3hot D3cold
 0.888839] pci 0000:03:00.1: PME# disabled
 0.888884] pci 0000:03:00.4: [1180:e822] type 0 class 0x000805
 0.888906] pci 0000:03:00.4: reg 10: [mem 0xf3600000-0xf36000ff]
 0.889038] pci 0000:03:00.4: supports D1 D2
 0.889039] pci 0000:03:00.4: PME# supported from D0 D1 D2 D3hot D3cold
 0.889045] pci 0000:03:00.4: PME# disabled
 0.889108] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
 0.889112] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
 0.889116] pci 0000:00:1c.1:   bridge window [mem 0xf3600000-0xf49fffff]
 0.889386] pci 0000:04:00.0: [11ab:4381] type 0 class 0x000200
 0.889601] pci 0000:04:00.0: reg 10: [mem 0xf2220000-0xf2223fff 64bit]
 0.889710] pci 0000:04:00.0: reg 18: [io  0xa000-0xa0ff]
 0.890138] pci 0000:04:00.0: reg 30: [mem 0xf2200000-0xf221ffff pref]
 0.890463] pci 0000:04:00.0: supports D1 D2
 0.890464] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
 0.890499] pci 0000:04:00.0: PME# disabled
 0.890722] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
 0.890727] pci 0000:00:1c.2:   bridge window [io  0xa000-0xafff]
 0.890731] pci 0000:00:1c.2:   bridge window [mem 0xf2200000-0xf35fffff]
 0.890791] pci 0000:00:1c.5: PCI bridge to [bus 05-0c]
 0.890795] pci 0000:00:1c.5:   bridge window [io  0x9000-0x9fff]
 0.890799] pci 0000:00:1c.5:   bridge window [mem 0xf0200000-0xf21fffff]
 0.890874] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d] (subtractive decode)
 0.890886] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
 0.890888] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
 0.890890] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
 0.890892] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
 0.890894] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
 0.890895] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
 0.890897] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
 0.890899] pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
 0.890901] pci 0000:00:1e.0:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
 0.890902] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xfeafffff] (subtractive decode)
 0.890933] pci_bus 0000:00: on NUMA node 0
 0.890936] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
 0.891063] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
 0.891112] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
 0.891168] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
 0.891234] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
 0.891284] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
 0.891400] \_SB_.PCI0:_OSC invalid UUID
 0.891401] _OSC request data:1 1f 1f 
 0.891404]  pci0000:00: Requesting ACPI _OSC control (0x15)
 0.891437] \_SB_.PCI0:_OSC invalid UUID
 0.891438] _OSC request data:1 0 15 
 0.891441]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: 0x15
 0.891442] ACPI _OSC control for PCIe not granted, disabling ASPM
 0.895843] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus 3f])
 0.895896] pci 0000:3f:00.0: [8086:2c62] type 0 class 0x000600
 0.895912] pci 0000:3f:00.1: [8086:2d01] type 0 class 0x000600
 0.895927] pci 0000:3f:02.0: [8086:2d10] type 0 class 0x000600
 0.895941] pci 0000:3f:02.1: [8086:2d11] type 0 class 0x000600
 0.895955] pci 0000:3f:02.2: [8086:2d12] type 0 class 0x000600
 0.895968] pci 0000:3f:02.3: [8086:2d13] type 0 class 0x000600
 0.895989] pci_bus 0000:3f: on NUMA node 0
 0.895996]  pci0000:3f: Requesting ACPI _OSC control (0x15)
 0.895998]  pci0000:3f: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x15
 0.895999] ACPI _OSC control for PCIe not granted, disabling ASPM
 0.896186] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
 0.896230] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
 0.896276] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 *4 5 6 7 10 12 14 15)
 0.896319] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 11 12 14 15)
 0.896362] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
 0.896404] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
 0.896447] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
 0.896490] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
 0.896562] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
 0.896567] vgaarb: loaded
 0.896568] vgaarb: bridge control possible 0000:01:00.0
 0.896646] SCSI subsystem initialized
 0.896657] libata version 3.00 loaded.
 0.896684] usbcore: registered new interface driver usbfs
 0.896692] usbcore: registered new interface driver hub
 0.896721] usbcore: registered new device driver usb
 0.896770] Advanced Linux Sound Architecture Driver Version 1.0.24.
 0.896771] PCI: Using ACPI for IRQ routing
 0.898966] PCI: pci_cache_line_size set to 64 bytes
 0.899052] reserve RAM buffer: 000000000009e800 - 000000000009ffff 
 0.899054] reserve RAM buffer: 00000000dee7c000 - 00000000dfffffff 
 0.899164] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
 0.899169] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
 0.901184] Switching to clocksource hpet
 0.901247] Switched to NOHz mode on CPU #2
 0.901288] Switched to NOHz mode on CPU #1
 0.901306] pnp: PnP ACPI init
 0.901314] ACPI: bus type pnp registered
 0.901583] pnp 00:00: [bus 00-3e]
 0.901585] pnp 00:00: [io  0x0000-0x0cf7 window]
 0.901587] pnp 00:00: [io  0x0cf8-0x0cff]
 0.901589] pnp 00:00: [io  0x0d00-0xffff window]
 0.901591] pnp 00:00: [mem 0x000a0000-0x000bffff window]
 0.901593] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
 0.901594] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
 0.901595] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
 0.901597] pnp 00:00: [mem 0x000cc000-0x000cffff window]
 0.901598] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
 0.901599] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
 0.901601] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
 0.901602] pnp 00:00: [mem 0x000dc000-0x000dffff window]
 0.901603] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
 0.901605] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
 0.901606] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
 0.901608] pnp 00:00: [mem 0x000ec000-0x000effff window]
 0.901609] pnp 00:00: [mem 0x000f0000-0x000fffff window]
 0.901610] pnp 00:00: [mem 0xe0000000-0xfeafffff window]
 0.901659] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
 0.901672] pnp 00:01: [io  0x0000-0x001f]
 0.901673] pnp 00:01: [io  0x0081-0x0091]
 0.901674] pnp 00:01: [io  0x0093-0x009f]
 0.901675] pnp 00:01: [io  0x00c0-0x00df]
 0.901677] pnp 00:01: [dma 4]
 0.901693] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
 0.901701] pnp 00:02: [mem 0xff000000-0xffffffff]
 0.901715] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
 0.901785] pnp 00:03: [mem 0xfed00000-0xfed003ff]
 0.901802] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
 0.901812] pnp 00:04: [io  0x00f0]
 0.901819] pnp 00:04: [irq 13]
 0.901836] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
 0.901846] pnp 00:05: [io  0x002e-0x002f]
 0.901847] pnp 00:05: [io  0x004e-0x004f]
 0.901848] pnp 00:05: [io  0x0061]
 0.901849] pnp 00:05: [io  0x0063]
 0.901850] pnp 00:05: [io  0x0065]
 0.901852] pnp 00:05: [io  0x0067]
 0.901853] pnp 00:05: [io  0x0070]
 0.901855] pnp 00:05: [io  0x0080]
 0.901856] pnp 00:05: [io  0x0092]
 0.901857] pnp 00:05: [io  0x00b2-0x00b3]
 0.901858] pnp 00:05: [io  0x0680-0x069f]
 0.901859] pnp 00:05: [io  0xff00-0xff0f]
 0.901861] pnp 00:05: [io  0xff10-0xff13]
 0.901862] pnp 00:05: [io  0x0800-0x0803]
 0.901863] pnp 00:05: [io  0x0400-0x047f]
 0.901864] pnp 00:05: [io  0x0500-0x057f]
 0.901866] pnp 00:05: [io  0x164e-0x164f]
 0.901901] system 00:05: [io  0x0680-0x069f] has been reserved
 0.901903] system 00:05: [io  0xff00-0xff0f] has been reserved
 0.901905] system 00:05: [io  0xff10-0xff13] has been reserved
 0.901907] system 00:05: [io  0x0800-0x0803] has been reserved
 0.901908] system 00:05: [io  0x0400-0x047f] has been reserved
 0.901910] system 00:05: [io  0x0500-0x057f] has been reserved
 0.901912] system 00:05: [io  0x164e-0x164f] has been reserved
 0.901914] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
 0.901922] pnp 00:06: [io  0x0070-0x0077]
 0.901926] pnp 00:06: [irq 8]
 0.901943] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
 0.901952] pnp 00:07: [io  0x0060]
 0.901954] pnp 00:07: [io  0x0064]
 0.901958] pnp 00:07: [irq 1]
 0.901974] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
 0.901985] pnp 00:08: [irq 12]
 0.902027] pnp 00:08: Plug and Play ACPI device, IDs PNP0f13 (active)
 0.902143] Switched to NOHz mode on CPU #0
 0.902194] Switched to NOHz mode on CPU #3
 0.902415] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
 0.902417] pnp 00:09: [mem 0xfed10000-0xfed13fff]
 0.902419] pnp 00:09: [mem 0xfed18000-0xfed18fff]
 0.902420] pnp 00:09: [mem 0xfed19000-0xfed19fff]
 0.902421] pnp 00:09: [mem 0xf8000000-0xfbffffff]
 0.902422] pnp 00:09: [mem 0xfed20000-0xfed3ffff]
 0.902424] pnp 00:09: [mem 0xfed90000-0xfed8ffff disabled]
 0.902425] pnp 00:09: [mem 0xfed45000-0xfed8ffff]
 0.902427] pnp 00:09: [mem 0xff000000-0xffffffff]
 0.902428] pnp 00:09: [mem 0xfee00000-0xfeefffff]
 0.902430] pnp 00:09: [mem 0xf7fff000-0xf7ffffff]
 0.902488] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
 0.902490] system 00:09: [mem 0xfed10000-0xfed13fff] has been reserved
 0.902492] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
 0.902494] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
 0.902496] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
 0.902498] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
 0.902500] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
 0.902502] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
 0.902504] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
 0.902506] system 00:09: [mem 0xf7fff000-0xf7ffffff] has been reserved
 0.902508] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
 0.902648] pnp 00:0a: [bus 3f]
 0.902692] pnp 00:0a: Plug and Play ACPI device, IDs PNP0a03 (active)
 0.913023] pnp: PnP ACPI: found 11 devices
 0.913025] ACPI: ACPI bus type pnp unregistered
 0.919701] PCI: max bus depth: 1 pci_try_num: 2
 0.919754] pci 0000:00:1c.5: BAR 9: assigned [mem 0xf5f00000-0xf60fffff 64bit pref]
 0.919758] pci 0000:00:1c.2: BAR 9: assigned [mem 0xf6100000-0xf62fffff 64bit pref]
 0.919762] pci 0000:00:1c.1: BAR 9: assigned [mem 0xf6300000-0xf64fffff 64bit pref]
 0.919765] pci 0000:00:1c.0: BAR 9: assigned [mem 0xf6500000-0xf66fffff 64bit pref]
 0.919768] pci 0000:00:01.0: PCI bridge to [bus 01-01]
 0.919770] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
 0.919772] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf00fffff]
 0.919776] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
 0.919779] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
 0.919785] pci 0000:00:1c.0:   bridge window [mem 0xf4a00000-0xf5dfffff]
 0.919789] pci 0000:00:1c.0:   bridge window [mem 0xf6500000-0xf66fffff 64bit pref]
 0.919796] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
 0.919799] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
 0.919805] pci 0000:00:1c.1:   bridge window [mem 0xf3600000-0xf49fffff]
 0.919809] pci 0000:00:1c.1:   bridge window [mem 0xf6300000-0xf64fffff 64bit pref]
 0.919817] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
 0.919820] pci 0000:00:1c.2:   bridge window [io  0xa000-0xafff]
 0.919825] pci 0000:00:1c.2:   bridge window [mem 0xf2200000-0xf35fffff]
 0.919830] pci 0000:00:1c.2:   bridge window [mem 0xf6100000-0xf62fffff 64bit pref]
 0.919837] pci 0000:00:1c.5: PCI bridge to [bus 05-0c]
 0.919840] pci 0000:00:1c.5:   bridge window [io  0x9000-0x9fff]
 0.919845] pci 0000:00:1c.5:   bridge window [mem 0xf0200000-0xf21fffff]
 0.919850] pci 0000:00:1c.5:   bridge window [mem 0xf5f00000-0xf60fffff 64bit pref]
 0.919856] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
 0.919876] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 0.919879] pci 0000:00:01.0: setting latency timer to 64
 0.919885] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 0.919889] pci 0000:00:1c.0: setting latency timer to 64
 0.919898] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 0.919902] pci 0000:00:1c.1: setting latency timer to 64
 0.919911] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
 0.919915] pci 0000:00:1c.2: setting latency timer to 64
 0.919922] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 0.919926] pci 0000:00:1c.5: setting latency timer to 64
 0.919934] pci 0000:00:1e.0: setting latency timer to 64
 0.919937] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
 0.919939] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
 0.919940] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
 0.919942] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
 0.919943] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
 0.919945] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
 0.919946] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
 0.919948] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
 0.919949] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
 0.919951] pci_bus 0000:00: resource 13 [mem 0xe0000000-0xfeafffff]
 0.919953] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
 0.919954] pci_bus 0000:01: resource 1 [mem 0xe0000000-0xf00fffff]
 0.919956] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
 0.919957] pci_bus 0000:02: resource 1 [mem 0xf4a00000-0xf5dfffff]
 0.919959] pci_bus 0000:02: resource 2 [mem 0xf6500000-0xf66fffff 64bit pref]
 0.919961] pci_bus 0000:03: resource 0 [io  0xb000-0xbfff]
 0.919962] pci_bus 0000:03: resource 1 [mem 0xf3600000-0xf49fffff]
 0.919964] pci_bus 0000:03: resource 2 [mem 0xf6300000-0xf64fffff 64bit pref]
 0.919965] pci_bus 0000:04: resource 0 [io  0xa000-0xafff]
 0.919967] pci_bus 0000:04: resource 1 [mem 0xf2200000-0xf35fffff]
 0.919968] pci_bus 0000:04: resource 2 [mem 0xf6100000-0xf62fffff 64bit pref]
 0.919970] pci_bus 0000:05: resource 0 [io  0x9000-0x9fff]
 0.919971] pci_bus 0000:05: resource 1 [mem 0xf0200000-0xf21fffff]
 0.919973] pci_bus 0000:05: resource 2 [mem 0xf5f00000-0xf60fffff 64bit pref]
 0.919975] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
 0.919976] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
 0.919978] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
 0.919979] pci_bus 0000:0d: resource 7 [mem 0x000d0000-0x000d3fff]
 0.919981] pci_bus 0000:0d: resource 8 [mem 0x000d4000-0x000d7fff]
 0.919982] pci_bus 0000:0d: resource 9 [mem 0x000d8000-0x000dbfff]
 0.919984] pci_bus 0000:0d: resource 10 [mem 0x000dc000-0x000dffff]
 0.919985] pci_bus 0000:0d: resource 11 [mem 0x000e0000-0x000e3fff]
 0.919987] pci_bus 0000:0d: resource 12 [mem 0x000e4000-0x000e7fff]
 0.919988] pci_bus 0000:0d: resource 13 [mem 0xe0000000-0xfeafffff]
 0.920059] NET: Registered protocol family 2
 0.920148] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
 0.920517] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
 0.921301] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
 0.921510] TCP: Hash tables configured (established 262144 bind 65536)
 0.921512] TCP reno registered
 0.921515] UDP hash table entries: 2048 (order: 4, 65536 bytes)
 0.921531] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
 0.921713] NET: Registered protocol family 1
 2.018584] pci 0000:00:1a.0: EHCI: BIOS handoff failed (BIOS bug?) 01010001
 3.115896] pci 0000:00:1d.0: EHCI: BIOS handoff failed (BIOS bug?) 01010001
 3.116025] pci 0000:01:00.0: Boot video device
 3.116053] PCI: CLS 64 bytes, default 64
 3.116089] Trying to unpack rootfs image as initramfs...
 3.265838] Freeing initrd memory: 10732k freed
 3.268103] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
 3.268109] Placing 64MB software IO TLB between ffff8800dae76000 - ffff8800dee76000
 3.268110] software IO TLB at phys 0xdae76000 - 0xdee76000
 3.276692] Btrfs loaded
 3.276698] msgmni has been set to 7621
 3.276906] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
 3.276908] io scheduler noop registered
 3.276929] io scheduler cfq registered (default)
 3.277004] pcieport 0000:00:01.0: setting latency timer to 64
 3.277027] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
 3.277323] intel_idle: MWAIT substates: 0x1120
 3.277324] intel_idle: v0.4 model 0x25
 3.277325] intel_idle: lapic_timer_reliable_states 0xffffffff
 3.287029] ACPI: AC Adapter [ADP1] (on-line)
 3.287144] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
 3.297044] ACPI: Lid Switch [LID0]
 3.297083] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
 3.297087] ACPI: Power Button [PWRB]
 3.297156] [Firmware Bug]: ACPI(VGA) defines _DOD but not _DOS
 3.318632] acpi device:4b: registered as cooling_device0
 3.318675] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:4a/LNXVIDEO:01/input/input2
 3.318678] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
 3.318699] ACPI: acpi_idle yielding to intel_idle
 3.340082] thermal LNXTHERM:00: registered as thermal_zone0
 3.340086] ACPI: Thermal Zone [TZ00] (49 C)
 3.350129] thermal LNXTHERM:01: registered as thermal_zone1
 3.350132] ACPI: Thermal Zone [TZ01] (49 C)
 3.350415] Non-volatile memory driver v1.3
 3.350417] Linux agpgart interface v0.103
 3.352143] brd: module loaded
 3.352181] ahci 0000:00:1f.2: version 3.0
 3.352195] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
 3.352237] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
 3.352269] ahci: SSS flag set, parallel bus scan disabled
 3.352324] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 0x23 impl SATA mode
 3.352327] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part sxs apst 
 3.352332] ahci 0000:00:1f.2: setting latency timer to 64
 3.352745] scsi0 : ahci
 3.352826] scsi1 : ahci
 3.352876] scsi2 : ahci
 3.352924] scsi3 : ahci
 3.352972] scsi4 : ahci
 3.353021] scsi5 : ahci
 3.353051] ata1: SATA max UDMA/133 abar m2048@0xf5e06000 port 0xf5e06100 irq 41
 3.353054] ata2: SATA max UDMA/133 abar m2048@0xf5e06000 port 0xf5e06180 irq 41
 3.353056] ata3: DUMMY
 3.353057] ata4: DUMMY
 3.353058] ata5: DUMMY
 3.353060] ata6: SATA max UDMA/133 abar m2048@0xf5e06000 port 0xf5e06380 irq 41
 3.353076] sky2: driver version 1.29
 3.353094] sky2 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
 3.353108] sky2 0000:04:00.0: setting latency timer to 64
 3.353141] sky2 0000:04:00.0: Yukon-2 Optima chip revision 1
 3.353261] sky2 0000:04:00.0: irq 42 for MSI/MSI-X
 3.353522] sky2 0000:04:00.0: eth0: addr 78:84:3c:02:d8:a5
 3.353538] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
 3.353552] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 3.353566] ehci_hcd 0000:00:1a.0: setting latency timer to 64
 3.353569] ehci_hcd 0000:00:1a.0: EHCI Host Controller
 3.353574] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
 3.353603] ehci_hcd 0000:00:1a.0: debug port 2
 3.357507] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
 3.357525] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf5e08000
 3.367290] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
 3.367323] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
 3.367327] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 3.367331] usb usb1: Product: EHCI Host Controller
 3.367334] usb usb1: Manufacturer: Linux 3.1.0-rc2 ehci_hcd
 3.367338] usb usb1: SerialNumber: 0000:00:1a.0
 3.367441] hub 1-0:1.0: USB hub found
 3.367445] hub 1-0:1.0: 2 ports detected
 3.367496] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
 3.367508] ehci_hcd 0000:00:1d.0: setting latency timer to 64
 3.367511] ehci_hcd 0000:00:1d.0: EHCI Host Controller
 3.367515] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
 3.367539] ehci_hcd 0000:00:1d.0: debug port 2
 3.371449] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
 3.371464] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf5e07000
 3.381253] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
 3.381287] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
 3.381291] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 3.381295] usb usb2: Product: EHCI Host Controller
 3.381298] usb usb2: Manufacturer: Linux 3.1.0-rc2 ehci_hcd
 3.381301] usb usb2: SerialNumber: 0000:00:1d.0
 3.381391] hub 2-0:1.0: USB hub found
 3.381395] hub 2-0:1.0: 2 ports detected
 3.381438] uhci_hcd: USB Universal Host Controller Interface driver
 3.381464] Initializing USB Mass Storage driver...
 3.381478] usbcore: registered new interface driver usb-storage
 3.381480] USB Mass Storage support registered.
 3.381515] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
 3.387244] serio: i8042 KBD port at 0x60,0x64 irq 1
 3.387265] serio: i8042 AUX port at 0x60,0x64 irq 12
 3.387338] mousedev: PS/2 mouse device common for all mice
 3.387493] lirc_dev: IR Remote Control driver registered, major 253 
 3.387500] Linux video capture interface: v2.00
 3.387539] coretemp coretemp.0: TjMax is 105 C.
 3.387549] coretemp coretemp.0: TjMax is 105 C.
 3.387625] cpuidle: using governor ladder
 3.387724] cpuidle: using governor menu
 3.387730] sdhci: Secure Digital Host Controller Interface driver
 3.387731] sdhci: Copyright(c) Pierre Ossman
 3.387739] sdhci-pci 0000:03:00.0: SDHCI controller found [1180:e822] (rev 0)
 3.387753] sdhci-pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
 3.387770] sdhci-pci 0000:03:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
 3.387776] sdhci-pci 0000:03:00.0: setting latency timer to 64
 3.387811] Registered led device: mmc0::
 3.387838] mmc0: SDHCI controller on PCI [0000:03:00.0] using DMA
 3.387852] sdhci-pci 0000:03:00.4: SDHCI controller found [1180:e822] (rev 0)
 3.387868] sdhci-pci 0000:03:00.4: PCI INT C -> GSI 19 (level, low) -> IRQ 19
 3.387886] sdhci-pci 0000:03:00.4: Will use DMA mode even though HW doesn't fully claim to support it.
 3.387894] sdhci-pci 0000:03:00.4: setting latency timer to 64
 3.387927] Registered led device: mmc1::
 3.387950] mmc1: SDHCI controller on PCI [0000:03:00.4] using DMA
 3.387962] sdhci-pltfm: SDHCI platform and OF driver helper
 3.388242] usbcore: registered new interface driver usbhid
 3.388243] usbhid: USB HID core driver
 3.389678] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
 3.389750] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
 3.389786] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
 3.407106] hda_codec: ALC269: BIOS auto-probing.
 3.411256] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
 3.411499] snd_hda_intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 3.411541] snd_hda_intel 0000:01:00.1: irq 44 for MSI/MSI-X
 3.411559] snd_hda_intel 0000:01:00.1: setting latency timer to 64
 3.415661] HDMI status: Codec=0 Pin=3 Presence_Detect=0 ELD_Valid=0
 3.416021] ALSA device list:
 3.416025]   #0: HDA Intel at 0xf5e00000 irq 43
 3.416028]   #1: HD-Audio Generic at 0xf0040000 irq 44
 3.416217] TCP cubic registered
 3.416218] Initializing XFRM netlink socket
 3.416353] NET: Registered protocol family 10
 3.417678] IPv6 over IPv4 tunneling driver
 3.417973] lib80211: common routines for IEEE802.11 drivers
 3.417975] lib80211_crypt: registered algorithm 'NULL'
 3.438849] ACPI: Battery Slot [BAT0] (battery present)
 3.659646] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
 3.659912] ata1.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102HD, max UDMA/133
 3.659915] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
 3.660316] ata1.00: configured for UDMA/133
 3.660682] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
 3.660869] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
 3.661222] sd 0:0:0:0: [sda] Write Protect is off
 3.661227] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
 3.661284] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 3.662065]  sda: sda1 sda2 sda3
 3.662413] sd 0:0:0:0: [sda] Attached SCSI disk
 3.668645] usb 1-1: new high speed USB device number 2 using ehci_hcd
 3.782874] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
 3.782879] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
 3.783178] hub 1-1:1.0: USB hub found
 3.783371] hub 1-1:1.0: 6 ports detected
 3.886044] usb 2-1: new high speed USB device number 2 using ehci_hcd
 3.964946] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
 3.967699] ata2.00: ATAPI: PIONEER BD-ROM  BDC-TD03, 1.00, max UDMA/100
 3.970724] ata2.00: configured for UDMA/100
 3.981302] scsi 1:0:0:0: CD-ROM            PIONEER  BD-ROM  BDC-TD03 1.00 PQ: 0 ANSI: 5
 4.000206] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
 4.000211] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
 4.000493] hub 2-1:1.0: USB hub found
 4.000739] hub 2-1:1.0: 8 ports detected
 4.074813] usb 1-1.2: new high speed USB device number 3 using ehci_hcd
 4.193031] usb 1-1.2: New USB device found, idVendor=0c45, idProduct=6464
 4.193037] usb 1-1.2: New USB device strings: Mfr=2, Product=1, SerialNumber=0
 4.193042] usb 1-1.2: Product: USB 2.0 Camera
 4.193045] usb 1-1.2: Manufacturer: USB 2.0 Camera
 4.209258] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input4
 4.267182] Refined TSC clocksource calibration: 2660.158 MHz.
 4.267190] Switching to clocksource tsc
 4.285132] ata6: SATA link down (SStatus 0 SControl 300)
 4.286384] Freeing unused kernel memory: 460k freed
 4.286482] Write protecting the kernel read-only data: 8192k
 4.292978] Freeing unused kernel memory: 1172k freed
 4.293392] Freeing unused kernel memory: 32k freed
 4.333458] udev[88]: starting version 166
 4.378515] [drm] Initialized drm 1.1.0 20060810
 4.384294] [drm] radeon defaulting to kernel modesetting.
 4.384297] [drm] radeon kernel modesetting enabled.
 4.384369] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 4.384374] radeon 0000:01:00.0: setting latency timer to 64
 4.384522] [drm] initializing kernel modesetting (REDWOOD 0x1002:0x68C1 0x104D:0x9071).
 4.384581] [drm] register mmio base: 0xF0020000
 4.384583] [drm] register mmio size: 131072
 4.384705] ATOM BIOS: Sony
 4.384726] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
 4.384729] radeon 0000:01:00.0: GTT: 512M 0x0000000040000000 - 0x000000005FFFFFFF
 4.385487] [drm] Detected VRAM RAM=1024M, BAR=256M
 4.385490] [drm] RAM width 128bits DDR
 4.385635] [TTM] Zone  kernel: Available graphics memory: 1951902 kiB.
 4.385637] [TTM] Initializing pool allocator.
 4.385665] [drm] radeon: 1024M of VRAM memory ready
 4.385666] [drm] radeon: 512M of GTT memory ready.
 4.385671] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
 4.385672] [drm] Driver supports precise vblank timestamp query.
 4.385708] radeon 0000:01:00.0: irq 45 for MSI/MSI-X
 4.385713] radeon 0000:01:00.0: radeon: using MSI.
 4.385751] [drm] radeon: irq initialized.
 4.385756] [drm] GART: num cpu pages 131072, num gpu pages 131072
 4.386313] [drm] Loading REDWOOD Microcode
 4.420590] radeon 0000:01:00.0: WB enabled
 4.437165] [drm] ring test succeeded in 1 usecs
 4.437237] [drm] radeon: ib pool ready.
 4.437288] [drm] ib test succeeded in 0 usecs
 4.437606] [drm] Radeon Display Connectors
 4.437609] [drm] Connector 0:
 4.437610] [drm]   LVDS
 4.437611] [drm]   Encoders:
 4.437612] [drm]     LCD1: INTERNAL_UNIPHY
 4.437614] [drm] Connector 1:
 4.437615] [drm]   HDMI-A
 4.437616] [drm]   HPD1
 4.437618] [drm]   DDC: 0x6470 0x6470 0x6474 0x6474 0x6478 0x6478 0x647c 0x647c
 4.437619] [drm]   Encoders:
 4.437620] [drm]     DFP1: INTERNAL_UNIPHY1
 4.437622] [drm] Connector 2:
 4.437623] [drm]   VGA
 4.437625] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
 4.437627] [drm]   Encoders:
 4.437628] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
 4.447552] [drm] Radeon display connector HDMI-A-1: No monitor connected or invalid EDID
 4.457466] [drm] Radeon display connector VGA-1: No monitor connected or invalid EDID
 4.457493] [drm] Internal thermal controller with fan control
 4.457524] [drm] radeon: power management initialized
 4.851929] [drm] fb mappable at 0xE0141000
 4.851930] [drm] vram apper at 0xE0000000
 4.851931] [drm] size 8294400
 4.851932] [drm] fb depth is 24
 4.851933] [drm]    pitch is 7680
 4.852058] fbcon: radeondrmfb (fb0) is primary device
 5.848000] Console: switching to colour frame buffer device 240x67
 5.852474] fb0: radeondrmfb frame buffer device
 5.852475] drm: registered panic notifier
 5.852480] [drm] Initialized radeon 2.11.0 20080528 for 0000:01:00.0 on minor 0
 5.928912] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: discard
 5.943461] EXT4-fs (sda2): re-mounted. Opts: discard
 6.242454] udev[316]: starting version 166
 6.286782] sony_laptop: Sony Notebook Control Driver v0.6
 6.300630] input: Sony Vaio Keys as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/SNY5001:00/input/input5
 6.300753] input: Sony Vaio Jogdial as /devices/virtual/input/input6
 6.300822] sony_laptop: brightness ignored, must be controlled by ACPI video driver
 6.322857] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
 6.325966] uvcvideo: Found UVC 1.00 device USB 2.0 Camera (0c45:6464)
 6.334181] input: USB 2.0 Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input7
 6.334263] usbcore: registered new interface driver uvcvideo
 6.334265] USB Video Class driver (1.1.1)
 6.347815] sd 0:0:0:0: Attached scsi generic sg0 type 0
 6.348001] scsi 1:0:0:0: Attached scsi generic sg1 type 5
 6.367868] sr0: scsi3-mmc drive: 62x/62x writer dvd-ram cd/rw xa/form2 cdda tray
 6.367873] cdrom: Uniform CD-ROM driver Revision: 3.20
 6.368161] sr 1:0:0:0: Attached scsi CD-ROM sr0
 6.629929] Adding 2104476k swap on /dev/sda1.  Priority:-1 extents:1 across:2104476k SS
 6.736070] device fsid 5c83f0ac-40c4-4e35-99c7-a6e496f753ee devid 1 transid 322993 /dev/sda3
 6.736487] btrfs: use ssd allocation scheme
 6.736496] btrfs: use zlib compression
Kernel logging (ksyslog) stopped.
Kernel log daemon terminating.


