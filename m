Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab2GINyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:54:54 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.101]:37045 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab2GINyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:54:49 -0400
Message-ID: <4FFAE2A5.2070701@ladisch.de>
Date: Mon, 09 Jul 2012 15:54:45 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-usb@vger.kernel.org, Udo van den Heuvel <udovdh@xs4all.nl>,
        Simon Jones <sijones2010@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.4.4: disabling irq
References: <4FF93C68.5000503@xs4all.nl>
In-Reply-To: <4FF93C68.5000503@xs4all.nl>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(forwarded to linux-usb)

Udo van den Heuvel wrote:
> Hello,
>
> One moment the box is runing OK.
> One moment the 3.4.4 kernel decides to disable an interrupt.
> Why?
>
> Jul  8 07:43:49 box3 ntpd[5067]: parse: convert_rawdcf: INCOMPLETE DATA - time code only has 1 bits
> Jul  8 07:44:53 box3 kernel: irq 18: nobody cared (try booting with the "irqpoll" option)
> Jul  8 07:44:53 box3 kernel: Pid: 1501, comm: irq/18-ohci_hcd Tainted: G        W    3.4.4 #1
> Jul  8 07:44:53 box3 kernel: Call Trace:
> Jul  8 07:44:53 box3 kernel: [<ffffffff81095a76>] ? __report_bad_irq+0x36/0xd0
> Jul  8 07:44:53 box3 kernel: [<ffffffff81095d7f>] ? note_interrupt+0x1cf/0x220
> Jul  8 07:44:53 box3 kernel: [<ffffffff810945c0>] ? irq_thread_fn+0x40/0x40
> Jul  8 07:44:53 box3 kernel: [<ffffffff8109443d>] ? irq_thread+0x13d/0x180
> Jul  8 07:44:53 box3 kernel: [<ffffffff81094300>] ? wake_threads_waitq+0x50/0x50
> Jul  8 07:44:53 box3 kernel: [<ffffffff81052015>] ? kthread+0x85/0x90
> Jul  8 07:44:53 box3 kernel: [<ffffffff81405514>] ? kernel_thread_helper+0x4/0x10
> Jul  8 07:44:53 box3 kernel: [<ffffffff81051f90>] ? kthread_freezable_should_stop+0x50/0x50
> Jul  8 07:44:53 box3 kernel: [<ffffffff81405510>] ? gs_change+0xb/0xb
> Jul  8 07:44:53 box3 kernel: handlers:
> Jul  8 07:44:53 box3 kernel: [<ffffffff810939d0>] irq_default_primary_handler threaded [<ffffffff812c7bb0>] usb_hcd_irq
> Jul  8 07:44:53 box3 kernel: [<ffffffff810939d0>] irq_default_primary_handler threaded [<ffffffff812c7bb0>] usb_hcd_irq
> Jul  8 07:44:53 box3 kernel: [<ffffffff810939d0>] irq_default_primary_handler threaded [<ffffffff812c7bb0>] usb_hcd_irq
> Jul  8 07:44:53 box3 kernel: Disabling IRQ #18
> Jul  8 07:44:53 box3 kernel: pwc: Iso frame 0 has error -114
> Jul  8 07:44:53 box3 kernel: pwc: Iso frame 1 has error -18
> Jul  8 07:44:53 box3 kernel: pwc: Iso frame 2 has error -18
> Jul  8 07:44:53 box3 kernel: pwc: Iso frame 3 has error -18
> Jul  8 07:44:53 box3 kernel: pwc: Iso frame 4 has error -18
> Jul  8 07:44:53 box3 kernel: pwc: Iso frame 5 has error -18
> (etc; many more of the pwc messages)
>
> Kind regards,
> Udo

... and, with apparently the same mainboard:

