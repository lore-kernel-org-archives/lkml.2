Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1GVC3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 22:29:54 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50340 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab1GVC3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 22:29:52 -0400
Date: Thu, 21 Jul 2011 19:29:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: RKK <kulkarni.ravi4@gmail.com>
Cc: kernelmail.jms@gmail.com, linux-kernel@vger.kernel.org, cmm@us.ibm.com
Subject: Re: Fw: RCU boot debug patch
Message-ID: <20110722022937.GB2408@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110719224142.GT2357@linux.vnet.ibm.com>
 <CAM=x7SbY8Z8jmarRougaJPxxR8gHi2MKtCUkq8Yi4JYCBo=JAw@mail.gmail.com>
 <20110720145939.GB2352@linux.vnet.ibm.com>
 <CAM=x7SbUJyZuCsgc_mfkgYZ4hyZz4iK7ASs7hyW5jfyGP-2Zwg@mail.gmail.com>
 <20110720160946.GA2313@linux.vnet.ibm.com>
 <CAM=x7SYYSPGhqYmEAUqe6pc2N=Djg-aG31P5nSmPGDsMORBmyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM=x7SYYSPGhqYmEAUqe6pc2N=Djg-aG31P5nSmPGDsMORBmyA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 11:09:57AM +0530, RKK wrote:
> On Wed, Jul 20, 2011 at 9:39 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Jul 20, 2011 at 09:23:06PM +0530, RKK wrote:
> >> Hi Paul
> >>
> >> >>
> >> >> On Wed, Jul 20, 2011 at 4:11 AM, Paul E. McKenney
> >> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> >> > Hello, Julie and Ravi,
> >> >> >
> >> >> > Although we arrived at a patch that worked for both of you, we never did
> >> >> > identify exactly which RCU callback (or other issue) that was causing
> >> >> > the problem.  It would be good to do this in case there is some other
> >> >> > problem lurking that might bite us in the future.  Mingming has therefore
> >> >> > put together the following diagnostic patch which should identify the
> >> >> > callbacks, please see below.
> >> >> >
> >> >> > So could you please run this and let us know what you find?  There should
> >> >> > at least be a message for artificial_callback().
> >> >> >
> >> >>
> >> >>  Do i need to  apply this patch on today's Linus master or on -rc7 ?
> >> >
> >> > Please do not use -rc7, as that would reproduce your hang.  Linus master
> >> > tree would be best, but -rc7 with the fix applied would work fine as well.
> >> >
> >>
> >> Ok. will apply against Linus Master tree and get back to you sometime
> >> later tonight.
> >
> 
> I applied and booted into today's Linus master tree today . it booted
> fine.  Im attaching the dmesg output for you. you want anyother info?

Thank you again for the testing, Ravi!

It appears that you are running with CONFIG_TREE_RCU=y, and therefore
CONFIG_RCU_BOOST=n.  It looks like I do need to take a look at a few
additional things.  Again, thank you for testing this!

							Thanx, Paul

