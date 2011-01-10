Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1AJKyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:54:39 -0500
Received: from shutemov.name ([188.40.19.243]:56325 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab1AJKyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:54:35 -0500
Date: Mon, 10 Jan 2011 12:54:33 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: BUG: sleeping function called from invalid context at mm/slub.c:793
Message-ID: <20110110105433.GA17881@shutemov.name>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Every time I run qemu with KVM enabled I get this in dmesg:

[  182.878328] BUG: sleeping function called from invalid context at mm/slub.c:793
[  182.878339] in_atomic(): 1, irqs_disabled(): 0, pid: 4992, name: qemu
[  182.878355] Pid: 4992, comm: qemu Not tainted 2.6.37+ #31
[  182.878361] Call Trace:
[  182.878381]  [<c104e317>] ? __might_sleep+0xd0/0xd7
[  182.878394]  [<c10ec337>] ? slab_pre_alloc_hook.clone.39+0x23/0x27
[  182.878404]  [<c10ece27>] ? kmem_cache_alloc+0x22/0xc8
[  182.878414]  [<c1030221>] ? init_fpu+0x44/0x7b
[  182.878426]  [<c130cc29>] ? do_device_not_available+0x0/0x1b
[  182.878435]  [<c1030221>] ? init_fpu+0x44/0x7b
[  182.878444]  [<c102a588>] ? math_state_restore+0x24/0x47
[  182.878453]  [<c130cc39>] ? do_device_not_available+0x10/0x1b
[  182.878462]  [<c130c4ab>] ? error_code+0x67/0x6c
[  182.878475]  [<c1012340>] ? kvm_load_guest_fpu+0xa1/0xaa
[  182.878484]  [<c1013364>] ? kvm_arch_vcpu_ioctl_run+0x798/0xbe8
[  182.878496]  [<c1004523>] ? kvm_vcpu_ioctl+0x105/0x46e
[  182.878508]  [<c107dce0>] ? get_futex_key+0x73/0x132
[  182.878517]  [<c107e352>] ? futex_wake+0xb6/0xc0
[  182.878527]  [<c107f8d6>] ? do_futex+0x87/0x669
[  182.878535]  [<c100441e>] ? kvm_vcpu_ioctl+0x0/0x46e
[  182.878545]  [<c1101ebf>] ? do_vfs_ioctl+0x4a0/0x4d1
[  182.878554]  [<c130e348>] ? do_page_fault+0x2eb/0x316
[  182.878564]  [<c1101f36>] ? sys_ioctl+0x46/0x68
[  182.878572]  [<c130bdc0>] ? syscall_call+0x7/0xb
[  182.878585]  [<c1300000>] ? aer_probe+0x1da/0x274

.config and dmesg attached.

-- 
 Kirill A. Shutemov

--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii; name=dmesg
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37+ (kas@t400.shutemov.name) (gcc version 4.5.1 20101130 (ALT Linux 4.5.1-alt7) (GCC) ) #31 SMP PREEMPT Mon Jan 10 12:24:56 EET 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf5a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bf5a1000 - 00000000bf5a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf5a7000 - 00000000bf6b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bf6b7000 - 00000000bf70f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf70f000 - 00000000bf7c6000 (usable)
[    0.000000]  BIOS-e820: 00000000bf7c6000 - 00000000bf7d1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7d1000 - 00000000bf7d4000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf7d4000 - 00000000bf7d8000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf7d8000 - 00000000bf7dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7dc000 - 00000000bf7df000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf7df000 - 00000000bf806000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf806000 - 00000000bf808000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf808000 - 00000000bfa0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bfa0f000 - 00000000bfa9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfa9f000 - 00000000bfaff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfaff000 - 00000000bfb00000 (usable)
[    0.000000]  BIOS-e820: 00000000bfe00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI present.
[    0.000000] DMI: 2767BC8/2767BC8, BIOS 7UET89WW (3.19 ) 08/02/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0xbfb00 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 100000000 mask FC0000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 5056MB, range: 64MB, type UC
[    0.000000] reg 1, base: 0GB, range: 2GB, type WB
[    0.000000] reg 2, base: 2GB, range: 1GB, type WB
[    0.000000] reg 3, base: 4GB, range: 1GB, type WB
[    0.000000] total RAM covered: 4032M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 4  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 4GB, range: 1GB, type WB
[    0.000000] reg 3, base: 5056MB, range: 64MB, type UC
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 1bfb000-1c00000
[    0.000000] RAMDISK: 7f117000 - 80000000
[    0.000000] Allocated new RAMDISK: 36915000 - 377fd49a
[    0.000000] Move RAMDISK from 000000007f117000 - 000000007ffff499 to 36915000 - 377fd499
[    0.000000] ACPI: RSDP 000f6440 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT bfa49b5a 0009C (v01 LENOVO TP-7U    00003190  LTP 00000000)
[    0.000000] ACPI: FACP bfa49d00 000F4 (v03 LENOVO TP-7U    00003190 LNVO 00000001)
[    0.000000] ACPI: DSDT bfa4a10e 0FAE1 (v01 LENOVO TP-7U    00003190 MSFT 03000000)
[    0.000000] ACPI: FACS bfa8e000 00040
[    0.000000] ACPI: SSDT bfa49eb4 0025A (v01 LENOVO TP-7U    00003190 MSFT 03000000)
[    0.000000] ACPI: ECDT bfa59bef 00052 (v01 LENOVO TP-7U    00003190 LNVO 00000001)
[    0.000000] ACPI: APIC bfa59c41 00078 (v01 LENOVO TP-7U    00003190 LNVO 00000001)
[    0.000000] ACPI: MCFG bfa59cb9 0003C (v01 LENOVO TP-7U    00003190 LNVO 00000001)
[    0.000000] ACPI: HPET bfa59cf5 00038 (v01 LENOVO TP-7U    00003190 LNVO 00000001)
[    0.000000] ACPI: SLIC bfa59dc2 00176 (v01 LENOVO TP-7U    00003190  LTP 00000000)
[    0.000000] ACPI: BOOT bfa59f38 00028 (v01 LENOVO TP-7U    00003190  LTP 00000001)
[    0.000000] ACPI: ASF! bfa59f60 000A0 (v16 LENOVO TP-7U    00003190 PTL  00000001)
[    0.000000] ACPI: SSDT bfa8d1fa 00568 (v01 LENOVO TP-7U    00003190 INTL 20050513)
[    0.000000] ACPI: TCPA bf807000 00032 (v00                 00000000      00000000)
[    0.000000] ACPI: DMAR bf806000 000D8 (v01               ? 00000001      00000000)
[    0.000000] ACPI: SSDT bf7d3000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT bf7d2000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT bf7d1000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
[    0.000000] ACPI: DMI detected: Lenovo ThinkPad T400
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2179MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x000bfb00
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bf5a1
[    0.000000]     0: 0x000bf5a7 -> 0x000bf6b7
[    0.000000]     0: 0x000bf70f -> 0x000bf7c6
[    0.000000]     0: 0x000bfaff -> 0x000bfb00
[    0.000000] On node 0 totalpages: 784119
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3950 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4359 pages used for memmap
[    0.000000]   HighMem zone: 552548 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f4c00000 s27648 r0 d21504 u2097152
[    0.000000] pcpu-alloc: s27648 r0 d21504 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 777984
[    0.000000] Kernel command line: BOOT_IMAGE=last ro root=UUID=290a76b5-e002-4f94-861a-3cbd0b7ae65a panic=30 rootdelay=10 radeon.dynclks=1 resume=UUID=2d867796-d2a9-4d03-a84c-77732fa4d8e6
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:000bfb00)
[    0.000000] Memory: 3089472k/3140608k available (3139k kernel code, 47004k reserved, 1871k data, 456k init, 2227628k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8e000 - 0xfffff000   ( 452 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc14e5000 - 0xc1557000   ( 456 kB)
[    0.000000]       .data : 0xc1310fe9 - 0xc14e4fdc   (1871 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1310fe9   (3139 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:320
[    0.000000] CPU 0 irqstacks, hard=f4808000 soft=f480a000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 15728640 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2526.973 MHz processor.
[    0.001006] Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.94 BogoMIPS (lpj=2526973)
[    0.001400] pid_max: default: 32768 minimum: 301
[    0.002075] Security Framework initialized
[    0.002314] Mount-cache hash table entries: 512
[    0.002823] Initializing cgroup subsys debug
[    0.003011] Initializing cgroup subsys ns
[    0.003207] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.003528] Initializing cgroup subsys cpuacct
[    0.003734] Initializing cgroup subsys memory
[    0.004025] Initializing cgroup subsys devices
[    0.004221] Initializing cgroup subsys freezer
[    0.004416] Initializing cgroup subsys blkio
[    0.004693] CPU: Physical Processor ID: 0
[    0.005008] CPU: Processor Core ID: 0
[    0.005204] mce: CPU supports 6 MCE banks
[    0.005415] CPU0: Thermal monitoring enabled (TM2)
[    0.005615] using mwait in idle threads.
[    0.008100] ACPI: Core revision 20101013
[    0.053026] ftrace: allocating 19660 entries in 39 pages
[    0.055090] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.056237] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.066438] CPU0: Intel(R) Core(TM)2 Duo CPU     P9500  @ 2.53GHz stepping 06
[    0.066993] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.066993] ... version:                2
[    0.066993] ... bit width:              40
[    0.066993] ... generic registers:      2
[    0.066993] ... value mask:             000000ffffffffff
[    0.066999] ... max period:             000000007fffffff
[    0.067187] ... fixed-purpose events:   3
[    0.067369] ... event mask:             0000000700000003
[    0.070368] NMI watchdog enabled, takes one hw-pmu counter.
[    0.074051] CPU 1 irqstacks, hard=f3128000 soft=f312a000
[    0.074064] Booting Node   0, Processors  #1 Ok.
[    0.001999] Initializing CPU#1
[    0.148043] NMI watchdog enabled, takes one hw-pmu counter.
[    0.149003] Brought up 2 CPUs
[    0.149189] Total of 2 processors activated (10107.81 BogoMIPS).
[    0.151148] kworker/u:0 used greatest stack depth: 7068 bytes left
[    0.155066] Time: 10:35:18  Date: 01/10/11
[    0.155351] NET: Registered protocol family 16
[    0.156093] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.156347] ACPI: bus type pci registered
[    0.157135] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.157388] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    0.157579] PCI: Using MMCONFIG for extended config space
[    0.158019] PCI: Using configuration type 1 for base access
[    0.167074] bio: create slab <bio-0> at 0
[    0.168077] ACPI: Added _OSI(Linux)
[    0.174524] ACPI: EC: EC description table is found, configuring boot EC
[    0.200081] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via DMI
[    0.218796] ACPI: SSDT bf7d6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.220735] ACPI: Dynamic OEM Table Load:
[    0.220982] ACPI: SSDT   (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.222369] ACPI: SSDT bf7d4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.224410] ACPI: Dynamic OEM Table Load:
[    0.224725] ACPI: SSDT   (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.232048] ACPI: SSDT bf7d5ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.234047] ACPI: Dynamic OEM Table Load:
[    0.234363] ACPI: SSDT   (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.237328] ACPI: SSDT bf7d5f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.239261] ACPI: Dynamic OEM Table Load:
[    0.239577] ACPI: SSDT   (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.245181] ACPI: Interpreter enabled
[    0.245374] ACPI: (supports S0 S3 S4 S5)
[    0.245867] ACPI: Using IOAPIC for interrupt routing
[    0.255251] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[    0.256068] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[    0.262167] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[    0.278194] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[    0.280417] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.281089] ACPI: Power Resource [PUBS] (on)
[    0.285820] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.285998] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.287416] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.287730] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.287992] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.288186] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.288487] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    0.288788] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.288986] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.289290] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.289616] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.289672] DMAR: Forcing write-buffer flush capability
[    0.289972] DMAR: Disabling IOMMU for graphics on this chipset
[    0.290211] pci 0000:00:01.0: [8086:2a41] type 1 class 0x000604
[    0.290298] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.290307] pci 0000:00:01.0: PME# disabled
[    0.290352] pci 0000:00:03.0: [8086:2a44] type 0 class 0x000780
[    0.290390] pci 0000:00:03.0: reg 10: [mem 0xfc226800-0xfc22680f 64bit]
[    0.290483] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.290492] pci 0000:00:03.0: PME# disabled
[    0.290605] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    0.290650] pci 0000:00:19.0: reg 10: [mem 0xfc200000-0xfc21ffff]
[    0.290672] pci 0000:00:19.0: reg 14: [mem 0xfc225000-0xfc225fff]
[    0.290694] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.290812] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.290823] pci 0000:00:19.0: PME# disabled
[    0.290979] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.291076] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.291177] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.291274] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.291374] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    0.291470] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    0.291589] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.291634] pci 0000:00:1a.7: reg 10: [mem 0xfc226c00-0xfc226fff]
[    0.291783] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.291794] pci 0000:00:1a.7: PME# disabled
[    0.291848] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.291887] pci 0000:00:1b.0: reg 10: [mem 0xfc220000-0xfc223fff 64bit]
[    0.292033] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.292044] pci 0000:00:1b.0: PME# disabled
[    0.292096] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.292233] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.292244] pci 0000:00:1c.0: PME# disabled
[    0.292300] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    0.292437] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.292448] pci 0000:00:1c.1: PME# disabled
[    0.292506] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.292643] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.292653] pci 0000:00:1c.3: PME# disabled
[    0.292709] pci 0000:00:1c.4: [8086:2948] type 1 class 0x000604
[    0.292846] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.292856] pci 0000:00:1c.4: PME# disabled
[    0.292923] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.293027] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    0.293129] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.293225] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    0.293325] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.293421] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    0.293541] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.293585] pci 0000:00:1d.7: reg 10: [mem 0xfc227000-0xfc2273ff]
[    0.293734] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.293745] pci 0000:00:1d.7: PME# disabled
[    0.293791] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.293928] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.294181] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.294231] pci 0000:00:1f.2: reg 10: [io  0x1c40-0x1c47]
[    0.294252] pci 0000:00:1f.2: reg 14: [io  0x1834-0x1837]
[    0.294274] pci 0000:00:1f.2: reg 18: [io  0x1838-0x183f]
[    0.294296] pci 0000:00:1f.2: reg 1c: [io  0x1830-0x1833]
[    0.294317] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.294339] pci 0000:00:1f.2: reg 24: [mem 0xfc226000-0xfc2267ff]
[    0.294425] pci 0000:00:1f.2: PME# supported from D3hot
[    0.294436] pci 0000:00:1f.2: PME# disabled
[    0.294479] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.294517] pci 0000:00:1f.3: reg 10: [mem 0xfc227400-0xfc2274ff 64bit]
[    0.294570] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.294722] pci 0000:01:00.0: [1002:95c4] type 0 class 0x000300
[    0.294752] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xdfffffff pref]
[    0.294773] pci 0000:01:00.0: reg 14: [io  0x2000-0x20ff]
[    0.294794] pci 0000:01:00.0: reg 18: [mem 0xcfff0000-0xcfffffff]
[    0.294859] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.294908] pci 0000:01:00.0: supports D1 D2
[    0.294939] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.294976] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.294986] pci 0000:00:01.0:   bridge window [mem 0xcff00000-0xcfffffff]
[    0.294999] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.295099] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.295293] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.295305] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.295322] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.295554] pci 0000:03:00.0: [8086:4236] type 0 class 0x000280
[    0.295705] pci 0000:03:00.0: reg 10: [mem 0xf4200000-0xf4201fff 64bit]
[    0.296445] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.296485] pci 0000:03:00.0: PME# disabled
[    0.296613] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.296808] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.296819] pci 0000:00:1c.1:   bridge window [mem 0xf4200000-0xf42fffff]
[    0.296836] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.296937] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.296978] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.296989] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.297005] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 64bit pref]
[    0.297107] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.297300] pci 0000:00:1c.4:   bridge window [io  0x4000-0x4fff]
[    0.297311] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.297327] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
[    0.297406] pci 0000:15:00.0: [1180:0476] type 2 class 0x000607
[    0.297449] pci 0000:15:00.0: reg 10: [mem 0xf4300000-0xf4300fff]
[    0.297495] pci 0000:15:00.0: supports D1 D2
[    0.297501] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.297513] pci 0000:15:00.0: PME# disabled
[    0.297554] pci 0000:15:00.1: [1180:0832] type 0 class 0x000c00
[    0.297596] pci 0000:15:00.1: reg 10: [mem 0xf4301000-0xf43017ff]
[    0.297750] pci 0000:15:00.1: supports D1 D2
[    0.297756] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.297767] pci 0000:15:00.1: PME# disabled
[    0.297985] pci 0000:15:00.2: [1180:0822] type 0 class 0x000805
[    0.298027] pci 0000:15:00.2: reg 10: [mem 0xf4301800-0xf43018ff]
[    0.298182] pci 0000:15:00.2: supports D1 D2
[    0.298188] pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.298200] pci 0000:15:00.2: PME# disabled
[    0.298240] pci 0000:15:00.3: [1180:0843] type 0 class 0x000880
[    0.298282] pci 0000:15:00.3: reg 10: [mem 0xf4301c00-0xf4301cff]
[    0.298436] pci 0000:15:00.3: supports D1 D2
[    0.298442] pci 0000:15:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.298454] pci 0000:15:00.3: PME# disabled
[    0.298495] pci 0000:15:00.4: [1180:0592] type 0 class 0x000880
[    0.298536] pci 0000:15:00.4: reg 10: [mem 0xf4302000-0xf43020ff]
[    0.298690] pci 0000:15:00.4: supports D1 D2
[    0.298696] pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.298708] pci 0000:15:00.4: PME# disabled
[    0.298749] pci 0000:15:00.5: [1180:0852] type 0 class 0x000880
[    0.298790] pci 0000:15:00.5: reg 10: [mem 0xf4302400-0xf43024ff]
[    0.298944] pci 0000:15:00.5: supports D1 D2
[    0.298950] pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
[    0.298971] pci 0000:15:00.5: PME# disabled
[    0.299087] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
[    0.299284] pci 0000:00:1e.0:   bridge window [io  0x5000-0x8fff]
[    0.299296] pci 0000:00:1e.0:   bridge window [mem 0xf4300000-0xf7ffffff]
[    0.299312] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.299320] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.299328] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.299336] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.299344] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.299351] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.299359] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.299367] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.299506] pci_bus 0000:00: on NUMA node 0
[    0.299515] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.299897] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.300022] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.300132] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.300247] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.300367] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.300487] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.322048] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.323141] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.324237] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.325212] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.326439] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.327503] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.328587] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.329702] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.331041] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.331358] vgaarb: loaded
[    0.332022] PCI: Using ACPI for IRQ routing
[    0.332155] PCI: pci_cache_line_size set to 64 bytes
[    0.332482] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    0.332490] reserve RAM buffer: 00000000bf5a1000 - 00000000bfffffff 
[    0.332507] reserve RAM buffer: 00000000bf6b7000 - 00000000bfffffff 
[    0.332522] reserve RAM buffer: 00000000bf7c6000 - 00000000bfffffff 
[    0.332537] reserve RAM buffer: 00000000bfb00000 - 00000000bfffffff 
[    0.333119] cfg80211: Calling CRDA to update world regulatory domain
[    0.333119] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.333119] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.333119] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.338018] Switching to clocksource hpet
[    0.359040] pnp: PnP ACPI init
[    0.359259] ACPI: bus type pnp registered
[    0.382259] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.382268] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.382275] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.382281] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.382287] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.382294] pnp 00:00: [mem 0x000d0000-0x000cffff disabled]
[    0.382301] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    0.382308] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    0.382314] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    0.382321] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.382327] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.382333] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.382339] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.382345] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.382352] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    0.382358] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    0.382364] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    0.382688] pnp 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.382755] pnp 00:01: [bus 00-ff]
[    0.382762] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.382772] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.382779] pnp 00:01: [io  0x0d00-0xffff window]
[    0.382787] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.382794] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    0.382801] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    0.382807] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    0.382814] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    0.382821] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    0.382828] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    0.382835] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    0.382842] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    0.382849] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    0.382856] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    0.382863] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    0.382870] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    0.382877] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
[    0.382884] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    0.383164] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.404651] pnp 00:02: [io  0x0010-0x001f]
[    0.404659] pnp 00:02: [io  0x0090-0x009f]
[    0.404665] pnp 00:02: [io  0x0024-0x0025]
[    0.404670] pnp 00:02: [io  0x0028-0x0029]
[    0.404676] pnp 00:02: [io  0x002c-0x002d]
[    0.404682] pnp 00:02: [io  0x0030-0x0031]
[    0.404688] pnp 00:02: [io  0x0034-0x0035]
[    0.404694] pnp 00:02: [io  0x0038-0x0039]
[    0.404699] pnp 00:02: [io  0x003c-0x003d]
[    0.404705] pnp 00:02: [io  0x00a4-0x00a5]
[    0.404711] pnp 00:02: [io  0x00a8-0x00a9]
[    0.404717] pnp 00:02: [io  0x00ac-0x00ad]
[    0.404723] pnp 00:02: [io  0x00b0-0x00b5]
[    0.404728] pnp 00:02: [io  0x00b8-0x00b9]
[    0.404734] pnp 00:02: [io  0x00bc-0x00bd]
[    0.404740] pnp 00:02: [io  0x0050-0x0053]
[    0.404745] pnp 00:02: [io  0x0072-0x0077]
[    0.404751] pnp 00:02: [io  0x002e-0x002f]
[    0.404757] pnp 00:02: [io  0x1000-0x107f]
[    0.404763] pnp 00:02: [io  0x1180-0x11ff]
[    0.404768] pnp 00:02: [io  0x0800-0x080f]
[    0.404774] pnp 00:02: [io  0x15e0-0x15ef]
[    0.404780] pnp 00:02: [io  0x1600-0x167f]
[    0.404786] pnp 00:02: [io  0x1680-0x169f]
[    0.404793] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    0.404799] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    0.404805] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    0.404812] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    0.404818] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    0.404824] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    0.405236] pnp 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.405362] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.405535] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.405573] pnp 00:04: [io  0x0000-0x000f]
[    0.405579] pnp 00:04: [io  0x0080-0x008f]
[    0.405585] pnp 00:04: [io  0x00c0-0x00df]
[    0.405592] pnp 00:04: [dma 4]
[    0.405763] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.405793] pnp 00:05: [io  0x0061]
[    0.405968] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.405999] pnp 00:06: [io  0x00f0]
[    0.406038] pnp 00:06: [irq 13]
[    0.406215] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.406247] pnp 00:07: [io  0x0070-0x0071]
[    0.406260] pnp 00:07: [irq 8]
[    0.406431] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.406462] pnp 00:08: [io  0x0060]
[    0.406468] pnp 00:08: [io  0x0064]
[    0.406480] pnp 00:08: [irq 1]
[    0.406652] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.406690] pnp 00:09: [irq 12]
[    0.406877] pnp 00:09: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (active)
[    0.428498] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.428748] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
[    0.429912] pnp: PnP ACPI: found 11 devices
[    0.430131] ACPI: ACPI bus type pnp unregistered
[    0.430339] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.430534] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.430728] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.430921] system 00:00: [mem 0x000c8000-0x000cbfff] could not be reserved
[    0.431143] system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
[    0.431336] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.431529] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.431722] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.431915] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.432134] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.432328] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.432521] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.432716] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.432911] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.433144] system 00:02: [io  0x1000-0x107f] has been reserved
[    0.433338] system 00:02: [io  0x1180-0x11ff] has been reserved
[    0.433531] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.433722] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.433914] system 00:02: [io  0x1600-0x167f] has been reserved
[    0.434133] system 00:02: [io  0x1680-0x169f] has been reserved
[    0.434327] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    0.434521] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.434715] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.434910] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.435129] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.435323] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.482348] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0000000-0xc01fffff]
[    0.482553] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.482863] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.483187] pci 0000:00:1c.0: BAR 13: assigned [io  0x9000-0x9fff]
[    0.483383] pci 0000:00:1c.1: BAR 13: assigned [io  0xa000-0xafff]
[    0.483579] pci 0000:01:00.0: BAR 6: assigned [mem 0xcff00000-0xcff1ffff pref]
[    0.483880] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.484085] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.484280] pci 0000:00:01.0:   bridge window [mem 0xcff00000-0xcfffffff]
[    0.484476] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.484783] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.484973] pci 0000:00:1c.0:   bridge window [io  0x9000-0x9fff]
[    0.485185] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    0.485383] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.485694] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.485885] pci 0000:00:1c.1:   bridge window [io  0xa000-0xafff]
[    0.486098] pci 0000:00:1c.1:   bridge window [mem 0xf4200000-0xf42fffff]
[    0.486295] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.486604] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.486794] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.486992] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.487203] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 64bit pref]
[    0.487512] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.487703] pci 0000:00:1c.4:   bridge window [io  0x4000-0x4fff]
[    0.487900] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.488113] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
[    0.488428] pci 0000:15:00.0: BAR 15: assigned [mem 0xf0000000-0xf3ffffff pref]
[    0.488738] pci 0000:15:00.0: BAR 16: assigned [mem 0xc4000000-0xc7ffffff]
[    0.488932] pci 0000:15:00.0: BAR 13: assigned [io  0x5000-0x50ff]
[    0.489139] pci 0000:15:00.0: BAR 14: assigned [io  0x5400-0x54ff]
[    0.489330] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
[    0.489519] pci 0000:15:00.0:   bridge window [io  0x5000-0x50ff]
[    0.489715] pci 0000:15:00.0:   bridge window [io  0x5400-0x54ff]
[    0.489911] pci 0000:15:00.0:   bridge window [mem 0xf0000000-0xf3ffffff pref]
[    0.490231] pci 0000:15:00.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.490430] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
[    0.493524] pci 0000:00:1e.0:   bridge window [io  0x5000-0x8fff]
[    0.493722] pci 0000:00:1e.0:   bridge window [mem 0xf4300000-0xf7ffffff]
[    0.493919] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.494261] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.494459] pci 0000:00:01.0: setting latency timer to 64
[    0.494480] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.494677] pci 0000:00:1c.0: setting latency timer to 64
[    0.494696] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.494894] pci 0000:00:1c.1: setting latency timer to 64
[    0.494914] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.495128] pci 0000:00:1c.3: setting latency timer to 64
[    0.495145] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.495343] pci 0000:00:1c.4: setting latency timer to 64
[    0.495360] pci 0000:00:1e.0: setting latency timer to 64
[    0.495378] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.495577] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.495584] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.495591] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.495598] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.495605] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.495612] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.495619] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.495627] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.495633] pci_bus 0000:01: resource 1 [mem 0xcff00000-0xcfffffff]
[    0.495641] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.495648] pci_bus 0000:02: resource 0 [io  0x9000-0x9fff]
[    0.495655] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    0.495662] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.495669] pci_bus 0000:03: resource 0 [io  0xa000-0xafff]
[    0.495676] pci_bus 0000:03: resource 1 [mem 0xf4200000-0xf42fffff]
[    0.495683] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.495690] pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
[    0.495697] pci_bus 0000:05: resource 1 [mem 0xf8000000-0xf9ffffff]
[    0.495704] pci_bus 0000:05: resource 2 [mem 0xf4000000-0xf40fffff 64bit pref]
[    0.495711] pci_bus 0000:0d: resource 0 [io  0x4000-0x4fff]
[    0.495718] pci_bus 0000:0d: resource 1 [mem 0xfa000000-0xfbffffff]
[    0.495725] pci_bus 0000:0d: resource 2 [mem 0xf4100000-0xf41fffff 64bit pref]
[    0.495732] pci_bus 0000:15: resource 0 [io  0x5000-0x8fff]
[    0.495739] pci_bus 0000:15: resource 1 [mem 0xf4300000-0xf7ffffff]
[    0.495746] pci_bus 0000:15: resource 2 [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.495753] pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
[    0.495759] pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
[    0.495766] pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
[    0.495773] pci_bus 0000:15: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.495779] pci_bus 0000:15: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.495786] pci_bus 0000:15: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.495793] pci_bus 0000:15: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.495800] pci_bus 0000:16: resource 0 [io  0x5000-0x50ff]
[    0.495806] pci_bus 0000:16: resource 1 [io  0x5400-0x54ff]
[    0.495813] pci_bus 0000:16: resource 2 [mem 0xf0000000-0xf3ffffff pref]
[    0.495820] pci_bus 0000:16: resource 3 [mem 0xc4000000-0xc7ffffff]
[    0.495884] NET: Registered protocol family 2
[    0.496202] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.496824] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.498032] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.498593] TCP: Hash tables configured (established 131072 bind 65536)
[    0.498783] TCP reno registered
[    0.498966] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.499184] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.499582] NET: Registered protocol family 1
[    0.500104] pci 0000:01:00.0: Boot video device
[    0.500176] PCI: CLS 64 bytes, default 64
[    0.500275] Trying to unpack rootfs image as initramfs...
[    0.934830] Freeing initrd memory: 15268k freed
[    0.947400] DMAR: Host address width 36
[    0.947595] DMAR: DRHD base: 0x000000feb03000 flags: 0x0
[    0.947824] IOMMU 0: reg_base_addr feb03000 ver 1:0 cap c9008020e30260 ecap 1000
[    0.948152] DMAR: DRHD base: 0x000000feb00000 flags: 0x0
[    0.948357] IOMMU 1: reg_base_addr feb00000 ver 1:0 cap c0000020630270 ecap 1000
[    0.948658] DMAR: DRHD base: 0x000000feb02000 flags: 0x1
[    0.948860] IOMMU 2: reg_base_addr feb02000 ver 1:0 cap c9008020630260 ecap 1000
[    0.949177] DMAR: RMRR base: 0x000000fc226c00 end: 0x000000fc2273ff
[    0.949368] DMAR: No ATSR found
[    0.949564] DMAR: Device scope device [0000:00:03.02] not found
[    0.949754] DMAR: Device scope device [0000:00:03.02] not found
[    0.949949] DMAR: Device scope device [0000:00:03.03] not found
[    0.950155] DMAR: Device scope device [0000:00:03.03] not found
[    0.950544] IOMMU 1 0xfeb00000: using Register based invalidation
[    0.950735] IOMMU 0 0xfeb03000: using Register based invalidation
[    0.950926] IOMMU 2 0xfeb02000: using Register based invalidation
[    0.951143] IOMMU: Setting RMRR:
[    0.951357] IOMMU: Setting identity map for device 0000:00:1d.0 [0xfc226c00 - 0xfc227400]
[    0.951721] IOMMU: Setting identity map for device 0000:00:1d.1 [0xfc226c00 - 0xfc227400]
[    0.952090] IOMMU: Setting identity map for device 0000:00:1d.2 [0xfc226c00 - 0xfc227400]
[    0.952441] IOMMU: Setting identity map for device 0000:00:1d.7 [0xfc226c00 - 0xfc227400]
[    0.952792] IOMMU: Setting identity map for device 0000:00:1a.0 [0xfc226c00 - 0xfc227400]
[    0.953161] IOMMU: Setting identity map for device 0000:00:1a.1 [0xfc226c00 - 0xfc227400]
[    0.953512] IOMMU: Setting identity map for device 0000:00:1a.2 [0xfc226c00 - 0xfc227400]
[    0.953862] IOMMU: Setting identity map for device 0000:00:1a.7 [0xfc226c00 - 0xfc227400]
[    0.954209] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    0.954424] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0x1000000]
[    0.955096] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    0.956533] Simple Boot Flag at 0x35 set to 0x1
[    0.959591] microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
[    0.959793] microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
[    0.960185] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.961227] audit: initializing netlink socket (disabled)
[    0.961438] type=2000 audit(1294655718.960:1): initialized
[    0.981214] highmem bounce pool size: 64 pages
[    0.981410] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.993973] msgmni has been set to 1713
[    0.995050] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.995352] io scheduler noop registered
[    0.995534] io scheduler deadline registered
[    0.995750] io scheduler cfq registered (default)
[    0.998224] pcieport 0000:00:01.0: ACPI _OSC control granted for 0x1d
[    0.998439] pcieport 0000:00:01.0: setting latency timer to 64
[    0.998507] pcieport 0000:00:01.0: irq 43 for MSI/MSI-X
[    0.998981] pcieport 0000:00:1c.0: ACPI _OSC control granted for 0x1d
[    0.999271] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.999358] pcieport 0000:00:1c.0: irq 44 for MSI/MSI-X
[    0.999842] pcieport 0000:00:1c.1: ACPI _OSC control granted for 0x1d
[    1.000091] pcieport 0000:00:1c.1: setting latency timer to 64
[    1.000178] pcieport 0000:00:1c.1: irq 45 for MSI/MSI-X
[    1.000665] pcieport 0000:00:1c.3: ACPI _OSC control granted for 0x1d
[    1.000885] pcieport 0000:00:1c.3: setting latency timer to 64
[    1.000972] pcieport 0000:00:1c.3: irq 46 for MSI/MSI-X
[    1.001479] pcieport 0000:00:1c.4: ACPI _OSC control granted for 0x1d
[    1.001699] pcieport 0000:00:1c.4: setting latency timer to 64
[    1.001785] pcieport 0000:00:1c.4: irq 47 for MSI/MSI-X
[    1.002535] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    1.002732] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    1.002927] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    1.002983] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    1.003238] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    1.003288] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    1.003482] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    1.003679] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    1.003726] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    1.003924] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    1.003970] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    1.004195] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    1.004555] intel_idle: MWAIT substates: 0x3122220
[    1.004561] intel_idle: does not run on family 6 model 23
[    1.005440] ACPI: AC Adapter [AC] (off-line)
[    1.006267] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    1.006795] ACPI: Lid Switch [LID]
[    1.007228] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    1.007538] ACPI: Sleep Button [SLPB]
[    1.007975] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.008307] ACPI: Power Button [PWRF]
[    1.008737] ACPI: acpi_idle registered with cpuidle
[    1.015624] Monitor-Mwait will be used to enter C-1 state
[    1.016036] Monitor-Mwait will be used to enter C-2 state
[    1.017042] Monitor-Mwait will be used to enter C-3 state
[    1.017060] Marking TSC unstable due to TSC halts in idle
[    1.069970] thermal LNXTHERM:00: registered as thermal_zone0
[    1.070189] ACPI: Thermal Zone [THM0] (68 C)
[    1.072680] thermal LNXTHERM:01: registered as thermal_zone1
[    1.072873] ACPI: Thermal Zone [THM1] (66 C)
[    1.074989] Non-volatile memory driver v1.3
[    1.075641] Linux agpgart interface v0.103
[    1.076208] [drm] Initialized drm 1.1.0 20060810
[    1.076444] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.091765] ACPI: Battery Slot [BAT0] (battery present)
[    1.116032] brd: module loaded
[    1.116234] console [netcon0] enabled
[    1.116417] netconsole: network logging started
[    1.116911] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.126476] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.126779] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.127365] mousedev: PS/2 mouse device common for all mice
[    1.128358] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.129960] cpuidle: using governor ladder
[    1.131805] cpuidle: using governor menu
[    1.132288] Netfilter messages via NETLINK v0.30.
[    1.132505] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.133405] ctnetlink v0.93: registering with nfnetlink.
[    1.134645] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.134925] TCP cubic registered
[    1.135132] NET: Registered protocol family 17
[    1.135339] Registering the dns_resolver key type
[    1.137459] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.138471] Using IPI No-Shortcut mode
[    1.139171] PM: Checking hibernation image partition UUID=2d867796-d2a9-4d03-a84c-77732fa4d8e6
[    1.627975] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    1.645819] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
[    1.650044] PM: Hibernation image not present or could not be loaded.
[    1.650080] registered taskstats version 1
[    1.651121]   Magic number: 11:806:577
[    1.651767] Freeing unused kernel memory: 456k freed
[    1.652598] Write protecting the kernel text: 3140k
[    1.652897] Write protecting the kernel read-only data: 1532k
[    1.665671] mount used greatest stack depth: 7052 bytes left
[    1.674566] mknod used greatest stack depth: 6984 bytes left
[    1.691550] mknod used greatest stack depth: 6980 bytes left
[    1.706243] replace used greatest stack depth: 6924 bytes left
[    1.745305] device-mapper: uevent: version 1.0.3
[    1.745857] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    1.747057] modprobe used greatest stack depth: 6728 bytes left
[    1.805439] udevadm used greatest stack depth: 6220 bytes left
[    2.717785] SCSI subsystem initialized
[    2.726122] usbcore: registered new interface driver usbfs
[    2.726414] usbcore: registered new interface driver hub
[    2.729157] usbcore: registered new device driver usb
[    2.749408] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.752491] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    2.754103] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    2.754333] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    2.754578] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.754587] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.754836] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.761135] ehci_hcd 0000:00:1a.7: debug port 1
[    2.765214] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    2.765258] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xfc226c00
[    2.775064] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.775311] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.775514] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.775821] usb usb1: Product: EHCI Host Controller
[    2.776034] usb usb1: Manufacturer: Linux 2.6.37+ ehci_hcd
[    2.776229] usb usb1: SerialNumber: 0000:00:1a.7
[    2.776928] hub 1-0:1.0: USB hub found
[    2.777153] hub 1-0:1.0: 6 ports detected
[    2.777953] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    2.778408] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    2.778623] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.778847] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.778856] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.779090] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.782144] ehci_hcd 0000:00:1d.7: debug port 1
[    2.786211] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    2.786246] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfc227000
[    2.799066] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.799302] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.799497] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.799798] usb usb2: Product: EHCI Host Controller
[    2.799986] usb usb2: Manufacturer: Linux 2.6.37+ ehci_hcd
[    2.800198] usb usb2: SerialNumber: 0000:00:1d.7
[    2.800817] hub 2-0:1.0: USB hub found
[    2.801036] hub 2-0:1.0: 6 ports detected
[    2.823296] libata version 3.00 loaded.
[    2.825285] modprobe used greatest stack depth: 6024 bytes left
[    2.872238] ahci 0000:00:1f.2: version 3.0
[    2.872268] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.872562] ahci 0000:00:1f.2: irq 48 for MSI/MSI-X
[    2.872637] ahci: SSS flag set, parallel bus scan disabled
[    2.872879] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    2.873218] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    2.873530] ahci 0000:00:1f.2: setting latency timer to 64
[    2.875719] [drm] radeon defaulting to kernel modesetting.
[    2.876138] scsi0 : ahci
[    2.876736] [drm] radeon kernel modesetting enabled.
[    2.877153] radeon 0000:01:00.0: power state changed by ACPI to D0
[    2.877371] radeon 0000:01:00.0: power state changed by ACPI to D0
[    2.877575] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.877776] radeon 0000:01:00.0: setting latency timer to 64
[    2.878515] scsi1 : ahci
[    2.878935] scsi2 : ahci
[    2.880561] scsi3 : ahci
[    2.881697] ata1: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226100 irq 48
[    2.882002] ata2: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226180 irq 48
[    2.882339] ata3: DUMMY
[    2.882542] ata4: DUMMY
[    2.883247] [drm] initializing kernel modesetting (RV620 0x1002:0x95C4).
[    2.883608] [drm] register mmio base: 0xCFFF0000
[    2.883802] [drm] register mmio size: 65536
[    2.884685] ATOM BIOS: BR037722
[    2.884916] radeon 0000:01:00.0: VRAM: 256M 0x0000000000000000 - 0x000000000FFFFFFF (256M used)
[    2.885261] radeon 0000:01:00.0: GTT: 512M 0x0000000010000000 - 0x000000002FFFFFFF
[    2.890319] [drm] Detected VRAM RAM=256M, BAR=256M
[    2.890533] [drm] RAM width 64bits DDR
[    2.890867] [TTM] Zone  kernel: Available graphics memory: 438784 kiB.
[    2.891104] [TTM] Zone highmem: Available graphics memory: 1552598 kiB.
[    2.891298] [TTM] Initializing pool allocator.
[    2.891521] [drm] radeon: 256M of VRAM memory ready
[    2.891708] [drm] radeon: 512M of GTT memory ready.
[    2.892049] radeon 0000:01:00.0: irq 49 for MSI/MSI-X
[    2.892066] radeon 0000:01:00.0: radeon: using MSI.
[    2.892311] [drm] radeon: irq initialized.
[    2.892497] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    2.893716] [drm] Loading RV620 Microcode
[    2.914555] DRHD: handling fault status reg 3
[    2.914753] DMAR:[DMA Read] Request device [01:00.0] fault addr d05e1000 
[    2.914756] DMAR:[fault reason 06] PTE Read access is not set
[    2.918600] radeon 0000:01:00.0: WB enabled
[    2.951776] [drm] ring test succeeded in 0 usecs
[    2.952924] [drm] radeon: ib pool ready.
[    2.953270] [drm] ib test succeeded in 0 usecs
[    2.953467] [drm] Enabling audio support
[    2.954362] [drm] Radeon Display Connectors
[    2.954549] [drm] Connector 0:
[    2.954732] [drm]   DVI-I
[    2.954915] [drm]   HPD3
[    2.955125] [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68 0x7e6c 0x7e6c
[    2.955433] [drm]   Encoders:
[    2.955621] [drm]     DFP1: INTERNAL_UNIPHY
[    2.955809] [drm] Connector 1:
[    2.955997] [drm]   LVDS
[    2.956197] [drm]   Encoders:
[    2.956385] [drm]     LCD1: INTERNAL_KLDSCP_LVTMA
[    2.956575] [drm] Connector 2:
[    2.956764] [drm]   VGA
[    2.956955] [drm]   DDC: 0x7e20 0x7e20 0x7e24 0x7e24 0x7e28 0x7e28 0x7e2c 0x7e2c
[    2.957279] [drm]   Encoders:
[    2.957463] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    2.961839] [drm] radeon: power management initialized
[    3.181274] usb 1-6: new high speed USB device using ehci_hcd and address 3
[    3.187286] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.188556] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.188567] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.189034] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.189046] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.189916] ata1.00: ATA-8: FUJITSU MHZ2160BJ G1, 0084001F, max UDMA/100
[    3.190155] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.191357] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.191368] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.191777] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.191787] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.192709] ata1.00: configured for UDMA/100
[    3.193242] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHZ2160B 0084 PQ: 0 ANSI: 5
[    3.285281] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037060/fffff060 (bad dma)
[    3.308603] usb 1-6: New USB device found, idVendor=17ef, idProduct=1004
[    3.308808] usb 1-6: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    3.309043] usb 1-6: Product: Integrated Camera
[    3.309240] usb 1-6: Manufacturer: Chicony Electronics Co., Ltd.
[    3.309432] usb 1-6: SerialNumber: SN0001
[    3.498279] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.500375] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.500387] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.500698] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.777728] [drm] fb mappable at 0xD0141000
[    3.777921] [drm] vram apper at 0xD0000000
[    3.778121] [drm] size 5300224
[    3.778302] [drm] fb depth is 24
[    3.778483] [drm]    pitch is 5888
[    3.778810] fbcon: radeondrmfb (fb0) is primary device
[    4.026919] Console: switching to colour frame buffer device 180x56
[    4.041746] fb0: radeondrmfb frame buffer device
[    4.041839] drm: registered panic notifier
[    4.041931] [drm] Initialized radeon 2.7.0 20080528 for 0000:01:00.0 on minor 0
[    4.192943] ata2.00: HPA detected: current 231496650, native 234441648
[    4.193208] ata2.00: ATA-7: TOSHIBA MK1234GSX, AH001D, max UDMA/100
[    4.193336] ata2.00: 231496650 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.195753] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    4.195764] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    4.195923] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    4.197341] ata2.00: configured for UDMA/100
[    4.197736] scsi 1:0:0:0: Direct-Access     ATA      TOSHIBA MK1234GS AH00 PQ: 0 ANSI: 5
[    4.204832] modprobe used greatest stack depth: 5452 bytes left
[    4.261578] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    4.261734] sd 1:0:0:0: [sdb] 231496650 512-byte logical blocks: (118 GB/110 GiB)
[    4.261919] sd 1:0:0:0: [sdb] Write Protect is off
[    4.262050] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.262097] sd 0:0:0:0: [sda] Write Protect is off
[    4.262143] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.262366] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.262449] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.301516]  sdb: unknown partition table
[    4.302289] sd 1:0:0:0: [sdb] Attached SCSI disk
[    4.330190]  sda:
[    4.330968] sd 0:0:0:0: [sda] Attached SCSI disk
[   15.740212] PM: Starting manual resume from disk
[   15.744658] PM: Hibernation image partition 254:7 present
[   15.744663] PM: Looking for hibernation image.
[   15.745144] PM: Image not found (code -22)
[   15.745150] PM: Hibernation image not present or could not be loaded.
[   15.832329] EXT3-fs: barriers not enabled
[   15.849627] kjournald starting.  Commit interval 5 seconds
[   15.849694] EXT3-fs (dm-3): mounted filesystem with writeback data mode
[   18.645812] udev[1794]: starting version 165
[   19.080574] [drm:radeon_vga_detect] *ERROR* VGA-1: probed a monitor but no|invalid EDID
[   19.343487] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   19.343610] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   19.402561] uhci_hcd: USB Universal Host Controller Interface driver
[   19.404606] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   19.404856] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   19.404877] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   19.404898] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   19.404907] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   19.404937] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   19.408112] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[   19.408252] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   19.408261] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.408275] usb usb3: Product: UHCI Host Controller
[   19.408281] usb usb3: Manufacturer: Linux 2.6.37+ uhci_hcd
[   19.408288] usb usb3: SerialNumber: 0000:00:1a.0
[   19.408806] hub 3-0:1.0: USB hub found
[   19.408829] hub 3-0:1.0: 2 ports detected
[   19.409248] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[   19.409272] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   19.409287] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   19.409308] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   19.413298] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[   19.413400] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   19.413408] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.413415] usb usb4: Product: UHCI Host Controller
[   19.413421] usb usb4: Manufacturer: Linux 2.6.37+ uhci_hcd
[   19.413428] usb usb4: SerialNumber: 0000:00:1a.1
[   19.414960] hub 4-0:1.0: USB hub found
[   19.414974] hub 4-0:1.0: 2 ports detected
[   19.415609] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   19.415839] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   19.415862] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[   19.415878] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   19.415886] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   19.415912] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[   19.427389] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[   19.427492] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   19.427501] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.427508] usb usb5: Product: UHCI Host Controller
[   19.427514] usb usb5: Manufacturer: Linux 2.6.37+ uhci_hcd
[   19.427520] usb usb5: SerialNumber: 0000:00:1a.2
[   19.427975] hub 5-0:1.0: USB hub found
[   19.427989] hub 5-0:1.0: 2 ports detected
[   19.428618] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   19.428837] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   19.428853] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   19.428869] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   19.428877] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   19.428901] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[   19.430163] tpm_tis 00:0a: 1.2 TPM (device-id 0x1020, rev-id 6)
[   19.430171] tpm_tis 00:0a: Intel iTPM workaround enabled
[   19.432101] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[   19.432203] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   19.432212] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.432219] usb usb6: Product: UHCI Host Controller
[   19.432224] usb usb6: Manufacturer: Linux 2.6.37+ uhci_hcd
[   19.432231] usb usb6: SerialNumber: 0000:00:1d.0
[   19.432466] hub 6-0:1.0: USB hub found
[   19.432479] hub 6-0:1.0: 2 ports detected
[   19.432758] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   19.432774] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   19.432783] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   19.432803] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[   19.436100] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[   19.436203] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   19.436211] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.436218] usb usb7: Product: UHCI Host Controller
[   19.436224] usb usb7: Manufacturer: Linux 2.6.37+ uhci_hcd
[   19.436230] usb usb7: SerialNumber: 0000:00:1d.1
[   19.436470] hub 7-0:1.0: USB hub found
[   19.436483] hub 7-0:1.0: 2 ports detected
[   19.436754] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   19.436770] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   19.436778] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   19.436798] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   19.438865] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[   19.438966] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   19.438974] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.438981] usb usb8: Product: UHCI Host Controller
[   19.438987] usb usb8: Manufacturer: Linux 2.6.37+ uhci_hcd
[   19.438992] usb usb8: SerialNumber: 0000:00:1d.2
[   19.440458] hub 8-0:1.0: USB hub found
[   19.440473] hub 8-0:1.0: 2 ports detected
[   19.519636] acpi device:08: registered as cooling_device2
[   19.520959] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:07/LNXVIDEO:01/input/input5
[   19.521237] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[   19.521668] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   19.521675] thinkpad_acpi: http://ibm-acpi.sf.net/
[   19.521681] thinkpad_acpi: ThinkPad BIOS 7UET89WW (3.19 ), EC 7VHT16WW-1.06
[   19.521687] thinkpad_acpi: Lenovo ThinkPad T400, model 2767BC8
[   19.544649] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   19.545297] thinkpad_acpi: radio switch found; radios are enabled
[   19.550369] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[   19.551187] Registered led device: tpacpi::thinklight
[   19.551273] Registered led device: tpacpi::power
[   19.551329] Registered led device: tpacpi::standby
[   19.551391] Registered led device: tpacpi::thinkvantage
[   19.554145] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[   19.554153] thinkpad_acpi: volume: disabled as there is no ALSA support in this kernel
[   19.554558] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
[   19.644323] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
[   19.716053] usb 4-2: new full speed USB device using uhci_hcd and address 2
[   19.741381] rtc_cmos 00:07: RTC can wake from S4
[   19.744264] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[   19.744317] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   19.767942] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
[   19.767953] yenta_cardbus 0000:15:00.0: Socket status: 30000006
[   19.818042] Monitor-Mwait will be used to enter C-3 state
[   19.835306] thinkpad_acpi: EC reports that Thermal Table has changed
[   19.856552] Linux video capture interface: v2.00
[   19.875401] usb 4-2: New USB device found, idVendor=0a5c, idProduct=2145
[   19.875411] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   19.875418] usb 4-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[   19.875425] usb 4-2: Manufacturer: Lenovo Computer Corp
[   19.927824] ACPI: \_SB_.GDCK - docking
[   20.007396] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[   20.211040] usb 1-5: new high speed USB device using ehci_hcd and address 4
[   20.254960] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-k2
[   20.254962] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[   20.254989] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   20.254999] e1000e 0000:00:19.0: setting latency timer to 64
[   20.255150] e1000e 0000:00:19.0: irq 50 for MSI/MSI-X
[   20.314031] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037120/fffff120 (bad dma)
[   20.325383] usb 1-5: New USB device found, idVendor=04b3, idProduct=4485
[   20.325387] usb 1-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   20.325660] hub 1-5:1.0: USB hub found
[   20.325745] hub 1-5:1.0: 4 ports detected
[   20.410467] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1c:25:9f:37:bb
[   20.410470] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   20.410493] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[   20.414251] udev[1803]: renamed network interface eth0 to ethernet
[   20.599136] usb 1-5.2: new high speed USB device using ehci_hcd and address 5
[   20.673024] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037240/fffff240 (bad dma)
[   20.683096] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:1004)
[   20.684375] usb 1-5.2: New USB device found, idVendor=03f0, idProduct=2f24
[   20.684378] usb 1-5.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   20.716180] hub 1-5.2:1.0: USB hub found
[   20.716255] hub 1-5.2:1.0: 6 ports detected
[   20.718747] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.7/usb1/1-6/1-6:1.0/input/input7
[   20.718891] usbcore: registered new interface driver uvcvideo
[   20.718893] USB Video Class driver (v1.0.0)
[   20.990123] usb 1-5.2.1: new full speed USB device using ehci_hcd and address 6
[   21.064036] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037360/fffff360 (bad dma)
[   21.075880] usb 1-5.2.1: New USB device found, idVendor=0557, idProduct=2008
[   21.075885] usb 1-5.2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   21.075889] usb 1-5.2.1: Product: USB-Serial Controller
[   21.075892] usb 1-5.2.1: Manufacturer: Prolific Technology Inc.
[   21.150119] usb 1-5.2.2: new full speed USB device using ehci_hcd and address 7
[   21.154581] usbcore: registered new interface driver usbserial
[   21.154736] USB Serial support registered for generic
[   21.157287] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   21.157352] HDA Intel 0000:00:1b.0: irq 51 for MSI/MSI-X
[   21.157381] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   21.198817] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   21.198894] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   21.198958] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   21.199042] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   21.224047] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037420/fffff420 (bad dma)
[   21.236256] usb 1-5.2.2: New USB device found, idVendor=413c, idProduct=1003
[   21.236261] usb 1-5.2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   21.236265] usb 1-5.2.2: Product: Dell USB Keyboard Hub
[   21.236268] usb 1-5.2.2: Manufacturer: Dell
[   21.237037] hub 1-5.2.2:1.0: USB hub found
[   21.237254] hub 1-5.2.2:1.0: 3 ports detected
[   21.238269] usbcore: registered new interface driver usbserial_generic
[   21.238271] usbserial: USB Serial Driver core
[   21.276130] USB Serial support registered for pl2303
[   21.276158] pl2303 1-5.2.1:1.0: pl2303 converter detected
[   21.279470] usb 1-5.2.1: pl2303 converter now attached to ttyUSB0
[   21.279491] usbcore: registered new interface driver pl2303
[   21.279492] pl2303: Prolific PL2303 USB to serial adaptor driver
[   21.499150] usb 1-5.2.2.1: new full speed USB device using ehci_hcd and address 8
[   21.536355] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[   21.536358] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   21.536440] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   21.536470] iwlagn 0000:03:00.0: setting latency timer to 64
[   21.536529] iwlagn 0000:03:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
[   21.555916] iwlagn 0000:03:00.0: device EEPROM VER=0x11e, CALIB=0x4
[   21.555918] iwlagn 0000:03:00.0: Device SKU: 0Xb
[   21.555921] iwlagn 0000:03:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
[   21.555933] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   21.556077] iwlagn 0000:03:00.0: irq 52 for MSI/MSI-X
[   21.562042] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037540/fffff540 (bad dma)
[   21.574256] usb 1-5.2.2.1: New USB device found, idVendor=413c, idProduct=2010
[   21.574261] usb 1-5.2.2.1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[   21.574265] usb 1-5.2.2.1: Product: Dell USB Keyboard
[   21.574268] usb 1-5.2.2.1: Manufacturer: Dell
[   21.648297] usb 1-5.2.2.3: new low speed USB device using ehci_hcd and address 9
[   21.702369] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[   21.712118] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037600/fffff600 (bad dma)
[   21.727122] usb 1-5.2.2.3: New USB device found, idVendor=413c, idProduct=3012
[   21.727125] usb 1-5.2.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   21.727127] usb 1-5.2.2.3: Product: Dell USB Optical Mouse
[   21.727129] usb 1-5.2.2.3: Manufacturer: Dell
[   21.766539] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   21.771239] udev[1807]: renamed network interface wlan0 to wifi
[   21.831220] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5.2/1-5.2.2/1-5.2.2.1/1-5.2.2.1:1.0/input/input12
[   21.831344] generic-usb 0003:413C:2010.0001: input,hidraw0: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1a.7-5.2.2.1/input0
[   21.832857] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5.2/1-5.2.2/1-5.2.2.1/1-5.2.2.1:1.1/input/input13
[   21.832948] generic-usb 0003:413C:2010.0002: input,hidraw1: USB HID v1.10 Device [Dell Dell USB Keyboard] on usb-0000:00:1a.7-5.2.2.1/input1
[   21.835291] input: Dell Dell USB Optical Mouse as /devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5.2/1-5.2.2/1-5.2.2.3/1-5.2.2.3:1.0/input/input14
[   21.835382] generic-usb 0003:413C:3012.0003: input,hidraw2: USB HID v1.11 Mouse [Dell Dell USB Optical Mouse] on usb-0000:00:1a.7-5.2.2.3/input0
[   21.835398] usbcore: registered new interface driver usbhid
[   21.835400] usbhid: USB HID core driver
[   22.129982] ACPI: \_SB_.GDCK - undocking
[   22.149285] usb 1-5: USB disconnect, address 4
[   22.149288] usb 1-5.2: USB disconnect, address 5
[   22.149290] usb 1-5.2.1: USB disconnect, address 6
[   22.149417] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[   22.149429] pl2303 1-5.2.1:1.0: device disconnected
[   22.149446] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f70373c0/fffff3c0 (bad dma)
[   22.149560] usb 1-5.2.2: USB disconnect, address 7
[   22.149562] usb 1-5.2.2.1: USB disconnect, address 8
[   22.166193] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f70375a0/fffff5a0 (bad dma)
[   22.166199] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f70376c0/fffff6c0 (bad dma)
[   22.166204] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037720/fffff720 (bad dma)
[   22.170140] usb 1-5.2.2.3: USB disconnect, address 9
[   22.178340] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037660/fffff660 (bad dma)
[   22.178686] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037480/fffff480 (bad dma)
[   22.178697] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f70374e0/fffff4e0 (bad dma)
[   22.179110] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f70372a0/fffff2a0 (bad dma)
[   22.179120] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037300/fffff300 (bad dma)
[   22.179491] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037180/fffff180 (bad dma)
[   22.179502] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f70371e0/fffff1e0 (bad dma)
[   22.308830] Adding 8388604k swap on /dev/mapper/crypted-swap.  Priority:-1 extents:1 across:8388604k 
[   23.760318] thinkpad_acpi: EC reports that Thermal Table has changed
[   24.273918] EXT3-fs (dm-3): using internal journal
[   31.743321] EXT2-fs (dm-0): warning: mounting unchecked fs, running e2fsck is recommended
[   32.075528] EXT3-fs: barriers not enabled
[   32.085814] kjournald starting.  Commit interval 5 seconds
[   32.085873] EXT3-fs (dm-4): warning: maximal mount count reached, running e2fsck is recommended
[   32.086528] EXT3-fs (dm-4): using internal journal
[   32.086539] EXT3-fs (dm-4): mounted filesystem with writeback data mode
[   32.431428] EXT3-fs: barriers not enabled
[   32.442139] kjournald starting.  Commit interval 5 seconds
[   32.442208] EXT3-fs (dm-5): warning: maximal mount count reached, running e2fsck is recommended
[   32.442753] EXT3-fs (dm-5): using internal journal
[   32.442765] EXT3-fs (dm-5): mounted filesystem with writeback data mode
[   32.826416] EXT3-fs: barriers not enabled
[   32.837741] kjournald starting.  Commit interval 5 seconds
[   32.837849] EXT3-fs (dm-6): warning: maximal mount count reached, running e2fsck is recommended
[   32.838431] EXT3-fs (dm-6): using internal journal
[   32.838442] EXT3-fs (dm-6): mounted filesystem with writeback data mode
[   33.177426] EXT3-fs: barriers not enabled
[   33.188864] kjournald starting.  Commit interval 5 seconds
[   33.188957] EXT3-fs (dm-8): warning: maximal mount count reached, running e2fsck is recommended
[   33.189544] EXT3-fs (dm-8): using internal journal
[   33.189555] EXT3-fs (dm-8): mounted filesystem with writeback data mode
[   33.654162] Btrfs loaded
[   33.657219] device fsid a4d08ddefc5924d-3889fbd70ed8eaaf devid 1 transid 64893 /dev/sdb
[   39.784247] e1000e 0000:00:19.0: irq 50 for MSI/MSI-X
[   39.835230] e1000e 0000:00:19.0: irq 50 for MSI/MSI-X
[   71.341078] RPC: Registered udp transport module.
[   71.341086] RPC: Registered tcp transport module.
[   71.341091] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   77.915299] sshd (3300): /proc/3300/oom_adj is deprecated, please use /proc/3300/oom_score_adj instead.
[   80.943951] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   81.136378] svc: failed to register nfsdv2 RPC service (errno 111).
[   81.136470] svc: failed to register nfsaclv2 RPC service (errno 111).
[   81.136478] nfsd: last server has exited, flushing export cache
[  135.294334] thinkpad_acpi: EC reports that Thermal Table has changed
[  135.409094] ACPI: \_SB_.GDCK - docking
[  135.475090] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[  135.714054] usb 1-5: new high speed USB device using ehci_hcd and address 10
[  135.817037] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037780/fffff780 (bad dma)
[  135.828412] usb 1-5: New USB device found, idVendor=04b3, idProduct=4485
[  135.828415] usb 1-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  135.828666] hub 1-5:1.0: USB hub found
[  135.828763] hub 1-5:1.0: 4 ports detected
[  136.102157] usb 1-5.2: new high speed USB device using ehci_hcd and address 11
[  136.176024] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f70378a0/fffff8a0 (bad dma)
[  136.187416] usb 1-5.2: New USB device found, idVendor=03f0, idProduct=2f24
[  136.187420] usb 1-5.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  136.187710] hub 1-5.2:1.0: USB hub found
[  136.187771] hub 1-5.2:1.0: 6 ports detected
[  136.371080] e1000e: ethernet NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[  136.371090] e1000e 0000:00:19.0: ethernet: 10/100 speed: disabling TSO
[  136.463319] usb 1-5.2.1: new full speed USB device using ehci_hcd and address 12
[  136.537077] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f70379c0/fffff9c0 (bad dma)
[  136.549436] usb 1-5.2.1: New USB device found, idVendor=0557, idProduct=2008
[  136.549446] usb 1-5.2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  136.549453] usb 1-5.2.1: Product: USB-Serial Controller
[  136.549459] usb 1-5.2.1: Manufacturer: Prolific Technology Inc.
[  136.550409] pl2303 1-5.2.1:1.0: pl2303 converter detected
[  136.554101] usb 1-5.2.1: pl2303 converter now attached to ttyUSB0
[  136.628197] usb 1-5.2.2: new full speed USB device using ehci_hcd and address 13
[  136.702066] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037a80/fffffa80 (bad dma)
[  136.714316] usb 1-5.2.2: New USB device found, idVendor=413c, idProduct=1003
[  136.714326] usb 1-5.2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  136.714333] usb 1-5.2.2: Product: Dell USB Keyboard Hub
[  136.714339] usb 1-5.2.2: Manufacturer: Dell
[  136.715206] hub 1-5.2.2:1.0: USB hub found
[  136.715406] hub 1-5.2.2:1.0: 3 ports detected
[  137.056191] usb 1-5.2.2.1: new full speed USB device using ehci_hcd and address 14
[  137.119072] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037ba0/fffffba0 (bad dma)
[  137.131438] usb 1-5.2.2.1: New USB device found, idVendor=413c, idProduct=2010
[  137.131448] usb 1-5.2.2.1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[  137.131455] usb 1-5.2.2.1: Product: Dell USB Keyboard
[  137.131461] usb 1-5.2.2.1: Manufacturer: Dell
[  137.139376] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5.2/1-5.2.2/1-5.2.2.1/1-5.2.2.1:1.0/input/input15
[  137.139585] generic-usb 0003:413C:2010.0004: input,hidraw0: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1a.7-5.2.2.1/input0
[  137.142655] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5.2/1-5.2.2/1-5.2.2.1/1-5.2.2.1:1.1/input/input16
[  137.142863] generic-usb 0003:413C:2010.0005: input,hidraw1: USB HID v1.10 Device [Dell Dell USB Keyboard] on usb-0000:00:1a.7-5.2.2.1/input1
[  137.205146] usb 1-5.2.2.3: new low speed USB device using ehci_hcd and address 15
[  137.269065] ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f7037d20/fffffd20 (bad dma)
[  137.284310] usb 1-5.2.2.3: New USB device found, idVendor=413c, idProduct=3012
[  137.284319] usb 1-5.2.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  137.284327] usb 1-5.2.2.3: Product: Dell USB Optical Mouse
[  137.284333] usb 1-5.2.2.3: Manufacturer: Dell
[  137.288188] input: Dell Dell USB Optical Mouse as /devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5.2/1-5.2.2/1-5.2.2.3/1-5.2.2.3:1.0/input/input17
[  137.288444] generic-usb 0003:413C:3012.0006: input,hidraw2: USB HID v1.11 Mouse [Dell Dell USB Optical Mouse] on usb-0000:00:1a.7-5.2.2.3/input0
[  168.716883] e1000e 0000:00:19.0: irq 50 for MSI/MSI-X
[  168.767220] e1000e 0000:00:19.0: irq 50 for MSI/MSI-X
[  170.459923] e1000e: ethernet NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[  170.459927] e1000e 0000:00:19.0: ethernet: 10/100 speed: disabling TSO
[  182.878328] BUG: sleeping function called from invalid context at mm/slub.c:793
[  182.878339] in_atomic(): 1, irqs_disabled(): 0, pid: 4992, name: qemu
[  182.878355] Pid: 4992, comm: qemu Not tainted 2.6.37+ #31
[  182.878361] Call Trace:
[  182.878381]  [<c104e317>] ? __might_sleep+0xd0/0xd7
[  182.878394]  [<c10ec337>] ? slab_pre_alloc_hook.clone.39+0x23/0x27
[  182.878404]  [<c10ece27>] ? kmem_cache_alloc+0x22/0xc8
[  182.878414]  [<c1030221>] ? init_fpu+0x44/0x7b
[  182.878426]  [<c130cc29>] ? do_device_not_available+0x0/0x1b
[  182.878435]  [<c1030221>] ? init_fpu+0x44/0x7b
[  182.878444]  [<c102a588>] ? math_state_restore+0x24/0x47
[  182.878453]  [<c130cc39>] ? do_device_not_available+0x10/0x1b
[  182.878462]  [<c130c4ab>] ? error_code+0x67/0x6c
[  182.878475]  [<c1012340>] ? kvm_load_guest_fpu+0xa1/0xaa
[  182.878484]  [<c1013364>] ? kvm_arch_vcpu_ioctl_run+0x798/0xbe8
[  182.878496]  [<c1004523>] ? kvm_vcpu_ioctl+0x105/0x46e
[  182.878508]  [<c107dce0>] ? get_futex_key+0x73/0x132
[  182.878517]  [<c107e352>] ? futex_wake+0xb6/0xc0
[  182.878527]  [<c107f8d6>] ? do_futex+0x87/0x669
[  182.878535]  [<c100441e>] ? kvm_vcpu_ioctl+0x0/0x46e
[  182.878545]  [<c1101ebf>] ? do_vfs_ioctl+0x4a0/0x4d1
[  182.878554]  [<c130e348>] ? do_page_fault+0x2eb/0x316
[  182.878564]  [<c1101f36>] ? sys_ioctl+0x46/0x68
[  182.878572]  [<c130bdc0>] ? syscall_call+0x7/0xb
[  182.878585]  [<c1300000>] ? aer_probe+0x1da/0x274
[  184.410920] kvm: 4983: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0xabcd

