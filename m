Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2LDM5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 07:57:48 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:57925 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2LDM5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 07:57:44 -0500
Message-ID: <50BDF345.60804@gmail.com>
Date: Tue, 04 Dec 2012 13:57:41 +0100
From: Roberto Oppedisano <roberto.oppedisano@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, rui.zhang@intel.com,
        "Rafael J. Wysocki" <rjw@sisk.pl>, eduardo.valentin@ti.com
Subject: regression in linux 3.7 - fan speed at 100% after suspend/resume
 at 100%
Content-Type: multipart/mixed;
 boundary="------------050601040604010602010406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050601040604010602010406
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,
     with recent kernels after a suspend/resume cycle on my laptop (HP 
6730b) the fans stays at full speed.
I've bisected down to this commit:

ce119f83257aae29b84a5bfad0669e8348437b18 is the first bad commit
commit ce119f83257aae29b84a5bfad0669e8348437b18
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Jun 27 14:13:04 2012 +0800

     Thermal: Introduce simple arbitrator for setting device cooling state

     This fixes the problem that a cooling device may be referenced by
     by multiple trip points in multiple thermal zones.

     With this patch, we have two stages for updating a thermal zone,
     1. check if a thermal_instance needs to be updated or not
     2. update the cooling device, based on the target cooling state
        of all its instances.

     Note that, currently, the cooling device is set to the deepest
     cooling state required.

     Signed-off-by: Zhang Rui <rui.zhang@intel.com>
     Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
     Reviewed-by: Eduardo Valentin <eduardo.valentin@ti.com>

:040000 040000 8469b057ee5b33bdb264624db35c951d0ecdb66b 
d7288437cff3c7437e59144c46c04c78669a597b M      drivers
:040000 040000 397296161d55c825f07501470130928d226497cc 
f715fd1770dd33fd333c5fa339e740537b2a916f M      include

I tried to revert it but there are rejects so I cold not try current 
kernel with simply this commit removed.

As a side note when the fan is at full speed a see an anomaly on thermal 
indicator #4

$ grep 0 /sys/devices/virtual/thermal/thermal_zone*/temp
/sys/devices/virtual/thermal/thermal_zone0/temp:59000
/sys/devices/virtual/thermal/thermal_zone1/temp:63000
/sys/devices/virtual/thermal/thermal_zone2/temp:48000
/sys/devices/virtual/thermal/thermal_zone3/temp:27900
/sys/devices/virtual/thermal/thermal_zone4/temp:100000

while the others seem to report normal value. Attached the output of 
dmesg on this laptop.

More info/testing on request.

Kind regards
R

