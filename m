Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab0CRQGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:06:24 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:37981 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab0CRQGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:06:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=noz3yj7h4Yy97uacjp7MASVbGvhg69/xfmdVhKfeyKZ/9VcO51wtfLH/Ks8IidNStD
         7tFeVJB+idNqBKH1Lgz0rVu+tOP1+fBBeztUXXw3dOnrSrVGTfwIb1MXot/TvCf3q30c
         LfDGurFwlZt2q5ZZwr+lPJkZUAbMFD3OPdJy4=
MIME-Version: 1.0
Date: Thu, 18 Mar 2010 16:06:19 +0000
Message-ID: <d311c6a81003180906i1b28b5c6k1c20d8bbb4c2fc37@mail.gmail.com>
Subject: Memory Loss
From: Tomasz Grzegurzko <tomasz89@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a Dell PowerEdge 2900 reporting the loss of some memory at boot
time. It runs Ubuntu Karmic kernel 2.6.31-19-server (internal name).
The server is loaded with 42 GB of RAM but I get a little over 40GB,
and the following message from dmesg after bootup accounting for the
loss of RAM.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-19-server (buildd@crested) (gcc
version 4.4.1 (Ubuntu 4.4.1-4ubuntu8) ) #56-Ubuntu SMP Thu Jan 28
03:40:48 UTC 2010 (Ubuntu 2.6.31-19.56-server)
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.31-19-server
root=UUID=53c9e374-ff9a-4c43-96ef-d5e3039d0eba ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfb50000 (usable)
[    0.000000]  BIOS-e820: 00000000cfb50000 - 00000000cfb66000 (reserved)
[    0.000000]  BIOS-e820: 00000000cfb66000 - 00000000cfb85c00 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfb85c00 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fe000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000ab0000000 (usable)
[    0.000000] DMI 2.5 present.
[    0.000000] last_pfn = 0xab0000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-EBFFF uncachable
[    0.000000]   EC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 100000000 mask F00000000 write-back
[    0.000000]   2 base 200000000 mask E00000000 write-back
[    0.000000]   3 base 400000000 mask C00000000 write-back
[    0.000000]   4 base 800000000 mask C00000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 0000000080000000 - 0000000100000000
(usable) ==> (reserved)
[    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory,
losing 1275MB of RAM.
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at
/build/buildd/linux-2.6.31/arch/x86/kernel/cpu/mtrr/cleanup.c:1091
mtrr_trim_uncached_memory+0x2a6/0x2d1()
[    0.000000] Hardware name: PowerEdge 2900
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-19-server #56-Ubuntu
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8105e508>] warn_slowpath_common+0x78/0xb0
[    0.000000]  [<ffffffff8105e54f>] warn_slowpath_null+0xf/0x20
[    0.000000]  [<ffffffff8184150e>] mtrr_trim_uncached_memory+0x2a6/0x2d1
[    0.000000]  [<ffffffff8183ccfa>] setup_arch+0x3d0/0x647
[    0.000000]  [<ffffffff81524b0d>] ? printk+0x3c/0x3f
[    0.000000]  [<ffffffff81837db3>] start_kernel+0xbe/0x35b
[    0.000000]  [<ffffffff8183759a>] x86_64_start_reservations+0x125/0x129
[    0.000000]  [<ffffffff81837698>] x86_64_start_kernel+0xfa/0x109
[    0.000000] ---[ end trace a7919e7f17c0a725 ]---
[    0.000000] update e820 for mtrr
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  modified: 0000000000100000 - 0000000080000000 (usable)
[    0.000000]  modified: 0000000080000000 - 00000000cfb66000 (reserved)
[    0.000000]  modified: 00000000cfb66000 - 00000000cfb85c00 (ACPI data)
[    0.000000]  modified: 00000000cfb85c00 - 00000000d0000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fe000000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000ab0000000 (usable)
[    0.000000] last_pfn = 0xab0000 max_arch_pfn = 0x400000000
[    0.000000] last_pfn = 0x80000 max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000
(usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 00000000000a0000 (usable)
[    0.000000]  modified: 0000000000100000 - 0000000080000000 (usable)
[    0.000000]  modified: 0000000080000000 - 00000000cfb66000 (reserved)
[    0.000000]  modified: 00000000cfb66000 - 00000000cfb85c00 (ACPI data)
[    0.000000]  modified: 00000000cfb85c00 - 00000000d0000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fe000000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000ab0000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-0000000080000000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0000000000 - 0080000000 page 2M
[    0.000000] kernel direct mapping tables up to 80000000 @ 8000-b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000ab0000000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0100000000 - 0ab0000000 page 2M
[    0.000000] kernel direct mapping tables up to ab0000000 @ 9000-35000
[    0.000000] RAMDISK: 37917000 - 37fef3ac
[    0.000000] ACPI: RSDP 00000000000f2160 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000000f21fc 00084 (v01 DELL   PE_SC3
00000001 DELL 00000001)
[    0.000000] ACPI: FACP 00000000cfb83524 000F4 (v03 DELL   PE_SC3
00000001 DELL 00000001)
[    0.000000] ACPI: DSDT 00000000cfb66000 04996 (v01 DELL   PE_SC3
00000001 INTL 20050624)
[    0.000000] ACPI: FACS 00000000cfb85c00 00040
[    0.000000] ACPI: APIC 00000000cfb83078 000AA (v01 DELL   PE_SC3
00000001 DELL 00000001)
[    0.000000] ACPI: SPCR 00000000cfb83130 00050 (v01 DELL   PE_SC3
00000001 DELL 00000001)
[    0.000000] ACPI: HPET 00000000cfb83184 00038 (v01 DELL   PE_SC3
00000001 DELL 00000001)
[    0.000000] ACPI: MCFG 00000000cfb831c0 0003C (v01 DELL   PE_SC3
00000001 DELL 00000001)
[    0.000000] ACPI: WD__ 00000000cfb83200 00134 (v01 DELL   PE_SC3
00000001 DELL 00000001)
[    0.000000] ACPI: SLIC 00000000cfb83338 00176 (v01 DELL   PE_SC3
00000001 DELL 00000001)
[    0.000000] ACPI: ERST 00000000cfb6ab18 00210 (v01 DELL   PE_SC3
00000001 DELL 00000001)
[    0.000000] ACPI: HEST 00000000cfb6ad28 0027C (v01 DELL   PE_SC3
00000001 DELL 00000001)
[    0.000000] ACPI: BERT 00000000cfb6a998 00030 (v01 DELL   PE_SC3
00000001 DELL 00000001)
[    0.000000] ACPI: EINJ 00000000cfb6a9c8 00150 (v01 DELL   PE_SC3
00000001 DELL 00000001)
[    0.000000] ACPI: TCPA 00000000cfb834bc 00064 (v02 DELL   PE_SC3
00000001 DELL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000ab0000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000ab0000000
[    0.000000]   NODE_DATA [0000000000030000 - 0000000000034fff]
[    0.000000]   bootmap [0000000000100000 -  0000000000255fff] pages 156
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0ab0000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>
[0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 00019e1ccc]    TEXT DATA BSS ==>
[0001000000 - 00019e1ccc]
[    0.000000]   #3 [0037917000 - 0037fef3ac]          RAMDISK ==>
[0037917000 - 0037fef3ac]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==>
[000009ec00 - 0000100000]
[    0.000000]   #5 [00019e2000 - 00019e22d9]              BRK ==>
[00019e2000 - 00019e22d9]
[    0.000000]   #6 [0000008000 - 0000009000]          PGTABLE ==>
[0000008000 - 0000009000]
[    0.000000]   #7 [0000009000 - 0000030000]          PGTABLE ==>
[0000009000 - 0000030000]
[    0.000000] found SMP MP-table at [ffff8800000fe710] fe710
[    0.000000]  [ffffea0000000000-ffffea0010dfffff] PMD ->
[ffff880028600000-ffff8800377fffff] on node 0
[    0.000000]  [ffffea0010e00000-ffffea00257fffff] PMD ->
[ffff880038000000-ffff88004c9fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00ab0000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x00080000
[    0.000000]     0: 0x00100000 -> 0x00ab0000
[    0.000000] On node 0 totalpages: 10682267
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 140 pages reserved
[    0.000000]   DMA zone: 3799 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 505912 pages, LIFO batch:31
[    0.000000]   Normal zone: 138880 pages used for memmap
[    0.000000]   Normal zone: 10019200 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[32])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 32-55
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec83000] gsi_base[128])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec83000,
GSI 128-151
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 152
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000080000000 - 00000000cfb66000
[    0.000000] PM: Registered nosave memory: 00000000cfb66000 - 00000000cfb85000
[    0.000000] PM: Registered nosave memory: 00000000cfb85000 - 00000000cfb86000
[    0.000000] PM: Registered nosave memory: 00000000cfb86000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fe000000
[    0.000000] PM: Registered nosave memory: 00000000fe000000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap:
d0000000:10000000)
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages at ffff880028036000, static
data 90720 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 10528911
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:
BOOT_IMAGE=/vmlinuz-2.6.31-19-server
root=UUID=53c9e374-ff9a-4c43-96ef-d5e3039d0eba ro
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 -
ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 42058792k/44826624k available (5305k kernel
code, 2097556k absent, 670276k reserved, 3012k data, 660k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0,
CPUs=8, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:2048
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2327.614 MHz processor.
[    0.002088] Console: colour VGA+ 80x25
[    0.002091] console [tty0] enabled
[    0.010000] allocated 427294720 bytes of page_cgroup
[    0.010000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.010000] hpet clockevent registered
[    0.010000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.010000] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4655.22 BogoMIPS (lpj=23276140)
[    0.010000] Security Framework initialized
[    0.010000] AppArmor: AppArmor initialized
[    0.010000] Dentry cache hash table entries: 8388608 (order: 14,
67108864 bytes)
[    0.042585] Inode-cache hash table entries: 4194304 (order: 13,
33554432 bytes)
[    0.061021] Mount-cache hash table entries: 256
[    0.061249] Initializing cgroup subsys ns
[    0.061307] Initializing cgroup subsys cpuacct
[    0.061364] Initializing cgroup subsys memory
[    0.061425] Initializing cgroup subsys freezer
[    0.061480] Initializing cgroup subsys net_cls
[    0.061548] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.061636] CPU: L2 cache: 4096K
[    0.061690] CPU 0/0x0 -> Node 0
[    0.061744] CPU: Physical Processor ID: 0
[    0.061797] CPU: Processor Core ID: 0
[    0.061852] mce: CPU supports 6 MCE banks
[    0.061912] CPU0: Thermal monitoring enabled (TM1)
[    0.061969] using mwait in idle threads.
[    0.062023] Performance Counters: Core2 events, Intel PMU driver.
[    0.062150] ... version:                 2
[    0.062204] ... bit width:               40
[    0.062258] ... generic counters:        2
[    0.062312] ... value mask:              000000ffffffffff
[    0.062369] ... max period:              000000007fffffff
[    0.062425] ... fixed-purpose counters:  3
[    0.062479] ... counter mask:            0000000700000003
[    0.064919] ACPI: Core revision 20090521
[    0.080067] Setting APIC routing to flat
[    0.080549] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.181643] CPU0: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 07
[    0.190000] Booting processor 1 APIC 0x4 ip 0x6000
[    0.010000] Initializing CPU#1
[    0.010000] Calibrating delay using timer specific routine..
4655.14 BogoMIPS (lpj=23275702)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 1/0x4 -> Node 0
[    0.010000] CPU: Physical Processor ID: 1
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] mce: CPU supports 6 MCE banks
[    0.010000] CPU1: Thermal monitoring enabled (TM2)
[    0.010000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.341802] CPU1: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 0b
[    0.342479] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.350092] Booting processor 2 APIC 0x2 ip 0x6000
[    0.010000] Initializing CPU#2
[    0.010000] Calibrating delay using timer specific routine..
4655.12 BogoMIPS (lpj=23275641)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 2/0x2 -> Node 0
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 2
[    0.010000] mce: CPU supports 6 MCE banks
[    0.010000] CPU2: Thermal monitoring enabled (TM2)
[    0.010000] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.511776] CPU2: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 07
[    0.512453] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.520103] Booting processor 3 APIC 0x6 ip 0x6000
[    0.010000] Initializing CPU#3
[    0.010000] Calibrating delay using timer specific routine..
4655.13 BogoMIPS (lpj=23275697)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 3/0x6 -> Node 0
[    0.010000] CPU: Physical Processor ID: 1
[    0.010000] CPU: Processor Core ID: 2
[    0.010000] mce: CPU supports 6 MCE banks
[    0.010000] CPU3: Thermal monitoring enabled (TM2)
[    0.010000] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.681761] CPU3: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 0b
[    0.682436] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.690097] Booting processor 4 APIC 0x1 ip 0x6000
[    0.010000] Initializing CPU#4
[    0.010000] Calibrating delay using timer specific routine..
4655.12 BogoMIPS (lpj=23275618)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 4/0x1 -> Node 0
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] mce: CPU supports 6 MCE banks
[    0.010000] CPU4: Thermal monitoring enabled (TM2)
[    0.010000] x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
[    0.851740] CPU4: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 07
[    0.852417] checking TSC synchronization [CPU#0 -> CPU#4]: passed.
[    0.860145] Booting processor 5 APIC 0x5 ip 0x6000
[    0.010000] Initializing CPU#5
[    0.010000] Calibrating delay using timer specific routine..
4655.12 BogoMIPS (lpj=23275618)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 5/0x5 -> Node 0
[    0.010000] CPU: Physical Processor ID: 1
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] mce: CPU supports 6 MCE banks
[    0.010000] CPU5: Thermal monitoring enabled (TM2)
[    0.010000] x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
[    1.021770] CPU5: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 0b
[    1.022446] checking TSC synchronization [CPU#0 -> CPU#5]: passed.
[    1.030085] Booting processor 6 APIC 0x3 ip 0x6000
[    0.010000] Initializing CPU#6
[    0.010000] Calibrating delay using timer specific routine..
4655.12 BogoMIPS (lpj=23275614)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 6/0x3 -> Node 0
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 3
[    0.010000] mce: CPU supports 6 MCE banks
[    0.010000] CPU6: Thermal monitoring enabled (TM2)
[    0.010000] x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
[    1.191735] CPU6: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 07
[    1.192410] checking TSC synchronization [CPU#0 -> CPU#6]: passed.
[    1.200097] Booting processor 7 APIC 0x7 ip 0x6000
[    0.010000] Initializing CPU#7
[    0.010000] Calibrating delay using timer specific routine..
4655.13 BogoMIPS (lpj=23275659)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU 7/0x7 -> Node 0
[    0.010000] CPU: Physical Processor ID: 1
[    0.010000] CPU: Processor Core ID: 3
[    0.010000] mce: CPU supports 6 MCE banks
[    0.010000] CPU7: Thermal monitoring enabled (TM2)
[    0.010000] x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
[    1.361712] CPU7: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 0b
[    1.362388] checking TSC synchronization [CPU#0 -> CPU#7]: passed.
[    1.370020] Brought up 8 CPUs
[    1.370073] Total of 8 processors activated (37241.13 BogoMIPS).
[    1.370196] CPU0 attaching sched-domain:
[    1.370199]  domain 0: span 0,4 level MC
[    1.370201]   groups: 0 4
[    1.370205]   domain 1: span 0-7 level CPU
[    1.370207]    groups: 0,4 1,5 2,6 3,7
[    1.370214] CPU1 attaching sched-domain:
[    1.370216]  domain 0: span 1,5 level MC
[    1.370217]   groups: 1 5
[    1.370221]   domain 1: span 0-7 level CPU
[    1.370223]    groups: 1,5 2,6 3,7 0,4
[    1.370228] CPU2 attaching sched-domain:
[    1.370230]  domain 0: span 2,6 level MC
[    1.370232]   groups: 2 6
[    1.370235]   domain 1: span 0-7 level CPU
[    1.370237]    groups: 2,6 3,7 0,4 1,5
[    1.370242] CPU3 attaching sched-domain:
[    1.370244]  domain 0: span 3,7 level MC
[    1.370246]   groups: 3 7
[    1.370249]   domain 1: span 0-7 level CPU
[    1.370251]    groups: 3,7 0,4 1,5 2,6
[    1.370256] CPU4 attaching sched-domain:
[    1.370258]  domain 0: span 0,4 level MC
[    1.370260]   groups: 4 0
[    1.370263]   domain 1: span 0-7 level CPU
[    1.370265]    groups: 0,4 1,5 2,6 3,7
[    1.370270] CPU5 attaching sched-domain:
[    1.370272]  domain 0: span 1,5 level MC
[    1.370274]   groups: 5 1
[    1.370277]   domain 1: span 0-7 level CPU
[    1.370278]    groups: 1,5 2,6 3,7 0,4
[    1.370284] CPU6 attaching sched-domain:
[    1.370286]  domain 0: span 2,6 level MC
[    1.370288]   groups: 6 2
[    1.370291]   domain 1: span 0-7 level CPU
[    1.370293]    groups: 2,6 3,7 0,4 1,5
[    1.370298] CPU7 attaching sched-domain:
[    1.370300]  domain 0: span 3,7 level MC
[    1.370302]   groups: 7 3
[    1.370305]   domain 1: span 0-7 level CPU
[    1.370307]    groups: 3,7 0,4 1,5 2,6
[    1.370499] Booting paravirtualized kernel on bare hardware
[    1.370499] regulator: core version 0.5
[    1.370499] Time: 13:30:07  Date: 03/18/10
[    1.370499] NET: Registered protocol family 16
[    1.370499] ACPI FADT declares the system doesn't support PCIe
ASPM, so disable it
[    1.370499] ACPI: bus type pci registered
[    1.370609] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    1.370669] PCI: MCFG area at e0000000 reserved in E820
[    1.380488] PCI: Using MMCONFIG at e0000000 - efffffff
[    1.380545] PCI: Using configuration type 1 for base access
[    1.380603] PCI: Dell PowerEdge 2900 detected, enabling pci=bfsort.
[    1.381472] bio: create slab <bio-0> at 0
[    1.381472] ACPI: EC: Look up EC in DSDT
[    1.383951] ACPI: BIOS _OSI(Linux) query ignored
[    1.384422] ACPI: Interpreter enabled
[    1.384477] ACPI: (supports S0 S4 S5)
[    1.384638] ACPI: Using IOAPIC for interrupt routing
[    1.392669] ACPI: No dock devices found.
[    1.393121] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.393248] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.393307] pci 0000:00:00.0: PME# disabled
[    1.393402] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    1.393462] pci 0000:00:02.0: PME# disabled
[    1.393573] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.393632] pci 0000:00:03.0: PME# disabled
[    1.393724] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    1.393783] pci 0000:00:04.0: PME# disabled
[    1.393875] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    1.393934] pci 0000:00:05.0: PME# disabled
[    1.394026] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    1.394085] pci 0000:00:06.0: PME# disabled
[    1.394176] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.394235] pci 0000:00:07.0: PME# disabled
[    1.394312] pci 0000:00:08.0: reg 10 64bit mmio: [0xfc900400-0xfc9007ff]
[    1.394336] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    1.394394] pci 0000:00:08.0: PME# disabled
[    1.394677] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.394755] pci 0000:00:1c.0: PME# disabled
[    1.394856] pci 0000:00:1d.0: reg 20 io port: [0xbce0-0xbcff]
[    1.394900] pci 0000:00:1d.1: reg 20 io port: [0xbcc0-0xbcdf]
[    1.394945] pci 0000:00:1d.2: reg 20 io port: [0xbca0-0xbcbf]
[    1.394990] pci 0000:00:1d.3: reg 20 io port: [0xbc80-0xbc9f]
[    1.395040] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfc900000-0xfc9003ff]
[    1.395087] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.395147] pci 0000:00:1d.7: PME# disabled
[    1.395316] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    1.395322] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    1.395328] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    1.395334] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    1.395340] pci 0000:00:1f.1: reg 20 io port: [0xfc00-0xfc0f]
[    1.397202] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    1.397340] pci 0000:05:00.0: PME# disabled
[    1.399218] pci 0000:05:00.3: PME# supported from D0 D3hot D3cold
[    1.399355] pci 0000:05:00.3: PME# disabled
[    1.400022] pci 0000:00:02.0: bridge 32bit mmio: [0xf2000000-0xf7ffffff]
[    1.402185] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    1.402322] pci 0000:06:00.0: PME# disabled
[    1.404934] pci 0000:06:01.0: PME# supported from D0 D3hot D3cold
[    1.405071] pci 0000:06:01.0: PME# disabled
[    1.407133] pci 0000:05:00.0: bridge 32bit mmio: [0xf4000000-0xf7ffffff]
[    1.409287] pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
[    1.409424] pci 0000:07:00.0: PME# disabled
[    1.411648] pci 0000:06:00.0: bridge 32bit mmio: [0xf4000000-0xf7ffffff]
[    1.413664] pci 0000:08:00.0: reg 10 64bit mmio: [0xf4000000-0xf5ffffff]
[    1.415543] pci 0000:08:00.0: PME# supported from D3hot D3cold
[    1.415680] pci 0000:08:00.0: PME# disabled
[    1.417742] pci 0000:07:00.0: bridge 32bit mmio: [0xf4000000-0xf7ffffff]
[    1.423047] pci 0000:0c:00.0: reg 10 32bit mmio: [0xfc3e0000-0xfc3fffff]
[    1.423053] pci 0000:0c:00.0: reg 14 32bit mmio: [0xfc3c0000-0xfc3dffff]
[    1.423059] pci 0000:0c:00.0: reg 18 io port: [0xdce0-0xdcff]
[    1.423100] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    1.423160] pci 0000:0c:00.0: PME# disabled
[    1.424833] pci 0000:0c:00.1: reg 10 32bit mmio: [0xfc3a0000-0xfc3bffff]
[    1.424839] pci 0000:0c:00.1: reg 14 32bit mmio: [0xfc380000-0xfc39ffff]
[    1.424845] pci 0000:0c:00.1: reg 18 io port: [0xdcc0-0xdcdf]
[    1.424885] pci 0000:0c:00.1: PME# supported from D0 D3hot D3cold
[    1.424965] pci 0000:0c:00.1: PME# disabled
[    1.425066] pci 0000:00:04.0: bridge io port: [0xd000-0xdfff]
[    1.425069] pci 0000:00:04.0: bridge 32bit mmio: [0xfc300000-0xfc4fffff]
[    1.425101] pci 0000:01:00.0: PXH quirk detected; SHPC device MSI disabled
[    1.425187] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    1.425247] pci 0000:01:00.0: PME# disabled
[    1.425348] pci 0000:00:05.0: bridge io port: [0xe000-0xefff]
[    1.425351] pci 0000:00:05.0: bridge 32bit mmio: [0xfc500000-0xfc8fffff]
[    1.425404] pci 0000:02:08.0: reg 10 io port: [0xec00-0xecff]
[    1.425413] pci 0000:02:08.0: reg 14 64bit mmio: [0xfc7fc000-0xfc7fffff]
[    1.425423] pci 0000:02:08.0: reg 1c 64bit mmio: [0xfc7e0000-0xfc7effff]
[    1.425432] pci 0000:02:08.0: reg 30 32bit mmio: [0xfc800000-0xfc8fffff]
[    1.425456] pci 0000:02:08.0: supports D1 D2
[    1.425493] pci 0000:01:00.0: bridge io port: [0xe000-0xefff]
[    1.425496] pci 0000:01:00.0: bridge 32bit mmio: [0xfc600000-0xfc8fffff]
[    1.425643] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.425704] pci 0000:03:00.0: PME# disabled
[    1.425807] pci 0000:00:1c.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
[    1.425869] pci 0000:04:00.0: reg 10 64bit mmio: [0xf8000000-0xf9ffffff]
[    1.425926] pci 0000:04:00.0: PME# supported from D3hot D3cold
[    1.425985] pci 0000:04:00.0: PME# disabled
[    1.426101] pci 0000:03:00.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
[    1.426168] pci 0000:0f:0d.0: reg 10 32bit mmio: [0xd8000000-0xdfffffff]
[    1.426175] pci 0000:0f:0d.0: reg 14 io port: [0xcc00-0xccff]
[    1.426181] pci 0000:0f:0d.0: reg 18 32bit mmio: [0xfc2d0000-0xfc2dffff]
[    1.426202] pci 0000:0f:0d.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    1.426221] pci 0000:0f:0d.0: supports D1 D2
[    1.426250] pci 0000:00:1e.0: transparent bridge
[    1.426307] pci 0000:00:1e.0: bridge io port: [0xc000-0xcfff]
[    1.426311] pci 0000:00:1e.0: bridge 32bit mmio: [0xfc100000-0xfc2fffff]
[    1.426316] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xd8000000-0xdfffffff]
[    1.426343] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.426358] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    1.426358] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2.UPST._PRT]
[    1.426358] ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.PEX2.UPST.DWN1._PRT]
[    1.426358] ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.PEX2.UPST.DWN2._PRT]
[    1.426358] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2.PE2X._PRT]
[    1.426358] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    1.426358] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    1.426358] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
[    1.426358] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5.PE2P._PRT]
[    1.426358] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX6._PRT]
[    1.426358] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SBEX._PRT]
[    1.426358] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.COMP._PRT]
[    1.426358] ACPI: PCI Interrupt Link [LK00] (IRQs 3 4 5 6 7 10 *11 12)
[    1.426358] ACPI: PCI Interrupt Link [LK01] (IRQs 3 4 *5 6 7 10 11 12)
[    1.426358] ACPI: PCI Interrupt Link [LK02] (IRQs 3 4 5 6 7 10 *11 12)
[    1.426358] ACPI: PCI Interrupt Link [LK03] (IRQs 3 4 5 6 7 *10 11 12)
[    1.426459] ACPI: PCI Interrupt Link [LK04] (IRQs 3 4 5 *6 7 10 11 12)
[    1.426956] ACPI: PCI Interrupt Link [LK05] (IRQs 3 4 5 6 7 *10 11 12)
[    1.427438] ACPI: PCI Interrupt Link [LK06] (IRQs 3 4 5 6 7 10 11
12) *0, disabled.
[    1.430425] ACPI: PCI Interrupt Link [LK07] (IRQs 3 4 5 6 7 10 11
12) *0, disabled.
[    1.431080] SCSI subsystem initialized
[    1.431156] libata version 3.00 loaded.
[    1.431156] usbcore: registered new interface driver usbfs
[    1.431156] usbcore: registered new interface driver hub
[    1.431156] usbcore: registered new device driver usb
[    1.431156] ACPI: WMI: Mapper loaded
[    1.431156] PCI: Using ACPI for IRQ routing
[    1.460007] Bluetooth: Core ver 2.15
[    1.460068] NET: Registered protocol family 31
[    1.460080] Bluetooth: HCI device and connection manager initialized
[    1.460140] Bluetooth: HCI socket layer initialized
[    1.460196] NetLabel: Initializing
[    1.460248] NetLabel:  domain hash size = 128
[    1.460302] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.460369] NetLabel:  unlabeled traffic allowed by default
[    1.460500] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.460701] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    1.510008] Switched to high resolution mode on CPU 0
[    1.512411] Switched to high resolution mode on CPU 7
[    1.512560] Switched to high resolution mode on CPU 4
[    1.513017] Switched to high resolution mode on CPU 3
[    1.513102] Switched to high resolution mode on CPU 5
[    1.513685] Switched to high resolution mode on CPU 1
[    1.513833] Switched to high resolution mode on CPU 6
[    1.514998] Switched to high resolution mode on CPU 2
[    1.530645] pnp: PnP ACPI init
[    1.530709] ACPI: bus type pnp registered
[    1.536672] pnp: PnP ACPI: found 12 devices
[    1.536727] ACPI: ACPI bus type pnp unregistered
[    1.536799] system 00:08: ioport range 0x800-0x87f has been reserved
[    1.536859] system 00:08: ioport range 0x880-0x8bf has been reserved
[    1.536918] system 00:08: ioport range 0x8c0-0x8df has been reserved
[    1.536976] system 00:08: ioport range 0x8e0-0x8e3 has been reserved
[    1.537035] system 00:08: ioport range 0x900-0x900 has been reserved
[    1.537094] system 00:08: ioport range 0xc00-0xc7f has been reserved
[    1.537153] system 00:08: ioport range 0xca0-0xca7 has been reserved
[    1.537212] system 00:08: ioport range 0xca9-0xcab has been reserved
[    1.537271] system 00:08: ioport range 0xcad-0xcaf has been reserved
[    1.537332] system 00:09: ioport range 0xca8-0xca8 has been reserved
[    1.537391] system 00:09: ioport range 0xcac-0xcac has been reserved
[    1.537452] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    1.542177] AppArmor: AppArmor Filesystem Enabled
[    1.543542] pci 0000:07:00.0: PCI bridge, secondary bus 0000:08
[    1.543600] pci 0000:07:00.0:   IO window: disabled
[    1.543766] pci 0000:07:00.0:   MEM window: 0xf4000000-0xf7ffffff
[    1.543904] pci 0000:07:00.0:   PREFETCH window: disabled
[    1.544041] pci 0000:06:00.0: PCI bridge, secondary bus 0000:07
[    1.544099] pci 0000:06:00.0:   IO window: disabled
[    1.544270] pci 0000:06:00.0:   MEM window: 0xf4000000-0xf7ffffff
[    1.544407] pci 0000:06:00.0:   PREFETCH window: disabled
[    1.544545] pci 0000:06:01.0: PCI bridge, secondary bus 0000:09
[    1.544602] pci 0000:06:01.0:   IO window: disabled
[    1.544774] pci 0000:06:01.0:   MEM window: disabled
[    1.544911] pci 0000:06:01.0:   PREFETCH window: disabled
[    1.545049] pci 0000:05:00.0: PCI bridge, secondary bus 0000:06
[    1.545106] pci 0000:05:00.0:   IO window: disabled
[    1.545278] pci 0000:05:00.0:   MEM window: 0xf4000000-0xf7ffffff
[    1.545415] pci 0000:05:00.0:   PREFETCH window: disabled
[    1.545553] pci 0000:05:00.3: PCI bridge, secondary bus 0000:0a
[    1.545610] pci 0000:05:00.3:   IO window: disabled
[    1.545782] pci 0000:05:00.3:   MEM window: disabled
[    1.545919] pci 0000:05:00.3:   PREFETCH window: disabled
[    1.546057] pci 0000:00:02.0: PCI bridge, secondary bus 0000:05
[    1.546114] pci 0000:00:02.0:   IO window: disabled
[    1.546171] pci 0000:00:02.0:   MEM window: 0xf2000000-0xf7ffffff
[    1.546230] pci 0000:00:02.0:   PREFETCH window: disabled
[    1.546287] pci 0000:00:03.0: PCI bridge, secondary bus 0000:0b
[    1.546345] pci 0000:00:03.0:   IO window: disabled
[    1.546402] pci 0000:00:03.0:   MEM window: disabled
[    1.546458] pci 0000:00:03.0:   PREFETCH window: disabled
[    1.546516] pci 0000:00:04.0: PCI bridge, secondary bus 0000:0c
[    1.546574] pci 0000:00:04.0:   IO window: 0xd000-0xdfff
[    1.546632] pci 0000:00:04.0:   MEM window: 0xfc300000-0xfc4fffff
[    1.546691] pci 0000:00:04.0:   PREFETCH window: disabled
[    1.546749] pci 0000:01:00.0: PCI bridge, secondary bus 0000:02
[    1.546807] pci 0000:01:00.0:   IO window: 0xe000-0xefff
[    1.546866] pci 0000:01:00.0:   MEM window: 0xfc600000-0xfc8fffff
[    1.546925] pci 0000:01:00.0:   PREFETCH window: disabled
[    1.546983] pci 0000:00:05.0: PCI bridge, secondary bus 0000:01
[    1.547042] pci 0000:00:05.0:   IO window: 0xe000-0xefff
[    1.547100] pci 0000:00:05.0:   MEM window: 0xfc500000-0xfc8fffff
[    1.547158] pci 0000:00:05.0:   PREFETCH window: disabled
[    1.547216] pci 0000:00:06.0: PCI bridge, secondary bus 0000:0d
[    1.547273] pci 0000:00:06.0:   IO window: disabled
[    1.547330] pci 0000:00:06.0:   MEM window: disabled
[    1.547387] pci 0000:00:06.0:   PREFETCH window: disabled
[    1.547445] pci 0000:00:07.0: PCI bridge, secondary bus 0000:0e
[    1.547502] pci 0000:00:07.0:   IO window: disabled
[    1.547559] pci 0000:00:07.0:   MEM window: disabled
[    1.547615] pci 0000:00:07.0:   PREFETCH window: disabled
[    1.547673] pci 0000:03:00.0: PCI bridge, secondary bus 0000:04
[    1.547730] pci 0000:03:00.0:   IO window: disabled
[    1.547790] pci 0000:03:00.0:   MEM window: 0xf8000000-0xfbffffff
[    1.547851] pci 0000:03:00.0:   PREFETCH window: disabled
[    1.547910] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:03
[    1.547967] pci 0000:00:1c.0:   IO window: disabled
[    1.548025] pci 0000:00:1c.0:   MEM window: 0xf8000000-0xfbffffff
[    1.548084] pci 0000:00:1c.0:   PREFETCH window: disabled
[    1.548145] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0f
[    1.548203] pci 0000:00:1e.0:   IO window: 0xc000-0xcfff
[    1.548262] pci 0000:00:1e.0:   MEM window: 0xfc100000-0xfc2fffff
[    1.548322] pci 0000:00:1e.0:   PREFETCH window:
0x000000d8000000-0x000000dfffffff
[    1.548406]   alloc irq_desc for 17 on node 0
[    1.548408]   alloc kstat_irqs on node 0
[    1.548414] pci 0000:00:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.548475] pci 0000:00:02.0: setting latency timer to 64
[    1.548571] pci 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.548708] pci 0000:05:00.0: setting latency timer to 64
[    1.548892] pci 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.549028] pci 0000:06:00.0: setting latency timer to 64
[    1.549303] pci 0000:07:00.0: setting latency timer to 64
[    1.549487] pci 0000:06:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.549624] pci 0000:06:01.0: setting latency timer to 64
[    1.549854] pci 0000:05:00.3: setting latency timer to 64
[    1.549901]   alloc irq_desc for 19 on node 0
[    1.549903]   alloc kstat_irqs on node 0
[    1.549906] pci 0000:00:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.549966] pci 0000:00:03.0: setting latency timer to 64
[    1.549970]   alloc irq_desc for 18 on node 0
[    1.549972]   alloc kstat_irqs on node 0
[    1.549975] pci 0000:00:04.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.550035] pci 0000:00:04.0: setting latency timer to 64
[    1.550039]   alloc irq_desc for 16 on node 0
[    1.550041]   alloc kstat_irqs on node 0
[    1.550044] pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.550104] pci 0000:00:05.0: setting latency timer to 64
[    1.550111] pci 0000:01:00.0: setting latency timer to 64
[    1.550121] pci 0000:00:06.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.550181] pci 0000:00:06.0: setting latency timer to 64
[    1.550187] pci 0000:00:07.0: setting latency timer to 64
[    1.550193] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.550253] pci 0000:00:1c.0: setting latency timer to 64
[    1.550262] pci 0000:03:00.0: setting latency timer to 64
[    1.550268] pci 0000:00:1e.0: setting latency timer to 64
[    1.550272] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    1.550275] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    1.550277] pci_bus 0000:05: resource 1 mem: [0xf2000000-0xf7ffffff]
[    1.550279] pci_bus 0000:06: resource 1 mem: [0xf4000000-0xf7ffffff]
[    1.550282] pci_bus 0000:07: resource 1 mem: [0xf4000000-0xf7ffffff]
[    1.550284] pci_bus 0000:08: resource 1 mem: [0xf4000000-0xf7ffffff]
[    1.550286] pci_bus 0000:0c: resource 0 io:  [0xd000-0xdfff]
[    1.550288] pci_bus 0000:0c: resource 1 mem: [0xfc300000-0xfc4fffff]
[    1.550290] pci_bus 0000:01: resource 0 io:  [0xe000-0xefff]
[    1.550292] pci_bus 0000:01: resource 1 mem: [0xfc500000-0xfc8fffff]
[    1.550294] pci_bus 0000:02: resource 0 io:  [0xe000-0xefff]
[    1.550296] pci_bus 0000:02: resource 1 mem: [0xfc600000-0xfc8fffff]
[    1.550298] pci_bus 0000:03: resource 1 mem: [0xf8000000-0xfbffffff]
[    1.550300] pci_bus 0000:04: resource 1 mem: [0xf8000000-0xfbffffff]
[    1.550303] pci_bus 0000:0f: resource 0 io:  [0xc000-0xcfff]
[    1.550305] pci_bus 0000:0f: resource 1 mem: [0xfc100000-0xfc2fffff]
[    1.550307] pci_bus 0000:0f: resource 2 pref mem [0xd8000000-0xdfffffff]
[    1.550309] pci_bus 0000:0f: resource 3 io:  [0x00-0xffff]
[    1.550310] pci_bus 0000:0f: resource 4 mem: [0x000000-0xffffffffffffffff]
[    1.550346] NET: Registered protocol family 2
[    1.550841] IP route cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    1.553143] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    1.557434] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.558022] TCP: Hash tables configured (established 524288 bind 65536)
[    1.558081] TCP reno registered
[    1.558285] NET: Registered protocol family 1
[    1.558403] Trying to unpack rootfs image as initramfs...
[    1.701496] Freeing initrd memory: 7008k freed
[    1.705391] Scanning for low memory corruption every 60 seconds
[    1.705599] audit: initializing netlink socket (disabled)
[    1.705669] type=2000 audit(1268919006.700:1): initialized
[    1.717072] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.718677] VFS: Disk quotas dquot_6.5.2
[    1.718788] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.719414] fuse init (API version 7.12)
[    1.719599] msgmni has been set to 32768
[    1.720215] alg: No test for stdrng (krng)
[    1.720291] io scheduler noop registered
[    1.720362] io scheduler anticipatory registered
[    1.720418] io scheduler deadline registered (default)
[    1.720506] io scheduler cfq registered
[    1.720664] PCI quirk: reroute interrupts for 0x8086:0x2670
[    1.720730] PCI quirk: reroute interrupts for 0x8086:0x032c
[    1.720803] pci 0000:0f:0d.0: Boot video device
[    1.720985]   alloc irq_desc for 152 on node 0
[    1.720988]   alloc kstat_irqs on node 0
[    1.720998] pcieport-driver 0000:00:02.0: irq 152 for MSI/MSI-X
[    1.721005] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    1.721215]   alloc irq_desc for 153 on node 0
[    1.721222]   alloc kstat_irqs on node 0
[    1.721228] pcieport-driver 0000:00:03.0: irq 153 for MSI/MSI-X
[    1.721235] pcieport-driver 0000:00:03.0: setting latency timer to 64
[    1.721392]   alloc irq_desc for 154 on node 0
[    1.721394]   alloc kstat_irqs on node 0
[    1.721400] pcieport-driver 0000:00:04.0: irq 154 for MSI/MSI-X
[    1.721406] pcieport-driver 0000:00:04.0: setting latency timer to 64
[    1.721565]   alloc irq_desc for 155 on node 0
[    1.721568]   alloc kstat_irqs on node 0
[    1.721574] pcieport-driver 0000:00:05.0: irq 155 for MSI/MSI-X
[    1.721580] pcieport-driver 0000:00:05.0: setting latency timer to 64
[    1.721716]   alloc irq_desc for 156 on node 0
[    1.721739]   alloc kstat_irqs on node 0
[    1.721745] pcieport-driver 0000:00:06.0: irq 156 for MSI/MSI-X
[    1.721760] pcieport-driver 0000:00:06.0: setting latency timer to 64
[    1.721897]   alloc irq_desc for 157 on node 0
[    1.721899]   alloc kstat_irqs on node 0
[    1.721905] pcieport-driver 0000:00:07.0: irq 157 for MSI/MSI-X
[    1.721911] pcieport-driver 0000:00:07.0: setting latency timer to 64
[    1.722106]   alloc irq_desc for 158 on node 0
[    1.722108]   alloc kstat_irqs on node 0
[    1.722114] pcieport-driver 0000:00:1c.0: irq 158 for MSI/MSI-X
[    1.722122] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.723718] pcieport-driver 0000:05:00.0: setting latency timer to 64
[    1.727299]   alloc irq_desc for 159 on node 0
[    1.727300]   alloc kstat_irqs on node 0
[    1.727527] pcieport-driver 0000:06:00.0: irq 159 for MSI/MSI-X
[    1.727802] pcieport-driver 0000:06:00.0: setting latency timer to 64
[    1.731295]   alloc irq_desc for 160 on node 0
[    1.731297]   alloc kstat_irqs on node 0
[    1.731523] pcieport-driver 0000:06:01.0: irq 160 for MSI/MSI-X
[    1.731798] pcieport-driver 0000:06:01.0: setting latency timer to 64
[    1.734647] aer 0000:00:02.0:pcie02: service driver aer loaded
[    1.734677] aer 0000:00:03.0:pcie02: service driver aer loaded
[    1.734706] aer 0000:00:04.0:pcie02: service driver aer loaded
[    1.734735] aer 0000:00:05.0:pcie02: service driver aer loaded
[    1.734766] aer 0000:00:06.0:pcie02: service driver aer loaded
[    1.734794] aer 0000:00:07.0:pcie02: service driver aer loaded
[    1.735975] aer 0000:05:00.0:pcie12: service driver aer loaded
[    1.737074] aer 0000:06:00.0:pcie22: service driver aer loaded
[    1.738128] aer 0000:06:01.0:pcie22: service driver aer loaded
[    1.738136] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.738217] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.738388] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.738464] ACPI: Power Button [PWRF]
[    1.739044] processor LNXCPU:00: registered as cooling_device0
[    1.739453] processor LNXCPU:01: registered as cooling_device1
[    1.739854] processor LNXCPU:02: registered as cooling_device2
[    1.740258] processor LNXCPU:03: registered as cooling_device3
[    1.740689] processor LNXCPU:04: registered as cooling_device4
[    1.741095] processor LNXCPU:05: registered as cooling_device5
[    1.741495] processor LNXCPU:06: registered as cooling_device6
[    1.741910] processor LNXCPU:07: registered as cooling_device7
[    1.746246] Linux agpgart interface v0.103
[    1.746307] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.746460] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.746605] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.746899] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.747072] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.748041] brd: module loaded
[    1.748480] loop: module loaded
[    1.748593] input: Macintosh mouse button emulation as
/devices/virtual/input/input1
[    1.748856] ata_piix 0000:00:1f.1: version 2.13
[    1.748869] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.749008] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.749099] scsi0 : ata_piix
[    1.749269] scsi1 : ata_piix
[    1.749379] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
[    1.749439] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
[    1.750349] Fixed MDIO Bus: probed
[    1.750429] PPP generic driver version 2.4.2
[    1.750558] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.752417]   alloc irq_desc for 21 on node 0
[    1.752424] ata2: port disabled. ignoring.
[    1.752433]   alloc kstat_irqs on node 0
[    1.752438] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    1.752583] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.752586] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.752735] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 1
[    1.756694] ehci_hcd 0000:00:1d.7: debug port 1
[    1.756753] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.756767] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xfc900000
[    1.790029] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.790184] usb usb1: configuration #1 chosen from 1 choice
[    1.790266] hub 1-0:1.0: USB hub found
[    1.790326] hub 1-0:1.0: 8 ports detected
[    1.790462] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.790538] uhci_hcd: USB Universal Host Controller Interface driver
[    1.790698] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    1.790764] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.790767] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.790886] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    1.790980] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000bce0
[    1.791102] usb usb2: configuration #1 chosen from 1 choice
[    1.791180] hub 2-0:1.0: USB hub found
[    1.791238] hub 2-0:1.0: 2 ports detected
[    1.791408]   alloc irq_desc for 20 on node 0
[    1.791410]   alloc kstat_irqs on node 0
[    1.791415] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    1.791489] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.791492] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.791577] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 3
[    1.791680] uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000bcc0
[    1.791801] usb usb3: configuration #1 chosen from 1 choice
[    1.791878] hub 3-0:1.0: USB hub found
[    1.791940] hub 3-0:1.0: 2 ports detected
[    1.792084] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
[    1.792149] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.792152] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.792265] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 4
[    1.792389] uhci_hcd 0000:00:1d.2: irq 21, io base 0x0000bca0
[    1.792506] usb usb4: configuration #1 chosen from 1 choice
[    1.792586] hub 4-0:1.0: USB hub found
[    1.792643] hub 4-0:1.0: 2 ports detected
[    1.792785] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 20 (level, low) -> IRQ 20
[    1.792850] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    1.792853] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.792939] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 5
[    1.793062] uhci_hcd 0000:00:1d.3: irq 20, io base 0x0000bc80
[    1.793185] usb usb5: configuration #1 chosen from 1 choice
[    1.793262] hub 5-0:1.0: USB hub found
[    1.793319] hub 5-0:1.0: 2 ports detected
[    1.793483] PNP: No PS/2 controller found. Probing ports directly.
[    1.795964] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.796025] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.796153] mice: PS/2 mouse device common for all mice
[    1.796270] rtc_cmos 00:04: RTC can wake from S4
[    1.796354] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.796436] rtc0: alarms up to one day, y3k, 242 bytes nvram, hpet irqs
[    1.796592] device-mapper: uevent: version 1.0.3
[    1.796740] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01)
initialised: dm-devel@redhat.com
[    1.797088] device-mapper: multipath: version 1.1.0 loaded
[    1.797153] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.797808] cpuidle: using governor ladder
[    1.797885] cpuidle: using governor menu
[    1.798293] TCP cubic registered
[    1.798461] NET: Registered protocol family 10
[    1.798960] lo: Disabled Privacy Extensions
[    1.799260] NET: Registered protocol family 17
[    1.799329] Bluetooth: L2CAP ver 2.13
[    1.799383] Bluetooth: L2CAP socket layer initialized
[    1.799440] Bluetooth: SCO (Voice Link) ver 0.6
[    1.799495] Bluetooth: SCO socket layer initialized
[    1.799591] Bluetooth: RFCOMM TTY layer initialized
[    1.799650] Bluetooth: RFCOMM socket layer initialized
[    1.799707] Bluetooth: RFCOMM ver 1.11
[    1.799880] PM: Resume from disk failed.
[    1.799892] registered taskstats version 1
[    1.800105]   Magic number: 2:190:534
[    1.800170] bdi 1:12: hash matches
[    1.800318] rtc_cmos 00:04: setting system clock to 2010-03-18
13:30:07 UTC (1268919007)
[    1.800393] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.800451] EDD information not available.
[    1.920358] ata1.00: ATAPI: HL-DT-STDVD-ROM GDR8164B, 0D08, max UDMA/33
[    1.960208] ata1.00: configured for UDMA/33
[    1.966563] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVD-ROM
GDR8164B 0D08 PQ: 0 ANSI: 5
[    1.974533] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    1.974594] Uniform CD-ROM driver Revision: 3.20
[    1.974790] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.974860] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    1.974964] Freeing unused kernel memory: 660k freed
[    1.975296] Write protecting the kernel read-only data: 7572k
[    2.135298] md: linear personality registered for level -1
[    2.138439] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    2.138503] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    2.141993] e1000e 0000:0c:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.142081] e1000e 0000:0c:00.0: setting latency timer to 64
[    2.142234]   alloc irq_desc for 161 on node 0
[    2.142236]   alloc kstat_irqs on node 0
[    2.142250] e1000e 0000:0c:00.0: irq 161 for MSI/MSI-X
[    2.146566] md: multipath personality registered for level -4
[    2.149210] md: raid0 personality registered for level 0
[    2.151986] md: raid1 personality registered for level 1
[    2.153490] xor: automatically using best checksumming function: generic_sse
[    2.160231] Fusion MPT base driver 3.04.10
[    2.160289] Copyright (c) 1999-2008 LSI Corporation
[    2.167695] Fusion MPT SAS Host driver 3.04.10
[    2.192744]   alloc irq_desc for 128 on node 0
[    2.192746]   alloc kstat_irqs on node 0
[    2.192754] mptsas 0000:02:08.0: PCI INT A -> GSI 128 (level, low) -> IRQ 128
[    2.193021] mptbase: ioc0: Initiating bringup
[    2.203122]    generic_sse:  8649.200 MB/sec
[    2.203178] xor: using function: generic_sse (8649.200 MB/sec)
[    2.203648] async_tx: api initialized (async)
[    2.223806] usb 1-6: new high speed USB device using ehci_hcd and address 4
[    2.373147] raid6: int64x1   1847 MB/s
[    2.382988] 0000:0c:00.0: eth0: (PCI Express:2.5GB/s:Width x4)
00:15:17:25:b8:88
[    2.383064] 0000:0c:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    2.383197] 0000:0c:00.0: eth0: MAC: 0, PHY: 4, PBA No: c57721-005
[    2.383407] e1000e 0000:0c:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.383505] e1000e 0000:0c:00.1: setting latency timer to 64
[    2.383628]   alloc irq_desc for 162 on node 0
[    2.383630]   alloc kstat_irqs on node 0
[    2.383639] e1000e 0000:0c:00.1: irq 162 for MSI/MSI-X
[    2.384105] usb 1-6: configuration #1 chosen from 1 choice
[    2.389740] Initializing USB Mass Storage driver...
[    2.389989] scsi2 : SCSI emulation for USB Mass Storage devices
[    2.390180] usb-storage: device found at 4
[    2.390183] usb-storage: waiting for device to settle before scanning
[    2.390202] usbcore: registered new interface driver usb-storage
[    2.390262] USB Mass Storage support registered.
[    2.503801] usb 1-7: new high speed USB device using ehci_hcd and address 5
[    2.543128] raid6: int64x2   2493 MB/s
[    2.622990] 0000:0c:00.1: eth1: (PCI Express:2.5GB/s:Width x4)
00:15:17:25:b8:89
[    2.623066] 0000:0c:00.1: eth1: Intel(R) PRO/1000 Network Connection
[    2.623198] 0000:0c:00.1: eth1: MAC: 0, PHY: 4, PBA No: c57721-005
[    2.654808] usb 1-7: configuration #1 chosen from 1 choice
[    2.655173] hub 1-7:1.0: USB hub found
[    2.655366] hub 1-7:1.0: 4 ports detected
[    2.713143] raid6: int64x4   1831 MB/s
[    2.883139] raid6: int64x8   1660 MB/s
[    2.933799] usb 3-1: new low speed USB device using uhci_hcd and address 2
[    3.053130] raid6: sse2x1    2966 MB/s
[    3.157789] usb 3-1: configuration #1 chosen from 1 choice
[    3.198026] usbcore: registered new interface driver hiddev
[    3.223128] raid6: sse2x2    5913 MB/s
[    3.230007] input: Dell Dell USB Keyboard as
/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input2
[    3.230162] generic-usb 0003:413C:2105.0001: input,hidraw0: USB HID
v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.1-1/input0
[    3.230260] usbcore: registered new interface driver usbhid
[    3.230318] usbhid: v2.6:USB HID core driver
[    3.393129] raid6: sse2x4    6600 MB/s
[    3.393183] raid6: using algorithm sse2x4 (6600 MB/s)
[    3.395582] md: raid6 personality registered for level 6
[    3.395641] md: raid5 personality registered for level 5
[    3.395698] md: raid4 personality registered for level 4
[    3.401769] md: raid10 personality registered for level 10
[    3.474405] usb 4-1: new low speed USB device using uhci_hcd and address 2
[    3.659501] usb 4-1: configuration #1 chosen from 1 choice
[    3.675666] input: Logitech Optical USB Mouse as
/devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.0/input/input3
[    3.675818] generic-usb 0003:046D:C016.0002: input,hidraw1: USB HID
v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.2-1/input0
[    3.730048] ioc0: LSISAS1068 B0: Capabilities={Initiator}
[    5.190037] floppy0: no floppy controllers found
[    5.862098] scsi3 : ioc0: LSISAS1068 B0, FwRev=000a3300h, Ports=1,
MaxQ=366, IRQ=128
[    5.905946] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id
0, phy 0, sas_addr 0x5000c500022f3d49
[    5.907174] scsi 3:0:0:0: Direct-Access     SEAGATE  ST3300555SS
  T107 PQ: 0 ANSI: 5
