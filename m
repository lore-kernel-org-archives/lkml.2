Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab0EJXLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:11:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38973 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab0EJXLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 19:11:15 -0400
Message-ID: <4BE89243.8090809@oracle.com>
Date: Mon, 10 May 2010 16:09:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: BUG: rtc_cmos (2.6.34-rc7)
Content-Type: multipart/mixed;
 boundary="------------070809010500060306020209"
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BE89275.0158:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070809010500060306020209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This happened during a 2.6.34-rc7 boot on a pee-cee.

[   18.314219] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[   18.314229] IP: [<ffffffffa02ea9e9>] cmos_update_irq_enable+0x21/0xa5 [rtc_cmos]
[   18.314243] PGD 7d0b7067 PUD 7dab5067 PMD 0 
[   18.314250] Oops: 0000 [#1] SMP 
[   18.314254] last sysfs file: /sys/class/rtc/rtc0/dev
[   18.314259] CPU 0


Full kernel boot log and config are attached.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

--------------070809010500060306020209
Content-Type: text/plain;
 name="bug1.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bug1.out"

[    0.000000] Linux version 2.6.34-rc7 (rdunlap@control.site) (gcc version 4.4.1 20090725 (Red Hat 4.4.1-2) (GCC) ) #1 SMP Sun May 9 21:22:05 PDT 2010
[    0.000000] Command line: ro root=/dev/sda6 selinux=0 debug ignore_loglevel initcall_debug printk.time=1 print_fatal_signals=1 kern=2634rc7 console=ttyS0,115200n8 console=tty0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f686c00 (usable)
[    0.000000]  BIOS-e820: 000000007f686c00 - 000000007f688c00 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f688c00 - 000000007f68ac00 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f68ac00 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.3 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7f686 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F800000 mask FFF800000 uncachable
[    0.000000]   2 base 07F700000 mask FFFF00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 00000000000a0000 (usable)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007f686c00 (usable)
[    0.000000]  modified: 000000007f686c00 - 000000007f688c00 (ACPI NVS)
[    0.000000]  modified: 000000007f688c00 - 000000007f68ac00 (ACPI data)
[    0.000000]  modified: 000000007f68ac00 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  modified: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000fe710] fe710
[    0.000000] init_memory_mapping: 0000000000000000-000000007f686000
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f686000 page 4k
[    0.000000] kernel direct mapping tables up to 7f686000 @ 16000-1a000
[    0.000000] RAMDISK: 37c13000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000feb00 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000000fd24f 0005C (v01 DELL    GX620   00000007 ASL  00000061)
[    0.000000] ACPI: FACP 00000000000fd347 000F4 (v03 DELL    GX620   00000007 ASL  00000061)
[    0.000000] ACPI: DSDT 00000000fffd32f4 03D69 (v01   DELL    dt_ex 00001000 INTL 20050309)
[    0.000000] ACPI: FACS 000000007f686c00 00040
[    0.000000] ACPI: SSDT 00000000fffd717c 000AA (v01   DELL    st_ex 00001000 INTL 20050309)
[    0.000000] ACPI: APIC 00000000000fd43b 00072 (v01 DELL    GX620   00000007 ASL  00000061)
[    0.000000] ACPI: BOOT 00000000000fd4ad 00028 (v01 DELL    GX620   00000007 ASL  00000061)
[    0.000000] ACPI: ASF! 00000000000fd4d5 00067 (v16 DELL    GX620   00000007 ASL  00000061)
[    0.000000] ACPI: MCFG 00000000000fd53c 0003E (v01 DELL    GX620   00000007 ASL  00000061)
[    0.000000] ACPI: HPET 00000000000fd57a 00038 (v01 DELL    GX620   00000007 ASL  00000061)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007f686000
[    0.000000] Initmem setup node 0 0000000000000000-000000007f686000
[    0.000000]   NODE_DATA [00000000028c5240 - 00000000028d923f]
[    0.000000]   bootmap [00000000028da000 -  00000000028e9ed7] pages 10
[    0.000000] (13/32 early reservations) ==> bootmem [0000000000 - 007f686000]
[    0.000000]   #0 [0001000000 - 00028c4b10]    TEXT DATA BSS ==> [0001000000 - 00028c4b10]
[    0.000000]   #1 [0037c13000 - 0037ff0000]          RAMDISK ==> [0037c13000 - 0037ff0000]
[    0.000000]   #2 [00028c5000 - 00028c521c]              BRK ==> [00028c5000 - 00028c521c]
[    0.000000]   #3 [00000fe720 - 0000100000]    BIOS reserved ==> [00000fe720 - 0000100000]
[    0.000000]   #4 [00000fe710 - 00000fe720]     MP-table mpf ==> [00000fe710 - 00000fe720]
[    0.000000]   #5 [000009fc00 - 00000f0000]    BIOS reserved ==> [000009fc00 - 00000f0000]
[    0.000000]   #6 [00000f0284 - 00000fe710]    BIOS reserved ==> [00000f0284 - 00000fe710]
[    0.000000]   #7 [00000f0000 - 00000f0284]     MP-table mpc ==> [00000f0000 - 00000f0284]
[    0.000000]   #8 [0000010000 - 0000012000]       TRAMPOLINE ==> [0000010000 - 0000012000]
[    0.000000]   #9 [0000012000 - 0000016000]      ACPI WAKEUP ==> [0000012000 - 0000016000]
[    0.000000]   #10 [0000016000 - 0000018000]          PGTABLE ==> [0000016000 - 0000018000]
[    0.000000]   #11 [00028c5240 - 00028d9240]        NODE_DATA ==> [00028c5240 - 00028d9240]
[    0.000000]   #12 [00028da000 - 00028ea000]          BOOTMAP ==> [00028da000 - 00028ea000]
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880003200000-ffff880004dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x0007f686
[    0.000000] On node 0 totalpages: 521750
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 103 pages reserved
[    0.000000]   DMA zone: 3825 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7079 pages used for memmap
[    0.000000]   DMA32 zone: 510687 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:70000000)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff880005400000 s1920232 r8192 d21272 u2097152
[    0.000000] pcpu-alloc: s1920232 r8192 d21272 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 514512
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: ro root=/dev/sda6 selinux=0 debug ignore_loglevel initcall_debug printk.time=1 print_fatal_signals=1 kern=2634rc7 console=ttyS0,115200n8 console=tty0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 2021036k/2087448k available (4471k kernel code, 448k absent, 65964k reserved, 6663k data, 3324k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
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
[    0.000000] Detected 2992.343 MHz processor.
[    0.003010] Calibrating delay loop (skipped), value calculated using timer frequency.. 5984.68 BogoMIPS (lpj=2992343)
[    0.006140] Security Framework initialized
[    0.007560] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.009444] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.011224] Mount-cache hash table entries: 256
[    0.014122] CPU: Physical Processor ID: 0
[    0.015008] CPU: Processor Core ID: 0
[    0.017011] mce: CPU supports 4 MCE banks
[    0.018024] CPU0: Thermal monitoring enabled (TM1)
[    0.019014] using mwait in idle threads.
[    0.020008] Performance Events: no PMU driver, software events only.
[    0.022084] ACPI: Core revision 20100121
[    0.190635] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.191013] ftrace: allocating 15507 entries in 61 pages
[    0.194415] Setting APIC routing to flat
[    0.195504] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.206617] CPU0: Intel(R) Pentium(R) D CPU 3.00GHz stepping 04
[    0.209999] calling  migration_init+0x0/0x7c @ 1
[    0.210217] initcall migration_init+0x0/0x7c returned 0 after 0 usecs
[    0.211008] calling  spawn_ksoftirqd+0x0/0x7d @ 1
[    0.212133] initcall spawn_ksoftirqd+0x0/0x7d returned 0 after 0 usecs
[    0.213010] calling  init_call_single_data+0x0/0xe2 @ 1
[    0.214011] initcall init_call_single_data+0x0/0xe2 returned 0 after 0 usecs
[    0.215007] calling  spawn_softlockup_task+0x0/0xa8 @ 1
[    0.216120] initcall spawn_softlockup_task+0x0/0xa8 returned 0 after 0 usecs
[    0.217007] calling  relay_init+0x0/0x22 @ 1
[    0.218028] initcall relay_init+0x0/0x22 returned 0 after 0 usecs
[    0.219007] calling  tracer_alloc_buffers+0x0/0x2c2 @ 1
[    0.221120] initcall tracer_alloc_buffers+0x0/0x2c2 returned 0 after 976 usecs
[    0.222007] calling  init_trace_printk+0x0/0x20 @ 1
[    0.223007] initcall init_trace_printk+0x0/0x20 returned 0 after 0 usecs
[    0.224007] calling  trace_workqueue_early_init+0x0/0x1a1 @ 1
[    0.225118] initcall trace_workqueue_early_init+0x0/0x1a1 returned 0 after 0 usecs
[    0.227352] lockdep: fixing up alternatives.
[    0.228134] Booting Node   0, Processors  #1
[    0.302083] Brought up 2 CPUs
[    0.303011] Total of 2 processors activated (11969.49 BogoMIPS).
[    0.306336] devtmpfs: initialized
[    0.310375] khelper used greatest stack depth: 6064 bytes left
[    0.317445] gcov: version magic: 0x34303452
[    0.320198] calling  init_mmap_min_addr+0x0/0x1d @ 1
[    0.321010] initcall init_mmap_min_addr+0x0/0x1d returned 0 after 0 usecs
[    0.322010] calling  init_cpufreq_transition_notifier_list+0x0/0x29 @ 1
[    0.323020] initcall init_cpufreq_transition_notifier_list+0x0/0x29 returned 0 after 0 usecs
[    0.324031] calling  net_ns_init+0x0/0x24f @ 1
[    0.325030] initcall net_ns_init+0x0/0x24f returned 0 after 0 usecs
[    0.326009] calling  e820_mark_nvs_memory+0x0/0x5c @ 1
[    0.327014] initcall e820_mark_nvs_memory+0x0/0x5c returned 0 after 0 usecs
[    0.328012] calling  cpufreq_tsc+0x0/0x28 @ 1
[    0.329010] initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
[    0.330009] calling  pci_reboot_init+0x0/0x22 @ 1
[    0.331011] initcall pci_reboot_init+0x0/0x22 returned 0 after 0 usecs
[    0.332012] calling  init_lapic_sysfs+0x0/0x52 @ 1
[    0.334376] initcall init_lapic_sysfs+0x0/0x52 returned 0 after 976 usecs
[    0.335042] calling  init_smp_flush+0x0/0x53 @ 1
[    0.336011] initcall init_smp_flush+0x0/0x53 returned 0 after 0 usecs
[    0.337009] calling  alloc_frozen_cpus+0x0/0x14 @ 1
[    0.338008] initcall alloc_frozen_cpus+0x0/0x14 returned 0 after 0 usecs
[    0.339014] calling  sysctl_init+0x0/0x47 @ 1
[    0.341351] initcall sysctl_init+0x0/0x47 returned 0 after 0 usecs
[    0.342008] calling  ksysfs_init+0x0/0xe7 @ 1
[    0.343081] initcall ksysfs_init+0x0/0xe7 returned 0 after 0 usecs
[    0.344010] calling  async_init+0x0/0x8c @ 1
[    0.345165] initcall async_init+0x0/0x8c returned 0 after 0 usecs
[    0.346014] calling  init_jiffies_clocksource+0x0/0x20 @ 1
[    0.347014] initcall init_jiffies_clocksource+0x0/0x20 returned 0 after 0 usecs
[    0.348008] calling  pm_init+0x0/0x97 @ 1
[    0.349209] initcall pm_init+0x0/0x97 returned 0 after 0 usecs
[    0.350015] calling  pm_disk_init+0x0/0x27 @ 1
[    0.351023] initcall pm_disk_init+0x0/0x27 returned 0 after 0 usecs
[    0.352009] calling  swsusp_header_init+0x0/0x46 @ 1
[    0.353010] initcall swsusp_header_init+0x0/0x46 returned 0 after 0 usecs
[    0.354012] calling  init_ftrace_syscalls+0x0/0xfc @ 1
[    0.356876] initcall init_ftrace_syscalls+0x0/0xfc returned 0 after 976 usecs
[    0.357008] calling  init_hw_breakpoint+0x0/0x20 @ 1
[    0.358016] initcall init_hw_breakpoint+0x0/0x20 returned 0 after 0 usecs
[    0.359008] calling  init_zero_pfn+0x0/0x43 @ 1
[    0.360008] initcall init_zero_pfn+0x0/0x43 returned 0 after 0 usecs
[    0.361008] calling  filelock_init+0x0/0x3c @ 1
[    0.362030] initcall filelock_init+0x0/0x3c returned 0 after 0 usecs
[    0.363014] calling  init_misc_binfmt+0x0/0x6c @ 1
[    0.364026] initcall init_misc_binfmt+0x0/0x6c returned 0 after 0 usecs
[    0.365008] calling  init_script_binfmt+0x0/0x22 @ 1
[    0.366010] initcall init_script_binfmt+0x0/0x22 returned 0 after 0 usecs
[    0.367012] calling  init_elf_binfmt+0x0/0x22 @ 1
[    0.368009] initcall init_elf_binfmt+0x0/0x22 returned 0 after 0 usecs
[    0.369008] calling  init_compat_elf_binfmt+0x0/0x22 @ 1
[    0.370010] initcall init_compat_elf_binfmt+0x0/0x22 returned 0 after 0 usecs
[    0.371012] calling  debugfs_init+0x0/0x85 @ 1
[    0.372023] initcall debugfs_init+0x0/0x85 returned 0 after 0 usecs
[    0.373011] calling  securityfs_init+0x0/0x7c @ 1
[    0.374023] initcall securityfs_init+0x0/0x7c returned 0 after 0 usecs
[    0.375008] calling  random32_init+0x0/0x119 @ 1
[    0.377011] initcall random32_init+0x0/0x119 returned 0 after 0 usecs
[    0.378009] calling  cpufreq_core_init+0x0/0xc5 @ 1
[    0.379021] initcall cpufreq_core_init+0x0/0xc5 returned 0 after 0 usecs
[    0.380008] calling  cpuidle_init+0x0/0x5e @ 1
[    0.381025] initcall cpuidle_init+0x0/0x5e returned 0 after 0 usecs
[    0.382008] calling  sock_init+0x0/0x91 @ 1
[    0.383154] initcall sock_init+0x0/0x91 returned 0 after 0 usecs
[    0.384009] calling  netpoll_init+0x0/0x22 @ 1
[    0.385009] initcall netpoll_init+0x0/0x22 returned 0 after 0 usecs
[    0.386009] calling  netlink_proto_init+0x0/0x1bd @ 1
[    0.387093] NET: Registered protocol family 16
[    0.388116] initcall netlink_proto_init+0x0/0x1bd returned 0 after 976 usecs
[    0.389008] calling  bdi_class_init+0x0/0x67 @ 1
[    0.390292] initcall bdi_class_init+0x0/0x67 returned 0 after 0 usecs
[    0.391009] calling  kobject_uevent_init+0x0/0x77 @ 1
[    0.392031] initcall kobject_uevent_init+0x0/0x77 returned 0 after 0 usecs
[    0.393008] calling  gpiolib_sysfs_init+0x0/0xed @ 1
[    0.395149] initcall gpiolib_sysfs_init+0x0/0xed returned 0 after 976 usecs
[    0.396010] calling  pcibus_class_init+0x0/0x27 @ 1
[    0.397287] initcall pcibus_class_init+0x0/0x27 returned 0 after 0 usecs
[    0.398011] calling  pci_driver_init+0x0/0x20 @ 1
[    0.399277] initcall pci_driver_init+0x0/0x20 returned 0 after 0 usecs
[    0.400011] calling  backlight_class_init+0x0/0x79 @ 1
[    0.401288] initcall backlight_class_init+0x0/0x79 returned 0 after 0 usecs
[    0.402011] calling  tty_class_init+0x0/0x4b @ 1
[    0.403288] initcall tty_class_init+0x0/0x4b returned 0 after 0 usecs
[    0.404011] calling  vtconsole_class_init+0x0/0x113 @ 1
[    0.406429] initcall vtconsole_class_init+0x0/0x113 returned 0 after 976 usecs
[    0.407010] calling  register_node_type+0x0/0x20 @ 1
[    0.408296] initcall register_node_type+0x0/0x20 returned 0 after 0 usecs
[    0.409011] calling  spi_init+0x0/0x11d @ 1
[    0.411515] initcall spi_init+0x0/0x11d returned 0 after 976 usecs
[    0.412010] calling  i2c_init+0x0/0xb5 @ 1
[    0.413437] initcall i2c_init+0x0/0xb5 returned 0 after 0 usecs
[    0.414011] calling  amd_postcore_init+0x0/0xc6 @ 1
[    0.415010] initcall amd_postcore_init+0x0/0xc6 returned 0 after 0 usecs
[    0.416008] calling  arch_kdebugfs_init+0x0/0x3a6 @ 1
[    0.417104] initcall arch_kdebugfs_init+0x0/0x3a6 returned 0 after 0 usecs
[    0.418013] calling  mtrr_if_init+0x0/0x8d @ 1
[    0.419025] initcall mtrr_if_init+0x0/0x8d returned 0 after 0 usecs
[    0.420008] calling  ffh_cstate_init+0x0/0x41 @ 1
[    0.421014] initcall ffh_cstate_init+0x0/0x41 returned 0 after 0 usecs
[    0.422012] calling  acpi_pci_init+0x0/0xa6 @ 1
[    0.423021] ACPI: bus type pci registered
[    0.424012] initcall acpi_pci_init+0x0/0xa6 returned 0 after 976 usecs
[    0.425009] calling  dmi_id_init+0x0/0x499 @ 1
[    0.427105] initcall dmi_id_init+0x0/0x499 returned 0 after 976 usecs
[    0.428010] calling  pci_arch_init+0x0/0xc6 @ 1
[    0.429050] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.430008] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.466230] PCI: Using configuration type 1 for base access
[    0.467018] initcall pci_arch_init+0x0/0xc6 returned 0 after 37109 usecs
[    0.468008] calling  topology_init+0x0/0xe4 @ 1
[    0.470421] initcall topology_init+0x0/0xe4 returned 0 after 976 usecs
[    0.471010] calling  mtrr_init_finialize+0x0/0x70 @ 1
[    0.472009] initcall mtrr_init_finialize+0x0/0x70 returned 0 after 0 usecs
[    0.473009] calling  param_sysfs_init+0x0/0x356 @ 1
[    0.494438] initcall param_sysfs_init+0x0/0x356 returned 0 after 19531 usecs
[    0.495012] calling  pm_sysrq_init+0x0/0x2c @ 1
[    0.496027] initcall pm_sysrq_init+0x0/0x2c returned 0 after 0 usecs
[    0.497008] calling  audit_watch_init+0x0/0x4b @ 1
[    0.498013] initcall audit_watch_init+0x0/0x4b returned 0 after 0 usecs
[    0.499012] calling  init_slow_work+0x0/0x5a @ 1
[    0.500008] initcall init_slow_work+0x0/0x5a returned 0 after 0 usecs
[    0.501009] calling  default_bdi_init+0x0/0x113 @ 1
[    0.503592] initcall default_bdi_init+0x0/0x113 returned 0 after 976 usecs
[    0.510047] calling  init_bio+0x0/0x115 @ 1
[    0.515231] bio: create slab <bio-0> at 0
[    0.519243] initcall init_bio+0x0/0x115 returned 0 after 3906 usecs
[    0.526022] calling  fsnotify_init+0x0/0x2e @ 1
[    0.530024] initcall fsnotify_init+0x0/0x2e returned 0 after 0 usecs
[    0.537022] calling  fsnotify_notification_init+0x0/0x84 @ 1
[    0.543047] initcall fsnotify_notification_init+0x0/0x84 returned 0 after 0 usecs
[    0.550011] calling  cryptomgr_init+0x0/0x20 @ 1
[    0.555011] initcall cryptomgr_init+0x0/0x20 returned 0 after 0 usecs
[    0.561010] calling  blk_settings_init+0x0/0x31 @ 1
[    0.566010] initcall blk_settings_init+0x0/0x31 returned 0 after 0 usecs
[    0.573009] calling  blk_ioc_init+0x0/0x38 @ 1
[    0.577024] initcall blk_ioc_init+0x0/0x38 returned 0 after 0 usecs
[    0.584009] calling  blk_softirq_init+0x0/0x9d @ 1
[    0.589014] initcall blk_softirq_init+0x0/0x9d returned 0 after 0 usecs
[    0.595009] calling  blk_iopoll_setup+0x0/0x9d @ 1
[    0.600012] initcall blk_iopoll_setup+0x0/0x9d returned 0 after 0 usecs
[    0.607009] calling  genhd_device_init+0x0/0x92 @ 1
[    0.612320] initcall genhd_device_init+0x0/0x92 returned 0 after 0 usecs
[    0.621012] calling  blk_dev_integrity_init+0x0/0x38 @ 1
[    0.626689] initcall blk_dev_integrity_init+0x0/0x38 returned 0 after 0 usecs
[    0.627011] calling  gpiolib_debugfs_init+0x0/0x32 @ 1
[    0.628036] initcall gpiolib_debugfs_init+0x0/0x32 returned 0 after 0 usecs
[    0.629009] calling  pci_slot_init+0x0/0x6d @ 1
[    0.630027] initcall pci_slot_init+0x0/0x6d returned 0 after 0 usecs
[    0.631009] calling  fbmem_init+0x0/0xd0 @ 1
[    0.633125] initcall fbmem_init+0x0/0xd0 returned 0 after 976 usecs
[    0.634010] calling  acpi_init+0x0/0x1be @ 1
[    0.644269] ACPI: EC: Look up EC in DSDT
[    0.692322] ACPI: BIOS _OSI(Linux) query ignored
[    0.712782] ACPI: Interpreter enabled
[    0.713015] ACPI: (supports S0 S1 S3 S4 S5)
[    0.716019] ACPI: Using IOAPIC for interrupt routing
[    0.847317] initcall acpi_init+0x0/0x1be returned 0 after 207031 usecs
[    0.848011] calling  dock_init+0x0/0xde @ 1
[    0.856397] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    0.857013] initcall dock_init+0x0/0xde returned 0 after 7812 usecs
[    0.858008] calling  acpi_pci_root_init+0x0/0x52 @ 1
[    0.859008] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.867232] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.881855] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.882012] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.883012] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.884007] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff] (ignored)
[    0.885007] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff] (ignored)
[    0.886007] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xefffffff] (ignored)
[    0.887011] pci_root PNP0A03:00: host bridge window [mem 0xf4000000-0xfebfffff] (ignored)
[    0.888007] pci_root PNP0A03:00: host bridge window [mem 0xffa80800-0xffa80bff] (ignored)
[    0.889414] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.890013] pci 0000:00:01.0: PME# disabled
[    0.891109] pci 0000:00:02.0: reg 10: [mem 0xfeb00000-0xfeb7ffff]
[    0.892016] pci 0000:00:02.0: reg 14: [io  0xe898-0xe89f]
[    0.893018] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff pref]
[    0.894020] pci 0000:00:02.0: reg 1c: [mem 0xfeac0000-0xfeafffff]
[    0.895160] pci 0000:00:02.1: reg 10: [mem 0xfeb80000-0xfebfffff]
[    0.896412] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.897011] pci 0000:00:1c.0: PME# disabled
[    0.899186] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.900013] pci 0000:00:1c.1: PME# disabled
[    0.901155] pci 0000:00:1d.0: reg 20: [io  0xff80-0xff9f]
[    0.902147] pci 0000:00:1d.1: reg 20: [io  0xff60-0xff7f]
[    0.904128] pci 0000:00:1d.2: reg 20: [io  0xff40-0xff5f]
[    0.905147] pci 0000:00:1d.3: reg 20: [io  0xff20-0xff3f]
[    0.906146] pci 0000:00:1d.7: reg 10: [mem 0xffa80800-0xffa80bff]
[    0.907134] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.908012] pci 0000:00:1d.7: PME# disabled
[    0.909255] pci 0000:00:1e.2: reg 10: [io  0xec00-0xecff]
[    0.910020] pci 0000:00:1e.2: reg 14: [io  0xe8c0-0xe8ff]
[    0.911019] pci 0000:00:1e.2: reg 18: [mem 0xfeabfa00-0xfeabfbff]
[    0.912018] pci 0000:00:1e.2: reg 1c: [mem 0xfeabf900-0xfeabf9ff]
[    0.913079] pci 0000:00:1e.2: PME# supported from D0 D3hot D3cold
[    0.914011] pci 0000:00:1e.2: PME# disabled
[    0.915197] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.916011] pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by ICH6 GPIO
[    0.917010] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (mask 007f)
[    0.918010] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0 (mask 0007)
[    0.919137] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    0.921018] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    0.922018] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    0.923018] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    0.924018] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
[    0.925153] pci 0000:00:1f.2: reg 10: [io  0xfe00-0xfe07]
[    0.926017] pci 0000:00:1f.2: reg 14: [io  0xfe10-0xfe13]
[    0.927017] pci 0000:00:1f.2: reg 18: [io  0xfe20-0xfe27]
[    0.928017] pci 0000:00:1f.2: reg 1c: [io  0xfe30-0xfe33]
[    0.929017] pci 0000:00:1f.2: reg 20: [io  0xfea0-0xfeaf]
[    0.930072] pci 0000:00:1f.2: PME# supported from D3hot
[    0.931011] pci 0000:00:1f.2: PME# disabled
[    0.932124] pci 0000:00:1f.3: reg 20: [io  0xe8a0-0xe8bf]
[    0.934183] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.935012] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.936011] pci 0000:00:01.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.937016] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.939123] pci 0000:02:00.0: reg 10: [mem 0xfe8f0000-0xfe8fffff 64bit]
[    0.940160] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.941012] pci 0000:02:00.0: PME# disabled
[    0.942049] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.943052] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.944012] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.945012] pci 0000:00:1c.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.946017] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.947145] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.948012] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.949012] pci 0000:00:1c.1:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.950017] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.951196] pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive decode)
[    0.952012] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.953012] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.954017] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.955009] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.956009] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffffffffffff] (subtractive decode)
[    0.957064] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.962889] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
[    0.966700] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
[    0.967641] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3._PRT]
[    0.969442] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    2.026217] initcall acpi_pci_root_init+0x0/0x52 returned 0 after 1139648 usecs
[    2.027011] calling  acpi_pci_link_init+0x0/0x7c @ 1
[    2.029577] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    2.033857] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    2.038455] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    2.042832] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    2.048506] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    2.052865] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    2.057360] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    2.062730] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    2.066512] initcall acpi_pci_link_init+0x0/0x7c returned 0 after 37109 usecs
[    2.067011] calling  pnp_init+0x0/0x20 @ 1
[    2.068288] initcall pnp_init+0x0/0x20 returned 0 after 0 usecs
[    2.069011] calling  misc_init+0x0/0xf6 @ 1
[    2.071307] initcall misc_init+0x0/0xf6 returned 0 after 976 usecs
[    2.072011] calling  vga_arb_device_init+0x0/0xbf @ 1
[    2.074348] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.075117] vgaarb: loaded
[    2.076011] initcall vga_arb_device_init+0x0/0xbf returned 0 after 2929 usecs
[    2.077011] calling  cn_init+0x0/0xd6 @ 1
[    2.079069] initcall cn_init+0x0/0xd6 returned 0 after 976 usecs
[    2.080008] calling  phy_init+0x0/0x5a @ 1
[    2.082417] initcall phy_init+0x0/0x5a returned 0 after 976 usecs
[    2.083011] calling  serio_init+0x0/0xda @ 1
[    2.084355] initcall serio_init+0x0/0xda returned 0 after 0 usecs
[    2.085011] calling  input_init+0x0/0x1db @ 1
[    2.086284] initcall input_init+0x0/0x1db returned 0 after 0 usecs
[    2.087011] calling  power_supply_class_init+0x0/0x4b @ 1
[    2.088292] initcall power_supply_class_init+0x0/0x4b returned 0 after 0 usecs
[    2.089011] calling  pci_subsys_init+0x0/0x16a @ 1
[    2.090007] PCI: Using ACPI for IRQ routing
[    2.091008] PCI: pci_cache_line_size set to 64 bytes
[    2.092414] reserve RAM buffer: 000000007f686c00 - 000000007fffffff initcall pci_subsys_init+0x0/0x16a returned 0 after 2929 usecs
[    2.094008] calling  proto_init+0x0/0x20 @ 1
[    2.095045] initcall proto_init+0x0/0x20 returned 0 after 0 usecs
[    2.096008] calling  net_dev_init+0x0/0x254 @ 1
[    2.098197] initcall net_dev_init+0x0/0x254 returned 0 after 976 usecs
[    2.099020] calling  neigh_init+0x0/0x9b @ 1
[    2.100011] initcall neigh_init+0x0/0x9b returned 0 after 0 usecs
[    2.101008] calling  fib_rules_init+0x0/0xfa @ 1
[    2.102018] initcall fib_rules_init+0x0/0xfa returned 0 after 0 usecs
[    2.103008] calling  genl_init+0x0/0xeb @ 1
[    2.104100] initcall genl_init+0x0/0xeb returned 0 after 0 usecs
[    2.105008] calling  cipso_v4_init+0x0/0xbe @ 1
[    2.106042] initcall cipso_v4_init+0x0/0xbe returned 0 after 0 usecs
[    2.107010] calling  wireless_nlevent_init+0x0/0x20 @ 1
[    2.108013] initcall wireless_nlevent_init+0x0/0x20 returned 0 after 0 usecs
[    2.109009] calling  netlbl_init+0x0/0xdc @ 1
[    2.110005] NetLabel: Initializing
[    2.111010] NetLabel:  domain hash size = 128
[    2.112005] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.113246] NetLabel:  unlabeled traffic allowed by default
[    2.114009] initcall netlbl_init+0x0/0xdc returned 0 after 3906 usecs
[    2.115012] calling  sysctl_init+0x0/0x72 @ 1
[    2.116016] initcall sysctl_init+0x0/0x72 returned 0 after 0 usecs
[    2.117010] calling  print_ICs+0x0/0x7a4 @ 1
[    2.118010] initcall print_ICs+0x0/0x7a4 returned 0 after 0 usecs
[    2.119008] calling  hpet_late_init+0x0/0xea @ 1
[    2.120012] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    2.121016] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    2.123874] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    2.128067] initcall hpet_late_init+0x0/0xea returned 0 after 7812 usecs
[    2.129010] calling  init_k8_nbs+0x0/0x44 @ 1
[    2.130139] initcall init_k8_nbs+0x0/0x44 returned 0 after 0 usecs
[    2.131010] calling  clocksource_done_booting+0x0/0x96 @ 1
[    2.132017] Switching to clocksource tsc
[    2.133626] initcall clocksource_done_booting+0x0/0x96 returned 0 after 1285 usecs
[    2.141082] calling  ftrace_init_debugfs+0x0/0x2f1 @ 1
[    2.146598] initcall ftrace_init_debugfs+0x0/0x2f1 returned 0 after 272 usecs
[    2.153831] calling  rb_init_debugfs+0x0/0x44 @ 1
[    2.158657] initcall rb_init_debugfs+0x0/0x44 returned 0 after 18 usecs
[    2.165369] calling  tracer_init_debugfs+0x0/0x4a7 @ 1
[    2.171780] initcall tracer_init_debugfs+0x0/0x4a7 returned 0 after 1145 usecs
[    2.179166] calling  init_trace_printk_function_export+0x0/0x4d @ 1
[    2.185550] initcall init_trace_printk_function_export+0x0/0x4d returned 0 after 18 usecs
[    2.193887] calling  stat_workqueue_init+0x0/0x49 @ 1
[    2.199065] initcall stat_workqueue_init+0x0/0x49 returned 0 after 23 usecs
[    2.206122] calling  event_trace_init+0x0/0x2ea @ 1
[    2.315623] initcall event_trace_init+0x0/0x2ea returned 0 after 102068 usecs
[    2.322866] calling  init_kprobe_trace+0x0/0xbc @ 1
[    2.327881] initcall init_kprobe_trace+0x0/0xbc returned 0 after 35 usecs
[    2.334767] calling  init_pipe_fs+0x0/0x76 @ 1
[    2.339437] initcall init_pipe_fs+0x0/0x76 returned 0 after 121 usecs
[    2.345976] calling  eventpoll_init+0x0/0x10d @ 1
[    2.350848] initcall eventpoll_init+0x0/0x10d returned 0 after 52 usecs
[    2.357561] calling  anon_inode_init+0x0/0x18a @ 1
[    2.362528] initcall anon_inode_init+0x0/0x18a returned 0 after 73 usecs
[    2.369326] calling  blk_scsi_ioctl_init+0x0/0x488 @ 1
[    2.374567] initcall blk_scsi_ioctl_init+0x0/0x488 returned 0 after 1 usecs
[    2.381627] calling  acpi_event_init+0x0/0xe1 @ 1
[    2.386572] initcall acpi_event_init+0x0/0xe1 returned 0 after 137 usecs
[    2.393379] calling  pnpacpi_init+0x0/0xd5 @ 1
[    2.397921] pnp: PnP ACPI init
[    2.401168] ACPI: bus type pnp registered
[    2.418925] pnp 00:01: disabling [io  0x0800-0x085f] because it overlaps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    2.429275] pnp 00:01: disabling [io  0x0860-0x08ff] because it overlaps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    2.500087] pnp: PnP ACPI: found 10 devices
[    2.504392] ACPI: ACPI bus type pnp unregistered
[    2.509169] initcall pnpacpi_init+0x0/0xd5 returned 0 after 108635 usecs
[    2.515977] calling  pnp_system_init+0x0/0x20 @ 1
[    2.520877] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    2.526948] system 00:08: [mem 0x00000000-0x0009ffff] could not be reserved
[    2.534103] system 00:08: [mem 0x00100000-0x00ffffff] could not be reserved
[    2.541175] system 00:08: [mem 0x01000000-0x7f686bff] could not be reserved
[    2.548248] system 00:08: [mem 0x000f0000-0x000fffff] could not be reserved
[    2.555321] system 00:08: [mem 0x000c0000-0x000cffff] has been reserved
[    2.562062] system 00:08: [mem 0xfec00000-0xfecfffff] could not be reserved
[    2.569137] system 00:08: [mem 0xfee00000-0xfeefffff] has been reserved
[    2.575859] system 00:08: [mem 0xfed20000-0xfed9ffff] has been reserved
[    2.582585] system 00:08: [mem 0xffb00000-0xffbfffff] has been reserved
[    2.589311] system 00:08: [mem 0xffc00000-0xffffffff] has been reserved
[    2.596104] system 00:09: [io  0x0100-0x01fe] could not be reserved
[    2.602482] system 00:09: [io  0x0200-0x0277] has been reserved
[    2.608514] system 00:09: [io  0x0280-0x02e7] has been reserved
[    2.614537] system 00:09: [io  0x02f0-0x02f7] has been reserved
[    2.620579] system 00:09: [io  0x0300-0x0377] could not be reserved
[    2.626952] system 00:09: [io  0x0380-0x03bb] has been reserved
[    2.633004] system 00:09: [io  0x03c0-0x03e7] could not be reserved
[    2.639393] system 00:09: [io  0x03f6-0x03f7] could not be reserved
[    2.645764] system 00:09: [io  0x0400-0x04cf] has been reserved
[    2.651793] system 00:09: [io  0x04d2-0x057f] has been reserved
[    2.657818] system 00:09: [io  0x0580-0x0677] has been reserved
[    2.663842] system 00:09: [io  0x0680-0x0777] has been reserved
[    2.669865] system 00:09: [io  0x0780-0x07bb] has been reserved
[    2.675886] system 00:09: [io  0x07c0-0x07ff] has been reserved
[    2.681911] system 00:09: [io  0x08e0-0x08ff] has been reserved
[    2.687947] system 00:09: [io  0x0900-0x09fe] has been reserved
[    2.693984] system 00:09: [io  0x0a00-0x0afe] has been reserved
[    2.700044] system 00:09: [io  0x0b00-0x0bfe] has been reserved
[    2.706075] system 00:09: [io  0x0c80-0x0caf] has been reserved
[    2.712099] system 00:09: [io  0x0cb0-0x0cbf] has been reserved
[    2.718124] system 00:09: [io  0x0cc0-0x0cf7] has been reserved
[    2.724150] system 00:09: [io  0x0d00-0x0dfe] has been reserved
[    2.730174] system 00:09: [io  0x0e00-0x0efe] has been reserved
[    2.736199] system 00:09: [io  0x0f00-0x0ffe] has been reserved
[    2.742222] system 00:09: [io  0x2000-0x20fe] has been reserved
[    2.748245] system 00:09: [io  0x2100-0x21fe] has been reserved
[    2.754269] system 00:09: [io  0x2200-0x22fe] has been reserved
[    2.760294] system 00:09: [io  0x2300-0x23fe] has been reserved
[    2.766318] system 00:09: [io  0x2400-0x24fe] has been reserved
[    2.772343] system 00:09: [io  0x2500-0x25fe] has been reserved
[    2.778368] system 00:09: [io  0x2600-0x26fe] has been reserved
[    2.784394] system 00:09: [io  0x2700-0x27fe] has been reserved
[    2.790416] system 00:09: [io  0x2800-0x28fe] has been reserved
[    2.796439] system 00:09: [io  0x2900-0x29fe] has been reserved
[    2.802463] system 00:09: [io  0x2a00-0x2afe] has been reserved
[    2.808488] system 00:09: [io  0x2b00-0x2bfe] has been reserved
[    2.814512] system 00:09: [io  0x2c00-0x2cfe] has been reserved
[    2.820548] system 00:09: [io  0x2d00-0x2dfe] has been reserved
[    2.826575] system 00:09: [io  0x2e00-0x2efe] has been reserved
[    2.832600] system 00:09: [io  0x2f00-0x2ffe] has been reserved
[    2.838627] system 00:09: [io  0x5000-0x50fe] has been reserved
[    2.844652] system 00:09: [io  0x5100-0x51fe] has been reserved
[    2.850676] system 00:09: [io  0x5200-0x52fe] has been reserved
[    2.856699] system 00:09: [io  0x5300-0x53fe] has been reserved
[    2.862722] system 00:09: [io  0x5400-0x54fe] has been reserved
[    2.868748] system 00:09: [io  0x5500-0x55fe] has been reserved
[    2.874773] system 00:09: [io  0x5600-0x56fe] has been reserved
[    2.880798] system 00:09: [io  0x5700-0x57fe] has been reserved
[    2.886824] system 00:09: [io  0x5800-0x58fe] has been reserved
[    2.892850] system 00:09: [io  0x5900-0x59fe] has been reserved
[    2.898874] system 00:09: [io  0x5a00-0x5afe] has been reserved
[    2.904897] system 00:09: [io  0x5b00-0x5bfe] has been reserved
[    2.910929] system 00:09: [io  0x5c00-0x5cfe] has been reserved
[    2.916967] system 00:09: [io  0x5d00-0x5dfe] has been reserved
[    2.923022] system 00:09: [io  0x5e00-0x5efe] has been reserved
[    2.929054] system 00:09: [io  0x5f00-0x5ffe] has been reserved
[    2.935080] system 00:09: [io  0x6000-0x60fe] has been reserved
[    2.941106] system 00:09: [io  0x6100-0x61fe] has been reserved
[    2.947138] system 00:09: [io  0x6200-0x62fe] has been reserved
[    2.953162] system 00:09: [io  0x6300-0x63fe] has been reserved
[    2.959187] system 00:09: [io  0x6400-0x64fe] has been reserved
[    2.965212] system 00:09: [io  0x6500-0x65fe] has been reserved
[    2.971238] system 00:09: [io  0x6600-0x66fe] has been reserved
[    2.977264] system 00:09: [io  0x6700-0x67fe] has been reserved
[    2.983290] system 00:09: [io  0x6800-0x68fe] has been reserved
[    2.989316] system 00:09: [io  0x6900-0x69fe] has been reserved
[    2.995342] system 00:09: [io  0x6a00-0x6afe] has been reserved
[    3.001380] system 00:09: [io  0x6b00-0x6bfe] has been reserved
[    3.007430] system 00:09: [io  0x6c00-0x6cfe] has been reserved
[    3.013456] system 00:09: [io  0x6d00-0x6dfe] has been reserved
[    3.019478] system 00:09: [io  0x6e00-0x6efe] has been reserved
[    3.025504] system 00:09: [io  0x6f00-0x6ffe] has been reserved
[    3.031529] system 00:09: [io  0xa000-0xa0fe] has been reserved
[    3.037557] system 00:09: [io  0xa100-0xa1fe] has been reserved
[    3.043584] system 00:09: [io  0xa200-0xa2fe] has been reserved
[    3.049610] system 00:09: [io  0xa300-0xa3fe] has been reserved
[    3.055636] system 00:09: [io  0xa400-0xa4fe] has been reserved
[    3.061659] system 00:09: [io  0xa500-0xa5fe] has been reserved
[    3.067684] system 00:09: [io  0xa600-0xa6fe] has been reserved
[    3.073709] system 00:09: [io  0xa700-0xa7fe] has been reserved
[    3.079735] system 00:09: [io  0xa800-0xa8fe] has been reserved
[    3.085763] system 00:09: [io  0xa900-0xa9fe] has been reserved
[    3.091788] system 00:09: [io  0xaa00-0xaafe] has been reserved
[    3.097816] system 00:09: [io  0xab00-0xabfe] has been reserved
[    3.103841] system 00:09: [io  0xac00-0xacfe] has been reserved
[    3.109867] system 00:09: [io  0xad00-0xadfe] has been reserved
[    3.115893] system 00:09: [io  0xae00-0xaefe] has been reserved
[    3.121919] system 00:09: [io  0xaf00-0xaffe] has been reserved
[    3.127957] system 00:09: [mem 0xf0000000-0xf3ffffff] has been reserved
[    3.134685] system 00:09: [mem 0xfeda0000-0xfedacfff] has been reserved
[    3.141816] initcall pnp_system_init+0x0/0x20 returned 0 after 606458 usecs
[    3.148882] calling  chr_dev_init+0x0/0x121 @ 1
[    3.159335] initcall chr_dev_init+0x0/0x121 returned 0 after 5682 usecs
[    3.166140] calling  firmware_class_init+0x0/0xb1 @ 1
[    3.171716] initcall firmware_class_init+0x0/0xb1 returned 0 after 412 usecs
[    3.179076] calling  cpufreq_gov_performance_init+0x0/0x20 @ 1
[    3.185042] initcall cpufreq_gov_performance_init+0x0/0x20 returned 0 after 32 usecs
[    3.192949] calling  cpufreq_gov_dbs_init+0x0/0xf5 @ 1
[    3.198577] initcall cpufreq_gov_dbs_init+0x0/0xf5 returned 0 after 365 usecs
[    3.205845] calling  init_acpi_pm_clocksource+0x0/0x160 @ 1
[    3.216102] initcall init_acpi_pm_clocksource+0x0/0x160 returned 0 after 4473 usecs
[    3.223977] calling  pcibios_assign_resources+0x0/0xb5 @ 1
[    3.229700] PCI: max bus depth: 1 pci_try_num: 2
[    3.234514] pci 0000:00:1c.0: BAR 15: assigned [mem 0x80000000-0x801fffff 64bit pref]
[    3.242524] pci 0000:00:1c.1: BAR 15: assigned [mem 0x80200000-0x803fffff 64bit pref]
[    3.250531] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    3.256819] pci 0000:00:1c.1: BAR 13: assigned [io  0x3000-0x3fff]
[    3.263105] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    3.268440] pci 0000:00:01.0:   bridge window [io  disabled]
[    3.274210] pci 0000:00:01.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    3.281108] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    3.287324] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    3.292653] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    3.298857] pci 0000:00:1c.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    3.305752] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff 64bit pref]
[    3.313675] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    3.319017] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    3.327028] pci 0000:00:1c.1:   bridge window [mem 0xfe700000-0xfe7fffff]
[    3.333924] pci 0000:00:1c.1:   bridge window [mem 0x80200000-0x803fffff 64bit pref]
[    3.341849] pci 0000:00:1e.0: PCI bridge to [bus 04-04]
[    3.347176] pci 0000:00:1e.0:   bridge window [io  disabled]
[    3.352946] pci 0000:00:1e.0:   bridge window [mem disabled]
[    3.358716] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    3.364983]   alloc irq_desc for 16 on node -1
[    3.365899]   alloc kstat_irqs on node -1
[    3.373644] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.380454] pci 0000:00:01.0: setting latency timer to 64
[    3.385979] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.392791] pci 0000:00:1c.0: setting latency timer to 64
[    3.398315]   alloc irq_desc for 17 on node -1
[    3.399279]   alloc kstat_irqs on node -1
[    3.406971] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.413785] pci 0000:00:1c.1: setting latency timer to 64
[    3.419305] pci 0000:00:1e.0: setting latency timer to 64
[    3.424815] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    3.430493] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    3.437559] pci_bus 0000:01: resource 1 [mem 0xfe900000-0xfe9fffff]
[    3.443931] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    3.449609] pci_bus 0000:02: resource 1 [mem 0xfe800000-0xfe8fffff]
[    3.455982] pci_bus 0000:02: resource 2 [mem 0x80000000-0x801fffff 64bit pref]
[    3.463375] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    3.469052] pci_bus 0000:03: resource 1 [mem 0xfe700000-0xfe7fffff]
[    3.475427] pci_bus 0000:03: resource 2 [mem 0x80200000-0x803fffff 64bit pref]
[    3.482822] pci_bus 0000:04: resource 4 [io  0x0000-0xffff]
[    3.488499] pci_bus 0000:04: resource 5 [mem 0x00000000-0xffffffffffffffff]
[    3.495568] initcall pcibios_assign_resources+0x0/0xb5 returned 0 after 259765 usecs
[    3.503503] calling  sysctl_core_init+0x0/0x54 @ 1
[    3.508472] initcall sysctl_core_init+0x0/0x54 returned 0 after 69 usecs
[    3.515278] calling  inet_init+0x0/0x387 @ 1
[    3.519725] NET: Registered protocol family 2
[    3.524728] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    3.534773] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    3.545581] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    3.560370] TCP: Hash tables configured (established 262144 bind 65536)
[    3.567171] TCP reno registered
[    3.570485] UDP hash table entries: 1024 (order: 5, 163840 bytes)
[    3.576960] UDP-Lite hash table entries: 1024 (order: 5, 163840 bytes)
[    3.584331] initcall inet_init+0x0/0x387 returned 0 after 63153 usecs
[    3.590872] calling  af_unix_init+0x0/0x7f @ 1
[    3.595433] NET: Registered protocol family 1
[    3.599959] initcall af_unix_init+0x0/0x7f returned 0 after 4433 usecs
[    3.606588] calling  pci_apply_final_quirks+0x0/0x16c @ 1
[    3.612171] pci 0000:00:02.0: Boot video device
[    3.617142] PCI: CLS 64 bytes, default 64
[    3.621260] initcall pci_apply_final_quirks+0x0/0x16c returned 0 after 8957 usecs
[    3.628911] calling  populate_rootfs+0x0/0x18b @ 1
[    3.634562] Unpacking initramfs...
[    3.803604] Freeing initrd memory: 3956k freed
[    3.810385] initcall populate_rootfs+0x0/0x18b returned 0 after 172434 usecs
[    3.817546] calling  pci_iommu_init+0x0/0x5b @ 1
[    3.822271] initcall pci_iommu_init+0x0/0x5b returned 0 after 1 usecs
[    3.828817] calling  i8259A_init_sysfs+0x0/0x3e @ 1
[    3.834375] khelper used greatest stack depth: 5736 bytes left
[    3.834784] initcall i8259A_init_sysfs+0x0/0x3e returned 0 after 959 usecs
[    3.834789] calling  vsyscall_init+0x0/0x6c @ 1
[    3.851890] initcall vsyscall_init+0x0/0x6c returned 0 after 16692 usecs
[    3.858734] calling  sbf_init+0x0/0x18b @ 1
[    3.863025] Simple Boot Flag at 0x7a set to 0x1
[    3.867668] initcall sbf_init+0x0/0x18b returned 0 after 4534 usecs
[    3.874038] calling  i8237A_init_sysfs+0x0/0x3e @ 1
[    3.879805] initcall i8237A_init_sysfs+0x0/0x3e returned 0 after 759 usecs
[    3.886833] calling  add_rtc_cmos+0x0/0xea @ 1
[    3.891390] initcall add_rtc_cmos+0x0/0xea returned 0 after 4 usecs
[    3.897763] calling  cache_sysfs_init+0x0/0x98 @ 1
[    3.905408] initcall cache_sysfs_init+0x0/0x98 returned 0 after 2680 usecs
[    3.912390] calling  mcheck_init_device+0x0/0x13a @ 1
[    3.919650] initcall mcheck_init_device+0x0/0x13a returned 0 after 2054 usecs
[    3.926893] calling  thermal_throttle_init_device+0x0/0xf4 @ 1
[    3.932903] initcall thermal_throttle_init_device+0x0/0xf4 returned 0 after 77 usecs
[    3.940811] calling  ioapic_init_sysfs+0x0/0x10f @ 1
[    3.946827] initcall ioapic_init_sysfs+0x0/0x10f returned 0 after 931 usecs
[    3.953896] calling  add_pcspkr+0x0/0x3a @ 1
[    3.958747] initcall add_pcspkr+0x0/0x3a returned 0 after 468 usecs
[    3.965121] calling  start_periodic_check_for_corruption+0x0/0x61 @ 1
[    3.971672] Scanning for low memory corruption every 60 seconds
[    3.977700] initcall start_periodic_check_for_corruption+0x0/0x61 returned 0 after 5884 usecs
[    3.986387] calling  audit_classes_init+0x0/0xfc @ 1
[    3.991542] initcall audit_classes_init+0x0/0xfc returned 0 after 88 usecs
[    3.998520] calling  pt_dump_init+0x0/0x4a @ 1
[    4.003099] initcall pt_dump_init+0x0/0x4a returned 0 after 28 usecs
[    4.009558] calling  init_vdso_vars+0x0/0x207 @ 1
[    4.014385] initcall init_vdso_vars+0x0/0x207 returned 0 after 21 usecs
[    4.021097] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    4.026024] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 31 usecs
[    4.032821] calling  sysenter_setup+0x0/0x2d0 @ 1
[    4.037630] initcall sysenter_setup+0x0/0x2d0 returned 0 after 4 usecs
[    4.044257] calling  init_aout_binfmt+0x0/0x22 @ 1
[    4.049162] initcall init_aout_binfmt+0x0/0x22 returned 0 after 1 usecs
[    4.055872] calling  init_sched_debug_procfs+0x0/0x46 @ 1
[    4.061393] initcall init_sched_debug_procfs+0x0/0x46 returned 0 after 21 usecs
[    4.068866] calling  proc_schedstat_init+0x0/0x30 @ 1
[    4.074030] initcall proc_schedstat_init+0x0/0x30 returned 0 after 14 usecs
[    4.081092] calling  proc_execdomains_init+0x0/0x30 @ 1
[    4.086435] initcall proc_execdomains_init+0x0/0x30 returned 0 after 14 usecs
[    4.093672] calling  ioresources_init+0x0/0x51 @ 1
[    4.098588] initcall ioresources_init+0x0/0x51 returned 0 after 26 usecs
[    4.105389] calling  uid_cache_init+0x0/0xc4 @ 1
[    4.110169] initcall uid_cache_init+0x0/0xc4 returned 0 after 60 usecs
[    4.116796] calling  init_posix_timers+0x0/0x1b2 @ 1
[    4.121877] initcall init_posix_timers+0x0/0x1b2 returned 0 after 13 usecs
[    4.128850] calling  init_posix_cpu_timers+0x0/0x10f @ 1
[    4.134265] initcall init_posix_cpu_timers+0x0/0x10f returned 0 after 0 usecs
[    4.141500] calling  nsproxy_cache_init+0x0/0x3b @ 1
[    4.146579] initcall nsproxy_cache_init+0x0/0x3b returned 0 after 12 usecs
[    4.153555] calling  create_proc_profile+0x0/0x301 @ 1
[    4.158793] initcall create_proc_profile+0x0/0x301 returned 0 after 0 usecs
[    4.165853] calling  timekeeping_init_device+0x0/0x3e @ 1
[    4.172132] initcall timekeeping_init_device+0x0/0x3e returned 0 after 759 usecs
[    4.179708] calling  init_clocksource_sysfs+0x0/0x88 @ 1
[    4.185901] initcall init_clocksource_sysfs+0x0/0x88 returned 0 after 756 usecs
[    4.193379] calling  init_timer_list_procfs+0x0/0x46 @ 1
[    4.198810] initcall init_timer_list_procfs+0x0/0x46 returned 0 after 16 usecs
[    4.206196] calling  init_tstats_procfs+0x0/0x46 @ 1
[    4.211276] initcall init_tstats_procfs+0x0/0x46 returned 0 after 14 usecs
[    4.218246] calling  lockdep_proc_init+0x0/0x7b @ 1
[    4.223264] initcall lockdep_proc_init+0x0/0x7b returned 0 after 38 usecs
[    4.230167] calling  futex_init+0x0/0xa3 @ 1
[    4.234575] initcall futex_init+0x0/0xa3 returned 0 after 36 usecs
[    4.240854] calling  proc_dma_init+0x0/0x30 @ 1
[    4.245497] initcall proc_dma_init+0x0/0x30 returned 0 after 14 usecs
[    4.252035] calling  proc_modules_init+0x0/0x30 @ 1
[    4.257052] initcall proc_modules_init+0x0/0x30 returned 0 after 34 usecs
[    4.263941] calling  kallsyms_init+0x0/0x33 @ 1
[    4.268587] initcall kallsyms_init+0x0/0x33 returned 0 after 14 usecs
[    4.275124] calling  snapshot_device_init+0x0/0x20 @ 1
[    4.280834] initcall snapshot_device_init+0x0/0x20 returned 0 after 453 usecs
[    4.288076] calling  crash_save_vmcoreinfo_init+0x0/0x593 @ 1
[    4.293968] initcall crash_save_vmcoreinfo_init+0x0/0x593 returned 0 after 37 usecs
[    4.301793] calling  crash_notes_memory_init+0x0/0x52 @ 1
[    4.307379] initcall crash_notes_memory_init+0x0/0x52 returned 0 after 85 usecs
[    4.314852] calling  ikconfig_init+0x0/0x4e @ 1
[    4.319501] initcall ikconfig_init+0x0/0x4e returned 0 after 15 usecs
[    4.326040] calling  audit_init+0x0/0x1ac @ 1
[    4.330495] audit: initializing netlink socket (disabled)
[    4.336107] type=2000 audit(1273506456.335:1): initialized
[    4.341712] initcall audit_init+0x0/0x1ac returned 0 after 10950 usecs
[    4.348338] calling  gcov_init+0x0/0x20 @ 1
[    4.352625] initcall gcov_init+0x0/0x20 returned 0 after 1 usecs
[    4.358730] calling  gcov_fs_init+0x0/0x10d @ 1
[    4.499928] initcall gcov_fs_init+0x0/0x10d returned 0 after 133357 usecs
[    4.506841] calling  audit_tree_init+0x0/0x7a @ 1
[    4.511650] initcall audit_tree_init+0x0/0x7a returned 0 after 5 usecs
[    4.518274] calling  init_kprobes+0x0/0x220 @ 1
[    4.535277] initcall init_kprobes+0x0/0x220 returned 0 after 12083 usecs
[    4.542076] calling  hung_task_init+0x0/0x76 @ 1
[    4.547035] initcall hung_task_init+0x0/0x76 returned 0 after 229 usecs
[    4.553755] calling  rcuclassic_trace_init+0x0/0x15d @ 1
[    4.559274] initcall rcuclassic_trace_init+0x0/0x15d returned 0 after 108 usecs
[    4.566748] calling  utsname_sysctl_init+0x0/0x22 @ 1
[    4.572028] initcall utsname_sysctl_init+0x0/0x22 returned 0 after 123 usecs
[    4.579176] calling  init_tracepoints+0x0/0x25 @ 1
[    4.584069] initcall init_tracepoints+0x0/0x25 returned 0 after 0 usecs
[    4.590785] calling  init_lstats_procfs+0x0/0x33 @ 1
[    4.595874] initcall init_lstats_procfs+0x0/0x33 returned 0 after 24 usecs
[    4.602847] calling  ftrace_mod_cmd_init+0x0/0x20 @ 1
[    4.608051] initcall ftrace_mod_cmd_init+0x0/0x20 returned 0 after 52 usecs
[    4.615117] calling  init_events+0x0/0xa4 @ 1
[    4.619595] initcall init_events+0x0/0xa4 returned 0 after 12 usecs
[    4.625960] calling  init_sched_switch_trace+0x0/0x20 @ 1
[    4.631460] initcall init_sched_switch_trace+0x0/0x20 returned 0 after 4 usecs
[    4.638846] calling  init_stack_trace+0x0/0x20 @ 1
[    4.645503] initcall init_stack_trace+0x0/0x20 returned 0 after 3 usecs
[    4.652216] calling  init_function_trace+0x0/0x71 @ 1
[    4.657374] initcall init_function_trace+0x0/0x71 returned 0 after 5 usecs
[    4.664344] calling  init_wakeup_tracer+0x0/0x4d @ 1
[    4.669414] initcall init_wakeup_tracer+0x0/0x4d returned 0 after 4 usecs
[    4.676299] calling  stack_trace_init+0x0/0x95 @ 1
[    4.681229] initcall stack_trace_init+0x0/0x95 returned 0 after 37 usecs
[    4.688025] calling  init_graph_trace+0x0/0x40 @ 1
[    4.692922] initcall init_graph_trace+0x0/0x40 returned 0 after 4 usecs
[    4.699635] calling  init_kmem_tracer+0x0/0xaf @ 1
[    4.704531] initcall init_kmem_tracer+0x0/0xaf returned 0 after 5 usecs
[    4.711244] calling  init_blk_tracer+0x0/0x8f @ 1
[    4.716051] initcall init_blk_tracer+0x0/0x8f returned 0 after 4 usecs
[    4.722679] calling  perf_event_sysfs_init+0x0/0x27 @ 1
[    4.728048] initcall perf_event_sysfs_init+0x0/0x27 returned 0 after 36 usecs
[    4.735284] calling  init_per_zone_wmark_min+0x0/0xc0 @ 1
[    4.740967] initcall init_per_zone_wmark_min+0x0/0xc0 returned 0 after 180 usecs
[    4.748535] calling  kswapd_init+0x0/0xad @ 1
[    4.753219] initcall kswapd_init+0x0/0xad returned 0 after 221 usecs
[    4.759688] calling  setup_vmstat+0x0/0x104 @ 1
[    4.764391] initcall setup_vmstat+0x0/0x104 returned 0 after 69 usecs
[    4.770929] calling  mm_sysfs_init+0x0/0x43 @ 1
[    4.775576] initcall mm_sysfs_init+0x0/0x43 returned 0 after 14 usecs
[    4.782114] calling  proc_vmalloc_init+0x0/0x33 @ 1
[    4.787113] initcall proc_vmalloc_init+0x0/0x33 returned 0 after 14 usecs
[    4.794012] calling  procswaps_init+0x0/0x30 @ 1
[    4.798745] initcall procswaps_init+0x0/0x30 returned 0 after 14 usecs
[    4.805369] calling  hugetlb_init+0x0/0x55d @ 1
[    4.810011] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.816557] initcall hugetlb_init+0x0/0x55d returned 0 after 6402 usecs
[    4.823270] calling  ksm_init+0x0/0x301 @ 1
[    4.827877] initcall ksm_init+0x0/0x301 returned 0 after 316 usecs
[    4.834168] calling  slab_proc_init+0x0/0x33 @ 1
[    4.838903] initcall slab_proc_init+0x0/0x33 returned 0 after 16 usecs
[    4.845524] calling  slab_sysfs_init+0x0/0x157 @ 1
[    4.915583] initcall slab_sysfs_init+0x0/0x157 returned 0 after 63635 usecs
[    4.922652] calling  fasync_init+0x0/0x38 @ 1
[    4.927773] initcall fasync_init+0x0/0x38 returned 0 after 646 usecs
[    4.934237] calling  proc_filesystems_init+0x0/0x30 @ 1
[    4.939582] initcall proc_filesystems_init+0x0/0x30 returned 0 after 20 usecs
[    4.946813] calling  dnotify_init+0x0/0xa3 @ 1
[    4.952787] initcall dnotify_init+0x0/0xa3 returned 0 after 1395 usecs
[    4.959415] calling  inotify_setup+0x0/0x19 @ 1
[    4.964045] initcall inotify_setup+0x0/0x19 returned 0 after 0 usecs
[    4.970501] calling  inotify_user_setup+0x0/0x85 @ 1
[    4.976873] initcall inotify_user_setup+0x0/0x85 returned 0 after 1276 usecs
[    4.984031] calling  aio_setup+0x0/0x11d @ 1
[    4.990103] initcall aio_setup+0x0/0x11d returned 0 after 1654 usecs
[    4.996563] calling  proc_locks_init+0x0/0x30 @ 1
[    5.001384] initcall proc_locks_init+0x0/0x30 returned 0 after 18 usecs
[    5.008096] calling  init_sys32_ioctl+0x0/0x36 @ 1
[    5.013153] initcall init_sys32_ioctl+0x0/0x36 returned 0 after 159 usecs
[    5.020040] calling  dquot_init+0x0/0x121 @ 1
[    5.024499] VFS: Disk quotas dquot_6.5.2
[    5.029374] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.035927] initcall dquot_init+0x0/0x121 returned 0 after 11157 usecs
[    5.042554] calling  quota_init+0x0/0x42 @ 1
[    5.046973] initcall quota_init+0x0/0x42 returned 0 after 47 usecs
[    5.053252] calling  proc_cmdline_init+0x0/0x30 @ 1
[    5.058247] initcall proc_cmdline_init+0x0/0x30 returned 0 after 16 usecs
[    5.065134] calling  proc_cpuinfo_init+0x0/0x30 @ 1
[    5.070129] initcall proc_cpuinfo_init+0x0/0x30 returned 0 after 14 usecs
[    5.077019] calling  proc_devices_init+0x0/0x30 @ 1
[    5.082019] initcall proc_devices_init+0x0/0x30 returned 0 after 20 usecs
[    5.088905] calling  proc_interrupts_init+0x0/0x30 @ 1
[    5.094186] initcall proc_interrupts_init+0x0/0x30 returned 0 after 18 usecs
[    5.101333] calling  proc_loadavg_init+0x0/0x30 @ 1
[    5.106326] initcall proc_loadavg_init+0x0/0x30 returned 0 after 16 usecs
[    5.113212] calling  proc_meminfo_init+0x0/0x30 @ 1
[    5.118205] initcall proc_meminfo_init+0x0/0x30 returned 0 after 14 usecs
[    5.125090] calling  proc_stat_init+0x0/0x30 @ 1
[    5.129825] initcall proc_stat_init+0x0/0x30 returned 0 after 14 usecs
[    5.136454] calling  proc_uptime_init+0x0/0x30 @ 1
[    5.141363] initcall proc_uptime_init+0x0/0x30 returned 0 after 14 usecs
[    5.148161] calling  proc_version_init+0x0/0x30 @ 1
[    5.153171] initcall proc_version_init+0x0/0x30 returned 0 after 20 usecs
[    5.160055] calling  proc_softirqs_init+0x0/0x30 @ 1
[    5.165157] initcall proc_softirqs_init+0x0/0x30 returned 0 after 30 usecs
[    5.172130] calling  proc_kcore_init+0x0/0xe4 @ 1
[    5.176993] initcall proc_kcore_init+0x0/0xe4 returned 0 after 48 usecs
[    5.183706] calling  vmcore_init+0x0/0x4e1 @ 1
[    5.188251] initcall vmcore_init+0x0/0x4e1 returned 0 after 0 usecs
[    5.194617] calling  proc_kmsg_init+0x0/0x33 @ 1
[    5.199351] initcall proc_kmsg_init+0x0/0x33 returned 0 after 15 usecs
[    5.205975] calling  proc_page_init+0x0/0x57 @ 1
[    5.210721] initcall proc_page_init+0x0/0x57 returned 0 after 28 usecs
[    5.217344] calling  init_devpts_fs+0x0/0x76 @ 1
[    5.222208] initcall init_devpts_fs+0x0/0x76 returned 0 after 143 usecs
[    5.228921] calling  init_ramfs_fs+0x0/0x20 @ 1
[    5.233555] initcall init_ramfs_fs+0x0/0x20 returned 0 after 2 usecs
[    5.240011] calling  init_hugetlbfs_fs+0x0/0xf1 @ 1
[    5.245819] initcall init_hugetlbfs_fs+0x0/0xf1 returned 0 after 809 usecs
[    5.252798] calling  ipc_init+0x0/0x46 @ 1
[    5.257021] msgmni has been set to 3955
[    5.261012] initcall ipc_init+0x0/0x46 returned 0 after 3924 usecs
[    5.267289] calling  ipc_sysctl_init+0x0/0x22 @ 1
[    5.272324] initcall ipc_sysctl_init+0x0/0x22 returned 0 after 227 usecs
[    5.279125] calling  init_mqueue_fs+0x0/0x128 @ 1
[    5.284945] initcall init_mqueue_fs+0x0/0x128 returned 0 after 984 usecs
[    5.291750] calling  key_proc_init+0x0/0x7e @ 1
[    5.296413] initcall key_proc_init+0x0/0x7e returned 0 after 30 usecs
[    5.302948] calling  crypto_wq_init+0x0/0x4c @ 1
[    5.308036] initcall crypto_wq_init+0x0/0x4c returned 0 after 359 usecs
[    5.314761] calling  crypto_algapi_init+0x0/0x1b @ 1
[    5.319884] initcall crypto_algapi_init+0x0/0x1b returned 0 after 56 usecs
[    5.326858] calling  skcipher_module_init+0x0/0x4e @ 1
[    5.332097] initcall skcipher_module_init+0x0/0x4e returned 0 after 1 usecs
[    5.339159] calling  chainiv_module_init+0x0/0x20 @ 1
[    5.344344] initcall chainiv_module_init+0x0/0x20 returned 0 after 32 usecs
[    5.351403] calling  eseqiv_module_init+0x0/0x20 @ 1
[    5.356471] initcall eseqiv_module_init+0x0/0x20 returned 0 after 2 usecs
[    5.363355] calling  hmac_module_init+0x0/0x20 @ 1
[    5.368250] initcall hmac_module_init+0x0/0x20 returned 0 after 2 usecs
[    5.374961] calling  md5_mod_init+0x0/0x20 @ 1
[    5.379793] initcall md5_mod_init+0x0/0x20 returned 0 after 281 usecs
[    5.386350] calling  sha1_generic_mod_init+0x0/0x20 @ 1
[    5.391959] initcall sha1_generic_mod_init+0x0/0x20 returned 0 after 275 usecs
[    5.399368] calling  krng_mod_init+0x0/0x20 @ 1
[    5.404221] alg: No test for stdrng (krng)
[    5.408518] initcall krng_mod_init+0x0/0x20 returned 0 after 4407 usecs
[    5.415250] calling  proc_genhd_init+0x0/0x51 @ 1
[    5.420085] initcall proc_genhd_init+0x0/0x51 returned 0 after 30 usecs
[    5.426801] calling  bsg_init+0x0/0x1ae @ 1
[    5.432208] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    5.439781] initcall bsg_init+0x0/0x1ae returned 0 after 8491 usecs
[    5.446160] calling  noop_init+0x0/0x22 @ 1
[    5.450463] io scheduler noop registered
[    5.454485] initcall noop_init+0x0/0x22 returned 0 after 3946 usecs
[    5.460851] calling  deadline_init+0x0/0x22 @ 1
[    5.465480] io scheduler deadline registered
[    5.469850] initcall deadline_init+0x0/0x22 returned 0 after 4266 usecs
[    5.476562] calling  cfq_init+0x0/0xda @ 1
[    5.482068] io scheduler cfq registered (default)
[    5.486878] initcall cfq_init+0x0/0xda returned 0 after 5975 usecs
[    5.493158] calling  percpu_counter_startup+0x0/0x2e @ 1
[    5.498575] initcall percpu_counter_startup+0x0/0x2e returned 0 after 5 usecs
[    5.505821] calling  dynamic_debug_init+0x0/0x1aa @ 1
[    5.511355] initcall dynamic_debug_init+0x0/0x1aa returned 0 after 371 usecs
[    5.518502] calling  lnw_gpio_init+0x0/0x29 @ 1
[    5.523640] initcall lnw_gpio_init+0x0/0x29 returned 0 after 491 usecs
[    5.530271] calling  pci_proc_init+0x0/0x94 @ 1
[    5.535425] initcall pci_proc_init+0x0/0x94 returned 0 after 509 usecs
[    5.542050] calling  pcie_portdrv_init+0x0/0x90 @ 1
[    5.547531] pcieport 0000:00:01.0: setting latency timer to 64
[    5.553558]   alloc irq_desc for 24 on node -1
[    5.554453]   alloc kstat_irqs on node -1
[    5.562225] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    5.568702] pcieport 0000:00:1c.0: setting latency timer to 64
[    5.574722]   alloc irq_desc for 25 on node -1
[    5.575624]   alloc kstat_irqs on node -1
[    5.583380] pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X
[    5.590342] pcieport 0000:00:1c.1: setting latency timer to 64
[    5.596362]   alloc irq_desc for 26 on node -1
[    5.597264]   alloc kstat_irqs on node -1
[    5.605024] pcieport 0000:00:1c.1: irq 26 for MSI/MSI-X
[    5.612492] initcall pcie_portdrv_init+0x0/0x90 returned 0 after 63925 usecs
[    5.619641] calling  aer_service_init+0x0/0x50 @ 1
[    5.624927] initcall aer_service_init+0x0/0x50 returned 0 after 382 usecs
[    5.631821] calling  pcie_pme_service_init+0x0/0x37 @ 1
[    5.637197] pcieport 0000:00:01.0: Requesting control of PCIe PME from ACPI BIOS
[    5.644771] pcieport 0000:00:01.0: Failed to receive control of PCIe PME service: no _OSC support
[    5.653843] pcie_pme: probe of 0000:00:01.0:pcie01 failed with error -13
[    5.660668] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    5.668233] pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: no _OSC support
[    5.677281] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
[    5.684101] pcieport 0000:00:1c.1: Requesting control of PCIe PME from ACPI BIOS
[    5.691672] pcieport 0000:00:1c.1: Failed to receive control of PCIe PME service: no _OSC support
[    5.700721] pcie_pme: probe of 0000:00:1c.1:pcie01 failed with error -13
[    5.708011] initcall pcie_pme_service_init+0x0/0x37 returned 0 after 69183 usecs
[    5.715585] calling  ioapic_init+0x0/0x29 @ 1
[    5.722434] initcall ioapic_init+0x0/0x29 returned 0 after 546 usecs
[    5.728889] calling  vesafb_init+0x0/0x331 @ 1
[    5.735441] initcall vesafb_init+0x0/0x331 returned -19 after 1960 usecs
[    5.742244] calling  efifb_init+0x0/0x2be @ 1
[    5.746709] initcall efifb_init+0x0/0x2be returned -19 after 6 usecs
[    5.753163] calling  acpi_reserve_resources+0x0/0x141 @ 1
[    5.758672] initcall acpi_reserve_resources+0x0/0x141 returned 0 after 13 usecs
[    5.766161] calling  irqrouter_init_sysfs+0x0/0x62 @ 1
[    5.772179] initcall irqrouter_init_sysfs+0x0/0x62 returned 0 after 759 usecs
[    5.779428] calling  rand_initialize+0x0/0x4d @ 1
[    5.784270] initcall rand_initialize+0x0/0x4d returned 0 after 35 usecs
[    5.790982] calling  tty_init+0x0/0x15a @ 1
[    5.832831] initcall tty_init+0x0/0x15a returned 0 after 36683 usecs
[    5.839289] calling  pty_init+0x0/0x603 @ 1
[    6.126625] initcall pty_init+0x0/0x603 returned 0 after 276409 usecs
[    6.133178] calling  sysrq_init+0x0/0x33 @ 1
[    6.137576] initcall sysrq_init+0x0/0x33 returned 0 after 26 usecs
[    6.143851] calling  hpet_init+0x0/0xab @ 1
[    6.149181] initcall hpet_init+0x0/0xab returned 0 after 1005 usecs
[    6.155565] calling  agp_init+0x0/0x3b @ 1
[    6.159760] Linux agpgart interface v0.103
[    6.163959] initcall agp_init+0x0/0x3b returned 0 after 4098 usecs
[    6.170237] calling  drm_core_init+0x0/0x1ab @ 1
[    6.175437] [drm] Initialized drm 1.1.0 20060810
[    6.180170] initcall drm_core_init+0x0/0x1ab returned 0 after 5087 usecs
[    6.186970] calling  cn_proc_init+0x0/0x5b @ 1
[    6.191572] initcall cn_proc_init+0x0/0x5b returned 0 after 55 usecs
[    6.198024] calling  serial8250_init+0x0/0x222 @ 1
[    6.202913] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.210032] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    6.219118] initcall serial8250_init+0x0/0x222 returned 0 after 15815 usecs
[    6.226192] calling  serial8250_pnp_init+0x0/0x20 @ 1
[    6.232984] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    6.239691] initcall serial8250_pnp_init+0x0/0x20 returned 0 after 8149 usecs
[    6.246940] calling  serial8250_pci_init+0x0/0x29 @ 1
[    6.252608] initcall serial8250_pci_init+0x0/0x29 returned 0 after 499 usecs
[    6.259757] calling  topology_sysfs_init+0x0/0x8e @ 1
[    6.264997] initcall topology_sysfs_init+0x0/0x8e returned 0 after 84 usecs
[    6.272055] calling  init_kgdbts+0x0/0x2d @ 1
[    6.276519] initcall init_kgdbts+0x0/0x2d returned 0 after 0 usecs
[    6.282797] calling  fixed_mdio_bus_init+0x0/0x13a @ 1
[    6.289007] Fixed MDIO Bus: probed
[    6.292517] initcall fixed_mdio_bus_init+0x0/0x13a returned 0 after 4375 usecs
[    6.299906] calling  tg3_init+0x0/0x29 @ 1
[    6.304236] tg3.c:v3.108 (February 17, 2010)
[    6.308640] tg3 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.315449] tg3 0000:02:00.0: setting latency timer to 64
[    6.333419] tg3 0000:02:00.0: eth0: Tigon3 [partno(BCM5751PKFBG) rev 4001] (PCI Express) MAC address 00:18:8b:01:d2:2b
[    6.344278] tg3 0000:02:00.0: eth0: attached PHY is 5750 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    6.353571] tg3 0000:02:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    6.361653] tg3 0000:02:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    6.368959] initcall tg3_init+0x0/0x29 returned 0 after 63329 usecs
[    6.375331] calling  net_olddevs_init+0x0/0x11c @ 1
[    6.380317] initcall net_olddevs_init+0x0/0x11c returned 0 after 6 usecs
[    6.387114] calling  init_netconsole+0x0/0x32c @ 1
[    6.392023] console [netcon0] enabled
[    6.395783] netconsole: network logging started
[    6.400411] initcall init_netconsole+0x0/0x32c returned 0 after 8197 usecs
[    6.407383] calling  i8042_init+0x0/0x50e @ 1
[    6.413677] PNP: No PS/2 controller found. Probing ports directly.
[    6.423215] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.428313] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.434102] initcall i8042_init+0x0/0x50e returned 0 after 21736 usecs
[    6.440766] calling  mousedev_init+0x0/0xd8 @ 1
[    6.446658] mice: PS/2 mouse device common for all mice
[    6.452019] initcall mousedev_init+0x0/0xd8 returned 0 after 6465 usecs
[    6.458731] calling  atkbd_init+0x0/0x3c @ 1
[    6.463547] initcall atkbd_init+0x0/0x3c returned 0 after 434 usecs
[    6.469990] calling  init_ladder+0x0/0x20 @ 1
[    6.474508] cpuidle: using governor ladder
[    6.478707] initcall init_ladder+0x0/0x20 returned 0 after 4130 usecs
[    6.485274] calling  init_menu+0x0/0x20 @ 1
[    6.489571] cpuidle: using governor menu
[    6.493596] initcall init_menu+0x0/0x20 returned 0 after 3930 usecs
[    6.499984] calling  ledtrig_ide_init+0x0/0x29 @ 1
[    6.504947] initcall ledtrig_ide_init+0x0/0x29 returned 0 after 39 usecs
[    6.511772] calling  hid_init+0x0/0xac @ 1
[    6.516890] initcall hid_init+0x0/0xac returned 0 after 883 usecs
[    6.523105] calling  flow_cache_init+0x0/0x20d @ 1
[    6.528731] initcall flow_cache_init+0x0/0x20d returned 0 after 713 usecs
[    6.535679] calling  sysctl_ipv4_init+0x0/0x75 @ 1
[    6.542851] initcall sysctl_ipv4_init+0x0/0x75 returned 0 after 2227 usecs
[    6.549826] calling  init_syncookies+0x0/0x27 @ 1
[    6.554680] initcall init_syncookies+0x0/0x27 returned 0 after 47 usecs
[    6.561394] calling  cubictcp_register+0x0/0x76 @ 1
[    6.566370] TCP cubic registered
[    6.569700] initcall cubictcp_register+0x0/0x76 returned 0 after 3251 usecs
[    6.576761] calling  packet_init+0x0/0x71 @ 1
[    6.581221] NET: Registered protocol family 17
[    6.585794] initcall packet_init+0x0/0x71 returned 0 after 4466 usecs
[    6.592335] calling  mcheck_debugfs_init+0x0/0x60 @ 1
[    6.597527] initcall mcheck_debugfs_init+0x0/0x60 returned 0 after 38 usecs
[    6.604586] calling  severities_debugfs_init+0x0/0x5e @ 1
[    6.610164] initcall severities_debugfs_init+0x0/0x5e returned 0 after 77 usecs
[    6.617641] calling  hpet_insert_resource+0x0/0x3a @ 1
[    6.622882] initcall hpet_insert_resource+0x0/0x3a returned 0 after 3 usecs
[    6.629941] calling  update_mp_table+0x0/0x85c @ 1
[    6.634833] initcall update_mp_table+0x0/0x85c returned 0 after 0 usecs
[    6.641547] calling  lapic_insert_resource+0x0/0x55 @ 1
[    6.646873] initcall lapic_insert_resource+0x0/0x55 returned 0 after 2 usecs
[    6.654020] calling  init_lapic_nmi_sysfs+0x0/0x65 @ 1
[    6.659259] initcall init_lapic_nmi_sysfs+0x0/0x65 returned 0 after 0 usecs
[    6.666319] calling  io_apic_bug_finalize+0x0/0x29 @ 1
[    6.671555] initcall io_apic_bug_finalize+0x0/0x29 returned 0 after 0 usecs
[    6.678613] calling  check_early_ioremap_leak+0x0/0x91 @ 1
[    6.684199] initcall check_early_ioremap_leak+0x0/0x91 returned 0 after 0 usecs
[    6.691679] calling  pat_memtype_list_init+0x0/0x47 @ 1
[    6.697030] initcall pat_memtype_list_init+0x0/0x47 returned 0 after 19 usecs
[    6.704278] calling  sched_init_debug+0x0/0x32 @ 1
[    6.709211] initcall sched_init_debug+0x0/0x32 returned 0 after 39 usecs
[    6.716031] calling  init_oops_id+0x0/0x4b @ 1
[    6.720584] initcall init_oops_id+0x0/0x4b returned 0 after 8 usecs
[    6.726951] calling  disable_boot_consoles+0x0/0x67 @ 1
[    6.732278] initcall disable_boot_consoles+0x0/0x67 returned 0 after 0 usecs
[    6.739423] calling  pm_qos_power_init+0x0/0xb9 @ 1
[    6.745496] khelper used greatest stack depth: 5560 bytes left
[    6.746736] initcall pm_qos_power_init+0x0/0xb9 returned 0 after 2273 usecs
[    6.746744] calling  software_resume+0x0/0x4b2 @ 1
[    6.746776] initcall software_resume+0x0/0x4b2 returned -2 after 24 usecs
[    6.746782] initcall software_resume+0x0/0x4b2 returned with error code -2 
[    6.746787] calling  debugfs_kprobe_init+0x0/0xd4 @ 1
[    6.746852] initcall debugfs_kprobe_init+0x0/0xd4 returned 0 after 57 usecs
[    6.746857] calling  taskstats_init+0x0/0xe0 @ 1
[    6.746913] registered taskstats version 1
[    6.746918] initcall taskstats_init+0x0/0xe0 returned 0 after 54 usecs
[    6.746922] calling  clear_boot_tracer+0x0/0x44 @ 1
[    6.746927] initcall clear_boot_tracer+0x0/0x44 returned 0 after 0 usecs
[    6.746931] calling  max_swapfiles_check+0x0/0xf @ 1
[    6.746936] initcall max_swapfiles_check+0x0/0xf returned 0 after 0 usecs
[    6.746940] calling  random32_reseed+0x0/0xdc @ 1
[    6.746990] initcall random32_reseed+0x0/0xdc returned 0 after 43 usecs
[    6.746994] calling  pci_resource_alignment_sysfs_init+0x0/0x27 @ 1
[    6.747008] initcall pci_resource_alignment_sysfs_init+0x0/0x27 returned 0 after 7 usecs
[    6.747013] calling  pci_sysfs_init+0x0/0x7b @ 1
[    6.747925] initcall pci_sysfs_init+0x0/0x7b returned 0 after 884 usecs
[    6.747930] calling  seqgen_init+0x0/0x1d @ 1
[    6.747960] initcall seqgen_init+0x0/0x1d returned 0 after 23 usecs
[    6.747964] calling  memmap_init+0x0/0x5b @ 1
[    6.748245] initcall memmap_init+0x0/0x5b returned 0 after 267 usecs
[    6.748249] calling  pci_mmcfg_late_insert_resources+0x0/0x97 @ 1
[    6.748258] initcall pci_mmcfg_late_insert_resources+0x0/0x97 returned 0 after 3 usecs
[    6.748263] calling  init_net_drop_monitor+0x0/0x209 @ 1
[    6.748266] Initalizing network drop monitor service
[    6.748377] initcall init_net_drop_monitor+0x0/0x209 returned 0 after 104 usecs
[    6.748382] calling  tcp_congestion_default+0x0/0x20 @ 1
[    6.748389] initcall tcp_congestion_default+0x0/0x20 returned 0 after 2 usecs
[    6.748394] calling  ip_auto_config+0x0/0x1302 @ 1
[    6.748424] initcall ip_auto_config+0x0/0x1302 returned 0 after 23 usecs
[    6.748429] calling  initialize_hashrnd+0x0/0x27 @ 1
[    6.748442] initcall initialize_hashrnd+0x0/0x27 returned 0 after 7 usecs
[    6.956327] async_waiting @ 1
[    6.959427] async_continuing @ 1 after 17 usec
[    6.964060] Freeing unused kernel memory: 3324k freed
[    6.971024] Write protecting the kernel read-only data: 10240k
[    6.978548] Freeing unused kernel memory: 1652k freed
[    6.986248] Freeing unused kernel memory: 2024k freed
[    7.481859] calling  usb_init+0x0/0x270 [usbcore] @ 990
[    7.487611] usbcore: registered new interface driver usbfs
[    7.493587] usbcore: registered new interface driver hub
[    7.499419] usbcore: registered new device driver usb
[    7.504623] initcall usb_init+0x0/0x270 [usbcore] returned 0 after 16996 usecs
[    7.516955] calling  ehci_hcd_init+0x0/0x136 [ehci_hcd] @ 990
[    7.522827] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.529561]   alloc irq_desc for 21 on node -1
[    7.530444]   alloc kstat_irqs on node -1
[    7.540063] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    7.547357] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    7.553293] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    7.558924] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    7.566634] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    7.573030] ehci_hcd 0000:00:1d.7: debug port 1
[    7.581556] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    7.588525] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xffa80800
[    7.604055] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    7.610298] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.617185] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.624574] usb usb1: Product: EHCI Host Controller
[    7.629552] usb usb1: Manufacturer: Linux 2.6.34-rc7 ehci_hcd
[    7.635398] usb usb1: SerialNumber: 0000:00:1d.7
[    7.641221] hub 1-0:1.0: USB hub found
[    7.645109] hub 1-0:1.0: 8 ports detected
[    7.650355] initcall ehci_hcd_init+0x0/0x136 [ehci_hcd] returned 0 after 124531 usecs
[    7.658688] modprobe used greatest stack depth: 4512 bytes left
[    7.674955] calling  init_pcmcia_cs+0x0/0x4b [pcmcia_core] @ 992
[    7.681234] initcall init_pcmcia_cs+0x0/0x4b [pcmcia_core] returned 0 after 144 usecs
[    7.696779] calling  init_pcmcia_bus+0x0/0x9d [pcmcia] @ 992
[    7.702793] initcall init_pcmcia_bus+0x0/0x9d [pcmcia] returned 0 after 226 usecs
[    7.724007] calling  mmc_init+0x0/0xd8 [mmc_core] @ 992
[    7.729994] initcall mmc_init+0x0/0xd8 [mmc_core] returned 0 after 622 usecs
[    7.748138] calling  ssb_modinit+0x0/0xb1 [ssb] @ 992
[    7.754030] initcall ssb_modinit+0x0/0xb1 [ssb] returned 0 after 616 usecs
[    7.767227] calling  ohci_hcd_mod_init+0x0/0x135 [ohci_hcd] @ 992
[    7.773435] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.780089] initcall ohci_hcd_mod_init+0x0/0x135 [ohci_hcd] returned 0 after 6493 usecs
[    7.797500] calling  uhci_hcd_init+0x0/0x12b [uhci_hcd] @ 994
[    7.803366] uhci_hcd: USB Universal Host Controller Interface driver
[    7.810392] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    7.817671] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    7.823613] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    7.829016] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    7.836662] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000ff80
[    7.842820] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    7.849723] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.857131] usb usb2: Product: UHCI Host Controller
[    7.862127] usb usb2: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
[    7.867989] usb usb2: SerialNumber: 0000:00:1d.0
[    7.873807] hub 2-0:1.0: USB hub found
[    7.877792] hub 2-0:1.0: 2 ports detected
[    7.882678]   alloc irq_desc for 22 on node -1
[    7.883004]   alloc kstat_irqs on node -1
[    7.891353] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    7.898618] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    7.904561] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    7.909940] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    7.917621] uhci_hcd 0000:00:1d.1: irq 22, io base 0x0000ff60
[    7.923711] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    7.930639] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.938028] usb usb3: Product: UHCI Host Controller
[    7.943016] usb usb3: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
[    7.948862] usb usb3: SerialNumber: 0000:00:1d.1
[    7.954531] hub 3-0:1.0: USB hub found
[    7.958442] hub 3-0:1.0: 2 ports detected
[    7.963324]   alloc irq_desc for 18 on node -1
[    7.964006]   alloc kstat_irqs on node -1
[    7.971991] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    7.979255] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    7.985209] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    7.990763] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    7.998464] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[    8.004572] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    8.011460] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.018852] usb usb4: Product: UHCI Host Controller
[    8.023831] usb usb4: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
[    8.029677] usb usb4: SerialNumber: 0000:00:1d.2
[    8.035265] hub 4-0:1.0: USB hub found
[    8.039173] hub 4-0:1.0: 2 ports detected
[    8.043984]   alloc irq_desc for 23 on node -1
[    8.044276]   alloc kstat_irqs on node -1
[    8.052658] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    8.059922] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    8.065875] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    8.071343] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    8.079029] uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000ff20
[    8.085168] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    8.092057] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.099449] usb usb5: Product: UHCI Host Controller
[    8.104429] usb usb5: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
[    8.110274] usb usb5: SerialNumber: 0000:00:1d.3
[    8.115894] hub 5-0:1.0: USB hub found
[    8.119788] hub 5-0:1.0: 2 ports detected
[    8.124794] initcall uhci_hcd_init+0x0/0x12b [uhci_hcd] returned 0 after 313886 usecs
[    8.142193] calling  init_mbcache+0x0/0x22 [mbcache] @ 995
[    8.147934] initcall init_mbcache+0x0/0x22 [mbcache] returned 0 after 117 usecs
[    8.163908] calling  journal_init+0x0/0x114 [jbd] @ 995
[    8.170716] initcall journal_init+0x0/0x114 [jbd] returned 0 after 1427 usecs
[    8.194037] calling  init_ext3_fs+0x0/0xbf [ext3] @ 995
[    8.200289] initcall init_ext3_fs+0x0/0xbf [ext3] returned 0 after 877 usecs
[    8.244877] calling  init_scsi+0x0/0x131 [scsi_mod] @ 997
[    8.253807] SCSI subsystem initialized
[    8.257682] initcall init_scsi+0x0/0x131 [scsi_mod] returned 0 after 7102 usecs
[    8.277933] calling  init_sd+0x0/0x227 [sd_mod] @ 998
[    8.283219] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    8.283876] initcall init_sd+0x0/0x227 [sd_mod] returned 0 after 749 usecs
[    8.311389] calling  ide_init+0x0/0xcc [ide_core] @ 999
[    8.316733] Uniform Multi-Platform E-IDE driver
[    8.321711] initcall ide_init+0x0/0xcc [ide_core] returned 0 after 4849 usecs
[    8.335984] calling  generic_ide_init+0x0/0x2e [ide_pci_generic] @ 1000
[    8.343054] initcall generic_ide_init+0x0/0x2e [ide_pci_generic] returned 0 after 311 usecs
[    8.386257] calling  ata_init+0x0/0x470 [libata] @ 1001
[    8.392259] libata version 3.00 loaded.
[    8.396227] initcall ata_init+0x0/0x470 [libata] returned 0 after 4501 usecs
[    8.413968] calling  piix_init+0x0/0x45 [ata_piix] @ 1005
[    8.419605] ata_piix 0000:00:1f.1: version 2.13
[    8.424322] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.431869] ata_piix 0000:00:1f.1: setting latency timer to 64
[    8.438313] scsi0 : ata_piix
[    8.442763] scsi1 : ata_piix
[    8.452318] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    8.459502] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    8.466798]   alloc irq_desc for 20 on node -1
[    8.467496] ata2: port disabled. ignoring.
[    8.467555]   alloc kstat_irqs on node -1
[    8.479744] ata_piix 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    8.487047] usb 3-1: New USB device found, idVendor=413c, idProduct=1003
[    8.487055] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    8.499168] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.506412] usb 3-1: Product: Dell USB Keyboard Hub
[    8.511389] usb 3-1: Manufacturer: Dell
[    8.523837] hub 3-1:1.0: USB hub found
[    8.528665] hub 3-1:1.0: 3 ports detected
[    8.620493] ata1.00: ATAPI: HL-DT-STDVD+-RW GSA-H21N, A105, max UDMA/33
[    8.633400] ata1.00: configured for UDMA/33
[    8.638158] ata_piix 0000:00:1f.2: setting latency timer to 64
[    8.644670] scsi2 : ata_piix
[    8.648570] scsi3 : ata_piix
[    8.652260] ata3: SATA max UDMA/133 cmd 0xfe00 ctl 0xfe10 bmdma 0xfea0 irq 20
[    8.659596] ata4: SATA max UDMA/133 cmd 0xfe20 ctl 0xfe30 bmdma 0xfea8 irq 20
[    8.659618] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-H21N A105 PQ: 0 ANSI: 5
[    8.675539] initcall piix_init+0x0/0x45 [ata_piix] returned 0 after 250015 usecs
[    8.829468] ata3.00: ATA-7: WDC WD2500JS-75NCB3, 10.02E04, max UDMA/133
[    8.836203] ata3.00: 488281250 sectors, multi 8: LBA48 NCQ (depth 0/32)
[    8.846352] ata3.00: configured for UDMA/133
[    8.851298] scsi 2:0:0:0: Direct-Access     ATA      WDC WD2500JS-75N 10.0 PQ: 0 ANSI: 5
[    8.859628] usb 3-1.1: new full speed USB device using uhci_hcd and address 3
[    8.861357] sd 2:0:0:0: [sda] 488281250 512-byte logical blocks: (250 GB/232 GiB)
[    8.861752] sd 2:0:0:0: [sda] Write Protect is off
[    8.861756] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    8.861914] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.862948]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    8.913982] sd 2:0:0:0: [sda] Attached SCSI disk
[    9.026702] usb 3-1.1: New USB device found, idVendor=413c, idProduct=2010
[    9.033717] usb 3-1.1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[    9.041202] usb 3-1.1: Product: Dell USB Keyboard
[    9.046011] usb 3-1.1: Manufacturer: Dell
[    9.126708] usb 3-1.3: new low speed USB device using uhci_hcd and address 4
[    9.260724] usb 3-1.3: New USB device found, idVendor=046d, idProduct=c016
[    9.267734] usb 3-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    9.275216] usb 3-1.3: Product: Optical USB Mouse
[    9.280021] usb 3-1.3: Manufacturer: Logitech
[   10.484839] calling  pacpi_init+0x0/0x2e [pata_acpi] @ 1013
[   10.492689] initcall pacpi_init+0x0/0x2e [pata_acpi] returned 0 after 252 usecs
[   10.508687] calling  ata_generic_init+0x0/0x2e [ata_generic] @ 1014
[   10.515454] initcall ata_generic_init+0x0/0x2e [ata_generic] returned 0 after 289 usecs
[   10.529074] calling  wait_scan_init+0x0/0x1b [scsi_wait_scan] @ 1015
[   10.535584] initcall wait_scan_init+0x0/0x1b [scsi_wait_scan] returned 0 after 3 usecs
[   10.820025] kjournald starting.  Commit interval 5 seconds
[   10.820186] EXT3-fs (sda6): mounted filesystem with writeback data mode
[   11.234394] modprobe used greatest stack depth: 3736 bytes left
[   13.384777] udev: starting version 141
[   13.388793] udev: deprecated sysfs layout; update the kernel or disable CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
[   14.223658] calling  cdrom_init+0x0/0x1b [cdrom] @ 1175
[   14.258157] initcall cdrom_init+0x0/0x1b [cdrom] returned 0 after 28397 usecs
[   14.466576] calling  init_sr+0x0/0x72 [sr_mod] @ 1175
[   14.499310] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   14.506362] Uniform CD-ROM driver Revision: 3.20
[   14.554837] sr 0:0:0:0: Attached scsi CD-ROM sr0
[   14.591371] initcall init_sr+0x0/0x72 [sr_mod] returned 0 after 116748 usecs
[   17.313994] calling  agp_intel_init+0x0/0x45 [intel_agp] @ 1991
[   17.326472] calling  hwmon_init+0x0/0x186 [hwmon] @ 1988
[   17.342259] initcall hwmon_init+0x0/0x186 [hwmon] returned 0 after 10031 usecs
[   17.384820] calling  thermal_init+0x0/0x88 [thermal_sys] @ 1985
[   17.391526] agpgart-intel 0000:00:00.0: Intel 945G Chipset
[   17.415535] initcall thermal_init+0x0/0x88 [thermal_sys] returned 0 after 23875 usecs
[   17.464393] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[   17.496104] calling  acpi_processor_init+0x0/0x159 [processor] @ 1983
[   17.503454] calling  acpi_button_init+0x0/0x7d [button] @ 1987
[   17.509837] calling  acpi_thermal_init+0x0/0xb7 [thermal] @ 1994
[   17.519912] input: Power Button as /class/input/input0
[   17.534352] initcall acpi_thermal_init+0x0/0xb7 [thermal] returned 0 after 17869 usecs
[   17.558203] ACPI: Power Button [VBTN]
[   17.571561] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[   17.586976] input: Power Button as /class/input/input1
[   17.624070] ACPI: Power Button [PWRF]
[   17.629955] initcall acpi_processor_init+0x0/0x159 [processor] returned 0 after 124227 usecs
[   17.638935] initcall agp_intel_init+0x0/0x45 [intel_agp] returned 0 after 311332 usecs
[   17.682686] initcall acpi_button_init+0x0/0x7d [button] returned 0 after 169171 usecs
[   17.708718] calling  parport_default_proc_register+0x0/0x29 [parport] @ 2068
[   17.717598] calling  rtc_init+0x0/0xa0 [rtc_core] @ 2071
[   17.743225] initcall rtc_init+0x0/0xa0 [rtc_core] returned 0 after 19671 usecs
[   17.753327] initcall parport_default_proc_register+0x0/0x29 [parport] returned 0 after 36478 usecs
[   17.823374] calling  parport_pc_init+0x0/0x7fa [parport_pc] @ 2068
[   17.857098] parport_pc 00:06: reported by Plug and Play ACPI
[   17.860683] calling  init_sg+0x0/0x1a7 [sg] @ 2112
[   17.861388] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   17.861634] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   17.861752] initcall init_sg+0x0/0x1a7 [sg] returned 0 after 1033 usecs
[   17.897738] calling  mod_init+0x0/0x383 [intel_rng] @ 2097
[   17.918560] calling  pcspkr_init+0x0/0x20 [pcspkr] @ 2129
[   17.930492] intel_rng: Firmware space is locked read-only. If you can't or
[   17.930496] intel_rng: don't want to disable this in firmware setup, and if
[   17.930497] intel_rng: you are certain that your system has a functional
[   17.930499] intel_rng: RNG, try using the 'no_fwh_detect' option.
[   17.934687] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
[   17.937826] input: PC Speaker as /class/input/input2
[   17.937970] initcall pcspkr_init+0x0/0x20 [pcspkr] returned 0 after 13480 usecs
[   17.979014] initcall mod_init+0x0/0x383 [intel_rng] returned -16 after 73840 usecs
[   17.986823] initcall mod_init+0x0/0x383 [intel_rng] returned with error code -16 
[   18.023800] calling  iTCO_vendor_init_module+0x0/0x2a [iTCO_vendor_support] @ 2097
[   18.024361] initcall parport_pc_init+0x0/0x7fa [parport_pc] returned 0 after 190053 usecs
[   18.039967] iTCO_vendor_support: vendor-support=0
[   18.044808] initcall iTCO_vendor_init_module+0x0/0x2a [iTCO_vendor_support] returned 0 after 4722 usecs
[   18.130190] calling  ppdev_init+0x0/0x128 [ppdev] @ 2188
[   18.140633] ppdev: user-space parallel port driver
[   18.141719] calling  evdev_init+0x0/0x20 [evdev] @ 2172
[   18.142545] initcall evdev_init+0x0/0x20 [evdev] returned 0 after 796 usecs
[   18.158238] initcall ppdev_init+0x0/0x128 [ppdev] returned 0 after 22021 usecs
[   18.199630] calling  i2c_i801_init+0x0/0x106 [i2c_i801] @ 2111
[   18.206228] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   18.214528] initcall i2c_i801_init+0x0/0x106 [i2c_i801] returned 0 after 8656 usecs
[   18.261834] calling  cmos_init+0x0/0xad [rtc_cmos] @ 2071
[   18.267450] rtc_cmos 00:05: RTC can wake from S4
[   18.275487] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[   18.277986] calling  serio_raw_init+0x0/0x2e [serio_raw] @ 2141
[   18.278153] initcall serio_raw_init+0x0/0x2e [serio_raw] returned 0 after 153 usecs
[   18.281287] calling  iTCO_wdt_init_module+0x0/0x9b [iTCO_wdt] @ 2097
[   18.281291] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   18.281773] iTCO_wdt: unable to reset NO_REBOOT flag, platform may have disabled it
[   18.281869] initcall iTCO_wdt_init_module+0x0/0x9b [iTCO_wdt] returned 0 after 559 usecs
[   18.284646] calling  snd_mem_init+0x0/0x3a [snd_page_alloc] @ 2104
[   18.284687] initcall snd_mem_init+0x0/0x3a [snd_page_alloc] returned 0 after 30 usecs
[   18.314219] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[   18.314229] IP: [<ffffffffa02ea9e9>] cmos_update_irq_enable+0x21/0xa5 [rtc_cmos]
[   18.314243] PGD 7d0b7067 PUD 7dab5067 PMD 0 
[   18.314250] Oops: 0000 [#1] SMP 
[   18.314254] last sysfs file: /sys/class/rtc/rtc0/dev
[   18.314259] CPU 0 
[   18.314261] Modules linked in: iTCO_wdt serio_raw snd_page_alloc rtc_cmos(+) i2c_i801 evdev ppdev iTCO_vendor_support pcspkr sg parport_pc rtc_core parport rng_core rtc_lib thermal button processor thermal_sys hwmon intel_agp sr_mod cdrom ata_generic pata_acpi ata_piix libata ide_pci_generic ide_core sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core ehci_hcd usbcore nls_base [last unloaded: scsi_wait_scan]
[   18.314312] 
[   18.314317] Pid: 2243, comm: hwclock Not tainted 2.6.34-rc7 #1 0HH807/OptiPlex GX620               
[   18.314321] RIP: 0010:[<ffffffffa02ea9e9>]  [<ffffffffa02ea9e9>] cmos_update_irq_enable+0x21/0xa5 [rtc_cmos]
[   18.314331] RSP: 0018:ffff88007d37dd78  EFLAGS: 00010212
[   18.314334] RAX: 0000000000000000 RBX: ffff88007a4edb18 RCX: 0000000000000000
[   18.314338] RDX: ffff88007a4edf20 RSI: 0000000000000000 RDI: ffff88007e8452d0
[   18.314341] RBP: ffff88007d37dd98 R08: 0000000000000000 R09: 0000000000000000
[   18.314344] R10: 0000000000000000 R11: ffffffffa016aaec R12: 0000000000000000
[   18.314348] R13: 0000000000000000 R14: 0000000000007004 R15: ffffffffa02ec1a0
[   18.314352] FS:  00007f3a5c1d56f0(0000) GS:ffff880005400000(0000) knlGS:0000000000000000
[   18.314356] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   18.314359] CR2: 0000000000000010 CR3: 000000007d95e000 CR4: 00000000000006f0
[   18.314363] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   18.314367] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   18.314371] Process hwclock (pid: 2243, threadinfo ffff88007d37c000, task ffff88007d51c620)
[   18.314374] Stack:
[   18.314376]  ffff88007d37dd98 ffff88007a4edb18 0000000000000000 ffff88007a4eded8
[   18.314382] <0> ffff88007d37ddd8 ffffffffa016ab7a 0000000000007004 ffff88007a4edb18
[   18.314388] <0> ffff88007a4eded8 ffff88007a4edb18 ffff88007a4eded8 0000000000000000
[   18.314397] Call Trace:
[   18.314406]  [<ffffffffa016ab7a>] rtc_update_irq_enable+0xbe/0x103 [rtc_core]
[   18.314415]  [<ffffffffa016bdd0>] rtc_dev_ioctl+0x5e7/0x75b [rtc_core]
[   18.314425]  [<ffffffff81092ef3>] ? lockstat_clock+0x18/0x21
[   18.314432]  [<ffffffff81095312>] ? __lock_acquire+0x32c/0x6d2
[   18.314438]  [<ffffffff81084032>] ? sched_clock_local+0x1a/0xc0
[   18.314446]  [<ffffffffa016bf6f>] rtc_dev_release+0x2b/0x95 [rtc_core]
[   18.314452]  [<ffffffff81160fee>] __fput+0x1a6/0x2be
[   18.314457]  [<ffffffff81161135>] fput+0x2f/0x38
[   18.314463]  [<ffffffff8115c948>] filp_close+0xa0/0xb1
[   18.314468]  [<ffffffff8115ca34>] sys_close+0xdb/0x131
[   18.314474]  [<ffffffff8100371b>] system_call_fastpath+0x16/0x1b
[   18.314477] Code: c0 41 59 5b 41 5c 41 5d c9 c3 55 48 89 e5 41 55 41 54 53 48 83 ec 08 0f 1f 44 00 00 48 ff 05 37 2a 00 00 41 89 f5 e8 33 8e 03 e1 <83> 78 10 00 48 89 c3 7f 0e 48 ff 05 2f 2a 00 00 b8 ea ff ff ff 
[   18.314527] RIP  [<ffffffffa02ea9e9>] cmos_update_irq_enable+0x21/0xa5 [rtc_cmos]
[   18.314536]  RSP <ffff88007d37dd78>
[   18.314538] CR2: 0000000000000010
[   18.314543] ---[ end trace 242733edcec1d4a0 ]---
[   18.360513] calling  leds_init+0x0/0x60 [led_class] @ 2097
[   18.360605] initcall leds_init+0x0/0x60 [led_class] returned 0 after 81 usecs
[   18.403126] calling  init_soundcore+0x0/0xd9 [soundcore] @ 2104
[   18.403253] initcall init_soundcore+0x0/0xd9 [soundcore] returned 0 after 114 usecs
[   18.677126] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[   18.684111] initcall cmos_init+0x0/0xad [rtc_cmos] returned 0 after 406964 usecs
[   18.710661] calling  nas_gpio_init+0x0/0x31f [leds_ss4200] @ 2097
[   18.713264] calling  hid_init+0x0/0x149 [usbhid] @ 2187
[   18.715046] usbcore: registered new interface driver hiddev
[   18.719238] input: Dell Dell USB Keyboard as /class/input/input3
[   18.719766] generic-usb 0003:413C:2010.0001: input,hidraw0: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.1-1.1/input0
[   18.725936] input: Dell Dell USB Keyboard as /class/input/input4
[   18.726438] generic-usb 0003:413C:2010.0002: input,hidraw1: USB HID v1.10 Device [Dell Dell USB Keyboard] on usb-0000:00:1d.1-1.1/input1
[   18.740094] input: Logitech Optical USB Mouse as /class/input/input5
[   18.740759] generic-usb 0003:046D:C016.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.1-1.3/input0
[   18.740914] usbcore: registered new interface driver usbhid
[   18.740918] usbhid: USB HID core driver
[   18.740933] initcall hid_init+0x0/0x149 [usbhid] returned 0 after 27005 usecs
[   18.779480] calling  psmouse_init+0x0/0xc1 [psmouse] @ 2141
[   18.786493] initcall psmouse_init+0x0/0xc1 [psmouse] returned 0 after 6829 usecs
[   18.816379] leds_ss4200: no LED devices found
[   18.820840] initcall nas_gpio_init+0x0/0x31f [leds_ss4200] returned -19 after 4353 usecs
[   18.827828] calling  alsa_sound_init+0x0/0xce [snd] @ 2104
[   18.828038] initcall alsa_sound_init+0x0/0xce [snd] returned 0 after 189 usecs
[   18.844222] calling  joydev_init+0x0/0x20 [joydev] @ 2260
[   18.852499] initcall joydev_init+0x0/0x20 [joydev] returned 0 after 2233 usecs
[   18.873831] calling  alsa_timer_init+0x0/0x21d [snd_timer] @ 2104
[   18.886541] initcall alsa_timer_init+0x0/0x21d [snd_timer] returned 0 after 6280 usecs
[   18.986638] calling  alsa_pcm_init+0x0/0xa9 [snd_pcm] @ 2294
[   18.992446] initcall alsa_pcm_init+0x0/0xa9 [snd_pcm] returned 0 after 30 usecs
[   19.029010] calling  alsa_seq_device_init+0x0/0x87 [snd_seq_device] @ 2303
[   19.036209] initcall alsa_seq_device_init+0x0/0x87 [snd_seq_device] returned 0 after 138 usecs
[   19.113275] calling  alsa_seq_init+0x0/0xae [snd_seq] @ 2303
[   19.119516] initcall alsa_seq_init+0x0/0xae [snd_seq] returned 0 after 450 usecs
[   19.152967] calling  ac97_bus_init+0x0/0x20 [ac97_bus] @ 2104
[   19.158978] initcall ac97_bus_init+0x0/0x20 [ac97_bus] returned 0 after 127 usecs
[   19.241199] calling  alsa_ac97_init+0x0/0xf [snd_ac97_codec] @ 2104
[   19.247596] initcall alsa_ac97_init+0x0/0xf [snd_ac97_codec] returned 0 after 0 usecs
[   19.287342] calling  alsa_card_intel8x0_init+0x0/0x2e [snd_intel8x0] @ 2104
[   19.294684] Intel ICH 0000:00:1e.2: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   19.302154] Intel ICH 0000:00:1e.2: setting latency timer to 64
[   19.672959] intel8x0: white list rate for 1028:01ad is 48000
[   19.684525] initcall alsa_card_intel8x0_init+0x0/0x2e [snd_intel8x0] returned 0 after 380917 usecs
[   19.792044] calling  uinput_init+0x0/0x20 [uinput] @ 2322
[   19.799039] initcall uinput_init+0x0/0x20 [uinput] returned 0 after 1402 usecs
[   19.868701] calling  wait_scan_init+0x0/0x1b [scsi_wait_scan] @ 2335
[   19.875217] initcall wait_scan_init+0x0/0x1b [scsi_wait_scan] returned 0 after 2 usecs
[   22.131820] EXT3-fs (sda6): using internal journal
[   22.414802] kjournald starting.  Commit interval 5 seconds
[   22.420795] EXT3-fs (sda1): using internal journal
[   22.425802] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   22.509111] kjournald starting.  Commit interval 5 seconds
[   22.509431] EXT3-fs (sda3): using internal journal
[   22.509444] EXT3-fs (sda3): mounted filesystem with writeback data mode
[   22.557773] kjournald starting.  Commit interval 5 seconds
[   22.558071] EXT3-fs (sda5): using internal journal
[   22.558084] EXT3-fs (sda5): mounted filesystem with writeback data mode
[   23.777643] Adding 4194300k swap on /dev/sda2.  Priority:-1 extents:1 across:4194300k 
[   29.357517] calling  acpi_cpufreq_init+0x0/0x12c [acpi_cpufreq] @ 2487
[   29.364277] initcall acpi_cpufreq_init+0x0/0x12c [acpi_cpufreq] returned -19 after 82 usecs
[   29.428750] calling  cpufreq_p4_init+0x0/0x8f [p4_clockmod] @ 2498
[   29.435160] ondemand governor failed, too long transition latency of HW, fallback to performance governor
[   29.445072] ondemand governor failed, too long transition latency of HW, fallback to performance governor
[   29.454914] p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
[   29.462175] initcall cpufreq_p4_init+0x0/0x8f [p4_clockmod] returned 0 after 26460 usecs
[   29.956005] calling  inet6_init+0x0/0x4ff [ipv6] @ 2528
[   29.963896] NET: Registered protocol family 10
[   29.987055] lo: Disabled Privacy Extensions
[   29.994053] initcall inet6_init+0x0/0x4ff [ipv6] returned 0 after 31848 usecs
[   33.528407] calling  rfkill_init+0x0/0x9b [rfkill] @ 2909
[   33.537348] initcall rfkill_init+0x0/0x9b [rfkill] returned 0 after 3276 usecs
[   33.717373] calling  bt_init+0x0/0x9b [bluetooth] @ 2909
[   33.722819] Bluetooth: Core ver 2.15
[   33.726927] NET: Registered protocol family 31
[   33.731517] Bluetooth: HCI device and connection manager initialized
[   33.738016] Bluetooth: HCI socket layer initialized
[   33.743047] initcall bt_init+0x0/0x9b [bluetooth] returned 0 after 19743 usecs
[   33.789763] calling  l2cap_init+0x0/0x178 [l2cap] @ 2949
[   33.796186] Bluetooth: L2CAP ver 2.14
[   33.800428] Bluetooth: L2CAP socket layer initialized
[   33.806833] initcall l2cap_init+0x0/0x178 [l2cap] returned 0 after 11249 usecs
[   33.864963] calling  bnep_init+0x0/0xca [bnep] @ 2959
[   33.870186] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   33.875636] Bluetooth: BNEP filters: protocol multicast
[   33.881057] initcall bnep_init+0x0/0xca [bnep] returned 0 after 10610 usecs
[   33.934997] calling  llc_init+0x0/0x6d [llc] @ 2972
[   33.940078] initcall llc_init+0x0/0x6d [llc] returned 0 after 2 usecs
[   34.207173] calling  br_init+0x0/0x136 [bridge] @ 2972
[   34.214648] initcall br_init+0x0/0x136 [bridge] returned 0 after 2139 usecs
[   34.263850] calling  sco_init+0x0/0x17f [sco] @ 3014
[   34.270248] Bluetooth: SCO (Voice Link) ver 0.6
[   34.274908] Bluetooth: SCO socket layer initialized
[   34.279903] initcall sco_init+0x0/0x17f [sco] returned 0 after 10655 usecs
[   34.564923] virbr0: starting userspace STP failed, starting kernel STP
[   37.037442] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   38.689027] tg3 0000:02:00.0: eth0: Link is up at 100 Mbps, full duplex
[   38.689248] tg3 0000:02:00.0: eth0: Flow control is on for TX and on for RX
[   38.689248] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   49.336036] eth0: no IPv6 routers present
[  180.051546] calling  init_parport_cs+0x0/0x20 [parport_cs] @ 3511
[  180.060051] initcall init_parport_cs+0x0/0x20 [parport_cs] returned 0 after 311 usecs

