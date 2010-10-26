Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab0JZOFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:05:11 -0400
Received: from smtp-out-226.synserver.de ([212.40.180.226]:1107 "HELO
	smtp-out-217.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751529Ab0JZOFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:05:09 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 26814
Date: Tue, 26 Oct 2010 16:05:00 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: Clocksource tsc unstable (delta = -8589361717 ns) in current
 git
Message-ID: <20101026140500.GA3578@arch.trippelsdorf.de>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
 <20101026131843.GC17852@aftab>
 <20101026135808.GB1672@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20101026135808.GB1672@arch.trippelsdorf.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 26, 2010 at 03:58:08PM +0200, Markus Trippelsdorf wrote:
> On Tue, Oct 26, 2010 at 03:18:43PM +0200, Borislav Petkov wrote:
> > On Tue, Oct 26, 2010 at 07:20:52AM -0400, Markus Trippelsdorf wrote:
> > > On my AMD system the following kernel messages are sometimes printed
> > > after several hours of uptime:
> > > Clocksource tsc unstable (delta = -8589361717 ns)
> > > Switching to clocksource hpet
> > 
> > This is strange, tsc is actually stable on your F10h revC.
> 
> Yes. constant_tsc is among the CPU flags.
> 
> > > This happened several times already:
> > > # grep "Clocksource" kernel.*
> > > kernel.log:Oct 24 18:31:17 arch kernel: Clocksource tsc unstable (delta = -8591703466 ns)
> > > kernel.log:Oct 26 12:54:38 arch kernel: Clocksource tsc unstable (delta = -8589361717 ns)
> > > kernel.log.1:Oct 22 21:43:51 arch kernel: Clocksource tsc unstable (delta = -25772316650 ns)
> > 
> > Do you have any warnings/oopses before that, can we have the whole dmesg
> > with the above messages?
> 
> No warning/oopses. The whole dmesg is attached.

This time I will hopefully hit the right key in mutt...
-- 
Markus

--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kernel.log"

Oct 24 10:19:05 arch kernel: Initializing cgroup subsys cpu
Oct 24 10:19:05 arch kernel: Linux version 2.6.36-03963-g35da7a3-dirty (markus@arch.trippelsdorf.de) (gcc version 4.5.1 (GCC) ) #29 SMP PREEMPT Sun Oct 24 03:26:33 CEST 2010
Oct 24 10:19:05 arch kernel: Command line: root=/dev/sdb2 fbcon=rotate:3 quiet
Oct 24 10:19:05 arch kernel: BIOS-provided physical RAM map:
Oct 24 10:19:05 arch kernel: BIOS-e820: 0000000000000100 - 000000000009fc00 (usable)
Oct 24 10:19:05 arch kernel: BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Oct 24 10:19:05 arch kernel: BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
Oct 24 10:19:05 arch kernel: BIOS-e820: 0000000000100000 - 00000000dfe90000 (usable)
Oct 24 10:19:05 arch kernel: BIOS-e820: 00000000dfe90000 - 00000000dfea8000 (ACPI data)
Oct 24 10:19:05 arch kernel: BIOS-e820: 00000000dfea8000 - 00000000dfed0000 (ACPI NVS)
Oct 24 10:19:05 arch kernel: BIOS-e820: 00000000dfed0000 - 00000000dff00000 (reserved)
Oct 24 10:19:05 arch kernel: BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Oct 24 10:19:05 arch kernel: BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
Oct 24 10:19:05 arch kernel: NX (Execute Disable) protection: active
Oct 24 10:19:05 arch kernel: DMI present.
Oct 24 10:19:05 arch kernel: e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
Oct 24 10:19:05 arch kernel: e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
Oct 24 10:19:05 arch kernel: last_pfn = 0x120000 max_arch_pfn = 0x400000000
Oct 24 10:19:05 arch kernel: MTRR default type: uncachable
Oct 24 10:19:05 arch kernel: MTRR fixed ranges enabled:
Oct 24 10:19:05 arch kernel: 00000-9FFFF write-back
Oct 24 10:19:05 arch kernel: A0000-EFFFF uncachable
Oct 24 10:19:05 arch kernel: F0000-FFFFF write-protect
Oct 24 10:19:05 arch kernel: MTRR variable ranges enabled:
Oct 24 10:19:05 arch kernel: 0 base 000000000000 mask FFFF80000000 write-back
Oct 24 10:19:05 arch kernel: 1 base 000080000000 mask FFFFC0000000 write-back
Oct 24 10:19:05 arch kernel: 2 base 0000C0000000 mask FFFFE0000000 write-back
Oct 24 10:19:05 arch kernel: 3 base 0000F0000000 mask FFFFF8000000 write-combining
Oct 24 10:19:05 arch kernel: 4 disabled
Oct 24 10:19:05 arch kernel: 5 disabled
Oct 24 10:19:05 arch kernel: 6 disabled
Oct 24 10:19:05 arch kernel: 7 disabled
Oct 24 10:19:05 arch kernel: TOM2: 0000000120000000 aka 4608M
Oct 24 10:19:05 arch kernel: x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
Oct 24 10:19:05 arch kernel: last_pfn = 0xdfe90 max_arch_pfn = 0x400000000
Oct 24 10:19:05 arch kernel: initial memory mapped : 0 - 20000000
Oct 24 10:19:05 arch kernel: Using GB pages for direct mapping
Oct 24 10:19:05 arch kernel: init_memory_mapping: 0000000000000000-00000000dfe90000
Oct 24 10:19:05 arch kernel: 0000000000 - 00c0000000 page 1G
Oct 24 10:19:05 arch kernel: 00c0000000 - 00dfe00000 page 2M
Oct 24 10:19:05 arch kernel: 00dfe00000 - 00dfe90000 page 4k
Oct 24 10:19:05 arch kernel: kernel direct mapping tables up to dfe90000 @ 1fffd000-20000000
Oct 24 10:19:05 arch kernel: init_memory_mapping: 0000000100000000-0000000120000000
Oct 24 10:19:05 arch kernel: 0100000000 - 0120000000 page 2M
Oct 24 10:19:05 arch kernel: kernel direct mapping tables up to 120000000 @ dfe8e000-dfe90000
Oct 24 10:19:05 arch kernel: ACPI: RSDP 00000000000fb880 00024 (v02 ACPIAM)
Oct 24 10:19:05 arch kernel: ACPI: XSDT 00000000dfe90100 0005C (v01 041910 XSDT2028 20100419 MSFT 00000097)
Oct 24 10:19:05 arch kernel: ACPI: FACP 00000000dfe90290 000F4 (v03 041910 FACP2028 20100419 MSFT 00000097)
Oct 24 10:19:05 arch kernel: ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20100702/tbfadt-557)
Oct 24 10:19:05 arch kernel: ACPI: DSDT 00000000dfe90450 0E6FE (v01  A1152 A1152000 00000000 INTL 20060113)
Oct 24 10:19:05 arch kernel: ACPI: FACS 00000000dfea8000 00040
Oct 24 10:19:05 arch kernel: ACPI: APIC 00000000dfe90390 0007C (v01 041910 APIC2028 20100419 MSFT 00000097)
Oct 24 10:19:05 arch kernel: ACPI: MCFG 00000000dfe90410 0003C (v01 041910 OEMMCFG  20100419 MSFT 00000097)
Oct 24 10:19:05 arch kernel: ACPI: OEMB 00000000dfea8040 00072 (v01 041910 OEMB2028 20100419 MSFT 00000097)
Oct 24 10:19:05 arch kernel: ACPI: SRAT 00000000dfe9f450 000E8 (v03 AMD    FAM_F_10 00000002 AMD  00000001)
Oct 24 10:19:05 arch kernel: ACPI: HPET 00000000dfe9f540 00038 (v01 041910 OEMHPET  20100419 MSFT 00000097)
Oct 24 10:19:05 arch kernel: ACPI: SSDT 00000000dfe9f580 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
Oct 24 10:19:05 arch kernel: ACPI: Local APIC address 0xfee00000
Oct 24 10:19:05 arch kernel: [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff8800d0000000-ffff8800d39fffff] on node 0
Oct 24 10:19:05 arch kernel: Zone PFN ranges:
Oct 24 10:19:05 arch kernel: DMA      0x00000010 -> 0x00001000
Oct 24 10:19:05 arch kernel: DMA32    0x00001000 -> 0x00100000
Oct 24 10:19:05 arch kernel: Normal   0x00100000 -> 0x00120000
Oct 24 10:19:05 arch kernel: Movable zone start PFN for each node
Oct 24 10:19:05 arch kernel: early_node_map[3] active PFN ranges
Oct 24 10:19:05 arch kernel: 0: 0x00000010 -> 0x0000009f
Oct 24 10:19:05 arch kernel: 0: 0x00000100 -> 0x000dfe90
Oct 24 10:19:05 arch kernel: 0: 0x00100000 -> 0x00120000
Oct 24 10:19:05 arch kernel: On node 0 totalpages: 1048095
Oct 24 10:19:05 arch kernel: DMA zone: 56 pages used for memmap
Oct 24 10:19:05 arch kernel: DMA zone: 2 pages reserved
Oct 24 10:19:05 arch kernel: DMA zone: 3925 pages, LIFO batch:0
Oct 24 10:19:05 arch kernel: DMA32 zone: 14280 pages used for memmap
Oct 24 10:19:05 arch kernel: DMA32 zone: 898760 pages, LIFO batch:31
Oct 24 10:19:05 arch kernel: Normal zone: 1792 pages used for memmap
Oct 24 10:19:05 arch kernel: Normal zone: 129280 pages, LIFO batch:31
Oct 24 10:19:05 arch kernel: ACPI: PM-Timer IO Port: 0x808
Oct 24 10:19:05 arch kernel: ACPI: Local APIC address 0xfee00000
Oct 24 10:19:05 arch kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Oct 24 10:19:05 arch kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Oct 24 10:19:05 arch kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Oct 24 10:19:05 arch kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Oct 24 10:19:05 arch kernel: ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
Oct 24 10:19:05 arch kernel: ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
Oct 24 10:19:05 arch kernel: ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
Oct 24 10:19:05 arch kernel: IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
Oct 24 10:19:05 arch kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Oct 24 10:19:05 arch kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Oct 24 10:19:05 arch kernel: ACPI: IRQ0 used by override.
Oct 24 10:19:05 arch kernel: ACPI: IRQ2 used by override.
Oct 24 10:19:05 arch kernel: ACPI: IRQ9 used by override.
Oct 24 10:19:05 arch kernel: Using ACPI (MADT) for SMP configuration information
Oct 24 10:19:05 arch kernel: ACPI: HPET id: 0x8300 base: 0xfed00000
Oct 24 10:19:05 arch kernel: SMP: Allowing 4 CPUs, 0 hotplug CPUs
Oct 24 10:19:05 arch kernel: nr_irqs_gsi: 40
Oct 24 10:19:05 arch kernel: Allocating PCI resources starting at dff00000 (gap: dff00000:20000000)
Oct 24 10:19:05 arch kernel: converting mcount calls to 0f 1f 44 00 00
Oct 24 10:19:05 arch kernel: setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
Oct 24 10:19:05 arch kernel: PERCPU: Embedded 24 pages/cpu @ffff8800dfc00000 s74176 r0 d24128 u524288
Oct 24 10:19:05 arch kernel: pcpu-alloc: s74176 r0 d24128 u524288 alloc=1*2097152
Oct 24 10:19:05 arch kernel: pcpu-alloc: [0] 0 1 2 3 
Oct 24 10:19:05 arch kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1031965
Oct 24 10:19:05 arch kernel: Kernel command line: root=/dev/sdb2 fbcon=rotate:3 quiet
Oct 24 10:19:05 arch kernel: PID hash table entries: 4096 (order: 3, 32768 bytes)
Oct 24 10:19:05 arch kernel: Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Oct 24 10:19:05 arch kernel: Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Oct 24 10:19:05 arch kernel: Memory: 4053416k/4718592k available (4432k kernel code, 526212k absent, 138964k reserved, 1733k data, 424k init)
Oct 24 10:19:05 arch kernel: SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Oct 24 10:19:05 arch kernel: Preemptable hierarchical RCU implementation.
Oct 24 10:19:05 arch kernel: 	RCU-based detection of stalled CPUs is disabled.
Oct 24 10:19:05 arch kernel: 	Verbose stalled-CPUs detection is disabled.
Oct 24 10:19:05 arch kernel: NR_IRQS:384
Oct 24 10:19:05 arch kernel: Extended CMOS year: 2000
Oct 24 10:19:05 arch kernel: Console: colour VGA+ 80x25
Oct 24 10:19:05 arch kernel: console [tty0] enabled
Oct 24 10:19:05 arch kernel: hpet clockevent registered
Oct 24 10:19:05 arch kernel: Fast TSC calibration using PIT
Oct 24 10:19:05 arch kernel: Detected 3211.206 MHz processor.
Oct 24 10:19:05 arch kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 6422.41 BogoMIPS (lpj=3211206)
Oct 24 10:19:05 arch kernel: pid_max: default: 32768 minimum: 301
Oct 24 10:19:05 arch kernel: Mount-cache hash table entries: 256
Oct 24 10:19:05 arch kernel: Initializing cgroup subsys blkio
Oct 24 10:19:05 arch kernel: tseg: 0000000000
Oct 24 10:19:05 arch kernel: CPU: Physical Processor ID: 0
Oct 24 10:19:05 arch kernel: CPU: Processor Core ID: 0
Oct 24 10:19:05 arch kernel: mce: CPU supports 6 MCE banks
Oct 24 10:19:05 arch kernel: using C1E aware idle routine
Oct 24 10:19:05 arch kernel: Performance Events: AMD PMU driver.
Oct 24 10:19:05 arch kernel: ... version:                0
Oct 24 10:19:05 arch kernel: ... bit width:              48
Oct 24 10:19:05 arch kernel: ... generic registers:      4
Oct 24 10:19:05 arch kernel: ... value mask:             0000ffffffffffff
Oct 24 10:19:05 arch kernel: ... max period:             00007fffffffffff
Oct 24 10:19:05 arch kernel: ... fixed-purpose events:   0
Oct 24 10:19:05 arch kernel: ... event mask:             000000000000000f
Oct 24 10:19:05 arch kernel: Freeing SMP alternatives: 16k freed
Oct 24 10:19:05 arch kernel: ACPI: Core revision 20100702
Oct 24 10:19:05 arch kernel: Setting APIC routing to flat
Oct 24 10:19:05 arch kernel: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Oct 24 10:19:05 arch kernel: CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02
Oct 24 10:19:05 arch kernel: System has AMD C1E enabled
Oct 24 10:19:05 arch kernel: Switch to broadcast mode on CPU0
Oct 24 10:19:05 arch kernel: Booting Node   0, Processors  #1
Oct 24 10:19:05 arch kernel: Switch to broadcast mode on CPU1
Oct 24 10:19:05 arch kernel: #2
Oct 24 10:19:05 arch kernel: Switch to broadcast mode on CPU2
Oct 24 10:19:05 arch kernel: #3 Ok.
Oct 24 10:19:05 arch kernel: Brought up 4 CPUs
Oct 24 10:19:05 arch kernel: Total of 4 processors activated (25687.49 BogoMIPS).
Oct 24 10:19:05 arch kernel: Switch to broadcast mode on CPU3
Oct 24 10:19:05 arch kernel: NET: Registered protocol family 16
Oct 24 10:19:05 arch kernel: node 0 link 0: io port [1000, ffffff]
Oct 24 10:19:05 arch kernel: TOM: 00000000e0000000 aka 3584M
Oct 24 10:19:05 arch kernel: Fam 10h mmconf [e0000000, efffffff]
Oct 24 10:19:05 arch kernel: node 0 link 0: mmio [a0000, bffff]
Oct 24 10:19:05 arch kernel: node 0 link 0: mmio [e0000000, efffffff] ==> none
Oct 24 10:19:05 arch kernel: node 0 link 0: mmio [f0000000, fbcfffff]
Oct 24 10:19:05 arch kernel: node 0 link 0: mmio [fbd00000, fbefffff]
Oct 24 10:19:05 arch kernel: node 0 link 0: mmio [fbf00000, ffefffff]
Oct 24 10:19:05 arch kernel: TOM2: 0000000120000000 aka 4608M
Oct 24 10:19:05 arch kernel: bus: [00, 07] on node 0 link 0
Oct 24 10:19:05 arch kernel: bus: 00 index 0 [io  0x0000-0xffff]
Oct 24 10:19:05 arch kernel: bus: 00 index 1 [mem 0x000a0000-0x000bffff]
Oct 24 10:19:05 arch kernel: bus: 00 index 2 [mem 0xf0000000-0xffffffff]
Oct 24 10:19:05 arch kernel: bus: 00 index 3 [mem 0x120000000-0xfcffffffff]
Oct 24 10:19:05 arch kernel: ACPI: bus type pci registered
Oct 24 10:19:05 arch kernel: PCI: Using configuration type 1 for base access
Oct 24 10:19:05 arch kernel: PCI: Using configuration type 1 for extended access
Oct 24 10:19:05 arch kernel: bio: create slab <bio-0> at 0
Oct 24 10:19:05 arch kernel: ACPI: EC: Look up EC in DSDT
Oct 24 10:19:05 arch kernel: ACPI: Executed 3 blocks of module-level executable AML code
Oct 24 10:19:05 arch kernel: ACPI: Interpreter enabled
Oct 24 10:19:05 arch kernel: ACPI: (supports S0 S5)
Oct 24 10:19:05 arch kernel: ACPI: Using IOAPIC for interrupt routing
Oct 24 10:19:05 arch kernel: PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Oct 24 10:19:05 arch kernel: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
Oct 24 10:19:05 arch kernel: pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
Oct 24 10:19:05 arch kernel: pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
Oct 24 10:19:05 arch kernel: pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
Oct 24 10:19:05 arch kernel: pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
Oct 24 10:19:05 arch kernel: pci_root PNP0A03:00: host bridge window [mem 0xdff00000-0xdfffffff]
Oct 24 10:19:05 arch kernel: pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
Oct 24 10:19:05 arch kernel: pci 0000:00:11.0: reg 10: [io  0xc000-0xc007]
Oct 24 10:19:05 arch kernel: pci 0000:00:11.0: reg 14: [io  0xb000-0xb003]
Oct 24 10:19:05 arch kernel: pci 0000:00:11.0: reg 18: [io  0xa000-0xa007]
Oct 24 10:19:05 arch kernel: pci 0000:00:11.0: reg 1c: [io  0x9000-0x9003]
Oct 24 10:19:05 arch kernel: pci 0000:00:11.0: reg 20: [io  0x8000-0x800f]
Oct 24 10:19:05 arch kernel: pci 0000:00:11.0: reg 24: [mem 0xfbcffc00-0xfbcfffff]
Oct 24 10:19:05 arch kernel: pci 0000:00:12.0: reg 10: [mem 0xfbcfd000-0xfbcfdfff]
Oct 24 10:19:05 arch kernel: pci 0000:00:12.1: reg 10: [mem 0xfbcfe000-0xfbcfefff]
Oct 24 10:19:05 arch kernel: pci 0000:00:12.2: reg 10: [mem 0xfbcff800-0xfbcff8ff]
Oct 24 10:19:05 arch kernel: pci 0000:00:12.2: supports D1 D2
Oct 24 10:19:05 arch kernel: pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
Oct 24 10:19:05 arch kernel: pci 0000:00:12.2: PME# disabled
Oct 24 10:19:05 arch kernel: pci 0000:00:13.0: reg 10: [mem 0xfbcfb000-0xfbcfbfff]
Oct 24 10:19:05 arch kernel: pci 0000:00:13.1: reg 10: [mem 0xfbcfc000-0xfbcfcfff]
Oct 24 10:19:05 arch kernel: pci 0000:00:13.2: reg 10: [mem 0xfbcff400-0xfbcff4ff]
Oct 24 10:19:05 arch kernel: pci 0000:00:13.2: supports D1 D2
Oct 24 10:19:05 arch kernel: pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
Oct 24 10:19:05 arch kernel: pci 0000:00:13.2: PME# disabled
Oct 24 10:19:05 arch kernel: pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
Oct 24 10:19:05 arch kernel: pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
Oct 24 10:19:05 arch kernel: pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
Oct 24 10:19:05 arch kernel: pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
Oct 24 10:19:05 arch kernel: pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
Oct 24 10:19:05 arch kernel: pci 0000:00:14.5: reg 10: [mem 0xfbcfa000-0xfbcfafff]
Oct 24 10:19:05 arch kernel: pci 0000:01:05.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
Oct 24 10:19:05 arch kernel: pci 0000:01:05.0: reg 14: [io  0xd000-0xd0ff]
Oct 24 10:19:05 arch kernel: pci 0000:01:05.0: reg 18: [mem 0xfbee0000-0xfbeeffff]
Oct 24 10:19:05 arch kernel: pci 0000:01:05.0: reg 24: [mem 0xfbd00000-0xfbdfffff]
Oct 24 10:19:05 arch kernel: pci 0000:01:05.0: supports D1 D2
Oct 24 10:19:05 arch kernel: pci 0000:01:05.1: reg 10: [mem 0xfbefc000-0xfbefffff]
Oct 24 10:19:05 arch kernel: pci 0000:01:05.1: supports D1 D2
Oct 24 10:19:05 arch kernel: pci 0000:00:01.0: PCI bridge to [bus 01-01]
Oct 24 10:19:05 arch kernel: pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
Oct 24 10:19:05 arch kernel: pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
Oct 24 10:19:05 arch kernel: pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
Oct 24 10:19:05 arch kernel: pci 0000:02:05.0: reg 10: [io  0xe800-0xe8ff]
Oct 24 10:19:05 arch kernel: pci 0000:02:05.0: reg 14: [mem 0xfbfffc00-0xfbfffcff]
Oct 24 10:19:05 arch kernel: pci 0000:02:05.0: reg 30: [mem 0xfbfc0000-0xfbfdffff pref]
Oct 24 10:19:05 arch kernel: pci 0000:02:05.0: supports D1 D2
Oct 24 10:19:05 arch kernel: pci 0000:02:05.0: PME# supported from D1 D2 D3hot D3cold
Oct 24 10:19:05 arch kernel: pci 0000:02:05.0: PME# disabled
Oct 24 10:19:05 arch kernel: pci 0000:00:14.4: PCI bridge to [bus 02-02] (subtractive decode)
Oct 24 10:19:05 arch kernel: pci 0000:00:14.4:   bridge window [io  0xe000-0xefff]
Oct 24 10:19:05 arch kernel: pci 0000:00:14.4:   bridge window [mem 0xfbf00000-0xfbffffff]
Oct 24 10:19:05 arch kernel: pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
Oct 24 10:19:05 arch kernel: pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
Oct 24 10:19:05 arch kernel: pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
Oct 24 10:19:05 arch kernel: pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
Oct 24 10:19:05 arch kernel: pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
Oct 24 10:19:05 arch kernel: pci 0000:00:14.4:   bridge window [mem 0xdff00000-0xdfffffff] (subtractive decode)
Oct 24 10:19:05 arch kernel: pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
Oct 24 10:19:05 arch kernel: pci_bus 0000:00: on NUMA node 0
Oct 24 10:19:05 arch kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Oct 24 10:19:05 arch kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
Oct 24 10:19:05 arch kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
Oct 24 10:19:05 arch kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Oct 24 10:19:05 arch kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Oct 24 10:19:05 arch kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Oct 24 10:19:05 arch kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Oct 24 10:19:05 arch kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Oct 24 10:19:05 arch kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Oct 24 10:19:05 arch kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Oct 24 10:19:05 arch kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Oct 24 10:19:05 arch kernel: SCSI subsystem initialized
Oct 24 10:19:05 arch kernel: libata version 3.00 loaded.
Oct 24 10:19:05 arch kernel: usbcore: registered new interface driver usbfs
Oct 24 10:19:05 arch kernel: usbcore: registered new interface driver hub
Oct 24 10:19:05 arch kernel: usbcore: registered new device driver usb
Oct 24 10:19:05 arch kernel: Advanced Linux Sound Architecture Driver Version 1.0.23.
Oct 24 10:19:05 arch kernel: PCI: Using ACPI for IRQ routing
Oct 24 10:19:05 arch kernel: PCI: pci_cache_line_size set to 64 bytes
Oct 24 10:19:05 arch kernel: reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
Oct 24 10:19:05 arch kernel: reserve RAM buffer: 00000000dfe90000 - 00000000dfffffff 
Oct 24 10:19:05 arch kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
Oct 24 10:19:05 arch kernel: hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Oct 24 10:19:05 arch kernel: Switching to clocksource tsc
Oct 24 10:19:05 arch kernel: pnp: PnP ACPI init
Oct 24 10:19:05 arch kernel: ACPI: bus type pnp registered
Oct 24 10:19:05 arch kernel: pnp: PnP ACPI: found 12 devices
Oct 24 10:19:05 arch kernel: ACPI: ACPI bus type pnp unregistered
Oct 24 10:19:05 arch kernel: system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
Oct 24 10:19:05 arch kernel: system 00:07: [mem 0xfee00000-0xfee00fff] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x04d0-0x04d1] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x040b] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x04d6] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0c00-0x0c01] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0c14] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0c50-0x0c51] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0c52] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0c6c] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0c6f] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0cd0-0x0cd1] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0cd2-0x0cd3] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0cd4-0x0cd5] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0cd6-0x0cd7] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0cd8-0x0cdf] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0b00-0x0b3f] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0800-0x089f] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0b00-0x0b0f] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0b20-0x0b3f] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0900-0x090f] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0x0910-0x091f] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [io  0xfe00-0xfefe] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [mem 0xdff00000-0xdfffffff] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [mem 0xffb80000-0xffbfffff] has been reserved
Oct 24 10:19:05 arch kernel: system 00:08: [mem 0xfec10000-0xfec1001f] has been reserved
Oct 24 10:19:05 arch kernel: system 00:09: [io  0x0230-0x023f] has been reserved
Oct 24 10:19:05 arch kernel: system 00:09: [io  0x0290-0x029f] has been reserved
Oct 24 10:19:05 arch kernel: system 00:09: [io  0x0f40-0x0f4f] has been reserved
Oct 24 10:19:05 arch kernel: system 00:09: [io  0x0a30-0x0a3f] has been reserved
Oct 24 10:19:05 arch kernel: system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
Oct 24 10:19:05 arch kernel: system 00:0b: [mem 0x00000000-0x0009ffff] could not be reserved
Oct 24 10:19:05 arch kernel: system 00:0b: [mem 0x000c0000-0x000cffff] has been reserved
Oct 24 10:19:05 arch kernel: system 00:0b: [mem 0x000e0000-0x000fffff] could not be reserved
Oct 24 10:19:05 arch kernel: system 00:0b: [mem 0x00100000-0xdfefffff] could not be reserved
Oct 24 10:19:05 arch kernel: system 00:0b: [mem 0xfec00000-0xffffffff] could not be reserved
Oct 24 10:19:05 arch kernel: pci 0000:00:01.0: PCI bridge to [bus 01-01]
Oct 24 10:19:05 arch kernel: pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
Oct 24 10:19:05 arch kernel: pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
Oct 24 10:19:05 arch kernel: pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
Oct 24 10:19:05 arch kernel: pci 0000:00:14.4: PCI bridge to [bus 02-02]
Oct 24 10:19:05 arch kernel: pci 0000:00:14.4:   bridge window [io  0xe000-0xefff]
Oct 24 10:19:05 arch kernel: pci 0000:00:14.4:   bridge window [mem 0xfbf00000-0xfbffffff]
Oct 24 10:19:05 arch kernel: pci 0000:00:14.4:   bridge window [mem pref disabled]
Oct 24 10:19:05 arch kernel: pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
Oct 24 10:19:05 arch kernel: pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
Oct 24 10:19:05 arch kernel: pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
Oct 24 10:19:05 arch kernel: pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
Oct 24 10:19:05 arch kernel: pci_bus 0000:00: resource 8 [mem 0xdff00000-0xdfffffff]
Oct 24 10:19:05 arch kernel: pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
Oct 24 10:19:05 arch kernel: pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
Oct 24 10:19:05 arch kernel: pci_bus 0000:01: resource 1 [mem 0xfbd00000-0xfbefffff]
Oct 24 10:19:05 arch kernel: pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
Oct 24 10:19:05 arch kernel: pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
Oct 24 10:19:05 arch kernel: pci_bus 0000:02: resource 1 [mem 0xfbf00000-0xfbffffff]
Oct 24 10:19:05 arch kernel: pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
Oct 24 10:19:05 arch kernel: pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
Oct 24 10:19:05 arch kernel: pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
Oct 24 10:19:05 arch kernel: pci_bus 0000:02: resource 7 [mem 0x000d0000-0x000dffff]
Oct 24 10:19:05 arch kernel: pci_bus 0000:02: resource 8 [mem 0xdff00000-0xdfffffff]
Oct 24 10:19:05 arch kernel: pci_bus 0000:02: resource 9 [mem 0xf0000000-0xfebfffff]
Oct 24 10:19:05 arch kernel: NET: Registered protocol family 2
Oct 24 10:19:05 arch kernel: IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
Oct 24 10:19:05 arch kernel: TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
Oct 24 10:19:05 arch kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Oct 24 10:19:05 arch kernel: TCP: Hash tables configured (established 262144 bind 65536)
Oct 24 10:19:05 arch kernel: TCP reno registered
Oct 24 10:19:05 arch kernel: UDP hash table entries: 2048 (order: 4, 65536 bytes)
Oct 24 10:19:05 arch kernel: UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
Oct 24 10:19:05 arch kernel: NET: Registered protocol family 1
Oct 24 10:19:05 arch kernel: pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
Oct 24 10:19:05 arch kernel: pci 0000:01:05.0: Boot video device
Oct 24 10:19:05 arch kernel: PCI: CLS mismatch (64 != 32), using 64 bytes
Oct 24 10:19:05 arch kernel: PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Oct 24 10:19:05 arch kernel: Placing 64MB software IO TLB between ffff8800db48b000 - ffff8800df48b000
Oct 24 10:19:05 arch kernel: software IO TLB at phys 0xdb48b000 - 0xdf48b000
Oct 24 10:19:05 arch kernel: kvm: Nested Virtualization enabled
Oct 24 10:19:05 arch kernel: kvm: Nested Paging enabled
Oct 24 10:19:05 arch kernel: msgmni has been set to 7916
Oct 24 10:19:05 arch kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
Oct 24 10:19:05 arch kernel: io scheduler noop registered
Oct 24 10:19:05 arch kernel: io scheduler cfq registered (default)
Oct 24 10:19:05 arch kernel: input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
Oct 24 10:19:05 arch kernel: ACPI: Power Button [PWRB]
Oct 24 10:19:05 arch kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Oct 24 10:19:05 arch kernel: ACPI: Power Button [PWRF]
Oct 24 10:19:05 arch kernel: ACPI: acpi_idle registered with cpuidle
Oct 24 10:19:05 arch kernel: ACPI: processor limited to max C-state 1
Oct 24 10:19:05 arch kernel: Real Time Clock Driver v1.12b
Oct 24 10:19:05 arch kernel: Linux agpgart interface v0.103
Oct 24 10:19:05 arch kernel: [drm] Initialized drm 1.1.0 20060810
Oct 24 10:19:05 arch kernel: [drm] radeon defaulting to kernel modesetting.
Oct 24 10:19:05 arch kernel: [drm] radeon kernel modesetting enabled.
Oct 24 10:19:05 arch kernel: radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Oct 24 10:19:05 arch kernel: radeon 0000:01:05.0: setting latency timer to 64
Oct 24 10:19:05 arch kernel: [drm] initializing kernel modesetting (RS780 0x1002:0x9614).
Oct 24 10:19:05 arch kernel: [drm] register mmio base: 0xFBEE0000
Oct 24 10:19:05 arch kernel: [drm] register mmio size: 65536
Oct 24 10:19:05 arch kernel: ATOM BIOS: 113
Oct 24 10:19:05 arch kernel: radeon 0000:01:05.0: VRAM: 128M 0xC0000000 - 0xC7FFFFFF (128M used)
Oct 24 10:19:05 arch kernel: radeon 0000:01:05.0: GTT: 512M 0xA0000000 - 0xBFFFFFFF
Oct 24 10:19:05 arch kernel: [drm] Detected VRAM RAM=128M, BAR=128M
Oct 24 10:19:05 arch kernel: [drm] RAM width 32bits DDR
Oct 24 10:19:05 arch kernel: [TTM] Zone  kernel: Available graphics memory: 2026716 kiB.
Oct 24 10:19:05 arch kernel: [TTM] Initializing pool allocator.
Oct 24 10:19:05 arch kernel: [drm] radeon: 128M of VRAM memory ready
Oct 24 10:19:05 arch kernel: [drm] radeon: 512M of GTT memory ready.
Oct 24 10:19:05 arch kernel: [drm] radeon: irq initialized.
Oct 24 10:19:05 arch kernel: [drm] GART: num cpu pages 131072, num gpu pages 131072
Oct 24 10:19:05 arch kernel: [drm] Loading RS780 Microcode
Oct 24 10:19:05 arch kernel: [drm] ring test succeeded in 1 usecs
Oct 24 10:19:05 arch kernel: [drm] radeon: ib pool ready.
Oct 24 10:19:05 arch kernel: [drm] ib test succeeded in 0 usecs
Oct 24 10:19:05 arch kernel: [drm] Enabling audio support
Oct 24 10:19:05 arch kernel: [drm] Radeon Display Connectors
Oct 24 10:19:05 arch kernel: [drm] Connector 0:
Oct 24 10:19:05 arch kernel: [drm]   VGA
Oct 24 10:19:05 arch kernel: [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
Oct 24 10:19:05 arch kernel: [drm]   Encoders:
Oct 24 10:19:05 arch kernel: [drm]     CRT1: INTERNAL_KLDSCP_DAC1
Oct 24 10:19:05 arch kernel: [drm] Connector 1:
Oct 24 10:19:05 arch kernel: [drm]   DVI-D
Oct 24 10:19:05 arch kernel: [drm]   HPD3
Oct 24 10:19:05 arch kernel: [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
Oct 24 10:19:05 arch kernel: [drm]   Encoders:
Oct 24 10:19:05 arch kernel: [drm]     DFP3: INTERNAL_KLDSCP_LVTMA
Oct 24 10:19:05 arch kernel: [drm] radeon: power management initialized
Oct 24 10:19:05 arch kernel: [drm] fb mappable at 0xF0141000
Oct 24 10:19:05 arch kernel: [drm] vram apper at 0xF0000000
Oct 24 10:19:05 arch kernel: [drm] size 7258112
Oct 24 10:19:05 arch kernel: [drm] fb depth is 24
Oct 24 10:19:05 arch kernel: [drm]    pitch is 6912
Oct 24 10:19:05 arch kernel: Console: switching to colour frame buffer device 131x105
Oct 24 10:19:05 arch kernel: fb0: radeondrmfb frame buffer device
Oct 24 10:19:05 arch kernel: drm: registered panic notifier
Oct 24 10:19:05 arch kernel: [drm] Initialized radeon 2.6.0 20080528 for 0000:01:05.0 on minor 0
Oct 24 10:19:05 arch kernel: loop: module loaded
Oct 24 10:19:05 arch kernel: ahci 0000:00:11.0: version 3.0
Oct 24 10:19:05 arch kernel: ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Oct 24 10:19:05 arch kernel: ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
Oct 24 10:19:05 arch kernel: ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
Oct 24 10:19:05 arch kernel: scsi0 : ahci
Oct 24 10:19:05 arch kernel: scsi1 : ahci
Oct 24 10:19:05 arch kernel: scsi2 : ahci
Oct 24 10:19:05 arch kernel: scsi3 : ahci
Oct 24 10:19:05 arch kernel: ata1: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY changed
Oct 24 10:19:05 arch kernel: ata2: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd80 irq 22
Oct 24 10:19:05 arch kernel: ata3: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe00 irq 22
Oct 24 10:19:05 arch kernel: ata4: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe80 irq 22
Oct 24 10:19:05 arch kernel: pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 24 10:19:05 arch kernel: scsi4 : pata_atiixp
Oct 24 10:19:05 arch kernel: scsi5 : pata_atiixp
Oct 24 10:19:05 arch kernel: ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
Oct 24 10:19:05 arch kernel: ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
Oct 24 10:19:05 arch kernel: PPP generic driver version 2.4.2
Oct 24 10:19:05 arch kernel: tun: Universal TUN/TAP device driver, 1.6
Oct 24 10:19:05 arch kernel: tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Oct 24 10:19:05 arch kernel: r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
Oct 24 10:19:05 arch kernel: r8169 0000:02:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Oct 24 10:19:05 arch kernel: r8169 0000:02:05.0: (unregistered net_device): no PCI Express capability
Oct 24 10:19:05 arch kernel: r8169 0000:02:05.0: eth0: RTL8110s at 0xffffc90000452c00, 00:08:54:36:f2:2f, XID 04000000 IRQ 20
Oct 24 10:19:05 arch kernel: usbmon: debugfs is not available
Oct 24 10:19:05 arch kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Oct 24 10:19:05 arch kernel: ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Oct 24 10:19:05 arch kernel: ehci_hcd 0000:00:12.2: EHCI Host Controller
Oct 24 10:19:05 arch kernel: ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
Oct 24 10:19:05 arch kernel: ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
Oct 24 10:19:05 arch kernel: ehci_hcd 0000:00:12.2: debug port 1
Oct 24 10:19:05 arch kernel: ehci_hcd 0000:00:12.2: irq 17, io mem 0xfbcff800
Oct 24 10:19:05 arch kernel: ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
Oct 24 10:19:05 arch kernel: hub 1-0:1.0: USB hub found
Oct 24 10:19:05 arch kernel: hub 1-0:1.0: 6 ports detected
Oct 24 10:19:05 arch kernel: ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Oct 24 10:19:05 arch kernel: ehci_hcd 0000:00:13.2: EHCI Host Controller
Oct 24 10:19:05 arch kernel: ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
Oct 24 10:19:05 arch kernel: ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
Oct 24 10:19:05 arch kernel: ehci_hcd 0000:00:13.2: debug port 1
Oct 24 10:19:05 arch kernel: ehci_hcd 0000:00:13.2: irq 19, io mem 0xfbcff400
Oct 24 10:19:05 arch kernel: ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
Oct 24 10:19:05 arch kernel: hub 2-0:1.0: USB hub found
Oct 24 10:19:05 arch kernel: hub 2-0:1.0: 6 ports detected
Oct 24 10:19:05 arch kernel: ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:12.0: OHCI Host Controller
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:12.0: irq 16, io mem 0xfbcfd000
Oct 24 10:19:05 arch kernel: hub 3-0:1.0: USB hub found
Oct 24 10:19:05 arch kernel: hub 3-0:1.0: 3 ports detected
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:12.1: OHCI Host Controller
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:12.1: irq 16, io mem 0xfbcfe000
Oct 24 10:19:05 arch kernel: hub 4-0:1.0: USB hub found
Oct 24 10:19:05 arch kernel: hub 4-0:1.0: 3 ports detected
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:13.0: OHCI Host Controller
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:13.0: irq 18, io mem 0xfbcfb000
Oct 24 10:19:05 arch kernel: ata5.00: ATAPI: HL-DT-STDVD-RAM GH22NP20, 1.03, max UDMA/66
Oct 24 10:19:05 arch kernel: ata5.00: configured for UDMA/66
Oct 24 10:19:05 arch kernel: hub 5-0:1.0: USB hub found
Oct 24 10:19:05 arch kernel: hub 5-0:1.0: 3 ports detected
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:13.1: OHCI Host Controller
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:13.1: irq 18, io mem 0xfbcfc000
Oct 24 10:19:05 arch kernel: hub 6-0:1.0: USB hub found
Oct 24 10:19:05 arch kernel: hub 6-0:1.0: 3 ports detected
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:14.5: OHCI Host Controller
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
Oct 24 10:19:05 arch kernel: ohci_hcd 0000:00:14.5: irq 18, io mem 0xfbcfa000
Oct 24 10:19:05 arch kernel: hub 7-0:1.0: USB hub found
Oct 24 10:19:05 arch kernel: hub 7-0:1.0: 2 ports detected
Oct 24 10:19:05 arch kernel: Initializing USB Mass Storage driver...
Oct 24 10:19:05 arch kernel: usbcore: registered new interface driver usb-storage
Oct 24 10:19:05 arch kernel: USB Mass Storage support registered.
Oct 24 10:19:05 arch kernel: usbcore: registered new interface driver usbserial
Oct 24 10:19:05 arch kernel: USB Serial support registered for generic
Oct 24 10:19:05 arch kernel: ata4: SATA link down (SStatus 0 SControl 300)
Oct 24 10:19:05 arch kernel: ata2: SATA link down (SStatus 0 SControl 300)
Oct 24 10:19:05 arch kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Oct 24 10:19:05 arch kernel: ata3.00: ATA-8: OCZ-VERTEX, 1.6, max UDMA/133
Oct 24 10:19:05 arch kernel: ata3.00: 62533296 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
Oct 24 10:19:05 arch kernel: ata3.00: configured for UDMA/133
Oct 24 10:19:05 arch kernel: usb 4-1: new full speed USB device using ohci_hcd and address 2
Oct 24 10:19:05 arch kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Oct 24 10:19:05 arch kernel: ata1.00: ATA-7: SAMSUNG HD103UJ, 1AA01118, max UDMA7
Oct 24 10:19:05 arch kernel: ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Oct 24 10:19:05 arch kernel: ata1.00: configured for UDMA/133
Oct 24 10:19:05 arch kernel: scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
Oct 24 10:19:05 arch kernel: sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Oct 24 10:19:05 arch kernel: sd 0:0:0:0: [sda] Write Protect is off
Oct 24 10:19:05 arch kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 24 10:19:05 arch kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 24 10:19:05 arch kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Oct 24 10:19:05 arch kernel: scsi 2:0:0:0: Direct-Access     ATA      OCZ-VERTEX       1.6  PQ: 0 ANSI: 5
Oct 24 10:19:05 arch kernel: sd 2:0:0:0: [sdb] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
Oct 24 10:19:05 arch kernel: sd 2:0:0:0: Attached scsi generic sg1 type 0
Oct 24 10:19:05 arch kernel: sd 2:0:0:0: [sdb] Write Protect is off
Oct 24 10:19:05 arch kernel: sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Oct 24 10:19:05 arch kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 24 10:19:05 arch kernel: scsi 4:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GH22NP20 1.03 PQ: 0 ANSI: 5
Oct 24 10:19:05 arch kernel: sdb: sdb1 sdb2
Oct 24 10:19:05 arch kernel: sd 2:0:0:0: [sdb] Attached SCSI disk
Oct 24 10:19:05 arch kernel: sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Oct 24 10:19:05 arch kernel: cdrom: Uniform CD-ROM driver Revision: 3.20
Oct 24 10:19:05 arch kernel: sr 4:0:0:0: Attached scsi CD-ROM sr0
Oct 24 10:19:05 arch kernel: sr 4:0:0:0: Attached scsi generic sg2 type 5
Oct 24 10:19:05 arch kernel: sda: sda1 sda2 sda3
Oct 24 10:19:05 arch kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Oct 24 10:19:05 arch kernel: usb 4-2: new full speed USB device using ohci_hcd and address 3
Oct 24 10:19:05 arch kernel: usb 4-3: new low speed USB device using ohci_hcd and address 4
Oct 24 10:19:05 arch kernel: usbcore: registered new interface driver usbserial_generic
Oct 24 10:19:05 arch kernel: usbserial: USB Serial Driver core
Oct 24 10:19:05 arch kernel: USB Serial support registered for GSM modem (1-port)
Oct 24 10:19:05 arch kernel: usbcore: registered new interface driver option
Oct 24 10:19:05 arch kernel: option: v0.7.2:USB Driver for GSM modems
Oct 24 10:19:05 arch kernel: PNP: No PS/2 controller found. Probing ports directly.
Oct 24 10:19:05 arch kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Oct 24 10:19:05 arch kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Oct 24 10:19:05 arch kernel: mice: PS/2 mouse device common for all mice
Oct 24 10:19:05 arch kernel: i2c /dev entries driver
Oct 24 10:19:05 arch kernel: cpuidle: using governor ladder
Oct 24 10:19:05 arch kernel: cpuidle: using governor menu
Oct 24 10:19:05 arch kernel: usbcore: registered new interface driver hiddev
Oct 24 10:19:05 arch kernel: input: C-Media USB Headphone Set   as /devices/pci0000:00/0000:00:12.1/usb4/4-1/4-1:1.3/input/input2
Oct 24 10:19:05 arch kernel: generic-usb 0003:0D8C:000C.0001: input,hidraw0: USB HID v1.00 Device [C-Media USB Headphone Set  ] on usb-0000:00:12.1-1/input3
Oct 24 10:19:05 arch kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.0/input/input3
Oct 24 10:19:05 arch kernel: generic-usb 0003:046D:C52B.0002: input,hidraw1: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb-0000:00:12.1-2/input0
Oct 24 10:19:05 arch kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.1/input/input4
Oct 24 10:19:05 arch kernel: generic-usb 0003:046D:C52B.0003: input,hiddev0,hidraw2: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-2/input1
Oct 24 10:19:05 arch kernel: generic-usb 0003:046D:C52B.0004: hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.1-2/input2
Oct 24 10:19:05 arch kernel: input: HID 046a:0011 as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input5
Oct 24 10:19:05 arch kernel: generic-usb 0003:046A:0011.0005: input,hidraw4: USB HID v1.10 Keyboard [HID 046a:0011] on usb-0000:00:12.1-3/input0
Oct 24 10:19:05 arch kernel: usbcore: registered new interface driver usbhid
Oct 24 10:19:05 arch kernel: usbhid: USB HID core driver
Oct 24 10:19:05 arch kernel: usbcore: registered new interface driver snd-usb-audio
Oct 24 10:19:05 arch kernel: ALSA device list:
Oct 24 10:19:05 arch kernel: #0: C-Media USB Headphone Set   at usb-0000:00:12.1-1, full speed
Oct 24 10:19:05 arch kernel: Netfilter messages via NETLINK v0.30.
Oct 24 10:19:05 arch kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Oct 24 10:19:05 arch kernel: ctnetlink v0.93: registering with nfnetlink.
Oct 24 10:19:05 arch kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Oct 24 10:19:05 arch kernel: TCP cubic registered
Oct 24 10:19:05 arch kernel: NET: Registered protocol family 17
Oct 24 10:19:05 arch kernel: powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor (4 cpu cores) (version 2.20.00)
Oct 24 10:19:05 arch kernel: powernow-k8:    0 : pstate 0 (3200 MHz)
Oct 24 10:19:05 arch kernel: powernow-k8:    1 : pstate 1 (2500 MHz)
Oct 24 10:19:05 arch kernel: powernow-k8:    2 : pstate 2 (2100 MHz)
Oct 24 10:19:05 arch kernel: powernow-k8:    3 : pstate 3 (800 MHz)
Oct 24 10:19:05 arch kernel: EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
Oct 24 10:19:05 arch kernel: VFS: Mounted root (ext4 filesystem) readonly on device 8:18.
Oct 24 10:19:05 arch kernel: Freeing unused kernel memory: 424k freed
Oct 24 10:19:05 arch kernel: udev[751]: starting version 163
Oct 24 10:19:05 arch kernel: EXT4-fs (sdb2): re-mounted. Opts: (null)
Oct 24 10:19:05 arch kernel: EXT4-fs (sdb2): re-mounted. Opts: (null)
Oct 24 10:19:05 arch kernel: EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
Oct 24 10:19:05 arch kernel: EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
Oct 24 10:19:05 arch kernel: Adding 200808k swap on /dev/sda3.  Priority:-1 extents:1 across:200808k 
Oct 24 10:19:05 arch kernel: r8169 0000:02:05.0: eth0: link up
Oct 24 16:56:39 arch kernel: usb 5-1: new full speed USB device using ohci_hcd and address 2
Oct 24 16:56:40 arch kernel: input: Burr-Brown from TI               USB Audio CODEC  as /devices/pci0000:00/0000:00:13.0/usb5/5-1/5-1:1.3/input/input6
Oct 24 16:56:40 arch kernel: generic-usb 0003:08BB:2902.0006: input,hidraw5: USB HID v1.00 Device [Burr-Brown from TI               USB Audio CODEC ] on usb-0000:00:13.0-1/input3
Oct 24 16:56:43 arch kernel: usb 5-1: USB disconnect, address 2
Oct 24 16:57:05 arch kernel: usb 5-2: new full speed USB device using ohci_hcd and address 3
Oct 24 16:57:05 arch kernel: input: Burr-Brown from TI               USB Audio CODEC  as /devices/pci0000:00/0000:00:13.0/usb5/5-2/5-2:1.3/input/input7
Oct 24 16:57:05 arch kernel: generic-usb 0003:08BB:2902.0007: input,hidraw5: USB HID v1.00 Device [Burr-Brown from TI               USB Audio CODEC ] on usb-0000:00:13.0-2/input3
Oct 24 18:16:06 arch kernel: usb 5-2: USB disconnect, address 3
Oct 24 18:31:17 arch kernel: Clocksource tsc unstable (delta = -8591703466 ns)
Oct 24 18:31:17 arch kernel: Switching to clocksource hpet

--bg08WKrSYDhXBjb5--