[    5.909753] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    5.930985] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id
1, phy 1, sas_addr 0x5000c500022fcb09
[    5.933493] sd 3:0:0:0: [sda] 585937500 512-byte logical blocks:
(300 GB/279 GiB)
[    5.934187] scsi 3:0:1:0: Direct-Access     SEAGATE  ST3300555SS
  T107 PQ: 0 ANSI: 5
[    5.935831] sd 3:0:0:0: [sda] Write Protect is off
[    5.935890] sd 3:0:0:0: [sda] Mode Sense: b3 00 10 08
[    5.936756] sd 3:0:1:0: Attached scsi generic sg2 type 0
[    5.957996] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id
2, phy 2, sas_addr 0x5000c500022fb4ed
[    5.958008] sd 3:0:0:0: [sda] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[    5.960510] sd 3:0:1:0: [sdb] 585937500 512-byte logical blocks:
(300 GB/279 GiB)
[    5.982819] scsi 3:0:2:0: Direct-Access     SEAGATE  ST3300555SS
  T107 PQ: 0 ANSI: 5
[    5.984514] sd 3:0:1:0: [sdb] Write Protect is off
[    5.984578] sd 3:0:1:0: [sdb] Mode Sense: b3 00 10 08
[    5.986853] sd 3:0:1:0: [sdb] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[    5.987040] sd 3:0:2:0: Attached scsi generic sg3 type 0
[    6.031806] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id
3, phy 3, sas_addr 0x5000c500022fb425
[    6.031840]  sda:
[    6.032103] sd 3:0:2:0: [sdc] 585937500 512-byte logical blocks:
(300 GB/279 GiB)
[    6.033408] scsi 3:0:3:0: Direct-Access     SEAGATE  ST3300555SS
  T107 PQ: 0 ANSI: 5
