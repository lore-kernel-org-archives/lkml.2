Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2DRPUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:20:04 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40951 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2DRPT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:19:56 -0400
Message-ID: <1334762504.1595.2.camel@fujitsu-laptop>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/mutex.c:271
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Apr 2012 21:21:44 +0600
In-Reply-To: <1334756901.28106.38.camel@gandalf.stny.rr.com>
References: <1334561244.3339.7.camel@aep-desktop>
	 <20120418025626.GB23877@home.goodmis.org>
	 <20120418040636.GD2449@linux.vnet.ibm.com>
	 <1334724679.2019.20.camel@aep-desktop>
	 <1334750926.28106.36.camel@gandalf.stny.rr.com>
	 <1334756757.1269.28.camel@fujitsu-laptop>
	 <1334756901.28106.38.camel@gandalf.stny.rr.com>
Content-Type: multipart/mixed; boundary="=-H5vF6Ax8eJozKS/jbq3T"
X-Mailer: Evolution 3.2.3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-H5vF6Ax8eJozKS/jbq3T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Steven Rostedt wrote:
> On Wed, 2012-04-18 at 19:45 +0600, Alexander E. Patrakov wrote:
> 
> > > Do you see the RT throttling message too? That's a bug with an RT task
> > > going haywire. If that is happening, an RT task may be preventing an RCU
> > > grace period to finish, and causing the RCU stalls.
> > 
> > I am currently at home, writing this from a laptop with 3.3.1, and there
> 
> Have you seen the memory leaks on your laptop?
> 
> > are no such messages in dmesg (yet?). Also I don't know any RT tasks
> > that may run on my computer, except pulseaudio, which has a built-in
> 
> There are kernel threads that run at RT priorities too.
> 
> > safeguard against this. As for the work computer, should I check
> > tomorrow, and with which kernel version?
> > 
> 
> I'm only interested in the kernel version that happens to leak. If other
> versions don't leak then we don't need to worry about them ;-)

Attached is a config and a full dmesg on 3.3.0 on the laptop. No obvious
memory leak - but this may be just the beginning, as the laptop still
responds well enough for me to send this email.

-- 
Alexander E. Patrakov

