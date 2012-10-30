Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab2J3Ja2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:30:28 -0400
Received: from smtp207.alice.it ([82.57.200.103]:53319 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563Ab2J3JaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:30:20 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2012 05:30:19 EDT
Date: Tue, 30 Oct 2012 10:24:39 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: bskeggs@redhat.com
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org
Subject: Re: nouveau, linux3.7-rc3: BUG: unable to handle kernel paging
 request at fffffffffffffff8
Message-Id: <20121030102439.31254089ee80b4a22cb81a5d@studenti.unina.it>
In-Reply-To: <1351574241.3810.5.camel@turiel>
References: <20121029231624.1476a25a62a0c219cc25627a@studenti.unina.it>
	<1351574241.3810.5.camel@turiel>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2012 15:17:21 +1000
Ben Skeggs <bskeggs@redhat.com> wrote:

> On Mon, 2012-10-29 at 23:16 +0100, Antonio Ospite wrote:

[...] 
> > The problem presents itself as soon as I use a gnome-shell session from
> > gdm3, if I use the fall-back mode (gnome-panel) it does not happen
> > immediately, until maybe some processes do something stressful (firefox
> > triggered it twice).
> If you boot into fallback mode and run glxgears (or whatever, some 3d
> app) does this happen too?

It does: as soon as I run glxgears the driver crashes.

> > Here is the kernel trace, please let me know if the disassembled
> > nouveau.o —or any other information— is necessary:
> Are you able to post me your entire kernel log from before this happens?

I am pasting it below, I noticed in particular the line:

 nouveau  [     DRM] allocated 1024x768 fb: 0x50000, bo ffff88011a025800

I am setting video=1024x768 in the kernel command line because without
any resolution set nouveau and my monitor do not get along, but then in
Xorg I am using a bigger resolution, this setup works fine in 3.5 tho
so maybe it's not that.

Full kernel log from boot to crash:

imklog 5.8.11, log source = /proc/kmsg started.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0-rc3-ao2 (ao2@jcn) (gcc version 4.7.2 (Debian 4.7.2-4) ) #1 SMP Mon Oct 29 13:14:36 CET 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.7.0-rc3-ao2 root=UUID=614c68fd-bd5f-4627-9f62-1f0cada81683 ro quiet video=1024x768
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009dc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e3000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cff8ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cff90000-0x00000000cff9dfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cff9e000-0x00000000cffdffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cffe0000-0x00000000cffedfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cfff0000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000feefffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: System manufacturer System Product Name/M3N78-VM, BIOS 1801    09/10/2010
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000120000000 aka 4608M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcff90 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xcff8ffff]
[    0.000000]  [mem 0x00000000-0xcfdfffff] page 2M
[    0.000000]  [mem 0xcfe00000-0xcff8ffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xcff8ffff @ [mem 0x1fffa000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11fffffff]
[    0.000000]  [mem 0x100000000-0x11fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x11fffffff @ [mem 0xcff8e000-0xcff8ffff]
[    0.000000] RAMDISK: [mem 0x368de000-0x37466fff]
[    0.000000] ACPI: RSDP 00000000000fb630 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000cff90100 0006C (v01 091010 XSDT1648 20100910 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cff90290 000F4 (v03 091010 FACP1648 20100910 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000cff90460 0AF17 (v01  A1041 A1041000 00000000 INTL 20060113)
[    0.000000] ACPI: FACS 00000000cff9e000 00040
[    0.000000] ACPI: APIC 00000000cff90390 00090 (v01 091010 APIC1648 20100910 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cff90420 0003C (v01 091010 OEMMCFG  20100910 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cff9e040 00072 (v01 091010 OEMB1648 20100910 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000cff9b380 000B8 (v01 AMD    FAM_F_10 00000002 AMD  00000001)
[    0.000000] ACPI: HPET 00000000cff9b440 00038 (v01 091010 OEMHPET0 20100910 MSFT 00000097)
[    0.000000] ACPI: INFO 00000000cff9e0c0 00124 (v01 091010 AMDINFO  20100910 MSFT 00000097)
[    0.000000] ACPI: NVHD 00000000cff9e1f0 00284 (v01 091010  NVHDCP  20100910 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000cff9b480 00178 (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00100000-0xdfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x11fffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xdfffffff] -> [mem 0x00000000-0xdfffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xdfffffff] + [mem 0x100000000-0x11fffffff] -> [mem 0x00000000-0x11fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11fffc000-0x11fffffff]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff88011ba00000-ffff88011effffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xcff8ffff]
[    0.000000]   node   0: [mem 0x100000000-0x11fffffff]
[    0.000000] On node 0 totalpages: 982813
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3919 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833480 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x508
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] smpboot: Allowing 6 CPUs, 5 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e3000
[    0.000000] PM: Registered nosave memory: 00000000000e3000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cff90000 - 00000000cff9e000
[    0.000000] PM: Registered nosave memory: 00000000cff9e000 - 00000000cffe0000
[    0.000000] PM: Registered nosave memory: 00000000cffe0000 - 00000000cffee000
[    0.000000] PM: Registered nosave memory: 00000000cffee000 - 00000000cfff0000
[    0.000000] PM: Registered nosave memory: 00000000cfff0000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] e820: [mem 0xd0000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:6 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88011fc00000 s83776 r8192 d22720 u262144
[    0.000000] pcpu-alloc: s83776 r8192 d22720 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 - - 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 966679
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.7.0-rc3-ao2 root=UUID=614c68fd-bd5f-4627-9f62-1f0cada81683 ro quiet video=1024x768
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ c4000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ c4000000
[    0.000000] PM: Registered nosave memory: 00000000c4000000 - 00000000c8000000
[    0.000000] Memory: 3723324k/4718592k available (3558k kernel code, 787340k absent, 207928k reserved, 3159k data, 616k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=6.
[    0.000000] NR_IRQS:33024 nr_irqs:728 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2814.255 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.004005] Calibrating delay loop (skipped), value calculated using timer frequency.. 5628.51 BogoMIPS (lpj=11257020)
[    0.004008] pid_max: default: 32768 minimum: 301
[    0.004046] Security Framework initialized
[    0.004052] AppArmor: AppArmor disabled by boot time parameter
[    0.004341] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.009246] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.010307] Mount-cache hash table entries: 256
[    0.010522] Initializing cgroup subsys cpuacct
[    0.010525] Initializing cgroup subsys devices
[    0.010526] Initializing cgroup subsys freezer
[    0.010528] Initializing cgroup subsys net_cls
[    0.010530] Initializing cgroup subsys blkio
[    0.010531] Initializing cgroup subsys perf_event
[    0.010558] tseg: 0000000000
[    0.010572] mce: CPU supports 5 MCE banks
[    0.010581] LVT offset 0 assigned for vector 0xf9
[    0.010585] process: using AMD E400 aware idle routine
[    0.010588] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.010588] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.010588] tlb_flushall_shift: 4
[    0.012719] ACPI: Core revision 20120913
[    0.017978] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.057675] smpboot: CPU0: AMD Athlon(tm) Processor LE-1660 (fam: 0f, model: 7f, stepping: 02)
[    0.060000] Performance Events: AMD PMU driver.
[    0.060000] ... version:                0
[    0.060000] ... bit width:              48
[    0.060000] ... generic registers:      4
[    0.060000] ... value mask:             0000ffffffffffff
[    0.060000] ... max period:             00007fffffffffff
[    0.060000] ... fixed-purpose events:   0
[    0.060000] ... event mask:             000000000000000f
[    0.060000] Brought up 1 CPUs
[    0.060000] smpboot: Total of 1 processors activated (5628.51 BogoMIPS)
[    0.060000] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.060000] devtmpfs: initialized
[    0.060000] PM: Registering ACPI NVS region [mem 0xcff9e000-0xcffdffff] (270336 bytes)
[    0.060000] regulator-dummy: no parameters
[    0.060000] NET: Registered protocol family 16
[    0.060000] node 0 link 0: io port [5000, ffffff]
[    0.060000] node 0 link 0: io port [1000, 1fff]
[    0.060000] TOM: 00000000e0000000 aka 3584M
[    0.060000] node 0 link 0: mmio [e0000000, efffffff]
[    0.060000] node 0 link 0: mmio [a0000, bffff]
[    0.060000] node 0 link 0: mmio [e0000000, fe0bffff]
[    0.060000] TOM2: 0000000120000000 aka 4608M
[    0.060000] bus: [bus 00-07] on node 0 link 0
[    0.060000] bus: 00 [io  0x2000-0xffff]
[    0.060000] bus: 00 [io  0x0000-0x1fff]
[    0.060000] bus: 00 [mem 0xe0000000-0xffffffff]
[    0.060000] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.060000] bus: 00 [mem 0x120000000-0xfcffffffff]
[    0.060000] ACPI: bus type pci registered
[    0.060062] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.060064] PCI: not using MMCONFIG
[    0.060065] PCI: Using configuration type 1 for base access
[    0.060789] bio: create slab <bio-0> at 0
[    0.060866] ACPI: Added _OSI(Module Device)
[    0.060868] ACPI: Added _OSI(Processor Device)
[    0.060870] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.060871] ACPI: Added _OSI(Processor Aggregator Device)
[    0.061912] ACPI: EC: Look up EC in DSDT
[    0.063357] ACPI: Executed 1 blocks of module-level executable AML code
[    0.067945] ACPI: Interpreter enabled
[    0.067950] ACPI: (supports S0 S1 S3 S4 S5)
[    0.067969] ACPI: Using IOAPIC for interrupt routing
[    0.068011] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.069584] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.092280] ACPI: No dock devices found.
[    0.092286] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.092508] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.092702] PCI host bridge to bus 0000:00
[    0.092705] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.092708] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.092711] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.092713] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.092716] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.092718] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfed44fff]
[    0.092752] pci 0000:00:00.0: [10de:0754] type 00 class 0x050000
[    0.093010] pci 0000:00:01.0: [10de:075c] type 00 class 0x060100
[    0.093017] pci 0000:00:01.0: reg 10: [io  0x0900-0x09ff]
[    0.093053] pci 0000:00:01.1: [10de:0752] type 00 class 0x0c0500
[    0.093064] pci 0000:00:01.1: reg 10: [io  0x0e00-0x0e3f]
[    0.093079] pci 0000:00:01.1: reg 20: [io  0x0600-0x063f]
[    0.093085] pci 0000:00:01.1: reg 24: [io  0x0700-0x073f]
[    0.093114] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.093130] pci 0000:00:01.2: [10de:0751] type 00 class 0x050000
[    0.093179] pci 0000:00:01.3: [10de:0753] type 00 class 0x0b4000
[    0.093195] pci 0000:00:01.3: reg 10: [mem 0xfcf80000-0xfcffffff]
[    0.093308] pci 0000:00:01.4: [10de:0568] type 00 class 0x050000
[    0.093378] pci 0000:00:02.0: [10de:077b] type 00 class 0x0c0310
[    0.093386] pci 0000:00:02.0: reg 10: [mem 0xfcf7e000-0xfcf7efff]
[    0.093419] pci 0000:00:02.0: supports D1 D2
[    0.093422] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.093436] pci 0000:00:02.1: [10de:077c] type 00 class 0x0c0320
[    0.093446] pci 0000:00:02.1: reg 10: [mem 0xfcf7fc00-0xfcf7fcff]
[    0.093487] pci 0000:00:02.1: supports D1 D2
[    0.093489] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.093509] pci 0000:00:04.0: [10de:077d] type 00 class 0x0c0310
[    0.093518] pci 0000:00:04.0: reg 10: [mem 0xfcf7d000-0xfcf7dfff]
[    0.093551] pci 0000:00:04.0: supports D1 D2
[    0.093553] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.093568] pci 0000:00:04.1: [10de:077e] type 00 class 0x0c0320
[    0.093578] pci 0000:00:04.1: reg 10: [mem 0xfcf7f800-0xfcf7f8ff]
[    0.093618] pci 0000:00:04.1: supports D1 D2
[    0.093620] pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.093644] pci 0000:00:07.0: [10de:0774] type 00 class 0x040300
[    0.093654] pci 0000:00:07.0: reg 10: [mem 0xfcf78000-0xfcf7bfff]
[    0.093695] pci 0000:00:07.0: PME# supported from D3hot D3cold
[    0.093711] pci 0000:00:08.0: [10de:075a] type 01 class 0x060401
[    0.093751] pci 0000:00:09.0: [10de:0ad4] type 00 class 0x010601
[    0.093760] pci 0000:00:09.0: reg 10: [io  0xd480-0xd487]
[    0.093764] pci 0000:00:09.0: reg 14: [io  0xd400-0xd403]
[    0.093769] pci 0000:00:09.0: reg 18: [io  0xd080-0xd087]
[    0.093773] pci 0000:00:09.0: reg 1c: [io  0xd000-0xd003]
[    0.093778] pci 0000:00:09.0: reg 20: [io  0xcc00-0xcc0f]
[    0.093782] pci 0000:00:09.0: reg 24: [mem 0xfcf76000-0xfcf77fff]
[    0.093815] pci 0000:00:0a.0: [10de:0760] type 00 class 0x020000
[    0.093825] pci 0000:00:0a.0: reg 10: [mem 0xfcf7c000-0xfcf7cfff]
[    0.093829] pci 0000:00:0a.0: reg 14: [io  0xc880-0xc887]
[    0.093834] pci 0000:00:0a.0: reg 18: [mem 0xfcf7f400-0xfcf7f4ff]
[    0.093838] pci 0000:00:0a.0: reg 1c: [mem 0xfcf7f000-0xfcf7f00f]
[    0.093868] pci 0000:00:0a.0: supports D1 D2
[    0.093870] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.093886] pci 0000:00:0b.0: [10de:0569] type 01 class 0x060400
[    0.093910] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.093966] pci 0000:00:10.0: [10de:0778] type 01 class 0x060400
[    0.094187] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.094279] pci 0000:00:12.0: [10de:075b] type 01 class 0x060400
[    0.094498] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.094551] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.094568] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.094582] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.094596] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.094656] pci 0000:00:08.0: PCI bridge to [bus 01] (subtractive decode)
[    0.094661] pci 0000:00:08.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.094664] pci 0000:00:08.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.094666] pci 0000:00:08.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.094669] pci 0000:00:08.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.094671] pci 0000:00:08.0:   bridge window [mem 0xf0000000-0xfed44fff] (subtractive decode)
[    0.094693] pci 0000:02:00.0: [10de:0849] type 00 class 0x030000
[    0.094701] pci 0000:02:00.0: reg 10: [mem 0xfd000000-0xfdffffff]
[    0.094707] pci 0000:02:00.0: reg 14: [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.094713] pci 0000:02:00.0: reg 1c: [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.094717] pci 0000:02:00.0: reg 24: [io  0xec00-0xec7f]
[    0.094722] pci 0000:02:00.0: reg 30: [mem 0xfebe0000-0xfebfffff pref]
[    0.094748] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    0.094752] pci 0000:00:0b.0:   bridge window [io  0xe000-0xefff]
[    0.094754] pci 0000:00:0b.0:   bridge window [mem 0xfd000000-0xfebfffff]
[    0.094758] pci 0000:00:0b.0:   bridge window [mem 0xf0000000-0xfbffffff 64bit pref]
[    0.094905] pci 0000:00:10.0: PCI bridge to [bus 03]
[    0.095082] pci 0000:00:12.0: PCI bridge to [bus 04]
[    0.095139] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.095401] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.095459] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IXVE._PRT]
[    0.095498] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MXR0._PRT]
[    0.095535] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.095691]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.095905]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x0c
[    0.095906] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.105864] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0, disabled.
[    0.105976] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
[    0.106088] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[    0.106199] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    0.106312] ACPI: PCI Interrupt Link [LN0A] (IRQs 16 17 18 19) *10
[    0.106421] ACPI: PCI Interrupt Link [LN0B] (IRQs 16 17 18 19) *0, disabled.
[    0.106531] ACPI: PCI Interrupt Link [LN0C] (IRQs 16 17 18 19) *0, disabled.
[    0.106642] ACPI: PCI Interrupt Link [LN0D] (IRQs 16 17 18 19) *0, disabled.
[    0.106752] ACPI: PCI Interrupt Link [LN1A] (IRQs 16 17 18 19) *0, disabled.
[    0.106862] ACPI: PCI Interrupt Link [LN1B] (IRQs 16 17 18 19) *0, disabled.
[    0.106972] ACPI: PCI Interrupt Link [LN1C] (IRQs 16 17 18 19) *0, disabled.
[    0.107082] ACPI: PCI Interrupt Link [LN1D] (IRQs 16 17 18 19) *0, disabled.
[    0.107195] ACPI: PCI Interrupt Link [LN2A] (IRQs 16 17 18 19) *11
[    0.107304] ACPI: PCI Interrupt Link [LN2B] (IRQs 16 17 18 19) *0, disabled.
[    0.107414] ACPI: PCI Interrupt Link [LN2C] (IRQs 16 17 18 19) *0, disabled.
[    0.107524] ACPI: PCI Interrupt Link [LN2D] (IRQs 16 17 18 19) *0, disabled.
[    0.107634] ACPI: PCI Interrupt Link [LN3A] (IRQs 16 17 18 19) *0, disabled.
[    0.107745] ACPI: PCI Interrupt Link [LN3B] (IRQs 16 17 18 19) *0, disabled.
[    0.107855] ACPI: PCI Interrupt Link [LN3C] (IRQs 16 17 18 19) *0, disabled.
[    0.107966] ACPI: PCI Interrupt Link [LN3D] (IRQs 16 17 18 19) *0, disabled.
[    0.108091] ACPI: PCI Interrupt Link [LN4A] (IRQs 16 17 18 19) *0, disabled.
[    0.108201] ACPI: PCI Interrupt Link [LN4B] (IRQs 16 17 18 19) *0, disabled.
[    0.108312] ACPI: PCI Interrupt Link [LN4C] (IRQs 16 17 18 19) *0, disabled.
[    0.108422] ACPI: PCI Interrupt Link [LN4D] (IRQs 16 17 18 19) *0, disabled.
[    0.108532] ACPI: PCI Interrupt Link [LN5A] (IRQs 16 17 18 19) *0, disabled.
[    0.108642] ACPI: PCI Interrupt Link [LN5B] (IRQs 16 17 18 19) *0, disabled.
[    0.108752] ACPI: PCI Interrupt Link [LN5C] (IRQs 16 17 18 19) *0, disabled.
[    0.108863] ACPI: PCI Interrupt Link [LN5D] (IRQs 16 17 18 19) *0, disabled.
[    0.108973] ACPI: PCI Interrupt Link [LN6A] (IRQs 16 17 18 19) *0, disabled.
[    0.109083] ACPI: PCI Interrupt Link [LN6B] (IRQs 16 17 18 19) *0, disabled.
[    0.109194] ACPI: PCI Interrupt Link [LN6C] (IRQs 16 17 18 19) *0, disabled.
[    0.109304] ACPI: PCI Interrupt Link [LN6D] (IRQs 16 17 18 19) *0, disabled.
[    0.109414] ACPI: PCI Interrupt Link [LN7A] (IRQs 16 17 18 19) *0, disabled.
[    0.109526] ACPI: PCI Interrupt Link [LN7B] (IRQs 16 17 18 19) *0, disabled.
[    0.109638] ACPI: PCI Interrupt Link [LN7C] (IRQs 16 17 18 19) *0, disabled.
[    0.109748] ACPI: PCI Interrupt Link [LN7D] (IRQs 16 17 18 19) *0, disabled.
[    0.109863] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *15
[    0.109975] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *11
[    0.110088] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *15
[    0.110201] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *11
[    0.110321] ACPI: PCI Interrupt Link [SGRU] (IRQs 20 21 22 23) *15
[    0.110434] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *10
[    0.110546] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *14
[    0.110659] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *5
[    0.110787] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[    0.110901] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *10
[    0.111018] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *14
[    0.111132] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.111133] vgaarb: loaded
[    0.111134] vgaarb: bridge control possible 0000:02:00.0
[    0.111182] PCI: Using ACPI for IRQ routing
[    0.117499] PCI: pci_cache_line_size set to 64 bytes
[    0.117554] e820: reserve RAM buffer [mem 0x0009dc00-0x0009ffff]
[    0.117556] e820: reserve RAM buffer [mem 0xcff90000-0xcfffffff]
[    0.117694] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.117700] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.117703] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.119765] Switching to clocksource hpet
[    0.119771] pnp: PnP ACPI init
[    0.119771] ACPI: bus type pnp registered
[    0.119771] pnp 00:00: [bus 00-ff]
[    0.119771] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.119771] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.119771] pnp 00:00: [io  0x0d00-0xffff window]
[    0.119771] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.119771] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.119771] pnp 00:00: [mem 0xe0000000-0xdfffffff window disabled]
[    0.119771] pnp 00:00: [mem 0xf0000000-0xfed44fff window]
[    0.119771] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.119771] pnp 00:01: [dma 4]
[    0.119771] pnp 00:01: [io  0x0000-0x000f]
[    0.119771] pnp 00:01: [io  0x0081-0x0083]
[    0.119771] pnp 00:01: [io  0x0087]
[    0.119771] pnp 00:01: [io  0x0089-0x008b]
[    0.119771] pnp 00:01: [io  0x008f]
[    0.119771] pnp 00:01: [io  0x00c0-0x00df]
[    0.119771] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.119771] pnp 00:02: [io  0x0061]
[    0.119771] pnp 00:02: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.119771] pnp 00:03: [io  0x00f0-0x00ff]
[    0.119771] pnp 00:03: [irq 13]
[    0.119771] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.119771] pnp 00:04: [io  0x03f0-0x03f5]
[    0.119771] pnp 00:04: [io  0x03f7]
[    0.119771] pnp 00:04: [irq 6]
[    0.119771] pnp 00:04: [dma 2]
[    0.119771] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.120103] pnp 00:05: [io  0x0378-0x037f]
[    0.120112] pnp 00:05: [irq 7]
[    0.120114] pnp 00:05: [dma 0 disabled]
[    0.120442] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.120814] pnp 00:06: [mem 0x000d0000-0x000d3fff window]
[    0.120817] pnp 00:06: [mem 0x000d4000-0x000d7fff window]
[    0.120819] pnp 00:06: [mem 0x000de000-0x000dffff window]
[    0.120822] pnp 00:06: [io  0x0010-0x001f]
[    0.120824] pnp 00:06: [io  0x0022-0x003f]
[    0.120826] pnp 00:06: [io  0x0044-0x004d]
[    0.120828] pnp 00:06: [io  0x0050-0x005f]
[    0.120830] pnp 00:06: [io  0x0062-0x0063]
[    0.120832] pnp 00:06: [io  0x0065-0x006f]
[    0.120835] pnp 00:06: [io  0x0072-0x007f]
[    0.120837] pnp 00:06: [io  0x0080]
[    0.120839] pnp 00:06: [io  0x0084-0x0086]
[    0.120841] pnp 00:06: [io  0x0088]
[    0.120843] pnp 00:06: [io  0x008c-0x008e]
[    0.120846] pnp 00:06: [io  0x0090-0x009f]
[    0.120848] pnp 00:06: [io  0x00a2-0x00bf]
[    0.120850] pnp 00:06: [io  0x00e0-0x00ef]
[    0.120852] pnp 00:06: [io  0x04d0-0x04d1]
[    0.120854] pnp 00:06: [io  0x0800-0x080f]
[    0.120857] pnp 00:06: [io  0x0500-0x057f]
[    0.120859] pnp 00:06: [io  0x0580-0x05ff]
[    0.120861] pnp 00:06: [io  0x0800-0x087f]
[    0.120863] pnp 00:06: [io  0x0880-0x08ff]
[    0.120865] pnp 00:06: [io  0x0d00-0x0d7f]
[    0.120867] pnp 00:06: [io  0x0d80-0x0dff]
[    0.120870] pnp 00:06: [io  0x0900-0x097f]
[    0.120872] pnp 00:06: [io  0x0980-0x09ff]
[    0.120874] pnp 00:06: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.120877] pnp 00:06: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.120879] pnp 00:06: [mem 0xfed04000-0xfed04fff]
[    0.120882] pnp 00:06: [mem 0xfee01000-0xfeefffff]
[    0.120889] pnp 00:06: disabling [io  0x0900-0x097f] because it overlaps 0000:00:01.0 BAR 0 [io  0x0900-0x09ff]
[    0.120892] pnp 00:06: disabling [io  0x0980-0x09ff] because it overlaps 0000:00:01.0 BAR 0 [io  0x0900-0x09ff]
[    0.120953] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.120956] system 00:06: [io  0x0800-0x080f] has been reserved
[    0.120959] system 00:06: [io  0x0500-0x057f] has been reserved
[    0.120962] system 00:06: [io  0x0580-0x05ff] has been reserved
[    0.120965] system 00:06: [io  0x0800-0x087f] could not be reserved
[    0.120967] system 00:06: [io  0x0880-0x08ff] has been reserved
[    0.120970] system 00:06: [io  0x0d00-0x0d7f] has been reserved
[    0.120973] system 00:06: [io  0x0d80-0x0dff] has been reserved
[    0.120976] system 00:06: [mem 0x000d0000-0x000d3fff window] has been reserved
[    0.120979] system 00:06: [mem 0x000d4000-0x000d7fff window] has been reserved
[    0.120982] system 00:06: [mem 0x000de000-0x000dffff window] has been reserved
[    0.120985] system 00:06: [mem 0xfed04000-0xfed04fff] has been reserved
[    0.120988] system 00:06: [mem 0xfee01000-0xfeefffff] has been reserved
[    0.120991] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.121105] pnp 00:07: [mem 0xfed00000-0xfed00fff]
[    0.121108] pnp 00:07: [irq 2 disabled]
[    0.121116] pnp 00:07: [irq 8]
[    0.121139] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.121163] pnp 00:08: [io  0x0070-0x0071]
[    0.121184] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.121293] pnp 00:09: [mem 0xfec00000-0xfec00fff]
[    0.121295] pnp 00:09: [mem 0xfee00000-0xfee00fff]
[    0.121298] pnp 00:09: [mem 0xd0000000-0xdfffffff]
[    0.121330] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.121333] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.121336] system 00:09: [mem 0xd0000000-0xdfffffff] has been reserved
[    0.121339] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.121367] pnp 00:0a: [io  0x0060]
[    0.121370] pnp 00:0a: [io  0x0064]
[    0.121378] pnp 00:0a: [irq 1]
[    0.121408] pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.121590] pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
[    0.121593] pnp 00:0b: [io  0x0230-0x023f]
[    0.121595] pnp 00:0b: [io  0x0290-0x029f]
[    0.121597] pnp 00:0b: [io  0x0a00-0x0a0f]
[    0.121599] pnp 00:0b: [io  0x0a10-0x0a1f]
[    0.121630] system 00:0b: [io  0x0230-0x023f] has been reserved
[    0.121633] system 00:0b: [io  0x0290-0x029f] has been reserved
[    0.121636] system 00:0b: [io  0x0a00-0x0a0f] has been reserved
[    0.121638] system 00:0b: [io  0x0a10-0x0a1f] has been reserved
[    0.121641] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.122300] pnp 00:0c: [io  0x03f8-0x03ff]
[    0.122308] pnp 00:0c: [irq 4]
[    0.122311] pnp 00:0c: [dma 0 disabled]
[    0.122377] pnp 00:0c: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.122437] pnp 00:0d: [mem 0xe0000000-0xefffffff]
[    0.122467] system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
[    0.122470] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.122652] pnp 00:0e: [mem 0x00000000-0x0009ffff]
[    0.122654] pnp 00:0e: [mem 0x000c0000-0x000cffff]
[    0.122657] pnp 00:0e: [mem 0x000e0000-0x000fffff]
[    0.122659] pnp 00:0e: [mem 0x00100000-0xdfffffff]
[    0.122661] pnp 00:0e: [mem 0xfed45000-0xffffffff]
[    0.122698] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.122701] system 00:0e: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.122704] system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.122706] system 00:0e: [mem 0x00100000-0xdfffffff] could not be reserved
[    0.122709] system 00:0e: [mem 0xfed45000-0xffffffff] could not be reserved
[    0.122712] system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.123450] pnp: PnP ACPI: found 15 devices
[    0.123451] ACPI: ACPI bus type pnp unregistered
[    0.129768] pci 0000:00:08.0: PCI bridge to [bus 01]
[    0.129777] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    0.129779] pci 0000:00:0b.0:   bridge window [io  0xe000-0xefff]
[    0.129782] pci 0000:00:0b.0:   bridge window [mem 0xfd000000-0xfebfffff]
[    0.129785] pci 0000:00:0b.0:   bridge window [mem 0xf0000000-0xfbffffff 64bit pref]
[    0.129789] pci 0000:00:10.0: PCI bridge to [bus 03]
[    0.129813] pci 0000:00:12.0: PCI bridge to [bus 04]
[    0.129843] pci 0000:00:08.0: setting latency timer to 64
[    0.129847] pci 0000:00:0b.0: setting latency timer to 64
[    0.130077] ACPI: PCI Interrupt Link [LN0A] enabled at IRQ 19
[    0.130283] ACPI: PCI Interrupt Link [LN2A] enabled at IRQ 18
[    0.130296] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.130298] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.130300] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.130303] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.130305] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfed44fff]
[    0.130307] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    0.130309] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    0.130312] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    0.130314] pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff]
[    0.130316] pci_bus 0000:01: resource 8 [mem 0xf0000000-0xfed44fff]
[    0.130318] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.130320] pci_bus 0000:02: resource 1 [mem 0xfd000000-0xfebfffff]
[    0.130323] pci_bus 0000:02: resource 2 [mem 0xf0000000-0xfbffffff 64bit pref]
[    0.130361] NET: Registered protocol family 2
[    0.131001] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.134528] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.134980] TCP: Hash tables configured (established 524288 bind 65536)
[    0.135060] TCP: reno registered
[    0.135071] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.135103] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.135211] NET: Registered protocol family 1
[    0.135494] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 23
[    0.135699] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[    0.135885] ACPI: PCI Interrupt Link [UB11] enabled at IRQ 21
[    0.136108] ACPI: PCI Interrupt Link [UB12] enabled at IRQ 20
[    0.136223] pci 0000:00:07.0: Enabling HT MSI Mapping
[    0.136316] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.136414] pci 0000:00:09.0: Enabling HT MSI Mapping
[    0.136517] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.136619] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.136742] pci 0000:02:00.0: Boot video device
[    0.136744] PCI: CLS 64 bytes, default 64
[    0.136792] Unpacking initramfs...
[    0.382182] Freeing initrd memory: 11812k freed
[    0.388080] PCI-DMA: Disabling AGP.
[    0.388154] PCI-DMA: aperture base @ c4000000 size 65536 KB
[    0.388155] PCI-DMA: using GART IOMMU.
[    0.388158] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.390725] audit: initializing netlink socket (disabled)
[    0.390741] type=2000 audit(1351583134.388:1): initialized
[    0.404155] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.404558] VFS: Disk quotas dquot_6.5.2
[    0.404578] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.404655] msgmni has been set to 7424
[    0.404813] alg: No test for stdrng (krng)
[    0.404831] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.404833] io scheduler noop registered
[    0.404835] io scheduler deadline registered
[    0.404841] io scheduler cfq registered (default)
[    0.405150] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.405171] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.405173] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.405492] GHES: HEST is not enabled!
[    0.405550] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.425970] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.426372] Linux agpgart interface v0.103
[    0.426464] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.426465] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.426611] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.426708] mousedev: PS/2 mouse device common for all mice
[    0.426758] rtc_cmos 00:08: RTC can wake from S4
[    0.426999] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    0.427053] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    0.427062] cpuidle: using governor ladder
[    0.427063] cpuidle: using governor menu
[    0.427087] drop_monitor: Initializing network drop monitor service
[    0.427154] TCP: cubic registered
[    0.427171] NET: Registered protocol family 10
[    0.427347] mip6: Mobile IPv6
[    0.427349] NET: Registered protocol family 17
[    0.427367] Key type dns_resolver registered
[    0.427552] PM: Hibernation image not present or could not be loaded.
[    0.427560] registered taskstats version 1
[    0.428254] rtc_cmos 00:08: setting system clock to 2012-10-30 07:45:34 UTC (1351583134)
[    0.429635] Freeing unused kernel memory: 616k freed
[    0.429896] Write protecting the kernel read-only data: 6144k
[    0.431952] Freeing unused kernel memory: 528k freed
[    0.434409] Freeing unused kernel memory: 584k freed
[    0.452405] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.566458] ACPI: bus type usb registered
[    0.566489] usbcore: registered new interface driver usbfs
[    0.566502] usbcore: registered new interface driver hub
[    0.571047] Floppy drive(s): fd0 is 1.44M
[    0.599264] usbcore: registered new device driver usb
[    0.599713] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.599764] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    0.599767] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    0.599773] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    0.599805] ehci_hcd 0000:00:02.1: debug port 1
[    0.599809] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    0.599834] ehci_hcd 0000:00:02.1: irq 22, io mem 0xfcf7fc00
[    0.605123] FDC 0 is a post-1991 82077
[    0.608048] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    0.608090] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.608093] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.608095] usb usb1: Product: EHCI Host Controller
[    0.608097] usb usb1: Manufacturer: Linux 3.7.0-rc3-ao2 ehci_hcd
[    0.608099] usb usb1: SerialNumber: 0000:00:02.1
[    0.608227] hub 1-0:1.0: USB hub found
[    0.608232] hub 1-0:1.0: 6 ports detected
[    0.608388] ehci_hcd 0000:00:04.1: setting latency timer to 64
[    0.608390] ehci_hcd 0000:00:04.1: EHCI Host Controller
[    0.608397] ehci_hcd 0000:00:04.1: new USB bus registered, assigned bus number 2
[    0.608423] ehci_hcd 0000:00:04.1: debug port 1
[    0.608428] ehci_hcd 0000:00:04.1: cache line size of 64 is not supported
[    0.608452] ehci_hcd 0000:00:04.1: irq 20, io mem 0xfcf7f800
[    0.618358] SCSI subsystem initialized
[    0.620055] ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.00
[    0.620099] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.620102] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.620104] usb usb2: Product: EHCI Host Controller
[    0.620106] usb usb2: Manufacturer: Linux 3.7.0-rc3-ao2 ehci_hcd
[    0.620108] usb usb2: SerialNumber: 0000:00:04.1
[    0.620229] hub 2-0:1.0: USB hub found
[    0.620234] hub 2-0:1.0: 6 ports detected
[    0.620747] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.620788] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    0.620790] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    0.620798] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 3
[    0.620834] ohci_hcd 0000:00:02.0: irq 23, io mem 0xfcf7e000
[    0.633595] ACPI: bus type scsi registered
[    0.636177] libata version 3.00 loaded.
[    0.678025] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.678030] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.678032] usb usb3: Product: OHCI Host Controller
[    0.678034] usb usb3: Manufacturer: Linux 3.7.0-rc3-ao2 ohci_hcd
[    0.678036] usb usb3: SerialNumber: 0000:00:02.0
[    0.678157] hub 3-0:1.0: USB hub found
[    0.678164] hub 3-0:1.0: 6 ports detected
[    0.678392] ohci_hcd 0000:00:04.0: setting latency timer to 64
[    0.678395] ohci_hcd 0000:00:04.0: OHCI Host Controller
[    0.678401] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 4
[    0.678435] ohci_hcd 0000:00:04.0: irq 21, io mem 0xfcf7d000
[    0.734009] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.734012] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.734014] usb usb4: Product: OHCI Host Controller
[    0.734016] usb usb4: Manufacturer: Linux 3.7.0-rc3-ao2 ohci_hcd
[    0.734018] usb usb4: SerialNumber: 0000:00:04.0
[    0.734161] hub 4-0:1.0: USB hub found
[    0.734167] hub 4-0:1.0: 6 ports detected
[    0.736033] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    0.736247] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
[    0.736254] forcedeth 0000:00:0a.0: setting latency timer to 64
[    0.801050] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x732 @ 3, addr 00:0b:e0:f0:00:ed
[    0.801055] forcedeth 0000:00:0a.0: highdma csum pwrctl mgmt gbit lnktim msi desc-v3
[    0.801261] ahci 0000:00:09.0: version 3.0
[    0.801455] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 22
[    0.801502] ahci 0000:00:09.0: irq 40 for MSI/MSI-X
[    0.801512] ahci 0000:00:09.0: controller can't do PMP, turning off CAP_PMP
[    0.801590] ahci 0000:00:09.0: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.801594] ahci 0000:00:09.0: flags: 64bit ncq sntf led clo pio boh 
[    0.801597] ahci 0000:00:09.0: setting latency timer to 64
[    0.803522] scsi0 : ahci
[    0.803656] scsi1 : ahci
[    0.803742] scsi2 : ahci
[    0.803828] scsi3 : ahci
[    0.803922] scsi4 : ahci
[    0.804041] scsi5 : ahci
[    0.804091] ata1: SATA max UDMA/133 abar m8192@0xfcf76000 port 0xfcf76100 irq 40
[    0.804094] ata2: SATA max UDMA/133 abar m8192@0xfcf76000 port 0xfcf76180 irq 40
[    0.804096] ata3: SATA max UDMA/133 abar m8192@0xfcf76000 port 0xfcf76200 irq 40
[    0.804098] ata4: SATA max UDMA/133 abar m8192@0xfcf76000 port 0xfcf76280 irq 40
[    0.804100] ata5: SATA max UDMA/133 abar m8192@0xfcf76000 port 0xfcf76300 irq 40
[    0.804101] ata6: SATA max UDMA/133 abar m8192@0xfcf76000 port 0xfcf76380 irq 40
[    1.032014] usb 1-6: new high-speed USB device number 3 using ehci_hcd
[    1.124018] ata5: SATA link down (SStatus 0 SControl 300)
[    1.124034] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.124045] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.124053] ata2: SATA link down (SStatus 0 SControl 300)
[    1.124063] ata4: SATA link down (SStatus 0 SControl 300)
[    1.124072] ata6: SATA link down (SStatus 0 SControl 300)
[    1.125034] ata1.00: ATA-8: ST3500418AS, CC37, max UDMA/133
[    1.125036] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.125197] ata1.00: failed to get Identify Device Data, Emask 0x1
[    1.125459] ata3.00: ATAPI: TSSTcorp CDDVDW SH-S223C, SB04, max UDMA/100
[    1.126540] ata1.00: failed to get Identify Device Data, Emask 0x1
[    1.126543] ata1.00: configured for UDMA/133
[    1.126637] scsi 0:0:0:0: Direct-Access     ATA      ST3500418AS      CC37 PQ: 0 ANSI: 5
[    1.165864] usb 1-6: New USB device found, idVendor=058f, idProduct=6362
[    1.165867] usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.165869] usb 1-6: Product: Mass Storage Device
[    1.165871] usb 1-6: Manufacturer: Generic
[    1.165873] usb 1-6: SerialNumber: 058E63626375
[    1.168361] usbcore: registered new interface driver uas
[    1.524015] usb 4-3: new low-speed USB device number 2 using ohci_hcd
[    1.736031] usb 4-3: New USB device found, idVendor=046d, idProduct=c05a
[    1.736034] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.736036] usb 4-3: Product: USB Optical Mouse
[    1.736038] usb 4-3: Manufacturer: Logitech
[    1.926579] ata3.00: configured for UDMA/100
[    2.168015] usb 3-3: new full-speed USB device number 2 using ohci_hcd
[    2.390032] usb 3-3: New USB device found, idVendor=0a5c, idProduct=2102
[    2.390034] usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.390037] usb 3-3: Product: ANYCOM Blue USB-200/250
[    2.390039] usb 3-3: Manufacturer: Broadcom Corp
[    2.728394] scsi 2:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S223C  SB04 PQ: 0 ANSI: 5
[    2.729595] Initializing USB Mass Storage driver...
[    2.738041] scsi6 : usb-storage 1-6:1.0
[    2.738261] usbcore: registered new interface driver usb-storage
[    2.738263] USB Mass Storage support registered.
[    2.740108] usbcore: registered new interface driver usbhid
[    2.740111] usbhid: USB HID core driver
[    2.741029] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.741070] sd 0:0:0:0: [sda] Write Protect is off
[    2.741073] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.741091] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.743847] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:04.0/usb4/4-3/4-3:1.0/input/input1
[    2.744120] hid-generic 0003:046D:C05A.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:04.0-3/input0
[    2.745868] sr0: scsi3-mmc drive: 52x/52x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.745872] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.745984] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    2.789369]  sda: sda1 sda2 < sda5 sda6 sda7 >
[    2.789727] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.794226] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.794288] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    2.807576] ata3.00: exception Emask 0x12 SAct 0x0 SErr 0x400 action 0x6 frozen
[    2.807621] ata3.00: irq_stat 0x08000002, interface fatal error
[    2.807660] ata3: SError: { Proto }
[    2.807695] ata3.00: failed command: IDENTIFY PACKET DEVICE
[    2.807735] ata3.00: cmd a1/00:01:00:00:00/00:00:00:00:00/00 tag 0 pio 512 in
[    2.807735]          res 50/00:03:00:24:00/00:00:00:00:00/a0 Emask 0x12 (ATA bus error)
[    2.807788] ata3.00: status: { DRDY }
[    2.807825] ata3: hard resetting link
[    3.124020] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.738128] scsi 6:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[    3.738622] scsi 6:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[    3.739122] scsi 6:0:0:2: Direct-Access     Generic  USB xD/SM Reader 1.02 PQ: 0 ANSI: 0
[    3.739622] scsi 6:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[    3.740074] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    3.740223] sd 6:0:0:1: Attached scsi generic sg3 type 0
[    3.740361] sd 6:0:0:2: Attached scsi generic sg4 type 0
[    3.740505] sd 6:0:0:3: Attached scsi generic sg5 type 0
[    3.746011] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[    3.746631] sd 6:0:0:1: [sdc] Attached SCSI removable disk
[    3.747245] sd 6:0:0:2: [sdd] Attached SCSI removable disk
[    3.747871] sd 6:0:0:3: [sde] Attached SCSI removable disk
[    4.409528] ata3.00: configured for UDMA/100
[    5.210306] ata3: EH complete
[    5.219510] ata3.00: exception Emask 0x12 SAct 0x0 SErr 0x400 action 0x6 frozen
[    5.219554] ata3.00: irq_stat 0x08000002, interface fatal error
[    5.219593] ata3: SError: { Proto }
[    5.219628] ata3.00: failed command: IDENTIFY PACKET DEVICE
[    5.219668] ata3.00: cmd a1/00:01:00:00:00/00:00:00:00:00/00 tag 0 pio 512 in
[    5.219668]          res 50/00:03:00:24:00/00:00:00:00:00/a0 Emask 0x12 (ATA bus error)
[    5.219721] ata3.00: status: { DRDY }
[    5.219758] ata3: hard resetting link
[    5.536017] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.821488] ata3.00: configured for UDMA/100
[    7.622321] ata3: EH complete
[    7.633149] device-mapper: uevent: version 1.0.3
[    7.633439] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[    7.642671] PM: Starting manual resume from disk
[    7.642676] PM: Hibernation image partition 8:5 present
[    7.642677] PM: Looking for hibernation image.
[    7.642884] PM: Image not found (code -22)
[    7.642886] PM: Hibernation image not present or could not be loaded.
[    7.645995] PM: Marking nosave pages: [mem 0x0009d000-0x000fffff]
[    7.646001] PM: Marking nosave pages: [mem 0xcff90000-0xffffffff]
[    7.646770] PM: Marking nosave pages: [mem 0xc4000000-0xc7ffffff]
[    7.646940] PM: Basic memory bitmaps created
[    7.663087] PM: Basic memory bitmaps freed
[    7.697662] kjournald starting.  Commit interval 5 seconds
[    7.697684] EXT3-fs (sda1): mounted filesystem with ordered data mode
[   10.022858] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[   10.022865] ACPI: Power Button [PWRB]
[   10.023033] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[   10.023036] ACPI: Power Button [PWRF]
[   10.047068] i2c i2c-0: nForce2 SMBus adapter at 0x600
[   10.047073] ACPI Warning: 0x0000000000000700-0x000000000000073f SystemIO conflicts with Region \SM00 1 (20120913/utaddress-251)
[   10.047078] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.082548] wmi: Mapper loaded
[   10.176538] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[   10.203287] microcode: AMD CPU family 0xf not supported
[   10.285064] [Firmware Bug]: ACPI(IGPU) defines _DOD but not _DOS
[   10.285191] ACPI: Video Device [IGPU] (multi-head: yes  rom: no  post: no)
[   10.285254] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:12/LNXVIDEO:00/input/input4
[   10.330930] EDAC MC: Ver: 3.0.0
[   10.382928] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   10.393422] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   10.576300] [drm] Initialized drm 1.1.0 20060810
[   10.595449] MCE: In-kernel MCE decoding enabled.
[   10.637493] AMD64 EDAC driver v3.4.0
[   10.637529] EDAC amd64: DRAM ECC disabled.
[   10.637532] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[   10.637532]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[   10.637532]  (Note that use of the override may cause unknown side effects.)
[   10.821232] parport_pc 00:05: reported by Plug and Play ACPI
[   10.821281] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   10.916365] ata3.00: exception Emask 0x12 SAct 0x0 SErr 0x400 action 0x6 frozen
[   10.916435] ata3.00: irq_stat 0x08000002, interface fatal error
[   10.916486] ata3: SError: { Proto }
[   10.916534] ata3.00: failed command: IDENTIFY PACKET DEVICE
[   10.916613] ata3.00: cmd a1/00:01:00:00:00/00:00:00:00:00/00 tag 0 pio 512 in
[   10.916613]          res 50/00:03:00:24:00/00:00:00:00:00/a0 Emask 0x12 (ATA bus error)
[   10.916705] ata3.00: status: { DRDY }
[   10.916754] ata3: hard resetting link
[   10.961027] Bluetooth: Core ver 2.16
[   10.961059] NET: Registered protocol family 31
[   10.961061] Bluetooth: HCI device and connection manager initialized
[   10.961254] Bluetooth: HCI socket layer initialized
[   10.961257] Bluetooth: L2CAP socket layer initialized
[   10.961263] Bluetooth: SCO socket layer initialized
[   10.992337] usbcore: registered new interface driver btusb
[   11.210817] kvm: Nested Virtualization enabled
[   11.236020] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   11.243841] powernow-k8: fid 0x14 (2800 MHz), vid 0xa
[   11.243845] powernow-k8: fid 0x12 (2600 MHz), vid 0xc
[   11.243846] powernow-k8: fid 0x10 (2400 MHz), vid 0xe
[   11.243847] powernow-k8: fid 0xe (2200 MHz), vid 0x10
[   11.243848] powernow-k8: fid 0xc (2000 MHz), vid 0x10
[   11.243850] powernow-k8: fid 0xa (1800 MHz), vid 0x10
[   11.243851] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
[   11.243883] powernow-k8: Found 1 AMD Athlon(tm) Processor LE-1660 (1 cpu cores) (version 2.20.00)
[   11.445895] MXM: GUID detected in BIOS
[   11.446145] nouveau 0000:02:00.0: setting latency timer to 64
[   11.446602] ACPI: PCI Interrupt Link [SGRU] enabled at IRQ 21
[   11.447218] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x0aa480a2
[   11.447226] nouveau  [  DEVICE][0000:02:00.0] Chipset: MCP77/MCP78 (NVAA)
[   11.447231] nouveau  [  DEVICE][0000:02:00.0] Family : NV50
[   11.450154] nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image...
[   11.498609] nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
[   11.498615] nouveau  [   VBIOS][0000:02:00.0] using image from PRAMIN
[   11.499115] nouveau  [   VBIOS][0000:02:00.0] BIT signature found
[   11.499123] nouveau  [   VBIOS][0000:02:00.0] version 62.77.35.00
[   11.530057] nouveau  [     MXM][0000:02:00.0] no VBIOS data, nothing to do
[   11.560999] nouveau  [     PFB][0000:02:00.0] RAM type: stolen system memory
[   11.561010] nouveau  [     PFB][0000:02:00.0] RAM size: 256 MiB
[   12.208023] i2c i2c-2: sendbytes: error -110
[   12.552480] ata3.00: configured for UDMA/100
[   12.740023] i2c i2c-2: sendbytes: error -110
[   13.324508] ata3: EH complete
[   13.940022] i2c i2c-2: sendbytes: error -110
[   14.136014] i2c i2c-2: sendbytes: error -110
[   14.137401] [TTM] Zone  kernel: Available graphics memory: 1901408 kiB
[   14.137408] [TTM] Initializing pool allocator
[   14.137420] [TTM] Initializing DMA pool allocator
[   14.137807] nouveau  [     DRM] VRAM: 256 MiB
[   14.137816] nouveau  [     DRM] GART: 512 MiB
[   14.137829] nouveau  [     DRM] BIT BIOS found
[   14.137836] nouveau  [     DRM] Bios version 62.77.35.00
[   14.137845] nouveau  [     DRM] TMDS table version 2.0
[   14.137851] nouveau  [     DRM] DCB version 4.0
[   14.137857] nouveau  [     DRM] DCB outp 00: 01000300 0000001e
[   14.137863] nouveau  [     DRM] DCB outp 01: 01011332 00020010
[   14.137868] nouveau  [     DRM] DCB conn 00: 00000000
[   14.137874] nouveau  [     DRM] DCB conn 01: 00003161
[   14.151539] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   14.151546] [drm] No driver support for vblank timestamp query.
[   14.344144] nouveau  [     DRM] 1 available performance level(s)
[   14.344159] nouveau  [     DRM] 0: core 500MHz shader 1200MHz voltage 1100mV fanspeed 100%
[   14.344165] nouveau  [     DRM] c:
[   14.387963] nouveau  [     DRM] MM: using M2MF for buffer copies
[   14.419955] nouveau  [     DRM] allocated 1024x768 fb: 0x50000, bo ffff88011a025800
[   14.420199] fbcon: nouveaufb (fb0) is primary device
[   14.439651] Console: switching to colour frame buffer device 128x48
[   14.440796] fb0: nouveaufb frame buffer device
[   14.440800] drm: registered panic notifier
[   14.444060] [drm] Initialized nouveau 1.1.0 20120801 for 0000:02:00.0 on minor 0
[   14.444884] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 20
[   14.444895] hda_intel: Disabling MSI
[   14.444981] snd_hda_intel 0000:00:07.0: setting latency timer to 64
[   16.172470] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:07.0/sound/card0/input6
[   16.172838] input: HDA NVidia Line as /devices/pci0000:00/0000:00:07.0/sound/card0/input7
[   16.173161] input: HDA NVidia Front Mic as /devices/pci0000:00/0000:00:07.0/sound/card0/input8
[   16.173469] input: HDA NVidia Rear Mic as /devices/pci0000:00/0000:00:07.0/sound/card0/input9
[   16.173786] input: HDA NVidia Front Headphone as /devices/pci0000:00/0000:00:07.0/sound/card0/input10
[   16.174093] input: HDA NVidia Line Out Side as /devices/pci0000:00/0000:00:07.0/sound/card0/input11
[   16.174388] input: HDA NVidia Line Out CLFE as /devices/pci0000:00/0000:00:07.0/sound/card0/input12
[   16.174695] input: HDA NVidia Line Out Surround as /devices/pci0000:00/0000:00:07.0/sound/card0/input13
[   16.174998] input: HDA NVidia Line Out Front as /devices/pci0000:00/0000:00:07.0/sound/card0/input14
[   17.289608] Adding 5662876k swap on /dev/sda5.  Priority:-1 extents:1 across:5662876k 
[   17.891037] EXT3-fs (sda1): using internal journal
[   18.123745] fuse init (API version 7.20)
[   18.173682] loop: module loaded
[   18.259479] it87: Found IT8712F chip at 0x290, revision 8
[   18.259496] it87: VID is disabled (pins used for GPIO)
[   18.259577] ACPI Warning: 0x0000000000000295-0x0000000000000296 SystemIO conflicts with Region \_SB_.PCI0.SBRG.SIOR.ECRE 1 (20120913/utaddress-251)
[   18.259591] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   21.276609] kjournald starting.  Commit interval 5 seconds
[   21.277109] EXT3-fs (sda7): using internal journal
[   21.277116] EXT3-fs (sda7): mounted filesystem with ordered data mode
[   21.376033] kjournald starting.  Commit interval 5 seconds
[   21.376537] EXT3-fs (sda6): using internal journal
[   21.376543] EXT3-fs (sda6): mounted filesystem with ordered data mode
[   23.702780] ip_tables: (C) 2000-2006 Netfilter Core Team
[   23.970138] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   24.362264] forcedeth 0000:00:0a.0: irq 41 for MSI/MSI-X
[   24.362342] forcedeth 0000:00:0a.0 eth0: MSI enabled
[   27.734155] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   30.092195] Loading iSCSI transport class v2.0-870.
[   30.121060] iscsi: registered transport (tcp)
[   30.238950] iscsi: registered transport (iser)
[   31.820186] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input15
[   33.235834] sit: IPv6 over IPv4 tunneling driver
[   33.278318] tun: Universal TUN/TAP device driver, 1.6
[   33.278326] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   38.256123] Bluetooth: RFCOMM TTY layer initialized
[   38.256166] Bluetooth: RFCOMM socket layer initialized
[   38.256170] Bluetooth: RFCOMM ver 1.11
[   38.330314] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   38.330323] Bluetooth: BNEP filters: protocol multicast
[   38.330348] Bluetooth: BNEP socket layer initialized
[   40.418155] lp0: using parport0 (interrupt-driven).
[   40.529256] ppdev: user-space parallel port driver
[   47.517752] Bridge firewalling registered
[   48.144822] IPv6: ADDRCONF(NETDEV_UP): virbr0: link is not ready
[   50.290818] Ebtables v2.0 registered
[   85.609241] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   85.609274] Bluetooth: HIDP socket layer initialized
[  115.819460] BUG: unable to handle kernel paging request at fffffffffffffff8
[  115.819521] IP: [<ffffffffa033267a>] nouveau_mm_head+0x30/0x127 [nouveau]
[  115.819632] PGD 160d067 PUD 160e067 PMD 0 
[  115.819656] Oops: 0000 [#1] SMP 
[  115.819676] Modules linked in: hidp ebtable_nat ebtables cpufreq_powersave cpufreq_conservative cpufreq_stats cpufreq_userspace ipt_MASQUERADE xt_CHECKSUM bridge stp llc ppdev lp bnep rfcomm tun sit tunnel4 binfmt_misc uinput ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip6table_raw ip6table_mangle ip6t_REJECT xt_LOG nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_rt ip6table_filter ip6_tables xt_tcpudp ipt_REJECT ipt_ULOG xt_limit xt_multiport xt_conntrack iptable_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_raw ip_tables x_tables hwmon_vid loop fuse snd_hda_codec_hdmi snd_hda_codec_via snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_seq_midi nouveau snd_seq_midi_event snd_rawmidi powernow_k8 kvm_amd kvm snd_seq btusb bluetooth rfkill parport_pc parport ttm drm_kms_helper snd_seq_device snd_timer edac_mce_amd snd drm i2c
_algo_bit shpchp pcspkr mxm_wmi edac_core video crc16 soundcore k8temp evdev processor asus_atk0110 wmi thermal_sys i2c_nforce2 i2c_core button ext3 mbcache jbd dm_mod sg hid_generic sr_mod sd_mod cdrom crc_t10dif usbhid usb_storage hid uas ahci libahci libata forcedeth ohci_hcd scsi_mod ehci_hcd floppy usbcore usb_common
[  115.820391] CPU 0 
[  115.820405] Pid: 2953, comm: Xorg Not tainted 3.7.0-rc3-ao2 #1 System manufacturer System Product Name/M3N78-VM
[  115.820434] RIP: 0010:[<ffffffffa033267a>]  [<ffffffffa033267a>] nouveau_mm_head+0x30/0x127 [nouveau]
[  115.820494] RSP: 0018:ffff88011839d9a8  EFLAGS: 00010212
[  115.820510] RAX: 00000000ffffffff RBX: fffffffffffffff0 RCX: 000000000000000c
[  115.820531] RDX: 000000000000000c RSI: 0000000000000001 RDI: ffff8801182f60e8
[  115.820551] RBP: ffff8800cfa16f78 R08: 0000000000000000 R09: ffff8800cfa16f78
[  115.820572] R10: ffff8801182f6000 R11: ffff8800cfa16ec0 R12: 000000000000000c
[  115.820592] R13: ffff8801182f6001 R14: ffff8801182f6020 R15: ffff88011839da70
[  115.820614] FS:  00007f93e340d880(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
[  115.820635] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  115.820652] CR2: fffffffffffffff8 CR3: 000000011874f000 CR4: 00000000000007f0
[  115.820673] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  115.820693] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  115.820712] Process Xorg (pid: 2953, threadinfo ffff88011839c000, task ffff880117e2a040)
[  115.820732] Stack:
[  115.820740]  0000000000000246 ffffffff810fa13d ffffffff81060f13 0000000000000060
[  115.820774]  0000000000000002 0000000000000010 ffff8801182f6000 ffff8801182f6020
[  115.820805]  ffff88011839da70 ffffffffa034210a 0000000000000000 00000060810c7d9e
[  115.820835] Call Trace:
[  115.820857]  [<ffffffff810fa13d>] ? kmem_cache_alloc_trace+0xbf/0xcf
[  115.820883]  [<ffffffff81060f13>] ? should_resched+0x5/0x23
[  115.820941]  [<ffffffffa034210a>] ? nv50_fb_vram_new+0xc5/0x1f2 [nouveau]
[  115.821009]  [<ffffffffa03807b6>] ? nouveau_vram_manager_new+0x62/0xa4 [nouveau]
[  115.821051]  [<ffffffffa0251d34>] ? ttm_bo_mem_space+0x112/0x2f8 [ttm]
[  115.821083]  [<ffffffffa0251fbd>] ? ttm_bo_move_buffer+0xa3/0xee [ttm]
[  115.821105]  [<ffffffff810fa13d>] ? kmem_cache_alloc_trace+0xbf/0xcf
[  115.821136]  [<ffffffffa02520ae>] ? ttm_bo_validate+0xa6/0xeb [ttm]
[  115.821166]  [<ffffffffa0252466>] ? ttm_bo_init+0x373/0x3b2 [ttm]
[  115.821232]  [<ffffffffa0382021>] ? nouveau_bo_new+0x23f/0x264 [nouveau]
[  115.821292]  [<ffffffffa0381c55>] ? nouveau_ttm_tt_unpopulate+0xa3/0xa3 [nouveau]
[  115.821292]  [<ffffffffa038377a>] ? nouveau_gem_new+0x53/0xf7 [nouveau]
[  115.821292]  [<ffffffff81060f13>] ? should_resched+0x5/0x23
[  115.821292]  [<ffffffff8137031a>] ? _cond_resched+0x6/0x1b
[  115.821292]  [<ffffffffa03838bd>] ? nouveau_gem_ioctl_new+0x9f/0x107 [nouveau]
[  115.821292]  [<ffffffffa020107b>] ? drm_gem_flink_ioctl+0xc1/0xde [drm]
[  115.821292]  [<ffffffffa01ff603>] ? drm_ioctl+0x28c/0x36a [drm]
[  115.821292]  [<ffffffff810dfe6e>] ? handle_pte_fault+0x6ff/0x770
[  115.821292]  [<ffffffffa038381e>] ? nouveau_gem_new+0xf7/0xf7 [nouveau]
[  115.821292]  [<ffffffff81373f12>] ? __do_page_fault+0x2d8/0x376
[  115.821292]  [<ffffffff8110eb82>] ? vfs_ioctl+0x1e/0x31
[  115.821292]  [<ffffffff8110f3ba>] ? do_vfs_ioctl+0x3ee/0x430
[  115.821292]  [<ffffffff8110289c>] ? vfs_read+0xac/0xf5
[  115.821292]  [<ffffffff8110f449>] ? sys_ioctl+0x4d/0x7c
[  115.821292]  [<ffffffff81376129>] ? system_call_fastpath+0x16/0x1b
[  115.821292] Code: 44 89 c0 41 56 f7 d0 41 55 41 88 f5 41 54 41 89 d4 55 4c 89 cd 53 48 83 ec 18 48 8b 5f 10 89 44 24 0c 48 83 eb 10 e9 da 00 00 00 <48> 8b 43 08 44 8b 53 34 44 8b 7b 38 48 39 f8 45 89 d3 47 8d 0c 
[  115.821292] RIP  [<ffffffffa033267a>] nouveau_mm_head+0x30/0x127 [nouveau]
[  115.821292]  RSP <ffff88011839d9a8>
[  115.821292] CR2: fffffffffffffff8
[  115.821292] ---[ end trace cc9ee83770ef32d5 ]---
[  117.838087] nouveau E[     DRM] EvoCh 1 Mthd 0x0080 Data 0x00000000 (0x000b 0x05)
[  117.840022] [sched_delayed] sched: RT throttling activated

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
