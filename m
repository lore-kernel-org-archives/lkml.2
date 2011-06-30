Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab1F3PZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:25:16 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:55494 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab1F3PZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:25:09 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 3.0rc3-rc5: usb stops working after resume from suspend to ram
Date: Thu, 30 Jun 2011 17:25:00 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4-00059-g143e859; KDE/4.6.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.1106291720330.2064-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106291720330.2064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106301725.00791.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 of June 2011, Alan Stern wrote:
> On Wed, 29 Jun 2011, Arkadiusz Miskiewicz wrote:
> > On Wednesday 29 of June 2011, Alan Stern wrote:
> > > On Wed, 29 Jun 2011, Arkadiusz Miskiewicz wrote:
> > > > Hi,
> > > > 
> > > > Something broke between rc3 and rc5. Thinkpad t400, logitech usb
> > > > mouse. After resume from ram usb device no longer works. Somewhere
> > > > around rc3 it was working fine.
> > > 
> > > Obviously you can try bisection to find the problem.  But if you don't
> > > want to go through that, you could post the dmesg from a kernel that
> > > has CONFIG_USB_DEBUG enabled.
> > 
> > CONFIG_USB_DEBUG will be faster but I'll bisect if no one figures out
> > what's wrong.
> 
> Actually bisection might end up being quicker.  This looks like a
> pretty tricky problem.  Maybe you should start a bisection while I look
> at this stuff; you'll probably reach an answer before I do!

Looks tricky indeed. There seem to be two related problems actually. I'm 
bisecting between rc3 (good) and rc5 (bad). 

At 3.0.0-rc4-00059-g143e859 usb auto-suspend suspends my mouse usb port after 
like 4 seconds when I don't move mouse. That's not a problem. The problem is 
that resume takes like 1-2seconds and in that time mouse cursor doesn't move 
when I move mouse of course.

With previous kernel (rc5) the problem become worse as I described in previous 
emails.

