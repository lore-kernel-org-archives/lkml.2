Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab2FNOsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:48:46 -0400
Received: from hera.cwi.nl ([192.16.191.8]:52473 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab2FNOsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:48:38 -0400
Message-ID: <4FD9F9B0.9030204@cwi.nl>
Date: Thu, 14 Jun 2012 15:48:16 +0100
From: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Dave Airlie <airlied@gmail.com>,
        "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>,
        intergalactic.anonymous@gmail.com, len.brown@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Barnes, Jesse" <jbarnes@virtuousgeek.org>,
        "Wilson, Chris" <chris.wilson@intel.com>
Subject: Re: [3.4 regression] [bisected] DisplayPort fails to come on
References: <4FD9E69A.4090708@cwi.nl> <CAPM=9tzL-TyDLKWdmCdi5d6PzQTs3sTLnqnLG_s7K2h9WNOEvQ@mail.gmail.com> <CAKMK7uGokt5cW0R+LKXRmE_kecqmnv4Zgy-WiSZA-GPP8htE-A@mail.gmail.com>
In-Reply-To: <CAKMK7uGokt5cW0R+LKXRmE_kecqmnv4Zgy-WiSZA-GPP8htE-A@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080302020805010102020801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080302020805010102020801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 06/14/2012 03:05 PM, Daniel Vetter wrote:
> Can you please boot with drm.debug=0xe added to your kernel
> cmdline and attach the full dmesg, so we know a bit what your display
> hw looks like?
Please find attached dmesg output with drm.debug=0xe.

3.3.8 is the baseline, on which the display port monitor works fine.
3.4.2.cold is a cold boot into 3.4.2. The monitor on the display port 
remains blank. That is, it displays "No Signal Input" and then enters 
power saving mode.
3.4.2 is a reboot after running 3.3.8 first. Now the monitor attached to 
the display port works too.

The main difference between 3.4.2 and 3.4.2.cold seems to be that a warm 
boot reports "clock recovery OK", whereas a cold boot fails trying to 
train the link.

I did have a look at the (many) differences between 3.3.8 and 3.4.2, but 
I can't see anything that looks important. I will happily leave further 
interpretation to you.

I hope this will give someone an idea. In the mean while I will redo the 
bisect.

With kind regards,

Wouter

--------------080302020805010102020801
Content-Type: text/plain;
 name="3.3.8"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="3.3.8"

Initializing cgroup subsys cpu
Linux version 3.3.8.git (root@wensxps) (gcc version 4.6.3 (Debian 4.6.3-1) ) #42 SMP Wed Jun 6 17:12:38 BST 2012
Command line: BOOT_IMAGE=/boot/vmlinuz-3.3.8.git root=UUID=39c0ed04-fbf1-43b0-8e7a-09e446a8bea6 ro drm.debug=0xe
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
RAMDISK: 37aec000 - 37d6e000
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
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.3.8.git root=UUID=39c0ed04-fbf1-43b0-8e7a-09e446a8bea6 ro drm.debug=0xe
PID hash table entries: 4096 (order: 3, 32768 bytes)
xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
Memory: 8085788k/9414652k available (4110k kernel code, 1134476k absent, 194388k reserved, 4571k data, 468k init)
Hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
NR_IRQS:33024 nr_irqs:744 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2195.009 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4390.01 BogoMIPS (lpj=8780036)
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
Total of 8 processors activated (35120.14 BogoMIPS).
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
Freeing initrd memory: 2568k freed
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
[drm:intel_opregion_setup], graphic opregion physical addr: 0xbaf27018
[drm:intel_opregion_setup], Public ACPI methods supported
[drm:intel_opregion_setup], SWSCI supported
[drm:intel_opregion_setup], ASLE supported
i915 0000:00:02.0: irq 41 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
[drm:intel_detect_pch], Found CougarPoint PCH
[drm:init_vbt_defaults], Set default to SSC at 100MHz
[drm:intel_parse_bios], Using VBT from OpRegion: $VBT SANDYBRIDGE-M  d
[drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 0 int_crt_support 1 lvds_use_ssc 0 lvds_ssc_freq 120 display_clock_mode 0
[drm:parse_general_definitions], crt_ddc_bus_pin: 2
[drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1080" 0 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x8 0xa
[drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[drm:intel_dsm_detect], VGA switcheroo: detected DSM switching method \_SB_.PCI0.PEG0.PEGP handle
[drm:intel_modeset_init], 2 display pipes available.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
[drm:intel_panel_get_backlight], get backlight PWM = 4648
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_get_backlight], get backlight PWM = 4648
[drm:intel_crt_init], pch crt adpa set to 0xf40000
[drm:intel_dp_i2c_init], i2c_init DPDDC-C
[drm:intel_panel_actually_set_backlight], set backlight PWM = 0
[drm:ironlake_crtc_dpms], crtc 0/0 dpms off
[drm:i915_get_vblank_timestamp], crtc 0 is disabled
[drm:intel_update_fbc], 
[drm:intel_update_fbc], no output, disabling
[drm:ironlake_crtc_dpms], crtc 1/1 dpms off
[drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe B
[drm:i915_get_vblank_timestamp], crtc 1 is disabled
[drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe B
[drm:intel_update_fbc], 
[drm:intel_update_fbc], no output, disabling
[drm:ironlake_init_pch_refclk], has_panel 1 has_lvds 1 has_pch_edp 0 has_cpu_edp 0 has_ck505 0
[drm:intel_enable_rc6], Sandybridge: RC6 disabled
[drm:init_status_page], render ring hws offset: 0x00000000
[drm:init_status_page], gen6 bsd ring hws offset: 0x00022000
[drm:init_status_page], blt ring hws offset: 0x00043000
[drm:i915_setup_compression], FBC base 0xfc000000, ll base 0x00000000, size 32M
[drm:intel_panel_actually_set_backlight], set backlight PWM = 0
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], trigger hotplug detect cycle: adpa=0xf40000
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_setup_crtcs], 
[drm:drm_enable_connectors], connector 7 enabled? yes
[drm:drm_enable_connectors], connector 14 enabled? no
[drm:drm_enable_connectors], connector 17 enabled? no
[drm:drm_enable_connectors], connector 20 enabled? yes
[drm:drm_target_preferred], looking for cmdline mode on connector 7
[drm:drm_target_preferred], looking for preferred mode on connector 7
[drm:drm_target_preferred], found mode 1920x1080
[drm:drm_target_preferred], looking for cmdline mode on connector 20
[drm:drm_target_preferred], looking for preferred mode on connector 20
[drm:drm_target_preferred], found mode 1280x1024
[drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[drm:drm_setup_crtcs], desired mode 1920x1080 set on crtc 3
[drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 5
[drm:intelfb_create], allocated 1920x1080 fb: 0x00064000, bo ffff88023448cc00
fbcon: inteldrmfb (fb0) is primary device
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_crtc_helper_set_mode], [CRTC:3]
[drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to LVDS (6)
[drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 6)
[drm:ironlake_crtc_mode_set], Mode for pipe 0:
[drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:ironlake_update_plane], Writing base 00064000 00000000 0 0 7680
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:ironlake_check_srwm], watermark 1: display plane 16, fbc lines 3, cursor 6
[drm:ironlake_check_srwm], watermark 2: display plane 20, fbc lines 3, cursor 6
[drm:ironlake_check_srwm], watermark 3: display plane 99, fbc lines 3, cursor 6
[drm:drm_crtc_helper_set_mode], [ENCODER:8:LVDS-8] set [MODE:11:1920x1080]
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:ironlake_check_srwm], watermark 1: display plane 16, fbc lines 3, cursor 6
[drm:ironlake_check_srwm], watermark 2: display plane 20, fbc lines 3, cursor 6
[drm:ironlake_check_srwm], watermark 3: display plane 99, fbc lines 3, cursor 6
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x700
[drm:gen6_fdi_link_train], FDI train 1 done.
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[drm:gen6_fdi_link_train], FDI train 2 done.
[drm:gen6_fdi_link_train], FDI train done.
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config], 	[CONNECTOR:7:LVDS-1] set DPMS on
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[drm:drm_mode_debug_printmodeline], Modeline 22:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 22:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:intel_dp_mode_fixup], Display port link bw 06 lane count 2 clock 162000
[drm:drm_crtc_helper_set_mode], [CRTC:5]
[drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 8)
[drm:ironlake_crtc_mode_set], Mode for pipe 1:
[drm:drm_mode_debug_printmodeline], Modeline 22:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:ironlake_update_plane], Writing base 00064000 00000000 0 0 7680
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:drm_crtc_helper_set_mode], [ENCODER:21:TMDS-21] set [MODE:22:1280x1024]
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
Refined TSC clocksource calibration: 2195.014 MHz.
Switching to clocksource tsc
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[drm:gen6_fdi_link_train], FDI train 1 done.
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[drm:gen6_fdi_link_train], FDI train 2 done.
[drm:gen6_fdi_link_train], FDI train done.
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], clock recovery OK
[drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config], 	[CONNECTOR:20:DP-1] set DPMS on
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
Console: switching to colour frame buffer device 160x64
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
acpi device:2f: registered as cooling_device0
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2c/LNXVIDEO:00/input/input4
ACPI: Video Device [PEGP] (multi-head: yes  rom: yes  post: no)
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
acpi device:31: registered as cooling_device1
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input5
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
rtc_cmos 00:05: setting system clock to 2012-06-14 14:23:26 UTC (1339683806)
Initializing network drop monitor service
Freeing unused kernel memory: 468k freed
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 2012k freed
Freeing unused kernel memory: 744k freed
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input6
udevd[74]: starting version 175
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (53 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [TZ01] (53 C)
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
udevd[320]: starting version 175
ACPI Warning: 0x000000000000efa0-0x000000000000efbf SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120111/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
mei: module is from the staging directory, the quality is unknown, you have been warned.
mei 0000:00:16.0: setting latency timer to 64
mei 0000:00:16.0: irq 43 for MSI/MSI-X
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
input: PC Speaker as /devices/platform/pcspkr/input/input7
iTCO_vendor_support: vendor-support=0
cfg80211: Calling CRDA to update world regulatory domain
ACPI: AC Adapter [ADP0] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
wmi: Mapper loaded
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:0a:00.0: irq 44 for MSI/MSI-X
r8169 0000:0a:00.0: eth0: RTL8168e/8111e at 0xffffc900057fc000, 84:8f:69:c4:09:63, XID 0c200000 IRQ 44
r8169 0000:0a:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 5:0:0:0: Attached scsi CD-ROM sr0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.0: setting latency timer to 64
ehci_hcd 0000:00:1a.0: EHCI Host Controller
ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.0: debug port 2
ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf3c0a000
ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.3.8.git ehci_hcd
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
usb usb2: Manufacturer: Linux 3.3.8.git ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
input: Dell WMI hotkeys as /devices/virtual/input/input8
Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
Copyright(c) 2003-2011 Intel Corporation
iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
iwlwifi 0000:03:00.0: pci_resource_base = ffffc900057e4000
iwlwifi 0000:03:00.0: HW Revision ID = 0x34
iwlwifi 0000:03:00.0: irq 45 for MSI/MSI-X
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6230 AGN, REV=0xB0
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
xhci_hcd 0000:04:00.0: xHCI Host Controller
xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 3
xhci_hcd 0000:04:00.0: irq 19, io mem 0xf3a00000
xhci_hcd 0000:04:00.0: irq 46 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 48 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 49 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 50 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 51 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 52 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 53 for MSI/MSI-X
usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: xHCI Host Controller
iwlwifi 0000:03:00.0: device EEPROM VER=0x716, CALIB=0x6
iwlwifi 0000:03:00.0: Device SKU: 0x1F0
iwlwifi 0000:03:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
usb usb3: Manufacturer: Linux 3.3.8.git xhci_hcd
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
usb usb4: Manufacturer: Linux 3.3.8.git xhci_hcd
usb usb4: SerialNumber: 0000:04:00.0
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
snd_hda_intel 0000:00:1b.0: irq 54 for MSI/MSI-X
usb 1-1: new high-speed USB device number 2 using ehci_hcd
usb 1-1: New USB device found, idVendor=8087, idProduct=0024
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 6 ports detected
iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1
Registered led device: phy0-led
usb 2-1: new high-speed USB device number 2 using ehci_hcd
ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
usb 2-1: New USB device found, idVendor=8087, idProduct=0024
usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 8 ports detected
usb 3-1: new low-speed USB device number 2 using xhci_hcd
usb 3-1: New USB device found, idVendor=045e, idProduct=0040
usb 3-1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
usb 3-1: Product: Microsoft 3-Button Mouse with IntelliEye(TM)
usb 3-1: Manufacturer: Microsoft
usb 3-1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
psmouse serio1: synaptics: Touchpad model: 1, fw: 7.4, id: 0x1e0b1, caps: 0xd04773/0xa40000/0x8a0400
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input9
usb 3-2: new low-speed USB device number 3 using xhci_hcd
hda_codec: ALC665: SKU not ready 0x598301f0
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input10
usb 3-2: New USB device found, idVendor=0a81, idProduct=0205
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: PS2 to USB Converter
usb 3-2: Manufacturer: CHESEN
usb 3-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
usb 3-2: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
HDMI status: Codec=3 Pin=6 Presence_Detect=0 ELD_Valid=0
input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
usb 1-1.4: new high-speed USB device number 3 using ehci_hcd
input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1c.3/0000:04:00.0/usb3/3-1/3-1:1.0/input/input15
generic-usb 0003:045E:0040.0001: input,hidraw0: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:04:00.0-1/input0
usb 1-1.4: New USB device found, idVendor=0408, idProduct=2fb1
usb 1-1.4: New USB device strings: Mfr=3, Product=2, SerialNumber=0
usb 1-1.4: Product: Laptop_Integrated_Webcam_2HDM
usb 1-1.4: Manufacturer: CN07CN2C7866421A1605A00
input: CHESEN PS2 to USB Converter as /devices/pci0000:00/0000:00:1c.3/0000:04:00.0/usb3/3-2/3-2:1.0/input/input16
generic-usb 0003:0A81:0205.0002: input,hidraw1: USB HID v1.10 Keyboard [CHESEN PS2 to USB Converter] on usb-0000:04:00.0-2/input0
input: CHESEN PS2 to USB Converter as /devices/pci0000:00/0000:00:1c.3/0000:04:00.0/usb3/3-2/3-2:1.1/input/input17
generic-usb 0003:0A81:0205.0003: input,hidraw2: USB HID v1.10 Mouse [CHESEN PS2 to USB Converter] on usb-0000:04:00.0-2/input1
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usb 2-1.5: new full-speed USB device number 3 using ehci_hcd
Linux media interface: v0.10
Linux video capture interface: v2.00
uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_2HDM (0408:2fb1)
uvcvideo: No streaming interface found for terminal 6.
input: Laptop_Integrated_Webcam_2HDM as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input18
usbcore: registered new interface driver uvcvideo
USB Video Class driver (1.1.1)
usb 2-1.5: New USB device found, idVendor=8086, idProduct=0189
usb 2-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
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
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:14:VGA-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:17:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:output_poll_execute], [CONNECTOR:20:DP-1] status updated from 1 to 1
fuse init (API version 7.18)
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
ADDRCONF(NETDEV_UP): wlan0: link is not ready
r8169 0000:0a:00.0: eth0: link down
r8169 0000:0a:00.0: eth0: link down
ADDRCONF(NETDEV_UP): eth0: link is not ready
input: ACPI Virtual Keyboard Device as /devices/virtual/input/input19
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:i915_driver_open], 
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:i915_driver_open], 
[drm:i915_getparam], Unknown parameter 17
[drm:drm_mode_getresources], CRTC[2] CONNECTORS[4] ENCODERS[4]
[drm:drm_mode_getresources], CRTC[2] CONNECTORS[4] ENCODERS[4]
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:drm_mode_addfb], [FB:25]
[drm:drm_mode_setcrtc], [CRTC:3]
[drm:drm_mode_setcrtc], [CONNECTOR:7:LVDS-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:25] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 26:"1280x1024" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 26:"1280x1024" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm:drm_crtc_helper_set_mode], [CRTC:3]
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to LVDS (6)
[drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 6)
[drm:ironlake_crtc_mode_set], Mode for pipe 0:
[drm:drm_mode_debug_printmodeline], Modeline 26:"1280x1024" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm] Changing LVDS panel from (-hsync, -vsync) to (+hsync, +vsync)
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:ironlake_update_plane], Writing base 0084D000 00000000 0 0 5120
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:drm_crtc_helper_set_mode], [ENCODER:8:LVDS-8] set [MODE:26:1280x1024]
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[drm:gen6_fdi_link_train], FDI train 1 done.
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[drm:gen6_fdi_link_train], FDI train 2 done.
[drm:gen6_fdi_link_train], FDI train done.
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config], 	[CONNECTOR:7:LVDS-1] set DPMS on
[drm:drm_mode_setcrtc], [CRTC:5]
[drm:drm_mode_setcrtc], [CONNECTOR:20:DP-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:25] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:ironlake_update_plane], Writing base 0084D000 00000000 0 0 5120
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:i915_getparam], Unknown parameter 17
[drm:i915_getparam], Unknown parameter 17
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
r8169 0000:0a:00.0: eth0: link up
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 26:"1280x1024" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_crtc_helper_set_mode], [CRTC:3]
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to LVDS (6)
[drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 6)
[drm:ironlake_crtc_mode_set], Mode for pipe 0:
[drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm] Changing LVDS panel from (+hsync, +vsync) to (-hsync, -vsync)
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:ironlake_update_plane], Writing base 00064000 00000000 0 0 7680
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:drm_crtc_helper_set_mode], [ENCODER:8:LVDS-8] set [MODE:11:1920x1080]
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[drm:gen6_fdi_link_train], FDI train 1 done.
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[drm:gen6_fdi_link_train], FDI train 2 done.
[drm:gen6_fdi_link_train], FDI train done.
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config], 	[CONNECTOR:7:LVDS-1] set DPMS on
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:ironlake_update_plane], Writing base 00064000 00000000 0 0 7680
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:14:VGA-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:17:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:output_poll_execute], [CONNECTOR:20:DP-1] status updated from 1 to 1
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
wlan0: authenticate with d8:c7:c8:ad:e3:a9 (try 1)
wlan0: authenticate with d8:c7:c8:ad:e3:a9 (try 2)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:a9 (try 1)
wlan0: associate with d8:c7:c8:ad:e3:a9 (try 2)
wlan0: RX AssocResp from d8:c7:c8:ad:e3:a9 (capab=0x401 status=0 aid=4)
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

