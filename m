Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab2GETki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:40:38 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:50899 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772Ab2GETke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:40:34 -0400
Date: Thu, 5 Jul 2012 22:40:30 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Dave Airlie <airlied@gmail.com>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: 3.5-rc5: radeon acceleration regression on Transmeta system
In-Reply-To: <CAPM=9tyo69+8QTCKMDCOTzWT2gR+uXkynOny85PaQ_nCYNMGAg@mail.gmail.com>
Message-ID: <alpine.SOC.1.00.1207052224340.19147@math.ut.ee>
References: <alpine.SOC.1.00.1207050956300.515@math.ut.ee> <CAPM=9tyo69+8QTCKMDCOTzWT2gR+uXkynOny85PaQ_nCYNMGAg@mail.gmail.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > In 3.4, radeon worked with a glitch - window titles were see-throug (not
> > drawn). In 3.5-rc5, radeon driver seems to be more careful and disables
> > acceleration on this system at all. Full dmesg below.
> 
> Does it always do it the same? got the dmesg from 3.4 and/or 2.6.32?

That was a good question. I did some more tries, and it was not 
repeatable. Sometimes it worked like 3.4 did - rv100 initialized fine, 
no borders except when maximized, otherwise worked.

Total 3 failures and 6 successes in intializing the card so far.

> if I had to guess something broke in the dma area elsewhere, but not sure.

Initial windows border problem seems to have been introduced between 
2.6.37 and 2.6.38, bisect is slow.

