Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab1IJEtt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 00:49:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53078 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab1IJEtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 00:49:47 -0400
Subject: Re: linux-3.1-0-rc4 bus error ... MPS configured higher than
 maximum supported by the device. If a bus issue occurs, try running with
 pci=pcie_bus_safe.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        Jordan_Hargrave@dell.com, Jon Mason <mason@myri.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <CA+55aFyGQuPh0W7aEtng1NM1q3Vg6HAT83eiNk+fRFUjpsXPCg@mail.gmail.com>
References: <CAAJw_Zv9LaOut6+aQWki_-nCngEEfh-OVqF4rsUwb-LPfLk8Ug@mail.gmail.com>
	 <CAAJw_ZvP6m=3T0YoYq6VJdOKMxzm3fDcdJoDY8wqqDV8GZB+Dg@mail.gmail.com>
	 <1315290313.2565.0.camel@edumazet-laptop>
	 <CAAJw_ZvTX374XDZEi_rFAL=797au_7J9gfuDVz-h9o-+Zp_f4w@mail.gmail.com>
	 <CA+55aFyGQuPh0W7aEtng1NM1q3Vg6HAT83eiNk+fRFUjpsXPCg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Sep 2011 06:49:13 +0200
Message-ID: <1315630153.2606.24.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 09 septembre 2011 à 19:55 -0700, Linus Torvalds a écrit :
> On Tue, Sep 6, 2011 at 1:39 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> >
> > Thanks. I saw that. And the system nearly got trashed even though I've
> > no hpsa. Grub went into rescue mode after reboot, and I had to rebuild
> > the grub boot sector.
> >
> > Now, it's all ok with pcie_aspm=force and pci=pcie_bus_safe.
> 
> Jeff, Eric,
>   Is the current -git state ok for you guys? I just pushed out commit
> ed2888e906b5 ("PCI: Remove MRRS modification from MPS setting code")
> which should default to safe pcie behavior.
> 
> I just wanted to verify that that was all sufficient for this thread..
> 

Hi Linus

I pulled your last changes, and did some tests on my HP BL460c G6,
including several stress sessions (make -j128 and various benches)

So far, everything seems fine, thanks.

