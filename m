Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab2JaLsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:48:18 -0400
Received: from smtp.tele.fi ([192.89.123.25]:37697 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab2JaLsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:48:14 -0400
X-Originating-Ip: [194.89.68.22]
Date: Wed, 31 Oct 2012 13:48:09 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Olaf Hering <olaf@aepfle.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen PVonHVM: require at least Xen 3.4 as
 dom0
Message-ID: <20121031114809.GB8912@reaktio.net>
References: <1351613105-24408-1-git-send-email-olaf@aepfle.de>
 <20121030181732.GZ8912@reaktio.net>
 <20121030182859.GA8775@aepfle.de>
 <1351672212.20470.7.camel@hastur.hellion.org.uk>
 <20121031092925.GA22587@aepfle.de>
 <20121031102128.GA8912@reaktio.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121031102128.GA8912@reaktio.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 12:21:28PM +0200, Pasi Kärkkäinen wrote:
> On Wed, Oct 31, 2012 at 10:29:25AM +0100, Olaf Hering wrote:
> > On Wed, Oct 31, Ian Campbell wrote:
> > 
> > > If I understand correctly this requirements comes from the need to
> > > support moving the shared info page in order to support kexec?
> > > 
> > > So could we do something more fine grained and limit only the kexec
> > > support (and therefore the movement of the SI into that range) to 3.4+?
> > 
> > Its not strictly about kexec. The other patch I sent out will place the
> > shared info page at 0xFE700000. If that range is not within a
> > E820_Reserved area and if the old hvmloader makes allocations within
> > that range, that other patch needs to be changed so that the shared info
> > page is done either at 0xFE700000 or within RESERVE_BRK (as it is done
> > currently).
> > 
> > Is the source code of that old RHEL available somewhere, did they patch
> > hvmloader at all? Providing a E820 map from a guest which was started on
> > such old dom0 would be a good start.
> > 
> 
> http://ftp.redhat.com/pub/redhat/linux/enterprise/5Server/en/os/SRPMS/xen-3.0.3-135.el5_8.5.src.rpm
> That's the userland, actual Xen hypervisor is in the kernel src.rpm.
> 
> I can provide a dmesg from a guest later today.
> 

dmesg from a Fedora 17 PVHVM guest with Linux 3.5.4, running on RHEL 5.8 Xen dom0:



[    0.000000] Linux version 3.5.4-1.fc17.x86_64 (mockbuild@) (gcc version 4.7.0 20120507 (Red Hat 4.7.0-5) (GCC) ) #1 SMP Mon Sep 17 15:03:59 UTC 2012
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.5.4-1.fc17.x86_64 root=/dev/mapper/vg_f17x64hvm01-lv_root ro rd.lvm.lv=vg_f17x64hvm01/lv_root rd.md=0 rd.dm=0 SYSFONT=T
rue KEYTABLE=fi rd.luks=0 rd.lvm.lv=vg_f17x64hvm01/lv_swap LANG=en_US.UTF-8 rhgb
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003fffabff] usable
[    0.000000] BIOS-e820: [mem 0x000000003fffac00-0x000000003fffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Red Hat HVM domU, BIOS 3.1.2-308.13.1.el5 09/27/2012
[    0.000000] Hypervisor detected: Xen HVM
[    0.000000] Xen version 3.1.
[    0.000000] Xen Platform PCI: I/O protocol version 1
[    0.000000] Netfront and the Xen platform PCI driver have been compiled for this kernel: unplug emulated NICs.
[    0.000000] Blkfront and the Xen platform PCI driver have been compiled for this kernel: unplug emulated disks.
[    0.000000] You might have to change the root device
[    0.000000] from /dev/hd[a-d] to /dev/xvd[a-d]
[    0.000000] in your root= kernel command line option
[    0.000000] HVMOP_pagetable_dying not supported
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x3fffa max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-D3FFF write-back
[    0.000000]   D4000-EBFFF uncachable
[    0.000000]   EC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFF0000000 write-back
[    0.000000]   3 base 0100000000 mask FF00000000 write-back
[    0.000000]   4 base 0200000000 mask FE00000000 write-back
[    0.000000]   5 base 0400000000 mask FC00000000 write-back
[    0.000000]   6 base 0800000000 mask FC00000000 write-back
[    0.000000]   7 base 0C00000000 mask FFC0000000 write-back
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000000] found SMP MP-table at [mem 0x000fccd0-0x000fccdf] mapped at [ffff8800000fccd0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x3fff9fff]
[    0.000000]  [mem 0x00000000-0x3fdfffff] page 2M
[    0.000000]  [mem 0x3fe00000-0x3fff9fff] page 4k
[    0.000000] kernel direct mapping tables up to 0x3fff9fff @ [mem 0x1fdfe000-0x1fffffff]
[    0.000000] RAMDISK: [mem 0x36398000-0x371c3fff]
[    0.000000] ACPI: RSDP 00000000000eb340 00024 (v02    Xen)
[    0.000000] ACPI: XSDT 00000000000eb2b0 00044 (v01    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: FACP 00000000000eb0c0 000F4 (v04    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: DSDT 00000000000ea050 00FEA (v02    Xen      HVM 00000000 INTL 20110413)
[    0.000000] ACPI: FACS 00000000000ea010 00040
[    0.000000] ACPI: APIC 00000000000eb1c0 00072 (v02    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: HPET 00000000000eb240 00038 (v01    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: SSDT 00000000000eb278 00038 (v02    Xen      HVM 00000000 HVML 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000003fff9fff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x3fff9fff]
[    0.000000]   NODE_DATA [mem 0x3ffe6000-0x3fff9fff]
[    0.000000]  [ffffea0000000000-ffffea0000ffffff] PMD -> [ffff88003e600000-ffff88003f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x3fff9fff]
[    0.000000] On node 0 totalpages: 262025
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 4032 pages used for memmap
[    0.000000]   DMA32 zone: 254010 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1f48
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 low level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 7 global_irq 7 low level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 low level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ7 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] e820: [mem 0x40000000-0xffffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on Xen HVM
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88003fc00000 s83136 r8192 d23360 u2097152
[    0.000000] pcpu-alloc: s83136 r8192 d23360 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 257923
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.5.4-1.fc17.x86_64 root=/dev/mapper/vg_f17x64hvm01-lv_root ro rd.lvm.lv=vg_f17x64hvm01/lv_root rd.md=0 rd.dm=0 SYSFONT=True KEYTABLE=fi rd.luks=0 rd.lvm.lv=vg_f17x64hvm01/lv_swap LANG=en_US.UTF-8 rhgb
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 1000920k/1048552k available (6243k kernel code, 452k absent, 47180k reserved, 6940k data, 1016k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:8448 nr_irqs:256 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Cannot get hvm parameter 18: -22!
[    0.000000] allocated 4194304 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2266.865 MHz processor.
[    0.002002] Calibrating delay loop (skipped), value calculated using timer frequency.. 4533.73 BogoMIPS (lpj=2266865)
[    0.002011] pid_max: default: 32768 minimum: 301
[    0.002042] Security Framework initialized
[    0.002051] SELinux:  Initializing.
[    0.002064] SELinux:  Starting in permissive mode
[    0.002246] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.002574] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.003077] Mount-cache hash table entries: 256
[    0.003313] Initializing cgroup subsys cpuacct
[    0.003320] Initializing cgroup subsys memory
[    0.003334] Initializing cgroup subsys devices
[    0.003339] Initializing cgroup subsys freezer
[    0.003343] Initializing cgroup subsys net_cls
[    0.003347] Initializing cgroup subsys blkio
[    0.003351] Initializing cgroup subsys perf_event
[    0.003453] mce: CPU supports 0 MCE banks
[    0.003693] SMP alternatives: switching to UP code
[    0.025713] Freeing SMP alternatives: 24k freed
[    0.025736] ACPI: Core revision 20120320
[    0.026449] ftrace: allocating 23073 entries in 91 pages
[    0.039831] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.049847] CPU0: Intel(R) Xeon(R) CPU           L5640  @ 2.27GHz stepping 02
[    0.049996] Performance Events: unsupported p6 CPU model 44 no PMU driver, software events only.
[    0.049996] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.049996] Brought up 1 CPUs
[    0.049996] Total of 1 processors activated (4533.73 BogoMIPS).
[    0.051186] devtmpfs: initialized
[    0.052641] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.052680] RTC time: 11:39:09, date: 10/31/12
[    0.052726] NET: Registered protocol family 16
[    0.053044] ACPI: bus type pci registered
[    0.053398] PCI: Using configuration type 1 for base access
[    0.054494] bio: create slab <bio-0> at 0
[    0.054574] ACPI: Added _OSI(Module Device)
[    0.054579] ACPI: Added _OSI(Processor Device)
[    0.054583] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.054587] ACPI: Added _OSI(Processor Aggregator Device)
[    0.055150] ACPI: EC: Look up EC in DSDT
[    0.056561] ACPI: Interpreter enabled
[    0.056569] ACPI: (supports S0 S5)
[    0.056586] ACPI: Using IOAPIC for interrupt routing
[    0.058580] ACPI: No dock devices found.
[    0.058589] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.058623] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.058662] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.058668] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.058674] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.058680] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xf4ffffff]
[    0.058719] PCI host bridge to bus 0000:00
[    0.058725] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.058730] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.058734] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.058740] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xf4ffffff]
[    0.058888] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.060341] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.062468] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.063798] pci 0000:00:01.1: reg 20: [io  0xc000-0xc00f]
[    0.064737] pci 0000:00:01.2: [8086:7113] type 00 class 0x068000
[    0.066604] pci 0000:00:01.2: quirk: [io  0x1f40-0x1f7f] claimed by PIIX4 ACPI
[    0.067167] pci 0000:00:01.3: [8086:7020] type 00 class 0x0c0300
[    0.068505] pci 0000:00:01.3: reg 20: [io  0xc020-0xc03f]
[    0.069531] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.069840] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pref]
[    0.070066] pci 0000:00:02.0: reg 14: [mem 0xf2000000-0xf2000fff]
[    0.071671] pci 0000:00:03.0: [5853:0001] type 00 class 0x010000
[    0.072032] pci 0000:00:03.0: reg 10: [io  0xc100-0xc1ff]
[    0.072275] pci 0000:00:03.0: reg 14: [mem 0xf3000000-0xf3ffffff pref]
[    0.074114] pci 0000:00:06.0: [8086:10ed] type 00 class 0x020000
[    0.075080] pci 0000:00:06.0: reg 10: [mem 0xf4020000-0xf4023fff 64bit]
[    0.076389] pci 0000:00:06.0: reg 1c: [mem 0xf4024000-0xf4027fff 64bit]
[    0.079467] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.079705]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
[    0.083474] ACPI: PCI Interrupt Link [LNKA] (IRQs *5 7 10 11)
[    0.083650] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *7 10 11)
[    0.083822] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 *10 11)
[    0.084068] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 *11)
[    0.084195] xen/balloon: Initialising balloon driver.
[    0.084212] xen-balloon: Initialising balloon driver.
[    0.084340] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.084348] vgaarb: loaded
[    0.084351] vgaarb: bridge control possible 0000:00:02.0
[    0.084431] SCSI subsystem initialized
[    0.084468] libata version 3.00 loaded.
[    0.084501] ACPI: bus type usb registered
[    0.084524] usbcore: registered new interface driver usbfs
[    0.084537] usbcore: registered new interface driver hub
[    0.084562] usbcore: registered new device driver usb
[    0.084626] PCI: Using ACPI for IRQ routing
[    0.084631] PCI: pci_cache_line_size set to 64 bytes
[    0.085209] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.085212] e820: reserve RAM buffer [mem 0x3fffac00-0x3fffffff]
[    0.085323] NetLabel: Initializing
[    0.085328] NetLabel:  domain hash size = 128
[    0.085331] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.085344] NetLabel:  unlabeled traffic allowed by default
[    0.085416] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.085431] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.085438] hpet0: 3 comparators, 64-bit 70.836816 MHz counter
[    0.088026] Switching to clocksource hpet
[    0.096355] pnp: PnP ACPI init
[    0.096371] ACPI: bus type pnp registered
[    0.096392] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.096425] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.096433] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.096465] pnp 00:01: [bus 00-ff]
[    0.096468] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.096471] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.096473] pnp 00:01: [io  0x0d00-0xffff window]
[    0.096476] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.096479] pnp 00:01: [mem 0xf0000000-0xf4ffffff]
[    0.096503] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.096513] pnp 00:02: [io  0x10c0-0x10c2]
[    0.096516] pnp 00:02: [io  0xb044-0xb047]
[    0.096545] system 00:02: [io  0x10c0-0x10c2] has been reserved
[    0.096551] system 00:02: [io  0xb044-0xb047] has been reserved
[    0.096557] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.096811] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.096835] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.096857] pnp 00:04: [io  0x0010-0x001f]
[    0.096859] pnp 00:04: [io  0x0022-0x002d]
[    0.096862] pnp 00:04: [io  0x0030-0x003f]
[    0.096864] pnp 00:04: [io  0x0044-0x005f]
[    0.096866] pnp 00:04: [io  0x0062-0x0063]
[    0.096868] pnp 00:04: [io  0x0065-0x006f]
[    0.096871] pnp 00:04: [io  0x0072-0x007f]
[    0.096873] pnp 00:04: [io  0x0080]
[    0.096875] pnp 00:04: [io  0x0084-0x0086]
[    0.096877] pnp 00:04: [io  0x0088]
[    0.096879] pnp 00:04: [io  0x008c-0x008e]
[    0.096882] pnp 00:04: [io  0x0090-0x009f]
[    0.096884] pnp 00:04: [io  0x00a2-0x00bd]
[    0.096886] pnp 00:04: [io  0x00e0-0x00ef]
[    0.096888] pnp 00:04: [io  0x08a0-0x08a3]
[    0.096891] pnp 00:04: [io  0x0cc0-0x0ccf]
[    0.096893] pnp 00:04: [io  0x04d0-0x04d1]
[    0.096932] system 00:04: [io  0x08a0-0x08a3] has been reserved
[    0.096939] system 00:04: [io  0x0cc0-0x0ccf] has been reserved
[    0.096944] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    0.096950] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.096964] pnp 00:05: [dma 4]
[    0.096966] pnp 00:05: [io  0x0000-0x000f]
[    0.096969] pnp 00:05: [io  0x0081-0x0083]
[    0.096971] pnp 00:05: [io  0x0087]
[    0.096973] pnp 00:05: [io  0x0089-0x008b]
[    0.096976] pnp 00:05: [io  0x008f]
[    0.096978] pnp 00:05: [io  0x00c0-0x00df]
[    0.096980] pnp 00:05: [io  0x0480-0x048f]
[    0.097002] pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.097063] pnp 00:06: [io  0x0070-0x0071]
[    0.097084] pnp 00:06: [irq 8]
[    0.097115] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.097125] pnp 00:07: [io  0x0061]
[    0.097147] pnp 00:07: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.097185] pnp 00:08: [irq 12]
[    0.097212] pnp 00:08: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.097230] pnp 00:09: [io  0x0060]
[    0.097232] pnp 00:09: [io  0x0064]
[    0.097251] pnp 00:09: [irq 1]
[    0.097279] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.097299] pnp 00:0a: [io  0x03f0-0x03f5]
[    0.097301] pnp 00:0a: [io  0x03f7]
[    0.097319] pnp 00:0a: [irq 6]
[    0.097322] pnp 00:0a: [dma 2]
[    0.097346] pnp 00:0a: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.097372] pnp 00:0b: [io  0x03f8-0x03ff]
[    0.097391] pnp 00:0b: [irq 4]
[    0.097419] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.097565] pnp: PnP ACPI: found 12 devices
[    0.097570] ACPI: ACPI bus type pnp unregistered
[    0.103895] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.103899] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.103902] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.103904] pci_bus 0000:00: resource 7 [mem 0xf0000000-0xf4ffffff]
[    0.103942] NET: Registered protocol family 2
[    0.104059] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.104396] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    0.104917] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.105164] TCP: Hash tables configured (established 131072 bind 65536)
[    0.105169] TCP: reno registered
[    0.105178] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.105191] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.105254] NET: Registered protocol family 1
[    0.105268] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.105329] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.105405] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.105882] pci 0000:00:02.0: Boot video device
[    0.106032] PCI: CLS 0 bytes, default 64
[    0.106076] Unpacking initramfs...
[    0.514071] Freeing initrd memory: 14512k freed
[    0.520187] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.520475] audit: initializing netlink socket (disabled)
[    0.520493] type=2000 audit(1351683549.519:1): initialized
[    0.548550] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.550379] VFS: Disk quotas dquot_6.5.2
[    0.550435] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.550892] msgmni has been set to 1983
[    0.550959] SELinux:  Registering netfilter hooks
[    0.551447] alg: No test for stdrng (krng)
[    0.551455] NET: Registered protocol family 38
[    0.551501] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.551540] io scheduler noop registered
[    0.551544] io scheduler deadline registered
[    0.551580] io scheduler cfq registered (default)
[    0.551684] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.551709] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.551714] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.551777] acpiphp: Slot [1] registered
[    0.551797] acpiphp: Slot [2] registered
[    0.551909] efifb: probing for efifb
[    0.552061] efifb: framebuffer at 0xf0000000, mapped to 0xffffc90000500000, using 1408k, total 1408k
[    0.552068] efifb: mode is 800x600x24, linelength=2400, pages=1
[    0.552071] efifb: scrolling: redraw
[    0.552075] efifb: Truecolor: size=0:8:8:8, shift=0:16:8:0
[    0.554963] Console: switching to colour frame buffer device 100x37
[    0.557505] fb0: EFI VGA frame buffer device
[    0.557558] intel_idle: does not run on family 6 model 44
[    0.559150] GHES: HEST is not enabled!
[    0.560329] Grant tables using version 1 layout.
[    0.561053] Grant table initialized
[    0.563974] Cannot get hvm parameter 18: -22!
[    0.564057] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.564761] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16450
[    0.567223] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16450
[    0.568715] Non-volatile memory driver v1.3
[    0.569901] Linux agpgart interface v0.103
[    0.571940] loop: module loaded
[    0.573169] ata_piix 0000:00:01.1: version 2.13
[    0.573412] ata_piix 0000:00:01.1: setting latency timer to 64
[    0.573953] scsi0 : ata_piix
[    0.575153] scsi1 : ata_piix
[    0.576294] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14
[    0.577438] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15
[    0.579517] Fixed MDIO Bus: probed
[    0.581517] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.582644] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.583781] uhci_hcd: USB Universal Host Controller Interface driver
[    0.585135] uhci_hcd 0000:00:01.3: setting latency timer to 64
[    0.585173] uhci_hcd 0000:00:01.3: UHCI Host Controller
[    0.586346] uhci_hcd 0000:00:01.3: new USB bus registered, assigned bus number 1
[    0.587784] uhci_hcd 0000:00:01.3: irq 23, io base 0x0000c020
[    0.589922] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    0.591061] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.592231] usb usb1: Product: UHCI Host Controller
[    0.593403] usb usb1: Manufacturer: Linux 3.5.4-1.fc17.x86_64 uhci_hcd
[    0.594585] usb usb1: SerialNumber: 0000:00:01.3
[    0.595842] hub 1-0:1.0: USB hub found
[    0.597033] hub 1-0:1.0: 2 ports detected
[    0.598354] usbcore: registered new interface driver usbserial
[    0.599501] usbcore: registered new interface driver usbserial_generic
[    0.600611] USB Serial support registered for generic
[    0.601705] usbserial: USB Serial Driver core
[    0.602837] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.606311] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.607478] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.608710] mousedev: PS/2 mouse device common for all mice
[    0.610891] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.618267] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.619536] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[    0.626404] device-mapper: uevent: version 1.0.3
[    0.629046] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    0.630380] cpuidle: using governor ladder
[    0.631644] cpuidle: using governor menu
[    0.632955] EFI Variables Facility v0.08 2004-May-17
[    0.634343] usbcore: registered new interface driver usbhid
[    0.635674] usbhid: USB HID core driver
[    0.636960] drop_monitor: Initializing network drop monitor service
[    0.638351] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.639670] TCP: cubic registered
[    0.640945] Initializing XFRM netlink socket
[    0.642333] NET: Registered protocol family 10
[    0.643824] mip6: Mobile IPv6
[    0.645084] NET: Registered protocol family 17
[    0.646337] Key type dns_resolver registered
[    0.647724] PM: Hibernation image not present or could not be loaded.
[    0.647735] registered taskstats version 1
[    0.649679] XENBUS: Device with no driver: device/vbd/768
[    0.650905] XENBUS: Device with no driver: device/vbd/5632
[    0.652099] XENBUS: Device with no driver: device/pci/0
[    0.653302] XENBUS: Device with no driver: device/vif/0
[    0.654508]   Magic number: 0:653:682
[    0.655758] rtc_cmos 00:06: setting system clock to 2012-10-31 11:39:09 UTC (1351683549)
[    0.734310] ata2.00: ATAPI: QEMU CD-ROM, 0.8.2, max UDMA/100
[    0.737067] ata2.00: configured for MWDMA2
[    0.740507] scsi 1:0:0:0: CD-ROM            QEMU     QEMU CD-ROM      0.8. PQ: 0 ANSI: 5
[    0.743836] ata2: drained 28 bytes to clear DRQ
[    0.743841] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[    0.745072] ata2.00: BMDMA stat 0x5
[    0.746296] sr 1:0:0:0: CDB:
[    0.747495] Mode Sense(10): 5a 00 2a 00 00 00 00 00 80 00
[    0.748728] ata2.00: cmd a0/01:00:00:80:00/00:00:00:00:00/a0 tag 0 dma 16512 in
[    0.748728]          res 48/00:02:00:1c:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
[    0.751056] ata2.00: status: { DRDY DRQ }
[    0.752576] ata2: soft resetting link
[    0.900093] usb 1-2: new full-speed USB device number 2 using uhci_hcd
[    0.908193] ata2.00: configured for MWDMA2
[    0.909947] ata2: EH complete
[    0.911089] sr0: scsi-1 drive
[    0.912203] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.913431] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    0.913907] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    0.917115] Freeing unused kernel memory: 1016k freed
[    0.918435] Write protecting the kernel read-only data: 12288k
[    0.927222] Freeing unused kernel memory: 1936k freed
[    0.936163] Freeing unused kernel memory: 1464k freed
[    0.995483] dracut: dracut-018-98.git20120813.fc17
[    1.044758] udevd[118]: starting version 182
[    1.065510] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input1
[    1.118295] dracut: Starting plymouth daemon
[    1.312103] blkfront: xvda: barrier or flush: disabled
[    1.313300] vbd vbd-5632: 19 xenbus_dev_probe on device/vbd/5632
[    1.320460]  xvda: xvda1 xvda2
[    1.364359] usb 1-2: New USB device found, idVendor=0627, idProduct=0001
[    1.364364] usb 1-2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.364367] usb 1-2: Product: QEMU USB Tablet
[    1.364369] usb 1-2: Manufacturer: QEMU 0.8.2
[    1.364372] usb 1-2: SerialNumber: 1
[    1.518082] Refined TSC clocksource calibration: 2266.775 MHz.
[    1.518088] Switching to clocksource tsc
[    1.524582] input: QEMU 0.8.2 QEMU USB Tablet as /devices/pci0000:00/0000:00:01.3/usb1/1-2/1-2:1.0/input/input2
[    1.524691] hid-generic 0003:0627:0001.0001: input,hidraw0: USB HID v0.01 Pointer [QEMU 0.8.2 QEMU USB Tablet] on usb-0000:00:01.3-2/input0
[    1.565662] dracut: Scanning devices xvda2  for LVM logical volumes vg_f17x64hvm01/lv_root vg_f17x64hvm01/lv_swap
[    1.576180] dracut: inactive '/dev/vg_f17x64hvm01/lv_swap' [1.97 GiB] inherit
[    1.576412] dracut: inactive '/dev/vg_f17x64hvm01/lv_root' [15.53 GiB] inherit
[    1.726230] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[    1.784148] dracut: Checking ext4: /dev/mapper/vg_f17x64hvm01-lv_root
[    1.784351] dracut: issuing e2fsck -a  /dev/mapper/vg_f17x64hvm01-lv_root
[    1.801138] dracut: /dev/mapper/vg_f17x64hvm01-lv_root: clean, 28180/1018000 files, 327793/4071424 blocks
[    1.802385] dracut: Remounting /dev/mapper/vg_f17x64hvm01-lv_root with -o ro
[    1.822950] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[    1.854460] dracut: Mounted root filesystem /dev/mapper/vg_f17x64hvm01-lv_root
[    1.935263] dracut: Switching root


-- Pasi