--------------080302020805010102020801
Content-Type: text/plain;
 name="3.4.2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="3.4.2"

Initializing cgroup subsys cpu
Linux version 3.4.2.git (root@wensxps) (gcc version 4.6.3 (Debian 4.6.3-1) ) #46 SMP Mon Jun 11 15:44:57 CEST 2012
Command line: BOOT_IMAGE=/boot/vmlinuz-3.4.2.git root=UUID=39c0ed04-fbf1-43b0-8e7a-09e446a8bea6 ro drm.debug=0xe
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
  NODE_DATA [000000023e9fb000 - 000000023e9fefff]
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
PERCPU: Embedded 27 pages/cpu @ffff88023e600000 s78016 r8192 d24384 u262144
pcpu-alloc: s78016 r8192 d24384 u262144 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2037860
Policy zone: Normal
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.4.2.git root=UUID=39c0ed04-fbf1-43b0-8e7a-09e446a8bea6 ro drm.debug=0xe
PID hash table entries: 4096 (order: 3, 32768 bytes)
xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
Memory: 8085692k/9414652k available (4137k kernel code, 1134476k absent, 194484k reserved, 4574k data, 472k init)
Hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
NR_IRQS:33024 nr_irqs:744 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2194.857 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4389.71 BogoMIPS (lpj=8779428)
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
ACPI: Core revision 20120320
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz stepping 07
Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
PEBS disabled due to CPU errata.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
NMI watchdog: enabled, takes one hw-pmu counter.
Booting Node   0, Processors  #1
Disabled fast string operations
CPU1: Thermal monitoring handled by SMI
NMI watchdog: enabled, takes one hw-pmu counter.
 #2