--=-H5vF6Ax8eJozKS/jbq3T
Content-Disposition: attachment; filename="dmesg.txt"
Content-Type: text/plain; name="dmesg.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0-gentoo (root@fujitsu-laptop) (gcc version 4.5.3 (Gentoo 4.5.3-r2 p1.1, pie-0.4.7) ) #4 SMP PREEMPT Wed Apr 18 21:03:46 YEKT 2012
[    0.000000] Command line: initrd=/initramfs.img.old ro quiet drm_kms_helper.poll=0 root=/dev/fujitsu-laptop/gentoo32b-root resume=/dev/fujitsu-laptop/swap pcie_aspm=force rd.lvm.vg=fujitsu-laptop init=/sbin/init32 BOOT_IMAGE=/vmlinuz.old 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
[    0.000000]  BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000ba94d000 (usable)
[    0.000000]  BIOS-e820: 00000000ba94d000 - 00000000bac30000 (reserved)
[    0.000000]  BIOS-e820: 00000000bac30000 - 00000000bb27c000 (usable)
[    0.000000]  BIOS-e820: 00000000bb27c000 - 00000000bb282000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb282000 - 00000000bb3cb000 (usable)
[    0.000000]  BIOS-e820: 00000000bb3cb000 - 00000000bb40f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb40f000 - 00000000bb64f000 (usable)
[    0.000000]  BIOS-e820: 00000000bb64f000 - 00000000bb6d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb6d0000 - 00000000bb70f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb70f000 - 00000000bb717000 (usable)
[    0.000000]  BIOS-e820: 00000000bb717000 - 00000000bb71f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb71f000 - 00000000bb76f000 (usable)
[    0.000000]  BIOS-e820: 00000000bb76f000 - 00000000bb79f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bb79f000 - 00000000bb7de000 (usable)
[    0.000000]  BIOS-e820: 00000000bb7de000 - 00000000bb7ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bb7ff000 - 00000000bb800000 (usable)
[    0.000000]  BIOS-e820: 00000000bb800000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f272c000 - 00000000f272d000 (reserved)
[    0.000000]  BIOS-e820: 00000000feaff000 - 00000000feb00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001fc000000 (usable)
[    0.000000]  BIOS-e820: 0000000200000000 - 000000023c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: FUJITSU LIFEBOOK S760/FJNB20A, BIOS Version 1.19  10/20/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x23c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-through
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 disabled
[    0.000000]   1 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask F00000000 write-back
[    0.000000]   5 base 200000000 mask FC0000000 write-back
[    0.000000]   6 base 23C000000 mask FFC000000 uncachable
[    0.000000]   7 base 0BC000000 mask FFC000000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbb800 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bb800000
[    0.000000]  0000000000 - 00bb800000 page 2M
[    0.000000] kernel direct mapping tables up to bb800000 @ 1fffc000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000023c000000
[    0.000000]  0100000000 - 023c000000 page 2M
[    0.000000] kernel direct mapping tables up to 23c000000 @ bb7d4000-bb7de000
[    0.000000] RAMDISK: 7fb34000 - 7ffff000
[    0.000000] ACPI: RSDP 00000000000f5420 00024 (v02 FUJ   )
[    0.000000] ACPI: XSDT 00000000bb7f2b0b 0008C (v01 FSC    PC       01190000 FUJ  00000100)
[    0.000000] ACPI: FACP 00000000bb7e0000 000F4 (v03 FSC    PC       01190000 FUJ  00000100)
[    0.000000] ACPI: DSDT 00000000bb7e1000 0B79F (v02 FUJ    FJNB20A  01190000 FUJ  00000100)
[    0.000000] ACPI: FACS 00000000bb78bfc0 00040
[    0.000000] ACPI: SSDT 00000000bb7fe366 000BA (v01 FUJ    FJNB20A  01190000 FUJ  00000100)
[    0.000000] ACPI: HPET 00000000bb7fe514 00038 (v01 FUJ    FJNB20A  01190000 FUJ  00000100)
[    0.000000] ACPI: MCFG 00000000bb7fe54c 0003C (v01 FUJ    FJNB20A  01190000 FUJ  00000100)
[    0.000000] ACPI: SSDT 00000000bb7fe588 0042F (v01 FUJ    FJNB20A  01190000 FUJ  00000100)
[    0.000000] ACPI: SSDT 00000000bb7fe9b7 002C3 (v01 FUJ    FJNB20A  01190000 FUJ  00000100)
[    0.000000] ACPI: APIC 00000000bb7fec7a 00084 (v01 FUJ    FJNB20A  01190000 FUJ  00000100)
[    0.000000] ACPI: SPCR 00000000bb7fecfe 00050 (v01 FUJ    FJNB20A  01190000 FUJ  00000100)
[    0.000000] ACPI: SLIC 00000000bb7fed4e 00176 (v01 FSC    PC       01190000 FUJ  00000100)
[    0.000000] ACPI: BOOT 00000000bb7feec4 00028 (v01 FUJ    FJNB20A  01190000 FUJ  00000100)
[    0.000000] ACPI: ASF! 00000000bb7ee000 000A0 (v16 FUJ    FJNB20A  01190000 FUJ  00000100)
[    0.000000] ACPI: DMAR 00000000bb7ed000 000B8 (v01 INTEL  CP_DALE  00000001 INTL 00000001)
[    0.000000] ACPI: SSDT 00000000bb7df000 00A5F (v01  PmRef    CpuPm 00003000 INTL 20060912)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000023c000000
[    0.000000] Initmem setup node 0 0000000000000000-000000023c000000
[    0.000000]   NODE_DATA [000000023bffb000 - 000000023bffffff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880233600000-ffff88023b5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0023c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000ba94d
[    0.000000]     0: 0x000bac30 -> 0x000bb27c
[    0.000000]     0: 0x000bb282 -> 0x000bb3cb
[    0.000000]     0: 0x000bb40f -> 0x000bb64f
[    0.000000]     0: 0x000bb70f -> 0x000bb717
[    0.000000]     0: 0x000bb71f -> 0x000bb76f
[    0.000000]     0: 0x000bb79f -> 0x000bb7de
[    0.000000]     0: 0x000bb7ff -> 0x000bb800
[    0.000000]     0: 0x00100000 -> 0x001fc000
[    0.000000]     0: 0x00200000 -> 0x0023c000
[    0.000000] On node 0 totalpages: 2044741
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3910 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 746490 pages, LIFO batch:31
[    0.000000]   Normal zone: 20224 pages used for memmap
[    0.000000]   Normal zone: 1257728 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000ba94d000 - 00000000bac30000
[    0.000000] PM: Registered nosave memory: 00000000bb27c000 - 00000000bb282000
[    0.000000] PM: Registered nosave memory: 00000000bb3cb000 - 00000000bb40f000
[    0.000000] PM: Registered nosave memory: 00000000bb64f000 - 00000000bb6d0000
[    0.000000] PM: Registered nosave memory: 00000000bb6d0000 - 00000000bb70f000
[    0.000000] PM: Registered nosave memory: 00000000bb717000 - 00000000bb71f000
[    0.000000] PM: Registered nosave memory: 00000000bb76f000 - 00000000bb79f000
[    0.000000] PM: Registered nosave memory: 00000000bb7de000 - 00000000bb7ff000
[    0.000000] PM: Registered nosave memory: 00000000bb800000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000f272c000
[    0.000000] PM: Registered nosave memory: 00000000f272c000 - 00000000f272d000
[    0.000000] PM: Registered nosave memory: 00000000f272d000 - 00000000feaff000
[    0.000000] PM: Registered nosave memory: 00000000feaff000 - 00000000feb00000
[    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] PM: Registered nosave memory: 00000001fc000000 - 0000000200000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff880232e00000 s1919360 r8192 d22144 u2097152
[    0.000000] pcpu-alloc: s1919360 r8192 d22144 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2008128
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: initrd=/initramfs.img.old ro quiet drm_kms_helper.poll=0 root=/dev/fujitsu-laptop/gentoo32b-root resume=/dev/fujitsu-laptop/swap pcie_aspm=force rd.lvm.vg=fujitsu-laptop init=/sbin/init32 BOOT_IMAGE=/vmlinuz.old 
[    0.000000] PCIe ASPM is forcibly enabled
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7944428k/9371648k available (6537k kernel code, 1192684k absent, 234536k reserved, 6456k data, 2432k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	CONFIG_RCU_FANOUT set to non-default value of 32
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
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
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2660.054 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5320.10 BogoMIPS (lpj=2660054)
[    0.000007] pid_max: default: 32768 minimum: 301
[    0.000044] Security Framework initialized
[    0.000612] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.002571] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003425] Mount-cache hash table entries: 256
[    0.003794] Initializing cgroup subsys cpuacct
[    0.003796] Initializing cgroup subsys devices
[    0.003798] Initializing cgroup subsys freezer
[    0.003841] CPU: Physical Processor ID: 0
[    0.003842] CPU: Processor Core ID: 0
[    0.003847] mce: CPU supports 9 MCE banks
[    0.003855] CPU0: Thermal monitoring handled by SMI
[    0.003868] using mwait in idle threads.
[    0.004771] ACPI: Core revision 20120111
[    0.025881] DMAR: Host address width 36
[    0.025884] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.025893] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020e30272 ecap 1000
[    0.025895] DMAR: DRHD base: 0x000000fed91000 flags: 0x0
[    0.025904] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c0000020230272 ecap 1000
[    0.025905] DMAR: DRHD base: 0x000000fed93000 flags: 0x1
[    0.025914] IOMMU 2: reg_base_addr fed93000 ver 1:0 cap c9008020630272 ecap 1000
[    0.025915] DMAR: RMRR base: 0x000000bb6e9000 end: 0x000000bb6fffff
[    0.025917] DMAR: RMRR base: 0x000000bde00000 end: 0x000000bfffffff
[    0.026469] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.036447] CPU0: Intel(R) Core(TM) i5 CPU       M 560  @ 2.67GHz stepping 05
[    0.137804] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.137810] CPUID marked event: 'bus cycles' unavailable
[    0.137818] ... version:                3
[    0.137819] ... bit width:              48
[    0.137820] ... generic registers:      4
[    0.137822] ... value mask:             0000ffffffffffff
[    0.137823] ... max period:             000000007fffffff
[    0.137824] ... fixed-purpose events:   3
[    0.137825] ... event mask:             000000070000000f
[    0.146059] NMI watchdog enabled, takes one hw-pmu counter.
[    0.151802] lockdep: fixing up alternatives.
[    0.153861] Booting Node   0, Processors  #1
[    0.153867] smpboot cpu 1: start_ip = 96000
[    0.164983] CPU1: Thermal monitoring handled by SMI
[    0.185082] NMI watchdog enabled, takes one hw-pmu counter.
[    0.190693] lockdep: fixing up alternatives.
[    0.190757]  #2
[    0.190761] smpboot cpu 2: start_ip = 96000
[    0.201775] CPU2: Thermal monitoring handled by SMI
[    0.221857] NMI watchdog enabled, takes one hw-pmu counter.
[    0.227599] lockdep: fixing up alternatives.
[    0.227660]  #3 Ok.
[    0.227664] smpboot cpu 3: start_ip = 96000
[    0.238674] CPU3: Thermal monitoring handled by SMI
[    0.258755] NMI watchdog enabled, takes one hw-pmu counter.
[    0.260512] Brought up 4 CPUs
[    0.260517] Total of 4 processors activated (21280.43 BogoMIPS).
[    0.263192] devtmpfs: initialized
[    0.265841] PM: Registering ACPI NVS region at bb64f000 (528384 bytes)
[    0.265852] PM: Registering ACPI NVS region at bb76f000 (196608 bytes)
[    0.266010] NET: Registered protocol family 16
[    0.266261] ACPI: bus type pci registered
[    0.266338] dca service started, version 1.12.1
[    0.266366] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.266369] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.365473] PCI: Using configuration type 1 for base access
[    0.368071] bio: create slab <bio-0> at 0
[    0.368186] ACPI: Added _OSI(Module Device)
[    0.368189] ACPI: Added _OSI(Processor Device)
[    0.368191] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.368193] ACPI: Added _OSI(Processor Aggregator Device)
[    0.375778] ACPI: EC: Look up EC in DSDT
[    0.388053] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.388192] ACPI: SSDT 00000000bb78b4e6 00665 (v02 FUJ    FJNB20A  01190000 FUJ  00000100)
[    0.390335] ACPI: Dynamic OEM Table Load:
[    0.390338] ACPI: SSDT           (null) 00665 (v02 FUJ    FJNB20A  01190000 FUJ  00000100)
[    0.394880] ACPI: SSDT 00000000bb71a598 004F2 (v01  PmRef  Cpu0Ist 00003000 INTL 20060912)
[    0.396899] ACPI: Dynamic OEM Table Load:
[    0.396902] ACPI: SSDT           (null) 004F2 (v01  PmRef  Cpu0Ist 00003000 INTL 20060912)
[    0.397049] ACPI: SSDT 00000000bb718018 00834 (v01  PmRef  Cpu0Cst 00003001 INTL 20060912)
[    0.399056] ACPI: Dynamic OEM Table Load:
[    0.399059] ACPI: SSDT           (null) 00834 (v01  PmRef  Cpu0Cst 00003001 INTL 20060912)
[    0.404447] ACPI: SSDT 00000000bb719a98 00303 (v01  PmRef    ApIst 00003000 INTL 20060912)
[    0.406542] ACPI: Dynamic OEM Table Load:
[    0.406545] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20060912)
[    0.409620] ACPI: SSDT 00000000bb717d98 00119 (v01  PmRef    ApCst 00003000 INTL 20060912)
[    0.411680] ACPI: Dynamic OEM Table Load:
[    0.411683] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20060912)
[    0.415028] ACPI: Interpreter enabled
[    0.415032] ACPI: (supports S0 S3 S4 S5)
[    0.415070] ACPI: Using IOAPIC for interrupt routing
[    0.427062] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.428677] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.428681] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.429073] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.429627] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.429630] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.429632] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.429634] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    0.429636] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.429638] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.429640] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfeafffff]
[    0.429714] PCI host bridge to bus 0000:00
[    0.429716] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.429718] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.429719] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.429721] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.429723] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.429725] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.429727] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfeafffff]
[    0.429748] pci 0000:00:00.0: [8086:0044] type 0 class 0x000600
[    0.429790] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
[    0.429828] pci 0000:00:02.0: [8086:0046] type 0 class 0x000300
[    0.429848] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.429859] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.429867] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.429966] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
[    0.430001] pci 0000:00:16.0: reg 10: [mem 0xf2724000-0xf272400f 64bit]
[    0.430124] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.430163] pci 0000:00:16.2: [8086:3b66] type 0 class 0x000101
[    0.430187] pci 0000:00:16.2: reg 10: [io  0x1828-0x182f]
[    0.430201] pci 0000:00:16.2: reg 14: [io  0x180c-0x180f]
[    0.430213] pci 0000:00:16.2: reg 18: [io  0x1820-0x1827]
[    0.430226] pci 0000:00:16.2: reg 1c: [io  0x1808-0x180b]
[    0.430239] pci 0000:00:16.2: reg 20: [io  0x1810-0x181f]
[    0.430341] pci 0000:00:16.3: [8086:3b67] type 0 class 0x000700
[    0.430365] pci 0000:00:16.3: reg 10: [io  0x1830-0x1837]
[    0.430379] pci 0000:00:16.3: reg 14: [mem 0xf2726000-0xf2726fff]
[    0.430528] pci 0000:00:19.0: [8086:10ea] type 0 class 0x000200
[    0.430552] pci 0000:00:19.0: reg 10: [mem 0xf2700000-0xf271ffff]
[    0.430563] pci 0000:00:19.0: reg 14: [mem 0xf2727000-0xf2727fff]
[    0.430574] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.430659] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.430694] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    0.430720] pci 0000:00:1a.0: reg 10: [mem 0xf2728000-0xf27283ff]
[    0.430839] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.430873] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    0.430892] pci 0000:00:1b.0: reg 10: [mem 0xf2720000-0xf2723fff 64bit]
[    0.430984] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.431016] pci 0000:00:1c.0: [8086:3b4c] type 1 class 0x000604
[    0.431112] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.431143] pci 0000:00:1c.1: [8086:3b44] type 1 class 0x000604
[    0.431237] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.431285] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    0.431311] pci 0000:00:1d.0: reg 10: [mem 0xf2729000-0xf27293ff]
[    0.431432] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.431460] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.431545] pci 0000:00:1f.0: [8086:3b07] type 0 class 0x000601
[    0.431701] pci 0000:00:1f.2: [8086:3b2f] type 0 class 0x000106
[    0.431726] pci 0000:00:1f.2: reg 10: [io  0x1888-0x188f]
[    0.431737] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    0.431747] pci 0000:00:1f.2: reg 18: [io  0x1880-0x1887]
[    0.431757] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    0.431767] pci 0000:00:1f.2: reg 20: [io  0x1860-0x187f]
[    0.431777] pci 0000:00:1f.2: reg 24: [mem 0xf272a000-0xf272a7ff]
[    0.431841] pci 0000:00:1f.2: PME# supported from D3hot
[    0.431866] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    0.431886] pci 0000:00:1f.3: reg 10: [mem 0xf272b000-0xf272b0ff 64bit]
[    0.431914] pci 0000:00:1f.3: reg 20: [io  0x18a0-0x18bf]
[    0.431963] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
[    0.431992] pci 0000:00:1f.6: reg 10: [mem 0xf272c000-0xf272cfff 64bit]
[    0.432152] pci 0000:00:1c.0: PCI bridge to [bus 08-0f]
[    0.432156] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.432161] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.432305] pci 0000:10:00.0: [8086:422c] type 0 class 0x000280
[    0.432362] pci 0000:10:00.0: reg 10: [mem 0xf2400000-0xf2401fff 64bit]
[    0.432637] pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
[    0.434519] pci 0000:00:1c.1: PCI bridge to [bus 10-17]
[    0.434526] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.434617] pci 0000:00:1e.0: PCI bridge to [bus 48-48] (subtractive decode)
[    0.434629] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.434631] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.434633] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.434635] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.434637] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.434639] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.434641] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfeafffff] (subtractive decode)
[    0.434661] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.434914] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE0._PRT]
[    0.434951] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE1._PRT]
[    0.435087]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.435091]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.435092] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.442503] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
[    0.442544] PCI: root bus ff: using default resources
[    0.442597] PCI host bridge to bus 0000:ff
[    0.442599] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    0.442601] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xfffffffff]
[    0.442608] pci 0000:ff:00.0: [8086:2c62] type 0 class 0x000600
[    0.442647] pci 0000:ff:00.1: [8086:2d01] type 0 class 0x000600
[    0.442691] pci 0000:ff:02.0: [8086:2d10] type 0 class 0x000600
[    0.442728] pci 0000:ff:02.1: [8086:2d11] type 0 class 0x000600
[    0.442764] pci 0000:ff:02.2: [8086:2d12] type 0 class 0x000600
[    0.442802] pci 0000:ff:02.3: [8086:2d13] type 0 class 0x000600
[    0.442880]  pci0000:ff: Requesting ACPI _OSC control (0x1d)
[    0.442883]  pci0000:ff: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.442884] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.443331] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 *7 10 12 14 15)
[    0.443395] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.443451] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.443506] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.443561] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.443617] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.443672] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.443727] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.443915] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.443946] vgaarb: loaded
[    0.443947] vgaarb: bridge control possible 0000:00:02.0
[    0.444067] SCSI subsystem initialized
[    0.444154] libata version 3.00 loaded.
[    0.444216] PCI: Using ACPI for IRQ routing
[    0.452006] PCI: pci_cache_line_size set to 64 bytes
[    0.452190] reserve RAM buffer: 000000000009bc00 - 000000000009ffff 
[    0.452193] reserve RAM buffer: 00000000ba94d000 - 00000000bbffffff 
[    0.452197] reserve RAM buffer: 00000000bb27c000 - 00000000bbffffff 
[    0.452201] reserve RAM buffer: 00000000bb3cb000 - 00000000bbffffff 
[    0.452204] reserve RAM buffer: 00000000bb64f000 - 00000000bbffffff 
[    0.452207] reserve RAM buffer: 00000000bb717000 - 00000000bbffffff 
[    0.452210] reserve RAM buffer: 00000000bb76f000 - 00000000bbffffff 
[    0.452212] reserve RAM buffer: 00000000bb7de000 - 00000000bbffffff 
[    0.452214] reserve RAM buffer: 00000000bb800000 - 00000000bbffffff 
[    0.452437] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.452445] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.454487] Switching to clocksource hpet
[    0.467455] pnp: PnP ACPI init
[    0.467483] ACPI: bus type pnp registered
[    0.467827] pnp 00:00: [bus 00-fe]
[    0.467829] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.467831] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.467833] pnp 00:00: [io  0x0d00-0xffff window]
[    0.467835] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.467836] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.467838] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.467840] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.467842] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.467843] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.467845] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.467847] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.467848] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.467850] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.467852] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.467853] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.467855] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.467857] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.467859] pnp 00:00: [mem 0xc0000000-0xfeafffff window]
[    0.467860] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.468043] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.468062] pnp 00:01: [io  0x0010-0x001f]
[    0.468064] pnp 00:01: [io  0x0024-0x0025]
[    0.468065] pnp 00:01: [io  0x0028-0x0029]
[    0.468067] pnp 00:01: [io  0x002c-0x002d]
[    0.468068] pnp 00:01: [io  0x002e-0x002f]
[    0.468070] pnp 00:01: [io  0x0030-0x0031]
[    0.468071] pnp 00:01: [io  0x0034-0x0035]
[    0.468072] pnp 00:01: [io  0x0038-0x0039]
[    0.468074] pnp 00:01: [io  0x003c-0x003d]
[    0.468075] pnp 00:01: [io  0x004e-0x004f]
[    0.468077] pnp 00:01: [io  0x0050-0x0053]
[    0.468078] pnp 00:01: [io  0x0061]
[    0.468080] pnp 00:01: [io  0x0063]
[    0.468081] pnp 00:01: [io  0x0065]
[    0.468082] pnp 00:01: [io  0x0067]
[    0.468086] pnp 00:01: [io  0x0072-0x0077]
[    0.468087] pnp 00:01: [io  0x0080]
[    0.468089] pnp 00:01: [io  0x0090-0x009f]
[    0.468090] pnp 00:01: [io  0x0092]
[    0.468091] pnp 00:01: [io  0x00a4-0x00a5]
[    0.468093] pnp 00:01: [io  0x00a8-0x00a9]
[    0.468094] pnp 00:01: [io  0x00ac-0x00ad]
[    0.468096] pnp 00:01: [io  0x00b0-0x00b1]
[    0.468097] pnp 00:01: [io  0x00b2-0x00b3]
[    0.468099] pnp 00:01: [io  0x00b4-0x00b5]
[    0.468100] pnp 00:01: [io  0x00b8-0x00b9]
[    0.468102] pnp 00:01: [io  0x00bc-0x00bd]
[    0.468103] pnp 00:01: [io  0x0400-0x047f]
[    0.468105] pnp 00:01: [io  0x0480-0x048f]
[    0.468106] pnp 00:01: [io  0x04d0-0x04d1]
[    0.468107] pnp 00:01: [io  0x0680-0x069f]
[    0.468109] pnp 00:01: [io  0x0500-0x050f]
[    0.468110] pnp 00:01: [io  0x0600-0x0603]
[    0.468112] pnp 00:01: [io  0x0800-0x080f]
[    0.468113] pnp 00:01: [io  0x0f40-0x0f41]
[    0.468115] pnp 00:01: [io  0x1100-0x111f]
[    0.468116] pnp 00:01: [io  0x1180-0x11ff]
[    0.468118] pnp 00:01: [io  0x1640-0x164f]
[    0.468119] pnp 00:01: [io  0xf800-0xf87f]
[    0.468121] pnp 00:01: [io  0xf880-0xf8ff]
[    0.468122] pnp 00:01: [io  0xfc00-0xfc7f]
[    0.468124] pnp 00:01: [io  0xfc80-0xfcff]
[    0.468125] pnp 00:01: [io  0xfd00-0xfd7f]
[    0.468255] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.468258] system 00:01: [io  0x0480-0x048f] has been reserved
[    0.468260] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.468262] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.468265] system 00:01: [io  0x0500-0x050f] has been reserved
[    0.468267] system 00:01: [io  0x0600-0x0603] has been reserved
[    0.468269] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.468271] system 00:01: [io  0x0f40-0x0f41] has been reserved
[    0.468274] system 00:01: [io  0x1100-0x111f] has been reserved
[    0.468276] system 00:01: [io  0x1180-0x11ff] has been reserved
[    0.468278] system 00:01: [io  0x1640-0x164f] has been reserved
[    0.468280] system 00:01: [io  0xf800-0xf87f] has been reserved
[    0.468283] system 00:01: [io  0xf880-0xf8ff] has been reserved
[    0.468285] system 00:01: [io  0xfc00-0xfc7f] has been reserved
[    0.468287] system 00:01: [io  0xfc80-0xfcff] has been reserved
[    0.468290] system 00:01: [io  0xfd00-0xfd7f] has been reserved
[    0.468295] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.468529] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    0.468531] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    0.468533] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    0.468534] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    0.468536] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    0.468537] pnp 00:02: [mem 0x00000000-0x00000fff]
[    0.468539] pnp 00:02: [mem 0xfeaff000-0xfeafffff]
[    0.468541] pnp 00:02: [mem 0xfed20000-0xfed3ffff]
[    0.468542] pnp 00:02: [mem 0xfed90000-0xfed93fff]
[    0.468544] pnp 00:02: [mem 0xfed40000-0xfed3ffff disabled]
[    0.468545] pnp 00:02: [mem 0xfed45000-0xfed8ffff]
[    0.468547] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.468549] pnp 00:02: [mem 0xfee00000-0xfeefffff]
[    0.468552] pnp 00:02: [mem 0xfef00000-0xfeffffff]
[    0.468644] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.468647] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.468649] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.468652] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.468654] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    0.468656] system 00:02: [mem 0x00000000-0x00000fff] could not be reserved
[    0.468659] system 00:02: [mem 0xfeaff000-0xfeafffff] has been reserved
[    0.468663] system 00:02: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.468665] system 00:02: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.468668] system 00:02: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.468670] system 00:02: [mem 0xff000000-0xffffffff] has been reserved
[    0.468673] system 00:02: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.468675] system 00:02: [mem 0xfef00000-0xfeffffff] has been reserved
[    0.468680] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.468773] pnp 00:03: [mem 0xfed40000-0xfed44fff]
[    0.468833] pnp 00:03: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.468871] pnp 00:04: [io  0x0000-0x001f]
[    0.468872] pnp 00:04: [io  0x0081-0x0091]
[    0.468874] pnp 00:04: [io  0x0093-0x009f]
[    0.468875] pnp 00:04: [io  0x00c0-0x00df]
[    0.468877] pnp 00:04: [dma 4]
[    0.468937] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.468961] pnp 00:05: [io  0x0060]
[    0.468962] pnp 00:05: [io  0x0064]
[    0.468977] pnp 00:05: [irq 1]
[    0.469038] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.469058] pnp 00:06: [io  0x00f0]
[    0.469066] pnp 00:06: [irq 13]
[    0.469127] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.469164] pnp 00:07: [irq 12]
[    0.469228] pnp 00:07: Plug and Play ACPI device, IDs SYN1f02 PNP0f13 (active)
[    0.469274] pnp 00:08: [io  0x0070-0x0077]
[    0.469341] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.469361] pnp 00:09: [io  0x0061]
[    0.469426] pnp 00:09: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.469528] pnp 00:0a: [irq 0 disabled]
[    0.469537] pnp 00:0a: [irq 8]
[    0.469538] pnp 00:0a: [mem 0xfed00000-0xfed003ff]
[    0.469650] system 00:0a: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.469655] system 00:0a: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.470304] pnp 00:0b: [bus ff]
[    0.470434] pnp 00:0b: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.470565] pnp: PnP ACPI: found 12 devices
[    0.470567] ACPI: ACPI bus type pnp unregistered
[    0.475136] PCI: max bus depth: 1 pci_try_num: 2
[    0.475172] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.475176] pci 0000:00:1c.1: BAR 13: assigned [io  0x3000-0x3fff]
[    0.475180] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.475183] pci 0000:00:1c.0: PCI bridge to [bus 08-0f]
[    0.475186] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.475191] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.475196] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.475203] pci 0000:00:1c.1: PCI bridge to [bus 10-17]
[    0.475206] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.475211] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.475216] pci 0000:00:1c.1:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.475223] pci 0000:00:1e.0: PCI bridge to [bus 48-48]
[    0.475272] pci 0000:00:1e.0: setting latency timer to 64
[    0.475276] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.475278] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.475279] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.475281] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.475283] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.475285] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.475286] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfeafffff]
[    0.475288] pci_bus 0000:08: resource 0 [io  0x2000-0x2fff]
[    0.475290] pci_bus 0000:08: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.475292] pci_bus 0000:08: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.475294] pci_bus 0000:10: resource 0 [io  0x3000-0x3fff]
[    0.475296] pci_bus 0000:10: resource 1 [mem 0xf2400000-0xf24fffff]
[    0.475297] pci_bus 0000:10: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.475300] pci_bus 0000:48: resource 4 [io  0x0000-0x0cf7]
[    0.475301] pci_bus 0000:48: resource 5 [io  0x0d00-0xffff]
[    0.475303] pci_bus 0000:48: resource 6 [mem 0x000a0000-0x000bffff]
[    0.475305] pci_bus 0000:48: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.475306] pci_bus 0000:48: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.475308] pci_bus 0000:48: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.475310] pci_bus 0000:48: resource 10 [mem 0xc0000000-0xfeafffff]
[    0.475312] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    0.475314] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xfffffffff]
[    0.475347] NET: Registered protocol family 2
[    0.475594] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.476679] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.478700] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    0.480810] TCP: Hash tables configured (established 524288 bind 65536)
[    0.480838] TCP reno registered
[    0.480913] UDP hash table entries: 4096 (order: 7, 786432 bytes)
[    0.481240] UDP-Lite hash table entries: 4096 (order: 7, 786432 bytes)
[    0.481635] NET: Registered protocol family 1
[    0.481655] pci 0000:00:02.0: Boot video device
[    0.481855] PCI: CLS 64 bytes, default 64
[    0.481954] Unpacking initramfs...
[    0.566773] Freeing initrd memory: 4908k freed
[    0.567837] DMAR: No ATSR found
[    0.567980] IOMMU 0 0xfed90000: using Register based invalidation
[    0.567982] IOMMU 2 0xfed93000: using Register based invalidation
[    0.567993] IOMMU: Setting RMRR:
[    0.568036] IOMMU: Setting identity map for device 0000:00:1d.0 [0xbb6e9000 - 0xbb6fffff]
[    0.568114] IOMMU: Setting identity map for device 0000:00:1a.0 [0xbb6e9000 - 0xbb6fffff]
[    0.568151] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    0.568175] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[    0.568518] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    0.570902] Simple Boot Flag at 0x7b set to 0x1
[    0.571718] audit: initializing netlink socket (disabled)
[    0.571757] type=2000 audit(1334761874.405:1): initialized
[    0.587151] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.590914] VFS: Disk quotas dquot_6.5.2
[    0.590976] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.591587] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.591754] msgmni has been set to 15654
[    0.592263] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.592274] io scheduler noop registered
[    0.592276] io scheduler deadline registered
[    0.592361] io scheduler cfq registered (default)
[    0.592363] start plist test
[    0.592997] end plist test
[    0.593350] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.593411] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.593491] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.614657] 0000:00:16.3: ttyS0 at I/O 0x1830 (irq = 17) is a 16550A
[    0.615320] Linux agpgart interface v0.103
[    0.615680] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    0.615919] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.617218] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    0.617402] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.617790] intel_idle: MWAIT substates: 0x1120
[    0.617792] intel_idle: v0.4 model 0x25
[    0.617793] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.617998] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.618153] ACPI: AC Adapter [AC] (on-line)
[    0.618349] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.618405] ACPI: Lid Switch [LID]
[    0.618470] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.618486] ACPI: Power Button [PWRB]
[    0.618548] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.618552] ACPI: Sleep Button [SLPB]
[    0.618622] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.618626] ACPI: Power Button [PWRF]
[    0.623920] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    0.623998] XENFS: not registering filesystem on non-xen platform
[    0.624046] [drm] Initialized drm 1.1.0 20060810
[    0.624427] [drm] radeon defaulting to kernel modesetting.
[    0.624429] [drm] radeon kernel modesetting enabled.
[    0.624582] i915 0000:00:02.0: setting latency timer to 64
[    0.631636] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.631649] ACPI: Battery Slot [CMB1] (battery present)
[    0.631697] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.631707] ACPI: Battery Slot [CMB2] (battery absent)
[    0.751090] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.751103] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.751105] [drm] Driver supports precise vblank timestamp query.
[    0.751183] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.483095] fbcon: inteldrmfb (fb0) is primary device
[    1.570932] Refined TSC clocksource calibration: 2659.999 MHz.
[    1.570937] Switching to clocksource tsc
[    1.933648] Console: switching to colour frame buffer device 170x48
[    1.936058] fb0: inteldrmfb frame buffer device
[    1.936060] drm: registered panic notifier
[    1.937953] acpi device:04: registered as cooling_device4
[    1.938086] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    1.938094] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    1.938155] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.939917] loop: module loaded
[    1.940031] Loading iSCSI transport class v2.0-870.
[    1.940156] iscsi: registered transport (tcp)
[    1.940230] ahci 0000:00:1f.2: version 3.0
[    1.940314] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    1.940382] ahci: SSS flag set, parallel bus scan disabled
[    1.950853] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x13 impl SATA mode
[    1.950861] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
[    1.950871] ahci 0000:00:1f.2: setting latency timer to 64
[    1.955851] scsi0 : ahci
[    1.956019] scsi1 : ahci
[    1.956131] scsi2 : ahci
[    1.956241] scsi3 : ahci
[    1.956351] scsi4 : ahci
[    1.956463] scsi5 : ahci
[    1.957101] ata1: SATA max UDMA/133 abar m2048@0xf272a000 port 0xf272a100 irq 43
[    1.957104] ata2: SATA max UDMA/133 abar m2048@0xf272a000 port 0xf272a180 irq 43
[    1.957106] ata3: DUMMY
[    1.957107] ata4: DUMMY
[    1.957109] ata5: SATA max UDMA/133 abar m2048@0xf272a000 port 0xf272a300 irq 43
[    1.957110] ata6: DUMMY
[    1.957576] scsi6 : pata_legacy
[    1.957647] ata7: PATA max PIO4 cmd 0x1f0 ctl 0x3f6 irq 14
[    2.261049] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.262603] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.262606] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.262992] ata1.00: ATA-8: ST9320325AS, 0001SDM1, max UDMA/133
[    2.262998] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.264988] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.264991] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.265354] ata1.00: configured for UDMA/133
[    2.265625] scsi 0:0:0:0: Direct-Access     ATA      ST9320325AS      0001 PQ: 0 ANSI: 5
[    2.265900] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    2.265991] sd 0:0:0:0: [sda] Write Protect is off
[    2.265994] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.266044] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.272910]  sda: sda1 sda2
[    2.273335] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.621153] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.622503] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.623128] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    2.623137] ata2.00: ATAPI: MATSHITA BD-RE UJ242, 1.00, max UDMA/100
[    2.625234] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.625838] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    2.625847] ata2.00: configured for UDMA/100
[    2.628773] scsi 1:0:0:0: CD-ROM            MATSHITA BD-RE UJ242      1.00 PQ: 0 ANSI: 5
[    2.636209] sr0: scsi3-mmc drive: 62x/62x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.636215] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.636437] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.940346] ata5: SATA link down (SStatus 0 SControl 300)
[    2.941411] scsi7 : pata_legacy
[    2.941488] ata8: PATA max PIO4 cmd 0x170 ctl 0x376 irq 15
[    3.092558] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.095139] i8042: Detected active multiplexing controller, rev 1.1
[    3.096557] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.096655] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    3.096696] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    3.096735] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    3.096773] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    3.096951] mousedev: PS/2 mouse device common for all mice
[    3.097401] rtc_cmos 00:08: RTC can wake from S4
[    3.097587] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    3.097617] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    3.097761] cpuidle: using governor ladder
[    3.098052] cpuidle: using governor menu
[    3.098177] TCP cubic registered
[    3.098179] Initializing XFRM netlink socket
[    3.098418] NET: Registered protocol family 10
[    3.098679] NET: Registered protocol family 17
[    3.098685] Registering the dns_resolver key type
[    3.098949] PM: Checking hibernation image partition /dev/fujitsu-laptop/swap
[    3.125485] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    4.135502] input: PS/2 Generic Mouse as /devices/platform/i8042/serio3/input/input6
[    4.892398] psmouse serio4: synaptics: Touchpad model: 1, fw: 7.4, id: 0x180b1, caps: 0xd04733/0xa42000/0xa0000
[    4.932592] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input7
[    4.935937] PM: Hibernation image not present or could not be loaded.
[    4.936007] registered taskstats version 1
[    4.936875] rtc_cmos 00:08: setting system clock to 2012-04-18 15:11:19 UTC (1334761879)
[    4.942024] Freeing unused kernel memory: 2432k freed
[    4.942471] Write protecting the kernel read-only data: 12288k
[    4.946793] Freeing unused kernel memory: 1632k freed
[    4.949748] Freeing unused kernel memory: 1024k freed
[    5.009799] device-mapper: uevent: version 1.0.3
[    5.010015] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    5.014837] udevd[137]: starting version 182
[    5.126476] pata_acpi 0000:00:16.2: setting latency timer to 64
[    5.126848] ata_generic 0000:00:16.2: setting latency timer to 64
[    5.127778] scsi8 : ata_generic
[    5.128049] scsi9 : ata_generic
[    5.128176] ata9: PATA max UDMA/100 cmd 0x1828 ctl 0x180c bmdma 0x1810 irq 18
[    5.128178] ata10: PATA max UDMA/100 cmd 0x1820 ctl 0x1808 bmdma 0x1818 irq 18
[    5.134738] usbcore: registered new interface driver usbfs
[    5.134862] usbcore: registered new interface driver hub
[    5.135194] usbcore: registered new device driver usb
[    5.453407] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.454080] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.454088] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    5.454407] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    5.454533] ehci_hcd 0000:00:1a.0: debug port 2
[    5.506708] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    5.506764] ehci_hcd 0000:00:1a.0: irq 22, io mem 0xf2728000
[    5.509565] dracut: luksOpen /dev/sda2 luks-17b941de-1e5c-46db-b394-f498d50a1d68 
[    5.511924] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    5.513250] hub 1-0:1.0: USB hub found
[    5.513266] hub 1-0:1.0: 3 ports detected
[    5.513923] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.513930] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    5.513971] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    5.514057] ehci_hcd 0000:00:1d.0: debug port 2
[    5.518035] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    5.518053] ehci_hcd 0000:00:1d.0: irq 22, io mem 0xf2729000
[    5.523909] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    5.524404] hub 2-0:1.0: USB hub found
[    5.524414] hub 2-0:1.0: 3 ports detected
[    5.814223] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    5.929378] hub 1-1:1.0: USB hub found
[    5.929575] hub 1-1:1.0: 6 ports detected
[    6.032637] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    6.147976] hub 2-1:1.0: USB hub found
[    6.148105] hub 2-1:1.0: 8 ports detected
[    6.423852] usb 2-1.1: new full-speed USB device number 3 using ehci_hcd
[    6.585448] usb 2-1.3: new high-speed USB device number 4 using ehci_hcd
[    6.775113] usb 2-1.4: new full-speed USB device number 5 using ehci_hcd
[   13.057187] dracut: Scanning devices dm-0  for LVM logical volumes fujitsu-laptop/gentoo32b-root
[   13.109145] dracut: inactive '/dev/fujitsu-laptop/gentoo32b-root' [13.00 GiB] inherit
[   13.109347] dracut: inactive '/dev/fujitsu-laptop/swap' [5.00 GiB] inherit
[   13.109502] dracut: inactive '/dev/fujitsu-laptop/home' [100.00 GiB] inherit
[   13.109659] dracut: inactive '/dev/fujitsu-laptop/libvirt' [125.00 GiB] inherit
[   13.109843] dracut: inactive '/dev/fujitsu-laptop/gentoo32-root' [16.00 GiB] inherit
[   13.110025] dracut: inactive '/dev/fujitsu-laptop/backup' [10.00 GiB] inherit
[   13.110190] dracut: inactive '/dev/fujitsu-laptop/gentoo32a-root' [10.00 GiB] inherit
[   13.110356] dracut: inactive '/dev/fujitsu-laptop/gentoo64a-root' [14.09 GiB] inherit
[   13.329366] dracut: Scanning devices dm-0  for LVM volume groups fujitsu-laptop
[   13.342583] dracut: Reading all physical volumes. This may take a while...
[   13.486910] dracut: Found volume group "fujitsu-laptop" using metadata type lvm2
[   13.552929] dracut: 8 logical volume(s) in volume group "fujitsu-laptop" now active
[   16.268432] PM: Marking nosave pages: 000000000009b000 - 0000000000100000
[   16.268441] PM: Marking nosave pages: 00000000ba94d000 - 00000000bac30000
[   16.268463] PM: Marking nosave pages: 00000000bb27c000 - 00000000bb282000
[   16.268467] PM: Marking nosave pages: 00000000bb3cb000 - 00000000bb40f000
[   16.268473] PM: Marking nosave pages: 00000000bb64f000 - 00000000bb70f000
[   16.268481] PM: Marking nosave pages: 00000000bb717000 - 00000000bb71f000
[   16.268485] PM: Marking nosave pages: 00000000bb76f000 - 00000000bb79f000
[   16.268490] PM: Marking nosave pages: 00000000bb7de000 - 00000000bb7ff000
[   16.268495] PM: Marking nosave pages: 00000000bb800000 - 0000000100000000
[   16.270314] PM: Marking nosave pages: 00000001fc000000 - 0000000200000000
[   16.270717] PM: Basic memory bitmaps created
[   16.356365] PM: Basic memory bitmaps freed
[   16.356374] video LNXVIDEO:00: Restoring backlight state
[   16.362253] PM: Starting manual resume from disk
[   16.362258] PM: Hibernation image partition 252:2 present
[   16.362261] PM: Looking for hibernation image.
[   16.362804] PM: Image not found (code -22)
[   16.362811] PM: Hibernation image not present or could not be loaded.
[   16.483087] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   16.629822] dracut: Checking ext4: /dev/fujitsu-laptop/gentoo32b-root
[   16.629917] dracut: issuing e2fsck -a  /dev/fujitsu-laptop/gentoo32b-root
[   16.819365] dracut: /dev/fujitsu-laptop/gentoo32b-root: clean, 568764/851968 files, 2432407/3407872 blocks
[   16.819972] dracut: Remounting /dev/fujitsu-laptop/gentoo32b-root with -o noatime,ro
[   16.877756] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   16.964579] dracut: Mounted root filesystem /dev/mapper/fujitsu--laptop-gentoo32b--root
[   17.157988] dracut: Switching root
[   19.567247] EXT4-fs (dm-1): re-mounted. Opts: (null)
[   19.676241] udevd[454]: starting version 182
[   19.939053] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[   20.467862] input: Fujitsu FUJ02B1 as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:09/FUJ02B1:00/input/input8
[   20.469831] fujitsu_laptop: ACPI: Fujitsu FUJ02B1 [FJEX] (on)
[   20.480045] input: Fujitsu FUJ02E3 as /devices/LNXSYSTM:00/device:00/FUJ02E3:00/input/input9
[   20.480310] fujitsu_laptop: ACPI: Fujitsu FUJ02E3 [FEXT] (on)
[   20.481508] fujitsu_laptop: BTNI: [0x10f0101]
[   20.482141] fujitsu_laptop: driver 0.6.0 successfully loaded
[   20.556952] tpm_tis 00:03: 1.2 TPM (device-id 0xB, rev-id 16)
[   20.806903] iTCO_vendor_support: vendor-support=0
[   20.818413] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[   20.818805] iTCO_wdt: Found a QM57 TCO device (Version=2, TCOBASE=0x0460)
[   20.819593] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   20.843242] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
[   20.843779] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[   20.889980] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[   20.889985] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[   20.890077] e1000e 0000:00:19.0: setting latency timer to 64
[   20.890427] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   20.927916] Linux media interface: v0.10
[   20.970663] mei: module is from the staging directory, the quality is unknown, you have been warned.
[   21.068843] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 8c:73:6e:d8:dc:e2
[   21.068849] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   21.068914] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: FFFFFF-0FF
[   21.069040] mei 0000:00:16.0: setting latency timer to 64
[   21.069221] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[   21.139246] watchdog: INTCAMT: cannot register miscdev on minor=130 (err=-16).
[   21.139322] watchdog: error registering /dev/watchdog (err=-16).
[   21.139373] mei 0000:00:16.0: unable to register watchdog device.
[   21.383991] Bluetooth: Core ver 2.16
[   21.384046] NET: Registered protocol family 31
[   21.384050] Bluetooth: HCI device and connection manager initialized
[   21.384187] Bluetooth: HCI socket layer initialized
[   21.384196] Bluetooth: L2CAP socket layer initialized
[   21.384230] Bluetooth: SCO socket layer initialized
[   21.404752] usbcore: registered new interface driver btusb
[   21.425099] cfg80211: Calling CRDA to update world regulatory domain
[   21.474566] Linux video capture interface: v2.00
[   22.084518] uvcvideo: Found UVC 1.00 device FJ Camera (04f2:b186)
[   22.118987] input: PC Speaker as /devices/platform/pcspkr/input/input10
[   22.127655] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[   22.399296] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   22.399302] Copyright(c) 2003-2011 Intel Corporation
[   22.399585] iwlwifi 0000:10:00.0: pci_resource_len = 0x00002000
[   22.399596] iwlwifi 0000:10:00.0: pci_resource_base = ffffc90000c70000
[   22.399606] iwlwifi 0000:10:00.0: HW Revision ID = 0x35
[   22.399760] iwlwifi 0000:10:00.0: irq 47 for MSI/MSI-X
[   22.399889] iwlwifi 0000:10:00.0: CONFIG_IWLWIFI_DEBUG disabled
[   22.399897] iwlwifi 0000:10:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   22.399904] iwlwifi 0000:10:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[   22.399911] iwlwifi 0000:10:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[   22.399917] iwlwifi 0000:10:00.0: CONFIG_IWLWIFI_P2P disabled
[   22.399928] iwlwifi 0000:10:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
[   22.400212] iwlwifi 0000:10:00.0: L1 Disabled; Enabling L0S
[   22.414661] iwlwifi 0000:10:00.0: device EEPROM VER=0x436, CALIB=0x6
[   22.414667] iwlwifi 0000:10:00.0: Device SKU: 0x1F0
[   22.414692] iwlwifi 0000:10:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   22.453858] iwlwifi 0000:10:00.0: loaded firmware version 9.221.4.1 build 25532
[   22.454279] Registered led device: phy0-led
[   22.651892] input: FJ Camera as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input11
[   22.652315] usbcore: registered new interface driver uvcvideo
[   22.652322] USB Video Class driver (1.1.1)
[   22.684887] tpm_tis 00:03: A TPM error (7) occurred attempting to read a pcr value
[   22.684962] tpm_tis 00:03: TPM is disabled/deactivated (0x7)
[   22.788106] hda_codec: ALC269: SKU not ready 0x90970130
[   22.906915] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   23.024320] HDMI status: Codec=3 Pin=4 Presence_Detect=0 ELD_Valid=0
[   23.024575] input: HDA Intel HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   23.024887] input: HDA Intel Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   23.025244] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   23.025585] input: HDA Intel Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[   23.025932] input: HDA Intel Dock Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
[   24.036268] Adding 5242876k swap on /dev/mapper/fujitsu--laptop-swap.  Priority:0 extents:1 across:5242876k 
[   26.641840] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   26.642553] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: (null)
[   26.643127] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: (null)
[   30.493440] Bridge firewalling registered
[   30.522712] tun: Universal TUN/TAP device driver, 1.6
[   30.522717] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   30.550669] device virbr0-nic entered promiscuous mode
[   31.124882] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   31.175782] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   31.177615] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   31.186858] iwlwifi 0000:10:00.0: L1 Disabled; Enabling L0S
[   31.193679] iwlwifi 0000:10:00.0: Radio type=0x1-0x3-0x1
[   31.240947] ip_tables: (C) 2000-2006 Netfilter Core Team
[   31.423083] iwlwifi 0000:10:00.0: L1 Disabled; Enabling L0S
[   31.429875] iwlwifi 0000:10:00.0: Radio type=0x1-0x3-0x1
[   31.522654] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   31.926259] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   32.065632] ADDRCONF(NETDEV_UP): virbr0: link is not ready
[   33.128548] Ebtables v2.0 registered
[   33.208381] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   39.306555] wlan0: authenticate with bc:ae:c5:c4:c2:d6 (try 1)
[   39.310415] wlan0: authenticated
[   39.359946] wlan0: waiting for beacon from bc:ae:c5:c4:c2:d6
[   39.380712] wlan0: beacon received
[   39.385072] wlan0: associate with bc:ae:c5:c4:c2:d6 (try 1)
[   39.391453] wlan0: RX AssocResp from bc:ae:c5:c4:c2:d6 (capab=0x411 status=0 aid=2)
[   39.391459] wlan0: associated
[   39.391468] wlan0: moving STA bc:ae:c5:c4:c2:d6 to state 1
[   39.391472] wlan0: moving STA bc:ae:c5:c4:c2:d6 to state 2
[   39.399196] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   39.409792] wlan0: moving STA bc:ae:c5:c4:c2:d6 to state 3
[   39.852854] ata1.00: configured for UDMA/133
[   39.852865] ata1: EH complete
[   40.431079] EXT4-fs (dm-1): re-mounted. Opts: commit=0
[   40.440941] EXT4-fs (sda1): re-mounted. Opts: commit=0
[   40.444690] EXT4-fs (dm-3): re-mounted. Opts: commit=0
[   40.573903] EXT4-fs (dm-4): re-mounted. Opts: commit=0
[   55.116101] fuse init (API version 7.18)
[   58.890559] ICMPv6 RA: ndisc_router_discovery() failed to add default route.
[   74.825302] ICMPv6 RA: ndisc_router_discovery() failed to add default route.
[  304.676562] BUG: sleeping function called from invalid context at include/linux/kernel.h:182
[  304.676569] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  304.676574] 1 lock held by NetworkManager/676:
[  304.676576]  #0:  (rcu_read_lock){......}, at: [<ffffffff81603add>] inet6_dump_fib+0x3d/0x310
[  304.676597] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  304.676601] Call Trace:
[  304.676612]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  304.676620]  [<ffffffff8156d068>] put_cmsg_compat+0x98/0x1c0
[  304.676627]  [<ffffffff8154a435>] put_cmsg+0x125/0x130
[  304.676634]  [<ffffffff815787dc>] netlink_recvmsg+0x31c/0x4b0
[  304.676641]  [<ffffffff8153f558>] ? sock_update_classid+0xa8/0x120
[  304.676647]  [<ffffffff8153b375>] sock_recvmsg+0x115/0x130
[  304.676655]  [<ffffffff810a625e>] ? put_lock_stats.clone.14+0xe/0x40
[  304.676660]  [<ffffffff810a6338>] ? lock_release_holdtime+0xa8/0x150
[  304.676667]  [<ffffffff8112b8cf>] ? do_wp_page+0xcf/0x800
[  304.676673]  [<ffffffff8107fd31>] ? get_parent_ip+0x11/0x50
[  304.676679]  [<ffffffff8156cc4b>] ? verify_compat_iovec+0x8b/0x150
[  304.676684]  [<ffffffff8153ae9e>] __sys_recvmsg+0x14e/0x2c0
[  304.676692]  [<ffffffff8165a24d>] ? sub_preempt_count+0x9d/0xd0
[  304.676697]  [<ffffffff810a625e>] ? put_lock_stats.clone.14+0xe/0x40
[  304.676702]  [<ffffffff810a6338>] ? lock_release_holdtime+0xa8/0x150
[  304.676709]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  304.676714]  [<ffffffff81161f0f>] ? fget_light+0xbf/0x150
[  304.676719]  [<ffffffff81161f2c>] ? fget_light+0xdc/0x150
[  304.676723]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  304.676729]  [<ffffffff8153db04>] sys_recvmsg+0x44/0x80
[  304.676735]  [<ffffffff8156d7ff>] compat_sys_recvmsg+0xf/0x20
[  304.676740]  [<ffffffff8156d9f5>] compat_sys_socketcall+0xe5/0x250
[  304.676745]  [<ffffffff8165710a>] ? error_exit+0x6a/0xb0
[  304.676751]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  304.677120] 
[  304.677124] ================================================
[  304.677128] [ BUG: lock held when returning to user space! ]
[  304.677133] 3.3.0-gentoo #4 Tainted: G         C  
[  304.677136] ------------------------------------------------
[  304.677141] NetworkManager/676 is leaving the kernel with locks still held!
[  304.677145] 1 lock held by NetworkManager/676:
[  304.677148]  #0:  (rcu_read_lock){......}, at: [<ffffffff81603add>] inet6_dump_fib+0x3d/0x310
[  306.400786] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  306.400792] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  306.400796] INFO: lockdep is turned off.
[  306.400801] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  306.400804] Call Trace:
[  306.400815]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  306.400824]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  306.400831]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  306.400838]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  306.400845]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  306.400851]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  306.400856]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  306.400862]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  306.400867]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  306.400872]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  306.400877]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  306.400883]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  306.400888]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  306.400893]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  306.400899]  [<ffffffff81161f2c>] ? fget_light+0xdc/0x150
[  306.400904]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  306.400913]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  306.400919]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  306.400925]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  306.400931]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  306.400936]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  306.400986] sched: RT throttling activated
[  310.389617] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  310.389625] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  310.389630] INFO: lockdep is turned off.
[  310.389636] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  310.389640] Call Trace:
[  310.389655]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  310.389667]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  310.389703]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  310.389711]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  310.389720]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  310.389727]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  310.389736]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  310.389745]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  310.389753]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  310.389760]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  310.389769]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  310.389776]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  310.389785]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  310.389793]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  310.389801]  [<ffffffff81161f2c>] ? fget_light+0xdc/0x150
[  310.389808]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  310.389820]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  310.389830]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  310.389839]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  310.389849]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  310.389859]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  313.381455] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  313.381463] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  313.381467] INFO: lockdep is turned off.
[  313.381473] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  313.381477] Call Trace:
[  313.381489]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  313.381498]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  313.381505]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  313.381512]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  313.381519]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  313.381526]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  313.381533]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  313.381540]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  313.381546]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  313.381552]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  313.381559]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  313.381565]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  313.381571]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  313.381578]  [<ffffffff8116db9e>] ? putname+0x2e/0x40
[  313.381588]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  313.381596]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  313.381602]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  313.381609]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  313.381616]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  314.379663] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  314.379696] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  314.379702] INFO: lockdep is turned off.
[  314.379707] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  314.379712] Call Trace:
[  314.379726]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  314.379737]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  314.379745]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  314.379753]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  314.379761]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  314.379771]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  314.379781]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  314.379790]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  314.379798]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  314.379807]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  314.379815]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  314.379822]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  314.379830]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  314.379839]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  314.379848]  [<ffffffff81161f2c>] ? fget_light+0xdc/0x150
[  314.379856]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  314.379870]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  314.379880]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  314.379888]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  314.379897]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  314.379907]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  318.368986] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  318.368995] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  318.368999] INFO: lockdep is turned off.
[  318.369005] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  318.369009] Call Trace:
[  318.369025]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  318.369036]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  318.369045]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  318.369053]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  318.369061]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  318.369068]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  318.369075]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  318.369082]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  318.369088]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  318.369094]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  318.369101]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  318.369107]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  318.369113]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  318.369120]  [<ffffffff8116db9e>] ? putname+0x2e/0x40
[  318.369131]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  318.369139]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  318.369146]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  318.369153]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  318.369160]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  319.366776] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  319.366784] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  319.366789] INFO: lockdep is turned off.
[  319.366795] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  319.366799] Call Trace:
[  319.366813]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  319.366823]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  319.366832]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  319.366839]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  319.366847]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  319.366854]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  319.366861]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  319.366867]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  319.366873]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  319.366880]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  319.366886]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  319.366892]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  319.366899]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  319.366905]  [<ffffffff8116db9e>] ? putname+0x2e/0x40
[  319.366916]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  319.366924]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  319.366931]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  319.366938]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  319.366945]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  322.359057] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  322.359066] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  322.359071] INFO: lockdep is turned off.
[  322.359077] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  322.359081] Call Trace:
[  322.359098]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  322.359109]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  322.359118]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  322.359126]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  322.359135]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  322.359142]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  322.359149]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  322.359155]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  322.359162]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  322.359168]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  322.359174]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  322.359181]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  322.359187]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  322.359194]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  322.359200]  [<ffffffff81161f2c>] ? fget_light+0xdc/0x150
[  322.359206]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  322.359217]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  322.359225]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  322.359232]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  322.359238]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  322.359246]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  325.351860] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  325.351868] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  325.351873] INFO: lockdep is turned off.
[  325.351879] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  325.351884] Call Trace:
[  325.351899]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  325.351910]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  325.351919]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  325.351927]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  325.351936]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  325.351943]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  325.351949]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  325.351956]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  325.351962]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  325.351969]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  325.351975]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  325.351981]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  325.351988]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  325.351994]  [<ffffffff8116db9e>] ? putname+0x2e/0x40
[  325.352005]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  325.352013]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  325.352020]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  325.352027]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  325.352035]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  326.349159] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  326.349168] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  326.349173] INFO: lockdep is turned off.
[  326.349179] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  326.349183] Call Trace:
[  326.349197]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  326.349208]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  326.349216]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  326.349224]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  326.349231]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  326.349239]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  326.349246]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  326.349252]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  326.349259]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  326.349265]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  326.349271]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  326.349277]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  326.349284]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  326.349291]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  326.349297]  [<ffffffff81161f2c>] ? fget_light+0xdc/0x150
[  326.349313]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  326.349323]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  326.349330]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  326.349337]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  326.349344]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  326.349351]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  330.339460] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  330.339468] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  330.339473] INFO: lockdep is turned off.
[  330.339479] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  330.339483] Call Trace:
[  330.339499]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  330.339510]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  330.339519]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  330.339527]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  330.339536]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  330.339543]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  330.339550]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  330.339556]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  330.339563]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  330.339569]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  330.339575]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  330.339582]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  330.339588]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  330.339594]  [<ffffffff8116db9e>] ? putname+0x2e/0x40
[  330.339606]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  330.339614]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  330.339621]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  330.339627]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  330.339635]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  331.337023] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  331.337032] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  331.337037] INFO: lockdep is turned off.
[  331.337043] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  331.337047] Call Trace:
[  331.337062]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  331.337073]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  331.337083]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  331.337091]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  331.337099]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  331.337106]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  331.337113]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  331.337120]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  331.337126]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  331.337132]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  331.337139]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  331.337145]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  331.337151]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  331.337158]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  331.337190]  [<ffffffff81161f2c>] ? fget_light+0xdc/0x150
[  331.337196]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  331.337206]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  331.337214]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  331.337221]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  331.337228]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  331.337236]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  334.328832] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  334.328841] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  334.328846] INFO: lockdep is turned off.
[  334.328852] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  334.328856] Call Trace:
[  334.328871]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  334.328882]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  334.328891]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  334.328899]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  334.328907]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  334.328914]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  334.328920]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  334.328927]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  334.328941]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  334.328947]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  334.328953]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  334.328960]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  334.328966]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  334.328975]  [<ffffffff81659c88>] ? do_page_fault+0x1b8/0x530
[  334.328981]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  334.328992]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  334.329000]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  334.329006]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  334.329013]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  334.329021]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  335.326612] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  335.326623] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  335.326630] INFO: lockdep is turned off.
[  335.326637] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  335.326644] Call Trace:
[  335.326663]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  335.326679]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  335.326692]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  335.326704]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  335.326716]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  335.326727]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  335.326736]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  335.326746]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  335.326755]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  335.326764]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  335.326773]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  335.326783]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  335.326790]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  335.326799]  [<ffffffff8116db9e>] ? putname+0x2e/0x40
[  335.326812]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  335.326823]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  335.326831]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  335.326840]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  335.326849]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  336.735168] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  336.735173] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  336.735176] INFO: lockdep is turned off.
[  336.735180] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  336.735182] Call Trace:
[  336.735194]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  336.735202]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  336.735210]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  336.735215]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  336.735220]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  336.735224]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  336.735228]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  336.735238]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  336.735244]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  336.735251]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  336.735257]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  336.735263]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  336.735269]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  336.735276]  [<ffffffff8116db9e>] ? putname+0x2e/0x40
[  336.735287]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  336.735296]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  336.735303]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  336.735310]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  336.735318]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  336.827572] ICMPv6 RA: ndisc_router_discovery() failed to add default route.
[  336.828967] ICMPv6 RA: ndisc_router_discovery() failed to add default route.
[  336.830375] ICMPv6 RA: ndisc_router_discovery() failed to add default route.
[  336.831757] ICMPv6 RA: ndisc_router_discovery() failed to add default route.
[  338.318820] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  338.318829] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  338.318833] INFO: lockdep is turned off.
[  338.318839] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  338.318843] Call Trace:
[  338.318859]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  338.318870]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  338.318879]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  338.318887]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  338.318895]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  338.318902]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  338.318909]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  338.318915]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  338.318922]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  338.318928]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  338.318934]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  338.318940]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  338.318947]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  338.318953]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  338.318960]  [<ffffffff81161f2c>] ? fget_light+0xdc/0x150
[  338.318966]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  338.318976]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  338.318984]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  338.318991]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  338.318997]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  338.319005]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  341.311971] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  341.311979] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  341.311984] INFO: lockdep is turned off.
[  341.311990] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  341.311994] Call Trace:
[  341.312010]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  341.312021]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  341.312032]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  341.312040]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  341.312048]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  341.312055]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  341.312062]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  341.312069]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  341.312075]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  341.312082]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  341.312088]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  341.312094]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  341.312101]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  341.312108]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  341.312114]  [<ffffffff81161f2c>] ? fget_light+0xdc/0x150
[  341.312120]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  341.312130]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  341.312138]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  341.312145]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  341.312152]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  341.312185]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  342.308800] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  342.308809] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  342.308814] INFO: lockdep is turned off.
[  342.308820] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  342.308825] Call Trace:
[  342.308841]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  342.308852]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  342.308861]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  342.308869]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  342.308878]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  342.308885]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  342.308892]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  342.308898]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  342.308905]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  342.308911]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  342.308917]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  342.308924]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  342.308930]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  342.308937]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  342.308943]  [<ffffffff81161f2c>] ? fget_light+0xdc/0x150
[  342.308949]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  342.308959]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  342.308967]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  342.308974]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  342.308981]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  342.308989]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  343.306604] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  343.306612] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  343.306617] INFO: lockdep is turned off.
[  343.306623] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  343.306627] Call Trace:
[  343.306644]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  343.306655]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  343.306664]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  343.306672]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  343.306680]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  343.306688]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  343.306695]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  343.306701]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  343.306707]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  343.306714]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  343.306720]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  343.306726]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  343.306732]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  343.306739]  [<ffffffff8116db9e>] ? putname+0x2e/0x40
[  343.306750]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  343.306758]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  343.306765]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  343.306772]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  343.306780]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  346.299070] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  346.299079] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  346.299083] INFO: lockdep is turned off.
[  346.299089] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  346.299094] Call Trace:
[  346.299109]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  346.299120]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  346.299130]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  346.299138]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  346.299146]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  346.299153]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  346.299160]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  346.299167]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  346.299173]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  346.299179]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  346.299186]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  346.299192]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  346.299199]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  346.299206]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  346.299212]  [<ffffffff81161f2c>] ? fget_light+0xdc/0x150
[  346.299218]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  346.299229]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  346.299238]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  346.299245]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  346.299252]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  346.299260]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  349.291874] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  349.291882] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  349.291886] INFO: lockdep is turned off.
[  349.291893] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  349.291897] Call Trace:
[  349.291913]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  349.291924]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  349.291933]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  349.291941]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  349.291949]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  349.291957]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  349.291964]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  349.291970]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  349.291976]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  349.291983]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  349.291989]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  349.291995]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  349.292002]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  349.292008]  [<ffffffff8116db9e>] ? putname+0x2e/0x40
[  349.292020]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  349.292028]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  349.292035]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  349.292041]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  349.292049]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  350.289208] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  350.289217] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  350.289222] INFO: lockdep is turned off.
[  350.289228] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  350.289232] Call Trace:
[  350.289248]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  350.289260]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  350.289269]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  350.289277]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  350.289285]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  350.289292]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  350.289299]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  350.289306]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  350.289312]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  350.289318]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  350.289325]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  350.289331]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  350.289337]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  350.289344]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  350.289351]  [<ffffffff81161f2c>] ? fget_light+0xdc/0x150
[  350.289357]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  350.289367]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  350.289375]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  350.289382]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  350.289388]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  350.289396]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  352.762073] ICMPv6 RA: ndisc_router_discovery() failed to add default route.
[  354.279508] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  354.279516] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  354.279520] INFO: lockdep is turned off.
[  354.279527] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  354.279531] Call Trace:
[  354.279546]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  354.279557]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  354.279567]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  354.279575]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  354.279583]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  354.279590]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  354.279597]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  354.279603]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  354.279610]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  354.279616]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  354.279622]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  354.279629]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  354.279635]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  354.279642]  [<ffffffff8116db9e>] ? putname+0x2e/0x40
[  354.279654]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  354.279687]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  354.279695]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  354.279702]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  354.279710]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21
[  355.276293] BUG: sleeping function called from invalid context at kernel/mutex.c:271
[  355.276301] in_atomic(): 0, irqs_disabled(): 0, pid: 676, name: NetworkManager
[  355.276305] INFO: lockdep is turned off.
[  355.276311] Pid: 676, comm: NetworkManager Tainted: G         C   3.3.0-gentoo #4
[  355.276315] Call Trace:
[  355.276329]  [<ffffffff8107ce75>] __might_sleep+0xf5/0x120
[  355.276341]  [<ffffffff8165339a>] mutex_lock_nested+0x2a/0x3a0
[  355.276349]  [<ffffffff81161e8b>] ? fget_light+0x3b/0x150
[  355.276357]  [<ffffffff811a1dfb>] inotify_poll+0x2b/0x60
[  355.276365]  [<ffffffff811750f0>] do_sys_poll+0x2a0/0x4f0
[  355.276372]  [<ffffffff81173d20>] ? poll_freewait+0xb0/0xb0
[  355.276379]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  355.276385]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  355.276392]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  355.276398]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  355.276404]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  355.276411]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  355.276417]  [<ffffffff81173e10>] ? __pollwait+0xf0/0xf0
[  355.276423]  [<ffffffff8116db9e>] ? putname+0x2e/0x40
[  355.276435]  [<ffffffff8101b759>] ? read_tsc+0x9/0x20
[  355.276443]  [<ffffffff8109c238>] ? ktime_get_ts+0xa8/0xe0
[  355.276449]  [<ffffffff81174002>] ? poll_select_set_timeout+0x82/0x90
[  355.276456]  [<ffffffff8117540c>] sys_poll+0x6c/0x100
[  355.276464]  [<ffffffff8165f216>] sysenter_dispatch+0x7/0x21

