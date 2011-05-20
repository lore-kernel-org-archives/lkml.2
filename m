Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015Ab1ETHN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:13:56 -0400
Received: from ns5.dns-guards.com ([41.203.20.164]:43709 "EHLO
	velocity.dns-guards.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375Ab1ETHNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:13:51 -0400
Message-ID: <4DD61495.4020706@radicalsystems.co.za>
Date: Fri, 20 May 2011 09:13:25 +0200
From: Jan Zwiegers <jan@radicalsystems.co.za>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PCI BAR1 Unassigned
References: <4DD5452F.9050108@radicalsystems.co.za> <BANLkTi=g=fKaXF4uwwjLSX-R+pk0FUa6OQ@mail.gmail.com> <sig.512079e334.4DD57D44.50009@radicalsystems.co.za> <BANLkTinK5PtxuWpaJq9XeDDN_quGj=MhTg@mail.gmail.com> <sig.2120eee186.4DD597A2.4040306@radicalsystems.co.za> <BANLkTi=DJsiHuic4u90nEw-jPc2AKWNXcw@mail.gmail.com>
In-Reply-To: <BANLkTi=DJsiHuic4u90nEw-jPc2AKWNXcw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-ID: velocity.dns-guards.com ()
X-Assp-Version: 1.7.1.3(1.0.2)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - velocity.dns-guards.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - radicalsystems.co.za
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-20 12:38 AM, Bjorn Helgaas wrote:
> On Thu, May 19, 2011 at 4:20 PM, Jan Zwiegers<jan@radicalsystems.co.za>  wrote:
>> On 2011-05-20 12:13 AM, Bjorn Helgaas wrote:
>>>
>>> On Thu, May 19, 2011 at 2:27 PM, Jan Zwiegers<jan@radicalsystems.co.za>
>>>   wrote:
>>>>
>>>> On 2011-05-19 08:50 PM, Bjorn Helgaas wrote:
>>>>>
>>>>> On Thu, May 19, 2011 at 10:28 AM, Jan Zwiegers<jan@radicalsystems.co.za>
>>>>>   wrote:
>>>>>>
>>>>>> I have the problem below where my PCI card's second BAR does not get
>>>>>> assigned.
>>>>>> What can be the cause of this problem?
>>>>>> The last kernel I tested on which worked OK was 2.6.27.
>>>>>> My current problematic kernel 2.6.35.
>>>>>>
>>>>>> 05:01.0 Unassigned class [ff00]: Eagle Technology PCI-703 Analog I/O
>>>>>> Card
>>>>>> (rev 5c)
>>>>>>     Flags: bus master, slow devsel, latency 32, IRQ 22
>>>>>>     Memory at 93b00000 (type 3, prefetchable) [size=2K]
>>>>>>     Memory at<unassigned>      (type 3, prefetchable)
>>>>>>     Capabilities: [80] #00 [0600]
>>>>>>     Kernel modules: pci703drv
>>>>>
>>>>> Could be resource exhaustion or, more likely, we ran out because we
>>>>> now assign resource to things that don't need them, leaving none for
>>>>> things that *do* need them.  This sounds like a regression, so we
>>>>> should open a bugzilla for it and attach dmesg logs from 2.6.27 and
>>>>> 2.6.35.
>>>>>
>>>>> Does this problem keep the driver from working?  (Sometimes drivers
>>>>> don't actually use all the BARs a device supports.)
>>>>
>>>> I'm the maintainer of the driver and was involved in the development of
>>>> the
>>>> board as well in 2003. The board uses two BARS and the second BAR is the
>>>> most important. The board worked fine since the 2.4 days and only
>>>> recently
>>>> became problematic. I suspect it works on even later kernels than 27,
>>>> maybe
>>>> 2.6.32.
>>>>
>>>> My knowledge is too little to actually determine if the problem is
>>>> because
>>>> the FPGA based PCI interface is not within spec or something that changed
>>>> in
>>>> the kernel, because of the post .30 releases becoming more strict to PCI
>>>> specification, i.e. BIOS / Kernel interaction.
>>>
>>> Well, let's at least look at the working and broken dmesg logs.  My
>>> money is on kernel breakage.  If it used to work, it should still
>>> work.
>>
>> What do you need from me? I have at least 3 machines on which it used to
>> work and is now running a later kernel. I can post dmesg from both .27 and
>> .35. Will do tomorrow when I'm back at the office.
>
> Since you don't have continuous access to the machines, maybe you can
> collect the /proc/iomem and "lspci -v" output at the same time you
> collect the dmesg logs.  That should be enough to get started.
>
> Thanks,
>    Bjorn
>
As requested I collected info for iomem, lspci and dmesg from the same 
machine running 2.6.27 & 2.6.35.
The dmesg shows my driver loading correctly on 2.6.27 and failing on 2.6.35.

Output from 2.6.27
dmesg:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.27-7-generic (buildd@rothera) (gcc 
version 4.3.2 (Ubuntu 4.3.2-1ubuntu10) ) #1 SMP Fri Oct 24 06:42:44 UTC 
2008 (Ubuntu 2.6.27-7.14-generic)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ec0a000 (usable)
[    0.000000]  BIOS-e820: 000000007ec0a000 - 000000007ed35000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ed35000 - 000000007fd75000 (usable)
[    0.000000]  BIOS-e820: 000000007fd75000 - 000000007fd7d000 (reserved)
[    0.000000]  BIOS-e820: 000000007fd7d000 - 000000007fe2d000 (usable)
[    0.000000]  BIOS-e820: 000000007fe2d000 - 000000007fe31000 (reserved)
[    0.000000]  BIOS-e820: 000000007fe31000 - 000000007feaa000 (usable)
[    0.000000]  BIOS-e820: 000000007feaa000 - 000000007fee9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fee9000 - 000000007feed000 (usable)
[    0.000000]  BIOS-e820: 000000007feed000 - 000000007feff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007feff000 - 000000007ff00000 (usable)
[    0.000000]  BIOS-e820: 000000007ff00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] last_pfn = 0x7ff00 max_arch_pfn = 0x100000
[    0.000000] kernel direct mapping tables up to 38000000 @ 7000-c000
[    0.000000] RAMDISK: 37822000 - 37fef044
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL )
[    0.000000] ACPI: RSDT 7FEFD038, 0050 (r1 INTEL  D946GZIS       57 
     1000013)