--------------070809010500060306020209
Content-Type: text/plain;
 name="config-2634-rc7"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-2634-rc7"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.34-rc7
# Sun May  9 20:49:41 2010
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
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
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_EARLY_RES=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_TINY_RCU is not set
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
# CONFIG_NAMESPACES is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_PERF_COUNTERS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
# CONFIG_OPTPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_SLOW_WORK=y
# CONFIG_SLOW_WORK_DEBUG is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
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
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_SPARSE_IRQ=y
CONFIG_NUMA_IRQ_DESC=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_NO_BOOTMEM is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=7
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
# CONFIG_K8_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=9
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION_NVS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_RUNTIME=y
CONFIG_PM_OPS=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_POWER_METER=m
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=m
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
# CONFIG_DMAR_DEFAULT_ON is not set
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_INTR_REMAP=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_STUB=m
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=m
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
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
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
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
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
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
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
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
CONFIG_RDS=m
CONFIG_RDS_TCP=m
# CONFIG_RDS_DEBUG is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
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
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
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
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=m
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
CONFIG_PARIDE_PT=m
CONFIG_PARIDE_PG=m

#
# Parallel IDE protocol modules
#
# CONFIG_PARIDE_ATEN is not set
# CONFIG_PARIDE_BPCK is not set
# CONFIG_PARIDE_COMM is not set
# CONFIG_PARIDE_DSTR is not set
# CONFIG_PARIDE_FIT2 is not set
# CONFIG_PARIDE_FIT3 is not set
# CONFIG_PARIDE_EPAT is not set
# CONFIG_PARIDE_EPIA is not set
# CONFIG_PARIDE_FRIQ is not set
# CONFIG_PARIDE_FRPW is not set
# CONFIG_PARIDE_KBIC is not set
# CONFIG_PARIDE_KTTI is not set
# CONFIG_PARIDE_ON20 is not set
# CONFIG_PARIDE_ON26 is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_TIFM_CORE=m
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
CONFIG_IWMC3200TOP=m
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECS=m
CONFIG_BLK_DEV_DELKIN=m
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=m
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=m
CONFIG_BLK_DEV_CMD640=m
CONFIG_BLK_DEV_CMD640_ENHANCED=y
CONFIG_BLK_DEV_IDEPNP=m
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=m
CONFIG_BLK_DEV_OPTI621=m
CONFIG_BLK_DEV_RZ1000=m
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
CONFIG_BLK_DEV_ALI15X3=m
CONFIG_BLK_DEV_AMD74XX=m
CONFIG_BLK_DEV_ATIIXP=m
CONFIG_BLK_DEV_CMD64X=m
CONFIG_BLK_DEV_TRIFLEX=m
CONFIG_BLK_DEV_CS5520=m
CONFIG_BLK_DEV_CS5530=m
CONFIG_BLK_DEV_HPT366=m
CONFIG_BLK_DEV_JMICRON=m
CONFIG_BLK_DEV_SC1200=m
CONFIG_BLK_DEV_PIIX=m
CONFIG_BLK_DEV_IT8172=m
CONFIG_BLK_DEV_IT8213=m
CONFIG_BLK_DEV_IT821X=m
CONFIG_BLK_DEV_NS87415=m
CONFIG_BLK_DEV_PDC202XX_OLD=m
CONFIG_BLK_DEV_PDC202XX_NEW=m
CONFIG_BLK_DEV_SVWKS=m
CONFIG_BLK_DEV_SIIMAGE=m
CONFIG_BLK_DEV_SIS5513=m
CONFIG_BLK_DEV_SLC90E66=m
CONFIG_BLK_DEV_TRM290=m
CONFIG_BLK_DEV_VIA82CXXX=m
CONFIG_BLK_DEV_TC86C001=m
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
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
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
# CONFIG_SCSI_BNX2_ISCSI is not set
CONFIG_BE2ISCSI=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=m
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=m
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_DPT_I2O=m
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_ARCMSR=m
CONFIG_SCSI_ARCMSR_AER=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=m
CONFIG_VMWARE_PVSCSI=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=m
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_EATA=m
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=m
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
CONFIG_SCSI_IZIP_EPP16=y
CONFIG_SCSI_IZIP_SLOW_CTR=y
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=m
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=m
CONFIG_SCSI_LPFC_DEBUG_FS=y
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_PMCRAID=m
CONFIG_SCSI_PM8001=m
CONFIG_SCSI_SRP=m
CONFIG_SCSI_BFA_FC=m
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=m
CONFIG_ATA_PIIX=m
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SX4=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m
CONFIG_SATA_INIC162X=m
CONFIG_PATA_ACPI=m
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATP867X=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_CMD640_PCI=m
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
CONFIG_PATA_CS5530=m
CONFIG_PATA_CYPRESS=m
CONFIG_PATA_EFAR=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_IT821X=m
CONFIG_PATA_IT8213=m
CONFIG_PATA_JMICRON=m
# CONFIG_PATA_LEGACY is not set
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_MPIIX=m
CONFIG_PATA_OLDPIIX=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
CONFIG_PATA_NS87410=m
CONFIG_PATA_NS87415=m
CONFIG_PATA_OPTI=m
CONFIG_PATA_OPTIDMA=m
CONFIG_PATA_PCMCIA=m
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_PDC_OLD=m
CONFIG_PATA_RADISYS=m
CONFIG_PATA_RDC=m
CONFIG_PATA_RZ1000=m
CONFIG_PATA_SC1200=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_TOSHIBA=m
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=m
# CONFIG_PATA_PLATFORM is not set
CONFIG_PATA_SCH=m
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# The newer stack is recommended.
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
CONFIG_IEEE1394=m
CONFIG_IEEE1394_OHCI1394=m
CONFIG_IEEE1394_PCILYNX=m
CONFIG_IEEE1394_SBP2=m
CONFIG_IEEE1394_SBP2_PHYS_DMA=y
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_DV1394=m
CONFIG_IEEE1394_VERBOSEDEBUG=y
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_MACVLAN=m
# CONFIG_MACVTAP is not set
CONFIG_EQUALIZER=m
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_NET_SB1000=m
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

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
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_ENC28J60=m
CONFIG_ENC28J60_WRITEVERIFY=y
CONFIG_ETHOC=m
CONFIG_DNET=m
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
CONFIG_ADAPTEC_STARFIRE=m
# CONFIG_KSZ884X_PCI is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
CONFIG_E100=m
# CONFIG_FEALNX is not set
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
CONFIG_SIS900=m
CONFIG_EPIC100=m
CONFIG_SMSC9420=m
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
CONFIG_KS8851_MLL=m
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
# CONFIG_SC92031 is not set
CONFIG_NET_POCKET=y
CONFIG_ATP=m
CONFIG_DE600=m
CONFIG_DE620=m
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
CONFIG_ACENIC_OMIT_TIGON_I=y
CONFIG_DL2K=m
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_IP1000=m
CONFIG_IGB=m
CONFIG_IGBVF=m
CONFIG_NS83820=m
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
CONFIG_SIS190=m
CONFIG_SKGE=m
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
CONFIG_QLA3XXX=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_JME=m
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=m
CONFIG_LIBERTAS_THINFIRM=m
CONFIG_LIBERTAS_THINFIRM_USB=m
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
CONFIG_MAC80211_HWSIM=m
CONFIG_MWL8K=m
CONFIG_ATH_COMMON=m
# CONFIG_ATH_DEBUG is not set
CONFIG_ATH5K=m
# CONFIG_ATH5K_DEBUG is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K=m
CONFIG_ATH9K_DEBUGFS=y
CONFIG_AR9170_USB=m
CONFIG_AR9170_LEDS=y
CONFIG_B43=m
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
CONFIG_B43_SDIO=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_LP=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
# CONFIG_B43LEGACY_DEBUG is not set
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
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
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLWIFI_DEVICE_TRACING=y
CONFIG_IWLAGN=m
CONFIG_IWL4965=y
CONFIG_IWL5000=y
CONFIG_IWL3945=m
CONFIG_IWM=m
# CONFIG_IWM_DEBUG is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_CS=m
CONFIG_LIBERTAS_SDIO=m
CONFIG_LIBERTAS_SPI=m
# CONFIG_LIBERTAS_DEBUG is not set
# CONFIG_LIBERTAS_MESH is not set
CONFIG_HERMES=m
CONFIG_HERMES_CACHE_FW_ON_INIT=y
CONFIG_PLX_HERMES=m
CONFIG_TMD_HERMES=m
CONFIG_NORTEL_HERMES=m
CONFIG_PCI_HERMES=m
CONFIG_PCMCIA_HERMES=m
CONFIG_PCMCIA_SPECTRUM=m
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
CONFIG_P54_SPI=m
CONFIG_P54_LEDS=y
CONFIG_RT2X00=m
CONFIG_RT2400PCI=m
CONFIG_RT2500PCI=m
CONFIG_RT61PCI=m
CONFIG_RT2800PCI_PCI=y
CONFIG_RT2800PCI=m
# CONFIG_RT2800PCI_RT30XX is not set
# CONFIG_RT2800PCI_RT35XX is not set
CONFIG_RT2500USB=m
CONFIG_RT73USB=m
CONFIG_RT2800USB=m
# CONFIG_RT2800USB_RT30XX is not set
# CONFIG_RT2800USB_RT35XX is not set
# CONFIG_RT2800USB_UNKNOWN is not set
CONFIG_RT2800_LIB=m
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_HT=y
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2X00_LIB_DEBUGFS=y
# CONFIG_RT2X00_DEBUG is not set
CONFIG_WL12XX=m
CONFIG_WL1251=m
CONFIG_WL1251_SPI=m
CONFIG_WL1251_SDIO=m
CONFIG_WL1271=m
CONFIG_ZD1211RW=m
# CONFIG_ZD1211RW_DEBUG is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_SDIO=m
CONFIG_WIMAX_IWMC3200_SDIO=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8

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
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SMSC75XX is not set
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
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=m
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=m
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=m
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_PCMCIA_PCNET=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_PCMCIA_SMC91C92=m
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_PCMCIA_AXNET=m
# CONFIG_WAN is not set
CONFIG_FDDI=m
CONFIG_DEFXX=m
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=m
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=m
CONFIG_ROADRUNNER_LARGE_RINGS=y
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOL2TP=m
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VMXNET3=m
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
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ATKBD=y
CONFIG_QT2160=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_MATRIX=m
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_GPIO=m
CONFIG_MOUSE_SYNAPTICS_I2C=m
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
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_JOYSTICK_WALKERA0701=m
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
CONFIG_TOUCHSCREEN_AD7877=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
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
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC5UH=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_WINBOND_CIR=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m

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
CONFIG_SERIO_ALTERA_PS2=m
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
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

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
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

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
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=m
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_GPIO=m
CONFIG_SPI_LM70_LLP=m
CONFIG_SPI_XILINX=m
CONFIG_SPI_XILINX_PLTFM=m
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=m

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=m

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO expanders:
#
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_SCH is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
CONFIG_GPIO_LANGWELL=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=m
CONFIG_GPIO_MCP23S08=m
CONFIG_GPIO_MC33880=m