--=-H5vF6Ax8eJozKS/jbq3T
Content-Description: 
Content-Disposition: attachment; filename="config-3.3.0"
Content-Type: text/x-mpsub; name="config-3.3.0"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.3.0-gentoo Kernel Configuration
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
CONFIG_CROSS_COMPILE="x86_64-pc-linux-gnu-"
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
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
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
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
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
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
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
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
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
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
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
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
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
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
CONFIG_PARAVIRT_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
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
CONFIG_ARCH_MEMORY_PROBE=y
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
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CLEANCACHE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
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
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_STUB=m
CONFIG_XEN_PCIDEV_FRONTEND=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
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
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_ARPD=y
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
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_PROCFS=y
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
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
# CONFIG_NETFILTER_XT_TARGET_CHECKSUM is not set
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
# CONFIG_NETFILTER_XT_TARGET_CT is not set
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_IPVS is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
CONFIG_NETFILTER_XT_MATCH_REALM=m
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
# CONFIG_IP_VS_IPV6 is not set
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
# CONFIG_IP_VS_PE_SIP is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
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
# CONFIG_IP_NF_SECURITY is not set
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
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
# CONFIG_IP6_NF_SECURITY is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
# CONFIG_BRIDGE_EBT_IP6 is not set
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_NET_DCCPPROBE is not set
CONFIG_IP_SCTP=m
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_RDS=m
CONFIG_RDS_RDMA=m
CONFIG_RDS_TCP=m
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=m
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
CONFIG_WAN_ROUTER=m
CONFIG_PHONET=m
CONFIG_IEEE802154=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=m
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
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
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
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
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
CONFIG_BT_ATH3K=m
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=m
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
# CONFIG_DMA_SHARED_BUFFER is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
CONFIG_BLK_CPQ_DA=m
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
CONFIG_BLK_DEV_DRBD=m
# CONFIG_DRBD_FAULT_INJECTION is not set
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_NVME=m
CONFIG_BLK_DEV_SX8=m
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_XEN_BLKDEV_BACKEND is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RBD=m

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
CONFIG_IBM_ASM=m
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=m
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085 is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=m
# CONFIG_CB710_CORE is not set
CONFIG_IWMC3200TOP=m
# CONFIG_IWMC3200TOP_DEBUG is not set
# CONFIG_IWMC3200TOP_DEBUGFS is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=y
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
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_CXGB3_ISCSI=m
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=m
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=m
# CONFIG_SCSI_MVSAS_DEBUG is not set
# CONFIG_SCSI_MVSAS_TASKLET is not set
CONFIG_SCSI_MVUMI=m
CONFIG_SCSI_DPT_I2O=m
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_ARCMSR=m
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=m
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_EATA=m
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=m
# CONFIG_SCSI_ISCI is not set
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=m
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=m
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_SRP=m
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_SATA_INIC162X=m
# CONFIG_SATA_ACARD_AHCI is not set
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_SVW=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARASAN_CF=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
# CONFIG_PATA_ATP867X is not set
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
CONFIG_PATA_CS5530=m
CONFIG_PATA_CS5536=m
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=m
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=m
CONFIG_PATA_IT821X=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
CONFIG_PATA_NS87415=m
CONFIG_PATA_OLDPIIX=m
CONFIG_PATA_OPTIDMA=m
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_PDC_OLD=m
CONFIG_PATA_RADISYS=m
CONFIG_PATA_RDC=m
CONFIG_PATA_SC1200=m
CONFIG_PATA_SCH=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_TOSHIBA=m
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=m

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=m
CONFIG_PATA_MPIIX=m
CONFIG_PATA_NS87410=m
CONFIG_PATA_OPTI=m
CONFIG_PATA_PCMCIA=m
CONFIG_PATA_RZ1000=m

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_LEGACY=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MULTICORE_RAID456=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=m
CONFIG_DM_PERSISTENT_DATA=m
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
# CONFIG_DM_DEBUG_SPACE_MAPS is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_RAID=m
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LAN=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
# CONFIG_DUMMY is not set
CONFIG_EQUALIZER=m
CONFIG_NET_FC=y
CONFIG_MII=m
CONFIG_IEEE802154_DRIVERS=m
# CONFIG_IEEE802154_FAKEHARD is not set
# CONFIG_IFB is not set
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=m
CONFIG_SUNGEM_PHY=m
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
# CONFIG_ATM_ZATM_DEBUG is not set
CONFIG_ATM_NICSTAR=m
# CONFIG_ATM_NICSTAR_USE_SUNI is not set
# CONFIG_ATM_NICSTAR_USE_IDT77105 is not set
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=m
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=m
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=m
CONFIG_ATM_HE_USE_SUNI=y
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
CONFIG_MDIO=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_3C589=m
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=m
CONFIG_PCNET32=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=m
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=m
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3=m
CONFIG_CHELSIO_T4=m
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=m
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DE600=m
CONFIG_DE620=m
CONFIG_DL2K=m
CONFIG_SUNDANCE=m
CONFIG_SUNDANCE_MMIO=y
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=m
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=m
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=m
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_IGB=m
CONFIG_IGB_DCA=y
CONFIG_IGBVF=m
CONFIG_IXGB=m
CONFIG_IXGBE=m
CONFIG_IXGBE_DCA=y
# CONFIG_IXGBEVF is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_ZNET=m
CONFIG_IP1000=m
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_SKGE=m
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
CONFIG_FEALNX=m
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=m
CONFIG_NS83820=m
CONFIG_NET_VENDOR_8390=y
CONFIG_PCMCIA_AXNET=m
CONFIG_NE2K_PCI=m
CONFIG_PCMCIA_PCNET=m
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=m
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=m
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
CONFIG_NETXEN_NIC=m
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=m
CONFIG_8139CP=m
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=m
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_SEEQ8005=m
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=m
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=m
CONFIG_SIS190=m
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_PCMCIA_SMC91C92=m
CONFIG_EPIC100=m
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=m
# CONFIG_STMMAC_PLATFORM is not set
CONFIG_STMMAC_PCI=m
# CONFIG_STMMAC_DEBUG_FS is not set
# CONFIG_STMMAC_DA is not set
CONFIG_STMMAC_RING=y
# CONFIG_STMMAC_CHAINED is not set
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NIU=m
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=m
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=m
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
CONFIG_VIA_VELOCITY=m
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_FDDI=y
CONFIG_DEFXX=m
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=m
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=m
# CONFIG_ROADRUNNER_LARGE_RINGS is not set
CONFIG_NET_SB1000=m
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
CONFIG_MDIO_BITBANG=m
# CONFIG_MICREL_KS8995MA is not set
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
# CONFIG_PPTP is not set
# CONFIG_PPPOL2TP is not set
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
# CONFIG_TR is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SMSC75XX=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=m
# CONFIG_USB_CDC_PHONET is not set
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
CONFIG_USB_VL600=m
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
CONFIG_AIRO=m
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
CONFIG_PCMCIA_ATMEL=m
CONFIG_AT76C50X_USB=m
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
CONFIG_PRISM54=m
CONFIG_USB_ZD1201=m
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_RTL8180=m
CONFIG_RTL8187=m
CONFIG_RTL8187_LEDS=y
CONFIG_ADM8211=m
# CONFIG_MAC80211_HWSIM is not set
CONFIG_MWL8K=m
CONFIG_ATH_COMMON=m
# CONFIG_ATH_DEBUG is not set
CONFIG_ATH5K=m
# CONFIG_ATH5K_DEBUG is not set
# CONFIG_ATH5K_TRACER is not set
CONFIG_ATH5K_PCI=y
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K=m
CONFIG_ATH9K_PCI=y
# CONFIG_ATH9K_AHB is not set
# CONFIG_ATH9K_DEBUGFS is not set
CONFIG_ATH9K_RATE_CONTROL=y
CONFIG_ATH9K_BTCOEX_SUPPORT=y
CONFIG_ATH9K_HTC=m
# CONFIG_ATH9K_HTC_DEBUGFS is not set
CONFIG_CARL9170=m
CONFIG_CARL9170_LEDS=y
CONFIG_CARL9170_WPC=y
# CONFIG_CARL9170_HWRNG is not set
CONFIG_ATH6KL=m
# CONFIG_ATH6KL_DEBUG is not set
CONFIG_B43=m
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
# CONFIG_B43_SDIO is not set
CONFIG_B43_PIO=y
CONFIG_B43_PHY_N=y
CONFIG_B43_PHY_LP=y
CONFIG_B43_PHY_HT=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_BRCMUTIL=m
CONFIG_BRCMFMAC=m
CONFIG_BRCMFMAC_SDIO=y
# CONFIG_BRCMDBG is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=m
CONFIG_HOSTAP_PCI=m
CONFIG_HOSTAP_CS=m
CONFIG_IPW2100=m
CONFIG_IPW2100_MONITOR=y
# CONFIG_IPW2100_DEBUG is not set
CONFIG_IPW2200=m
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=m
# CONFIG_LIBIPW_DEBUG is not set
CONFIG_IWLWIFI=m

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
# CONFIG_IWLWIFI_P2P is not set
CONFIG_IWLEGACY=m

