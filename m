Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab2HRGJu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 02:09:50 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:38940 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2HRGJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 02:09:38 -0400
Date: Sat, 18 Aug 2012 08:09:34 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Jim Cromie <jim.cromie@gmail.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [bisected] Driver core fixes for 3.6-rc3 regression
Message-ID: <20120818060934.GA255@x4>
References: <20120817171354.GA14046@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20120817171354.GA14046@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.08.17 at 10:13 -0700, Greg KH wrote:
> ----------------------------------------------------------------
> Driver core fixes for 3.6-rc3
> 
> Here are two tiny patches, one fixing a dynamic debug problem that the printk
> rework turned up, and the other one fixing an extcon problem that people
> reported.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ----------------------------------------------------------------
> Axel Lin (1):
>       extcon: extcon_gpio: Replace gpio_request_one by devm_gpio_request_one
> 
> Jim Cromie (1):
>       drivers-core: make structured logging play nice with dynamic-debug

The commit af7f2158f above causes hundreds of "Failed to force enable
HPET" messages to appear during boot on my system.
Please also note the strange "^A0" character sequence that is also
introduced by the same commit.

Aug 18 07:48:58 x4 kernel: Linux version 3.6.0-rc2-00084-g225a389 (markus@x4) (gcc version 4.8.0 20120817 (experimental) (GCC) ) #219 SMP Sat Aug 18 07:48:39 CEST 2012
Aug 18 07:48:58 x4 kernel: Command line: root=PARTUUID=1E3384D0-CAE6-41BB-8CD6-4F640164EFD7 init=/sbin/minit rootflags=logbsize=256k fbcon=rotate:3 drm_kms_helper.poll=0 quiet
Aug 18 07:48:58 x4 kernel: KERNEL supported cpus:
Aug 18 07:48:58 x4 kernel: AMD AuthenticAMD
Aug 18 07:48:58 x4 kernel: e820: BIOS-provided physical RAM map:
Aug 18 07:48:58 x4 kernel: BIOS-e820: [mem 0x0000000000000100-0x000000000009fbff] usable
Aug 18 07:48:58 x4 kernel: BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
Aug 18 07:48:58 x4 kernel: BIOS-e820: [mem 0x00000000000e6000-0x00000000000fffff] reserved
Aug 18 07:48:58 x4 kernel: BIOS-e820: [mem 0x0000000000100000-0x00000000dfe8ffff] usable
Aug 18 07:48:58 x4 kernel: BIOS-e820: [mem 0x00000000dfe90000-0x00000000dfea7fff] ACPI data
Aug 18 07:48:58 x4 kernel: BIOS-e820: [mem 0x00000000dfea8000-0x00000000dfecffff] ACPI NVS
Aug 18 07:48:58 x4 kernel: BIOS-e820: [mem 0x00000000dfed0000-0x00000000dfefffff] reserved
Aug 18 07:48:58 x4 kernel: BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
Aug 18 07:48:58 x4 kernel: BIOS-e820: [mem 0x0000000100000000-0x000000021fffffff] usable
Aug 18 07:48:58 x4 kernel: NX (Execute Disable) protection: active
Aug 18 07:48:58 x4 kernel: DMI present.
Aug 18 07:48:58 x4 kernel: DMI: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
Aug 18 07:48:58 x4 kernel: e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
Aug 18 07:48:58 x4 kernel: e820: remove [mem 0x000a0000-0x000fffff] usable
Aug 18 07:48:58 x4 kernel: e820: last_pfn = 0x220000 max_arch_pfn = 0x400000000
Aug 18 07:48:58 x4 kernel: MTRR default type: uncachable
Aug 18 07:48:58 x4 kernel: MTRR fixed ranges enabled:
Aug 18 07:48:58 x4 kernel: 00000-9FFFF write-back
Aug 18 07:48:58 x4 kernel: A0000-EFFFF uncachable
Aug 18 07:48:58 x4 kernel: F0000-FFFFF write-protect
Aug 18 07:48:58 x4 kernel: MTRR variable ranges enabled:
Aug 18 07:48:58 x4 kernel: 0 base 000000000000 mask FFFF80000000 write-back
Aug 18 07:48:58 x4 kernel: 1 base 000080000000 mask FFFFC0000000 write-back
Aug 18 07:48:58 x4 kernel: 2 base 0000C0000000 mask FFFFE0000000 write-back
Aug 18 07:48:58 x4 kernel: 3 base 0000F0000000 mask FFFFF8000000 write-combining
Aug 18 07:48:58 x4 kernel: 4 disabled
Aug 18 07:48:58 x4 kernel: 5 disabled
Aug 18 07:48:58 x4 kernel: 6 disabled
Aug 18 07:48:58 x4 kernel: 7 disabled
Aug 18 07:48:58 x4 kernel: TOM2: 0000000220000000 aka 8704M
Aug 18 07:48:58 x4 kernel: x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
Aug 18 07:48:58 x4 kernel: e820: last_pfn = 0xdfe90 max_arch_pfn = 0x400000000
Aug 18 07:48:58 x4 kernel: initial memory mapped: [mem 0x00000000-0x1fffffff]
Aug 18 07:48:58 x4 kernel: Base memory trampoline at [ffff880000099000] 99000 size 24576
Aug 18 07:48:58 x4 kernel: Using GB pages for direct mapping
Aug 18 07:48:58 x4 kernel: init_memory_mapping: [mem 0x00000000-0xdfe8ffff]
Aug 18 07:48:58 x4 kernel: [mem 0x00000000-0xbfffffff] page 1G
Aug 18 07:48:58 x4 kernel: [mem 0xc0000000-0xdfdfffff] page 2M
Aug 18 07:48:58 x4 kernel: [mem 0xdfe00000-0xdfe8ffff] page 4k
Aug 18 07:48:58 x4 kernel: kernel direct mapping tables up to 0xdfe8ffff @ [mem 0x1f9fd000-0x1fffffff]
Aug 18 07:48:58 x4 kernel: init_memory_mapping: [mem 0x100000000-0x21fffffff]
Aug 18 07:48:58 x4 kernel: [mem 0x100000000-0x1ffffffff] page 1G
Aug 18 07:48:58 x4 kernel: [mem 0x200000000-0x21fffffff] page 2M
Aug 18 07:48:58 x4 kernel: kernel direct mapping tables up to 0x21fffffff @ [mem 0xdfe8e000-0xdfe8ffff]
Aug 18 07:48:58 x4 kernel: ACPI: RSDP 00000000000fb880 00024 (v02 ACPIAM)
Aug 18 07:48:58 x4 kernel: ACPI: XSDT 00000000dfe90100 0005C (v01 041311 XSDT1656 20110413 MSFT 00000097)
Aug 18 07:48:58 x4 kernel: ACPI: FACP 00000000dfe90290 000F4 (v03 041311 FACP1656 20110413 MSFT 00000097)
Aug 18 07:48:58 x4 kernel: ACPI BIOS Bug: Warning: Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20120711/tbfadt-598)
Aug 18 07:48:58 x4 kernel: ACPI: DSDT 00000000dfe90450 0E6FE (v01  A1152 A1152000 00000000 INTL 20060113)
Aug 18 07:48:58 x4 kernel: ACPI: FACS 00000000dfea8000 00040
Aug 18 07:48:58 x4 kernel: ACPI: APIC 00000000dfe90390 0007C (v01 041311 APIC1656 20110413 MSFT 00000097)
Aug 18 07:48:58 x4 kernel: ACPI: MCFG 00000000dfe90410 0003C (v01 041311 OEMMCFG  20110413 MSFT 00000097)
Aug 18 07:48:58 x4 kernel: ACPI: OEMB 00000000dfea8040 00072 (v01 041311 OEMB1656 20110413 MSFT 00000097)
Aug 18 07:48:58 x4 kernel: ACPI: SRAT 00000000dfe9f450 000E8 (v01 AMD    FAM_F_10 00000002 AMD  00000001)
Aug 18 07:48:58 x4 kernel: ACPI: HPET 00000000dfe9f540 00038 (v01 041311 OEMHPET  20110413 MSFT 00000097)
Aug 18 07:48:58 x4 kernel: ACPI: SSDT 00000000dfe9f580 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
Aug 18 07:48:58 x4 kernel: ACPI: Local APIC address 0xfee00000
Aug 18 07:48:58 x4 kernel: [ffffea0000000000-ffffea00087fffff] PMD -> [ffff880217600000-ffff88021f5fffff] on node 0
Aug 18 07:48:58 x4 kernel: Zone ranges:
Aug 18 07:48:58 x4 kernel: DMA      [mem 0x00010000-0x00ffffff]
Aug 18 07:48:58 x4 kernel: DMA32    [mem 0x01000000-0xffffffff]
Aug 18 07:48:58 x4 kernel: Normal   [mem 0x100000000-0x21fffffff]
Aug 18 07:48:58 x4 kernel: Movable zone start for each node
Aug 18 07:48:58 x4 kernel: Early memory node ranges
Aug 18 07:48:58 x4 kernel: node   0: [mem 0x00010000-0x0009efff]
Aug 18 07:48:58 x4 kernel: node   0: [mem 0x00100000-0xdfe8ffff]
Aug 18 07:48:58 x4 kernel: node   0: [mem 0x100000000-0x21fffffff]
Aug 18 07:48:58 x4 kernel: On node 0 totalpages: 2096671
Aug 18 07:48:58 x4 kernel: DMA zone: 64 pages used for memmap
Aug 18 07:48:58 x4 kernel: DMA zone: 6 pages reserved
Aug 18 07:48:58 x4 kernel: DMA zone: 3913 pages, LIFO batch:0
Aug 18 07:48:58 x4 kernel: DMA32 zone: 16320 pages used for memmap
Aug 18 07:48:58 x4 kernel: DMA32 zone: 896720 pages, LIFO batch:31
Aug 18 07:48:58 x4 kernel: Normal zone: 18432 pages used for memmap
Aug 18 07:48:58 x4 kernel: Normal zone: 1161216 pages, LIFO batch:31
Aug 18 07:48:58 x4 kernel: ACPI: PM-Timer IO Port: 0x808
Aug 18 07:48:58 x4 kernel: ACPI: Local APIC address 0xfee00000
Aug 18 07:48:58 x4 kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Aug 18 07:48:58 x4 kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Aug 18 07:48:58 x4 kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Aug 18 07:48:58 x4 kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Aug 18 07:48:58 x4 kernel: ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
Aug 18 07:48:58 x4 kernel: ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
Aug 18 07:48:58 x4 kernel: ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
Aug 18 07:48:58 x4 kernel: IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
Aug 18 07:48:58 x4 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Aug 18 07:48:58 x4 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Aug 18 07:48:58 x4 kernel: ACPI: IRQ0 used by override.
Aug 18 07:48:58 x4 kernel: ACPI: IRQ2 used by override.
Aug 18 07:48:58 x4 kernel: ACPI: IRQ9 used by override.
Aug 18 07:48:58 x4 kernel: Using ACPI (MADT) for SMP configuration information
Aug 18 07:48:58 x4 kernel: ACPI: HPET id: 0x8300 base: 0xfed00000
Aug 18 07:48:58 x4 kernel: smpboot: Allowing 4 CPUs, 0 hotplug CPUs
Aug 18 07:48:58 x4 kernel: nr_irqs_gsi: 40
Aug 18 07:48:58 x4 kernel: e820: [mem 0xdff00000-0xffefffff] available for PCI devices
Aug 18 07:48:58 x4 kernel: setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
Aug 18 07:48:58 x4 kernel: PERCPU: Embedded 23 pages/cpu @ffff88021fc00000 s73664 r0 d20544 u524288
Aug 18 07:48:58 x4 kernel: pcpu-alloc: s73664 r0 d20544 u524288 alloc=1*2097152
Aug 18 07:48:58 x4 kernel: pcpu-alloc: [0] 0 1 2 3 
Aug 18 07:48:58 x4 kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2061849
Aug 18 07:48:58 x4 kernel: Kernel command line: root=PARTUUID=1E3384D0-CAE6-41BB-8CD6-4F640164EFD7 init=/sbin/minit rootflags=logbsize=256k fbcon=rotate:3 drm_kms_helper.poll=0 quiet
Aug 18 07:48:58 x4 kernel: PID hash table entries: 4096 (order: 3, 32768 bytes)
Aug 18 07:48:58 x4 kernel: Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Aug 18 07:48:58 x4 kernel: Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Aug 18 07:48:58 x4 kernel: __ex_table already sorted, skipping sort
Aug 18 07:48:58 x4 kernel: Memory: 8167088k/8912896k available (4780k kernel code, 526212k absent, 219596k reserved, 3797k data, 440k init)
Aug 18 07:48:58 x4 kernel: SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Aug 18 07:48:58 x4 kernel: Hierarchical RCU implementation.
Aug 18 07:48:58 x4 kernel: NR_IRQS:4352 nr_irqs:712 16
Aug 18 07:48:58 x4 kernel: Extended CMOS year: 2000
Aug 18 07:48:58 x4 kernel: Console: colour VGA+ 80x25
Aug 18 07:48:58 x4 kernel: console [tty0] enabled
Aug 18 07:48:58 x4 kernel: hpet clockevent registered
Aug 18 07:48:58 x4 kernel: tsc: Fast TSC calibration using PIT
Aug 18 07:48:58 x4 kernel: tsc: Detected 3211.071 MHz processor
Aug 18 07:48:58 x4 kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 6424.73 BogoMIPS (lpj=10703570)
Aug 18 07:48:58 x4 kernel: pid_max: default: 32768 minimum: 301
Aug 18 07:48:58 x4 kernel: Mount-cache hash table entries: 256
Aug 18 07:48:58 x4 kernel: tseg: 0000000000
Aug 18 07:48:58 x4 kernel: CPU: Physical Processor ID: 0
Aug 18 07:48:58 x4 kernel: CPU: Processor Core ID: 0
Aug 18 07:48:58 x4 kernel: mce: CPU supports 6 MCE banks
Aug 18 07:48:58 x4 kernel: LVT offset 0 assigned for vector 0xf9
Aug 18 07:48:58 x4 kernel: process: using AMD E400 aware idle routine
Aug 18 07:48:58 x4 kernel: Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
Aug 18 07:48:58 x4 kernel: Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
Aug 18 07:48:58 x4 kernel: tlb_flushall_shift is 0xffffffff
Aug 18 07:48:58 x4 kernel: Freeing SMP alternatives: 16k freed
Aug 18 07:48:58 x4 kernel: ACPI: Core revision 20120711
Aug 18 07:48:58 x4 kernel: ..TIMER: vector=0x51 apic1=0 pin1=2 apic2=-1 pin2=-1
Aug 18 07:48:58 x4 kernel: smpboot: CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02
Aug 18 07:48:58 x4 kernel: Performance Events: AMD PMU driver.
Aug 18 07:48:58 x4 kernel: ... version:                0
Aug 18 07:48:58 x4 kernel: ... bit width:              48
Aug 18 07:48:58 x4 kernel: ... generic registers:      4
Aug 18 07:48:58 x4 kernel: ... value mask:             0000ffffffffffff
Aug 18 07:48:58 x4 kernel: ... max period:             00007fffffffffff
Aug 18 07:48:58 x4 kernel: ... fixed-purpose events:   0
Aug 18 07:48:58 x4 kernel: ... event mask:             000000000000000f
Aug 18 07:48:58 x4 kernel: MCE: In-kernel MCE decoding enabled.
Aug 18 07:48:58 x4 kernel: process: System has AMD C1E enabled
Aug 18 07:48:58 x4 kernel: process: Switch to broadcast mode on CPU0
Aug 18 07:48:58 x4 kernel: process: Switch to broadcast mode on CPU1
Aug 18 07:48:58 x4 kernel: process: Switch to broadcast mode on CPU2
Aug 18 07:48:58 x4 kernel: smpboot: Booting Node   0, Processors  #1 #2 #3 OK
Aug 18 07:48:58 x4 kernel: process: Switch to broadcast mode on CPU3
Aug 18 07:48:58 x4 kernel: Brought up 4 CPUs
Aug 18 07:48:58 x4 kernel: smpboot: Total of 4 processors activated (25698.92 BogoMIPS)
Aug 18 07:48:58 x4 kernel: devtmpfs: initialized
Aug 18 07:48:58 x4 kernel: NET: Registered protocol family 16
Aug 18 07:48:58 x4 kernel: node 0 link 0: io port [1000, ffffff]
Aug 18 07:48:58 x4 kernel: TOM: 00000000e0000000 aka 3584M
Aug 18 07:48:58 x4 kernel: Fam 10h mmconf [mem 0xe0000000-0xefffffff]
Aug 18 07:48:58 x4 kernel: node 0 link 0: mmio [a0000, bffff]
Aug 18 07:48:58 x4 kernel: node 0 link 0: mmio [e0000000, efffffff] ==> none
Aug 18 07:48:58 x4 kernel: node 0 link 0: mmio [f0000000, fbcfffff]
Aug 18 07:48:58 x4 kernel: node 0 link 0: mmio [fbd00000, fbefffff]
Aug 18 07:48:58 x4 kernel: node 0 link 0: mmio [fbf00000, ffefffff]
Aug 18 07:48:58 x4 kernel: TOM2: 0000000220000000 aka 8704M
Aug 18 07:48:58 x4 kernel: bus: [bus 00-07] on node 0 link 0
Aug 18 07:48:58 x4 kernel: bus: 00 [io  0x0000-0xffff]
Aug 18 07:48:58 x4 kernel: bus: 00 [mem 0x000a0000-0x000bffff]
Aug 18 07:48:58 x4 kernel: bus: 00 [mem 0xf0000000-0xffffffff]
Aug 18 07:48:58 x4 kernel: bus: 00 [mem 0x220000000-0xfcffffffff]
Aug 18 07:48:58 x4 kernel: ACPI: bus type pci registered
Aug 18 07:48:58 x4 kernel: PCI: Using configuration type 1 for base access
Aug 18 07:48:58 x4 kernel: PCI: Using configuration type 1 for extended access
Aug 18 07:48:58 x4 kernel: bio: create slab <bio-0> at 0
Aug 18 07:48:58 x4 kernel: ACPI: Added _OSI(Module Device)
Aug 18 07:48:58 x4 kernel: ACPI: Added _OSI(Processor Device)
Aug 18 07:48:58 x4 kernel: ACPI: Added _OSI(3.0 _SCP Extensions)
Aug 18 07:48:58 x4 kernel: ACPI: Added _OSI(Processor Aggregator Device)
Aug 18 07:48:58 x4 kernel: ACPI: EC: Look up EC in DSDT
Aug 18 07:48:58 x4 kernel: ACPI: Executed 3 blocks of module-level executable AML code
Aug 18 07:48:58 x4 kernel: ACPI: Interpreter enabled
Aug 18 07:48:58 x4 kernel: ACPI: (supports S0 S5)
Aug 18 07:48:58 x4 kernel: ACPI: Using IOAPIC for interrupt routing
Aug 18 07:48:58 x4 kernel: PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Aug 18 07:48:58 x4 kernel: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
Aug 18 07:48:58 x4 kernel: PCI host bridge to bus 0000:00
Aug 18 07:48:58 x4 kernel: pci_bus 0000:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:00: 0root bus resource [bus 00-ff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:00: 0root bus resource [io  0x0000-0x0cf7]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:00: 0root bus resource [io  0x0d00-0xffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:00: 0root bus resource [mem 0x000a0000-0x000bffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:00: 0root bus resource [mem 0x000d0000-0x000dffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:00: 0root bus resource [mem 0xdff00000-0xdfffffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:00: 0root bus resource [mem 0xf0000000-0xfebfffff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:00.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1022:9600] type 00 class 0x060000
Aug 18 07:48:58 x4 kernel: pci 0000:00:01.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1022:9602] type 01 class 0x060400
Aug 18 07:48:58 x4 kernel: pci 0000:00:06.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1022:9606] type 01 class 0x060400
Aug 18 07:48:58 x4 kernel: pci 0000:00:06.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: PME# supported from D0 D3hot D3cold
Aug 18 07:48:58 x4 kernel: pci 0000:00:11.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1002:4391] type 00 class 0x010601
Aug 18 07:48:58 x4 kernel: pci 0000:00:11.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 10: [io  0xc000-0xc007]
Aug 18 07:48:58 x4 kernel: pci 0000:00:11.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 14: [io  0xb000-0xb003]
Aug 18 07:48:58 x4 kernel: pci 0000:00:11.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 18: [io  0xa000-0xa007]
Aug 18 07:48:58 x4 kernel: pci 0000:00:11.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 1c: [io  0x9000-0x9003]
Aug 18 07:48:58 x4 kernel: pci 0000:00:11.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 20: [io  0x8000-0x800f]
Aug 18 07:48:58 x4 kernel: pci 0000:00:11.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 24: [mem 0xfbcffc00-0xfbcfffff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:12.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1002:4397] type 00 class 0x0c0310
Aug 18 07:48:58 x4 kernel: pci 0000:00:12.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 10: [mem 0xfbcfd000-0xfbcfdfff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:12.1: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1002:4398] type 00 class 0x0c0310
Aug 18 07:48:58 x4 kernel: pci 0000:00:12.1: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 10: [mem 0xfbcfe000-0xfbcfefff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:12.2: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1002:4396] type 00 class 0x0c0320
Aug 18 07:48:58 x4 kernel: pci 0000:00:12.2: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 10: [mem 0xfbcff800-0xfbcff8ff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:12.2: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: supports D1 D2
Aug 18 07:48:58 x4 kernel: pci 0000:00:12.2: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: PME# supported from D0 D1 D2 D3hot
Aug 18 07:48:58 x4 kernel: pci 0000:00:13.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1002:4397] type 00 class 0x0c0310
Aug 18 07:48:58 x4 kernel: pci 0000:00:13.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 10: [mem 0xfbcfb000-0xfbcfbfff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:13.1: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1002:4398] type 00 class 0x0c0310
Aug 18 07:48:58 x4 kernel: pci 0000:00:13.1: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 10: [mem 0xfbcfc000-0xfbcfcfff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:13.2: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1002:4396] type 00 class 0x0c0320
Aug 18 07:48:58 x4 kernel: pci 0000:00:13.2: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 10: [mem 0xfbcff400-0xfbcff4ff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:13.2: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: supports D1 D2
Aug 18 07:48:58 x4 kernel: pci 0000:00:13.2: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: PME# supported from D0 D1 D2 D3hot
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1002:4385] type 00 class 0x0c0500
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.1: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1002:439c] type 00 class 0x01018a
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.1: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 10: [io  0x0000-0x0007]
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.1: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 14: [io  0x0000-0x0003]
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.1: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 18: [io  0x0000-0x0007]
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.1: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 1c: [io  0x0000-0x0003]
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.1: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 20: [io  0xff00-0xff0f]
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.3: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1002:439d] type 00 class 0x060100
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.4: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1002:4384] type 01 class 0x060401
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.5: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1002:4399] type 00 class 0x0c0310
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.5: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 10: [mem 0xfbcfa000-0xfbcfafff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:18.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1022:1200] type 00 class 0x060000
Aug 18 07:48:58 x4 kernel: pci 0000:00:18.1: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1022:1201] type 00 class 0x060000
Aug 18 07:48:58 x4 kernel: pci 0000:00:18.2: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1022:1202] type 00 class 0x060000
Aug 18 07:48:58 x4 kernel: pci 0000:00:18.3: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1022:1203] type 00 class 0x060000
Aug 18 07:48:58 x4 kernel: pci 0000:00:18.4: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1022:1204] type 00 class 0x060000
Aug 18 07:48:58 x4 kernel: pci_bus 0000:01: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: busn_res: [bus 01] is inserted under [bus 00-ff]
Aug 18 07:48:58 x4 kernel: pci 0000:01:05.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1002:9614] type 00 class 0x030000
Aug 18 07:48:58 x4 kernel: pci 0000:01:05.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 10: [mem 0xf0000000-0xf7ffffff pref]
Aug 18 07:48:58 x4 kernel: pci 0000:01:05.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 14: [io  0xd000-0xd0ff]
Aug 18 07:48:58 x4 kernel: pci 0000:01:05.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 18: [mem 0xfbee0000-0xfbeeffff]
Aug 18 07:48:58 x4 kernel: pci 0000:01:05.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 24: [mem 0xfbd00000-0xfbdfffff]
Aug 18 07:48:58 x4 kernel: pci 0000:01:05.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: supports D1 D2
Aug 18 07:48:58 x4 kernel: pci 0000:01:05.1: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1002:960f] type 00 class 0x040300
Aug 18 07:48:58 x4 kernel: pci 0000:01:05.1: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 10: [mem 0xfbefc000-0xfbefffff]
Aug 18 07:48:58 x4 kernel: pci 0000:01:05.1: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: supports D1 D2
Aug 18 07:48:58 x4 kernel: pci 0000:00:01.0: 0PCI bridge to [bus 01]
Aug 18 07:48:58 x4 kernel: pci 0000:00:01.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: bridge window [io  0xd000-0xdfff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:01.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: bridge window [mem 0xfbd00000-0xfbefffff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:01.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:02: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: busn_res: [bus 02] is inserted under [bus 00-ff]
Aug 18 07:48:58 x4 kernel: pci 0000:02:00.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [1969:1026] type 00 class 0x020000
Aug 18 07:48:58 x4 kernel: pci 0000:02:00.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 10: [mem 0xfbfc0000-0xfbffffff 64bit]
Aug 18 07:48:58 x4 kernel: pci 0000:02:00.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: reg 18: [io  0xec00-0xec7f]
Aug 18 07:48:58 x4 kernel: pci 0000:02:00.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: PME# supported from D3hot D3cold
Aug 18 07:48:58 x4 kernel: pci 0000:00:06.0: 0PCI bridge to [bus 02]
Aug 18 07:48:58 x4 kernel: pci 0000:00:06.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: bridge window [io  0xe000-0xefff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:06.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: bridge window [mem 0xfbf00000-0xfbffffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:03: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: busn_res: [bus 03] is inserted under [bus 00-ff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.4: 0PCI bridge to [bus 03] (subtractive decode)
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.4: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: bridge window [io  0x0000-0x0cf7] (subtractive decode)
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.4: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: bridge window [io  0x0d00-0xffff] (subtractive decode)
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.4: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.4: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.4: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: bridge window [mem 0xdff00000-0xdfffffff] (subtractive decode)
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.4: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
Aug 18 07:48:58 x4 kernel: pci_bus 0000:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: on NUMA node 0
Aug 18 07:48:58 x4 kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Aug 18 07:48:58 x4 kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
Aug 18 07:48:58 x4 kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
Aug 18 07:48:58 x4 kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
Aug 18 07:48:58 x4 kernel: pci0000:00: 0ACPI _OSC support notification failed, disabling PCIe ASPM
Aug 18 07:48:58 x4 kernel: pci0000:00: 0Unable to request _OSC control (_OSC support mask: 0x08)
Aug 18 07:48:58 x4 kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Aug 18 07:48:58 x4 kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Aug 18 07:48:58 x4 kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Aug 18 07:48:58 x4 kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Aug 18 07:48:58 x4 kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Aug 18 07:48:58 x4 kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Aug 18 07:48:58 x4 kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Aug 18 07:48:58 x4 kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Aug 18 07:48:58 x4 kernel: SCSI subsystem initialized
Aug 18 07:48:58 x4 kernel: libata version 3.00 loaded.
Aug 18 07:48:58 x4 kernel: ACPI: bus type usb registered
Aug 18 07:48:58 x4 kernel: usbcore: registered new interface driver usbfs
Aug 18 07:48:58 x4 kernel: usbcore: registered new interface driver hub
Aug 18 07:48:58 x4 kernel: usbcore: registered new device driver usb
Aug 18 07:48:58 x4 kernel: Advanced Linux Sound Architecture Driver Version 1.0.25.
Aug 18 07:48:58 x4 kernel: PCI: Using ACPI for IRQ routing
Aug 18 07:48:58 x4 kernel: PCI: pci_cache_line_size set to 64 bytes
Aug 18 07:48:58 x4 kernel: e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
Aug 18 07:48:58 x4 kernel: e820: reserve RAM buffer [mem 0xdfe90000-0xdfffffff]
Aug 18 07:48:58 x4 kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
Aug 18 07:48:58 x4 kernel: hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Aug 18 07:48:58 x4 kernel: Switching to clocksource hpet
Aug 18 07:48:58 x4 kernel: pnp: PnP ACPI init
Aug 18 07:48:58 x4 kernel: ACPI: bus type pnp registered
Aug 18 07:48:58 x4 kernel: pnp 00:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [bus 00-ff]
Aug 18 07:48:58 x4 kernel: pnp 00:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0cf8-0x0cff]
Aug 18 07:48:58 x4 kernel: pnp 00:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0000-0x0cf7 window]
Aug 18 07:48:58 x4 kernel: pnp 00:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0d00-0xffff window]
Aug 18 07:48:58 x4 kernel: pnp 00:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0x000a0000-0x000bffff window]
Aug 18 07:48:58 x4 kernel: pnp 00:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0x000d0000-0x000dffff window]
Aug 18 07:48:58 x4 kernel: pnp 00:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0xdff00000-0xdfffffff window]
Aug 18 07:48:58 x4 kernel: pnp 00:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0xf0000000-0xfebfffff window]
Aug 18 07:48:58 x4 kernel: pnp 00:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: Plug and Play ACPI device, IDs PNP0a03 (active)
Aug 18 07:48:58 x4 kernel: pnp 00:01: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0x00000000-0xffffffffffffffff disabled]
Aug 18 07:48:58 x4 kernel: pnp 00:01: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0x00000000-0xffffffffffffffff disabled]
Aug 18 07:48:58 x4 kernel: system 00:01: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: Plug and Play ACPI device, IDs PNP0c02 (active)
Aug 18 07:48:58 x4 kernel: pnp 00:02: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [dma 4]
Aug 18 07:48:58 x4 kernel: pnp 00:02: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0000-0x000f]
Aug 18 07:48:58 x4 kernel: pnp 00:02: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0081-0x0083]
Aug 18 07:48:58 x4 kernel: pnp 00:02: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0087]
Aug 18 07:48:58 x4 kernel: pnp 00:02: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0089-0x008b]
Aug 18 07:48:58 x4 kernel: pnp 00:02: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x008f]
Aug 18 07:48:58 x4 kernel: pnp 00:02: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x00c0-0x00df]
Aug 18 07:48:58 x4 kernel: pnp 00:02: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: Plug and Play ACPI device, IDs PNP0200 (active)
Aug 18 07:48:58 x4 kernel: pnp 00:03: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0070-0x0071]
Aug 18 07:48:58 x4 kernel: pnp 00:03: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [irq 8]
Aug 18 07:48:58 x4 kernel: pnp 00:03: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: Plug and Play ACPI device, IDs PNP0b00 (active)
Aug 18 07:48:58 x4 kernel: pnp 00:04: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0061]
Aug 18 07:48:58 x4 kernel: pnp 00:04: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: Plug and Play ACPI device, IDs PNP0800 (active)
Aug 18 07:48:58 x4 kernel: pnp 00:05: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x00f0-0x00ff]
Aug 18 07:48:58 x4 kernel: pnp 00:05: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [irq 13]
Aug 18 07:48:58 x4 kernel: pnp 00:05: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: Plug and Play ACPI device, IDs PNP0c04 (active)
Aug 18 07:48:58 x4 kernel: pnp 00:06: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0xfed00000-0xfed003ff]
Aug 18 07:48:58 x4 kernel: pnp 00:06: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: Plug and Play ACPI device, IDs PNP0103 (active)
Aug 18 07:48:58 x4 kernel: pnp 00:07: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0060]
Aug 18 07:48:58 x4 kernel: pnp 00:07: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0064]
Aug 18 07:48:58 x4 kernel: pnp 00:07: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0xfec00000-0xfec00fff]
Aug 18 07:48:58 x4 kernel: pnp 00:07: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0xfee00000-0xfee00fff]
Aug 18 07:48:58 x4 kernel: system 00:07: 0[mem 0xfec00000-0xfec00fff] could not be reserved
Aug 18 07:48:58 x4 kernel: system 00:07: 0[mem 0xfee00000-0xfee00fff] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:07: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: Plug and Play ACPI device, IDs PNP0c02 (active)
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0010-0x001f]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0022-0x003f]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0062-0x0063]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0065-0x006f]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0072-0x007f]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0080]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0084-0x0086]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0088]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x008c-0x008e]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0090-0x009f]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x00a2-0x00bf]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x00b1]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x00e0-0x00ef]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x04d0-0x04d1]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x040b]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x04d6]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0c00-0x0c01]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0c14]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0c50-0x0c51]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0c52]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0c6c]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0c6f]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0cd0-0x0cd1]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0cd2-0x0cd3]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0cd4-0x0cd5]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0cd6-0x0cd7]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0cd8-0x0cdf]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0b00-0x0b3f]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0800-0x089f]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0000-0xffffffffffffffff disabled]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0b00-0x0b0f]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0b20-0x0b3f]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0900-0x090f]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0910-0x091f]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0xfe00-0xfefe]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0060]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0064]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0xdff00000-0xdfffffff]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0xffb80000-0xffbfffff]
Aug 18 07:48:58 x4 kernel: pnp 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0xfec10000-0xfec1001f]
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x04d0-0x04d1] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x040b] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x04d6] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0c00-0x0c01] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0c14] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0c50-0x0c51] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0c52] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0c6c] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0c6f] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0cd0-0x0cd1] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0cd2-0x0cd3] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0cd4-0x0cd5] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0cd6-0x0cd7] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0cd8-0x0cdf] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0b00-0x0b3f] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0800-0x089f] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0b00-0x0b0f] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0b20-0x0b3f] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0900-0x090f] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0x0910-0x091f] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[io  0xfe00-0xfefe] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[mem 0xdff00000-0xdfffffff] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[mem 0xffb80000-0xffbfffff] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: 0[mem 0xfec10000-0xfec1001f] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:08: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: Plug and Play ACPI device, IDs PNP0c02 (active)
Aug 18 07:48:58 x4 kernel: pnp 00:09: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0000-0xffffffffffffffff disabled]
Aug 18 07:48:58 x4 kernel: pnp 00:09: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0230-0x023f]
Aug 18 07:48:58 x4 kernel: pnp 00:09: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0290-0x029f]
Aug 18 07:48:58 x4 kernel: pnp 00:09: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0f40-0x0f4f]
Aug 18 07:48:58 x4 kernel: pnp 00:09: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [io  0x0a30-0x0a3f]
Aug 18 07:48:58 x4 kernel: system 00:09: 0[io  0x0230-0x023f] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:09: 0[io  0x0290-0x029f] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:09: 0[io  0x0f40-0x0f4f] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:09: 0[io  0x0a30-0x0a3f] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:09: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: Plug and Play ACPI device, IDs PNP0c02 (active)
Aug 18 07:48:58 x4 kernel: pnp 00:0a: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0xe0000000-0xefffffff]
Aug 18 07:48:58 x4 kernel: system 00:0a: 0[mem 0xe0000000-0xefffffff] has been reserved
Aug 18 07:48:58 x4 kernel: system 00:0a: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: Plug and Play ACPI device, IDs PNP0c02 (active)
Aug 18 07:48:58 x4 kernel: pnp 00:0b: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0x00000000-0x0009ffff]
Aug 18 07:48:58 x4 kernel: pnp 00:0b: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0x000c0000-0x000cffff]
Aug 18 07:48:58 x4 kernel: pnp 00:0b: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0x000e0000-0x000fffff]
Aug 18 07:48:58 x4 kernel: pnp 00:0b: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0x00100000-0xdfefffff]
Aug 18 07:48:58 x4 kernel: pnp 00:0b: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [mem 0xfec00000-0xffffffff]
Aug 18 07:48:58 x4 kernel: system 00:0b: 0[mem 0x00000000-0x0009ffff] could not be reserved
Aug 18 07:48:58 x4 kernel: system 00:0b: 0[mem 0x000c0000-0x000cffff] could not be reserved
Aug 18 07:48:58 x4 kernel: system 00:0b: 0[mem 0x000e0000-0x000fffff] could not be reserved
Aug 18 07:48:58 x4 kernel: system 00:0b: 0[mem 0x00100000-0xdfefffff] could not be reserved
Aug 18 07:48:58 x4 kernel: system 00:0b: 0[mem 0xfec00000-0xffffffff] could not be reserved
Aug 18 07:48:58 x4 kernel: system 00:0b: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: Plug and Play ACPI device, IDs PNP0c01 (active)
Aug 18 07:48:58 x4 kernel: pnp: PnP ACPI: found 12 devices
Aug 18 07:48:58 x4 kernel: ACPI: ACPI bus type pnp unregistered
Aug 18 07:48:58 x4 kernel: pci 0000:00:01.0: 0PCI bridge to [bus 01]
Aug 18 07:48:58 x4 kernel: pci 0000:00:01.0: 0  bridge window [io  0xd000-0xdfff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:01.0: 0  bridge window [mem 0xfbd00000-0xfbefffff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:01.0: 0  bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
Aug 18 07:48:58 x4 kernel: pci 0000:00:06.0: 0PCI bridge to [bus 02]
Aug 18 07:48:58 x4 kernel: pci 0000:00:06.0: 0  bridge window [io  0xe000-0xefff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:06.0: 0  bridge window [mem 0xfbf00000-0xfbffffff]
Aug 18 07:48:58 x4 kernel: pci 0000:00:14.4: 0PCI bridge to [bus 03]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 4 [io  0x0000-0x0cf7]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 5 [io  0x0d00-0xffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 6 [mem 0x000a0000-0x000bffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 7 [mem 0x000d0000-0x000dffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 8 [mem 0xdff00000-0xdfffffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:00: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 9 [mem 0xf0000000-0xfebfffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:01: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 0 [io  0xd000-0xdfff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:01: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 1 [mem 0xfbd00000-0xfbefffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:01: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:02: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 0 [io  0xe000-0xefff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:02: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 1 [mem 0xfbf00000-0xfbffffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:03: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 4 [io  0x0000-0x0cf7]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:03: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 5 [io  0x0d00-0xffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:03: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 6 [mem 0x000a0000-0x000bffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:03: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 7 [mem 0x000d0000-0x000dffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:03: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 8 [mem 0xdff00000-0xdfffffff]
Aug 18 07:48:58 x4 kernel: pci_bus 0000:03: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: resource 9 [mem 0xf0000000-0xfebfffff]
Aug 18 07:48:58 x4 kernel: NET: Registered protocol family 2
Aug 18 07:48:58 x4 kernel: TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
Aug 18 07:48:58 x4 kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Aug 18 07:48:58 x4 kernel: TCP: Hash tables configured (established 262144 bind 65536)
Aug 18 07:48:58 x4 kernel: TCP: reno registered
Aug 18 07:48:58 x4 kernel: UDP hash table entries: 4096 (order: 5, 131072 bytes)
Aug 18 07:48:58 x4 kernel: UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
Aug 18 07:48:58 x4 kernel: NET: Registered protocol family 1
Aug 18 07:48:58 x4 kernel: pci 0000:00:01.0: usableMSI quirk detected; subordinate MSI disabled
Aug 18 07:48:58 x4 kernel: pci 0000:01:05.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: Boot video device
Aug 18 07:48:58 x4 kernel: PCI: CLS 64 bytes, default 64
Aug 18 07:48:58 x4 kernel: PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Aug 18 07:48:58 x4 kernel: software IO TLB [mem 0xdbe8e000-0xdfe8dfff] (64MB) mapped at [ffff8800dbe8e000-ffff8800dfe8dfff]
Aug 18 07:48:58 x4 kernel: kvm: Nested Virtualization enabled
Aug 18 07:48:58 x4 kernel: kvm: Nested Paging enabled
Aug 18 07:48:58 x4 kernel: LVT offset 1 assigned for vector 0x400
Aug 18 07:48:58 x4 kernel: IBS: LVT offset 1 assigned
Aug 18 07:48:58 x4 kernel: perf: AMD IBS detected (0x0000001f)
Aug 18 07:48:58 x4 kernel: microcode: CPU0: patch_level=0x010000db
Aug 18 07:48:58 x4 kernel: microcode: CPU1: patch_level=0x010000db
Aug 18 07:48:58 x4 kernel: microcode: CPU2: patch_level=0x010000db
Aug 18 07:48:58 x4 kernel: microcode: CPU3: patch_level=0x010000db
Aug 18 07:48:58 x4 kernel: microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Aug 18 07:48:58 x4 kernel: SGI XFS with security attributes, large block/inode numbers, no debug enabled
Aug 18 07:48:58 x4 kernel: msgmni has been set to 15951
Aug 18 07:48:58 x4 kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Aug 18 07:48:58 x4 kernel: io scheduler noop registered
Aug 18 07:48:58 x4 kernel: io scheduler deadline registered (default)
Aug 18 07:48:58 x4 kernel: input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
Aug 18 07:48:58 x4 kernel: ACPI: Power Button [PWRB]
Aug 18 07:48:58 x4 kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Aug 18 07:48:58 x4 kernel: ACPI: Power Button [PWRF]
Aug 18 07:48:58 x4 kernel: ACPI: processor limited to max C-state 1
Aug 18 07:48:58 x4 kernel: [drm] Initialized drm 1.1.0 20060810
Aug 18 07:48:58 x4 kernel: [drm] radeon defaulting to kernel modesetting.
Aug 18 07:48:58 x4 kernel: [drm] radeon kernel modesetting enabled.
Aug 18 07:48:58 x4 kernel: [drm] initializing kernel modesetting (RS780 0x1002:0x9614 0x1043:0x834D).
Aug 18 07:48:58 x4 kernel: [drm] register mmio base: 0xFBEE0000
Aug 18 07:48:58 x4 kernel: [drm] register mmio size: 65536
Aug 18 07:48:58 x4 kernel: ATOM BIOS: 113
Aug 18 07:48:58 x4 kernel: radeon 0000:01:05.0: 0VRAM: 128M 0x00000000C0000000 - 0x00000000C7FFFFFF (128M used)
Aug 18 07:48:58 x4 kernel: radeon 0000:01:05.0: 0GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
Aug 18 07:48:58 x4 kernel: [drm] Detected VRAM RAM=128M, BAR=128M
Aug 18 07:48:58 x4 kernel: [drm] RAM width 32bits DDR
Aug 18 07:48:58 x4 kernel: [TTM] Zone  kernel: Available graphics memory: 4083552 kiB
Aug 18 07:48:58 x4 kernel: [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
Aug 18 07:48:58 x4 kernel: [TTM] Initializing pool allocator
Aug 18 07:48:58 x4 kernel: [TTM] Initializing DMA pool allocator
Aug 18 07:48:58 x4 kernel: [drm] radeon: 128M of VRAM memory ready
Aug 18 07:48:58 x4 kernel: [drm] radeon: 512M of GTT memory ready.
Aug 18 07:48:58 x4 kernel: [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
Aug 18 07:48:58 x4 kernel: [drm] Driver supports precise vblank timestamp query.
Aug 18 07:48:58 x4 kernel: [drm] radeon: irq initialized.
Aug 18 07:48:58 x4 kernel: [drm] GART: num cpu pages 131072, num gpu pages 131072
Aug 18 07:48:58 x4 kernel: [drm] Loading RS780 Microcode
Aug 18 07:48:58 x4 kernel: [drm] PCIE GART of 512M enabled (table at 0x00000000C0040000).
Aug 18 07:48:58 x4 kernel: radeon 0000:01:05.0: 0WB enabled
Aug 18 07:48:58 x4 kernel: radeon 0000:01:05.0: 0fence driver on ring 0 use gpu addr 0x00000000a0000c00 and cpu addr 0xffff880215c5dc00
Aug 18 07:48:58 x4 kernel: radeon 0000:01:05.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: setting latency timer to 64
Aug 18 07:48:58 x4 kernel: [drm] ring test on 0 succeeded in 0 usecs
Aug 18 07:48:58 x4 kernel: [drm] ib test on ring 0 succeeded in 0 usecs
Aug 18 07:48:58 x4 kernel: [drm] Radeon Display Connectors
Aug 18 07:48:58 x4 kernel: [drm] Connector 0:
Aug 18 07:48:58 x4 kernel: [drm]   VGA-1
Aug 18 07:48:58 x4 kernel: [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
Aug 18 07:48:58 x4 kernel: [drm]   Encoders:
Aug 18 07:48:58 x4 kernel: [drm]     CRT1: INTERNAL_KLDSCP_DAC1
Aug 18 07:48:58 x4 kernel: [drm] Connector 1:
Aug 18 07:48:58 x4 kernel: [drm]   DVI-D-1
Aug 18 07:48:58 x4 kernel: [drm]   HPD3
Aug 18 07:48:58 x4 kernel: [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
Aug 18 07:48:58 x4 kernel: [drm]   Encoders:
Aug 18 07:48:58 x4 kernel: [drm]     DFP3: INTERNAL_KLDSCP_LVTMA
Aug 18 07:48:58 x4 kernel: [drm] radeon: power management initialized
Aug 18 07:48:58 x4 kernel: [drm] fb mappable at 0xF0142000
Aug 18 07:48:58 x4 kernel: [drm] vram apper at 0xF0000000
Aug 18 07:48:58 x4 kernel: [drm] size 7299072
Aug 18 07:48:58 x4 kernel: [drm] fb depth is 24
Aug 18 07:48:58 x4 kernel: [drm]    pitch is 6912
Aug 18 07:48:58 x4 kernel: fbcon: radeondrmfb (fb0) is primary device
Aug 18 07:48:58 x4 kernel: Console: switching to colour frame buffer device 131x105
Aug 18 07:48:58 x4 kernel: fb0: radeondrmfb frame buffer device
Aug 18 07:48:58 x4 kernel: drm: registered panic notifier
Aug 18 07:48:58 x4 kernel: [drm] Initialized radeon 2.20.0 20080528 for 0000:01:05.0 on minor 0
Aug 18 07:48:58 x4 kernel: loop: module loaded
Aug 18 07:48:58 x4 kernel: ahci 0000:00:11.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: version 3.0
Aug 18 07:48:58 x4 kernel: ahci 0000:00:11.0: 0AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
Aug 18 07:48:58 x4 kernel: ahci 0000:00:11.0: 0flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
Aug 18 07:48:58 x4 kernel: scsi0 : ahci
Aug 18 07:48:58 x4 kernel: scsi1 : ahci
Aug 18 07:48:58 x4 kernel: scsi2 : ahci
Aug 18 07:48:58 x4 kernel: scsi3 : ahci
Aug 18 07:48:58 x4 kernel: scsi4 : ahci
Aug 18 07:48:58 x4 kernel: scsi5 : ahci
Aug 18 07:48:58 x4 kernel: ata1: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd00 irq 22
Aug 18 07:48:58 x4 kernel: ata2: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd80 irq 22
Aug 18 07:48:58 x4 kernel: ata3: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe00 irq 22
Aug 18 07:48:58 x4 kernel: ata4: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe80 irq 22
Aug 18 07:48:58 x4 kernel: ata5: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcfff00 irq 22
Aug 18 07:48:58 x4 kernel: ata6: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcfff80 irq 22
Aug 18 07:48:58 x4 kernel: scsi6 : pata_atiixp
Aug 18 07:48:58 x4 kernel: scsi7 : pata_atiixp
Aug 18 07:48:58 x4 kernel: ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
Aug 18 07:48:58 x4 kernel: ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
Aug 18 07:48:58 x4 kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Aug 18 07:48:58 x4 kernel: ehci_hcd 0000:00:12.2: 0EHCI Host Controller
Aug 18 07:48:58 x4 kernel: ehci_hcd 0000:00:12.2: 0new USB bus registered, assigned bus number 1
Aug 18 07:48:58 x4 kernel: QUIRK: Enable AMD PLL fix
Aug 18 07:48:58 x4 kernel: ehci_hcd 0000:00:12.2: 0applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
Aug 18 07:48:58 x4 kernel: ehci_hcd 0000:00:12.2: 0applying AMD SB600/SB700 USB freeze workaround
Aug 18 07:48:58 x4 kernel: ehci_hcd 0000:00:12.2: 0debug port 1
Aug 18 07:48:58 x4 kernel: ehci_hcd 0000:00:12.2: 0irq 17, io mem 0xfbcff800
Aug 18 07:48:58 x4 kernel: ehci_hcd 0000:00:12.2: 0USB 2.0 started, EHCI 1.00
Aug 18 07:48:58 x4 kernel: hub 1-0:1.0: 0USB hub found
Aug 18 07:48:58 x4 kernel: hub 1-0:1.0: 06 ports detected
Aug 18 07:48:58 x4 kernel: ehci_hcd 0000:00:13.2: 0EHCI Host Controller
Aug 18 07:48:58 x4 kernel: ehci_hcd 0000:00:13.2: 0new USB bus registered, assigned bus number 2
Aug 18 07:48:58 x4 kernel: ehci_hcd 0000:00:13.2: 0applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
Aug 18 07:48:58 x4 kernel: ehci_hcd 0000:00:13.2: 0applying AMD SB600/SB700 USB freeze workaround
Aug 18 07:48:58 x4 kernel: ehci_hcd 0000:00:13.2: 0debug port 1
Aug 18 07:48:58 x4 kernel: ehci_hcd 0000:00:13.2: 0irq 19, io mem 0xfbcff400
Aug 18 07:48:58 x4 kernel: ehci_hcd 0000:00:13.2: 0USB 2.0 started, EHCI 1.00
Aug 18 07:48:58 x4 kernel: hub 2-0:1.0: 0USB hub found
Aug 18 07:48:58 x4 kernel: hub 2-0:1.0: 06 ports detected
Aug 18 07:48:58 x4 kernel: ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Aug 18 07:48:58 x4 kernel: ohci_hcd 0000:00:12.0: 0OHCI Host Controller
Aug 18 07:48:58 x4 kernel: ohci_hcd 0000:00:12.0: 0new USB bus registered, assigned bus number 3
Aug 18 07:48:58 x4 kernel: ohci_hcd 0000:00:12.0: 0irq 16, io mem 0xfbcfd000
Aug 18 07:48:58 x4 kernel: hub 3-0:1.0: 0USB hub found
Aug 18 07:48:58 x4 kernel: hub 3-0:1.0: 03 ports detected
Aug 18 07:48:58 x4 kernel: ohci_hcd 0000:00:12.1: 0OHCI Host Controller
Aug 18 07:48:58 x4 kernel: ohci_hcd 0000:00:12.1: 0new USB bus registered, assigned bus number 4
Aug 18 07:48:58 x4 kernel: ohci_hcd 0000:00:12.1: 0irq 16, io mem 0xfbcfe000
Aug 18 07:48:58 x4 kernel: ata7.00: ATAPI: HL-DT-STDVD-RAM GH22NP20, 1.03, max UDMA/66
Aug 18 07:48:58 x4 kernel: ata7.00: configured for UDMA/66
Aug 18 07:48:58 x4 kernel: hub 4-0:1.0: 0USB hub found
Aug 18 07:48:58 x4 kernel: hub 4-0:1.0: 03 ports detected
Aug 18 07:48:58 x4 kernel: ohci_hcd 0000:00:13.0: 0OHCI Host Controller
Aug 18 07:48:58 x4 kernel: ohci_hcd 0000:00:13.0: 0new USB bus registered, assigned bus number 5
Aug 18 07:48:58 x4 kernel: ohci_hcd 0000:00:13.0: 0irq 18, io mem 0xfbcfb000
Aug 18 07:48:58 x4 kernel: hub 5-0:1.0: 0USB hub found
Aug 18 07:48:58 x4 kernel: hub 5-0:1.0: 03 ports detected
Aug 18 07:48:58 x4 kernel: ohci_hcd 0000:00:13.1: 0OHCI Host Controller
Aug 18 07:48:58 x4 kernel: ohci_hcd 0000:00:13.1: 0new USB bus registered, assigned bus number 6
Aug 18 07:48:58 x4 kernel: ohci_hcd 0000:00:13.1: 0irq 18, io mem 0xfbcfc000
Aug 18 07:48:58 x4 kernel: hub 6-0:1.0: 0USB hub found
Aug 18 07:48:58 x4 kernel: hub 6-0:1.0: 03 ports detected
Aug 18 07:48:58 x4 kernel: ohci_hcd 0000:00:14.5: 0OHCI Host Controller
Aug 18 07:48:58 x4 kernel: ohci_hcd 0000:00:14.5: 0new USB bus registered, assigned bus number 7
Aug 18 07:48:58 x4 kernel: ohci_hcd 0000:00:14.5: 0irq 18, io mem 0xfbcfa000
Aug 18 07:48:58 x4 kernel: ata6: SATA link down (SStatus 0 SControl 300)
Aug 18 07:48:58 x4 kernel: ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug 18 07:48:58 x4 kernel: ata4: SATA link down (SStatus 0 SControl 300)
Aug 18 07:48:58 x4 kernel: ata2.00: ATA-8: ST1500DL003-9VT16L, CC32, max UDMA/133
Aug 18 07:48:58 x4 kernel: ata2.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
Aug 18 07:48:58 x4 kernel: ata2.00: configured for UDMA/133
Aug 18 07:48:58 x4 kernel: ata5: SATA link down (SStatus 0 SControl 300)
Aug 18 07:48:58 x4 kernel: ata1: SATA link down (SStatus 0 SControl 300)
Aug 18 07:48:58 x4 kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug 18 07:48:58 x4 kernel: scsi 1:0:0:0: bad extra_isize (%u != %u)Direct-Access     ATA      ST1500DL003-9VT1 CC32 PQ: 0 ANSI: 5
Aug 18 07:48:58 x4 kernel: ata3.00: ATA-8: OCZ VERTEX-TURBO, 1.7, max UDMA/133
Aug 18 07:48:58 x4 kernel: ata3.00: 62533296 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
Aug 18 07:48:58 x4 kernel: sd 1:0:0:0: bad extra_isize (%u != %u)Attached scsi generic sg0 type 0
Aug 18 07:48:58 x4 kernel: sd 1:0:0:0: bad extra_isize (%u != %u)[sda] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Aug 18 07:48:58 x4 kernel: sd 1:0:0:0: bad extra_isize (%u != %u)[sda] Write Protect is off
Aug 18 07:48:58 x4 kernel: sd 1:0:0:0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [sda] Mode Sense: 00 3a 00 00
Aug 18 07:48:58 x4 kernel: sd 1:0:0:0: bad extra_isize (%u != %u)[sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 18 07:48:58 x4 kernel: ata3.00: configured for UDMA/133
Aug 18 07:48:58 x4 kernel: scsi 2:0:0:0: bad extra_isize (%u != %u)Direct-Access     ATA      OCZ VERTEX-TURBO 1.7  PQ: 0 ANSI: 5
Aug 18 07:48:58 x4 kernel: sd 2:0:0:0: bad extra_isize (%u != %u)[sdb] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
Aug 18 07:48:58 x4 kernel: sd 2:0:0:0: bad extra_isize (%u != %u)[sdb] Write Protect is off
Aug 18 07:48:58 x4 kernel: sd 2:0:0:0: bad extra_isize (%u != %u)Attached scsi generic sg1 type 0
Aug 18 07:48:58 x4 kernel: sd 2:0:0:0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: [sdb] Mode Sense: 00 3a 00 00
Aug 18 07:48:58 x4 kernel: sd 2:0:0:0: bad extra_isize (%u != %u)[sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 18 07:48:58 x4 kernel: scsi 6:0:0:0: bad extra_isize (%u != %u)CD-ROM            HL-DT-ST DVD-RAM GH22NP20 1.03 PQ: 0 ANSI: 5
Aug 18 07:48:58 x4 kernel: sdb: sdb1 sdb2
Aug 18 07:48:58 x4 kernel: sd 2:0:0:0: bad extra_isize (%u != %u)[sdb] Attached SCSI disk
Aug 18 07:48:58 x4 kernel: sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Aug 18 07:48:58 x4 kernel: cdrom: Uniform CD-ROM driver Revision: 3.20
Aug 18 07:48:58 x4 kernel: sr 6:0:0:0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: Attached scsi CD-ROM sr0
Aug 18 07:48:58 x4 kernel: sr 6:0:0:0: bad extra_isize (%u != %u)Attached scsi generic sg2 type 5
Aug 18 07:48:58 x4 kernel: hub 7-0:1.0: 0USB hub found
Aug 18 07:48:58 x4 kernel: hub 7-0:1.0: 02 ports detected
Aug 18 07:48:58 x4 kernel: usbcore: registered new interface driver usblp
Aug 18 07:48:58 x4 kernel: Initializing USB Mass Storage driver...
Aug 18 07:48:58 x4 kernel: usbcore: registered new interface driver usb-storage
Aug 18 07:48:58 x4 kernel: USB Mass Storage support registered.
Aug 18 07:48:58 x4 kernel: i8042: PNP: No PS/2 controller found. Probing ports directly.
Aug 18 07:48:58 x4 kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Aug 18 07:48:58 x4 kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Aug 18 07:48:58 x4 kernel: mousedev: PS/2 mouse device common for all mice
Aug 18 07:48:58 x4 kernel: rtc_cmos 00:03: 0RTC can wake from S4
Aug 18 07:48:58 x4 kernel: rtc_cmos 00:03: 0rtc core: registered rtc_cmos as rtc0
Aug 18 07:48:58 x4 kernel: rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Aug 18 07:48:58 x4 kernel: i2c /dev entries driver
Aug 18 07:48:58 x4 kernel: EDAC MC: Ver: 3.0.0
Aug 18 07:48:58 x4 kernel: AMD64 EDAC driver v3.4.0
Aug 18 07:48:58 x4 kernel: EDAC amd64: DRAM ECC enabled.
Aug 18 07:48:58 x4 kernel: EDAC amd64: F10h detected (node 0).
Aug 18 07:48:58 x4 kernel: EDAC MC: DCT0 chip selects:
Aug 18 07:48:58 x4 kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
Aug 18 07:48:58 x4 kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
Aug 18 07:48:58 x4 kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
Aug 18 07:48:58 x4 kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
Aug 18 07:48:58 x4 kernel: EDAC MC: DCT1 chip selects:
Aug 18 07:48:58 x4 kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
Aug 18 07:48:58 x4 kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
Aug 18 07:48:58 x4 kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
Aug 18 07:48:58 x4 kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
Aug 18 07:48:58 x4 kernel: EDAC amd64: using x4 syndromes.
Aug 18 07:48:58 x4 kernel: EDAC amd64: MCT channel count: 2
Aug 18 07:48:58 x4 kernel: EDAC amd64: CS0: Unbuffered DDR3 RAM
Aug 18 07:48:58 x4 kernel: EDAC amd64: CS1: Unbuffered DDR3 RAM
Aug 18 07:48:58 x4 kernel: EDAC amd64: CS2: Unbuffered DDR3 RAM
Aug 18 07:48:58 x4 kernel: EDAC amd64: CS3: Unbuffered DDR3 RAM
Aug 18 07:48:58 x4 kernel: EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:18.2
Aug 18 07:48:58 x4 kernel: EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
Aug 18 07:48:58 x4 kernel: cpuidle: using governor ladder
Aug 18 07:48:58 x4 kernel: cpuidle: using governor menu
Aug 18 07:48:58 x4 kernel: usbcore: registered new interface driver usbhid
Aug 18 07:48:58 x4 kernel: usbhid: USB HID core driver
Aug 18 07:48:58 x4 kernel: usbcore: registered new interface driver snd-usb-audio
Aug 18 07:48:58 x4 kernel: Netfilter messages via NETLINK v0.30.
Aug 18 07:48:58 x4 kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Aug 18 07:48:58 x4 kernel: ctnetlink v0.93: registering with nfnetlink.
Aug 18 07:48:58 x4 kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Aug 18 07:48:58 x4 kernel: TCP: cubic registered
Aug 18 07:48:58 x4 kernel: NET: Registered protocol family 17
Aug 18 07:48:58 x4 kernel: registered taskstats version 1
Aug 18 07:48:58 x4 kernel: rtc_cmos 00:03: 0setting system clock to 2012-08-18 05:48:56 UTC (1345268936)
Aug 18 07:48:58 x4 kernel: powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor (4 cpu cores) (version 2.20.00)
Aug 18 07:48:58 x4 kernel: powernow-k8:    0 : pstate 0 (3200 MHz)
Aug 18 07:48:58 x4 kernel: powernow-k8:    1 : pstate 1 (2500 MHz)
Aug 18 07:48:58 x4 kernel: powernow-k8:    2 : pstate 2 (2100 MHz)
Aug 18 07:48:58 x4 kernel: powernow-k8:    3 : pstate 3 (800 MHz)
Aug 18 07:48:58 x4 kernel: ALSA device list:
Aug 18 07:48:58 x4 kernel: No soundcards found.
Aug 18 07:48:58 x4 kernel: sda: sda1 sda2 sda3
Aug 18 07:48:58 x4 kernel: sd 1:0:0:0: bad extra_isize (%u != %u)[sda] Attached SCSI disk
Aug 18 07:48:58 x4 kernel: XFS (sdb2): Mounting Filesystem
Aug 18 07:48:58 x4 kernel: XFS (sdb2): Ending clean mount
Aug 18 07:48:58 x4 kernel: VFS: Mounted root (xfs filesystem) readonly on device 8:18.
Aug 18 07:48:58 x4 kernel: devtmpfs: mounted
Aug 18 07:48:58 x4 kernel: Freeing unused kernel memory: 440k freed
Aug 18 07:48:58 x4 kernel: Write protecting the kernel read-only data: 8192k
Aug 18 07:48:58 x4 kernel: Freeing unused kernel memory: 1360k freed
Aug 18 07:48:58 x4 kernel: Freeing unused kernel memory: 292k freed
Aug 18 07:48:58 x4 kernel: usb 4-1: 0new full-speed USB device number 2 using ohci_hcd
Aug 18 07:48:58 x4 kernel: tsc: Refined TSC clocksource calibration: 3210.826 MHz
Aug 18 07:48:58 x4 kernel: Switching to clocksource tsc
Aug 18 07:48:58 x4 kernel: XFS (sda1): Mounting Filesystem
Aug 18 07:48:58 x4 kernel: input: C-Media USB Headphone Set   as /devices/pci0000:00/0000:00:12.1/usb4/4-1/4-1:1.3/input/input2
Aug 18 07:48:58 x4 kernel: hid-generic 0003:0D8C:000C.0001: 0input,hidraw0: USB HID v1.00 Device [C-Media USB Headphone Set  ] on usb-0000:00:12.1-1/input3
Aug 18 07:48:58 x4 kernel: usb 4-2: 0new full-speed USB device number 3 using ohci_hcd
Aug 18 07:48:58 x4 kernel: XFS (sda1): Ending clean mount
Aug 18 07:48:58 x4 kernel: logitech-djreceiver 0003:046D:C52B.0004: 0hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.1-2/input2
Aug 18 07:48:58 x4 kernel: input: Logitech Unifying Device. Wireless PID:101b as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.2/0003:046D:C52B.0004/input/input3
Aug 18 07:48:58 x4 kernel: logitech-djdevice 0003:046D:C52B.0005: 0input,hidraw2: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:101b] on usb-0000:00:12.1-2:1
Aug 18 07:48:58 x4 kernel: ATL1E 0000:02:00.0: Failed to force enable HPET
Aug 18 07:48:58 x4 kernel: irq 40 for MSI/MSI-X
Aug 18 07:48:58 x4 kernel: ATL1E 0000:02:00.0: 0eth0: NIC Link is Up <100 Mbps Full Duplex>
Aug 18 07:48:58 x4 kernel: usb 4-3: 0new low-speed USB device number 4 using ohci_hcd
Aug 18 07:48:58 x4 kernel: input: HID 046a:0011 as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input4
Aug 18 07:48:58 x4 kernel: hid-generic 0003:046A:0011.0006: 0input,hidraw3: USB HID v1.10 Keyboard [HID 046a:0011] on usb-0000:00:12.1-3/input0
Aug 18 07:48:58 x4 kernel: Adding 1953788k swap on /dev/sda2.  Priority:-1 extents:1 across:1953788k 

-- 
Markus