--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii; name=".config"
Content-Disposition: attachment; filename=".config"

#
# Automatically generated make config: don't edit
# Linux/i386 2.6.37 Kernel Configuration
# Mon Jan 10 12:05:18 2011
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_KTIME_SCALAR=y
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
# CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED is not set
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
# CONFIG_AUTO_IRQ_AFFINITY is not set
# CONFIG_IRQ_PER_CPU is not set
# CONFIG_HARDIRQS_SW_RESEND is not set
# CONFIG_SPARSE_IRQ is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_SRCU_SYNCHRONIZE_DELAY=10
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_PERF_COUNTERS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_32_IRIS is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_IOMMU_API=y
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=0
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_NVS=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_RUNTIME=y
CONFIG_PM_OPS=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_POWER_METER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_OLPC_OPENFIRMWARE is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_HOTPLUG_PCI=m
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
CONFIG_HOTPLUG_PCI_ACPI=m
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
CONFIG_NF_NAT_SIP=y
CONFIG_IP_NF_MANGLE=y
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=m
CONFIG_ATM_BR2684_IPFILTER=y
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_RPS=y
CONFIG_XPS=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=m
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_ZERO=m
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_MII=m
# CONFIG_PHYLIB is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=m
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_STMMAC_ETH is not set
# CONFIG_PCH_GBE is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
CONFIG_WLAN=y
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_ATH_COMMON is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLWIFI=m

