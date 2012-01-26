Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab2AZJrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:47:21 -0500
Received: from bar.sig21.net ([80.81.252.164]:55426 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab2AZJrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:47:13 -0500
Date: Thu, 26 Jan 2012 10:46:59 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-3.2.1 + KVM: TSC unstable on Core i5-2400S / H67
Message-ID: <20120126094659.GA25282@sig21.net>
References: <20120124113608.GA16876@sig21.net>
 <20120125122702.GA30888@amt.cnet>
 <20120125132503.GA3399@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120125132503.GA3399@sig21.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 02:25:03PM +0100, Johannes Stezenbach wrote:
> On Wed, Jan 25, 2012 at 10:27:03AM -0200, Marcelo Tosatti wrote:
> > On Tue, Jan 24, 2012 at 12:36:08PM +0100, Johannes Stezenbach wrote:
> > > 
> > > [23379.612251] usb 2-1.2: new high-speed USB device number 6 using ehci_hcd
> > > [    0.006666] Marking TSC unstable due to KVM discovered backwards TSC
> > > [23421.511167] Switching to clocksource hpet
> ...
> > Can you please apply the following patch, and report back when it
> > reproduces again.
> 
> I applied the patch and rebooted, I'll let you know
> as soon as the issue reappears.

Today I got a "BUG: spinlock bad magic" right after resume,
and then the TSC message.  I'll just add the full dmesg
from after resume.  I didn't get this BUG before.

Thanks,
Johannes

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.1 (root@zzz) (gcc version 4.6.2 (Debian 4.6.2-12) ) #2 SMP PREEMPT Wed Jan 25 14:14:58 CET 2012
[    0.000000] Command line: root=/dev/mapper/zzz-croot libata.force=3:1.5G ro 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
[    0.000000]  BIOS-e820: 0000000040200000 - 00000000cac19000 (usable)
[    0.000000]  BIOS-e820: 00000000cac19000 - 00000000cac75000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cac75000 - 00000000cada8000 (reserved)
[    0.000000]  BIOS-e820: 00000000cada8000 - 00000000cadb9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cadb9000 - 00000000cadd0000 (reserved)
[    0.000000]  BIOS-e820: 00000000cadd0000 - 00000000cadd2000 (usable)
[    0.000000]  BIOS-e820: 00000000cadd2000 - 00000000cadd3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cadd3000 - 00000000caddb000 (reserved)
[    0.000000]  BIOS-e820: 00000000caddb000 - 00000000cade5000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cade5000 - 00000000cae41000 (reserved)
[    0.000000]  BIOS-e820: 00000000cae41000 - 00000000cae84000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cae84000 - 00000000cb000000 (usable)
[    0.000000]  BIOS-e820: 00000000cb800000 - 00000000cfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000012fe00000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: System manufacturer System Product Name/P8H67-V, BIOS 0806 10/26/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x12fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 100000000 mask FC0000000 write-back
[    0.000000]   2 base 0CB800000 mask FFF800000 uncachable
[    0.000000]   3 base 0CC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   5 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   6 base 12FE00000 mask FFFE00000 uncachable
[    0.000000]   7 base 130000000 mask FF0000000 uncachable
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000cb800000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcb000 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000cb000000
[    0.000000]  0000000000 - 00cb000000 page 2M
[    0.000000] kernel direct mapping tables up to cb000000 @ 1fffb000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000012fe00000
[    0.000000]  0100000000 - 012fe00000 page 2M
[    0.000000] kernel direct mapping tables up to 12fe00000 @ caffa000-cb000000
[    0.000000] RAMDISK: 1fd66000 - 1fff0000
[    0.000000] ACPI: RSDP 00000000000f0420 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000cac68068 0004C (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000cac718e0 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000cac68140 0979E (v02 ALASKA    A M I 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000caddcf80 00040
[    0.000000] ACPI: APIC 00000000cac719d8 00072 (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000cac71a50 00102 (v01 AMICPU     PROC 00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 00000000cac71b58 0003C (v01 ALASKA    A M I 01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cac71b98 00038 (v01 ALASKA    A M I 01072009 AMI. 00000004)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0004bfffff] PMD -> [ffff88012b400000-ffff88012f3fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0012fe00
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040000
[    0.000000]     0: 0x00040200 -> 0x000cac19
[    0.000000]     0: 0x000cadd0 -> 0x000cadd2
[    0.000000]     0: 0x000cae84 -> 0x000cb000
[    0.000000]     0: 0x00100000 -> 0x0012fe00
[    0.000000] On node 0 totalpages: 1025828
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3912 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 809431 pages, LIFO batch:31
[    0.000000]   Normal zone: 3064 pages used for memmap
[    0.000000]   Normal zone: 193032 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
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
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 00000000cac19000 - 00000000cac75000
[    0.000000] PM: Registered nosave memory: 00000000cac75000 - 00000000cada8000
[    0.000000] PM: Registered nosave memory: 00000000cada8000 - 00000000cadb9000
[    0.000000] PM: Registered nosave memory: 00000000cadb9000 - 00000000cadd0000
[    0.000000] PM: Registered nosave memory: 00000000cadd2000 - 00000000cadd3000
[    0.000000] PM: Registered nosave memory: 00000000cadd3000 - 00000000caddb000
[    0.000000] PM: Registered nosave memory: 00000000caddb000 - 00000000cade5000
[    0.000000] PM: Registered nosave memory: 00000000cade5000 - 00000000cae41000
[    0.000000] PM: Registered nosave memory: 00000000cae41000 - 00000000cae84000
[    0.000000] PM: Registered nosave memory: 00000000cb000000 - 00000000cb800000
[    0.000000] PM: Registered nosave memory: 00000000cb800000 - 00000000cfa00000
[    0.000000] PM: Registered nosave memory: 00000000cfa00000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at cfa00000 (gap: cfa00000:2f31c000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff88012ac00000 s1914688 r8192 d22720 u2097152
[    0.000000] pcpu-alloc: s1914688 r8192 d22720 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1006375
[    0.000000] Kernel command line: root=/dev/mapper/zzz-croot libata.force=3:1.5G ro 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3933028k/4978688k available (5497k kernel code, 875376k absent, 170284k reserved, 5579k data, 2572k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	CONFIG_RCU_FANOUT set to non-default value of 32
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.003333] Detected 2508.599 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 5019.24 BogoMIPS (lpj=8361996)
[    0.000194] pid_max: default: 32768 minimum: 301
[    0.000358] Mount-cache hash table entries: 256
[    0.000849] Initializing cgroup subsys debug
[    0.000943] Initializing cgroup subsys cpuacct
[    0.001042] Initializing cgroup subsys memory
[    0.001174] Initializing cgroup subsys devices
[    0.001269] Initializing cgroup subsys freezer
[    0.001363] Initializing cgroup subsys blkio
[    0.001464] Initializing cgroup subsys perf_event
[    0.001606] CPU: Physical Processor ID: 0
[    0.001699] CPU: Processor Core ID: 0
[    0.001794] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.001795] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.001989] mce: CPU supports 9 MCE banks
[    0.002092] CPU0: Thermal monitoring enabled (TM1)
[    0.002199] using mwait in idle threads.
[    0.003309] ACPI: Core revision 20110623
[    0.016301] ftrace: allocating 23282 entries in 92 pages
[    0.025721] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.058807] CPU0: Intel(R) Core(TM) i5-2400S CPU @ 2.50GHz stepping 07
[    0.164331] Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
[    0.164592] PEBS disabled due to CPU errata.
[    0.164691] ... version:                3
[    0.164783] ... bit width:              48
[    0.164875] ... generic registers:      8
[    0.164967] ... value mask:             0000ffffffffffff
[    0.165061] ... max period:             000000007fffffff
[    0.165157] ... fixed-purpose events:   3
[    0.165248] ... event mask:             00000007000000ff
[    0.191178] NMI watchdog enabled, takes one hw-pmu counter.
[    0.210999] lockdep: fixing up alternatives.
[    0.217703] Booting Node   0, Processors  #1
[    0.217789] smpboot cpu 1: start_ip = 98000
[    0.331096] NMI watchdog enabled, takes one hw-pmu counter.
[    0.350909] lockdep: fixing up alternatives.
[    0.351043]  #2
[    0.351085] smpboot cpu 2: start_ip = 98000
[    0.464277] NMI watchdog enabled, takes one hw-pmu counter.
[    0.484165] lockdep: fixing up alternatives.
[    0.484298]  #3 Ok.
[    0.484387] smpboot cpu 3: start_ip = 98000
[    0.597594] NMI watchdog enabled, takes one hw-pmu counter.
[    0.604093] Brought up 4 CPUs
[    0.604196] Total of 4 processors activated (20075.68 BogoMIPS).
[    0.607633] devtmpfs: initialized
[    0.608062] PM: Registering ACPI NVS region at cac19000 (376832 bytes)
[    0.608167] PM: Registering ACPI NVS region at cada8000 (69632 bytes)
[    0.608265] PM: Registering ACPI NVS region at cadd2000 (4096 bytes)
[    0.609680] PM: Registering ACPI NVS region at caddb000 (40960 bytes)
[    0.609778] PM: Registering ACPI NVS region at cae41000 (274432 bytes)
[    0.610884] NET: Registered protocol family 16
[    0.611801] ACPI: bus type pci registered
[    0.612065] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.612214] PCI: not using MMCONFIG
[    0.612305] PCI: Using configuration type 1 for base access
[    0.625738] bio: create slab <bio-0> at 0
[    0.626042] ACPI: Added _OSI(Module Device)
[    0.626136] ACPI: Added _OSI(Processor Device)
[    0.626230] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.626324] ACPI: Added _OSI(Processor Aggregator Device)
[    0.633898] ACPI: EC: Look up EC in DSDT
[    0.641821] ACPI: Executed 1 blocks of module-level executable AML code
[    0.646493] ACPI Error: [RAMB] Namespace lookup failure, AE_NOT_FOUND (20110623/psargs-359)
[    0.646758] ACPI Exception: AE_NOT_FOUND, Could not execute arguments for [RAMW] (Region) (20110623/nsinit-349)
[    0.647299] ACPI: SSDT 00000000caddbc18 0038C (v01    AMI      IST 00000001 MSFT 03000001)
[    0.649469] ACPI: Dynamic OEM Table Load:
[    0.649638] ACPI: SSDT           (null) 0038C (v01    AMI      IST 00000001 MSFT 03000001)
[    0.649887] ACPI: SSDT 00000000caddce18 00084 (v01    AMI      CST 00000001 MSFT 03000001)
[    0.651996] ACPI: Dynamic OEM Table Load:
[    0.652166] ACPI: SSDT           (null) 00084 (v01    AMI      CST 00000001 MSFT 03000001)
[    0.653287] ACPI: Interpreter enabled
[    0.653381] ACPI: (supports S0 S1 S3 S4 S5)
[    0.653700] ACPI: Using IOAPIC for interrupt routing
[    0.653823] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.654060] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in ACPI motherboard resources
[    0.678629] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.695762] ACPI: No dock devices found.
[    0.695857] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.696232] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.696640] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.696738] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.696835] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.696980] pci_root PNP0A08:00: host bridge window [mem 0x000c8000-0x000dffff]
[    0.697124] pci_root PNP0A08:00: host bridge window [mem 0xcfa00000-0xffffffff]
[    0.697273] pci_root PNP0A08:00: ignoring host bridge window [mem 0x000c8000-0x000dffff] (conflicts with Video ROM [mem 0x000c0000-0x000cdfff])
[    0.697458] pci 0000:00:00.0: [8086:0100] type 0 class 0x000600
[    0.697541] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    0.697601] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.697615] pci 0000:00:01.0: PME# disabled
[    0.697657] pci 0000:00:02.0: [8086:0102] type 0 class 0x000300
[    0.697681] pci 0000:00:02.0: reg 10: [mem 0xfe000000-0xfe3fffff 64bit]
[    0.697694] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.697703] pci 0000:00:02.0: reg 20: [io  0xf000-0xf03f]
[    0.697821] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    0.697866] pci 0000:00:16.0: reg 10: [mem 0xfe608000-0xfe60800f 64bit]
[    0.697989] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.697996] pci 0000:00:16.0: PME# disabled
[    0.698062] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    0.698103] pci 0000:00:1a.0: reg 10: [mem 0xfe607000-0xfe6073ff]
[    0.698251] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.698258] pci 0000:00:1a.0: PME# disabled
[    0.698305] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    0.698336] pci 0000:00:1b.0: reg 10: [mem 0xfe600000-0xfe603fff 64bit]
[    0.698456] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.698462] pci 0000:00:1b.0: PME# disabled
[    0.698503] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    0.698632] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.698639] pci 0000:00:1c.0: PME# disabled
[    0.698687] pci 0000:00:1c.2: [8086:1c14] type 1 class 0x000604
[    0.698816] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.698822] pci 0000:00:1c.2: PME# disabled
[    0.698869] pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
[    0.698999] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.699005] pci 0000:00:1c.3: PME# disabled
[    0.699053] pci 0000:00:1c.5: [8086:1c1a] type 1 class 0x000604
[    0.699182] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.699189] pci 0000:00:1c.5: PME# disabled
[    0.699234] pci 0000:00:1c.6: [8086:1c1c] type 1 class 0x000604
[    0.699364] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.699371] pci 0000:00:1c.6: PME# disabled
[    0.699416] pci 0000:00:1c.7: [8086:244e] type 1 class 0x000604
[    0.699546] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.699552] pci 0000:00:1c.7: PME# disabled
[    0.699604] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    0.699645] pci 0000:00:1d.0: reg 10: [mem 0xfe606000-0xfe6063ff]
[    0.699793] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.699800] pci 0000:00:1d.0: PME# disabled
[    0.699842] pci 0000:00:1f.0: [8086:1c4a] type 0 class 0x000601
[    0.700057] pci 0000:00:1f.2: [8086:1c02] type 0 class 0x000106
[    0.700098] pci 0000:00:1f.2: reg 10: [io  0xf0b0-0xf0b7]
[    0.700114] pci 0000:00:1f.2: reg 14: [io  0xf0a0-0xf0a3]
[    0.700130] pci 0000:00:1f.2: reg 18: [io  0xf090-0xf097]
[    0.700146] pci 0000:00:1f.2: reg 1c: [io  0xf080-0xf083]
[    0.700162] pci 0000:00:1f.2: reg 20: [io  0xf060-0xf07f]
[    0.700179] pci 0000:00:1f.2: reg 24: [mem 0xfe605000-0xfe6057ff]
[    0.700254] pci 0000:00:1f.2: PME# supported from D3hot
[    0.700260] pci 0000:00:1f.2: PME# disabled
[    0.700293] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    0.700324] pci 0000:00:1f.3: reg 10: [mem 0xfe604000-0xfe6040ff 64bit]
[    0.700370] pci 0000:00:1f.3: reg 20: [io  0xf040-0xf05f]
[    0.700475] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.700668] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.700878] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.701080] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.701323] pci 0000:05:00.0: [1b21:1042] type 0 class 0x000c03
[    0.701369] pci 0000:05:00.0: reg 10: [mem 0xfe500000-0xfe507fff 64bit]
[    0.701569] pci 0000:05:00.0: PME# supported from D3hot D3cold
[    0.701578] pci 0000:05:00.0: PME# disabled
[    0.701668] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    0.701772] pci 0000:00:1c.5:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.701908] pci 0000:06:00.0: [1969:1083] type 0 class 0x000200
[    0.701952] pci 0000:06:00.0: reg 10: [mem 0xfe400000-0xfe43ffff 64bit]
[    0.701975] pci 0000:06:00.0: reg 18: [io  0xe000-0xe07f]
[    0.702132] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.702141] pci 0000:06:00.0: PME# disabled
[    0.707396] pci 0000:00:1c.6: PCI bridge to [bus 06-06]
[    0.707505] pci 0000:00:1c.6:   bridge window [io  0xe000-0xefff]
[    0.707512] pci 0000:00:1c.6:   bridge window [mem 0xfe400000-0xfe4fffff]
[    0.707634] pci 0000:07:00.0: [1b21:1080] type 1 class 0x000604
[    0.707804] pci 0000:00:1c.7: PCI bridge to [bus 07-08] (subtractive decode)
[    0.707920] pci 0000:00:1c.7:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.707923] pci 0000:00:1c.7:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.707925] pci 0000:00:1c.7:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.707927] pci 0000:00:1c.7:   bridge window [mem 0xcfa00000-0xffffffff] (subtractive decode)
[    0.708112] pci 0000:07:00.0: PCI bridge to [bus 08-08] (subtractive decode)
[    0.708243] pci 0000:07:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.708246] pci 0000:07:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.708248] pci 0000:07:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.708250] pci 0000:07:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.708253] pci 0000:07:00.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.708255] pci 0000:07:00.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.708257] pci 0000:07:00.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.708259] pci 0000:07:00.0:   bridge window [mem 0xcfa00000-0xffffffff] (subtractive decode)
[    0.708337] pci_bus 0000:00: on NUMA node 0
[    0.708341] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.708530] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.708581] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.708631] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.708674] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.708723] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
[    0.708766] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX6._PRT]
[    0.708823] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX7.BR19._PRT]
[    0.709010]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.709346]  pci0000:00: ACPI _OSC control (0x1c) granted
[    0.720056] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.720685] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.721304] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.721880] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.722455] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.723072] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.723686] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.724310] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.725199] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.725373] vgaarb: loaded
[    0.725463] vgaarb: bridge control possible 0000:00:02.0
[    0.725769] SCSI subsystem initialized
[    0.726053] libata version 3.00 loaded.
[    0.726191] usbcore: registered new interface driver usbfs
[    0.726355] usbcore: registered new interface driver hub
[    0.726531] usbcore: registered new device driver usb
[    0.726981] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.727078] PCI: Using ACPI for IRQ routing
[    0.730105] PCI: pci_cache_line_size set to 64 bytes
[    0.730271] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    0.730274] reserve RAM buffer: 00000000cac19000 - 00000000cbffffff 
[    0.730279] reserve RAM buffer: 00000000cadd2000 - 00000000cbffffff 
[    0.730282] reserve RAM buffer: 00000000cb000000 - 00000000cbffffff 
[    0.730285] reserve RAM buffer: 000000012fe00000 - 000000012fffffff 
[    0.730651] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.731102] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.733239] Switching to clocksource hpet
[    0.760667] pnp: PnP ACPI init
[    0.760780] ACPI: bus type pnp registered
[    0.761034] pnp 00:00: [bus 00-ff]
[    0.761037] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.761039] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.761041] pnp 00:00: [io  0x0d00-0xffff window]
[    0.761043] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.761045] pnp 00:00: [mem 0x000c8000-0x000dffff window]
[    0.761047] pnp 00:00: [mem 0xcfa00000-0xffffffff window]
[    0.761049] pnp 00:00: [mem 0x00000000 window]
[    0.761261] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.761338] pnp 00:01: [mem 0xfed10000-0xfed19fff]
[    0.761340] pnp 00:01: [mem 0xe0000000-0xe3ffffff]
[    0.761342] pnp 00:01: [mem 0xfed90000-0xfed93fff]
[    0.761343] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    0.761345] pnp 00:01: [mem 0xfee00000-0xfee0ffff]
[    0.761491] system 00:01: [mem 0xfed10000-0xfed19fff] has been reserved
[    0.761590] system 00:01: [mem 0xe0000000-0xe3ffffff] has been reserved
[    0.761689] system 00:01: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.761786] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.761885] system 00:01: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.761985] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.762059] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.762061] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.762063] pnp 00:02: [io  0x0290-0x029f]
[    0.762065] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.762205] system 00:02: [io  0x0290-0x029f] has been reserved
[    0.762303] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.762471] pnp 00:03: [dma 4]
[    0.762473] pnp 00:03: [io  0x0000-0x000f]
[    0.762475] pnp 00:03: [io  0x0081-0x0083]
[    0.762476] pnp 00:03: [io  0x0087]
[    0.762478] pnp 00:03: [io  0x0089-0x008b]
[    0.762480] pnp 00:03: [io  0x008f]
[    0.762481] pnp 00:03: [io  0x00c0-0x00df]
[    0.762582] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.762601] pnp 00:04: [io  0x0070-0x0071]
[    0.762614] pnp 00:04: [irq 8]
[    0.762716] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.762730] pnp 00:05: [io  0x0061]
[    0.762831] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.762856] pnp 00:06: [io  0x0010-0x001f]
[    0.762858] pnp 00:06: [io  0x0022-0x003f]
[    0.762861] pnp 00:06: [io  0x0044-0x005f]
[    0.762862] pnp 00:06: [io  0x0063]
[    0.762864] pnp 00:06: [io  0x0065]
[    0.762865] pnp 00:06: [io  0x0067-0x006f]
[    0.762867] pnp 00:06: [io  0x0072-0x007f]
[    0.762869] pnp 00:06: [io  0x0080]
[    0.762871] pnp 00:06: [io  0x0084-0x0086]
[    0.762872] pnp 00:06: [io  0x0088]
[    0.762874] pnp 00:06: [io  0x008c-0x008e]
[    0.762875] pnp 00:06: [io  0x0090-0x009f]
[    0.762877] pnp 00:06: [io  0x00a2-0x00bf]
[    0.762878] pnp 00:06: [io  0x00e0-0x00ef]
[    0.762880] pnp 00:06: [io  0x04d0-0x04d1]
[    0.763026] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.763126] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.763141] pnp 00:07: [io  0x00f0-0x00ff]
[    0.763149] pnp 00:07: [irq 13]
[    0.763253] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.763548] pnp 00:08: [io  0x03f8-0x03ff]
[    0.763556] pnp 00:08: [irq 4]
[    0.763558] pnp 00:08: [dma 0 disabled]
[    0.763705] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.763738] pnp 00:09: [io  0x0060]
[    0.763740] pnp 00:09: [io  0x0064]
[    0.763748] pnp 00:09: [irq 1]
[    0.763869] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.764028] pnp 00:0a: [io  0x0400-0x0453]
[    0.764030] pnp 00:0a: [io  0x0458-0x047f]
[    0.764032] pnp 00:0a: [io  0x0000-0xffffffffffffffff disabled]
[    0.764034] pnp 00:0a: [io  0x0500-0x057f]
[    0.764036] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    0.764038] pnp 00:0a: [mem 0xfec00000-0xfecfffff]
[    0.764040] pnp 00:0a: [mem 0xfed08000-0xfed08fff]
[    0.764042] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    0.764194] system 00:0a: [io  0x0400-0x0453] has been reserved
[    0.764292] system 00:0a: [io  0x0458-0x047f] has been reserved
[    0.764389] system 00:0a: [io  0x0500-0x057f] has been reserved
[    0.764486] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.764584] system 00:0a: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.764683] system 00:0a: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.764781] system 00:0a: [mem 0xff000000-0xffffffff] has been reserved
[    0.764880] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.764932] pnp 00:0b: [io  0x0454-0x0457]
[    0.765082] system 00:0b: [io  0x0454-0x0457] has been reserved
[    0.765180] system 00:0b: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.765492] pnp 00:0c: [mem 0xfed00000-0xfed003ff]
[    0.765657] pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.765918] pnp: PnP ACPI: found 13 devices
[    0.766011] ACPI: ACPI bus type pnp unregistered
[    0.778953] PCI: max bus depth: 2 pci_try_num: 3
[    0.779066] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.779170] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.779284] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.779398] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.779512] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    0.779614] pci 0000:00:1c.5:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.779725] pci 0000:00:1c.6: PCI bridge to [bus 06-06]
[    0.779821] pci 0000:00:1c.6:   bridge window [io  0xe000-0xefff]
[    0.779924] pci 0000:00:1c.6:   bridge window [mem 0xfe400000-0xfe4fffff]
[    0.780044] pci 0000:07:00.0: PCI bridge to [bus 08-08]
[    0.780168] pci 0000:00:1c.7: PCI bridge to [bus 07-08]
[    0.780297] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.780398] pci 0000:00:01.0: setting latency timer to 64
[    0.780415] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.780517] pci 0000:00:1c.0: setting latency timer to 64
[    0.780534] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.780635] pci 0000:00:1c.2: setting latency timer to 64
[    0.780653] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.780755] pci 0000:00:1c.3: setting latency timer to 64
[    0.780766] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.780867] pci 0000:00:1c.5: setting latency timer to 64
[    0.780878] pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.780980] pci 0000:00:1c.6: setting latency timer to 64
[    0.780991] pci 0000:00:1c.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.781093] pci 0000:00:1c.7: setting latency timer to 64
[    0.781104] pci 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.781207] pci 0000:07:00.0: setting latency timer to 64
[    0.781213] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.781215] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.781217] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.781219] pci_bus 0000:00: resource 7 [mem 0xcfa00000-0xffffffff]
[    0.781222] pci_bus 0000:05: resource 1 [mem 0xfe500000-0xfe5fffff]
[    0.781224] pci_bus 0000:06: resource 0 [io  0xe000-0xefff]
[    0.781226] pci_bus 0000:06: resource 1 [mem 0xfe400000-0xfe4fffff]
[    0.781228] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    0.781230] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    0.781232] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    0.781234] pci_bus 0000:07: resource 7 [mem 0xcfa00000-0xffffffff]
[    0.781236] pci_bus 0000:08: resource 8 [io  0x0000-0x0cf7]
[    0.781238] pci_bus 0000:08: resource 9 [io  0x0d00-0xffff]
[    0.781240] pci_bus 0000:08: resource 10 [mem 0x000a0000-0x000bffff]
[    0.781242] pci_bus 0000:08: resource 11 [mem 0xcfa00000-0xffffffff]
[    0.781306] NET: Registered protocol family 2
[    0.781585] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.782322] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.783096] TCP bind hash table entries: 32768 (order: 9, 2621440 bytes)
[    0.784483] TCP: Hash tables configured (established 262144 bind 32768)
[    0.784596] TCP reno registered
[    0.784694] UDP hash table entries: 2048 (order: 6, 393216 bytes)
[    0.784963] UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
[    0.785348] NET: Registered protocol family 1
[    0.785690] RPC: Registered named UNIX socket transport module.
[    0.785787] RPC: Registered udp transport module.
[    0.785881] RPC: Registered tcp transport module.
[    0.785974] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.786086] pci 0000:00:02.0: Boot video device
[    1.033346] PCI: CLS 64 bytes, default 64
[    1.033453] Unpacking initramfs...
[    1.084553] Freeing initrd memory: 2600k freed
[    1.084917] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.085016] Placing 64MB software IO TLB between ffff8800c6c19000 - ffff8800cac19000
[    1.085162] software IO TLB at phys 0xc6c19000 - 0xcac19000
[    1.091666] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    1.094579] sha1_ssse3: Using AVX optimized SHA-1 implementation
[    1.109313] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.109775] fuse init (API version 7.17)
[    1.110308] msgmni has been set to 7686
[    1.111335] alg: No test for stdrng (krng)
[    1.111450] io scheduler noop registered
[    1.111543] io scheduler deadline registered
[    1.111744] io scheduler cfq registered (default)
[    1.111844] start plist test
[    1.113315] end plist test
[    1.113634] pcieport 0000:00:01.0: setting latency timer to 64
[    1.113691] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    1.113894] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.113979] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    1.114152] pcieport 0000:00:1c.2: setting latency timer to 64
[    1.114236] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    1.114408] pcieport 0000:00:1c.3: setting latency timer to 64
[    1.114492] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    1.114666] pcieport 0000:00:1c.5: setting latency timer to 64
[    1.114750] pcieport 0000:00:1c.5: irq 44 for MSI/MSI-X
[    1.114922] pcieport 0000:00:1c.6: setting latency timer to 64
[    1.115006] pcieport 0000:00:1c.6: irq 45 for MSI/MSI-X
[    1.115850] intel_idle: MWAIT substates: 0x1120
[    1.115851] intel_idle: v0.4 model 0x2A
[    1.115853] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.116270] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.116432] ACPI: Power Button [PWRB]
[    1.116751] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.116904] ACPI: Power Button [PWRF]
[    1.170194] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.190948] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.424279] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.460218] Real Time Clock Driver v1.12b
[    1.460716] Non-volatile memory driver v1.3
[    1.460847] Linux agpgart interface v0.103
[    1.461258] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    1.461564] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    1.463159] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    1.463465] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.463652] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    1.463800] Hangcheck: Using getrawmonotonic().
[    1.463983] [drm] Initialized drm 1.1.0 20060810
[    1.464101] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.464200] i915 0000:00:02.0: setting latency timer to 64
[    1.589530] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    1.589695] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    1.591049] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[    1.591056] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.591155] [drm] Driver supports precise vblank timestamp query.
[    1.591319] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.904432] fbcon: inteldrmfb (fb0) is primary device
[    2.079426] Console: switching to colour frame buffer device 240x75
[    2.085905] fb0: inteldrmfb frame buffer device
[    2.085931] drm: registered panic notifier
[    2.086015] Refined TSC clocksource calibration: 2508.443 MHz.
[    2.086050] Switching to clocksource tsc
[    2.087658] fixme: max PWM is zero.
[    2.088006] acpi device:33: registered as cooling_device4
[    2.088411] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    2.088465] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.088590] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.090880] loop: module loaded
[    2.091276] ahci 0000:00:1f.2: version 3.0
[    2.091301] ahci 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    2.091405] ahci 0000:00:1f.2: irq 47 for MSI/MSI-X
[    2.102717] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    2.102763] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[    2.102810] ahci 0000:00:1f.2: setting latency timer to 64
[    2.137648] scsi0 : ahci
[    2.137903] scsi1 : ahci
[    2.138113] scsi2 : ahci
[    2.138321] scsi3 : ahci
[    2.138529] scsi4 : ahci
[    2.138750] scsi5 : ahci
[    2.139185] ata1: SATA max UDMA/133 abar m2048@0xfe605000 port 0xfe605100 irq 47
[    2.139226] ata2: SATA max UDMA/133 abar m2048@0xfe605000 port 0xfe605180 irq 47
[    2.139266] ata3: FORCE: PHY spd limit set to 1.5Gbps
[    2.139301] ata3: SATA max UDMA/133 abar m2048@0xfe605000 port 0xfe605200 irq 47
[    2.139341] ata4: SATA max UDMA/133 abar m2048@0xfe605000 port 0xfe605280 irq 47
[    2.139381] ata5: SATA max UDMA/133 abar m2048@0xfe605000 port 0xfe605300 irq 47
[    2.139421] ata6: SATA max UDMA/133 abar m2048@0xfe605000 port 0xfe605380 irq 47
[    2.139889] tun: Universal TUN/TAP device driver, 1.6
[    2.139919] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.140160] atl1c 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.140206] atl1c 0000:06:00.0: setting latency timer to 64
[    2.256845] atl1c 0000:06:00.0: version 1.0.1.0-NAPI
[    2.257271] usbcore: registered new interface driver uas
[    2.257301] Initializing USB Mass Storage driver...
[    2.257396] usbcore: registered new interface driver usb-storage
[    2.257429] USB Mass Storage support registered.
[    2.257612] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    2.257648] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    2.258428] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.258770] mousedev: PS/2 mouse device common for all mice
[    2.259393] i2c /dev entries driver
[    2.261536] w83627ehf: Found NCT6776F chip at 0x290
[    2.262697] device-mapper: uevent: version 1.0.3
[    2.262942] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    2.264016] cpuidle: using governor ladder
[    2.265949] cpuidle: using governor menu
[    2.267050] EFI Variables Facility v0.08 2004-May-17
[    2.269907] usbcore: registered new interface driver usbhid
[    2.269940] usbhid: USB HID core driver
[    2.272249] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.272378] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[    2.272428] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[    2.280315] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    2.459173] ata5: SATA link down (SStatus 0 SControl 300)
[    2.460954] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.462731] ata4: SATA link down (SStatus 0 SControl 300)
[    2.464500] ata3: SATA link down (SStatus 0 SControl 310)
[    2.466267] ata2: SATA link down (SStatus 0 SControl 300)
[    2.467999] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.469756] ata6.00: ATAPI: HL-DT-STDVD-RAM GH22LS30, 1.00, max UDMA/100
[    2.471543] ata1.00: HPA detected: current 976771055, native 976773168
[    2.473310] ata1.00: ATA-8: WDC WD5000AACS-00G8B0, 05.04C05, max UDMA/133
[    2.474985] ata1.00: 976771055 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.476716] ata6.00: configured for UDMA/100
[    2.479182] ata1.00: configured for UDMA/133
[    2.481137] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000AACS-0 05.0 PQ: 0 ANSI: 5
[    2.483596] sd 0:0:0:0: [sda] 976771055 512-byte logical blocks: (500 GB/465 GiB)
[    2.484072] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.486970] sd 0:0:0:0: [sda] Write Protect is off
[    2.488088] scsi 5:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GH22LS30 1.00 PQ: 0 ANSI: 5
[    2.490191] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.490230] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.490371] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.490373] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.490912] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    2.491233] sr 5:0:0:0: Attached scsi generic sg1 type 5
[    2.518374]  sda: sda1 sda2
[    2.521176] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.805813] hda_codec: ALC887-VD: BIOS auto-probing.
[    2.817524] ALSA device list:
[    2.819101]   #0: HDA Intel PCH at 0xfe600000 irq 48
[    2.820684] Netfilter messages via NETLINK v0.30.
[    2.822294] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.824484] ip_set: protocol 6
[    2.827712] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.829301] arp_tables: (C) 2002 David S. Miller
[    2.830852] TCP cubic registered
[    2.832367] NET: Registered protocol family 17
[    2.833993] Bridge firewalling registered
[    2.835497] Ebtables v2.0 registered
[    2.837997] registered taskstats version 1
[    2.846356] Freeing unused kernel memory: 2572k freed
[    2.848206] Write protecting the kernel read-only data: 10240k
[    2.851539] Freeing unused kernel memory: 628k freed
[    2.856302] Freeing unused kernel memory: 1300k freed
[    2.933381] udevd[1586]: starting version 175
[    9.470987] alg: No test for __cbc-aes-aesni (cryptd(__driver-cbc-aes-aesni))
[   10.280638] PM: Starting manual resume from disk
[   10.312511] kjournald starting.  Commit interval 5 seconds
[   10.312634] EXT3-fs (dm-1): mounted filesystem with writeback data mode
[   11.889493] udevd[1808]: starting version 175
[   12.675574] xhci_hcd 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   12.677181] xhci_hcd 0000:05:00.0: setting latency timer to 64
[   12.677197] xhci_hcd 0000:05:00.0: xHCI Host Controller
[   12.678857] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 1
[   12.690012] xhci_hcd 0000:05:00.0: irq 17, io mem 0xfe500000
[   12.691726] xhci_hcd 0000:05:00.0: irq 49 for MSI/MSI-X
[   12.691735] xhci_hcd 0000:05:00.0: irq 50 for MSI/MSI-X
[   12.691744] xhci_hcd 0000:05:00.0: irq 51 for MSI/MSI-X
[   12.691753] xhci_hcd 0000:05:00.0: irq 52 for MSI/MSI-X
[   12.691762] xhci_hcd 0000:05:00.0: irq 53 for MSI/MSI-X
[   12.692166] xHCI xhci_add_endpoint called for root hub
[   12.692168] xHCI xhci_check_bandwidth called for root hub
[   12.692238] hub 1-0:1.0: USB hub found
[   12.693901] hub 1-0:1.0: 2 ports detected
[   12.695650] xhci_hcd 0000:05:00.0: xHCI Host Controller
[   12.697399] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 2
[   12.699186] xHCI xhci_add_endpoint called for root hub
[   12.699189] xHCI xhci_check_bandwidth called for root hub
[   12.699248] hub 2-0:1.0: USB hub found
[   12.700754] hub 2-0:1.0: 2 ports detected
[   12.744226] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   12.745878] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   12.747528] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[   12.747533] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[   12.749206] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   12.750812] ehci_hcd 0000:00:1a.0: debug port 2
[   12.756241] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[   12.756272] ehci_hcd 0000:00:1a.0: irq 23, io mem 0xfe607000
[   12.770199] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   12.771979] hub 3-0:1.0: USB hub found
[   12.773540] hub 3-0:1.0: 2 ports detected
[   12.775208] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   12.776783] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[   12.776787] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[   12.778216] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[   12.779691] ehci_hcd 0000:00:1d.0: debug port 2
[   12.785126] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[   12.785134] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xfe606000
[   12.800188] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   12.801945] hub 4-0:1.0: USB hub found
[   12.803475] hub 4-0:1.0: 2 ports detected
[   13.080056] usb 3-1: new high-speed USB device number 2 using ehci_hcd
[   13.204038] hub 3-1:1.0: USB hub found
[   13.205493] hub 3-1:1.0: 6 ports detected
[   13.313284] usb 4-1: new high-speed USB device number 2 using ehci_hcd
[   13.440822] hub 4-1:1.0: USB hub found
[   13.442327] hub 4-1:1.0: 8 ports detected
[   13.713135] usb 4-1.5: new low-speed USB device number 3 using ehci_hcd
[   13.820487] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.5/4-1.5:1.0/input/input4
[   13.822399] generic-usb 0003:046D:C050.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1.5/input0
[   15.001424] EXT3-fs (dm-1): using internal journal
[   15.758443] Adding 3903484k swap on /dev/mapper/zzz-cswap.  Priority:-1 extents:1 across:3903484k 
[   16.489711] kjournald starting.  Commit interval 5 seconds
[   16.495099] EXT3-fs (dm-3): using internal journal
[   16.497145] EXT3-fs (dm-3): mounted filesystem with writeback data mode
[   16.536416] kjournald starting.  Commit interval 5 seconds
[   16.536846] EXT3-fs (dm-4): using internal journal
[   16.536856] EXT3-fs (dm-4): mounted filesystem with writeback data mode
[   17.866508] device eth0 entered promiscuous mode
[   17.869987] atl1c 0000:06:00.0: irq 54 for MSI/MSI-X
[   17.870110] atl1c 0000:06:00.0: atl1c: eth0 NIC Link is Up<1000 Mbps Full Duplex>
[   17.874758] device brtap0 entered promiscuous mode
[   17.882187] br0: port 1(eth0) entering forwarding state
[   17.884413] br0: port 1(eth0) entering forwarding state
[  152.502080] br0: port 2(brtap0) entering forwarding state
[  152.502093] br0: port 2(brtap0) entering forwarding state
[ 3202.032203] usb 4-1.2: new high-speed USB device number 4 using ehci_hcd
[16266.375704] usb 4-1.2: USB disconnect, device number 4
[16351.507673] PM: Syncing filesystems ... done.
[16351.630070] Freezing user space processes ... (elapsed 0.03 seconds) done.
[16351.669142] PM: Preallocating image memory... done (allocated 340490 pages)
[16351.794992] PM: Allocated 1361960 kbytes in 0.12 seconds (11349.66 MB/s)
[16351.795020] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[16351.806781] Suspending console(s) (use no_console_suspend to debug)
[16351.807779] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[16351.808729] i8042 kbd 00:09: wake-up capability enabled by ACPI
[16351.809156] serial 00:08: disabled
[16351.809166] serial 00:08: wake-up capability disabled by ACPI
[16351.809551] snd_hda_intel 0000:00:1b.0: PCI INT A disabled
[16351.809624] ACPI handle has no context!
[16351.809650] br0: port 1(eth0) entering forwarding state
[16351.829675] PM: freeze of devices complete after 22.874 msecs
[16351.831060] PM: late freeze of devices complete after 1.381 msecs
[16351.831062] Disabling non-boot CPUs ...
[16351.834016] kvm: disabling virtualization on CPU1
[16351.834041] CPU 1 is now offline
[16351.837527] kvm: disabling virtualization on CPU2
[16351.837555] CPU 2 is now offline
[16351.839770] kvm: disabling virtualization on CPU3
[16351.839815] CPU 3 is now offline
[16351.839817] lockdep: fixing up alternatives.
[16351.840469] Extended CMOS year: 2000
[16351.840580] PM: Creating hibernation image:
[16351.916977] PM: Need to copy 338911 pages
[16351.840919] Extended CMOS year: 2000
[16351.840956] Enabling non-boot CPUs ...
[16351.847918] lockdep: fixing up alternatives.
[16351.847925] Booting Node 0 Processor 1 APIC 0x2
[16351.847927] smpboot cpu 1: start_ip = 98000
[16351.859046] Calibrating delay loop (skipped) already calibrated this CPU
[16351.859099] kvm: enabling virtualization on CPU1
[16351.880239] NMI watchdog enabled, takes one hw-pmu counter.
[16351.880576] ACPI Error: The DSDT has been corrupted or replaced - old, new headers below (20110623/tbutils-372)
[16351.880581] ACPI: DSDT           (null) 0979E (v02 ALASKA    A M I 00000000 INTL 20051117)
[16351.880587] ACPI: DSDT           (null) 0979E (v02 ALASKA    A M I 00000000 INTL 20051117)
[16351.880591] ACPI Error: Please send DMI info to linux-acpi@vger.kernel.org
[16351.880593] If system does not work as expected, please boot with acpi=copy_dsdt (20110623/tbutils-378)
[16351.880813] CPU1 is up
[16351.881299] lockdep: fixing up alternatives.
[16351.881306] Booting Node 0 Processor 2 APIC 0x4
[16351.881308] smpboot cpu 2: start_ip = 98000
[16351.892429] Calibrating delay loop (skipped) already calibrated this CPU
[16351.892483] kvm: enabling virtualization on CPU2
[16351.913836] NMI watchdog enabled, takes one hw-pmu counter.
[16351.914377] CPU2 is up
[16351.914879] lockdep: fixing up alternatives.
[16351.914886] Booting Node 0 Processor 3 APIC 0x6
[16351.914888] smpboot cpu 3: start_ip = 98000
[16351.925906] Calibrating delay loop (skipped) already calibrated this CPU
[16351.925960] kvm: enabling virtualization on CPU3
[16351.947612] NMI watchdog enabled, takes one hw-pmu counter.
[16351.948132] CPU3 is up
[16351.962797] snd_hda_intel 0000:00:1b.0: BAR 0: set to [mem 0xfe600000-0xfe603fff 64bit] (PCI address [0xfe600000-0xfe603fff])
[16351.962826] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x103)
[16351.962859] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[16351.962869] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
[16351.963770] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, writing 0x2b00407)
[16351.963976] xhci_hcd 0000:05:00.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100406)
[16351.964885] PM: early restore of devices complete after 13.340 msecs
[16352.028856] i915 0000:00:02.0: setting latency timer to 64
[16352.028865] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[16352.028889] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[16352.028899] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[16352.028915] usb usb3: root hub lost power or was reset
[16352.028976] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[16352.029081] pci 0000:00:1c.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[16352.029088] pci 0000:00:1c.7: setting latency timer to 64
[16352.029103] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[16352.029144] usb usb4: root hub lost power or was reset
[16352.029220] ahci 0000:00:1f.2: setting latency timer to 64
[16352.029266] xhci_hcd 0000:05:00.0: setting latency timer to 64
[16352.029272] usb usb1: root hub lost power or was reset
[16352.029274] usb usb2: root hub lost power or was reset
[16352.032801] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[16352.032884] pci 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[16352.032894] pci 0000:07:00.0: setting latency timer to 64
[16352.032984] sd 0:0:0:0: [sda] Starting disk
[16352.033034] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[16352.039526] xhci_hcd 0000:05:00.0: irq 49 for MSI/MSI-X
[16352.039535] xhci_hcd 0000:05:00.0: irq 50 for MSI/MSI-X
[16352.039543] xhci_hcd 0000:05:00.0: irq 51 for MSI/MSI-X
[16352.039551] xhci_hcd 0000:05:00.0: irq 52 for MSI/MSI-X
[16352.039559] xhci_hcd 0000:05:00.0: irq 53 for MSI/MSI-X
[16352.040200] serial 00:08: activated
[16352.040233] i8042 kbd 00:09: wake-up capability disabled by ACPI
[16352.136554] atl1c 0000:06:00.0: irq 54 for MSI/MSI-X
[16352.352536] ata3: SATA link down (SStatus 0 SControl 310)
[16352.359222] ata4: SATA link down (SStatus 0 SControl 300)
[16352.365859] ata2: SATA link down (SStatus 0 SControl 300)
[16352.372528] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[16352.374572] ata1.00: configured for UDMA/133
[16352.379190] ata5: SATA link down (SStatus 0 SControl 300)
[16352.379212] usb 4-1: reset high-speed USB device number 2 using ehci_hcd
[16352.385884] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[16352.388473] ata6.00: configured for UDMA/100
[16352.609124] usb 3-1: reset high-speed USB device number 2 using ehci_hcd
[16352.989022] usb 4-1.5: reset low-speed USB device number 3 using ehci_hcd
[16353.265737] PM: restore of devices complete after 1237.652 msecs
[16353.270435] Restarting tasks ... 
[16353.270612] BUG: spinlock bad magic on CPU#2, dhclient3/2590
[16353.274702]  lock: ffff880127b9ce08, .magic: 00000000, .owner: dhclient3/2590, .owner_cpu: 2
[16353.276594] Pid: 2590, comm: dhclient3 Not tainted 3.2.1 #2
[16353.278294] done.
[16353.278314] video LNXVIDEO:00: Restoring backlight state
[16353.281627] Call Trace:
[16353.281633]  [<ffffffff81552515>] spin_dump+0x8a/0x8f
[16353.281636]  [<ffffffff81552540>] spin_bug+0x26/0x28
[16353.281639]  [<ffffffff81285af8>] do_raw_spin_unlock+0x1e/0x83
[16353.281643]  [<ffffffff8155912e>] _raw_spin_unlock_irq+0x28/0x5b
[16353.281647]  [<ffffffff8105e427>] get_signal_to_deliver+0x546/0x57c
[16353.281651]  [<ffffffff81001572>] do_signal+0x3e/0x62f
[16353.281654]  [<ffffffff815595b8>] ? retint_restore_args+0x13/0x13
[16353.281657]  [<ffffffff81280079>] ? copy_user_generic_string+0x19/0x40
[16353.281661]  [<ffffffff81142e8c>] ? poll_select_copy_remaining+0xc5/0xe9
[16353.281664]  [<ffffffff81001ba8>] do_notify_resume+0x2c/0x53
[16353.281666]  [<ffffffff8128137e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[16353.281669]  [<ffffffff8155a1d6>] int_signal+0x12/0x17
[16353.472289] tsc = fffffd60248a9f39 last_guest_tsc = 229a823d4b88
[    0.006666] Marking TSC unstable due to KVM discovered backwards TSC
[16362.155512] Switching to clocksource hpet
[16363.617844] atl1c 0000:06:00.0: atl1c: eth0 NIC Link is Up<1000 Mbps Full Duplex>
[16363.618145] br0: port 1(eth0) entering forwarding state
[16363.618153] br0: port 1(eth0) entering forwarding state
