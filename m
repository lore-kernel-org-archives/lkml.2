Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab0KURgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 12:36:32 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:35839 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336Ab0KURg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 12:36:29 -0500
Message-ID: <4CE95893.8040008@gmail.com>
Date: Sun, 21 Nov 2010 18:36:19 +0100
From: Vincent Vanackere <vincent.vanackere@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [i915] 2.6.37-rc1 G33 regression : no DVI output
References: <AANLkTinEbBirwkREAVaaB4gH0w44tem0ik9nPU5-6aNJ@mail.gmail.com>	<c6d829$pk1i4l@fmsmga001.fm.intel.com>
In-Reply-To: <c6d829$pk1i4l@fmsmga001.fm.intel.com>
Content-Type: multipart/mixed;
 boundary="------------030302030106000706060004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030302030106000706060004
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/2010 12:49 PM, Chris Wilson wrote:
> On Sun, 21 Nov 2010 12:20:01 +0100, Vincent Vanackere<vincent.vanackere@gmail.com>  wrote:
>> Hi,
>>
>>   I'm trying to track down a regression occuring in recent kernel : I
>> get the DVI output of my intel G33 chipset through a Sapphire ADD2
>> DVI-D SDVO adaptor card and it was working fine until
>> kernel 2.6.37-rc1 :
>> - all more recent kernels only give a black screen
>> - I can log through ssh and no oops nor anything suspicious is in the log
>> - I get an output if I uses the VGA builtin port.
>
> Add drm.debug=0xe to your boot command line (or module options) and attach
> the dmesg. We're obviously failing to detect the output over the SDVO
> card, and hopefully we might have a reason in the debug log.
> -Chris
>

I attached the dmesg from the latest git kernel (commit 
b86db4744230c94e480de56f1b7f31117edbf193). Do you need the same 
information with a working kernel ?

Vincent