[    6.034469] sd 3:0:2:0: [sdc] Write Protect is off
[    6.034473]  sda1 sda2
[    6.034608] sd 3:0:2:0: [sdc] Mode Sense: b3 00 10 08
[    6.036035] sd 3:0:3:0: Attached scsi generic sg4 type 0
[    6.055342] sd 3:0:2:0: [sdc] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[    6.055350]  sdb: sdb1 sdb2
[    6.102365] sd 3:0:3:0: [sdd] 585937500 512-byte logical blocks:
(300 GB/279 GiB)
[    6.125781] sd 3:0:3:0: [sdd] Write Protect is off
[    6.125840] sd 3:0:3:0: [sdd] Mode Sense: b3 00 10 08
[    6.126609] sd 3:0:0:0: [sda] Attached SCSI disk
[    6.127500] sd 3:0:3:0: [sdd] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[    6.127985]  sdc:
[    6.147365] sd 3:0:1:0: [sdb] Attached SCSI disk
[    6.147372]  sdc1 sdc2
[    6.174672]  sdd: sdd1 sdd2
[    6.175671] sd 3:0:2:0: [sdc] Attached SCSI disk
[    6.201153] sd 3:0:3:0: [sdd] Attached SCSI disk
[    6.276343] md: bind<sdc2>
[    6.278197] md: bind<sda1>
[    6.279321] md: bind<sdb1>
[    6.281869] raid1: raid set md0 active with 2 out of 2 mirrors
[    6.281970] md0: detected capacity change from 0 to 98566144
[    6.283362]  md0: unknown partition table
[    6.286825] md: bind<sdd1>
[    6.315425] md: bind<sdb2>
[    6.316585] md: bind<sdd2>
[    6.490737] md: bind<sdc1>
[    6.514868] md: bind<sda2>
[    6.517510] raid5: device sda2 operational as raid disk 0
[    6.517568] raid5: device sdd2 operational as raid disk 3
[    6.517625] raid5: device sdb2 operational as raid disk 1
[    6.517681] raid5: device sdc2 operational as raid disk 2
[    6.518182] raid5: allocated 4280kB for md1
[    6.518332] raid5: raid level 5 set md1 active with 4 out of 4
devices, algorithm 2
[    6.518407] RAID5 conf printout:
[    6.518460]  --- rd:4 wd:4
[    6.518512]  disk 0, o:1, dev:sda2
[    6.518565]  disk 1, o:1, dev:sdb2
[    6.518617]  disk 2, o:1, dev:sdc2
[    6.518670]  disk 3, o:1, dev:sdd2
[    6.518751] md1: detected capacity change from 0 to 899680763904
[    6.520096]  md1: unknown partition table
[    6.728145] EXT4-fs (md1): barriers enabled
[    6.735404] kjournald2 starting: pid 505, dev md1:8, commit
interval 5 seconds
[    6.735438] EXT4-fs (md1): delayed allocation enabled
[    6.735443] EXT4-fs: file extents enabled
[    6.737261] EXT4-fs: mballoc enabled
[    6.737331] EXT4-fs (md1): mounted filesystem with ordered data mode
[    7.215120] type=1505 audit(1268919012.914:2):
operation="profile_load" pid=526
name=/usr/share/gdm/guest-session/Xsession
[    7.237352] type=1505 audit(1268919012.929:3):
operation="profile_load" pid=527 name=/sbin/dhclient3
[    7.238049] type=1505 audit(1268919012.929:4):
operation="profile_load" pid=527
name=/usr/lib/NetworkManager/nm-dhcp-client.action
[    7.238466] type=1505 audit(1268919012.929:5):
operation="profile_load" pid=527
name=/usr/lib/connman/scripts/dhclient-script
[    7.245569] type=1505 audit(1268919012.939:6):
operation="profile_load" pid=529 name=/usr/sbin/tcpdump
[    7.393987] usb-storage: device scan complete
[    7.394458] scsi 2:0:0:0: Direct-Access     WD       10EADS
External  1.75 PQ: 0 ANSI: 4
[    7.395020] sd 2:0:0:0: Attached scsi generic sg5 type 0
[    7.395568] sd 2:0:0:0: [sde] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    7.396190] sd 2:0:0:0: [sde] Write Protect is off
[    7.396248] sd 2:0:0:0: [sde] Mode Sense: 23 00 00 00
[    7.396251] sd 2:0:0:0: [sde] Assuming drive cache: write through
[    7.397559] sd 2:0:0:0: [sde] Assuming drive cache: write through
[    7.397622]  sde: sde1
[    7.399439] sd 2:0:0:0: [sde] Assuming drive cache: write through
[    7.399499] sd 2:0:0:0: [sde] Attached SCSI disk
[   10.686527] udev: starting version 147
[   10.716994] lp: driver loaded but no devices found
[   10.718993] EDAC MC: Ver: 2.1.0 Jan 28 2010
[   10.726177] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   10.750362] [drm] Initialized drm 1.1.0 20060810
[   10.753575] dcdbas dcdbas: Dell Systems Management Base Driver
(version 5.6.0-3.2)
[   10.757510] EDAC MC0: Giving out device to 'i5000_edac.c' 'I5000':
DEV 0000:00:10.0
[   10.757533] EDAC PCI0: Giving out device to module 'i5000_edac'
controller 'EDAC PCI controller': DEV '0000:00:10.0' (POLLED)
[   10.762058] Broadcom NetXtreme II Gigabit Ethernet Driver bnx2
v2.0.1 (May 6, 2009)
[   10.762083] bnx2 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.768960] [drm] radeon default to kernel modesetting DISABLED.
[   10.769224] pci 0000:0f:0d.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   10.769390] [drm] Initialized radeon 1.31.0 20080528 for
0000:0f:0d.0 on minor 0
[   10.770312] intel_rng: FWH not detected
[   10.772522] dell-wmi: No known WMI GUID found
[   10.778738] ip_tables: (C) 2000-2006 Netfilter Core Team
[   10.816676] EXT4-fs (md1): internal journal on md1:8
[   10.951856] JBD: barrier-based sync failed on md1:8 - disabling barriers
[   11.357117] type=1505 audit(1268919017.052:7):
operation="profile_replace" pid=1057
name=/usr/share/gdm/guest-session/Xsession
[   11.359162] type=1505 audit(1268919017.052:8):
operation="profile_replace" pid=1058 name=/sbin/dhclient3
[   11.359783] type=1505 audit(1268919017.052:9):
operation="profile_replace" pid=1058
name=/usr/lib/NetworkManager/nm-dhcp-client.action
[   11.360122] type=1505 audit(1268919017.052:10):
operation="profile_replace" pid=1058
name=/usr/lib/connman/scripts/dhclient-script
[   11.363459] type=1505 audit(1268919017.062:11):
operation="profile_replace" pid=1060 name=/usr/sbin/tcpdump
[   11.380153] bnx2 0000:04:00.0: firmware: requesting
bnx2/bnx2-mips-06-4.6.16.fw
[   11.392021] bnx2 0000:04:00.0: firmware: requesting
bnx2/bnx2-rv2p-06-4.6.16.fw
[   11.398198] eth2: Broadcom NetXtreme II BCM5708 1000Base-T (B2)
PCI-X 64-bit 133MHz found at mem f8000000, IRQ 16, node addr
00:19:b9:c5:9a:ea
[   11.402190] bnx2 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   11.660308] e1000e 0000:0c:00.0: irq 161 for MSI/MSI-X
[   11.720734] e1000e 0000:0c:00.0: irq 161 for MSI/MSI-X
[   11.722574] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   11.870898] e1000e 0000:0c:00.1: irq 162 for MSI/MSI-X
[   11.930077] e1000e 0000:0c:00.1: irq 162 for MSI/MSI-X
[   11.931984] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   12.010256] bnx2 0000:08:00.0: firmware: requesting
bnx2/bnx2-mips-06-4.6.16.fw
[   12.016829] bnx2 0000:08:00.0: firmware: requesting
bnx2/bnx2-rv2p-06-4.6.16.fw
[   12.023731] eth3: Broadcom NetXtreme II BCM5708 1000Base-T (B2)
PCI-X 64-bit 133MHz found at mem f4000000, IRQ 17, node addr
00:19:b9:c5:9a:ec
[   12.049689]   alloc irq_desc for 163 on node 0
[   12.049692]   alloc kstat_irqs on node 0
[   12.049707] bnx2 0000:04:00.0: irq 163 for MSI/MSI-X
[   12.090905] /dev/vmmon[1273]: Module vmmon: registered with
major=10 minor=165
[   12.090953] /dev/vmmon[1273]: Initial HV check: anyNotCapable=0
anyUnlocked=0 anyEnabled=1 anyDisabled=0
[   12.091011] /dev/vmmon[1273]: HV check: anyNotCapable=0
anyUnlocked=0 anyEnabled=1 anyDisabled=0
[   12.091014] /dev/vmmon[1273]: Module vmmon: initialized
[   12.145290] /dev/vmci[1306]: VMCI: Driver initialized.
[   12.145336] /dev/vmci[1306]: Module vmci: registered with major=10 minor=55
[   12.145338] /dev/vmci[1306]: Module vmci: initialized
[   12.172708] bnx2: eth2: using MSI
[   12.174456] ADDRCONF(NETDEV_UP): eth2: link is not ready
[   12.209061]   alloc irq_desc for 164 on node 0
[   12.209064]   alloc kstat_irqs on node 0
[   12.209285] bnx2 0000:08:00.0: irq 164 for MSI/MSI-X
[   12.343631] ppdev: user-space parallel port driver
[   12.343634] bnx2: eth3: using MSI
[   12.345367] ADDRCONF(NETDEV_UP): eth3: link is not ready
[   12.542550] /dev/vmnet: open called by PID 1389 (vmnet-bridge)
[   12.542561] /dev/vmnet: hub 0 does not exist, allocating memory.
[   12.542580] /dev/vmnet: port on hub 0 successfully opened
[   12.542593] bridge-eth3: up
[   12.542616] bridge-eth3: attached
[   13.205046] bridge-eth3: disabling the bridge
[   13.233181] bridge-eth3: down
[   13.233187] bridge-eth3: detached
[   13.730079] floppy0: no floppy controllers found
[   14.183261] /dev/vmnet: open called by PID 1451 (vmnet-dhcpd)
[   14.183272] /dev/vmnet: hub 1 does not exist, allocating memory.
[   14.183291] /dev/vmnet: port on hub 1 successfully opened
[   14.218535] /dev/vmnet: open called by PID 1453 (vmnet-netifup)
[   14.218551] /dev/vmnet: port on hub 1 successfully opened
[   14.283918] /dev/vmnet: open called by PID 1457 (vmnet-dhcpd)
[   14.283930] /dev/vmnet: hub 8 does not exist, allocating memory.
[   14.283949] /dev/vmnet: port on hub 8 successfully opened
[   14.326235] /dev/vmnet: open called by PID 1461 (vmnet-natd)
[   14.326250] /dev/vmnet: port on hub 8 successfully opened
[   14.361740] /dev/vmnet: open called by PID 1462 (vmnet-netifup)
[   14.361751] /dev/vmnet: port on hub 8 successfully opened
[   14.945907] bnx2: eth2 NIC Copper Link is Up, 1000 Mbps full duplex
[   14.947758] ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
[   14.947933] /dev/vmnet: open called by PID 1389 (vmnet-bridge)
[   14.947950] /dev/vmnet: hub 0 does not exist, allocating memory.
[   14.947973] /dev/vmnet: port on hub 0 successfully opened
[   14.947986] bridge-eth2: up
[   14.947992] bridge-eth2: attached
[   15.005757] CPU0 attaching NULL sched-domain.
[   15.005764] CPU1 attaching NULL sched-domain.
[   15.005767] CPU2 attaching NULL sched-domain.
[   15.005769] CPU3 attaching NULL sched-domain.
[   15.005771] CPU4 attaching NULL sched-domain.
[   15.005774] CPU5 attaching NULL sched-domain.
[   15.005776] CPU6 attaching NULL sched-domain.
[   15.005779] CPU7 attaching NULL sched-domain.
[   15.031423] CPU0 attaching sched-domain:
[   15.031427]  domain 0: span 0,2,4,6 level MC
[   15.031430]   groups: 0 2 4 6
[   15.031435]   domain 1: span 0-7 level CPU
[   15.031437]    groups: 0,2,4,6 (__cpu_power = 4096) 1,3,5,7
(__cpu_power = 4096)
[   15.031444] CPU1 attaching sched-domain:
[   15.031446]  domain 0: span 1,3,5,7 level MC
[   15.031448]   groups: 1 3 5 7
[   15.031452]   domain 1: span 0-7 level CPU
[   15.031454]    groups: 1,3,5,7 (__cpu_power = 4096) 0,2,4,6
(__cpu_power = 4096)
[   15.031460] CPU2 attaching sched-domain:
[   15.031462]  domain 0: span 0,2,4,6 level MC
[   15.031464]   groups: 2 4 6 0
[   15.031469]   domain 1: span 0-7 level CPU
[   15.031471]    groups: 0,2,4,6 (__cpu_power = 4096) 1,3,5,7
(__cpu_power = 4096)
[   15.031476] CPU3 attaching sched-domain:
[   15.031478]  domain 0: span 1,3,5,7 level MC
[   15.031480]   groups: 3 5 7 1
[   15.031484]   domain 1: span 0-7 level CPU
[   15.031486]    groups: 1,3,5,7 (__cpu_power = 4096) 0,2,4,6
(__cpu_power = 4096)
[   15.031492] CPU4 attaching sched-domain:
[   15.031494]  domain 0: span 0,2,4,6 level MC
[   15.031496]   groups: 4 6 0 2
[   15.031500]   domain 1: span 0-7 level CPU
[   15.031502]    groups: 0,2,4,6 (__cpu_power = 4096) 1,3,5,7
(__cpu_power = 4096)
[   15.031508] CPU5 attaching sched-domain:
[   15.031510]  domain 0: span 1,3,5,7 level MC
[   15.031512]   groups: 5 7 1 3
[   15.031516]   domain 1: span 0-7 level CPU
[   15.031518]    groups: 1,3,5,7 (__cpu_power = 4096) 0,2,4,6
(__cpu_power = 4096)
[   15.031524] CPU6 attaching sched-domain:
[   15.031526]  domain 0: span 0,2,4,6 level MC
[   15.031528]   groups: 6 0 2 4
[   15.031532]   domain 1: span 0-7 level CPU
[   15.031534]    groups: 0,2,4,6 (__cpu_power = 4096) 1,3,5,7
(__cpu_power = 4096)
[   15.031540] CPU7 attaching sched-domain:
[   15.031542]  domain 0: span 1,3,5,7 level MC
[   15.031544]   groups: 7 1 3 5
[   15.031548]   domain 1: span 0-7 level CPU
[   15.031550]    groups: 1,3,5,7 (__cpu_power = 4096) 0,2,4,6
(__cpu_power = 4096)
[   16.651342] CPU0 attaching NULL sched-domain.
[   16.651348] CPU1 attaching NULL sched-domain.
[   16.651351] CPU2 attaching NULL sched-domain.
[   16.651353] CPU3 attaching NULL sched-domain.
[   16.651356] CPU4 attaching NULL sched-domain.
[   16.651358] CPU5 attaching NULL sched-domain.
[   16.651361] CPU6 attaching NULL sched-domain.
[   16.651363] CPU7 attaching NULL sched-domain.
[   16.683952] CPU0 attaching sched-domain:
[   16.683956]  domain 0: span 0,4 level MC
[   16.683958]   groups: 0 4
[   16.683962]   domain 1: span 0-7 level CPU
[   16.683964]    groups: 0,4 1,5 2,6 3,7
[   16.683971] CPU1 attaching sched-domain:
[   16.683972]  domain 0: span 1,5 level MC
[   16.683974]   groups: 1 5
[   16.683978]   domain 1: span 0-7 level CPU
[   16.683980]    groups: 1,5 2,6 3,7 0,4
[   16.683985] CPU2 attaching sched-domain:
[   16.683987]  domain 0: span 2,6 level MC
[   16.683989]   groups: 2 6
[   16.683992]   domain 1: span 0-7 level CPU
[   16.683994]    groups: 2,6 3,7 0,4 1,5
[   16.683999] CPU3 attaching sched-domain:
[   16.684000]  domain 0: span 3,7 level MC
[   16.684002]   groups: 3 7
[   16.684005]   domain 1: span 0-7 level CPU
[   16.684007]    groups: 3,7 0,4 1,5 2,6
[   16.684013] CPU4 attaching sched-domain:
[   16.684014]  domain 0: span 0,4 level MC
[   16.684016]   groups: 4 0
[   16.684019]   domain 1: span 0-7 level CPU
[   16.684021]    groups: 0,4 1,5 2,6 3,7
[   16.684027] CPU5 attaching sched-domain:
[   16.684028]  domain 0: span 1,5 level MC
[   16.684030]   groups: 5 1
[   16.684033]   domain 1: span 0-7 level CPU
[   16.684035]    groups: 1,5 2,6 3,7 0,4
[   16.684040] CPU6 attaching sched-domain:
[   16.684042]  domain 0: span 2,6 level MC
[   16.684044]   groups: 6 2
[   16.684047]   domain 1: span 0-7 level CPU
[   16.684049]    groups: 2,6 3,7 0,4 1,5
[   16.684054] CPU7 attaching sched-domain:
[   16.684055]  domain 0: span 3,7 level MC
[   16.684057]   groups: 7 3
[   16.684060]   domain 1: span 0-7 level CPU
[   16.684062]    groups: 3,7 0,4 1,5 2,6
[   18.093161] /dev/vmmon[0]: HostIF_ReadUptime: detected
settimeofday: fixed uptimeBase old 18445475154691760999 new
18445475154670328232 attempts 1
[   24.981893] vmnet1: no IPv6 routers present
[   24.990066] vmnet8: no IPv6 routers present
[   25.160039] eth2: no IPv6 routers present
[   93.375156] /dev/vmmon[2011]: PTSC: initialized at 2327614000 Hz using TSC
[   95.785854] /dev/vmnet: open called by PID 2014 (vmware-vmx)
[   95.785876] device eth2 entered promiscuous mode
[   95.785880] bridge-eth2: enabled promiscuous mode
[   95.785882] /dev/vmnet: port on hub 0 successfully opened
[  119.903499] /dev/vmnet: open called by PID 2118 (vmware-vmx)
[  119.903518] /dev/vmnet: port on hub 0 successfully opened
[  137.839846] /dev/vmnet: open called by PID 2167 (vmware-vmx)
[  137.839869] /dev/vmnet: port on hub 0 successfully opened
[  172.263434] /dev/vmnet: open called by PID 2182 (vmware-vmx)
[  172.263455] /dev/vmnet: port on hub 0 successfully opened
[  172.263468] /dev/vmnet: open called by PID 2182 (vmware-vmx)
[  172.263475] /dev/vmnet: port on hub 0 successfully opened