Disabled fast string operations
CPU2: Thermal monitoring handled by SMI
NMI watchdog: enabled, takes one hw-pmu counter.
 #3
Disabled fast string operations
CPU3: Thermal monitoring handled by SMI
NMI watchdog: enabled, takes one hw-pmu counter.
 #4
Disabled fast string operations
CPU4: Thermal monitoring handled by SMI
NMI watchdog: enabled, takes one hw-pmu counter.
 #5
Disabled fast string operations
CPU5: Thermal monitoring handled by SMI
NMI watchdog: enabled, takes one hw-pmu counter.
 #6
Disabled fast string operations
CPU6: Thermal monitoring handled by SMI
NMI watchdog: enabled, takes one hw-pmu counter.
 #7 Ok.
Disabled fast string operations
CPU7: Thermal monitoring handled by SMI
NMI watchdog: enabled, takes one hw-pmu counter.
Brought up 8 CPUs
Total of 8 processors activated (35117.71 BogoMIPS).
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0xbade2000-0xbade9fff] (32768 bytes)
PM: Registering ACPI NVS region [mem 0xbaf1f000-0xbaf9efff] (524288 bytes)
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
pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: [8086:0116] type 00 class 0x030000
pci 0000:00:02.0: reg 10: [mem 0xf2400000-0xf27fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
pci 0000:00:16.0: reg 10: [mem 0xf3c05000-0xf3c0500f 64bit]
pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
pci 0000:00:1a.0: reg 10: [mem 0xf3c0a000-0xf3c0a3ff]
pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
pci 0000:00:1b.0: reg 10: [mem 0xf3c00000-0xf3c03fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: [8086:1c1a] type 01 class 0x060400
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
pci 0000:00:1d.0: reg 10: [mem 0xf3c09000-0xf3c093ff]
pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.0: [8086:1c4b] type 00 class 0x060100
pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
pci 0000:00:1f.2: reg 10: [io  0x5088-0x508f]
pci 0000:00:1f.2: reg 14: [io  0x5094-0x5097]
pci 0000:00:1f.2: reg 18: [io  0x5080-0x5087]
pci 0000:00:1f.2: reg 1c: [io  0x5090-0x5093]
pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
pci 0000:00:1f.2: reg 24: [mem 0xf3c08000-0xf3c087ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
pci 0000:00:1f.3: reg 10: [mem 0xf3c04000-0xf3c040ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
pci 0000:01:00.0: [10de:124d] type 00 class 0x030000
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
pci 0000:03:00.0: [8086:0091] type 00 class 0x028000
pci 0000:03:00.0: reg 10: [mem 0xf3b00000-0xf3b01fff 64bit]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [mem 0xf3b00000-0xf3bfffff]
pci 0000:04:00.0: [1033:0194] type 00 class 0x0c0330
pci 0000:04:00.0: reg 10: [mem 0xf3a00000-0xf3a01fff 64bit]
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PCI bridge to [bus 04-04]
pci 0000:00:1c.3:   bridge window [mem 0xf3a00000-0xf3afffff]
pci 0000:00:1c.4: PCI bridge to [bus 05-09]
pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.4:   bridge window [mem 0xf3100000-0xf39fffff]
pci 0000:00:1c.4:   bridge window [mem 0xf2800000-0xf2ffffff 64bit pref]
pci 0000:0a:00.0: [10ec:8168] type 00 class 0x020000
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
TCP: reno registered
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
[drm:intel_opregion_setup], graphic opregion physical addr: 0xbaf27018
[drm:intel_opregion_setup], Public ACPI methods supported
[drm:intel_opregion_setup], SWSCI supported
[drm:intel_opregion_setup], ASLE supported
i915 0000:00:02.0: irq 41 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
[drm:intel_detect_pch], Found CougarPoint PCH
[drm:init_vbt_defaults], Set default to SSC at 100MHz
[drm:intel_parse_bios], Using VBT from OpRegion: $VBT SANDYBRIDGE-M  d
[drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 0 int_crt_support 1 lvds_use_ssc 0 lvds_ssc_freq 120 display_clock_mode 0
[drm:parse_general_definitions], crt_ddc_bus_pin: 2
[drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1080" 0 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x8 0xa
[drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[drm:intel_dsm_detect], VGA switcheroo: detected DSM switching method \_SB_.PCI0.PEG0.PEGP handle
[drm:intel_modeset_init], 2 display pipes available.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
[drm:intel_panel_get_backlight], get backlight PWM = 4648
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_get_backlight], get backlight PWM = 4648
[drm:intel_crt_init], pch crt adpa set to 0xf40000
[drm:intel_dp_i2c_init], i2c_init DPDDC-C
[drm:intel_panel_actually_set_backlight], set backlight PWM = 0
[drm:ironlake_crtc_dpms], crtc 0/0 dpms off
[drm:i915_get_vblank_timestamp], crtc 0 is disabled
[drm:intel_update_fbc], 
[drm:intel_update_fbc], no output, disabling
[drm:ironlake_crtc_dpms], crtc 1/1 dpms off
[drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe B
[drm:i915_get_vblank_timestamp], crtc 1 is disabled
[drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe B
[drm:intel_update_fbc], 
[drm:intel_update_fbc], no output, disabling
[drm:ironlake_init_pch_refclk], has_panel 1 has_lvds 1 has_pch_edp 0 has_cpu_edp 0 has_ck505 0
[drm:intel_enable_rc6], Sandybridge: deep RC6 disabled
[drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[drm:init_status_page], render ring hws offset: 0x00000000
[drm:init_status_page], gen6 bsd ring hws offset: 0x00022000
[drm:init_status_page], blt ring hws offset: 0x00043000
[drm:i915_setup_compression], FBC base 0xfc000000, ll base 0x00000000, size 32M
[drm:intel_panel_actually_set_backlight], set backlight PWM = 0
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], trigger hotplug detect cycle: adpa=0xf40000
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_setup_crtcs], 
[drm:drm_enable_connectors], connector 7 enabled? yes
[drm:drm_enable_connectors], connector 14 enabled? no
[drm:drm_enable_connectors], connector 17 enabled? no
[drm:drm_enable_connectors], connector 20 enabled? yes
[drm:drm_target_preferred], looking for cmdline mode on connector 7
[drm:drm_target_preferred], looking for preferred mode on connector 7
[drm:drm_target_preferred], found mode 1920x1080
[drm:drm_target_preferred], looking for cmdline mode on connector 20
[drm:drm_target_preferred], looking for preferred mode on connector 20
[drm:drm_target_preferred], found mode 1280x1024
[drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[drm:drm_setup_crtcs], desired mode 1920x1080 set on crtc 3
[drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 5
[drm:intelfb_create], allocated 1920x1080 fb: 0x00064000, bo ffff88023466ec00
fbcon: inteldrmfb (fb0) is primary device
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_crtc_helper_set_mode], [CRTC:3]
[drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to LVDS (6)
[drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 6)
[drm:ironlake_crtc_mode_set], Mode for pipe 0:
[drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:ironlake_update_plane], Writing base 00064000 00000000 0 0 7680
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:ironlake_check_srwm], watermark 1: display plane 16, fbc lines 3, cursor 6
[drm:ironlake_check_srwm], watermark 2: display plane 20, fbc lines 3, cursor 6
[drm:ironlake_check_srwm], watermark 3: display plane 99, fbc lines 3, cursor 6
[drm:drm_crtc_helper_set_mode], [ENCODER:8:LVDS-8] set [MODE:11:1920x1080]
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:ironlake_check_srwm], watermark 1: display plane 16, fbc lines 3, cursor 6
[drm:ironlake_check_srwm], watermark 2: display plane 20, fbc lines 3, cursor 6
[drm:ironlake_check_srwm], watermark 3: display plane 99, fbc lines 3, cursor 6
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x700
[drm:gen6_fdi_link_train], FDI train 1 done.
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[drm:gen6_fdi_link_train], FDI train 2 done.
[drm:gen6_fdi_link_train], FDI train done.
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config], 	[CONNECTOR:7:LVDS-1] set DPMS on
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[drm:drm_mode_debug_printmodeline], Modeline 22:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 22:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:intel_dp_mode_fixup], Display port link bw 06 lane count 2 clock 162000
[drm:drm_crtc_helper_set_mode], [CRTC:5]
[drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 8)
[drm:ironlake_crtc_mode_set], Mode for pipe 1:
[drm:drm_mode_debug_printmodeline], Modeline 22:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:ironlake_update_plane], Writing base 00064000 00000000 0 0 7680
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:drm_crtc_helper_set_mode], [ENCODER:21:TMDS-21] set [MODE:22:1280x1024]
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
Refined TSC clocksource calibration: 2195.013 MHz.
Switching to clocksource tsc
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[drm:gen6_fdi_link_train], FDI train 1 done.
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[drm:gen6_fdi_link_train], FDI train 2 done.
[drm:gen6_fdi_link_train], FDI train done.
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], clock recovery OK
[drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config], 	[CONNECTOR:20:DP-1] set DPMS on
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
Console: switching to colour frame buffer device 160x64
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
acpi device:2f: registered as cooling_device0
video: probe of LNXVIDEO:00 failed with error -5
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
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
TCP: cubic registered
NET: Registered protocol family 10
NET: Registered protocol family 17
Registering the dns_resolver key type
PM: Hibernation image not present or could not be loaded.
registered taskstats version 1
rtc_cmos 00:05: setting system clock to 2012-06-14 14:24:26 UTC (1339683866)
Initializing network drop monitor service
Freeing unused kernel memory: 472k freed
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 1988k freed
Freeing unused kernel memory: 728k freed
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
udevd[75]: starting version 175
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (55 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [TZ01] (55 C)
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
ata1.00: ACPI cmd ef/5a:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ATA-8: ST9500423AS, 0002DEM1, max UDMA/133
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd ef/5a:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST9500423AS      0002 PQ: 0 ANSI: 5
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ACPI cmd ef/5a:00:00:00:00:a0 (SET FEATURES) succeeded
ata2.00: ATA-8: ST9500423AS, 0002DEM1, max UDMA/133
ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata2.00: ACPI cmd ef/5a:00:00:00:00:a0 (SET FEATURES) succeeded
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
udevd[327]: starting version 175
microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x23
ACPI Warning: 0x000000000000efa0-0x000000000000efbf SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120320/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
mei: module is from the staging directory, the quality is unknown, you have been warned.
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
mei 0000:00:16.0: setting latency timer to 64
mei 0000:00:16.0: irq 43 for MSI/MSI-X
input: PC Speaker as /devices/platform/pcspkr/input/input6
ACPI: Requesting acpi_cpufreq
iTCO_vendor_support: vendor-support=0
wmi: Mapper loaded
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:0a:00.0: irq 44 for MSI/MSI-X
r8169 0000:0a:00.0: eth0: RTL8168e/8111e at 0xffffc900057b6000, 84:8f:69:c4:09:63, XID 0c200000 IRQ 44
r8169 0000:0a:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
cfg80211: Calling CRDA to update world regulatory domain
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 5:0:0:0: Attached scsi CD-ROM sr0
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.0: setting latency timer to 64
ehci_hcd 0000:00:1a.0: EHCI Host Controller
ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.0: debug port 2
ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf3c0a000
ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.4.2.git ehci_hcd
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
ACPI: AC Adapter [ADP0] (on-line)
usb usb2: Manufacturer: Linux 3.4.2.git ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: Battery Slot [BAT0] (battery present)
alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
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
usb usb3: Manufacturer: Linux 3.4.2.git xhci_hcd
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
usb usb4: Manufacturer: Linux 3.4.2.git xhci_hcd
usb usb4: SerialNumber: 0000:04:00.0
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
input: Dell WMI hotkeys as /devices/virtual/input/input7
microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU4 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU5 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU6 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU7 sig=0x206a7, pf=0x10, revision=0x23
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
snd_hda_intel 0000:00:1b.0: irq 53 for MSI/MSI-X
Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
Copyright(c) 2003-2012 Intel Corporation
iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
iwlwifi 0000:03:00.0: pci_resource_base = ffffc900057e4000
iwlwifi 0000:03:00.0: HW Revision ID = 0x34
iwlwifi 0000:03:00.0: irq 54 for MSI/MSI-X
usb 1-1: new high-speed USB device number 2 using ehci_hcd
psmouse serio1: synaptics: Touchpad model: 1, fw: 7.4, id: 0x1e0b1, caps: 0xd04773/0xa40000/0x8a0400
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input8
usb 1-1: New USB device found, idVendor=8087, idProduct=0024
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 6 ports detected
iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1
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
Registered led device: phy0-led
usb 2-1: new high-speed USB device number 2 using ehci_hcd
usb 2-1: New USB device found, idVendor=8087, idProduct=0024
usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 8 ports detected
usb 3-1: new low-speed USB device number 2 using xhci_hcd
usb 3-1: New USB device found, idVendor=045e, idProduct=0040
usb 3-1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
usb 3-1: Product: Microsoft 3-Button Mouse with IntelliEye(TM)
usb 3-1: Manufacturer: Microsoft
usb 3-1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
hda_codec: ALC665: SKU not ready 0x598301f0
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
usb 3-2: new low-speed USB device number 3 using xhci_hcd
usb 3-2: New USB device found, idVendor=0a81, idProduct=0205
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: PS2 to USB Converter
usb 3-2: Manufacturer: CHESEN
usb 3-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
usb 3-2: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
usb 1-1.4: new high-speed USB device number 3 using ehci_hcd
usb 1-1.4: New USB device found, idVendor=0408, idProduct=2fb1
usb 1-1.4: New USB device strings: Mfr=3, Product=2, SerialNumber=0
usb 1-1.4: Product: Laptop_Integrated_Webcam_2HDM
usb 1-1.4: Manufacturer: CN07CN2C7866421A1605A00
Linux media interface: v0.10
usb 2-1.5: new full-speed USB device number 3 using ehci_hcd
Linux video capture interface: v2.00
input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1c.3/0000:04:00.0/usb3/3-1/3-1:1.0/input/input14
generic-usb 0003:045E:0040.0001: input,hidraw0: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:04:00.0-1/input0
input: CHESEN PS2 to USB Converter as /devices/pci0000:00/0000:00:1c.3/0000:04:00.0/usb3/3-2/3-2:1.0/input/input15
generic-usb 0003:0A81:0205.0002: input,hidraw1: USB HID v1.10 Keyboard [CHESEN PS2 to USB Converter] on usb-0000:04:00.0-2/input0
input: CHESEN PS2 to USB Converter as /devices/pci0000:00/0000:00:1c.3/0000:04:00.0/usb3/3-2/3-2:1.1/input/input16
generic-usb 0003:0A81:0205.0003: input,hidraw2: USB HID v1.10 Mouse [CHESEN PS2 to USB Converter] on usb-0000:04:00.0-2/input1
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usb 2-1.5: New USB device found, idVendor=8086, idProduct=0189
usb 2-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
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
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Adding 15007740k swap on /dev/sda6.  Priority:-1 extents:1 across:15007740k 
EXT4-fs (sda5): re-mounted. Opts: (null)
EXT4-fs (sda5): re-mounted. Opts: errors=remount-ro
loop: module loaded
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:14:VGA-1] status updated from 2 to 2
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:output_poll_execute], [CONNECTOR:17:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:output_poll_execute], [CONNECTOR:20:DP-1] status updated from 1 to 1
fuse init (API version 7.18)
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
ADDRCONF(NETDEV_UP): wlan0: link is not ready
r8169 0000:0a:00.0: eth0: link down
r8169 0000:0a:00.0: eth0: link down
ADDRCONF(NETDEV_UP): eth0: link is not ready
NOHZ: local_softirq_pending 08
input: ACPI Virtual Keyboard Device as /devices/virtual/input/input18
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:i915_driver_open], 
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:i915_driver_open], 
[drm:drm_mode_getresources], CRTC[2] CONNECTORS[4] ENCODERS[4]
[drm:drm_mode_getresources], CRTC[2] CONNECTORS[4] ENCODERS[4]
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:drm_mode_addfb], [FB:25]
[drm:drm_mode_setcrtc], [CRTC:3]
[drm:drm_mode_setcrtc], [CONNECTOR:7:LVDS-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:25] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 26:"1280x1024" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 26:"1280x1024" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm:drm_crtc_helper_set_mode], [CRTC:3]
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to LVDS (6)
[drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 6)
[drm:ironlake_crtc_mode_set], Mode for pipe 0:
[drm:drm_mode_debug_printmodeline], Modeline 26:"1280x1024" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm] Changing LVDS panel from (-hsync, -vsync) to (+hsync, +vsync)
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:ironlake_update_plane], Writing base 0084D000 00000000 0 0 5120
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:drm_crtc_helper_set_mode], [ENCODER:8:LVDS-8] set [MODE:26:1280x1024]
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[drm:gen6_fdi_link_train], FDI train 1 done.
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[drm:gen6_fdi_link_train], FDI train 2 done.
[drm:gen6_fdi_link_train], FDI train done.
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config], 	[CONNECTOR:7:LVDS-1] set DPMS on
[drm:drm_mode_setcrtc], [CRTC:5]
[drm:drm_mode_setcrtc], [CONNECTOR:20:DP-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:25] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:ironlake_update_plane], Writing base 0084D000 00000000 0 0 5120
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
r8169 0000:0a:00.0: eth0: link up
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:14:VGA-1] status updated from 2 to 2
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:output_poll_execute], [CONNECTOR:17:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:output_poll_execute], [CONNECTOR:20:DP-1] status updated from 1 to 1
microcode: CPU0 updated to revision 0x28, date = 2012-04-24
microcode: CPU1 updated to revision 0x28, date = 2012-04-24
microcode: CPU2 updated to revision 0x28, date = 2012-04-24
microcode: CPU3 updated to revision 0x28, date = 2012-04-24
microcode: CPU4 updated to revision 0x28, date = 2012-04-24
microcode: CPU5 updated to revision 0x28, date = 2012-04-24
microcode: CPU6 updated to revision 0x28, date = 2012-04-24
microcode: CPU7 updated to revision 0x28, date = 2012-04-24
eth0: no IPv6 routers present
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:drm_mode_addfb], [FB:26]
[drm:drm_mode_setcrtc], [CRTC:3]
[drm:drm_mode_setcrtc], [CONNECTOR:7:LVDS-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:ironlake_update_plane], Writing base 0125F000 00000000 0 0 7680
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:drm_mode_setcrtc], [CRTC:5]
[drm:drm_mode_setcrtc], [CONNECTOR:20:DP-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:26] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:ironlake_update_plane], Writing base 0125F000 00000000 0 0 7680
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:drm_mode_setcrtc], [CRTC:3]
[drm:drm_mode_setcrtc], [CONNECTOR:7:LVDS-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 26:"1280x1024" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm:drm_mode_debug_printmodeline], Modeline 25:"" 0 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x0 0xa
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 25:"" 0 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x0 0xa
[drm:drm_crtc_helper_set_mode], [CRTC:3]
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to LVDS (6)
[drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 6)
[drm:ironlake_crtc_mode_set], Mode for pipe 0:
[drm:drm_mode_debug_printmodeline], Modeline 25:"" 0 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x0 0xa
[drm] Changing LVDS panel from (+hsync, +vsync) to (-hsync, -vsync)
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:ironlake_update_plane], Writing base 0125F000 00000000 0 0 7680
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:drm_crtc_helper_set_mode], [ENCODER:8:LVDS-8] set [MODE:25:]
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[drm:gen6_fdi_link_train], FDI train 1 done.
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[drm:gen6_fdi_link_train], FDI train 2 done.
[drm:gen6_fdi_link_train], FDI train done.
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config], 	[CONNECTOR:7:LVDS-1] set DPMS on
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:drm_mode_addfb], [FB:25]
[drm:drm_mode_setcrtc], [CRTC:3]
[drm:drm_mode_setcrtc], [CONNECTOR:7:LVDS-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:25] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:ironlake_update_plane], Writing base 01A5F000 00000000 0 0 12800
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:drm_mode_setcrtc], [CRTC:5]
[drm:drm_mode_setcrtc], [CONNECTOR:20:DP-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:25] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:ironlake_update_plane], Writing base 01A5F000 00000000 0 0 12800
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:drm_mode_setcrtc], [CRTC:5]
[drm:drm_mode_setcrtc], [CONNECTOR:20:DP-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:25] #connectors=1 (x y) (1920 56)
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 22:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 26:"" 0 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 26:"" 0 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm:intel_dp_mode_fixup], Display port link bw 0a lane count 2 clock 270000
[drm:drm_crtc_helper_set_mode], [CRTC:5]
[drm:intel_dp_link_down], 
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:pch_irq_handler], PCH HDCP audio interrupt
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 8, cursor: 6
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 8)
[drm:ironlake_crtc_mode_set], Mode for pipe 1:
[drm:drm_mode_debug_printmodeline], Modeline 26:"" 0 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:ironlake_update_plane], Writing base 01A5F000 000B0E00 1920 56 12800
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 8, cursor: 6
[drm:drm_crtc_helper_set_mode], [ENCODER:21:TMDS-21] set [MODE:26:]
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 8, cursor: 6
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[drm:gen6_fdi_link_train], FDI train 1 done.
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[drm:gen6_fdi_link_train], FDI train 2 done.
[drm:gen6_fdi_link_train], FDI train done.
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], clock recovery OK
[drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config], 	[CONNECTOR:20:DP-1] set DPMS on
[drm:i915_hotplug_work_func], running encoder hotplug functions
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:14:VGA-1] status updated from 2 to 2
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:output_poll_execute], [CONNECTOR:17:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:output_poll_execute], [CONNECTOR:20:DP-1] status updated from 1 to 1
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
wlan0: authenticate with d8:c7:c8:ad:e3:a9
wlan0: send auth to d8:c7:c8:ad:e3:a9 (try 1/3)
wlan0: send auth to d8:c7:c8:ad:e3:a9 (try 2/3)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:a9 (try 1/3)
wlan0: RX AssocResp from d8:c7:c8:ad:e3:a9 (capab=0x401 status=0 aid=4)
wlan0: associated
wlan0: Wrong control channel in association response: configured center-freq: 5180 hti-cfreq: 5540  hti->control_chan: 108 band: 1.  Disabling HT.
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
wlan0: authenticate with d8:c7:c8:ad:e3:a1
wlan0: send auth to d8:c7:c8:ad:e3:a1 (try 1/3)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:a1 (try 1/3)
wlan0: RX AssocResp from d8:c7:c8:ad:e3:a1 (capab=0x421 status=0 aid=2)
wlan0: associated
wlan0: Wrong control channel in association response: configured center-freq: 2412 hti-cfreq: 2462  hti->control_chan: 11 band: 0.  Disabling HT.
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:14:VGA-1] status updated from 2 to 2
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:output_poll_execute], [CONNECTOR:17:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:output_poll_execute], [CONNECTOR:20:DP-1] status updated from 1 to 1
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
wlan0: no IPv6 routers present
[drm:i915_driver_open], 
[drm:i915_driver_open], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off