--------------030302030106000706060004
Content-Type: text/x-log;
 name="drm-debug.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="drm-debug.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-rc2-custom+ (root@marvin) (gcc version 4.5.2 (Ubuntu/Linaro 4.5.1-10ubuntu1) ) #1 SMP Sun Nov 21 18:21:43 CET 2010
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.37-rc2-custom+ root=UUID=bab2f734-5563-4c1a-84ff-06562667f32e ro drm.debug=0xe
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf5e0000 (usable)
[    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf5e3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf5e3000 - 00000000cf5f0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf5f0000 - 00000000cf600000 (reserved)
[    0.000000]  BIOS-e820: 00000000d0000000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: G33-DS3R/G33-DS3R, BIOS F7L 07/31/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CAFFF write-protect
[    0.000000]   CB000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   2 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   3 base 0CF800000 mask FFF800000 uncachable
[    0.000000]   4 base 0CF700000 mask FFFF00000 uncachable
[    0.000000]   5 base 100000000 mask FC0000000 write-back
[    0.000000]   6 base 130000000 mask FF0000000 uncachable
[    0.000000]   7 base 0CF600000 mask FFFF00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000cf600000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcf5e0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f5510] f5510
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000cf5e0000
[    0.000000]  0000000000 - 00cf400000 page 2M
[    0.000000]  00cf400000 - 00cf5e0000 page 4k
[    0.000000] kernel direct mapping tables up to cf5e0000 @ 1fffa000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000130000000
[    0.000000]  0100000000 - 0130000000 page 2M
[    0.000000] kernel direct mapping tables up to 130000000 @ cf5da000-cf5e0000
[    0.000000] RAMDISK: 37bca000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f6ed0 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000cf5e3040 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 00000000cf5e30c0 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000cf5e3180 053A1 (v01 GBT    GBTUACPI 00001000 MSFT 0100000C)
[    0.000000] ACPI: FACS 00000000cf5e0000 00040
[    0.000000] ACPI: HPET 00000000cf5e8680 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000cf5e8700 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: APIC 00000000cf5e8580 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: SSDT 00000000cf5e9060 003AB (v01  PmRef    CpuPm 00003000 INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000130000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000130000000
[    0.000000]   NODE_DATA [000000012fffb000 - 000000012fffffff]
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD -> [ffff88012be00000-ffff88012f7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000cf5e0
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1045871
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 831000 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cf5e0000 - 00000000cf5e3000
[    0.000000] PM: Registered nosave memory: 00000000cf5e3000 - 00000000cf5f0000
[    0.000000] PM: Registered nosave memory: 00000000cf5f0000 - 00000000cf600000
[    0.000000] PM: Registered nosave memory: 00000000cf600000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:1ec00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff8800cf200000 s83136 r8192 d23360 u524288
[    0.000000] pcpu-alloc: s83136 r8192 d23360 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1028841
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.37-rc2-custom+ root=UUID=bab2f734-5563-4c1a-84ff-06562667f32e ro drm.debug=0xe
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 4040388k/4980736k available (4800k kernel code, 797252k absent, 143096k reserved, 5995k data, 824k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2832.815 MHz processor.
[    0.000006] Calibrating delay loop (skipped), value calculated using timer frequency.. 5665.63 BogoMIPS (lpj=28328150)
[    0.010045] pid_max: default: 32768 minimum: 301
[    0.010104] Security Framework initialized
[    0.010520] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.012396] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.013274] Mount-cache hash table entries: 256
[    0.013434] Initializing cgroup subsys ns
[    0.013475] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.013535] Initializing cgroup subsys cpuacct
[    0.013576] Initializing cgroup subsys memory
[    0.013619] Initializing cgroup subsys devices
[    0.013659] Initializing cgroup subsys freezer
[    0.013725] CPU: Physical Processor ID: 0
[    0.013763] CPU: Processor Core ID: 0
[    0.013800] mce: CPU supports 6 MCE banks
[    0.013844] CPU0: Thermal monitoring enabled (TM2)
[    0.013885] using mwait in idle threads.
[    0.013923] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.014022] ... version:                2
[    0.014059] ... bit width:              40
[    0.014097] ... generic registers:      2
[    0.014135] ... value mask:             000000ffffffffff
[    0.014175] ... max period:             000000007fffffff
[    0.014215] ... fixed-purpose events:   3
[    0.014253] ... event mask:             0000000700000003
[    0.016375] ACPI: Core revision 20101013
[    0.023373] ftrace: allocating 18255 entries in 72 pages
[    0.030037] Setting APIC routing to flat
[    0.030368] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.130567] CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
[    0.140000] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.640024] Brought up 4 CPUs
[    0.640064] Total of 4 processors activated (22665.71 BogoMIPS).
[    0.642497] devtmpfs: initialized
[    0.642497] Time: 17:30:15  Date: 11/21/10
[    0.642497] NET: Registered protocol family 16
[    0.642497] ACPI: bus type pci registered
[    0.642497] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xd0000000-0xdfffffff] (base 0xd0000000)
[    0.642497] PCI: MMCONFIG at [mem 0xd0000000-0xdfffffff] reserved in E820
[    0.677677] PCI: Using configuration type 1 for base access
[    0.678155] bio: create slab <bio-0> at 0
[    0.678155] ACPI: EC: Look up EC in DSDT
[    0.683842] ACPI: SSDT 00000000cf5e8780 0022A (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.684111] ACPI: Dynamic OEM Table Load:
[    0.684184] ACPI: SSDT           (null) 0022A (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.684438] ACPI: SSDT 00000000cf5e8c40 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20040311)
[    0.684693] ACPI: Dynamic OEM Table Load:
[    0.684766] ACPI: SSDT           (null) 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20040311)
[    0.685022] ACPI: SSDT 00000000cf5e8da0 00152 (v01  PmRef  Cpu2Ist 00003000 INTL 20040311)
[    0.685278] ACPI: Dynamic OEM Table Load:
[    0.685350] ACPI: SSDT           (null) 00152 (v01  PmRef  Cpu2Ist 00003000 INTL 20040311)
[    0.685622] ACPI: SSDT 00000000cf5e8f00 00152 (v01  PmRef  Cpu3Ist 00003000 INTL 20040311)
[    0.685879] ACPI: Dynamic OEM Table Load:
[    0.685951] ACPI: SSDT           (null) 00152 (v01  PmRef  Cpu3Ist 00003000 INTL 20040311)
[    0.686170] ACPI: Interpreter enabled
[    0.686208] ACPI: (supports S0 S1 S4 S5)
[    0.686328] ACPI: Using IOAPIC for interrupt routing
[    0.689961] ACPI: No dock devices found.
[    0.690006] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.690155] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.690335] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.690379] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.690421] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.690478] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.690534] pci_root PNP0A03:00: host bridge window [mem 0xcf600000-0xfebfffff]
[    0.690599] pci 0000:00:00.0: [8086:29c0] type 0 class 0x000600
[    0.690629] pci 0000:00:02.0: [8086:29c2] type 0 class 0x000300
[    0.690637] pci 0000:00:02.0: reg 10: [mem 0xf2200000-0xf227ffff]
[    0.690642] pci 0000:00:02.0: reg 14: [io  0xe200-0xe207]
[    0.690646] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff pref]
[    0.690650] pci 0000:00:02.0: reg 1c: [mem 0xf2100000-0xf21fffff]
[    0.690675] pci 0000:00:02.1: [8086:29c3] type 0 class 0x000380
[    0.690681] pci 0000:00:02.1: reg 10: [mem 0xf2280000-0xf22fffff]
[    0.690735] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.690770] pci 0000:00:1a.0: reg 20: [io  0xe300-0xe31f]
[    0.690806] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.690842] pci 0000:00:1a.1: reg 20: [io  0xe000-0xe01f]
[    0.690878] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    0.690913] pci 0000:00:1a.2: reg 20: [io  0xe100-0xe11f]
[    0.690953] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.690967] pci 0000:00:1a.7: reg 10: [mem 0xf2304000-0xf23043ff]
[    0.691035] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.691047] pci 0000:00:1b.0: reg 10: [mem 0xf2300000-0xf2303fff 64bit]
[    0.691092] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.691095] pci 0000:00:1b.0: PME# disabled
[    0.691112] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.691157] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.691160] pci 0000:00:1c.0: PME# disabled
[    0.691178] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.691222] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.691225] pci 0000:00:1c.3: PME# disabled
[    0.691242] pci 0000:00:1c.4: [8086:2948] type 1 class 0x000604
[    0.691286] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.691289] pci 0000:00:1c.4: PME# disabled
[    0.691309] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.691344] pci 0000:00:1d.0: reg 20: [io  0xe400-0xe41f]
[    0.691380] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.691416] pci 0000:00:1d.1: reg 20: [io  0xe500-0xe51f]
[    0.691452] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.691487] pci 0000:00:1d.2: reg 20: [io  0xe600-0xe61f]
[    0.691527] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.691541] pci 0000:00:1d.7: reg 10: [mem 0xf2305000-0xf23053ff]
[    0.691606] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.691654] pci 0000:00:1f.0: [8086:2916] type 0 class 0x000601
[    0.691720] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
[    0.691779] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
[    0.691824] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0800 (mask 000f)
[    0.691883] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 000f)
[    0.691969] pci 0000:00:1f.2: [8086:2920] type 0 class 0x000101
[    0.691982] pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
[    0.691988] pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
[    0.691995] pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
[    0.692001] pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
[    0.692008] pci 0000:00:1f.2: reg 20: [io  0xf000-0xf00f]
[    0.692014] pci 0000:00:1f.2: reg 24: [io  0xfc00-0xfc0f]
[    0.692044] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.692056] pci 0000:00:1f.3: reg 10: [mem 0xf2306000-0xf23060ff 64bit]
[    0.692073] pci 0000:00:1f.3: reg 20: [io  0x0500-0x051f]
[    0.692100] pci 0000:00:1f.5: [8086:2926] type 0 class 0x000101
[    0.692112] pci 0000:00:1f.5: reg 10: [io  0xe800-0xe807]
[    0.692119] pci 0000:00:1f.5: reg 14: [io  0xe900-0xe903]
[    0.692125] pci 0000:00:1f.5: reg 18: [io  0xea00-0xea07]
[    0.692132] pci 0000:00:1f.5: reg 1c: [io  0xeb00-0xeb03]
[    0.692138] pci 0000:00:1f.5: reg 20: [io  0xec00-0xec0f]
[    0.692145] pci 0000:00:1f.5: reg 24: [io  0xed00-0xed0f]
[    0.692202] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.692741] pci 0000:00:1c.0:   bridge window [io  0xa000-0xafff]
[    0.692744] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.692749] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.692795] pci 0000:02:00.0: [197b:2363] type 0 class 0x000101
[    0.692875] pci 0000:02:00.0: reg 24: [mem 0xf2000000-0xf2001fff]
[    0.692914] pci 0000:02:00.0: PME# supported from D3hot
[    0.692918] pci 0000:02:00.0: PME# disabled
[    0.692944] pci 0000:02:00.1: [197b:2363] type 0 class 0x000101
[    0.692965] pci 0000:02:00.1: reg 10: [io  0xc000-0xc007]
[    0.692978] pci 0000:02:00.1: reg 14: [io  0xc100-0xc103]
[    0.692990] pci 0000:02:00.1: reg 18: [io  0xc200-0xc207]
[    0.693002] pci 0000:02:00.1: reg 1c: [io  0xc300-0xc303]
[    0.693014] pci 0000:02:00.1: reg 20: [io  0xc400-0xc40f]
[    0.693078] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.693150] pci 0000:00:1c.3: PCI bridge to [bus 02-02]
[    0.693191] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    0.693194] pci 0000:00:1c.3:   bridge window [mem 0xf2000000-0xf20fffff]
[    0.693199] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.693251] pci 0000:03:00.0: [10ec:8168] type 0 class 0x000200
[    0.693268] pci 0000:03:00.0: reg 10: [io  0xd000-0xd0ff]
[    0.693296] pci 0000:03:00.0: reg 18: [mem 0xf1000000-0xf1000fff 64bit]
[    0.693329] pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.693371] pci 0000:03:00.0: supports D1 D2
[    0.693372] pci 0000:03:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.693377] pci 0000:03:00.0: PME# disabled
[    0.693397] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.693465] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    0.693507] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.693510] pci 0000:00:1c.4:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.693514] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.693565] pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive decode)
[    0.693610] pci 0000:00:1e.0:   bridge window [io  0xb000-0xbfff]
[    0.693613] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.693618] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.693620] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.693622] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.693624] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.693626] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.693628] pci 0000:00:1e.0:   bridge window [mem 0xcf600000-0xfebfffff] (subtractive decode)
[    0.693644] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.693754] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.693787] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.693823] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.693853] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.701681] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.702003] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.702359] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
[    0.702679] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.703000] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.703356] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 *4 5 6 7 9 10 11 12 14 15)
[    0.703675] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.703996] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
[    0.704295] HEST: Table is not found!
[    0.704372] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.704439] vgaarb: loaded
[    0.704535] SCSI subsystem initialized
[    0.704585] libata version 3.00 loaded.
[    0.704585] usbcore: registered new interface driver usbfs
[    0.704585] usbcore: registered new interface driver hub
[    0.704585] usbcore: registered new device driver usb
[    0.704585] wmi: Mapper loaded
[    0.704585] PCI: Using ACPI for IRQ routing
[    0.704585] PCI: pci_cache_line_size set to 64 bytes
[    0.704585] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.704585] reserve RAM buffer: 00000000cf5e0000 - 00000000cfffffff 
[    0.704585] NetLabel: Initializing
[    0.704585] NetLabel:  domain hash size = 128
[    0.704585] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.704585] NetLabel:  unlabeled traffic allowed by default
[    0.704585] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.704585] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.704585] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.720017] Switching to clocksource tsc
[    0.725686] pnp: PnP ACPI init
[    0.725736] ACPI: bus type pnp registered
[    0.725859] pnp 00:00: [bus 00-ff]
[    0.725861] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.725863] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.725864] pnp 00:00: [io  0x0d00-0xffff window]
[    0.725866] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.725868] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.725870] pnp 00:00: [mem 0xcf600000-0xfebfffff window]
[    0.725918] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.725985] pnp 00:01: [io  0x0010-0x001f]
[    0.725987] pnp 00:01: [io  0x0022-0x003f]
[    0.725989] pnp 00:01: [io  0x0044-0x005f]
[    0.725990] pnp 00:01: [io  0x0062-0x0063]
[    0.725991] pnp 00:01: [io  0x0065-0x006f]
[    0.725993] pnp 00:01: [io  0x0074-0x007f]
[    0.725994] pnp 00:01: [io  0x0091-0x0093]
[    0.725996] pnp 00:01: [io  0x00a2-0x00bf]
[    0.725997] pnp 00:01: [io  0x00e0-0x00ef]
[    0.725998] pnp 00:01: [io  0x04d0-0x04d1]
[    0.726000] pnp 00:01: [io  0x0290-0x029f]
[    0.726001] pnp 00:01: [io  0x0800-0x087f]
[    0.726003] pnp 00:01: [io  0x0290-0x0294]
[    0.726004] pnp 00:01: [io  0x0880-0x088f]
[    0.726059] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.726069] pnp 00:02: [dma 4]
[    0.726071] pnp 00:02: [io  0x0000-0x000f]
[    0.726072] pnp 00:02: [io  0x0080-0x0090]
[    0.726074] pnp 00:02: [io  0x0094-0x009f]
[    0.726075] pnp 00:02: [io  0x00c0-0x00df]
[    0.726101] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.726149] pnp 00:03: [irq 0 disabled]
[    0.726157] pnp 00:03: [irq 8]
[    0.726159] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.726185] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.726211] pnp 00:04: [io  0x0070-0x0073]
[    0.726237] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.726244] pnp 00:05: [io  0x0061]
[    0.726271] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.726279] pnp 00:06: [io  0x00f0-0x00ff]
[    0.726283] pnp 00:06: [irq 13]
[    0.726308] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.726436] pnp 00:07: [io  0x03f0-0x03f5]
[    0.726438] pnp 00:07: [io  0x03f7]
[    0.726442] pnp 00:07: [irq 6]
[    0.726444] pnp 00:07: [dma 2]
[    0.726482] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.726735] pnp 00:08: [io  0x0400-0x04bf]
[    0.726776] pnp 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.726948] pnp 00:09: [mem 0xd0000000-0xdfffffff]
[    0.726998] pnp 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.727208] pnp 00:0a: [mem 0x000cb400-0x000cbfff]
[    0.727210] pnp 00:0a: [mem 0x000f0000-0x000f7fff]
[    0.727212] pnp 00:0a: [mem 0x000f8000-0x000fbfff]
[    0.727213] pnp 00:0a: [mem 0x000fc000-0x000fffff]
[    0.727215] pnp 00:0a: [mem 0xcf5e0000-0xcf5fffff]
[    0.727217] pnp 00:0a: [mem 0x00000000-0x0009ffff]
[    0.727218] pnp 00:0a: [mem 0x00100000-0xcf5dffff]
[    0.727220] pnp 00:0a: [mem 0xfec00000-0xfec00fff]
[    0.727221] pnp 00:0a: [mem 0xfed10000-0xfed1dfff]
[    0.727223] pnp 00:0a: [mem 0xfed20000-0xfed8ffff]
[    0.727224] pnp 00:0a: [mem 0xfee00000-0xfee00fff]
[    0.727225] pnp 00:0a: [mem 0xffb00000-0xffb7ffff]
[    0.727227] pnp 00:0a: [mem 0xfff00000-0xffffffff]
[    0.727228] pnp 00:0a: [mem 0x000e0000-0x000effff]
[    0.727283] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.727302] pnp 00:0b: [mem 0xffb80000-0xffbfffff]
[    0.727340] pnp 00:0b: Plug and Play ACPI device, IDs INT0800 (active)
[    0.727345] pnp: PnP ACPI: found 12 devices
[    0.727383] ACPI: ACPI bus type pnp unregistered
[    0.727432] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.727474] system 00:01: [io  0x0290-0x029f] has been reserved
[    0.727515] system 00:01: [io  0x0800-0x087f] has been reserved
[    0.727557] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.727598] system 00:01: [io  0x0880-0x088f] has been reserved
[    0.727643] system 00:08: [io  0x0400-0x04bf] could not be reserved
[    0.727687] system 00:09: [mem 0xd0000000-0xdfffffff] has been reserved
[    0.727732] system 00:0a: [mem 0x000cb400-0x000cbfff] has been reserved
[    0.727775] system 00:0a: [mem 0x000f0000-0x000f7fff] could not be reserved
[    0.727819] system 00:0a: [mem 0x000f8000-0x000fbfff] could not be reserved
[    0.727863] system 00:0a: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.727906] system 00:0a: [mem 0xcf5e0000-0xcf5fffff] could not be reserved
[    0.727950] system 00:0a: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.727993] system 00:0a: [mem 0x00100000-0xcf5dffff] could not be reserved
[    0.728037] system 00:0a: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.728081] system 00:0a: [mem 0xfed10000-0xfed1dfff] has been reserved
[    0.728124] system 00:0a: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.728167] system 00:0a: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.728210] system 00:0a: [mem 0xffb00000-0xffb7ffff] has been reserved
[    0.728253] system 00:0a: [mem 0xfff00000-0xffffffff] has been reserved
[    0.728295] system 00:0a: [mem 0x000e0000-0x000effff] has been reserved
[    0.734136] pci 0000:00:1c.0: BAR 14: assigned [mem 0xfea00000-0xfebfffff]
[    0.734182] pci 0000:00:1c.0: BAR 15: assigned [mem 0xfe800000-0xfe9fffff 64bit pref]
[    0.734241] pci 0000:00:1c.3: BAR 15: assigned [mem 0xfe600000-0xfe7fffff 64bit pref]
[    0.734300] pci 0000:00:1c.4: BAR 15: assigned [mem 0xfe400000-0xfe5fffff pref]
[    0.734357] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.734398] pci 0000:00:1c.0:   bridge window [io  0xa000-0xafff]
[    0.734442] pci 0000:00:1c.0:   bridge window [mem 0xfea00000-0xfebfffff]
[    0.734486] pci 0000:00:1c.0:   bridge window [mem 0xfe800000-0xfe9fffff 64bit pref]
[    0.734546] pci 0000:00:1c.3: PCI bridge to [bus 02-02]
[    0.734587] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    0.734630] pci 0000:00:1c.3:   bridge window [mem 0xf2000000-0xf20fffff]
[    0.734675] pci 0000:00:1c.3:   bridge window [mem 0xfe600000-0xfe7fffff 64bit pref]
[    0.734736] pci 0000:03:00.0: BAR 6: assigned [mem 0xfe5e0000-0xfe5fffff pref]
[    0.734792] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    0.734833] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.734877] pci 0000:00:1c.4:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.734921] pci 0000:00:1c.4:   bridge window [mem 0xfe400000-0xfe5fffff pref]
[    0.734980] pci 0000:00:1e.0: PCI bridge to [bus 04-04]
[    0.735021] pci 0000:00:1e.0:   bridge window [io  0xb000-0xbfff]
[    0.735065] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.735107] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.735160] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.735205] pci 0000:00:1c.0: setting latency timer to 64
[    0.735211] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.735255] pci 0000:00:1c.3: setting latency timer to 64
[    0.735260] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.735304] pci 0000:00:1c.4: setting latency timer to 64
[    0.735309] pci 0000:00:1e.0: setting latency timer to 64
[    0.735312] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.735314] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.735315] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.735317] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.735319] pci_bus 0000:00: resource 8 [mem 0xcf600000-0xfebfffff]
[    0.735321] pci_bus 0000:01: resource 0 [io  0xa000-0xafff]
[    0.735322] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfebfffff]
[    0.735324] pci_bus 0000:01: resource 2 [mem 0xfe800000-0xfe9fffff 64bit pref]
[    0.735326] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    0.735328] pci_bus 0000:02: resource 1 [mem 0xf2000000-0xf20fffff]
[    0.735330] pci_bus 0000:02: resource 2 [mem 0xfe600000-0xfe7fffff 64bit pref]
[    0.735331] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.735333] pci_bus 0000:03: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.735335] pci_bus 0000:03: resource 2 [mem 0xfe400000-0xfe5fffff pref]
[    0.735337] pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
[    0.735339] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    0.735340] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    0.735342] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    0.735344] pci_bus 0000:04: resource 7 [mem 0x000c0000-0x000dffff]
[    0.735345] pci_bus 0000:04: resource 8 [mem 0xcf600000-0xfebfffff]
[    0.735368] NET: Registered protocol family 2
[    0.735521] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.736462] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.739611] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.740127] TCP: Hash tables configured (established 524288 bind 65536)
[    0.740172] TCP reno registered
[    0.740220] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.740294] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.740446] NET: Registered protocol family 1
[    0.740501] pci 0000:00:02.0: Boot video device
[    0.740653] PCI: CLS 32 bytes, default 64
[    0.740701] Trying to unpack rootfs image as initramfs...
[    0.812068] Freeing initrd memory: 4248k freed
[    0.813099] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.813143] Placing 64MB software IO TLB between ffff8800cb200000 - ffff8800cf200000
[    0.813200] software IO TLB at phys 0xcb200000 - 0xcf200000
[    0.813517] Scanning for low memory corruption every 60 seconds
[    0.813669] audit: initializing netlink socket (disabled)
[    0.813719] type=2000 audit(1290360614.800:1): initialized
[    0.822153] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.823956] fuse init (API version 7.15)
[    0.824071] msgmni has been set to 7899
[    0.824376] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.824433] io scheduler noop registered
[    0.824471] io scheduler deadline registered
[    0.824537] io scheduler cfq registered (default)
[    0.824742] intel_idle: MWAIT substates: 0x22220
[    0.824744] intel_idle: does not run on family 6 model 23
[    0.824819] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.824880] ACPI: Power Button [PWRB]
[    0.824966] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.825023] ACPI: Power Button [PWRF]
[    0.825216] ACPI: acpi_idle registered with cpuidle
[    0.826565] ERST: Table is not found!
[    0.826757] Linux agpgart interface v0.103
[    0.826814] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.011054] brd: module loaded
[    1.011517] loop: module loaded
[    1.011630] ata_piix 0000:00:1f.2: version 2.13
[    1.011642] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.011688] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    1.011851] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.012115] scsi0 : ata_piix
[    1.012247] scsi1 : ata_piix
[    1.012794] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    1.012840] ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    1.012902] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.012970] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    1.013121] ata_piix 0000:00:1f.5: setting latency timer to 64
[    1.013316] scsi2 : ata_piix
[    1.013434] scsi3 : ata_piix
[    1.013915] ata3: SATA max UDMA/133 cmd 0xe800 ctl 0xe900 bmdma 0xec00 irq 19
[    1.013960] ata4: SATA max UDMA/133 cmd 0xea00 ctl 0xeb00 bmdma 0xec08 irq 19
[    1.014060] pata_acpi 0000:02:00.1: enabling device (0000 -> 0001)
[    1.014117] pata_acpi 0000:02:00.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.014195] pata_acpi 0000:02:00.1: setting latency timer to 64
[    1.014205] pata_acpi 0000:02:00.1: PCI INT B disabled
[    1.014267] tun: Universal TUN/TAP device driver, 1.6
[    1.014307] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.014409] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.014465] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.014526] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.014532] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.014598] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.018555] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    1.018566] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf2304000
[    1.040012] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.040170] hub 1-0:1.0: USB hub found
[    1.040227] hub 1-0:1.0: 6 ports detected
[    1.040324] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.040376] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.040378] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.040447] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.044407] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.044418] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf2305000
[    1.060011] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.060151] hub 2-0:1.0: USB hub found
[    1.060200] hub 2-0:1.0: 6 ports detected
[    1.060294] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.060344] uhci_hcd: USB Universal Host Controller Interface driver
[    1.060421] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.060467] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.060470] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.060533] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.060624] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e300
[    1.060753] hub 3-0:1.0: USB hub found
[    1.060792] hub 3-0:1.0: 2 ports detected
[    1.061380] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.061426] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.061429] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.061495] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.061585] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000e000
[    1.061714] hub 4-0:1.0: USB hub found
[    1.061753] hub 4-0:1.0: 2 ports detected
[    1.061840] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.061886] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.061889] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.061958] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.062042] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000e100
[    1.062170] hub 5-0:1.0: USB hub found
[    1.062209] hub 5-0:1.0: 2 ports detected
[    1.062297] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.062343] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.062345] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.062411] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.062497] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e400
[    1.062632] hub 6-0:1.0: USB hub found
[    1.062671] hub 6-0:1.0: 2 ports detected
[    1.062759] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.062806] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.062809] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.062874] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.062957] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e500
[    1.063091] hub 7-0:1.0: USB hub found
[    1.063130] hub 7-0:1.0: 2 ports detected
[    1.063217] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.063263] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.063266] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.063331] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.063414] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e600
[    1.063544] hub 8-0:1.0: USB hub found
[    1.063584] hub 8-0:1.0: 2 ports detected
[    1.063707] PNP: No PS/2 controller found. Probing ports directly.
[    1.064069] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.064112] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.064226] mice: PS/2 mouse device common for all mice
[    1.064355] rtc_cmos 00:04: RTC can wake from S4
[    1.140071] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.140136] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.140299] cpuidle: using governor ladder
[    1.140342] cpuidle: using governor menu
[    1.140536] TCP cubic registered
[    1.140573] NET: Registered protocol family 17
[    1.140624] Registering the dns_resolver key type
[    1.146042] PM: Hibernation image not present or could not be loaded.
[    1.146053] registered taskstats version 1
[    1.146331]   Magic number: 2:889:542
[    1.146457] rtc_cmos 00:04: setting system clock to 2010-11-21 17:30:15 UTC (1290360615)
[    1.146520] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.146561] EDD information not available.
[    1.360022] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    1.515664] hub 1-1:1.0: USB hub found
[    1.516246] hub 1-1:1.0: 4 ports detected
[    1.520045] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.520202] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.540310] ata3.00: ATA-7: SAMSUNG HD753LJ, 1AA01110, max UDMA7
[    1.540362] ata3.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.540460] ata4.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
[    1.540505] ata4.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.560305] ata3.00: configured for UDMA/133
[    1.560367] ata4.00: configured for UDMA/133
[    1.850020] usb 3-2: new low speed USB device using uhci_hcd and address 2
[    1.870056] ata2.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.870111] ata2.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.870268] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.870324] ata1.01: SATA link down (SStatus 0 SControl 300)
[    1.890320] ata1.00: ATA-8: OCZ-VERTEX, 1.5, max UDMA/133
[    1.890360] ata1.00: 125045424 sectors, multi 1: LBA48 NCQ (depth 0/32)
[    1.910263] ata2.00: ATA-7: SAMSUNG SP2504C, VT100-50, max UDMA7
[    1.910308] ata2.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.910356] ata2.01: ATAPI: ASUS    DRW-1814BLT, 1.04, max UDMA/66
[    1.930191] ata1.00: configured for UDMA/133
[    1.930339] scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX       1.5  PQ: 0 ANSI: 5
[    1.930524] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.930540] sd 0:0:0:0: [sda] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
[    1.930593] sd 0:0:0:0: [sda] Write Protect is off
[    1.930595] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.930612] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.931174]  sda: sda1 sda2 sda3 sda4
[    1.931473] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.970219] ata2.00: configured for UDMA/133
[    2.010118] ata2.01: configured for UDMA/66
[    2.010921] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG SP2504C  VT10 PQ: 0 ANSI: 5
[    2.011108] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.011123] sd 1:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    2.011175] sd 1:0:0:0: [sdb] Write Protect is off
[    2.011178] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.011199] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.021400]  sdb: sdb1 sdb2
[    2.021562] scsi 1:0:1:0: CD-ROM            ASUS     DRW-1814BLT      1.04 PQ: 0 ANSI: 5
[    2.021650] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.026020] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.026086] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.026189] sr 1:0:1:0: Attached scsi CD-ROM sr0
[    2.026243] sr 1:0:1:0: Attached scsi generic sg2 type 5
[    2.026387] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
[    2.026532] sd 2:0:0:0: [sdc] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    2.026558] sd 2:0:0:0: Attached scsi generic sg3 type 0
[    2.026635] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
[    2.026717] sd 3:0:0:0: [sdd] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    2.026730] sd 3:0:0:0: Attached scsi generic sg4 type 0
[    2.026747] sd 2:0:0:0: [sdc] Write Protect is off
[    2.026749] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.026771] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.027023] sd 3:0:0:0: [sdd] Write Protect is off
[    2.027063] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    2.027085] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.038681]  sdc: unknown partition table
[    2.038878] sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.048030]  sdd: sdd1
[    2.048223] sd 3:0:0:0: [sdd] Attached SCSI disk
[    2.048287] Freeing unused kernel memory: 824k freed
[    2.048467] Write protecting the kernel read-only data: 10240k
[    2.048709] Freeing unused kernel memory: 1324k freed
[    2.049122] Freeing unused kernel memory: 2044k freed
[    2.061955] udev[75]: starting version 164
[    2.107403] ahci 0000:02:00.0: version 3.0
[    2.107419] ahci 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.110137] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.110200] r8169 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.110291] r8169 0000:03:00.0: setting latency timer to 64
[    2.110353] r8169 0000:03:00.0: irq 40 for MSI/MSI-X
[    2.110632] r8169 0000:03:00.0: eth0: RTL8168b/8111b at 0xffffc90000650000, 00:1a:4d:41:cc:e0, XID 18000000 IRQ 40
[    2.115711] Btrfs loaded
[    2.120053] ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    2.120143] ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    2.120197] ahci 0000:02:00.0: setting latency timer to 64
[    2.120369] usb 1-1.1: new low speed USB device using ehci_hcd and address 4
[    2.120578] scsi4 : ahci
[    2.120706] scsi5 : ahci
[    2.120841] ata5: SATA max UDMA/133 abar m8192@0xf2000000 port 0xf2000100 irq 19
[    2.120903] ata6: SATA max UDMA/133 abar m8192@0xf2000000 port 0xf2000180 irq 19
[    2.124122] input: A4Tech Wireless Battery Free Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input2
[    2.124271] generic-usb 0003:09DA:022B.0001: input,hidraw0: USB HID v1.10 Mouse [A4Tech Wireless Battery Free Optical Mouse] on usb-0000:00:1a.0-2/input0
[    2.124361] usbcore: registered new interface driver usbhid
[    2.124416] usbhid: USB HID core driver
[    2.270452] device fsid 2418f358cca8245-a82ad5df04b9b983 devid 1 transid 28326 /dev/sdd1
[    2.309928] device label goinfre devid 1 transid 16136 /dev/sdc
[    2.340281] usb 1-1.3: new full speed USB device using ehci_hcd and address 5
[    2.382932] sr 1:0:1:0: [sr0]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[    2.383012] sr 1:0:1:0: [sr0]  Sense Key : Illegal Request [current] 
[    2.383112] sr 1:0:1:0: [sr0]  Add. Sense: Illegal mode for this track
[    2.383196] sr 1:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 00 20 00 00 02 00
[    2.383472] end_request: I/O error, dev sr0, sector 128
[    2.383511] Buffer I/O error on device sr0, logical block 16
[    2.384695] sr 1:0:1:0: [sr0]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[    2.384775] sr 1:0:1:0: [sr0]  Sense Key : Illegal Request [current] 
[    2.384875] sr 1:0:1:0: [sr0]  Add. Sense: Illegal mode for this track
[    2.384959] sr 1:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 00 20 00 00 02 00
[    2.385236] end_request: I/O error, dev sr0, sector 128
[    2.385277] Buffer I/O error on device sr0, logical block 16
[    2.386464] sr 1:0:1:0: [sr0]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[    2.386543] sr 1:0:1:0: [sr0]  Sense Key : Illegal Request [current] 
[    2.386642] sr 1:0:1:0: [sr0]  Add. Sense: Illegal mode for this track
[    2.386725] sr 1:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 80 00 00 00 02 00
[    2.387000] end_request: I/O error, dev sr0, sector 131072
[    2.387040] Buffer I/O error on device sr0, logical block 16384
[    2.401171] sr 1:0:1:0: [sr0]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[    2.401250] sr 1:0:1:0: [sr0]  Sense Key : Illegal Request [current] 
[    2.401350] sr 1:0:1:0: [sr0]  Add. Sense: Illegal mode for this track
[    2.401433] sr 1:0:1:0: [sr0] CDB: Read(10): 28 00 00 00 80 00 00 00 02 00
[    2.401710] end_request: I/O error, dev sr0, sector 131072
[    2.401751] Buffer I/O error on device sr0, logical block 16384
[    2.460050] ata6: SATA link down (SStatus 0 SControl 300)
[    2.467976] input: Elan USB Audio as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.3/1-1.3:1.3/input/input3
[    2.468137] generic-usb 0003:04F3:0A11.0004: input,hidraw1: USB HID v1.00 Device [Elan USB Audio] on usb-0000:00:1a.7-1.3/input3
[    2.470030] ata5: SATA link down (SStatus 0 SControl 300)
[    2.540319] usb 1-1.4: new low speed USB device using ehci_hcd and address 6
[    2.670088] input: HID 0566:3108 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.4/1-1.4:1.0/input/input4
[    2.670243] generic-usb 0003:0566:3108.0005: input,hidraw2: USB HID v1.10 Keyboard [HID 0566:3108] on usb-0000:00:1a.7-1.4/input0
[    2.674298] input: HID 0566:3108 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.4/1-1.4:1.1/input/input5
[    2.674443] generic-usb 0003:0566:3108.0006: input,hidraw3: USB HID v1.10 Device [HID 0566:3108] on usb-0000:00:1a.7-1.4/input1
[    2.692422] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1:1.0/input/input6
[    2.692622] logitech 0003:046D:C101.0002: input,hidraw4: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:1a.7-1.1/input0
[    2.720283] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1:1.1/input/input7
[    2.720565] logitech 0003:046D:C101.0003: input,hiddev0,hidraw5: USB HID v1.10 Device [Logitech USB Receiver] on usb-0000:00:1a.7-1.1/input1
[    7.452647] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[    7.452651] PM: Marking nosave pages: 00000000cf5e0000 - 0000000100000000
[    7.453203] PM: Basic memory bitmaps created
[    7.467802] PM: Basic memory bitmaps freed
[    7.472280] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    7.741338] Adding 512508k swap on /dev/sda2.  Priority:-1 extents:1 across:512508k SS
[    7.818393] EXT4-fs (sda3): re-mounted. Opts: (null)
[    7.856191] EXT3-fs: barriers not enabled
[    7.856369] kjournald starting.  Commit interval 5 seconds
[    7.856388] EXT3-fs (sda1): warning: maximal mount count reached, running e2fsck is recommended
[    7.856473] EXT3-fs (sda1): using internal journal
[    7.856476] EXT3-fs (sda1): mounted filesystem with ordered data mode
[    7.868320] EXT4-fs (sda4): warning: maximal mount count reached, running e2fsck is recommended
[    7.868507] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
[    7.894241] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[    7.895902] device label goinfre devid 1 transid 16136 /dev/sdc
[    7.946901] udev[463]: starting version 164
[    8.093886] agpgart-intel 0000:00:00.0: Intel G33 Chipset
[    8.093994] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
[    8.095438] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    8.108400] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    8.217045] [drm] Initialized drm 1.1.0 20060810
[    8.240068] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.240072] i915 0000:00:02.0: setting latency timer to 64
[    8.282644] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[    8.282647] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    8.283015] [drm:intel_opregion_setup], graphic opregion physical addr: 0xcf5e0800
[    8.283035] [drm:intel_opregion_setup], SWSCI supported
[    8.283055] i915 0000:00:02.0: irq 41 for MSI/MSI-X
[    8.283075] [drm:init_status_page], render ring hws offset: 0x007bf000
[    8.283158] [drm:intel_parse_bios], Using VBT from OpRegion: $VBT BEARLAKE-B     d
[    8.283166] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    8.283181] [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 70 is found on SDVOB port
[    8.283184] [drm:parse_sdvo_device_mapping], SDVO device: dvo=1, addr=70, wiring=1, ddc_pin=29, i2c_pin=5, i2c_speed=3
[    8.283200] [drm:intel_dsm_pci_probe], no _DSM method for intel device
[    8.283213] [drm:intel_modeset_init], 2 display pipes available.
[    8.283252] [drm:intel_setup_outputs], probing SDVOB
[    8.399084] [drm:intel_sdvo_debug_write], SDVOB: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
[    8.403950] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 04 AA 02 00 01 01 01 00
[    8.417992] [drm:intel_sdvo_get_capabilities], SDVO capabilities:
[    8.417996]   vendor_id: 4
[    8.417996]   device_id: 170
[    8.417997]   device_rev_id: 2
[    8.417997]   sdvo_version_major: 0
[    8.417998]   sdvo_version_minor: 1
[    8.417998]   sdvo_inputs_mask: 1
[    8.417999]   smooth_scaling: 0
[    8.417999]   sharp_scaling: 0
[    8.418000]   up_scaling: 0
[    8.418000]   down_scaling: 0
[    8.418001]   stall_support: 0
[    8.418001]   output_flags: 1
[    8.418004] [drm:intel_sdvo_debug_write], SDVOB: W: 9D                         (SDVO_CMD_GET_SUPP_ENCODE)
[    8.420976] [drm:intel_sdvo_write_cmd], command returns response Not supported [2]
[    8.421108] [drm:intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[    8.425262] [drm:intel_sdvo_debug_write], SDVOB: W: 1D                         (SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE)
[    8.430067] [drm:intel_sdvo_read_response], SDVOB: R: (Success) C4 09 74 40
[    8.437202] [drm:intel_sdvo_init], SDVOB device VID/DID: 04:AA.02, clock range 25MHz - 165MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
[    8.437206] [drm:intel_setup_outputs], probing SDVOC
[    8.439305] [drm:intel_sdvo_read_byte], i2c transfer returned -6
[    8.439308] [drm:intel_sdvo_init], No SDVO device found on SDVOC
[    8.439347] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    8.439665] [drm] initialized overlay support
[    8.439685] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    8.455675] [drm:intel_update_fbc], 
[    8.455678] [drm:intel_update_watermarks], plane B (pipe 1) clock: 0
[    8.455681] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    8.455683] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    8.455685] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    8.455687] [drm:intel_calculate_wm], FIFO watermark level: 26
[    8.455689] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    8.455691] [drm:intel_calculate_wm], FIFO watermark level: 29
[    8.455692] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    8.455694] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    8.455698] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    8.455701] [drm:intel_update_fbc], 
[    8.455704] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[    8.470041] [drm:intel_crt_detect], CRT not detected via hotplug
[    8.470044] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[    8.470049] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
[    8.470052] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    8.475032] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    8.478700] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[    8.478704] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    8.484941] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    8.539803] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    8.594855] [drm:drm_detect_monitor_audio], Monitor has basic audio support
[    8.594862] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    8.600715] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    8.655484] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    8.710562] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] probed modes :
[    8.710565] [drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1200" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[    8.710569] [drm:drm_mode_debug_printmodeline], Modeline 17:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[    8.710572] [drm:drm_mode_debug_printmodeline], Modeline 18:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[    8.710576] [drm:drm_mode_debug_printmodeline], Modeline 14:"1280x1024" 76 141813 1280 1376 1512 1744 1024 1025 1028 1070 0x0 0x6
[    8.710579] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    8.710583] [drm:drm_mode_debug_printmodeline], Modeline 16:"1280x1024" 72 132840 1280 1368 1504 1728 1024 1025 1028 1067 0x0 0x6
[    8.710586] [drm:drm_mode_debug_printmodeline], Modeline 15:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[    8.710590] [drm:drm_mode_debug_printmodeline], Modeline 19:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[    8.710593] [drm:drm_mode_debug_printmodeline], Modeline 20:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[    8.710596] [drm:drm_mode_debug_printmodeline], Modeline 34:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[    8.710600] [drm:drm_mode_debug_printmodeline], Modeline 12:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
[    8.710603] [drm:drm_mode_debug_printmodeline], Modeline 28:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[    8.710606] [drm:drm_mode_debug_printmodeline], Modeline 29:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[    8.710610] [drm:drm_mode_debug_printmodeline], Modeline 30:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    8.710613] [drm:drm_mode_debug_printmodeline], Modeline 31:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[    8.710616] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[    8.710620] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[    8.710623] [drm:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    8.710626] [drm:drm_mode_debug_printmodeline], Modeline 23:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[    8.710630] [drm:drm_mode_debug_printmodeline], Modeline 22:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[    8.710633] [drm:drm_mode_debug_printmodeline], Modeline 24:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[    8.710636] [drm:drm_mode_debug_printmodeline], Modeline 25:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    8.710639] [drm:drm_mode_debug_printmodeline], Modeline 26:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    8.710643] [drm:drm_setup_crtcs], 
[    8.710646] [drm:drm_enable_connectors], connector 5 enabled? no
[    8.710647] [drm:drm_enable_connectors], connector 8 enabled? yes
[    8.710650] [drm:drm_target_preferred], looking for cmdline mode on connector 8
[    8.710652] [drm:drm_target_preferred], looking for preferred mode on connector 8
[    8.710654] [drm:drm_target_preferred], found mode 1920x1200
[    8.710656] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[    8.710659] [drm:drm_setup_crtcs], desired mode 1920x1200 set on crtc 3
[    8.719790] [drm:intelfb_create], allocated 1920x1200 fb: 0x007f0000, bo ffff8801252ae600
[    8.720479] [drm:drm_crtc_helper_set_config], 
[    8.720481] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:35] #connectors=1 (x y) (0 0)
[    8.720486] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    8.720488] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[    8.720490] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    8.720492] [drm:drm_mode_debug_printmodeline], Modeline 13:"1920x1200" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[    8.720496] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[    8.720498] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[    8.720500] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    8.720502] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[    8.720503] [drm:drm_mode_debug_printmodeline], Modeline 13:"1920x1200" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[    8.720508] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[    8.720510] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    8.725949] [drm:intel_crtc_mode_set], Mode for pipe A:
[    8.725951] [drm:drm_mode_debug_printmodeline], Modeline 13:"1920x1200" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[    8.740016] [drm:intel_pipe_set_base_atomic], Writing base 007F0000 00000000 0 0 7680
[    8.740021] [drm:intel_update_fbc], 
[    8.740024] [drm:drm_crtc_helper_set_mode], [ENCODER:7:TMDS-7] set [MODE:13:1920x1200]
[    8.740027] [drm:intel_sdvo_debug_write], SDVOB: W: 07 01 00 00 00             (SDVO_CMD_SET_IN_OUT_MAP)
[    8.747826] [drm:intel_sdvo_write_cmd], command returns response Not supported [2]
[    8.747828] [drm:intel_sdvo_debug_write], SDVOB: W: 11 01 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    8.753161] [drm:intel_sdvo_debug_write], SDVOB: W: 11 01 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    8.758485] [drm:intel_sdvo_debug_write], SDVOB: W: 16 28 3C 80 A0 70 B0 23 40 (SDVO_CMD_SET_OUTPUT_TIMINGS_PART1)
[    8.771225] [drm:intel_sdvo_write_cmd], command returns response Not supported [2]
[    8.771227] [drm:intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[    8.775340] [drm:intel_sdvo_debug_write], SDVOB: W: 93 01 00                   (SDVO_CMD_SET_HBUF_INDEX)
[    8.780688] [drm:intel_sdvo_write_cmd], command returns response Not supported [2]
[    8.780690] [drm:intel_update_watermarks], plane A (pipe 0) clock: 154000
[    8.780692] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    8.780694] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    8.780696] [drm:intel_calculate_wm], FIFO entries required for mode: 49
[    8.780698] [drm:intel_calculate_wm], FIFO watermark level: -23
[    8.780699] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    8.780700] [drm:intel_calculate_wm], FIFO watermark level: 29
[    8.780702] [drm:i9xx_update_wm], FIFO watermarks - A: 1, B: 29
[    8.780704] [drm:i9xx_update_wm], self-refresh entries: 120
[    8.780705] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 1, B: 29, C: 2, SR 1
[    8.781361] [drm:intel_update_fbc], 
[    8.820017] [drm:intel_sdvo_debug_write], SDVOB: W: 03                         (SDVO_CMD_GET_TRAINED_INPUTS)
[    8.824667] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00
[    8.826380] [drm:intel_sdvo_dpms], First SDVOB output reported failure to sync
[    8.826382] [drm:intel_sdvo_debug_write], SDVOB: W: 05 01 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    8.831689] [drm:drm_crtc_helper_set_config], 
[    8.831690] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:35] #connectors=0 (x y) (0 0)
[    8.831695] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    8.831697] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    8.831727] [drm:drm_crtc_helper_set_config], 
[    8.831728] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:35] #connectors=1 (x y) (0 0)
[    8.831732] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    8.838123] Console: switching to colour frame buffer device 240x75
[    8.838127] [drm:drm_crtc_helper_set_config], 
[    8.838128] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:35] #connectors=1 (x y) (0 0)
[    8.838131] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    8.844059] fb0: inteldrmfb frame buffer device
[    8.844061] drm: registered panic notifier
[    8.844206] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    8.844265] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    8.844335] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[    8.844363] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    8.859439] [drm:i915_driver_open], 
[    8.859452] [drm:drm_crtc_helper_set_config], 
[    8.859455] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:35] #connectors=1 (x y) (0 0)
[    8.859461] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    8.859463] [drm:drm_crtc_helper_set_config], 
[    8.859465] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:35] #connectors=0 (x y) (0 0)
[    8.859468] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    8.859470] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    8.859480] [drm:i915_driver_open], 
[    8.859486] [drm:drm_crtc_helper_set_config], 
[    8.859487] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:35] #connectors=1 (x y) (0 0)
[    8.859491] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    8.859493] [drm:drm_crtc_helper_set_config], 
[    8.859494] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:35] #connectors=0 (x y) (0 0)
[    8.859497] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    8.859499] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    8.859507] [drm:i915_driver_open], 
[    8.859524] [drm:i915_getparam], Unknown parameter 12
[    8.859564] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[2] ENCODERS[2]
[    8.859568] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[2] ENCODERS[2]
[    8.859571] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[    8.859574] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[    8.870010] [drm:intel_crt_detect], CRT not detected via hotplug
[    8.870014] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[    8.870019] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[    8.870022] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[    8.890012] [drm:intel_crt_detect], CRT not detected via hotplug
[    8.890015] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[    8.890026] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[    8.890029] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
[    8.890035] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    8.894624] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    8.898016] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[    8.898019] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    8.903831] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    8.959408] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    9.014126] [drm:drm_detect_monitor_audio], Monitor has basic audio support
[    9.014137] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    9.019978] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    9.074736] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    9.096659] device fsid 2418f358cca8245-a82ad5df04b9b983 devid 1 transid 28326 /dev/sdd1
[    9.129607] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] probed modes :
[    9.129610] [drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1200" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[    9.129614] [drm:drm_mode_debug_printmodeline], Modeline 17:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[    9.129617] [drm:drm_mode_debug_printmodeline], Modeline 18:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[    9.129621] [drm:drm_mode_debug_printmodeline], Modeline 14:"1280x1024" 76 141813 1280 1376 1512 1744 1024 1025 1028 1070 0x0 0x6
[    9.129624] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    9.129628] [drm:drm_mode_debug_printmodeline], Modeline 16:"1280x1024" 72 132840 1280 1368 1504 1728 1024 1025 1028 1067 0x0 0x6
[    9.129631] [drm:drm_mode_debug_printmodeline], Modeline 15:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[    9.129634] [drm:drm_mode_debug_printmodeline], Modeline 19:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[    9.129638] [drm:drm_mode_debug_printmodeline], Modeline 20:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[    9.129641] [drm:drm_mode_debug_printmodeline], Modeline 34:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[    9.129645] [drm:drm_mode_debug_printmodeline], Modeline 12:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
[    9.129648] [drm:drm_mode_debug_printmodeline], Modeline 28:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[    9.129651] [drm:drm_mode_debug_printmodeline], Modeline 29:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[    9.129655] [drm:drm_mode_debug_printmodeline], Modeline 30:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    9.129658] [drm:drm_mode_debug_printmodeline], Modeline 31:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[    9.129661] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[    9.129665] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[    9.129668] [drm:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    9.129671] [drm:drm_mode_debug_printmodeline], Modeline 23:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[    9.129674] [drm:drm_mode_debug_printmodeline], Modeline 22:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[    9.129678] [drm:drm_mode_debug_printmodeline], Modeline 24:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[    9.129681] [drm:drm_mode_debug_printmodeline], Modeline 25:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    9.129685] [drm:drm_mode_debug_printmodeline], Modeline 26:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    9.129704] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[    9.139763] [drm:drm_crtc_helper_set_config], 
[    9.139767] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:35] #connectors=1 (x y) (0 0)
[    9.139776] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[   15.677395] sshd (997): /proc/997/oom_adj is deprecated, please use /proc/997/oom_score_adj instead.
[   15.721693] r8169 0000:03:00.0: eth0: link up
[   15.721700] r8169 0000:03:00.0: eth0: link up
[   15.773165] [drm:i915_driver_open], 
[   15.773208] [drm:i915_driver_open], 
[   15.773342] [drm:i915_getparam], Unknown parameter 12
[   15.773387] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[2] ENCODERS[2]
[   15.773391] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[2] ENCODERS[2]
[   15.773425] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   15.773428] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   15.790024] [drm:intel_crt_detect], CRT not detected via hotplug
[   15.790028] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[   15.790033] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   15.790036] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   15.810022] [drm:intel_crt_detect], CRT not detected via hotplug
[   15.810025] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[   15.810062] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   15.810066] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
[   15.810072] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   15.814612] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   15.817962] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   15.817965] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   15.823713] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   15.877315] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   15.930971] [drm:drm_detect_monitor_audio], Monitor has basic audio support
[   15.930974] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   15.936704] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   15.990332] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.043988] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] probed modes :
[   16.043991] [drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1200" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[   16.043995] [drm:drm_mode_debug_printmodeline], Modeline 17:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[   16.043998] [drm:drm_mode_debug_printmodeline], Modeline 18:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[   16.044002] [drm:drm_mode_debug_printmodeline], Modeline 14:"1280x1024" 76 141813 1280 1376 1512 1744 1024 1025 1028 1070 0x0 0x6
[   16.044005] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   16.044008] [drm:drm_mode_debug_printmodeline], Modeline 16:"1280x1024" 72 132840 1280 1368 1504 1728 1024 1025 1028 1067 0x0 0x6
[   16.044012] [drm:drm_mode_debug_printmodeline], Modeline 15:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   16.044015] [drm:drm_mode_debug_printmodeline], Modeline 19:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[   16.044019] [drm:drm_mode_debug_printmodeline], Modeline 20:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[   16.044022] [drm:drm_mode_debug_printmodeline], Modeline 34:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   16.044025] [drm:drm_mode_debug_printmodeline], Modeline 12:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
[   16.044029] [drm:drm_mode_debug_printmodeline], Modeline 28:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   16.044033] [drm:drm_mode_debug_printmodeline], Modeline 29:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   16.044036] [drm:drm_mode_debug_printmodeline], Modeline 30:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   16.044039] [drm:drm_mode_debug_printmodeline], Modeline 31:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   16.044043] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   16.044046] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   16.044049] [drm:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   16.044053] [drm:drm_mode_debug_printmodeline], Modeline 23:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   16.044056] [drm:drm_mode_debug_printmodeline], Modeline 22:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   16.044059] [drm:drm_mode_debug_printmodeline], Modeline 24:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   16.044062] [drm:drm_mode_debug_printmodeline], Modeline 25:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   16.044066] [drm:drm_mode_debug_printmodeline], Modeline 26:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   16.044071] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   16.044105] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   16.044108] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   16.060008] [drm:intel_crt_detect], CRT not detected via hotplug
[   16.060011] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[   16.060016] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   16.060018] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   16.080010] [drm:intel_crt_detect], CRT not detected via hotplug
[   16.080012] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[   16.080043] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   16.080046] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
[   16.080049] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   16.084605] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   16.087947] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   16.087949] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.093691] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.147305] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.201046] [drm:drm_detect_monitor_audio], Monitor has basic audio support
[   16.201053] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.206843] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.260474] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.314211] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] probed modes :
[   16.314213] [drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1200" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[   16.314217] [drm:drm_mode_debug_printmodeline], Modeline 17:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[   16.314220] [drm:drm_mode_debug_printmodeline], Modeline 18:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[   16.314224] [drm:drm_mode_debug_printmodeline], Modeline 14:"1280x1024" 76 141813 1280 1376 1512 1744 1024 1025 1028 1070 0x0 0x6
[   16.314227] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   16.314231] [drm:drm_mode_debug_printmodeline], Modeline 16:"1280x1024" 72 132840 1280 1368 1504 1728 1024 1025 1028 1067 0x0 0x6
[   16.314234] [drm:drm_mode_debug_printmodeline], Modeline 15:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   16.314238] [drm:drm_mode_debug_printmodeline], Modeline 19:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[   16.314241] [drm:drm_mode_debug_printmodeline], Modeline 20:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[   16.314244] [drm:drm_mode_debug_printmodeline], Modeline 34:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   16.314248] [drm:drm_mode_debug_printmodeline], Modeline 12:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
[   16.314251] [drm:drm_mode_debug_printmodeline], Modeline 28:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   16.314255] [drm:drm_mode_debug_printmodeline], Modeline 29:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   16.314258] [drm:drm_mode_debug_printmodeline], Modeline 30:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   16.314261] [drm:drm_mode_debug_printmodeline], Modeline 31:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   16.314265] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   16.314268] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   16.314271] [drm:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   16.314275] [drm:drm_mode_debug_printmodeline], Modeline 23:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   16.314278] [drm:drm_mode_debug_printmodeline], Modeline 22:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   16.314281] [drm:drm_mode_debug_printmodeline], Modeline 24:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   16.314284] [drm:drm_mode_debug_printmodeline], Modeline 25:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   16.314288] [drm:drm_mode_debug_printmodeline], Modeline 26:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   16.314294] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   16.332785] [drm:drm_mode_addfb], [FB:36]
[   16.333294] [drm:drm_mode_setcrtc], [CRTC:3]
[   16.333298] [drm:drm_mode_setcrtc], [CONNECTOR:8:DVI-D-1]
[   16.333300] [drm:drm_crtc_helper_set_config], 
[   16.333301] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:36] #connectors=1 (x y) (0 0)
[   16.333307] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[   16.333314] [drm:intel_pipe_set_base_atomic], Writing base 02000000 00000000 0 0 8192
[   16.333318] [drm:intel_update_fbc], 
[   16.339748] [drm:i915_getparam], Unknown parameter 12
[   16.626170] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   16.626175] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   16.640011] [drm:intel_crt_detect], CRT not detected via hotplug
[   16.640015] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[   16.640020] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   16.640023] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   16.660015] [drm:intel_crt_detect], CRT not detected via hotplug
[   16.660019] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[   16.660039] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   16.660042] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
[   16.660047] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   16.664642] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   16.667985] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   16.667988] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.673730] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.727493] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.781251] [drm:drm_detect_monitor_audio], Monitor has basic audio support
[   16.781304] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.787759] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.841820] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.895690] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] probed modes :
[   16.895694] [drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1200" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[   16.895698] [drm:drm_mode_debug_printmodeline], Modeline 17:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[   16.895701] [drm:drm_mode_debug_printmodeline], Modeline 18:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[   16.895705] [drm:drm_mode_debug_printmodeline], Modeline 14:"1280x1024" 76 141813 1280 1376 1512 1744 1024 1025 1028 1070 0x0 0x6
[   16.895708] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   16.895711] [drm:drm_mode_debug_printmodeline], Modeline 16:"1280x1024" 72 132840 1280 1368 1504 1728 1024 1025 1028 1067 0x0 0x6
[   16.895715] [drm:drm_mode_debug_printmodeline], Modeline 15:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   16.895718] [drm:drm_mode_debug_printmodeline], Modeline 19:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[   16.895722] [drm:drm_mode_debug_printmodeline], Modeline 20:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[   16.895725] [drm:drm_mode_debug_printmodeline], Modeline 34:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   16.895729] [drm:drm_mode_debug_printmodeline], Modeline 12:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
[   16.895732] [drm:drm_mode_debug_printmodeline], Modeline 28:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   16.895735] [drm:drm_mode_debug_printmodeline], Modeline 29:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   16.895739] [drm:drm_mode_debug_printmodeline], Modeline 30:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   16.895742] [drm:drm_mode_debug_printmodeline], Modeline 31:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   16.895745] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   16.895749] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   16.895752] [drm:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   16.895755] [drm:drm_mode_debug_printmodeline], Modeline 23:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   16.895759] [drm:drm_mode_debug_printmodeline], Modeline 22:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   16.895762] [drm:drm_mode_debug_printmodeline], Modeline 24:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   16.895765] [drm:drm_mode_debug_printmodeline], Modeline 25:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   16.895768] [drm:drm_mode_debug_printmodeline], Modeline 26:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   16.895782] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   16.897121] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   16.897124] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   16.910045] [drm:intel_crt_detect], CRT not detected via hotplug
[   16.910049] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[   16.910056] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   16.910058] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   16.930040] [drm:intel_crt_detect], CRT not detected via hotplug
[   16.930045] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[   16.930066] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   16.930070] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
[   16.930075] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   16.934616] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   16.937958] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   16.937961] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.943789] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   16.997412] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.051047] [drm:drm_detect_monitor_audio], Monitor has basic audio support
[   17.051054] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.056778] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.110397] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.164035] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] probed modes :
[   17.164037] [drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1200" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[   17.164041] [drm:drm_mode_debug_printmodeline], Modeline 17:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[   17.164045] [drm:drm_mode_debug_printmodeline], Modeline 18:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[   17.164048] [drm:drm_mode_debug_printmodeline], Modeline 14:"1280x1024" 76 141813 1280 1376 1512 1744 1024 1025 1028 1070 0x0 0x6
[   17.164051] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   17.164055] [drm:drm_mode_debug_printmodeline], Modeline 16:"1280x1024" 72 132840 1280 1368 1504 1728 1024 1025 1028 1067 0x0 0x6
[   17.164058] [drm:drm_mode_debug_printmodeline], Modeline 15:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   17.164062] [drm:drm_mode_debug_printmodeline], Modeline 19:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[   17.164065] [drm:drm_mode_debug_printmodeline], Modeline 20:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[   17.164069] [drm:drm_mode_debug_printmodeline], Modeline 34:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   17.164072] [drm:drm_mode_debug_printmodeline], Modeline 12:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
[   17.164075] [drm:drm_mode_debug_printmodeline], Modeline 28:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   17.164079] [drm:drm_mode_debug_printmodeline], Modeline 29:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   17.164082] [drm:drm_mode_debug_printmodeline], Modeline 30:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   17.164086] [drm:drm_mode_debug_printmodeline], Modeline 31:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   17.164089] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   17.164092] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   17.164096] [drm:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   17.164099] [drm:drm_mode_debug_printmodeline], Modeline 23:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   17.164102] [drm:drm_mode_debug_printmodeline], Modeline 22:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   17.164106] [drm:drm_mode_debug_printmodeline], Modeline 24:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   17.164109] [drm:drm_mode_debug_printmodeline], Modeline 25:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   17.164112] [drm:drm_mode_debug_printmodeline], Modeline 26:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   17.164121] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   17.166057] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   17.166060] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   17.180009] [drm:intel_crt_detect], CRT not detected via hotplug
[   17.180012] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[   17.180017] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   17.180020] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   17.200009] [drm:intel_crt_detect], CRT not detected via hotplug
[   17.200012] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[   17.200023] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   17.200026] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
[   17.200029] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   17.204587] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   17.207929] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   17.207931] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.213668] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.267276] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.320897] [drm:drm_detect_monitor_audio], Monitor has basic audio support
[   17.320906] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.326631] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.380461] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.434286] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] probed modes :
[   17.434288] [drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1200" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[   17.434292] [drm:drm_mode_debug_printmodeline], Modeline 17:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[   17.434295] [drm:drm_mode_debug_printmodeline], Modeline 18:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[   17.434299] [drm:drm_mode_debug_printmodeline], Modeline 14:"1280x1024" 76 141813 1280 1376 1512 1744 1024 1025 1028 1070 0x0 0x6
[   17.434302] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   17.434306] [drm:drm_mode_debug_printmodeline], Modeline 16:"1280x1024" 72 132840 1280 1368 1504 1728 1024 1025 1028 1067 0x0 0x6
[   17.434309] [drm:drm_mode_debug_printmodeline], Modeline 15:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   17.434313] [drm:drm_mode_debug_printmodeline], Modeline 19:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[   17.434316] [drm:drm_mode_debug_printmodeline], Modeline 20:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[   17.434319] [drm:drm_mode_debug_printmodeline], Modeline 34:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   17.434323] [drm:drm_mode_debug_printmodeline], Modeline 12:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
[   17.434326] [drm:drm_mode_debug_printmodeline], Modeline 28:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   17.434330] [drm:drm_mode_debug_printmodeline], Modeline 29:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   17.434333] [drm:drm_mode_debug_printmodeline], Modeline 30:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   17.434337] [drm:drm_mode_debug_printmodeline], Modeline 31:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   17.434340] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   17.434343] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   17.434346] [drm:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   17.434350] [drm:drm_mode_debug_printmodeline], Modeline 23:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   17.434353] [drm:drm_mode_debug_printmodeline], Modeline 22:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   17.434356] [drm:drm_mode_debug_printmodeline], Modeline 24:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   17.434360] [drm:drm_mode_debug_printmodeline], Modeline 25:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   17.434363] [drm:drm_mode_debug_printmodeline], Modeline 26:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   17.434373] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   17.435207] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   17.435211] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   17.450009] [drm:intel_crt_detect], CRT not detected via hotplug
[   17.450012] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[   17.450017] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   17.450019] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   17.470009] [drm:intel_crt_detect], CRT not detected via hotplug
[   17.470013] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[   17.470024] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   17.470027] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
[   17.470030] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   17.474565] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   17.477907] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   17.477910] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.483713] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.537413] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.591034] [drm:drm_detect_monitor_audio], Monitor has basic audio support
[   17.591037] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.596761] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.650375] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   17.704115] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] probed modes :
[   17.704118] [drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1200" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[   17.704121] [drm:drm_mode_debug_printmodeline], Modeline 17:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[   17.704125] [drm:drm_mode_debug_printmodeline], Modeline 18:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[   17.704128] [drm:drm_mode_debug_printmodeline], Modeline 14:"1280x1024" 76 141813 1280 1376 1512 1744 1024 1025 1028 1070 0x0 0x6
[   17.704132] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   17.704135] [drm:drm_mode_debug_printmodeline], Modeline 16:"1280x1024" 72 132840 1280 1368 1504 1728 1024 1025 1028 1067 0x0 0x6
[   17.704139] [drm:drm_mode_debug_printmodeline], Modeline 15:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   17.704142] [drm:drm_mode_debug_printmodeline], Modeline 19:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[   17.704146] [drm:drm_mode_debug_printmodeline], Modeline 20:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[   17.704149] [drm:drm_mode_debug_printmodeline], Modeline 34:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   17.704152] [drm:drm_mode_debug_printmodeline], Modeline 12:"1280x720" 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
[   17.704156] [drm:drm_mode_debug_printmodeline], Modeline 28:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   17.704159] [drm:drm_mode_debug_printmodeline], Modeline 29:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   17.704163] [drm:drm_mode_debug_printmodeline], Modeline 30:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   17.704166] [drm:drm_mode_debug_printmodeline], Modeline 31:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   17.704169] [drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   17.704173] [drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   17.704176] [drm:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   17.704179] [drm:drm_mode_debug_printmodeline], Modeline 23:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   17.704182] [drm:drm_mode_debug_printmodeline], Modeline 22:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   17.704186] [drm:drm_mode_debug_printmodeline], Modeline 24:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   17.704189] [drm:drm_mode_debug_printmodeline], Modeline 25:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   17.704192] [drm:drm_mode_debug_printmodeline], Modeline 26:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   17.704200] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   17.754460] [drm:intel_crtc_cursor_set], 
[   18.091178] EXT4-fs (sda3): re-mounted. Opts: commit=0
[   18.094722] EXT4-fs (sda4): re-mounted. Opts: commit=0
[   18.096070] EXT4-fs (sdb2): re-mounted. Opts: commit=0
[   18.880008] [drm:intel_crt_detect], CRT not detected via hotplug
[   18.880013] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   18.884560] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   18.887909] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   18.887912] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   18.893649] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   18.947386] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   19.001156] [drm:drm_detect_monitor_audio], Monitor has basic audio support
[   29.040010] [drm:intel_crt_detect], CRT not detected via hotplug
[   29.040014] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   29.044565] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   29.047967] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   29.047972] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   29.053719] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   29.107793] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   29.161720] [drm:drm_detect_monitor_audio], Monitor has basic audio support
[   29.380378] CPUFREQ: Per core ondemand sysfs interface is deprecated - ignore_nice_load
[   39.200011] [drm:intel_crt_detect], CRT not detected via hotplug
[   39.200017] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   39.204565] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   39.207915] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   39.207919] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   39.213667] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   39.267323] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   39.320987] [drm:drm_detect_monitor_audio], Monitor has basic audio support
[   49.360007] [drm:intel_crt_detect], CRT not detected via hotplug
[   49.360012] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   49.364561] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[   49.367911] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[   49.367914] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   49.373661] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   49.427316] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[   49.480988] [drm:drm_detect_monitor_audio], Monitor has basic audio support

--------------030302030106000706060004--
