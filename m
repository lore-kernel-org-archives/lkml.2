Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab1DGRPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:15:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64365 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab1DGRPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:15:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q0yy75FnyKilFoWUKON/XPMVCV61eCZCnHD7zt6xqbk6LaR5VqaaihMWzBgrzDVP9u
         GtLXzs4J7n8XYHgmHgtEZ7L/vdTFUTPT2oTeNhE9EBgwsaY6NpzDi0U3hVtZvrIS5DtS
         f1PdQG7lA99bA0KbdeZGs9dmCeM0EJeaW7ibg=
Date: Thu, 7 Apr 2011 19:15:17 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: gma500 driver feedback on sony vaio p21z
Message-ID: <20110407171517.GB4671@Boggieman>
Reply-To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <20110407102215.GB2911@Boggieman>
 <20110407131557.0531d41a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20110407131557.0531d41a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Apr 07, 2011 at 01:15:57PM +0100, Alan Cox wrote:
> On Thu, 7 Apr 2011 12:22:15 +0200
> Kristoffer Ericson <kristoffer.ericson@gmail.com> wrote:
> 
> > Hey,
> > 
> > Is 1024x768 hardcoded in the driver atm? It looks strange on
> > my sony since the native resolution should be 1600x768 and
> > I effectivly get a black screen area of the difference in pixels.
> 
> The resolution is autodetected so ought to be right but I don't doubt it
> will fail for something! Firstly however how much stolen RAM is your
> system reporting and can you send me a dmesg ?

Lol, I didnt even bother look at the dmesg :D 
Looks like its not happy with the backlight init:
Attached full dmesg

[    1.965676] fb0: psbfb frame buffer device
[    1.965681] drm: registered panic notifier
[    1.965698] ------------[ cut here ]------------
[    1.965715] WARNING: at drivers/video/backlight/backlight.c:314 backlight_device_register+0xd0/0x137()
[    1.965723] Hardware name: VGN-P21Z_R
[    1.965728] psb-bl: invalid backlight type
[    1.965733] Modules linked in:
[    1.965742] Pid: 1, comm: swapper Not tainted 2.6.39-rc1-hpc+ #4
[    1.965750] Call Trace:
[    1.965766]  [<c103362c>] ? warn_slowpath_common+0x6a/0x7b
[    1.965776]  [<c11e3161>] ? backlight_device_register+0xd0/0x137
[    1.965785]  [<c10336a3>] ? warn_slowpath_fmt+0x28/0x2c
[    1.965794]  [<c11e3161>] ? backlight_device_register+0xd0/0x137
[    1.965807]  [<c131e603>] ? psb_backlight_init+0x32/0x185
[    1.965816]  [<c1320467>] ? psb_driver_load+0x47f/0x4b6
[    1.965827]  [<c12438f8>] ? drm_get_pci_dev+0x12f/0x20b
[    1.965837]  [<c11c6e28>] ? local_pci_probe+0x34/0x74
[    1.965845]  [<c11c7806>] ? pci_device_probe+0x41/0x63
[    1.965856]  [<c1282019>] ? driver_probe_device+0x8c/0x110
[    1.965864]  [<c12820dd>] ? __driver_attach+0x40/0x5b
[    1.965873]  [<c1281875>] ? bus_for_each_dev+0x37/0x5f
[    1.965882]  [<c1281ecf>] ? driver_attach+0x11/0x13
[    1.965890]  [<c128209d>] ? driver_probe_device+0x110/0x110
[    1.965899]  [<c1281bf0>] ? bus_add_driver+0x87/0x1bb
[    1.965909]  [<c11af944>] ? kset_find_obj_hinted+0x43/0x7d
[    1.965919]  [<c15de581>] ? staging_init+0x3/0x3
[    1.965928]  [<c128251c>] ? driver_register+0x7a/0xd9
[    1.965936]  [<c12439f7>] ? drm_pci_init+0x23/0xbc
[    1.965944]  [<c15de581>] ? staging_init+0x3/0x3
[    1.965952]  [<c11c79d1>] ? __pci_register_driver+0x33/0x89
[    1.965961]  [<c15de581>] ? staging_init+0x3/0x3
[    1.965970]  [<c1001150>] ? do_one_initcall+0x68/0x10f
[    1.965980]  [<c15b425b>] ? kernel_init+0xb3/0x12a
[    1.965989]  [<c15b41a8>] ? parse_early_options+0x18/0x18
[    1.965997]  [<c13c627e>] ? kernel_thread_helper+0x6/0xd
[    1.966004] ---[ end trace 269e1680fe8fb34d ]---
[    1.966082] [drm] Initialized pvrsrvkm 8.1.0 2009-03-10 for 0000:00:02.0 on minor 0
[    1.966145] Initializing network drop monitor service

> 
> Alan

