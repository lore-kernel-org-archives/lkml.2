Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1FOORJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:17:09 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:53475 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab1FOORB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:17:01 -0400
Date: Wed, 15 Jun 2011 16:16:58 +0200
From: Tobias Diedrich <ranma+xen@tdiedrich.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: 3.0.0-rc2: Xen: powernow-k8: Kernel panic - not syncing:
 Attempted to kill init!
Message-ID: <20110615141658.GD23379@yumi.tdiedrich.de>
Mail-Followup-To: Tobias Diedrich <ranma+xen@tdiedrich.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	xen-users@lists.xensource.com, linux-kernel@vger.kernel.org
References: <20110613202622.GC20616@yumi.tdiedrich.de>
 <20110613215123.GA19117@dumpdata.com>
 <20110613235221.GA7417@yumi.tdiedrich.de>
 <20110614001333.GC7417@yumi.tdiedrich.de>
 <20110614013457.GB414@dumpdata.com>
 <20110614134634.GD7417@yumi.tdiedrich.de>
 <20110614175940.GA22859@dumpdata.com>
 <20110614212827.GH7417@yumi.tdiedrich.de>
 <20110615123847.GA5512@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615123847.GA5512@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Tue, Jun 14, 2011 at 11:28:27PM +0200, Tobias Diedrich wrote:
> > Konrad Rzeszutek Wilk wrote:
> > > On Tue, Jun 14, 2011 at 03:46:34PM +0200, Tobias Diedrich wrote:
> > > > [    5.740826] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
> > > > [    5.740941] powernow-k8: fid 0xa (1800 MHz), vid 0xa
> > > > [    5.741057] powernow-k8: fid 0xc (2000 MHz), vid 0x8
> > > > [    5.741170] powernow-k8: fid 0xe (2200 MHz), vid 0x8
> > > > [    5.741304] cpufreq_stats_create_table: policy->cur is 800000
> > > > [    5.741475] last_index set to -1 in cpufreq_stats_create_table!
> > > > 
> > > > I think policy->cur used here probably set in powernowk8_cpu_init.
> > > 
> > > Yup, and there is not much that can be done there. Lets try this patch
> > 
> > Thanks, this works fine for suppressing the crash.
> 
> OK, can you do one more test? Can you reboot the kernel without Xen
> and see whether the baremetal kernel still works? Wouldn't want to
> cause a regression.

Just tested it, no error messages from powernow-k8/cpufreq in dmesg,
ondemand switching seems to work when running powertop in one shell and
"while true; do :; done" in another.

cpufrequtils 007: cpufreq-info (C) Dominik Brodowski 2004-2009
Report errors and bugs to cpufreq@vger.kernel.org, please.
analyzing CPU 0:
  driver: powernow-k8
  CPUs which run at the same hardware frequency: 0
  CPUs which need to have their frequency coordinated by software: 0
  maximum transition latency: 1.24 ms.
  hardware limits: 1000 MHz - 2.20 GHz
  available frequency steps: 1000 MHz, 1.80 GHz, 2.00 GHz, 2.20 GHz
  available cpufreq governors: ondemand, performance
  current policy: frequency should be within 1000 MHz and 2.20 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 1000 MHz (asserted by call to hardware).
  cpufreq stats: 1000 MHz:96.68%, 1.80 GHz:0.00%, 2.00 GHz:0.00%, 2.20 GHz:3.32%  (3)

> Is it OK if I stick Reported-by/Tested-by: Tobias .. on the patches
> for upstream submission?

Sure, no problem.

