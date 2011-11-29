Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1K2Lde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:33:34 -0500
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:55620 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752143Ab1K2Ld2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:33:28 -0500
Message-ID: <1322566405.1834.11.camel@tellur>
Subject: Re: Hangs with Linux 3.2.0-rc3
From: Lucas Stach <dev@lynxeye.de>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Tue, 29 Nov 2011 12:33:25 +0100
In-Reply-To: <20111129080655.GA12809@x1.osrc.amd.com>
References: <1322552218.1679.5.camel@tellur>
	 <20111129080655.GA12809@x1.osrc.amd.com>
Content-Type: multipart/mixed; boundary="=-wQL0t+x3avgBlScYCzTB"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wQL0t+x3avgBlScYCzTB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Am Dienstag, den 29.11.2011, 09:06 +0100 schrieb Borislav Petkov:
> Hi,
> 
> On Tue, Nov 29, 2011 at 08:36:58AM +0100, Lucas Stach wrote:
> > [please cc me on every answer, I'm not on the list]
> > 
> > Hi,
> > 
> > since a few days I get lockups every few hours. I think it's related to
> > me installing a the 3.2.0-rc3 kernel. I can't say for sure if the
> > problem existed in earlier rc's as it only happens after a few hours of
> > work on this machine and I haven't had time to retest the other rc's.
> 
> yeah, that might help as a sort of a coarse-grained bisection. I haven't
> seen any issues with 3.1 so far.
> 
> But it looks like this is a Bulldozer in a Gigabyte board, correct? Can
> you send full dmesg from the boot along with /proc/cpuinfo please?
> 

Yep, you are right, this is a FX-8150 on a Gigabyte Ga-970A-UD3 with
latest (F5a) BIOS. Now that I think about it I remember I updated the
BIOS some days ago, but only change according to Gigabyte website is an
update to a newer AGESA version. Don't know if this could be related.

I will change back to rc2 kernel today to see if the problem persists. I
don't know if the problem could be workload dependent, but I had done
some burn-in tests with this system with older BIOS (F4) and 3.2.0-rc2
kernel where I had 100% sustained cpu load on all cores where I didn't
encounter any lockups in more than 48h, now I use the system under low
load with occasional spikes and have lockups every few hours.

You will find the full dmesg of a fresh boot and cpuinfo attached to
this mail.

Sorry I have so much variables in here, but this is a relatively new
system and therefore it's still a bit in flux.

Thanks,
Lucas
> Thanks.
> 
> Leaving the rest in for Andreas.
> 
> > If I can be of any help tracking this down, I gladly test patches.
> > 
> > Backtrace as found in syslog:
> > 
[snip]

--=-wQL0t+x3avgBlScYCzTB
Content-Disposition: attachment; filename="dmesg"
Content-Type: text/plain; name="dmesg"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.0-rc3+ (lynxeye@tellur) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #39 SMP Thu Nov 24 09:16:34 CET 2011
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.2.0-rc3+ root=UUID=ce4247a8-ba04-4b2f-8f86-38b183755e5d ro quiet rhgb
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009b800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfda0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfda0000 - 00000000cfdd1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfdd1000 - 00000000cfe00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfe00000 - 00000000cff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000042f000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. GA-970A-UD3/GA-970A-UD3, BIOS F5a 11/25/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x42f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 base 0000CFE00000 mask FFFFFFE00000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000042f000000 aka 17136M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 256MB, type WB
[    0.000000] reg 3, base: 3326MB, range: 2MB, type UC
[    0.000000] total RAM covered: 3326M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 4M 	num_reg: 4  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 256MB, type WB
[    0.000000] reg 3, base: 3326MB, range: 2MB, type UC
[    0.000000] e820 update range: 00000000cfe00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcfda0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f4c10] f4c10
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 20480
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfda0000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00cfc00000 page 2M
[    0.000000]  00cfc00000 - 00cfda0000 page 4k
[    0.000000] kernel direct mapping tables up to cfda0000 @ 1fffd000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000042f000000
[    0.000000]  0100000000 - 0400000000 page 1G
[    0.000000]  0400000000 - 042f000000 page 2M
[    0.000000] kernel direct mapping tables up to 42f000000 @ cfd9e000-cfda0000
[    0.000000] RAMDISK: 358c0000 - 36c58000
[    0.000000] ACPI: RSDP 00000000000f6b30 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000cfdd1000 0004C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 00000000cfdd1080 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000cfdd1100 0792A (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000cfda0000 00040
[    0.000000] ACPI: MSDM 00000000cfdd8b00 00055 (v03 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: HPET 00000000cfdd8b80 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000cfdd8bc0 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: MATS 00000000cfdd8c40 00034 (v01 GBT             00000000      00000000)
[    0.000000] ACPI: TAMG 00000000cfdd8cb0 00182 (v01 GBT    GBT   B0 5455312E BG?? 53450101)
[    0.000000] ACPI: APIC 00000000cfdd8a40 000BC (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: MATS 00000000cfdd8e40 061FE (v01        MATS RCM 80000001 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000cfddf0b0 01714 (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: IVRS 00000000cfde0840 000D8 (v01  AMD     RD890S 00202031 AMD  00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000042f000000
[    0.000000] Initmem setup node 0 0000000000000000-000000042f000000
[    0.000000]   NODE_DATA [000000042efec000 - 000000042effffff]
[    0.000000]  [ffffea0000000000-ffffea0010bfffff] PMD -> [ffff88041e600000-ffff88042e5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0042f000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000cfda0
[    0.000000]     0: 0x00100000 -> 0x0042f000
[    0.000000] On node 0 totalpages: 4189483
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3910 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 830944 pages, LIFO batch:31
[    0.000000]   Normal zone: 52160 pages used for memmap
[    0.000000]   Normal zone: 3286080 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
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
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cfda0000 - 00000000cfdd1000
[    0.000000] PM: Registered nosave memory: 00000000cfdd1000 - 00000000cfe00000
[    0.000000] PM: Registered nosave memory: 00000000cfe00000 - 00000000cff00000
[    0.000000] PM: Registered nosave memory: 00000000cff00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at cff00000 (gap: cff00000:10100000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88042ec00000 s82112 r8192 d24384 u262144
[    0.000000] pcpu-alloc: s82112 r8192 d24384 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4120934
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.2.0-rc3+ root=UUID=ce4247a8-ba04-4b2f-8f86-38b183755e5d ro quiet rhgb
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 4ae4000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ c4000000
[    0.000000] PM: Registered nosave memory: 00000000c4000000 - 00000000c8000000
[    0.000000] Memory: 16328924k/17547264k available (4816k kernel code, 789332k absent, 429008k reserved, 6767k data, 932k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:16640 nr_irqs:744 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 134217728 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3623.753 MHz processor.
[    0.001003] Calibrating delay loop (skipped), value calculated using timer frequency.. 7247.50 BogoMIPS (lpj=3623753)
[    0.001006] pid_max: default: 32768 minimum: 301
[    0.001026] Security Framework initialized
[    0.001032] SELinux:  Initializing.
[    0.001039] SELinux:  Starting in permissive mode
[    0.003055] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.006912] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.008434] Mount-cache hash table entries: 256
[    0.008542] Initializing cgroup subsys cpuacct
[    0.008547] Initializing cgroup subsys memory
[    0.008557] Initializing cgroup subsys devices
[    0.008559] Initializing cgroup subsys freezer
[    0.008560] Initializing cgroup subsys net_cls
[    0.008561] Initializing cgroup subsys blkio
[    0.008566] Initializing cgroup subsys perf_event
[    0.008587] tseg: 00cff00000
[    0.008589] CPU: Physical Processor ID: 0
[    0.008590] CPU: Processor Core ID: 0
[    0.008591] mce: CPU supports 7 MCE banks
[    0.008874] ACPI: Core revision 20110623
[    0.011018] ftrace: allocating 24643 entries in 97 pages
[    0.012345] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.022500] CPU0: AMD FX(tm)-8150 Eight-Core Processor            stepping 02
[    0.022998] Performance Events: AMD Family 15h PMU driver.
[    0.022998] ... version:                0
[    0.022998] ... bit width:              48
[    0.022998] ... generic registers:      6
[    0.022998] ... value mask:             0000ffffffffffff
[    0.022998] ... max period:             00007fffffffffff
[    0.022998] ... fixed-purpose events:   0
[    0.022998] ... event mask:             000000000000003f
[    0.022998] NMI watchdog enabled, takes one hw-pmu counter.
[    0.022998] Booting Node   0, Processors  #1
[    0.022998] smpboot cpu 1: start_ip = 96000
[    0.094011] NMI watchdog enabled, takes one hw-pmu counter.
[    0.094102]  #2
[    0.094103] smpboot cpu 2: start_ip = 96000
[    0.165995] NMI watchdog enabled, takes one hw-pmu counter.
[    0.166057]  #3
[    0.166058] smpboot cpu 3: start_ip = 96000
[    0.237985] NMI watchdog enabled, takes one hw-pmu counter.
[    0.238052]  #4
[    0.238053] smpboot cpu 4: start_ip = 96000
[    0.309973] NMI watchdog enabled, takes one hw-pmu counter.
[    0.310047]  #5
[    0.310048] smpboot cpu 5: start_ip = 96000
[    0.381963] NMI watchdog enabled, takes one hw-pmu counter.
[    0.382037]  #6
[    0.382038] smpboot cpu 6: start_ip = 96000
[    0.453952] NMI watchdog enabled, takes one hw-pmu counter.
[    0.454016]  #7 Ok.
[    0.454017] smpboot cpu 7: start_ip = 96000
[    0.525941] NMI watchdog enabled, takes one hw-pmu counter.
[    0.525957] Brought up 8 CPUs
[    0.525959] Total of 8 processors activated (57982.83 BogoMIPS).
[    0.527071] devtmpfs: initialized
[    0.532639] PM: Registering ACPI NVS region at cfda0000 (200704 bytes)
[    0.533245] xor: automatically using best checksumming function: generic_sse
[    0.537929]    generic_sse:  9980.000 MB/sec
[    0.537931] xor: using function: generic_sse (9980.000 MB/sec)
[    0.537936] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.537950] RTC time: 18:46:44, date: 11/29/11
[    0.537977] NET: Registered protocol family 16
[    0.538076] Extended Config Space enabled on 1 nodes
[    0.538182] ACPI: bus type pci registered
[    0.538232] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.538235] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.560214] PCI: Using configuration type 1 for base access
[    0.561411] bio: create slab <bio-0> at 0
[    0.577951] raid6: int64x1   1898 MB/s
[    0.594941] raid6: int64x2   2140 MB/s
[    0.611931] raid6: int64x4   2222 MB/s
[    0.628934] raid6: int64x8   1527 MB/s
[    0.645916] raid6: sse2x1    4738 MB/s
[    0.662912] raid6: sse2x2    9625 MB/s
[    0.679908] raid6: sse2x4   12410 MB/s
[    0.679909] raid6: using algorithm sse2x4 (12410 MB/s)
[    0.679930] ACPI: Added _OSI(Module Device)
[    0.679932] ACPI: Added _OSI(Processor Device)
[    0.679933] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.679935] ACPI: Added _OSI(Processor Aggregator Device)
[    0.680831] ACPI: EC: Look up EC in DSDT
[    0.688059] ACPI Warning: Incorrect checksum in table [TAMG] - 0xD2, should be 0xD1 (20110623/tbutils-314)
[    0.689004] ACPI: Interpreter enabled
[    0.689008] ACPI: (supports S0 S3 S4 S5)
[    0.689028] ACPI: Using IOAPIC for interrupt routing
[    0.707284] ACPI: No dock devices found.
[    0.707286] HEST: Table not found.
[    0.707289] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.707344] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.707461] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.707463] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.707466] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.707468] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.707470] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.707472] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xfebfffff]
[    0.707485] pci 0000:00:00.0: [1002:5a14] type 0 class 0x000600
[    0.707496] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
[    0.707531] pci 0000:00:00.2: [1002:5a23] type 0 class 0x000806
[    0.707577] pci 0000:00:02.0: [1002:5a16] type 1 class 0x000604
[    0.707601] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.707604] pci 0000:00:02.0: PME# disabled
[    0.707619] pci 0000:00:04.0: [1002:5a18] type 1 class 0x000604
[    0.707642] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.707645] pci 0000:00:04.0: PME# disabled
[    0.707661] pci 0000:00:09.0: [1002:5a1c] type 1 class 0x000604
[    0.707685] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.707687] pci 0000:00:09.0: PME# disabled
[    0.707700] pci 0000:00:0a.0: [1002:5a1d] type 1 class 0x000604
[    0.707724] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.707726] pci 0000:00:0a.0: PME# disabled
[    0.707749] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    0.707763] pci 0000:00:11.0: reg 10: [io  0xff00-0xff07]
[    0.707771] pci 0000:00:11.0: reg 14: [io  0xfe00-0xfe03]
[    0.707779] pci 0000:00:11.0: reg 18: [io  0xfd00-0xfd07]
[    0.707786] pci 0000:00:11.0: reg 1c: [io  0xfc00-0xfc03]
[    0.707793] pci 0000:00:11.0: reg 20: [io  0xfb00-0xfb0f]
[    0.707801] pci 0000:00:11.0: reg 24: [mem 0xfdfff000-0xfdfff3ff]
[    0.707836] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.707846] pci 0000:00:12.0: reg 10: [mem 0xfdffe000-0xfdffefff]
[    0.707904] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.707918] pci 0000:00:12.2: reg 10: [mem 0xfdffd000-0xfdffd0ff]
[    0.707971] pci 0000:00:12.2: supports D1 D2
[    0.707973] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.707981] pci 0000:00:12.2: PME# disabled
[    0.707999] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.708009] pci 0000:00:13.0: reg 10: [mem 0xfdffc000-0xfdffcfff]
[    0.708061] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.708076] pci 0000:00:13.2: reg 10: [mem 0xfdffb000-0xfdffb0ff]
[    0.708127] pci 0000:00:13.2: supports D1 D2
[    0.708129] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.708132] pci 0000:00:13.2: PME# disabled
[    0.708148] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.708202] pci 0000:00:14.1: [1002:439c] type 0 class 0x000101
[    0.708212] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.708220] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.708227] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.708234] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.708242] pci 0000:00:14.1: reg 20: [io  0xfa00-0xfa0f]
[    0.708269] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.708285] pci 0000:00:14.2: reg 10: [mem 0xfdff4000-0xfdff7fff 64bit]
[    0.708328] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.708332] pci 0000:00:14.2: PME# disabled
[    0.708342] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.708398] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.708429] pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
[    0.708439] pci 0000:00:14.5: reg 10: [mem 0xfdffa000-0xfdffafff]
[    0.708494] pci 0000:00:15.0: [1002:43a0] type 1 class 0x000604
[    0.708535] pci 0000:00:15.0: supports D1 D2
[    0.708551] pci 0000:00:16.0: [1002:4397] type 0 class 0x000c03
[    0.708562] pci 0000:00:16.0: reg 10: [mem 0xfdff9000-0xfdff9fff]
[    0.708614] pci 0000:00:16.2: [1002:4396] type 0 class 0x000c03
[    0.708628] pci 0000:00:16.2: reg 10: [mem 0xfdff8000-0xfdff80ff]
[    0.708680] pci 0000:00:16.2: supports D1 D2
[    0.708681] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.708685] pci 0000:00:16.2: PME# disabled
[    0.708701] pci 0000:00:18.0: [1022:1600] type 0 class 0x000600
[    0.708717] pci 0000:00:18.1: [1022:1601] type 0 class 0x000600
[    0.708730] pci 0000:00:18.2: [1022:1602] type 0 class 0x000600
[    0.708744] pci 0000:00:18.3: [1022:1603] type 0 class 0x000600
[    0.708760] pci 0000:00:18.4: [1022:1604] type 0 class 0x000600
[    0.708775] pci 0000:00:18.5: [1022:1605] type 0 class 0x000600
[    0.708823] pci 0000:01:00.0: [10de:05e2] type 0 class 0x000300
[    0.708831] pci 0000:01:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
[    0.708841] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.708850] pci 0000:01:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
[    0.708857] pci 0000:01:00.0: reg 24: [io  0xcf00-0xcf7f]
[    0.708863] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.709920] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.709924] pci 0000:00:02.0:   bridge window [io  0xc000-0xcfff]
[    0.709926] pci 0000:00:02.0:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.709931] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.709971] pci 0000:02:00.0: [1b6f:7023] type 0 class 0x000c03
[    0.709986] pci 0000:02:00.0: reg 10: [mem 0xfd9f8000-0xfd9fffff 64bit]
[    0.710038] pci 0000:02:00.0: supports D1 D2
[    0.710040] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.710043] pci 0000:02:00.0: PME# disabled
[    0.711914] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    0.711918] pci 0000:00:04.0:   bridge window [io  0xb000-0xbfff]
[    0.711920] pci 0000:00:04.0:   bridge window [mem 0xfd900000-0xfd9fffff]
[    0.711924] pci 0000:00:04.0:   bridge window [mem 0xfd600000-0xfd6fffff 64bit pref]
[    0.711960] pci 0000:03:00.0: [10ec:8168] type 0 class 0x000200
[    0.711972] pci 0000:03:00.0: reg 10: [io  0xee00-0xeeff]
[    0.711992] pci 0000:03:00.0: reg 18: [mem 0xfdeff000-0xfdefffff 64bit pref]
[    0.712005] pci 0000:03:00.0: reg 20: [mem 0xfdef8000-0xfdefbfff 64bit pref]
[    0.712039] pci 0000:03:00.0: supports D1 D2
[    0.712041] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.712045] pci 0000:03:00.0: PME# disabled
[    0.713914] pci 0000:00:09.0: PCI bridge to [bus 03-03]
[    0.713918] pci 0000:00:09.0:   bridge window [io  0xe000-0xefff]
[    0.713921] pci 0000:00:09.0:   bridge window [mem 0xfd500000-0xfd5fffff]
[    0.713924] pci 0000:00:09.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.713964] pci 0000:04:00.0: [1b6f:7023] type 0 class 0x000c03
[    0.713979] pci 0000:04:00.0: reg 10: [mem 0xfddf8000-0xfddfffff 64bit]
[    0.714032] pci 0000:04:00.0: supports D1 D2
[    0.714033] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.714037] pci 0000:04:00.0: PME# disabled
[    0.715911] pci 0000:00:0a.0: PCI bridge to [bus 04-04]
[    0.715915] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    0.715918] pci 0000:00:0a.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.715921] pci 0000:00:0a.0:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.715961] pci 0000:05:0e.0: [1106:3044] type 0 class 0x000c00
[    0.715980] pci 0000:05:0e.0: reg 10: [mem 0xfdbff000-0xfdbff7ff]
[    0.715991] pci 0000:05:0e.0: reg 14: [io  0xaf00-0xaf7f]
[    0.716056] pci 0000:05:0e.0: supports D2
[    0.716058] pci 0000:05:0e.0: PME# supported from D2 D3hot D3cold
[    0.716062] pci 0000:05:0e.0: PME# disabled
[    0.716091] pci 0000:00:14.4: PCI bridge to [bus 05-05] (subtractive decode)
[    0.716094] pci 0000:00:14.4:   bridge window [io  0xa000-0xafff]
[    0.716098] pci 0000:00:14.4:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.716101] pci 0000:00:14.4:   bridge window [mem 0xfda00000-0xfdafffff pref]
[    0.716104] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.716106] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.716108] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.716111] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.716113] pci 0000:00:14.4:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.716115] pci 0000:00:14.4:   bridge window [mem 0xd0000000-0xfebfffff] (subtractive decode)
[    0.716151] pci 0000:00:15.0: PCI bridge to [bus 06-06]
[    0.716156] pci 0000:00:15.0:   bridge window [io  0x9000-0x9fff]
[    0.716159] pci 0000:00:15.0:   bridge window [mem 0xfd800000-0xfd8fffff]
[    0.716164] pci 0000:00:15.0:   bridge window [mem 0xfd700000-0xfd7fffff 64bit pref]
[    0.716180] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.716513] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.716557] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.716626] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.716661] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
[    0.716701] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
[    0.716733] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.716772]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.716775]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.716777] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.731195] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0
[    0.731235] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0
[    0.731273] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0
[    0.731311] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0
[    0.731351] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0
[    0.731388] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0
[    0.731426] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0
[    0.731463] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0
[    0.731541] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.731541] vgaarb: loaded
[    0.731541] vgaarb: bridge control possible 0000:01:00.0
[    0.731541] SCSI subsystem initialized
[    0.731578] libata version 3.00 loaded.
[    0.731578] usbcore: registered new interface driver usbfs
[    0.731578] usbcore: registered new interface driver hub
[    0.731578] usbcore: registered new device driver usb
[    0.731578] PCI: Using ACPI for IRQ routing
[    0.738131] PCI: pci_cache_line_size set to 64 bytes
[    0.738140] pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
[    0.738215] reserve RAM buffer: 000000000009b800 - 000000000009ffff 
[    0.738217] reserve RAM buffer: 00000000cfda0000 - 00000000cfffffff 
[    0.738221] reserve RAM buffer: 000000042f000000 - 000000042fffffff 
[    0.738301] NetLabel: Initializing
[    0.738303] NetLabel:  domain hash size = 128
[    0.738304] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.738313] NetLabel:  unlabeled traffic allowed by default
[    0.738325] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.738329] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.739934] Switching to clocksource hpet
[    0.747814] pnp: PnP ACPI init
[    0.747824] ACPI: bus type pnp registered
[    0.747896] pnp 00:00: [bus 00-ff]
[    0.747898] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.747900] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.747902] pnp 00:00: [io  0x0d00-0xffff window]
[    0.747904] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.747906] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.747908] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.747910] pnp 00:00: [mem 0xd0000000-0xfebfffff window]
[    0.747946] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.747956] pnp 00:01: [io  0x0010-0x001f]
[    0.747958] pnp 00:01: [io  0x0022-0x003f]
[    0.747960] pnp 00:01: [io  0x0044-0x004d]
[    0.747961] pnp 00:01: [io  0x0050-0x005f]
[    0.747963] pnp 00:01: [io  0x0062-0x0063]
[    0.747964] pnp 00:01: [io  0x0065-0x006f]
[    0.747966] pnp 00:01: [io  0x0074-0x007f]
[    0.747967] pnp 00:01: [io  0x0091-0x0093]
[    0.747969] pnp 00:01: [io  0x00a2-0x00bf]
[    0.747970] pnp 00:01: [io  0x00e0-0x00ef]
[    0.747972] pnp 00:01: [io  0x04d0-0x04d1]
[    0.747973] pnp 00:01: [io  0x0220-0x0225]
[    0.747975] pnp 00:01: [io  0x0290-0x0294]
[    0.748032] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.748035] system 00:01: [io  0x0220-0x0225] has been reserved
[    0.748037] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.748040] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.748518] pnp 00:02: [io  0x0900-0x091f]
[    0.748521] pnp 00:02: [io  0x0228-0x022f]
[    0.748523] pnp 00:02: [io  0x040b]
[    0.748524] pnp 00:02: [io  0x04d6]
[    0.748526] pnp 00:02: [io  0x0c00-0x0c01]
[    0.748527] pnp 00:02: [io  0x0c14]
[    0.748529] pnp 00:02: [io  0x0c50-0x0c52]
[    0.748530] pnp 00:02: [io  0x0c6c-0x0c6d]
[    0.748532] pnp 00:02: [io  0x0c6f]
[    0.748536] pnp 00:02: [io  0x0cd0-0x0cd1]
[    0.748537] pnp 00:02: [io  0x0cd2-0x0cd3]
[    0.748539] pnp 00:02: [io  0x0cd4-0x0cdf]
[    0.748541] pnp 00:02: [io  0x0800-0x08fe]
[    0.748542] pnp 00:02: [io  0x0a10-0x0a17]
[    0.748544] pnp 00:02: [io  0x0b00-0x0b0f]
[    0.748545] pnp 00:02: [io  0x0b10-0x0b1f]
[    0.748547] pnp 00:02: [io  0x0b20-0x0b3f]
[    0.748548] pnp 00:02: [mem 0x00000000-0x00000fff window]
[    0.748550] pnp 00:02: [mem 0xfee00400-0xfee00fff window]
[    0.748555] pnp 00:02: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.748583] pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x0007ffff pref]
[    0.748616] system 00:02: [io  0x0900-0x091f] has been reserved
[    0.748618] system 00:02: [io  0x0228-0x022f] has been reserved
[    0.748620] system 00:02: [io  0x040b] has been reserved
[    0.748622] system 00:02: [io  0x04d6] has been reserved
[    0.748625] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.748627] system 00:02: [io  0x0c14] has been reserved
[    0.748629] system 00:02: [io  0x0c50-0x0c52] has been reserved
[    0.748631] system 00:02: [io  0x0c6c-0x0c6d] has been reserved
[    0.748633] system 00:02: [io  0x0c6f] has been reserved
[    0.748635] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    0.748637] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    0.748639] system 00:02: [io  0x0cd4-0x0cdf] has been reserved
[    0.748641] system 00:02: [io  0x0800-0x08fe] has been reserved
[    0.748643] system 00:02: [io  0x0a10-0x0a17] has been reserved
[    0.748647] system 00:02: [io  0x0b00-0x0b0f] has been reserved
[    0.748650] system 00:02: [io  0x0b10-0x0b1f] has been reserved
[    0.748652] system 00:02: [io  0x0b20-0x0b3f] has been reserved
[    0.748654] system 00:02: [mem 0xfee00400-0xfee00fff window] has been reserved
[    0.748657] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.748750] pnp 00:03: [dma 4]
[    0.748752] pnp 00:03: [io  0x0000-0x000f]
[    0.748753] pnp 00:03: [io  0x0080-0x0090]
[    0.748755] pnp 00:03: [io  0x0094-0x009f]
[    0.748757] pnp 00:03: [io  0x00c0-0x00df]
[    0.748784] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.748834] pnp 00:04: [irq 0 disabled]
[    0.748840] pnp 00:04: [irq 8]
[    0.748842] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.748870] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.748898] pnp 00:05: [io  0x0070-0x0073]
[    0.748923] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.748931] pnp 00:06: [io  0x0061]
[    0.748957] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.748965] pnp 00:07: [io  0x00f0-0x00ff]
[    0.748969] pnp 00:07: [irq 13]
[    0.748996] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.749283] pnp 00:08: [io  0x03f8-0x03ff]
[    0.749287] pnp 00:08: [irq 4]
[    0.749337] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.749395] pnp 00:09: [mem 0xe0000000-0xefffffff]
[    0.749445] system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
[    0.749447] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.749597] pnp 00:0a: [mem 0x000d4200-0x000d7fff]
[    0.749599] pnp 00:0a: [mem 0x000f0000-0x000f7fff]
[    0.749600] pnp 00:0a: [mem 0x000f8000-0x000fbfff]
[    0.749602] pnp 00:0a: [mem 0x000fc000-0x000fffff]
[    0.749604] pnp 00:0a: [mem 0xcfda0000-0xcfdfffff]
[    0.749606] pnp 00:0a: [mem 0xffff0000-0xffffffff]
[    0.749607] pnp 00:0a: [mem 0x00000000-0x0009ffff]
[    0.749609] pnp 00:0a: [mem 0x00100000-0xcfd9ffff]
[    0.749611] pnp 00:0a: [mem 0xcfe00000-0xcfefffff]
[    0.749614] pnp 00:0a: [mem 0xcff00000-0xcfffffff]
[    0.749616] pnp 00:0a: [mem 0xfec00000-0xfec00fff]
[    0.749618] pnp 00:0a: [mem 0xfee00000-0xfee00fff]
[    0.749619] pnp 00:0a: [mem 0xfff80000-0xfffeffff]
[    0.749623] pnp 00:0a: disabling [mem 0x000d4200-0x000d7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.749626] pnp 00:0a: disabling [mem 0x000f0000-0x000f7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.749630] pnp 00:0a: disabling [mem 0x000f8000-0x000fbfff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.749633] pnp 00:0a: disabling [mem 0x000fc000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.749636] pnp 00:0a: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.749639] pnp 00:0a: disabling [mem 0x00100000-0xcfd9ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.749703] system 00:0a: [mem 0xcfda0000-0xcfdfffff] could not be reserved
[    0.749706] system 00:0a: [mem 0xffff0000-0xffffffff] has been reserved
[    0.749708] system 00:0a: [mem 0xcfe00000-0xcfefffff] has been reserved
[    0.749711] system 00:0a: [mem 0xcff00000-0xcfffffff] could not be reserved
[    0.749713] system 00:0a: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.749716] system 00:0a: [mem 0xfee00000-0xfee00fff] could not be reserved
[    0.749718] system 00:0a: [mem 0xfff80000-0xfffeffff] has been reserved
[    0.749721] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.749739] pnp: PnP ACPI: found 11 devices
[    0.749740] ACPI: ACPI bus type pnp unregistered
[    0.756405] PCI: max bus depth: 1 pci_try_num: 2
[    0.756428] pci 0000:01:00.0: BAR 6: assigned [mem 0xfb000000-0xfb07ffff pref]
[    0.756431] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.756433] pci 0000:00:02.0:   bridge window [io  0xc000-0xcfff]
[    0.756436] pci 0000:00:02.0:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.756439] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.756442] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    0.756444] pci 0000:00:04.0:   bridge window [io  0xb000-0xbfff]
[    0.756447] pci 0000:00:04.0:   bridge window [mem 0xfd900000-0xfd9fffff]
[    0.756450] pci 0000:00:04.0:   bridge window [mem 0xfd600000-0xfd6fffff 64bit pref]
[    0.756453] pci 0000:00:09.0: PCI bridge to [bus 03-03]
[    0.756455] pci 0000:00:09.0:   bridge window [io  0xe000-0xefff]
[    0.756458] pci 0000:00:09.0:   bridge window [mem 0xfd500000-0xfd5fffff]
[    0.756461] pci 0000:00:09.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.756464] pci 0000:00:0a.0: PCI bridge to [bus 04-04]
[    0.756466] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    0.756469] pci 0000:00:0a.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.756472] pci 0000:00:0a.0:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.756475] pci 0000:00:14.4: PCI bridge to [bus 05-05]
[    0.756478] pci 0000:00:14.4:   bridge window [io  0xa000-0xafff]
[    0.756482] pci 0000:00:14.4:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.756485] pci 0000:00:14.4:   bridge window [mem 0xfda00000-0xfdafffff pref]
[    0.756490] pci 0000:00:15.0: PCI bridge to [bus 06-06]
[    0.756493] pci 0000:00:15.0:   bridge window [io  0x9000-0x9fff]
[    0.756496] pci 0000:00:15.0:   bridge window [mem 0xfd800000-0xfd8fffff]
[    0.756500] pci 0000:00:15.0:   bridge window [mem 0xfd700000-0xfd7fffff 64bit pref]
[    0.756512] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.756515] pci 0000:00:02.0: setting latency timer to 64
[    0.756523] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.756525] pci 0000:00:04.0: setting latency timer to 64
[    0.756532] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.756534] pci 0000:00:09.0: setting latency timer to 64
[    0.756538] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.756541] pci 0000:00:0a.0: setting latency timer to 64
[    0.756548] pci 0000:00:15.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.756551] pci 0000:00:15.0: setting latency timer to 64
[    0.756554] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.756556] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.756558] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.756560] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.756562] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.756564] pci_bus 0000:00: resource 9 [mem 0xd0000000-0xfebfffff]
[    0.756566] pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
[    0.756568] pci_bus 0000:01: resource 1 [mem 0xf8000000-0xfbffffff]
[    0.756570] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.756572] pci_bus 0000:02: resource 0 [io  0xb000-0xbfff]
[    0.756574] pci_bus 0000:02: resource 1 [mem 0xfd900000-0xfd9fffff]
[    0.756576] pci_bus 0000:02: resource 2 [mem 0xfd600000-0xfd6fffff 64bit pref]
[    0.756578] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.756579] pci_bus 0000:03: resource 1 [mem 0xfd500000-0xfd5fffff]
[    0.756581] pci_bus 0000:03: resource 2 [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.756583] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.756585] pci_bus 0000:04: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.756587] pci_bus 0000:04: resource 2 [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.756589] pci_bus 0000:05: resource 0 [io  0xa000-0xafff]
[    0.756591] pci_bus 0000:05: resource 1 [mem 0xfdb00000-0xfdbfffff]
[    0.756593] pci_bus 0000:05: resource 2 [mem 0xfda00000-0xfdafffff pref]
[    0.756595] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.756596] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.756598] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.756600] pci_bus 0000:05: resource 7 [mem 0x000c0000-0x000dffff]
[    0.756602] pci_bus 0000:05: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.756604] pci_bus 0000:05: resource 9 [mem 0xd0000000-0xfebfffff]
[    0.756606] pci_bus 0000:06: resource 0 [io  0x9000-0x9fff]
[    0.756608] pci_bus 0000:06: resource 1 [mem 0xfd800000-0xfd8fffff]
[    0.756610] pci_bus 0000:06: resource 2 [mem 0xfd700000-0xfd7fffff 64bit pref]
[    0.756628] NET: Registered protocol family 2
[    0.757124] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.758674] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.760279] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.760454] TCP: Hash tables configured (established 524288 bind 65536)
[    0.760456] TCP reno registered
[    0.760488] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.760566] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.760669] NET: Registered protocol family 1
[    1.017112] pci 0000:01:00.0: Boot video device
[    1.017180] PCI: CLS 64 bytes, default 64
[    1.017237] Trying to unpack rootfs image as initramfs...
[    1.349347] Freeing initrd memory: 20064k freed
[    1.353371] pci 0000:00:00.2: can't derive routing for PCI INT A
[    1.353374] pci 0000:00:00.2: PCI INT A: no GSI
[    1.353422] pci 0000:00:00.2: irq 40 for MSI/MSI-X
[    1.353494] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40
[    1.416994] AMD-Vi: Lazy IO/TLB flushing enabled
[    1.416996] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.416999] Placing 64MB software IO TLB between ffff8800cbd9e000 - ffff8800cfd9e000
[    1.417009] software IO TLB at phys 0xcbd9e000 - 0xcfd9e000
[    1.417542] perf: AMD IBS detected (0x000000ff)
[    1.418062] sha1_ssse3: Using AVX optimized SHA-1 implementation
[    1.418204] audit: initializing netlink socket (disabled)
[    1.418212] type=2000 audit(1322592404.417:1): initialized
[    1.457296] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.503974] VFS: Disk quotas dquot_6.5.2
[    1.504025] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.504413] msgmni has been set to 31931
[    1.504458] SELinux:  Registering netfilter hooks
[    1.504705] async_tx: api initialized (async)
[    1.504740] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.504743] io scheduler noop registered
[    1.504744] io scheduler deadline registered
[    1.504772] io scheduler cfq registered (default)
[    1.504877] xz_dec_test: module loaded
[    1.504878] xz_dec_test: Create a device node with 'mknod xz_dec_test c 252 0' and write .xz files to it.
[    1.505107] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.505129] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.505131] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.505492] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.505495] ACPI: Power Button [PWRB]
[    1.505537] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.505539] ACPI: Power Button [PWRF]
[    1.505719] ACPI: acpi_idle registered with cpuidle
[    1.552926] ERST: Table is not found!
[    1.552933] GHES: HEST is not enabled!
[    1.553020] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.817143] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.838869] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.848384] Non-volatile memory driver v1.3
[    1.848386] Linux agpgart interface v0.103
[    1.849638] brd: module loaded
[    1.850249] loop: module loaded
[    1.850298] ahci 0000:00:11.0: version 3.0
[    1.850312] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.850404] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 4 ports 6 Gbps 0xf impl SATA mode
[    1.850407] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    1.850870] scsi0 : ahci
[    1.850941] scsi1 : ahci
[    1.851021] scsi2 : ahci
[    1.851087] scsi3 : ahci
[    1.851194] ata1: SATA max UDMA/133 abar m1024@0xfdfff000 port 0xfdfff100 irq 19
[    1.851197] ata2: SATA max UDMA/133 abar m1024@0xfdfff000 port 0xfdfff180 irq 19
[    1.851199] ata3: SATA max UDMA/133 abar m1024@0xfdfff000 port 0xfdfff200 irq 19
[    1.851202] ata4: SATA max UDMA/133 abar m1024@0xfdfff000 port 0xfdfff280 irq 19
[    1.851331] Fixed MDIO Bus: probed
[    1.851382] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.851394] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.851403] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    1.851464] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    1.851471] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.851489] QUIRK: Enable AMD PLL fix
[    1.851498] ehci_hcd 0000:00:12.2: debug port 1
[    1.851513] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfdffd000
[    1.857041] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.857062] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.857064] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.857066] usb usb1: Product: EHCI Host Controller
[    1.857068] usb usb1: Manufacturer: Linux 3.2.0-rc3+ ehci_hcd
[    1.857070] usb usb1: SerialNumber: 0000:00:12.2
[    1.857167] hub 1-0:1.0: USB hub found
[    1.857173] hub 1-0:1.0: 5 ports detected
[    1.857240] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.857251] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    1.857295] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    1.857301] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.857318] ehci_hcd 0000:00:13.2: debug port 1
[    1.857328] ehci_hcd 0000:00:13.2: irq 17, io mem 0xfdffb000
[    1.863040] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.863058] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.863060] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.863062] usb usb2: Product: EHCI Host Controller
[    1.863064] usb usb2: Manufacturer: Linux 3.2.0-rc3+ ehci_hcd
[    1.863065] usb usb2: SerialNumber: 0000:00:13.2
[    1.863158] hub 2-0:1.0: USB hub found
[    1.863161] hub 2-0:1.0: 5 ports detected
[    1.863226] ehci_hcd 0000:00:16.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.863237] ehci_hcd 0000:00:16.2: EHCI Host Controller
[    1.863283] ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus number 3
[    1.863289] ehci_hcd 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.863306] ehci_hcd 0000:00:16.2: debug port 1
[    1.863316] ehci_hcd 0000:00:16.2: irq 17, io mem 0xfdff8000
[    1.869040] ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    1.869055] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.869057] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.869059] usb usb3: Product: EHCI Host Controller
[    1.869061] usb usb3: Manufacturer: Linux 3.2.0-rc3+ ehci_hcd
[    1.869062] usb usb3: SerialNumber: 0000:00:16.2
[    1.869156] hub 3-0:1.0: USB hub found
[    1.869160] hub 3-0:1.0: 4 ports detected
[    1.869224] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.869235] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.869246] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    1.869294] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 4
[    1.869314] ohci_hcd 0000:00:12.0: irq 18, io mem 0xfdffe000
[    1.924074] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.924077] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.924079] usb usb4: Product: OHCI Host Controller
[    1.924081] usb usb4: Manufacturer: Linux 3.2.0-rc3+ ohci_hcd
[    1.924082] usb usb4: SerialNumber: 0000:00:12.0
[    1.924177] hub 4-0:1.0: USB hub found
[    1.924183] hub 4-0:1.0: 5 ports detected
[    1.924253] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.924264] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.924308] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    1.924324] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfdffc000
[    1.979068] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.979070] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.979072] usb usb5: Product: OHCI Host Controller
[    1.979074] usb usb5: Manufacturer: Linux 3.2.0-rc3+ ohci_hcd
[    1.979075] usb usb5: SerialNumber: 0000:00:13.0
[    1.979170] hub 5-0:1.0: USB hub found
[    1.979175] hub 5-0:1.0: 5 ports detected
[    1.979242] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.979253] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.979300] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 6
[    1.979315] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfdffa000
[    2.034066] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.034068] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.034070] usb usb6: Product: OHCI Host Controller
[    2.034072] usb usb6: Manufacturer: Linux 3.2.0-rc3+ ohci_hcd
[    2.034073] usb usb6: SerialNumber: 0000:00:14.5
[    2.034168] hub 6-0:1.0: USB hub found
[    2.034174] hub 6-0:1.0: 2 ports detected
[    2.034234] ohci_hcd 0000:00:16.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.034245] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    2.034296] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 7
[    2.034310] ohci_hcd 0000:00:16.0: irq 18, io mem 0xfdff9000
[    2.089070] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.089072] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.089074] usb usb7: Product: OHCI Host Controller
[    2.089076] usb usb7: Manufacturer: Linux 3.2.0-rc3+ ohci_hcd
[    2.089077] usb usb7: SerialNumber: 0000:00:16.0
[    2.089172] hub 7-0:1.0: USB hub found
[    2.089177] hub 7-0:1.0: 4 ports detected
[    2.089243] uhci_hcd: USB Universal Host Controller Interface driver
[    2.089290] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    2.122844] i8042: Failed to disable AUX port, but continuing anyway... Is this a SiS?
[    2.122846] i8042: If AUX port is really absent please use the 'i8042.noaux' option
[    2.156065] ata3: SATA link down (SStatus 0 SControl 300)
[    2.156090] ata4: SATA link down (SStatus 0 SControl 300)
[    2.156115] ata2: SATA link down (SStatus 0 SControl 300)
[    2.159057] usb 1-4: new high-speed USB device number 2 using ehci_hcd
[    2.311054] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.313482] usb 1-4: New USB device found, idVendor=0bda, idProduct=0161
[    2.313485] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.313487] usb 1-4: Product: USB2.0-CRW
[    2.313489] usb 1-4: Manufacturer: Generic
[    2.313490] usb 1-4: SerialNumber: 20070818000000000
[    2.321437] ata1.00: ATA-7: WDC WD5000ABYS-01TNA0, 12.01C01, max UDMA/133
[    2.321440] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.322331] ata1.00: configured for UDMA/133
[    2.322424] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000ABYS-0 12.0 PQ: 0 ANSI: 5
[    2.322567] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.322607] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.322692] sd 0:0:0:0: [sda] Write Protect is off
[    2.322694] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.322725] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.333077]  sda: sda1 sda2 sda3
[    2.333433] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.372130] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.372212] mousedev: PS/2 mouse device common for all mice
[    2.372371] rtc_cmos 00:05: RTC can wake from S4
[    2.372458] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    2.372476] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    2.372484] md: raid1 personality registered for level 1
[    2.372486] md: raid6 personality registered for level 6
[    2.372488] md: raid5 personality registered for level 5
[    2.372489] md: raid4 personality registered for level 4
[    2.372549] device-mapper: uevent: version 1.0.3
[    2.372614] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    2.372810] cpuidle: using governor ladder
[    2.373085] cpuidle: using governor menu
[    2.373086] EFI Variables Facility v0.08 2004-May-17
[    2.373206] usbcore: registered new interface driver usbhid
[    2.373207] usbhid: USB HID core driver
[    2.373226] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.373356] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.373369] TCP cubic registered
[    2.373370] Initializing XFRM netlink socket
[    2.373379] NET: Registered protocol family 17
[    2.373390] Registering the dns_resolver key type
[    2.373511] PM: Hibernation image not present or could not be loaded.
[    2.373520] registered taskstats version 1
[    2.396088] IMA: No TPM chip found, activating TPM-bypass!
[    2.396393]   Magic number: 3:357:798
[    2.396478] rtc_cmos 00:05: setting system clock to 2011-11-29 18:46:46 UTC (1322592406)
[    2.396570] Initializing network drop monitor service
[    2.399727] Freeing unused kernel memory: 932k freed
[    2.399871] Write protecting the kernel read-only data: 10240k
[    2.408437] Freeing unused kernel memory: 1312k freed
[    2.418434] Freeing unused kernel memory: 1600k freed
[    2.420024] Refined TSC clocksource calibration: 3624.274 MHz.
[    2.420027] Switching to clocksource tsc
[    2.505922] dracut: dracut-013-19.fc16
[    2.512121] udevd[119]: starting version 173
[    2.524690] wmi: Mapper loaded
[    2.538348] [drm] Initialized drm 1.1.0 20060810
[    2.575263] nouveau 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.575268] nouveau 0000:01:00.0: setting latency timer to 64
[    2.576260] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x0a0100b1)
[    2.578797] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[    2.643125] usb 5-4: new low-speed USB device number 2 using ohci_hcd
[    2.651766] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    2.651770] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    2.651772] [drm] nouveau 0000:01:00.0: Bios version 62.00.4c.00
[    2.651775] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[    2.651909] [drm] nouveau 0000:01:00.0: MXM: no VBIOS data, nothing to do
[    2.651912] [drm] nouveau 0000:01:00.0: DCB version 4.0
[    2.651915] [drm] nouveau 0000:01:00.0: DCB outp 00: 04000320 00000028
[    2.651917] [drm] nouveau 0000:01:00.0: DCB outp 01: 01000322 00020030
[    2.651919] [drm] nouveau 0000:01:00.0: DCB outp 02: 02011310 00000028
[    2.651921] [drm] nouveau 0000:01:00.0: DCB outp 03: 02011312 00020030
[    2.651923] [drm] nouveau 0000:01:00.0: DCB outp 04: 010223f1 00c1c020
[    2.651925] [drm] nouveau 0000:01:00.0: DCB conn 00: 00001030
[    2.651927] [drm] nouveau 0000:01:00.0: DCB conn 01: 00002130
[    2.651929] [drm] nouveau 0000:01:00.0: DCB conn 02: 00000210
[    2.651931] [drm] nouveau 0000:01:00.0: DCB conn 03: 00000211
[    2.651932] [drm] nouveau 0000:01:00.0: DCB conn 04: 00000213
[    2.651934] [drm] nouveau 0000:01:00.0: DCB conn 05: 00000360
[    2.651938] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xD073
[    2.682098] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xD49E
[    2.684944] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xE93B
[    2.684950] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xEA18
[    2.685959] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xEAEA
[    2.685961] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xEB4F
[    2.705965] [drm] nouveau 0000:01:00.0: 0xEB4F: Condition still not met after 20ms, skipping following opcodes
[    2.726014] [drm] nouveau 0000:01:00.0: 3 available performance level(s)
[    2.726018] [drm] nouveau 0000:01:00.0: 0: core 300MHz shader 600MHz memory 100MHz timing 0 voltage 1050mV fanspeed 100%
[    2.726022] [drm] nouveau 0000:01:00.0: 2: core 400MHz shader 800MHz memory 300MHz timing 1 voltage 1050mV fanspeed 100%
[    2.726026] [drm] nouveau 0000:01:00.0: 3: core 576MHz shader 1242MHz memory 1015MHz timing 4 voltage 1120mV fanspeed 100%
[    2.726067] [drm] nouveau 0000:01:00.0: c: core 399MHz shader 810MHz memory 297MHz voltage 1050mV
[    2.727350] [TTM] Zone  kernel: Available graphics memory: 8176416 kiB.
[    2.727352] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[    2.727353] [TTM] Initializing pool allocator.
[    2.727365] [drm] nouveau 0000:01:00.0: Detected 896MiB VRAM
[    2.733371] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[    2.740644] [drm] nouveau 0000:01:00.0: DCB encoder 1 unknown
[    2.740647] [drm] nouveau 0000:01:00.0: TV-1 has no encoders, removing
[    2.741246] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.741247] [drm] Driver supports precise vblank timestamp query.
[    2.794175] usb 5-4: New USB device found, idVendor=09da, idProduct=000e
[    2.794195] usb 5-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.794197] usb 5-4: Product: PS/2+USB Mouse
[    2.794199] usb 5-4: Manufacturer: A4Tech
[    2.804271] input: A4Tech PS/2+USB Mouse as /devices/pci0000:00/0000:00:13.0/usb5/5-4/5-4:1.0/input/input2
[    2.804388] generic-usb 0003:09DA:000E.0001: input,hidraw0: USB HID v1.10 Mouse [A4Tech PS/2+USB Mouse] on usb-0000:00:13.0-4/input0
[    2.991139] [drm] nouveau 0000:01:00.0: allocated 1680x1050 fb: 0x330000, bo ffff88040eb3f800
[    2.991195] fbcon: nouveaufb (fb0) is primary device
[    3.031092] usb 5-5: new low-speed USB device number 3 using ohci_hcd
[    3.032095] Console: switching to colour frame buffer device 160x64
[    3.033734] fb0: nouveaufb frame buffer device
[    3.033735] drm: registered panic notifier
[    3.033738] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[    3.088950] dracut: Starting plymouth daemon
[    3.177138] usb 5-5: New USB device found, idVendor=046a, idProduct=0023
[    3.177152] usb 5-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.185289] input: HID 046a:0023 as /devices/pci0000:00/0000:00:13.0/usb5/5-5/5-5:1.0/input/input3
[    3.185385] cherry 0003:046A:0023.0002: input,hidraw1: USB HID v1.11 Keyboard [HID 046a:0023] on usb-0000:00:13.0-5/input0
[    3.195186] input: HID 046a:0023 as /devices/pci0000:00/0000:00:13.0/usb5/5-5/5-5:1.1/input/input4
[    3.195273] cherry 0003:046A:0023.0003: input,hidraw2: USB HID v1.11 Device [HID 046a:0023] on usb-0000:00:13.0-5/input1
[    3.449241] pata_atiixp 0000:00:14.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.449544] scsi4 : pata_atiixp
[    3.449634] scsi5 : pata_atiixp
[    3.450469] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
[    3.450472] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
[    3.453207] usbcore: registered new interface driver uas
[    3.613227] ata5.00: ATAPI: HL-DT-ST DVD-RAM GSA-H60L, R90A, max UDMA/100
[    3.613232] ata5.00: limited to UDMA/33 due to 40-wire cable
[    3.635281] ata5.00: configured for UDMA/33
[    3.644210] scsi 4:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GSA-H60L R90A PQ: 0 ANSI: 5
[    3.650726] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.650729] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.650946] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    3.651048] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    3.654568] Initializing USB Mass Storage driver...
[    3.654735] scsi6 : usb-storage 1-4:1.1
[    3.654820] firewire_ohci 0000:05:0e.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    3.654993] usbcore: registered new interface driver usb-storage
[    3.654995] USB Mass Storage support registered.
[    3.708168] firewire_ohci: Added fw-ohci device 0000:05:0e.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x11
[    3.811172] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    3.907542] dracut: Checking ext4: /dev/disk/by-uuid/ce4247a8-ba04-4b2f-8f86-38b183755e5d
[    3.907581] dracut: issuing e2fsck -a  /dev/disk/by-uuid/ce4247a8-ba04-4b2f-8f86-38b183755e5d
[    3.950853] dracut: /dev/disk/by-uuid/ce4247a8-ba04-4b2f-8f86-38b183755e5d: clean, 324197/2564096 files, 8185391/10240000 blocks
[    3.951051] dracut: Remounting /dev/disk/by-uuid/ce4247a8-ba04-4b2f-8f86-38b183755e5d with -o ro
[    3.958408] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    3.982014] dracut: Mounted root filesystem /dev/sda1
[    4.200460] dracut: Switching root
[    4.209174] firewire_core: created device fw0: GUID 0049e5503beb0300, S400
[    4.656591] type=1404 audit(1322592408.758:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    4.658392] scsi 6:0:0:0: Direct-Access     Generic- Compact Flash    1.00 PQ: 0 ANSI: 0 CCS
[    4.662225] scsi 6:0:0:1: Direct-Access     Generic- SM/xD-Picture    1.00 PQ: 0 ANSI: 0 CCS
[    4.666189] scsi 6:0:0:2: Direct-Access     Generic- SD/MMC           1.00 PQ: 0 ANSI: 0 CCS
[    4.670160] scsi 6:0:0:3: Direct-Access     Generic- MS/MS-Pro        1.00 PQ: 0 ANSI: 0 CCS
[    4.670791] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    4.670921] sd 6:0:0:1: Attached scsi generic sg3 type 0
[    4.671069] sd 6:0:0:2: Attached scsi generic sg4 type 0
[    4.671198] sd 6:0:0:3: Attached scsi generic sg5 type 0
[    4.679109] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[    4.682741] sd 6:0:0:1: [sdc] Attached SCSI removable disk
[    4.683954] sd 6:0:0:2: [sdd] Attached SCSI removable disk
[    4.685115] sd 6:0:0:3: [sde] Attached SCSI removable disk
[    4.783881] SELinux: 2048 avtab hash slots, 98214 rules.
[    4.801991] SELinux: 2048 avtab hash slots, 98214 rules.
[    4.859543] SELinux:  9 users, 13 roles, 3917 types, 205 bools, 1 sens, 1024 cats
[    4.859546] SELinux:  82 classes, 98214 rules
[    4.864629] SELinux:  Completing initialization.
[    4.864631] SELinux:  Setting up existing superblocks.
[    4.864636] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    4.864641] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    4.864710] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    4.864714] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    4.864720] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.864736] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    4.865285] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    4.865289] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    4.865996] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    4.866006] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    4.866010] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    4.866020] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    4.866025] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    4.866030] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    4.866042] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[    4.866048] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    4.866052] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    4.866434] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.866438] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.866990] SELinux: initialized (dev sda1, type ext4), uses xattr
[    4.869736] type=1403 audit(1322592408.971:3): policy loaded auid=4294967295 ses=4294967295
[    4.874037] systemd[1]: Successfully loaded SELinux policy in 260ms 763us.
[    4.926806] systemd[1]: Successfully loaded SELinux database in 52ms 603us, size on heap is 478K.
[    4.938082] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.938386] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.972221] systemd[1]: Relabelled /dev and /run in 33ms 775us.
[    4.986737] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.998208] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.015234] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.025113] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.041161] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.049237] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.066193] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.074218] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.074365] systemd[1]: systemd 37 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)
[    5.467745] NET: Registered protocol family 10
[    5.480803] systemd[1]: Set hostname to <tellur>.
[    6.411686] systemd-readahead-collect[396]: Failed to create fanotify object: Function not implemented
[    6.440650] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[    7.839381] systemd[1]: systemd-readahead-collect.service: main process exited, code=exited, status=1
[    9.078507] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    9.078754] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    9.205639] udevd[407]: starting version 173
[   10.507893] EXT4-fs (sda1): re-mounted. Opts: (null)
[   14.685611] RPC: Registered named UNIX socket transport module.
[   14.685613] RPC: Registered udp transport module.
[   14.685615] RPC: Registered tcp transport module.
[   14.685616] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   14.686336] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
[   16.525458] kvm: Nested Virtualization enabled
[   16.525464] kvm: Nested Paging enabled
[   20.516761] rmmod[685]: ERROR: Module scsi_wait_scan does not exist in /proc/modules
[   21.138916] mtp-probe[539]: checking bus 5, device 2: "/sys/devices/pci0000:00/0000:00:13.0/usb5/5-4"
[   21.138924] mtp-probe[528]: checking bus 1, device 2: "/sys/devices/pci0000:00/0000:00:12.2/usb1/1-4"
[   21.138955] mtp-probe[541]: checking bus 5, device 3: "/sys/devices/pci0000:00/0000:00:13.0/usb5/5-5"
[   21.298891] microcode: CPU0: patch_level=0x06000623
[   21.300448] microcode: CPU1: patch_level=0x06000623
[   21.301961] microcode: CPU2: patch_level=0x06000623
[   21.303404] microcode: CPU3: patch_level=0x06000623
[   21.304829] microcode: CPU4: patch_level=0x06000623
[   21.306320] microcode: CPU5: patch_level=0x06000623
[   21.307763] microcode: CPU6: patch_level=0x06000623
[   21.309222] microcode: CPU7: patch_level=0x06000623
[   21.310803] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   21.384270] mtp-probe[539]: bus: 5, device: 2 was not an MTP device
[   21.384491] mtp-probe[541]: bus: 5, device: 3 was not an MTP device
[   21.385384] mtp-probe[528]: bus: 1, device: 2 was not an MTP device
[   21.506816] MCE: In-kernel MCE decoding enabled.
[   21.526759] EDAC MC: Ver: 2.1.0
[   21.662314] xhci_hcd 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   21.662372] xhci_hcd 0000:02:00.0: setting latency timer to 64
[   21.662376] xhci_hcd 0000:02:00.0: xHCI Host Controller
[   21.662555] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 8
[   21.662636] xhci_hcd 0000:02:00.0: irq 16, io mem 0xfd9f8000
[   21.662650] xhci_hcd 0000:02:00.0: Failed to enable MSI-X
[   21.662681] xhci_hcd 0000:02:00.0: irq 41 for MSI/MSI-X
[   21.662722] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[   21.662724] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   21.662726] usb usb8: Product: xHCI Host Controller
[   21.662728] usb usb8: Manufacturer: Linux 3.2.0-rc3+ xhci_hcd
[   21.662729] usb usb8: SerialNumber: 0000:02:00.0
[   21.662863] xHCI xhci_add_endpoint called for root hub
[   21.662865] xHCI xhci_check_bandwidth called for root hub
[   21.662893] hub 8-0:1.0: USB hub found
[   21.662898] hub 8-0:1.0: 2 ports detected
[   21.662956] xhci_hcd 0000:02:00.0: xHCI Host Controller
[   21.663023] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 9
[   21.663041] usb usb9: New USB device found, idVendor=1d6b, idProduct=0003
[   21.663043] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   21.663045] usb usb9: Product: xHCI Host Controller
[   21.663046] usb usb9: Manufacturer: Linux 3.2.0-rc3+ xhci_hcd
[   21.663048] usb usb9: SerialNumber: 0000:02:00.0
[   21.663125] xHCI xhci_add_endpoint called for root hub
[   21.663127] xHCI xhci_check_bandwidth called for root hub
[   21.663151] hub 9-0:1.0: USB hub found
[   21.663157] hub 9-0:1.0: 2 ports detected
[   21.681059] xhci_hcd 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   21.681092] xhci_hcd 0000:04:00.0: setting latency timer to 64
[   21.681095] xhci_hcd 0000:04:00.0: xHCI Host Controller
[   21.681218] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 10
[   21.681293] xhci_hcd 0000:04:00.0: irq 18, io mem 0xfddf8000
[   21.681304] xhci_hcd 0000:04:00.0: Failed to enable MSI-X
[   21.681338] xhci_hcd 0000:04:00.0: irq 42 for MSI/MSI-X
[   21.681378] usb usb10: New USB device found, idVendor=1d6b, idProduct=0002
[   21.681381] usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   21.681383] usb usb10: Product: xHCI Host Controller
[   21.681384] usb usb10: Manufacturer: Linux 3.2.0-rc3+ xhci_hcd
[   21.681386] usb usb10: SerialNumber: 0000:04:00.0
[   21.681483] xHCI xhci_add_endpoint called for root hub
[   21.681485] xHCI xhci_check_bandwidth called for root hub
[   21.681522] hub 10-0:1.0: USB hub found
[   21.681528] hub 10-0:1.0: 2 ports detected
[   21.681588] xhci_hcd 0000:04:00.0: xHCI Host Controller
[   21.681663] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 11
[   21.681679] usb usb11: New USB device found, idVendor=1d6b, idProduct=0003
[   21.681681] usb usb11: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   21.681683] usb usb11: Product: xHCI Host Controller
[   21.681685] usb usb11: Manufacturer: Linux 3.2.0-rc3+ xhci_hcd
[   21.681686] usb usb11: SerialNumber: 0000:04:00.0
[   21.681767] xHCI xhci_add_endpoint called for root hub
[   21.681769] xHCI xhci_check_bandwidth called for root hub
[   21.681794] hub 11-0:1.0: USB hub found
[   21.681799] hub 11-0:1.0: 2 ports detected
[   21.746076] IR NEC protocol handler initialized
[   21.808343] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[   21.818953] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
[   21.819021] SP5100 TCO timer: mmio address 0xb8fe00 already in use
[   21.829623] AMD64 EDAC driver v3.4.0
[   21.829641] EDAC amd64: DRAM ECC disabled.
[   21.829660] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[   21.829662]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[   21.829663]  (Note that use of the override may cause unknown side effects.)
[   21.865904] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   21.867604] usbcore: registered new interface driver mceusb
[   22.062728] IR RC5(x) protocol handler initialized
[   22.080686] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   22.080702] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   22.080817] r8169 0000:03:00.0: setting latency timer to 64
[   22.080870] r8169 0000:03:00.0: irq 43 for MSI/MSI-X
[   22.081018] r8169 0000:03:00.0: eth0: RTL8168evl/8111evl at 0xffffc9001273e000, 50:e5:49:5b:ec:3a, XID 0c900800 IRQ 43
[   22.081021] r8169 0000:03:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[   22.108228] IR RC6 protocol handler initialized
[   22.164565] IR JVC protocol handler initialized
[   22.264136] udevd[459]: renamed network interface eth0 to p9p1
[   22.309332] IR Sony protocol handler initialized
[   22.398760] fedora-storage-init[751]: Logical Volume Management einrichten:   No volume groups found
[   22.402579] fedora-storage-init[751]: [  OK  ]
[   22.407046] IR MCE Keyboard/mouse protocol handler initialized
[   22.463737] snd_hda_intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   22.463741] ALSA sound/pci/hda/hda_intel.c:2547 Using LPIB position fix
[   22.471265] ALSA sound/pci/hda/hda_intel.c:1572 Enable sync_write for stable communication
[   22.482931] lirc_dev: IR Remote Control driver registered, major 248 
[   22.487792] IR LIRC bridge handler initialized
[   22.522519] ALSA sound/pci/hda/patch_realtek.c:1243 SKU: Nid=0x1d sku_cfg=0x4005e601
[   22.522526] ALSA sound/pci/hda/patch_realtek.c:1245 SKU: port_connectivity=0x1
[   22.522528] ALSA sound/pci/hda/patch_realtek.c:1246 SKU: enable_pcbeep=0x0
[   22.522530] ALSA sound/pci/hda/patch_realtek.c:1247 SKU: check_sum=0x00000005
[   22.522532] ALSA sound/pci/hda/patch_realtek.c:1248 SKU: customization=0x000000e6
[   22.522534] ALSA sound/pci/hda/patch_realtek.c:1249 SKU: external_amp=0x0
[   22.522536] ALSA sound/pci/hda/patch_realtek.c:1250 SKU: platform_type=0x0
[   22.522537] ALSA sound/pci/hda/patch_realtek.c:1251 SKU: swap=0x0
[   22.522539] ALSA sound/pci/hda/patch_realtek.c:1252 SKU: override=0x1
[   22.554735] fedora-storage-init[806]: Logical Volume Management einrichten:   No volume groups found
[   22.555428] Adding 2097148k swap on /dev/sda2.  Priority:0 extents:1 across:2097148k 
[   22.559111] fedora-storage-init[806]: [  OK  ]
[   22.586350] systemd-fsck[801]: /dev/sda3: sauber, 1664769/27836416 Dateien, 76092959/111332096 Bl\xffffffc3\xffffffb6\xffffffb6cke (Pr\xffffffc3\xffffffbc\xffffffbcfung nach 2 Einh\xffffffc3\xffffffa4\xffffffa4ngevorg\xffffffc3\xffffffa4\xffffffa4ngen)
[   22.675709] lvm[831]: No volume groups found
[   22.742505] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[   22.742512] SELinux: initialized (dev sda3, type ext4), uses xattr
[   22.871245] systemd-tmpfiles[844]: Successfully loaded SELinux database in 8ms 850us, size on heap is 480K.
[   23.160799] sandbox[850]: Starting sandbox[  OK  ]
[   23.228759] iptables.init[856]: iptables: Firewall-Regeln anwenden: [  OK  ]
[   23.235127] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   23.317870] ip6tables.init[852]: ip6tables: Firewall-Regeln anwenden: [  OK  ]
[   23.399883] NetworkManager[882]: <info> NetworkManager (version 0.9.1.90-5.git20110927.fc16) is starting...
[   23.399890] NetworkManager[882]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
[   23.399896] NetworkManager[882]: NetworkManager[882]: <info> NetworkManager (version 0.9.1.90-5.git20110927.fc16) is starting...
[   23.399901] NetworkManager[882]: NetworkManager[882]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
[   23.427766] ntpd[891]: ntpd 4.2.6p4@1.2324-o Thu Oct  6 15:37:57 UTC 2011 (1)
[   23.427878] ntpd[891]: proto: precision = 0.074 usec
[   23.427922] ntpd[891]: 0.0.0.0 c01d 0d kern kernel time sync enabled
[   23.428084] ntpd[891]: ntp_io: estimated max descriptors: 1024, initial socket boundary: 16
[   23.428140] ntpd[891]: Listen and drop on 0 v4wildcard 0.0.0.0 UDP 123
[   23.429316] ntpd[891]: Listen and drop on 1 v6wildcard :: UDP 123
[   23.429423] ntpd[891]: Listen normally on 2 lo 127.0.0.1 UDP 123
[   23.429458] ntpd[891]: Listen normally on 3 lo ::1 UDP 123
[   23.429480] ntpd[891]: peers refreshed
[   23.429512] ntpd[891]: Listening on routing socket on fd #20 for interface updates
[   23.430371] ntpd[891]: Deferring DNS for 0.fedora.pool.ntp.org 1
[   23.430896] ntpd[891]: Deferring DNS for 1.fedora.pool.ntp.org 1
[   23.430993] ntpd[891]: Deferring DNS for 2.fedora.pool.ntp.org 1
[   23.431120] ntpd[891]: Deferring DNS for 3.fedora.pool.ntp.org 1
[   23.431381] ntpd[891]: 0.0.0.0 c016 06 restart
[   23.431408] ntpd[891]: 0.0.0.0 c012 02 freq_set kernel -23.306 PPM
[   23.431470] ntpd[894]: signal_no_reset: signal 17 had flags 4000000
[   23.488188] /usr/sbin/irqbalance[896]: WARNING: MSI interrupts found in /proc/interrupts
[   23.488196] /usr/sbin/irqbalance[896]: But none found in sysfs, you need to update your kernel
[   23.488202] /usr/sbin/irqbalance[896]: Until then, IRQs will be improperly classified
[   23.656523] it87: Found IT8720F chip at 0x228, revision 8
[   23.656531] it87: VID is disabled (pins used for GPIO)
[   23.656540] it87: Routing internal VCCH to in7
[   23.656544] it87: Beeping is supported
[   23.715591] acpid[905]: starting up with netlink and the input layer
[   23.715736] acpid[905]: skipping incomplete file /etc/acpi/events/videoconf
[   23.715756] acpid[905]: 1 rule loaded
[   23.715819] acpid[905]: waiting for events: event logging is off
[   23.732291] /usr/sbin/gpm[906]: *** info [daemon/startup.c(136)]:
[   23.732299] /usr/sbin/gpm[906]: Started gpm successfully. Entered daemon mode.
[   23.772585] avahi-daemon[907]: Found user 'avahi' (UID 70) and group 'avahi' (GID 70).
[   23.772670] avahi-daemon[907]: Successfully dropped root privileges.
[   23.772865] avahi-daemon[907]: avahi-daemon 0.6.30 starting up.
[   23.789320] avahi-daemon[907]: WARNING: No NSS support for mDNS detected, consider installing nss-mdns!
[   23.803955] /usr/sbin/crond[895]: (CRON) INFO (running with inotify support)
[   24.289424] dbus-daemon[918]: dbus[918]: avc:  netlink poll: error 4
[   24.289468] dbus[918]: avc:  netlink poll: error 4
[   24.292866] abrtd[900]: Init complete, entering main loop
[   24.292959] avahi-daemon[907]: Successfully called chroot().
[   24.292979] avahi-daemon[907]: Successfully dropped remaining capabilities.
[   24.293765] avahi-daemon[907]: Loading service file /services/ssh.service.
[   24.293771] avahi-daemon[907]: Loading service file /services/udisks.service.
[   24.293776] avahi-daemon[907]: Network interface enumeration completed.
[   24.293782] avahi-daemon[907]: Registering HINFO record with values 'X86_64'/'LINUX'.
[   24.293787] avahi-daemon[907]: Server startup complete. Host name is tellur.local. Local service cookie is 3748537667.
[   24.293793] avahi-daemon[907]: Service "tellur" (/services/udisks.service) successfully established.
[   24.293798] avahi-daemon[907]: Service "tellur" (/services/ssh.service) successfully established.
[   24.293804] systemd-logind[911]: New seat seat0.
[   24.347809] NetworkManager[882]: <info> VPN: loaded org.freedesktop.NetworkManager.openconnect
[   24.347817] NetworkManager[882]: <info> VPN: loaded org.freedesktop.NetworkManager.vpnc
[   24.347826] NetworkManager[882]: NetworkManager[882]: <info> VPN: loaded org.freedesktop.NetworkManager.openconnect
[   24.347832] NetworkManager[882]: NetworkManager[882]: <info> VPN: loaded org.freedesktop.NetworkManager.vpnc
[   24.347853] NetworkManager[882]: <info> VPN: loaded org.freedesktop.NetworkManager.pptp
[   24.347860] NetworkManager[882]: NetworkManager[882]: <info> VPN: loaded org.freedesktop.NetworkManager.pptp
[   24.347891] NetworkManager[882]: <info> VPN: loaded org.freedesktop.NetworkManager.openvpn
[   24.347908] NetworkManager[882]: NetworkManager[882]: <info> VPN: loaded org.freedesktop.NetworkManager.openvpn
[   24.351808] dbus[918]: [system] Activating service name='org.freedesktop.PolicyKit1' (using servicehelper)
[   24.351815] dbus-daemon[918]: dbus[918]: [system] Activating service name='org.freedesktop.PolicyKit1' (using servicehelper)
[   24.366707] polkitd[929]: started daemon version 0.102 using authority implementation `local' version `0.102'
[   24.367184] dbus[918]: [system] Successfully activated service 'org.freedesktop.PolicyKit1'
[   24.367506] dbus-daemon[918]: dbus[918]: [system] Successfully activated service 'org.freedesktop.PolicyKit1'
[   24.371055] NetworkManager[882]: ifcfg-rh: Acquired D-Bus service com.redhat.ifcfgrh1
[   24.371078] NetworkManager[882]: <info> Loaded plugin ifcfg-rh: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the NetworkManager mailing list.
[   24.371134] NetworkManager[882]: NetworkManager[882]:    ifcfg-rh: Acquired D-Bus service com.redhat.ifcfgrh1
[   24.371145] NetworkManager[882]: NetworkManager[882]: <info> Loaded plugin ifcfg-rh: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the NetworkManager mailing list.
[   24.371176] NetworkManager[882]: <info> Loaded plugin keyfile: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the NetworkManager mailing list.
[   24.371185] NetworkManager[882]: NetworkManager[882]: <info> Loaded plugin keyfile: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the NetworkManager mailing list.
[   24.371267] NetworkManager[882]: ifcfg-rh: parsing /etc/sysconfig/network-scripts/ifcfg-eth0 ...
[   24.371275] NetworkManager[882]: NetworkManager[882]:    ifcfg-rh: parsing /etc/sysconfig/network-scripts/ifcfg-eth0 ...
[   24.378100] NetworkManager[882]: ifcfg-rh:     read connection 'System eth0'
[   24.378107] NetworkManager[882]: ifcfg-rh: parsing /etc/sysconfig/network-scripts/ifcfg-lo ...
[   24.378126] NetworkManager[882]: NetworkManager[882]:    ifcfg-rh:     read connection 'System eth0'
[   24.378132] NetworkManager[882]: NetworkManager[882]:    ifcfg-rh: parsing /etc/sysconfig/network-scripts/ifcfg-lo ...
[   24.387766] NetworkManager[882]: <info> trying to start the modem manager...
[   24.387773] NetworkManager[882]: NetworkManager[882]: <info> trying to start the modem manager...
[   24.388022] dbus[918]: [system] Activating service name='org.freedesktop.ModemManager' (using servicehelper)
[   24.388027] NetworkManager[882]: <info> monitoring kernel firmware directory '/lib/firmware'.
[   24.388033] dbus-daemon[918]: dbus[918]: [system] Activating service name='org.freedesktop.ModemManager' (using servicehelper)
[   24.388038] NetworkManager[882]: NetworkManager[882]: <info> monitoring kernel firmware directory '/lib/firmware'.
[   24.388889] dbus[918]: [system] Activating via systemd: service name='org.bluez' unit='dbus-org.bluez.service'
[   24.388899] dbus-daemon[918]: dbus[918]: [system] Activating via systemd: service name='org.bluez' unit='dbus-org.bluez.service'
[   24.389543] NetworkManager[882]: <info> WiFi enabled by radio killswitch; enabled by state file
[   24.389553] NetworkManager[882]: <info> WWAN enabled by radio killswitch; enabled by state file
[   24.389560] NetworkManager[882]: NetworkManager[882]: <info> WiFi enabled by radio killswitch; enabled by state file
[   24.389566] NetworkManager[882]: NetworkManager[882]: <info> WWAN enabled by radio killswitch; enabled by state file
[   24.389590] NetworkManager[882]: <info> WiMAX enabled by radio killswitch; enabled by state file
[   24.389597] NetworkManager[882]: NetworkManager[882]: <info> WiMAX enabled by radio killswitch; enabled by state file
[   24.389603] NetworkManager[882]: <info> Networking is enabled by state file
[   24.389623] NetworkManager[882]: NetworkManager[882]: <info> Networking is enabled by state file
[   24.390555] NetworkManager[882]: <info> (p9p1): carrier is OFF
[   24.390561] NetworkManager[882]: NetworkManager[882]: <info> (p9p1): carrier is OFF
[   24.390604] NetworkManager[882]: <info> (p9p1): new Ethernet device (driver: 'r8169' ifindex: 2)
[   24.390610] NetworkManager[882]: NetworkManager[882]: <info> (p9p1): new Ethernet device (driver: 'r8169' ifindex: 2)
[   24.390630] NetworkManager[882]: <info> (p9p1): exported as /org/freedesktop/NetworkManager/Devices/0
[   24.390649] NetworkManager[882]: NetworkManager[882]: <info> (p9p1): exported as /org/freedesktop/NetworkManager/Devices/0
[   24.390654] NetworkManager[882]: <info> (p9p1): now managed
[   24.390670] NetworkManager[882]: NetworkManager[882]: <info> (p9p1): now managed
[   24.390677] NetworkManager[882]: <info> (p9p1): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
[   24.390693] NetworkManager[882]: NetworkManager[882]: <info> (p9p1): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
[   24.390744] NetworkManager[882]: <info> (p9p1): bringing up device.
[   24.390756] NetworkManager[882]: NetworkManager[882]: <info> (p9p1): bringing up device.
[   24.391317] dbus-daemon[918]: modem-manager[949]: <info>  ModemManager (version 0.4.998-1.git20110706.fc16) starting...
[   24.391399] modem-manager[949]: <info>  ModemManager (version 0.4.998-1.git20110706.fc16) starting...
[   24.393045] dbus[918]: [system] Successfully activated service 'org.freedesktop.ModemManager'
[   24.393054] dbus-daemon[918]: dbus[918]: [system] Successfully activated service 'org.freedesktop.ModemManager'
[   24.393736] modem-manager[949]: <info>  Loaded plugin Ericsson MBM
[   24.393743] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin Ericsson MBM
[   24.393930] modem-manager[949]: <info>  Loaded plugin Samsung
[   24.393938] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin Samsung
[   24.394139] modem-manager[949]: <info>  Loaded plugin Longcheer
[   24.394147] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin Longcheer
[   24.394331] modem-manager[949]: <info>  Loaded plugin Linktop
[   24.394347] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin Linktop
[   24.394521] modem-manager[949]: <info>  Loaded plugin Nokia
[   24.394536] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin Nokia
[   24.394718] modem-manager[949]: <info>  Loaded plugin AnyData
[   24.394733] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin AnyData
[   24.394907] modem-manager[949]: <info>  Loaded plugin MotoC
[   24.394922] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin MotoC
[   24.395119] modem-manager[949]: <info>  Loaded plugin Novatel
[   24.395135] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin Novatel
[   24.395321] modem-manager[949]: <info>  Loaded plugin Huawei
[   24.395337] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin Huawei
[   24.395524] modem-manager[949]: <info>  Loaded plugin Sierra
[   24.395539] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin Sierra
[   24.395715] modem-manager[949]: <info>  Loaded plugin Wavecom
[   24.395731] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin Wavecom
[   24.395910] modem-manager[949]: <info>  Loaded plugin SimTech
[   24.395926] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin SimTech
[   24.396144] modem-manager[949]: <info>  Loaded plugin Generic
[   24.396159] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin Generic
[   24.396341] modem-manager[949]: <info>  Loaded plugin X22X
[   24.396357] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin X22X
[   24.396540] modem-manager[949]: <info>  Loaded plugin Option High-Speed
[   24.396554] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin Option High-Speed
[   24.396733] modem-manager[949]: <info>  Loaded plugin Gobi
[   24.396749] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin Gobi
[   24.396933] modem-manager[949]: <info>  Loaded plugin ZTE
[   24.396948] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin ZTE
[   24.397152] modem-manager[949]: <info>  Loaded plugin Option
[   24.397168] dbus-daemon[918]: modem-manager[949]: <info>  Loaded plugin Option
[   24.495159] r8169 0000:03:00.0: p9p1: link down
[   24.495165] r8169 0000:03:00.0: p9p1: link down
[   24.496288] ADDRCONF(NETDEV_UP): p9p1: link is not ready
[   24.496646] NetworkManager[882]: <info> (p9p1): preparing device.
[   24.496652] NetworkManager[882]: <info> (p9p1): deactivating device (reason 'managed') [2]
[   24.496684] NetworkManager[882]: NetworkManager[882]: <info> (p9p1): preparing device.
[   24.496690] NetworkManager[882]: NetworkManager[882]: <info> (p9p1): deactivating device (reason 'managed') [2]
[   24.497128] NetworkManager[882]: <info> Added default wired connection 'Wired connection 1' for /sys/devices/pci0000:00/0000:00:09.0/0000:03:00.0/net/p9p1
[   24.497146] NetworkManager[882]: NetworkManager[882]: <info> Added default wired connection 'Wired connection 1' for /sys/devices/pci0000:00/0000:00:09.0/0000:03:00.0/net/p9p1
[   24.498093] NetworkManager[882]: <info> modem-manager is now available
[   24.498111] NetworkManager[882]: NetworkManager[882]: <info> modem-manager is now available
[   24.535467] systemd[1]: Failed to read PID file /var/run/iscsid.pid after start. The service might be broken.
[   24.681440] bluetoothd[971]: Bluetooth daemon 4.96
[   24.681446] bluetoothd[971]: bluetoothd[971]: Bluetooth daemon 4.96
[   24.682847] dbus[918]: [system] Successfully activated service 'org.bluez'
[   24.682869] dbus-daemon[918]: dbus[918]: [system] Successfully activated service 'org.bluez'
[   24.683070] bluetoothd[971]: Starting SDP server
[   24.683167] bluetoothd[971]: bluetoothd[971]: Starting SDP server
[   24.828410] Bluetooth: Core ver 2.16
[   24.828462] NET: Registered protocol family 31
[   24.828464] Bluetooth: HCI device and connection manager initialized
[   24.828467] Bluetooth: HCI socket layer initialized
[   24.830827] bluetoothd[971]: opening L2CAP socket: Protocol not supported
[   24.830835] bluetoothd[971]: Server initialization failed
[   24.830893] bluetoothd[971]: bluetoothd[971]: opening L2CAP socket: Protocol not supported
[   24.830899] bluetoothd[971]: bluetoothd[971]: Server initialization failed
[   24.874971] bluetoothd[971]: Failed to open control socket: Protocol not supported (93)
[   24.874980] bluetoothd[971]: Can't init bnep module
[   24.874986] bluetoothd[971]: Failed to init network plugin
[   24.874992] bluetoothd[971]: bluetoothd[971]: Failed to open control socket: Protocol not supported (93)
[   24.874998] bluetoothd[971]: bluetoothd[971]: Can't init bnep module
[   24.875015] bluetoothd[971]: bluetoothd[971]: Failed to init network plugin
[   24.875021] bluetoothd[971]: Parsing /etc/bluetooth/input.conf failed: No such file or directory
[   24.875027] bluetoothd[971]: Parsing /etc/bluetooth/audio.conf failed: No such file or directory
[   24.875063] bluetoothd[971]: bluetoothd[971]: Parsing /etc/bluetooth/input.conf failed: No such file or directory
[   24.875069] bluetoothd[971]: bluetoothd[971]: Parsing /etc/bluetooth/audio.conf failed: No such file or directory
[   24.875948] bluetoothd[971]: Unable to start SCO server socket
[   24.875956] bluetoothd[971]: bluetoothd[971]: Unable to start SCO server socket
[   24.875962] bluetoothd[971]: Failed to init audio plugin
[   24.875967] bluetoothd[971]: bluetoothd[971]: Failed to init audio plugin
[   24.876375] NetworkManager[882]: <warn> bluez error getting default adapter: No such adapter
[   24.876384] NetworkManager[882]: NetworkManager[882]: <warn> bluez error getting default adapter: No such adapter
[   24.876391] NetworkManager[882]: <warn> bluez error getting default adapter: No such adapter
[   24.876398] NetworkManager[882]: NetworkManager[882]: <warn> bluez error getting default adapter: No such adapter
[   24.938965] libvirtd[999]: Could not find keytab file: /etc/libvirt/krb5.tab: Datei oder Verzeichnis nicht gefunden
[   24.938973] libvirtd[999]: server add_plugin entry_point error generic failure
[   24.938978] libvirtd[999]: _sasl_plugin_load failed on sasl_server_plug_init for plugin: gssapiv2
[   24.944754] libvirtd[978]: libvirtd-Daemon starten: [  OK  ]
[   24.951272] sshd[996]: Server listening on 0.0.0.0 port 22.
[   24.951423] sshd[996]: Server listening on :: port 22.
[   24.965828] systemd[1]: mnt-share.mount mount process exited, code=exited status=32
[   25.004185] systemd[1]: Job remote-fs.target/start failed with result 'dependency'.
[   25.004192] systemd[1]: Unit mnt-share.mount entered failed state.
[   25.046139] Bridge firewalling registered
[   25.053417] NetworkManager[882]: <warn> /sys/devices/virtual/net/virbr0: couldn't determine device driver; ignoring...
[   25.053692] NetworkManager[882]: NetworkManager[882]: <warn> /sys/devices/virtual/net/virbr0: couldn't determine device driver; ignoring...
[   25.182649] tun: Universal TUN/TAP device driver, 1.6
[   25.182651] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   25.185254] device virbr0-nic entered promiscuous mode
[   25.189157] NetworkManager[882]: <warn> /sys/devices/virtual/net/virbr0-nic: couldn't determine device driver; ignoring...
[   25.189166] NetworkManager[882]: NetworkManager[882]: <warn> /sys/devices/virtual/net/virbr0-nic: couldn't determine device driver; ignoring...
[   25.206822] sendmail[1045]: My unqualified host name (tellur) unknown; sleeping for retry
[   25.219189] rpc.statd[1062]: Version 1.2.5 starting
[   25.220379] sm-notify[1063]: Version 1.2.5 starting
[   25.281368] avahi-daemon[907]: Joining mDNS multicast group on interface virbr0.IPv4 with address 192.168.122.1.
[   25.282399] ADDRCONF(NETDEV_UP): virbr0: link is not ready
[   25.283520] avahi-daemon[907]: New relevant interface virbr0.IPv4 for mDNS.
[   25.283544] avahi-daemon[907]: Registering new address record for 192.168.122.1 on virbr0.IPv4.
[   25.289187] dnsmasq[1077]: started, version 2.59 cachesize 150
[   25.289194] dnsmasq[1077]: compile time options: IPv6 GNU-getopt DBus no-i18n DHCP TFTP no-conntrack no-IDN
[   25.289200] dnsmasq-dhcp[1077]: DHCP, IP range 192.168.122.2 -- 192.168.122.254, lease time 1h
[   25.289261] dnsmasq[1077]: reading /etc/resolv.conf
[   25.289266] dnsmasq[1077]: using nameserver 192.168.1.2#53
[   25.289317] dnsmasq[1077]: read /etc/hosts - 2 addresses
[   25.428426] Ebtables v2.0 registered
[   26.575200] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   26.575241] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   26.692505] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   26.692533] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   26.875687] r8169 0000:03:00.0: p9p1: link up
[   26.876771] ADDRCONF(NETDEV_CHANGE): p9p1: link becomes ready
[   27.580437] [drm:drm_debugfs_create_files] *ERROR* Cannot create /sys/kernel/debug/dri/channel/4
[   29.473205] FS-Cache: Loaded
[   29.651893] Registering the id_resolver key type
[   29.651908] FS-Cache: Netfs 'nfs' registered for caching
[   29.672955] SELinux: initialized (dev 0:25, type nfs4), uses genfs_contexts
[   30.996419] [drm:drm_debugfs_create_files] *ERROR* Cannot create /sys/kernel/debug/dri/channel/4
[   37.042133] p9p1: no IPv6 routers present

