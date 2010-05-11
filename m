Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab0EKU5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:57:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63768 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab0EKU5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:57:43 -0400
Message-ID: <4BE9C469.2020901@oracle.com>
Date: Tue, 11 May 2010 13:56:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: David Airlie <airlied@linux.ie>, Dave Jones <davej@redhat.com>
Subject: BUG: amd64-agp (2.6.34-rc7)
Content-Type: multipart/mixed;
 boundary="------------070002050008000808000304"
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4BE9C4B1.0170:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070002050008000808000304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[  482.226941] calling  agp_amd64_mod_init+0x0/0x19 [amd64_agp] @ 3555
[  482.235968] initcall agp_amd64_mod_init+0x0/0x19 [amd64_agp] returned -19 after 705 usecs
[  484.289804] calling  agp_amd64_mod_init+0x0/0x19 [amd64_agp] @ 3566
[  484.298287] BUG: unable to handle kernel paging request at 000000000000369a
[  484.299128] IP: [<ffffffff811ea6e2>] kobject_put+0x1f/0x75
[  484.299128] PGD 75f2a067 PUD 74876067 PMD 0 
[  484.299128] Oops: 0000 [#1] SMP

Full kernel message log & config file are attached.

BUG happens on the second module load.
The test system does not have this hardware.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

--------------070002050008000808000304
Content-Type: text/plain;
 name="amd64-agp.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="amd64-agp.log"

[    0.000000] Linux version 2.6.34-rc7 (rdunlap@control.site) (gcc version 4.4.1 20090725 (Red Hat 4.4.1-2) (GCC) ) #2 SMP Tue May 11 11:55:41 PDT 2010
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
[    0.000000] RAMDISK: 37c1b000 - 37ff0000
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
[    0.000000]   NODE_DATA [0000000002622240 - 000000000263623f]
[    0.000000]   bootmap [0000000002637000 -  0000000002646ed7] pages 10
[    0.000000] (13/32 early reservations) ==> bootmem [0000000000 - 007f686000]
[    0.000000]   #0 [0001000000 - 0002621250]    TEXT DATA BSS ==> [0001000000 - 0002621250]
[    0.000000]   #1 [0037c1b000 - 0037ff0000]          RAMDISK ==> [0037c1b000 - 0037ff0000]
[    0.000000]   #2 [0002622000 - 000262221c]              BRK ==> [0002622000 - 000262221c]
[    0.000000]   #3 [00000fe720 - 0000100000]    BIOS reserved ==> [00000fe720 - 0000100000]
[    0.000000]   #4 [00000fe710 - 00000fe720]     MP-table mpf ==> [00000fe710 - 00000fe720]
[    0.000000]   #5 [000009fc00 - 00000f0000]    BIOS reserved ==> [000009fc00 - 00000f0000]
[    0.000000]   #6 [00000f0284 - 00000fe710]    BIOS reserved ==> [00000f0284 - 00000fe710]
[    0.000000]   #7 [00000f0000 - 00000f0284]     MP-table mpc ==> [00000f0000 - 00000f0284]
[    0.000000]   #8 [0000010000 - 0000012000]       TRAMPOLINE ==> [0000010000 - 0000012000]
[    0.000000]   #9 [0000012000 - 0000016000]      ACPI WAKEUP ==> [0000012000 - 0000016000]
[    0.000000]   #10 [0000016000 - 0000018000]          PGTABLE ==> [0000016000 - 0000018000]
[    0.000000]   #11 [0002622240 - 0002636240]        NODE_DATA ==> [0002622240 - 0002636240]
[    0.000000]   #12 [0002637000 - 0002647000]          BOOTMAP ==> [0002637000 - 0002647000]
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880003000000-ffff880004bfffff] on node 0
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
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff880005200000 s1915048 r8192 d22360 u2097152
[    0.000000] pcpu-alloc: s1915048 r8192 d22360 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 514512
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: ro root=/dev/sda6 selinux=0 debug ignore_loglevel initcall_debug printk.time=1 print_fatal_signals=1 kern=2634rc7 console=ttyS0,115200n8 console=tty0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 2023784k/2087448k available (4081k kernel code, 448k absent, 63216k reserved, 4771k data, 3180k init)
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
[    0.000000] Detected 2992.479 MHz processor.
[    0.003011] Calibrating delay loop (skipped), value calculated using timer frequency.. 5984.95 BogoMIPS (lpj=2992479)
[    0.006119] Security Framework initialized
[    0.007534] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.009392] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.011171] Mount-cache hash table entries: 256
[    0.013947] CPU: Physical Processor ID: 0
[    0.014008] CPU: Processor Core ID: 0
[    0.015010] mce: CPU supports 4 MCE banks
[    0.016021] CPU0: Thermal monitoring enabled (TM1)
[    0.017013] using mwait in idle threads.
[    0.018008] Performance Events: no PMU driver, software events only.
[    0.020073] ACPI: Core revision 20100121
[    0.188037] Setting APIC routing to flat
[    0.189505] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.200674] CPU0: Intel(R) Pentium(R) D CPU 3.00GHz stepping 04
[    0.203999] calling  migration_init+0x0/0x7c @ 1
[    0.204208] initcall migration_init+0x0/0x7c returned 0 after 0 usecs
[    0.205007] calling  spawn_ksoftirqd+0x0/0x7d @ 1
[    0.206133] initcall spawn_ksoftirqd+0x0/0x7d returned 0 after 0 usecs
[    0.207010] calling  init_call_single_data+0x0/0xdd @ 1
[    0.208011] initcall init_call_single_data+0x0/0xdd returned 0 after 0 usecs
[    0.209008] calling  spawn_softlockup_task+0x0/0xa8 @ 1
[    0.210117] initcall spawn_softlockup_task+0x0/0xa8 returned 0 after 0 usecs
[    0.211007] calling  relay_init+0x0/0x22 @ 1
[    0.212028] initcall relay_init+0x0/0x22 returned 0 after 0 usecs
[    0.214011] lockdep: fixing up alternatives.
[    0.215128] Booting Node   0, Processors  #1
[    0.288079] Brought up 2 CPUs
[    0.289008] Total of 2 processors activated (11969.80 BogoMIPS).
[    0.292289] devtmpfs: initialized
[    0.294304] khelper used greatest stack depth: 6144 bytes left
[    0.296658] gcov: version magic: 0x34303452
[    0.299453] calling  init_mmap_min_addr+0x0/0x1d @ 1
[    0.300009] initcall init_mmap_min_addr+0x0/0x1d returned 0 after 0 usecs
[    0.301009] calling  init_cpufreq_transition_notifier_list+0x0/0x29 @ 1
[    0.302018] initcall init_cpufreq_transition_notifier_list+0x0/0x29 returned 0 after 0 usecs
[    0.303036] calling  net_ns_init+0x0/0x24f @ 1
[    0.304026] initcall net_ns_init+0x0/0x24f returned 0 after 0 usecs
[    0.305010] calling  e820_mark_nvs_memory+0x0/0x5c @ 1
[    0.306047] initcall e820_mark_nvs_memory+0x0/0x5c returned 0 after 0 usecs
[    0.307022] calling  cpufreq_tsc+0x0/0x28 @ 1
[    0.308009] initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
[    0.309009] calling  pci_reboot_init+0x0/0x22 @ 1
[    0.310010] initcall pci_reboot_init+0x0/0x22 returned 0 after 0 usecs
[    0.311012] calling  init_lapic_sysfs+0x0/0x52 @ 1
[    0.312376] initcall init_lapic_sysfs+0x0/0x52 returned 0 after 0 usecs
[    0.313039] calling  init_smp_flush+0x0/0x4e @ 1
[    0.314010] initcall init_smp_flush+0x0/0x4e returned 0 after 0 usecs
[    0.315009] calling  alloc_frozen_cpus+0x0/0xf @ 1
[    0.316008] initcall alloc_frozen_cpus+0x0/0xf returned 0 after 0 usecs
[    0.317012] calling  sysctl_init+0x0/0x47 @ 1
[    0.319282] initcall sysctl_init+0x0/0x47 returned 0 after 976 usecs
[    0.320007] calling  ksysfs_init+0x0/0xe7 @ 1
[    0.321067] initcall ksysfs_init+0x0/0xe7 returned 0 after 0 usecs
[    0.322057] calling  async_init+0x0/0x8c @ 1
[    0.324096] initcall async_init+0x0/0x8c returned 0 after 976 usecs
[    0.330011] calling  init_jiffies_clocksource+0x0/0x20 @ 1
[    0.336027] initcall init_jiffies_clocksource+0x0/0x20 returned 0 after 0 usecs
[    0.343010] calling  pm_init+0x0/0x97 @ 1
[    0.347636] initcall pm_init+0x0/0x97 returned 0 after 0 usecs
[    0.353012] calling  pm_disk_init+0x0/0x27 @ 1
[    0.358034] initcall pm_disk_init+0x0/0x27 returned 0 after 0 usecs
[    0.364012] calling  swsusp_header_init+0x0/0x41 @ 1
[    0.369012] initcall swsusp_header_init+0x0/0x41 returned 0 after 0 usecs
[    0.376009] calling  init_hw_breakpoint+0x0/0x20 @ 1
[    0.381024] initcall init_hw_breakpoint+0x0/0x20 returned 0 after 0 usecs
[    0.388009] calling  init_zero_pfn+0x0/0x43 @ 1
[    0.392011] initcall init_zero_pfn+0x0/0x43 returned 0 after 0 usecs
[    0.399009] calling  filelock_init+0x0/0x3c @ 1
[    0.403044] initcall filelock_init+0x0/0x3c returned 0 after 0 usecs
[    0.410009] calling  init_misc_binfmt+0x0/0x6c @ 1
[    0.415023] initcall init_misc_binfmt+0x0/0x6c returned 0 after 0 usecs
[    0.421012] calling  init_script_binfmt+0x0/0x22 @ 1
[    0.426011] initcall init_script_binfmt+0x0/0x22 returned 0 after 0 usecs
[    0.433009] calling  init_elf_binfmt+0x0/0x22 @ 1
[    0.438011] initcall init_elf_binfmt+0x0/0x22 returned 0 after 0 usecs
[    0.445009] calling  init_compat_elf_binfmt+0x0/0x22 @ 1
[    0.450012] initcall init_compat_elf_binfmt+0x0/0x22 returned 0 after 0 usecs
[    0.457008] calling  debugfs_init+0x0/0x85 @ 1
[    0.462024] initcall debugfs_init+0x0/0x85 returned 0 after 0 usecs
[    0.468008] calling  securityfs_init+0x0/0x7c @ 1
[    0.473036] initcall securityfs_init+0x0/0x7c returned 0 after 0 usecs
[    0.479009] calling  random32_init+0x0/0x119 @ 1
[    0.484010] initcall random32_init+0x0/0x119 returned 0 after 0 usecs
[    0.490014] calling  cpufreq_core_init+0x0/0xc5 @ 1
[    0.495024] initcall cpufreq_core_init+0x0/0xc5 returned 0 after 0 usecs
[    0.502008] calling  cpuidle_init+0x0/0x5e @ 1
[    0.507026] initcall cpuidle_init+0x0/0x5e returned 0 after 0 usecs
[    0.513009] calling  sock_init+0x0/0x91 @ 1
[    0.517211] initcall sock_init+0x0/0x91 returned 0 after 0 usecs
[    0.524010] calling  netpoll_init+0x0/0x22 @ 1
[    0.528010] initcall netpoll_init+0x0/0x22 returned 0 after 0 usecs
[    0.534009] calling  netlink_proto_init+0x0/0x1bd @ 1
[    0.539108] NET: Registered protocol family 16
[    0.544149] initcall netlink_proto_init+0x0/0x1bd returned 0 after 4882 usecs
[    0.551010] calling  bdi_class_init+0x0/0x67 @ 1
[    0.556785] initcall bdi_class_init+0x0/0x67 returned 0 after 976 usecs
[    0.563012] calling  kobject_uevent_init+0x0/0x77 @ 1
[    0.568033] initcall kobject_uevent_init+0x0/0x77 returned 0 after 0 usecs
[    0.575009] calling  gpiolib_sysfs_init+0x0/0xed @ 1
[    0.581127] initcall gpiolib_sysfs_init+0x0/0xed returned 0 after 976 usecs
[    0.588011] calling  pcibus_class_init+0x0/0x27 @ 1
[    0.593447] initcall pcibus_class_init+0x0/0x27 returned 0 after 0 usecs
[    0.600013] calling  pci_driver_init+0x0/0x20 @ 1
[    0.605321] initcall pci_driver_init+0x0/0x20 returned 0 after 0 usecs
[    0.612012] calling  backlight_class_init+0x0/0x79 @ 1
[    0.617778] initcall backlight_class_init+0x0/0x79 returned 0 after 0 usecs
[    0.625029] calling  tty_class_init+0x0/0x4b @ 1
[    0.629887] initcall tty_class_init+0x0/0x4b returned 0 after 976 usecs
[    0.636012] calling  vtconsole_class_init+0x0/0x113 @ 1
[    0.642452] initcall vtconsole_class_init+0x0/0x113 returned 0 after 0 usecs
[    0.649011] calling  register_node_type+0x0/0x20 @ 1
[    0.655267] initcall register_node_type+0x0/0x20 returned 0 after 0 usecs
[    0.662011] calling  spi_init+0x0/0xe9 @ 1
[    0.667095] initcall spi_init+0x0/0xe9 returned 0 after 976 usecs
[    0.673012] calling  i2c_init+0x0/0xb5 @ 1
[    0.678116] initcall i2c_init+0x0/0xb5 returned 0 after 976 usecs
[    0.684011] calling  amd_postcore_init+0x0/0xc6 @ 1
[    0.689010] initcall amd_postcore_init+0x0/0xc6 returned 0 after 0 usecs
[    0.696010] calling  arch_kdebugfs_init+0x0/0x342 @ 1
[    0.701102] initcall arch_kdebugfs_init+0x0/0x342 returned 0 after 0 usecs
[    0.708008] calling  mtrr_if_init+0x0/0x8d @ 1
[    0.712025] initcall mtrr_if_init+0x0/0x8d returned 0 after 0 usecs
[    0.719010] calling  ffh_cstate_init+0x0/0x41 @ 1
[    0.723014] initcall ffh_cstate_init+0x0/0x41 returned 0 after 0 usecs
[    0.730009] calling  acpi_pci_init+0x0/0xa6 @ 1
[    0.735025] ACPI: bus type pci registered
[    0.739009] initcall acpi_pci_init+0x0/0xa6 returned 0 after 3906 usecs
[    0.745008] calling  dmi_id_init+0x0/0x46e @ 1
[    0.751188] initcall dmi_id_init+0x0/0x46e returned 0 after 976 usecs
[    0.757011] calling  pci_arch_init+0x0/0xc6 @ 1
[    0.762046] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.771009] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.812808] PCI: Using configuration type 1 for base access
[    0.818017] initcall pci_arch_init+0x0/0xc6 returned 0 after 54687 usecs
[    0.825009] calling  topology_init+0x0/0xe4 @ 1
[    0.831166] initcall topology_init+0x0/0xe4 returned 0 after 976 usecs
[    0.837012] calling  mtrr_init_finialize+0x0/0x70 @ 1
[    0.843025] initcall mtrr_init_finialize+0x0/0x70 returned 0 after 0 usecs
[    0.849008] calling  param_sysfs_init+0x0/0x2e4 @ 1
[    0.875233] initcall param_sysfs_init+0x0/0x2e4 returned 0 after 20507 usecs
[    0.876234] calling  pm_sysrq_init+0x0/0x27 @ 1
[    0.877028] initcall pm_sysrq_init+0x0/0x27 returned 0 after 0 usecs
[    0.878008] calling  audit_watch_init+0x0/0x4b @ 1
[    0.879014] initcall audit_watch_init+0x0/0x4b returned 0 after 0 usecs
[    0.880117] calling  init_slow_work+0x0/0x5a @ 1
[    0.881008] initcall init_slow_work+0x0/0x5a returned 0 after 0 usecs
[    0.882008] calling  default_bdi_init+0x0/0x113 @ 1
[    0.884494] initcall default_bdi_init+0x0/0x113 returned 0 after 976 usecs
[    0.885061] calling  init_bio+0x0/0x115 @ 1
[    0.887224] bio: create slab <bio-0> at 0
[    0.888143] initcall init_bio+0x0/0x115 returned 0 after 1953 usecs
[    0.889008] calling  fsnotify_init+0x0/0x2e @ 1
[    0.890014] initcall fsnotify_init+0x0/0x2e returned 0 after 0 usecs
[    0.891008] calling  fsnotify_notification_init+0x0/0x84 @ 1
[    0.893030] initcall fsnotify_notification_init+0x0/0x84 returned 0 after 0 usecs
[    0.894007] calling  cryptomgr_init+0x0/0x20 @ 1
[    0.895009] initcall cryptomgr_init+0x0/0x20 returned 0 after 0 usecs
[    0.896013] calling  blk_settings_init+0x0/0x31 @ 1
[    0.897008] initcall blk_settings_init+0x0/0x31 returned 0 after 0 usecs
[    0.898007] calling  blk_ioc_init+0x0/0x38 @ 1
[    0.899023] initcall blk_ioc_init+0x0/0x38 returned 0 after 0 usecs
[    0.900019] calling  blk_softirq_init+0x0/0x9d @ 1
[    0.901013] initcall blk_softirq_init+0x0/0x9d returned 0 after 0 usecs
[    0.902012] calling  blk_iopoll_setup+0x0/0x9d @ 1
[    0.903011] initcall blk_iopoll_setup+0x0/0x9d returned 0 after 0 usecs
[    0.904008] calling  genhd_device_init+0x0/0x92 @ 1
[    0.906247] initcall genhd_device_init+0x0/0x92 returned 0 after 976 usecs
[    0.907012] calling  blk_dev_integrity_init+0x0/0x38 @ 1
[    0.908020] initcall blk_dev_integrity_init+0x0/0x38 returned 0 after 0 usecs
[    0.909008] calling  gpiolib_debugfs_init+0x0/0x32 @ 1
[    0.910028] initcall gpiolib_debugfs_init+0x0/0x32 returned 0 after 0 usecs
[    0.911009] calling  pci_slot_init+0x0/0x68 @ 1
[    0.912020] initcall pci_slot_init+0x0/0x68 returned 0 after 0 usecs
[    0.913008] calling  fbmem_init+0x0/0xd0 @ 1
[    0.915185] initcall fbmem_init+0x0/0xd0 returned 0 after 976 usecs
[    0.916014] calling  acpi_init+0x0/0x1be @ 1
[    0.925853] ACPI: EC: Look up EC in DSDT
[    0.979113] ACPI: BIOS _OSI(Linux) query ignored
[    1.008784] ACPI: Interpreter enabled
[    1.013015] ACPI: (supports S0 S1 S3 S4 S5)
[    1.019022] ACPI: Using IOAPIC for interrupt routing
[    1.156287] initcall acpi_init+0x0/0x1be returned 0 after 233398 usecs
[    1.157248] calling  dock_init+0x0/0xde @ 1
[    1.165614] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    1.166010] initcall dock_init+0x0/0xde returned 0 after 7812 usecs
[    1.167009] calling  acpi_pci_root_init+0x0/0x52 @ 1
[    1.168010] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    1.176399] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.190890] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.191012] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    1.192007] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.193007] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff] (ignored)
[    1.194007] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff] (ignored)
[    1.195011] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xefffffff] (ignored)
[    1.196007] pci_root PNP0A03:00: host bridge window [mem 0xf4000000-0xfebfffff] (ignored)
[    1.197007] pci_root PNP0A03:00: host bridge window [mem 0xffa80800-0xffa80bff] (ignored)
[    1.198377] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.199047] pci 0000:00:01.0: PME# disabled
[    1.200108] pci 0000:00:02.0: reg 10: [mem 0xfeb00000-0xfeb7ffff]
[    1.201020] pci 0000:00:02.0: reg 14: [io  0xe898-0xe89f]
[    1.202017] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff pref]
[    1.203016] pci 0000:00:02.0: reg 1c: [mem 0xfeac0000-0xfeafffff]
[    1.204162] pci 0000:00:02.1: reg 10: [mem 0xfeb80000-0xfebfffff]
[    1.205415] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.206011] pci 0000:00:1c.0: PME# disabled
[    1.208225] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.209015] pci 0000:00:1c.1: PME# disabled
[    1.210158] pci 0000:00:1d.0: reg 20: [io  0xff80-0xff9f]
[    1.211153] pci 0000:00:1d.1: reg 20: [io  0xff60-0xff7f]
[    1.213148] pci 0000:00:1d.2: reg 20: [io  0xff40-0xff5f]
[    1.214159] pci 0000:00:1d.3: reg 20: [io  0xff20-0xff3f]
[    1.215150] pci 0000:00:1d.7: reg 10: [mem 0xffa80800-0xffa80bff]
[    1.216151] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.217012] pci 0000:00:1d.7: PME# disabled
[    1.218262] pci 0000:00:1e.2: reg 10: [io  0xec00-0xecff]
[    1.220018] pci 0000:00:1e.2: reg 14: [io  0xe8c0-0xe8ff]
[    1.221022] pci 0000:00:1e.2: reg 18: [mem 0xfeabfa00-0xfeabfbff]
[    1.222017] pci 0000:00:1e.2: reg 1c: [mem 0xfeabf900-0xfeabf9ff]
[    1.224008] pci 0000:00:1e.2: PME# supported from D0 D3hot D3cold
[    1.225011] pci 0000:00:1e.2: PME# disabled
[    1.226214] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    1.227017] pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by ICH6 GPIO
[    1.228010] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (mask 007f)
[    1.229010] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0 (mask 0007)
[    1.230122] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    1.231027] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    1.232018] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    1.233018] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    1.234021] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
[    1.235128] pci 0000:00:1f.2: reg 10: [io  0xfe00-0xfe07]
[    1.236017] pci 0000:00:1f.2: reg 14: [io  0xfe10-0xfe13]
[    1.237017] pci 0000:00:1f.2: reg 18: [io  0xfe20-0xfe27]
[    1.238017] pci 0000:00:1f.2: reg 1c: [io  0xfe30-0xfe33]
[    1.239021] pci 0000:00:1f.2: reg 20: [io  0xfea0-0xfeaf]
[    1.240072] pci 0000:00:1f.2: PME# supported from D3hot
[    1.241011] pci 0000:00:1f.2: PME# disabled
[    1.242126] pci 0000:00:1f.3: reg 20: [io  0xe8a0-0xe8bf]
[    1.243201] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.244012] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.245011] pci 0000:00:01.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    1.246025] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.248227] pci 0000:02:00.0: reg 10: [mem 0xfe8f0000-0xfe8fffff 64bit]
[    1.250097] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    1.251013] pci 0000:02:00.0: PME# disabled
[    1.252039] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.253051] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.254012] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.255012] pci 0000:00:1c.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    1.256017] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.257128] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.258012] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    1.259012] pci 0000:00:1c.1:   bridge window [mem 0xfe700000-0xfe7fffff]
[    1.260017] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.261195] pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive decode)
[    1.262012] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.263012] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.264017] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.265008] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    1.266008] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffffffffffff] (subtractive decode)
[    1.267063] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.272886] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
[    1.276678] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
[    1.277644] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3._PRT]
[    1.279403] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    2.337013] initcall acpi_pci_root_init+0x0/0x52 returned 0 after 1141601 usecs
[    2.338193] calling  acpi_pci_link_init+0x0/0x7c @ 1
[    2.340662] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    2.345083] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    2.350471] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    2.354847] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    2.360535] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    2.364862] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    2.369362] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    2.374747] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    2.378437] initcall acpi_pci_link_init+0x0/0x7c returned 0 after 38085 usecs
[    2.379016] calling  pnp_init+0x0/0x20 @ 1
[    2.380241] initcall pnp_init+0x0/0x20 returned 0 after 0 usecs
[    2.381021] calling  misc_init+0x0/0xf6 @ 1
[    2.382242] initcall misc_init+0x0/0xf6 returned 0 after 0 usecs
[    2.383050] calling  vga_arb_device_init+0x0/0xbf @ 1
[    2.385389] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.386141] vgaarb: loaded
[    2.387009] initcall vga_arb_device_init+0x0/0xbf returned 0 after 2929 usecs
[    2.388011] calling  cn_init+0x0/0xd1 @ 1
[    2.390053] initcall cn_init+0x0/0xd1 returned 0 after 976 usecs
[    2.391007] calling  phy_init+0x0/0x5a @ 1
[    2.393399] initcall phy_init+0x0/0x5a returned 0 after 976 usecs
[    2.394081] calling  serio_init+0x0/0xda @ 1
[    2.395402] initcall serio_init+0x0/0xda returned 0 after 0 usecs
[    2.396125] calling  input_init+0x0/0x1db @ 1
[    2.398098] initcall input_init+0x0/0x1db returned 0 after 976 usecs
[    2.399008] calling  power_supply_class_init+0x0/0x4b @ 1
[    2.400232] initcall power_supply_class_init+0x0/0x4b returned 0 after 0 usecs
[    2.401027] calling  pci_subsys_init+0x0/0x16a @ 1
[    2.402006] PCI: Using ACPI for IRQ routing
[    2.403008] PCI: pci_cache_line_size set to 64 bytes
[    2.404477] reserve RAM buffer: 000000007f686c00 - 000000007fffffff initcall pci_subsys_init+0x0/0x16a returned 0 after 2929 usecs
[    2.406008] calling  proto_init+0x0/0x20 @ 1
[    2.407026] initcall proto_init+0x0/0x20 returned 0 after 0 usecs
[    2.408008] calling  net_dev_init+0x0/0x254 @ 1
[    2.410690] initcall net_dev_init+0x0/0x254 returned 0 after 1953 usecs
[    2.417013] calling  neigh_init+0x0/0x9b @ 1
[    2.422011] initcall neigh_init+0x0/0x9b returned 0 after 0 usecs
[    2.428009] calling  fib_rules_init+0x0/0xfa @ 1
[    2.432016] initcall fib_rules_init+0x0/0xfa returned 0 after 0 usecs
[    2.439010] calling  genl_init+0x0/0xeb @ 1
[    2.443105] initcall genl_init+0x0/0xeb returned 0 after 0 usecs
[    2.449009] calling  cipso_v4_init+0x0/0xbe @ 1
[    2.454033] initcall cipso_v4_init+0x0/0xbe returned 0 after 0 usecs
[    2.460011] calling  wireless_nlevent_init+0x0/0x20 @ 1
[    2.466012] initcall wireless_nlevent_init+0x0/0x20 returned 0 after 0 usecs
[    2.473009] calling  netlbl_init+0x0/0xdc @ 1
[    2.477006] NetLabel: Initializing
[    2.481006] NetLabel:  domain hash size = 128
[    2.485006] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.490210] NetLabel:  unlabeled traffic allowed by default
[    2.496009] initcall netlbl_init+0x0/0xdc returned 0 after 18554 usecs
[    2.502009] calling  sysctl_init+0x0/0x72 @ 1
[    2.507015] initcall sysctl_init+0x0/0x72 returned 0 after 0 usecs
[    2.513010] calling  print_ICs+0x0/0x7a4 @ 1
[    2.517009] initcall print_ICs+0x0/0x7a4 returned 0 after 0 usecs
[    2.524012] calling  hpet_late_init+0x0/0xea @ 1
[    2.528013] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    2.535013] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    2.540579] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    2.549125] initcall hpet_late_init+0x0/0xea returned 0 after 20507 usecs
[    2.556011] calling  init_k8_nbs+0x0/0x44 @ 1
[    2.560156] initcall init_k8_nbs+0x0/0x44 returned 0 after 0 usecs
[    2.566009] calling  clocksource_done_booting+0x0/0x96 @ 1
[    2.572014] Switching to clocksource tsc
[    2.576476] initcall clocksource_done_booting+0x0/0x96 returned 0 after 4219 usecs
[    2.584083] calling  init_pipe_fs+0x0/0x76 @ 1
[    2.588736] initcall init_pipe_fs+0x0/0x76 returned 0 after 105 usecs
[    2.595277] calling  eventpoll_init+0x0/0x10d @ 1
[    2.601978] initcall eventpoll_init+0x0/0x10d returned 0 after 44 usecs
[    2.608702] calling  anon_inode_init+0x0/0x18a @ 1
[    2.613665] initcall anon_inode_init+0x0/0x18a returned 0 after 68 usecs
[    2.620463] calling  blk_scsi_ioctl_init+0x0/0x488 @ 1
[    2.625704] initcall blk_scsi_ioctl_init+0x0/0x488 returned 0 after 0 usecs
[    2.632765] calling  acpi_event_init+0x0/0xe1 @ 1
[    2.637671] initcall acpi_event_init+0x0/0xe1 returned 0 after 100 usecs
[    2.644472] calling  pnpacpi_init+0x0/0xd5 @ 1
[    2.649030] pnp: PnP ACPI init
[    2.652252] ACPI: bus type pnp registered
[    2.669710] pnp 00:01: disabling [io  0x0800-0x085f] because it overlaps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    2.680049] pnp 00:01: disabling [io  0x0860-0x08ff] because it overlaps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    2.749897] pnp: PnP ACPI: found 10 devices
[    2.754201] ACPI: ACPI bus type pnp unregistered
[    2.758924] initcall pnpacpi_init+0x0/0xd5 returned 0 after 107313 usecs
[    2.765735] calling  pnp_system_init+0x0/0x20 @ 1
[    2.770600] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    2.776659] system 00:08: [mem 0x00000000-0x0009ffff] could not be reserved
[    2.783726] system 00:08: [mem 0x00100000-0x00ffffff] could not be reserved
[    2.790791] system 00:08: [mem 0x01000000-0x7f686bff] could not be reserved
[    2.797859] system 00:08: [mem 0x000f0000-0x000fffff] could not be reserved
[    2.804920] system 00:08: [mem 0x000c0000-0x000cffff] has been reserved
[    2.811652] system 00:08: [mem 0xfec00000-0xfecfffff] could not be reserved
[    2.818712] system 00:08: [mem 0xfee00000-0xfeefffff] has been reserved
[    2.825425] system 00:08: [mem 0xfed20000-0xfed9ffff] has been reserved
[    2.832140] system 00:08: [mem 0xffb00000-0xffbfffff] has been reserved
[    2.838853] system 00:08: [mem 0xffc00000-0xffffffff] has been reserved
[    2.845611] system 00:09: [io  0x0100-0x01fe] could not be reserved
[    2.851979] system 00:09: [io  0x0200-0x0277] has been reserved
[    2.858016] system 00:09: [io  0x0280-0x02e7] has been reserved
[    2.864048] system 00:09: [io  0x02f0-0x02f7] has been reserved
[    2.870073] system 00:09: [io  0x0300-0x0377] could not be reserved
[    2.876441] system 00:09: [io  0x0380-0x03bb] has been reserved
[    2.882468] system 00:09: [io  0x03c0-0x03e7] could not be reserved
[    2.888838] system 00:09: [io  0x03f6-0x03f7] could not be reserved
[    2.895208] system 00:09: [io  0x0400-0x04cf] has been reserved
[    2.901228] system 00:09: [io  0x04d2-0x057f] has been reserved
[    2.907249] system 00:09: [io  0x0580-0x0677] has been reserved
[    2.913273] system 00:09: [io  0x0680-0x0777] has been reserved
[    2.919295] system 00:09: [io  0x0780-0x07bb] has been reserved
[    2.925317] system 00:09: [io  0x07c0-0x07ff] has been reserved
[    2.931339] system 00:09: [io  0x08e0-0x08ff] has been reserved
[    2.937361] system 00:09: [io  0x0900-0x09fe] has been reserved
[    2.943381] system 00:09: [io  0x0a00-0x0afe] has been reserved
[    2.949401] system 00:09: [io  0x0b00-0x0bfe] has been reserved
[    2.955422] system 00:09: [io  0x0c80-0x0caf] has been reserved
[    2.961443] system 00:09: [io  0x0cb0-0x0cbf] has been reserved
[    2.967463] system 00:09: [io  0x0cc0-0x0cf7] has been reserved
[    2.973497] system 00:09: [io  0x0d00-0x0dfe] has been reserved
[    2.979518] system 00:09: [io  0x0e00-0x0efe] has been reserved
[    2.985539] system 00:09: [io  0x0f00-0x0ffe] has been reserved
[    2.991559] system 00:09: [io  0x2000-0x20fe] has been reserved
[    2.997580] system 00:09: [io  0x2100-0x21fe] has been reserved
[    3.003628] system 00:09: [io  0x2200-0x22fe] has been reserved
[    3.009653] system 00:09: [io  0x2300-0x23fe] has been reserved
[    3.015673] system 00:09: [io  0x2400-0x24fe] has been reserved
[    3.021696] system 00:09: [io  0x2500-0x25fe] has been reserved
[    3.027717] system 00:09: [io  0x2600-0x26fe] has been reserved
[    3.033737] system 00:09: [io  0x2700-0x27fe] has been reserved
[    3.039760] system 00:09: [io  0x2800-0x28fe] has been reserved
[    3.045783] system 00:09: [io  0x2900-0x29fe] has been reserved
[    3.051804] system 00:09: [io  0x2a00-0x2afe] has been reserved
[    3.057827] system 00:09: [io  0x2b00-0x2bfe] has been reserved
[    3.063847] system 00:09: [io  0x2c00-0x2cfe] has been reserved
[    3.069870] system 00:09: [io  0x2d00-0x2dfe] has been reserved
[    3.075891] system 00:09: [io  0x2e00-0x2efe] has been reserved
[    3.081913] system 00:09: [io  0x2f00-0x2ffe] has been reserved
[    3.087946] system 00:09: [io  0x5000-0x50fe] has been reserved
[    3.093979] system 00:09: [io  0x5100-0x51fe] has been reserved
[    3.100022] system 00:09: [io  0x5200-0x52fe] has been reserved
[    3.106049] system 00:09: [io  0x5300-0x53fe] has been reserved
[    3.112088] system 00:09: [io  0x5400-0x54fe] has been reserved
[    3.118109] system 00:09: [io  0x5500-0x55fe] has been reserved
[    3.124136] system 00:09: [io  0x5600-0x56fe] has been reserved
[    3.130159] system 00:09: [io  0x5700-0x57fe] has been reserved
[    3.136181] system 00:09: [io  0x5800-0x58fe] has been reserved
[    3.142203] system 00:09: [io  0x5900-0x59fe] has been reserved
[    3.148221] system 00:09: [io  0x5a00-0x5afe] has been reserved
[    3.154257] system 00:09: [io  0x5b00-0x5bfe] has been reserved
[    3.160278] system 00:09: [io  0x5c00-0x5cfe] has been reserved
[    3.166302] system 00:09: [io  0x5d00-0x5dfe] has been reserved
[    3.172326] system 00:09: [io  0x5e00-0x5efe] has been reserved
[    3.178348] system 00:09: [io  0x5f00-0x5ffe] has been reserved
[    3.184371] system 00:09: [io  0x6000-0x60fe] has been reserved
[    3.190392] system 00:09: [io  0x6100-0x61fe] has been reserved
[    3.196416] system 00:09: [io  0x6200-0x62fe] has been reserved
[    3.202439] system 00:09: [io  0x6300-0x63fe] has been reserved
[    3.208462] system 00:09: [io  0x6400-0x64fe] has been reserved
[    3.214483] system 00:09: [io  0x6500-0x65fe] has been reserved
[    3.220504] system 00:09: [io  0x6600-0x66fe] has been reserved
[    3.226526] system 00:09: [io  0x6700-0x67fe] has been reserved
[    3.232548] system 00:09: [io  0x6800-0x68fe] has been reserved
[    3.238572] system 00:09: [io  0x6900-0x69fe] has been reserved
[    3.244594] system 00:09: [io  0x6a00-0x6afe] has been reserved
[    3.250618] system 00:09: [io  0x6b00-0x6bfe] has been reserved
[    3.256639] system 00:09: [io  0x6c00-0x6cfe] has been reserved
[    3.262661] system 00:09: [io  0x6d00-0x6dfe] has been reserved
[    3.268685] system 00:09: [io  0x6e00-0x6efe] has been reserved
[    3.274707] system 00:09: [io  0x6f00-0x6ffe] has been reserved
[    3.280731] system 00:09: [io  0xa000-0xa0fe] has been reserved
[    3.286755] system 00:09: [io  0xa100-0xa1fe] has been reserved
[    3.292777] system 00:09: [io  0xa200-0xa2fe] has been reserved
[    3.298799] system 00:09: [io  0xa300-0xa3fe] has been reserved
[    3.304819] system 00:09: [io  0xa400-0xa4fe] has been reserved
[    3.310842] system 00:09: [io  0xa500-0xa5fe] has been reserved
[    3.316865] system 00:09: [io  0xa600-0xa6fe] has been reserved
[    3.322888] system 00:09: [io  0xa700-0xa7fe] has been reserved
[    3.328909] system 00:09: [io  0xa800-0xa8fe] has been reserved
[    3.334952] system 00:09: [io  0xa900-0xa9fe] has been reserved
[    3.340985] system 00:09: [io  0xaa00-0xaafe] has been reserved
[    3.347073] system 00:09: [io  0xab00-0xabfe] has been reserved
[    3.353101] system 00:09: [io  0xac00-0xacfe] has been reserved
[    3.359125] system 00:09: [io  0xad00-0xadfe] has been reserved
[    3.365148] system 00:09: [io  0xae00-0xaefe] has been reserved
[    3.371171] system 00:09: [io  0xaf00-0xaffe] has been reserved
[    3.377193] system 00:09: [mem 0xf0000000-0xf3ffffff] has been reserved
[    3.383907] system 00:09: [mem 0xfeda0000-0xfedacfff] has been reserved
[    3.390994] initcall pnp_system_init+0x0/0x20 returned 0 after 605906 usecs
[    3.398088] calling  chr_dev_init+0x0/0x122 @ 1
[    3.408142] initcall chr_dev_init+0x0/0x122 returned 0 after 5289 usecs
[    3.414880] calling  firmware_class_init+0x0/0xb1 @ 1
[    3.420436] initcall firmware_class_init+0x0/0xb1 returned 0 after 375 usecs
[    3.427596] calling  cpufreq_gov_performance_init+0x0/0x20 @ 1
[    3.433550] initcall cpufreq_gov_performance_init+0x0/0x20 returned 0 after 20 usecs
[    3.441458] calling  cpufreq_gov_dbs_init+0x0/0xf5 @ 1
[    3.447099] initcall cpufreq_gov_dbs_init+0x0/0xf5 returned 0 after 395 usecs
[    3.454342] calling  init_acpi_pm_clocksource+0x0/0x160 @ 1
[    3.464574] initcall init_acpi_pm_clocksource+0x0/0x160 returned 0 after 4431 usecs
[    3.472399] calling  pcibios_assign_resources+0x0/0xb5 @ 1
[    3.478169] PCI: max bus depth: 1 pci_try_num: 2
[    3.482971] pci 0000:00:1c.0: BAR 15: assigned [mem 0x80000000-0x801fffff 64bit pref]
[    3.490982] pci 0000:00:1c.1: BAR 15: assigned [mem 0x80200000-0x803fffff 64bit pref]
[    3.498997] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    3.505293] pci 0000:00:1c.1: BAR 13: assigned [io  0x3000-0x3fff]
[    3.511573] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    3.516897] pci 0000:00:01.0:   bridge window [io  disabled]
[    3.522663] pci 0000:00:01.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    3.529550] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    3.535750] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    3.541076] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    3.547274] pci 0000:00:1c.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    3.554165] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff 64bit pref]
[    3.562080] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    3.567406] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    3.573606] pci 0000:00:1c.1:   bridge window [mem 0xfe700000-0xfe7fffff]
[    3.580497] pci 0000:00:1c.1:   bridge window [mem 0x80200000-0x803fffff 64bit pref]
[    3.588415] pci 0000:00:1e.0: PCI bridge to [bus 04-04]
[    3.593736] pci 0000:00:1e.0:   bridge window [io  disabled]
[    3.599500] pci 0000:00:1e.0:   bridge window [mem disabled]
[    3.605259] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    3.611504]   alloc irq_desc for 16 on node -1
[    3.612440]   alloc kstat_irqs on node -1
[    3.620160] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.626962] pci 0000:00:01.0: setting latency timer to 64
[    3.632489] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.639292] pci 0000:00:1c.0: setting latency timer to 64
[    3.644813]   alloc irq_desc for 17 on node -1
[    3.645781]   alloc kstat_irqs on node -1
[    3.653463] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.660266] pci 0000:00:1c.1: setting latency timer to 64
[    3.665781] pci 0000:00:1e.0: setting latency timer to 64
[    3.671282] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    3.676953] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    3.684048] pci_bus 0000:01: resource 1 [mem 0xfe900000-0xfe9fffff]
[    3.690417] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    3.696087] pci_bus 0000:02: resource 1 [mem 0xfe800000-0xfe8fffff]
[    3.702451] pci_bus 0000:02: resource 2 [mem 0x80000000-0x801fffff 64bit pref]
[    3.709842] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    3.715512] pci_bus 0000:03: resource 1 [mem 0xfe700000-0xfe7fffff]
[    3.721878] pci_bus 0000:03: resource 2 [mem 0x80200000-0x803fffff 64bit pref]
[    3.731112] pci_bus 0000:04: resource 4 [io  0x0000-0xffff]
[    3.736783] pci_bus 0000:04: resource 5 [mem 0x00000000-0xffffffffffffffff]
[    3.743843] initcall pcibios_assign_resources+0x0/0xb5 returned 0 after 259625 usecs
[    3.751764] calling  sysctl_core_init+0x0/0x54 @ 1
[    3.756724] initcall sysctl_core_init+0x0/0x54 returned 0 after 65 usecs
[    3.763519] calling  inet_init+0x0/0x387 @ 1
[    3.767952] NET: Registered protocol family 2
[    3.772935] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    3.782960] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    3.793788] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    3.808184] TCP: Hash tables configured (established 262144 bind 65536)
[    3.814979] TCP reno registered
[    3.818303] UDP hash table entries: 1024 (order: 5, 163840 bytes)
[    3.824773] UDP-Lite hash table entries: 1024 (order: 5, 163840 bytes)
[    3.832173] initcall inet_init+0x0/0x387 returned 0 after 62770 usecs
[    3.838714] calling  af_unix_init+0x0/0x7f @ 1
[    3.843271] NET: Registered protocol family 1
[    3.847771] initcall af_unix_init+0x0/0x7f returned 0 after 4407 usecs
[    3.854397] calling  pci_apply_final_quirks+0x0/0x16c @ 1
[    3.859940] pci 0000:00:02.0: Boot video device
[    3.864900] PCI: CLS 64 bytes, default 64
[    3.869056] initcall pci_apply_final_quirks+0x0/0x16c returned 0 after 8940 usecs
[    3.876704] calling  populate_rootfs+0x0/0x18b @ 1
[    3.882375] Unpacking initramfs...
[    4.048859] Freeing initrd memory: 3924k freed
[    4.055599] initcall populate_rootfs+0x0/0x18b returned 0 after 169918 usecs
[    4.062749] calling  pci_iommu_init+0x0/0x5b @ 1
[    4.067470] initcall pci_iommu_init+0x0/0x5b returned 0 after 1 usecs
[    4.074012] calling  i8259A_init_sysfs+0x0/0x3e @ 1
[    4.080037] initcall i8259A_init_sysfs+0x0/0x3e returned 0 after 1006 usecs
[    4.087362] calling  vsyscall_init+0x0/0x6c @ 1
[    4.092643] initcall vsyscall_init+0x0/0x6c returned 0 after 351 usecs
[    4.099270] calling  sbf_init+0x0/0x18b @ 1
[    4.103556] Simple Boot Flag at 0x7a set to 0x1
[    4.108191] initcall sbf_init+0x0/0x18b returned 0 after 4527 usecs
[    4.114555] calling  i8237A_init_sysfs+0x0/0x3e @ 1
[    4.120331] initcall i8237A_init_sysfs+0x0/0x3e returned 0 after 775 usecs
[    4.127320] calling  add_rtc_cmos+0x0/0xea @ 1
[    4.131868] initcall add_rtc_cmos+0x0/0xea returned 0 after 4 usecs
[    4.138236] calling  cache_sysfs_init+0x0/0x93 @ 1
[    4.145766] initcall cache_sysfs_init+0x0/0x93 returned 0 after 2573 usecs
[    4.152760] calling  mcheck_init_device+0x0/0x13a @ 1
[    4.159912] initcall mcheck_init_device+0x0/0x13a returned 0 after 1948 usecs
[    4.167171] calling  thermal_throttle_init_device+0x0/0xf4 @ 1
[    4.173190] initcall thermal_throttle_init_device+0x0/0xf4 returned 0 after 84 usecs
[    4.181101] calling  ioapic_init_sysfs+0x0/0x10f @ 1
[    4.186931] initcall ioapic_init_sysfs+0x0/0x10f returned 0 after 745 usecs
[    4.194056] calling  add_pcspkr+0x0/0x3a @ 1
[    4.198887] initcall add_pcspkr+0x0/0x3a returned 0 after 442 usecs
[    4.205273] calling  start_periodic_check_for_corruption+0x0/0x5c @ 1
[    4.211811] Scanning for low memory corruption every 60 seconds
[    4.217841] initcall start_periodic_check_for_corruption+0x0/0x5c returned 0 after 5886 usecs
[    4.226541] calling  audit_classes_init+0x0/0xfc @ 1
[    4.231694] initcall audit_classes_init+0x0/0xfc returned 0 after 87 usecs
[    4.238668] calling  pt_dump_init+0x0/0x45 @ 1
[    4.243244] initcall pt_dump_init+0x0/0x45 returned 0 after 26 usecs
[    4.249700] calling  init_vdso_vars+0x0/0x207 @ 1
[    4.254529] initcall init_vdso_vars+0x0/0x207 returned 0 after 21 usecs
[    4.261243] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    4.266165] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 24 usecs
[    4.272963] calling  sysenter_setup+0x0/0x2d0 @ 1
[    4.277786] initcall sysenter_setup+0x0/0x2d0 returned 0 after 5 usecs
[    4.284412] calling  init_aout_binfmt+0x0/0x22 @ 1
[    4.289302] initcall init_aout_binfmt+0x0/0x22 returned 0 after 2 usecs
[    4.296026] calling  init_sched_debug_procfs+0x0/0x46 @ 1
[    4.301557] initcall init_sched_debug_procfs+0x0/0x46 returned 0 after 21 usecs
[    4.309040] calling  proc_schedstat_init+0x0/0x30 @ 1
[    4.314206] initcall proc_schedstat_init+0x0/0x30 returned 0 after 13 usecs
[    4.321264] calling  proc_execdomains_init+0x0/0x30 @ 1
[    4.326603] initcall proc_execdomains_init+0x0/0x30 returned 0 after 14 usecs
[    4.333833] calling  ioresources_init+0x0/0x51 @ 1
[    4.338770] initcall ioresources_init+0x0/0x51 returned 0 after 44 usecs
[    4.345569] calling  uid_cache_init+0x0/0xc4 @ 1
[    4.350333] initcall uid_cache_init+0x0/0xc4 returned 0 after 44 usecs
[    4.356957] calling  init_posix_timers+0x0/0x1b2 @ 1
[    4.362056] initcall init_posix_timers+0x0/0x1b2 returned 0 after 13 usecs
[    4.369044] calling  init_posix_cpu_timers+0x0/0x10f @ 1
[    4.374453] initcall init_posix_cpu_timers+0x0/0x10f returned 0 after 0 usecs
[    4.381685] calling  nsproxy_cache_init+0x0/0x3b @ 1
[    4.386763] initcall nsproxy_cache_init+0x0/0x3b returned 0 after 12 usecs
[    4.393737] calling  create_proc_profile+0x0/0x2fc @ 1
[    4.398975] initcall create_proc_profile+0x0/0x2fc returned 0 after 0 usecs
[    4.406046] calling  timekeeping_init_device+0x0/0x3e @ 1
[    4.412329] initcall timekeeping_init_device+0x0/0x3e returned 0 after 761 usecs
[    4.419899] calling  init_clocksource_sysfs+0x0/0x88 @ 1
[    4.426093] initcall init_clocksource_sysfs+0x0/0x88 returned 0 after 758 usecs
[    4.433579] calling  init_timer_list_procfs+0x0/0x46 @ 1
[    4.439008] initcall init_timer_list_procfs+0x0/0x46 returned 0 after 15 usecs
[    4.446407] calling  init_tstats_procfs+0x0/0x46 @ 1
[    4.451487] initcall init_tstats_procfs+0x0/0x46 returned 0 after 15 usecs
[    4.458458] calling  lockdep_proc_init+0x0/0x7b @ 1
[    4.463479] initcall lockdep_proc_init+0x0/0x7b returned 0 after 38 usecs
[    4.470364] calling  futex_init+0x0/0xa3 @ 1
[    4.474770] initcall futex_init+0x0/0xa3 returned 0 after 35 usecs
[    4.481050] calling  proc_dma_init+0x0/0x30 @ 1
[    4.485696] initcall proc_dma_init+0x0/0x30 returned 0 after 14 usecs
[    4.492234] calling  proc_modules_init+0x0/0x30 @ 1
[    4.497226] initcall proc_modules_init+0x0/0x30 returned 0 after 14 usecs
[    4.504114] calling  kallsyms_init+0x0/0x33 @ 1
[    4.508760] initcall kallsyms_init+0x0/0x33 returned 0 after 13 usecs
[    4.515299] calling  snapshot_device_init+0x0/0x20 @ 1
[    4.520997] initcall snapshot_device_init+0x0/0x20 returned 0 after 445 usecs
[    4.528264] calling  crash_save_vmcoreinfo_init+0x0/0x593 @ 1
[    4.534151] initcall crash_save_vmcoreinfo_init+0x0/0x593 returned 0 after 39 usecs
[    4.541972] calling  crash_notes_memory_init+0x0/0x52 @ 1
[    4.547490] initcall crash_notes_memory_init+0x0/0x52 returned 0 after 7 usecs
[    4.554877] calling  ikconfig_init+0x0/0x4e @ 1
[    4.559523] initcall ikconfig_init+0x0/0x4e returned 0 after 15 usecs
[    4.566061] calling  audit_init+0x0/0x1ac @ 1
[    4.570518] audit: initializing netlink socket (disabled)
[    4.576150] type=2000 audit(1273585102.576:1): initialized
[    4.581745] initcall audit_init+0x0/0x1ac returned 0 after 10961 usecs
[    4.588369] calling  gcov_init+0x0/0x20 @ 1
[    4.592654] initcall gcov_init+0x0/0x20 returned 0 after 0 usecs
[    4.598759] calling  gcov_fs_init+0x0/0x10d @ 1
[    4.734314] initcall gcov_fs_init+0x0/0x10d returned 0 after 127847 usecs
[    4.741209] calling  audit_tree_init+0x0/0x7a @ 1
[    4.746024] initcall audit_tree_init+0x0/0x7a returned 0 after 8 usecs
[    4.752656] calling  init_kprobes+0x0/0x220 @ 1
[    4.776347] initcall init_kprobes+0x0/0x220 returned 0 after 18611 usecs
[    4.783145] calling  hung_task_init+0x0/0x76 @ 1
[    4.788089] initcall hung_task_init+0x0/0x76 returned 0 after 222 usecs
[    4.794817] calling  rcuclassic_trace_init+0x0/0x15d @ 1
[    4.800335] initcall rcuclassic_trace_init+0x0/0x15d returned 0 after 103 usecs
[    4.807811] calling  utsname_sysctl_init+0x0/0x22 @ 1
[    4.813119] initcall utsname_sysctl_init+0x0/0x22 returned 0 after 151 usecs
[    4.820267] calling  init_lstats_procfs+0x0/0x33 @ 1
[    4.825356] initcall init_lstats_procfs+0x0/0x33 returned 0 after 22 usecs
[    4.832331] calling  perf_event_sysfs_init+0x0/0x27 @ 1
[    4.837677] initcall perf_event_sysfs_init+0x0/0x27 returned 0 after 20 usecs
[    4.844910] calling  init_per_zone_wmark_min+0x0/0xc0 @ 1
[    4.850604] initcall init_per_zone_wmark_min+0x0/0xc0 returned 0 after 182 usecs
[    4.858168] calling  kswapd_init+0x0/0xad @ 1
[    4.862848] initcall kswapd_init+0x0/0xad returned 0 after 214 usecs
[    4.869315] calling  setup_vmstat+0x0/0x104 @ 1
[    4.874035] initcall setup_vmstat+0x0/0x104 returned 0 after 85 usecs
[    4.880584] calling  mm_sysfs_init+0x0/0x43 @ 1
[    4.885245] initcall mm_sysfs_init+0x0/0x43 returned 0 after 28 usecs
[    4.891783] calling  proc_vmalloc_init+0x0/0x33 @ 1
[    4.896776] initcall proc_vmalloc_init+0x0/0x33 returned 0 after 14 usecs
[    4.903663] calling  procswaps_init+0x0/0x30 @ 1
[    4.908394] initcall procswaps_init+0x0/0x30 returned 0 after 14 usecs
[    4.915044] calling  hugetlb_init+0x0/0x55d @ 1
[    4.919687] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.926232] initcall hugetlb_init+0x0/0x55d returned 0 after 6394 usecs
[    4.932943] calling  ksm_init+0x0/0x285 @ 1
[    4.937551] initcall ksm_init+0x0/0x285 returned 0 after 303 usecs
[    4.943843] calling  slab_proc_init+0x0/0x33 @ 1
[    4.948578] initcall slab_proc_init+0x0/0x33 returned 0 after 15 usecs
[    4.955203] calling  slab_sysfs_init+0x0/0x157 @ 1
[    5.024726] initcall slab_sysfs_init+0x0/0x157 returned 0 after 63110 usecs
[    5.031806] calling  fasync_init+0x0/0x38 @ 1
[    5.036904] initcall fasync_init+0x0/0x38 returned 0 after 620 usecs
[    5.043391] calling  proc_filesystems_init+0x0/0x30 @ 1
[    5.048736] initcall proc_filesystems_init+0x0/0x30 returned 0 after 19 usecs
[    5.055967] calling  dnotify_init+0x0/0xa3 @ 1
[    5.061857] initcall dnotify_init+0x0/0xa3 returned 0 after 1300 usecs
[    5.068492] calling  inotify_setup+0x0/0x19 @ 1
[    5.073122] initcall inotify_setup+0x0/0x19 returned 0 after 0 usecs
[    5.079574] calling  inotify_user_setup+0x0/0x85 @ 1
[    5.086047] initcall inotify_user_setup+0x0/0x85 returned 0 after 1371 usecs
[    5.093223] calling  aio_setup+0x0/0x11d @ 1
[    5.099282] initcall aio_setup+0x0/0x11d returned 0 after 1646 usecs
[    5.105745] calling  proc_locks_init+0x0/0x30 @ 1
[    5.110579] initcall proc_locks_init+0x0/0x30 returned 0 after 25 usecs
[    5.117294] calling  init_sys32_ioctl+0x0/0x36 @ 1
[    5.122344] initcall init_sys32_ioctl+0x0/0x36 returned 0 after 153 usecs
[    5.131089] calling  dquot_init+0x0/0x121 @ 1
[    5.135543] VFS: Disk quotas dquot_6.5.2
[    5.140389] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.146951] initcall dquot_init+0x0/0x121 returned 0 after 11137 usecs
[    5.153589] calling  quota_init+0x0/0x42 @ 1
[    5.158009] initcall quota_init+0x0/0x42 returned 0 after 48 usecs
[    5.164299] calling  proc_cmdline_init+0x0/0x30 @ 1
[    5.169292] initcall proc_cmdline_init+0x0/0x30 returned 0 after 14 usecs
[    5.176177] calling  proc_cpuinfo_init+0x0/0x30 @ 1
[    5.181169] initcall proc_cpuinfo_init+0x0/0x30 returned 0 after 14 usecs
[    5.188055] calling  proc_devices_init+0x0/0x30 @ 1
[    5.193073] initcall proc_devices_init+0x0/0x30 returned 0 after 32 usecs
[    5.199959] calling  proc_interrupts_init+0x0/0x30 @ 1
[    5.205223] initcall proc_interrupts_init+0x0/0x30 returned 0 after 14 usecs
[    5.212368] calling  proc_loadavg_init+0x0/0x30 @ 1
[    5.217362] initcall proc_loadavg_init+0x0/0x30 returned 0 after 15 usecs
[    5.224248] calling  proc_meminfo_init+0x0/0x30 @ 1
[    5.229240] initcall proc_meminfo_init+0x0/0x30 returned 0 after 14 usecs
[    5.236135] calling  proc_stat_init+0x0/0x30 @ 1
[    5.240865] initcall proc_stat_init+0x0/0x30 returned 0 after 14 usecs
[    5.247489] calling  proc_uptime_init+0x0/0x30 @ 1
[    5.252395] initcall proc_uptime_init+0x0/0x30 returned 0 after 14 usecs
[    5.259195] calling  proc_version_init+0x0/0x30 @ 1
[    5.264188] initcall proc_version_init+0x0/0x30 returned 0 after 14 usecs
[    5.271072] calling  proc_softirqs_init+0x0/0x30 @ 1
[    5.276153] initcall proc_softirqs_init+0x0/0x30 returned 0 after 14 usecs
[    5.283125] calling  proc_kcore_init+0x0/0xe4 @ 1
[    5.287957] initcall proc_kcore_init+0x0/0xe4 returned 0 after 29 usecs
[    5.294680] calling  vmcore_init+0x0/0x4e1 @ 1
[    5.299224] initcall vmcore_init+0x0/0x4e1 returned 0 after 0 usecs
[    5.305588] calling  proc_kmsg_init+0x0/0x33 @ 1
[    5.310322] initcall proc_kmsg_init+0x0/0x33 returned 0 after 14 usecs
[    5.316946] calling  proc_page_init+0x0/0x57 @ 1
[    5.321706] initcall proc_page_init+0x0/0x57 returned 0 after 27 usecs
[    5.328331] calling  init_devpts_fs+0x0/0x76 @ 1
[    5.333181] initcall init_devpts_fs+0x0/0x76 returned 0 after 127 usecs
[    5.339892] calling  init_ramfs_fs+0x0/0x20 @ 1
[    5.344525] initcall init_ramfs_fs+0x0/0x20 returned 0 after 2 usecs
[    5.350976] calling  init_hugetlbfs_fs+0x0/0xf1 @ 1
[    5.356787] initcall init_hugetlbfs_fs+0x0/0xf1 returned 0 after 800 usecs
[    5.363763] calling  ipc_init+0x0/0x46 @ 1
[    5.367983] msgmni has been set to 3960
[    5.371962] initcall ipc_init+0x0/0x46 returned 0 after 3906 usecs
[    5.378253] calling  ipc_sysctl_init+0x0/0x22 @ 1
[    5.383254] initcall ipc_sysctl_init+0x0/0x22 returned 0 after 191 usecs
[    5.390049] calling  init_mqueue_fs+0x0/0x128 @ 1
[    5.395800] initcall init_mqueue_fs+0x0/0x128 returned 0 after 922 usecs
[    5.402603] calling  key_proc_init+0x0/0x7e @ 1
[    5.407265] initcall key_proc_init+0x0/0x7e returned 0 after 29 usecs
[    5.413804] calling  crypto_wq_init+0x0/0x4c @ 1
[    5.418910] initcall crypto_wq_init+0x0/0x4c returned 0 after 378 usecs
[    5.425640] calling  crypto_algapi_init+0x0/0x1b @ 1
[    5.430825] initcall crypto_algapi_init+0x0/0x1b returned 0 after 113 usecs
[    5.437909] calling  skcipher_module_init+0x0/0x4e @ 1
[    5.443169] initcall skcipher_module_init+0x0/0x4e returned 0 after 0 usecs
[    5.450235] calling  chainiv_module_init+0x0/0x20 @ 1
[    5.455434] initcall chainiv_module_init+0x0/0x20 returned 0 after 40 usecs
[    5.462505] calling  eseqiv_module_init+0x0/0x20 @ 1
[    5.467579] initcall eseqiv_module_init+0x0/0x20 returned 0 after 4 usecs
[    5.474473] calling  hmac_module_init+0x0/0x20 @ 1
[    5.479377] initcall hmac_module_init+0x0/0x20 returned 0 after 4 usecs
[    5.486097] calling  md5_mod_init+0x0/0x20 @ 1
[    5.490998] initcall md5_mod_init+0x0/0x20 returned 0 after 336 usecs
[    5.491005] cryptomgr_test used greatest stack depth: 5816 bytes left
[    5.504111] calling  sha1_generic_mod_init+0x0/0x20 @ 1
[    5.509729] initcall sha1_generic_mod_init+0x0/0x20 returned 0 after 275 usecs
[    5.517146] calling  krng_mod_init+0x0/0x20 @ 1
[    5.521947] alg: No test for stdrng (krng)
[    5.526292] initcall krng_mod_init+0x0/0x20 returned 0 after 4401 usecs
[    5.533027] calling  proc_genhd_init+0x0/0x51 @ 1
[    5.537868] initcall proc_genhd_init+0x0/0x51 returned 0 after 33 usecs
[    5.544579] calling  bsg_init+0x0/0x1ae @ 1
[    5.550006] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    5.557578] initcall bsg_init+0x0/0x1ae returned 0 after 8509 usecs
[    5.563944] calling  noop_init+0x0/0x22 @ 1
[    5.568246] io scheduler noop registered
[    5.572268] initcall noop_init+0x0/0x22 returned 0 after 3943 usecs
[    5.578632] calling  deadline_init+0x0/0x22 @ 1
[    5.583261] io scheduler deadline registered
[    5.587628] initcall deadline_init+0x0/0x22 returned 0 after 4263 usecs
[    5.594338] calling  cfq_init+0x0/0xda @ 1
[    5.599941] io scheduler cfq registered (default)
[    5.604777] initcall cfq_init+0x0/0xda returned 0 after 6096 usecs
[    5.611055] calling  percpu_counter_startup+0x0/0x2e @ 1
[    5.616504] initcall percpu_counter_startup+0x0/0x2e returned 0 after 34 usecs
[    5.623953] calling  dynamic_debug_init+0x0/0x1aa @ 1
[    5.629505] initcall dynamic_debug_init+0x0/0x1aa returned 0 after 394 usecs
[    5.636652] calling  lnw_gpio_init+0x0/0x29 @ 1
[    5.641751] initcall lnw_gpio_init+0x0/0x29 returned 0 after 456 usecs
[    5.648411] calling  pci_proc_init+0x0/0x94 @ 1
[    5.653576] initcall pci_proc_init+0x0/0x94 returned 0 after 522 usecs
[    5.660225] calling  pcie_portdrv_init+0x0/0x90 @ 1
[    5.665702] pcieport 0000:00:01.0: setting latency timer to 64
[    5.671800]   alloc irq_desc for 24 on node -1
[    5.672627]   alloc kstat_irqs on node -1
[    5.680491] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    5.686912] pcieport 0000:00:1c.0: setting latency timer to 64
[    5.692975]   alloc irq_desc for 25 on node -1
[    5.693839]   alloc kstat_irqs on node -1
[    5.701701] pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X
[    5.708637] pcieport 0000:00:1c.1: setting latency timer to 64
[    5.714757]   alloc irq_desc for 26 on node -1
[    5.715561]   alloc kstat_irqs on node -1
[    5.723463] pcieport 0000:00:1c.1: irq 26 for MSI/MSI-X
[    5.730818] initcall pcie_portdrv_init+0x0/0x90 returned 0 after 64075 usecs
[    5.738083] calling  aer_service_init+0x0/0x50 @ 1
[    5.743555] initcall aer_service_init+0x0/0x50 returned 0 after 555 usecs
[    5.750469] calling  pcie_pme_service_init+0x0/0x37 @ 1
[    5.755861] pcieport 0000:00:01.0: Requesting control of PCIe PME from ACPI BIOS
[    5.763484] pcieport 0000:00:01.0: Failed to receive control of PCIe PME service: no _OSC support
[    5.772591] pcie_pme: probe of 0000:00:01.0:pcie01 failed with error -13
[    5.779419] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    5.786996] pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: no _OSC support
[    5.796062] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
[    5.802896] pcieport 0000:00:1c.1: Requesting control of PCIe PME from ACPI BIOS
[    5.810467] pcieport 0000:00:1c.1: Failed to receive control of PCIe PME service: no _OSC support
[    5.819518] pcie_pme: probe of 0000:00:1c.1:pcie01 failed with error -13
[    5.826727] initcall pcie_pme_service_init+0x0/0x37 returned 0 after 69263 usecs
[    5.834300] calling  ioapic_init+0x0/0x29 @ 1
[    5.839260] initcall ioapic_init+0x0/0x29 returned 0 after 485 usecs
[    5.845720] calling  vesafb_init+0x0/0x331 @ 1
[    5.852295] initcall vesafb_init+0x0/0x331 returned -19 after 1974 usecs
[    5.859298] calling  efifb_init+0x0/0x2be @ 1
[    5.863772] initcall efifb_init+0x0/0x2be returned -19 after 6 usecs
[    5.870228] calling  acpi_reserve_resources+0x0/0x141 @ 1
[    5.875748] initcall acpi_reserve_resources+0x0/0x141 returned 0 after 15 usecs
[    5.883266] calling  irqrouter_init_sysfs+0x0/0x62 @ 1
[    5.889347] initcall irqrouter_init_sysfs+0x0/0x62 returned 0 after 815 usecs
[    5.896609] calling  rand_initialize+0x0/0x48 @ 1
[    5.901453] initcall rand_initialize+0x0/0x48 returned 0 after 35 usecs
[    5.908171] calling  tty_init+0x0/0x15a @ 1
[    5.927989] khelper used greatest stack depth: 5672 bytes left
[    5.956757] initcall tty_init+0x0/0x15a returned 0 after 43253 usecs
[    5.963217] calling  pty_init+0x0/0x603 @ 1
[    6.250036] initcall pty_init+0x0/0x603 returned 0 after 275904 usecs
[    6.256607] calling  sysrq_init+0x0/0x33 @ 1
[    6.261005] initcall sysrq_init+0x0/0x33 returned 0 after 26 usecs
[    6.267298] calling  hpet_init+0x0/0xab @ 1
[    6.272637] initcall hpet_init+0x0/0xab returned 0 after 1024 usecs
[    6.279048] calling  agp_init+0x0/0x3b @ 1
[    6.283246] Linux agpgart interface v0.103
[    6.287444] initcall agp_init+0x0/0x3b returned 0 after 4096 usecs
[    6.293722] calling  drm_core_init+0x0/0x1ab @ 1
[    6.298890] [drm] Initialized drm 1.1.0 20060810
[    6.303619] initcall drm_core_init+0x0/0x1ab returned 0 after 5055 usecs
[    6.310420] calling  cn_proc_init+0x0/0x5b @ 1
[    6.315026] initcall cn_proc_init+0x0/0x5b returned 0 after 61 usecs
[    6.321486] calling  serial8250_init+0x0/0x222 @ 1
[    6.326375] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.333499] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    6.342393] initcall serial8250_init+0x0/0x222 returned 0 after 15633 usecs
[    6.349469] calling  serial8250_pnp_init+0x0/0x20 @ 1
[    6.356237] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    6.362911] initcall serial8250_pnp_init+0x0/0x20 returned 0 after 8089 usecs
[    6.370176] calling  serial8250_pci_init+0x0/0x29 @ 1
[    6.375838] initcall serial8250_pci_init+0x0/0x29 returned 0 after 494 usecs
[    6.382998] calling  topology_sysfs_init+0x0/0x89 @ 1
[    6.388240] initcall topology_sysfs_init+0x0/0x89 returned 0 after 65 usecs
[    6.395299] calling  init_kgdbts+0x0/0x2d @ 1
[    6.399754] initcall init_kgdbts+0x0/0x2d returned 0 after 0 usecs
[    6.406040] calling  fixed_mdio_bus_init+0x0/0x13a @ 1
[    6.412228] Fixed MDIO Bus: probed
[    6.415743] initcall fixed_mdio_bus_init+0x0/0x13a returned 0 after 4359 usecs
[    6.423138] calling  tg3_init+0x0/0x29 @ 1
[    6.427414] tg3.c:v3.108 (February 17, 2010)
[    6.431818] tg3 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.438630] tg3 0000:02:00.0: setting latency timer to 64
[    6.454495] tg3 0000:02:00.0: eth0: Tigon3 [partno(BCM5751PKFBG) rev 4001] (PCI Express) MAC address 00:18:8b:01:d2:2b
[    6.467210] tg3 0000:02:00.0: eth0: attached PHY is 5750 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    6.476499] tg3 0000:02:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    6.484579] tg3 0000:02:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    6.491879] initcall tg3_init+0x0/0x29 returned 0 after 63027 usecs
[    6.498259] calling  net_olddevs_init+0x0/0x11c @ 1
[    6.503247] initcall net_olddevs_init+0x0/0x11c returned 0 after 6 usecs
[    6.510045] calling  init_netconsole+0x0/0x2c6 @ 1
[    6.514939] console [netcon0] enabled
[    6.518712] netconsole: network logging started
[    6.523343] initcall init_netconsole+0x0/0x2c6 returned 0 after 8212 usecs
[    6.530314] calling  i8042_init+0x0/0x50e @ 1
[    6.536608] PNP: No PS/2 controller found. Probing ports directly.
[    6.546346] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.551482] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.557434] initcall i8042_init+0x0/0x50e returned 0 after 22127 usecs
[    6.564104] calling  mousedev_init+0x0/0xd8 @ 1
[    6.570120] mice: PS/2 mouse device common for all mice
[    6.575465] initcall mousedev_init+0x0/0xd8 returned 0 after 6556 usecs
[    6.582182] calling  atkbd_init+0x0/0x3c @ 1
[    6.586995] initcall atkbd_init+0x0/0x3c returned 0 after 426 usecs
[    6.593396] calling  init_ladder+0x0/0x20 @ 1
[    6.597935] cpuidle: using governor ladder
[    6.602175] initcall init_ladder+0x0/0x20 returned 0 after 4172 usecs
[    6.608768] calling  init_menu+0x0/0x20 @ 1
[    6.613075] cpuidle: using governor menu
[    6.617110] initcall init_menu+0x0/0x20 returned 0 after 3942 usecs
[    6.623538] calling  ledtrig_ide_init+0x0/0x29 @ 1
[    6.628482] initcall ledtrig_ide_init+0x0/0x29 returned 0 after 34 usecs
[    6.635343] calling  hid_init+0x0/0xac @ 1
[    6.640439] initcall hid_init+0x0/0xac returned 0 after 862 usecs
[    6.646634] calling  flow_cache_init+0x0/0x20d @ 1
[    6.652218] initcall flow_cache_init+0x0/0x20d returned 0 after 675 usecs
[    6.659121] calling  sysctl_ipv4_init+0x0/0x75 @ 1
[    6.666318] initcall sysctl_ipv4_init+0x0/0x75 returned 0 after 2239 usecs
[    6.673289] calling  init_syncookies+0x0/0x27 @ 1
[    6.678162] initcall init_syncookies+0x0/0x27 returned 0 after 64 usecs
[    6.684873] calling  cubictcp_register+0x0/0x76 @ 1
[    6.689851] TCP cubic registered
[    6.693183] initcall cubictcp_register+0x0/0x76 returned 0 after 3252 usecs
[    6.700240] calling  packet_init+0x0/0x71 @ 1
[    6.704772] NET: Registered protocol family 17
[    6.709421] initcall packet_init+0x0/0x71 returned 0 after 4546 usecs
[    6.716030] calling  mcheck_debugfs_init+0x0/0x60 @ 1
[    6.721238] initcall mcheck_debugfs_init+0x0/0x60 returned 0 after 41 usecs
[    6.728303] calling  severities_debugfs_init+0x0/0x5e @ 1
[    6.733831] initcall severities_debugfs_init+0x0/0x5e returned 0 after 21 usecs
[    6.741356] calling  hpet_insert_resource+0x0/0x3a @ 1
[    6.746605] initcall hpet_insert_resource+0x0/0x3a returned 0 after 3 usecs
[    6.753671] calling  update_mp_table+0x0/0x85c @ 1
[    6.758569] initcall update_mp_table+0x0/0x85c returned 0 after 0 usecs
[    6.765288] calling  lapic_insert_resource+0x0/0x55 @ 1
[    6.770622] initcall lapic_insert_resource+0x0/0x55 returned 0 after 2 usecs
[    6.777775] calling  init_lapic_nmi_sysfs+0x0/0x65 @ 1
[    6.783051] initcall init_lapic_nmi_sysfs+0x0/0x65 returned 0 after 2 usecs
[    6.790122] calling  io_apic_bug_finalize+0x0/0x29 @ 1
[    6.795364] initcall io_apic_bug_finalize+0x0/0x29 returned 0 after 0 usecs
[    6.802427] calling  check_early_ioremap_leak+0x0/0x91 @ 1
[    6.808054] initcall check_early_ioremap_leak+0x0/0x91 returned 0 after 0 usecs
[    6.815537] calling  pat_memtype_list_init+0x0/0x47 @ 1
[    6.820908] initcall pat_memtype_list_init+0x0/0x47 returned 0 after 39 usecs
[    6.828166] calling  sched_init_debug+0x0/0x32 @ 1
[    6.833085] initcall sched_init_debug+0x0/0x32 returned 0 after 21 usecs
[    6.839905] calling  init_oops_id+0x0/0x46 @ 1
[    6.844473] initcall init_oops_id+0x0/0x46 returned 0 after 10 usecs
[    6.850932] calling  disable_boot_consoles+0x0/0x67 @ 1
[    6.856274] initcall disable_boot_consoles+0x0/0x67 returned 0 after 0 usecs
[    6.863424] calling  pm_qos_power_init+0x0/0xb9 @ 1
[    6.870179] initcall pm_qos_power_init+0x0/0xb9 returned 0 after 1725 usecs
[    6.877265] calling  software_resume+0x0/0x4ad @ 1
[    6.882185] initcall software_resume+0x0/0x4ad returned -2 after 21 usecs
[    6.889079] initcall software_resume+0x0/0x4ad returned with error code -2 
[    6.896146] calling  debugfs_kprobe_init+0x0/0xcf @ 1
[    6.901363] initcall debugfs_kprobe_init+0x0/0xcf returned 0 after 57 usecs
[    6.908528] calling  taskstats_init+0x0/0xe0 @ 1
[    6.913303] registered taskstats version 1
[    6.917513] initcall taskstats_init+0x0/0xe0 returned 0 after 4161 usecs
[    6.924320] calling  max_swapfiles_check+0x0/0xf @ 1
[    6.929390] initcall max_swapfiles_check+0x0/0xf returned 0 after 0 usecs
[    6.936284] calling  random32_reseed+0x0/0xdc @ 1
[    6.941145] initcall random32_reseed+0x0/0xdc returned 0 after 49 usecs
[    6.947863] calling  pci_resource_alignment_sysfs_init+0x0/0x27 @ 1
[    6.954245] initcall pci_resource_alignment_sysfs_init+0x0/0x27 returned 0 after 10 usecs
[    6.962609] calling  pci_sysfs_init+0x0/0x7b @ 1
[    6.968185] initcall pci_sysfs_init+0x0/0x7b returned 0 after 831 usecs
[    6.974905] calling  seqgen_init+0x0/0x1d @ 1
[    6.979397] initcall seqgen_init+0x0/0x1d returned 0 after 22 usecs
[    6.985769] calling  memmap_init+0x0/0x5b @ 1
[    6.990487] initcall memmap_init+0x0/0x5b returned 0 after 247 usecs
[    6.996953] calling  pci_mmcfg_late_insert_resources+0x0/0x97 @ 1
[    7.003208] initcall pci_mmcfg_late_insert_resources+0x0/0x97 returned 0 after 6 usecs
[    7.011298] calling  tcp_congestion_default+0x0/0x20 @ 1
[    7.016721] initcall tcp_congestion_default+0x0/0x20 returned 0 after 2 usecs
[    7.023961] calling  ip_auto_config+0x0/0x1285 @ 1
[    7.028889] initcall ip_auto_config+0x0/0x1285 returned 0 after 20 usecs
[    7.035697] calling  initialize_hashrnd+0x0/0x27 @ 1
[    7.040773] initcall initialize_hashrnd+0x0/0x27 returned 0 after 7 usecs
[    7.048042] async_waiting @ 1
[    7.051143] async_continuing @ 1 after 22 usec
[    7.055759] Freeing unused kernel memory: 3180k freed
[    7.062706] Write protecting the kernel read-only data: 8192k
[    7.070418] Freeing unused kernel memory: 2044k freed
[    7.076961] Freeing unused kernel memory: 180k freed
[    7.568597] calling  usb_init+0x0/0x270 [usbcore] @ 990
[    7.574383] usbcore: registered new interface driver usbfs
[    7.580350] usbcore: registered new interface driver hub
[    7.586198] usbcore: registered new device driver usb
[    7.591372] initcall usb_init+0x0/0x270 [usbcore] returned 0 after 17003 usecs
[    7.603519] calling  ehci_hcd_init+0x0/0x136 [ehci_hcd] @ 990
[    7.609378] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.616119]   alloc irq_desc for 21 on node -1
[    7.617005]   alloc kstat_irqs on node -1
[    7.624801] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    7.632096] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    7.638037] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    7.643642] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    7.651351] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    7.657735] ehci_hcd 0000:00:1d.7: debug port 1
[    7.666275] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    7.673247] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xffa80800
[    7.688053] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    7.694278] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.701163] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.708563] usb usb1: Product: EHCI Host Controller
[    7.713543] usb usb1: Manufacturer: Linux 2.6.34-rc7 ehci_hcd
[    7.719391] usb usb1: SerialNumber: 0000:00:1d.7
[    7.725245] hub 1-0:1.0: USB hub found
[    7.729153] hub 1-0:1.0: 8 ports detected
[    7.734370] initcall ehci_hcd_init+0x0/0x136 [ehci_hcd] returned 0 after 122055 usecs
[    7.742702] modprobe used greatest stack depth: 4336 bytes left
[    7.758815] calling  init_pcmcia_cs+0x0/0x4b [pcmcia_core] @ 992
[    7.765078] initcall init_pcmcia_cs+0x0/0x4b [pcmcia_core] returned 0 after 131 usecs
[    7.780287] calling  init_pcmcia_bus+0x0/0x9d [pcmcia] @ 992
[    7.786301] initcall init_pcmcia_bus+0x0/0x9d [pcmcia] returned 0 after 235 usecs
[    7.807165] calling  mmc_init+0x0/0xd8 [mmc_core] @ 992
[    7.813193] initcall mmc_init+0x0/0xd8 [mmc_core] returned 0 after 662 usecs
[    7.830528] calling  ssb_modinit+0x0/0xb2 [ssb] @ 992
[    7.836421] initcall ssb_modinit+0x0/0xb2 [ssb] returned 0 after 633 usecs
[    7.848638] calling  ohci_hcd_mod_init+0x0/0x135 [ohci_hcd] @ 992
[    7.854852] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.861551] initcall ohci_hcd_mod_init+0x0/0x135 [ohci_hcd] returned 0 after 6536 usecs
[    7.878661] calling  uhci_hcd_init+0x0/0x12b [uhci_hcd] @ 994
[    7.884610] uhci_hcd: USB Universal Host Controller Interface driver
[    7.891574] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    7.898891] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    7.904841] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    7.910231] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    7.917878] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000ff80
[    7.923997] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    7.930901] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.938308] usb usb2: Product: UHCI Host Controller
[    7.943293] usb usb2: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
[    7.949177] usb usb2: SerialNumber: 0000:00:1d.0
[    7.955019] hub 2-0:1.0: USB hub found
[    7.958993] hub 2-0:1.0: 2 ports detected
[    7.963858]   alloc irq_desc for 22 on node -1
[    7.964097]   alloc kstat_irqs on node -1
[    7.972532] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    7.979798] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    7.985738] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    7.991151] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    8.000689] uhci_hcd 0000:00:1d.1: irq 22, io base 0x0000ff60
[    8.006790] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    8.013717] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.021110] usb usb3: Product: UHCI Host Controller
[    8.026099] usb usb3: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
[    8.031950] usb usb3: SerialNumber: 0000:00:1d.1
[    8.037516] hub 3-0:1.0: USB hub found
[    8.041406] hub 3-0:1.0: 2 ports detected
[    8.046264]   alloc irq_desc for 18 on node -1
[    8.047005]   alloc kstat_irqs on node -1
[    8.054927] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    8.062192] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    8.068182] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    8.073743] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    8.081429] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[    8.087539] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    8.094428] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.101815] usb usb4: Product: UHCI Host Controller
[    8.106795] usb usb4: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
[    8.112643] usb usb4: SerialNumber: 0000:00:1d.2
[    8.118226] hub 4-0:1.0: USB hub found
[    8.122115] hub 4-0:1.0: 2 ports detected
[    8.126941]   alloc irq_desc for 23 on node -1
[    8.127225]   alloc kstat_irqs on node -1
[    8.135613] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    8.142898] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    8.148855] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    8.154331] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    8.162016] uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000ff20
[    8.168121] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    8.175016] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.182409] usb usb5: Product: UHCI Host Controller
[    8.187391] usb usb5: Manufacturer: Linux 2.6.34-rc7 uhci_hcd
[    8.193238] usb usb5: SerialNumber: 0000:00:1d.3
[    8.198772] hub 5-0:1.0: USB hub found
[    8.202665] hub 5-0:1.0: 2 ports detected
[    8.207753] initcall uhci_hcd_init+0x0/0x12b [uhci_hcd] returned 0 after 315560 usecs
[    8.224896] calling  init_mbcache+0x0/0x22 [mbcache] @ 995
[    8.230698] initcall init_mbcache+0x0/0x22 [mbcache] returned 0 after 119 usecs
[    8.246134] calling  journal_init+0x0/0x114 [jbd] @ 995
[    8.252945] initcall journal_init+0x0/0x114 [jbd] returned 0 after 1425 usecs
[    8.275605] calling  init_ext3_fs+0x0/0xbf [ext3] @ 995
[    8.281810] initcall init_ext3_fs+0x0/0xbf [ext3] returned 0 after 840 usecs
[    8.325982] calling  init_scsi+0x0/0x131 [scsi_mod] @ 997
[    8.334941] SCSI subsystem initialized
[    8.338823] initcall init_scsi+0x0/0x131 [scsi_mod] returned 0 after 7138 usecs
[    8.358431] calling  init_sd+0x0/0x227 [sd_mod] @ 998
[    8.364275] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    8.364468] initcall init_sd+0x0/0x227 [sd_mod] returned 0 after 844 usecs
[    8.391215] calling  ide_init+0x0/0xcc [ide_core] @ 999
[    8.396556] Uniform Multi-Platform E-IDE driver
[    8.401537] initcall ide_init+0x0/0xcc [ide_core] returned 0 after 4852 usecs
[    8.415627] calling  generic_ide_init+0x0/0x2e [ide_pci_generic] @ 1000
[    8.422666] initcall generic_ide_init+0x0/0x2e [ide_pci_generic] returned 0 after 294 usecs
[    8.464773] calling  ata_init+0x0/0x470 [libata] @ 1001
[    8.470757] libata version 3.00 loaded.
[    8.474758] initcall ata_init+0x0/0x470 [libata] returned 0 after 4521 usecs
[    8.492342] calling  piix_init+0x0/0x45 [ata_piix] @ 1005
[    8.497950] ata_piix 0000:00:1f.1: version 2.13
[    8.502622] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.510275] ata_piix 0000:00:1f.1: setting latency timer to 64
[    8.516677] scsi0 : ata_piix
[    8.521051] scsi1 : ata_piix
[    8.530427] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    8.537568] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    8.544858]   alloc irq_desc for 20 on node -1
[    8.545523] ata2: port disabled. ignoring.
[    8.545621]   alloc kstat_irqs on node -1
[    8.557809] ata_piix 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    8.565096] ata_piix 0000:00:1f.2: MAP [
[    8.565103] usb 3-1: New USB device found, idVendor=413c, idProduct=1003
[    8.565110] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.565116] usb 3-1: Product: Dell USB Keyboard Hub
[    8.565119] usb 3-1: Manufacturer: Dell
[    8.592083]  P0 P2 P1 P3 ]
[    8.596840] hub 3-1:1.0: USB hub found
[    8.601699] hub 3-1:1.0: 3 ports detected
[    8.698495] ata1.00: ATAPI: HL-DT-STDVD+-RW GSA-H21N, A105, max UDMA/33
[    8.711398] ata1.00: configured for UDMA/33
[    8.719569] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-H21N A105 PQ: 0 ANSI: 5
[    8.746096] ata_piix 0000:00:1f.2: setting latency timer to 64
[    8.752432] scsi2 : ata_piix
[    8.755982] scsi3 : ata_piix
[    8.759284] ata3: SATA max UDMA/133 cmd 0xfe00 ctl 0xfe10 bmdma 0xfea0 irq 20
[    8.766520] ata4: SATA max UDMA/133 cmd 0xfe20 ctl 0xfe30 bmdma 0xfea8 irq 20
[    8.774254] initcall piix_init+0x0/0x45 [ata_piix] returned 0 after 269905 usecs
[    8.881707] usb 3-1.1: new full speed USB device using uhci_hcd and address 3
[    8.928358] ata3.00: ATA-7: WDC WD2500JS-75NCB3, 10.02E04, max UDMA/133
[    8.935095] ata3.00: 488281250 sectors, multi 8: LBA48 NCQ (depth 0/32)
[    8.945360] ata3.00: configured for UDMA/133
[    8.950230] scsi 2:0:0:0: Direct-Access     ATA      WDC WD2500JS-75N 10.0 PQ: 0 ANSI: 5
[    8.960180] sd 2:0:0:0: [sda] 488281250 512-byte logical blocks: (250 GB/232 GiB)
[    8.968374] sd 2:0:0:0: [sda] Write Protect is off
[    8.973298] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    8.978728] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.989026]  sda: sda1 sda2 sda3 sda4 < sda5
[    9.030718] usb 3-1.1: New USB device found, idVendor=413c, idProduct=2010
[    9.038027] usb 3-1.1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[    9.045578] usb 3-1.1: Product: Dell USB Keyboard
[    9.046166]  sda6 >
[    9.052593] usb 3-1.1: Manufacturer: Dell
[    9.054555] sd 2:0:0:0: [sda] Attached SCSI disk
[    9.137718] usb 3-1.3: new low speed USB device using uhci_hcd and address 4
[    9.271726] usb 3-1.3: New USB device found, idVendor=046d, idProduct=c016
[    9.278742] usb 3-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    9.286229] usb 3-1.3: Product: Optical USB Mouse
[    9.291034] usb 3-1.3: Manufacturer: Logitech
[   10.567620] calling  pacpi_init+0x0/0x2e [pata_acpi] @ 1013
[   10.573569] initcall pacpi_init+0x0/0x2e [pata_acpi] returned 0 after 216 usecs
[   10.589302] calling  ata_generic_init+0x0/0x2e [ata_generic] @ 1014
[   10.595926] initcall ata_generic_init+0x0/0x2e [ata_generic] returned 0 after 230 usecs
[   10.609470] calling  wait_scan_init+0x0/0x1b [scsi_wait_scan] @ 1015
[   10.615945] initcall wait_scan_init+0x0/0x1b [scsi_wait_scan] returned 0 after 2 usecs
[   10.890103] kjournald starting.  Commit interval 5 seconds
[   10.893371] EXT3-fs (sda6): mounted filesystem with writeback data mode
[   11.297782] modprobe used greatest stack depth: 3800 bytes left
[   13.366897] udev: starting version 141
[   13.370912] udev: deprecated sysfs layout; update the kernel or disable CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
[   14.044022] calling  cdrom_init+0x0/0x1b [cdrom] @ 1164
[   14.090913] initcall cdrom_init+0x0/0x1b [cdrom] returned 0 after 40479 usecs
[   14.277706] calling  init_sr+0x0/0x72 [sr_mod] @ 1164
[   14.320086] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   14.327203] Uniform CD-ROM driver Revision: 3.20
[   14.351652] sr 0:0:0:0: Attached scsi CD-ROM sr0
[   14.371620] initcall init_sr+0x0/0x72 [sr_mod] returned 0 after 86594 usecs
[   17.356522] calling  acpi_button_init+0x0/0x7d [button] @ 1980
[   17.384940] calling  agp_intel_init+0x0/0x45 [intel_agp] @ 1987
[   17.406217] calling  hwmon_init+0x0/0x186 [hwmon] @ 1977
[   17.427857] input: Power Button as /class/input/input0
[   17.433381] initcall hwmon_init+0x0/0x186 [hwmon] returned 0 after 21169 usecs
[   17.448008] calling  thermal_init+0x0/0x88 [thermal_sys] @ 1982
[   17.474234] agpgart-intel 0000:00:00.0: Intel 945G Chipset
[   17.489160] initcall thermal_init+0x0/0x88 [thermal_sys] returned 0 after 34230 usecs
[   17.505218] ACPI: Power Button [VBTN]
[   17.526940] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[   17.538963] input: Power Button as /class/input/input1
[   17.550652] ACPI: Power Button [PWRF]
[   17.552766] calling  acpi_processor_init+0x0/0x159 [processor] @ 1974
[   17.568130] calling  acpi_thermal_init+0x0/0xb7 [thermal] @ 1983
[   17.592523] initcall acpi_thermal_init+0x0/0xb7 [thermal] returned 0 after 17755 usecs
[   17.601670] initcall acpi_processor_init+0x0/0x159 [processor] returned 0 after 47743 usecs
[   17.616485] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[   17.644192] initcall acpi_button_init+0x0/0x7d [button] returned 0 after 275044 usecs
[   17.686335] initcall agp_intel_init+0x0/0x45 [intel_agp] returned 0 after 288352 usecs
[   17.748751] calling  rtc_init+0x0/0xa0 [rtc_core] @ 2051
[   17.768345] initcall rtc_init+0x0/0xa0 [rtc_core] returned 0 after 13766 usecs
[   17.844595] calling  mod_init+0x0/0x312 [intel_rng] @ 2087
[   17.872322] intel_rng: Firmware space is locked read-only. If you can't or
[   17.872326] intel_rng: don't want to disable this in firmware setup, and if
[   17.872330] intel_rng: you are certain that your system has a functional
[   17.872333] intel_rng: RNG, try using the 'no_fwh_detect' option.
[   17.901424] initcall mod_init+0x0/0x312 [intel_rng] returned -16 after 49950 usecs
[   17.909239] initcall mod_init+0x0/0x312 [intel_rng] returned with error code -16 
[   17.938074] calling  parport_default_proc_register+0x0/0x29 [parport] @ 2047
[   17.948399] calling  i2c_i801_init+0x0/0x106 [i2c_i801] @ 2095
[   17.951648] initcall parport_default_proc_register+0x0/0x29 [parport] returned 0 after 6025 usecs
[   17.969321] calling  cmos_init+0x0/0xad [rtc_cmos] @ 2051
[   17.974598] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   17.976418] initcall i2c_i801_init+0x0/0x106 [i2c_i801] returned 0 after 12715 usecs
[   17.990564] rtc_cmos 00:05: RTC can wake from S4
[   17.995954] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[   18.003126] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[   18.009733] initcall cmos_init+0x0/0xad [rtc_cmos] returned 0 after 18898 usecs
[   18.039790] calling  init_sg+0x0/0x1a7 [sg] @ 2111
[   18.045774] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   18.051509] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   18.057286] initcall init_sg+0x0/0x1a7 [sg] returned 0 after 12235 usecs
[   18.071802] calling  snd_mem_init+0x0/0x3a [snd_page_alloc] @ 2086
[   18.078191] initcall snd_mem_init+0x0/0x3a [snd_page_alloc] returned 0 after 55 usecs
[   18.099431] calling  init_soundcore+0x0/0xd9 [soundcore] @ 2086
[   18.105789] initcall init_soundcore+0x0/0xd9 [soundcore] returned 0 after 270 usecs
[   18.208684] calling  pcspkr_init+0x0/0x20 [pcspkr] @ 2107
[   18.214874] input: PC Speaker as /class/input/input2
[   18.220405] initcall pcspkr_init+0x0/0x20 [pcspkr] returned 0 after 6017 usecs
[   18.236952] calling  evdev_init+0x0/0x20 [evdev] @ 2155
[   18.243626] initcall evdev_init+0x0/0x20 [evdev] returned 0 after 1094 usecs
[   18.254626] calling  serio_raw_init+0x0/0x2e [serio_raw] @ 2103
[   18.261769] initcall serio_raw_init+0x0/0x2e [serio_raw] returned 0 after 1029 usecs
[   18.282351] calling  iTCO_vendor_init_module+0x0/0x2a [iTCO_vendor_support] @ 2087
[   18.290166] iTCO_vendor_support: vendor-support=0
[   18.295278] initcall iTCO_vendor_init_module+0x0/0x2a [iTCO_vendor_support] returned 0 after 4986 usecs
[   18.313853] calling  parport_pc_init+0x0/0x7fa [parport_pc] @ 2047
[   18.322233] parport_pc 00:06: reported by Plug and Play ACPI
[   18.328278] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
[   18.363212] calling  iTCO_wdt_init_module+0x0/0x9b [iTCO_wdt] @ 2087
[   18.369712] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   18.376732] iTCO_wdt: unable to reset NO_REBOOT flag, platform may have disabled it
[   18.384901] initcall iTCO_wdt_init_module+0x0/0x9b [iTCO_wdt] returned 0 after 14823 usecs
[   18.420674] calling  psmouse_init+0x0/0xc1 [psmouse] @ 2105
[   18.429653] initcall parport_pc_init+0x0/0x7fa [parport_pc] returned 0 after 106892 usecs
[   18.436240] initcall psmouse_init+0x0/0xc1 [psmouse] returned 0 after 9506 usecs
[   18.459809] calling  ppdev_init+0x0/0x128 [ppdev] @ 2206
[   18.473504] ppdev: user-space parallel port driver
[   18.478483] initcall ppdev_init+0x0/0x128 [ppdev] returned 0 after 12872 usecs
[   18.536306] calling  alsa_sound_init+0x0/0xce [snd] @ 2086
[   18.542381] initcall alsa_sound_init+0x0/0xce [snd] returned 0 after 274 usecs
[   18.580787] calling  leds_init+0x0/0x60 [led_class] @ 2087
[   18.586744] initcall leds_init+0x0/0x60 [led_class] returned 0 after 272 usecs
[   18.615721] calling  alsa_timer_init+0x0/0x21d [snd_timer] @ 2086
[   18.622842] initcall alsa_timer_init+0x0/0x21d [snd_timer] returned 0 after 836 usecs
[   18.644305] calling  nas_gpio_init+0x0/0x31f [leds_ss4200] @ 2087
[   18.650577] leds_ss4200: no LED devices found
[   18.655041] initcall nas_gpio_init+0x0/0x31f [leds_ss4200] returned -19 after 4356 usecs
[   18.678904] calling  hid_init+0x0/0x149 [usbhid] @ 2148
[   18.691308] usbcore: registered new interface driver hiddev
[   18.701861] input: Dell Dell USB Keyboard as /class/input/input3
[   18.715288] generic-usb 0003:413C:2010.0001: input,hidraw0: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.1-1.1/input0
[   18.743906] input: Dell Dell USB Keyboard as /class/input/input4
[   18.747449] calling  alsa_pcm_init+0x0/0xa9 [snd_pcm] @ 2238
[   18.747584] initcall alsa_pcm_init+0x0/0xa9 [snd_pcm] returned 0 after 119 usecs
[   18.764312] generic-usb 0003:413C:2010.0002: input,hidraw1: USB HID v1.10 Device [Dell Dell USB Keyboard] on usb-0000:00:1d.1-1.1/input1
[   18.793204] calling  alsa_seq_device_init+0x0/0x87 [snd_seq_device] @ 2253
[   18.801407] input: Logitech Optical USB Mouse as /class/input/input5
[   18.804068] initcall alsa_seq_device_init+0x0/0x87 [snd_seq_device] returned 0 after 3646 usecs
[   18.818057] generic-usb 0003:046D:C016.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.1-1.3/input0
[   18.842590] usbcore: registered new interface driver usbhid
[   18.848595] usbhid: USB HID core driver
[   18.852674] initcall hid_init+0x0/0x149 [usbhid] returned 0 after 164357 usecs
[   18.889842] calling  alsa_seq_init+0x0/0xae [snd_seq] @ 2253
[   18.908991] initcall alsa_seq_init+0x0/0xae [snd_seq] returned 0 after 12755 usecs
[   18.973380] calling  joydev_init+0x0/0x20 [joydev] @ 2280
[   18.978954] initcall joydev_init+0x0/0x20 [joydev] returned 0 after 11 usecs
[   18.994240] calling  ac97_bus_init+0x0/0x20 [ac97_bus] @ 2086
[   19.000533] initcall ac97_bus_init+0x0/0x20 [ac97_bus] returned 0 after 350 usecs
[   19.076764] calling  alsa_ac97_init+0x0/0xf [snd_ac97_codec] @ 2086
[   19.083183] initcall alsa_ac97_init+0x0/0xf [snd_ac97_codec] returned 0 after 0 usecs
[   19.131043] calling  alsa_card_intel8x0_init+0x0/0x2e [snd_intel8x0] @ 2086
[   19.138521] Intel ICH 0000:00:1e.2: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   19.146144] Intel ICH 0000:00:1e.2: setting latency timer to 64
[   19.518365] intel8x0: white list rate for 1028:01ad is 48000
[   19.527683] initcall alsa_card_intel8x0_init+0x0/0x2e [snd_intel8x0] returned 0 after 380376 usecs
[   19.646240] calling  uinput_init+0x0/0x20 [uinput] @ 2305
[   19.652255] initcall uinput_init+0x0/0x20 [uinput] returned 0 after 443 usecs
[   19.745341] calling  wait_scan_init+0x0/0x1b [scsi_wait_scan] @ 2318
[   19.751869] initcall wait_scan_init+0x0/0x1b [scsi_wait_scan] returned 0 after 2 usecs
[   21.768099] EXT3-fs (sda6): using internal journal
[   21.993129] kjournald starting.  Commit interval 5 seconds
[   22.018449] EXT3-fs (sda1): using internal journal
[   22.023477] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   22.087343] kjournald starting.  Commit interval 5 seconds
[   22.087725] EXT3-fs (sda3): using internal journal
[   22.087745] EXT3-fs (sda3): mounted filesystem with writeback data mode
[   22.160990] kjournald starting.  Commit interval 5 seconds
[   22.161339] EXT3-fs (sda5): using internal journal
[   22.161359] EXT3-fs (sda5): mounted filesystem with writeback data mode
[   23.439334] Adding 4194300k swap on /dev/sda2.  Priority:-1 extents:1 across:4194300k 
[   29.174648] calling  acpi_cpufreq_init+0x0/0x12c [acpi_cpufreq] @ 2470
[   29.181561] initcall acpi_cpufreq_init+0x0/0x12c [acpi_cpufreq] returned -19 after 221 usecs
[   29.253813] calling  cpufreq_p4_init+0x0/0x8f [p4_clockmod] @ 2481
[   29.260274] ondemand governor failed, too long transition latency of HW, fallback to performance governor
[   29.270244] ondemand governor failed, too long transition latency of HW, fallback to performance governor
[   29.280116] p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
[   29.287400] initcall cpufreq_p4_init+0x0/0x8f [p4_clockmod] returned 0 after 26580 usecs
[   29.816196] calling  inet6_init+0x0/0x4ff [ipv6] @ 2511
[   29.825338] NET: Registered protocol family 10
[   29.860884] lo: Disabled Privacy Extensions
[   29.870435] initcall inet6_init+0x0/0x4ff [ipv6] returned 0 after 47655 usecs
[   34.147607] calling  rfkill_init+0x0/0x9b [rfkill] @ 2891
[   34.159691] initcall rfkill_init+0x0/0x9b [rfkill] returned 0 after 6314 usecs
[   34.300530] calling  bt_init+0x0/0x9b [bluetooth] @ 2891
[   34.306044] Bluetooth: Core ver 2.15
[   34.310763] NET: Registered protocol family 31
[   34.315355] Bluetooth: HCI device and connection manager initialized
[   34.322151] Bluetooth: HCI socket layer initialized
[   34.327189] initcall bt_init+0x0/0x9b [bluetooth] returned 0 after 20637 usecs
[   34.395844] calling  l2cap_init+0x0/0x178 [l2cap] @ 2925
[   34.404866] Bluetooth: L2CAP ver 2.14
[   34.408687] Bluetooth: L2CAP socket layer initialized
[   34.413907] initcall l2cap_init+0x0/0x178 [l2cap] returned 0 after 12281 usecs
[   34.483553] calling  bnep_init+0x0/0xca [bnep] @ 2932
[   34.488767] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   34.494264] Bluetooth: BNEP filters: protocol multicast
[   34.499695] initcall bnep_init+0x0/0xca [bnep] returned 0 after 10668 usecs
[   34.541421] calling  llc_init+0x0/0x6d [llc] @ 2943
[   34.546545] initcall llc_init+0x0/0x6d [llc] returned 0 after 12 usecs
[   34.693526] calling  br_init+0x0/0x136 [bridge] @ 2943
[   34.694267] initcall br_init+0x0/0x136 [bridge] returned 0 after 706 usecs
[   34.747530] calling  sco_init+0x0/0x17f [sco] @ 2950
[   34.753218] Bluetooth: SCO (Voice Link) ver 0.6
[   34.757894] Bluetooth: SCO socket layer initialized
[   34.762934] initcall sco_init+0x0/0x17f [sco] returned 0 after 10021 usecs
[   35.527445] virbr0: starting userspace STP failed, starting kernel STP
[   37.954754] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   39.600873] tg3 0000:02:00.0: eth0: Link is up at 100 Mbps, full duplex
[   39.601089] tg3 0000:02:00.0: eth0: Flow control is on for TX and on for RX
[   39.601089] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   49.939044] eth0: no IPv6 routers present
[  413.538825] calling  cmos_init+0x0/0xad [rtc_cmos] @ 3382
[  413.546544] rtc_cmos 00:05: RTC can wake from S4
[  413.553609] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[  413.562205] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[  413.570582] initcall cmos_init+0x0/0xad [rtc_cmos] returned 0 after 23722 usecs
[  415.626573] calling  cmos_init+0x0/0xad [rtc_cmos] @ 3397
[  415.634313] rtc_cmos 00:05: RTC can wake from S4
[  415.641912] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[  415.650533] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[  415.658968] initcall cmos_init+0x0/0xad [rtc_cmos] returned 0 after 24345 usecs
[  425.898417] calling  cmos_init+0x0/0xad [rtc_cmos] @ 3429
[  425.906045] rtc_cmos 00:05: RTC can wake from S4
[  425.913057] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[  425.923859] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[  425.932093] initcall cmos_init+0x0/0xad [rtc_cmos] returned 0 after 25658 usecs
[  428.002197] calling  cmos_init+0x0/0xad [rtc_cmos] @ 3444
[  428.009844] rtc_cmos 00:05: RTC can wake from S4
[  428.016843] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[  428.027872] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[  428.036129] initcall cmos_init+0x0/0xad [rtc_cmos] returned 0 after 25856 usecs
[  430.092355] calling  cmos_init+0x0/0xad [rtc_cmos] @ 3459
[  430.100121] rtc_cmos 00:05: RTC can wake from S4
[  430.107159] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[  430.117858] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[  430.126151] initcall cmos_init+0x0/0xad [rtc_cmos] returned 0 after 25757 usecs
[  436.681901] calling  cmos_init+0x0/0xad [rtc_cmos] @ 3491
[  436.689537] rtc_cmos 00:05: RTC can wake from S4
[  436.696558] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[  436.705413] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[  436.713912] initcall cmos_init+0x0/0xad [rtc_cmos] returned 0 after 23935 usecs
[  438.773054] calling  cmos_init+0x0/0xad [rtc_cmos] @ 3506
[  438.780786] rtc_cmos 00:05: RTC can wake from S4
[  438.787816] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[  438.796329] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[  438.804792] initcall cmos_init+0x0/0xad [rtc_cmos] returned 0 after 23772 usecs
[  440.860906] calling  cmos_init+0x0/0xad [rtc_cmos] @ 3521
[  440.868510] rtc_cmos 00:05: RTC can wake from S4
[  440.875537] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[  440.885342] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[  440.893743] initcall cmos_init+0x0/0xad [rtc_cmos] returned 0 after 24822 usecs
[  482.226941] calling  agp_amd64_mod_init+0x0/0x19 [amd64_agp] @ 3555
[  482.235968] initcall agp_amd64_mod_init+0x0/0x19 [amd64_agp] returned -19 after 705 usecs
[  484.289804] calling  agp_amd64_mod_init+0x0/0x19 [amd64_agp] @ 3566
[  484.298287] BUG: unable to handle kernel paging request at 000000000000369a
[  484.299128] IP: [<ffffffff811ea6e2>] kobject_put+0x1f/0x75
[  484.299128] PGD 75f2a067 PUD 74876067 PMD 0 
[  484.299128] Oops: 0000 [#1] SMP 
[  484.299128] last sysfs file: /sys/class/rtc/rtc0/dev
[  484.299128] CPU 1 
[  484.299128] Modules linked in: amd64_agp(+) sco bridge stp llc bnep l2cap crc16 bluetooth rfkill ipv6 p4_clockmod speedstep_lib uinput snd_intel8x0 snd_ac97_codec ac97_bus joydev snd_seq snd_seq_device snd_pcm usbhid snd_timer led_class snd ppdev psmouse iTCO_wdt parport_pc iTCO_vendor_support serio_raw evdev pcspkr soundcore snd_page_alloc sg i2c_i801 parport rng_core rtc_core rtc_lib thermal thermal_sys hwmon intel_agp button sr_mod cdrom ata_generic pata_acpi ata_piix libata ide_pci_generic ide_core sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core ehci_hcd usbcore nls_base [last unloaded: rtc_cmos]
[  484.299128] 
[  484.299128] Pid: 3566, comm: modprobe Not tainted 2.6.34-rc7 #2 0HH807/OptiPlex GX620               
[  484.299128] RIP: 0010:[<ffffffff811ea6e2>]  [<ffffffff811ea6e2>] kobject_put+0x1f/0x75
[  484.299128] RSP: 0018:ffff880075ce5e58  EFLAGS: 00010206
[  484.299128] RAX: ffffffffa05bca30 RBX: 000000000000365e RCX: ffff880005414550
[  484.299128] RDX: 0000000000000025 RSI: 00000070c26a5b82 RDI: 000000000000365e
[  484.299128] RBP: ffff880075ce5e68 R08: ffff88007e83c108 R09: 0000000000000010
[  484.299128] R10: ffffffff811eab66 R11: ffff880075f722e0 R12: ffffffffa05c5a30
[  484.299128] R13: 00000070c26a54fb R14: 0000000000000000 R15: 0000000000000000
[  484.299128] FS:  00007f88ff9aa6f0(0000) GS:ffff880005400000(0000) knlGS:0000000000000000
[  484.299128] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  484.299128] CR2: 000000000000369a CR3: 0000000075ede000 CR4: 00000000000006e0
[  484.299128] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  484.299128] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  484.299128] Process modprobe (pid: 3566, threadinfo ffff880075ce4000, task ffff880075f722e0)
[  484.299128] Stack:
[  484.299128]  0000000000000000 ffffffffa05c5a30 ffff880075ce5e78 ffffffff812cd5e7
[  484.299128] <0> ffff880075ce5ea8 ffffffff812cd6ab ffffffffa05c59d0 ffffffffa05c5a30
[  484.299128] <0> 00000070c26a54fb 0000000000000000 ffff880075ce5ee8 ffffffff8120bcf4
[  484.299128] Call Trace:
[  484.299128]  [<ffffffff812cd5e7>] put_driver+0x14/0x1d
[  484.299128]  [<ffffffff812cd6ab>] driver_register+0xbb/0x1ad
[  484.299128]  [<ffffffff8120bcf4>] __pci_register_driver+0x71/0x127
[  484.299128]  [<ffffffff813efd59>] ? printk+0x4a/0x61
[  484.299128]  [<ffffffffa05c914f>] ? agp_amd64_mod_init+0x0/0x19 [amd64_agp]
[  484.299128]  [<ffffffffa05c9044>] agp_amd64_init+0x44/0x14f [amd64_agp]
[  484.299128]  [<ffffffffa05c914f>] ? agp_amd64_mod_init+0x0/0x19 [amd64_agp]
[  484.299128]  [<ffffffffa05c915f>] agp_amd64_mod_init+0x10/0x19 [amd64_agp]
[  484.299128]  [<ffffffff8100023a>] do_one_initcall+0x75/0x1cb
[  484.299128]  [<ffffffff810920bb>] sys_init_module+0x134/0x326
[  484.299128]  [<ffffffff810034eb>] system_call_fastpath+0x16/0x1b
[  484.299128] Code: ff 05 03 3e 35 01 48 8b 45 f8 c9 c3 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 ff 05 f2 3d 35 01 48 85 ff 74 59 48 ff 05 ee 3d 35 01 <f6> 47 3c 01 75 35 48 ff 05 e9 3d 35 01 48 ff 05 ea 3d 35 01 49 
[  484.299128] RIP  [<ffffffff811ea6e2>] kobject_put+0x1f/0x75
[  484.299128]  RSP <ffff880075ce5e58>
[  484.299128] CR2: 000000000000369a
[  484.719731] ---[ end trace dbce3a2bdb37ea19 ]---

--------------070002050008000808000304
Content-Type: text/plain;
 name="config-2634-rc7-notrace"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-2634-rc7-notrace"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.34-rc7
# Tue May 11 11:21:22 2010
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
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
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
# CONFIG_BINARY_PRINTF is not set

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

--------------070002050008000808000304--
