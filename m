Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab0HQPB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:01:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62163 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab0HQPBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:01:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DvK50ZDrJJsqC8Cfx752BWmYSSUJaugPrE5aZdw1RRhEb1sLfb9DpFrV9QpM9yG/LH
         cLSgPh3hT3bdX6qGDfvfH/eqlgzrsino5VdH7wG8XfknnNKCYauAM3wzqsZGjWddL7iZ
         lDjj1qEEjcnaDC/22oOTyZgTJYuH7VvT63S2Q=
Date: Tue, 17 Aug 2010 16:53:05 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.35.2 regression, does not boot, sleeping function called from
	invalid context
Message-ID: <20100817145305.GA7342@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

updated 2.6.35 -> 2.6.35.2 and it breaks very early during initialisation, does
not boot.

The first oops I get is a ~BUG sleeping function called from invalid context, mm/rmap.c:119~
Comes right after 
  protecting the kernel read only data: 1868K

Backtrace seems to be 
  anon_vma_prepare
  do_raw_spinlock
  expand_downwards

I can email pictures of stack back trace off list if anyone is interested.
2.6.35 works without problems except that hibernation is completely broken,
attached dmesgs for 2.6.35

Richard

Aug 17 15:23:48 localhost kernel: [    0.000000] Initializing cgroup subsys cpuset
Aug 17 15:23:48 localhost kernel: [    0.000000] Initializing cgroup subsys cpu
Aug 17 15:23:48 localhost kernel: [    0.000000] Linux version 2.6.35v1 (rz@rz) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #1 SMP Wed Aug 4 00:37:26 CEST 2010
Aug 17 15:23:48 localhost kernel: [    0.000000] BIOS-provided physical RAM map:
Aug 17 15:23:48 localhost kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Aug 17 15:23:48 localhost kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Aug 17 15:23:48 localhost kernel: [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
Aug 17 15:23:48 localhost kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000007f7b0000 (usable)
Aug 17 15:23:48 localhost kernel: [    0.000000]  BIOS-e820: 000000007f7b0000 - 000000007f7c0000 (ACPI data)
Aug 17 15:23:48 localhost kernel: [    0.000000]  BIOS-e820: 000000007f7c0000 - 000000007f7f0000 (ACPI NVS)
Aug 17 15:23:48 localhost kernel: [    0.000000]  BIOS-e820: 000000007f7f0000 - 000000007f800000 (reserved)
Aug 17 15:23:48 localhost kernel: [    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
Aug 17 15:23:48 localhost kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Aug 17 15:23:48 localhost kernel: [    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
Aug 17 15:23:48 localhost kernel: [    0.000000] Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
Aug 17 15:23:48 localhost kernel: [    0.000000] DMI present.
Aug 17 15:23:48 localhost kernel: [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
Aug 17 15:23:48 localhost kernel: [    0.000000] last_pfn = 0x7f7b0 max_arch_pfn = 0x100000
Aug 17 15:23:48 localhost kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Aug 17 15:23:48 localhost kernel: [    0.000000] found SMP MP-table at [c00ff780] ff780
Aug 17 15:23:48 localhost kernel: [    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
Aug 17 15:23:48 localhost kernel: [    0.000000] RAMDISK: 37bfd000 - 37ff0000
Aug 17 15:23:48 localhost kernel: [    0.000000] Allocated new RAMDISK: 001d6000 - 005c8023
Aug 17 15:23:48 localhost kernel: [    0.000000] Move RAMDISK from 0000000037bfd000 - 0000000037fef022 to 001d6000 - 005c8022
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: RSDP 000fa4f0 00014 (v00 ACPIAM)
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: RSDT 7f7b0000 00040 (v01 A_M_I  OEMRSDT  11000817 MSFT 00000097)
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: FACP 7f7b0200 00084 (v02 A M I  OEMFACP  12000601 MSFT 00000097)
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: DSDT 7f7b0440 0424C (v01  AS154 AS154101 00000101 INTL 02002026)
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: FACS 7f7c0000 00040
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: APIC 7f7b0390 0006C (v01 A_M_I  OEMAPIC  11000817 MSFT 00000097)
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: MCFG 7f7b0400 0003C (v01 A_M_I  OEMMCFG  11000817 MSFT 00000097)
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: OEMB 7f7c0040 00046 (v01 A_M_I  AMI_OEM  11000817 MSFT 00000097)
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: AAFT 7f7b4690 00027 (v01 A_M_I  OEMAAFT  11000817 MSFT 00000097)
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: HPET 7f7b46c0 00038 (v01 A_M_I  OEMHPET  11000817 MSFT 00000097)
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: SSDT 7f7c09b0 00A7C (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
Aug 17 15:23:48 localhost kernel: [    0.000000] 1151MB HIGHMEM available.
Aug 17 15:23:48 localhost kernel: [    0.000000] 887MB LOWMEM available.
Aug 17 15:23:48 localhost kernel: [    0.000000]   mapped low ram: 0 - 377fe000
Aug 17 15:23:48 localhost kernel: [    0.000000]   low ram: 0 - 377fe000
Aug 17 15:23:48 localhost kernel: [    0.000000] Zone PFN ranges:
Aug 17 15:23:48 localhost kernel: [    0.000000]   DMA      0x00000010 -> 0x00001000
Aug 17 15:23:48 localhost kernel: [    0.000000]   Normal   0x00001000 -> 0x000377fe
Aug 17 15:23:48 localhost kernel: [    0.000000]   HighMem  0x000377fe -> 0x0007f7b0
Aug 17 15:23:48 localhost kernel: [    0.000000] Movable zone start PFN for each node
Aug 17 15:23:48 localhost kernel: [    0.000000] early_node_map[2] active PFN ranges
Aug 17 15:23:48 localhost kernel: [    0.000000]     0: 0x00000010 -> 0x0000009f
Aug 17 15:23:48 localhost kernel: [    0.000000]     0: 0x00000100 -> 0x0007f7b0
Aug 17 15:23:48 localhost kernel: [    0.000000] Using APIC driver default
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x808
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Aug 17 15:23:48 localhost kernel: [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Aug 17 15:23:48 localhost kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Aug 17 15:23:48 localhost kernel: [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
Aug 17 15:23:48 localhost kernel: [    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
Aug 17 15:23:48 localhost kernel: [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Aug 17 15:23:48 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
Aug 17 15:23:48 localhost kernel: [    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
Aug 17 15:23:48 localhost kernel: [    0.000000] Allocating PCI resources starting at 7f800000 (gap: 7f800000:7f500000)
Aug 17 15:23:48 localhost kernel: [    0.000000] Booting paravirtualized kernel on bare hardware
Aug 17 15:23:48 localhost kernel: [    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
Aug 17 15:23:48 localhost kernel: [    0.000000] PERCPU: Embedded 14 pages/cpu @c2c00000 s35264 r0 d22080 u1048576
Aug 17 15:23:48 localhost kernel: [    0.000000] pcpu-alloc: s35264 r0 d22080 u1048576 alloc=1*4194304
Aug 17 15:23:48 localhost kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3 
Aug 17 15:23:48 localhost kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517967
Aug 17 15:23:48 localhost kernel: [    0.000000] Kernel command line: ro root=/dev/mapper/luks-945154b7-c0e5-40b1-8947-25673735c9c0 no_console_suspend
Aug 17 15:23:48 localhost kernel: [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
Aug 17 15:23:48 localhost kernel: [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Aug 17 15:23:48 localhost kernel: [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Aug 17 15:23:48 localhost kernel: [    0.000000] Enabling fast FPU save and restore... done.
Aug 17 15:23:48 localhost kernel: [    0.000000] Enabling unmasked SIMD FPU exception support... done.
Aug 17 15:23:48 localhost kernel: [    0.000000] Initializing CPU#0
Aug 17 15:23:48 localhost kernel: [    0.000000] allocated 10442880 bytes of page_cgroup
Aug 17 15:23:48 localhost kernel: [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
Aug 17 15:23:48 localhost kernel: [    0.000000] Subtract (51 early reservations)
Aug 17 15:23:48 localhost kernel: [    0.000000]   #1 [0000001000 - 0000002000]   EX TRAMPOLINE
Aug 17 15:23:48 localhost kernel: [    0.000000]   #2 [0001000000 - 0001b7b7c4]   TEXT DATA BSS
Aug 17 15:23:48 localhost kernel: [    0.000000]   #3 [0001b7c000 - 0001b8412f]             BRK
Aug 17 15:23:48 localhost kernel: [    0.000000]   #4 [00000ff790 - 0000100000]   BIOS reserved
Aug 17 15:23:48 localhost kernel: [    0.000000]   #5 [00000ff780 - 00000ff790]    MP-table mpf
Aug 17 15:23:48 localhost kernel: [    0.000000]   #6 [000009fc00 - 00000e0000]   BIOS reserved
Aug 17 15:23:48 localhost kernel: [    0.000000]   #7 [00000e0144 - 00000ff780]   BIOS reserved
Aug 17 15:23:48 localhost kernel: [    0.000000]   #8 [00000e0000 - 00000e0144]    MP-table mpc
Aug 17 15:23:48 localhost kernel: [    0.000000]   #9 [0000010000 - 0000011000]      TRAMPOLINE
Aug 17 15:23:48 localhost kernel: [    0.000000]   #10 [0000011000 - 0000015000]     ACPI WAKEUP
Aug 17 15:23:48 localhost kernel: [    0.000000]   #11 [0000100000 - 00001d6000]         PGTABLE
Aug 17 15:23:48 localhost kernel: [    0.000000]   #12 [00001d6000 - 00005c9000]     NEW RAMDISK
Aug 17 15:23:48 localhost kernel: [    0.000000]   #13 [0001b85000 - 0001b86000]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #14 [0001b86000 - 0002b76000]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #15 [0001b7b800 - 0001b7b804]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #16 [0001b7b840 - 0001b7ba80]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #17 [0001b7ba80 - 0001b7bad4]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #18 [0002b76000 - 0002b7f000]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #19 [0001b7bb00 - 0001b7bb6c]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #20 [0002b7f000 - 0002b91000]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #21 [0001b7bb80 - 0001b7bba5]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #22 [0001b7bbc0 - 0001b7bbe7]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #23 [0001b7bc00 - 0001b7bd34]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #24 [0001b7bd40 - 0001b7bd80]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #25 [0001b7bd80 - 0001b7bdc0]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #26 [0001b7bdc0 - 0001b7be00]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #27 [0001b7be00 - 0001b7be40]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #28 [0001b7be40 - 0001b7be80]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #29 [0001b7be80 - 0001b7bec0]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #30 [0001b7bec0 - 0001b7bf00]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #31 [0001b7bf00 - 0001b7bf40]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #32 [0001b7bf40 - 0001b7bf80]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #33 [0001b7bf80 - 0001b7bfc0]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #34 [0001b7bfc0 - 0001b7bfd0]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #35 [0001b84140 - 0001b84191]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #36 [0001b841c0 - 0001b84211]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #37 [0002c00000 - 0002c0e000]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #38 [0002d00000 - 0002d0e000]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #39 [0002e00000 - 0002e0e000]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #40 [0002f00000 - 0002f0e000]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #41 [0001b84240 - 0001b84244]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #42 [0001b84280 - 0001b84284]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #43 [0001b842c0 - 0001b842d0]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #44 [0001b84300 - 0001b84310]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #45 [0001b84340 - 0001b843e0]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #46 [0001b84400 - 0001b84448]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #47 [0002b91000 - 0002b95000]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #48 [0002c0e000 - 0002c8e000]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #49 [0002b95000 - 0002bd5000]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000]   #50 [0002f0e000 - 0003903880]         BOOTMEM
Aug 17 15:23:48 localhost kernel: [    0.000000] Initializing HighMem for node 0 (000377fe:0007f7b0)
Aug 17 15:23:48 localhost kernel: [    0.000000] Memory: 2043832k/2088640k available (3424k kernel code, 44356k reserved, 2169k data, 432k init, 1179336k highmem)
Aug 17 15:23:48 localhost kernel: [    0.000000] virtual kernel memory layout:
Aug 17 15:23:48 localhost kernel: [    0.000000]     fixmap  : 0xfff66000 - 0xfffff000   ( 612 kB)
Aug 17 15:23:48 localhost kernel: [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Aug 17 15:23:48 localhost kernel: [    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
Aug 17 15:23:48 localhost kernel: [    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
Aug 17 15:23:48 localhost kernel: [    0.000000]       .init : 0xc1577000 - 0xc15e3000   ( 432 kB)
Aug 17 15:23:48 localhost kernel: [    0.000000]       .data : 0xc1358373 - 0xc157687c   (2169 kB)
Aug 17 15:23:48 localhost kernel: [    0.000000]       .text : 0xc1000000 - 0xc1358373   (3424 kB)
Aug 17 15:23:48 localhost kernel: [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
Aug 17 15:23:48 localhost kernel: [    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Aug 17 15:23:48 localhost kernel: [    0.000000] Hierarchical RCU implementation.
Aug 17 15:23:48 localhost kernel: [    0.000000] 	Verbose stalled-CPUs detection is disabled.
Aug 17 15:23:48 localhost kernel: [    0.000000] NR_IRQS:2304 nr_irqs:712
Aug 17 15:23:48 localhost kernel: [    0.000000] Console: colour VGA+ 80x25
Aug 17 15:23:48 localhost kernel: [    0.000000] console [tty0] enabled
Aug 17 15:23:48 localhost kernel: [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
Aug 17 15:23:48 localhost kernel: [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
Aug 17 15:23:48 localhost kernel: [    0.000000] ... MAX_LOCK_DEPTH:          48
Aug 17 15:23:48 localhost kernel: [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
Aug 17 15:23:48 localhost kernel: [    0.000000] ... CLASSHASH_SIZE:          4096
Aug 17 15:23:48 localhost kernel: [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
Aug 17 15:23:48 localhost kernel: [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
Aug 17 15:23:48 localhost kernel: [    0.000000] ... CHAINHASH_SIZE:          16384
Aug 17 15:23:48 localhost kernel: [    0.000000]  memory used by lock dependency info: 3567 kB
Aug 17 15:23:48 localhost kernel: [    0.000000]  per task-struct memory footprint: 1152 bytes
Aug 17 15:23:48 localhost kernel: [    0.000000] Fast TSC calibration using PIT
Aug 17 15:23:48 localhost kernel: [    0.000000] Detected 2492.703 MHz processor.
Aug 17 15:23:48 localhost kernel: [    0.001009] Calibrating delay loop (skipped), value calculated using timer frequency.. 4985.40 BogoMIPS (lpj=2492703)
Aug 17 15:23:48 localhost kernel: [    0.001177] pid_max: default: 32768 minimum: 301
Aug 17 15:23:48 localhost kernel: [    0.001310] Security Framework initialized
Aug 17 15:23:48 localhost kernel: [    0.001402] SELinux:  Initializing.
Aug 17 15:23:48 localhost kernel: [    0.001553] Mount-cache hash table entries: 512
Aug 17 15:23:48 localhost kernel: [    0.002726] Initializing cgroup subsys ns
Aug 17 15:23:48 localhost kernel: [    0.002813] Initializing cgroup subsys cpuacct
Aug 17 15:23:48 localhost kernel: [    0.002902] Initializing cgroup subsys memory
Aug 17 15:23:48 localhost kernel: [    0.003021] Initializing cgroup subsys devices
Aug 17 15:23:48 localhost kernel: [    0.003105] Initializing cgroup subsys freezer
Aug 17 15:23:48 localhost kernel: [    0.003188] Initializing cgroup subsys blkio
Aug 17 15:23:48 localhost kernel: [    0.003328] CPU: Physical Processor ID: 0
Aug 17 15:23:48 localhost kernel: [    0.003410] CPU: Processor Core ID: 0
Aug 17 15:23:48 localhost kernel: [    0.003493] mce: CPU supports 6 MCE banks
Aug 17 15:23:48 localhost kernel: [    0.003580] CPU0: Thermal monitoring enabled (TM2)
Aug 17 15:23:48 localhost kernel: [    0.003665] using mwait in idle threads.
Aug 17 15:23:48 localhost kernel: [    0.003752] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
Aug 17 15:23:48 localhost kernel: [    0.003913] ... version:                2
Aug 17 15:23:48 localhost kernel: [    0.004004] ... bit width:              40
Aug 17 15:23:48 localhost kernel: [    0.004085] ... generic registers:      2
Aug 17 15:23:48 localhost kernel: [    0.005003] ... value mask:             000000ffffffffff
Aug 17 15:23:48 localhost kernel: [    0.006003] ... max period:             000000007fffffff
Aug 17 15:23:48 localhost kernel: [    0.006086] ... fixed-purpose events:   3
Aug 17 15:23:48 localhost kernel: [    0.006167] ... event mask:             0000000700000003
Aug 17 15:23:48 localhost kernel: [    0.007649] ACPI: Core revision 20100428
Aug 17 15:23:48 localhost kernel: [    0.015041] Enabling APIC mode:  Flat.  Using 1 I/O APICs
Aug 17 15:23:48 localhost kernel: [    0.015464] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Aug 17 15:23:48 localhost kernel: [    0.025551] CPU0: Intel Pentium(R) Dual-Core  CPU      E5200  @ 2.50GHz stepping 06
Aug 17 15:23:48 localhost kernel: [    0.025999] lockdep: fixing up alternatives.
Aug 17 15:23:48 localhost kernel: [    0.025999] Booting Node   0, Processors  #1
Aug 17 15:23:48 localhost kernel: [    0.001999] Initializing CPU#1
Aug 17 15:23:48 localhost kernel: [    0.097049] Brought up 2 CPUs
Aug 17 15:23:48 localhost kernel: [    0.097292] Total of 2 processors activated (9971.45 BogoMIPS).
Aug 17 15:23:48 localhost kernel: [    0.099085] regulator: core version 0.5
Aug 17 15:23:48 localhost kernel: [    0.099132] Time: 13:22:52  Date: 08/17/10
Aug 17 15:23:48 localhost kernel: [    0.099272] NET: Registered protocol family 16
Aug 17 15:23:48 localhost kernel: [    0.100091] ACPI: bus type pci registered
Aug 17 15:23:48 localhost kernel: [    0.101052] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Aug 17 15:23:48 localhost kernel: [    0.101200] PCI: Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub with MMCONFIG support
Aug 17 15:23:48 localhost kernel: [    0.101200] PCI: not using MMCONFIG
Aug 17 15:23:48 localhost kernel: [    0.101416] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3
Aug 17 15:23:48 localhost kernel: [    0.101501] PCI: Using configuration type 1 for base access
Aug 17 15:23:48 localhost kernel: [    0.107088] bio: create slab <bio-0> at 0
Aug 17 15:23:48 localhost kernel: [    0.114190] ACPI: Executed 1 blocks of module-level executable AML code
Aug 17 15:23:48 localhost kernel: [    0.121449] ACPI: SSDT 7f7c0090 00277 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
Aug 17 15:23:48 localhost kernel: [    0.122422] ACPI: Dynamic OEM Table Load:
Aug 17 15:23:48 localhost kernel: [    0.122543] ACPI: SSDT (null) 00277 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
Aug 17 15:23:48 localhost kernel: [    0.123336] ACPI: SSDT 7f7c0520 00277 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
Aug 17 15:23:48 localhost kernel: [    0.124309] ACPI: Dynamic OEM Table Load:
Aug 17 15:23:48 localhost kernel: [    0.124431] ACPI: SSDT (null) 00277 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
Aug 17 15:23:48 localhost kernel: [    0.124729] ACPI: Interpreter enabled
Aug 17 15:23:48 localhost kernel: [    0.124813] ACPI: (supports S0 S1 S3 S4 S5)
Aug 17 15:23:48 localhost kernel: [    0.125007] ACPI: Using IOAPIC for interrupt routing
Aug 17 15:23:48 localhost kernel: [    0.142069] ACPI: No dock devices found.
Aug 17 15:23:48 localhost kernel: [    0.142154] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Aug 17 15:23:48 localhost kernel: [    0.142751] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
Aug 17 15:23:48 localhost kernel: [    0.143300] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
Aug 17 15:23:48 localhost kernel: [    0.143387] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
Aug 17 15:23:48 localhost kernel: [    0.143473] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
Aug 17 15:23:48 localhost kernel: [    0.143615] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
Aug 17 15:23:48 localhost kernel: [    0.143760] pci_root PNP0A08:00: host bridge window [mem 0x7f800000-0xffffffff]
Aug 17 15:23:48 localhost kernel: [    0.145028] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
Aug 17 15:23:48 localhost kernel: [    0.145173] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
Aug 17 15:23:48 localhost kernel: [    0.145260] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0280 (mask 00ff)
Aug 17 15:23:48 localhost kernel: [    0.145762] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
Aug 17 15:23:48 localhost kernel: [    0.148046] pci 0000:00:1c.1: PCI bridge to [bus 01-01]
Aug 17 15:23:48 localhost kernel: [    0.148227] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
Aug 17 15:23:48 localhost kernel: [    0.165166] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
Aug 17 15:23:48 localhost kernel: [    0.165620] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
Aug 17 15:23:48 localhost kernel: [    0.166136] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
Aug 17 15:23:48 localhost kernel: [    0.166590] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
Aug 17 15:23:48 localhost kernel: [    0.167113] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Aug 17 15:23:48 localhost kernel: [    0.167665] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Aug 17 15:23:48 localhost kernel: [    0.168207] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Aug 17 15:23:48 localhost kernel: [    0.168757] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 *15)
Aug 17 15:23:48 localhost kernel: [    0.169156] HEST: Table is not found!
Aug 17 15:23:48 localhost kernel: [    0.169156] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
Aug 17 15:23:48 localhost kernel: [    0.169228] vgaarb: loaded
Aug 17 15:23:48 localhost kernel: [    0.170059] SCSI subsystem initialized
Aug 17 15:23:48 localhost kernel: [    0.170131] usbcore: registered new interface driver usbfs
Aug 17 15:23:48 localhost kernel: [    0.170149] usbcore: registered new interface driver hub
Aug 17 15:23:48 localhost kernel: [    0.170149] usbcore: registered new device driver usb
Aug 17 15:23:48 localhost kernel: [    0.171068] PCI: Using ACPI for IRQ routing
Aug 17 15:23:48 localhost kernel: [    0.171261] NetLabel: Initializing
Aug 17 15:23:48 localhost kernel: [    0.172033] NetLabel:  domain hash size = 128
Aug 17 15:23:48 localhost kernel: [    0.172115] NetLabel:  protocols = UNLABELED CIPSOv4
Aug 17 15:23:48 localhost kernel: [    0.172246] NetLabel:  unlabeled traffic allowed by default
Aug 17 15:23:48 localhost kernel: [    0.172334] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Aug 17 15:23:48 localhost kernel: [    0.172423] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Aug 17 15:23:48 localhost kernel: [    0.172586] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Aug 17 15:23:48 localhost kernel: [    0.175072] Switching to clocksource tsc
Aug 17 15:23:48 localhost kernel: [    0.182721] pnp: PnP ACPI init
Aug 17 15:23:48 localhost kernel: [    0.182837] ACPI: bus type pnp registered
Aug 17 15:23:48 localhost kernel: [    0.189333] pnp: PnP ACPI: found 18 devices
Aug 17 15:23:48 localhost kernel: [    0.189416] ACPI: ACPI bus type pnp unregistered
Aug 17 15:23:48 localhost kernel: [    0.189501] PnPBIOS: Disabled by ACPI PNP
Aug 17 15:23:48 localhost kernel: [    0.189604] system 00:01: [mem 0xfed13000-0xfed19fff] has been reserved
Aug 17 15:23:48 localhost kernel: [    0.189703] system 00:07: [io  0x04d0-0x04d1] has been reserved
Aug 17 15:23:48 localhost kernel: [    0.189793] system 00:07: [io  0x0800-0x087f] has been reserved
Aug 17 15:23:48 localhost kernel: [    0.189875] system 00:07: [io  0x0480-0x04bf] has been reserved
Aug 17 15:23:48 localhost kernel: [    0.189958] system 00:07: [io  0x0900-0x090f] has been reserved
Aug 17 15:23:48 localhost kernel: [    0.190040] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
Aug 17 15:23:48 localhost kernel: [    0.190123] system 00:07: [mem 0xfed20000-0xfed8ffff] has been reserved
Aug 17 15:23:48 localhost kernel: [    0.190215] system 00:0a: [mem 0xffc00000-0xfff7ffff] has been reserved
Aug 17 15:23:48 localhost kernel: [    0.190305] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
Aug 17 15:23:48 localhost kernel: [    0.190389] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
Aug 17 15:23:48 localhost kernel: [    0.190480] system 00:0f: [io  0x0290-0x029f] has been reserved
Aug 17 15:23:48 localhost kernel: [    0.190569] system 00:10: [mem 0xe0000000-0xefffffff] has been reserved
Aug 17 15:23:48 localhost kernel: [    0.190660] system 00:11: [mem 0x00000000-0x0009ffff] could not be reserved
Aug 17 15:23:48 localhost kernel: [    0.190786] system 00:11: [mem 0x000c0000-0x000cffff] could not be reserved
Aug 17 15:23:48 localhost kernel: [    0.190871] system 00:11: [mem 0x000e0000-0x000fffff] could not be reserved
Aug 17 15:23:48 localhost kernel: [    0.190955] system 00:11: [mem 0x00100000-0x7f7fffff] could not be reserved
Aug 17 15:23:48 localhost kernel: [    0.226567] pci 0000:00:1c.0: BAR 14: assigned [mem 0x7f800000-0x7fbfffff]
Aug 17 15:23:48 localhost kernel: [    0.226655] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
Aug 17 15:23:48 localhost kernel: [    0.226765] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
Aug 17 15:23:48 localhost kernel: [    0.226851] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
Aug 17 15:23:48 localhost kernel: [    0.226940] pci 0000:00:1c.0:   bridge window [mem 0x7f800000-0x7fbfffff]
Aug 17 15:23:48 localhost kernel: [    0.227028] pci 0000:00:1c.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
Aug 17 15:23:48 localhost kernel: [    0.227175] pci 0000:00:1c.1: PCI bridge to [bus 01-01]
Aug 17 15:23:48 localhost kernel: [    0.227260] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
Aug 17 15:23:48 localhost kernel: [    0.227349] pci 0000:00:1c.1:   bridge window [mem 0xfeb00000-0xfebfffff]
Aug 17 15:23:48 localhost kernel: [    0.227437] pci 0000:00:1c.1:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
Aug 17 15:23:48 localhost kernel: [    0.227586] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
Aug 17 15:23:48 localhost kernel: [    0.227670] pci 0000:00:1e.0:   bridge window [io  disabled]
Aug 17 15:23:48 localhost kernel: [    0.227763] pci 0000:00:1e.0:   bridge window [mem disabled]
Aug 17 15:23:48 localhost kernel: [    0.227850] pci 0000:00:1e.0:   bridge window [mem pref disabled]
Aug 17 15:23:48 localhost kernel: [    0.227948] pci 0000:00:1c.0: enabling device (0106 -> 0107)
Aug 17 15:23:48 localhost kernel: [    0.228052] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Aug 17 15:23:48 localhost kernel: [    0.228160] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Aug 17 15:23:48 localhost kernel: [    0.228332] NET: Registered protocol family 2
Aug 17 15:23:48 localhost kernel: [    0.228519] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Aug 17 15:23:48 localhost kernel: [    0.228932] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Aug 17 15:23:48 localhost kernel: [    0.229695] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
Aug 17 15:23:48 localhost kernel: [    0.234306] TCP: Hash tables configured (established 131072 bind 65536)
Aug 17 15:23:48 localhost kernel: [    0.234463] TCP reno registered
Aug 17 15:23:48 localhost kernel: [    0.234566] UDP hash table entries: 512 (order: 3, 40960 bytes)
Aug 17 15:23:48 localhost kernel: [    0.234751] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
Aug 17 15:23:48 localhost kernel: [    0.235124] NET: Registered protocol family 1
Aug 17 15:23:48 localhost kernel: [    0.235617] Trying to unpack rootfs image as initramfs...
Aug 17 15:23:48 localhost kernel: [    0.337770] debug: unmapping init memory c01d6000..c05c9000
Aug 17 15:23:48 localhost kernel: [    0.340433] audit: initializing netlink socket (disabled)
Aug 17 15:23:48 localhost kernel: [    0.340556] type=2000 audit(1282051371.338:1): initialized
Aug 17 15:23:48 localhost kernel: [    0.355419] highmem bounce pool size: 64 pages
Aug 17 15:23:48 localhost kernel: [    0.355509] HugeTLB registered 4 MB page size, pre-allocated 0 pages
Aug 17 15:23:48 localhost kernel: [    0.361301] VFS: Disk quotas dquot_6.5.2
Aug 17 15:23:48 localhost kernel: [    0.361507] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Aug 17 15:23:48 localhost kernel: [    0.363280] msgmni has been set to 1688
Aug 17 15:23:48 localhost kernel: [    0.364381] alg: No test for stdrng (krng)
Aug 17 15:23:48 localhost kernel: [    0.364650] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Aug 17 15:23:48 localhost kernel: [    0.364813] io scheduler noop registered
Aug 17 15:23:48 localhost kernel: [    0.364897] io scheduler deadline registered
Aug 17 15:23:48 localhost kernel: [    0.364993] io scheduler cfq registered (default)
Aug 17 15:23:48 localhost kernel: [    0.366983] ERST: Table is not found!
Aug 17 15:23:48 localhost kernel: [    0.367078] isapnp: Scanning for PnP cards...
Aug 17 15:23:48 localhost kernel: [    0.723692] isapnp: No Plug & Play device found
Aug 17 15:23:48 localhost kernel: [    0.730391] Non-volatile memory driver v1.3
Aug 17 15:23:48 localhost kernel: [    0.730575] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Aug 17 15:23:48 localhost kernel: [    0.974933] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Aug 17 15:23:48 localhost kernel: [    0.976078] 00:0e: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Aug 17 15:23:48 localhost kernel: [    0.980430] brd: module loaded
Aug 17 15:23:48 localhost kernel: [    0.980516] Uniform Multi-Platform E-IDE driver
Aug 17 15:23:48 localhost kernel: [    0.980914] ide-gd driver 1.18
Aug 17 15:23:48 localhost kernel: [    0.981556] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Aug 17 15:23:48 localhost kernel: [    0.981957] scsi0 : ata_piix
Aug 17 15:23:48 localhost kernel: [    0.982378] scsi1 : ata_piix
Aug 17 15:23:48 localhost kernel: [    0.985344] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
Aug 17 15:23:48 localhost kernel: [    0.985431] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
Aug 17 15:23:48 localhost kernel: [    0.985577] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Aug 17 15:23:48 localhost kernel: [    0.985677] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
Aug 17 15:23:48 localhost kernel: [    0.986052] scsi2 : ata_piix
Aug 17 15:23:48 localhost kernel: [    0.986353] scsi3 : ata_piix
Aug 17 15:23:48 localhost kernel: [    0.986630] ata3: SATA max UDMA/133 cmd 0xd080 ctl 0xd000 bmdma 0xc800 irq 19
Aug 17 15:23:48 localhost kernel: [    0.986717] ata4: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc808 irq 19
Aug 17 15:23:48 localhost kernel: [    0.987134] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Aug 17 15:23:48 localhost kernel: [    0.987313] uhci_hcd: USB Universal Host Controller Interface driver
Aug 17 15:23:48 localhost kernel: [    0.987446] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Aug 17 15:23:48 localhost kernel: [    0.987542] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Aug 17 15:23:48 localhost kernel: [    0.988287] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
Aug 17 15:23:48 localhost kernel: [    0.990189] uhci_hcd 0000:00:1d.0: detected 2 ports
Aug 17 15:23:48 localhost kernel: [    0.990312] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d400
Aug 17 15:23:48 localhost kernel: [    0.990601] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
Aug 17 15:23:48 localhost kernel: [    0.990687] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug 17 15:23:48 localhost kernel: [    0.990837] usb usb1: Product: UHCI Host Controller
Aug 17 15:23:48 localhost kernel: [    0.990920] usb usb1: Manufacturer: Linux 2.6.35v1 uhci_hcd
Aug 17 15:23:48 localhost kernel: [    0.991004] usb usb1: SerialNumber: 0000:00:1d.0
Aug 17 15:23:48 localhost kernel: [    0.991602] hub 1-0:1.0: USB hub found
Aug 17 15:23:48 localhost kernel: [    0.991733] hub 1-0:1.0: 2 ports detected
Aug 17 15:23:48 localhost kernel: [    0.992100] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Aug 17 15:23:48 localhost kernel: [    0.992195] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Aug 17 15:23:48 localhost kernel: [    0.992452] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
Aug 17 15:23:48 localhost kernel: [    0.992601] uhci_hcd 0000:00:1d.1: detected 2 ports
Aug 17 15:23:48 localhost kernel: [    0.992710] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d480
Aug 17 15:23:48 localhost kernel: [    0.992891] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
Aug 17 15:23:48 localhost kernel: [    0.992977] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug 17 15:23:48 localhost kernel: [    0.993119] usb usb2: Product: UHCI Host Controller
Aug 17 15:23:48 localhost kernel: [    0.993202] usb usb2: Manufacturer: Linux 2.6.35v1 uhci_hcd
Aug 17 15:23:48 localhost kernel: [    0.993286] usb usb2: SerialNumber: 0000:00:1d.1
Aug 17 15:23:48 localhost kernel: [    0.993641] hub 2-0:1.0: USB hub found
Aug 17 15:23:48 localhost kernel: [    0.993729] hub 2-0:1.0: 2 ports detected
Aug 17 15:23:48 localhost kernel: [    0.993983] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Aug 17 15:23:48 localhost kernel: [    0.994078] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Aug 17 15:23:48 localhost kernel: [    0.994302] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
Aug 17 15:23:48 localhost kernel: [    0.994450] uhci_hcd 0000:00:1d.2: detected 2 ports
Aug 17 15:23:48 localhost kernel: [    0.994575] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d800
Aug 17 15:23:48 localhost kernel: [    0.994735] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Aug 17 15:23:48 localhost kernel: [    0.994835] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug 17 15:23:48 localhost kernel: [    0.994978] usb usb3: Product: UHCI Host Controller
Aug 17 15:23:48 localhost kernel: [    0.995060] usb usb3: Manufacturer: Linux 2.6.35v1 uhci_hcd
Aug 17 15:23:48 localhost kernel: [    0.995144] usb usb3: SerialNumber: 0000:00:1d.2
Aug 17 15:23:48 localhost kernel: [    0.995509] hub 3-0:1.0: USB hub found
Aug 17 15:23:48 localhost kernel: [    0.995597] hub 3-0:1.0: 2 ports detected
Aug 17 15:23:48 localhost kernel: [    0.995854] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
Aug 17 15:23:48 localhost kernel: [    0.995949] uhci_hcd 0000:00:1d.3: UHCI Host Controller
Aug 17 15:23:48 localhost kernel: [    0.996169] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
Aug 17 15:23:48 localhost kernel: [    0.996318] uhci_hcd 0000:00:1d.3: detected 2 ports
Aug 17 15:23:48 localhost kernel: [    0.996449] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d880
Aug 17 15:23:48 localhost kernel: [    0.996605] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
Aug 17 15:23:48 localhost kernel: [    0.996691] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug 17 15:23:48 localhost kernel: [    0.996853] usb usb4: Product: UHCI Host Controller
Aug 17 15:23:48 localhost kernel: [    0.996936] usb usb4: Manufacturer: Linux 2.6.35v1 uhci_hcd
Aug 17 15:23:48 localhost kernel: [    0.997020] usb usb4: SerialNumber: 0000:00:1d.3
Aug 17 15:23:48 localhost kernel: [    0.997377] hub 4-0:1.0: USB hub found
Aug 17 15:23:48 localhost kernel: [    0.997466] hub 4-0:1.0: 2 ports detected
Aug 17 15:23:48 localhost kernel: [    0.997934] usbcore: registered new interface driver libusual
Aug 17 15:23:48 localhost kernel: [    0.998214] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
Aug 17 15:23:48 localhost kernel: [    1.001331] serio: i8042 KBD port at 0x60,0x64 irq 1
Aug 17 15:23:48 localhost kernel: [    1.001438] serio: i8042 AUX port at 0x60,0x64 irq 12
Aug 17 15:23:48 localhost kernel: [    1.001853] mice: PS/2 mouse device common for all mice
Aug 17 15:23:48 localhost kernel: [    1.002042] cpuidle: using governor ladder
Aug 17 15:23:48 localhost kernel: [    1.002129] cpuidle: using governor menu
Aug 17 15:23:48 localhost kernel: [    1.002574] usbcore: registered new interface driver hiddev
Aug 17 15:23:48 localhost kernel: [    1.002732] usbcore: registered new interface driver usbhid
Aug 17 15:23:48 localhost kernel: [    1.002816] usbhid: USB HID core driver
Aug 17 15:23:48 localhost kernel: [    1.003139] NET: Registered protocol family 17
Aug 17 15:23:48 localhost kernel: [    1.003254] NET: Registered protocol family 15
Aug 17 15:23:48 localhost kernel: [    1.003370] Using IPI No-Shortcut mode
Aug 17 15:23:48 localhost kernel: [    1.003778] registered taskstats version 1
Aug 17 15:23:48 localhost kernel: [    1.003859] IMA: No TPM chip found, activating TPM-bypass!
Aug 17 15:23:48 localhost kernel: [    1.004424]   Magic number: 6:490:382
Aug 17 15:23:48 localhost kernel: [    1.022112] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
Aug 17 15:23:48 localhost kernel: [    1.141432] ata3.00: ATA-8: ExcelStor Technology J9250S, GM2OA52A, max UDMA/133
Aug 17 15:23:48 localhost kernel: [    1.141576] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
Aug 17 15:23:48 localhost kernel: [    1.142532] ata1.00: ATA-5: IC35L060AVER07-0, ER6OA46A, max UDMA/100
Aug 17 15:23:48 localhost kernel: [    1.142618] ata1.00: 120103200 sectors, multi 16: LBA 
Aug 17 15:23:48 localhost kernel: [    1.144251] ata4.00: ATAPI: ATAPI   iHAS322   8, 3L13, max UDMA/100
Aug 17 15:23:48 localhost kernel: [    1.145316] ata3.00: configured for UDMA/133
Aug 17 15:23:48 localhost kernel: [    1.148246] ata4.00: configured for UDMA/100
Aug 17 15:23:48 localhost kernel: [    1.151441] ata1.00: configured for UDMA/100
Aug 17 15:23:48 localhost kernel: [    1.151935] scsi 0:0:0:0: Direct-Access     ATA      IC35L060AVER07-0 ER6O PQ: 0 ANSI: 5
Aug 17 15:23:48 localhost kernel: [    1.153033] sd 0:0:0:0: Attached scsi generic sg0 type 0
Aug 17 15:23:48 localhost kernel: [    1.153315] sd 0:0:0:0: [sda] 120103200 512-byte logical blocks: (61.4 GB/57.2 GiB)
Aug 17 15:23:48 localhost kernel: [    1.153638] scsi 2:0:0:0: Direct-Access     ATA      ExcelStor Techno GM2O PQ: 0 ANSI: 5
Aug 17 15:23:48 localhost kernel: [    1.153640] sd 0:0:0:0: [sda] Write Protect is off
Aug 17 15:23:48 localhost kernel: [    1.153686] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 17 15:23:48 localhost kernel: [    1.154063]  sda:
Aug 17 15:23:48 localhost kernel: [    1.154506] sd 2:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB/232 GiB)
Aug 17 15:23:48 localhost kernel: [    1.154798] sd 2:0:0:0: [sdb] Write Protect is off
Aug 17 15:23:48 localhost kernel: [    1.154802] sd 2:0:0:0: Attached scsi generic sg1 type 0
Aug 17 15:23:48 localhost kernel: [    1.155049] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 17 15:23:48 localhost kernel: [    1.155572]  sdb:
Aug 17 15:23:48 localhost kernel: [    1.156445] scsi 3:0:0:0: CD-ROM            ATAPI    iHAS322   8      3L13 PQ: 0 ANSI: 5
Aug 17 15:23:48 localhost kernel: [    1.162187]  sda1 sda2 sda3 sda4 <sr0: scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
Aug 17 15:23:48 localhost kernel: [    1.163675] Uniform CD-ROM driver Revision: 3.20
Aug 17 15:23:48 localhost kernel: [    1.164173]  sdb1 sdb2
Aug 17 15:23:48 localhost kernel: [    1.164662] sr 3:0:0:0: Attached scsi generic sg2 type 5
Aug 17 15:23:48 localhost kernel: [    1.165246] sd 2:0:0:0: [sdb] Attached SCSI disk
Aug 17 15:23:48 localhost kernel: [    1.176559]  sda5 sda6 sda7
Aug 17 15:23:48 localhost kernel: [    1.202214]  sda8 sda9 >
Aug 17 15:23:48 localhost kernel: [    1.210081] sd 0:0:0:0: [sda] Attached SCSI disk
Aug 17 15:23:48 localhost kernel: [    1.210177] debug: unmapping init memory c1577000..c15e3000
Aug 17 15:23:48 localhost kernel: [    1.210333] Write protecting the kernel text: 3428k
Aug 17 15:23:48 localhost kernel: [    1.210440] Write protecting the kernel read-only data: 1864k
Aug 17 15:23:48 localhost kernel: [    1.296022] usb 2-1: new full speed USB device using uhci_hcd and address 2
Aug 17 15:23:48 localhost kernel: [    1.444955] usb 2-1: New USB device found, idVendor=19d2, idProduct=0063
Aug 17 15:23:48 localhost kernel: [    1.445048] usb 2-1: New USB device strings: Mfr=2, Product=1, SerialNumber=0
Aug 17 15:23:48 localhost kernel: [    1.445135] usb 2-1: Product: ZTE CDMA Technologies MSM
Aug 17 15:23:48 localhost kernel: [    1.445219] usb 2-1: Manufacturer: ZTE,Incorporated
Aug 17 15:23:48 localhost kernel: [    2.277422] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Aug 17 15:23:48 localhost kernel: [    2.277509] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
Aug 17 15:23:48 localhost kernel: [    2.277715] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Aug 17 15:23:48 localhost kernel: [    2.277822] ehci_hcd 0000:00:1d.7: EHCI Host Controller
Aug 17 15:23:48 localhost kernel: [    2.278053] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
Aug 17 15:23:48 localhost kernel: [    2.278236] ehci_hcd 0000:00:1d.7: using broken periodic workaround
Aug 17 15:23:48 localhost kernel: [    2.278331] ehci_hcd 0000:00:1d.7: debug port 1
Aug 17 15:23:48 localhost kernel: [    2.282320] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfea37c00
Aug 17 15:23:48 localhost kernel: [    2.292016] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
Aug 17 15:23:48 localhost kernel: [    2.292191] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Aug 17 15:23:48 localhost kernel: [    2.292277] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug 17 15:23:48 localhost kernel: [    2.292418] usb usb5: Product: EHCI Host Controller
Aug 17 15:23:48 localhost kernel: [    2.292501] usb usb5: Manufacturer: Linux 2.6.35v1 ehci_hcd
Aug 17 15:23:48 localhost kernel: [    2.292585] usb usb5: SerialNumber: 0000:00:1d.7
Aug 17 15:23:48 localhost kernel: [    2.292905] hub 5-0:1.0: USB hub found
Aug 17 15:23:48 localhost kernel: [    2.292996] hub 5-0:1.0: 8 ports detected
Aug 17 15:23:48 localhost kernel: [    2.454108] usb 2-1: USB disconnect, address 2
Aug 17 15:23:48 localhost kernel: [    2.662020] usb 5-3: new high speed USB device using ehci_hcd and address 2
Aug 17 15:23:48 localhost kernel: [    2.788188] usb 5-3: New USB device found, idVendor=19d2, idProduct=0063
Aug 17 15:23:48 localhost kernel: [    2.788275] usb 5-3: New USB device strings: Mfr=2, Product=1, SerialNumber=0
Aug 17 15:23:48 localhost kernel: [    2.788362] usb 5-3: Product: ZTE CDMA Technologies MSM
Aug 17 15:23:48 localhost kernel: [    2.788446] usb 5-3: Manufacturer: ZTE,Incorporated
Aug 17 15:23:48 localhost kernel: [    2.858714] device-mapper: uevent: version 1.0.3
Aug 17 15:23:48 localhost kernel: [    2.859045] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
Aug 17 15:23:48 localhost kernel: [    2.877493] padlock: VIA PadLock not detected.
Aug 17 15:23:48 localhost kernel: [   15.718888] EXT3-fs: barriers not enabled
Aug 17 15:23:48 localhost kernel: [   15.725049] kjournald starting.  Commit interval 5 seconds
Aug 17 15:23:48 localhost kernel: [   15.725305] EXT3-fs (dm-6): mounted filesystem with ordered data mode
Aug 17 15:23:48 localhost kernel: [   15.871100] SELinux:  Disabled at runtime.
Aug 17 15:23:48 localhost kernel: [   15.884014] type=1404 audit(1282051386.883:2): selinux=0 auid=4294967295 ses=4294967295
Aug 17 15:23:48 localhost kernel: [   18.963309] udev: starting version 145
Aug 17 15:23:48 localhost kernel: [   20.869129] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
Aug 17 15:23:48 localhost kernel: [   20.869254] ACPI: Power Button [PWRB]
Aug 17 15:23:48 localhost kernel: [   20.869354] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
Aug 17 15:23:48 localhost kernel: [   20.869399] ACPI: Power Button [PWRF]
Aug 17 15:23:48 localhost kernel: [   21.605321] parport_pc 00:06: reported by Plug and Play ACPI
Aug 17 15:23:48 localhost kernel: [   21.605464] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
Aug 17 15:23:48 localhost kernel: [   21.687142] rtc_cmos 00:03: RTC can wake from S4
Aug 17 15:23:48 localhost kernel: [   21.687340] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Aug 17 15:23:48 localhost kernel: [   21.687385] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
Aug 17 15:23:48 localhost kernel: [   22.024947] input: PC Speaker as /devices/platform/pcspkr/input/input3
Aug 17 15:23:48 localhost kernel: [   22.207691] ppdev: user-space parallel port driver
Aug 17 15:23:48 localhost kernel: [   22.462607] leds_ss4200: no LED devices found
Aug 17 15:23:48 localhost kernel: [   22.482779] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
Aug 17 15:23:48 localhost kernel: [   22.482805] r8169 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Aug 17 15:23:48 localhost kernel: [   22.483235] r8169 0000:01:00.0: eth0: RTL8102e at 0xf915e000, 00:19:66:a7:72:3c, XID 04a00000 IRQ 42
Aug 17 15:23:48 localhost kernel: [   22.816128] Linux agpgart interface v0.103
Aug 17 15:23:48 localhost kernel: [   22.821053] intel_rng: FWH not detected
Aug 17 15:23:48 localhost kernel: [   23.037445] usbcore: registered new interface driver usbserial
Aug 17 15:23:48 localhost kernel: [   23.037466] USB Serial support registered for generic
Aug 17 15:23:48 localhost kernel: [   23.038697] usbcore: registered new interface driver usbserial_generic
Aug 17 15:23:48 localhost kernel: [   23.038699] usbserial: USB Serial Driver core
Aug 17 15:23:48 localhost kernel: [   23.061415] iTCO_vendor_support: vendor-support=0
Aug 17 15:23:48 localhost kernel: [   23.080067] agpgart-intel 0000:00:00.0: Intel 945G Chipset
Aug 17 15:23:48 localhost kernel: [   23.081395] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
Aug 17 15:23:48 localhost kernel: [   23.084059] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
Aug 17 15:23:48 localhost kernel: [   23.096950] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Aug 17 15:23:48 localhost kernel: [   23.122315] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
Aug 17 15:23:48 localhost kernel: [   23.122500] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0860)
Aug 17 15:23:48 localhost kernel: [   23.122731] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Aug 17 15:23:48 localhost kernel: [   23.122952] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input4
Aug 17 15:23:48 localhost kernel: [   23.399687] USB Serial support registered for GSM modem (1-port)
Aug 17 15:23:48 localhost kernel: [   23.399757] option 5-3:1.0: GSM modem (1-port) converter detected
Aug 17 15:23:48 localhost kernel: [   23.409456] usb 5-3: GSM modem (1-port) converter now attached to ttyUSB0
Aug 17 15:23:48 localhost kernel: [   23.409516] option 5-3:1.1: GSM modem (1-port) converter detected
Aug 17 15:23:48 localhost kernel: [   23.409727] usb 5-3: GSM modem (1-port) converter now attached to ttyUSB1
Aug 17 15:23:48 localhost kernel: [   23.409766] option 5-3:1.2: GSM modem (1-port) converter detected
Aug 17 15:23:48 localhost kernel: [   23.410576] usb 5-3: GSM modem (1-port) converter now attached to ttyUSB2
Aug 17 15:23:48 localhost kernel: [   23.410620] option 5-3:1.3: GSM modem (1-port) converter detected
Aug 17 15:23:48 localhost kernel: [   23.410779] usb 5-3: GSM modem (1-port) converter now attached to ttyUSB3
Aug 17 15:23:48 localhost kernel: [   23.412026] option 5-3:1.4: GSM modem (1-port) converter detected
Aug 17 15:23:48 localhost kernel: [   23.412222] usb 5-3: GSM modem (1-port) converter now attached to ttyUSB4
Aug 17 15:23:48 localhost kernel: [   23.412265] usbcore: registered new interface driver option
Aug 17 15:23:48 localhost kernel: [   23.412267] option: v0.7.2:USB Driver for GSM modems
Aug 17 15:23:48 localhost kernel: [   23.950890] alg: No test for cipher_null (cipher_null-generic)
Aug 17 15:23:48 localhost kernel: [   23.951532] alg: No test for ecb(cipher_null) (ecb-cipher_null)
Aug 17 15:23:48 localhost kernel: [   23.951591] alg: No test for digest_null (digest_null-generic)
Aug 17 15:23:48 localhost kernel: [   23.951641] alg: No test for compress_null (compress_null-generic)
Aug 17 15:23:48 localhost kernel: [   24.503620] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Aug 17 15:23:48 localhost kernel: [   37.989411] device-mapper: multipath: version 1.1.1 loaded
Aug 17 15:23:48 localhost kernel: [   40.607022] EXT3-fs (dm-6): using internal journal
Aug 17 15:23:48 localhost kernel: [   40.779395] EXT3-fs: barriers not enabled
Aug 17 15:23:48 localhost kernel: [   40.779540] kjournald starting.  Commit interval 5 seconds
Aug 17 15:23:48 localhost kernel: [   40.779697] EXT3-fs (sdb1): using internal journal
Aug 17 15:23:48 localhost kernel: [   40.779705] EXT3-fs (sdb1): mounted filesystem with ordered data mode
Aug 17 15:23:48 localhost kernel: [   40.872991] EXT3-fs: barriers not enabled
Aug 17 15:23:48 localhost kernel: [   40.877139] kjournald starting.  Commit interval 5 seconds
Aug 17 15:23:48 localhost kernel: [   40.877173] EXT3-fs (sda9): mounted filesystem with ordered data mode
Aug 17 15:23:48 localhost kernel: [   40.907529] EXT3-fs: barriers not enabled
Aug 17 15:23:48 localhost kernel: [   40.913032] kjournald starting.  Commit interval 5 seconds
Aug 17 15:23:48 localhost kernel: [   40.913058] EXT3-fs (sda1): mounted filesystem with ordered data mode
Aug 17 15:23:48 localhost kernel: [   40.960576] EXT3-fs: barriers not enabled
Aug 17 15:23:48 localhost kernel: [   40.963262] kjournald starting.  Commit interval 5 seconds
Aug 17 15:23:48 localhost kernel: [   40.963291] EXT3-fs (sda2): mounted filesystem with ordered data mode
Aug 17 15:23:48 localhost kernel: [   40.996980] EXT3-fs: barriers not enabled
Aug 17 15:23:48 localhost kernel: [   41.001200] kjournald starting.  Commit interval 5 seconds
Aug 17 15:23:48 localhost kernel: [   41.001228] EXT3-fs (sda5): mounted filesystem with ordered data mode
Aug 17 15:23:48 localhost kernel: [   41.030016] EXT3-fs: barriers not enabled
Aug 17 15:23:48 localhost kernel: [   41.034718] kjournald starting.  Commit interval 5 seconds
Aug 17 15:23:48 localhost kernel: [   41.034747] EXT3-fs (sda6): mounted filesystem with ordered data mode
Aug 17 15:23:48 localhost kernel: [   41.062746] EXT3-fs: barriers not enabled
Aug 17 15:23:48 localhost kernel: [   41.065127] kjournald starting.  Commit interval 5 seconds
Aug 17 15:23:48 localhost kernel: [   41.065315] EXT3-fs (sda3): using internal journal
Aug 17 15:23:48 localhost kernel: [   41.065322] EXT3-fs (sda3): mounted filesystem with ordered data mode
Aug 17 15:23:48 localhost kernel: [   41.454660] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: (null)
Aug 17 15:23:48 localhost kernel: [   41.482911] EXT3-fs: barriers not enabled
Aug 17 15:23:48 localhost kernel: [   41.485209] kjournald starting.  Commit interval 5 seconds
Aug 17 15:23:48 localhost kernel: [   41.493153] EXT3-fs (dm-4): using internal journal
Aug 17 15:23:48 localhost kernel: [   41.493162] EXT3-fs (dm-4): mounted filesystem with ordered data mode
Aug 17 15:23:48 localhost kernel: [   41.544105] EXT4-fs (dm-5): mounted filesystem with ordered data mode. Opts: (null)
Aug 17 15:23:48 localhost kernel: [   46.164903] Adding 4128764k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 extents:1 across:4128764k 
Aug 17 15:23:48 localhost kernel: [   46.182415] Adding 514044k swap on /dev/sda8.  Priority:-2 extents:1 across:514044k 
Aug 17 15:23:48 localhost kernel: [   46.940971] microcode: CPU0 sig=0x10676, pf=0x1, revision=0x60c
Aug 17 15:23:48 localhost kernel: [   46.967879] microcode: CPU1 sig=0x10676, pf=0x1, revision=0x60c
Aug 17 15:23:48 localhost kernel: [   46.972917] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Aug 17 15:23:48 localhost kernel: [   48.172748] microcode: Microcode Update Driver: v2.00 removed.
Aug 17 15:23:48 localhost kernel: [   48.425144] NET: Registered protocol family 10
Aug 17 15:23:48 localhost kernel: [   48.425591] lo: Disabled Privacy Extensions
Aug 17 15:23:48 localhost kernel: [   48.732536] ip_tables: (C) 2000-2006 Netfilter Core Team
Aug 17 15:23:48 localhost kernel: [   49.083376] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Aug 17 15:23:48 localhost kernel: [   49.083990] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
Aug 17 15:23:48 localhost kernel: [   49.083993] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
Aug 17 15:23:48 localhost kernel: [   49.083995] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
Aug 17 15:23:48 localhost kernel: [   49.671317] r8169 0000:01:00.0: eth0: link down
Aug 17 15:23:48 localhost kernel: [   49.671576] ADDRCONF(NETDEV_UP): eth0: link is not ready
Aug 17 15:23:48 localhost rpc.statd[2223]: Version 1.1.4 Starting
Aug 17 15:23:48 localhost kernel: [   56.893678] RPC: Registered udp transport module.
Aug 17 15:23:48 localhost kernel: [   56.893681] RPC: Registered tcp transport module.
Aug 17 15:23:48 localhost kernel: [   56.893683] RPC: Registered tcp NFSv4.1 backchannel transport module.
Aug 17 15:23:50 localhost kernel: [   58.592957] tun: Universal TUN/TAP device driver, 1.6
Aug 17 15:23:50 localhost kernel: [   58.592961] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Aug 17 15:23:50 localhost acpid: starting up
Aug 17 15:23:53 localhost kernel: [   61.111891] w83627ehf: Found W83627EHG chip at 0x290

