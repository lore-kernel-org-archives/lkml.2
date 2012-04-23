Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab2DWVJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:09:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab2DWVJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:09:47 -0400
Message-ID: <4F95C50C.4060203@redhat.com>
Date: Mon, 23 Apr 2012 17:09:32 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Richard Yang <weiyang@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: One problem in reassign pci bus number?
References: <20120410090306.GA7056@richard>	<20120422155202.GA13540@richard>	<4F95B17B.3030401@redhat.com> <CAE9FiQX52eL6ZFQ_X3uL5DukK03sPhByZpPh0++o6L=WF8BGXg@mail.gmail.com>
In-Reply-To: <CAE9FiQX52eL6ZFQ_X3uL5DukK03sPhByZpPh0++o6L=WF8BGXg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040709020301090407070007"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040709020301090407070007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/23/2012 04:19 PM, Yinghai Lu wrote:
> On Mon, Apr 23, 2012 at 12:46 PM, Don Dutile<ddutile@redhat.com>  wrote:
>> I have run into a similar problem recently when trying to use
>> pci=assign-busses
>> with an SRIOV device behind a non-ARI-capable PCIe switch.
>> In this scenario, the assign-busses code assigned the next bus number,
>> which conflicted with an existing one on the system, and hangs the
>> system -- two bridges responding to the same PCI bus num evidently
>> confuses the hw! ;-)
>
> can you post boot log and lspci -vvxxx?
>
> Yinghai

Attached requested logs of linux-3.4-rc2 booted on RHEL6.2 installation.

I don't have a boot log of failing condition (pci=assign-devices)
b/c it wedges at boot, and the serial line doesn't output anything
even though I've tried every magic trick known with grub & kernel boot params.
... the PCI log btwn early boot and until the console is reconfigured is 'lost'
on the serial line, and that's when the hang occurs.
It's been 'fun' to debug w/o that serial output...

Let me know if you need something else. (lspci -t ?)



--------------040709020301090407070007
Content-Type: text/plain;
 name="dmesg-linux-3dot4dot0-rc2.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-linux-3dot4dot0-rc2.log"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.4.0-rc2+ (gcc version 4.4.6 20110731 (Red Hat 4.4.6-3) (GCC) ) #1 SMP Thu Apr 12 17:57:10 EDT 2012
Command line: ro root=/dev/mapper/vg_dhcp10019175-lv_root rd_LVM_LV=vg_dhcp10019175/lv_root rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us intel_iommu=on crashkernel=auto earlycon=uart82550,io,0x1030,115200 earlyprintk=serial,ttyS0,115200 console=tty0 console=ttyS0,115200n81 ignore_loglevel log_buf_len=8M
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
 BIOS-e820: 000000000008f000 - 0000000000090000 (reserved)
 BIOS-e820: 0000000000090000 - 000000000009d000 (usable)
 BIOS-e820: 000000000009d000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cf49d000 (usable)
 BIOS-e820: 00000000cf49d000 - 00000000cf4bf000 (reserved)
 BIOS-e820: 00000000cf4bf000 - 00000000cf662000 (usable)
 BIOS-e820: 00000000cf662000 - 00000000cf7bf000 (ACPI NVS)
 BIOS-e820: 00000000cf7bf000 - 00000000cf7db000 (usable)
 BIOS-e820: 00000000cf7db000 - 00000000cf7ff000 (ACPI data)
 BIOS-e820: 00000000cf7ff000 - 00000000cf800000 (usable)
 BIOS-e820: 00000000cf800000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000f8000000 - 00000000fd000000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000001b0000000 (usable)
bootconsole [earlyser0] enabled
debug: ignoring loglevel setting.
NX (Execute Disable) protection: active
DMI 2.5 present.
DMI:                  /DX58SO, BIOS SOX5810J.86A.5561.2011.0516.2023 05/16/2011
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x1b0000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-DFFFF write-protect
  E0000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 080000000 mask FC0000000 write-back
  2 base 0C0000000 mask FF0000000 write-back
  3 base 100000000 mask F80000000 write-back
  4 base 180000000 mask FE0000000 write-back
  5 base 1A0000000 mask FF0000000 write-back
  6 base 0FFFF0000 mask FFFFF0000 write-protect
  7 disabled
  8 disabled
  9 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xcf800 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff880000098000] 98000 size 20480
Using GB pages for direct mapping
init_memory_mapping: 0000000000000000-00000000cf800000
 0000000000 - 00c0000000 page 1G
 00c0000000 - 00cf800000 page 2M
kernel direct mapping tables up to cf800000 @ 1fffe000-20000000
init_memory_mapping: 0000000100000000-00000001b0000000
 0100000000 - 0180000000 page 1G
 0180000000 - 01b0000000 page 2M
kernel direct mapping tables up to 1b0000000 @ cf7d9000-cf7db000
log_buf_len: 8388608
early log buf free: 520997(99%)
RAMDISK: 3643c000 - 37ff0000
crashkernel: memory value expected
ACPI: RSDP 00000000000fe020 00024 (v02 INTEL )
ACPI: XSDT 00000000cf7fe120 00074 (v01 INTEL  DX58SO   000015B9      01000013)
ACPI: FACP 00000000cf7fd000 000F4 (v03 INTEL  DX58SO   000015B9 MSFT 0100000D)
ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0x0000000000000450/0x0 (20120320/tbfadt-579)
ACPI Warning: Invalid length for Pm2ControlBlock: 0, using default 8 (20120320/tbfadt-629)
ACPI: DSDT 00000000cf7f8000 04617 (v02 INTEL  DX58SO   000015B9 MSFT 0100000D)
ACPI: FACS 00000000cf724000 00040
ACPI: APIC 00000000cf7f7000 00138 (v02 INTEL  DX58SO   000015B9 MSFT 0100000D)
ACPI: WDDT 00000000cf7f6000 00040 (v01 INTEL  DX58SO   000015B9 MSFT 0100000D)
ACPI: MCFG 00000000cf7f5000 0003C (v01 INTEL  DX58SO   000015B9 MSFT 0100000D)
ACPI: ASF! 00000000cf7f4000 000AC (v32 INTEL  DX58SO   000015B9 MSFT 0100000D)
ACPI: HPET 00000000cf7f3000 00038 (v01 INTEL  DX58SO   000015B9 MSFT 0100000D)
ACPI: SSDT 00000000cf7de000 12344 (v01 INTEL  SSDT  PM 000015B9 MSFT 0100000D)
ACPI: DMAR 00000000cf7db000 00180 (v01 INTEL  DX58SO   000015B9 MSFT 0100000D)
ACPI: WDTT 00000000cf7f1000 0020C (v02 INTEL  DX58SO   000015B9 MSFT 0100000D)
ACPI: ASPT 00000000cf7f2000 00034 (v06 INTEL  PerfTune 000015B9 MSFT 0100000D)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-00000001b0000000
Initmem setup node 0 0000000000000000-00000001b0000000
  NODE_DATA [00000001af7da000 - 00000001af7fffff]
 [ffffea0000000000-ffffea0005ffffff] PMD -> [ffff8801a8e00000-ffff8801ae3fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x001b0000
Movable zone start PFN for each node
Early memory PFN ranges
    0: 0x00000010 -> 0x0000008f
    0: 0x00000090 -> 0x0000009d
    0: 0x00000100 -> 0x000cf49d
    0: 0x000cf4bf -> 0x000cf662
    0: 0x000cf7bf -> 0x000cf7db
    0: 0x000cf7ff -> 0x000cf800
    0: 0x00100000 -> 0x001b0000
On node 0 totalpages: 1570281
  DMA zone: 56 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3919 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 831125 pages, LIFO batch:31
  Normal zone: 9856 pages used for memmap
  Normal zone: 711040 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x11] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x13] enabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x15] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x07] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
SMP: Allowing 16 CPUs, 4 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000008f000 - 0000000000090000
PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000cf49d000 - 00000000cf4bf000
PM: Registered nosave memory: 00000000cf662000 - 00000000cf7bf000
PM: Registered nosave memory: 00000000cf7db000 - 00000000cf7ff000
PM: Registered nosave memory: 00000000cf800000 - 00000000d0000000
PM: Registered nosave memory: 00000000d0000000 - 00000000f8000000
PM: Registered nosave memory: 00000000f8000000 - 00000000fd000000
PM: Registered nosave memory: 00000000fd000000 - 00000000ffe00000
PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
Allocating PCI resources starting at d0000000 (gap: d0000000:28000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:1
PERCPU: Embedded 28 pages/cpu @ffff8801af400000 s83328 r8192 d23168 u131072
pcpu-alloc: s83328 r8192 d23168 u131072 alloc=1*2097152
pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1546084
Policy zone: Normal
Kernel command line: ro root=/dev/mapper/vg_dhcp10019175-lv_root rd_LVM_LV=vg_dhcp10019175/lv_root rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us intel_iommu=on crashkernel=auto earlycon=uart82550,io,0x1030,115200 earlyprintk=serial,ttyS0,115200 console=tty0 console=ttyS0,115200n81 ignore_loglevel log_buf_len=8M
Intel-IOMMU: enabled
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Memory: 6073004k/7077888k available (5214k kernel code, 796764k absent, 208120k reserved, 5955k data, 1460k init)
Hierarchical RCU implementation.
NR_IRQS:262400 nr_irqs:808 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled, bootconsole disabled
allocated 25165824 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
Fast TSC calibration using PIT
Detected 3378.027 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 6756.05 BogoMIPS (lpj=3378027)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
Initializing cgroup subsys perf_event
Initializing cgroup subsys net_prio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
ACPI: Core revision 20120320
ftrace: allocating 21140 entries in 83 pages
DMAR: Host address width 39
DMAR: DRHD base: 0x000000fe711000 flags: 0x0
IOMMU 0: reg_base_addr fe711000 ver 1:0 cap c9008010e60262 ecap f0207a
DMAR: DRHD base: 0x000000fe710000 flags: 0x1
IOMMU 1: reg_base_addr fe710000 ver 1:0 cap c90780106f0462 ecap f020fa
DMAR: RMRR base: 0x000000cf4aa000 end: 0x000000cf4aafff
DMAR: RMRR base: 0x000000cf4ab000 end: 0x000000cf4abfff
DMAR: RMRR base: 0x000000cf4ac000 end: 0x000000cf4acfff
DMAR: RMRR base: 0x000000cf4ad000 end: 0x000000cf4adfff
DMAR: RMRR base: 0x000000cf4a3000 end: 0x000000cf4a3fff
DMAR: RMRR base: 0x000000cf4a8000 end: 0x000000cf4a8fff
DMAR: RMRR base: 0x000000cf4a9000 end: 0x000000cf4a9fff
DMAR: RMRR base: 0x000000cf4a1000 end: 0x000000cf4a1fff
DMAR: RMRR base: 0x000000000ec000 end: 0x000000000eefff
IOAPIC id 8 under DRHD base  0xfe710000 IOMMU 1
Enabled IRQ remapping in xapic mode
Switched APIC routing to physical flat.
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM) i7 CPU       X 980  @ 3.33GHz stepping 02
Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
CPUID marked event: 'bus cycles' unavailable
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
NMI watchdog: enabled, takes one hw-pmu counter.
Booting Node   0, Processors  #1
NMI watchdog: enabled, takes one hw-pmu counter.
 #2
NMI watchdog: enabled, takes one hw-pmu counter.
 #3
NMI watchdog: enabled, takes one hw-pmu counter.
 #4
NMI watchdog: enabled, takes one hw-pmu counter.
 #5
NMI watchdog: enabled, takes one hw-pmu counter.
 #6
NMI watchdog: enabled, takes one hw-pmu counter.
 #7
NMI watchdog: enabled, takes one hw-pmu counter.
 #8
NMI watchdog: enabled, takes one hw-pmu counter.
 #9
NMI watchdog: enabled, takes one hw-pmu counter.
 #10
NMI watchdog: enabled, takes one hw-pmu counter.
 #11
