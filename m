Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab2H0R4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:56:22 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48445 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567Ab2H0R4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:56:19 -0400
Message-ID: <503BB4BB.4080307@gmail.com>
Date: Mon, 27 Aug 2012 19:56:11 +0200
From: Arvydas Sidorenko <asido4@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: linux-kernel@vger.kernel.org,
        IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Storage related regression in linux-next 20120824
References: <CA+6av4=uxu_q5U_46HtpUt=FSgbh3pZuAEY54J5_xK=MKWq-YQ@mail.gmail.com> <CAFtxgO536xEMjMw_D1u3utT1f1iy-6EsjcawdYvbocRxc=Wu=A@mail.gmail.com> <503BA2DB.9080704@gmail.com>
In-Reply-To: <503BA2DB.9080704@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 06:39 PM, Arvydas Sidorenko wrote:
>> Can you pastebin 'dmesg' and 'lspci'?  Did this occur only once, or is
>> it reproducible?
>>
>>       Jeff
> It does happen every time when booting into -next 20120824.
>
> #lspci
> 00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor 
> Family DRAM Controller (rev 09)
> 00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core 
> Processor Family PCI Express Root Port (rev 09)
> 00:01.1 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core 
> Processor Family PCI Express Root Port (rev 09)
> 00:02.0 VGA compatible controller: Intel Corporation 2nd Generation 
> Core Processor Family Integrated Graphics Controller (rev 09)
> 00:16.0 Communication controller: Intel Corporation 6 Series/C200 
> Series Chipset Family MEI Controller #1 (rev 04)
> 00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset 
> Family USB Universal Host Controller #5 (rev 05)
> 00:1a.7 USB controller: Intel Corporation 6 Series/C200 Series Chipset 
> Family USB Enhanced Host Controller #2 (rev 05)
> 00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset 
> Family High Definition Audio Controller (rev 05)
> 00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
> Family PCI Express Root Port 1 (rev b5)
> 00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
> Family PCI Express Root Port 2 (rev b5)
> 00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
> Family PCI Express Root Port 3 (rev b5)
> 00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset 
> Family USB Universal Host Controller #1 (rev 05)
> 00:1d.7 USB controller: Intel Corporation 6 Series/C200 Series Chipset 
> Family USB Enhanced Host Controller #1 (rev 05)
> 00:1f.0 ISA bridge: Intel Corporation HM65 Express Chipset Family LPC 
> Controller (rev 05)
> 00:1f.2 IDE interface: Intel Corporation 6 Series/C200 Series Chipset 
> Family 4 port SATA IDE Controller (rev 05)
> 00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family 
> SMBus Controller (rev 05)
> 02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM57765 
> Gigabit Ethernet PCIe (rev 10)
> 02:00.1 SD Host controller: Broadcom Corporation NetXtreme BCM57765 
> Memory Card Reader (rev 10)
> 03:00.0 Network controller: Broadcom Corporation BCM4331 802.11a/b/g/n 
> (rev 02)
> 04:00.0 PCI bridge: Texas Instruments XIO2213A/B/XIO2221 PCI Express 
> to PCI Bridge [Cheetah Express] (rev 01)
> 05:00.0 FireWire (IEEE 1394): Texas Instruments XIO2213A/B/XIO2221 
> IEEE-1394b OHCI Controller [Cheetah Express] (rev 01)
>
>
> #dmesg
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.6.0-rc3-next-20120824 (asido@slacker) 
> (gcc version 4.6.3 (Gentoo 4.6.3 p1.5, pie-0.5.2) ) #9 SMP Sun Aug 26 
> 15:54:31 CEST 2012
> [    0.000000] Command line: root=/dev/sda4
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008efff] 
> usable
> [    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000008ffff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009fbff] 
> usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x00000000000fffff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] 
> usable
> [    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] 
> usable
> [    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000040200000-0x000000008ad33fff] 
> usable
> [    0.000000] BIOS-e820: [mem 0x000000008ad34000-0x000000008ad5efff] 
> ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000008ad5f000-0x000000008afa1fff] 
> ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000008afa2000-0x000000008affefff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x000000008afff000-0x000000008affffff] 
> ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000008b000000-0x000000008f9fffff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] 
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000026fdfffff] 
> usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Apple Inc. Macmini5,1/Mac-8ED6AF5B48C039E1, BIOS 
> MM51.88Z.0077.B0F.1110201309 10/20/2011
> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> 
> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x26fe00 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-DFFFF write-protect
> [    0.000000]   E0000-FFFFF uncachable
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
> [    0.000000]   1 base 0A0000000 mask FE0000000 uncachable
> [    0.000000]   2 base 090000000 mask FF0000000 uncachable
> [    0.000000]   3 base 08C000000 mask FFC000000 uncachable
> [    0.000000]   4 base 08B800000 mask FFF800000 uncachable
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
> 0x7010600070106
> [    0.000000] e820: last_pfn = 0x8ad34 max_arch_pfn = 0x400000000
> [    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 
> 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x8ad33fff]
> [    0.000000]  [mem 0x00000000-0x8abfffff] page 2M
> [    0.000000]  [mem 0x8ac00000-0x8ad33fff] page 4k
> [    0.000000] kernel direct mapping tables up to 0x8ad33fff @ [mem 
> 0x1fba5000-0x1fffffff]
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x26fdfffff]
> [    0.000000]  [mem 0x100000000-0x26fdfffff] page 2M
> [    0.000000] kernel direct mapping tables up to 0x26fdfffff @ [mem 
> 0x8ad29000-0x8ad33fff]
> [    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
> [    0.000000] ACPI: XSDT 000000008ad8e1c0 000B4 (v01 APPLE Apple00 
> 00000060      01000013)
> [    0.000000] ACPI: FACP 000000008ad8c000 000F4 (v04 APPLE Apple00 
> 00000060 Loki 0000005F)
> [    0.000000] ACPI: DSDT 000000008ad81000 0500C (v01 APPLE Macmini 
> 00050001 INTL 20100915)
> [    0.000000] ACPI: FACS 000000008ad3e000 00040
> [    0.000000] ACPI: HPET 000000008ad8b000 00038 (v01 APPLE Apple00 
> 00000001 Loki 0000005F)
> [    0.000000] ACPI: APIC 000000008ad8a000 000BC (v02 APPLE Apple00 
> 00000001 Loki 0000005F)
> [    0.000000] ACPI: SBST 000000008ad88000 00030 (v01 APPLE Apple00 
> 00000001 Loki 0000005F)
> [    0.000000] ACPI: ECDT 000000008ad87000 00053 (v01 APPLE Apple00 
> 00000001 Loki 0000005F)
> [    0.000000] ACPI: SSDT 000000008ad7d000 00024 (v01 APPLE SmcDppt 
> 00001000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad7a000 00643 (v01 APPLE UsbNoRmh 
> 00001000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad78000 0013F (v01 APPLE SataPrt1 
> 00001000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad77000 00159 (v02 APPLE IGHda 
> 00001000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad73000 01580 (v02 APPLE SsdtIGPU 
> 00001000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad72000 0060E (v01  PmRef Cpu0Ist 
> 00003000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad71000 009B1 (v01  PmRef CpuPm 
> 00003000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad70000 00315 (v01  PmRef Cpu0Tst 
> 00003000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad6f000 0037A (v01  PmRef ApTst 
> 00003000 INTL 20100915)
> [    0.000000] ACPI: MCFG 000000008ad89000 0003C (v01 APPLE Apple00 
> 00000001 Loki 0000005F)
> [    0.000000] ACPI: SSDT 000000008ad80000 000FA (v01 SataRe SataPri 
> 00001000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad7f000 000FA (v01 SataRe SataSec 
> 00001000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad7e000 00032 (v01  Apple SsdtS3 
> 00001000 INTL 20100915)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 
> 0x0000000000000000-0x000000026fdfffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x26fdfffff]
> [    0.000000]   NODE_DATA [mem 0x26fdfc000-0x26fdfffff]
> [    0.000000]  [ffffea0000000000-ffffea0009bfffff] PMD -> 
> [ffff880267400000-ffff88026f3fffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x26fdfffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00010000-0x0008efff]
> [    0.000000]   node   0: [mem 0x00090000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
> [    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
> [    0.000000]   node   0: [mem 0x40200000-0x8ad33fff]
> [    0.000000]   node   0: [mem 0x100000000-0x26fdfffff]
> [    0.000000] On node 0 totalpages: 2074306
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 6 pages reserved
> [    0.000000]   DMA zone: 3912 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 16320 pages used for memmap
> [    0.000000]   DMA32 zone: 547188 pages, LIFO batch:31
> [    0.000000]   Normal zone: 23544 pages used for memmap
> [    0.000000]   Normal zone: 1483272 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, 
> GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high 
> level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: 8 Processors exceeds NR_CPUS limit of 4
> [    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000008f000 - 
> 0000000000090000
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 
> 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
> 0000000000100000
> [    0.000000] PM: Registered nosave memory: 0000000020000000 - 
> 0000000020200000
> [    0.000000] PM: Registered nosave memory: 0000000040000000 - 
> 0000000040200000
> [    0.000000] PM: Registered nosave memory: 000000008ad34000 - 
> 000000008ad5f000
> [    0.000000] PM: Registered nosave memory: 000000008ad5f000 - 
> 000000008afa2000
> [    0.000000] PM: Registered nosave memory: 000000008afa2000 - 
> 000000008afff000
> [    0.000000] PM: Registered nosave memory: 000000008afff000 - 
> 000000008b000000
> [    0.000000] PM: Registered nosave memory: 000000008b000000 - 
> 000000008fa00000
> [    0.000000] PM: Registered nosave memory: 000000008fa00000 - 
> 00000000e0000000
> [    0.000000] PM: Registered nosave memory: 00000000e0000000 - 
> 00000000f0000000
> [    0.000000] PM: Registered nosave memory: 00000000f0000000 - 
> 00000000fec00000
> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 
> 00000000fec01000
> [    0.000000] PM: Registered nosave memory: 00000000fec01000 - 
> 00000000fed00000
> [    0.000000] PM: Registered nosave memory: 00000000fed00000 - 
> 00000000fed04000
> [    0.000000] PM: Registered nosave memory: 00000000fed04000 - 
> 00000000fed10000
> [    0.000000] PM: Registered nosave memory: 00000000fed10000 - 
> 00000000fed14000
> [    0.000000] PM: Registered nosave memory: 00000000fed14000 - 
> 00000000fed18000
> [    0.000000] PM: Registered nosave memory: 00000000fed18000 - 
> 00000000fed1a000
> [    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 
> 00000000fed1c000
> [    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 
> 00000000fed20000
> [    0.000000] PM: Registered nosave memory: 00000000fed20000 - 
> 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 
> 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 
> 00000000ff800000
> [    0.000000] PM: Registered nosave memory: 00000000ff800000 - 
> 0000000100000000
> [    0.000000] e820: [mem 0x8fa00000-0xdfffffff] available for PCI 
> devices
> [    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 
> nr_node_ids:1
> [    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88026fa00000 s78272 
> r8192 d24128 u524288
> [    0.000000] pcpu-alloc: s78272 r8192 d24128 u524288 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  
> Total pages: 2034372
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: root=/dev/sda4
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] __ex_table already sorted, skipping sort
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - 
> bailing!
> [    0.000000] Memory: 8084852k/10221568k available (7059k kernel 
> code, 1924344k absent, 212372k reserved, 5915k data, 600k init)
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, 
> CPUs=4, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] NR_IRQS:4352 nr_irqs:712 16
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.001000] tsc: Detected 2294.757 MHz processor
> [    0.000001] Calibrating delay loop (skipped), value calculated 
> using timer frequency.. 4589.51 BogoMIPS (lpj=2294757)
> [    0.000152] pid_max: default: 32768 minimum: 301
> [    0.000246] Security Framework initialized
> [    0.000319] SELinux:  Initializing.
> [    0.000396] SELinux:  Starting in permissive mode
> [    0.000848] Dentry cache hash table entries: 1048576 (order: 11, 
> 8388608 bytes)
> [    0.002653] Inode-cache hash table entries: 524288 (order: 10, 
> 4194304 bytes)
> [    0.003478] Mount-cache hash table entries: 256
> [    0.003706] Initializing cgroup subsys cpuacct
> [    0.003780] Initializing cgroup subsys freezer
> [    0.003871] CPU: Physical Processor ID: 0
> [    0.003944] CPU: Processor Core ID: 0
> [    0.004020] mce: CPU supports 7 MCE banks
> [    0.004102] CPU0: Thermal monitoring enabled (TM1)
> [    0.004180] process: using mwait in idle threads
> [    0.004266] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
> [    0.004266] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
> [    0.004266] tlb_flushall_shift: 5
> [    0.004526] Freeing SMP alternatives: 24k freed
> [    0.004606] ACPI: Core revision 20120711
> [    0.010917] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.021489] smpboot: CPU0: Intel(R) Core(TM) i5-2415M CPU @ 2.30GHz 
> stepping 07
> [    0.123160] Performance Events: PEBS fmt1+, 16-deep LBR, 
> SandyBridge events, Intel PMU driver.
> [    0.123429] perf_event_intel: PEBS disabled due to CPU errata, 
> please upgrade microcode
> [    0.123535] ... version:                3
> [    0.123607] ... bit width:              48
> [    0.123680] ... generic registers:      4
> [    0.123752] ... value mask:             0000ffffffffffff
> [    0.123827] ... max period:             000000007fffffff
> [    0.123902] ... fixed-purpose events:   3
> [    0.123975] ... event mask:             000000070000000f
> [    0.124217] smpboot: Booting Node   0, Processors  #1 #2 #3 OK
> [    0.164119] Brought up 4 CPUs
> [    0.164196] smpboot: Total of 4 processors activated (18358.05 
> BogoMIPS)
> [    0.167186] devtmpfs: initialized
> [    0.167382] PM: Registering ACPI NVS region [mem 
> 0x8ad34000-0x8ad5efff] (176128 bytes)
> [    0.167533] RTC time: 16:13:27, date: 08/27/12
> [    0.167640] NET: Registered protocol family 16
> [    0.167774] kworker/u:0 (28) used greatest stack depth: 6536 bytes 
> left
> [    0.167856] kworker/u:0 (29) used greatest stack depth: 5544 bytes 
> left
> [    0.168081] ACPI: bus type pci registered
> [    0.168236] PCI: MMCONFIG for domain 0000 [bus 00-9c] at [mem 
> 0xe0000000-0xe9cfffff] (base 0xe0000000)
> [    0.168345] PCI: MMCONFIG at [mem 0xe0000000-0xe9cfffff] reserved 
> in E820
> [    0.184749] PCI: Using configuration type 1 for base access
> [    0.190640] bio: create slab <bio-0> at 0
> [    0.190938] ACPI: Added _OSI(Module Device)
> [    0.191013] ACPI: Added _OSI(Processor Device)
> [    0.191087] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.191165] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.192359] ACPI: EC: EC description table is found, configuring 
> boot EC
> [    0.196071] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    2.195270] ACPI: SSDT 000000008ad39190 00781 (v01  PmRef Cpu0Cst 
> 00003001 INTL 20100915)
> [    2.195742] ACPI: Dynamic OEM Table Load:
> [    2.195897] ACPI: SSDT           (null) 00781 (v01  PmRef Cpu0Cst 
> 00003001 INTL 20100915)
> [    2.201116] ACPI: SSDT 000000008ad3a710 003A4 (v01  PmRef ApIst 
> 00003000 INTL 20100915)
> [    2.201625] ACPI: Dynamic OEM Table Load:
> [    2.201776] ACPI: SSDT           (null) 003A4 (v01  PmRef ApIst 
> 00003000 INTL 20100915)
> [    2.205988] ACPI: SSDT 000000008ad38d90 00119 (v01  PmRef ApCst 
> 00003000 INTL 20100915)
> [    2.206454] ACPI: Dynamic OEM Table Load:
> [    2.206606] ACPI: SSDT           (null) 00119 (v01  PmRef ApCst 
> 00003000 INTL 20100915)
> [    2.211315] ACPI: Interpreter enabled
> [    2.211390] ACPI: (supports S0 S3 S4 S5)
> [    2.211635] ACPI: Using IOAPIC for interrupt routing
> [    2.219475] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data 
> = 0x62
> [    2.219707] ACPI: No dock devices found.
> [    2.219781] PCI: Using host bridge windows from ACPI; if necessary, 
> use "pci=nocrs" and report a bug
> [    2.220163] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    2.220678] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for 
> domain 0000 [bus 00-9c] only partially covers this bridge
> [    2.220829] PCI host bridge to bus 0000:00
> [    2.220905] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted 
> under domain [bus 00-ff]
> [    2.220907] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    2.220983] pci_bus 0000:00: root bus resource [io 0x0000-0x0cf7]
> [    2.221061] pci_bus 0000:00: root bus resource [io 0x0d00-0xffff]
> [    2.221138] pci_bus 0000:00: root bus resource [mem 
> 0x000a0000-0x000bffff]
> [    2.221216] pci_bus 0000:00: root bus resource [mem 
> 0x8fa00000-0xfeafffff]
> [    2.221294] pci_bus 0000:00: root bus resource [mem 
> 0xfed40000-0xfed44fff]
> [    2.221379] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
> [    2.221416] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
> [    2.221447] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    2.221459] pci 0000:00:01.1: [8086:0105] type 01 class 0x060400
> [    2.221488] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
> [    2.221505] pci 0000:00:02.0: [8086:0126] type 00 class 0x030000
> [    2.221515] pci 0000:00:02.0: reg 10: [mem 0xa0000000-0xa03fffff 
> 64bit]
> [    2.221521] pci 0000:00:02.0: reg 18: [mem 0x90000000-0x9fffffff 
> 64bit pref]
> [    2.221525] pci 0000:00:02.0: reg 20: [io  0x2000-0x203f]
> [    2.221579] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
> [    2.221601] pci 0000:00:16.0: reg 10: [mem 0xa0907100-0xa090710f 
> 64bit]
> [    2.221680] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    2.221708] pci 0000:00:1a.0: [8086:1c2c] type 00 class 0x0c0300
> [    2.221751] pci 0000:00:1a.0: reg 20: [io  0x2120-0x213f]
> [    2.221817] pci 0000:00:1a.7: [8086:1c2d] type 00 class 0x0c0320
> [    2.221837] pci 0000:00:1a.7: reg 10: [mem 0xa0906c00-0xa0906fff]
> [    2.221928] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> [    2.221956] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
> [    2.221970] pci 0000:00:1b.0: reg 10: [mem 0xa0900000-0xa0903fff 
> 64bit]
> [    2.222041] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    2.222064] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
> [    2.222144] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    2.222169] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
> [    2.222249] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    2.222273] pci 0000:00:1c.2: [8086:1c14] type 01 class 0x060400
> [    2.222353] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    2.222383] pci 0000:00:1d.0: [8086:1c27] type 00 class 0x0c0300
> [    2.222430] pci 0000:00:1d.0: reg 20: [io  0x20c0-0x20df]
> [    2.222504] pci 0000:00:1d.7: [8086:1c26] type 00 class 0x0c0320
> [    2.222525] pci 0000:00:1d.7: reg 10: [mem 0xa0906800-0xa0906bff]
> [    2.222617] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    2.222643] pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
> [    2.222765] pci 0000:00:1f.2: [8086:1c01] type 00 class 0x01018f
> [    2.222780] pci 0000:00:1f.2: reg 10: [io  0x2148-0x214f]
> [    2.222788] pci 0000:00:1f.2: reg 14: [io  0x215c-0x215f]
> [    2.222796] pci 0000:00:1f.2: reg 18: [io  0x2140-0x2147]
> [    2.222808] pci 0000:00:1f.2: reg 1c: [io  0x2158-0x215b]
> [    2.222816] pci 0000:00:1f.2: reg 20: [io  0x2060-0x206f]
> [    2.222824] pci 0000:00:1f.2: reg 24: [io  0xffe0-0xffef]
> [    2.222872] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
> [    2.222888] pci 0000:00:1f.3: reg 10: [mem 0xa0907000-0xa09070ff 
> 64bit]
> [    2.222909] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
> [    2.222959] pci_bus 0000:01: busn_res: [bus 01] is inserted under 
> [bus 00-ff]
> [    2.222961] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    2.223040] pci 0000:00:01.0:   bridge window [mem 
> 0xa0800000-0xa08fffff]
> [    2.223062] pci_bus 0000:06: busn_res: [bus 06-9c] is inserted 
> under [bus 00-ff]
> [    2.223065] pci 0000:00:01.1: PCI bridge to [bus 06-9c]
> [    2.223140] pci 0000:00:01.1:   bridge window [io 0x3000-0x3fff]
> [    2.223142] pci 0000:00:01.1:   bridge window [mem 
> 0xa0a00000-0xa4efffff]
> [    2.223145] pci 0000:00:01.1:   bridge window [mem 
> 0xa4f00000-0xa8efffff 64bit pref]
> [    2.223188] pci_bus 0000:02: busn_res: [bus 02] is inserted under 
> [bus 00-ff]
> [    2.223255] pci 0000:02:00.0: [14e4:16b4] type 00 class 0x020000
> [    2.223288] pci 0000:02:00.0: reg 10: [mem 0xa0400000-0xa040ffff 
> 64bit pref]
> [    2.223316] pci 0000:02:00.0: reg 18: [mem 0xa0410000-0xa041ffff 
> 64bit pref]
> [    2.223468] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
> [    2.223540] pci 0000:02:00.1: [14e4:16bc] type 00 class 0x080501
> [    2.223573] pci 0000:02:00.1: reg 10: [mem 0xa0420000-0xa042ffff 
> 64bit pref]
> [    2.223753] pci 0000:02:00.1: PME# supported from D0 D3hot D3cold
> [    2.225875] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    2.225980] pci 0000:00:1c.0:   bridge window [mem 
> 0xa0700000-0xa07fffff]
> [    2.225986] pci 0000:00:1c.0:   bridge window [mem 
> 0xa0400000-0xa04fffff 64bit pref]
> [    2.226034] pci_bus 0000:03: busn_res: [bus 03] is inserted under 
> [bus 00-ff]
> [    2.226103] pci 0000:03:00.0: [14e4:4331] type 00 class 0x028000
> [    2.226149] pci 0000:03:00.0: reg 10: [mem 0xa0600000-0xa0603fff 
> 64bit]
> [    2.226417] pci 0000:03:00.0: supports D1 D2
> [    2.226419] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> [    2.227841] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    2.227953] pci 0000:00:1c.1:   bridge window [mem 
> 0xa0600000-0xa06fffff]
> [    2.228002] pci_bus 0000:04: busn_res: [bus 04-05] is inserted 
> under [bus 00-ff]
> [    2.228039] pci 0000:04:00.0: [104c:823e] type 01 class 0x060400
> [    2.228223] pci 0000:04:00.0: supports D1 D2
> [    2.229828] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
> [    2.229945] pci 0000:00:1c.2:   bridge window [mem 
> 0xa0500000-0xa05fffff]
> [    2.230062] pci_bus 0000:05: busn_res: [bus 05] is inserted under 
> [bus 04-05]
> [    2.230086] pci 0000:05:00.0: [104c:823f] type 00 class 0x0c0010
> [    2.230119] pci 0000:05:00.0: reg 10: [mem 0xa0504000-0xa05047ff]
> [    2.230140] pci 0000:05:00.0: reg 14: [mem 0xa0500000-0xa0503fff]
> [    2.230297] pci 0000:05:00.0: supports D1 D2
> [    2.230299] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot
> [    2.230399] pci 0000:04:00.0: PCI bridge to [bus 05]
> [    2.230490] pci 0000:04:00.0:   bridge window [mem 
> 0xa0500000-0xa05fffff]
> [    2.230532] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    2.230614] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
> [    2.230646] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
> [    2.230684] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
> [    2.230714] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
> [    2.230740] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
> [    2.230830]  pci0000:00: Requesting ACPI _OSC control (0x1d)
> [    2.230974]  pci0000:00: ACPI _OSC control (0x1d) granted
> [    2.234433] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 
> 14 15) *11
> [    2.235086] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 
> 12 14 15)
> [    2.235673] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 
> 14 15) *11
> [    2.236332] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 
> 12 14 15)
> [    2.236920] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 
> 14 15) *0, disabled.
> [    2.237613] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 
> 14 15) *10
> [    2.238263] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 
> 14 15) *11
> [    2.238914] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 
> 12 14 15)
> [    2.239591] vgaarb: device added: 
> PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    2.239702] vgaarb: loaded
> [    2.239773] vgaarb: bridge control possible 0000:00:02.0
> [    2.239950] SCSI subsystem initialized
> [    2.240026] ACPI: bus type scsi registered
> [    2.240170] libata version 3.00 loaded.
> [    2.240255] ACPI: bus type usb registered
> [    2.240375] usbcore: registered new interface driver usbfs
> [    2.240477] usbcore: registered new interface driver hub
> [    2.240583] usbcore: registered new device driver usb
> [    2.240827] Advanced Linux Sound Architecture Driver Version 1.0.25.
> [    2.240905] PCI: Using ACPI for IRQ routing
> [    2.242412] PCI: pci_cache_line_size set to 64 bytes
> [    2.242581] e820: reserve RAM buffer [mem 0x0008f000-0x0008ffff]
> [    2.242582] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    2.242584] e820: reserve RAM buffer [mem 0x8ad34000-0x8bffffff]
> [    2.242586] e820: reserve RAM buffer [mem 0x26fe00000-0x26fffffff]
> [    2.242804] cfg80211: Calling CRDA to update world regulatory domain
> [    2.242916] NetLabel: Initializing
> [    2.242991] NetLabel:  domain hash size = 128
> [    2.243065] NetLabel:  protocols = UNLABELED CIPSOv4
> [    2.243156] NetLabel:  unlabeled traffic allowed by default
> [    2.243308] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    2.243744] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    2.245835] Switching to clocksource hpet
> [    2.248152] pnp: PnP ACPI init
> [    2.248232] ACPI: bus type pnp registered
> [    2.248570] pnp 00:00: [bus 00-ff]
> [    2.248573] pnp 00:00: [io  0x0000-0x0cf7 window]
> [    2.248574] pnp 00:00: [io  0x0cf8-0x0cff]
> [    2.248576] pnp 00:00: [io  0x0d00-0xffff window]
> [    2.248578] pnp 00:00: [mem 0x000a0000-0x000bffff window]
> [    2.248580] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
> [    2.248581] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
> [    2.248583] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
> [    2.248584] pnp 00:00: [mem 0x000cc000-0x000cffff window]
> [    2.248586] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
> [    2.248587] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
> [    2.248589] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
> [    2.248591] pnp 00:00: [mem 0x000dc000-0x000dffff window]
> [    2.248592] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
> [    2.248594] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
> [    2.248595] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
> [    2.248597] pnp 00:00: [mem 0x000ec000-0x000effff window]
> [    2.248598] pnp 00:00: [mem 0x000f0000-0x000fffff window]
> [    2.248600] pnp 00:00: [mem 0x8fa00000-0xfeafffff window]
> [    2.248602] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
> [    2.248683] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 
> PNP0a03 (active)
> [    2.248754] pnp 00:01: [io  0x0000-0x001f]
> [    2.248756] pnp 00:01: [io  0x0081-0x0091]
> [    2.248757] pnp 00:01: [io  0x0093-0x009f]
> [    2.248758] pnp 00:01: [io  0x00c0-0x00df]
> [    2.248760] pnp 00:01: [dma 4]
> [    2.248811] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
> [    2.248819] pnp 00:02: [mem 0xff000000-0xffffffff]
> [    2.248864] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
> [    2.248929] pnp 00:03: [irq 0 disabled]
> [    2.248938] pnp 00:03: [irq 8]
> [    2.248939] pnp 00:03: [mem 0xfed00000-0xfed003ff]
> [    2.249002] system 00:03: [mem 0xfed00000-0xfed003ff] has been 
> reserved
> [    2.249081] system 00:03: Plug and Play ACPI device, IDs PNP0103 
> PNP0c01 (active)
> [    2.249090] pnp 00:04: [io  0x00f0]
> [    2.249095] pnp 00:04: [irq 13]
> [    2.249144] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    2.249152] pnp 00:05: [io  0x002e-0x002f]
> [    2.249154] pnp 00:05: [io  0x004e-0x004f]
> [    2.249155] pnp 00:05: [io  0x0061]
> [    2.249157] pnp 00:05: [io  0x0063]
> [    2.249158] pnp 00:05: [io  0x0065]
> [    2.249160] pnp 00:05: [io  0x0067]
> [    2.249161] pnp 00:05: [io  0x0080]
> [    2.249162] pnp 00:05: [io  0x0092]
> [    2.249165] pnp 00:05: [io  0x00b2-0x00b3]
> [    2.249167] pnp 00:05: [io  0x1000-0x100f]
> [    2.249168] pnp 00:05: [io  0x0400-0x047f]
> [    2.249170] pnp 00:05: [io  0x0500-0x057f]
> [    2.249228] system 00:05: [io  0x1000-0x100f] has been reserved
> [    2.249314] system 00:05: [io  0x0400-0x047f] has been reserved
> [    2.249391] system 00:05: [io  0x0500-0x057f] has been reserved
> [    2.249469] system 00:05: Plug and Play ACPI device, IDs PNP0c02 
> (active)
> [    2.249476] pnp 00:06: [io  0x0070-0x0077]
> [    2.249522] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    2.249531] pnp 00:07: [io  0x0300-0x031f]
> [    2.249537] pnp 00:07: [irq 6]
> [    2.249583] pnp 00:07: Plug and Play ACPI device, IDs APP0001 (active)
> [    2.249593] pnp 00:08: [io  0x0700-0x07fe]
> [    2.249644] pnp 00:08: Plug and Play ACPI device, IDs APP000b (active)
> [    2.249763] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
> [    2.249765] pnp 00:09: [mem 0xfed10000-0xfed17fff]
> [    2.249767] pnp 00:09: [mem 0xfed18000-0xfed18fff]
> [    2.249768] pnp 00:09: [mem 0xfed19000-0xfed19fff]
> [    2.249770] pnp 00:09: [mem 0xe0000000-0xefffffff]
> [    2.249771] pnp 00:09: [mem 0xfed20000-0xfed3ffff]
> [    2.249773] pnp 00:09: [mem 0xfed90000-0xfed93fff]
> [    2.249774] pnp 00:09: [mem 0xfed45000-0xfed8ffff]
> [    2.249775] pnp 00:09: [mem 0xff000000-0xffffffff]
> [    2.249777] pnp 00:09: [mem 0xfee00000-0xfeefffff]
> [    2.249779] pnp 00:09: [mem 0x00000000-0xffffffffffffffff disabled]
> [    2.249843] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been 
> reserved
> [    2.249921] system 00:09: [mem 0xfed10000-0xfed17fff] could not be 
> reserved
> [    2.249999] system 00:09: [mem 0xfed18000-0xfed18fff] has been 
> reserved
> [    2.250077] system 00:09: [mem 0xfed19000-0xfed19fff] has been 
> reserved
> [    2.250155] system 00:09: [mem 0xe0000000-0xefffffff] has been 
> reserved
> [    2.250232] system 00:09: [mem 0xfed20000-0xfed3ffff] has been 
> reserved
> [    2.250318] system 00:09: [mem 0xfed90000-0xfed93fff] has been 
> reserved
> [    2.250395] system 00:09: [mem 0xfed45000-0xfed8ffff] has been 
> reserved
> [    2.250473] system 00:09: [mem 0xff000000-0xffffffff] could not be 
> reserved
> [    2.250552] system 00:09: [mem 0xfee00000-0xfeefffff] could not be 
> reserved
> [    2.250630] system 00:09: Plug and Play ACPI device, IDs PNP0c02 
> (active)
> [    2.250755] pnp 00:0a: [mem 0x20000000-0x201fffff]
> [    2.250757] pnp 00:0a: [mem 0x40000000-0x401fffff]
> [    2.250825] system 00:0a: [mem 0x20000000-0x201fffff] has been 
> reserved
> [    2.250903] system 00:0a: [mem 0x40000000-0x401fffff] has been 
> reserved
> [    2.250981] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 
> (active)
> [    2.250988] pnp: PnP ACPI: found 11 devices
> [    2.251061] ACPI: ACPI bus type pnp unregistered
> [    2.259213] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    2.259301] pci 0000:00:01.0:   bridge window [mem 
> 0xa0800000-0xa08fffff]
> [    2.259381] pci 0000:00:01.1: PCI bridge to [bus 06-9c]
> [    2.259457] pci 0000:00:01.1:   bridge window [io 0x3000-0x3fff]
> [    2.259534] pci 0000:00:01.1:   bridge window [mem 
> 0xa0a00000-0xa4efffff]
> [    2.259614] pci 0000:00:01.1:   bridge window [mem 
> 0xa4f00000-0xa8efffff 64bit pref]
> [    2.259721] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    2.259799] pci 0000:00:1c.0:   bridge window [mem 
> 0xa0700000-0xa07fffff]
> [    2.259878] pci 0000:00:1c.0:   bridge window [mem 
> 0xa0400000-0xa04fffff 64bit pref]
> [    2.259987] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    2.260065] pci 0000:00:1c.1:   bridge window [mem 
> 0xa0600000-0xa06fffff]
> [    2.260151] pci 0000:04:00.0: PCI bridge to [bus 05]
> [    2.260233] pci 0000:04:00.0:   bridge window [mem 
> 0xa0500000-0xa05fffff]
> [    2.260332] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
> [    2.260410] pci 0000:00:1c.2:   bridge window [mem 
> 0xa0500000-0xa05fffff]
> [    2.260496] pci 0000:00:01.0: enabling device (0000 -> 0002)
> [    2.260607] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    2.260609] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    2.260611] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    2.260613] pci_bus 0000:00: resource 7 [mem 0x8fa00000-0xfeafffff]
> [    2.260614] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
> [    2.260616] pci_bus 0000:01: resource 1 [mem 0xa0800000-0xa08fffff]
> [    2.260618] pci_bus 0000:06: resource 0 [io  0x3000-0x3fff]
> [    2.260619] pci_bus 0000:06: resource 1 [mem 0xa0a00000-0xa4efffff]
> [    2.260621] pci_bus 0000:06: resource 2 [mem 0xa4f00000-0xa8efffff 
> 64bit pref]
> [    2.260623] pci_bus 0000:02: resource 1 [mem 0xa0700000-0xa07fffff]
> [    2.260625] pci_bus 0000:02: resource 2 [mem 0xa0400000-0xa04fffff 
> 64bit pref]
> [    2.260627] pci_bus 0000:03: resource 1 [mem 0xa0600000-0xa06fffff]
> [    2.260629] pci_bus 0000:04: resource 1 [mem 0xa0500000-0xa05fffff]
> [    2.260630] pci_bus 0000:05: resource 1 [mem 0xa0500000-0xa05fffff]
> [    2.260655] NET: Registered protocol family 2
> [    2.261300] TCP established hash table entries: 524288 (order: 11, 
> 8388608 bytes)
> [    2.262626] TCP bind hash table entries: 65536 (order: 8, 1048576 
> bytes)
> [    2.262833] TCP: Hash tables configured (established 524288 bind 
> 65536)
> [    2.262923] TCP: reno registered
> [    2.263003] UDP hash table entries: 4096 (order: 5, 131072 bytes)
> [    2.263109] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
> [    2.263273] NET: Registered protocol family 1
> [    2.263418] RPC: Registered named UNIX socket transport module.
> [    2.263495] RPC: Registered udp transport module.
> [    2.263569] RPC: Registered tcp transport module.
> [    2.263643] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    2.263736] pci 0000:00:02.0: Boot video device
> [    2.263760] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0080
> [    2.263761] pci 0000:00:1a.0: Performing full reset
> [    2.263935] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0080
> [    2.263936] pci 0000:00:1d.0: Performing full reset
> [    2.264160] PCI: CLS mismatch (256 != 64), using 64 bytes
> [    2.264200] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    2.264294] software IO TLB [mem 0x86d29000-0x8ad28fff] (64MB) 
> mapped at [ffff880086d29000-ffff88008ad28fff]
> [    2.265018] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x1a
> [    2.265098] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x1a
> [    2.265179] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x1a
> [    2.265265] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x1a
> [    2.265396] microcode: Microcode Update Driver: v2.00 
> <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    2.265714] audit: initializing netlink socket (disabled)
> [    2.265795] type=2000 audit(1346084009.161:1): initialized
> [    2.286766] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    2.289578] VFS: Disk quotas dquot_6.5.2
> [    2.289713] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    2.290644] NFS: Registering the id_resolver key type
> [    2.290727] Key type id_resolver registered
> [    2.290800] Key type id_legacy registered
> [    2.290937] msgmni has been set to 15790
> [    2.291083] SELinux:  Registering netfilter hooks
> [    2.291459] Block layer SCSI generic (bsg) driver version 0.4 
> loaded (major 253)
> [    2.291565] io scheduler noop registered
> [    2.292133] io scheduler deadline registered
> [    2.292263] io scheduler cfq registered (default)
> [    2.292437] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
> [    2.292547] pcieport 0000:00:01.1: irq 41 for MSI/MSI-X
> [    2.292681] pcieport 0000:00:1c.0: irq 42 for MSI/MSI-X
> [    2.292803] pcieport 0000:00:1c.1: irq 43 for MSI/MSI-X
> [    2.292929] pcieport 0000:00:1c.2: irq 44 for MSI/MSI-X
> [    2.293077] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    2.293344] input: Power Button as 
> /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
> [    2.293453] ACPI: Power Button [PWRB]
> [    2.293578] input: Sleep Button as 
> /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
> [    2.293686] ACPI: Sleep Button [SLPB]
> [    2.293808] input: Power Button as 
> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> [    2.293914] ACPI: Power Button [PWRF]
> [    2.294084] ACPI: Requesting acpi_cpufreq
> [    2.296175] Monitor-Mwait will be used to enter C-1 state
> [    2.296203] Monitor-Mwait will be used to enter C-2 state
> [    2.296234] Monitor-Mwait will be used to enter C-3 state
> [    2.296249] ACPI: acpi_idle registered with cpuidle
> [    2.300198] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    2.300895] Non-volatile memory driver v1.3
> [    2.300971] Linux agpgart interface v0.103
> [    2.301174] [drm] Initialized drm 1.1.0 20060810
> [    2.302841] brd: module loaded
> [    2.303781] loop: module loaded
> [    2.304078] ata_piix 0000:00:1f.2: version 2.13
> [    2.304092] ata_piix 0000:00:1f.2: MAP [
> [    2.304165]  P0 P2 P1 P3 ]
> [    2.455212] ata_piix 0000:00:1f.2: setting latency timer to 64
> [    2.455616] scsi0 : ata_piix
> [    2.455862] scsi1 : ata_piix
> [    2.456073] ata1: SATA max UDMA/133 cmd 0x2148 ctl 0x215c bmdma 
> 0x2060 irq 19
> [    2.456164] ata2: SATA max UDMA/133 cmd 0x2140 ctl 0x2158 bmdma 
> 0x2068 irq 19
> [    2.456433] tg3.c:v3.124 (March 21, 2012)
> [    2.475283] tg3 0000:02:00.0: eth0: Tigon3 [partno(BCM957765) rev 
> 57785100] (PCI Express) MAC address 3c:07:54:6f:0e:4c
> [    2.475396] tg3 0000:02:00.0: eth0: attached PHY is 57765 
> (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
> [    2.475506] tg3 0000:02:00.0: eth0: RXcsums[1] LinkChgREG[0] 
> MIirq[0] ASF[0] TSOcap[1]
> [    2.475612] tg3 0000:02:00.0: eth0: dma_rwctrl[00000001] 
> dma_mask[64-bit]
> [    2.475844] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
> [    2.475920] e100: Copyright(c) 1999-2006 Intel Corporation
> [    2.476031] e1000: Intel(R) PRO/1000 Network Driver - version 
> 7.3.21-k8-NAPI
> [    2.476109] e1000: Copyright (c) 1999-2006 Intel Corporation.
> [    2.476230] sky2: driver version 1.30
> [    2.476537] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    2.476615] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
> [    2.476639] ehci_hcd 0000:00:1a.7: setting latency timer to 64
> [    2.476642] ehci_hcd 0000:00:1a.7: EHCI Host Controller
> [    2.476773] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned 
> bus number 1
> [    2.476883] ehci_hcd 0000:00:1a.7: reset hcs_params 0x203206 dbg=2 
> cc=3 pcc=2 ordered !ppc ports=6
> [    2.476886] ehci_hcd 0000:00:1a.7: reset hcc_params 36881 caching 
> frame 1024 64 bit addr
> [    2.476896] ehci_hcd 0000:00:1a.7: support lpm
> [    2.476903] ehci_hcd 0000:00:1a.7: reset command 0080012 (park)=0 
> ithresh=8 Periodic period=1024 Reset HALT
> [    2.480779] ehci_hcd 0000:00:1a.7: debug port 2
> [    2.480859] ehci_hcd 0000:00:1a.7: cache line size of 64 is not 
> supported
> [    2.480860] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
> [    2.480876] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xa0906c00
> [    2.480954] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 
> ithresh=1 period=1024 RUN
> [    2.486147] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
> [    2.486276] usb usb1: default language 0x0409
> [    2.486281] usb usb1: udev 1, busnum 1, minor = 0
> [    2.486283] usb usb1: New USB device found, idVendor=1d6b, 
> idProduct=0002
> [    2.486361] usb usb1: New USB device strings: Mfr=3, Product=2, 
> SerialNumber=1
> [    2.486466] usb usb1: Product: EHCI Host Controller
> [    2.486541] usb usb1: Manufacturer: Linux 3.6.0-rc3-next-20120824 
> ehci_hcd
> [    2.486619] usb usb1: SerialNumber: 0000:00:1a.7
> [    2.486781] usb usb1: usb_probe_device
> [    2.486784] usb usb1: configuration #1 chosen from 1 choice
> [    2.486790] usb usb1: adding 1-0:1.0 (config #1, interface 0)
> [    2.486831] hub 1-0:1.0: usb_probe_interface
> [    2.486833] hub 1-0:1.0: usb_probe_interface - got id
> [    2.486835] hub 1-0:1.0: USB hub found
> [    2.486909] hub 1-0:1.0: 6 ports detected
> [    2.486983] hub 1-0:1.0: standalone hub
> [    2.486985] hub 1-0:1.0: no power switching (usb 1.0)
> [    2.486986] hub 1-0:1.0: individual port over-current protection
> [    2.486987] hub 1-0:1.0: power on to power good time: 20ms
> [    2.486990] hub 1-0:1.0: local power source is good
> [    2.486992] hub 1-0:1.0: trying to enable port power on 
> non-switchable hub
> [    2.487048] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    2.487051] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    2.487189] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
> bus number 2
> [    2.487299] ehci_hcd 0000:00:1d.7: reset hcs_params 0x204208 dbg=2 
> cc=4 pcc=2 ordered !ppc ports=8
> [    2.487302] ehci_hcd 0000:00:1d.7: reset hcc_params 36881 caching 
> frame 1024 64 bit addr
> [    2.487311] ehci_hcd 0000:00:1d.7: support lpm
> [    2.487316] ehci_hcd 0000:00:1d.7: reset command 0080012 (park)=0 
> ithresh=8 Periodic period=1024 Reset HALT
> [    2.491211] ehci_hcd 0000:00:1d.7: debug port 2
> [    2.491291] ehci_hcd 0000:00:1d.7: cache line size of 64 is not 
> supported
> [    2.491293] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
> [    2.491304] ehci_hcd 0000:00:1d.7: irq 22, io mem 0xa0906800
> [    2.491383] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 
> ithresh=1 period=1024 RUN
> [    2.497144] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    2.497272] usb usb2: default language 0x0409
> [    2.497277] usb usb2: udev 1, busnum 2, minor = 128
> [    2.497279] usb usb2: New USB device found, idVendor=1d6b, 
> idProduct=0002
> [    2.497357] usb usb2: New USB device strings: Mfr=3, Product=2, 
> SerialNumber=1
> [    2.497461] usb usb2: Product: EHCI Host Controller
> [    2.497536] usb usb2: Manufacturer: Linux 3.6.0-rc3-next-20120824 
> ehci_hcd
> [    2.497614] usb usb2: SerialNumber: 0000:00:1d.7
> [    2.497769] usb usb2: usb_probe_device
> [    2.497771] usb usb2: configuration #1 chosen from 1 choice
> [    2.497777] usb usb2: adding 2-0:1.0 (config #1, interface 0)
> [    2.497816] hub 2-0:1.0: usb_probe_interface
> [    2.497817] hub 2-0:1.0: usb_probe_interface - got id
> [    2.497818] hub 2-0:1.0: USB hub found
> [    2.497893] hub 2-0:1.0: 8 ports detected
> [    2.497967] hub 2-0:1.0: standalone hub
> [    2.497968] hub 2-0:1.0: no power switching (usb 1.0)
> [    2.497969] hub 2-0:1.0: individual port over-current protection
> [    2.497970] hub 2-0:1.0: power on to power good time: 20ms
> [    2.497973] hub 2-0:1.0: local power source is good
> [    2.497975] hub 2-0:1.0: trying to enable port power on 
> non-switchable hub
> [    2.498049] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    2.498136] ohci_hcd: block sizes: ed 80 td 96
> [    2.498173] uhci_hcd: USB Universal Host Controller Interface driver
> [    2.498271] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [    2.498274] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    2.498402] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned 
> bus number 3
> [    2.498512] uhci_hcd 0000:00:1a.0: detected 2 ports
> [    2.498589] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 
> 0x0000
> [    2.498590] uhci_hcd 0000:00:1a.0: Performing full reset
> [    2.498616] uhci_hcd 0000:00:1a.0: irq 21, io base 0x00002120
> [    2.498714] usb usb3: default language 0x0409
> [    2.498719] usb usb3: udev 1, busnum 3, minor = 256
> [    2.498721] usb usb3: New USB device found, idVendor=1d6b, 
> idProduct=0001
> [    2.498799] usb usb3: New USB device strings: Mfr=3, Product=2, 
> SerialNumber=1
> [    2.498903] usb usb3: Product: UHCI Host Controller
> [    2.498978] usb usb3: Manufacturer: Linux 3.6.0-rc3-next-20120824 
> uhci_hcd
> [    2.499056] usb usb3: SerialNumber: 0000:00:1a.0
> [    2.499208] usb usb3: usb_probe_device
> [    2.499210] usb usb3: configuration #1 chosen from 1 choice
> [    2.499215] usb usb3: adding 3-0:1.0 (config #1, interface 0)
> [    2.499254] hub 3-0:1.0: usb_probe_interface
> [    2.499256] hub 3-0:1.0: usb_probe_interface - got id
> [    2.499257] hub 3-0:1.0: USB hub found
> [    2.499332] hub 3-0:1.0: 2 ports detected
> [    2.499406] hub 3-0:1.0: standalone hub
> [    2.499407] hub 3-0:1.0: no power switching (usb 1.0)
> [    2.499408] hub 3-0:1.0: individual port over-current protection
> [    2.499410] hub 3-0:1.0: power on to power good time: 2ms
> [    2.499412] hub 3-0:1.0: local power source is good
> [    2.499414] hub 3-0:1.0: trying to enable port power on 
> non-switchable hub
> [    2.499437] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
> [    2.499454] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    2.499457] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    2.499582] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
> bus number 4
> [    2.499692] uhci_hcd 0000:00:1d.0: detected 2 ports
> [    2.499769] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 
> 0x0000
> [    2.499770] uhci_hcd 0000:00:1d.0: Performing full reset
> [    2.499787] uhci_hcd 0000:00:1d.0: irq 19, io base 0x000020c0
> [    2.499883] usb usb4: default language 0x0409
> [    2.499887] usb usb4: udev 1, busnum 4, minor = 384
> [    2.499889] usb usb4: New USB device found, idVendor=1d6b, 
> idProduct=0001
> [    2.499967] usb usb4: New USB device strings: Mfr=3, Product=2, 
> SerialNumber=1
> [    2.500072] usb usb4: Product: UHCI Host Controller
> [    2.500166] usb usb4: Manufacturer: Linux 3.6.0-rc3-next-20120824 
> uhci_hcd
> [    2.500245] usb usb4: SerialNumber: 0000:00:1d.0
> [    2.500388] usb usb4: usb_probe_device
> [    2.500390] usb usb4: configuration #1 chosen from 1 choice
> [    2.500394] usb usb4: adding 4-0:1.0 (config #1, interface 0)
> [    2.500432] hub 4-0:1.0: usb_probe_interface
> [    2.500433] hub 4-0:1.0: usb_probe_interface - got id
> [    2.500435] hub 4-0:1.0: USB hub found
> [    2.500510] hub 4-0:1.0: 2 ports detected
> [    2.500583] hub 4-0:1.0: standalone hub
> [    2.500584] hub 4-0:1.0: no power switching (usb 1.0)
> [    2.500586] hub 4-0:1.0: individual port over-current protection
> [    2.500587] hub 4-0:1.0: power on to power good time: 2ms
> [    2.500590] hub 4-0:1.0: local power source is good
> [    2.500591] hub 4-0:1.0: trying to enable port power on 
> non-switchable hub
> [    2.500616] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
> [    2.500653] Initializing USB Mass Storage driver...
> [    2.500772] usbcore: registered new interface driver usb-storage
> [    2.500848] USB Mass Storage support registered.
> [    2.500966] usbcore: registered new interface driver libusual
> [    2.501178] i8042: PNP: No PS/2 controller found. Probing ports 
> directly.
> [    2.502142] i8042: No controller found
> [    2.502267] mousedev: PS/2 mouse device common for all mice
> [    2.502588] rtc_cmos 00:06: RTC can wake from S4
> [    2.502798] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
> [    2.502901] rtc0: alarms up to one month, y3k, 242 bytes nvram, 
> hpet irqs
> [    2.503124] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) 
> initialised: dm-devel@redhat.com
> [    2.503331] cpuidle: using governor ladder
> [    2.503470] cpuidle: using governor menu
> [    2.503544] EFI Variables Facility v0.08 2004-May-17
> [    2.504494] usbcore: registered new interface driver usbhid
> [    2.504570] usbhid: USB HID core driver
> [    2.505257] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
> [    2.586181] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001803 
> 0  ACK POWER sig=j CSC CONNECT
> [    2.586198] hub 1-0:1.0: port 1: status 0501 change 0001
> [    2.597173] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001803 
> 0  ACK POWER sig=j CSC CONNECT
> [    2.597189] hub 2-0:1.0: port 1: status 0501 change 0001
> [    2.599139] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
> [    2.600131] uhci_hcd 0000:00:1d.0: port 1 portsc 0082,00
> [    2.686150] hub 1-0:1.0: state 7 ports 6 chg 0002 evt 0000
> [    2.686187] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
> [    2.737352] ehci_hcd 0000:00:1a.7: port 1 reset complete, port enabled
> [    2.737358] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 
> 0  ACK POWER sig=se0 PE CONNECT
> [    2.788081] usb 1-1: new high-speed USB device number 2 using ehci_hcd
> [    2.839297] ehci_hcd 0000:00:1a.7: port 1 reset complete, port enabled
> [    2.839304] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 
> 0  ACK POWER sig=se0 PE CONNECT
> [    2.902223] ehci_hcd 0000:00:1a.7: set dev address 2 for port 1
> [    2.902235] ehci_hcd 0000:00:1a.7: LPM: no device attached
> [    2.902596] usb 1-1: udev 2, busnum 1, minor = 1
> [    2.902606] usb 1-1: New USB device found, idVendor=0424, 
> idProduct=2513
> [    2.902710] usb 1-1: New USB device strings: Mfr=0, Product=0, 
> SerialNumber=0
> [    2.903108] usb 1-1: usb_probe_device
> [    2.903112] usb 1-1: configuration #1 chosen from 1 choice
> [    2.903374] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
> [    2.903623] hub 1-1:1.0: usb_probe_interface
> [    2.903626] hub 1-1:1.0: usb_probe_interface - got id
> [    2.903628] hub 1-1:1.0: USB hub found
> [    2.903834] hub 1-1:1.0: 3 ports detected
> [    2.903953] hub 1-1:1.0: compound device; port removable status: FRR
> [    2.903955] hub 1-1:1.0: individual port power switching
> [    2.903956] hub 1-1:1.0: individual port over-current protection
> [    2.904125] hub 1-1:1.0: TT per port
> [    2.904128] hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
> [    2.904130] hub 1-1:1.0: power on to power good time: 100ms
> [    2.904424] hub 1-1:1.0: local power source is good
> [    2.904430] hub 1-1:1.0: enabling power on all ports
> [    2.904805] hub 2-0:1.0: state 7 ports 8 chg 0002 evt 0000
> [    2.904818] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
> [    2.955112] ehci_hcd 0000:00:1d.7: port 1 reset complete, port enabled
> [    2.955119] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001005 
> 0  ACK POWER sig=se0 PE CONNECT
> [    3.004169] hub 1-1:1.0: port 1: status 0101 change 0001
> [    3.005952] usb 2-1: new high-speed USB device number 2 using ehci_hcd
> [    3.026624] Netfilter messages via NETLINK v0.30.
> [    3.026711] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [    3.026941] ctnetlink v0.93: registering with nfnetlink.
> [    3.027111] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    3.027211] TCP: cubic registered
> [    3.027283] Initializing XFRM netlink socket
> [    3.027555] NET: Registered protocol family 10
> [    3.027765] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [    3.027874] sit: IPv6 over IPv4 tunneling driver
> [    3.028140] NET: Registered protocol family 17
> [    3.028230] Key type dns_resolver registered
> [    3.028744] PM: Hibernation image not present or could not be loaded.
> [    3.028753] registered taskstats version 1
> [    3.029428]   Magic number: 8:905:237
> [    3.029546] console [netcon0] enabled
> [    3.029618] netconsole: network logging started
> [    3.030266] ALSA device list:
> [    3.030338]   #0: HDA Intel PCH at 0xa0900000 irq 45
> [    3.057058] ehci_hcd 0000:00:1d.7: port 1 reset complete, port enabled
> [    3.057063] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001005 
> 0  ACK POWER sig=se0 PE CONNECT
> [    3.103927] usb 1-1: link qh256-0001/ffff8802650cf600 start 1 [1/0 us]
> [    3.120112] ehci_hcd 0000:00:1d.7: set dev address 2 for port 1
> [    3.120124] ehci_hcd 0000:00:1d.7: LPM: no device attached
> [    3.120439] usb 2-1: udev 2, busnum 2, minor = 129
> [    3.120448] usb 2-1: New USB device found, idVendor=0424, 
> idProduct=2513
> [    3.120543] usb 2-1: New USB device strings: Mfr=0, Product=0, 
> SerialNumber=0
> [    3.120919] usb 2-1: usb_probe_device
> [    3.120923] usb 2-1: configuration #1 chosen from 1 choice
> [    3.121120] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
> [    3.121351] hub 2-1:1.0: usb_probe_interface
> [    3.121354] hub 2-1:1.0: usb_probe_interface - got id
> [    3.121356] hub 2-1:1.0: USB hub found
> [    3.121596] hub 2-1:1.0: 3 ports detected
> [    3.121704] hub 2-1:1.0: compound device; port removable status: FRR
> [    3.121705] hub 2-1:1.0: individual port power switching
> [    3.121707] hub 2-1:1.0: individual port over-current protection
> [    3.121895] hub 2-1:1.0: TT per port
> [    3.121898] hub 2-1:1.0: TT requires at most 8 FS bit times (666 ns)
> [    3.121900] hub 2-1:1.0: power on to power good time: 100ms
> [    3.122221] hub 2-1:1.0: local power source is good
> [    3.122231] hub 2-1:1.0: enabling power on all ports
> [    3.122639] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [    3.122648] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [    3.122655] hub 1-1:1.0: state 7 ports 3 chg 0002 evt 0000
> [    3.122850] hub 1-1:1.0: port 1, status 0101, change 0000, 12 Mb/s
> [    3.134100] hub 1-1:1.0: port 1 not reset yet, waiting 10ms
> [    3.196073] usb 1-1.1: new full-speed USB device number 3 using 
> ehci_hcd
> [    3.207064] hub 1-1:1.0: port 1 not reset yet, waiting 10ms
> [    3.222056] hub 2-1:1.0: port 1: status 0301 change 0001
> [    3.222295] hub 2-1:1.0: port 2: status 0301 change 0001
> [    3.222545] hub 2-1:1.0: port 3: status 0101 change 0001
> [    3.266842] tsc: Refined TSC clocksource calibration: 2294.786 MHz
> [    3.266946] Switching to clocksource tsc
> [    3.280798] usb 1-1.1: ep0 maxpacket = 8
> [    3.282521] usb 1-1.1: default language 0x0409
> [    3.283021] usb 1-1.1: udev 3, busnum 1, minor = 2
> [    3.283031] usb 1-1.1: New USB device found, idVendor=0a5c, 
> idProduct=4500
> [    3.283144] usb 1-1.1: New USB device strings: Mfr=1, Product=2, 
> SerialNumber=0
> [    3.283248] usb 1-1.1: Product: BRCM20702 Hub
> [    3.283318] usb 1-1.1: Manufacturer: Apple Inc.
> [    3.283673] usb 1-1.1: usb_probe_device
> [    3.283677] usb 1-1.1: configuration #1 chosen from 1 choice
> [    3.283907] usb 1-1.1: adding 1-1.1:1.0 (config #1, interface 0)
> [    3.284113] hub 1-1.1:1.0: usb_probe_interface
> [    3.284116] hub 1-1.1:1.0: usb_probe_interface - got id
> [    3.284118] hub 1-1.1:1.0: USB hub found
> [    3.284384] hub 1-1.1:1.0: 3 ports detected
> [    3.284494] hub 1-1.1:1.0: compound device; port removable status: FFF
> [    3.284495] hub 1-1.1:1.0: ganged power switching
> [    3.284496] hub 1-1.1:1.0: global over-current protection
> [    3.284498] hub 1-1.1:1.0: power on to power good time: 100ms
> [    3.285035] hub 1-1.1:1.0: local power source is good
> [    3.285043] hub 1-1.1:1.0: no over-current condition exists
> [    3.285049] hub 1-1.1:1.0: enabling power on all ports
> [    3.285530] hub 1-1:1.0: state 7 ports 3 chg 0000 evt 0002
> [    3.321803] usb 2-1: link qh256-0001/ffff8802650cf780 start 1 [1/0 us]
> [    3.321869] hub 2-1:1.0: state 7 ports 3 chg 000e evt 0000
> [    3.322000] hub 2-1:1.0: port 1, status 0301, change 0000, 1.5 Mb/s
> [    3.332994] hub 2-1:1.0: port 1 not reset yet, waiting 10ms
> [    3.384967] hub 1-1.1:1.0: port 1: status 0101 change 0001
> [    3.385468] hub 1-1.1:1.0: port 2: status 0101 change 0001
> [    3.385969] hub 1-1.1:1.0: port 3: status 0101 change 0001
> [    3.394976] usb 2-1.1: new low-speed USB device number 3 using 
> ehci_hcd
> [    3.406958] hub 2-1:1.0: port 1 not reset yet, waiting 10ms
> [    3.484225] usb 2-1.1: skipped 1 descriptor after interface
> [    3.484672] usb 2-1.1: default language 0x0409
> [    3.485688] usb 1-1.1: link qh128-0601/ffff8802650cf880 start 2 
> [1/2 us]
> [    3.487212] usb 2-1.1: udev 3, busnum 2, minor = 130
> [    3.487223] usb 2-1.1: New USB device found, idVendor=05ac, 
> idProduct=8242
> [    3.487325] usb 2-1.1: New USB device strings: Mfr=1, Product=2, 
> SerialNumber=0
> [    3.487428] usb 2-1.1: Product: IR Receiver
> [    3.487502] usb 2-1.1: Manufacturer: Apple Computer, Inc.
> [    3.487833] usb 2-1.1: usb_probe_device
> [    3.487836] usb 2-1.1: configuration #1 chosen from 1 choice
> [    3.489715] usb 2-1.1: adding 2-1.1:1.0 (config #1, interface 0)
> [    3.489964] usbhid 2-1.1:1.0: usb_probe_interface
> [    3.489968] usbhid 2-1.1:1.0: usb_probe_interface - got id
> [    3.494139] usbhid 2-1.1:1.0: looking for a minor, starting at 96
> [    3.494495] apple 0003:05AC:8242.0001: hiddev0,hidraw0: USB HID 
> v1.11 Device [Apple Computer, Inc. IR Receiver] on 
> usb-0000:00:1d.7-1.1/input0
> [    3.494729] hub 2-1:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
> [    3.505776] hub 2-1:1.0: port 2 not reset yet, waiting 10ms
> [    3.567714] usb 2-1.2: new low-speed USB device number 4 using 
> ehci_hcd
> [    3.580865] hub 2-1:1.0: port 2 not reset yet, waiting 10ms
> [    3.666301] usb 2-1.2: skipped 1 descriptor after interface
> [    3.666312] usb 2-1.2: skipped 1 descriptor after interface
> [    3.667199] usb 2-1.2: default language 0x0409
> [    3.676757] usb 2-1.2: udev 4, busnum 2, minor = 131
> [    3.676768] usb 2-1.2: New USB device found, idVendor=045e, 
> idProduct=00db
> [    3.676868] usb 2-1.2: New USB device strings: Mfr=1, Product=2, 
> SerialNumber=0
> [    3.676972] usb 2-1.2: Product: Natural® Ergonomic Keyboard 4000
> [    3.677049] usb 2-1.2: Manufacturer: Microsoft
> [    3.677422] usb 2-1.2: usb_probe_device
> [    3.677426] usb 2-1.2: configuration #1 chosen from 1 choice
> [    3.678110] usb 2-1.2: adding 2-1.2:1.0 (config #1, interface 0)
> [    3.678334] usbhid 2-1.2:1.0: usb_probe_interface
> [    3.678337] usbhid 2-1.2:1.0: usb_probe_interface - got id
> [    3.685822] input: Microsoft Natural® Ergonomic Keyboard 4000 as 
> /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1.2/2-1.2:1.0/input/input3
> [    3.685943] usb 2-1.2: link qh8-0601/ffff8802650cfb80 start 2 [1/2 us]
> [    3.686145] microsoft 0003:045E:00DB.0002: input,hidraw1: USB HID 
> v1.11 Keyboard [Microsoft Natural® Ergonomic Keyboard 4000] on 
> usb-0000:00:1d.7-1.2/input0
> [    3.686274] usb 2-1.2: adding 2-1.2:1.1 (config #1, interface 1)
> [    3.686334] usbhid 2-1.2:1.1: usb_probe_interface
> [    3.686336] usbhid 2-1.2:1.1: usb_probe_interface - got id
> [    3.697654] input: Microsoft Natural® Ergonomic Keyboard 4000 as 
> /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1.2/2-1.2:1.1/input/input4
> [    3.697778] usb 2-1.2: link qh8-0601/ffff8802650cfc80 start 3 [1/2 us]
> [    3.698205] microsoft 0003:045E:00DB.0003: input,hidraw2: USB HID 
> v1.11 Device [Microsoft Natural® Ergonomic Keyboard 4000] on 
> usb-0000:00:1d.7-1.2/input1
> [    3.698519] hub 2-1:1.0: port 3, status 0101, change 0000, 12 Mb/s
> [    3.709798] hub 2-1:1.0: port 3 not reset yet, waiting 10ms
> [    3.767546] ata2.01: failed to resume link (SControl 0)
> [    3.779208] ata2.00: SATA link down (SStatus 0 SControl 300)
> [    3.779291] ata2.01: SATA link down (SStatus 0 SControl 0)
> [    3.779376] usb 2-1.3: new full-speed USB device number 5 using 
> ehci_hcd
> [    3.779396] ata1.01: failed to resume link (SControl 0)
> [    3.790757] hub 2-1:1.0: port 3 not reset yet, waiting 10ms
> [    3.806519] usb usb3: suspend_rh (auto-stop)
> [    3.806556] usb usb4: suspend_rh (auto-stop)
> [    3.864502] usb 2-1.3: ep0 maxpacket = 8
> [    3.866873] usb 2-1.3: skipped 1 descriptor after interface
> [    3.866884] usb 2-1.3: skipped 1 descriptor after interface
> [    3.867084] usb 2-1.3: default language 0x0409
> [    3.867992] usb 2-1.3: udev 5, busnum 2, minor = 132
> [    3.868002] usb 2-1.3: New USB device found, idVendor=046d, 
> idProduct=c245
> [    3.868111] usb 2-1.3: New USB device strings: Mfr=1, Product=2, 
> SerialNumber=0
> [    3.868214] usb 2-1.3: Product: Gaming Mouse G400
> [    3.868792] usb 2-1.3: Manufacturer: Logitech
> [    3.869109] usb 2-1.3: usb_probe_device
> [    3.869112] usb 2-1.3: configuration #1 chosen from 1 choice
> [    3.869780] usb 2-1.3: adding 2-1.3:1.0 (config #1, interface 0)
> [    3.869954] usbhid 2-1.3:1.0: usb_probe_interface
> [    3.869955] usbhid 2-1.3:1.0: usb_probe_interface - got id
> [    3.871376] input: Logitech Gaming Mouse G400 as 
> /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1.3/2-1.3:1.0/input/input5
> [    3.871920] hid-generic 0003:046D:C245.0004: input,hidraw3: USB HID 
> v1.10 Mouse [Logitech Gaming Mouse G400] on usb-0000:00:1d.7-1.3/input0
> [    3.872047] usb 2-1.3: adding 2-1.3:1.1 (config #1, interface 1)
> [    3.872101] usbhid 2-1.3:1.1: usb_probe_interface
> [    3.872103] usbhid 2-1.3:1.1: usb_probe_interface - got id
> [    3.873705] usbhid 2-1.3:1.1: looking for a minor, starting at 96
> [    3.874106] hid-generic 0003:046D:C245.0005: hiddev0,hidraw4: USB 
> HID v1.10 Device [Logitech Gaming Mouse G400] on 
> usb-0000:00:1d.7-1.3/input1
> [    3.874239] hub 1-1.1:1.0: state 7 ports 3 chg 000e evt 0000
> [    3.874403] hub 1-1.1:1.0: port 1, status 0101, change 0000, 12 Mb/s
> [    3.930629] ata1.00: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    3.930723] ata1.01: SATA link down (SStatus 0 SControl 0)
> [    3.934157] ata1.00: ATA-9: INTEL SSDSC2CT120A3, 300i, max UDMA/133
> [    3.934266] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 
> 0/32)
> [    3.936547] usb 1-1.1.1: new full-speed USB device number 4 using 
> ehci_hcd
> [    3.954145] ata1.00: configured for UDMA/133
> [    3.954441] scsi 0:0:0:0: Direct-Access     ATA      INTEL 
> SSDSC2CT12 300i PQ: 0 ANSI: 5
> [    3.955233] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: 
> (120 GB/111 GiB)
> [    3.955381] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    3.955396] sd 0:0:0:0: [sda] Write Protect is off
> [    3.955397] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 10
> [    3.955409] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
> enabled, supports DPO and FUA
> [    3.957034]  sda: sda1 sda2 sda3 sda4
> [    3.957520] sd 0:0:0:0: [sda] Attached SCSI disk
> [    3.957647] md: Waiting for all devices to be available before 
> autodetect
> [    3.957766] md: If you don't use raid, use raid=noautodetect
> [    3.958021] md: Autodetecting RAID arrays.
> [    3.958133] md: Scanned 0 and added 0 devices.
> [    3.958244] md: autorun ...
> [    3.958353] md: ... autorun DONE.
> [    3.958829] EXT4-fs (sda4): couldn't mount as ext3 due to feature 
> incompatibilities
> [    3.959174] EXT4-fs (sda4): couldn't mount as ext2 due to feature 
> incompatibilities
> [    3.962387] EXT4-fs (sda4): mounted filesystem with ordered data 
> mode. Opts: (null)
> [    3.962539] VFS: Mounted root (ext4 filesystem) readonly on device 
> 8:4.
> [    3.963506] Freeing unused kernel memory: 600k freed
> [    3.963687] Write protecting the kernel read-only data: 12288k
> [    3.966849] Freeing unused kernel memory: 1120k freed
> [    3.971946] Freeing unused kernel memory: 1908k freed
> [    4.010363] usb 1-1.1.1: ep0 maxpacket = 8
> [    4.013335] usb 1-1.1.1: skipped 1 descriptor after interface
> [    4.013412] usb 1-1.1.1: udev 4, busnum 1, minor = 3
> [    4.013462] usb 1-1.1.1: New USB device found, idVendor=05ac, 
> idProduct=820a
> [    4.013575] usb 1-1.1.1: New USB device strings: Mfr=0, Product=0, 
> SerialNumber=0
> [    4.013902] usb 1-1.1.1: usb_probe_device
> [    4.013950] usb 1-1.1.1: configuration #1 chosen from 1 choice
> [    4.014102] usb 1-1.1.1: adding 1-1.1.1:1.0 (config #1, interface 0)
> [    4.014297] usbhid 1-1.1.1:1.0: usb_probe_interface
> [    4.014404] usbhid 1-1.1.1:1.0: usb_probe_interface - got id
> [    4.015734] input: HID 05ac:820a as 
> /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/input/input6
> [    4.015890] usb 1-1.1.1: link qh8-0601/ffff8802650cfb00 start 3 
> [1/2 us]
> [    4.016064] hid-generic 0003:05AC:820A.0006: input,hidraw5: USB HID 
> v1.11 Keyboard [HID 05ac:820a] on usb-0000:00:1a.7-1.1.1/input0
> [    4.016606] hub 1-1.1:1.0: port 2, status 0101, change 0000, 12 Mb/s
> [    4.030312] kbd_mode (1031) used greatest stack depth: 5280 bytes left
> [    4.036584] loadkeys (1032) used greatest stack depth: 5120 bytes left
> [    4.036878] init-early.sh (1024) used greatest stack depth: 4728 
> bytes left
> [    4.078435] usb 1-1.1.2: new full-speed USB device number 5 using 
> ehci_hcd
> [    4.152281] usb 1-1.1.2: ep0 maxpacket = 8
> [    4.154884] usb 1-1.1.2: skipped 1 descriptor after interface
> [    4.154945] usb 1-1.1.2: udev 5, busnum 1, minor = 4
> [    4.155003] usb 1-1.1.2: New USB device found, idVendor=05ac, 
> idProduct=820b
> [    4.155119] usb 1-1.1.2: New USB device strings: Mfr=0, Product=0, 
> SerialNumber=0
> [    4.155414] usb 1-1.1.2: usb_probe_device
> [    4.155455] usb 1-1.1.2: configuration #1 chosen from 1 choice
> [    4.155643] usb 1-1.1.2: adding 1-1.1.2:1.0 (config #1, interface 0)
> [    4.155829] usbhid 1-1.1.2:1.0: usb_probe_interface
> [    4.155870] usbhid 1-1.1.2:1.0: usb_probe_interface - got id
> [    4.157461] input: HID 05ac:820b as 
> /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.2/1-1.1.2:1.0/input/input7
> [    4.157851] hid-generic 0003:05AC:820B.0007: input,hidraw6: USB HID 
> v1.11 Mouse [HID 05ac:820b] on usb-0000:00:1a.7-1.1.2/input0
> [    4.158256] hub 1-1.1:1.0: port 3, status 0101, change 0000, 12 Mb/s
> [    4.220347] usb 1-1.1.3: new full-speed USB device number 6 using 
> ehci_hcd
> [    4.269619] systemd-udevd[1139]: starting version 189
> [    4.269915] start-stop-daem (1137) used greatest stack depth: 4328 
> bytes left
> [    4.296678] usb 1-1.1.3: skipped 1 descriptor after interface
> [    4.296922] usb 1-1.1.3: default language 0x0409
> [    4.297434] usb 1-1.1.3: udev 6, busnum 1, minor = 5
> [    4.297439] usb 1-1.1.3: New USB device found, idVendor=05ac, 
> idProduct=8281
> [    4.297442] usb 1-1.1.3: New USB device strings: Mfr=1, Product=2, 
> SerialNumber=0
> [    4.297445] usb 1-1.1.3: Product: Bluetooth USB Host Controller
> [    4.297448] usb 1-1.1.3: Manufacturer: Apple Inc.
> [    4.297593] usb 1-1.1.3: usb_probe_device
> [    4.297597] usb 1-1.1.3: configuration #1 chosen from 1 choice
> [    4.297691] usb 1-1.1.3: adding 1-1.1.3:1.0 (config #1, interface 0)
> [    4.297750] usb 1-1.1.3: adding 1-1.1.3:1.1 (config #1, interface 1)
> [    4.297779] usb 1-1.1.3: adding 1-1.1.3:1.2 (config #1, interface 2)
> [    4.297806] usb 1-1.1.3: adding 1-1.1.3:1.3 (config #1, interface 3)
> [    4.297833] hub 2-1:1.0: state 7 ports 3 chg 0000 evt 0008
> [    4.297926] hub 1-1.1:1.0: state 7 ports 3 chg 0000 evt 0008
> [    4.314332] bcma: bus0: Found chip with id 0x4331, rev 0x02 and 
> package 0x09
> [    4.314367] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 
> 0x800, rev 0x25, class 0x0)
> [    4.314393] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 
> 0x812, rev 0x1D, class 0x0)
> [    4.314442] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, 
> rev 0x13, class 0x0)
> [    4.316581] pci 0000:00:00.0: Intel Sandybridge Chipset
> [    4.316689] pci 0000:00:00.0: detected gtt size: 2097152K total, 
> 262144K mappable
> [    4.317734] pci 0000:00:00.0: detected 65536K stolen memory
> [    4.317796] i915 0000:00:02.0: setting latency timer to 64
> [    4.364945] bcma: bus0: Bus registered
> [    4.396878] i915 0000:00:02.0: irq 46 for MSI/MSI-X
> [    4.396890] [drm] Supports vblank timestamp caching Rev 1 
> (10.10.2010).
> [    4.396891] [drm] Driver supports precise vblank timestamp query.
> [    4.396975] vgaarb: device changed decodes: 
> PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    4.401954] b43-phy0: Broadcom 4331 WLAN found (core revision 29)
> [    4.402409] b43-phy0: Found PHY: Analog 9, Type 7 (HT), Revision 1
> [    4.402745] Broadcom 43xx driver loaded [ Features: PNL ]
> [    4.444000] ieee80211 phy0: Selected rate control algorithm 
> 'minstrel_ht'
> [    4.444475] Registered led device: b43-phy0::tx
> [    4.444583] Registered led device: b43-phy0::rx
> [    4.444687] Registered led device: b43-phy0::radio
> [    4.452710] Bluetooth: Core ver 2.16
> [    4.452726] NET: Registered protocol family 31
> [    4.452727] Bluetooth: HCI device and connection manager initialized
> [    4.452735] Bluetooth: HCI socket layer initialized
> [    4.452739] Bluetooth: L2CAP socket layer initialized
> [    4.452746] Bluetooth: SCO socket layer initialized
> [    4.453955] btusb 1-1.1.3:1.0: usb_probe_interface
> [    4.453960] btusb 1-1.1.3:1.0: usb_probe_interface - got id
> [    4.454152] btusb 1-1.1.3:1.2: usb_probe_interface
> [    4.454155] btusb 1-1.1.3:1.2: usb_probe_interface - got id
> [    4.454164] btusb 1-1.1.3:1.3: usb_probe_interface
> [    4.454167] btusb 1-1.1.3:1.3: usb_probe_interface - got id
> [    4.454185] usbcore: registered new interface driver btusb
> [    4.454373] usb 1-1.1.3: link qh1-3008/ffff88026362e500 start 0 
> [1/2 us]
> [    4.475260] usb 1-1.1.1: unlink qh8-0601/ffff8802650cfb00 start 3 
> [1/2 us]
> [    4.488133] ehci_hcd 0000:00:1a.7: reused qh ffff8802650cfb00 schedule
> [    4.488145] usb 1-1.1.1: link qh8-0601/ffff8802650cfb00 start 3 
> [1/2 us]
> [    4.489146] [drm:intel_disable_transcoder] *ERROR* failed to 
> disable transcoder 1
> [    4.507214] usb 1-1.1.1: unlink qh8-0601/ffff8802650cfb00 start 3 
> [1/2 us]
> [    4.522768] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [    4.530220] hub 1-1.1:1.0: state 7 ports 3 chg 0000 evt 0006
> [    4.530751] hub 1-1.1:1.0: port 1, status 0100, change 0001, 12 Mb/s
> [    4.530761] usb 1-1.1.1: USB disconnect, device number 4
> [    4.530766] usb 1-1.1.1: unregistering device
> [    4.530771] usb 1-1.1.1: unregistering interface 1-1.1.1:1.0
> [    4.556329] usb 1-1.1.1: usb_disable_device nuking all URBs
> [    4.614105] [drm] GMBUS [i915 gmbus vga] timed out, falling back to 
> bit banging on pin 2
> [    4.669136] hub 1-1.1:1.0: debounce: port 1: total 100ms stable 
> 100ms status 0x100
> [    4.669384] hub 1-1.1:1.0: port 2, status 0100, change 0001, 12 Mb/s
> [    4.669388] usb 1-1.1.2: USB disconnect, device number 5
> [    4.669389] usb 1-1.1.2: unregistering device
> [    4.669392] usb 1-1.1.2: unregistering interface 1-1.1.2:1.0
> [    4.713270] usb 1-1.1.2: usb_disable_device nuking all URBs
> [    4.815542] fbcon: inteldrmfb (fb0) is primary device
> [    4.817230] hub 1-1.1:1.0: debounce: port 2: total 100ms stable 
> 100ms status 0x100
> [    4.817237] hub 1-1.1:1.0: state 7 ports 3 chg 0000 evt 0000
> [    3.955741] ACPI: Invalid Power Resource to register!
> [    5.138954] Console: switching to colour frame buffer device 240x67
> [    5.143838] fb0: inteldrmfb frame buffer device
> [    5.143839] drm: registered panic notifier
> [    5.144679] ACPI: Video Device [IGPU] (multi-head: yes  rom: no 
> post: no)
> [    5.144721] input: Video Bus as 
> /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input8
> [    5.144821] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 
> on minor 0
> [    5.144853] ACPI Warning: 0x000000000000efa0-0x000000000000efbf 
> SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 
> (20120711/utaddress-251)
> [    5.144859] ACPI: If an ACPI driver is available for this device, 
> you should use it instead of the native driver
> [    5.150594] systemd-udevd (1150) used greatest stack depth: 3296 
> bytes left
> [    5.777001] vboxdrv: Found 4 processor cores.
> [    5.777182] vboxdrv: fAsync=0 offMin=0x20f offMax=0x126b
> [    5.777227] vboxdrv: TSC mode is 'synchronous', kernel timer mode 
> is 'normal'.
> [    5.777229] vboxdrv: Successfully loaded version 4.1.20 (interface 
> 0x00190000).
> [    5.838256] EXT4-fs (sda4): re-mounted. Opts: discard
> [    6.468583] usb 2-1.3: link qh1-0601/ffff880265c25e80 start 0 [1/2 us]
> [    6.498242] tg3 0000:02:00.0: irq 47 for MSI/MSI-X
> [    6.498248] tg3 0000:02:00.0: irq 48 for MSI/MSI-X
> [    6.498253] tg3 0000:02:00.0: irq 49 for MSI/MSI-X
> [    6.498258] tg3 0000:02:00.0: irq 50 for MSI/MSI-X
> [    6.498263] tg3 0000:02:00.0: irq 51 for MSI/MSI-X
> [    6.793668] usb 1-1.1.3: unlink qh1-3008/ffff88026362e500 start 0 
> [1/2 us]
> [    6.793689] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [    6.895972] usb 1-1: clear tt buffer port 1, a6 ep2 t04048d82
> [    6.945967] b43-phy0: Loading firmware version 666.2 (2011-02-23 
> 01:15:07)
> [    6.985379] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   10.213293] tg3 0000:02:00.0: eth0: Link is up at 1000 Mbps, full 
> duplex
> [   10.213297] tg3 0000:02:00.0: eth0: Flow control is off for TX and 
> off for RX
> [   10.213298] tg3 0000:02:00.0: eth0: EEE is disabled
> [   10.214309] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   11.035530] sd 0:0:0:0: [sda]
> [   11.035533] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [   11.035535] sd 0:0:0:0: [sda]
> [   11.035536] Sense Key : Illegal Request [current]
> [   11.035539] sd 0:0:0:0: [sda]
> [   11.035541] Add. Sense: Invalid field in cdb
> [   11.035543] sd 0:0:0:0: [sda] CDB:
> [   11.035544] Write(10): 2a 08 0b ad d1 78 00 00 08 00
> [   11.035550] end_request: critical target error, dev sda, sector 
> 195940728
> [   11.035552] end_request: critical target error, dev sda, sector 
> 195940728
> [   11.035557] Aborting journal on device sda4-8.
> [   11.046413] EXT4-fs error (device sda4): ext4_journal_start_sb:348: 
> Detected aborted journal
> [   11.046418] EXT4-fs (sda4): Remounting filesystem read-only
> [   18.737844] tty_init_dev: 26 callbacks suppressed
>
I believe the problem is in SCSI. Mode sense command catches my attention:
     [    3.955397] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 10
All logs from older kernels has different mode page code: 00 3a 00 00

sg_modes from broken kernel shows DPOFUA set, which is 0x10th bit.
Anyone knowing SCSI better could tell if that might cause the problems?

# From broken kernel:
$ sudo sg_modes --all /dev/sda
     ATA       INTEL SSDSC2CT12  300i   peripheral_type: disk [0x0]
Mode parameter header from MODE SENSE(10):
   Mode data length=60, medium type=0x00, WP=0, DpoFua=1, longlba=0
   Block descriptor length=8
 > Direct access device block descriptors:
    Density code=0x0
  00     00 00 00 00 00 00 02 00

 >> Read-Write error recovery, page_control: current
  00     01 0a 80 00 00 00 00 00  00 00 00 00
 >> Caching, page_control: current
  00     08 12 04 00 00 00 00 00  00 00 00 00 00 00 00 00
  10     00 00 00 00
 >> Control, page_control: current
  00     0a 0a 02 00 00 00 00 00  ff ff 00 1e


# From good kernel:
$ sudo sg_modes --all /dev/sda
     ATA       INTEL SSDSC2CT12  300i   peripheral_type: disk [0x0]
Mode parameter header from MODE SENSE(10):
   Mode data length=60, medium type=0x00, WP=0, DpoFua=0, longlba=0
   Block descriptor length=8
 > Direct access device block descriptors:
    Density code=0x0
  00     00 00 00 00 00 00 02 00

 >> Read-Write error recovery, page_control: current
  00     01 0a 80 00 00 00 00 00  00 00 00 00
 >> Caching, page_control: current
  00     08 12 04 00 00 00 00 00  00 00 00 00 00 00 00 00
  10     00 00 00 00
 >> Control, page_control: current
  00     0a 0a 02 00 00 00 00 00  ff ff 00 1e


