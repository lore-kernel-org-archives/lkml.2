Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1DAThf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 15:37:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab1DATha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 15:37:30 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=EVKuf7F6qnwA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=2z1OXlWFAAAA:8 a=Dhlf5ZkEBDu8mUw1qCIA:9 a=TZjJZN8eqQLdCS1EMxsA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=63pbC3Pc-u4Zm4T2:21 a=n4nyaYToNim6l4Cr:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: 2.6.38 crash (null pointer reference at
 mark_inode_dirty+0xa1/0x151)
From: Steven Rostedt <rostedt@goodmis.org>
To: thunder8@xs4all.nl
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20110401205116.GA28751@onderneming10.xs4all.nl>
References: <20110331143227.GA8238@onderneming10.xs4all.nl>
	 <20110401141723.GH14441@home.goodmis.org>
	 <20110401205116.GA28751@onderneming10.xs4all.nl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 01 Apr 2011 15:37:26 -0400
Message-ID: <1301686646.2160.27.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added back LKML and added some people that know this code better ]

On Fri, 2011-04-01 at 20:51 +0000, thunder8@xs4all.nl wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Fri, Apr 01, 2011 at 10:17:23AM -0400
> > On Thu, Mar 31, 2011 at 02:32:27PM +0000, Jurriaan wrote:
> > > My laptop, running Debian Unstable + 2.6.38 debian kernel from
> > > experimantal, just crashed.
> > > 
> > > unable to handle null reference pointer
> > > mark_inode_dirty+0xa1/0x151
> > > 
> > > call trace (top lines)
> > > setattr_copy
> > > fat_setattr
> > > path_init_rcu
> > > need_resched
> > > 
> > > After resuming, I was adding backgrounds to Desktop Drapes and running
> > > rsync from an ext4 partition to an USB stick with a vfat filesystem.
> > 
> > Hi, 
> > 
> > Thanks for the report. As this looks like you hand typed the output, I
> > doubt you have any way to save the full dump. Could you be able to take
> > a digital photo of the screen and upload it somewhere?
> > 
> I might have taken a snapshot, but unfortunatly, I didn't. You're right
> on the hand-written aspect. 
> 
> All I can add now is that this is an IBM Z61p thinkpad, lspci & dmesg
> below. Another rsync run didn't oops, so it's not that reproducable
> unfortunately.

There's not much to go on that I can see. Hopefully someone else will be
able to hit this as well and have a full dump. Or maybe one of us can
reproduce it.

Thanks,

-- Steve

