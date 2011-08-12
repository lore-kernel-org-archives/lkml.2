Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1HLNlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:41:18 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:52988 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1HLNlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:41:16 -0400
X-Greylist: delayed 2526 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Aug 2011 09:41:15 EDT
Date: Fri, 12 Aug 2011 14:58:18 +0200
From: "Udo A. Steinberg" <udo@hypervisor.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: iommu@lists.linux-foundation.org, David Woodhouse <dwmw2@infradead.org>
Subject: Kernel panic with intel_iommu=on
Message-ID: <20110812145818.00cde392@laptop.anywhere.org>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

After upgrading from firefox 5.0.1 to 6.0b5, my machine locks up hard, the
moment firefox is started under Linux 3.0 with Intel IOMMU enabled.

With intel_iommu=off, everything works fine. Likewise, when going back to
firefox 5.0.1, everything works fine. I've managed to capture the following
kernel output via the serial console.

Kernel panic - not syncing: DMAR hardware is malfunctioning                                                                                                                                                      
                                                                                                                                                                                                                 
Pid: 0, comm: swapper Not tainted 3.0.0 #1                                                                                                                                                                       
Call Trace:                                                                                                                                                                                                      
 [<c132ffb8>] ? panic+0x4d/0x12b                                                                                                                                                                                 
 [<c112d889>] ? __iommu_flush_iotlb+0x199/0x1ce                                                                                                                                                                  
 [<c112f0e5>] ? flush_unmaps+0xe5/0xe5                                                                                                                                                                           
 [<c112f05d>] ? flush_unmaps+0x5d/0xe5                                                                                                                                                                           
 [<c112f0e5>] ? flush_unmaps+0xe5/0xe5                                                                                                                                                                           
 [<c112f0f7>] ? flush_unmaps_timeout+0x12/0x1f                                                                                                                                                                   
 [<c102f445>] ? run_timer_softirq+0x139/0x1b2                                                                                                                                                                    
 [<c102b303>] ? __do_softirq+0x68/0xe0                                                                                                                                                                           
 [<c102b29b>] ? local_bh_enable_ip+0x6a/0x6a                                                                                                                                                                     
 <IRQ>  [<c102b4cd>] ? irq_exit+0x32/0x84                                                                                                                                                                        
 [<c101363f>] ? smp_apic_timer_interrupt+0x69/0x73                                                                                                                                                               
 [<c1332072>] ? apic_timer_interrupt+0x2a/0x30                                                                                                                                                                   
 [<c100708d>] ? mwait_idle+0x47/0x4c                                                                                                                                                                             
 [<c1001467>] ? cpu_idle+0x41/0x5b                                                                                                                                                                               
 [<c14b45c0>] ? start_kernel+0x258/0x25d      

Any suggestions on how to debug what exactly is going wrong?

The board is an Intel DQ35JO with Bearlake-Q chipset. I'm running

xorg-server-1.9.5
xf86-video-intel-2.15.0
libdrm-2.4.25

Below the output of the kernel with intel_iommu=off.

Initializing cgroup subsys cpu
Linux version 3.0.0 (root@weybridge) (gcc version 4.5.3 (GCC) ) #1 SMP Sun
Jul 24 14:26:51 CEST 2011 BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
 BIOS-e820: 000000000008f000 - 0000000000090000 (reserved)
 BIOS-e820: 0000000000090000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003e02f000 (usable)
 BIOS-e820: 000000003e02f000 - 000000003e031000 (reserved)
 BIOS-e820: 000000003e031000 - 000000003e113000 (usable)
 BIOS-e820: 000000003e113000 - 000000003e1e3000 (ACPI NVS)
 BIOS-e820: 000000003e1e3000 - 000000003e1e8000 (usable)
 BIOS-e820: 000000003e1e8000 - 000000003e1f2000 (ACPI data)
 BIOS-e820: 000000003e1f2000 - 000000003e1f3000 (usable)
 BIOS-e820: 000000003e1f3000 - 000000003e1ff000 (ACPI data)
 BIOS-e820: 000000003e1ff000 - 000000003e200000 (usable)
 BIOS-e820: 000000003e200000 - 000000003f000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f8000000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI 2.4 present.