#
# AC97 GPIO expanders:
#
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM73=m
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
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_MAX1111=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
CONFIG_SENSORS_LIS3_I2C=m
CONFIG_SENSORS_APPLESMC=m

#
# ACPI drivers
#
CONFIG_SENSORS_ATK0110=m
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
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
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_TPS65010 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13783 is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_AB4500_CORE is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_IR_CORE=m
CONFIG_VIDEO_IR=m
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_VPX3220=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BWQCAM=m
CONFIG_VIDEO_CQCAM=m
CONFIG_VIDEO_W9966=m
CONFIG_VIDEO_CPIA=m
CONFIG_VIDEO_CPIA_PP=m
CONFIG_VIDEO_CPIA_USB=m
CONFIG_VIDEO_CPIA2=m
CONFIG_VIDEO_SAA5246A=m
CONFIG_VIDEO_SAA5249=m
CONFIG_VIDEO_STRADIS=m
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
CONFIG_VIDEO_ZORAN_LML33=m
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_MXB=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_CAFE_CCIC=m
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_MT9M001=m
CONFIG_SOC_CAMERA_MT9M111=m
CONFIG_SOC_CAMERA_MT9T031=m
CONFIG_SOC_CAMERA_MT9T112=m
CONFIG_SOC_CAMERA_MT9V022=m
CONFIG_SOC_CAMERA_RJ54N1=m
CONFIG_SOC_CAMERA_TW9910=m
CONFIG_SOC_CAMERA_PLATFORM=m
CONFIG_SOC_CAMERA_OV772X=m
CONFIG_SOC_CAMERA_OV9640=m
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
# CONFIG_USB_GSPCA_BENQ is not set
CONFIG_USB_GSPCA_CONEX=m
# CONFIG_USB_GSPCA_CPIA1 is not set
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
# CONFIG_USB_GSPCA_OV534_9 is not set
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
# CONFIG_USB_GSPCA_SN9C2028 is not set
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SN9C20X_EVDEV=y
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_STK014=m
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_USBVISION=m
CONFIG_VIDEO_USBVIDEO=m
CONFIG_USB_VICAM=m
CONFIG_USB_IBMCAM=m
CONFIG_USB_KONICAWC=m
CONFIG_USB_QUICKCAM_MESSENGER=m
CONFIG_USB_ET61X251=m
CONFIG_VIDEO_OVCAMCHIP=m
CONFIG_USB_W9968CF=m
CONFIG_USB_OV511=m
CONFIG_USB_SE401=m
CONFIG_USB_SN9C102=m
CONFIG_USB_STV680=m
CONFIG_USB_ZC0301=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=m
CONFIG_AGP_SIS=m
CONFIG_AGP_VIA=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_TTM=m
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_KMS=y
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=m
CONFIG_FB_ARC=m
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=m
CONFIG_FB_UVESA=m
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
CONFIG_FB_HGA_ACCEL=y
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
# CONFIG_FB_INTEL is not set
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=m
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=m
CONFIG_FB_GEODE_GX=m
CONFIG_FB_GEODE_GX1=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_BROADSHEET=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=m
CONFIG_LCD_LTV350QV=m
CONFIG_LCD_ILI9320=m
CONFIG_LCD_TDO24M=m
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_PROGEAR=m
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_MBP_NVIDIA=m
CONFIG_BACKLIGHT_SAHARA=m

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
CONFIG_FONT_7x14=y
CONFIG_FONT_PEARL_8x8=y
CONFIG_FONT_ACORN_8x8=y
CONFIG_FONT_MINI_4x6=y
CONFIG_FONT_SUN8x16=y
CONFIG_FONT_SUN12x22=y
CONFIG_FONT_10x18=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
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
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
CONFIG_SND_AW2=m
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
CONFIG_SND_BT87X_OVERCLOCK=y
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
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
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
CONFIG_SND_FM801=m
CONFIG_SND_FM801_TEA575X_BOOL=y
CONFIG_SND_FM801_TEA575X=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_HIFIER=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
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
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_UA101 is not set
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=m
CONFIG_SOUND_OSS=m
CONFIG_SOUND_TRACEINIT=y
CONFIG_SOUND_DMAP=y
CONFIG_SOUND_VMIDI=m
CONFIG_SOUND_TRIX=m
CONFIG_SOUND_MSS=m
CONFIG_SOUND_MPU401=m
CONFIG_SOUND_PAS=m
CONFIG_SOUND_PSS=m
CONFIG_PSS_MIXER=y
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
CONFIG_SOUND_UART6850=m
CONFIG_SOUND_AEDSP16=m
CONFIG_SC6600=y
CONFIG_SC6600_JOY=y
CONFIG_SC6600_CDROM=4
CONFIG_SC6600_CDROMBASE=0
CONFIG_SOUND_KAHLUA=m
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set

