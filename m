Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2KGOBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:01:46 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49501 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2KGOBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:01:42 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: [REGRESSION] 3.7-rc3+git hard lockup on CPU after inserting/removing USB stick
Date: Wed, 7 Nov 2012 15:01:38 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.0-tp520; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201211071501.38288.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I had this with something in between 3.7-rc3 und 3.7-rc4 after inserting
and removing an USB stick. This example is with a kernel + f2fs patches v3,
but I had this with 3.7-rc3 as well.

I think it happens on removing the USB stick, but I am not exactly sure. It
might have happened a bit earlier.

Host is an ThinkPad T520.

Is this known already? I didn´t find anything in LKML or git log from today.

Thanks,
Martin


martin@merkaba:~> dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0-rc3-f2fs-v3-tp520+ (martin@merkaba) (gcc version 4.7.2 (Debian 
4.7.2-4) ) #10 SMP PREEMPT Sat Nov 3 14:36:04 CET 2012
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.7.0-rc3-f2fs-v3-tp520+ 
root=/dev/mapper/merkaba-debian ro threadirqs cgroup_enable=memory i915.i915_enable_rc6=7 
init=/bin/systemd
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000d3d9ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d3da0000-0x00000000dae9efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffd20000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021e5fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000021e600000-0x000000021e7fffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: LENOVO 42433WG/42433WG, BIOS 8AET54WW (1.34 ) 11/02/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x21e600 max_arch_pfn = 0x400000000
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
[    0.000000] e820: last_pfn = 0xd3da0 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xd3d9ffff]
[    0.000000]  [mem 0x00000000-0xd3bfffff] page 2M
[    0.000000]  [mem 0xd3c00000-0xd3d9ffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xd3d9ffff @ [mem 0x1fffa000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x21e5fffff]
[    0.000000]  [mem 0x100000000-0x21e5fffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x21e5fffff @ [mem 0xd3d9a000-0xd3d9ffff]
[    0.000000] RAMDISK: [mem 0x36e5a000-0x37724fff]
[    0.000000] ACPI: RSDP 00000000000f00e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000daffe120 000AC (v01 LENOVO TP-8A    00001340 PTEC 00000002)
[    0.000000] ACPI: FACP 00000000dafe8000 000F4 (v04 LENOVO TP-8A    00001340 PTL  00000002)
[    0.000000] ACPI: DSDT 00000000dafeb000 0E44D (v01 LENOVO TP-8A    00001340 INTL 20061109)
[    0.000000] ACPI: FACS 00000000daf2d000 00040
[    0.000000] ACPI: SLIC 00000000daffd000 00176 (v01 LENOVO TP-8A    00001340 PTEC 00000001)
[    0.000000] ACPI: SSDT 00000000daffc000 00249 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffb000 00033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffa000 00797 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET 00000000dafe7000 00038 (v01 LENOVO TP-8A    00001340 PTL  00000002)
[    0.000000] ACPI: APIC 00000000dafe6000 00098 (v01 LENOVO TP-8A    00001340 PTL  00000002)
[    0.000000] ACPI: MCFG 00000000dafe5000 0003C (v01 LENOVO TP-8A    00001340 PTL  00000002)
[    0.000000] ACPI: ECDT 00000000dafe4000 00052 (v01 LENOVO TP-8A    00001340 PTL  00000002)
[    0.000000] ACPI: ASF! 00000000dafea000 000A5 (v32 LENOVO TP-8A    00001340 PTL  00000002)
[    0.000000] ACPI: TCPA 00000000dafe3000 00032 (v02    PTL   LENOVO 06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT 00000000dafe2000 009E5 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000dafe1000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: DMAR 00000000dafe0000 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 00000000dafdf000 0003E (v01 LENOVO TP-8A    00001340 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dafde000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: UEFI 00000000dafdd000 00292 (v01 LENOVO TP-8A    00001340 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000021e5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x21e5fffff]
[    0.000000]   NODE_DATA [mem 0x21e5fc000-0x21e5fffff]
[    0.000000]  [ffffea0000000000-ffffea00087fffff] PMD -> [ffff880215e00000-ffff88021dbfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x21e5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
[    0.000000]   node   0: [mem 0x40200000-0xd3d9ffff]
[    0.000000]   node   0: [mem 0x100000000-0x21e5fffff]
[    0.000000] On node 0 totalpages: 2039597
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 846304 pages, LIFO batch:31
[    0.000000]   Normal zone: 18328 pages used for memmap
[    0.000000]   Normal zone: 1154664 pages, LIFO batch:31
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
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 00000000d3da0000 - 00000000dae9f000
[    0.000000] PM: Registered nosave memory: 00000000dae9f000 - 00000000daf9f000
[    0.000000] PM: Registered nosave memory: 00000000daf9f000 - 00000000dafff000
[    0.000000] PM: Registered nosave memory: 00000000dafff000 - 00000000dfa00000
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
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88021e200000 s83648 r8192 d22848 u262144
[    0.000000] pcpu-alloc: s83648 r8192 d22848 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2004879
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.7.0-rc3-f2fs-v3-tp520+ 
root=/dev/mapper/merkaba-debian ro threadirqs cgroup_enable=memory i915.i915_enable_rc6=7 
init=/bin/systemd
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 7940772k/8886272k available (4201k kernel code, 727884k absent, 217616k 
reserved, 6619k data, 588k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.001000] tsc: Detected 2492.090 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 4984.18 
BogoMIPS (lpj=2492090)
[    0.000119] pid_max: default: 32768 minimum: 301
[    0.000199] Security Framework initialized
[    0.000800] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.002525] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003289] Mount-cache hash table entries: 256
[    0.003561] Initializing cgroup subsys cpuacct
[    0.003620] Initializing cgroup subsys devices
[    0.003678] Initializing cgroup subsys freezer
[    0.003735] Initializing cgroup subsys net_cls
[    0.003791] Initializing cgroup subsys blkio
[    0.003849] Initializing cgroup subsys perf_event
[    0.003930] Disabled fast string operations
[    0.003987] CPU: Physical Processor ID: 0
[    0.004043] CPU: Processor Core ID: 0
[    0.004102] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.004102] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.004186] mce: CPU supports 7 MCE banks
[    0.004262] CPU0: Thermal monitoring enabled (TM1)
[    0.004324] process: using mwait in idle threads
[    0.004384] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.004384] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.004384] tlb_flushall_shift: 5
[    0.004564] Freeing SMP alternatives: 8k freed
[    0.005037] ACPI: Core revision 20120913
[    0.012624] dmar: Host address width 36
[    0.012683] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.012747] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.012823] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.012887] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.012962] dmar: RMRR base: 0x000000dacd5000 end: 0x000000dacebfff
[    0.014384] dmar: RMRR base: 0x000000db800000 end: 0x000000df9fffff
[    0.014515] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.014575] HPET id 0 under DRHD base 0xfed91000
[    0.014633] HPET id 0 under DRHD base 0xfed91000
[    0.014692] HPET id 0 under DRHD base 0xfed91000
[    0.014750] HPET id 0 under DRHD base 0xfed91000
[    0.014808] HPET id 0 under DRHD base 0xfed91000
[    0.014865] HPET id 0 under DRHD base 0xfed91000
[    0.014922] HPET id 0 under DRHD base 0xfed91000
[    0.014980] HPET id 0 under DRHD base 0xfed91000
[    0.015284] Enabled IRQ remapping in x2apic mode
[    0.015344] Enabling x2apic
[    0.015399] Enabled x2apic
[    0.015472] Switched APIC routing to cluster x2apic.
[    0.015984] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.026024] smpboot: CPU0: Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz (fam: 06, model: 2a, 
stepping: 07)
[    0.127966] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.128202] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.128277] ... version:                3
[    0.128335] ... bit width:              48
[    0.128393] ... generic registers:      4
[    0.128450] ... value mask:             0000ffffffffffff
[    0.128510] ... max period:             000000007fffffff
[    0.128569] ... fixed-purpose events:   3
[    0.128626] ... event mask:             000000070000000f
[    0.147173] Disabled fast string operations
[    0.149393] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.162090] Disabled fast string operations
[    0.177112] Disabled fast string operations
[    0.136082] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.179217] Brought up 4 CPUs
[    0.179383] smpboot: Total of 4 processors activated (19936.72 BogoMIPS)
[    0.182840] devtmpfs: initialized
[    0.186494] PM: Registering ACPI NVS region [mem 0xdae9f000-0xdaf9efff] (1048576 bytes)
[    0.186689] NET: Registered protocol family 16
[    0.186952] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.187028] ACPI: bus type pci registered
[    0.187330] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 
0xf8000000)
[    0.187409] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.191130] PCI: Using configuration type 1 for base access
[    0.192175] bio: create slab <bio-0> at 0
[    0.192297] ACPI: Added _OSI(Module Device)
[    0.192355] ACPI: Added _OSI(Processor Device)
[    0.192414] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.192473] ACPI: Added _OSI(Processor Aggregator Device)
[    0.194350] ACPI: EC: EC description table is found, configuring boot EC
[    0.199800] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.207645] ACPI: SSDT 00000000dae8c018 008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.208273] ACPI: Dynamic OEM Table Load:
[    0.208409] ACPI: SSDT           (null) 008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.208831] ACPI: SSDT 00000000dae8da98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.209493] ACPI: Dynamic OEM Table Load:
[    0.209630] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.209899] ACPI: SSDT 00000000dae8bd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.210511] ACPI: Dynamic OEM Table Load:
[    0.210646] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.211411] ACPI: Interpreter enabled
[    0.211470] ACPI: (supports S0 S3 S4 S5)
[    0.211700] ACPI: Using IOAPIC for interrupt routing
[    0.214756] ACPI: Power Resource [PUBS] (on)
[    0.218168] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.219073] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.219138] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.219322] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.219410] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only 
partially covers this bridge
[    0.219515] PCI host bridge to bus 0000:00
[    0.219573] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.219633] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.219695] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.219757] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.219820] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff]
[    0.219884] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.219954] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.219993] pci 0000:00:02.0: [8086:0126] type 00 class 0x030000
[    0.220004] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.220010] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.220015] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
[    0.220079] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.220104] pci 0000:00:16.0: reg 10: [mem 0xf2525000-0xf252500f 64bit]
[    0.220186] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.220222] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    0.220241] pci 0000:00:19.0: reg 10: [mem 0xf2500000-0xf251ffff]
[    0.220250] pci 0000:00:19.0: reg 14: [mem 0xf252b000-0xf252bfff]
[    0.220259] pci 0000:00:19.0: reg 18: [io  0x5080-0x509f]
[    0.220324] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.220352] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.220374] pci 0000:00:1a.0: reg 10: [mem 0xf252a000-0xf252a3ff]
[    0.220466] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.220494] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.220511] pci 0000:00:1b.0: reg 10: [mem 0xf2520000-0xf2523fff 64bit]
[    0.220581] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.220607] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.220688] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.220718] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.220798] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.220827] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
[    0.220907] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.220938] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
[    0.221070] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.221117] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.221139] pci 0000:00:1d.0: reg 10: [mem 0xf2529000-0xf25293ff]
[    0.221231] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.221260] pci 0000:00:1f.0: [8086:1c4f] type 00 class 0x060100
[    0.221389] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
[    0.221408] pci 0000:00:1f.2: reg 10: [io  0x50a8-0x50af]
[    0.221416] pci 0000:00:1f.2: reg 14: [io  0x50b4-0x50b7]
[    0.221425] pci 0000:00:1f.2: reg 18: [io  0x50a0-0x50a7]
[    0.221433] pci 0000:00:1f.2: reg 1c: [io  0x50b0-0x50b3]
[    0.221442] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
[    0.221450] pci 0000:00:1f.2: reg 24: [mem 0xf2528000-0xf25287ff]
[    0.221497] pci 0000:00:1f.2: PME# supported from D3hot
[    0.221517] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.221534] pci 0000:00:1f.3: reg 10: [mem 0xf2524000-0xf25240ff 64bit]
[    0.221556] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.221632] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.221905] pci 0000:03:00.0: [8086:0085] type 00 class 0x028000
[    0.222073] pci 0000:03:00.0: reg 10: [mem 0xf2400000-0xf2401fff 64bit]
[    0.222843] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.225202] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.225270] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.225324] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.225387] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.225391] pci 0000:00:1c.3:   bridge window [mem 0xf1c00000-0xf23fffff]
[    0.225398] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.225541] pci 0000:0d:00.0: [1180:e822] type 00 class 0x088001
[    0.225568] pci 0000:0d:00.0: reg 10: [mem 0xf1401000-0xf14010ff]
[    0.225806] pci 0000:0d:00.0: supports D1 D2
[    0.225808] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.225880] pci 0000:0d:00.3: [1180:e832] type 00 class 0x0c0010
[    0.225906] pci 0000:0d:00.3: reg 10: [mem 0xf1400000-0xf14007ff]
[    0.226105] pci 0000:0d:00.3: supports D1 D2
[    0.226107] pci 0000:0d:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.227822] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.227903] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.227909] pci 0000:00:1c.4:   bridge window [mem 0xf1400000-0xf1bfffff]
[    0.227918] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.227943] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.228048] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.228076] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.228108] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.228138] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    0.228269]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.228481]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x0d
[    0.228557] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.230743] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.231260] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 9 10 11)
[    0.231760] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.232271] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.232774] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11)
[    0.233279] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.233876] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11)
[    0.234386] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11)
[    0.234926] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.235004] vgaarb: loaded
[    0.235064] vgaarb: bridge control possible 0000:00:02.0
[    0.235163] PCI: Using ACPI for IRQ routing
[    0.236960] PCI: pci_cache_line_size set to 64 bytes
[    0.237171] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.237173] e820: reserve RAM buffer [mem 0xd3da0000-0xd3ffffff]
[    0.237175] e820: reserve RAM buffer [mem 0x21e600000-0x21fffffff]
[    0.237313] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.237728] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.239802] Switching to clocksource hpet
[    0.241510] pnp: PnP ACPI init
[    0.241578] ACPI: bus type pnp registered
[    0.241985] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.241987] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.241989] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.241991] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.241993] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.241994] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    0.241996] pnp 00:00: [mem 0x000d4000-0x000d7fff]
[    0.241998] pnp 00:00: [mem 0x000d8000-0x000dbfff]
[    0.241999] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    0.242001] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.242003] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.242004] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.242006] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.242008] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.242010] pnp 00:00: [mem 0x00100000-0xdf9fffff]
[    0.242011] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    0.242013] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    0.242057] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.242120] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.242182] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.242245] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.242308] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.242371] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.242433] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.242496] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.242559] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.242621] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.242685] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.242748] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.242812] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.242887] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.242951] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
[    0.243016] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.243079] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.243143] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.243161] pnp 00:01: [bus 00-fe]
[    0.243163] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.243165] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.243167] pnp 00:01: [io  0x0d00-0xffff window]
[    0.243169] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.243170] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    0.243172] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    0.243174] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    0.243176] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    0.243178] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    0.243179] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    0.243181] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    0.243183] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    0.243185] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    0.243187] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    0.243188] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    0.243190] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    0.243194] pnp 00:01: [mem 0xdfa00000-0xfebfffff window]
[    0.243196] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    0.243227] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.243283] pnp 00:02: [io  0x0010-0x001f]
[    0.243285] pnp 00:02: [io  0x0090-0x009f]
[    0.243287] pnp 00:02: [io  0x0024-0x0025]
[    0.243288] pnp 00:02: [io  0x0028-0x0029]
[    0.243290] pnp 00:02: [io  0x002c-0x002d]
[    0.243291] pnp 00:02: [io  0x0030-0x0031]
[    0.243293] pnp 00:02: [io  0x0034-0x0035]
[    0.243295] pnp 00:02: [io  0x0038-0x0039]
[    0.243296] pnp 00:02: [io  0x003c-0x003d]
[    0.243298] pnp 00:02: [io  0x00a4-0x00a5]
[    0.243299] pnp 00:02: [io  0x00a8-0x00a9]
[    0.243301] pnp 00:02: [io  0x00ac-0x00ad]
[    0.243303] pnp 00:02: [io  0x00b0-0x00b5]
[    0.243304] pnp 00:02: [io  0x00b8-0x00b9]
[    0.243306] pnp 00:02: [io  0x00bc-0x00bd]
[    0.243307] pnp 00:02: [io  0x0050-0x0053]
[    0.243309] pnp 00:02: [io  0x0072-0x0077]
[    0.243311] pnp 00:02: [io  0x0400-0x047f]
[    0.243312] pnp 00:02: [io  0x0500-0x057f]
[    0.243314] pnp 00:02: [io  0x0800-0x080f]
[    0.243315] pnp 00:02: [io  0x15e0-0x15ef]
[    0.243317] pnp 00:02: [io  0x1600-0x167f]
[    0.243319] pnp 00:02: [mem 0xf8000000-0xfbffffff]
[    0.243321] pnp 00:02: [mem 0x00000000-0x00000fff]
[    0.243322] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    0.243324] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    0.243326] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    0.243327] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    0.243329] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    0.243379] system 00:02: [io  0x0400-0x047f] has been reserved
[    0.243442] system 00:02: [io  0x0500-0x057f] has been reserved
[    0.243503] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.243564] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.243626] system 00:02: [io  0x1600-0x167f] has been reserved
[    0.243687] system 00:02: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.243750] system 00:02: [mem 0x00000000-0x00000fff] could not be reserved
[    0.243813] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.243887] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.243950] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.244012] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.244074] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.244138] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.244178] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.244199] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.244207] pnp 00:04: [io  0x0000-0x000f]
[    0.244209] pnp 00:04: [io  0x0080-0x008f]
[    0.244211] pnp 00:04: [io  0x00c0-0x00df]
[    0.244213] pnp 00:04: [dma 4]
[    0.244233] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.244240] pnp 00:05: [io  0x0061]
[    0.244259] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.244267] pnp 00:06: [io  0x00f0]
[    0.244279] pnp 00:06: [irq 13]
[    0.244300] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.244309] pnp 00:07: [io  0x0070-0x0071]
[    0.244316] pnp 00:07: [irq 8]
[    0.244336] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.244344] pnp 00:08: [io  0x0060]
[    0.244346] pnp 00:08: [io  0x0064]
[    0.244353] pnp 00:08: [irq 1]
[    0.244373] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.244385] pnp 00:09: [irq 12]
[    0.244405] pnp 00:09: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
[    0.244435] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.244462] pnp 00:0a: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.244924] pnp: PnP ACPI: found 11 devices
[    0.244982] ACPI: ACPI bus type pnp unregistered
[    0.251568] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.251639] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.251702] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.251771] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.251832] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.251906] pci 0000:00:1c.3:   bridge window [mem 0xf1c00000-0xf23fffff]
[    0.251972] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.252052] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.252114] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.252180] pci 0000:00:1c.4:   bridge window [mem 0xf1400000-0xf1bfffff]
[    0.252246] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.252364] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.252366] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.252368] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.252370] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff]
[    0.252372] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    0.252374] pci_bus 0000:03: resource 1 [mem 0xf2400000-0xf24fffff]
[    0.252376] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.252378] pci_bus 0000:05: resource 1 [mem 0xf1c00000-0xf23fffff]
[    0.252380] pci_bus 0000:05: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.252382] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.252383] pci_bus 0000:0d: resource 1 [mem 0xf1400000-0xf1bfffff]
[    0.252385] pci_bus 0000:0d: resource 2 [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.252415] NET: Registered protocol family 2
[    0.253153] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.254398] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.254582] TCP: Hash tables configured (established 524288 bind 65536)
[    0.254669] TCP: reno registered
[    0.254741] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.254830] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.255004] NET: Registered protocol family 1
[    0.255074] pci 0000:00:02.0: Boot video device
[    0.255246] PCI: CLS 64 bytes, default 64
[    0.255285] Unpacking initramfs...
[    0.843809] Freeing initrd memory: 9004k freed
[    0.845415] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.845484] software IO TLB [mem 0xcfd9a000-0xd3d99fff] (64MB) mapped at [ffff8800cfd9a000-
ffff8800d3d99fff]
[    0.846013] audit: initializing netlink socket (disabled)
[    0.846087] type=2000 audit(1351955887.740:1): initialized
[    0.865941] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.867811] VFS: Disk quotas dquot_6.5.2
[    0.867908] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.868063] msgmni has been set to 15526
[    0.868637] alg: No test for stdrng (krng)
[    0.870125] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.870232] io scheduler noop registered
[    0.870291] io scheduler deadline registered
[    0.870373] io scheduler cfq registered (default)
[    0.870715] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.870797] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.870858] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.871083] acpiphp: Slot [1] registered
[    0.871234] intel_idle: MWAIT substates: 0x21120
[    0.871236] intel_idle: v0.4 model 0x2A
[    0.871237] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.871300] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.871533] ACPI: Lid Switch [LID]
[    0.871632] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.871711] ACPI: Sleep Button [SLPB]
[    0.871813] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.871889] ACPI: Power Button [PWRF]
[    0.871975] GHES: HEST is not enabled!
[    0.872083] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.872574] Linux agpgart interface v0.103
[    0.872694] [drm] Initialized drm 1.1.0 20060810
[    0.872972] pci 0000:00:00.0: Intel Sandybridge Chipset
[    0.873083] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.873969] pci 0000:00:00.0: detected 65536K stolen memory
[    0.874082] i915 0000:00:02.0: setting latency timer to 64
[    0.894819] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.894828] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.894891] [drm] Driver supports precise vblank timestamp query.
[    0.894986] vgaarb: device changed decodes: 
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.987525] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp on
[    1.083114] fbcon: inteldrmfb (fb0) is primary device
[    1.846255] tsc: Refined TSC clocksource calibration: 2491.906 MHz
[    1.846261] Switching to clocksource tsc
[    1.993853] Console: switching to colour frame buffer device 240x67
[    2.001851] fb0: inteldrmfb frame buffer device
[    2.001887] drm: registered panic notifier
[    2.004085] acpi device:01: registered as cooling_device0
[    2.004203] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    2.004285] input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    2.004372] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.004454] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    2.004582] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.011312] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.011372] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.011499] mousedev: PS/2 mouse device common for all mice
[    2.011576] rtc_cmos 00:07: RTC can wake from S4
[    2.011728] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    2.011817] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.011951] cpuidle: using governor ladder
[    2.012075] cpuidle: using governor menu
[    2.012195] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[    2.012236] acerhdf: unknown (unsupported) BIOS version LENOVO/42433WG/8AET54WW (1.34 ), 
please report, aborting!
[    2.012341] drop_monitor: Initializing network drop monitor service
[    2.012458] TCP: cubic registered
[    2.012573] NET: Registered protocol family 10
[    2.012767] mip6: Mobile IPv6
[    2.012790] NET: Registered protocol family 17
[    2.012832] lib80211: common routines for IEEE802.11 drivers
[    2.012878] lib80211_crypt: registered algorithm 'NULL'
[    2.012880] lib80211_crypt: registered algorithm 'WEP'
[    2.012881] lib80211_crypt: registered algorithm 'CCMP'
[    2.012883] lib80211_crypt: registered algorithm 'TKIP'
[    2.012892] Key type dns_resolver registered
[    2.013331] PM: Hibernation image not present or could not be loaded.
[    2.013339] registered taskstats version 1
[    2.014306] rtc_cmos 00:07: setting system clock to 2012-11-03 15:18:09 UTC (1351955889)
[    2.014368] p4-clockmod: Warning: EST-capable CPU detected. The acpi-cpufreq module offers voltage 
scaling in addition to frequency scaling. You should use that instead of p4-clockmod, if possible.
[    2.015245] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.015679] Freeing unused kernel memory: 588k freed
[    2.015804] Write protecting the kernel read-only data: 10240k
[    2.022196] Freeing unused kernel memory: 1932k freed
[    2.028481] Freeing unused kernel memory: 1836k freed
[    2.083199] udevd[81]: starting version 175
[    2.101578] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
[    2.101642] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    2.102148] e1000e 0000:00:19.0: setting latency timer to 64
[    2.102231] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative 
mode
[    2.102361] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    2.112075] ACPI: bus type usb registered
[    2.112168] usbcore: registered new interface driver usbfs
[    2.115757] usbcore: registered new interface driver hub
[    2.121861] usbcore: registered new device driver usb
[    2.124892] thermal LNXTHERM:00: registered as thermal_zone0
[    2.127753] ACPI: Thermal Zone [THM0] (52 C)
[    2.130562] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.135074] sdhci: Secure Digital Host Controller Interface driver
[    2.138068] SCSI subsystem initialized
[    2.139333] sdhci: Copyright(c) Pierre Ossman
[    2.143447] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e822] (rev 8)
[    2.146550] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x23
[    2.150177] microcode: CPU0 updated to revision 0x28, date = 2012-04-24
[    2.153145] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x23
[    2.155900] ACPI: bus type scsi registered
[    2.156246] microcode: CPU1 updated to revision 0x28, date = 2012-04-24
[    2.156254] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x23
[    2.156595] microcode: CPU2 updated to revision 0x28, date = 2012-04-24
[    2.156645] Registered led device: mmc0::
[    2.166550] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x23
[    2.169460] microcode: CPU3 updated to revision 0x28, date = 2012-04-24
[    2.172055] perf_event_intel: PEBS enabled due to microcode update
[    2.174857] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.179516] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[    2.182791] libata version 3.00 loaded.
[    2.186251] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    2.235702] firewire_ohci 0000:0d:00.3: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, 
quirks 0x11
[    2.313622] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) f0:de:f1:5b:15:44
[    2.315801] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    2.318023] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: 1000FF-0FF
[    2.320282] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.320288] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    2.322906] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.329453] ehci_hcd 0000:00:1a.0: debug port 2
[    2.331635] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    2.331684] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf252a000
[    2.339295] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.341482] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.343600] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.345711] usb usb1: Product: EHCI Host Controller
[    2.347797] usb usb1: Manufacturer: Linux 3.7.0-rc3-f2fs-v3-tp520+ ehci_hcd
[    2.349927] usb usb1: SerialNumber: 0000:00:1a.0
[    2.352244] hub 1-0:1.0: USB hub found
[    2.354348] hub 1-0:1.0: 3 ports detected
[    2.356603] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.356607] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    2.358706] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.364711] ehci_hcd 0000:00:1d.0: debug port 2
[    2.366794] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    2.366900] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf2529000
[    2.374215] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.376365] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.378442] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.380495] usb usb2: Product: EHCI Host Controller
[    2.382536] usb usb2: Manufacturer: Linux 3.7.0-rc3-f2fs-v3-tp520+ ehci_hcd
[    2.384617] usb usb2: SerialNumber: 0000:00:1d.0
[    2.386870] hub 2-0:1.0: USB hub found
[    2.388940] hub 2-0:1.0: 3 ports detected
[    2.391165] ahci 0000:00:1f.2: version 3.0
[    2.391251] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    2.391290] ahci: SSS flag set, parallel bus scan disabled
[    2.404152] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1b impl SATA mode
[    2.406232] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
[    2.408321] ahci 0000:00:1f.2: setting latency timer to 64
[    2.414815] scsi0 : ahci
[    2.416906] scsi1 : ahci
[    2.418943] scsi2 : ahci
[    2.420955] scsi3 : ahci
[    2.422944] scsi4 : ahci
[    2.424908] scsi5 : ahci
[    2.426816] ata1: SATA max UDMA/133 abar m2048@0xf2528000 port 0xf2528100 irq 44
[    2.428695] ata2: SATA max UDMA/133 abar m2048@0xf2528000 port 0xf2528180 irq 44
[    2.430559] ata3: DUMMY
[    2.432401] ata4: SATA max UDMA/133 abar m2048@0xf2528000 port 0xf2528280 irq 44
[    2.434282] ata5: SATA max UDMA/133 abar m2048@0xf2528000 port 0xf2528300 irq 44
[    2.436163] ata6: DUMMY
[    2.657580] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    2.737542] firewire_core 0000:0d:00.3: created device fw0: GUID f0def1ff5b1544ff, S400
[    2.742379] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.745107] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.745111] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.747027] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.749477] ata1.00: ATA-8: INTEL SSDSA2CW300G3, 4PC10362, max UDMA/133
[    2.751366] ata1.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.753349] ata1.00: failed to get Identify Device Data, Emask 0x1
[    2.754348] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.754352] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.756269] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.758885] ata1.00: failed to get Identify Device Data, Emask 0x1
[    2.758889] ata1.00: configured for UDMA/133
[    2.762466] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2CW30 4PC1 PQ: 0 ANSI: 5
[    2.774531] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    2.776445] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.778721] hub 1-1:1.0: USB hub found
[    2.780840] hub 1-1:1.0: 6 ports detected
[    2.885979] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    3.002306] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    3.004239] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.006477] hub 2-1:1.0: USB hub found
[    3.008669] hub 2-1:1.0: 8 ports detected
[    3.069646] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.075774] usb 1-1.3: new full-speed USB device number 3 using ehci_hcd
[    3.165375] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
[    3.167257] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.169100] usb 1-1.3: Product: Biometric Coprocessor
[    3.170906] usb 1-1.3: Manufacturer: UPEK
[    3.195403] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 (IDLE) succeeded
[    3.195758] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 (IDLE) succeeded
[    3.195763] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.199331] ata2.00: ATAPI: HL-DT-STDVDRAM GT33N, LT20, max UDMA/66
[    3.204643] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 (IDLE) succeeded
[    3.204983] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 (IDLE) succeeded
[    3.204987] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.208554] ata2.00: configured for UDMA/66
[    3.213824] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GT33N     LT20 PQ: 0 ANSI: 5
[    2.764787] ACPI: Invalid Power Resource to register!
[    3.216093] ACPI: Invalid Power Resource to register!<6>[    3.287398] usb 2-1.5: new full-speed USB 
device number 3 using ehci_hcd
[    3.370864] usb 2-1.5: New USB device found, idVendor=17ef, idProduct=1003
[    3.372807] usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.374686] usb 2-1.5: Product: Integrated Smart Card Reader
[    3.376553] usb 2-1.5: Manufacturer: Lenovo
[    3.520655] ata4: SATA link down (SStatus 0 SControl 300)
[    3.826930] ata5: SATA link down (SStatus 0 SControl 300)
[    3.833234] sd 0:0:0:0: [sda] 586072368 512-byte logical blocks: (300 GB/279 GiB)
[    3.835328] sd 0:0:0:0: [sda] Write Protect is off
[    3.835600] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.835601] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.835796] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.841039] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.841062] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.843611]  sda: sda1 sda2 sda3 sda4
[    3.846181] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.850720] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.852782] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    3.901838] device-mapper: uevent: version 1.0.3
[    3.903945] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[    3.976102] bio: create slab <bio-1> at 1
[    4.044626] Btrfs loaded
[    4.066447] device label debian devid 1 transid 215102 /dev/dm-0
[    4.071404] PM: Starting manual resume from disk
[    4.073540] PM: Hibernation image partition 254:1 present
[    4.073541] PM: Looking for hibernation image.
[    4.076660] PM: Image not found (code -22)
[    4.076668] PM: Hibernation image not present or could not be loaded.
[    4.081570] PM: Marking nosave pages: [mem 0x0009d000-0x000fffff]
[    4.081574] PM: Marking nosave pages: [mem 0x20000000-0x201fffff]
[    4.081583] PM: Marking nosave pages: [mem 0x40000000-0x401fffff]
[    4.081591] PM: Marking nosave pages: [mem 0xd3da0000-0xffffffff]
[    4.082497] PM: Basic memory bitmaps created
[    4.117237] PM: Basic memory bitmaps freed
[    4.117244] video LNXVIDEO:00: Restoring backlight state
[    4.133605] device label debian devid 1 transid 215102 /dev/mapper/merkaba-debian
[    4.143142] btrfs: disk space caching is enabled
[    4.166425] Btrfs detected SSD devices, enabling SSD mode
[    4.539995] fuse init (API version 7.20)
[    4.564543] loop: module loaded
[    4.567946] hdaps: supported laptop not found!
[    4.567947] hdaps: driver init failed (ret=-19)!
[    4.569973] udevd[391]: starting version 175
[    4.671811] ACPI: Requesting acpi_cpufreq
[    4.724558] tpm_tis 00:0a: 1.2 TPM (device-id 0x0, rev-id 78)
[    4.747813] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    4.750657] ACPI: AC Adapter [AC] (on-line)
[    4.754372] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region 
\_SB_.PCI0.LPC_.PMIO 1 (20120913/utaddress-251)
[    4.757724] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    4.760678] ACPI: If an ACPI driver is available for this device, you should use it instead of the native 
driver
[    4.762803] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region 
\_SB_.PCI0.LPC_.LPIO 1 (20120913/utaddress-251)
[    4.764833] cfg80211: Calling CRDA to update world regulatory domain
[    4.766792] ACPI: If an ACPI driver is available for this device, you should use it instead of the native 
driver
[    4.768745] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region 
\_SB_.PCI0.LPC_.LPIO 1 (20120913/utaddress-251)
[    4.770747] ACPI: If an ACPI driver is available for this device, you should use it instead of the native 
driver
[    4.779711] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region 
\_SB_.PCI0.LPC_.LPIO 1 (20120913/utaddress-251)
[    4.788968] Intel(R) Wireless WiFi driver for Linux, in-tree:
[    4.789623] ACPI: If an ACPI driver is available for this device, you should use it instead of the native 
driver
[    4.789625] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    4.795255] Copyright(c) 2003-2012 Intel Corporation
[    4.797728] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
[    4.800173] iwlwifi 0000:03:00.0: pci_resource_base = ffffc900056ac000
[    4.802545] iwlwifi 0000:03:00.0: HW Revision ID = 0x34
[    4.805140] iwlwifi 0000:03:00.0: irq 45 for MSI/MSI-X
[    4.829676] ACPI: Battery Slot [BAT0] (battery present)
[    4.867482] btrfs: use lzo compression
[    4.869722] btrfs: disk space caching is enabled
[    4.877610] iwlwifi 0000:03:00.0: loaded firmware version 17.168.5.3 build 42301
[    4.885763] Non-volatile memory driver v1.3
[    4.889345] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    4.891516] thinkpad_acpi: http://ibm-acpi.sf.net/
[    4.893335] thinkpad_acpi: ThinkPad BIOS 8AET54WW (1.34 ), EC unknown
[    4.895223] thinkpad_acpi: Lenovo ThinkPad T520, model 42433WG
[    4.900193] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[    4.903888] iwldvm: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    4.906312] iwldvm: Copyright(c) 2003-2012 Intel Corporation
[    4.908739] thinkpad_acpi: radio switch found; radios are disabled
[    4.908780] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    4.908781] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    4.908783] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    4.908784] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[    4.908785] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
[    4.908787] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205 AGN, REV=0xB0
[    4.923355] cfg80211: World regulatory domain updated:
[    4.923357] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    4.923359] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.923361] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    4.923362] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    4.923364] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.923365] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.944294] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by 
the ACPI video driver
[    4.944299] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[    4.944546] iwlwifi 0000:03:00.0: RF_KILL bit toggled to disable radio.
[    4.950980] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    4.955114] iwlwifi 0000:03:00.0: device EEPROM VER=0x715, CALIB=0x6
[    4.955116] iwlwifi 0000:03:00.0: Device SKU: 0x1F0
[    4.955117] iwlwifi 0000:03:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
[    4.955231] Registered led device: phy0-led
[    4.955322] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    4.958999] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
[    4.959689] Registered led device: tpacpi::thinklight
[    4.959763] Registered led device: tpacpi::power
[    4.959795] Registered led device: tpacpi::standby
[    4.959817] Registered led device: tpacpi::thinkvantage
[    4.959826] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[    4.960273] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    4.962511] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
[    4.974408] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    4.989207] hda_codec: CX20590: BIOS auto-probing.
[    4.992989] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
[    4.993127] device label debian devid 1 transid 215102 /dev/dm-0
[    5.005026] input: HDA Intel PCH HDMI/DP,pcm=8 as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    5.010471] input: HDA Intel PCH HDMI/DP,pcm=7 as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    5.012571] input: HDA Intel PCH HDMI/DP,pcm=3 as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    5.019621] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    5.026528] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    5.034330] input: HDA Intel PCH Dock Headphone as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    5.041230] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[    5.067686] Adding 12582908k swap on /dev/mapper/merkaba-swap.  Priority:0 extents:1 
across:12582908k SS
[    5.293922] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    5.316254] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[    5.330538] FAT-fs (sda2): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be 
case sensitive!
[    5.962021] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 
0xd047b3/0xb40000/0xa0000, board id: 71, fw id: 578367
[    5.962028] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    6.033609] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input15
[    6.396266] Ebtables v2.0 registered
[    6.415692] ip_tables: (C) 2000-2006 Netfilter Core Team
[    6.426057] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    6.445537] cgroup: libvirtd (1763) created nested cgroup for controller "devices" which has incomplete 
hierarchy support. Nested cgroups may change behavior in the future.
[    6.445566] cgroup: libvirtd (1763) created nested cgroup for controller "freezer" which has incomplete 
hierarchy support. Nested cgroups may change behavior in the future.
[    6.445588] cgroup: libvirtd (1763) created nested cgroup for controller "blkio" which has incomplete 
hierarchy support. Nested cgroups may change behavior in the future.
[    6.784429] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    6.884902] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    6.885135] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.194609] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input16
[   14.764988] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   15.112317] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input17
[  128.432667] usb 1-1.1: new high-speed USB device number 4 using ehci_hcd
[  128.519833] usb 1-1.1: New USB device found, idVendor=1307, idProduct=0163
[  128.519836] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  128.519838] usb 1-1.1: Product: USB Mass Storage Device
[  128.519840] usb 1-1.1: Manufacturer: USBest Technology
[  128.519841] usb 1-1.1: SerialNumber: 00000000000D6B
[  128.535935] usbcore: registered new interface driver uas
[  128.539492] Initializing USB Mass Storage driver...
[  128.544749] scsi6 : usb-storage 1-1.1:1.0
[  128.544855] usbcore: registered new interface driver usb-storage
[  128.544857] USB Mass Storage support registered.
[  129.545142] scsi 6:0:0:0: Direct-Access     TinyDisk 2007-05-12       0.00 PQ: 0 ANSI: 2
[  129.545801] sd 6:0:0:0: Attached scsi generic sg2 type 0
[  129.546692] sd 6:0:0:0: [sdb] 4095999 512-byte logical blocks: (2.09 GB/1.95 GiB)
[  129.547436] sd 6:0:0:0: [sdb] Write Protect is off
[  129.547440] sd 6:0:0:0: [sdb] Mode Sense: 00 00 00 00
[  129.548231] sd 6:0:0:0: [sdb] Asking for cache data failed
[  129.548235] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  129.552085] sd 6:0:0:0: [sdb] Asking for cache data failed
[  129.552090] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  129.606358]  sdb: sdb4
[  129.609178] sd 6:0:0:0: [sdb] Asking for cache data failed
[  129.609182] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  129.609186] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[  130.598825] psmouse serio1: TouchPad at isa0060/serio1/input0 lost synchronization, throwing 5 bytes 
away.
[  137.448223] ------------[ cut here ]------------
[  137.448230] WARNING: at kernel/watchdog.c:245 watchdog_overflow_callback+0x80/0xa2()
[  137.448231] Hardware name: 42433WG
[  137.448232] Watchdog detected hard LOCKUP on cpu 3
[  137.448234] Modules linked in: usb_storage uas binfmt_misc ip6table_filter ip6_tables iptable_filter 
ip_tables ebtable_nat ebtables x_tables cpufreq_conservative cpufreq_powersave cpufreq_stats 
cpufreq_userspace uinput joydev nls_utf8 nls_cp437 vfat fat ext4 crc16 jbd2 mbcache 
snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss iwldvm snd_pcm mac80211 thinkpad_acpi nvram snd_page_alloc snd_seq_midi 
snd_seq_midi_event snd_rawmidi snd_seq battery snd_seq_device iwlwifi snd_timer snd psmouse 
cfg80211 pcspkr serio_raw lpc_ich mfd_core i2c_i801 ac soundcore rfkill tpm_tis tpm tpm_bios 
acpi_cpufreq evdev mperf kvm_intel kvm processor sbs sbshc coretemp input_polldev loop firewire_sbp2 
fuse ecryptfs autofs4 btrfs libcrc32c zlib_deflate md_mod dm_mirror dm_region_hash dm_log dm_mod sg 
sd_mod sr_mod cdrom crc_t10dif crc32c_intel ghash_clmulni_intel ahci libahci aesni_intel firewire_ohci 
aes_x86_64 xts lrw gf128mul ablk_helper cryptd firewire_core crc_itu_t 
libata microcode sdhci_pci scsi_mod sdhci mmc_core ehci_hcd thermal usbcore usb_common e1000e
[  137.448302] Pid: 230, comm: irq/16-ehci_hcd Not tainted 3.7.0-rc3-f2fs-v3-tp520+ #10
[  137.448304] Call Trace:
[  137.448305]  <NMI>  [<ffffffff8103fb9f>] warn_slowpath_common+0x7e/0x97
[  137.448312]  [<ffffffff8103fc4c>] warn_slowpath_fmt+0x41/0x43
[  137.448315]  [<ffffffff8106b64c>] ? local_clock+0x2e/0x39
[  137.448317]  [<ffffffff810a5359>] watchdog_overflow_callback+0x80/0xa2
[  137.448320]  [<ffffffff810ca443>] __perf_event_overflow+0x134/0x1c2
[  137.448324]  [<ffffffff8101c518>] ? x86_perf_event_set_period+0x103/0x114
[  137.448326]  [<ffffffff810cac2d>] perf_event_overflow+0x14/0x16
[  137.448328]  [<ffffffff81020b6b>] intel_pmu_handle_irq+0x25f/0x2cd
[  137.448331]  [<ffffffff8141357c>] perf_event_nmi_handler+0x19/0x1b
[  137.448333]  [<ffffffff81412e8c>] nmi_handle.isra.1+0x4a/0x74
[  137.448339]  [<ffffffffa007d71a>] ? end_free_itds+0x106/0x106 [ehci_hcd]
[  137.448341]  [<ffffffff81412f5c>] do_nmi+0xa6/0x2c1
[  137.448343]  [<ffffffff814126e0>] end_repeat_nmi+0x1e/0x2e
[  137.448348]  [<ffffffffa007d71a>] ? end_free_itds+0x106/0x106 [ehci_hcd]
[  137.448351]  [<ffffffff81411d4c>] ? _raw_spin_lock_irqsave+0x3b/0x48
[  137.448354]  [<ffffffff81411d4c>] ? _raw_spin_lock_irqsave+0x3b/0x48
[  137.448356]  [<ffffffff81411d4c>] ? _raw_spin_lock_irqsave+0x3b/0x48
[  137.448357]  <<EOE>>  <IRQ>  [<ffffffffa007d742>] ehci_hrtimer_func+0x28/0xb5 [ehci_hcd]
[  137.448366]  [<ffffffff8105e385>] ? __remove_hrtimer+0x31/0x8b
[  137.448370]  [<ffffffffa007d71a>] ? end_free_itds+0x106/0x106 [ehci_hcd]
[  137.448373]  [<ffffffff8105e80b>] __run_hrtimer+0xb9/0x176
[  137.448375]  [<ffffffff8105eef9>] hrtimer_interrupt+0xcb/0x1b4
[  137.448378]  [<ffffffff810a6445>] ? irq_thread_fn+0x35/0x35
[  137.448381]  [<ffffffff8102b012>] smp_apic_timer_interrupt+0x71/0x84
[  137.448384]  [<ffffffff814172dd>] apic_timer_interrupt+0x6d/0x80
[  137.448384]  <EOI>  [<ffffffffa008047a>] ? ehci_irq+0x39/0x267 [ehci_hcd]
[  137.448394]  [<ffffffffa008046f>] ? ehci_irq+0x2e/0x267 [ehci_hcd]
[  137.448396]  [<ffffffff81410dc1>] ? __schedule+0x57f/0x5b2
[  137.448398]  [<ffffffff810a6445>] ? irq_thread_fn+0x35/0x35
[  137.448406]  [<ffffffffa003bc88>] usb_hcd_irq+0x20/0x2f [usbcore]
[  137.448408]  [<ffffffff810a6465>] irq_forced_thread_fn+0x20/0x3e
[  137.448410]  [<ffffffff810a6445>] ? irq_thread_fn+0x35/0x35
[  137.448412]  [<ffffffff810a6761>] irq_thread+0xba/0x182
[  137.448413]  [<ffffffff810a6363>] ? irq_finalize_oneshot+0x94/0x94
[  137.448415]  [<ffffffff810a66a7>] ? kzalloc.constprop.35+0x29/0x29
[  137.448417]  [<ffffffff8105b205>] kthread+0x88/0x90
[  137.448420]  [<ffffffff8105b17d>] ? __kthread_parkme+0x60/0x60
[  137.448422]  [<ffffffff8141677c>] ret_from_fork+0x7c/0xb0
[  137.448424]  [<ffffffff8105b17d>] ? __kthread_parkme+0x60/0x60
[  137.448426] ---[ end trace 05f37b58f5305728 ]---

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
