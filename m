Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab1DMQ7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:59:54 -0400
Received: from mail.candelatech.com ([208.74.158.172]:57107 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab1DMQ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:59:51 -0400
Message-ID: <4DA5D5D8.8070301@candelatech.com>
Date: Wed, 13 Apr 2011 09:56:56 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING at libata-core.c:5015 in 2.6.39-rc3-wl+, then lockup.
References: <4DA5CF81.4070908@candelatech.com>
In-Reply-To: <4DA5CF81.4070908@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 09:29 AM, Ben Greear wrote:
> This on an multi-core Atom based appliance.  Using SSD for hard-drive.
> Fedora 14 OS.
>
> 2.6.39-rc* has been very flaky for me on this system (haven't tried other
> machines yet), and I'm pretty sure I saw similar bugs on earlier 39-rc
> kernels though
> they often crashed on other things as well...

I found someone else reporting this bug against -rc1, and folks
requested lspci -nn.  It's included below.  This is from a different
boot, but appears to be the same bug.  System didn't lock hard right away,
but crashed shortly after I gathered this info.

[root@lec2010-ath9k-1 ~]# lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Mobile 945GME Express Memory Controller Hub [8086:27ac] (rev 03)
00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 945GME Express Integrated Graphics Controller [8086:27ae] (rev 03)
00:02.1 Display controller [0380]: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller [8086:27a6] (rev 03)
00:1b.0 Audio device [0403]: Intel Corporation N10/ICH 7 Family High Definition Audio Controller [8086:27d8] (rev 02)
00:1c.0 PCI bridge [0604]: Intel Corporation N10/ICH 7 Family PCI Express Port 1 [8086:27d0] (rev 02)
00:1c.1 PCI bridge [0604]: Intel Corporation N10/ICH 7 Family PCI Express Port 2 [8086:27d2] (rev 02)
00:1d.0 USB Controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #1 [8086:27c8] (rev 02)
00:1d.1 USB Controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 [8086:27c9] (rev 02)
00:1d.2 USB Controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 [8086:27ca] (rev 02)
00:1d.3 USB Controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 [8086:27cb] (rev 02)
00:1d.7 USB Controller [0c03]: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller [8086:27cc] (rev 02)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev e2)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge [8086:27b9] (rev 02)
00:1f.2 IDE interface [0101]: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller [8086:27c4] (rev 02)
00:1f.3 SMBus [0c05]: Intel Corporation N10/ICH 7 Family SMBus Controller [8086:27da] (rev 02)
01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 02)
02:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 02)
03:00.0 Network controller [0280]: Atheros Communications Inc. AR922X Wireless Network Adapter [168c:0029] (rev 01)


[root@lec2010-ath9k-1 ~]# dmesg
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.39-rc3-wl+ (greearb@build-32) (gcc version 4.4.5 20101112 (Red Hat 4.4.5-2) (GCC) ) #58 SMP Wed Apr 13 09:15:24 PDT 2011
KERNEL supported cpus:
   Intel GenuineIntel
   AMD AuthenticAMD
   NSC Geode by NSC
   Cyrix CyrixInstead
   Centaur CentaurHauls
   Transmeta GenuineTMx86
   Transmeta TransmetaCPU
   UMC UMC UMC UMC
Atom PSE erratum detected, BIOS microcode update recommended
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000007f7c0000 (usable)
  BIOS-e820: 000000007f7c0000 - 000000007f7ce000 (ACPI data)
  BIOS-e820: 000000007f7ce000 - 000000007f800000 (ACPI NVS)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI present.
DMI: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080015  05/31/2010
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x7f7c0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
   00000-9FFFF write-back
   A0000-DFFFF uncachable
   E0000-E3FFF write-protect
   E4000-EFFFF write-through
   F0000-FFFFF write-protect
