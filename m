Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab2ILMpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:45:04 -0400
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:57579 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757656Ab2ILMpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:45:01 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Sep 2012 08:45:01 EDT
Message-ID: <5050824B.9050006@akamai.com>
Date: Wed, 12 Sep 2012 07:38:35 -0500
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
References: <1347403947-20187-1-git-send-email-johunt@akamai.com> <504FC2E9.4010708@akamai.com> <20120912085140.GA12277@aftab.osrc.amd.com>
In-Reply-To: <20120912085140.GA12277@aftab.osrc.amd.com>
X-Enigmail-Version: 1.5pre
Content-Type: multipart/mixed;
 boundary="------------080104080706020008050206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080104080706020008050206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 09/12/2012 03:51 AM, Borislav Petkov wrote:
> On Tue, Sep 11, 2012 at 06:02:01PM -0500, Josh Hunt wrote:
>> On 09/11/2012 05:52 PM, Josh Hunt wrote:
>>> With recent kernels we noticed that edac was reporting double the memory size on
>>> systems running with AMD family 0Fh processors. I'm not very familiar with the
>>> code, but this resolves it from what I can see on my systems. At least in
>>> amd64_debug_display_dimm_sizes() and k8_dbam_to_chip_select() there appeared
>>> to be redundant shifts to the left by 1 when WIDTH_128 is present.
> 
> Any chance you could enable CONFIG_EDAC_DEBUG, boot and send me your
> whole dmesg? Privately is fine too.
> 
> Thanks.
> 

Sure. Attached. This is booting with latest git.

Josh

