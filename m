Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab2D2Nma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 09:42:30 -0400
Received: from 2481.rev.megiteam.pl ([91.227.36.129]:54340 "EHLO
	vk1001.megiteam.com.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab2D2NmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 09:42:24 -0400
Message-ID: <4F9D4539.9000903@localdomain.pl>
Date: Sun, 29 Apr 2012 15:42:17 +0200
From: Grzegorz Nosek <root@localdomain.pl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        support@supermicro.com
Subject: Re: EHCI software retries break Supermicro IPKVM
References: <Pine.LNX.4.44L0.1204191337520.2070-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1204191337520.2070-100000@iolanthe.rowland.org>
Content-Type: multipart/mixed;
 boundary="------------080102030709070300040402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080102030709070300040402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

W dniu 19.04.2012 19:40, Alan Stern pisze:
> Do you have any idea what's going wrong?

Nope. I found this workaround by bisecting.

> Can you provide complete dmesg logs for kernels both with and without
> your patch (and with CONFIG_USB_DEBUG enabled)?  Maybe also usbmon
> traces too.

Attached. Sorry it took so long, it was rather hard to align time when I 
can easily reboot this machine with when I actually had the time to do it.

Note: USB support is compiled in the kernel image, so I couldn't attach 
usbmon very early. Instead, I captured usbmon traces (and dmesgs since 
boot) from connecting and disconnecting an ISO image via the KVM's 
virtual CD drive, which exhibits the same problems (the IPKVM is visible 
as an USB keyboard, an USB mouse and two USB CD-ROM drives).

Best regards,
  Grzegorz Nosek

--------------080102030709070300040402
Content-Type: text/plain;
 name="usb-bad.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="usb-bad.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.15-00012-g7afde96 (blackfire@eskarina) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5.1) ) #11 SMP Tue Apr 17 14:04:23 CEST 2012
[    0.000000] Command line: root=/dev/md11 ro nmi_watchdog=2 panic=10 console=ttyS1,115200n8r console=tty0 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000099000 (usable)
[    0.000000]  BIOS-e820: 0000000000099000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff50000 (usable)
[    0.000000]  BIOS-e820: 00000000cff50000 - 00000000cff65000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cff65000 - 00000000cff80000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000430000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Supermicro X7DBR-3/X7DBR-3, BIOS 2.1 06/23/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x430000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00D0000000 mask 3FF0000000 uncachable
[    0.000000]   1 base 00E0000000 mask 3FE0000000 uncachable
[    0.000000]   2 base 0000000000 mask 3C00000000 write-back
[    0.000000]   3 base 0400000000 mask 3FE0000000 write-back
[    0.000000]   4 base 0420000000 mask 3FF0000000 write-back
[    0.000000]   5 base 00CFF80000 mask 3FFFF80000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000cff80000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcff50 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f61b0] f61b0
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 8192
[    0.000000] init_memory_mapping: 0000000000000000-00000000cff50000
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cff50000 page 4k
[    0.000000] kernel direct mapping tables up to cff50000 @ 1fffa000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000430000000
[    0.000000]  0100000000 - 0430000000 page 2M
[    0.000000] kernel direct mapping tables up to 430000000 @ cff3e000-cff50000
[    0.000000] ACPI: RSDP 00000000000f6180 00014 (v00 PTLTD )
[    0.000000] ACPI: RSDT 00000000cff5ea36 00060 (v01 SMCI   SMCISLP2 06040000  LTP 00000000)
[    0.000000] ACPI: FACP 00000000cff644fa 00074 (v01 INTEL  TUMWATER 06040000 PTL  00000003)
[    0.000000] ACPI: DSDT 00000000cff60568 03F92 (v01  Intel BLAKFORD 06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000cff65fc0 00040
[    0.000000] ACPI: APIC 00000000cff6456e 00090 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: MCFG 00000000cff645fe 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000cff6463a 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SPCR 00000000cff64662 00050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: SLIC 00000000cff646b2 00176 (v01 SMCI   SMCISLP2 06040000  LTP 00000000)
[    0.000000] ACPI: SSDT 00000000cff60309 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff60263 000A6 (v01  PmRef  Cpu7Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff601bd 000A6 (v01  PmRef  Cpu6Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff60117 000A6 (v01  PmRef  Cpu5Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff60071 000A6 (v01  PmRef  Cpu4Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff5ffcb 000A6 (v01  PmRef  Cpu3Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff5ff25 000A6 (v01  PmRef  Cpu2Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff5fe7f 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff5ea96 013E9 (v01  PmRef    CpuPm 00003000 INTL 20050228)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000430000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000430000000
[    0.000000]   NODE_DATA [000000042fffb000 - 000000042fffffff]
[    0.000000]  [ffffea0000000000-ffffea0010bfffff] PMD -> [ffff88041f600000-ffff88042f5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00430000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000099
[    0.000000]     0: 0x00000100 -> 0x000cff50
[    0.000000]     0: 0x00100000 -> 0x00430000
[    0.000000] On node 0 totalpages: 4194009
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 2 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 831376 pages, LIFO batch:31
[    0.000000]   Normal zone: 52224 pages used for memmap
[    0.000000]   Normal zone: 3290112 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 5, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88042fc00000 s78208 r8192 d24192 u524288
[    0.000000] pcpu-alloc: s78208 r8192 d24192 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4125399
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/md11 ro nmi_watchdog=2 panic=10 console=ttyS1,115200n8r console=tty0 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16434604k/17563648k available (5176k kernel code, 787612k absent, 341432k reserved, 5710k data, 860k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:1024 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS1] enabled
[    0.000000] allocated 134217728 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2000.290 MHz processor.
[    0.020004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4000.58 BogoMIPS (lpj=20002900)
[    0.040003] pid_max: default: 32768 minimum: 301
[    0.046516] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.064291] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.074331] Mount-cache hash table entries: 256
[    0.080176] Initializing cgroup subsys cpuacct
[    0.084867] Initializing cgroup subsys memory
[    0.090013] Initializing cgroup subsys devices
[    0.094699] Initializing cgroup subsys freezer
[    0.100003] Initializing cgroup subsys net_cls
[    0.104685] Initializing cgroup subsys blkio
[    0.109239] CPU: Physical Processor ID: 0
[    0.110002] CPU: Processor Core ID: 0
[    0.113906] mce: CPU supports 6 MCE banks
[    0.120007] CPU0: Thermal monitoring handled by SMI
[    0.120011] using mwait in idle threads.
[    0.124300] Freeing SMP alternatives: 24k freed
[    0.130017] ACPI: Core revision 20110623
[    0.140012] ftrace: allocating 21131 entries in 83 pages
[    0.160303] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.266576] CPU0: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz stepping 06
[    0.280000] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.280000] ... version:                2
[    0.280001] ... bit width:              40
[    0.284342] ... generic registers:      2
[    0.290001] ... value mask:             000000ffffffffff
[    0.295553] ... max period:             000000007fffffff
[    0.300001] ... fixed-purpose events:   3
[    0.304254] ... event mask:             0000000700000003
[    0.310239] NMI watchdog enabled, takes one hw-pmu counter.
[    0.316160] Booting Node   0, Processors  #1
[    0.320329] smpboot cpu 1: start_ip = 97000
[    0.030000] CPU1: Thermal monitoring handled by SMI
[    0.490028] NMI watchdog enabled, takes one hw-pmu counter.
[    0.495975]  #2
[    0.497602] smpboot cpu 2: start_ip = 97000
[    0.030000] CPU2: Thermal monitoring handled by SMI
[    0.660020] NMI watchdog enabled, takes one hw-pmu counter.
[    0.665911]  #3 Ok.
[    0.668255] smpboot cpu 3: start_ip = 97000
[    0.030000] CPU3: Thermal monitoring handled by SMI
[    0.830020] NMI watchdog enabled, takes one hw-pmu counter.
[    0.835856] Brought up 4 CPUs
[    0.839064] Total of 4 processors activated (16001.31 BogoMIPS).
[    0.851272] xor: automatically using best checksumming function: generic_sse
[    0.910002]    generic_sse:  7427.200 MB/sec
[    0.914513] xor: using function: generic_sse (7427.200 MB/sec)
[    0.920044] NET: Registered protocol family 16
[    0.924773] kworker/u:0 used greatest stack depth: 5504 bytes left
[    0.932238] ACPI: bus type pci registered
[    0.936589] PCI: Using configuration type 1 for base access
[    0.947379] bio: create slab <bio-0> at 0
[    1.120027] raid6: int64x1   1666 MB/s
[    1.290012] raid6: int64x2   1835 MB/s
[    1.460004] raid6: int64x4   1567 MB/s
[    1.630025] raid6: int64x8   1200 MB/s
[    1.800004] raid6: sse2x1    3148 MB/s
[    1.970002] raid6: sse2x2    5441 MB/s
[    2.140009] raid6: sse2x4    6110 MB/s
[    2.144000] raid6: using algorithm sse2x4 (6110 MB/s)
[    2.149309] ACPI: Added _OSI(Module Device)
[    2.150003] ACPI: Added _OSI(Processor Device)
[    2.154688] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.160003] ACPI: Added _OSI(Processor Aggregator Device)
[    2.166271] ACPI: EC: Look up EC in DSDT
[    2.170199] ACPI Error: [Z000] Namespace lookup failure, AE_NOT_FOUND (20110623/psargs-359)
[    2.179166] ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node ffff88041544c7a8), AE_NOT_FOUND (20110623/psparse-536)
[    2.192203] ACPI: Interpreter enabled
[    2.196105] ACPI: (supports S0 S5)
[    2.200846] ACPI: Using IOAPIC for interrupt routing
[    2.211445] ACPI: No dock devices found.
[    2.215610] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.220549] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.228045] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    2.230004] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    2.240004] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    2.250003] pci_root PNP0A03:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    2.257750] pci_root PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    2.260002] pci_root PNP0A03:00: host bridge window [mem 0x000dc000-0x000dffff]
[    2.270003] pci_root PNP0A03:00: host bridge window [mem 0x000e0000-0x000e3fff]
[    2.280003] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xfebfffff]
[    2.287766] pci 0000:00:00.0: [8086:25d8] type 0 class 0x000600
[    2.287812] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    2.287816] pci 0000:00:00.0: PME# disabled
[    2.287834] pci 0000:00:02.0: [8086:25f7] type 1 class 0x000604
[    2.287876] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    2.287879] pci 0000:00:02.0: PME# disabled
[    2.287896] pci 0000:00:04.0: [8086:25f8] type 1 class 0x000604
[    2.287938] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    2.287941] pci 0000:00:04.0: PME# disabled
[    2.287958] pci 0000:00:06.0: [8086:25f9] type 1 class 0x000604
[    2.288000] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    2.288004] pci 0000:00:06.0: PME# disabled
[    2.288020] pci 0000:00:08.0: [8086:1a38] type 0 class 0x000880
[    2.288029] pci 0000:00:08.0: reg 10: [mem 0xfe700000-0xfe7003ff 64bit]
[    2.290014] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    2.290018] pci 0000:00:08.0: PME# disabled
[    2.290035] pci 0000:00:10.0: [8086:25f0] type 0 class 0x000600
[    2.290065] pci 0000:00:10.1: [8086:25f0] type 0 class 0x000600
[    2.290092] pci 0000:00:10.2: [8086:25f0] type 0 class 0x000600
[    2.290124] pci 0000:00:11.0: [8086:25f1] type 0 class 0x000600
[    2.290152] pci 0000:00:13.0: [8086:25f3] type 0 class 0x000600
[    2.290179] pci 0000:00:15.0: [8086:25f5] type 0 class 0x000600
[    2.290206] pci 0000:00:16.0: [8086:25f6] type 0 class 0x000600
[    2.290243] pci 0000:00:1c.0: [8086:2690] type 1 class 0x000604
[    2.290310] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.290314] pci 0000:00:1c.0: PME# disabled
[    2.290339] pci 0000:00:1d.0: [8086:2688] type 0 class 0x000c03
[    2.290378] pci 0000:00:1d.0: reg 20: [io  0x1800-0x181f]
[    2.290410] pci 0000:00:1d.1: [8086:2689] type 0 class 0x000c03
[    2.290449] pci 0000:00:1d.1: reg 20: [io  0x1820-0x183f]
[    2.290479] pci 0000:00:1d.2: [8086:268a] type 0 class 0x000c03
[    2.290518] pci 0000:00:1d.2: reg 20: [io  0x1840-0x185f]
[    2.290549] pci 0000:00:1d.3: [8086:268b] type 0 class 0x000c03
[    2.290588] pci 0000:00:1d.3: reg 20: [io  0x1860-0x187f]
[    2.290631] pci 0000:00:1d.7: [8086:268c] type 0 class 0x000c03
[    2.290649] pci 0000:00:1d.7: reg 10: [mem 0xd8700000-0xd87003ff]
[    2.290729] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    2.290734] pci 0000:00:1d.7: PME# disabled
[    2.290751] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    2.290809] pci 0000:00:1f.0: [8086:2670] type 0 class 0x000601
[    2.290888] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    2.290905] pci 0000:00:1f.1: [8086:269e] type 0 class 0x000101
[    2.290918] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    2.290927] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    2.290936] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    2.290945] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    2.290955] pci 0000:00:1f.1: reg 20: [io  0x1880-0x188f]
[    2.290989] pci 0000:00:1f.3: [8086:269b] type 0 class 0x000c05
[    2.291039] pci 0000:00:1f.3: reg 20: [io  0x1100-0x111f]
[    2.291108] pci 0000:01:00.0: [8086:3500] type 1 class 0x000604
[    2.291166] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    2.291170] pci 0000:01:00.0: PME# disabled
[    2.291189] pci 0000:01:00.3: [8086:350c] type 1 class 0x000604
[    2.291246] pci 0000:01:00.3: PME# supported from D0 D3hot D3cold
[    2.291250] pci 0000:01:00.3: PME# disabled
[    2.291264] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.300010] pci 0000:00:02.0: PCI bridge to [bus 01-05]
[    2.305475] pci 0000:00:02.0:   bridge window [io  0x2000-0x2fff]
[    2.305478] pci 0000:00:02.0:   bridge window [mem 0xd8100000-0xd82fffff]
[    2.305520] pci 0000:02:00.0: [8086:3510] type 1 class 0x000604
[    2.305584] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    2.305588] pci 0000:02:00.0: PME# disabled
[    2.305599] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.310013] pci 0000:02:02.0: [8086:3518] type 1 class 0x000604
[    2.310077] pci 0000:02:02.0: PME# supported from D0 D3hot D3cold
[    2.310081] pci 0000:02:02.0: PME# disabled
[    2.310093] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.320026] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    2.330004] pci 0000:01:00.0:   bridge window [io  0x2000-0x2fff]
[    2.330008] pci 0000:01:00.0:   bridge window [mem 0xd8200000-0xd82fffff]
[    2.330047] pci 0000:02:00.0: PCI bridge to [bus 03-03]
[    2.335567] pci 0000:04:00.0: [8086:1096] type 0 class 0x000200
[    2.335580] pci 0000:04:00.0: reg 10: [mem 0xd8220000-0xd823ffff]
[    2.335590] pci 0000:04:00.0: reg 14: [mem 0xd8200000-0xd821ffff]
[    2.335601] pci 0000:04:00.0: reg 18: [io  0x2000-0x201f]
[    2.335635] pci 0000:04:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    2.335680] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    2.335684] pci 0000:04:00.0: PME# disabled
[    2.335712] pci 0000:04:00.1: [8086:1096] type 0 class 0x000200
[    2.335725] pci 0000:04:00.1: reg 10: [mem 0xd8260000-0xd827ffff]
[    2.335735] pci 0000:04:00.1: reg 14: [mem 0xd8240000-0xd825ffff]
[    2.335746] pci 0000:04:00.1: reg 18: [io  0x2020-0x203f]
[    2.335780] pci 0000:04:00.1: reg 30: [mem 0x00000000-0x0000ffff pref]
[    2.335825] pci 0000:04:00.1: PME# supported from D0 D3hot D3cold
[    2.335829] pci 0000:04:00.1: PME# disabled
[    2.335849] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.340011] pci 0000:02:02.0: PCI bridge to [bus 04-04]
[    2.345476] pci 0000:02:02.0:   bridge window [io  0x2000-0x2fff]
[    2.345481] pci 0000:02:02.0:   bridge window [mem 0xd8200000-0xd82fffff]
[    2.345553] pci 0000:01:00.3: PCI bridge to [bus 05-05]
[    2.350041] pci 0000:00:04.0: PCI bridge to [bus 06-06]
[    2.355529] pci 0000:00:06.0: PCI bridge to [bus 07-07]
[    2.360056] pci 0000:08:00.0: [8086:032c] type 1 class 0x000604
[    2.360078] pci 0000:08:00.0: PXH quirk detected; SHPC device MSI disabled
[    2.367269] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    2.367274] pci 0000:08:00.0: PME# disabled
[    2.367297] pci 0000:08:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.370010] pci 0000:00:1c.0: PCI bridge to [bus 08-09]
[    2.380004] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    2.380008] pci 0000:00:1c.0:   bridge window [mem 0xd8300000-0xd83fffff]
[    2.380015] pci 0000:00:1c.0:   bridge window [mem 0xd8000000-0xd80fffff 64bit pref]
[    2.380077] pci 0000:09:02.0: [9005:041f] type 0 class 0x000104
[    2.380102] pci 0000:09:02.0: reg 10: [mem 0xd8300000-0xd833ffff 64bit]
[    2.380120] pci 0000:09:02.0: reg 18: [mem 0xd8000000-0xd801ffff 64bit pref]
[    2.380132] pci 0000:09:02.0: reg 20: [io  0x3000-0x30ff]
[    2.380153] pci 0000:09:02.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    2.380255] pci 0000:08:00.0: PCI bridge to [bus 09-09]
[    2.390006] pci 0000:08:00.0:   bridge window [io  0x3000-0x3fff]
[    2.390011] pci 0000:08:00.0:   bridge window [mem 0xd8300000-0xd83fffff]
[    2.390018] pci 0000:08:00.0:   bridge window [mem 0xd8000000-0xd80fffff 64bit pref]
[    2.390060] pci 0000:0a:01.0: [1002:515e] type 0 class 0x000300
[    2.390079] pci 0000:0a:01.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
[    2.390089] pci 0000:0a:01.0: reg 14: [io  0x4000-0x40ff]
[    2.390100] pci 0000:0a:01.0: reg 18: [mem 0xd8400000-0xd840ffff]
[    2.390134] pci 0000:0a:01.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    2.390164] pci 0000:0a:01.0: supports D1 D2
[    2.390208] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a] (subtractive decode)
[    2.397490] pci 0000:00:1e.0:   bridge window [io  0x4000-0x4fff]
[    2.397494] pci 0000:00:1e.0:   bridge window [mem 0xd8400000-0xd84fffff]
[    2.397500] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    2.397503] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    2.397506] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    2.397509] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    2.397512] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    2.397515] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    2.397518] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    2.397521] pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
[    2.397524] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xfebfffff] (subtractive decode)
[    2.397544] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.397716] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    2.397745] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0._PRT]
[    2.397783] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0.BPD0._PRT]
[    2.397833] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0.BPD2._PRT]
[    2.397868] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMF3._PRT]
[    2.397915] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    2.397964] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    2.398018] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0.PXH0._PRT]
[    2.398088] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    2.398137]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
[    2.413663] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 *7 10 11 14 15)
[    2.421272] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 14 15)
[    2.429005] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 14 15)
[    2.433173] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 14 15)
[    2.443166] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    2.453693] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
[    2.462809] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    2.472023] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
[    2.480653] vgaarb: device added: PCI:0000:0a:01.0,decodes=io+mem,owns=io+mem,locks=none
[    2.489185] vgaarb: loaded
[    2.490003] vgaarb: bridge control possible 0000:0a:01.0
[    2.495739] SCSI subsystem initialized
[    2.500141] libata version 3.00 loaded.
[    2.500238] usbcore: registered new interface driver usbfs
[    2.506014] usbcore: registered new interface driver hub
[    2.510064] usbcore: registered new device driver usb
[    2.515578] PCI: Using ACPI for IRQ routing
[    2.520004] PCI: pci_cache_line_size set to 64 bytes
[    2.520109] reserve RAM buffer: 0000000000099000 - 000000000009ffff 
[    2.520112] reserve RAM buffer: 00000000cff50000 - 00000000cfffffff 
[    2.520461] hpet clockevent registered
[    2.520465] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    2.530005] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    2.535364] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    2.560192] Switching to clocksource hpet
[    2.569746] pnp: PnP ACPI init
[    2.573051] ACPI: bus type pnp registered
[    2.577902] pnp 00:00: [bus 00-ff]
[    2.577905] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.577907] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.577913] pnp 00:00: [io  0x0d00-0xffff window]
[    2.577915] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.577917] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    2.577920] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    2.577922] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    2.577925] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    2.577927] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    2.577929] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    2.577932] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    2.577934] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    2.577936] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    2.577939] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    2.577941] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    2.577943] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    2.577946] pnp 00:00: [mem 0xd0000000-0xfebfffff window]
[    2.578040] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    2.578137] pnp 00:01: [io  0x0010-0x001f]
[    2.578139] pnp 00:01: [io  0x0024-0x0025]
[    2.578141] pnp 00:01: [io  0x0028-0x0029]
[    2.578143] pnp 00:01: [io  0x002c-0x002d]
[    2.578145] pnp 00:01: [io  0x002e-0x002f]
[    2.578147] pnp 00:01: [io  0x0030-0x0031]
[    2.578149] pnp 00:01: [io  0x0034-0x0035]
[    2.578151] pnp 00:01: [io  0x0038-0x0039]
[    2.578153] pnp 00:01: [io  0x003c-0x003d]
[    2.578155] pnp 00:01: [io  0x004e-0x004f]
[    2.578157] pnp 00:01: [io  0x0050-0x0053]
[    2.578159] pnp 00:01: [io  0x0063]
[    2.578161] pnp 00:01: [io  0x0065]
[    2.578163] pnp 00:01: [io  0x0067]
[    2.578165] pnp 00:01: [io  0x0072-0x0077]
[    2.578167] pnp 00:01: [io  0x0080]
[    2.578169] pnp 00:01: [io  0x0090-0x009f]
[    2.578171] pnp 00:01: [io  0x00a4-0x00a5]
[    2.578173] pnp 00:01: [io  0x00a8-0x00a9]
[    2.578175] pnp 00:01: [io  0x00ac-0x00ad]
[    2.578177] pnp 00:01: [io  0x00b0-0x00b5]
[    2.578179] pnp 00:01: [io  0x00b8-0x00b9]
[    2.578181] pnp 00:01: [io  0x00bc-0x00bd]
[    2.578183] pnp 00:01: [io  0x04d0-0x04d1]
[    2.578185] pnp 00:01: [io  0x0295-0x0296]
[    2.578187] pnp 00:01: [io  0x0ca2-0x0ca3]
[    2.578189] pnp 00:01: [io  0x0ca8-0x0caf]
[    2.578194] pnp 00:01: [io  0x1000-0x107f]
[    2.578196] pnp 00:01: [io  0x1180-0x11bf]
[    2.578199] pnp 00:01: [io  0x0800-0x080f]
[    2.578201] pnp 00:01: [io  0xfe00]
[    2.578203] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    2.578205] pnp 00:01: [mem 0xfee00000-0xfee0ffff]
[    2.578207] pnp 00:01: [mem 0xfec80000-0xfec80fff]
[    2.578209] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    2.578211] pnp 00:01: [mem 0xfe000000-0xfe01ffff]
[    2.578213] pnp 00:01: [mem 0xfe600000-0xfe6fffff]
[    2.578376] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    2.584537] system 00:01: [io  0x0295-0x0296] has been reserved
[    2.590726] system 00:01: [io  0x0ca2-0x0ca3] has been reserved
[    2.596894] system 00:01: [io  0x0ca8-0x0caf] has been reserved
[    2.603050] system 00:01: [io  0x1000-0x107f] has been reserved
[    2.609236] system 00:01: [io  0x1180-0x11bf] has been reserved
[    2.615391] system 00:01: [io  0x0800-0x080f] has been reserved
[    2.621576] system 00:01: [io  0xfe00] has been reserved
[    2.627143] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    2.633998] system 00:01: [mem 0xfee00000-0xfee0ffff] could not be reserved
[    2.641226] system 00:01: [mem 0xfec80000-0xfec80fff] could not be reserved
[    2.648678] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.655527] system 00:01: [mem 0xfe000000-0xfe01ffff] has been reserved
[    2.662407] system 00:01: [mem 0xfe600000-0xfe6fffff] has been reserved
[    2.669280] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.669292] pnp 00:02: [io  0x0000-0x001f]
[    2.669294] pnp 00:02: [io  0x0081-0x0091]
[    2.669296] pnp 00:02: [io  0x0093-0x009f]
[    2.669298] pnp 00:02: [io  0x00c0-0x00df]
[    2.669301] pnp 00:02: [dma 4]
[    2.669368] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.669379] pnp 00:03: [io  0x00f0-0x00fe]
[    2.669391] pnp 00:03: [irq 13]
[    2.669451] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.669504] pnp 00:04: [io  0x0070-0x0071]
[    2.669567] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.669577] pnp 00:05: [io  0x0061]
[    2.669641] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    2.669771] pnp 00:06: [mem 0xff000000-0xffffffff]
[    2.669838] pnp 00:06: Plug and Play ACPI device, IDs INT0800 (active)
[    2.669859] pnp 00:07: [io  0x0060]
[    2.669861] pnp 00:07: [io  0x0064]
[    2.669867] pnp 00:07: [irq 1]
[    2.669933] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    2.669954] pnp 00:08: [irq 12]
[    2.670020] pnp 00:08: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.670194] pnp 00:09: [io  0x03f8-0x03ff]
[    2.670200] pnp 00:09: [irq 4]
[    2.670308] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.670474] pnp 00:0a: [io  0x02f8-0x02ff]
[    2.670480] pnp 00:0a: [irq 3]
[    2.670583] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.670805] pnp 00:0b: [io  0x03f0-0x03f5]
[    2.670807] pnp 00:0b: [io  0x03f7]
[    2.670813] pnp 00:0b: [irq 6]
[    2.670815] pnp 00:0b: [dma 2]
[    2.670905] pnp 00:0b: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.670990] pnp: PnP ACPI: found 12 devices
[    2.675417] ACPI: ACPI bus type pnp unregistered
[    2.688563] PCI: max bus depth: 3 pci_try_num: 4
[    2.688630] pci 0000:00:02.0: BAR 15: assigned [mem 0xd8500000-0xd85fffff pref]
[    2.696407] pci 0000:01:00.0: BAR 15: assigned [mem 0xd8500000-0xd85fffff pref]
[    2.704154] pci 0000:02:02.0: BAR 15: assigned [mem 0xd8500000-0xd85fffff pref]
[    2.711935] pci 0000:02:00.0: PCI bridge to [bus 03-03]
[    2.717422] pci 0000:04:00.0: BAR 6: assigned [mem 0xd8500000-0xd850ffff pref]
[    2.725083] pci 0000:04:00.1: BAR 6: assigned [mem 0xd8510000-0xd851ffff pref]
[    2.732778] pci 0000:02:02.0: PCI bridge to [bus 04-04]
[    2.738257] pci 0000:02:02.0:   bridge window [io  0x2000-0x2fff]
[    2.744587] pci 0000:02:02.0:   bridge window [mem 0xd8200000-0xd82fffff]
[    2.751638] pci 0000:02:02.0:   bridge window [mem 0xd8500000-0xd85fffff pref]
[    2.759319] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    2.764780] pci 0000:01:00.0:   bridge window [io  0x2000-0x2fff]
[    2.771140] pci 0000:01:00.0:   bridge window [mem 0xd8200000-0xd82fffff]
[    2.778185] pci 0000:01:00.0:   bridge window [mem 0xd8500000-0xd85fffff pref]
[    2.785864] pci 0000:01:00.3: PCI bridge to [bus 05-05]
[    2.791332] pci 0000:00:02.0: PCI bridge to [bus 01-05]
[    2.796817] pci 0000:00:02.0:   bridge window [io  0x2000-0x2fff]
[    2.803148] pci 0000:00:02.0:   bridge window [mem 0xd8100000-0xd82fffff]
[    2.810199] pci 0000:00:02.0:   bridge window [mem 0xd8500000-0xd85fffff pref]
[    2.817882] pci 0000:00:04.0: PCI bridge to [bus 06-06]
[    2.823355] pci 0000:00:06.0: PCI bridge to [bus 07-07]
[    2.828846] pci 0000:09:02.0: BAR 6: assigned [mem 0xd8080000-0xd80fffff pref]
[    2.836518] pci 0000:08:00.0: PCI bridge to [bus 09-09]
[    2.841984] pci 0000:08:00.0:   bridge window [io  0x3000-0x3fff]
[    2.848345] pci 0000:08:00.0:   bridge window [mem 0xd8300000-0xd83fffff]
[    2.855373] pci 0000:08:00.0:   bridge window [mem 0xd8000000-0xd80fffff 64bit pref]
[    2.863588] pci 0000:00:1c.0: PCI bridge to [bus 08-09]
[    2.869062] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    2.875393] pci 0000:00:1c.0:   bridge window [mem 0xd8300000-0xd83fffff]
[    2.882445] pci 0000:00:1c.0:   bridge window [mem 0xd8000000-0xd80fffff 64bit pref]
[    2.890648] pci 0000:0a:01.0: BAR 6: assigned [mem 0xd8420000-0xd843ffff pref]
[    2.898320] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
[    2.904054] pci 0000:00:1e.0:   bridge window [io  0x4000-0x4fff]
[    2.910414] pci 0000:00:1e.0:   bridge window [mem 0xd8400000-0xd84fffff]
[    2.917458] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    2.925665] pci 0000:00:02.0: setting latency timer to 64
[    2.925681] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.932618] pci 0000:01:00.0: setting latency timer to 64
[    2.932624] pci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.939593] pci 0000:02:00.0: setting latency timer to 64
[    2.939604] pci 0000:02:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.946560] pci 0000:02:02.0: setting latency timer to 64
[    2.946567] pci 0000:01:00.3: setting latency timer to 64
[    2.946573] pci 0000:00:04.0: setting latency timer to 64
[    2.946579] pci 0000:00:06.0: setting latency timer to 64
[    2.946589] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.953530] pci 0000:00:1c.0: setting latency timer to 64
[    2.953539] pci 0000:08:00.0: setting latency timer to 64
[    2.953545] pci 0000:00:1e.0: setting latency timer to 64
[    2.953549] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.953552] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.953554] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.953557] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    2.953559] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    2.953562] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff]
[    2.953564] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000e3fff]
[    2.953567] pci_bus 0000:00: resource 11 [mem 0xd0000000-0xfebfffff]
[    2.953570] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    2.953572] pci_bus 0000:01: resource 1 [mem 0xd8100000-0xd82fffff]
[    2.953575] pci_bus 0000:01: resource 2 [mem 0xd8500000-0xd85fffff pref]
[    2.953577] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    2.953580] pci_bus 0000:02: resource 1 [mem 0xd8200000-0xd82fffff]
[    2.953583] pci_bus 0000:02: resource 2 [mem 0xd8500000-0xd85fffff pref]
[    2.953585] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    2.953588] pci_bus 0000:04: resource 1 [mem 0xd8200000-0xd82fffff]
[    2.953590] pci_bus 0000:04: resource 2 [mem 0xd8500000-0xd85fffff pref]
[    2.953594] pci_bus 0000:08: resource 0 [io  0x3000-0x3fff]
[    2.953596] pci_bus 0000:08: resource 1 [mem 0xd8300000-0xd83fffff]
[    2.953599] pci_bus 0000:08: resource 2 [mem 0xd8000000-0xd80fffff 64bit pref]
[    2.953601] pci_bus 0000:09: resource 0 [io  0x3000-0x3fff]
[    2.953604] pci_bus 0000:09: resource 1 [mem 0xd8300000-0xd83fffff]
[    2.953607] pci_bus 0000:09: resource 2 [mem 0xd8000000-0xd80fffff 64bit pref]
[    2.953609] pci_bus 0000:0a: resource 0 [io  0x4000-0x4fff]
[    2.953612] pci_bus 0000:0a: resource 1 [mem 0xd8400000-0xd84fffff]
[    2.953614] pci_bus 0000:0a: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
[    2.953617] pci_bus 0000:0a: resource 4 [io  0x0000-0x0cf7]
[    2.953619] pci_bus 0000:0a: resource 5 [io  0x0d00-0xffff]
[    2.953622] pci_bus 0000:0a: resource 6 [mem 0x000a0000-0x000bffff]
[    2.953624] pci_bus 0000:0a: resource 7 [mem 0x000d4000-0x000d7fff]
[    2.953627] pci_bus 0000:0a: resource 8 [mem 0x000d8000-0x000dbfff]
[    2.953629] pci_bus 0000:0a: resource 9 [mem 0x000dc000-0x000dffff]
[    2.953632] pci_bus 0000:0a: resource 10 [mem 0x000e0000-0x000e3fff]
[    2.953634] pci_bus 0000:0a: resource 11 [mem 0xd0000000-0xfebfffff]
[    2.953679] NET: Registered protocol family 2
[    2.958765] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    2.968576] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.980591] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.988096] TCP: Hash tables configured (established 524288 bind 65536)
[    2.994945] TCP reno registered
[    2.998379] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    3.004868] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    3.011913] NET: Registered protocol family 1
[    3.016585] pci 0000:00:1d.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.023532] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x003b
[    3.023534] pci 0000:00:1d.0: Performing full reset
[    3.023549] pci 0000:00:1d.0: PCI INT A disabled
[    3.028450] pci 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.035387] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    3.035389] pci 0000:00:1d.1: Performing full reset
[    3.035402] pci 0000:00:1d.1: PCI INT B disabled
[    3.040296] pci 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.047252] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    3.047255] pci 0000:00:1d.2: Performing full reset
[    3.047268] pci 0000:00:1d.2: PCI INT C disabled
[    3.052131] pci 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    3.059098] pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x0010
[    3.059100] pci 0000:00:1d.3: Performing full reset
[    3.059113] pci 0000:00:1d.3: PCI INT D disabled
[    3.063980] pci 0000:00:1d.7: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.070973] pci 0000:00:1d.7: PCI INT A disabled
[    3.075863] PCI: CLS mismatch (32 != 64), using 64 bytes
[    3.075879] pci 0000:0a:01.0: Boot video device
[    3.075944] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.082619] Placing 64MB software IO TLB between ffff8800cbf3e000 - ffff8800cff3e000
[    3.090835] software IO TLB at phys 0xcbf3e000 - 0xcff3e000
[    3.096664] Simple Boot Flag at 0x38 set to 0x1
[    3.103283] audit: initializing netlink socket (disabled)
[    3.108958] type=2000 audit(1335705467.100:1): initialized
[    3.202606] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.213435] VFS: Disk quotas dquot_6.5.2
[    3.217719] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.225613] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    3.236284] SGI XFS Quota Management subsystem
[    3.240976] msgmni has been set to 32098
[    3.245580] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.253467] io scheduler noop registered
[    3.257643] io scheduler deadline registered
[    3.262225] io scheduler cfq registered (default)
[    3.267650] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.273617] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0A03:00/PNP0C0C:00/input/input0
[    3.283231] ACPI: Power Button [PWRB]
[    3.287221] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    3.301184] ACPI: Power Button [PWRF]
[    3.307553] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.605796] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.905801] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.932893] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.959303] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.965396] Linux agpgart interface v0.103
[    3.969939] ipmi message handler version 39.2
[    3.974537] ipmi device interface
[    3.978199] IPMI System Interface driver.
[    3.982536] ipmi_si: probing via SMBIOS
[    3.986630] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[    3.992785] ipmi_si: Adding SMBIOS-specified kcs state machine
[    3.998950] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
[    4.095645] Refined TSC clocksource calibration: 2000.070 MHz.
[    4.101727] Switching to clocksource tsc
[    4.316149] ipmi_si ipmi_si.0: Found new BMC (man_id: 0x0028c5, prod_id: 0x0004, dev_id: 0x22)
[    4.325252] ipmi_si ipmi_si.0: IPMI kcs interface initialized
[    4.333635] IPMI Watchdog: driver initialized
[    4.338254] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    4.347307] IPMI poweroff: ATCA Detect mfg 0x28C5 prod 0x4
[    4.353030] IPMI poweroff: Found a chassis style poweroff function
[    4.359479] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    4.368888] Hangcheck: Using getrawmonotonic().
[    4.375873] brd: module loaded
[    4.380342] loop: module loaded
[    4.392373] vroot: loaded (max 64 devices)
[    4.397160] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    4.404228] aic94xx 0000:09:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    4.411586] aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:09:02.0
[    4.420048] scsi0 : aic94xx
[    4.423649] aic94xx: BIOS present (1,1), 1822
[    4.428265] aic94xx: ue num:4, ue size:88
[    4.449229] aic94xx: manuf sect SAS_ADDR 50030480002a8a30
[    4.454867] aic94xx: manuf sect PCBA SN ORG
[    4.459316] aic94xx: ms: num_phy_desc: 8
[    4.463474] aic94xx: ms: phy0: ENABLED
[    4.467480] aic94xx: ms: phy1: ENABLED
[    4.471474] aic94xx: ms: phy2: ENABLED
[    4.475462] aic94xx: ms: phy3: ENABLED
[    4.479474] aic94xx: ms: phy4: ENABLED
[    4.483461] aic94xx: ms: phy5: ENABLED
[    4.487465] aic94xx: ms: phy6: ENABLED
[    4.491450] aic94xx: ms: phy7: ENABLED
[    4.495438] aic94xx: ms: max_phys:0x8, num_phys:0x8
[    4.500577] aic94xx: ms: enabled_phys:0xff
[    4.516071] aic94xx: ctrla: phy0: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.526352] aic94xx: ctrla: phy1: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.536633] aic94xx: ctrla: phy2: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.546910] aic94xx: ctrla: phy3: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.557190] aic94xx: ctrla: phy4: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.567468] aic94xx: ctrla: phy5: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.577749] aic94xx: ctrla: phy6: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.588027] aic94xx: ctrla: phy7: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.598317] aic94xx: max_scbs:512, max_ddbs:128
[    4.603087] aic94xx: setting phy0 addr to 50030480002a8a30
[    4.608834] aic94xx: setting phy1 addr to 50030480002a8a30
[    4.614557] aic94xx: setting phy2 addr to 50030480002a8a30
[    4.620309] aic94xx: setting phy3 addr to 50030480002a8a30
[    4.626046] aic94xx: setting phy4 addr to 50030480002a8a30
[    4.631771] aic94xx: setting phy5 addr to 50030480002a8a30
[    4.637520] aic94xx: setting phy6 addr to 50030480002a8a30
[    4.643244] aic94xx: setting phy7 addr to 50030480002a8a30
[    4.649038] aic94xx: num_edbs:21
[    4.652506] aic94xx: num_escbs:3
[    4.656019] aic94xx: Found sequencer Firmware version 1.1 (V17/10c6)
[    4.662613] aic94xx: downloading CSEQ...
[    4.666814] aic94xx: dma-ing 8192 bytes
[    4.673742] aic94xx: verified 8192 bytes, passed
[    4.678631] aic94xx: downloading LSEQs...
[    4.682895] aic94xx: dma-ing 14336 bytes
[    4.692056] aic94xx: LSEQ0 verified 14336 bytes, passed
[    4.702303] aic94xx: LSEQ1 verified 14336 bytes, passed
[    4.712547] aic94xx: LSEQ2 verified 14336 bytes, passed
[    4.722789] aic94xx: LSEQ3 verified 14336 bytes, passed
[    4.733034] aic94xx: LSEQ4 verified 14336 bytes, passed
[    4.743278] aic94xx: LSEQ5 verified 14336 bytes, passed
[    4.753523] aic94xx: LSEQ6 verified 14336 bytes, passed
[    4.763769] aic94xx: LSEQ7 verified 14336 bytes, passed
[    4.782381] aic94xx: max_scbs:446
[    4.785963] aic94xx: first_scb_site_no:0x20
[    4.790391] aic94xx: last_scb_site_no:0x1fe
[    4.794838] aic94xx: First SCB dma_handle: 0x413df1000
[    4.800675] aic94xx: device 0000:09:02.0: SAS addr 50030480002a8a30, PCBA SN ORG, 8 phys, 8 enabled phys, flash present, BIOS build 1822
[    4.813402] aic94xx: posting 3 escbs
[    4.817233] aic94xx: escbs posted
[    4.821346] aic94xx: posting 8 control phy scbs
[    4.826224] aic94xx: control_phy_tasklet_complete: phy0, lrate:0x8, proto:0xe
[    4.833612] aic94xx: control_phy_tasklet_complete: phy1, lrate:0x8, proto:0xe
[    4.841030] aic94xx: control_phy_tasklet_complete: phy2, lrate:0x8, proto:0xe
[    4.848434] aic94xx: control_phy_tasklet_complete: phy3, lrate:0x8, proto:0xe
[    4.855833] aic94xx: control_phy_tasklet_complete: phy4: no device present: oob_status:0x0
[    4.864541] aic94xx: control_phy_tasklet_complete: phy5: no device present: oob_status:0x0
[    4.873292] aic94xx: control_phy_tasklet_complete: phy6: no device present: oob_status:0x0
[    4.882015] aic94xx: control_phy_tasklet_complete: phy7: no device present: oob_status:0x0
[    4.890736] aic94xx: escb_tasklet_complete: phy2: BYTES_DMAED
[    4.896731] aic94xx: STP proto device-to-host FIS:
[    4.901765] aic94xx: 00: 34 00 50 01
[    4.905588] aic94xx: 04: 01 00 00 00
[    4.906729] aic94xx: 08: 00 00 00 00
[    4.906729] aic94xx: 0c: 01 00 00 00
[    4.906729] aic94xx: 10: 00 00 00 00
[    4.920895] aic94xx: asd_form_port: updating phy_mask 0x4 for phy2
[    4.927336] aic94xx: escb_tasklet_complete: phy3: BYTES_DMAED
[    4.933318] aic94xx: STP proto device-to-host FIS:
[    4.938375] aic94xx: 00: 34 00 50 01
[    4.942197] aic94xx: 04: 01 00 00 00
[    4.946011] aic94xx: 08: 00 00 00 00
[    4.948373] aic94xx: 0c: 01 00 00 00
[    4.948373] aic94xx: 10: 00 00 00 00
[    4.957502] aic94xx: asd_form_port: updating phy_mask 0x8 for phy3
[    4.963930] aic94xx: escb_tasklet_complete: phy1: BYTES_DMAED
[    4.969939] aic94xx: STP proto device-to-host FIS:
[    4.974973] aic94xx: 00: 34 00 50 01
[    4.978787] aic94xx: 04: 01 00 00 00
[    4.979938] aic94xx: 08: 00 00 00 00
[    4.979938] aic94xx: 0c: 01 00 00 00
[    4.979938] aic94xx: 10: 00 00 00 00
[    4.994092] aic94xx: asd_form_port: updating phy_mask 0x2 for phy1
[    5.000535] aic94xx: escb_tasklet_complete: phy0: BYTES_DMAED
[    5.006529] aic94xx: STP proto device-to-host FIS:
[    5.011561] aic94xx: 00: 34 00 50 01
[    5.015376] aic94xx: 04: 01 00 00 00
[    5.016527] aic94xx: 08: 00 00 00 00
[    5.016527] aic94xx: 0c: 01 00 00 00
[    5.016527] aic94xx: 10: 00 00 00 00
[    5.030693] aic94xx: asd_form_port: updating phy_mask 0x1 for phy0
[    5.037166] sas: phy-0:2 added to port-0:0, phy_mask:0x4 (50030480002a8a42)
[    5.037239] sas: phy-0:3 added to port-0:1, phy_mask:0x8 (50030480002a8a43)
[    5.037303] sas: phy-0:1 added to port-0:2, phy_mask:0x2 (50030480002a8a41)
[    5.037361] sas: phy-0:0 added to port-0:3, phy_mask:0x1 (50030480002a8a40)
[    5.037370] sas: DOING DISCOVERY on port 0, pid:24
[    5.039271] sas: Enter sas_scsi_recover_host
[    5.039275] ata1: sas eh calling libata port error handler
[    5.039287] aic94xx: asd_clear_nexus_I_T: PRE
[    5.043886] aic94xx: asd_clear_nexus_I_T: POST
[    5.048601] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    5.048615] aic94xx: asd_clear_nexus_tasklet_complete: here
[    5.048617] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    5.067804] aic94xx: sending soft reset to phy-0:2
[    5.072974] aic94xx: control_phy_tasklet_complete: phy2, lrate:0x8, proto:0xe
[    5.087714] aic94xx: escb_tasklet_complete: phy2: BYTES_DMAED
[    5.093700] aic94xx: STP proto device-to-host FIS:
[    5.098761] aic94xx: 00: 34 00 50 01
[    5.102581] aic94xx: 04: 01 00 00 00
[    5.106397] aic94xx: 08: 00 00 00 00
[    5.108759] aic94xx: 0c: 01 00 00 00
[    5.108759] aic94xx: 10: 00 00 00 00
[    5.117888] aic94xx: asd_form_port: updating phy_mask 0x4 for phy2
[    5.575717] aic94xx: asd_clear_nexus_I_T: PRE
[    5.580313] aic94xx: asd_clear_nexus_I_T: POST
[    5.585001] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    5.585179] aic94xx: asd_clear_nexus_tasklet_complete: here
[    5.585182] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    5.604227] aic94xx: asd_clear_nexus_I_T: PRE
[    5.608838] aic94xx: asd_clear_nexus_I_T: POST
[    5.613524] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    5.613535] aic94xx: asd_clear_nexus_tasklet_complete: here
[    5.613538] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x13
[    5.632819] sas: sas_ata_hard_reset: Found ATA device.
[    5.635129] ata1.00: native sectors (1) is smaller than sectors (3907029168)
[    5.642444] ata1.00: ATA-8: ST32000644NS, SN11, max UDMA/133
[    5.648359] ata1.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.657335] ata1.00: configured for UDMA/133
[    5.661851] sas: --- Exit sas_scsi_recover_host
[    5.675672] scsi 0:0:0:0: Direct-Access     ATA      ST32000644NS     SN11 PQ: 0 ANSI: 5
[    5.684423] sas: DONE DISCOVERY on port 0, pid:24, result:0
[    5.684433] sas: DOING DISCOVERY on port 1, pid:24
[    5.686369] sas: Enter sas_scsi_recover_host
[    5.686373] ata1: sas eh calling libata port error handler
[    5.686382] ata2: sas eh calling libata port error handler
[    5.686389] aic94xx: asd_clear_nexus_I_T: PRE
[    5.690986] aic94xx: asd_clear_nexus_I_T: POST
[    5.695697] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    5.695716] aic94xx: asd_clear_nexus_tasklet_complete: here
[    5.695719] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    5.721029] aic94xx: sending soft reset to phy-0:3
[    5.726212] aic94xx: control_phy_tasklet_complete: phy3, lrate:0x8, proto:0xe
[    5.741096] aic94xx: escb_tasklet_complete: phy3: BYTES_DMAED
[    5.747107] aic94xx: STP proto device-to-host FIS:
[    5.752139] aic94xx: 00: 34 00 50 01
[    5.755953] aic94xx: 04: 01 00 00 00
[    5.757104] aic94xx: 08: 00 00 00 00
[    5.757104] aic94xx: 0c: 01 00 00 00
[    5.757104] aic94xx: 10: 00 00 00 00
[    5.771269] aic94xx: asd_form_port: updating phy_mask 0x8 for phy3
[    6.235676] aic94xx: asd_clear_nexus_I_T: PRE
[    6.240273] aic94xx: asd_clear_nexus_I_T: POST
[    6.244960] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    6.245137] aic94xx: asd_clear_nexus_tasklet_complete: here
[    6.245139] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    6.264178] aic94xx: asd_clear_nexus_I_T: PRE
[    6.268788] aic94xx: asd_clear_nexus_I_T: POST
[    6.273474] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    6.273486] aic94xx: asd_clear_nexus_tasklet_complete: here
[    6.273488] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x13
[    6.292777] sas: sas_ata_hard_reset: Found ATA device.
[    6.295547] ata2.00: native sectors (1) is smaller than sectors (3907029168)
[    6.302860] ata2.00: ATA-8: ST32000644NS, SN11, max UDMA/133
[    6.308766] ata2.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.317764] ata2.00: configured for UDMA/133
[    6.322276] sas: --- Exit sas_scsi_recover_host
[    6.335812] scsi 0:0:1:0: Direct-Access     ATA      ST32000644NS     SN11 PQ: 0 ANSI: 5
[    6.344569] sas: DONE DISCOVERY on port 1, pid:24, result:0
[    6.344578] sas: DOING DISCOVERY on port 2, pid:24
[    6.346251] sas: Enter sas_scsi_recover_host
[    6.346254] ata1: sas eh calling libata port error handler
[    6.346261] ata2: sas eh calling libata port error handler
[    6.346265] ata3: sas eh calling libata port error handler
[    6.346270] aic94xx: asd_clear_nexus_I_T: PRE
[    6.351047] aic94xx: asd_clear_nexus_I_T: POST
[    6.355751] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    6.355771] aic94xx: asd_clear_nexus_tasklet_complete: here
[    6.355773] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    6.374963] aic94xx: sending soft reset to phy-0:1
[    6.380083] aic94xx: control_phy_tasklet_complete: phy1, lrate:0x8, proto:0xe
[    6.423221] aic94xx: escb_tasklet_complete: phy1: BYTES_DMAED
[    6.429233] aic94xx: STP proto device-to-host FIS:
[    6.434267] aic94xx: 00: 34 00 50 01
[    6.438081] aic94xx: 04: 01 00 00 00
[    6.439231] aic94xx: 08: 00 00 00 00
[    6.439231] aic94xx: 0c: 01 00 00 00
[    6.439231] aic94xx: 10: 00 00 00 00
[    6.453396] aic94xx: asd_form_port: updating phy_mask 0x2 for phy1
[    6.885728] aic94xx: asd_clear_nexus_I_T: PRE
[    6.890326] aic94xx: asd_clear_nexus_I_T: POST
[    6.895012] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    6.895188] aic94xx: asd_clear_nexus_tasklet_complete: here
[    6.895191] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    6.914238] aic94xx: asd_clear_nexus_I_T: PRE
[    6.918848] aic94xx: asd_clear_nexus_I_T: POST
[    6.923534] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    6.923545] aic94xx: asd_clear_nexus_tasklet_complete: here
[    6.923547] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x13
[    6.942836] sas: sas_ata_hard_reset: Found ATA device.
[    6.971649] ata3.00: native sectors (1) is smaller than sectors (1953525168)
[    6.978965] ata3.00: ATA-8: ST31000340NS, SN06, max UDMA/133
[    6.984868] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.034053] ata3.00: configured for UDMA/133
[    7.038601] sas: --- Exit sas_scsi_recover_host
[    7.055748] scsi 0:0:2:0: Direct-Access     ATA      ST31000340NS     SN06 PQ: 0 ANSI: 5
[    7.064492] sas: DONE DISCOVERY on port 2, pid:24, result:0
[    7.064502] sas: DOING DISCOVERY on port 3, pid:24
[    7.066190] sas: Enter sas_scsi_recover_host
[    7.066193] ata1: sas eh calling libata port error handler
[    7.066198] ata2: sas eh calling libata port error handler
[    7.066203] ata3: sas eh calling libata port error handler
[    7.066207] ata4: sas eh calling libata port error handler
[    7.066212] aic94xx: asd_clear_nexus_I_T: PRE
[    7.070808] aic94xx: asd_clear_nexus_I_T: POST
[    7.075495] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    7.075515] aic94xx: asd_clear_nexus_tasklet_complete: here
[    7.075517] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    7.094723] aic94xx: sending soft reset to phy-0:0
[    7.099844] aic94xx: control_phy_tasklet_complete: phy0, lrate:0x8, proto:0xe
[    7.143071] aic94xx: escb_tasklet_complete: phy0: BYTES_DMAED
[    7.149086] aic94xx: STP proto device-to-host FIS:
[    7.154119] aic94xx: 00: 34 00 50 01
[    7.157934] aic94xx: 04: 01 00 00 00
[    7.159085] aic94xx: 08: 00 00 00 00
[    7.159085] aic94xx: 0c: 01 00 00 00
[    7.159085] aic94xx: 10: 00 00 00 00
[    7.173241] aic94xx: asd_form_port: updating phy_mask 0x1 for phy0
[    7.615624] aic94xx: asd_clear_nexus_I_T: PRE
[    7.620222] aic94xx: asd_clear_nexus_I_T: POST
[    7.624912] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    7.625089] aic94xx: asd_clear_nexus_tasklet_complete: here
[    7.625091] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    7.644138] aic94xx: asd_clear_nexus_I_T: PRE
[    7.648747] aic94xx: asd_clear_nexus_I_T: POST
[    7.653432] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    7.653444] aic94xx: asd_clear_nexus_tasklet_complete: here
[    7.653446] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x13
[    7.672727] sas: sas_ata_hard_reset: Found ATA device.
[    7.701539] ata4.00: native sectors (1) is smaller than sectors (1953525168)
[    7.708854] ata4.00: ATA-8: ST31000340NS, SN06, max UDMA/133
[    7.714757] ata4.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.763978] ata4.00: configured for UDMA/133
[    7.768515] sas: --- Exit sas_scsi_recover_host
[    7.785802] scsi 0:0:3:0: Direct-Access     ATA      ST31000340NS     SN06 PQ: 0 ANSI: 5
[    7.794541] sas: DONE DISCOVERY on port 3, pid:24, result:0
[    7.794544] sas: sas_form_port: phy2 belongs to port0 already(1)!
[    7.794547] sas: sas_form_port: phy3 belongs to port1 already(1)!
[    7.794551] sas: sas_form_port: phy1 belongs to port2 already(1)!
[    7.794554] sas: sas_form_port: phy0 belongs to port3 already(1)!
[    7.794750] sd 0:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    7.794822] sd 0:0:1:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    7.794897] sd 0:0:1:0: [sdb] Write Protect is off
[    7.794900] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    7.794931] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.825771] sd 0:0:0:0: [sda] Write Protect is off
[    7.825851] sd 0:0:2:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.825920] sd 0:0:2:0: [sdc] Write Protect is off
[    7.825923] sd 0:0:2:0: [sdc] Mode Sense: 00 3a 00 00
[    7.825955] sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.826113] sd 0:0:3:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.826165] sd 0:0:3:0: [sdd] Write Protect is off
[    7.826167] sd 0:0:3:0: [sdd] Mode Sense: 00 3a 00 00
[    7.826193] sd 0:0:3:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.826433] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.826501] sd 0:0:1:0: Attached scsi generic sg1 type 0
[    7.826565] sd 0:0:2:0: Attached scsi generic sg2 type 0
[    7.826624] sd 0:0:3:0: Attached scsi generic sg3 type 0
[    7.826729] ata_piix 0000:00:1f.1: version 2.13
[    7.826744] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.826779] ata_piix 0000:00:1f.1: setting latency timer to 64
[    7.827267] scsi1 : ata_piix
[    7.827390] scsi2 : ata_piix
[    7.827802] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1880 irq 14
[    7.827805] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1888 irq 15
[    7.827977] ata6: port disabled--ignoring
[    7.828125] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    7.828299] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.828303] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    7.828322] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    7.828349] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    7.828353] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    7.828374] drivers/usb/core/inode.c: creating file 'devices'
[    7.828378] drivers/usb/core/inode.c: creating file '001'
[    7.828442] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    7.828451] ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
[    7.828455] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    7.828482] ehci_hcd 0000:00:1d.7: debug port 1
[    7.828488] ehci_hcd 0000:00:1d.7: reset command 0080022 (park)=0 ithresh=8 Async period=1024 Reset HALT
[    7.832369] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    7.832371] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    7.832387] ehci_hcd 0000:00:1d.7: irq 17, io mem 0xd8700000
[    7.832392] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    7.836285] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    7.855630] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    7.855689] usb usb1: default language 0x0409
[    7.855696] usb usb1: udev 1, busnum 1, minor = 0
[    7.855698] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.855700] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.855703] usb usb1: Product: EHCI Host Controller
[    7.855705] usb usb1: Manufacturer: Linux 3.2.15-00012-g7afde96 ehci_hcd
[    7.855706] usb usb1: SerialNumber: 0000:00:1d.7
[    7.855791] usb usb1: usb_probe_device
[    7.855794] usb usb1: configuration #1 chosen from 1 choice
[    7.855801] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    7.855866] hub 1-0:1.0: usb_probe_interface
[    7.855868] hub 1-0:1.0: usb_probe_interface - got id
[    7.855870] hub 1-0:1.0: USB hub found
[    7.855875] hub 1-0:1.0: 8 ports detected
[    7.855877] hub 1-0:1.0: standalone hub
[    7.855878] hub 1-0:1.0: no power switching (usb 1.0)
[    7.855880] hub 1-0:1.0: individual port over-current protection
[    7.855882] hub 1-0:1.0: power on to power good time: 20ms
[    7.855886] hub 1-0:1.0: local power source is good
[    7.855889] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    7.855921] drivers/usb/core/inode.c: creating file '001'
[    7.855988] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.855991] ohci_hcd: block sizes: ed 80 td 96
[    7.856043] uhci_hcd: USB Universal Host Controller Interface driver
[    7.856067] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    7.856075] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    7.856078] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    7.856083] drivers/usb/core/inode.c: creating file '002'
[    7.856145] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    7.856152] uhci_hcd 0000:00:1d.0: detected 2 ports
[    7.856157] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    7.856159] uhci_hcd 0000:00:1d.0: Performing full reset
[    7.856174] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    7.856179] uhci_hcd 0000:00:1d.0: irq 17, io base 0x00001800
[    7.856210] usb usb2: default language 0x0409
[    7.856217] usb usb2: udev 1, busnum 2, minor = 128
[    7.856219] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    7.856221] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.856223] usb usb2: Product: UHCI Host Controller
[    7.856225] usb usb2: Manufacturer: Linux 3.2.15-00012-g7afde96 uhci_hcd
[    7.856227] usb usb2: SerialNumber: 0000:00:1d.0
[    7.856305] usb usb2: usb_probe_device
[    7.856307] usb usb2: configuration #1 chosen from 1 choice
[    7.856313] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    7.856370] hub 2-0:1.0: usb_probe_interface
[    7.856372] hub 2-0:1.0: usb_probe_interface - got id
[    7.856373] hub 2-0:1.0: USB hub found
[    7.856378] hub 2-0:1.0: 2 ports detected
[    7.856379] hub 2-0:1.0: standalone hub
[    7.856381] hub 2-0:1.0: no power switching (usb 1.0)
[    7.856382] hub 2-0:1.0: individual port over-current protection
[    7.856384] hub 2-0:1.0: power on to power good time: 2ms
[    7.856388] hub 2-0:1.0: local power source is good
[    7.856390] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    7.856403] drivers/usb/core/inode.c: creating file '001'
[    7.856436] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    7.856443] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    7.856446] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    7.856451] drivers/usb/core/inode.c: creating file '003'
[    7.856508] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    7.856515] uhci_hcd 0000:00:1d.1: detected 2 ports
[    7.856520] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    7.856522] uhci_hcd 0000:00:1d.1: Performing full reset
[    7.856537] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    7.856551] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001820
[    7.856585] usb usb3: default language 0x0409
[    7.856591] usb usb3: udev 1, busnum 3, minor = 256
[    7.856593] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    7.856595] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.856597] usb usb3: Product: UHCI Host Controller
[    7.856599] usb usb3: Manufacturer: Linux 3.2.15-00012-g7afde96 uhci_hcd
[    7.856601] usb usb3: SerialNumber: 0000:00:1d.1
[    7.856682] usb usb3: usb_probe_device
[    7.856684] usb usb3: configuration #1 chosen from 1 choice
[    7.856690] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    7.856749] hub 3-0:1.0: usb_probe_interface
[    7.856751] hub 3-0:1.0: usb_probe_interface - got id
[    7.856752] hub 3-0:1.0: USB hub found
[    7.856756] hub 3-0:1.0: 2 ports detected
[    7.856758] hub 3-0:1.0: standalone hub
[    7.856759] hub 3-0:1.0: no power switching (usb 1.0)
[    7.856761] hub 3-0:1.0: individual port over-current protection
[    7.856763] hub 3-0:1.0: power on to power good time: 2ms
[    7.856766] hub 3-0:1.0: local power source is good
[    7.856768] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    7.856781] drivers/usb/core/inode.c: creating file '001'
[    7.856813] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    7.856820] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    7.856823] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    7.856830] drivers/usb/core/inode.c: creating file '004'
[    7.856889] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    7.856897] uhci_hcd 0000:00:1d.2: detected 2 ports
[    7.856902] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    7.856903] uhci_hcd 0000:00:1d.2: Performing full reset
[    7.856918] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    7.856923] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
[    7.856954] usb usb4: default language 0x0409
[    7.856960] usb usb4: udev 1, busnum 4, minor = 384
[    7.856962] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    7.856964] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.856967] usb usb4: Product: UHCI Host Controller
[    7.856968] usb usb4: Manufacturer: Linux 3.2.15-00012-g7afde96 uhci_hcd
[    7.856970] usb usb4: SerialNumber: 0000:00:1d.2
[    7.857047] usb usb4: usb_probe_device
[    7.857049] usb usb4: configuration #1 chosen from 1 choice
[    7.857055] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    7.857113] hub 4-0:1.0: usb_probe_interface
[    7.857115] hub 4-0:1.0: usb_probe_interface - got id
[    7.857117] hub 4-0:1.0: USB hub found
[    7.857120] hub 4-0:1.0: 2 ports detected
[    7.857122] hub 4-0:1.0: standalone hub
[    7.857124] hub 4-0:1.0: no power switching (usb 1.0)
[    7.857125] hub 4-0:1.0: individual port over-current protection
[    7.857127] hub 4-0:1.0: power on to power good time: 2ms
[    7.857131] hub 4-0:1.0: local power source is good
[    7.857133] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    7.857146] drivers/usb/core/inode.c: creating file '001'
[    7.857180] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    7.857187] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    7.857190] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    7.857195] drivers/usb/core/inode.c: creating file '005'
[    7.857251] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    7.857259] uhci_hcd 0000:00:1d.3: detected 2 ports
[    7.857263] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
[    7.857265] uhci_hcd 0000:00:1d.3: Performing full reset
[    7.857280] uhci_hcd 0000:00:1d.3: supports USB remote wakeup
[    7.857295] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001860
[    7.857326] usb usb5: default language 0x0409
[    7.857333] usb usb5: udev 1, busnum 5, minor = 512
[    7.857335] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    7.857337] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.857339] usb usb5: Product: UHCI Host Controller
[    7.857341] usb usb5: Manufacturer: Linux 3.2.15-00012-g7afde96 uhci_hcd
[    7.857343] usb usb5: SerialNumber: 0000:00:1d.3
[    7.857417] usb usb5: usb_probe_device
[    7.857420] usb usb5: configuration #1 chosen from 1 choice
[    7.857425] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    7.857483] hub 5-0:1.0: usb_probe_interface
[    7.857485] hub 5-0:1.0: usb_probe_interface - got id
[    7.857487] hub 5-0:1.0: USB hub found
[    7.857491] hub 5-0:1.0: 2 ports detected
[    7.857492] hub 5-0:1.0: standalone hub
[    7.857494] hub 5-0:1.0: no power switching (usb 1.0)
[    7.857496] hub 5-0:1.0: individual port over-current protection
[    7.857497] hub 5-0:1.0: power on to power good time: 2ms
[    7.857501] hub 5-0:1.0: local power source is good
[    7.857503] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    7.857516] drivers/usb/core/inode.c: creating file '001'
[    7.857587] Initializing USB Mass Storage driver...
[    7.857653] usbcore: registered new interface driver usb-storage
[    7.857655] USB Mass Storage support registered.
[    7.857785] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    7.859976] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.859982] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.860129] mousedev: PS/2 mouse device common for all mice
[    7.860319] rtc_cmos 00:04: RTC can wake from S4
[    7.860449] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    7.860479] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    7.860524] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[    7.860653] iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0x1060)
[    7.860669] iTCO_wdt: cannot register miscdev on minor=130 (err=-16)
[    7.860689] iTCO_wdt: probe of iTCO_wdt failed with error -16
[    7.860691] iTCO_vendor_support: vendor-support=0
[    7.860694] SoftDog: cannot register miscdev on minor=130 (err=-16)
[    7.860698] md: linear personality registered for level -1
[    7.860700] md: raid0 personality registered for level 0
[    7.860702] md: raid1 personality registered for level 1
[    7.860704] md: raid10 personality registered for level 10
[    7.860706] md: raid6 personality registered for level 6
[    7.860707] md: raid5 personality registered for level 5
[    7.860709] md: raid4 personality registered for level 4
[    7.860853] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    7.861069] EDAC MC: Ver: 2.1.0
[    7.861537] EDAC MC0: Giving out device to 'i5000_edac.c' 'I5000': DEV 0000:00:10.0
[    7.861619] EDAC PCI0: Giving out device to module 'i5000_edac' controller 'EDAC PCI controller': DEV '0000:00:10.0' (POLLED)
[    7.862338] AMD64 EDAC driver v3.4.0
[    7.862455] cpuidle: using governor ladder
[    7.862458] No iBFT detected.
[    7.863104] usbcore: registered new interface driver usbhid
[    7.863106] usbhid: USB HID core driver
[    7.863340] TCP cubic registered
[    7.863342] Initializing XFRM netlink socket
[    7.863622] NET: Registered protocol family 10
[    7.864081] IPv6 over IPv4 tunneling driver
[    7.864585] NET: Registered protocol family 17
[    7.864617] Bridge firewalling registered
[    7.864621] 8021q: 802.1Q VLAN Support v1.8
[    7.864627] Registering the dns_resolver key type
[    7.864662] registered taskstats version 1
[    7.955676] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001803 0  ACK POWER sig=j CSC CONNECT
[    7.955680] hub 1-0:1.0: port 7: status 0501 change 0001
[    7.955699] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.955699] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.955720] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    7.955728] uhci_hcd 0000:00:1d.3: port 1 portsc 008a,00
[    8.006042] ata5.00: ATAPI: DV-28E-V, 1.AB, max UDMA/33
[    8.045866] ata5.00: configured for UDMA/33
[    8.055640] hub 1-0:1.0: state 7 ports 8 chg 0080 evt 0000
[    8.055640] hub 1-0:1.0: port 7, status 0501, change 0000, 480 Mb/s
[    8.115937] ehci_hcd 0000:00:1d.7: port 7 high speed
[    8.115942] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    8.175753] usb 1-7: new high-speed USB device number 2 using ehci_hcd
[    8.175815] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[    8.175941] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[    8.570347] console [netcon0] enabled
[    8.570361] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[    8.570440] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[    8.570449] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    8.570481] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.570559] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[    8.570682] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[    8.583920] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[    8.583949] netconsole: network logging started
[    8.584050] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[    8.584174] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[    8.588437]  sdb: sdb1 sdb2 < sdb5 sdb6 sdb7 >
[    8.591577]  sdc: sdc1 sdc2 < sdc5 sdc6 sdc7 >
[    8.598126] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[    8.598145]  sdd: sdd1 sdd2 < sdd5 sdd6 sdd7 >
[    8.598186] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[    8.598311] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[    8.598440] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[    8.598718] sd 0:0:2:0: [sdc] Attached SCSI disk
[    8.598722] sd 0:0:1:0: [sdb] Attached SCSI disk
[    8.612593] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[    8.612676] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[    8.612801] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[    8.612926] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[    8.613065] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[    8.613184] sd 0:0:3:0: [sdd] Attached SCSI disk
[    8.613176] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[    8.613302] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[    8.613425] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[    8.618067] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[    8.618184] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[    8.618309] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[    8.618439] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[    8.618559] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[    8.618683] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[    8.618808] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[    8.618937] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[    8.619057] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[    8.619182] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[    8.619307] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    8.619556] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[    8.619681] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[    8.619807] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[    8.619935] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[    8.620055] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[    8.620180] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[    8.620305] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[    8.620434] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[    8.620554] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[    8.620679] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[    8.620804] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[    8.620933] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[    8.621053] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[    8.621178] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[    8.621303] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[    8.621432] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[    8.621552] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[    8.621677] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[    8.621802] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[    8.621931] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[    8.622051] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[    8.622176] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[    8.622301] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[    8.622430] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[    8.622550] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[    8.622675] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[    8.622799] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[    8.622929] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[    8.623049] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[    8.623174] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[    8.623299] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[    8.623429] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    8.623673] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[    8.623798] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[    8.623928] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[    8.624048] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[    8.624172] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[    8.624297] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[    8.624426] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[    8.624546] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[    8.624671] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[    8.624796] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[    8.624925] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[    8.625046] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[    8.625170] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[    8.625295] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[    8.625424] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[    8.625544] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[    8.625670] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[    8.625814] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[    8.625938] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[    8.626064] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 1
[    8.626188] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 2
[    8.626313] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 3
[    8.626437] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 4
[    8.626562] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 5
[    8.626687] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 6
[    8.626811] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 7
[    8.626936] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 8
[    8.627060] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 9
[    8.627186] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 10
[    8.627311] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 11
[    8.627435] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 12
[    8.627560] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 13
[    8.627685] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 14
[    8.627809] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 15
[    8.627934] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 16
[    8.628059] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 17
[    8.628184] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 18
[    8.632919]  sda: sda1 sda2 < sda5 sda6 sda7 >
[    8.638227] sd 0:0:0:0: [sda] Attached SCSI disk
[    8.649825] scsi 1:0:0:0: CD-ROM            TEAC     DV-28E-V         1.AB PQ: 0 ANSI: 5
[    8.669652] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[    8.676094] cdrom: Uniform CD-ROM driver Revision: 3.20
[    8.681715] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    8.681868] sr 1:0:0:0: Attached scsi generic sg4 type 5
[    8.687682] ehci_hcd 0000:00:1d.7: port 7 high speed
[    8.687688] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    8.687751] md: Waiting for all devices to be available before autodetect
[    8.694782] md: If you don't use raid, use raid=noautodetect
[    8.700895] md: Autodetecting RAID arrays.
[    8.745670] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[    8.745815] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[    8.745939] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[    8.746064] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[    8.746188] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[    8.746313] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[    8.746437] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[    8.746562] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[    8.746686] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[    8.746812] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[    8.746936] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[    8.747061] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[    8.747186] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[    8.747311] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[    8.747435] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[    8.747560] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[    8.747685] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[    8.747810] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[    8.747934] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[    8.748059] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[    8.748184] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[    8.748308] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[    8.748433] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[    8.748558] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[    8.748683] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[    8.748808] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[    8.748933] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 3
[    8.749057] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 4
[    8.749182] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 5
[    8.749306] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 6
[    8.749431] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 7
[    8.775814] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[    8.775939] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[    8.776064] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[    8.776189] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[    8.776313] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[    8.776437] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[    8.776562] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[    8.776687] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[    8.776812] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 1
[    8.776936] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 2
[    8.777061] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 3
[    8.777186] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 4
[    8.777311] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 5
[    8.777560] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[    8.777685] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[    8.777809] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[    8.777935] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[    8.778059] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[    8.778184] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[    8.778309] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[    8.778433] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[    8.778558] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[    8.778682] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[    8.778808] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[    8.778933] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[    8.779057] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[    8.779182] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[    8.779307] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[    8.779431] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[    8.779556] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[    8.779681] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[    8.779806] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[    8.779931] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[    8.780055] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[    8.780180] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[    8.780304] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[    8.780429] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[    8.780555] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[    8.780679] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[    8.780804] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[    8.780929] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[    8.781053] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[    8.781178] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[    8.781303] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[    8.781428] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    8.781677] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[    8.781802] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[    8.781928] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[    8.782052] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[    8.782176] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[    8.782301] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[    8.782426] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[    8.782551] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[    8.782675] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[    8.782800] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[    8.782924] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[    8.783050] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[    8.783174] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[    8.783299] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[    8.783424] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[    8.783549] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[    8.783673] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[    8.783798] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[    8.783923] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[    8.784048] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[    8.784172] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[    8.784297] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[    8.784422] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[    8.784546] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[    8.784671] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[    8.784796] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[    8.784921] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[    8.785046] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[    8.785171] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[    8.785295] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[    8.785420] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[    8.785545] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    8.785814] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[    8.785938] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[    8.786064] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[    8.786187] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[    8.786312] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[    8.786438] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[    8.786562] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[    8.786687] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[    8.786812] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[    8.786936] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[    8.787061] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[    8.787185] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[    8.787311] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[    8.787436] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[    8.787560] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[    8.787685] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[    8.787810] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[    8.787934] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[    8.788060] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[    8.788183] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[    8.788309] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[    8.788434] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[    8.788558] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[    8.788683] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[    8.788808] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[    8.788933] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[    8.789057] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[    8.789182] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[    8.789307] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[    8.789432] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[    8.789556] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[    8.789681] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    8.789694] usb 1-7: unable to read config index 0 descriptor/start: -71
[    8.796656] usb 1-7: chopping to 0 config(s)
[    8.801305] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[    8.801428] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[    8.801553] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[    8.801679] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 1
[    8.801804] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 2
[    8.801927] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 3
[    8.802052] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 4
[    8.802185] usb 1-7: default language 0x0409
[    8.802303] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[    8.802426] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[    8.802550] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[    8.802676] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[    8.802802] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[    8.802925] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[    8.803050] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[    8.803174] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[    8.803301] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[    8.803424] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[    8.803548] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[    8.803673] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[    8.803800] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[    8.803923] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[    8.804048] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[    8.804172] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[    8.804299] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[    8.804422] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[    8.804546] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[    8.804671] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[    8.804798] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[    8.804921] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[    8.805046] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[    8.805170] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[    8.805297] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[    8.805420] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[    8.805545] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[    8.805689] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[    8.805813] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[    8.805938] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[    8.806064] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[    8.806187] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    8.806437] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[    8.806562] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[    8.806687] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[    8.806811] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[    8.806936] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[    8.807061] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[    8.807186] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[    8.807311] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[    8.807435] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[    8.807560] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[    8.807685] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[    8.807809] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[    8.807934] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[    8.808060] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[    8.808184] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[    8.808309] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[    8.808433] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[    8.808559] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[    8.808683] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[    8.808807] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[    8.808933] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[    8.809057] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[    8.809182] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[    8.809307] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[    8.809431] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[    8.809556] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[    8.809681] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[    8.809806] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[    8.809931] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[    8.810055] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[    8.810180] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[    8.810305] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    8.810554] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[    8.810679] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[    8.810805] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[    8.810929] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[    8.811053] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[    8.811178] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[    8.811303] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[    8.811428] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[    8.811552] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[    8.811677] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[    8.811802] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[    8.811927] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[    8.812051] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[    8.812176] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[    8.812301] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[    8.812426] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[    8.812551] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[    8.812675] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[    8.812800] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[    8.812925] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[    8.813049] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[    8.813174] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[    8.813299] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[    8.813424] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[    8.813549] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[    8.813673] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[    8.813798] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[    8.813923] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[    8.814047] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[    8.814173] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[    8.814297] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[    8.814422] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    8.814671] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[    8.814796] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[    8.814921] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[    8.815045] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[    8.815171] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[    8.815295] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[    8.815420] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[    8.815545] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[    8.815643] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[    8.815669] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[    8.815814] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[    8.815938] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[    8.816063] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[    8.816188] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[    8.816312] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[    8.816437] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[    8.816561] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[    8.816687] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[    8.816812] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[    8.816936] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[    8.817061] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[    8.817186] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[    8.817310] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[    8.817436] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[    8.817560] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[    8.817685] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[    8.817810] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[    8.817934] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[    8.818059] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[    8.818184] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[    8.818308] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[    8.818434] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    8.818683] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[    8.818808] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[    8.818933] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[    8.819057] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[    8.819182] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[    8.819307] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[    8.819432] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[    8.819556] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 1
[    8.819681] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 2
[    8.819806] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 3
[    8.819930] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 4
[    8.820055] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 5
[    8.820180] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 6
[    8.820305] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 7
[    8.820430] ehci_hcd 0000:00:1d.7: detected XactErr len 64/255 retry 8
[    8.820554] ehci_hcd 0000:00:1d.7: detected XactErr len 64/255 retry 9
[    8.820688] usb 1-7: udev 2, busnum 1, minor = 1
[    8.820690] usb 1-7: New USB device found, idVendor=14dd, idProduct=0002
[    8.827657] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    8.835040] usb 1-7: SerialNumber: 0083c601aa48d2d18A62C7F7C61EBFAA
[    8.841675] usb 1-7: usb_probe_device
[    8.841679] usb 1-7: no configuration chosen from 0 choices
[    8.847507] drivers/usb/core/inode.c: creating file '002'
[    8.847526] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.856189] md: Scanned 16 and added 16 devices.
[    8.861044] md: autorun ...
[    8.864081] md: considering sda7 ...
[    8.867929] md:  adding sda7 ...
[    8.871398] md: sda6 has different UUID to sda7
[    8.876193] md: sda5 has different UUID to sda7
[    8.880964] md: sda1 has different UUID to sda7
[    8.885750] md: sdd7 has different UUID to sda7
[    8.890524] md: sdd6 has different UUID to sda7
[    8.895297] md: sdd5 has different UUID to sda7
[    8.900102] md: sdd1 has different UUID to sda7
[    8.904876] md: sdc7 has different UUID to sda7
[    8.909671] md: sdc6 has different UUID to sda7
[    8.914443] md: sdc5 has different UUID to sda7
[    8.919229] md: sdc1 has different UUID to sda7
[    8.924004] md:  adding sdb7 ...
[    8.927499] md: sdb6 has different UUID to sda7
[    8.932271] md: sdb5 has different UUID to sda7
[    8.937065] md: sdb1 has different UUID to sda7
[    8.942028] md: created md21
[    8.945151] md: bind<sdb7>
[    8.948136] md: bind<sda7>
[    8.951095] md: running: <sda7><sdb7>
[    8.955256] bio: create slab <bio-1> at 1
[    8.959608] md/raid1:md21: active with 2 out of 2 mirrors
[    8.965264] md21: detected capacity change from 0 to 1987186393088
[    8.971753] md: considering sda6 ...
[    8.975572] md:  adding sda6 ...
[    8.979066] md: sda5 has different UUID to sda6
[    8.983838] md: sda1 has different UUID to sda6
[    8.988636] md: sdd7 has different UUID to sda6
[    8.993407] md:  adding sdd6 ...
[    8.996902] md: sdd5 has different UUID to sda6
[    9.001672] md: sdd1 has different UUID to sda6
[    9.006468] md: sdc7 has different UUID to sda6
[    9.011243] md:  adding sdc6 ...
[    9.014717] md: sdc5 has different UUID to sda6
[    9.019520] md: sdc1 has different UUID to sda6
[    9.024294] md:  adding sdb6 ...
[    9.027781] md: sdb5 has different UUID to sda6
[    9.032553] md: sdb1 has different UUID to sda6
[    9.037519] md: created md11
[    9.040648] md: bind<sdb6>
[    9.043607] md: bind<sdc6>
[    9.046591] md: bind<sdd6>
[    9.049550] md: bind<sda6>
[    9.052506] md: running: <sda6><sdd6><sdc6><sdb6>
[    9.057918] md/raid1:md11: active with 4 out of 4 mirrors
[    9.063575] md11: detected capacity change from 0 to 12584550400
[    9.069893] md: considering sda5 ...
[    9.073712] md:  adding sda5 ...
[    9.075657] usb usb2: suspend_rh (auto-stop)
[    9.075681] usb usb3: suspend_rh (auto-stop)
[    9.075703] usb usb4: suspend_rh (auto-stop)
[    9.075725] usb usb5: suspend_rh (auto-stop)
[    9.077208] md: sda1 has different UUID to sda5
[    9.081980] md: sdd7 has different UUID to sda5
[    9.086777] md: sdd5 has different UUID to sda5
[    9.091547] md: sdd1 has different UUID to sda5
[    9.096342] md: sdc7 has different UUID to sda5
[    9.101115] md: sdc5 has different UUID to sda5
[    9.105910] md: sdc1 has different UUID to sda5
[    9.110685] md:  adding sdb5 ...
[    9.114160] md: sdb1 has different UUID to sda5
[    9.119133] md: created md15
[    9.122255] md: bind<sdb5>
[    9.125212] md: bind<sda5>
[    9.128193] md: running: <sda5><sdb5>
[    9.132416] md/raid1:md15: active with 2 out of 2 mirrors
[    9.138098] md15: detected capacity change from 0 to 518062080
[    9.144208] md: considering sda1 ...
[    9.148051] md:  adding sda1 ...
[    9.151522] md: sdd7 has different UUID to sda1
[    9.156317] md: sdd5 has different UUID to sda1
[    9.161090] md:  adding sdd1 ...
[    9.164557] md: sdc7 has different UUID to sda1
[    9.169359] md: sdc5 has different UUID to sda1
[    9.174131] md:  adding sdc1 ...
[    9.177620] md:  adding sdb1 ...
[    9.181261] md: created md10
[    9.184388] md: bind<sdb1>
[    9.187371] md: bind<sdc1>
[    9.190331] md: bind<sdd1>
[    9.193289] md: bind<sda1>
[    9.196271] md: running: <sda1><sdd1><sdc1><sdb1>
[    9.201662] md/raid1:md10: active with 4 out of 4 mirrors
[    9.207346] md10: detected capacity change from 0 to 106823680
[    9.213454] md: considering sdd7 ...
[    9.217298] md:  adding sdd7 ...
[    9.220769] md: sdd5 has different UUID to sdd7
[    9.225545] md:  adding sdc7 ...
[    9.229048] md: sdc5 has different UUID to sdd7
[    9.233986] md: created md22
[    9.237134] md: bind<sdc7>
[    9.240095] md: bind<sdd7>
[    9.243055] md: running: <sdd7><sdc7>
[    9.247294] md/raid1:md22: active with 2 out of 2 mirrors
[    9.252948] md22: detected capacity change from 0 to 986992345088
[    9.265462] md: considering sdd5 ...
[    9.269296] md:  adding sdd5 ...
[    9.272770] md:  adding sdc5 ...
[    9.276434] md: created md14
[    9.279564] md: bind<sdc5>
[    9.282520] md: bind<sdd5>
[    9.285478] md: running: <sdd5><sdc5>
[    9.289734] md/raid1:md14: active with 2 out of 2 mirrors
[    9.295389] md14: detected capacity change from 0 to 518062080
[    9.301533] md: ... autorun DONE.
[    9.305549]  md11: unknown partition table
[    9.330471] kjournald starting.  Commit interval 5 seconds
[    9.330491] EXT3-fs (md11): mounted filesystem with writeback data mode
[    9.330501] VFS: Mounted root (ext3 filesystem) readonly on device 9:11.
[    9.351958] Freeing unused kernel memory: 860k freed
[    9.357379] Write protecting the kernel read-only data: 10240k
[    9.367449] Freeing unused kernel memory: 948k freed
[    9.379759] Freeing unused kernel memory: 1696k freed
[    9.681057] modprobe used greatest stack depth: 4648 bytes left
[    9.917347] sed used greatest stack depth: 4328 bytes left
[   10.057634] mount used greatest stack depth: 3016 bytes left
[   10.277172] udevd (1198): /proc/1198/oom_adj is deprecated, please use /proc/1198/oom_score_adj instead.
[   10.407962] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[   10.414254] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[   10.420563] e1000e 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   10.427842] e1000e 0000:04:00.0: setting latency timer to 64
[   10.427936] e1000e 0000:04:00.0: (unregistered net_device): CRC Stripping Disabled
[   10.436009] e1000e 0000:04:00.0: irq 64 for MSI/MSI-X
[   10.561380] e1000e 0000:04:00.0: eth0: (PCI Express:2.5GT/s:Width x4) 00:30:48:d5:5a:4a
[   10.569891] e1000e 0000:04:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   10.577208] e1000e 0000:04:00.0: eth0: MAC: 5, PHY: 5, PBA No: 2050FF-0FF
[   10.584263] e1000e 0000:04:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   10.591500] e1000e 0000:04:00.1: setting latency timer to 64
[   10.591591] e1000e 0000:04:00.1: (unregistered net_device): CRC Stripping Disabled
[   10.599652] e1000e 0000:04:00.1: irq 65 for MSI/MSI-X
[   10.722826] e1000e 0000:04:00.1: eth1: (PCI Express:2.5GT/s:Width x4) 00:30:48:d5:5a:4b
[   10.731304] e1000e 0000:04:00.1: eth1: Intel(R) PRO/1000 Network Connection
[   10.738597] e1000e 0000:04:00.1: eth1: MAC: 5, PHY: 5, PBA No: 2050FF-0FF
[   11.101506]  md14: unknown partition table
[   11.106296] Adding 505916k swap on /dev/md14.  Priority:-1 extents:1 across:505916k 
[   11.115108]  md15: unknown partition table
[   11.119810] Adding 505916k swap on /dev/md15.  Priority:-2 extents:1 across:505916k 
[   11.240538] EXT3-fs (md11): using internal journal
[   12.523879]  md10: unknown partition table
[   12.586781]  md21: unknown partition table
[   12.593994]  md22: unknown partition table
[   13.789859] XFS (dm-10): Mounting Filesystem
[   13.891332] XFS (dm-10): Starting recovery (logdev: internal)
[   14.306110] XFS (dm-10): Ending recovery (logdev: internal)
[   14.743866] ip_tables: (C) 2000-2006 Netfilter Core Team
[   14.757296] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   15.646563] ipt_account 0.1.21 : Piotr Gasidlo <quaker@barbara.eu.org>, http://www.barbara.eu.org/~quaker/ipt_account/
[   16.396053] e1000e 0000:04:00.0: irq 64 for MSI/MSI-X
[   16.455887] e1000e 0000:04:00.0: irq 64 for MSI/MSI-X
[   16.458283] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   16.464042] 8021q: adding VLAN 0 to HW filter on device eth0
[   16.556023] e1000e 0000:04:00.1: irq 65 for MSI/MSI-X
[   16.615893] e1000e 0000:04:00.1: irq 65 for MSI/MSI-X
[   16.618278] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   16.623837] 8021q: adding VLAN 0 to HW filter on device eth1
[   16.700803] ADDRCONF(NETDEV_UP): eth0.20: link is not ready
[   19.138231] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   19.153801] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   19.162057] ADDRCONF(NETDEV_CHANGE): eth0.20: link becomes ready
[   29.245973] eth0: no IPv6 routers present
[   30.145986] eth0.20: no IPv6 routers present

* attached an ISO image (visible as one of two virtual CD-ROM drives) *

[  147.139215] hub 1-0:1.0: state 7 ports 8 chg 0000 evt ff80
[  147.139231] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001002 0  ACK POWER sig=se0 CSC
[  147.139242] hub 1-0:1.0: port 7, status 0100, change 0001, 12 Mb/s
[  147.139246] usb 1-7: USB disconnect, device number 2
[  147.144682] usb 1-7: unregistering device
[  147.144685] usb 1-7: usb_disable_device nuking all URBs
[  147.182928] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001803 0  ACK POWER sig=j CSC CONNECT
[  147.342849] hub 1-0:1.0: debounce: port 7: total 125ms stable 100ms status 0x501
[  147.403056] ehci_hcd 0000:00:1d.7: port 7 high speed
[  147.403061] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  147.462792] usb 1-7: new high-speed USB device number 3 using ehci_hcd
[  147.469643] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  147.469767] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  147.469897] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 1
[  147.470016] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 2
[  147.470142] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 3
[  147.470265] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 4
[  147.470390] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 5
[  147.522997] ehci_hcd 0000:00:1d.7: port 7 high speed
[  147.523002] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  147.582845] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  147.582970] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  147.583095] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  147.583219] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  147.583343] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  147.583468] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  147.583593] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  147.583717] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  147.583842] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  147.583967] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  147.584091] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  147.584216] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  147.584341] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  147.584466] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  147.584591] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  147.584715] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  147.584840] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  147.584965] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  147.585089] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  147.585214] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  147.585339] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  147.585464] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  147.585589] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  147.585713] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  147.585838] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  147.585963] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  147.586088] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  147.586212] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  147.586337] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  147.586462] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  147.586587] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  147.586711] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[  147.792739] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  147.792866] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  147.792990] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  147.793114] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  147.793238] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  147.793363] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  147.793488] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  147.793612] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  147.793737] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  147.793862] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  147.793986] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  147.794111] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  147.794236] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  147.794361] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  147.794486] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  147.794610] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  147.794735] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  147.794860] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  147.794984] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  147.795109] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  147.795234] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  147.795359] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  147.795484] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  147.795608] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  147.795733] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  147.795858] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  147.795983] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  147.796108] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  147.796232] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  147.796357] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  147.796482] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  147.796606] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[  148.002525] usb 1-7: device not accepting address 3, error -71
[  148.062727] ehci_hcd 0000:00:1d.7: port 7 high speed
[  148.062732] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  148.122472] usb 1-7: new high-speed USB device number 4 using ehci_hcd
[  148.129313] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.129438] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.129562] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.129687] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.129811] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.129935] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.130061] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 1
[  148.130184] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 2
[  148.130309] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 3
[  148.130434] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 4
[  148.130559] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 5
[  148.130684] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 6
[  148.130808] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 7
[  148.130933] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 8
[  148.131058] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 9
[  148.131182] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 10
[  148.131307] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 11
[  148.131432] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 12
[  148.131557] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 13
[  148.131682] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 14
[  148.131806] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 15
[  148.131931] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 16
[  148.132056] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  148.182667] ehci_hcd 0000:00:1d.7: port 7 high speed
[  148.182672] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  148.242515] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.242641] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.242765] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.242890] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.243013] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.243138] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.243263] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  148.243388] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  148.243512] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 3
[  148.243637] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 4
[  148.243761] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 5
[  148.243886] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 6
[  148.244011] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 7
[  148.272499] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.272625] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.272750] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.272875] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.272998] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.273123] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.273248] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  148.273373] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  148.273497] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  148.273622] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  148.273747] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  148.273871] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  148.273996] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  148.274121] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  148.274246] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  148.274371] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  148.274495] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  148.274620] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  148.274745] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  148.274870] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  148.274994] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  148.275119] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  148.275244] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  148.275369] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  148.275493] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  148.275618] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  148.275742] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  148.275868] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  148.275993] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  148.276117] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  148.276242] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  148.276367] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  148.276616] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.276742] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.276866] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.276992] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.277115] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.277240] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.277365] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  148.277490] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  148.277614] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  148.277739] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 1
[  148.277989] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 2
[  148.278114] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 3
[  148.278238] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 4
[  148.278363] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 5
[  148.278613] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.278738] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.278863] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.278988] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.279111] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.279237] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.279361] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  148.279486] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  148.279611] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  148.279735] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  148.279861] ehci_hcd 0000:00:1d.7: detected XactErr len 0/9 retry 1
[  148.279984] ehci_hcd 0000:00:1d.7: detected XactErr len 0/9 retry 2
[  148.280236] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.280359] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.280485] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.280610] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.280733] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.280858] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.280983] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  148.281108] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  148.281233] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  148.281357] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  148.281482] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  148.281607] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  148.281731] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  148.281856] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  148.281981] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  148.282106] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  148.282231] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  148.282369] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  148.282495] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  148.282620] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  148.282744] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  148.282869] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  148.282993] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  148.283119] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  148.283243] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  148.283367] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  148.283492] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  148.283618] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  148.283742] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  148.283867] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  148.283991] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  148.284117] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  148.284366] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.284492] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.284616] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.284741] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.284865] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.284989] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.285116] ehci_hcd 0000:00:1d.7: detected XactErr len 0/105 retry 1
[  148.285239] ehci_hcd 0000:00:1d.7: detected XactErr len 0/105 retry 2
[  148.285364] ehci_hcd 0000:00:1d.7: detected XactErr len 0/105 retry 3
[  148.285501] usb 1-7: skipped 1 descriptor after interface
[  148.285504] usb 1-7: skipped 1 descriptor after interface
[  148.285614] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.285738] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 1
[  148.285864] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 2
[  148.285989] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 3
[  148.286121] usb 1-7: default language 0x0409
[  148.286237] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.286363] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.286489] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 1
[  148.286613] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 2
[  148.286736] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 3
[  148.286861] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 4
[  148.287112] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 1
[  148.287236] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 2
[  148.287361] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 3
[  148.287486] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  148.287609] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  148.287734] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 3
[  148.287984] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.288110] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.288233] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.288359] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.288482] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.288607] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.288732] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  148.288857] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  148.288982] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  148.289107] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  148.289231] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 1
[  148.289356] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 2
[  148.289481] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 3
[  148.289606] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 4
[  148.289730] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 5
[  148.289855] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  148.289980] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  148.290104] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 3
[  148.290239] usb 1-7: udev 4, busnum 1, minor = 3
[  148.290242] usb 1-7: New USB device found, idVendor=14dd, idProduct=0002
[  148.297212] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  148.304619] usb 1-7: Product: Multidevice
[  148.308868] usb 1-7: Manufacturer: Peppercon AG
[  148.313652] usb 1-7: SerialNumber: 0083c601aa48d2d18A62C7F7C61EBFAA
[  148.320203] usb 1-7: usb_probe_device
[  148.320207] usb 1-7: configuration #1 chosen from 1 choice
[  148.320340] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  148.320465] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  148.320592] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 3
[  148.320715] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 4
[  148.320839] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 5
[  148.320965] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 6
[  148.321214] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 7
[  148.321337] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 8
[  148.321588] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 9
[  148.321712] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 10
[  148.321838] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 11
[  148.321961] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 12
[  148.322086] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 13
[  148.322210] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 14
[  148.322371] usb 1-7: adding 1-7:1.0 (config #1, interface 0)
[  148.322407] usb-storage 1-7:1.0: usb_probe_interface
[  148.322413] usb-storage 1-7:1.0: usb_probe_interface - got id
[  148.322754] scsi3 : usb-storage 1-7:1.0
[  148.326912] usb 1-7: adding 1-7:1.1 (config #1, interface 1)
[  148.326939] usb-storage 1-7:1.1: usb_probe_interface
[  148.326944] usb-storage 1-7:1.1: usb_probe_interface - got id
[  148.327000] scsi4 : usb-storage 1-7:1.1
[  148.331137] usb 1-7: adding 1-7:1.2 (config #1, interface 2)
[  148.331164] usbhid 1-7:1.2: usb_probe_interface
[  148.331167] usbhid 1-7:1.2: usb_probe_interface - got id
[  148.331208] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.331335] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.331458] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.331584] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.331708] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 1
[  148.331833] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 2
[  148.331957] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 3
[  148.332083] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 4
[  148.332207] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 5
[  148.332346] ehci_hcd 0000:00:1d.7: detected XactErr len 64/255 retry 6
[  148.332471] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  148.332720] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.332845] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.332969] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.333095] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.333219] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.333344] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.333468] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  148.333592] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  148.333717] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  148.333842] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  148.333966] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  148.334092] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  148.334216] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  148.334467] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.334591] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.334716] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.334840] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.334966] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.335090] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.335214] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  148.335340] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  148.335465] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  148.335590] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  148.335713] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  148.335839] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  148.335963] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  148.336088] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  148.336212] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  148.336338] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  148.336461] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  148.336586] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  148.336711] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  148.336836] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  148.336961] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  148.337086] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  148.337210] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  148.337336] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  148.337459] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  148.337585] ehci_hcd 0000:00:1d.7: detected XactErr len 0/79 retry 1
[  148.337709] ehci_hcd 0000:00:1d.7: detected XactErr len 0/79 retry 2
[  148.337835] ehci_hcd 0000:00:1d.7: detected XactErr len 0/79 retry 3
[  148.337959] ehci_hcd 0000:00:1d.7: detected XactErr len 0/79 retry 4
[  148.338085] ehci_hcd 0000:00:1d.7: detected XactErr len 0/79 retry 5
[  148.338208] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  148.338334] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  148.338709] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.338833] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.338958] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.339083] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 1
[  148.339206] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 2
[  148.339398] input: Peppercon AG Multidevice as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7:1.2/input/input2
[  148.349897] generic-usb 0003:14DD:0002.0001: input,hidraw0: USB HID v1.01 Mouse [Peppercon AG Multidevice] on usb-0000:00:1d.7-7/input2
[  148.362551] usb 1-7: adding 1-7:1.3 (config #1, interface 3)
[  148.362586] usbhid 1-7:1.3: usb_probe_interface
[  148.362588] usbhid 1-7:1.3: usb_probe_interface - got id
[  148.362706] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.362830] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.362955] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.363078] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.363205] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.363329] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.363454] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  148.363577] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  148.363703] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  148.363827] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  148.363952] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  148.364076] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  148.364203] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  148.364326] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  148.364451] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  148.364575] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  148.364700] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  148.364825] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  148.364949] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  148.365074] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  148.365199] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  148.365324] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  148.365449] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  148.365573] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  148.365700] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  148.365823] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  148.365949] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  148.366072] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  148.366198] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  148.366322] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  148.366447] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  148.366571] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  148.366822] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.366947] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.367071] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.367196] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.367320] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.367445] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.367569] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  148.367694] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  148.367819] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  148.367944] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  148.368069] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  148.368193] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  148.368318] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  148.368443] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  148.368567] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  148.368692] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  148.368817] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  148.368942] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  148.369067] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  148.369191] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  148.369316] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  148.369441] ehci_hcd 0000:00:1d.7: detected XactErr len 0/2 retry 1
[  148.369565] ehci_hcd 0000:00:1d.7: detected XactErr len 0/2 retry 2
[  148.369691] ehci_hcd 0000:00:1d.7: detected XactErr len 0/2 retry 3
[  148.369815] ehci_hcd 0000:00:1d.7: detected XactErr len 0/2 retry 4
[  148.369940] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  148.370191] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.370315] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.370439] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.370565] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.370689] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.370813] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.370938] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  148.371062] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  148.371187] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  148.371313] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  148.371437] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  148.371562] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  148.371687] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  148.371811] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  148.371936] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  148.372060] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  148.372185] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  148.372311] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  148.372449] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  148.372574] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  148.372699] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  148.372824] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  148.372950] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  148.373073] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  148.373198] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  148.373323] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  148.373448] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  148.373572] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  148.373697] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  148.373822] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  148.373947] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  148.374071] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  148.374322] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.374447] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.374571] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  148.374696] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  148.374945] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.375070] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.375195] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.375321] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.375443] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.375569] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.375694] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  148.375819] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  148.375943] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  148.376067] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  148.376193] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  148.376318] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  148.376442] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  148.376567] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  148.376691] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  148.376816] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  148.376940] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  148.377066] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  148.377190] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  148.377316] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  148.377440] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  148.377564] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  148.377689] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  148.377814] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  148.377940] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  148.378063] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  148.378188] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  148.378313] ehci_hcd 0000:00:1d.7: detected XactErr len 0/66 retry 1
[  148.378438] ehci_hcd 0000:00:1d.7: detected XactErr len 0/66 retry 2
[  148.378563] ehci_hcd 0000:00:1d.7: detected XactErr len 0/66 retry 3
[  148.378937] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.378944] input: Peppercon AG Multidevice as /devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7:1.3/input/input3
[  148.379063] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.379189] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.379313] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.389332] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.389360] usb 1-7: link qh1-0001/ffff8804124ce200 start 0 [2/0 us]
[  148.389422] generic-usb 0003:14DD:0002.0002: input,hidraw1: USB HID v1.01 Keyboard [Peppercon AG Multidevice] on usb-0000:00:1d.7-7/input3
[  148.389434] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.389558] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  148.389684] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  148.392211] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  148.402324] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  148.402329] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.402359] drivers/usb/core/inode.c: creating file '004'
[  148.402386] hub 1-0:1.0: state 7 ports 8 chg 0000 evt fe80
[  148.402437] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  148.402560] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  148.402686] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  148.402810] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  148.402935] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  148.403060] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  148.403184] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  148.403310] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  148.403434] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  148.403559] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  148.403683] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  148.403807] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  148.403935] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  148.404058] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  148.404183] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  148.404306] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  148.404432] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  148.404558] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  148.404682] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  148.404809] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  148.404932] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  148.405056] ehci_hcd 0000:00:1d.7: detected XactErr len 0/1 retry 1
[  148.405181] ehci_hcd 0000:00:1d.7: detected XactErr len 0/1 retry 2
[  148.405306] ehci_hcd 0000:00:1d.7: detected XactErr len 0/1 retry 3
[  148.407677] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.410672] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.415677] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.418671] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.422678] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.430660] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  148.435666] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  148.438660] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  148.443664] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  148.448655] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  148.451649] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  148.456652] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  148.461643] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  148.468645] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  148.474647] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  148.481633] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  148.487636] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  148.493639] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  148.500626] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  148.507626] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  148.512631] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  148.515626] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  148.519617] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  148.527616] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  148.533619] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  148.540605] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  148.546608] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  148.553608] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  148.558600] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  148.566598] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  148.571589] ehci_hcd 0000:00:1d.7: devpath 7 ep6in 3strikes
[  148.571609] usb 1-7: unlink qh1-0001/ffff8804124ce200 start 0 [2/0 us]
[  148.582257] ehci_hcd 0000:00:1d.7: reused qh ffff8804124ce200 schedule
[  148.582261] usb 1-7: link qh1-0001/ffff8804124ce200 start 0 [2/0 us]
[  148.587586] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.594587] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.600575] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.603584] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.607575] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.614577] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.621563] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  148.627567] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  148.633569] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  148.638559] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  148.644561] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  148.649552] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  148.656553] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  148.662556] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  148.669542] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  148.674548] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  148.680535] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  148.683543] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  148.686538] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  148.691528] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  148.697531] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  148.703534] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  148.708524] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  148.711519] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  148.716523] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  148.721513] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  148.724522] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  148.728514] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  148.734517] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  148.741504] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  148.747506] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  148.750500] ehci_hcd 0000:00:1d.7: devpath 7 ep6in 3strikes
[  148.750514] usb 1-7: unlink qh1-0001/ffff8804124ce200 start 0 [2/0 us]
[  148.772163] ehci_hcd 0000:00:1d.7: reused qh ffff8804124ce200 schedule
[  148.772167] usb 1-7: link qh1-0001/ffff8804124ce200 start 0 [2/0 us]
[  148.774498] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  148.782496] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  148.788485] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  148.795484] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  148.801473] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  148.806479] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  148.809473] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  148.813478] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  148.819468] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  148.826467] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  148.832471] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  148.839457] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  148.845460] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  148.852461] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  148.857452] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  148.863454] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  148.866449] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  148.870441] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  148.876442] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  148.879438] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  148.883443] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  148.896432] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  148.902436] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  148.910420] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  148.916424] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  148.922426] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  148.927416] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  148.941404] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  148.948404] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  148.954408] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  148.960396] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  148.965401] ehci_hcd 0000:00:1d.7: devpath 7 ep6in 3strikes
[  148.965415] usb 1-7: unlink qh1-0001/ffff8804124ce200 start 0 [2/0 us]
[  149.022041] ehci_hcd 0000:00:1d.7: reused qh ffff8804124ce200 schedule
[  149.022045] usb 1-7: link qh1-0001/ffff8804124ce200 start 0 [2/0 us]
[  149.026369] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  149.031359] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  149.038360] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  149.044362] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  149.051349] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  149.057352] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  149.064353] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  149.069342] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  149.076343] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  149.079338] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  149.082346] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  149.088335] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  149.093339] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  149.101324] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  149.106328] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  149.109322] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  149.114328] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  149.119318] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  149.125320] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  149.128315] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  149.132321] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  149.138309] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  149.143314] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  149.146309] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  149.150301] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  149.156303] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  149.161294] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  149.164302] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  149.167297] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  149.174297] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  149.179288] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  149.182296] ehci_hcd 0000:00:1d.7: devpath 7 ep6in 3strikes
[  149.182319] usb 1-7: unlink qh1-0001/ffff8804124ce200 start 0 [2/0 us]
[  149.291863] ehci_hcd 0000:00:1d.7: reused qh ffff8804124ce200 schedule
[  149.291867] usb 1-7: link qh1-0001/ffff8804124ce200 start 0 [2/0 us]
[  149.295235] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  149.301224] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  149.306229] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  149.313229] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  149.319218] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  149.321977] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  149.322100] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  149.322105] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  149.322226] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  149.322349] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  149.322475] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  149.322599] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  149.322723] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  149.322848] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  149.322973] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  149.323097] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  149.323223] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  149.323347] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  149.323472] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  149.323597] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  149.323721] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  149.323846] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  149.323971] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  149.324096] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  149.324221] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  149.324345] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  149.324470] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  149.324595] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  149.324719] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  149.324844] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  149.324969] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  149.325094] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  149.325219] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  149.325343] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  149.325468] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  149.325592] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  149.325717] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  149.325842] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  149.326093] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  149.326097] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 1
[  149.326218] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  149.326221] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 2
[  149.326342] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  149.326345] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 3
[  149.326467] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  149.326470] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 4
[  149.326591] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  149.326594] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 5
[  149.326715] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  149.326718] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 6
[  149.326841] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  149.326844] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 7
[  149.326965] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  149.326968] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 8
[  149.327090] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  149.327093] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 9
[  149.327097] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  149.327214] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  149.327217] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 10
[  149.327340] ehci_hcd 0000:00:1d.7: detected XactErr len 0/1 retry 1
[  149.327343] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 11
[  149.327464] ehci_hcd 0000:00:1d.7: detected XactErr len 0/1 retry 2
[  149.327467] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 12
[  149.327589] ehci_hcd 0000:00:1d.7: detected XactErr len 0/1 retry 3
[  149.327592] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 13
[  149.327714] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 14
[  149.327839] ehci_hcd 0000:00:1d.7: detected XactErr len 0/1 retry 4
[  149.327842] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 15
[  149.327970] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 16
[  149.328089] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 1
[  149.328093] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 17
[  149.328213] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 2
[  149.328216] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 18
[  149.328339] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 3
[  149.328342] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 19
[  149.328464] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 4
[  149.328467] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 20
[  149.328588] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 5
[  149.328591] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 21
[  149.328712] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 6
[  149.328715] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 22
[  149.328837] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 7
[  149.328840] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 23
[  149.328961] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 8
[  149.328964] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 24
[  149.329086] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 9
[  149.329089] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 25
[  149.329211] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 10
[  149.329214] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 26
[  149.329336] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 11
[  149.329339] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 27
[  149.329461] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 12
[  149.329464] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 28
[  149.329585] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 13
[  149.329588] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 29
[  149.329710] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 14
[  149.329713] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 30
[  149.329834] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 15
[  149.329837] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 31
[  149.329959] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 16
[  149.329963] ehci_hcd 0000:00:1d.7: devpath 7 ep2out 3strikes
[  149.330085] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 17
[  149.330210] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 18
[  149.330334] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 19
[  149.330460] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 20
[  149.330583] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 21
[  149.330708] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 22
[  149.330832] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 23
[  149.330958] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 24
[  149.331082] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 25
[  149.331207] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 26
[  149.331332] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 27
[  149.331456] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 28
[  149.331581] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 29
[  149.331706] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 30
[  149.331845] ehci_hcd 0000:00:1d.7: detected XactErr len 0/31 retry 31
[  149.331970] ehci_hcd 0000:00:1d.7: devpath 7 ep4out 3strikes
[  149.332005] usb 1-7: unlink qh1-0001/ffff8804124ce200 start 0 [2/0 us]
[  149.402058] ehci_hcd 0000:00:1d.7: port 7 high speed
[  149.402064] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  149.461815] usb 1-7: reset high-speed USB device number 4 using ehci_hcd
[  149.468892] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  149.469018] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  149.469142] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  149.469267] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  149.469390] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  149.469516] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  149.469640] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  149.469765] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  149.469889] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  149.470014] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  149.470139] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  149.470264] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  149.470388] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  149.470514] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  149.470638] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  149.470763] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  149.470887] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  149.471012] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  149.471137] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  149.471262] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  149.471387] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  149.471511] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  149.471636] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  149.471761] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  149.471900] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  149.472025] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  149.472151] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  149.472274] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  149.472399] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  149.472523] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  149.472649] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  149.472773] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  149.473024] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  149.473147] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  149.473273] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  149.473398] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  149.473522] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  149.473646] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  149.473772] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  149.473896] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  149.474021] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  149.474145] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  149.474270] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  149.474395] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  149.474520] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  149.474645] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  149.474769] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  149.474894] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  149.475019] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  149.475143] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  149.475268] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  149.475393] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  149.475518] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  149.475643] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  149.475767] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  149.475892] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  149.476017] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  149.476141] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  149.476266] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  149.476391] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  149.476516] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  149.476641] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 1
[  149.476765] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 2
[  149.476890] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 3
[  149.477015] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 4
[  149.477140] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 5
[  149.477265] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 6
[  149.477389] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 7
[  149.477514] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 8
[  149.477639] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 9
[  149.477763] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 10
[  149.477888] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 11
[  149.478013] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 12
[  149.478138] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 13
[  149.478263] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 14
[  149.531993] ehci_hcd 0000:00:1d.7: port 7 high speed
[  149.531998] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  149.591841] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  149.591967] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  149.592091] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  149.592214] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  149.592340] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  149.592464] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  149.592589] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  149.592713] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  149.592838] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  149.592962] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  149.593088] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  149.593212] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  149.593337] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  149.593462] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  149.593587] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  149.593711] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  149.593836] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  149.593960] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  149.594086] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  149.594210] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  149.594335] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  149.594460] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  149.594584] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  149.594709] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  149.594834] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  149.594959] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  149.595084] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  149.595209] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  149.595333] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  149.595458] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  149.595582] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  149.595708] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[  149.801736] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  149.801862] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  149.801987] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  149.802110] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  149.802235] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  149.802359] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  149.802484] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  149.802609] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  149.802733] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  149.802858] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 3
[  149.802982] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 4
[  149.803108] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 5
[  149.831721] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  149.831846] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  149.831971] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  149.832095] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 1
[  149.832220] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 2
[  149.832344] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 3
[  149.832593] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  149.832719] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  149.832845] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  149.832968] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  149.833092] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  149.833217] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  149.833342] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  149.833467] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  149.833591] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  149.833716] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  149.833841] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  149.833966] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  149.834091] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  149.834215] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  149.834340] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  149.834465] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  149.834589] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  149.834714] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  149.834839] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  149.834964] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  149.835089] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  149.835213] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  149.835339] ehci_hcd 0000:00:1d.7: detected XactErr len 0/105 retry 1
[  149.835463] ehci_hcd 0000:00:1d.7: detected XactErr len 0/105 retry 2
[  149.835588] ehci_hcd 0000:00:1d.7: detected XactErr len 0/105 retry 3
[  149.835712] ehci_hcd 0000:00:1d.7: detected XactErr len 64/105 retry 4
[  149.835837] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  149.836087] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  149.836212] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  149.836337] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  149.836461] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  149.836586] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  149.836711] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  149.836835] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  149.836960] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  149.837085] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  149.837209] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  149.837334] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  149.837459] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  149.837584] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  149.837709] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  149.837833] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  149.837958] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  149.838083] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  149.838207] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  149.838333] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  149.838458] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  149.838582] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  149.838707] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  149.838832] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  149.838956] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  149.839080] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  149.839206] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  149.839331] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  149.839455] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  149.839580] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  149.839705] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  149.839830] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  149.839954] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  149.840205] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  149.840330] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  149.840453] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  149.840579] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  149.840704] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  149.840828] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  149.840952] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  149.841077] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  149.841202] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  149.841327] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  149.841451] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  149.841576] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  149.841716] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  149.841840] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  149.841965] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  149.842089] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  149.842215] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  149.842339] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  149.842463] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  149.842589] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  149.842713] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  149.842838] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  149.842963] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  149.843087] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  149.843212] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  149.843336] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  149.843461] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  149.843587] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  149.843711] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  149.843836] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  149.843961] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  149.844085] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  149.844097] usb 1-7: serial string error -71
[  149.844099] usb 1-7: device firmware changed
[  149.848628] hub 1-0:1.0: logical disconnect on port 7
[  149.848661] hub 1-0:1.0: state 7 ports 8 chg 0080 evt fe00
[  149.848673] hub 1-0:1.0: port 7, status 0501, change 0000, 480 Mb/s
[  149.848676] usb 1-7: USB disconnect, device number 4
[  149.853904] usb 1-7: unregistering device
[  149.853906] usb 1-7: unregistering interface 1-7:1.0
[  149.862278] usb 1-7: unregistering interface 1-7:1.1
[  149.892201] usb 1-7: unregistering interface 1-7:1.2
[  149.961671] usb 1-7: unregistering interface 1-7:1.3
[  150.071616] usb 1-7: usb_disable_device nuking all URBs
[  150.131693] ehci_hcd 0000:00:1d.7: port 7 high speed
[  150.131699] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  150.191473] usb 1-7: new high-speed USB device number 5 using ehci_hcd
[  150.198279] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  150.198405] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  150.198528] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  150.198652] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  150.198778] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  150.198903] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  150.199026] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  150.199150] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  150.199275] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  150.199401] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  150.199525] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  150.199650] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  150.199775] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  150.199899] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  150.200024] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  150.200148] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  150.200273] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  150.200398] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  150.200523] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  150.200648] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  150.200772] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  150.200897] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  150.201022] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  150.201146] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  150.201271] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  150.201397] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  150.201536] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 1
[  150.201660] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 2
[  150.201786] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 3
[  150.201910] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 4
[  150.202034] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 5
[  150.202159] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 6
[  150.202285] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 7
[  150.202409] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 8
[  150.202533] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 9
[  150.202658] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 10
[  150.202784] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 11
[  150.202907] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 12
[  150.203032] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 13
[  150.203157] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 14
[  150.203282] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 15
[  150.203406] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 16
[  150.203531] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 17
[  150.261753] ehci_hcd 0000:00:1d.7: port 7 high speed
[  150.261758] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  150.321477] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  150.321601] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  150.321726] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  150.321851] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  150.321974] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  150.322099] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  150.322224] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  150.322349] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  150.322473] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  150.322598] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  150.322723] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  150.322848] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  150.322973] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  150.323097] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  150.323222] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 3
[  150.323347] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 4
[  150.323471] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 5
[  150.323596] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 6
[  150.323721] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 7
[  150.323846] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 8
[  150.323970] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 9
[  150.324095] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 10
[  150.324220] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 11
[  150.324345] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 12
[  150.351461] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  150.351587] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 1
[  150.351711] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 2
[  150.351837] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 3
[  150.351959] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 4
[  150.352084] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 5
[  150.352209] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 6
[  150.352333] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 7
[  150.352459] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  150.352583] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  150.352708] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 3
[  150.352833] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 4
[  150.352957] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 5
[  150.353082] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 6
[  150.353207] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 7
[  150.353457] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  150.353581] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  150.353707] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  150.353831] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  150.353955] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  150.354080] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  150.354205] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  150.354329] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  150.354455] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  150.354579] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  150.354704] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  150.354829] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  150.354953] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  150.355078] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  150.355203] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  150.355328] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  150.355453] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  150.355577] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  150.355702] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  150.355827] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  150.355951] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  150.356076] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  150.356201] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  150.356326] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  150.356451] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  150.356575] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  150.356700] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  150.356824] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  150.356950] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  150.357075] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  150.357199] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  150.357324] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  150.357575] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  150.357699] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  150.357823] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  150.357948] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  150.358073] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  150.358197] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  150.358323] ehci_hcd 0000:00:1d.7: detected XactErr len 0/9 retry 1
[  150.358447] ehci_hcd 0000:00:1d.7: detected XactErr len 0/9 retry 2
[  150.358572] ehci_hcd 0000:00:1d.7: detected XactErr len 0/9 retry 3
[  150.358696] ehci_hcd 0000:00:1d.7: detected XactErr len 0/9 retry 4
[  150.358821] ehci_hcd 0000:00:1d.7: detected XactErr len 0/9 retry 5
[  150.358946] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  150.359071] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  150.359321] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  150.359446] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  150.359571] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  150.359696] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  150.359819] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  150.359945] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  150.360069] ehci_hcd 0000:00:1d.7: detected XactErr len 0/105 retry 1
[  150.360194] ehci_hcd 0000:00:1d.7: detected XactErr len 0/105 retry 2
[  150.360319] ehci_hcd 0000:00:1d.7: detected XactErr len 0/105 retry 3
[  150.360444] ehci_hcd 0000:00:1d.7: detected XactErr len 0/105 retry 4
[  150.360568] ehci_hcd 0000:00:1d.7: detected XactErr len 0/105 retry 5
[  150.360693] ehci_hcd 0000:00:1d.7: detected XactErr len 64/105 retry 6
[  150.360817] ehci_hcd 0000:00:1d.7: detected XactErr len 64/105 retry 7
[  150.360943] ehci_hcd 0000:00:1d.7: detected XactErr len 64/105 retry 8
[  150.361067] ehci_hcd 0000:00:1d.7: detected XactErr len 64/105 retry 9
[  150.361191] ehci_hcd 0000:00:1d.7: detected XactErr len 64/105 retry 10
[  150.361317] ehci_hcd 0000:00:1d.7: detected XactErr len 64/105 retry 11
[  150.361456] ehci_hcd 0000:00:1d.7: detected XactErr len 64/105 retry 12
[  150.361595] usb 1-7: skipped 1 descriptor after interface
[  150.361599] usb 1-7: skipped 1 descriptor after interface
[  150.361706] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  150.361830] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  150.361956] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  150.362079] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  150.362205] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 1
[  150.362330] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 2
[  150.362454] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 3
[  150.362578] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 4
[  150.362703] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 5
[  150.362828] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 6
[  150.362953] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 7
[  150.363077] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  150.363202] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  150.363327] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 3
[  150.363451] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 4
[  150.363576] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 5
[  150.363701] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 6
[  150.363825] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 7
[  150.363951] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 8
[  150.364075] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 9
[  150.364208] usb 1-7: default language 0x0409
[  150.364325] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  150.364450] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  150.364574] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  150.364700] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  150.364824] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  150.364949] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  150.365073] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  150.365198] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  150.365322] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  150.365448] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  150.365572] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  150.365697] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  150.365822] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  150.365947] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  150.366071] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  150.366196] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  150.366320] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  150.366446] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  150.366571] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  150.366695] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  150.366820] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  150.366944] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  150.367069] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  150.367194] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  150.367319] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  150.367444] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  150.367569] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  150.367693] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  150.367818] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  150.367942] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  150.368067] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  150.368193] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  150.368442] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  150.368568] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  150.368691] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  150.368816] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  150.368941] ehci_hcd 0000:00:1d.7: detected XactErr len 0/2 retry 1
[  150.369066] ehci_hcd 0000:00:1d.7: detected XactErr len 0/2 retry 2
[  150.369192] ehci_hcd 0000:00:1d.7: detected XactErr len 0/2 retry 3
[  150.369315] ehci_hcd 0000:00:1d.7: detected XactErr len 0/2 retry 4
[  150.369440] ehci_hcd 0000:00:1d.7: detected XactErr len 0/2 retry 5
[  150.369564] ehci_hcd 0000:00:1d.7: detected XactErr len 0/2 retry 6
[  150.369689] ehci_hcd 0000:00:1d.7: detected XactErr len 0/2 retry 7
[  150.369940] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  150.370065] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  150.370190] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  150.370314] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  150.370438] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  150.370562] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  150.370687] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  150.370812] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  150.370937] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  150.371062] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  150.371186] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  150.371327] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  150.371451] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  150.371576] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  150.371700] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  150.371825] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  150.371949] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  150.372075] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  150.372198] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  150.372323] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  150.372449] ehci_hcd 0000:00:1d.7: detected XactErr len 0/24 retry 1
[  150.372573] ehci_hcd 0000:00:1d.7: detected XactErr len 0/24 retry 2
[  150.372698] ehci_hcd 0000:00:1d.7: detected XactErr len 0/24 retry 3
[  150.372823] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  150.372949] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  150.373197] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  150.373323] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  150.373448] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  150.373571] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  150.373697] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  150.373821] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  150.373946] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  150.374070] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  150.374195] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  150.374321] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  150.374445] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  150.374569] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  150.374694] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  150.374820] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  150.374944] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  150.375069] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  150.375193] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  150.375318] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  150.375442] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  150.375567] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  150.375692] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  150.375816] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  150.375942] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  150.376067] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  150.376191] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  150.376316] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  150.376440] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  150.376565] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  150.376690] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  150.376815] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  150.376940] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  150.377064] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  150.377315] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  150.377439] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  150.377565] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  150.377689] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  150.377813] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  150.377938] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  150.378062] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  150.378187] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  150.378312] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  150.378437] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  150.378562] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  150.378686] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  150.378811] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  150.378936] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  150.379060] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  150.379185] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  150.379310] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  150.379435] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  150.379560] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  150.379684] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  150.379809] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  150.379934] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  150.380058] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  150.380183] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  150.380309] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  150.380433] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  150.380558] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  150.380682] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  150.380808] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  150.380932] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  150.381056] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  150.381182] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  150.381446] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  150.381572] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 1
[  150.381695] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 2
[  150.381821] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 3
[  150.381946] ehci_hcd 0000:00:1d.7: detected XactErr len 64/255 retry 4
[  150.382069] ehci_hcd 0000:00:1d.7: detected XactErr len 64/255 retry 5
[  150.382205] usb 1-7: udev 5, busnum 1, minor = 4
[  150.382208] usb 1-7: New USB device found, idVendor=14dd, idProduct=0002
[  150.389169] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  150.396572] usb 1-7: Product: Multidevice
[  150.400824] usb 1-7: SerialNumber: 0083c601aa48d2d18A62C7F7C61EBFAA
[  150.407402] usb 1-7: usb_probe_device
[  150.407406] usb 1-7: configuration #1 chosen from 1 choice
[  150.407550] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  150.407674] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  150.407808] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  150.407923] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  150.408049] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  150.408174] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  150.408307] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  150.408422] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  150.408547] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  150.408672] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 3
[  150.408804] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 4
[  150.408921] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 5
[  150.409045] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 6
[  150.409170] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 7
[  150.409304] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 8
[  150.409419] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 9
[  150.409545] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 10
[  150.409670] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 11
[  150.409803] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 12
[  150.409919] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 13
[  150.410043] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 14
[  150.410168] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 15
[  150.410302] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 16
[  150.410418] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 17
[  150.410543] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 18
[  150.410668] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 19
[  150.410801] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 20
[  150.410917] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 21
[  150.411041] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 22
[  150.411166] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 23
[  150.411300] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 24
[  150.411431] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 25
[  150.411556] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 26
[  150.411680] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 27
[  150.411805] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 28
[  150.411930] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 29
[  150.412054] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 30
[  150.412179] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 31
[  150.412304] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[  150.412318] usb 1-7: can't set config #1, error -71
[  150.417434] drivers/usb/core/inode.c: creating file '005'

* detached the CD-ROM drive *

[  181.273274] hub 1-0:1.0: state 7 ports 8 chg 0000 evt ff80
[  181.273287] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001002 0  ACK POWER sig=se0 CSC
[  181.273301] hub 1-0:1.0: port 7, status 0100, change 0001, 12 Mb/s
[  181.273304] usb 1-7: USB disconnect, device number 5
[  181.278531] usb 1-7: unregistering device
[  181.278534] usb 1-7: usb_disable_device nuking all URBs
[  181.316395] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001803 0  ACK POWER sig=j CSC CONNECT
[  181.476316] hub 1-0:1.0: debounce: port 7: total 125ms stable 100ms status 0x501
[  181.536498] ehci_hcd 0000:00:1d.7: port 7 high speed
[  181.536503] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  181.596258] usb 1-7: new high-speed USB device number 6 using ehci_hcd
[  181.603084] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  181.603208] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  181.603333] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  181.603459] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 1
[  181.603581] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 2
[  181.603705] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 3
[  181.603830] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 4
[  181.603956] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 5
[  181.604079] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 6
[  181.604205] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 7
[  181.604329] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 8
[  181.604454] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 9
[  181.604579] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 10
[  181.604703] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 11
[  181.604828] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 12
[  181.604953] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 13
[  181.605077] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 14
[  181.605203] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 15
[  181.605327] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 16
[  181.605452] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 17
[  181.605577] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 18
[  181.605701] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 19
[  181.605826] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 20
[  181.605951] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 21
[  181.606075] ehci_hcd 0000:00:1d.7: detected XactErr len 0/64 retry 22
[  181.666433] ehci_hcd 0000:00:1d.7: port 7 high speed
[  181.666438] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  181.726281] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  181.726405] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  181.726530] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  181.726656] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  181.726778] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  181.726904] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  181.727028] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  181.727153] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  181.727278] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  181.727402] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  181.727527] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  181.727652] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  181.727776] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  181.727901] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  181.728026] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  181.728151] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  181.728276] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  181.728400] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  181.728525] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  181.728650] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  181.728774] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  181.728900] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  181.729024] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  181.729149] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  181.729274] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  181.729398] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  181.729524] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  181.729648] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  181.729773] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 3
[  181.729898] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 4
[  181.730022] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 5
[  181.730147] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 6
[  181.756265] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  181.756391] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  181.756515] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  181.756640] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  181.756763] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  181.756888] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  181.757013] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  181.757138] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  181.757263] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  181.757388] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  181.757512] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  181.757637] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  181.757762] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 1
[  181.757886] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 2
[  181.758012] ehci_hcd 0000:00:1d.7: detected XactErr len 0/18 retry 3
[  181.758136] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  181.758261] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 2
[  181.758511] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  181.758635] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  181.758761] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  181.758885] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  181.759009] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  181.759134] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  181.759259] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  181.759383] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  181.759508] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  181.759633] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  181.759758] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  181.759883] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  181.760007] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  181.760132] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  181.760257] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  181.760381] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  181.760506] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  181.760631] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  181.760756] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  181.760881] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  181.761005] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  181.761130] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  181.761255] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  181.761379] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  181.761504] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  181.761630] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  181.761754] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  181.761879] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  181.762003] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  181.762128] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  181.762253] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  181.762378] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  181.762628] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  181.762753] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  181.762878] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  181.763001] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  181.763127] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  181.763251] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  181.763376] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  181.763501] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  181.763625] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  181.763750] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  181.763875] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  181.763999] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  181.764124] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  181.764249] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  181.764374] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  181.764499] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  181.764623] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  181.764748] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  181.764873] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  181.764997] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  181.765123] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  181.765247] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  181.765372] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  181.765497] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  181.765621] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  181.765746] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  181.765871] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  181.765996] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  181.766121] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  181.766259] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  181.766385] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  181.766511] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  181.766760] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  181.766884] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  181.767009] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  181.767134] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  181.767257] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  181.767383] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  181.767508] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  181.767632] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  181.767757] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  181.767882] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  181.768005] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  181.768131] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  181.768257] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  181.768382] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  181.768505] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  181.768630] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  181.768756] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  181.768879] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  181.769004] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  181.769129] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  181.769254] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  181.769379] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  181.769503] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  181.769628] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  181.769754] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  181.769877] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  181.770002] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  181.770127] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  181.770253] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  181.770377] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  181.770501] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  181.770626] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  181.770637] usb 1-7: unable to read config index 0 descriptor/start: -71
[  181.777620] usb 1-7: chopping to 0 config(s)
[  181.782244] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  181.782371] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  181.782494] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  181.782618] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  181.782742] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  181.782869] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  181.782992] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  181.783117] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 1
[  181.783241] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 2
[  181.783368] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 3
[  181.783491] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 4
[  181.783624] usb 1-7: default language 0x0409
[  181.783740] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  181.783868] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  181.783991] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  181.784116] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  181.784239] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  181.784366] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  181.784488] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  181.784613] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  181.784738] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  181.784865] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  181.784988] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  181.785113] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  181.785237] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  181.785364] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  181.785486] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  181.785612] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  181.785736] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  181.785863] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  181.785986] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  181.786125] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  181.786250] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  181.786375] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  181.786499] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  181.786625] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  181.786749] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  181.786873] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  181.786998] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  181.787124] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  181.787248] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  181.787373] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  181.787497] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  181.787623] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  181.787872] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  181.787998] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  181.788121] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  181.788246] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  181.788371] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  181.788495] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  181.788620] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  181.788744] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  181.788869] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  181.788995] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  181.789119] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  181.789244] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  181.789369] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  181.789493] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  181.789618] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  181.789742] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  181.789868] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  181.789992] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  181.790117] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  181.790242] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  181.790366] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  181.790491] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  181.790616] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  181.790741] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  181.790866] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  181.790991] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  181.791115] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  181.791240] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  181.791364] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  181.791489] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  181.791615] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  181.791739] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  181.791990] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  181.792114] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  181.792239] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  181.792363] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  181.792488] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  181.792613] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  181.792737] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  181.792862] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  181.792986] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  181.793111] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  181.793236] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  181.793361] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  181.793486] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  181.793611] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  181.793735] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  181.793860] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  181.793984] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  181.794109] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  181.794234] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  181.794359] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  181.794484] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  181.794608] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  181.794733] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  181.794858] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  181.794982] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  181.795108] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  181.795232] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  181.795357] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  181.795482] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  181.795606] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  181.795731] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  181.795856] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  181.796121] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  181.796166] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  181.796244] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  181.796370] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  181.796495] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  181.796619] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  181.796744] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  181.796870] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  181.796993] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  181.797118] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  181.797242] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  181.797368] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  181.797492] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  181.797617] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  181.797742] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  181.797868] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  181.797990] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  181.798116] ehci_hcd 0000:00:1d.7: detected XactErr len 0/2 retry 1
[  181.798241] ehci_hcd 0000:00:1d.7: detected XactErr len 0/2 retry 2
[  181.798367] ehci_hcd 0000:00:1d.7: detected XactErr len 0/2 retry 3
[  181.798491] ehci_hcd 0000:00:1d.7: detected XactErr len 0/0 retry 1
[  181.798741] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  181.798865] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  181.798990] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  181.799115] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  181.799240] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  181.799364] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  181.799489] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  181.799613] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  181.799738] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  181.799862] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  181.799987] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  181.800112] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  181.800237] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  181.800362] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  181.800486] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  181.800611] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[  181.800736] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[  181.800860] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[  181.800985] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[  181.801111] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[  181.801235] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[  181.801360] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[  181.801484] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[  181.801609] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[  181.801734] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[  181.801859] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[  181.801983] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[  181.802109] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[  181.802233] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[  181.802358] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[  181.802482] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[  181.802607] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  181.802857] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[  181.802983] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[  181.803106] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[  181.803232] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[  181.803356] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[  181.803480] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[  181.803605] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[  181.803730] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[  181.803855] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[  181.803980] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[  181.804104] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[  181.804229] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[  181.804354] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[  181.804478] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[  181.804604] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[  181.804728] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 1
[  181.804853] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 2
[  181.804978] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 3
[  181.805102] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 4
[  181.805227] ehci_hcd 0000:00:1d.7: detected XactErr len 0/255 retry 5
[  181.805352] ehci_hcd 0000:00:1d.7: detected XactErr len 64/255 retry 6
[  181.805477] ehci_hcd 0000:00:1d.7: detected XactErr len 64/255 retry 7
[  181.805612] usb 1-7: udev 6, busnum 1, minor = 5
[  181.805615] usb 1-7: New USB device found, idVendor=14dd, idProduct=0002
[  181.812599] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  181.819991] usb 1-7: SerialNumber: 0083c601aa48d2d18A62C7F7C61EBFAA
[  181.826556] usb 1-7: usb_probe_device
[  181.826559] usb 1-7: no configuration chosen from 0 choices
[  181.832372] drivers/usb/core/inode.c: creating file '006'
[  181.832394] hub 1-0:1.0: state 7 ports 8 chg 0000 evt fe80

--------------080102030709070300040402
Content-Type: text/plain;
 name="usb-bad-usbmon.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="usb-bad-usbmon.txt"

ffff880413e39f00 12118441 C Ii:1:001:1 0:2048 2 = 8000
ffff880413e39f00 12118451 S Ii:1:001:1 -115:2048 4 <
ffff880413525d80 12118464 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525d80 12118476 C Ci:1:001:0 0 4 = 00010100
ffff880413525d80 12118479 S Co:1:001:0 s 23 01 0010 0007 0000 0
ffff880413525d80 12118481 C Co:1:001:0 0 0
ffff880413525d80 12124005 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525d80 12124008 C Ci:1:001:0 0 4 = 00010000
ffff880413e39f00 12159558 C Ii:1:001:1 0:2048 2 = 8000
ffff880413e39f00 12159561 S Ii:1:001:1 -115:2048 4 <
ffff880413525d80 12162155 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525d80 12162165 C Ci:1:001:0 0 4 = 01050100
ffff880413525d80 12162166 S Co:1:001:0 s 23 01 0010 0007 0000 0
ffff880413525d80 12162169 C Co:1:001:0 0 0
ffff880413525d80 12202135 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525d80 12202138 C Ci:1:001:0 0 4 = 01050000
ffff880413525d80 12242116 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525d80 12242119 C Ci:1:001:0 0 4 = 01050000
ffff880413525d80 12282096 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525d80 12282099 C Ci:1:001:0 0 4 = 01050000
ffff880413525d80 12322077 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525d80 12322079 C Ci:1:001:0 0 4 = 01050000
ffff880413525d80 12322089 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880413525d80 12322092 C Co:1:001:0 0 0
ffff880413525d80 12382047 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525d80 12382297 C Ci:1:001:0 0 4 = 03051000
ffff880413525d80 12442018 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880413525d80 12442021 C Co:1:001:0 0 0
ffff880413525d80 12448796 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413525d80 12449760 C Ci:1:000:0 0 18 = 12010002 00000040 dd140200 01000102 0301
ffff880413525d80 12449766 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880413525d80 12449769 C Co:1:001:0 0 0
ffff880413525d80 12501990 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525d80 12502240 C Ci:1:001:0 0 4 = 03051000
ffff880413525d80 12561960 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880413525d80 12561964 C Co:1:001:0 0 0
ffff880413525d80 12561965 S Co:1:000:0 s 00 05 0003 0000 0000 0
ffff880413525d80 12565956 C Co:1:000:0 -71 0
ffff880413525d80 12771860 S Co:1:000:0 s 00 05 0003 0000 0000 0
ffff880413525d80 12775849 C Co:1:000:0 -71 0
ffff880413525d80 12987838 S Co:1:001:0 s 23 01 0001 0007 0000 0
ffff880413525d80 12987843 C Co:1:001:0 0 0
ffff880413525d80 12987849 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880413525d80 12987853 C Co:1:001:0 0 0
ffff880413525d80 13041728 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525d80 13041968 C Ci:1:001:0 0 4 = 03051000
ffff880413525d80 13101699 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880413525d80 13101703 C Co:1:001:0 0 0
ffff880413525d80 13108491 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413525d80 13111428 C Ci:1:000:0 0 18 = 12010002 00000040 dd140200 01000102 0301
ffff880411f48f00 13111437 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880411f48f00 13111440 C Co:1:001:0 0 0
ffff880411f48f00 13161661 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880411f48f00 13161910 C Ci:1:001:0 0 4 = 03051000
ffff880411f48f00 13221631 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880411f48f00 13221634 C Co:1:001:0 0 0
ffff880411f48f00 13221636 S Co:1:000:0 s 00 05 0004 0000 0000 0
ffff880411f48f00 13223372 C Co:1:000:0 0 0
ffff880413525780 13251627 S Ci:1:004:0 s 80 06 0100 0000 0012 18 <
ffff880413525780 13255610 C Ci:1:004:0 -71 0
ffff880413525780 13255616 S Ci:1:004:0 s 80 06 0100 0000 0012 18 <
ffff880413525780 13257732 C Ci:1:004:0 0 18 = 12010002 00000040 dd140200 01000102 0301
ffff880413525780 13257743 S Ci:1:004:0 s 80 06 0200 0000 0009 9 <
ffff880413525780 13259355 C Ci:1:004:0 0 9 = 09026900 040100c0 32
ffff880411f486c0 13259364 S Ci:1:004:0 s 80 06 0200 0000 0069 105 <
ffff880411f486c0 13263359 C Ci:1:004:0 -71 0
ffff880411f486c0 13263370 S Ci:1:004:0 s 80 06 0200 0000 0069 105 <
ffff880411f486c0 13264728 C Ci:1:004:0 0 105 = 09026900 040100c0 32090400 00020806 50000705 81020002 00070502 02000200
ffff880411f486c0 13264746 S Ci:1:004:0 s 80 06 0300 0000 00ff 255 <
ffff880411f486c0 13265352 C Ci:1:004:0 0 4 = 04030904
ffff880413525840 13265362 S Ci:1:004:0 s 80 06 0302 0409 00ff 255 <
ffff880413525840 13266227 C Ci:1:004:0 0 24 = 18034d00 75006c00 74006900 64006500 76006900 63006500
ffff880413525840 13266237 S Ci:1:004:0 s 80 06 0301 0409 00ff 255 <
ffff880413525840 13267101 C Ci:1:004:0 0 26 = 1a035000 65007000 70006500 72006300 6f006e00 20004100 4700
ffff880413525840 13267108 S Ci:1:004:0 s 80 06 0303 0409 00ff 255 <
ffff880413525840 13269475 C Ci:1:004:0 0 66 = 42033000 30003800 33006300 36003000 31006100 61003400 38006400 32006400
ffff880413525cc0 13299454 S Co:1:004:0 s 00 09 0001 0000 0000 0
ffff880413525cc0 13301583 C Co:1:004:0 0 0
ffff8804138bfc00 13310420 S Ci:1:004:0 s 80 06 0303 0409 00ff 255 <
ffff8804138bfc00 13311831 C Ci:1:004:0 0 66 = 42033000 30003800 33006300 36003000 31006100 61003400 38006400 32006400
ffff880412511300 13311902 S Co:1:004:0 s 21 0a 0000 0002 0000 0
ffff880412511300 13313577 C Co:1:004:0 0 0
ffff880413525600 13313585 S Ci:1:004:0 s 81 06 2200 0002 004f 79 <
ffff880413525600 13317702 C Ci:1:004:0 0 79 = 05010902 a1010901 a1000509 19012903 15002501 95037501 81029501 75058101
ffff880413d9d240 13317899 S Ci:1:004:0 s a1 01 0100 0002 0006 64 <
ffff880413d9d240 13318576 C Ci:1:004:0 0 6 = 00bf1bff 5c00
ffff880412468000 13341829 S Ci:1:004:0 s 80 06 0303 0409 00ff 255 <
ffff880412468000 13345816 C Ci:1:004:0 -71 0
ffff880412468000 13345824 S Ci:1:004:0 s 80 06 0303 0409 0002 2 <
ffff880412468000 13349311 C Ci:1:004:0 0 2 = 4203
ffff880412468000 13349318 S Ci:1:004:0 s 80 06 0303 0409 0042 66 <
ffff880412468000 13353311 C Ci:1:004:0 -71 0
ffff880412468240 13353357 S Co:1:004:0 s 21 0a 0000 0003 0000 0
ffff880412468240 13354058 C Co:1:004:0 0 0
ffff880412468240 13354090 S Ci:1:004:0 s 81 06 2200 0003 0042 66 <
ffff880412468240 13357931 C Ci:1:004:0 0 66 = 05010906 a1010507 19e029e7 15002501 75019508 81029501 75088101 190029e7
ffff880413525c00 13358093 S Co:1:004:0 s 21 09 0200 0003 0001 1 = 00
ffff880412468240 13368577 S Ii:1:004:6 -115:8 8 <
ffff880413ccad80 13381612 S Ci:1:001:0 s a3 00 0000 0008 0004 4 <
ffff880413ccad80 13381615 C Ci:1:001:0 0 4 = 00010000
ffff880413ccad80 13381622 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413ccad80 13381624 C Ci:1:001:0 0 4 = 03050000
ffff880413525c00 13384670 C Co:1:004:0 0 1 >
ffff880412468240 13550840 C Ii:1:004:6 -71:8 0
ffff880412468240 13561475 S Ii:1:004:6 -115:8 8 <
ffff880412468240 13729748 C Ii:1:004:6 -71:8 0
ffff880412468240 13751383 S Ii:1:004:6 -115:8 8 <
ffff880412468240 13944641 C Ii:1:004:6 -71:8 0
ffff880412468240 14001261 S Ii:1:004:6 -115:8 8 <
ffff880412468240 14161533 C Ii:1:004:6 -71:8 0
ffff880412468240 14271080 S Ii:1:004:6 -115:8 8 <
ffff880411f48f00 14301115 S Ci:1:004:0 s a1 fe 0000 0000 0001 1 <
ffff880411f48240 14301128 S Ci:1:004:0 s a1 fe 0000 0001 0001 1 <
ffff880411f48f00 14305086 C Ci:1:004:0 -71 0
ffff880411f48f00 14305190 S Bo:1:004:2 -115 31 = 55534243 01000000 24000000 80000612 00000024 00000000 00000000 000000
ffff880411f48240 14307206 C Ci:1:004:0 0 1 = 00
ffff880411f48240 14307278 S Bo:1:004:4 -115 31 = 55534243 01000000 24000000 80000612 00000024 00000000 00000000 000000
ffff880411f48f00 14309210 C Bo:1:004:2 -71 0
ffff880411f48240 14311208 C Bo:1:004:4 -71 0
ffff880412468240 14311299 C Ii:1:004:6 -2:8 0
ffff880411ea3780 14321106 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880411ea3780 14321110 C Co:1:001:0 0 0
ffff880411ea3780 14381072 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880411ea3780 14381301 C Ci:1:001:0 0 4 = 03051000
ffff880411ea3780 14441041 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880411ea3780 14441044 C Co:1:001:0 0 0
ffff880411ea3780 14448011 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880411ea3780 14452012 C Ci:1:000:0 -71 0
ffff880415745b40 14452020 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880415745b40 14457632 C Ci:1:000:0 0 18 = 12010002 00000040 dd140200 01000102 0301
ffff880415745b40 14457642 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880415745b40 14457645 C Co:1:001:0 0 0
ffff880415745b40 14511019 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880415745b40 14511235 C Ci:1:001:0 0 4 = 03051000
ffff880415745b40 14570990 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880415745b40 14570995 C Co:1:001:0 0 0
ffff880415745b40 14570997 S Co:1:000:0 s 00 05 0004 0000 0000 0
ffff880415745b40 14574951 C Co:1:000:0 -71 0
ffff880415745b40 14780888 S Co:1:000:0 s 00 05 0004 0000 0000 0
ffff880415745b40 14782468 C Co:1:000:0 0 0
ffff880415745b40 14810872 S Ci:1:004:0 s 80 06 0100 0000 0012 18 <
ffff880415745b40 14811705 C Ci:1:004:0 0 18 = 12010002 00000040 dd140200 01000102 0301
ffff880415745b40 14811714 S Ci:1:004:0 s 80 06 0200 0000 0069 105 <
ffff880415745b40 14815203 C Ci:1:004:0 0 105 = 09026900 040100c0 32090400 00020806 50000705 81020002 00070502 02000200
ffff880415745b40 14815210 S Ci:1:004:0 s 80 06 0303 0409 00ff 255 <
ffff880415745b40 14819205 C Ci:1:004:0 -71 0
ffff880415745b40 14819211 S Ci:1:004:0 s 80 06 0303 0409 0002 2 <
ffff880415745b40 14823326 C Ci:1:004:0 -71 0
ffff880411ea3e40 14827875 S Co:1:001:0 s 23 01 0001 0007 0000 0
ffff880411ea3e40 14827879 C Co:1:001:0 0 0
ffff880415745cc0 14827908 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880415745cc0 14827913 C Ci:1:001:0 0 4 = 01050000
ffff880415745840 15050910 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880415745840 15050916 C Co:1:001:0 0 0
ffff880415745840 15110729 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880415745840 15110936 C Ci:1:001:0 0 4 = 03051000
ffff880415745540 15170698 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880415745540 15170703 C Co:1:001:0 0 0
ffff880415745540 15177487 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880415745540 15182894 C Ci:1:000:0 0 18 = 12010002 00000040 dd140200 01000102 0301
ffff880411ea3900 15182904 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880411ea3900 15182907 C Co:1:001:0 0 0
ffff880411ea3900 15240689 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880411ea3900 15240995 C Ci:1:001:0 0 4 = 03051000
ffff880411ea3900 15300625 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880411ea3900 15300629 C Co:1:001:0 0 0
ffff880411ea3900 15300631 S Co:1:000:0 s 00 05 0005 0000 0000 0
ffff880411ea3900 15303709 C Co:1:000:0 0 0
ffff880411ea3900 15330610 S Ci:1:005:0 s 80 06 0100 0000 0012 18 <
ffff880411ea3900 15332569 C Ci:1:005:0 0 18 = 12010002 00000040 dd140200 01000102 0301
ffff880411ea3900 15332578 S Ci:1:005:0 s 80 06 0200 0000 0009 9 <
ffff880411ea3900 15336571 C Ci:1:005:0 -71 0
ffff880411ea3900 15336580 S Ci:1:005:0 s 80 06 0200 0000 0009 9 <
ffff880411ea3900 15338442 C Ci:1:005:0 0 9 = 09026900 040100c0 32
ffff880411ea3900 15338450 S Ci:1:005:0 s 80 06 0200 0000 0069 105 <
ffff880411ea3900 15340815 C Ci:1:005:0 0 105 = 09026900 040100c0 32090400 00020806 50000705 81020002 00070502 02000200
ffff880415745240 15340838 S Ci:1:005:0 s 80 06 0300 0000 00ff 255 <
ffff880415745240 15343438 C Ci:1:005:0 0 4 = 04030904
ffff880411ea3480 15343449 S Ci:1:005:0 s 80 06 0302 0409 00ff 255 <
ffff880411ea3480 15347440 C Ci:1:005:0 -71 0
ffff880411ea3480 15347445 S Ci:1:005:0 s 80 06 0302 0409 0002 2 <
ffff880411ea3480 15349061 C Ci:1:005:0 0 2 = 1803
ffff880411ea3480 15349070 S Ci:1:005:0 s 80 06 0302 0409 0018 24 <
ffff880411ea3480 15352309 C Ci:1:005:0 0 24 = 18034d00 75006c00 74006900 64006500 76006900 63006500
ffff880415745c00 15352318 S Ci:1:005:0 s 80 06 0301 0409 00ff 255 <
ffff880415745c00 15356309 C Ci:1:005:0 -71 0
ffff880411ea3480 15356316 S Ci:1:005:0 s 80 06 0301 0409 0002 2 <
ffff880411ea3480 15360432 C Ci:1:005:0 -71 0
ffff880415745e40 15360439 S Ci:1:005:0 s 80 06 0303 0409 00ff 255 <
ffff880415745e40 15361430 C Ci:1:005:0 0 66 = 42033000 30003800 33006300 36003000 31006100 61003400 38006400 32006400
ffff880415745c00 15386643 S Co:1:005:0 s 00 09 0001 0000 0000 0
ffff880415745c00 15391543 C Co:1:005:0 -71 0
ffff880413e39f00 46252504 C Ii:1:001:1 0:2048 2 = 8000
ffff880413e39f00 46252512 S Ii:1:001:1 -115:2048 4 <
ffff880413525780 46252523 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525780 46252533 C Ci:1:001:0 0 4 = 00010100
ffff880413525780 46252537 S Co:1:001:0 s 23 01 0010 0007 0000 0
ffff880413525780 46252540 C Co:1:001:0 0 0
ffff880413525780 46257830 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525780 46257834 C Ci:1:001:0 0 4 = 00010000
ffff880413e39f00 46293877 C Ii:1:001:1 0:2048 2 = 8000
ffff880413e39f00 46293881 S Ii:1:001:1 -115:2048 4 <
ffff880413525a80 46295622 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525a80 46295632 C Ci:1:001:0 0 4 = 01050100
ffff880413525a80 46295634 S Co:1:001:0 s 23 01 0010 0007 0000 0
ffff880413525a80 46295636 C Co:1:001:0 0 0
ffff880413525780 46335602 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525780 46335606 C Ci:1:001:0 0 4 = 01050000
ffff880413525780 46375583 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525780 46375586 C Ci:1:001:0 0 4 = 01050000
ffff880413525780 46415563 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525780 46415567 C Ci:1:001:0 0 4 = 01050000
ffff880413525780 46455543 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525780 46455546 C Ci:1:001:0 0 4 = 01050000
ffff880413525780 46455556 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880413525780 46455558 C Co:1:001:0 0 0
ffff880413525780 46515514 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413525780 46515739 C Ci:1:001:0 0 4 = 03051000
ffff880413525780 46575484 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880413525780 46575488 C Co:1:001:0 0 0
ffff880413525780 46582268 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413525780 46585449 C Ci:1:000:0 0 18 = 12010002 00000040 dd140200 01000102 0301
ffff88041248df00 46585458 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff88041248df00 46585461 C Co:1:001:0 0 0
ffff88041248df00 46645460 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff88041248df00 46645674 C Ci:1:001:0 0 4 = 03051000
ffff88041248df00 46705432 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff88041248df00 46705436 C Co:1:001:0 0 0
ffff88041248df00 46705438 S Co:1:000:0 s 00 05 0006 0000 0000 0
ffff88041248df00 46709512 C Co:1:000:0 0 0
ffff88041248df00 46735419 S Ci:1:006:0 s 80 06 0100 0000 0012 18 <
ffff88041248df00 46737623 C Ci:1:006:0 0 18 = 12010002 00000040 dd140200 01000102 0301
ffff88041248df00 46737632 S Ci:1:006:0 s 80 06 0200 0000 0009 9 <
ffff88041248df00 46741624 C Ci:1:006:0 -71 0
ffff880413525a80 46741632 S Ci:1:006:0 s 80 06 0200 0000 0009 9 <
ffff880413525a80 46745750 C Ci:1:006:0 -71 0
ffff880413525a80 46745759 S Ci:1:006:0 s 80 06 0200 0000 0009 9 <
ffff880413525a80 46749869 C Ci:1:006:0 -71 0
ffff880413525a80 46761372 S Ci:1:006:0 s 80 06 0300 0000 00ff 255 <
ffff880413525a80 46762860 C Ci:1:006:0 0 4 = 04030904
ffff880413525a80 46762869 S Ci:1:006:0 s 80 06 0302 0409 00ff 255 <
ffff880413525a80 46766864 C Ci:1:006:0 -71 0
ffff880413525a80 46766872 S Ci:1:006:0 s 80 06 0302 0409 0002 2 <
ffff880413525a80 46770985 C Ci:1:006:0 -71 0
ffff880413525a80 46770992 S Ci:1:006:0 s 80 06 0301 0409 00ff 255 <
ffff880413525a80 46775108 C Ci:1:006:0 -71 0
ffff880413525a80 46775115 S Ci:1:006:0 s 80 06 0301 0409 0002 2 <
ffff880413525a80 46777852 C Ci:1:006:0 0 2 = 1a03
ffff880413525a80 46777858 S Ci:1:006:0 s 80 06 0301 0409 001a 26 <
ffff880413525a80 46781855 C Ci:1:006:0 -71 0
ffff880413525a80 46781863 S Ci:1:006:0 s 80 06 0303 0409 00ff 255 <
ffff880413525a80 46784850 C Ci:1:006:0 0 66 = 42033000 30003800 33006300 36003000 31006100 61003400 38006400 32006400
ffff88041248d540 46811630 S Ci:1:001:0 s a3 00 0000 0008 0004 4 <
ffff88041248d540 46811633 C Ci:1:001:0 0 4 = 00010000
ffff88041248d540 46811639 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff88041248d540 46811640 C Ci:1:001:0 0 4 = 03050000

--------------080102030709070300040402
Content-Type: text/plain;
 name="usb-good.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="usb-good.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.15-00013-g9c7edc7 (blackfire@eskarina) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5.1) ) #12 SMP Thu Apr 19 09:45:06 CEST 2012
[    0.000000] Command line: root=/dev/md11 ro nmi_watchdog=2 panic=10 console=ttyS1,115200n8r console=tty0 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000099000 (usable)
[    0.000000]  BIOS-e820: 0000000000099000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff50000 (usable)
[    0.000000]  BIOS-e820: 00000000cff50000 - 00000000cff65000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cff65000 - 00000000cff80000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000430000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Supermicro X7DBR-3/X7DBR-3, BIOS 2.1 06/23/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x430000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00D0000000 mask 3FF0000000 uncachable
[    0.000000]   1 base 00E0000000 mask 3FE0000000 uncachable
[    0.000000]   2 base 0000000000 mask 3C00000000 write-back
[    0.000000]   3 base 0400000000 mask 3FE0000000 write-back
[    0.000000]   4 base 0420000000 mask 3FF0000000 write-back
[    0.000000]   5 base 00CFF80000 mask 3FFFF80000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000cff80000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcff50 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f61b0] f61b0
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 8192
[    0.000000] init_memory_mapping: 0000000000000000-00000000cff50000
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cff50000 page 4k
[    0.000000] kernel direct mapping tables up to cff50000 @ 1fffa000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000430000000
[    0.000000]  0100000000 - 0430000000 page 2M
[    0.000000] kernel direct mapping tables up to 430000000 @ cff3e000-cff50000
[    0.000000] ACPI: RSDP 00000000000f6180 00014 (v00 PTLTD )
[    0.000000] ACPI: RSDT 00000000cff5ea36 00060 (v01 SMCI   SMCISLP2 06040000  LTP 00000000)
[    0.000000] ACPI: FACP 00000000cff644fa 00074 (v01 INTEL  TUMWATER 06040000 PTL  00000003)
[    0.000000] ACPI: DSDT 00000000cff60568 03F92 (v01  Intel BLAKFORD 06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000cff65fc0 00040
[    0.000000] ACPI: APIC 00000000cff6456e 00090 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: MCFG 00000000cff645fe 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000cff6463a 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SPCR 00000000cff64662 00050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: SLIC 00000000cff646b2 00176 (v01 SMCI   SMCISLP2 06040000  LTP 00000000)
[    0.000000] ACPI: SSDT 00000000cff60309 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff60263 000A6 (v01  PmRef  Cpu7Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff601bd 000A6 (v01  PmRef  Cpu6Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff60117 000A6 (v01  PmRef  Cpu5Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff60071 000A6 (v01  PmRef  Cpu4Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff5ffcb 000A6 (v01  PmRef  Cpu3Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff5ff25 000A6 (v01  PmRef  Cpu2Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff5fe7f 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff5ea96 013E9 (v01  PmRef    CpuPm 00003000 INTL 20050228)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000430000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000430000000
[    0.000000]   NODE_DATA [000000042fffb000 - 000000042fffffff]
[    0.000000]  [ffffea0000000000-ffffea0010bfffff] PMD -> [ffff88041f600000-ffff88042f5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00430000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000099
[    0.000000]     0: 0x00000100 -> 0x000cff50
[    0.000000]     0: 0x00100000 -> 0x00430000
[    0.000000] On node 0 totalpages: 4194009
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 2 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 831376 pages, LIFO batch:31
[    0.000000]   Normal zone: 52224 pages used for memmap
[    0.000000]   Normal zone: 3290112 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 5, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88042fc00000 s78208 r8192 d24192 u524288
[    0.000000] pcpu-alloc: s78208 r8192 d24192 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4125399
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/md11 ro nmi_watchdog=2 panic=10 console=ttyS1,115200n8r console=tty0 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16434604k/17563648k available (5176k kernel code, 787612k absent, 341432k reserved, 5710k data, 860k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:1024 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS1] enabled
[    0.000000] allocated 134217728 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2000.145 MHz processor.
[    0.020004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4000.29 BogoMIPS (lpj=20001450)
[    0.040002] pid_max: default: 32768 minimum: 301
[    0.046519] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.064088] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.074336] Mount-cache hash table entries: 256
[    0.080177] Initializing cgroup subsys cpuacct
[    0.084868] Initializing cgroup subsys memory
[    0.090013] Initializing cgroup subsys devices
[    0.094697] Initializing cgroup subsys freezer
[    0.099378] Initializing cgroup subsys net_cls
[    0.100003] Initializing cgroup subsys blkio
[    0.104553] CPU: Physical Processor ID: 0
[    0.110002] CPU: Processor Core ID: 0
[    0.113905] mce: CPU supports 6 MCE banks
[    0.120007] CPU0: Thermal monitoring handled by SMI
[    0.120012] using mwait in idle threads.
[    0.124300] Freeing SMP alternatives: 24k freed
[    0.130017] ACPI: Core revision 20110623
[    0.140012] ftrace: allocating 21131 entries in 83 pages
[    0.160489] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.267273] CPU0: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz stepping 06
[    0.280000] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.280000] ... version:                2
[    0.280001] ... bit width:              40
[    0.284340] ... generic registers:      2
[    0.290001] ... value mask:             000000ffffffffff
[    0.295554] ... max period:             000000007fffffff
[    0.300001] ... fixed-purpose events:   3
[    0.304255] ... event mask:             0000000700000003
[    0.310239] NMI watchdog enabled, takes one hw-pmu counter.
[    0.316160] Booting Node   0, Processors  #1
[    0.320329] smpboot cpu 1: start_ip = 97000
[    0.030000] CPU1: Thermal monitoring handled by SMI
[    0.490028] NMI watchdog enabled, takes one hw-pmu counter.
[    0.495968]  #2
[    0.497597] smpboot cpu 2: start_ip = 97000
[    0.030000] CPU2: Thermal monitoring handled by SMI
[    0.660020] NMI watchdog enabled, takes one hw-pmu counter.
[    0.665913]  #3 Ok.
[    0.668256] smpboot cpu 3: start_ip = 97000
[    0.030000] CPU3: Thermal monitoring handled by SMI
[    0.830020] NMI watchdog enabled, takes one hw-pmu counter.
[    0.835856] Brought up 4 CPUs
[    0.839340] Total of 4 processors activated (16001.02 BogoMIPS).
[    0.851274] xor: automatically using best checksumming function: generic_sse
[    0.910002]    generic_sse:  7427.200 MB/sec
[    0.914512] xor: using function: generic_sse (7427.200 MB/sec)
[    0.920044] NET: Registered protocol family 16
[    0.924773] kworker/u:0 used greatest stack depth: 5504 bytes left
[    0.932235] ACPI: bus type pci registered
[    0.936588] PCI: Using configuration type 1 for base access
[    0.947377] bio: create slab <bio-0> at 0
[    1.120006] raid6: int64x1   1662 MB/s
[    1.290009] raid6: int64x2   1835 MB/s
[    1.460010] raid6: int64x4   1557 MB/s
[    1.630012] raid6: int64x8   1176 MB/s
[    1.800008] raid6: sse2x1    3119 MB/s
[    1.970013] raid6: sse2x2    5444 MB/s
[    2.140003] raid6: sse2x4    5999 MB/s
[    2.143990] raid6: using algorithm sse2x4 (5999 MB/s)
[    2.149707] ACPI: Added _OSI(Module Device)
[    2.150003] ACPI: Added _OSI(Processor Device)
[    2.154686] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.160002] ACPI: Added _OSI(Processor Aggregator Device)
[    2.170088] ACPI: EC: Look up EC in DSDT
[    2.170347] ACPI Error: [Z000] Namespace lookup failure, AE_NOT_FOUND (20110623/psargs-359)
[    2.179323] ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node ffff88041544c7a8), AE_NOT_FOUND (20110623/psparse-536)
[    2.192204] ACPI: Interpreter enabled
[    2.196114] ACPI: (supports S0 S5)
[    2.200847] ACPI: Using IOAPIC for interrupt routing
[    2.211605] ACPI: No dock devices found.
[    2.215772] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.220548] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.228038] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    2.230004] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    2.240003] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    2.250003] pci_root PNP0A03:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    2.257749] pci_root PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    2.260002] pci_root PNP0A03:00: host bridge window [mem 0x000dc000-0x000dffff]
[    2.270002] pci_root PNP0A03:00: host bridge window [mem 0x000e0000-0x000e3fff]
[    2.280003] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xfebfffff]
[    2.287765] pci 0000:00:00.0: [8086:25d8] type 0 class 0x000600
[    2.287812] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    2.287816] pci 0000:00:00.0: PME# disabled
[    2.287835] pci 0000:00:02.0: [8086:25f7] type 1 class 0x000604
[    2.287876] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    2.287879] pci 0000:00:02.0: PME# disabled
[    2.287896] pci 0000:00:04.0: [8086:25f8] type 1 class 0x000604
[    2.290039] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    2.290043] pci 0000:00:04.0: PME# disabled
[    2.290060] pci 0000:00:06.0: [8086:25f9] type 1 class 0x000604
[    2.290102] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    2.290105] pci 0000:00:06.0: PME# disabled
[    2.290121] pci 0000:00:08.0: [8086:1a38] type 0 class 0x000880
[    2.290131] pci 0000:00:08.0: reg 10: [mem 0xfe700000-0xfe7003ff 64bit]
[    2.290172] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    2.290175] pci 0000:00:08.0: PME# disabled
[    2.290192] pci 0000:00:10.0: [8086:25f0] type 0 class 0x000600
[    2.290222] pci 0000:00:10.1: [8086:25f0] type 0 class 0x000600
[    2.290249] pci 0000:00:10.2: [8086:25f0] type 0 class 0x000600
[    2.290280] pci 0000:00:11.0: [8086:25f1] type 0 class 0x000600
[    2.290308] pci 0000:00:13.0: [8086:25f3] type 0 class 0x000600
[    2.290336] pci 0000:00:15.0: [8086:25f5] type 0 class 0x000600
[    2.290363] pci 0000:00:16.0: [8086:25f6] type 0 class 0x000600
[    2.290399] pci 0000:00:1c.0: [8086:2690] type 1 class 0x000604
[    2.290467] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.290471] pci 0000:00:1c.0: PME# disabled
[    2.290495] pci 0000:00:1d.0: [8086:2688] type 0 class 0x000c03
[    2.290534] pci 0000:00:1d.0: reg 20: [io  0x1800-0x181f]
[    2.290566] pci 0000:00:1d.1: [8086:2689] type 0 class 0x000c03
[    2.290605] pci 0000:00:1d.1: reg 20: [io  0x1820-0x183f]
[    2.290636] pci 0000:00:1d.2: [8086:268a] type 0 class 0x000c03
[    2.290675] pci 0000:00:1d.2: reg 20: [io  0x1840-0x185f]
[    2.290706] pci 0000:00:1d.3: [8086:268b] type 0 class 0x000c03
[    2.290745] pci 0000:00:1d.3: reg 20: [io  0x1860-0x187f]
[    2.290790] pci 0000:00:1d.7: [8086:268c] type 0 class 0x000c03
[    2.290809] pci 0000:00:1d.7: reg 10: [mem 0xd8700000-0xd87003ff]
[    2.290888] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    2.290893] pci 0000:00:1d.7: PME# disabled
[    2.290910] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    2.290968] pci 0000:00:1f.0: [8086:2670] type 0 class 0x000601
[    2.291047] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    2.291064] pci 0000:00:1f.1: [8086:269e] type 0 class 0x000101
[    2.291077] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    2.291086] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    2.291095] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    2.291104] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    2.291113] pci 0000:00:1f.1: reg 20: [io  0x1880-0x188f]
[    2.291148] pci 0000:00:1f.3: [8086:269b] type 0 class 0x000c05
[    2.291198] pci 0000:00:1f.3: reg 20: [io  0x1100-0x111f]
[    2.291268] pci 0000:01:00.0: [8086:3500] type 1 class 0x000604
[    2.291326] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    2.291330] pci 0000:01:00.0: PME# disabled
[    2.291349] pci 0000:01:00.3: [8086:350c] type 1 class 0x000604
[    2.291405] pci 0000:01:00.3: PME# supported from D0 D3hot D3cold
[    2.291409] pci 0000:01:00.3: PME# disabled
[    2.291423] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.300010] pci 0000:00:02.0: PCI bridge to [bus 01-05]
[    2.305476] pci 0000:00:02.0:   bridge window [io  0x2000-0x2fff]
[    2.305480] pci 0000:00:02.0:   bridge window [mem 0xd8100000-0xd82fffff]
[    2.305521] pci 0000:02:00.0: [8086:3510] type 1 class 0x000604
[    2.305585] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    2.305589] pci 0000:02:00.0: PME# disabled
[    2.305600] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.310012] pci 0000:02:02.0: [8086:3518] type 1 class 0x000604
[    2.310076] pci 0000:02:02.0: PME# supported from D0 D3hot D3cold
[    2.310080] pci 0000:02:02.0: PME# disabled
[    2.310091] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.320027] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    2.330004] pci 0000:01:00.0:   bridge window [io  0x2000-0x2fff]
[    2.330008] pci 0000:01:00.0:   bridge window [mem 0xd8200000-0xd82fffff]
[    2.330047] pci 0000:02:00.0: PCI bridge to [bus 03-03]
[    2.335566] pci 0000:04:00.0: [8086:1096] type 0 class 0x000200
[    2.335579] pci 0000:04:00.0: reg 10: [mem 0xd8220000-0xd823ffff]
[    2.335589] pci 0000:04:00.0: reg 14: [mem 0xd8200000-0xd821ffff]
[    2.335600] pci 0000:04:00.0: reg 18: [io  0x2000-0x201f]
[    2.335634] pci 0000:04:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    2.335678] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    2.335683] pci 0000:04:00.0: PME# disabled
[    2.335710] pci 0000:04:00.1: [8086:1096] type 0 class 0x000200
[    2.335723] pci 0000:04:00.1: reg 10: [mem 0xd8260000-0xd827ffff]
[    2.335734] pci 0000:04:00.1: reg 14: [mem 0xd8240000-0xd825ffff]
[    2.335744] pci 0000:04:00.1: reg 18: [io  0x2020-0x203f]
[    2.335778] pci 0000:04:00.1: reg 30: [mem 0x00000000-0x0000ffff pref]
[    2.335823] pci 0000:04:00.1: PME# supported from D0 D3hot D3cold
[    2.335827] pci 0000:04:00.1: PME# disabled
[    2.335846] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.340011] pci 0000:02:02.0: PCI bridge to [bus 04-04]
[    2.345476] pci 0000:02:02.0:   bridge window [io  0x2000-0x2fff]
[    2.345480] pci 0000:02:02.0:   bridge window [mem 0xd8200000-0xd82fffff]
[    2.345552] pci 0000:01:00.3: PCI bridge to [bus 05-05]
[    2.350040] pci 0000:00:04.0: PCI bridge to [bus 06-06]
[    2.355528] pci 0000:00:06.0: PCI bridge to [bus 07-07]
[    2.360056] pci 0000:08:00.0: [8086:032c] type 1 class 0x000604
[    2.360079] pci 0000:08:00.0: PXH quirk detected; SHPC device MSI disabled
[    2.367469] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    2.367474] pci 0000:08:00.0: PME# disabled
[    2.367497] pci 0000:08:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.370011] pci 0000:00:1c.0: PCI bridge to [bus 08-09]
[    2.375476] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    2.375480] pci 0000:00:1c.0:   bridge window [mem 0xd8300000-0xd83fffff]
[    2.375486] pci 0000:00:1c.0:   bridge window [mem 0xd8000000-0xd80fffff 64bit pref]
[    2.375548] pci 0000:09:02.0: [9005:041f] type 0 class 0x000104
[    2.375574] pci 0000:09:02.0: reg 10: [mem 0xd8300000-0xd833ffff 64bit]
[    2.375591] pci 0000:09:02.0: reg 18: [mem 0xd8000000-0xd801ffff 64bit pref]
[    2.375603] pci 0000:09:02.0: reg 20: [io  0x3000-0x30ff]
[    2.375624] pci 0000:09:02.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    2.375726] pci 0000:08:00.0: PCI bridge to [bus 09-09]
[    2.380005] pci 0000:08:00.0:   bridge window [io  0x3000-0x3fff]
[    2.380010] pci 0000:08:00.0:   bridge window [mem 0xd8300000-0xd83fffff]
[    2.380017] pci 0000:08:00.0:   bridge window [mem 0xd8000000-0xd80fffff 64bit pref]
[    2.380059] pci 0000:0a:01.0: [1002:515e] type 0 class 0x000300
[    2.380077] pci 0000:0a:01.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
[    2.380088] pci 0000:0a:01.0: reg 14: [io  0x4000-0x40ff]
[    2.380098] pci 0000:0a:01.0: reg 18: [mem 0xd8400000-0xd840ffff]
[    2.380133] pci 0000:0a:01.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    2.380162] pci 0000:0a:01.0: supports D1 D2
[    2.380206] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a] (subtractive decode)
[    2.387494] pci 0000:00:1e.0:   bridge window [io  0x4000-0x4fff]
[    2.387498] pci 0000:00:1e.0:   bridge window [mem 0xd8400000-0xd84fffff]
[    2.387504] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    2.387507] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    2.387510] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    2.387513] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    2.387516] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    2.387519] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    2.387522] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    2.387525] pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
[    2.387528] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xfebfffff] (subtractive decode)
[    2.387548] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.387720] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    2.387750] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0._PRT]
[    2.387787] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0.BPD0._PRT]
[    2.387837] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0.BPD2._PRT]
[    2.387872] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMF3._PRT]
[    2.387918] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    2.387967] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    2.388022] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0.PXH0._PRT]
[    2.388091] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    2.388140]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
[    2.403829] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 *7 10 11 14 15)
[    2.411279] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 14 15)
[    2.419012] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 14 15)
[    2.423163] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 14 15)
[    2.433174] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    2.443918] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
[    2.452818] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    2.462169] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
[    2.470656] vgaarb: device added: PCI:0000:0a:01.0,decodes=io+mem,owns=io+mem,locks=none
[    2.479185] vgaarb: loaded
[    2.480003] vgaarb: bridge control possible 0000:0a:01.0
[    2.485738] SCSI subsystem initialized
[    2.490140] libata version 3.00 loaded.
[    2.490237] usbcore: registered new interface driver usbfs
[    2.496007] usbcore: registered new interface driver hub
[    2.500063] usbcore: registered new device driver usb
[    2.505579] PCI: Using ACPI for IRQ routing
[    2.510004] PCI: pci_cache_line_size set to 64 bytes
[    2.510108] reserve RAM buffer: 0000000000099000 - 000000000009ffff 
[    2.510111] reserve RAM buffer: 00000000cff50000 - 00000000cfffffff 
[    2.510463] hpet clockevent registered
[    2.510467] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    2.520005] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    2.525371] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    2.560146] Switching to clocksource hpet
[    2.569746] pnp: PnP ACPI init
[    2.573053] ACPI: bus type pnp registered
[    2.577903] pnp 00:00: [bus 00-ff]
[    2.577906] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.577909] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.577914] pnp 00:00: [io  0x0d00-0xffff window]
[    2.577917] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.577919] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    2.577922] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    2.577924] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    2.577926] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    2.577929] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    2.577931] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    2.577933] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    2.577936] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    2.577938] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    2.577940] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    2.577943] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    2.577945] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    2.577948] pnp 00:00: [mem 0xd0000000-0xfebfffff window]
[    2.578042] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    2.578138] pnp 00:01: [io  0x0010-0x001f]
[    2.578141] pnp 00:01: [io  0x0024-0x0025]
[    2.578143] pnp 00:01: [io  0x0028-0x0029]
[    2.578145] pnp 00:01: [io  0x002c-0x002d]
[    2.578147] pnp 00:01: [io  0x002e-0x002f]
[    2.578149] pnp 00:01: [io  0x0030-0x0031]
[    2.578151] pnp 00:01: [io  0x0034-0x0035]
[    2.578153] pnp 00:01: [io  0x0038-0x0039]
[    2.578154] pnp 00:01: [io  0x003c-0x003d]
[    2.578157] pnp 00:01: [io  0x004e-0x004f]
[    2.578159] pnp 00:01: [io  0x0050-0x0053]
[    2.578161] pnp 00:01: [io  0x0063]
[    2.578162] pnp 00:01: [io  0x0065]
[    2.578164] pnp 00:01: [io  0x0067]
[    2.578166] pnp 00:01: [io  0x0072-0x0077]
[    2.578168] pnp 00:01: [io  0x0080]
[    2.578170] pnp 00:01: [io  0x0090-0x009f]
[    2.578172] pnp 00:01: [io  0x00a4-0x00a5]
[    2.578174] pnp 00:01: [io  0x00a8-0x00a9]
[    2.578176] pnp 00:01: [io  0x00ac-0x00ad]
[    2.578178] pnp 00:01: [io  0x00b0-0x00b5]
[    2.578180] pnp 00:01: [io  0x00b8-0x00b9]
[    2.578182] pnp 00:01: [io  0x00bc-0x00bd]
[    2.578185] pnp 00:01: [io  0x04d0-0x04d1]
[    2.578187] pnp 00:01: [io  0x0295-0x0296]
[    2.578189] pnp 00:01: [io  0x0ca2-0x0ca3]
[    2.578190] pnp 00:01: [io  0x0ca8-0x0caf]
[    2.578196] pnp 00:01: [io  0x1000-0x107f]
[    2.578198] pnp 00:01: [io  0x1180-0x11bf]
[    2.578200] pnp 00:01: [io  0x0800-0x080f]
[    2.578202] pnp 00:01: [io  0xfe00]
[    2.578204] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    2.578206] pnp 00:01: [mem 0xfee00000-0xfee0ffff]
[    2.578208] pnp 00:01: [mem 0xfec80000-0xfec80fff]
[    2.578210] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    2.578212] pnp 00:01: [mem 0xfe000000-0xfe01ffff]
[    2.578215] pnp 00:01: [mem 0xfe600000-0xfe6fffff]
[    2.578377] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    2.584539] system 00:01: [io  0x0295-0x0296] has been reserved
[    2.590728] system 00:01: [io  0x0ca2-0x0ca3] has been reserved
[    2.596906] system 00:01: [io  0x0ca8-0x0caf] has been reserved
[    2.603061] system 00:01: [io  0x1000-0x107f] has been reserved
[    2.609247] system 00:01: [io  0x1180-0x11bf] has been reserved
[    2.615781] system 00:01: [io  0x0800-0x080f] has been reserved
[    2.621937] system 00:01: [io  0xfe00] has been reserved
[    2.627517] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    2.634373] system 00:01: [mem 0xfee00000-0xfee0ffff] could not be reserved
[    2.641602] system 00:01: [mem 0xfec80000-0xfec80fff] could not be reserved
[    2.648819] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.655676] system 00:01: [mem 0xfe000000-0xfe01ffff] has been reserved
[    2.662555] system 00:01: [mem 0xfe600000-0xfe6fffff] has been reserved
[    2.669420] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.669432] pnp 00:02: [io  0x0000-0x001f]
[    2.669434] pnp 00:02: [io  0x0081-0x0091]
[    2.669436] pnp 00:02: [io  0x0093-0x009f]
[    2.669438] pnp 00:02: [io  0x00c0-0x00df]
[    2.669441] pnp 00:02: [dma 4]
[    2.669508] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.669519] pnp 00:03: [io  0x00f0-0x00fe]
[    2.669531] pnp 00:03: [irq 13]
[    2.669592] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.669645] pnp 00:04: [io  0x0070-0x0071]
[    2.669707] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.669717] pnp 00:05: [io  0x0061]
[    2.669780] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    2.669910] pnp 00:06: [mem 0xff000000-0xffffffff]
[    2.669974] pnp 00:06: Plug and Play ACPI device, IDs INT0800 (active)
[    2.669995] pnp 00:07: [io  0x0060]
[    2.669997] pnp 00:07: [io  0x0064]
[    2.670002] pnp 00:07: [irq 1]
[    2.670068] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    2.670089] pnp 00:08: [irq 12]
[    2.670156] pnp 00:08: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.670329] pnp 00:09: [io  0x03f8-0x03ff]
[    2.670336] pnp 00:09: [irq 4]
[    2.670444] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.670610] pnp 00:0a: [io  0x02f8-0x02ff]
[    2.670616] pnp 00:0a: [irq 3]
[    2.670722] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.670944] pnp 00:0b: [io  0x03f0-0x03f5]
[    2.670946] pnp 00:0b: [io  0x03f7]
[    2.670952] pnp 00:0b: [irq 6]
[    2.670954] pnp 00:0b: [dma 2]
[    2.671043] pnp 00:0b: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.671128] pnp: PnP ACPI: found 12 devices
[    2.675556] ACPI: ACPI bus type pnp unregistered
[    2.688705] PCI: max bus depth: 3 pci_try_num: 4
[    2.688772] pci 0000:00:02.0: BAR 15: assigned [mem 0xd8500000-0xd85fffff pref]
[    2.696549] pci 0000:01:00.0: BAR 15: assigned [mem 0xd8500000-0xd85fffff pref]
[    2.704293] pci 0000:02:02.0: BAR 15: assigned [mem 0xd8500000-0xd85fffff pref]
[    2.712068] pci 0000:02:00.0: PCI bridge to [bus 03-03]
[    2.717553] pci 0000:04:00.0: BAR 6: assigned [mem 0xd8500000-0xd850ffff pref]
[    2.725216] pci 0000:04:00.1: BAR 6: assigned [mem 0xd8510000-0xd851ffff pref]
[    2.732911] pci 0000:02:02.0: PCI bridge to [bus 04-04]
[    2.738388] pci 0000:02:02.0:   bridge window [io  0x2000-0x2fff]
[    2.744718] pci 0000:02:02.0:   bridge window [mem 0xd8200000-0xd82fffff]
[    2.751771] pci 0000:02:02.0:   bridge window [mem 0xd8500000-0xd85fffff pref]
[    2.759452] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    2.764920] pci 0000:01:00.0:   bridge window [io  0x2000-0x2fff]
[    2.771280] pci 0000:01:00.0:   bridge window [mem 0xd8200000-0xd82fffff]
[    2.778325] pci 0000:01:00.0:   bridge window [mem 0xd8500000-0xd85fffff pref]
[    2.786005] pci 0000:01:00.3: PCI bridge to [bus 05-05]
[    2.791475] pci 0000:00:02.0: PCI bridge to [bus 01-05]
[    2.796967] pci 0000:00:02.0:   bridge window [io  0x2000-0x2fff]
[    2.803297] pci 0000:00:02.0:   bridge window [mem 0xd8100000-0xd82fffff]
[    2.810348] pci 0000:00:02.0:   bridge window [mem 0xd8500000-0xd85fffff pref]
[    2.818028] pci 0000:00:04.0: PCI bridge to [bus 06-06]
[    2.823496] pci 0000:00:06.0: PCI bridge to [bus 07-07]
[    2.828996] pci 0000:09:02.0: BAR 6: assigned [mem 0xd8080000-0xd80fffff pref]
[    2.836668] pci 0000:08:00.0: PCI bridge to [bus 09-09]
[    2.842134] pci 0000:08:00.0:   bridge window [io  0x3000-0x3fff]
[    2.848492] pci 0000:08:00.0:   bridge window [mem 0xd8300000-0xd83fffff]
[    2.855522] pci 0000:08:00.0:   bridge window [mem 0xd8000000-0xd80fffff 64bit pref]
[    2.863738] pci 0000:00:1c.0: PCI bridge to [bus 08-09]
[    2.869438] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    2.875784] pci 0000:00:1c.0:   bridge window [mem 0xd8300000-0xd83fffff]
[    2.882811] pci 0000:00:1c.0:   bridge window [mem 0xd8000000-0xd80fffff 64bit pref]
[    2.891030] pci 0000:0a:01.0: BAR 6: assigned [mem 0xd8420000-0xd843ffff pref]
[    2.898705] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
[    2.904169] pci 0000:00:1e.0:   bridge window [io  0x4000-0x4fff]
[    2.910528] pci 0000:00:1e.0:   bridge window [mem 0xd8400000-0xd84fffff]
[    2.917572] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    2.925781] pci 0000:00:02.0: setting latency timer to 64
[    2.925798] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.932742] pci 0000:01:00.0: setting latency timer to 64
[    2.932748] pci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.939717] pci 0000:02:00.0: setting latency timer to 64
[    2.939728] pci 0000:02:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.946684] pci 0000:02:02.0: setting latency timer to 64
[    2.946691] pci 0000:01:00.3: setting latency timer to 64
[    2.946697] pci 0000:00:04.0: setting latency timer to 64
[    2.946702] pci 0000:00:06.0: setting latency timer to 64
[    2.946712] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.953653] pci 0000:00:1c.0: setting latency timer to 64
[    2.953661] pci 0000:08:00.0: setting latency timer to 64
[    2.953668] pci 0000:00:1e.0: setting latency timer to 64
[    2.953672] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.953675] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.953677] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.953680] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    2.953682] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    2.953685] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff]
[    2.953687] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000e3fff]
[    2.953690] pci_bus 0000:00: resource 11 [mem 0xd0000000-0xfebfffff]
[    2.953692] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    2.953695] pci_bus 0000:01: resource 1 [mem 0xd8100000-0xd82fffff]
[    2.953698] pci_bus 0000:01: resource 2 [mem 0xd8500000-0xd85fffff pref]
[    2.953700] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    2.953703] pci_bus 0000:02: resource 1 [mem 0xd8200000-0xd82fffff]
[    2.953705] pci_bus 0000:02: resource 2 [mem 0xd8500000-0xd85fffff pref]
[    2.953708] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    2.953711] pci_bus 0000:04: resource 1 [mem 0xd8200000-0xd82fffff]
[    2.953713] pci_bus 0000:04: resource 2 [mem 0xd8500000-0xd85fffff pref]
[    2.953716] pci_bus 0000:08: resource 0 [io  0x3000-0x3fff]
[    2.953719] pci_bus 0000:08: resource 1 [mem 0xd8300000-0xd83fffff]
[    2.953721] pci_bus 0000:08: resource 2 [mem 0xd8000000-0xd80fffff 64bit pref]
[    2.953724] pci_bus 0000:09: resource 0 [io  0x3000-0x3fff]
[    2.953727] pci_bus 0000:09: resource 1 [mem 0xd8300000-0xd83fffff]
[    2.953729] pci_bus 0000:09: resource 2 [mem 0xd8000000-0xd80fffff 64bit pref]
[    2.953732] pci_bus 0000:0a: resource 0 [io  0x4000-0x4fff]
[    2.953735] pci_bus 0000:0a: resource 1 [mem 0xd8400000-0xd84fffff]
[    2.953737] pci_bus 0000:0a: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
[    2.953740] pci_bus 0000:0a: resource 4 [io  0x0000-0x0cf7]
[    2.953742] pci_bus 0000:0a: resource 5 [io  0x0d00-0xffff]
[    2.953745] pci_bus 0000:0a: resource 6 [mem 0x000a0000-0x000bffff]
[    2.953747] pci_bus 0000:0a: resource 7 [mem 0x000d4000-0x000d7fff]
[    2.953750] pci_bus 0000:0a: resource 8 [mem 0x000d8000-0x000dbfff]
[    2.953752] pci_bus 0000:0a: resource 9 [mem 0x000dc000-0x000dffff]
[    2.953755] pci_bus 0000:0a: resource 10 [mem 0x000e0000-0x000e3fff]
[    2.953757] pci_bus 0000:0a: resource 11 [mem 0xd0000000-0xfebfffff]
[    2.953803] NET: Registered protocol family 2
[    2.958893] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    2.968708] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.980712] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.988219] TCP: Hash tables configured (established 524288 bind 65536)
[    2.995069] TCP reno registered
[    2.998503] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    3.004998] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    3.012039] NET: Registered protocol family 1
[    3.016708] pci 0000:00:1d.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.023647] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x003b
[    3.023649] pci 0000:00:1d.0: Performing full reset
[    3.023663] pci 0000:00:1d.0: PCI INT A disabled
[    3.028564] pci 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.035501] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    3.035503] pci 0000:00:1d.1: Performing full reset
[    3.035516] pci 0000:00:1d.1: PCI INT B disabled
[    3.040411] pci 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.047366] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    3.047368] pci 0000:00:1d.2: Performing full reset
[    3.047381] pci 0000:00:1d.2: PCI INT C disabled
[    3.052245] pci 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    3.059213] pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x0010
[    3.059215] pci 0000:00:1d.3: Performing full reset
[    3.059228] pci 0000:00:1d.3: PCI INT D disabled
[    3.064095] pci 0000:00:1d.7: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.071087] pci 0000:00:1d.7: PCI INT A disabled
[    3.075974] PCI: CLS mismatch (32 != 64), using 64 bytes
[    3.075989] pci 0000:0a:01.0: Boot video device
[    3.076054] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.082733] Placing 64MB software IO TLB between ffff8800cbf3e000 - ffff8800cff3e000
[    3.090950] software IO TLB at phys 0xcbf3e000 - 0xcff3e000
[    3.096779] Simple Boot Flag at 0x38 set to 0x1
[    3.103387] audit: initializing netlink socket (disabled)
[    3.109064] type=2000 audit(1335705788.100:1): initialized
[    3.202693] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.213536] VFS: Disk quotas dquot_6.5.2
[    3.217825] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.225722] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    3.236354] SGI XFS Quota Management subsystem
[    3.241048] msgmni has been set to 32098
[    3.245648] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.253539] io scheduler noop registered
[    3.257713] io scheduler deadline registered
[    3.262296] io scheduler cfq registered (default)
[    3.267723] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.273697] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0A03:00/PNP0C0C:00/input/input0
[    3.283299] ACPI: Power Button [PWRB]
[    3.287292] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    3.301256] ACPI: Power Button [PWRF]
[    3.307661] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.605806] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.905811] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.932904] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.959315] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.965410] Linux agpgart interface v0.103
[    3.969961] ipmi message handler version 39.2
[    3.974558] ipmi device interface
[    3.978221] IPMI System Interface driver.
[    3.982555] ipmi_si: probing via SMBIOS
[    3.986658] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[    3.992813] ipmi_si: Adding SMBIOS-specified kcs state machine
[    3.998978] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
[    4.095758] Refined TSC clocksource calibration: 2000.070 MHz.
[    4.101833] Switching to clocksource tsc
[    4.318178] ipmi_si ipmi_si.0: Found new BMC (man_id: 0x0028c5, prod_id: 0x0004, dev_id: 0x22)
[    4.327303] ipmi_si ipmi_si.0: IPMI kcs interface initialized
[    4.341340] IPMI Watchdog: driver initialized
[    4.345960] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    4.354998] IPMI poweroff: ATCA Detect mfg 0x28C5 prod 0x4
[    4.360755] IPMI poweroff: Found a chassis style poweroff function
[    4.367184] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    4.376594] Hangcheck: Using getrawmonotonic().
[    4.383554] brd: module loaded
[    4.388046] loop: module loaded
[    4.400101] vroot: loaded (max 64 devices)
[    4.404859] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    4.411963] aic94xx 0000:09:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    4.419303] aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:09:02.0
[    4.427765] scsi0 : aic94xx
[    4.431375] aic94xx: BIOS present (1,1), 1822
[    4.435997] aic94xx: ue num:4, ue size:88
[    4.456961] aic94xx: manuf sect SAS_ADDR 50030480002a8a30
[    4.462598] aic94xx: manuf sect PCBA SN ORG
[    4.467039] aic94xx: ms: num_phy_desc: 8
[    4.471208] aic94xx: ms: phy0: ENABLED
[    4.475196] aic94xx: ms: phy1: ENABLED
[    4.479208] aic94xx: ms: phy2: ENABLED
[    4.483195] aic94xx: ms: phy3: ENABLED
[    4.487199] aic94xx: ms: phy4: ENABLED
[    4.491193] aic94xx: ms: phy5: ENABLED
[    4.495181] aic94xx: ms: phy6: ENABLED
[    4.499193] aic94xx: ms: phy7: ENABLED
[    4.503188] aic94xx: ms: max_phys:0x8, num_phys:0x8
[    4.508327] aic94xx: ms: enabled_phys:0xff
[    4.523821] aic94xx: ctrla: phy0: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.534104] aic94xx: ctrla: phy1: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.544381] aic94xx: ctrla: phy2: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.554662] aic94xx: ctrla: phy3: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.564939] aic94xx: ctrla: phy4: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.575218] aic94xx: ctrla: phy5: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.585498] aic94xx: ctrla: phy6: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.595777] aic94xx: ctrla: phy7: sas_addr: 50030480002a8a30, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
[    4.606067] aic94xx: max_scbs:512, max_ddbs:128
[    4.610839] aic94xx: setting phy0 addr to 50030480002a8a30
[    4.616584] aic94xx: setting phy1 addr to 50030480002a8a30
[    4.622308] aic94xx: setting phy2 addr to 50030480002a8a30
[    4.628058] aic94xx: setting phy3 addr to 50030480002a8a30
[    4.633782] aic94xx: setting phy4 addr to 50030480002a8a30
[    4.639533] aic94xx: setting phy5 addr to 50030480002a8a30
[    4.645257] aic94xx: setting phy6 addr to 50030480002a8a30
[    4.651006] aic94xx: setting phy7 addr to 50030480002a8a30
[    4.656788] aic94xx: num_edbs:21
[    4.660256] aic94xx: num_escbs:3
[    4.663751] aic94xx: Found sequencer Firmware version 1.1 (V17/10c6)
[    4.670369] aic94xx: downloading CSEQ...
[    4.674553] aic94xx: dma-ing 8192 bytes
[    4.681496] aic94xx: verified 8192 bytes, passed
[    4.686368] aic94xx: downloading LSEQs...
[    4.690637] aic94xx: dma-ing 14336 bytes
[    4.699798] aic94xx: LSEQ0 verified 14336 bytes, passed
[    4.710043] aic94xx: LSEQ1 verified 14336 bytes, passed
[    4.720287] aic94xx: LSEQ2 verified 14336 bytes, passed
[    4.730534] aic94xx: LSEQ3 verified 14336 bytes, passed
[    4.740775] aic94xx: LSEQ4 verified 14336 bytes, passed
[    4.751020] aic94xx: LSEQ5 verified 14336 bytes, passed
[    4.761266] aic94xx: LSEQ6 verified 14336 bytes, passed
[    4.771507] aic94xx: LSEQ7 verified 14336 bytes, passed
[    4.790126] aic94xx: max_scbs:446
[    4.793686] aic94xx: first_scb_site_no:0x20
[    4.798132] aic94xx: last_scb_site_no:0x1fe
[    4.802580] aic94xx: First SCB dma_handle: 0x413de9000
[    4.808406] aic94xx: device 0000:09:02.0: SAS addr 50030480002a8a30, PCBA SN ORG, 8 phys, 8 enabled phys, flash present, BIOS build 1822
[    4.821135] aic94xx: posting 3 escbs
[    4.824955] aic94xx: escbs posted
[    4.829080] aic94xx: posting 8 control phy scbs
[    4.833940] aic94xx: control_phy_tasklet_complete: phy0, lrate:0x8, proto:0xe
[    4.841354] aic94xx: control_phy_tasklet_complete: phy1, lrate:0x8, proto:0xe
[    4.848756] aic94xx: control_phy_tasklet_complete: phy2, lrate:0x8, proto:0xe
[    4.856156] aic94xx: control_phy_tasklet_complete: phy3, lrate:0x8, proto:0xe
[    4.863531] aic94xx: control_phy_tasklet_complete: phy4: no device present: oob_status:0x0
[    4.872266] aic94xx: control_phy_tasklet_complete: phy5: no device present: oob_status:0x0
[    4.880993] aic94xx: control_phy_tasklet_complete: phy6: no device present: oob_status:0x0
[    4.889720] aic94xx: control_phy_tasklet_complete: phy7: no device present: oob_status:0x0
[    4.898441] aic94xx: escb_tasklet_complete: phy2: BYTES_DMAED
[    4.904426] aic94xx: STP proto device-to-host FIS:
[    4.909483] aic94xx: 00: 34 00 50 01
[    4.913305] aic94xx: 04: 01 00 00 00
[    4.917119] aic94xx: 08: 00 00 00 00
[    4.919481] aic94xx: 0c: 01 00 00 00
[    4.919481] aic94xx: 10: 00 00 00 00
[    4.928601] aic94xx: asd_form_port: updating phy_mask 0x4 for phy2
[    4.935030] aic94xx: escb_tasklet_complete: phy3: BYTES_DMAED
[    4.941038] aic94xx: STP proto device-to-host FIS:
[    4.946080] aic94xx: 00: 34 00 50 01
[    4.949894] aic94xx: 04: 01 00 00 00
[    4.953708] aic94xx: 08: 00 00 00 00
[    4.956079] aic94xx: 0c: 01 00 00 00
[    4.956079] aic94xx: 10: 00 00 00 00
[    4.965193] aic94xx: asd_form_port: updating phy_mask 0x8 for phy3
[    4.971634] aic94xx: escb_tasklet_complete: phy1: BYTES_DMAED
[    4.977627] aic94xx: STP proto device-to-host FIS:
[    4.982662] aic94xx: 00: 34 00 50 01
[    4.986484] aic94xx: 04: 01 00 00 00
[    4.987626] aic94xx: 08: 00 00 00 00
[    4.987626] aic94xx: 0c: 01 00 00 00
[    4.987626] aic94xx: 10: 00 00 00 00
[    5.001792] aic94xx: asd_form_port: updating phy_mask 0x2 for phy1
[    5.008233] aic94xx: escb_tasklet_complete: phy0: BYTES_DMAED
[    5.014214] aic94xx: STP proto device-to-host FIS:
[    5.019271] aic94xx: 00: 34 00 50 01
[    5.023094] aic94xx: 04: 01 00 00 00
[    5.026907] aic94xx: 08: 00 00 00 00
[    5.029269] aic94xx: 0c: 01 00 00 00
[    5.029269] aic94xx: 10: 00 00 00 00
[    5.038391] aic94xx: asd_form_port: updating phy_mask 0x1 for phy0
[    5.044863] sas: phy-0:2 added to port-0:0, phy_mask:0x4 (50030480002a8a42)
[    5.044929] sas: phy-0:3 added to port-0:1, phy_mask:0x8 (50030480002a8a43)
[    5.044992] sas: phy-0:1 added to port-0:2, phy_mask:0x2 (50030480002a8a41)
[    5.045056] sas: phy-0:0 added to port-0:3, phy_mask:0x1 (50030480002a8a40)
[    5.045065] sas: DOING DISCOVERY on port 0, pid:24
[    5.046952] sas: Enter sas_scsi_recover_host
[    5.046957] ata1: sas eh calling libata port error handler
[    5.046967] aic94xx: asd_clear_nexus_I_T: PRE
[    5.051570] aic94xx: asd_clear_nexus_I_T: POST
[    5.056280] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    5.056300] aic94xx: asd_clear_nexus_tasklet_complete: here
[    5.056303] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    5.075501] aic94xx: sending soft reset to phy-0:2
[    5.080686] aic94xx: control_phy_tasklet_complete: phy2, lrate:0x8, proto:0xe
[    5.094914] aic94xx: escb_tasklet_complete: phy2: BYTES_DMAED
[    5.100931] aic94xx: STP proto device-to-host FIS:
[    5.105973] aic94xx: 00: 34 00 50 01
[    5.109794] aic94xx: 04: 01 00 00 00
[    5.113610] aic94xx: 08: 00 00 00 00
[    5.115971] aic94xx: 0c: 01 00 00 00
[    5.115971] aic94xx: 10: 00 00 00 00
[    5.125092] aic94xx: asd_form_port: updating phy_mask 0x4 for phy2
[    5.585727] aic94xx: asd_clear_nexus_I_T: PRE
[    5.590326] aic94xx: asd_clear_nexus_I_T: POST
[    5.595015] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    5.595191] aic94xx: asd_clear_nexus_tasklet_complete: here
[    5.595194] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    5.614231] aic94xx: asd_clear_nexus_I_T: PRE
[    5.618841] aic94xx: asd_clear_nexus_I_T: POST
[    5.623528] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    5.623540] aic94xx: asd_clear_nexus_tasklet_complete: here
[    5.623542] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x13
[    5.642823] sas: sas_ata_hard_reset: Found ATA device.
[    5.645129] ata1.00: native sectors (1) is smaller than sectors (3907029168)
[    5.652456] ata1.00: ATA-8: ST32000644NS, SN11, max UDMA/133
[    5.658371] ata1.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.667357] ata1.00: configured for UDMA/133
[    5.671872] sas: --- Exit sas_scsi_recover_host
[    5.685807] scsi 0:0:0:0: Direct-Access     ATA      ST32000644NS     SN11 PQ: 0 ANSI: 5
[    5.694572] sas: DONE DISCOVERY on port 0, pid:24, result:0
[    5.694582] sas: DOING DISCOVERY on port 1, pid:24
[    5.696503] sas: Enter sas_scsi_recover_host
[    5.696506] ata1: sas eh calling libata port error handler
[    5.696513] ata2: sas eh calling libata port error handler
[    5.696518] aic94xx: asd_clear_nexus_I_T: PRE
[    5.701119] aic94xx: asd_clear_nexus_I_T: POST
[    5.705831] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    5.705851] aic94xx: asd_clear_nexus_tasklet_complete: here
[    5.705853] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    5.731164] aic94xx: sending soft reset to phy-0:3
[    5.736345] aic94xx: control_phy_tasklet_complete: phy3, lrate:0x8, proto:0xe
[    5.750930] aic94xx: escb_tasklet_complete: phy3: BYTES_DMAED
[    5.756934] aic94xx: STP proto device-to-host FIS:
[    5.761968] aic94xx: 00: 34 00 50 01
[    5.765782] aic94xx: 04: 01 00 00 00
[    5.766933] aic94xx: 08: 00 00 00 00
[    5.766933] aic94xx: 0c: 01 00 00 00
[    5.766933] aic94xx: 10: 00 00 00 00
[    5.781089] aic94xx: asd_form_port: updating phy_mask 0x8 for phy3
[    6.245738] aic94xx: asd_clear_nexus_I_T: PRE
[    6.250336] aic94xx: asd_clear_nexus_I_T: POST
[    6.255024] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    6.255200] aic94xx: asd_clear_nexus_tasklet_complete: here
[    6.255203] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    6.274233] aic94xx: asd_clear_nexus_I_T: PRE
[    6.278843] aic94xx: asd_clear_nexus_I_T: POST
[    6.283528] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    6.283540] aic94xx: asd_clear_nexus_tasklet_complete: here
[    6.283542] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x13
[    6.302822] sas: sas_ata_hard_reset: Found ATA device.
[    6.305145] ata2.00: native sectors (1) is smaller than sectors (3907029168)
[    6.312455] ata2.00: ATA-8: ST32000644NS, SN11, max UDMA/133
[    6.318362] ata2.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.327358] ata2.00: configured for UDMA/133
[    6.331873] sas: --- Exit sas_scsi_recover_host
[    6.345729] scsi 0:0:1:0: Direct-Access     ATA      ST32000644NS     SN11 PQ: 0 ANSI: 5
[    6.354793] sas: DONE DISCOVERY on port 1, pid:24, result:0
[    6.354801] sas: DOING DISCOVERY on port 2, pid:24
[    6.356463] sas: Enter sas_scsi_recover_host
[    6.356467] ata1: sas eh calling libata port error handler
[    6.356476] ata2: sas eh calling libata port error handler
[    6.356480] ata3: sas eh calling libata port error handler
[    6.356487] aic94xx: asd_clear_nexus_I_T: PRE
[    6.361085] aic94xx: asd_clear_nexus_I_T: POST
[    6.365797] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    6.365817] aic94xx: asd_clear_nexus_tasklet_complete: here
[    6.365819] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    6.385011] aic94xx: sending soft reset to phy-0:1
[    6.390133] aic94xx: control_phy_tasklet_complete: phy1, lrate:0x8, proto:0xe
[    6.433282] aic94xx: escb_tasklet_complete: phy1: BYTES_DMAED
[    6.439297] aic94xx: STP proto device-to-host FIS:
[    6.444330] aic94xx: 00: 34 00 50 01
[    6.448144] aic94xx: 04: 01 00 00 00
[    6.449295] aic94xx: 08: 00 00 00 00
[    6.449295] aic94xx: 0c: 01 00 00 00
[    6.449295] aic94xx: 10: 00 00 00 00
[    6.463452] aic94xx: asd_form_port: updating phy_mask 0x2 for phy1
[    6.895798] aic94xx: asd_clear_nexus_I_T: PRE
[    6.900396] aic94xx: asd_clear_nexus_I_T: POST
[    6.905084] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    6.905261] aic94xx: asd_clear_nexus_tasklet_complete: here
[    6.905264] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    6.924311] aic94xx: asd_clear_nexus_I_T: PRE
[    6.928921] aic94xx: asd_clear_nexus_I_T: POST
[    6.933607] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    6.933618] aic94xx: asd_clear_nexus_tasklet_complete: here
[    6.933620] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x13
[    6.952901] sas: sas_ata_hard_reset: Found ATA device.
[    6.981711] ata3.00: native sectors (1) is smaller than sectors (1953525168)
[    6.989027] ata3.00: ATA-8: ST31000340NS, SN06, max UDMA/133
[    6.994922] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.044081] ata3.00: configured for UDMA/133
[    7.048620] sas: --- Exit sas_scsi_recover_host
[    7.065802] scsi 0:0:2:0: Direct-Access     ATA      ST31000340NS     SN06 PQ: 0 ANSI: 5
[    7.074554] sas: DONE DISCOVERY on port 2, pid:24, result:0
[    7.074561] sas: DOING DISCOVERY on port 3, pid:24
[    7.076233] sas: Enter sas_scsi_recover_host
[    7.076236] ata1: sas eh calling libata port error handler
[    7.076242] ata2: sas eh calling libata port error handler
[    7.076247] ata3: sas eh calling libata port error handler
[    7.076251] ata4: sas eh calling libata port error handler
[    7.076256] aic94xx: asd_clear_nexus_I_T: PRE
[    7.080854] aic94xx: asd_clear_nexus_I_T: POST
[    7.085541] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    7.085561] aic94xx: asd_clear_nexus_tasklet_complete: here
[    7.085563] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    7.104769] aic94xx: sending soft reset to phy-0:0
[    7.109890] aic94xx: control_phy_tasklet_complete: phy0, lrate:0x8, proto:0xe
[    7.153140] aic94xx: escb_tasklet_complete: phy0: BYTES_DMAED
[    7.159151] aic94xx: STP proto device-to-host FIS:
[    7.164183] aic94xx: 00: 34 00 50 01
[    7.167997] aic94xx: 04: 01 00 00 00
[    7.169150] aic94xx: 08: 00 00 00 00
[    7.169150] aic94xx: 0c: 01 00 00 00
[    7.169150] aic94xx: 10: 00 00 00 00
[    7.183314] aic94xx: asd_form_port: updating phy_mask 0x1 for phy0
[    7.615750] aic94xx: asd_clear_nexus_I_T: PRE
[    7.620347] aic94xx: asd_clear_nexus_I_T: POST
[    7.625035] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    7.625212] aic94xx: asd_clear_nexus_tasklet_complete: here
[    7.625215] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
[    7.644259] aic94xx: asd_clear_nexus_I_T: PRE
[    7.648871] aic94xx: asd_clear_nexus_I_T: POST
[    7.653557] aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
[    7.653568] aic94xx: asd_clear_nexus_tasklet_complete: here
[    7.653571] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x13
[    7.672860] sas: sas_ata_hard_reset: Found ATA device.
[    7.701668] ata4.00: native sectors (1) is smaller than sectors (1953525168)
[    7.708985] ata4.00: ATA-8: ST31000340NS, SN06, max UDMA/133
[    7.714880] ata4.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.764070] ata4.00: configured for UDMA/133
[    7.768614] sas: --- Exit sas_scsi_recover_host
[    7.785872] scsi 0:0:3:0: Direct-Access     ATA      ST31000340NS     SN06 PQ: 0 ANSI: 5
[    7.794619] sas: DONE DISCOVERY on port 3, pid:24, result:0
[    7.794623] sas: sas_form_port: phy2 belongs to port0 already(1)!
[    7.794626] sas: sas_form_port: phy3 belongs to port1 already(1)!
[    7.794630] sas: sas_form_port: phy1 belongs to port2 already(1)!
[    7.794633] sas: sas_form_port: phy0 belongs to port3 already(1)!
[    7.794857] sd 0:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    7.794924] sd 0:0:1:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    7.795001] sd 0:0:1:0: [sdb] Write Protect is off
[    7.795004] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    7.795055] sd 0:0:2:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.795069] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.795124] sd 0:0:2:0: [sdc] Write Protect is off
[    7.795127] sd 0:0:2:0: [sdc] Mode Sense: 00 3a 00 00
[    7.795170] sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.795257] sd 0:0:3:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.795312] sd 0:0:3:0: [sdd] Write Protect is off
[    7.795315] sd 0:0:3:0: [sdd] Mode Sense: 00 3a 00 00
[    7.795339] sd 0:0:3:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.807139] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.807213] sd 0:0:1:0: Attached scsi generic sg1 type 0
[    7.807276] sd 0:0:2:0: Attached scsi generic sg2 type 0
[    7.807337] sd 0:0:3:0: Attached scsi generic sg3 type 0
[    7.807440] ata_piix 0000:00:1f.1: version 2.13
[    7.807456] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.807491] ata_piix 0000:00:1f.1: setting latency timer to 64
[    7.807974] scsi1 : ata_piix
[    7.808097] scsi2 : ata_piix
[    7.808498] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1880 irq 14
[    7.808501] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1888 irq 15
[    7.808681] ata6: port disabled--ignoring
[    7.808793] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    7.808959] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.808963] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    7.808986] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    7.809013] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    7.809018] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    7.809049] drivers/usb/core/inode.c: creating file 'devices'
[    7.809052] drivers/usb/core/inode.c: creating file '001'
[    7.809112] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    7.809120] ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
[    7.809124] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    7.809148] ehci_hcd 0000:00:1d.7: debug port 1
[    7.809155] ehci_hcd 0000:00:1d.7: reset command 0080022 (park)=0 ithresh=8 Async period=1024 Reset HALT
[    7.813026] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    7.813028] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    7.813044] ehci_hcd 0000:00:1d.7: irq 17, io mem 0xd8700000
[    7.813049] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    7.816941] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    7.966870] sd 0:0:0:0: [sda] Write Protect is off
[    7.971907] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.971939] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.981459] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    7.981485]  sdb: sdb1 sdb2 < sdb5 sdb6 sdb7 >
[    7.992192]  sdc: sdc1 sdc2 < sdc5 sdc6 sdc7 >
[    7.992212] usb usb1: default language 0x0409
[    7.992219] usb usb1: udev 1, busnum 1, minor = 0
[    7.992221] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.992224] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.992226] usb usb1: Product: EHCI Host Controller
[    7.992228] usb usb1: Manufacturer: Linux 3.2.15-00013-g9c7edc7 ehci_hcd
[    7.992230] usb usb1: SerialNumber: 0000:00:1d.7
[    7.992315] usb usb1: usb_probe_device
[    7.992318] usb usb1: configuration #1 chosen from 1 choice
[    7.992325] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    7.992384] hub 1-0:1.0: usb_probe_interface
[    7.992386] hub 1-0:1.0: usb_probe_interface - got id
[    7.992388] hub 1-0:1.0: USB hub found
[    7.992393] hub 1-0:1.0: 8 ports detected
[    7.992395] hub 1-0:1.0: standalone hub
[    7.992396] hub 1-0:1.0: no power switching (usb 1.0)
[    7.992398] hub 1-0:1.0: individual port over-current protection
[    7.992400] hub 1-0:1.0: power on to power good time: 20ms
[    7.992404] hub 1-0:1.0: local power source is good
[    7.992407] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    7.992447] drivers/usb/core/inode.c: creating file '001'
[    7.992520] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.992523] ohci_hcd: block sizes: ed 80 td 96
[    7.992573] uhci_hcd: USB Universal Host Controller Interface driver
[    7.992599] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    7.992606] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    7.992609] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    7.992615] drivers/usb/core/inode.c: creating file '002'
[    7.992674] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    7.992681] uhci_hcd 0000:00:1d.0: detected 2 ports
[    7.992686] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    7.992688] uhci_hcd 0000:00:1d.0: Performing full reset
[    7.992703] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    7.992708] uhci_hcd 0000:00:1d.0: irq 17, io base 0x00001800
[    7.992745] usb usb2: default language 0x0409
[    7.992752] usb usb2: udev 1, busnum 2, minor = 128
[    7.992754] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    7.992756] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.992758] usb usb2: Product: UHCI Host Controller
[    7.992760] usb usb2: Manufacturer: Linux 3.2.15-00013-g9c7edc7 uhci_hcd
[    7.992762] usb usb2: SerialNumber: 0000:00:1d.0
[    7.992834] usb usb2: usb_probe_device
[    7.992836] usb usb2: configuration #1 chosen from 1 choice
[    7.992842] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    7.992895] hub 2-0:1.0: usb_probe_interface
[    7.992897] hub 2-0:1.0: usb_probe_interface - got id
[    7.992899] hub 2-0:1.0: USB hub found
[    7.992903] hub 2-0:1.0: 2 ports detected
[    7.992905] hub 2-0:1.0: standalone hub
[    7.992906] hub 2-0:1.0: no power switching (usb 1.0)
[    7.992908] hub 2-0:1.0: individual port over-current protection
[    7.992910] hub 2-0:1.0: power on to power good time: 2ms
[    7.992914] hub 2-0:1.0: local power source is good
[    7.992915] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    7.992931] drivers/usb/core/inode.c: creating file '001'
[    7.992964] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    7.992971] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    7.992974] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    7.992980] drivers/usb/core/inode.c: creating file '003'
[    7.993043] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    7.993050] uhci_hcd 0000:00:1d.1: detected 2 ports
[    7.993055] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    7.993057] uhci_hcd 0000:00:1d.1: Performing full reset
[    7.993072] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    7.993088] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001820
[    7.993120] usb usb3: default language 0x0409
[    7.993126] usb usb3: udev 1, busnum 3, minor = 256
[    7.993128] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    7.993131] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.993133] usb usb3: Product: UHCI Host Controller
[    7.993134] usb usb3: Manufacturer: Linux 3.2.15-00013-g9c7edc7 uhci_hcd
[    7.993136] usb usb3: SerialNumber: 0000:00:1d.1
[    7.993209] usb usb3: usb_probe_device
[    7.993212] usb usb3: configuration #1 chosen from 1 choice
[    7.993218] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    7.993271] hub 3-0:1.0: usb_probe_interface
[    7.993273] hub 3-0:1.0: usb_probe_interface - got id
[    7.993275] hub 3-0:1.0: USB hub found
[    7.993279] hub 3-0:1.0: 2 ports detected
[    7.993280] hub 3-0:1.0: standalone hub
[    7.993282] hub 3-0:1.0: no power switching (usb 1.0)
[    7.993283] hub 3-0:1.0: individual port over-current protection
[    7.993285] hub 3-0:1.0: power on to power good time: 2ms
[    7.993289] hub 3-0:1.0: local power source is good
[    7.993291] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    7.993306] drivers/usb/core/inode.c: creating file '001'
[    7.993337] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    7.993345] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    7.993348] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    7.993355] drivers/usb/core/inode.c: creating file '004'
[    7.993409] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    7.993417] uhci_hcd 0000:00:1d.2: detected 2 ports
[    7.993421] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    7.993423] uhci_hcd 0000:00:1d.2: Performing full reset
[    7.993438] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    7.993444] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
[    7.993474] usb usb4: default language 0x0409
[    7.993481] usb usb4: udev 1, busnum 4, minor = 384
[    7.993483] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    7.993485] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.993487] usb usb4: Product: UHCI Host Controller
[    7.993489] usb usb4: Manufacturer: Linux 3.2.15-00013-g9c7edc7 uhci_hcd
[    7.993491] usb usb4: SerialNumber: 0000:00:1d.2
[    7.993564] usb usb4: usb_probe_device
[    7.993566] usb usb4: configuration #1 chosen from 1 choice
[    7.993572] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    7.993626] hub 4-0:1.0: usb_probe_interface
[    7.993628] hub 4-0:1.0: usb_probe_interface - got id
[    7.993630] hub 4-0:1.0: USB hub found
[    7.993640] hub 4-0:1.0: 2 ports detected
[    7.993641] hub 4-0:1.0: standalone hub
[    7.993643] hub 4-0:1.0: no power switching (usb 1.0)
[    7.993644] hub 4-0:1.0: individual port over-current protection
[    7.993646] hub 4-0:1.0: power on to power good time: 2ms
[    7.993650] hub 4-0:1.0: local power source is good
[    7.993652] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    7.993667] drivers/usb/core/inode.c: creating file '001'
[    7.993704] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    7.993710] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    7.993714] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    7.993719] drivers/usb/core/inode.c: creating file '005'
[    7.993779] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    7.993786] uhci_hcd 0000:00:1d.3: detected 2 ports
[    7.993791] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
[    7.993793] uhci_hcd 0000:00:1d.3: Performing full reset
[    7.993808] uhci_hcd 0000:00:1d.3: supports USB remote wakeup
[    7.993822] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001860
[    7.993853] usb usb5: default language 0x0409
[    7.993859] usb usb5: udev 1, busnum 5, minor = 512
[    7.993862] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    7.993864] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.993866] usb usb5: Product: UHCI Host Controller
[    7.993868] usb usb5: Manufacturer: Linux 3.2.15-00013-g9c7edc7 uhci_hcd
[    7.993870] usb usb5: SerialNumber: 0000:00:1d.3
[    7.993943] usb usb5: usb_probe_device
[    7.993946] usb usb5: configuration #1 chosen from 1 choice
[    7.993952] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    7.994004] hub 5-0:1.0: usb_probe_interface
[    7.994006] hub 5-0:1.0: usb_probe_interface - got id
[    7.994008] hub 5-0:1.0: USB hub found
[    7.994012] hub 5-0:1.0: 2 ports detected
[    7.994013] hub 5-0:1.0: standalone hub
[    7.994015] hub 5-0:1.0: no power switching (usb 1.0)
[    7.994016] hub 5-0:1.0: individual port over-current protection
[    7.994018] hub 5-0:1.0: power on to power good time: 2ms
[    7.994022] hub 5-0:1.0: local power source is good
[    7.994024] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    7.994037] drivers/usb/core/inode.c: creating file '001'
[    7.994106] Initializing USB Mass Storage driver...
[    7.994169] usbcore: registered new interface driver usb-storage
[    7.994170] USB Mass Storage support registered.
[    7.994290] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    8.002793]  sdd: sdd1 sdd2 < sdd5 sdd6 sdd7 >
[    8.085697] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001803 0  ACK POWER sig=j CSC CONNECT
[    8.085700] hub 1-0:1.0: port 7: status 0501 change 0001
[    8.085744] uhci_hcd 0000:00:1d.3: port 1 portsc 008a,00
[    8.246030] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.246123] mousedev: PS/2 mouse device common for all mice
[    8.246292] rtc_cmos 00:04: RTC can wake from S4
[    8.246409] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    8.246439] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    8.246481] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[    8.246603] iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0x1060)
[    8.246619] iTCO_wdt: cannot register miscdev on minor=130 (err=-16)
[    8.246638] iTCO_wdt: probe of iTCO_wdt failed with error -16
[    8.246641] iTCO_vendor_support: vendor-support=0
[    8.246643] SoftDog: cannot register miscdev on minor=130 (err=-16)
[    8.246647] md: linear personality registered for level -1
[    8.246649] md: raid0 personality registered for level 0
[    8.246651] md: raid1 personality registered for level 1
[    8.246653] md: raid10 personality registered for level 10
[    8.246655] md: raid6 personality registered for level 6
[    8.246656] md: raid5 personality registered for level 5
[    8.246658] md: raid4 personality registered for level 4
[    8.246801] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    8.247017] EDAC MC: Ver: 2.1.0
[    8.247484] EDAC MC0: Giving out device to 'i5000_edac.c' 'I5000': DEV 0000:00:10.0
[    8.247570] EDAC PCI0: Giving out device to module 'i5000_edac' controller 'EDAC PCI controller': DEV '0000:00:10.0' (POLLED)
[    8.248278] AMD64 EDAC driver v3.4.0
[    8.248396] cpuidle: using governor ladder
[    8.248398] No iBFT detected.
[    8.249040] usbcore: registered new interface driver usbhid
[    8.249041] usbhid: USB HID core driver
[    8.249271] TCP cubic registered
[    8.249273] Initializing XFRM netlink socket
[    8.249557] NET: Registered protocol family 10
[    8.250006] IPv6 over IPv4 tunneling driver
[    8.250502] NET: Registered protocol family 17
[    8.250534] Bridge firewalling registered
[    8.250538] 8021q: 802.1Q VLAN Support v1.8
[    8.250544] Registering the dns_resolver key type
[    8.250573] registered taskstats version 1
[    8.572114] console [netcon0] enabled
[    8.572334] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.572339] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.572342] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.572345] hub 1-0:1.0: state 7 ports 8 chg 0080 evt 0000
[    8.572359] hub 1-0:1.0: port 7, status 0501, change 0000, 480 Mb/s
[    8.572508] sd 0:0:3:0: [sdd] Attached SCSI disk
[    8.572827] sd 0:0:1:0: [sdb] Attached SCSI disk
[    8.585882] netconsole: network logging started
[    8.586169] ata5.00: ATAPI: DV-28E-V, 1.AB, max UDMA/33
[    8.586683] sd 0:0:2:0: [sdc] Attached SCSI disk
[    8.603570]  sda: sda1 sda2 < sda5 sda6 sda7 >
[    8.608825] sd 0:0:0:0: [sda] Attached SCSI disk
[    8.626093] ehci_hcd 0000:00:1d.7: port 7 high speed
[    8.626099] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    8.626274] ata5.00: configured for UDMA/33
[    8.639451] scsi 1:0:0:0: CD-ROM            TEAC     DV-28E-V         1.AB PQ: 0 ANSI: 5
[    8.659272] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[    8.665692] cdrom: Uniform CD-ROM driver Revision: 3.20
[    8.671351] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    8.671509] sr 1:0:0:0: Attached scsi generic sg4 type 5
[    8.677156] md: Waiting for all devices to be available before autodetect
[    8.684181] md: If you don't use raid, use raid=noautodetect
[    8.685786] usb 1-7: new high-speed USB device number 2 using ehci_hcd
[    8.685849] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    8.696894] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    8.697094] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    8.697149] md: Autodetecting RAID arrays.
[    8.756094] ehci_hcd 0000:00:1d.7: port 7 high speed
[    8.756100] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    8.815834] usb 1-7: device descriptor read/64, error -71
[    8.835149] md: Scanned 16 and added 16 devices.
[    8.840035] md: autorun ...
[    8.843070] md: considering sda7 ...
[    8.846913] md:  adding sda7 ...
[    8.850384] md: sda6 has different UUID to sda7
[    8.855158] md: sda5 has different UUID to sda7
[    8.859961] md: sda1 has different UUID to sda7
[    8.864732] md: sdc7 has different UUID to sda7
[    8.869529] md: sdc6 has different UUID to sda7
[    8.874302] md: sdc5 has different UUID to sda7
[    8.879097] md: sdc1 has different UUID to sda7
[    8.883868] md: sdd7 has different UUID to sda7
[    8.888665] md: sdd6 has different UUID to sda7
[    8.893437] md: sdd5 has different UUID to sda7
[    8.898232] md: sdd1 has different UUID to sda7
[    8.903008] md:  adding sdb7 ...
[    8.906500] md: sdb6 has different UUID to sda7
[    8.911273] md: sdb5 has different UUID to sda7
[    8.916068] md: sdb1 has different UUID to sda7
[    8.921029] md: created md21
[    8.924153] md: bind<sdb7>
[    8.927138] md: bind<sda7>
[    8.930101] md: running: <sda7><sdb7>
[    8.934271] bio: create slab <bio-1> at 1
[    8.935972] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    8.938554] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    8.938634] md/raid1:md21: active with 2 out of 2 mirrors
[    8.938717] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    8.944291] md21: detected capacity change from 0 to 1987186393088
[    8.950786] md: considering sda6 ...
[    8.954610] md:  adding sda6 ...
[    8.958129] md: sda5 has different UUID to sda6
[    8.962900] md: sda1 has different UUID to sda6
[    8.967696] md: sdc7 has different UUID to sda6
[    8.972471] md:  adding sdc6 ...
[    8.975963] md: sdc5 has different UUID to sda6
[    8.980737] md: sdc1 has different UUID to sda6
[    8.985510] md: sdd7 has different UUID to sda6
[    8.990316] md:  adding sdd6 ...
[    8.993791] md: sdd5 has different UUID to sda6
[    8.998586] md: sdd1 has different UUID to sda6
[    9.003357] md:  adding sdb6 ...
[    9.006094] ehci_hcd 0000:00:1d.7: port 7 high speed
[    9.006098] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    9.006855] md: sdb5 has different UUID to sda6
[    9.011624] md: sdb1 has different UUID to sda6
[    9.016592] md: created md11
[    9.019721] md: bind<sdb6>
[    9.022678] md: bind<sdd6>
[    9.025637] md: bind<sdc6>
[    9.028622] md: bind<sda6>
[    9.031587] md: running: <sda6><sdc6><sdd6><sdb6>
[    9.036990] md/raid1:md11: active with 4 out of 4 mirrors
[    9.042646] md11: detected capacity change from 0 to 12584550400
[    9.048966] md: considering sda5 ...
[    9.052786] md:  adding sda5 ...
[    9.056280] md: sda1 has different UUID to sda5
[    9.061050] md: sdc7 has different UUID to sda5
[    9.065838] usb 1-7: device descriptor read/64, error -71
[    9.071489] md: sdc5 has different UUID to sda5
[    9.076271] md: sdc1 has different UUID to sda5
[    9.081045] md: sdd7 has different UUID to sda5
[    9.085843] md: sdd5 has different UUID to sda5
[    9.090612] md: sdd1 has different UUID to sda5
[    9.095389] md:  adding sdb5 ...
[    9.098892] md: sdb1 has different UUID to sda5
[    9.103836] md: created md15
[    9.106978] md: bind<sdb5>
[    9.109932] md: bind<sda5>
[    9.112890] md: running: <sda5><sdb5>
[    9.117135] md/raid1:md15: active with 2 out of 2 mirrors
[    9.122793] md15: detected capacity change from 0 to 518062080
[    9.128941] md: considering sda1 ...
[    9.132762] md:  adding sda1 ...
[    9.136256] md: sdc7 has different UUID to sda1
[    9.141026] md: sdc5 has different UUID to sda1
[    9.145823] md:  adding sdc1 ...
[    9.149298] md: sdd7 has different UUID to sda1
[    9.154073] md: sdd5 has different UUID to sda1
[    9.158875] md:  adding sdd1 ...
[    9.162350] md:  adding sdb1 ...
[    9.166006] md: created md10
[    9.169134] md: bind<sdb1>
[    9.172094] md: bind<sdd1>
[    9.175051] md: bind<sdc1>
[    9.178036] md: bind<sda1>
[    9.181000] md: running: <sda1><sdc1><sdd1><sdb1>
[    9.186406] md/raid1:md10: active with 4 out of 4 mirrors
[    9.192059] md10: detected capacity change from 0 to 106823680
[    9.198209] md: considering sdc7 ...
[    9.202026] md:  adding sdc7 ...
[    9.205501] md: sdc5 has different UUID to sdc7
[    9.210310] usb usb2: suspend_rh (auto-stop)
[    9.210329] usb usb3: suspend_rh (auto-stop)
[    9.210348] usb usb4: suspend_rh (auto-stop)
[    9.210366] usb usb5: suspend_rh (auto-stop)
[    9.210382] md:  adding sdd7 ...
[    9.213855] md: sdd5 has different UUID to sdc7
[    9.218829] md: created md22
[    9.221958] md: bind<sdd7>
[    9.224917] md: bind<sdc7>
[    9.227895] md: running: <sdc7><sdd7>
[    9.232115] md/raid1:md22: active with 2 out of 2 mirrors
[    9.236095] ehci_hcd 0000:00:1d.7: port 7 high speed
[    9.236099] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    9.237794] md22: detected capacity change from 0 to 986992345088
[    9.244175] md: considering sdc5 ...
[    9.248015] md:  adding sdc5 ...
[    9.251487] md:  adding sdd5 ...
[    9.255132] md: created md14
[    9.258282] md: bind<sdd5>
[    9.267365] md: bind<sdc5>
[    9.270326] md: running: <sdc5><sdd5>
[    9.274554] md/raid1:md14: active with 2 out of 2 mirrors
[    9.280234] md14: detected capacity change from 0 to 518062080
[    9.286357] md: ... autorun DONE.
[    9.290384]  md11: unknown partition table
[    9.295847] usb 1-7: new high-speed USB device number 3 using ehci_hcd
[    9.302710] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    9.302959] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    9.303208] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    9.322324] kjournald starting.  Commit interval 5 seconds
[    9.322343] EXT3-fs (md11): mounted filesystem with writeback data mode
[    9.322352] VFS: Mounted root (ext3 filesystem) readonly on device 9:11.
[    9.343809] Freeing unused kernel memory: 860k freed
[    9.349232] Write protecting the kernel read-only data: 10240k
[    9.355833] ehci_hcd 0000:00:1d.7: port 7 high speed
[    9.355833] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    9.359300] Freeing unused kernel memory: 948k freed
[    9.371612] Freeing unused kernel memory: 1696k freed
[    9.415846] usb 1-7: device descriptor read/64, error -71
[    9.525973] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    9.526222] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    9.526471] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[    9.585968] ehci_hcd 0000:00:1d.7: port 7 high speed
[    9.585974] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    9.645711] usb 1-7: device descriptor read/64, error -71
[    9.697429] modprobe used greatest stack depth: 4552 bytes left
[    9.815969] ehci_hcd 0000:00:1d.7: port 7 high speed
[    9.815975] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    9.875713] usb 1-7: new high-speed USB device number 4 using ehci_hcd
[    9.882585] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[   10.011807] sed used greatest stack depth: 4328 bytes left
[   10.085850] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[   10.159994] mount used greatest stack depth: 3016 bytes left
[   10.295717] usb 1-7: device not accepting address 4, error -71
[   10.355850] ehci_hcd 0000:00:1d.7: port 7 high speed
[   10.355850] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   10.402457] udevd (1196): /proc/1196/oom_adj is deprecated, please use /proc/1196/oom_score_adj instead.
[   10.415869] usb 1-7: new high-speed USB device number 5 using ehci_hcd
[   10.422961] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[   10.522048] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[   10.528470] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[   10.534747] e1000e 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   10.542006] e1000e 0000:04:00.0: setting latency timer to 64
[   10.542104] e1000e 0000:04:00.0: (unregistered net_device): CRC Stripping Disabled
[   10.550187] e1000e 0000:04:00.0: irq 64 for MSI/MSI-X
[   10.625978] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[   10.671483] e1000e 0000:04:00.0: eth0: (PCI Express:2.5GT/s:Width x4) 00:30:48:d5:5a:4a
[   10.680012] e1000e 0000:04:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   10.687326] e1000e 0000:04:00.0: eth0: MAC: 5, PHY: 5, PBA No: 2050FF-0FF
[   10.694372] e1000e 0000:04:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   10.701618] e1000e 0000:04:00.1: setting latency timer to 64
[   10.701711] e1000e 0000:04:00.1: (unregistered net_device): CRC Stripping Disabled
[   10.709801] e1000e 0000:04:00.1: irq 65 for MSI/MSI-X
[   10.833057] e1000e 0000:04:00.1: eth1: (PCI Express:2.5GT/s:Width x4) 00:30:48:d5:5a:4b
[   10.841539] e1000e 0000:04:00.1: eth1: Intel(R) PRO/1000 Network Connection
[   10.841534] usb 1-7: device not accepting address 5, error -71
[   10.841552] hub 1-0:1.0: unable to enumerate USB device on port 7
[   10.861267] e1000e 0000:04:00.1: eth1: MAC: 5, PHY: 5, PBA No: 2050FF-0FF
[   10.875722] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   10.875726] hub 1-0:1.0: state 7 ports 8 chg 0000 evt fe80
[   10.875734] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 003002 0  ACK POWER OWNER sig=se0 CSC
[   10.875740] hub 1-0:1.0: port 7, status 0100, change 0001, 12 Mb/s
[   10.955744] usb usb5: wakeup_rh (auto-start)
[   11.035733] hub 1-0:1.0: debounce: port 7: total 100ms stable 100ms status 0x100
[   11.035739] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0002
[   11.035746] uhci_hcd 0000:00:1d.3: port 1 portsc 0093,00
[   11.035753] hub 5-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[   11.195739] hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[   11.246975]  md14: unknown partition table
[   11.251705] Adding 505916k swap on /dev/md14.  Priority:-1 extents:1 across:505916k 
[   11.260558]  md15: unknown partition table
[   11.265233] Adding 505916k swap on /dev/md15.  Priority:-2 extents:1 across:505916k 
[   11.315747] usb 5-1: new full-speed USB device number 2 using uhci_hcd
[   11.382061] EXT3-fs (md11): using internal journal
[   11.475747] usb 5-1: not running at top speed; connect to a high speed hub
[   11.493754] usb 5-1: skipped 1 descriptor after interface
[   11.493758] usb 5-1: skipped 1 descriptor after interface
[   11.499754] usb 5-1: default language 0x0409
[   11.518755] usb 5-1: udev 2, busnum 5, minor = 513
[   11.518758] usb 5-1: New USB device found, idVendor=14dd, idProduct=0002
[   11.525847] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   11.533344] usb 5-1: Product: Multidevice
[   11.537745] usb 5-1: Manufacturer: Peppercon AG
[   11.542639] usb 5-1: SerialNumber: 0083c601aa48d2d18A62C7F7C61EBFAA
[   11.549368] usb 5-1: usb_probe_device
[   11.549372] usb 5-1: configuration #1 chosen from 1 choice
[   11.555768] usb 5-1: adding 5-1:1.0 (config #1, interface 0)
[   11.555803] usb-storage 5-1:1.0: usb_probe_interface
[   11.555809] usb-storage 5-1:1.0: usb_probe_interface - got id
[   11.555881] scsi3 : usb-storage 5-1:1.0
[   11.560160] usb 5-1: adding 5-1:1.1 (config #1, interface 1)
[   11.560186] usb-storage 5-1:1.1: usb_probe_interface
[   11.560191] usb-storage 5-1:1.1: usb_probe_interface - got id
[   11.560238] scsi4 : usb-storage 5-1:1.1
[   11.564492] usb 5-1: adding 5-1:1.2 (config #1, interface 2)
[   11.564519] usbhid 5-1:1.2: usb_probe_interface
[   11.564522] usbhid 5-1:1.2: usb_probe_interface - got id
[   11.570826] input: Peppercon AG Multidevice as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.2/input/input2
[   11.581512] generic-usb 0003:14DD:0002.0001: input,hidraw0: USB HID v1.01 Mouse [Peppercon AG Multidevice] on usb-0000:00:1d.3-1/input2
[   11.594387] usb 5-1: adding 5-1:1.3 (config #1, interface 3)
[   11.594429] usbhid 5-1:1.3: usb_probe_interface
[   11.594432] usbhid 5-1:1.3: usb_probe_interface - got id
[   11.598988] input: Peppercon AG Multidevice as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.3/input/input3
[   11.609609] uhci_hcd 0000:00:1d.3: reserve dev 2 ep86-INT, period 8, phase 4, 61 us
[   11.609650] generic-usb 0003:14DD:0002.0002: input,hidraw1: USB HID v1.01 Keyboard [Peppercon AG Multidevice] on usb-0000:00:1d.3-1/input3
[   11.622772] drivers/usb/core/inode.c: creating file '002'
[   12.507160]  md10: unknown partition table
[   12.561783] scsi 4:0:0:0: CD-ROM            PepperC  Virtual Disc 2   0.01 PQ: 0 ANSI: 3
[   12.570451] scsi 3:0:0:0: CD-ROM            PepperC  Virtual Disc 1   0.01 PQ: 0 ANSI: 3
[   12.583441]  md21: unknown partition table
[   12.602759] sr1: scsi-1 drive
[   12.606124] sr 4:0:0:0: Attached scsi CD-ROM sr1
[   12.606173] sr 4:0:0:0: Attached scsi generic sg5 type 5
[   12.611793] sr2: scsi-1 drive
[   12.613775]  md22: unknown partition table
[   12.619467] sr 3:0:0:0: Attached scsi CD-ROM sr2
[   12.619507] sr 3:0:0:0: Attached scsi generic sg6 type 5
[   13.752186] XFS (dm-10): Mounting Filesystem
[   13.917507] XFS (dm-10): Ending clean mount
[   14.259235] ip_tables: (C) 2000-2006 Netfilter Core Team
[   14.284931] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   15.226378] ipt_account 0.1.21 : Piotr Gasidlo <quaker@barbara.eu.org>, http://www.barbara.eu.org/~quaker/ipt_account/
[   15.976085] e1000e 0000:04:00.1: irq 65 for MSI/MSI-X
[   16.035944] e1000e 0000:04:00.1: irq 65 for MSI/MSI-X
[   16.038345] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   16.044110] 8021q: adding VLAN 0 to HW filter on device eth1
[   16.096130] e1000e 0000:04:00.0: irq 64 for MSI/MSI-X
[   16.155995] e1000e 0000:04:00.0: irq 64 for MSI/MSI-X
[   16.158395] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   16.163953] 8021q: adding VLAN 0 to HW filter on device eth0
[   16.271222] ADDRCONF(NETDEV_UP): eth0.20: link is not ready
[   19.118371] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   19.128988] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   19.137277] ADDRCONF(NETDEV_CHANGE): eth0.20: link becomes ready
[   29.156156] eth0: no IPv6 routers present
[   29.916167] eth0.20: no IPv6 routers present

* attached an ISO image (visible as one of two virtual CD-ROM drives) *

[   95.688794] usb 5-1: uhci_result_common: failed with status 440000
[   95.688813] uhci_hcd 0000:00:1d.3: release dev 2 ep86-INT, period 8, phase 4, 61 us
[   95.705096] hub 1-0:1.0: state 7 ports 8 chg 0000 evt ff80
[   95.705112] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001803 0  ACK POWER sig=j CSC CONNECT
[   95.705124] hub 1-0:1.0: port 7, status 0501, change 0001, 480 Mb/s
[   95.707183] uhci_hcd 0000:00:1d.3: reserve dev 2 ep86-INT, period 8, phase 4, 61 us
[   95.728790] usb 5-1: uhci_result_common: failed with status 440000
[   95.728799] uhci_hcd 0000:00:1d.3: release dev 2 ep86-INT, period 8, phase 4, 61 us
[   95.757188] uhci_hcd 0000:00:1d.3: reserve dev 2 ep86-INT, period 8, phase 4, 61 us
[   95.776778] usb 5-1: uhci_result_common: failed with status 440000
[   95.776794] uhci_hcd 0000:00:1d.3: release dev 2 ep86-INT, period 8, phase 4, 61 us
[   95.827239] uhci_hcd 0000:00:1d.3: reserve dev 2 ep86-INT, period 8, phase 4, 61 us
[   95.848791] usb 5-1: uhci_result_common: failed with status 440000
[   95.848800] uhci_hcd 0000:00:1d.3: release dev 2 ep86-INT, period 8, phase 4, 61 us
[   95.857227] hub 1-0:1.0: debounce: port 7: total 100ms stable 100ms status 0x501
[   95.917385] ehci_hcd 0000:00:1d.7: port 7 high speed
[   95.917390] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   95.957181] uhci_hcd 0000:00:1d.3: reserve dev 2 ep86-INT, period 8, phase 4, 61 us
[   95.976776] usb 5-1: uhci_result_common: failed with status 440000
[   95.976786] uhci_hcd 0000:00:1d.3: release dev 2 ep86-INT, period 8, phase 4, 61 us
[   95.977196] usb 1-7: new high-speed USB device number 6 using ehci_hcd
[   95.984252] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[   95.984500] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[   95.984749] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[   96.037508] ehci_hcd 0000:00:1d.7: port 7 high speed
[   96.037514] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   96.077241] uhci_hcd 0000:00:1d.3: reserve dev 2 ep86-INT, period 8, phase 4, 61 us
[   96.096775] usb 5-1: uhci_result_common: failed with status 440000
[   96.096783] uhci_hcd 0000:00:1d.3: release dev 2 ep86-INT, period 8, phase 4, 61 us
[   96.097198] usb 1-7: device descriptor read/64, error -71
[   96.197103] uhci_hcd 0000:00:1d.3: reserve dev 2 ep86-INT, period 8, phase 4, 61 us
[   96.207262] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[   96.207512] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[   96.207762] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[   96.216776] usb 5-1: uhci_result_common: failed with status 440000
[   96.216785] uhci_hcd 0000:00:1d.3: release dev 2 ep86-INT, period 8, phase 4, 61 us
[   96.267384] ehci_hcd 0000:00:1d.7: port 7 high speed
[   96.267389] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   96.317196] uhci_hcd 0000:00:1d.3: reserve dev 2 ep86-INT, period 8, phase 4, 61 us
[   96.327203] usb 1-7: device descriptor read/64, error -71
[   96.336775] usb 5-1: uhci_result_common: failed with status 440000
[   96.336782] uhci_hcd 0000:00:1d.3: release dev 2 ep86-INT, period 8, phase 4, 61 us
[   96.437189] uhci_hcd 0000:00:1d.3: reserve dev 2 ep86-INT, period 8, phase 4, 61 us
[   96.456775] usb 5-1: uhci_result_common: failed with status 440000
[   96.456783] uhci_hcd 0000:00:1d.3: release dev 2 ep86-INT, period 8, phase 4, 61 us
[   96.497385] ehci_hcd 0000:00:1d.7: port 7 high speed
[   96.497390] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   96.557193] usb 1-7: new high-speed USB device number 7 using ehci_hcd
[   96.557199] uhci_hcd 0000:00:1d.3: reserve dev 2 ep86-INT, period 8, phase 4, 61 us
[   96.564000] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[   96.564249] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[   96.564500] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[   96.576775] usb 5-1: uhci_result_common: failed with status 440000
[   96.576785] uhci_hcd 0000:00:1d.3: release dev 2 ep86-INT, period 8, phase 4, 61 us
[   96.617385] ehci_hcd 0000:00:1d.7: port 7 high speed
[   96.617390] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   96.677191] uhci_hcd 0000:00:1d.3: reserve dev 2 ep86-INT, period 8, phase 4, 61 us
[   96.677204] usb 1-7: device descriptor read/64, error -71
[   96.696775] usb 5-1: uhci_result_common: failed with status 440000
[   96.696783] uhci_hcd 0000:00:1d.3: release dev 2 ep86-INT, period 8, phase 4, 61 us
[   96.787263] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[   96.787513] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[   96.787762] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[   96.797195] uhci_hcd 0000:00:1d.3: reserve dev 2 ep86-INT, period 8, phase 4, 61 us
[   96.816775] usb 5-1: uhci_result_common: failed with status 440000
[   96.816784] uhci_hcd 0000:00:1d.3: release dev 2 ep86-INT, period 8, phase 4, 61 us
[   96.847509] ehci_hcd 0000:00:1d.7: port 7 high speed
[   96.847515] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   96.907208] usb 1-7: device descriptor read/64, error -71
[   97.077229] hub 5-0:1.0: logical disconnect on port 1
[   97.137384] ehci_hcd 0000:00:1d.7: port 7 high speed
[   97.137390] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   97.197205] usb 1-7: new high-speed USB device number 8 using ehci_hcd
[   97.204126] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[   97.407264] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[   97.617205] usb 1-7: device not accepting address 8, error -71
[   97.677510] ehci_hcd 0000:00:1d.7: port 7 high speed
[   97.677515] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   97.737212] usb 1-7: new high-speed USB device number 9 using ehci_hcd
[   97.744125] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[   97.947264] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[   98.157212] usb 1-7: device not accepting address 9, error -71
[   98.163297] hub 1-0:1.0: unable to enumerate USB device on port 7
[   98.187222] hub 5-0:1.0: state 7 ports 2 chg 0002 evt 0002
[   98.187229] uhci_hcd 0000:00:1d.3: port 1 portsc 0093,00
[   98.187236] hub 5-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[   98.187239] usb 5-1: USB disconnect, device number 2
[   98.192446] usb 5-1: unregistering device
[   98.192449] usb 5-1: unregistering interface 5-1:1.0
[   98.192970] usb 5-1: unregistering interface 5-1:1.1
[   98.193313] usb 5-1: unregistering interface 5-1:1.2
[   98.267316] usb 5-1: unregistering interface 5-1:1.3
[   98.377310] usb 5-1: usb_disable_device nuking all URBs
[   98.537227] hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[   98.657225] usb 5-1: new full-speed USB device number 3 using uhci_hcd
[   98.816786] usb 5-1: not running at top speed; connect to a high speed hub
[   98.834796] usb 5-1: skipped 1 descriptor after interface
[   98.834800] usb 5-1: skipped 1 descriptor after interface
[   98.840798] usb 5-1: default language 0x0409
[   98.859800] usb 5-1: udev 3, busnum 5, minor = 514
[   98.859803] usb 5-1: New USB device found, idVendor=14dd, idProduct=0002
[   98.866751] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   98.874161] usb 5-1: Product: Multidevice
[   98.878424] usb 5-1: Manufacturer: Peppercon AG
[   98.883195] usb 5-1: SerialNumber: 0083c601aa48d2d18A62C7F7C61EBFAA
[   98.889778] usb 5-1: usb_probe_device
[   98.889782] usb 5-1: configuration #1 chosen from 1 choice
[   98.893796] usb 5-1: adding 5-1:1.0 (config #1, interface 0)
[   98.893831] usb-storage 5-1:1.0: usb_probe_interface
[   98.893837] usb-storage 5-1:1.0: usb_probe_interface - got id
[   98.893900] scsi5 : usb-storage 5-1:1.0
[   98.898069] usb 5-1: adding 5-1:1.1 (config #1, interface 1)
[   98.898096] usb-storage 5-1:1.1: usb_probe_interface
[   98.898101] usb-storage 5-1:1.1: usb_probe_interface - got id
[   98.900814] scsi6 : usb-storage 5-1:1.1
[   98.904964] usb 5-1: adding 5-1:1.2 (config #1, interface 2)
[   98.904991] usbhid 5-1:1.2: usb_probe_interface
[   98.904993] usbhid 5-1:1.2: usb_probe_interface - got id
[   98.910854] input: Peppercon AG Multidevice as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.2/input/input4
[   98.921296] generic-usb 0003:14DD:0002.0003: input,hidraw0: USB HID v1.01 Mouse [Peppercon AG Multidevice] on usb-0000:00:1d.3-1/input2
[   98.933939] usb 5-1: adding 5-1:1.3 (config #1, interface 3)
[   98.933971] usbhid 5-1:1.3: usb_probe_interface
[   98.933973] usbhid 5-1:1.3: usb_probe_interface - got id
[   98.939053] input: Peppercon AG Multidevice as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.3/input/input5
[   98.949471] uhci_hcd 0000:00:1d.3: reserve dev 3 ep86-INT, period 8, phase 4, 61 us
[   98.949516] generic-usb 0003:14DD:0002.0004: input,hidraw1: USB HID v1.01 Keyboard [Peppercon AG Multidevice] on usb-0000:00:1d.3-1/input3
[   98.962426] drivers/usb/core/inode.c: creating file '003'
[   98.962447] hub 1-0:1.0: state 7 ports 8 chg 0000 evt fe80
[   98.962459] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 003002 0  ACK POWER OWNER sig=se0 CSC
[   98.962469] hub 1-0:1.0: port 7, status 0100, change 0001, 12 Mb/s
[   99.117252] hub 1-0:1.0: debounce: port 7: total 100ms stable 100ms status 0x100
[   99.117257] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0002
[   99.901838] scsi 5:0:0:0: CD-ROM            PepperC  Virtual Disc 1   0.01 PQ: 0 ANSI: 3
[   99.901845] scsi 6:0:0:0: CD-ROM            PepperC  Virtual Disc 2   0.01 PQ: 0 ANSI: 3
[   99.932802] sr2: scsi-1 drive
[   99.936139] sr 5:0:0:0: Attached scsi CD-ROM sr2
[   99.936187] sr 5:0:0:0: Attached scsi generic sg5 type 5
[   99.937814] sr1: scsi-1 drive
[   99.937911] sr 6:0:0:0: Attached scsi CD-ROM sr1
[   99.945066] sr 6:0:0:0: Attached scsi generic sg6 type 5

* detached the CD-ROM drive *

[  126.072800] usb 5-1: uhci_result_common: failed with status 440000
[  126.072814] uhci_hcd 0000:00:1d.3: release dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.087589] uhci_hcd 0000:00:1d.3: reserve dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.096462] hub 1-0:1.0: state 7 ports 8 chg 0000 evt ff80
[  126.096475] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001803 0  ACK POWER sig=j CSC CONNECT
[  126.096485] hub 1-0:1.0: port 7, status 0501, change 0001, 480 Mb/s
[  126.104795] usb 5-1: uhci_result_common: failed with status 440000
[  126.104806] uhci_hcd 0000:00:1d.3: release dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.127680] uhci_hcd 0000:00:1d.3: reserve dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.144794] usb 5-1: uhci_result_common: failed with status 440000
[  126.144805] uhci_hcd 0000:00:1d.3: release dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.197728] uhci_hcd 0000:00:1d.3: reserve dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.216790] usb 5-1: uhci_result_common: failed with status 440000
[  126.216798] uhci_hcd 0000:00:1d.3: release dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.247683] hub 1-0:1.0: debounce: port 7: total 100ms stable 100ms status 0x501
[  126.307899] ehci_hcd 0000:00:1d.7: port 7 high speed
[  126.307904] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  126.317589] uhci_hcd 0000:00:1d.3: reserve dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.336791] usb 5-1: uhci_result_common: failed with status 440000
[  126.336800] uhci_hcd 0000:00:1d.3: release dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.367687] usb 1-7: new high-speed USB device number 10 using ehci_hcd
[  126.374640] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  126.374890] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  126.375138] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  126.427897] ehci_hcd 0000:00:1d.7: port 7 high speed
[  126.427903] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  126.437684] uhci_hcd 0000:00:1d.3: reserve dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.456790] usb 5-1: uhci_result_common: failed with status 440000
[  126.456798] uhci_hcd 0000:00:1d.3: release dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.487678] usb 1-7: device descriptor read/64, error -71
[  126.557685] uhci_hcd 0000:00:1d.3: reserve dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.576790] usb 5-1: uhci_result_common: failed with status 440000
[  126.576799] uhci_hcd 0000:00:1d.3: release dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.597776] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  126.598027] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  126.598276] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  126.657899] ehci_hcd 0000:00:1d.7: port 7 high speed
[  126.657904] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  126.677595] uhci_hcd 0000:00:1d.3: reserve dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.696790] usb 5-1: uhci_result_common: failed with status 440000
[  126.696798] uhci_hcd 0000:00:1d.3: release dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.717682] usb 1-7: device descriptor read/64, error -71
[  126.797596] uhci_hcd 0000:00:1d.3: reserve dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.816790] usb 5-1: uhci_result_common: failed with status 440000
[  126.816798] uhci_hcd 0000:00:1d.3: release dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.887898] ehci_hcd 0000:00:1d.7: port 7 high speed
[  126.887903] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  126.917739] uhci_hcd 0000:00:1d.3: reserve dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.936791] usb 5-1: uhci_result_common: failed with status 440000
[  126.936801] uhci_hcd 0000:00:1d.3: release dev 3 ep86-INT, period 8, phase 4, 61 us
[  126.947684] usb 1-7: new high-speed USB device number 11 using ehci_hcd
[  126.954638] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  126.954889] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  126.955138] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  127.007898] ehci_hcd 0000:00:1d.7: port 7 high speed
[  127.007904] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  127.037692] uhci_hcd 0000:00:1d.3: reserve dev 3 ep86-INT, period 8, phase 4, 61 us
[  127.056790] usb 5-1: uhci_result_common: failed with status 440000
[  127.056798] uhci_hcd 0000:00:1d.3: release dev 3 ep86-INT, period 8, phase 4, 61 us
[  127.067697] usb 1-7: device descriptor read/64, error -71
[  127.157693] uhci_hcd 0000:00:1d.3: reserve dev 3 ep86-INT, period 8, phase 4, 61 us
[  127.176791] usb 5-1: uhci_result_common: failed with status 440000
[  127.176802] uhci_hcd 0000:00:1d.3: release dev 3 ep86-INT, period 8, phase 4, 61 us
[  127.177777] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  127.178027] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  127.178276] ehci_hcd 0000:00:1d.7: devpath 7 ep0in 3strikes
[  127.237898] ehci_hcd 0000:00:1d.7: port 7 high speed
[  127.237904] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  127.297700] usb 1-7: device descriptor read/64, error -71
[  127.467899] ehci_hcd 0000:00:1d.7: port 7 high speed
[  127.467904] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  127.527705] usb 1-7: new high-speed USB device number 12 using ehci_hcd
[  127.534639] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[  127.737778] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[  127.947705] usb 1-7: device not accepting address 12, error -71
[  128.007790] hub 5-0:1.0: logical disconnect on port 1
[  128.067898] ehci_hcd 0000:00:1d.7: port 7 high speed
[  128.067903] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001005 0  ACK POWER sig=se0 PE CONNECT
[  128.127713] usb 1-7: new high-speed USB device number 13 using ehci_hcd
[  128.134640] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[  128.337778] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[  128.547707] usb 1-7: device not accepting address 13, error -71
[  128.553880] hub 1-0:1.0: unable to enumerate USB device on port 7
[  128.577712] hub 5-0:1.0: state 7 ports 2 chg 0002 evt 0002
[  128.577720] uhci_hcd 0000:00:1d.3: port 1 portsc 0093,00
[  128.577729] hub 5-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[  128.577732] usb 5-1: USB disconnect, device number 3
[  128.582947] usb 5-1: unregistering device
[  128.582950] usb 5-1: unregistering interface 5-1:1.0
[  128.583460] usb 5-1: unregistering interface 5-1:1.1
[  128.583774] usb 5-1: unregistering interface 5-1:1.2
[  128.657820] usb 5-1: unregistering interface 5-1:1.3
[  128.767811] usb 5-1: usb_disable_device nuking all URBs
[  128.927728] hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[  129.047729] usb 5-1: new full-speed USB device number 4 using uhci_hcd
[  129.206803] usb 5-1: not running at top speed; connect to a high speed hub
[  129.224809] usb 5-1: skipped 1 descriptor after interface
[  129.224813] usb 5-1: skipped 1 descriptor after interface
[  129.230812] usb 5-1: default language 0x0409
[  129.249815] usb 5-1: udev 4, busnum 5, minor = 515
[  129.249818] usb 5-1: New USB device found, idVendor=14dd, idProduct=0002
[  129.256762] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  129.264174] usb 5-1: Product: Multidevice
[  129.268434] usb 5-1: Manufacturer: Peppercon AG
[  129.273213] usb 5-1: SerialNumber: 0083c601aa48d2d18A62C7F7C61EBFAA
[  129.279799] usb 5-1: usb_probe_device
[  129.279802] usb 5-1: configuration #1 chosen from 1 choice
[  129.289818] usb 5-1: adding 5-1:1.0 (config #1, interface 0)
[  129.289854] usb-storage 5-1:1.0: usb_probe_interface
[  129.289859] usb-storage 5-1:1.0: usb_probe_interface - got id
[  129.290179] scsi7 : usb-storage 5-1:1.0
[  129.294328] usb 5-1: adding 5-1:1.1 (config #1, interface 1)
[  129.294355] usb-storage 5-1:1.1: usb_probe_interface
[  129.294361] usb-storage 5-1:1.1: usb_probe_interface - got id
[  129.294407] scsi8 : usb-storage 5-1:1.1
[  129.298576] usb 5-1: adding 5-1:1.2 (config #1, interface 2)
[  129.298603] usbhid 5-1:1.2: usb_probe_interface
[  129.298605] usbhid 5-1:1.2: usb_probe_interface - got id
[  129.303863] input: Peppercon AG Multidevice as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.2/input/input6
[  129.314374] generic-usb 0003:14DD:0002.0005: input,hidraw0: USB HID v1.01 Mouse [Peppercon AG Multidevice] on usb-0000:00:1d.3-1/input2
[  129.327029] usb 5-1: adding 5-1:1.3 (config #1, interface 3)
[  129.327063] usbhid 5-1:1.3: usb_probe_interface
[  129.327066] usbhid 5-1:1.3: usb_probe_interface - got id
[  129.332049] input: Peppercon AG Multidevice as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.3/input/input7
[  129.342483] uhci_hcd 0000:00:1d.3: reserve dev 4 ep86-INT, period 8, phase 4, 61 us
[  129.342528] generic-usb 0003:14DD:0002.0006: input,hidraw1: USB HID v1.01 Keyboard [Peppercon AG Multidevice] on usb-0000:00:1d.3-1/input3
[  129.355442] drivers/usb/core/inode.c: creating file '004'
[  129.355462] hub 1-0:1.0: state 7 ports 8 chg 0000 evt fe80
[  129.355475] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 003002 0  ACK POWER OWNER sig=se0 CSC
[  129.355485] hub 1-0:1.0: port 7, status 0100, change 0001, 12 Mb/s
[  129.507741] hub 1-0:1.0: debounce: port 7: total 100ms stable 100ms status 0x100
[  130.291836] scsi 7:0:0:0: CD-ROM            PepperC  Virtual Disc 1   0.01 PQ: 0 ANSI: 3
[  130.304835] scsi 8:0:0:0: CD-ROM            PepperC  Virtual Disc 2   0.01 PQ: 0 ANSI: 3
[  130.324827] sr1: scsi-1 drive
[  130.328203] sr 7:0:0:0: Attached scsi CD-ROM sr1
[  130.328253] sr 7:0:0:0: Attached scsi generic sg5 type 5
[  130.333887] sr2: scsi-1 drive
[  130.337212] sr 8:0:0:0: Attached scsi CD-ROM sr2
[  130.337255] sr 8:0:0:0: Attached scsi generic sg6 type 5

--------------080102030709070300040402
Content-Type: text/plain;
 name="usb-good-usbmon.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="usb-good-usbmon.txt"

ffff88041341e780 281667846 C Ii:5:002:6 -84:8 0
ffff880415633b40 281684142 C Ii:1:001:1 0:2048 2 = 8000
ffff880415633b40 281684148 S Ii:1:001:1 -115:2048 4 <
ffff880413901840 281684159 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413901840 281684172 C Ci:1:001:0 0 4 = 01050100
ffff880413901840 281684176 S Co:1:001:0 s 23 01 0010 0007 0000 0
ffff880413901840 281684179 C Co:1:001:0 0 0
ffff880413901840 281684184 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413901840 281684185 C Ci:1:001:0 0 4 = 01050000
ffff880415681e40 281686150 C Ii:5:001:1 0:128 1 = 02
ffff880415681e40 281686160 S Ii:5:001:1 -115:128 2 <
ffff88041341e780 281686216 S Ii:5:002:6 -115:8 8 <
ffff88041341e780 281707838 C Ii:5:002:6 -84:8 0
ffff880415604000 281716229 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880415604000 281716232 C Ci:1:001:0 0 4 = 01050000
ffff88041341e780 281736223 S Ii:5:002:6 -115:8 8 <
ffff88041341e780 281755843 C Ii:5:002:6 -84:8 0
ffff880415604000 281756219 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880415604000 281756223 C Ci:1:001:0 0 4 = 01050000
ffff880415604000 281796216 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880415604000 281796220 C Ci:1:001:0 0 4 = 01050000
ffff88041341e780 281806274 S Ii:5:002:6 -115:8 8 <
ffff88041341e780 281827839 C Ii:5:002:6 -84:8 0
ffff880413901840 281836262 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413901840 281836265 C Ci:1:001:0 0 4 = 01050000
ffff880413901840 281836278 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880413901840 281836281 C Co:1:001:0 0 0
ffff880413901840 281896229 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413901840 281896436 C Ci:1:001:0 0 4 = 03051000
ffff880415681e40 281936151 C Ii:5:001:1 0:128 1 = 02
ffff880415681e40 281936155 S Ii:5:001:1 -115:128 2 <
ffff88041341e780 281936217 S Ii:5:002:6 -115:8 8 <
ffff88041341e780 281955839 C Ii:5:002:6 -84:8 0
ffff880413901840 281956229 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880413901840 281956234 C Co:1:001:0 0 0
ffff880413901840 281963224 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413901840 281963314 C Ci:1:000:0 -71 0
ffff880413901840 281963321 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413901840 281963561 C Ci:1:000:0 -71 0
ffff880413901840 281963568 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413901840 281963811 C Ci:1:000:0 -71 0
ffff880413901840 281963819 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880413901840 281963823 C Co:1:001:0 0 0
ffff880413901840 282016230 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413901840 282016565 C Ci:1:001:0 0 4 = 03051000
ffff88041341e780 282056278 S Ii:5:002:6 -115:8 8 <
ffff88041341e780 282075839 C Ii:5:002:6 -84:8 0
ffff880413901840 282076232 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880413901840 282076237 C Co:1:001:0 0 0
ffff88041341e780 282176139 S Ii:5:002:6 -115:8 8 <
ffff880415681e40 282186162 C Ii:5:001:1 0:128 1 = 02
ffff880415681e40 282186164 S Ii:5:001:1 -115:128 2 <
ffff880413901840 282186234 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413901840 282186309 C Ci:1:000:0 -71 0
ffff880413901840 282186316 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413901840 282186559 C Ci:1:000:0 -71 0
ffff880413901840 282186566 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413901840 282186809 C Ci:1:000:0 -71 0
ffff880413901840 282186817 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880413901840 282186820 C Co:1:001:0 0 0
ffff88041341e780 282195839 C Ii:5:002:6 -84:8 0
ffff880413901840 282246236 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413901840 282246434 C Ci:1:001:0 0 4 = 03051000
ffff88041341e780 282296232 S Ii:5:002:6 -115:8 8 <
ffff880415604000 282306238 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880415604000 282306242 C Co:1:001:0 0 0
ffff88041341e780 282315838 C Ii:5:002:6 -84:8 0
ffff88041341e780 282416225 S Ii:5:002:6 -115:8 8 <
ffff880415604000 282416236 S Co:1:001:0 s 23 01 0001 0007 0000 0
ffff880415604000 282416239 C Co:1:001:0 0 0
ffff880415604000 282416247 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880415604000 282416251 C Co:1:001:0 0 0
ffff88041341e780 282435839 C Ii:5:002:6 -84:8 0
ffff880415681e40 282436161 C Ii:5:001:1 0:128 1 = 02
ffff880415681e40 282436164 S Ii:5:001:1 -115:128 2 <
ffff880415604000 282476228 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880415604000 282476441 C Ci:1:001:0 0 4 = 03051000
ffff880415604000 282536228 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880415604000 282536232 C Co:1:001:0 0 0
ffff88041341e780 282536236 S Ii:5:002:6 -115:8 8 <
ffff880415604000 282543011 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880415604000 282543059 C Ci:1:000:0 -71 0
ffff880415604000 282543066 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880415604000 282543309 C Ci:1:000:0 -71 0
ffff880415604000 282543316 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880415604000 282543560 C Ci:1:000:0 -71 0
ffff880415604000 282543569 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880415604000 282543572 C Co:1:001:0 0 0
ffff88041341e780 282555838 C Ii:5:002:6 -84:8 0
ffff880415604000 282596231 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880415604000 282596436 C Ci:1:001:0 0 4 = 03051000
ffff88041341e780 282656228 S Ii:5:002:6 -115:8 8 <
ffff880413901840 282656241 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880413901840 282656243 C Co:1:001:0 0 0
ffff88041341e780 282675839 C Ii:5:002:6 -84:8 0
ffff880415681e40 282686164 C Ii:5:001:1 0:128 1 = 02
ffff880415681e40 282686167 S Ii:5:001:1 -115:128 2 <
ffff880413901840 282766243 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413901840 282766308 C Ci:1:000:0 -71 0
ffff880415604000 282766316 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880415604000 282766560 C Ci:1:000:0 -71 0
ffff880415604000 282766568 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880415604000 282766809 C Ci:1:000:0 -71 0
ffff880413901900 282766817 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880413901900 282766820 C Co:1:001:0 0 0
ffff88041341e780 282776232 S Ii:5:002:6 -115:8 8 <
ffff88041341e780 282795838 C Ii:5:002:6 -84:8 0
ffff880413901900 282826243 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413901900 282826560 C Ci:1:001:0 0 4 = 03051000
ffff880413901900 282886244 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880413901900 282886248 C Co:1:001:0 0 0
ffff880415681e40 282936168 C Ii:5:001:1 0:128 1 = 02
ffff880415681e40 282936171 S Ii:5:001:1 -115:128 2 <
ffff880413901900 282996246 S Co:1:001:0 s 23 01 0001 0007 0000 0
ffff880413901900 282996250 C Co:1:001:0 0 0
ffff880415604240 282996256 S Co:5:001:0 s 23 03 0004 0001 0000 0
ffff880415604240 282996261 C Co:5:001:0 0 0
ffff880415604240 283056237 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880415604240 283056258 C Ci:5:001:0 0 4 = 00010000
ffff880415604240 283056261 S Co:5:001:0 s 23 01 0014 0001 0000 0
ffff880415604240 283056261 C Co:5:001:0 0 0
ffff880415604240 283056263 S Co:5:001:0 s 23 01 0001 0001 0000 0
ffff880415604240 283056266 C Co:5:001:0 0 0
ffff880415604240 283056273 S Co:5:001:0 s 23 01 0001 0001 0000 0
ffff880415604240 283056277 C Co:5:001:0 0 0
ffff880415604240 283056289 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880415604240 283056294 C Co:1:001:0 0 0
ffff880415604240 283116238 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880415604240 283116434 C Ci:1:001:0 0 4 = 03051000
ffff880415604240 283176240 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880415604240 283176244 C Co:1:001:0 0 0
ffff880415604240 283183033 S Co:1:000:0 s 00 05 0008 0000 0000 0
ffff880415604240 283183185 C Co:1:000:0 -71 0
ffff880415604240 283386242 S Co:1:000:0 s 00 05 0008 0000 0000 0
ffff880415604240 283386310 C Co:1:000:0 -71 0
ffff880415604240 283602330 S Co:1:001:0 s 23 01 0001 0007 0000 0
ffff880415604240 283602334 C Co:1:001:0 0 0
ffff880415604240 283602340 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880415604240 283602343 C Co:1:001:0 0 0
ffff880415604240 283656246 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880415604240 283656567 C Ci:1:001:0 0 4 = 03051000
ffff880415604240 283716247 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880415604240 283716251 C Co:1:001:0 0 0
ffff880415604240 283723030 S Co:1:000:0 s 00 05 0009 0000 0000 0
ffff880415604240 283723184 C Co:1:000:0 -71 0
ffff880415604240 283926252 S Co:1:000:0 s 00 05 0009 0000 0000 0
ffff880415604240 283926309 C Co:1:000:0 -71 0
ffff880415604240 284142341 S Co:1:001:0 s 23 01 0001 0007 0000 0
ffff880415604240 284142345 C Co:1:001:0 0 0
ffff880415604240 284148698 S Co:1:001:0 s 23 01 0001 0007 0000 0
ffff880415604240 284148702 C Co:1:001:0 0 0
ffff880415633b40 284148775 C Ii:1:001:1 0:2048 2 = 8000
ffff880415633b40 284148777 S Ii:1:001:1 -115:2048 4 <
ffff880415604240 284166257 S Ci:1:001:0 s a3 00 0000 0008 0004 4 <
ffff880415604240 284166260 C Ci:1:001:0 0 4 = 00010000
ffff880415604240 284166266 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880415604240 284166273 C Ci:5:001:0 0 4 = 01010100
ffff880415604240 284166274 S Co:5:001:0 s 23 01 0010 0001 0000 0
ffff880415604240 284166276 C Co:5:001:0 0 0
ffff880415604240 284356411 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880415604240 284356417 C Ci:5:001:0 0 4 = 01010000
ffff880415604240 284396259 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880415604240 284396264 C Ci:5:001:0 0 4 = 01010000
ffff880415604240 284436260 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880415604240 284436265 C Ci:5:001:0 0 4 = 01010000
ffff880415604240 284476261 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880415604240 284476265 C Ci:5:001:0 0 4 = 01010000
ffff880415604240 284516261 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880415604240 284516266 C Ci:5:001:0 0 4 = 01010000
ffff880415604240 284516276 S Co:5:001:0 s 23 03 0004 0001 0000 0
ffff880415604240 284516279 C Co:5:001:0 0 0
ffff880415604240 284576261 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880415604240 284576281 C Ci:5:001:0 0 4 = 03010000
ffff880415604240 284636262 S Co:5:001:0 s 23 01 0014 0001 0000 0
ffff880415604240 284636264 C Co:5:001:0 0 0
ffff880415604240 284643055 S Ci:5:000:0 s 80 06 0100 0000 0040 64 <
ffff880415604240 284647841 C Ci:5:000:0 0 18 = 12010002 00000040 dd140200 01000102 0301
ffff880415604240 284647851 S Co:5:001:0 s 23 03 0004 0001 0000 0
ffff880415604240 284647856 C Co:5:001:0 0 0
ffff880415681e40 284686196 C Ii:5:001:1 0:128 1 = 02
ffff880415681e40 284686201 S Ii:5:001:1 -115:128 2 <
ffff880415604240 284706263 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880415604240 284706284 C Ci:5:001:0 0 4 = 03010000
ffff880415604240 284766263 S Co:5:001:0 s 23 01 0014 0001 0000 0
ffff880415604240 284766266 C Co:5:001:0 0 0
ffff880415604240 284766267 S Co:5:000:0 s 00 05 0003 0000 0000 0
ffff880415604240 284769838 C Co:5:000:0 0 0
ffff880413901180 284786275 S Ci:5:003:0 s 80 06 0100 0000 0012 18 <
ffff880413901180 284790839 C Ci:5:003:0 0 18 = 12010002 00000040 dd140200 01000102 0301
ffff880415604240 284790848 S Ci:5:003:0 s 80 06 0600 0000 000a 10 <
ffff880415604240 284795838 C Ci:5:003:0 0 10 = 0a060002 00000040 0100
ffff880415604240 284802987 S Ci:5:003:0 s 80 06 0200 0000 0009 9 <
ffff880415604240 284807838 C Ci:5:003:0 0 9 = 09026900 040100c0 32
ffff880415604240 284807846 S Ci:5:003:0 s 80 06 0200 0000 0069 105 <
ffff880415604240 284813839 C Ci:5:003:0 0 105 = 09026900 040100c0 32090400 00020806 50000705 81024000 00070502 02400000
ffff880415604240 284813860 S Ci:5:003:0 s 80 06 0300 0000 00ff 255 <
ffff880415604240 284819838 C Ci:5:003:0 0 4 = 04030904
ffff880415604240 284819850 S Ci:5:003:0 s 80 06 0302 0409 00ff 255 <
ffff880415604240 284825838 C Ci:5:003:0 0 24 = 18034d00 75006c00 74006900 64006500 76006900 63006500
ffff880415604240 284825846 S Ci:5:003:0 s 80 06 0301 0409 00ff 255 <
ffff880415604240 284831838 C Ci:5:003:0 0 26 = 1a035000 65007000 70006500 72006300 6f006e00 20004100 4700
ffff880415604240 284831844 S Ci:5:003:0 s 80 06 0303 0409 00ff 255 <
ffff880415604240 284838838 C Ci:5:003:0 0 66 = 42033000 30003800 33006300 36003000 31006100 61003400 38006400 32006400
ffff880413901180 284868828 S Co:5:003:0 s 00 09 0001 0000 0000 0
ffff880413901180 284872837 C Co:5:003:0 0 0
ffff880412cac780 284884058 S Ci:5:003:0 s 80 06 0303 0409 00ff 255 <
ffff880412cac780 284886839 C Ci:5:003:0 0 66 = 42033000 30003800 33006300 36003000 31006100 61003400 38006400 32006400
ffff880412caccc0 284886897 S Co:5:003:0 s 21 0a 0000 0002 0000 0
ffff880412caccc0 284887838 C Co:5:003:0 0 0
ffff880413f93e40 284887846 S Ci:5:003:0 s 81 06 2200 0002 004f 79 <
ffff880413f93e40 284888840 C Ci:5:003:0 0 79 = 05010902 a1010901 a1000509 19012903 15002501 95037501 81029501 75058101
ffff880412d4be40 284889033 S Ci:5:003:0 s a1 01 0100 0002 0006 64 <
ffff880412d4be40 284889839 C Ci:5:003:0 0 6 = 00bf7dff 0d00
ffff880412d4bf00 284913022 S Ci:5:003:0 s 80 06 0303 0409 00ff 255 <
ffff880412d4bf00 284915840 C Ci:5:003:0 0 66 = 42033000 30003800 33006300 36003000 31006100 61003400 38006400 32006400
ffff88041350a480 284915887 S Co:5:003:0 s 21 0a 0000 0003 0000 0
ffff88041350a480 284916839 C Co:5:003:0 0 0
ffff88041350a480 284916847 S Ci:5:003:0 s 81 06 2200 0003 0042 66 <
ffff88041350a480 284917840 C Ci:5:003:0 0 66 = 05010906 a1010507 19e029e7 15002501 75019508 81029501 75088101 190029e7
ffff88041350ac00 284918009 S Co:5:003:0 s 21 09 0200 0003 0001 1 = 00
ffff88041350ac00 284918839 C Co:5:003:0 0 1 >
ffff88041350a480 284928504 S Ii:5:003:6 -115:8 8 <
ffff88041350a540 284941493 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff88041350a540 284941504 C Ci:1:001:0 0 4 = 00010100
ffff88041350a540 284941506 S Co:1:001:0 s 23 01 0010 0007 0000 0
ffff88041350a540 284941509 C Co:1:001:0 0 0
ffff88041350a540 284941514 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff88041350a540 284941515 C Ci:1:001:0 0 4 = 00010000
ffff8804135bef00 284976280 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff8804135bef00 284976286 C Ci:1:001:0 0 4 = 00010000
ffff8804135bed80 285016281 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff8804135bed80 285016284 C Ci:1:001:0 0 4 = 00010000
ffff8804135bed80 285056280 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff8804135bed80 285056283 C Ci:1:001:0 0 4 = 00010000
ffff880413f93480 285096285 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413f93480 285096289 C Ci:1:001:0 0 4 = 00010000
ffff880413f93480 285096302 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880413f93480 285096307 C Ci:5:001:0 0 4 = 03010000
ffff880415604840 285876285 S Ci:5:003:0 s a1 fe 0000 0000 0001 1 <
ffff8804116959c0 285876295 S Ci:5:003:0 s a1 fe 0000 0001 0001 1 <
ffff880415604840 285877841 C Ci:5:003:0 0 1 = 00
ffff8804116959c0 285877846 C Ci:5:003:0 0 1 = 00
ffff880415604840 285877957 S Bo:5:003:2 -115 31 = 55534243 01000000 24000000 80000612 00000024 00000000 00000000 000000
ffff8804116959c0 285877962 S Bo:5:003:4 -115 31 = 55534243 01000000 24000000 80000612 00000024 00000000 00000000 000000
ffff880415604840 285878838 C Bo:5:003:2 0 31 >
ffff8804116959c0 285878843 C Bo:5:003:4 0 31 >
ffff88041355c000 285878847 S Bi:5:003:1 -115 36 <
ffff8804135be240 285878851 S Bi:5:003:3 -115 36 <
ffff88041355c000 285879839 C Bi:5:003:1 0 36 = 05800302 1f000000 50657070 65724320 56697274 75616c20 44697363 20312020
ffff8804135be240 285879845 C Bi:5:003:3 0 36 = 05800302 1f000000 50657070 65724320 56697274 75616c20 44697363 20322020
ffff880415604840 285879846 S Bi:5:003:1 -115 13 <
ffff8804116959c0 285879851 S Bi:5:003:3 -115 13 <
ffff880415604840 285880839 C Bi:5:003:1 0 13 = 55534253 01000000 00000000 00
ffff8804116959c0 285880846 C Bi:5:003:3 0 13 = 55534253 01000000 00000000 00
ffff8804116959c0 285898061 S Bo:5:003:4 -115 31 = 55534243 02000000 00000000 00000600 00000000 00000000 00000000 000000
ffff880415604840 285898063 S Bo:5:003:2 -115 31 = 55534243 02000000 00000000 00000600 00000000 00000000 00000000 000000
ffff8804116959c0 285899838 C Bo:5:003:4 0 31 >
ffff880415604840 285899845 C Bo:5:003:2 0 31 >
ffff880415604840 285899850 S Bi:5:003:1 -115 13 <
ffff8804116959c0 285899863 S Bi:5:003:3 -115 13 <
ffff880415604840 285900838 C Bi:5:003:1 0 13 = 55534253 02000000 00000000 01
ffff8804116959c0 285900843 C Bi:5:003:3 0 13 = 55534253 02000000 00000000 01
ffff880415604840 285900849 S Bo:5:003:2 -115 31 = 55534243 03000000 12000000 80000603 00000012 00000000 00000000 000000
ffff8804116959c0 285900875 S Bo:5:003:4 -115 31 = 55534243 03000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880415604840 285901839 C Bo:5:003:2 0 31 >
ffff8804116959c0 285901846 C Bo:5:003:4 0 31 >
ffff88041355c3c0 285901848 S Bi:5:003:1 -115 18 <
ffff880412fc33c0 285901854 S Bi:5:003:3 -115 18 <
ffff88041355c3c0 285902840 C Bi:5:003:1 0 18 = 70000600 0000000a 00000000 29000000 0000
ffff880412fc33c0 285902846 C Bi:5:003:3 0 18 = 70000600 0000000a 00000000 29000000 0000
ffff880415604840 285902847 S Bi:5:003:1 -115 13 <
ffff8804116959c0 285902853 S Bi:5:003:3 -115 13 <
ffff880415604840 285903838 C Bi:5:003:1 0 13 = 55534253 03000000 00000000 00
ffff8804116959c0 285903844 C Bi:5:003:3 0 13 = 55534253 03000000 00000000 00
ffff8804116959c0 285903881 S Bo:5:003:4 -115 31 = 55534243 04000000 00000000 00000600 00000000 00000000 00000000 000000
ffff880415604840 285903898 S Bo:5:003:2 -115 31 = 55534243 04000000 00000000 00000600 00000000 00000000 00000000 000000
ffff8804116959c0 285904839 C Bo:5:003:4 0 31 >
ffff880415604840 285904844 C Bo:5:003:2 0 31 >
ffff8804116959c0 285904845 S Bi:5:003:3 -115 13 <
ffff880415604840 285904850 S Bi:5:003:1 -115 13 <
ffff8804116959c0 285905838 C Bi:5:003:3 0 13 = 55534253 04000000 00000000 01
ffff880415604840 285905844 C Bi:5:003:1 0 13 = 55534253 04000000 00000000 00
ffff8804116959c0 285905845 S Bo:5:003:4 -115 31 = 55534243 05000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880415604840 285905871 S Bo:5:003:2 -115 31 = 55534243 05000000 80000000 80000a5a 002a0000 00000080 00000000 000000
ffff8804116959c0 285906837 C Bo:5:003:4 0 31 >
ffff880415604840 285906842 C Bo:5:003:2 0 31 >
ffff88041355c3c0 285906843 S Bi:5:003:3 -115 18 <
ffff88041355c780 285906849 S Bi:5:003:1 -115 128 <
ffff88041355c3c0 285907840 C Bi:5:003:3 0 18 = 70000200 0000000a 00000000 3a000000 0000
ffff88041355c780 285907848 C Bi:5:003:1 0 128 = 55534243 05000000 80000000 80000a5a 002a0000 00000080 00000000 00000020
ffff8804116959c0 285907848 S Bi:5:003:3 -115 13 <
ffff880415604840 285907855 S Bi:5:003:1 -115 13 <
ffff8804116959c0 285908838 C Bi:5:003:3 0 13 = 55534253 05000000 00000000 00
ffff880415604840 285908843 C Bi:5:003:1 0 13 = 55534253 05000000 80000000 01
ffff880415604840 285908855 S Bo:5:003:2 -115 31 = 55534243 06000000 12000000 80000603 00000012 00000000 00000000 000000
ffff8804116959c0 285908900 S Bo:5:003:4 -115 31 = 55534243 06000000 80000000 80000a5a 002a0000 00000080 00000000 000000
ffff880415604840 285909838 C Bo:5:003:2 0 31 >
ffff8804116959c0 285909842 C Bo:5:003:4 0 31 >
ffff88041355c3c0 285909844 S Bi:5:003:1 -115 18 <
ffff880412fc33c0 285909852 S Bi:5:003:3 -115 128 <
ffff88041355c3c0 285910839 C Bi:5:003:1 0 18 = 70000500 0000000a 00000000 24000000 0000
ffff880412fc33c0 285910845 C Bi:5:003:3 0 128 = 70000200 0000000a 00000000 3a000000 00000012 00000000 00000000 00000020
ffff880415604840 285910847 S Bi:5:003:1 -115 13 <
ffff8804116959c0 285910852 S Bi:5:003:3 -115 13 <
ffff880415604840 285911837 C Bi:5:003:1 0 13 = 55534253 06000000 00000000 00
ffff8804116959c0 285911842 C Bi:5:003:3 0 13 = 55534253 06000000 80000000 01
ffff8804116959c0 285911866 S Bo:5:003:4 -115 31 = 55534243 07000000 12000000 80000603 00000012 00000000 00000000 000000
ffff8804116959c0 285915080 C Bo:5:003:4 0 31 >
ffff880412fc33c0 285915096 S Bi:5:003:3 -115 18 <
ffff880412fc33c0 285915839 C Bi:5:003:3 0 18 = 70000500 0000000a 00000000 24000000 0000
ffff8804116959c0 285915906 S Bi:5:003:3 -115 13 <
ffff880415604840 285916819 S Bo:5:003:2 -115 31 = 55534243 07000000 08000000 80000a4a 01000010 00000008 00000000 000000
ffff8804116959c0 285916839 C Bi:5:003:3 0 13 = 55534253 07000000 00000000 00
ffff880415604840 285917840 C Bo:5:003:2 0 31 >
ffff88041355c240 285917874 S Bi:5:003:1 -115 8 <
ffff88041355c240 285918839 C Bi:5:003:1 0 8 = 55534243 07000000
ffff880415604840 285918868 S Bi:5:003:1 -115 13 <
ffff880415604840 285924041 C Bi:5:003:1 0 13 = 55534253 07000000 08000000 01
ffff880415604840 285924075 S Bo:5:003:2 -115 31 = 55534243 08000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880415604840 285929699 C Bo:5:003:2 0 31 >
ffff880411695cc0 285929732 S Bi:5:003:1 -115 18 <
ffff8804116959c0 285929758 S Bo:5:003:4 -115 31 = 55534243 08000000 00100000 80000ca0 00000000 00000010 00000000 000000
ffff880411695cc0 285929839 C Bi:5:003:1 0 18 = 70000500 0000000a 00000000 20000000 0000
ffff8804116959c0 285929846 C Bo:5:003:4 0 31 >
ffff880415604840 285929849 S Bi:5:003:1 -115 13 <
ffff880413623900 285929899 S Bi:5:003:3 -115 4096 <
ffff880415604840 285930837 C Bi:5:003:1 0 13 = 55534253 08000000 00000000 00
ffff880415604840 285930861 S Bo:5:003:2 -115 31 = 55534243 09000000 00100000 80000ca0 00000000 00000010 00000000 000000
ffff880415604840 285931838 C Bo:5:003:2 0 31 >
ffff88041355cc00 285931846 S Bi:5:003:1 -115 4096 <
ffff880413623900 285936841 C Bi:5:003:3 0 4096 = 00000008 00000000 00000000 00000000 00000012 00000000 00000000 00000020
ffff8804116959c0 285936847 S Bi:5:003:3 -115 13 <
ffff8804116959c0 285937840 C Bi:5:003:3 0 13 = 55534253 08000000 f00f0000 00
ffff88041355cc00 285940844 C Bi:5:003:1 0 4096 = 00000008 00000000 00000000 00000000 00000000 00000010 00000000 00000020
ffff880415604840 285940852 S Bi:5:003:1 -115 13 <
ffff880415604840 285941837 C Bi:5:003:1 0 13 = 55534253 09000000 f00f0000 00
ffff880415604840 285941854 S Bo:5:003:2 -115 31 = 55534243 0a000000 00000000 00000600 00000000 00000000 00000000 000000
ffff880415604840 285942838 C Bo:5:003:2 0 31 >
ffff880415604840 285942844 S Bi:5:003:1 -115 13 <
ffff880415604840 285943839 C Bi:5:003:1 0 13 = 55534253 0a000000 00000000 00
ffff880415604840 285943898 S Bo:5:003:2 -115 31 = 55534243 0b000000 00000000 00000600 00000000 00000000 00000000 000000
ffff880415604840 285944838 C Bo:5:003:2 0 31 >
ffff880415604840 285944845 S Bi:5:003:1 -115 13 <
ffff880415604840 285945838 C Bi:5:003:1 0 13 = 55534253 0b000000 00000000 00
ffff880415604840 285945884 S Bo:5:003:2 -115 31 = 55534243 0c000000 0c000000 80000a43 00000000 0000000c 40000000 000000
ffff880415604840 285946837 C Bo:5:003:2 0 31 >
ffff88041355cc00 285946843 S Bi:5:003:1 -115 12 <
ffff88041355cc00 285947840 C Bi:5:003:1 0 12 = 000a0101 00140100 00000000
ffff880415604840 285947847 S Bi:5:003:1 -115 13 <
ffff880415604840 285948838 C Bi:5:003:1 0 13 = 55534253 0c000000 00000000 00
ffff880415604840 285948869 S Bo:5:003:2 -115 31 = 55534243 0d000000 0c000000 80000a43 00000000 0000000c 00000000 000000
ffff880415604840 285949838 C Bo:5:003:2 0 31 >
ffff88041355cc00 285949845 S Bi:5:003:1 -115 12 <
ffff88041355cc00 285950838 C Bi:5:003:1 0 12 = 000a0101 00140100 00000000
ffff880415604840 285950845 S Bi:5:003:1 -115 13 <
ffff880415604840 285951838 C Bi:5:003:1 0 13 = 55534253 0d000000 00000000 00
ffff880415604840 285951868 S Bo:5:003:2 -115 31 = 55534243 0e000000 0c000000 80000a43 00000000 0001000c 00000000 000000
ffff880415604840 285952838 C Bo:5:003:2 0 31 >
ffff8804116950c0 285952846 S Bi:5:003:1 -115 12 <
ffff8804116950c0 285953839 C Bi:5:003:1 0 12 = 000a0101 00140100 00000000
ffff880415604840 285953847 S Bi:5:003:1 -115 13 <
ffff880415604840 285954837 C Bi:5:003:1 0 13 = 55534253 0e000000 0c000000 00
ffff880415604840 285954866 S Bo:5:003:2 -115 31 = 55534243 0f000000 08000000 80000a25 00000000 00000000 00000000 000000
ffff880415604840 285955838 C Bo:5:003:2 0 31 >
ffff8804116950c0 285955845 S Bi:5:003:1 -115 8 <
ffff8804116950c0 285956839 C Bi:5:003:1 0 8 = 000075ff 00000800
ffff880415604840 285956846 S Bi:5:003:1 -115 13 <
ffff880415604840 285957838 C Bi:5:003:1 0 13 = 55534253 0f000000 00000000 00
ffff880415604840 285957864 S Bo:5:003:2 -115 31 = 55534243 10000000 02000000 80000a51 00000000 00000002 00000000 000000
ffff880415604840 285958838 C Bo:5:003:2 0 31 >
ffff8804116950c0 285958845 S Bi:5:003:1 -115 2 <
ffff8804116950c0 285959839 C Bi:5:003:1 0 2 = 0000
ffff880415604840 285959846 S Bi:5:003:1 -115 13 <
ffff880415604840 285960838 C Bi:5:003:1 0 13 = 55534253 10000000 02000000 01
ffff880415604840 285960844 S Bo:5:003:2 -115 31 = 55534243 11000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880415604840 285961839 C Bo:5:003:2 0 31 >
ffff88041355c840 285961847 S Bi:5:003:1 -115 18 <
ffff88041355c840 285962838 C Bi:5:003:1 0 18 = 70000500 0000000a 00000000 20000000 0000
ffff880415604840 285962846 S Bi:5:003:1 -115 13 <
ffff880415604840 285963838 C Bi:5:003:1 0 13 = 55534253 11000000 00000000 00
ffff880415604840 285963872 S Bo:5:003:2 -115 31 = 55534243 12000000 0c000000 80000a43 02000000 00aa000c 00000000 000000
ffff880415604840 285964837 C Bo:5:003:2 0 31 >
ffff8804116950c0 285964844 S Bi:5:003:1 -115 12 <
ffff8804116950c0 285965839 C Bi:5:003:1 0 12 = 70000500 0000000a 00000000
ffff880415604840 285965845 S Bi:5:003:1 -115 13 <
ffff880415604840 285966838 C Bi:5:003:1 0 13 = 55534253 12000000 0c000000 00
ffff8804116959c0 285966882 S Bo:5:003:4 -115 31 = 55534243 09000000 08000000 80000a4a 01000010 00000008 00000000 000000
ffff8804116959c0 285967839 C Bo:5:003:4 0 31 >
ffff88041350a9c0 285967847 S Bi:5:003:3 -115 8 <
ffff88041350a9c0 285968839 C Bi:5:003:3 0 8 = 55534243 09000000
ffff8804116959c0 285968847 S Bi:5:003:3 -115 13 <
ffff8804116959c0 285969838 C Bi:5:003:3 0 13 = 55534253 09000000 08000000 01
ffff8804116959c0 285969845 S Bo:5:003:4 -115 31 = 55534243 0a000000 12000000 80000603 00000012 00000000 00000000 000000
ffff8804116959c0 285970836 C Bo:5:003:4 0 31 >
ffff880413623b40 285970842 S Bi:5:003:3 -115 18 <
ffff880413623b40 285971838 C Bi:5:003:3 0 18 = 70000500 0000000a 00000000 20000000 0000
ffff8804116959c0 285971844 S Bi:5:003:3 -115 13 <
ffff8804116959c0 285972837 C Bi:5:003:3 0 13 = 55534253 0a000000 00000000 00
ffff8804116959c0 285972896 S Bo:5:003:4 -115 31 = 55534243 0b000000 00000000 00000600 00000000 00000000 00000000 000000
ffff8804116959c0 285973838 C Bo:5:003:4 0 31 >
ffff8804116959c0 285973843 S Bi:5:003:3 -115 13 <
ffff8804116959c0 285983836 C Bi:5:003:3 0 13 = 55534253 0b000000 00000000 01
ffff8804116959c0 285983843 S Bo:5:003:4 -115 31 = 55534243 0c000000 12000000 80000603 00000012 00000000 00000000 000000
ffff8804116959c0 285984839 C Bo:5:003:4 0 31 >
ffff880413623d80 285984847 S Bi:5:003:3 -115 18 <
ffff880413623d80 285990839 C Bi:5:003:3 0 18 = 70000200 0000000a 00000000 3a000000 0000
ffff8804116959c0 285990848 S Bi:5:003:3 -115 13 <
ffff8804116959c0 285991838 C Bi:5:003:3 0 13 = 55534253 0c000000 00000000 00
ffff8804116959c0 285991889 S Bo:5:003:4 -115 31 = 55534243 0d000000 00000000 00000600 00000000 00000000 00000000 000000
ffff8804116959c0 285992838 C Bo:5:003:4 0 31 >
ffff8804116959c0 285992844 S Bi:5:003:3 -115 13 <
ffff8804116959c0 285993837 C Bi:5:003:3 0 13 = 55534253 0d000000 00000000 01
ffff8804116959c0 285993843 S Bo:5:003:4 -115 31 = 55534243 0e000000 12000000 80000603 00000012 00000000 00000000 000000
ffff8804116959c0 285994838 C Bo:5:003:4 0 31 >
ffff880413623d80 285994846 S Bi:5:003:3 -115 18 <
ffff880413623d80 285995840 C Bi:5:003:3 0 18 = 70000200 0000000a 00000000 3a000000 0000
ffff8804116959c0 285995847 S Bi:5:003:3 -115 13 <
ffff8804116959c0 285996838 C Bi:5:003:3 0 13 = 55534253 0e000000 00000000 00
ffff880415604840 285996886 S Bo:5:003:2 -115 31 = 55534243 13000000 08000000 80000a4a 01000010 00000008 00000000 000000
ffff8804116959c0 285996913 S Bo:5:003:4 -115 31 = 55534243 0f000000 00000000 0000061e 00000000 00000000 00000000 000000
ffff880415604840 285997838 C Bo:5:003:2 0 31 >
ffff8804116959c0 285997844 C Bo:5:003:4 0 31 >
ffff88041355c480 285997847 S Bi:5:003:1 -115 8 <
ffff8804116959c0 285997850 S Bi:5:003:3 -115 13 <
ffff88041355c480 285998839 C Bi:5:003:1 0 8 = 55534243 13000000
ffff8804116959c0 285998845 C Bi:5:003:3 0 13 = 55534253 0f000000 00000000 00
ffff880415604840 285998847 S Bi:5:003:1 -115 13 <
ffff8804116959c0 285998862 S Bo:5:003:4 -115 31 = 55534243 10000000 08000000 80000a4a 01000010 00000008 00000000 000000
ffff880415604840 285999838 C Bi:5:003:1 0 13 = 55534253 13000000 08000000 01
ffff8804116959c0 285999844 C Bo:5:003:4 0 31 >
ffff880415604840 285999847 S Bo:5:003:2 -115 31 = 55534243 14000000 12000000 80000603 00000012 00000000 00000000 000000
ffff88041355c480 285999860 S Bi:5:003:3 -115 8 <
ffff880415604840 286000838 C Bo:5:003:2 0 31 >
ffff88041355c480 286000844 C Bi:5:003:3 0 8 = 55534243 10000000
ffff88041355c180 286000846 S Bi:5:003:1 -115 18 <
ffff8804116959c0 286000854 S Bi:5:003:3 -115 13 <
ffff88041355c180 286001839 C Bi:5:003:1 0 18 = 70000500 0000000a 00000000 20000000 0000
ffff8804116959c0 286001844 C Bi:5:003:3 0 13 = 55534253 10000000 08000000 01
ffff880415604840 286001849 S Bi:5:003:1 -115 13 <
ffff8804116959c0 286001896 S Bo:5:003:4 -115 31 = 55534243 11000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880415604840 286002837 C Bi:5:003:1 0 13 = 55534253 14000000 00000000 00
ffff8804116959c0 286002842 C Bo:5:003:4 0 31 >
ffff880415604840 286002853 S Bo:5:003:2 -115 31 = 55534243 15000000 00000000 0000061e 00000000 00000000 00000000 000000
ffff88041355c180 286002857 S Bi:5:003:3 -115 18 <
ffff880415604840 286003839 C Bo:5:003:2 0 31 >
ffff88041355c180 286003848 C Bi:5:003:3 0 18 = 70000500 0000000a 00000000 20000000 0000
ffff880415604840 286003849 S Bi:5:003:1 -115 13 <
ffff8804116959c0 286003856 S Bi:5:003:3 -115 13 <
ffff880415604840 286004838 C Bi:5:003:1 0 13 = 55534253 15000000 00000000 00
ffff8804116959c0 286004845 C Bi:5:003:3 0 13 = 55534253 11000000 00000000 00
ffff880415604840 286004854 S Bo:5:003:2 -115 31 = 55534243 16000000 00000000 00000600 00000000 00000000 00000000 000000
ffff8804116959c0 286004873 S Bo:5:003:4 -115 31 = 55534243 12000000 00000000 00000600 00000000 00000000 00000000 000000
ffff880415604840 286005838 C Bo:5:003:2 0 31 >
ffff8804116959c0 286005844 C Bo:5:003:4 0 31 >
ffff880415604840 286005862 S Bi:5:003:1 -115 13 <
ffff8804116959c0 286005870 S Bi:5:003:3 -115 13 <
ffff880415604840 286006837 C Bi:5:003:1 0 13 = 55534253 16000000 00000000 00
ffff8804116959c0 286006842 C Bi:5:003:3 0 13 = 55534253 12000000 00000000 01
ffff8804116959c0 286006851 S Bo:5:003:4 -115 31 = 55534243 13000000 12000000 80000603 00000012 00000000 00000000 000000
ffff8804116959c0 286007839 C Bo:5:003:4 0 31 >
ffff880411695300 286007848 S Bi:5:003:3 -115 18 <
ffff880411695300 286008840 C Bi:5:003:3 0 18 = 70000200 0000000a 00000000 3a000000 0000
ffff8804116959c0 286008848 S Bi:5:003:3 -115 13 <
ffff8804116959c0 286009838 C Bi:5:003:3 0 13 = 55534253 13000000 00000000 00
ffff88041350a480 312051857 C Ii:5:003:6 -84:8 0
ffff88041350a480 312066624 S Ii:5:003:6 -115:8 8 <
ffff880415633b40 312075506 C Ii:1:001:1 0:2048 2 = 8000
ffff880415633b40 312075513 S Ii:1:001:1 -115:2048 4 <
ffff880413623d80 312075526 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413623d80 312075537 C Ci:1:001:0 0 4 = 01050100
ffff880413623d80 312075538 S Co:1:001:0 s 23 01 0010 0007 0000 0
ffff880413623d80 312075541 C Co:1:001:0 0 0
ffff880413623d80 312075546 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413623d80 312075548 C Ci:1:001:0 0 4 = 01050000
ffff88041350a480 312083854 C Ii:5:003:6 -84:8 0
ffff88041350a480 312106715 S Ii:5:003:6 -115:8 8 <
ffff880413623d80 312106727 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413623d80 312106730 C Ci:1:001:0 0 4 = 01050000
ffff88041350a480 312123854 C Ii:5:003:6 -84:8 0
ffff880413623d80 312146717 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413623d80 312146720 C Ci:1:001:0 0 4 = 01050000
ffff88041350a480 312176764 S Ii:5:003:6 -115:8 8 <
ffff880415681e40 312186644 C Ii:5:001:1 0:128 1 = 02
ffff880415681e40 312186647 S Ii:5:001:1 -115:128 2 <
ffff880413623d80 312186717 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413623d80 312186721 C Ci:1:001:0 0 4 = 01050000
ffff88041350a480 312195852 C Ii:5:003:6 -84:8 0
ffff880413623d80 312226718 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413623d80 312226721 C Ci:1:001:0 0 4 = 01050000
ffff880413623d80 312226733 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880413623d80 312226736 C Co:1:001:0 0 0
ffff880413623d80 312286719 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413623d80 312286949 C Ci:1:001:0 0 4 = 03051000
ffff88041350a480 312296626 S Ii:5:003:6 -115:8 8 <
ffff88041350a480 312315853 C Ii:5:003:6 -84:8 0
ffff880413623d80 312346722 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880413623d80 312346725 C Co:1:001:0 0 0
ffff880413623d80 312353604 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413623d80 312353702 C Ci:1:000:0 -71 0
ffff880413623d80 312353711 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413623d80 312353951 C Ci:1:000:0 -71 0
ffff880413d2d480 312353959 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413d2d480 312354200 C Ci:1:000:0 -71 0
ffff880413d2d480 312354208 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880413d2d480 312354212 C Co:1:001:0 0 0
ffff880413d2d480 312406711 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413d2d480 312406948 C Ci:1:001:0 0 4 = 03051000
ffff88041350a480 312416720 S Ii:5:003:6 -115:8 8 <
ffff88041350a480 312435852 C Ii:5:003:6 -84:8 0
ffff880415681e40 312436645 C Ii:5:001:1 0:128 1 = 02
ffff880415681e40 312436648 S Ii:5:001:1 -115:128 2 <
ffff880413d2d480 312466713 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880413d2d480 312466717 C Co:1:001:0 0 0
ffff88041350a480 312536721 S Ii:5:003:6 -115:8 8 <
ffff88041350a480 312555853 C Ii:5:003:6 -84:8 0
ffff880413d2d480 312576713 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413d2d480 312576823 C Ci:1:000:0 -71 0
ffff880413623d80 312576831 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413623d80 312577074 C Ci:1:000:0 -71 0
ffff880413d2d000 312577080 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413d2d000 312577324 C Ci:1:000:0 -71 0
ffff880413d2d000 312577333 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880413d2d000 312577337 C Co:1:001:0 0 0
ffff880413d2d000 312636715 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413d2d000 312636956 C Ci:1:001:0 0 4 = 03051000
ffff88041350a480 312656631 S Ii:5:003:6 -115:8 8 <
ffff88041350a480 312675853 C Ii:5:003:6 -84:8 0
ffff880415681e40 312686649 C Ii:5:001:1 0:128 1 = 02
ffff880415681e40 312686651 S Ii:5:001:1 -115:128 2 <
ffff880413d2d000 312696716 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880413d2d000 312696721 C Co:1:001:0 0 0
ffff88041350a480 312776633 S Ii:5:003:6 -115:8 8 <
ffff88041350a480 312795853 C Ii:5:003:6 -84:8 0
ffff880413d2d000 312806719 S Co:1:001:0 s 23 01 0001 0007 0000 0
ffff880413d2d000 312806723 C Co:1:001:0 0 0
ffff880413d2d000 312806732 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880413d2d000 312806735 C Co:1:001:0 0 0
ffff880413d2d000 312866718 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413d2d000 312866948 C Ci:1:001:0 0 4 = 03051000
ffff88041350a480 312896776 S Ii:5:003:6 -115:8 8 <
ffff88041350a480 312915854 C Ii:5:003:6 -84:8 0
ffff880413d2d000 312926719 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880413d2d000 312926722 C Co:1:001:0 0 0
ffff880413d2d000 312933594 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413d2d000 312933697 C Ci:1:000:0 -71 0
ffff880413623240 312933704 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413623240 312933950 C Ci:1:000:0 -71 0
ffff880413623240 312933958 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413623240 312934200 C Ci:1:000:0 -71 0
ffff880413623240 312934208 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880413623240 312934212 C Co:1:001:0 0 0
ffff880415681e40 312936655 C Ii:5:001:1 0:128 1 = 02
ffff880415681e40 312936657 S Ii:5:001:1 -115:128 2 <
ffff880413623240 312986730 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413623240 312986955 C Ci:1:001:0 0 4 = 03051000
ffff88041350a480 313016728 S Ii:5:003:6 -115:8 8 <
ffff88041350a480 313035853 C Ii:5:003:6 -84:8 0
ffff880413623240 313046732 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880413623240 313046736 C Co:1:001:0 0 0
ffff88041350a480 313136730 S Ii:5:003:6 -115:8 8 <
ffff88041350a480 313155854 C Ii:5:003:6 -84:8 0
ffff880413623240 313156734 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413623240 313156824 C Ci:1:000:0 -71 0
ffff880413623240 313156832 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413623240 313157075 C Ci:1:000:0 -71 0
ffff880413623240 313157082 S Ci:1:000:0 s 80 06 0100 0000 0040 64 <
ffff880413623240 313157324 C Ci:1:000:0 -71 0
ffff880413623240 313157332 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880413623240 313157336 C Co:1:001:0 0 0
ffff880415681e40 313186658 C Ii:5:001:1 0:128 1 = 02
ffff880415681e40 313186660 S Ii:5:001:1 -115:128 2 <
ffff880413623240 313216735 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413623240 313216949 C Ci:1:001:0 0 4 = 03051000
ffff880413623240 313276735 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880413623240 313276739 C Co:1:001:0 0 0
ffff880413623240 313386737 S Co:1:001:0 s 23 01 0001 0007 0000 0
ffff880413623240 313386741 C Co:1:001:0 0 0
ffff880413623240 313386749 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff880413623240 313386753 C Co:1:001:0 0 0
ffff880415681e40 313436660 C Ii:5:001:1 0:128 1 = 02
ffff880415681e40 313436662 S Ii:5:001:1 -115:128 2 <
ffff880413623240 313446737 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880413623240 313446949 C Ci:1:001:0 0 4 = 03051000
ffff880413623240 313506740 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff880413623240 313506744 C Co:1:001:0 0 0
ffff880413623240 313513610 S Co:1:000:0 s 00 05 000c 0000 0000 0
ffff880413623240 313513697 C Co:1:000:0 -71 0
ffff880415681e40 313686664 C Ii:5:001:1 0:128 1 = 02
ffff880415681e40 313686666 S Ii:5:001:1 -115:128 2 <
ffff880413d2d540 313716733 S Co:1:000:0 s 00 05 000c 0000 0000 0
ffff880413d2d540 313716823 C Co:1:000:0 -71 0
ffff8804136233c0 313932921 S Co:1:001:0 s 23 01 0001 0007 0000 0
ffff8804136233c0 313932925 C Co:1:001:0 0 0
ffff88041355c900 313932932 S Co:5:001:0 s 23 03 0004 0001 0000 0
ffff88041355c900 313932937 C Co:5:001:0 0 0
ffff880415681e40 313936668 C Ii:5:001:1 0:128 1 = 02
ffff880415681e40 313936671 S Ii:5:001:1 -115:128 2 <
ffff88041355c900 313986797 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff88041355c900 313986817 C Ci:5:001:0 0 4 = 00010000
ffff88041355c900 313986821 S Co:5:001:0 s 23 01 0014 0001 0000 0
ffff88041355c900 313986822 C Co:5:001:0 0 0
ffff88041355c900 313986824 S Co:5:001:0 s 23 01 0001 0001 0000 0
ffff88041355c900 313986827 C Co:5:001:0 0 0
ffff8804136233c0 313986834 S Co:1:001:0 s 23 03 0004 0007 0000 0
ffff88041355c900 313986836 S Co:5:001:0 s 23 01 0001 0001 0000 0
ffff8804136233c0 313986838 C Co:1:001:0 0 0
ffff88041355c900 313986840 C Co:5:001:0 0 0
ffff8804136233c0 314046747 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff8804136233c0 314046954 C Ci:1:001:0 0 4 = 03051000
ffff8804136233c0 314106748 S Co:1:001:0 s 23 01 0014 0007 0000 0
ffff8804136233c0 314106752 C Co:1:001:0 0 0
ffff8804136233c0 314113622 S Co:1:000:0 s 00 05 000d 0000 0000 0
ffff8804136233c0 314113699 C Co:1:000:0 -71 0
ffff8804136233c0 314316754 S Co:1:000:0 s 00 05 000d 0000 0000 0
ffff8804136233c0 314316824 C Co:1:000:0 -71 0
ffff880413d2d6c0 314532924 S Co:1:001:0 s 23 01 0001 0007 0000 0
ffff880413d2d6c0 314532928 C Co:1:001:0 0 0
ffff880413d2d6c0 314539282 S Co:1:001:0 s 23 01 0001 0007 0000 0
ffff880413d2d6c0 314539285 C Co:1:001:0 0 0
ffff880415633b40 314539361 C Ii:1:001:1 0:2048 2 = 8000
ffff880415633b40 314539363 S Ii:1:001:1 -115:2048 4 <
ffff880413d2d6c0 314556747 S Ci:1:001:0 s a3 00 0000 0008 0004 4 <
ffff880413d2d6c0 314556750 C Ci:1:001:0 0 4 = 00010000
ffff880413d2d6c0 314556757 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880413d2d6c0 314556764 C Ci:5:001:0 0 4 = 01010100
ffff880413d2d6c0 314556766 S Co:5:001:0 s 23 01 0010 0001 0000 0
ffff880413d2d6c0 314556768 C Co:5:001:0 0 0
ffff880413623180 314746914 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880413623180 314746920 C Ci:5:001:0 0 4 = 01010000
ffff880413623180 314786763 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880413623180 314786767 C Ci:5:001:0 0 4 = 01010000
ffff880413623180 314826760 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880413623180 314826765 C Ci:5:001:0 0 4 = 01010000
ffff880413623180 314866761 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880413623180 314866766 C Ci:5:001:0 0 4 = 01010000
ffff880413623180 314906762 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880413623180 314906766 C Ci:5:001:0 0 4 = 01010000
ffff880413623180 314906777 S Co:5:001:0 s 23 03 0004 0001 0000 0
ffff880413623180 314906782 C Co:5:001:0 0 0
ffff880413623180 314966763 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880413623180 314966783 C Ci:5:001:0 0 4 = 03010000
ffff880413623180 315026765 S Co:5:001:0 s 23 01 0014 0001 0000 0
ffff880413623180 315026767 C Co:5:001:0 0 0
ffff880413623180 315033553 S Ci:5:000:0 s 80 06 0100 0000 0040 64 <
ffff880413623180 315037856 C Ci:5:000:0 0 18 = 12010002 00000040 dd140200 01000102 0301
ffff880413623180 315037867 S Co:5:001:0 s 23 03 0004 0001 0000 0
ffff880413623180 315037871 C Co:5:001:0 0 0
ffff880413d2d000 315096768 S Ci:5:001:0 s a3 00 0000 0001 0004 4 <
ffff880413d2d000 315096789 C Ci:5:001:0 0 4 = 03010000
ffff880413d2d000 315156758 S Co:5:001:0 s 23 01 0014 0001 0000 0
ffff880413d2d000 315156760 C Co:5:001:0 0 0
ffff880413d2d000 315156762 S Co:5:000:0 s 00 05 0004 0000 0000 0
ffff880413d2d000 315159853 C Co:5:000:0 0 0
ffff880413d2d000 315176759 S Ci:5:004:0 s 80 06 0100 0000 0012 18 <
ffff880413d2d000 315180853 C Ci:5:004:0 0 18 = 12010002 00000040 dd140200 01000102 0301
ffff880413d2d000 315180862 S Ci:5:004:0 s 80 06 0600 0000 000a 10 <
ffff880413d2d000 315185853 C Ci:5:004:0 0 10 = 0a060002 00000040 0100
ffff880413d2d000 315193019 S Ci:5:004:0 s 80 06 0200 0000 0009 9 <
ffff880413d2d000 315197852 C Ci:5:004:0 0 9 = 09026900 040100c0 32
ffff880413d2d000 315197860 S Ci:5:004:0 s 80 06 0200 0000 0069 105 <
ffff880413d2d000 315203852 C Ci:5:004:0 0 105 = 09026900 040100c0 32090400 00020806 50000705 81024000 00070502 02400000
ffff880413623180 315203872 S Ci:5:004:0 s 80 06 0300 0000 00ff 255 <
ffff880413623180 315209852 C Ci:5:004:0 0 4 = 04030904
ffff880413623180 315209862 S Ci:5:004:0 s 80 06 0302 0409 00ff 255 <
ffff880413623180 315215852 C Ci:5:004:0 0 24 = 18034d00 75006c00 74006900 64006500 76006900 63006500
ffff880413623180 315215859 S Ci:5:004:0 s 80 06 0301 0409 00ff 255 <
ffff880413623180 315221851 C Ci:5:004:0 0 26 = 1a035000 65007000 70006500 72006300 6f006e00 20004100 4700
ffff880413623180 315221858 S Ci:5:004:0 s 80 06 0303 0409 00ff 255 <
ffff880413623180 315228852 C Ci:5:004:0 0 66 = 42033000 30003800 33006300 36003000 31006100 61003400 38006400 32006400
ffff880413d2d300 315258849 S Co:5:004:0 s 00 09 0001 0000 0000 0
ffff880413d2d300 315268851 C Co:5:004:0 0 0
ffff880413f93a80 315277655 S Ci:5:004:0 s 80 06 0303 0409 00ff 255 <
ffff880413f93a80 315279852 C Ci:5:004:0 0 66 = 42033000 30003800 33006300 36003000 31006100 61003400 38006400 32006400
ffff880413623d80 315279905 S Co:5:004:0 s 21 0a 0000 0002 0000 0
ffff880413623d80 315280851 C Co:5:004:0 0 0
ffff880413f93cc0 315280859 S Ci:5:004:0 s 81 06 2200 0002 004f 79 <
ffff880413f93cc0 315281856 C Ci:5:004:0 0 79 = 05010902 a1010901 a1000509 19012903 15002501 95037501 81029501 75058101
ffff88041341ea80 315282064 S Ci:5:004:0 s a1 01 0100 0002 0006 64 <
ffff88041341ea80 315282853 C Ci:5:004:0 0 6 = 00bf3c7f 1e00
ffff88041341ed80 315306115 S Ci:5:004:0 s 80 06 0303 0409 00ff 255 <
ffff88041341ed80 315308853 C Ci:5:004:0 0 66 = 42033000 30003800 33006300 36003000 31006100 61003400 38006400 32006400
ffff88041341e540 315308902 S Co:5:004:0 s 21 0a 0000 0003 0000 0
ffff88041341e540 315309852 C Co:5:004:0 0 0
ffff88041341e540 315309860 S Ci:5:004:0 s 81 06 2200 0003 0042 66 <
ffff88041341e540 315310853 C Ci:5:004:0 0 66 = 05010906 a1010507 19e029e7 15002501 75019508 81029501 75088101 190029e7
ffff88041341e900 315311009 S Co:5:004:0 s 21 09 0200 0003 0001 1 = 00
ffff88041341e900 315321479 C Co:5:004:0 0 1 >
ffff88041341e540 315321516 S Ii:5:004:6 -115:8 8 <
ffff88041341e9c0 315334508 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff88041341e9c0 315334520 C Ci:1:001:0 0 4 = 00010100
ffff88041341e9c0 315334522 S Co:1:001:0 s 23 01 0010 0007 0000 0
ffff88041341e9c0 315334525 C Co:1:001:0 0 0
ffff88041341e9c0 315334530 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff88041341e9c0 315334532 C Ci:1:001:0 0 4 = 00010000
ffff880412c810c0 315366774 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880412c810c0 315366779 C Ci:1:001:0 0 4 = 00010000
ffff880412c81840 315406774 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880412c81840 315406779 C Ci:1:001:0 0 4 = 00010000
ffff880412c81840 315446774 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880412c81840 315446777 C Ci:1:001:0 0 4 = 00010000
ffff880412c81840 315486774 S Ci:1:001:0 s a3 00 0000 0007 0004 4 <
ffff880412c81840 315486777 C Ci:1:001:0 0 4 = 00010000
ffff880413d2d9c0 316266776 S Ci:5:004:0 s a1 fe 0000 0000 0001 1 <
ffff880413d2d9c0 316267855 C Ci:5:004:0 0 1 = 00
ffff880413d2d9c0 316267971 S Bo:5:004:2 -115 31 = 55534243 01000000 24000000 80000612 00000024 00000000 00000000 000000
ffff880413d2d9c0 316268852 C Bo:5:004:2 0 31 >
ffff880411728600 316268861 S Bi:5:004:1 -115 36 <
ffff880411728600 316269853 C Bi:5:004:1 0 36 = 05800302 1f000000 50657070 65724320 56697274 75616c20 44697363 20312020
ffff880413d2d9c0 316269860 S Bi:5:004:1 -115 13 <
ffff880413d2d9c0 316270852 C Bi:5:004:1 0 13 = 55534253 01000000 00000000 00
ffff880413d2d9c0 316279518 S Bo:5:004:2 -115 31 = 55534243 02000000 00000000 00000600 00000000 00000000 00000000 000000
ffff880413d2df00 316279522 S Ci:5:004:0 s a1 fe 0000 0001 0001 1 <
ffff880413d2df00 316280854 C Ci:5:004:0 0 1 = 00
ffff880413d2d9c0 316280861 C Bo:5:004:2 0 31 >
ffff880413d2d9c0 316280871 S Bi:5:004:1 -115 13 <
ffff880413d2df00 316280935 S Bo:5:004:4 -115 31 = 55534243 01000000 24000000 80000612 00000024 00000000 00000000 000000
ffff880413d2d9c0 316281852 C Bi:5:004:1 0 13 = 55534253 02000000 00000000 01
ffff880413d2df00 316281858 C Bo:5:004:4 0 31 >
ffff880413d2d9c0 316281860 S Bo:5:004:2 -115 31 = 55534243 03000000 12000000 80000603 00000012 00000000 00000000 000000
ffff8804117289c0 316281864 S Bi:5:004:3 -115 36 <
ffff880413d2d9c0 316282851 C Bo:5:004:2 0 31 >
ffff8804117289c0 316282856 C Bi:5:004:3 0 36 = 05800302 1f000000 50657070 65724320 56697274 75616c20 44697363 20322020
ffff8804135be600 316282859 S Bi:5:004:1 -115 18 <
ffff880413d2df00 316282863 S Bi:5:004:3 -115 13 <
ffff8804135be600 316283853 C Bi:5:004:1 0 18 = 70000600 0000000a 00000000 29000000 0000
ffff880413d2df00 316283858 C Bi:5:004:3 0 13 = 55534253 01000000 00000000 00
ffff880413d2d9c0 316283860 S Bi:5:004:1 -115 13 <
ffff880413d2d9c0 316284852 C Bi:5:004:1 0 13 = 55534253 03000000 00000000 00
ffff880413d2df00 316292511 S Bo:5:004:4 -115 31 = 55534243 02000000 00000000 00000600 00000000 00000000 00000000 000000
ffff880413d2d9c0 316292518 S Bo:5:004:2 -115 31 = 55534243 04000000 00000000 00000600 00000000 00000000 00000000 000000
ffff880413d2df00 316293852 C Bo:5:004:4 0 31 >
ffff880413d2d9c0 316293857 C Bo:5:004:2 0 31 >
ffff880413d2df00 316293859 S Bi:5:004:3 -115 13 <
ffff880413d2d9c0 316293863 S Bi:5:004:1 -115 13 <
ffff880413d2df00 316294852 C Bi:5:004:3 0 13 = 55534253 02000000 00000000 01
ffff880413d2d9c0 316294858 C Bi:5:004:1 0 13 = 55534253 04000000 00000000 01
ffff880413d2df00 316294860 S Bo:5:004:4 -115 31 = 55534243 03000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880413d2d9c0 316294864 S Bo:5:004:2 -115 31 = 55534243 05000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880413d2df00 316295852 C Bo:5:004:4 0 31 >
ffff880413d2d9c0 316295856 C Bo:5:004:2 0 31 >
ffff880411728c00 316295860 S Bi:5:004:3 -115 18 <
ffff8804135bee40 316295862 S Bi:5:004:1 -115 18 <
ffff880411728c00 316296853 C Bi:5:004:3 0 18 = 70000600 0000000a 00000000 29000000 0000
ffff8804135bee40 316296859 C Bi:5:004:1 0 18 = 70000200 0000000a 00000000 3a000000 0000
ffff880413d2df00 316296861 S Bi:5:004:3 -115 13 <
ffff880413d2d9c0 316296864 S Bi:5:004:1 -115 13 <
ffff880413d2df00 316297852 C Bi:5:004:3 0 13 = 55534253 03000000 00000000 00
ffff880413d2d9c0 316297858 C Bi:5:004:1 0 13 = 55534253 05000000 00000000 00
ffff880413d2df00 316297890 S Bo:5:004:4 -115 31 = 55534243 04000000 00000000 00000600 00000000 00000000 00000000 000000
ffff880413d2d9c0 316297891 S Bo:5:004:2 -115 31 = 55534243 06000000 80000000 80000a5a 002a0000 00000080 00000000 000000
ffff880413d2df00 316298852 C Bo:5:004:4 0 31 >
ffff880413d2d9c0 316298857 C Bo:5:004:2 0 31 >
ffff880413d2df00 316298858 S Bi:5:004:3 -115 13 <
ffff880412fc30c0 316298863 S Bi:5:004:1 -115 128 <
ffff880413d2df00 316299853 C Bi:5:004:3 0 13 = 55534253 04000000 00000000 01
ffff880412fc30c0 316299860 C Bi:5:004:1 0 128 = 70000200 0000000a 00000000 3a000000 00000012 00000000 00000000 00000020
ffff880413d2df00 316299861 S Bo:5:004:4 -115 31 = 55534243 05000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880413d2d9c0 316299865 S Bi:5:004:1 -115 13 <
ffff880413d2df00 316300852 C Bo:5:004:4 0 31 >
ffff880413d2d9c0 316300856 C Bi:5:004:1 0 13 = 55534253 06000000 80000000 01
ffff880411728c00 316300859 S Bi:5:004:3 -115 18 <
ffff880413d2d9c0 316300862 S Bo:5:004:2 -115 31 = 55534243 07000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880411728c00 316301854 C Bi:5:004:3 0 18 = 70000200 0000000a 00000000 3a000000 0000
ffff880413d2d9c0 316301861 C Bo:5:004:2 0 31 >
ffff880413d2df00 316301862 S Bi:5:004:3 -115 13 <
ffff8804135be480 316301868 S Bi:5:004:1 -115 18 <
ffff880413d2df00 316302852 C Bi:5:004:3 0 13 = 55534253 05000000 00000000 00
ffff8804135be480 316302858 C Bi:5:004:1 0 18 = 70000500 0000000a 00000000 24000000 0000
ffff880413d2d9c0 316302865 S Bi:5:004:1 -115 13 <
ffff880413d2df00 316302873 S Bo:5:004:4 -115 31 = 55534243 06000000 80000000 80000a5a 002a0000 00000080 00000000 000000
ffff880413d2d9c0 316303852 C Bi:5:004:1 0 13 = 55534253 07000000 00000000 00
ffff880413d2df00 316303857 C Bo:5:004:4 0 31 >
ffff880411728c00 316303862 S Bi:5:004:3 -115 128 <
ffff880411728c00 316304853 C Bi:5:004:3 0 128 = 70000200 0000000a 00000000 3a000000 00000012 00000000 00000000 00000020
ffff880413d2df00 316304860 S Bi:5:004:3 -115 13 <
ffff880413d2df00 316305853 C Bi:5:004:3 0 13 = 55534253 06000000 80000000 01
ffff880413d2df00 316305862 S Bo:5:004:4 -115 31 = 55534243 07000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880413d2df00 316306852 C Bo:5:004:4 0 31 >
ffff880411728c00 316306860 S Bi:5:004:3 -115 18 <
ffff880413d2d9c0 316308877 S Bo:5:004:2 -115 31 = 55534243 08000000 08000000 80000a4a 01000010 00000008 00000000 000000
ffff880411728c00 316309853 C Bi:5:004:3 0 18 = 70000500 0000000a 00000000 24000000 0000
ffff880413d2d9c0 316309859 C Bo:5:004:2 0 31 >
ffff880413d2df00 316309862 S Bi:5:004:3 -115 13 <
ffff8804135bee40 316309867 S Bi:5:004:1 -115 8 <
ffff880413d2df00 316310854 C Bi:5:004:3 0 13 = 55534253 07000000 00000000 00
ffff8804135bee40 316310861 C Bi:5:004:1 0 8 = 70000500 0000000a
ffff880413d2d9c0 316310868 S Bi:5:004:1 -115 13 <
ffff880413d2d9c0 316311853 C Bi:5:004:1 0 13 = 55534253 08000000 08000000 01
ffff880413d2d9c0 316311861 S Bo:5:004:2 -115 31 = 55534243 09000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880413d2d9c0 316312869 C Bo:5:004:2 0 31 >
ffff8804135be0c0 316312877 S Bi:5:004:1 -115 18 <
ffff8804135be0c0 316313853 C Bi:5:004:1 0 18 = 70000500 0000000a 00000000 20000000 0000
ffff880413d2d9c0 316313862 S Bi:5:004:1 -115 13 <
ffff880413d2d9c0 316314852 C Bi:5:004:1 0 13 = 55534253 09000000 00000000 00
ffff880413d2d9c0 316314870 S Bo:5:004:2 -115 31 = 55534243 0a000000 00100000 80000ca0 00000000 00000010 00000000 000000
ffff880413d2d9c0 316315852 C Bo:5:004:2 0 31 >
ffff880412fc3300 316315859 S Bi:5:004:1 -115 4096 <
ffff880412fc3300 316319858 C Bi:5:004:1 0 4096 = 00000008 00000000 00000000 00000000 00000012 00000000 00000000 00000020
ffff880413d2d9c0 316319893 S Bi:5:004:1 -115 13 <
ffff880413d2d9c0 316320853 C Bi:5:004:1 0 13 = 55534253 0a000000 f00f0000 00
ffff880413d2d9c0 316320873 S Bo:5:004:2 -115 31 = 55534243 0b000000 00000000 00000600 00000000 00000000 00000000 000000
ffff880413d2d9c0 316321853 C Bo:5:004:2 0 31 >
ffff880413d2d9c0 316321860 S Bi:5:004:1 -115 13 <
ffff880413d2df00 316321970 S Bo:5:004:4 -115 31 = 55534243 08000000 00100000 80000ca0 00000000 00000010 00000000 000000
ffff880413d2d9c0 316322852 C Bi:5:004:1 0 13 = 55534253 0b000000 00000000 01
ffff880413d2df00 316322858 C Bo:5:004:4 0 31 >
ffff880413d2d9c0 316322861 S Bo:5:004:2 -115 31 = 55534243 0c000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880412cac540 316322865 S Bi:5:004:3 -115 4096 <
ffff880413d2d9c0 316323852 C Bo:5:004:2 0 31 >
ffff880412caccc0 316323861 S Bi:5:004:1 -115 18 <
ffff880412cac540 316327858 C Bi:5:004:3 0 4096 = 00000008 00000000 00000000 00000000 00000012 00000000 00000000 00000020
ffff880412caccc0 316327863 C Bi:5:004:1 0 18 = 70000200 0000000a 00000000 3a000000 0000
ffff880413d2df00 316327864 S Bi:5:004:3 -115 13 <
ffff880413d2d9c0 316327869 S Bi:5:004:1 -115 13 <
ffff880413d2df00 316328852 C Bi:5:004:3 0 13 = 55534253 08000000 f00f0000 00
ffff880413d2d9c0 316328857 C Bi:5:004:1 0 13 = 55534253 0c000000 00000000 00
ffff880413d2d9c0 316328920 S Bo:5:004:2 -115 31 = 55534243 0d000000 00000000 00000600 00000000 00000000 00000000 000000
ffff880413d2d9c0 316329852 C Bo:5:004:2 0 31 >
ffff880413d2d9c0 316329857 S Bi:5:004:1 -115 13 <
ffff880413d2d9c0 316330852 C Bi:5:004:1 0 13 = 55534253 0d000000 00000000 01
ffff880413d2d9c0 316330861 S Bo:5:004:2 -115 31 = 55534243 0e000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880413d2d9c0 316331852 C Bo:5:004:2 0 31 >
ffff880412caccc0 316331859 S Bi:5:004:1 -115 18 <
ffff880412caccc0 316332854 C Bi:5:004:1 0 18 = 70000200 0000000a 00000000 3a000000 0000
ffff880413d2d9c0 316332862 S Bi:5:004:1 -115 13 <
ffff880413d2d9c0 316333852 C Bi:5:004:1 0 13 = 55534253 0e000000 00000000 00
ffff880413d2df00 316333907 S Bo:5:004:4 -115 31 = 55534243 09000000 08000000 80000a4a 01000010 00000008 00000000 000000
ffff880413d2d9c0 316333913 S Bo:5:004:2 -115 31 = 55534243 0f000000 08000000 80000a4a 01000010 00000008 00000000 000000
ffff880413d2df00 316334852 C Bo:5:004:4 0 31 >
ffff880413d2d9c0 316334858 C Bo:5:004:2 0 31 >
ffff880412caccc0 316334859 S Bi:5:004:3 -115 8 <
ffff8804139010c0 316334865 S Bi:5:004:1 -115 8 <
ffff880412caccc0 316335853 C Bi:5:004:3 0 8 = 55534243 09000000
ffff8804139010c0 316335859 C Bi:5:004:1 0 8 = 55534243 0f000000
ffff880413d2df00 316335859 S Bi:5:004:3 -115 13 <
ffff880413d2d9c0 316335869 S Bi:5:004:1 -115 13 <
ffff880413d2df00 316336852 C Bi:5:004:3 0 13 = 55534253 09000000 08000000 01
ffff880413d2d9c0 316336859 C Bi:5:004:1 0 13 = 55534253 0f000000 08000000 01
ffff880413d2df00 316336861 S Bo:5:004:4 -115 31 = 55534243 0a000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880413d2d9c0 316336866 S Bo:5:004:2 -115 31 = 55534243 10000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880413d2df00 316337853 C Bo:5:004:4 0 31 >
ffff880413d2d9c0 316337858 C Bo:5:004:2 0 31 >
ffff880412caccc0 316337859 S Bi:5:004:3 -115 18 <
ffff8804139010c0 316337863 S Bi:5:004:1 -115 18 <
ffff880412caccc0 316342853 C Bi:5:004:3 0 18 = 70000500 0000000a 00000000 20000000 0000
ffff880413d2df00 316342860 S Bi:5:004:3 -115 13 <
ffff8804139010c0 316343853 C Bi:5:004:1 0 18 = 70000500 0000000a 00000000 20000000 0000
ffff880413d2df00 316343860 C Bi:5:004:3 0 13 = 55534253 0a000000 00000000 00
ffff880413d2d9c0 316343862 S Bi:5:004:1 -115 13 <
ffff880413d2df00 316343880 S Bo:5:004:4 -115 31 = 55534243 0b000000 00000000 00000600 00000000 00000000 00000000 000000
ffff880413d2d9c0 316344853 C Bi:5:004:1 0 13 = 55534253 10000000 00000000 00
ffff880413d2df00 316344859 C Bo:5:004:4 0 31 >
ffff880413d2d9c0 316344883 S Bo:5:004:2 -115 31 = 55534243 11000000 00000000 00000600 00000000 00000000 00000000 000000
ffff880413d2df00 316344887 S Bi:5:004:3 -115 13 <
ffff880413d2d9c0 316345852 C Bo:5:004:2 0 31 >
ffff880413d2df00 316345857 C Bi:5:004:3 0 13 = 55534253 0b000000 00000000 01
ffff880413d2d9c0 316345858 S Bi:5:004:1 -115 13 <
ffff880413d2df00 316345862 S Bo:5:004:4 -115 31 = 55534243 0c000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880413d2d9c0 316346852 C Bi:5:004:1 0 13 = 55534253 11000000 00000000 01
ffff880413d2df00 316346858 C Bo:5:004:4 0 31 >
ffff880413d2d9c0 316346861 S Bo:5:004:2 -115 31 = 55534243 12000000 12000000 80000603 00000012 00000000 00000000 000000
ffff8804139010c0 316346864 S Bi:5:004:3 -115 18 <
ffff880413d2d9c0 316347852 C Bo:5:004:2 0 31 >
ffff8804139010c0 316347858 C Bi:5:004:3 0 18 = 70000200 0000000a 00000000 3a000000 0000
ffff880412cac540 316347859 S Bi:5:004:1 -115 18 <
ffff880413d2df00 316347864 S Bi:5:004:3 -115 13 <
ffff880412cac540 316348854 C Bi:5:004:1 0 18 = 70000200 0000000a 00000000 3a000000 0000
ffff880413d2df00 316348860 C Bi:5:004:3 0 13 = 55534253 0c000000 00000000 00
ffff880413d2d9c0 316348861 S Bi:5:004:1 -115 13 <
ffff880413d2df00 316348906 S Bo:5:004:4 -115 31 = 55534243 0d000000 00000000 00000600 00000000 00000000 00000000 000000
ffff880413d2d9c0 316349852 C Bi:5:004:1 0 13 = 55534253 12000000 00000000 00
ffff880413d2df00 316349858 C Bo:5:004:4 0 31 >
ffff880413d2df00 316349865 S Bi:5:004:3 -115 13 <
ffff880413d2df00 316350852 C Bi:5:004:3 0 13 = 55534253 0d000000 00000000 01
ffff880413d2df00 316350860 S Bo:5:004:4 -115 31 = 55534243 0e000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880413d2df00 316351852 C Bo:5:004:4 0 31 >
ffff880412cac540 316351859 S Bi:5:004:3 -115 18 <
ffff880412cac540 316352853 C Bi:5:004:3 0 18 = 70000200 0000000a 00000000 3a000000 0000
ffff880413d2df00 316352861 S Bi:5:004:3 -115 13 <
ffff880413d2df00 316353852 C Bi:5:004:3 0 13 = 55534253 0e000000 00000000 00
ffff880413d2d9c0 316353879 S Bo:5:004:2 -115 31 = 55534243 13000000 00000000 0000061e 00000000 00000000 00000000 000000
ffff880413d2d9c0 316354851 C Bo:5:004:2 0 31 >
ffff880413d2d9c0 316354857 S Bi:5:004:1 -115 13 <
ffff880413d2d9c0 316355852 C Bi:5:004:1 0 13 = 55534253 13000000 00000000 00
ffff880413d2df00 316355901 S Bo:5:004:4 -115 31 = 55534243 0f000000 00000000 0000061e 00000000 00000000 00000000 000000
ffff880413d2df00 316356852 C Bo:5:004:4 0 31 >
ffff880413d2df00 316356859 S Bi:5:004:3 -115 13 <
ffff880413d2df00 316357853 C Bi:5:004:3 0 13 = 55534253 0f000000 00000000 00
ffff880413d2df00 316357877 S Bo:5:004:4 -115 31 = 55534243 10000000 08000000 80000a4a 01000010 00000008 00000000 000000
ffff880413d2df00 316358853 C Bo:5:004:4 0 31 >
ffff8804117283c0 316358863 S Bi:5:004:3 -115 8 <
ffff8804117283c0 316359854 C Bi:5:004:3 0 8 = 55534243 10000000
ffff880413d2df00 316359863 S Bi:5:004:3 -115 13 <
ffff880413d2df00 316360852 C Bi:5:004:3 0 13 = 55534253 10000000 08000000 01
ffff880413d2df00 316360862 S Bo:5:004:4 -115 31 = 55534243 11000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880413d2df00 316361852 C Bo:5:004:4 0 31 >
ffff8804150e6d80 316361887 S Bi:5:004:3 -115 18 <
ffff8804150e6d80 316362852 C Bi:5:004:3 0 18 = 70000500 0000000a 00000000 20000000 0000
ffff880413d2df00 316362859 S Bi:5:004:3 -115 13 <
ffff880413d2df00 316363852 C Bi:5:004:3 0 13 = 55534253 11000000 00000000 00
ffff880413d2df00 316363894 S Bo:5:004:4 -115 31 = 55534243 12000000 00000000 00000600 00000000 00000000 00000000 000000
ffff880413d2df00 316364852 C Bo:5:004:4 0 31 >
ffff880413d2df00 316364877 S Bi:5:004:3 -115 13 <
ffff880413d2df00 316365855 C Bi:5:004:3 0 13 = 55534253 12000000 00000000 01
ffff880413d2df00 316365866 S Bo:5:004:4 -115 31 = 55534243 13000000 12000000 80000603 00000012 00000000 00000000 000000
ffff880413d2df00 316366852 C Bo:5:004:4 0 31 >
ffff88041563de40 316366861 S Bi:5:004:3 -115 18 <
ffff88041563de40 316367854 C Bi:5:004:3 0 18 = 70000200 0000000a 00000000 3a000000 0000
ffff880413d2df00 316367861 S Bi:5:004:3 -115 13 <
ffff880413d2df00 316368852 C Bi:5:004:3 0 13 = 55534253 13000000 00000000 00

--------------080102030709070300040402--