NMI watchdog: enabled, takes one hw-pmu counter.
Brought up 12 CPUs
Total of 12 processors activated (81072.64 BogoMIPS).
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0xcf662000-0xcf7befff] (1429504 bytes)
dummy: 
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
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
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3d])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000c4000-0x000cbfff]
pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfedfffff]
pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xf7ffffff]
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000cbfff]
pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfedfffff]
pci_bus 0000:00: root bus resource [mem 0xd0000000-0xf7ffffff]
pci 0000:00:00.0: [8086:3405] type 00 class 0x060000
pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:10.0: [8086:3425] type 00 class 0x080000
pci 0000:00:10.1: [8086:3426] type 00 class 0x080000
pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
pci 0000:00:19.0: [8086:10cc] type 00 class 0x020000
pci 0000:00:19.0: reg 10: [mem 0xd2400000-0xd241ffff]
pci 0000:00:19.0: reg 14: [mem 0xd2423000-0xd2423fff]
pci 0000:00:19.0: reg 18: [io  0x7100-0x711f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
pci 0000:00:1a.0: reg 20: [io  0x70e0-0x70ff]
pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
pci 0000:00:1a.1: reg 20: [io  0x70c0-0x70df]
pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
pci 0000:00:1a.2: reg 20: [io  0x70a0-0x70bf]
pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
pci 0000:00:1a.7: reg 10: [mem 0xd2422000-0xd24223ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: [8086:3a3e] type 00 class 0x040300
pci 0000:00:1b.0: reg 10: [mem 0xf0200000-0xf0203fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: [8086:3a42] type 01 class 0x060400
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
pci 0000:00:1d.0: reg 20: [io  0x7080-0x709f]
pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
pci 0000:00:1d.1: reg 20: [io  0x7060-0x707f]
pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
pci 0000:00:1d.2: reg 20: [io  0x7040-0x705f]
pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
pci 0000:00:1d.7: reg 10: [mem 0xd2421000-0xd24213ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (mask 007f)
pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
pci 0000:00:1f.2: reg 10: [io  0x7128-0x712f]
pci 0000:00:1f.2: reg 14: [io  0x7134-0x7137]
pci 0000:00:1f.2: reg 18: [io  0x7120-0x7127]
pci 0000:00:1f.2: reg 1c: [io  0x7130-0x7133]
pci 0000:00:1f.2: reg 20: [io  0x7020-0x703f]
pci 0000:00:1f.2: reg 24: [mem 0xd2420000-0xd24207ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
pci 0000:00:1f.3: reg 10: [mem 0xf0204000-0xf02040ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x7000-0x701f]
pci 0000:01:00.0: [8086:10c9] type 00 class 0x020000
pci 0000:01:00.0: reg 10: [mem 0xd2020000-0xd203ffff]
pci 0000:01:00.0: reg 14: [mem 0xd1c00000-0xd1ffffff]
pci 0000:01:00.0: reg 18: [io  0x6020-0x603f]
pci 0000:01:00.0: reg 1c: [mem 0xd20c4000-0xd20c7fff]
pci 0000:01:00.0: reg 30: [mem 0xffc00000-0xffffffff pref]
pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
pci 0000:01:00.0: reg 184: [mem 0xd2040000-0xd2043fff 64bit]
pci 0000:01:00.0: reg 190: [mem 0xd2060000-0xd2063fff 64bit]
pci 0000:01:00.1: [8086:10c9] type 00 class 0x020000
pci 0000:01:00.1: reg 10: [mem 0xd2000000-0xd201ffff]
pci 0000:01:00.1: reg 14: [mem 0xd1800000-0xd1bfffff]
pci 0000:01:00.1: reg 18: [io  0x6000-0x601f]
pci 0000:01:00.1: reg 1c: [mem 0xd20c0000-0xd20c3fff]
pci 0000:01:00.1: reg 30: [mem 0xffc00000-0xffffffff pref]
pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
pci 0000:01:00.1: reg 184: [mem 0xd2080000-0xd2083fff 64bit]
pci 0000:01:00.1: reg 190: [mem 0xd20a0000-0xd20a3fff 64bit]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x6000-0x6fff]
pci 0000:00:01.0:   bridge window [mem 0xd1800000-0xd20fffff]
pci 0000:02:00.0: [1002:7249] type 00 class 0x030000
pci 0000:02:00.0: reg 10: [mem 0xe0000000-0xefffffff 64bit pref]
pci 0000:02:00.0: reg 18: [mem 0xd2300000-0xd230ffff 64bit]
pci 0000:02:00.0: reg 20: [io  0x5000-0x50ff]
pci 0000:02:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.1: [1002:7269] type 00 class 0x038000
pci 0000:02:00.1: reg 10: [mem 0xd2310000-0xd231ffff 64bit]
pci 0000:02:00.1: supports D1 D2
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  0x5000-0x5fff]
pci 0000:00:03.0:   bridge window [mem 0xd2300000-0xd23fffff]
pci 0000:00:03.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
pci 0000:03:00.0: [111d:8018] type 01 class 0x060400
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PCI bridge to [bus 03-06]
pci 0000:00:07.0:   bridge window [io  0x3000-0x4fff]
pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xd14fffff]
pci 0000:00:07.0:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
pci 0000:04:02.0: [111d:8018] type 01 class 0x060400
pci 0000:04:02.0: PME# supported from D0 D3hot D3cold
pci 0000:04:04.0: [111d:8018] type 01 class 0x060400
pci 0000:04:04.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PCI bridge to [bus 04-06]
pci 0000:03:00.0:   bridge window [io  0x3000-0x4fff]
pci 0000:03:00.0:   bridge window [mem 0xd0000000-0xd14fffff]
pci 0000:03:00.0:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
pci 0000:05:00.0: [8086:1526] type 00 class 0x020000
pci 0000:05:00.0: reg 10: [mem 0xd1420000-0xd143ffff]
pci 0000:05:00.0: reg 14: [mem 0xd1000000-0xd13fffff]
pci 0000:05:00.0: reg 18: [io  0x4020-0x403f]
pci 0000:05:00.0: reg 1c: [mem 0xd1444000-0xd1447fff]
pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
pci 0000:05:00.0: reg 184: [mem 0xf0160000-0xf0163fff 64bit pref]
pci 0000:05:00.0: reg 190: [mem 0xf0140000-0xf0143fff 64bit pref]
pci 0000:05:00.1: [8086:1526] type 00 class 0x020000
pci 0000:05:00.1: reg 10: [mem 0xd1400000-0xd141ffff]
pci 0000:05:00.1: reg 14: [mem 0xd0c00000-0xd0ffffff]
pci 0000:05:00.1: reg 18: [io  0x4000-0x401f]
pci 0000:05:00.1: reg 1c: [mem 0xd1440000-0xd1443fff]
pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
pci 0000:05:00.1: reg 184: [mem 0xf0120000-0xf0123fff 64bit pref]
pci 0000:05:00.1: reg 190: [mem 0xf0100000-0xf0103fff 64bit pref]
pci 0000:04:02.0: PCI bridge to [bus 05-05]
pci 0000:04:02.0:   bridge window [io  0x4000-0x4fff]
pci 0000:04:02.0:   bridge window [mem 0xd0c00000-0xd14fffff]
pci 0000:04:02.0:   bridge window [mem 0xf0100000-0xf01fffff 64bit pref]
pci 0000:06:00.0: [8086:1526] type 00 class 0x020000
pci 0000:06:00.0: reg 10: [mem 0xd0820000-0xd083ffff]
pci 0000:06:00.0: reg 14: [mem 0xd0400000-0xd07fffff]
pci 0000:06:00.0: reg 18: [io  0x3020-0x303f]
pci 0000:06:00.0: reg 1c: [mem 0xd0844000-0xd0847fff]
pci 0000:06:00.0: PME# supported from D0 D3hot
pci 0000:06:00.0: reg 184: [mem 0xf0060000-0xf0063fff 64bit pref]
pci 0000:06:00.0: reg 190: [mem 0xf0040000-0xf0043fff 64bit pref]
pci 0000:06:00.1: [8086:1526] type 00 class 0x020000
pci 0000:06:00.1: reg 10: [mem 0xd0800000-0xd081ffff]
pci 0000:06:00.1: reg 14: [mem 0xd0000000-0xd03fffff]
pci 0000:06:00.1: reg 18: [io  0x3000-0x301f]
pci 0000:06:00.1: reg 1c: [mem 0xd0840000-0xd0843fff]
pci 0000:06:00.1: PME# supported from D0 D3hot
pci 0000:06:00.1: reg 184: [mem 0xf0020000-0xf0023fff 64bit pref]
pci 0000:06:00.1: reg 190: [mem 0xf0000000-0xf0003fff 64bit pref]
pci 0000:04:04.0: PCI bridge to [bus 06-06]
pci 0000:04:04.0:   bridge window [io  0x3000-0x3fff]
pci 0000:04:04.0:   bridge window [mem 0xd0000000-0xd08fffff]
pci 0000:04:04.0:   bridge window [mem 0xf0000000-0xf00fffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 07-07]
pci 0000:00:1c.1: PCI bridge to [bus 08-08]
pci 0000:09:00.0: [11ab:6121] type 00 class 0x01018f
pci 0000:09:00.0: reg 10: [io  0x2018-0x201f]
pci 0000:09:00.0: reg 14: [io  0x2024-0x2027]
pci 0000:09:00.0: reg 18: [io  0x2010-0x2017]
pci 0000:09:00.0: reg 1c: [io  0x2020-0x2023]
pci 0000:09:00.0: reg 20: [io  0x2000-0x200f]
pci 0000:09:00.0: reg 24: [mem 0xd2200000-0xd22003ff]
pci 0000:09:00.0: supports D1
pci 0000:09:00.0: PME# supported from D0 D1 D3hot
pci 0000:00:1c.4: PCI bridge to [bus 09-09]
pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.4:   bridge window [mem 0xd2200000-0xd22fffff]
pci 0000:0a:02.0: [9710:9835] type 00 class 0x070002
pci 0000:0a:02.0: reg 10: [io  0x1030-0x1037]
pci 0000:0a:02.0: reg 14: [io  0x1028-0x102f]
pci 0000:0a:02.0: reg 18: [io  0x1020-0x1027]
pci 0000:0a:02.0: reg 1c: [io  0x1018-0x101f]
pci 0000:0a:02.0: reg 20: [io  0x1010-0x1017]
pci 0000:0a:02.0: reg 24: [io  0x1000-0x100f]
pci 0000:0a:03.0: [104c:8023] type 00 class 0x0c0010
pci 0000:0a:03.0: reg 10: [mem 0xd2104000-0xd21047ff]
pci 0000:0a:03.0: reg 14: [mem 0xd2100000-0xd2103fff]
pci 0000:0a:03.0: supports D1 D2
pci 0000:0a:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:00:1e.0: PCI bridge to [bus 0a-0a] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1e.0:   bridge window [mem 0xd2100000-0xd21fffff]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000cbfff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xf7ffffff] (subtractive decode)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC control (0x1d) granted
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:02:00.0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: Discovered peer bus 3f
PCI: root bus 3f: using default resources
PCI host bridge to bus 0000:3f
pci_bus 0000:3f: root bus resource [io  0x0000-0xffff]
pci_bus 0000:3f: root bus resource [mem 0x00000000-0xfffffffff]
pci 0000:3f:00.0: [8086:2c71] type 00 class 0x060000
pci 0000:3f:00.1: [8086:2d81] type 00 class 0x060000
pci 0000:3f:02.0: [8086:2d90] type 00 class 0x060000
pci 0000:3f:02.1: [8086:2d91] type 00 class 0x060000
pci 0000:3f:02.2: [8086:2d92] type 00 class 0x060000
pci 0000:3f:02.3: [8086:2d93] type 00 class 0x060000
pci 0000:3f:03.0: [8086:2d98] type 00 class 0x060000
pci 0000:3f:03.1: [8086:2d99] type 00 class 0x060000
pci 0000:3f:03.4: [8086:2d9c] type 00 class 0x060000
pci 0000:3f:04.0: [8086:2da0] type 00 class 0x060000
pci 0000:3f:04.1: [8086:2da1] type 00 class 0x060000
pci 0000:3f:04.2: [8086:2da2] type 00 class 0x060000
pci 0000:3f:04.3: [8086:2da3] type 00 class 0x060000
pci 0000:3f:05.0: [8086:2da8] type 00 class 0x060000
pci 0000:3f:05.1: [8086:2da9] type 00 class 0x060000
pci 0000:3f:05.2: [8086:2daa] type 00 class 0x060000
pci 0000:3f:05.3: [8086:2dab] type 00 class 0x060000
pci 0000:3f:06.0: [8086:2db0] type 00 class 0x060000
pci 0000:3f:06.1: [8086:2db1] type 00 class 0x060000
pci 0000:3f:06.2: [8086:2db2] type 00 class 0x060000
pci 0000:3f:06.3: [8086:2db3] type 00 class 0x060000
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000008f000 - 000000000008ffff 
reserve RAM buffer: 000000000009d000 - 000000000009ffff 
reserve RAM buffer: 00000000cf49d000 - 00000000cfffffff 
reserve RAM buffer: 00000000cf662000 - 00000000cfffffff 
reserve RAM buffer: 00000000cf7db000 - 00000000cfffffff 
reserve RAM buffer: 00000000cf800000 - 00000000cfffffff 
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-3d]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000c4000-0x000cbfff window]
pnp 00:00: [mem 0xfed40000-0xfedfffff window]
pnp 00:00: [mem 0xd0000000-0xf7ffffff window]
pnp 00:00: [mem 0x00000000 window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [io  0x0000-0x000f]
pnp 00:01: [io  0x0081-0x0083]
pnp 00:01: [io  0x0087]
pnp 00:01: [io  0x0089-0x008b]
pnp 00:01: [io  0x008f]
pnp 00:01: [io  0x00c0-0x00df]
pnp 00:01: [dma 4]
pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:02: [io  0x0070-0x0071]
pnp 00:02: [io  0x0074-0x0077]
pnp 00:02: [irq 8]
pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:03: [io  0x00f0]
pnp 00:03: [irq 13]
pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:04: [io  0x0061]
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: [io  0x0500-0x053f]
pnp 00:05: [io  0x0400-0x047f]
pnp 00:05: [io  0x0092]
pnp 00:05: [io  0x0680-0x06ff]
pnp 00:05: [io  0x0010-0x001f]
pnp 00:05: [io  0x0072-0x0073]
pnp 00:05: [io  0x0080]
pnp 00:05: [io  0x0084-0x0086]
pnp 00:05: [io  0x0088]
pnp 00:05: [io  0x008c-0x008e]
pnp 00:05: [io  0x0090-0x009f]
system 00:05: [io  0x0500-0x053f] has been reserved
system 00:05: [io  0x0400-0x047f] has been reserved
system 00:05: [io  0x0680-0x06ff] has been reserved
system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:06: [io  0x0060]
pnp 00:06: [io  0x0064]
system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:07: [mem 0xfec00000-0xfec000ff]
pnp 00:07: Plug and Play ACPI device, IDs PNP0003 (active)
pnp 00:08: [mem 0xfed00000-0xfed03fff]
pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:01:00.0: no compatible bridge window for [mem 0xffc00000-0xffffffff pref]
pci 0000:01:00.1: no compatible bridge window for [mem 0xffc00000-0xffffffff pref]
pci 0000:02:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
pci 0000:00:01.0: BAR 15: assigned [mem 0xd2800000-0xd2ffffff pref]
pci 0000:01:00.0: BAR 6: assigned [mem 0xd2800000-0xd2bfffff pref]
pci 0000:01:00.1: BAR 6: assigned [mem 0xd2c00000-0xd2ffffff pref]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x6000-0x6fff]
pci 0000:00:01.0:   bridge window [mem 0xd1800000-0xd20fffff]
pci 0000:00:01.0:   bridge window [mem 0xd2800000-0xd2ffffff pref]
pci 0000:02:00.0: BAR 6: assigned [mem 0xd2320000-0xd233ffff pref]
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  0x5000-0x5fff]
pci 0000:00:03.0:   bridge window [mem 0xd2300000-0xd23fffff]
pci 0000:00:03.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
pci 0000:04:02.0: PCI bridge to [bus 05-05]
pci 0000:04:02.0:   bridge window [io  0x4000-0x4fff]
pci 0000:04:02.0:   bridge window [mem 0xd0c00000-0xd14fffff]
pci 0000:04:02.0:   bridge window [mem 0xf0100000-0xf01fffff 64bit pref]
pci 0000:04:04.0: PCI bridge to [bus 06-06]
pci 0000:04:04.0:   bridge window [io  0x3000-0x3fff]
pci 0000:04:04.0:   bridge window [mem 0xd0000000-0xd08fffff]
pci 0000:04:04.0:   bridge window [mem 0xf0000000-0xf00fffff 64bit pref]
pci 0000:03:00.0: PCI bridge to [bus 04-06]
pci 0000:03:00.0:   bridge window [io  0x3000-0x4fff]
pci 0000:03:00.0:   bridge window [mem 0xd0000000-0xd14fffff]
pci 0000:03:00.0:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
pci 0000:00:07.0: PCI bridge to [bus 03-06]
pci 0000:00:07.0:   bridge window [io  0x3000-0x4fff]
pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xd14fffff]
pci 0000:00:07.0:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 07-07]
pci 0000:00:1c.1: PCI bridge to [bus 08-08]
pci 0000:00:1c.4: PCI bridge to [bus 09-09]
pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.4:   bridge window [mem 0xd2200000-0xd22fffff]
pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1e.0:   bridge window [mem 0xd2100000-0xd21fffff]
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000cbfff]
pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfedfffff]
pci_bus 0000:00: resource 9 [mem 0xd0000000-0xf7ffffff]
pci_bus 0000:01: resource 0 [io  0x6000-0x6fff]
pci_bus 0000:01: resource 1 [mem 0xd1800000-0xd20fffff]
pci_bus 0000:01: resource 2 [mem 0xd2800000-0xd2ffffff pref]
pci_bus 0000:02: resource 0 [io  0x5000-0x5fff]
pci_bus 0000:02: resource 1 [mem 0xd2300000-0xd23fffff]
pci_bus 0000:02: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x3000-0x4fff]
pci_bus 0000:03: resource 1 [mem 0xd0000000-0xd14fffff]
pci_bus 0000:03: resource 2 [mem 0xf0000000-0xf01fffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0x3000-0x4fff]
pci_bus 0000:04: resource 1 [mem 0xd0000000-0xd14fffff]
pci_bus 0000:04: resource 2 [mem 0xf0000000-0xf01fffff 64bit pref]
pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:05: resource 1 [mem 0xd0c00000-0xd14fffff]
pci_bus 0000:05: resource 2 [mem 0xf0100000-0xf01fffff 64bit pref]
pci_bus 0000:06: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:06: resource 1 [mem 0xd0000000-0xd08fffff]
pci_bus 0000:06: resource 2 [mem 0xf0000000-0xf00fffff 64bit pref]
pci_bus 0000:09: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:09: resource 1 [mem 0xd2200000-0xd22fffff]
pci_bus 0000:0a: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:0a: resource 1 [mem 0xd2100000-0xd21fffff]
pci_bus 0000:0a: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:0a: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:0a: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:0a: resource 7 [mem 0x000c4000-0x000cbfff]
pci_bus 0000:0a: resource 8 [mem 0xfed40000-0xfedfffff]
pci_bus 0000:0a: resource 9 [mem 0xd0000000-0xf7ffffff]
pci_bus 0000:3f: resource 4 [io  0x0000-0xffff]
pci_bus 0000:3f: resource 5 [mem 0x00000000-0xfffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP: reno registered
UDP hash table entries: 4096 (order: 5, 131072 bytes)
UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
NET: Registered protocol family 1
pci 0000:02:00.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 28368k freed
DMAR: No ATSR found
IOMMU 0 0xfe711000: using Queued invalidation
IOMMU 1 0xfe710000: using Queued invalidation
DMAR: Recommended TLB entries for ISOCH unit is 16; your BIOS set 20
IOMMU: Setting RMRR:
IOMMU: Setting identity map for device 0000:00:1d.0 [0xec000 - 0xeefff]
IOMMU: Setting identity map for device 0000:00:1a.7 [0xcf4a1000 - 0xcf4a1fff]
IOMMU: Setting identity map for device 0000:00:1a.2 [0xcf4a9000 - 0xcf4a9fff]
IOMMU: Setting identity map for device 0000:00:1a.1 [0xcf4a8000 - 0xcf4a8fff]
IOMMU: Setting identity map for device 0000:00:1a.0 [0xcf4a3000 - 0xcf4a3fff]
IOMMU: Setting identity map for device 0000:00:1d.7 [0xcf4ad000 - 0xcf4adfff]
IOMMU: Setting identity map for device 0000:00:1d.2 [0xcf4ac000 - 0xcf4acfff]
IOMMU: Setting identity map for device 0000:00:1d.1 [0xcf4ab000 - 0xcf4abfff]
IOMMU: Setting identity map for device 0000:00:1d.0 [0xcf4aa000 - 0xcf4aafff]
IOMMU: Prepare 0-16MiB unity mapping for LPC
IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
audit: initializing netlink socket (disabled)
type=2000 audit(1335213058.781:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 12045
SELinux:  Registering netfilter hooks
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: irq 42 for MSI/MSI-X
pcieport 0000:00:03.0: irq 43 for MSI/MSI-X
pcieport 0000:00:07.0: irq 44 for MSI/MSI-X
pcieport 0000:00:1c.0: irq 45 for MSI/MSI-X
pcieport 0000:00:1c.1: irq 46 for MSI/MSI-X
pcieport 0000:00:1c.4: irq 47 for MSI/MSI-X
pcieport 0000:04:02.0: irq 48 for MSI/MSI-X
pcieport 0000:04:04.0: irq 49 for MSI/MSI-X
aer 0000:00:01.0:pcie02: service driver aer loaded
aer 0000:00:03.0:pcie02: service driver aer loaded
aer 0000:00:07.0:pcie02: service driver aer loaded
pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
pci 0000:02:00.1: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
pcieport 0000:03:00.0: Signaling PME through PCIe PME interrupt
pcieport 0000:04:02.0: Signaling PME through PCIe PME interrupt
pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
pci 0000:05:00.1: Signaling PME through PCIe PME interrupt
pcieport 0000:04:04.0: Signaling PME through PCIe PME interrupt
pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
pci 0000:06:00.1: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
pci 0000:09:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
intel_idle: MWAIT substates: 0x1120
intel_idle: v0.4 model 0x2C
intel_idle: lapic_timer_reliable_states 0xffffffff
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: Requesting acpi_cpufreq
GHES: HEST is not enabled!
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
0000:0a:02.0: ttyS0 at I/O 0x1030 (irq = 18) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xd2422000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.4.0-rc2+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd2421000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 3.4.0-rc2+ ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x000070e0
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.4.0-rc2+ uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x000070c0
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.4.0-rc2+ uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 19, io base 0x000070a0
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 3.4.0-rc2+ uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00007080
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 3.4.0-rc2+ uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00007060
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 3.4.0-rc2+ uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00007040
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 3.4.0-rc2+ uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
i8042: PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:02: RTC can wake from S4
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
EFI Variables Facility v0.08 2004-May-17
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP: cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
IMA: No TPM chip found, activating TPM-bypass!
rtc_cmos 00:02: setting system clock to 2012-04-23 20:31:00 UTC (1335213060)
Initializing network drop monitor service
Freeing unused kernel memory: 1460k freed
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 912k freed
Freeing unused kernel memory: 1672k freed
dracut: dracut-004-252.el6
dracut: rd_NO_LUKS: removing cryptoluks activation
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
udev: starting version 147
udevd (124): /proc/124/oom_adj is deprecated, please use /proc/124/oom_score_adj instead.
usb 3-1: new full-speed USB device number 2 using uhci_hcd
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
[drm] initializing kernel modesetting (R580 0x1002:0x7249 0x1002:0x0B12).
[drm] register mmio base: 0xD2300000
[drm] register mmio size: 65536
ATOM BIOS: A52021
[drm] Generation 2 PCI interface, using max accessible memory
radeon 0000:02:00.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
Refined TSC clocksource calibration: 3378.194 MHz.
Switching to clocksource tsc
radeon 0000:02:00.0: GTT: 512M 0x0000000020000000 - 0x000000003FFFFFFF
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
radeon 0000:02:00.0: irq 50 for MSI/MSI-X
radeon 0000:02:00.0: radeon: using MSI.
[drm] radeon: irq initialized.
[drm] Detected VRAM RAM=512M, BAR=256M
[drm] RAM width 256bits DDR
[TTM] Zone  kernel: Available graphics memory: 3085684 kiB
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[TTM] Initializing pool allocator
[TTM] Initializing DMA pool allocator
[drm] radeon: 512M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] radeon: ib pool ready.
[drm] radeon: 4 quad pipes, 1 z pipes initialized.
[drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
usb 3-1: New USB device found, idVendor=0557, idProduct=7000
usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 3-1:1.0: USB hub found
hub 3-1:1.0: 4 ports detected
radeon 0000:02:00.0: WB enabled
[drm] fence driver on ring 0 use gpu addr 0x20000000 and cpu addr 0xffff88019bef9000
[drm] Loading R500 Microcode
[drm] radeon: ring at 0x0000000020001000
[drm] ring test succeeded in 3 usecs
[drm] ib test succeeded in 0 usecs
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   DVI-I
[drm]   HPD2
[drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[drm]   Encoders:
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
[drm]     DFP3: INTERNAL_LVTM1
[drm] Connector 1:
[drm]   S-video
[drm]   Encoders:
[drm]     TV1: INTERNAL_KLDSCP_DAC2
[drm] Connector 2:
[drm]   DVI-I
[drm]   HPD1
[drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[drm]   Encoders:
[drm]     CRT2: INTERNAL_KLDSCP_DAC2
[drm]     DFP1: INTERNAL_KLDSCP_TMDS1
[drm] Possible lm64 thermal controller at 0x18
[drm] radeon: power management initialized
[drm] fb mappable at 0xE00C0000
[drm] vram apper at 0xE0000000
[drm] size 7258112
[drm] fb depth is 24
[drm]    pitch is 6912
fbcon: radeondrmfb (fb0) is primary device
Console: switching to colour frame buffer device 210x65
fb0: radeondrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized radeon 2.15.0 20080528 for 0000:02:00.0 on minor 0
dracut: Starting plymouth daemon
scsi0 : pata_marvell
scsi1 : pata_marvell
ata1: PATA max UDMA/100 cmd 0x2018 ctl 0x2024 bmdma 0x2000 irq 16
ata2: PATA max UDMA/133 cmd 0x2010 ctl 0x2020 bmdma 0x2008 irq 16
usb 3-1.1: new low-speed USB device number 3 using uhci_hcd
usb 3-1.1: New USB device found, idVendor=413c, idProduct=2005
usb 3-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1.1: Product: DELL USB Keyboard
usb 3-1.1: Manufacturer: DELL
input: DELL DELL USB Keyboard as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.1/3-1.1:1.0/input/input2
generic-usb 0003:413C:2005.0001: input,hidraw0: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:1a.0-1.1/input0
usb 3-1.4: new low-speed USB device number 4 using uhci_hcd
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: irq 51 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
ahci 0000:00:1f.2: setting latency timer to 64
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
scsi6 : ahci
scsi7 : ahci
ata3: SATA max UDMA/133 abar m2048@0xd2420000 port 0xd2420100 irq 51
ata4: SATA max UDMA/133 abar m2048@0xd2420000 port 0xd2420180 irq 51
ata5: SATA max UDMA/133 abar m2048@0xd2420000 port 0xd2420200 irq 51
ata6: SATA max UDMA/133 abar m2048@0xd2420000 port 0xd2420280 irq 51
ata7: SATA max UDMA/133 abar m2048@0xd2420000 port 0xd2420300 irq 51
ata8: SATA max UDMA/133 abar m2048@0xd2420000 port 0xd2420380 irq 51
usb 3-1.4: New USB device found, idVendor=046d, idProduct=c016
usb 3-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1.4: Product: Optical USB Mouse
usb 3-1.4: Manufacturer: Logitech
input: Logitech Optical USB Mouse as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.4/3-1.4:1.0/input/input3
generic-usb 0003:046D:C016.0002: input,hidraw1: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1a.0-1.4/input0
ata4: SATA link down (SStatus 0 SControl 300)
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata7: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
ata6.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata8.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
ata8.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata6.00: configured for UDMA/133
ata8.00: configured for UDMA/133
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATAPI: HL-DT-ST BDDVDRW GGC-H20L, 1.00, max UDMA/133
ata3.00: configured for UDMA/133
scsi 2:0:0:0: CD-ROM            HL-DT-ST BDDVDRW GGC-H20L 1.00 PQ: 0 ANSI: 5
scsi 5:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
scsi 7:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
firewire_ohci 0000:0a:03.0: added OHCI v1.10 device as card 0, 4 IR + 8 IT contexts, quirks 0x2
sd 5:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 7:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 7:0:0:0: [sdb] Write Protect is off
sd 7:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 5:0:0:0: [sda] Write Protect is off
 sdb: sdb1
sd 7:0:0:0: [sdb] Attached SCSI disk
sd 5:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 5:0:0:0: [sda] Attached SCSI disk
sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
firewire_core 0000:0a:03.0: created device fw0: GUID 00902700025565e0, S400
dracut: Scanning devices sda2 sdb1  for LVM logical volumes vg_dhcp10019175/lv_root 
dracut: inactive '/dev/Volgrprhel6/guest2-rhel6-64' [7.81 GiB] inherit
dracut: inactive '/dev/vg_dhcp10019175/lv_root' [50.00 GiB] inherit
dracut: inactive '/dev/vg_dhcp10019175/lv_home' [239.77 GiB] inherit
dracut: inactive '/dev/vg_dhcp10019175/lv_swap' [7.83 GiB] inherit
EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
dracut: Mounted root filesystem /dev/mapper/vg_dhcp10019175-lv_root
dracut: Loading SELinux policy
SELinux: 2048 avtab hash slots, 222702 rules.
SELinux: 2048 avtab hash slots, 222702 rules.
SELinux:  9 users, 12 roles, 3551 types, 179 bools, 1 sens, 1024 cats
SELinux:  81 classes, 222702 rules
SELinux:  Permission audit_access in class file not defined in policy.
SELinux:  Permission audit_access in class dir not defined in policy.
SELinux:  Permission execmod in class dir not defined in policy.
SELinux:  Permission audit_access in class lnk_file not defined in policy.
SELinux:  Permission open in class lnk_file not defined in policy.
SELinux:  Permission execmod in class lnk_file not defined in policy.
SELinux:  Permission audit_access in class chr_file not defined in policy.
SELinux:  Permission audit_access in class blk_file not defined in policy.
SELinux:  Permission execmod in class blk_file not defined in policy.
SELinux:  Permission audit_access in class sock_file not defined in policy.
SELinux:  Permission execmod in class sock_file not defined in policy.
SELinux:  Permission audit_access in class fifo_file not defined in policy.
SELinux:  Permission execmod in class fifo_file not defined in policy.
SELinux:  Permission syslog in class capability2 not defined in policy.
SELinux: the above unknown classes and permissions will be allowed
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev dm-0, type ext4), uses xattr
type=1403 audit(1335213064.873:2): policy loaded auid=4294967295 ses=4294967295
dracut: 
dracut: Switching root
readahead: starting
udev: starting version 147
WARNING! power/level is deprecated; use power/control instead
type=1400 audit(1335213067.453:3): avc:  denied  { mmap_zero } for  pid=538 comm="vbetool" scontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023 tcontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023 tclass=memprotect
dca service started, version 1.12.1
igb: Intel(R) Gigabit Ethernet Network Driver - version 3.2.10-k
igb: Copyright (c) 2007-2012 Intel Corporation.
igb 0000:01:00.0: irq 52 for MSI/MSI-X
igb 0000:01:00.0: irq 53 for MSI/MSI-X
igb 0000:01:00.0: irq 54 for MSI/MSI-X
igb 0000:01:00.0: irq 55 for MSI/MSI-X
igb 0000:01:00.0: irq 56 for MSI/MSI-X
igb 0000:01:00.0: irq 57 for MSI/MSI-X
igb 0000:01:00.0: irq 58 for MSI/MSI-X
igb 0000:01:00.0: irq 59 for MSI/MSI-X
igb 0000:01:00.0: irq 60 for MSI/MSI-X
igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:1b:21:24:1e:48
igb 0000:01:00.0: eth0: PBA No: E19418-004
igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
igb 0000:01:00.1: irq 61 for MSI/MSI-X
igb 0000:01:00.1: irq 62 for MSI/MSI-X
igb 0000:01:00.1: irq 63 for MSI/MSI-X
igb 0000:01:00.1: irq 64 for MSI/MSI-X
igb 0000:01:00.1: irq 65 for MSI/MSI-X
igb 0000:01:00.1: irq 66 for MSI/MSI-X
igb 0000:01:00.1: irq 67 for MSI/MSI-X
igb 0000:01:00.1: irq 68 for MSI/MSI-X
igb 0000:01:00.1: irq 69 for MSI/MSI-X
igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:1b:21:24:1e:49
igb 0000:01:00.1: eth1: PBA No: E19418-004
igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
igb 0000:05:00.0: irq 70 for MSI/MSI-X
igb 0000:05:00.0: irq 71 for MSI/MSI-X
igb 0000:05:00.0: irq 72 for MSI/MSI-X
igb 0000:05:00.0: irq 73 for MSI/MSI-X
igb 0000:05:00.0: irq 74 for MSI/MSI-X
igb 0000:05:00.0: irq 75 for MSI/MSI-X
igb 0000:05:00.0: irq 76 for MSI/MSI-X
igb 0000:05:00.0: irq 77 for MSI/MSI-X
igb 0000:05:00.0: irq 78 for MSI/MSI-X
igb 0000:05:00.0: The NVM Checksum Is Not Valid
igb: probe of 0000:05:00.0 failed with error -5
igb 0000:05:00.1: irq 70 for MSI/MSI-X
igb 0000:05:00.1: irq 71 for MSI/MSI-X
igb 0000:05:00.1: irq 72 for MSI/MSI-X
igb 0000:05:00.1: irq 73 for MSI/MSI-X
igb 0000:05:00.1: irq 74 for MSI/MSI-X
igb 0000:05:00.1: irq 75 for MSI/MSI-X
igb 0000:05:00.1: irq 76 for MSI/MSI-X
igb 0000:05:00.1: irq 77 for MSI/MSI-X
igb 0000:05:00.1: irq 78 for MSI/MSI-X
igb 0000:05:00.1: The NVM Checksum Is Not Valid
igb: probe of 0000:05:00.1 failed with error -5
igb 0000:06:00.0: irq 70 for MSI/MSI-X
igb 0000:06:00.0: irq 71 for MSI/MSI-X
igb 0000:06:00.0: irq 72 for MSI/MSI-X
igb 0000:06:00.0: irq 73 for MSI/MSI-X
igb 0000:06:00.0: irq 74 for MSI/MSI-X
igb 0000:06:00.0: irq 75 for MSI/MSI-X
igb 0000:06:00.0: irq 76 for MSI/MSI-X
igb 0000:06:00.0: irq 77 for MSI/MSI-X
igb 0000:06:00.0: irq 78 for MSI/MSI-X
igb 0000:06:00.0: Intel(R) Gigabit Ethernet Network Connection
igb 0000:06:00.0: eth2: (PCIe:2.5Gb/s:Width x4) 00:1b:21:66:d7:2a
igb 0000:06:00.0: eth2: PBA No: E91609-002
igb 0000:06:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
igb 0000:06:00.1: irq 79 for MSI/MSI-X
igb 0000:06:00.1: irq 80 for MSI/MSI-X
igb 0000:06:00.1: irq 81 for MSI/MSI-X
igb 0000:06:00.1: irq 82 for MSI/MSI-X
igb 0000:06:00.1: irq 83 for MSI/MSI-X
igb 0000:06:00.1: irq 84 for MSI/MSI-X
igb 0000:06:00.1: irq 85 for MSI/MSI-X
igb 0000:06:00.1: irq 86 for MSI/MSI-X
igb 0000:06:00.1: irq 87 for MSI/MSI-X
igb 0000:06:00.1: Intel(R) Gigabit Ethernet Network Connection
igb 0000:06:00.1: eth3: (PCIe:2.5Gb/s:Width x4) 00:1b:21:66:d7:2b
igb 0000:06:00.1: eth3: PBA No: E91609-002
igb 0000:06:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
udev: renamed network interface eth1 to rename3
udev: renamed network interface eth0 to eth1
EDAC MC: Ver: 2.1.0
EDAC i7core: Device not found: dev 00.0 PCI ID 8086:2c70
e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 88 for MSI/MSI-X
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1c:c0:b0:1a:7c
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: FFFFFF-0FF
udev: renamed network interface eth2 to eth55
udev: renamed network interface eth3 to eth65
udev: renamed network interface rename3 to eth3
snd_hda_intel 0000:00:1b.0: irq 89 for MSI/MSI-X
hda_codec: ALC889: SKU not ready 0x411111f0
input: HDA Intel Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input4
input: HDA Intel Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
input: HDA Intel Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
input: HDA Intel Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
input: HDA Intel Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
input: HDA Intel Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
input: HDA Intel Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
input: PC Speaker as /devices/platform/pcspkr/input/input11
microcode: CPU0 sig=0x206c2, pf=0x2, revision=0x13
microcode: CPU1 sig=0x206c2, pf=0x2, revision=0x13
microcode: CPU2 sig=0x206c2, pf=0x2, revision=0x13
microcode: CPU3 sig=0x206c2, pf=0x2, revision=0x13
microcode: CPU4 sig=0x206c2, pf=0x2, revision=0x13
microcode: CPU5 sig=0x206c2, pf=0x2, revision=0x13
microcode: CPU6 sig=0x206c2, pf=0x2, revision=0x13
microcode: CPU7 sig=0x206c2, pf=0x2, revision=0x13
microcode: CPU8 sig=0x206c2, pf=0x2, revision=0x13
microcode: CPU9 sig=0x206c2, pf=0x2, revision=0x13
microcode: CPU10 sig=0x206c2, pf=0x2, revision=0x13
microcode: CPU11 sig=0x206c2, pf=0x2, revision=0x13
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
sr 2:0:0:0: Attached scsi generic sg0 type 5
sd 5:0:0:0: Attached scsi generic sg1 type 0
sd 7:0:0:0: Attached scsi generic sg2 type 0
wmi: Mapper loaded
kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
EXT4-fs (dm-0): re-mounted. Opts: (null)
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
SELinux: initialized (dev sda1, type ext4), uses xattr
EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
SELinux: initialized (dev dm-2, type ext4), uses xattr
Adding 8208380k swap on /dev/mapper/vg_dhcp10019175-lv_swap.  Priority:-1 extents:1 across:8208380k 
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
NET: Registered protocol family 10
Bridge firewalling registered
e1000e 0000:00:19.0: irq 88 for MSI/MSI-X
e1000e 0000:00:19.0: irq 88 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
device eth0 entered promiscuous mode
ADDRCONF(NETDEV_UP): br0: link is not ready
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
br0: port 1(eth0) entered forwarding state
br0: port 1(eth0) entered forwarding state
ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
8021q: 802.1Q VLAN Support v1.8
cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.10 (March 21, 2012)
bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v1.0.10 (Jan 22, 2011)
netlink: 12 bytes leftover after parsing attributes.
netlink: 12 bytes leftover after parsing attributes.
netlink: 12 bytes leftover after parsing attributes.
netlink: 12 bytes leftover after parsing attributes.
netlink: 12 bytes leftover after parsing attributes.
FS-Cache: Loaded
NFS: Registering the id_resolver key type
FS-Cache: Netfs 'nfs' registered for caching
SELinux: initialized (dev 0:28, type nfs4), uses genfs_contexts
SELinux: initialized (dev 0:29, type nfs4), uses genfs_contexts
SELinux: initialized (dev 0:28, type nfs4), uses genfs_contexts
SELinux: initialized (dev 0:30, type nfs4), uses genfs_contexts
SELinux: initialized (dev 0:28, type nfs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
device virbr0-nic entered promiscuous mode
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ADDRCONF(NETDEV_UP): virbr0: link is not ready
device virbr1-nic entered promiscuous mode
ADDRCONF(NETDEV_UP): virbr1: link is not ready
Ebtables v2.0 registered
ip6_tables: (C) 2000-2006 Netfilter Core Team
hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
eth0: no IPv6 routers present
br0: no IPv6 routers present
fuse init (API version 7.18)
SELinux: initialized (dev fuse, type fuse), uses genfs_contexts

--------------040709020301090407070007
Content-Type: text/plain;
 name="lspci-vvxxx-linux-3dot4dot0-rc2.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lspci-vvxxx-linux-3dot4dot0-rc2.log"

00:00.0 Host bridge: Intel Corporation 5520/5500/X58 I/O Hub to ESI Port (rev 13)
	Subsystem: Intel Corporation Device 4f53
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 11
	Capabilities: [40] #00 [0000]
00: 86 80 05 34 00 00 10 00 13 00 00 06 10 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 53 4f
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 b0 d1 fe 00 00 00 00 00 00 00 00 00 00 00 00
60: 05 90 02 01 20 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 10 e0 42 00 20 80 00 00 00 00 00 00 41 3c 39 00
a0: 00 00 41 30 00 00 00 00 c0 07 00 01 00 00 00 00
b0: 00 00 00 00 3e 00 00 00 19 00 00 00 00 00 00 00
c0: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 01 00 03 c8 08 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 1 (rev 13) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00006000-00006fff
	Memory behind bridge: d1800000-d20fffff
	Prefetchable memory behind bridge: 00000000d2800000-00000000d2ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Intel Corporation Device 4f53
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
		Address: fee002f8  Data: 0000
		Masking: 00000002  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug- Surpise-
			Slot # 40, PowerLimit 242.000000; Interlock+ NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power+ Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis+ ARIFwd+
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	Capabilities: [160] Vendor Specific Information <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 08 34 47 05 10 00 13 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 00 60 60 00 00
20: 80 d1 00 d2 81 d2 f1 d2 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00
40: 0d 60 00 00 86 80 53 4f 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 05 90 03 01 f8 02 e0 fe 00 00 00 00 02 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 10 e0 42 01 21 80 00 00 0f 00 00 00 42 3c 3b 01
a0: 40 00 41 70 1f 79 02 02 c0 07 48 01 08 00 01 00
b0: 00 00 00 00 3e 00 00 00 39 00 00 00 00 00 00 00
c0: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 01 00 03 c8 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 3 (rev 13) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00005000-00005fff
	Memory behind bridge: d2300000-d23fffff
	Prefetchable memory behind bridge: 00000000e0000000-00000000efffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Intel Corporation Device 4f53
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
		Address: fee00318  Data: 0000
		Masking: 00000002  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #3, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug- Surpise-
			Slot # c0, PowerLimit 242.000000; Interlock+ NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power+ Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis+ ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	Capabilities: [160] Vendor Specific Information <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 0a 34 47 05 10 00 13 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 02 02 00 50 50 00 00
20: 30 d2 30 d2 01 e0 f1 ef 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 18 00
40: 0d 60 00 00 86 80 53 4f 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 05 90 03 01 18 03 e0 fe 00 00 00 00 02 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 10 e0 42 01 21 80 00 00 0f 00 00 00 02 3d 3b 03
a0: 40 00 01 71 1f 79 02 06 c0 07 48 01 08 00 01 00
b0: 00 00 00 00 3e 00 00 00 19 00 00 00 00 00 00 00
c0: 42 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 01 00 03 c8 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 7 (rev 13) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=06, sec-latency=0
	I/O behind bridge: 00003000-00004fff
	Memory behind bridge: d0000000-d14fffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f01fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Intel Corporation Device 4f53
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
		Address: fee00338  Data: 0000
		Masking: 00000002  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #7, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug- Surpise-
			Slot # 80, PowerLimit 242.000000; Interlock+ NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power+ Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis+ ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [150] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	Capabilities: [160] Vendor Specific Information <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 0e 34 47 05 10 00 13 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 03 06 00 30 40 00 00
20: 00 d0 40 d1 01 f0 11 f0 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00
40: 0d 60 00 00 86 80 53 4f 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 05 90 03 01 38 03 e0 fe 00 00 00 00 02 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 10 e0 42 01 21 80 00 00 0f 00 00 00 02 3d 3b 07
a0: 40 00 41 70 1f 79 02 04 c0 07 48 01 08 00 01 00
b0: 00 00 00 00 3e 00 00 00 19 00 00 00 00 00 00 00
c0: 42 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 01 00 03 c8 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:10.0 PIC: Intel Corporation 5520/5500/X58 Physical and Link Layer Registers Port 0 (rev 13) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [50] Vendor Specific Information <?>
00: 86 80 25 34 00 00 10 00 13 00 00 08 10 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 09 00 ff f0 02 00 c0 00 00 68 00 00 39 00 00 00
60: 88 c6 fa 07 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 07 0f 80 00 04 20 7e 00 80 00 00 00 00 00 00 10
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 08 96 08 00 00 14 00 00 fc 16 06 00 00 5f 00
d0: 45 0e 00 00 00 00 d1 00 00 00 00 00 81 04 01 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 14 00 00 00 00 00 41 41 13 11 41 41 13 11

00:10.1 PIC: Intel Corporation 5520/5500/X58 Routing and Protocol Layer Registers Port 0 (rev 13) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
00: 86 80 26 34 00 00 00 00 13 00 00 08 10 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 01 00 00 00 00 00 00 00 00 00 00 00 46 22 40 e0
50: 08 01 02 00 00 00 00 00 02 00 00 00 00 00 00 00
60: 00 00 00 00 80 00 00 00 00 00 00 00 02 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 01 00 41 10 04 41 10 04 00 00 00 00 8b 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 3a 00 01 00 00 00 00 00 13 24 01 00 00 00 00 00
c0: 00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00
d0: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management Registers (rev 13) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Kernel modules: i7core_edac
00: 86 80 2e 34 00 00 10 00 13 00 00 08 10 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 00 00
40: 10 00 92 00 00 80 00 00 00 00 00 00 00 f4 3b 00
50: 00 00 00 10 00 00 00 00 c0 07 00 00 00 00 01 00
60: 00 00 00 00 00 80 00 00 00 00 00 00 00 f4 3b 00
70: 00 00 00 10 00 00 00 00 c0 07 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 ff ff ff ff 07 00
90: 00 00 00 00 00 00 00 00 38 81 04 00 06 ec 03 00
a0: 00 00 00 00 00 00 00 00 09 00 80 cf 00 00 00 00
b0: 00 00 ff ff ff ff 07 00 00 00 00 00 00 00 00 00
c0: 00 00 ff ff ff ff 07 00 00 00 00 00 00 00 00 00
d0: 00 00 00 cc 00 00 00 ac 01 00 00 00 00 00 00 fc
e0: ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00
f0: 74 ef ff f3 00 00 00 00 c7 7f 00 00 00 00 00 00

00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers (rev 13) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
00: 86 80 22 34 00 00 10 00 13 00 00 08 10 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 00 00
40: 10 00 92 00 00 80 00 00 00 00 00 00 00 f4 3b 00
50: 00 00 00 10 00 00 00 00 c0 07 00 00 00 00 01 00
60: 00 00 00 00 00 80 00 00 00 00 00 00 00 f4 3b 00
70: 00 00 00 10 00 00 00 00 c0 07 00 00 00 00 00 00
80: 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 06 ec 03 00 00 00 00 00 00 00 00 bf
a0: 00 00 00 00 00 00 10 02 00 00 83 01 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 06 ec 03 00 00 00 00 00 00 00 00 bf

00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers (rev 13) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
00: 86 80 23 34 00 00 10 00 13 00 00 08 10 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 00 00
40: 10 00 92 00 00 80 00 00 00 00 00 00 00 f4 3b 00
50: 00 00 00 10 00 00 00 00 c0 07 00 00 00 00 01 00
60: 00 00 00 00 00 80 00 00 00 00 00 00 00 f4 3b 00
70: 00 00 00 10 00 00 00 00 c0 07 00 00 00 00 00 00
80: a4 80 a0 02 50 01 aa aa a8 00 00 00 65 15 00 00
90: 00 00 00 00 24 00 00 00 04 08 00 00 22 05 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00
d0: 02 00 00 00 00 08 08 92 9d 00 cd 35 00 00 10 00
e0: 40 58 05 00 fb 03 00 00 ff 07 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers (rev 13) (prog-if 00 [8259])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
00: 86 80 38 34 00 00 00 00 13 00 00 08 10 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 07 0f 2d 05 0b 1f 00 00 2d 05 00 00 00 00 00 00
90: 07 0f 2d 05 0b 1f 00 00 2d 05 00 00 00 00 00 00
a0: 07 0f 2d 05 0b 1f 00 00 2d 05 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 dc 00 77 00 00 00 01 00 00 00 b4 00 c8 00
f0: 00 ff 01 51 00 00 00 07 40 ee d3 07 00 00 00 00

00:19.0 Ethernet controller: Intel Corporation 82567LM-2 Gigabit Network Connection
	Subsystem: Intel Corporation Device 0000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 88
	Region 0: Memory at d2400000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at d2423000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at 7100 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee00458  Data: 0000
	Capabilities: [e0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: e1000e
	Kernel modules: e1000e
00: 86 80 cc 10 07 04 10 00 00 00 00 02 00 00 00 00
10: 00 00 40 d2 00 30 42 d2 01 71 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 00 00
30: 00 00 00 00 c8 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 01 d0 22 c8 00 20 00 0d
d0: 05 e0 81 00 58 04 e0 fe 00 00 00 00 00 00 00 00
e0: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 4f53
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 70e0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 37 3a 05 00 90 02 00 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: e1 70 00 00 00 00 00 00 00 00 00 00 86 80 53 4f
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 04 00 00 00 00 00

00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 4f53
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at 70c0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 38 3a 05 00 90 02 00 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: c1 70 00 00 00 00 00 00 00 00 00 00 86 80 53 4f
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 04 00 00 00 00 00

00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 4f53
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 4: I/O ports at 70a0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 39 3a 05 00 90 02 00 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: a1 70 00 00 00 00 00 00 00 00 00 00 86 80 53 4f
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 04 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 04 00 00 00 00 00

00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2 (prog-if 20 [EHCI])
	Subsystem: Intel Corporation Device 4f53
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at d2422000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd
00: 86 80 3c 3a 06 00 90 02 00 20 03 0c 00 00 00 00
10: 00 20 42 d2 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 53 4f
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 c2 c9 00 00 00 00 0a 98 a0 20 00 00 00 00
60: 20 20 00 00 00 00 00 00 01 00 00 01 00 00 08 40
70: 00 00 e7 0f 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 13 00 06 03 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 aa ff 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 88 85 40 00 86 0f 04 00 0a 97 02 20

00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio Controller
	Subsystem: Intel Corporation Device 0022
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 89
	Region 0: Memory at f0200000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee00018  Data: 0000
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd-hda-intel
00: 86 80 3e 3a 06 04 10 00 00 00 03 04 10 00 00 00
10: 04 00 20 f0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 22 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00
40: 01 00 00 07 00 00 00 00 00 00 00 00 00 80 00 00
50: 01 60 42 c8 00 00 00 00 00 00 00 00 00 00 00 00
60: 05 70 81 00 18 00 e0 fe 00 00 00 00 00 00 00 00
70: 10 00 91 00 00 00 00 10 00 08 10 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 04 00 01 00 00 00 00 31 00 a3 02 00 00 00 00
d0: 61 00 a3 02 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 04 00 00 00 00 00

00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 1 (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee00358  Data: 0000
	Capabilities: [90] Subsystem: Intel Corporation Device 4f53
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 40 3a 04 04 10 00 00 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 07 07 00 f0 00 00 20
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 01 00 00
40: 10 80 41 00 00 80 00 00 00 00 10 00 11 4c 11 01
50: 03 00 01 10 60 00 00 00 00 00 40 00 08 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 58 03 e0 fe 00 00 00 00 00 00 00 00
90: 0d a0 00 00 86 80 53 4f 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 11 08 00 00 00 00
e0: 00 00 c7 00 06 07 08 00 30 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 04 00 00 00 00 00

00:1c.1 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 2 (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee00378  Data: 0000
	Capabilities: [90] Subsystem: Intel Corporation Device 4f53
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 42 3a 04 04 10 00 00 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 08 08 00 f0 00 00 20
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 02 00 00
40: 10 80 41 00 00 80 00 00 00 00 10 00 11 4c 11 02
50: 03 00 01 10 60 00 00 00 00 00 40 00 08 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 78 03 e0 fe 00 00 00 00 00 00 00 00
90: 0d a0 00 00 86 80 53 4f 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 11 08 00 00 00 00
e0: 00 00 c7 00 06 07 08 00 30 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 04 00 00 00 00 00

00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 5 (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: d2200000-d22fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee00398  Data: 0000
	Capabilities: [90] Subsystem: Intel Corporation Device 4f53
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 48 3a 07 04 10 00 00 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 09 09 00 20 20 00 00
20: 20 d2 20 d2 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 01 00 00
40: 10 80 41 00 00 80 00 00 00 00 10 00 11 2c 11 05
50: 40 00 11 30 60 00 00 00 00 00 48 01 08 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 98 03 e0 fe 00 00 00 00 00 00 00 00
90: 0d a0 00 00 86 80 53 4f 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 11 08 00 00 00 00
e0: 00 00 c7 00 06 07 08 00 30 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 04 00 00 00 00 00

00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 4f53
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at 7080 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 34 3a 05 00 90 02 00 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 70 00 00 00 00 00 00 00 00 00 00 86 80 53 4f
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 04 00 00 00 00 00

00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 4f53
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 7060 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 35 3a 05 00 90 02 00 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 61 70 00 00 00 00 00 00 00 00 00 00 86 80 53 4f
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 04 00 00 00 00 00

00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 4f53
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 7040 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 36 3a 05 00 90 02 00 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 41 70 00 00 00 00 00 00 00 00 00 00 86 80 53 4f
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 04 00 00 00 00 00

00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1 (prog-if 20 [EHCI])
	Subsystem: Intel Corporation Device 4f53
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at d2421000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd
00: 86 80 3a 3a 06 00 90 02 00 20 03 0c 00 00 00 00
10: 00 10 42 d2 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 53 4f
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 c2 c9 00 00 00 00 0a 98 a0 20 00 00 00 00
60: 20 20 00 00 00 00 00 00 01 00 00 01 00 00 08 40
70: 00 00 e7 0f 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 13 00 06 03 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 aa ff 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 88 85 40 00 86 0f 04 00 0a 97 02 20

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=32
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: d2100000-d21fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Intel Corporation Device 4f53
00: 86 80 4e 24 07 00 10 00 90 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 0a 0a 20 10 10 80 22
20: 10 d2 10 d2 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 12 00 00
50: 0d 00 00 00 86 80 53 4f 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 04 00 00 00 00 00

00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
	Subsystem: Intel Corporation Device 4f53
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: iTCO_wdt
00: 86 80 16 3a 07 01 10 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 53 4f
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00
40: 01 04 00 00 80 00 00 00 01 05 00 00 10 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 8b 8a 8a 8b d0 00 00 00 8b 8a 8b 8b ff f0 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 0b 14 81 06 7c 00 11 08 7c 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 70 02 00 00 00 02 02 00 13 04 00 80 00 03 04 40
b0: 00 00 f0 00 00 00 00 00 00 00 00 08 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 11 11 00 00 67 45 00 00 c0 ff 00 00 0a 00 00 00
e0: 09 00 0c 10 01 00 c4 02 64 02 00 00 00 00 00 00
f0: 01 c0 d1 fe 00 00 00 00 86 0f 04 00 00 00 00 00

00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI Controller (prog-if 01 [AHCI 1.0])
	Subsystem: Intel Corporation Device 4f53
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 51
	Region 0: I/O ports at 7128 [size=8]
	Region 1: I/O ports at 7134 [size=4]
	Region 2: I/O ports at 7120 [size=8]
	Region 3: I/O ports at 7130 [size=4]
	Region 4: I/O ports at 7020 [size=32]
	Region 5: Memory at d2420000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
		Address: fee00418  Data: 0000
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA <?>
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci
	Kernel modules: ahci
00: 86 80 22 3a 07 04 b0 02 00 01 06 01 00 00 00 00
10: 29 71 00 00 35 71 00 00 21 71 00 00 31 71 00 00
20: 21 70 00 00 00 00 42 d2 00 00 00 00 86 80 53 4f
30: 00 00 00 00 80 00 00 00 00 00 00 00 0b 01 00 00
40: 00 80 00 80 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 01 a8 03 40 08 00 00 00 00 00 00 00 00 00 00 00
80: 05 70 09 00 18 04 e0 fe 00 00 00 00 00 00 00 00
90: 60 00 3f a9 93 01 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 12 b0 10 00 48 00 00 00
b0: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 04 00 00 00 00 00

00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
	Subsystem: Intel Corporation Device 4f53
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 18
	Region 0: Memory at f0204000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 7000 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801
00: 86 80 30 3a 03 00 80 02 00 00 05 0c 00 00 00 00
10: 04 40 20 f0 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 70 00 00 00 00 00 00 00 00 00 00 86 80 53 4f
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 02 00 00
40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 03 04 04 00 00 00 08 08 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 04 00 00 00 00 00

01:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
	Subsystem: Intel Corporation Gigabit ET Dual Port Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d2020000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at d1c00000 (32-bit, non-prefetchable) [size=4M]
	Region 2: I/O ports at 6020 [size=32]
	Region 3: Memory at d20c4000 (32-bit, non-prefetchable) [size=16K]
	Expansion ROM at d2800000 [disabled] [size=4M]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] MSI-X: Enable+ Count=10 Masked-
		Vector table: BAR=3 offset=00000000
		PBA: BAR=3 offset=00002000
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
		DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140] Device Serial Number 00-1b-21-ff-ff-24-1e-48
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 1
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [160] Single Root I/O Virtualization (SR-IOV)
		IOVCap:	Migration-, Interrupt Message Number: 000
		IOVCtl:	Enable- Migration- Interrupt- MSE- ARIHierarchy+
		IOVSta:	Migration-
		Initial VFs: 8, Total VFs: 8, Number of VFs: 0, Function Dependency Link: 00
		VF offset: 128, stride: 2, Device ID: 10ca
		Supported Page Size: 00000553, System Page Size: 00000001
		Region 0: Memory at 00000000d2040000 (64-bit, non-prefetchable)
		Region 3: Memory at 00000000d2060000 (64-bit, non-prefetchable)
		VF Migration: offset: 00000000, BIR: 0
	Kernel driver in use: igb
	Kernel modules: igb
00: 86 80 c9 10 07 04 10 00 01 00 00 02 10 00 80 00
10: 00 00 02 d2 00 00 c0 d1 21 60 00 00 00 40 0c d2
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 1c a0
30: 00 00 c0 ff 40 00 00 00 00 00 00 00 0b 01 00 00
40: 01 50 23 c8 00 20 00 1a 00 00 00 00 00 00 00 00
50: 05 70 80 01 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 11 a0 09 80 03 00 00 00 03 20 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 10 00 02 00 c2 8c 00 10 1f 28 19 00 41 6c 03 00
b0: 40 00 41 10 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 1f 00 00 00 05 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

01:00.1 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
	Subsystem: Intel Corporation Gigabit ET Dual Port Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at d2000000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at d1800000 (32-bit, non-prefetchable) [size=4M]
	Region 2: I/O ports at 6000 [size=32]
	Region 3: Memory at d20c0000 (32-bit, non-prefetchable) [size=16K]
	Expansion ROM at d2c00000 [disabled] [size=4M]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] MSI-X: Enable+ Count=10 Masked-
		Vector table: BAR=3 offset=00000000
		PBA: BAR=3 offset=00002000
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
		DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140] Device Serial Number 00-1b-21-ff-ff-24-1e-48
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 0
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [160] Single Root I/O Virtualization (SR-IOV)
		IOVCap:	Migration-, Interrupt Message Number: 000
		IOVCtl:	Enable- Migration- Interrupt- MSE- ARIHierarchy-
		IOVSta:	Migration-
		Initial VFs: 8, Total VFs: 8, Number of VFs: 0, Function Dependency Link: 01
		VF offset: 128, stride: 2, Device ID: 10ca
		Supported Page Size: 00000553, System Page Size: 00000001
		Region 0: Memory at 00000000d2080000 (64-bit, non-prefetchable)
		Region 3: Memory at 00000000d20a0000 (64-bit, non-prefetchable)
		VF Migration: offset: 00000000, BIR: 0
	Kernel driver in use: igb
	Kernel modules: igb
00: 86 80 c9 10 07 04 10 00 01 00 00 02 10 00 80 00
10: 00 00 00 d2 00 00 80 d1 01 60 00 00 00 00 0c d2
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 1c a0
30: 00 00 c0 ff 40 00 00 00 00 00 00 00 0a 02 00 00
40: 01 50 23 c8 00 20 00 1a 00 00 00 00 00 00 00 00
50: 05 70 80 01 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 11 a0 09 80 03 00 00 00 03 20 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 10 00 02 00 c2 8c 00 10 1f 28 19 00 41 6c 03 00
b0: 40 00 41 10 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 1f 00 00 00 05 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:00.0 VGA compatible controller: ATI Technologies Inc R580 [Radeon X1900 XT] (Primary) (prog-if 00 [VGA controller])
	Subsystem: ATI Technologies Inc Device 0b12
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 50
	Region 0: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 2: Memory at d2300000 (64-bit, non-prefetchable) [size=64K]
	Region 4: I/O ports at 5000 [size=256]
	Expansion ROM at d2320000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee003f8  Data: 0000
	Kernel driver in use: radeon
	Kernel modules: radeon
00: 02 10 49 72 07 04 10 00 00 00 00 03 10 00 80 00
10: 0c 00 00 e0 00 00 00 00 04 00 30 d2 00 00 00 00
20: 01 50 00 00 00 00 00 00 00 00 00 00 02 10 12 0b
30: 00 00 fe ff 50 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 12 0b
50: 01 58 02 06 00 00 00 00 10 80 01 00 a0 0f c8 03
60: 10 08 00 00 01 0d 00 00 40 00 01 11 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 00 81 00 f8 03 e0 fe 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:00.1 Display controller: ATI Technologies Inc R580 [Radeon X1900 XT] (Secondary)
	Subsystem: ATI Technologies Inc Device 0b13
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Region 0: Memory at d2310000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
00: 02 10 69 72 07 00 10 00 00 00 80 03 10 00 00 00
10: 04 00 31 d2 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 02 10 13 0b
30: 00 00 00 00 50 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 02 06 00 00 00 00 10 00 01 00 80 0f 00 00
60: 00 00 00 00 01 0d 00 00 40 00 01 11 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

03:00.0 PCI bridge: Integrated Device Technology, Inc. PES12N3A PCI Express Switch (rev 0c) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=03, secondary=04, subordinate=06, sec-latency=0
	I/O behind bridge: 00003000-00004fff
	Memory behind bridge: d0000000-d14fffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f01fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Upstream Port, MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-SlotPowerLimit 242.000000W
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [c0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [200] Virtual Channel <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 1d 11 18 80 07 00 10 00 0c 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 03 04 06 00 31 41 00 00
20: 00 d0 40 d1 01 f0 11 f0 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 00 00
40: 10 c0 51 40 24 80 c8 03 0f 00 09 00 41 3c 01 00
50: 40 00 41 10 00 00 00 00 00 00 40 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 00 03 c8 08 00 00 00 00 00 00 00 00 00 00 00
d0: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 0d 00 00 00 00 00 00 00 00 00 00 00 1d 11 18 80

04:02.0 PCI bridge: Integrated Device Technology, Inc. PES12N3A PCI Express Switch (rev 0c) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=04, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: d0c00000-d14fffff
	Prefetchable memory behind bridge: 00000000f0100000-00000000f01fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Downstream Port (Slot-), MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Surprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
	Capabilities: [c0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee003b8  Data: 0000
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [200] Virtual Channel <?>
	Capabilities: [320] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl+ DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 1d 11 18 80 07 04 10 00 0c 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 04 05 05 00 41 41 00 00
20: c0 d0 40 d1 11 f0 11 f0 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 00 00
40: 10 c0 61 40 24 80 00 00 0f 00 09 00 41 3c 19 02
50: 40 00 41 30 00 00 00 00 00 00 40 00 00 00 00 00
60: 00 00 00 00 20 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 d0 03 c8 08 00 00 00 00 00 00 00 00 00 00 00
d0: 05 00 81 00 b8 03 e0 fe 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 0d 00 00 00 00 00 00 00 00 00 00 00 1d 11 18 80

04:04.0 PCI bridge: Integrated Device Technology, Inc. PES12N3A PCI Express Switch (rev 0c) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=04, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: d0000000-d08fffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f00fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Downstream Port (Slot-), MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Surprise+ LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
	Capabilities: [c0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee003d8  Data: 0000
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [200] Virtual Channel <?>
	Capabilities: [320] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl+ DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 1d 11 18 80 07 04 10 00 0c 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 04 06 06 00 31 31 00 00
20: 00 d0 80 d0 01 f0 01 f0 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 00 00
40: 10 c0 61 40 24 80 00 00 0f 00 09 00 41 3c 19 04
50: 40 00 41 30 00 00 00 00 00 00 40 00 00 00 00 00
60: 00 00 00 00 20 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 d0 03 c8 08 00 00 00 00 00 00 00 00 00 00 00
d0: 05 00 81 00 d8 03 e0 fe 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 0d 00 00 00 00 00 00 00 00 00 00 00 1d 11 18 80

05:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
	Subsystem: Intel Corporation Gigabit ET2 Quad Port Server Adapter
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at d1420000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at d1000000 (32-bit, non-prefetchable) [size=4M]
	Region 2: I/O ports at 4020 [size=32]
	Region 3: Memory at d1444000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] MSI-X: Enable- Count=10 Masked-
		Vector table: BAR=3 offset=00000000
		PBA: BAR=3 offset=00002000
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
		DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140] Device Serial Number 00-1b-21-ff-ff-66-d7-28
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 1
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [160] Single Root I/O Virtualization (SR-IOV)
		IOVCap:	Migration-, Interrupt Message Number: 000
		IOVCtl:	Enable- Migration- Interrupt- MSE- ARIHierarchy-
		IOVSta:	Migration-
		Initial VFs: 8, Total VFs: 8, Number of VFs: 0, Function Dependency Link: 00
		VF offset: 384, stride: 2, Device ID: 10ca
		Supported Page Size: 00000553, System Page Size: 00000001
		Region 0: Memory at 00000000f0160000 (64-bit, prefetchable)
		Region 3: Memory at 00000000f0140000 (64-bit, prefetchable)
		VF Migration: offset: 00000000, BIR: 0
	Kernel modules: igb
00: 86 80 26 15 03 00 10 00 01 00 00 02 10 00 80 00
10: 00 00 42 d1 00 00 00 d1 21 40 00 00 00 40 44 d1
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 6c a0
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 01 00 00
40: 01 50 23 c8 00 20 00 1a 00 00 00 00 00 00 00 00
50: 05 70 80 01 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 11 a0 09 00 03 00 00 00 03 20 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 10 00 02 00 c2 8c 00 10 1f 28 19 00 41 6c 03 02
b0: 40 00 41 10 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 1f 00 00 00 05 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

05:00.1 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
	Subsystem: Intel Corporation Gigabit ET2 Quad Port Server Adapter
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at d1400000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at d0c00000 (32-bit, non-prefetchable) [size=4M]
	Region 2: I/O ports at 4000 [size=32]
	Region 3: Memory at d1440000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] MSI-X: Enable- Count=10 Masked-
		Vector table: BAR=3 offset=00000000
		PBA: BAR=3 offset=00002000
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
		DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140] Device Serial Number 00-1b-21-ff-ff-66-d7-28
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 0
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [160] Single Root I/O Virtualization (SR-IOV)
		IOVCap:	Migration-, Interrupt Message Number: 000
		IOVCtl:	Enable- Migration- Interrupt- MSE- ARIHierarchy-
		IOVSta:	Migration-
		Initial VFs: 8, Total VFs: 8, Number of VFs: 0, Function Dependency Link: 01
		VF offset: 384, stride: 2, Device ID: 10ca
		Supported Page Size: 00000553, System Page Size: 00000001
		Region 0: Memory at 00000000f0120000 (64-bit, prefetchable)
		Region 3: Memory at 00000000f0100000 (64-bit, prefetchable)
		VF Migration: offset: 00000000, BIR: 0
	Kernel modules: igb
00: 86 80 26 15 03 00 10 00 01 00 00 02 10 00 80 00
10: 00 00 40 d1 00 00 c0 d0 01 40 00 00 00 00 44 d1
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 6c a0
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 02 00 00
40: 01 50 23 c8 00 20 00 1a 00 00 00 00 00 00 00 00
50: 05 70 80 01 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 11 a0 09 00 03 00 00 00 03 20 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 10 00 02 00 c2 8c 00 10 1f 28 19 00 41 6c 03 02
b0: 40 00 41 10 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 1f 00 00 00 05 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

06:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
	Subsystem: Intel Corporation Gigabit ET2 Quad Port Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d0820000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at d0400000 (32-bit, non-prefetchable) [size=4M]
	Region 2: I/O ports at 3020 [size=32]
	Region 3: Memory at d0844000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] MSI-X: Enable+ Count=10 Masked-
		Vector table: BAR=3 offset=00000000
		PBA: BAR=3 offset=00002000
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
		DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140] Device Serial Number 00-1b-21-ff-ff-66-d7-2a
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 1
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [160] Single Root I/O Virtualization (SR-IOV)
		IOVCap:	Migration-, Interrupt Message Number: 000
		IOVCtl:	Enable- Migration- Interrupt- MSE- ARIHierarchy-
		IOVSta:	Migration-
		Initial VFs: 8, Total VFs: 8, Number of VFs: 0, Function Dependency Link: 00
		VF offset: 384, stride: 2, Device ID: 10ca
		Supported Page Size: 00000553, System Page Size: 00000001
		Region 0: Memory at 00000000f0060000 (64-bit, prefetchable)
		Region 3: Memory at 00000000f0040000 (64-bit, prefetchable)
		VF Migration: offset: 00000000, BIR: 0
	Kernel driver in use: igb
	Kernel modules: igb
00: 86 80 26 15 07 04 10 00 01 00 00 02 10 00 80 00
10: 00 00 82 d0 00 00 40 d0 21 30 00 00 00 40 84 d0
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 6c a0
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 01 00 00
40: 01 50 23 48 00 20 00 1a 00 00 00 00 00 00 00 00
50: 05 70 80 01 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 11 a0 09 80 03 00 00 00 03 20 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 10 00 02 00 c2 8c 00 10 1f 28 09 00 41 6c 03 04
b0: 40 00 41 10 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 1f 00 00 00 05 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

06:00.1 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
	Subsystem: Intel Corporation Gigabit ET2 Quad Port Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at d0800000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at d0000000 (32-bit, non-prefetchable) [size=4M]
	Region 2: I/O ports at 3000 [size=32]
	Region 3: Memory at d0840000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] MSI-X: Enable+ Count=10 Masked-
		Vector table: BAR=3 offset=00000000
		PBA: BAR=3 offset=00002000
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
		DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140] Device Serial Number 00-1b-21-ff-ff-66-d7-2a
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 0
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [160] Single Root I/O Virtualization (SR-IOV)
		IOVCap:	Migration-, Interrupt Message Number: 000
		IOVCtl:	Enable- Migration- Interrupt- MSE- ARIHierarchy-
		IOVSta:	Migration-
		Initial VFs: 8, Total VFs: 8, Number of VFs: 0, Function Dependency Link: 01
		VF offset: 384, stride: 2, Device ID: 10ca
		Supported Page Size: 00000553, System Page Size: 00000001
		Region 0: Memory at 00000000f0020000 (64-bit, prefetchable)
		Region 3: Memory at 00000000f0000000 (64-bit, prefetchable)
		VF Migration: offset: 00000000, BIR: 0
	Kernel driver in use: igb
	Kernel modules: igb
