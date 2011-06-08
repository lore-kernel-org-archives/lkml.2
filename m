Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab1FHG02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 02:26:28 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:28552 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab1FHG0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 02:26:25 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5k/BuK6UoSI=
X-RZG-CLASS-ID: mo00
Message-ID: <4DEF1606.5030803@hartkopp.net>
Date: Wed, 08 Jun 2011 08:26:14 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Chris Ball <cjb@laptop.org>,
        "S\, Venkatraman" <svenkatr@ti.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: sdhci-pci fails on 3.0.0-rc1 on Dell E6510
References: <4DEBCA3F.8050205@hartkopp.net>	<BANLkTin_WHuy5MExNBHdeLiDmdmn7SZYkg@mail.gmail.com>	<4DED05C4.7050903@hartkopp.net> <m3hb82wx6m.fsf@pullcord.laptop.org> <4DEE6FC6.9040308@hartkopp.net> <4DEE84AD.6050104@hartkopp.net> <4DEEA3CD.30507@kernel.org>
In-Reply-To: <4DEEA3CD.30507@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------040302050002040906070604"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040302050002040906070604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 08.06.2011 00:18, Yinghai Lu wrote:
> thanks.
> 
> second report.
> 
> can you send out whole boot log.

See attached dmesg output. The 'dirty' is due to the revert test of the sd/mmc
stuff (see below) - the rest is plain 3.0.0-rc2.

Good luck :-)

Oliver