--------------080302020805010102020801
Content-Type: text/plain;
 name="3.4.2.cold"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="3.4.2.cold"

Policy zone: Normal
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.4.2.git root=UUID=39c0ed04-fbf1-43b0-8e7a-09e446a8bea6 ro drm.debug=0xe
PID hash table entries: 4096 (order: 3, 32768 bytes)
xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
Memory: 8085692k/9414652k available (4137k kernel code, 1134476k absent, 194484k reserved, 4574k data, 472k init)
Hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
NR_IRQS:33024 nr_irqs:744 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2195.025 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4390.05 BogoMIPS (lpj=8780100)
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
ACPI: Core revision 20120320
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz stepping 07
Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
PEBS disabled due to CPU errata.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
NMI watchdog: enabled, takes one hw-pmu counter.
Booting Node   0, Processors  #1
Disabled fast string operations
CPU1: Thermal monitoring handled by SMI
NMI watchdog: enabled, takes one hw-pmu counter.
 #2
Disabled fast string operations
CPU2: Thermal monitoring handled by SMI
NMI watchdog: enabled, takes one hw-pmu counter.
 #3
Disabled fast string operations
CPU3: Thermal monitoring handled by SMI
NMI watchdog: enabled, takes one hw-pmu counter.
 #4
Disabled fast string operations
CPU4: Thermal monitoring handled by SMI
NMI watchdog: enabled, takes one hw-pmu counter.
 #5