#
# Debugging Options
#
# CONFIG_IWLEGACY_DEBUG is not set
CONFIG_IWL4965=m
CONFIG_IWL3945=m
CONFIG_IWM=m
# CONFIG_IWM_DEBUG is not set
# CONFIG_IWM_TRACING is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_CS=m
CONFIG_LIBERTAS_SDIO=m
# CONFIG_LIBERTAS_SPI is not set
# CONFIG_LIBERTAS_DEBUG is not set
CONFIG_LIBERTAS_MESH=y
CONFIG_HERMES=m
# CONFIG_HERMES_PRISM is not set
CONFIG_HERMES_CACHE_FW_ON_INIT=y
CONFIG_PLX_HERMES=m
CONFIG_TMD_HERMES=m
CONFIG_NORTEL_HERMES=m
CONFIG_PCMCIA_HERMES=m
CONFIG_PCMCIA_SPECTRUM=m
# CONFIG_ORINOCO_USB is not set
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
# CONFIG_P54_SPI is not set
CONFIG_P54_LEDS=y
CONFIG_RT2X00=m
CONFIG_RT2400PCI=m
CONFIG_RT2500PCI=m
CONFIG_RT61PCI=m
# CONFIG_RT2800PCI is not set
CONFIG_RT2500USB=m
CONFIG_RT73USB=m
# CONFIG_RT2800USB is not set
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
CONFIG_RTL8192CE=m
CONFIG_RTL8192SE=m
CONFIG_RTL8192DE=m
CONFIG_RTL8192CU=m
CONFIG_RTLWIFI=m
CONFIG_RTL8192C_COMMON=m
# CONFIG_WL1251 is not set
# CONFIG_WL12XX_MENU is not set
CONFIG_ZD1211RW=m
# CONFIG_ZD1211RW_DEBUG is not set
CONFIG_MWIFIEX=m
CONFIG_MWIFIEX_SDIO=m
CONFIG_MWIFIEX_PCIE=m

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_SDIO=m
# CONFIG_WIMAX_IWMC3200_SDIO is not set
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_WAN=y
CONFIG_LANMEDIA=m
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
CONFIG_PCI200SYN=m
CONFIG_WANXL=m
CONFIG_PC300TOO=m
CONFIG_FARSYNC=m
CONFIG_DSCC4=m
CONFIG_DSCC4_PCISYNC=y
CONFIG_DSCC4_PCI_RST=y
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
# CONFIG_WAN_ROUTER_DRIVERS is not set
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_XEN_NETDEV_BACKEND is not set
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
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=m
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=m
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=m
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_JOYSTICK_XPAD_LEDS is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_HANWANG=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
CONFIG_TOUCHSCREEN_AD7877=m
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
CONFIG_TOUCHSCREEN_AD7879_SPI=m
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_EGALAX=m
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_MAX11801=m
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_WM97XX=m
CONFIG_TOUCHSCREEN_WM9705=y
CONFIG_TOUCHSCREEN_WM9712=y
CONFIG_TOUCHSCREEN_WM9713=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC_SERIO=m
CONFIG_TOUCHSCREEN_TSC2005=m
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_TPS6507X=m
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
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
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set