--=-wQL0t+x3avgBlScYCzTB
Content-Disposition: attachment; filename="cpuinfo"
Content-Type: text/plain; name="cpuinfo"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 1
model name	: AMD FX(tm)-8150 Eight-Core Processor           
stepping	: 2
microcode	: 0x6000623
cpu MHz		: 3623.753
cache size	: 2048 KB
physical id	: 0
siblings	: 8
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni pclmulqdq monitor ssse3 cx16 sse4_1 sse4_2 popcnt aes xsave avx lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 nodeid_msr topoext perfctr_core arat cpb npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold
bogomips	: 7247.50
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate [9]

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 1
model name	: AMD FX(tm)-8150 Eight-Core Processor           
stepping	: 2
microcode	: 0x6000623
cpu MHz		: 3623.753
cache size	: 2048 KB
physical id	: 0
siblings	: 8
core id		: 1
cpu cores	: 4
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni pclmulqdq monitor ssse3 cx16 sse4_1 sse4_2 popcnt aes xsave avx lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 nodeid_msr topoext perfctr_core arat cpb npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold
bogomips	: 7247.83
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate [9]

processor	: 2
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 1
model name	: AMD FX(tm)-8150 Eight-Core Processor           
stepping	: 2
microcode	: 0x6000623
cpu MHz		: 3623.753
cache size	: 2048 KB
physical id	: 0
siblings	: 8
core id		: 6
cpu cores	: 4
apicid		: 2
initial apicid	: 6
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni pclmulqdq monitor ssse3 cx16 sse4_1 sse4_2 popcnt aes xsave avx lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 nodeid_msr topoext perfctr_core arat cpb npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold
bogomips	: 7247.89
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate [9]

