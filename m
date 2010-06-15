Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab0FOTLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:11:31 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:5543 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754778Ab0FOTL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:11:29 -0400
Message-ID: <4C17D05E.5010807@athenacr.com>
Date: Tue, 15 Jun 2010 15:11:26 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 2.6.35-rc3 BUG: unable to handle kernel paging request (ahci_stop_engine)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing the following BUG booting a Dell Precision T3500
with 2.6.35-rc3 -- does this ring any bells for anyone?

Looks like -rc1 has the same behavior, I haven't gotten any
farther than that yet.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-020635rc3-generic (root@zinc) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #020635rc3 SMP Sat Jun 12 09:09:12 UTC 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-020635rc3-generic root=UUID=45f3fa71-d7b2-4af5-9bfe-0702e8a64758 ro crashkernel=384M-2G:64M,2G-:128M console=ttyS0,115200
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000096800 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfdf9c00 (usable)
[    0.000000]  BIOS-e820: 00000000bfdf9c00 - 00000000bfe4bc00 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfe4bc00 - 00000000bfe4dc00 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfe4dc00 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fc000000 - 00000000fd000000 (reserved)                                                                                                                                                                                                      
[    0.000000]  BIOS-e820: 00000000fe000000 - 00000000fed00400 (reserved)                                                                                                                                                                                                      
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)                                                                                                                                                                                                      
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)                                                                                                                                                                                                      
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000340000000 (usable)                                                                                                                                                                                                        
[    0.000000] NX (Execute Disable) protection: active                                                                                                                                                                                                                         
[    0.000000] DMI 2.5 present.                                                                                                                                                                                                                                                
[    0.000000] No AGP bridge found                                                                                                                                                                                                                                             
[    0.000000] last_pfn = 0x340000 max_arch_pfn = 0x400000000                                                                                                                                                                                                                  
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106                                                                                                                                                                                                
[    0.000000] last_pfn = 0xbfdf9 max_arch_pfn = 0x400000000                                                                                                                                                                                                                   
[    0.000000] Scanning 1 areas for low memory corruption                                                                                                                                                                                                                      
[    0.000000] modified physical RAM map:                                                                                                                                                                                                                                      
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)                                                                                                                                                                                                       
[    0.000000]  modified: 0000000000010000 - 0000000000096800 (usable)                                                                                                                                                                                                         
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)                                                                                                                                                                                                       
[    0.000000]  modified: 0000000000100000 - 00000000bfdf9c00 (usable)                                                                                                                                                                                                         
[    0.000000]  modified: 00000000bfdf9c00 - 00000000bfe4bc00 (ACPI NVS)                                                                                                                                                                                                       
[    0.000000]  modified: 00000000bfe4bc00 - 00000000bfe4dc00 (ACPI data)                                                                                                                                                                                                      
[    0.000000]  modified: 00000000bfe4dc00 - 00000000c0000000 (reserved)                                                                                                                                                                                                       
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)                                                                                                                                                                                                       
[    0.000000]  modified: 00000000fc000000 - 00000000fd000000 (reserved)                                                                                                                                                                                                       
[    0.000000]  modified: 00000000fe000000 - 00000000fed00400 (reserved)                                                                                                                                                                                                       
[    0.000000]  modified: 00000000fee00000 - 00000000fef00000 (reserved)                                                                                                                                                                                                       
[    0.000000]  modified: 00000000ffb00000 - 0000000100000000 (reserved)                                                                                                                                                                                                       
[    0.000000]  modified: 0000000100000000 - 0000000340000000 (usable)                                                                                                                                                                                                         
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfdf9000                                                                                                                                                                                                          
[    0.000000] init_memory_mapping: 0000000100000000-0000000340000000                                                                                                                                                                                                          
[    0.000000] RAMDISK: 3772c000 - 37ff0000                                                                                                                                                                                                                                    
[    0.000000] Reserving 128MB of memory at 32MB for crashkernel (System RAM: 13312MB)                                                                                                                                                                                         
[    0.000000] ACPI: RSDP 00000000000febf0 00024 (v02 DELL  )                                                                                                                                                                                                                  
[    0.000000] ACPI: XSDT 00000000000fcd96 0007C (v01 DELL    B10K    00000015 ASL  00000061)                                                                                                                                                                                  
[    0.000000] ACPI: FACP 00000000000fce86 000F4 (v03 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: DSDT 00000000ffe9825b 04A18 (v01   DELL    dt_ex 00001000 INTL 20050624)
[    0.000000] ACPI: FACS 00000000bfdf9c00 00040
[    0.000000] ACPI: SSDT 00000000ffe9cd94 000AC (v01   DELL    st_ex 00001000 INTL 20050624)
[    0.000000] ACPI: APIC 00000000000fcf7a 0009E (v01 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: BOOT 00000000000fd018 00028 (v01 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: ASF! 00000000000fd040 00096 (v32 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: MCFG 00000000000fd0d6 0003E (v01 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: HPET 00000000000fd114 00038 (v01 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: TCPA 00000000000fd370 00032 (v01 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: DMAR 00000000000fd3a2 000C8 (v01 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: SLIC 00000000000fd14c 00176 (v01 DELL    B10K    00000015 ASL  00000061)
[    0.000000] ACPI: SSDT 00000000bfe4dc00 0185C (v01  INTEL PPM RCM  80000001 INTL 20061109)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000340000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000340000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00340000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000096
[    0.000000]     0: 0x00000100 -> 0x000bfdf9
[    0.000000]     0: 0x00100000 -> 0x00340000
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 0000000000096000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bfdf9000 - 00000000bfdfa000
[    0.000000] PM: Registered nosave memory: 00000000bfdfa000 - 00000000bfe4b000
[    0.000000] PM: Registered nosave memory: 00000000bfe4b000 - 00000000bfe4c000
[    0.000000] PM: Registered nosave memory: 00000000bfe4c000 - 00000000bfe4d000
[    0.000000] PM: Registered nosave memory: 00000000bfe4d000 - 00000000bfe4e000
[    0.000000] PM: Registered nosave memory: 00000000bfe4e000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fd000000
[    0.000000] PM: Registered nosave memory: 00000000fd000000 - 00000000fe000000
[    0.000000] PM: Registered nosave memory: 00000000fe000000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s91392 r8192 d23296 u262144
[    0.000000] pcpu-alloc: s91392 r8192 d23296 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3098495
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-020635rc3-generic root=UUID=45f3fa71-d7b2-4af5-9bfe-0702e8a64758 ro crashkernel=384M-2G:64M,2G-:128M console=ttyS0,115200
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (59 early reservations)
[    0.000000]   #1 [0001000000 - 0001d2b514]   TEXT DATA BSS
[    0.000000]   #2 [003772c000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0000096800 - 0000100000]   BIOS reserved
[    0.000000]   #4 [0001d2c000 - 0001d2c1a4]             BRK
[    0.000000]   #5 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #6 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #7 [0000016000 - 0000019000]         PGTABLE
[    0.000000]   #8 [0000019000 - 0000022000]         PGTABLE
[    0.000000]   #9 [0002000000 - 000a000000]    CRASH KERNEL
[    0.000000]   #10 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #11 [0001d2c1c0 - 0001d2d1c0]         BOOTMEM
[    0.000000]   #12 [0001d2b540 - 0001d2be40]         BOOTMEM
[    0.000000]   #13 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #14 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #15 [0100200000 - 010aa00000]        MEMMAP 0
[    0.000000]   #16 [0001d2be40 - 0001d2bfc0]         BOOTMEM
[    0.000000]   #17 [0001d2d1c0 - 0001d451c0]         BOOTMEM
[    0.000000]   #18 [0001d451c0 - 0001d5d1c0]         BOOTMEM
[    0.000000]   #19 [0001d5e000 - 0001d5f000]         BOOTMEM
[    0.000000]   #20 [0001d5d1c0 - 0001d5d201]         BOOTMEM
[    0.000000]   #21 [0001d5d240 - 0001d5d2c6]         BOOTMEM
[    0.000000]   #22 [0001d5d300 - 0001d5d5d8]         BOOTMEM
[    0.000000]   #23 [0001d5d600 - 0001d5d668]         BOOTMEM
[    0.000000]   #24 [0001d5d680 - 0001d5d6e8]         BOOTMEM
[    0.000000]   #25 [0001d5d700 - 0001d5d768]         BOOTMEM
[    0.000000]   #26 [0001d5d780 - 0001d5d7e8]         BOOTMEM
[    0.000000]   #27 [0001d5d800 - 0001d5d868]         BOOTMEM
[    0.000000]   #28 [0001d5d880 - 0001d5d8e8]         BOOTMEM
[    0.000000]   #29 [0001d5d900 - 0001d5d968]         BOOTMEM
[    0.000000]   #30 [0001d5d980 - 0001d5d9e8]         BOOTMEM
[    0.000000]   #31 [0001d5da00 - 0001d5da68]         BOOTMEM
[    0.000000]   #32 [0001d5da80 - 0001d5dae8]         BOOTMEM
[    0.000000]   #33 [0001d5db00 - 0001d5db68]         BOOTMEM
[    0.000000]   #34 [0001d5db80 - 0001d5dbe8]         BOOTMEM
[    0.000000]   #35 [0001d2bfc0 - 0001d2bfe0]         BOOTMEM
[    0.000000]   #36 [0001d5dc00 - 0001d5dc20]         BOOTMEM
[    0.000000]   #37 [0001d5dc40 - 0001d5dcda]         BOOTMEM
[    0.000000]   #38 [0001d5dd00 - 0001d5dd9a]         BOOTMEM
[    0.000000]   #39 [0001e00000 - 0001e1e000]         BOOTMEM
[    0.000000]   #40 [0001e40000 - 0001e5e000]         BOOTMEM
[    0.000000]   #41 [0001e80000 - 0001e9e000]         BOOTMEM
[    0.000000]   #42 [0001ec0000 - 0001ede000]         BOOTMEM
[    0.000000]   #43 [0001f00000 - 0001f1e000]         BOOTMEM
[    0.000000]   #44 [0001f40000 - 0001f5e000]         BOOTMEM
[    0.000000]   #45 [0001f80000 - 0001f9e000]         BOOTMEM
[    0.000000]   #46 [0001fc0000 - 0001fde000]         BOOTMEM
[    0.000000]   #47 [0001d5ddc0 - 0001d5ddc8]         BOOTMEM
[    0.000000]   #48 [0001d5de00 - 0001d5de08]         BOOTMEM
[    0.000000]   #49 [0001d5de40 - 0001d5de60]         BOOTMEM
[    0.000000]   #50 [0001d5de80 - 0001d5dec0]         BOOTMEM
[    0.000000]   #51 [0001d5dec0 - 0001d5dfe0]         BOOTMEM
[    0.000000]   #52 [0001d61000 - 0001d61048]         BOOTMEM
[    0.000000]   #53 [0001d61080 - 0001d610c8]         BOOTMEM
[    0.000000]   #54 [0001d61100 - 0001d69100]         BOOTMEM
[    0.000000]   #55 [000a000000 - 000e000000]         BOOTMEM
[    0.000000]   #56 [0001d69100 - 0001d89100]         BOOTMEM
[    0.000000]   #57 [0001d89100 - 0001dc9100]         BOOTMEM
[    0.000000]   #58 [0000023800 - 000002b800]         BOOTMEM
[    0.000000] Memory: 12187524k/13631488k available (5620k kernel code, 1051140k absent, 392824k reserved, 5501k data, 968k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  RCU-based detection of stalled CPUs is disabled.
[    0.000000]  Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:1152
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 125829120 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.010000] Detected 2666.492 MHz processor.
[    0.000006] Calibrating delay loop (skipped), value calculated using timer frequency.. 5332.98 BogoMIPS (lpj=26664920)
[    0.010684] pid_max: default: 32768 minimum: 301
[    0.015297] Security Framework initialized
[    0.019376] SELinux:  Disabled at boot.
[    0.024338] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.034619] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.043003] Mount-cache hash table entries: 256
[    0.047600] Initializing cgroup subsys ns
[    0.051607] Initializing cgroup subsys cpuacct
[    0.056032] Initializing cgroup subsys memory
[    0.060372] Initializing cgroup subsys devices
[    0.064803] Initializing cgroup subsys freezer
[    0.069227] Initializing cgroup subsys net_cls
[    0.073671] CPU: Physical Processor ID: 0
[    0.077661] CPU: Processor Core ID: 0
[    0.081316] mce: CPU supports 9 MCE banks
[    0.085313] CPU0: Thermal monitoring enabled (TM1)
[    0.090088] using mwait in idle threads.
[    0.093999] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
[    0.101139] ... version:                3
[    0.105129] ... bit width:              48
[    0.109206] ... generic registers:      4
[    0.113204] ... value mask:             0000ffffffffffff
[    0.118492] ... max period:             000000007fffffff
[    0.123788] ... fixed-purpose events:   3
[    0.127779] ... event mask:             000000070000000f
[    0.134803] ACPI: Core revision 20100428
[    0.276702] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.282435] ftrace: allocating 26354 entries in 104 pages
[    0.295108] Setting APIC routing to flat
[    0.299474] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.405460] CPU0: Intel(R) Xeon(R) CPU           W3520  @ 2.67GHz stepping 05
[    0.530592] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
[    1.790557] Brought up 8 CPUs
[    1.793513] Total of 8 processors activated (42666.87 BogoMIPS).
[    1.803682] devtmpfs: initialized
[    1.807741] regulator: core version 0.5
[    1.811585] Time: 18:22:34  Date: 06/15/10
[    1.815689] NET: Registered protocol family 16
[    1.820186] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    1.827731] ACPI: bus type pci registered
[    1.831763] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.841038] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    1.863626] PCI: Using configuration type 1 for base access
[    1.869721] bio: create slab <bio-0> at 0
[    1.914658] ACPI: BIOS _OSI(Linux) query ignored
[    1.938782] ACPI: Interpreter enabled
[    1.942432] ACPI: (supports S0 S1 S3 S4 S5)
[    1.946665] ACPI: Using IOAPIC for interrupt routing
[    2.024783] ACPI Warning: Incorrect checksum in table [TCPA] - 0x00, should be 0x7F (20100428/tbutils-314)
[    2.034497] ACPI: No dock devices found.
[    2.038405] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.054811] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.075566] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    2.082159] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    2.088751] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    2.096035] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
[    2.103320] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]
[    2.110604] pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]
[    2.117885] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfc000000]
[    2.125167] pci_root PNP0A03:00: host bridge window [mem 0xff980000-0xff980fff]
[    2.132451] pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
[    2.139733] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff]
[    2.148209] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    2.156101] pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by ICH6 GPIO
[    2.163212] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (mask 007f)
[    2.170758] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0 (mask 0007)
[    2.178301] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0900 (mask 003f)
[    2.186030] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.191406] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    2.196652] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    2.201902] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    2.207333] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    2.212606] pci 0000:00:1e.0: PCI bridge to [bus 06-06] (subtractive decode)
[    3.173750] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    3.181628] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    3.189498] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    3.197357] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    3.206378] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    3.214243] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    3.223267] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    3.231135] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    3.238410] HEST: Table is not found!
[    3.242109] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    3.250172] vgaarb: loaded
[    3.252952] SCSI subsystem initialized
[    3.256820] usbcore: registered new interface driver usbfs
[    3.262293] usbcore: registered new interface driver hub
[    3.267601] usbcore: registered new device driver usb
[    3.272785] ACPI: WMI: Mapper loaded
[    3.276346] PCI: Using ACPI for IRQ routing
[    3.280547] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
[    3.288742] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    3.295681] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    3.302681] NetLabel: Initializing
[    3.306069] NetLabel:  domain hash size = 128
[    3.310407] NetLabel:  protocols = UNLABELED CIPSOv4
[    3.315363] NetLabel:  unlabeled traffic allowed by default
[    3.320937] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    3.327962] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    3.333138] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    3.400597] Switching to clocksource tsc
[    3.410213] pnp: PnP ACPI init
[    3.413263] ACPI: bus type pnp registered
[    3.427206] pnp 00:01: disabling [io  0x0800-0x085f] because it overlaps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    3.437350] pnp 00:01: disabling [io  0x0860-0x08ff] because it overlaps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    3.478775] pnp: PnP ACPI: found 9 devices
[    3.482856] ACPI: ACPI bus type pnp unregistered
[    3.487463] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    3.498027] pci 0000:00:1c.0: BAR 14: assigned [mem 0xd0000000-0xd01fffff]
[    3.504881] pci 0000:00:1c.0: BAR 15: assigned [mem 0xd0200000-0xd03fffff 64bit pref]
[    3.512683] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    3.518841] pci 0000:00:1f.2: BAR 5: assigned [mem 0xbff00000-0xbff007ff]
[    3.525608] pci 0000:00:1f.2: BAR 5: set to [mem 0xbff00000-0xbff007ff] (PCI address [0xbff00000-0xbff007ff]
[    3.535403] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    3.540607] pci 0000:00:01.0:   bridge window [io  disabled]
[    3.546250] pci 0000:00:01.0:   bridge window [mem 0xdbe00000-0xdbefffff]
[    3.553013] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    3.559089] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    3.564295] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    3.570369] pci 0000:00:03.0:   bridge window [mem 0xdc000000-0xdfefffff]
[    3.577135] pci 0000:00:03.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    3.584854] pci 0000:00:07.0: PCI bridge to [bus 03-03]
[    3.590059] pci 0000:00:07.0:   bridge window [io  disabled]
[    3.595699] pci 0000:00:07.0:   bridge window [mem 0xdbf00000-0xdbffffff]
[    3.602462] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    3.608536] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    3.613741] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    3.619814] pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd01fffff]
[    3.626579] pci 0000:00:1c.0:   bridge window [mem 0xd0200000-0xd03fffff 64bit pref]
[    3.634297] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    3.639505] pci 0000:00:1c.5:   bridge window [io  disabled]
[    3.645145] pci 0000:00:1c.5:   bridge window [mem 0xdbd00000-0xdbdfffff]
[    3.651910] pci 0000:00:1c.5:   bridge window [mem pref disabled]
[    3.657984] pci 0000:00:1e.0: PCI bridge to [bus 06-06]
[    3.663188] pci 0000:00:1e.0:   bridge window [io  disabled]
[    3.668829] pci 0000:00:1e.0:   bridge window [mem disabled]
[    3.674468] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    3.680553] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.687238] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.693920] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.700605] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.707295] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.714045] NET: Registered protocol family 2
[    3.718680] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    3.727075] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    3.735642] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    3.742449] TCP: Hash tables configured (established 524288 bind 65536)
[    3.749043] TCP reno registered
[    3.752188] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    3.758314] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    3.764928] NET: Registered protocol family 1
[    3.769485] Trying to unpack rootfs image as initramfs...
[    3.926534] Freeing initrd memory: 8976k freed
[    3.932157] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.938586] Placing 64MB software IO TLB between ffff88000a000000 - ffff88000e000000
[    3.946303] software IO TLB at phys 0xa000000 - 0xe000000
[    3.951711] Simple Boot Flag at 0x7a set to 0x80
[    3.956641] Scanning for low memory corruption every 60 seconds
[    3.962644] audit: initializing netlink socket (disabled)
[    3.968065] type=2000 audit(1276626154.790:1): initialized
[    3.986773] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.994131] VFS: Disk quotas dquot_6.5.2
[    3.998084] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.004904] fuse init (API version 7.14)
[    4.008866] msgmni has been set to 23821
[    4.012983] alg: No test for stdrng (krng)
[    4.017099] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    4.024469] io scheduler noop registered
[    4.028377] io scheduler deadline registered
[    4.032656] io scheduler cfq registered (default)
[    4.037852] pcieport 0000:00:01.0: Requesting control of PCIe PME from ACPI BIOS
[    4.045224] pcieport 0000:00:01.0: Failed to receive control of PCIe PME service: no _OSC support
[    4.054066] pcie_pme: probe of 0000:00:01.0:pcie01 failed with error -13
[    4.060744] pcieport 0000:00:03.0: Requesting control of PCIe PME from ACPI BIOS
[    4.068115] pcieport 0000:00:03.0: Failed to receive control of PCIe PME service: no _OSC support
[    4.076959] pcie_pme: probe of 0000:00:03.0:pcie01 failed with error -13
[    4.083635] pcieport 0000:00:07.0: Requesting control of PCIe PME from ACPI BIOS
[    4.091006] pcieport 0000:00:07.0: Failed to receive control of PCIe PME service: no _OSC support
[    4.099849] pcie_pme: probe of 0000:00:07.0:pcie01 failed with error -13
[    4.106528] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    4.113897] pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: no _OSC support
[    4.122739] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
[    4.129420] pcieport 0000:00:1c.5: Requesting control of PCIe PME from ACPI BIOS
[    4.136791] pcieport 0000:00:1c.5: Failed to receive control of PCIe PME service: no _OSC support
[    4.145635] pcie_pme: probe of 0000:00:1c.5:pcie01 failed with error -13
[    4.152321] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.157907] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.164579] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    4.172901] ACPI: Power Button [VBTN]
[    4.176582] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.183950] ACPI: Power Button [PWRF]
[    4.249304] ERST: Table is not found!
[    4.253949] Linux agpgart interface v0.103
[    4.258045] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.264380] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.270595] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.276811] brd: module loaded
[    4.280151] loop: module loaded
[    4.283555] Fixed MDIO Bus: probed
[    4.286968] PPP generic driver version 2.4.2
[    4.291241] tun: Universal TUN/TAP device driver, 1.6
[    4.296277] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.302482] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.309010] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.316136] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.321362] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    4.328756] ehci_hcd 0000:00:1a.7: debug port 1
[    4.337166] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xdfffa000
[    4.364462] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.370257] hub 1-0:1.0: USB hub found
[    4.373993] hub 1-0:1.0: 6 ports detected
[    4.378041] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.385164] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.390394] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    4.397783] ehci_hcd 0000:00:1d.7: debug port 1
[    4.406197] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xff980000
[    4.434459] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.440244] hub 2-0:1.0: USB hub found
[    4.443980] hub 2-0:1.0: 6 ports detected
[    4.448020] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.454183] uhci_hcd: USB Universal Host Controller Interface driver
[    4.460547] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.467663] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.472894] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    4.480309] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff20
[    4.486109] hub 3-0:1.0: USB hub found
[    4.489845] hub 3-0:1.0: 2 ports detected
[    4.493873] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.500990] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.506215] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    4.513609] uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000ff00
[    4.519410] hub 4-0:1.0: USB hub found
[    4.523145] hub 4-0:1.0: 2 ports detected
[    4.527175] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.534289] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.539518] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    4.546924] uhci_hcd 0000:00:1a.2: irq 22, io base 0x0000fc00
[    4.552720] hub 5-0:1.0: USB hub found
[    4.556460] hub 5-0:1.0: 2 ports detected
[    4.560492] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.567608] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.572837] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    4.580234] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000ff80
[    4.586049] hub 6-0:1.0: USB hub found
[    4.589784] hub 6-0:1.0: 2 ports detected
[    4.593812] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.600931] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.606157] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    4.613544] uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000ff60
[    4.619341] hub 7-0:1.0: USB hub found
[    4.623076] hub 7-0:1.0: 2 ports detected
[    4.627123] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.634237] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.639464] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    4.646860] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[    4.652655] hub 8-0:1.0: USB hub found
[    4.656403] hub 8-0:1.0: 2 ports detected
[    4.660462] PNP: No PS/2 controller found. Probing ports directly.
[    4.669259] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.674215] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.679303] mice: PS/2 mouse device common for all mice
[    4.684556] rtc_cmos 00:05: RTC can wake from S4
[    4.689184] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    4.695285] usb 1-2: new high speed USB device using ehci_hcd and address 2
[    4.695287] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[    4.695354] device-mapper: uevent: version 1.0.3
[    4.695401] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    4.695501] device-mapper: multipath: version 1.1.1 loaded
[    4.695504] device-mapper: multipath round-robin: version 1.0.0 loaded
[    4.695841] cpuidle: using governor ladder
[    4.737650] cpuidle: using governor menu
[    4.741769] TCP cubic registered
[    4.745069] NET: Registered protocol family 10
[    4.749781] lo: Disabled Privacy Extensions
[    4.754108] NET: Registered protocol family 17
[    4.758654] registered taskstats version 1
[    4.762988]   Magic number: 14:857:392
[    4.766732] thermal cooling_device7: hash matches
[    4.771508] rtc_cmos 00:05: setting system clock to 2010-06-15 18:22:37 UTC (1276626157)
[    4.779577] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found