[    0.000000] ACPI: FACP 7FEFC000, 0074 (r1 INTEL  D946GZIS       57 
MSFT  1000013)
[    0.000000] ACPI: DSDT 7FEF7000, 44D7 (r1 INTEL  D946GZIS       57 
MSFT  1000013)
[    0.000000] ACPI: FACS 7FEAA000, 0040
[    0.000000] ACPI: APIC 7FEF6000, 0078 (r1 INTEL  D946GZIS       57 
MSFT  1000013)
[    0.000000] ACPI: WDDT 7FEF5000, 0040 (r1 INTEL  D946GZIS       57 
MSFT  1000013)
[    0.000000] ACPI: MCFG 7FEF4000, 003C (r1 INTEL  D946GZIS       57 
MSFT  1000013)
[    0.000000] ACPI: ASF! 7FEF3000, 00A6 (r32 INTEL  D946GZIS       57 
MSFT  1000013)
[    0.000000] ACPI: HPET 7FEF2000, 0038 (r1 INTEL  D946GZIS       57 
MSFT  1000013)
[    0.000000] ACPI: SSDT 7FEF1000, 01BC (r1 INTEL     CpuPm       57 
MSFT  1000013)
[    0.000000] ACPI: SSDT 7FEF0000, 0175 (r1 INTEL   Cpu0Ist       57 
MSFT  1000013)
[    0.000000] ACPI: SSDT 7FEEF000, 0175 (r1 INTEL   Cpu1Ist       57 
MSFT  1000013)
[    0.000000] ACPI: SSDT 7FEEE000, 0175 (r1 INTEL   Cpu2Ist       57 
MSFT  1000013)
[    0.000000] ACPI: SSDT 7FEED000, 0175 (r1 INTEL   Cpu3Ist       57 
MSFT  1000013)
[    0.000000] 1151MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 38000000
[    0.000000]   low ram: 00000000 - 38000000
[    0.000000]   bootmap 00008000 - 0000f000
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0038000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> 
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> 
[0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00005c0a20]    TEXT DATA BSS ==> 
[0000100000 - 00005c0a20]
[    0.000000]   #4 [0037822000 - 0037fef044]          RAMDISK ==> 
[0037822000 - 0037fef044]
[    0.000000]   #5 [00005c1000 - 00005c4000]    INIT_PG_TABLE ==> 
[00005c1000 - 00005c4000]
[    0.000000]   #6 [000009fc00 - 0000100000]    BIOS reserved ==> 
[000009fc00 - 0000100000]
[    0.000000]   #7 [0000007000 - 0000008000]          PGTABLE ==> 
[0000007000 - 0000008000]
[    0.000000]   #8 [0000008000 - 000000f000]          BOOTMAP ==> 
[0000008000 - 000000f000]
[    0.000000] found SMP MP-table at [c00fe200] 000fe200
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00038000
[    0.000000]   HighMem  0x00038000 -> 0x0007ff00
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000008f
[    0.000000]     0: 0x00000100 -> 0x0007ec0a
[    0.000000]     0: 0x0007ed35 -> 0x0007fd75
[    0.000000]     0: 0x0007fd7d -> 0x0007fe2d
[    0.000000]     0: 0x0007fe31 -> 0x0007feaa
[    0.000000]     0: 0x0007fee9 -> 0x0007feed
[    0.000000]     0: 0x0007feff -> 0x0007ff00
[    0.000000] On node 0 totalpages: 523527
[    0.000000] free_area_init_node: node 0, pgdat c048a500, node_mem_map 
c1000000
[    0.000000]   DMA zone: 3947 pages, LIFO batch:0
[    0.000000]   Normal zone: 223300 pages, LIFO batch:31
[    0.000000]   HighMem zone: 291674 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] PM: Registered nosave memory: 000000000008f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 
80000000:7ff80000)
[    0.000000] PERCPU: Allocating 41628 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 4, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 518921
[    0.000000] Kernel command line: 
root=UUID=3e30d82b-1f24-48b7-ba4f-d9124fd06022 ro quiet splash
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] TSC: PIT calibration confirmed by PMTIMER.
[    0.000000] TSC: using PIT calibration value
[    0.000000] Detected 1798.202 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
[    0.004000] Memory: 2061004k/2096128k available (2572k kernel code, 
32340k reserved, 1160k data, 424k init, 1177056k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xffc77000 - 0xfffff000   (3616 kB)
[    0.004000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.004000]     vmalloc : 0xf8800000 - 0xff3fe000   ( 107 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.004000]       .init : 0xc04ab000 - 0xc0515000   ( 424 kB)
[    0.004000]       .data : 0xc038329a - 0xc04a5680   (1160 kB)
[    0.004000]       .text : 0xc0100000 - 0xc038329a   (2572 kB)
[    0.004000] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=4, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 3596.40 BogoMIPS (lpj=7192808)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] AppArmor: AppArmor initialized
[    0.004000] Mount-cache hash table entries: 512
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 1024K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] using mwait in idle threads.
[    0.004000] Checking 'hlt' instruction... OK.
[    0.018129] ACPI: Core revision 20080609
[    0.020053] ACPI: Checking initramfs for custom DSDT
[    0.394745] ENABLING IO-APIC IRQs
[    0.394923] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.434621] CPU0: Intel Genuine Intel(R) CPU            2160  @ 
1.80GHz stepping 02
[    0.436027] Booting processor 1/1 ip 6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 3596.41 
BogoMIPS (lpj=7192839)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 1024K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.520433] CPU1: Intel Genuine Intel(R) CPU            2160  @ 
1.80GHz stepping 02
[    0.520452] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.524053] Brought up 2 CPUs
[    0.524056] Total of 2 processors activated (7192.82 BogoMIPS).
[    0.524079] CPU0 attaching sched-domain:
[    0.524082]  domain 0: span 0-1 level MC
[    0.524085]   groups: 0 1
[    0.524092] CPU1 attaching sched-domain:
[    0.524095]  domain 0: span 0-1 level MC
[    0.524097]   groups: 1 0
[    0.524182] net_namespace: 840 bytes
[    0.524182] Booting paravirtualized kernel on bare hardware
[    0.524311] Time:  6:44:31  Date: 05/20/11
[    0.524340] NET: Registered protocol family 16
[    0.524363] EISA bus registered
[    0.524363] ACPI: bus type pci registered
[    0.524363] PCI: MCFG configuration 0: base f0000000 segment 0 buses 
0 - 127
[    0.524363] PCI: Not using MMCONFIG.
[    0.525834] PCI: Using configuration type 1 for base access
[    0.528834] ACPI: EC: Look up EC in DSDT
[    0.533211] ACPI: Interpreter enabled
[    0.533215] ACPI: (supports S0 S3 S4 S5)
[    0.533231] ACPI: Using IOAPIC for interrupt routing
[    0.533278] PCI: MCFG configuration 0: base f0000000 segment 0 buses 
0 - 127
[    0.534315] PCI: MCFG area at f0000000 reserved in ACPI motherboard 
resources
[    0.534318] PCI: Using MMCONFIG for extended config space
[    0.537256] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.540125] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.540129] pci 0000:00:01.0: PME# disabled
[    0.540191] PCI: 0000:00:1b.0 reg 10 64bit mmio: [93100000, 93103fff]
[    0.540231] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.540235] pci 0000:00:1b.0: PME# disabled
[    0.540286] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.540291] pci 0000:00:1c.0: PME# disabled
[    0.540343] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.540347] pci 0000:00:1c.2: PME# disabled
[    0.540398] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.540403] pci 0000:00:1c.3: PME# disabled
[    0.540442] PCI: 0000:00:1d.0 reg 20 io port: [3080, 309f]
[    0.540492] PCI: 0000:00:1d.1 reg 20 io port: [3060, 307f]
[    0.540542] PCI: 0000:00:1d.2 reg 20 io port: [3040, 305f]
[    0.540592] PCI: 0000:00:1d.3 reg 20 io port: [3020, 303f]
[    0.540647] PCI: 0000:00:1d.7 reg 10 32bit mmio: [93104400, 931047ff]
[    0.540695] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.540700] pci 0000:00:1d.7: PME# disabled
[    0.540817] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 
ACPI/GPIO/TCO
[    0.540822] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 
GPIO
[    0.540846] PCI: 0000:00:1f.1 reg 10 io port: [0, 7]
[    0.540853] PCI: 0000:00:1f.1 reg 14 io port: [0, 3]
[    0.540860] PCI: 0000:00:1f.1 reg 18 io port: [0, 7]
[    0.540867] PCI: 0000:00:1f.1 reg 1c io port: [0, 3]
[    0.540874] PCI: 0000:00:1f.1 reg 20 io port: [30b0, 30bf]
[    0.540915] PCI: 0000:00:1f.2 reg 10 io port: [30c8, 30cf]
[    0.540921] PCI: 0000:00:1f.2 reg 14 io port: [30e4, 30e7]
[    0.540928] PCI: 0000:00:1f.2 reg 18 io port: [30c0, 30c7]
[    0.540934] PCI: 0000:00:1f.2 reg 1c io port: [30e0, 30e3]
[    0.540940] PCI: 0000:00:1f.2 reg 20 io port: [30a0, 30af]
[    0.540947] PCI: 0000:00:1f.2 reg 24 32bit mmio: [93104000, 931043ff]
[    0.540966] pci 0000:00:1f.2: PME# supported from D3hot
[    0.540970] pci 0000:00:1f.2: PME# disabled
[    0.541013] PCI: 0000:00:1f.3 reg 20 io port: [3000, 301f]
[    0.541069] PCI: 0000:01:00.0 reg 10 32bit mmio: [92000000, 92ffffff]
[    0.541076] PCI: 0000:01:00.0 reg 14 32bit mmio: [80000000, 8fffffff]
[    0.541090] PCI: 0000:01:00.0 reg 1c 64bit mmio: [90000000, 91ffffff]
[    0.541096] PCI: 0000:01:00.0 reg 24 io port: [2000, 207f]
[    0.541103] PCI: 0000:01:00.0 reg 30 32bit mmio: [fffe0000, ffffffff]
[    0.541154] PCI: bridge 0000:00:01.0 io port: [2000, 2fff]
[    0.541158] PCI: bridge 0000:00:01.0 32bit mmio: [90000000, 92ffffff]
[    0.541163] PCI: bridge 0000:00:01.0 64bit mmio pref: [80000000, 
8fffffff]
[    0.541209] PCI: bridge 0000:00:1c.0 32bit mmio: [93200000, 932fffff]
[    0.541258] PCI: bridge 0000:00:1c.2 32bit mmio: [93300000, 933fffff]
[    0.541307] PCI: bridge 0000:00:1c.3 32bit mmio: [93400000, 934fffff]
[    0.541349] PCI: 0000:05:01.0 reg 10 32bit mmio: [0, 7ff]
[    0.541356] PCI: 0000:05:01.0 reg 14 32bit mmio: [0, 7ff]
[    0.541434] PCI: 0000:05:08.0 reg 10 32bit mmio: [93000000, 93000fff]
[    0.541441] PCI: 0000:05:08.0 reg 14 io port: [1000, 103f]
[    0.541482] pci 0000:05:08.0: supports D1
[    0.541483] pci 0000:05:08.0: supports D2
[    0.541486] pci 0000:05:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.541490] pci 0000:05:08.0: PME# disabled
[    0.541524] pci 0000:00:1e.0: transparent bridge
[    0.541528] PCI: bridge 0000:00:1e.0 io port: [1000, 1fff]
[    0.541532] PCI: bridge 0000:00:1e.0 32bit mmio: [93000000, 930fffff]
[    0.541560] bus 00 -> node 0
[    0.541567] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.541966] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.542400] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.542546] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.542689] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.544256] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.544278] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 12) 
*0, disabled.
[    0.544410] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.544539] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[    0.544668] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 *11 12)
[    0.544796] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) 
*0, disabled.
[    0.548034] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
[    0.548165] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 *10 11 12)
[    0.548250] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.548250] pnp: PnP ACPI init
[    0.548250] ACPI: bus type pnp registered
[    0.552228] pnp: PnP ACPI: found 13 devices
[    0.552228] ACPI: ACPI bus type pnp unregistered
[    0.552228] PnPBIOS: Disabled by ACPI PNP
[    0.552228] PCI: Using ACPI for IRQ routing
[    0.560045] NET: Registered protocol family 8
[    0.560050] NET: Registered protocol family 20
[    0.560081] NetLabel: Initializing
[    0.560081] NetLabel:  domain hash size = 128
[    0.560081] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.560091] NetLabel:  unlabeled traffic allowed by default
[    0.560099] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.560108] hpet0: 3 64-bit timers, 14318180 Hz
[    0.562130] tracer: 772 pages allocated for 65536 entries of 48 bytes
[    0.562133]    actual entries 65620
[    0.562230] AppArmor: AppArmor Filesystem Enabled
[    0.562253] ACPI: RTC can wake from S4
[    0.564047] Switched to high resolution mode on CPU 0
[    0.564492] Switched to high resolution mode on CPU 1
[    0.568084] system 00:01: iomem range 0xf0000000-0xf7ffffff has been 
reserved
[    0.568089] system 00:01: iomem range 0xfed00000-0xfed00fff has been 
reserved
[    0.568095] system 00:01: iomem range 0xfed13000-0xfed13fff has been 
reserved
[    0.568100] system 00:01: iomem range 0xfed14000-0xfed17fff has been 
reserved
[    0.568105] system 00:01: iomem range 0xfed18000-0xfed18fff has been 
reserved
[    0.568110] system 00:01: iomem range 0xfed19000-0xfed19fff has been 
reserved
[    0.568115] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been 
reserved
[    0.568120] system 00:01: iomem range 0xfed20000-0xfed9ffff has been 
reserved
[    0.568125] system 00:01: iomem range 0xc0000-0xdffff could not be 
reserved
[    0.568130] system 00:01: iomem range 0xe0000-0xfffff could not be 
reserved
[    0.568148] system 00:06: ioport range 0x500-0x53f has been reserved
[    0.568153] system 00:06: ioport range 0x400-0x47f has been reserved
[    0.568157] system 00:06: ioport range 0x680-0x6ff has been reserved
[    0.603436] pci 0000:01:00.0: BAR 6: can't allocate mem resource 
[0x90000000-0x8fffffff]
[    0.603440] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.603443] pci 0000:00:01.0:   IO window: 0x2000-0x2fff
[    0.603448] pci 0000:00:01.0:   MEM window: 0x90000000-0x92ffffff
[    0.603452] pci 0000:00:01.0:   PREFETCH window: 
0x00000080000000-0x0000008fffffff
[    0.603458] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.603460] pci 0000:00:1c.0:   IO window: disabled
[    0.603465] pci 0000:00:1c.0:   MEM window: 0x93200000-0x932fffff
[    0.603470] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.603476] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:03
[    0.603478] pci 0000:00:1c.2:   IO window: disabled
[    0.603484] pci 0000:00:1c.2:   MEM window: 0x93300000-0x933fffff
[    0.603488] pci 0000:00:1c.2:   PREFETCH window: disabled
[    0.603494] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:04
[    0.603496] pci 0000:00:1c.3:   IO window: disabled
[    0.603502] pci 0000:00:1c.3:   MEM window: 0x93400000-0x934fffff
[    0.603506] pci 0000:00:1c.3:   PREFETCH window: disabled
[    0.603519] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.603522] pci 0000:00:1e.0:   IO window: 0x1000-0x1fff
[    0.603528] pci 0000:00:1e.0:   MEM window: 0x93000000-0x930fffff
[    0.603532] pci 0000:00:1e.0:   PREFETCH window: 
0x00000093500000-0x000000935fffff
[    0.603548] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.603553] pci 0000:00:01.0: setting latency timer to 64
[    0.603563] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.603567] pci 0000:00:1c.0: setting latency timer to 64
[    0.603576] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.603581] pci 0000:00:1c.2: setting latency timer to 64
[    0.603589] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.603594] pci 0000:00:1c.3: setting latency timer to 64
[    0.603601] pci 0000:00:1e.0: setting latency timer to 64
[    0.603605] bus: 00 index 0 io port: [0, ffff]
[    0.603607] bus: 00 index 1 mmio: [0, ffffffff]
[    0.603610] bus: 01 index 0 io port: [2000, 2fff]
[    0.603612] bus: 01 index 1 mmio: [90000000, 92ffffff]
[    0.603615] bus: 01 index 2 mmio: [80000000, 8fffffff]
[    0.603617] bus: 01 index 3 mmio: [0, 0]
[    0.603619] bus: 02 index 0 mmio: [0, 0]
[    0.603621] bus: 02 index 1 mmio: [93200000, 932fffff]
[    0.603623] bus: 02 index 2 mmio: [0, 0]
[    0.603625] bus: 02 index 3 mmio: [0, 0]
[    0.603627] bus: 03 index 0 mmio: [0, 0]
[    0.603630] bus: 03 index 1 mmio: [93300000, 933fffff]
[    0.603632] bus: 03 index 2 mmio: [0, 0]
[    0.603634] bus: 03 index 3 mmio: [0, 0]
[    0.603636] bus: 04 index 0 mmio: [0, 0]
[    0.603638] bus: 04 index 1 mmio: [93400000, 934fffff]
[    0.603640] bus: 04 index 2 mmio: [0, 0]
[    0.603642] bus: 04 index 3 mmio: [0, 0]
[    0.603645] bus: 05 index 0 io port: [1000, 1fff]
[    0.603647] bus: 05 index 1 mmio: [93000000, 930fffff]
[    0.603649] bus: 05 index 2 mmio: [93500000, 935fffff]
[    0.603651] bus: 05 index 3 io port: [0, ffff]
[    0.603654] bus: 05 index 4 mmio: [0, ffffffff]
[    0.603664] NET: Registered protocol family 2
[    0.616125] IP route cache hash table entries: 32768 (order: 5, 
131072 bytes)
[    0.616425] TCP established hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.616870] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.617179] TCP: Hash tables configured (established 131072 bind 65536)
[    0.617184] TCP reno registered
[    0.624194] NET: Registered protocol family 1
[    0.624358] checking if image is initramfs... it is
[    1.388465] Freeing initrd memory: 7988k freed
[    1.389753] audit: initializing netlink socket (disabled)
[    1.389778] type=2000 audit(1305873871.388:1): initialized
[    1.396323] highmem bounce pool size: 64 pages
[    1.396330] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.399073] VFS: Disk quotas dquot_6.5.1
[    1.399174] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.399297] msgmni has been set to 1743
[    1.399442] io scheduler noop registered
[    1.399445] io scheduler anticipatory registered
[    1.399448] io scheduler deadline registered
[    1.399462] io scheduler cfq registered (default)
[    1.399676] pci 0000:01:00.0: Boot video device
[    1.399689] pci 0000:05:08.0: Firmware left e100 interrupts enabled; 
disabling
[    1.399818] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    1.399859] pcieport-driver 0000:00:01.0: found MSI capability
[    1.399892] pci_express 0000:00:01.0:pcie00: allocate port service
[    1.399947] pci_express 0000:00:01.0:pcie03: allocate port service
[    1.400047] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.400082] pcieport-driver 0000:00:1c.0: found MSI capability
[    1.400118] pci_express 0000:00:1c.0:pcie00: allocate port service
[    1.400176] pci_express 0000:00:1c.0:pcie02: allocate port service
[    1.400221] pci_express 0000:00:1c.0:pcie03: allocate port service
[    1.400320] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    1.400355] pcieport-driver 0000:00:1c.2: found MSI capability
[    1.400391] pci_express 0000:00:1c.2:pcie00: allocate port service
[    1.400437] pci_express 0000:00:1c.2:pcie02: allocate port service
[    1.400482] pci_express 0000:00:1c.2:pcie03: allocate port service
[    1.400585] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    1.400620] pcieport-driver 0000:00:1c.3: found MSI capability
[    1.400655] pci_express 0000:00:1c.3:pcie00: allocate port service
[    1.400700] pci_express 0000:00:1c.3:pcie02: allocate port service
[    1.400746] pci_express 0000:00:1c.3:pcie03: allocate port service
[    1.401118] isapnp: Scanning for PnP cards...
[    1.754109] isapnp: No Plug & Play device found
[    1.793579] hpet_resources: 0xfed00000 is busy
[    1.793657] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.793798] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.794692] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.796876] brd: module loaded
[    1.796957] input: Macintosh mouse button emulation as 
/devices/virtual/input/input0
[    1.797188] PNP: No PS/2 controller found. Probing ports directly.
[    1.800113] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.800120] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.804211] mice: PS/2 mouse device common for all mice
[    1.804385] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.804409] rtc0: alarms up to one month, hpet irqs
[    1.804572] EISA: Probing bus 0 at eisa.0
[    1.804579] Cannot allocate resource for EISA slot 1
[    1.804582] Cannot allocate resource for EISA slot 2
[    1.804584] Cannot allocate resource for EISA slot 3
[    1.804602] EISA: Detected 0 cards.
[    1.804606] cpuidle: using governor ladder
[    1.804609] cpuidle: using governor menu
[    1.805178] TCP cubic registered
[    1.805210] Using IPI No-Shortcut mode
[    1.805432] registered taskstats version 1
[    1.805570]   Magic number: 11:813:721
[    1.805686] rtc_cmos 00:03: setting system clock to 2011-05-20 
06:44:32 UTC (1305873872)
[    1.805690] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.805692] EDD information not available.
[    1.805913] Freeing unused kernel memory: 424k freed
[    1.805955] Write protecting the kernel text: 2576k
[    1.805983] Write protecting the kernel read-only data: 936k
[    1.962099] fuse init (API version 7.9)
[    2.016342] processor ACPI0007:00: registered as cooling_device0
[    2.016347] ACPI: Processor [CPU0] (supports 8 throttling states)
[    2.016521] processor ACPI0007:01: registered as cooling_device1
[    2.016527] ACPI: Processor [CPU1] (supports 8 throttling states)
[    2.350836] usbcore: registered new interface driver usbfs
[    2.350864] usbcore: registered new interface driver hub
[    2.351154] usbcore: registered new device driver usb
[    2.363385] USB Universal Host Controller Interface driver v3.0
[    2.363441] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    2.363450] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.363455] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.363502] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 1
[    2.363538] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003080
[    2.363689] usb usb1: configuration #1 chosen from 1 choice
[    2.363724] hub 1-0:1.0: USB hub found
[    2.363732] hub 1-0:1.0: 2 ports detected
[    2.480951] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[    2.480955] e100: Copyright(c) 1999-2006 Intel Corporation
[    2.483004] No dock devices found.
[    2.498849] SCSI subsystem initialized
[    2.516813] libata version 3.00 loaded.
[    2.572305] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    2.572316] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.572320] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.572353] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 2
[    2.572393] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003060
[    2.572519] usb usb2: configuration #1 chosen from 1 choice
[    2.572554] hub 2-0:1.0: USB hub found
[    2.572562] hub 2-0:1.0: 2 ports detected
[    2.680279] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    2.680290] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.680294] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.680325] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 3
[    2.680360] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
[    2.680489] usb usb3: configuration #1 chosen from 1 choice
[    2.680521] hub 3-0:1.0: USB hub found
[    2.680527] usb 1-1: new low speed USB device using uhci_hcd and 
address 2
[    2.680531] hub 3-0:1.0: 2 ports detected
[    2.828301] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) 
-> IRQ 16
[    2.828313] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.828318] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.828353] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned 
bus number 4
[    2.828390] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00003020
[    2.828531] usb usb4: configuration #1 chosen from 1 choice
[    2.828565] hub 4-0:1.0: USB hub found
[    2.828575] hub 4-0:1.0: 2 ports detected
[    2.933299] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    2.933314] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.933318] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.933357] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 5
[    2.937271] ehci_hcd 0000:00:1d.7: debug port 1
[    2.937278] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.937289] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x93104400
[    2.948829] usb 1-1: configuration #1 chosen from 1 choice
[    2.952520] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 
10 Dec 2004
[    2.952667] usb usb5: configuration #1 chosen from 1 choice
[    2.952700] hub 5-0:1.0: USB hub found
[    2.952709] hub 5-0:1.0: 8 ports detected
[    2.952743] usb 1-1: can't set config #1, error -71
[    3.132079] usb 1-1: USB disconnect, address 2
[    3.160666] e100 0000:05:08.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.184245] e100 0000:05:08.0: PME# disabled
[    3.184559] e100: eth0: e100_probe: addr 0x93000000, irq 20, MAC addr 
00:19:d1:1f:64:66
[    3.189059] pata_acpi 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) 
-> IRQ 18
[    3.189094] pata_acpi 0000:00:1f.1: setting latency timer to 64
[    3.189108] pata_acpi 0000:00:1f.1: PCI INT A disabled
[    3.189126] pata_acpi 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    3.189145] pata_acpi 0000:00:1f.2: setting latency timer to 64
[    3.189155] pata_acpi 0000:00:1f.2: PCI INT B disabled
[    3.193490] ata_piix 0000:00:1f.1: version 2.12
[    3.193503] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) 
-> IRQ 18
[    3.193542] ata_piix 0000:00:1f.1: setting latency timer to 64
[    3.195019] scsi0 : ata_piix
[    3.195133] scsi1 : ata_piix
[    3.195862] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x30b0 
irq 14
[    3.195866] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x30b8 
irq 15
[    3.548334] ata1.00: HPA unlocked: 156299375 -> 156301488, native 
156301488
[    3.548340] ata1.00: ATA-6: ST380011A, 8.01, max UDMA/100
[    3.548343] ata1.00: 156301488 sectors, multi 16: LBA48
[    3.548365] ata1.01: ATAPI: HL-DT-ST DVDRAM GSA-H42L, SL01, max UDMA/66
[    3.564509] ata1.00: configured for UDMA/100
[    3.584321] ata1.01: configured for UDMA/66
[    3.584363] ata2: port disabled. ignoring.
[    3.584485] scsi 0:0:0:0: Direct-Access     ATA      ST380011A 
  8.01 PQ: 0 ANSI: 5