MTRR variable ranges enabled:
   0 base 000000000 mask 080000000 write-back
   1 base 07F800000 mask 0FF800000 uncachable
   2 disabled
   3 disabled
   4 disabled
   5 disabled
   6 disabled
   7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2040MB, range: 8MB, type UC
total RAM covered: 2040M
Found optimal setting for mtrr clean up
  gran_size: 64K 	chunk_size: 16M 	num_reg: 2  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2040MB, range: 8MB, type UC
found SMP MP-table at [c00ff780] ff780
initial memory mapped : 0 - 01400000
Base memory trampoline at [c009b000] 9b000 size 16384
init_memory_mapping: 0000000000000000-00000000377fe000
  0000000000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 131f000-1400000
RAMDISK: 37ae8000 - 37ff0000
Allocated new RAMDISK: 372f6000 - 377fddbf
Move RAMDISK from 0000000037ae8000 - 0000000037fefdbe to 372f6000 - 377fddbe
ACPI: RSDP 000f99c0 00014 (v00 ACPIAM)
ACPI: RSDT 7f7c0000 0003C (v01 053110 RSDT1119 20100531 MSFT 00000097)
ACPI: FACP 7f7c0200 00084 (v02 053110 FACP1119 20100531 MSFT 00000097)
ACPI: DSDT 7f7c0430 03E81 (v01  1AAAA 1AAAA000 00000000 INTL 20051117)
ACPI: FACS 7f7ce000 00040
ACPI: APIC 7f7c0390 0005C (v01 053110 APIC1119 20100531 MSFT 00000097)
ACPI: MCFG 7f7c03f0 0003C (v01 053110 OEMMCFG  20100531 MSFT 00000097)
ACPI: OEMB 7f7ce040 00071 (v01 053110 OEMB1119 20100531 MSFT 00000097)
ACPI: ASF! 7f7c42c0 00075 (v32 LEGEND I865PASF 00000001 INTL 20051117)
ACPI: SSDT 7f7cea00 004F0 (v01  PmRef    CpuPm 00003000 INTL 20051117)
ACPI: Local APIC address 0xfee00000
1151MB HIGHMEM available.
887MB LOWMEM available.
   mapped low ram: 0 - 377fe000
   low ram: 0 - 377fe000
Zone PFN ranges:
   DMA      0x00000010 -> 0x00001000
   Normal   0x00001000 -> 0x000377fe
   HighMem  0x000377fe -> 0x0007f7c0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
     0: 0x00000010 -> 0x0000009f
     0: 0x00000100 -> 0x0007f7c0