--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg-sonyvaio.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.39-rc1-hpc+ (kristoffer@Boggieman) (gcc version 4.4.5 (Debian 4.4.5-8) ) #4 SMP Tue Apr 5 20:21:55 CEST 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f64d000 (usable)
[    0.000000]  BIOS-e820: 000000007f64d000 - 000000007f64e000 (reserved)
[    0.000000]  BIOS-e820: 000000007f64e000 - 000000007f656000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f656000 - 000000007f69f000 (reserved)
[    0.000000]  BIOS-e820: 000000007f69f000 - 000000007f6a2000 (usable)
[    0.000000]  BIOS-e820: 000000007f6a2000 - 000000007f6df000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f6df000 - 000000007f6ef000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f6ef000 - 000000007f6f0000 (usable)
[    0.000000]  BIOS-e820: 000000007f6f0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed40000 - 00000000fed4c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Sony Corporation VGN-P21Z_R/VAIO, BIOS R2073U3 01/13/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x7f6f0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 disabled
[    0.000000]   1 base 000000000 mask 080000000 write-back
[    0.000000]   2 base 07F800000 mask 0FF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 base 07F6F0000 mask 0FFFF0000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 000000007f6f0000 - 000000007f700000 (usable) ==> (reserved)
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 1bfb000-1c00000
[    0.000000] ACPI: RSDP 000fe020 00024 (v02   Sony)
[    0.000000] ACPI: XSDT 7f6ee120 00064 (v01   Sony     VAIO 20100113      01000013)
[    0.000000] ACPI: FACP 7f6ed000 000F4 (v03   Sony     VAIO 20100113 MSFT 01000013)
[    0.000000] ACPI Warning: Invalid length for Pm1aControlBlock: 32, using default 16 (20110316/tbfadt-610)
[    0.000000] ACPI: DSDT 7f6e2000 0574D (v01   Sony     VAIO 20100113 MSFT 01000013)
[    0.000000] ACPI: FACS 7f6a6000 00040
[    0.000000] ACPI: HPET 7f6ec000 00038 (v01   Sony     VAIO 20100113 MSFT 01000013)
[    0.000000] ACPI: APIC 7f6eb000 00068 (v01   Sony     VAIO 20100113 MSFT 01000013)
[    0.000000] ACPI: MCFG 7f6ea000 0003C (v01   Sony     VAIO 20100113 MSFT 01000013)
[    0.000000] ACPI: SLIC 7f6e9000 00176 (v01   Sony     VAIO 20100113 MSFT 01000013)
[    0.000000] ACPI: ASF! 7f6e8000 000A5 (v32   Sony     VAIO 20100113 MSFT 01000013)
[    0.000000] ACPI: BOOT 7f6e1000 00028 (v01   Sony     VAIO 20100113 MSFT 01000013)
[    0.000000] ACPI: SSDT 7f6df000 004CE (v02   Sony     VAIO 20100113 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1150MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0007f6f0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f64d
[    0.000000]     0: 0x0007f69f -> 0x0007f6a2
[    0.000000]     0: 0x0007f6ef -> 0x0007f6f0
[    0.000000] On node 0 totalpages: 521696
[    0.000000] free_area_init_node: node 0, pgdat c15abe40, node_mem_map f680d200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2302 pages used for memmap
[    0.000000]   HighMem zone: 292181 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f6400000 s27264 r0 d21888 u2097152
[    0.000000] pcpu-alloc: s27264 r0 d21888 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517618
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.39-gma500 root=/dev/sda3 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0007f6f0)
[    0.000000] Memory: 2062624k/2087872k available (3867k kernel code, 24160k reserved, 1968k data, 428k init, 1177932k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc15b4000 - 0xc161f000   ( 428 kB)
[    0.000000]       .data : 0xc13c6d80 - 0xc15b30c0   (1968 kB)
[    0.000000]       .text : 0xc1000000 - 0xc13c6d80   (3867 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:1280
[    0.000000] CPU 0 irqstacks, hard=f600e000 soft=f6020000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1333.156 MHz processor.
[    0.004007] Calibrating delay loop (skipped), value calculated using timer frequency.. 2666.31 BogoMIPS (lpj=5332624)
[    0.004020] pid_max: default: 32768 minimum: 301
[    0.004264] Security Framework initialized
[    0.004294] TOMOYO Linux initialized
[    0.004388] Mount-cache hash table entries: 512
[    0.005151] Initializing cgroup subsys ns
[    0.005160] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.005168] Initializing cgroup subsys cpuacct
[    0.005234] Initializing cgroup subsys devices
[    0.005240] Initializing cgroup subsys freezer
[    0.005245] Initializing cgroup subsys net_cls
[    0.005346] CPU: Physical Processor ID: 0
[    0.005351] CPU: Processor Core ID: 0
[    0.005358] mce: CPU supports 5 MCE banks
[    0.005377] CPU0: Thermal monitoring enabled (TM2)
[    0.005385] using mwait in idle threads.
[    0.007380] ACPI: Core revision 20110316
[    0.016150] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.016499] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.057502] CPU0: Intel(R) Atom(TM) CPU Z520   @ 1.33GHz stepping 02
[    0.060003] Performance Events: PEBS fmt0+, Atom events, Intel PMU driver.
[    0.060003] ... version:                3
[    0.060003] ... bit width:              40
[    0.060003] ... generic registers:      2
[    0.060003] ... value mask:             000000ffffffffff
[    0.060003] ... max period:             000000007fffffff
[    0.060003] ... fixed-purpose events:   3
[    0.060003] ... event mask:             0000000700000003
[    0.060003] CPU 1 irqstacks, hard=f609a000 soft=f609c000
[    0.060003] Booting Node   0, Processors  #1 Ok.
[    0.060003] smpboot cpu 1: start_ip = 9b000
[    0.008000] Initializing CPU#1
[    0.148038] Brought up 2 CPUs
[    0.148048] Total of 2 processors activated (5332.77 BogoMIPS).
[    0.148409] devtmpfs: initialized
[    0.148736] PM: Registering ACPI NVS region at 7f64e000 (32768 bytes)
[    0.148736] PM: Registering ACPI NVS region at 7f6a2000 (249856 bytes)
[    0.148736] print_constraints: dummy: 
[    0.148736] NET: Registered protocol family 16
[    0.149041] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.149050] ACPI: bus type pci registered
[    0.149336] dca service started, version 1.12.1
[    0.149414] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.149424] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.149430] PCI: Using MMCONFIG for extended config space
[    0.149435] PCI: Using configuration type 1 for base access
[    0.153865] bio: create slab <bio-0> at 0
[    0.157604] ACPI: EC: Look up EC in DSDT
[    0.160531] ACPI: Executed 1 blocks of module-level executable AML code
[    0.178411] ACPI: SSDT 7f658c90 001F7 (v02   Sony     VAIO 20100113 INTL 20051117)
[    0.179137] ACPI: Dynamic OEM Table Load:
[    0.179147] ACPI: SSDT   (null) 001F7 (v02   Sony     VAIO 20100113 INTL 20051117)
[    0.179557] ACPI: SSDT 7f657690 00650 (v02   Sony     VAIO 20100113 INTL 20051117)
[    0.180241] ACPI: Dynamic OEM Table Load:
[    0.180250] ACPI: SSDT   (null) 00650 (v02   Sony     VAIO 20100113 INTL 20051117)
[    0.204792] ACPI: SSDT 7f658f10 000D0 (v02   Sony     VAIO 20100113 INTL 20051117)
[    0.205487] ACPI: Dynamic OEM Table Load:
[    0.205495] ACPI: SSDT   (null) 000D0 (v02   Sony     VAIO 20100113 INTL 20051117)
[    0.205759] ACPI: SSDT 7f656f10 00083 (v02   Sony     VAIO 20100113 INTL 20051117)
[    0.206431] ACPI: Dynamic OEM Table Load:
[    0.206439] ACPI: SSDT   (null) 00083 (v02   Sony     VAIO 20100113 INTL 20051117)
[    0.228711] ACPI: Interpreter enabled
[    0.228725] ACPI: (supports S0 S3 S4 S5)
[    0.228783] ACPI: Using IOAPIC for interrupt routing
[    0.238172] ACPI: EC: GPE = 0xd, I/O: command/status = 0x66, data = 0x62
[    0.238506] ACPI: No dock devices found.
[    0.238516] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.239009] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.239897] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.239907] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.239915] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.239924] pci_root PNP0A08:00: host bridge window [mem 0x7f800000-0x7fffffff]
[    0.239932] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.239940] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000effff]
[    0.239947] pci_root PNP0A08:00: host bridge window [mem 0x000f0000-0x000fffff]
[    0.239956] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff]
[    0.239988] pci 0000:00:00.0: [8086:8100] type 0 class 0x000600
[    0.240096] pci 0000:00:02.0: [8086:8108] type 0 class 0x000300
[    0.240129] pci 0000:00:02.0: reg 10: [mem 0x94200000-0x9427ffff]
[    0.240147] pci 0000:00:02.0: reg 14: [io  0x6070-0x6077]
[    0.240163] pci 0000:00:02.0: reg 18: [mem 0x80000000-0x8fffffff]
[    0.240180] pci 0000:00:02.0: reg 1c: [mem 0x94280000-0x942bffff]
[    0.240304] pci 0000:00:1b.0: [8086:811b] type 0 class 0x000403
[    0.240330] pci 0000:00:1b.0: reg 10: [mem 0x942c0000-0x942c3fff 64bit]
[    0.240402] pci 0000:00:1b.0: PME# supported from D0 D3hot
[    0.240412] pci 0000:00:1b.0: PME# disabled
[    0.240445] pci 0000:00:1c.0: [8086:8110] type 1 class 0x000604
[    0.240518] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.240527] pci 0000:00:1c.0: PME# disabled
[    0.240561] pci 0000:00:1c.1: [8086:8112] type 1 class 0x000604
[    0.240633] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.240642] pci 0000:00:1c.1: PME# disabled
[    0.240681] pci 0000:00:1d.0: [8086:8114] type 0 class 0x000c03
[    0.240733] pci 0000:00:1d.0: reg 20: [io  0x6040-0x605f]
[    0.240780] pci 0000:00:1d.1: [8086:8115] type 0 class 0x000c03
[    0.240832] pci 0000:00:1d.1: reg 20: [io  0x6020-0x603f]
[    0.240878] pci 0000:00:1d.2: [8086:8116] type 0 class 0x000c03
[    0.240930] pci 0000:00:1d.2: reg 20: [io  0x6000-0x601f]
[    0.240991] pci 0000:00:1d.7: [8086:8117] type 0 class 0x000c03
[    0.241026] pci 0000:00:1d.7: reg 10: [mem 0x00000000-0x000003ff]
[    0.241140] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.241150] pci 0000:00:1d.7: PME# disabled
[    0.241182] pci 0000:00:1f.0: [8086:8119] type 0 class 0x000601
[    0.241279] pci 0000:00:1f.1: [8086:811a] type 0 class 0x000101
[    0.241333] pci 0000:00:1f.1: reg 20: [io  0x6060-0x606f]
[    0.241454] pci 0000:01:00.0: [11ab:4380] type 0 class 0x000200
[    0.241489] pci 0000:01:00.0: reg 10: [mem 0x93100000-0x93103fff 64bit]
[    0.241510] pci 0000:01:00.0: reg 18: [io  0x4000-0x40ff]
[    0.241567] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.241620] pci 0000:01:00.0: supports D1 D2
[    0.241627] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.241637] pci 0000:01:00.0: PME# disabled
[    0.241679] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.241689] pci 0000:00:1c.0:   bridge window [io  0x4000-0x5fff]
[    0.241699] pci 0000:00:1c.0:   bridge window [mem 0x93100000-0x941fffff]
[    0.241709] pci 0000:00:1c.0:   bridge window [mem 0x90000000-0x90ffffff pref]
[    0.241788] pci 0000:02:00.0: [168c:002a] type 0 class 0x000280
[    0.241822] pci 0000:02:00.0: reg 10: [mem 0x92000000-0x9200ffff 64bit]
[    0.241932] pci 0000:02:00.0: supports D1
[    0.241939] pci 0000:02:00.0: PME# supported from D0 D1 D3hot
[    0.241948] pci 0000:02:00.0: PME# disabled
[    0.241991] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.242001] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.242011] pci 0000:00:1c.1:   bridge window [mem 0x92000000-0x930fffff]
[    0.242021] pci 0000:00:1c.1:   bridge window [mem 0x91000000-0x91ffffff pref]
[    0.242041] pci_bus 0000:00: on NUMA node 0
[    0.242050] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.242361] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.242501] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.242695]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.242702] Unable to assume _OSC PCIe control. Disabling ASPM
[    0.248517] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 *7 9 10 11 12)
[    0.248681] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 7 9 10 11 12)
[    0.248841] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.249001] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 *10 11 12)
[    0.249161] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 *11 12)
[    0.249321] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 *11 12)
[    0.249481] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 *11 12)
[    0.249642] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    0.249881] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.249898] vgaarb: loaded
[    0.250218] SCSI subsystem initialized
[    0.250278] libata version 3.00 loaded.
[    0.250278] PCI: Using ACPI for IRQ routing
[    0.250278] PCI: pci_cache_line_size set to 64 bytes
[    0.250278] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.250278] reserve RAM buffer: 000000007f64d000 - 000000007fffffff 
[    0.250278] reserve RAM buffer: 000000007f6a2000 - 000000007fffffff 
[    0.250278] reserve RAM buffer: 000000007f6f0000 - 000000007fffffff 
[    0.250278] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.252069] Switching to clocksource hpet
[    0.255793] Switched to NOHz mode on CPU #0
[    0.255872] Switched to NOHz mode on CPU #1
[    0.256906] pnp: PnP ACPI init
[    0.256954] ACPI: bus type pnp registered
[    0.257839] pnp 00:00: [bus 00-ff]
[    0.257849] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.257857] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.257864] pnp 00:00: [io  0x0d00-0xffff window]
[    0.257871] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.257879] pnp 00:00: [mem 0x7f800000-0x7fffffff window]
[    0.257887] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.257894] pnp 00:00: [mem 0x000e0000-0x000effff window]
[    0.257908] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.257916] pnp 00:00: [mem 0x80000000-0xfebfffff window]
[    0.258059] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.258300] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.258308] pnp 00:01: [mem 0xfed10000-0xfed13fff]
[    0.258315] pnp 00:01: [mem 0x40000000-0x7fffffff]
[    0.258322] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    0.258329] pnp 00:01: [mem 0xfed40000-0xfed4bfff]
[    0.258336] pnp 00:01: [mem 0xfee00000-0xfee00fff]
[    0.258343] pnp 00:01: [mem 0xffc00000-0xffc3ffff]
[    0.258457] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.258467] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.258476] system 00:01: [mem 0x40000000-0x7fffffff] could not be reserved
[    0.258485] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.258494] system 00:01: [mem 0xfed40000-0xfed4bfff] has been reserved
[    0.258503] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.258511] system 00:01: [mem 0xffc00000-0xffc3ffff] has been reserved
[    0.258521] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.259100] pnp 00:02: Plug and Play ACPI device, IDs SNY6001 (disabled)
[    0.259132] pnp 00:03: [mem 0xff000000-0xffffffff]
[    0.259215] pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
[    0.259308] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.259426] system 00:04: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.259437] system 00:04: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.259477] pnp 00:05: [io  0x0070-0x0077]
[    0.259502] pnp 00:05: [irq 8]
[    0.259595] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.259636] pnp 00:06: [io  0x002e-0x002f]
[    0.259643] pnp 00:06: [io  0x004e-0x004f]
[    0.259649] pnp 00:06: [io  0x0061]
[    0.259655] pnp 00:06: [io  0x0063]
[    0.259661] pnp 00:06: [io  0x0065]
[    0.259667] pnp 00:06: [io  0x0067]
[    0.259674] pnp 00:06: [io  0x0080-0x0083]
[    0.259680] pnp 00:06: [io  0x0092]
[    0.259686] pnp 00:06: [io  0x00b2-0x00b3]
[    0.259692] pnp 00:06: [io  0x2000]
[    0.259699] pnp 00:06: [io  0x2004]
[    0.259705] pnp 00:06: [io  0x0820-0x0823]
[    0.259711] pnp 00:06: [io  0x0000]
[    0.259718] pnp 00:06: [io  0x0084-0x008f]
[    0.259724] pnp 00:06: [io  0x0374-0x0375]
[    0.259731] pnp 00:06: [io  0x0377]
[    0.259737] pnp 00:06: [io  0x03f4-0x03f5]
[    0.259743] pnp 00:06: [io  0x03f7]
[    0.259749] pnp 00:06: [io  0x0400-0x040f]
[    0.259756] pnp 00:06: [io  0x0410-0x041f]
[    0.259762] pnp 00:06: [io  0x0600-0x063f]
[    0.259769] pnp 00:06: [io  0x0500-0x055f]
[    0.259775] pnp 00:06: [io  0x1040-0x107f]
[    0.259946] system 00:06: [io  0x2000] has been reserved
[    0.259955] system 00:06: [io  0x2004] has been reserved
[    0.259964] system 00:06: [io  0x0820-0x0823] has been reserved
[    0.259973] system 00:06: [io  0x0374-0x0375] has been reserved
[    0.259981] system 00:06: [io  0x0377] has been reserved
[    0.259990] system 00:06: [io  0x03f4-0x03f5] has been reserved
[    0.259998] system 00:06: [io  0x03f7] has been reserved
[    0.260048] system 00:06: [io  0x0400-0x040f] has been reserved
[    0.260057] system 00:06: [io  0x0410-0x041f] has been reserved
[    0.260065] system 00:06: [io  0x0600-0x063f] has been reserved
[    0.260074] system 00:06: [io  0x0500-0x055f] has been reserved
[    0.260082] system 00:06: [io  0x1040-0x107f] has been reserved
[    0.260092] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.260132] pnp 00:07: [io  0x0060]
[    0.260139] pnp 00:07: [io  0x0064]
[    0.260153] pnp 00:07: [irq 1]
[    0.260244] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.260281] pnp 00:08: [irq 12]
[    0.260369] pnp 00:08: Plug and Play ACPI device, IDs SNY9010 PNP0f13 (active)
[    0.260418] pnp: PnP ACPI: found 9 devices
[    0.260423] ACPI: ACPI bus type pnp unregistered
[    0.299758] pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    0.299802] pci 0000:00:1d.7: BAR 0: assigned [mem 0x942c4000-0x942c43ff]
[    0.299817] pci 0000:00:1d.7: BAR 0: set to [mem 0x942c4000-0x942c43ff] (PCI address [0x942c4000-0x942c43ff])
[    0.299828] pci 0000:01:00.0: BAR 6: assigned [mem 0x90000000-0x9001ffff pref]
[    0.299837] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.299845] pci 0000:00:1c.0:   bridge window [io  0x4000-0x5fff]
[    0.299856] pci 0000:00:1c.0:   bridge window [mem 0x93100000-0x941fffff]
[    0.299867] pci 0000:00:1c.0:   bridge window [mem 0x90000000-0x90ffffff pref]
[    0.299880] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.299888] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.299899] pci 0000:00:1c.1:   bridge window [mem 0x92000000-0x930fffff]
[    0.299909] pci 0000:00:1c.1:   bridge window [mem 0x91000000-0x91ffffff pref]
[    0.299948] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.299959] pci 0000:00:1c.0: setting latency timer to 64
[    0.299979] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.299988] pci 0000:00:1c.1: setting latency timer to 64
[    0.299998] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.300022] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.300030] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.300037] pci_bus 0000:00: resource 7 [mem 0x7f800000-0x7fffffff]
[    0.300045] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000dffff]
[    0.300053] pci_bus 0000:00: resource 9 [mem 0x000e0000-0x000effff]
[    0.300061] pci_bus 0000:00: resource 10 [mem 0x000f0000-0x000fffff]
[    0.300069] pci_bus 0000:00: resource 11 [mem 0x80000000-0xfebfffff]
[    0.300077] pci_bus 0000:01: resource 0 [io  0x4000-0x5fff]
[    0.300084] pci_bus 0000:01: resource 1 [mem 0x93100000-0x941fffff]
[    0.300092] pci_bus 0000:01: resource 2 [mem 0x90000000-0x90ffffff pref]
[    0.300100] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.300108] pci_bus 0000:02: resource 1 [mem 0x92000000-0x930fffff]
[    0.300115] pci_bus 0000:02: resource 2 [mem 0x91000000-0x91ffffff pref]
[    0.300295] NET: Registered protocol family 2
[    0.300514] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.301232] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.302488] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.303162] TCP: Hash tables configured (established 131072 bind 65536)
[    0.303170] TCP reno registered
[    0.303182] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.303209] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.303730] NET: Registered protocol family 1
[    0.303782] pci 0000:00:02.0: Boot video device
[    0.303880] PCI: CLS 0 bytes, default 64
[    0.304084] Simple Boot Flag at 0x44 set to 0x1
[    0.305037] microcode: CPU0 sig=0x106c2, pf=0x1, revision=0x217
[    0.305059] microcode: CPU1 sig=0x106c2, pf=0x1, revision=0x217
[    0.305128] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.305708] audit: initializing netlink socket (disabled)
[    0.305734] type=2000 audit(1302173619.300:1): initialized
[    0.343108] highmem bounce pool size: 64 pages
[    0.343121] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.348391] VFS: Disk quotas dquot_6.5.2
[    0.348704] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.351121] msgmni has been set to 1727
[    0.354502] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.354511] io scheduler noop registered
[    0.354517] io scheduler deadline registered
[    0.354565] io scheduler cfq registered (default)
[    0.355058] intel_idle: MWAIT substates: 0x3020220
[    0.355080] intel_idle: v0.4 model 0x1C
[    0.355086] intel_idle: lapic_timer_reliable_states 0x2
[    0.355118] Marking TSC unstable due to TSC halts in idle states deeper than C2
[    0.356084] ACPI: AC Adapter [AC] (on-line)
[    0.357480] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.357875] ACPI: Lid Switch [LID0]
[    0.358031] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.358043] ACPI: Power Button [PWRB]
[    0.358340] ACPI: acpi_idle yielding to intel_idle
[    0.363133] thermal LNXTHERM:00: registered as thermal_zone0
[    0.363142] ACPI: Thermal Zone [ATF0] (34 C)
[    0.363635] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.369878] ACPI: Battery Slot [BAT0] (battery present)
[    0.572605] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    0.572679] sonypi: please try the sony-laptop module instead and report failures, see also http://www.linux.it/~malattia/wiki/index.php/Sony_drivers
[    0.572791] sonypi: detected type2 model, verbose = 0, fnkeyinit = off, camera = off, compat = off, mask = 0xffffffff, useinput = on, acpi = on
[    0.572801] sonypi: enabled at irq=11, port1=0x1080, port2=0x1084
[    0.572806] sonypi: device allocated minor is 61
[    0.572958] input: Sony Vaio Jogdial as /devices/platform/sonypi/input/input2
[    0.573129] input: Sony Vaio Keys as /devices/platform/sonypi/input/input3
[    0.618876] sonypi command failed at drivers/char/sonypi.c : sonypi_call1 (line 654)
[    0.663103] sonypi command failed at drivers/char/sonypi.c : sonypi_call2 (line 665)
[    0.707327] sonypi command failed at drivers/char/sonypi.c : sonypi_call2 (line 667)
[    0.751546] sonypi command failed at drivers/char/sonypi.c : sonypi_call1 (line 654)
[    0.751705] Non-volatile memory driver v1.3
[    0.751804] Linux agpgart interface v0.103
[    0.751894] [drm] Initialized drm 1.1.0 20060810
[    0.751947] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    0.754126] loop: module loaded
[    0.755000] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    0.755348] pata_sch 0000:00:1f.1: version 0.2
[    0.755423] pata_sch 0000:00:1f.1: setting latency timer to 64
[    0.756110] scsi0 : pata_sch
[    0.756347] scsi1 : pata_sch
[    0.757063] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6060 irq 14
[    0.757071] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6068 irq 15
[    0.757350] sky2: driver version 1.28
[    0.757396] sky2 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.757416] sky2 0000:01:00.0: setting latency timer to 64
[    0.757473] sky2 0000:01:00.0: Yukon-2 UL 2 chip revision 0
[    0.757639] sky2 0000:01:00.0: irq 40 for MSI/MSI-X
[    0.758295] sky2 0000:01:00.0: eth0: addr 00:1d:ba:bc:e2:79
[    0.759064] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.761647] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.761665] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.762093] mousedev: PS/2 mouse device common for all mice
[    0.762785] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    0.762892] I2O subsystem v1.325
[    0.762898] i2o: max drivers = 8
[    0.763093] I2O ProcFS OSM v1.316
[    0.763166] rtc_cmos 00:05: RTC can wake from S4
[    0.776541] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    0.788306] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.788357] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[    0.788409] i2c /dev entries driver
[    0.789128] coretemp coretemp.0: Unable to read TjMax from CPU.
[    0.789257] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    0.789360] iTCO_wdt: No device detected.
[    0.789372] iTCO_vendor_support: vendor-support=0
[    0.789852] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    0.790125] cpuidle: using governor ladder
[    0.790528] cpuidle: using governor menu
[    0.790534] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    0.790719] sdhci: Secure Digital Host Controller Interface driver
[    0.790724] sdhci: Copyright(c) Pierre Ossman
[    0.791526] TCP cubic registered
[    0.791535] NET: Registered protocol family 17
[    0.791553] Registering the dns_resolver key type
[    0.792490] Using IPI No-Shortcut mode
[    0.792739] PM: Hibernation image not present or could not be loaded.
[    0.792766] registered taskstats version 1
[    0.793244] rtc_cmos 00:05: setting system clock to 2011-04-07 10:53:40 UTC (1302173620)
[    0.793448] pvrsrvkm 0000:00:02.0: irq 41 for MSI/MSI-X
[    0.793473] pvrsrvkm 0000:00:02.0: setting latency timer to 64
[    0.794618] GMMADR(region 0) start: 0x80000000 (256M).
[    0.794626] GTTADR(region 3) start: 0x94280000 (can map 256M RAM), and actual RAM base 0x7ffc0000.
[    0.794632] Stolen memory information
[    0.794636]        base in RAM: 0x7f800000
[    0.794641]        size: 7932K, calculated by (GTT RAM base) - (Stolen base), seems wrong
[    0.794648]       the correct size should be: 8M(dvmt mode=3)
[    0.799010] Set up 1983 stolen pages starting at 0x0007f800, GTT offset 0K
[    0.806480] [drm] PSB GTT mem manager ready, tt_start 1983, tt_size 30785 pages
[    0.806590] [drm] SGX core id = 0x01130000
[    0.806596] [drm] SGX core rev major = 0x01, minor = 0x02
[    0.806601] [drm] SGX core rev maintenance = 0x01, designer = 0x00
[    0.820250] TWOD base 80000000
[    0.825229] acpi device:04: registered as cooling_device2
[    0.825440] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
[    0.825570] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    0.825624] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.825630] [drm] No driver support for vblank timestamp query.
[    0.975655] ata1.00: ATA-7: TOSHIBA MK8025GAL, BD102A, max UDMA/100
[    0.975667] ata1.00: 156301488 sectors, multi 16: LBA48 
[    0.975682] ata1.00: limited to UDMA/33 due to 40-wire cable
[    0.988569] ata1.00: configured for UDMA/33
[    0.988974] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK8025GA BD10 PQ: 0 ANSI: 5
[    0.989539] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.989823] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    0.990037] sd 0:0:0:0: [sda] Write Protect is off
[    0.990049] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.990141] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.026113]  sda: sda1 sda2 < sda5 > sda3
[    1.027307] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.526861] allocated 1600x768 fb
[    1.527013] fbcon: psbfb (fb0) is primary device
[    1.552814] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input7
[    1.955638] Console: switching to colour frame buffer device 128x48
[    1.965676] fb0: psbfb frame buffer device
[    1.965681] drm: registered panic notifier
[    1.965698] ------------[ cut here ]------------
[    1.965715] WARNING: at drivers/video/backlight/backlight.c:314 backlight_device_register+0xd0/0x137()
[    1.965723] Hardware name: VGN-P21Z_R
[    1.965728] psb-bl: invalid backlight type
[    1.965733] Modules linked in:
[    1.965742] Pid: 1, comm: swapper Not tainted 2.6.39-rc1-hpc+ #4
[    1.965750] Call Trace:
[    1.965766]  [<c103362c>] ? warn_slowpath_common+0x6a/0x7b
[    1.965776]  [<c11e3161>] ? backlight_device_register+0xd0/0x137
[    1.965785]  [<c10336a3>] ? warn_slowpath_fmt+0x28/0x2c
[    1.965794]  [<c11e3161>] ? backlight_device_register+0xd0/0x137
[    1.965807]  [<c131e603>] ? psb_backlight_init+0x32/0x185
[    1.965816]  [<c1320467>] ? psb_driver_load+0x47f/0x4b6
[    1.965827]  [<c12438f8>] ? drm_get_pci_dev+0x12f/0x20b
[    1.965837]  [<c11c6e28>] ? local_pci_probe+0x34/0x74
[    1.965845]  [<c11c7806>] ? pci_device_probe+0x41/0x63
[    1.965856]  [<c1282019>] ? driver_probe_device+0x8c/0x110
[    1.965864]  [<c12820dd>] ? __driver_attach+0x40/0x5b
[    1.965873]  [<c1281875>] ? bus_for_each_dev+0x37/0x5f
[    1.965882]  [<c1281ecf>] ? driver_attach+0x11/0x13
[    1.965890]  [<c128209d>] ? driver_probe_device+0x110/0x110
[    1.965899]  [<c1281bf0>] ? bus_add_driver+0x87/0x1bb
[    1.965909]  [<c11af944>] ? kset_find_obj_hinted+0x43/0x7d
[    1.965919]  [<c15de581>] ? staging_init+0x3/0x3
[    1.965928]  [<c128251c>] ? driver_register+0x7a/0xd9
[    1.965936]  [<c12439f7>] ? drm_pci_init+0x23/0xbc
[    1.965944]  [<c15de581>] ? staging_init+0x3/0x3
[    1.965952]  [<c11c79d1>] ? __pci_register_driver+0x33/0x89
[    1.965961]  [<c15de581>] ? staging_init+0x3/0x3
[    1.965970]  [<c1001150>] ? do_one_initcall+0x68/0x10f
[    1.965980]  [<c15b425b>] ? kernel_init+0xb3/0x12a
[    1.965989]  [<c15b41a8>] ? parse_early_options+0x18/0x18
[    1.965997]  [<c13c627e>] ? kernel_thread_helper+0x6/0xd
[    1.966004] ---[ end trace 269e1680fe8fb34d ]---
[    1.966082] [drm] Initialized pvrsrvkm 8.1.0 2009-03-10 for 0000:00:02.0 on minor 0
[    1.966145] Initializing network drop monitor service
[    2.015063] EXT3-fs: barriers not enabled
[    2.026716] kjournald starting.  Commit interval 5 seconds
[    2.026873] EXT3-fs (sda3): mounted filesystem with ordered data mode
[    2.026923] VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
[    2.027060] Freeing unused kernel memory: 428k freed
[    2.027908] Write protecting the kernel text: 3868k
[    2.027983] Write protecting the kernel read-only data: 1564k
[    2.077648] Not activating Mandatory Access Control now since /sbin/tomoyo-init doesn't exist.
[    6.142840] cfg80211: Calling CRDA to update world regulatory domain
[    6.743727] usbcore: registered new interface driver usbfs
[    6.745240] usbcore: registered new interface driver hub
[    6.761012] usbcore: registered new device driver usb
[    6.942419] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.942506] ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
[    6.942542] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 20 (level, low) -> IRQ 20
[    6.942610] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.942622] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.942756] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    6.960151] ehci_hcd 0000:00:1d.7: debug port 1
[    6.964058] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    6.964101] ehci_hcd 0000:00:1d.7: irq 20, io mem 0x942c4000
[    6.980059] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.980144] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.980157] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.980167] usb usb1: Product: EHCI Host Controller
[    6.980176] usb usb1: Manufacturer: Linux 2.6.39-rc1-hpc+ ehci_hcd
[    6.980185] usb usb1: SerialNumber: 0000:00:1d.7
[    6.981034] hub 1-0:1.0: USB hub found
[    6.981055] hub 1-0:1.0: 8 ports detected
[    7.404120] usb 1-7: new high speed USB device number 3 using ehci_hcd
[    7.482329] uhci_hcd: USB Universal Host Controller Interface driver
[    7.482491] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    7.482517] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    7.482528] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    7.482568] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    7.499817] uhci_hcd 0000:00:1d.0: irq 21, io base 0x00006040
[    7.500066] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    7.500080] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.500091] usb usb2: Product: UHCI Host Controller
[    7.500100] usb usb2: Manufacturer: Linux 2.6.39-rc1-hpc+ uhci_hcd
[    7.500109] usb usb2: SerialNumber: 0000:00:1d.0
[    7.500780] hub 2-0:1.0: USB hub found
[    7.500800] hub 2-0:1.0: 2 ports detected
[    7.501007] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    7.501026] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    7.501034] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    7.501058] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    7.516250] uhci_hcd 0000:00:1d.1: irq 22, io base 0x00006020
[    7.516419] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    7.516428] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.516435] usb usb3: Product: UHCI Host Controller
[    7.516441] usb usb3: Manufacturer: Linux 2.6.39-rc1-hpc+ uhci_hcd
[    7.516448] usb usb3: SerialNumber: 0000:00:1d.1
[    7.516823] hub 3-0:1.0: USB hub found
[    7.516843] hub 3-0:1.0: 2 ports detected
[    7.517073] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 23 (level, low) -> IRQ 23
[    7.517099] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    7.517110] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    7.517142] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    7.528208] uhci_hcd 0000:00:1d.2: irq 23, io base 0x00006000
[    7.528369] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    7.528378] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.528385] usb usb4: Product: UHCI Host Controller
[    7.528391] usb usb4: Manufacturer: Linux 2.6.39-rc1-hpc+ uhci_hcd
[    7.528398] usb usb4: SerialNumber: 0000:00:1d.2
[    7.528783] hub 4-0:1.0: USB hub found
[    7.528804] hub 4-0:1.0: 2 ports detected
[    7.588824] usb 1-7: New USB device found, idVendor=054c, idProduct=038b
[    7.588842] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    7.588854] usb 1-7: Product: UMH-U10
[    7.588864] usb 1-7: Manufacturer: Sony
[    7.588873] usb 1-7: SerialNumber: 001DBABCE279
[    7.700200] usb 1-8: new high speed USB device number 4 using ehci_hcd
[    7.843182] usb 1-8: New USB device found, idVendor=05ca, idProduct=18b2
[    7.843200] usb 1-8: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[    7.843213] usb 1-8: Manufacturer: Ricoh co. Ltd.
[    7.956106] usb 3-2: new full speed USB device number 2 using uhci_hcd
[    8.127981] usb 3-2: New USB device found, idVendor=044e, idProduct=3017
[    8.127999] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    8.128056] usb 3-2: Product: BCM2046 Bluetooth Device
[    8.128071] usb 3-2: Manufacturer: Broadcom Corp
[    8.128083] usb 3-2: SerialNumber: 002643405B2C
[    8.156837] usbcore: registered new interface driver usbserial
[    8.156897] USB Serial support registered for generic
[    8.157590] usbcore: registered new interface driver usbserial_generic
[    8.157601] usbserial: USB Serial Driver core
[    8.537529] USB Serial support registered for GSM modem (1-port)
[    8.537820] usbcore: registered new interface driver option
[    8.537829] option: v0.7.2:USB Driver for GSM modems
[    8.782864] Linux video capture interface: v2.00
[    8.994545] usbcore: registered new interface driver uas
[    9.151734] Bluetooth: Core ver 2.16
[    9.151821] NET: Registered protocol family 31
[    9.151829] Bluetooth: HCI device and connection manager initialized
[    9.151839] Bluetooth: HCI socket layer initialized
[    9.201577] Initializing USB Mass Storage driver...
[    9.201916] scsi2 : usb-storage 1-7:1.0
[    9.202341] usbcore: registered new interface driver usb-storage
[    9.202351] USB Mass Storage support registered.
[    9.545828] ath9k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    9.545855] ath9k 0000:02:00.0: setting latency timer to 64
[    9.979474] ath: EEPROM regdomain: 0x65
[    9.979481] ath: EEPROM indicates we should expect a direct regpair map
[    9.979491] ath: Country alpha2 being used: 00
[    9.979496] ath: Regpair used: 0x65
[    9.989224] ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
[    9.990486] Registered led device: ath9k-phy0
[    9.990504] ieee80211 phy0: Atheros AR9280 Rev:2 mem=0xfbb80000, irq=17
[   10.162568] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   10.164127] usbcore: registered new interface driver btusb
[   10.202656] scsi 2:0:0:0: Direct-Access     Sony     USB   HS-MS      1.75 PQ: 0 ANSI: 0
[   10.205165] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   10.207726] sd 2:0:0:0: [sdb] 960512 512-byte logical blocks: (491 MB/469 MiB)
[   10.213956] sd 2:0:0:0: [sdb] Write Protect is off
[   10.213971] sd 2:0:0:0: [sdb] Mode Sense: 87 20 00 00
[   10.213981] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   10.220591] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   10.221738]  sdb: sdb1
[   10.228471] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   10.228638] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   10.246098] uvcvideo: Found UVC 1.00 device <unnamed> (05ca:18b2)
[   10.248196] input: UVC Camera (05ca:18b2) as /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/input/input8
[   10.248732] usbcore: registered new interface driver uvcvideo
[   10.248741] USB Video Class driver (v1.0.0)
[   10.463414] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   10.463493] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   10.463536] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   10.463676] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   10.804233] hda_codec: ALC262: SKU not ready 0x411111f0
[   10.804315] hda_codec: ALC262: BIOS auto-probing.
[   10.805093] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
[   10.808712] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   12.282188] EXT3-fs (sda3): using internal journal
[   25.072279] EXT3-fs: barriers not enabled
[   25.073563] kjournald starting.  Commit interval 5 seconds
[   25.081029] EXT3-fs (dm-0): using internal journal
[   25.081055] EXT3-fs (dm-0): mounted filesystem with ordered data mode
[   26.509850] IPv4 FIB: Using LC-trie version 0.409
[   27.257768] fuse init (API version 7.16)
[   50.085370] sky2 0000:01:00.0: eth0: enabling interface
[   52.995491] Ebtables v2.0 registered
[   53.108970] sky2 0000:01:00.0: eth0: Link is up at 100 Mbps, full duplex, flow control both
[   53.264724] ip_tables: (C) 2000-2006 Netfilter Core Team
[   62.268126] libfcoe_device_notification: NETDEV_UNREGISTER lo
[   64.413878] hda-intel: Invalid position buffer, using LPIB read method instead.

--FCuugMFkClbJLl1L--