I also saw somewhere to add the output of a dmidecode, so here it is also:

# dmidecode 2.9
SMBIOS 2.5 present.
67 structures occupying 3419 bytes.
Table at 0xCFB9C000.

Handle 0xDA00, DMI type 218, 11 bytes
OEM-specific Type
	Header and Data:
		DA 0B 00 DA B2 00 17 00 0E 20 00

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Dell Inc.
	Version: 2.6.1
	Release Date: 04/20/2009
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 1024 kB
	Characteristics:
		ISA is supported
		PCI is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		EDD is supported
		Japanese floppy for Toshiba 1.2 MB is supported (int 13h)
		5.25"/360 KB floppy services are supported (int 13h)
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 KB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Function key-initiated network boot is supported
		Targeted content distribution is supported
	BIOS Revision: 2.6

Handle 0x0100, DMI type 1, 27 bytes
System Information
	Manufacturer: Dell Inc.
	Product Name: PowerEdge 2900
	Version: Not Specified
	Serial Number: 17VSW2J
	UUID: 44454C4C-3700-1056-8053-B1C04F57324A
	Wake-up Type: Power Switch
	SKU Number: Not Specified
	Family: Not Specified

Handle 0x0200, DMI type 2, 9 bytes
Base Board Information
	Manufacturer: Dell Inc.
	Product Name: 0TM757
	Version: A00
	Serial Number: ..CN1374074300SY.