#
# KCopy
#
CONFIG_KCOPY=m
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX3107 is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
# CONFIG_IPWIRELESS is not set
CONFIG_MWAVE=m
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set
CONFIG_I2C_EG20T=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT=m
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
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_BITBANG=m
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=m

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
CONFIG_POWER_SUPPLY=y
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
CONFIG_SENSORS_AD7314=m
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
# CONFIG_SENSORS_LM73 is not set
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
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=m
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX6639=m
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_APPLESMC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=m
# CONFIG_SBC_FITPC2_WATCHDOG is not set
CONFIG_EUROTECH_WDT=m
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=m
CONFIG_PC87413_WDT=m
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=m
CONFIG_SBC8360_WDT=m
CONFIG_CPU5_WDT=m
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=m
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m
# CONFIG_XEN_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
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
CONFIG_MFD_SM501=m
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_S5M_CORE is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13XXX is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_LPC_SCH=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_WL1273_CORE=m
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_DVB_CORE=m
CONFIG_DVB_NET=y
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_RC_CORE=m
CONFIG_LIRC=m
CONFIG_RC_MAP=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_RC5_SZ_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_LIRC_CODEC=m
CONFIG_RC_ATI_REMOTE=m
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_RC_LOOPBACK is not set
# CONFIG_MEDIA_ATTACH is not set
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
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m