dmesg from boot:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0-rc2 (ranma@nukunuku) (gcc version 4.5.2 (Debian 4.5.2-11) ) #56 SMP Tue Jun 14 23:22:08 CEST 2011
[    0.000000] Command line: root=/dev/md2 vga=ext netconsole=25360@85.10.200.103/eth0,514@217.160.215.119/00:26:88:75:cf:27 ro
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fef0000 (usable)
[    0.000000]  BIOS-e820: 000000007fef0000 - 000000007fef3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fef3000 - 000000007ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.3 present.
[    0.000000] DMI: MICRO-STAR INTERNATIONAL CO., LTD MS-7094/MS-7094, BIOS V3.6 10/12/2006
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] AGP bridge at 00:00:00
[    0.000000] Aperture from AGP @ f0000000 old size 32 MB
[    0.000000] Aperture from AGP @ f0000000 size 128 MB (APSIZE f20)
[    0.000000] last_pfn = 0x7fef0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 007FF00000 mask FFFFF00000 uncachable
[    0.000000]   2 base 00F0000000 mask FFF8000000 write-combining
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009d000] 9d000 size 8192
[    0.000000] init_memory_mapping: 0000000000000000-000000007fef0000
[    0.000000]  0000000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007fef0000 page 4k
[    0.000000] kernel direct mapping tables up to 7fef0000 @ 7feec000-7fef0000
[    0.000000] ACPI: RSDP 00000000000f8dc0 00014 (v00 VIAK8T)
[    0.000000] ACPI: RSDT 000000007fef3040 00030 (v01 VIAK8T AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 000000007fef30c0 00074 (v01 VIAK8T AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 000000007fef3180 04F07 (v01 VIAK8T AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS 000000007fef0000 00040
[    0.000000] ACPI: SRAT 000000007fef8300 00090 (v01 AMD    HAMMER   00000001 AMD  00000001)
[    0.000000] ACPI: APIC 000000007fef8100 00068 (v01 VIAK8T AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff88007d600000-ffff88007f1fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007fef0
[    0.000000] On node 0 totalpages: 523903
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2 pages reserved
[    0.000000]   DMA zone: 3925 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7109 pages used for memmap
[    0.000000]   DMA32 zone: 512811 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 1 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] Allocating PCI resources starting at 7ff00000 (gap: 7ff00000:7ed00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88007fc00000 s79488 r8192 d22912 u1048576
[    0.000000] pcpu-alloc: s79488 r8192 d22912 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 516736
[    0.000000] Kernel command line: root=/dev/md2 vga=ext netconsole=25360@85.10.200.103/eth0,514@217.160.215.119/00:26:88:75:cf:27 ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Checking aperture...
[    0.000000] AGP bridge at 00:00:00
[    0.000000] Aperture from AGP @ f0000000 old size 32 MB
[    0.000000] Aperture from AGP @ f0000000 size 128 MB (APSIZE f20)
[    0.000000] Node 0: aperture @ f0000000 size 128 MB
[    0.000000] Memory: 2050316k/2096064k available (6122k kernel code, 452k absent, 45296k reserved, 4761k data, 576k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Console: colour VGA+ 80x50
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2199.474 MHz processor.
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.020098] Calibrating delay loop (skipped), value calculated using timer frequency.. 4398.94 BogoMIPS (lpj=21994740)
[    0.020281] pid_max: default: 32768 minimum: 301
[    0.020444] Mount-cache hash table entries: 256
[    0.020700] Initializing cgroup subsys cpuacct
[    0.020797] Initializing cgroup subsys memory
[    0.020899] Initializing cgroup subsys net_cls
[    0.020990] Initializing cgroup subsys blkio
[    0.021107] tseg: 007ff00000
[    0.021109] mce: CPU supports 5 MCE banks
[    0.021238] SMP alternatives: switching to UP code
[    0.036043] ACPI: Core revision 20110413
[    0.039847] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.139943] CPU0: AMD Athlon(tm) 64 Processor 3700+ stepping 02
[    0.150000] Performance Events: AMD PMU driver.
[    0.150000] ... version:                0
[    0.150000] ... bit width:              48
[    0.150000] ... generic registers:      4
[    0.150000] ... value mask:             0000ffffffffffff
[    0.150000] ... max period:             00007fffffffffff
[    0.150000] ... fixed-purpose events:   0
[    0.150000] ... event mask:             000000000000000f
[    0.150000] NMI watchdog enabled, takes one hw-pmu counter.
[    0.150000] Brought up 1 CPUs
[    0.150000] Total of 1 processors activated (4398.94 BogoMIPS).
[    0.150000] devtmpfs: initialized
[    0.150000] xor: automatically using best checksumming function: generic_sse
[    0.190002]    generic_sse:  7038.400 MB/sec
[    0.190092] xor: using function: generic_sse (7038.400 MB/sec)
[    0.190223] NET: Registered protocol family 16
[    0.190580] node 0 link 0: io port [1000, fffff]
[    0.190583] TOM: 0000000080000000 aka 2048M
[    0.190675] node 0 link 0: mmio [a0000, bffff]
[    0.190678] node 0 link 0: mmio [80000000, ff70ffff]
[    0.190681] bus: [00, ff] on node 0 link 0
[    0.190684] bus: 00 index 0 [io  0x0000-0xffff]
[    0.190687] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.190689] bus: 00 index 2 [mem 0x80000000-0xfcffffffff]
[    0.190699] ACPI: bus type pci registered
[    0.190872] PCI: Using configuration type 1 for base access
[    0.197527] bio: create slab <bio-0> at 0
[    0.360017] raid6: int64x1   2045 MB/s
[    0.530007] raid6: int64x2   2394 MB/s
[    0.700020] raid6: int64x4   1697 MB/s
[    0.870043] raid6: int64x8   1237 MB/s
[    1.040009] raid6: sse2x1    2668 MB/s
[    1.210004] raid6: sse2x2    3525 MB/s
[    1.380007] raid6: sse2x4    3950 MB/s
[    1.380096] raid6: using algorithm sse2x4 (3950 MB/s)
[    1.380732] ACPI: EC: Look up EC in DSDT
[    1.384063] ACPI: Interpreter enabled
[    1.384156] ACPI: (supports S0 S5)
[    1.384272] ACPI: Using IOAPIC for interrupt routing
[    1.389348] ACPI: No dock devices found.
[    1.389442] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    1.389668] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.389891] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.389895] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    1.389898] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.389901] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    1.389904] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xfebfffff] (ignored)
[    1.389924] pci 0000:00:00.0: [1106:0282] type 0 class 0x000600
[    1.389933] pci 0000:00:00.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
[    1.390013] pci 0000:00:00.1: [1106:1282] type 0 class 0x000600
[    1.390051] pci 0000:00:00.2: [1106:2282] type 0 class 0x000600
[    1.390087] pci 0000:00:00.3: [1106:3282] type 0 class 0x000600
[    1.390124] pci 0000:00:00.4: [1106:4282] type 0 class 0x000600
[    1.390162] pci 0000:00:00.7: [1106:7282] type 0 class 0x000600
[    1.390201] pci 0000:00:01.0: [1106:b188] type 1 class 0x000604
[    1.390236] pci 0000:00:01.0: supports D1
[    1.390260] pci 0000:00:09.0: [10ec:8139] type 0 class 0x000200
[    1.390275] pci 0000:00:09.0: reg 10: [io  0xe000-0xe0ff]
[    1.390284] pci 0000:00:09.0: reg 14: [mem 0xfc122000-0xfc1220ff]
[    1.390317] pci 0000:00:09.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    1.390334] pci 0000:00:09.0: supports D1 D2
[    1.390336] pci 0000:00:09.0: PME# supported from D1 D2 D3hot
[    1.390341] pci 0000:00:09.0: PME# disabled
[    1.390364] pci 0000:00:0f.0: [1106:3149] type 0 class 0x000104
[    1.390379] pci 0000:00:0f.0: reg 10: [io  0xe200-0xe207]
[    1.390388] pci 0000:00:0f.0: reg 14: [io  0xe300-0xe303]
[    1.390397] pci 0000:00:0f.0: reg 18: [io  0xe400-0xe407]
[    1.390405] pci 0000:00:0f.0: reg 1c: [io  0xe500-0xe503]
[    1.390414] pci 0000:00:0f.0: reg 20: [io  0xe600-0xe60f]
[    1.390423] pci 0000:00:0f.0: reg 24: [io  0xe700-0xe7ff]
[    1.390462] pci 0000:00:0f.1: [1106:0571] type 0 class 0x000101
[    1.390502] pci 0000:00:0f.1: reg 20: [io  0xe800-0xe80f]
[    1.390554] pci 0000:00:10.0: [1106:3038] type 0 class 0x000c03
[    1.390591] pci 0000:00:10.0: reg 20: [io  0xe900-0xe91f]
[    1.390620] pci 0000:00:10.0: supports D1 D2
[    1.390622] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.390627] pci 0000:00:10.0: PME# disabled
[    1.390644] pci 0000:00:10.1: [1106:3038] type 0 class 0x000c03
[    1.390682] pci 0000:00:10.1: reg 20: [io  0xea00-0xea1f]
[    1.390710] pci 0000:00:10.1: supports D1 D2
[    1.390712] pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.390716] pci 0000:00:10.1: PME# disabled
[    1.390734] pci 0000:00:10.2: [1106:3038] type 0 class 0x000c03
[    1.390771] pci 0000:00:10.2: reg 20: [io  0xeb00-0xeb1f]
[    1.390800] pci 0000:00:10.2: supports D1 D2
[    1.390802] pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
[    1.390806] pci 0000:00:10.2: PME# disabled
[    1.390824] pci 0000:00:10.3: [1106:3038] type 0 class 0x000c03
[    1.390861] pci 0000:00:10.3: reg 20: [io  0xec00-0xec1f]
[    1.390889] pci 0000:00:10.3: supports D1 D2
[    1.390892] pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
[    1.390896] pci 0000:00:10.3: PME# disabled
[    1.390913] pci 0000:00:10.4: [1106:3104] type 0 class 0x000c03
[    1.390928] pci 0000:00:10.4: reg 10: [mem 0xfc121000-0xfc1210ff]
[    1.390980] pci 0000:00:10.4: supports D1 D2
[    1.390982] pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
[    1.390986] pci 0000:00:10.4: PME# disabled
[    1.391007] pci 0000:00:11.0: [1106:3227] type 0 class 0x000601
[    1.391058] HPET not enabled in BIOS. You might try hpet=force boot option
[    1.391189] pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
[    1.391208] pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
[    1.391224] pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
[    1.391240] pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
[    1.391260] PCI: peer root bus 00 res updated from pci conf
[    1.391295] pci 0000:01:00.0: [1002:5046] type 0 class 0x000300
[    1.391309] pci 0000:01:00.0: reg 10: [mem 0xf8000000-0xfbffffff pref]
[    1.391316] pci 0000:01:00.0: reg 14: [io  0xd000-0xd0ff]
[    1.391323] pci 0000:01:00.0: reg 18: [mem 0xfc020000-0xfc023fff]
[    1.391344] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.391362] pci 0000:01:00.0: supports D1
[    1.391386] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.391480] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    1.391484] pci 0000:00:01.0:   bridge window [mem 0xfc000000-0xfc0fffff]
[    1.391489] pci 0000:00:01.0:   bridge window [mem 0xf8000000-0xfbffffff pref]
[    1.391496] pci_bus 0000:00: on NUMA node 0
[    1.391499] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.391734]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
[    1.414614] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12)
[    1.414854] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11 12)
[    1.415096] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 *12)
[    1.415323] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12) *0, disabled.
[    1.415638] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12) *0, disabled.
[    1.415951] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12) *0, disabled.
[    1.416262] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 6 7 10 11 12) *0, disabled.
[    1.416573] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 6 7 10 11 12) *0, disabled.
[    1.416910] ACPI: PCI Interrupt Link [ALKA] (IRQs *20)
[    1.417096] ACPI: PCI Interrupt Link [ALKB] (IRQs *21)
[    1.417281] ACPI: PCI Interrupt Link [ALKC] (IRQs *22), disabled.
[    1.417498] ACPI: PCI Interrupt Link [ALKD] (IRQs *23), disabled.
[    1.417859] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.418028] vgaarb: loaded
[    1.418116] vgaarb: bridge control possible 0000:01:00.0
[    1.418366] SCSI subsystem initialized
[    1.418569] libata version 3.00 loaded.
[    1.418650] usbcore: registered new interface driver usbfs
[    1.418804] usbcore: registered new interface driver hub
[    1.418937] usbcore: registered new device driver usb
[    1.419236] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    1.419329] PCI: Using ACPI for IRQ routing
[    1.419420] PCI: pci_cache_line_size set to 64 bytes
[    1.419429] pci 0000:00:00.0: address space collision: [mem 0xf0000000-0xf7ffffff pref] conflicts with GART [mem 0xf0000000-0xf7ffffff]
[    1.419661] reserve RAM buffer: 000000000009f000 - 000000000009ffff 
[    1.419664] reserve RAM buffer: 000000007fef0000 - 000000007fffffff 
[    1.423817] pnp: PnP ACPI init
[    1.423926] ACPI: bus type pnp registered
[    1.424205] pnp 00:00: [mem 0x000d1c00-0x000d3fff]
[    1.424208] pnp 00:00: [mem 0x000f0000-0x000f7fff]
[    1.424211] pnp 00:00: [mem 0x000f8000-0x000fbfff]
[    1.424214] pnp 00:00: [mem 0x000fc000-0x000fffff]
[    1.424216] pnp 00:00: [mem 0x7ff00000-0x7fffffff]
[    1.424219] pnp 00:00: [mem 0x7fef0000-0x7fefffff]
[    1.424221] pnp 00:00: [mem 0xffff0000-0xffffffff]
[    1.424224] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    1.424226] pnp 00:00: [mem 0x00100000-0x7feeffff]
[    1.424229] pnp 00:00: [mem 0xfec00000-0xfec00fff]
[    1.424231] pnp 00:00: [mem 0xfee00000-0xfee00fff]
[    1.424234] pnp 00:00: [mem 0xfff80000-0xfffeffff]
[    1.424242] pnp 00:00: disabling [mem 0x000d1c00-0x000d3fff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x07ffffff pref]
[    1.424419] pnp 00:00: disabling [mem 0x000f0000-0x000f7fff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x07ffffff pref]
[    1.424595] pnp 00:00: disabling [mem 0x000f8000-0x000fbfff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x07ffffff pref]
[    1.424772] pnp 00:00: disabling [mem 0x000fc000-0x000fffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x07ffffff pref]
[    1.424949] pnp 00:00: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x07ffffff pref]
[    1.425124] pnp 00:00: disabling [mem 0x00100000-0x7feeffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x07ffffff pref]
[    1.425385] system 00:00: [mem 0x7ff00000-0x7fffffff] could not be reserved
[    1.425480] system 00:00: [mem 0x7fef0000-0x7fefffff] could not be reserved
[    1.425574] system 00:00: [mem 0xffff0000-0xffffffff] has been reserved
[    1.425669] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.425764] system 00:00: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.425859] system 00:00: [mem 0xfff80000-0xfffeffff] has been reserved
[    1.425954] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.426012] pnp 00:01: [bus 00-ff]
[    1.426015] pnp 00:01: [io  0x0cf8-0x0cff]
[    1.426018] pnp 00:01: [io  0x0000-0x0cf7 window]
[    1.426021] pnp 00:01: [io  0x0d00-0xffff window]
[    1.426023] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    1.426026] pnp 00:01: [mem 0x000c0000-0x000dffff window]
[    1.426030] pnp 00:01: [mem 0x80000000-0xfebfffff window]
[    1.426102] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.426124] pnp 00:02: [io  0x4000-0x407f]
[    1.426126] pnp 00:02: [io  0x5000-0x500f]
[    1.426188] system 00:02: [io  0x4000-0x407f] has been reserved
[    1.426283] system 00:02: [io  0x5000-0x500f] has been reserved
[    1.426377] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.426946] pnp 00:03: [io  0x0010-0x001f]
[    1.426948] pnp 00:03: [io  0x0022-0x003f]
[    1.426951] pnp 00:03: [io  0x0044-0x005f]
[    1.426953] pnp 00:03: [io  0x0062-0x0063]
[    1.426956] pnp 00:03: [io  0x0065-0x006f]
[    1.426958] pnp 00:03: [io  0x0074-0x007f]
[    1.426960] pnp 00:03: [io  0x0091-0x0093]
[    1.426963] pnp 00:03: [io  0x00a2-0x00bf]
[    1.426965] pnp 00:03: [io  0x00e0-0x00ef]
[    1.426968] pnp 00:03: [io  0x0b78-0x0b7b]
[    1.426970] pnp 00:03: [io  0x0f78-0x0f7b]
[    1.426973] pnp 00:03: [io  0x0a78-0x0a7b]
[    1.426975] pnp 00:03: [io  0x0e78-0x0e7b]
[    1.426977] pnp 00:03: [io  0x0bbc-0x0bbf]
[    1.426980] pnp 00:03: [io  0x0fbc-0x0fbf]
[    1.426982] pnp 00:03: [io  0x04d0-0x04d1]
[    1.426985] pnp 00:03: [io  0x0290-0x0297]
[    1.427066] system 00:03: [io  0x0b78-0x0b7b] has been reserved
[    1.427159] system 00:03: [io  0x0f78-0x0f7b] has been reserved
[    1.427252] system 00:03: [io  0x0a78-0x0a7b] has been reserved
[    1.427345] system 00:03: [io  0x0e78-0x0e7b] has been reserved
[    1.427439] system 00:03: [io  0x0bbc-0x0bbf] has been reserved
[    1.427531] system 00:03: [io  0x0fbc-0x0fbf] has been reserved
[    1.427625] system 00:03: [io  0x04d0-0x04d1] has been reserved
[    1.427718] system 00:03: [io  0x0290-0x0297] has been reserved
[    1.427811] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.427824] pnp 00:04: [dma 4]
[    1.427827] pnp 00:04: [io  0x0000-0x000f]
[    1.427830] pnp 00:04: [io  0x0080-0x0090]
[    1.427832] pnp 00:04: [io  0x0094-0x009f]
[    1.427835] pnp 00:04: [io  0x00c0-0x00df]
[    1.427890] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.427902] pnp 00:05: [io  0x0070-0x0073]
[    1.427913] pnp 00:05: [irq 8]
[    1.427969] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.427979] pnp 00:06: [io  0x0061]
[    1.428034] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.428045] pnp 00:07: [io  0x00f0-0x00ff]
[    1.428051] pnp 00:07: [irq 13]
[    1.428107] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.428213] pnp 00:08: [io  0x03f0-0x03f5]
[    1.428216] pnp 00:08: [io  0x03f7]
[    1.428221] pnp 00:08: [irq 6]
[    1.428223] pnp 00:08: [dma 2]
[    1.428295] pnp 00:08: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.428456] pnp 00:09: [io  0x03f8-0x03ff]
[    1.428462] pnp 00:09: [irq 4]
[    1.428551] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.428726] pnp 00:0a: [io  0x02f8-0x02ff]
[    1.428732] pnp 00:0a: [irq 3]
[    1.428814] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.429102] pnp 00:0b: [io  0x0378-0x037f]
[    1.429105] pnp 00:0b: [io  0x0778-0x077b]
[    1.429111] pnp 00:0b: [irq 7]
[    1.429195] pnp 00:0b: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.429281] pnp 00:0c: [io  0x0060]
[    1.429284] pnp 00:0c: [io  0x0064]
[    1.429289] pnp 00:0c: [irq 1]
[    1.429348] pnp 00:0c: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    1.429371] pnp: PnP ACPI: found 13 devices
[    1.429461] ACPI: ACPI bus type pnp unregistered
[    1.437664] Switching to clocksource acpi_pm
[    1.440031] PCI: max bus depth: 1 pci_try_num: 2
[    1.440052] pci 0000:00:09.0: BAR 6: assigned [mem 0x80000000-0x8000ffff pref]
[    1.440223] pci 0000:01:00.0: BAR 6: assigned [mem 0xfc000000-0xfc01ffff pref]
[    1.440392] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.440485] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    1.440580] pci 0000:00:01.0:   bridge window [mem 0xfc000000-0xfc0fffff]
[    1.440676] pci 0000:00:01.0:   bridge window [mem 0xf8000000-0xfbffffff pref]
[    1.440854] pci 0000:00:01.0: setting latency timer to 64
[    1.440858] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    1.440861] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
[    1.440864] pci_bus 0000:00: resource 6 [mem 0x80000000-0xfcffffffff]
[    1.440868] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    1.440870] pci_bus 0000:01: resource 1 [mem 0xfc000000-0xfc0fffff]
[    1.440873] pci_bus 0000:01: resource 2 [mem 0xf8000000-0xfbffffff pref]
[    1.440923] NET: Registered protocol family 2
[    1.441073] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    1.441670] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.444164] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.444886] TCP: Hash tables configured (established 262144 bind 65536)
[    1.444978] TCP reno registered
[    1.445068] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    1.445183] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    1.445427] NET: Registered protocol family 1
[    1.445626] RPC: Registered named UNIX socket transport module.
[    1.445719] RPC: Registered udp transport module.
[    1.445808] RPC: Registered tcp transport module.
[    1.445898] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.446012] pci 0000:00:01.0: disabling DAC on VIA PCI bridge
[    1.446197] pci 0000:01:00.0: Boot video device
[    1.446200] PCI: CLS 32 bytes, default 64
[    1.446291] has_svm: svm not available
[    1.446380] kvm: no hardware support
[    1.454164] Switched to NOHz mode on CPU #0
[    1.454332] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.468080] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.468281] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.468458] NTFS driver 2.1.30 [Flags: R/W].
[    1.468674] fuse init (API version 7.16)
[    1.468834] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    1.469169] msgmni has been set to 4004
[    1.469448] io scheduler noop registered
[    1.469537] io scheduler deadline registered
[    1.469637] io scheduler cfq registered (default)
[    1.470076] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.470247] ACPI: Power Button [PWRB]
[    1.470434] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.470603] ACPI: Power Button [PWRF]
[    1.470886] ACPI: acpi_idle registered with cpuidle
[    1.472455] XENFS: not registering filesystem on non-xen platform
[    1.472630] Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
[    1.493211] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.513970] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.514199] serial 00:0a: disabled
[    1.515538] loop: module loaded
[    1.515981] sata_via 0000:00:0f.0: version 2.6
[    1.516109] ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
[    1.516208] sata_via 0000:00:0f.0: PCI INT B -> Link[ALKA] -> GSI 20 (level, low) -> IRQ 20
[    1.516415] sata_via 0000:00:0f.0: routed to hard irq line 11
[    1.516868] scsi0 : sata_via
[    1.517075] scsi1 : sata_via
[    1.517250] ata1: SATA max UDMA/133 cmd 0xe200 ctl 0xe300 bmdma 0xe600 irq 20
[    1.517345] ata2: SATA max UDMA/133 cmd 0xe400 ctl 0xe500 bmdma 0xe608 irq 20
[    1.517645] pata_via 0000:00:0f.1: version 0.3.4
[    1.517654] pata_via 0000:00:0f.1: PCI INT A -> Link[ALKA] -> GSI 20 (level, low) -> IRQ 20
[    1.518341] scsi2 : pata_via
[    1.518530] scsi3 : pata_via
[    1.519548] ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xe800 irq 14
[    1.519643] ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xe808 irq 15
[    1.519907] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.520027] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.520162] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    1.520253] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    1.520394] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.520488] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.520623] PPP generic driver version 2.4.2
[    1.520814] PPP Deflate Compression module registered
[    1.520906] PPP BSD Compression module registered
[    1.520996] NET: Registered protocol family 24
[    1.521563] 8139cp: 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[    1.521659] 8139cp 0000:00:09.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip, use 8139too
[    1.521872] 8139too: 8139too Fast Ethernet driver 0.9.28
[    1.521979] 8139too 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.522449] 8139too 0000:00:09.0: eth0: RealTek RTL8139 at 0xffffc9000000c000, 00:e0:4c:4c:17:fb, IRQ 17
[    1.522659] tun: Universal TUN/TAP device driver, 1.6
[    1.522750] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.522969] usbcore: registered new interface driver cdc_ether
[    1.523094] usbcore: registered new interface driver cdc_subset
[    1.523220] usbcore: registered new interface driver zaurus
[    1.523315] cdc_ncm: 01-June-2011
[    1.523437] usbcore: registered new interface driver cdc_ncm
[    1.523643] netconsole: local port 25360
[    1.523734] netconsole: local IP 85.10.200.103
[    1.523824] netconsole: interface 'eth0'
[    1.523912] netconsole: remote port 514
[    1.524001] netconsole: remote IP 217.160.215.119
[    1.524091] netconsole: remote ethernet address 00:26:88:75:cf:27
[    1.524183] netconsole: device eth0 not up yet, forcing it
[    1.524357] 8139too 0000:00:09.0: eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[    1.524900] netconsole: carrier detect appears untrustworthy, waiting 4 seconds
[    1.720013] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.920301] ata1.00: ATA-8: SAMSUNG HD321KJ, CP100-10, max UDMA7
[    1.920395] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.940316] ata1.00: configured for UDMA/133
[    1.940537] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD321KJ  CP10 PQ: 0 ANSI: 5
[    1.940944] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.941153] sd 0:0:0:0: [sda] Write Protect is off
[    1.941245] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.941265] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.941796] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.959570]  sda: sda1 sda2 sda3 sda4 < sda5 >
[    1.960079] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.150028] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.330305] ata2.00: ATA-8: SAMSUNG HD321KJ, CP100-10, max UDMA7
[    2.330398] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.350297] ata2.00: configured for UDMA/133
[    2.350493] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD321KJ  CP10 PQ: 0 ANSI: 5
[    2.350905] sd 1:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    2.351115] sd 1:0:0:0: [sdb] Write Protect is off
[    2.351206] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.351225] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.351748] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.384353]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 >
[    2.384857] sd 1:0:0:0: [sdb] Attached SCSI disk
[    5.538802] console [netcon0] enabled
[    5.538897] netconsole: network logging started
[    5.539091] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.539353] ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
[    5.539455] ehci_hcd 0000:00:10.4: PCI INT C -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
[    5.539649] ehci_hcd 0000:00:10.4: EHCI Host Controller
[    5.539804] ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
[    5.540057] ehci_hcd 0000:00:10.4: irq 21, io mem 0xfc121000
[    5.560011] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
[    5.560257] hub 1-0:1.0: USB hub found
[    5.560352] hub 1-0:1.0: 8 ports detected
[    5.560592] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.560724] uhci_hcd: USB Universal Host Controller Interface driver
[    5.560847] uhci_hcd 0000:00:10.0: PCI INT A -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
[    5.561024] uhci_hcd 0000:00:10.0: UHCI Host Controller
[    5.561178] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
[    5.561371] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000e900
[    5.561629] hub 2-0:1.0: USB hub found
[    5.561728] hub 2-0:1.0: 2 ports detected
[    5.561922] uhci_hcd 0000:00:10.1: PCI INT A -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
[    5.562098] uhci_hcd 0000:00:10.1: UHCI Host Controller
[    5.562254] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
[    5.566893] uhci_hcd 0000:00:10.1: irq 21, io base 0x0000ea00
[    5.567148] hub 3-0:1.0: USB hub found
[    5.567242] hub 3-0:1.0: 2 ports detected
[    5.567435] uhci_hcd 0000:00:10.2: PCI INT B -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
[    5.567612] uhci_hcd 0000:00:10.2: UHCI Host Controller
[    5.567765] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
[    5.567958] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000eb00
[    5.568216] hub 4-0:1.0: USB hub found
[    5.568311] hub 4-0:1.0: 2 ports detected
[    5.568505] uhci_hcd 0000:00:10.3: PCI INT B -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
[    5.568683] uhci_hcd 0000:00:10.3: UHCI Host Controller
[    5.568837] uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
[    5.569029] uhci_hcd 0000:00:10.3: irq 21, io base 0x0000ec00
[    5.569284] hub 5-0:1.0: USB hub found
[    5.569379] hub 5-0:1.0: 2 ports detected
[    5.569646] usbcore: registered new interface driver cdc_acm
[    5.569740] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    5.569954] usbcore: registered new interface driver usblp
[    5.570158] usbcore: registered new interface driver usbserial
[    5.570287] USB Serial support registered for generic
[    5.570417] usbcore: registered new interface driver usbserial_generic
[    5.570512] usbserial: USB Serial Driver core
[    5.570639] USB Serial support registered for pl2303
[    5.570773] usbcore: registered new interface driver pl2303
[    5.570866] pl2303: Prolific PL2303 USB to serial adaptor driver
[    5.571053] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    5.571148] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    5.571535] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.571809] mousedev: PS/2 mouse device common for all mice
[    5.572060] rtc_cmos 00:05: RTC can wake from S4
[    5.572335] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    5.572482] rtc0: alarms up to one year, y3k, 242 bytes nvram
[    5.572608] i2c /dev entries driver
[    5.572916] md: raid1 personality registered for level 1
[    5.573011] md: raid6 personality registered for level 6
[    5.573108] md: raid5 personality registered for level 5
[    5.573205] md: raid4 personality registered for level 4
[    5.573403] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    5.573619] cpuidle: using governor ladder
[    5.573710] cpuidle: using governor menu
[    5.574774] usbcore: registered new interface driver usbhid
[    5.574868] usbhid: USB HID core driver
[    5.575084] ALSA device list:
[    5.575174]   No soundcards found.
[    5.575459] u32 classifier
[    5.575548]     Actions configured
[    5.575643] Netfilter messages via NETLINK v0.30.
[    5.575760] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.575998] ctnetlink v0.93: registering with nfnetlink.
[    5.576131] IPv4 over IPv4 tunneling driver
[    5.576510] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.576654] TCP bic registered
[    5.576745] TCP cubic registered
[    5.576839] TCP westwood registered
[    5.576933] TCP hybla registered
[    5.577026] TCP vegas registered
[    5.577158] NET: Registered protocol family 10
[    5.577623] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    5.577753] IPv6 over IPv4 tunneling driver
[    5.578229] NET: Registered protocol family 17
[    5.578353] 802.1Q VLAN Support v1.8
[    5.578448] Registering the dns_resolver key type
[    5.585932] rtc_cmos 00:05: setting system clock to 2011-06-15 14:08:58 UTC (1308146938)
[    5.586112] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3700+ (1 cpu cores) (version 2.20.00)
[    5.593635] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
[    5.593729] powernow-k8: fid 0xa (1800 MHz), vid 0xa
[    5.593825] powernow-k8: fid 0xc (2000 MHz), vid 0x8
[    5.593921] powernow-k8: fid 0xe (2200 MHz), vid 0x8
[    5.594523] md: Waiting for all devices to be available before autodetect
[    5.594620] md: If you don't use raid, use raid=noautodetect
[    5.594905] md: Autodetecting RAID arrays.
[    5.680033] md: Scanned 8 and added 8 devices.
[    5.680126] md: autorun ...
[    5.680219] md: considering sdb5 ...
[    5.680319] md:  adding sdb5 ...
[    5.680417] md: sdb3 has different UUID to sdb5
[    5.680514] md: sdb2 has different UUID to sdb5
[    5.680613] md: sdb1 has different UUID to sdb5
[    5.680713] md:  adding sda5 ...
[    5.680810] md: sda3 has different UUID to sdb5
[    5.680908] md: sda2 has different UUID to sdb5
[    5.681005] md: sda1 has different UUID to sdb5
[    5.681241] md: created md3
[    5.681332] md: bind<sda5>
[    5.681436] md: bind<sdb5>
[    5.681531] md: running: <sdb5><sda5>
[    5.681732] bio: create slab <bio-1> at 1
[    5.681904] md/raid1:md3: active with 2 out of 2 mirrors
[    5.682018] md3: detected capacity change from 0 to 309644754944
[    5.682152] md: considering sdb3 ...
[    5.682250] md:  adding sdb3 ...
[    5.682346] md: sdb2 has different UUID to sdb3
[    5.682444] md: sdb1 has different UUID to sdb3
[    5.682543] md:  adding sda3 ...
[    5.682640] md: sda2 has different UUID to sdb3
[    5.682737] md: sda1 has different UUID to sdb3
[    5.682976] md: created md2
[    5.683067] md: bind<sda3>
[    5.683169] md: bind<sdb3>
[    5.683264] md: running: <sdb3><sda3>
[    5.683512] md/raid1:md2: active with 2 out of 2 mirrors
[    5.683625] md2: detected capacity change from 0 to 7999520768
[    5.683753] md: considering sdb2 ...
[    5.683848] md:  adding sdb2 ...
[    5.683944] md: sdb1 has different UUID to sdb2
[    5.684043] md:  adding sda2 ...
[    5.684139] md: sda1 has different UUID to sdb2
[    5.684387] md: created md1
[    5.684477] md: bind<sda2>
[    5.684577] md: bind<sdb2>
[    5.684679] md: running: <sdb2><sda2>
[    5.684926] md/raid1:md1: active with 2 out of 2 mirrors
[    5.685037] md1: detected capacity change from 0 to 271319040
[    5.685163] md: considering sdb1 ...
[    5.685259] md:  adding sdb1 ...
[    5.685356] md:  adding sda1 ...
[    5.685449] md: created md0
[    5.685543] md: bind<sda1>
[    5.685647] md: bind<sdb1>
[    5.685742] md: running: <sdb1><sda1>
[    5.685995] md/raid1:md0: active with 2 out of 2 mirrors
[    5.686106] md0: detected capacity change from 0 to 2152923136
[    5.686234] md: ... autorun DONE.
[    5.706860]  md2: unknown partition table
[    5.714363] EXT3-fs: barriers not enabled
[    5.717892] kjournald starting.  Commit interval 5 seconds
[    5.718005] EXT3-fs (md2): mounted filesystem with writeback data mode
[    5.718106] VFS: Mounted root (ext3 filesystem) readonly on device 9:2.
[    5.731373] devtmpfs: mounted
[    5.732699] Freeing unused kernel memory: 576k freed
[    5.733108] Write protecting the kernel read-only data: 10240k
[    5.733351] Freeing unused kernel memory: 4k freed
[    5.737110] Freeing unused kernel memory: 964k freed
[    6.013474] /etc/rcS.d/S01mountkernfs.sh start
[    6.146645] splash_progress 2
[    6.146890] /etc/rcS.d/S02udev start
[    6.244999] udev[809]: starting version 164
[    6.597032]  md3: unknown partition table
[    6.605496]  md1: unknown partition table
[    6.619599]  md0: unknown partition table
[    6.966614] splash_progress 4
[    6.966881] /etc/rcS.d/S03mdadm-raid start
[    6.972053] splash_progress 6
[    6.972184] /etc/rcS.d/S03mountdevsubfs.sh start
[    6.980321] splash_progress 8
[    6.980570] /etc/rcS.d/S04bootlogd start
[    7.017156] splash_progress 11
[    7.017404] /etc/rcS.d/S05keyboard-setup start
[    7.187111] splash_progress 13
[    7.187413] /etc/rcS.d/S06hostname.sh start
[    7.201400] splash_progress 15
[    7.201533] /etc/rcS.d/S06hwclockfirst.sh start
[    7.203281] splash_progress 17
[    7.203406] /etc/rcS.d/S06lvm2 start
[    7.470792] splash_progress 19
[    7.471056] /etc/rcS.d/S07checkroot.sh start
[    7.493962] Adding 2102460k swap on /dev/md0.  Priority:-1 extents:1 across:2102460k 
[    7.511448] EXT3-fs (md2): using internal journal
[    7.549361] splash_progress 22
[    7.549695] /etc/rcS.d/S08hwclock.sh start
[    7.551686] splash_progress 24
[    7.551813] /etc/rcS.d/S08ifupdown-clean start
[    7.567623] splash_progress 26
[    7.567758] /etc/rcS.d/S08module-init-tools start
[    7.572863] splash_progress 28
[    7.572994] /etc/rcS.d/S08mtab.sh start
[    7.635720] splash_progress 30
[    7.635998] /etc/rcS.d/S09checkfs.sh start
[    7.701409] splash_progress 33
[    7.701682] /etc/rcS.d/S10ifupdown start
[    7.708168] splash_progress 35
[    7.708301] /etc/rcS.d/S10mountall.sh start
[    7.827223] EXT3-fs: barriers not enabled
[    7.837995] kjournald starting.  Commit interval 5 seconds
[    7.838100] EXT3-fs (md1): warning: maximal mount count reached, running e2fsck is recommended
[    7.859805] EXT3-fs (md1): using internal journal
[    7.859901] EXT3-fs (md1): mounted filesystem with writeback data mode
[    7.885698] splash_progress 37
[    7.885956] /etc/rcS.d/S11mountall-bootclean.sh start
[    7.938113] splash_progress 39
[    7.938361] /etc/rcS.d/S12mountoverflowtmp start
[    7.954407] splash_progress 41
[    7.954741] /etc/rcS.d/S13networking start
[    7.956410] Configuring network interfaces
[    8.611625] netconsole: network logging stopped on interface eth0 as it is joining a master device
[    8.611814] device eth0 entered promiscuous mode
[    8.615999] br0: port 1(eth0) entering forwarding state
[    8.616097] br0: port 1(eth0) entering forwarding state
[    9.610024] br0: port 1(eth0) entering forwarding state
[    9.742593] network interfaces configured
[    9.742838] splash_progress 44
[    9.742955] /etc/rcS.d/S13procps start
[    9.762853] splash_progress 46
[    9.762972] /etc/rcS.d/S13udev-mtab start
[    9.774548] splash_progress 48
[    9.774668] /etc/rcS.d/S13urandom start
[    9.885408] splash_progress 50
[    9.885669] /etc/rcS.d/S14mountnfs.sh start
[    9.888207] splash_progress 52
[    9.888437] /etc/rcS.d/S15mountnfs-bootclean.sh start
[    9.904577] splash_progress 55
[    9.904811] /etc/rcS.d/S16kbd start
[   10.014870] splash_progress 57
[   10.015109] /etc/rcS.d/S17console-setup start
[   10.185111] splash_progress 59
[   10.203573] /etc/rcS.d/S18bootmisc.sh start
[   10.224406] splash_progress 61
[   10.224528] /etc/rcS.d/S18screen-cleanup start
[   10.267160] splash_progress 63
[   10.267409] /etc/rcS.d/S19stop-bootlogd-single start
[   10.269192] splash_progress 66
[   10.290808] /etc/rc2.d/S01rsyslog start
[   10.439750] splash_progress 67
[   10.439871] /etc/rc2.d/S01sudo start
[   10.487166] splash_progress 69
[   10.487309] /etc/rc2.d/S01xend start
[   10.510767] splash_progress 71
[   10.511191] /etc/rc2.d/S02acpid start
[   10.544147] splash_progress 73
[   10.544268] /etc/rc2.d/S02bind9 start
[   10.941185] splash_progress 75
[   10.941305] /etc/rc2.d/S02loadcpufreq start
[   10.986515] splash_progress 77
[   10.986635] /etc/rc2.d/S02mdadm start
[   10.995983] splash_progress 78
[   10.996103] /etc/rc2.d/S02ntp start
[   11.064937] splash_progress 80
[   11.065058] /etc/rc2.d/S02smartmontools start
[   11.074035] splash_progress 82
[   11.074157] /etc/rc2.d/S02ssh start
[   11.207009] sshd (1625): /proc/1625/oom_adj is deprecated, please use /proc/1625/oom_score_adj instead.
[   11.211599] splash_progress 84
[   11.211720] /etc/rc2.d/S02xendomains start
[   11.257901] splash_progress 86
[   11.258270] /etc/rc2.d/S03bootlogs start
[   11.362275] splash_progress 88
[   11.362398] /etc/rc2.d/S03cpufrequtils start
[   11.389910] splash_progress 89
[   11.390126] /etc/rc2.d/S03cron start
[   11.487976] splash_progress 91
[   11.488096] /etc/rc2.d/S03rsync start
[   11.491718] splash_progress 93
[   11.492012] /etc/rc2.d/S04rc.local start
[   11.495195] splash_progress 95
[   11.495317] /etc/rc2.d/S04rmnologin start
[   11.497180] splash_progress 97
[   11.497300] /etc/rc2.d/S04stop-bootlogd start
[   12.545313] splash_progress 99
[   16.120016] eth0: no IPv6 routers present
[   19.140028] br0: no IPv6 routers present

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