Handle 0x0300, DMI type 3, 21 bytes
Chassis Information
	Manufacturer: Dell Inc.
	Type: Main Server Chassis
	Lock: Present
	Version: Not Specified
	Serial Number: 17VSW2J
	Asset Tag: Not Specified
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: Unknown
	OEM Information: 0x00000000
	Height: 5 U
	Number Of Power Cords: Unspecified
	Contained Elements: 0

Handle 0x0400, DMI type 4, 40 bytes
Processor Information
	Socket Designation: CPU1
	Type: Central Processor
	Family: Xeon
	Manufacturer: Intel
	ID: F7 06 00 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 15, Stepping 7
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		DS (Debug store)
		ACPI (ACPI supported)
		MMX (MMX technology supported)
		FXSR (Fast floating-point save and restore)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		SS (Self-snoop)
		HTT (Hyper-threading technology)
		TM (Thermal monitor supported)
		PBE (Pending break enabled)
	Version: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz
	Voltage: 1.4 V
	External Clock: 1333 MHz
	Max Speed: 3600 MHz
	Current Speed: 2333 MHz
	Status: Populated, Enabled
	Upgrade: Socket LGA771
	L1 Cache Handle: 0x0700
	L2 Cache Handle: 0x0701
	L3 Cache Handle: 0x0702
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified
	Core Count: 4
	Core Enabled: 4
	Thread Count: 4
	Characteristics:
		64-bit capable