Here is a dmesg output in anycase.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-rc5+ (root@svivoipvnx021) (gcc version 4.6.1 (Debian 4.6.1-4) ) #64 SMP PREEMPT Sat Sep 10 06:27:17 CEST 2011
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.1.0-rc5+ root=UUID=65aecdf5-c988-4afe-ac94-09a9f3d35653 ro quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df61f000 (usable)
[    0.000000]  BIOS-e820: 00000000df61f000 - 00000000df62c000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df62c000 - 00000000df62d000 (usable)
[    0.000000]  BIOS-e820: 00000000df62d000 - 00000000e4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000011ffff000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: HP ProLiant BL460c G6, BIOS I24 05/05/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x11ffff max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xdf62d max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f4f80] f4f80
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000df62d000
[    0.000000]  0000000000 - 00df600000 page 2M
[    0.000000]  00df600000 - 00df62d000 page 4k
[    0.000000] kernel direct mapping tables up to df62d000 @ df619000-df61f000
[    0.000000] init_memory_mapping: 0000000100000000-000000011ffff000
[    0.000000]  0100000000 - 011fe00000 page 2M
[    0.000000]  011fe00000 - 011ffff000 page 4k
[    0.000000] kernel direct mapping tables up to 11ffff000 @ 11fff8000-11ffff000
[    0.000000] RAMDISK: 37b1e000 - 37d87000
[    0.000000] ACPI: RSDP 00000000000f4f00 00024 (v02 HP    )
[    0.000000] ACPI: XSDT 00000000df620080 000AC (v01 HP     ProLiant 00000002   �? 0000162E)
[    0.000000] ACPI: FACP 00000000df620180 000F4 (v03 HP     ProLiant 00000002   �? 0000162E)
[    0.000000] ACPI Warning: Invalid length for Pm1aControlBlock: 32, using default 16 (20110623/tbfadt-610)
[    0.000000] ACPI Warning: Invalid length for Pm2ControlBlock: 32, using default 8 (20110623/tbfadt-610)
[    0.000000] ACPI: DSDT 00000000df620280 01F90 (v01 HP         DSDT 00000001 INTL 20030228)
[    0.000000] ACPI: FACS 00000000df61f100 00040
[    0.000000] ACPI: SPCR 00000000df61f140 00050 (v01 HP     SPCRRBSU 00000001   �? 0000162E)
[    0.000000] ACPI: MCFG 00000000df61f1c0 0003C (v01 HP     ProLiant 00000001      00000000)
[    0.000000] ACPI: HPET 00000000df61f200 00038 (v01 HP     ProLiant 00000002   �? 0000162E)
[    0.000000] ACPI: FFFF 00000000df61f240 00064 (v02 HP     ProLiant 00000002   �? 0000162E)
[    0.000000] ACPI: SPMI 00000000df61f2c0 00040 (v05 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: ERST 00000000df61f300 001D0 (v01 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: APIC 00000000df61f500 0015E (v01 HP     ProLiant 00000002      00000000)
[    0.000000] ACPI: SRAT 00000000df61f680 00570 (v01 HP     Proliant 00000001   �? 0000162E)
[    0.000000] ACPI: FFFF 00000000df61fc00 00176 (v01 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: BERT 00000000df61fd80 00030 (v01 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: HEST 00000000df61fdc0 000BC (v01 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: DMAR 00000000df61fe80 0013C (v01 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: SSDT 00000000df622240 00125 (v03     HP  CRSPCI0 00000002   HP 00000001)
[    0.000000] ACPI: SSDT 00000000df622380 003BB (v01     HP      pcc 00000001 INTL 20090625)
[    0.000000] ACPI: SSDT 00000000df622740 00377 (v01     HP     pmab 00000001 INTL 20090625)
[    0.000000] ACPI: SSDT 00000000df622ac0 022E4 (v01  INTEL PPM RCM  00000001 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x10 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x11 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x12 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x13 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x14 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x15 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x16 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x17 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 0-80000000
[    0.000000] SRAT: Node 1 PXM 1 80000000-e0000000
[    0.000000] SRAT: Node 1 PXM 1 100000000-120000000
[    0.000000] NUMA: Node 1 [80000000,e0000000) + [100000000,11ffff000) -> [80000000,11ffff000)
[    0.000000] Initmem setup node 0 0000000000000000-0000000080000000
[    0.000000]   NODE_DATA [000000007fffb000 - 000000007fffffff]
[    0.000000] Initmem setup node 1 0000000080000000-000000011ffff000
[    0.000000]   NODE_DATA [000000011fffa000 - 000000011fffefff]
[    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007de00000-ffff88007fdfffff] on node 0
[    0.000000]  [ffffea0002000000-ffffea00047fffff] PMD -> [ffff88011d600000-ffff88011f5fffff] on node 1
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0011ffff
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00080000
[    0.000000]     1: 0x00080000 -> 0x000df61f
[    0.000000]     1: 0x000df62c -> 0x000df62d
[    0.000000]     1: 0x00100000 -> 0x0011ffff
[    0.000000] On node 0 totalpages: 524175
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3914 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8128 pages used for memmap
[    0.000000]   DMA32 zone: 512064 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 521759
[    0.000000]   DMA32 zone: 8192 pages used for memmap
[    0.000000]   DMA32 zone: 382496 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 129023 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 0, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 32 CPUs, 16 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000df61f000 - 00000000df62c000
[    0.000000] PM: Registered nosave memory: 00000000df62d000 - 00000000e4000000
[    0.000000] PM: Registered nosave memory: 00000000e4000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fee10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e4000000 (gap: e4000000:1ac00000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:32 nr_node_ids:2
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88007dc00000 s75136 r8192 d23168 u131072
[    0.000000] pcpu-alloc: s75136 r8192 d23168 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 02 04 06 08 10 12 14 17 19 21 23 25 27 29 31 
[    0.000000] pcpu-alloc: [1] 01 03 05 07 09 11 13 15 16 18 20 22 24 26 28 30 
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 1027497
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.1.0-rc5+ root=UUID=65aecdf5-c988-4afe-ac94-09a9f3d35653 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 4031352k/4718588k available (7279k kernel code, 534852k absent, 152384k reserved, 5617k data, 856k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=32, Nodes=2
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:1344 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2533.240 MHz processor.
[    0.000007] Calibrating delay loop (skipped), value calculated using timer frequency.. 5066.48 BogoMIPS (lpj=2533240)
[    0.000011] pid_max: default: 32768 minimum: 301
[    0.000072] Security Framework initialized
[    0.000076] SELinux:  Initializing.
[    0.000093] SELinux:  Starting in permissive mode
[    0.000417] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001580] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002081] Mount-cache hash table entries: 256
[    0.002309] Initializing cgroup subsys cpuacct
[    0.002316] Initializing cgroup subsys freezer
[    0.002352] CPU: Physical Processor ID: 1
[    0.002353] CPU: Processor Core ID: 0
[    0.002358] mce: CPU supports 9 MCE banks
[    0.002369] CPU0: Thermal monitoring enabled (TM1)
[    0.002376] using mwait in idle threads.
[    0.002447] ACPI: Core revision 20110623
[    0.004871] ftrace: allocating 26284 entries in 104 pages
[    0.013876] DMAR: Host address width 39
[    0.013879] DMAR: DRHD base: 0x000000e7ffe000 flags: 0x1
[    0.013890] IOMMU 0: reg_base_addr e7ffe000 ver 1:0 cap c90780106f0462 ecap f0207e
[    0.013892] DMAR: RMRR base: 0x000000df7fd000 end: 0x000000df7fefff
[    0.013894] DMAR: RMRR base: 0x000000df7f6000 end: 0x000000df7fbfff
[    0.013896] DMAR: RMRR base: 0x000000df63e000 end: 0x000000df63ffff
[    0.013897] DMAR: ATSR flags: 0x0
[    0.014119] Switched APIC routing to physical flat.
[    0.014557] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.024555] CPU0: Intel(R) Xeon(R) CPU           E5540  @ 2.53GHz stepping 05
[    0.125964] Performance Events: PEBS fmt1+, erratum AAJ80 worked around, Nehalem events, Broken BIOS detected, complain to your hardware vendor.
[    0.125970] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is 330)
[    0.126054] Intel PMU driver.
[    0.126056] ... version:                3
[    0.126058] ... bit width:              48
[    0.126059] ... generic registers:      4
[    0.126060] ... value mask:             0000ffffffffffff
[    0.126062] ... max period:             000000007fffffff
[    0.126063] ... fixed-purpose events:   3
[    0.126064] ... event mask:             000000070000000f
[    0.137968] Booting Node   0, Processors  #1
[    0.137971] smpboot cpu 1: start_ip = 9a000
[    0.232909]  Ok.
[    0.232911] Booting Node   1, Processors  #2
[    0.232913] smpboot cpu 2: start_ip = 9a000
[    0.327852]  Ok.
[    0.327854] Booting Node   0, Processors  #3
[    0.327857] smpboot cpu 3: start_ip = 9a000
[    0.422784]  Ok.
[    0.422786] Booting Node   1, Processors  #4
[    0.422788] smpboot cpu 4: start_ip = 9a000
[    0.517725]  Ok.
[    0.517728] Booting Node   0, Processors  #5
[    0.517730] smpboot cpu 5: start_ip = 9a000
[    0.612651]  Ok.
[    0.612652] Booting Node   1, Processors  #6
[    0.612654] smpboot cpu 6: start_ip = 9a000
[    0.707595]  Ok.
[    0.707598] Booting Node   0, Processors  #7
[    0.707600] smpboot cpu 7: start_ip = 9a000
[    0.802521]  Ok.
[    0.802522] Booting Node   1, Processors  #8
[    0.802524] smpboot cpu 8: start_ip = 9a000
[    0.897468]  Ok.
[    0.897470] Booting Node   0, Processors  #9
[    0.897473] smpboot cpu 9: start_ip = 9a000
[    0.992395]  Ok.
[    0.992397] Booting Node   1, Processors  #10
[    0.992399] smpboot cpu 10: start_ip = 9a000
[    1.087340]  Ok.
[    1.087343] Booting Node   0, Processors  #11
[    1.087345] smpboot cpu 11: start_ip = 9a000
[    1.182262]  Ok.
[    1.182263] Booting Node   1, Processors  #12
[    1.182265] smpboot cpu 12: start_ip = 9a000
[    1.277207]  Ok.
[    1.277209] Booting Node   0, Processors  #13
[    1.277212] smpboot cpu 13: start_ip = 9a000
[    1.372132]  Ok.
[    1.372134] Booting Node   1, Processors  #14
[    1.372135] smpboot cpu 14: start_ip = 9a000
[    1.467077]  Ok.
[    1.467080] Booting Node   0, Processors  #15
[    1.467082] smpboot cpu 15: start_ip = 9a000
[    1.558039] Brought up 16 CPUs
[    1.558042] Total of 16 processors activated (81055.83 BogoMIPS).
[    1.566152] kworker/u:0 used greatest stack depth: 5592 bytes left
[    1.566415] RTC time:  4:31:27, date: 09/10/11
[    1.566480] NET: Registered protocol family 16
[    1.566956] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    1.566959] ACPI: bus type pci registered
[    1.567068] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    1.567071] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    1.576232] PCI: Using configuration type 1 for base access
[    1.586655] bio: create slab <bio-0> at 0
[    1.586817] ACPI: Added _OSI(Module Device)
[    1.586820] ACPI: Added _OSI(Processor Device)
[    1.586821] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.586823] ACPI: Added _OSI(Processor Aggregator Device)
[    1.587647] ACPI: EC: Look up EC in DSDT
[    1.587800] \_SB_:_OSC evaluation returned wrong type
[    1.587802] _OSC request data:1 6 
[    1.590770] ACPI: Interpreter enabled
[    1.590773] ACPI: (supports S0 S4 S5)
[    1.590786] ACPI: Using IOAPIC for interrupt routing
[    1.592095] kworker/u:0 used greatest stack depth: 5472 bytes left
[    1.596808] ACPI: No dock devices found.
[    1.596811] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.596831] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-12])
[    1.596900] pci_root PNP0A03:00: host bridge window [mem 0xe7000000-0xfbffffff]
[    1.596903] pci_root PNP0A03:00: host bridge window [io  0x1000-0x4fff]
[    1.596905] pci_root PNP0A03:00: host bridge window [io  0x0000-0x03af]
[    1.596907] pci_root PNP0A03:00: host bridge window [io  0x03e0-0x0cf7]
[    1.596909] pci_root PNP0A03:00: host bridge window [io  0x0d00-0x0fff]
[    1.596911] pci_root PNP0A03:00: host bridge window [mem 0xfed00000-0xfed03fff]
[    1.596913] pci_root PNP0A03:00: host bridge window [mem 0xfed00000-0xfed44fff]
[    1.596915] pci_root PNP0A03:00: host bridge window [io  0x03b0-0x03bb]
[    1.596917] pci_root PNP0A03:00: host bridge window [io  0x03c0-0x03df]
[    1.596919] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.596922] pci_root PNP0A03:00: host bridge window expanded to [mem 0xfed00000-0xfed44fff]; [mem 0xfed00000-0xfed44fff] ignored
[    1.596939] pci 0000:00:00.0: [8086:3403] type 0 class 0x000600
[    1.596988] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.596992] pci 0000:00:00.0: PME# disabled
[    1.597016] pci 0000:00:01.0: [8086:3408] type 1 class 0x000604
[    1.597058] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.597062] pci 0000:00:01.0: PME# disabled
[    1.597082] pci 0000:00:02.0: [8086:3409] type 1 class 0x000604
[    1.597124] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    1.597128] pci 0000:00:02.0: PME# disabled
[    1.597148] pci 0000:00:03.0: [8086:340a] type 1 class 0x000604
[    1.597189] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.597192] pci 0000:00:03.0: PME# disabled
[    1.597214] pci 0000:00:07.0: [8086:340e] type 1 class 0x000604
[    1.597255] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.597258] pci 0000:00:07.0: PME# disabled
[    1.597278] pci 0000:00:08.0: [8086:340f] type 1 class 0x000604
[    1.597319] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    1.597322] pci 0000:00:08.0: PME# disabled
[    1.597342] pci 0000:00:09.0: [8086:3410] type 1 class 0x000604
[    1.597383] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    1.597386] pci 0000:00:09.0: PME# disabled
[    1.597406] pci 0000:00:0a.0: [8086:3411] type 1 class 0x000604
[    1.597447] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    1.597451] pci 0000:00:0a.0: PME# disabled
[    1.597469] pci 0000:00:0d.0: [8086:343a] type 0 class 0x000600
[    1.597519] pci 0000:00:0d.1: [8086:343b] type 0 class 0x000600
[    1.597567] pci 0000:00:0d.2: [8086:343c] type 0 class 0x000600
[    1.597614] pci 0000:00:0d.3: [8086:343d] type 0 class 0x000600
[    1.597661] pci 0000:00:0d.4: [8086:3418] type 0 class 0x000600
[    1.597708] pci 0000:00:0d.5: [8086:3419] type 0 class 0x000600
[    1.597755] pci 0000:00:0d.6: [8086:341a] type 0 class 0x000600
[    1.597802] pci 0000:00:0e.0: [8086:341c] type 0 class 0x000600
[    1.597849] pci 0000:00:0e.1: [8086:341d] type 0 class 0x000600
[    1.597898] pci 0000:00:0e.2: [8086:341e] type 0 class 0x000600
[    1.597945] pci 0000:00:0e.3: [8086:341f] type 0 class 0x000600
[    1.597995] pci 0000:00:0e.4: [8086:3439] type 0 class 0x000600
[    1.598044] pci 0000:00:14.0: [8086:342e] type 0 class 0x000800
[    1.598104] pci 0000:00:14.1: [8086:3422] type 0 class 0x000800
[    1.598161] pci 0000:00:14.2: [8086:3423] type 0 class 0x000800
[    1.598230] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
[    1.598282] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.598286] pci 0000:00:1c.0: PME# disabled
[    1.598317] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    1.598383] pci 0000:00:1d.0: reg 20: [io  0x1000-0x101f]
[    1.598449] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    1.598513] pci 0000:00:1d.1: reg 20: [io  0x1020-0x103f]
[    1.598577] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    1.598643] pci 0000:00:1d.2: reg 20: [io  0x1040-0x105f]
[    1.598706] pci 0000:00:1d.3: [8086:3a39] type 0 class 0x000c03
[    1.598771] pci 0000:00:1d.3: reg 20: [io  0x1060-0x107f]
[    1.598839] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    1.598859] pci 0000:00:1d.7: reg 10: [mem 0xf35f0000-0xf35f03ff]
[    1.598930] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.598934] pci 0000:00:1d.7: PME# disabled
[    1.598953] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    1.599010] pci 0000:00:1f.0: [8086:3a18] type 0 class 0x000601
[    1.599157] pci 0000:02:00.0: [14e4:1650] type 0 class 0x000200
[    1.599171] pci 0000:02:00.0: reg 10: [mem 0xfb000000-0xfb7fffff 64bit]
[    1.599183] pci 0000:02:00.0: reg 18: [mem 0xfa800000-0xfaffffff 64bit]
[    1.599202] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    1.599229] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    1.599233] pci 0000:02:00.0: PME# disabled
[    1.599260] pci 0000:02:00.1: [14e4:1650] type 0 class 0x000200
[    1.599274] pci 0000:02:00.1: reg 10: [mem 0xfa000000-0xfa7fffff 64bit]
[    1.599285] pci 0000:02:00.1: reg 18: [mem 0xf9800000-0xf9ffffff 64bit]
[    1.599305] pci 0000:02:00.1: reg 30: [mem 0x00000000-0x0000ffff pref]
[    1.599332] pci 0000:02:00.1: PME# supported from D0 D3hot D3cold
[    1.599335] pci 0000:02:00.1: PME# disabled
[    1.599357] pci 0000:00:01.0: PCI bridge to [bus 02-02]
[    1.599362] pci 0000:00:01.0:   bridge window [mem 0xf3800000-0xfb7fffff]
[    1.599399] pci 0000:00:02.0: PCI bridge to [bus 0d-0d]
[    1.599437] pci 0000:00:03.0: PCI bridge to [bus 03-05]
[    1.599481] pci 0000:00:07.0: PCI bridge to [bus 06-08]
[    1.599520] pci 0000:00:08.0: PCI bridge to [bus 11-11]
[    1.599569] pci 0000:09:00.0: [1166:0103] type 1 class 0x000604
[    1.599614] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
[    1.599617] pci 0000:09:00.0: PME# disabled
[    1.599633] pci 0000:00:09.0: PCI bridge to [bus 09-0b]
[    1.599638] pci 0000:00:09.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    1.599684] pci 0000:0a:04.0: [14e4:1679] type 0 class 0x000200
[    1.599702] pci 0000:0a:04.0: reg 10: [mem 0xfbcf0000-0xfbcfffff 64bit]
[    1.599715] pci 0000:0a:04.0: reg 18: [mem 0xfbce0000-0xfbceffff 64bit]
[    1.599737] pci 0000:0a:04.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.599760] pci 0000:0a:04.0: PME# supported from D3hot D3cold
[    1.599764] pci 0000:0a:04.0: PME# disabled
[    1.599787] pci 0000:0a:04.1: [14e4:1679] type 0 class 0x000200
[    1.599805] pci 0000:0a:04.1: reg 10: [mem 0xfbcd0000-0xfbcdffff 64bit]
[    1.599818] pci 0000:0a:04.1: reg 18: [mem 0xfbcc0000-0xfbccffff 64bit]
[    1.599840] pci 0000:0a:04.1: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.599863] pci 0000:0a:04.1: PME# supported from D3hot D3cold
[    1.599867] pci 0000:0a:04.1: PME# disabled
[    1.599907] pci 0000:09:00.0: PCI bridge to [bus 0a-0a]
[    1.599915] pci 0000:09:00.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    1.599956] pci 0000:00:0a.0: PCI bridge to [bus 12-12]
[    1.600021] pci 0000:0c:00.0: [103c:323a] type 0 class 0x000104
[    1.600043] pci 0000:0c:00.0: reg 10: [mem 0xfbe00000-0xfbffffff 64bit]
[    1.600061] pci 0000:0c:00.0: reg 18: [mem 0xfbdf0000-0xfbdf0fff 64bit]
[    1.600073] pci 0000:0c:00.0: reg 20: [io  0x4000-0x40ff]
[    1.600095] pci 0000:0c:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    1.600133] pci 0000:0c:00.0: PME# supported from D0
[    1.600138] pci 0000:0c:00.0: PME# disabled
[    1.600164] pci 0000:00:1c.0: PCI bridge to [bus 0c-0c]
[    1.600167] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    1.600171] pci 0000:00:1c.0:   bridge window [mem 0xfbd00000-0xfbffffff]
[    1.600209] pci 0000:01:03.0: [1002:515e] type 0 class 0x000300
[    1.600226] pci 0000:01:03.0: reg 10: [mem 0xe8000000-0xefffffff pref]
[    1.600237] pci 0000:01:03.0: reg 14: [io  0x3000-0x30ff]
[    1.600247] pci 0000:01:03.0: reg 18: [mem 0xf37f0000-0xf37fffff]
[    1.600282] pci 0000:01:03.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.600301] pci 0000:01:03.0: supports D1 D2
[    1.600318] pci 0000:01:04.0: [0e11:b203] type 0 class 0x000880
[    1.600335] pci 0000:01:04.0: reg 10: [io  0x2800-0x28ff]
[    1.600345] pci 0000:01:04.0: reg 14: [mem 0xf37e0000-0xf37e01ff]
[    1.600405] pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
[    1.600409] pci 0000:01:04.0: PME# disabled
[    1.600428] pci 0000:01:04.2: [0e11:b204] type 0 class 0x000880
[    1.600447] pci 0000:01:04.2: reg 10: [io  0x3400-0x34ff]
[    1.600458] pci 0000:01:04.2: reg 14: [mem 0xf37d0000-0xf37d07ff]
[    1.600470] pci 0000:01:04.2: reg 18: [mem 0xf37c0000-0xf37c3fff]
[    1.600481] pci 0000:01:04.2: reg 1c: [mem 0xf3700000-0xf377ffff]
[    1.600511] pci 0000:01:04.2: reg 30: [mem 0x00000000-0x0000ffff pref]
[    1.600532] pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
[    1.600536] pci 0000:01:04.2: PME# disabled
[    1.600556] pci 0000:01:04.4: [103c:3300] type 0 class 0x000c03
[    1.600612] pci 0000:01:04.4: reg 20: [io  0x3800-0x381f]
[    1.600651] pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
[    1.600656] pci 0000:01:04.4: PME# disabled
[    1.600677] pci 0000:01:04.6: [103c:3302] type 0 class 0x000c07
[    1.600694] pci 0000:01:04.6: reg 10: [mem 0xf36f0000-0xf36f00ff]
[    1.600762] pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
[    1.600767] pci 0000:01:04.6: PME# disabled
[    1.600807] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    1.600810] pci 0000:00:1e.0:   bridge window [io  0x2000-0x3fff]
[    1.600814] pci 0000:00:1e.0:   bridge window [mem 0xf3600000-0xf37fffff]
[    1.600820] pci 0000:00:1e.0:   bridge window [mem 0xe8000000-0xefffffff 64bit pref]
[    1.600822] pci 0000:00:1e.0:   bridge window [mem 0xe7000000-0xfbffffff] (subtractive decode)
[    1.600824] pci 0000:00:1e.0:   bridge window [io  0x1000-0x4fff] (subtractive decode)
[    1.600826] pci 0000:00:1e.0:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    1.600829] pci 0000:00:1e.0:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    1.600831] pci 0000:00:1e.0:   bridge window [io  0x0d00-0x0fff] (subtractive decode)
[    1.600833] pci 0000:00:1e.0:   bridge window [mem 0xfed00000-0xfed44fff] (subtractive decode)
[    1.600835] pci 0000:00:1e.0:   bridge window [io  0x03b0-0x03bb] (subtractive decode)
[    1.600837] pci 0000:00:1e.0:   bridge window [io  0x03c0-0x03df] (subtractive decode)
[    1.600839] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.600884] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.600985] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
[    1.601018] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IPT1._PRT]
[    1.601048] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT01._PRT]
[    1.601077] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT03._PRT]
[    1.601134] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT07._PRT]
[    1.601189] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT09._PRT]
[    1.601247]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.601251]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    1.601252] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.605547] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *7 10 11)
[    1.605582] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 *10 11)
[    1.605614] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 *10 11)
[    1.605647] ACPI: PCI Interrupt Link [LNKD] (IRQs *5 7 10 11)
[    1.605680] ACPI: PCI Interrupt Link [LNKE] (IRQs *5 7 10 11)
[    1.605712] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 *10 11)
[    1.605745] ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 *10 11)
[    1.605777] ACPI: PCI Interrupt Link [LNKH] (IRQs 5 *7 10 11)
[    1.605978] vgaarb: device added: PCI:0000:01:03.0,decodes=io+mem,owns=io+mem,locks=none
[    1.605982] vgaarb: loaded
[    1.605983] vgaarb: bridge control possible 0000:01:03.0
[    1.606142] SCSI subsystem initialized
[    1.606276] libata version 3.00 loaded.
[    1.606507] usbcore: registered new interface driver usbfs
[    1.606554] usbcore: registered new interface driver hub
[    1.606612] usbcore: registered new device driver usb
[    1.606916] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    1.606918] PCI: Using ACPI for IRQ routing
[    1.608108] PCI: Discovered peer bus 3e
[    1.608168] pci 0000:3e:00.0: [8086:2c40] type 0 class 0x000600
[    1.608187] pci 0000:3e:00.1: [8086:2c01] type 0 class 0x000600
[    1.608208] pci 0000:3e:02.0: [8086:2c10] type 0 class 0x000600
[    1.608225] pci 0000:3e:02.1: [8086:2c11] type 0 class 0x000600
[    1.608243] pci 0000:3e:02.4: [8086:2c14] type 0 class 0x000600
[    1.608263] pci 0000:3e:02.5: [8086:2c15] type 0 class 0x000600
[    1.608281] pci 0000:3e:03.0: [8086:2c18] type 0 class 0x000600
[    1.608299] pci 0000:3e:03.1: [8086:2c19] type 0 class 0x000600
[    1.608316] pci 0000:3e:03.2: [8086:2c1a] type 0 class 0x000600
[    1.608333] pci 0000:3e:03.4: [8086:2c1c] type 0 class 0x000600
[    1.608352] pci 0000:3e:04.0: [8086:2c20] type 0 class 0x000600
[    1.608369] pci 0000:3e:04.1: [8086:2c21] type 0 class 0x000600
[    1.608387] pci 0000:3e:04.2: [8086:2c22] type 0 class 0x000600
[    1.608406] pci 0000:3e:04.3: [8086:2c23] type 0 class 0x000600
[    1.608425] pci 0000:3e:05.0: [8086:2c28] type 0 class 0x000600
[    1.608443] pci 0000:3e:05.1: [8086:2c29] type 0 class 0x000600
[    1.608460] pci 0000:3e:05.2: [8086:2c2a] type 0 class 0x000600
[    1.608478] pci 0000:3e:05.3: [8086:2c2b] type 0 class 0x000600
[    1.608497] pci 0000:3e:06.0: [8086:2c30] type 0 class 0x000600
[    1.608514] pci 0000:3e:06.1: [8086:2c31] type 0 class 0x000600
[    1.608532] pci 0000:3e:06.2: [8086:2c32] type 0 class 0x000600
[    1.608551] pci 0000:3e:06.3: [8086:2c33] type 0 class 0x000600
[    1.609699] PCI: Discovered peer bus 3f
[    1.609754] pci 0000:3f:00.0: [8086:2c40] type 0 class 0x000600
[    1.609775] pci 0000:3f:00.1: [8086:2c01] type 0 class 0x000600
[    1.609798] pci 0000:3f:02.0: [8086:2c10] type 0 class 0x000600
[    1.609818] pci 0000:3f:02.1: [8086:2c11] type 0 class 0x000600
[    1.609838] pci 0000:3f:02.4: [8086:2c14] type 0 class 0x000600
[    1.609858] pci 0000:3f:02.5: [8086:2c15] type 0 class 0x000600
[    1.609878] pci 0000:3f:03.0: [8086:2c18] type 0 class 0x000600
[    1.609900] pci 0000:3f:03.1: [8086:2c19] type 0 class 0x000600
[    1.609919] pci 0000:3f:03.2: [8086:2c1a] type 0 class 0x000600
[    1.609939] pci 0000:3f:03.4: [8086:2c1c] type 0 class 0x000600
[    1.609964] pci 0000:3f:04.0: [8086:2c20] type 0 class 0x000600
[    1.609984] pci 0000:3f:04.1: [8086:2c21] type 0 class 0x000600
[    1.610004] pci 0000:3f:04.2: [8086:2c22] type 0 class 0x000600
[    1.610025] pci 0000:3f:04.3: [8086:2c23] type 0 class 0x000600
[    1.610046] pci 0000:3f:05.0: [8086:2c28] type 0 class 0x000600
[    1.610068] pci 0000:3f:05.1: [8086:2c29] type 0 class 0x000600
[    1.610088] pci 0000:3f:05.2: [8086:2c2a] type 0 class 0x000600
[    1.610111] pci 0000:3f:05.3: [8086:2c2b] type 0 class 0x000600
[    1.610133] pci 0000:3f:06.0: [8086:2c30] type 0 class 0x000600
[    1.610153] pci 0000:3f:06.1: [8086:2c31] type 0 class 0x000600
[    1.610173] pci 0000:3f:06.2: [8086:2c32] type 0 class 0x000600
[    1.610193] pci 0000:3f:06.3: [8086:2c33] type 0 class 0x000600
[    1.611352] PCI: pci_cache_line_size set to 64 bytes
[    1.611541] reserve RAM buffer: 000000000009f400 - 000000000009ffff 
[    1.611543] reserve RAM buffer: 00000000df61f000 - 00000000dfffffff 
[    1.611545] reserve RAM buffer: 00000000df62d000 - 00000000dfffffff 
[    1.611547] reserve RAM buffer: 000000011ffff000 - 000000011fffffff 
[    1.611883] cfg80211: Calling CRDA to update world regulatory domain
[    1.612023] NetLabel: Initializing
[    1.612026] NetLabel:  domain hash size = 128
[    1.612027] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.612042] NetLabel:  unlabeled traffic allowed by default
[    1.612127] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.612133] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.612137] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.628061] Switching to clocksource hpet
[    1.628948] Switched to NOHz mode on CPU #0
[    1.628991] Switched to NOHz mode on CPU #13
[    1.628994] Switched to NOHz mode on CPU #15
[    1.628998] Switched to NOHz mode on CPU #9
[    1.629004] Switched to NOHz mode on CPU #11
[    1.629065] Switched to NOHz mode on CPU #1
[    1.629070] Switched to NOHz mode on CPU #10
[    1.629076] Switched to NOHz mode on CPU #12
[    1.629086] Switched to NOHz mode on CPU #6
[    1.629092] Switched to NOHz mode on CPU #14
[    1.629098] Switched to NOHz mode on CPU #7
[    1.629103] Switched to NOHz mode on CPU #2
[    1.629107] Switched to NOHz mode on CPU #5
[    1.629112] Switched to NOHz mode on CPU #4
[    1.629117] Switched to NOHz mode on CPU #3
[    1.629121] Switched to NOHz mode on CPU #8
[    1.631243] pnp: PnP ACPI init
[    1.631251] ACPI: bus type pnp registered
[    1.631281] pnp 00:00: [bus 00-12]
[    1.631284] pnp 00:00: [mem 0xe7000000-0xfbffffff window]
[    1.631286] pnp 00:00: [io  0x1000-0x4fff window]
[    1.631288] pnp 00:00: [io  0x0000-0x03af window]
[    1.631290] pnp 00:00: [io  0x03e0-0x0cf7 window]
[    1.631291] pnp 00:00: [io  0x0d00-0x0fff window]
[    1.631293] pnp 00:00: [mem 0xfed00000-0xfed03fff window]
[    1.631295] pnp 00:00: [mem 0xfed00000-0xfed44fff window]
[    1.631297] pnp 00:00: [io  0x03b0-0x03bb window]
[    1.631299] pnp 00:00: [io  0x03c0-0x03df window]
[    1.631301] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.631384] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 PNP0a08 (active)
[    1.631501] pnp 00:01: [io  0x0070-0x0077]
[    1.631503] pnp 00:01: [io  0x0408-0x040f]
[    1.631505] pnp 00:01: [io  0x04d0-0x04d1]
[    1.631507] pnp 00:01: [io  0x0020-0x003f]
[    1.631508] pnp 00:01: [io  0x00a0-0x00bf]
[    1.631510] pnp 00:01: [io  0x0090-0x009f]
[    1.631511] pnp 00:01: [io  0x0050-0x0053]
[    1.631513] pnp 00:01: [io  0x0700-0x071f]
[    1.631514] pnp 00:01: [io  0x0880-0x08ff]
[    1.631516] pnp 00:01: [io  0x0900-0x097f]
[    1.631517] pnp 00:01: [io  0x0010-0x001f]
[    1.631519] pnp 00:01: [io  0x0c80-0x0c83]
[    1.631520] pnp 00:01: [io  0x0cd4-0x0cd7]
[    1.631522] pnp 00:01: [io  0x0f50-0x0f58]
[    1.631524] pnp 00:01: [io  0x00f0]
[    1.631525] pnp 00:01: [io  0x0ca0-0x0ca1]
[    1.631527] pnp 00:01: [io  0x0ca4-0x0ca5]
[    1.631528] pnp 00:01: [mem 0xe0000000-0xe3ffffff]
[    1.631530] pnp 00:01: [mem 0xfe000000-0xfebfffff]
[    1.631532] pnp 00:01: [mem 0xe7ffe000-0xe7ffffff]
[    1.631534] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    1.631536] pnp 00:01: [io  0x03f8-0x03ff]
[    1.631670] system 00:01: [io  0x0408-0x040f] has been reserved
[    1.631672] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    1.631674] system 00:01: [io  0x0700-0x071f] has been reserved
[    1.631677] system 00:01: [io  0x0880-0x08ff] has been reserved
[    1.631679] system 00:01: [io  0x0900-0x097f] has been reserved
[    1.631681] system 00:01: [io  0x0c80-0x0c83] has been reserved
[    1.631683] system 00:01: [io  0x0cd4-0x0cd7] has been reserved
[    1.631685] system 00:01: [io  0x0f50-0x0f58] has been reserved
[    1.631688] system 00:01: [io  0x0ca0-0x0ca1] has been reserved
[    1.631690] system 00:01: [io  0x0ca4-0x0ca5] has been reserved
[    1.631692] system 00:01: [io  0x03f8-0x03ff] has been reserved
[    1.631695] system 00:01: [mem 0xe0000000-0xe3ffffff] has been reserved
[    1.631697] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    1.631699] system 00:01: [mem 0xe7ffe000-0xe7ffffff] has been reserved
[    1.631702] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.631712] pnp 00:02: [io  0x0ca2-0x0ca3]
[    1.631783] pnp 00:02: Plug and Play ACPI device, IDs IPI0001 (active)
[    1.631805] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.631882] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.631892] pnp 00:04: [dma 7]
[    1.631894] pnp 00:04: [io  0x0000-0x000f]
[    1.631895] pnp 00:04: [io  0x0080-0x008f]
[    1.631900] pnp 00:04: [io  0x00c0-0x00df]
[    1.631972] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.631981] pnp 00:05: [io  0x0061]
[    1.632052] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.632062] pnp 00:06: [io  0x0060]
[    1.632064] pnp 00:06: [io  0x0064]
[    1.632072] pnp 00:06: [irq 1]
[    1.632144] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.632157] pnp 00:07: [irq 12]
[    1.632230] pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    1.632241] pnp 00:08: [io  0x002e-0x002f]
[    1.632242] pnp 00:08: [io  0x0620-0x065f]
[    1.632244] pnp 00:08: [io  0x0680-0x069f]
[    1.632246] pnp 00:08: [io  0x0600-0x061f]
[    1.632247] pnp 00:08: [io  0x0660-0x067f]
[    1.632249] pnp 00:08: [io  0x0300-0x031f]
[    1.632333] pnp 00:08: Plug and Play ACPI device, IDs PNP0a06 (active)
[    1.632434] pnp 00:09: [irq 3]
[    1.632436] pnp 00:09: [io  0x02f8-0x02ff]
[    1.632575] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    1.632615] pnp 00:0a: [io  0x0070-0x0071]
[    1.632691] pnp 00:0a: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.632815] pnp: PnP ACPI: found 11 devices
[    1.632817] ACPI: ACPI bus type pnp unregistered
[    1.641608] PCI: max bus depth: 2 pci_try_num: 3
[    1.641670] pci 0000:00:01.0: BAR 15: assigned [mem 0xe7000000-0xe70fffff pref]
[    1.641673] pci 0000:00:09.0: BAR 15: assigned [mem 0xe7100000-0xe71fffff pref]
[    1.641676] pci 0000:00:1c.0: BAR 15: assigned [mem 0xe7200000-0xe72fffff pref]
[    1.641679] pci 0000:02:00.0: BAR 6: assigned [mem 0xe7000000-0xe700ffff pref]
[    1.641681] pci 0000:02:00.1: BAR 6: assigned [mem 0xe7010000-0xe701ffff pref]
[    1.641684] pci 0000:00:01.0: PCI bridge to [bus 02-02]
[    1.641688] pci 0000:00:01.0:   bridge window [mem 0xf3800000-0xfb7fffff]
[    1.641691] pci 0000:00:01.0:   bridge window [mem 0xe7000000-0xe70fffff pref]
[    1.641696] pci 0000:00:02.0: PCI bridge to [bus 0d-0d]
[    1.641704] pci 0000:00:03.0: PCI bridge to [bus 03-05]
[    1.641712] pci 0000:00:07.0: PCI bridge to [bus 06-08]
[    1.641720] pci 0000:00:08.0: PCI bridge to [bus 11-11]
[    1.641728] pci 0000:09:00.0: BAR 15: assigned [mem 0xe7100000-0xe71fffff pref]
[    1.641731] pci 0000:0a:04.0: BAR 6: assigned [mem 0xe7100000-0xe711ffff pref]
[    1.641733] pci 0000:0a:04.1: BAR 6: assigned [mem 0xe7120000-0xe713ffff pref]
[    1.641735] pci 0000:09:00.0: PCI bridge to [bus 0a-0a]
[    1.641740] pci 0000:09:00.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    1.641743] pci 0000:09:00.0:   bridge window [mem 0xe7100000-0xe71fffff pref]
[    1.641749] pci 0000:00:09.0: PCI bridge to [bus 09-0b]
[    1.641752] pci 0000:00:09.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    1.641756] pci 0000:00:09.0:   bridge window [mem 0xe7100000-0xe71fffff pref]
[    1.641760] pci 0000:00:0a.0: PCI bridge to [bus 12-12]
[    1.641769] pci 0000:0c:00.0: BAR 6: assigned [mem 0xe7200000-0xe727ffff pref]
[    1.641771] pci 0000:00:1c.0: PCI bridge to [bus 0c-0c]
[    1.641774] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    1.641778] pci 0000:00:1c.0:   bridge window [mem 0xfbd00000-0xfbffffff]
[    1.641782] pci 0000:00:1c.0:   bridge window [mem 0xe7200000-0xe72fffff pref]
[    1.641789] pci 0000:01:03.0: BAR 6: assigned [mem 0xf3600000-0xf361ffff pref]
[    1.641791] pci 0000:01:04.2: BAR 6: assigned [mem 0xf3620000-0xf362ffff pref]
[    1.641793] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    1.641796] pci 0000:00:1e.0:   bridge window [io  0x2000-0x3fff]
[    1.641801] pci 0000:00:1e.0:   bridge window [mem 0xf3600000-0xf37fffff]
[    1.641804] pci 0000:00:1e.0:   bridge window [mem 0xe8000000-0xefffffff 64bit pref]
[    1.641816] pci 0000:00:01.0: setting latency timer to 64
[    1.641822] pci 0000:00:02.0: setting latency timer to 64
[    1.641827] pci 0000:00:03.0: setting latency timer to 64
[    1.641833] pci 0000:00:07.0: setting latency timer to 64
[    1.641838] pci 0000:00:08.0: setting latency timer to 64
[    1.641843] pci 0000:00:09.0: setting latency timer to 64
[    1.641850] pci 0000:09:00.0: setting latency timer to 64
[    1.641855] pci 0000:00:0a.0: setting latency timer to 64
[    1.641869] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.641873] pci 0000:00:1c.0: setting latency timer to 64
[    1.641879] pci 0000:00:1e.0: setting latency timer to 64
[    1.641883] pci_bus 0000:00: resource 4 [mem 0xe7000000-0xfbffffff]
[    1.641885] pci_bus 0000:00: resource 5 [io  0x1000-0x4fff]
[    1.641887] pci_bus 0000:00: resource 6 [io  0x0000-0x03af]
[    1.641889] pci_bus 0000:00: resource 7 [io  0x03e0-0x0cf7]
[    1.641890] pci_bus 0000:00: resource 8 [io  0x0d00-0x0fff]
[    1.641892] pci_bus 0000:00: resource 9 [mem 0xfed00000-0xfed44fff]
[    1.641894] pci_bus 0000:00: resource 10 [io  0x03b0-0x03bb]
[    1.641896] pci_bus 0000:00: resource 11 [io  0x03c0-0x03df]
[    1.641898] pci_bus 0000:00: resource 12 [mem 0x000a0000-0x000bffff]
[    1.641900] pci_bus 0000:02: resource 1 [mem 0xf3800000-0xfb7fffff]
[    1.641902] pci_bus 0000:02: resource 2 [mem 0xe7000000-0xe70fffff pref]
[    1.641905] pci_bus 0000:09: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    1.641907] pci_bus 0000:09: resource 2 [mem 0xe7100000-0xe71fffff pref]
[    1.641909] pci_bus 0000:0a: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    1.641911] pci_bus 0000:0a: resource 2 [mem 0xe7100000-0xe71fffff pref]
[    1.641913] pci_bus 0000:0c: resource 0 [io  0x4000-0x4fff]
[    1.641915] pci_bus 0000:0c: resource 1 [mem 0xfbd00000-0xfbffffff]
[    1.641917] pci_bus 0000:0c: resource 2 [mem 0xe7200000-0xe72fffff pref]
[    1.641919] pci_bus 0000:01: resource 0 [io  0x2000-0x3fff]
[    1.641921] pci_bus 0000:01: resource 1 [mem 0xf3600000-0xf37fffff]
[    1.641923] pci_bus 0000:01: resource 2 [mem 0xe8000000-0xefffffff 64bit pref]
[    1.641925] pci_bus 0000:01: resource 4 [mem 0xe7000000-0xfbffffff]
[    1.641927] pci_bus 0000:01: resource 5 [io  0x1000-0x4fff]
[    1.641929] pci_bus 0000:01: resource 6 [io  0x0000-0x03af]
[    1.641931] pci_bus 0000:01: resource 7 [io  0x03e0-0x0cf7]
[    1.641933] pci_bus 0000:01: resource 8 [io  0x0d00-0x0fff]
[    1.641934] pci_bus 0000:01: resource 9 [mem 0xfed00000-0xfed44fff]
[    1.641936] pci_bus 0000:01: resource 10 [io  0x03b0-0x03bb]
[    1.641938] pci_bus 0000:01: resource 11 [io  0x03c0-0x03df]
[    1.641940] pci_bus 0000:01: resource 12 [mem 0x000a0000-0x000bffff]
[    1.641942] pci_bus 0000:3e: resource 0 [io  0x0000-0xffff]
[    1.641944] pci_bus 0000:3e: resource 1 [mem 0x00000000-0xffffffffff]
[    1.641947] pci_bus 0000:3f: resource 0 [io  0x0000-0xffff]
[    1.641949] pci_bus 0000:3f: resource 1 [mem 0x00000000-0xffffffffff]
[    1.641984] NET: Registered protocol family 2
[    1.642116] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.643074] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.644883] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    1.645580] TCP: Hash tables configured (established 524288 bind 65536)
[    1.645583] TCP reno registered
[    1.645602] UDP hash table entries: 2048 (order: 5, 196608 bytes)
[    1.645699] UDP-Lite hash table entries: 2048 (order: 5, 196608 bytes)
[    1.645970] NET: Registered protocol family 1
[    1.646102] RPC: Registered named UNIX socket transport module.
[    1.646105] RPC: Registered udp transport module.
[    1.646106] RPC: Registered tcp transport module.
[    1.646107] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.646166] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x043b
[    1.646168] pci 0000:00:1d.0: Performing full reset
[    1.646187] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    1.646189] pci 0000:00:1d.1: Performing full reset
[    1.646207] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    1.646208] pci 0000:00:1d.2: Performing full reset
[    1.646225] pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x0010
[    1.646227] pci 0000:00:1d.3: Performing full reset
[    1.646279] pci 0000:00:1d.7: EHCI: BIOS handoff
[    1.657293] pci 0000:01:03.0: Boot video device
[    1.657305] pci 0000:01:04.4: uhci_check_and_reset_hc: legsup = 0x0010
[    1.657306] pci 0000:01:04.4: Performing full reset
[    1.657988] PCI: CLS 64 bytes, default 64
[    1.658048] Trying to unpack rootfs image as initramfs...
[    1.695598] Freeing initrd memory: 2468k freed
[    1.695902] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.695905] Placing 64MB software IO TLB between ffff8800db619000 - ffff8800df619000
[    1.695907] software IO TLB at phys 0xdb619000 - 0xdf619000
[    1.702251] microcode: CPU0 sig=0x106a5, pf=0x1, revision=0x16
[    1.702258] microcode: CPU1 sig=0x106a5, pf=0x1, revision=0x16
[    1.702265] microcode: CPU2 sig=0x106a5, pf=0x1, revision=0x16
[    1.702272] microcode: CPU3 sig=0x106a5, pf=0x1, revision=0x16
[    1.702280] microcode: CPU4 sig=0x106a5, pf=0x1, revision=0x16
[    1.702287] microcode: CPU5 sig=0x106a5, pf=0x1, revision=0x16
[    1.702295] microcode: CPU6 sig=0x106a5, pf=0x1, revision=0x16
[    1.702301] microcode: CPU7 sig=0x106a5, pf=0x1, revision=0x16
[    1.702312] microcode: CPU8 sig=0x106a5, pf=0x1, revision=0x16
[    1.702320] microcode: CPU9 sig=0x106a5, pf=0x1, revision=0x16
[    1.702327] microcode: CPU10 sig=0x106a5, pf=0x1, revision=0x16
[    1.702333] microcode: CPU11 sig=0x106a5, pf=0x1, revision=0x16
[    1.702340] microcode: CPU12 sig=0x106a5, pf=0x1, revision=0x16
[    1.702346] microcode: CPU13 sig=0x106a5, pf=0x1, revision=0x16
[    1.702353] microcode: CPU14 sig=0x106a5, pf=0x1, revision=0x16
[    1.702360] microcode: CPU15 sig=0x106a5, pf=0x1, revision=0x16
[    1.702416] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.702742] audit: initializing netlink socket (disabled)
[    1.702759] type=2000 audit(1315629086.304:1): initialized
[    1.730386] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.734770] VFS: Disk quotas dquot_6.5.2
[    1.734892] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.736155] msgmni has been set to 7878
[    1.736314] SELinux:  Registering netfilter hooks
[    1.736854] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.736857] io scheduler noop registered
[    1.736858] io scheduler deadline registered
[    1.736939] io scheduler cfq registered (default)
[    1.737396] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.737442] pcieport 0000:00:1c.0: irq 64 for MSI/MSI-X
[    1.737690] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.737949] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.737955] ACPI: Power Button [PWRF]
[    1.738145] ACPI: acpi_idle registered with cpuidle
[    1.738264] Monitor-Mwait will be used to enter C-1 state
[    1.741356] thermal LNXTHERM:00: registered as thermal_zone0
[    1.741359] ACPI: Thermal Zone [THM0] (8 C)
[    1.741573] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.005210] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.278081] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.339644] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.348279] Non-volatile memory driver v1.3
[    2.348281] Linux agpgart interface v0.103
[    2.348510] ipmi message handler version 39.2
[    2.348567] [drm] Initialized drm 1.1.0 20060810
[    2.348569] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    2.350948] brd: module loaded
[    2.352184] loop: module loaded
[    2.352293] HP HPSA Driver (v 2.0.2-1)
[    2.352306] hpsa 0000:0c:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.352324] hpsa 0000:0c:00.0: MSIX
[    2.352398] hpsa 0000:0c:00.0: irq 65 for MSI/MSI-X
[    2.352405] hpsa 0000:0c:00.0: irq 66 for MSI/MSI-X
[    2.352412] hpsa 0000:0c:00.0: irq 67 for MSI/MSI-X
[    2.352419] hpsa 0000:0c:00.0: irq 68 for MSI/MSI-X
[    2.371926] hpsa 0000:0c:00.0: hpsa0: <0x323a> at IRQ 65 using DAC
[    2.392754] scsi0 : hpsa
[    2.394010] hpsa 0000:0c:00.0: RAID              device c0b0t0l0 added.
[    2.394012] hpsa 0000:0c:00.0: Direct-Access     device c0b0t0l1 added.
[    2.394360] scsi 0:0:0:0: RAID              HP       P410i            5.06 PQ: 0 ANSI: 5
[    2.394888] scsi 0:0:0:1: Direct-Access     HP       LOGICAL VOLUME   5.06 PQ: 0 ANSI: 5
[    2.395455] scsi 0:0:0:0: Attached scsi generic sg0 type 12
[    2.395508] sd 0:0:0:1: [sda] 488327040 512-byte logical blocks: (250 GB/232 GiB)
[    2.395524] sd 0:0:0:1: Attached scsi generic sg1 type 0
[    2.395888] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    2.395901] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.395973] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    2.395975] e100: Copyright(c) 1999-2006 Intel Corporation
[    2.396048] sd 0:0:0:1: [sda] Write Protect is off
[    2.396051] sd 0:0:0:1: [sda] Mode Sense: 6b 00 00 08
[    2.396079] tg3.c:v3.119 (May 18, 2011)
[    2.396095] tg3 0000:0a:04.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
[    2.396296] sd 0:0:0:1: [sda] Write cache: disabled, read cache: disabled, doesn't support DPO or FUA
[    2.408493]  sda: sda1 sda2 < sda5 sda6 >
[    2.409906] sd 0:0:0:1: [sda] Attached SCSI disk
[    2.418777] tg3 0000:0a:04.0: eth0: Tigon3 [partno(N/A) rev 9003] (PCIX:133MHz:64-bit) MAC address f4:ce:46:87:96:ce
[    2.418781] tg3 0000:0a:04.0: eth0: attached PHY is 5714 (1000Base-SX Ethernet) (WireSpeed[0], EEE[0])
[    2.418784] tg3 0000:0a:04.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    2.418786] tg3 0000:0a:04.0: eth0: dma_rwctrl[76148000] dma_mask[40-bit]
[    2.418830] tg3 0000:0a:04.1: PCI INT B -> GSI 42 (level, low) -> IRQ 42
[    2.442778] tg3 0000:0a:04.1: eth1: Tigon3 [partno(N/A) rev 9003] (PCIX:133MHz:64-bit) MAC address f4:ce:46:87:96:cf
[    2.442781] tg3 0000:0a:04.1: eth1: attached PHY is 5714 (1000Base-SX Ethernet) (WireSpeed[0], EEE[0])
[    2.442784] tg3 0000:0a:04.1: eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    2.442786] tg3 0000:0a:04.1: eth1: dma_rwctrl[76148000] dma_mask[40-bit]
[    2.442878] sky2: driver version 1.29
[    2.443078] console [netcon0] enabled
[    2.443080] netconsole: network logging started
[    2.443280] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.443282] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    2.443308] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.443322] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.443325] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.443350] drivers/usb/core/inode.c: creating file 'devices'
[    2.443354] drivers/usb/core/inode.c: creating file '001'
[    2.443423] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.443431] ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
[    2.443435] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    2.443455] ehci_hcd 0000:00:1d.7: debug port 1
[    2.443459] ehci_hcd 0000:00:1d.7: reset command 0080012 (park)=0 ithresh=8 Periodic period=1024 Reset HALT
[    2.447340] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    2.447342] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    2.447355] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf35f0000
[    2.447359] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    2.451242] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    2.456871] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.456899] usb usb1: default language 0x0409
[    2.456905] usb usb1: udev 1, busnum 1, minor = 0
[    2.456906] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.456909] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.456911] usb usb1: Product: EHCI Host Controller
[    2.456913] usb usb1: Manufacturer: Linux 3.1.0-rc5+ ehci_hcd
[    2.456914] usb usb1: SerialNumber: 0000:00:1d.7
[    2.457002] usb usb1: usb_probe_device
[    2.457005] usb usb1: configuration #1 chosen from 1 choice
[    2.457012] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    2.457071] hub 1-0:1.0: usb_probe_interface
[    2.457073] hub 1-0:1.0: usb_probe_interface - got id
[    2.457075] hub 1-0:1.0: USB hub found
[    2.457080] hub 1-0:1.0: 8 ports detected
[    2.457082] hub 1-0:1.0: standalone hub
[    2.457083] hub 1-0:1.0: no power switching (usb 1.0)
[    2.457085] hub 1-0:1.0: individual port over-current protection
[    2.457087] hub 1-0:1.0: power on to power good time: 20ms
[    2.457091] hub 1-0:1.0: local power source is good
[    2.457093] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    2.457123] drivers/usb/core/inode.c: creating file '001'
[    2.457233] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.457235] ohci_hcd: block sizes: ed 80 td 96
[    2.457297] uhci_hcd: USB Universal Host Controller Interface driver
[    2.457322] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.457328] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.457331] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.457335] drivers/usb/core/inode.c: creating file '002'
[    2.457400] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.457407] uhci_hcd 0000:00:1d.0: detected 2 ports
[    2.457411] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    2.457413] uhci_hcd 0000:00:1d.0: Performing full reset
[    2.457430] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001000
[    2.457457] usb usb2: default language 0x0409
[    2.457462] usb usb2: udev 1, busnum 2, minor = 128
[    2.457464] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.457466] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.457468] usb usb2: Product: UHCI Host Controller
[    2.457470] usb usb2: Manufacturer: Linux 3.1.0-rc5+ uhci_hcd
[    2.457472] usb usb2: SerialNumber: 0000:00:1d.0
[    2.457551] usb usb2: usb_probe_device
[    2.457553] usb usb2: configuration #1 chosen from 1 choice
[    2.457558] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    2.457615] hub 2-0:1.0: usb_probe_interface
[    2.457617] hub 2-0:1.0: usb_probe_interface - got id
[    2.457618] hub 2-0:1.0: USB hub found
[    2.457623] hub 2-0:1.0: 2 ports detected
[    2.457625] hub 2-0:1.0: standalone hub
[    2.457626] hub 2-0:1.0: no power switching (usb 1.0)
[    2.457627] hub 2-0:1.0: individual port over-current protection
[    2.457629] hub 2-0:1.0: power on to power good time: 2ms
[    2.457633] hub 2-0:1.0: local power source is good
[    2.457634] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    2.457650] drivers/usb/core/inode.c: creating file '001'
[    2.457684] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    2.457722] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 23 (level, low) -> IRQ 23
[    2.457727] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.457730] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.457735] drivers/usb/core/inode.c: creating file '003'
[    2.457805] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.457812] uhci_hcd 0000:00:1d.1: detected 2 ports
[    2.457816] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    2.457818] uhci_hcd 0000:00:1d.1: Performing full reset
[    2.457842] uhci_hcd 0000:00:1d.1: irq 23, io base 0x00001020
[    2.457877] usb usb3: default language 0x0409
[    2.457883] usb usb3: udev 1, busnum 3, minor = 256
[    2.457885] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.457887] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.457889] usb usb3: Product: UHCI Host Controller
[    2.457890] usb usb3: Manufacturer: Linux 3.1.0-rc5+ uhci_hcd
[    2.457892] usb usb3: SerialNumber: 0000:00:1d.1
[    2.457975] usb usb3: usb_probe_device
[    2.457977] usb usb3: configuration #1 chosen from 1 choice
[    2.457983] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    2.458039] hub 3-0:1.0: usb_probe_interface
[    2.458041] hub 3-0:1.0: usb_probe_interface - got id
[    2.458043] hub 3-0:1.0: USB hub found
[    2.458046] hub 3-0:1.0: 2 ports detected
[    2.458048] hub 3-0:1.0: standalone hub
[    2.458049] hub 3-0:1.0: no power switching (usb 1.0)
[    2.458051] hub 3-0:1.0: individual port over-current protection
[    2.458052] hub 3-0:1.0: power on to power good time: 2ms
[    2.458056] hub 3-0:1.0: local power source is good
[    2.458058] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    2.458070] drivers/usb/core/inode.c: creating file '001'
[    2.458104] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    2.458142] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.458148] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.458151] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.458155] drivers/usb/core/inode.c: creating file '004'
[    2.458220] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.458227] uhci_hcd 0000:00:1d.2: detected 2 ports
[    2.458231] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    2.458233] uhci_hcd 0000:00:1d.2: Performing full reset
[    2.458256] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001040
[    2.458284] usb usb4: default language 0x0409
[    2.458290] usb usb4: udev 1, busnum 4, minor = 384
[    2.458292] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.458294] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.458296] usb usb4: Product: UHCI Host Controller
[    2.458297] usb usb4: Manufacturer: Linux 3.1.0-rc5+ uhci_hcd
[    2.458299] usb usb4: SerialNumber: 0000:00:1d.2
[    2.458382] usb usb4: usb_probe_device
[    2.458384] usb usb4: configuration #1 chosen from 1 choice
[    2.458389] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    2.458446] hub 4-0:1.0: usb_probe_interface
[    2.458448] hub 4-0:1.0: usb_probe_interface - got id
[    2.458450] hub 4-0:1.0: USB hub found
[    2.458453] hub 4-0:1.0: 2 ports detected
[    2.458455] hub 4-0:1.0: standalone hub
[    2.458456] hub 4-0:1.0: no power switching (usb 1.0)
[    2.458458] hub 4-0:1.0: individual port over-current protection
[    2.458460] hub 4-0:1.0: power on to power good time: 2ms
[    2.458463] hub 4-0:1.0: local power source is good
[    2.458465] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    2.458477] drivers/usb/core/inode.c: creating file '001'
[    2.458512] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    2.458543] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    2.458548] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.458551] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.458558] drivers/usb/core/inode.c: creating file '005'
[    2.458639] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.458646] uhci_hcd 0000:00:1d.3: detected 2 ports
[    2.458650] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
[    2.458652] uhci_hcd 0000:00:1d.3: Performing full reset
[    2.458668] uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001060
[    2.458694] usb usb5: default language 0x0409
[    2.458699] usb usb5: udev 1, busnum 5, minor = 512
[    2.458701] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.458703] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.458705] usb usb5: Product: UHCI Host Controller
[    2.458707] usb usb5: Manufacturer: Linux 3.1.0-rc5+ uhci_hcd
[    2.458709] usb usb5: SerialNumber: 0000:00:1d.3
[    2.458787] usb usb5: usb_probe_device
[    2.458789] usb usb5: configuration #1 chosen from 1 choice
[    2.458795] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    2.458852] hub 5-0:1.0: usb_probe_interface
[    2.458854] hub 5-0:1.0: usb_probe_interface - got id
[    2.458855] hub 5-0:1.0: USB hub found
[    2.458868] hub 5-0:1.0: 2 ports detected
[    2.458870] hub 5-0:1.0: standalone hub
[    2.458871] hub 5-0:1.0: no power switching (usb 1.0)
[    2.458873] hub 5-0:1.0: individual port over-current protection
[    2.458875] hub 5-0:1.0: power on to power good time: 2ms
[    2.458878] hub 5-0:1.0: local power source is good
[    2.458880] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    2.458892] drivers/usb/core/inode.c: creating file '001'
[    2.458923] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.3
[    2.458958] uhci_hcd 0000:01:04.4: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    2.458964] uhci_hcd 0000:01:04.4: UHCI Host Controller
[    2.458968] drivers/usb/core/inode.c: creating file '006'
[    2.459038] uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 6
[    2.459051] uhci_hcd 0000:01:04.4: detected 8 ports
[    2.459053] uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
[    2.459057] uhci_hcd 0000:01:04.4: uhci_check_and_reset_hc: cmd = 0x0000
[    2.459059] uhci_hcd 0000:01:04.4: Performing full reset
[    2.459679] uhci_hcd 0000:01:04.4: supports USB remote wakeup
[    2.459684] uhci_hcd 0000:01:04.4: irq 22, io base 0x00003800
[    2.459761] usb usb6: default language 0x0409
[    2.459766] usb usb6: udev 1, busnum 6, minor = 640
[    2.459768] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.459770] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.459772] usb usb6: Product: UHCI Host Controller
[    2.459773] usb usb6: Manufacturer: Linux 3.1.0-rc5+ uhci_hcd
[    2.459775] usb usb6: SerialNumber: 0000:01:04.4
[    2.459853] usb usb6: usb_probe_device
[    2.459855] usb usb6: configuration #1 chosen from 1 choice
[    2.459871] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    2.459933] hub 6-0:1.0: usb_probe_interface
[    2.459935] hub 6-0:1.0: usb_probe_interface - got id
[    2.459937] hub 6-0:1.0: USB hub found
[    2.459940] hub 6-0:1.0: 2 ports detected
[    2.459942] hub 6-0:1.0: standalone hub
[    2.459943] hub 6-0:1.0: no power switching (usb 1.0)
[    2.459945] hub 6-0:1.0: individual port over-current protection
[    2.459946] hub 6-0:1.0: power on to power good time: 2ms
[    2.459950] hub 6-0:1.0: local power source is good
[    2.459952] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    2.459963] drivers/usb/core/inode.c: creating file '001'
[    2.460129] usbcore: registered new interface driver usblp
[    2.460131] Initializing USB Mass Storage driver...
[    2.460197] usbcore: registered new interface driver usb-storage
[    2.460199] USB Mass Storage support registered.
[    2.460265] usbcore: registered new interface driver libusual
[    2.460382] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    2.461866] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.461891] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.462067] mousedev: PS/2 mouse device common for all mice
[    2.462301] rtc_cmos 00:0a: RTC can wake from S4
[    2.462434] rtc_cmos 00:0a: rtc core: registered rtc_cmos as rtc0
[    2.462459] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    2.462748] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    2.462834] cpuidle: using governor ladder
[    2.462836] cpuidle: using governor menu
[    2.462838] EFI Variables Facility v0.08 2004-May-17
[    2.464060] usbcore: registered new interface driver usbhid
[    2.464062] usbhid: USB HID core driver
[    2.465496] ALSA device list:
[    2.465498]   No soundcards found.
[    2.465554] Netfilter messages via NETLINK v0.30.
[    2.465843] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.466087] TCP cubic registered
[    2.466089] Initializing XFRM netlink socket
[    2.466387] NET: Registered protocol family 10
[    2.467393] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.467726] IPv6 over IPv4 tunneling driver
[    2.468328] NET: Registered protocol family 17
[    2.468339] Registering the dns_resolver key type
[    2.468524] PM: Hibernation image not present or could not be loaded.
[    2.468536] registered taskstats version 1
[    2.469122]   Magic number: 11:667:514
[    2.470578] Freeing unused kernel memory: 856k freed
[    2.470765] Write protecting the kernel read-only data: 12288k
[    2.473367] Freeing unused kernel memory: 892k freed
[    2.476681] Freeing unused kernel memory: 1128k freed
[    2.517217] Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2x 1.70.00-0 (2011/06/13)
[    2.517351] bnx2x 0000:02:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    2.517362] bnx2x 0000:02:00.0: setting latency timer to 64
[    2.518651] bnx2x 0000:02:00.0: part number 412F4E-0-0-0
[    2.519643] bnx2x 0000:02:00.0: irq 69 for MSI/MSI-X
[    2.519655] bnx2x 0000:02:00.0: irq 70 for MSI/MSI-X
[    2.519668] bnx2x 0000:02:00.0: irq 71 for MSI/MSI-X
[    2.519679] bnx2x 0000:02:00.0: irq 72 for MSI/MSI-X
[    2.519693] bnx2x 0000:02:00.0: irq 73 for MSI/MSI-X
[    2.519704] bnx2x 0000:02:00.0: irq 74 for MSI/MSI-X
[    2.519719] bnx2x 0000:02:00.0: irq 75 for MSI/MSI-X
[    2.519732] bnx2x 0000:02:00.0: irq 76 for MSI/MSI-X
[    2.519747] bnx2x 0000:02:00.0: irq 77 for MSI/MSI-X
[    2.519761] bnx2x 0000:02:00.0: irq 78 for MSI/MSI-X
[    2.519773] bnx2x 0000:02:00.0: irq 79 for MSI/MSI-X
[    2.519784] bnx2x 0000:02:00.0: irq 80 for MSI/MSI-X
[    2.519794] bnx2x 0000:02:00.0: irq 81 for MSI/MSI-X
[    2.519803] bnx2x 0000:02:00.0: irq 82 for MSI/MSI-X
[    2.519812] bnx2x 0000:02:00.0: irq 83 for MSI/MSI-X
[    2.519823] bnx2x 0000:02:00.0: irq 84 for MSI/MSI-X
[    2.519861] bnx2x 0000:02:00.0: irq 85 for MSI/MSI-X
[    2.522373] bnx2x 0000:02:00.0: eth2: Broadcom NetXtreme II BCM57711E 10 Gigabit PCIe (A0) PCI-E x4 5GHz (Gen2) found at mem fb000000, IRQ 28, node addr f4:ce:46:bb:32:d0
[    2.522420] bnx2x 0000:02:00.1: PCI INT D -> GSI 47 (level, low) -> IRQ 47
[    2.522427] bnx2x 0000:02:00.1: setting latency timer to 64
[    2.523703] bnx2x 0000:02:00.1: part number 412F4E-0-0-0
[    2.524671] bnx2x 0000:02:00.1: irq 86 for MSI/MSI-X
[    2.524682] bnx2x 0000:02:00.1: irq 87 for MSI/MSI-X
[    2.524694] bnx2x 0000:02:00.1: irq 88 for MSI/MSI-X
[    2.524710] bnx2x 0000:02:00.1: irq 89 for MSI/MSI-X
[    2.524721] bnx2x 0000:02:00.1: irq 90 for MSI/MSI-X
[    2.524732] bnx2x 0000:02:00.1: irq 91 for MSI/MSI-X
[    2.524742] bnx2x 0000:02:00.1: irq 92 for MSI/MSI-X
[    2.524754] bnx2x 0000:02:00.1: irq 93 for MSI/MSI-X
[    2.524765] bnx2x 0000:02:00.1: irq 94 for MSI/MSI-X
[    2.524775] bnx2x 0000:02:00.1: irq 95 for MSI/MSI-X
[    2.524786] bnx2x 0000:02:00.1: irq 96 for MSI/MSI-X
[    2.524796] bnx2x 0000:02:00.1: irq 97 for MSI/MSI-X
[    2.524806] bnx2x 0000:02:00.1: irq 98 for MSI/MSI-X
[    2.524817] bnx2x 0000:02:00.1: irq 99 for MSI/MSI-X
[    2.524851] bnx2x 0000:02:00.1: irq 100 for MSI/MSI-X
[    2.524864] bnx2x 0000:02:00.1: irq 101 for MSI/MSI-X
[    2.524874] bnx2x 0000:02:00.1: irq 102 for MSI/MSI-X
[    2.526116] scsi_id used greatest stack depth: 5440 bytes left
[    2.526996] bnx2x 0000:02:00.1: eth3: Broadcom NetXtreme II BCM57711E 10 Gigabit PCIe (A0) PCI-E x4 5GHz (Gen2) found at mem fa000000, IRQ 47, node addr f4:ce:46:bb:32:d4
[    2.556875] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
[    2.556881] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.557852] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.557862] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.559838] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.560830] uhci_hcd 0000:01:04.4: port 1 portsc 0083,00
[    2.560835] hub 6-0:1.0: port 1: status 0101 change 0001
[    2.638117] blkid used greatest stack depth: 4768 bytes left
[    2.660787] hub 6-0:1.0: state 7 ports 2 chg 0002 evt 0000
[    2.660798] hub 6-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    2.696751] Refined TSC clocksource calibration: 2533.422 MHz.
[    2.696757] Switching to clocksource tsc
[    2.762727] usb 6-1: new full speed USB device number 2 using uhci_hcd
[    2.888401] usb 6-1: skipped 1 descriptor after interface
[    2.888406] usb 6-1: skipped 1 descriptor after interface
[    2.891641] usb 6-1: default language 0x0409
[    2.898115] usb 6-1: udev 2, busnum 6, minor = 641
[    2.898118] usb 6-1: New USB device found, idVendor=03f0, idProduct=1027
[    2.898120] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.898122] usb 6-1: Product: Virtual Keyboard
[    2.898124] usb 6-1: Manufacturer: HP
[    2.898184] usb 6-1: usb_probe_device
[    2.898187] usb 6-1: configuration #1 chosen from 1 choice
[    2.900306] usb 6-1: adding 6-1:1.0 (config #1, interface 0)
[    2.903597] usbhid 6-1:1.0: usb_probe_interface
[    2.903599] usbhid 6-1:1.0: usb_probe_interface - got id
[    2.908143] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:1e.0/0000:01:04.4/usb6/6-1/6-1:1.0/input/input1
[    2.908155] uhci_hcd 0000:01:04.4: reserve dev 2 ep81-INT, period 8, phase 4, 17 us
[    2.908193] generic-usb 0003:03F0:1027.0001: input,hidraw0: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1/input0
[    2.908204] usb 6-1: adding 6-1:1.1 (config #1, interface 1)
[    2.913333] usbhid 6-1:1.1: usb_probe_interface
[    2.913335] usbhid 6-1:1.1: usb_probe_interface - got id
[    2.917812] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:1e.0/0000:01:04.4/usb6/6-1/6-1:1.1/input/input2
[    2.917866] generic-usb 0003:03F0:1027.0002: input,hidraw1: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1/input1
[    2.917879] drivers/usb/core/inode.c: creating file '002'
[    2.917897] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    3.076818] fstype used greatest stack depth: 4736 bytes left
[    3.077847] PM: Starting manual resume from disk
[    3.077850] PM: Hibernation image partition 8:5 present
[    3.077852] PM: Looking for hibernation image.
[    3.078480] PM: Image not found (code -22)
[    3.078482] PM: Hibernation image not present or could not be loaded.
[    3.096737] kjournald starting.  Commit interval 5 seconds
[    3.096761] EXT3-fs (sda1): mounted filesystem with writeback data mode
[    3.600316] usb usb2: suspend_rh (auto-stop)
[    3.600337] usb usb3: suspend_rh (auto-stop)
[    3.600360] usb usb4: suspend_rh (auto-stop)
[    3.600378] usb usb5: suspend_rh (auto-stop)
[    3.641862] stty used greatest stack depth: 3784 bytes left
[    4.124782] touch used greatest stack depth: 3336 bytes left
[    4.348187] udevd[1480]: starting version 172
[    5.020568] hpilo 0000:01:04.2: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    5.082747] IPMI System Interface driver.
[    5.082825] ipmi_si 0000:01:04.6: probing via PCI
[    5.082845] ipmi_si 0000:01:04.6: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    5.082849] ipmi_si 0000:01:04.6: [mem 0xf36f0000-0xf36f00ff] regsize 1 spacing 1 irq 21
[    5.082853] ipmi_si: Adding PCI-specified kcs state machine
[    5.082911] ipmi_si: probing via ACPI
[    5.082949] ipmi_si 00:02: [io  0x0ca2-0x0ca3] regsize 1 spacing 1 irq 0
[    5.082953] ipmi_si: Adding ACPI-specified kcs state machine
[    5.082976] ipmi_si: probing via SMBIOS
[    5.082980] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[    5.082984] ipmi_si: Adding SMBIOS-specified kcs state machine duplicate interface
[    5.082992] ipmi_si: probing via SPMI
[    5.082996] ipmi_si: SPMI: io 0xca2 regsize 2 spacing 2 irq 0
[    5.083000] ipmi_si: Adding SPMI-specified kcs state machine duplicate interface
[    5.083009] ipmi_si: Trying PCI-specified kcs state machine at mem address 0xf36f0000, slave address 0x0, irq 21
[    5.119588] ipmi_si 0000:01:04.6: Using irq 21
[    5.188792] ipmi_si 0000:01:04.6: Found new BMC (man_id: 0x00000b, prod_id: 0x2020, dev_id: 0x11)
[    5.188807] ipmi_si 0000:01:04.6: IPMI kcs interface initialized
[    6.000365] Adding 7903228k swap on /dev/sda5.  Priority:-1 extents:1 across:7903228k 
[    6.910487] EXT3-fs (sda1): using internal journal
[    8.015266] kjournald starting.  Commit interval 5 seconds
[    8.022319] EXT3-fs (sda6): using internal journal
[    8.022323] EXT3-fs (sda6): mounted filesystem with writeback data mode
[   10.449777] bnx2x 0000:02:00.1: eth3: using MSI-X  IRQs: sp 86  fp[0] 87 ... fp[15] 102
[   10.769171] ipmi device interface
[   11.519858] ADDRCONF(NETDEV_UP): eth3: link is not ready
[   13.693736] ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
[   13.693813] bnx2x 0000:02:00.1: eth3: NIC Link is Up, 1000 Mbps full duplex
[   24.436191] eth3: no IPv6 routers present