Disabled fast string operations
CPU5: Thermal monitoring handled by SMI
NMI watchdog: enabled, takes one hw-pmu counter.
 #6
Disabled fast string operations
CPU6: Thermal monitoring handled by SMI
NMI watchdog: enabled, takes one hw-pmu counter.
 #7 Ok.
Disabled fast string operations
CPU7: Thermal monitoring handled by SMI
NMI watchdog: enabled, takes one hw-pmu counter.
Brought up 8 CPUs
Total of 8 processors activated (35120.40 BogoMIPS).
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0xbade2000-0xbade9fff] (32768 bytes)
PM: Registering ACPI NVS region [mem 0xbaf1f000-0xbaf9efff] (524288 bytes)
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
pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: [8086:0116] type 00 class 0x030000
pci 0000:00:02.0: reg 10: [mem 0xf2400000-0xf27fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
pci 0000:00:16.0: reg 10: [mem 0xf3c05000-0xf3c0500f 64bit]
pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
pci 0000:00:1a.0: reg 10: [mem 0xf3c0a000-0xf3c0a3ff]
pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
pci 0000:00:1b.0: reg 10: [mem 0xf3c00000-0xf3c03fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: [8086:1c1a] type 01 class 0x060400
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
pci 0000:00:1d.0: reg 10: [mem 0xf3c09000-0xf3c093ff]
pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.0: [8086:1c4b] type 00 class 0x060100
pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
pci 0000:00:1f.2: reg 10: [io  0x5088-0x508f]
pci 0000:00:1f.2: reg 14: [io  0x5094-0x5097]
pci 0000:00:1f.2: reg 18: [io  0x5080-0x5087]
pci 0000:00:1f.2: reg 1c: [io  0x5090-0x5093]
pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
pci 0000:00:1f.2: reg 24: [mem 0xf3c08000-0xf3c087ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
pci 0000:00:1f.3: reg 10: [mem 0xf3c04000-0xf3c040ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
pci 0000:01:00.0: [10de:124d] type 00 class 0x030000
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
pci 0000:03:00.0: [8086:0091] type 00 class 0x028000
pci 0000:03:00.0: reg 10: [mem 0xf3b00000-0xf3b01fff 64bit]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [mem 0xf3b00000-0xf3bfffff]
pci 0000:04:00.0: [1033:0194] type 00 class 0x0c0330
pci 0000:04:00.0: reg 10: [mem 0xf3a00000-0xf3a01fff 64bit]
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PCI bridge to [bus 04-04]
pci 0000:00:1c.3:   bridge window [mem 0xf3a00000-0xf3afffff]
pci 0000:00:1c.4: PCI bridge to [bus 05-09]
pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.4:   bridge window [mem 0xf3100000-0xf39fffff]
pci 0000:00:1c.4:   bridge window [mem 0xf2800000-0xf2ffffff 64bit pref]
pci 0000:0a:00.0: [10ec:8168] type 00 class 0x020000
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
TCP: reno registered
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
[drm:intel_opregion_setup], graphic opregion physical addr: 0xbaf27018
[drm:intel_opregion_setup], Public ACPI methods supported
[drm:intel_opregion_setup], SWSCI supported
[drm:intel_opregion_setup], ASLE supported
i915 0000:00:02.0: irq 41 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
[drm:intel_detect_pch], Found CougarPoint PCH
[drm:init_vbt_defaults], Set default to SSC at 100MHz
[drm:intel_parse_bios], Using VBT from OpRegion: $VBT SANDYBRIDGE-M  d
[drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 0 int_crt_support 1 lvds_use_ssc 0 lvds_ssc_freq 120 display_clock_mode 0
[drm:parse_general_definitions], crt_ddc_bus_pin: 2
[drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1080" 0 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x8 0xa
[drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[drm:intel_dsm_detect], VGA switcheroo: detected DSM switching method \_SB_.PCI0.PEG0.PEGP handle
[drm:intel_modeset_init], 2 display pipes available.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
[drm:intel_panel_get_backlight], get backlight PWM = 4648
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_get_backlight], get backlight PWM = 4648
[drm:intel_crt_init], pch crt adpa set to 0xf40000
[drm:intel_dp_i2c_init], i2c_init DPDDC-C
[drm:intel_panel_actually_set_backlight], set backlight PWM = 0
[drm:ironlake_crtc_dpms], crtc 0/0 dpms off
[drm:i915_get_vblank_timestamp], crtc 0 is disabled
[drm:intel_update_fbc], 
[drm:intel_update_fbc], no output, disabling
[drm:ironlake_crtc_dpms], crtc 1/1 dpms off
[drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe B
[drm:i915_get_vblank_timestamp], crtc 1 is disabled
[drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe B
[drm:intel_update_fbc], 
[drm:intel_update_fbc], no output, disabling
[drm:ironlake_init_pch_refclk], has_panel 1 has_lvds 1 has_pch_edp 0 has_cpu_edp 0 has_ck505 0
[drm:intel_enable_rc6], Sandybridge: deep RC6 disabled
[drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[drm:init_status_page], render ring hws offset: 0x00000000
[drm:init_status_page], gen6 bsd ring hws offset: 0x00022000
[drm:init_status_page], blt ring hws offset: 0x00043000
[drm:i915_setup_compression], FBC base 0xfc000000, ll base 0x00000000, size 32M
[drm:intel_panel_actually_set_backlight], set backlight PWM = 0
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], trigger hotplug detect cycle: adpa=0xf40000
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_setup_crtcs], 
[drm:drm_enable_connectors], connector 7 enabled? yes
[drm:drm_enable_connectors], connector 14 enabled? no
[drm:drm_enable_connectors], connector 17 enabled? no
[drm:drm_enable_connectors], connector 20 enabled? yes
[drm:drm_target_preferred], looking for cmdline mode on connector 7
[drm:drm_target_preferred], looking for preferred mode on connector 7
[drm:drm_target_preferred], found mode 1920x1080
[drm:drm_target_preferred], looking for cmdline mode on connector 20
[drm:drm_target_preferred], looking for preferred mode on connector 20
[drm:drm_target_preferred], found mode 1280x1024
[drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[drm:drm_setup_crtcs], desired mode 1920x1080 set on crtc 3
[drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 5
[drm:intelfb_create], allocated 1920x1080 fb: 0x00064000, bo ffff88023466ec00
fbcon: inteldrmfb (fb0) is primary device
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_crtc_helper_set_mode], [CRTC:3]
[drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to LVDS (6)
[drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 6)
[drm:ironlake_crtc_mode_set], Mode for pipe 0:
[drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:ironlake_update_plane], Writing base 00064000 00000000 0 0 7680
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:ironlake_check_srwm], watermark 1: display plane 16, fbc lines 3, cursor 6
[drm:ironlake_check_srwm], watermark 2: display plane 20, fbc lines 3, cursor 6
[drm:ironlake_check_srwm], watermark 3: display plane 99, fbc lines 3, cursor 6
[drm:drm_crtc_helper_set_mode], [ENCODER:8:LVDS-8] set [MODE:11:1920x1080]
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:ironlake_check_srwm], watermark 1: display plane 16, fbc lines 3, cursor 6
[drm:ironlake_check_srwm], watermark 2: display plane 20, fbc lines 3, cursor 6
[drm:ironlake_check_srwm], watermark 3: display plane 99, fbc lines 3, cursor 6
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x700
[drm:gen6_fdi_link_train], FDI train 1 done.
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[drm:gen6_fdi_link_train], FDI train 2 done.
[drm:gen6_fdi_link_train], FDI train done.
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config], 	[CONNECTOR:7:LVDS-1] set DPMS on
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[drm:drm_mode_debug_printmodeline], Modeline 22:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 22:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:intel_dp_mode_fixup], Display port link bw 06 lane count 2 clock 162000
[drm:drm_crtc_helper_set_mode], [CRTC:5]
[drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 8)
[drm:ironlake_crtc_mode_set], Mode for pipe 1:
[drm:drm_mode_debug_printmodeline], Modeline 22:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:ironlake_update_plane], Writing base 00064000 00000000 0 0 7680
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:drm_crtc_helper_set_mode], [ENCODER:21:TMDS-21] set [MODE:22:1280x1024]
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
Refined TSC clocksource calibration: 2195.013 MHz.
Switching to clocksource tsc
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[drm:gen6_fdi_link_train], FDI train 1 done.
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[drm:gen6_fdi_link_train], FDI train 2 done.
[drm:gen6_fdi_link_train], FDI train done.
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], too many full retries, give up
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], too many full retries, give up
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], too many full retries, give up
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], too many full retries, give up
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], too many full retries, give up
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], too many full retries, give up
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], too many full retries, give up
[drm:intel_dp_complete_link_train] *ERROR* failed to train DP, aborting
[drm:intel_dp_link_down], 
[drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config], 	[CONNECTOR:20:DP-1] set DPMS on
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
Console: switching to colour frame buffer device 160x64
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
acpi device:2f: registered as cooling_device0
video: probe of LNXVIDEO:00 failed with error -5
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
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
TCP: cubic registered
NET: Registered protocol family 10
NET: Registered protocol family 17
Registering the dns_resolver key type
PM: Hibernation image not present or could not be loaded.
registered taskstats version 1
rtc_cmos 00:05: setting system clock to 2012-06-14 14:31:22 UTC (1339684282)
Initializing network drop monitor service
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
Freeing unused kernel memory: 472k freed
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 1988k freed
Freeing unused kernel memory: 728k freed
udevd[80]: starting version 175
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (44 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [TZ01] (44 C)
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
udevd[330]: starting version 175
input: PC Speaker as /devices/platform/pcspkr/input/input6
mei: module is from the staging directory, the quality is unknown, you have been warned.
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
mei 0000:00:16.0: setting latency timer to 64
mei 0000:00:16.0: irq 43 for MSI/MSI-X
ACPI Warning: 0x000000000000efa0-0x000000000000efbf SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120320/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x23
snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
cfg80211: Calling CRDA to update world regulatory domain
wmi: Mapper loaded
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:0a:00.0: irq 45 for MSI/MSI-X
r8169 0000:0a:00.0: eth0: RTL8168e/8111e at 0xffffc900057ac000, 84:8f:69:c4:09:63, XID 0c200000 IRQ 45
r8169 0000:0a:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
ACPI: Requesting acpi_cpufreq
Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
Copyright(c) 2003-2012 Intel Corporation
iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
iwlwifi 0000:03:00.0: pci_resource_base = ffffc900057b8000
iwlwifi 0000:03:00.0: HW Revision ID = 0x34
usbcore: registered new interface driver usbfs
iwlwifi 0000:03:00.0: irq 46 for MSI/MSI-X
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: AC Adapter [ADP0] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU4 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU5 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU6 sig=0x206a7, pf=0x10, revision=0x23
microcode: CPU7 sig=0x206a7, pf=0x10, revision=0x23
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
xhci_hcd 0000:04:00.0: xHCI Host Controller
xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 1
xhci_hcd 0000:04:00.0: irq 19, io mem 0xf3a00000
xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 48 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 49 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 50 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 51 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 52 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 53 for MSI/MSI-X
xhci_hcd 0000:04:00.0: irq 54 for MSI/MSI-X
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: xHCI Host Controller
usb usb1: Manufacturer: Linux 3.4.2.git xhci_hcd
usb usb1: SerialNumber: 0000:04:00.0
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
xhci_hcd 0000:04:00.0: xHCI Host Controller
xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 2
usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: xHCI Host Controller
usb usb2: Manufacturer: Linux 3.4.2.git xhci_hcd
usb usb2: SerialNumber: 0000:04:00.0
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:14:VGA-1] status updated from 2 to 2
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:output_poll_execute], [CONNECTOR:17:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
input: Dell WMI hotkeys as /devices/virtual/input/input7
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 5:0:0:0: Attached scsi CD-ROM sr0
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:output_poll_execute], [CONNECTOR:20:DP-1] status updated from 1 to 1
iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1
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
Registered led device: phy0-led
hda_codec: ALC665: SKU not ready 0x598301f0
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
ehci_hcd 0000:00:1a.0: setting latency timer to 64
ehci_hcd 0000:00:1a.0: EHCI Host Controller
ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:1a.0: debug port 2
ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf3c0a000
ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: EHCI Host Controller
usb usb3: Manufacturer: Linux 3.4.2.git ehci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ehci_hcd 0000:00:1d.0: setting latency timer to 64
ehci_hcd 0000:00:1d.0: EHCI Host Controller
ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.0: debug port 2
ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf3c09000
psmouse serio1: synaptics: Touchpad model: 1, fw: 7.4, id: 0x1e0b1, caps: 0xd04773/0xa40000/0x8a0400
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input13
usb 1-1: new low-speed USB device number 2 using xhci_hcd
ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: EHCI Host Controller
usb usb4: Manufacturer: Linux 3.4.2.git ehci_hcd
usb usb4: SerialNumber: 0000:00:1d.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-1: New USB device found, idVendor=045e, idProduct=0040
usb 1-1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
usb 1-1: Product: Microsoft 3-Button Mouse with IntelliEye(TM)
usb 1-1: Manufacturer: Microsoft
usb 1-1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
usb 1-2: new low-speed USB device number 3 using xhci_hcd
usb 1-2: New USB device found, idVendor=0a81, idProduct=0205
usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-2: Product: PS2 to USB Converter
usb 1-2: Manufacturer: CHESEN
usb 1-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
usb 1-2: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
usb 3-1: new high-speed USB device number 2 using ehci_hcd
usb 3-1: New USB device found, idVendor=8087, idProduct=0024
usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 3-1:1.0: USB hub found
hub 3-1:1.0: 6 ports detected
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
usb 4-1: new high-speed USB device number 2 using ehci_hcd
input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1c.3/0000:04:00.0/usb1/1-1/1-1:1.0/input/input14
generic-usb 0003:045E:0040.0001: input,hidraw0: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:04:00.0-1/input0
usb 4-1: New USB device found, idVendor=8087, idProduct=0024
usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 4-1:1.0: USB hub found
hub 4-1:1.0: 8 ports detected
input: CHESEN PS2 to USB Converter as /devices/pci0000:00/0000:00:1c.3/0000:04:00.0/usb1/1-2/1-2:1.0/input/input15
generic-usb 0003:0A81:0205.0002: input,hidraw1: USB HID v1.10 Keyboard [CHESEN PS2 to USB Converter] on usb-0000:04:00.0-2/input0
input: CHESEN PS2 to USB Converter as /devices/pci0000:00/0000:00:1c.3/0000:04:00.0/usb1/1-2/1-2:1.1/input/input16
generic-usb 0003:0A81:0205.0003: input,hidraw2: USB HID v1.10 Mouse [CHESEN PS2 to USB Converter] on usb-0000:04:00.0-2/input1
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usb 3-1.4: new high-speed USB device number 3 using ehci_hcd
usb 3-1.4: New USB device found, idVendor=0408, idProduct=2fb1
usb 3-1.4: New USB device strings: Mfr=3, Product=2, SerialNumber=0
usb 3-1.4: Product: Laptop_Integrated_Webcam_2HDM
usb 3-1.4: Manufacturer: CN07CN2C7866421A1605A00
Linux media interface: v0.10
Linux video capture interface: v2.00
usb 4-1.5: new full-speed USB device number 3 using ehci_hcd
usb 4-1.5: New USB device found, idVendor=8086, idProduct=0189
usb 4-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_2HDM (0408:2fb1)
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
uvcvideo: No streaming interface found for terminal 6.
input: Laptop_Integrated_Webcam_2HDM as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.4/3-1.4:1.0/input/input17
usbcore: registered new interface driver uvcvideo
USB Video Class driver (1.1.1)
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
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
ADDRCONF(NETDEV_UP): wlan0: link is not ready
r8169 0000:0a:00.0: eth0: link down
r8169 0000:0a:00.0: eth0: link down
ADDRCONF(NETDEV_UP): eth0: link is not ready
input: ACPI Virtual Keyboard Device as /devices/virtual/input/input18
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:i915_driver_open], 
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:24] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:i915_driver_open], 
[drm:drm_mode_getresources], CRTC[2] CONNECTORS[4] ENCODERS[4]
[drm:drm_mode_getresources], CRTC[2] CONNECTORS[4] ENCODERS[4]
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:drm_mode_addfb], [FB:25]
[drm:drm_mode_setcrtc], [CRTC:3]
[drm:drm_mode_setcrtc], [CONNECTOR:7:LVDS-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:25] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 11:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 26:"1280x1024" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 26:"1280x1024" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm:drm_crtc_helper_set_mode], [CRTC:3]
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to LVDS (6)
[drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 6)
[drm:ironlake_crtc_mode_set], Mode for pipe 0:
[drm:drm_mode_debug_printmodeline], Modeline 26:"1280x1024" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm] Changing LVDS panel from (-hsync, -vsync) to (+hsync, +vsync)
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:ironlake_update_plane], Writing base 0084D000 00000000 0 0 5120
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:drm_crtc_helper_set_mode], [ENCODER:8:LVDS-8] set [MODE:26:1280x1024]
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[drm:gen6_fdi_link_train], FDI train 1 done.
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[drm:gen6_fdi_link_train], FDI train 2 done.
[drm:gen6_fdi_link_train], FDI train done.
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config], 	[CONNECTOR:7:LVDS-1] set DPMS on
[drm:drm_mode_setcrtc], [CRTC:5]
[drm:drm_mode_setcrtc], [CONNECTOR:20:DP-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:25] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:ironlake_update_plane], Writing base 0084D000 00000000 0 0 5120
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
r8169 0000:0a:00.0: eth0: link up
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:14:VGA-1] status updated from 2 to 2
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:output_poll_execute], [CONNECTOR:17:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:output_poll_execute], [CONNECTOR:20:DP-1] status updated from 1 to 1
eth0: no IPv6 routers present
microcode: CPU0 updated to revision 0x28, date = 2012-04-24
microcode: CPU1 updated to revision 0x28, date = 2012-04-24
microcode: CPU2 updated to revision 0x28, date = 2012-04-24
microcode: CPU3 updated to revision 0x28, date = 2012-04-24
microcode: CPU4 updated to revision 0x28, date = 2012-04-24
microcode: CPU5 updated to revision 0x28, date = 2012-04-24
microcode: CPU6 updated to revision 0x28, date = 2012-04-24
microcode: CPU7 updated to revision 0x28, date = 2012-04-24
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:drm_mode_addfb], [FB:26]
[drm:drm_mode_setcrtc], [CRTC:3]
[drm:drm_mode_setcrtc], [CONNECTOR:7:LVDS-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:ironlake_update_plane], Writing base 01263000 00000000 0 0 7680
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:drm_mode_setcrtc], [CRTC:5]
[drm:drm_mode_setcrtc], [CONNECTOR:20:DP-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:26] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:ironlake_update_plane], Writing base 01263000 00000000 0 0 7680
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:drm_mode_setcrtc], [CRTC:3]
[drm:drm_mode_setcrtc], [CONNECTOR:7:LVDS-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 26:"1280x1024" 0 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm:drm_mode_debug_printmodeline], Modeline 25:"" 0 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x0 0xa
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 25:"" 0 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x0 0xa
[drm:drm_crtc_helper_set_mode], [CRTC:3]
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to LVDS (6)
[drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 6)
[drm:ironlake_crtc_mode_set], Mode for pipe 0:
[drm:drm_mode_debug_printmodeline], Modeline 25:"" 0 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x0 0xa
[drm] Changing LVDS panel from (+hsync, +vsync) to (-hsync, -vsync)
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:ironlake_update_plane], Writing base 01263000 00000000 0 0 7680
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:drm_crtc_helper_set_mode], [ENCODER:8:LVDS-8] set [MODE:25:]
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[drm:gen6_fdi_link_train], FDI train 1 done.
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[drm:gen6_fdi_link_train], FDI train 2 done.
[drm:gen6_fdi_link_train], FDI train done.
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config], 	[CONNECTOR:7:LVDS-1] set DPMS on
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:drm_mode_addfb], [FB:25]
[drm:drm_mode_setcrtc], [CRTC:3]
[drm:drm_mode_setcrtc], [CONNECTOR:7:LVDS-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [FB:25] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:ironlake_update_plane], Writing base 01A63000 00000000 0 0 12800
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:drm_mode_setcrtc], [CRTC:5]
[drm:drm_mode_setcrtc], [CONNECTOR:20:DP-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:25] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:ironlake_update_plane], Writing base 01A63000 00000000 0 0 12800
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:drm_mode_setcrtc], [CRTC:5]
[drm:drm_mode_setcrtc], [CONNECTOR:20:DP-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:5] [FB:25] #connectors=1 (x y) (1920 56)
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 22:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 26:"" 0 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1] to [CRTC:3]
[drm:drm_crtc_helper_set_config], [CONNECTOR:20:DP-1] to [CRTC:5]
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 26:"" 0 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm:intel_dp_mode_fixup], Display port link bw 0a lane count 2 clock 270000
[drm:drm_crtc_helper_set_mode], [CRTC:5]
[drm:intel_dp_link_down], 
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 8, cursor: 6
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 8)
[drm:ironlake_crtc_mode_set], Mode for pipe 1:
[drm:drm_mode_debug_printmodeline], Modeline 26:"" 0 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x0 0x5
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:ironlake_update_plane], Writing base 01A63000 000B0E00 1920 56 12800
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 8, cursor: 6
[drm:drm_crtc_helper_set_mode], [ENCODER:21:TMDS-21] set [MODE:26:]
[drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 8, cursor: 6
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:intel_wait_for_vblank], vblank wait timed out
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[drm:gen6_fdi_link_train], FDI train 1 done.
[drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[drm:gen6_fdi_link_train], FDI train 2 done.
[drm:gen6_fdi_link_train], FDI train done.
[drm:intel_update_fbc], 
[drm:intel_update_fbc], more than one pipe active, disabling compression
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], too many full retries, give up
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], too many full retries, give up
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], too many full retries, give up
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], too many full retries, give up
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], too many full retries, give up
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], too many full retries, give up
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[drm:intel_dp_start_link_train], training pattern 1 signal levels 06000000
[drm:intel_dp_start_link_train], too many full retries, give up
[drm:intel_dp_complete_link_train] *ERROR* failed to train DP, aborting
[drm:intel_dp_link_down], 
[drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config], 	[CONNECTOR:20:DP-1] set DPMS on
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:intel_prepare_page_flip], preparing flip with no unpin work?
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
wlan0: authenticate with d8:c7:c8:ad:e3:a9
wlan0: send auth to d8:c7:c8:ad:e3:a9 (try 1/3)
wlan0: send auth to d8:c7:c8:ad:e3:a9 (try 2/3)
wlan0: authenticated
wlan0: associate with d8:c7:c8:ad:e3:a9 (try 1/3)
wlan0: RX AssocResp from d8:c7:c8:ad:e3:a9 (capab=0x401 status=0 aid=4)
wlan0: associated
wlan0: Wrong control channel in association response: configured center-freq: 5180 hti-cfreq: 5540  hti->control_chan: 108 band: 1.  Disabling HT.
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
wlan0: authenticate with d8:c7:c8:ad:e3:a1
wlan0: send auth to d8:c7:c8:ad:e3:a1 (try 1/3)
wlan0: authenticated
wlan0: waiting for beacon from d8:c7:c8:ad:e3:a1
wlan0: associate with d8:c7:c8:ad:e3:a1 (try 1/3)
wlan0: RX AssocResp from d8:c7:c8:ad:e3:a1 (capab=0x421 status=0 aid=2)
wlan0: associated
wlan0: Wrong control channel in association response: configured center-freq: 2412 hti-cfreq: 2462  hti->control_chan: 11 band: 0.  Disabling HT.
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:14:VGA-1] status updated from 2 to 2
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:output_poll_execute], [CONNECTOR:17:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:output_poll_execute], [CONNECTOR:20:DP-1] status updated from 1 to 1
[drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
wlan0: no IPv6 routers present
[drm:i915_driver_open], 
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1080" 60 140000 1920 1968 2000 2096 1080 1083 1088 1113 0x48 0xa
[drm:drm_mode_getconnector], [CONNECTOR:7:?]
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:14:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:17:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1]
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:17:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1]
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:drm_edid_to_eld], ELD: no CEA Extension found
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 55:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[drm:drm_mode_debug_printmodeline], Modeline 58:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 56:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 60:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 59:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 54:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 57:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 53:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 52:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 49:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 51:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[drm:drm_mode_debug_printmodeline], Modeline 50:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 48:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 47:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 46:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 44:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 41:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 45:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 40:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 39:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 38:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 30:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[drm:drm_mode_getconnector], [CONNECTOR:20:?]
[drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:14:VGA-1] status updated from 2 to 2
[drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[drm:output_poll_execute], [CONNECTOR:17:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 110a824100030181
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[drm:output_poll_execute], [CONNECTOR:20:DP-1] status updated from 1 to 1
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 

--------------080302020805010102020801--
