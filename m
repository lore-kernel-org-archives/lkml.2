Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2DDUpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 16:45:53 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52634 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab2DDUps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 16:45:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120404083343.7feb282c@s6510.linuxnetplumber.net>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	<1332338318-5958-2-git-send-email-fweisbec@gmail.com>
	<20120404083343.7feb282c@s6510.linuxnetplumber.net>
Date: Wed, 4 Apr 2012 22:45:47 +0200
Message-ID: <CAFTL4hxKA5=NkniQgoDNA6Bgoqy75rWYYYKBw33vWhVp2JEA6g@mail.gmail.com>
Subject: Re: warning in tick_nohz_irq_exit
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/4 Stephen Hemminger <shemminger@vyatta.com>:
> Using test kernel merged no-hz from your github repo with
> current upstream.
>
> Tried running this on laptop and seeing warning splats.
> May or may not be related to write to cpuset/NAME/tasks
> returning ENOSPC.
>
> [  476.389422] ------------[ cut here ]------------
> [  476.389440] WARNING: at kernel/time/tick-sched.c:567 tick_nohz_irq_exit+0x11e/0x194()
>
>
> Full dmesg:
>
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.3.1-1-amd64-vyatta (shemminger@s6510) (gcc version 4.6.3 (Debian 4.6.3-1) ) #1 SMP Tue Apr 3 15:52:51 PDT 2012
> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.3.1-1-amd64-vyatta root=UUID=b7241ed2-14f8-4d17-b9c0-87c5a6876d4c ro quiet
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e000 (usable)
> [    0.000000]  BIOS-e820: 000000000009e000 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf6b0000 (usable)
> [    0.000000]  BIOS-e820: 00000000cf6b0000 - 00000000cf6ca000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000cf6ca000 - 00000000cf6ce000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000cf6ce000 - 00000000d0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.4 present.
> [    0.000000] DMI: FUJITSU LifeBook S6510/FJNB1D3, BIOS Version 1.31  02/05/2009
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> [    0.000000] No AGP bridge found
> [    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CFFFF write-protect
> [    0.000000]   D0000-DFFFF uncachable
> [    0.000000]   E0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0D0000000 mask FF0000000 uncachable
> [    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
> [    0.000000]   2 base 000000000 mask F00000000 write-back
> [    0.000000]   3 base 100000000 mask FE0000000 write-back
> [    0.000000]   4 base 120000000 mask FF0000000 write-back
> [    0.000000]   5 base 0CF700000 mask FFFF00000 uncachable
> [    0.000000]   6 base 0CF800000 mask FFF800000 uncachable
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] e820 update range: 00000000cf700000 - 0000000100000000 (usable) ==> (reserved)
> [    0.000000] last_pfn = 0xcf6b0 max_arch_pfn = 0x400000000
> [    0.000000] initial memory mapped : 0 - 20000000
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 20480
> [    0.000000] init_memory_mapping: 0000000000000000-00000000cf6b0000
> [    0.000000]  0000000000 - 00cf600000 page 2M
> [    0.000000]  00cf600000 - 00cf6b0000 page 4k
> [    0.000000] kernel direct mapping tables up to cf6b0000 @ 1fffa000-20000000
> [    0.000000] init_memory_mapping: 0000000100000000-0000000130000000
> [    0.000000]  0100000000 - 0130000000 page 2M
> [    0.000000] kernel direct mapping tables up to 130000000 @ cf6aa000-cf6b0000
> [    0.000000] RAMDISK: 36a60000 - 37528000
> [    0.000000] ACPI: RSDP 00000000000f6150 00024 (v02 FUJ   )
> [    0.000000] ACPI: XSDT 00000000cf6bfa35 00074 (v01 FUJ    PC       01310000 FUJ  00000100)
> [    0.000000] ACPI: FACP 00000000cf6c80b1 000F4 (v03 FUJ    PC       01310000 FUJ  00000100)
> [    0.000000] ACPI: DSDT 00000000cf6bfaa9 08608 (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.000000] ACPI: FACS 00000000cf6cdfc0 00040
> [    0.000000] ACPI: HPET 00000000cf6c81a5 00038 (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.000000] ACPI: MCFG 00000000cf6c81dd 0003C (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.000000] ACPI: SSDT 00000000cf6c8219 004EF (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.000000] ACPI: SSDT 00000000cf6c8708 001CA (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.000000] ACPI: SSDT 00000000cf6c88d2 0106D (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.000000] ACPI: SSDT 00000000cf6c993f 00447 (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.000000] ACPI: APIC 00000000cf6c9d86 00068 (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.000000] ACPI: BOOT 00000000cf6c9dee 00028 (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.000000] ACPI: SLIC 00000000cf6c9e16 00176 (v01 FUJ    PC       01310000 FUJ  00000100)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at 0000000000000000-0000000130000000
> [    0.000000] Initmem setup node 0 0000000000000000-0000000130000000
> [    0.000000]   NODE_DATA [000000012fffb000 - 000000012fffffff]
> [    0.000000]  [ffffea0000000000-ffffea0004bfffff] PMD -> [ffff88012b600000-ffff88012f5fffff] on node 0
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   DMA32    0x00001000 -> 0x00100000
> [    0.000000]   Normal   0x00100000 -> 0x00130000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] Early memory PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009e
> [    0.000000]     0: 0x00000100 -> 0x000cf6b0
> [    0.000000]     0: 0x00100000 -> 0x00130000
> [    0.000000] On node 0 totalpages: 1046078
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 5 pages reserved
> [    0.000000]   DMA zone: 3913 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 16320 pages used for memmap
> [    0.000000]   DMA32 zone: 829168 pages, LIFO batch:31
> [    0.000000]   Normal zone: 3072 pages used for memmap
> [    0.000000]   Normal zone: 193536 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x1008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 00000000cf6b0000 - 00000000cf6ca000
> [    0.000000] PM: Registered nosave memory: 00000000cf6ca000 - 00000000cf6ce000
> [    0.000000] PM: Registered nosave memory: 00000000cf6ce000 - 00000000d0000000
> [    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000f8000000
> [    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
> [    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
> [    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
> [    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed14000
> [    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed1a000
> [    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
> [    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
> [    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
> [    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
> [    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:28000000)
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88012fc00000 s80192 r8192 d22208 u1048576
> [    0.000000] pcpu-alloc: s80192 r8192 d22208 u1048576 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1026617
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.3.1-1-amd64-vyatta root=UUID=b7241ed2-14f8-4d17-b9c0-87c5a6876d4c ro quiet
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Memory: 4033240k/4980736k available (3452k kernel code, 796424k absent, 151072k reserved, 3171k data, 560k init)
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  CONFIG_RCU_FANOUT set to non-default value of 32
> [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] NR_IRQS:4352 nr_irqs:512 16
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2394.105 MHz processor.
> [    0.010005] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.21 BogoMIPS (lpj=23941050)
> [    0.010014] pid_max: default: 32768 minimum: 301
> [    0.010052] Security Framework initialized
> [    0.010745] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.022235] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.023585] Mount-cache hash table entries: 256
> [    0.023888] CPU: Physical Processor ID: 0
> [    0.023893] CPU: Processor Core ID: 0
> [    0.023897] mce: CPU supports 6 MCE banks
> [    0.023911] CPU0: Thermal monitoring enabled (TM2)
> [    0.023918] using mwait in idle threads.
> [    0.024936] ACPI: Core revision 20120111
> [    0.036120] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.136162] CPU0: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0b
> [    0.140000] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
> [    0.140000] PEBS disabled due to CPU errata.
> [    0.140000] ... version:                2
> [    0.140000] ... bit width:              40
> [    0.140000] ... generic registers:      2
> [    0.140000] ... value mask:             000000ffffffffff
> [    0.140000] ... max period:             000000007fffffff
> [    0.140000] ... fixed-purpose events:   3
> [    0.140000] ... event mask:             0000000700000003
> [    0.140000] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.140000] Booting Node   0, Processors  #1 Ok.
> [    0.140000] smpboot cpu 1: start_ip = 99000
> [    0.143775] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.143826] Brought up 2 CPUs
> [    0.143831] Total of 2 processors activated (9576.42 BogoMIPS).
> [    0.147081] devtmpfs: initialized
> [    0.153207] PM: Registering ACPI NVS region at cf6ca000 (16384 bytes)
> [    0.153207] print_constraints: dummy:
> [    0.153207] NET: Registered protocol family 16
> [    0.153207] ACPI: bus type pci registered
> [    0.153207] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.153207] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
> [    0.159024] PCI: Using configuration type 1 for base access
> [    0.160062] bio: create slab <bio-0> at 0
> [    0.160069] ACPI: Added _OSI(Module Device)
> [    0.160069] ACPI: Added _OSI(Processor Device)
> [    0.160069] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.160069] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.162586] ACPI: EC: Look up EC in DSDT
> [    0.172631] ACPI:      00000000cf6cda9f 003B7 (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.173514] ACPI: Dynamic OEM Table Load:
> [    0.173520] ACPI:                (null) 003B7 (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.175848] ACPI: SSDT 00000000cf6cac19 002BC (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.176501] ACPI: Dynamic OEM Table Load:
> [    0.176507] ACPI: SSDT           (null) 002BC (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.176755] ACPI: SSDT 00000000cf6cb119 00627 (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.177375] ACPI: Dynamic OEM Table Load:
> [    0.177380] ACPI: SSDT           (null) 00627 (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.180423] ACPI: SSDT 00000000cf6cb061 000B8 (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.181067] ACPI: Dynamic OEM Table Load:
> [    0.181073] ACPI: SSDT           (null) 000B8 (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.181251] ACPI: SSDT 00000000cf6cb740 00047 (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.181873] ACPI: Dynamic OEM Table Load:
> [    0.181879] ACPI: SSDT           (null) 00047 (v01 FUJ    FJNB1D3  01310000 FUJ  00000100)
> [    0.182301] ACPI: Interpreter enabled
> [    0.182308] ACPI: (supports S0 S3 S4 S5)
> [    0.182347] ACPI: Using IOAPIC for interrupt routing
> [    0.190533] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
> [    0.190533] ACPI: ACPI Dock Station Driver: 1 docks/bays found
> [    0.190533] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.190924] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.191834] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
> [    0.191839] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
> [    0.191845] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
> [    0.191850] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
> [    0.191855] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
> [    0.191860] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
> [    0.191865] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
> [    0.191871] pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xfebfffff]
> [    0.191876] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
> [    0.191938] PCI host bridge to bus 0000:00
> [    0.191938] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.191938] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.191938] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.191938] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
> [    0.191938] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
> [    0.191938] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
> [    0.191938] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
> [    0.191938] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfebfffff]
> [    0.191938] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
> [    0.191938] pci 0000:00:00.0: [8086:2a00] type 0 class 0x000600
> [    0.191938] pci 0000:00:02.0: [8086:2a02] type 0 class 0x000300
> [    0.191938] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfc0fffff 64bit]
> [    0.191938] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
> [    0.191938] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
> [    0.191938] pci 0000:00:02.1: [8086:2a03] type 0 class 0x000380
> [    0.191938] pci 0000:00:02.1: reg 10: [mem 0xfc100000-0xfc1fffff 64bit]
> [    0.191938] pci 0000:00:1a.0: [8086:2834] type 0 class 0x000c03
> [    0.191938] pci 0000:00:1a.0: reg 20: [io  0x1820-0x183f]
> [    0.191938] pci 0000:00:1a.1: [8086:2835] type 0 class 0x000c03
> [    0.191938] pci 0000:00:1a.1: reg 20: [io  0x1840-0x185f]
> [    0.191938] pci 0000:00:1a.7: [8086:283a] type 0 class 0x000c03
> [    0.191938] pci 0000:00:1a.7: reg 10: [mem 0xfc704800-0xfc704bff]
> [    0.191938] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> [    0.191938] pci 0000:00:1b.0: [8086:284b] type 0 class 0x000403
> [    0.191938] pci 0000:00:1b.0: reg 10: [mem 0xfc700000-0xfc703fff 64bit]
> [    0.191938] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.191938] pci 0000:00:1c.0: [8086:283f] type 1 class 0x000604
> [    0.191938] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.191938] pci 0000:00:1c.2: [8086:2843] type 1 class 0x000604
> [    0.191938] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    0.191938] pci 0000:00:1d.0: [8086:2830] type 0 class 0x000c03
> [    0.191938] pci 0000:00:1d.0: reg 20: [io  0x1860-0x187f]
> [    0.191938] pci 0000:00:1d.1: [8086:2831] type 0 class 0x000c03
> [    0.191938] pci 0000:00:1d.1: reg 20: [io  0x1880-0x189f]
> [    0.191938] pci 0000:00:1d.2: [8086:2832] type 0 class 0x000c03
> [    0.191938] pci 0000:00:1d.2: reg 20: [io  0x18a0-0x18bf]
> [    0.191938] pci 0000:00:1d.7: [8086:2836] type 0 class 0x000c03
> [    0.191938] pci 0000:00:1d.7: reg 10: [mem 0xfc704c00-0xfc704fff]
> [    0.191952] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.191986] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
> [    0.192099] pci 0000:00:1f.0: [8086:2815] type 0 class 0x000601
> [    0.192215] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
> [    0.192225] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
> [    0.192232] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at fd00 (mask 007f)
> [    0.192301] pci 0000:00:1f.1: [8086:2850] type 0 class 0x000101
> [    0.192323] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
> [    0.192338] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
> [    0.192354] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
> [    0.192369] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
> [    0.192384] pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
> [    0.192450] pci 0000:00:1f.2: [8086:2829] type 0 class 0x000106
> [    0.192483] pci 0000:00:1f.2: reg 10: [io  0x1c00-0x1c07]
> [    0.192498] pci 0000:00:1f.2: reg 14: [io  0x18d4-0x18d7]
> [    0.192514] pci 0000:00:1f.2: reg 18: [io  0x18d8-0x18df]
> [    0.192530] pci 0000:00:1f.2: reg 1c: [io  0x18d0-0x18d3]
> [    0.192545] pci 0000:00:1f.2: reg 20: [io  0x18e0-0x18ff]
> [    0.192563] pci 0000:00:1f.2: reg 24: [mem 0xfc704000-0xfc7047ff]
> [    0.192640] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.192672] pci 0000:00:1f.3: [8086:283e] type 0 class 0x000c05
> [    0.192694] pci 0000:00:1f.3: reg 10: [mem 0x00000000-0x000000ff]
> [    0.192742] pci 0000:00:1f.3: reg 20: [io  0x1c20-0x1c3f]
> [    0.192890] pci 0000:04:00.0: [11ab:4363] type 0 class 0x000200
> [    0.192927] pci 0000:04:00.0: reg 10: [mem 0xfc200000-0xfc203fff 64bit]
> [    0.192949] pci 0000:04:00.0: reg 18: [io  0x2000-0x20ff]
> [    0.193021] pci 0000:04:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
> [    0.193136] pci 0000:04:00.0: supports D1 D2
> [    0.193140] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.220028] pci 0000:00:1c.0: PCI bridge to [bus 04-07]
> [    0.220036] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
> [    0.220044] pci 0000:00:1c.0:   bridge window [mem 0xfc200000-0xfc2fffff]
> [    0.220150] pci 0000:0c:00.0: [8086:4229] type 0 class 0x000280
> [    0.220197] pci 0000:0c:00.0: reg 10: [mem 0xfc300000-0xfc301fff 64bit]
> [    0.220413] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
> [    0.240028] pci 0000:00:1c.2: PCI bridge to [bus 0c-0f]
> [    0.240039] pci 0000:00:1c.2:   bridge window [mem 0xfc300000-0xfc3fffff]
> [    0.240107] pci 0000:1c:03.0: [1217:7136] type 2 class 0x000607
> [    0.240137] pci 0000:1c:03.0: reg 10: [mem 0x00000000-0x00000fff]
> [    0.240185] pci 0000:1c:03.0: supports D1 D2
> [    0.240189] pci 0000:1c:03.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.240227] pci 0000:1c:03.2: [1217:7120] type 0 class 0x000805
> [    0.240257] pci 0000:1c:03.2: reg 10: [mem 0xfc402800-0xfc4028ff]
> [    0.240380] pci 0000:1c:03.2: supports D1 D2
> [    0.240384] pci 0000:1c:03.2: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.240416] pci 0000:1c:03.3: [1217:7130] type 0 class 0x000180
> [    0.240446] pci 0000:1c:03.3: reg 10: [mem 0xfc400000-0xfc400fff]
> [    0.240569] pci 0000:1c:03.3: supports D1 D2
> [    0.240573] pci 0000:1c:03.3: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.240607] pci 0000:1c:03.4: [1217:00f7] type 0 class 0x000c00
> [    0.240633] pci 0000:1c:03.4: reg 10: [mem 0xfc401000-0xfc401fff]
> [    0.240650] pci 0000:1c:03.4: reg 14: [mem 0xfc402000-0xfc4027ff]
> [    0.240754] pci 0000:1c:03.4: supports D1 D2
> [    0.240758] pci 0000:1c:03.4: PME# supported from D0 D1 D2 D3hot
> [    0.240831] pci 0000:00:1e.0: PCI bridge to [bus 1c-1d] (subtractive decode)
> [    0.240841] pci 0000:00:1e.0:   bridge window [mem 0xfc400000-0xfc4fffff]
> [    0.240852] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
> [    0.240857] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
> [    0.240862] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
> [    0.240867] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
> [    0.240873] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
> [    0.240878] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
> [    0.240883] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
> [    0.240889] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xfebfffff] (subtractive decode)
> [    0.240894] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
> [    0.240955] pci_bus 0000:1d: [bus 1d-20] partially hidden behind transparent bridge 0000:1c [bus 1c-1d]
> [    0.240986] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.241271] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
> [    0.241362] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
> [    0.241497] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
> [    0.241562]  pci0000:00: Requesting ACPI _OSC control (0x1d)
> [    0.241568]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
> [    0.241572] ACPI _OSC control for PCIe not granted, disabling ASPM
> [    0.250489] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
> [    0.250489] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
> [    0.250489] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
> [    0.250489] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
> [    0.250489] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
> [    0.250536] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> [    0.250618] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
> [    0.250701] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> [    0.250750] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.250750] vgaarb: loaded
> [    0.250750] vgaarb: bridge control possible 0000:00:02.0
> [    0.250750] SCSI subsystem initialized
> [    0.250750] libata version 3.00 loaded.
> [    0.250750] usbcore: registered new interface driver usbfs
> [    0.250750] usbcore: registered new interface driver hub
> [    0.250750] usbcore: registered new device driver usb
> [    0.250750] PCI: Using ACPI for IRQ routing
> [    0.260440] PCI: pci_cache_line_size set to 64 bytes
> [    0.260592] reserve RAM buffer: 000000000009e000 - 000000000009ffff
> [    0.260597] reserve RAM buffer: 00000000cf6b0000 - 00000000cfffffff
> [    0.260630] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    0.260630] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    0.260630] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> [    0.270038] Switching to clocksource hpet
> [    0.273784] pnp: PnP ACPI init
> [    0.273805] ACPI: bus type pnp registered
> [    0.274317] pnp 00:00: [bus 00-ff]
> [    0.274323] pnp 00:00: [io  0x0000-0x0cf7 window]
> [    0.274327] pnp 00:00: [io  0x0cf8-0x0cff]
> [    0.274331] pnp 00:00: [io  0x0d00-0xffff window]
> [    0.274336] pnp 00:00: [mem 0x000a0000-0x000bffff window]
> [    0.274340] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
> [    0.274345] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
> [    0.274349] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
> [    0.274353] pnp 00:00: [mem 0x000cc000-0x000cffff window]
> [    0.274358] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
> [    0.274362] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
> [    0.274366] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
> [    0.274371] pnp 00:00: [mem 0x000dc000-0x000dffff window]
> [    0.274375] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
> [    0.274379] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
> [    0.274384] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
> [    0.274388] pnp 00:00: [mem 0x000ec000-0x000effff window]
> [    0.274393] pnp 00:00: [mem 0x000f0000-0x000fffff window]
> [    0.274397] pnp 00:00: [mem 0xd0000000-0xfebfffff window]
> [    0.274402] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
> [    0.274542] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
> [    0.274657] pnp 00:01: [io  0x0010-0x001f]
> [    0.274662] pnp 00:01: [io  0x0024-0x0025]
> [    0.274666] pnp 00:01: [io  0x0028-0x0029]
> [    0.274670] pnp 00:01: [io  0x002c-0x002d]
> [    0.274673] pnp 00:01: [io  0x002e-0x002f]
> [    0.274677] pnp 00:01: [io  0x0030-0x0031]
> [    0.274681] pnp 00:01: [io  0x0034-0x0035]
> [    0.274684] pnp 00:01: [io  0x0038-0x0039]
> [    0.274688] pnp 00:01: [io  0x003c-0x003d]
> [    0.274692] pnp 00:01: [io  0x0000-0xffffffffffffffff disabled]
> [    0.274697] pnp 00:01: [io  0x0050-0x0053]
> [    0.274700] pnp 00:01: [io  0x0061]
> [    0.274704] pnp 00:01: [io  0x0063]
> [    0.274707] pnp 00:01: [io  0x0065]
> [    0.274715] pnp 00:01: [io  0x0067]
> [    0.274719] pnp 00:01: [io  0x0072-0x0077]
> [    0.274722] pnp 00:01: [io  0x0080]
> [    0.274726] pnp 00:01: [io  0x0090-0x009f]
> [    0.274729] pnp 00:01: [io  0x0092]
> [    0.274733] pnp 00:01: [io  0x00a4-0x00a5]
> [    0.274737] pnp 00:01: [io  0x00a8-0x00a9]
> [    0.274740] pnp 00:01: [io  0x00ac-0x00ad]
> [    0.274744] pnp 00:01: [io  0x00b0-0x00b1]
> [    0.274748] pnp 00:01: [io  0x00b2-0x00b3]
> [    0.274751] pnp 00:01: [io  0x00b4-0x00b5]
> [    0.274755] pnp 00:01: [io  0x00b8-0x00b9]
> [    0.274759] pnp 00:01: [io  0x00bc-0x00bd]
> [    0.274762] pnp 00:01: [io  0x04d0-0x04d1]
> [    0.274766] pnp 00:01: [io  0x0680-0x069f]
> [    0.274770] pnp 00:01: [io  0x0800-0x080f]
> [    0.274773] pnp 00:01: [io  0x1000-0x107f]
> [    0.274777] pnp 00:01: [io  0x1080-0x10ff]
> [    0.274781] pnp 00:01: [io  0x1100-0x111f]
> [    0.274784] pnp 00:01: [io  0x1180-0x11bf]
> [    0.274788] pnp 00:01: [io  0x1640-0x164f]
> [    0.274792] pnp 00:01: [io  0xf800-0xf87f]
> [    0.274796] pnp 00:01: [io  0xf880-0xf8ff]
> [    0.274800] pnp 00:01: [io  0xfc00-0xfc7f]
> [    0.274803] pnp 00:01: [io  0xfc80-0xfcff]
> [    0.274807] pnp 00:01: [io  0xfd0c-0xfd7f]
> [    0.274811] pnp 00:01: [io  0xfe00-0xfe03]
> [    0.275050] system 00:01: [io  0x04d0-0x04d1] has been reserved
> [    0.275056] system 00:01: [io  0x0680-0x069f] has been reserved
> [    0.275061] system 00:01: [io  0x0800-0x080f] has been reserved
> [    0.275067] system 00:01: [io  0x1000-0x107f] has been reserved
> [    0.275072] system 00:01: [io  0x1080-0x10ff] has been reserved
> [    0.275077] system 00:01: [io  0x1100-0x111f] has been reserved
> [    0.275082] system 00:01: [io  0x1180-0x11bf] has been reserved
> [    0.275088] system 00:01: [io  0x1640-0x164f] has been reserved
> [    0.275093] system 00:01: [io  0xf800-0xf87f] has been reserved
> [    0.275099] system 00:01: [io  0xf880-0xf8ff] has been reserved
> [    0.275104] system 00:01: [io  0xfc00-0xfc7f] has been reserved
> [    0.275109] system 00:01: [io  0xfc80-0xfcff] has been reserved
> [    0.275115] system 00:01: [io  0xfd0c-0xfd7f] has been reserved
> [    0.275120] system 00:01: [io  0xfe00-0xfe03] has been reserved
> [    0.275127] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.275285] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
> [    0.275290] pnp 00:02: [mem 0xfed14000-0xfed17fff]
> [    0.275294] pnp 00:02: [mem 0xfed18000-0xfed18fff]
> [    0.275298] pnp 00:02: [mem 0xfed19000-0xfed19fff]
> [    0.275302] pnp 00:02: [mem 0xf8000000-0xfbffffff]
> [    0.275306] pnp 00:02: [mem 0xfed20000-0xfed3ffff]
> [    0.275311] pnp 00:02: [mem 0xfed40000-0xfed3ffff disabled]
> [    0.275315] pnp 00:02: [mem 0xfed45000-0xfed8ffff]
> [    0.275319] pnp 00:02: [mem 0xfef00000-0xfeffffff]
> [    0.275449] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.275456] system 00:02: [mem 0xfed14000-0xfed17fff] has been reserved
> [    0.275462] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.275467] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.275473] system 00:02: [mem 0xf8000000-0xfbffffff] has been reserved
> [    0.275478] system 00:02: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    0.275484] system 00:02: [mem 0xfed45000-0xfed8ffff] has been reserved
> [    0.275489] system 00:02: [mem 0xfef00000-0xfeffffff] has been reserved
> [    0.275496] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.275813] pnp 00:03: [io  0x004e-0x004f]
> [    0.275818] pnp 00:03: [io  0xfd00-0xfd0b]
> [    0.275822] pnp 00:03: [mem 0xfed40000-0xfed44fff]
> [    0.275934] pnp 00:03: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
> [    0.275990] pnp 00:04: [io  0x0000-0x000f]
> [    0.275995] pnp 00:04: [io  0x0081-0x008f]
> [    0.276003] pnp 00:04: [io  0x00c0-0x00df]
> [    0.276007] pnp 00:04: [dma 4]
> [    0.276114] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.276145] pnp 00:05: [io  0x0060]
> [    0.276149] pnp 00:05: [io  0x0064]
> [    0.276162] pnp 00:05: [irq 1]
> [    0.276273] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.276303] pnp 00:06: [io  0x00f0-0x00fe]
> [    0.276313] pnp 00:06: [irq 13]
> [    0.276420] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.276466] pnp 00:07: [irq 12]
> [    0.276578] pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    0.276610] pnp 00:08: [io  0x0070-0x0071]
> [    0.276619] pnp 00:08: [irq 8]
> [    0.276731] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.276761] pnp 00:09: [io  0x0061]
> [    0.276872] pnp 00:09: Plug and Play ACPI device, IDs PNP0800 (active)
> [    0.277523] pnp: PnP ACPI: found 10 devices
> [    0.277527] ACPI: ACPI bus type pnp unregistered
> [    0.284690] PCI: max bus depth: 2 pci_try_num: 3
> [    0.284752] pci 0000:00:1c.0: BAR 15: assigned [mem 0xd0000000-0xd00fffff pref]
> [    0.284761] pci 0000:00:1f.3: BAR 0: assigned [mem 0xd0100000-0xd01000ff]
> [    0.284774] pci 0000:00:1e.0: BAR 15: assigned [mem 0xd4000000-0xd7ffffff pref]
> [    0.284782] pci 0000:00:1e.0: BAR 13: assigned [io  0x3000-0x3fff]
> [    0.284790] pci 0000:00:1c.2: BAR 15: assigned [mem 0xd0200000-0xd03fffff 64bit pref]
> [    0.284798] pci 0000:00:1c.2: BAR 13: assigned [io  0x4000-0x4fff]
> [    0.284807] pci 0000:00:1c.0: BAR 15: assigned [mem 0xd0400000-0xd06fffff pref]
> [    0.284814] pci 0000:04:00.0: BAR 6: assigned [mem 0xd0400000-0xd041ffff pref]
> [    0.284819] pci 0000:00:1c.0: PCI bridge to [bus 04-07]
> [    0.284825] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
> [    0.284835] pci 0000:00:1c.0:   bridge window [mem 0xfc200000-0xfc2fffff]
> [    0.284842] pci 0000:00:1c.0:   bridge window [mem 0xd0400000-0xd06fffff pref]
> [    0.284853] pci 0000:00:1c.2: PCI bridge to [bus 0c-0f]
> [    0.284859] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
> [    0.284869] pci 0000:00:1c.2:   bridge window [mem 0xfc300000-0xfc3fffff]
> [    0.284877] pci 0000:00:1c.2:   bridge window [mem 0xd0200000-0xd03fffff 64bit pref]
> [    0.284897] pci 0000:1c:03.0: BAR 0: assigned [mem 0xd0000000-0xd0000fff]
> [    0.284909] pci 0000:1c:03.0: BAR 16: assigned [mem 0xd8000000-0xdbffffff]
> [    0.284915] pci 0000:1c:03.0: BAR 15: assigned [mem 0xd4000000-0xd7ffffff pref]
> [    0.284920] pci 0000:1c:03.0: BAR 14: assigned [io  0x3000-0x30ff]
> [    0.284925] pci 0000:1c:03.0: BAR 13: assigned [io  0x3400-0x34ff]
> [    0.284930] pci 0000:1c:03.0: CardBus bridge to [bus 1d-20]
> [    0.284934] pci 0000:1c:03.0:   bridge window [io  0x3400-0x34ff]
> [    0.284942] pci 0000:1c:03.0:   bridge window [io  0x3000-0x30ff]
> [    0.284950] pci 0000:1c:03.0:   bridge window [mem 0xd4000000-0xd7ffffff pref]
> [    0.284959] pci 0000:1c:03.0:   bridge window [mem 0xd8000000-0xdbffffff]
> [    0.284967] pci 0000:00:1e.0: PCI bridge to [bus 1c-1d]
> [    0.284972] pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
> [    0.284981] pci 0000:00:1e.0:   bridge window [mem 0xfc400000-0xfc4fffff]
> [    0.284989] pci 0000:00:1e.0:   bridge window [mem 0xd4000000-0xd7ffffff pref]
> [    0.285039] pci 0000:00:1e.0: setting latency timer to 64
> [    0.285057] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.285062] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.285066] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.285071] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
> [    0.285076] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
> [    0.285080] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
> [    0.285085] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
> [    0.285090] pci_bus 0000:00: resource 11 [mem 0xd0000000-0xfebfffff]
> [    0.285094] pci_bus 0000:00: resource 12 [mem 0xfed40000-0xfed44fff]
> [    0.285099] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
> [    0.285104] pci_bus 0000:04: resource 1 [mem 0xfc200000-0xfc2fffff]
> [    0.285109] pci_bus 0000:04: resource 2 [mem 0xd0400000-0xd06fffff pref]
> [    0.285114] pci_bus 0000:0c: resource 0 [io  0x4000-0x4fff]
> [    0.285118] pci_bus 0000:0c: resource 1 [mem 0xfc300000-0xfc3fffff]
> [    0.285123] pci_bus 0000:0c: resource 2 [mem 0xd0200000-0xd03fffff 64bit pref]
> [    0.285128] pci_bus 0000:1c: resource 0 [io  0x3000-0x3fff]
> [    0.285132] pci_bus 0000:1c: resource 1 [mem 0xfc400000-0xfc4fffff]
> [    0.285137] pci_bus 0000:1c: resource 2 [mem 0xd4000000-0xd7ffffff pref]
> [    0.285142] pci_bus 0000:1c: resource 4 [io  0x0000-0x0cf7]
> [    0.285146] pci_bus 0000:1c: resource 5 [io  0x0d00-0xffff]
> [    0.285151] pci_bus 0000:1c: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.285155] pci_bus 0000:1c: resource 7 [mem 0x000d0000-0x000d3fff]
> [    0.285160] pci_bus 0000:1c: resource 8 [mem 0x000d4000-0x000d7fff]
> [    0.285164] pci_bus 0000:1c: resource 9 [mem 0x000d8000-0x000dbfff]
> [    0.285169] pci_bus 0000:1c: resource 10 [mem 0x000dc000-0x000dffff]
> [    0.285174] pci_bus 0000:1c: resource 11 [mem 0xd0000000-0xfebfffff]
> [    0.285179] pci_bus 0000:1c: resource 12 [mem 0xfed40000-0xfed44fff]
> [    0.285183] pci_bus 0000:1d: resource 0 [io  0x3400-0x34ff]
> [    0.285188] pci_bus 0000:1d: resource 1 [io  0x3000-0x30ff]
> [    0.285192] pci_bus 0000:1d: resource 2 [mem 0xd4000000-0xd7ffffff pref]
> [    0.285197] pci_bus 0000:1d: resource 3 [mem 0xd8000000-0xdbffffff]
> [    0.285241] NET: Registered protocol family 2
> [    0.285467] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.287260] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> [    0.292371] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.293032] TCP: Hash tables configured (established 524288 bind 65536)
> [    0.293036] TCP reno registered
> [    0.293054] UDP hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.293117] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.293289] NET: Registered protocol family 1
> [    0.293317] pci 0000:00:02.0: Boot video device
> [    0.293693] PCI: CLS 64 bytes, default 64
> [    0.293766] Trying to unpack rootfs image as initramfs...
> [    0.748181] Freeing initrd memory: 11040k freed
> [    0.754749] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.754758] Placing 64MB software IO TLB between ffff8800cb6aa000 - ffff8800cf6aa000
> [    0.754763] software IO TLB at phys 0xcb6aa000 - 0xcf6aa000
> [    0.754786] Simple Boot Flag at 0x7b set to 0x1
> [    0.756515] audit: initializing netlink socket (disabled)
> [    0.756535] type=2000 audit(1333552189.750:1): initialized
> [    0.757428] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.765853] Registering unionfs 2.5.11 (for 3.3.0-rc3)
> [    0.766222] msgmni has been set to 7898
> [    0.766724] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    0.766730] io scheduler noop registered
> [    0.766733] io scheduler deadline registered
> [    0.766949] io scheduler cfq registered (default)
> [    0.767215] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
> [    0.767442] pcieport 0000:00:1c.2: irq 41 for MSI/MSI-X
> [    0.768293] intel_idle: MWAIT substates: 0x22220
> [    0.768297] intel_idle: does not run on family 6 model 15
> [    0.768443] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.769879] tpm_tis 00:03: 1.2 TPM (device-id 0xB, rev-id 16)
> [    1.470021] tpm_tis 00:03: Operation Timed out
> [    1.470076] tpm_tis 00:03: TPM self test failed
> [    1.474343] brd: module loaded
> [    1.474781] Fixed MDIO Bus: probed
> [    1.474790] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    1.474849] ehci_hcd 0000:00:1a.7: setting latency timer to 64
> [    1.474855] ehci_hcd 0000:00:1a.7: EHCI Host Controller
> [    1.474867] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
> [    1.474919] ehci_hcd 0000:00:1a.7: debug port 1
> [    1.478799] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
> [    1.478827] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xfc704800
> [    1.490055] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
> [    1.490107] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.490112] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.490117] usb usb1: Product: EHCI Host Controller
> [    1.490121] usb usb1: Manufacturer: Linux 3.3.1-1-amd64-vyatta ehci_hcd
> [    1.490125] usb usb1: SerialNumber: 0000:00:1a.7
> [    1.490409] hub 1-0:1.0: USB hub found
> [    1.490419] hub 1-0:1.0: 4 ports detected
> [    1.490555] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    1.490561] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    1.490571] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
> [    1.490616] ehci_hcd 0000:00:1d.7: debug port 1
> [    1.494486] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
> [    1.494496] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfc704c00
> [    1.510035] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    1.510083] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.510088] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.510092] usb usb2: Product: EHCI Host Controller
> [    1.510096] usb usb2: Manufacturer: Linux 3.3.1-1-amd64-vyatta ehci_hcd
> [    1.510100] usb usb2: SerialNumber: 0000:00:1d.7
> [    1.510387] hub 2-0:1.0: USB hub found
> [    1.510396] hub 2-0:1.0: 6 ports detected
> [    1.510568] uhci_hcd: USB Universal Host Controller Interface driver
> [    1.510603] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [    1.510610] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    1.510620] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
> [    1.510671] uhci_hcd 0000:00:1a.0: irq 22, io base 0x00001820
> [    1.510726] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.510731] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.510735] usb usb3: Product: UHCI Host Controller
> [    1.510739] usb usb3: Manufacturer: Linux 3.3.1-1-amd64-vyatta uhci_hcd
> [    1.510743] usb usb3: SerialNumber: 0000:00:1a.0
> [    1.511006] hub 3-0:1.0: USB hub found
> [    1.511015] hub 3-0:1.0: 2 ports detected
> [    1.511128] uhci_hcd 0000:00:1a.1: setting latency timer to 64
> [    1.511134] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    1.511143] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
> [    1.511179] uhci_hcd 0000:00:1a.1: irq 22, io base 0x00001840
> [    1.511233] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.511238] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.511242] usb usb4: Product: UHCI Host Controller
> [    1.511246] usb usb4: Manufacturer: Linux 3.3.1-1-amd64-vyatta uhci_hcd
> [    1.511250] usb usb4: SerialNumber: 0000:00:1a.1
> [    1.511510] hub 4-0:1.0: USB hub found
> [    1.511519] hub 4-0:1.0: 2 ports detected
> [    1.511630] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    1.511636] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    1.511646] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
> [    1.511682] uhci_hcd 0000:00:1d.0: irq 22, io base 0x00001860
> [    1.511735] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.511741] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.511745] usb usb5: Product: UHCI Host Controller
> [    1.511749] usb usb5: Manufacturer: Linux 3.3.1-1-amd64-vyatta uhci_hcd
> [    1.511753] usb usb5: SerialNumber: 0000:00:1d.0
> [    1.512008] hub 5-0:1.0: USB hub found
> [    1.512016] hub 5-0:1.0: 2 ports detected
> [    1.512128] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    1.512134] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    1.512143] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
> [    1.512180] uhci_hcd 0000:00:1d.1: irq 22, io base 0x00001880
> [    1.512235] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.512241] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.512245] usb usb6: Product: UHCI Host Controller
> [    1.512249] usb usb6: Manufacturer: Linux 3.3.1-1-amd64-vyatta uhci_hcd
> [    1.512253] usb usb6: SerialNumber: 0000:00:1d.1
> [    1.512508] hub 6-0:1.0: USB hub found
> [    1.512516] hub 6-0:1.0: 2 ports detected
> [    1.512628] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    1.512634] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    1.512643] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
> [    1.512680] uhci_hcd 0000:00:1d.2: irq 22, io base 0x000018a0
> [    1.512733] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.512739] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.512743] usb usb7: Product: UHCI Host Controller
> [    1.512747] usb usb7: Manufacturer: Linux 3.3.1-1-amd64-vyatta uhci_hcd
> [    1.512751] usb usb7: SerialNumber: 0000:00:1d.2
> [    1.513013] hub 7-0:1.0: USB hub found
> [    1.513022] hub 7-0:1.0: 2 ports detected
> [    1.513377] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
> [    1.515536] i8042: Detected active multiplexing controller, rev 1.1
> [    1.517407] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    1.517417] serio: i8042 AUX0 port at 0x60,0x64 irq 12
> [    1.517422] serio: i8042 AUX1 port at 0x60,0x64 irq 12
> [    1.517427] serio: i8042 AUX2 port at 0x60,0x64 irq 12
> [    1.517432] serio: i8042 AUX3 port at 0x60,0x64 irq 12
> [    1.517874] mousedev: PS/2 mouse device common for all mice
> [    1.517988] rtc_cmos 00:08: RTC can wake from S4
> [    1.518239] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
> [    1.518282] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    1.518344] cpuidle: using governor ladder
> [    1.518347] cpuidle: using governor menu
> [    1.518697] No iBFT detected.
> [    1.518728] Netfilter messages via NETLINK v0.30.
> [    1.518806] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    1.518811] TCP cubic registered
> [    1.518816] NET: Registered protocol family 17
> [    1.518889] Registering the dns_resolver key type
> [    1.519225] registered taskstats version 1
> [    1.520227] rtc_cmos 00:08: setting system clock to 2012-04-04 15:09:51 UTC (1333552191)
> [    1.522640] Freeing unused kernel memory: 560k freed
> [    1.522909] Write protecting the kernel read-only data: 6144k
> [    1.527588] Freeing unused kernel memory: 624k freed
> [    1.532348] Freeing unused kernel memory: 608k freed
> [    1.547150] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> [    1.657281] udevd[612]: starting version 175
> [    1.701917] sky2: driver version 1.30
> [    1.702034] sky2 0000:04:00.0: Yukon-2 EC Ultra chip revision 3
> [    1.702182] sky2 0000:04:00.0: irq 42 for MSI/MSI-X
> [    1.702515] sky2 0000:04:00.0: eth0: addr 00:17:42:8a:b4:05
> [    1.706543] ata_piix 0000:00:1f.1: version 2.13
> [    1.706630] ata_piix 0000:00:1f.1: setting latency timer to 64
> [    1.714519] scsi0 : ata_piix
> [    1.717709] scsi1 : ata_piix
> [    1.718371] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
> [    1.718377] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
> [    1.742743] thermal LNXTHERM:00: registered as thermal_zone0
> [    1.742749] ACPI: Thermal Zone [TZ00] (27 C)
> [    1.742977] thermal LNXTHERM:01: registered as thermal_zone1
> [    1.742982] ACPI: Thermal Zone [TZ01] (27 C)
> [    1.747831] ahci 0000:00:1f.2: version 3.0
> [    1.747943] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
> [    1.748050] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
> [    1.748058] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc
> [    1.748067] ahci 0000:00:1f.2: setting latency timer to 64
> [    1.750080] Refined TSC clocksource calibration: 2393.999 MHz.
> [    1.750088] Switching to clocksource tsc
> [    1.752771] scsi2 : ahci
> [    1.756589] scsi3 : ahci
> [    1.756750] scsi4 : ahci
> [    1.756953] ata3: SATA max UDMA/133 abar m2048@0xfc704000 port 0xfc704100 irq 43
> [    1.756960] ata4: SATA max UDMA/133 abar m2048@0xfc704000 port 0xfc704180 irq 43
> [    1.756966] ata5: SATA max UDMA/133 abar m2048@0xfc704000 port 0xfc704200 irq 43
> [    1.930028] usb 1-3: new high-speed USB device number 3 using ehci_hcd
> [    2.100033] ata4: SATA link down (SStatus 0 SControl 300)
> [    2.100068] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.100097] ata5: SATA link down (SStatus 0 SControl 300)
> [    2.100475] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [    2.100482] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    2.100570] ata3.00: ATA-9: M4-CT128M4SSD2, 0309, max UDMA/100
> [    2.100576] ata3.00: 250069680 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [    2.100978] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [    2.100985] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    2.101073] ata3.00: configured for UDMA/100
> [    2.101255] scsi 2:0:0:0: Direct-Access     ATA      M4-CT128M4SSD2   0309 PQ: 0 ANSI: 5
> [    2.101501] sd 2:0:0:0: [sda] 250069680 512-byte logical blocks: (128 GB/119 GiB)
> [    2.101527] sd 2:0:0:0: Attached scsi generic sg0 type 0
> [    2.101622] sd 2:0:0:0: [sda] Write Protect is off
> [    2.101628] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    2.101677] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    2.102522]  sda: sda1 sda2 < sda5 sda6 >
> [    2.103156] sd 2:0:0:0: [sda] Attached SCSI disk
> [    2.106992] sdhci: Secure Digital Host Controller Interface driver
> [    2.106997] sdhci: Copyright(c) Pierre Ossman
> [    2.107472] sdhci-pci 0000:1c:03.2: SDHCI controller found [1217:7120] (rev 2)
> [    2.107563] mmc0: no vmmc regulator found
> [    2.107612] Registered led device: mmc0::
> [    2.108674] mmc0: SDHCI controller on PCI [0000:1c:03.2] using PIO
> [    2.109899] usb 1-3: New USB device found, idVendor=046d, idProduct=09b2
> [    2.109905] usb 1-3: New USB device strings: Mfr=0, Product=2, SerialNumber=0
> [    2.109910] usb 1-3: Product: OEM Camera
> [    2.170066] firewire_ohci: Added fw-ohci device 0000:1c:03.4, OHCI v1.10, 8 IR + 8 IT contexts, quirks 0x10
> [    2.225306] device-mapper: uevent: version 1.0.3
> [    2.225727] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
> [    2.259177] Btrfs loaded
> [    2.266136] PM: Starting manual resume from disk
> [    2.283545] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> [    2.450029] usb 3-2: new full-speed USB device number 2 using uhci_hcd
> [    2.629744] usb 3-2: New USB device found, idVendor=0c24, idProduct=000f
> [    2.629750] usb 3-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    2.637278] udevd[854]: starting version 175
> [    2.670194] firewire_core: created device fw0: GUID 00000e1003f448d1, S400
> [    2.784513] Linux agpgart interface v0.103
> [    2.787669] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
> [    2.787713] ACPI: Lid Switch [LID]
> [    2.787804] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
> [    2.787812] ACPI: Power Button [PWRB]
> [    2.799854] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
> [    2.800060] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
> [    2.800066] Monitor-Mwait will be used to enter C-1 state
> [    2.801730] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
> [    2.802036] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
> [    2.808253] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
> [    2.808269] ACPI: Battery Slot [CMB1] (battery present)
> [    2.815046] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
> [    2.815062] ACPI: Battery Slot [CMB2] (battery present)
> [    2.816520] Monitor-Mwait will be used to enter C-2 state
> [    2.824425] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
> [    2.824582] iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x1060)
> [    2.826922] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [    2.827356] Monitor-Mwait will be used to enter C-3 state
> [    2.827381] Marking TSC unstable due to TSC halts in idle
> [    2.827417] ACPI: acpi_idle registered with cpuidle
> [    2.827566] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
> [    2.829919] ACPI: AC Adapter [AC] (off-line)
> [    2.839175] Switching to clocksource hpet
> [    2.852557] cfg80211: Calling CRDA to update world regulatory domain
> [    2.880008] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
> [    2.880008] ACPI: Power Button [PWRF]
> [    2.887729] iwl4965: Intel(R) Wireless WiFi 4965 driver for Linux, in-tree:
> [    2.887734] iwl4965: Copyright(c) 2003-2011 Intel Corporation
> [    2.887864] iwl4965 0000:0c:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
> [    2.927386] iwl4965 0000:0c:00.0: device EEPROM VER=0x36, CALIB=0x5
> [    2.927444] iwl4965 0000:0c:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
> [    2.927677] iwl4965 0000:0c:00.0: irq 44 for MSI/MSI-X
> [    2.927848] usb 5-1: new low-speed USB device number 2 using uhci_hcd
> [    2.939578] tpm_inf_pnp 00:03: Found TPM with ID IFX0102
> [    2.939650] tpm_inf_pnp 00:03: TPM found: config base 0x4e, data base 0xfd00, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
> [    2.956878] input: PC Speaker as /devices/platform/pcspkr/input/input4
> [    3.028008] input: Fujitsu Application Panel buttons as /devices/pci0000:00/0000:00:1f.3/i2c-0/0-0019/input/input5
> [    3.079666] iwl4965 0000:0c:00.0: loaded firmware version 228.61.2.24
> [    3.080152] Registered led device: phy0-led
> [    3.097917] cfg80211: World regulatory domain updated:
> [    3.097923] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [    3.097929] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [    3.097934] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [    3.097939] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [    3.097944] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [    3.097949] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [    3.099297] ieee80211 phy0: Selected rate control algorithm 'iwl-4965-rs'
> [    3.118778] usb 5-1: New USB device found, idVendor=1050, idProduct=0010
> [    3.118784] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    3.118790] usb 5-1: Product: Yubico Yubikey II
> [    3.118793] usb 5-1: Manufacturer: Yubico
> [    3.118796] usb 5-1: SerialNumber: 0000367025
> [    3.161328] input: Yubico Yubico Yubikey II as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input6
> [    3.161490] generic-usb 0003:1050:0010.0001: input,hidraw0: USB HID v1.11 Keyboard [Yubico Yubico Yubikey II] on usb-0000:00:1d.0-1/input0
> [    3.161526] usbcore: registered new interface driver usbhid
> [    3.161530] usbhid: USB HID core driver
> [    3.454412] Adding 1951740k swap on /dev/sda5.  Priority:-1 extents:1 across:1951740k SS
> [    3.460632] EXT4-fs (sda1): re-mounted. Opts: (null)
> [    3.647225] psmouse serio4: synaptics: Touchpad model: 1, fw: 6.2, id: 0x1a0b1, caps: 0xa04713/0x202000/0x0
> [    3.685537] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input7
> [    3.745928] EXT4-fs (sda1): re-mounted. Opts: discard,errors=remount-ro
> [    4.027211] input: Yubico Yubico Yubikey II as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input8
> [    4.027371] generic-usb 0003:1050:0010.0002: input,hidraw0: USB HID v1.11 Keyboard [Yubico Yubico Yubikey II] on usb-0000:00:1d.0-1/input0
> [    6.167412] Intel AES-NI instructions are not detected.
> [    6.181055] padlock_sha: VIA PadLock Hash Engine not detected.
> [   11.493873] loop: module loaded
> [   11.970959] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
> [   12.164577] NET: Registered protocol family 10
> [   12.221536] RPC: Registered named UNIX socket transport module.
> [   12.221541] RPC: Registered udp transport module.
> [   12.221544] RPC: Registered tcp transport module.
> [   12.221548] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [   12.321045] fuse init (API version 7.18)
> [   12.609444] NET: Registered protocol family 15
> [   13.088426] sky2 0000:04:00.0: eth0: enabling interface
> [   13.089637] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   13.261673] [drm] Initialized drm 1.1.0 20060810
> [   13.271149] i915 0000:00:02.0: setting latency timer to 64
> [   13.342156] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
> [   13.342161] [drm] MTRR allocation failed.  Graphics performance may suffer.
> [   13.343984] i915 0000:00:02.0: irq 45 for MSI/MSI-X
> [   13.344001] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [   13.344005] [drm] Driver supports precise vblank timestamp query.
> [   13.344071] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [   13.349856] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   14.078303] [drm] initialized overlay support
> [   14.161389] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input9
> [   14.289222] fbcon: inteldrmfb (fb0) is primary device
> [   14.289439] Console: switching to colour frame buffer device 160x50
> [   14.289450] fb0: inteldrmfb frame buffer device
> [   14.289453] drm: registered panic notifier
> [   14.308314] acpi device:04: registered as cooling_device2
> [   14.308479] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input10
> [   14.310326] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> [   14.310466] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [   14.603377] lp: driver loaded but no devices found
> [   14.610928] ppdev: user-space parallel port driver
> [   17.794824] Ebtables v2.0 registered
> [   17.809543] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [   18.204652] wlan0: authenticate with 00:22:90:93:49:d0 (try 1)
> [   18.213234] wlan0: authenticated
> [   18.268777] wlan0: associate with 00:22:90:93:49:d0 (try 1)
> [   18.462396] wlan0: associate with 00:22:90:93:49:d0 (try 2)
> [   18.480746] wlan0: RX AssocResp from 00:22:90:93:49:d0 (capab=0x431 status=0 aid=6)
> [   18.480750] wlan0: associated
> [   18.480753] wlan0: moving STA 00:22:90:93:49:d0 to state 1
> [   18.480755] wlan0: moving STA 00:22:90:93:49:d0 to state 2
> [   18.542165] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   18.542234] cfg80211: Calling CRDA for country: US
> [   18.546200] cfg80211: Regulatory domain changed to country: US
> [   18.546204] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [   18.546207] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
> [   18.546210] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
> [   18.546212] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   18.546215] cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   18.546217] cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   18.546220] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
> [   19.633036] wlan0: moving STA 00:22:90:93:49:d0 to state 3
> [   30.191204] wlan0: no IPv6 routers present
> [  476.389422] ------------[ cut here ]------------
> [  476.389440] WARNING: at kernel/time/tick-sched.c:567 tick_nohz_irq_exit+0x11e/0x194()