processor	: 3
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 1
model name	: AMD FX(tm)-8150 Eight-Core Processor           
stepping	: 2
microcode	: 0x6000623
cpu MHz		: 3623.753
cache size	: 2048 KB
physical id	: 0
siblings	: 8
core id		: 5
cpu cores	: 4
apicid		: 3
initial apicid	: 5
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni pclmulqdq monitor ssse3 cx16 sse4_1 sse4_2 popcnt aes xsave avx lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 nodeid_msr topoext perfctr_core arat cpb npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold
bogomips	: 7247.90
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate [9]

processor	: 4
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 1
model name	: AMD FX(tm)-8150 Eight-Core Processor           
stepping	: 2
microcode	: 0x6000623
cpu MHz		: 3623.753
cache size	: 2048 KB
physical id	: 0
siblings	: 8
core id		: 7
cpu cores	: 4
apicid		: 4
initial apicid	: 7
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni pclmulqdq monitor ssse3 cx16 sse4_1 sse4_2 popcnt aes xsave avx lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 nodeid_msr topoext perfctr_core arat cpb npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold
bogomips	: 7247.93
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate [9]

processor	: 5
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 1
model name	: AMD FX(tm)-8150 Eight-Core Processor           
stepping	: 2
microcode	: 0x6000623
cpu MHz		: 3623.753
cache size	: 2048 KB
physical id	: 0
siblings	: 8
core id		: 3
cpu cores	: 4
apicid		: 5
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni pclmulqdq monitor ssse3 cx16 sse4_1 sse4_2 popcnt aes xsave avx lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 nodeid_msr topoext perfctr_core arat cpb npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold
bogomips	: 7247.90
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate [9]

processor	: 6
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 1
model name	: AMD FX(tm)-8150 Eight-Core Processor           
stepping	: 2
microcode	: 0x6000623
cpu MHz		: 3623.753
cache size	: 2048 KB
physical id	: 0
siblings	: 8
core id		: 4
cpu cores	: 4
apicid		: 6
initial apicid	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni pclmulqdq monitor ssse3 cx16 sse4_1 sse4_2 popcnt aes xsave avx lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 nodeid_msr topoext perfctr_core arat cpb npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold
bogomips	: 7247.93
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate [9]

processor	: 7
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 1
model name	: AMD FX(tm)-8150 Eight-Core Processor           
stepping	: 2
microcode	: 0x6000623
cpu MHz		: 3623.753
cache size	: 2048 KB
physical id	: 0
siblings	: 8
core id		: 2
cpu cores	: 4
apicid		: 7
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni pclmulqdq monitor ssse3 cx16 sse4_1 sse4_2 popcnt aes xsave avx lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 nodeid_msr topoext perfctr_core arat cpb npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold
bogomips	: 7247.93
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate [9]


--=-wQL0t+x3avgBlScYCzTB--