Handle 0x0401, DMI type 4, 40 bytes
Processor Information
	Socket Designation: CPU2
	Type: Central Processor
	Family: Xeon
	Manufacturer: Intel
	ID: FB 06 00 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 15, Stepping 11
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		DS (Debug store)
		ACPI (ACPI supported)
		MMX (MMX technology supported)
		FXSR (Fast floating-point save and restore)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		SS (Self-snoop)
		HTT (Hyper-threading technology)
		TM (Thermal monitor supported)
		PBE (Pending break enabled)
	Version: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz
	Voltage: 1.4 V
	External Clock: 1333 MHz
	Max Speed: 3600 MHz
	Current Speed: 2333 MHz
	Status: Populated, Idle
	Upgrade: Socket LGA771
	L1 Cache Handle: 0x0703
	L2 Cache Handle: 0x0704
	L3 Cache Handle: 0x0705
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified
	Core Count: 4
	Core Enabled: 4
	Thread Count: 4
	Characteristics:
		64-bit capable

Handle 0x0700, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Not Specified
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 128 KB
	Maximum Size: 128 KB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 8-way Set-associative

Handle 0x0701, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Not Specified
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 8192 KB
	Maximum Size: 8192 KB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 16-way Set-associative

Handle 0x0702, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Not Specified
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 0 KB
	Maximum Size: 0 KB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: Unknown