--------------050601040604010602010406
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc1+ (root@poppero4) (gcc version 4.7.2 (Ubuntu/Linaro 4.7.2-2ubuntu1) ) #93 SMP PREEMPT Tue Dec 4 12:38:22 CET 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.6.0-rc1+ root=UUID=972c7610-1938-46dd-a5eb-e5c4b73d6c66 ro quiet splash vt.handoff=7
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000ef000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b5bdffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b5be0000-0x00000000b5beffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000b5bf0000-0x00000000b5bf7fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b5bf8000-0x00000000b5bf9fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b5bfa000-0x00000000b99dbfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b99dc000-0x00000000b9bdbfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000b9bdc000-0x00000000b9e92fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b9e93000-0x00000000b9e9afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b9e9b000-0x00000000b9ebefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b9ebf000-0x00000000b9ecefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b9ecf000-0x00000000b9fcefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000b9fcf000-0x00000000b9ffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000b9fff000-0x00000000b9ffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ba000000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Hewlett-Packard HP Compaq 6730b (KU216ET#ABZ)/30DD, BIOS 68PDD Ver. F.16 10/21/2010
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 100000000 mask FC0000000 write-back
[    0.000000]   4 base 0B5BE0000 mask FFFFF0000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xba000 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xb9ffffff]
[    0.000000]  [mem 0x00000000-0xb9ffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0xb9ffffff @ [mem 0x1fa2c000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x13fffffff]
[    0.000000]  [mem 0x100000000-0x13fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x13fffffff @ [mem 0xb9eb9000-0xb9ebefff]
[    0.000000] RAMDISK: [mem 0x36dfa000-0x376f4fff]
[    0.000000] ACPI: RSDP 00000000000f68c0 00024 (v02 HPQOEM)
[    0.000000] ACPI: XSDT 00000000b9ffe120 0008C (v01 HPQOEM SLIC-MPC 0000000F      01000013)
[    0.000000] ACPI: FACP 00000000b9ffc000 000F4 (v03 HPQOEM 30DD     0000000F HP   00000001)
[    0.000000] ACPI: DSDT 00000000b9fdd000 197AD (v01 HPQOEM 30DD     00000001 INTL 20060912)
[    0.000000] ACPI: FACS 00000000b9f9c000 00040
[    0.000000] ACPI: HPET 00000000b9ffb000 00038 (v01 HPQOEM 30DD     00000001 HP   00000001)
[    0.000000] ACPI: APIC 00000000b9ffa000 00084 (v01 HPQOEM 30DD     00000001 HP   00000001)
[    0.000000] ACPI: MCFG 00000000b9ff9000 0003C (v01 HPQOEM 30DD     00000001 HP   00000001)
[    0.000000] ACPI: ASF! 00000000b9ff8000 000A0 (v32 HPQOEM 30DD     00000001 HP   00000001)
[    0.000000] ACPI: TCPA 00000000b9ff7000 00032 (v02 HPQOEM 30DD     00000000 HP   00000001)
[    0.000000] ACPI: SSDT 00000000b9fda000 002DD (v01 HPQOEM SataAhci 00001000 INTL 20060912)
[    0.000000] ACPI: SLIC 00000000b9fd8000 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
[    0.000000] ACPI: SSDT 00000000b9fd7000 00059 (v01 HPQOEM   HPQNLP 00000001 INTL 20060912)
[    0.000000] ACPI: DMAR 00000000b9fd6000 000F8 (v01               ? 00000001      00000000)
[    0.000000] ACPI: SSDT 00000000b9fd5000 0066C (v01  PmRef    CpuPm 00003000 INTL 20060912)
[    0.000000] ACPI: SSDT 00000000b9fd4000 00288 (v01  PmRef  Cpu0Tst 00003000 INTL 20060912)
[    0.000000] ACPI: SSDT 00000000b9fd3000 00225 (v01  PmRef    ApTst 00003000 INTL 20060912)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff88013b600000-ffff88013f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x13fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xb5bdffff]
[    0.000000]   node   0: [mem 0xb5bf0000-0xb5bf7fff]
[    0.000000]   node   0: [mem 0xb5bfa000-0xb99dbfff]
[    0.000000]   node   0: [mem 0xb9bdc000-0xb9e92fff]
[    0.000000]   node   0: [mem 0xb9e9b000-0xb9ebefff]
[    0.000000]   node   0: [mem 0xb9fff000-0xb9ffffff]
[    0.000000]   node   0: [mem 0x100000000-0x13fffffff]
[    0.000000] On node 0 totalpages: 1023029
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 740582 pages, LIFO batch:31
[    0.000000]   Normal zone: 4096 pages used for memmap
[    0.000000]   Normal zone: 258048 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000ef000
[    0.000000] PM: Registered nosave memory: 00000000000ef000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000b5be0000 - 00000000b5bf0000
[    0.000000] PM: Registered nosave memory: 00000000b5bf8000 - 00000000b5bfa000
[    0.000000] PM: Registered nosave memory: 00000000b99dc000 - 00000000b9bdc000
[    0.000000] PM: Registered nosave memory: 00000000b9e93000 - 00000000b9e9b000
[    0.000000] PM: Registered nosave memory: 00000000b9ebf000 - 00000000b9ecf000
[    0.000000] PM: Registered nosave memory: 00000000b9ecf000 - 00000000b9fcf000
[    0.000000] PM: Registered nosave memory: 00000000b9fcf000 - 00000000b9fff000
[    0.000000] PM: Registered nosave memory: 00000000ba000000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88013fc00000 s73472 r8192 d20736 u1048576
[    0.000000] pcpu-alloc: s73472 r8192 d20736 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1002543
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.6.0-rc1+ root=UUID=972c7610-1938-46dd-a5eb-e5c4b73d6c66 ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3937772k/5242880k available (3849k kernel code, 1150764k absent, 154344k reserved, 2134k data, 468k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2393.886 MHz processor
[    0.001003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.77 BogoMIPS (lpj=2393886)
[    0.001006] pid_max: default: 32768 minimum: 301
[    0.001031] Security Framework initialized
[    0.001036] SELinux:  Disabled at boot.
[    0.001048] Mount-cache hash table entries: 256
[    0.001272] Initializing cgroup subsys cpuacct
[    0.001275] Initializing cgroup subsys devices
[    0.001276] Initializing cgroup subsys freezer
[    0.001278] Initializing cgroup subsys net_cls
[    0.002003] Initializing cgroup subsys blkio
[    0.002025] Disabled fast string operations
[    0.002030] CPU: Physical Processor ID: 0
[    0.002031] CPU: Processor Core ID: 0
[    0.002033] mce: CPU supports 6 MCE banks
[    0.002039] CPU0: Thermal monitoring handled by SMI
[    0.002041] process: using mwait in idle threads
[    0.002047] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.002047] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
[    0.002047] tlb_flushall_shift is 0xffffffff
[    0.002063] ACPI: Core revision 20120711
[    0.009470] ..TIMER: vector=0x51 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.019616] smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz stepping 0a
[    0.019996] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.019996] ... version:                2
[    0.019996] ... bit width:              40
[    0.019996] ... generic registers:      2
[    0.019996] ... value mask:             000000ffffffffff
[    0.019996] ... max period:             000000007fffffff
[    0.019996] ... fixed-purpose events:   3
[    0.019996] ... event mask:             0000000700000003
[    0.030999] smpboot: Booting Node   0, Processors  #1 OK
[    0.001999] CPU1: Thermal monitoring handled by SMI
[    0.043017] Brought up 2 CPUs
[    0.043017] smpboot: Total of 2 processors activated (9575.54 BogoMIPS)
[    0.044045] devtmpfs: initialized
[    0.045051] PM: Registering ACPI NVS region [mem 0xb5be0000-0xb5beffff] (65536 bytes)
[    0.045055] PM: Registering ACPI NVS region [mem 0xb99dc000-0xb9bdbfff] (2097152 bytes)
[    0.045099] PM: Registering ACPI NVS region [mem 0xb9ecf000-0xb9fcefff] (1048576 bytes)
[    0.045126] reboot: BIOS series board detected. Selecting HP Compaq Laptop-method for reboots.
[    0.045195] dummy: 
[    0.045227] RTC time: 12:41:12, date: 12/04/12
[    0.045271] NET: Registered protocol family 16
[    0.045465] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.045467] ACPI: bus type pci registered
[    0.045545] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.045548] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.065869] PCI: Using configuration type 1 for base access
[    0.065971] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.065972] mtrr: probably your BIOS does not setup all CPUs.
[    0.065973] mtrr: corrected configuration.
[    0.067114] bio: create slab <bio-0> at 0
[    0.067114] ACPI: Added _OSI(Module Device)
[    0.067114] ACPI: Added _OSI(Processor Device)
[    0.067114] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.067114] ACPI: Added _OSI(Processor Aggregator Device)
[    0.068942] ACPI: EC: Look up EC in DSDT
[    0.080020] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.095352] ACPI: SSDT 00000000b9ec7c18 00275 (v01  PmRef  Cpu0Ist 00003000 INTL 20060912)
[    0.095747] ACPI: Dynamic OEM Table Load:
[    0.095749] ACPI: SSDT           (null) 00275 (v01  PmRef  Cpu0Ist 00003000 INTL 20060912)
[    0.095877] ACPI: SSDT 00000000b9ec5618 0057B (v01  PmRef  Cpu0Cst 00003001 INTL 20060912)
[    0.096261] ACPI: Dynamic OEM Table Load:
[    0.096263] ACPI: SSDT           (null) 0057B (v01  PmRef  Cpu0Cst 00003001 INTL 20060912)
[    0.102225] ACPI: SSDT 00000000b9ec6e18 001D7 (v01  PmRef    ApIst 00003000 INTL 20060912)
[    0.102638] ACPI: Dynamic OEM Table Load:
[    0.102640] ACPI: SSDT           (null) 001D7 (v01  PmRef    ApIst 00003000 INTL 20060912)
[    0.105079] ACPI: SSDT 00000000b9ec7f18 0008D (v01  PmRef    ApCst 00003000 INTL 20060912)
[    0.105472] ACPI: Dynamic OEM Table Load:
[    0.105475] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20060912)
[    0.353982] ACPI: Interpreter enabled
[    0.353986] ACPI: (supports S0 S3 S4 S5)
[    0.354005] ACPI: Using IOAPIC for interrupt routing
[    0.354723] ACPI: Power Resource [APPR] (off)
[    0.364507] ACPI: Power Resource [COMP] (on)
[    0.364862] ACPI: Power Resource [LPP] (on)
[    0.365887] ACPI: Power Resource [PFN0] (off)
[    0.365937] ACPI: Power Resource [PFN1] (off)
[    0.365993] ACPI: Power Resource [PFN2] (off)
[    0.366044] ACPI: Power Resource [PFN3] (off)
[    0.366093] ACPI: Power Resource [PFN4] (off)
[    0.366751] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    0.366959] ACPI: No dock devices found.
[    0.366963] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.367712] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.368301] PCI host bridge to bus 0000:00
[    0.368305] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    0.368307] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.368310] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.368312] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.368315] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.368317] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xdfffffff]
[    0.368319] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfedfffff]
[    0.368321] pci_bus 0000:00: root bus resource [mem 0xfee01000-0xffffffff]
[    0.368331] pci 0000:00:00.0: [8086:2a40] type 00 class 0x060000
[    0.368372] pci 0000:00:02.0: [8086:2a42] type 00 class 0x030000
[    0.368383] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd03fffff 64bit]
[    0.368391] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.368396] pci 0000:00:02.0: reg 20: [io  0x60f0-0x60f7]
[    0.368429] pci 0000:00:02.1: [8086:2a43] type 00 class 0x038000
[    0.368438] pci 0000:00:02.1: reg 10: [mem 0xd0400000-0xd04fffff 64bit]
[    0.368522] pci 0000:00:1a.0: [8086:2937] type 00 class 0x0c0300
[    0.368576] pci 0000:00:1a.0: reg 20: [io  0x60c0-0x60df]
[    0.368643] pci 0000:00:1a.1: [8086:2938] type 00 class 0x0c0300
[    0.368697] pci 0000:00:1a.1: reg 20: [io  0x60a0-0x60bf]
[    0.368764] pci 0000:00:1a.2: [8086:2939] type 00 class 0x0c0300
[    0.368818] pci 0000:00:1a.2: reg 20: [io  0x6080-0x609f]
[    0.368897] pci 0000:00:1a.7: [8086:293c] type 00 class 0x0c0320
[    0.368921] pci 0000:00:1a.7: reg 10: [mem 0xd8906000-0xd89063ff]
[    0.369034] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.369068] pci 0000:00:1b.0: [8086:293e] type 00 class 0x040300
[    0.369087] pci 0000:00:1b.0: reg 10: [mem 0xd8900000-0xd8903fff 64bit]
[    0.369183] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.369211] pci 0000:00:1c.0: [8086:2940] type 01 class 0x060400
[    0.369312] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.369342] pci 0000:00:1c.1: [8086:2942] type 01 class 0x060400
[    0.369443] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.369475] pci 0000:00:1c.2: [8086:2944] type 01 class 0x060400
[    0.369575] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.369607] pci 0000:00:1c.4: [8086:2948] type 01 class 0x060400
[    0.369707] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.369737] pci 0000:00:1c.5: [8086:294a] type 01 class 0x060400
[    0.369836] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.369868] pci 0000:00:1d.0: [8086:2934] type 00 class 0x0c0300
[    0.369922] pci 0000:00:1d.0: reg 20: [io  0x6060-0x607f]
[    0.369995] pci 0000:00:1d.1: [8086:2935] type 00 class 0x0c0300
[    0.370049] pci 0000:00:1d.1: reg 20: [io  0x6040-0x605f]
[    0.370117] pci 0000:00:1d.2: [8086:2936] type 00 class 0x0c0300
[    0.370171] pci 0000:00:1d.2: reg 20: [io  0x6020-0x603f]
[    0.370249] pci 0000:00:1d.7: [8086:293a] type 00 class 0x0c0320
[    0.370272] pci 0000:00:1d.7: reg 10: [mem 0xd8905000-0xd89053ff]
[    0.370381] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.370409] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.370499] pci 0000:00:1f.0: [8086:2919] type 00 class 0x060100
[    0.370662] pci 0000:00:1f.2: [8086:2929] type 00 class 0x010601
[    0.370688] pci 0000:00:1f.2: reg 10: [io  0x60e8-0x60ef]
[    0.370699] pci 0000:00:1f.2: reg 14: [io  0x60fc-0x60ff]
[    0.370710] pci 0000:00:1f.2: reg 18: [io  0x60e0-0x60e7]
[    0.370721] pci 0000:00:1f.2: reg 1c: [io  0x60f8-0x60fb]
[    0.370732] pci 0000:00:1f.2: reg 20: [io  0x6000-0x601f]
[    0.370743] pci 0000:00:1f.2: reg 24: [mem 0xd8904000-0xd89047ff]
[    0.370812] pci 0000:00:1f.2: PME# supported from D3hot
[    0.370889] pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-ff]
[    0.370893] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.370901] pci 0000:00:1c.0:   bridge window [mem 0xd8800000-0xd88fffff]
[    0.370962] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-ff]
[    0.370999] pci 0000:02:00.0: [8086:4237] type 00 class 0x028000
[    0.371036] pci 0000:02:00.0: reg 10: [mem 0xd8700000-0xd8701fff 64bit]
[    0.371232] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.372965] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.372973] pci 0000:00:1c.1:   bridge window [mem 0xd8700000-0xd87fffff]
[    0.373033] pci_bus 0000:03: busn_res: [bus 03-43] is inserted under [bus 00-ff]
[    0.373037] pci 0000:00:1c.2: PCI bridge to [bus 03-43]
[    0.373042] pci 0000:00:1c.2:   bridge window [io  0x4000-0x5fff]
[    0.373047] pci 0000:00:1c.2:   bridge window [mem 0xd4700000-0xd86fffff]
[    0.373106] pci_bus 0000:44: busn_res: [bus 44-84] is inserted under [bus 00-ff]
[    0.373110] pci 0000:00:1c.4: PCI bridge to [bus 44-84]
[    0.373115] pci 0000:00:1c.4:   bridge window [io  0x2000-0x3fff]
[    0.373120] pci 0000:00:1c.4:   bridge window [mem 0xd0700000-0xd46fffff]
[    0.373180] pci_bus 0000:85: busn_res: [bus 85] is inserted under [bus 00-ff]
[    0.373294] pci 0000:85:00.0: [14e4:1693] type 00 class 0x020000
[    0.373357] pci 0000:85:00.0: reg 10: [mem 0xd0600000-0xd060ffff 64bit]
[    0.373772] pci 0000:85:00.0: PME# supported from D3hot D3cold
[    0.373904] pci 0000:00:1c.5: PCI bridge to [bus 85]
[    0.373911] pci 0000:00:1c.5:   bridge window [mem 0xd0600000-0xd06fffff]
[    0.373950] pci_bus 0000:86: busn_res: [bus 86] is inserted under [bus 00-ff]
[    0.373968] pci 0000:86:02.0: [11c1:5811] type 00 class 0x0c0010
[    0.373988] pci 0000:86:02.0: reg 10: [mem 0xd0500000-0xd0500fff]
[    0.374085] pci 0000:86:02.0: supports D1 D2
[    0.374087] pci 0000:86:02.0: PME# supported from D0 D1 D2 D3hot
[    0.374148] pci 0000:00:1e.0: PCI bridge to [bus 86] (subtractive decode)
[    0.374156] pci 0000:00:1e.0:   bridge window [mem 0xd0500000-0xd05fffff]
[    0.374164] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.374166] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.374169] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.374171] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    0.374173] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfedfffff] (subtractive decode)
[    0.374176] pci 0000:00:1e.0:   bridge window [mem 0xfee01000-0xffffffff] (subtractive decode)
[    0.374211] pci_bus 0000:00: on NUMA node 0
[    0.374214] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.374366] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.374407] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.374451] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.374515] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.374578] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.374642] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.375127]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.376354]  pci0000:00: ACPI _OSC control (0x1d) granted
[    0.383620] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.383667] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.383709] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.383751] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.383793] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.383835] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.383877] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.383918] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.383975] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.383975] vgaarb: loaded
[    0.383975] vgaarb: bridge control possible 0000:00:02.0
[    0.384049] SCSI subsystem initialized
[    0.384051] ACPI: bus type scsi registered
[    0.384059] libata version 3.00 loaded.
[    0.384059] ACPI: bus type usb registered
[    0.384059] usbcore: registered new interface driver usbfs
[    0.384059] usbcore: registered new interface driver hub
[    0.384059] usbcore: registered new device driver usb
[    0.384277] wmi: Mapper loaded
[    0.384278] PCI: Using ACPI for IRQ routing
[    0.394303] PCI: pci_cache_line_size set to 64 bytes
[    0.394394] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.394396] e820: reserve RAM buffer [mem 0xb5be0000-0xb7ffffff]
[    0.394398] e820: reserve RAM buffer [mem 0xb5bf8000-0xb7ffffff]
[    0.394400] e820: reserve RAM buffer [mem 0xb99dc000-0xbbffffff]
[    0.394403] e820: reserve RAM buffer [mem 0xb9e93000-0xbbffffff]
[    0.394405] e820: reserve RAM buffer [mem 0xb9ebf000-0xbbffffff]
[    0.394407] e820: reserve RAM buffer [mem 0xba000000-0xbbffffff]
[    0.394514] NetLabel: Initializing
[    0.394516] NetLabel:  domain hash size = 128
[    0.394517] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.394528] NetLabel:  unlabeled traffic allowed by default
[    0.394543] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.394543] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.394543] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.400953] Switching to clocksource hpet
[    0.401003] pnp: PnP ACPI init
[    0.401012] ACPI: bus type pnp registered
[    0.401310] pnp 00:00: [bus 00-ff]
[    0.401313] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.401315] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.401317] pnp 00:00: [io  0x0d00-0xffff window]
[    0.401320] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.401322] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.401324] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.401326] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.401329] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.401331] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.401333] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.401335] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.401337] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.401339] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.401342] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.401344] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.401346] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.401348] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.401350] pnp 00:00: [mem 0xc0000000-0xdfffffff window]
[    0.401353] pnp 00:00: [mem 0xf0000000-0xfedfffff window]
[    0.401355] pnp 00:00: [mem 0xfee01000-0xffffffff window]
[    0.401414] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.401485] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    0.401488] pnp 00:01: [mem 0xfed10000-0xfed13fff]
[    0.401490] pnp 00:01: [mem 0xfed18000-0xfed18fff]
[    0.401492] pnp 00:01: [mem 0xfed19000-0xfed19fff]
[    0.401494] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.401496] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    0.401498] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    0.401500] pnp 00:01: [mem 0xfed45000-0xfed8ffff]
[    0.401538] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.401540] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.401543] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.401546] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.401548] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.401551] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.401554] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.401556] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.401559] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.401878] pnp 00:02: [io  0x0000-0x001f]
[    0.401880] pnp 00:02: [io  0x0081-0x0091]
[    0.401882] pnp 00:02: [io  0x0093-0x009f]
[    0.401884] pnp 00:02: [io  0x00c0-0x00df]
[    0.401887] pnp 00:02: [dma 4]
[    0.401931] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.401940] pnp 00:03: [mem 0xff000000-0xffffffff]
[    0.401981] pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
[    0.402037] pnp 00:04: [io  0xfe00-0xfe0f]
[    0.402039] pnp 00:04: [io  0xfe80-0xfe8f]
[    0.402043] pnp 00:04: [mem 0xfed40000-0xfed44fff]
[    0.402089] pnp 00:04: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.402160] pnp 00:05: [mem 0xfed00000-0xfed003ff]
[    0.402218] system 00:05: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.402222] system 00:05: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.402232] pnp 00:06: [io  0x00f0]
[    0.402237] pnp 00:06: [irq 13]
[    0.402282] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.402293] pnp 00:07: [io  0x002e-0x002f]
[    0.402295] pnp 00:07: [io  0x004e-0x004f]
[    0.402297] pnp 00:07: [io  0x0061]
[    0.402299] pnp 00:07: [io  0x0063]
[    0.402301] pnp 00:07: [io  0x0065]
[    0.402303] pnp 00:07: [io  0x0067]
[    0.402305] pnp 00:07: [io  0x0070]
[    0.402306] pnp 00:07: [io  0x0080]
[    0.402308] pnp 00:07: [io  0x0092]
[    0.402310] pnp 00:07: [io  0x00b2-0x00b3]
[    0.402312] pnp 00:07: [io  0x0200-0x027f]
[    0.402314] pnp 00:07: [io  0x1000-0x1003]
[    0.402316] pnp 00:07: [io  0x1010-0x101f]
[    0.402318] pnp 00:07: [io  0xffff]
[    0.402320] pnp 00:07: [io  0x0400-0x047f]
[    0.402322] pnp 00:07: [io  0x0500-0x057f]
[    0.402324] pnp 00:07: [io  0xef80-0xef9f]
[    0.402389] system 00:07: [io  0x0200-0x027f] has been reserved
[    0.402392] system 00:07: [io  0x1000-0x1003] has been reserved
[    0.402395] system 00:07: [io  0x1010-0x101f] has been reserved
[    0.402397] system 00:07: [io  0xffff] has been reserved
[    0.402400] system 00:07: [io  0x0400-0x047f] has been reserved
[    0.402402] system 00:07: [io  0x0500-0x057f] has been reserved
[    0.402405] system 00:07: [io  0xef80-0xef9f] has been reserved
[    0.402408] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.402416] pnp 00:08: [io  0x0070-0x0077]
[    0.402419] pnp 00:08: [irq 8]
[    0.402465] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.402834] pnp 00:09: [io  0x03f8-0x03ff]
[    0.402837] pnp 00:09: [irq 4]
[    0.402907] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.403283] pnp 00:0a: [io  0x0378-0x037f]
[    0.403286] pnp 00:0a: [io  0x0778-0x077a]
[    0.403289] pnp 00:0a: [irq 5]
[    0.403291] pnp 00:0a: [dma 0 disabled]
[    0.403406] pnp 00:0a: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.403416] pnp 00:0b: [io  0x0060]
[    0.403418] pnp 00:0b: [io  0x0064]
[    0.403421] pnp 00:0b: [irq 1]
[    0.403467] pnp 00:0b: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.403477] pnp 00:0c: [irq 12]
[    0.403524] pnp 00:0c: Plug and Play ACPI device, IDs SYN0141 SYN0100 SYN0002 PNP0f13 (active)
[    0.403556] pnp 00:0d: [irq 23]
[    0.403605] pnp 00:0d: Plug and Play ACPI device, IDs HPQ0004 (active)
[    0.403733] pnp: PnP ACPI: found 14 devices
[    0.403735] ACPI: ACPI bus type pnp unregistered
[    0.410396] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
[    0.410400] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000
[    0.410411] pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[    0.410415] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.410426] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03-43] add_size 200000
[    0.410437] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 44-84] add_size 200000
[    0.410447] pci 0000:00:1c.5: bridge window [io  0x1000-0x0fff] to [bus 85] add_size 1000
[    0.410451] pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 85] add_size 200000
[    0.410466] pci 0000:00:1c.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.410469] pci 0000:00:1c.1: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.410472] pci 0000:00:1c.2: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.410474] pci 0000:00:1c.4: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.410477] pci 0000:00:1c.5: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.410480] pci 0000:00:1c.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.410482] pci 0000:00:1c.1: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.410485] pci 0000:00:1c.5: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.410490] pci 0000:00:1c.0: BAR 9: assigned [mem 0xd8a00000-0xd8bfffff 64bit pref]
[    0.410494] pci 0000:00:1c.1: BAR 9: assigned [mem 0xd8c00000-0xd8dfffff 64bit pref]
[    0.410498] pci 0000:00:1c.2: BAR 9: assigned [mem 0xd8e00000-0xd8ffffff 64bit pref]
[    0.410503] pci 0000:00:1c.4: BAR 9: assigned [mem 0xd9000000-0xd91fffff 64bit pref]
[    0.410507] pci 0000:00:1c.5: BAR 9: assigned [mem 0xd9200000-0xd93fffff 64bit pref]
[    0.410510] pci 0000:00:1c.0: BAR 7: assigned [io  0x7000-0x7fff]
[    0.410513] pci 0000:00:1c.1: BAR 7: assigned [io  0x8000-0x8fff]
[    0.410517] pci 0000:00:1c.5: BAR 7: assigned [io  0x9000-0x9fff]
[    0.410520] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.410524] pci 0000:00:1c.0:   bridge window [io  0x7000-0x7fff]
[    0.410530] pci 0000:00:1c.0:   bridge window [mem 0xd8800000-0xd88fffff]
[    0.410535] pci 0000:00:1c.0:   bridge window [mem 0xd8a00000-0xd8bfffff 64bit pref]
[    0.410542] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.410546] pci 0000:00:1c.1:   bridge window [io  0x8000-0x8fff]
[    0.410552] pci 0000:00:1c.1:   bridge window [mem 0xd8700000-0xd87fffff]
[    0.410557] pci 0000:00:1c.1:   bridge window [mem 0xd8c00000-0xd8dfffff 64bit pref]
[    0.410564] pci 0000:00:1c.2: PCI bridge to [bus 03-43]
[    0.410568] pci 0000:00:1c.2:   bridge window [io  0x4000-0x5fff]
[    0.410573] pci 0000:00:1c.2:   bridge window [mem 0xd4700000-0xd86fffff]
[    0.410578] pci 0000:00:1c.2:   bridge window [mem 0xd8e00000-0xd8ffffff 64bit pref]
[    0.410586] pci 0000:00:1c.4: PCI bridge to [bus 44-84]
[    0.410589] pci 0000:00:1c.4:   bridge window [io  0x2000-0x3fff]
[    0.410595] pci 0000:00:1c.4:   bridge window [mem 0xd0700000-0xd46fffff]
[    0.410600] pci 0000:00:1c.4:   bridge window [mem 0xd9000000-0xd91fffff 64bit pref]
[    0.410608] pci 0000:00:1c.5: PCI bridge to [bus 85]
[    0.410611] pci 0000:00:1c.5:   bridge window [io  0x9000-0x9fff]
[    0.410617] pci 0000:00:1c.5:   bridge window [mem 0xd0600000-0xd06fffff]
[    0.410622] pci 0000:00:1c.5:   bridge window [mem 0xd9200000-0xd93fffff 64bit pref]
[    0.410630] pci 0000:00:1e.0: PCI bridge to [bus 86]
[    0.410636] pci 0000:00:1e.0:   bridge window [mem 0xd0500000-0xd05fffff]
[    0.410682] pci 0000:00:1e.0: setting latency timer to 64
[    0.410686] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.410689] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.410691] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.410693] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xdfffffff]
[    0.410695] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfedfffff]
[    0.410698] pci_bus 0000:00: resource 9 [mem 0xfee01000-0xffffffff]
[    0.410700] pci_bus 0000:01: resource 0 [io  0x7000-0x7fff]
[    0.410702] pci_bus 0000:01: resource 1 [mem 0xd8800000-0xd88fffff]
[    0.410705] pci_bus 0000:01: resource 2 [mem 0xd8a00000-0xd8bfffff 64bit pref]
[    0.410707] pci_bus 0000:02: resource 0 [io  0x8000-0x8fff]
[    0.410709] pci_bus 0000:02: resource 1 [mem 0xd8700000-0xd87fffff]
[    0.410712] pci_bus 0000:02: resource 2 [mem 0xd8c00000-0xd8dfffff 64bit pref]
[    0.410714] pci_bus 0000:03: resource 0 [io  0x4000-0x5fff]
[    0.410716] pci_bus 0000:03: resource 1 [mem 0xd4700000-0xd86fffff]
[    0.410718] pci_bus 0000:03: resource 2 [mem 0xd8e00000-0xd8ffffff 64bit pref]
[    0.410721] pci_bus 0000:44: resource 0 [io  0x2000-0x3fff]
[    0.410723] pci_bus 0000:44: resource 1 [mem 0xd0700000-0xd46fffff]
[    0.410725] pci_bus 0000:44: resource 2 [mem 0xd9000000-0xd91fffff 64bit pref]
[    0.410727] pci_bus 0000:85: resource 0 [io  0x9000-0x9fff]
[    0.410730] pci_bus 0000:85: resource 1 [mem 0xd0600000-0xd06fffff]
[    0.410732] pci_bus 0000:85: resource 2 [mem 0xd9200000-0xd93fffff 64bit pref]
[    0.410734] pci_bus 0000:86: resource 1 [mem 0xd0500000-0xd05fffff]
[    0.410737] pci_bus 0000:86: resource 4 [io  0x0000-0x0cf7]
[    0.410739] pci_bus 0000:86: resource 5 [io  0x0d00-0xffff]
[    0.410741] pci_bus 0000:86: resource 6 [mem 0x000a0000-0x000bffff]
[    0.410743] pci_bus 0000:86: resource 7 [mem 0xc0000000-0xdfffffff]
[    0.410745] pci_bus 0000:86: resource 8 [mem 0xf0000000-0xfedfffff]
[    0.410748] pci_bus 0000:86: resource 9 [mem 0xfee01000-0xffffffff]
[    0.410778] NET: Registered protocol family 2
[    0.410939] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.412550] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.413058] TCP: Hash tables configured (established 262144 bind 65536)
[    0.413125] TCP: reno registered
[    0.413129] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.413162] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.413275] NET: Registered protocol family 1
[    0.413298] pci 0000:00:02.0: Boot video device
[    0.413661] PCI: CLS 64 bytes, default 64
[    0.413711] Trying to unpack rootfs image as initramfs...
[    0.586799] Freeing initrd memory: 9196k freed
[    0.591075] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.591083] software IO TLB [mem 0xb1be0000-0xb5bdffff] (64MB) mapped at [ffff8800b1be0000-ffff8800b5bdffff]
[    0.591456] audit: initializing netlink socket (disabled)
[    0.591472] type=2000 audit(1354624872.590:1): initialized
[    0.591738] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.593386] VFS: Disk quotas dquot_6.5.2
[    0.593431] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.593878] fuse init (API version 7.19)
[    0.593965] msgmni has been set to 7708
[    0.594230] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.594232] io scheduler noop registered
[    0.594234] io scheduler deadline registered (default)
[    0.594643] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
[    0.594645] crc32: self tests passed, processed 225944 bytes in 199747 nsec
[    0.594851] crc32c: CRC_LE_BITS = 64
[    0.594852] crc32c: self tests passed, processed 225944 bytes in 100571 nsec
[    0.594986] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.595147] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.595290] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    0.595434] pcieport 0000:00:1c.4: irq 43 for MSI/MSI-X
[    0.595578] pcieport 0000:00:1c.5: irq 44 for MSI/MSI-X
[    0.595734] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.595740] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.595760] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    0.595763] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    0.595768] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    0.595787] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    0.595792] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
[    0.595811] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    0.595816] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    0.595836] pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
[    0.595838] pci 0000:85:00.0: Signaling PME through PCIe PME interrupt
[    0.595843] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
[    0.595874] intel_idle: does not run on family 6 model 23
[    0.596045] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.596263] ACPI: AC Adapter [AC] (on-line)
[    0.596341] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    0.596346] ACPI: Sleep Button [SLPB]
[    0.596385] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    0.596426] ACPI: Lid Switch [LID]
[    0.596467] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.596470] ACPI: Power Button [PWRF]
[    0.596553] ACPI: Fan [FAN0] (off)
[    0.596599] ACPI: Fan [FAN1] (off)
[    0.596644] ACPI: Fan [FAN2] (off)
[    0.596687] ACPI: Fan [FAN3] (off)
[    0.596732] ACPI: Fan [FAN4] (off)
[    0.596945] ACPI: Requesting acpi_cpufreq
[    0.599831] Monitor-Mwait will be used to enter C-1 state
[    0.599856] Monitor-Mwait will be used to enter C-2 state
[    0.599862] tsc: Marking TSC unstable due to TSC halts in idle
[    0.599871] ACPI: acpi_idle registered with cpuidle
[    0.613229] thermal LNXTHERM:00: registered as thermal_zone0
[    0.613231] ACPI: Thermal Zone [DTSZ] (50 C)
[    0.619794] thermal LNXTHERM:01: registered as thermal_zone1
[    0.619797] ACPI: Thermal Zone [CPUZ] (49 C)
[    0.622652] thermal LNXTHERM:02: registered as thermal_zone2
[    0.622654] ACPI: Thermal Zone [SKNZ] (42 C)
[    0.884537] thermal LNXTHERM:03: registered as thermal_zone3
[    0.884539] ACPI: Thermal Zone [BATZ] (28 C)
[    0.891322] thermal LNXTHERM:04: registered as thermal_zone4
[    0.891324] ACPI: Thermal Zone [FDTZ] (24 C)
[    0.891426] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.912096] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.933074] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.933336] Linux agpgart interface v0.103
[    0.933398] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    0.933469] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.934489] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    0.934604] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    0.934646] [drm] Initialized drm 1.1.0 20060810
[    0.935846] brd: module loaded
[    0.936554] loop: module loaded
[    0.936732] ahci 0000:00:1f.2: version 3.0
[    0.936793] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    0.936841] ahci: SSS flag set, parallel bus scan disabled
[    0.936874] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x23 impl SATA mode
[    0.936878] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems sxs 
[    0.936883] ahci 0000:00:1f.2: setting latency timer to 64
[    0.941482] scsi0 : ahci
[    0.941558] scsi1 : ahci
[    0.941622] scsi2 : ahci
[    0.941683] scsi3 : ahci
[    0.941745] scsi4 : ahci
[    0.941803] scsi5 : ahci
[    0.941843] ata1: SATA max UDMA/133 abar m2048@0xd8904000 port 0xd8904100 irq 45
[    0.941846] ata2: SATA max UDMA/133 abar m2048@0xd8904000 port 0xd8904180 irq 45
[    0.941848] ata3: DUMMY
[    0.941849] ata4: DUMMY
[    0.941850] ata5: DUMMY
[    0.941853] ata6: SATA max UDMA/133 abar m2048@0xd8904000 port 0xd8904380 irq 45
[    0.942552] tun: Universal TUN/TAP device driver, 1.6
[    0.942554] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.942642] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.942669] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.942672] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.942705] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.946618] ehci_hcd 0000:00:1a.7: debug port 1
[    0.946627] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    0.946643] ehci_hcd 0000:00:1a.7: irq 19, io mem 0xd8906000
[    0.952015] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.952143] hub 1-0:1.0: USB hub found
[    0.952148] hub 1-0:1.0: 6 ports detected
[    0.952224] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.952227] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.952263] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.956264] ehci_hcd 0000:00:1d.7: debug port 1
[    0.956307] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    0.956370] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xd8905000
[    0.959694] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.959700] ACPI: Battery Slot [BAT0] (battery present)
[    0.959754] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.959759] ACPI: Battery Slot [BAT1] (battery absent)
[    0.962017] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.962126] hub 2-0:1.0: USB hub found
[    0.962130] hub 2-0:1.0: 6 ports detected
[    0.962195] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.962208] uhci_hcd: USB Universal Host Controller Interface driver
[    0.962226] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.962230] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.962264] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.962299] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000060c0
[    0.962428] hub 3-0:1.0: USB hub found
[    0.962432] hub 3-0:1.0: 2 ports detected
[    0.962494] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.962498] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.962530] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.962564] uhci_hcd 0000:00:1a.1: irq 17, io base 0x000060a0
[    0.962687] hub 4-0:1.0: USB hub found
[    0.962691] hub 4-0:1.0: 2 ports detected
[    0.962752] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    0.962756] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    0.962791] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    0.962827] uhci_hcd 0000:00:1a.2: irq 18, io base 0x00006080
[    0.962950] hub 5-0:1.0: USB hub found
[    0.962953] hub 5-0:1.0: 2 ports detected
[    0.963022] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.963026] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.963059] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    0.963085] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006060
[    0.963210] hub 6-0:1.0: USB hub found
[    0.963214] hub 6-0:1.0: 2 ports detected
[    0.963277] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.963281] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.963315] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    0.963350] uhci_hcd 0000:00:1d.1: irq 22, io base 0x00006040
[    0.963471] hub 7-0:1.0: USB hub found
[    0.963475] hub 7-0:1.0: 2 ports detected
[    0.963534] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.963537] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.963573] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    0.963599] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006020
[    0.963721] hub 8-0:1.0: USB hub found
[    0.963724] hub 8-0:1.0: 2 ports detected
[    0.963838] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.965475] i8042: Detected active multiplexing controller, rev 1.1
[    0.966144] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.966170] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.966190] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.966211] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.966230] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.966314] mousedev: PS/2 mouse device common for all mice
[    0.966448] rtc_cmos 00:08: RTC can wake from S4
[    0.966577] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    0.966604] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.966645] cpuidle: using governor ladder
[    0.966682] cpuidle: using governor menu
[    0.966751] hp_accel: hardware type NC6730b found
[    0.967304] lis3lv02d: 8 bits sensor found
[    0.988753] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.003228] input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input4
[    1.003396] Registered led device: hp::hddprotect
[    1.003406] hp_accel: driver loaded
[    1.003534] TCP: cubic registered
[    1.003634] NET: Registered protocol family 10
[    1.003806] NET: Registered protocol family 17
[    1.003817] Key type dns_resolver registered
[    1.004175] PM: Hibernation image not present or could not be loaded.
[    1.004183] registered taskstats version 1
[    1.004692]   Magic number: 8:740:682
[    1.004824] rtc_cmos 00:08: setting system clock to 2012-12-04 12:41:13 UTC (1354624873)
[    1.005340] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.005341] EDD information not available.
[    1.246213] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.247739] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.248082] ata1.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[    1.248086] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.249988] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.250306] ata1.00: configured for UDMA/133
[    1.250485] scsi 0:0:0:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[    1.250635] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.250651] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.250674] sd 0:0:0:0: [sda] Write Protect is off
[    1.250677] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.250694] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.293442]  sda: sda1 sda2 < sda5 sda6 > sda3
[    1.294028] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.356203] usb 1-4: new high-speed USB device number 3 using ehci_hcd
[    1.470764] hub 1-4:1.0: USB hub found
[    1.470831] hub 1-4:1.0: 4 ports detected
[    1.555190] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.559445] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.559448] ata2.00: ATAPI: HL-DT-ST DVDRAM GT20L, DC03, max UDMA/100
[    1.564275] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.564279] ata2.00: configured for UDMA/100
[    1.569578] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GT20L     DC03 PQ: 0 ANSI: 5
[    1.573054] usb 1-5: new high-speed USB device number 4 using ehci_hcd
[    1.574534] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.574537] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.574684] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.574776] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.250734] ACPI: Invalid Power Resource to register!
[    1.574887] ACPI: Invalid Power Resource to register!<6>[    1.879076] ata6: SATA link down (SStatus 0 SControl 300)
[    1.879716] Freeing unused kernel memory: 468k freed
[    1.894641] udevd[80]: starting version 175
[    1.934060] usb 4-1: new full-speed USB device number 2 using uhci_hcd
[    1.947653] i915 0000:00:02.0: setting latency timer to 64
[    1.971385] firewire_ohci 0000:86:02.0: setting latency timer to 64
[    1.972877] tg3.c:v3.124 (March 21, 2012)
[    2.011327] tg3 0000:85:00.0: eth0: Tigon3 [partno(BCM95751) rev b002] (PCI Express) MAC address 00:24:81:64:3c:e3
[    2.011332] tg3 0000:85:00.0: eth0: attached PHY is 5787 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    2.011336] tg3 0000:85:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    2.011338] tg3 0000:85:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    2.022107] firewire_ohci 0000:86:02.0: added OHCI v1.0 device as card 0, 8 IR + 8 IT contexts, quirks 0x0
[    2.031032] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[    2.031042] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.031043] [drm] Driver supports precise vblank timestamp query.
[    2.031086] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.271124] usb 1-4.1: new full-speed USB device number 5 using ehci_hcd
[    2.430140] usb 1-4.2: new low-speed USB device number 6 using ehci_hcd
[    2.523088] firewire_core 0000:86:02.0: created device fw0: GUID 5566779911223355, S400
[    2.526226] input: PS/2+USB Mouse as /devices/pci0000:00/0000:00:1a.7/usb1/1-4/1-4.2/1-4.2:1.0/input/input5
[    2.526319] hid-generic 0003:1267:0213.0001: input,hidraw0: USB HID v1.11 Mouse [PS/2+USB Mouse] on usb-0000:00:1a.7-4.2/input0
[    2.526338] usbcore: registered new interface driver usbhid
[    2.526339] usbhid: USB HID core driver
[    2.544984] fbcon: inteldrmfb (fb0) is primary device
[    2.866099] Console: switching to colour frame buffer device 160x64
[    2.871167] fb0: inteldrmfb frame buffer device
[    2.871169] drm: registered panic notifier
[    2.876411] ACPI Exception: AE_AML_PACKAGE_LIMIT, Index (0x0000000000000005) is beyond end of object (20120711/exoparg2-418)
[    2.876419] ACPI Error: Method parse/execution failed [\_SB_.PCI0.GFX0._DOD] (Node ffff88013b02a2f8), AE_AML_PACKAGE_LIMIT (20120711/psparse-536)
[    2.876427] ACPI Exception: AE_AML_PACKAGE_LIMIT, Evaluating _DOD (20120711/video-1149)
[    2.876432] video: probe of LNXVIDEO:00 failed with error 12299
[    2.876476] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.688295] Btrfs loaded
[    3.794380] EXT4-fs (sda5): INFO: recovery required on readonly filesystem
[    3.794384] EXT4-fs (sda5): write access will be enabled during recovery
[    4.566996] EXT4-fs (sda5): recovery complete
[    4.577918] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[    9.399660] Adding 2859532k swap on /dev/sda6.  Priority:-1 extents:1 across:2859532k 
[   12.182609] udevd[583]: starting version 175
[   13.345779] EXT4-fs (sda5): re-mounted. Opts: errors=remount-ro,user_xattr
[   14.752456] cfg80211: Calling CRDA to update world regulatory domain
[   14.915418] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
[   14.948998] tpm_tis 00:04: 1.2 TPM (device-id 0xB, rev-id 16)
[   15.009099] tpm_tis 00:04: Adjusting TPM timeout parameters.
[   15.062119] input: HP WMI hotkeys as /devices/virtual/input/input6
[   15.090741] Intel(R) Wireless WiFi driver for Linux, in-tree:
[   15.090744] Copyright(c) 2003-2012 Intel Corporation
[   15.090815] iwlwifi 0000:02:00.0: pci_resource_len = 0x00002000
[   15.090817] iwlwifi 0000:02:00.0: pci_resource_base = ffffc90000058000
[   15.090819] iwlwifi 0000:02:00.0: HW Revision ID = 0x0
[   15.090900] iwlwifi 0000:02:00.0: irq 47 for MSI/MSI-X
[   15.368627] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[   15.377668] microcode: CPU1 sig=0x1067a, pf=0x80, revision=0xa07
[   15.379303] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   15.433430] usbcore: registered new interface driver usbserial
[   15.433825] usbcore: registered new interface driver usbserial_generic
[   15.434235] USB Serial support registered for generic
[   15.434243] usbserial: USB Serial Driver core
[   15.469806] usbcore: registered new interface driver pl2303
[   15.470241] USB Serial support registered for pl2303
[   15.470266] pl2303 1-4.1:1.0: pl2303 converter detected
[   15.473817] usb 1-4.1: pl2303 converter now attached to ttyUSB0
[   15.577242] iwlwifi 0000:02:00.0: loaded firmware version 8.83.5.1 build 33692
[   15.681298] ip_tables: (C) 2000-2006 Netfilter Core Team
[   15.749795] iwldvm: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   15.749799] iwldvm: Copyright(c) 2003-2012 Intel Corporation
[   15.749832] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG disabled
[   15.749834] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   15.749837] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[   15.749839] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
[   15.749841] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_P2P disabled
[   15.749843] iwlwifi 0000:02:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   15.749906] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[   15.750284] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
[   15.753752] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
[   15.762078] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   15.776514] iwlwifi 0000:02:00.0: device EEPROM VER=0x11f, CALIB=0x4
[   15.776518] iwlwifi 0000:02:00.0: Device SKU: 0xF0
[   15.776520] iwlwifi 0000:02:00.0: Valid Tx ant: 0x2, Valid Rx ant: 0x3
[   15.776883] Registered led device: phy0-led
[   15.828708] psmouse serio4: synaptics: Touchpad model: 1, fw: 7.0, id: 0x1c0b1, caps: 0xd04711/0xa00000/0x20000, board id: 3655, fw id: 470319
[   15.842272] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   15.875250] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input8
[   15.955806] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   17.481176] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: errors=remount-ro,user_xattr
[   18.017320] init: failsafe main process (1137) killed by TERM signal
[   23.969916] Bluetooth: Core ver 2.16
[   23.969929] NET: Registered protocol family 31
[   23.969930] Bluetooth: HCI device and connection manager initialized
[   23.969932] Bluetooth: HCI socket layer initialized
[   23.969934] Bluetooth: L2CAP socket layer initialized
[   23.969935] Bluetooth: SCO socket layer initialized
[   24.075173] Bluetooth: RFCOMM TTY layer initialized
[   24.075177] Bluetooth: RFCOMM socket layer initialized
[   24.075179] Bluetooth: RFCOMM ver 1.11
[   24.315287] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   24.315298] Bluetooth: BNEP filters: protocol multicast
[   27.939689] tg3 0000:85:00.0: irq 49 for MSI/MSI-X
[   27.969705] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   29.559190] tg3 0000:85:00.0: eth0: Link is up at 100 Mbps, full duplex
[   29.559194] tg3 0000:85:00.0: eth0: Flow control is off for TX and off for RX
[   29.559214] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   30.345598] nf_conntrack: automatic helper assignment is deprecated and it will be removed soon. Use the iptables CT target to attach helpers instead.
[   32.732954] vboxdrv: Found 2 processor cores.
[   32.733382] vboxdrv: fAsync=0 offMin=0x195 offMax=0x759
[   32.733800] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   32.733802] vboxdrv: Successfully loaded version 4.2.4 (interface 0x001a0004).
[   32.988198] vboxpci: pci-stub module not available, cannot detach PCI devices
[   32.988201] vboxpci: IOMMU not found (not compiled)
[   33.420039] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[   35.876643] init: plymouth-stop pre-start process (2025) terminated with status 1
[  110.985245] tg3 0000:85:00.0: wake-up capability enabled by ACPI
[  113.097253] PM: Syncing filesystems ... done.
[  113.469488] PM: Preparing system for mem sleep
[  113.598244] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  113.609073] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  113.620092] PM: Entering mem sleep
[  113.620256] Suspending console(s) (use no_console_suspend to debug)
[  113.620754] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  113.621063] sd 0:0:0:0: [sda] Stopping disk
[  113.663979] serial 00:09: disabled
[  113.730144] ACPI handle has no context!
[  113.943054] snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D3
[  114.630233] PM: suspend of devices complete after 1009.648 msecs
[  114.630235] PM: suspend devices took 1.010 seconds
[  114.630381] PM: late suspend of devices complete after 0.143 msecs
[  114.641139] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[  114.652122] uhci_hcd 0000:00:1d.2: wake-up capability enabled by ACPI
[  114.652222] uhci_hcd 0000:00:1d.1: wake-up capability enabled by ACPI
[  114.652320] uhci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
[  114.652361] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[  114.663119] uhci_hcd 0000:00:1a.2: wake-up capability enabled by ACPI
[  114.663220] uhci_hcd 0000:00:1a.1: wake-up capability enabled by ACPI
[  114.663321] uhci_hcd 0000:00:1a.0: wake-up capability enabled by ACPI
[  114.663365] PM: noirq suspend of devices complete after 32.982 msecs
[  114.663723] ACPI: Preparing to enter system sleep state S3
[  114.669147] PM: Saving platform NVS memory
[  114.689354] Disabling non-boot CPUs ...
[  114.690603] smpboot: CPU 1 is now offline
[  114.691152] Extended CMOS year: 2000
[  114.691152] ACPI: Low-level resume complete
[  114.691152] PM: Restoring platform NVS memory
[  114.691152] Extended CMOS year: 2000
[  114.691152] CPU0: Thermal monitoring handled by SMI
[  114.691152] Enabling non-boot CPUs ...
[  114.693298] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  114.690003] Disabled fast string operations
[  114.690003] CPU1: Thermal monitoring handled by SMI
[  114.705025] CPU1 is up
[  114.707691] ACPI: Waking up from system sleep state S3
[  114.763137] uhci_hcd 0000:00:1a.0: wake-up capability disabled by ACPI
[  114.763222] uhci_hcd 0000:00:1a.1: wake-up capability disabled by ACPI
[  114.763307] uhci_hcd 0000:00:1a.2: wake-up capability disabled by ACPI
[  114.774067] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[  114.779026] snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D0
[  114.790514] uhci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
[  114.790595] uhci_hcd 0000:00:1d.1: wake-up capability disabled by ACPI
[  114.790675] uhci_hcd 0000:00:1d.2: wake-up capability disabled by ACPI
[  114.801066] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[  114.845218] PM: noirq resume of devices complete after 92.394 msecs
[  114.845333] PM: early resume of devices complete after 0.067 msecs
[  114.845355] i915 0000:00:02.0: setting latency timer to 64
[  114.845363] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  114.845389] usb usb3: root hub lost power or was reset
[  114.845408] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[  114.845434] usb usb4: root hub lost power or was reset
[  114.845451] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[  114.845476] usb usb5: root hub lost power or was reset
[  114.845494] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[  114.845565] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[  114.845733] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  114.845758] usb usb6: root hub lost power or was reset
[  114.845773] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  114.845798] usb usb7: root hub lost power or was reset
[  114.845812] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  114.845838] usb usb8: root hub lost power or was reset
[  114.845854] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  114.845875] pci 0000:00:1e.0: setting latency timer to 64
[  114.845888] ahci 0000:00:1f.2: setting latency timer to 64
[  114.845927] tg3 0000:85:00.0: wake-up capability disabled by ACPI
[  114.845932] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
[  115.157054] ata6: SATA link down (SStatus 0 SControl 300)
[  115.159056] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  115.161074] usb 4-1: reset full-speed USB device number 2 using uhci_hcd
[  115.162829] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  115.167639] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  115.167642] ata2.00: configured for UDMA/100
[  115.397062] firewire_core 0000:86:02.0: rediscovered device fw0
[  115.982214] serial 00:09: activated
[  119.082042] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  119.105333] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  119.107723] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  119.108055] ata1.00: configured for UDMA/133
[  119.119089] sd 0:0:0:0: [sda] Starting disk
[  119.120892] Extended CMOS year: 2000
[  119.402197] PM: resume of devices complete after 4556.861 msecs
[  119.402370] PM: resume devices took 4.557 seconds
[  119.402410] PM: Finishing wakeup.
[  119.402411] Restarting tasks ... done.
[  119.944432] tg3 0000:85:00.0: irq 49 for MSI/MSI-X
[  119.976480] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[  121.561477] tg3 0000:85:00.0: eth0: Link is up at 100 Mbps, full duplex
[  121.561482] tg3 0000:85:00.0: eth0: Flow control is off for TX and off for RX
[  121.561501] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

--------------050601040604010602010406--