00: 86 80 26 15 07 04 10 00 01 00 00 02 10 00 80 00
10: 00 00 80 d0 00 00 00 d0 01 30 00 00 00 00 84 d0
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 6c a0
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 02 00 00
40: 01 50 23 48 00 20 00 1a 00 00 00 00 00 00 00 00
50: 05 70 80 01 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 11 a0 09 80 03 00 00 00 03 20 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 10 00 02 00 c2 8c 00 10 1f 28 09 00 41 6c 03 04
b0: 40 00 41 10 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 1f 00 00 00 05 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

09:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II Controller (rev b2) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Intel Corporation Device 4f53
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 2018 [size=8]
	Region 1: I/O ports at 2024 [size=4]
	Region 2: I/O ports at 2010 [size=8]
	Region 3: I/O ports at 2020 [size=4]
	Region 4: I/O ports at 2000 [size=16]
	Region 5: Memory at d2200000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <256ns, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 1f, GenCap- CGenEn- ChkCap- ChkEn-
	Kernel driver in use: pata_marvell
	Kernel modules: ata_generic, pata_acpi, pata_marvell, ahci
00: ab 11 21 61 07 00 10 00 b2 8f 01 01 10 00 00 00
10: 19 20 00 00 25 20 00 00 11 20 00 00 21 20 00 00
20: 01 20 00 00 00 00 20 d2 00 00 00 00 86 80 53 4f
30: 00 00 00 00 48 00 00 00 00 00 00 00 0b 01 00 00
40: 24 c9 c0 00 1f 80 00 00 01 50 02 5a 00 20 00 13
50: 05 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 50 c4 21 40 b0 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 10 00 11 00 c0 0f 24 00 00 24 00 00 11 a4 03 00
f0: 40 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00