> Warm Regards,
> Ravi Kulkarni.

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.0.0-rc7+ (root@localhost.localdomain) (gcc version 4.6.0 20110428 (Red Hat 4.6.0-6) (GCC) ) #1 SMP Thu Jul 21 10:17:30 IST 2011
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd949000 (usable)
> [    0.000000]  BIOS-e820: 00000000bd949000 - 00000000bd96b000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bd96b000 - 00000000bda5e000 (reserved)
> [    0.000000]  BIOS-e820: 00000000bda5e000 - 00000000bda61000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bda61000 - 00000000bdb5d000 (reserved)
> [    0.000000]  BIOS-e820: 00000000bdb5d000 - 00000000bdb5e000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bdb5e000 - 00000000bdb66000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bdb66000 - 00000000bdb70000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bdb70000 - 00000000bdb8e000 (reserved)
> [    0.000000]  BIOS-e820: 00000000bdb8e000 - 00000000bdb94000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bdb94000 - 00000000bdd00000 (usable)
> [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.4 present.
> [    0.000000] DMI:                  /DG43NB, BIOS NBG4310H.86A.0054.2008.0813.1914 08/13/2008
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> [    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x1000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-E7FFF uncachable
> [    0.000000]   E8000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask F00000000 write-back
> [    0.000000]   1 base 0BDD00000 mask FFFF00000 write-through
> [    0.000000]   2 base 0BDE00000 mask FFFE00000 uncachable
> [    0.000000]   3 base 0BE000000 mask FFE000000 uncachable
> [    0.000000]   4 base 0C0000000 mask FC0000000 uncachable
> [    0.000000]   5 base 100000000 mask FC0000000 write-back
> [    0.000000]   6 base 13C000000 mask FFC000000 uncachable
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] initial memory mapped : 0 - 01200000
> [    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: 0000000000000000-00000000371fe000
> [    0.000000]  0000000000 - 0000200000 page 4k
> [    0.000000]  0000200000 - 0037000000 page 2M
> [    0.000000]  0037000000 - 00371fe000 page 4k
> [    0.000000] kernel direct mapping tables up to 371fe000 @ 11f6000-1200000
> [    0.000000] RAMDISK: 37055000 - 37ff0000
> [    0.000000] Allocated new RAMDISK: 360ba000 - 37054784
> [    0.000000] Move RAMDISK from 0000000037055000 - 0000000037fef783 to 360ba000 - 37054783
> [    0.000000] ACPI: RSDP 000f03b0 00024 (v02  INTEL)
> [    0.000000] ACPI: XSDT bdb64e18 0004C (v01 INTEL  DG43NB   00000036 MSFT 00010013)
> [    0.000000] ACPI Warning: Incorrect checksum in table [XSDT] - 0xB6, should be 0xA5 (20110413/tbutils-314)
> [    0.000000] ACPI: FACP bdb63d98 000F4 (v04  INTEL   DG43NB 06222004 MSFT 00010013)
> [    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20110413/tbfadt-369)
> [    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xBDB67F40/0x00000000BDB6DE40, using 32 (20110413/tbfadt-489)
> [    0.000000] ACPI: DSDT bdb5e018 04D1C (v01 INTEL    DG43NB 00000036 INTL 20051117)
> [    0.000000] ACPI: FACS bdb67f40 00040
> [    0.000000] ACPI: APIC bdb63f18 0006C (v02  INTEL   DG43NB 06222004 MSFT 00010013)
> [    0.000000] ACPI: MCFG bdb6ed98 0003C (v01 INTEL  DG43NB   06222004 MSFT 00000097)
> [    0.000000] ACPI: ASF! bdb6dc18 000A0 (v32 INTEL      DG43 06222004 TFSM 000F4240)
> [    0.000000] ACPI: HPET bdb6ed18 00038 (v01 INTEL  DG43NB   06222004 AMI. 00000003)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] 4174MB HIGHMEM available.
> [    0.000000] 881MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 371fe000
> [    0.000000]   low ram: 0 - 371fe000
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x000371fe
> [    0.000000]   HighMem  0x000371fe -> 0x0013c000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[4] active PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x000bd949
> [    0.000000]     0: 0x000bdb94 -> 0x000bdd00
> [    0.000000]     0: 0x00100000 -> 0x0013c000
> [    0.000000] On node 0 totalpages: 1022532
> [    0.000000] free_area_init_node: node 0, pgdat c0a72100, node_mem_map f393a200
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3951 pages, LIFO batch:0
> [    0.000000]   Normal zone: 1732 pages used for memmap
> [    0.000000]   Normal zone: 219962 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 8349 pages used for memmap
> [    0.000000]   HighMem zone: 788506 pages, LIFO batch:31
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> [    0.000000] Allocating PCI resources starting at bdd00000 (gap: bdd00000:4101c000)
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 13 pages/cpu @f3600000 s28736 r0 d24512 u524288
> [    0.000000] pcpu-alloc: s28736 r0 d24512 u524288 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1012419
> [    0.000000] Kernel command line: ro root=/dev/mapper/VolGroup-lv_root rd_LVM_LV=VolGroup/lv_root rd_LVM_LV=VolGroup/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us rhgb quiet
> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
> [    0.000000] allocated 20709120 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] Initializing HighMem for node 0 (000371fe:0013c000)
> [    0.000000] Memory: 4004124k/5177344k available (4083k kernel code, 86004k reserved, 2585k data, 596k init, 3187420k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xff575000 - 0xfffff000   (10792 kB)
> [    0.000000]     pkmap   : 0xff200000 - 0xff400000   (2048 kB)
> [    0.000000]     vmalloc : 0xf79fe000 - 0xff1fe000   ( 120 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xf71fe000   ( 881 MB)
> [    0.000000]       .init : 0xc0a84000 - 0xc0b19000   ( 596 kB)
> [    0.000000]       .data : 0xc07fce1c - 0xc0a833c0   (2585 kB)
> [    0.000000]       .text : 0xc0400000 - 0xc07fce1c   (4083 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] RCU scheduler is not active yet, Calling _call_rcu() with this function artificial_callback
> [    0.000000] NR_IRQS:2304
> [    0.000000] CPU 0 irqstacks, hard=f1c20000 soft=f1c22000
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2826.107 MHz processor.
> [    0.001002] Calibrating delay loop (skipped), value calculated using timer frequency.. 5652.21 BogoMIPS (lpj=2826107)
> [    0.001006] pid_max: default: 32768 minimum: 301
> [    0.001157] Security Framework initialized
> [    0.001165] SELinux:  Initializing.
> [    0.001185] SELinux:  Starting in permissive mode
> [    0.001280] Mount-cache hash table entries: 512
> [    0.002445] Initializing cgroup subsys cpuacct
> [    0.002491] Initializing cgroup subsys memory
> [    0.002511] Initializing cgroup subsys devices
> [    0.002513] Initializing cgroup subsys freezer
> [    0.002514] Initializing cgroup subsys net_cls
> [    0.002516] Initializing cgroup subsys blkio
> [    0.002570] CPU: Physical Processor ID: 0
> [    0.002571] CPU: Processor Core ID: 0
> [    0.002574] mce: CPU supports 6 MCE banks
> [    0.002580] CPU0: Thermal monitoring enabled (TM2)
> [    0.002583] using mwait in idle threads.
> [    0.002952] ACPI: Core revision 20110413
> [    0.005254] ftrace: allocating 23729 entries in 47 pages
> [    0.006032] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.006327] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.016861] CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
> [    0.016998] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
> [    0.016998] ... version:                2
> [    0.016998] ... bit width:              40
> [    0.016998] ... generic registers:      2
> [    0.016998] ... value mask:             000000ffffffffff
> [    0.016998] ... max period:             000000007fffffff
> [    0.016998] ... fixed-purpose events:   3
> [    0.016998] ... event mask:             0000000700000003
> [    0.016998] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.016998] CPU 1 irqstacks, hard=f1d12000 soft=f1d14000
> [    0.016998] Booting Node   0, Processors  #1
> [    0.016998] smpboot cpu 1: start_ip = 9b000
> [    0.001999] Initializing CPU#1
> [    0.088014] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.088104] CPU 2 irqstacks, hard=f1d20000 soft=f1d22000
> [    0.088106]  #2
> [    0.088107] smpboot cpu 2: start_ip = 9b000
> [    0.001999] Initializing CPU#2
> [    0.160001] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.160083] CPU 3 irqstacks, hard=f1d54000 soft=f1d56000
> [    0.160085]  #3 Ok.
> [    0.160086] smpboot cpu 3: start_ip = 9b000
> [    0.001999] Initializing CPU#3
> [    0.231989] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.232013] Brought up 4 CPUs
> [    0.232015] Total of 4 processors activated (22608.85 BogoMIPS).
> [    0.233227] devtmpfs: initialized
> [    0.233988] PM: Registering ACPI NVS region at bd949000 (139264 bytes)
> [    0.233997] PM: Registering ACPI NVS region at bda5e000 (12288 bytes)
> [    0.233999] PM: Registering ACPI NVS region at bdb5d000 (4096 bytes)
> [    0.234001] PM: Registering ACPI NVS region at bdb66000 (40960 bytes)
> [    0.234004] PM: Registering ACPI NVS region at bdb8e000 (24576 bytes)
> [    0.234773] atomic64 test passed for i586+ platform with CX8 and with SSE
> [    0.234797] Time: 10:42:35  Date: 07/21/11
> [    0.234878] NET: Registered protocol family 16
> [    0.235098] ACPI: bus type pci registered
> [    0.235277] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> [    0.235280] PCI: not using MMCONFIG
> [    0.252409] PCI: Using configuration type 1 for base access
> [    0.253324] bio: create slab <bio-0> at 0
> [    0.254661] ACPI: EC: Look up EC in DSDT
> [    0.255442] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.257435] ACPI: SSDT bdb67c18 002CC (v01    AMI      IST 00000001 MSFT 03000001)
> [    0.257676] ACPI: Dynamic OEM Table Load:
> [    0.257678] ACPI: SSDT   (null) 002CC (v01    AMI      IST 00000001 MSFT 03000001)
> [    0.257846] ACPI: Interpreter enabled
> [    0.257851] ACPI: (supports S0 S3 S4 S5)
> [    0.257865] ACPI: Using IOAPIC for interrupt routing
> [    0.257885] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> [    0.257915] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
> [    0.257917] PCI: Using MMCONFIG for extended config space
> [    0.258197] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.262242] ACPI: No dock devices found.
> [    0.262244] HEST: Table not found.
> [    0.262246] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.262363] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.262448] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
> [    0.262450] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
> [    0.262452] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
> [    0.262454] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xffffffff]
> [    0.262464] pci 0000:00:00.0: [8086:2e20] type 0 class 0x000600
> [    0.262495] pci 0000:00:02.0: [8086:2e22] type 0 class 0x000300
> [    0.262505] pci 0000:00:02.0: reg 10: [mem 0xd0000000-0xd03fffff 64bit]
> [    0.262511] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
> [    0.262516] pci 0000:00:02.0: reg 20: [io  0xf1a0-0xf1a7]
> [    0.262538] pci 0000:00:02.1: [8086:2e23] type 0 class 0x000380
> [    0.262546] pci 0000:00:02.1: reg 10: [mem 0xd0400000-0xd04fffff 64bit]
> [    0.262579] pci 0000:00:03.0: [8086:2e24] type 0 class 0x000780
> [    0.262591] pci 0000:00:03.0: reg 10: [mem 0xd0725900-0xd072590f 64bit]
> [    0.262624] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
> [    0.262626] pci 0000:00:03.0: PME# disabled
> [    0.262663] pci 0000:00:19.0: [8086:10ce] type 0 class 0x000200
> [    0.262678] pci 0000:00:19.0: reg 10: [mem 0xd0700000-0xd071ffff]
> [    0.262685] pci 0000:00:19.0: reg 14: [mem 0xd0724000-0xd0724fff]
> [    0.262693] pci 0000:00:19.0: reg 18: [io  0xf0c0-0xf0df]
> [    0.262734] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
> [    0.262737] pci 0000:00:19.0: PME# disabled
> [    0.262753] pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
> [    0.262789] pci 0000:00:1a.0: reg 20: [io  0xf0a0-0xf0bf]
> [    0.262825] pci 0000:00:1a.1: [8086:3a38] type 0 class 0x000c03
> [    0.262861] pci 0000:00:1a.1: reg 20: [io  0xf080-0xf09f]
> [    0.262908] pci 0000:00:1a.2: [8086:3a39] type 0 class 0x000c03
> [    0.262944] pci 0000:00:1a.2: reg 20: [io  0xf060-0xf07f]
> [    0.262993] pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
> [    0.263011] pci 0000:00:1a.7: reg 10: [mem 0xd0725400-0xd07257ff]
> [    0.263074] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> [    0.263078] pci 0000:00:1a.7: PME# disabled
> [    0.263097] pci 0000:00:1b.0: [8086:3a3e] type 0 class 0x000403
> [    0.263110] pci 0000:00:1b.0: reg 10: [mem 0xd0720000-0xd0723fff 64bit]
> [    0.263156] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.263159] pci 0000:00:1b.0: PME# disabled
> [    0.263175] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
> [    0.263221] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.263224] pci 0000:00:1c.0: PME# disabled
> [    0.263243] pci 0000:00:1c.3: [8086:3a46] type 1 class 0x000604
> [    0.263288] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    0.263291] pci 0000:00:1c.3: PME# disabled
> [    0.263314] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
> [    0.263350] pci 0000:00:1d.0: reg 20: [io  0xf040-0xf05f]
> [    0.263386] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
> [    0.263422] pci 0000:00:1d.1: reg 20: [io  0xf020-0xf03f]
> [    0.263459] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
> [    0.263495] pci 0000:00:1d.2: reg 20: [io  0xf000-0xf01f]
> [    0.263539] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
> [    0.263557] pci 0000:00:1d.7: reg 10: [mem 0xd0725000-0xd07253ff]
> [    0.263620] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.263623] pci 0000:00:1d.7: PME# disabled
> [    0.263640] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
> [    0.263686] pci 0000:00:1f.0: [8086:3a18] type 0 class 0x000601
> [    0.263778] pci 0000:00:1f.2: [8086:3a20] type 0 class 0x000101
> [    0.263791] pci 0000:00:1f.2: reg 10: [io  0xf190-0xf197]
> [    0.263797] pci 0000:00:1f.2: reg 14: [io  0xf180-0xf183]
> [    0.263804] pci 0000:00:1f.2: reg 18: [io  0xf170-0xf177]
> [    0.263811] pci 0000:00:1f.2: reg 1c: [io  0xf160-0xf163]
> [    0.263817] pci 0000:00:1f.2: reg 20: [io  0xf150-0xf15f]
> [    0.263824] pci 0000:00:1f.2: reg 24: [io  0xf140-0xf14f]
> [    0.263854] pci 0000:00:1f.3: [8086:3a30] type 0 class 0x000c05
> [    0.263867] pci 0000:00:1f.3: reg 10: [mem 0xd0725800-0xd07258ff 64bit]
> [    0.263895] pci 0000:00:1f.3: reg 20: [io  0x1180-0x119f]
> [    0.263921] pci 0000:00:1f.5: [8086:3a26] type 0 class 0x000101
> [    0.263934] pci 0000:00:1f.5: reg 10: [io  0xf130-0xf137]
> [    0.263941] pci 0000:00:1f.5: reg 14: [io  0xf120-0xf123]
> [    0.263947] pci 0000:00:1f.5: reg 18: [io  0xf110-0xf117]
> [    0.263954] pci 0000:00:1f.5: reg 1c: [io  0xf100-0xf103]
> [    0.263961] pci 0000:00:1f.5: reg 20: [io  0xf0f0-0xf0ff]
> [    0.263972] pci 0000:00:1f.5: reg 24: [io  0xf0e0-0xf0ef]
> [    0.264030] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
> [    0.264034] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
> [    0.264037] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
> [    0.264042] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
> [    0.264090] pci 0000:02:00.0: [197b:2368] type 0 class 0x000101
> [    0.264117] pci 0000:02:00.0: reg 10: [io  0xe040-0xe047]
> [    0.264130] pci 0000:02:00.0: reg 14: [io  0xe030-0xe033]
> [    0.264143] pci 0000:02:00.0: reg 18: [io  0xe020-0xe027]
> [    0.264156] pci 0000:02:00.0: reg 1c: [io  0xe010-0xe013]
> [    0.264168] pci 0000:02:00.0: reg 20: [io  0xe000-0xe00f]
> [    0.264235] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    0.264245] pci 0000:00:1c.3: PCI bridge to [bus 02-02]
> [    0.264248] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
> [    0.264251] pci 0000:00:1c.3:   bridge window [mem 0xd0600000-0xd06fffff]
> [    0.264256] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
> [    0.264289] pci 0000:03:06.0: [11c1:5811] type 0 class 0x000c00
> [    0.264303] pci 0000:03:06.0: reg 10: [mem 0xd0500000-0xd0500fff]
> [    0.264360] pci 0000:03:06.0: supports D1 D2
> [    0.264362] pci 0000:03:06.0: PME# supported from D0 D1 D2 D3hot
> [    0.264365] pci 0000:03:06.0: PME# disabled
> [    0.264398] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
> [    0.264401] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
> [    0.264405] pci 0000:00:1e.0:   bridge window [mem 0xd0500000-0xd05fffff]
> [    0.264409] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
> [    0.264412] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
> [    0.264414] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
> [    0.264416] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
> [    0.264418] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
> [    0.264430] pci_bus 0000:00: on NUMA node 0
> [    0.264433] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.264549] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
> [    0.264638] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
> [    0.264670] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
> [    0.264774]  pci0000:00: Requesting ACPI _OSC control (0x1d)
> [    0.264904]  pci0000:00: ACPI _OSC control (0x1d) granted
> [    0.269945] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.269988] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 *4 5 6 7 10 11 12 14 15)
> [    0.270025] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 15)
> [    0.270062] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
> [    0.270099] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.270135] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> [    0.270172] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 12 14 15)
> [    0.270211] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.270286] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.270297] vgaarb: loaded
> [    0.270298] vgaarb: bridge control possible 0000:00:02.0
> [    0.270375] SCSI subsystem initialized
> [    0.270396] libata version 3.00 loaded.
> [    0.270396] usbcore: registered new interface driver usbfs
> [    0.270396] usbcore: registered new interface driver hub
> [    0.270396] usbcore: registered new device driver usb
> [    0.270396] PCI: Using ACPI for IRQ routing
> [    0.275724] PCI: pci_cache_line_size set to 64 bytes
> [    0.275793] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
> [    0.275795] reserve RAM buffer: 00000000bd949000 - 00000000bfffffff 
> [    0.275798] reserve RAM buffer: 00000000bdd00000 - 00000000bfffffff 
> [    0.275904] NetLabel: Initializing
> [    0.275905] NetLabel:  domain hash size = 128
> [    0.275907] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.275915] NetLabel:  unlabeled traffic allowed by default
> [    0.275935] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
> [    0.275940] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
> [    0.275944] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
> [    0.278987] Switching to clocksource hpet
> [    0.279107] Switched to NOHz mode on CPU #0
> [    0.279161] Switched to NOHz mode on CPU #1
> [    0.279903] Switched to NOHz mode on CPU #3
> [    0.279906] Switched to NOHz mode on CPU #2
> [    0.285861] pnp: PnP ACPI init
> [    0.285871] ACPI: bus type pnp registered
> [    0.285916] pnp 00:00: [bus 00-ff]
> [    0.285918] pnp 00:00: [io  0x0cf8-0x0cff]
> [    0.285920] pnp 00:00: [io  0x0000-0x0cf7 window]
> [    0.285922] pnp 00:00: [io  0x0d00-0xffff window]
> [    0.285924] pnp 00:00: [mem 0x000a0000-0x000bffff window]
> [    0.285926] pnp 00:00: [mem 0x00000000 window]
> [    0.285928] pnp 00:00: [mem 0xc0000000-0xffffffff window]
> [    0.285966] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
> [    0.285992] pnp 00:01: [mem 0xfed14000-0xfed19fff]
> [    0.285994] pnp 00:01: [mem 0xe0000000-0xefffffff]
> [    0.286039] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
> [    0.286042] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
> [    0.286044] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.286113] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
> [    0.286116] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
> [    0.286151] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.286169] pnp 00:03: [io  0x0060]
> [    0.286170] pnp 00:03: [io  0x0064]
> [    0.286177] pnp 00:03: [irq 1]
> [    0.286207] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
> [    0.286222] pnp 00:04: [irq 12]
> [    0.286248] pnp 00:04: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
> [    0.286457] pnp 00:05: [io  0x03f8-0x03ff]
> [    0.286461] pnp 00:05: [irq 4]
> [    0.286463] pnp 00:05: [dma 0 disabled]
> [    0.286513] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.286523] pnp 00:06: [dma 4]
> [    0.286525] pnp 00:06: [io  0x0000-0x000f]
> [    0.286527] pnp 00:06: [io  0x0081-0x0083]
> [    0.286530] pnp 00:06: [io  0x0087]
> [    0.286531] pnp 00:06: [io  0x0089-0x008b]
> [    0.286533] pnp 00:06: [io  0x008f]
> [    0.286534] pnp 00:06: [io  0x00c0-0x00df]
> [    0.286557] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.286565] pnp 00:07: [io  0x0070-0x0071]
> [    0.286569] pnp 00:07: [irq 8]
> [    0.286590] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.286597] pnp 00:08: [io  0x0061]
> [    0.286618] pnp 00:08: Plug and Play ACPI device, IDs PNP0800 (active)
> [    0.286633] pnp 00:09: [io  0x0010-0x001f]
> [    0.286634] pnp 00:09: [io  0x0022-0x003f]
> [    0.286636] pnp 00:09: [io  0x0044-0x005f]
> [    0.286638] pnp 00:09: [io  0x0062-0x0063]
> [    0.286639] pnp 00:09: [io  0x0065-0x006f]
> [    0.286641] pnp 00:09: [io  0x0072-0x007f]
> [    0.286642] pnp 00:09: [io  0x0080]
> [    0.286644] pnp 00:09: [io  0x0084-0x0086]
> [    0.286645] pnp 00:09: [io  0x0088]
> [    0.286647] pnp 00:09: [io  0x008c-0x008e]
> [    0.286649] pnp 00:09: [io  0x0090-0x009f]
> [    0.286650] pnp 00:09: [io  0x00a2-0x00bf]
> [    0.286652] pnp 00:09: [io  0x00e0-0x00ef]
> [    0.286653] pnp 00:09: [io  0x04d0-0x04d1]
> [    0.286655] pnp 00:09: [mem 0xffe00000-0xffffffff]
> [    0.286657] pnp 00:09: [mem 0xfed30000-0xfed3ffff]
> [    0.286659] pnp 00:09: [mem 0xfed08000-0xfed08fff]
> [    0.286660] pnp 00:09: [io  0x0540-0x057f]
> [    0.286710] system 00:09: [io  0x04d0-0x04d1] has been reserved
> [    0.286713] system 00:09: [io  0x0540-0x057f] has been reserved
> [    0.286715] system 00:09: [mem 0xffe00000-0xffffffff] has been reserved
> [    0.286718] system 00:09: [mem 0xfed30000-0xfed3ffff] has been reserved
> [    0.286720] system 00:09: [mem 0xfed08000-0xfed08fff] has been reserved
> [    0.286723] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.286731] pnp 00:0a: [io  0x00f0-0x00ff]
> [    0.286735] pnp 00:0a: [irq 13]
> [    0.286758] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.286859] pnp 00:0b: [io  0x0400-0x047f]
> [    0.286860] pnp 00:0b: [io  0x1180-0x119f]
> [    0.286862] pnp 00:0b: [io  0x0500-0x053f]
> [    0.286864] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
> [    0.286865] pnp 00:0b: [mem 0xfec00000-0xfecfffff]
> [    0.286867] pnp 00:0b: [mem 0xfee00000-0xfee0ffff]
> [    0.286869] pnp 00:0b: [mem 0xff000000-0xffffffff]
> [    0.286909] system 00:0b: [io  0x0400-0x047f] has been reserved
> [    0.286911] system 00:0b: [io  0x1180-0x119f] has been reserved
> [    0.286913] system 00:0b: [io  0x0500-0x053f] has been reserved
> [    0.286916] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.286919] system 00:0b: [mem 0xfec00000-0xfecfffff] could not be reserved
> [    0.286921] system 00:0b: [mem 0xfee00000-0xfee0ffff] has been reserved
> [    0.286923] system 00:0b: [mem 0xff000000-0xffffffff] could not be reserved
> [    0.286926] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.286998] pnp 00:0c: [mem 0xfed00000-0xfed003ff]
> [    0.287036] pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.287147] pnp: PnP ACPI: found 13 devices
> [    0.287149] ACPI: ACPI bus type pnp unregistered
> [    0.323151] PCI: max bus depth: 1 pci_try_num: 2
> [    0.323176] pci 0000:00:1c.3: BAR 15: assigned [mem 0xd0800000-0xd09fffff 64bit pref]
> [    0.323181] pci 0000:00:1c.0: BAR 14: assigned [mem 0xd0a00000-0xd0bfffff]
> [    0.323187] pci 0000:00:1c.0: BAR 15: assigned [mem 0xd0c00000-0xd0dfffff 64bit pref]
> [    0.323190] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
> [    0.323192] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
> [    0.323195] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
> [    0.323199] pci 0000:00:1c.0:   bridge window [mem 0xd0a00000-0xd0bfffff]
> [    0.323202] pci 0000:00:1c.0:   bridge window [mem 0xd0c00000-0xd0dfffff 64bit pref]
> [    0.323207] pci 0000:00:1c.3: PCI bridge to [bus 02-02]
> [    0.323210] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
> [    0.323214] pci 0000:00:1c.3:   bridge window [mem 0xd0600000-0xd06fffff]
> [    0.323217] pci 0000:00:1c.3:   bridge window [mem 0xd0800000-0xd09fffff 64bit pref]
> [    0.323222] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
> [    0.323224] pci 0000:00:1e.0:   bridge window [io  disabled]
> [    0.323228] pci 0000:00:1e.0:   bridge window [mem 0xd0500000-0xd05fffff]
> [    0.323231] pci 0000:00:1e.0:   bridge window [mem pref disabled]
> [    0.323242] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    0.323246] pci 0000:00:1c.0: setting latency timer to 64
> [    0.323253] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [    0.323256] pci 0000:00:1c.3: setting latency timer to 64
> [    0.323261] pci 0000:00:1e.0: setting latency timer to 64
> [    0.323264] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.323266] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.323268] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.323270] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xffffffff]
> [    0.323272] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
> [    0.323274] pci_bus 0000:01: resource 1 [mem 0xd0a00000-0xd0bfffff]
> [    0.323276] pci_bus 0000:01: resource 2 [mem 0xd0c00000-0xd0dfffff 64bit pref]
> [    0.323278] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
> [    0.323280] pci_bus 0000:02: resource 1 [mem 0xd0600000-0xd06fffff]
> [    0.323282] pci_bus 0000:02: resource 2 [mem 0xd0800000-0xd09fffff 64bit pref]
> [    0.323284] pci_bus 0000:03: resource 1 [mem 0xd0500000-0xd05fffff]
> [    0.323286] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
> [    0.323287] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
> [    0.323289] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.323291] pci_bus 0000:03: resource 7 [mem 0xc0000000-0xffffffff]
> [    0.323351] NET: Registered protocol family 2
> [    0.323433] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.323591] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.323857] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.323984] TCP: Hash tables configured (established 131072 bind 65536)
> [    0.323986] TCP reno registered
> [    0.323988] UDP hash table entries: 512 (order: 2, 16384 bytes)
> [    0.323994] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> [    0.324263] NET: Registered protocol family 1
> [    0.324271] pci 0000:00:02.0: Boot video device
> [    1.424012] pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
> [    2.524014] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
> [    2.524142] PCI: CLS 64 bytes, default 64
> [    2.524185] Trying to unpack rootfs image as initramfs...
> [    2.847633] Freeing initrd memory: 15980k freed
> [    2.852848] apm: BIOS not found.
> [    2.853030] audit: initializing netlink socket (disabled)
> [    2.853042] type=2000 audit(1311244957.852:1): initialized
> [    2.875292] highmem bounce pool size: 64 pages
> [    2.875297] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    2.887516] VFS: Disk quotas dquot_6.5.2
> [    2.887691] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    2.888456] msgmni has been set to 1626
> [    2.888542] SELinux:  Registering netfilter hooks
> [    2.889112] NET: Registered protocol family 38
> [    2.889169] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    2.889262] io scheduler noop registered
> [    2.889264] io scheduler deadline registered
> [    2.889277] io scheduler cfq registered (default)
> [    2.889360] pcieport 0000:00:1c.0: setting latency timer to 64
> [    2.889392] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
> [    2.889466] pcieport 0000:00:1c.3: setting latency timer to 64
> [    2.889494] pcieport 0000:00:1c.3: irq 41 for MSI/MSI-X
> [    2.889587] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
> [    2.889591] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
> [    2.889606] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
> [    2.889608] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
> [    2.889611] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
> [    2.889625] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    2.889672] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 3a40 ss_vid 8086 ss_did 23
> [    2.889688] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
> [    2.889697] pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 3a46 ss_vid 8086 ss_did 23
> [    2.889711] pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
> [    2.889717] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    2.889718] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    2.889971] intel_idle: MWAIT substates: 0x22220
> [    2.889972] intel_idle: does not run on family 6 model 23
> [    2.890064] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
> [    2.890068] ACPI: Sleep Button [SLPB]
> [    2.890109] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    2.890111] ACPI: Power Button [PWRB]
> [    2.890146] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> [    2.890149] ACPI: Power Button [PWRF]
> [    2.890273] ACPI: acpi_idle registered with cpuidle
> [    2.891618] ERST: Table is not found!
> [    2.891628] isapnp: Scanning for PnP cards...
> [    3.247265] isapnp: No Plug & Play device found
> [    3.247319] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    3.267788] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    3.288583] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    3.288879] Non-volatile memory driver v1.3
> [    3.288881] Linux agpgart interface v0.103
> [    3.288995] agpgart-intel 0000:00:00.0: Intel G45/G43 Chipset
> [    3.289091] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
> [    3.290562] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
> [    3.290689] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
> [    3.292339] brd: module loaded
> [    3.292796] loop: module loaded
> [    3.292893] ata_piix 0000:00:1f.2: version 2.13
> [    3.292904] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    3.292908] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
> [    3.292941] ata_piix 0000:00:1f.2: setting latency timer to 64
> [    3.293230] scsi0 : ata_piix
> [    3.293324] scsi1 : ata_piix
> [    3.293361] ata1: SATA max UDMA/133 cmd 0xf190 ctl 0xf180 bmdma 0xf150 irq 19
> [    3.293365] ata2: SATA max UDMA/133 cmd 0xf170 ctl 0xf160 bmdma 0xf158 irq 19
> [    3.293384] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    3.293388] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
> [    3.293420] ata_piix 0000:00:1f.5: setting latency timer to 64
> [    3.293608] scsi2 : ata_piix
> [    3.293687] scsi3 : ata_piix
> [    3.293721] ata3: SATA max UDMA/133 cmd 0xf130 ctl 0xf120 bmdma 0xf0f0 irq 19
> [    3.293723] ata4: SATA max UDMA/133 cmd 0xf110 ctl 0xf100 bmdma 0xf0f8 irq 19
> [    3.293783] Fixed MDIO Bus: probed
> [    3.293831] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    3.293853] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    3.293864] ehci_hcd 0000:00:1a.7: setting latency timer to 64
> [    3.293867] ehci_hcd 0000:00:1a.7: EHCI Host Controller
> [    3.293908] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
> [    3.293929] ehci_hcd 0000:00:1a.7: debug port 1
> [    3.297828] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
> [    3.297839] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xd0725400
> [    3.307015] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
> [    3.307038] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    3.307041] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.307044] usb usb1: Product: EHCI Host Controller
> [    3.307046] usb usb1: Manufacturer: Linux 3.0.0-rc7+ ehci_hcd
> [    3.307048] usb usb1: SerialNumber: 0000:00:1a.7
> [    3.307166] hub 1-0:1.0: USB hub found
> [    3.307171] hub 1-0:1.0: 6 ports detected
> [    3.307243] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    3.307251] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    3.307254] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    3.307283] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
> [    3.307303] ehci_hcd 0000:00:1d.7: debug port 1
> [    3.311196] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
> [    3.311207] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd0725000
> [    3.321015] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    3.321031] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    3.321034] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.321037] usb usb2: Product: EHCI Host Controller
> [    3.321039] usb usb2: Manufacturer: Linux 3.0.0-rc7+ ehci_hcd
> [    3.321041] usb usb2: SerialNumber: 0000:00:1d.7
> [    3.321145] hub 2-0:1.0: USB hub found
> [    3.321149] hub 2-0:1.0: 6 ports detected
> [    3.321221] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    3.321232] uhci_hcd: USB Universal Host Controller Interface driver
> [    3.321249] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    3.321253] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [    3.321256] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    3.321288] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
> [    3.321315] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0a0
> [    3.321338] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    3.321340] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.321342] usb usb3: Product: UHCI Host Controller
> [    3.321343] usb usb3: Manufacturer: Linux 3.0.0-rc7+ uhci_hcd
> [    3.321345] usb usb3: SerialNumber: 0000:00:1a.0
> [    3.321419] hub 3-0:1.0: USB hub found
> [    3.321422] hub 3-0:1.0: 2 ports detected
> [    3.321475] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [    3.321480] uhci_hcd 0000:00:1a.1: setting latency timer to 64
> [    3.321482] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    3.321513] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
> [    3.321539] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000f080
> [    3.321563] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    3.321565] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.321567] usb usb4: Product: UHCI Host Controller
> [    3.321568] usb usb4: Manufacturer: Linux 3.0.0-rc7+ uhci_hcd
> [    3.321570] usb usb4: SerialNumber: 0000:00:1a.1
> [    3.321643] hub 4-0:1.0: USB hub found
> [    3.321646] hub 4-0:1.0: 2 ports detected
> [    3.321696] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    3.321700] uhci_hcd 0000:00:1a.2: setting latency timer to 64
> [    3.321703] uhci_hcd 0000:00:1a.2: UHCI Host Controller
> [    3.321734] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
> [    3.321753] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000f060
> [    3.321777] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    3.321779] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.321780] usb usb5: Product: UHCI Host Controller
> [    3.321782] usb usb5: Manufacturer: Linux 3.0.0-rc7+ uhci_hcd
> [    3.321784] usb usb5: SerialNumber: 0000:00:1a.2
> [    3.321857] hub 5-0:1.0: USB hub found
> [    3.321860] hub 5-0:1.0: 2 ports detected
> [    3.321912] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    3.321916] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    3.321919] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    3.321948] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
> [    3.321967] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f040
> [    3.321989] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    3.321991] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.321993] usb usb6: Product: UHCI Host Controller
> [    3.321997] usb usb6: Manufacturer: Linux 3.0.0-rc7+ uhci_hcd
> [    3.321998] usb usb6: SerialNumber: 0000:00:1d.0
> [    3.322084] hub 6-0:1.0: USB hub found
> [    3.322088] hub 6-0:1.0: 2 ports detected
> [    3.322140] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    3.322144] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    3.322147] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    3.322177] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
> [    3.322196] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f020
> [    3.322220] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
> [    3.322222] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.322224] usb usb7: Product: UHCI Host Controller
> [    3.322226] usb usb7: Manufacturer: Linux 3.0.0-rc7+ uhci_hcd
> [    3.322227] usb usb7: SerialNumber: 0000:00:1d.1
> [    3.322302] hub 7-0:1.0: USB hub found
> [    3.322305] hub 7-0:1.0: 2 ports detected
> [    3.322362] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    3.322366] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    3.322369] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    3.322401] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
> [    3.322421] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f000
> [    3.322443] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
> [    3.322446] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.322447] usb usb8: Product: UHCI Host Controller
> [    3.322449] usb usb8: Manufacturer: Linux 3.0.0-rc7+ uhci_hcd
> [    3.322450] usb usb8: SerialNumber: 0000:00:1d.2
> [    3.322521] hub 8-0:1.0: USB hub found
> [    3.322524] hub 8-0:1.0: 2 ports detected
> [    3.322619] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
> [    3.325588] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    3.325600] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    3.325723] mousedev: PS/2 mouse device common for all mice
> [    3.325917] rtc_cmos 00:07: RTC can wake from S4
> [    3.326044] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
> [    3.326065] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
> [    3.326139] device-mapper: uevent: version 1.0.3
> [    3.326202] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
> [    3.326252] cpuidle: using governor ladder
> [    3.326254] cpuidle: using governor menu
> [    3.326255] EFI Variables Facility v0.08 2004-May-17
> [    3.326385] usbcore: registered new interface driver usbhid
> [    3.326386] usbhid: USB HID core driver
> [    3.326402] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [    3.326538] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    3.326548] TCP cubic registered
> [    3.326550] Initializing XFRM netlink socket
> [    3.326559] NET: Registered protocol family 17
> [    3.326574] Registering the dns_resolver key type
> [    3.326590] Using IPI No-Shortcut mode
> [    3.326654] PM: Hibernation image not present or could not be loaded.
> [    3.326663] registered taskstats version 1
> [    3.331977] IMA: No TPM chip found, activating TPM-bypass!
> [    3.332302]   Magic number: 3:328:730
> [    3.332386] rtc_cmos 00:07: setting system clock to 2011-07-21 10:42:38 UTC (1311244958)
> [    3.332426] Initializing network drop monitor service
> [    3.345123] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
> [    3.608617] ata4: SATA link down (SStatus 0 SControl 300)
> [    3.759063] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    3.762290] ata3.00: ATA-7: ST3250310AS, 4.AAA, max UDMA/133
> [    3.762294] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    3.768235] ata3.00: configured for UDMA/133
> [    3.854031] Refined TSC clocksource calibration: 2826.249 MHz.
> [    3.854036] Switching to clocksource tsc
> [    3.914599] ata2.00: SATA link down (SStatus 0 SControl 300)
> [    3.914611] ata2.01: SATA link down (SStatus 0 SControl 300)
> [    3.925210] ata1.00: SATA link down (SStatus 0 SControl 300)
> [    3.925220] ata1.01: SATA link down (SStatus 0 SControl 300)
> [    3.925380] scsi 2:0:0:0: Direct-Access     ATA      ST3250310AS      4.AA PQ: 0 ANSI: 5
> [    3.925476] sd 2:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
> [    3.925495] sd 2:0:0:0: Attached scsi generic sg0 type 0
> [    3.925519] sd 2:0:0:0: [sda] Write Protect is off
> [    3.925522] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.925555] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    3.949913]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
> [    3.950315] sd 2:0:0:0: [sda] Attached SCSI disk
> [    3.950389] Freeing unused kernel memory: 596k freed
> [    3.950578] Write protecting the kernel text: 4084k
> [    3.950654] Write protecting the kernel read-only data: 1936k
> [    3.950663] NX-protecting the kernel data: 4108k
> [    3.976783] dracut: dracut-009-10.fc15
> [    3.989604] udev[112]: starting version 167
> [    4.016203] [drm] Initialized drm 1.1.0 20060810
> [    4.035569] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    4.035574] i915 0000:00:02.0: setting latency timer to 64
> [    4.053693] mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining
> [    4.053695] [drm] MTRR allocation failed.  Graphics performance may suffer.
> [    4.053999] i915 0000:00:02.0: irq 42 for MSI/MSI-X
> [    4.054020] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    4.054022] [drm] Driver supports precise vblank timestamp query.
> [    4.054047] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    4.071768] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input4
> [    4.159422] fbcon: inteldrmfb (fb0) is primary device
> [    4.193163] Console: switching to colour frame buffer device 160x64
> [    4.197800] fb0: inteldrmfb frame buffer device
> [    4.197801] drm: registered panic notifier
> [    4.197811] No ACPI video bus found
> [    4.197846] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [    4.207034] dracut: Starting plymouth daemon
> [    4.390230] pata_jmicron 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [    4.390256] pata_jmicron 0000:02:00.0: setting latency timer to 64
> [    4.391434] scsi4 : pata_jmicron
> [    4.392269] scsi5 : pata_jmicron
> [    4.392314] ata5: PATA max UDMA/100 cmd 0xe040 ctl 0xe030 bmdma 0xe000 irq 19
> [    4.392316] ata6: PATA max UDMA/100 cmd 0xe020 ctl 0xe010 bmdma 0xe008 irq 19
> [    4.696674] firewire_ohci 0000:03:06.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    4.747076] firewire_ohci: Added fw-ohci device 0000:03:06.0, OHCI v1.0, 8 IR + 8 IT contexts, quirks 0x0
> [    5.248093] firewire_core: created device fw0: GUID 009027000239fe4f, S400
> [    5.547880] dracut: Scanning devices sda7  for LVM logical volumes VolGroup/lv_root VolGroup/lv_swap
> [    5.711053] dracut: inactive '/dev/VolGroup/lv_swap' [4.91 GiB] inherit
> [    5.711113] dracut: inactive '/dev/VolGroup/lv_root' [41.47 GiB] inherit
> [    5.911524] Btrfs loaded
> [    5.912829] device fsid fcc37d87-f052-4392-a158-d83f9de3f069 devid 1 transid 35234 /dev/dm-1
> [    5.966655] device fsid fcc37d87-f052-4392-a158-d83f9de3f069 devid 1 transid 35234 /dev/mapper/VolGroup-lv_root
> [    6.390620] dracut: Checking filesystems
> [    6.390640] dracut: fsck -T -t noopts=_netdev -A -a
> [    6.391776] dracut: 
> [    6.391888] dracut: Remounting /dev/mapper/VolGroup-lv_root with -o ro,
> [    6.399829] device fsid fcc37d87-f052-4392-a158-d83f9de3f069 devid 1 transid 35234 /dev/mapper/VolGroup-lv_root
> [    6.718831] dracut: Mounted root filesystem /dev/mapper/VolGroup-lv_root
> [    6.922634] dracut: Switching root
> [    7.861242] type=1404 audit(1311244963.027:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
> [    8.048306] SELinux: 2048 avtab hash slots, 220453 rules.
> [    8.111966] SELinux: 2048 avtab hash slots, 220453 rules.
> [    8.268941] SELinux:  9 users, 13 roles, 3606 types, 191 bools, 1 sens, 1024 cats
> [    8.268945] SELinux:  81 classes, 220453 rules
> [    8.275051] SELinux:  Completing initialization.
> [    8.275052] SELinux:  Setting up existing superblocks.
> [    8.275059] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
> [    8.275065] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
> [    8.275083] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
> [    8.275088] SELinux: initialized (dev proc, type proc), uses genfs_contexts
> [    8.275096] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [    8.275116] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
> [    8.275727] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
> [    8.275732] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
> [    8.276956] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
> [    8.276960] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
> [    8.276964] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
> [    8.276976] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
> [    8.276985] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
> [    8.276991] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
> [    8.277014] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
> [    8.277023] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
> [    8.277028] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
> [    8.277615] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [    8.277621] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [    8.278080] SELinux: initialized (dev dm-1, type btrfs), uses xattr
> [    8.280599] type=1403 audit(1311244963.446:3): policy loaded auid=4294967295 ses=4294967295
> [    8.458942] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [    8.459305] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
> [    8.555699] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
> [    8.567032] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
> [    8.576040] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
> [    8.588047] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
> [    8.589041] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
> [    8.601022] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
> [    8.611032] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
> [    8.623055] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
> [    8.674047] systemd[1]: systemd 26 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)
> [    9.070076] NET: Registered protocol family 10
> [    9.078106] systemd[1]: Set hostname to <localhost.localdomain>.
> [   12.896134] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
> [   12.896764] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
> [   12.897222] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
> [   12.901023] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
> [   12.901585] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
> [   13.547880] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [   14.026817] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
> [   15.208199] kvm: disabled by bios
> [   15.932998] udev[403]: starting version 167
> [   16.214584] microcode: CPU0 sig=0x1067a, pf=0x10, revision=0xa07
> [   16.617851] input: PC Speaker as /devices/platform/pcspkr/input/input5
> [   17.081005] microcode: CPU1 sig=0x1067a, pf=0x10, revision=0xa07
> [   17.082579] microcode: CPU2 sig=0x1067a, pf=0x10, revision=0xa07
> [   17.083967] microcode: CPU3 sig=0x1067a, pf=0x10, revision=0xa07
> [   17.085382] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [   17.132001] microcode: CPU0 updated to revision 0xa0b, date = 2010-09-28
> [   17.137639] microcode: CPU1 updated to revision 0xa0b, date = 2010-09-28
> [   17.142000] microcode: CPU2 updated to revision 0xa0b, date = 2010-09-28
> [   17.147809] microcode: CPU3 updated to revision 0xa0b, date = 2010-09-28
> [   17.631263] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
> [   17.631265] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
> [   17.631305] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [   17.631315] e1000e 0000:00:19.0: setting latency timer to 64
> [   17.631421] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> [   17.805023] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1c:c0:93:62:ef
> [   17.805026] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
> [   17.805046] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: FFFFFF-0FF
> [   17.805084] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [   18.486772] iTCO_vendor_support: vendor-support=0
> [   19.490008] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
> [   19.490089] iTCO_wdt: Found a ICH10 TCO device (Version=2, TCOBASE=0x0460)
> [   19.490157] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [   19.857152] Adding 5144572k swap on /dev/mapper/VolGroup-lv_swap.  Priority:0 extents:1 across:5144572k 
> [   19.911087] udev[427]: renamed network interface eth0 to em1
> [   28.819107] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> [   28.819147] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
> [   28.819168] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [   29.261471] systemd-fsck[647]: /dev/sda6: clean, 60/128016 files, 224191/512000 blocks
> [   29.296271] hda_codec: ALC888: BIOS auto-probing.
> [   29.296276] ALSA sound/pci/hda/patch_realtek.c:1748 SKU: Nid=0x1d sku_cfg=0x4004c601
> [   29.296278] ALSA sound/pci/hda/patch_realtek.c:1750 SKU: port_connectivity=0x1
> [   29.296280] ALSA sound/pci/hda/patch_realtek.c:1751 SKU: enable_pcbeep=0x0
> [   29.296282] ALSA sound/pci/hda/patch_realtek.c:1752 SKU: check_sum=0x00000004
> [   29.296284] ALSA sound/pci/hda/patch_realtek.c:1753 SKU: customization=0x000000c6
> [   29.296285] ALSA sound/pci/hda/patch_realtek.c:1754 SKU: external_amp=0x0
> [   29.296287] ALSA sound/pci/hda/patch_realtek.c:1755 SKU: platform_type=0x0
> [   29.296289] ALSA sound/pci/hda/patch_realtek.c:1756 SKU: swap=0x0
> [   29.296291] ALSA sound/pci/hda/patch_realtek.c:1757 SKU: override=0x1
> [   29.296295] ALSA sound/pci/hda/hda_codec.c:4707 autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
> [   29.296297] ALSA sound/pci/hda/hda_codec.c:4711    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [   29.296300] ALSA sound/pci/hda/hda_codec.c:4715    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
> [   29.296301] ALSA sound/pci/hda/hda_codec.c:4716    mono: mono_out=0x0
> [   29.296303] ALSA sound/pci/hda/hda_codec.c:4719    dig-out=0x1e/0x0
> [   29.296305] ALSA sound/pci/hda/hda_codec.c:4720    inputs:
> [   29.296307] ALSA sound/pci/hda/hda_codec.c:4724  Rear Mic=0x18
> [   29.296309] ALSA sound/pci/hda/hda_codec.c:4724  Front Mic=0x19
> [   29.296310] ALSA sound/pci/hda/hda_codec.c:4724  Line=0x1a
> [   29.296312] ALSA sound/pci/hda/hda_codec.c:4726 
> [   29.297426] ALSA sound/pci/hda/patch_realtek.c:1805 realtek: No valid SSID, checking pincfg 0x4004c601 for NID 0x1d
> [   29.297428] ALSA sound/pci/hda/patch_realtek.c:1821 realtek: Enabling init ASM_ID=0xc601 CODEC_ID=10ec0888
> [   29.300814] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
> [   29.674447] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
> [   29.681220] SELinux: initialized (dev sda6, type ext4), uses xattr
> [   33.943024] /usr/sbin/gpm[735]: *** info [daemon/startup.c(136)]:
> [   33.943032] /usr/sbin/gpm[735]: Started gpm successfully. Entered daemon mode.
> [   34.059870] avahi-daemon[736]: Found user 'avahi' (UID 70) and group 'avahi' (GID 70).
> [   34.060148] avahi-daemon[736]: Successfully dropped root privileges.
> [   34.060376] avahi-daemon[736]: avahi-daemon 0.6.30 starting up.
> [   34.142570] NetworkManager[737]: <info> NetworkManager (version 0.8.999-2.git20110509.fc15) is starting...
> [   34.142578] NetworkManager[737]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
> [   34.161475] acpid[756]: starting up with netlink and the input layer
> [   34.161482] acpid[756]: skipping incomplete file /etc/acpi/events/videoconf
> [   34.161487] acpid[756]: 1 rule loaded
> [   34.161577] acpid[756]: waiting for events: event logging is off
> [   34.259822] smartd[755]: smartd 5.40 2010-10-16 r3189 [i386-redhat-linux-gnu] (local build)
> [   34.259831] smartd[755]: Opened configuration file /etc/smartd.conf
> [   34.259961] smartd[755]: Configuration file /etc/smartd.conf was parsed, found DEVICESCAN, scanning devices
> [   34.304369] smartd[755]: Device: /dev/sda, type changed from 'scsi' to 'sat'
> [   34.304417] smartd[755]: Device: /dev/sda [SAT], opened
> [   34.330213] smartd[755]: Device: /dev/sda [SAT], found in smartd database.
> [   34.465609] /usr/sbin/crond[752]: (CRON) INFO (running with inotify support)
> [   34.535758] smartd[755]: Device: /dev/sda [SAT], is SMART capable. Adding to "monitor" list.
> [   34.535766] smartd[755]: Monitoring 1 ATA and 0 SCSI devices
> [   35.524159] dbus[798]: avc:  netlink poll: error 4
> [   35.528147] abrtd[734]: Init complete, entering main loop
> [   35.530217] avahi-daemon[736]: Successfully called chroot().
> [   35.530225] avahi-daemon[736]: Successfully dropped remaining capabilities.
> [   35.530418] avahi-daemon[736]: Loading service file /services/ssh.service.
> [   35.530683] avahi-daemon[736]: Loading service file /services/udisks.service.
> [   35.530922] avahi-daemon[736]: System host name is set to 'localhost'. This is not a suitable mDNS host name, looking for alternatives.
> [   35.531190] avahi-daemon[736]: Network interface enumeration completed.
> [   35.531303] avahi-daemon[736]: Registering HINFO record with values 'I686'/'LINUX'.
> [   35.531417] avahi-daemon[736]: Server startup complete. Host name is linux.local. Local service cookie is 297961017.
> [   35.531476] avahi-daemon[736]: Service "linux" (/services/udisks.service) successfully established.
> [   35.531516] avahi-daemon[736]: Service "linux" (/services/ssh.service) successfully established.
> [   35.652831] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [   36.088165] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> [   36.139046] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> [   36.139235] ADDRCONF(NETDEV_UP): em1: link is not ready
> [   36.815477] CAPI 2.0 started up with major 68 (middleware)
> [   37.858878] e1000e: em1 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
> [   37.858882] e1000e 0000:00:19.0: em1: 10/100 speed: disabling TSO
> [   37.859011] ADDRCONF(NETDEV_CHANGE): em1: link becomes ready
> [   42.044648] auditd (877): /proc/877/oom_adj is deprecated, please use /proc/877/oom_score_adj instead.
> [   44.560978] RPC: Registered named UNIX socket transport module.
> [   44.560980] RPC: Registered udp transport module.
> [   44.560982] RPC: Registered tcp transport module.
> [   44.560983] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [   44.566381] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
> [   48.866007] em1: no IPv6 routers present
> [   50.889762] Bridge firewalling registered
> [   51.568832] ADDRCONF(NETDEV_UP): virbr0: link is not ready
> [   53.474567] Ebtables v2.0 registered
> [   58.196031] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
> [   58.196098] SELinux: initialized (dev proc, type proc), uses genfs_contexts
> [   58.218835] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
> [   58.218893] SELinux: initialized (dev proc, type proc), uses genfs_contexts
> [   95.828305] fuse init (API version 7.16)
> [   95.829391] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
> [   95.851066] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
> 

