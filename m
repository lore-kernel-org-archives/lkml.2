Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2FNN4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:56:37 -0400
Received: from hera.cwi.nl ([192.16.191.8]:50462 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985Ab2FNN43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:56:29 -0400
X-Greylist: delayed 1763 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2012 09:56:28 EDT
Message-ID: <4FD9E69A.4090708@cwi.nl>
Date: Thu, 14 Jun 2012 14:26:50 +0100
From: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: intergalactic.anonymous@gmail.com, len.brown@intel.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [3.4 regression] [bisected] DisplayPort fails to come on
Content-Type: multipart/mixed;
 boundary="------------090103010701070007060903"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090103010701070007060903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Igor and Len,

When I cold boot 3.4 on my laptop the second monitor attached to the 
displayport stays blank. It works fine with 3.3.8 and earlier.

I get two error messages in dmesg:

kernel: video: probe of LNXVIDEO:00 failed with error -5

kernel: [drm:intel_dp_complete_link_train] *ERROR* failed to train DP, 
aborting

When I warm boot 3.4 after running kernel 3.3.8 first, only the first 
message appears and the display works fine.

A bisection based on the occurrence of the first error message resulted in

Author: Igor Murzov <intergalactic.anonymous@gmail.com>  2012-03-30 18:32:08
Committer: Len Brown <len.brown@intel.com>  2012-03-30 20:44:05
Parent: c16fa4f2ad19908a47c63d8fa436a1178438c7e7 (Linux 3.3)
Branches: linux-3.4.y, remotes/origin/linux-3.4.y, remotes/origin/master
Follows: v3.3
Precedes: v3.4-rc1

     ACPI video: Harden video bus adding.

     It is always better to check return values, so add some new checks and
     correct existing ones.

     v2: Be consistent and don't mix errors from -E* and AE_* namespaces.

     Signed-off-by: Igor Murzov <e-mail@date.by>
     Signed-off-by: Len Brown <len.brown@intel.com>


The laptop is a Dell System XPS L702X/0XN71K, BIOS A17 02/22/2012. It 
has two graphics card in Optimus configuration:
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core 
Processor Family Integrated Graphics Controller (rev 09)
01:00.0 VGA compatible controller: NVIDIA Corporation Device 124d (rev a1)

I only use the Intel card (which drives the DP port if I am not mistaken)

I hope this is helpful. Please let me know what I can do next to track 
this problem down.

With kind regards,

Wouter Koolen

--------------090103010701070007060903
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

Initializing cgroup subsys cpu
Linux version 3.3.0.bisect25+ (root@wensxps) (gcc version 4.6.3 (Debian 4.6.3-1) ) #72 SMP Thu Jun 14 13:18:20 BST 2012
Command line: BOOT_IMAGE=/boot/vmlinuz-3.3.0.bisect25+ root=UUID=39c0ed04-fbf1-43b0-8e7a-09e446a8bea6 ro
KERNEL supported cpus:
  Intel GenuineIntel
Disabled fast string operations
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
 BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bac8f000 (usable)
 BIOS-e820: 00000000bac8f000 - 00000000bade2000 (reserved)
 BIOS-e820: 00000000bade2000 - 00000000badea000 (ACPI NVS)
 BIOS-e820: 00000000badea000 - 00000000baf1f000 (reserved)
 BIOS-e820: 00000000baf1f000 - 00000000baf9f000 (ACPI NVS)
 BIOS-e820: 00000000baf9f000 - 00000000bafff000 (ACPI data)
 BIOS-e820: 00000000bafff000 - 00000000bb000000 (usable)
 BIOS-e820: 00000000bb000000 - 00000000bfa00000 (reserved)
 BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed08000 - 00000000fed09000 (reserved)
 BIOS-e820: 00000000fed10000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffd80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000023e9ff000 (usable)
 BIOS-e820: 000000023e9ff000 - 000000023fe00000 (reserved)
NX (Execute Disable) protection: active
DMI 2.6 present.
DMI: Dell Inc.          Dell System XPS L702X/0XN71K, BIOS A17 02/22/2012
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x23e9ff max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0FFC00000 mask FFFC00000 write-protect
  1 base 000000000 mask F80000000 write-back
  2 base 080000000 mask FC0000000 write-back
  3 base 0BC000000 mask FFC000000 uncachable
  4 base 0BB000000 mask FFF000000 uncachable
  5 base 100000000 mask F00000000 write-back
  6 base 200000000 mask FC0000000 write-back
  7 base 23FE00000 mask FFFE00000 uncachable
  8 disabled
  9 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xbb000 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff880000098000] 98000 size 20480
init_memory_mapping: 0000000000000000-00000000bb000000
 0000000000 - 00bb000000 page 2M
kernel direct mapping tables up to bb000000 @ 1fffc000-20000000
init_memory_mapping: 0000000100000000-000000023e9ff000
 0100000000 - 023e800000 page 2M
 023e800000 - 023e9ff000 page 4k