Simon Jones wrote:
> Hi,
>
> Am not sure where to start with getting help on an issue.
>
> Since buying my motherboard i have found the usb ports are pretty
> unstable, and some devices work on usb2 some on usb3, after a while i
> managed to work out which will work where and it's reasonably stable
> now.
>
> Am on kernel 3.2.16 and tonight i thought i would try 3.4.4, it's all
> been compiled and seemed fine until i ran mythtv and couldn't get a
> smooth picture, then the tuner stopped responding and when looking in
> to the logs it appears IRQ18 assigned to the usb chipset gets disabled
> from what i can tell, it also causes a crash.
>
> Motherboard is Gigabyte GA-990XA-UD3
> CPU is AMD Bulldozer 6 Core version
>
> I'll attach the 2 dmesg logs, one from 3.2 and other from 3.4,
> hopefully someone can see what's wrong, there is a suggestion to boot
> with irqpoll, but really wanted someone's opinion on this.
>
> Regards,
>
> Simon

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.4-1-custom (root@tv-pc) (gcc version 4.7.1 (GCC) ) #1 SMP PREEMPT Sun Jul 8 16:39:08 BST 2012
[    0.000000] Command line: root=/dev/sda2 ro initrd=../initramfs-linux-custom.img BOOT_IMAGE=../vmlinuz-linux-custom
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000098800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfda0000 (usable)
[    0.000000]  BIOS-e820: 00000000bfda0000 - 00000000bfdd1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfdd1000 - 00000000bfe00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfe00000 - 00000000bff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000043f000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. GA-990XA-UD3/GA-990XA-UD3, BIOS F9 10/13/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x43f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000BFE00000 mask FFFFFFE00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000043f000000 aka 17392M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bfe00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbfda0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f4b30] f4b30
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000093000] 93000 size 20480
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfda0000
[    0.000000]  0000000000 - 0080000000 page 1G
[    0.000000]  0080000000 - 00bfc00000 page 2M
[    0.000000]  00bfc00000 - 00bfda0000 page 4k
[    0.000000] kernel direct mapping tables up to bfda0000 @ 1fffd000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000043f000000
[    0.000000]  0100000000 - 0400000000 page 1G
[    0.000000]  0400000000 - 043f000000 page 2M
[    0.000000] kernel direct mapping tables up to 43f000000 @ bfd9e000-bfda0000
[    0.000000] RAMDISK: 7fd29000 - 7ffff000
[    0.000000] ACPI: RSDP 00000000000f6a50 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000bfdd1000 00048 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 00000000bfdd1080 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000bfdd1100 07A4B (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bfda0000 00040
[    0.000000] ACPI: MSDM 00000000bfdd8c40 00055 (v03 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: HPET 00000000bfdd8cc0 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000bfdd8d00 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: MATS 00000000bfdd8d80 00034 (v01 GBT             00000000      00000000)
[    0.000000] ACPI: TAMG 00000000bfdd8df0 00202 (v01 GBT    GBT   B0 5455312E BG?? 53450101)
[    0.000000] ACPI: APIC 00000000bfdd8b80 000BC (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: MATS 00000000bfdd9000 06207 (v01        MATS RCM 80000001 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000bfddf280 01158 (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000043f000000
[    0.000000] Initmem setup node 0 0000000000000000-000000043f000000
[    0.000000]   NODE_DATA [000000043effc000 - 000000043effffff]
[    0.000000]  [ffffea0000000000-ffffea0010ffffff] PMD -> [ffff88042e600000-ffff88043e5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0043f000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000098
[    0.000000]     0: 0x00000100 -> 0x000bfda0
[    0.000000]     0: 0x00100000 -> 0x0043f000
[    0.000000] On node 0 totalpages: 4189480
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3907 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 765408 pages, LIFO batch:31
[    0.000000]   Normal zone: 53184 pages used for memmap
[    0.000000]   Normal zone: 3350592 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000098000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bfda0000 - 00000000bfdd1000
[    0.000000] PM: Registered nosave memory: 00000000bfdd1000 - 00000000bfe00000
[    0.000000] PM: Registered nosave memory: 00000000bfe00000 - 00000000bff00000
[    0.000000] PM: Registered nosave memory: 00000000bff00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at bff00000 (gap: bff00000:20100000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88043ec00000 s82048 r8192 d24448 u262144
[    0.000000] pcpu-alloc: s82048 r8192 d24448 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4119907
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda2 ro initrd=../initramfs-linux-custom.img BOOT_IMAGE=../vmlinuz-linux-custom
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ b4000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ b4000000
[    0.000000] PM: Registered nosave memory: 00000000b4000000 - 00000000b8000000
[    0.000000] Memory: 16349224k/17809408k available (4278k kernel code, 1051488k absent, 408696k reserved, 4565k data, 720k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.003333] Detected 3322.127 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 6646.09 BogoMIPS (lpj=11073756)
[    0.000006] pid_max: default: 32768 minimum: 301
[    0.000030] Security Framework initialized
[    0.000033] AppArmor: AppArmor disabled by boot time parameter
[    0.001135] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.005136] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.006855] Mount-cache hash table entries: 256
[    0.007031] Initializing cgroup subsys cpuacct
[    0.007033] Initializing cgroup subsys memory
[    0.007041] Initializing cgroup subsys devices
[    0.007042] Initializing cgroup subsys freezer
[    0.007044] Initializing cgroup subsys net_cls
[    0.007045] Initializing cgroup subsys blkio
[    0.007067] tseg: 00bff00000
[    0.007069] CPU: Physical Processor ID: 0
[    0.007070] CPU: Processor Core ID: 0
[    0.007071] mce: CPU supports 7 MCE banks
[    0.007077] LVT offset 1 assigned for vector 0xf9
[    0.007748] ACPI: Core revision 20120320
[    0.056144] ftrace: allocating 17054 entries in 67 pages
[    0.066001] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.098983] CPU0: AMD FX(tm)-6100 Six-Core Processor              stepping 02
[    0.203517] Performance Events: AMD Family 15h PMU driver.
[    0.203521] ... version:                0
[    0.203523] ... bit width:              48
[    0.203524] ... generic registers:      6
[    0.203526] ... value mask:             0000ffffffffffff
[    0.203527] ... max period:             00007fffffffffff
[    0.203529] ... fixed-purpose events:   0
[    0.203530] ... event mask:             000000000000003f
[    0.223560] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.243508] Booting Node   0, Processors  #1
[    0.257183] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.270172]  #2
[    0.283288] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.293470]  #3
[    0.306586] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.316782]  #4
[    0.329898] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.340098]  #5
[    0.353226] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.353251] Brought up 6 CPUs
[    0.353253] Total of 6 processors activated (39881.58 BogoMIPS).
[    0.364074] devtmpfs: initialized
[    0.366531] PM: Registering ACPI NVS region [mem 0xbfda0000-0xbfdd0fff] (200704 bytes)
[    0.367250] dummy:
[    0.367292] NET: Registered protocol family 16
[    0.367438] ACPI: bus type pci registered
[    0.367493] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.367496] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.394422] PCI: Using configuration type 1 for base access
[    0.395193] bio: create slab <bio-0> at 0
[    0.395247] ACPI: Added _OSI(Module Device)
[    0.395249] ACPI: Added _OSI(Processor Device)
[    0.395250] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.395252] ACPI: Added _OSI(Processor Aggregator Device)
[    0.396218] ACPI: EC: Look up EC in DSDT
[    0.404617] ACPI Warning: Incorrect checksum in table [TAMG] - 0x45, should be 0x44 (20120320/tbutils-323)
[    0.404759] ACPI: Interpreter enabled
[    0.404763] ACPI: (supports S0 S3 S4 S5)
[    0.404782] ACPI: Using IOAPIC for interrupt routing
[    0.502093] ACPI: No dock devices found.
[    0.502101] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.502233] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.502436] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.502442] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.502448] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.502453] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.502458] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.502463] pci_root PNP0A03:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.502547] PCI host bridge to bus 0000:00
[    0.502552] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.502558] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.502563] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.502568] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.502573] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.502578] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
[    0.502601] pci 0000:00:00.0: [1002:5a14] type 00 class 0x060000
[    0.502624] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
[    0.502718] pci 0000:00:02.0: [1002:5a16] type 01 class 0x060400
[    0.502779] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.502808] pci 0000:00:04.0: [1002:5a18] type 01 class 0x060400
[    0.502868] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.502893] pci 0000:00:05.0: [1002:5a19] type 01 class 0x060400
[    0.502953] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.502982] pci 0000:00:09.0: [1002:5a1c] type 01 class 0x060400
[    0.503041] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.503067] pci 0000:00:0a.0: [1002:5a1d] type 01 class 0x060400
[    0.503126] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.503163] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    0.503186] pci 0000:00:11.0: reg 10: [io  0xff00-0xff07]
[    0.503198] pci 0000:00:11.0: reg 14: [io  0xfe00-0xfe03]
[    0.503210] pci 0000:00:11.0: reg 18: [io  0xfd00-0xfd07]
[    0.503222] pci 0000:00:11.0: reg 1c: [io  0xfc00-0xfc03]
[    0.503234] pci 0000:00:11.0: reg 20: [io  0xfb00-0xfb0f]
[    0.503247] pci 0000:00:11.0: reg 24: [mem 0xfdfff000-0xfdfff3ff]
[    0.503321] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.503338] pci 0000:00:12.0: reg 10: [mem 0xfdffe000-0xfdffefff]
[    0.503419] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.503442] pci 0000:00:12.2: reg 10: [mem 0xfdffd000-0xfdffd0ff]
[    0.503529] pci 0000:00:12.2: supports D1 D2
[    0.503533] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.503562] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.503579] pci 0000:00:13.0: reg 10: [mem 0xfdffc000-0xfdffcfff]
[    0.503662] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.503684] pci 0000:00:13.2: reg 10: [mem 0xfdffb000-0xfdffb0ff]
[    0.503771] pci 0000:00:13.2: supports D1 D2
[    0.503775] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.503805] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.503890] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.503915] pci 0000:00:14.2: reg 10: [mem 0xfdff4000-0xfdff7fff 64bit]
[    0.503986] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.504006] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.504088] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.504137] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    0.504153] pci 0000:00:14.5: reg 10: [mem 0xfdffa000-0xfdffafff]
[    0.504235] pci 0000:00:15.0: [1002:43a0] type 01 class 0x060400
[    0.504318] pci 0000:00:15.0: supports D1 D2
[    0.504343] pci 0000:00:16.0: [1002:4397] type 00 class 0x0c0310
[    0.504359] pci 0000:00:16.0: reg 10: [mem 0xfdff9000-0xfdff9fff]
[    0.504437] pci 0000:00:16.2: [1002:4396] type 00 class 0x0c0320
[    0.504459] pci 0000:00:16.2: reg 10: [mem 0xfdff8000-0xfdff80ff]
[    0.504546] pci 0000:00:16.2: supports D1 D2
[    0.504550] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.504581] pci 0000:00:18.0: [1022:1600] type 00 class 0x060000
[    0.504624] pci 0000:00:18.1: [1022:1601] type 00 class 0x060000
[    0.504658] pci 0000:00:18.2: [1022:1602] type 00 class 0x060000
[    0.504692] pci 0000:00:18.3: [1022:1603] type 00 class 0x060000
[    0.504735] pci 0000:00:18.4: [1022:1604] type 00 class 0x060000
[    0.504771] pci 0000:00:18.5: [1022:1605] type 00 class 0x060000
[    0.504863] pci 0000:01:00.0: [10de:0a20] type 00 class 0x030000
[    0.504879] pci 0000:01:00.0: reg 10: [mem 0xfb000000-0xfbffffff]
[    0.504894] pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.504910] pci 0000:01:00.0: reg 1c: [mem 0xde000000-0xdfffffff 64bit pref]
[    0.504922] pci 0000:01:00.0: reg 24: [io  0xef00-0xef7f]
[    0.504934] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.505009] pci 0000:01:00.1: [10de:0be2] type 00 class 0x040300
[    0.505024] pci 0000:01:00.1: reg 10: [mem 0xfcffc000-0xfcffffff]
[    0.509966] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.509975] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.509982] pci 0000:00:02.0:   bridge window [mem 0xfb000000-0xfcffffff]
[    0.509990] pci 0000:00:02.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.510049] pci 0000:02:00.0: [1b6f:7023] type 00 class 0x0c0330
[    0.510072] pci 0000:02:00.0: reg 10: [mem 0xfd4f8000-0xfd4fffff 64bit]
[    0.510164] pci 0000:02:00.0: supports D1 D2
[    0.510168] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.516622] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    0.516631] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.516637] pci 0000:00:04.0:   bridge window [mem 0xfd400000-0xfd4fffff]
[    0.516645] pci 0000:00:04.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.516709] pci 0000:03:00.0: [9710:9990] type 00 class 0x0c0310
[    0.516731] pci 0000:03:00.0: reg 10: [mem 0xfddff000-0xfddfffff]
[    0.516863] pci 0000:03:00.0: supports D1 D2
[    0.516867] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.516915] pci 0000:03:00.1: [9710:9990] type 00 class 0x0c0320
[    0.516936] pci 0000:03:00.1: reg 10: [mem 0xfddfe000-0xfddfefff]
[    0.517071] pci 0000:03:00.1: supports D1 D2
[    0.517075] pci 0000:03:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.517121] pci 0000:03:00.2: [9710:9990] type 00 class 0x0c0310
[    0.517142] pci 0000:03:00.2: reg 10: [mem 0xfddfd000-0xfddfdfff]
[    0.517272] pci 0000:03:00.2: supports D1 D2
[    0.517276] pci 0000:03:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.517322] pci 0000:03:00.3: [9710:9990] type 00 class 0x0c0320
[    0.517343] pci 0000:03:00.3: reg 10: [mem 0xfddfc000-0xfddfcfff]
[    0.517473] pci 0000:03:00.3: supports D1 D2
[    0.517477] pci 0000:03:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.517527] pci 0000:03:00.4: [9710:9990] type 00 class 0x0c0310
[    0.517547] pci 0000:03:00.4: reg 10: [mem 0xfddfb000-0xfddfbfff]
[    0.517678] pci 0000:03:00.4: supports D1 D2
[    0.517682] pci 0000:03:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.517727] pci 0000:03:00.5: [9710:9990] type 00 class 0x0c0320
[    0.517748] pci 0000:03:00.5: reg 10: [mem 0xfddfa000-0xfddfafff]
[    0.517879] pci 0000:03:00.5: supports D1 D2
[    0.517883] pci 0000:03:00.5: PME# supported from D0 D1 D2 D3hot D3cold
[    0.517928] pci 0000:03:00.6: [9710:9990] type 00 class 0x0c0310
[    0.517949] pci 0000:03:00.6: reg 10: [mem 0xfddf9000-0xfddf9fff]
[    0.518080] pci 0000:03:00.6: supports D1 D2
[    0.518084] pci 0000:03:00.6: PME# supported from D0 D1 D2 D3hot D3cold
[    0.518129] pci 0000:03:00.7: [9710:9990] type 00 class 0x0c0320
[    0.518150] pci 0000:03:00.7: reg 10: [mem 0xfddf8000-0xfddf8fff]
[    0.518280] pci 0000:03:00.7: supports D1 D2
[    0.518284] pci 0000:03:00.7: PME# supported from D0 D1 D2 D3hot D3cold
[    0.523319] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    0.523327] pci 0000:00:05.0:   bridge window [io  0xc000-0xcfff]
[    0.523334] pci 0000:00:05.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.523342] pci 0000:00:05.0:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.523402] pci 0000:04:00.0: [10ec:8168] type 00 class 0x020000
[    0.523420] pci 0000:04:00.0: reg 10: [io  0xbe00-0xbeff]
[    0.523448] pci 0000:04:00.0: reg 18: [mem 0xfdaff000-0xfdafffff 64bit pref]
[    0.523468] pci 0000:04:00.0: reg 20: [mem 0xfdaf8000-0xfdafbfff 64bit pref]
[    0.523539] pci 0000:04:00.0: supports D1 D2
[    0.523544] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.529945] pci 0000:00:09.0: PCI bridge to [bus 04-04]
[    0.529953] pci 0000:00:09.0:   bridge window [io  0xb000-0xbfff]
[    0.529960] pci 0000:00:09.0:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.529968] pci 0000:00:09.0:   bridge window [mem 0xfda00000-0xfdafffff 64bit pref]
[    0.530027] pci 0000:05:00.0: [1b6f:7023] type 00 class 0x0c0330
[    0.530049] pci 0000:05:00.0: reg 10: [mem 0xfd8f8000-0xfd8fffff 64bit]
[    0.530141] pci 0000:05:00.0: supports D1 D2
[    0.530145] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.536605] pci 0000:00:0a.0: PCI bridge to [bus 05-05]
[    0.536614] pci 0000:00:0a.0:   bridge window [io  0xa000-0xafff]
[    0.536620] pci 0000:00:0a.0:   bridge window [mem 0xfd800000-0xfd8fffff]
[    0.536628] pci 0000:00:0a.0:   bridge window [mem 0xfd500000-0xfd5fffff 64bit pref]
[    0.536671] pci 0000:06:06.0: [1106:3038] type 00 class 0x0c0300
[    0.536736] pci 0000:06:06.0: reg 20: [io  0x9f00-0x9f1f]
[    0.536796] pci 0000:06:06.0: supports D1 D2
[    0.536800] pci 0000:06:06.0: PME# supported from D0 D1 D2 D3hot
[    0.536828] pci 0000:06:06.1: [1106:3038] type 00 class 0x0c0300
[    0.536893] pci 0000:06:06.1: reg 20: [io  0x9e00-0x9e1f]
[    0.536956] pci 0000:06:06.1: supports D1 D2
[    0.536961] pci 0000:06:06.1: PME# supported from D0 D1 D2 D3hot
[    0.536992] pci 0000:06:06.2: [1106:3104] type 00 class 0x0c0320
[    0.537017] pci 0000:06:06.2: reg 10: [mem 0xfafff000-0xfafff0ff]
[    0.537116] pci 0000:06:06.2: supports D1 D2
[    0.537120] pci 0000:06:06.2: PME# supported from D0 D1 D2 D3hot
[    0.537159] pci 0000:06:07.0: [14f1:8800] type 00 class 0x040000
[    0.537186] pci 0000:06:07.0: reg 10: [mem 0xf8000000-0xf8ffffff]
[    0.537321] pci 0000:06:07.2: [14f1:8802] type 00 class 0x048000
[    0.537345] pci 0000:06:07.2: reg 10: [mem 0xf9000000-0xf9ffffff]
[    0.537484] pci 0000:06:0e.0: [1106:3044] type 00 class 0x0c0010
[    0.537509] pci 0000:06:0e.0: reg 10: [mem 0xfaffe000-0xfaffe7ff]
[    0.537525] pci 0000:06:0e.0: reg 14: [io  0x9d00-0x9d7f]
[    0.537621] pci 0000:06:0e.0: supports D2
[    0.537625] pci 0000:06:0e.0: PME# supported from D2 D3hot D3cold
[    0.537669] pci 0000:00:14.4: PCI bridge to [bus 06-06] (subtractive decode)
[    0.537676] pci 0000:00:14.4:   bridge window [io  0x9000-0x9fff]
[    0.537683] pci 0000:00:14.4:   bridge window [mem 0xf8000000-0xfaffffff]
[    0.537691] pci 0000:00:14.4:   bridge window [mem 0xfd900000-0xfd9fffff pref]
[    0.537696] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.537702] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.537707] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.537713] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.537718] pci 0000:00:14.4:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.537724] pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.537780] pci 0000:00:15.0: PCI bridge to [bus 07-07]
[    0.537789] pci 0000:00:15.0:   bridge window [io  0x8000-0x8fff]
[    0.537795] pci 0000:00:15.0:   bridge window [mem 0xfd700000-0xfd7fffff]
[    0.537805] pci 0000:00:15.0:   bridge window [mem 0xfd600000-0xfd6fffff 64bit pref]
[    0.537837] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.538513] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.538610] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.538752] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.538829] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
[    0.538900] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE5._PRT]
[    0.538979] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
[    0.539049] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.539131]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.539138]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.539142] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.571361] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0
[    0.571419] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0
[    0.571474] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0
[    0.571528] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0
[    0.571582] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0
[    0.571634] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0
[    0.571686] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0
[    0.571738] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0
[    0.571878] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.571891] vgaarb: loaded
[    0.571893] vgaarb: bridge control possible 0000:01:00.0
[    0.571963] PCI: Using ACPI for IRQ routing
[    0.578310] PCI: pci_cache_line_size set to 64 bytes
[    0.578319] pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
[    0.578439] reserve RAM buffer: 0000000000098800 - 000000000009ffff
[    0.578441] reserve RAM buffer: 00000000bfda0000 - 00000000bfffffff
[    0.578443] reserve RAM buffer: 000000043f000000 - 000000043fffffff
[    0.578525] NetLabel: Initializing
[    0.578526] NetLabel:  domain hash size = 128
[    0.578527] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.578538] NetLabel:  unlabeled traffic allowed by default
[    0.578556] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.578559] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.580609] Switching to clocksource hpet
[    0.586476] pnp: PnP ACPI init
[    0.586489] ACPI: bus type pnp registered
[    0.586564] pnp 00:00: [bus 00-ff]
[    0.586567] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.586569] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.586571] pnp 00:00: [io  0x0d00-0xffff window]
[    0.586573] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.586575] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.586577] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.586579] pnp 00:00: [mem 0xc0000000-0xfebfffff window]
[    0.586617] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.586628] pnp 00:01: [io  0x0010-0x001f]
[    0.586629] pnp 00:01: [io  0x0022-0x003f]
[    0.586631] pnp 00:01: [io  0x0044-0x004d]
[    0.586633] pnp 00:01: [io  0x0050-0x005f]
[    0.586635] pnp 00:01: [io  0x0062-0x0063]
[    0.586636] pnp 00:01: [io  0x0065-0x006f]
[    0.586638] pnp 00:01: [io  0x0074-0x007f]
[    0.586640] pnp 00:01: [io  0x0091-0x0093]
[    0.586641] pnp 00:01: [io  0x00a2-0x00bf]
[    0.586643] pnp 00:01: [io  0x00e0-0x00ef]
[    0.586645] pnp 00:01: [io  0x04d0-0x04d1]
[    0.586646] pnp 00:01: [io  0x0220-0x0225]
[    0.586648] pnp 00:01: [io  0x0290-0x0294]
[    0.586705] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.586708] system 00:01: [io  0x0220-0x0225] has been reserved
[    0.586711] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.586714] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.680847] pnp 00:02: [io  0x0900-0x091f]
[    0.680853] pnp 00:02: [io  0x0228-0x022f]
[    0.680858] pnp 00:02: [io  0x040b]
[    0.680862] pnp 00:02: [io  0x04d6]
[    0.680870] pnp 00:02: [io  0x0c00-0x0c01]
[    0.680874] pnp 00:02: [io  0x0c14]
[    0.680878] pnp 00:02: [io  0x0c50-0x0c52]
[    0.680882] pnp 00:02: [io  0x0c6c-0x0c6d]
[    0.680886] pnp 00:02: [io  0x0c6f]
[    0.680889] pnp 00:02: [io  0x0cd0-0x0cd1]
[    0.680893] pnp 00:02: [io  0x0cd2-0x0cd3]
[    0.680897] pnp 00:02: [io  0x0cd4-0x0cdf]
[    0.680901] pnp 00:02: [io  0x0800-0x08fe]
[    0.680905] pnp 00:02: [io  0x0a10-0x0a17]
[    0.680908] pnp 00:02: [io  0x0b00-0x0b0f]
[    0.680912] pnp 00:02: [io  0x0b10-0x0b1f]
[    0.680916] pnp 00:02: [io  0x0b20-0x0b3f]
[    0.680921] pnp 00:02: [mem 0x00000000-0x00000fff window]
[    0.680926] pnp 00:02: [mem 0xfee00400-0xfee00fff window]
[    0.680937] pnp 00:02: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.681006] pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x0007ffff pref]
[    0.681114] system 00:02: [io  0x0900-0x091f] has been reserved
[    0.681121] system 00:02: [io  0x0228-0x022f] has been reserved
[    0.681127] system 00:02: [io  0x040b] has been reserved
[    0.681132] system 00:02: [io  0x04d6] has been reserved
[    0.681137] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.681142] system 00:02: [io  0x0c14] has been reserved
[    0.681147] system 00:02: [io  0x0c50-0x0c52] has been reserved
[    0.681152] system 00:02: [io  0x0c6c-0x0c6d] has been reserved
[    0.681157] system 00:02: [io  0x0c6f] has been reserved
[    0.681162] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    0.681167] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    0.681172] system 00:02: [io  0x0cd4-0x0cdf] has been reserved
[    0.681177] system 00:02: [io  0x0800-0x08fe] has been reserved
[    0.681182] system 00:02: [io  0x0a10-0x0a17] has been reserved
[    0.681188] system 00:02: [io  0x0b00-0x0b0f] has been reserved
[    0.681193] system 00:02: [io  0x0b10-0x0b1f] has been reserved
[    0.681198] system 00:02: [io  0x0b20-0x0b3f] has been reserved
[    0.681205] system 00:02: [mem 0xfee00400-0xfee00fff window] has been reserved
[    0.681212] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.681421] pnp 00:03: [dma 4]
[    0.681425] pnp 00:03: [io  0x0000-0x000f]
[    0.681429] pnp 00:03: [io  0x0080-0x0090]
[    0.681433] pnp 00:03: [io  0x0094-0x009f]
[    0.681437] pnp 00:03: [io  0x00c0-0x00df]
[    0.681506] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.681623] pnp 00:04: [irq 0 disabled]
[    0.681636] pnp 00:04: [irq 8]
[    0.681641] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.681707] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.681769] pnp 00:05: [io  0x0070-0x0073]
[    0.681838] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.681857] pnp 00:06: [io  0x0061]
[    0.681924] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.681943] pnp 00:07: [io  0x00f0-0x00ff]
[    0.681951] pnp 00:07: [irq 13]
[    0.682017] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.682620] pnp 00:08: [io  0x03f8-0x03ff]
[    0.682629] pnp 00:08: [irq 4]
[    0.682755] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.682895] pnp 00:09: [mem 0xe0000000-0xefffffff]
[    0.683042] system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
[    0.683050] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.683416] pnp 00:0a: [mem 0x000d4200-0x000d7fff]
[    0.683421] pnp 00:0a: [mem 0x000f0000-0x000f7fff]
[    0.683425] pnp 00:0a: [mem 0x000f8000-0x000fbfff]
[    0.683430] pnp 00:0a: [mem 0x000fc000-0x000fffff]
[    0.683437] pnp 00:0a: [mem 0xbfda0000-0xbfdfffff]
[    0.683441] pnp 00:0a: [mem 0xffff0000-0xffffffff]
[    0.683446] pnp 00:0a: [mem 0x00000000-0x0009ffff]
[    0.683450] pnp 00:0a: [mem 0x00100000-0xbfd9ffff]
[    0.683454] pnp 00:0a: [mem 0xbfe00000-0xbfefffff]
[    0.683459] pnp 00:0a: [mem 0xbff00000-0xbfffffff]
[    0.683463] pnp 00:0a: [mem 0xfec00000-0xfec00fff]
[    0.683467] pnp 00:0a: [mem 0xfee00000-0xfee00fff]
[    0.683472] pnp 00:0a: [mem 0xfff80000-0xfffeffff]
[    0.683480] pnp 00:0a: disabling [mem 0x000d4200-0x000d7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.683488] pnp 00:0a: disabling [mem 0x000f0000-0x000f7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.683496] pnp 00:0a: disabling [mem 0x000f8000-0x000fbfff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.683504] pnp 00:0a: disabling [mem 0x000fc000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.683511] pnp 00:0a: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.683519] pnp 00:0a: disabling [mem 0x00100000-0xbfd9ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.683710] system 00:0a: [mem 0xbfda0000-0xbfdfffff] could not be reserved
[    0.683717] system 00:0a: [mem 0xffff0000-0xffffffff] has been reserved
[    0.683722] system 00:0a: [mem 0xbfe00000-0xbfefffff] has been reserved
[    0.683728] system 00:0a: [mem 0xbff00000-0xbfffffff] could not be reserved
[    0.683734] system 00:0a: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.683740] system 00:0a: [mem 0xfee00000-0xfee00fff] could not be reserved
[    0.683746] system 00:0a: [mem 0xfff80000-0xfffeffff] has been reserved
[    0.683753] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.683797] pnp: PnP ACPI: found 11 devices
[    0.683801] ACPI: ACPI bus type pnp unregistered
[    0.692508] pci 0000:01:00.0: BAR 6: assigned [mem 0xd0000000-0xd007ffff pref]
[    0.692515] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.692521] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.692528] pci 0000:00:02.0:   bridge window [mem 0xfb000000-0xfcffffff]
[    0.692535] pci 0000:00:02.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.692543] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    0.692548] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.692554] pci 0000:00:04.0:   bridge window [mem 0xfd400000-0xfd4fffff]
[    0.692561] pci 0000:00:04.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.692570] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    0.692575] pci 0000:00:05.0:   bridge window [io  0xc000-0xcfff]
[    0.692581] pci 0000:00:05.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.692587] pci 0000:00:05.0:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.692595] pci 0000:00:09.0: PCI bridge to [bus 04-04]
[    0.692600] pci 0000:00:09.0:   bridge window [io  0xb000-0xbfff]
[    0.692606] pci 0000:00:09.0:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.692612] pci 0000:00:09.0:   bridge window [mem 0xfda00000-0xfdafffff 64bit pref]
[    0.692620] pci 0000:00:0a.0: PCI bridge to [bus 05-05]
[    0.692625] pci 0000:00:0a.0:   bridge window [io  0xa000-0xafff]
[    0.692631] pci 0000:00:0a.0:   bridge window [mem 0xfd800000-0xfd8fffff]
[    0.692637] pci 0000:00:0a.0:   bridge window [mem 0xfd500000-0xfd5fffff 64bit pref]
[    0.692646] pci 0000:00:14.4: PCI bridge to [bus 06-06]
[    0.692651] pci 0000:00:14.4:   bridge window [io  0x9000-0x9fff]
[    0.692659] pci 0000:00:14.4:   bridge window [mem 0xf8000000-0xfaffffff]
[    0.692666] pci 0000:00:14.4:   bridge window [mem 0xfd900000-0xfd9fffff pref]
[    0.692675] pci 0000:00:15.0: PCI bridge to [bus 07-07]
[    0.692680] pci 0000:00:15.0:   bridge window [io  0x8000-0x8fff]
[    0.692687] pci 0000:00:15.0:   bridge window [mem 0xfd700000-0xfd7fffff]
[    0.692694] pci 0000:00:15.0:   bridge window [mem 0xfd600000-0xfd6fffff 64bit pref]
[    0.692765] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.692770] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.692775] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.692780] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.692785] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.692789] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    0.692794] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.692799] pci_bus 0000:01: resource 1 [mem 0xfb000000-0xfcffffff]
[    0.692804] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.692809] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.692813] pci_bus 0000:02: resource 1 [mem 0xfd400000-0xfd4fffff]
[    0.692818] pci_bus 0000:02: resource 2 [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.692823] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.692828] pci_bus 0000:03: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.692833] pci_bus 0000:03: resource 2 [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.692838] pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
[    0.692842] pci_bus 0000:04: resource 1 [mem 0xfdb00000-0xfdbfffff]
[    0.692847] pci_bus 0000:04: resource 2 [mem 0xfda00000-0xfdafffff 64bit pref]
[    0.692853] pci_bus 0000:05: resource 0 [io  0xa000-0xafff]
[    0.692857] pci_bus 0000:05: resource 1 [mem 0xfd800000-0xfd8fffff]
[    0.692862] pci_bus 0000:05: resource 2 [mem 0xfd500000-0xfd5fffff 64bit pref]
[    0.692867] pci_bus 0000:06: resource 0 [io  0x9000-0x9fff]
[    0.692872] pci_bus 0000:06: resource 1 [mem 0xf8000000-0xfaffffff]
[    0.692877] pci_bus 0000:06: resource 2 [mem 0xfd900000-0xfd9fffff pref]
[    0.692881] pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
[    0.692886] pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
[    0.692890] pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
[    0.692895] pci_bus 0000:06: resource 7 [mem 0x000c0000-0x000dffff]
[    0.692900] pci_bus 0000:06: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.692905] pci_bus 0000:06: resource 9 [mem 0xc0000000-0xfebfffff]
[    0.692910] pci_bus 0000:07: resource 0 [io  0x8000-0x8fff]
[    0.692914] pci_bus 0000:07: resource 1 [mem 0xfd700000-0xfd7fffff]
[    0.692919] pci_bus 0000:07: resource 2 [mem 0xfd600000-0xfd6fffff 64bit pref]
[    0.692984] NET: Registered protocol family 2
[    0.693759] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.696487] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.699498] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.699844] TCP: Hash tables configured (established 524288 bind 65536)
[    0.699849] TCP: reno registered
[    0.699898] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.700039] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.700251] NET: Registered protocol family 1
[    0.980534] pci 0000:01:00.0: Boot video device
[    1.193849] PCI: CLS 64 bytes, default 64
[    1.193929] Unpacking initramfs...
[    1.332646] Freeing initrd memory: 2904k freed
[    1.334860] PCI-DMA: Disabling AGP.
[    1.335019] PCI-DMA: aperture base @ b4000000 size 65536 KB
[    1.335023] PCI-DMA: using GART IOMMU.
[    1.335029] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.344641] LVT offset 0 assigned for vector 0x400
[    1.344677] perf: AMD IBS detected (0x000000ff)
[    1.344996] audit: initializing netlink socket (disabled)
[    1.345026] type=2000 audit(1341767257.186:1): initialized
[    1.346517] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.352006] VFS: Disk quotas dquot_6.5.2
[    1.352102] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.352279] msgmni has been set to 32066
[    1.352574] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.352625] io scheduler noop registered
[    1.352629] io scheduler deadline registered
[    1.352740] io scheduler cfq registered (default)
[    1.353398] GHES: HEST is not enabled!
[    1.353519] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.374060] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.394776] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.394973] Linux agpgart interface v0.103
[    1.395029] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.428691] i8042: Failed to disable AUX port, but continuing anyway... Is this a SiS?
[    1.428693] i8042: If AUX port is really absent please use the 'i8042.noaux' option
[    1.676649] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.676856] mousedev: PS/2 mouse device common for all mice
[    1.676950] rtc_cmos 00:05: RTC can wake from S4
[    1.677126] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.677153] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.677170] cpuidle: using governor ladder
[    1.677175] cpuidle: using governor menu
[    1.677324] TCP: cubic registered
[    1.677328] NET: Registered protocol family 17
[    1.677339] Registering the dns_resolver key type
[    1.677559] PM: Hibernation image not present or could not be loaded.
[    1.677571] registered taskstats version 1
[    1.679465] rtc_cmos 00:05: setting system clock to 2012-07-08 17:07:38 UTC (1341767258)
[    1.679541] Initializing network drop monitor service
[    1.830872] Freeing unused kernel memory: 720k freed
[    1.831140] Write protecting the kernel read-only data: 8192k
[    1.849515] Freeing unused kernel memory: 1848k freed
[    1.856902] Freeing unused kernel memory: 676k freed
[    1.872457] udevd[61]: starting version 185
[    1.931585] usbcore: registered new interface driver usbfs
[    1.931729] usbcore: registered new interface driver hub
[    1.931786] usbcore: registered new device driver usb
[    1.933938] SCSI subsystem initialized
[    1.934052] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.934114] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    1.934161] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    1.934176] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.934219] QUIRK: Enable AMD PLL fix
[    1.934230] ehci_hcd 0000:00:12.2: debug port 1
[    1.934253] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfdffd000
[    1.935666] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    1.935690] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 2
[    1.935785] xhci_hcd 0000:02:00.0: irq 16, io mem 0xfd4f8000
[    1.935847] xhci_hcd 0000:02:00.0: irq 40 for MSI/MSI-X
[    1.936069] xHCI xhci_add_endpoint called for root hub
[    1.936073] xHCI xhci_check_bandwidth called for root hub
[    1.936145] hub 2-0:1.0: USB hub found
[    1.936153] hub 2-0:1.0: 2 ports detected
[    1.936633] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    1.936644] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 3
[    1.936804] xHCI xhci_add_endpoint called for root hub
[    1.936807] xHCI xhci_check_bandwidth called for root hub
[    1.937093] hub 3-0:1.0: USB hub found
[    1.937101] hub 3-0:1.0: 2 ports detected
[    1.937680] libata version 3.00 loaded.
[    1.942992] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.943457] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.943644] hub 1-0:1.0: USB hub found
[    1.943652] hub 1-0:1.0: 5 ports detected
[    1.943854] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    1.943863] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
[    1.943870] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.943888] ehci_hcd 0000:00:13.2: debug port 1
[    1.943901] ehci_hcd 0000:00:13.2: irq 17, io mem 0xfdffb000
[    1.952972] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.953334] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    1.953488] hub 4-0:1.0: USB hub found
[    1.953494] hub 4-0:1.0: 5 ports detected
[    1.953557] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 5
[    1.953600] ehci_hcd 0000:00:16.2: EHCI Host Controller
[    1.953609] ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus number 6
[    1.953618] ehci_hcd 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.953645] ehci_hcd 0000:00:16.2: debug port 1
[    1.953652] xhci_hcd 0000:05:00.0: irq 18, io mem 0xfd8f8000
[    1.953661] ehci_hcd 0000:00:16.2: irq 17, io mem 0xfdff8000
[    1.953706] xhci_hcd 0000:05:00.0: irq 41 for MSI/MSI-X
[    1.953730] uhci_hcd: USB Universal Host Controller Interface driver
[    1.953781] uhci_hcd 0000:06:06.0: UHCI Host Controller
[    1.953967] xHCI xhci_add_endpoint called for root hub
[    1.953970] xHCI xhci_check_bandwidth called for root hub
[    1.953999] hub 5-0:1.0: USB hub found
[    1.954006] hub 5-0:1.0: 2 ports detected
[    1.954229] uhci_hcd 0000:06:06.0: new USB bus registered, assigned bus number 7
[    1.954246] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    1.954254] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 8
[    1.954264] uhci_hcd 0000:06:06.0: irq 20, io base 0x00009f00
[    1.954489] xHCI xhci_add_endpoint called for root hub
[    1.954491] xHCI xhci_check_bandwidth called for root hub
[    1.954524] hub 8-0:1.0: USB hub found
[    1.954532] hub 8-0:1.0: 2 ports detected
[    1.955229] hub 7-0:1.0: USB hub found
[    1.955235] hub 7-0:1.0: 2 ports detected
[    1.955403] uhci_hcd 0000:06:06.1: UHCI Host Controller
[    1.955413] uhci_hcd 0000:06:06.1: new USB bus registered, assigned bus number 9
[    1.955450] uhci_hcd 0000:06:06.1: irq 21, io base 0x00009e00
[    1.955573] hub 9-0:1.0: USB hub found
[    1.955579] hub 9-0:1.0: 2 ports detected
[    1.963012] ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    1.963168] hub 6-0:1.0: USB hub found
[    1.963173] hub 6-0:1.0: 4 ports detected
[    1.963337] ahci 0000:00:11.0: version 3.0
[    1.963363] ehci_hcd 0000:03:00.1: EHCI Host Controller
[    1.963388] ehci_hcd 0000:03:00.1: new USB bus registered, assigned bus number 10
[    1.963408] ehci_hcd 0000:03:00.1: applying MosChip frame-index workaround
[    1.963454] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    1.963458] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part
[    1.964185] scsi0 : ahci
[    1.964262] scsi1 : ahci
[    1.964329] scsi2 : ahci
[    1.964395] scsi3 : ahci
[    1.964460] scsi4 : ahci
[    1.964526] scsi5 : ahci
[    1.964669] ata1: SATA max UDMA/133 abar m1024@0xfdfff000 port 0xfdfff100 irq 19
[    1.964672] ata2: SATA max UDMA/133 abar m1024@0xfdfff000 port 0xfdfff180 irq 19
[    1.964675] ata3: SATA max UDMA/133 abar m1024@0xfdfff000 port 0xfdfff200 irq 19
[    1.964678] ata4: SATA max UDMA/133 abar m1024@0xfdfff000 port 0xfdfff280 irq 19
[    1.964681] ata5: SATA max UDMA/133 abar m1024@0xfdfff000 port 0xfdfff300 irq 19
[    1.964684] ata6: SATA max UDMA/133 abar m1024@0xfdfff000 port 0xfdfff380 irq 19
[    1.964729] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    1.964741] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 11
[    1.964762] ohci_hcd 0000:00:12.0: irq 18, io mem 0xfdffe000
[    1.986318] ehci_hcd 0000:03:00.1: irq 17, io mem 0xfddfe000
[    1.996311] ehci_hcd 0000:03:00.1: USB 2.0 started, EHCI 1.00
[    1.996577] hub 10-0:1.0: USB hub found
[    1.996585] hub 10-0:1.0: 1 port detected
[    1.996820] ehci_hcd 0000:03:00.3: EHCI Host Controller
[    1.996837] ehci_hcd 0000:03:00.3: new USB bus registered, assigned bus number 12
[    1.996863] ehci_hcd 0000:03:00.3: applying MosChip frame-index workaround
[    2.019607] ehci_hcd 0000:03:00.3: irq 18, io mem 0xfddfc000
[    2.020567] hub 11-0:1.0: USB hub found
[    2.020578] hub 11-0:1.0: 5 ports detected
[    2.020854] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.020871] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 13
[    2.020898] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfdffc000
[    2.029615] ehci_hcd 0000:03:00.3: USB 2.0 started, EHCI 1.00
[    2.029871] hub 12-0:1.0: USB hub found
[    2.029880] hub 12-0:1.0: 1 port detected
[    2.030133] ehci_hcd 0000:03:00.5: EHCI Host Controller
[    2.030152] ehci_hcd 0000:03:00.5: new USB bus registered, assigned bus number 14
[    2.030176] ehci_hcd 0000:03:00.5: applying MosChip frame-index workaround
[    2.052956] ehci_hcd 0000:03:00.5: irq 19, io mem 0xfddfa000
[    2.062913] ehci_hcd 0000:03:00.5: USB 2.0 started, EHCI 1.00
[    2.063166] hub 14-0:1.0: USB hub found
[    2.063175] hub 14-0:1.0: 1 port detected
[    2.063351] ehci_hcd 0000:03:00.7: EHCI Host Controller
[    2.063367] ehci_hcd 0000:03:00.7: new USB bus registered, assigned bus number 15
[    2.063392] ehci_hcd 0000:03:00.7: applying MosChip frame-index workaround
[    2.077141] hub 13-0:1.0: USB hub found
[    2.077151] hub 13-0:1.0: 5 ports detected
[    2.077463] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    2.077479] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 16
[    2.077504] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfdffa000
[    2.086243] ehci_hcd 0000:03:00.7: irq 16, io mem 0xfddf8000
[    2.096220] ehci_hcd 0000:03:00.7: USB 2.0 started, EHCI 1.00
[    2.096457] hub 15-0:1.0: USB hub found
[    2.096465] hub 15-0:1.0: 1 port detected
[    2.096782] ehci_hcd 0000:06:06.2: EHCI Host Controller
[    2.096798] ehci_hcd 0000:06:06.2: new USB bus registered, assigned bus number 17
[    2.096863] ehci_hcd 0000:06:06.2: irq 22, io mem 0xfafff000
[    2.106217] ehci_hcd 0000:06:06.2: USB 2.0 started, EHCI 1.00
[    2.106466] hub 17-0:1.0: USB hub found
[    2.106474] hub 17-0:1.0: 4 ports detected
[    2.137129] hub 16-0:1.0: USB hub found
[    2.137141] hub 16-0:1.0: 2 ports detected
[    2.137477] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    2.137494] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 18
[    2.137526] ohci_hcd 0000:00:16.0: irq 18, io mem 0xfdff9000
[    2.193744] hub 18-0:1.0: USB hub found
[    2.193755] hub 18-0:1.0: 4 ports detected
[    2.194082] ohci_hcd 0000:03:00.0: OHCI Host Controller
[    2.194126] ohci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 19
[    2.194149] ohci_hcd 0000:03:00.0: irq 17, io mem 0xfddff000
[    2.242793] usb 2-1: new high-speed USB device number 2 using xhci_hcd
[    2.250370] hub 19-0:1.0: USB hub found
[    2.250382] hub 19-0:1.0: 1 port detected
[    2.250620] ohci_hcd 0000:03:00.2: OHCI Host Controller
[    2.250636] ohci_hcd 0000:03:00.2: new USB bus registered, assigned bus number 20
[    2.250659] ohci_hcd 0000:03:00.2: irq 18, io mem 0xfddfd000
[    2.282765] ata4: SATA link down (SStatus 0 SControl 300)
[    2.282864] ata6: SATA link down (SStatus 0 SControl 300)
[    2.282931] ata5: SATA link down (SStatus 0 SControl 300)
[    2.306990] hub 20-0:1.0: USB hub found
[    2.307002] hub 20-0:1.0: 1 port detected
[    2.307304] ohci_hcd 0000:03:00.4: OHCI Host Controller
[    2.307320] ohci_hcd 0000:03:00.4: new USB bus registered, assigned bus number 21
[    2.307347] ohci_hcd 0000:03:00.4: irq 19, io mem 0xfddfb000
[    2.346038] Refined TSC clocksource calibration: 3322.134 MHz.
[    2.346051] Switching to clocksource tsc
[    2.363603] hub 21-0:1.0: USB hub found
[    2.363613] hub 21-0:1.0: 1 port detected
[    2.363912] ohci_hcd 0000:03:00.6: OHCI Host Controller
[    2.363928] ohci_hcd 0000:03:00.6: new USB bus registered, assigned bus number 22
[    2.363952] ohci_hcd 0000:03:00.6: irq 16, io mem 0xfddf9000
[    2.366033] usb 2-2: new low-speed USB device number 3 using xhci_hcd
[    2.416660] usb 2-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    2.416671] usb 2-2: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
[    2.420196] hub 22-0:1.0: USB hub found
[    2.420207] hub 22-0:1.0: 1 port detected
[    2.449303] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.449342] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.449388] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.449736] ata1.00: ATA-9: M4-CT064M4SSD2, 0309, max UDMA/100
[    2.449742] ata1.00: 125045424 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.450157] ata1.00: configured for UDMA/100
[    2.450370] scsi 0:0:0:0: Direct-Access     ATA      M4-CT064M4SSD2   0309 PQ: 0 ANSI: 5
[    2.452084] ata3.00: HPA detected: current 2930275055, native 2930277168
[    2.452185] ata3.00: ATA-8: WDC WD15EADS-00P8B0, 01.00A01, max UDMA/133
[    2.452192] ata3.00: 2930275055 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.452757] ata2.00: ATA-8: WDC WD20EARX-00PASB0, 51.0AB51, max UDMA/133
[    2.452764] ata2.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.455192] ata3.00: configured for UDMA/133
[    2.456801] ata2.00: configured for UDMA/133
[    2.456981] scsi 1:0:0:0: Direct-Access     ATA      WDC WD20EARX-00P 51.0 PQ: 0 ANSI: 5
[    2.457404] scsi 2:0:0:0: Direct-Access     ATA      WDC WD15EADS-00P 01.0 PQ: 0 ANSI: 5
[    2.470706] sd 0:0:0:0: [sda] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
[    2.470768] sd 1:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    2.470775] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    2.470833] sd 2:0:0:0: [sdc] 2930275055 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    2.470905] sd 1:0:0:0: [sdb] Write Protect is off
[    2.470912] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.470919] sd 0:0:0:0: [sda] Write Protect is off
[    2.470930] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.470953] sd 2:0:0:0: [sdc] Write Protect is off
[    2.470960] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.470984] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.470993] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.471015] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.471992]  sda: sda1 sda2
[    2.474752] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.525293]  sdb: sdb1 sdb2 sdb3
[    2.525818]  sdc: sdc1 sdc2 < sdc5 >
[    2.526120] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.527024] sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.962223] usb 10-1: new high-speed USB device number 2 using ehci_hcd
[    2.971964] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    3.086715] usb 10-1: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 2
[    3.192026] usb 12-1: new high-speed USB device number 2 using ehci_hcd
[    3.234403] udevd[163]: starting version 185
[    3.262844] FS-Cache: Loaded
[    3.268414] RPC: Registered named UNIX socket transport module.
[    3.268417] RPC: Registered udp transport module.
[    3.268419] RPC: Registered tcp transport module.
[    3.268420] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.276911] NFS: Registering the id_resolver key type
[    3.276926] FS-Cache: Netfs 'nfs' registered for caching
[    3.278556] systemd-modules-load[166]: Inserted module 'nfs'
[    3.286940] ACPI: acpi_idle registered with cpuidle
[    3.288047] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    3.288053] ACPI: Power Button [PWRB]
[    3.288131] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    3.288135] ACPI: Power Button [PWRF]
[    3.295824] vboxdrv: Found 6 processor cores.
[    3.296531] VBoxDrv: dbg - g_abExecMemory=ffffffffa030f0e0
[    3.296654] vboxdrv: fAsync=0 offMin=0x243 offMax=0x3ca8
[    3.296998] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[    3.297001] vboxdrv: Successfully loaded version 4.1.18_OSE (interface 0x00190000).
[    3.304254] vboxpci: IOMMU not found (not registered)
[    3.319963] usb 12-1: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 2
[    3.320931] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.321050] r8169 0000:04:00.0: irq 42 for MSI/MSI-X
[    3.330200] r8169 0000:04:00.0: eth0: RTL8168evl/8111evl at 0xffffc900125e0000, 50:e5:49:b9:1f:d0, XID 0c900800 IRQ 42
[    3.330205] r8169 0000:04:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    3.348333] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
[    3.348605] sp5100_tco: mmio address 0xb8fe00 already in use
[    3.352177] Linux media interface: v0.10
[    3.357228] Linux video capture interface: v2.00
[    3.359297] wmi: Mapper loaded
[    3.370276] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    3.372428] dvb-usb: found a 'TeVii S660 USB' in cold state, will try to load a firmware
[    3.378726] EDAC MC: Ver: 2.1.0
[    3.380791] cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
[    3.384226] MCE: In-kernel MCE decoding enabled.
[    3.385118] AMD64 EDAC driver v3.4.0
[    3.393131] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
[    3.400869] powernow-k8: Found 1 AMD FX(tm)-6100 Six-Core Processor              (6 cpu cores) (version 2.20.00)
[    3.400885] powernow-k8: Core Performance Boosting: on.
[    3.400938] powernow-k8:    0 : pstate 0 (3300 MHz)
[    3.400941] powernow-k8:    1 : pstate 1 (3000 MHz)
[    3.400943] powernow-k8:    2 : pstate 2 (2400 MHz)
[    3.400945] powernow-k8:    3 : pstate 3 (1800 MHz)
[    3.400946] powernow-k8:    4 : pstate 4 (1400 MHz)
[    3.401767] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps (2013:024f, interface 0, class 0)
[    3.401770] em28xx: DVB interface 0 found
[    3.402055] em28xx #0: chip ID is em28174
[    3.402381] input: HDA ATI SB Line as /devices/pci0000:00/0000:00:14.2/sound/card0/input3
[    3.403038] input: HDA ATI SB Front Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input4
[    3.403584] input: HDA ATI SB Rear Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input5
[    3.404207] input: HDA ATI SB Front Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input6
[    3.404476] input: HDA ATI SB Line Out Side as /devices/pci0000:00/0000:00:14.2/sound/card0/input7
[    3.405152] microcode: CPU0: patch_level=0x06000613
[    3.405460] input: HDA ATI SB Line Out CLFE as /devices/pci0000:00/0000:00:14.2/sound/card0/input8
[    3.405745] input: HDA ATI SB Line Out Surround as /devices/pci0000:00/0000:00:14.2/sound/card0/input9
[    3.406187] input: HDA ATI SB Line Out Front as /devices/pci0000:00/0000:00:14.2/sound/card0/input10
[    3.409709] ACPI Warning: 0x0000000000000b00-0x0000000000000b07 SystemIO conflicts with Region \SOR1 1 (20120320/utaddress-251)
[    3.409716] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.410141] hda_intel: Disabling MSI
[    3.415719] EDAC amd64: DRAM ECC disabled.
[    3.415729] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[    3.415731]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[    3.415735]  (Note that use of the override may cause unknown side effects.)
[    3.418826] nvidia: module license 'NVIDIA' taints kernel.
[    3.418829] Disabling lock debugging due to kernel taint
[    3.425250] firewire_ohci 0000:06:0e.0: added OHCI v1.10 device as card 0, 4 IR + 8 IT contexts, quirks 0x11
[    3.427571] cx88[0]: subsystem: 18ac:db50, board: DViCO FusionHDTV DVB-T Dual Digital [card=44,autodetected], frontend(s): 1
[    3.427574] cx88[0]: TV tuner type 4, Radio tuner type -1
[    3.431827] Registered IR keymap rc-rc6-mce
[    3.432317] input: Media Center Ed. eHome Infrared Remote Transceiver (147a:e017) as /devices/pci0000:00/0000:00:04.0/0000:02:00.0/usb2/2-2/2-2:1.0/rc/rc0/input11
[    3.432323] rc0: Media Center Ed. eHome Infrared Remote Transceiver (147a:e017) as /devices/pci0000:00/0000:00:04.0/0000:02:00.0/usb2/2-2/2-2:1.0/rc/rc0
[    3.434938] IR NEC protocol handler initialized
[    3.437835] IR RC5(x) protocol handler initialized
[    3.439896] IR RC6 protocol handler initialized
[    3.442347] IR JVC protocol handler initialized
[    3.444354] IR Sony protocol handler initialized
[    3.447188] IR SANYO protocol handler initialized
[    3.448468] input: MCE IR Keyboard/Mouse (mceusb) as /devices/virtual/input/input12
[    3.449321] IR MCE Keyboard/mouse protocol handler initialized
[    3.452410] lirc_dev: IR Remote Control driver registered, major 250
[    3.453439] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
[    3.453442] IR LIRC bridge handler initialized
[    3.460209] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    3.460211] dw2102: start downloading DW210X firmware
[    3.462835] microcode: failed to load file amd-ucode/microcode_amd_fam15h.bin
[    3.462949] microcode: CPU1: patch_level=0x06000613
[    3.477597] microcode: failed to load file amd-ucode/microcode_amd_fam15h.bin
[    3.477663] microcode: CPU2: patch_level=0x06000613
[    3.479968] microcode: failed to load file amd-ucode/microcode_amd_fam15h.bin
[    3.480257] microcode: CPU3: patch_level=0x06000613
[    3.481624] microcode: failed to load file amd-ucode/microcode_amd_fam15h.bin
[    3.481723] microcode: CPU4: patch_level=0x06000613
[    3.482262] microcode: failed to load file amd-ucode/microcode_amd_fam15h.bin
[    3.482349] microcode: CPU5: patch_level=0x06000613
[    3.482706] microcode: failed to load file amd-ucode/microcode_amd_fam15h.bin
[    3.482841] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.578476] mceusb 2-2:1.0: Registered Formosa21 SnowflakeEmulation with mce emulator interface version 1
[    3.578484] usb 18-1: new full-speed USB device number 2 using ohci_hcd
[    3.578490] mceusb 2-2:1.0: 2 tx ports (0x0 cabled) and 2 rx sensors (0x0 active)
[    3.578517] usbcore: registered new interface driver mceusb
[    3.611805] dvb-usb: found a 'TeVii S660 USB' in warm state.
[    3.611907] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[    3.612284] DVB: registering new adapter (TeVii S660 USB)
[    3.710809] em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
[    3.734960] Registered IR keymap rc-pinnacle-pctv-hd
[    3.735051] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:04.0/0000:02:00.0/usb2/2-1/rc/rc1/input13
[    3.735102] rc1: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:04.0/0000:02:00.0/usb2/2-1/rc/rc1
[    3.736504] em28xx #0: v4l2 driver version 0.1.3
[    3.750725] em28xx #0: V4L2 video device registered as video0
[    3.752614] usbcore: registered new interface driver em28xx
[    3.766775] tda18271 2-0060: creating new instance
[    3.774515] TDA18271HD/C2 detected @ 2-0060
[    3.852454] dvb-usb: MAC address: 00:18:bd:5b:54:40
[    3.857024] DS3000 chip version: 0.192 attached.
[    3.857321] dw2102: Attached ds3000+ds2020!
[    3.857322]
[    3.857325] DVB: registering adapter 0 frontend 0 (Montage Technology DS3000/TS2020)...
[    3.858203] dvb-usb: TeVii S660 USB successfully initialized and connected.
[    3.858222] dvb-usb: found a 'TeVii S660 USB' in cold state, will try to load a firmware
[    3.858580] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    3.858582] dw2102: start downloading DW210X firmware
[    3.925010] firewire_core 0000:06:0e.0: created device fw0: GUID 0049e550b2e80400, S400
[    4.001500] usb 18-4: new full-speed USB device number 3 using ohci_hcd
[    4.011486] dvb-usb: found a 'TeVii S660 USB' in warm state.
[    4.011586] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[    4.011896] DVB: registering new adapter (TeVii S660 USB)
[    4.079657] DVB: registering new adapter (em28xx #0)
[    4.079660] DVB: registering adapter 2 frontend 0 (Sony CXD2820R)...
[    4.080000] em28xx #0: Successfully loaded em28xx-dvb
[    4.080004] Em28xx: Initialized (Em28xx dvb Extension) extension
[    4.161385] input: HDA NVidia HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input14
[    4.161502] input: HDA NVidia HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input15
[    4.161619] input: HDA NVidia HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input16
[    4.161752] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input17
[    4.162577] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    4.162821] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  302.17  Tue Jun 12 16:03:22 PDT 2012
[    4.195225] systemd-udevd[480]: failed to execute '/usr/lib/udev/ok_pcscd_hotplug.sh' 'ok_pcscd_hotplug.sh': No such file or directory
[    4.197118] systemd-udevd[483]: failed to execute '/usr/lib/udev/ok_pcscd_hotplug.sh' 'ok_pcscd_hotplug.sh': No such file or directory
[    4.200602] usbcore: registered new interface driver usbserial
[    4.200624] usbcore: registered new interface driver usbserial_generic
[    4.200697] USB Serial support registered for generic
[    4.232608] dvb-usb: MAC address: 00:18:bd:5b:54:41
[    4.235369] DS3000 chip version: 0.192 attached.
[    4.235597] dw2102: Attached ds3000+ds2020!
[    4.235598]
[    4.235614] DVB: registering adapter 1 frontend 0 (Montage Technology DS3000/TS2020)...
[    4.236092] dvb-usb: TeVii S660 USB successfully initialized and connected.
[    4.236134] usbcore: registered new interface driver dw2102
[    4.277850] usb 17-1: new high-speed USB device number 2 using ehci_hcd
[    4.403525] usbserial: USB Serial Driver core
[    4.404309] usbcore: registered new interface driver cp210x
[    4.404322] USB Serial support registered for cp210x
[    4.404422] cp210x 18-1:1.0: cp210x converter detected
[    4.425848] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
[    4.425906] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[    4.426152] DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
[    4.529289] DVB: registering adapter 4 frontend 0 (DiBcom 3000MC/P)...
[    4.534331] usb 18-1: reset full-speed USB device number 2 using ohci_hcd
[    4.534885] MT2060: successfully identified (IF1 = 1252)
[    4.593953] cx88[0]/0: found at 0000:06:07.0, rev: 5, irq: 21, latency: 32, mmio: 0xf8000000
[    4.594139] cx88[0]/0: registered device video1 [v4l2]
[    4.594171] cx88[0]/0: registered device vbi0
[    4.594196] cx88[0]/2: cx2388x 8802 Driver Manager
[    4.594213] cx88[0]/2: found at 0000:06:07.2, rev: 5, irq: 21, latency: 32, mmio: 0xf9000000
[    4.597817] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[    4.597821] cx88/2: registering cx8802 driver, type: dvb access: shared
[    4.597824] cx88[0]/2: subsystem: 18ac:db50, board: DViCO FusionHDTV DVB-T Dual Digital [card=44]
[    4.597828] cx88[0]/2: cx2388x based DVB/ATSC card
[    4.597841] cx8802_alloc_frontends() allocating 1 frontend(s)
[    4.601834] DVB: registering new adapter (cx88[0])
[    4.601837] DVB: registering adapter 3 frontend 0 (Zarlink MT352 DVB-T)...
[    4.687753] usb 18-1: cp210x converter now attached to ttyUSB0
[    4.810784] usb 11-2: new full-speed USB device number 2 using ohci_hcd
[    4.995343] usbcore: registered new interface driver usbhid
[    4.995345] usbhid: USB HID core driver
[    4.999048] ortek 0003:05A4:2000.0001: Fixing up logical minimum in report descriptor (Ortek)
[    4.999236] input: ORTEK Smartpad Keyboard as /devices/pci0000:00/0000:00:12.0/usb11/11-2/11-2:1.0/input/input18
[    4.999405] ortek 0003:05A4:2000.0001: input,hidraw0: USB HID v1.10 Keyboard [ORTEK Smartpad Keyboard] on usb-0000:00:12.0-2/input0
[    5.004576] input: ORTEK Smartpad Keyboard as /devices/pci0000:00/0000:00:12.0/usb11/11-2/11-2:1.1/input/input19
[    5.005401] ortek 0003:05A4:2000.0002: input,hiddev0,hidraw1: USB HID v1.10 Mouse [ORTEK Smartpad Keyboard] on usb-0000:00:12.0-2/input1
[    5.040978] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[    5.041177] DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
[    5.047118] DVB: registering adapter 5 frontend 0 (DiBcom 3000MC/P)...
[    5.051717] MT2060: successfully identified (IF1 = 1242)
[    5.582318] dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully initialized and connected.
[    5.582444] dib0700: rc submit urb failed
[    5.582445]
[    5.582642] usbcore: registered new interface driver dvb_usb_dib0700
[    5.728942] Btrfs loaded
[    5.729437] device fsid e0b3363c-9a13-4e53-9cd7-9c569271ea29 devid 2 transid 336060 /dev/sdc1
[    5.756444] device fsid feeffb5f-cb04-4295-9758-9184717bfa31 devid 1 transid 75902 /dev/sdc5
[    5.785251] device fsid e6c092cd-ccb3-47b6-976a-0096b1795359 devid 1 transid 663 /dev/sdb
[    5.807493] device fsid e0b3363c-9a13-4e53-9cd7-9c569271ea29 devid 1 transid 336060 /dev/sdb1
[    5.828225] device fsid b7d1bc68-45a1-493e-bfaa-d2d134b63fe6 devid 1 transid 7 /dev/sdb2
[    7.481761] irq 18: nobody cared (try booting with the "irqpoll" option)
[    7.481822] Pid: 0, comm: swapper/2 Tainted: P           O 3.4.4-1-custom #1
[    7.481824] Call Trace:
[    7.481825]  <IRQ>  [<ffffffff810cd82d>] __report_bad_irq+0x3d/0xe0
[    7.481835]  [<ffffffff810cdb29>] note_interrupt+0x1a9/0x200
[    7.481838]  [<ffffffff810cb4be>] handle_irq_event_percpu+0xbe/0x270
[    7.481841]  [<ffffffff810cb6b8>] handle_irq_event+0x48/0x70
[    7.481845]  [<ffffffff810ce61a>] handle_fasteoi_irq+0x5a/0x100
[    7.481848]  [<ffffffff810166b2>] handle_irq+0x22/0x40
[    7.481852]  [<ffffffff8142b5aa>] do_IRQ+0x5a/0xe0
[    7.481854]  [<ffffffff81428fea>] common_interrupt+0x6a/0x6a
[    7.481856]  <EOI>  [<ffffffff8101c659>] ? read_tsc+0x9/0x20
[    7.481875]  [<ffffffffa01b5007>] ? acpi_idle_enter_simple+0xf9/0x13d [processor]
[    7.481883]  [<ffffffffa01b5003>] ? acpi_idle_enter_simple+0xf5/0x13d [processor]
[    7.481888]  [<ffffffff8133f6de>] cpuidle_enter+0x1e/0x20
[    7.481891]  [<ffffffff8133fd26>] cpuidle_idle_call+0xa6/0x330
[    7.481894]  [<ffffffff8101eb3f>] cpu_idle+0xbf/0x130
[    7.481897]  [<ffffffff81418038>] start_secondary+0x203/0x20a
[    7.481900] handlers:
[    7.481960] [<ffffffffa000a570>] usb_hcd_irq
[    7.482060] [<ffffffffa000a570>] usb_hcd_irq
[    7.482162] [<ffffffffa000a570>] usb_hcd_irq
[    7.482264] [<ffffffffa000a570>] usb_hcd_irq
[    7.482364] [<ffffffffa000a570>] usb_hcd_irq
[    7.482467] [<ffffffffa000a570>] usb_hcd_irq
[    7.482572] [<ffffffffa0195050>] azx_interrupt
[    7.482683] Disabling IRQ #18