--------------080104080706020008050206
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc5+ (johunt@kernelsuite-780) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5.1) ) #33 SMP Wed Sep 12 05:10:20 PDT 2012
[    0.000000] Command line: root=UUID=2ceb4350-c206-4bcd-b8b3-e6dd2ff5b021 ro oops=panic panic=30 INIT_VERBOSE=yes init=/sbin/init processor.max_cstate=1 reboot_type=1 nmi_watchdog=2,120 
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e8000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000edfeffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000edff0000-0x00000000edffdfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000edffe000-0x00000000edffffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec02fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff700000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000111ffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Supermicro H8SSL-I2/H8SSL-I2, BIOS 080011  09/05/2007
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x112000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF00000000 write-back
[    0.000000]   1 base 0100000000 mask FFF0000000 write-back
[    0.000000]   2 base 0110000000 mask FFFE000000 write-back
[    0.000000]   3 base 00EE000000 mask FFFE000000 uncachable
[    0.000000]   4 base 00F0000000 mask FFF0000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000112000000 aka 4384M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xee000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xedff0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xedfeffff]
[    0.000000]  [mem 0x00000000-0xeddfffff] page 2M
[    0.000000]  [mem 0xede00000-0xedfeffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xedfeffff @ [mem 0x1f88b000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x111ffffff]
[    0.000000]  [mem 0x100000000-0x111ffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x111ffffff @ [mem 0xedfea000-0xedfeffff]
[    0.000000] RAMDISK: [mem 0x37511000-0x37feffff]
[    0.000000] ACPI: RSDP 00000000000f9e40 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000edff0000 00030 (v01 A M I  OEMRSDT  09000705 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000edff0200 00084 (v02 A M I  OEMFACP  09000705 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000edff0410 030C5 (v01  1SSL2 1SSL2005 00000005 INTL 02002026)
[    0.000000] ACPI: FACS 00000000edffe000 00040
[    0.000000] ACPI: APIC 00000000edff0390 00076 (v01 A M I  OEMAPIC  09000705 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000edffe040 00056 (v01 A M I  AMI_OEM  09000705 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000111ffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x111ffffff]
[    0.000000]   NODE_DATA [mem 0x111ffc000-0x111ffffff]
[    0.000000]  [ffffea0000000000-ffffea0003dfffff] PMD -> [ffff88010d400000-ffff880110ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x111ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xedfeffff]
[    0.000000]   node   0: [mem 0x100000000-0x111ffffff]
[    0.000000] On node 0 totalpages: 1048447
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 8 pages reserved
[    0.000000]   DMA zone: 3919 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 956456 pages, LIFO batch:31
[    0.000000]   Normal zone: 1008 pages used for memmap
[    0.000000]   Normal zone: 72720 pages, LIFO batch:15
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x508
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-15
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec01000] gsi_base[16])
[    0.000000] IOAPIC[1]: apic_id 3, version 17, address 0xfec01000, GSI 16-31
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec02000] gsi_base[32])
[    0.000000] IOAPIC[2]: apic_id 4, version 17, address 0xfec02000, GSI 32-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] e820: [mem 0xee000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880111c00000 s78720 r8192 d23680 u1048576
[    0.000000] pcpu-alloc: s78720 r8192 d23680 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1033095
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=UUID=2ceb4350-c206-4bcd-b8b3-e6dd2ff5b021 ro oops=panic panic=30 INIT_VERBOSE=yes init=/sbin/init processor.max_cstate=1 reboot_type=1 nmi_watchdog=2,120 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ e4000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ e4000000
[    0.000000] Memory: 3979312k/4489216k available (5189k kernel code, 295428k absent, 214476k reserved, 3016k data, 896k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2394.076 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.001138] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.15 BogoMIPS (lpj=2394076)
[    0.001409] pid_max: default: 32768 minimum: 301
[    0.001573] Security Framework initialized
[    0.001717] AppArmor: AppArmor disabled by boot time parameter
[    0.002291] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004936] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.006273] Mount-cache hash table entries: 256
[    0.006621] Initializing cgroup subsys cpuacct
[    0.006755] Initializing cgroup subsys devices
[    0.006891] Initializing cgroup subsys freezer
[    0.007002] Initializing cgroup subsys net_cls
[    0.007134] Initializing cgroup subsys blkio
[    0.007267] Initializing cgroup subsys perf_event
[    0.007425] tseg: 0000000000
[    0.007439] CPU: Physical Processor ID: 0
[    0.007572] CPU: Processor Core ID: 0
[    0.007703] mce: CPU supports 5 MCE banks
[    0.007840] LVT offset 0 assigned for vector 0xf9
[    0.008005] process: using AMD E400 aware idle routine
[    0.008972] Freeing SMP alternatives: 24k freed
[    0.009017] ACPI: Core revision 20120711
[    0.012420] ftrace: allocating 19835 entries in 78 pages
[    0.020810] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.030958] smpboot: CPU0: Dual-Core AMD Opteron(tm) Processor 1216 HE stepping 03
[    0.031995] Performance Events: AMD PMU driver.
[    0.031995] ... version:                0
[    0.031995] ... bit width:              48
[    0.031995] ... generic registers:      4
[    0.031995] ... value mask:             0000ffffffffffff
[    0.031995] ... max period:             00007fffffffffff
[    0.031995] ... fixed-purpose events:   0
[    0.031995] ... event mask:             000000000000000f
[    0.032447] MCE: In-kernel MCE decoding enabled.
[    0.032594] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.033078] smpboot: Booting Node   0, Processors  #1 OK
[    0.104088] Brought up 2 CPUs
[    0.104218] smpboot: Total of 2 processors activated (9575.18 BogoMIPS)
[    0.106174] NET: Registered protocol family 16
[    0.106742] node 0 link 0: io port [1000, ffffff]
[    0.106745] TOM: 00000000ee000000 aka 3808M
[    0.106880] node 0 link 0: mmio [a0000, bffff]
[    0.106883] node 0 link 0: mmio [ee000000, ffe0ffff]
[    0.106886] TOM2: 0000000112000000 aka 4384M
[    0.106988] bus: [bus 00-ff] on node 0 link 0
[    0.106990] bus: 00 [io  0x0000-0xffff]
[    0.106991] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.106992] bus: 00 [mem 0xee000000-0xffffffff]
[    0.106994] bus: 00 [mem 0x112000000-0xfcffffffff]
[    0.107043] ACPI: bus type pci registered
[    0.107347] dca service started, version 1.12.1
[    0.107514] PCI: Using configuration type 1 for base access
[    0.113895] bio: create slab <bio-0> at 0
[    0.114216] ACPI: Added _OSI(Module Device)
[    0.114353] ACPI: Added _OSI(Processor Device)
[    0.114485] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.114619] ACPI: Added _OSI(Processor Aggregator Device)
[    0.115742] ACPI: EC: Look up EC in DSDT
[    0.117055] ACPI: Executed 1 blocks of module-level executable AML code
[    0.118730] ACPI: Interpreter enabled
[    0.118864] ACPI: (supports S0 S5)
[    0.118988] ACPI: Using IOAPIC for interrupt routing
[    0.127498] ACPI: No dock devices found.
[    0.127637] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.127943] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.128153] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.128156] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.128159] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.128161] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.128164] pci_root PNP0A03:00: host bridge window [mem 0xee000000-0xffffffff] (ignored)
[    0.128166] PCI: root bus 00: hardware-probed resources
[    0.128172] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.128445] PCI host bridge to bus 0000:00
[    0.128579] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    0.128581] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.128717] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.128854] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.128983] pci_bus 0000:00: root bus resource [mem 0xee000000-0xffffffff]
[    0.129120] pci_bus 0000:00: root bus resource [mem 0x112000000-0xfcffffffff]
[    0.129270] pci 0000:00:01.0: [1166:0036] type 01 class 0x060400
[    0.129293] pci 0000:00:01.0: Enabling HT MSI Mapping
[    0.129460] pci 0000:00:02.0: [1166:0205] type 00 class 0x060000
[    0.129499] pci 0000:00:02.1: [1166:0214] type 00 class 0x01018a
[    0.129510] pci 0000:00:02.1: reg 10: [io  0x01f0-0x01f7]
[    0.129518] pci 0000:00:02.1: reg 14: [io  0x03f4-0x03f7]
[    0.129527] pci 0000:00:02.1: reg 18: [io  0x0170-0x0177]
[    0.129535] pci 0000:00:02.1: reg 1c: [io  0x0374-0x0377]
[    0.129543] pci 0000:00:02.1: reg 20: [io  0xffa0-0xffaf]
[    0.129573] pci 0000:00:02.2: [1166:0234] type 00 class 0x060100
[    0.129639] pci 0000:00:03.0: [1166:0223] type 00 class 0x0c0310
[    0.129654] pci 0000:00:03.0: reg 10: [mem 0xff6ee000-0xff6eefff]
[    0.129663] pci 0000:00:03.0: reg 14: [io  0xe800-0xe8ff]
[    0.129731] pci 0000:00:03.1: [1166:0223] type 00 class 0x0c0310
[    0.129746] pci 0000:00:03.1: reg 10: [mem 0xff6ed000-0xff6edfff]
[    0.129754] pci 0000:00:03.1: reg 14: [io  0xd800-0xd8ff]
[    0.129821] pci 0000:00:03.2: [1166:0223] type 00 class 0x0c0320
[    0.129836] pci 0000:00:03.2: reg 10: [mem 0xff6ec000-0xff6ecfff]
[    0.129844] pci 0000:00:03.2: reg 14: [io  0xd400-0xd4ff]
[    0.130018] pci 0000:00:03.2: supports D1 D2
[    0.130020] pci 0000:00:03.2: PME# supported from D0 D1 D2 D3hot
[    0.130044] pci 0000:00:05.0: [1002:515e] type 00 class 0x030000
[    0.130058] pci 0000:00:05.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
[    0.130067] pci 0000:00:05.0: reg 14: [io  0xe000-0xe0ff]
[    0.130076] pci 0000:00:05.0: reg 18: [mem 0xff6f0000-0xff6fffff]
[    0.130104] pci 0000:00:05.0: reg 30: [mem 0xff6c0000-0xff6dffff pref]
[    0.130127] pci 0000:00:05.0: supports D1 D2
[    0.130153] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.130169] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.130181] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.130196] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.130229] pci_bus 0000:01: busn_res: [bus 01-02] is inserted under [bus 00-ff]
[    0.130244] pci 0000:01:0d.0: [1166:0104] type 01 class 0x060400
[    0.130278] pci 0000:01:0e.0: [1166:024b] type 00 class 0x01018f
[    0.130287] pci 0000:01:0e.0: reg 10: [io  0xbc00-0xbc07]
[    0.130292] pci 0000:01:0e.0: reg 14: [io  0xb880-0xb883]
[    0.130298] pci 0000:01:0e.0: reg 18: [io  0xb800-0xb807]
[    0.130303] pci 0000:01:0e.0: reg 1c: [io  0xb480-0xb483]
[    0.130308] pci 0000:01:0e.0: reg 20: [io  0xb400-0xb40f]
[    0.130314] pci 0000:01:0e.0: reg 24: [mem 0xff5fe000-0xff5fffff]
[    0.130320] pci 0000:01:0e.0: reg 30: [mem 0xff5c0000-0xff5dffff pref]
[    0.130351] pci 0000:01:0e.1: [1166:024b] type 00 class 0x01018f
[    0.130359] pci 0000:01:0e.1: reg 10: [io  0xb080-0xb087]
[    0.130365] pci 0000:01:0e.1: reg 14: [io  0xb000-0xb003]
[    0.130370] pci 0000:01:0e.1: reg 18: [io  0xac00-0xac07]
[    0.130375] pci 0000:01:0e.1: reg 1c: [io  0xa880-0xa883]
[    0.130381] pci 0000:01:0e.1: reg 20: [io  0xa800-0xa80f]
[    0.130423] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.130560] pci 0000:00:01.0:   bridge window [io  0x7000-0xbfff]
[    0.130563] pci 0000:00:01.0:   bridge window [mem 0xff000000-0xff5fffff]
[    0.130567] pci 0000:00:01.0:   bridge window [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.130578] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 01-02]
[    0.130595] pci 0000:02:01.0: [1000:0054] type 00 class 0x010000
[    0.130612] pci 0000:02:01.0: reg 10: [io  0x9000-0x90ff]
[    0.130623] pci 0000:02:01.0: reg 14: [mem 0xff4fc000-0xff4fffff 64bit]
[    0.130635] pci 0000:02:01.0: reg 1c: [mem 0xff4e0000-0xff4effff 64bit]
[    0.130650] pci 0000:02:01.0: reg 30: [mem 0xff200000-0xff3fffff pref]
[    0.130686] pci 0000:02:01.0: supports D1 D2
[    0.130711] pci 0000:02:03.0: [14e4:1648] type 00 class 0x020000
[    0.130729] pci 0000:02:03.0: reg 10: [mem 0xff4d0000-0xff4dffff 64bit]
[    0.130801] pci 0000:02:03.0: PME# supported from D3hot D3cold
[    0.130826] pci 0000:02:03.1: [14e4:1648] type 00 class 0x020000
[    0.130843] pci 0000:02:03.1: reg 10: [mem 0xff4c0000-0xff4cffff 64bit]
[    0.130915] pci 0000:02:03.1: PME# supported from D3hot D3cold
[    0.130955] pci 0000:01:0d.0: PCI bridge to [bus 02]
[    0.131016] pci 0000:01:0d.0:   bridge window [io  0x7000-0x9fff]
[    0.131019] pci 0000:01:0d.0:   bridge window [mem 0xff000000-0xff4fffff]
[    0.131023] pci 0000:01:0d.0:   bridge window [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.131033] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.131139] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.131170] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1.P1P2._PRT]
[    0.131228]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.131440]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.133631] ACPI: PCI Interrupt Link [LN00] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.134585] ACPI: PCI Interrupt Link [LN01] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.135622] ACPI: PCI Interrupt Link [LN02] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.136674] ACPI: PCI Interrupt Link [LN03] (IRQs 1 3 4 5 6 7 9 *10 11 12 14 15)
[    0.137627] ACPI: PCI Interrupt Link [LN04] (IRQs 1 3 4 5 6 7 *9 10 11 12 14 15)
[    0.138570] ACPI: PCI Interrupt Link [LN05] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.139621] ACPI: PCI Interrupt Link [LN06] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.140671] ACPI: PCI Interrupt Link [LN07] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.141770] ACPI: PCI Interrupt Link [LN08] (IRQs 1 3 4 *5 6 7 9 10 11 12 14 15)
[    0.142718] ACPI: PCI Interrupt Link [LN09] (IRQs 1 3 4 5 6 *7 9 10 11 12 14 15)
[    0.143668] ACPI: PCI Interrupt Link [LN10] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.144718] ACPI: PCI Interrupt Link [LN11] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.146299] ACPI: PCI Interrupt Link [LN12] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.147433] ACPI: PCI Interrupt Link [LN13] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.148520] ACPI: PCI Interrupt Link [LN14] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.149571] ACPI: PCI Interrupt Link [LN15] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.150620] ACPI: PCI Interrupt Link [LN16] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.151670] ACPI: PCI Interrupt Link [LN17] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.152716] ACPI: PCI Interrupt Link [LN18] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.153767] ACPI: PCI Interrupt Link [LN19] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.154816] ACPI: PCI Interrupt Link [LN20] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.155868] ACPI: PCI Interrupt Link [LN21] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.156913] ACPI: PCI Interrupt Link [LN22] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.157989] ACPI: PCI Interrupt Link [LN23] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.159028] ACPI: PCI Interrupt Link [LN24] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.160028] ACPI: PCI Interrupt Link [LN25] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.161028] ACPI: PCI Interrupt Link [LN26] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.162149] ACPI: PCI Interrupt Link [LN27] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.163199] ACPI: PCI Interrupt Link [LN28] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.164247] ACPI: PCI Interrupt Link [LN29] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.165298] ACPI: PCI Interrupt Link [LN30] (IRQs 1 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.166316] ACPI: PCI Interrupt Link [LNUS] (IRQs *10)
[    0.166660] ACPI: PCI Interrupt Link [LNSA] (IRQs *11)
[    0.167156] vgaarb: device added: PCI:0000:00:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.167372] vgaarb: loaded
[    0.167503] vgaarb: bridge control possible 0000:00:05.0
[    0.167818] SCSI subsystem initialized
[    0.167982] ACPI: bus type usb registered
[    0.168192] usbcore: registered new interface driver usbfs
[    0.168367] usbcore: registered new interface driver hub
[    0.168579] usbcore: registered new device driver usb
[    0.168869] PCI: Using ACPI for IRQ routing
[    0.168981] PCI: pci_cache_line_size set to 64 bytes
[    0.169047] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.169050] e820: reserve RAM buffer [mem 0xedff0000-0xefffffff]
[    0.169052] e820: reserve RAM buffer [mem 0x112000000-0x113ffffff]
[    0.177566] pnp: PnP ACPI init
[    0.177709] ACPI: bus type pnp registered
[    0.178031] pnp 00:00: [bus 00-ff]
[    0.178034] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.178038] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.178040] pnp 00:00: [io  0x0d00-0xffff window]
[    0.178043] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.178045] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.178047] pnp 00:00: [mem 0xee000000-0xffffffff window]
[    0.178146] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.178176] pnp 00:01: [dma 4]
[    0.178179] pnp 00:01: [io  0x0000-0x000f]
[    0.178181] pnp 00:01: [io  0x0081-0x0083]
[    0.178183] pnp 00:01: [io  0x0087]
[    0.178185] pnp 00:01: [io  0x0089-0x008b]
[    0.178188] pnp 00:01: [io  0x008f]
[    0.178190] pnp 00:01: [io  0x00c0-0x00df]
[    0.178244] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.178256] pnp 00:02: [io  0x0070-0x0071]
[    0.178268] pnp 00:02: [irq 8]
[    0.178322] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.178355] pnp 00:03: [io  0x0060]
[    0.178357] pnp 00:03: [io  0x0064]
[    0.178362] pnp 00:03: [irq 1]
[    0.178420] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.178473] pnp 00:04: [irq 12]
[    0.178529] pnp 00:04: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.178537] pnp 00:05: [io  0x0061]
[    0.178591] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.178601] pnp 00:06: [io  0x00f0-0x00ff]
[    0.178606] pnp 00:06: [irq 13]
[    0.178661] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.179009] pnp 00:07: [io  0x03f0-0x03f5]
[    0.179011] pnp 00:07: [io  0x03f7]
[    0.179016] pnp 00:07: [irq 6]
[    0.179018] pnp 00:07: [dma 2]
[    0.179106] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.179373] pnp 00:08: [io  0x03f8-0x03ff]
[    0.179378] pnp 00:08: [irq 4]
[    0.179381] pnp 00:08: [dma 0 disabled]
[    0.179473] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.179740] pnp 00:09: [io  0x02f8-0x02ff]
[    0.179745] pnp 00:09: [irq 3]
[    0.179747] pnp 00:09: [dma 0 disabled]
[    0.179867] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.180336] pnp 00:0a: [io  0x0000-0xffffffffffffffff disabled]
[    0.180338] pnp 00:0a: [io  0x0600-0x061f]
[    0.180341] pnp 00:0a: [io  0x0520-0x053f]
[    0.180343] pnp 00:0a: [io  0x0540-0x054f]
[    0.180345] pnp 00:0a: [io  0x0544-0x0553]
[    0.180348] pnp 00:0a: [io  0x0550-0x055f]
[    0.180350] pnp 00:0a: [io  0x0640-0x065f]
[    0.180353] pnp 00:0a: [io  0x0800-0x080f]
[    0.180355] pnp 00:0a: [io  0x0aa0-0x0abf]
[    0.180357] pnp 00:0a: [io  0x0ac0-0x0adf]
[    0.180359] pnp 00:0a: [io  0x0ae0-0x0aff]
[    0.180450] system 00:0a: [io  0x0600-0x061f] has been reserved
[    0.180589] system 00:0a: [io  0x0520-0x053f] has been reserved
[    0.180726] system 00:0a: [io  0x0540-0x054f] has been reserved
[    0.180863] system 00:0a: [io  0x0544-0x0553] could not be reserved
[    0.180998] system 00:0a: [io  0x0550-0x055f] has been reserved
[    0.181134] system 00:0a: [io  0x0640-0x065f] has been reserved
[    0.181269] system 00:0a: [io  0x0800-0x080f] has been reserved
[    0.181405] system 00:0a: [io  0x0aa0-0x0abf] has been reserved
[    0.181543] system 00:0a: [io  0x0ac0-0x0adf] has been reserved
[    0.181678] system 00:0a: [io  0x0ae0-0x0aff] has been reserved
[    0.181819] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.181893] pnp 00:0b: [io  0x0010-0x001f]
[    0.181895] pnp 00:0b: [io  0x0022-0x003f]
[    0.181898] pnp 00:0b: [io  0x0044-0x005f]
[    0.181900] pnp 00:0b: [io  0x0062-0x0063]
[    0.181902] pnp 00:0b: [io  0x0065-0x006f]
[    0.181904] pnp 00:0b: [io  0x0072-0x007f]
[    0.181906] pnp 00:0b: [io  0x0080]
[    0.181908] pnp 00:0b: [io  0x0084-0x0086]
[    0.181910] pnp 00:0b: [io  0x0088]
[    0.181912] pnp 00:0b: [io  0x008c-0x008e]
[    0.181915] pnp 00:0b: [io  0x0090-0x009f]
[    0.181917] pnp 00:0b: [io  0x00a2-0x00bf]
[    0.181919] pnp 00:0b: [io  0x00e0-0x00ef]
[    0.181921] pnp 00:0b: [io  0x0092]
[    0.181923] pnp 00:0b: [io  0x040b]
[    0.181925] pnp 00:0b: [io  0x04d6]
[    0.181927] pnp 00:0b: [io  0x0c06-0x0c07]
[    0.181929] pnp 00:0b: [io  0x0c49]
[    0.181932] pnp 00:0b: [io  0x0c4a]
[    0.181934] pnp 00:0b: [io  0x0c6f]
[    0.181936] pnp 00:0b: [io  0x0c98]
[    0.181938] pnp 00:0b: [io  0x0f50-0x0f57]
[    0.181940] pnp 00:0b: [io  0x0c00-0x0c01]
[    0.181974] pnp 00:0b: [io  0x0c14]
[    0.181978] pnp 00:0b: [io  0x0c50-0x0c51]
[    0.181980] pnp 00:0b: [io  0x0c52]
[    0.181982] pnp 00:0b: [io  0x0c6c]
[    0.181984] pnp 00:0b: [io  0x0c6f]
[    0.181986] pnp 00:0b: [io  0x0cd6-0x0cd7]
[    0.181988] pnp 00:0b: [io  0x0cd4-0x0cd5]
[    0.181990] pnp 00:0b: [io  0x0cd8-0x0cdf]
[    0.181992] pnp 00:0b: [io  0x002e-0x002f]
[    0.181994] pnp 00:0b: [io  0x0530-0x0531]
[    0.181997] pnp 00:0b: [io  0x0440-0x045f]
[    0.181999] pnp 00:0b: [io  0x0480-0x049f]
[    0.182001] pnp 00:0b: [io  0x04c0-0x04df]
[    0.182003] pnp 00:0b: [io  0x0500-0x051f]
[    0.182005] pnp 00:0b: [io  0x0540-0x055f]
[    0.182007] pnp 00:0b: [io  0x0560-0x057f]
[    0.182009] pnp 00:0b: [io  0x0580-0x058f]
[    0.182011] pnp 00:0b: [io  0x0590-0x05ff]
[    0.182013] pnp 00:0b: [io  0x0660-0x06df]
[    0.182016] pnp 00:0b: [io  0x06e0-0x075f]
[    0.182018] pnp 00:0b: [io  0x0760-0x07ff]
[    0.182020] pnp 00:0b: [io  0x0ca8-0x0cab]
[    0.182022] pnp 00:0b: [io  0x0cac-0x0caf]
[    0.182024] pnp 00:0b: [io  0x04d0-0x04d1]
[    0.182026] pnp 00:0b: [io  0x0500-0x057f]
[    0.182029] pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
[    0.182031] pnp 00:0b: [mem 0xfebfe000-0xfebfefff]
[    0.182033] pnp 00:0b: [mem 0xff600000-0xffffffff]
[    0.182195] system 00:0b: [io  0x040b] has been reserved
[    0.182328] system 00:0b: [io  0x04d6] has been reserved
[    0.182462] system 00:0b: [io  0x0c06-0x0c07] has been reserved
[    0.182601] system 00:0b: [io  0x0c49] has been reserved
[    0.182735] system 00:0b: [io  0x0c4a] has been reserved
[    0.182871] system 00:0b: [io  0x0c6f] has been reserved
[    0.182982] system 00:0b: [io  0x0c98] has been reserved
[    0.183117] system 00:0b: [io  0x0f50-0x0f57] has been reserved
[    0.183252] system 00:0b: [io  0x0c00-0x0c01] has been reserved
[    0.183388] system 00:0b: [io  0x0c14] has been reserved
[    0.183524] system 00:0b: [io  0x0c50-0x0c51] has been reserved
[    0.183660] system 00:0b: [io  0x0c52] has been reserved
[    0.183799] system 00:0b: [io  0x0c6c] has been reserved
[    0.183934] system 00:0b: [io  0x0c6f] has been reserved
[    0.183974] system 00:0b: [io  0x0cd6-0x0cd7] has been reserved
[    0.184110] system 00:0b: [io  0x0cd4-0x0cd5] has been reserved
[    0.184246] system 00:0b: [io  0x0cd8-0x0cdf] has been reserved
[    0.184383] system 00:0b: [io  0x0530-0x0531] has been reserved
[    0.184519] system 00:0b: [io  0x0440-0x045f] has been reserved
[    0.184655] system 00:0b: [io  0x0480-0x049f] has been reserved
[    0.184792] system 00:0b: [io  0x04c0-0x04df] could not be reserved
[    0.184974] system 00:0b: [io  0x0500-0x051f] has been reserved
[    0.185110] system 00:0b: [io  0x0540-0x055f] could not be reserved
[    0.185247] system 00:0b: [io  0x0560-0x057f] has been reserved
[    0.185383] system 00:0b: [io  0x0580-0x058f] has been reserved
[    0.185522] system 00:0b: [io  0x0590-0x05ff] has been reserved
[    0.185658] system 00:0b: [io  0x0660-0x06df] has been reserved
[    0.185796] system 00:0b: [io  0x06e0-0x075f] has been reserved
[    0.185974] system 00:0b: [io  0x0760-0x07ff] has been reserved
[    0.186109] system 00:0b: [io  0x0ca8-0x0cab] has been reserved
[    0.186245] system 00:0b: [io  0x0cac-0x0caf] has been reserved
[    0.186380] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    0.186516] system 00:0b: [io  0x0500-0x057f] could not be reserved
[    0.186653] system 00:0b: [mem 0xfebfe000-0xfebfefff] has been reserved
[    0.186792] system 00:0b: [mem 0xff600000-0xffffffff] could not be reserved
[    0.186975] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.187037] pnp 00:0c: [mem 0xfec00000-0xfec00fff]
[    0.187040] pnp 00:0c: [mem 0xfee00000-0xfee00fff]
[    0.187120] system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.187247] system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.187384] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.187488] pnp 00:0d: [mem 0x00000000-0x0009ffff]
[    0.187492] pnp 00:0d: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.187494] pnp 00:0d: [mem 0x000e0000-0x000fffff]
[    0.187496] pnp 00:0d: [mem 0x00100000-0xedffffff]
[    0.187499] pnp 00:0d: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.187581] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.187709] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.187849] system 00:0d: [mem 0x00100000-0xedffffff] could not be reserved
[    0.187985] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.188633] pnp: PnP ACPI: found 14 devices
[    0.188765] ACPI: ACPI bus type pnp unregistered
[    0.196903] Switching to clocksource acpi_pm
[    0.196973] pci 0000:01:0d.0: PCI bridge to [bus 02]
[    0.196973] pci 0000:01:0d.0:   bridge window [io  0x7000-0x9fff]
[    0.196973] pci 0000:01:0d.0:   bridge window [mem 0xff000000-0xff4fffff]
[    0.196973] pci 0000:01:0d.0:   bridge window [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.196973] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.196973] pci 0000:00:01.0:   bridge window [io  0x7000-0xbfff]
[    0.197965] pci 0000:00:01.0:   bridge window [mem 0xff000000-0xff5fffff]
[    0.198147] pci 0000:00:01.0:   bridge window [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.198369] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.198372] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
[    0.198374] pci_bus 0000:00: resource 6 [mem 0xee000000-0xffffffff]
[    0.198377] pci_bus 0000:00: resource 7 [mem 0x112000000-0xfcffffffff]
[    0.198379] pci_bus 0000:01: resource 0 [io  0x7000-0xbfff]
[    0.198382] pci_bus 0000:01: resource 1 [mem 0xff000000-0xff5fffff]
[    0.198384] pci_bus 0000:01: resource 2 [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.198387] pci_bus 0000:02: resource 0 [io  0x7000-0x9fff]
[    0.198389] pci_bus 0000:02: resource 1 [mem 0xff000000-0xff4fffff]
[    0.198392] pci_bus 0000:02: resource 2 [mem 0xeea00000-0xeeafffff 64bit pref]
[    0.198439] NET: Registered protocol family 2
[    0.199470] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.203620] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.204383] TCP: Hash tables configured (established 524288 bind 65536)
[    0.204580] TCP: reno registered
[    0.204721] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.204893] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.205148] NET: Registered protocol family 1
[    0.205377] RPC: Registered named UNIX socket transport module.
[    0.205516] RPC: Registered udp transport module.
[    0.205648] RPC: Registered tcp transport module.
[    0.205782] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.205974] pci 0000:00:02.0: disabled boot interrupts on device [1166:0205]
[    0.340042] pci 0000:00:05.0: Boot video device
[    0.340067] PCI: CLS 64 bytes, default 64
[    0.340112] Trying to unpack rootfs image as initramfs...
[    0.592333] Freeing initrd memory: 11132k freed
[    0.599420] PCI-DMA: Disabling AGP.
[    0.599652] PCI-DMA: aperture base @ e4000000 size 65536 KB
[    0.599786] PCI-DMA: using GART IOMMU.
[    0.599919] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.604862] audit: initializing netlink socket (disabled)
[    0.605026] type=2000 audit(1347453023.604:1): initialized
[    0.623292] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.624182] VFS: Disk quotas dquot_6.5.2
[    0.624336] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.624672] NFS: Registering the id_resolver key type
[    0.624820] Key type id_resolver registered
[    0.624951] Key type id_legacy registered
[    0.625097] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.625528] msgmni has been set to 7922
[    0.625900] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.626150] io scheduler noop registered
[    0.626282] io scheduler deadline registered
[    0.626423] io scheduler cfq registered (default)
[    0.626796] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.627028] ACPI: Power Button [PWRB]
[    0.627234] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.627448] ACPI: Sleep Button [SLPB]
[    0.627642] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.627854] ACPI: Power Button [PWRF]
[    0.628077] input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input3
[    0.628288] ACPI: Sleep Button [SLPF]
[    0.628535] ACPI: processor limited to max C-state 1
[    0.628878] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    0.652058] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.672881] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.693669] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.714757] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.735599] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.736079] Real Time Clock Driver v1.12b
[    0.736376] Linux agpgart interface v0.103
[    0.738599] brd: module loaded
[    0.739872] loop: module loaded
[    0.740022] Uniform Multi-Platform E-IDE driver
[    0.740257] serverworks 0000:00:02.1: IDE controller (0x1166:0x0214 rev 0x00)
[    0.740419] serverworks 0000:00:02.1: not 100% native mode: will probe irqs later
[    0.740633]     ide0: BM-DMA at 0xffa0-0xffa7
[    0.740774] Probing IDE interface ide0...
[    1.715014] hdb: CD-224E-R, ATAPI CD/DVD-ROM drive
[    1.716916] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    1.717582] hdb: UDMA/33 mode selected
[    1.728769] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    1.729318] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    1.729533] ide-gd driver 1.18
[    1.729703] ide-cd driver 5.00
[    1.740619] ide-cd: hdb: ATAPI 24X CD-ROM drive, 90kB Cache
[    1.740951] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.787244] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.787380] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.787706] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.787906] ehci_hcd 0000:00:03.2: EHCI Host Controller
[    1.788126] ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1
[    1.809030] ehci_hcd 0000:00:03.2: irq 10, io mem 0xff6ec000
[    1.815014] ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00
[    1.815302] hub 1-0:1.0: USB hub found
[    1.815436] hub 1-0:1.0: 4 ports detected
[    1.815657] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.815834] ohci_hcd 0000:00:03.0: OHCI Host Controller
[    1.816037] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
[    1.816261] ohci_hcd 0000:00:03.0: irq 10, io mem 0xff6ee000
[    1.871152] hub 2-0:1.0: USB hub found
[    1.871288] hub 2-0:1.0: 2 ports detected
[    1.871480] ohci_hcd 0000:00:03.1: OHCI Host Controller
[    1.871671] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
[    1.871895] ohci_hcd 0000:00:03.1: irq 10, io mem 0xff6ed000
[    1.927148] hub 3-0:1.0: USB hub found
[    1.927284] hub 3-0:1.0: 2 ports detected
[    1.927482] uhci_hcd: USB Universal Host Controller Interface driver
[    1.927717] usbcore: registered new interface driver usblp
[    1.927957] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.930660] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.930797] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.931066] mousedev: PS/2 mouse device common for all mice
[    1.931490] cpuidle: using governor ladder
[    1.932826] usbcore: registered new interface driver usbhid
[    1.932962] usbhid: USB HID core driver
[    1.933207] TCP: cubic registered
[    1.933337] NET: Registered protocol family 17
[    1.933498] Key type dns_resolver registered
[    1.934067] registered taskstats version 1
[    1.934684] console [netcon0] enabled
[    1.934817] netconsole: network logging started
[    1.934952] powernow-k8: Found 1 Dual-Core AMD Opteron(tm) Processor 1216 HE (2 cpu cores) (version 2.20.00)
[    1.935194] [Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
[    1.935194] [Firmware Bug]: powernow-k8: Try again with latest BIOS.
[    1.937015] Freeing unused kernel memory: 896k freed
[    1.963297] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.973874] ACPI: bus type scsi registered
[    1.974246] libata version 3.00 loaded.
[    1.975072] sata_svw 0000:01:0e.0: version 2.3
[    1.975795] scsi0 : sata_svw
[    1.976068] scsi1 : sata_svw
[    1.976319] scsi2 : sata_svw
[    1.976558] scsi3 : sata_svw
[    1.976777] ata1: SATA max UDMA/133 mmio m8192@0xff5fe000 port 0xff5fe000 irq 11
[    1.976989] ata2: SATA max UDMA/133 mmio m8192@0xff5fe000 port 0xff5fe100 irq 11
[    1.977220] ata3: SATA max UDMA/133 mmio m8192@0xff5fe000 port 0xff5fe200 irq 11
[    1.977431] ata4: SATA max UDMA/133 mmio m8192@0xff5fe000 port 0xff5fe300 irq 11
[    2.292358] ata1: SATA link down (SStatus 4 SControl 300)
[    2.607356] ata2: SATA link down (SStatus 4 SControl 300)
[    2.922357] ata3: SATA link down (SStatus 4 SControl 300)
[    3.111224] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input5
[    3.237355] ata4: SATA link down (SStatus 4 SControl 300)
[    3.241336] Fusion MPT base driver 3.04.20
[    3.241472] Copyright (c) 1999-2008 LSI Corporation
[    3.247145] Fusion MPT SAS Host driver 3.04.20
[    3.247424] mptbase: ioc0: Initiating bringup
[    3.525010] ioc0: LSISAS1068 B0: Capabilities={Initiator}
[   25.212055] scsi4 : ioc0: LSISAS1068 B0, FwRev=011e0000h, Ports=1, MaxQ=277, IRQ=20
[   25.253360] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 0, phy 0, sas_addr 0x5000c500070dc515
[   25.254645] scsi 4:0:0:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.257130] sd 4:0:0:0: Attached scsi generic sg0 type 0
[   25.260189] sd 4:0:0:0: [sda] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.260811] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 1, phy 1, sas_addr 0x5000c500070dac45
[   25.262091] scsi 4:0:1:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.262601] sd 4:0:0:0: [sda] Write Protect is off
[   25.262737] sd 4:0:0:0: [sda] Mode Sense: b3 00 10 08
[   25.264536] sd 4:0:1:0: Attached scsi generic sg1 type 0
[   25.267093] sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.267825] sd 4:0:1:0: [sdb] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.268454] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 2, phy 2, sas_addr 0x5000c500070dc391
[   25.271628] scsi 4:0:2:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.272240] sd 4:0:1:0: [sdb] Write Protect is off
[   25.272375] sd 4:0:1:0: [sdb] Mode Sense: b3 00 10 08
[   25.274064] sd 4:0:2:0: Attached scsi generic sg2 type 0
[   25.276614] sd 4:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.277340] sd 4:0:2:0: [sdc] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.277967] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 3, phy 3, sas_addr 0x5000c500070daf29
[   25.278221]  sda: sda1 sda2 sda3
[   25.283264] scsi 4:0:3:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.283278] sd 4:0:2:0: [sdc] Write Protect is off
[   25.283280] sd 4:0:2:0: [sdc] Mode Sense: b3 00 10 08
[   25.284978] sd 4:0:2:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.285842] sd 4:0:3:0: Attached scsi generic sg3 type 0
[   25.290384] sd 4:0:0:0: [sda] Attached SCSI disk
[   25.290857] sd 4:0:3:0: [sdd] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.291486] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 4, phy 4, sas_addr 0x5000c500070dc0c1
[   25.292750] scsi 4:0:4:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.293278] sd 4:0:3:0: [sdd] Write Protect is off
[   25.293425] sd 4:0:3:0: [sdd] Mode Sense: b3 00 10 08
[   25.293428]  sdb: sdb1 sdb2
[   25.295213] sd 4:0:4:0: Attached scsi generic sg4 type 0
[   25.297276] sd 4:0:3:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.298835] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 5, phy 5, sas_addr 0x5000c500070daa9d
[   25.303086] sd 4:0:4:0: [sde] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.303490] scsi 4:0:5:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.305054] sd 4:0:1:0: [sdb] Attached SCSI disk
[   25.305696] sd 4:0:4:0: [sde] Write Protect is off
[   25.305833] sd 4:0:4:0: [sde] Mode Sense: b3 00 10 08
[   25.305905] sd 4:0:5:0: Attached scsi generic sg5 type 0
[   25.305920]  sdc: sdc1 sdc2 sdc3
[   25.311848] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 7, phy 6, sas_addr 0x5000c500070dc1e5
[   25.311883] sd 4:0:4:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.311900] sd 4:0:5:0: [sdf] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.315388] scsi 4:0:6:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   25.315610] sd 4:0:5:0: [sdf] Write Protect is off
[   25.315752] sd 4:0:5:0: [sdf] Mode Sense: b3 00 10 08
[   25.317613]  sdd: sdd1 sdd2
[   25.317855] sd 4:0:6:0: Attached scsi generic sg6 type 0
[   25.318399] sd 4:0:5:0: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.318404] sd 4:0:2:0: [sdc] Attached SCSI disk
[   25.323688] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 8, phy 7, sas_addr 0x5000c5000128ff31
[   25.323700] sd 4:0:6:0: [sdg] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.326840] scsi 4:0:7:0: Direct-Access     SEAGATE  ST373455SS       0004 PQ: 0 ANSI: 5
[   25.327495] sd 4:0:6:0: [sdg] Write Protect is off
[   25.327631] sd 4:0:6:0: [sdg] Mode Sense: b3 00 10 08
[   25.329266] sd 4:0:7:0: Attached scsi generic sg7 type 0
[   25.329821] sd 4:0:6:0: [sdg] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.332024] sd 4:0:3:0: [sdd] Attached SCSI disk
[   25.332097]  sde: sde1
[   25.332324] sd 4:0:7:0: [sdh] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   25.338712] sd 4:0:7:0: [sdh] Write Protect is off
[   25.338846] sd 4:0:7:0: [sdh] Mode Sense: b3 00 10 08
[   25.339140]  sdf: sdf1
[   25.342210] sd 4:0:7:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.343236] sd 4:0:4:0: [sde] Attached SCSI disk
[   25.347993] sd 4:0:5:0: [sdf] Attached SCSI disk
[   25.349140]  sdh: sdh1
[   25.349688]  sdg: sdg1
[   25.357819] sd 4:0:7:0: [sdh] Attached SCSI disk
[   25.358377] sd 4:0:6:0: [sdg] Attached SCSI disk
[   25.383026] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[   25.390772] fuse init (API version 7.20)
[   25.403289] md: linear personality registered for level -1
[   25.408502] md: raid0 personality registered for level 0
[   25.411819] md: raid1 personality registered for level 1
[   25.414570] async_tx: api initialized (async)
[   25.415378] xor: automatically using best checksumming function:
[   25.425011]    generic_sse:  7312.000 MB/sec
[   25.445031] raid6: sse2x1    3378 MB/s
[   25.462015] raid6: sse2x2    4421 MB/s
[   25.479015] raid6: sse2x4    4562 MB/s
[   25.479145] raid6: using algorithm sse2x4 (4562 MB/s)
[   25.479278] raid6: using intx1 recovery algorithm
[   25.482072] md: raid6 personality registered for level 6
[   25.482212] md: raid5 personality registered for level 5
[   25.482345] md: raid4 personality registered for level 4
[   25.509196] udevd (1599): /proc/1599/oom_adj is deprecated, please use /proc/1599/oom_score_adj instead.
[   25.765804] tg3.c:v3.124 (March 21, 2012)
[   25.773501] tg3 0000:02:03.0: eth0: Tigon3 [partno(BCM95704A6) rev 2100] (PCIX:66MHz:64-bit) MAC address 00:30:48:63:8b:6e
[   25.773725] tg3 0000:02:03.0: eth0: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[   25.773942] tg3 0000:02:03.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[0]
[   25.774168] tg3 0000:02:03.0: eth0: dma_rwctrl[769f0000] dma_mask[64-bit]
[   25.798320] tg3 0000:02:03.1: eth1: Tigon3 [partno(BCM95704A6) rev 2100] (PCIX:66MHz:64-bit) MAC address 00:30:48:63:8b:6f
[   25.798545] tg3 0000:02:03.1: eth1: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[   25.798762] tg3 0000:02:03.1: eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[   25.798977] tg3 0000:02:03.1: eth1: dma_rwctrl[769f0000] dma_mask[64-bit]
[   25.806337] piix4_smbus 0000:00:02.0: SMBus Host Controller at 0x580, revision 0
[   25.810987] EDAC MC: Ver: 3.0.0
[   25.811213] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[   25.816782] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[   25.831382] AMD64 EDAC driver v3.4.0
[   25.841347] EDAC amd64: DRAM ECC enabled.
[   25.841490] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 0, MCG_CTL: 0x1f, NB MSR is enabled
[   25.841492] EDAC DEBUG: amd64_nb_mce_bank_enabled_on_node: core: 1, MCG_CTL: 0x1f, NB MSR is enabled
[   25.841495] EDAC amd64: K8 revF or later detected (node 0).
[   25.841636] EDAC DEBUG: reserve_mc_sibling_devs: F1: 0000:00:18.1
[   25.841638] EDAC DEBUG: reserve_mc_sibling_devs: F2: 0000:00:18.2
[   25.841639] EDAC DEBUG: reserve_mc_sibling_devs: F3: 0000:00:18.3
[   25.841640] EDAC DEBUG: read_mc_regs:   TOP_MEM:  0x00000000ee000000
[   25.841642] EDAC DEBUG: read_mc_regs:   TOP_MEM2: 0x0000000112000000
[   25.841645] EDAC DEBUG: read_mc_regs:   DRAM range[0], base: 0x0000000000000000; limit: 0x0000000111ffffff
[   25.841647] EDAC DEBUG: read_mc_regs:    IntlvEn=Disabled; Range access: RW IntlvSel=0 DstNode=0
[   25.841651] EDAC DEBUG: read_dct_base_mask:   DCSB0[0]=0x00000001 reg: F2x40
[   25.841653] EDAC DEBUG: read_dct_base_mask:   DCSB0[1]=0x00000101 reg: F2x44
[   25.841655] EDAC DEBUG: read_dct_base_mask:   DCSB0[2]=0x00000201 reg: F2x48
[   25.841657] EDAC DEBUG: read_dct_base_mask:   DCSB0[3]=0x00000301 reg: F2x4c
[   25.841659] EDAC DEBUG: read_dct_base_mask:   DCSB0[4]=0x00000000 reg: F2x50
[   25.841660] EDAC DEBUG: read_dct_base_mask:   DCSB0[5]=0x00000000 reg: F2x54
[   25.841662] EDAC DEBUG: read_dct_base_mask:   DCSB0[6]=0x00000000 reg: F2x58
[   25.841664] EDAC DEBUG: read_dct_base_mask:   DCSB0[7]=0x00000000 reg: F2x5c
[   25.841666] EDAC DEBUG: read_dct_base_mask:     DCSM0[0]=0x00f83ce0 reg: F2x60
[   25.841668] EDAC DEBUG: read_dct_base_mask:     DCSM0[1]=0x00f83ce0 reg: F2x64
[   25.841669] EDAC DEBUG: read_dct_base_mask:     DCSM0[2]=0x00000000 reg: F2x68
[   25.841671] EDAC DEBUG: read_dct_base_mask:     DCSM0[3]=0x00000000 reg: F2x6c
[   25.841674] EDAC DEBUG: dump_misc_regs: F3xE8 (NB Cap): 0x00001719
[   25.841675] EDAC DEBUG: dump_misc_regs:   NB two channel DRAM capable: yes
[   25.841676] EDAC DEBUG: dump_misc_regs:   ECC capable: yes, ChipKill ECC capable: yes
[   25.841678] EDAC DEBUG: amd64_dump_dramcfg_low: F2x090 (DRAM Cfg Low): 0x00090810
[   25.841679] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: unbuffered; all DIMMs support ECC: yes
[   25.841681] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: disabled
[   25.841682] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
[   25.841684] EDAC DEBUG: dump_misc_regs: F3xB0 (Online Spare): 0x0f000000
[   25.841686] EDAC DEBUG: dump_misc_regs: F1xF0 (DRAM Hole Address): 0xee001201, base: 0xee000000, offset: 0x12000000
[   25.841687] EDAC DEBUG: dump_misc_regs:   DramHoleValid: yes
[   25.841689] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x080 (DRAM Bank Address Mapping): 0x00000022
[   25.841690] EDAC MC: DCT0 chip selects:
[   25.841692] EDAC amd64: MC: 0:  2048MB 1:  2048MB
[   25.841824] EDAC amd64: MC: 2:  2048MB 3:  2048MB
[   25.841955] EDAC amd64: MC: 4:     0MB 5:     0MB
[   25.842104] EDAC amd64: MC: 6:     0MB 7:     0MB
[   25.842239] EDAC DEBUG: edac_mc_alloc: allocating 1160 bytes for mci data (16 ranks, 16 csrows/channels)
[   25.842266] EDAC DEBUG: init_csrows: node 0, NBCFG=0x0ad00044[ChipKillEccCap: 1|DramEccEn: 1]
[   25.842267] EDAC DEBUG: amd64_csrow_nr_pages:   (csrow=0) DBAM map index= 2
[   25.842269] EDAC DEBUG: amd64_csrow_nr_pages:     nr_pages/channel= 262144  channel-count = 2
[   25.842271] EDAC amd64: CS0: Unbuffered DDR2 RAM
[   25.842405] EDAC DEBUG: init_csrows:   for MC node 0 csrow 0:
[   25.842406] EDAC DEBUG: init_csrows:     nr_pages: 524288
[   25.842408] EDAC DEBUG: amd64_csrow_nr_pages:   (csrow=1) DBAM map index= 2
[   25.842409] EDAC DEBUG: amd64_csrow_nr_pages:     nr_pages/channel= 262144  channel-count = 2
[   25.842410] EDAC amd64: CS1: Unbuffered DDR2 RAM
[   25.842542] EDAC DEBUG: init_csrows:   for MC node 0 csrow 1:
[   25.842543] EDAC DEBUG: init_csrows:     nr_pages: 524288
[   25.842544] EDAC DEBUG: amd64_csrow_nr_pages:   (csrow=2) DBAM map index= 2
[   25.842546] EDAC DEBUG: amd64_csrow_nr_pages:     nr_pages/channel= 262144  channel-count = 2
[   25.842547] EDAC amd64: CS2: Unbuffered DDR2 RAM
[   25.842679] EDAC DEBUG: init_csrows:   for MC node 0 csrow 2:
[   25.842680] EDAC DEBUG: init_csrows:     nr_pages: 524288
[   25.842681] EDAC DEBUG: amd64_csrow_nr_pages:   (csrow=3) DBAM map index= 2
[   25.842683] EDAC DEBUG: amd64_csrow_nr_pages:     nr_pages/channel= 262144  channel-count = 2
[   25.842684] EDAC amd64: CS3: Unbuffered DDR2 RAM
[   25.842816] EDAC DEBUG: init_csrows:   for MC node 0 csrow 3:
[   25.842817] EDAC DEBUG: init_csrows:     nr_pages: 524288
[   25.842819] EDAC DEBUG: init_csrows: ----CSROW 4 VALID for MC node 0
[   25.842820] EDAC DEBUG: init_csrows: ----CSROW 5 VALID for MC node 0
[   25.842821] EDAC DEBUG: init_csrows: ----CSROW 6 VALID for MC node 0
[   25.842823] EDAC DEBUG: init_csrows: ----CSROW 7 VALID for MC node 0
[   25.842824] EDAC DEBUG: edac_mc_add_mc: 
[   25.842827] EDAC DEBUG: edac_create_sysfs_mci_device: creating bus mc0
[   25.842854] EDAC DEBUG: edac_create_sysfs_mci_device: creating device mc0
[   25.842875] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm0, located at csrow 0 channel 0 
[   25.842888] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank0
[   25.842889] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm1, located at csrow 0 channel 1 
[   25.842900] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank1
[   25.842901] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm2, located at csrow 1 channel 0 
[   25.842913] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank2
[   25.842914] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm3, located at csrow 1 channel 1 
[   25.842926] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank3
[   25.842928] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm8, located at csrow 4 channel 0 
[   25.842938] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank8
[   25.842940] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm9, located at csrow 4 channel 1 
[   25.842950] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank9
[   25.842952] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm10, located at csrow 5 channel 0 
[   25.842964] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank10
[   25.842966] EDAC DEBUG: edac_create_sysfs_mci_device: creating dimm11, located at csrow 5 channel 1 
[   25.842976] EDAC DEBUG: edac_create_dimm_object: creating rank/dimm device rank11
[   25.842978] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow0
[   25.842991] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow1
[   25.843016] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow2
[   25.843027] EDAC DEBUG: edac_create_csrow_object: creating (virtual) csrow node csrow3
[   25.843059] EDAC MC0: Giving out device to 'amd64_edac' 'K8': DEV 0000:00:18.2
[   25.843317] EDAC DEBUG: edac_pci_alloc_ctl_info: 
[   25.843320] EDAC DEBUG: edac_pci_add_device: 
[   25.843322] EDAC DEBUG: add_edac_pci_to_global_list: 
[   25.843323] EDAC DEBUG: find_edac_pci_by_dev: 
[   25.843325] EDAC DEBUG: edac_pci_create_sysfs: idx=0
[   25.843326] EDAC DEBUG: edac_pci_main_kobj_setup: 
[   25.843332] EDAC DEBUG: edac_pci_main_kobj_setup: Registered '.../edac/pci' kobject
[   25.843333] EDAC DEBUG: edac_pci_create_instance_kobj: 
[   25.843337] EDAC DEBUG: edac_pci_create_instance_kobj: Register instance 'pci0' kobject
[   25.843339] EDAC DEBUG: edac_pci_workq_setup: 
[   25.843343] EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
[   28.994536] kvm: Nested Virtualization enabled
[   29.009824] microcode: AMD CPU family 0xf not supported
[   29.953049] w83793 0-002f: Registered watchdog chardev major 10, minor: 130
[   30.121069] NET: Registered protocol family 10
[   30.121499] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   30.121661] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   30.836610] Adding 4192960k swap on /dev/sdc3.  Priority:-1 extents:1 across:4192960k 
[   31.219162] microcode: AMD CPU family 0xf not supported
[   31.234579] microcode: AMD CPU family 0xf not supported
[   31.861807] tg3 0000:02:03.0: eth1: Link is up at 1000 Mbps, full duplex
[   31.861949] tg3 0000:02:03.0: eth1: Flow control is off for TX and off for RX
[   31.862114] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   32.449399] tg3 0000:02:03.1: eth0: Link is up at 1000 Mbps, full duplex
[   32.449543] tg3 0000:02:03.1: eth0: Flow control is off for TX and off for RX
[   32.449697] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   33.793912] ip_tables: (C) 2000-2006 Netfilter Core Team
[   35.490265] warning: `named' uses 32-bit capabilities (legacy support in use)

--------------080104080706020008050206--