kernel direct mapping tables up to 23e9ff000 @ bac84000-bac8f000
RAMDISK: 37adc000 - 37d66000
ACPI: RSDP 00000000000f00e0 00024 (v02 DELL  )
ACPI: XSDT 00000000baffe120 0008C (v01 DELL    QA09    00000002 LOHR 00000002)
ACPI: FACP 00000000bafef000 000F4 (v03 DELL    QA09    00000002 PTL  00000002)
ACPI: DSDT 00000000baff2000 09178 (v02 DELL    SNB-CPT 00000000 INTL 20061109)
ACPI: FACS 00000000baf40000 00040
ACPI: SLIC 00000000baffd000 00176 (v01 DELL    QA09    00000002 LOHR 00000001)
ACPI: SSDT 00000000baffc000 00166 (v01 DELL   PtidDevc 00001000 INTL 20061109)
ACPI: ASF! 00000000baff1000 000A5 (v32 DELL    QA09    00000002 PTL  00000002)
ACPI: HPET 00000000bafee000 00038 (v01 DELL    QA09    00000002 PTL  00000002)
ACPI: APIC 00000000bafed000 00098 (v01 DELL    QA09    00000002 PTL  00000002)
ACPI: MCFG 00000000bafec000 0003C (v01 DELL    QA09    00000002 PTL  00000002)
ACPI: SSDT 00000000bafea000 012AD (v01 NvORef NvOptTbl 00001000 INTL 20061109)
ACPI: SSDT 00000000bafe9000 0094E (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
ACPI: SSDT 00000000bafe8000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
ACPI: UEFI 00000000bafe7000 0003E (v01 DELL    QA09    00000002 PTL  00000002)
ACPI: UEFI 00000000bafe6000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
ACPI: UEFI 00000000bafe5000 0026A (v01 DELL    QA09    00000002 PTL  00000002)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-000000023e9ff000
Initmem setup node 0 0000000000000000-000000023e9ff000
  NODE_DATA [000000023e9fa000 - 000000023e9fefff]
 [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880236000000-ffff88023cffffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x0023e9ff
Movable zone start PFN for each node
Early memory PFN ranges
    0: 0x00000010 -> 0x0000009d
    0: 0x00000100 -> 0x000bac8f
    0: 0x000bafff -> 0x000bb000
    0: 0x00100000 -> 0x0023e9ff
On node 0 totalpages: 2070044
  DMA zone: 56 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3920 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 746696 pages, LIFO batch:31
  Normal zone: 17843 pages used for memmap
  Normal zone: 1287244 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
SMP: Allowing 8 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000bac8f000 - 00000000bade2000
PM: Registered nosave memory: 00000000bade2000 - 00000000badea000
PM: Registered nosave memory: 00000000badea000 - 00000000baf1f000
PM: Registered nosave memory: 00000000baf1f000 - 00000000baf9f000
PM: Registered nosave memory: 00000000baf9f000 - 00000000bafff000
PM: Registered nosave memory: 00000000bb000000 - 00000000bfa00000
PM: Registered nosave memory: 00000000bfa00000 - 00000000f8000000
PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
PM: Registered nosave memory: 00000000fec01000 - 00000000fed08000
PM: Registered nosave memory: 00000000fed08000 - 00000000fed09000
PM: Registered nosave memory: 00000000fed09000 - 00000000fed10000
PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
PM: Registered nosave memory: 00000000fee01000 - 00000000ffd80000
PM: Registered nosave memory: 00000000ffd80000 - 0000000100000000
Allocating PCI resources starting at bfa00000 (gap: bfa00000:38600000)
setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 26 pages/cpu @ffff88023e600000 s77440 r8192 d20864 u262144
pcpu-alloc: s77440 r8192 d20864 u262144 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2037860
Policy zone: Normal
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.3.0.bisect25+ root=UUID=39c0ed04-fbf1-43b0-8e7a-09e446a8bea6 ro
PID hash table entries: 4096 (order: 3, 32768 bytes)
xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
Memory: 8085740k/9414652k available (4110k kernel code, 1134476k absent, 194436k reserved, 4582k data, 468k init)
Hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
NR_IRQS:33024 nr_irqs:744 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2194.995 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4389.99 BogoMIPS (lpj=8779980)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
Disabled fast string operations
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
ACPI: Core revision 20120111
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz stepping 07
Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
PEBS disabled due to CPU errata.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
NMI watchdog enabled, takes one hw-pmu counter.
Booting Node   0, Processors  #1
smpboot cpu 1: start_ip = 98000
Disabled fast string operations
CPU1: Thermal monitoring handled by SMI
NMI watchdog enabled, takes one hw-pmu counter.
 #2
smpboot cpu 2: start_ip = 98000
Disabled fast string operations
CPU2: Thermal monitoring handled by SMI
NMI watchdog enabled, takes one hw-pmu counter.
 #3
smpboot cpu 3: start_ip = 98000
Disabled fast string operations
CPU3: Thermal monitoring handled by SMI
NMI watchdog enabled, takes one hw-pmu counter.
 #4
smpboot cpu 4: start_ip = 98000
Disabled fast string operations
CPU4: Thermal monitoring handled by SMI
NMI watchdog enabled, takes one hw-pmu counter.
 #5
smpboot cpu 5: start_ip = 98000
Disabled fast string operations
CPU5: Thermal monitoring handled by SMI
NMI watchdog enabled, takes one hw-pmu counter.
 #6
smpboot cpu 6: start_ip = 98000
Disabled fast string operations
CPU6: Thermal monitoring handled by SMI
NMI watchdog enabled, takes one hw-pmu counter.
 #7 Ok.
smpboot cpu 7: start_ip = 98000
Disabled fast string operations
CPU7: Thermal monitoring handled by SMI
NMI watchdog enabled, takes one hw-pmu counter.
Brought up 8 CPUs
Total of 8 processors activated (35119.92 BogoMIPS).
devtmpfs: initialized
PM: Registering ACPI NVS region at bade2000 (32768 bytes)
PM: Registering ACPI NVS region at baf1f000 (524288 bytes)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 00000000baf10718 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
ACPI: SSDT 00000000baf11a98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
ACPI: SSDT 00000000baf0fd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
\_SB_.PCI0:_OSC invalid UUID
_OSC request data:1 8 1f 
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0xbfa00000-0xfeafffff]
pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0xbfa00000-0xfeafffff]
pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: [8086:0116] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xf2400000-0xf27fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
pci 0000:00:16.0: reg 10: [mem 0xf3c05000-0xf3c0500f 64bit]
pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
pci 0000:00:1a.0: reg 10: [mem 0xf3c0a000-0xf3c0a3ff]
pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xf3c00000-0xf3c03fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: [8086:1c18] type 1 class 0x000604
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: [8086:1c1a] type 1 class 0x000604
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
pci 0000:00:1d.0: reg 10: [mem 0xf3c09000-0xf3c093ff]
pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.0: [8086:1c4b] type 0 class 0x000601
pci 0000:00:1f.2: [8086:1c03] type 0 class 0x000106
pci 0000:00:1f.2: reg 10: [io  0x5088-0x508f]
pci 0000:00:1f.2: reg 14: [io  0x5094-0x5097]
pci 0000:00:1f.2: reg 18: [io  0x5080-0x5087]
pci 0000:00:1f.2: reg 1c: [io  0x5090-0x5093]
pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
pci 0000:00:1f.2: reg 24: [mem 0xf3c08000-0xf3c087ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
pci 0000:00:1f.3: reg 10: [mem 0xf3c04000-0xf3c040ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
pci 0000:01:00.0: [10de:124d] type 0 class 0x000300
pci 0000:01:00.0: reg 10: [mem 0xf0000000-0xf1ffffff]
pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:01:00.0: reg 1c: [mem 0xd0000000-0xd3ffffff 64bit pref]
pci 0000:01:00.0: reg 24: [io  0x4000-0x407f]
pci 0000:01:00.0: reg 30: [mem 0xfff80000-0xffffffff pref]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf20fffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd3ffffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:03:00.0: [8086:0091] type 0 class 0x000280
pci 0000:03:00.0: reg 10: [mem 0xf3b00000-0xf3b01fff 64bit]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [mem 0xf3b00000-0xf3bfffff]
pci 0000:04:00.0: [1033:0194] type 0 class 0x000c03
pci 0000:04:00.0: reg 10: [mem 0xf3a00000-0xf3a01fff 64bit]
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PCI bridge to [bus 04-04]
pci 0000:00:1c.3:   bridge window [mem 0xf3a00000-0xf3afffff]
pci 0000:00:1c.4: PCI bridge to [bus 05-09]
pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.4:   bridge window [mem 0xf3100000-0xf39fffff]
pci 0000:00:1c.4:   bridge window [mem 0xf2800000-0xf2ffffff 64bit pref]
pci 0000:0a:00.0: [10ec:8168] type 0 class 0x000200
pci 0000:0a:00.0: reg 10: [io  0x2000-0x20ff]
pci 0000:0a:00.0: reg 18: [mem 0xf3004000-0xf3004fff 64bit pref]
pci 0000:0a:00.0: reg 20: [mem 0xf3000000-0xf3003fff 64bit pref]
pci 0000:0a:00.0: supports D1 D2
pci 0000:0a:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:1c.5: PCI bridge to [bus 0a-0a]
pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.5:   bridge window [mem 0xf3000000-0xf30fffff 64bit pref]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
\_SB_.PCI0:_OSC invalid UUID
_OSC request data:1 1f 1f 
 pci0000:00: Requesting ACPI _OSC control (0x1d)
\_SB_.PCI0:_OSC invalid UUID
_OSC request data:1 0 1d 
 pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: 0x1d
ACPI _OSC control for PCIe not granted, disabling ASPM
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 *6 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 *5 6 10 11 12 14 15)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:01:00.0
vgaarb: no bridge control possible 0000:00:02.0
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009d800 - 000000000009ffff 
reserve RAM buffer: 00000000bac8f000 - 00000000bbffffff 
reserve RAM buffer: 00000000bb000000 - 00000000bbffffff 
reserve RAM buffer: 000000023e9ff000 - 000000023fffffff 
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-3e]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000c0000-0x000c3fff window]
pnp 00:00: [mem 0x000c4000-0x000c7fff window]
pnp 00:00: [mem 0x000c8000-0x000cbfff window]
pnp 00:00: [mem 0x000cc000-0x000cffff window]
pnp 00:00: [mem 0x000d0000-0x000d3fff window]
pnp 00:00: [mem 0x000d4000-0x000d7fff window]
pnp 00:00: [mem 0x000d8000-0x000dbfff window]
pnp 00:00: [mem 0x000dc000-0x000dffff window]
pnp 00:00: [mem 0x000e0000-0x000e3fff window]
pnp 00:00: [mem 0x000e4000-0x000e7fff window]
pnp 00:00: [mem 0x000e8000-0x000ebfff window]
pnp 00:00: [mem 0x000ec000-0x000effff window]
pnp 00:00: [mem 0x000f0000-0x000fffff window]
pnp 00:00: [mem 0xbfa00000-0xfeafffff window]
pnp 00:00: [mem 0xfed40000-0xfed44fff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [io  0x0000-0x001f]
pnp 00:01: [io  0x0081-0x0091]
pnp 00:01: [io  0x0093-0x009f]
pnp 00:01: [io  0x00c0-0x00df]
pnp 00:01: [dma 4]
pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:02: [mem 0xfed00000-0xfed003ff]
pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:03: [io  0x00f0]
pnp 00:03: [irq 13]
pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:04: [io  0x002e-0x002f]
pnp 00:04: [io  0x004e-0x004f]
pnp 00:04: [io  0x0061]
pnp 00:04: [io  0x0063]
pnp 00:04: [io  0x0065]
pnp 00:04: [io  0x0067]
pnp 00:04: [io  0x0068]
pnp 00:04: [io  0x006c]
pnp 00:04: [io  0x0070]
pnp 00:04: [io  0x0080]
pnp 00:04: [io  0x0092]
pnp 00:04: [io  0x00b2-0x00b3]
pnp 00:04: [io  0x0680-0x069f]
pnp 00:04: [io  0x1000-0x1003]
pnp 00:04: [io  0x1004-0x1013]
pnp 00:04: [io  0xffff]
pnp 00:04: [io  0x0400-0x0453]
pnp 00:04: [io  0x0458-0x047f]
pnp 00:04: [io  0x0500-0x057f]
pnp 00:04: [io  0x164e-0x164f]
system 00:04: [io  0x0680-0x069f] has been reserved
system 00:04: [io  0x1000-0x1003] has been reserved
system 00:04: [io  0x1004-0x1013] has been reserved
system 00:04: [io  0xffff] has been reserved
system 00:04: [io  0x0400-0x0453] has been reserved
system 00:04: [io  0x0458-0x047f] has been reserved
system 00:04: [io  0x0500-0x057f] has been reserved
system 00:04: [io  0x164e-0x164f] has been reserved
system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:05: [io  0x0070-0x0077]
pnp 00:05: [irq 8]
pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:06: [io  0x0454-0x0457]
system 00:06: [io  0x0454-0x0457] has been reserved
system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
pnp 00:07: [io  0x0060]
pnp 00:07: [io  0x0064]
pnp 00:07: [irq 1]
pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:08: [irq 12]
pnp 00:08: Plug and Play ACPI device, IDs DLL0571 PNP0f13 (active)
pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
pnp 00:09: [mem 0xfed10000-0xfed17fff]
pnp 00:09: [mem 0xfed18000-0xfed18fff]
pnp 00:09: [mem 0xfed19000-0xfed19fff]
pnp 00:09: [mem 0xf8000000-0xfbffffff]
pnp 00:09: [mem 0xfed20000-0xfed3ffff]
pnp 00:09: [mem 0xfed90000-0xfed93fff]
pnp 00:09: [mem 0xfed45000-0xfed8ffff]
pnp 00:09: [mem 0xff000000-0xffffffff]
pnp 00:09: [mem 0xfee00000-0xfeefffff]
pnp 00:09: [mem 0xfffff000-0xffffffff]
pnp 00:09: disabling [mem 0xfffff000-0xffffffff] because it overlaps 0000:01:00.0 BAR 6 [mem 0xfff80000-0xffffffff pref]
system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:09: [mem 0xfed90000-0xfed93fff] has been reserved
system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0a: [irq 20]
pnp 00:0a: Plug and Play ACPI device, IDs SMO8800 (active)
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:01:00.0: no compatible bridge window for [mem 0xfff80000-0xffffffff pref]
PCI: max bus depth: 1 pci_try_num: 2
pci 0000:01:00.0: BAR 6: assigned [mem 0xf2000000-0xf207ffff pref]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf20fffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd3ffffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [mem 0xf3b00000-0xf3bfffff]
pci 0000:00:1c.3: PCI bridge to [bus 04-04]
pci 0000:00:1c.3:   bridge window [mem 0xf3a00000-0xf3afffff]
pci 0000:00:1c.4: PCI bridge to [bus 05-09]
pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.4:   bridge window [mem 0xf3100000-0xf39fffff]
pci 0000:00:1c.4:   bridge window [mem 0xf2800000-0xf2ffffff 64bit pref]
pci 0000:00:1c.5: PCI bridge to [bus 0a-0a]
pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.5:   bridge window [mem 0xf3000000-0xf30fffff 64bit pref]
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xfeafffff]
pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:01: resource 1 [mem 0xf0000000-0xf20fffff]
pci_bus 0000:01: resource 2 [mem 0xc0000000-0xd3ffffff 64bit pref]
pci_bus 0000:03: resource 1 [mem 0xf3b00000-0xf3bfffff]
pci_bus 0000:04: resource 1 [mem 0xf3a00000-0xf3afffff]
pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:05: resource 1 [mem 0xf3100000-0xf39fffff]
pci_bus 0000:05: resource 2 [mem 0xf2800000-0xf2ffffff 64bit pref]
pci_bus 0000:0a: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:0a: resource 2 [mem 0xf3000000-0xf30fffff 64bit pref]
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 4096 (order: 5, 131072 bytes)
UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
Unpacking initramfs...
Freeing initrd memory: 2600k freed
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff8800b6c84000 - ffff8800bac84000
software IO TLB at phys 0xb6c84000 - 0xbac84000
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 15797
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
intel_idle: MWAIT substates: 0x21120
intel_idle: v0.4 model 0x2A
intel_idle: lapic_timer_reliable_states 0xffffffff
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
ACPI: Lid Switch [LID0]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
ACPI: Power Button [PWRF]
GHES: HEST is not enabled!
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 65536K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: setting latency timer to 64
i915 0000:00:02.0: irq 41 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
[drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
fbcon: inteldrmfb (fb0) is primary device
Refined TSC clocksource calibration: 2195.012 MHz.
Switching to clocksource tsc
Console: switching to colour frame buffer device 160x64
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
acpi device:2f: registered as cooling_device0
video: probe of LNXVIDEO:00 failed with error -5
acpi device:31: registered as cooling_device0
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input4
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:05: RTC can wake from S4
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 10
NET: Registered protocol family 17
Registering the dns_resolver key type
PM: Hibernation image not present or could not be loaded.
registered taskstats version 1
rtc_cmos 00:05: setting system clock to 2012-06-14 12:20:52 UTC (1339676452)
Initializing network drop monitor service
Freeing unused kernel memory: 468k freed
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 2012k freed
Freeing unused kernel memory: 744k freed
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
udevd[75]: starting version 175
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (54 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [TZ01] (54 C)
SCSI subsystem initialized
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x33 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xf3c08000 port 0xf3c08100 irq 42
ata2: SATA max UDMA/133 abar m2048@0xf3c08000 port 0xf3c08180 irq 42
ata3: DUMMY
ata4: DUMMY
ata5: SATA max UDMA/133 abar m2048@0xf3c08000 port 0xf3c08300 irq 42
ata6: SATA max UDMA/133 abar m2048@0xf3c08000 port 0xf3c08380 irq 42
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
ata1.00: ATA-8: ST9500423AS, 0002DEM1, max UDMA/133
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST9500423AS      0002 PQ: 0 ANSI: 5
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
ata2.00: ATA-8: ST9500423AS, 0002DEM1, max UDMA/133
ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      ST9500423AS      0002 PQ: 0 ANSI: 5
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata6.00: ATAPI: HL-DT-ST DVD+-RW GT50N, A101, max UDMA/133
ata6.00: configured for UDMA/133
scsi 5:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GT50N    A101 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 1:0:0:0: [sdb] 4096-byte physical blocks
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 4096-byte physical blocks
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
PM: Starting manual resume from disk
PM: Hibernation image partition 8:6 present
PM: Looking for hibernation image.
PM: Image not found (code -22)
PM: Hibernation image not present or could not be loaded.
EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
udevd[323]: starting version 175
ACPI Warning: 0x000000000000efa0-0x000000000000efbf SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120111/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
wmi: Mapper loaded
iTCO_vendor_support: vendor-support=0
mei: module is from the staging directory, the quality is unknown, you have been warned.
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
mei 0000:00:16.0: setting latency timer to 64
mei 0000:00:16.0: irq 43 for MSI/MSI-X
input: PC Speaker as /devices/platform/pcspkr/input/input6
ACPI: Battery Slot [BAT0] (battery present)
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:0a:00.0: irq 44 for MSI/MSI-X
r8169 0000:0a:00.0: eth0: RTL8168e/8111e at 0xffffc900057ba000, 84:8f:69:c4:09:63, XID 0c200000 IRQ 44
r8169 0000:0a:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
input: Dell WMI hotkeys as /devices/virtual/input/input7
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.0: setting latency timer to 64
ehci_hcd 0000:00:1a.0: EHCI Host Controller
ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.0: debug port 2
ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf3c0a000
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.3.0.bisect25+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ehci_hcd 0000:00:1d.0: setting latency timer to 64
ehci_hcd 0000:00:1d.0: EHCI Host Controller
ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.0: debug port 2
ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf3c09000
ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 3.3.0.bisect25+ ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
ACPI: AC Adapter [ADP0] (on-line)
hub 2-0:1.0: 2 ports detected
xhci_hcd 0000:04:00.0: xHCI Host Controller
xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 3
xhci_hcd 0000:04:00.0: irq 19, io mem 0xf3a00000
xhci_hcd 0000:04:00.0: irq 45 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 46 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 48 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 49 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 50 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 51 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 52 for MSI/MSI-X
usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: xHCI Host Controller
usb usb3: Manufacturer: Linux 3.3.0.bisect25+ xhci_hcd
usb usb3: SerialNumber: 0000:04:00.0
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
xhci_hcd 0000:04:00.0: xHCI Host Controller
xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 4
usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: xHCI Host Controller
usb usb4: Manufacturer: Linux 3.3.0.bisect25+ xhci_hcd
usb usb4: SerialNumber: 0000:04:00.0
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
snd_hda_intel 0000:00:1b.0: irq 53 for MSI/MSI-X
usb 1-1: new high-speed USB device number 2 using ehci_hcd
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 5:0:0:0: Attached scsi CD-ROM sr0
cfg80211: Calling CRDA to update world regulatory domain
Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
Copyright(c) 2003-2011 Intel Corporation
iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
iwlwifi 0000:03:00.0: pci_resource_base = ffffc900057b4000
iwlwifi 0000:03:00.0: HW Revision ID = 0x34
iwlwifi 0000:03:00.0: irq 54 for MSI/MSI-X
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6230 AGN, REV=0xB0
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: device EEPROM VER=0x716, CALIB=0x6
iwlwifi 0000:03:00.0: Device SKU: 0x1F0
iwlwifi 0000:03:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
usb 1-1: New USB device found, idVendor=8087, idProduct=0024
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 6 ports detected
usb 2-1: new high-speed USB device number 2 using ehci_hcd
psmouse serio1: synaptics: Touchpad model: 1, fw: 7.4, id: 0x1e0b1, caps: 0xd04773/0xa40000/0x8a0400
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input8
usb 2-1: New USB device found, idVendor=8087, idProduct=0024
usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 8 ports detected
iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1
Registered led device: phy0-led
ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
usb 3-1: new low-speed USB device number 2 using xhci_hcd
hda_codec: ALC665: SKU not ready 0x598301f0
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
usb 3-1: New USB device found, idVendor=045e, idProduct=0040
usb 3-1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
usb 3-1: Product: Microsoft 3-Button Mouse with IntelliEye(TM)
usb 3-1: Manufacturer: Microsoft
usb 3-1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
HDMI status: Codec=3 Pin=6 Presence_Detect=0 ELD_Valid=0
input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
usb 3-2: new low-speed USB device number 3 using xhci_hcd
usb 3-2: New USB device found, idVendor=0a81, idProduct=0205
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: PS2 to USB Converter
usb 3-2: Manufacturer: CHESEN
usb 3-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
usb 3-2: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1c.3/0000:04:00.0/usb3/3-1/3-1:1.0/input/input14
generic-usb 0003:045E:0040.0001: input,hidraw0: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:04:00.0-1/input0
input: CHESEN PS2 to USB Converter as /devices/pci0000:00/0000:00:1c.3/0000:04:00.0/usb3/3-2/3-2:1.0/input/input15
generic-usb 0003:0A81:0205.0002: input,hidraw1: USB HID v1.10 Keyboard [CHESEN PS2 to USB Converter] on usb-0000:04:00.0-2/input0
input: CHESEN PS2 to USB Converter as /devices/pci0000:00/0000:00:1c.3/0000:04:00.0/usb3/3-2/3-2:1.1/input/input16
generic-usb 0003:0A81:0205.0003: input,hidraw2: USB HID v1.10 Mouse [CHESEN PS2 to USB Converter] on usb-0000:04:00.0-2/input1
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usb 1-1.4: new high-speed USB device number 3 using ehci_hcd
usb 1-1.4: New USB device found, idVendor=0408, idProduct=2fb1
usb 1-1.4: New USB device strings: Mfr=3, Product=2, SerialNumber=0
usb 1-1.4: Product: Laptop_Integrated_Webcam_2HDM
usb 1-1.4: Manufacturer: CN07CN2C7866421A1605A00
Linux media interface: v0.10
usb 2-1.5: new full-speed USB device number 3 using ehci_hcd
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
usb 2-1.5: New USB device found, idVendor=8086, idProduct=0189
usb 2-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Linux video capture interface: v2.00
uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_2HDM (0408:2fb1)
uvcvideo: No streaming interface found for terminal 6.
input: Laptop_Integrated_Webcam_2HDM as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input17
usbcore: registered new interface driver uvcvideo
USB Video Class driver (1.1.1)
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
usbcore: registered new interface driver btusb
Adding 15007740k swap on /dev/sda6.  Priority:-1 extents:1 across:15007740k 
EXT4-fs (sda5): re-mounted. Opts: (null)
EXT4-fs (sda5): re-mounted. Opts: errors=remount-ro
loop: module loaded
fuse init (API version 7.18)
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
ADDRCONF(NETDEV_UP): wlan0: link is not ready
input: ACPI Virtual Keyboard Device as /devices/virtual/input/input18
r8169 0000:0a:00.0: eth0: link down
r8169 0000:0a:00.0: eth0: link down
ADDRCONF(NETDEV_UP): eth0: link is not ready
[drm] Changing LVDS panel from (-hsync, -vsync) to (+hsync, +vsync)
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
r8169 0000:0a:00.0: eth0: link up
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU4 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU5 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU6 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU7 sig=0x206a7, pf=0x10, revision=0x23
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
microcode: CPU0 updated to revision 0x28, date = 2012-04-24
microcode: CPU1 updated to revision 0x28, date = 2012-04-24
microcode: CPU2 updated to revision 0x28, date = 2012-04-24
microcode: CPU3 updated to revision 0x28, date = 2012-04-24
microcode: CPU4 updated to revision 0x28, date = 2012-04-24
microcode: CPU5 updated to revision 0x28, date = 2012-04-24
microcode: CPU6 updated to revision 0x28, date = 2012-04-24
microcode: CPU7 updated to revision 0x28, date = 2012-04-24
eth0: no IPv6 routers present
[drm] Changing LVDS panel from (+hsync, +vsync) to (-hsync, -vsync)
wlan0: authenticate with d8:c7:c8:ad:e3:a9 (try 1)
wlan0: authenticate with d8:c7:c8:ad:e3:a9 (try 2)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:a9 (try 1)
wlan0: associate with d8:c7:c8:ad:e3:a9 (try 2)
wlan0: RX AssocResp from d8:c7:c8:ad:e3:a9 (capab=0x401 status=0 aid=2)
wlan0: associated
wlan0: moving STA d8:c7:c8:ad:e3:a9 to state 1
wlan0: moving STA d8:c7:c8:ad:e3:a9 to state 2
wlan0: Wrong control channel in association response: configured center-freq: 5180 hti-cfreq: 5540  hti->control_chan: 108 band: 1.  Disabling HT.
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: moving STA d8:c7:c8:ad:e3:a9 to state 3
wlan0: moving STA d8:c7:c8:ad:e3:a9 to state 2
wlan0: moving STA d8:c7:c8:ad:e3:a9 to state 1
wlan0: moving STA d8:c7:c8:ad:e3:a9 to state 0
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
wlan0: authenticate with d8:c7:c8:ad:e3:a1 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:a1 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:a1 (capab=0x421 status=0 aid=2)
wlan0: associated
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 1
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 2
wlan0: Wrong control channel in association response: configured center-freq: 2412 hti-cfreq: 2462  hti->control_chan: 11 band: 0.  Disabling HT.
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 3
wlan0: no IPv6 routers present
[drm] Changing LVDS panel from (-hsync, -vsync) to (+hsync, +vsync)
wlan0: deauthenticating from d8:c7:c8:ad:e3:a1 by local choice (reason=3)
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 2
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 1
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 0
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[drm] Changing LVDS panel from (+hsync, +vsync) to (-hsync, -vsync)
wlan0: authenticate with d8:c7:c8:ad:e3:a1 (try 1)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:a1 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:a1 (capab=0x421 status=0 aid=2)
wlan0: associated
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 1
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 2
wlan0: Wrong control channel in association response: configured center-freq: 2412 hti-cfreq: 2462  hti->control_chan: 11 band: 0.  Disabling HT.
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 3
wlan0: authenticate with 00:24:6c:82:b2:f1 (try 1)
wlan0: authenticated
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 2
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 1
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 0
wlan0: associate with 00:24:6c:82:b2:f1 (try 1)
wlan0: RX ReassocResp from 00:24:6c:82:b2:f1 (capab=0x421 status=0 aid=3)
wlan0: associated
wlan0: moving STA 00:24:6c:82:b2:f1 to state 1
wlan0: moving STA 00:24:6c:82:b2:f1 to state 2
wlan0: Wrong control channel in association response: configured center-freq: 2437 hti-cfreq: 2412  hti->control_chan: 1 band: 0.  Disabling HT.
wlan0: moving STA 00:24:6c:82:b2:f1 to state 3
wlan0: authenticate with d8:c7:c8:ad:e3:a1 (try 1)
wlan0: authenticated
wlan0: moving STA 00:24:6c:82:b2:f1 to state 2
wlan0: moving STA 00:24:6c:82:b2:f1 to state 1
wlan0: moving STA 00:24:6c:82:b2:f1 to state 0
wlan0: associate with d8:c7:c8:ad:e3:a1 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:a1 (capab=0x421 status=0 aid=2)
wlan0: associated
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 1
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 2
wlan0: Wrong control channel in association response: configured center-freq: 2412 hti-cfreq: 2462  hti->control_chan: 11 band: 0.  Disabling HT.
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 3
iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x2000000.
iwlwifi 0000:03:00.0: Loaded firmware version: 18.168.6.1
iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
iwlwifi 0000:03:00.0: Status: 0x000412E5, count: 6
iwlwifi 0000:03:00.0: 0x00002076 | ADVANCED_SYSASSERT          
iwlwifi 0000:03:00.0: 0x00009C14 | uPc
iwlwifi 0000:03:00.0: 0x00009BCE | branchlink1
iwlwifi 0000:03:00.0: 0x00009BCE | branchlink2
iwlwifi 0000:03:00.0: 0x0000DBEA | interruptlink1
iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
iwlwifi 0000:03:00.0: 0x00000000 | data1
iwlwifi 0000:03:00.0: 0x00000200 | data2
iwlwifi 0000:03:00.0: 0x00000609 | line
iwlwifi 0000:03:00.0: 0x000141F5 | beacon time
iwlwifi 0000:03:00.0: 0x00004E0A | tsf low
iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
iwlwifi 0000:03:00.0: 0x00000000 | time gp1
iwlwifi 0000:03:00.0: 0x3FD5DF46 | time gp2
iwlwifi 0000:03:00.0: 0x00000000 | time gp3
iwlwifi 0000:03:00.0: 0x754312A8 | uCode version
iwlwifi 0000:03:00.0: 0x000000B0 | hw version
iwlwifi 0000:03:00.0: 0x00480303 | board version
iwlwifi 0000:03:00.0: 0x047D004E | hcmd
iwlwifi 0000:03:00.0: 0xAF963080 | isr0
iwlwifi 0000:03:00.0: 0x11C9F800 | isr1
iwlwifi 0000:03:00.0: 0x00000E02 | isr2
iwlwifi 0000:03:00.0: 0x8142C8C2 | isr3
iwlwifi 0000:03:00.0: 0x00000000 | isr4
iwlwifi 0000:03:00.0: 0x01800112 | isr_pref
iwlwifi 0000:03:00.0: 0x000260A4 | wait_event
iwlwifi 0000:03:00.0: 0x000000D4 | l2p_control
iwlwifi 0000:03:00.0: 0x00000000 | l2p_duration
iwlwifi 0000:03:00.0: 0x00000007 | l2p_mhvalid
iwlwifi 0000:03:00.0: 0x00101040 | l2p_addr_match
iwlwifi 0000:03:00.0: 0x00000005 | lmpm_pmg_sel
iwlwifi 0000:03:00.0: 0x13011136 | timestamp
iwlwifi 0000:03:00.0: 0x0000B0C0 | flow_handler
iwlwifi 0000:03:00.0: CSR values:
iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00480303
iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
iwlwifi 0000:03:00.0:                     CSR_INT: 0X00000000
iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000038
iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X000000b0
iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xf3f80ffd
iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000801
iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00030001
iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080042
iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X0000bbfe
iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000058
iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X88234ac3
iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
iwlwifi 0000:03:00.0: FH register values:
iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X230c1500
iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02325f30
iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000b0
iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
iwlwifi 0000:03:00.0: Start IWL Event Log Dump: nothing in log
iwlwifi 0000:03:00.0: Error: Response NULL in 'REPLY_ADD_STA'
iwlwifi 0000:03:00.0: Adding station d8:c7:c8:ad:e3:a1 failed.
iwlwifi 0000:03:00.0: Command REPLY_ADD_STA failed: FW Error
iwlwifi 0000:03:00.0: Adding station ff:ff:ff:ff:ff:ff failed.
iwlwifi 0000:03:00.0: Command REPLY_RXON_TIMING failed: FW Error
iwlwifi 0000:03:00.0: Failed to send timing (-5)!
wlan0: authenticate with 00:24:6c:82:b2:f1 (try 1)
ieee80211 phy0: Hardware restart was requested
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
wlan0: authenticated
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 2
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 1
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 0
wlan0: waiting for beacon from 00:24:6c:82:b2:f1
wlan0: beacon received
wlan0: associate with 00:24:6c:82:b2:f1 (try 1)
wlan0: RX ReassocResp from 00:24:6c:82:b2:f1 (capab=0x421 status=0 aid=3)
wlan0: associated
wlan0: moving STA 00:24:6c:82:b2:f1 to state 1
wlan0: moving STA 00:24:6c:82:b2:f1 to state 2
wlan0: Wrong control channel in association response: configured center-freq: 2437 hti-cfreq: 2412  hti->control_chan: 1 band: 0.  Disabling HT.
wlan0: moving STA 00:24:6c:82:b2:f1 to state 3
wlan0: authenticate with d8:c7:c8:ad:e3:a1 (try 1)
wlan0: authenticated
wlan0: moving STA 00:24:6c:82:b2:f1 to state 2
wlan0: moving STA 00:24:6c:82:b2:f1 to state 1
wlan0: moving STA 00:24:6c:82:b2:f1 to state 0
wlan0: waiting for beacon from d8:c7:c8:ad:e3:a1
wlan0: beacon received
wlan0: associate with d8:c7:c8:ad:e3:a1 (try 1)
wlan0: RX ReassocResp from d8:c7:c8:ad:e3:a1 (capab=0x421 status=0 aid=2)
wlan0: associated
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 1
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 2
wlan0: Wrong control channel in association response: configured center-freq: 2412 hti-cfreq: 2462  hti->control_chan: 11 band: 0.  Disabling HT.
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 3
wlan0: authenticate with 00:24:6c:82:b2:f1 (try 1)
wlan0: authenticated
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 2
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 1
wlan0: moving STA d8:c7:c8:ad:e3:a1 to state 0
wlan0: waiting for beacon from 00:24:6c:82:b2:f1
wlan0: beacon received
wlan0: associate with 00:24:6c:82:b2:f1 (try 1)
wlan0: RX ReassocResp from 00:24:6c:82:b2:f1 (capab=0x421 status=0 aid=3)
wlan0: associated
wlan0: moving STA 00:24:6c:82:b2:f1 to state 1
wlan0: moving STA 00:24:6c:82:b2:f1 to state 2
wlan0: Wrong control channel in association response: configured center-freq: 2437 hti-cfreq: 2412  hti->control_chan: 1 band: 0.  Disabling HT.
wlan0: moving STA 00:24:6c:82:b2:f1 to state 3

--------------090103010701070007060903
Content-Type: text/plain;
 name="bisectlog"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bisectlog"

git bisect start
# bad: [1f5547c7f183363eabe07e5d202a49f2e94e995a] Linux 3.4.2
git bisect bad 1f5547c7f183363eabe07e5d202a49f2e94e995a
# good: [845720650c557a75262b629b0bc228fffcf64638] Linux 3.3.8
git bisect good 845720650c557a75262b629b0bc228fffcf64638
# good: [c16fa4f2ad19908a47c63d8fa436a1178438c7e7] Linux 3.3
git bisect good c16fa4f2ad19908a47c63d8fa436a1178438c7e7
# good: [f63d395d47f37a4fe771e6d4b1db9d2cdae5ffc5] Merge tag 'nfs-for-3.4-1' of git://git.linux-nfs.org/projects/trondmy/linux-nfs
git bisect good f63d395d47f37a4fe771e6d4b1db9d2cdae5ffc5
# good: [a6f707b601c3f85d4b816ea08a757ea1af4f1cc0] Merge git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia
git bisect good a6f707b601c3f85d4b816ea08a757ea1af4f1cc0
# bad: [174808af90a06ee59ffedd60c00c252f1f887f25] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect bad 174808af90a06ee59ffedd60c00c252f1f887f25
# bad: [adb3b1f3fc1c6edb501808ebf80a81e81c52eb73] Merge tag 'parisc-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.6
git bisect bad adb3b1f3fc1c6edb501808ebf80a81e81c52eb73
# good: [a9d38a4f2da6c49a257253a9fdef7a6bcb0e0e4f] Merge branch 'dunlap' (Randy's Documentation patches)
git bisect good a9d38a4f2da6c49a257253a9fdef7a6bcb0e0e4f
# bad: [c39e8ede284f469971589f2e04af78216e1a771d] Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect bad c39e8ede284f469971589f2e04af78216e1a771d
# bad: [73f05330497b98c45d157b7d0c60673798bb4c3b] Merge branch 'apei' into release
git bisect bad 73f05330497b98c45d157b7d0c60673798bb4c3b
# good: [5aa3c16c6b196857ea24ec1c589e3db3c4c64c96] ACPICA: Update to version 20120320
git bisect good 5aa3c16c6b196857ea24ec1c589e3db3c4c64c96
# good: [02401c06b7f6bec65f314e3cec7894502c973501] cpuidle: power_usage should be declared signed integer
git bisect good 02401c06b7f6bec65f314e3cec7894502c973501
# good: [344e222edf486bf42da1ced137e36df7a345b0ad] ACPI throttling: fix endian bug in acpi_read_throttling_status()
git bisect good 344e222edf486bf42da1ced137e36df7a345b0ad
# bad: [1a05e4678724c4a5fe7b9e4e208b616dfe8c3a32] Merge branches 'acpica', 'bgrt', 'bz-11533', 'cpuidle', 'ec', 'hotplug', 'misc', 'red-hat-bz-727865', 'thermal', 'throttling', 'turbostat' and 'video' into release
git bisect bad 1a05e4678724c4a5fe7b9e4e208b616dfe8c3a32
# good: [37239978778806ecba54da60676abb46870acebb] ACPI: Clean redundant codes in scan.c
git bisect good 37239978778806ecba54da60676abb46870acebb
# good: [15aaa34654831e98dd76f7738b6c7f5d05a66430] tools turbostat: harden against cpu online/offline
git bisect good 15aaa34654831e98dd76f7738b6c7f5d05a66430
# good: [6fe0d0628245fdcd6fad8b837c81e8f7ebc3364d] ACPI: Make ACPI interrupt threaded
git bisect good 6fe0d0628245fdcd6fad8b837c81e8f7ebc3364d
# good: [d1ff4b1cdbabb9ab9813f3d6e1cbec42cc5d6ed8] ACPI: Add support for exposing BGRT data
git bisect good d1ff4b1cdbabb9ab9813f3d6e1cbec42cc5d6ed8
# bad: [b60e7f6166857c76871977794fa266b02da1f394] ACPI video: Don't start video device until its associated input device has been allocated
git bisect bad b60e7f6166857c76871977794fa266b02da1f394
# bad: [ea9f8856bd6d4ed45885b06a338f7362cd6c60e5] ACPI video: Harden video bus adding.
git bisect bad ea9f8856bd6d4ed45885b06a338f7362cd6c60e5

--------------090103010701070007060903
Content-Type: text/plain;
 name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=".config"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.3.0.bisect25 Kernel Configuration
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_FHANDLE=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_INLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=y
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=y
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=y
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_SMP=y
# CONFIG_X86_X2APIC is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=7
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=512
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=m
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CLEANCACHE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=m
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IPGRE=m
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_ZONES=y
# CONFIG_NF_CONNTRACK_PROCFS is not set
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
# CONFIG_IP_NF_MATCH_RPFILTER is not set
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
# CONFIG_IP_NF_TARGET_LOG is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
# CONFIG_IP6_NF_QUEUE is not set
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
# CONFIG_IP6_NF_MATCH_RPFILTER is not set
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
# CONFIG_IP6_NF_TARGET_LOG is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
CONFIG_RDS=m
CONFIG_RDS_TCP=m
# CONFIG_RDS_DEBUG is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=m
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y
CONFIG_HAVE_BPF_JIT=y
CONFIG_BPF_JIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
# CONFIG_DMA_SHARED_BUFFER is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085 is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_CB710_CORE is not set
# CONFIG_IWMC3200TOP is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
# CONFIG_DUMMY is not set
CONFIG_EQUALIZER=m
CONFIG_NET_FC=y
CONFIG_MII=m
# CONFIG_NET_TEAM is not set
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=m
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=m
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=m
CONFIG_PPTP=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_TR is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_IPHETH is not set
CONFIG_WLAN=y
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_ATH_COMMON is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMFMAC is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLWIFI=m

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
# CONFIG_IWLWIFI_P2P is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWM is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_WL1251 is not set
# CONFIG_WL12XX_MENU is not set
# CONFIG_ZD1211RW is not set
# CONFIG_MWIFIEX is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
# CONFIG_I2C_EG20T is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=m
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
# CONFIG_SENSORS_MAX34440 is not set
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_UCD9000 is not set
# CONFIG_SENSORS_UCD9200 is not set
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_S5M_CORE is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_LPC_SCH=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
# CONFIG_RC_CORE is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# MPEG video encoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#
# CONFIG_VIDEO_VIVI is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
# CONFIG_USB_GSPCA is not set
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_PWC is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
CONFIG_V4L_PCI_DRIVERS=y
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_ZORAN is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_VIDEO_TIMBERDALE is not set
# CONFIG_SOC_CAMERA is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_ENABLE_REALTEK_QUIRKS=y
# CONFIG_SND_HDA_CODEC_ANALOG is not set
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
# CONFIG_SND_HDA_CODEC_VIA is not set
CONFIG_SND_HDA_CODEC_HDMI=y
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CA0110 is not set
# CONFIG_SND_HDA_CODEC_CA0132 is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_EHCI_MV is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_STORAGE_ENE_UB6250=m
CONFIG_USB_UAS=m
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_DELL_NETBOOKS=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_TIMB_DMA is not set
CONFIG_PCH_DMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_COMEDI is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_R8712U is not set
# CONFIG_RTS_PSTOR is not set
# CONFIG_RTS5139 is not set
# CONFIG_TRANZPORT is not set
# CONFIG_LINE6_USB is not set
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_VME_BUS is not set
# CONFIG_DX_SEP is not set
# CONFIG_IIO is not set
# CONFIG_XVMALLOC is not set
# CONFIG_ZRAM is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_USB_ENESTORAGE is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_INTEL_MEI=m
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_AIO=m
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=m
CONFIG_MSI_WMI=m
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=m
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=m
CONFIG_INTEL_OAKTRAIL=m
# CONFIG_SAMSUNG_Q10 is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EXOFS_FS is not set
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_OBJLAYOUT=m
CONFIG_NFS_FSCACHE=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
# CONFIG_NFSD is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_FSCACHE=y
CONFIG_CIFS_ACL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
# CONFIG_EVENT_POWER_TRACING_DEPRECATED is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_KPROBE_EVENT is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_INTEL_TXT is not set
CONFIG_SECURITY_TOMOYO=y
CONFIG_SECURITY_TOMOYO_MAX_ACCEPT_ENTRY=2048
CONFIG_SECURITY_TOMOYO_MAX_AUDIT_LOG=1024
# CONFIG_SECURITY_TOMOYO_OMIT_USERSPACE_LOADER is not set
CONFIG_SECURITY_TOMOYO_POLICY_LOADER="/sbin/tomoyo-init"
CONFIG_SECURITY_TOMOYO_ACTIVATION_TRIGGER="/sbin/init"
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
# CONFIG_VHOST_NET is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set

--------------090103010701070007060903
Content-Type: text/plain;
 name="cpuinfo"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cpuinfo"

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping	: 7
microcode	: 0x28
cpu MHz		: 800.000
cache size	: 6144 KB
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4389.99
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping	: 7
microcode	: 0x28
cpu MHz		: 800.000
cache size	: 6144 KB
physical id	: 0
siblings	: 8
core id		: 0
cpu cores	: 4
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4389.99
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping	: 7
microcode	: 0x28
cpu MHz		: 800.000
cache size	: 6144 KB
physical id	: 0
siblings	: 8
core id		: 1
cpu cores	: 4
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4389.99
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping	: 7
microcode	: 0x28
cpu MHz		: 800.000
cache size	: 6144 KB
physical id	: 0
siblings	: 8
core id		: 1
cpu cores	: 4
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4389.99
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 4
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping	: 7
microcode	: 0x28
cpu MHz		: 800.000
cache size	: 6144 KB
physical id	: 0
siblings	: 8
core id		: 2
cpu cores	: 4
apicid		: 4
initial apicid	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4389.99
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 5
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping	: 7
microcode	: 0x28
cpu MHz		: 800.000
cache size	: 6144 KB
physical id	: 0
siblings	: 8
core id		: 2
cpu cores	: 4
apicid		: 5
initial apicid	: 5
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4389.99
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 6
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping	: 7
microcode	: 0x28
cpu MHz		: 2201.000
cache size	: 6144 KB
physical id	: 0
siblings	: 8
core id		: 3
cpu cores	: 4
apicid		: 6
initial apicid	: 6
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4389.99
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 7
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping	: 7
microcode	: 0x28
cpu MHz		: 800.000
cache size	: 6144 KB
physical id	: 0
siblings	: 8
core id		: 3
cpu cores	: 4
apicid		: 7
initial apicid	: 7
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4389.99
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


--------------090103010701070007060903
Content-Type: text/plain;
 name="modules"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="modules"

microcode 25639 0 - Live 0xffffffffa046a000
acpi_cpufreq 12893 0 - Live 0xffffffffa0465000
mperf 12411 1 acpi_cpufreq, Live 0xffffffffa0460000
cpufreq_conservative 13143 0 - Live 0xffffffffa045b000
cpufreq_stats 12894 0 - Live 0xffffffffa0456000
cpufreq_powersave 12454 0 - Live 0xffffffffa044a000
bnep 17574 2 - Live 0xffffffffa0450000
rfcomm 41940 10 - Live 0xffffffffa043e000
binfmt_misc 17058 1 - Live 0xffffffffa0430000
uinput 17497 1 - Live 0xffffffffa0438000
fuse 75132 1 - Live 0xffffffffa041c000
loop 26770 0 - Live 0xffffffffa0410000
btusb 17296 2 - Live 0xffffffffa03c0000
bluetooth 178610 23 bnep,rfcomm,btusb, Live 0xffffffffa03e3000
uvcvideo 71728 0 - Live 0xffffffffa03d0000
videobuf2_vmalloc 12620 1 uvcvideo, Live 0xffffffffa0339000
videobuf2_memops 12526 1 videobuf2_vmalloc, Live 0xffffffffa01cf000
videobuf2_core 30156 1 uvcvideo, Live 0xffffffffa03c7000
videodev 83396 1 uvcvideo, Live 0xffffffffa03aa000
v4l2_compat_ioctl32 16928 1 videodev, Live 0xffffffffa02ba000
media 18214 2 uvcvideo,videodev, Live 0xffffffffa01fa000
usbhid 44712 0 - Live 0xffffffffa032d000
hid 93864 1 usbhid, Live 0xffffffffa0392000
snd_hda_codec_hdmi 31064 1 - Live 0xffffffffa0324000
snd_hda_codec_realtek 118060 1 - Live 0xffffffffa0374000
arc4 12458 2 - Live 0xffffffffa01c5000
iwlwifi 206162 0 - Live 0xffffffffa0340000
mac80211 395970 1 iwlwifi, Live 0xffffffffa02c2000
cfg80211 179668 2 iwlwifi,mac80211, Live 0xffffffffa0289000
sr_mod 22024 0 - Live 0xffffffffa026b000
cdrom 40503 1 sr_mod, Live 0xffffffffa027e000
snd_hda_intel 30767 3 - Live 0xffffffffa0275000
snd_hda_codec 99488 3 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live 0xffffffffa0251000
snd_hwdep 13214 1 snd_hda_codec, Live 0xffffffffa01b1000
snd_pcm 76070 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 0xffffffffa023d000
snd_page_alloc 17153 2 snd_hda_intel,snd_pcm, Live 0xffffffffa01ab000
xhci_hcd 86957 0 - Live 0xffffffffa0226000
snd_seq 53273 0 - Live 0xffffffffa01eb000
snd_seq_device 13175 1 snd_seq, Live 0xffffffffa01a6000
snd_timer 27226 2 snd_pcm,snd_seq, Live 0xffffffffa016c000
iTCO_wdt 17136 0 - Live 0xffffffffa01b9000
ehci_hcd 49121 0 - Live 0xffffffffa01de000
dell_laptop 17120 0 - Live 0xffffffffa0185000
dell_wmi 12477 0 - Live 0xffffffffa015e000
usbcore 141026 5 btusb,uvcvideo,usbhid,xhci_hcd,ehci_hcd, Live 0xffffffffa0202000
rfkill 18830 5 bluetooth,cfg80211,dell_laptop, Live 0xffffffffa019c000
r8169 55623 0 - Live 0xffffffffa018d000
snd 61324 15 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq,snd_seq_device,snd_timer, Live 0xffffffffa0175000
psmouse 65175 0 - Live 0xffffffffa014d000
mii 12722 1 r8169, Live 0xffffffffa0148000
sparse_keymap 12760 1 dell_wmi, Live 0xffffffffa01d4000
processor 28834 1 acpi_cpufreq, Live 0xffffffffa0163000
usb_common 12313 1 usbcore, Live 0xffffffffa01ca000
ac 12624 0 - Live 0xffffffffa01c0000
battery 13109 0 - Live 0xffffffffa0138000
serio_raw 12845 0 - Live 0xffffffffa0133000
soundcore 13070 1 snd, Live 0xffffffffa0118000
mei 40540 0 - Live 0xffffffffa013d000 (C)
dcdbas 13359 1 dell_laptop, Live 0xffffffffa0113000
evdev 17499 27 - Live 0xffffffffa012d000
iTCO_vendor_support 12649 1 iTCO_wdt, Live 0xffffffffa0128000
wmi 17525 1 dell_wmi, Live 0xffffffffa010d000
i2c_i801 17118 0 - Live 0xffffffffa0103000
power_supply 13676 4 hid,dell_laptop,ac,battery, Live 0xffffffffa011f000
ext4 421038 1 - Live 0xffffffffa009b000
crc16 12313 2 bluetooth,ext4, Live 0xffffffffa004f000
jbd2 74141 1 ext4, Live 0xffffffffa0087000
mbcache 12985 1 ext4, Live 0xffffffffa000e000
sd_mod 44248 4 - Live 0xffffffffa007b000
crc_t10dif 12313 1 sd_mod, Live 0xffffffffa004a000
ahci 25145 4 - Live 0xffffffffa0006000
libahci 22985 1 ahci, Live 0xffffffffa0043000
libata 146794 2 ahci,libahci, Live 0xffffffffa0054000
scsi_mod 179793 3 sr_mod,sd_mod,libata, Live 0xffffffffa0016000
thermal 17488 0 - Live 0xffffffffa0000000

--------------090103010701070007060903
Content-Type: text/plain;
 name="ioports"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ioports"

0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : EC cmd
  0070-0077 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  03c0-03df : vga+
  0400-0453 : pnp 00:04
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-042f : ACPI GPE0_BLK
    0430-0433 : iTCO_wdt
    0450-0450 : ACPI PM2_CNT_BLK
  0454-0457 : pnp 00:06
  0458-047f : pnp 00:04
    0460-047f : iTCO_wdt
  0500-057f : pnp 00:04
  0680-069f : pnp 00:04
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-1003 : pnp 00:04
  1004-1013 : pnp 00:04
  164e-164f : pnp 00:04
  2000-2fff : PCI Bus 0000:0a
    2000-20ff : 0000:0a:00.0
      2000-20ff : r8169
  3000-3fff : PCI Bus 0000:05
  4000-4fff : PCI Bus 0000:01
    4000-407f : 0000:01:00.0
  5000-503f : 0000:00:02.0
  5060-507f : 0000:00:1f.2
    5060-507f : ahci
  5080-5087 : 0000:00:1f.2
    5080-5087 : ahci
  5088-508f : 0000:00:1f.2
    5088-508f : ahci
  5090-5093 : 0000:00:1f.2
    5090-5093 : ahci
  5094-5097 : 0000:00:1f.2
    5094-5097 : ahci
  efa0-efbf : 0000:00:1f.3
  ffff-ffff : pnp 00:04

--------------090103010701070007060903
Content-Type: text/plain;
 name="iomem"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iomem"

00000000-0000ffff : reserved
00010000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cefff : Video ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-bac8efff : System RAM
  01000000-014038fe : Kernel code
  014038ff-0187d2ff : Kernel data
  018f9000-019cbfff : Kernel bss
bac8f000-bade1fff : reserved
bade2000-bade9fff : ACPI Non-volatile Storage
badea000-baf1efff : reserved
baf1f000-baf9efff : ACPI Non-volatile Storage
baf9f000-baffefff : ACPI Tables
bafff000-baffffff : System RAM
bb000000-bf9fffff : reserved
bfa00000-feafffff : PCI Bus 0000:00
  c0000000-d3ffffff : PCI Bus 0000:01
    c0000000-cfffffff : 0000:01:00.0
    d0000000-d3ffffff : 0000:01:00.0
  e0000000-efffffff : 0000:00:02.0
  f0000000-f20fffff : PCI Bus 0000:01
    f0000000-f1ffffff : 0000:01:00.0
    f2000000-f207ffff : 0000:01:00.0
  f2400000-f27fffff : 0000:00:02.0
  f2800000-f2ffffff : PCI Bus 0000:05
  f3000000-f30fffff : PCI Bus 0000:0a
    f3000000-f3003fff : 0000:0a:00.0
      f3000000-f3003fff : r8169
    f3004000-f3004fff : 0000:0a:00.0
      f3004000-f3004fff : r8169
  f3100000-f39fffff : PCI Bus 0000:05
  f3a00000-f3afffff : PCI Bus 0000:04
    f3a00000-f3a01fff : 0000:04:00.0
      f3a00000-f3a01fff : xhci_hcd
  f3b00000-f3bfffff : PCI Bus 0000:03
    f3b00000-f3b01fff : 0000:03:00.0
      f3b00000-f3b01fff : iwlwifi
  f3c00000-f3c03fff : 0000:00:1b.0
    f3c00000-f3c03fff : ICH HD audio
  f3c04000-f3c040ff : 0000:00:1f.3
  f3c05000-f3c0500f : 0000:00:16.0
    f3c05000-f3c0500f : mei
  f3c08000-f3c087ff : 0000:00:1f.2
    f3c08000-f3c087ff : ahci
  f3c09000-f3c093ff : 0000:00:1d.0
    f3c09000-f3c093ff : ehci_hcd
  f3c0a000-f3c0a3ff : 0000:00:1a.0
    f3c0a000-f3c0a3ff : ehci_hcd
  f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
    f8000000-fbffffff : reserved
      f8000000-fbffffff : pnp 00:09
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fed08000-fed08fff : reserved
fed10000-fed19fff : reserved
  fed10000-fed17fff : pnp 00:09
  fed18000-fed18fff : pnp 00:09
  fed19000-fed19fff : pnp 00:09
fed1c000-fed1ffff : reserved
  fed1c000-fed1ffff : pnp 00:09
fed20000-fed3ffff : pnp 00:09
fed40000-fed44fff : PCI Bus 0000:00
fed45000-fed8ffff : pnp 00:09
fed90000-fed93fff : pnp 00:09
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ffd80000-ffffffff : reserved
100000000-23e9fefff : System RAM
23e9ff000-23fdfffff : reserved
23fe00000-23fffffff : RAM buffer

--------------090103010701070007060903
Content-Type: text/plain;
 name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lspci"

00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
	Subsystem: Dell Device 0571
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel driver in use: agpgart-intel

00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port (rev 09) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: f0000000-f20fffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000d3ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [88] Subsystem: Intel Corporation Device 2010
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: feeff00c  Data: 4161
	Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance+ ComplianceSOS-
			 Compliance De-emphasis: -3.5dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [140 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=01 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=01 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed19000
	Kernel driver in use: pcieport

00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09) (prog-if 00 [VGA controller])
	Subsystem: Dell Device 0571
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 41
	Region 0: Memory at f2400000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 5000 [size=64]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: feeff00c  Data: 4169
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a4] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: i915

00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
	Subsystem: Dell Device 0571
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 43
	Region 0: Memory at f3c05000 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000feeff00c  Data: 4181
	Kernel driver in use: mei

00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 05) (prog-if 20 [EHCI])
	Subsystem: Dell Device 0571
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f3c0a000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 05)
	Subsystem: Dell Device 0571
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 53
	Region 0: Memory at f3c00000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000feeff00c  Data: 412a
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=22
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Device 0571
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f3b00000-f3bfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Device 0571
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f3a00000-f3afffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Device 0571
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 5 (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=05, subordinate=09, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: f3100000-f39fffff
	Prefetchable memory behind bridge: 00000000f2800000-00000000f2ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #5, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #4, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Device 0571
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1c.5 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 6 (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000f3000000-00000000f30fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #6, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #5, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Device 0571
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 05) (prog-if 20 [EHCI])
	Subsystem: Dell Device 0571
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at f3c09000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP+
	Kernel driver in use: ehci_hcd

00:1f.0 ISA bridge: Intel Corporation HM67 Express Chipset Family LPC Controller (rev 05)
	Subsystem: Dell Device 0571
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 05) (prog-if 01 [AHCI 1.0])
	Subsystem: Dell Device 0571
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 42
	Region 0: I/O ports at 5088 [size=8]
	Region 1: I/O ports at 5094 [size=4]
	Region 2: I/O ports at 5080 [size=8]
	Region 3: I/O ports at 5090 [size=4]
	Region 4: I/O ports at 5060 [size=32]
	Region 5: Memory at f3c08000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: feeff00c  Data: 4171
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
	Subsystem: Dell Device 0571
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at f3c04000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at efa0 [size=32]