Ah nice one. Were you running a specific testsuite?
I'll try to figure out what happened once I have access to a testbox.

Thanks.

> [  476.389447] Hardware name: LifeBook S6510
> [  476.389452] Modules linked in: kvm_intel kvm ip6table_filter ip6_tables iptable_filter ebtable_nat ebtables acpi_cpufreq mperf cpufreq_ondemand cpufreq_conservative cpufreq_userspace cpufreq_stats freq_table cpufreq_powersave parport_pc ppdev lp parport binfmt_misc i915 drm_kms_helper drm i2c_algo_bit uinput deflate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common camellia serpent_sse2_x86_64 xts lrw gf128mul serpent_generic blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic xcbc rmd160 sha512_generic crypto_null af_key fuse nfs nfs_acl lockd auth_rpcgss sunrpc ipv6 loop sha256_generic aes_x86_64 cryptd aes_generic cbc dm_crypt usbhid hid arc4 apanel input_polldev i2c_i801 i2c_core serio_raw pcspkr psmouse evdev tpm_infineon iwl4965 iwlegacy mac80211 cfg80211 rfkill video ac iTCO_wdt intel_agp battery button processor intel_gtt agpgart ext4 crc16 jbd2 btrfs crc32c libcrc32c zlib_deflate dm_mod firewire_ohci sdhci_pci sdhci firewire_core
>  pata_acpi ata_generic thermal thermal_sys mmc_core crc_itu_t ahci libahci ata_piix sky2 [last unloaded: scsi_wait_scan]
> [  476.389700] Pid: 9, comm: kworker/1:0 Not tainted 3.3.1-1-amd64-vyatta #1
> [  476.389707] Call Trace:
> [  476.389711]  <IRQ>  [<ffffffff81037e38>] ? warn_slowpath_common+0x78/0x8c
> [  476.389732]  [<ffffffff8106f6c2>] ? tick_nohz_irq_exit+0x11e/0x194
> [  476.389743]  [<ffffffff8103d40b>] ? irq_exit+0x73/0x79
> [  476.389753]  [<ffffffff8100fbd7>] ? do_IRQ+0x82/0x98
> [  476.389766]  [<ffffffff8135af6e>] ? common_interrupt+0x6e/0x6e
> [  476.389771]  <EOI>  [<ffffffff81014f09>] ? native_read_tsc+0x2/0xf
> [  476.389794]  [<ffffffff811a4515>] ? paravirt_read_tsc+0x5/0x8
> [  476.389804]  [<ffffffff811a45b0>] ? delay_tsc+0x29/0x5e
> [  476.389816]  [<ffffffffa0486063>] ? sclhi+0x5d/0x63 [i2c_algo_bit]
> [  476.389827]  [<ffffffffa04861d7>] ? i2c_outb.isra.4+0x3c/0x8e [i2c_algo_bit]
> [  476.389838]  [<ffffffffa04865e4>] ? bit_xfer+0x34b/0x3fc [i2c_algo_bit]
> [  476.389849]  [<ffffffff810532d4>] ? __hrtimer_start_range_ns+0x297/0x2b8
> [  476.389883]  [<ffffffffa0509e58>] ? intel_i2c_quirk_xfer+0x71/0xb9 [i915]
> [  476.389901]  [<ffffffffa029596b>] ? i2c_transfer+0x90/0xf3 [i2c_core]
> [  476.389929]  [<ffffffffa05063c5>] ? intel_sdvo_write_cmd+0x25f/0x2e5 [i915]
> [  476.389940]  [<ffffffff811a383e>] ? vsnprintf+0x3ee/0x427
> [  476.389969]  [<ffffffffa0508a5c>] ? intel_sdvo_detect+0x2d/0x1e0 [i915]
> [  476.389980]  [<ffffffff8104c015>] ? queue_delayed_work_on+0xb0/0xc8
> [  476.389996]  [<ffffffffa04d121c>] ? output_poll_execute+0x97/0x16c [drm_kms_helper]
> [  476.390008]  [<ffffffffa04d1185>] ? drm_format_num_planes+0x8a/0x8a [drm_kms_helper]
> [  476.390018]  [<ffffffff8104c20c>] ? process_one_work+0x157/0x296
> [  476.390028]  [<ffffffff8104cc77>] ? worker_thread+0xc2/0x145
> [  476.390037]  [<ffffffff8104cbb5>] ? manage_workers.isra.24+0x15b/0x15b
> [  476.390046]  [<ffffffff8104ff44>] ? kthread+0x7d/0x85
> [  476.390056]  [<ffffffff8135cbe4>] ? kernel_thread_helper+0x4/0x10
> [  476.390066]  [<ffffffff8104fec7>] ? kthread_freezable_should_stop+0x37/0x37
> [  476.390075]  [<ffffffff8135cbe0>] ? gs_change+0x13/0x13
> [  476.390081] ---[ end trace f87639a4a779b971 ]---
> [  769.514514] ------------[ cut here ]------------
> [  769.514523] WARNING: at kernel/time/tick-sched.c:706 tick_nohz_account_ticks+0x77/0x80()
> [  769.514526] Hardware name: LifeBook S6510
> [  769.514527] Modules linked in: kvm_intel kvm ip6table_filter ip6_tables iptable_filter ebtable_nat ebtables acpi_cpufreq mperf cpufreq_ondemand cpufreq_conservative cpufreq_userspace cpufreq_stats freq_table cpufreq_powersave parport_pc ppdev lp parport binfmt_misc i915 drm_kms_helper drm i2c_algo_bit uinput deflate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common camellia serpent_sse2_x86_64 xts lrw gf128mul serpent_generic blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic xcbc rmd160 sha512_generic crypto_null af_key fuse nfs nfs_acl lockd auth_rpcgss sunrpc ipv6 loop sha256_generic aes_x86_64 cryptd aes_generic cbc dm_crypt usbhid hid arc4 apanel input_polldev i2c_i801 i2c_core serio_raw pcspkr psmouse evdev tpm_infineon iwl4965 iwlegacy mac80211 cfg80211 rfkill video ac iTCO_wdt intel_agp battery button processor intel_gtt agpgart ext4 crc16 jbd2 btrfs crc32c libcrc32c zlib_deflate dm_mod firewire_ohci sdhci_pci sdhci firewire_core
>  pata_acpi ata_generic thermal thermal_sys mmc_core crc_itu_t ahci libahci ata_piix sky2 [last unloaded: scsi_wait_scan]
> [  769.514619] Pid: 0, comm: swapper/0 Tainted: G        W    3.3.1-1-amd64-vyatta #1
> [  769.514621] Call Trace:
> [  769.514623]  <IRQ>  [<ffffffff81037e38>] ? warn_slowpath_common+0x78/0x8c
> [  769.514632]  [<ffffffff8106eee9>] ? tick_nohz_account_ticks+0x77/0x80
> [  769.514635]  [<ffffffff8106fb59>] ? tick_nohz_flush_current_times+0x24/0x48
> [  769.514639]  [<ffffffff81073a0b>] ? generic_smp_call_function_single_interrupt+0xca/0xeb
> [  769.514644]  [<ffffffff81024800>] ? smp_call_function_single_interrupt+0x10/0x20
> [  769.514649]  [<ffffffff8135c6ce>] ? call_function_single_interrupt+0x6e/0x80
> [  769.514650]  <EOI>  [<ffffffff8106e1bc>] ? tick_notify+0x1fc/0x354
> [  769.514657]  [<ffffffff81055884>] ? arch_local_irq_enable+0x4/0x8
> [  769.514660]  [<ffffffff81057ec6>] ? finish_task_switch+0x44/0xc2
> [  769.514665]  [<ffffffff8135a40e>] ? __schedule+0x444/0x4ae
> [  769.514669]  [<ffffffff8101452d>] ? paravirt_read_tsc+0x5/0x8
> [  769.514673]  [<ffffffff8100d245>] ? cpu_idle+0xa7/0xac
> [  769.514676]  [<ffffffff8168eabc>] ? start_kernel+0x342/0x34d
> [  769.514680]  [<ffffffff8168e140>] ? early_idt_handlers+0x140/0x140
> [  769.514683]  [<ffffffff8168e3c3>] ? x86_64_start_kernel+0x104/0x111
> [  769.514685] ---[ end trace f87639a4a779b972 ]---