#
# Camera sensor devices
#
CONFIG_VIDEO_MT9V011=m

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_M52790=m
# CONFIG_VIDEO_VIVI is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
CONFIG_USB_GSPCA_KINECT=m
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TOPRO=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_EM28XX_RC=y
CONFIG_VIDEO_TLG2300=m
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
CONFIG_VIDEO_TM6000=m
CONFIG_VIDEO_TM6000_ALSA=m
CONFIG_VIDEO_TM6000_DVB=m
CONFIG_VIDEO_USBVISION=m
CONFIG_USB_ET61X251=m
CONFIG_USB_SN9C102=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_VIDEO_CPIA2=m
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
CONFIG_V4L_PCI_DRIVERS=y
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CX18_ALSA=m
CONFIG_VIDEO_CX23885=m
CONFIG_MEDIA_ALTERA_CI=m
CONFIG_VIDEO_CX25821=m
CONFIG_VIDEO_CX25821_ALSA=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
# CONFIG_VIDEO_CX88_VP3054 is not set
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_MEYE=m
CONFIG_VIDEO_MXB=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_SAA7164=m
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
CONFIG_VIDEO_ZORAN_LML33=m
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
# CONFIG_V4L_ISA_PARPORT_DRIVERS is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_SI470X=y
CONFIG_USB_SI470X=m
CONFIG_I2C_SI470X=m
CONFIG_USB_MR800=m
CONFIG_USB_DSBR=m
CONFIG_RADIO_MAXIRADIO=m
CONFIG_I2C_SI4713=m
CONFIG_RADIO_SI4713=m
CONFIG_RADIO_TEA5764=m
CONFIG_RADIO_SAA7706H=m
CONFIG_RADIO_TEF6862=m
CONFIG_RADIO_WL1273=m

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m

