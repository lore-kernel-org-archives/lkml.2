Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1BAT2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:28:00 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:59459 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab1BAT14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:27:56 -0500
Date: Tue, 1 Feb 2011 20:27:52 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        Doug Thompson <dougthompson@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EDAC-AMD64] Display correct RAM sizes in ganged mode on F10 CPUs
Message-ID: <20110201192752.GA1589@gentoo.trippels.de>
References: <20110129211531.GA1874@gentoo.trippels.de>
 <20110201185114.GD8418@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201185114.GD8418@aftab>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.02.01 at 19:51 +0100, Borislav Petkov wrote:
> On Sat, Jan 29, 2011 at 04:15:31PM -0500, Markus Trippelsdorf wrote:
> > The EDAC_AMD64 module displays only half the actual memory size, when
> > RAM is running in ganged mode on F10 CPUs. Fix this by moving the the
> > conversion factor check out of the if block, where it is never reached.
> > 
> > With this patch:
> > 
> > Unganged: 
> >  amd64: DRAM ECC enabled.
> >  EDAC amd64: F10h detected (node 0).
> >  EDAC amd64: using x4 syndromes.
> >  EDAC MC: DCT0 chip selects:
> >  kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
> >  kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
> >  kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
> >  kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
> >  kernel: EDAC MC: DCT1 chip selects:
> >  kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
> >  kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
> >  kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
> >  kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
> >  kernel: EDAC amd64: MCT channel count: 2
> 
> Hmm, can you send me your whole dmesg without your patch, dmidecode
> output and the exact model of your DIMMs.