DMI:                  /DQ35JO, BIOS JOQ3510J.86A.1143.2010.1209.0048
12/09/2010 e820 update range: 0000000000000000 - 0000000000010000 (usable)
==> (reserved) e820 remove range: 00000000000a0000 - 0000000000100000
(usable) last_pfn = 0x3e200 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-DFFFF write-protect
  E0000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 000000000 mask FC0000000 write-back
  1 base 03E200000 mask FFFE00000 uncachable
  2 base 03E400000 mask FFFC00000 uncachable
  3 base 03E800000 mask FFF800000 uncachable
  4 base 03F000000 mask FFF000000 uncachable
  5 disabled
  6 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 01800000
Base memory trampoline at [c0099000] 99000 size 16384
init_memory_mapping: 0000000000000000-00000000377fe000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037400000 page 2M
 0037400000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 17fb000-1800000
ACPI: RSDP 000fe020 00014 (v00 INTEL )
ACPI: RSDT 3e1fd038 00068 (v01 INTEL  DQ3510J  00000477      01000013)
ACPI: FACP 3e1fc000 00074 (v01 INTEL  DQ3510J  00000477 MSFT 01000013)
ACPI: DSDT 3e1f8000 03D84 (v01 INTEL  DQ3510J  00000477 MSFT 01000013)
ACPI: FACS 3e186000 00040
ACPI: APIC 3e1f7000 00078 (v01 INTEL  DQ3510J  00000477 MSFT 01000013)
ACPI: WDDT 3e1f6000 00040 (v01 INTEL  DQ3510J  00000477 MSFT 01000013)
ACPI: MCFG 3e1f5000 0003C (v01 INTEL  DQ3510J  00000477 MSFT 01000013)
ACPI: ASF! 3e1f4000 000A6 (v32 INTEL  DQ3510J  00000477 MSFT 01000013)
ACPI: HPET 3e1f3000 00038 (v01 INTEL  DQ3510J  00000477 MSFT 01000013)
ACPI: DMAR 3e1f1000 000F8 (v01 INTEL  DQ3510J  00000477 MSFT 01000013)
ACPI: ASPT 3e1f0000 00034 (v03 INTEL  DQ3510J  00000477 MSFT 01000013)
ACPI: WDTT 3e1ef000 002CC (v01 INTEL  DQ3510J  00000477 MSFT 01000013)
ACPI: SSDT 3e1ee000 00204 (v01 INTEL     CpuPm 00000477 MSFT 01000013)
ACPI: SSDT 3e1ed000 001F9 (v01 INTEL   Cpu0Ist 00000477 MSFT 01000013)
ACPI: SSDT 3e1ec000 001F9 (v01 INTEL   Cpu1Ist 00000477 MSFT 01000013)
ACPI: SSDT 3e1eb000 000DD (v01 INTEL   Cpu0Cst 00000477 MSFT 01000013)
ACPI: SSDT 3e1ea000 000DD (v01 INTEL   Cpu1Cst 00000477 MSFT 01000013)
ACPI: SSDT 3e1e9000 000DD (v01 INTEL   Cpu2Cst 00000477 MSFT 01000013)
ACPI: SSDT 3e1e8000 000DD (v01 INTEL   Cpu3Cst 00000477 MSFT 01000013)
ACPI: TCPA 3e114000 00032 (v02 INTEL  TIANO    00000002 MSFT 01000013)
ACPI: Local APIC address 0xfee00000
106MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0003e200
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0: 0x00000010 -> 0x0000008f
    0: 0x00000090 -> 0x0000009d
    0: 0x00000100 -> 0x0003e02f
    0: 0x0003e031 -> 0x0003e113
    0: 0x0003e1e3 -> 0x0003e1e8
    0: 0x0003e1f2 -> 0x0003e1f3
    0: 0x0003e1ff -> 0x0003e200
On node 0 totalpages: 254116
free_area_init_node: node 0, pgdat c14ad900, node_mem_map f7035200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3948 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 213 pages used for memmap
  HighMem zone: 26693 pages, LIFO batch:7