[    3.588928] scsi 0:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-H42L 
  SL01 PQ: 0 ANSI: 5
[    3.589057] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    3.589064] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    3.589119] ata_piix 0000:00:1f.2: setting latency timer to 64
[    3.589556] scsi2 : ata_piix
[    3.589872] scsi3 : ata_piix
[    3.590020] ata3: SATA max UDMA/133 cmd 0x30c8 ctl 0x30e4 bmdma 
0x30a0 irq 19
[    3.590023] ata4: SATA max UDMA/133 cmd 0x30c0 ctl 0x30e0 bmdma 
0x30a8 irq 19
[    3.632190] usb 1-1: new low speed USB device using uhci_hcd and 
address 3
[    3.787677] ata3.01: ATA-8: ST3160813AS, CC2H, max UDMA/133
[    3.787682] ata3.01: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.807588] usb 1-1: configuration #1 chosen from 1 choice
[    3.843664] ata3.01: configured for UDMA/133
[    4.004994] ata4.00: ATA-8: ST3500413AS, JC45, max UDMA/133
[    4.004999] ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.020487] ata4.00: configured for UDMA/133
[    4.020651] scsi 2:0:1:0: Direct-Access     ATA      ST3160813AS 
  CC2H PQ: 0 ANSI: 5
[    4.021277] scsi 3:0:0:0: Direct-Access     ATA      ST3500413AS 
  JC45 PQ: 0 ANSI: 5