> 
> On 06/07/2011 01:06 PM, Oliver Hartkopp wrote:
>> On 07.06.2011 20:36, Oliver Hartkopp wrote:
>> Hi all,
>>
>> the commit "PCI: update bridge resources to get more big ranges when allocating space (again)"
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=da7822e5ad71ec9b745b412639f1e5e0ba795a20
>>
>> kills my SD-Card and the PCMCIA slot on a Dell E6510 with the latest 3.0.0-rc2 ...
>>
>> When i revert the commit both the MMC/SD stuff and the PCMCIA re-appears.
>>
>> Any idea?
>>
>> See my attached boot.diff / kernel config 
>>
>> Regards,
>> Oliver
>>
>>
>>
>>
>>> On 06.06.2011 21:56, Chris Ball wrote:
>>>> Hi Oliver,
>>>>
>>>> On Mon, Jun 06 2011, Oliver Hartkopp wrote:
>>>>>>> dmesg is a bit more detailed:
>>>>>>> [    6.242510] sdhci-pci 0000:03:00.1: SDHCI controller found [1180:e822] (rev 3)
>>>>>>> [    6.244168] sdhci-pci 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
>>>>>>> [    6.245788] sdhci-pci 0000:03:00.1: BAR 0 is not iomem. Aborting.
>>>>>>> [    6.247609] sdhci-pci 0000:03:00.1: PCI INT B disabled
>>>>
>>>> If you get a chance to do some bisecting, that would be extremely
>>>> helpful -- even just building 3.0 from *before* the MMC tree was
>>>> merged would help a lot, since if the problem still happens before
>>>> the MMC merge we might be looking at some kind of generic PCI bug.
>>>>
>>>
>>>
>>> Hi Chris,
>>>
>>> i just reverted this pull of your merge window patches in my 3.0.0-rc2 tree:
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8c1c77ff9be27137fa7cbbf51efedef1a2ae915b;hp=f3ae1c75203535f65448517e46c8dd70a56b6c71
>>>
>>> And you were right: The problem still exists. So it might be from the PCI subsystem :-(
>>>
>>> [    6.167106] sdhci: Secure Digital Host Controller Interface driver
>>> [    6.167108] sdhci: Copyright(c) Pierre Ossman
>>> [    6.194731] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
>>> [    6.195140] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf6970000
>>> [    6.196423] sdhci-pci 0000:03:00.1: SDHCI controller found [1180:e822] (rev 3)
>>> [    6.196429] sdhci-pci 0000:03:00.1: found 1 slot(s)
>>> [    6.196447] sdhci-pci 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
>>> [    6.196451] sdhci-pci 0000:03:00.1: BAR 0 is not iomem. Aborting.
>>> [    6.196459] sdhci-pci 0000:03:00.1: PCI INT B disabled
>>>
>>> Well then, i'll reset my tree and look for differences in the PCI boot messages.
>>>
>>> Thanks,
>>> Oliver
>>
> 


--------------040302050002040906070604
Content-Type: text/plain;
 name="pci-3.0.0-rc2-dirty"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pci-3.0.0-rc2-dirty"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0-rc2-dirty (hartko@vwagwolkf484) (gcc version 4.6.1 20110526 (prerelease) (Debian 4.6.0-10) ) #46 SMP Tue Jun 7 20:06:39 CEST 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000093c00 (usable)
[    0.000000]  BIOS-e820: 0000000000093c00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000db65f000 (usable)
[    0.000000]  BIOS-e820: 00000000db65f000 - 00000000db67f000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000db67f000 - 00000000db76f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000db76f000 - 00000000dc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ddc00000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001fc000000 (usable)
[    0.000000]  BIOS-e820: 00000001fc000000 - 0000000200000000 (reserved)
[    0.000000]  BIOS-e820: 0000000200000000 - 000000021c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Dell Inc. Latitude E6510/02K3Y4, BIOS A06 11/20/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x21c000 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   4 base 100000000 mask F00000000 write-back
[    0.000000]   5 base 200000000 mask FE0000000 write-back
[    0.000000]   6 base 21C000000 mask FFC000000 uncachable
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000dc000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] initial memory mapped : 0 - 02000000
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-0000000037bfe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037a00000 page 2M
[    0.000000]  0037a00000 - 0037bfe000 page 4k
[    0.000000] kernel direct mapping tables up to 37bfe000 @ 1ffb000-2000000
[    0.000000] ACPI: RSDP 000fe300 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT db67de18 0006C (v01 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI: FACP db74fc18 000F4 (v04 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20110413/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xDB76BF40/0x00000000DB76ED40, using 32 (20110413/tbfadt-489)
[    0.000000] ACPI: DSDT db72e018 0A6C0 (v01 DELL    E2      00001001 INTL 20080729)
[    0.000000] ACPI: FACS db76bf40 00040
[    0.000000] ACPI: APIC db67cf18 0008C (v02 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI: TCPA db76dd18 00032 (v02                 00000000      00000000)
[    0.000000] ACPI: MCFG db76dc98 0003C (v01 A M I  GMCH945. 06222004 MSFT 00000097)
[    0.000000] ACPI: HPET db76dc18 00038 (v01 DELL    E2      00000001 ASL  00000061)
[    0.000000] ACPI: BOOT db76db98 00028 (v01 DELL   E2       06222004 AMI  00010013)
[    0.000000] ACPI: SLIC db766818 00176 (v03 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI: SSDT db73d018 009F1 (v01  PmRef    CpuPm 00003000 INTL 20080729)
[    0.000000] ACPI: DMAR db76eb18 000B8 (v01 INTEL  CP_DALE  00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 7748MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00037bfe
[    0.000000]   HighMem  0x00037bfe -> 0x0021c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000093
[    0.000000]     0: 0x00000100 -> 0x000db65f
[    0.000000]     0: 0x00100000 -> 0x001fc000
[    0.000000]     0: 0x00200000 -> 0x0021c000
[    0.000000] On node 0 totalpages: 2045410
[    0.000000] free_area_init_node: node 0, pgdat c15ed780, node_mem_map f387d200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3939 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 222502 pages, LIFO batch:31
[    0.000000]   HighMem zone: 15497 pages used for memmap
[    0.000000]   HighMem zone: 1801688 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] 8 Processors exceeds NR_CPUS limit of 4
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:18000000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f3600000 s24896 r0 d24256 u524288
[    0.000000] pcpu-alloc: s24896 r0 d24256 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2028129
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.0.0-rc2-dirty root=/dev/sda3 ro
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00037bfe:0021c000)
[    0.000000] Memory: 8099508k/8847360k available (4126k kernel code, 82132k reserved, 1966k data, 392k init, 7268740k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff67000 - 0xfffff000   ( 608 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc15f4000 - 0xc1656000   ( 392 kB)
[    0.000000]       .data : 0xc1407bb1 - 0xc15f3500   (1966 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1407bb1   (4126 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] NR_IRQS:384
[    0.000000] CPU 0 irqstacks, hard=f300c000 soft=f300e000
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2792.604 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 5585.20 BogoMIPS (lpj=11170416)
[    0.000165] pid_max: default: 32768 minimum: 301
[    0.000311] Mount-cache hash table entries: 512
[    0.000921] Initializing cgroup subsys cpuacct
[    0.001010] Initializing cgroup subsys devices
[    0.001089] Initializing cgroup subsys freezer
[    0.001168] Initializing cgroup subsys net_cls
[    0.001248] Initializing cgroup subsys blkio
[    0.001377] CPU: Physical Processor ID: 0
[    0.001453] CPU: Processor Core ID: 0
[    0.001532] mce: CPU supports 9 MCE banks
[    0.001616] CPU0: Thermal monitoring handled by SMI
[    0.001624] using mwait in idle threads.
[    0.001785] ACPI: Core revision 20110413
[    0.009698] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.010112] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.049804] CPU0: Intel(R) Core(TM) i7 CPU       M 640  @ 2.80GHz stepping 05
[    0.155000] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.155236] ... version:                3
[    0.155314] ... bit width:              48
[    0.155392] ... generic registers:      4
[    0.155468] ... value mask:             0000ffffffffffff
[    0.155550] ... max period:             000000007fffffff
[    0.155631] ... fixed-purpose events:   3
[    0.155708] ... event mask:             000000070000000f
[    0.156132] NMI watchdog enabled, takes one hw-pmu counter.
[    0.156374] lockdep: fixing up alternatives.
[    0.156563] CPU 1 irqstacks, hard=f30e2000 soft=f30e4000
[    0.156564] Booting Node   0, Processors  #1
[    0.156659] smpboot cpu 1: start_ip = 8f000
[    0.167193] Initializing CPU#1
[    0.182950] calibrate_delay_direct() timer_rate_max=11171727 timer_rate_min=11171544 pre_start=3881838390 pre_end=3904181664
[    0.198921] calibrate_delay_direct() timer_rate_max=11171761 timer_rate_min=11171581 pre_start=3926524953 pre_end=3948868281
[    0.214893] calibrate_delay_direct() timer_rate_max=11171737 timer_rate_min=11171613 pre_start=3971211633 pre_end=3993554940
[    0.230865] calibrate_delay_direct() timer_rate_max=11171698 timer_rate_min=11171566 pre_start=4015898268 pre_end=4038241581
[    0.246837] calibrate_delay_direct() timer_rate_max=11171788 timer_rate_min=11171656 pre_start=4060584918 pre_end=4082928312
[    0.246854] CPU1: Thermal monitoring handled by SMI
[    0.267000] NMI watchdog enabled, takes one hw-pmu counter.
[    0.267299] lockdep: fixing up alternatives.
[    0.267405] CPU 2 irqstacks, hard=f30f2000 soft=f30f4000
[    0.267407]  #2
[    0.267452] smpboot cpu 2: start_ip = 8f000
[    0.277660] Initializing CPU#2
[    0.290761] calibrate_delay_direct() timer_rate_max=11171715 timer_rate_min=11171581 pre_start=4183473708 pre_end=4205817015
[    0.306733] calibrate_delay_direct() timer_rate_max=11171676 timer_rate_min=11171547 pre_start=4228160445 pre_end=4250503671
[    0.322705] calibrate_delay_direct() timer_rate_max=11171721 timer_rate_min=11171589 pre_start=4272847008 pre_end=223013
[    0.322707] calibrate_delay_direct() ignoring timer_rate as we had a TSC wrap around start=4272847029 >=post_end=223154
[    0.338677] calibrate_delay_direct() timer_rate_max=11171937 timer_rate_min=11171811 pre_start=22566383 pre_end=44910128
[    0.354649] calibrate_delay_direct() timer_rate_max=11171704 timer_rate_min=11171575 pre_start=67253036 pre_end=89596322
[    0.354668] CPU2: Thermal monitoring handled by SMI
[    0.374793] NMI watchdog enabled, takes one hw-pmu counter.
[    0.375215] lockdep: fixing up alternatives.
[    0.375322] CPU 3 irqstacks, hard=f3106000 soft=f3110000
[    0.375324]  #3 Ok.
[    0.375395] smpboot cpu 3: start_ip = 8f000
[    0.385537] Initializing CPU#3
[    0.398572] calibrate_delay_direct() timer_rate_max=11171743 timer_rate_min=11171566 pre_start=190141136 pre_end=212484437
[    0.414543] calibrate_delay_direct() timer_rate_max=11171718 timer_rate_min=11171635 pre_start=234827750 pre_end=257171102
[    0.430515] calibrate_delay_direct() timer_rate_max=11171737 timer_rate_min=11171607 pre_start=279514439 pre_end=301857830
[    0.446487] calibrate_delay_direct() timer_rate_max=11171737 timer_rate_min=11171574 pre_start=324201098 pre_end=346544408
[    0.462459] calibrate_delay_direct() timer_rate_max=11171742 timer_rate_min=11171574 pre_start=368887718 pre_end=391231034
[    0.462477] CPU3: Thermal monitoring handled by SMI
[    0.482529] NMI watchdog enabled, takes one hw-pmu counter.
[    0.482735] Brought up 4 CPUs
[    0.482811] Total of 4 processors activated (22342.82 BogoMIPS).
[    0.484759] devtmpfs: initialized
[    0.485332] NET: Registered protocol family 16
[    0.485745] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.485865] ACPI: bus type pci registered
[    0.486024] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.486143] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.486229] PCI: Using MMCONFIG for extended config space
[    0.486310] PCI: Using configuration type 1 for base access
[    0.486397] dmi type 0xB1 record - unknown flag
[    0.487772] bio: create slab <bio-0> at 0
[    0.492889] ACPI: EC: Look up EC in DSDT
[    0.526559] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.606495] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.634596] ACPI: SSDT db7eaa18 004B6 (v01  PmRef  Cpu0Ist 00003000 INTL 20080729)
[    0.636002] ACPI: Dynamic OEM Table Load:
[    0.636161] ACPI: SSDT   (null) 004B6 (v01  PmRef  Cpu0Ist 00003000 INTL 20080729)
[    0.636492] ACPI: SSDT db7e8018 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20080729)
[    0.638641] ACPI: Dynamic OEM Table Load:
[    0.638799] ACPI: SSDT   (null) 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20080729)
[    0.662454] ACPI: SSDT db7e9a98 00303 (v01  PmRef    ApIst 00003000 INTL 20080729)
[    0.663934] ACPI: Dynamic OEM Table Load:
[    0.664094] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20080729)
[    0.674394] ACPI: SSDT db7e7d98 00119 (v01  PmRef    ApCst 00003000 INTL 20080729)
[    0.675834] ACPI: Dynamic OEM Table Load:
[    0.675992] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20080729)
[    0.754124] ACPI: Interpreter enabled
[    0.754204] ACPI: (supports S0 S3 S5)
[    0.754433] ACPI: Using IOAPIC for interrupt routing
[    1.294218] ACPI: EC: GPE = 0x10, I/O: command/status = 0x934, data = 0x930
[    1.317164] ACPI: No dock devices found.
[    1.317243] HEST: Table not found.
[    1.317320] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.318020] \_SB_.PCI0:_OSC invalid UUID
[    1.318021] _OSC request data:1 8 1f 
[    1.318025] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.318986] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.319072] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.319158] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.319271] pci_root PNP0A08:00: host bridge window [mem 0xe0000000-0xfeafffff]
[    1.319411] pci 0000:00:00.0: [8086:0044] type 0 class 0x000600
[    1.319484] pci 0000:00:02.0: [8086:0046] type 0 class 0x000300
[    1.319501] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    1.319510] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    1.319517] pci 0000:00:02.0: reg 20: [io  0x70b0-0x70b7]
[    1.319611] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
[    1.319651] pci 0000:00:16.0: reg 10: [mem 0xf69b0000-0xf69b000f 64bit]
[    1.319758] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.319764] pci 0000:00:16.0: PME# disabled
[    1.319799] pci 0000:00:16.3: [8086:3b67] type 0 class 0x000700
[    1.319829] pci 0000:00:16.3: reg 10: [io  0x70a0-0x70a7]
[    1.319844] pci 0000:00:16.3: reg 14: [mem 0xf6990000-0xf6990fff]
[    1.319992] pci 0000:00:19.0: [8086:10ea] type 0 class 0x000200
[    1.320025] pci 0000:00:19.0: reg 10: [mem 0xf6900000-0xf691ffff]
[    1.320039] pci 0000:00:19.0: reg 14: [mem 0xf6980000-0xf6980fff]
[    1.320055] pci 0000:00:19.0: reg 18: [io  0x7040-0x705f]
[    1.320147] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.320152] pci 0000:00:19.0: PME# disabled
[    1.320190] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    1.320222] pci 0000:00:1a.0: reg 10: [mem 0xf6970000-0xf69703ff]
[    1.320345] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.320350] pci 0000:00:1a.0: PME# disabled
[    1.320388] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    1.320414] pci 0000:00:1b.0: reg 10: [mem 0xf6960000-0xf6963fff 64bit]
[    1.320520] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.320526] pci 0000:00:1b.0: PME# disabled
[    1.320560] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    1.320665] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.320670] pci 0000:00:1c.0: PME# disabled
[    1.320706] pci 0000:00:1c.1: [8086:3b44] type 1 class 0x000604
[    1.320812] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.320817] pci 0000:00:1c.1: PME# disabled
[    1.320852] pci 0000:00:1c.2: [8086:3b46] type 1 class 0x000604
[    1.320962] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    1.320969] pci 0000:00:1c.2: PME# disabled
[    1.321007] pci 0000:00:1c.3: [8086:3b48] type 1 class 0x000604
[    1.321122] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.321128] pci 0000:00:1c.3: PME# disabled
[    1.321188] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    1.321222] pci 0000:00:1d.0: reg 10: [mem 0xf6950000-0xf69503ff]
[    1.321341] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.321346] pci 0000:00:1d.0: PME# disabled
[    1.321376] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    1.321478] pci 0000:00:1f.0: [8086:3b07] type 0 class 0x000601
[    1.321648] pci 0000:00:1f.2: [8086:3b2f] type 0 class 0x000106
[    1.321684] pci 0000:00:1f.2: reg 10: [io  0x7090-0x7097]
[    1.321699] pci 0000:00:1f.2: reg 14: [io  0x7080-0x7083]
[    1.321713] pci 0000:00:1f.2: reg 18: [io  0x7070-0x7077]
[    1.321728] pci 0000:00:1f.2: reg 1c: [io  0x7060-0x7063]
[    1.321742] pci 0000:00:1f.2: reg 20: [io  0x7020-0x703f]
[    1.321757] pci 0000:00:1f.2: reg 24: [mem 0xf6940000-0xf69407ff]
[    1.321821] pci 0000:00:1f.2: PME# supported from D3hot
[    1.321826] pci 0000:00:1f.2: PME# disabled
[    1.321855] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    1.321883] pci 0000:00:1f.3: reg 10: [mem 0xf6930000-0xf69300ff 64bit]
[    1.321923] pci 0000:00:1f.3: reg 20: [io  0x7000-0x701f]
[    1.321987] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
[    1.322023] pci 0000:00:1f.6: reg 10: [mem 0xf6920000-0xf6920fff 64bit]
[    1.322208] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    1.322294] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    1.322299] pci 0000:00:1c.0:   bridge window [mem 0xf5500000-0xf68fffff]
[    1.322309] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.322523] pci 0000:02:00.0: [8086:422c] type 0 class 0x000280
[    1.322661] pci 0000:02:00.0: reg 10: [mem 0xf4100000-0xf4101fff 64bit]
[    1.323197] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    1.323230] pci 0000:02:00.0: PME# disabled
[    1.323462] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    1.323546] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    1.323551] pci 0000:00:1c.1:   bridge window [mem 0xf4100000-0xf54fffff]
[    1.323560] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.323706] pci 0000:03:00.0: [1180:e476] type 2 class 0x000607
[    1.323733] pci 0000:03:00.0: reg 10: [mem 0xf2c40000-0xf2c40fff]
[    1.323793] pci 0000:03:00.0: supports D1 D2
[    1.323794] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.323801] pci 0000:03:00.0: PME# disabled
[    1.323856] pci 0000:03:00.1: [1180:e822] type 0 class 0x000805
[    1.323883] pci 0000:03:00.1: reg 10: [mem 0xf2c30000-0xf2c300ff]
[    1.324053] pci 0000:03:00.1: supports D1 D2
[    1.324054] pci 0000:03:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.324061] pci 0000:03:00.1: PME# disabled
[    1.324119] pci 0000:03:00.4: [1180:e832] type 0 class 0x000c00
[    1.324147] pci 0000:03:00.4: reg 10: [mem 0xf2c00000-0xf2c007ff]
[    1.324315] pci 0000:03:00.4: supports D1 D2
[    1.324317] pci 0000:03:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    1.324324] pci 0000:03:00.4: PME# disabled
[    1.324412] pci 0000:00:1c.2: PCI bridge to [bus 03-04]
[    1.324497] pci 0000:00:1c.2:   bridge window [io  0x2000-0x3fff]
[    1.324502] pci 0000:00:1c.2:   bridge window [mem 0xf0400000-0xf2cfffff]
[    1.324511] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.324626] pci_bus 0000:04: [bus 04-07] partially hidden behind bridge 0000:03 [bus 03-04]
[    1.324814] pci 0000:00:1c.3: PCI bridge to [bus 05-0a]
[    1.324900] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    1.324906] pci 0000:00:1c.3:   bridge window [mem 0xf2d00000-0xf40fffff]
[    1.324915] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.325028] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b] (subtractive decode)
[    1.325125] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.325131] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.325139] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.325145] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.325147] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.325150] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.325152] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xfeafffff] (subtractive decode)
[    1.325192] pci_bus 0000:00: on NUMA node 0
[    1.325195] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.325493] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    1.325660] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.325737] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    1.325814] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    1.325892] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    1.326101] \_SB_.PCI0:_OSC invalid UUID
[    1.326102] _OSC request data:1 1f 1f 
[    1.326106]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.326238] \_SB_.PCI0:_OSC invalid UUID
[    1.326240] _OSC request data:1 0 1d 
[    1.326243]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: 0x1d
[    1.326357] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.335354] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus 3f])
[    1.335530] pci 0000:3f:00.0: [8086:2c62] type 0 class 0x000600
[    1.335561] pci 0000:3f:00.1: [8086:2d01] type 0 class 0x000600
[    1.335596] pci 0000:3f:02.0: [8086:2d10] type 0 class 0x000600
[    1.335625] pci 0000:3f:02.1: [8086:2d11] type 0 class 0x000600
[    1.335655] pci 0000:3f:02.2: [8086:2d12] type 0 class 0x000600
[    1.335684] pci 0000:3f:02.3: [8086:2d13] type 0 class 0x000600
[    1.335735] pci_bus 0000:3f: on NUMA node 0
[    1.335746]  pci0000:3f: Requesting ACPI _OSC control (0x1d)
[    1.335830]  pci0000:3f: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    1.335946] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.336460] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    1.337185] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    1.337826] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    1.338469] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.339178] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    1.339815] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    1.340553] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
[    1.341197] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    1.342108] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.342245] vgaarb: loaded
[    1.342319] vgaarb: bridge control possible 0000:00:02.0
[    1.342458] SCSI subsystem initialized
[    1.342590] libata version 3.00 loaded.
[    1.342675] PCI: Using ACPI for IRQ routing
[    1.345142] PCI: pci_cache_line_size set to 64 bytes
[    1.345298] reserve RAM buffer: 0000000000093c00 - 000000000009ffff 
[    1.345300] reserve RAM buffer: 00000000db65f000 - 00000000dbffffff 
[    1.345574] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.346026] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.348143] Switching to clocksource hpet
[    1.348404] pnp: PnP ACPI init
[    1.348500] ACPI: bus type pnp registered
[    1.348915] pnp 00:00: [bus 00-3e]
[    1.348918] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.348921] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.348924] pnp 00:00: [io  0x0d00-0xffff window]
[    1.348927] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.348929] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    1.348932] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    1.348934] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    1.348937] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    1.348938] Switched to NOHz mode on CPU #0
[    1.348985] Switched to NOHz mode on CPU #3
[    1.349048] Switched to NOHz mode on CPU #1
[    1.349180] Switched to NOHz mode on CPU #2
[    1.349265] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    1.349266] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    1.349268] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    1.349269] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    1.349271] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    1.349272] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    1.349274] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    1.349275] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    1.349277] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    1.349279] pnp 00:00: [mem 0xe0000000-0xfeafffff window]
[    1.349280] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    1.349378] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.349418] pnp 00:01: [io  0x0000-0x001f]
[    1.349419] pnp 00:01: [io  0x0081-0x0091]
[    1.349420] pnp 00:01: [io  0x0093-0x009f]
[    1.349422] pnp 00:01: [io  0x00c0-0x00df]
[    1.349424] pnp 00:01: [dma 4]
[    1.349461] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.349471] pnp 00:02: [mem 0xff000000-0xffffffff]
[    1.349509] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    1.349583] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.349623] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.349635] pnp 00:04: [io  0x00f0]
[    1.349644] pnp 00:04: [irq 13]
[    1.349684] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.349695] pnp 00:05: [io  0x002e-0x002f]
[    1.349697] pnp 00:05: [io  0x004e-0x004f]
[    1.349698] pnp 00:05: [io  0x0061]
[    1.349699] pnp 00:05: [io  0x0063]
[    1.349700] pnp 00:05: [io  0x0065]
[    1.349702] pnp 00:05: [io  0x0067]
[    1.349703] pnp 00:05: [io  0x0070]
[    1.349704] pnp 00:05: [io  0x0080]
[    1.349705] pnp 00:05: [io  0x0092]
[    1.349706] pnp 00:05: [io  0x00b2-0x00b3]
[    1.349708] pnp 00:05: [io  0x0680-0x069f]
[    1.349709] pnp 00:05: [io  0x1000-0x1003]
[    1.349710] pnp 00:05: [io  0x1004-0x1013]
[    1.349712] pnp 00:05: [io  0xffff]
[    1.349714] pnp 00:05: [io  0x0400-0x047f]
[    1.349715] pnp 00:05: [io  0x0500-0x057f]
[    1.349717] pnp 00:05: [io  0x164e-0x164f]
[    1.349802] system 00:05: [io  0x0680-0x069f] has been reserved
[    1.349887] system 00:05: [io  0x1000-0x1003] has been reserved
[    1.349970] system 00:05: [io  0x1004-0x1013] has been reserved
[    1.350054] system 00:05: [io  0xffff] has been reserved
[    1.350136] system 00:05: [io  0x0400-0x047f] has been reserved
[    1.350221] system 00:05: [io  0x0500-0x057f] has been reserved
[    1.350304] system 00:05: [io  0x164e-0x164f] has been reserved
[    1.350390] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.350400] pnp 00:06: [io  0x0070-0x0077]
[    1.350406] pnp 00:06: [irq 8]
[    1.350447] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.350460] pnp 00:07: [io  0x0060]
[    1.350461] pnp 00:07: [io  0x0064]
[    1.350467] pnp 00:07: [irq 1]
[    1.350510] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.350543] pnp 00:08: [mem 0xfed40000-0xfed44fff]
[    1.350587] pnp 00:08: Plug and Play ACPI device, IDs BCM0102 PNP0c31 (active)
[    1.351633] pnp 00:09: Plug and Play ACPI device, IDs PNP0401 (disabled)
[    1.351650] pnp 00:0a: [irq 12]
[    1.351695] pnp 00:0a: Plug and Play ACPI device, IDs DLL040b PNP0f13 (active)
[    1.351989] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
[    1.351990] pnp 00:0b: [mem 0xfed10000-0xfed13fff]
[    1.351992] pnp 00:0b: [mem 0xfed18000-0xfed18fff]
[    1.351993] pnp 00:0b: [mem 0xfed19000-0xfed19fff]
[    1.351995] pnp 00:0b: [mem 0xf8000000-0xfbffffff]
[    1.351996] pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
[    1.351998] pnp 00:0b: [mem 0xfed90000-0xfed93fff]
[    1.351999] pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
[    1.352001] pnp 00:0b: [mem 0xff000000-0xffffffff]
[    1.352002] pnp 00:0b: [mem 0xfee00000-0xfeefffff]
[    1.352003] pnp 00:0b: [mem 0xf69c0000-0xf69c0fff]
[    1.352104] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.352222] system 00:0b: [mem 0xfed10000-0xfed13fff] has been reserved
[    1.352309] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.352395] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.352482] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
[    1.352568] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.352654] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
[    1.352740] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.352829] system 00:0b: [mem 0xff000000-0xffffffff] could not be reserved
[    1.352916] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.353004] system 00:0b: [mem 0xf69c0000-0xf69c0fff] has been reserved
[    1.353093] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.353180] pnp 00:0c: [irq 23]
[    1.353250] pnp 00:0c: Plug and Play ACPI device, IDs SMO8800 (active)
[    1.354610] pnp 00:0d: [bus 3f]
[    1.354706] pnp 00:0d: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.357628] pnp: PnP ACPI: found 14 devices
[    1.357708] ACPI: ACPI bus type pnp unregistered
[    1.357788] PnPBIOS: Disabled by ACPI PNP
[    1.394577] PCI: max bus depth: 2 pci_try_num: 3
[    1.394646] pci 0000:00:1c.2: BAR 15: can't assign mem pref (size 0x4000000)
[    1.394737] pci 0000:00:1c.3: BAR 15: assigned [mem 0xf6a00000-0xf6bfffff 64bit pref]
[    1.394853] pci 0000:00:1c.1: BAR 15: assigned [mem 0xf6c00000-0xf6dfffff 64bit pref]
[    1.394969] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf6e00000-0xf6ffffff 64bit pref]
[    1.395083] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    1.395165] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    1.395254] pci 0000:00:1c.0:   bridge window [mem 0xf5500000-0xf68fffff]
[    1.395343] pci 0000:00:1c.0:   bridge window [mem 0xf6e00000-0xf6ffffff 64bit pref]
[    1.395464] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    1.395547] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    1.395637] pci 0000:00:1c.1:   bridge window [mem 0xf4100000-0xf54fffff]
[    1.395726] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6dfffff 64bit pref]
[    1.395847] pci 0000:03:00.0: BAR 15: can't assign mem pref (size 0x4000000)
[    1.395936] pci 0000:03:00.0: BAR 16: can't assign mem (size 0x4000000)
[    1.396021] pci 0000:03:00.0: BAR 13: assigned [io  0x2000-0x20ff]
[    1.396121] pci 0000:03:00.0: BAR 14: assigned [io  0x2400-0x24ff]
[    1.396209] pci 0000:03:00.0: CardBus bridge to [bus 04-07]
[    1.396291] pci 0000:03:00.0:   bridge window [io  0x2000-0x20ff]
[    1.396380] pci 0000:03:00.0:   bridge window [io  0x2400-0x24ff]
[    1.396469] pci 0000:00:1c.2: PCI bridge to [bus 03-04]
[    1.396553] pci 0000:00:1c.2:   bridge window [io  0x2000-0x3fff]
[    1.396642] pci 0000:00:1c.2:   bridge window [mem 0xf0400000-0xf2cfffff]
[    1.396731] pci 0000:00:1c.2:   bridge window [mem pref disabled]
[    1.396821] pci 0000:00:1c.3: PCI bridge to [bus 05-0a]
[    1.396903] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    1.396992] pci 0000:00:1c.3:   bridge window [mem 0xf2d00000-0xf40fffff]
[    1.397082] pci 0000:00:1c.3:   bridge window [mem 0xf6a00000-0xf6bfffff 64bit pref]
[    1.397201] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b]
[    1.397281] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.397369] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.397455] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.397546] PCI: No. 2 try to assign unassigned res
[    1.397609] pci 0000:00:1c.2: BAR 15: can't assign mem pref (size 0x4000000)
[    1.397696] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    1.397779] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    1.397868] pci 0000:00:1c.0:   bridge window [mem 0xf5500000-0xf68fffff]
[    1.397958] pci 0000:00:1c.0:   bridge window [mem 0xf6e00000-0xf6ffffff 64bit pref]
[    1.398077] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    1.398159] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    1.398248] pci 0000:00:1c.1:   bridge window [mem 0xf4100000-0xf54fffff]
[    1.398337] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6dfffff 64bit pref]
[    1.398458] pci 0000:03:00.0: BAR 15: can't assign mem pref (size 0x4000000)
[    1.398546] pci 0000:03:00.0: BAR 16: can't assign mem (size 0x4000000)
[    1.398632] pci 0000:03:00.0: CardBus bridge to [bus 04-07]
[    1.398714] pci 0000:03:00.0:   bridge window [io  0x0000-0x00ff]
[    1.398803] pci 0000:03:00.0:   bridge window [io  0x0000-0x00ff]
[    1.398892] pci 0000:00:1c.2: PCI bridge to [bus 03-04]
[    1.398976] pci 0000:00:1c.2:   bridge window [io  0x2000-0x3fff]
[    1.399064] pci 0000:00:1c.2:   bridge window [mem 0xf0400000-0xf2cfffff]
[    1.399154] pci 0000:00:1c.2:   bridge window [mem pref disabled]
[    1.399244] pci 0000:00:1c.3: PCI bridge to [bus 05-0a]
[    1.399327] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    1.399416] pci 0000:00:1c.3:   bridge window [mem 0xf2d00000-0xf40fffff]
[    1.399506] pci 0000:00:1c.3:   bridge window [mem 0xf6a00000-0xf6bfffff 64bit pref]
[    1.399625] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b]
[    1.399704] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.399791] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.399877] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.399968] PCI: No. 3 try to assign unassigned res
[    1.399970] release child resource [mem 0xf2c00000-0xf2c007ff]
[    1.399971] release child resource [mem 0xf2c30000-0xf2c300ff]
[    1.399972] release child resource [mem 0xf2c40000-0xf2c40fff]
[    1.399974] pci 0000:00:1c.2: resource 14 [mem 0xf0400000-0xf2cfffff] released
[    1.399976] pci 0000:00:1c.2: PCI bridge to [bus 03-04]
[    1.400057] pci 0000:00:1c.2:   bridge window [mem disabled]
[    1.400215] pci 0000:00:1c.2: BAR 15: can't assign mem pref (size 0x4000000)
[    1.400305] pci 0000:00:1c.2: BAR 14: can't assign mem (size 0x6000000)
[    1.400391] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    1.400474] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    1.400563] pci 0000:00:1c.0:   bridge window [mem 0xf5500000-0xf68fffff]
[    1.400653] pci 0000:00:1c.0:   bridge window [mem 0xf6e00000-0xf6ffffff 64bit pref]
[    1.400773] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    1.400856] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    1.400945] pci 0000:00:1c.1:   bridge window [mem 0xf4100000-0xf54fffff]
[    1.401035] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6dfffff 64bit pref]
[    1.401155] pci 0000:03:00.0: BAR 15: can't assign mem pref (size 0x4000000)
[    1.401242] pci 0000:03:00.0: BAR 16: can't assign mem (size 0x4000000)
[    1.401328] pci 0000:03:00.0: BAR 0: can't assign mem (size 0x1000)
[    1.401412] pci 0000:03:00.4: BAR 0: can't assign mem (size 0x800)
[    1.401496] pci 0000:03:00.1: BAR 0: can't assign mem (size 0x100)
[    1.401580] pci 0000:03:00.0: CardBus bridge to [bus 04-07]
[    1.401662] pci 0000:03:00.0:   bridge window [io  0x0000-0x00ff]
[    1.401751] pci 0000:03:00.0:   bridge window [io  0x0000-0x00ff]
[    1.402588] pci 0000:00:1c.2: PCI bridge to [bus 03-04]
[    1.402671] pci 0000:00:1c.2:   bridge window [io  0x2000-0x3fff]
[    1.402759] pci 0000:00:1c.2:   bridge window [mem disabled]
[    1.402845] pci 0000:00:1c.2:   bridge window [mem pref disabled]
[    1.402935] pci 0000:00:1c.3: PCI bridge to [bus 05-0a]
[    1.403018] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    1.403107] pci 0000:00:1c.3:   bridge window [mem 0xf2d00000-0xf40fffff]
[    1.403197] pci 0000:00:1c.3:   bridge window [mem 0xf6a00000-0xf6bfffff 64bit pref]
[    1.403316] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b]
[    1.403396] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.403483] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.403570] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.404220] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.404457] pci 0000:00:1c.0: setting latency timer to 64
[    1.408199] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.408292] pci 0000:00:1c.1: setting latency timer to 64
[    1.408309] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.408400] pci 0000:00:1c.2: setting latency timer to 64
[    1.412188] pci 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.412426] pci 0000:03:00.0: setting latency timer to 64
[    1.416187] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.416279] pci 0000:00:1c.3: setting latency timer to 64
[    1.416288] pci 0000:00:1e.0: setting latency timer to 64
[    1.416293] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.416294] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.416296] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.416297] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfeafffff]
[    1.416299] pci_bus 0000:01: resource 0 [io  0x6000-0x6fff]
[    1.416301] pci_bus 0000:01: resource 1 [mem 0xf5500000-0xf68fffff]
[    1.416302] pci_bus 0000:01: resource 2 [mem 0xf6e00000-0xf6ffffff 64bit pref]
[    1.416304] pci_bus 0000:02: resource 0 [io  0x5000-0x5fff]
[    1.416306] pci_bus 0000:02: resource 1 [mem 0xf4100000-0xf54fffff]
[    1.416307] pci_bus 0000:02: resource 2 [mem 0xf6c00000-0xf6dfffff 64bit pref]
[    1.416309] pci_bus 0000:03: resource 0 [io  0x2000-0x3fff]
[    1.416311] pci_bus 0000:04: resource 0 [io  0x0000-0x00ff]
[    1.416312] pci_bus 0000:04: resource 1 [io  0x0000-0x00ff]
[    1.416314] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    1.416315] pci_bus 0000:05: resource 1 [mem 0xf2d00000-0xf40fffff]
[    1.416317] pci_bus 0000:05: resource 2 [mem 0xf6a00000-0xf6bfffff 64bit pref]
[    1.416318] pci_bus 0000:0b: resource 4 [io  0x0000-0x0cf7]
[    1.416320] pci_bus 0000:0b: resource 5 [io  0x0d00-0xffff]
[    1.416321] pci_bus 0000:0b: resource 6 [mem 0x000a0000-0x000bffff]
[    1.416323] pci_bus 0000:0b: resource 7 [mem 0xe0000000-0xfeafffff]
[    1.416368] NET: Registered protocol family 2
[    1.416546] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    1.417035] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.417416] TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
[    1.420728] TCP: Hash tables configured (established 131072 bind 65536)
[    1.420837] TCP reno registered
[    1.420914] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    1.421050] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    1.421337] NET: Registered protocol family 1
[    1.421439] pci 0000:00:02.0: Boot video device
[    1.421565] PCI: CLS 64 bytes, default 64
[    1.421621] DMAR: Host address width 36
[    1.421700] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    1.421787] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020e30272 ecap 1000
[    1.421898] DMAR: DRHD base: 0x000000fed91000 flags: 0x0
[    1.421984] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c0000020230272 ecap 1000
[    1.422096] DMAR: DRHD base: 0x000000fed93000 flags: 0x1
[    1.422180] IOMMU 2: reg_base_addr fed93000 ver 1:0 cap c9008020630272 ecap 1000
[    1.422293] DMAR: RMRR base: 0x000000db7d7000 end: 0x000000db7e6fff
[    1.422378] DMAR: RMRR base: 0x000000ddc00000 end: 0x000000dfffffff
[    1.422462] DMAR: No ATSR found
[    1.422546] Simple Boot Flag at 0xf1 set to 0x1
[    1.432496] highmem bounce pool size: 64 pages
[    1.432583] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.453376] msgmni has been set to 1622
[    1.453824] alg: No test for stdrng (krng)
[    1.453989] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.454112] io scheduler noop registered
[    1.454190] io scheduler deadline registered
[    1.454278] io scheduler cfq registered (default)
[    1.454365] start plist test
[    1.455400] end plist test
[    1.455955] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.456139] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.456251] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.456565] intel_idle: MWAIT substates: 0x1120
[    1.456567] intel_idle: v0.4 model 0x25
[    1.456568] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.456784] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    1.457324] ACPI: Lid Switch [LID]
[    1.457462] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    1.457601] ACPI: Power Button [PBTN]
[    1.457730] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    1.457847] ACPI: Sleep Button [SBTN]
[    1.457978] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    1.458092] ACPI: Power Button [PWRF]
[    1.458188] ERST: Table is not found!
[    1.458280] isapnp: Scanning for PnP cards...
[    1.812060] isapnp: No Plug & Play device found
[    1.812247] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.813061] serial 0000:00:16.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.833998] 0000:00:16.3: ttyS0 at I/O 0x70a0 (irq = 19) is a 16550A
[    1.834763] i8k: unable to get SMM BIOS version
[    1.846882] Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal Zotto (dz@debian.org)
[    1.846995] Linux agpgart interface v0.103
[    1.847291] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    1.847489] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
[    1.848218] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    1.848577] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    1.848751] [drm] Initialized drm 1.1.0 20060810
[    1.848858] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.848947] i915 0000:00:02.0: setting latency timer to 64
[    1.872461] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    1.872468] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.872558] [drm] Driver supports precise vblank timestamp query.
[    1.872765] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.418444] Refined TSC clocksource calibration: 2792.999 MHz.
[    2.418543] Switching to clocksource tsc
[    3.460559] [drm] GMBUS timed out, falling back to bit banging on pin 7 [i915 gmbus dpd]
[    3.489542] fbcon: inteldrmfb (fb0) is primary device
[    5.001303] Console: switching to colour frame buffer device 240x67
[    5.006689] fb0: inteldrmfb frame buffer device
[    5.006690] drm: registered panic notifier
[    5.016459] acpi device:43: registered as cooling_device0
[    5.017020] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:02/input/input4
[    5.017074] ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)
[    5.017155] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    5.017372] ahci 0000:00:1f.2: version 3.0
[    5.017388] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.017493] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    5.017596] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
[    5.017638] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems sxs apst 
[    5.017683] ahci 0000:00:1f.2: setting latency timer to 64
[    5.038891] scsi0 : ahci
[    5.039085] scsi1 : ahci
[    5.039194] scsi2 : ahci
[    5.039303] scsi3 : ahci
[    5.039415] scsi4 : ahci
[    5.039532] scsi5 : ahci
[    5.040170] ata1: SATA max UDMA/133 abar m2048@0xf6940000 port 0xf6940100 irq 41
[    5.040210] ata2: SATA max UDMA/133 abar m2048@0xf6940000 port 0xf6940180 irq 41
[    5.040248] ata3: DUMMY
[    5.040263] ata4: DUMMY
[    5.040280] ata5: SATA max UDMA/133 abar m2048@0xf6940000 port 0xf6940300 irq 41
[    5.040319] ata6: SATA max UDMA/133 abar m2048@0xf6940000 port 0xf6940380 irq 41
[    5.040433] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    5.040465] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    5.040559] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    5.040611] e1000e 0000:00:19.0: setting latency timer to 64
[    5.040790] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[    5.224228] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 5c:26:0a:3e:27:e2
[    5.224270] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    5.224377] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: 2041FF-0FF
[    5.224442] tun: Universal TUN/TAP device driver, 1.6
[    5.224469] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    5.224661] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    5.224936] i8042: Warning: Keylock active
[    5.226275] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.226333] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.226618] mousedev: PS/2 mouse device common for all mice
[    5.226818] rtc_cmos 00:06: RTC can wake from S4
[    5.227153] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    5.227238] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    5.227294] md: raid0 personality registered for level 0
[    5.227333] md: raid1 personality registered for level 1
[    5.227535] cpuidle: using governor ladder
[    5.227717] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    5.228228] cpuidle: using governor menu
[    5.230073] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
[    5.233768] intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.238428] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[    5.243479] TCP cubic registered
[    5.247803] NET: Registered protocol family 10
[    5.255890] Mobile IPv6
[    5.259635] NET: Registered protocol family 17
[    5.263441] 802.1Q VLAN Support v1.8
[    5.267299] Using IPI No-Shortcut mode
[    5.282781] rtc_cmos 00:06: setting system clock to 2011-06-07 20:19:08 UTC (1307477948)
[    5.357384] ata5: SATA link down (SStatus 0 SControl 300)
[    5.360939] ata2: SATA link down (SStatus 0 SControl 300)
[    5.364740] ata6: SATA link down (SStatus 0 SControl 300)
[    5.366569] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.372005] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    5.375008] ata1.00: ATA-8: SAMSUNG SSD PM810 2.5" 256GB, AXM06D1Q, max UDMA/133
[    5.378308] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    5.382551] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    5.387054] ata1.00: configured for UDMA/133
[    5.391743] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SSD PM81 AXM0 PQ: 0 ANSI: 5
[    5.396400] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    5.396665] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.400023] sd 0:0:0:0: [sda] Write Protect is off
[    5.401671] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.401702] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.405066]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    5.410518] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.414059] md: Waiting for all devices to be available before autodetect
[    5.417525] md: If you don't use raid, use raid=noautodetect
[    5.422188] md: Autodetecting RAID arrays.
[    5.425588] md: Scanned 0 and added 0 devices.
[    5.428994] md: autorun ...
[    5.432419] md: ... autorun DONE.
[    5.436754] EXT4-fs (sda3): couldn't mount as ext3 due to feature incompatibilities
[    5.510764] EXT4-fs (sda3): couldn't mount as ext2 due to feature incompatibilities
[    5.585607] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    5.587346] VFS: Mounted root (ext4 filesystem) readonly on device 8:3.
[    5.589284] Freeing unused kernel memory: 392k freed
[    5.591064] Write protecting the kernel text: 4128k
[    5.592854] Write protecting the kernel read-only data: 1640k
[    5.594521] NX-protecting the kernel data: 4064k
[    5.989481] ACPI: acpi_idle yielding to intel_idle
[    6.001528] ACPI: AC Adapter [AC] (off-line)
[    6.044906] ACPI: Battery Slot [BAT0] (battery present)
[    6.096905] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    6.101805] yenta_cardbus 0000:03:00.0: No cardbus resource!
[    6.111139] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    6.112087] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.122398] usbcore: registered new interface driver usbfs
[    6.126377] usbcore: registered new interface driver hub
[    6.129736] usbcore: registered new device driver usb
[    6.147829] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.156049] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.158626] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.158635] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    6.159019] ACPI: Battery Slot [BAT1] (battery absent)
[    6.160641] wmi: Mapper loaded
[    6.164859] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    6.166945] ehci_hcd 0000:00:1a.0: debug port 2
[    6.167106] sdhci: Secure Digital Host Controller Interface driver
[    6.167108] sdhci: Copyright(c) Pierre Ossman
[    6.194731] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    6.195140] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf6970000
[    6.196423] sdhci-pci 0000:03:00.1: SDHCI controller found [1180:e822] (rev 3)
[    6.196429] sdhci-pci 0000:03:00.1: found 1 slot(s)
[    6.196447] sdhci-pci 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.196451] sdhci-pci 0000:03:00.1: BAR 0 is not iomem. Aborting.
[    6.196459] sdhci-pci 0000:03:00.1: PCI INT B disabled
[    6.203663] tpm_tis 00:08: 1.2 TPM (device-id 0x2001, rev-id 32)
[    6.223816] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    6.227005] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.229001] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.230827] usb usb1: Product: EHCI Host Controller
[    6.233371] usb usb1: Manufacturer: Linux 3.0.0-rc2-dirty ehci_hcd
[    6.235638] usb usb1: SerialNumber: 0000:00:1a.0
[    6.241970] cfg80211: Calling CRDA to update world regulatory domain
[    6.246720] hub 1-0:1.0: USB hub found
[    6.249088] hub 1-0:1.0: 3 ports detected
[    6.253909] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.256151] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.256157] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    6.256534] input: Dell WMI hotkeys as /devices/virtual/input/input7
[    6.259514] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    6.261416] ehci_hcd 0000:00:1d.0: debug port 2
[    6.267224] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    6.268103] ehci_hcd 0000:00:1d.0: irq 17, io mem 0xf6950000
[    6.283745] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    6.287368] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    6.291302] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.294325] usb usb2: Product: EHCI Host Controller
[    6.297822] usb usb2: Manufacturer: Linux 3.0.0-rc2-dirty ehci_hcd
[    6.301264] usb usb2: SerialNumber: 0000:00:1d.0
[    6.305425] hub 2-0:1.0: USB hub found
[    6.307072] hub 2-0:1.0: 3 ports detected
[    6.323443] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    6.327192] HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[    6.327249] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    6.384046] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    6.385936] iwlagn: Copyright(c) 2003-2011 Intel Corporation
[    6.387938] iwlagn 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.389845] iwlagn 0000:02:00.0: setting latency timer to 64
[    6.389880] iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
[    6.408362] iwlagn 0000:02:00.0: device EEPROM VER=0x43a, CALIB=0x6
[    6.410238] iwlagn 0000:02:00.0: Device SKU: 0Xb
[    6.412234] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    6.414361] iwlagn 0000:02:00.0: irq 44 for MSI/MSI-X
[    6.426542] iwlagn 0000:02:00.0: loaded firmware version 9.193.4.1 build 19710
[    6.431014] Registered led device: phy0-led
[    6.440630] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    6.559233] usb 1-1: new high speed USB device number 2 using ehci_hcd
[    7.030094] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    7.033713] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    7.038475] hub 1-1:1.0: USB hub found
[    7.042636] hub 1-1:1.0: 6 ports detected
[    7.158216] usb 2-1: new high speed USB device number 2 using ehci_hcd
[    7.357858] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    7.359829] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    7.369997] hub 2-1:1.0: USB hub found
[    7.381816] hub 2-1:1.0: 8 ports detected
[    7.503784] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
[    7.517293] HDMI status: Pin=4 Presence_Detect=0 ELD_Valid=0
[    7.521463] HDMI status: Pin=5 Presence_Detect=0 ELD_Valid=0
[    7.525579] HDMI status: Pin=6 Presence_Detect=0 ELD_Valid=0
[    7.539006] input: HDA Intel Mic at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    7.540778] input: HDA Intel Mic at Ext Right Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    7.542561] input: HDA Intel Line Out at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    7.544349] input: HDA Intel HP Out at Ext Right Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    7.546516] input: HDA Intel HDMI/DP as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    7.548291] input: HDA Intel HDMI/DP as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[    7.550073] input: HDA Intel HDMI/DP as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[    8.280364] usb 2-1.4: new low speed USB device number 3 using ehci_hcd
[    9.050338] usb 2-1.4: New USB device found, idVendor=0461, idProduct=4d03
[    9.053870] usb 2-1.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    9.131068] usb 2-1.7: new full speed USB device number 4 using ehci_hcd
[    9.232231] usb 2-1.7: New USB device found, idVendor=413c, idProduct=8187
[    9.235798] usb 2-1.7: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    9.239307] usb 2-1.7: Product: DW375 Bluetooth Module
[    9.242844] usb 2-1.7: Manufacturer: Dell Computer Corp
[    9.246298] usb 2-1.7: SerialNumber: C0CB38A9E70C
[    9.281574] Bluetooth: Core ver 2.16
[    9.284891] NET: Registered protocol family 31
[    9.288329] Bluetooth: HCI device and connection manager initialized
[    9.291878] Bluetooth: HCI socket layer initialized
[    9.295340] Bluetooth: L2CAP socket layer initialized
[    9.299033] Bluetooth: SCO socket layer initialized
[    9.306332] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    9.308908] usbcore: registered new interface driver btusb
[    9.326771] usb 2-1.8: new full speed USB device number 5 using ehci_hcd
[    9.445160] usb 2-1.8: New USB device found, idVendor=0a5c, idProduct=5800
[    9.448261] usb 2-1.8: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    9.451703] usb 2-1.8: Product: 5880
[    9.455087] usb 2-1.8: Manufacturer: Broadcom Corp
[    9.458506] usb 2-1.8: SerialNumber: 0123456789ABCD
[    9.462284] usb 2-1.8: config 0 descriptor??
[    9.483577] WARNING! power/level is deprecated; use power/control instead
[    9.497061] input: HID 0461:4d03 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/input/input16
[    9.498905] generic-usb 0003:0461:4D03.0001: input: USB HID v1.10 Mouse [HID 0461:4d03] on usb-0000:00:1d.0-1.4/input0
[    9.500509] usbcore: registered new interface driver usbhid
[    9.502080] usbhid: USB HID core driver
[    9.755670] EXT4-fs (sda3): re-mounted. Opts: (null)
[    9.802720] EXT4-fs (sda3): re-mounted. Opts: errors=remount-ro
[   10.425695] hpet1: lost 25 rtc interrupts
[   10.503913] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input17
[   10.611381] loop: module loaded
[   11.005039] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[   11.024375] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[   11.859956] vcan: Virtual CAN interface driver
[   11.875328] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   12.023359] Bluetooth: RFCOMM TTY layer initialized
[   12.023370] Bluetooth: RFCOMM socket layer initialized
[   12.023373] Bluetooth: RFCOMM ver 1.11
[   12.024480] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   12.050017] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   12.105826] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   12.107759] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.796013] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input18

--------------040302050002040906070604--