On node 0 totalpages: 522063
free_area_init_node: node 0, pgdat c0a78500, node_mem_map f6305200
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 3951 pages, LIFO batch:0
   Normal zone: 1744 pages used for memmap
   Normal zone: 221486 pages, LIFO batch:31
   HighMem zone: 2304 pages used for memmap
   HighMem zone: 292546 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 7f800000 (gap: 7f800000:7f600000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 12 pages/cpu @f62cc000 s28224 r0 d20928 u49152
pcpu-alloc: s28224 r0 d20928 u49152 alloc=12*4096
pcpu-alloc: [0] 0 [0] 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517983
Kernel command line: ro root=/dev/mapper/VolGroup-lv_root rd_LVM_LV=VolGroup/lv_root rd_LVM_LV=VolGroup/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 
SYSFONT=latarcyrheb-sun16 KEYTABLE=us elevator=noop console=tty0 console=ttyS0,115200
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
allocated 8354560 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Initializing HighMem for node 0 (000377fe:0007f7c0)
Memory: 2043872k/2088704k available (4077k kernel code, 44380k reserved, 2580k data, 612k init, 1179400k highmem)
virtual kernel memory layout:
     fixmap  : 0xffd33000 - 0xfffff000   (2864 kB)
     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
       .init : 0xc0a81000 - 0xc0b1a000   ( 612 kB)
       .data : 0xc07fb49c - 0xc0a80880   (2580 kB)
       .text : 0xc0400000 - 0xc07fb49c   (4077 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Hierarchical RCU implementation.
	RCU lockdep checking is enabled.
	RCU-based detection of stalled CPUs is disabled.
NR_IRQS:1280
CPU 0 irqstacks, hard=f540e000 soft=f5420000
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
  memory used by lock dependency info: 3567 kB
  per task-struct memory footprint: 1152 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                  | spin |wlock |rlock |mutex | wsem | rsem |
   --------------------------------------------------------------------------
                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
   --------------------------------------------------------------------------
               recursive read-lock:             |  ok  |             |  ok  |
            recursive read-lock #2:             |  ok  |             |  ok  |
             mixed read-write-lock:             |  ok  |             |  ok  |
             mixed write-read-lock:             |  ok  |             |  ok  |
   --------------------------------------------------------------------------
      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
       hard-irq read-recursion/123:  ok  |
       soft-irq read-recursion/123:  ok  |
       hard-irq read-recursion/132:  ok  |
       soft-irq read-recursion/132:  ok  |
       hard-irq read-recursion/213:  ok  |
       soft-irq read-recursion/213:  ok  |
       hard-irq read-recursion/231:  ok  |
       soft-irq read-recursion/231:  ok  |
       hard-irq read-recursion/312:  ok  |
       soft-irq read-recursion/312:  ok  |
       hard-irq read-recursion/321:  ok  |
       soft-irq read-recursion/321:  ok  |
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
Fast TSC calibration using PIT
Detected 1595.989 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3191.97 BogoMIPS (lpj=1595989)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
spurious 8259A interrupt: IRQ7.
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
Initializing cgroup subsys perf_event
Atom PSE erratum detected, BIOS microcode update recommended
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
ACPI: Core revision 20110316
ftrace: allocating 22126 entries in 44 pages
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Genuine Intel(R) CPU N270   @ 1.60GHz stepping 02
Performance Events: PEBS fmt0+, Atom events, Intel PMU driver.
... version:                3
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
NMI watchdog enabled, takes one hw-pmu counter.
lockdep: fixing up alternatives.
CPU 1 irqstacks, hard=f54e6000 soft=f54e8000
Booting Node   0, Processors  #1 Ok.
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Atom PSE erratum detected, BIOS microcode update recommended
NMI watchdog enabled, takes one hw-pmu counter.
Brought up 2 CPUs
Total of 2 processors activated (6383.43 BogoMIPS).
devtmpfs: initialized
PM: Registering ACPI NVS region at 7f7ce000 (204800 bytes)
print_constraints: dummy:
Time: 16:48:20  Date: 04/13/11
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: SSDT 7f7ce190 0023C (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 0023C (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
ACPI: SSDT 7f7ce460 00594 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00594 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
ACPI: SSDT 7f7ce0c0 000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
ACPI: SSDT 7f7ce3d0 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
PCI: MMCONFIG for 0000 [bus00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000) (size reduced!)
PCI: Using MMCONFIG for extended config space
ACPI: No dock devices found.
HEST: Table not found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
pci_root PNP0A08:00: host bridge window [mem 0x7f800000-0xdfffffff]
pci_root PNP0A08:00: host bridge window [mem 0xe4000000-0xfed8ffff]
pci 0000:00:00.0: [8086:27ac] type 0 class 0x000600
pci 0000:00:02.0: [8086:27ae] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xfe880000-0xfe8fffff]
pci 0000:00:02.0: reg 14: [io  0xcc80-0xcc87]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
pci 0000:00:02.0: reg 1c: [mem 0xfe840000-0xfe87ffff]
pci 0000:00:02.1: [8086:27a6] type 0 class 0x000380
pci 0000:00:02.1: reg 10: [mem 0xfe780000-0xfe7fffff]
pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xfe838000-0xfe83bfff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0xcc00-0xcc1f]
pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0xc880-0xc89f]
pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0xc800-0xc81f]
pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
pci 0000:00:1d.3: reg 20: [io  0xc480-0xc49f]
pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xfe837c00-0xfe837fff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
pci 0000:00:1f.0: [8086:27b9] type 0 class 0x000601
pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 03e0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 02e0 (mask 000f)
pci 0000:00:1f.2: [8086:27c4] type 0 class 0x000101
pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.2: reg 20: [io  0xffa0-0xffaf]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
pci 0000:01:00.0: [10ec:8168] type 0 class 0x000200
pci 0000:01:00.0: reg 10: [io  0xdc00-0xdcff]
pci 0000:01:00.0: reg 18: [mem 0xfe9ff000-0xfe9fffff 64bit]
pci 0000:01:00.0: reg 20: [mem 0xfdef0000-0xfdefffff 64bit pref]
pci 0000:01:00.0: reg 30: [mem 0xfe9c0000-0xfe9dffff pref]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:00.0: PME# disabled
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1c.0:   bridge window [mem 0xfe900000-0xfe9fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
pci 0000:02:00.0: [10ec:8168] type 0 class 0x000200
pci 0000:02:00.0: reg 10: [io  0xec00-0xecff]
pci 0000:02:00.0: reg 18: [mem 0xfeaff000-0xfeafffff 64bit]
pci 0000:02:00.0: reg 20: [mem 0xfdff0000-0xfdffffff 64bit pref]
pci 0000:02:00.0: reg 30: [mem 0xfeac0000-0xfeadffff pref]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.1: PCI bridge to [bus 02-02]
pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
pci 0000:00:1c.1:   bridge window [mem 0xfea00000-0xfeafffff]
pci 0000:00:1c.1:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
pci 0000:03:00.0: [168c:0029] type 0 class 0x000280
pci 0000:03:00.0: reg 10: [mem 0xfebf0000-0xfebfffff]
pci 0000:03:00.0: PME# supported from D0 D3hot
pci 0000:03:00.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x7f800000-0xdfffffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xe4000000-0xfed8ffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
  pci0000:00: Requesting ACPI _OSC control (0x1d)
Unable to assume _OSC PCIe control. Disabling ASPM
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 *6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 *6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 *6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 *6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 *6 7 10 11 12 14 15)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009fc00 - 000000000009ffff
reserve RAM buffer: 000000007f7c0000 - 000000007fffffff
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000d0000-0x000dffff window]
pnp 00:00: [mem 0x7f800000-0xdfffffff window]
pnp 00:00: [mem 0xe4000000-0xfed8ffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [mem 0xfed13000-0xfed19fff]
system 00:01: [mem 0xfed13000-0xfed19fff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:02: [dma 4]
pnp 00:02: [io  0x0000-0x000f]
pnp 00:02: [io  0x0081-0x0083]
pnp 00:02: [io  0x0087]
pnp 00:02: [io  0x0089-0x008b]
pnp 00:02: [io  0x008f]
pnp 00:02: [io  0x00c0-0x00df]
pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:03: [io  0x0070-0x0071]
pnp 00:03: [irq 8]
pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:04: [io  0x0061]
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: [io  0x00f0-0x00ff]
pnp 00:05: [irq 13]
pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:06: [io  0x03f8-0x03ff]
pnp 00:06: IRQ 4 override to edge, high
pnp 00:06: [irq 4]
pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:07: [io  0x02f8-0x02ff]
pnp 00:07: IRQ 3 override to edge, high
pnp 00:07: [irq 3]
pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:08: [io  0x03e8-0x03ef]
pnp 00:08: IRQ 10 override to edge, high
pnp 00:08: [irq 10]
pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:09: [io  0x02e8-0x02ef]
pnp 00:09: IRQ 11 override to edge, high
pnp 00:09: [irq 11]
pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0a: [io  0x03e0-0x03e7]
pnp 00:0a: IRQ 5 override to edge, high
pnp 00:0a: [irq 5]
pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0b: [io  0x02e0-0x02e7]
pnp 00:0b: IRQ 7 override to edge, high
pnp 00:0b: [irq 7]
pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0c: [io  0x0000-0xffffffff disabled]
pnp 00:0c: [io  0x0a00-0x0a0f]
pnp 00:0c: [io  0x0a10-0x0a1f]
system 00:0c: [io  0x0a00-0x0a0f] has been reserved
system 00:0c: [io  0x0a10-0x0a1f] has been reserved
system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0d: [io  0x0010-0x001f]
pnp 00:0d: [io  0x0022-0x003f]
pnp 00:0d: [io  0x0044-0x005f]
pnp 00:0d: [io  0x0063]
pnp 00:0d: [io  0x0065]
pnp 00:0d: [io  0x0067-0x006f]
pnp 00:0d: [io  0x0072-0x007f]
pnp 00:0d: [io  0x0080]
pnp 00:0d: [io  0x0084-0x0086]
pnp 00:0d: [io  0x0088]
pnp 00:0d: [io  0x008c-0x008e]
pnp 00:0d: [io  0x0090-0x009f]
pnp 00:0d: [io  0x00a2-0x00bf]
pnp 00:0d: [io  0x00e0-0x00ef]
pnp 00:0d: [io  0x04d0-0x04d1]
pnp 00:0d: [io  0x0800-0x087f]
pnp 00:0d: [io  0x0000-0xffffffff disabled]
pnp 00:0d: [io  0x0480-0x04bf]
pnp 00:0d: [mem 0xfed1c000-0xfed1ffff]
pnp 00:0d: [mem 0xfed20000-0xfed3ffff]
pnp 00:0d: [mem 0xfed40000-0xfed8ffff]
system 00:0d: [io  0x04d0-0x04d1] has been reserved
system 00:0d: [io  0x0800-0x087f] has been reserved
system 00:0d: [io  0x0480-0x04bf] has been reserved
system 00:0d: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:0d: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:0d: [mem 0xfed40000-0xfed8ffff] has been reserved
system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0e: [mem 0xfec00000-0xfec00fff]
pnp 00:0e: [mem 0xfee00000-0xfee00fff]
system 00:0e: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0e: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0f: [mem 0xe0000000-0xe3ffffff]
system 00:0f: [mem 0xe0000000-0xe3ffffff] has been reserved
system 00:0f: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:10: [mem 0x00000000-0x0009ffff]
pnp 00:10: [mem 0x000c0000-0x000cffff]
pnp 00:10: [mem 0x000e0000-0x000fffff]
pnp 00:10: [mem 0x00100000-0x7f7fffff]
pnp 00:10: [mem 0xfed90000-0xffffffff]
system 00:10: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:10: [mem 0x000c0000-0x000cffff] could not be reserved
system 00:10: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:10: [mem 0x00100000-0x7f7fffff] could not be reserved
system 00:10: [mem 0xfed90000-0xffffffff] could not be reserved
system 00:10: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 17 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1c.0:   bridge window [mem 0xfe900000-0xfe9fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 02-02]
pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
pci 0000:00:1c.1:   bridge window [mem 0xfea00000-0xfeafffff]
pci 0000:00:1c.1:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 03-03]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:00: resource 8 [mem 0x7f800000-0xdfffffff]
pci_bus 0000:00: resource 9 [mem 0xe4000000-0xfed8ffff]
pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:01: resource 1 [mem 0xfe900000-0xfe9fffff]
pci_bus 0000:01: resource 2 [mem 0xfde00000-0xfdefffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
pci_bus 0000:02: resource 1 [mem 0xfea00000-0xfeafffff]
pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
pci_bus 0000:03: resource 1 [mem 0xfeb00000-0xfebfffff]
pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:03: resource 8 [mem 0x7f800000-0xdfffffff]
pci_bus 0000:03: resource 9 [mem 0xe4000000-0xfed8ffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 3, 40960 bytes)
UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 32 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 5152k freed
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
audit: initializing netlink socket (disabled)
type=2000 audit(1302713299.298:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1698
SELinux:  Registering netfilter hooks
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered (default)
io scheduler deadline registered
io scheduler cfq registered
start plist test
end plist test
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
intel_idle: MWAIT substates: 0x20220
intel_idle: v0.4 model 0x1C
intel_idle: lapic_timer_reliable_states 0x2
Marking TSC unstable due to TSC halts in idle states deeper than C2
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: acpi_idle yielding to intel_idle
ERST: Table is not found!
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
serial8250: ttyS2 at I/O 0x3e8 (irq = 10) is a 16550A
serial8250: ttyS3 at I/O 0x2e8 (irq = 11) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS2 at I/O 0x3e8 (irq = 10) is a 16550A
00:09: ttyS3 at I/O 0x2e8 (irq = 11) is a 16550A
serial 00:0a: disabled
serial 00:0b: disabled
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GME Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
brd: module loaded
loop: module loaded
ata_piix 0000:00:1f.2: version 2.13
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: using broken periodic workaround
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe837c00
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.39-rc3-wl+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000cc00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.39-rc3-wl+ uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata1.01: ATA-8: STT_FTM16GL25H, 080826, max UDMA/100
ata1.01: 31277056 sectors, multi 0: LBA
ata1.01: configured for UDMA/100
scsi 0:0:1:0: Direct-Access     ATA      STT_FTM16GL25H   0808 PQ: 0 ANSI: 5
sd 0:0:1:0: Attached scsi generic sg0 type 0
sd 0:0:1:0: [sda] 31277056 512-byte logical blocks: (16.0 GB/14.9 GiB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
  sda: sda1 sda2
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000c880
sd 0:0:1:0: [sda] Attached SCSI disk
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.39-rc3-wl+ uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000c800
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.39-rc3-wl+ uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000c480
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.39-rc3-wl+ uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
i8042: PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
EFI Variables Facility v0.08 2004-May-17
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Registering the dns_resolver key type
Using IPI No-Shortcut mode
PM: Hibernation image not present or could not be loaded.
registered taskstats version 1
   Magic number: 7:448:843
Freeing unused kernel memory: 612k freed
Write protecting the kernel text: 4080k
Write protecting the kernel read-only data: 1952k
dracut: dracut-006-6.fc14
dracut: rd_NO_LUKS: removing cryptoluks activation
udev[69]: starting version 161
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[drm] initialized overlay support
fbcon: inteldrmfb (fb0) is primary device
[drm] Changing LVDS panel from (+hsync, +vsync) to (-hsync, -vsync)
Console: switching to colour frame buffer device 160x64
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
dracut: Starting plymouth daemon
dracut: Scanning devices sda2  for LVM logical volumes VolGroup/lv_root VolGroup/lv_swap
dracut: inactive '/dev/VolGroup/lv_root' [10.47 GiB] inherit
dracut: inactive '/dev/VolGroup/lv_swap' [3.94 GiB] inherit
EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
EXT4-fs (dm-0): write access will be enabled during recovery
EXT4-fs (dm-0): recovery complete
EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
dracut: Remounting /dev/mapper/VolGroup-lv_root with -o noatime,ro
EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
dracut: Mounted root filesystem /dev/mapper/VolGroup-lv_root
dracut: Loading SELinux policy
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
type=1404 audit(1302713305.280:2): selinux=0 auid=4294967295 ses=4294967295
dracut: /sbin/load_policy: Can't load policy: No such file or directory
dracut: Switching root
udev[285]: starting version 161
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
r8169 0000:01:00.0: setting latency timer to 64
r8169 0000:01:00.0: irq 42 for MSI/MSI-X
r8169 0000:01:00.0: eth0: RTL8168c/8111c at 0xf8936000, 00:90:0b:13:ed:ea, XID 1c4000c0 IRQ 42
intel_rng: FWH not detected
input: PC Speaker as /devices/platform/pcspkr/input/input2
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
iTCO_vendor_support: vendor-support=0
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
r8169 0000:02:00.0: setting latency timer to 64
r8169 0000:02:00.0: irq 43 for MSI/MSI-X
r8169 0000:02:00.0: eth1: RTL8168c/8111c at 0xf89d8000, 00:90:0b:13:ed:eb, XID 1c4000c0 IRQ 43
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Version=2, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
microcode: CPU0 sig=0x106c2, pf=0x4, revision=0x204
leds_ss4200: no LED devices found
cfg80211: Calling CRDA to update world regulatory domain
microcode: CPU1 sig=0x106c2, pf=0x4, revision=0x204
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: ALC888: BIOS auto-probing.
ALSA patch_realtek.c:1458: SKU: Nid=0x1d sku_cfg=0x40120601
ALSA patch_realtek.c:1460: SKU: port_connectivity=0x1
ALSA patch_realtek.c:1461: SKU: enable_pcbeep=0x1
ALSA patch_realtek.c:1462: SKU: check_sum=0x00000002
ALSA patch_realtek.c:1463: SKU: customization=0x00000006
ALSA patch_realtek.c:1464: SKU: external_amp=0x0
ALSA patch_realtek.c:1465: SKU: platform_type=0x0
ALSA patch_realtek.c:1466: SKU: swap=0x0
ALSA patch_realtek.c:1467: SKU: override=0x1
ALSA hda_codec.c:4634: autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0)
ALSA hda_codec.c:4638:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA hda_codec.c:4642:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA hda_codec.c:4643:    mono: mono_out=0x0
ALSA hda_codec.c:4647:    inputs:
ALSA hda_codec.c:4653:
ALSA patch_realtek.c:1515: realtek: No valid SSID, checking pincfg 0x40120601 for NID 0x1d
ALSA patch_realtek.c:1531: realtek: Enabling init ASM_ID=0x0601 CODEC_ID=10ec0888
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input3
microcode: CPU0 updated to revision 0x218, date = 2009-04-10
microcode: CPU1 updated to revision 0x218, date = 2009-04-10
IPv4 FIB: Using LC-trie version 0.409
ath9k 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
cfg80211: Calling CRDA for country: US
Registered led device: ath9k-phy0
ieee80211 phy0: Atheros AR9280 Rev:2 mem=0xf8e60000, irq=16
cfg80211: Regulatory domain changed to country: US
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
EXT4-fs (dm-0): re-mounted. Opts: (null)
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
NET: Registered protocol family 10
r8169 0000:01:00.0: eth0: link up
r8169 0000:01:00.0: eth0: link up
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
r8169 0000:01:00.0: eth0: link up
r8169 0000:01:00.0: eth0: link up
r8169 0000:01:00.0: eth0: link up
eth0: no IPv6 routers present
r8169 0000:01:00.0: eth0: link up
r8169 0000:01:00.0: eth0: link up
r8169 0000:01:00.0: eth0: link up
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
FS-Cache: Loaded
FS-Cache: Netfs 'nfs' registered for caching
coretemp coretemp.0: Unable to read TjMax from CPU.
sshd (1253): /proc/1253/oom_adj is deprecated, please use /proc/1253/oom_score_adj instead.
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux.wireless-testing/drivers/ata/libata-core.c:5015 ata_qc_issue+0x15d/0x296()
Hardware name: To Be Filled By O.E.M.
Modules linked in: coretemp hwmon nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 uinput arc4 ath9k mac80211 snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep ath9k_common ath9k_hw snd_seq snd_seq_device ath snd_pcm cfg80211 microcode iTCO_wdt serio_raw i2c_i801 iTCO_vendor_support snd_timer pcspkr snd r8169 
mii soundcore snd_page_alloc i915 drm_kms_helper drm i2c_algo_bit video [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Not tainted 2.6.39-rc3-wl+ #58
Call Trace:
  [<c043a11a>] warn_slowpath_common+0x6a/0x7f
  [<c06a9395>] ? ata_qc_issue+0x15d/0x296
  [<c043a143>] warn_slowpath_null+0x14/0x18
  [<c06a9395>] ata_qc_issue+0x15d/0x296
  [<c06af2c7>] __ata_scsi_queuecmd+0x15b/0x1a0
  [<c06ae9cf>] ? ata_scsiop_mode_sense+0x25c/0x25c
  [<c06af38e>] ata_scsi_queuecmd+0x3c/0x63
  [<c0690dbe>] scsi_dispatch_cmd+0x161/0x1ee
  [<c0695ef8>] scsi_request_fn+0x319/0x44a
  [<c05b5c5e>] __blk_run_queue+0x5d/0x8d
  [<c05b601d>] blk_run_queue+0x22/0x33
  [<c06956d3>] scsi_run_queue+0x28a/0x30e
  [<c0691040>] ? __scsi_put_command+0x59/0x5f
  [<c06961d4>] scsi_next_command+0x2d/0x39
  [<c0696cfd>] scsi_io_completion+0x3e8/0x41f
  [<c069683a>] ? scsi_device_unbusy+0x8c/0x92
  [<c0690b5b>] scsi_finish_command+0xc5/0xcd
  [<c0696e25>] scsi_softirq_done+0xdd/0xe5
  [<c05bb0c2>] blk_done_softirq+0x66/0x73
  [<c043fbda>] __do_softirq+0xb1/0x17c
  [<c043fb29>] ? __local_bh_enable+0x8c/0x8c
  <IRQ>  [<c043f9aa>] ? irq_exit+0x43/0x8e
  [<c0403b43>] ? do_IRQ+0x81/0x95
  [<c07fa92e>] ? common_interrupt+0x2e/0x40
  [<c046007b>] ? ftrace_raw_output_lock+0x53/0xaa
  [<c0617633>] ? intel_idle+0xbf/0xe8
  [<c0724bd0>] ? cpuidle_idle_call+0xcd/0x141
  [<c0402439>] ? cpu_idle+0x58/0x77
  [<c07d9166>] ? rest_init+0x92/0x97
  [<c0a817f8>] ? start_kernel+0x30f/0x314
  [<c0a810c5>] ? i386_start_kernel+0xc5/0xcc
---[ end trace f88fb9625c23bd19 ]---
ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.01: failed command: READ DMA
ata1.01: cmd c8/00:10:f8:cf:0f/00:00:00:00:00/f1 tag 0 dma 8192 in
          res 50/00:00:88:cf:0f/00:00:00:00:00/f1 Emask 0x40 (internal error)
ata1.01: status: { DRDY }
ata1.01: configured for UDMA/100
ata1: EH complete
fuse init (API version 7.16)
pktgen: Packet Generator for packet performance testing. Version: 2.74
wanlink: version magic '2.6.38-wl+ SMP mod_unload 586 ' should be '2.6.39-rc3-wl+ SMP mod_unload 586 '
r8169 0000:02:00.0: eth1: link up
r8169 0000:02:00.0: eth1: link up
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
r8169 0000:02:00.0: eth1: link up
r8169 0000:02:00.0: eth1: link up
ADDRCONF(NETDEV_UP): rddVR1b: link is not ready
r8169 0000:02:00.0: eth1: link up
r8169 0000:02:00.0: eth1: link up
ADDRCONF(NETDEV_CHANGE): rddVR1b: link becomes ready
ADDRCONF(NETDEV_UP): rddVR0b: link is not ready
ADDRCONF(NETDEV_CHANGE): rddVR0b: link becomes ready
ADDRCONF(NETDEV_UP): rddVR4: link is not ready

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