Using APIC driver default
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
4 Processors exceeds NR_CPUS limit of 2
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000008f000 - 0000000000090000
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 3f000000 (gap: 3f000000:b1000000)
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 9 pages/cpu @f6c00000 s23168 r0 d13696 u2097152
pcpu-alloc: s23168 r0 d13696 u2097152 alloc=1*4194304
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 252127
Kernel command line: root=/dev/sda1 intel_iommu=off console=ttyS0,115200,8N1
Intel-IOMMU: disabled
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:0003e200)
Memory: 1002112k/1017856k available (3277k kernel code, 14352k reserved,
1536k data, 332k init, 107624k highmem) virtual kernel memory layout:
    fixmap  : 0xfff8f000 - 0xfffff000   ( 448 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc14b4000 - 0xc1507000   ( 332 kB)
      .data : 0xc133351d - 0xc14b3840   (1536 kB)
      .text : 0xc1000000 - 0xc133351d   (3277 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:320
CPU 0 irqstacks, hard=f680c000 soft=f680e000
Console: colour VGA+ 80x25
console [ttyS0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2989.547 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency..
5979.09 BogoMIPS (lpj=29895470) pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20110413
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz stepping 06
Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
CPU 1 irqstacks, hard=f686a000 soft=f686c000
Booting Node   0, Processors  #1 Ok.
smpboot cpu 1: start_ip = 99000
Initializing CPU#1
Brought up 2 CPUs
Total of 2 processors activated (11958.09 BogoMIPS).
PM: Registering ACPI NVS region at 3e113000 (851968 bytes)
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff]
(base 0xf0000000) PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in
E820 PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and
report a bug ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A03:00: host bridge window [mem 0x000e0000-0x000effff]
pci_root PNP0A03:00: host bridge window [mem 0xf8000000-0xfeafffff]
pci_root PNP0A03:00: host bridge window [mem 0x40000000-0xefffffff]
pci 0000:00:00.0: [8086:29b0] type 0 class 0x000600
pci 0000:00:02.0: [8086:29b2] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0x50480000-0x504fffff]
pci 0000:00:02.0: reg 14: [io  0x2430-0x2437]
pci 0000:00:02.0: reg 18: [mem 0x40000000-0x4fffffff pref]
pci 0000:00:02.0: reg 1c: [mem 0x50300000-0x503fffff]
pci 0000:00:02.1: [8086:29b3] type 0 class 0x000380
pci 0000:00:02.1: reg 10: [mem 0x50400000-0x5047ffff]
pci 0000:00:03.0: [8086:29b4] type 0 class 0x000780
pci 0000:00:03.0: reg 10: [mem 0x50526100-0x5052610f 64bit]
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:19.0: [8086:10bd] type 0 class 0x000200
pci 0000:00:19.0: reg 10: [mem 0x50500000-0x5051ffff]
pci 0000:00:19.0: reg 14: [mem 0x50524000-0x50524fff]
pci 0000:00:19.0: reg 18: [io  0x2400-0x241f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
pci 0000:00:1a.0: reg 20: [io  0x20e0-0x20ff]
pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
pci 0000:00:1a.1: reg 20: [io  0x20c0-0x20df]
pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
pci 0000:00:1a.2: reg 20: [io  0x20a0-0x20bf]
pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
pci 0000:00:1a.7: reg 10: [mem 0x50525c00-0x50525fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0x50520000-0x50523fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: [8086:2944] type 1 class 0x000604
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1c.4: [8086:2948] type 1 class 0x000604
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x2080-0x209f]
pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x2060-0x207f]
pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x2040-0x205f]
pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0x50525800-0x50525bff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
pci 0000:00:1f.0: [8086:2914] type 0 class 0x000601
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
pci 0000:00:1f.2: [8086:2922] type 0 class 0x000106
pci 0000:00:1f.2: reg 10: [io  0x2428-0x242f]
pci 0000:00:1f.2: reg 14: [io  0x243c-0x243f]
pci 0000:00:1f.2: reg 18: [io  0x2420-0x2427]
pci 0000:00:1f.2: reg 1c: [io  0x2438-0x243b]
pci 0000:00:1f.2: reg 20: [io  0x2020-0x203f]
pci 0000:00:1f.2: reg 24: [mem 0x50525000-0x505257ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
pci 0000:00:1f.3: reg 10: [mem 0x50526000-0x505260ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x2000-0x201f]
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1c.1: PCI bridge to [bus 02-02]
pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:03:00.0: [11ab:6101] type 0 class 0x000101
pci 0000:03:00.0: reg 10: [io  0x1018-0x101f]
pci 0000:03:00.0: reg 14: [io  0x1024-0x1027]
pci 0000:03:00.0: reg 18: [io  0x1010-0x1017]
pci 0000:03:00.0: reg 1c: [io  0x1020-0x1023]
pci 0000:03:00.0: reg 20: [io  0x1000-0x100f]
pci 0000:03:00.0: reg 24: [mem 0x50200000-0x502001ff]
pci 0000:03:00.0: supports D1
pci 0000:03:00.0: PME# supported from D0 D1 D3hot
pci 0000:03:00.0: PME# disabled
pci 0000:00:1c.2: PCI bridge to [bus 03-03]
pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.2:   bridge window [mem 0x50200000-0x502fffff]
pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1c.3: PCI bridge to [bus 04-04]
pci 0000:00:1c.3:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1c.4: PCI bridge to [bus 05-05]
pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:06:00.0: [109e:036e] type 0 class 0x000400
pci 0000:06:00.0: reg 10: [mem 0x50001000-0x50001fff pref]
pci 0000:06:00.1: [109e:0878] type 0 class 0x000480
pci 0000:06:00.1: reg 10: [mem 0x50000000-0x50000fff pref]
pci 0000:06:03.0: [11c1:5811] type 0 class 0x000c00
pci 0000:06:03.0: reg 10: [mem 0x50100000-0x50100fff]
pci 0000:06:03.0: supports D1 D2
pci 0000:06:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:06:03.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 06-06] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0x50100000-0x501fffff]
pci 0000:00:1e.0:   bridge window [mem 0x50000000-0x500fffff 64bit pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive
decode) pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000effff]
(subtractive decode) pci 0000:00:1e.0:   bridge window [mem
0xf8000000-0xfeafffff] (subtractive decode) pci 0000:00:1e.0:   bridge
window [mem 0x40000000-0xefffffff] (subtractive decode) pci_bus 0000:00: on
NUMA node 0 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask:
0x1d ACPI _OSC control for PCIe not granted, disabling ASPM
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Version 1.0.24.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000008f000 - 000000000008ffff 
reserve RAM buffer: 000000000009dc00 - 000000000009ffff 
reserve RAM buffer: 000000003e02f000 - 000000003fffffff 
reserve RAM buffer: 000000003e113000 - 000000003fffffff 
reserve RAM buffer: 000000003e1e8000 - 000000003fffffff 
reserve RAM buffer: 000000003e1f3000 - 000000003fffffff 
reserve RAM buffer: 000000003e200000 - 000000003fffffff 
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000e0000-0x000effff window]
pnp 00:00: [mem 0xf8000000-0xfeafffff window]
pnp 00:00: [mem 0x40000000-0xefffffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: [mem 0xf0000000-0xf7ffffff]
pnp 00:01: [mem 0xfeb00000-0xfeb03fff]
pnp 00:01: [mem 0xfed13000-0xfed13fff]
pnp 00:01: [mem 0xfed14000-0xfed17fff]
pnp 00:01: [mem 0xfed18000-0xfed18fff]
pnp 00:01: [mem 0xfed19000-0xfed19fff]
pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
pnp 00:01: [mem 0xfed20000-0xfed3ffff]
pnp 00:01: [mem 0xfed45000-0xfed99fff]
pnp 00:01: [mem 0x000c0000-0x000dffff]
pnp 00:01: [mem 0x000e0000-0x000fffff]
pnp 00:01: [mem 0xffc00000-0xffffffff]
system 00:01: [mem 0xf0000000-0xf7ffffff] has been reserved
Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #0
system 00:01: [mem 0xfeb00000-0xfeb03fff] has been reserved
system 00:01: [mem 0xfed13000-0xfed13fff] has been reserved
system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:01: [mem 0xfed45000-0xfed99fff] has been reserved
system 00:01: [mem 0x000c0000-0x000dffff] could not be reserved
system 00:01: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:01: [mem 0xffc00000-0xffffffff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: [io  0x0000-0x000f]
pnp 00:02: [io  0x0081-0x0083]
pnp 00:02: [io  0x0087]
pnp 00:02: [io  0x0089-0x008b]
pnp 00:02: [io  0x008f]
pnp 00:02: [io  0x00c0-0x00df]
pnp 00:02: [dma 4]
pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:03: [io  0x0070-0x0071]
pnp 00:03: [io  0x0074-0x0077]
pnp 00:03: [irq 8]
pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:04: [io  0x00f0]
pnp 00:04: [irq 13]
pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:05: [io  0x0061]
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: [io  0x0500-0x053f]
pnp 00:06: [io  0x0400-0x047f]
pnp 00:06: [io  0x0092]
pnp 00:06: [io  0x0680-0x06ff]
pnp 00:06: [io  0x0010-0x001f]
pnp 00:06: [io  0x0072-0x0073]
pnp 00:06: [io  0x0080]
pnp 00:06: [io  0x0084-0x0086]
pnp 00:06: [io  0x0088]
pnp 00:06: [io  0x008c-0x008e]
pnp 00:06: [io  0x0090-0x009f]
system 00:06: [io  0x0500-0x053f] has been reserved
system 00:06: [io  0x0400-0x047f] has been reserved
system 00:06: [io  0x0680-0x06ff] has been reserved
system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:07: [mem 0xfed40000-0xfed44fff]
pnp 00:07: Plug and Play ACPI device, IDs WEC1000 PNP0c31 (active)
pnp 00:08: [io  0x0060]
pnp 00:08: [io  0x0064]
system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:09: [io  0x03f8-0x03ff]
pnp 00:09: [irq 4]
pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0a: [mem 0xfec00000-0xfec000ff]
pnp 00:0a: Plug and Play ACPI device, IDs PNP0003 (active)
pnp 00:0b: [mem 0xfed00000-0xfed03fff]
pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
PCI: max bus depth: 1 pci_try_num: 2
pci 0000:00:1c.4: BAR 8: assigned [mem 0xf8000000-0xf81fffff]
pci 0000:00:1c.4: BAR 9: assigned [mem 0xf8200000-0xf83fffff 64bit pref]
pci 0000:00:1c.4: BAR 7: assigned [io  0x3000-0x3fff]
pci 0000:00:1c.3: BAR 8: assigned [mem 0xf8400000-0xf85fffff]
pci 0000:00:1c.3: BAR 9: assigned [mem 0xf8600000-0xf87fffff 64bit pref]
pci 0000:00:1c.3: BAR 7: assigned [io  0x4000-0x4fff]
pci 0000:00:1c.2: BAR 9: assigned [mem 0xf8800000-0xf89fffff 64bit pref]
pci 0000:00:1c.1: BAR 8: assigned [mem 0xf8a00000-0xf8bfffff]
pci 0000:00:1c.1: BAR 9: assigned [mem 0xf8c00000-0xf8dfffff 64bit pref]
pci 0000:00:1c.1: BAR 7: assigned [io  0x5000-0x5fff]
pci 0000:00:1c.0: BAR 8: assigned [mem 0xf8e00000-0xf8ffffff]
pci 0000:00:1c.0: BAR 9: assigned [mem 0xf9000000-0xf91fffff 64bit pref]
pci 0000:00:1c.0: BAR 7: assigned [io  0x6000-0x6fff]
pci 0000:00:1c.0: PCI bridge to [bus 01-01]
pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
pci 0000:00:1c.0:   bridge window [mem 0xf8e00000-0xf8ffffff]
pci 0000:00:1c.0:   bridge window [mem 0xf9000000-0xf91fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 02-02]
pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
pci 0000:00:1c.1:   bridge window [mem 0xf8a00000-0xf8bfffff]
pci 0000:00:1c.1:   bridge window [mem 0xf8c00000-0xf8dfffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 03-03]
pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.2:   bridge window [mem 0x50200000-0x502fffff]
pci 0000:00:1c.2:   bridge window [mem 0xf8800000-0xf89fffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 04-04]
pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.3:   bridge window [mem 0xf8400000-0xf85fffff]
pci 0000:00:1c.3:   bridge window [mem 0xf8600000-0xf87fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 05-05]
pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.4:   bridge window [mem 0xf8000000-0xf81fffff]
pci 0000:00:1c.4:   bridge window [mem 0xf8200000-0xf83fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 06-06]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem 0x50100000-0x501fffff]
pci 0000:00:1e.0:   bridge window [mem 0x50000000-0x500fffff 64bit pref]
pci 0000:00:1c.0: enabling device (0000 -> 0003)
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: enabling device (0000 -> 0003)
pci 0000:00:1c.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.3: enabling device (0000 -> 0003)
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1c.4: enabling device (0000 -> 0003)
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000e0000-0x000effff]
pci_bus 0000:00: resource 8 [mem 0xf8000000-0xfeafffff]
pci_bus 0000:00: resource 9 [mem 0x40000000-0xefffffff]
pci_bus 0000:01: resource 0 [io  0x6000-0x6fff]
pci_bus 0000:01: resource 1 [mem 0xf8e00000-0xf8ffffff]
pci_bus 0000:01: resource 2 [mem 0xf9000000-0xf91fffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0x5000-0x5fff]
pci_bus 0000:02: resource 1 [mem 0xf8a00000-0xf8bfffff]
pci_bus 0000:02: resource 2 [mem 0xf8c00000-0xf8dfffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:03: resource 1 [mem 0x50200000-0x502fffff]
pci_bus 0000:03: resource 2 [mem 0xf8800000-0xf89fffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:04: resource 1 [mem 0xf8400000-0xf85fffff]
pci_bus 0000:04: resource 2 [mem 0xf8600000-0xf87fffff 64bit pref]
pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:05: resource 1 [mem 0xf8000000-0xf81fffff]
pci_bus 0000:05: resource 2 [mem 0xf8200000-0xf83fffff 64bit pref]
pci_bus 0000:06: resource 1 [mem 0x50100000-0x501fffff]
pci_bus 0000:06: resource 2 [mem 0x50000000-0x500fffff 64bit pref]
pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:06: resource 7 [mem 0x000e0000-0x000effff]
pci_bus 0000:06: resource 8 [mem 0xf8000000-0xfeafffff]
pci_bus 0000:06: resource 9 [mem 0x40000000-0xefffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
DMAR: Host address width 36
DMAR: DRHD base: 0x000000feb00000 flags: 0x0
IOMMU 0: reg_base_addr feb00000 ver 1:0 cap c9008020a30270 ecap 1000
DMAR: DRHD base: 0x000000feb01000 flags: 0x0
IOMMU 1: reg_base_addr feb01000 ver 1:0 cap c0000020230270 ecap 1000
DMAR: DRHD base: 0x000000feb03000 flags: 0x1
IOMMU 2: reg_base_addr feb03000 ver 1:0 cap c9008020230270 ecap 1000
DMAR: RMRR base: 0x000000000e0000 end: 0x000000000effff
DMAR: RMRR base: 0x0000003e600000 end: 0x0000003effffff
DMAR: No ATSR found
microcode: CPU0 sig=0x10676, pf=0x1, revision=0x60c
microcode: CPU1 sig=0x10676, pf=0x1, revision=0x60c
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>,
Peter Oruba highmem bounce pool size: 64 pages
NTFS driver 2.1.30 [Flags: R/O].
msgmni has been set to 1747
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.2: setting latency timer to 64
pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
pcieport 0000:00:1c.3: setting latency timer to 64
pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
pcieport 0000:00:1c.4: setting latency timer to 64
pcieport 0000:00:1c.4: irq 44 for MSI/MSI-X
intel_idle: MWAIT substates: 0x22220
intel_idle: does not run on family 6 model 23
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
Monitor-Mwait will be used to enter C-1 state
Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
lp: driver loaded but no devices found
Real Time Clock Driver v1.12b
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel Q35 Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K
mappable agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x40000000
tpm_tis 00:07: 1.2 TPM (device-id 0xFE, rev-id 70)
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
i915 0000:00:02.0: irq 45 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem [drm]
initialized overlay support fbcon: inteldrmfb (fb0) is primary device
Refined TSC clocksource calibration: 2989.488 MHz.
Switching to clocksource tsc
Console: switching to colour frame buffer device 240x75
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
floppy0: no floppy controllers found
loop: module loaded
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT A -> GSI 21 (level, low) -> IRQ 21
ahci 0000:00:1f.2: irq 46 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pmp pio slum part ccc
ems ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0x50525000 port 0x50525100 irq 46
ata2: SATA max UDMA/133 abar m2048@0x50525000 port 0x50525180 irq 46
ata3: SATA max UDMA/133 abar m2048@0x50525000 port 0x50525200 irq 46
ata4: SATA max UDMA/133 abar m2048@0x50525000 port 0x50525280 irq 46
ata5: SATA max UDMA/133 abar m2048@0x50525000 port 0x50525300 irq 46
ata6: SATA max UDMA/133 abar m2048@0x50525000 port 0x50525380 irq 46
pata_marvell 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pata_marvell 0000:03:00.0: setting latency timer to 64
scsi6 : pata_marvell
scsi7 : pata_marvell
ata7: PATA max UDMA/100 cmd 0x1018 ctl 0x1024 bmdma 0x1000 irq 18
ata8: DUMMY
e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 47 for MSI/MSI-X
ata2: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata1.00: ATA-7: SAMSUNG HD103UJ, 1AA01109, max UDMA7
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1c:c0:2e:d8:b2
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 6, PBA No: FFFFFF-0FF
firewire_ohci 0000:06:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
firewire_ohci: Added fw-ohci device 0000:06:03.0, OHCI v1.0, 8 IR + 8 IT
contexts, quirks 0x0 sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 17 (level, low) -> IRQ 17
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: irq 17, io mem 0x50525c00
sd 0:0:0:0: Attached scsi generic sg0 type 0
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50525800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 18, io base 0x000020e0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x000020c0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 17, io base 0x000020a0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
i8042: PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input2
i2c /dev entries driver
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 18 (level, low) -> IRQ 18
lirc_dev: IR Remote Control driver registered, major 253 
IR RC5(x) protocol handler initialized
Linux video capture interface: v2.00
i2c-core: driver [tuner] using legacy suspend method
 sda: sda1 sda2 sda3 < sda5 sda6 >
i2c-core: driver [tuner] using legacy resume method
sd 0:0:0:0: [sda] Attached SCSI disk
i2c-core: driver [msp3400] using legacy suspend method
i2c-core: driver [msp3400] using legacy resume method
bttv: driver version 0.9.18 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv 0000:06:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
bttv0: Bt878 (rev 2) at 0000:06:00.0, irq: 21, latency: 32, mmio: 0x50001000
bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=10,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
tveeprom 16-0050: Hauppauge model 37284, rev B221, serial# 3546046
tveeprom 16-0050: tuner model is Philips FM1216 (idx 21, type 5)
tveeprom 16-0050: TV standards PAL(B/G) (eeprom 0x04)
tveeprom 16-0050: audio processor is MSP3410D (idx 5)
tveeprom 16-0050: has radio
bttv0: Hauppauge eeprom indicates model#37284
bttv0: tuner type=5
usb 2-5: new high speed USB device number 3 using ehci_hcd
msp3400 16-0040: MSP3410D-B4 found @ 0x80 (bt878 #0 [sw])
msp3400 16-0040: msp3400 supports nicam, mode is autodetect
tda9887 16-0042: creating new instance
tda9887 16-0042: tda988[5/6/7] found
tuner 16-0042: Tuner 74 found with type(s) Radio TV.
tuner 16-0061: Tuner -1 found with type(s) Radio TV.
tuner-simple 16-0061: creating new instance
tuner-simple 16-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
bttv0: PLL: 28636363 => 35468950 .
firewire_core: created device fw0: GUID 0090270001fbb355, S400
. ok
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v1.1.0)
Registered IR keymap rc-hauppauge
input: i2c IR (Hauppauge) as /devices/virtual/rc/rc0/input3
rc0: i2c IR (Hauppauge) as /devices/virtual/rc/rc0
ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-16/16-0018/ir0 [bt878 #0 [sw]]
device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised:
dm-devel@redhat.com cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
Bt87x 0000:06:00.1: PCI INT A -> GSI 21 (level, low) -> IRQ 21
bt87x0: Using board 1, analog, digital (rate 32000 Hz)
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: irq 48 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: ALC268: BIOS auto-probing.
autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
   speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
   hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
   mono: mono_out=0x0
   inputs: Rear Mic=0x18 Front Mic=0x1a Line=0x19
realtek: No valid SSID, checking pincfg 0x411111f0 for NID 0x1d
realtek: Enable default setup for auto mode as fallback
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input4
input: HDA Intel Headphone
as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5 uvcvideo: Found UVC
1.00 device <unnamed> (046d:0990) input: UVC Camera (046d:0990)
as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5:1.0/input/input6 usb 7-2:
new low speed USB device number 2 using uhci_hcd 5:2: cannot get min/max
values for control 2 (id 5) 5:2: cannot get min/max values for control 2 (id
5) usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  #0: HDA Intel at 0x50520000 irq 48
  #1: Brooktree Bt878 at 0x50000000, irq 21
  #2: Logitech, Inc. QuickCam Pro 9000 at usb-0000:00:1d.7-5, high speed
TCP cubic registered
NET: Registered protocol family 17
Using IPI No-Shortcut mode
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
EXT3-fs (sda1): recovery required on readonly filesystem
EXT3-fs (sda1): write access will be enabled during recovery
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda1): recovery complete
EXT3-fs (sda1): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
input: Microsoft Comfort Curve Keyboard 2000
as /devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.0/input/input7 Freeing
unused kernel memory: 332k freed Write protecting the kernel text: 3280k
Write protecting the kernel read-only data: 1232k
generic-usb 0003:045E:00DD.0001: input: USB HID v1.11 Keyboard [Microsoft
Comfort Curve Keyboard 2000] on usb-0000:00:1d.1-2/input0 input: Microsoft
Comfort Curve Keyboard 2000
as /devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.1/input/input8
generic-usb 0003:045E:00DD.0002: input: USB HID v1.11 Device [Microsoft
Comfort Curve Keyboard 2000] on usb-0000:00:1d.1-2/input1 usb 8-2: new low
speed USB device number 2 using uhci_hcd input: Microsoft Basic Optical
Mouse as /devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input9
generic-usb 0003:045E:0083.0003: input: USB HID v1.10 Mouse [Microsoft Basic
Optical Mouse] on usb-0000:00:1d.2-2/input0 Adding 8016428k swap
on /dev/mapper/swap.  Priority:-1 extents:1 across:8016428k EXT3-fs (sda1):
using internal journal kjournald starting.  Commit interval 5 seconds
EXT3-fs (dm-1): using internal journal EXT3-fs (dm-1): mounted filesystem
with writeback data mode kjournald starting.  Commit interval 5 seconds
EXT3-fs (dm-2): using internal journal EXT3-fs (dm-2): mounted filesystem
with writeback data mode e1000e 0000:00:19.0: irq 47 for MSI/MSI-X e1000e
0000:00:19.0: irq 47 for MSI/MSI-X e1000e: eth0 NIC Link is Up 100 Mbps Full
Duplex, Flow Control: Rx/Tx e1000e 0000:00:19.0: eth0: 10/100 speed:
disabling TSO

Cheers,

	- Udo