#
# Supported USB Adapters
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_PCTV452E=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_FRIIO=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_AZ6027=m
CONFIG_DVB_USB_LME2510=m
CONFIG_DVB_USB_TECHNISAT_USB2=m
CONFIG_DVB_USB_IT913X=m
CONFIG_DVB_USB_MXL111SF=m
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
# CONFIG_SMS_SIANO_MDTV is not set

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=m

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=m

#
# Supported SDMC DM1105 Adapters
#
CONFIG_DVB_DM1105=m

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y

#
# Supported Earthsoft PT1 Adapters
#
CONFIG_DVB_PT1=m

#
# Supported Mantis Adapters
#
CONFIG_MANTIS_CORE=m
CONFIG_DVB_MANTIS=m
CONFIG_DVB_HOPPER=m

#
# Supported nGene Adapters
#
CONFIG_DVB_NGENE=m

#
# Supported ddbridge ('Octopus') Adapters
#
# CONFIG_DVB_DDBRIDGE is not set

#
# Supported DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV6110x=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_IT913X_FE=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_KMS=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_GMA500 is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
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
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
CONFIG_FB_GEODE_GX=y
CONFIG_FB_GEODE_GX1=y
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_XEN_FBDEV_FRONTEND=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_PROGEAR=m
CONFIG_BACKLIGHT_APPLE=m
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FB_CON_DECOR=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_VIRMIDI is not set
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=1
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
# CONFIG_SND_ASIHPI is not set
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
# CONFIG_SND_OXYGEN is not set
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=m
CONFIG_SND_CS5535AUDIO=m
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
# CONFIG_SND_ES1968_INPUT is not set
# CONFIG_SND_ES1968_RADIO is not set
CONFIG_SND_FM801=m
# CONFIG_SND_FM801_TEA575X_BOOL is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_PREALLOC_SIZE=1024
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=2
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_ENABLE_REALTEK_QUIRKS=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=1
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LOLA=m
# CONFIG_SND_LX6464ES is not set
CONFIG_SND_MAESTRO3=m
# CONFIG_SND_MAESTRO3_INPUT is not set
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
CONFIG_SND_PCXHR=m
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
CONFIG_SND_SONICVIBES=m
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
# CONFIG_SND_VIRTUOSO is not set
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_USB_6FIRE=m
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
CONFIG_SND_FIREWIRE_SPEAKERS=m
CONFIG_SND_ISIGHT=m
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=m
CONFIG_SND_PDAUDIOCF=m
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
CONFIG_HID_HOLTEK=m
CONFIG_HOLTEK_FF=y
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_ROCCAT_COMMON=m
CONFIG_HID_ROCCAT_ARVO=m
CONFIG_HID_ROCCAT_ISKU=m
CONFIG_HID_ROCCAT_KONE=m
CONFIG_HID_ROCCAT_KONEPLUS=m
CONFIG_HID_ROCCAT_KOVAPLUS=m
CONFIG_HID_ROCCAT_PYRA=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TOPSEED=m
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=m
CONFIG_HID_WACOM_POWER_SUPPLY=y
CONFIG_HID_WIIMOTE=m
CONFIG_HID_WIIMOTE_EXT=y
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
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
CONFIG_USB_ISP116X_HCD=m
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=m
CONFIG_USB_R8A66597_HCD=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

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
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
# CONFIG_USB_UAS is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=m
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=m
CONFIG_USB_SERIAL_ZIO=m
CONFIG_USB_SERIAL_SSU100=m
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
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
# CONFIG_MMC_SDHCI_PLTFM is not set
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPATH=m
CONFIG_INFINIBAND_QIB=m
CONFIG_INFINIBAND_AMSO1100=m
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_CXGB3=m
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
# CONFIG_INFINIBAND_CXGB4 is not set
CONFIG_MLX4_INFINIBAND=m
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MCE_INJ is not set
# CONFIG_EDAC_MM_EDAC is not set
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
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
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
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
CONFIG_RTC_DRV_MAX6902=m
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RS5C348=m
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
CONFIG_TIMB_DMA=m
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=m
CONFIG_UIO_CIF=m
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_SELFBALLOONING is not set
# CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not set
CONFIG_XEN_SCRUB_PAGES=y
CONFIG_XEN_DEV_EVTCHN=y
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=y
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=m
CONFIG_XEN_GRANT_DEV_ALLOC=m
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=y
CONFIG_XEN_PCIDEV_BACKEND=m
CONFIG_XEN_PRIVCMD=y
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
CONFIG_USBIP_CORE=m
CONFIG_USBIP_VHCI_HCD=m
CONFIG_USBIP_HOST=m
# CONFIG_USBIP_DEBUG is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_COMEDI is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_PANEL is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_R8712U is not set
# CONFIG_RTS_PSTOR is not set
# CONFIG_RTS5139 is not set
# CONFIG_TRANZPORT is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_LINE6_USB is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_NOUVEAU_DEBUG=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_USB_SERIAL_QUATECH_USB2 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_VME_BUS is not set
# CONFIG_DX_SEP is not set
# CONFIG_IIO is not set
CONFIG_XVMALLOC=y
CONFIG_ZRAM=m
# CONFIG_ZRAM_DEBUG is not set
# CONFIG_ZCACHE is not set
# CONFIG_WLAGS49_H2 is not set
# CONFIG_WLAGS49_H25 is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_CXT1E1 is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_SBE_2T3E3 is not set
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
CONFIG_ACER_WMI=m
CONFIG_ACERHDF=m
CONFIG_ASUS_LAPTOP=m
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_AIO=m
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_FUJITSU_TABLET=m
CONFIG_AMILO_RFKILL=m
CONFIG_HP_ACCEL=m
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
CONFIG_INTEL_MENLOW=m
CONFIG_EEEPC_LAPTOP=m
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_WMI=m
CONFIG_ACPI_WMI=m
CONFIG_MSI_WMI=m
CONFIG_ACPI_ASUS=m
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=m
CONFIG_ACPI_CMPC=m
CONFIG_INTEL_IPS=m
# CONFIG_IBM_RTL is not set
CONFIG_XO15_EBOOK=m
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_INTEL_OAKTRAIL=m
CONFIG_SAMSUNG_Q10=m

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_STATS is not set
# CONFIG_AMD_IOMMU_V2 is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=m
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
# CONFIG_GFS2_FS_LOCKING_DLM is not set
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
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
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=m
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
# CONFIG_NFS_FSCACHE is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CIFS_ACL is not set
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=m
CONFIG_AFS_FS=m
# CONFIG_AFS_DEBUG is not set
# CONFIG_AFS_FSCACHE is not set
# CONFIG_9P_FS is not set
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
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=60
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
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
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
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
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
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
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
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
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
CONFIG_INTEL_TXT=y
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
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
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set

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
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
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
CONFIG_CRYPTO_DES=y
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
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m

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
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_VHOST_NET=m
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
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
CONFIG_LRU_CACHE=m
CONFIG_AVERAGE=y
CONFIG_CORDIC=m

--=-H5vF6Ax8eJozKS/jbq3T--