"Good" dmesg:

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.0-rc5-00098-g9e85a6f (mroos@raamat) (gcc version 4.4.5 (Debian 4.4.5-8) ) #61 Thu Jul 5 04:17:43 EEST 2012
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e8000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000efdffff] usable
[    0.000000] BIOS-e820: [mem 0x000000000efe0000-0x000000000efefbff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000000efefc00-0x000000000efeffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000000eff0000-0x000000000f0fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] DMI 2.3 present.
[    0.000000] DMI: FUJITSU LifeBook P Series/FJNB164, BIOS Version 1.08  02/24/2005
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xefe0 max_arch_pfn = 0x100000
[    0.000000] initial memory mapped: [mem 0x00000000-0x017fffff]
[    0.000000] Base memory trampoline at [c0098000] 98000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0efdffff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0ebfffff] page 2M
[    0.000000]  [mem 0x0ec00000-0x0efdffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xefdffff @ [mem 0x017fa000-0x017fffff]
[    0.000000] ACPI: RSDP 000f70a0 00014 (v00 FUJ   )
[    0.000000] ACPI: RSDT 0efedad0 0002C (v01 FUJ    MOMUS3   01080000 FUJ  00001000)
[    0.000000] ACPI: FACP 0efefa92 00074 (v01 FUJ    MOMUS3   01080000 FUJ  00001000)
[    0.000000] ACPI: DSDT 0efedafc 01F96 (v01 FUJ    MOMUS3   01080000 MSFT 01000007)
[    0.000000] ACPI: FACS 0efeffc0 00040
[    0.000000] ACPI: SSDT 0efefb06 000FA (v01 PTLTD  ACPIPST1 00000001 PTL  00000001)
[    0.000000] 239MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0efe0000
[    0.000000]   low ram: 0 - 0efe0000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0efdffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0x0efdffff]
[    0.000000] On node 0 totalpages: 61292
[    0.000000] free_area_init_node: node 0, pgdat c12ff888, node_mem_map cee00200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3948 pages, LIFO batch:0
[    0.000000]   Normal zone: 448 pages used for memmap
[    0.000000]   Normal zone: 56864 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xff08
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
[    0.000000] e820: [mem 0x0f100000-0xffefffff] available for PCI devices
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 60812
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.5.0-rc5-00098-g9e85a6f root=/dev/sda1 ro debug radeon.modeset=1
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 239300k/245632k available (2103k kernel code, 5868k reserved, 984k data, 284k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe4000 - 0xfffff000   ( 108 kB)
[    0.000000]     vmalloc : 0xcf7e0000 - 0xfffe2000   ( 776 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcefe0000   ( 239 MB)
[    0.000000]       .init : 0xc1305000 - 0xc134c000   ( 284 kB)
[    0.000000]       .data : 0xc120de7e - 0xc13040c0   ( 984 kB)
[    0.000000]       .text : 0xc1000000 - 0xc120de7e   (2103 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=ce806000 soft=ce808000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 793.240 MHz processor.
[    0.020035] Calibrating delay loop (skipped), value calculated using timer frequency.. 1586.48 BogoMIPS (lpj=7932400)
[    0.020366] pid_max: default: 32768 minimum: 301
[    0.021490] Security Framework initialized
[    0.021777] Mount-cache hash table entries: 512
[    0.038674] Initializing cgroup subsys blkio
[    0.041032] CPU: Processor revision 1.4.1.0, 800 MHz
[    0.041169] CPU: Code Morphing Software revision 4.3.2-9-566
[    0.041271] CPU: 20030108 13:03 official release 28.0.3-4.3.2#1
[    0.041588] CPU: Transmeta(tm) Crusoe(tm) Processor TM5800 stepping 03
[    0.043161] ACPI: Core revision 20120320
[    0.092865] ACPI: setting ELCR to 0200 (from 0c00)
[    0.101555] Performance Events: 
[    0.116840] PM: Registering ACPI NVS region [mem 0x0efefc00-0x0efeffff] (1024 bytes)
[    0.120978] NET: Registered protocol family 16
[    0.146291] ACPI: bus type pci registered
[    0.171986] PCI: PCI BIOS revision 2.10 entry at 0xfd8ae, last bus=1
[    0.172114] PCI: Using configuration type 1 for base access
[    0.293013] bio: create slab <bio-0> at 0
[    0.294471] ACPI: Added _OSI(Module Device)
[    0.294902] ACPI: Added _OSI(Processor Device)
[    0.295010] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.295098] ACPI: Added _OSI(Processor Aggregator Device)
[    0.300433] ACPI: EC: Look up EC in DSDT
[    0.342862] ACPI: Interpreter enabled
[    0.343016] ACPI: (supports S0 S3 S4 S5)
[    0.343727] ACPI: Using PIC for interrupt routing
[    0.401915] ACPI: Power Resource [USBP] (on)
[    0.425434] ACPI: EC: GPE = 0x0, I/O: command/status = 0x66, data = 0x62
[    0.427299] ACPI: No dock devices found.
[    0.427486] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.436544] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.449834] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.450145] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.450317] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.450652] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000e7fff] (ignored)
[    0.450912] pci_root PNP0A03:00: host bridge window [mem 0x0f100000-0xffefffff] (ignored)
[    0.451047] PCI: root bus 00: using default resources
[    0.452055] PCI host bridge to bus 0000:00
[    0.452388] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.452539] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.452745] pci 0000:00:00.0: [1279:0395] type 00 class 0x060000
[    0.453310] pci 0000:00:00.0: reg 10: [mem 0xe8100000-0xe81fffff]
[    0.454398] pci 0000:00:00.1: [1279:0396] type 00 class 0x050000
[    0.456255] pci 0000:00:00.2: [1279:0397] type 00 class 0x050000
[    0.457619] pci 0000:00:02.0: [10b9:5237] type 00 class 0x0c0310
[    0.457842] pci 0000:00:02.0: reg 10: [mem 0xe8010000-0xe8010fff]
[    0.459763] pci 0000:00:04.0: [10b9:5451] type 00 class 0x040100
[    0.461235] pci 0000:00:04.0: reg 10: [io  0x1000-0x10ff]
[    0.461452] pci 0000:00:04.0: reg 14: [mem 0xe8011000-0xe8011fff]
[    0.462197] pci 0000:00:04.0: supports D1 D2
[    0.462444] pci 0000:00:04.0: PME# supported from D2 D3hot D3cold
[    0.462971] pci 0000:00:06.0: [10b9:7101] type 00 class 0x068000
[    0.464099] pci 0000:00:06.0: quirk: [io  0xff00-0xff3f] claimed by ali7101 ACPI
[    0.464272] pci 0000:00:06.0: quirk: [io  0xff80-0xff9f] claimed by ali7101 SMB
[    0.464464] pci 0000:00:07.0: [10b9:1533] type 00 class 0x060100
[    0.465017] pci 0000:00:0c.0: [104c:ac50] type 02 class 0x060700
[    0.465185] pci 0000:00:0c.0: reg 10: [mem 0x00000000-0x00000fff]
[    0.466438] pci 0000:00:0c.0: supports D1 D2
[    0.466633] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.467003] pci 0000:00:0f.0: [10b9:5229] type 00 class 0x0101ee
[    0.467154] pci 0000:00:0f.0: reg 18: [io  0x0170-0x0177]
[    0.467383] pci 0000:00:0f.0: reg 1c: [io  0x0374-0x0377]
[    0.467539] pci 0000:00:0f.0: reg 20: [io  0x1800-0x180f]
[    0.467749] pci 0000:00:10.0: [10ec:8139] type 00 class 0x020000
[    0.467887] pci 0000:00:10.0: reg 10: [io  0x8000-0x80ff]
[    0.467997] pci 0000:00:10.0: reg 14: [mem 0xe8012000-0xe80120ff]
[    0.468152] pci 0000:00:10.0: supports D1 D2
[    0.468225] pci 0000:00:10.0: PME# supported from D1 D2 D3hot D3cold
[    0.469332] pci 0000:00:12.0: [1260:3873] type 00 class 0x028000
[    0.469478] pci 0000:00:12.0: reg 10: [mem 0xe8013000-0xe8013fff pref]
[    0.469866] pci 0000:00:12.0: supports D1 D2
[    0.470093] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot
[    0.470280] pci 0000:00:14.0: [1002:4c59] type 00 class 0x030000
[    0.470417] pci 0000:00:14.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
[    0.470647] pci 0000:00:14.0: reg 14: [io  0x1400-0x14ff]
[    0.471055] pci 0000:00:14.0: reg 18: [mem 0xe8000000-0xe800ffff]
[    0.471838] pci 0000:00:14.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.471979] pci 0000:00:14.0: supports D1 D2
[    0.472682] pci_bus 0000:00: on NUMA node 0
[    0.472810] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.474350]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.485667] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 *10 11)
[    0.487375] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11)
[    0.492738] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11) *0, disabled.
[    0.495071] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *10 11)
[    0.497575] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *10 11)
[    0.499318] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11) *0, disabled.
[    0.501992] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11) *0, disabled.
[    0.503365] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 *10 11)
[    0.506516] ACPI: PCI Interrupt Link [LNKU] (IRQs 3 4 5 7 10 *11)
[    0.509103] vgaarb: device added: PCI:0000:00:14.0,decodes=io+mem,owns=io+mem,locks=none
[    0.509712] vgaarb: loaded
[    0.509788] vgaarb: bridge control possible 0000:00:14.0
[    0.512672] SCSI subsystem initialized
[    0.513736] libata version 3.00 loaded.
[    0.515213] PCI: Using ACPI for IRQ routing
[    0.515483] PCI: pci_cache_line_size set to 32 bytes
[    0.518048] e820: reserve RAM buffer [mem 0x0009c000-0x0009ffff]
[    0.518154] e820: reserve RAM buffer [mem 0x0efe0000-0x0fffffff]
[    0.522668] Switching to clocksource pit
[    0.524769] pnp: PnP ACPI init
[    0.524964] ACPI: bus type pnp registered
[    0.527568] pnp 00:00: [bus 00-ff]
[    0.527682] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.527777] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.527866] pnp 00:00: [io  0x0d00-0xffff window]
[    0.527957] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.528045] pnp 00:00: [mem 0x000d0000-0x000e7fff window]
[    0.528130] pnp 00:00: [mem 0x0f100000-0xffefffff window]
[    0.528130] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.528151] pnp 00:01: [io  0x0072-0x0073]
[    0.528269] pnp 00:01: [io  0x0080]
[    0.528353] pnp 00:01: [io  0x0092]
[    0.528433] pnp 00:01: [io  0x00b0-0x00b3]
[    0.528518] pnp 00:01: [io  0x00ea-0x00eb]
[    0.528599] pnp 00:01: [io  0x040b]
[    0.528678] pnp 00:01: [io  0x0480-0x048f]
[    0.528758] pnp 00:01: [io  0x04d0-0x04d1]
[    0.528840] pnp 00:01: [io  0x04d6]
[    0.528919] pnp 00:01: [io  0xf800-0xf87f]
[    0.528999] pnp 00:01: [io  0xf880-0xf8ff]
[    0.529080] pnp 00:01: [io  0xfd60-0xfd67]
[    0.529160] pnp 00:01: [io  0xfe00]
[    0.529237] pnp 00:01: [io  0xff00-0xff3f]
[    0.529317] pnp 00:01: [io  0xff80-0xff9f]
[    0.531074] system 00:01: [io  0x040b] has been reserved
[    0.531361] system 00:01: [io  0x0480-0x048f] has been reserved
[    0.531668] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.538838] system 00:01: [io  0x04d6] has been reserved
[    0.538936] system 00:01: [io  0xf800-0xf87f] has been reserved
[    0.539023] system 00:01: [io  0xf880-0xf8ff] has been reserved
[    0.539338] system 00:01: [io  0xfd60-0xfd67] has been reserved
[    0.539552] system 00:01: [io  0xfe00] has been reserved
[    0.539649] system 00:01: [io  0xff00-0xff3f] has been reserved
[    0.539737] system 00:01: [io  0xff80-0xff9f] has been reserved
[    0.539849] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.540429] pnp 00:02: [io  0x0000-0x000f]
[    0.540527] pnp 00:02: [io  0x0081-0x008f]
[    0.540791] pnp 00:02: [io  0x00c0-0x00df]
[    0.540886] pnp 00:02: [dma 4]
[    0.541466] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.541804] pnp 00:03: [io  0x00f0-0x00fe]
[    0.541911] pnp 00:03: [irq 13]
[    0.542312] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.542785] pnp 00:04: [io  0x0070-0x0071]
[    0.542885] pnp 00:04: [irq 8]
[    0.543382] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.543627] pnp 00:05: [io  0x0061]
[    0.544325] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.544842] pnp 00:06: [irq 12]
[    0.545447] pnp 00:06: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.546451] pnp 00:07: [io  0x0060]
[    0.546686] pnp 00:07: [io  0x0064]
[    0.546786] pnp 00:07: [irq 1]
[    0.547549] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.549662] pnp: PnP ACPI: found 8 devices
[    0.549764] ACPI: ACPI bus type pnp unregistered
[    0.611089] Switching to clocksource acpi_pm
[    0.611706] pci 0000:00:0c.0: res[9]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
[    0.611844] pci 0000:00:0c.0: res[10]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
[    0.611949] pci 0000:00:0c.0: res[7]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.612047] pci 0000:00:0c.0: res[8]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.612242] pci 0000:00:0c.0: BAR 0: assigned [mem 0x10000000-0x10000fff]
[    0.612555] pci 0000:00:0c.0: BAR 9: assigned [mem 0x14000000-0x17ffffff pref]
[    0.613102] pci 0000:00:0c.0: BAR 10: assigned [mem 0x18000000-0x1bffffff]
[    0.613243] pci 0000:00:14.0: BAR 6: assigned [mem 0x10020000-0x1003ffff pref]
[    0.614210] pci 0000:00:0c.0: BAR 7: assigned [io  0x1c00-0x1cff]
[    0.614458] pci 0000:00:0c.0: BAR 8: assigned [io  0x2000-0x20ff]
[    0.614587] pci 0000:00:0c.0: CardBus bridge to [bus 01-04]
[    0.614664] pci 0000:00:0c.0:   bridge window [io  0x1c00-0x1cff]
[    0.614749] pci 0000:00:0c.0:   bridge window [io  0x2000-0x20ff]
[    0.614840] pci 0000:00:0c.0:   bridge window [mem 0x14000000-0x17ffffff pref]
[    0.614946] pci 0000:00:0c.0:   bridge window [mem 0x18000000-0x1bffffff]
[    0.616292] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    0.616401] PCI: setting IRQ 10 as level-triggered
[    0.616537] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.616621] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.616708] pci_bus 0000:01: resource 0 [io  0x1c00-0x1cff]
[    0.616782] pci_bus 0000:01: resource 1 [io  0x2000-0x20ff]
[    0.616873] pci_bus 0000:01: resource 2 [mem 0x14000000-0x17ffffff pref]
[    0.616951] pci_bus 0000:01: resource 3 [mem 0x18000000-0x1bffffff]
[    0.617681] NET: Registered protocol family 2
[    0.620817] IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.624212] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.624685] TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
[    0.625028] TCP: Hash tables configured (established 8192 bind 8192)
[    0.625112] TCP: reno registered
[    0.625211] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.625574] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.627315] NET: Registered protocol family 1
[    0.627820] pci 0000:00:02.0: power state changed by ACPI to D0
[    0.627926] pci 0000:00:02.0: power state changed by ACPI to D0
[    0.628955] ACPI: PCI Interrupt Link [LNKU] enabled at IRQ 11
[    0.629059] PCI: setting IRQ 11 as level-triggered
[    0.681502] pci 0000:00:07.0: Activating ISA DMA hang workarounds
[    0.681685] pci 0000:00:14.0: Boot video device
[    0.681779] PCI: CLS 32 bytes, default 32
[    0.689471] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.693352] msgmni has been set to 467
[    0.695162] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.695304] io scheduler noop registered
[    0.695450] io scheduler cfq registered (default)
[    0.697342] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.703130] pata_ali 0000:00:0f.0: can't derive routing for PCI INT A
[    0.703244] pata_ali 0000:00:0f.0: PCI INT A: no GSI
[    0.703313] 
[    0.708248] scsi0 : pata_ali
[    0.709844] scsi1 : pata_ali
[    0.711414] ata1: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0x1800 irq 14
[    0.711521] ata2: PATA max UDMA/66 cmd 0x170 ctl 0x374 bmdma 0x1808 irq 15
[    0.714931] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.717909] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.718050] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.719285] mousedev: PS/2 mouse device common for all mice
[    0.720316] rtc_cmos 00:04: RTC can wake from S4
[    0.722195] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.722414] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    0.722736] cpuidle: using governor ladder
[    0.722824] cpuidle: using governor menu
[    0.729760] TCP: cubic registered
[    0.729882] NET: Registered protocol family 17
[    0.730627] Key type dns_resolver registered
[    0.742091] rtc_cmos 00:04: setting system clock to 2012-07-05 19:23:21 UTC (1341516201)
[    0.762000] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.374563] ata1.00: ATA-4: TOSHIBA MK6014MAP, N2.14 G, max UDMA/66
[    1.374759] ata1.00: 11733120 sectors, multi 16: LBA 
[    1.395171] ata1.00: configured for UDMA/66
[    1.399485] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK6014MA N2.1 PQ: 0 ANSI: 5
[    1.402880] sd 0:0:0:0: [sda] 11733120 512-byte logical blocks: (6.00 GB/5.59 GiB)
[    1.406907] sd 0:0:0:0: [sda] Write Protect is off
[    1.407023] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.408895] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.680580] Refined TSC clocksource calibration: 793.226 MHz.
[    1.680930] Switching to clocksource tsc
[    1.914135]  sda: sda1 sda2 < sda5 >
[    2.023377] kjournald starting.  Commit interval 5 seconds
[    2.025237] EXT3-fs (sda1): mounted filesystem with writeback data mode
[    2.025707] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[    2.029851] Freeing unused kernel memory: 284k freed
[    2.033163] Write protecting the kernel text: 2104k
[    2.033355] Write protecting the kernel read-only data: 804k
[    2.066561] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.378359] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    9.380337] ACPI: AC Adapter [AC] (on-line)
[    9.538646] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    9.538835] ACPI: Battery Slot [CMB1] (battery present)
[    9.575183] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    9.575704] ACPI: Power Button [PWRB]
[    9.576525] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[    9.587881] Linux agpgart interface v0.103
[    9.613869] ACPI: Lid Switch [LID]
[    9.615233] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    9.615430] ACPI: Power Button [PWRF]
[    9.633107] input: Fujitsu FUJ02B1 as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/FUJ02B1:00/input/input4
[    9.633330] fujitsu_laptop: ACPI: Fujitsu FUJ02B1 [FJEX] (on)
[    9.635378] fujitsu_laptop: driver 0.6.0 successfully loaded
[    9.983378] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   10.103584] Marking TSC unstable due to TSC halts in idle
[   10.103845] ACPI: acpi_idle registered with cpuidle
[   10.110299] Switching to clocksource acpi_pm
[   10.699501] ACPI: bus type usb registered
[   10.700226] usbcore: registered new interface driver usbfs
[   10.700525] usbcore: registered new interface driver hub
[   10.717359] usbcore: registered new device driver usb
[   11.619053] apanel: unknown device 11 found
[   11.870798] cfg80211: Calling CRDA to update world regulatory domain
[   11.917411] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   11.917744] ohci_hcd 0000:00:02.0: power state changed by ACPI to D0
[   11.917850] ohci_hcd 0000:00:02.0: power state changed by ACPI to D0
[   11.918749] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   11.918935] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
[   11.919204] ohci_hcd 0000:00:02.0: irq 11, io mem 0xe8010000
[   11.975378] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   11.976662] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.976863] usb usb1: Product: OHCI Host Controller
[   11.976993] usb usb1: Manufacturer: Linux 3.5.0-rc5-00098-g9e85a6f ohci_hcd
[   11.977125] usb usb1: SerialNumber: 0000:00:02.0
[   11.979694] hub 1-0:1.0: USB hub found
[   11.980533] hub 1-0:1.0: 3 ports detected
[   11.989022] 8139cp: 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[   11.989554] 8139cp 0000:00:10.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip, use 8139too
[   12.187323] ali1535_smbus 0000:00:06.0: enabling device (0000 -> 0001)
[   12.279406] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   12.299477] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input6
[   12.320669] usb 1-3: new low-speed USB device number 2 using ohci_hcd
[   12.336537] yenta_cardbus 0000:00:0c.0: CardBus bridge found [10cf:10c6]
[   12.336755] yenta_cardbus 0000:00:0c.0: adjusting diagnostic: 41 -> 61
[   12.336858] yenta_cardbus 0000:00:0c.0: Enabling burst memory read transactions
[   12.336981] yenta_cardbus 0000:00:0c.0: Using CSCINT to route CSC interrupts to PCI
[   12.337089] yenta_cardbus 0000:00:0c.0: Routing CardBus interrupts to PCI
[   12.337181] yenta_cardbus 0000:00:0c.0: TI: mfunc 0x00c61d22, devctl 0x46
[   12.516083] usb 1-3: New USB device found, idVendor=0430, idProduct=0508
[   12.516277] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   12.516519] usb 1-3: Product: USB Touch Panel
[   12.516661] usb 1-3: Manufacturer: Fujitsu Takamisawa
[   12.557797] 8139too: 8139too Fast Ethernet driver 0.9.28
[   12.581729] yenta_cardbus 0000:00:0c.0: ISA IRQ mask 0x00f8, PCI irq 10
[   12.581841] yenta_cardbus 0000:00:0c.0: Socket status: 30000006
[   12.601494] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[   12.605996] 8139too 0000:00:10.0: eth0: RealTek RTL8139 at 0xcf802000, 00:0b:5d:48:63:fb, IRQ 10
[   12.797313] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
[   12.928626] Error: Driver 'pcspkr' is already registered, aborting...
[   12.997445] orinoco_pci 0.15 (Pavel Roskin <proski@gnu.org>, David Gibson <hermes@gibson.dropbear.id.au> & Jean Tourrilhes <jt@hpl.hp.com>)
[   13.005180] ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 10
[   13.956782] orinoco_pci 0000:00:12.0: Hardware identity 8013:0000:0001:0000
[   13.957306] orinoco_pci 0000:00:12.0: Station identity  001f:0001:0001:0004
[   13.957404] orinoco_pci 0000:00:12.0: Firmware determined as Intersil 1.4.1
[   13.957476] orinoco_pci 0000:00:12.0: Ad-hoc demo mode supported
[   13.957547] orinoco_pci 0000:00:12.0: IEEE standard IBSS ad-hoc mode supported
[   13.957644] orinoco_pci 0000:00:12.0: WEP supported, 104-bit key
[   14.330014] lib80211: common routines for IEEE802.11 drivers
[   14.330341] lib80211_crypt: registered algorithm 'NULL'
[   14.571391] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
[   15.199027] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff:
[   15.201060]  excluding 0xc0000-0xcffff 0xe8000-0xfffff
[   15.219502] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff:
[   15.221299]  clean.
[   15.225028] usbcore: registered new interface driver usbhid
[   15.225145] usbhid: USB HID core driver
[   15.233874] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff:
[   15.234099]  clean.
[   15.536166] [drm] Initialized drm 1.1.0 20060810
[   15.542808] input: Fujitsu Takamisawa USB Touch Panel as /devices/pci0000:00/0000:00:02.0/usb1/1-3/1-3:1.0/input/input7
[   15.543585] hid-generic 0003:0430:0508.0001: input,hidraw0: USB HID v1.00 Mouse [Fujitsu Takamisawa USB Touch Panel] on usb-0000:00:02.0-3/input0
[   16.391064] [drm] radeon kernel modesetting enabled.
[   19.588805] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
[   19.596030] [drm] initializing kernel modesetting (RV100 0x1002:0x4C59 0x10CF:0x11C8).
[   19.597281] [drm] register mmio base: 0xE8000000
[   19.597381] [drm] register mmio size: 65536
[   19.601362] radeon 0000:00:14.0: VRAM: 128M 0x00000000F0000000 - 0x00000000F7FFFFFF (8M used)
[   19.601518] radeon 0000:00:14.0: GTT: 512M 0x00000000D0000000 - 0x00000000EFFFFFFF
[   19.601763] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   19.601845] [drm] Driver supports precise vblank timestamp query.
[   19.602082] [drm] radeon: irq initialized.
[   19.602177] [drm] Detected VRAM RAM=128M, BAR=128M
[   19.602257] [drm] RAM width 32bits DDR
[   19.728309] [TTM] Zone  kernel: Available graphics memory: 119792 kiB
[   19.728423] [TTM] Initializing pool allocator
[   19.729177] [drm] radeon: 8M of VRAM memory ready
[   19.729285] [drm] radeon: 512M of GTT memory ready.
[   19.730064] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   19.766728] [drm] PCI GART of 512M enabled (table at 0x000000000D480000).
[   19.767771] radeon 0000:00:14.0: WB disabled
[   19.767914] radeon 0000:00:14.0: fence driver on ring 0 use gpu addr 0x00000000d0000000 and cpu addr 0xcd9b5000
[   19.768415] [drm] Loading R100 Microcode
[   19.974232] [drm] radeon: ring at 0x00000000D0001000
[   19.975057] [drm] ring test succeeded in 0 usecs
[   19.975949] [drm] ib test succeeded in 0 usecs
[   19.980296] [drm] Panel ID String: Toshiba LTM07C382  XSGA 
[   19.980400] [drm] Panel Size 1024x600
[   19.993310] [drm] radeon legacy LVDS backlight initialized
[   19.993432] [drm] Radeon Display Connectors
[   19.993501] [drm] Connector 0:
[   19.993567] [drm]   VGA-1
[   19.993635] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[   19.993700] [drm]   Encoders:
[   19.993765] [drm]     CRT1: INTERNAL_DAC1
[   19.993833] [drm] Connector 1:
[   19.993896] [drm]   LVDS-1
[   19.994200] [drm]   Encoders:
[   19.994281] [drm]     LCD1: INTERNAL_LVDS
[   20.144012] [drm] fb mappable at 0xF0040000
[   20.144113] [drm] vram apper at 0xF0000000
[   20.144172] [drm] size 614400
[   20.144229] [drm] fb depth is 8
[   20.144286] [drm]    pitch is 1024
[   20.144689] fbcon: radeondrmfb (fb0) is primary device
[   20.232549] Console: switching to colour frame buffer device 128x37
[   20.240238] fb0: radeondrmfb frame buffer device
[   20.240395] drm: registered panic notifier
[   20.240603] [drm] Initialized radeon 2.17.0 20080528 for 0000:00:14.0 on minor 0
[   23.120940] Adding 305196k swap on /dev/sda5.  Priority:-1 extents:1 across:305196k 
[   23.710344] EXT3-fs (sda1): using internal journal
[   24.370504] loop: module loaded
[   28.499826] 8139too 0000:00:10.0: eth0: link up, 100Mbps, full-duplex, lpa 0xC5E1
[   37.509957] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input8
[   43.660574] Bluetooth: Core ver 2.16
[   43.663693] NET: Registered protocol family 31
[   43.666503] Bluetooth: HCI device and connection manager initialized
[   43.669356] Bluetooth: HCI socket layer initialized
[   43.672290] Bluetooth: L2CAP socket layer initialized
[   43.675149] Bluetooth: SCO socket layer initialized
[   43.920540] Bluetooth: RFCOMM TTY layer initialized
[   43.923472] Bluetooth: RFCOMM socket layer initialized
[   43.926256] Bluetooth: RFCOMM ver 1.11
[   45.025950] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   45.032461] Bluetooth: BNEP filters: protocol multicast
[   45.945918] NET: Registered protocol family 10
[   46.384565] Bridge firewalling registered
[   55.289903] sshd (1379): /proc/1379/oom_adj is deprecated, please use /proc/1379/oom_score_adj instead.

-- 
Meelis Roos (mroos@linux.ee)