Handle 0x0703, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Not Specified
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 128 KB
	Maximum Size: 128 KB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 8-way Set-associative

Handle 0x0704, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Not Specified
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 8192 KB
	Maximum Size: 8192 KB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 16-way Set-associative

Handle 0x0705, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Not Specified
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 0 KB
	Maximum Size: 0 KB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: Unknown

Handle 0x0800, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x0801, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x0802, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0803, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0804, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0805, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0806, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0807, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0808, DMI type 126, 9 bytes
Inactive

Handle 0x0809, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x080A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x080B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: DB-9 male
	Port Type: Serial Port 16550A Compatible

Handle 0x0900, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI1
	Type: 64-bit PCI-X
	Current Usage: Available
	Length: Long
	ID: 1
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x0901, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI2
	Type: 64-bit PCI-X
	Current Usage: Available
	Length: Long
	ID: 2
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x0902, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI3
	Type: x8 PCI Express
	Current Usage: Available
	Length: Long
	ID: 3
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x0903, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI4
	Type: x4 PCI Express
	Current Usage: In Use
	Length: Long
	ID: 4
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x0904, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI5
	Type: x4 PCI Express
	Current Usage: Available
	Length: Long
	ID: 5
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x0905, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI6
	Type: x4 PCI Express
	Current Usage: Available
	Length: Long
	ID: 6
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x0A00, DMI type 10, 10 bytes
On Board Device 1 Information
	Type: Video
	Status: Enabled
	Description: Embedded ATI ES1000 Video
On Board Device 2 Information
	Type: Ethernet
	Status: Enabled
	Description: Embedded Broadcom 5708 NIC 1
On Board Device 3 Information
	Type: Ethernet
	Status: Enabled
	Description: Embedded Broadcom 5708 NIC 2