Jan 29 19:05:39 gentoo kernel: Initializing cgroup subsys cpu
Jan 29 19:05:39 gentoo kernel: Linux version 2.6.38-rc2-00284-g52cda7c (markus@gentoo.trippels.de) (gcc version 4.6.0-alpha20110122 20110122 (experimental) (Gentoo 4.6.0_alpha20110122) ) #36 SMP PREEMPT Sat Jan 29 19:02:03 CET 2011
Jan 29 19:05:39 gentoo kernel: Command line: BOOT_IMAGE=/usr/src/linux/arch/x86/boot/bzImage root=PARTUUID=36e41736-f955-4ea2-8782-6983989a3b51 init=/sbin/minit fbcon=rotate:3 drm_kms_helper.poll=0 quiet
Jan 29 19:05:39 gentoo kernel: BIOS-provided physical RAM map:
Jan 29 19:05:39 gentoo kernel: BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Jan 29 19:05:39 gentoo kernel: BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Jan 29 19:05:39 gentoo kernel: BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
Jan 29 19:05:39 gentoo kernel: BIOS-e820: 0000000000100000 - 00000000dfe90000 (usable)
Jan 29 19:05:39 gentoo kernel: BIOS-e820: 00000000dfe90000 - 00000000dfea8000 (ACPI data)
Jan 29 19:05:39 gentoo kernel: BIOS-e820: 00000000dfea8000 - 00000000dfed0000 (ACPI NVS)
Jan 29 19:05:39 gentoo kernel: BIOS-e820: 00000000dfed0000 - 00000000dff00000 (reserved)
Jan 29 19:05:39 gentoo kernel: BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Jan 29 19:05:39 gentoo kernel: BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
Jan 29 19:05:39 gentoo kernel: NX (Execute Disable) protection: active
Jan 29 19:05:39 gentoo kernel: DMI present.
Jan 29 19:05:39 gentoo kernel: DMI: M4A78T-E/System Product Name, BIOS 3406    08/20/2010
Jan 29 19:05:39 gentoo kernel: e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
Jan 29 19:05:39 gentoo kernel: e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
Jan 29 19:05:39 gentoo kernel: last_pfn = 0x220000 max_arch_pfn = 0x400000000
Jan 29 19:05:39 gentoo kernel: MTRR default type: uncachable
Jan 29 19:05:39 gentoo kernel: MTRR fixed ranges enabled:
Jan 29 19:05:39 gentoo kernel: 00000-9FFFF write-back
Jan 29 19:05:39 gentoo kernel: A0000-EFFFF uncachable
Jan 29 19:05:39 gentoo kernel: F0000-FFFFF write-protect
Jan 29 19:05:39 gentoo kernel: MTRR variable ranges enabled:
Jan 29 19:05:39 gentoo kernel: 0 base 000000000000 mask FFFF80000000 write-back
Jan 29 19:05:39 gentoo kernel: 1 base 000080000000 mask FFFFC0000000 write-back
Jan 29 19:05:39 gentoo kernel: 2 base 0000C0000000 mask FFFFE0000000 write-back
Jan 29 19:05:39 gentoo kernel: 3 disabled
Jan 29 19:05:39 gentoo kernel: 4 disabled
Jan 29 19:05:39 gentoo kernel: 5 disabled
Jan 29 19:05:39 gentoo kernel: 6 disabled
Jan 29 19:05:39 gentoo kernel: 7 disabled
Jan 29 19:05:39 gentoo kernel: TOM2: 0000000220000000 aka 8704M
Jan 29 19:05:39 gentoo kernel: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Jan 29 19:05:39 gentoo kernel: e820 update range: 00000000e0000000 - 0000000100000000 (usable) ==> (reserved)
Jan 29 19:05:39 gentoo kernel: last_pfn = 0xdfe90 max_arch_pfn = 0x400000000
Jan 29 19:05:39 gentoo kernel: initial memory mapped : 0 - 20000000
Jan 29 19:05:39 gentoo kernel: Using GB pages for direct mapping
Jan 29 19:05:39 gentoo kernel: init_memory_mapping: 0000000000000000-00000000dfe90000
Jan 29 19:05:39 gentoo kernel: 0000000000 - 00c0000000 page 1G
Jan 29 19:05:39 gentoo kernel: 00c0000000 - 00dfe00000 page 2M
Jan 29 19:05:39 gentoo kernel: 00dfe00000 - 00dfe90000 page 4k
Jan 29 19:05:39 gentoo kernel: kernel direct mapping tables up to dfe90000 @ 1fffd000-20000000
Jan 29 19:05:39 gentoo kernel: init_memory_mapping: 0000000100000000-0000000220000000
Jan 29 19:05:39 gentoo kernel: 0100000000 - 0200000000 page 1G
Jan 29 19:05:39 gentoo kernel: 0200000000 - 0220000000 page 2M
Jan 29 19:05:39 gentoo kernel: kernel direct mapping tables up to 220000000 @ dfe8e000-dfe90000
Jan 29 19:05:39 gentoo kernel: ACPI: RSDP 00000000000fb880 00024 (v02 ACPIAM)
Jan 29 19:05:39 gentoo kernel: ACPI: XSDT 00000000dfe90100 0005C (v01 082010 XSDT1403 20100820 MSFT 00000097)
Jan 29 19:05:39 gentoo kernel: ACPI: FACP 00000000dfe90290 000F4 (v03 082010 FACP1403 20100820 MSFT 00000097)
Jan 29 19:05:39 gentoo kernel: ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20110112/tbfadt-557)
Jan 29 19:05:39 gentoo kernel: ACPI: DSDT 00000000dfe90450 0E6FE (v01  A1152 A1152000 00000000 INTL 20060113)
Jan 29 19:05:39 gentoo kernel: ACPI: FACS 00000000dfea8000 00040
Jan 29 19:05:39 gentoo kernel: ACPI: APIC 00000000dfe90390 0007C (v01 082010 APIC1403 20100820 MSFT 00000097)
Jan 29 19:05:39 gentoo kernel: ACPI: MCFG 00000000dfe90410 0003C (v01 082010 OEMMCFG  20100820 MSFT 00000097)
Jan 29 19:05:39 gentoo kernel: ACPI: OEMB 00000000dfea8040 00072 (v01 082010 OEMB1403 20100820 MSFT 00000097)
Jan 29 19:05:39 gentoo kernel: ACPI: SRAT 00000000dfe9f450 000E8 (v01 AMD    FAM_F_10 00000002 AMD  00000001)
Jan 29 19:05:39 gentoo kernel: ACPI: HPET 00000000dfe9f540 00038 (v01 082010 OEMHPET  20100820 MSFT 00000097)
Jan 29 19:05:39 gentoo kernel: ACPI: SSDT 00000000dfe9f580 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
Jan 29 19:05:39 gentoo kernel: ACPI: Local APIC address 0xfee00000
Jan 29 19:05:39 gentoo kernel: [ffffea0000000000-ffffea00077fffff] PMD -> [ffff8800cc000000-ffff8800d31fffff] on node 0
Jan 29 19:05:39 gentoo kernel: Zone PFN ranges:
Jan 29 19:05:39 gentoo kernel: DMA      0x00000010 -> 0x00001000
Jan 29 19:05:39 gentoo kernel: DMA32    0x00001000 -> 0x00100000
Jan 29 19:05:39 gentoo kernel: Normal   0x00100000 -> 0x00220000
Jan 29 19:05:39 gentoo kernel: Movable zone start PFN for each node
Jan 29 19:05:39 gentoo kernel: early_node_map[3] active PFN ranges
Jan 29 19:05:39 gentoo kernel: 0: 0x00000010 -> 0x0000009f
Jan 29 19:05:39 gentoo kernel: 0: 0x00000100 -> 0x000dfe90
Jan 29 19:05:39 gentoo kernel: 0: 0x00100000 -> 0x00220000
Jan 29 19:05:39 gentoo kernel: On node 0 totalpages: 2096671
Jan 29 19:05:39 gentoo kernel: DMA zone: 56 pages used for memmap
Jan 29 19:05:39 gentoo kernel: DMA zone: 2 pages reserved
Jan 29 19:05:39 gentoo kernel: DMA zone: 3925 pages, LIFO batch:0
Jan 29 19:05:39 gentoo kernel: DMA32 zone: 14280 pages used for memmap
Jan 29 19:05:39 gentoo kernel: DMA32 zone: 898760 pages, LIFO batch:31
Jan 29 19:05:39 gentoo kernel: Normal zone: 16128 pages used for memmap
Jan 29 19:05:39 gentoo kernel: Normal zone: 1163520 pages, LIFO batch:31
Jan 29 19:05:39 gentoo kernel: ACPI: PM-Timer IO Port: 0x808
Jan 29 19:05:39 gentoo kernel: ACPI: Local APIC address 0xfee00000
Jan 29 19:05:39 gentoo kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Jan 29 19:05:39 gentoo kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Jan 29 19:05:39 gentoo kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Jan 29 19:05:39 gentoo kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Jan 29 19:05:39 gentoo kernel: ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
Jan 29 19:05:39 gentoo kernel: ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
Jan 29 19:05:39 gentoo kernel: ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
Jan 29 19:05:39 gentoo kernel: IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
Jan 29 19:05:39 gentoo kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Jan 29 19:05:39 gentoo kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Jan 29 19:05:39 gentoo kernel: ACPI: IRQ0 used by override.
Jan 29 19:05:39 gentoo kernel: ACPI: IRQ2 used by override.
Jan 29 19:05:39 gentoo kernel: ACPI: IRQ9 used by override.
Jan 29 19:05:39 gentoo kernel: Using ACPI (MADT) for SMP configuration information
Jan 29 19:05:39 gentoo kernel: ACPI: HPET id: 0x8300 base: 0xfed00000
Jan 29 19:05:39 gentoo kernel: SMP: Allowing 4 CPUs, 0 hotplug CPUs
Jan 29 19:05:39 gentoo kernel: nr_irqs_gsi: 40
Jan 29 19:05:39 gentoo kernel: Allocating PCI resources starting at dff00000 (gap: dff00000:20000000)
Jan 29 19:05:39 gentoo kernel: setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
Jan 29 19:05:39 gentoo kernel: PERCPU: Embedded 24 pages/cpu @ffff8800dfc00000 s74560 r0 d23744 u524288
Jan 29 19:05:39 gentoo kernel: pcpu-alloc: s74560 r0 d23744 u524288 alloc=1*2097152
Jan 29 19:05:39 gentoo kernel: pcpu-alloc: [0] 0 1 2 3 
Jan 29 19:05:39 gentoo kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2066205
Jan 29 19:05:39 gentoo kernel: Kernel command line: BOOT_IMAGE=/usr/src/linux/arch/x86/boot/bzImage root=PARTUUID=36e41736-f955-4ea2-8782-6983989a3b51 init=/sbin/minit fbcon=rotate:3 drm_kms_helper.poll=0 quiet
Jan 29 19:05:39 gentoo kernel: PID hash table entries: 4096 (order: 3, 32768 bytes)
Jan 29 19:05:39 gentoo kernel: Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Jan 29 19:05:39 gentoo kernel: Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Jan 29 19:05:39 gentoo kernel: Memory: 8182108k/8912896k available (5550k kernel code, 526212k absent, 204576k reserved, 2205k data, 596k init)
Jan 29 19:05:39 gentoo kernel: SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Jan 29 19:05:39 gentoo kernel: Preemptable hierarchical RCU implementation.
Jan 29 19:05:39 gentoo kernel: NR_IRQS:384
Jan 29 19:05:39 gentoo kernel: Extended CMOS year: 2000
Jan 29 19:05:39 gentoo kernel: spurious 8259A interrupt: IRQ7.
Jan 29 19:05:39 gentoo kernel: Console: colour VGA+ 80x25
Jan 29 19:05:39 gentoo kernel: console [tty0] enabled
Jan 29 19:05:39 gentoo kernel: hpet clockevent registered
Jan 29 19:05:39 gentoo kernel: Fast TSC calibration using PIT
Jan 29 19:05:39 gentoo kernel: Detected 3211.424 MHz processor.
Jan 29 19:05:39 gentoo kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 6422.84 BogoMIPS (lpj=3211424)
Jan 29 19:05:39 gentoo kernel: pid_max: default: 32768 minimum: 301
Jan 29 19:05:39 gentoo kernel: Mount-cache hash table entries: 256
Jan 29 19:05:39 gentoo kernel: tseg: 0000000000
Jan 29 19:05:39 gentoo kernel: CPU: Physical Processor ID: 0
Jan 29 19:05:39 gentoo kernel: CPU: Processor Core ID: 0
Jan 29 19:05:39 gentoo kernel: mce: CPU supports 6 MCE banks
Jan 29 19:05:39 gentoo kernel: using C1E aware idle routine
Jan 29 19:05:39 gentoo kernel: Freeing SMP alternatives: 16k freed
Jan 29 19:05:39 gentoo kernel: ACPI: Core revision 20110112
Jan 29 19:05:39 gentoo kernel: ftrace: allocating 18624 entries in 74 pages
Jan 29 19:05:39 gentoo kernel: Setting APIC routing to flat
Jan 29 19:05:39 gentoo kernel: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Jan 29 19:05:39 gentoo kernel: CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02
Jan 29 19:05:39 gentoo kernel: Performance Events: AMD PMU driver.
Jan 29 19:05:39 gentoo kernel: ... version:                0
Jan 29 19:05:39 gentoo kernel: ... bit width:              48
Jan 29 19:05:39 gentoo kernel: ... generic registers:      4
Jan 29 19:05:39 gentoo kernel: ... value mask:             0000ffffffffffff
Jan 29 19:05:39 gentoo kernel: ... max period:             00007fffffffffff
Jan 29 19:05:39 gentoo kernel: ... fixed-purpose events:   0
Jan 29 19:05:39 gentoo kernel: ... event mask:             000000000000000f
Jan 29 19:05:39 gentoo kernel: System has AMD C1E enabled
Jan 29 19:05:39 gentoo kernel: Switch to broadcast mode on CPU0
Jan 29 19:05:39 gentoo kernel: MCE: In-kernel MCE decoding enabled.
Jan 29 19:05:39 gentoo kernel: Booting Node   0, Processors  #1
Jan 29 19:05:39 gentoo kernel: Switch to broadcast mode on CPU1
Jan 29 19:05:39 gentoo kernel: #2
Jan 29 19:05:39 gentoo kernel: Switch to broadcast mode on CPU2
Jan 29 19:05:39 gentoo kernel: #3 Ok.
Jan 29 19:05:39 gentoo kernel: Brought up 4 CPUs
Jan 29 19:05:39 gentoo kernel: Total of 4 processors activated (25687.75 BogoMIPS).
Jan 29 19:05:39 gentoo kernel: Switch to broadcast mode on CPU3
Jan 29 19:05:39 gentoo kernel: devtmpfs: initialized
Jan 29 19:05:39 gentoo kernel: NET: Registered protocol family 16
Jan 29 19:05:39 gentoo kernel: node 0 link 0: io port [1000, ffffff]
Jan 29 19:05:39 gentoo kernel: TOM: 00000000e0000000 aka 3584M
Jan 29 19:05:39 gentoo kernel: Fam 10h mmconf [e0000000, efffffff]
Jan 29 19:05:39 gentoo kernel: node 0 link 0: mmio [a0000, bffff]
Jan 29 19:05:39 gentoo kernel: node 0 link 0: mmio [e0000000, efffffff] ==> none
Jan 29 19:05:39 gentoo kernel: node 0 link 0: mmio [f0000000, fbcfffff]
Jan 29 19:05:39 gentoo kernel: node 0 link 0: mmio [fbd00000, fbefffff]
Jan 29 19:05:39 gentoo kernel: node 0 link 0: mmio [fbf00000, ffefffff]
Jan 29 19:05:39 gentoo kernel: TOM2: 0000000220000000 aka 8704M
Jan 29 19:05:39 gentoo kernel: bus: [00, 07] on node 0 link 0
Jan 29 19:05:39 gentoo kernel: bus: 00 index 0 [io  0x0000-0xffff]
Jan 29 19:05:39 gentoo kernel: bus: 00 index 1 [mem 0x000a0000-0x000bffff]
Jan 29 19:05:39 gentoo kernel: bus: 00 index 2 [mem 0xf0000000-0xffffffff]
Jan 29 19:05:39 gentoo kernel: bus: 00 index 3 [mem 0x220000000-0xfcffffffff]
Jan 29 19:05:39 gentoo kernel: Extended Config Space enabled on 1 nodes
Jan 29 19:05:39 gentoo kernel: ACPI: bus type pci registered
Jan 29 19:05:39 gentoo kernel: PCI: Using configuration type 1 for base access
Jan 29 19:05:39 gentoo kernel: PCI: Using configuration type 1 for extended access
Jan 29 19:05:39 gentoo kernel: mtrr: your CPUs had inconsistent fixed MTRR settings
Jan 29 19:05:39 gentoo kernel: mtrr: probably your BIOS does not setup all CPUs.
Jan 29 19:05:39 gentoo kernel: mtrr: corrected configuration.
Jan 29 19:05:39 gentoo kernel: bio: create slab <bio-0> at 0
Jan 29 19:05:39 gentoo kernel: ACPI: EC: Look up EC in DSDT
Jan 29 19:05:39 gentoo kernel: ACPI: Executed 3 blocks of module-level executable AML code
Jan 29 19:05:39 gentoo kernel: ACPI: Interpreter enabled
Jan 29 19:05:39 gentoo kernel: ACPI: (supports S0 S5)
Jan 29 19:05:39 gentoo kernel: ACPI: Using IOAPIC for interrupt routing
Jan 29 19:05:39 gentoo kernel: PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Jan 29 19:05:39 gentoo kernel: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
Jan 29 19:05:39 gentoo kernel: pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
Jan 29 19:05:39 gentoo kernel: pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
Jan 29 19:05:39 gentoo kernel: pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
Jan 29 19:05:39 gentoo kernel: pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
Jan 29 19:05:39 gentoo kernel: pci_root PNP0A03:00: host bridge window [mem 0xdff00000-0xdfffffff]
Jan 29 19:05:39 gentoo kernel: pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:00.0: [1022:9600] type 0 class 0x000600
Jan 29 19:05:39 gentoo kernel: pci 0000:00:01.0: [1022:9602] type 1 class 0x000604
Jan 29 19:05:39 gentoo kernel: pci 0000:00:06.0: [1022:9606] type 1 class 0x000604
Jan 29 19:05:39 gentoo kernel: pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
Jan 29 19:05:39 gentoo kernel: pci 0000:00:06.0: PME# disabled
Jan 29 19:05:39 gentoo kernel: pci 0000:00:11.0: [1002:4390] type 0 class 0x000101
Jan 29 19:05:39 gentoo kernel: pci 0000:00:11.0: reg 10: [io  0xc000-0xc007]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:11.0: reg 14: [io  0xb000-0xb003]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:11.0: reg 18: [io  0xa000-0xa007]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:11.0: reg 1c: [io  0x9000-0x9003]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:11.0: reg 20: [io  0x8000-0x800f]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:11.0: reg 24: [mem 0xfbcffc00-0xfbcfffff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:11.0: set SATA to AHCI mode
Jan 29 19:05:39 gentoo kernel: pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
Jan 29 19:05:39 gentoo kernel: pci 0000:00:12.0: reg 10: [mem 0xfbcfd000-0xfbcfdfff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:12.1: [1002:4398] type 0 class 0x000c03
Jan 29 19:05:39 gentoo kernel: pci 0000:00:12.1: reg 10: [mem 0xfbcfe000-0xfbcfefff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
Jan 29 19:05:39 gentoo kernel: pci 0000:00:12.2: reg 10: [mem 0xfbcff800-0xfbcff8ff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:12.2: supports D1 D2
Jan 29 19:05:39 gentoo kernel: pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
Jan 29 19:05:39 gentoo kernel: pci 0000:00:12.2: PME# disabled
Jan 29 19:05:39 gentoo kernel: pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
Jan 29 19:05:39 gentoo kernel: pci 0000:00:13.0: reg 10: [mem 0xfbcfb000-0xfbcfbfff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:13.1: [1002:4398] type 0 class 0x000c03
Jan 29 19:05:39 gentoo kernel: pci 0000:00:13.1: reg 10: [mem 0xfbcfc000-0xfbcfcfff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
Jan 29 19:05:39 gentoo kernel: pci 0000:00:13.2: reg 10: [mem 0xfbcff400-0xfbcff4ff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:13.2: supports D1 D2
Jan 29 19:05:39 gentoo kernel: pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
Jan 29 19:05:39 gentoo kernel: pci 0000:00:13.2: PME# disabled
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.1: [1002:439c] type 0 class 0x000101
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.5: reg 10: [mem 0xfbcfa000-0xfbcfafff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
Jan 29 19:05:39 gentoo kernel: pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
Jan 29 19:05:39 gentoo kernel: pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
Jan 29 19:05:39 gentoo kernel: pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
Jan 29 19:05:39 gentoo kernel: pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
Jan 29 19:05:39 gentoo kernel: pci 0000:01:05.0: [1002:9614] type 0 class 0x000300
Jan 29 19:05:39 gentoo kernel: pci 0000:01:05.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
Jan 29 19:05:39 gentoo kernel: pci 0000:01:05.0: reg 14: [io  0xd000-0xd0ff]
Jan 29 19:05:39 gentoo kernel: pci 0000:01:05.0: reg 18: [mem 0xfbee0000-0xfbeeffff]
Jan 29 19:05:39 gentoo kernel: pci 0000:01:05.0: reg 24: [mem 0xfbd00000-0xfbdfffff]
Jan 29 19:05:39 gentoo kernel: pci 0000:01:05.0: supports D1 D2
Jan 29 19:05:39 gentoo kernel: pci 0000:01:05.1: [1002:960f] type 0 class 0x000403
Jan 29 19:05:39 gentoo kernel: pci 0000:01:05.1: reg 10: [mem 0xfbefc000-0xfbefffff]
Jan 29 19:05:39 gentoo kernel: pci 0000:01:05.1: supports D1 D2
Jan 29 19:05:39 gentoo kernel: pci 0000:00:01.0: PCI bridge to [bus 01-01]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
Jan 29 19:05:39 gentoo kernel: pci 0000:02:00.0: [1969:1026] type 0 class 0x000200
Jan 29 19:05:39 gentoo kernel: pci 0000:02:00.0: reg 10: [mem 0xfbfc0000-0xfbffffff 64bit]
Jan 29 19:05:39 gentoo kernel: pci 0000:02:00.0: reg 18: [io  0xec00-0xec7f]
Jan 29 19:05:39 gentoo kernel: pci 0000:02:00.0: PME# supported from D3hot D3cold
Jan 29 19:05:39 gentoo kernel: pci 0000:02:00.0: PME# disabled
Jan 29 19:05:39 gentoo kernel: pci 0000:00:06.0: PCI bridge to [bus 02-02]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:06.0:   bridge window [mem 0xfbf00000-0xfbffffff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive decode)
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.4:   bridge window [mem 0xdff00000-0xdfffffff] (subtractive decode)
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:00: on NUMA node 0
Jan 29 19:05:39 gentoo kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Jan 29 19:05:39 gentoo kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
Jan 29 19:05:39 gentoo kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
Jan 29 19:05:39 gentoo kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
Jan 29 19:05:39 gentoo kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs *4 7 10 11 12 14 15)
Jan 29 19:05:39 gentoo kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 4 *7 10 11 12 14 15)
Jan 29 19:05:39 gentoo kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
Jan 29 19:05:39 gentoo kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 *11 12 14 15)
Jan 29 19:05:39 gentoo kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Jan 29 19:05:39 gentoo kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Jan 29 19:05:39 gentoo kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 12 14 15)
Jan 29 19:05:39 gentoo kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Jan 29 19:05:39 gentoo kernel: SCSI subsystem initialized
Jan 29 19:05:39 gentoo kernel: libata version 3.00 loaded.
Jan 29 19:05:39 gentoo kernel: usbcore: registered new interface driver usbfs
Jan 29 19:05:39 gentoo kernel: usbcore: registered new interface driver hub
Jan 29 19:05:39 gentoo kernel: usbcore: registered new device driver usb
Jan 29 19:05:39 gentoo kernel: Advanced Linux Sound Architecture Driver Version 1.0.23.
Jan 29 19:05:39 gentoo kernel: PCI: Using ACPI for IRQ routing
Jan 29 19:05:39 gentoo kernel: PCI: pci_cache_line_size set to 64 bytes
Jan 29 19:05:39 gentoo kernel: reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
Jan 29 19:05:39 gentoo kernel: reserve RAM buffer: 00000000dfe90000 - 00000000dfffffff 
Jan 29 19:05:39 gentoo kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
Jan 29 19:05:39 gentoo kernel: hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Jan 29 19:05:39 gentoo kernel: Switching to clocksource hpet
Jan 29 19:05:39 gentoo kernel: Switched to NOHz mode on CPU #1
Jan 29 19:05:39 gentoo kernel: Switched to NOHz mode on CPU #2
Jan 29 19:05:39 gentoo kernel: Switched to NOHz mode on CPU #3
Jan 29 19:05:39 gentoo kernel: Switched to NOHz mode on CPU #0
Jan 29 19:05:39 gentoo kernel: pnp: PnP ACPI init
Jan 29 19:05:39 gentoo kernel: ACPI: bus type pnp registered
Jan 29 19:05:39 gentoo kernel: pnp 00:00: [bus 00-ff]
Jan 29 19:05:39 gentoo kernel: pnp 00:00: [io  0x0cf8-0x0cff]
Jan 29 19:05:39 gentoo kernel: pnp 00:00: [io  0x0000-0x0cf7 window]
Jan 29 19:05:39 gentoo kernel: pnp 00:00: [io  0x0d00-0xffff window]
Jan 29 19:05:39 gentoo kernel: pnp 00:00: [mem 0x000a0000-0x000bffff window]
Jan 29 19:05:39 gentoo kernel: pnp 00:00: [mem 0x000d0000-0x000dffff window]
Jan 29 19:05:39 gentoo kernel: pnp 00:00: [mem 0xdff00000-0xdfffffff window]
Jan 29 19:05:39 gentoo kernel: pnp 00:00: [mem 0xf0000000-0xfebfffff window]
Jan 29 19:05:39 gentoo kernel: pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
Jan 29 19:05:39 gentoo kernel: pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
Jan 29 19:05:39 gentoo kernel: pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
Jan 29 19:05:39 gentoo kernel: system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
Jan 29 19:05:39 gentoo kernel: pnp 00:02: [dma 4]
Jan 29 19:05:39 gentoo kernel: pnp 00:02: [io  0x0000-0x000f]
Jan 29 19:05:39 gentoo kernel: pnp 00:02: [io  0x0081-0x0083]
Jan 29 19:05:39 gentoo kernel: pnp 00:02: [io  0x0087]
Jan 29 19:05:39 gentoo kernel: pnp 00:02: [io  0x0089-0x008b]
Jan 29 19:05:39 gentoo kernel: pnp 00:02: [io  0x008f]
Jan 29 19:05:39 gentoo kernel: pnp 00:02: [io  0x00c0-0x00df]
Jan 29 19:05:39 gentoo kernel: pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
Jan 29 19:05:39 gentoo kernel: pnp 00:03: [io  0x0070-0x0071]
Jan 29 19:05:39 gentoo kernel: pnp 00:03: [irq 8]
Jan 29 19:05:39 gentoo kernel: pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
Jan 29 19:05:39 gentoo kernel: pnp 00:04: [io  0x0061]
Jan 29 19:05:39 gentoo kernel: pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
Jan 29 19:05:39 gentoo kernel: pnp 00:05: [io  0x00f0-0x00ff]
Jan 29 19:05:39 gentoo kernel: pnp 00:05: [irq 13]
Jan 29 19:05:39 gentoo kernel: pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
Jan 29 19:05:39 gentoo kernel: pnp 00:06: [mem 0xfed00000-0xfed003ff]
Jan 29 19:05:39 gentoo kernel: pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
Jan 29 19:05:39 gentoo kernel: pnp 00:07: [io  0x0060]
Jan 29 19:05:39 gentoo kernel: pnp 00:07: [io  0x0064]
Jan 29 19:05:39 gentoo kernel: pnp 00:07: [mem 0xfec00000-0xfec00fff]
Jan 29 19:05:39 gentoo kernel: pnp 00:07: [mem 0xfee00000-0xfee00fff]
Jan 29 19:05:39 gentoo kernel: system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
Jan 29 19:05:39 gentoo kernel: system 00:07: [mem 0xfee00000-0xfee00fff] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0010-0x001f]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0022-0x003f]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0062-0x0063]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0065-0x006f]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0072-0x007f]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0080]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0084-0x0086]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0088]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x008c-0x008e]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0090-0x009f]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x00a2-0x00bf]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x00b1]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x00e0-0x00ef]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x04d0-0x04d1]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x040b]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x04d6]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0c00-0x0c01]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0c14]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0c50-0x0c51]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0c52]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0c6c]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0c6f]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0cd0-0x0cd1]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0cd2-0x0cd3]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0cd4-0x0cd5]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0cd6-0x0cd7]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0cd8-0x0cdf]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0b00-0x0b3f]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0800-0x089f]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0b00-0x0b0f]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0b20-0x0b3f]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0900-0x090f]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0910-0x091f]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0xfe00-0xfefe]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0060]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [io  0x0064]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [mem 0xdff00000-0xdfffffff]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [mem 0xffb80000-0xffbfffff]
Jan 29 19:05:39 gentoo kernel: pnp 00:08: [mem 0xfec10000-0xfec1001f]
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x04d0-0x04d1] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x040b] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x04d6] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0c00-0x0c01] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0c14] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0c50-0x0c51] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0c52] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0c6c] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0c6f] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0cd0-0x0cd1] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0cd2-0x0cd3] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0cd4-0x0cd5] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0cd6-0x0cd7] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0cd8-0x0cdf] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0b00-0x0b3f] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0800-0x089f] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0b00-0x0b0f] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0b20-0x0b3f] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0900-0x090f] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0x0910-0x091f] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [io  0xfe00-0xfefe] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [mem 0xdff00000-0xdfffffff] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [mem 0xffb80000-0xffbfffff] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: [mem 0xfec10000-0xfec1001f] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
Jan 29 19:05:39 gentoo kernel: pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
Jan 29 19:05:39 gentoo kernel: pnp 00:09: [io  0x0230-0x023f]
Jan 29 19:05:39 gentoo kernel: pnp 00:09: [io  0x0290-0x029f]
Jan 29 19:05:39 gentoo kernel: pnp 00:09: [io  0x0f40-0x0f4f]
Jan 29 19:05:39 gentoo kernel: pnp 00:09: [io  0x0a30-0x0a3f]
Jan 29 19:05:39 gentoo kernel: system 00:09: [io  0x0230-0x023f] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:09: [io  0x0290-0x029f] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:09: [io  0x0f40-0x0f4f] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:09: [io  0x0a30-0x0a3f] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
Jan 29 19:05:39 gentoo kernel: pnp 00:0a: [mem 0xe0000000-0xefffffff]
Jan 29 19:05:39 gentoo kernel: system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
Jan 29 19:05:39 gentoo kernel: pnp 00:0b: [mem 0x00000000-0x0009ffff]
Jan 29 19:05:39 gentoo kernel: pnp 00:0b: [mem 0x000c0000-0x000cffff]
Jan 29 19:05:39 gentoo kernel: pnp 00:0b: [mem 0x000e0000-0x000fffff]
Jan 29 19:05:39 gentoo kernel: pnp 00:0b: [mem 0x00100000-0xdfefffff]
Jan 29 19:05:39 gentoo kernel: pnp 00:0b: [mem 0xfec00000-0xffffffff]
Jan 29 19:05:39 gentoo kernel: system 00:0b: [mem 0x00000000-0x0009ffff] could not be reserved
Jan 29 19:05:39 gentoo kernel: system 00:0b: [mem 0x000c0000-0x000cffff] has been reserved
Jan 29 19:05:39 gentoo kernel: system 00:0b: [mem 0x000e0000-0x000fffff] could not be reserved
Jan 29 19:05:39 gentoo kernel: system 00:0b: [mem 0x00100000-0xdfefffff] could not be reserved
Jan 29 19:05:39 gentoo kernel: system 00:0b: [mem 0xfec00000-0xffffffff] could not be reserved
Jan 29 19:05:39 gentoo kernel: system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
Jan 29 19:05:39 gentoo kernel: pnp: PnP ACPI: found 12 devices
Jan 29 19:05:39 gentoo kernel: ACPI: ACPI bus type pnp unregistered
Jan 29 19:05:39 gentoo kernel: pci 0000:00:01.0: PCI bridge to [bus 01-01]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:06.0: PCI bridge to [bus 02-02]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:06.0:   bridge window [mem 0xfbf00000-0xfbffffff]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:06.0:   bridge window [mem pref disabled]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.4: PCI bridge to [bus 03-03]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.4:   bridge window [io  disabled]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.4:   bridge window [mem disabled]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:14.4:   bridge window [mem pref disabled]
Jan 29 19:05:39 gentoo kernel: pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 29 19:05:39 gentoo kernel: pci 0000:00:06.0: setting latency timer to 64
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:00: resource 8 [mem 0xdff00000-0xdfffffff]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:01: resource 1 [mem 0xfbd00000-0xfbefffff]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:02: resource 1 [mem 0xfbf00000-0xfbffffff]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:03: resource 8 [mem 0xdff00000-0xdfffffff]
Jan 29 19:05:39 gentoo kernel: pci_bus 0000:03: resource 9 [mem 0xf0000000-0xfebfffff]
Jan 29 19:05:39 gentoo kernel: NET: Registered protocol family 2
Jan 29 19:05:39 gentoo kernel: IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
Jan 29 19:05:39 gentoo kernel: TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
Jan 29 19:05:39 gentoo kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Jan 29 19:05:39 gentoo kernel: TCP: Hash tables configured (established 262144 bind 65536)
Jan 29 19:05:39 gentoo kernel: TCP reno registered
Jan 29 19:05:39 gentoo kernel: UDP hash table entries: 4096 (order: 5, 131072 bytes)
Jan 29 19:05:39 gentoo kernel: UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
Jan 29 19:05:39 gentoo kernel: NET: Registered protocol family 1
Jan 29 19:05:39 gentoo kernel: pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
Jan 29 19:05:39 gentoo kernel: pci 0000:01:05.0: Boot video device
Jan 29 19:05:39 gentoo kernel: PCI: CLS 64 bytes, default 64
Jan 29 19:05:39 gentoo kernel: PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Jan 29 19:05:39 gentoo kernel: Placing 64MB software IO TLB between ffff8800dae8b000 - ffff8800dee8b000
Jan 29 19:05:39 gentoo kernel: software IO TLB at phys 0xdae8b000 - 0xdee8b000
Jan 29 19:05:39 gentoo kernel: kvm: Nested Virtualization enabled
Jan 29 19:05:39 gentoo kernel: kvm: Nested Paging enabled
Jan 29 19:05:39 gentoo kernel: SGI XFS with security attributes, large block/inode numbers, no debug enabled
Jan 29 19:05:39 gentoo kernel: msgmni has been set to 15980
Jan 29 19:05:39 gentoo kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Jan 29 19:05:39 gentoo kernel: io scheduler noop registered
Jan 29 19:05:39 gentoo kernel: io scheduler cfq registered (default)
Jan 29 19:05:39 gentoo kernel: input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
Jan 29 19:05:39 gentoo kernel: ACPI: Power Button [PWRB]
Jan 29 19:05:39 gentoo kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Jan 29 19:05:39 gentoo kernel: ACPI: Power Button [PWRF]
Jan 29 19:05:39 gentoo kernel: ACPI: acpi_idle registered with cpuidle
Jan 29 19:05:39 gentoo kernel: ACPI: processor limited to max C-state 1
Jan 29 19:05:39 gentoo kernel: [drm] Initialized drm 1.1.0 20060810
Jan 29 19:05:39 gentoo kernel: [drm] radeon defaulting to kernel modesetting.
Jan 29 19:05:39 gentoo kernel: [drm] radeon kernel modesetting enabled.
Jan 29 19:05:39 gentoo kernel: radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 29 19:05:39 gentoo kernel: radeon 0000:01:05.0: setting latency timer to 64
Jan 29 19:05:39 gentoo kernel: [drm] initializing kernel modesetting (RS780 0x1002:0x9614).
Jan 29 19:05:39 gentoo kernel: [drm] register mmio base: 0xFBEE0000
Jan 29 19:05:39 gentoo kernel: [drm] register mmio size: 65536
Jan 29 19:05:39 gentoo kernel: ATOM BIOS: 113
Jan 29 19:05:39 gentoo kernel: radeon 0000:01:05.0: VRAM: 128M 0x00000000C0000000 - 0x00000000C7FFFFFF (128M used)
Jan 29 19:05:39 gentoo kernel: radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
Jan 29 19:05:39 gentoo kernel: [drm] Detected VRAM RAM=128M, BAR=128M
Jan 29 19:05:39 gentoo kernel: [drm] RAM width 32bits DDR
Jan 29 19:05:39 gentoo kernel: [TTM] Zone  kernel: Available graphics memory: 4091062 kiB.
Jan 29 19:05:39 gentoo kernel: [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
Jan 29 19:05:39 gentoo kernel: [TTM] Initializing pool allocator.
Jan 29 19:05:39 gentoo kernel: [drm] radeon: 128M of VRAM memory ready
Jan 29 19:05:39 gentoo kernel: [drm] radeon: 512M of GTT memory ready.
Jan 29 19:05:39 gentoo kernel: [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
Jan 29 19:05:39 gentoo kernel: [drm] Driver supports precise vblank timestamp query.
Jan 29 19:05:39 gentoo kernel: [drm] radeon: irq initialized.
Jan 29 19:05:39 gentoo kernel: [drm] GART: num cpu pages 131072, num gpu pages 131072
Jan 29 19:05:39 gentoo kernel: [drm] Loading RS780 Microcode
Jan 29 19:05:39 gentoo kernel: radeon 0000:01:05.0: WB enabled
Jan 29 19:05:39 gentoo kernel: [drm] ring test succeeded in 1 usecs
Jan 29 19:05:39 gentoo kernel: [drm] radeon: ib pool ready.
Jan 29 19:05:39 gentoo kernel: [drm] ib test succeeded in 0 usecs
Jan 29 19:05:39 gentoo kernel: [drm] Enabling audio support
Jan 29 19:05:39 gentoo kernel: [drm] Radeon Display Connectors
Jan 29 19:05:39 gentoo kernel: [drm] Connector 0:
Jan 29 19:05:39 gentoo kernel: [drm]   VGA
Jan 29 19:05:39 gentoo kernel: [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
Jan 29 19:05:39 gentoo kernel: [drm]   Encoders:
Jan 29 19:05:39 gentoo kernel: [drm]     CRT1: INTERNAL_KLDSCP_DAC1
Jan 29 19:05:39 gentoo kernel: [drm] Connector 1:
Jan 29 19:05:39 gentoo kernel: [drm]   DVI-D
Jan 29 19:05:39 gentoo kernel: [drm]   HPD3
Jan 29 19:05:39 gentoo kernel: [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
Jan 29 19:05:39 gentoo kernel: [drm]   Encoders:
Jan 29 19:05:39 gentoo kernel: [drm]     DFP3: INTERNAL_KLDSCP_LVTMA
Jan 29 19:05:39 gentoo kernel: [drm] radeon: power management initialized
Jan 29 19:05:39 gentoo kernel: [drm] fb mappable at 0xF0141000
Jan 29 19:05:39 gentoo kernel: [drm] vram apper at 0xF0000000
Jan 29 19:05:39 gentoo kernel: [drm] size 7258112
Jan 29 19:05:39 gentoo kernel: [drm] fb depth is 24
Jan 29 19:05:39 gentoo kernel: [drm]    pitch is 6912
Jan 29 19:05:39 gentoo kernel: Console: switching to colour frame buffer device 131x105
Jan 29 19:05:39 gentoo kernel: fb0: radeondrmfb frame buffer device
Jan 29 19:05:39 gentoo kernel: drm: registered panic notifier
Jan 29 19:05:39 gentoo kernel: [drm] Initialized radeon 2.8.0 20080528 for 0000:01:05.0 on minor 0
Jan 29 19:05:39 gentoo kernel: loop: module loaded
Jan 29 19:05:39 gentoo kernel: ahci 0000:00:11.0: version 3.0
Jan 29 19:05:39 gentoo kernel: ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Jan 29 19:05:39 gentoo kernel: ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
Jan 29 19:05:39 gentoo kernel: ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
Jan 29 19:05:39 gentoo kernel: scsi0 : ahci
Jan 29 19:05:39 gentoo kernel: scsi1 : ahci
Jan 29 19:05:39 gentoo kernel: scsi2 : ahci
Jan 29 19:05:39 gentoo kernel: scsi3 : ahci
Jan 29 19:05:39 gentoo kernel: ata1: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY changed
Jan 29 19:05:39 gentoo kernel: ata2: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd80 irq 22
Jan 29 19:05:39 gentoo kernel: ata3: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe00 irq 22
Jan 29 19:05:39 gentoo kernel: ata4: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe80 irq 22
Jan 29 19:05:39 gentoo kernel: pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 29 19:05:39 gentoo kernel: pata_atiixp 0000:00:14.1: setting latency timer to 64
Jan 29 19:05:39 gentoo kernel: scsi4 : pata_atiixp
Jan 29 19:05:39 gentoo kernel: scsi5 : pata_atiixp
Jan 29 19:05:39 gentoo kernel: ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
Jan 29 19:05:39 gentoo kernel: ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
Jan 29 19:05:39 gentoo kernel: ATL1E 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 29 19:05:39 gentoo kernel: ATL1E 0000:02:00.0: setting latency timer to 64
Jan 29 19:05:39 gentoo kernel: PPP generic driver version 2.4.2
Jan 29 19:05:39 gentoo kernel: tun: Universal TUN/TAP device driver, 1.6
Jan 29 19:05:39 gentoo kernel: tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Jan 29 19:05:39 gentoo kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:12.2: EHCI Host Controller
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:12.2: debug port 1
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:12.2: irq 17, io mem 0xfbcff800
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
Jan 29 19:05:39 gentoo kernel: hub 1-0:1.0: USB hub found
Jan 29 19:05:39 gentoo kernel: hub 1-0:1.0: 6 ports detected
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:13.2: EHCI Host Controller
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:13.2: debug port 1
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:13.2: irq 19, io mem 0xfbcff400
Jan 29 19:05:39 gentoo kernel: ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
Jan 29 19:05:39 gentoo kernel: hub 2-0:1.0: USB hub found
Jan 29 19:05:39 gentoo kernel: hub 2-0:1.0: 6 ports detected
Jan 29 19:05:39 gentoo kernel: ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:12.0: OHCI Host Controller
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:12.0: irq 16, io mem 0xfbcfd000
Jan 29 19:05:39 gentoo kernel: hub 3-0:1.0: USB hub found
Jan 29 19:05:39 gentoo kernel: hub 3-0:1.0: 3 ports detected
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:12.1: OHCI Host Controller
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:12.1: irq 16, io mem 0xfbcfe000
Jan 29 19:05:39 gentoo kernel: hub 4-0:1.0: USB hub found
Jan 29 19:05:39 gentoo kernel: hub 4-0:1.0: 3 ports detected
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:13.0: OHCI Host Controller
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:13.0: irq 18, io mem 0xfbcfb000
Jan 29 19:05:39 gentoo kernel: ata5.00: ATAPI: HL-DT-STDVD-RAM GH22NP20, 1.03, max UDMA/66
Jan 29 19:05:39 gentoo kernel: ata5.00: configured for UDMA/66
Jan 29 19:05:39 gentoo kernel: hub 5-0:1.0: USB hub found
Jan 29 19:05:39 gentoo kernel: hub 5-0:1.0: 3 ports detected
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:13.1: OHCI Host Controller
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:13.1: irq 18, io mem 0xfbcfc000
Jan 29 19:05:39 gentoo kernel: hub 6-0:1.0: USB hub found
Jan 29 19:05:39 gentoo kernel: hub 6-0:1.0: 3 ports detected
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:14.5: OHCI Host Controller
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
Jan 29 19:05:39 gentoo kernel: ohci_hcd 0000:00:14.5: irq 18, io mem 0xfbcfa000
Jan 29 19:05:39 gentoo kernel: hub 7-0:1.0: USB hub found
Jan 29 19:05:39 gentoo kernel: hub 7-0:1.0: 2 ports detected
Jan 29 19:05:39 gentoo kernel: Initializing USB Mass Storage driver...
Jan 29 19:05:39 gentoo kernel: usbcore: registered new interface driver usb-storage
Jan 29 19:05:39 gentoo kernel: USB Mass Storage support registered.
Jan 29 19:05:39 gentoo kernel: usbcore: registered new interface driver usbserial
Jan 29 19:05:39 gentoo kernel: USB Serial support registered for generic
Jan 29 19:05:39 gentoo kernel: ata4: SATA link down (SStatus 0 SControl 300)
Jan 29 19:05:39 gentoo kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jan 29 19:05:39 gentoo kernel: ata2: SATA link down (SStatus 0 SControl 300)
Jan 29 19:05:39 gentoo kernel: ata3.00: ATA-8: OCZ-VERTEX, 1.6, max UDMA/133
Jan 29 19:05:39 gentoo kernel: ata3.00: 62533296 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
Jan 29 19:05:39 gentoo kernel: ata3.00: configured for UDMA/133
Jan 29 19:05:39 gentoo kernel: usb 4-1: new full speed USB device using ohci_hcd and address 2
Jan 29 19:05:39 gentoo kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jan 29 19:05:39 gentoo kernel: ata1.00: ATA-7: SAMSUNG HD103UJ, 1AA01118, max UDMA7
Jan 29 19:05:39 gentoo kernel: ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Jan 29 19:05:39 gentoo kernel: ata1.00: configured for UDMA/133
Jan 29 19:05:39 gentoo kernel: scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
Jan 29 19:05:39 gentoo kernel: sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Jan 29 19:05:39 gentoo kernel: sd 0:0:0:0: [sda] Write Protect is off
Jan 29 19:05:39 gentoo kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan 29 19:05:39 gentoo kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 29 19:05:39 gentoo kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Jan 29 19:05:39 gentoo kernel: scsi 2:0:0:0: Direct-Access     ATA      OCZ-VERTEX       1.6  PQ: 0 ANSI: 5
Jan 29 19:05:39 gentoo kernel: sd 2:0:0:0: [sdb] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
Jan 29 19:05:39 gentoo kernel: sd 2:0:0:0: Attached scsi generic sg1 type 0
Jan 29 19:05:39 gentoo kernel: sd 2:0:0:0: [sdb] Write Protect is off
Jan 29 19:05:39 gentoo kernel: sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Jan 29 19:05:39 gentoo kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 29 19:05:39 gentoo kernel: scsi 4:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GH22NP20 1.03 PQ: 0 ANSI: 5
Jan 29 19:05:39 gentoo kernel: sdb: sdb1 sdb2
Jan 29 19:05:39 gentoo kernel: sd 2:0:0:0: [sdb] Attached SCSI disk
Jan 29 19:05:39 gentoo kernel: sda: sda1 sda2 sda3
Jan 29 19:05:39 gentoo kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Jan 29 19:05:39 gentoo kernel: sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Jan 29 19:05:39 gentoo kernel: cdrom: Uniform CD-ROM driver Revision: 3.20
Jan 29 19:05:39 gentoo kernel: sr 4:0:0:0: Attached scsi CD-ROM sr0
Jan 29 19:05:39 gentoo kernel: sr 4:0:0:0: Attached scsi generic sg2 type 5
Jan 29 19:05:39 gentoo kernel: Refined TSC clocksource calibration: 3210.827 MHz.
Jan 29 19:05:39 gentoo kernel: Switching to clocksource tsc
Jan 29 19:05:39 gentoo kernel: usb 4-2: new full speed USB device using ohci_hcd and address 3
Jan 29 19:05:39 gentoo kernel: usb 4-3: new low speed USB device using ohci_hcd and address 4
Jan 29 19:05:39 gentoo kernel: usbcore: registered new interface driver usbserial_generic
Jan 29 19:05:39 gentoo kernel: usbserial: USB Serial Driver core
Jan 29 19:05:39 gentoo kernel: USB Serial support registered for GSM modem (1-port)
Jan 29 19:05:39 gentoo kernel: usbcore: registered new interface driver option
Jan 29 19:05:39 gentoo kernel: option: v0.7.2:USB Driver for GSM modems
Jan 29 19:05:39 gentoo kernel: i8042: PNP: No PS/2 controller found. Probing ports directly.
Jan 29 19:05:39 gentoo kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Jan 29 19:05:39 gentoo kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Jan 29 19:05:39 gentoo kernel: mousedev: PS/2 mouse device common for all mice
Jan 29 19:05:39 gentoo kernel: rtc_cmos 00:03: RTC can wake from S4
Jan 29 19:05:39 gentoo kernel: rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Jan 29 19:05:39 gentoo kernel: rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Jan 29 19:05:39 gentoo kernel: i2c /dev entries driver
Jan 29 19:05:39 gentoo kernel: EDAC MC: Ver: 2.1.0 Jan 29 2011
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_sysfs_setup_mc_kset: edac_sysfs_setup_mc_kset()
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_sysfs_setup_mc_kset: edac_sysfs_setup_mc_kset() Registered '.../edac/mc' kobject
Jan 29 19:05:39 gentoo kernel: EDAC amd64_edac: v3.3.0
Jan 29 19:05:39 gentoo kernel: EDAC amd64: DRAM ECC enabled.
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 0, MCG_CTL: 0x3f, NB MSR is enabled
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 1, MCG_CTL: 0x3f, NB MSR is enabled
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 2, MCG_CTL: 0x3f, NB MSR is enabled
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 3, MCG_CTL: 0x3f, NB MSR is enabled
Jan 29 19:05:39 gentoo kernel: EDAC amd64: F10h detected (node 0).
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: reserve_mc_sibling_devs: F1: 0000:00:18.1
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: reserve_mc_sibling_devs: F2: 0000:00:18.2
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: reserve_mc_sibling_devs: F3: 0000:00:18.3
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: read_mc_regs:   TOP_MEM:  0x00000000e0000000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: read_mc_regs:   TOP_MEM2: 0x0000000220000000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: f10_read_dram_ctl_register: F2x110 (DCTL Sel. Low): 0x00000510, High range addresses at: 0x0
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: f10_read_dram_ctl_register:   DCT mode: ganged, All DCTs on: yes
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: f10_read_dram_ctl_register:   DCT data interleave for ECC: disabled, DRAM cleared since last warm reset: yes
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: f10_read_dram_ctl_register:   DCT channel interleave: disabled, DCT interleave bits selector: 0x0
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: read_mc_regs:   DRAM-BASE[0]: 0x0000000000000000 DRAM-LIMIT:  0x000000021fffffff
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: read_mc_regs:         IntlvEn=Disabled W R IntlvSel=0 DstNode=0
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_read_dct_base_mask:   DCSB0[0]=0x00000001 reg: F2x40
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_read_dct_base_mask:   DCSB0[1]=0x00000209 reg: F2x44
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_read_dct_base_mask:   DCSB0[2]=0x00000401 reg: F2x48
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_read_dct_base_mask:   DCSB0[3]=0x00000609 reg: F2x4c
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_read_dct_base_mask:   DCSB0[4]=0x00000000 reg: F2x50
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_read_dct_base_mask:   DCSB0[5]=0x00000000 reg: F2x54
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_read_dct_base_mask:   DCSB0[6]=0x00000000 reg: F2x58
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_read_dct_base_mask:   DCSB0[7]=0x00000000 reg: F2x5c
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_read_dct_base_mask:     DCSM0[0]=0x01f839e0 reg: F2x60
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_read_dct_base_mask:     DCSM0[1]=0x01f839e0 reg: F2x64
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_read_dct_base_mask:     DCSM0[2]=0x00000000 reg: F2x68
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_read_dct_base_mask:     DCSM0[3]=0x00000000 reg: F2x6c
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_dump_misc_regs: F3xE8 (NB Cap): 0x02077f59
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_dump_misc_regs:   NB two channel DRAM capable: yes
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_dump_misc_regs:   ECC capable: yes, ChipKill ECC capable: yes
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_dump_dramcfg_low: F2x090 (DRAM Cfg Low): 0x00090800
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: unbuffered; all DIMMs support ECC: yes
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: disabled
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_dump_dramcfg_low:   DCT 128bit mode width: 128b
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_dump_misc_regs: F3xB0 (Online Spare): 0x00000000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_dump_misc_regs: F1xF0 (DRAM Hole Address): 0xe0002003, base: 0xe0000000, offset: 0x20000000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_dump_misc_regs:   DramHoleValid: yes
Jan 29 19:05:39 gentoo kernel: EDAC amd64: using x4 syndromes.
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x080 (DRAM Bank Address Mapping): 0x00000055
Jan 29 19:05:39 gentoo kernel: EDAC MC: DCT0 chip selects:
Jan 29 19:05:39 gentoo kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
Jan 29 19:05:39 gentoo kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
Jan 29 19:05:39 gentoo kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
Jan 29 19:05:39 gentoo kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_mc_register_sysfs_main_kobj: edac_mc_register_sysfs_main_kobj()
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_mc_register_sysfs_main_kobj: edac_mc_register_sysfs_main_kobj() Registered '.../edac/mc0' kobject
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows: node 0, NBCFG=0x4af0005c[ChipKillEccCap: 1|DramEccEn: 1]
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows: ----CSROW 0 VALID for MC node 0
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_csrow_nr_pages:   (csrow=0) DBAM map index= 5
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_csrow_nr_pages:     nr_pages= 524288  channel-count = 2
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: input_addr_to_dram_addr:     InputAddr 0x0 translates to DramAddr of same value
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_get_dram_hole_info:   DHAR info for node 0 base 0xe0000000 offset 0x20000000 size 0x20000000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: dram_addr_to_sys_addr:     Node 0, DramAddr 0x0 to SysAddr 0x0
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: input_addr_to_dram_addr:     InputAddr 0xffffffe1fff9ffff translates to DramAddr of same value
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_get_dram_hole_info:   DHAR info for node 0 base 0xe0000000 offset 0x20000000 size 0x20000000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: dram_addr_to_sys_addr:     Node 0, DramAddr 0xffffffe1fff9ffff to SysAddr 0xffffffe1fff9ffff
Jan 29 19:05:39 gentoo kernel: EDAC amd64: CS0: Unbuffered DDR3 RAM
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:   for MC node 0 csrow 0:
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:     input_addr_min: 0x0 input_addr_max: 0xffffffe1fff9ffff
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:     sys_addr: 0xffffffe1fff9ffff  page_mask: 0x1e00060000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:     nr_pages: 524288  first_page: 0x0 last_page: 0xfe1fff9f
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows: ----CSROW 1 VALID for MC node 0
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_csrow_nr_pages:   (csrow=1) DBAM map index= 5
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_csrow_nr_pages:     nr_pages= 524288  channel-count = 2
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: input_addr_to_dram_addr:     InputAddr 0x20000 translates to DramAddr of same value
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_get_dram_hole_info:   DHAR info for node 0 base 0xe0000000 offset 0x20000000 size 0x20000000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: dram_addr_to_sys_addr:     Node 0, DramAddr 0x20000 to SysAddr 0x20000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: input_addr_to_dram_addr:     InputAddr 0xffffffe1fffbffff translates to DramAddr of same value
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_get_dram_hole_info:   DHAR info for node 0 base 0xe0000000 offset 0x20000000 size 0x20000000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: dram_addr_to_sys_addr:     Node 0, DramAddr 0xffffffe1fffbffff to SysAddr 0xffffffe1fffbffff
Jan 29 19:05:39 gentoo kernel: EDAC amd64: CS1: Unbuffered DDR3 RAM
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:   for MC node 0 csrow 1:
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:     input_addr_min: 0x20000 input_addr_max: 0xffffffe1fffbffff
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:     sys_addr: 0xffffffe1fffbffff  page_mask: 0x1e00060000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:     nr_pages: 524288  first_page: 0x20 last_page: 0xfe1fffbf
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows: ----CSROW 2 VALID for MC node 0
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_csrow_nr_pages:   (csrow=2) DBAM map index= 5
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_csrow_nr_pages:     nr_pages= 524288  channel-count = 2
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: input_addr_to_dram_addr:     InputAddr 0x40000 translates to DramAddr of same value
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_get_dram_hole_info:   DHAR info for node 0 base 0xe0000000 offset 0x20000000 size 0x20000000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: dram_addr_to_sys_addr:     Node 0, DramAddr 0x40000 to SysAddr 0x40000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: input_addr_to_dram_addr:     InputAddr 0xffffffe1fffdffff translates to DramAddr of same value
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_get_dram_hole_info:   DHAR info for node 0 base 0xe0000000 offset 0x20000000 size 0x20000000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: dram_addr_to_sys_addr:     Node 0, DramAddr 0xffffffe1fffdffff to SysAddr 0xffffffe1fffdffff
Jan 29 19:05:39 gentoo kernel: EDAC amd64: CS2: Unbuffered DDR3 RAM
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:   for MC node 0 csrow 2:
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:     input_addr_min: 0x40000 input_addr_max: 0xffffffe1fffdffff
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:     sys_addr: 0xffffffe1fffdffff  page_mask: 0x1e00060000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:     nr_pages: 524288  first_page: 0x40 last_page: 0xfe1fffdf
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows: ----CSROW 3 VALID for MC node 0
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_csrow_nr_pages:   (csrow=3) DBAM map index= 5
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_csrow_nr_pages:     nr_pages= 524288  channel-count = 2
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: input_addr_to_dram_addr:     InputAddr 0x60000 translates to DramAddr of same value
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_get_dram_hole_info:   DHAR info for node 0 base 0xe0000000 offset 0x20000000 size 0x20000000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: dram_addr_to_sys_addr:     Node 0, DramAddr 0x60000 to SysAddr 0x60000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: input_addr_to_dram_addr:     InputAddr 0xffffffe1ffffffff translates to DramAddr of same value
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: amd64_get_dram_hole_info:   DHAR info for node 0 base 0xe0000000 offset 0x20000000 size 0x20000000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: dram_addr_to_sys_addr:     Node 0, DramAddr 0xffffffe1ffffffff to SysAddr 0xffffffe1ffffffff
Jan 29 19:05:39 gentoo kernel: EDAC amd64: CS3: Unbuffered DDR3 RAM
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:   for MC node 0 csrow 3:
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:     input_addr_min: 0x60000 input_addr_max: 0xffffffe1ffffffff
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:     sys_addr: 0xffffffe1ffffffff  page_mask: 0x1e00060000
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows:     nr_pages: 524288  first_page: 0x60 last_page: 0xfe1fffff
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows: ----CSROW 4 EMPTY for node 0
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows: ----CSROW 5 EMPTY for node 0
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows: ----CSROW 6 EMPTY for node 0
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: init_csrows: ----CSROW 7 EMPTY for node 0
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_mc_add_mc: edac_mc_add_mc()
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_create_sysfs_mci_device: edac_create_sysfs_mci_device() idx=0
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes()
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() sysfs_attrib = ffffffff818b3c00
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() file dhar
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() sysfs_attrib = ffffffff818b3c28
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() file dbam
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() sysfs_attrib = ffffffff818b3c50
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() file topmem
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() sysfs_attrib = ffffffff818b3c78
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() file topmem2
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() sysfs_attrib = ffffffff818b3ca0
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() file dram_hole
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_create_mci_instance_attributes: edac_create_mci_instance_attributes() sysfs_attrib = ffffffff818b3cc8
Jan 29 19:05:39 gentoo kernel: EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:18.2
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_pci_alloc_ctl_info: edac_pci_alloc_ctl_info()
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_pci_add_device: edac_pci_add_device()
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: add_edac_pci_to_global_list: add_edac_pci_to_global_list()
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: find_edac_pci_by_dev: find_edac_pci_by_dev()
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_pci_create_sysfs: edac_pci_create_sysfs() idx=0
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_pci_main_kobj_setup: edac_pci_main_kobj_setup()
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_pci_main_kobj_setup: Registered '.../edac/pci' kobject
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_pci_create_instance_kobj: edac_pci_create_instance_kobj()
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_pci_create_instance_kobj: edac_pci_create_instance_kobj() Register instance 'pci0' kobject
Jan 29 19:05:39 gentoo kernel: EDAC DEBUG: edac_pci_workq_setup: edac_pci_workq_setup()
Jan 29 19:05:39 gentoo kernel: EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
Jan 29 19:05:39 gentoo kernel: cpuidle: using governor ladder
Jan 29 19:05:39 gentoo kernel: cpuidle: using governor menu
Jan 29 19:05:39 gentoo kernel: input: C-Media USB Headphone Set   as /devices/pci0000:00/0000:00:12.1/usb4/4-1/4-1:1.3/input/input2
Jan 29 19:05:39 gentoo kernel: generic-usb 0003:0D8C:000C.0001: input,hidraw0: USB HID v1.00 Device [C-Media USB Headphone Set  ] on usb-0000:00:12.1-1/input3
Jan 29 19:05:39 gentoo kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.0/input/input3
Jan 29 19:05:39 gentoo kernel: generic-usb 0003:046D:C52B.0002: input,hidraw1: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb-0000:00:12.1-2/input0
Jan 29 19:05:39 gentoo kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.1/input/input4
Jan 29 19:05:39 gentoo kernel: generic-usb 0003:046D:C52B.0003: input,hiddev0,hidraw2: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-2/input1
Jan 29 19:05:39 gentoo kernel: generic-usb 0003:046D:C52B.0004: hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.1-2/input2
Jan 29 19:05:39 gentoo kernel: input: HID 046a:0011 as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input5
Jan 29 19:05:39 gentoo kernel: generic-usb 0003:046A:0011.0005: input,hidraw4: USB HID v1.10 Keyboard [HID 046a:0011] on usb-0000:00:12.1-3/input0
Jan 29 19:05:39 gentoo kernel: usbcore: registered new interface driver usbhid
Jan 29 19:05:39 gentoo kernel: usbhid: USB HID core driver
Jan 29 19:05:39 gentoo kernel: usbcore: registered new interface driver snd-usb-audio
Jan 29 19:05:39 gentoo kernel: ALSA device list:
Jan 29 19:05:39 gentoo kernel: #0: C-Media USB Headphone Set   at usb-0000:00:12.1-1, full speed
Jan 29 19:05:39 gentoo kernel: Netfilter messages via NETLINK v0.30.
Jan 29 19:05:39 gentoo kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Jan 29 19:05:39 gentoo kernel: ctnetlink v0.93: registering with nfnetlink.
Jan 29 19:05:39 gentoo kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Jan 29 19:05:39 gentoo kernel: TCP cubic registered
Jan 29 19:05:39 gentoo kernel: NET: Registered protocol family 17
Jan 29 19:05:39 gentoo kernel: powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor (4 cpu cores) (version 2.20.00)
Jan 29 19:05:39 gentoo kernel: powernow-k8:    0 : pstate 0 (3200 MHz)
Jan 29 19:05:39 gentoo kernel: powernow-k8:    1 : pstate 1 (2500 MHz)
Jan 29 19:05:39 gentoo kernel: powernow-k8:    2 : pstate 2 (2100 MHz)
Jan 29 19:05:39 gentoo kernel: powernow-k8:    3 : pstate 3 (800 MHz)
Jan 29 19:05:39 gentoo kernel: rtc_cmos 00:03: setting system clock to 2011-01-29 18:05:38 UTC (1296324338)
Jan 29 19:05:39 gentoo kernel: EXT4-fs (sdb2): mounted filesystem without journal. Opts: (null)
Jan 29 19:05:39 gentoo kernel: VFS: Mounted root (ext4 filesystem) readonly on device 8:18.
Jan 29 19:05:39 gentoo kernel: devtmpfs: mounted
Jan 29 19:05:39 gentoo kernel: Freeing unused kernel memory: 596k freed
Jan 29 19:05:39 gentoo kernel: EXT4-fs (sdb2): re-mounted. Opts: (null)
Jan 29 19:05:39 gentoo kernel: EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
Jan 29 19:05:39 gentoo kernel: XFS mounting filesystem sda2
Jan 29 19:05:39 gentoo kernel: Ending clean XFS mount for filesystem: sda2
Jan 29 19:05:39 gentoo kernel: ATL1E 0000:02:00.0: irq 40 for MSI/MSI-X
Jan 29 19:05:39 gentoo kernel: ATL1E 0000:02:00.0: eth0: NIC Link is Up <100 Mbps Full Duplex>
Jan 29 19:05:39 gentoo kernel: udev[916]: starting version 164


# dmidecode -t memory
# dmidecode 2.10
SMBIOS 2.5 present.

Handle 0x0034, DMI type 16, 15 bytes
Physical Memory Array
        Location: System Board Or Motherboard
        Use: System Memory
        Error Correction Type: Single-bit ECC
        Maximum Capacity: 8 GB
        Error Information Handle: Not Provided
        Number Of Devices: 4

Handle 0x0036, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x0034
        Error Information Handle: Not Provided
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: DIMM
        Set: None
        Locator: DIMM0
        Bank Locator: BANK0
        Type: DDR
        Type Detail: Synchronous
        Speed: 1333 MHz
        Manufacturer: Manufacturer00
        Serial Number: SerNum00
        Asset Tag: AssetTagNum0
        Part Number: ModulePartNumber00

Handle 0x0038, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x0034
        Error Information Handle: Not Provided
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: DIMM
        Set: None
        Locator: DIMM1
        Bank Locator: BANK1
        Type: DDR
        Type Detail: Synchronous
        Speed: 1333 MHz
        Manufacturer: Manufacturer01
        Serial Number: SerNum01
        Asset Tag: AssetTagNum1
        Part Number: ModulePartNumber01

Handle 0x003A, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x0034
        Error Information Handle: Not Provided
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: DIMM
        Set: None
        Locator: DIMM2
        Bank Locator: BANK2
        Type: DDR
        Type Detail: Synchronous
        Speed: 1333 MHz
        Manufacturer: Manufacturer02
        Serial Number: SerNum02
        Asset Tag: AssetTagNum2
        Part Number: ModulePartNumber02

Handle 0x003C, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x0034
        Error Information Handle: Not Provided
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: DIMM
        Set: None
        Locator: DIMM3
        Bank Locator: BANK3
        Type: DDR
        Type Detail: Synchronous
        Speed: 1333 MHz
        Manufacturer: Manufacturer03
        Serial Number: SerNum03
        Asset Tag: AssetTagNum3
        Part Number: ModulePartNumber03


Memory type: 2x Kingston ValueRAM KVR1333D3E9SK2/4G

-- 
Markus