#
# Debugging Options
#
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEBUGFS=y
# CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE is not set
CONFIG_IWLWIFI_DEVICE_TRACING=y
CONFIG_IWLAGN=m
# CONFIG_IWL4965 is not set
CONFIG_IWL5000=y
# CONFIG_IWL3945 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
# CONFIG_RTL8192CE is not set
# CONFIG_WL1251 is not set
# CONFIG_WL12XX_MENU is not set
# CONFIG_ZD1211RW is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_NET_INT51X1=m
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_WAN is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=m
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
# CONFIG_ATM_ZATM_DEBUG is not set
CONFIG_ATM_NICSTAR=m
# CONFIG_ATM_NICSTAR_USE_SUNI is not set
# CONFIG_ATM_NICSTAR_USE_IDT77105 is not set
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=m
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=m
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=m
# CONFIG_ATM_HE_USE_SUNI is not set
CONFIG_ATM_SOLOS=m

#
# CAIF transport drivers
#
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m
CONFIG_VMXNET3=m
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ20Z75 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_PKGTEMP=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_LIS3_I2C is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
# CONFIG_MFD_SUPPORT is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
# CONFIG_RC_CORE is not set
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y

#
# Audio decoders
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# MPEG video encoders
#

#
# Video encoders
#

#
# Video improvement chips
#
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_TIMBERDALE is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
# CONFIG_USB_M5602 is not set
# CONFIG_USB_STV06XX is not set
# CONFIG_USB_GL860 is not set
# CONFIG_USB_GSPCA_BENQ is not set
# CONFIG_USB_GSPCA_CONEX is not set
# CONFIG_USB_GSPCA_CPIA1 is not set
# CONFIG_USB_GSPCA_ETOMS is not set
# CONFIG_USB_GSPCA_FINEPIX is not set
# CONFIG_USB_GSPCA_JEILINJ is not set
# CONFIG_USB_GSPCA_KONICA is not set
# CONFIG_USB_GSPCA_MARS is not set
# CONFIG_USB_GSPCA_MR97310A is not set
# CONFIG_USB_GSPCA_OV519 is not set
# CONFIG_USB_GSPCA_OV534 is not set
# CONFIG_USB_GSPCA_OV534_9 is not set
# CONFIG_USB_GSPCA_PAC207 is not set
# CONFIG_USB_GSPCA_PAC7302 is not set
# CONFIG_USB_GSPCA_PAC7311 is not set
# CONFIG_USB_GSPCA_SN9C2028 is not set
# CONFIG_USB_GSPCA_SN9C20X is not set
# CONFIG_USB_GSPCA_SONIXB is not set
# CONFIG_USB_GSPCA_SONIXJ is not set
# CONFIG_USB_GSPCA_SPCA500 is not set
# CONFIG_USB_GSPCA_SPCA501 is not set
# CONFIG_USB_GSPCA_SPCA505 is not set
# CONFIG_USB_GSPCA_SPCA506 is not set
# CONFIG_USB_GSPCA_SPCA508 is not set
# CONFIG_USB_GSPCA_SPCA561 is not set
# CONFIG_USB_GSPCA_SPCA1528 is not set
# CONFIG_USB_GSPCA_SQ905 is not set
# CONFIG_USB_GSPCA_SQ905C is not set
# CONFIG_USB_GSPCA_SQ930X is not set
# CONFIG_USB_GSPCA_STK014 is not set
# CONFIG_USB_GSPCA_STV0680 is not set
# CONFIG_USB_GSPCA_SUNPLUS is not set
# CONFIG_USB_GSPCA_T613 is not set
# CONFIG_USB_GSPCA_TV8532 is not set
# CONFIG_USB_GSPCA_VC032X is not set
# CONFIG_USB_GSPCA_XIRLINK_CIT is not set
# CONFIG_USB_GSPCA_ZC3XX is not set
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_TTM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=256
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
# CONFIG_SND_HDA_INPUT_BEEP is not set
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
# CONFIG_SND_HDA_CODEC_REALTEK is not set
# CONFIG_SND_HDA_CODEC_ANALOG is not set
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
# CONFIG_SND_HDA_CODEC_VIA is not set
# CONFIG_SND_HDA_CODEC_HDMI is not set
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
CONFIG_SND_HDA_CODEC_CONEXANT=y
# CONFIG_SND_HDA_CODEC_CA0110 is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
# CONFIG_SND_HDA_GENERIC is not set
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=60
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
CONFIG_SND_USB_UA101=m
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
# CONFIG_HID_3M_PCT is not set
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_CANDO is not set
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EGALAX is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=m
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LOGITECH=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWII_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=m
# CONFIG_HID_MOSART is not set
CONFIG_HID_MONTEREY=m
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_ROCCAT_PYRA is not set
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_HID_STANTUM is not set
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=m
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# Enable Host or Gadget support to see Inventra options
#

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_UAS is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
# CONFIG_USB_SERIAL_SAMBA is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=m
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=m
CONFIG_USB_SERIAL_ZIO=m
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_ATM is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_DECODE_MCE is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_STAGING=y
# CONFIG_STAGING_EXCLUDE_BUILD is not set
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_USB_DABUSB is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_VICAM is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_BRCM80211 is not set
# CONFIG_RT2860 is not set
# CONFIG_RT2870 is not set
# CONFIG_COMEDI is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTL8192E is not set
# CONFIG_R8712U is not set
# CONFIG_TRANZPORT is not set
# CONFIG_POHMELFS is not set
# CONFIG_LINE6_USB is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_USB_SERIAL_QUATECH_USB2 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_HYPERV is not set
# CONFIG_VME_BUS is not set
# CONFIG_IIO is not set
# CONFIG_ZRAM is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_VIDEO_DT3155 is not set
# CONFIG_CRYSTALHD is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_FB_XGI is not set
# CONFIG_SOLO6X10 is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_MACH_NO_WESTBRIDGE=y
# CONFIG_USB_ENESTORAGE is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_ALSA_SUPPORT is not set
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
CONFIG_ACPI_CMPC=m
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_NILFS2_FS=m
CONFIG_EXPORTFS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=866
CONFIG_FAT_DEFAULT_IOCHARSET="utf-8"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_NFS_FSCACHE=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
CONFIG_NFSD=m
CONFIG_NFSD_DEPRECATED=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CIFS_ACL is not set
CONFIG_CIFS_EXPERIMENTAL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=m
CONFIG_9P_FSCACHE=y
CONFIG_9P_FS_POSIX_ACL=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_BKL is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_PATH is not set
# CONFIG_INTEL_TXT is not set
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_IMA is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_VHOST_NET=m
# CONFIG_LGUEST is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y
CONFIG_AVERAGE=y

--DKU6Jbt7q3WqK7+M--