Handle 0x0B00, DMI type 11, 5 bytes
OEM Strings
	String 1: Dell System
	String 2: 5[0000]

Handle 0x7E00, DMI type 126, 154 bytes
Inactive

Handle 0x0C00, DMI type 12, 5 bytes
System Configuration Options
	Option 1: NVRAM_CLR:  Clear user settable NVRAM areas and set defaults
	Option 2: PWRD_EN:  Close to enable password

Handle 0x0D00, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 1
		en|US|iso8859-1
	Currently Installed Language: en|US|iso8859-1

Handle 0x1000, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: Multi-bit ECC
	Maximum Capacity: 65280 MB
	Error Information Handle: Not Provided
	Number Of Devices: 12

Handle 0x1100, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: FB-DIMM
	Set: 1
	Locator: DIMM1
	Bank Locator: Not Specified
	Type: DDR2 FB-DIMM
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 80AD808980AD
	Serial Number: 87653205
	Asset Tag: 010917
	Part Number: HYMP151F72CP4N3-Y5

Handle 0x1101, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: FB-DIMM
	Set: 1
	Locator: DIMM2
	Bank Locator: Not Specified
	Type: DDR2 FB-DIMM
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 830B7FB3830B
	Serial Number: 723B3F5B
	Asset Tag: 0D0931
	Part Number: NT4GT72U4ND1BD-3C

Handle 0x1102, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: FB-DIMM
	Set: 2
	Locator: DIMM3
	Bank Locator: Not Specified
	Type: DDR2 FB-DIMM
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 830B7FB3830B
	Serial Number: 9D623F5C
	Asset Tag: 0D0931
	Part Number: NT4GT72U4ND1BD-3C

Handle 0x1103, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: FB-DIMM
	Set: 2
	Locator: DIMM4
	Bank Locator: Not Specified
	Type: DDR2 FB-DIMM
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 830B7FB3830B
	Serial Number: 8C3A3F5B
	Asset Tag: 0D0931
	Part Number: NT4GT72U4ND1BD-3C

Handle 0x1104, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: FB-DIMM
	Set: 3
	Locator: DIMM5
	Bank Locator: Not Specified
	Type: DDR2 FB-DIMM
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 80AD808980AD
	Serial Number: 87653605
	Asset Tag: 010917
	Part Number: HYMP151F72CP4N3-Y5

Handle 0x1105, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: FB-DIMM
	Set: 3
	Locator: DIMM6
	Bank Locator: Not Specified
	Type: DDR2 FB-DIMM
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 830B7FB3830B
	Serial Number: 06613F5E
	Asset Tag: 0D0931
	Part Number: NT4GT72U4ND1BD-3C

Handle 0x1106, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: FB-DIMM
	Set: 4
	Locator: DIMM7
	Bank Locator: Not Specified
	Type: DDR2 FB-DIMM
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 830B7FB3830B
	Serial Number: 9E623F5F
	Asset Tag: 0D0931
	Part Number: NT4GT72U4ND1BD-3C

Handle 0x1107, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: FB-DIMM
	Set: 4
	Locator: DIMM8
	Bank Locator: Not Specified
	Type: DDR2 FB-DIMM
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 830B7FB3830B
	Serial Number: 05633F5C
	Asset Tag: 0D0931
	Part Number: NT4GT72U4ND1BD-3C

Handle 0x1108, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: FB-DIMM
	Set: 5
	Locator: DIMM9
	Bank Locator: Not Specified
	Type: DDR2 FB-DIMM
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 830B7FB3830B
	Serial Number: B9623F5D
	Asset Tag: 0D0931
	Part Number: NT4GT72U4ND1BD-3C

Handle 0x1109, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: FB-DIMM
	Set: 5
	Locator: DIMM10
	Bank Locator: Not Specified
	Type: DDR2 FB-DIMM
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 830B7FB3830B
	Serial Number: 34623F5E
	Asset Tag: 0D0931
	Part Number: NT4GT72U4ND1BD-3C

Handle 0x110A, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: FB-DIMM
	Set: 6
	Locator: DIMM11
	Bank Locator: Not Specified
	Type: DDR2 FB-DIMM
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 80CE808980CE
	Serial Number: 251287F0
	Asset Tag: 010734
	Part Number: M395T2953EZ4-CE65

Handle 0x110B, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: FB-DIMM
	Set: 6
	Locator: DIMM12
	Bank Locator: Not Specified
	Type: DDR2 FB-DIMM
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 80CE808980CE
	Serial Number: 25128701
	Asset Tag: 010734
	Part Number: M395T2953EZ4-CE65

Handle 0x1300, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000CFFFFFFF
	Range Size: 3328 MB
	Physical Array Handle: 0x1000
	Partition Width: 0

Handle 0x1301, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00100000000
	Ending Address: 0x00AAFFFFFFF
	Range Size: 39680 MB
	Physical Array Handle: 0x1000
	Partition Width: 0

Handle 0x2000, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x2600, DMI type 38, 18 bytes
IPMI Device Information
	Interface Type: KCS (Keyboard Control Style)
	Specification Version: 2.0
	I2C Slave Address: 0x10
	NV Storage Device: Not Present
	Base Address: 0x0000000000000CA8 (I/O)
	Register Spacing: 32-bit Boundaries

Handle 0x2900, DMI type 41, 11 bytes
Unknown Type
	Header and Data:
		29 0B 00 29 01 85 01 00 00 04 00
	Strings:
		Embedded NIC 1

Handle 0x2901, DMI type 41, 11 bytes
Unknown Type
	Header and Data:
		29 0B 01 29 01 85 02 00 00 08 00
	Strings:
		Embedded NIC 2

Handle 0xD000, DMI type 208, 13 bytes
OEM-specific Type
	Header and Data:
		D0 0D 00 D0 02 00 FE 00 B1 01 00 00 01

Handle 0xD200, DMI type 210, 12 bytes
OEM-specific Type
	Header and Data:
		D2 0C 00 D2 F8 03 04 03 06 80 04 05

Handle 0xD400, DMI type 212, 127 bytes
OEM-specific Type
	Header and Data:
		D4 7F 00 D4 70 00 71 00 00 10 2D 2E 03 00 11 7F
		80 04 00 11 7F 00 42 00 11 FE 01 43 00 11 FE 00
		70 01 11 9F 20 6F 01 11 9F 00 00 00 11 9F 20 00
		00 11 9F 00 31 40 11 FB 00 32 40 11 FB 04 9D 00
		11 FD 02 9E 00 11 FD 00 9F 00 26 FE 01 A0 00 26
		FE 00 51 00 26 3F 00 52 00 26 3F 40 53 00 26 3F
		80 54 00 26 3F C0 28 40 26 DF 20 29 40 26 DF 00
		D6 01 26 F7 00 D7 01 26 F7 08 FF FF 00 00 00

Handle 0xD401, DMI type 212, 207 bytes
OEM-specific Type
	Header and Data:
		D4 CF 01 D4 70 00 71 00 03 40 5A 6D 6B 00 78 7F
		80 6C 00 78 7F 00 58 00 78 FA 05 59 00 78 FA 00
		5C 00 78 BF 40 5D 00 78 BF 00 04 80 78 FD 02 01
		A0 78 FD 00 00 00 55 E7 00 00 00 55 E7 08 00 00
		55 E7 10 6C 01 57 FC 00 6B 01 57 FC 01 6A 01 57
		FC 02 77 01 54 FC 00 78 01 54 FC 01 79 01 54 FC
		02 7A 01 54 FC 03 33 40 54 CF 00 34 40 54 CF 10
		35 40 54 CF 20 36 40 54 CF 30 1A 40 54 FB 04 1B
		40 54 FB 00 1C 40 54 F7 08 1D 40 54 F7 00 43 40
		58 DF 20 42 40 58 DF 00 6E 00 58 FC 01 2D 00 58
		FC 02 00 00 58 FC 03 2E 00 58 FC 00 22 40 58 EF
		10 23 40 58 EF 00 BB 00 58 F3 04 BC 00 58 F3 08
		00 00 58 F3 0C BA 00 58 F3 00 FF FF 00 00 00

Handle 0xD402, DMI type 212, 47 bytes
OEM-specific Type
	Header and Data:
		D4 2F 02 D4 70 00 71 00 03 40 5A 6D D8 00 55 7F
		80 D9 00 55 7F 00 00 C0 5C 00 0A 03 C0 67 00 05
		83 00 76 00 00 84 00 77 00 00 FF FF 00 00 00

Handle 0xD403, DMI type 212, 247 bytes
OEM-specific Type
	Header and Data:
		D4 F7 03 D4 72 00 73 00 00 40 5D 5E 71 01 46 FB
		04 72 01 46 FB 00 73 01 46 F7 08 74 01 46 F7 00
		00 00 46 FE 00 00 00 46 FE 01 4A 01 46 BF 40 4B
		01 46 BF 00 D3 00 00 00 02 D4 00 02 00 02 00 90
		2C 00 00 01 90 2D 00 00 00 00 49 EB 14 DB 00 49
		EB 00 00 00 49 FC 00 00 00 49 FC 01 00 00 49 FC
		02 00 00 49 7F 00 00 00 49 7F 80 17 01 4A FE 00
		18 01 4A FE 01 19 01 4A FD 00 1A 01 4A FD 02 00
		00 4A FB 00 00 00 4A FB 04 00 00 4A F7 00 00 00
		4A F7 08 35 01 4B FC 00 37 01 4B FC 01 3B 01 4B
		F3 04 DE 00 63 FE 01 26 40 42 FE 01 27 40 42 FE
		00 49 01 47 FE 01 48 01 47 FE 00 A1 00 45 CF 20
		A3 00 45 CF 10 A2 00 45 CF 00 02 40 46 DF 00 01
		40 46 DF 20 95 01 7E FC 00 96 01 7E FC 01 97 01
		7E FC 02 09 80 7E F3 00 0A 80 7E F3 04 0B 80 7E
		F3 08 FF FF 00 00 00

Handle 0xD404, DMI type 212, 77 bytes
OEM-specific Type
	Header and Data:
		D4 4D 04 D4 72 00 73 00 00 40 5D 5E 41 40 40 FE
		01 40 40 40 FE 00 CF 01 40 FD 02 D0 01 40 FD 00
		45 40 40 F7 08 44 40 40 F7 00 FC 01 45 BF 00 FD
		01 45 BF 40 40 01 47 FD 02 41 01 47 FD 00 31 02
		47 FB 00 32 02 47 FB 04 FF FF 00 00 00

Handle 0xD405, DMI type 212, 27 bytes
OEM-specific Type
	Header and Data:
		D4 1B 05 D4 70 00 71 00 03 40 5A 6D 00 00 57 EF
		00 00 00 57 EF 10 FF FF 00 00 00

Handle 0xD800, DMI type 216, 9 bytes
OEM-specific Type
	Header and Data:
		D8 09 00 D8 01 02 01 00 00
	Strings:
		ATI
		RN50 A20 BIOS

Handle 0xDE00, DMI type 222, 16 bytes
OEM-specific Type
	Header and Data:
		DE 10 00 DE 01 04 00 00 10 02 23 08 56 00 00 01

Handle 0xE000, DMI type 224, 11 bytes
OEM-specific Type
	Header and Data:
		E0 0B 00 E0 01 00 07 FF FF 01 02
	Strings:
		0FG027
		FFFFFF

Handle 0x7F00, DMI type 127, 4 bytes
End Of Table



Thanks for any help, tips or pointers!

Tomasz