[    4.785561] EDD information not available.
[    4.789767] Freeing unused kernel memory: 968k freed
[    4.794827] Write protecting the kernel read-only data: 10240k
[    4.801142] Freeing unused kernel memory: 504k freed
[    4.806327] Freeing unused kernel memory: 1540k freed
Loading, please wait...
[    4.824026] udev: starting version 151
Begin: Loading essential drivers... ...
Done.
Begin: Running /scripts/init-premount ...
Done.
Begin: Mounting root file system... ...
Begin: Running /scripts/local-top ...
Done.
[    4.849124] tg3.c:v3.110 (April 9, 2010)
[    4.849764] ahci 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    4.859837] tg3 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.859863] ahci 0000:00:1f.2: controller can't do SNTF, turning off CAP_SNTF
[    4.859936] ahci: SSS flag set, parallel bus scan disabled
[    4.909578] hub 1-2:1.0: USB hub found
[    4.913400] hub 1-2:1.0: 2 ports detected
[    4.921485] tg3 0000:05:00.0: eth0: Tigon3 [partno(BCM95761) rev 5761100] (PCI Express) MAC address 00:22:19:32:7e:30
[    4.932063] tg3 0000:05:00.0: eth0: attached PHY is 5761 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    4.941164] tg3 0000:05:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    4.949053] tg3 0000:05:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    5.194682] usb 1-2.1: new high speed USB device using ehci_hcd and address 3
[    5.305150] hub 1-2.1:1.0: USB hub found
[    5.309185] hub 1-2.1:1.0: 4 ports detected
[    5.394680] usb 1-2.2: new low speed USB device using ehci_hcd and address 4
[    5.555467] usbcore: registered new interface driver hiddev
[    5.561076] usbcore: registered new interface driver usbhid
[    5.566637] usbhid: USB HID core driver
[    5.578793] input: Microsoft Natural® Ergonomic Keyboard 4000 as /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2.2/1-2.2:1.0/input/input2
[    5.591072] microsoft 0003:045E:00DB.0001: input,hidraw0: USB HID v1.11 Keyboard [Microsoft Natural® Ergonomic Keyboard 4000] on usb-0000:00:1a.7-2.2/input0
[    5.616209] input: Microsoft Natural® Ergonomic Keyboard 4000 as /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2.2/1-2.2:1.1/input/input3
[    5.628485] microsoft 0003:045E:00DB.0002: input,hidraw1: USB HID v1.11 Device [Microsoft Natural® Ergonomic Keyboard 4000] on usb-0000:00:1a.7-2.2/input1
[    5.635695] usb 1-2.1.1: new high speed USB device using ehci_hcd and address 5
[    5.834119] Initializing USB Mass Storage driver...
[    5.839208] scsi0 : usb-storage 1-2.1.1:1.0
[    5.843526] usbcore: registered new interface driver usb-storage
[    5.849516] USB Mass Storage support registered.
[    5.854464] ahci 0000:00:1f.2: controller reset failed (0xffffffff)
[    5.908956] usb 1-2.1.2: new low speed USB device using ehci_hcd and address 6
[    6.031648] input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2.1/1-2.1.2/1-2.1.2:1.0/input/input4
[    6.045732] generic-usb 0003:045E:0040.0003: input,hidraw2: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:00:1a.7-2.1.2/input0
[    6.354463] ahci 0000:00:1f.2: failed to stop engine (-5)
[    6.844828] scsi 0:0:0:0: Direct-Access     Generic  Flash HS-CF      5.39 PQ: 0 ANSI: 0
[    6.854432] ahci 0000:00:1f.2: failed to stop engine (-5)
[    6.856055] scsi 0:0:0:1: Direct-Access     Generic  Flash HS-COMBO   5.39 PQ: 0 ANSI: 0
[    6.857356] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.857494] sd 0:0:0:1: Attached scsi generic sg1 type 0
[    6.885248] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    6.894504] sd 0:0:0:1: [sdb] Attached SCSI removable disk
[    7.374400] ahci 0000:00:1f.2: failed to stop engine (-5)
[    7.874362] ahci 0000:00:1f.2: failed to stop engine (-5)
[    8.374331] ahci 0000:00:1f.2: failed to stop engine (-5)
[    8.874299] ahci 0000:00:1f.2: failed to stop engine (-5)
[    9.374265] ahci 0000:00:1f.2: failed to stop engine (-5)
[    9.874236] ahci 0000:00:1f.2: failed to stop engine (-5)
[   10.374205] ahci 0000:00:1f.2: failed to stop engine (-5)
[   10.874173] ahci 0000:00:1f.2: failed to stop engine (-5)
[   11.374137] ahci 0000:00:1f.2: failed to stop engine (-5)
[   11.874101] ahci 0000:00:1f.2: failed to stop engine (-5)
[   12.374071] ahci 0000:00:1f.2: failed to stop engine (-5)
[   12.874039] ahci 0000:00:1f.2: failed to stop engine (-5)
[   13.374001] ahci 0000:00:1f.2: failed to stop engine (-5)
[   13.873977] ahci 0000:00:1f.2: failed to stop engine (-5)
[   14.373942] ahci 0000:00:1f.2: failed to stop engine (-5)
[   14.873908] ahci 0000:00:1f.2: failed to stop engine (-5)
[   15.373875] ahci 0000:00:1f.2: failed to stop engine (-5)
[   15.873842] ahci 0000:00:1f.2: failed to stop engine (-5)
[   16.373810] ahci 0000:00:1f.2: failed to stop engine (-5)
[   16.873775] ahci 0000:00:1f.2: failed to stop engine (-5)
[   17.373743] ahci 0000:00:1f.2: failed to stop engine (-5)
[   17.873711] ahci 0000:00:1f.2: failed to stop engine (-5)
[   18.373680] ahci 0000:00:1f.2: failed to stop engine (-5)
[   18.873642] ahci 0000:00:1f.2: failed to stop engine (-5)
[   19.373609] ahci 0000:00:1f.2: failed to stop engine (-5)
[   19.873581] ahci 0000:00:1f.2: failed to stop engine (-5)
[   20.373547] ahci 0000:00:1f.2: failed to stop engine (-5)
[   20.873514] ahci 0000:00:1f.2: failed to stop engine (-5)
[   20.878896] BUG: unable to handle kernel paging request at ffffc90012621018
[   20.885854] IP: [<ffffffffa002c77c>] ahci_stop_engine+0x2c/0x70 [libahci]
[   20.892630] PGD 33fc0c067 PUD 33fc0d067 PMD 32e7a4067 PTE 0
[   20.898224] Oops: 0000 [#1] SMP 
[   20.901459] last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2.1/1-2.1.1/1-2.1.1:1.0/uevent
[   20.911164] CPU 0 
[   20.912993] Modules linked in: usb_storage hid_microsoft usbhid hid ahci(+) tg3 libahci
[   20.921241] 
[   20.922724] Pid: 286, comm: modprobe Not tainted 2.6.35-020635rc3-generic #020635rc3 0K095G/Precision WorkStation T3500  
[   20.933642] RIP: 0010:[<ffffffffa002c77c>]  [<ffffffffa002c77c>] ahci_stop_engine+0x2c/0x70 [libahci]
[   20.942840] RSP: 0018:ffff88032e53bb98  EFLAGS: 00010286
[   20.948132] RAX: ffffc90012621000 RBX: ffff88032e188000 RCX: ffffc90012620000
[   20.955240] RDX: 0000000000000f00 RSI: ffff88032e53bbe8 RDI: ffffc90012621018
[   20.962348] RBP: ffff88032e53bb98 R08: ffffc90012621000 R09: 0000000000000000
[   20.969455] R10: 0000000000000006 R11: 000000000000000a R12: ffff88032e53bbe8
[   20.976563] R13: ffff8803323a3090 R14: ffff88032f5c7a18 R15: ffff88032f57f438
[   20.983671] FS:  00007f570a121700(0000) GS:ffff880001e00000(0000) knlGS:0000000000000000
[   20.991732] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   20.997457] CR2: ffffc90012621018 CR3: 000000032e549000 CR4: 00000000000006f0
[   21.004567] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   21.011677] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   21.018785] Process modprobe (pid: 286, threadinfo ffff88032e53a000, task ffff88032e0d96d0)
[   21.027105] Stack:
[   21.029108]  ffff88032e53bbb8 ffffffffa002c8e1 ffffc90012621000 ffff88032f5c7a18
[   21.036334] <0> ffff88032e53bc18 ffffffffa002ccd2 ffff88032e53bbd8 ffffc90012620000
[   21.044016] <0> 0000001e00000282 00000000000000fa 0000000000000000 000000000000001f
[   21.051883] Call Trace:
[   21.054321]  [<ffffffffa002c8e1>] ahci_deinit_port+0x21/0x50 [libahci]
[   21.060826]  [<ffffffffa002ccd2>] ahci_port_init+0x42/0xc0 [libahci]
[   21.067158]  [<ffffffffa002e920>] ahci_init_controller+0x70/0xa0 [libahci]
[   21.074010]  [<ffffffffa003a0e3>] ahci_pci_init_controller+0x53/0x60 [ahci]
[   21.080947]  [<ffffffffa003b197>] ahci_init_one+0x4c7/0x610 [ahci]
[   21.087108]  [<ffffffff812c8c97>] local_pci_probe+0x17/0x20
[   21.092659]  [<ffffffff812c8e59>] pci_call_probe+0x89/0xa0
[   21.098124]  [<ffffffff812ca304>] __pci_device_probe+0x54/0x60
[   21.103936]  [<ffffffff812ca34b>] pci_device_probe+0x3b/0x60
[   21.109576]  [<ffffffff813788c5>] really_probe+0xf5/0x190
[   21.114954]  [<ffffffff813789a5>] driver_probe_device+0x45/0x70
[   21.120851]  [<ffffffff81378cfd>] __driver_attach+0x8d/0x90
[   21.126403]  [<ffffffff81378c70>] ? __driver_attach+0x0/0x90
[   21.132042]  [<ffffffff8137796d>] bus_for_each_dev+0x5d/0x90
[   21.137680]  [<ffffffff813786a1>] driver_attach+0x21/0x30
[   21.143058]  [<ffffffff81378389>] bus_add_driver+0xd9/0x220
[   21.148609]  [<ffffffffa0042000>] ? ahci_init+0x0/0x20 [ahci]
[   21.154334]  [<ffffffffa0042000>] ? ahci_init+0x0/0x20 [ahci]
[   21.160059]  [<ffffffff81378f36>] driver_register+0x56/0xf0
[   21.165612]  [<ffffffffa0042000>] ? ahci_init+0x0/0x20 [ahci]
[   21.171336]  [<ffffffff812ca01f>] __pci_register_driver+0x5f/0xb0
[   21.177407]  [<ffffffffa0042000>] ? ahci_init+0x0/0x20 [ahci]
[   21.183133]  [<ffffffffa004201e>] ahci_init+0x1e/0x20 [ahci]
[   21.188773]  [<ffffffff81002046>] do_one_initcall+0x36/0x180
[   21.194413]  [<ffffffff8109b018>] sys_init_module+0x98/0x1e0
[   21.200051]  [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
[   21.206035] Code: 48 89 e5 0f 1f 44 00 00 48 8b 87 50 28 00 00 8b 57 28 48 8b 40 20 c1 e2 07 89 d2 48 8b 00 48 05 00 01 00 00 48 01 d0 48 8d 78 18 <8b> 40 18 66 a9 01 80 75 0b 31 d2 c9 89 d0 c3 0f 1f 44 00 00 83 
[   21.225545] RIP  [<ffffffffa002c77c>] ahci_stop_engine+0x2c/0x70 [libahci]
[   21.232409]  RSP <ffff88032e53bb98>
[   21.235881] CR2: ffffc90012621018
[   21.239181] ---[ end trace 44532c520da7bf63 ]---
udevd-work[182]: '/sbin/modprobe -b pci:v00008086d00002822sv00001028sd00000293bc01sc04i00' unexpected exit with status 0x0009