#
# Special HID drivers
#
# CONFIG_HID_3M_PCT is not set
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MOSART is not set
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_NTRIG=m
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_STANTUM is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=m
# CONFIG_HID_ZEROPLUS is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=m
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_HCD_DEBUGGING=y
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OXU210HP_HCD=m
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_CS=m
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_WHCI_HCD=m
CONFIG_USB_HWA_HCD=m

#
# Enable Host or Gadget support to see Inventra options
#

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
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
CONFIG_USB_LIBUSUAL=y

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
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIEMENS_MPI=m
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
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
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_NOP_USB_XCEIV=m
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_WLP=m
CONFIG_UWB_I1480U=m
CONFIG_UWB_I1480U_WLP=m
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_UNSAFE_RESUME=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SPI=m
CONFIG_MMC_SDRICOH_CS=m
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_ALIX2=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_GPIO_PLATFORM=y
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_DAC124S085=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

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
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=m
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

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
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

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
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
# CONFIG_EXOFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="iso8859-1"
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
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_DETECTOR=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BOOT_TRACER=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_KSYM_TRACER is not set
CONFIG_STACK_TRACER=y
CONFIG_KMEMTRACE=y
CONFIG_WORKQUEUE_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=m
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=m
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_INTEL_TXT is not set
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_IMA is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

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
CONFIG_CRYPTO_FPU=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
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
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

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
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_NLATTR=y

--------------070809010500060306020209--