So for now I'm bisecting autosuspend issue since maybe it is some indirect 
cause of usb-not-working-at-all in rc5 problem.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0-rc4-00059-g143e859 (arekm@ixion-pld) (gcc 
version 4.6.1 20110627 (release) (PLD-Linux) ) #10 SMP PREEMPT Thu Jun 30 
15:57:48 CEST 2011
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.0.0 
root=/dev/mapper/lrootfs ro resume=/dev/sda2 panic=60 reboot=acpi
[    0.000000] Disabled fast string operations
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd4a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd4a1000 - 00000000bd4a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd4a7000 - 00000000bd5b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd5b7000 - 00000000bd60f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd60f000 - 00000000bd6c6000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6c6000 - 00000000bd6d1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6d1000 - 00000000bd6d4000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd6d4000 - 00000000bd6d8000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6d8000 - 00000000bd6dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6dc000 - 00000000bd6df000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6df000 - 00000000bd706000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd706000 - 00000000bd708000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd708000 - 00000000bd90f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd90f000 - 00000000bd99f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd99f000 - 00000000bd9ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd9ff000 - 00000000bda00000 (usable)
[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: LENOVO 2764CTO/2764CTO, BIOS 7UET91WW (3.21 ) 12/06/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) 
==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] e820 update range: 00000000bde00000 - 0000000100000000 (usable) 
==> (reserved)
[    0.000000] last_pfn = 0xbda00 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f6480] f6480
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bda00000
[    0.000000]  0000000000 - 00bda00000 page 2M
[    0.000000] kernel direct mapping tables up to bda00000 @ bd6c2000-bd6c6000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ 
13bffa000-13c000000
[    0.000000] RAMDISK: 37eb0000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f6440 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bd949b5a 0009C (v01 LENOVO TP-7U    00003210  
LTP 00000000)
[    0.000000] ACPI: FACP 00000000bd949d00 000F4 (v03 LENOVO TP-7U    00003210 
LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bd94a10e 0FAE1 (v01 LENOVO TP-7U    00003210 
MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bd98e000 00040
[    0.000000] ACPI: SSDT 00000000bd949eb4 0025A (v01 LENOVO TP-7U    00003210 
MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bd959bef 00052 (v01 LENOVO TP-7U    00003210 
LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bd959c41 00078 (v01 LENOVO TP-7U    00003210 
LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bd959cb9 0003C (v01 LENOVO TP-7U    00003210 
LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bd959cf5 00038 (v01 LENOVO TP-7U    00003210 
LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bd959dc2 00176 (v01 LENOVO TP-7U    00003210  
LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bd959f38 00028 (v01 LENOVO TP-7U    00003210  
LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bd959f60 000A0 (v16 LENOVO TP-7U    00003210 
PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bd98d1fa 00568 (v01 LENOVO TP-7U    00003210 
INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd707000 00032 (v00                 00000000      
00000000)
[    0.000000] ACPI: DMAR 00000000bd706000 00120 (v01               ? 00000001      
00000000)
[    0.000000] ACPI: SSDT 00000000bd6d3000 00655 (v01  PmRef    CpuPm 00003000 
INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d2000 00274 (v01  PmRef  Cpu0Tst 00003000 
INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d1000 00242 (v01  PmRef    ApTst 00003000 
INTL 20050624)
[    0.000000] ACPI: DMI detected: Lenovo ThinkPad T400
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000013c000000
[    0.000000] Initmem setup node 0 0000000000000000-000000013c000000
[    0.000000]   NODE_DATA [000000013bffb000 - 000000013bffffff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880137600000-
ffff88013adfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd4a1
[    0.000000]     0: 0x000bd4a7 -> 0x000bd5b7
[    0.000000]     0: 0x000bd60f -> 0x000bd6c6
[    0.000000]     0: 0x000bd9ff -> 0x000bda00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1021431
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 757409 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 
000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd4a1000 - 
00000000bd4a7000
[    0.000000] PM: Registered nosave memory: 00000000bd5b7000 - 
00000000bd60f000
[    0.000000] PM: Registered nosave memory: 00000000bd6c6000 - 
00000000bd6d1000
[    0.000000] PM: Registered nosave memory: 00000000bd6d1000 - 
00000000bd6d4000
[    0.000000] PM: Registered nosave memory: 00000000bd6d4000 - 
00000000bd6d8000
[    0.000000] PM: Registered nosave memory: 00000000bd6d8000 - 
00000000bd6dc000
[    0.000000] PM: Registered nosave memory: 00000000bd6dc000 - 
00000000bd6df000
[    0.000000] PM: Registered nosave memory: 00000000bd6df000 - 
00000000bd706000
[    0.000000] PM: Registered nosave memory: 00000000bd706000 - 
00000000bd708000
[    0.000000] PM: Registered nosave memory: 00000000bd708000 - 
00000000bd90f000
[    0.000000] PM: Registered nosave memory: 00000000bd90f000 - 
00000000bd99f000
[    0.000000] PM: Registered nosave memory: 00000000bd99f000 - 
00000000bd9ff000
[    0.000000] PM: Registered nosave memory: 00000000bda00000 - 
00000000bdc00000
[    0.000000] PM: Registered nosave memory: 00000000bdc00000 - 
00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 
00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 
00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 
00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 
00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 
00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 
00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 
00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 
00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 
00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 
00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 
00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 
00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 
00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 
00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: 
c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 
nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88013bc00000 s69760 r8192 
d24448 u1048576
[    0.000000] pcpu-alloc: s69760 r8192 d24448 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total 
pages: 1003730
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.0.0 
root=/dev/mapper/lrootfs ro resume=/dev/sda2 panic=60 reboot=acpi
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3950220k/5177344k available (4132k kernel code, 
1091620k absent, 135504k reserved, 4578k data, 568k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, 
Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want 
memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2526.872 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 5053.74 BogoMIPS (lpj=10107488)
[    0.004119] pid_max: default: 32768 minimum: 301
[    0.004202] Security Framework initialized
[    0.004576] Dentry cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[    0.006713] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.007728] Mount-cache hash table entries: 256
[    0.008135] Initializing cgroup subsys cpuacct
[    0.008197] Initializing cgroup subsys memory
[    0.008261] Initializing cgroup subsys devices
[    0.008315] Initializing cgroup subsys freezer
[    0.008371] Initializing cgroup subsys perf_event
[    0.008454] Disabled fast string operations
[    0.008512] CPU: Physical Processor ID: 0
[    0.008566] CPU: Processor Core ID: 0
[    0.008620] mce: CPU supports 6 MCE banks
[    0.008681] CPU0: Thermal monitoring enabled (TM2)
[    0.008738] using mwait in idle threads.
[    0.008810] ACPI: Core revision 20110413
[    0.020386] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.060134] CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 
06
[    0.064003] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.064003] ... version:                2
[    0.064003] ... bit width:              40
[    0.064003] ... generic registers:      2
[    0.064003] ... value mask:             000000ffffffffff
[    0.064003] ... max period:             000000007fffffff
[    0.064003] ... fixed-purpose events:   3
[    0.064003] ... event mask:             0000000700000003
[    0.088019] Booting Node   0, Processors  #1 Ok.
[    0.088116] smpboot cpu 1: start_ip = 99000
[    0.008000] Disabled fast string operations
[    0.180026] Brought up 2 CPUs
[    0.180138] Total of 2 processors activated (10107.70 BogoMIPS).
[    0.181760] devtmpfs: initialized
[    0.181760] PM: Registering ACPI NVS region at bd6c6000 (45056 bytes)
[    0.181760] PM: Registering ACPI NVS region at bd6d8000 (16384 bytes)
[    0.181760] PM: Registering ACPI NVS region at bd6df000 (159744 bytes)
[    0.181760] PM: Registering ACPI NVS region at bd90f000 (589824 bytes)
[    0.181760] print_constraints: dummy: 
[    0.181760] NET: Registered protocol family 16
[    0.181760] ACPI FADT declares the system doesn't support PCIe ASPM, so 
disable it
[    0.181760] ACPI: bus type pci registered
[    0.181760] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 
0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.181760] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    0.192508] PCI: Using configuration type 1 for base access
[    0.192579] bio: create slab <bio-0> at 0
[    0.192579] ACPI: Added _OSI(Linux)
[    0.197112] ACPI: EC: EC description table is found, configuring boot EC
[    0.203375] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via DMI
[    0.213320] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 
INTL 20050624)
[    0.213871] ACPI: Dynamic OEM Table Load:
[    0.214008] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 
INTL 20050624)
[    0.214297] ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003001 
INTL 20050624)
[    0.214878] ACPI: Dynamic OEM Table Load:
[    0.215014] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 
INTL 20050624)
[    0.240222] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003000 
INTL 20050624)
[    0.240790] ACPI: Dynamic OEM Table Load:
[    0.240926] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 
INTL 20050624)
[    0.252114] ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003000 
INTL 20050624)
[    0.252665] ACPI: Dynamic OEM Table Load:
[    0.252802] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 
INTL 20050624)
[    0.272027] ACPI: Interpreter enabled
[    0.272085] ACPI: (supports S0 S3 S4 S5)
[    0.272316] ACPI: Using IOAPIC for interrupt routing
[    0.284120] ACPI: Power Resource [PUBS] (on)
[    0.300167] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.300338] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.300384] HEST: Table not found.
[    0.300440] PCI: Using host bridge windows from ACPI; if necessary, use 
"pci=nocrs" and report a bug
[    0.300730] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.300822] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.300822] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.300822] pci_root PNP0A08:00: host bridge window [mem 
0x000a0000-0x000bffff]
[    0.300822] pci_root PNP0A08:00: host bridge window [mem 
0x000d0000-0x000d3fff]
[    0.300822] pci_root PNP0A08:00: host bridge window [mem 
0x000d4000-0x000d7fff]
[    0.300822] pci_root PNP0A08:00: host bridge window [mem 
0x000d8000-0x000dbfff]
[    0.300822] pci_root PNP0A08:00: host bridge window [mem 
0xc0000000-0xfebfffff]
[    0.300822] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    0.300822] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    0.300822] pci 0000:00:02.0: reg 10: [mem 0xf4400000-0xf47fffff 64bit]
[    0.300822] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit 
pref]
[    0.300822] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.300822] pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
[    0.300822] pci 0000:00:02.1: reg 10: [mem 0xf4200000-0xf42fffff 64bit]
[    0.300822] pci 0000:00:03.0: [8086:2a44] type 0 class 0x000780
[    0.300822] pci 0000:00:03.0: reg 10: [mem 0xfc226800-0xfc22680f 64bit]
[    0.300822] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.300822] pci 0000:00:03.0: PME# disabled
[    0.300822] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    0.300822] pci 0000:00:19.0: reg 10: [mem 0xfc000000-0xfc01ffff]
[    0.300830] pci 0000:00:19.0: reg 14: [mem 0xfc025000-0xfc025fff]
[    0.300841] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.300908] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.300913] pci 0000:00:19.0: PME# disabled
[    0.300939] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.300994] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.301051] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.301106] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.301162] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    0.301217] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    0.301285] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.301310] pci 0000:00:1a.7: reg 10: [mem 0xfc226c00-0xfc226fff]
[    0.301398] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.301403] pci 0000:00:1a.7: PME# disabled
[    0.301433] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.301454] pci 0000:00:1b.0: reg 10: [mem 0xfc020000-0xfc023fff 64bit]
[    0.301529] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.301533] pci 0000:00:1b.0: PME# disabled
[    0.301561] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.301639] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.301643] pci 0000:00:1c.0: PME# disabled
[    0.301672] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    0.301750] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.301755] pci 0000:00:1c.1: PME# disabled
[    0.301785] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    0.301863] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.301867] pci 0000:00:1c.3: PME# disabled
[    0.301897] pci 0000:00:1c.4: [8086:2948] type 1 class 0x000604
[    0.301975] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.301980] pci 0000:00:1c.4: PME# disabled
[    0.302013] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.302068] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    0.304077] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.304132] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    0.304189] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.304244] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    0.304312] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.304337] pci 0000:00:1d.7: reg 10: [mem 0xfc227000-0xfc2273ff]
[    0.304424] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.304429] pci 0000:00:1d.7: PME# disabled
[    0.304454] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.304538] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    0.304689] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    0.304716] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    0.304726] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    0.304737] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    0.304748] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    0.304759] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.304770] pci 0000:00:1f.2: reg 24: [mem 0xfc226000-0xfc2267ff]
[    0.304818] pci 0000:00:1f.2: PME# supported from D3hot
[    0.304822] pci 0000:00:1f.2: PME# disabled
[    0.304846] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.304867] pci 0000:00:1f.3: reg 10: [mem 0xfc227400-0xfc2274ff 64bit]
[    0.304896] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.304984] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.305045] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] 
(disabled)
[    0.305050] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] 
(disabled)
[    0.305058] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff 
pref] (disabled)
[    0.305175] pci 0000:03:00.0: [8086:423b] type 0 class 0x000280
[    0.305218] pci 0000:03:00.0: reg 10: [mem 0xf4300000-0xf4301fff 64bit]
[    0.305381] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.305392] pci 0000:03:00.0: PME# disabled
[    0.305461] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.305521] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] 
(disabled)
[    0.305526] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
[    0.305533] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff 
pref] (disabled)
[    0.305589] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.305649] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.305654] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.305661] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 
64bit pref]
[    0.305717] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.305778] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.305782] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.305790] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 
64bit pref]
[    0.305835] pci 0000:15:00.0: [1180:0476] type 2 class 0x000607
[    0.305858] pci 0000:15:00.0: proprietary Ricoh MMC controller disabled 
(via cardbus function)
[    0.305930] pci 0000:15:00.0: MMC cards are now supported by standard SDHCI 
controller
[    0.306017] pci 0000:15:00.0: reg 10: [mem 0xf4800000-0xf4800fff]
[    0.306045] pci 0000:15:00.0: supports D1 D2
[    0.306046] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.306052] pci 0000:15:00.0: PME# disabled
[    0.306076] pci 0000:15:00.1: [1180:0832] type 0 class 0x000c00
[    0.306102] pci 0000:15:00.1: reg 10: [mem 0xf4801000-0xf48017ff]
[    0.306201] pci 0000:15:00.1: supports D1 D2
[    0.306203] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.306208] pci 0000:15:00.1: PME# disabled
[    0.306232] pci 0000:15:00.2: [1180:0822] type 0 class 0x000805
[    0.306257] pci 0000:15:00.2: reg 10: [mem 0xf4801800-0xf48018ff]
[    0.306357] pci 0000:15:00.2: supports D1 D2
[    0.306359] pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.306364] pci 0000:15:00.2: PME# disabled
[    0.306391] pci 0000:15:00.4: [1180:0592] type 0 class 0x000880
[    0.306416] pci 0000:15:00.4: reg 10: [mem 0xf4802000-0xf48020ff]
[    0.306515] pci 0000:15:00.4: supports D1 D2
[    0.306517] pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.306522] pci 0000:15:00.4: PME# disabled
[    0.306546] pci 0000:15:00.5: [1180:0852] type 0 class 0x000880
[    0.306571] pci 0000:15:00.5: reg 10: [mem 0xf4802400-0xf48024ff]
[    0.306671] pci 0000:15:00.5: supports D1 D2
[    0.306672] pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
[    0.306678] pci 0000:15:00.5: PME# disabled
[    0.306748] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive 
decode)
[    0.306811] pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
[    0.306816] pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
[    0.306823] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 
64bit pref]
[    0.306826] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] 
(subtractive decode)
[    0.306828] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] 
(subtractive decode)
[    0.306830] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] 
(subtractive decode)
[    0.306833] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] 
(subtractive decode)
[    0.306835] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] 
(subtractive decode)
[    0.306837] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] 
(subtractive decode)
[    0.306840] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] 
(subtractive decode)
[    0.306921] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.307036] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.307066] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.307097] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.307129] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.307161] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.307419]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.307822]  pci0000:00: ACPI _OSC control (0x1d) granted
[    0.312217] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.312604] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.313122] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.313640] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.314158] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.314675] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.316133] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.316651] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.317211] vgaarb: device added: 
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.317211] vgaarb: loaded
[    0.317211] vgaarb: bridge control possible 0000:00:02.0
[    0.317211] PCI: Using ACPI for IRQ routing
[    0.318351] PCI: pci_cache_line_size set to 64 bytes
[    0.320143] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    0.320145] reserve RAM buffer: 00000000bd4a1000 - 00000000bfffffff 
[    0.320150] reserve RAM buffer: 00000000bd5b7000 - 00000000bfffffff 
[    0.320154] reserve RAM buffer: 00000000bd6c6000 - 00000000bfffffff 
[    0.320158] reserve RAM buffer: 00000000bda00000 - 00000000bfffffff 
[    0.320215] NetLabel: Initializing
[    0.320215] NetLabel:  domain hash size = 128
[    0.320215] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.320228] NetLabel:  unlabeled traffic allowed by default
[    0.320290] HPET: 4 timers in total, 0 timers will be used for per-cpu 
timer
[    0.320354] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.320613] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.328092] Switching to clocksource hpet
[    0.329494] pnp: PnP ACPI init
[    0.329504] ACPI: bus type pnp registered
[    0.349759] Switched to NOHz mode on CPU #0
[    0.349761] Switched to NOHz mode on CPU #1
[    0.349920] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.349922] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.349924] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.349925] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.349927] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.349929] pnp 00:00: [mem 0x000d0000-0x000cffff disabled]
[    0.349931] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    0.349933] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    0.349935] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    0.349936] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.349938] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.349940] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.349941] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.349943] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.349945] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    0.349947] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    0.349948] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    0.350033] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.350095] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.350156] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.350216] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.350278] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.350339] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.350399] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.350460] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.350520] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.350581] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.350642] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.350702] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.350763] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.350823] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.350885] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.350903] pnp 00:01: [bus 00-ff]
[    0.350905] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.350907] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.350909] pnp 00:01: [io  0x0d00-0xffff window]
[    0.350911] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.350913] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    0.350915] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    0.350917] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    0.350919] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    0.350921] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    0.350924] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    0.350926] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    0.350928] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    0.350930] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    0.350932] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    0.350934] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    0.350936] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    0.350938] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
[    0.350940] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    0.351014] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 
(active)
[    0.370932] pnp 00:02: [io  0x0010-0x001f]
[    0.370935] pnp 00:02: [io  0x0090-0x009f]
[    0.370936] pnp 00:02: [io  0x0024-0x0025]
[    0.370938] pnp 00:02: [io  0x0028-0x0029]
[    0.370939] pnp 00:02: [io  0x002c-0x002d]
[    0.370941] pnp 00:02: [io  0x0030-0x0031]
[    0.370943] pnp 00:02: [io  0x0034-0x0035]
[    0.370944] pnp 00:02: [io  0x0038-0x0039]
[    0.370946] pnp 00:02: [io  0x003c-0x003d]
[    0.370947] pnp 00:02: [io  0x00a4-0x00a5]
[    0.370949] pnp 00:02: [io  0x00a8-0x00a9]
[    0.370951] pnp 00:02: [io  0x00ac-0x00ad]
[    0.370952] pnp 00:02: [io  0x00b0-0x00b5]
[    0.370954] pnp 00:02: [io  0x00b8-0x00b9]
[    0.370955] pnp 00:02: [io  0x00bc-0x00bd]
[    0.370957] pnp 00:02: [io  0x0050-0x0053]
[    0.370959] pnp 00:02: [io  0x0072-0x0077]
[    0.370960] pnp 00:02: [io  0x002e-0x002f]
[    0.370962] pnp 00:02: [io  0x1000-0x107f]
[    0.370963] pnp 00:02: [io  0x1180-0x11ff]
[    0.370965] pnp 00:02: [io  0x0800-0x080f]
[    0.370967] pnp 00:02: [io  0x15e0-0x15ef]
[    0.370968] pnp 00:02: [io  0x1600-0x167f]
[    0.370970] pnp 00:02: [io  0x1680-0x169f]
[    0.370972] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    0.370974] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    0.370975] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    0.370977] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    0.370979] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    0.370980] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    0.371078] system 00:02: [io  0x1000-0x107f] has been reserved
[    0.371138] system 00:02: [io  0x1180-0x11ff] has been reserved
[    0.371197] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.371256] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.371315] system 00:02: [io  0x1600-0x167f] has been reserved
[    0.371374] system 00:02: [io  0x1680-0x169f] has been reserved
[    0.371434] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    0.371494] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.371554] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.371614] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.371675] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.371735] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.371795] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.371833] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.371884] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.371893] pnp 00:04: [io  0x0000-0x000f]
[    0.371897] pnp 00:04: [io  0x0080-0x008f]
[    0.371899] pnp 00:04: [io  0x00c0-0x00df]
[    0.371901] pnp 00:04: [dma 4]
[    0.371953] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.371962] pnp 00:05: [io  0x0061]
[    0.372036] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.372045] pnp 00:06: [io  0x00f0]
[    0.372051] pnp 00:06: [irq 13]
[    0.372104] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.372113] pnp 00:07: [io  0x0070-0x0071]
[    0.372117] pnp 00:07: [irq 8]
[    0.372168] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.372177] pnp 00:08: [io  0x0060]
[    0.372178] pnp 00:08: [io  0x0064]
[    0.372183] pnp 00:08: [irq 1]
[    0.372236] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.372248] pnp 00:09: [irq 12]
[    0.372299] pnp 00:09: Plug and Play ACPI device, IDs IBM0057 PNP0f13 
(active)
[    0.392258] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.392327] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
[    0.392781] pnp: PnP ACPI: found 11 devices
[    0.392838] ACPI: ACPI bus type pnp unregistered
[    0.401303] PCI: max bus depth: 2 pci_try_num: 3
[    0.401356] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0000000-0xc01fffff 
64bit pref]
[    0.401430] pci 0000:00:1c.1: BAR 13: assigned [io  0x8000-0x8fff]
[    0.401491] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0200000-0xc03fffff]
[    0.401553] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0400000-0xc05fffff 
64bit pref]
[    0.401625] pci 0000:00:1c.0: BAR 13: assigned [io  0x9000-0x9fff]
[    0.401685] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.401744] pci 0000:00:1c.0:   bridge window [io  0x9000-0x9fff]
[    0.401807] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff]
[    0.401869] pci 0000:00:1c.0:   bridge window [mem 0xc0400000-0xc05fffff 
64bit pref]
[    0.401946] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.402005] pci 0000:00:1c.1:   bridge window [io  0x8000-0x8fff]
[    0.402068] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
[    0.402130] pci 0000:00:1c.1:   bridge window [mem 0xc0000000-0xc01fffff 
64bit pref]
[    0.402206] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.402265] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.402328] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.402390] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 
64bit pref]
[    0.402466] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.402525] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.402588] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.402651] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 
64bit pref]
[    0.402728] pci 0000:15:00.0: BAR 15: assigned [mem 0xf0000000-0xf3ffffff 
pref]
[    0.402801] pci 0000:15:00.0: BAR 16: assigned [mem 0xc4000000-0xc7ffffff]
[    0.402861] pci 0000:15:00.0: BAR 13: assigned [io  0x4000-0x40ff]
[    0.402921] pci 0000:15:00.0: BAR 14: assigned [io  0x4400-0x44ff]
[    0.402980] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
[    0.403038] pci 0000:15:00.0:   bridge window [io  0x4000-0x40ff]
[    0.403100] pci 0000:15:00.0:   bridge window [io  0x4400-0x44ff]
[    0.403163] pci 0000:15:00.0:   bridge window [mem 0xf0000000-0xf3ffffff 
pref]
[    0.403236] pci 0000:15:00.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.403300] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
[    0.403358] pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
[    0.403421] pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
[    0.403484] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 
64bit pref]
[    0.403568] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.405320] pci 0000:00:1c.0: setting latency timer to 64
[    0.405329] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.405392] pci 0000:00:1c.1: setting latency timer to 64
[    0.405400] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.405462] pci 0000:00:1c.3: setting latency timer to 64
[    0.405469] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.405531] pci 0000:00:1c.4: setting latency timer to 64
[    0.405539] pci 0000:00:1e.0: setting latency timer to 64
[    0.405548] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.405612] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.405614] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.405617] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.405619] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.405621] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.405623] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.405625] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.405627] pci_bus 0000:02: resource 0 [io  0x9000-0x9fff]
[    0.405629] pci_bus 0000:02: resource 1 [mem 0xc0200000-0xc03fffff]
[    0.405631] pci_bus 0000:02: resource 2 [mem 0xc0400000-0xc05fffff 64bit 
pref]
[    0.405633] pci_bus 0000:03: resource 0 [io  0x8000-0x8fff]
[    0.405636] pci_bus 0000:03: resource 1 [mem 0xf4300000-0xf43fffff]
[    0.405638] pci_bus 0000:03: resource 2 [mem 0xc0000000-0xc01fffff 64bit 
pref]
[    0.405640] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.405642] pci_bus 0000:05: resource 1 [mem 0xf8000000-0xf9ffffff]
[    0.405644] pci_bus 0000:05: resource 2 [mem 0xf4000000-0xf40fffff 64bit 
pref]
[    0.405646] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.405648] pci_bus 0000:0d: resource 1 [mem 0xfa000000-0xfbffffff]
[    0.405650] pci_bus 0000:0d: resource 2 [mem 0xf4100000-0xf41fffff 64bit 
pref]
[    0.405653] pci_bus 0000:15: resource 0 [io  0x4000-0x7fff]
[    0.405655] pci_bus 0000:15: resource 1 [mem 0xf4800000-0xf7ffffff]
[    0.405657] pci_bus 0000:15: resource 2 [mem 0xf0000000-0xf3ffffff 64bit 
pref]
[    0.405659] pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
[    0.405661] pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
[    0.405663] pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
[    0.405665] pci_bus 0000:15: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.405667] pci_bus 0000:15: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.405669] pci_bus 0000:15: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.405671] pci_bus 0000:15: resource 10 [mem 0xc0000000-0xfebfffff]
[    0.405673] pci_bus 0000:16: resource 0 [io  0x4000-0x40ff]
[    0.405675] pci_bus 0000:16: resource 1 [io  0x4400-0x44ff]
[    0.405677] pci_bus 0000:16: resource 2 [mem 0xf0000000-0xf3ffffff pref]
[    0.405679] pci_bus 0000:16: resource 3 [mem 0xc4000000-0xc7ffffff]
[    0.405714] NET: Registered protocol family 2
[    0.405889] IP route cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[    0.407150] TCP established hash table entries: 524288 (order: 11, 8388608 
bytes)
[    0.410394] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.410917] TCP: Hash tables configured (established 524288 bind 65536)
[    0.410977] TCP reno registered
[    0.411041] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.411134] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.411354] NET: Registered protocol family 1
[    0.411428] pci 0000:00:02.0: Boot video device
[    0.411443] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.411445] pci 0000:00:1a.0: Performing full reset
[    0.411465] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.411467] pci 0000:00:1a.1: Performing full reset
[    0.411487] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.411489] pci 0000:00:1a.2: Performing full reset
[    0.411553] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.411554] pci 0000:00:1d.0: Performing full reset
[    0.411574] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.411576] pci 0000:00:1d.1: Performing full reset
[    0.411595] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.411597] pci 0000:00:1d.2: Performing full reset
[    0.411667] PCI: CLS 64 bytes, default 64
[    0.411714] Trying to unpack rootfs image as initramfs...
[    0.413879] rootfs image is not initramfs (no cpio magic); looks like an 
initrd
[    0.415298] Freeing initrd memory: 1280k freed
[    0.415575] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.415635] Placing 64MB software IO TLB between ffff8800b94a1000 - 
ffff8800bd4a1000
[    0.415706] software IO TLB at phys 0xb94a1000 - 0xbd4a1000
[    0.415777] Simple Boot Flag at 0x35 set to 0x1
[    0.416820] audit: initializing netlink socket (disabled)
[    0.416886] type=2000 audit(1309442452.412:1): initialized
[    0.427792] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.450533] VFS: Disk quotas dquot_6.5.2
[    0.450684] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.450851] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.450967] msgmni has been set to 7717
[    0.451363] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
253)
[    0.451434] io scheduler noop registered
[    0.451490] io scheduler deadline registered (default)
[    0.451687] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.451738] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.451931] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.451979] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.452212] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.452260] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    0.452448] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.452496] pcieport 0000:00:1c.4: irq 43 for MSI/MSI-X
[    0.452769] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.452833] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.452853] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    0.452914] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    0.452976] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    0.452997] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    0.453059] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    0.453079] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    0.453142] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    0.453266] intel_idle: MWAIT substates: 0x3122220
[    0.453268] intel_idle: does not run on family 6 model 23
[    0.453349] input: Lid Switch as 
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.453590] ACPI: Lid Switch [LID]
[    0.453717] input: Sleep Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.453791] ACPI: Sleep Button [SLPB]
[    0.453934] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.454006] ACPI: Power Button [PWRF]
[    0.454108] ERST: Table is not found!
[    0.485221] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.616417] Linux agpgart interface v0.103
[    0.616622] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    0.616800] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 
262144K mappable
[    0.618586] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    0.618851] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.619021] [drm] Initialized drm 1.1.0 20060810
[    0.619121] [drm] radeon defaulting to userspace modesetting.
[    0.620274] i915 0000:00:02.0: power state changed by ACPI to D0
[    0.620335] i915 0000:00:02.0: power state changed by ACPI to D0
[    0.620398] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.620459] i915 0000:00:02.0: setting latency timer to 64
[    0.675899] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[    0.675904] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.675966] [drm] Driver supports precise vblank timestamp query.
[    0.676083] vgaarb: device changed decodes: 
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.042814] fbcon: inteldrmfb (fb0) is primary device
[    1.093840] Console: switching to colour frame buffer device 180x56
[    1.098388] fb0: inteldrmfb frame buffer device
[    1.098418] drm: registered panic notifier
[    1.205736] acpi device:02: registered as cooling_device0
[    1.205888] input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.205949] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.206061] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 
0
[    1.208171] brd: module loaded
[    1.208300] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 
0x60,0x64 irq 1,12
[    1.217066] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.217126] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.217361] mousedev: PS/2 mouse device common for all mice
[    1.217459] rtc_cmos 00:07: RTC can wake from S4
[    1.217627] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    1.217694] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.217776] cpuidle: using governor ladder
[    1.217804] cpuidle: using governor menu
[    1.218043] TCP cubic registered
[    1.218067] NET: Registered protocol family 17
[    1.222637] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input4
[    1.229355] registered taskstats version 1
[    1.239418] rtc_cmos 00:07: setting system clock to 2011-06-30 14:00:54 UTC 
(1309442454)
[    1.239632] RAMDISK: lzo image found at block 0
[    1.255180] VFS: Mounted root (romfs filesystem) readonly on device 1:0.
[    1.260894] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: 
dm-devel@redhat.com
[    1.263514] Intel AES-NI instructions are not detected.
[    1.276778] SCSI subsystem initialized
[    1.281234] libata version 3.00 loaded.
[    1.282347] ahci 0000:00:1f.2: version 3.0
[    1.282362] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.284027] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    1.284068] ahci: SSS flag set, parallel bus scan disabled
[    1.285674] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 
impl SATA mode
[    1.287295] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio 
slum part ccc sxs 
[    1.288958] ahci 0000:00:1f.2: setting latency timer to 64
[    1.289759] scsi0 : ahci
[    1.291501] scsi1 : ahci
[    1.293196] scsi2 : ahci
[    1.294870] scsi3 : ahci
[    1.296736] ata1: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226100 
irq 45
[    1.298307] ata2: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226180 
irq 45
[    1.299834] ata3: DUMMY
[    1.301389] ata4: DUMMY
[    1.412018] Refined TSC clocksource calibration: 2526.999 MHz.
[    1.413544] Switching to clocksource tsc
[    1.620017] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.631008] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.631011] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[    1.632567] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[    1.640103] ata1.00: ATA-8: OCZ-VERTEX2, 1.32, max UDMA/133
[    1.641633] ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), 
AA
[    1.650104] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.650108] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[    1.651662] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[    1.660106] ata1.00: configured for UDMA/133
[    1.661755] scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX2      1.32 
PQ: 0 ANSI: 5
[    1.980017] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.984042] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    1.985060] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    1.985063] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[    1.987703] ata2.00: ATAPI: Optiarc  DVD RW AD-7910S, 1.D0, max UDMA/100
[    1.992196] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    1.993298] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    1.993301] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[    1.995939] ata2.00: configured for UDMA/100
[    1.999858] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7910S  1.D0 
PQ: 0 ANSI: 5
[    2.002678] sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 
GB/223 GiB)
[    2.004373] sd 0:0:0:0: [sda] Write Protect is off
[    2.006359] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.006379] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    2.008662]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 >
[    2.010754] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.031354] SGI XFS with ACLs, security attributes, large block/inode 
numbers, no debug enabled
[    2.033625] SGI XFS Quota Management subsystem
[    6.328282] XFS (dm-0): Mounting Filesystem
[    6.380374] XFS (dm-0): Ending clean mount
[    6.382043] VFS: Mounted root (xfs filesystem) readonly on device 254:0.
[    6.383711] Trying to move old root to /initrd ... okay
[    6.386001] devtmpfs: mounted
[    6.388579] Freeing unused kernel memory: 568k freed
[    6.390409] Write protecting the kernel read-only data: 8192k
[    6.397896] Freeing unused kernel memory: 1992k freed
[    6.401055] Freeing unused kernel memory: 280k freed
[    6.719905] usbcore: registered new interface driver usbfs
[    6.719951] usbcore: registered new interface driver hub
[    6.721649] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    6.721651] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    6.721685] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.721696] e1000e 0000:00:19.0: setting latency timer to 64
[    6.721826] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[    6.722267] usbcore: registered new device driver usb
[    6.726571] ACPI: acpi_idle registered with cpuidle
[    6.743745] Monitor-Mwait will be used to enter C-1 state
[    6.746559] Monitor-Mwait will be used to enter C-2 state
[    6.748047] Monitor-Mwait will be used to enter C-3 state
[    6.748058] Marking TSC unstable due to TSC halts in idle
[    6.748969] Switching to clocksource hpet
[    6.752458] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.752461] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    6.752678] iTCO_vendor_support: vendor-support=0
[    6.755801] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[    6.755895] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, 
TCOBASE=0x1060)
[    6.756058] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    6.780922] thermal LNXTHERM:00: registered as thermal_zone0
[    6.780925] ACPI: Thermal Zone [THM0] (49 C)
[    6.791193] thermal LNXTHERM:01: registered as thermal_zone1
[    6.791195] ACPI: Thermal Zone [THM1] (47 C)
[    6.796430] cfg80211: Calling CRDA to update world regulatory domain
[    6.796944] sdhci: Secure Digital Host Controller Interface driver
[    6.796946] sdhci: Copyright(c) Pierre Ossman
[    6.798191] firewire_ohci 0000:15:00.1: PCI INT B -> GSI 17 (level, low) -> 
IRQ 17
[    6.798885] wmi: Mapper loaded
[    6.819807] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-
tree:d
[    6.819809] iwlagn: Copyright(c) 2003-2011 Intel Corporation
[    6.819886] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.819895] iwlagn 0000:03:00.0: setting latency timer to 64
[    6.819926] iwlagn 0000:03:00.0: Detected Intel(R) WiMAX/WiFi Link 5350 
AGN, REV=0x24
[    6.842263] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    6.842906] Non-volatile memory driver v1.3
[    6.844282] ACPI: AC Adapter [AC] (on-line)
[    6.867197] firewire_ohci: Added fw-ohci device 0000:15:00.1, OHCI v1.10, 4 
IR + 4 IT contexts, quirks 0x1
[    6.867218] sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 
21)
[    6.867240] sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    6.867371] tpm_tis 00:0a: 1.2 TPM (device-id 0x1020, rev-id 6)
[    6.867373] tpm_tis 00:0a: Intel iTPM workaround enabled
[    6.868269] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW 
doesn't fully claim to support it.
[    6.868289] mmc0: no vmmc regulator found
[    6.869309] Registered led device: mmc0::
[    6.871047] mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
[    6.871426] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
[    6.874314] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.874352] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    6.879866] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 
cdda tray
[    6.879869] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.880022] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    6.899789] iwlagn 0000:03:00.0: device EEPROM VER=0x21e, CALIB=0x4
[    6.899791] iwlagn 0000:03:00.0: Device SKU: 0Xb
[    6.899793] iwlagn 0000:03:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
[    6.899805] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a 
channels
[    6.899879] iwlagn 0000:03:00.0: irq 47 for MSI/MSI-X
[    6.900174] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    6.900176] thinkpad_acpi: http://ibm-acpi.sf.net/
[    6.900178] thinkpad_acpi: ThinkPad BIOS 7UET91WW (3.21 ), EC 7VHT16WW-1.06
[    6.900180] thinkpad_acpi: Lenovo ThinkPad T400, model 2764CTO
[    6.965596] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 
00:21:86:a2:19:06
[    6.965600] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    6.965873] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[    6.965903] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    6.965908] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    6.965918] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 
23
[    6.965963] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    6.965967] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    6.965988] drivers/usb/core/inode.c: creating file 'devices'
[    6.965992] drivers/usb/core/inode.c: creating file '001'
[    6.965996] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus 
number 1
[    6.966007] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 
pcc=2 ordered !ppc ports=6
[    6.966011] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 
1024 64 bit addr hw prefetch
[    6.966045] ehci_hcd 0000:00:1a.7: debug port 1
[    6.966049] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 
period=1024 Reset HALT
[    6.969954] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    6.969956] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    6.969979] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xfc226c00
[    6.969984] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 
period=1024 Reset HALT
[    6.973856] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 
period=1024 RUN
[    6.984185] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.984215] usb usb1: default language 0x0409
[    6.984221] usb usb1: udev 1, busnum 1, minor = 0
[    6.984223] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.984225] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    6.984227] usb usb1: Product: EHCI Host Controller
[    6.984229] usb usb1: Manufacturer: Linux 3.0.0-rc4-00059-g143e859 ehci_hcd
[    6.984231] usb usb1: SerialNumber: 0000:00:1a.7
[    6.984333] usb usb1: usb_probe_device
[    6.984336] usb usb1: configuration #1 chosen from 1 choice
[    6.984345] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    6.984366] hub 1-0:1.0: usb_probe_interface
[    6.984368] hub 1-0:1.0: usb_probe_interface - got id
[    6.984370] hub 1-0:1.0: USB hub found
[    6.984374] hub 1-0:1.0: 6 ports detected
[    6.984376] hub 1-0:1.0: standalone hub
[    6.984377] hub 1-0:1.0: no power switching (usb 1.0)
[    6.984379] hub 1-0:1.0: individual port over-current protection
[    6.984381] hub 1-0:1.0: power on to power good time: 20ms
[    6.984384] hub 1-0:1.0: local power source is good
[    6.984386] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    6.984435] drivers/usb/core/inode.c: creating file '001'
[    6.984501] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 
17
[    6.984701] HDA Intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[    6.984729] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    6.996884] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0888, PCI irq 16
[    6.996888] yenta_cardbus 0000:15:00.0: Socket status: 30000006
[    6.996893] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: 
[io  0x4000-0x7fff]
[    6.996896] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: 
[mem 0xf4800000-0xf7ffffff]
[    6.996899] pcmcia_socket pcmcia_socket0: cs: memory probe 
0xf4800000-0xf7ffffff: excluding 0xf4800000-0xf4b7ffff
[    6.996912] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: 
[mem 0xf0000000-0xf3ffffff 64bit pref]
[    6.996915] pcmcia_socket pcmcia_socket0: cs: memory probe 
0xf0000000-0xf3ffffff: excluding 0xf0000000-0xf3ffffff
[    7.015659] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[    7.027652] Monitor-Mwait will be used to enter C-3 state
[    7.029229] thinkpad_acpi: radio switch found; radios are enabled
[    7.032893] ACPI: Battery Slot [BAT0] (battery present)
[    7.037110] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is 
unblocked
[    7.070128] ALSA sound/pci/hda/hda_codec.c:3771 hda_codec: model 'laptop' 
is selected
[    7.070186] input: HDA Digital PCBeep as 
/devices/pci0000:00/0000:00:1b.0/input/input6
[    7.077845] thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is unblocked
[    7.078559] Registered led device: tpacpi::thinklight
[    7.078592] Registered led device: tpacpi::power
[    7.078607] Registered led device: tpacpi::standby
[    7.078621] Registered led device: tpacpi::thinkvantage
[    7.084062] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[    7.084067] hub 1-0:1.0: port 1: status 0501 change 0001
[    7.084081] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[    7.084084] hub 1-0:1.0: port 4: status 0501 change 0001
[    7.084093] ehci_hcd 0000:00:1a.7: GetStatus port:6 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[    7.084096] hub 1-0:1.0: port 6: status 0501 change 0001
[    7.085743] input: HDA Intel Mic as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    7.085858] input: HDA Intel Mic as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    7.085921] input: HDA Intel Headphone as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    7.086459] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> 
IRQ 23
[    7.086659] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    7.086688] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    7.086699] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 
19
[    7.086741] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    7.086744] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    7.086750] thinkpad_acpi: Standard ACPI backlight interface available, not 
loading native one
[    7.086754] drivers/usb/core/inode.c: creating file '002'
[    7.086760] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus 
number 2
[    7.086770] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 
pcc=2 ordered !ppc ports=6
[    7.086775] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 
1024 64 bit addr hw prefetch
[    7.086805] ehci_hcd 0000:00:1d.7: debug port 1
[    7.086810] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 
period=1024 Reset HALT
[    7.086820] thinkpad_acpi: Console audio control enabled, mode: override 
(read/write)
[    7.088093] input: ThinkPad Extra Buttons as 
/devices/platform/thinkpad_acpi/input/input10
[    7.090836] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    7.090838] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    7.090857] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfc227000
[    7.090861] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 
period=1024 Reset HALT
[    7.094735] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 
period=1024 RUN
[    7.104088] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    7.108123] usb usb2: default language 0x0409
[    7.108129] usb usb2: udev 1, busnum 2, minor = 128
[    7.108131] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    7.108133] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.108136] usb usb2: Product: EHCI Host Controller
[    7.108137] usb usb2: Manufacturer: Linux 3.0.0-rc4-00059-g143e859 ehci_hcd
[    7.108139] usb usb2: SerialNumber: 0000:00:1d.7
[    7.108371] usb usb2: usb_probe_device
[    7.108374] usb usb2: configuration #1 chosen from 1 choice
[    7.108382] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    7.108405] hub 2-0:1.0: usb_probe_interface
[    7.108406] hub 2-0:1.0: usb_probe_interface - got id
[    7.108409] hub 2-0:1.0: USB hub found
[    7.108413] hub 2-0:1.0: 6 ports detected
[    7.108414] hub 2-0:1.0: standalone hub
[    7.108416] hub 2-0:1.0: no power switching (usb 1.0)
[    7.108418] hub 2-0:1.0: individual port over-current protection
[    7.108419] hub 2-0:1.0: power on to power good time: 20ms
[    7.108423] hub 2-0:1.0: local power source is good
[    7.108425] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    7.108481] drivers/usb/core/inode.c: creating file '001'
[    7.174002] iwlagn 0000:03:00.0: loaded firmware version 8.83.5.1 build 
33692
[    7.174385] Registered led device: phy0-led
[    7.184052] hub 1-0:1.0: state 7 ports 6 chg 0052 evt 0000
[    7.184074] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    7.190076] uhci_hcd: USB Universal Host Controller Interface driver
[    7.190134] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    7.190137] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    7.190147] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[    7.190156] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    7.190159] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    7.190166] drivers/usb/core/inode.c: creating file '003'
[    7.190172] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus 
number 3
[    7.190183] uhci_hcd 0000:00:1a.0: detected 2 ports
[    7.190188] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    7.190190] uhci_hcd 0000:00:1a.0: Performing full reset
[    7.190206] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    7.190228] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    7.190269] usb usb3: default language 0x0409
[    7.190275] usb usb3: udev 1, busnum 3, minor = 256
[    7.190277] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    7.190279] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.190281] usb usb3: Product: UHCI Host Controller
[    7.190283] usb usb3: Manufacturer: Linux 3.0.0-rc4-00059-g143e859 uhci_hcd
[    7.190284] usb usb3: SerialNumber: 0000:00:1a.0
[    7.190409] usb usb3: usb_probe_device
[    7.190412] usb usb3: configuration #1 chosen from 1 choice
[    7.190419] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    7.190441] hub 3-0:1.0: usb_probe_interface
[    7.190443] hub 3-0:1.0: usb_probe_interface - got id
[    7.190446] hub 3-0:1.0: USB hub found
[    7.190449] hub 3-0:1.0: 2 ports detected
[    7.190451] hub 3-0:1.0: standalone hub
[    7.190453] hub 3-0:1.0: no power switching (usb 1.0)
[    7.190454] hub 3-0:1.0: individual port over-current protection
[    7.190456] hub 3-0:1.0: power on to power good time: 2ms
[    7.190460] hub 3-0:1.0: local power source is good
[    7.190462] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    7.190500] drivers/usb/core/inode.c: creating file '001'
[    7.190530] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    7.190555] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 
21
[    7.190561] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    7.190565] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    7.190569] drivers/usb/core/inode.c: creating file '004'
[    7.190572] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus 
number 4
[    7.190581] uhci_hcd 0000:00:1a.1: detected 2 ports
[    7.190589] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    7.190591] uhci_hcd 0000:00:1a.1: Performing full reset
[    7.190618] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    7.190654] usb usb4: default language 0x0409
[    7.190659] usb usb4: udev 1, busnum 4, minor = 384
[    7.190661] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    7.190663] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.190665] usb usb4: Product: UHCI Host Controller
[    7.190667] usb usb4: Manufacturer: Linux 3.0.0-rc4-00059-g143e859 uhci_hcd
[    7.190669] usb usb4: SerialNumber: 0000:00:1a.1
[    7.190734] usb usb4: usb_probe_device
[    7.190737] usb usb4: configuration #1 chosen from 1 choice
[    7.190743] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    7.190767] hub 4-0:1.0: usb_probe_interface
[    7.190769] hub 4-0:1.0: usb_probe_interface - got id
[    7.190771] hub 4-0:1.0: USB hub found
[    7.190774] hub 4-0:1.0: 2 ports detected
[    7.190776] hub 4-0:1.0: standalone hub
[    7.190777] hub 4-0:1.0: no power switching (usb 1.0)
[    7.190779] hub 4-0:1.0: individual port over-current protection
[    7.190781] hub 4-0:1.0: power on to power good time: 2ms
[    7.190784] hub 4-0:1.0: local power source is good
[    7.190786] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    7.190828] drivers/usb/core/inode.c: creating file '001'
[    7.190861] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    7.190879] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    7.190882] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    7.190890] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 
22
[    7.190896] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    7.190900] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    7.190905] drivers/usb/core/inode.c: creating file '005'
[    7.190908] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus 
number 5
[    7.190916] uhci_hcd 0000:00:1a.2: detected 2 ports
[    7.190921] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    7.190923] uhci_hcd 0000:00:1a.2: Performing full reset
[    7.190940] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    7.190954] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    7.190988] usb usb5: default language 0x0409
[    7.190993] usb usb5: udev 1, busnum 5, minor = 512
[    7.190995] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    7.190998] usb usb5: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.191000] usb usb5: Product: UHCI Host Controller
[    7.191001] usb usb5: Manufacturer: Linux 3.0.0-rc4-00059-g143e859 uhci_hcd
[    7.191003] usb usb5: SerialNumber: 0000:00:1a.2
[    7.191069] usb usb5: usb_probe_device
[    7.191072] usb usb5: configuration #1 chosen from 1 choice
[    7.191077] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    7.191099] hub 5-0:1.0: usb_probe_interface
[    7.191101] hub 5-0:1.0: usb_probe_interface - got id
[    7.191103] hub 5-0:1.0: USB hub found
[    7.191106] hub 5-0:1.0: 2 ports detected
[    7.191108] hub 5-0:1.0: standalone hub
[    7.191109] hub 5-0:1.0: no power switching (usb 1.0)
[    7.191111] hub 5-0:1.0: individual port over-current protection
[    7.191113] hub 5-0:1.0: power on to power good time: 2ms
[    7.191116] hub 5-0:1.0: local power source is good
[    7.191118] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    7.191150] drivers/usb/core/inode.c: creating file '001'
[    7.191179] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    7.191198] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    7.191200] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    7.191205] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16
[    7.191211] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    7.191214] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    7.191218] drivers/usb/core/inode.c: creating file '006'
[    7.191222] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus 
number 6
[    7.191229] uhci_hcd 0000:00:1d.0: detected 2 ports
[    7.191234] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    7.191236] uhci_hcd 0000:00:1d.0: Performing full reset
[    7.191251] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    7.191257] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    7.191292] usb usb6: default language 0x0409
[    7.191297] usb usb6: udev 1, busnum 6, minor = 640
[    7.191299] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    7.191301] usb usb6: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.191303] usb usb6: Product: UHCI Host Controller
[    7.191305] usb usb6: Manufacturer: Linux 3.0.0-rc4-00059-g143e859 uhci_hcd
[    7.191307] usb usb6: SerialNumber: 0000:00:1d.0
[    7.191370] usb usb6: usb_probe_device
[    7.191373] usb usb6: configuration #1 chosen from 1 choice
[    7.191379] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    7.191398] hub 6-0:1.0: usb_probe_interface
[    7.191400] hub 6-0:1.0: usb_probe_interface - got id
[    7.191402] hub 6-0:1.0: USB hub found
[    7.191406] hub 6-0:1.0: 2 ports detected
[    7.191407] hub 6-0:1.0: standalone hub
[    7.191409] hub 6-0:1.0: no power switching (usb 1.0)
[    7.191410] hub 6-0:1.0: individual port over-current protection
[    7.191412] hub 6-0:1.0: power on to power good time: 2ms
[    7.191415] hub 6-0:1.0: local power source is good
[    7.191421] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    7.191455] drivers/usb/core/inode.c: creating file '001'
[    7.191485] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    7.191500] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 
17
[    7.191506] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    7.191509] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    7.191514] drivers/usb/core/inode.c: creating file '007'
[    7.191517] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus 
number 7
[    7.191526] uhci_hcd 0000:00:1d.1: detected 2 ports
[    7.191531] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    7.191533] uhci_hcd 0000:00:1d.1: Performing full reset
[    7.191553] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    7.191588] usb usb7: default language 0x0409
[    7.191593] usb usb7: udev 1, busnum 7, minor = 768
[    7.191595] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    7.191597] usb usb7: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.191599] usb usb7: Product: UHCI Host Controller
[    7.191601] usb usb7: Manufacturer: Linux 3.0.0-rc4-00059-g143e859 uhci_hcd
[    7.191602] usb usb7: SerialNumber: 0000:00:1d.1
[    7.191667] usb usb7: usb_probe_device
[    7.191669] usb usb7: configuration #1 chosen from 1 choice
[    7.191675] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    7.191693] hub 7-0:1.0: usb_probe_interface
[    7.191695] hub 7-0:1.0: usb_probe_interface - got id
[    7.191697] hub 7-0:1.0: USB hub found
[    7.191700] hub 7-0:1.0: 2 ports detected
[    7.191702] hub 7-0:1.0: standalone hub
[    7.191704] hub 7-0:1.0: no power switching (usb 1.0)
[    7.191705] hub 7-0:1.0: individual port over-current protection
[    7.191707] hub 7-0:1.0: power on to power good time: 2ms
[    7.191710] hub 7-0:1.0: local power source is good
[    7.191712] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    7.191748] drivers/usb/core/inode.c: creating file '001'
[    7.191781] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    7.191796] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    7.191802] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    7.191805] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    7.191810] drivers/usb/core/inode.c: creating file '008'
[    7.191813] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus 
number 8
[    7.191822] uhci_hcd 0000:00:1d.2: detected 2 ports
[    7.191827] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    7.191829] uhci_hcd 0000:00:1d.2: Performing full reset
[    7.191847] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    7.191880] usb usb8: default language 0x0409
[    7.191885] usb usb8: udev 1, busnum 8, minor = 896
[    7.191887] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    7.191889] usb usb8: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.191891] usb usb8: Product: UHCI Host Controller
[    7.191893] usb usb8: Manufacturer: Linux 3.0.0-rc4-00059-g143e859 uhci_hcd
[    7.191895] usb usb8: SerialNumber: 0000:00:1d.2
[    7.191957] usb usb8: usb_probe_device
[    7.191959] usb usb8: configuration #1 chosen from 1 choice
[    7.191965] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    7.191986] hub 8-0:1.0: usb_probe_interface
[    7.191988] hub 8-0:1.0: usb_probe_interface - got id
[    7.191990] hub 8-0:1.0: USB hub found
[    7.191993] hub 8-0:1.0: 2 ports detected
[    7.191995] hub 8-0:1.0: standalone hub
[    7.191996] hub 8-0:1.0: no power switching (usb 1.0)
[    7.195305] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    7.195542] hub 8-0:1.0: individual port over-current protection
[    7.195545] hub 8-0:1.0: power on to power good time: 2ms
[    7.195550] hub 8-0:1.0: local power source is good
[    7.195552] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    7.197246] drivers/usb/core/inode.c: creating file '001'
[    7.197291] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    7.208086] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[    7.208090] hub 2-0:1.0: port 4: status 0501 change 0001
[    7.221238] udevd[1440]: renamed network interface wlan0 to eth1
[    7.244259] ehci_hcd 0000:00:1a.7: port 1 full speed --> companion
[    7.244666] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003801 0  ACK 
POWER OWNER sig=j CONNECT
[    7.244692] hub 1-0:1.0: port 1 not reset yet, waiting 50ms
[    7.288048] uhci_hcd 0000:00:1a.0: port 1 portsc 0093,00
[    7.288054] hub 3-0:1.0: port 1: status 0101 change 0001
[    7.288080] uhci_hcd 0000:00:1a.1: port 2 portsc 0082,00
[    7.288099] uhci_hcd 0000:00:1a.2: port 2 portsc 0082,00
[    7.288133] uhci_hcd 0000:00:1d.1: port 2 portsc 0082,00
[    7.304065] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003002 0  ACK 
POWER OWNER sig=se0 CSC
[    7.304091] hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    7.364259] ehci_hcd 0000:00:1a.7: port 4 full speed --> companion
[    7.364264] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003801 0  ACK 
POWER OWNER sig=j CONNECT
[    7.364268] hub 1-0:1.0: port 4 not reset yet, waiting 50ms
[    7.368212] firewire_core: created device fw0: GUID 00061b032a347baa, S400
[    7.420063] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003002 0  ACK 
POWER OWNER sig=se0 CSC
[    7.420086] hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    7.476264] ehci_hcd 0000:00:1a.7: port 6 high speed
[    7.476267] ehci_hcd 0000:00:1a.7: GetStatus port:6 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[    7.532062] usb 1-6: new high speed USB device number 4 using ehci_hcd
[    7.588384] ehci_hcd 0000:00:1a.7: port 6 high speed
[    7.588388] ehci_hcd 0000:00:1a.7: GetStatus port:6 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[    7.671538] usb 1-6: skipped 1 descriptor after configuration
[    7.671541] usb 1-6: skipped 5 descriptors after interface
[    7.671543] usb 1-6: skipped 1 descriptor after endpoint
[    7.671545] usb 1-6: skipped 9 descriptors after interface
[    7.671922] usb 1-6: default language 0x0409
[    7.675642] usb 1-6: udev 4, busnum 1, minor = 3
[    7.675644] usb 1-6: New USB device found, idVendor=17ef, idProduct=1004
[    7.675647] usb 1-6: New USB device strings: Mfr=2, Product=1, 
SerialNumber=3
[    7.675648] usb 1-6: Product: Integrated Camera
[    7.675650] usb 1-6: Manufacturer: Chicony Electronics Co., Ltd.
[    7.675652] usb 1-6: SerialNumber: SN0001
[    7.675716] usb 1-6: usb_probe_device
[    7.675726] usb 1-6: configuration #1 chosen from 1 choice
[    7.675911] usb 1-6: adding 1-6:1.0 (config #1, interface 0)
[    7.677186] usb 1-6: adding 1-6:1.1 (config #1, interface 1)
[    7.677237] drivers/usb/core/inode.c: creating file '004'
[    7.677255] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0010
[    7.677262] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.677267] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.677271] hub 2-0:1.0: state 7 ports 6 chg 0010 evt 0000
[    7.677277] hub 2-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    7.681373] Linux media interface: v0.10
[    7.685763] Linux video capture interface: v2.00
[    7.688175] uvcvideo 1-6:1.0: usb_probe_interface
[    7.688178] uvcvideo 1-6:1.0: usb_probe_interface - got id
[    7.688200] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:1004)
[    7.707458] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1c0b1, caps: 
0xd04791/0xb00000/0x20000
[    7.707463] serio: Synaptics pass-through port at isa0060/serio1/input0
[    7.724879] input: Integrated Camera as 
/devices/pci0000:00/0000:00:1a.7/usb1/1-6/1-6:1.0/input/input11
[    7.724940] usbcore: registered new interface driver uvcvideo
[    7.724941] USB Video Class driver (v1.1.0)
[    7.726599] usb 1-6: link qh4-0001/ffff88012f2b3a80 start 1 [1/0 us]
[    7.726637] usb 1-6: unlink qh4-0001/ffff88012f2b3a80 start 1 [1/0 us]
[    7.732263] ehci_hcd 0000:00:1d.7: port 4 high speed
[    7.732267] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[    7.751599] input: SynPS/2 Synaptics TouchPad as 
/devices/platform/i8042/serio1/input/input12
[    7.788065] usb 2-4: new high speed USB device number 2 using ehci_hcd
[    7.848262] ehci_hcd 0000:00:1d.7: port 4 high speed
[    7.848267] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[    7.977437] usb 2-4: skipped 3 descriptors after interface
[    7.977439] usb 2-4: skipped 4 descriptors after interface
[    7.977442] usb 2-4: skipped 4 descriptors after interface
[    7.977445] usb 2-4: skipped 2 descriptors after interface
[    7.977447] usb 2-4: skipped 2 descriptors after interface
[    7.977449] usb 2-4: skipped 5 descriptors after interface
[    7.977452] usb 2-4: skipped 4 descriptors after interface
[    7.986046] usb 2-4: skipped 3 descriptors after interface
[    7.986048] usb 2-4: skipped 4 descriptors after interface
[    7.986051] usb 2-4: skipped 4 descriptors after interface
[    7.986053] usb 2-4: skipped 2 descriptors after interface
[    7.986055] usb 2-4: skipped 2 descriptors after interface
[    7.986058] usb 2-4: skipped 5 descriptors after interface
[    7.986147] usb 2-4: default language 0x0409
[    7.990174] usb 2-4: udev 2, busnum 2, minor = 129
[    7.990176] usb 2-4: New USB device found, idVendor=0bdb, idProduct=1900
[    7.990178] usb 2-4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    7.990180] usb 2-4: Product: Ericsson F3507g Mobile Broadband Minicard 
Composite Device
[    7.990182] usb 2-4: Manufacturer: Ericsson
[    7.990184] usb 2-4: SerialNumber: 3541430228088360
[    7.990261] usb 2-4: usb_probe_device
[    7.990264] usb 2-4: configuration #1 chosen from 2 choices
[    7.992812] usb 2-4: adding 2-4:1.0 (config #1, interface 0)
[    7.993061] usb 2-4: adding 2-4:1.1 (config #1, interface 1)
[    8.011947] usb 2-4: adding 2-4:1.2 (config #1, interface 2)
[    8.014325] usb 2-4: adding 2-4:1.3 (config #1, interface 3)
[    8.016308] usb 2-4: adding 2-4:1.4 (config #1, interface 4)
[    8.018188] usb 2-4: adding 2-4:1.5 (config #1, interface 5)
[    8.020310] usb 2-4: adding 2-4:1.6 (config #1, interface 6)
[    8.022314] usb 2-4: adding 2-4:1.7 (config #1, interface 7)
[    8.024184] usb 2-4: adding 2-4:1.8 (config #1, interface 8)
[    8.026037] usb 2-4: adding 2-4:1.9 (config #1, interface 9)
[    8.028074] usb 2-4: adding 2-4:1.10 (config #1, interface 10)
[    8.029968] drivers/usb/core/inode.c: creating file '002'
[    8.029988] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[    8.029998] hub 3-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    8.035841] cdc_wdm 2-4:1.5: usb_probe_interface
[    8.035845] cdc_wdm 2-4:1.5: usb_probe_interface - got id
[    8.035868] cdc_wdm 2-4:1.5: looking for a minor, starting at 0
[    8.035951] cdc_wdm 2-4:1.5: cdc-wdm-176: USB WDM device
[    8.035957] cdc_wdm 2-4:1.6: usb_probe_interface
[    8.035959] cdc_wdm 2-4:1.6: usb_probe_interface - got id
[    8.035962] cdc_wdm 2-4:1.6: looking for a minor, starting at 0
[    8.035995] cdc_wdm 2-4:1.6: cdc-wdm-175: USB WDM device
[    8.036026] usbcore: registered new interface driver cdc_wdm
[    8.040399] cdc_acm 2-4:1.1: usb_probe_interface
[    8.040403] cdc_acm 2-4:1.1: usb_probe_interface - got id
[    8.040619] cdc_acm 2-4:1.1: ttyACM0: USB ACM device
[    8.041423] cdc_acm 2-4:1.3: usb_probe_interface
[    8.041426] cdc_acm 2-4:1.3: usb_probe_interface - got id
[    8.041548] cdc_acm 2-4:1.3: ttyACM1: USB ACM device
[    8.042032] cdc_acm 2-4:1.9: usb_probe_interface
[    8.042035] cdc_acm 2-4:1.9: usb_probe_interface - got id
[    8.042159] cdc_acm 2-4:1.9: ttyACM2: USB ACM device
[    8.042455] usbcore: registered new interface driver cdc_acm
[    8.042457] cdc_acm: USB Abstract Control Model driver for USB modems and 
ISDN adapters
[    8.043801] cdc_ether 2-4:1.7: usb_probe_interface
[    8.043804] cdc_ether 2-4:1.7: usb_probe_interface - got id
[    8.047235] cdc_ether 2-4:1.7: wwan0: register 'cdc_ether' at 
usb-0000:00:1d.7-4, Mobile Broadband Network Device, 02:80:37:ec:02:00
[    8.047255] usbcore: registered new interface driver cdc_ether
[    8.047880] usbcore: registered new interface driver zaurus
[    8.144040] usb 3-1: new full speed USB device number 2 using uhci_hcd
[    8.278004] usb 3-1: ep0 maxpacket = 8
[    8.308275] usb 3-1: skipped 1 descriptor after interface
[    8.308279] usb 3-1: skipped 1 descriptor after interface
[    8.308281] usb 3-1: skipped 1 descriptor after interface
[    8.311293] usb 3-1: default language 0x0409
[    8.326541] usb 3-1: udev 2, busnum 3, minor = 257
[    8.326544] usb 3-1: New USB device found, idVendor=046d, idProduct=c52b
[    8.326546] usb 3-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    8.326548] usb 3-1: Product: USB Receiver
[    8.326549] usb 3-1: Manufacturer: Logitech
[    8.326681] usb 3-1: usb_probe_device
[    8.326684] usb 3-1: configuration #1 chosen from 1 choice
[    8.331299] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[    8.331335] usb 3-1: adding 3-1:1.1 (config #1, interface 1)
[    8.331366] usb 3-1: adding 3-1:1.2 (config #1, interface 2)
[    8.331423] drivers/usb/core/inode.c: creating file '002'
[    8.331449] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    8.331458] uhci_hcd 0000:00:1a.1: port 2 portsc 0093,00
[    8.331464] hub 4-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    8.336021] usb usb8: suspend_rh (auto-stop)
[    8.336024] usb usb6: suspend_rh (auto-stop)
[    8.340393] usbhid 3-1:1.0: usb_probe_interface
[    8.340396] usbhid 3-1:1.0: usb_probe_interface - got id
[    8.343509] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input13
[    8.343518] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 
4, 17 us
[    8.343641] generic-usb 0003:046D:C52B.0001: input,hidraw0: USB HID v1.11 
Keyboard [Logitech USB Receiver] on usb-0000:00:1a.0-1/input0
[    8.343648] usbhid 3-1:1.1: usb_probe_interface
[    8.343650] usbhid 3-1:1.1: usb_probe_interface - got id
[    8.346653] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.1/input/input14
[    8.346658] uhci_hcd 0000:00:1a.0: reserve dev 2 ep82-INT, period 2, phase 
1, 17 us
[    8.346738] usbhid 3-1:1.1: looking for a minor, starting at 0
[    8.346812] generic-usb 0003:046D:C52B.0002: input,hiddev0,hidraw1: USB HID 
v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1/input1
[    8.346819] usbhid 3-1:1.2: usb_probe_interface
[    8.346821] usbhid 3-1:1.2: usb_probe_interface - got id
[    8.352300] usbhid 3-1:1.2: looking for a minor, starting at 0
[    8.352411] generic-usb 0003:046D:C52B.0003: hiddev0,hidraw2: USB HID v1.11 
Device [Logitech USB Receiver] on usb-0000:00:1a.0-1/input2
[    8.352673] usbcore: registered new interface driver usbhid
[    8.352675] usbhid: USB HID core driver
[    8.456028] hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 
0x101
[    8.568083] usb 4-2: new full speed USB device number 2 using uhci_hcd
[    8.584104] usb usb5: suspend_rh (auto-stop)
[    8.584128] usb usb7: suspend_rh (auto-stop)
[    8.720684] usb 4-2: skipped 1 descriptor after interface
[    8.723676] usb 4-2: default language 0x0409
[    8.734686] usb 4-2: udev 2, busnum 4, minor = 385
[    8.734689] usb 4-2: New USB device found, idVendor=0a5c, idProduct=2145
[    8.734691] usb 4-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    8.734693] usb 4-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[    8.734695] usb 4-2: Manufacturer: Lenovo Computer Corp
[    8.734797] usb 4-2: usb_probe_device
[    8.734800] usb 4-2: configuration #1 chosen from 1 choice
[    8.736687] usb 4-2: adding 4-2:1.0 (config #1, interface 0)
[    8.736739] usb 4-2: adding 4-2:1.1 (config #1, interface 1)
[    8.736777] usb 4-2: adding 4-2:1.2 (config #1, interface 2)
[    8.736816] usb 4-2: adding 4-2:1.3 (config #1, interface 3)
[    8.736872] drivers/usb/core/inode.c: creating file '002'
[    8.736894] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.736900] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.736904] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    8.747792] Bluetooth: Core ver 2.16
[    8.748105] NET: Registered protocol family 31
[    8.748107] Bluetooth: HCI device and connection manager initialized
[    8.748109] Bluetooth: HCI socket layer initialized
[    8.748111] Bluetooth: L2CAP socket layer initialized
[    8.752045] Bluetooth: SCO socket layer initialized
[    8.754120] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    8.754158] btusb 4-2:1.0: usb_probe_interface
[    8.754161] btusb 4-2:1.0: usb_probe_interface - got id
[    8.754655] btusb 4-2:1.2: usb_probe_interface
[    8.754658] btusb 4-2:1.2: usb_probe_interface - got id
[    8.754665] btusb 4-2:1.3: usb_probe_interface
[    8.754667] btusb 4-2:1.3: usb_probe_interface - got id
[    8.754807] usbcore: registered new interface driver btusb
[    8.755143] uhci_hcd 0000:00:1a.1: reserve dev 2 ep81-INT, period 1, phase 
0, 23 us
[    9.808088] hub 6-0:1.0: hub_suspend
[    9.808107] usb usb6: bus auto-suspend
[    9.808114] usb usb6: suspend_rh
[    9.808143] hub 8-0:1.0: hub_suspend
[    9.808152] usb usb8: bus auto-suspend
[    9.808157] usb usb8: suspend_rh
[    9.808198] usb 1-6: usb auto-suspend
[    9.815284] NET: Registered protocol family 10
[    9.962593] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   10.016117] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   10.017580] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   10.824051] hub 5-0:1.0: hub_suspend
[   10.824069] usb usb5: bus auto-suspend
[   10.824075] usb usb5: suspend_rh
[   10.824102] hub 7-0:1.0: hub_suspend
[   10.824110] usb usb7: bus auto-suspend
[   10.824115] usb usb7: suspend_rh
[   10.832694] uhci_hcd 0000:00:1a.1: release dev 2 ep81-INT, period 1, phase 
0, 23 us
[   11.824068] hub 1-0:1.0: hub_suspend
[   11.824082] usb usb1: bus auto-suspend
[   11.824088] ehci_hcd 0000:00:1a.7: suspend root hub
[   13.439029] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   13.678040] input: TPPS/2 IBM TrackPoint as 
/devices/platform/i8042/serio1/serio2/input/input15
[   14.201308] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   17.452069] eth1: authenticate with 68:7f:74:0a:c4:b6 (try 1)
[   17.453499] eth1: authenticated
[   17.470652] eth1: associate with 68:7f:74:0a:c4:b6 (try 1)
[   17.474636] eth1: RX AssocResp from 68:7f:74:0a:c4:b6 (capab=0x431 status=0 
aid=1)
[   17.474644] eth1: associated
[   17.484772] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   17.495070] eth1: Wrong control channel in association response: configured 
center-freq: 2437 hti-cfreq: 2417  hti->control_chan: 2 band: 0.  Disabling 
HT.
[   24.327951] ------------[ cut here ]------------
[   24.327958] WARNING: at kernel/printk.c:322 do_syslog+0x89/0x438()
[   24.327960] Hardware name: 2764CTO
[   24.327962] Attempt to access syslog with CAP_SYS_ADMIN but no CAP_SYSLOG 
(deprecated).
[   24.327964] Modules linked in: sch_sfq ipv6 ext2 mbcache md_mod 
acpi_cpufreq mperf btusb bluetooth crc16 usbhid hid zaurus cdc_ether usbnet 
cdc_acm mii cdc_wdm joydev uvcvideo videodev v4l2_compat_ioctl32 media 
uhci_hcd arc4 snd_hda_codec_conexant pcmcia sg sr_mod battery cdrom psmouse 
serio_raw thinkpad_acpi ac nvram pcspkr tpm_tis tpm tpm_bios yenta_socket 
pcmcia_rsrc iwlagn pcmcia_core mac80211 wmi sdhci_pci firewire_ohci sdhci 
cfg80211 firewire_core mmc_core i2c_i801 rfkill crc_itu_t thermal evdev 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd iTCO_wdt soundcore 
iTCO_vendor_support ehci_hcd snd_page_alloc processor e1000e usbcore xfs 
sd_mod crc_t10dif ahci libahci libata scsi_mod cbc cryptd aes_x86_64 
aes_generic dm_crypt dm_mod [last unloaded: scsi_wait_scan]
[   24.328064] Pid: 2711, comm: syslog-ng Not tainted 3.0.0-rc4-00059-g143e859 
#10
[   24.328066] Call Trace:
[   24.328070]  [<ffffffff8103aa14>] warn_slowpath_common+0x7e/0x96
[   24.328073]  [<ffffffff8103aac0>] warn_slowpath_fmt+0x41/0x43
[   24.328076]  [<ffffffff81043da1>] ? ns_capable+0x35/0x4a
[   24.328079]  [<ffffffff8103b060>] do_syslog+0x89/0x438
[   24.328082]  [<ffffffff81103be8>] ? _d_rehash+0x44/0x46
[   24.328084]  [<ffffffff81103c10>] ? d_rehash+0x26/0x2b
[   24.328087]  [<ffffffff81143a53>] kmsg_open+0x17/0x19
[   24.328091]  [<ffffffff8113adfc>] proc_reg_open+0xab/0x148
[   24.328093]  [<ffffffff81143a3c>] ? kmsg_release+0x18/0x18
[   24.328096]  [<ffffffff81143a24>] ? seq_open_net+0x76/0x76
[   24.328098]  [<ffffffff8113ad51>] ? proc_alloc_inode+0x9c/0x9c
[   24.328102]  [<ffffffff810f11be>] __dentry_open+0x1fb/0x312
[   24.328105]  [<ffffffff810fc80f>] ? do_lookup+0x240/0x298
[   24.328108]  [<ffffffff810f2183>] nameidata_to_filp+0x5b/0x62
[   24.328111]  [<ffffffff810fe11e>] do_last+0x5c4/0x725
[   24.328114]  [<ffffffff810fedf3>] path_openat+0xc3/0x368
[   24.328117]  [<ffffffff8108b687>] ? call_rcu+0x10/0x12
[   24.328119]  [<ffffffff810fbec3>] ? putname+0x2d/0x36
[   24.328122]  [<ffffffff810ff0cb>] do_filp_open+0x33/0x81
[   24.328125]  [<ffffffff81108fe0>] ? alloc_fd+0x104/0x116
[   24.328128]  [<ffffffff810f2289>] do_sys_open+0xff/0x191
[   24.328130]  [<ffffffff810f2336>] sys_open+0x1b/0x1d
[   24.328135]  [<ffffffff814054fb>] system_call_fastpath+0x16/0x1b
[   24.328137] ---[ end trace 8722208fe06884da ]---
[   24.354551] auditd (2723): /proc/2723/oom_adj is deprecated, please use 
/proc/2723/oom_score_adj instead.
[   24.810919] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   24.810923] Bluetooth: BNEP filters: protocol multicast
[   24.841394] Bluetooth: RFCOMM TTY layer initialized
[   24.841398] Bluetooth: RFCOMM socket layer initialized
[   24.841400] Bluetooth: RFCOMM ver 1.11
[   25.655139] uhci_hcd 0000:00:1a.1: reserve dev 2 ep81-INT, period 1, phase 
0, 23 us
[   34.820517] ata1.00: configured for UDMA/133
[   34.820520] ata1: EH complete
[   43.715532] eth1: Wrong control channel in association response: configured 
center-freq: 2437 hti-cfreq: 2417  hti->control_chan: 2 band: 0.  Disabling 
HT.
[   57.854023] eth1: Wrong control channel in association response: configured 
center-freq: 2437 hti-cfreq: 2417  hti->control_chan: 2 band: 0.  Disabling 
HT.
[   62.261494] eth1: Wrong control channel in association response: configured 
center-freq: 2437 hti-cfreq: 2417  hti->control_chan: 2 band: 0.  Disabling 
HT.
[   68.673323] PM: Syncing filesystems ... done.
[   69.386251] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   69.400071] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) 
done.
[   69.416268] Suspending console(s) (use no_console_suspend to debug)
[   69.418375] usb 2-4: usb suspend
[   69.419611] uhci_hcd 0000:00:1a.0: release dev 2 ep82-INT, period 2, phase 
1, 17 us
[   69.420002] uhci_hcd 0000:00:1a.1: release dev 2 ep81-INT, period 1, phase 
0, 23 us
[   69.420583] uhci_hcd 0000:00:1a.0: release dev 2 ep81-INT, period 8, phase 
4, 17 us
[   69.421991] usb 4-2: usb suspend
[   69.422596] usb 3-1: usb suspend
[   69.581217] hub 4-0:1.0: hub_suspend
[   69.581224] hub 3-0:1.0: hub_suspend
[   69.581231] usb usb4: bus suspend
[   69.581236] usb usb3: bus suspend
[   69.581242] usb usb4: suspend_rh
[   69.581247] usb usb3: suspend_rh
[   69.604142] hub 2-0:1.0: hub_suspend
[   69.604151] usb usb2: bus suspend
[   69.604157] ehci_hcd 0000:00:1d.7: suspend root hub
[   69.604539] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   69.605363] sd 0:0:0:0: [sda] Stopping disk
[   69.689209] ACPI handle has no context!
[   69.689228] sdhci-pci 0000:15:00.2: PCI INT C disabled
[   69.689240] ACPI handle has no context!
[   69.689299] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[   69.689314] uhci_hcd 0000:00:1d.2: uhci_pci_suspend
[   69.689329] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[   69.689337] uhci_hcd 0000:00:1d.1: uhci_pci_suspend
[   69.689349] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[   69.689357] uhci_hcd 0000:00:1d.0: uhci_pci_suspend
[   69.689373] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[   69.689486] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[   69.689495] uhci_hcd 0000:00:1a.2: uhci_pci_suspend
[   69.689505] HDA Intel 0000:00:1b.0: PCI INT B disabled
[   69.689511] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[   69.689518] uhci_hcd 0000:00:1a.1: uhci_pci_suspend
[   69.689535] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[   69.689543] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[   69.689560] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[   69.696106] ACPI handle has no context!
[   69.704118] i915 0000:00:02.0: power state changed by ACPI to D3
[   69.784584] e1000e 0000:00:19.0: PCI INT A disabled
[   69.784598] e1000e 0000:00:19.0: PME# enabled
[   69.784615] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[   69.800088] PM: suspend of devices complete after 382.031 msecs
[   69.816219] ehci_hcd 0000:00:1d.7: wakeup: 0
[   69.832047] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[   69.832056] ehci_hcd 0000:00:1d.7: --> PCI D3hot
[   69.832104] uhci_hcd 0000:00:1d.2: wakeup: 0
[   69.832111] uhci_hcd 0000:00:1d.2: --> PCI D0
[   69.832158] uhci_hcd 0000:00:1d.1: wakeup: 0
[   69.832164] uhci_hcd 0000:00:1d.1: --> PCI D0
[   69.832211] uhci_hcd 0000:00:1d.0: wakeup: 0
[   69.832228] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[   69.832234] uhci_hcd 0000:00:1d.0: --> PCI D3hot
[   69.832292] ehci_hcd 0000:00:1a.7: wakeup: 0
[   69.848044] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[   69.848053] ehci_hcd 0000:00:1a.7: --> PCI D3hot
[   69.848101] uhci_hcd 0000:00:1a.2: wakeup: 0
[   69.848118] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D3
[   69.848123] uhci_hcd 0000:00:1a.2: --> PCI D3hot
[   69.848170] uhci_hcd 0000:00:1a.1: wakeup: 0
[   69.848177] uhci_hcd 0000:00:1a.1: --> PCI D0
[   69.848223] uhci_hcd 0000:00:1a.0: wakeup: 0
[   69.868043] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[   69.868049] uhci_hcd 0000:00:1a.0: --> PCI D3hot
[   69.868176] PM: late suspend of devices complete after 68.079 msecs
[   69.870233] ACPI: Preparing to enter system sleep state S3
[   70.028103] PM: Saving platform NVS memory
[   70.038400] Disabling non-boot CPUs ...
[   70.038812] Broke affinity for irq 9
[   70.038823] Broke affinity for irq 12
[   70.038841] Broke affinity for irq 17
[   70.140044] CPU 1 is now offline
[   70.140769] Extended CMOS year: 2000
[   70.140769] ACPI: Low-level resume complete
[   70.140769] PM: Restoring platform NVS memory
[   70.140769] Extended CMOS year: 2000
[   70.140769] Enabling non-boot CPUs ...
[   70.148930] Booting Node 0 Processor 1 APIC 0x1
[   70.148932] smpboot cpu 1: start_ip = 99000
[   70.039934] Disabled fast string operations
[   70.240124] Switched to NOHz mode on CPU #1
[   70.272756] CPU1 is up
[   70.274584] ACPI: Waking up from system sleep state S3
[   70.832235] i915 0000:00:02.0: restoring config space at offset 0x1 (was 
0x900007, writing 0x900407)
[   70.832294] pci 0000:00:02.1: restoring config space at offset 0x1 (was 
0x900000, writing 0x900007)
[   70.832321] pci 0000:00:03.0: restoring config space at offset 0xf (was 
0x100, writing 0x10b)
[   70.832347] pci 0000:00:03.0: restoring config space at offset 0x1 (was 
0x100006, writing 0x180006)
[   70.860046] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   70.860056] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   70.860104] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[   70.860127] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   70.860134] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   70.860184] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[   70.860209] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   70.860217] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   70.860263] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[   70.860284] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   70.860291] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   70.860350] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 
(was 0x2900106, writing 0x2900102)
[   70.860382] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   70.860391] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   70.860454] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 
(was 0x100106, writing 0x100102)
[   70.860518] pcieport 0000:00:1c.0: restoring config space at offset 0x9 
(was 0x1fff1, writing 0xc051c041)
[   70.860530] pcieport 0000:00:1c.0: restoring config space at offset 0x8 
(was 0xfff0, writing 0xc030c020)
[   70.860541] pcieport 0000:00:1c.0: restoring config space at offset 0x7 
(was 0xf0, writing 0x9090)
[   70.860564] pcieport 0000:00:1c.0: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[   70.860655] pcieport 0000:00:1c.1: restoring config space at offset 0x9 
(was 0x1fff1, writing 0xc011c001)
[   70.860669] pcieport 0000:00:1c.1: restoring config space at offset 0x7 
(was 0x200000f0, writing 0x8080)
[   70.860691] pcieport 0000:00:1c.1: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[   70.860798] pcieport 0000:00:1c.3: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[   70.860905] pcieport 0000:00:1c.4: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[   70.860964] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   70.860972] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   70.861018] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[   70.861039] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   70.861046] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   70.861095] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[   70.861158] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[   70.861231] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 
(was 0x2900106, writing 0x2900102)
[   70.861263] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   70.861273] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   70.861454] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 
0x2b00007, writing 0x2b00407)
[   70.876055] firewire_ohci 0000:15:00.1: BAR 0: set to [mem 
0xf4801000-0xf48017ff] (PCI address [0xf4801000-0xf48017ff])
[   70.876108] firewire_ohci 0000:15:00.1: restoring config space at offset 
0x3 (was 0x800000, writing 0x802010)
[   70.876123] firewire_ohci 0000:15:00.1: restoring config space at offset 
0x1 (was 0x2100000, writing 0x2100106)
[   70.892048] sdhci-pci 0000:15:00.2: BAR 0: set to [mem 
0xf4801800-0xf48018ff] (PCI address [0xf4801800-0xf48018ff])
[   70.892101] sdhci-pci 0000:15:00.2: restoring config space at offset 0x3 
(was 0x800000, writing 0x802010)
[   70.892116] sdhci-pci 0000:15:00.2: restoring config space at offset 0x1 
(was 0x2100000, writing 0x2100106)
[   70.893113] PM: early resume of devices complete after 61.027 msecs
[   70.893478] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 
21
[   70.893492] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   70.893501] uhci_hcd 0000:00:1a.1: uhci_pci_resume
[   70.893510] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x2f00
[   70.893516] uhci_hcd 0000:00:1a.1: Performing full reset
[   70.893548] usb usb4: root hub lost power or was reset
[   70.893611] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   70.893629] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   70.893641] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[   70.893651] e1000e 0000:00:19.0: PME# disabled
[   70.893661] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   70.893709] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 
17
[   70.893757] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   70.893765] uhci_hcd 0000:00:1d.1: uhci_pci_resume
[   70.893812] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2f00
[   70.893818] uhci_hcd 0000:00:1d.1: Performing full reset
[   70.893849] usb usb7: root hub lost power or was reset
[   70.893893] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 
17
[   70.893906] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   70.893974] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[   70.894039] i915 0000:00:02.0: power state changed by ACPI to D0
[   70.894072] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   70.894416] e1000e 0000:00:19.0: irq 48 for MSI/MSI-X
[   70.895407] usb usb4: usb resume
[   70.895413] usb usb4: wakeup_rh
[   70.895910] usb usb7: usb resume
[   70.895915] usb usb7: wakeup_rh
[   70.896585] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   70.896597] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[   70.896610] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   70.896617] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[   70.896626] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x2000
[   70.896631] uhci_hcd 0000:00:1a.0: Performing full reset
[   70.896666] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[   70.896674] usb usb3: root hub lost power or was reset
[   70.896682] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   70.896692] uhci_hcd 0000:00:1d.2: uhci_pci_resume
[   70.896700] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[   70.896705] uhci_hcd 0000:00:1d.2: Performing full reset
[   70.896736] usb usb8: root hub lost power or was reset
[   70.896769] usb usb3: usb resume
[   70.896773] usb usb3: wakeup_rh
[   70.896786] usb usb8: usb resume
[   70.896790] usb usb8: wakeup_rh
[   70.896831] pci 0000:00:1e.0: setting latency timer to 64
[   70.896858] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   70.896870] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 
22
[   70.896882] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   70.896889] uhci_hcd 0000:00:1a.2: uhci_pci_resume
[   70.896898] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x2000
[   70.896903] uhci_hcd 0000:00:1a.2: Performing full reset
[   70.896934] usb usb5: root hub lost power or was reset
[   70.896972] sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[   70.896979] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW 
doesn't fully claim to support it.
[   70.898017] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   70.898030] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 
23
[   70.898043] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   70.898129] usb usb5: usb resume
[   70.898134] usb usb5: wakeup_rh
[   70.898161] usb usb1: usb resume
[   70.898168] ehci_hcd 0000:00:1a.7: resume root hub
[   70.898208] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   70.898232] i915 0000:00:02.0: power state changed by ACPI to D0
[   70.898244] i915 0000:00:02.0: setting latency timer to 64
[   70.904067] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   70.904081] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16
[   70.904097] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   70.904105] uhci_hcd 0000:00:1d.0: uhci_pci_resume
[   70.904114] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2000
[   70.904122] ahci 0000:00:1f.2: setting latency timer to 64
[   70.904129] uhci_hcd 0000:00:1d.0: Performing full reset
[   70.904167] usb usb6: root hub lost power or was reset
[   70.904260] usb usb6: usb resume
[   70.904265] usb usb6: wakeup_rh
[   70.904302] sd 0:0:0:0: [sda] Starting disk
[   70.904334] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   70.904341] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 
19
[   70.904347] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   70.904435] usb usb2: usb resume
[   70.904438] ehci_hcd 0000:00:1d.7: resume root hub
[   70.908097] hub 7-0:1.0: hub_reset_resume
[   70.908099] hub 7-0:1.0: trying to enable port power on non-switchable hub
[   70.908107] hub 4-0:1.0: hub_reset_resume
[   70.908109] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   70.912058] hub 5-0:1.0: hub_reset_resume
[   70.912060] hub 5-0:1.0: trying to enable port power on non-switchable hub
[   70.912065] hub 8-0:1.0: hub_reset_resume
[   70.912067] hub 8-0:1.0: trying to enable port power on non-switchable hub
[   70.912071] hub 3-0:1.0: hub_reset_resume
[   70.912073] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   70.918227] legacy_resume(): pnp_bus_resume+0x0/0x67 returns -19
[   70.918230] PM: Device 00:0a failed to resume: error -19
[   70.920016] hub 6-0:1.0: hub_reset_resume
[   70.920018] hub 6-0:1.0: trying to enable port power on non-switchable hub
[   70.932053] hub 2-0:1.0: hub_resume
[   70.932066] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001002 0  ACK 
POWER sig=se0 CSC
[   70.932069] hub 2-0:1.0: port 4: status 0100 change 0001
[   70.960157] firewire_core: skipped bus generations, destroying all nodes
[   70.990691] Extended CMOS year: 2000
[   71.012148] uhci_hcd 0000:00:1a.1: port 2 portsc 008a,00
[   71.012157] hub 4-0:1.0: port 2: status 0100 change 0003
[   71.016157] uhci_hcd 0000:00:1a.0: port 1 portsc 008a,00
[   71.016167] hub 3-0:1.0: port 1: status 0100 change 0003
[   71.028331] ehci_hcd 0000:00:1a.7: port 4 full speed --> companion
[   71.028343] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003801 0  ACK 
POWER OWNER sig=j CONNECT
[   71.028582] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001802 0  ACK 
POWER sig=j CSC
[   71.028590] ehci_hcd 0000:00:1a.7: failed handover port 1: 1800
[   71.036123] hub 2-0:1.0: port 4 status 0000.0100 after resume, -19
[   71.036129] usb 2-4: can't resume, status -19
[   71.036133] hub 2-0:1.0: logical disconnect on port 4
[   71.044112] hub 1-0:1.0: hub_resume
[   71.044126] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[   71.044135] hub 1-0:1.0: port 1: status 0501 change 0001
[   71.044161] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003002 0  ACK 
POWER OWNER sig=se0 CSC
[   71.044184] ehci_hcd 0000:00:1a.7: GetStatus port:6 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[   71.044192] hub 1-0:1.0: port 6: status 0501 change 0001
[   71.148149] usb 1-6: finish reset-resume
[   71.148180] uhci_hcd 0000:00:1a.1: port 2 portsc 0093,00
[   71.148192] hub 3-0:1.0: port 1 status 0000.0100 after resume, -19
[   71.148198] usb 4-2: finish reset-resume
[   71.148204] usb 3-1: can't resume, status -19
[   71.148209] hub 3-0:1.0: logical disconnect on port 1
[   71.204332] ehci_hcd 0000:00:1a.7: port 6 high speed
[   71.204343] ehci_hcd 0000:00:1a.7: GetStatus port:6 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[   71.224127] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   71.224170] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   71.227031] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[   71.228123] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[   71.228132] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[   71.232758] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[   71.233937] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[   71.233945] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[   71.234949] ata2.00: configured for UDMA/100
[   71.260087] usb 1-6: reset high speed USB device number 4 using ehci_hcd
[   71.295798] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   71.295807] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[   71.295816] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[   71.316331] ehci_hcd 0000:00:1a.7: port 6 high speed
[   71.316342] ehci_hcd 0000:00:1a.7: GetStatus port:6 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[   71.405659] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   71.405668] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[   71.405677] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[   71.455450] ata1.00: configured for UDMA/133
[   71.460318] firewire_core: rediscovered device fw0
[   71.495341] thinkpad_acpi: restoring fan level to 0x07
[   71.504089] usb 4-2: reset full speed USB device number 2 using uhci_hcd
[   71.650464] btusb 4-2:1.0: no reset_resume for driver btusb?
[   71.650466] btusb 4-2:1.1: no reset_resume for driver btusb?
[   71.650468] btusb 4-2:1.0: forced unbind
[   71.900416] PM: resume of devices complete after 1007.170 msecs
[   71.900461] btusb 4-2:1.0: usb_probe_interface
[   71.900467] btusb 4-2:1.0: usb_probe_interface - got id
[   71.900816] uhci_hcd 0000:00:1a.1: reserve dev 2 ep81-INT, period 1, phase 
0, 23 us
[   71.901497] Restarting tasks ... 
[   71.901598] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   71.901615] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   71.901625] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   71.901635] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   71.901644] hub 2-0:1.0: state 7 ports 6 chg 0010 evt 0000
[   71.901660] hub 2-0:1.0: port 4, status 0100, change 0000, 12 Mb/s
[   71.901667] usb 2-4: USB disconnect, device number 2
[   71.901672] usb 2-4: unregistering device
[   71.901677] usb 2-4: unregistering interface 2-4:1.0
[   71.901762] usb 2-4: unregistering interface 2-4:1.1
[   71.909030] usb 2-4: unregistering interface 2-4:1.2
[   71.909131] usb 2-4: unregistering interface 2-4:1.3
[   71.909532] usb 2-4: unregistering interface 2-4:1.4
[   71.909628] usb 2-4: unregistering interface 2-4:1.5
[   71.909679] drivers/usb/core/file.c: removing 0 minor
[   71.909813] usb 2-4: unregistering interface 2-4:1.6
[   71.909863] drivers/usb/core/file.c: removing 1 minor
[   71.909993] usb 2-4: unregistering interface 2-4:1.7
[   71.910049] cdc_ether 2-4:1.7: wwan0: unregister 'cdc_ether' 
usb-0000:00:1d.7-4, Mobile Broadband Network Device
[   71.924196] usb 2-4: unregistering interface 2-4:1.8
[   71.924308] usb 2-4: unregistering interface 2-4:1.9
[   71.924655] usb 2-4: unregistering interface 2-4:1.10
[   71.924688] done.
[   71.924692] usb 2-4: usb_disable_device nuking all URBs
[   71.924694] video LNXVIDEO:00: Restoring backlight state
[   71.924798] hub 4-0:1.0: state 7 ports 2 chg 0004 evt 0004
[   71.924809] hub 4-0:1.0: port 2, status 0103, change 0000, 12 Mb/s
[   71.924813] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[   71.924821] hub 3-0:1.0: port 1, status 0100, change 0000, 12 Mb/s
[   71.924824] usb 3-1: USB disconnect, device number 2
[   71.924825] usb 3-1: unregistering device
[   71.924827] usb 3-1: unregistering interface 3-1:1.0
[   71.952447] usb 3-1: unregistering interface 3-1:1.1
[   71.990406] drivers/usb/core/file.c: removing 2 minor
[   71.990543] usb 3-1: unregistering interface 3-1:1.2
[   71.990575] drivers/usb/core/file.c: removing 3 minor
[   71.990683] usb 3-1: usb_disable_device nuking all URBs
[   72.004181] hub 1-0:1.0: state 7 ports 6 chg 0042 evt 0000
[   72.004193] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[   72.060203] ehci_hcd 0000:00:1a.7: port 1 full speed --> companion
[   72.060209] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003801 0  ACK 
POWER OWNER sig=j CONNECT
[   72.060214] hub 1-0:1.0: port 1 not reset yet, waiting 50ms
[   72.072024] usb usb8: suspend_rh (auto-stop)
[   72.072040] usb usb6: suspend_rh (auto-stop)
[   72.072053] usb usb5: suspend_rh (auto-stop)
[   72.072068] usb usb7: suspend_rh (auto-stop)
[   72.116030] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003002 0  ACK 
POWER OWNER sig=se0 CSC
[   72.116060] hub 1-0:1.0: port 6, status 0503, change 0000, 480 Mb/s
[   72.116064] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0002
[   72.116072] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
[   72.116081] uhci_hcd 0000:00:1a.0: port 1 portsc 0093,00
[   72.116087] hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[   72.248058] hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 
0x101
[   72.360042] usb 3-1: new full speed USB device number 3 using uhci_hcd
[   72.496585] usb 3-1: ep0 maxpacket = 8
[   72.529819] usb 3-1: skipped 1 descriptor after interface
[   72.529830] usb 3-1: skipped 1 descriptor after interface
[   72.529838] usb 3-1: skipped 1 descriptor after interface
[   72.534933] usb 3-1: default language 0x0409
[   72.549809] usb 3-1: udev 3, busnum 3, minor = 258
[   72.549816] usb 3-1: New USB device found, idVendor=046d, idProduct=c52b
[   72.549823] usb 3-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[   72.549830] usb 3-1: Product: USB Receiver
[   72.549835] usb 3-1: Manufacturer: Logitech
[   72.550143] usb 3-1: usb_probe_device
[   72.550152] usb 3-1: configuration #1 chosen from 1 choice
[   72.555814] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[   72.555907] usbhid 3-1:1.0: usb_probe_interface
[   72.555913] usbhid 3-1:1.0: usb_probe_interface - got id
[   72.558402] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input16
[   72.558426] uhci_hcd 0000:00:1a.0: reserve dev 3 ep81-INT, period 8, phase 
4, 17 us
[   72.558671] generic-usb 0003:046D:C52B.0004: input,hidraw0: USB HID v1.11 
Keyboard [Logitech USB Receiver] on usb-0000:00:1a.0-1/input0
[   72.558714] usb 3-1: adding 3-1:1.1 (config #1, interface 1)
[   72.558808] usbhid 3-1:1.1: usb_probe_interface
[   72.558815] usbhid 3-1:1.1: usb_probe_interface - got id
[   72.562896] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.1/input/input17
[   72.562914] uhci_hcd 0000:00:1a.0: reserve dev 3 ep82-INT, period 2, phase 
1, 17 us
[   72.563171] usbhid 3-1:1.1: looking for a minor, starting at 0
[   72.563424] generic-usb 0003:046D:C52B.0005: input,hiddev0,hidraw1: USB HID 
v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1/input1
[   72.563470] usb 3-1: adding 3-1:1.2 (config #1, interface 2)
[   72.563545] usbhid 3-1:1.2: usb_probe_interface
[   72.563552] usbhid 3-1:1.2: usb_probe_interface - got id
[   72.568833] usbhid 3-1:1.2: looking for a minor, starting at 0
[   72.569063] generic-usb 0003:046D:C52B.0006: hiddev0,hidraw2: USB HID v1.11 
Device [Logitech USB Receiver] on usb-0000:00:1a.0-1/input2
[   72.569176] drivers/usb/core/inode.c: creating file '003'
[   73.900130] hub 7-0:1.0: hub_suspend
[   73.900148] usb usb7: bus auto-suspend
[   73.900154] usb usb7: suspend_rh
[   73.900181] hub 8-0:1.0: hub_suspend
[   73.900189] usb usb8: bus auto-suspend
[   73.900194] usb usb8: suspend_rh
[   73.900218] hub 5-0:1.0: hub_suspend
[   73.900226] usb usb5: bus auto-suspend
[   73.900231] usb usb5: suspend_rh
[   73.900254] hub 6-0:1.0: hub_suspend
[   73.900262] usb usb6: bus auto-suspend
[   73.900267] usb usb6: suspend_rh
[   73.924113] hub 2-0:1.0: hub_suspend
[   73.924125] usb usb2: bus auto-suspend
[   73.924132] ehci_hcd 0000:00:1d.7: suspend root hub
[   75.534232] usb usb2: usb wakeup-resume
[   75.534246] usb usb2: usb auto-resume
[   75.534254] ehci_hcd 0000:00:1d.7: resume root hub
[   75.560046] hub 2-0:1.0: hub_resume
[   75.560085] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[   75.560095] hub 2-0:1.0: port 4: status 0501 change 0001
[   75.664174] hub 2-0:1.0: state 7 ports 6 chg 0010 evt 0000
[   75.664201] hub 2-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[   75.720292] ehci_hcd 0000:00:1d.7: port 4 high speed
[   75.720306] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[   75.776064] usb 2-4: new high speed USB device number 3 using ehci_hcd
[   75.912417] ehci_hcd 0000:00:1d.7: port 4 high speed
[   75.912431] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[   76.639475] usb 2-4: skipped 3 descriptors after interface
[   76.639485] usb 2-4: skipped 4 descriptors after interface
[   76.639494] usb 2-4: skipped 4 descriptors after interface
[   76.639502] usb 2-4: skipped 2 descriptors after interface
[   76.639509] usb 2-4: skipped 2 descriptors after interface
[   76.639517] usb 2-4: skipped 5 descriptors after interface
[   76.639526] usb 2-4: skipped 4 descriptors after interface
[   76.714613] usb 2-4: skipped 3 descriptors after interface
[   76.714621] usb 2-4: skipped 4 descriptors after interface
[   76.714629] usb 2-4: skipped 4 descriptors after interface
[   76.714637] usb 2-4: skipped 2 descriptors after interface
[   76.714645] usb 2-4: skipped 2 descriptors after interface
[   76.714652] usb 2-4: skipped 5 descriptors after interface
[   76.714957] usb 2-4: default language 0x0409
[   76.746089] usb 2-4: udev 3, busnum 2, minor = 130
[   76.746096] usb 2-4: New USB device found, idVendor=0bdb, idProduct=1900
[   76.746104] usb 2-4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[   76.746110] usb 2-4: Product: Ericsson F3507g Mobile Broadband Minicard 
Composite Device
[   76.746116] usb 2-4: Manufacturer: Ericsson
[   76.746121] usb 2-4: SerialNumber: 3541430228088360
[   76.746436] usb 2-4: usb_probe_device
[   76.746445] usb 2-4: configuration #1 chosen from 2 choices
[   76.749440] usb 2-4: adding 2-4:1.0 (config #1, interface 0)
[   76.749874] usb 2-4: adding 2-4:1.1 (config #1, interface 1)
[   76.771139] cdc_acm 2-4:1.1: usb_probe_interface
[   76.771148] cdc_acm 2-4:1.1: usb_probe_interface - got id
[   76.771338] cdc_acm 2-4:1.1: ttyACM0: USB ACM device
[   76.772091] usb 2-4: adding 2-4:1.2 (config #1, interface 2)
[   76.785693] usb 2-4: adding 2-4:1.3 (config #1, interface 3)
[   76.795497] cdc_acm 2-4:1.3: usb_probe_interface
[   76.795507] cdc_acm 2-4:1.3: usb_probe_interface - got id
[   76.795698] cdc_acm 2-4:1.3: ttyACM1: USB ACM device
[   76.796425] usb 2-4: adding 2-4:1.4 (config #1, interface 4)
[   76.800801] usb 2-4: adding 2-4:1.5 (config #1, interface 5)
[   76.808885] cdc_wdm 2-4:1.5: usb_probe_interface
[   76.808892] cdc_wdm 2-4:1.5: usb_probe_interface - got id
[   76.808906] cdc_wdm 2-4:1.5: looking for a minor, starting at 0
[   76.809027] cdc_wdm 2-4:1.5: cdc-wdm-174: USB WDM device
[   76.809069] usb 2-4: adding 2-4:1.6 (config #1, interface 6)
[   76.812300] cdc_wdm 2-4:1.6: usb_probe_interface
[   76.812308] cdc_wdm 2-4:1.6: usb_probe_interface - got id
[   76.812320] cdc_wdm 2-4:1.6: looking for a minor, starting at 0
[   76.812493] cdc_wdm 2-4:1.6: cdc-wdm-173: USB WDM device
[   76.812537] usb 2-4: adding 2-4:1.7 (config #1, interface 7)
[   76.819249] cdc_ether 2-4:1.7: usb_probe_interface
[   76.819257] cdc_ether 2-4:1.7: usb_probe_interface - got id
[   76.822114] cdc_ether 2-4:1.7: wwan0: register 'cdc_ether' at 
usb-0000:00:1d.7-4, Mobile Broadband Network Device, 02:80:37:ec:02:00
[   76.822162] usb 2-4: adding 2-4:1.8 (config #1, interface 8)
[   76.826670] usb 2-4: adding 2-4:1.9 (config #1, interface 9)
[   76.829994] cdc_acm 2-4:1.9: usb_probe_interface
[   76.830006] cdc_acm 2-4:1.9: usb_probe_interface - got id
[   76.830203] cdc_acm 2-4:1.9: ttyACM2: USB ACM device
[   76.830953] usb 2-4: adding 2-4:1.10 (config #1, interface 10)
[   76.836988] drivers/usb/core/inode.c: creating file '003'
[   81.278481] eth1: Wrong control channel in association response: configured 
center-freq: 2437 hti-cfreq: 2417  hti->control_chan: 2 band: 0.  Disabling 
HT.
[   81.376626] eth1: Wrong control channel in association response: configured 
center-freq: 2437 hti-cfreq: 2417  hti->control_chan: 2 band: 0.  Disabling 
HT.
[   81.481127] eth1: Wrong control channel in association response: configured 
center-freq: 2437 hti-cfreq: 2417  hti->control_chan: 2 band: 0.  Disabling 
HT.
[   93.566476] eth1: Wrong control channel in association response: configured 
center-freq: 2437 hti-cfreq: 2417  hti->control_chan: 2 band: 0.  Disabling 
HT.
[   93.664806] eth1: Wrong control channel in association response: configured 
center-freq: 2437 hti-cfreq: 2417  hti->control_chan: 2 band: 0.  Disabling 
HT.
[  107.953912] PM: Syncing filesystems ... done.
[  109.833518] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  109.848160] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) 
done.
[  109.864266] Suspending console(s) (use no_console_suspend to debug)
[  109.865888] usb 1-6: usb auto-suspend
[  109.880434] usb 2-4: usb suspend
[  109.881831] uhci_hcd 0000:00:1a.0: release dev 3 ep82-INT, period 2, phase 
1, 17 us
[  109.882475] uhci_hcd 0000:00:1a.1: release dev 2 ep81-INT, period 1, phase 
0, 23 us
[  109.882823] uhci_hcd 0000:00:1a.0: release dev 3 ep81-INT, period 8, phase 
4, 17 us
[  109.884471] usb 4-2: usb suspend
[  109.884818] usb 3-1: usb suspend
[  110.036474] hub 4-0:1.0: hub_suspend
[  110.036485] usb usb4: bus suspend
[  110.036491] usb usb4: suspend_rh
[  110.036497] hub 3-0:1.0: hub_suspend
[  110.036508] usb usb3: bus suspend
[  110.036513] usb usb3: suspend_rh
[  110.045988] hub 2-0:1.0: hub_suspend
[  110.045997] usb usb2: bus suspend
[  110.046003] ehci_hcd 0000:00:1d.7: suspend root hub
[  110.046051] hub 1-0:1.0: hub_suspend
[  110.046059] usb usb1: bus suspend
[  110.046063] ehci_hcd 0000:00:1a.7: suspend root hub
[  110.046519] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  110.057552] sd 0:0:0:0: [sda] Stopping disk
[  110.129247] ACPI handle has no context!
[  110.129265] sdhci-pci 0000:15:00.2: PCI INT C disabled
[  110.129277] ACPI handle has no context!
[  110.129314] uhci_hcd 0000:00:1d.2: uhci_pci_suspend
[  110.129323] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[  110.129331] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  110.129336] uhci_hcd 0000:00:1d.1: uhci_pci_suspend
[  110.129345] uhci_hcd 0000:00:1d.0: uhci_pci_suspend
[  110.129350] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  110.129358] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  110.129426] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[  110.129433] HDA Intel 0000:00:1b.0: PCI INT B disabled
[  110.129439] uhci_hcd 0000:00:1a.2: uhci_pci_suspend
[  110.129457] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[  110.129465] uhci_hcd 0000:00:1a.1: uhci_pci_suspend
[  110.129483] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[  110.129490] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[  110.129507] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  110.136104] ACPI handle has no context!
[  110.144081] i915 0000:00:02.0: power state changed by ACPI to D3
[  110.224572] e1000e 0000:00:19.0: PME# enabled
[  110.224589] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[  110.240070] PM: suspend of devices complete after 359.775 msecs
[  110.256213] ehci_hcd 0000:00:1d.7: wakeup: 0
[  110.272036] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[  110.272045] ehci_hcd 0000:00:1d.7: --> PCI D3hot
[  110.272094] uhci_hcd 0000:00:1d.2: wakeup: 0
[  110.272100] uhci_hcd 0000:00:1d.2: --> PCI D0
[  110.272147] uhci_hcd 0000:00:1d.1: wakeup: 0
[  110.272154] uhci_hcd 0000:00:1d.1: --> PCI D0
[  110.272200] uhci_hcd 0000:00:1d.0: wakeup: 0
[  110.272218] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[  110.272223] uhci_hcd 0000:00:1d.0: --> PCI D3hot
[  110.272539] ehci_hcd 0000:00:1a.7: wakeup: 0
[  110.288046] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[  110.288055] ehci_hcd 0000:00:1a.7: --> PCI D3hot
[  110.288102] uhci_hcd 0000:00:1a.2: wakeup: 0
[  110.288119] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D3
[  110.288125] uhci_hcd 0000:00:1a.2: --> PCI D3hot
[  110.288171] uhci_hcd 0000:00:1a.1: wakeup: 0
[  110.288178] uhci_hcd 0000:00:1a.1: --> PCI D0
[  110.288225] uhci_hcd 0000:00:1a.0: wakeup: 0
[  110.308044] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[  110.308051] uhci_hcd 0000:00:1a.0: --> PCI D3hot
[  110.308177] PM: late suspend of devices complete after 68.098 msecs
[  110.310228] ACPI: Preparing to enter system sleep state S3
[  110.468104] PM: Saving platform NVS memory
[  110.478410] Disabling non-boot CPUs ...
[  110.478860] Broke affinity for irq 19
[  110.580044] CPU 1 is now offline
[  110.580699] Extended CMOS year: 2000
[  110.580699] ACPI: Low-level resume complete
[  110.580699] PM: Restoring platform NVS memory
[  110.580699] Extended CMOS year: 2000
[  110.580699] Enabling non-boot CPUs ...
[  110.588870] Booting Node 0 Processor 1 APIC 0x1
[  110.588872] smpboot cpu 1: start_ip = 99000
[  110.479934] Disabled fast string operations
[  110.680117] Switched to NOHz mode on CPU #1
[  110.697048] CPU1 is up
[  110.702476] ACPI: Waking up from system sleep state S3
[  111.248232] i915 0000:00:02.0: restoring config space at offset 0x1 (was 
0x900007, writing 0x900407)
[  111.248291] pci 0000:00:02.1: restoring config space at offset 0x1 (was 
0x900000, writing 0x900007)
[  111.248317] pci 0000:00:03.0: restoring config space at offset 0xf (was 
0x100, writing 0x10b)
[  111.248344] pci 0000:00:03.0: restoring config space at offset 0x1 (was 
0x100006, writing 0x180006)
[  111.268042] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  111.268052] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  111.268100] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[  111.268123] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  111.268130] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  111.268180] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[  111.268205] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[  111.268212] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[  111.268259] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[  111.268280] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[  111.268287] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[  111.268346] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 
(was 0x2900106, writing 0x2900102)
[  111.268378] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[  111.268388] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[  111.268450] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 
(was 0x100106, writing 0x100102)
[  111.268514] pcieport 0000:00:1c.0: restoring config space at offset 0x9 
(was 0x1fff1, writing 0xc051c041)
[  111.268526] pcieport 0000:00:1c.0: restoring config space at offset 0x8 
(was 0xfff0, writing 0xc030c020)
[  111.268537] pcieport 0000:00:1c.0: restoring config space at offset 0x7 
(was 0xf0, writing 0x9090)
[  111.268559] pcieport 0000:00:1c.0: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[  111.268651] pcieport 0000:00:1c.1: restoring config space at offset 0x9 
(was 0x1fff1, writing 0xc011c001)
[  111.268664] pcieport 0000:00:1c.1: restoring config space at offset 0x7 
(was 0x200000f0, writing 0x20008080)
[  111.268686] pcieport 0000:00:1c.1: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[  111.268793] pcieport 0000:00:1c.3: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[  111.268900] pcieport 0000:00:1c.4: restoring config space at offset 0x1 
(was 0x100107, writing 0x100507)
[  111.268960] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  111.268967] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  111.269013] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[  111.269035] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  111.269042] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  111.269090] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[  111.269154] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 
(was 0x2900005, writing 0x2900001)
[  111.269227] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 
(was 0x2900106, writing 0x2900102)
[  111.269259] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[  111.269269] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[  111.269451] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 
0x2b00007, writing 0x2b00407)
[  111.269636] iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 
0x100106, writing 0x100506)
[  111.284053] firewire_ohci 0000:15:00.1: BAR 0: set to [mem 
0xf4801000-0xf48017ff] (PCI address [0xf4801000-0xf48017ff])
[  111.284106] firewire_ohci 0000:15:00.1: restoring config space at offset 
0x3 (was 0x800000, writing 0x802010)
[  111.284121] firewire_ohci 0000:15:00.1: restoring config space at offset 
0x1 (was 0x2100000, writing 0x2100106)
[  111.300049] sdhci-pci 0000:15:00.2: BAR 0: set to [mem 
0xf4801800-0xf48018ff] (PCI address [0xf4801800-0xf48018ff])
[  111.300102] sdhci-pci 0000:15:00.2: restoring config space at offset 0x3 
(was 0x800000, writing 0x802010)
[  111.300117] sdhci-pci 0000:15:00.2: restoring config space at offset 0x1 
(was 0x2100000, writing 0x2100106)
[  111.301113] PM: early resume of devices complete after 53.029 msecs
[  111.301307] i915 0000:00:02.0: power state changed by ACPI to D0
[  111.301319] i915 0000:00:02.0: power state changed by ACPI to D0
[  111.301331] i915 0000:00:02.0: setting latency timer to 64
[  111.301687] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[  111.301699] e1000e 0000:00:19.0: PME# disabled
[  111.301817] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[  111.303982] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  111.303990] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  111.304026] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[  111.304039] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  111.304048] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[  111.304057] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x2f00
[  111.304062] uhci_hcd 0000:00:1a.0: Performing full reset
[  111.304094] usb usb3: root hub lost power or was reset
[  111.304121] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 
21
[  111.304133] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[  111.304141] uhci_hcd 0000:00:1a.1: uhci_pci_resume
[  111.304148] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x2000
[  111.304153] uhci_hcd 0000:00:1a.1: Performing full reset
[  111.304183] usb usb4: root hub lost power or was reset
[  111.304202] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[  111.304209] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[  111.304219] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 
22
[  111.304231] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[  111.304238] uhci_hcd 0000:00:1a.2: uhci_pci_resume
[  111.304246] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x2000
[  111.304251] uhci_hcd 0000:00:1a.2: Performing full reset
[  111.304281] usb usb5: root hub lost power or was reset
[  111.304302] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[  111.304312] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[  111.304324] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 
23
[  111.304337] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[  111.304433] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 
17
[  111.304446] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  111.304509] HDA Intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[  111.304612] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  111.304620] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  111.304630] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16
[  111.304642] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  111.304649] uhci_hcd 0000:00:1d.0: uhci_pci_resume
[  111.304657] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2f00
[  111.304663] uhci_hcd 0000:00:1d.0: Performing full reset
[  111.304694] usb usb6: root hub lost power or was reset
[  111.304716] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 
17
[  111.304727] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  111.304735] uhci_hcd 0000:00:1d.1: uhci_pci_resume
[  111.304742] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
[  111.304747] uhci_hcd 0000:00:1d.1: Performing full reset
[  111.304777] usb usb7: root hub lost power or was reset
[  111.304798] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[  111.304810] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  111.304817] uhci_hcd 0000:00:1d.2: uhci_pci_resume
[  111.304825] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[  111.304830] uhci_hcd 0000:00:1d.2: Performing full reset
[  111.304860] usb usb8: root hub lost power or was reset
[  111.304880] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[  111.304890] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[  111.304903] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 
19
[  111.304915] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  111.304999] pci 0000:00:1e.0: setting latency timer to 64
[  111.305026] ahci 0000:00:1f.2: setting latency timer to 64
[  111.305137] sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[  111.305145] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW 
doesn't fully claim to support it.
[  111.305183] sd 0:0:0:0: [sda] Starting disk
[  111.305238] usb usb1: usb resume
[  111.305244] ehci_hcd 0000:00:1a.7: resume root hub
[  111.305277] usb usb2: usb resume
[  111.305283] ehci_hcd 0000:00:1d.7: resume root hub
[  111.305315] usb usb3: usb resume
[  111.305320] usb usb3: wakeup_rh
[  111.305375] usb usb4: usb resume
[  111.305380] usb usb4: wakeup_rh
[  111.305433] usb usb5: usb resume
[  111.305437] usb usb5: wakeup_rh
[  111.305471] usb usb6: usb resume
[  111.305475] usb usb6: wakeup_rh
[  111.305510] usb usb7: usb resume
[  111.305515] usb usb7: wakeup_rh
[  111.305549] usb usb8: usb resume
[  111.305553] usb usb8: wakeup_rh
[  111.320154] hub 3-0:1.0: hub_reset_resume
[  111.320156] hub 3-0:1.0: trying to enable port power on non-switchable hub
[  111.320164] hub 4-0:1.0: hub_reset_resume
[  111.320166] hub 4-0:1.0: trying to enable port power on non-switchable hub
[  111.320170] hub 5-0:1.0: hub_reset_resume
[  111.320171] hub 5-0:1.0: trying to enable port power on non-switchable hub
[  111.320175] hub 6-0:1.0: hub_reset_resume
[  111.320177] hub 6-0:1.0: trying to enable port power on non-switchable hub
[  111.320181] hub 7-0:1.0: hub_reset_resume
[  111.320183] hub 7-0:1.0: trying to enable port power on non-switchable hub
[  111.320187] hub 8-0:1.0: hub_reset_resume
[  111.320188] hub 8-0:1.0: trying to enable port power on non-switchable hub
[  111.320234] legacy_resume(): pnp_bus_resume+0x0/0x67 returns -19
[  111.320236] PM: Device 00:0a failed to resume: error -19
[  111.332017] hub 2-0:1.0: hub_resume
[  111.332032] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001002 0  ACK 
POWER sig=se0 CSC
[  111.332035] hub 2-0:1.0: port 4: status 0100 change 0001
[  111.368123] firewire_core: skipped bus generations, destroying all nodes
[  111.402630] Extended CMOS year: 2000
[  111.424089] uhci_hcd 0000:00:1a.0: port 1 portsc 008a,00
[  111.424098] hub 3-0:1.0: port 1: status 0100 change 0003
[  111.424141] uhci_hcd 0000:00:1a.1: port 2 portsc 008a,00
[  111.424148] hub 4-0:1.0: port 2: status 0100 change 0003
[  111.436176] hub 2-0:1.0: port 4 status 0000.0100 after resume, -19
[  111.436182] usb 2-4: can't resume, status -19
[  111.436187] hub 2-0:1.0: logical disconnect on port 4
[  111.436406] ehci_hcd 0000:00:1a.7: port 4 full speed --> companion
[  111.436417] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003801 0  ACK 
POWER OWNER sig=j CONNECT
[  111.439007] ehci_hcd 0000:00:1a.7: port 1 reset error -110
[  111.439014] ehci_hcd 0000:00:1a.7: failed handover port 1: 1100
[  111.452114] hub 1-0:1.0: hub_resume
[  111.452128] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[  111.452138] hub 1-0:1.0: port 1: status 0501 change 0001
[  111.452164] ehci_hcd 0000:00:1a.7: GetStatus port:4 status 003002 0  ACK 
POWER OWNER sig=se0 CSC
[  111.452188] ehci_hcd 0000:00:1a.7: GetStatus port:6 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[  111.452196] hub 1-0:1.0: port 6: status 0501 change 0001
[  111.556170] uhci_hcd 0000:00:1a.1: port 2 portsc 0093,00
[  111.556184] usb 4-2: finish reset-resume
[  111.556196] usb 1-6: finish reset-resume
[  111.556215] hub 3-0:1.0: port 1 status 0000.0100 after resume, -19
[  111.556221] usb 3-1: can't resume, status -19
[  111.556225] hub 3-0:1.0: logical disconnect on port 1
[  111.624093] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  111.624135] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  111.626995] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[  111.628094] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[  111.628104] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[  111.632363] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[  111.633440] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[  111.633448] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[  111.634454] ata2.00: configured for UDMA/100
[  111.668093] usb 4-2: reset full speed USB device number 2 using uhci_hcd
[  111.768099] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  111.768109] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[  111.768117] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[  111.814434] btusb 4-2:1.0: no reset_resume for driver btusb?
[  111.814440] btusb 4-2:1.1: no reset_resume for driver btusb?
[  111.814447] btusb 4-2:1.0: forced unbind
[  111.856532] ehci_hcd 0000:00:1a.7: port 6 high speed
[  111.856544] ehci_hcd 0000:00:1a.7: GetStatus port:6 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[  111.868129] firewire_core: rediscovered device fw0
[  111.912085] usb 1-6: reset high speed USB device number 4 using ehci_hcd
[  111.914281] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  111.914290] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[  111.914299] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[  111.968281] ehci_hcd 0000:00:1a.7: port 6 high speed
[  111.968292] ehci_hcd 0000:00:1a.7: GetStatus port:6 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[  111.974163] ata1.00: configured for UDMA/133
[  112.022159] thinkpad_acpi: restoring fan level to 0x07
[  112.215418] PM: resume of devices complete after 914.176 msecs
[  112.215488] btusb 4-2:1.0: usb_probe_interface
[  112.215495] btusb 4-2:1.0: usb_probe_interface - got id
[  112.215818] uhci_hcd 0000:00:1a.1: reserve dev 2 ep81-INT, period 1, phase 
0, 23 us
[  112.216487] Restarting tasks ... 
[  112.216580] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  112.216596] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  112.216606] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  112.216615] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  112.216624] hub 2-0:1.0: state 7 ports 6 chg 0010 evt 0000
[  112.216640] hub 2-0:1.0: port 4, status 0100, change 0000, 12 Mb/s
[  112.216647] usb 2-4: USB disconnect, device number 3
[  112.216652] usb 2-4: unregistering device
[  112.216658] usb 2-4: unregistering interface 2-4:1.0
[  112.216828] usb 2-4: unregistering interface 2-4:1.1
[  112.217712] usb 2-4: unregistering interface 2-4:1.2
[  112.217813] usb 2-4: unregistering interface 2-4:1.3
[  112.218233] usb 2-4: unregistering interface 2-4:1.4
[  112.218333] usb 2-4: unregistering interface 2-4:1.5
[  112.218401] drivers/usb/core/file.c: removing 2 minor
[  112.218540] usb 2-4: unregistering interface 2-4:1.6
[  112.218596] drivers/usb/core/file.c: removing 3 minor
[  112.218730] usb 2-4: unregistering interface 2-4:1.7
[  112.218790] cdc_ether 2-4:1.7: wwan0: unregister 'cdc_ether' 
usb-0000:00:1d.7-4, Mobile Broadband Network Device
[  112.230494] done.
[  112.230507] video LNXVIDEO:00: Restoring backlight state
[  112.248140] usb 2-4: unregistering interface 2-4:1.8
[  112.248183] usb 2-4: unregistering interface 2-4:1.9
[  112.248911] usb 2-4: unregistering interface 2-4:1.10
[  112.248950] usb 2-4: usb_disable_device nuking all URBs
[  112.249057] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[  112.249068] hub 3-0:1.0: port 1, status 0100, change 0000, 12 Mb/s
[  112.249071] usb 3-1: USB disconnect, device number 3
[  112.249073] usb 3-1: unregistering device
[  112.249075] usb 3-1: unregistering interface 3-1:1.0
[  112.301123] usb 3-1: unregistering interface 3-1:1.1
[  112.302854] cfg80211: Calling CRDA to update world regulatory domain
[  112.340228] drivers/usb/core/file.c: removing 0 minor
[  112.340524] usb 3-1: unregistering interface 3-1:1.2
[  112.340597] drivers/usb/core/file.c: removing 1 minor
[  112.340901] usb 3-1: usb_disable_device nuking all URBs
[  112.364203] hub 4-0:1.0: state 7 ports 2 chg 0004 evt 0004
[  112.364217] hub 4-0:1.0: port 2, status 0103, change 0000, 12 Mb/s
[  112.364221] hub 1-0:1.0: state 7 ports 6 chg 0042 evt 0000
[  112.364229] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[  112.424279] ehci_hcd 0000:00:1a.7: port 1 full speed --> companion
[  112.424285] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003801 0  ACK 
POWER OWNER sig=j CONNECT
[  112.424290] hub 1-0:1.0: port 1 not reset yet, waiting 50ms
[  112.476234] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003002 0  ACK 
POWER OWNER sig=se0 CSC
[  112.476262] hub 1-0:1.0: port 6, status 0503, change 0000, 480 Mb/s
[  112.476266] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0002
[  112.497747] usb usb6: suspend_rh (auto-stop)
[  112.497773] usb usb8: suspend_rh (auto-stop)
[  112.497797] usb usb5: suspend_rh (auto-stop)
[  112.497822] usb usb7: suspend_rh (auto-stop)
[  112.498328] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
[  112.498338] uhci_hcd 0000:00:1a.0: port 1 portsc 0093,00
[  112.498346] hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[  112.628041] hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 
0x101
[  112.724081] ata1.00: configured for UDMA/133
[  112.724094] ata1: EH complete
[  112.725738] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, 
doesn't support DPO or FUA
[  112.740141] usb 3-1: new full speed USB device number 4 using uhci_hcd
[  112.872398] usb 3-1: ep0 maxpacket = 8
[  112.906346] usb 3-1: skipped 1 descriptor after interface
[  112.906350] usb 3-1: skipped 1 descriptor after interface
[  112.906352] usb 3-1: skipped 1 descriptor after interface
[  112.911340] usb 3-1: default language 0x0409
[  112.926367] usb 3-1: udev 4, busnum 3, minor = 259
[  112.926370] usb 3-1: New USB device found, idVendor=046d, idProduct=c52b
[  112.926372] usb 3-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[  112.926374] usb 3-1: Product: USB Receiver
[  112.926376] usb 3-1: Manufacturer: Logitech
[  112.926520] usb 3-1: usb_probe_device
[  112.926524] usb 3-1: configuration #1 chosen from 1 choice
[  112.932341] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[  112.932383] usbhid 3-1:1.0: usb_probe_interface
[  112.932386] usbhid 3-1:1.0: usb_probe_interface - got id
[  112.934577] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input18
[  112.934587] uhci_hcd 0000:00:1a.0: reserve dev 4 ep81-INT, period 8, phase 
4, 17 us
[  112.934713] generic-usb 0003:046D:C52B.0007: input,hidraw0: USB HID v1.11 
Keyboard [Logitech USB Receiver] on usb-0000:00:1a.0-1/input0
[  112.934730] usb 3-1: adding 3-1:1.1 (config #1, interface 1)
[  112.934758] usbhid 3-1:1.1: usb_probe_interface
[  112.934761] usbhid 3-1:1.1: usb_probe_interface - got id
[  112.937698] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.1/input/input19
[  112.937705] uhci_hcd 0000:00:1a.0: reserve dev 4 ep82-INT, period 2, phase 
1, 17 us
[  112.937799] usbhid 3-1:1.1: looking for a minor, starting at 0
[  112.937878] generic-usb 0003:046D:C52B.0008: input,hiddev0,hidraw1: USB HID 
v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1/input1
[  112.937894] usb 3-1: adding 3-1:1.2 (config #1, interface 2)
[  112.937922] usbhid 3-1:1.2: usb_probe_interface
[  112.937924] usbhid 3-1:1.2: usb_probe_interface - got id
[  112.943341] usbhid 3-1:1.2: looking for a minor, starting at 0
[  112.943446] generic-usb 0003:046D:C52B.0009: hiddev0,hidraw2: USB HID v1.11 
Device [Logitech USB Receiver] on usb-0000:00:1a.0-1/input2
[  112.943490] drivers/usb/core/inode.c: creating file '004'
[  112.943512] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
[  113.402971] usb 1-6: link qh4-0001/ffff88010ef86f00 start 2 [1/0 us]
[  113.420976] usb 1-6: unlink qh4-0001/ffff88010ef86f00 start 2 [1/0 us]
[  114.824747] hub 5-0:1.0: hub_suspend
[  114.824766] usb usb5: bus auto-suspend
[  114.824773] usb usb5: suspend_rh
[  114.824800] hub 6-0:1.0: hub_suspend
[  114.824809] usb usb6: bus auto-suspend
[  114.824814] usb usb6: suspend_rh
[  114.824839] hub 7-0:1.0: hub_suspend
[  114.824848] usb usb7: bus auto-suspend
[  114.824853] usb usb7: suspend_rh
[  114.824877] hub 8-0:1.0: hub_suspend
[  114.824885] usb usb8: bus auto-suspend
[  114.824890] usb usb8: suspend_rh
[  114.824913] hub 2-0:1.0: hub_suspend
[  114.824921] usb usb2: bus auto-suspend
[  114.824928] ehci_hcd 0000:00:1d.7: suspend root hub
[  115.651308] eth1: authenticate with 00:27:19:d8:98:f2 (try 1)
[  115.653039] eth1: authenticated
[  115.671756] eth1: associate with 00:27:19:d8:98:f2 (try 1)
[  115.677927] eth1: RX AssocResp from 00:27:19:d8:98:f2 (capab=0x431 status=0 
aid=2)
[  115.677936] eth1: associated
[  115.824078] usb 1-6: usb auto-suspend
[  115.875129] eth1: deauthenticating from 00:27:19:d8:98:f2 by local choice 
(reason=3)
[  115.885602] cfg80211: Calling CRDA to update world regulatory domain
[  116.088104] usb usb2: usb wakeup-resume
[  116.088117] usb usb2: usb auto-resume
[  116.088124] ehci_hcd 0000:00:1d.7: resume root hub
[  116.116016] hub 2-0:1.0: hub_resume
[  116.116032] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001803 0  ACK 
POWER sig=j CSC CONNECT
[  116.116035] hub 2-0:1.0: port 4: status 0501 change 0001
[  116.155212] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[  116.208114] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[  116.209595] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  116.220258] hub 2-0:1.0: state 7 ports 6 chg 0010 evt 0000
[  116.220280] hub 2-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[  116.276289] ehci_hcd 0000:00:1d.7: port 4 high speed
[  116.276305] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[  116.332059] usb 2-4: new high speed USB device number 4 using ehci_hcd
[  116.488286] ehci_hcd 0000:00:1d.7: port 4 high speed
[  116.488300] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001005 0  ACK 
POWER sig=se0 PE CONNECT
[  117.122592] usb 2-4: skipped 3 descriptors after interface
[  117.122602] usb 2-4: skipped 4 descriptors after interface
[  117.122611] usb 2-4: skipped 4 descriptors after interface
[  117.122619] usb 2-4: skipped 2 descriptors after interface
[  117.122625] usb 2-4: skipped 2 descriptors after interface
[  117.122632] usb 2-4: skipped 5 descriptors after interface
[  117.122642] usb 2-4: skipped 4 descriptors after interface
[  117.217965] usb 2-4: skipped 3 descriptors after interface
[  117.217973] usb 2-4: skipped 4 descriptors after interface
[  117.217982] usb 2-4: skipped 4 descriptors after interface
[  117.217991] usb 2-4: skipped 2 descriptors after interface
[  117.217998] usb 2-4: skipped 2 descriptors after interface
[  117.218005] usb 2-4: skipped 5 descriptors after interface
[  117.218454] usb 2-4: default language 0x0409
[  117.232810] usb 2-4: udev 4, busnum 2, minor = 131
[  117.232817] usb 2-4: New USB device found, idVendor=0bdb, idProduct=1900
[  117.232825] usb 2-4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  117.232831] usb 2-4: Product: Ericsson F3507g Mobile Broadband Minicard 
Composite Device
[  117.232837] usb 2-4: Manufacturer: Ericsson
[  117.232842] usb 2-4: SerialNumber: 3541430228088360
[  117.233161] usb 2-4: usb_probe_device
[  117.233170] usb 2-4: configuration #1 chosen from 2 choices
[  117.236811] usb 2-4: adding 2-4:1.0 (config #1, interface 0)
[  117.237114] usb 2-4: adding 2-4:1.1 (config #1, interface 1)
[  117.268281] cdc_acm 2-4:1.1: usb_probe_interface
[  117.268292] cdc_acm 2-4:1.1: usb_probe_interface - got id
[  117.268489] cdc_acm 2-4:1.1: ttyACM0: USB ACM device
[  117.269127] usb 2-4: adding 2-4:1.2 (config #1, interface 2)
[  117.278054] usb 2-4: adding 2-4:1.3 (config #1, interface 3)
[  117.282497] cdc_acm 2-4:1.3: usb_probe_interface
[  117.282507] cdc_acm 2-4:1.3: usb_probe_interface - got id
[  117.282703] cdc_acm 2-4:1.3: ttyACM1: USB ACM device
[  117.283280] usb 2-4: adding 2-4:1.4 (config #1, interface 4)
[  117.289800] usb 2-4: adding 2-4:1.5 (config #1, interface 5)
[  117.293361] cdc_wdm 2-4:1.5: usb_probe_interface
[  117.293369] cdc_wdm 2-4:1.5: usb_probe_interface - got id
[  117.293383] cdc_wdm 2-4:1.5: looking for a minor, starting at 0
[  117.293513] cdc_wdm 2-4:1.5: cdc-wdm-174: USB WDM device
[  117.293553] usb 2-4: adding 2-4:1.6 (config #1, interface 6)
[  117.300128] cdc_wdm 2-4:1.6: usb_probe_interface
[  117.300135] cdc_wdm 2-4:1.6: usb_probe_interface - got id
[  117.300149] cdc_wdm 2-4:1.6: looking for a minor, starting at 0
[  117.300267] cdc_wdm 2-4:1.6: cdc-wdm-173: USB WDM device
[  117.300310] usb 2-4: adding 2-4:1.7 (config #1, interface 7)
[  117.303636] cdc_ether 2-4:1.7: usb_probe_interface
[  117.303644] cdc_ether 2-4:1.7: usb_probe_interface - got id
[  117.306070] cdc_ether 2-4:1.7: wwan0: register 'cdc_ether' at 
usb-0000:00:1d.7-4, Mobile Broadband Network Device, 02:80:37:ec:02:00
[  117.306118] usb 2-4: adding 2-4:1.8 (config #1, interface 8)
[  117.310541] usb 2-4: adding 2-4:1.9 (config #1, interface 9)
[  117.313985] cdc_acm 2-4:1.9: usb_probe_interface
[  117.313994] cdc_acm 2-4:1.9: usb_probe_interface - got id
[  117.314192] cdc_acm 2-4:1.9: ttyACM2: USB ACM device
[  117.314875] usb 2-4: adding 2-4:1.10 (config #1, interface 10)
[  117.321259] drivers/usb/core/inode.c: creating file '004'
[  117.840071] hub 1-0:1.0: hub_suspend
[  117.840088] usb usb1: bus auto-suspend
[  117.840095] ehci_hcd 0000:00:1a.7: suspend root hub
[  118.162581] ata1: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe 
frozen
[  118.162589] ata1: irq_stat 0x00000040, connection status changed
[  118.162597] ata1: SError: { CommWake DevExch }
[  118.162613] ata1: hard resetting link
[  118.884054] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  118.944309] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  118.944313] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[  118.944316] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[  119.074309] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  119.074320] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[  119.074330] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[  119.134032] ata1.00: configured for UDMA/133
[  119.155372] ata1: EH complete
[  119.155487] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[  120.144468] ADDRCONF(NETDEV_UP): eth1: link is not ready
[  122.158084] ata1: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe 
frozen
[  122.158092] ata1: irq_stat 0x00000040, connection status changed
[  122.158100] ata1: SError: { CommWake DevExch }
[  122.158115] ata1: hard resetting link
[  122.884153] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  122.944552] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  122.944563] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[  122.944573] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[  123.054373] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  123.054384] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[  123.054394] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[  123.104188] ata1.00: configured for UDMA/133
[  123.114871] ata1: EH complete
[  123.318000] eth1: authenticate with 00:27:19:d8:98:f2 (try 1)
[  123.320286] eth1: authenticated
[  123.324736] eth1: associate with 00:27:19:d8:98:f2 (try 1)
[  123.330788] eth1: RX AssocResp from 00:27:19:d8:98:f2 (capab=0x431 status=0 
aid=2)
[  123.330797] eth1: associated
[  123.339286] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[  131.162470] ata1: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe 
frozen
[  131.162479] ata1: irq_stat 0x00000040, connection status changed
[  131.162487] ata1: SError: { CommWake DevExch }
[  131.162503] ata1: hard resetting link
[  131.884051] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  131.944644] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  131.944656] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[  131.944665] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[  132.054463] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  132.054474] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[  132.054483] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[  132.114290] ata1.00: configured for UDMA/133
[  132.135597] ata1: EH complete
[  133.763527] e1000e 0000:00:19.0: eth0: Unsupported Speed/Duplex 
configuration
[  133.764440] e1000e 0000:00:19.0: eth0: Unsupported Speed/Duplex 
configuration
[  133.832049] eth1: no IPv6 routers present
[  134.191440] uhci_hcd 0000:00:1a.2: uhci_pci_suspend
[  134.191466] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[  134.191473] uhci_hcd 0000:00:1a.2: hcd_pci_runtime_suspend: 0
[  134.191630] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D3
[  134.191851] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[  134.191859] ehci_hcd 0000:00:1a.7: hcd_pci_runtime_suspend: 0
[  134.191927] ehci_hcd 0000:00:1a.7: PME# enabled
[  134.204110] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[  134.205325] uhci_hcd 0000:00:1d.0: uhci_pci_suspend
[  134.205343] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  134.205349] uhci_hcd 0000:00:1d.0: hcd_pci_runtime_suspend: 0
[  134.205468] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[  134.312274] usb 2-4: usb auto-suspend
[  134.398359] uhci_hcd 0000:00:1a.0: release dev 4 ep82-INT, period 2, phase 
1, 17 us
[  134.399348] uhci_hcd 0000:00:1a.0: release dev 4 ep81-INT, period 8, phase 
4, 17 us
[  134.401366] usb 3-1: usb auto-suspend
[  134.444443] uhci_hcd 0000:00:1a.1: release dev 2 ep81-INT, period 1, phase 
0, 23 us
[  134.447446] usb 4-2: usb auto-suspend
[  135.278827] e1000e 0000:00:19.0: PME# enabled
[  136.808101] hub 2-0:1.0: hub_suspend
[  136.808118] usb usb2: bus auto-suspend
[  136.808125] ehci_hcd 0000:00:1d.7: suspend root hub
[  136.808163] hub 3-0:1.0: hub_suspend
[  136.808171] usb usb3: bus auto-suspend
[  136.808177] usb usb3: suspend_rh
[  136.808205] hub 4-0:1.0: hub_suspend
[  136.808212] usb usb4: bus auto-suspend
[  136.808217] usb usb4: suspend_rh
[  136.808259] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[  136.808281] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  136.808287] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
[  136.808443] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[  136.824047] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[  136.824056] ehci_hcd 0000:00:1d.7: hcd_pci_runtime_suspend: 0
[  136.824125] ehci_hcd 0000:00:1d.7: PME# enabled
[  136.840050] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[  137.162708] ata1: limiting SATA link speed to 1.5 Gbps
[  137.162720] ata1: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe 
frozen
[  137.162726] ata1: irq_stat 0x00000040, connection status changed
[  137.162734] ata1: SError: { CommWake DevExch }
[  137.162749] ata1: hard resetting link
[  137.884081] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  137.951043] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  137.951054] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[  137.951064] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[  138.080964] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  138.080975] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) 
filtered out
[  138.080985] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered 
out
[  138.140792] ata1.00: configured for UDMA/133
[  138.151470] ata1: EH complete
[  139.152858] iwlagn 0000:03:00.0: Aggregation not enabled for tid 0 because 
load = 6
[  145.568081] iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra = 
00:27:19:d8:98:f2 tid = 0
[  372.976970] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  372.976981] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  372.977130] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  372.977139] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  372.977156] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[  372.977171] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  372.977180] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[  372.977227] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_resume: 0
[  372.977238] usb usb3: usb wakeup-resume
[  372.977247] usb usb3: usb auto-resume
[  372.977252] usb usb3: wakeup_rh
[  373.016038] hub 3-0:1.0: hub_resume
[  373.016057] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  373.016068] hub 3-0:1.0: port 1: status 0103 change 0004
[  373.016109] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[  373.016129] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  373.032084] usb 3-1: usb wakeup-resume
[  373.032105] usb 3-1: finish resume
[  373.035104] uhci_hcd 0000:00:1a.0: reserve dev 4 ep81-INT, period 8, phase 
4, 17 us
[  373.035118] uhci_hcd 0000:00:1a.0: reserve dev 4 ep82-INT, period 2, phase 
1, 17 us
[  373.035130] hub 3-0:1.0: resume on port 1, status 0
[  373.035137] hub 3-0:1.0: port 1, status 0103, change 0004, 12 Mb/s
[  376.822099] uhci_hcd 0000:00:1a.0: release dev 4 ep82-INT, period 2, phase 
1, 17 us
[  376.823087] uhci_hcd 0000:00:1a.0: release dev 4 ep81-INT, period 8, phase 
4, 17 us
[  376.825089] usb 3-1: usb auto-suspend
[  378.840072] hub 3-0:1.0: hub_suspend
[  378.840089] usb usb3: bus auto-suspend
[  378.840095] usb usb3: suspend_rh
[  378.840127] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[  378.840148] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  378.840155] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
[  378.840312] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[  398.246091] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  398.246102] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  398.246251] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  398.246260] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  398.246278] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[  398.246293] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  398.246302] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[  398.246351] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_resume: 0
[  398.246362] usb usb3: usb wakeup-resume
[  398.246371] usb usb3: usb auto-resume
[  398.246377] usb usb3: wakeup_rh
[  398.284030] hub 3-0:1.0: hub_resume
[  398.284049] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  398.284060] hub 3-0:1.0: port 1: status 0103 change 0004
[  398.284120] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[  398.284139] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  398.300038] usb 3-1: usb wakeup-resume
[  398.300058] usb 3-1: finish resume
[  398.303099] uhci_hcd 0000:00:1a.0: reserve dev 4 ep81-INT, period 8, phase 
4, 17 us
[  398.303113] uhci_hcd 0000:00:1a.0: reserve dev 4 ep82-INT, period 2, phase 
1, 17 us
[  398.303126] hub 3-0:1.0: resume on port 1, status 0
[  398.303133] hub 3-0:1.0: port 1, status 0103, change 0004, 12 Mb/s
[  401.817116] uhci_hcd 0000:00:1a.0: release dev 4 ep82-INT, period 2, phase 
1, 17 us
[  401.818104] uhci_hcd 0000:00:1a.0: release dev 4 ep81-INT, period 8, phase 
4, 17 us
[  401.820416] usb 3-1: usb auto-suspend
[  403.836071] hub 3-0:1.0: hub_suspend
[  403.836089] usb usb3: bus auto-suspend
[  403.836095] usb usb3: suspend_rh
[  403.836125] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[  403.836147] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  403.836153] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
[  403.836311] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[  406.394011] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  406.394022] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  406.394169] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  406.394178] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  406.394195] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[  406.394209] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  406.394218] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[  406.394266] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_resume: 0
[  406.394277] usb usb3: usb wakeup-resume
[  406.394285] usb usb3: usb auto-resume
[  406.394291] usb usb3: wakeup_rh
[  406.432093] hub 3-0:1.0: hub_resume
[  406.432112] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  406.432122] hub 3-0:1.0: port 1: status 0103 change 0004
[  406.432201] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[  406.432220] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  406.448056] usb 3-1: usb wakeup-resume
[  406.448073] usb 3-1: finish resume
[  406.451090] uhci_hcd 0000:00:1a.0: reserve dev 4 ep81-INT, period 8, phase 
4, 17 us
[  406.451105] uhci_hcd 0000:00:1a.0: reserve dev 4 ep82-INT, period 2, phase 
1, 17 us
[  406.451118] hub 3-0:1.0: resume on port 1, status 0
[  406.451125] hub 3-0:1.0: port 1, status 0103, change 0004, 12 Mb/s
[  423.818104] uhci_hcd 0000:00:1a.0: release dev 4 ep82-INT, period 2, phase 
1, 17 us
[  423.819092] uhci_hcd 0000:00:1a.0: release dev 4 ep81-INT, period 8, phase 
4, 17 us
[  423.821097] usb 3-1: usb auto-suspend
[  425.836075] hub 3-0:1.0: hub_suspend
[  425.836093] usb usb3: bus auto-suspend
[  425.836099] usb usb3: suspend_rh
[  425.836129] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[  425.836151] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  425.836157] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
[  425.836314] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[  435.513733] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  435.513744] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  435.513895] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  435.513904] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  435.513922] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[  435.513936] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  435.513946] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[  435.513994] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_resume: 0
[  435.514005] usb usb3: usb wakeup-resume
[  435.514014] usb usb3: usb auto-resume
[  435.514019] usb usb3: wakeup_rh
[  435.552089] hub 3-0:1.0: hub_resume
[  435.552109] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  435.552119] hub 3-0:1.0: port 1: status 0103 change 0004
[  435.552155] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[  435.552170] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  435.572055] usb 3-1: usb wakeup-resume
[  435.572079] usb 3-1: finish resume
[  435.575129] uhci_hcd 0000:00:1a.0: reserve dev 4 ep81-INT, period 8, phase 
4, 17 us
[  435.575145] uhci_hcd 0000:00:1a.0: reserve dev 4 ep82-INT, period 2, phase 
1, 17 us
[  435.575159] hub 3-0:1.0: resume on port 1, status 0
[  435.575166] hub 3-0:1.0: port 1, status 0103, change 0004, 12 Mb/s
[  440.805123] uhci_hcd 0000:00:1a.0: release dev 4 ep82-INT, period 2, phase 
1, 17 us
[  440.806108] uhci_hcd 0000:00:1a.0: release dev 4 ep81-INT, period 8, phase 
4, 17 us
[  440.808148] usb 3-1: usb auto-suspend
[  442.824072] hub 3-0:1.0: hub_suspend
[  442.824089] usb usb3: bus auto-suspend
[  442.824095] usb usb3: suspend_rh
[  442.824125] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[  442.824146] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  442.824153] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
[  442.824311] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[  445.377488] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  445.377499] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  445.377648] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  445.377657] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  445.377674] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[  445.377689] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  445.377698] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[  445.377746] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_resume: 0
[  445.377758] usb usb3: usb wakeup-resume
[  445.377766] usb usb3: usb auto-resume
[  445.377772] usb usb3: wakeup_rh
[  445.416060] hub 3-0:1.0: hub_resume
[  445.416082] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  445.416093] hub 3-0:1.0: port 1: status 0103 change 0004
[  445.416151] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[  445.416170] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  445.432084] usb 3-1: usb wakeup-resume
[  445.432101] usb 3-1: finish resume
[  445.435108] uhci_hcd 0000:00:1a.0: reserve dev 4 ep81-INT, period 8, phase 
4, 17 us
[  445.435123] uhci_hcd 0000:00:1a.0: reserve dev 4 ep82-INT, period 2, phase 
1, 17 us
[  445.435136] hub 3-0:1.0: resume on port 1, status 0
[  445.435143] hub 3-0:1.0: port 1, status 0103, change 0004, 12 Mb/s
[  448.818097] uhci_hcd 0000:00:1a.0: release dev 4 ep82-INT, period 2, phase 
1, 17 us
[  448.819087] uhci_hcd 0000:00:1a.0: release dev 4 ep81-INT, period 8, phase 
4, 17 us
[  448.821090] usb 3-1: usb auto-suspend
[  450.836077] hub 3-0:1.0: hub_suspend
[  450.836094] usb usb3: bus auto-suspend
[  450.836100] usb usb3: suspend_rh
[  450.836130] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[  450.836152] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  450.836158] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
[  450.836315] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[  453.390036] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  453.390048] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  453.390195] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  453.390204] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  453.390222] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[  453.390236] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  453.390246] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[  453.390293] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_resume: 0
[  453.390304] usb usb3: usb wakeup-resume
[  453.390312] usb usb3: usb auto-resume
[  453.390318] usb usb3: wakeup_rh
[  453.428060] hub 3-0:1.0: hub_resume
[  453.428083] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  453.428093] hub 3-0:1.0: port 1: status 0103 change 0004
[  453.428143] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[  453.428162] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  453.444088] usb 3-1: usb wakeup-resume
[  453.444105] usb 3-1: finish resume
[  453.447109] uhci_hcd 0000:00:1a.0: reserve dev 4 ep81-INT, period 8, phase 
4, 17 us
[  453.447124] uhci_hcd 0000:00:1a.0: reserve dev 4 ep82-INT, period 2, phase 
1, 17 us
[  453.447137] hub 3-0:1.0: resume on port 1, status 0
[  453.447144] hub 3-0:1.0: port 1, status 0103, change 0004, 12 Mb/s
[  482.822100] uhci_hcd 0000:00:1a.0: release dev 4 ep82-INT, period 2, phase 
1, 17 us
[  482.823089] uhci_hcd 0000:00:1a.0: release dev 4 ep81-INT, period 8, phase 
4, 17 us
[  482.825093] usb 3-1: usb auto-suspend
[  484.840075] hub 3-0:1.0: hub_suspend
[  484.840094] usb usb3: bus auto-suspend
[  484.840100] usb usb3: suspend_rh
[  484.840130] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[  484.840152] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  484.840158] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
[  484.840314] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[  487.404322] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  487.404333] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  487.404481] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  487.404490] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  487.404507] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[  487.404521] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  487.404531] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[  487.404579] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_resume: 0
[  487.404590] usb usb3: usb wakeup-resume
[  487.404599] usb usb3: usb auto-resume
[  487.404604] usb usb3: wakeup_rh
[  487.444070] hub 3-0:1.0: hub_resume
[  487.444090] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  487.444100] hub 3-0:1.0: port 1: status 0103 change 0004
[  487.444156] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[  487.444176] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  487.460098] usb 3-1: usb wakeup-resume
[  487.460116] usb 3-1: finish resume
[  487.463113] uhci_hcd 0000:00:1a.0: reserve dev 4 ep81-INT, period 8, phase 
4, 17 us
[  487.463127] uhci_hcd 0000:00:1a.0: reserve dev 4 ep82-INT, period 2, phase 
1, 17 us
[  487.463140] hub 3-0:1.0: resume on port 1, status 0
[  487.463147] hub 3-0:1.0: port 1, status 0103, change 0004, 12 Mb/s
[  490.817103] uhci_hcd 0000:00:1a.0: release dev 4 ep82-INT, period 2, phase 
1, 17 us
[  490.818092] uhci_hcd 0000:00:1a.0: release dev 4 ep81-INT, period 8, phase 
4, 17 us
[  490.820457] usb 3-1: usb auto-suspend
[  492.836071] hub 3-0:1.0: hub_suspend
[  492.836088] usb usb3: bus auto-suspend
[  492.836094] usb usb3: suspend_rh
[  492.836125] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[  492.836146] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  492.836153] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
[  492.836310] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[  495.392092] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  495.392103] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  495.392250] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  495.392259] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  495.392276] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[  495.392290] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  495.392299] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[  495.392347] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_resume: 0
[  495.392358] usb usb3: usb wakeup-resume
[  495.392366] usb usb3: usb auto-resume
[  495.392372] usb usb3: wakeup_rh
[  495.436056] hub 3-0:1.0: hub_resume
[  495.436080] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  495.436091] hub 3-0:1.0: port 1: status 0103 change 0004
[  495.436144] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[  495.436163] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  495.452055] usb 3-1: usb wakeup-resume
[  495.452073] usb 3-1: finish resume
[  495.455087] uhci_hcd 0000:00:1a.0: reserve dev 4 ep81-INT, period 8, phase 
4, 17 us
[  495.455102] uhci_hcd 0000:00:1a.0: reserve dev 4 ep82-INT, period 2, phase 
1, 17 us
[  495.455115] hub 3-0:1.0: resume on port 1, status 0
[  495.455122] hub 3-0:1.0: port 1, status 0103, change 0004, 12 Mb/s
[  501.822099] uhci_hcd 0000:00:1a.0: release dev 4 ep82-INT, period 2, phase 
1, 17 us
[  501.823088] uhci_hcd 0000:00:1a.0: release dev 4 ep81-INT, period 8, phase 
4, 17 us
[  501.825090] usb 3-1: usb auto-suspend
[  503.840085] hub 3-0:1.0: hub_suspend
[  503.840102] usb usb3: bus auto-suspend
[  503.840108] usb usb3: suspend_rh
[  503.840139] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[  503.840161] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  503.840167] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
[  503.840331] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[  506.395607] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  506.395618] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  506.395766] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  506.395774] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  506.395791] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[  506.395806] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  506.395815] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[  506.395864] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_resume: 0
[  506.395875] usb usb3: usb wakeup-resume
[  506.395884] usb usb3: usb auto-resume
[  506.395889] usb usb3: wakeup_rh
[  506.432067] hub 3-0:1.0: hub_resume
[  506.432086] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  506.432097] hub 3-0:1.0: port 1: status 0103 change 0004
[  506.432146] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[  506.432165] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  506.448085] usb 3-1: usb wakeup-resume
[  506.448102] usb 3-1: finish resume
[  506.451111] uhci_hcd 0000:00:1a.0: reserve dev 4 ep81-INT, period 8, phase 
4, 17 us
[  506.451126] uhci_hcd 0000:00:1a.0: reserve dev 4 ep82-INT, period 2, phase 
1, 17 us
[  506.451138] hub 3-0:1.0: resume on port 1, status 0
[  506.451145] hub 3-0:1.0: port 1, status 0103, change 0004, 12 Mb/s
[  509.818100] uhci_hcd 0000:00:1a.0: release dev 4 ep82-INT, period 2, phase 
1, 17 us
[  509.819090] uhci_hcd 0000:00:1a.0: release dev 4 ep81-INT, period 8, phase 
4, 17 us
[  509.821093] usb 3-1: usb auto-suspend
[  511.836072] hub 3-0:1.0: hub_suspend
[  511.836089] usb usb3: bus auto-suspend
[  511.836095] usb usb3: suspend_rh
[  511.836126] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[  511.836147] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  511.836154] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
[  511.836310] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[  514.395354] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  514.395366] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  514.395515] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  514.395524] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  514.395542] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20
[  514.395556] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  514.395565] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[  514.395612] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_resume: 0
[  514.395623] usb usb3: usb wakeup-resume
[  514.395632] usb usb3: usb auto-resume
[  514.395637] usb usb3: wakeup_rh
[  514.432069] hub 3-0:1.0: hub_resume
[  514.432089] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  514.432100] hub 3-0:1.0: port 1: status 0103 change 0004
[  514.432159] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[  514.432178] uhci_hcd 0000:00:1a.0: port 1 portsc 0095,01
[  514.448099] usb 3-1: usb wakeup-resume
[  514.448116] usb 3-1: finish resume
[  514.451113] uhci_hcd 0000:00:1a.0: reserve dev 4 ep81-INT, period 8, phase 
4, 17 us
[  514.451128] uhci_hcd 0000:00:1a.0: reserve dev 4 ep82-INT, period 2, phase 
1, 17 us
[  514.451140] hub 3-0:1.0: resume on port 1, status 0
[  514.451147] hub 3-0:1.0: port 1, status 0103, change 0004, 12 Mb/s
[  517.030078] uhci_hcd 0000:00:1a.0: release dev 4 ep82-INT, period 2, phase 
1, 17 us
[  517.031092] uhci_hcd 0000:00:1a.0: release dev 4 ep81-INT, period 8, phase 
4, 17 us
[  517.033094] usb 3-1: usb auto-suspend
[  519.048081] hub 3-0:1.0: hub_suspend
[  519.048098] usb usb3: bus auto-suspend
[  519.048104] usb usb3: suspend_rh
[  519.048135] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[  519.048156] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  519.048163] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
[  519.048319] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D3

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