0a:02.0 Serial controller: NetMos Technology PCI 9835 Multi-I/O Controller (rev 01) (prog-if 02 [16550])
	Subsystem: LSI Logic / Symbios Logic Device 0001
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 1030 [size=8]
	Region 1: I/O ports at 1028 [size=8]
	Region 2: I/O ports at 1020 [size=8]
	Region 3: I/O ports at 1018 [size=8]
	Region 4: I/O ports at 1010 [size=8]
	Region 5: I/O ports at 1000 [size=16]
	Kernel driver in use: serial
	Kernel modules: parport_serial
00: 10 97 35 98 03 00 80 02 01 02 00 07 10 20 00 00
10: 31 10 00 00 29 10 00 00 21 10 00 00 19 10 00 00
20: 11 10 00 00 01 10 00 00 00 00 00 00 00 10 01 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 01 00 00
40: 80 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0a:03.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22A IEEE-1394a-2000 Controller (PHY/Link) [iOHCI-Lynx] (prog-if 10 [OHCI])
	Subsystem: Intel Corporation Device 4f53
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 1000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at d2104000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at d2100000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci
00: 4c 10 23 80 16 00 10 02 00 10 00 0c 10 20 00 00
10: 00 40 10 d2 00 00 10 d2 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 53 4f
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 01 02 04
40: 00 00 00 00 01 00 02 7e 00 80 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 08 00 00 00
f0: 10 00 00 00 86 10 00 00 86 80 53 4f 00 00 00 00