[    4.033323] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    4.033366] scsi 0:0:1:0: Attached scsi generic sg1 type 5
[    4.033407] scsi 2:0:1:0: Attached scsi generic sg2 type 0
[    4.033450] scsi 3:0:0:0: Attached scsi generic sg3 type 0
[    4.059991] Driver 'sd' needs updating - please use bus_type methods
[    4.060030] usb 1-2: new low speed USB device using uhci_hcd and 
address 4
[    4.060119] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors 
(80026 MB)
[    4.060140] sd 0:0:0:0: [sda] Write Protect is off
[    4.060144] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.060177] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    4.060298] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors 
(80026 MB)
[    4.060317] sd 0:0:0:0: [sda] Write Protect is off
[    4.060320] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.060353] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    4.060358]  sda: sda1
[    4.063306] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.063410] sd 2:0:1:0: [sdb] 312581808 512-byte hardware sectors 
(160042 MB)
[    4.063430] sd 2:0:1:0: [sdb] Write Protect is off
[    4.063433] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    4.063466] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    4.063533] sd 2:0:1:0: [sdb] 312581808 512-byte hardware sectors 
(160042 MB)
[    4.063551] sd 2:0:1:0: [sdb] Write Protect is off
[    4.063554] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    4.063588] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    4.063593]  sdb:<4>Driver 'sr' needs updating - please use bus_type 
methods
[    4.071501] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw 
xa/form2 cdda tray
[    4.071507] Uniform CD-ROM driver Revision: 3.20
[    4.071643] sr 0:0:1:0: Attached scsi CD-ROM sr0
[    4.081609]  sdb1 sdb2 < sdb5 >
[    4.103834] sd 2:0:1:0: [sdb] Attached SCSI disk
[    4.103924] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors 
(500108 MB)
[    4.103945] sd 3:0:0:0: [sdc] Write Protect is off
[    4.103948] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.103984] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    4.104071] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors 
(500108 MB)
[    4.104091] sd 3:0:0:0: [sdc] Write Protect is off
[    4.104094] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.104131] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    4.104137]  sdc: sdc1 sdc2 sdc3 sdc4
[    4.116101] sd 3:0:0:0: [sdc] Attached SCSI disk
[    4.235765] usb 1-2: configuration #1 chosen from 1 choice
[    4.238872] usbcore: registered new interface driver hiddev
[    4.253041] input: Microsoft  Microsoft Basic Optical Mouse  as 
/devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1:1.0/input/input1
[    4.257224] input,hidraw0: USB HID v1.11 Mouse [Microsoft  Microsoft 
Basic Optical Mouse ] on usb-0000:00:1d.0-1
[    4.271969] input: Microsoft Wired Keyboard 400 as 
/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/input/input2
[    4.273706] input,hidraw1: USB HID v1.11 Keyboard [Microsoft Wired 
Keyboard 400] on usb-0000:00:1d.0-2
[    4.273740] usbcore: registered new interface driver usbhid
[    4.273745] usbhid: v2.6:USB HID core driver
[    5.211885] PM: Starting manual resume from disk
[    5.211890] PM: Resume from partition 8:21
[    5.211892] PM: Checking hibernation image.
[    5.212059] PM: Resume from disk failed.
[    5.277132] kjournald starting.  Commit interval 5 seconds
[    5.277142] EXT3-fs: mounted filesystem with ordered data mode.
[   10.511517] udevd version 124 started
[   10.823280] Linux agpgart interface v0.103
[   10.875599] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   11.048223] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   11.099861] input: Power Button (FF) as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[   11.120536] ACPI: Power Button (FF) [PWRF]
[   11.120639] input: Sleep Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input4
[   11.152538] ACPI: Sleep Button (CM) [SLPB]
[   11.248787] parport_pc 00:09: reported by Plug and Play ACPI
[   11.248818] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
[   11.649790] nvidia: module license 'NVIDIA' taints kernel.
[   11.973586] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
[   11.973596] nvidia 0000:01:00.0: setting latency timer to 64
[   11.973760] NVRM: loading NVIDIA UNIX x86 Kernel Module  185.18.14 
Wed May 27 02:23:13 PDT 2009
[   11.996361] intel_rng: Firmware space is locked read-only. If you 
can't or
[   11.996363] intel_rng: don't want to disable this in firmware setup, 
and if
[   11.996364] intel_rng: you are certain that your system has a functional
[   11.996365] intel_rng: RNG, try using the 'no_fwh_detect' option.
[   12.070623] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   12.097088] iTCO_vendor_support: vendor-support=0
[   12.108410] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[   12.190587] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, 
TCOBASE=0x0460)
[   12.190688] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   12.490097] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[   12.490131] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   13.454738] lp0: using parport0 (interrupt-driven).
[   13.486514] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   13.486518] All bugs added by David S. Miller <davem@redhat.com>
[   13.718400] Adding 3012148k swap on /dev/sdb5.  Priority:-1 extents:1 
across:3012148k
[   14.305399] EXT3 FS on sdb1, internal journal
[   15.484039] type=1505 audit(1305873886.156:2): 
operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" 
name2="default" pid=4203
[   15.666395] type=1505 audit(1305873886.336:3): 
operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" 
name2="default" pid=4208
[   15.666602] type=1505 audit(1305873886.336:4): 
operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=4208
[   15.818943] ip_tables: (C) 2000-2006 Netfilter Core Team
[   16.880201] ACPI: WMI: Mapper loaded
[   17.753243] warning: `avahi-daemon' uses 32-bit capabilities (legacy 
support in use)
[   17.981944] NET: Registered protocol family 10
[   17.982861] lo: Disabled Privacy Extensions
[   18.068257] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   18.068267] apm: disabled - APM is not SMP safe.
[   18.322990] ppdev: user-space parallel port driver
[   20.728138] Bluetooth: Core ver 2.13
[   20.728995] NET: Registered protocol family 31
[   20.729002] Bluetooth: HCI device and connection manager initialized
[   20.729008] Bluetooth: HCI socket layer initialized
[   20.758002] Bluetooth: L2CAP ver 2.11
[   20.758012] Bluetooth: L2CAP socket layer initialized
[   20.783698] Bluetooth: SCO (Voice Link) ver 0.6
[   20.783709] Bluetooth: SCO socket layer initialized
[   20.807775] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   20.807787] Bluetooth: BNEP filters: protocol multicast
[   20.839764] Bridge firewalling registered
[   20.840336] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
[   20.892286] Bluetooth: RFCOMM socket layer initialized
[   20.892308] Bluetooth: RFCOMM TTY layer initialized
[   20.892312] Bluetooth: RFCOMM ver 1.10
[   25.025285] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   25.028622] e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
[   25.031213] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   25.249416] NET: Registered protocol family 17
[   35.820509] eth0: no IPv6 routers present
[   50.307716] UDF-fs: No VRS found
[   50.327525] ISO 9660 Extensions: Microsoft Joliet Level 3
[   50.336325] ISO 9660 Extensions: RRIP_1991A
[   50.336349] init_special_inode: bogus i_mode (30555)
[   50.336354] isofs_fill_super: root inode is not a directory. 
Corrupted media?
[  138.851596] RPC: Registered udp transport module.
[  138.851603] RPC: Registered tcp transport module.
[  424.643611] edredaq_core:v2.0.2 : EDR Enhanced DAQ Class Driver
[  424.644691] edredaq_core: major number = 251
[  424.646899] PCI703 Interface Driver (C) 2004 - 2011 Eagle Technology 
(v1.1.8)
[  424.646940] pci703drv: Probing device: vendor = ea01, device = 52.
[  424.646952] pci703drv 0000:05:01.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[  424.646963] /usr/src/edrelib-2.6.7/drivers/edredaq/pci703/pci703.c - 
dev_alloc - pci703drv: BAR0 OK (f7504594)
[  424.667465] /usr/src/edrelib-2.6.7/drivers/edredaq/pci703/pci703.c - 
dev_hwinit - pci703drv: Added new device (serial number #1000000703, 
type #81).
[  424.667743] Allocated 2048 kb for A/D circular buffer.
[  424.688898] pci703drv: Allocated double buffer of 8192 bytes.
[  424.689041] device0: dev (251:0)
[  424.689053] edredaq_core: registered as edredaq0

iomem:
00000000-0008efff : System RAM
0008f000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000ccdff : Video ROM
000e0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-7ec09fff : System RAM
   00100000-00383299 : Kernel code
   0038329a-004a567f : Kernel data
   00515000-005c0a1f : Kernel bss
7ec0a000-7ed34fff : ACPI Non-volatile Storage
7ed35000-7fd74fff : System RAM
7fd75000-7fd7cfff : reserved
7fd7d000-7fe2cfff : System RAM
7fe2d000-7fe30fff : reserved
7fe31000-7fea9fff : System RAM
7feaa000-7fee8fff : ACPI Non-volatile Storage
7fee9000-7feecfff : System RAM
7feed000-7fefefff : ACPI Tables
7feff000-7fefffff : System RAM
7ff00000-7fffffff : reserved
80000000-8fffffff : PCI Bus 0000:01
   80000000-8fffffff : 0000:01:00.0
90000000-92ffffff : PCI Bus 0000:01
   90000000-91ffffff : 0000:01:00.0
   92000000-92ffffff : 0000:01:00.0
     92000000-92ffffff : nvidia
93000000-930fffff : PCI Bus 0000:05
   93000000-93000fff : 0000:05:08.0
     93000000-93000fff : e100
93100000-93103fff : 0000:00:1b.0
   93100000-93103fff : ICH HD audio
93104000-931043ff : 0000:00:1f.2
93104400-931047ff : 0000:00:1d.7
   93104400-931047ff : ehci_hcd
93200000-932fffff : PCI Bus 0000:02
93300000-933fffff : PCI Bus 0000:03
93400000-934fffff : PCI Bus 0000:04
93500000-935fffff : PCI Bus 0000:05
   93500000-935007ff : 0000:05:01.0
     93500000-935007ff : pci703drv
   93500800-93500fff : 0000:05:01.0
     93500800-93500fff : pci703drv
f0000000-f7ffffff : PCI MMCONFIG 0
   f0000000-f7ffffff : pnp 00:01
fed00000-fed00fff : pnp 00:01
   fed00000-fed003ff : HPET 0
fed13000-fed13fff : pnp 00:01
fed14000-fed17fff : pnp 00:01
fed18000-fed18fff : pnp 00:01
fed19000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:01
fed20000-fed9ffff : pnp 00:01
fee00000-fee00fff : Local APIC
fff80000-ffffffff : reserved

lspci:
00:00.0 Host bridge: Intel Corporation 82946GZ/PL/GL Memory Controller 
Hub (rev 02)
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, fast devsel, latency 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: intel-agp

00:01.0 PCI bridge: Intel Corporation 82946GZ/PL/GL PCI Express Root 
Port (rev 02)
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: 90000000-92ffffff
	Prefetchable memory behind bridge: 0000000080000000-000000008fffffff
	Capabilities: [88] Subsystem: Intel Corporation Device 5354
	Capabilities: [80] Power Management version 3
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 
Enable+
	Capabilities: [a0] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [140] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High 
Definition Audio Controller (rev 01)
	Subsystem: Intel Corporation Device a201
	Flags: bus master, fast devsel, latency 0, IRQ 22
	Memory at 93100000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 
Enable-
	Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 1 (rev 01)
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	Memory behind bridge: 93200000-932fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 
Enable+
	Capabilities: [90] Subsystem: Gammagraphx, Inc. Device 0000
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 3 (rev 01)
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Memory behind bridge: 93300000-933fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 
Enable+
	Capabilities: [90] Subsystem: Gammagraphx, Inc. Device 0000
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 4 (rev 01)
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	Memory behind bridge: 93400000-934fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 
Enable+
	Capabilities: [90] Subsystem: Gammagraphx, Inc. Device 0000
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #1 (rev 01)
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, medium devsel, latency 0, IRQ 23
	I/O ports at 3080 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #2 (rev 01)
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at 3060 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #3 (rev 01)
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 3040 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #4 (rev 01)
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at 3020 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
Controller (rev 01) (prog-if 20)
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at 93104400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1) (prog-if 01)
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: 93000000-930fffff
	Prefetchable memory behind bridge: 0000000093500000-00000000935fffff
	Capabilities: [50] Subsystem: Intel Corporation Device 5354

00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC 
Interface Bridge (rev 01)
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: iTCO_wdt, intel-rng

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE 
Controller (rev 01) (prog-if 8a [Master SecP PriP])
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 30b0 [size=16]
	Kernel driver in use: ata_piix
	Kernel modules: ata_piix

00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family) 
SATA IDE Controller (rev 01) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
	I/O ports at 30c8 [size=8]
	I/O ports at 30e4 [size=4]
	I/O ports at 30c0 [size=8]
	I/O ports at 30e0 [size=4]
	I/O ports at 30a0 [size=16]
	Memory at 93104000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [70] Power Management version 2
	Kernel driver in use: ata_piix
	Kernel modules: ata_piix

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller 
(rev 01)
	Subsystem: Intel Corporation Device 5354
	Flags: medium devsel, IRQ 11
	I/O ports at 3000 [size=32]
	Kernel modules: i2c-i801

01:00.0 VGA compatible controller: nVidia Corporation GeForce 8400 GS 
(rev a1)
	Subsystem: ASUSTeK Computer Inc. Device 8254
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at 92000000 (32-bit, non-prefetchable) [size=16M]
	Memory at 80000000 (64-bit, prefetchable) [size=256M]
	Memory at 90000000 (64-bit, non-prefetchable) [size=32M]
	I/O ports at 2000 [size=128]
	Capabilities: [60] Power Management version 2
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 
Enable-
	Capabilities: [78] Express Endpoint, MSI 00
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [128] Power Budgeting <?>
	Capabilities: [600] Vendor Specific Information <?>
	Kernel driver in use: nvidia
	Kernel modules: nvidia, nvidiafb

05:01.0 Class ff00: Eagle Technology PCI-703 Analog I/O Card (rev 5c)
	Flags: bus master, slow devsel, latency 32, IRQ 22
	Memory at 93500000 (type 3, prefetchable) [size=2K]
	Memory at 93500800 (type 3, prefetchable) [size=2K]
	Capabilities: [80] #00 [0600]
	Kernel driver in use: pci703drv
	Kernel modules: pci703drv

05:08.0 Ethernet controller: Intel Corporation PRO/100 VE Network 
Connection (rev 01)
	Subsystem: Intel Corporation Device 0001
	Flags: bus master, medium devsel, latency 32, IRQ 20
	Memory at 93000000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at 1000 [size=64]
	Capabilities: [dc] Power Management version 2
	Kernel driver in use: e100
	Kernel modules: e100


Output from 2.6.35:
dmesg:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-28-generic (buildd@rothera) (gcc 
version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #50-Ubuntu SMP Fri Mar 
18 19:00:26 UTC 2011 (Ubuntu 2.6.35-28.50-generic 2.6.35.11)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ec0a000 (usable)
[    0.000000]  BIOS-e820: 000000007ec0a000 - 000000007ed35000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ed35000 - 000000007fd75000 (usable)
[    0.000000]  BIOS-e820: 000000007fd75000 - 000000007fd7d000 (reserved)
[    0.000000]  BIOS-e820: 000000007fd7d000 - 000000007fe2d000 (usable)
[    0.000000]  BIOS-e820: 000000007fe2d000 - 000000007fe31000 (reserved)
[    0.000000]  BIOS-e820: 000000007fe31000 - 000000007feaa000 (usable)
[    0.000000]  BIOS-e820: 000000007feaa000 - 000000007fee9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fee9000 - 000000007feed000 (usable)
[    0.000000]  BIOS-e820: 000000007feed000 - 000000007feff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007feff000 - 000000007ff00000 (usable)
[    0.000000]  BIOS-e820: 000000007ff00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be 
enabled: non-PAE kernel!
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 
(usable)
[    0.000000] last_pfn = 0x7ff00 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07FF00000 mask FFFF00000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] e820 update range: 0000000000002000 - 0000000000010000 
(usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (reserved)
[    0.000000]  modified: 0000000000001000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000008f000 (usable)
[    0.000000]  modified: 000000000008f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007ec0a000 (usable)
[    0.000000]  modified: 000000007ec0a000 - 000000007ed35000 (ACPI NVS)
[    0.000000]  modified: 000000007ed35000 - 000000007fd75000 (usable)
[    0.000000]  modified: 000000007fd75000 - 000000007fd7d000 (reserved)
[    0.000000]  modified: 000000007fd7d000 - 000000007fe2d000 (usable)
[    0.000000]  modified: 000000007fe2d000 - 000000007fe31000 (reserved)
[    0.000000]  modified: 000000007fe31000 - 000000007feaa000 (usable)
[    0.000000]  modified: 000000007feaa000 - 000000007fee9000 (ACPI NVS)
[    0.000000]  modified: 000000007fee9000 - 000000007feed000 (usable)
[    0.000000]  modified: 000000007feed000 - 000000007feff000 (ACPI data)
[    0.000000]  modified: 000000007feff000 - 000000007ff00000 (usable)
[    0.000000]  modified: 000000007ff00000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 00c00000
[    0.000000] found SMP MP-table at [c00fe200] fe200
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 15000-1a000
[    0.000000] RAMDISK: 375ab000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 009a9000 - 013ed55f
[    0.000000] Move RAMDISK from 00000000375ab000 - 0000000037fef55e to 
009a9000 - 013ed55e
[    0.000000] ACPI: RSDP 000fe020 00014 (v00 INTEL )
[    0.000000] ACPI: RSDT 7fefd038 00050 (v01 INTEL  D946GZIS 00000057 
     01000013)
[    0.000000] ACPI: FACP 7fefc000 00074 (v01 INTEL  D946GZIS 00000057 
MSFT 01000013)
[    0.000000] ACPI: DSDT 7fef7000 044D7 (v01 INTEL  D946GZIS 00000057 
MSFT 01000013)
[    0.000000] ACPI: FACS 7feaa000 00040
[    0.000000] ACPI: APIC 7fef6000 00078 (v01 INTEL  D946GZIS 00000057 
MSFT 01000013)
[    0.000000] ACPI: WDDT 7fef5000 00040 (v01 INTEL  D946GZIS 00000057 
MSFT 01000013)
[    0.000000] ACPI: MCFG 7fef4000 0003C (v01 INTEL  D946GZIS 00000057 
MSFT 01000013)
[    0.000000] ACPI: ASF! 7fef3000 000A6 (v32 INTEL  D946GZIS 00000057 
MSFT 01000013)
[    0.000000] ACPI: HPET 7fef2000 00038 (v01 INTEL  D946GZIS 00000057 
MSFT 01000013)
[    0.000000] ACPI: SSDT 7fef1000 001BC (v01 INTEL     CpuPm 00000057 
MSFT 01000013)
[    0.000000] ACPI: SSDT 7fef0000 00175 (v01 INTEL   Cpu0Ist 00000057 
MSFT 01000013)
[    0.000000] ACPI: SSDT 7feef000 00175 (v01 INTEL   Cpu1Ist 00000057 
MSFT 01000013)
[    0.000000] ACPI: SSDT 7feee000 00175 (v01 INTEL   Cpu2Ist 00000057 
MSFT 01000013)
[    0.000000] ACPI: SSDT 7feed000 00175 (v01 INTEL   Cpu3Ist 00000057 
MSFT 01000013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1159MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0007ff00
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[8] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x00000002
[    0.000000]     0: 0x00000010 -> 0x0000008f
[    0.000000]     0: 0x00000100 -> 0x0007ec0a
[    0.000000]     0: 0x0007ed35 -> 0x0007fd75
[    0.000000]     0: 0x0007fd7d -> 0x0007fe2d
[    0.000000]     0: 0x0007fe31 -> 0x0007feaa
[    0.000000]     0: 0x0007fee9 -> 0x0007feed
[    0.000000]     0: 0x0007feff -> 0x0007ff00
[    0.000000] On node 0 totalpages: 523512
[    0.000000] free_area_init_node: node 0, pgdat c0801fc0, node_mem_map 
c13ef020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3936 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2319 pages used for memmap
[    0.000000]   HighMem zone: 293995 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [16000 - 167ff]
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 
0000000000010000
[    0.000000] PM: Registered nosave memory: 000000000008f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 
80000000:7ff80000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 
nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @c2400000 s36416 r0 d20928 
u1048576
[    0.000000] pcpu-alloc: s36416 r0 d20928 u1048576 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 519417
[    0.000000] Kernel command line: 
BOOT_IMAGE=/vmlinuz-2.6.35-28-generic 
root=UUID=585cffc2-80b8-487b-9ada-d6c794f4cbe8 ro quiet splash
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] early_res array is doubled to 128 at [16800 - 177ff]
[    0.000000] allocated 10480620 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't 
want memory cgroups
[    0.000000] Subtract (57 early reservations)
[    0.000000]   #1 [0000001000 - 0000002000]   EX TRAMPOLINE
[    0.000000]   #2 [0000100000 - 00009a4adc]   TEXT DATA BSS
[    0.000000]   #3 [00009a5000 - 00009a8125]             BRK
[    0.000000]   #4 [000009fc00 - 00000fe200]   BIOS reserved
[    0.000000]   #5 [00000fe200 - 00000fe210]    MP-table mpf
[    0.000000]   #6 [00000fe250 - 0000100000]   BIOS reserved
[    0.000000]   #7 [00000fe210 - 00000fe250]    MP-table mpc
[    0.000000]   #8 [0000010000 - 0000011000]      TRAMPOLINE
[    0.000000]   #9 [0000011000 - 0000015000]     ACPI WAKEUP
[    0.000000]   #10 [0000015000 - 0000016000]         PGTABLE
[    0.000000]   #11 [00009a9000 - 00013ee000]     NEW RAMDISK
[    0.000000]   #12 [00013ee000 - 00013ef000]         BOOTMEM
[    0.000000]   #13 [00013ef000 - 00023ef000]         BOOTMEM
[    0.000000]   #14 [00023ef000 - 00023ef004]         BOOTMEM
[    0.000000]   #15 [00023ef040 - 00023ef100]         BOOTMEM
[    0.000000]   #16 [00023ef100 - 00023ef154]         BOOTMEM
[    0.000000]   #17 [00023ef180 - 00023f2180]         BOOTMEM
[    0.000000]   #18 [00023f2180 - 00023f21f0]         BOOTMEM
[    0.000000]   #19 [00023f2200 - 00023f8200]         BOOTMEM
[    0.000000]   #20 [00023f8200 - 00023f8225]         BOOTMEM
[    0.000000]   #21 [00023f8240 - 00023f8267]         BOOTMEM
[    0.000000]   #22 [00023f8280 - 00023f8494]         BOOTMEM
[    0.000000]   #23 [00023f84c0 - 00023f8500]         BOOTMEM
[    0.000000]   #24 [00023f8500 - 00023f8540]         BOOTMEM
[    0.000000]   #25 [00023f8540 - 00023f8580]         BOOTMEM
[    0.000000]   #26 [00023f8580 - 00023f85c0]         BOOTMEM
[    0.000000]   #27 [00023f85c0 - 00023f8600]         BOOTMEM
[    0.000000]   #28 [00023f8600 - 00023f8640]         BOOTMEM
[    0.000000]   #29 [00023f8640 - 00023f8680]         BOOTMEM
[    0.000000]   #30 [00023f8680 - 00023f86c0]         BOOTMEM
[    0.000000]   #31 [00023f86c0 - 00023f8700]         BOOTMEM
[    0.000000]   #32 [00023f8700 - 00023f8740]         BOOTMEM
[    0.000000]   #33 [00023f8740 - 00023f8780]         BOOTMEM
[    0.000000]   #34 [00023f8780 - 00023f87c0]         BOOTMEM
[    0.000000]   #35 [00023f87c0 - 00023f8800]         BOOTMEM
[    0.000000]   #36 [00023f8800 - 00023f8840]         BOOTMEM
[    0.000000]   #37 [00023f8840 - 00023f8880]         BOOTMEM
[    0.000000]   #38 [00023f8880 - 00023f88c0]         BOOTMEM
[    0.000000]   #39 [00023f88c0 - 00023f88d0]         BOOTMEM
[    0.000000]   #40 [00023f8900 - 00023f8910]         BOOTMEM
[    0.000000]   #41 [00023f8940 - 00023f89a5]         BOOTMEM
[    0.000000]   #42 [00023f89c0 - 00023f8a25]         BOOTMEM
[    0.000000]   #43 [0002400000 - 000240e000]         BOOTMEM
[    0.000000]   #44 [0002500000 - 000250e000]         BOOTMEM
[    0.000000]   #45 [0002600000 - 000260e000]         BOOTMEM
[    0.000000]   #46 [0002700000 - 000270e000]         BOOTMEM
[    0.000000]   #47 [00023faa40 - 00023faa44]         BOOTMEM
[    0.000000]   #48 [00023faa80 - 00023faa84]         BOOTMEM
[    0.000000]   #49 [00023faac0 - 00023faad0]         BOOTMEM
[    0.000000]   #50 [00023fab00 - 00023fab10]         BOOTMEM
[    0.000000]   #51 [00023fab40 - 00023fabe0]         BOOTMEM
[    0.000000]   #52 [00023fac00 - 00023fac48]         BOOTMEM
[    0.000000]   #53 [00023fac80 - 00023fec80]         BOOTMEM
[    0.000000]   #54 [000240e000 - 000248e000]         BOOTMEM
[    0.000000]   #55 [000248e000 - 00024ce000]         BOOTMEM
[    0.000000]   #56 [000270e000 - 000310cbec]         BOOTMEM
[    0.000000] Initializing HighMem for node 0 (000377fe:0007ff00)
[    0.000000] Memory: 2046960k/2096128k available (4936k kernel code, 
47088k reserved, 2337k data, 688k init, 1185256k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc081b000 - 0xc08c7000   ( 688 kB)
[    0.000000]       .data : 0xc05d20ae - 0xc081a7a8   (2337 kB)
[    0.000000]       .text : 0xc0100000 - 0xc05d20ae   (4936 kB)
[    0.000000] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:2304 nr_irqs:712
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1798.346 MHz processor.
[    0.004006] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 3596.69 BogoMIPS (lpj=7193384)
[    0.004012] pid_max: default: 32768 minimum: 301
[    0.004037] Security Framework initialized
[    0.004056] AppArmor: AppArmor initialized
[    0.004058] Yama: becoming mindful.
[    0.004122] Mount-cache hash table entries: 512
[    0.004274] Initializing cgroup subsys ns
[    0.004279] Initializing cgroup subsys cpuacct
[    0.004285] Initializing cgroup subsys memory
[    0.004295] Initializing cgroup subsys devices
[    0.004298] Initializing cgroup subsys freezer
[    0.004300] Initializing cgroup subsys net_cls
[    0.004334] CPU: Physical Processor ID: 0
[    0.004336] CPU: Processor Core ID: 0
[    0.004339] mce: CPU supports 6 MCE banks
[    0.004349] CPU0: Thermal monitoring enabled (TM2)
[    0.004354] using mwait in idle threads.
[    0.004361] Performance Events: PEBS fmt0-, Core2 events, Intel PMU 
driver.
[    0.004368] PEBS disabled due to CPU errata.
[    0.004376] ... version:                2
[    0.004378] ... bit width:              40
[    0.004380] ... generic registers:      2
[    0.004382] ... value mask:             000000ffffffffff
[    0.004385] ... max period:             000000007fffffff
[    0.004387] ... fixed-purpose events:   3
[    0.004389] ... event mask:             0000000700000003
[    0.009995] ACPI: Core revision 20100428
[    0.018864] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.018870] ftrace: allocating 21762 entries in 43 pages
[    0.020064] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.020383] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.062203] CPU0: Genuine Intel(R) CPU            2160  @ 1.80GHz 
stepping 02
[    0.064000] Booting Node   0, Processors  #1
[    0.008000] Initializing CPU#1
[    0.152018] Brought up 2 CPUs
[    0.152022] Total of 2 processors activated (7193.09 BogoMIPS).
[    0.152495] devtmpfs: initialized
[    0.153152] regulator: core version 0.5
[    0.153178] Time:  6:59:36  Date: 05/20/11
[    0.153228] NET: Registered protocol family 16
[    0.153260] Trying to unpack rootfs image as initramfs...
[    0.153389] EISA bus registered
[    0.153400] ACPI: bus type pci registered
[    0.153491] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 
0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.153495] PCI: not using MMCONFIG
[    0.156489] PCI: Using configuration type 1 for base access
[    0.160280] bio: create slab <bio-0> at 0
[    0.161507] ACPI: EC: Look up EC in DSDT
[    0.165472] ACPI: Interpreter enabled
[    0.165481] ACPI: (supports S0 S3 S4 S5)
[    0.165508] ACPI: Using IOAPIC for interrupt routing
[    0.165554] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 
0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.165764] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in 
ACPI motherboard resources
[    0.165766] PCI: Using MMCONFIG for extended config space
[    0.172070] ACPI: No dock devices found.
[    0.172077] PCI: Ignoring host bridge windows from ACPI; if 
necessary, use "pci=use_crs" and report a bug
[    0.173385] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.175942] pci_root PNP0A03:00: host bridge window [io 
0x0000-0x0cf7] (ignored)
[    0.175946] pci_root PNP0A03:00: host bridge window [io 
0x0d00-0xffff] (ignored)
[    0.175950] pci_root PNP0A03:00: host bridge window [mem 
0x000a0000-0x000bffff] (ignored)
[    0.175953] pci_root PNP0A03:00: host bridge window [mem 
0x000e0000-0x000effff] (ignored)
[    0.175957] pci_root PNP0A03:00: host bridge window [mem 
0xf8000000-0xfeafffff] (ignored)
[    0.175960] pci_root PNP0A03:00: host bridge window [mem 
0x80000000-0xefffffff] (ignored)
[    0.176075] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.176079] pci 0000:00:01.0: PME# disabled
[    0.176145] pci 0000:00:1b.0: reg 10: [mem 0x93100000-0x93103fff 64bit]
[    0.176193] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.176198] pci 0000:00:1b.0: PME# disabled
[    0.176273] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.176278] pci 0000:00:1c.0: PME# disabled
[    0.176362] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.176366] pci 0000:00:1c.2: PME# disabled
[    0.176443] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.176448] pci 0000:00:1c.3: PME# disabled
[    0.176501] pci 0000:00:1d.0: reg 20: [io  0x3080-0x309f]
[    0.176554] pci 0000:00:1d.1: reg 20: [io  0x3060-0x307f]
[    0.176607] pci 0000:00:1d.2: reg 20: [io  0x3040-0x305f]
[    0.176660] pci 0000:00:1d.3: reg 20: [io  0x3020-0x303f]
[    0.176712] pci 0000:00:1d.7: reg 10: [mem 0x93104400-0x931047ff]
[    0.176771] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.176777] pci 0000:00:1d.7: PME# disabled
[    0.176905] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by 
ICH6 ACPI/GPIO/TCO
[    0.176910] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by 
ICH6 GPIO
[    0.176915] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 
0680 (mask 007f)
[    0.176962] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.176969] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.176977] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.176984] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.176992] pci 0000:00:1f.1: reg 20: [io  0x30b0-0x30bf]
[    0.177036] pci 0000:00:1f.2: reg 10: [io  0x30c8-0x30cf]
[    0.177043] pci 0000:00:1f.2: reg 14: [io  0x30e4-0x30e7]
[    0.177050] pci 0000:00:1f.2: reg 18: [io  0x30c0-0x30c7]
[    0.177057] pci 0000:00:1f.2: reg 1c: [io  0x30e0-0x30e3]
[    0.177063] pci 0000:00:1f.2: reg 20: [io  0x30a0-0x30af]
[    0.177070] pci 0000:00:1f.2: reg 24: [mem 0x93104000-0x931043ff]
[    0.177094] pci 0000:00:1f.2: PME# supported from D3hot
[    0.177098] pci 0000:00:1f.2: PME# disabled
[    0.177146] pci 0000:00:1f.3: reg 20: [io  0x3000-0x301f]
[    0.177234] pci 0000:01:00.0: reg 10: [mem 0x92000000-0x92ffffff]
[    0.177245] pci 0000:01:00.0: reg 14: [mem 0x80000000-0x8fffffff 
64bit pref]
[    0.177256] pci 0000:01:00.0: reg 1c: [mem 0x90000000-0x91ffffff 64bit]
[    0.177263] pci 0000:01:00.0: reg 24: [io  0x2000-0x207f]
[    0.177270] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.177323] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.177328] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.177332] pci 0000:00:01.0:   bridge window [mem 0x90000000-0x92ffffff]
[    0.177338] pci 0000:00:01.0:   bridge window [mem 
0x80000000-0x8fffffff 64bit pref]
[    0.177385] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.177390] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] 
(disabled)
[    0.177396] pci 0000:00:1c.0:   bridge window [mem 0x93200000-0x932fffff]
[    0.177403] pci 0000:00:1c.0:   bridge window [mem 
0xfff00000-0x000fffff pref] (disabled)
[    0.177450] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.177455] pci 0000:00:1c.2:   bridge window [io  0xf000-0x0000] 
(disabled)
[    0.177460] pci 0000:00:1c.2:   bridge window [mem 0x93300000-0x933fffff]
[    0.177467] pci 0000:00:1c.2:   bridge window [mem 
0xfff00000-0x000fffff pref] (disabled)
[    0.177514] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.177519] pci 0000:00:1c.3:   bridge window [io  0xf000-0x0000] 
(disabled)
[    0.177524] pci 0000:00:1c.3:   bridge window [mem 0x93400000-0x934fffff]
[    0.177531] pci 0000:00:1c.3:   bridge window [mem 
0xfff00000-0x000fffff pref] (disabled)
[    0.177681] pci 0000:05:08.0: reg 10: [mem 0x93000000-0x93000fff]
[    0.177689] pci 0000:05:08.0: reg 14: [io  0x1000-0x103f]
[    0.177736] pci 0000:05:08.0: supports D1 D2
[    0.177738] pci 0000:05:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.177743] pci 0000:05:08.0: PME# disabled
[    0.177785] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive 
decode)
[    0.177790] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    0.177795] pci 0000:00:1e.0:   bridge window [mem 0x93000000-0x930fffff]
[    0.177802] pci 0000:00:1e.0:   bridge window [mem 
0xfff00000-0x000fffff pref] (disabled)
[    0.177805] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] 
(subtractive decode)
[    0.177808] pci 0000:00:1e.0:   bridge window [mem 
0x00000000-0xffffffff] (subtractive decode)
[    0.177833] pci_bus 0000:00: on NUMA node 0
[    0.177839] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.178101] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.178396] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.178488] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.178575] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.184482] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.184610] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 12) 
*0, disabled.
[    0.184737] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.184861] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[    0.184984] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 *11 12)
[    0.185108] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) 
*0, disabled.
[    0.185232] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
[    0.185355] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 *10 11 12)
[    0.185415] HEST: Table is not found!
[    0.185533] vgaarb: device added: 
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.185538] vgaarb: loaded
[    0.185745] SCSI subsystem initialized
[    0.185846] libata version 3.00 loaded.
[    0.185920] usbcore: registered new interface driver usbfs
[    0.185936] usbcore: registered new interface driver hub
[    0.185969] usbcore: registered new device driver usb
[    0.186134] ACPI: WMI: Mapper loaded
[    0.186136] PCI: Using ACPI for IRQ routing
[    0.186141] PCI: pci_cache_line_size set to 64 bytes
[    0.186236] reserve RAM buffer: 0000000000002000 - 000000000000ffff
[    0.186240] reserve RAM buffer: 000000000008f000 - 000000000008ffff
[    0.186243] reserve RAM buffer: 000000007ec0a000 - 000000007fffffff
[    0.186248] reserve RAM buffer: 000000007fd75000 - 000000007fffffff
[    0.186253] reserve RAM buffer: 000000007fe2d000 - 000000007fffffff
[    0.186257] reserve RAM buffer: 000000007feaa000 - 000000007fffffff
[    0.186261] reserve RAM buffer: 000000007feed000 - 000000007fffffff
[    0.186264] reserve RAM buffer: 000000007ff00000 - 000000007fffffff
[    0.186389] NetLabel: Initializing
[    0.186392] NetLabel:  domain hash size = 128
[    0.186394] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.186410] NetLabel:  unlabeled traffic allowed by default
[    0.186454] HPET: 3 timers in total, 0 timers will be used for 
per-cpu timer
[    0.186460] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.186467] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.196042] Switching to clocksource tsc
[    0.209951] AppArmor: AppArmor Filesystem Enabled
[    0.209974] pnp: PnP ACPI init
[    0.209998] ACPI: bus type pnp registered
[    0.213814] pnp: PnP ACPI: found 13 devices
[    0.213817] ACPI: ACPI bus type pnp unregistered
[    0.213823] PnPBIOS: Disabled by ACPI PNP
[    0.213838] system 00:01: [mem 0xf0000000-0xf7ffffff] has been reserved
[    0.213842] system 00:01: [mem 0xfed00000-0xfed00fff] has been reserved
[    0.213845] system 00:01: [mem 0xfed13000-0xfed13fff] has been reserved
[    0.213849] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.213852] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.213856] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.213859] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.213863] system 00:01: [mem 0xfed20000-0xfed9ffff] has been reserved
[    0.213867] system 00:01: [mem 0x000c0000-0x000dffff] could not be 
reserved
[    0.213871] system 00:01: [mem 0x000e0000-0x000fffff] could not be 
reserved
[    0.213880] system 00:06: [io  0x0500-0x053f] has been reserved
[    0.213884] system 00:06: [io  0x0400-0x047f] has been reserved
[    0.213887] system 00:06: [io  0x0680-0x06ff] has been reserved
[    0.250322] pci 0000:01:00.0: no compatible bridge window for [mem 
0xfffe0000-0xffffffff pref]
[    0.250384] pci 0000:00:1c.0: BAR 15: assigned [mem 
0x93500000-0x936fffff 64bit pref]
[    0.250389] pci 0000:00:1c.2: BAR 15: assigned [mem 
0x93700000-0x938fffff 64bit pref]
[    0.250393] pci 0000:00:1c.3: BAR 15: assigned [mem 
0x93900000-0x93afffff 64bit pref]
[    0.250397] pci 0000:00:1e.0: BAR 15: assigned [mem 
0x93b00000-0x93bfffff 64bit pref]
[    0.250402] pci 0000:00:1c.0: BAR 13: assigned [io  0x4000-0x4fff]
[    0.250405] pci 0000:00:1c.2: BAR 13: assigned [io  0x5000-0x5fff]
[    0.250409] pci 0000:00:1c.3: BAR 13: assigned [io  0x6000-0x6fff]
[    0.250414] pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x20000)
[    0.250417] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.250421] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.250426] pci 0000:00:01.0:   bridge window [mem 0x90000000-0x92ffffff]
[    0.250430] pci 0000:00:01.0:   bridge window [mem 
0x80000000-0x8fffffff 64bit pref]
[    0.250436] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.250440] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.250446] pci 0000:00:1c.0:   bridge window [mem 0x93200000-0x932fffff]
[    0.250451] pci 0000:00:1c.0:   bridge window [mem 
0x93500000-0x936fffff 64bit pref]
[    0.250459] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.250463] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
[    0.250469] pci 0000:00:1c.2:   bridge window [mem 0x93300000-0x933fffff]
[    0.250474] pci 0000:00:1c.2:   bridge window [mem 
0x93700000-0x938fffff 64bit pref]
[    0.250481] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.250485] pci 0000:00:1c.3:   bridge window [io  0x6000-0x6fff]
[    0.250491] pci 0000:00:1c.3:   bridge window [mem 0x93400000-0x934fffff]
[    0.250496] pci 0000:00:1c.3:   bridge window [mem 
0x93900000-0x93afffff 64bit pref]
[    0.250504] pci 0000:05:01.0: BAR 0: assigned [mem 
0x93b00000-0x93b007ff 64bit pref]
[    0.250511] pci 0000:05:01.0: BAR 0: set to [mem 
0x93b00000-0x93b007ff 64bit pref] (PCI address [0x93b00000-0x93b007ff]
[    0.250514] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    0.250518] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    0.250524] pci 0000:00:1e.0:   bridge window [mem 0x93000000-0x930fffff]
[    0.250529] pci 0000:00:1e.0:   bridge window [mem 
0x93b00000-0x93bfffff 64bit pref]
[    0.250547]   alloc irq_desc for 16 on node -1
[    0.250550]   alloc kstat_irqs on node -1
[    0.250558] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.250564] pci 0000:00:01.0: setting latency timer to 64
[    0.250576]   alloc irq_desc for 17 on node -1
[    0.250578]   alloc kstat_irqs on node -1
[    0.250583] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.250588] pci 0000:00:1c.0: setting latency timer to 64
[    0.250598]   alloc irq_desc for 18 on node -1
[    0.250600]   alloc kstat_irqs on node -1
[    0.250604] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.250609] pci 0000:00:1c.2: setting latency timer to 64
[    0.250619]   alloc irq_desc for 19 on node -1
[    0.250621]   alloc kstat_irqs on node -1
[    0.250625] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.250630] pci 0000:00:1c.3: setting latency timer to 64
[    0.250638] pci 0000:00:1e.0: setting latency timer to 64
[    0.250644] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.250647] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.250650] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.250653] pci_bus 0000:01: resource 1 [mem 0x90000000-0x92ffffff]
[    0.250656] pci_bus 0000:01: resource 2 [mem 0x80000000-0x8fffffff 
64bit pref]
[    0.250659] pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
[    0.250662] pci_bus 0000:02: resource 1 [mem 0x93200000-0x932fffff]
[    0.250665] pci_bus 0000:02: resource 2 [mem 0x93500000-0x936fffff 
64bit pref]
[    0.250668] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    0.250671] pci_bus 0000:03: resource 1 [mem 0x93300000-0x933fffff]
[    0.250675] pci_bus 0000:03: resource 2 [mem 0x93700000-0x938fffff 
64bit pref]
[    0.250678] pci_bus 0000:04: resource 0 [io  0x6000-0x6fff]
[    0.250681] pci_bus 0000:04: resource 1 [mem 0x93400000-0x934fffff]
[    0.250684] pci_bus 0000:04: resource 2 [mem 0x93900000-0x93afffff 
64bit pref]
[    0.250687] pci_bus 0000:05: resource 0 [io  0x1000-0x1fff]
[    0.250690] pci_bus 0000:05: resource 1 [mem 0x93000000-0x930fffff]
[    0.250693] pci_bus 0000:05: resource 2 [mem 0x93b00000-0x93bfffff 
64bit pref]
[    0.250696] pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
[    0.250699] pci_bus 0000:05: resource 5 [mem 0x00000000-0xffffffff]
[    0.250761] NET: Registered protocol family 2
[    0.250852] IP route cache hash table entries: 32768 (order: 5, 
131072 bytes)
[    0.251155] TCP established hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.251772] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.252148] TCP: Hash tables configured (established 131072 bind 65536)
[    0.252152] TCP reno registered
[    0.252158] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.252179] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.252312] NET: Registered protocol family 1
[    0.252568] pci 0000:01:00.0: Boot video device
[    0.252587] pci 0000:05:08.0: Firmware left e100 interrupts enabled; 
disabling
[    0.252594] PCI: CLS 64 bytes, default 64
[    0.252831] cpufreq-nforce2: No nForce2 chipset.
[    0.252867] Scanning for low memory corruption every 60 seconds
[    0.253066] audit: initializing netlink socket (disabled)
[    0.253080] type=2000 audit(1305874776.248:1): initialized
[    0.265470] highmem bounce pool size: 64 pages
[    0.265478] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.267309] VFS: Disk quotas dquot_6.5.2
[    0.267396] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.268148] fuse init (API version 7.14)
[    0.268262] msgmni has been set to 1683
[    0.462443] Freeing initrd memory: 10516k freed
[    0.471014] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    0.471019] io scheduler noop registered
[    0.471022] io scheduler deadline registered
[    0.471040] io scheduler cfq registered (default)
[    0.471175] pcieport 0000:00:01.0: setting latency timer to 64
[    0.471208]   alloc irq_desc for 40 on node -1
[    0.471210]   alloc kstat_irqs on node -1
[    0.471222] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.471301] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.471336]   alloc irq_desc for 41 on node -1
[    0.471339]   alloc kstat_irqs on node -1
[    0.471347] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.471443] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.471478]   alloc irq_desc for 42 on node -1
[    0.471480]   alloc kstat_irqs on node -1
[    0.471488] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    0.471582] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.471617]   alloc irq_desc for 43 on node -1
[    0.471619]   alloc kstat_irqs on node -1
[    0.471626] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    0.471751] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.471857] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.471972] intel_idle: MWAIT substates: 0x20
[    0.471975] intel_idle: does not run on family 6 model 15
[    0.472085] input: Sleep Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    0.472098] ACPI: Sleep Button [SLPB]
[    0.472166] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.472171] ACPI: Power Button [PWRF]
[    0.472376] ACPI: acpi_idle registered with cpuidle
[    0.474345] ERST: Table is not found!
[    0.474372] isapnp: Scanning for PnP cards...
[    0.474545] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.474662] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.475154] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.476630] brd: module loaded
[    0.477296] loop: module loaded
[    0.477515] ata_piix 0000:00:1f.1: version 2.13
[    0.477531] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) 
-> IRQ 18
[    0.477573] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.477662] scsi0 : ata_piix
[    0.477763] scsi1 : ata_piix
[    0.478479] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x30b0 
irq 14
[    0.478483] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x30b8 
irq 15
[    0.478505] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    0.478511] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    0.478547] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.478604] scsi2 : ata_piix
[    0.478675] scsi3 : ata_piix
[    0.478877] ata3: SATA max UDMA/133 cmd 0x30c8 ctl 0x30e4 bmdma 
0x30a0 irq 19
[    0.478881] ata4: SATA max UDMA/133 cmd 0x30c0 ctl 0x30e0 bmdma 
0x30a8 irq 19
[    0.479291] Fixed MDIO Bus: probed
[    0.479335] PPP generic driver version 2.4.2
[    0.479389] tun: Universal TUN/TAP device driver, 1.6
[    0.479391] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.479496] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.479518]   alloc irq_desc for 23 on node -1
[    0.479521]   alloc kstat_irqs on node -1
[    0.479529] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    0.479547] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.479551] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.479592] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 1
[    0.479613] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    0.479625] ehci_hcd 0000:00:1d.7: debug port 1
[    0.483520] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    0.483539] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x93104400
[    0.487622] ata2: port disabled. ignoring.
[    0.495759] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.495904] hub 1-0:1.0: USB hub found
[    0.495911] hub 1-0:1.0: 8 ports detected
[    0.496008] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.496029] uhci_hcd: USB Universal Host Controller Interface driver
[    0.496062] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    0.496070] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.496074] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.496124] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    0.496150] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003080
[    0.496290] hub 2-0:1.0: USB hub found
[    0.496295] hub 2-0:1.0: 2 ports detected
[    0.496367] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    0.496374] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.496377] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.496420] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 3
[    0.496444] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003060
[    0.496582] hub 3-0:1.0: USB hub found
[    0.496588] hub 3-0:1.0: 2 ports detected
[    0.496657] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    0.496663] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.496667] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.496708] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 4
[    0.496744] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
[    0.496879] hub 4-0:1.0: USB hub found
[    0.496884] hub 4-0:1.0: 2 ports detected
[    0.496956] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) 
-> IRQ 16
[    0.496962] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    0.496966] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    0.497006] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned 
bus number 5
[    0.497040] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00003020
[    0.497186] hub 5-0:1.0: USB hub found
[    0.497191] hub 5-0:1.0: 2 ports detected
[    0.497348] PNP: No PS/2 controller found. Probing ports directly.
[    0.500416] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.500423] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.500559] mice: PS/2 mouse device common for all mice
[    0.500705] rtc_cmos 00:03: RTC can wake from S4
[    0.500753] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.500779] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    0.500914] device-mapper: uevent: version 1.0.3
[    0.501043] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) 
initialised: dm-devel@redhat.com
[    0.501117] device-mapper: multipath: version 1.1.1 loaded
[    0.501120] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.501265] EISA: Probing bus 0 at eisa.0
[    0.501272] Cannot allocate resource for EISA slot 1
[    0.501274] Cannot allocate resource for EISA slot 2
[    0.501277] Cannot allocate resource for EISA slot 3
[    0.501280] Cannot allocate resource for EISA slot 4
[    0.501283] Cannot allocate resource for EISA slot 5
[    0.501285] Cannot allocate resource for EISA slot 6
[    0.501294] EISA: Detected 0 cards.
[    0.501376] cpuidle: using governor ladder
[    0.501379] cpuidle: using governor menu
[    0.501767] TCP cubic registered
[    0.501925] NET: Registered protocol family 10
[    0.502392] lo: Disabled Privacy Extensions
[    0.502693] NET: Registered protocol family 17
[    0.503140] Using IPI No-Shortcut mode
[    0.503242] PM: Resume from disk failed.
[    0.503255] registered taskstats version 1
[    0.503520]   Magic number: 11:572:974
[    0.503598] rtc_cmos 00:03: setting system clock to 2011-05-20 
06:59:36 UTC (1305874776)
[    0.503601] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.503603] EDD information not available.
[    0.660191] ata4.00: ATA-8: ST3500413AS, JC45, max UDMA/133
[    0.660195] ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    0.676056] ata4.00: configured for UDMA/133
[    0.687361] ata3.01: ATA-8: ST3160813AS, CC2H, max UDMA/133
[    0.687365] ata3.01: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    0.743223] ata3.01: configured for UDMA/133
[    0.827544] isapnp: No Plug & Play device found
[    0.836037] ata1.00: HPA unlocked: 156299375 -> 156301488, native 
156301488
[    0.836042] ata1.00: ATA-6: ST380011A, 8.01, max UDMA/100
[    0.836045] ata1.00: 156301488 sectors, multi 16: LBA48
[    0.836088] ata1.01: ATAPI: HL-DT-ST DVDRAM GSA-H42L, SL01, max UDMA/66
[    0.852273] ata1.00: configured for UDMA/100
[    0.868198] ata1.01: configured for UDMA/66
[    0.870894] scsi 0:0:0:0: Direct-Access     ATA      ST380011A 
  8.01 PQ: 0 ANSI: 5
[    0.871060] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: 
(80.0 GB/74.5 GiB)
[    0.871093] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.871125] sd 0:0:0:0: [sda] Write Protect is off
[    0.871128] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.871157] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.875687] scsi 0:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-H42L 
  SL01 PQ: 0 ANSI: 5
[    0.881104] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw 
xa/form2 cdda tray
[    0.881109] Uniform CD-ROM driver Revision: 3.20
[    0.881262] sr 0:0:1:0: Attached scsi CD-ROM sr0
[    0.881340] sr 0:0:1:0: Attached scsi generic sg1 type 5
[    0.881472]  sda:
[    0.881492] scsi 2:0:1:0: Direct-Access     ATA      ST3160813AS 
  CC2H PQ: 0 ANSI: 5
[    0.881626] sd 2:0:1:0: [sdb] 312581808 512-byte logical blocks: (160 
GB/149 GiB)
[    0.881655] sd 2:0:1:0: Attached scsi generic sg2 type 0
[    0.881693] sd 2:0:1:0: [sdb] Write Protect is off
[    0.881696] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    0.881768] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.881799] scsi 3:0:0:0: Direct-Access     ATA      ST3500413AS 
  JC45 PQ: 0 ANSI: 5
[    0.881952] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    0.881973]  sdb:
[    0.882084] sd 3:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 
GB/465 GiB)
[    0.882178] sd 3:0:0:0: [sdc] Write Protect is off
[    0.882182] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    0.882219] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.882449]  sdc: sda1
[    0.884000] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.884616]  sdb1 sdb2 < sdc1 sdc2 sdc3 sdc4
[    0.897132] sd 3:0:0:0: [sdc] Attached SCSI disk
[    0.906623]  sdb5 >
[    0.907026] sd 2:0:1:0: [sdb] Attached SCSI disk
[    0.907053] Freeing unused kernel memory: 688k freed
[    0.907428] Write protecting the kernel text: 4940k
[    0.907481] Write protecting the kernel read-only data: 1976k
[    0.928914] udev[82]: starting version 163
[    1.087983] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.087987] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.088037]   alloc irq_desc for 20 on node -1
[    1.088040]   alloc kstat_irqs on node -1
[    1.088049] e100 0000:05:08.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.091592] usb 2-1: new low speed USB device using uhci_hcd and 
address 2
[    1.098512] FDC 0 is a post-1991 82077
[    1.112095] e100 0000:05:08.0: PME# disabled
[    1.113514] e100 0000:05:08.0: eth0: addr 0x93000000, irq 20, MAC 
addr 00:19:d1:1f:64:66
[    1.297373] usbcore: registered new interface driver hiddev
[    1.311777] input: Microsoft  Microsoft Basic Optical Mouse  as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input2
[    1.311919] generic-usb 0003:045E:0084.0001: input,hidraw0: USB HID 
v1.11 Mouse [Microsoft  Microsoft Basic Optical Mouse ] on 
usb-0000:00:1d.0-1/input0
[    1.311944] usbcore: registered new interface driver usbhid
[    1.311947] usbhid: USB HID core driver
[    1.352387] EXT4-fs (sdc4): mounted filesystem with ordered data 
mode. Opts: (null)
[    1.580483] usb 2-2: new low speed USB device using uhci_hcd and 
address 3
[    1.773745] input: Microsoft Wired Keyboard 400 as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input3
[    1.773840] generic-usb 0003:045E:0752.0002: input,hidraw1: USB HID 
v1.11 Keyboard [Microsoft Wired Keyboard 400] on usb-0000:00:1d.0-2/input0
[    8.875548] udev[331]: starting version 163
[    8.917796] Adding 7812092k swap on /dev/sdc2.  Priority:-1 extents:1 
across:7812092k
[    8.946842] lp: driver loaded but no devices found
[    8.994607] intel_rng: Firmware space is locked read-only. If you 
can't or
[    8.994611] intel_rng: don't want to disable this in firmware setup, 
and if
[    8.994614] intel_rng: you are certain that your system has a functional
[    8.994616] intel_rng: RNG, try using the 'no_fwh_detect' option.
[    9.015024] leds_ss4200: no LED devices found
[    9.041201] Linux agpgart interface v0.103
[    9.149809] edredaq_core:v2.0.2 : EDR Enhanced DAQ Class Driver
[    9.149832] edredaq_core: major number = 250
[    9.198435] PCI703 Interface Driver (C) 2004 - 2011 Eagle Technology 
(v1.1.8)
[    9.198463] pci703drv: Probing device: vendor = ea01, device = 52.
[    9.198478]   alloc irq_desc for 22 on node -1
[    9.198481]   alloc kstat_irqs on node -1
[    9.198491] pci703drv 0000:05:01.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[    9.198512] 
/data/projects/eagle/edrelib/edrelib-2.6.7/drivers/edredaq/pci703/pci703.c 
- dev_alloc - pci703drv: BAR0 OK ([mem 0x93b00000-0x93b007ff 64bit pref])
[    9.198565] 
/data/projects/eagle/edrelib/edrelib-2.6.7/drivers/edredaq/pci703/pci703.c 
- dev_alloc - pci703drv: Memory address for card detected at BAR1 (0xe)
[    9.198613] 
/data/projects/eagle/edrelib/edrelib-2.6.7/drivers/edredaq/pci703/pci703.c 
- dev_alloc - pci703drv: No memory address for card detected at BAR1 
([??? 0x00000000 flags 0x0])
[    9.198667] 
/data/projects/eagle/edrelib/edrelib-2.6.7/drivers/edredaq/pci703/pci703.c 
- dev_probe - pci703drv: Failed to setup device.
[    9.229999] parport_pc 00:09: reported by Plug and Play ACPI
[    9.230029] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
[    9.253610] [drm] Initialized drm 1.1.0 20060810
[    9.324234] lp0: using parport0 (interrupt-driven).
[    9.341789] ppdev: user-space parallel port driver
[    9.403549] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
[    9.403557] nouveau 0000:01:00.0: setting latency timer to 64
[    9.410563] type=1400 audit(1305874785.400:2): apparmor="STATUS" 
operation="profile_load" name="/sbin/dhclient3" pid=642 
comm="apparmor_parser"
[    9.410578] type=1400 audit(1305874785.400:3): apparmor="STATUS" 
operation="profile_replace" name="/sbin/dhclient3" pid=632 
comm="apparmor_parser"
[    9.411370] type=1400 audit(1305874785.400:4): apparmor="STATUS" 
operation="profile_load" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=642 
comm="apparmor_parser"
[    9.411394] type=1400 audit(1305874785.400:5): apparmor="STATUS" 
operation="profile_replace" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=632 
comm="apparmor_parser"
[    9.411805] type=1400 audit(1305874785.400:6): apparmor="STATUS" 
operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" 
pid=642 comm="apparmor_parser"
[    9.411844] type=1400 audit(1305874785.400:7): apparmor="STATUS" 
operation="profile_replace" 
name="/usr/lib/connman/scripts/dhclient-script" pid=632 
comm="apparmor_parser"
[    9.412953] EXT4-fs (sdc4): re-mounted. Opts: errors=remount-ro
[    9.430211] [drm] nouveau 0000:01:00.0: Detected an NV50 generation 
card (0x086200a2)
[    9.442549] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image 
from PRAMIN
[    9.496322] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    9.496328] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    9.496332] [drm] nouveau 0000:01:00.0: Bios version 60.86.4e.00
[    9.496336] [drm] nouveau 0000:01:00.0: TMDS table revision 2.0 not 
currently supported
[    9.496339] [drm] nouveau 0000:01:00.0: BIT table 'd' not found
[    9.496343] [drm] nouveau 0000:01:00.0: Found Display Configuration 
Block version 4.0
[    9.496346] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 02000300 
00000028
[    9.496350] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 01011310 
00000028
[    9.496353] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 01011312 
00000010
[    9.496356] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 010223f1 
00c0c080
[    9.496361] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 
0x40 5 14 2
[    9.496364] [drm] nouveau 0000:01:00.0:   0: 0x00000000: type 0x00 
idx 0 tag 0xff
[    9.496368] [drm] nouveau 0000:01:00.0:   1: 0x00001130: type 0x30 
idx 1 tag 0x07
[    9.496371] [drm] nouveau 0000:01:00.0:   2: 0x00000210: type 0x10 
idx 2 tag 0xff
[    9.496375] [drm] nouveau 0000:01:00.0:   3: 0x00000211: type 0x11 
idx 3 tag 0xff
[    9.496378] [drm] nouveau 0000:01:00.0:   4: 0x00000213: type 0x13 
idx 4 tag 0xff
[    9.496387] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at 
offset 0xC241
[    9.540653] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at 
offset 0xC58D
[    9.576569] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at 
offset 0xD1CE
[    9.576581] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at 
offset 0xD2C0
[    9.584684] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at 
offset 0xD4BA
[    9.584689] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at 
offset 0xD51F
[    9.607432] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[    9.607587]   alloc irq_desc for 44 on node -1
[    9.607591]   alloc kstat_irqs on node -1
[    9.607605] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[    9.607666] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    9.608528] [drm] nouveau 0000:01:00.0: 0xD51F: Condition still not 
met after 20ms, skipping following opcodes
[    9.608540] [drm] nouveau 0000:01:00.0: 0xB414: parsing output script 0
[    9.608544] [drm] nouveau 0000:01:00.0: 0xAA84: parsing output script 0
[    9.608552] [drm] nouveau 0000:01:00.0: Detected 256MiB VRAM
[    9.693937] [TTM] Zone  kernel: Available graphics memory: 436454 kiB.
[    9.693941] [TTM] Zone highmem: Available graphics memory: 1029082 kiB.
[    9.693944] [TTM] Initializing pool allocator.
[    9.727997] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[    9.735117] [drm] nouveau 0000:01:00.0: Allocating FIFO number 1
[    9.741642] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: 
initialised FIFO 1
[    9.742580] [drm] nouveau 0000:01:00.0: Detected a DAC output
[    9.742583] [drm] nouveau 0000:01:00.0: Detected a DAC output
[    9.742587] [drm] nouveau 0000:01:00.0: Detected a TMDS output
[    9.742590] [drm] nouveau 0000:01:00.0: DCB encoder 1 unknown
[    9.742593] [drm] nouveau 0000:01:00.0: Detected a VGA connector
[    9.742751] [drm] nouveau 0000:01:00.0: Detected a DVI-I connector
[    9.742791] [drm] nouveau 0000:01:00.0: Detected a TV connector
[    9.742795] [drm] nouveau 0000:01:00.0:   no encoders, ignoring
[    9.876182] input: HDA Intel Mic at Ext Front Jack as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input4
[    9.876285] input: HDA Intel Speaker at Ext Rear Jack as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[    9.876358] input: HDA Intel Speaker at Ext Rear Jack as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    9.876435] input: HDA Intel Speaker at Ext Rear Jack as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    9.876508] input: HDA Intel HP Out at Ext Front Jack as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    9.927334] [drm] nouveau 0000:01:00.0: allocated 1920x1080 fb: 
0x40250000, bo f53e5e00
[    9.929433] [drm] nouveau 0000:01:00.0: 0xB418: parsing output script 1
[    9.929459] [drm] nouveau 0000:01:00.0: 0x859F: parsing clock script 0
[    9.931582] Console: switching to colour frame buffer device 240x67
[    9.934278] fb0: nouveaufb frame buffer device
[    9.934282] drm: registered panic notifier
[    9.934287] Slow work thread pool: Starting up
[    9.934429] Slow work thread pool: Ready
[    9.934440] [drm] Initialized nouveau 0.0.16 20090420 for 
0000:01:00.0 on minor 0
[   10.264358] EXT4-fs (sdc3): mounted filesystem with ordered data 
mode. Opts: (null)
[   10.579429] RPC: Registered udp transport module.
[   10.579434] RPC: Registered tcp transport module.
[   10.579437] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   10.604319] type=1400 audit(1305874786.596:8): apparmor="STATUS" 
operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=934 
comm="apparmor_parser"
[   10.605321] type=1400 audit(1305874786.596:9): apparmor="STATUS" 
operation="profile_load" name="/usr/sbin/cupsd" pid=934 
comm="apparmor_parser"
[   10.649124] FS-Cache: Loaded
[   10.729247] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   10.732151] e100 0000:05:08.0: eth0: NIC Link is Up 100 Mbps Full Duplex
[   10.740469] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   10.746809] FS-Cache: Netfs 'nfs' registered for caching
[   10.765633] type=1400 audit(1305874786.756:10): apparmor="STATUS" 
operation="profile_replace" name="/sbin/dhclient3" pid=1039 
comm="apparmor_parser"
[   10.766450] type=1400 audit(1305874786.756:11): apparmor="STATUS" 
operation="profile_replace" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1039 
comm="apparmor_parser"
[   10.822587] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   11.196606] svc: failed to register lockdv1 RPC service (errno 97).
[   11.197595] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state 
recovery directory
[   11.246425] NFSD: starting 90-second grace period
[   11.332421] [drm] nouveau 0000:01:00.0: Allocating FIFO number 2
[   11.338630] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: 
initialised FIFO 2
[   12.876297] EXT4-fs (sdc4): re-mounted. Opts: errors=remount-ro,commit=0
[   13.024817] EXT4-fs (sdc3): re-mounted. Opts: commit=0
[   14.228987] EXT4-fs (sdc4): re-mounted. Opts: errors=remount-ro,commit=0
[   14.237131] EXT4-fs (sdc3): re-mounted. Opts: commit=0
[   20.800074] eth0: no IPv6 routers present
[   29.670291] ISO 9660 Extensions: Microsoft Joliet Level 3
[   29.705371] ISO 9660 Extensions: RRIP_1991A
[   29.705385] init_special_inode: bogus i_mode (30555) for inode sr0:1856
[   29.705389] isofs_fill_super: root inode is not a directory. 
Corrupted media?

iomem:
00000000-00000fff : reserved
00001000-00001fff : System RAM
00002000-0000ffff : reserved
00010000-0008efff : System RAM
0008f000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000ccdff : Video ROM
000e0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-7ec09fff : System RAM
   00100000-005d20ad : Kernel code
   005d20ae-0081a7a7 : Kernel data
   008cd000-009a4adb : Kernel bss
7ec0a000-7ed34fff : ACPI Non-volatile Storage
7ed35000-7fd74fff : System RAM
7fd75000-7fd7cfff : reserved
7fd7d000-7fe2cfff : System RAM
7fe2d000-7fe30fff : reserved
7fe31000-7fea9fff : System RAM
7feaa000-7fee8fff : ACPI Non-volatile Storage
7fee9000-7feecfff : System RAM
7feed000-7fefefff : ACPI Tables
7feff000-7fefffff : System RAM
7ff00000-7fffffff : reserved
80000000-8fffffff : PCI Bus 0000:01
   80000000-8fffffff : 0000:01:00.0
90000000-92ffffff : PCI Bus 0000:01
   90000000-91ffffff : 0000:01:00.0
   92000000-92ffffff : 0000:01:00.0
93000000-930fffff : PCI Bus 0000:05
   93000000-93000fff : 0000:05:08.0
     93000000-93000fff : e100
93100000-93103fff : 0000:00:1b.0
   93100000-93103fff : ICH HD audio
93104000-931043ff : 0000:00:1f.2
93104400-931047ff : 0000:00:1d.7
   93104400-931047ff : ehci_hcd
93200000-932fffff : PCI Bus 0000:02
93300000-933fffff : PCI Bus 0000:03
93400000-934fffff : PCI Bus 0000:04
93500000-936fffff : PCI Bus 0000:02
93700000-938fffff : PCI Bus 0000:03
93900000-93afffff : PCI Bus 0000:04
93b00000-93bfffff : PCI Bus 0000:05
   93b00000-93b007ff : 0000:05:01.0
f0000000-f7ffffff : PCI MMCONFIG 0000 [bus 00-7f]
   f0000000-f7ffffff : pnp 00:01
fec00000-fec003ff : IOAPIC 0
fed00000-fed00fff : pnp 00:01
   fed00000-fed003ff : HPET 0
fed13000-fed13fff : pnp 00:01
fed14000-fed17fff : pnp 00:01
fed18000-fed18fff : pnp 00:01
fed19000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:01
fed20000-fed9ffff : pnp 00:01
fee00000-fee00fff : Local APIC
fff80000-ffffffff : reserved

lspci:
00:00.0 Host bridge: Intel Corporation 82946GZ/PL/GL Memory Controller 
Hub (rev 02)
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, fast devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=09 <?>
	Kernel modules: intel-agp

00:01.0 PCI bridge: Intel Corporation 82946GZ/PL/GL PCI Express Root 
Port (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: 90000000-92ffffff
	Prefetchable memory behind bridge: 0000000080000000-000000008fffffff
	Capabilities: [88] Subsystem: Intel Corporation Device 5354
	Capabilities: [80] Power Management version 3
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [a0] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel
	Capabilities: [140] Root Complex Link
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition 
Audio Controller (rev 01)
	Subsystem: Intel Corporation Device a201
	Flags: bus master, fast devsel, latency 0, IRQ 44
	Memory at 93100000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Virtual Channel
	Capabilities: [130] Root Complex Link
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 
1 (rev 01) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: 93200000-932fffff
	Prefetchable memory behind bridge: 0000000093500000-00000000936fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.2 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 
3 (rev 01) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00005000-00005fff
	Memory behind bridge: 93300000-933fffff
	Prefetchable memory behind bridge: 0000000093700000-00000000938fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 
4 (rev 01) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 00006000-00006fff
	Memory behind bridge: 93400000-934fffff
	Prefetchable memory behind bridge: 0000000093900000-0000000093afffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI 
Controller #1 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, medium devsel, latency 0, IRQ 23
	I/O ports at 3080 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI 
Controller #2 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at 3060 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI 
Controller #3 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 3040 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.3 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI 
Controller #4 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at 3020 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation N10/ICH 7 Family USB2 EHCI 
Controller (rev 01) (prog-if 20 [EHCI])
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at 93104400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1) (prog-if 
01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: 93000000-930fffff
	Prefetchable memory behind bridge: 0000000093b00000-0000000093bfffff
	Capabilities: [50] Subsystem: Intel Corporation Device 5354

00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC 
Interface Bridge (rev 01)
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel modules: leds-ss4200, iTCO_wdt, intel-rng

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE 
Controller (rev 01) (prog-if 8a [Master SecP PriP])
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 30b0 [size=16]
	Kernel driver in use: ata_piix

00:1f.2 IDE interface: Intel Corporation N10/ICH7 Family SATA IDE 
Controller (rev 01) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Intel Corporation Device 5354
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
	I/O ports at 30c8 [size=8]
	I/O ports at 30e4 [size=4]
	I/O ports at 30c0 [size=8]
	I/O ports at 30e0 [size=4]
	I/O ports at 30a0 [size=16]
	Memory at 93104000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [70] Power Management version 2
	Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation N10/ICH 7 Family SMBus Controller (rev 01)
	Subsystem: Intel Corporation Device 5354
	Flags: medium devsel, IRQ 11
	I/O ports at 3000 [size=32]
	Kernel modules: i2c-i801

01:00.0 VGA compatible controller: nVidia Corporation G86 [GeForce 8400 
GS] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device 8254
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at 92000000 (32-bit, non-prefetchable) [size=16M]
	Memory at 80000000 (64-bit, prefetchable) [size=256M]
	Memory at 90000000 (64-bit, non-prefetchable) [size=32M]
	I/O ports at 2000 [size=128]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [60] Power Management version 2
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [78] Express Endpoint, MSI 00
	Capabilities: [100] Virtual Channel
	Capabilities: [128] Power Budgeting <?>
	Capabilities: [600] Vendor Specific Information: ID=0001 Rev=1 Len=024 <?>
	Kernel driver in use: nouveau
	Kernel modules: nouveau, nvidiafb

05:01.0 Unassigned class [ff00]: Eagle Technology PCI-703 Analog I/O 
Card (rev 5c)
	Flags: bus master, slow devsel, latency 32, IRQ 22
	Memory at 93b00000 (type 3, prefetchable) [size=2K]
	Memory at <unassigned> (type 3, prefetchable)
	Capabilities: [80] #00 [0600]
	Kernel modules: pci703drv

05:08.0 Ethernet controller: Intel Corporation PRO/100 VE Network 
Connection (rev 01)
	Subsystem: Intel Corporation Device 0001
	Flags: bus master, medium devsel, latency 32, IRQ 20
	Memory at 93000000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at 1000 [size=64]
	Capabilities: [dc] Power Management version 2
	Kernel driver in use: e100
	Kernel modules: e100

Let know if you have any ideas about this issue.

Thanks
Jan