01:00.0 VGA compatible controller: NVIDIA Corporation Device 124d (rev a1) (prog-if 00 [VGA controller])
	Subsystem: Dell Device 0571
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f0000000 (32-bit, non-prefetchable) [size=32M]
	Region 1: Memory at c0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at d0000000 (64-bit, prefetchable) [size=64M]
	Region 5: I/O ports at 4000 [disabled] [size=128]
	Expansion ROM at f2000000 [disabled] [size=512K]
	Capabilities: [60] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x16, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [b4] Vendor Specific Information: Len=14 <?>
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [128 v1] Power Budgeting <?>
	Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1 Len=024 <?>

03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6230 (rev 34)
	Subsystem: Intel Corporation Centrino Advanced-N 6230 AGN
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 54
	Region 0: Memory at f3b00000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000feeff00c  Data: 4142
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <32us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number 88-53-2e-ff-ff-93-1c-91
	Kernel driver in use: iwlwifi

04:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04) (prog-if 30 [XHCI])
	Subsystem: Dell Device 04b8
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at f3a00000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] MSI: Enable- Count=1/8 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [90] MSI-X: Enable+ Count=8 Masked-
		Vector table: BAR=0 offset=00001000
		PBA: BAR=0 offset=00001080
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 unlimited
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number ff-ff-ff-ff-ff-ff-ff-ff
	Capabilities: [150 v1] Latency Tolerance Reporting
		Max snoop latency: 0ns
		Max no snoop latency: 0ns
	Kernel driver in use: xhci_hcd

0a:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
	Subsystem: Dell Device 0570
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 44
	Region 0: I/O ports at 2000 [size=256]
	Region 2: Memory at f3004000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at f3000000 (64-bit, prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000feeff00c  Data: 4189
	Capabilities: [70] Express (v2) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [d0] Vital Product Data
		Unknown small resource type 00, will not decode more.
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 7b-06-00-00-68-4c-e0-00
	Kernel driver in use: r8169


--------------090103010701070007060903--