3f:00.0 Host bridge: Intel Corporation Device 2c71 (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 71 2c 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 28 00 00 00 00 00 00 00 28 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 28 00 28 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 03 04 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 14 14 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 80 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:00.1 Host bridge: Intel Corporation Xeon 5600 Series QuickPath Architecture System Address Decoder (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 81 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 10 11 11 11 11 11 31 00 00 00 00 00 00 3a 00 00
50: 0d 00 00 f8 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 18 fa 48 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: c3 0c 00 00 c0 0f 00 00 c3 1a 00 00 c0 1a 00 00
90: c0 1a 00 00 c0 1a 00 00 c0 1a 00 00 c0 1a 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 11 11 11 11 00 00 00 00 11 11 11 11 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:02.0 Host bridge: Intel Corporation Xeon 5600 Series QPI Link 0 (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 90 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 01 8f 08 00 00 00 00 00 00 34 00 00 00 00 00
50: 00 00 00 86 00 00 00 00 55 45 06 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: ad f6 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 7f 00 86 02 00 00 00 00 00 b3 00 00 00 00
d0: 01 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:02.1 Host bridge: Intel Corporation Xeon 5600 Series QPI Physical 0 (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 91 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 09 00 ff f0 01 00 80 0b 00 00 10 00 73 02 00 00
50: 18 01 0c 18 18 00 00 00 01 00 00 00 01 00 00 00
60: 00 00 00 00 00 00 00 00 00 51 c3 10 a8 a0 c0 00
70: 00 00 00 00 ff ff 0f 80 00 00 00 00 ff ff 0f 00
80: 03 0f 0f 07 03 03 03 07 01 00 00 00 01 00 0f 0f
90: 82 00 00 00 02 02 01 00 08 08 88 08 02 05 d0 00
a0: 00 5a 00 00 08 28 32 00 84 00 00 06 02 00 00 00
b0: 77 15 ae 4d 00 00 00 00 00 00 00 00 01 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 11 04 11 04 00 00 00 00 00 00 00 00 03 00 08 00
e0: 00 00 02 00 00 00 40 00 00 00 82 24 00 00 00 00
f0: 00 00 00 00 42 01 00 00 00 00 00 00 00 00 00 00

3f:02.2 Host bridge: Intel Corporation Xeon 5600 Series Mirror Port Link 0 (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 92 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:02.3 Host bridge: Intel Corporation Xeon 5600 Series Mirror Port Link 1 (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 93 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:03.0 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Registers (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 98 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 40 07 00 00 08 00 00 00
50: 00 00 00 00 0f 00 00 00 00 00 00 00 00 00 00 00
60: 89 44 02 00 94 00 00 00 00 00 00 00 00 00 00 00
70: 0d 01 02 00 02 03 00 00 00 00 00 00 00 0b 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:03.1 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Target Address Decoder (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 99 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 85 0c 00 00 c3 0c 00 00 c0 0f 00 00 45 1a 00 00
90: c3 1a 00 00 c0 1a 00 00 c0 1a 00 00 c0 1a 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 10 02 10 02 22 22 22 22 00 00 00 00 10 02 10 02
d0: 01 01 01 01 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:03.4 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Test Registers (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 9c 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 09 00 ff f0 01 00 80 0b 03 10 10 04 e7 00 01 03
50: 0a 00 00 0a 0a 00 00 00 15 00 00 00 01 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 40 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 0e 00 00 00 00 00 00 00
b0: ef cd ab 89 00 00 00 00 00 00 00 00 01 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 40 00 00 00 00 00
d0: 0f 00 11 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 45 15 00 00 ea 06 20 10

3f:04.0 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 0 Control (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 a0 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 04 00 00 32 40 3f 06 00 00 00 00
60: b8 1a 90 00 00 00 00 00 01 00 00 00 00 00 00 00
70: 58 1b 06 08 10 00 00 00 44 06 00 00 03 00 00 00
80: 58 44 34 12 14 b5 00 00 89 f3 2a 00 4a fa 54 02
90: 9c 02 10 00 90 1a 40 60 f0 3d 01 00 50 62 e4 03
a0: 00 00 00 00 00 00 01 01 04 04 01 01 01 02 05 09
b0: 05 06 05 09 18 f7 ae 0d c0 29 00 00 50 14 00 00
c0: 14 05 0a 00 04 01 02 00 14 0a 09 00 00 0a 00 00
d0: 09 13 00 00 39 00 00 00 03 20 00 00 00 00 00 00
e0: 14 05 00 00 00 01 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:04.1 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 0 Address (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 a1 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 a8 02 00 00 00 10 00 00
50: 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 08 00 00 00 00 00 00 00 00 00 cc ff 08
90: 00 50 ff 01 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:04.2 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 0 Rank (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 a2 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 07 00 00 00 07 00 00 00 07 00 00 00 07 00 00 00
50: 07 00 00 00 07 00 00 00 07 00 00 00 07 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 01 00 00 00 00 00 00 00 01 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:04.3 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 0 Thermal Control (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 a3 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 01 ff 04 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: ff ff ff ff 00 40 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 01 00 00 00 01 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:05.0 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 1 Control (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 a8 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 04 00 00 32 40 3f 06 00 00 00 00
60: b8 1a 90 00 00 00 00 00 01 00 00 00 00 00 00 00
70: 58 1b 06 08 10 00 00 00 44 06 00 00 03 00 00 00
80: 58 44 34 12 14 b5 00 00 89 f3 2a 00 4a fa 54 02
90: 9c 02 10 00 90 1a 40 60 f0 3d 01 00 50 62 e5 03
a0: 00 00 00 00 00 00 01 01 04 04 01 01 01 02 05 09
b0: 05 06 05 09 18 f7 ae 0d c0 29 00 00 50 14 00 00
c0: 14 05 0a 00 04 01 02 00 14 0a 09 00 00 0a 00 00
d0: 09 13 00 00 3a 00 00 00 03 20 00 00 00 00 00 00
e0: 14 05 00 00 00 01 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:05.1 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 1 Address (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 a9 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 a8 02 00 00 00 10 00 00
50: 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 08 00 00 00 00 00 00 00 00 00 cc ff 08
90: 00 50 ff 01 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:05.2 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 1 Rank (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 aa 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 07 00 00 00 07 00 00 00 07 00 00 00 07 00 00 00
50: 07 00 00 00 07 00 00 00 07 00 00 00 07 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 01 00 00 00 00 00 00 00 01 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:05.3 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 1 Thermal Control (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 ab 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 01 ff 04 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: ff ff ff ff 00 40 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 01 00 00 00 01 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:06.0 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 2 Control (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 b0 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 04 00 00 32 40 3f 06 00 00 00 00
60: b8 1a 90 00 00 00 00 00 01 00 00 00 00 00 00 00
70: 58 1b 06 08 10 00 00 00 44 06 00 00 03 00 00 00
80: 58 44 34 12 14 b5 00 00 89 f3 2a 00 4a fa 54 02
90: 9c 02 10 00 90 1a 40 60 f0 3d 01 00 50 62 e5 03
a0: 00 00 00 00 00 00 01 01 04 04 01 01 01 02 05 09
b0: 05 06 05 09 18 f7 ae 0d c0 29 00 00 50 14 00 00
c0: 14 05 0a 00 04 01 02 00 14 0a 09 00 00 0a 00 00
d0: 09 13 00 00 3b 00 00 00 03 20 00 00 00 00 00 00
e0: 14 05 00 00 00 01 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:06.1 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 2 Address (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 b1 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 a8 02 00 00 00 10 00 00
50: 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 08 00 78 ff 00 00 00 00 00 00 d8 ff 08
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:06.2 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 2 Rank (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 b2 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 07 00 00 00 07 00 00 00 07 00 00 00 07 00 00 00
50: 07 00 00 00 07 00 00 00 07 00 00 00 07 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 01 00 00 00 00 00 00 00 01 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

3f:06.3 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 2 Thermal Control (rev 02)
	Subsystem: Intel Corporation Device 8086
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
00: 86 80 b3 2d 06 00 00 00 02 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 86 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 01 ff 04 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: ff ff ff ff 00 40 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 01 00 00 00 01 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


--------------040709020301090407070007--