> 
> Kind regards,
> Jurriaan
> 
> 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML
> and 945GT Express Memory Controller Hub (rev 03)
> 00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML
> and 945GT Express PCI Express Root Port (rev 03)
> 00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition
> Audio Controller (rev 02)
> 00:1c.0 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port
> 1 (rev 02)
> 00:1c.1 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port
> 2 (rev 02)
> 00:1c.2 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port
> 3 (rev 02)
> 00:1c.3 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port
> 4 (rev 02)
> 00:1d.0 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI
> Controller #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI
> Controller #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI
> Controller #3 (rev 02)
> 00:1d.3 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI
> Controller #4 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation N10/ICH 7 Family USB2 EHCI
> Controller (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
> 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
> Bridge (rev 02)
> 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA
> IDE Controller (rev 02)
> 00:1f.3 SMBus: Intel Corporation N10/ICH 7 Family SMBus Controller (rev
> 02)
> 01:00.0 VGA compatible controller: ATI Technologies Inc M56GL [Mobility
> FireGL V5200]
> 02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5752M
> Gigabit Ethernet PCI Express (rev 02)
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
> [Golan] Network Connection (rev 02)
> 15:00.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
> 15:00.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant
> IEEE 1394 Host Controller
> 15:00.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia
> Card Reader (SD/MMC/MS/MS PRO/xD)
> 15:00.3 SD Host controller: Texas Instruments PCIxx12 SDA Standard
> Compliant SD Host Controller
> 
> dmesg:
> 
> 
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.38 (root@Z61p) (gcc version 4.5.2 (Debian 4.5.2-4) ) #1 SMP Sun Mar 20 12:39:56 CET 2011
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
> [    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfed0000 (usable)
> [    0.000000]  BIOS-e820: 00000000bfed0000 - 00000000bfedf000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bfedf000 - 00000000bff00000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bff00000 - 00000000c0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> [    0.000000] DMI present.
> [    0.000000] DMI: LENOVO 9452JRU/9452JRU, BIOS 7FETA9WW (2.27 ) 08/26/2009
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> [    0.000000] last_pfn = 0xbfed0 max_arch_pfn = 0x100000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CFFFF write-protect
> [    0.000000]   D0000-DBFFF uncachable
> [    0.000000]   DC000-DFFFF write-back
> [    0.000000]   E0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask F80000000 write-back
> [    0.000000]   1 base 080000000 mask FC0000000 write-back
> [    0.000000]   2 base 0BFF00000 mask FFFF00000 uncachable
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] found SMP MP-table at [c00f67e0] f67e0
> [    0.000000] initial memory mapped : 0 - 01800000
> [    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
> [    0.000000]  0000000000 - 0000400000 page 4k
> [    0.000000]  0000400000 - 0037400000 page 2M
> [    0.000000]  0037400000 - 00377fe000 page 4k
> [    0.000000] kernel direct mapping tables up to 377fe000 @ 17fb000-1800000
> [    0.000000] RAMDISK: 37440000 - 37ff0000
> [    0.000000] Allocated new RAMDISK: 36890000 - 3743fb17
> [    0.000000] Move RAMDISK from 0000000037440000 - 0000000037fefb16 to 36890000 - 3743fb16
> [    0.000000] ACPI: RSDP 000f67a0 00024 (v02 LENOVO)
> [    0.000000] ACPI: XSDT bfed1aeb 00094 (v01 LENOVO TP-7F    00002270  LTP 00000000)
> [    0.000000] ACPI: FACP bfed1c00 000F4 (v03 LENOVO TP-7F    00002270 LNVO 00000001)
> [    0.000000] ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 (20110112/tbfadt-526)
> [    0.000000] ACPI Warning: Optional field Gpe1Block has zero address or length: 0x000000000000102C/0x0 (20110112/tbfadt-557)
> [    0.000000] ACPI: DSDT bfed1f5e 0CC9E (v01 LENOVO TP-7F    00002270 MSFT 0100000E)
> [    0.000000] ACPI: FACS bfef4000 00040
> [    0.000000] ACPI: SSDT bfed1db4 001AA (v01 LENOVO TP-7F    00002270 MSFT 0100000E)
> [    0.000000] ACPI: ECDT bfedebfc 00052 (v01 LENOVO TP-7F    00002270 LNVO 00000001)
> [    0.000000] ACPI: TCPA bfedec4e 00032 (v02 LENOVO TP-7F    00002270 LNVO 00000001)
> [    0.000000] ACPI: APIC bfedec80 00068 (v01 LENOVO TP-7F    00002270 LNVO 00000001)
> [    0.000000] ACPI: MCFG bfedece8 0003C (v01 LENOVO TP-7F    00002270 LNVO 00000001)
> [    0.000000] ACPI: HPET bfeded24 00038 (v01 LENOVO TP-7F    00002270 LNVO 00000001)
> [    0.000000] ACPI: SLIC bfedee62 00176 (v01 LENOVO TP-7F    00002270  LTP 00000000)
> [    0.000000] ACPI: BOOT bfedefd8 00028 (v01 LENOVO TP-7F    00002270  LTP 00000001)
> [    0.000000] ACPI: SSDT bfef2686 0025F (v01 LENOVO TP-7F    00002270 INTL 20050513)
> [    0.000000] ACPI: SSDT bfef28e5 000A6 (v01 LENOVO TP-7F    00002270 INTL 20050513)
> [    0.000000] ACPI: SSDT bfef298b 004F7 (v01 LENOVO TP-7F    00002270 INTL 20050513)
> [    0.000000] ACPI: SSDT bfef2e82 008BD (v01 LENOVO TP-7F    00002270 INTL 20050513)
> [    0.000000] ACPI: SSDT bfef373f 006AD (v01 LENOVO TP-7F    00002270 INTL 20050513)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] 2182MB HIGHMEM available.
> [    0.000000] 887MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 377fe000
> [    0.000000]   low ram: 0 - 377fe000
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x000377fe
> [    0.000000]   HighMem  0x000377fe -> 0x000bfed0
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[2] active PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x000bfed0
> [    0.000000] On node 0 totalpages: 786015
> [    0.000000] free_area_init_node: node 0, pgdat c13c4a80, node_mem_map f5090200
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3951 pages, LIFO batch:0
> [    0.000000]   Normal zone: 1744 pages used for memmap
> [    0.000000]   Normal zone: 221486 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 4366 pages used for memmap
> [    0.000000]   HighMem zone: 554436 pages, LIFO batch:31
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x1008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
> [    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
> [    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:30000000)
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 12 pages/cpu @f4c00000 s27072 r0 d22080 u2097152
> [    0.000000] pcpu-alloc: s27072 r0 d22080 u2097152 alloc=1*4194304
> [    0.000000] pcpu-alloc: [0] 0 1 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 779873
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.38 root=UUID=da37983a-3c97-46c3-9248-6eb793035224 ro quiet
> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (000377fe:000bfed0)
> [    0.000000] Memory: 3101708k/3144512k available (2580k kernel code, 42352k reserved, 1303k data, 356k init, 2235208k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
> [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
> [    0.000000]       .init : 0xc13cc000 - 0xc1425000   ( 356 kB)
> [    0.000000]       .data : 0xc128537f - 0xc13cb340   (1303 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc128537f   (2580 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] 	RCU-based detection of stalled CPUs is disabled.
> [    0.000000] NR_IRQS:1280
> [    0.000000] CPU 0 irqstacks, hard=f480e000 soft=f4820000
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 1994.632 MHz processor.
> [    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.26 BogoMIPS (lpj=7978528)
> [    0.004008] pid_max: default: 32768 minimum: 301
> [    0.004112] Security Framework initialized
> [    0.004118] SELinux:  Disabled at boot.
> [    0.004155] Mount-cache hash table entries: 512
> [    0.004538] Initializing cgroup subsys ns
> [    0.004543] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
> [    0.004546] Initializing cgroup subsys cpuacct
> [    0.004577] Initializing cgroup subsys devices
> [    0.004579] Initializing cgroup subsys freezer
> [    0.004581] Initializing cgroup subsys net_cls
> [    0.004632] CPU: Physical Processor ID: 0
> [    0.004634] CPU: Processor Core ID: 0
> [    0.004637] mce: CPU supports 6 MCE banks
> [    0.004646] CPU0: Thermal monitoring enabled (TM2)
> [    0.004651] using mwait in idle threads.
> [    0.005104] ACPI: Core revision 20110112
> [    0.020060] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.020432] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.061356] CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 06
> [    0.064003] Performance Events: PEBS fmt0-, Core2 events, Intel PMU driver.
> [    0.064003] PEBS disabled due to CPU errata.
> [    0.064003] ... version:                2
> [    0.064003] ... bit width:              40
> [    0.064003] ... generic registers:      2
> [    0.064003] ... value mask:             000000ffffffffff
> [    0.064003] ... max period:             000000007fffffff
> [    0.064003] ... fixed-purpose events:   3
> [    0.064003] ... event mask:             0000000700000003
> [    0.064003] CPU 1 irqstacks, hard=f488a000 soft=f488c000
> [    0.064003] Booting Node   0, Processors  #1 Ok.
> [    0.008000] Initializing CPU#1
> [    0.152008] TSC synchronization [CPU#0 -> CPU#1]:
> [    0.152008] Measured 617448 cycles TSC warp between CPUs, turning off TSC clock.
> [    0.152008] Marking TSC unstable due to check_tsc_sync_source failed
> [    0.152022] Brought up 2 CPUs
> [    0.152025] Total of 2 processors activated (7979.30 BogoMIPS).
> [    0.152744] devtmpfs: initialized
> [    0.152744] print_constraints: dummy: 
> [    0.152744] NET: Registered protocol family 16
> [    0.152744] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> [    0.152744] ACPI: bus type pci registered
> [    0.152744] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
> [    0.152744] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
> [    0.152744] PCI: Using MMCONFIG for extended config space
> [    0.152744] PCI: Using configuration type 1 for base access
> [    0.152956] bio: create slab <bio-0> at 0
> [    0.156538] ACPI: EC: EC description table is found, configuring boot EC
> [    0.165575] ACPI: SSDT bfef1d25 00282 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
> [    0.166069] ACPI: Dynamic OEM Table Load:
> [    0.166072] ACPI: SSDT   (null) 00282 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
> [    0.166233] ACPI: SSDT bfef202c 0065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
> [    0.166753] ACPI: Dynamic OEM Table Load:
> [    0.166757] ACPI: SSDT   (null) 0065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
> [    0.176262] ACPI: SSDT bfef1c5d 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
> [    0.176749] ACPI: Dynamic OEM Table Load:
> [    0.176753] ACPI: SSDT   (null) 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
> [    0.176867] ACPI: SSDT bfef1fa7 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
> [    0.177345] ACPI: Dynamic OEM Table Load:
> [    0.177348] ACPI: SSDT   (null) 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
> [    0.188213] ACPI: Interpreter enabled
> [    0.188218] ACPI: (supports S0 S3 S4 S5)
> [    0.188239] ACPI: Using IOAPIC for interrupt routing
> [    0.189613] ACPI: Power Resource [PUBS] (on)
> [    0.196240] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
> [    0.221010] ACPI: ACPI Dock Station Driver: 4 docks/bays found
> [    0.221015] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.221274] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.221338] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
> [    0.221341] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
> [    0.221344] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
> [    0.221348] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
> [    0.221351] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
> [    0.221354] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
> [    0.221357] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed40fff]
> [    0.221372] pci 0000:00:00.0: [8086:27a0] type 0 class 0x000600
> [    0.221420] pci 0000:00:01.0: [8086:27a1] type 1 class 0x000604
> [    0.221459] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    0.221463] pci 0000:00:01.0: PME# disabled
> [    0.221528] pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
> [    0.221551] pci 0000:00:1b.0: reg 10: [mem 0xee400000-0xee403fff 64bit]
> [    0.221635] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.221641] pci 0000:00:1b.0: PME# disabled
> [    0.221669] pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
> [    0.221756] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.221761] pci 0000:00:1c.0: PME# disabled
> [    0.221792] pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
> [    0.221879] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.221884] pci 0000:00:1c.1: PME# disabled
> [    0.221915] pci 0000:00:1c.2: [8086:27d4] type 1 class 0x000604
> [    0.222002] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    0.222007] pci 0000:00:1c.2: PME# disabled
> [    0.222038] pci 0000:00:1c.3: [8086:27d6] type 1 class 0x000604
> [    0.222124] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    0.222130] pci 0000:00:1c.3: PME# disabled
> [    0.222163] pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
> [    0.222220] pci 0000:00:1d.0: reg 20: [io  0x1800-0x181f]
> [    0.222260] pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
> [    0.222317] pci 0000:00:1d.1: reg 20: [io  0x1820-0x183f]
> [    0.222357] pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
> [    0.222414] pci 0000:00:1d.2: reg 20: [io  0x1840-0x185f]
> [    0.222454] pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
> [    0.222511] pci 0000:00:1d.3: reg 20: [io  0x1860-0x187f]
> [    0.222563] pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
> [    0.222588] pci 0000:00:1d.7: reg 10: [mem 0xee404000-0xee4043ff]
> [    0.222678] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.222685] pci 0000:00:1d.7: PME# disabled
> [    0.222708] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
> [    0.222795] pci 0000:00:1f.0: [8086:27b9] type 0 class 0x000601
> [    0.222907] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
> [    0.222912] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
> [    0.222917] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
> [    0.222922] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
> [    0.222927] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
> [    0.222978] pci 0000:00:1f.2: [8086:27c4] type 0 class 0x000101
> [    0.223000] pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
> [    0.223012] pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
> [    0.223025] pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
> [    0.223037] pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
> [    0.223050] pci 0000:00:1f.2: reg 20: [io  0x18b0-0x18bf]
> [    0.223095] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.223100] pci 0000:00:1f.2: PME# disabled
> [    0.223118] pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
> [    0.223193] pci 0000:00:1f.3: reg 20: [io  0x18e0-0x18ff]
> [    0.223298] pci 0000:01:00.0: [1002:71c4] type 0 class 0x000300
> [    0.223328] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xdfffffff pref]
> [    0.224016] pci 0000:01:00.0: reg 14: [io  0x2000-0x20ff]
> [    0.224035] pci 0000:01:00.0: reg 18: [mem 0xee000000-0xee00ffff]
> [    0.224100] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
> [    0.224152] pci 0000:01:00.0: supports D1 D2
> [    0.224193] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> [    0.224196] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
> [    0.224201] pci 0000:00:01.0:   bridge window [mem 0xee000000-0xee0fffff]
> [    0.224206] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
> [    0.224331] pci 0000:02:00.0: [14e4:1601] type 0 class 0x000200
> [    0.224363] pci 0000:02:00.0: reg 10: [mem 0xee100000-0xee10ffff 64bit]
> [    0.224493] pci 0000:02:00.0: PME# supported from D3hot D3cold
> [    0.224499] pci 0000:02:00.0: PME# disabled
> [    0.224530] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
> [    0.224535] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
> [    0.224541] pci 0000:00:1c.0:   bridge window [mem 0xee100000-0xee1fffff]
> [    0.224550] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
> [    0.224711] pci 0000:03:00.0: [8086:4227] type 0 class 0x000280
> [    0.224768] pci 0000:03:00.0: reg 10: [mem 0xedf00000-0xedf00fff]
> [    0.225110] pci 0000:03:00.0: PME# supported from D0 D3hot
> [    0.225123] pci 0000:03:00.0: PME# disabled
> [    0.225224] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
> [    0.225230] pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
> [    0.225235] pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
> [    0.225244] pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
> [    0.225306] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
> [    0.225311] pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
> [    0.225317] pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
> [    0.225326] pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
> [    0.225388] pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
> [    0.225393] pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
> [    0.225399] pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
> [    0.225407] pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
> [    0.225459] pci 0000:15:00.0: [104c:8039] type 2 class 0x000607
> [    0.225487] pci 0000:15:00.0: reg 10: [mem 0xe4300000-0xe4300fff]
> [    0.225518] pci 0000:15:00.0: supports D1 D2
> [    0.225520] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.225527] pci 0000:15:00.0: PME# disabled
> [    0.225553] pci 0000:15:00.1: [104c:803a] type 0 class 0x000c00
> [    0.225582] pci 0000:15:00.1: reg 10: [mem 0xe4302000-0xe43027ff]
> [    0.225598] pci 0000:15:00.1: reg 14: [mem 0xe4304000-0xe4307fff]
> [    0.225696] pci 0000:15:00.1: supports D1 D2
> [    0.225699] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot
> [    0.225705] pci 0000:15:00.1: PME# disabled
> [    0.225731] pci 0000:15:00.2: [104c:803b] type 0 class 0x000180
> [    0.225759] pci 0000:15:00.2: reg 10: [mem 0xe4301000-0xe4301fff]
> [    0.225870] pci 0000:15:00.2: supports D1 D2
> [    0.225872] pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot
> [    0.225878] pci 0000:15:00.2: PME# disabled
> [    0.225904] pci 0000:15:00.3: [104c:803c] type 0 class 0x000805
> [    0.225932] pci 0000:15:00.3: reg 10: [mem 0xe4302800-0xe43028ff]
> [    0.226042] pci 0000:15:00.3: supports D1 D2
> [    0.226045] pci 0000:15:00.3: PME# supported from D0 D1 D2 D3hot
> [    0.226051] pci 0000:15:00.3: PME# disabled
> [    0.226131] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
> [    0.226137] pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
> [    0.226143] pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
> [    0.226151] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
> [    0.226155] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
> [    0.226158] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
> [    0.226161] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
> [    0.226164] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
> [    0.226167] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
> [    0.226171] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
> [    0.226174] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed40fff] (subtractive decode)
> [    0.226266] pci_bus 0000:00: on NUMA node 0
> [    0.226270] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.226366] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
> [    0.226403] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
> [    0.226441] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
> [    0.226478] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
> [    0.226519] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
> [    0.226561] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
> [    0.230894] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.230976] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.231057] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.231136] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.231215] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.231294] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.231372] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.231451] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.231553] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.231560] vgaarb: loaded
> [    0.231606] PCI: Using ACPI for IRQ routing
> [    0.231609] PCI: pci_cache_line_size set to 64 bytes
> [    0.231730] reserve RAM buffer: 000000000009f000 - 000000000009ffff 
> [    0.231733] reserve RAM buffer: 00000000bfed0000 - 00000000bfffffff 
> [    0.231859] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    0.231867] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    0.231872] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> [    0.236032] Switching to clocksource hpet
> [    0.237488] pnp: PnP ACPI init
> [    0.237503] ACPI: bus type pnp registered
> [    0.237958] pnp 00:00: [mem 0x00000000-0x0009ffff]
> [    0.237962] pnp 00:00: [mem 0x000c0000-0x000c3fff]
> [    0.237965] pnp 00:00: [mem 0x000c4000-0x000c7fff]
> [    0.237968] pnp 00:00: [mem 0x000c8000-0x000cbfff]
> [    0.237971] pnp 00:00: [mem 0x000cc000-0x000cffff]
> [    0.237974] pnp 00:00: [mem 0x000d0000-0x000d3fff]
> [    0.237977] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
> [    0.237981] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
> [    0.237984] pnp 00:00: [mem 0x000dc000-0x000dffff]
> [    0.237987] pnp 00:00: [mem 0x000e0000-0x000e3fff]
> [    0.237990] pnp 00:00: [mem 0x000e4000-0x000e7fff]
> [    0.237993] pnp 00:00: [mem 0x000e8000-0x000ebfff]
> [    0.237996] pnp 00:00: [mem 0x000ec000-0x000effff]
> [    0.237998] pnp 00:00: [mem 0x000f0000-0x000fffff]
> [    0.238002] pnp 00:00: [mem 0x00100000-0xbfffffff]
> [    0.238005] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
> [    0.238008] pnp 00:00: [mem 0xfed41000-0xffffffff]
> [    0.238085] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
> [    0.238089] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
> [    0.238092] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
> [    0.238096] system 00:00: [mem 0x000c8000-0x000cbfff] could not be reserved
> [    0.238099] system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
> [    0.238102] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
> [    0.238106] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
> [    0.238109] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
> [    0.238113] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
> [    0.238116] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
> [    0.238120] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
> [    0.238123] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
> [    0.238127] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
> [    0.238130] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
> [    0.238134] system 00:00: [mem 0xfed41000-0xffffffff] could not be reserved
> [    0.238137] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.238162] pnp 00:01: [bus 00-ff]
> [    0.238165] pnp 00:01: [io  0x0cf8-0x0cff]
> [    0.238168] pnp 00:01: [io  0x0000-0x0cf7 window]
> [    0.238171] pnp 00:01: [io  0x0d00-0xffff window]
> [    0.238175] pnp 00:01: [mem 0x000a0000-0x000bffff window]
> [    0.238178] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
> [    0.238181] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
> [    0.238184] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
> [    0.238188] pnp 00:01: [mem 0x000cc000-0x000cffff window]
> [    0.238191] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
> [    0.238194] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
> [    0.238197] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
> [    0.238201] pnp 00:01: [mem 0x000dc000-0x000dffff window]
> [    0.238204] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
> [    0.238207] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
> [    0.238210] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
> [    0.238214] pnp 00:01: [mem 0x000ec000-0x000effff window]
> [    0.238217] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
> [    0.238220] pnp 00:01: [mem 0xfed40000-0xfed40fff window]
> [    0.238274] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
> [    0.238318] pnp 00:02: [io  0x0010-0x001f]
> [    0.238321] pnp 00:02: [io  0x0090-0x009f]
> [    0.238324] pnp 00:02: [io  0x0024-0x0025]
> [    0.238327] pnp 00:02: [io  0x0028-0x0029]
> [    0.238329] pnp 00:02: [io  0x002c-0x002d]
> [    0.238332] pnp 00:02: [io  0x0030-0x0031]
> [    0.238335] pnp 00:02: [io  0x0034-0x0035]
> [    0.238338] pnp 00:02: [io  0x0038-0x0039]
> [    0.238341] pnp 00:02: [io  0x003c-0x003d]
> [    0.238343] pnp 00:02: [io  0x00a4-0x00a5]
> [    0.238346] pnp 00:02: [io  0x00a8-0x00a9]
> [    0.238349] pnp 00:02: [io  0x00ac-0x00ad]
> [    0.238351] pnp 00:02: [io  0x00b0-0x00b5]
> [    0.238354] pnp 00:02: [io  0x00b8-0x00b9]
> [    0.238357] pnp 00:02: [io  0x00bc-0x00bd]
> [    0.238360] pnp 00:02: [io  0x0050-0x0053]
> [    0.238362] pnp 00:02: [io  0x0072-0x0077]
> [    0.238365] pnp 00:02: [io  0x164e-0x164f]
> [    0.238368] pnp 00:02: [io  0x002e-0x002f]
> [    0.238371] pnp 00:02: [io  0x1000-0x107f]
> [    0.238374] pnp 00:02: [io  0x1180-0x11bf]
> [    0.238377] pnp 00:02: [io  0x0800-0x080f]
> [    0.238379] pnp 00:02: [io  0x15e0-0x15ef]
> [    0.238382] pnp 00:02: [io  0x1600-0x165f]
> [    0.238385] pnp 00:02: [mem 0xf0000000-0xf3ffffff]
> [    0.238388] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
> [    0.238391] pnp 00:02: [mem 0xfed14000-0xfed17fff]
> [    0.238394] pnp 00:02: [mem 0xfed18000-0xfed18fff]
> [    0.238397] pnp 00:02: [mem 0xfed19000-0xfed19fff]
> [    0.238504] system 00:02: [io  0x164e-0x164f] has been reserved
> [    0.238508] system 00:02: [io  0x1000-0x107f] has been reserved
> [    0.238511] system 00:02: [io  0x1180-0x11bf] has been reserved
> [    0.238514] system 00:02: [io  0x0800-0x080f] has been reserved
> [    0.238517] system 00:02: [io  0x15e0-0x15ef] has been reserved
> [    0.238521] system 00:02: [io  0x1600-0x165f] could not be reserved
> [    0.238525] system 00:02: [mem 0xf0000000-0xf3ffffff] has been reserved
> [    0.238528] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.238532] system 00:02: [mem 0xfed14000-0xfed17fff] has been reserved
> [    0.238535] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.238539] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.238542] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.238581] pnp 00:03: [mem 0xfed00000-0xfed003ff]
> [    0.238615] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.238626] pnp 00:04: [io  0x0000-0x000f]
> [    0.238629] pnp 00:04: [io  0x0080-0x008f]
> [    0.238632] pnp 00:04: [io  0x00c0-0x00df]
> [    0.238635] pnp 00:04: [dma 4]
> [    0.238667] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.238676] pnp 00:05: [io  0x0061]
> [    0.238708] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
> [    0.238719] pnp 00:06: [io  0x00f0]
> [    0.238727] pnp 00:06: [irq 13]
> [    0.238762] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.238773] pnp 00:07: [io  0x0070-0x0071]
> [    0.238779] pnp 00:07: [irq 8]
> [    0.238816] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.238827] pnp 00:08: [io  0x0060]
> [    0.238829] pnp 00:08: [io  0x0064]
> [    0.238835] pnp 00:08: [irq 1]
> [    0.238869] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.238882] pnp 00:09: [irq 12]
> [    0.238919] pnp 00:09: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (active)
> [    0.239100] pnp 00:0a: Plug and Play ACPI device, IDs IBM0071 PNP0511 (disabled)
> [    0.239129] pnp 00:0b: [mem 0xfed40000-0xfed40fff]
> [    0.239166] pnp 00:0b: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
> [    0.239696] pnp: PnP ACPI: found 12 devices
> [    0.239698] ACPI: ACPI bus type pnp unregistered
> [    0.239701] PnPBIOS: Disabled by ACPI PNP
> [    0.239907] Switched to NOHz mode on CPU #0
> [    0.239968] Switched to NOHz mode on CPU #1
> [    0.276401] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0000000-0xc01fffff 64bit pref]
> [    0.276406] pci 0000:00:1c.0: BAR 13: assigned [io  0xd000-0xdfff]
> [    0.276410] pci 0000:01:00.0: BAR 6: assigned [mem 0xee020000-0xee03ffff pref]
> [    0.276413] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> [    0.276416] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
> [    0.276421] pci 0000:00:01.0:   bridge window [mem 0xee000000-0xee0fffff]
> [    0.276426] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
> [    0.276431] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
> [    0.276435] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
> [    0.276442] pci 0000:00:1c.0:   bridge window [mem 0xee100000-0xee1fffff]
> [    0.276448] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
> [    0.276456] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
> [    0.276460] pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
> [    0.276467] pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
> [    0.276473] pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
> [    0.276481] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
> [    0.276485] pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
> [    0.276492] pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
> [    0.276498] pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
> [    0.276506] pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
> [    0.276510] pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
> [    0.276517] pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
> [    0.276523] pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
> [    0.276533] pci 0000:15:00.0: BAR 15: assigned [mem 0xe0000000-0xe3ffffff pref]
> [    0.276538] pci 0000:15:00.0: BAR 16: assigned [mem 0xc4000000-0xc7ffffff]
> [    0.276542] pci 0000:15:00.0: BAR 13: assigned [io  0x9000-0x90ff]
> [    0.276545] pci 0000:15:00.0: BAR 14: assigned [io  0x9400-0x94ff]
> [    0.276547] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
> [    0.276550] pci 0000:15:00.0:   bridge window [io  0x9000-0x90ff]
> [    0.276556] pci 0000:15:00.0:   bridge window [io  0x9400-0x94ff]
> [    0.276563] pci 0000:15:00.0:   bridge window [mem 0xe0000000-0xe3ffffff pref]
> [    0.276569] pci 0000:15:00.0:   bridge window [mem 0xc4000000-0xc7ffffff]
> [    0.276576] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
> [    0.276580] pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
> [    0.276587] pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
> [    0.276592] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
> [    0.276608] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.276613] pci 0000:00:01.0: setting latency timer to 64
> [    0.276622] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [    0.276627] pci 0000:00:1c.0: setting latency timer to 64
> [    0.276637] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [    0.276642] pci 0000:00:1c.1: setting latency timer to 64
> [    0.276652] pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> [    0.276657] pci 0000:00:1c.2: setting latency timer to 64
> [    0.276667] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
> [    0.276672] pci 0000:00:1c.3: setting latency timer to 64
> [    0.276678] pci 0000:00:1e.0: enabling device (0005 -> 0007)
> [    0.276685] pci 0000:00:1e.0: setting latency timer to 64
> [    0.276694] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.276702] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.276705] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.276708] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.276711] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
> [    0.276714] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
> [    0.276717] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
> [    0.276720] pci_bus 0000:00: resource 10 [mem 0xfed40000-0xfed40fff]
> [    0.276722] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
> [    0.276725] pci_bus 0000:01: resource 1 [mem 0xee000000-0xee0fffff]
> [    0.276728] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
> [    0.276731] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
> [    0.276734] pci_bus 0000:02: resource 1 [mem 0xee100000-0xee1fffff]
> [    0.276737] pci_bus 0000:02: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
> [    0.276740] pci_bus 0000:03: resource 0 [io  0x3000-0x4fff]
> [    0.276742] pci_bus 0000:03: resource 1 [mem 0xec000000-0xedffffff]
> [    0.276745] pci_bus 0000:03: resource 2 [mem 0xe4000000-0xe40fffff 64bit pref]
> [    0.276748] pci_bus 0000:04: resource 0 [io  0x5000-0x6fff]
> [    0.276751] pci_bus 0000:04: resource 1 [mem 0xe8000000-0xe9ffffff]
> [    0.276754] pci_bus 0000:04: resource 2 [mem 0xe4100000-0xe41fffff 64bit pref]
> [    0.276757] pci_bus 0000:0c: resource 0 [io  0x7000-0x8fff]
> [    0.276760] pci_bus 0000:0c: resource 1 [mem 0xea000000-0xebffffff]
> [    0.276763] pci_bus 0000:0c: resource 2 [mem 0xe4200000-0xe42fffff 64bit pref]
> [    0.276766] pci_bus 0000:15: resource 0 [io  0x9000-0xcfff]
> [    0.276768] pci_bus 0000:15: resource 1 [mem 0xe4300000-0xe7ffffff]
> [    0.276771] pci_bus 0000:15: resource 2 [mem 0xe0000000-0xe3ffffff 64bit pref]
> [    0.276774] pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
> [    0.276777] pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
> [    0.276780] pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.276782] pci_bus 0000:15: resource 7 [mem 0x000d4000-0x000d7fff]
> [    0.276785] pci_bus 0000:15: resource 8 [mem 0x000d8000-0x000dbfff]
> [    0.276788] pci_bus 0000:15: resource 9 [mem 0xc0000000-0xfebfffff]
> [    0.276791] pci_bus 0000:15: resource 10 [mem 0xfed40000-0xfed40fff]
> [    0.276794] pci_bus 0000:16: resource 0 [io  0x9000-0x90ff]
> [    0.276796] pci_bus 0000:16: resource 1 [io  0x9400-0x94ff]
> [    0.276799] pci_bus 0000:16: resource 2 [mem 0xe0000000-0xe3ffffff pref]
> [    0.276802] pci_bus 0000:16: resource 3 [mem 0xc4000000-0xc7ffffff]
> [    0.276868] NET: Registered protocol family 2
> [    0.276956] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.277206] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.277602] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.277798] TCP: Hash tables configured (established 131072 bind 65536)
> [    0.277801] TCP reno registered
> [    0.277804] UDP hash table entries: 512 (order: 2, 16384 bytes)
> [    0.277813] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> [    0.278016] NET: Registered protocol family 1
> [    0.278153] pci 0000:01:00.0: Boot video device
> [    0.278172] PCI: CLS mismatch (64 != 32), using 64 bytes
> [    0.278221] Unpacking initramfs...
> [    0.609728] Freeing initrd memory: 11968k freed
> [    0.616222] Simple Boot Flag at 0x35 set to 0x1
> [    0.616667] audit: initializing netlink socket (disabled)
> [    0.616682] type=2000 audit(1301631363.612:1): initialized
> [    0.623581] highmem bounce pool size: 64 pages
> [    0.623586] HugeTLB registered 4 MB page size, pre-allocated 0 pages
> [    0.625823] VFS: Disk quotas dquot_6.5.2
> [    0.625968] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    0.626129] msgmni has been set to 1715
> [    0.626425] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    0.626429] io scheduler noop registered
> [    0.626431] io scheduler deadline registered
> [    0.626444] io scheduler cfq registered (default)
> [    0.626535] pcieport 0000:00:01.0: setting latency timer to 64
> [    0.626570] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
> [    0.626627] pcieport 0000:00:1c.0: setting latency timer to 64
> [    0.626680] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
> [    0.626763] pcieport 0000:00:1c.1: setting latency timer to 64
> [    0.626816] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
> [    0.626902] pcieport 0000:00:1c.2: setting latency timer to 64
> [    0.626955] pcieport 0000:00:1c.2: irq 43 for MSI/MSI-X
> [    0.627038] pcieport 0000:00:1c.3: setting latency timer to 64
> [    0.627091] pcieport 0000:00:1c.3: irq 44 for MSI/MSI-X
> [    0.627290] intel_idle: MWAIT substates: 0x22220
> [    0.627292] intel_idle: does not run on family 6 model 15
> [    0.627323] isapnp: Scanning for PnP cards...
> [    0.981585] isapnp: No Plug & Play device found
> [    0.981645] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.984449] Linux agpgart interface v0.103
> [    0.984799] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    0.991596] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.991603] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    0.991738] mousedev: PS/2 mouse device common for all mice
> [    0.991797] rtc_cmos 00:07: RTC can wake from S4
> [    0.991868] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
> [    0.991900] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    0.991913] cpuidle: using governor ladder
> [    0.991915] cpuidle: using governor menu
> [    0.992176] TCP cubic registered
> [    0.992339] NET: Registered protocol family 10
> [    0.993043] Mobile IPv6
> [    0.993047] NET: Registered protocol family 17
> [    0.993052] Registering the dns_resolver key type
> [    0.993067] Using IPI No-Shortcut mode
> [    0.993159] PM: Hibernation image not present or could not be loaded.
> [    0.993174] registered taskstats version 1
> [    0.993703] rtc_cmos 00:07: setting system clock to 2011-04-01 04:16:04 UTC (1301631364)
> [    0.993743] Initalizing network drop monitor service
> [    0.993821] Freeing unused kernel memory: 356k freed
> [    0.994011] Write protecting the kernel text: 2584k
> [    0.994035] Write protecting the kernel read-only data: 940k
> [    0.996311] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> [    1.049311] udev[52]: starting version 166
> [    1.101142] usbcore: registered new interface driver usbfs
> [    1.101168] usbcore: registered new interface driver hub
> [    1.106856] usbcore: registered new device driver usb
> [    1.110471] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    1.110508] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [    1.110514] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [    1.110533] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [    1.110555] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    1.110559] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    1.110605] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
> [    1.144190] ehci_hcd 0000:00:1d.7: using broken periodic workaround
> [    1.144206] ehci_hcd 0000:00:1d.7: debug port 1
> [    1.148095] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
> [    1.181638] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee404000
> [    1.196074] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    1.196130] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.196133] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.196136] usb usb1: Product: EHCI Host Controller
> [    1.196139] usb usb1: Manufacturer: Linux 2.6.38 ehci_hcd
> [    1.196141] usb usb1: SerialNumber: 0000:00:1d.7
> [    1.196278] hub 1-0:1.0: USB hub found
> [    1.196283] hub 1-0:1.0: 8 ports detected
> [    1.204551] thermal LNXTHERM:00: registered as thermal_zone0
> [    1.204554] ACPI: Thermal Zone [THM0] (29 C)
> [    1.205486] thermal LNXTHERM:01: registered as thermal_zone1
> [    1.205489] ACPI: Thermal Zone [THM1] (34 C)
> [    1.209242] tg3.c:v3.116 (December 3, 2010)
> [    1.209257] tg3 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    1.209268] tg3 0000:02:00.0: setting latency timer to 64
> [    1.249426] uhci_hcd: USB Universal Host Controller Interface driver
> [    1.249497] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [    1.249502] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [    1.249509] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    1.249519] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    1.249524] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    1.249534] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    1.249633] SCSI subsystem initialized
> [    1.250270] sdhci: Secure Digital Host Controller Interface driver
> [    1.250272] sdhci: Copyright(c) Pierre Ossman
> [    1.256151] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
> [    1.256193] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.256196] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.256199] usb usb2: Product: UHCI Host Controller
> [    1.256201] usb usb2: Manufacturer: Linux 2.6.38 uhci_hcd
> [    1.256204] usb usb2: SerialNumber: 0000:00:1d.0
> [    1.256323] hub 2-0:1.0: USB hub found
> [    1.256328] hub 2-0:1.0: 2 ports detected
> [    1.256412] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [    1.256416] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [    1.256427] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    1.256435] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    1.256439] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    1.256447] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> [    1.257043] firewire_ohci 0000:15:00.1: enabling device (0000 -> 0002)
> [    1.257051] firewire_ohci 0000:15:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    1.257060] firewire_ohci 0000:15:00.1: setting latency timer to 64
> [    1.281245] libata version 3.00 loaded.
> [    1.282214] tg3 0000:02:00.0: eth0: Tigon3 [partno(BCM95752m) rev 6002] (PCI Express) MAC address 00:1b:24:0b:8b:3e
> [    1.282219] tg3 0000:02:00.0: eth0: attached PHY is 5752 (10/100/1000Base-T Ethernet) (WireSpeed[1])
> [    1.282223] tg3 0000:02:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
> [    1.282226] tg3 0000:02:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
> [    1.284072] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001820
> [    1.284116] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.284119] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.284122] usb usb3: Product: UHCI Host Controller
> [    1.284124] usb usb3: Manufacturer: Linux 2.6.38 uhci_hcd
> [    1.284127] usb usb3: SerialNumber: 0000:00:1d.1
> [    1.284247] hub 3-0:1.0: USB hub found
> [    1.284252] hub 3-0:1.0: 2 ports detected
> [    1.284342] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    1.284351] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    1.284354] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    1.284363] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> [    1.300059] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
> [    1.300097] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.300100] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.300103] usb usb4: Product: UHCI Host Controller
> [    1.300105] usb usb4: Manufacturer: Linux 2.6.38 uhci_hcd
> [    1.300107] usb usb4: SerialNumber: 0000:00:1d.2
> [    1.300225] hub 4-0:1.0: USB hub found
> [    1.300230] hub 4-0:1.0: 2 ports detected
> [    1.300316] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [    1.300324] uhci_hcd 0000:00:1d.3: setting latency timer to 64
> [    1.300328] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> [    1.300336] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
> [    1.312060] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
> [    1.312107] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.312110] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.312114] firewire_ohci: Added fw-ohci device 0000:15:00.1, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x2
> [    1.312118] usb usb5: Product: UHCI Host Controller
> [    1.312120] usb usb5: Manufacturer: Linux 2.6.38 uhci_hcd
> [    1.312123] usb usb5: SerialNumber: 0000:00:1d.3
> [    1.312189] sdhci-pci 0000:15:00.3: SDHCI controller found [104c:803c] (rev 0)
> [    1.312203] sdhci-pci 0000:15:00.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    1.312232] hub 5-0:1.0: USB hub found
> [    1.312235] sdhci-pci 0000:15:00.3: setting latency timer to 64
> [    1.312238] hub 5-0:1.0: 2 ports detected
> [    1.312246] mmc0: no vmmc regulator found
> [    1.312290] Registered led device: mmc0::
> [    1.312360] ata_piix 0000:00:1f.2: version 2.13
> [    1.312372] ata_piix 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
> [    1.312379] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
> [    1.312846] mmc0: SDHCI controller on PCI [0000:15:00.3] using DMA
> [    1.468029] ata_piix 0000:00:1f.2: setting latency timer to 64
> [    1.468425] scsi0 : ata_piix
> [    1.468532] scsi1 : ata_piix
> [    1.469058] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x18b0 irq 14
> [    1.469061] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x18b8 irq 15
> [    1.632577] ata2.00: ATAPI: HL-DT-ST DVDRAM GMA-4082N, CX08, max UDMA/33
> [    1.632727] ata1.00: ATA-8: HITACHI HTS725032A9A364, PC3ZC70F, max UDMA/100
> [    1.632731] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    1.648408] ata2.00: configured for UDMA/33
> [    1.648679] ata1.00: configured for UDMA/100
> [    1.648828] scsi 0:0:0:0: Direct-Access     ATA      HITACHI HTS72503 PC3Z PQ: 0 ANSI: 5
> [    1.654256] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GMA-4082N CX08 PQ: 0 ANSI: 5
> [    1.672419] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
> [    1.672477] sd 0:0:0:0: [sda] Write Protect is off
> [    1.672481] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.672506] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.673595] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> [    1.673598] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    1.673709] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    1.729102]  sda: sda1 sda2 sda3 < sda5 >
> [    1.729483] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.737018] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    1.737146] sr 1:0:0:0: Attached scsi generic sg1 type 5
> [    1.812098] firewire_core: created device fw0: GUID 00061b0020272abd, S400
> [    1.860020] usb 4-1: new full speed USB device using uhci_hcd and address 2
> [    2.030094] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2110
> [    2.030098] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    2.030101] usb 4-1: Product: BCM2045B
> [    2.030103] usb 4-1: Manufacturer: Broadcom Corp
> [    2.053282] device-mapper: uevent: version 1.0.3
> [    2.053509] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
> [    2.265007] PM: Starting manual resume from disk
> [    2.265011] PM: Hibernation image partition 8:2 present
> [    2.265013] PM: Looking for hibernation image.
> [    2.265178] PM: Image not found (code -22)
> [    2.265180] PM: Hibernation image not present or could not be loaded.
> [    2.272022] usb 4-2: new full speed USB device using uhci_hcd and address 3
> [    2.338047] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> [    2.446097] usb 4-2: New USB device found, idVendor=0483, idProduct=2016
> [    2.446100] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    2.446104] usb 4-2: Product: Biometric Coprocessor
> [    2.446106] usb 4-2: Manufacturer: STMicroelectronics
> [    4.046558] udev[343]: starting version 166
> [    4.365502] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
> [    4.369103] acpi device:03: registered as cooling_device0
> [    4.369220] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/LNXVIDEO:00/input/input2
> [    4.369226] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> [    4.375600] Non-volatile memory driver v1.3
> [    4.388029] ACPI: Lid Switch [LID]
> [    4.388101] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
> [    4.389753] tpm_tis 00:0b: 1.2 TPM (device-id 0x3202, rev-id 5)
> [    4.416018] ACPI: Sleep Button [SLPB]
> [    4.416098] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
> [    4.416103] ACPI: Power Button [PWRF]
> [    4.436527] ACPI: AC Adapter [AC] (on-line)
> [    4.441595] ACPI: acpi_idle registered with cpuidle
> [    4.452064] Monitor-Mwait will be used to enter C-1 state
> [    4.452376] Monitor-Mwait will be used to enter C-2 state
> [    4.452402] Monitor-Mwait will be used to enter C-3 state
> [    4.456403] ACPI: Battery Slot [BAT0] (battery present)
> [    4.477653] intel_rng: FWH not detected
> [    4.870620] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:2028]
> [    4.870645] yenta_cardbus 0000:15:00.0: Using INTVAL to route CSC interrupts to PCI
> [    4.870648] yenta_cardbus 0000:15:00.0: Routing CardBus interrupts to ISA
> [    4.870655] yenta_cardbus 0000:15:00.0: TI: mfunc 0x01db1b22, devctl 0x64
> [    4.879386] input: PC Speaker as /devices/platform/pcspkr/input/input5
> [    5.035425] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    5.101023] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cf8, PCI irq 16
> [    5.101028] yenta_cardbus 0000:15:00.0: Socket status: 30000086
> [    5.101034] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x9000-0xcfff]
> [    5.101038] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x9000-0xcfff: excluding 0x9000-0x90ff 0x9400-0x94ff
> [    5.150797] NET: Registered protocol family 23
> [    5.163582] Bluetooth: Core ver 2.15
> [    5.163602] NET: Registered protocol family 31
> [    5.163604] Bluetooth: HCI device and connection manager initialized
> [    5.163607] Bluetooth: HCI socket layer initialized
> [    5.174668] cfg80211: Calling CRDA to update world regulatory domain
> [    5.175498] 
> [    5.175503] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe4300000-0xe7ffffff]
> [    5.175508] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe4300000-0xe7ffffff: excluding 0xe4300000-0xe46cffff
> [    5.175525] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe0000000-0xe3ffffff 64bit pref]
> [    5.175528] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe0000000-0xe3ffffff: excluding 0xe0000000-0xe3ffffff
> [    5.223546] Bluetooth: Generic Bluetooth USB driver ver 0.6
> [    5.224031] usbcore: registered new interface driver btusb
> [    5.293314] tifm_7xx1 0000:15:00.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    5.293322] tifm_7xx1 0000:15:00.2: setting latency timer to 64
> [    5.387993] thinkpad_acpi: ThinkPad ACPI Extras v0.24
> [    5.387995] thinkpad_acpi: http://ibm-acpi.sf.net/
> [    5.388017] thinkpad_acpi: ThinkPad BIOS 7FETA9WW (2.27 ), EC 7FHT26WW-1.08
> [    5.388019] thinkpad_acpi: Lenovo ThinkPad Z61p, model 9452JRU
> [    5.388450] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
> [    5.388795] thinkpad_acpi: radio switch found; radios are enabled
> [    5.393956] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
> [    5.394541] Registered led device: tpacpi::thinklight
> [    5.394578] Registered led device: tpacpi::power
> [    5.394602] Registered led device: tpacpi::standby
> [    5.394631] Registered led device: tpacpi::thinkvantage
> [    5.396874] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
> [    5.397188] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
> [    5.398867] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
> [    5.413021] nsc-ircc 00:0a: [io  0x02f8-0x02ff]
> [    5.413106] nsc-ircc 00:0a: [irq 3]
> [    5.413109] nsc-ircc 00:0a: [dma 1]
> [    5.413496] nsc-ircc 00:0a: activated
> [    5.413532] nsc-ircc, chip->init
> [    5.413546] nsc-ircc, Found chip at base=0x164e
> [    5.413589] nsc-ircc, driver loaded (Dag Brattli)
> [    5.414323] IrDA: Registered device irda0
> [    5.414326] nsc-ircc, Using dongle: IBM31T1100 or Temic TFDS6000/TFDS6500
> [    5.483312] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
> [    5.483315] iwl3945: Copyright(c) 2003-2010 Intel Corporation
> [    5.483375] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    5.483390] iwl3945 0000:03:00.0: setting latency timer to 64
> [    5.536723] iwl3945 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
> [    5.536726] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
> [    5.536870] iwl3945 0000:03:00.0: irq 45 for MSI/MSI-X
> [    5.600183] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000/0x0
> [    5.600193] serio: Synaptics pass-through port at isa0060/serio1/input0
> [    5.641164] ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
> [    5.641981] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
> [    5.822442] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    5.822447] hda_intel: probe_mask set to 0x1 for device 17aa:2010
> [    5.822515] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
> [    5.822546] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [    5.977643] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
> [    7.182097] Adding 3906556k swap on /dev/sda2.  Priority:-1 extents:1 across:3906556k 
> [    7.186353] EXT4-fs (sda1): re-mounted. Opts: (null)
> [    7.457538] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
> [    7.667786] loop: module loaded
> [    8.061613] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
> [    8.517841] NET: Registered protocol family 8
> [    8.517843] NET: Registered protocol family 20
> [    8.926729] fuse init (API version 7.16)
> [    9.622294] NET: Registered protocol family 15
> [    9.717345] padlock_sha: VIA PadLock Hash Engine not detected.
> [    9.735594] padlock_sha: VIA PadLock Hash Engine not detected.
> [    9.827376] padlock_aes: VIA PadLock not detected.
> [   10.721919] vboxdrv: Found 2 processor cores.
> [   10.722017] vboxdrv: fAsync=1 offMin=0x9687c offMax=0x9687c
> [   10.722081] vboxdrv: TSC mode is 'asynchronous', kernel timer mode is 'normal'.
> [   10.722083] vboxdrv: Successfully loaded version 4.0.2_OSE (interface 0x00160000).
> [   10.937504] Initializing XFRM netlink socket
> [   11.313011] IBM TrackPoint firmware: 0x0e, buttons: 3/3
> [   11.529823] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input9
> [   13.192122] tg3 0000:02:00.0: irq 47 for MSI/MSI-X
> [   13.225490] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   13.534632] iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
> [   13.611020] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   15.250148] pci 0000:01:00.0: power state changed by ACPI to D0
> [   15.250154] pci 0000:01:00.0: power state changed by ACPI to D0
> [   15.250163] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   15.349832] [drm] Initialized drm 1.1.0 20060810
> [   15.446942] [drm] radeon kernel modesetting enabled.
> [   15.446994] radeon 0000:01:00.0: setting latency timer to 64
> [   15.448339] [drm] initializing kernel modesetting (RV530 0x1002:0x71C4).
> [   15.448369] [drm] register mmio base: 0xEE000000
> [   15.448371] [drm] register mmio size: 65536
> [   15.448655] ATOM BIOS: Lenovo
> [   15.448679] [drm] Generation 2 PCI interface, using max accessible memory
> [   15.448685] radeon 0000:01:00.0: VRAM: 256M 0x0000000000000000 - 0x000000000FFFFFFF (256M used)
> [   15.448689] radeon 0000:01:00.0: GTT: 512M 0x0000000010000000 - 0x000000002FFFFFFF
> [   15.448710] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [   15.448712] [drm] Driver supports precise vblank timestamp query.
> [   15.448749] radeon 0000:01:00.0: irq 48 for MSI/MSI-X
> [   15.448756] radeon 0000:01:00.0: radeon: using MSI.
> [   15.448781] [drm] radeon: irq initialized.
> [   15.450012] [drm] Detected VRAM RAM=256M, BAR=256M
> [   15.450016] [drm] RAM width 128bits DDR
> [   15.450153] [TTM] Zone  kernel: Available graphics memory: 439412 kiB.
> [   15.450156] [TTM] Zone highmem: Available graphics memory: 1557016 kiB.
> [   15.450158] [TTM] Initializing pool allocator.
> [   15.450180] [drm] radeon: 256M of VRAM memory ready
> [   15.450182] [drm] radeon: 512M of GTT memory ready.
> [   15.450204] [drm] GART: num cpu pages 131072, num gpu pages 131072
> [   15.451680] [drm] radeon: 1 quad pipes, 2 z pipes initialized.
> [   15.453016] [drm] PCIE GART of 512M enabled (table at 0x00040000).
> [   15.453045] radeon 0000:01:00.0: WB enabled
> [   15.453219] [drm] Loading R500 Microcode
> [   15.510361] [drm] radeon: ring at 0x0000000010001000
> [   15.510399] [drm] ring test succeeded in 11 usecs
> [   15.510551] [drm] radeon: ib pool ready.
> [   15.510931] [drm] ib test succeeded in 0 usecs
> [   15.511145] [drm:radeon_atombios_get_lvds_info] *ERROR* Bad LCD record 0
> [   15.511290] [drm] Radeon Display Connectors
> [   15.511293] [drm] Connector 0:
> [   15.511294] [drm]   VGA
> [   15.511297] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
> [   15.511299] [drm]   Encoders:
> [   15.511301] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
> [   15.511303] [drm] Connector 1:
> [   15.511304] [drm]   LVDS
> [   15.511307] [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68 0x7e6c 0x7e6c
> [   15.511309] [drm]   Encoders:
> [   15.511310] [drm]     LCD1: INTERNAL_LVTM1
> [   15.511312] [drm] Connector 2:
> [   15.511313] [drm]   S-video
> [   15.511315] [drm]   Encoders:
> [   15.511316] [drm]     TV1: INTERNAL_KLDSCP_DAC2
> [   15.511318] [drm] Connector 3:
> [   15.511320] [drm]   DVI-I
> [   15.511321] [drm]   HPD1
> [   15.511323] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
> [   15.511325] [drm]   Encoders:
> [   15.511327] [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
> [   15.518581] Bluetooth: L2CAP ver 2.15
> [   15.518583] Bluetooth: L2CAP socket layer initialized
> [   15.566724] Bluetooth: RFCOMM TTY layer initialized
> [   15.566729] Bluetooth: RFCOMM socket layer initialized
> [   15.566731] Bluetooth: RFCOMM ver 1.11
> [   15.566800] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   15.566802] Bluetooth: BNEP filters: protocol multicast
> [   15.570396] [drm] radeon: power management initialized
> [   15.576278] Bluetooth: SCO (Voice Link) ver 0.6
> [   15.576281] Bluetooth: SCO socket layer initialized
> [   15.949639] [drm] fb mappable at 0xD00C0000
> [   15.949642] [drm] vram apper at 0xD0000000
> [   15.949644] [drm] size 9216000
> [   15.949646] [drm] fb depth is 24
> [   15.949647] [drm]    pitch is 7680
> [   15.950711] Console: switching to colour frame buffer device 240x75
> [   15.950718] fb0: radeondrmfb frame buffer device
> [   15.950720] drm: registered panic notifier
> [   15.950728] [drm] Initialized radeon 2.8.0 20080528 for 0000:01:00.0 on minor 0
> [   18.823091] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   19.705363] sshd (2223): /proc/2223/oom_adj is deprecated, please use /proc/2223/oom_score_adj instead.
> [   25.660237] wlan0: authenticate with 00:25:9c:1d:a3:bd (try 1)
> [   25.662048] wlan0: authenticated
> [   25.663169] wlan0: associate with 00:25:9c:1d:a3:bd (try 1)
> [   25.666047] wlan0: RX AssocResp from 00:25:9c:1d:a3:bd (capab=0x411 status=0 aid=1)
> [   25.666054] wlan0: associated
> [   25.667769] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   35.880038] wlan0: no IPv6 routers present
> [   52.822705] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
> [   53.525981] EXT4-fs (sda5): re-mounted. Opts: commit=0
> [  148.576068] CE: hpet increased min_delta_ns to 20113 nsec
> [ 3443.192568] tg3 0000:02:00.0: PME# enabled
> [ 3443.192592] pcieport 0000:00:1c.0: wake-up capability enabled by ACPI
> [ 3443.413572] wlan0: deauthenticating from 00:25:9c:1d:a3:bd by local choice (reason=3)
> [ 3443.444136] cfg80211: Calling CRDA to update world regulatory domain
> [ 3445.443102] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
> [ 3445.446127] EXT4-fs (sda5): re-mounted. Opts: commit=0
> [ 3445.632116] usb 4-1: USB disconnect, address 2
> [ 3445.633133] btusb_intr_complete: hci0 urb ee50e900 failed to resubmit (19)
> [ 3445.633150] btusb_bulk_complete: hci0 urb ee50e400 failed to resubmit (19)
> [ 3445.634133] btusb_bulk_complete: hci0 urb ee50e180 failed to resubmit (19)
> [ 3445.634180] btusb_send_frame: hci0 urb f346bf80 submission failed
> [ 3446.227322] PM: Syncing filesystems ... done.
> [ 3446.237268] PM: Preparing system for mem sleep
> [ 3447.084384] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [ 3447.100070] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [ 3447.116080] PM: Entering mem sleep
> [ 3447.116109] Suspending console(s) (use no_console_suspend to debug)
> [ 3447.266338] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [ 3447.266541] sd 0:0:0:0: [sda] Stopping disk
> [ 3447.360285] nsc-ircc 00:0a: disabled
> [ 3447.360427] ACPI handle has no context!
> [ 3447.360440] tifm_7xx1 0000:15:00.2: PCI INT A disabled
> [ 3447.360442] ACPI handle has no context!
> [ 3447.360451] ACPI handle has no context!
> [ 3447.360455] sdhci-pci 0000:15:00.3: PCI INT A disabled
> [ 3447.360463] ACPI handle has no context!
> [ 3447.360525] ACPI handle has no context!
> [ 3447.360641] ehci_hcd 0000:00:1d.7: PCI INT D disabled
> [ 3447.360644] uhci_hcd 0000:00:1d.3: PCI INT D disabled
> [ 3447.360654] uhci_hcd 0000:00:1d.2: PCI INT C disabled
> [ 3447.360657] uhci_hcd 0000:00:1d.1: PCI INT B disabled
> [ 3447.360664] uhci_hcd 0000:00:1d.0: PCI INT A disabled
> [ 3447.464089] HDA Intel 0000:00:1b.0: PCI INT B disabled
> [ 3447.704026] radeon 0000:01:00.0: power state changed by ACPI to D3
> [ 3447.731926] ata_piix 0000:00:1f.2: PCI INT B disabled
> [ 3447.744037] PM: suspend of devices complete after 627.517 msecs
> [ 3447.776018] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
> [ 3447.776103] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D3
> [ 3447.796021] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D3
> [ 3447.796051] PM: late suspend of devices complete after 52.009 msecs
> [ 3447.796481] ACPI: Preparing to enter system sleep state S3
> [ 3447.976043] PM: Saving platform NVS memory
> [ 3447.976236] Disabling non-boot CPUs ...
> [ 3448.080036] CPU 1 is now offline
> [ 3448.080411] Extended CMOS year: 2000
> [ 3448.080411] Back to C!
> [ 3448.080411] PM: Restoring platform NVS memory
> [ 3448.080411] Extended CMOS year: 2000
> [ 3448.080411] Enabling non-boot CPUs ...
> [ 3448.080411] Booting Node 0 Processor 1 APIC 0x1
> [ 3447.977633] Initializing CPU#1
> [ 3448.172014] Switched to NOHz mode on CPU #1
> [ 3448.196059] CPU1 is up
> [ 3448.196772] ACPI: Waking up from system sleep state S3
> [ 3448.528109] pcieport 0000:00:01.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
> [ 3448.528166] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
> [ 3448.528207] pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0xc011c001)
> [ 3448.528215] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0xd0d0)
> [ 3448.528228] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
> [ 3448.528300] pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
> [ 3448.528363] pcieport 0000:00:1c.2: restoring config space at offset 0x7 (was 0x20006050, writing 0x6050)
> [ 3448.528376] pcieport 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
> [ 3448.528427] pcieport 0000:00:1c.3: restoring config space at offset 0xf (was 0x40400, writing 0x4040b)
> [ 3448.528440] pcieport 0000:00:1c.3: restoring config space at offset 0x9 (was 0x10001, writing 0xe421e421)
> [ 3448.528446] pcieport 0000:00:1c.3: restoring config space at offset 0x8 (was 0x0, writing 0xebf0ea00)
> [ 3448.528452] pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20000000, writing 0x8070)
> [ 3448.528462] pcieport 0000:00:1c.3: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
> [ 3448.528470] pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100507)
> [ 3448.548022] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 3448.548026] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 3448.548052] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
> [ 3448.548062] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 3448.548065] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 3448.548069] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [ 3448.548073] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [ 3448.548098] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
> [ 3448.548107] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [ 3448.548110] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [ 3448.548137] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
> [ 3448.548169] uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
> [ 3448.548212] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
> [ 3448.548228] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [ 3448.548233] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [ 3448.548267] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100005, writing 0x100007)
> [ 3448.548356] ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00005, writing 0x2b80005)
> [ 3448.548436] radeon 0000:01:00.0: restoring config space at offset 0x1 (was 0x100103, writing 0x100507)
> [ 3448.548495] tg3 0000:02:00.0: restoring config space at offset 0xc (was 0x0, writing 0x2a000000)
> [ 3448.548729] iwl3945 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
> [ 3448.548927] firewire_ohci 0000:15:00.1: restoring config space at offset 0xf (was 0x4020200, writing 0x402020b)
> [ 3448.548952] firewire_ohci 0000:15:00.1: restoring config space at offset 0x5 (was 0x0, writing 0xe4304000)
> [ 3448.548959] firewire_ohci 0000:15:00.1: restoring config space at offset 0x4 (was 0x0, writing 0xe4302000)
> [ 3448.548966] firewire_ohci 0000:15:00.1: restoring config space at offset 0x3 (was 0x800000, writing 0x804000)
> [ 3448.548975] firewire_ohci 0000:15:00.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
> [ 3448.549002] tifm_7xx1 0000:15:00.2: restoring config space at offset 0xf (was 0x40701ff, writing 0x407010b)
> [ 3448.549029] tifm_7xx1 0000:15:00.2: restoring config space at offset 0x4 (was 0x0, writing 0xe4301000)
> [ 3448.549036] tifm_7xx1 0000:15:00.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804000)
> [ 3448.549044] tifm_7xx1 0000:15:00.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
> [ 3448.549072] sdhci-pci 0000:15:00.3: restoring config space at offset 0xf (was 0x40701ff, writing 0x407010b)
> [ 3448.549098] sdhci-pci 0000:15:00.3: restoring config space at offset 0x4 (was 0x0, writing 0xe4302800)
> [ 3448.549105] sdhci-pci 0000:15:00.3: restoring config space at offset 0x3 (was 0x800000, writing 0x804000)
> [ 3448.549114] sdhci-pci 0000:15:00.3: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
> [ 3448.549402] PM: early resume of devices complete after 21.366 msecs
> [ 3448.549499] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [ 3448.549507] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [ 3448.549552] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
> [ 3448.549586] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 3448.549589] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 3448.549598] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 3448.549607] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [ 3448.549622] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [ 3448.549653] usb usb2: root hub lost power or was reset
> [ 3448.549674] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [ 3448.549678] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [ 3448.549684] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [ 3448.549686] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [ 3448.549694] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [ 3448.549725] usb usb4: root hub lost power or was reset
> [ 3448.549729] usb usb3: root hub lost power or was reset
> [ 3448.549742] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [ 3448.549747] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [ 3448.549750] uhci_hcd 0000:00:1d.3: setting latency timer to 64
> [ 3448.549754] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [ 3448.549764] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [ 3448.549775] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [ 3448.549783] usb usb5: root hub lost power or was reset
> [ 3448.549802] pci 0000:00:1e.0: setting latency timer to 64
> [ 3448.549816] ata_piix 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
> [ 3448.549826] ata_piix 0000:00:1f.2: setting latency timer to 64
> [ 3448.549852] radeon 0000:01:00.0: power state changed by ACPI to D0
> [ 3448.549857] radeon 0000:01:00.0: power state changed by ACPI to D0
> [ 3448.549861] pcieport 0000:00:1c.0: wake-up capability disabled by ACPI
> [ 3448.549863] radeon 0000:01:00.0: setting latency timer to 64
> [ 3448.549869] tg3 0000:02:00.0: PME# disabled
> [ 3448.549874] radeon 0000:01:00.0: f6cf4c00 unpin not necessary
> [ 3448.550185] tifm_7xx1 0000:15:00.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 3448.550250] sdhci-pci 0000:15:00.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 3448.551272] sd 0:0:0:0: [sda] Starting disk
> [ 3448.553683] [drm] radeon: 1 quad pipes, 2 z pipes initialized.
> [ 3448.557832] [drm] PCIE GART of 512M enabled (table at 0x00040000).
> [ 3448.557837] radeon 0000:01:00.0: WB enabled
> [ 3448.557923] [drm] radeon: ring at 0x0000000010001000
> [ 3448.557959] [drm] ring test succeeded in 11 usecs
> [ 3448.557971] [drm] ib test succeeded in 0 usecs
> [ 3448.568318] nsc-ircc 00:0a: activated
> [ 3448.604290] firewire_core: skipped bus generations, destroying all nodes
> [ 3448.724453] ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
> [ 3448.724457] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
> [ 3448.725903] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
> [ 3448.726822] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
> [ 3448.748322] ata2.00: configured for UDMA/33
> [ 3448.912061] usb 4-2: reset full speed USB device using uhci_hcd and address 3
> [ 3449.104134] firewire_core: rediscovered device fw0
> [ 3450.972061] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 3450.972069] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [ 3450.972076] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
> [ 3450.972083] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
> [ 3450.972380] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 3450.972387] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [ 3450.996532] ata1.00: configured for UDMA/100
> [ 3451.153834] PM: resume of devices complete after 2604.355 msecs
> [ 3451.154009] PM: Finishing wakeup.
> [ 3451.154011] Restarting tasks ... done.
> [ 3451.163364] video LNXVIDEO:00: Restoring backlight state
> [ 3451.199605] tg3 0000:02:00.0: irq 47 for MSI/MSI-X
> [ 3451.248614] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [ 3451.335556] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [ 3451.747769] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
> [ 3451.751389] EXT4-fs (sda5): re-mounted. Opts: commit=0
> [ 3452.072101] usb 4-1: new full speed USB device using uhci_hcd and address 4
> [ 3452.241725] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2110
> [ 3452.241729] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [ 3452.241732] usb 4-1: Product: BCM2045B
> [ 3452.241734] usb 4-1: Manufacturer: Broadcom Corp
> [ 3463.649712] wlan0: authenticate with 00:25:9c:1d:a3:bd (try 1)
> [ 3463.651539] wlan0: authenticated
> [ 3463.651586] wlan0: associate with 00:25:9c:1d:a3:bd (try 1)
> [ 3463.654529] wlan0: RX AssocResp from 00:25:9c:1d:a3:bd (capab=0x411 status=0 aid=1)
> [ 3463.654533] wlan0: associated
> [ 3463.656196] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [ 3474.304028] wlan0: no IPv6 routers present
> [ 7777.228570] tg3 0000:02:00.0: PME# enabled
> [ 7777.228594] pcieport 0000:00:1c.0: wake-up capability enabled by ACPI
> [ 7777.447587] wlan0: deauthenticating from 00:25:9c:1d:a3:bd by local choice (reason=3)
> [ 7777.464210] cfg80211: Calling CRDA to update world regulatory domain
> [ 7778.468050] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
> [ 7778.471003] EXT4-fs (sda5): re-mounted. Opts: commit=0
> [ 7778.688123] usb 4-1: USB disconnect, address 4
> [ 7778.688556] btusb_intr_complete: hci0 urb ee486a80 failed to resubmit (19)
> [ 7778.688573] btusb_bulk_complete: hci0 urb ee486f00 failed to resubmit (19)
> [ 7778.689557] btusb_bulk_complete: hci0 urb ee486000 failed to resubmit (19)
> [ 7778.689598] btusb_send_frame: hci0 urb f4bef980 submission failed
> [ 7779.323193] PM: Syncing filesystems ... done.
> [ 7779.333320] PM: Preparing system for mem sleep
> [ 7779.793124] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [ 7779.808168] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [ 7779.824079] PM: Entering mem sleep
> [ 7779.824110] Suspending console(s) (use no_console_suspend to debug)
> [ 7779.980227] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [ 7779.980362] sd 0:0:0:0: [sda] Stopping disk
> [ 7780.072285] nsc-ircc 00:0a: disabled
> [ 7780.072427] ACPI handle has no context!
> [ 7780.072440] tifm_7xx1 0000:15:00.2: PCI INT A disabled
> [ 7780.072442] ACPI handle has no context!
> [ 7780.072450] ACPI handle has no context!
> [ 7780.072455] sdhci-pci 0000:15:00.3: PCI INT A disabled
> [ 7780.072463] ACPI handle has no context!
> [ 7780.072525] ACPI handle has no context!
> [ 7780.080164] ehci_hcd 0000:00:1d.7: PCI INT D disabled
> [ 7780.080352] uhci_hcd 0000:00:1d.3: PCI INT D disabled
> [ 7780.080512] uhci_hcd 0000:00:1d.2: PCI INT C disabled
> [ 7780.080731] uhci_hcd 0000:00:1d.1: PCI INT B disabled
> [ 7780.080798] uhci_hcd 0000:00:1d.0: PCI INT A disabled
> [ 7780.081234] HDA Intel 0000:00:1b.0: PCI INT B disabled
> [ 7780.136028] radeon 0000:01:00.0: power state changed by ACPI to D3
> [ 7780.373306] ata_piix 0000:00:1f.2: PCI INT B disabled
> [ 7780.388039] PM: suspend of devices complete after 563.515 msecs
> [ 7780.420019] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
> [ 7780.420104] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D3
> [ 7780.440022] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D3
> [ 7780.440247] PM: late suspend of devices complete after 52.204 msecs
> [ 7780.440676] ACPI: Preparing to enter system sleep state S3
> [ 7780.620044] PM: Saving platform NVS memory
> [ 7780.620239] Disabling non-boot CPUs ...
> [ 7780.724027] CPU 1 is now offline
> [ 7780.724364] Extended CMOS year: 2000
> [ 7780.724364] Back to C!
> [ 7780.724364] PM: Restoring platform NVS memory
> [ 7780.724364] Extended CMOS year: 2000
> [ 7780.724364] Enabling non-boot CPUs ...
> [ 7780.724364] Booting Node 0 Processor 1 APIC 0x1
> [ 7780.621639] Initializing CPU#1
> [ 7780.816015] Switched to NOHz mode on CPU #1
> [ 7780.840062] CPU1 is up
> [ 7780.840778] ACPI: Waking up from system sleep state S3
> [ 7781.000204] Monitor-Mwait will be used to enter C-3 state
> [ 7781.240104] pcieport 0000:00:01.0: restoring config space at offset 0x7 (was 0x2020, writing 0x20002020)
> [ 7781.240112] pcieport 0000:00:01.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
> [ 7781.240169] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
> [ 7781.240209] pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0xc011c001)
> [ 7781.240217] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0xd0d0)
> [ 7781.240230] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
> [ 7781.240302] pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
> [ 7781.240373] pcieport 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
> [ 7781.240424] pcieport 0000:00:1c.3: restoring config space at offset 0xf (was 0x40400, writing 0x4040b)
> [ 7781.240437] pcieport 0000:00:1c.3: restoring config space at offset 0x9 (was 0x10001, writing 0xe421e421)
> [ 7781.240443] pcieport 0000:00:1c.3: restoring config space at offset 0x8 (was 0x0, writing 0xebf0ea00)
> [ 7781.240449] pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20000000, writing 0x20008070)
> [ 7781.240459] pcieport 0000:00:1c.3: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
> [ 7781.240467] pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100507)
> [ 7781.260022] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 7781.260026] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 7781.260053] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
> [ 7781.260062] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 7781.260065] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 7781.260069] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [ 7781.260073] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [ 7781.260099] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
> [ 7781.260107] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [ 7781.260110] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [ 7781.260137] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
> [ 7781.260169] uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
> [ 7781.260211] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
> [ 7781.260228] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [ 7781.260233] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [ 7781.260266] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100005, writing 0x100007)
> [ 7781.260354] ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00005, writing 0x2b80005)
> [ 7781.260433] radeon 0000:01:00.0: restoring config space at offset 0x1 (was 0x100103, writing 0x100507)
> [ 7781.260492] tg3 0000:02:00.0: restoring config space at offset 0xc (was 0x0, writing 0x2a000000)
> [ 7781.260724] iwl3945 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
> [ 7781.260921] firewire_ohci 0000:15:00.1: restoring config space at offset 0xf (was 0x4020200, writing 0x402020b)
> [ 7781.260946] firewire_ohci 0000:15:00.1: restoring config space at offset 0x5 (was 0x0, writing 0xe4304000)
> [ 7781.260953] firewire_ohci 0000:15:00.1: restoring config space at offset 0x4 (was 0x0, writing 0xe4302000)
> [ 7781.260960] firewire_ohci 0000:15:00.1: restoring config space at offset 0x3 (was 0x800000, writing 0x804000)
> [ 7781.260969] firewire_ohci 0000:15:00.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
> [ 7781.260997] tifm_7xx1 0000:15:00.2: restoring config space at offset 0xf (was 0x40701ff, writing 0x407010b)
> [ 7781.261023] tifm_7xx1 0000:15:00.2: restoring config space at offset 0x4 (was 0x0, writing 0xe4301000)
> [ 7781.261030] tifm_7xx1 0000:15:00.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804000)
> [ 7781.261039] tifm_7xx1 0000:15:00.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
> [ 7781.261066] sdhci-pci 0000:15:00.3: restoring config space at offset 0xf (was 0x40701ff, writing 0x407010b)
> [ 7781.261092] sdhci-pci 0000:15:00.3: restoring config space at offset 0x4 (was 0x0, writing 0xe4302800)
> [ 7781.261099] sdhci-pci 0000:15:00.3: restoring config space at offset 0x3 (was 0x800000, writing 0x804000)
> [ 7781.261108] sdhci-pci 0000:15:00.3: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
> [ 7781.261397] PM: early resume of devices complete after 21.361 msecs
> [ 7781.261507] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [ 7781.261515] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [ 7781.261561] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
> [ 7781.261579] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 7781.261582] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [ 7781.261589] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 7781.261595] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [ 7781.261598] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [ 7781.261601] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [ 7781.261608] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [ 7781.261615] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [ 7781.261632] usb usb2: root hub lost power or was reset
> [ 7781.261651] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [ 7781.261654] usb usb3: root hub lost power or was reset
> [ 7781.261659] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [ 7781.261673] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [ 7781.261684] uhci_hcd 0000:00:1d.3: setting latency timer to 64
> [ 7781.261694] usb usb4: root hub lost power or was reset
> [ 7781.261709] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [ 7781.261717] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [ 7781.261720] usb usb5: root hub lost power or was reset
> [ 7781.261724] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [ 7781.261734] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [ 7781.261738] pci 0000:00:1e.0: setting latency timer to 64
> [ 7781.261751] ata_piix 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
> [ 7781.261757] ata_piix 0000:00:1f.2: setting latency timer to 64
> [ 7781.261794] radeon 0000:01:00.0: power state changed by ACPI to D0
> [ 7781.261801] radeon 0000:01:00.0: power state changed by ACPI to D0
> [ 7781.261813] radeon 0000:01:00.0: setting latency timer to 64
> [ 7781.261829] radeon 0000:01:00.0: f6cf4c00 unpin not necessary
> [ 7781.261836] pcieport 0000:00:1c.0: wake-up capability disabled by ACPI
> [ 7781.261843] tg3 0000:02:00.0: PME# disabled
> [ 7781.261886] tifm_7xx1 0000:15:00.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 7781.261909] sdhci-pci 0000:15:00.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [ 7781.262657] sd 0:0:0:0: [sda] Starting disk
> [ 7781.265827] [drm] radeon: 1 quad pipes, 2 z pipes initialized.
> [ 7781.269950] [drm] PCIE GART of 512M enabled (table at 0x00040000).
> [ 7781.269956] radeon 0000:01:00.0: WB enabled
> [ 7781.270035] [drm] radeon: ring at 0x0000000010001000
> [ 7781.270075] [drm] ring test succeeded in 6 usecs
> [ 7781.270090] [drm] ib test succeeded in 0 usecs
> [ 7781.279534] nsc-ircc 00:0a: activated
> [ 7781.318770] firewire_core: skipped bus generations, destroying all nodes
> [ 7781.440451] ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
> [ 7781.440455] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
> [ 7781.441904] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
> [ 7781.442828] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
> [ 7781.480313] ata2.00: configured for UDMA/33
> [ 7781.624062] usb 4-2: reset full speed USB device using uhci_hcd and address 3
> [ 7781.816086] firewire_core: rediscovered device fw0
> [ 7783.635653] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 7783.635661] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [ 7783.635668] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
> [ 7783.635675] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
> [ 7783.635964] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
> [ 7783.635967] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [ 7783.660486] ata1.00: configured for UDMA/100
> [ 7783.817809] PM: resume of devices complete after 2556.343 msecs
> [ 7783.818002] PM: Finishing wakeup.
> [ 7783.818004] Restarting tasks ... done.
> [ 7783.826699] video LNXVIDEO:00: Restoring backlight state
> [ 7783.863488] tg3 0000:02:00.0: irq 47 for MSI/MSI-X
> [ 7783.916465] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [ 7784.003486] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [ 7784.415128] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
> [ 7784.418393] EXT4-fs (sda5): re-mounted. Opts: commit=600
> [ 7784.632029] usb 4-1: new full speed USB device using uhci_hcd and address 5
> [ 7784.801151] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2110
> [ 7784.801155] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [ 7784.801159] usb 4-1: Product: BCM2045B
> [ 7784.801161] usb 4-1: Manufacturer: Broadcom Corp
> [ 7785.215860] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
> [ 7785.218891] EXT4-fs (sda5): re-mounted. Opts: commit=600
> [ 7787.335473] wlan0: authenticate with 00:25:9c:1d:a3:bd (try 1)
> [ 7787.337295] wlan0: authenticated
> [ 7787.337326] wlan0: associate with 00:25:9c:1d:a3:bd (try 1)
> [ 7787.340210] wlan0: RX AssocResp from 00:25:9c:1d:a3:bd (capab=0x411 status=0 aid=1)
> [ 7787.340216] wlan0: associated
> [ 7787.341904] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [ 7798.112033] wlan0: no IPv6 routers present
> [ 7800.883099] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
> [ 7800.886431] EXT4-fs (sda5): re-mounted. Opts: commit=0
> [12538.060563] tg3 0000:02:00.0: PME# enabled
> [12538.060587] pcieport 0000:00:1c.0: wake-up capability enabled by ACPI
> [12538.279833] wlan0: deauthenticating from 00:25:9c:1d:a3:bd by local choice (reason=3)
> [12538.312101] cfg80211: Calling CRDA to update world regulatory domain
> [12539.129502] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
> [12539.132607] EXT4-fs (sda5): re-mounted. Opts: commit=0
> [12539.296123] usb 4-1: USB disconnect, address 5
> [12539.297089] btusb_intr_complete: hci0 urb f6cfe880 failed to resubmit (19)
> [12539.297106] btusb_bulk_complete: hci0 urb f6cfe080 failed to resubmit (19)
> [12539.298091] btusb_bulk_complete: hci0 urb f6cfef00 failed to resubmit (19)
> [12539.298137] btusb_send_frame: hci0 urb ee486300 submission failed
> [12539.885919] PM: Syncing filesystems ... done.
> [12539.896296] PM: Preparing system for mem sleep
> [12540.582935] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [12540.596106] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [12540.612092] PM: Entering mem sleep
> [12540.612128] Suspending console(s) (use no_console_suspend to debug)
> [12540.767584] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [12540.767712] sd 0:0:0:0: [sda] Stopping disk
> [12540.860285] nsc-ircc 00:0a: disabled
> [12540.860427] ACPI handle has no context!
> [12540.860439] tifm_7xx1 0000:15:00.2: PCI INT A disabled
> [12540.860442] ACPI handle has no context!
> [12540.860450] ACPI handle has no context!
> [12540.860454] sdhci-pci 0000:15:00.3: PCI INT A disabled
> [12540.860462] ACPI handle has no context!
> [12540.860525] ACPI handle has no context!
> [12540.868549] ehci_hcd 0000:00:1d.7: PCI INT D disabled
> [12540.868832] uhci_hcd 0000:00:1d.3: PCI INT D disabled
> [12540.868939] uhci_hcd 0000:00:1d.2: PCI INT C disabled
> [12540.869107] uhci_hcd 0000:00:1d.1: PCI INT B disabled
> [12540.869473] uhci_hcd 0000:00:1d.0: PCI INT A disabled
> [12540.870069] HDA Intel 0000:00:1b.0: PCI INT B disabled
> [12540.924027] radeon 0000:01:00.0: power state changed by ACPI to D3
> [12541.165917] ata_piix 0000:00:1f.2: PCI INT B disabled
> [12541.180040] PM: suspend of devices complete after 567.507 msecs
> [12541.212019] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
> [12541.212104] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D3
> [12541.232021] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D3
> [12541.232247] PM: late suspend of devices complete after 52.202 msecs
> [12541.232674] ACPI: Preparing to enter system sleep state S3
> [12541.412043] PM: Saving platform NVS memory
> [12541.412236] Disabling non-boot CPUs ...
> [12541.516025] CPU 1 is now offline
> [12541.516378] Extended CMOS year: 2000
> [12541.516378] Back to C!
> [12541.516378] PM: Restoring platform NVS memory
> [12541.516378] Extended CMOS year: 2000
> [12541.516378] Enabling non-boot CPUs ...
> [12541.516378] Booting Node 0 Processor 1 APIC 0x1
> [12541.413637] Initializing CPU#1
> [12541.608014] Switched to NOHz mode on CPU #1
> [12541.632059] CPU1 is up
> [12541.632779] ACPI: Waking up from system sleep state S3
> [12541.964105] pcieport 0000:00:01.0: restoring config space at offset 0x7 (was 0x2020, writing 0x20002020)
> [12541.964114] pcieport 0000:00:01.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
> [12541.964169] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
> [12541.964210] pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0xc011c001)
> [12541.964218] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0xd0d0)
> [12541.964231] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
> [12541.964303] pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
> [12541.964375] pcieport 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
> [12541.964426] pcieport 0000:00:1c.3: restoring config space at offset 0xf (was 0x40400, writing 0x4040b)
> [12541.964439] pcieport 0000:00:1c.3: restoring config space at offset 0x9 (was 0x10001, writing 0xe421e421)
> [12541.964446] pcieport 0000:00:1c.3: restoring config space at offset 0x8 (was 0x0, writing 0xebf0ea00)
> [12541.964452] pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20000000, writing 0x8070)
> [12541.964462] pcieport 0000:00:1c.3: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
> [12541.964469] pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100507)
> [12541.984022] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [12541.984026] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [12541.984053] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
> [12541.984062] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [12541.984065] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [12541.984070] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [12541.984073] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [12541.984099] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
> [12541.984107] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [12541.984110] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [12541.984138] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
> [12541.984170] uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
> [12541.984212] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
> [12541.984228] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [12541.984234] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [12541.984267] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100005, writing 0x100007)
> [12541.984355] ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00005, writing 0x2b80005)
> [12541.984434] radeon 0000:01:00.0: restoring config space at offset 0x1 (was 0x100103, writing 0x100507)
> [12541.984493] tg3 0000:02:00.0: restoring config space at offset 0xc (was 0x0, writing 0x2a000000)
> [12541.984726] iwl3945 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
> [12541.984925] firewire_ohci 0000:15:00.1: restoring config space at offset 0xf (was 0x4020200, writing 0x402020b)
> [12541.984949] firewire_ohci 0000:15:00.1: restoring config space at offset 0x5 (was 0x0, writing 0xe4304000)
> [12541.984956] firewire_ohci 0000:15:00.1: restoring config space at offset 0x4 (was 0x0, writing 0xe4302000)
> [12541.984964] firewire_ohci 0000:15:00.1: restoring config space at offset 0x3 (was 0x800000, writing 0x804000)
> [12541.984973] firewire_ohci 0000:15:00.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
> [12541.985000] tifm_7xx1 0000:15:00.2: restoring config space at offset 0xf (was 0x40701ff, writing 0x407010b)
> [12541.985027] tifm_7xx1 0000:15:00.2: restoring config space at offset 0x4 (was 0x0, writing 0xe4301000)
> [12541.985034] tifm_7xx1 0000:15:00.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804000)
> [12541.985042] tifm_7xx1 0000:15:00.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
> [12541.985070] sdhci-pci 0000:15:00.3: restoring config space at offset 0xf (was 0x40701ff, writing 0x407010b)
> [12541.985096] sdhci-pci 0000:15:00.3: restoring config space at offset 0x4 (was 0x0, writing 0xe4302800)
> [12541.985103] sdhci-pci 0000:15:00.3: restoring config space at offset 0x3 (was 0x800000, writing 0x804000)
> [12541.985112] sdhci-pci 0000:15:00.3: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
> [12541.985401] PM: early resume of devices complete after 21.365 msecs
> [12541.985499] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [12541.985507] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [12541.985554] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
> [12541.985583] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [12541.985586] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> [12541.985595] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [12541.985605] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [12541.985653] usb usb2: root hub lost power or was reset
> [12541.985669] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [12541.985672] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
> [12541.985677] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [12541.985680] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [12541.985685] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [12541.985691] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [12541.985725] usb usb4: root hub lost power or was reset
> [12541.985727] usb usb3: root hub lost power or was reset
> [12541.985741] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [12541.985744] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [12541.985749] uhci_hcd 0000:00:1d.3: setting latency timer to 64
> [12541.985751] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
> [12541.985761] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [12541.985773] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [12541.985782] usb usb5: root hub lost power or was reset
> [12541.985798] pci 0000:00:1e.0: setting latency timer to 64
> [12541.985807] ata_piix 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
> [12541.985812] ata_piix 0000:00:1f.2: setting latency timer to 64
> [12541.985817] radeon 0000:01:00.0: power state changed by ACPI to D0
> [12541.985821] radeon 0000:01:00.0: power state changed by ACPI to D0
> [12541.985827] radeon 0000:01:00.0: setting latency timer to 64
> [12541.985832] pcieport 0000:00:1c.0: wake-up capability disabled by ACPI
> [12541.985835] radeon 0000:01:00.0: f6cf4c00 unpin not necessary
> [12541.985840] tg3 0000:02:00.0: PME# disabled
> [12541.987388] tifm_7xx1 0000:15:00.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [12541.987411] sdhci-pci 0000:15:00.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [12541.989785] [drm] radeon: 1 quad pipes, 2 z pipes initialized.
> [12541.993866] [drm] PCIE GART of 512M enabled (table at 0x00040000).
> [12541.993872] radeon 0000:01:00.0: WB enabled
> [12541.993986] [drm] radeon: ring at 0x0000000010001000
> [12541.994028] [drm] ring test succeeded in 7 usecs
> [12541.994041] [drm] ib test succeeded in 0 usecs
> [12542.003388] nsc-ircc 00:0a: activated
> [12542.006934] sd 0:0:0:0: [sda] Starting disk
> [12542.040205] firewire_core: skipped bus generations, destroying all nodes
> [12542.152446] ata2.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
> [12542.152449] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
> [12542.153901] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
> [12542.154890] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
> [12542.176313] ata2.00: configured for UDMA/33
> [12542.404063] usb 4-2: reset full speed USB device using uhci_hcd and address 3
> [12542.540119] firewire_core: rediscovered device fw0
> [12544.447658] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [12544.447666] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [12544.447673] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
> [12544.447680] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
> [12544.447965] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
> [12544.447969] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [12544.472515] ata1.00: configured for UDMA/100
> [12544.629795] PM: resume of devices complete after 2644.327 msecs
> [12544.629996] PM: Finishing wakeup.
> [12544.629998] Restarting tasks ... done.
> [12544.639213] video LNXVIDEO:00: Restoring backlight state
> [12544.678239] tg3 0000:02:00.0: irq 47 for MSI/MSI-X
> [12544.728318] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [12544.815745] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [12545.355102] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
> [12545.358840] EXT4-fs (sda5): re-mounted. Opts: commit=0
> [12545.492029] usb 4-1: new full speed USB device using uhci_hcd and address 6
> [12545.662081] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2110
> [12545.662086] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [12545.662089] usb 4-1: Product: BCM2045B
> [12545.662091] usb 4-1: Manufacturer: Broadcom Corp
> [12556.653450] wlan0: authenticate with 00:25:9c:1d:a3:bd (try 1)
> [12556.655273] wlan0: authenticated
> [12556.655320] wlan0: associate with 00:25:9c:1d:a3:bd (try 1)
> [12556.658244] wlan0: RX AssocResp from 00:25:9c:1d:a3:bd (capab=0x411 status=0 aid=1)
> [12556.658248] wlan0: associated
> [12556.659909] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [12567.504037] wlan0: no IPv6 routers present


