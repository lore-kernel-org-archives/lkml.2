Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1GEFwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 01:52:42 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:12868 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753494Ab1GEFwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 01:52:38 -0400
Message-ID: <4E12A69C.8030709@dsn.okisemi.com>
Date: Tue, 05 Jul 2011 14:52:28 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        tglx@linutronix.de
Subject: Re: [PATCH v4] pch_gpio: Support interrupt function
References: <1309486572-2789-1-git-send-email-tomoya-linux@dsn.okisemi.com> <20110704163137.GA28042@ponder.secretlab.ca> <4E128A7D.9020508@dsn.okisemi.com> <20110705035902.GB13713@ponder.secretlab.ca>
In-Reply-To: <20110705035902.GB13713@ponder.secretlab.ca>
Content-Type: multipart/mixed;
 boundary="------------060809070202000403020703"
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060809070202000403020703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

(2011/07/05 12:59), Grant Likely wrote:
>> As we discussed before,
>> without specifying PCH_IRQ_BASE,
>> it seemed IRQ number collision issue occurred.
>> Thus, I added PCH_IRQ_BASE.
>
> Then fix the irq collision.  If the core code hands out an irq range
> that is in-use by some other driver, then the other driver isn't
> reserving it's irqs correctly and it needs to be fixed.  Hacking
> around the problem doesn't help anything in the long run.
>

I tried to work irq_alloc_descs with dynamic allocation.(Set 2nd 
parameter as 0).
However it seems the issue remains to be seen.
I attached dmesg output log, /proc/interrupts log and modified PCH-GPIO 
source code.

Could you give me your opinion or information ?

NOTE: I tested on linux-3.0-rc3

-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.

--------------060809070202000403020703
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0-rc3+ (root@localhost.localdomain) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #15 SMP Tue Jul 5 14:18:27 JST 2011
[    0.000000] Disabled fast string operations
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d000 (usable)
[    0.000000]  BIOS-e820: 000000000009d000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fd72000 (usable)
[    0.000000]  BIOS-e820: 000000003fd72000 - 000000003fdb5000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fdb5000 - 000000003fdbb000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003fdbb000 - 000000003fdbe000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fdbe000 - 000000003fdcd000 (reserved)
[    0.000000]  BIOS-e820: 000000003fdcd000 - 000000003fdce000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fdce000 - 000000003fdeb000 (reserved)
[    0.000000]  BIOS-e820: 000000003fdeb000 - 000000003fdf8000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fdf8000 - 000000003fe1a000 (reserved)
[    0.000000]  BIOS-e820: 000000003fe1a000 - 000000003fef0000 (usable)
[    0.000000]  BIOS-e820: 000000003fef0000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec86000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 00000000ffe10000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M., BIOS 4.6.3 03/03/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x3fef0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 0C0000000 write-back
[    0.000000]   1 base 03FEF0000 mask 0FFFF0000 uncachable
[    0.000000]   2 base 03FF00000 mask 0FFF00000 write-through
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 01000000
[    0.000000] Base memory trampoline at [c0099000] 99000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-0000000036ffe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0036c00000 page 2M
[    0.000000]  0036c00000 - 0036ffe000 page 4k
[    0.000000] kernel direct mapping tables up to 36ffe000 @ ff9000-1000000
[    0.000000] RAMDISK: 37745000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 36753000 - 36ffd81e
[    0.000000] Move RAMDISK from 0000000037745000 - 0000000037fef81d to 36753000 - 36ffd81d
[    0.000000] ACPI: RSDP 000f0450 00024 (v03 ALASKA)
[    0.000000] ACPI: XSDT 3fdb5078 0004C (v01 ALASKA CROWNBAY 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 3fdb9d78 000F4 (v04 ALASKA CROWNBAY 01072009 AMI  00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20110413/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0x3FDF1F40/0x000000003FDF1F80, using 32 (20110413/tbfadt-489)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0x00000000000009F4/0x0 (20110413/tbfadt-560)
[    0.000000] ACPI Warning: Invalid length for Pm2ControlBlock: 0, using default 8 (20110413/tbfadt-610)
[    0.000000] ACPI: DSDT 3fdb5150 04C26 (v02 ALASKA CROWNBAY 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 3fdf1f40 00040
[    0.000000] ACPI: APIC 3fdb9e70 00062 (v01 ALASKA CROWNBAY 01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 3fdb9ed8 0003C (v01 A M I  OEMMCFG  01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 3fdb9f18 00038 (v01 A M I  OEMHPET  01072009 AMI. 00000003)
[    0.000000] ACPI: SPCR 3fdb9f50 00050 (v01  A M I   APTIO4 01072009 AMI. 00000003)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 142MB HIGHMEM available.
[    0.000000] 879MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 36ffe000
[    0.000000]   low ram: 0 - 36ffe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00036ffe
[    0.000000]   HighMem  0x00036ffe -> 0x0003fef0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0003fd72
[    0.000000]     0: 0x0003fe1a -> 0x0003fef0
[    0.000000] On node 0 totalpages: 261589
[    0.000000] free_area_init_node: node 0, pgdat c0a42a40, node_mem_map f5f52200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3949 pages, LIFO batch:0
[    0.000000]   Normal zone: 1728 pages used for memmap
[    0.000000]   Normal zone: 219454 pages, LIFO batch:31
[    0.000000]   HighMem zone: 286 pages used for memmap
[    0.000000]   HighMem zone: 36140 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:bec00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f5800000 s25024 r0 d24128 u2097152
[    0.000000] pcpu-alloc: s25024 r0 d24128 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259543
[    0.000000] Kernel command line: ro root=/dev/mapper/VolGroup-lv_root rd_LVM_LV=VolGroup/lv_root rd_LVM_LV=VolGroup/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=jp106 rhgb quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 4189696 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (00036ffe:0003fef0)
[    0.000000] Memory: 1016268k/1047488k available (3899k kernel code, 30088k reserved, 2578k data, 564k init, 145704k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xff575000 - 0xfffff000   (10792 kB)
[    0.000000]     pkmap   : 0xff000000 - 0xff400000   (4096 kB)
[    0.000000]     vmalloc : 0xf77fe000 - 0xfeffe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf6ffe000   ( 879 MB)
[    0.000000]       .init : 0xc0a54000 - 0xc0ae1000   ( 564 kB)
[    0.000000]       .data : 0xc07cef3c - 0xc0a537c0   (2578 kB)
[    0.000000]       .text : 0xc0400000 - 0xc07cef3c   (3899 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:2304
[    0.000000] CPU 0 irqstacks, hard=f5420000 soft=f5422000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1500.340 MHz processor.
[    0.001006] Calibrating delay loop (skipped), value calculated using timer frequency.. 3000.68 BogoMIPS (lpj=1500340)
[    0.001020] pid_max: default: 32768 minimum: 301
[    0.001410] Security Framework initialized
[    0.001426] SELinux:  Initializing.
[    0.001482] SELinux:  Starting in permissive mode
[    0.002157] Mount-cache hash table entries: 512
[    0.003441] Initializing cgroup subsys cpuacct
[    0.003561] Initializing cgroup subsys memory
[    0.003623] Initializing cgroup subsys devices
[    0.003631] Initializing cgroup subsys freezer
[    0.003637] Initializing cgroup subsys net_cls
[    0.003644] Initializing cgroup subsys blkio
[    0.003792] Disabled fast string operations
[    0.003804] CPU: Physical Processor ID: 0
[    0.003809] CPU: Processor Core ID: 0
[    0.003817] mce: CPU supports 5 MCE banks
[    0.003837] using mwait in idle threads.
[    0.004549] ACPI: Core revision 20110413
[    0.013742] ftrace: allocating 24083 entries in 48 pages
[    0.016125] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.016482] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.026499] CPU0: Genuine Intel(R) CPU        @ 1.50GHz stepping 01
[    0.026998] Performance Events: PEBS fmt0+, generic architected perfmon, Intel PMU driver.
[    0.026998] ... version:                3
[    0.026998] ... bit width:              40
[    0.026998] ... generic registers:      2
[    0.026998] ... value mask:             000000ffffffffff
[    0.026998] ... max period:             000000007fffffff
[    0.026998] ... fixed-purpose events:   3
[    0.026998] ... event mask:             0000000700000003
[    0.027185] CPU 1 irqstacks, hard=f54d6000 soft=f54d8000
[    0.027192] Booting Node   0, Processors  #1 Ok.
[    0.027199] smpboot cpu 1: start_ip = 99000
[    0.001999] Initializing CPU#1
[    0.001999] calibrate_delay_direct() timer_rate_max=1499773 timer_rate_min=1499742 pre_start=3671042777 pre_end=3686040362
[    0.001999] calibrate_delay_direct() timer_rate_max=1499775 timer_rate_min=1499742 pre_start=3689039897 pre_end=3704037482
[    0.001999] calibrate_delay_direct() timer_rate_max=1499773 timer_rate_min=1499740 pre_start=3707037047 pre_end=3722034617
[    0.001999] calibrate_delay_direct() timer_rate_max=1499773 timer_rate_min=1499743 pre_start=3725034182 pre_end=3740031767
[    0.001999] calibrate_delay_direct() timer_rate_max=1499773 timer_rate_min=1499742 pre_start=3743031287 pre_end=3758028857
[    0.001999] Disabled fast string operations
[    0.099034] Brought up 2 CPUs
[    0.099049] Total of 2 processors activated (6000.22 BogoMIPS).
[    0.100454] devtmpfs: initialized
[    0.101287] PM: Registering ACPI NVS region at 3fd72000 (274432 bytes)
[    0.101287] PM: Registering ACPI NVS region at 3fdbb000 (12288 bytes)
[    0.101287] PM: Registering ACPI NVS region at 3fdcd000 (4096 bytes)
[    0.101287] PM: Registering ACPI NVS region at 3fdeb000 (53248 bytes)
[    0.104447] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.104510] Time:  5:31:12  Date: 07/05/11
[    0.104755] NET: Registered protocol family 16
[    0.105552] ACPI: bus type pci registered
[    0.106071] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.106081] PCI: not using MMCONFIG
[    0.106428] PCI: Using configuration type 1 for base access
[    0.111268] bio: create slab <bio-0> at 0
[    0.114290] ACPI: EC: Look up EC in DSDT
[    0.116863] ACPI: Executed 1 blocks of module-level executable AML code
[    0.125055] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.125742] ACPI: SSDT 3fdf2810 00374 (v01    AMI      IST 00000001 MSFT 03000001)
[    0.126684] ACPI: Dynamic OEM Table Load:
[    0.126693] ACPI: SSDT   (null) 00374 (v01    AMI      IST 00000001 MSFT 03000001)
[    0.127619] ACPI: Interpreter enabled
[    0.127633] ACPI: (supports S0 S3 S4 S5)
[    0.127686] ACPI: Using IOAPIC for interrupt routing
[    0.127759] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.128783] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.128790] PCI: Using MMCONFIG for extended config space
[    0.129884] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.130533] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.145742] ACPI: No dock devices found.
[    0.145750] HEST: Table not found.
[    0.145760] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.146246] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.146598] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.146607] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.146615] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.146623] pci_root PNP0A08:00: host bridge window [mem 0x40000000-0xffffffff]
[    0.146659] pci 0000:00:00.0: [8086:4114] type 0 class 0x000600
[    0.146730] pci 0000:00:01.0: [8086:8183] type 0 class 0x000600
[    0.146872] pci 0000:00:17.0: [8086:8184] type 1 class 0x000604
[    0.146972] pci 0000:00:17.0: PME# supported from D0 D3hot D3cold
[    0.146996] pci 0000:00:17.0: PME# disabled
[    0.147047] pci 0000:00:18.0: [8086:8185] type 1 class 0x000604
[    0.147146] pci 0000:00:18.0: PME# supported from D0 D3hot D3cold
[    0.147156] pci 0000:00:18.0: PME# disabled
[    0.147197] pci 0000:00:19.0: [8086:8180] type 1 class 0x000604
[    0.147294] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.147304] pci 0000:00:19.0: PME# disabled
[    0.147344] pci 0000:00:1a.0: [8086:8181] type 1 class 0x000604
[    0.147440] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.147450] pci 0000:00:1a.0: PME# disabled
[    0.147493] pci 0000:00:1b.0: [8086:811b] type 0 class 0x000403
[    0.147526] pci 0000:00:1b.0: reg 10: [mem 0xfe400000-0xfe403fff 64bit]
[    0.147624] pci 0000:00:1b.0: PME# supported from D0 D3hot
[    0.147633] pci 0000:00:1b.0: PME# disabled
[    0.147673] pci 0000:00:1f.0: [8086:8186] type 0 class 0x000601
[    0.147888] pci 0000:01:00.0: [8086:8800] type 1 class 0x000604
[    0.147954] pci 0000:01:00.0: reg 38: [mem 0xfe300000-0xfe30ffff pref]
[    0.148034] pci 0000:01:00.0: supports D1
[    0.148041] pci 0000:01:00.0: PME# supported from D0 D1 D3hot D3cold
[    0.148051] pci 0000:01:00.0: PME# disabled
[    0.150018] pci 0000:00:17.0: PCI bridge to [bus 01-02]
[    0.150030] pci 0000:00:17.0:   bridge window [io  0xf000-0xffff]
[    0.150040] pci 0000:00:17.0:   bridge window [mem 0xfe200000-0xfe3fffff]
[    0.150051] pci 0000:00:17.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.150161] pci 0000:02:00.0: [8086:8801] type 0 class 0x00ff00
[    0.150227] pci 0000:02:00.0: reg 14: [mem 0xfe259000-0xfe2597ff]
[    0.150328] pci 0000:02:00.0: reg 30: [mem 0xfe220000-0xfe23ffff pref]
[    0.150441] pci 0000:02:00.1: [8086:8802] type 0 class 0x000200
[    0.150489] pci 0000:02:00.1: reg 10: [io  0xf020-0xf03f]
[    0.150515] pci 0000:02:00.1: reg 14: [mem 0xfe258000-0xfe2581ff]
[    0.150673] pci 0000:02:00.1: PME# supported from D0
[    0.150684] pci 0000:02:00.1: PME# disabled
[    0.150739] pci 0000:02:00.2: [8086:8803] type 0 class 0x00ff00
[    0.150806] pci 0000:02:00.2: reg 14: [mem 0xfe257000-0xfe25703f]
[    0.150967] pci 0000:02:00.2: PME# supported from D0
[    0.150980] pci 0000:02:00.2: PME# disabled
[    0.151068] pci 0000:02:02.0: [8086:8804] type 0 class 0x000c03
[    0.151117] pci 0000:02:02.0: reg 10: [mem 0xfe256000-0xfe2560ff]
[    0.151294] pci 0000:02:02.0: PME# supported from D0 D3hot
[    0.151306] pci 0000:02:02.0: PME# disabled
[    0.151361] pci 0000:02:02.1: [8086:8805] type 0 class 0x000c03
[    0.151409] pci 0000:02:02.1: reg 10: [mem 0xfe255000-0xfe2550ff]
[    0.151585] pci 0000:02:02.1: PME# supported from D0 D3hot
[    0.151597] pci 0000:02:02.1: PME# disabled
[    0.151651] pci 0000:02:02.2: [8086:8806] type 0 class 0x000c03
[    0.151699] pci 0000:02:02.2: reg 10: [mem 0xfe254000-0xfe2540ff]
[    0.151878] pci 0000:02:02.2: PME# supported from D0 D3hot
[    0.151891] pci 0000:02:02.2: PME# disabled
[    0.151951] pci 0000:02:02.3: [8086:8807] type 0 class 0x000c03
[    0.152018] pci 0000:02:02.3: reg 10: [mem 0xfe253000-0xfe2530ff]
[    0.152207] pci 0000:02:02.3: PME# supported from D0 D3hot
[    0.152227] pci 0000:02:02.3: PME# disabled
[    0.152294] pci 0000:02:02.4: [8086:8808] type 0 class 0x000c03
[    0.152362] pci 0000:02:02.4: reg 14: [mem 0xfe240000-0xfe241fff]
[    0.152520] pci 0000:02:02.4: PME# supported from D0
[    0.152533] pci 0000:02:02.4: PME# disabled
[    0.152599] pci 0000:02:04.0: [8086:8809] type 0 class 0x000805
[    0.152648] pci 0000:02:04.0: reg 10: [mem 0xfe252000-0xfe2521ff]
[    0.152878] pci 0000:02:04.1: [8086:880a] type 0 class 0x000805
[    0.152927] pci 0000:02:04.1: reg 10: [mem 0xfe251000-0xfe2511ff]
[    0.153200] pci 0000:02:06.0: [8086:880b] type 0 class 0x000106
[    0.153330] pci 0000:02:06.0: reg 20: [io  0xf000-0xf01f]
[    0.153356] pci 0000:02:06.0: reg 24: [mem 0xfe250000-0xfe2503ff]
[    0.153382] pci 0000:02:06.0: reg 30: [mem 0xfe200000-0xfe21ffff pref]
[    0.153513] pci 0000:02:08.0: [8086:880c] type 0 class 0x000c03
[    0.153562] pci 0000:02:08.0: reg 10: [mem 0xfe24f000-0xfe24f0ff]
[    0.153738] pci 0000:02:08.0: PME# supported from D0 D3hot
[    0.153750] pci 0000:02:08.0: PME# disabled
[    0.153804] pci 0000:02:08.1: [8086:880d] type 0 class 0x000c03
[    0.153855] pci 0000:02:08.1: reg 10: [mem 0xfe24e000-0xfe24e0ff]
[    0.154046] pci 0000:02:08.1: PME# supported from D0 D3hot
[    0.154067] pci 0000:02:08.1: PME# disabled
[    0.154123] pci 0000:02:08.2: [8086:880e] type 0 class 0x000c03
[    0.154173] pci 0000:02:08.2: reg 10: [mem 0xfe24d000-0xfe24d0ff]
[    0.154350] pci 0000:02:08.2: PME# supported from D0 D3hot
[    0.154361] pci 0000:02:08.2: PME# disabled
[    0.154421] pci 0000:02:08.3: [8086:880f] type 0 class 0x000c03
[    0.154475] pci 0000:02:08.3: reg 10: [mem 0xfe24c000-0xfe24c0ff]
[    0.154662] pci 0000:02:08.3: PME# supported from D0 D3hot
[    0.154673] pci 0000:02:08.3: PME# disabled
[    0.154754] pci 0000:02:0a.0: [8086:8810] type 0 class 0x00ff00
[    0.154827] pci 0000:02:0a.0: reg 14: [mem 0xfe24b000-0xfe24b0ff]
[    0.155071] pci 0000:02:0a.1: [8086:8811] type 0 class 0x000700
[    0.155121] pci 0000:02:0a.1: reg 10: [io  0xf070-0xf077]
[    0.155147] pci 0000:02:0a.1: reg 14: [mem 0xfe24a000-0xfe24a00f]
[    0.155305] pci 0000:02:0a.1: PME# supported from D0
[    0.155316] pci 0000:02:0a.1: PME# disabled
[    0.155371] pci 0000:02:0a.2: [8086:8812] type 0 class 0x000700
[    0.155419] pci 0000:02:0a.2: reg 10: [io  0xf060-0xf067]
[    0.155445] pci 0000:02:0a.2: reg 14: [mem 0xfe249000-0xfe24900f]
[    0.155651] pci 0000:02:0a.3: [8086:8813] type 0 class 0x000700
[    0.155699] pci 0000:02:0a.3: reg 10: [io  0xf050-0xf057]
[    0.155725] pci 0000:02:0a.3: reg 14: [mem 0xfe248000-0xfe24800f]
[    0.155936] pci 0000:02:0a.4: [8086:8814] type 0 class 0x000700
[    0.155995] pci 0000:02:0a.4: reg 10: [io  0xf040-0xf047]
[    0.156021] pci 0000:02:0a.4: reg 14: [mem 0xfe247000-0xfe24700f]
[    0.156256] pci 0000:02:0c.0: [8086:8815] type 0 class 0x00ff00
[    0.156329] pci 0000:02:0c.0: reg 14: [mem 0xfe246000-0xfe2460ff]
[    0.156552] pci 0000:02:0c.1: [8086:8816] type 0 class 0x000c80
[    0.156619] pci 0000:02:0c.1: reg 14: [mem 0xfe245000-0xfe24501f]
[    0.156825] pci 0000:02:0c.2: [8086:8817] type 0 class 0x000c80
[    0.156895] pci 0000:02:0c.2: reg 14: [mem 0xfe244000-0xfe2440ff]
[    0.157128] pci 0000:02:0c.3: [8086:8818] type 0 class 0x000c09
[    0.157197] pci 0000:02:0c.3: reg 14: [mem 0xfe243000-0xfe2431ff]
[    0.157403] pci 0000:02:0c.4: [8086:8819] type 0 class 0x00ff00
[    0.157470] pci 0000:02:0c.4: reg 14: [mem 0xfe242000-0xfe2420ff]
[    0.157719] pci 0000:01:00.0: PCI bridge to [bus 02-02]
[    0.157735] pci 0000:01:00.0:   bridge window [io  0xf000-0xffff]
[    0.157747] pci 0000:01:00.0:   bridge window [mem 0xfe200000-0xfe2fffff]
[    0.157763] pci 0000:01:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.157851] pci 0000:00:18.0: PCI bridge to [bus 03-03]
[    0.157865] pci 0000:00:18.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.157875] pci 0000:00:18.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.157886] pci 0000:00:18.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.157957] pci 0000:00:19.0: PCI bridge to [bus 04-04]
[    0.157967] pci 0000:00:19.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.157977] pci 0000:00:19.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.157994] pci 0000:00:19.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.158110] pci 0000:05:00.0: [104c:8231] type 1 class 0x000604
[    0.158262] pci 0000:05:00.0: supports D1 D2
[    0.158301] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.158323] pci 0000:00:1a.0: PCI bridge to [bus 05-06]
[    0.158333] pci 0000:00:1a.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.158344] pci 0000:00:1a.0:   bridge window [mem 0xfd800000-0xfe0fffff]
[    0.158355] pci 0000:00:1a.0:   bridge window [mem 0xfa000000-0xfbffffff pref]
[    0.158506] pci 0000:06:00.0: [102b:2527] type 0 class 0x000300
[    0.158554] pci 0000:06:00.0: reg 10: [mem 0xfa000000-0xfbffffff pref]
[    0.158580] pci 0000:06:00.0: reg 14: [mem 0xfe020000-0xfe023fff]
[    0.158605] pci 0000:06:00.0: reg 18: [mem 0xfd800000-0xfdffffff]
[    0.158686] pci 0000:06:00.0: reg 30: [mem 0xfe000000-0xfe01ffff pref]
[    0.158849] pci 0000:05:00.0: PCI bridge to [bus 06-06]
[    0.158869] pci 0000:05:00.0:   bridge window [io  0xfff000-0x0000] (disabled)
[    0.158882] pci 0000:05:00.0:   bridge window [mem 0xfd800000-0xfe0fffff]
[    0.158899] pci 0000:05:00.0:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.158950] pci_bus 0000:00: on NUMA node 0
[    0.158961] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.159177] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.159567] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P1P1._PRT]
[    0.159670] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P1._PRT]
[    0.159770] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P3P1._PRT]
[    0.160180]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.160686]  pci0000:00: ACPI _OSC control (0x1d) granted
[    0.214884] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14)
[    0.215063] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 10 11 12 14)
[    0.215210] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14)
[    0.215355] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14)
[    0.215499] ACPI: PCI Interrupt Link [LNKE] (IRQs 9 15) *0, disabled.
[    0.215637] ACPI: PCI Interrupt Link [LNKF] (IRQs 9 15) *0, disabled.
[    0.215777] ACPI: PCI Interrupt Link [LNKG] (IRQs 9 15) *0, disabled.
[    0.215928] ACPI: PCI Interrupt Link [LNKH] (IRQs 9 15) *0, disabled.
[    0.216263] vgaarb: device added: PCI:0000:06:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.216271] vgaarb: loaded
[    0.216275] vgaarb: bridge control possible 0000:06:00.0
[    0.216673] SCSI subsystem initialized
[    0.217051] libata version 3.00 loaded.
[    0.217247] usbcore: registered new interface driver usbfs
[    0.217296] usbcore: registered new interface driver hub
[    0.217309] usbcore: registered new device driver usb
[    0.217309] PCI: Using ACPI for IRQ routing
[    0.230275] PCI: pci_cache_line_size set to 64 bytes
[    0.230576] reserve RAM buffer: 000000000009d000 - 000000000009ffff 
[    0.230583] reserve RAM buffer: 000000003fd72000 - 000000003fffffff 
[    0.230593] reserve RAM buffer: 000000003fef0000 - 000000003fffffff 
[    0.230960] NetLabel: Initializing
[    0.230966] NetLabel:  domain hash size = 128
[    0.230980] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.231024] NetLabel:  unlabeled traffic allowed by default
[    0.231037] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.231050] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.231062] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.234133] Switching to clocksource hpet
[    0.234743] Switched to NOHz mode on CPU #0
[    0.234824] Switched to NOHz mode on CPU #1
[    0.259448] pnp: PnP ACPI init
[    0.259493] ACPI: bus type pnp registered
[    0.259708] pnp 00:00: [bus 00-ff]
[    0.259717] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.259724] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.259731] pnp 00:00: [io  0x0d00-0xffff window]
[    0.259738] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.259745] pnp 00:00: [mem 0x00000000 window]
[    0.259752] pnp 00:00: [mem 0x40000000-0xffffffff window]
[    0.259906] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.260275] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.260283] pnp 00:01: [mem 0x3ff00000-0x3fffffff]
[    0.260291] pnp 00:01: [mem 0xffffffff-0xfffffffe disabled]
[    0.260298] pnp 00:01: [mem 0xfee00000-0xfeefffff]
[    0.260457] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.260467] system 00:01: [mem 0x3ff00000-0x3fffffff] has been reserved
[    0.260475] system 00:01: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.260485] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.260941] pnp 00:02: [io  0x0000-0xffffffff disabled]
[    0.260950] pnp 00:02: [io  0x0000-0xffffffff disabled]
[    0.260957] pnp 00:02: [io  0x0a00-0x0a3f]
[    0.260963] pnp 00:02: [io  0x0000-0xffffffff disabled]
[    0.260970] pnp 00:02: [io  0x0000-0xffffffff disabled]
[    0.260977] pnp 00:02: [io  0x0000-0xffffffff disabled]
[    0.260984] pnp 00:02: [io  0x0000-0xffffffff disabled]
[    0.261171] system 00:02: [io  0x0a00-0x0a3f] has been reserved
[    0.261182] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.261849] pnp 00:03: [io  0x03f8-0x03ff]
[    0.261874] pnp 00:03: [irq 4]
[    0.261887] pnp 00:03: [dma 0 disabled]
[    0.262093] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.262135] pnp 00:04: [dma 4]
[    0.262142] pnp 00:04: [io  0x0000-0x000f]
[    0.262148] pnp 00:04: [io  0x0081-0x0083]
[    0.262154] pnp 00:04: [io  0x0087]
[    0.262160] pnp 00:04: [io  0x0089-0x008b]
[    0.262166] pnp 00:04: [io  0x008f]
[    0.262172] pnp 00:04: [io  0x00c0-0x00df]
[    0.262253] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.262290] pnp 00:05: [io  0x0070-0x0077]
[    0.262305] pnp 00:05: [irq 8]
[    0.262385] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.262416] pnp 00:06: [io  0x0061]
[    0.262497] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.262563] pnp 00:07: [io  0x0010-0x001f]
[    0.262570] pnp 00:07: [io  0x0022-0x003f]
[    0.262576] pnp 00:07: [io  0x0044-0x005f]
[    0.262582] pnp 00:07: [io  0x0063]
[    0.262588] pnp 00:07: [io  0x0065]
[    0.262594] pnp 00:07: [io  0x0067-0x006f]
[    0.262600] pnp 00:07: [io  0x0072-0x007f]
[    0.262606] pnp 00:07: [io  0x0080]
[    0.262612] pnp 00:07: [io  0x0084-0x0086]
[    0.262618] pnp 00:07: [io  0x0088]
[    0.262624] pnp 00:07: [io  0x008c-0x008e]
[    0.262630] pnp 00:07: [io  0x0090-0x009f]
[    0.262636] pnp 00:07: [io  0x00a2-0x00bf]
[    0.262642] pnp 00:07: [io  0x00e0-0x00ef]
[    0.262649] pnp 00:07: [io  0x04d0-0x04d1]
[    0.262655] pnp 00:07: [io  0x0000-0xffffffff disabled]
[    0.262662] pnp 00:07: [io  0x0000-0xffffffff disabled]
[    0.262822] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.262832] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.262864] pnp 00:08: [io  0x00f0-0x00ff]
[    0.262880] pnp 00:08: [irq 13]
[    0.262963] pnp 00:08: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.263080] pnp 00:09: [io  0x0060]
[    0.263087] pnp 00:09: [io  0x0064]
[    0.263100] pnp 00:09: [irq 1]
[    0.263204] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.263319] pnp 00:0a: [irq 12]
[    0.263429] pnp 00:0a: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.263966] pnp 00:0b: [io  0x0900-0x097f]
[    0.263974] pnp 00:0b: [io  0x09c0-0x09ff]
[    0.263981] pnp 00:0b: [io  0x0400-0x043f]
[    0.263987] pnp 00:0b: [io  0x0480-0x04bf]
[    0.263994] pnp 00:0b: [mem 0xfec00000-0xfec85fff]
[    0.264000] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
[    0.264039] pnp 00:0b: [mem 0x000c0000-0x000dffff]
[    0.264047] pnp 00:0b: [mem 0x000e0000-0x000effff]
[    0.264053] pnp 00:0b: [mem 0x000f0000-0x000fffff]
[    0.264060] pnp 00:0b: [mem 0xff800000-0xffffffff]
[    0.264234] system 00:0b: [io  0x0900-0x097f] has been reserved
[    0.264243] system 00:0b: [io  0x09c0-0x09ff] has been reserved
[    0.264251] system 00:0b: [io  0x0400-0x043f] has been reserved
[    0.264258] system 00:0b: [io  0x0480-0x04bf] has been reserved
[    0.264268] system 00:0b: [mem 0xfec00000-0xfec85fff] could not be reserved
[    0.264277] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.264286] system 00:0b: [mem 0x000c0000-0x000dffff] could not be reserved
[    0.264294] system 00:0b: [mem 0x000e0000-0x000effff] could not be reserved
[    0.264303] system 00:0b: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.264311] system 00:0b: [mem 0xff800000-0xffffffff] could not be reserved
[    0.264321] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.264475] pnp 00:0c: [mem 0xfed00000-0xfed003ff]
[    0.264577] pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.264702] pnp 00:0d: [mem 0x3fef0000-0x3fefffff]
[    0.264862] system 00:0d: [mem 0x3fef0000-0x3fefffff] has been reserved
[    0.264873] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.265359] pnp: PnP ACPI: found 14 devices
[    0.265365] ACPI: ACPI bus type pnp unregistered
[    0.306304] PCI: max bus depth: 2 pci_try_num: 3
[    0.306388] pci 0000:00:1a.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.306400] pci 0000:00:19.0: BAR 14: assigned [mem 0x40000000-0x401fffff]
[    0.306410] pci 0000:00:19.0: BAR 15: assigned [mem 0x40200000-0x403fffff pref]
[    0.306420] pci 0000:00:19.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.306430] pci 0000:00:18.0: BAR 14: assigned [mem 0x40400000-0x405fffff]
[    0.306441] pci 0000:00:18.0: BAR 15: assigned [mem 0x40600000-0x407fffff pref]
[    0.306451] pci 0000:00:18.0: BAR 13: assigned [io  0x3000-0x3fff]
[    0.306462] pci 0000:00:17.0: BAR 15: assigned [mem 0x40800000-0x409fffff pref]
[    0.306477] pci 0000:01:00.0: PCI bridge to [bus 02-02]
[    0.306486] pci 0000:01:00.0:   bridge window [io  0xf000-0xffff]
[    0.306500] pci 0000:01:00.0:   bridge window [mem 0xfe200000-0xfe2fffff]
[    0.306511] pci 0000:01:00.0:   bridge window [mem pref disabled]
[    0.306527] pci 0000:00:17.0: PCI bridge to [bus 01-02]
[    0.306535] pci 0000:00:17.0:   bridge window [io  0xf000-0xffff]
[    0.306547] pci 0000:00:17.0:   bridge window [mem 0xfe200000-0xfe3fffff]
[    0.306558] pci 0000:00:17.0:   bridge window [mem 0x40800000-0x409fffff pref]
[    0.306571] pci 0000:00:18.0: PCI bridge to [bus 03-03]
[    0.306579] pci 0000:00:18.0:   bridge window [io  0x3000-0x3fff]
[    0.306591] pci 0000:00:18.0:   bridge window [mem 0x40400000-0x405fffff]
[    0.306602] pci 0000:00:18.0:   bridge window [mem 0x40600000-0x407fffff pref]
[    0.306616] pci 0000:00:19.0: PCI bridge to [bus 04-04]
[    0.306624] pci 0000:00:19.0:   bridge window [io  0x2000-0x2fff]
[    0.306636] pci 0000:00:19.0:   bridge window [mem 0x40000000-0x401fffff]
[    0.306646] pci 0000:00:19.0:   bridge window [mem 0x40200000-0x403fffff pref]
[    0.306661] pci 0000:05:00.0: PCI bridge to [bus 06-06]
[    0.306666] pci 0000:05:00.0:   bridge window [io  disabled]
[    0.306681] pci 0000:05:00.0:   bridge window [mem 0xfd800000-0xfe0fffff]
[    0.306693] pci 0000:05:00.0:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.306710] pci 0000:00:1a.0: PCI bridge to [bus 05-06]
[    0.306718] pci 0000:00:1a.0:   bridge window [io  0x1000-0x1fff]
[    0.306730] pci 0000:00:1a.0:   bridge window [mem 0xfd800000-0xfe0fffff]
[    0.306741] pci 0000:00:1a.0:   bridge window [mem 0xfa000000-0xfbffffff pref]
[    0.306784] pci 0000:00:17.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.306796] pci 0000:00:17.0: setting latency timer to 64
[    0.306815] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.306826] pci 0000:01:00.0: setting latency timer to 64
[    0.306843] pci 0000:00:18.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.306853] pci 0000:00:18.0: setting latency timer to 64
[    0.306868] pci 0000:00:19.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.306878] pci 0000:00:19.0: setting latency timer to 64
[    0.306893] pci 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.306903] pci 0000:00:1a.0: setting latency timer to 64
[    0.306922] pci 0000:05:00.0: setting latency timer to 64
[    0.306932] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.306939] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.306946] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.306953] pci_bus 0000:00: resource 7 [mem 0x40000000-0xffffffff]
[    0.306960] pci_bus 0000:01: resource 0 [io  0xf000-0xffff]
[    0.306967] pci_bus 0000:01: resource 1 [mem 0xfe200000-0xfe3fffff]
[    0.306975] pci_bus 0000:01: resource 2 [mem 0x40800000-0x409fffff pref]
[    0.306982] pci_bus 0000:02: resource 0 [io  0xf000-0xffff]
[    0.306989] pci_bus 0000:02: resource 1 [mem 0xfe200000-0xfe2fffff]
[    0.306997] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.307025] pci_bus 0000:03: resource 1 [mem 0x40400000-0x405fffff]
[    0.307033] pci_bus 0000:03: resource 2 [mem 0x40600000-0x407fffff pref]
[    0.307040] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.307047] pci_bus 0000:04: resource 1 [mem 0x40000000-0x401fffff]
[    0.307054] pci_bus 0000:04: resource 2 [mem 0x40200000-0x403fffff pref]
[    0.307062] pci_bus 0000:05: resource 0 [io  0x1000-0x1fff]
[    0.307069] pci_bus 0000:05: resource 1 [mem 0xfd800000-0xfe0fffff]
[    0.307076] pci_bus 0000:05: resource 2 [mem 0xfa000000-0xfbffffff pref]
[    0.307084] pci_bus 0000:06: resource 1 [mem 0xfd800000-0xfe0fffff]
[    0.307091] pci_bus 0000:06: resource 2 [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.307327] NET: Registered protocol family 2
[    0.307564] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.308158] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.309429] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.310143] TCP: Hash tables configured (established 131072 bind 65536)
[    0.310151] TCP reno registered
[    0.310169] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.310192] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.311003] NET: Registered protocol family 1
[    0.767142] pci 0000:05:00.0: TI XIO2000a quirk detected; secondary bus fast back-to-back transfers disabled
[    0.767169] pci 0000:06:00.0: Boot video device
[    0.767179] PCI: CLS 64 bytes, default 64
[    0.767340] Trying to unpack rootfs image as initramfs...
[    1.305158] Freeing initrd memory: 8876k freed
[    1.319061] apm: BIOS not found.
[    1.319587] audit: initializing netlink socket (disabled)
[    1.319618] type=2000 audit(1309843873.318:1): initialized
[    1.371603] highmem bounce pool size: 64 pages
[    1.371617] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.377302] VFS: Disk quotas dquot_6.5.2
[    1.377758] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.380329] msgmni has been set to 1717
[    1.380593] SELinux:  Registering netfilter hooks
[    1.381734] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.381745] io scheduler noop registered
[    1.381750] io scheduler deadline registered
[    1.381793] io scheduler cfq registered (default)
[    1.381953] pch_gpio_probe: 1
[    1.381986] pch_gpio 0000:02:00.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.381992] pch_gpio_probe: 2
[    1.382067] pch_gpio_probe: 3
[    1.382139] pch_gpio_probe: 4
[    1.382145] irq_base=17
[    1.382180] pch_gpio_probe: 5
[    1.382200] pch_gpio_probe: 6
[    1.382525] pcieport 0000:00:17.0: setting latency timer to 64
[    1.382783] pcieport 0000:00:18.0: setting latency timer to 64
[    1.383077] pcieport 0000:00:19.0: setting latency timer to 64
[    1.383328] pcieport 0000:00:1a.0: setting latency timer to 64
[    1.383663] pcieport 0000:00:17.0: Signaling PME through PCIe PME interrupt
[    1.383671] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    1.383677] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    1.383683] pci 0000:02:00.1: Signaling PME through PCIe PME interrupt
[    1.383690] pch_gpio 0000:02:00.2: Signaling PME through PCIe PME interrupt
[    1.383696] pci 0000:02:02.0: Signaling PME through PCIe PME interrupt
[    1.383702] pci 0000:02:02.1: Signaling PME through PCIe PME interrupt
[    1.383708] pci 0000:02:02.2: Signaling PME through PCIe PME interrupt
[    1.383714] pci 0000:02:02.3: Signaling PME through PCIe PME interrupt
[    1.383720] pci 0000:02:02.4: Signaling PME through PCIe PME interrupt
[    1.383726] pci 0000:02:04.0: Signaling PME through PCIe PME interrupt
[    1.383732] pci 0000:02:04.1: Signaling PME through PCIe PME interrupt
[    1.383738] pci 0000:02:06.0: Signaling PME through PCIe PME interrupt
[    1.383744] pci 0000:02:08.0: Signaling PME through PCIe PME interrupt
[    1.383750] pci 0000:02:08.1: Signaling PME through PCIe PME interrupt
[    1.383757] pci 0000:02:08.2: Signaling PME through PCIe PME interrupt
[    1.383763] pci 0000:02:08.3: Signaling PME through PCIe PME interrupt
[    1.383769] pci 0000:02:0a.0: Signaling PME through PCIe PME interrupt
[    1.383775] pci 0000:02:0a.1: Signaling PME through PCIe PME interrupt
[    1.383781] pci 0000:02:0a.2: Signaling PME through PCIe PME interrupt
[    1.383787] pci 0000:02:0a.3: Signaling PME through PCIe PME interrupt
[    1.383793] pci 0000:02:0a.4: Signaling PME through PCIe PME interrupt
[    1.383799] pci 0000:02:0c.0: Signaling PME through PCIe PME interrupt
[    1.383805] pci 0000:02:0c.1: Signaling PME through PCIe PME interrupt
[    1.383811] pci 0000:02:0c.2: Signaling PME through PCIe PME interrupt
[    1.383817] pci 0000:02:0c.3: Signaling PME through PCIe PME interrupt
[    1.383824] pci 0000:02:0c.4: Signaling PME through PCIe PME interrupt
[    1.383834] pcie_pme 0000:00:17.0:pcie01: service driver pcie_pme loaded
[    1.383856] pcieport 0000:00:18.0: Signaling PME through PCIe PME interrupt
[    1.383867] pcie_pme 0000:00:18.0:pcie01: service driver pcie_pme loaded
[    1.383888] pcieport 0000:00:19.0: Signaling PME through PCIe PME interrupt
[    1.383899] pcie_pme 0000:00:19.0:pcie01: service driver pcie_pme loaded
[    1.383920] pcieport 0000:00:1a.0: Signaling PME through PCIe PME interrupt
[    1.383927] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
[    1.383933] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
[    1.383943] pcie_pme 0000:00:1a.0:pcie01: service driver pcie_pme loaded
[    1.384040] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.384255] pciehp 0000:00:17.0:pcie04: HPC vendor_id 8086 device_id 8184 ss_vid 8086 ss_did 8186
[    1.384313] pciehp 0000:00:17.0:pcie04: service driver pciehp loaded
[    1.384340] pciehp 0000:00:18.0:pcie04: HPC vendor_id 8086 device_id 8185 ss_vid 8086 ss_did 8186
[    1.384388] pciehp 0000:00:18.0:pcie04: service driver pciehp loaded
[    1.384414] pciehp 0000:00:19.0:pcie04: HPC vendor_id 8086 device_id 8180 ss_vid 8086 ss_did 8186
[    1.384460] pciehp 0000:00:19.0:pcie04: service driver pciehp loaded
[    1.384486] pciehp 0000:00:1a.0:pcie04: HPC vendor_id 8086 device_id 8181 ss_vid 8086 ss_did 8186
[    1.384533] pciehp 0000:00:1a.0:pcie04: service driver pciehp loaded
[    1.384557] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.384563] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.385667] intel_idle: MWAIT substates: 0x3020220
[    1.385691] intel_idle: v0.4 model 0x26
[    1.385696] intel_idle: lapic_timer_reliable_states 0x2
[    1.385709] Marking TSC unstable due to TSC halts in idle states deeper than C2
[    1.385988] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.386029] ACPI: Power Button [PWRB]
[    1.386209] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    1.386283] ACPI: Lid Switch [LID]
[    1.386452] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.386462] ACPI: Power Button [PWRF]
[    1.386478] ACPI Error: Could not enable PowerButton event (20110413/evxfevnt-198)
[    1.386489] ACPI Warning: Could not enable fixed event 0x2 (20110413/evxface-197)
[    1.391164] button: probe of LNXPWRBN:00 failed with error -22
[    1.391676] ACPI: acpi_idle yielding to intel_idle
[    1.396822] ERST: Table is not found!
[    1.396944] isapnp: Scanning for PnP cards...
[    1.755425] isapnp: No Plug & Play device found
[    1.755512] pch-dma 0000:02:0a.0: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.755555] pch-dma 0000:02:0a.0: setting latency timer to 64
[    1.756415] pch-dma 0000:02:0c.0: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.756444] pch-dma 0000:02:0c.0: setting latency timer to 64
[    1.757115] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.022633] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.044662] 00:03: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.045211] serial 0000:02:0a.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.066183] 0000:02:0a.1: ttyS1 at I/O 0xf070 (irq = 19) is a 16550A
[    2.066403] serial 0000:02:0a.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.087339] 0000:02:0a.2: ttyS2 at I/O 0xf060 (irq = 19) is a 16550A
[    2.087548] serial 0000:02:0a.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.108494] 0000:02:0a.3: ttyS3 at I/O 0xf050 (irq = 19) is a 16550A
[    2.108704] serial 0000:02:0a.4: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.108715] Couldn't register serial port 0000:02:0a.4: -28
[    2.109602] Non-volatile memory driver v1.3
[    2.109610] Linux agpgart interface v0.103
[    2.115497] brd: module loaded
[    2.117304] loop: module loaded
[    2.117469] pch_phub 0000:02:00.0: Invalid ROM contents
[    2.117855] ahci 0000:02:06.0: version 3.0
[    2.117895] ahci 0000:02:06.0: PCI INT D -> GSI 17 (level, low) -> IRQ 17
[    2.117990] ahci 0000:02:06.0: irq 40 for MSI/MSI-X
[    2.118116] ahci: SSS flag set, parallel bus scan disabled
[    2.118189] ahci 0000:02:06.0: AHCI 0001.0100 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    2.118199] ahci 0000:02:06.0: flags: ncq sntf stag pm led clo only pmp pio slum part ccc 
[    2.118213] ahci 0000:02:06.0: setting latency timer to 64
[    2.119412] scsi0 : ahci
[    2.119768] scsi1 : ahci
[    2.119932] ata1: SATA max UDMA/133 abar m1024@0xfe250000 port 0xfe250100 irq 40
[    2.119943] ata2: SATA max UDMA/133 abar m1024@0xfe250000 port 0xfe250180 irq 40
[    2.120286] pch_spi 0000:02:0c.1: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.120692] Fixed MDIO Bus: probed
[    2.120750] pch_gbe 0000:02:00.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.120771] pch_gbe 0000:02:00.1: setting latency timer to 64
[    2.124143] pch_gbe 0000:02:00.1: MAC address : 00:1d:12:d0:00:1c
[    2.126090] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.126144] ehci_hcd 0000:02:02.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.126184] ehci_hcd 0000:02:02.3: setting latency timer to 64
[    2.126194] ehci_hcd 0000:02:02.3: EHCI Host Controller
[    2.126353] ehci_hcd 0000:02:02.3: new USB bus registered, assigned bus number 1
[    2.147057] ehci_hcd 0000:02:02.3: cache line size of 64 is not supported
[    2.147077] ehci_hcd 0000:02:02.3: irq 19, io mem 0xfe253000
[    2.153044] ehci_hcd 0000:02:02.3: USB 2.0 started, EHCI 1.00
[    2.153098] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.153106] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.153113] usb usb1: Product: EHCI Host Controller
[    2.153118] usb usb1: Manufacturer: Linux 3.0.0-rc3+ ehci_hcd
[    2.153124] usb usb1: SerialNumber: 0000:02:02.3
[    2.153439] hub 1-0:1.0: USB hub found
[    2.153453] hub 1-0:1.0: 3 ports detected
[    2.153662] ehci_hcd 0000:02:08.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.153699] ehci_hcd 0000:02:08.3: setting latency timer to 64
[    2.153709] ehci_hcd 0000:02:08.3: EHCI Host Controller
[    2.153836] ehci_hcd 0000:02:08.3: new USB bus registered, assigned bus number 2
[    2.174052] ehci_hcd 0000:02:08.3: cache line size of 64 is not supported
[    2.174073] ehci_hcd 0000:02:08.3: irq 16, io mem 0xfe24c000
[    2.180045] ehci_hcd 0000:02:08.3: USB 2.0 started, EHCI 1.00
[    2.180099] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.180107] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.180114] usb usb2: Product: EHCI Host Controller
[    2.180119] usb usb2: Manufacturer: Linux 3.0.0-rc3+ ehci_hcd
[    2.180125] usb usb2: SerialNumber: 0000:02:08.3
[    2.180423] hub 2-0:1.0: USB hub found
[    2.180443] hub 2-0:1.0: 3 ports detected
[    2.180657] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.180706] ohci_hcd 0000:02:02.0: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.180743] ohci_hcd 0000:02:02.0: setting latency timer to 64
[    2.180753] ohci_hcd 0000:02:02.0: OHCI Host Controller
[    2.180899] ohci_hcd 0000:02:02.0: new USB bus registered, assigned bus number 3
[    2.180940] ohci_hcd 0000:02:02.0: irq 19, io mem 0xfe256000
[    2.235185] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.235193] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.235200] usb usb3: Product: OHCI Host Controller
[    2.235206] usb usb3: Manufacturer: Linux 3.0.0-rc3+ ohci_hcd
[    2.235212] usb usb3: SerialNumber: 0000:02:02.0
[    2.235531] hub 3-0:1.0: USB hub found
[    2.235549] hub 3-0:1.0: 1 port detected
[    2.235745] ohci_hcd 0000:02:02.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.235790] ohci_hcd 0000:02:02.1: setting latency timer to 64
[    2.235800] ohci_hcd 0000:02:02.1: OHCI Host Controller
[    2.235951] ohci_hcd 0000:02:02.1: new USB bus registered, assigned bus number 4
[    2.235999] ohci_hcd 0000:02:02.1: irq 19, io mem 0xfe255000
[    2.291138] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.291147] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.291153] usb usb4: Product: OHCI Host Controller
[    2.291159] usb usb4: Manufacturer: Linux 3.0.0-rc3+ ohci_hcd
[    2.291165] usb usb4: SerialNumber: 0000:02:02.1
[    2.291479] hub 4-0:1.0: USB hub found
[    2.291498] hub 4-0:1.0: 1 port detected
[    2.291707] ohci_hcd 0000:02:02.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.291746] ohci_hcd 0000:02:02.2: setting latency timer to 64
[    2.291755] ohci_hcd 0000:02:02.2: OHCI Host Controller
[    2.291894] ohci_hcd 0000:02:02.2: new USB bus registered, assigned bus number 5
[    2.291935] ohci_hcd 0000:02:02.2: irq 19, io mem 0xfe254000
[    2.346150] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.346159] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.346166] usb usb5: Product: OHCI Host Controller
[    2.346171] usb usb5: Manufacturer: Linux 3.0.0-rc3+ ohci_hcd
[    2.346177] usb usb5: SerialNumber: 0000:02:02.2
[    2.346495] hub 5-0:1.0: USB hub found
[    2.346513] hub 5-0:1.0: 1 port detected
[    2.346727] ohci_hcd 0000:02:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.346765] ohci_hcd 0000:02:08.0: setting latency timer to 64
[    2.346775] ohci_hcd 0000:02:08.0: OHCI Host Controller
[    2.346911] ohci_hcd 0000:02:08.0: new USB bus registered, assigned bus number 6
[    2.346954] ohci_hcd 0000:02:08.0: irq 16, io mem 0xfe24f000
[    2.401145] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.401154] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.401161] usb usb6: Product: OHCI Host Controller
[    2.401167] usb usb6: Manufacturer: Linux 3.0.0-rc3+ ohci_hcd
[    2.401173] usb usb6: SerialNumber: 0000:02:08.0
[    2.401492] hub 6-0:1.0: USB hub found
[    2.401512] hub 6-0:1.0: 1 port detected
[    2.401708] ohci_hcd 0000:02:08.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.401747] ohci_hcd 0000:02:08.1: setting latency timer to 64
[    2.401757] ohci_hcd 0000:02:08.1: OHCI Host Controller
[    2.401899] ohci_hcd 0000:02:08.1: new USB bus registered, assigned bus number 7
[    2.401942] ohci_hcd 0000:02:08.1: irq 16, io mem 0xfe24e000
[    2.456152] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.456161] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.456168] usb usb7: Product: OHCI Host Controller
[    2.456174] usb usb7: Manufacturer: Linux 3.0.0-rc3+ ohci_hcd
[    2.456180] usb usb7: SerialNumber: 0000:02:08.1
[    2.456500] hub 7-0:1.0: USB hub found
[    2.456519] hub 7-0:1.0: 1 port detected
[    2.456733] ohci_hcd 0000:02:08.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.456772] ohci_hcd 0000:02:08.2: setting latency timer to 64
[    2.456782] ohci_hcd 0000:02:08.2: OHCI Host Controller
[    2.456920] ohci_hcd 0000:02:08.2: new USB bus registered, assigned bus number 8
[    2.456964] ohci_hcd 0000:02:08.2: irq 16, io mem 0xfe24d000
[    2.511161] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    2.511170] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.511177] usb usb8: Product: OHCI Host Controller
[    2.511183] usb usb8: Manufacturer: Linux 3.0.0-rc3+ ohci_hcd
[    2.511189] usb usb8: SerialNumber: 0000:02:08.2
[    2.511506] hub 8-0:1.0: USB hub found
[    2.511524] hub 8-0:1.0: 1 port detected
[    2.511734] uhci_hcd: USB Universal Host Controller Interface driver
[    2.511978] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    2.515321] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.515341] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.515667] mousedev: PS/2 mouse device common for all mice
[    2.516211] rtc_cmos 00:05: RTC can wake from S4
[    2.516448] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    2.516494] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    2.516730] device-mapper: uevent: version 1.0.3
[    2.516988] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    2.517490] cpuidle: using governor ladder
[    2.517903] cpuidle: using governor menu
[    2.517909] EFI Variables Facility v0.08 2004-May-17
[    2.518470] usbcore: registered new interface driver usbhid
[    2.518475] usbhid: USB HID core driver
[    2.518533] nf_conntrack version 0.5.0 (16017 buckets, 64068 max)
[    2.519129] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.519163] TCP cubic registered
[    2.519168] Initializing XFRM netlink socket
[    2.519193] NET: Registered protocol family 17
[    2.519256] Registering the dns_resolver key type
[    2.519312] Using IPI No-Shortcut mode
[    2.519631] PM: Hibernation image not present or could not be loaded.
[    2.519669] registered taskstats version 1
[    2.519684] IMA: No TPM chip found, activating TPM-bypass!
[    2.521134]   Magic number: 3:386:516
[    2.521307] rtc_cmos 00:05: setting system clock to 2011-07-05 05:31:14 UTC (1309843874)
[    2.521462] Initializing network drop monitor service
[    2.580203] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.581478] ata1.00: ATA-8: Hitachi HDS721010CLA332, JP4OA3MA, max UDMA/133
[    2.581500] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.582851] ata1.00: configured for UDMA/133
[    2.583244] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72101 JP4O PQ: 0 ANSI: 5
[    2.583766] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.583780] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.584105] sd 0:0:0:0: [sda] Write Protect is off
[    2.584115] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.584239] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.589578]  sda: sda1 sda2
[    2.590585] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.813161] usb 7-1: new low speed USB device number 2 using ohci_hcd
[    2.889202] ata2: SATA link down (SStatus 0 SControl 300)
[    2.889421] Freeing unused kernel memory: 564k freed
[    2.890192] Write protecting the kernel text: 3900k
[    2.890299] Write protecting the kernel read-only data: 1936k
[    2.933585] dracut: dracut-006-3.fc14
[    2.951594] dracut: rd_NO_LUKS: removing cryptoluks activation
[    2.967576] udev[70]: starting version 161
[    2.996136] usb 7-1: New USB device found, idVendor=045e, idProduct=00cb
[    2.996150] usb 7-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.996161] usb 7-1: Product: Microsoft Basic Optical Mouse v2.0 
[    2.996170] usb 7-1: Manufacturer: Microsoft 
[    3.007371] input: Microsoft  Microsoft Basic Optical Mouse v2.0  as /devices/pci0000:00/0000:00:17.0/0000:01:00.0/0000:02:08.1/usb7/7-1/7-1:1.0/input/input3
[    3.008458] generic-usb 0003:045E:00CB.0001: input,hidraw0: USB HID v1.11 Mouse [Microsoft  Microsoft Basic Optical Mouse v2.0 ] on usb-0000:02:08.1-1/input0
[    3.107454] dracut: Starting plymouth daemon
[    3.165098] usb 8-1: new low speed USB device number 2 using ohci_hcd
[    3.351191] usb 8-1: New USB device found, idVendor=413c, idProduct=2003
[    3.351206] usb 8-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.351217] usb 8-1: Product: Dell USB Keyboard
[    3.351225] usb 8-1: Manufacturer: Dell
[    3.360348] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:17.0/0000:01:00.0/0000:02:08.2/usb8/8-1/8-1:1.0/input/input4
[    3.360726] generic-usb 0003:413C:2003.0002: input,hidraw1: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:02:08.2-1/input0
[    3.466435] ------------[ cut here ]------------
[    3.466460] WARNING: at arch/x86/mm/highmem_32.c:81 __kunmap_atomic+0x69/0xd3()
[    3.466469] Hardware name: To be filled by O.E.M.
[    3.466475] Modules linked in: mmc_core
[    3.466489] Pid: 155, comm: modprobe Not tainted 3.0.0-rc3+ #15
[    3.466496] Call Trace:
[    3.466510]  [<c0437f5b>] warn_slowpath_common+0x6a/0x7f
[    3.466522]  [<c0425402>] ? __kunmap_atomic+0x69/0xd3
[    3.466534]  [<c0437f84>] warn_slowpath_null+0x14/0x18
[    3.466545]  [<c0425402>] __kunmap_atomic+0x69/0xd3
[    3.466558]  [<c04bf4c3>] unmap_vmas+0x381/0x421
[    3.466572]  [<c04c1fb2>] unmap_region+0x72/0xb3
[    3.466585]  [<c04c2d5c>] do_munmap+0x1b9/0x201
[    3.466598]  [<c04c2ec6>] sys_munmap+0x37/0x47
[    3.466613]  [<c07cdedf>] sysenter_do_call+0x12/0x28
[    3.466622] ---[ end trace 3a2eac7c51395dd4 ]---
[    3.480076] sdhci: Secure Digital Host Controller Interface driver
[    3.480087] sdhci: Copyright(c) Pierre Ossman
[    3.494717] sdhci-pci 0000:02:04.0: SDHCI controller found [8086:8809] (rev 1)
[    3.494760] sdhci-pci 0000:02:04.0: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.494773] sdhci-pci 0000:02:04.0: Invalid iomem size. You may experience problems.
[    3.494863] sdhci-pci 0000:02:04.0: setting latency timer to 64
[    3.494998] Registered led device: mmc0::
[    3.497852] mmc0: SDHCI controller on PCI [0000:02:04.0] using DMA
[    3.497906] sdhci-pci 0000:02:04.1: SDHCI controller found [8086:880a] (rev 1)
[    3.497948] sdhci-pci 0000:02:04.1: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.497961] sdhci-pci 0000:02:04.1: Invalid iomem size. You may experience problems.
[    3.498617] sdhci-pci 0000:02:04.1: setting latency timer to 64
[    3.504214] Registered led device: mmc1::
[    3.504414] mmc1: SDHCI controller on PCI [0000:02:04.1] using DMA
[    3.809771] dracut: Scanning devices sda2  for LVM logical volumes VolGroup/lv_root VolGroup/lv_swap 
[    3.841648] dracut: inactive '/dev/VolGroup/lv_root' [50.00 GiB] inherit
[    3.842121] dracut: inactive '/dev/VolGroup/lv_home' [875.31 GiB] inherit
[    3.842331] dracut: inactive '/dev/VolGroup/lv_swap' [5.69 GiB] inherit
[    4.217390] EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
[    4.217400] EXT4-fs (dm-0): write access will be enabled during recovery
[    4.890209] EXT4-fs (dm-0): recovery complete
[    4.891204] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    4.924384] dracut: Mounted root filesystem /dev/mapper/VolGroup-lv_root
[    5.158039] dracut: Loading SELinux policy
[    5.317651] type=1404 audit(1309843877.294:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    5.403867] SELinux: 2048 avtab hash slots, 204971 rules.
[    5.561737] SELinux: 2048 avtab hash slots, 204971 rules.
[    6.378988] SELinux:  9 users, 14 roles, 3433 types, 179 bools, 1 sens, 1024 cats
[    6.379000] SELinux:  77 classes, 204971 rules
[    6.394308] SELinux:  Permission read_policy in class security not defined in policy.
[    6.394381] SELinux:  Permission audit_access in class file not defined in policy.
[    6.394399] SELinux:  Permission audit_access in class dir not defined in policy.
[    6.394406] SELinux:  Permission execmod in class dir not defined in policy.
[    6.394425] SELinux:  Permission audit_access in class lnk_file not defined in policy.
[    6.394431] SELinux:  Permission open in class lnk_file not defined in policy.
[    6.394437] SELinux:  Permission execmod in class lnk_file not defined in policy.
[    6.394452] SELinux:  Permission audit_access in class chr_file not defined in policy.
[    6.394467] SELinux:  Permission audit_access in class blk_file not defined in policy.
[    6.394474] SELinux:  Permission execmod in class blk_file not defined in policy.
[    6.394489] SELinux:  Permission audit_access in class sock_file not defined in policy.
[    6.394496] SELinux:  Permission execmod in class sock_file not defined in policy.
[    6.394510] SELinux:  Permission audit_access in class fifo_file not defined in policy.
[    6.394517] SELinux:  Permission execmod in class fifo_file not defined in policy.
[    6.394810] SELinux:  Permission syslog in class capability2 not defined in policy.
[    6.394829] SELinux: the above unknown classes and permissions will be allowed
[    6.394853] SELinux:  Completing initialization.
[    6.394857] SELinux:  Setting up existing superblocks.
[    6.394880] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    6.394898] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    6.395201] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    6.395219] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    6.395245] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    6.395294] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    6.398111] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    6.398132] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    6.400810] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    6.400832] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    6.400845] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    6.400925] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    6.400953] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    6.400988] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    6.401096] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[    6.401123] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    6.401138] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    6.402362] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    6.402421] SELinux: initialized (dev dm-0, type ext4), uses xattr
[    6.407965] type=1403 audit(1309843878.384:3): policy loaded auid=4294967295 ses=4294967295
[    7.351848] dracut: Switching root
[    8.075930] readahead: starting
[    9.619883] udev[321]: starting version 161
[   10.154237] CAN device driver interface
[   10.227219] pch_can 0000:02:0c.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   10.227362] pch_can 0000:02:0c.3: irq 41 for MSI/MSI-X
[   10.227386] pch_can 0000:02:0c.3: (unregistered net_device): PCH CAN opened with MSI
[   10.227403] pch_can 0000:02:0c.3: setting latency timer to 64
[   10.588370] udev[337]: renamed network interface eth0 to eth2
[   10.620374] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   10.929472] matroxfb 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   10.929489] matroxfb: Matrox G550 detected
[   11.000963] PInS memtype = 5
[   11.016258] matroxfb: MTRR's turned on
[   11.016299] matroxfb: 640x480x8bpp (virtual: 640x26214)
[   11.016310] matroxfb: framebuffer at 0xFA000000, mapped to 0xf8a00000, size 33554432
[   11.058809] fbcon: MATROX (fb0) is primary device
[   11.102374] Console: switching to colour frame buffer device 80x30
[   11.104499] fb0: MATROX frame buffer device
[   11.201276] microcode: CPU0 sig=0x20661, pf=0x2, revision=0x104
[   11.528520] microcode: CPU1 sig=0x20661, pf=0x2, revision=0x104
[   11.560553] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   12.027189] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   12.027213] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   12.027236] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   12.027327] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.173735] hda_codec: ALC888: BIOS auto-probing.
[   12.173748] hda_codec: ALC888: SKU not ready 0x00000100
[   12.173769] ALSA sound/pci/hda/hda_codec.c:4707 autoconfig: line_outs=4 (0x14/0x16/0x15/0x17/0x0) type:line
[   12.173825] ALSA sound/pci/hda/hda_codec.c:4711    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   12.173837] ALSA sound/pci/hda/hda_codec.c:4715    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[   12.173846] ALSA sound/pci/hda/hda_codec.c:4716    mono: mono_out=0x0
[   12.173856] ALSA sound/pci/hda/hda_codec.c:4719    dig-out=0x1e/0x0
[   12.173864] ALSA sound/pci/hda/hda_codec.c:4720    inputs:
[   12.173875] ALSA sound/pci/hda/hda_codec.c:4724  Rear Mic=0x18
[   12.173885] ALSA sound/pci/hda/hda_codec.c:4724  Front Mic=0x19
[   12.173895] ALSA sound/pci/hda/hda_codec.c:4724  Line=0x1a
[   12.173904] ALSA sound/pci/hda/hda_codec.c:4724  CD=0x1c
[   12.173912] ALSA sound/pci/hda/hda_codec.c:4726 
[   12.173920] ALSA sound/pci/hda/hda_codec.c:4728    dig-in=0x1f
[   12.175422] ALSA sound/pci/hda/patch_realtek.c:1805 realtek: No valid SSID, checking pincfg 0x00000100 for NID 0x1d
[   12.175436] ALSA sound/pci/hda/patch_realtek.c:1886 realtek: Enable default setup for auto mode as fallback
[   12.190062] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[   15.414139] EXT4-fs (dm-0): re-mounted. Opts: (null)
[   16.150223] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   16.150635] SELinux: initialized (dev sda1, type ext4), uses xattr
[   16.535751] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[   16.535782] SELinux: initialized (dev dm-2, type ext4), uses xattr
[   18.524669] Adding 5963772k swap on /dev/mapper/VolGroup-lv_swap.  Priority:-1 extents:1 across:5963772k 
[   18.534087] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   19.743358] NET: Registered protocol family 10
[   19.773430] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   20.112644] auditd (849): /proc/849/oom_adj is deprecated, please use /proc/849/oom_score_adj instead.
[   21.643832] pch_gbe 0000:02:00.1: irq 42 for MSI/MSI-X
[   21.646732] ADDRCONF(NETDEV_UP): eth2: link is not ready
[   21.647467] ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
[   27.555629] [drm] Initialized drm 1.1.0 20060810
[   27.569664] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   27.569675] [drm] No driver support for vblank timestamp query.
[   27.569687] [drm] Initialized mga 3.2.1 20051102 for 0000:06:00.0 on minor 0
[   27.573589] [drm:mga_do_agp_dma_bootstrap] *ERROR* Unable to acquire AGP: -19
[   27.601938] [drm] Initialized card for PCI DMA.
[   33.184263] fuse init (API version 7.16)
[   33.278902] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[   33.280273] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[   36.326899] hda-intel: Invalid position buffer, using LPIB read method instead.
[   36.326960] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
[  343.850222] IRQ handler type mismatch for IRQ 19
[  343.850232] current handler: pch-dma
[  343.850243] Pid: 2023, comm: gpioSystest Tainted: G        W   3.0.0-rc3+ #15
[  343.850249] Call Trace:
[  343.850267]  [<c0482fe3>] __setup_irq+0x2d0/0x30d
[  343.850281]  [<c05cdf03>] ? gpiochip_add+0x183/0x183
[  343.850291]  [<c04830d2>] request_threaded_irq+0xb2/0xd9
[  343.850302]  [<c0483157>] request_any_context_irq+0x5e/0x69
[  343.850312]  [<c05cdf03>] ? gpiochip_add+0x183/0x183
[  343.850322]  [<c05ce38d>] gpio_setup_irq.clone.5+0x150/0x194
[  343.850333]  [<c05ce92a>] gpio_edge_store+0x63/0x85
[  343.850344]  [<c0428f19>] ? should_resched+0xd/0x28
[  343.850353]  [<c05ce8c7>] ? gpio_active_low_store+0x74/0x74
[  343.850365]  [<c065eaa9>] dev_attr_store+0x20/0x28
[  343.850376]  [<c0523916>] sysfs_write_file+0xb3/0xec
[  343.850386]  [<c0523863>] ? sysfs_poll+0x73/0x73
[  343.850397]  [<c04dd8e9>] vfs_write+0x87/0xde
[  343.850407]  [<c04e4cd6>] ? path_put+0x1a/0x1d
[  343.850417]  [<c04ddabd>] sys_write+0x40/0x62
[  343.850428]  [<c07cdedf>] sysenter_do_call+0x12/0x28
[  344.852676] IRQ handler type mismatch for IRQ 19
[  344.852686] current handler: pch-dma
[  344.852695] Pid: 2023, comm: gpioSystest Tainted: G        W   3.0.0-rc3+ #15
[  344.852701] Call Trace:
[  344.852718]  [<c0482fe3>] __setup_irq+0x2d0/0x30d
[  344.852730]  [<c05cdf03>] ? gpiochip_add+0x183/0x183
[  344.852739]  [<c04830d2>] request_threaded_irq+0xb2/0xd9
[  344.852748]  [<c0483157>] request_any_context_irq+0x5e/0x69
[  344.852757]  [<c05cdf03>] ? gpiochip_add+0x183/0x183
[  344.852766]  [<c05ce38d>] gpio_setup_irq.clone.5+0x150/0x194
[  344.852775]  [<c05ce92a>] gpio_edge_store+0x63/0x85
[  344.852784]  [<c0428f19>] ? should_resched+0xd/0x28
[  344.852793]  [<c05ce8c7>] ? gpio_active_low_store+0x74/0x74
[  344.852803]  [<c065eaa9>] dev_attr_store+0x20/0x28
[  344.852813]  [<c0523916>] sysfs_write_file+0xb3/0xec
[  344.852821]  [<c0523863>] ? sysfs_poll+0x73/0x73
[  344.852831]  [<c04dd8e9>] vfs_write+0x87/0xde
[  344.852839]  [<c04e4cd6>] ? path_put+0x1a/0x1d
[  344.852848]  [<c04ddabd>] sys_write+0x40/0x62
[  344.852858]  [<c07cdedf>] sysenter_do_call+0x12/0x28

--------------060809070202000403020703
Content-Type: text/plain;
 name="interrupts"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="interrupts"

            CPU0       CPU1       
   0:      19451          0   IO-APIC-edge      timer
   1:          2          0   IO-APIC-edge      i8042
   4:          2          0   IO-APIC-edge    
   8:          1          0   IO-APIC-edge      rtc0
   9:          0          0   IO-APIC-fasteoi   acpi
  12:          4          0   IO-APIC-edge      i8042
  16:       2369          0   IO-APIC-fasteoi   pch_gpio, PCIe PME, PCIe PME, PCIe PME, PCIe PME, pciehp, pciehp, pciehp, pciehp, ehci_hcd:usb2, ohci_hcd:usb6, ohci_hcd:usb7, ohci_hcd:usb8, hda_intel
  18:          0          0   IO-APIC-fasteoi   pch-dma, spi_topcliff_pch, mmc0, mmc1
  19:        176          0   IO-APIC-fasteoi   pch-dma, ehci_hcd:usb1, ohci_hcd:usb3, ohci_hcd:usb4, ohci_hcd:usb5, mga@pci:0000:06:00.0
  40:      12576          0   PCI-MSI-edge      ahci
  42:        511          0   PCI-MSI-edge      eth2
 NMI:          0          0   Non-maskable interrupts
 LOC:      69534      65021   Local timer interrupts
 SPU:          0          0   Spurious interrupts
 PMI:          0          0   Performance monitoring interrupts
 IWI:          0          0   IRQ work interrupts
 RES:       7115      10455   Rescheduling interrupts
 CAL:        173        246   Function call interrupts
 TLB:        208        250   TLB shootdowns
 TRM:          0          0   Thermal event interrupts
 THR:          0          0   Threshold APIC interrupts
 MCE:          0          0   Machine check exceptions
 MCP:          2          2   Machine check polls
 ERR:          0
 MIS:          0

--------------060809070202000403020703
Content-Type: text/plain;
 name="pch_gpio.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pch_gpio.c"

/*
 * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
 */
#include <linux/kernel.h>
#include <linux/pci.h>
#include <linux/gpio.h>
#include <linux/interrupt.h>
#include <linux/irq.h>

#define PCH_GPIO_ALL_PINS	0xfff /* Mask for GPIO pins 0 to 11 */
#define GPIO_NUM_PINS	12	/* Specifies number of GPIO PINS GPIO0-GPIO11 */

#define PCH_EDGE_FALLING	0
#define PCH_EDGE_RISING		BIT(0)
#define PCH_LEVEL_L		BIT(1)
#define PCH_LEVEL_H		(BIT(0) | BIT(1))
#define PCH_EDGE_BOTH		BIT(2)
#define PCH_IM_MASK		(BIT(0) | BIT(1) | BIT(2))

#define PCH_IRQ_BASE		23

struct pch_regs {
	u32	ien;
	u32	istatus;
	u32	idisp;
	u32	iclr;
	u32	imask;
	u32	imaskclr;
	u32	po;
	u32	pi;
	u32	pm;
	u32	im0;
	u32	im1;
	u32	reserved[4];
	u32	reset;
};

/**
 * struct pch_gpio_reg_data - The register store data.
 * @po_reg:	To store contents of PO register.
 * @pm_reg:	To store contents of PM register.
 */
struct pch_gpio_reg_data {
	u32 po_reg;
	u32 pm_reg;
};

/**
 * struct pch_gpio - GPIO private data structure.
 * @base:			PCI base address of Memory mapped I/O register.
 * @reg:			Memory mapped PCH GPIO register list.
 * @dev:			Pointer to device structure.
 * @gpio:			Data for GPIO infrastructure.
 * @pch_gpio_reg:		Memory mapped Register data is saved here
 *				when suspend.
 * @lock:			Used for register access protection
 * @irq_base:		Save base of IRQ number for interrupt
 * @spinlock:		Used for register access protection in
 *				interrupt context pch_irq_mask,
 * 				pch_irq_unmask and pch_irq_type;
 */
struct pch_gpio {
	void __iomem *base;
	struct pch_regs __iomem *reg;
	struct device *dev;
	struct gpio_chip gpio;
	struct pch_gpio_reg_data pch_gpio_reg;
	struct mutex lock;
	int irq_base;
	spinlock_t spinlock;
};

static void pch_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
{
	u32 reg_val;
	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);

	mutex_lock(&chip->lock);
	reg_val = ioread32(&chip->reg->po);
	if (val)
		reg_val |= (1 << nr);
	else
		reg_val &= ~(1 << nr);

	iowrite32(reg_val, &chip->reg->po);
	mutex_unlock(&chip->lock);
}

static int pch_gpio_get(struct gpio_chip *gpio, unsigned nr)
{
	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);

	return ioread32(&chip->reg->pi) & (1 << nr);
}

static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
				     int val)
{
	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
	u32 pm;
	u32 reg_val;

	mutex_lock(&chip->lock);
	pm = ioread32(&chip->reg->pm) & PCH_GPIO_ALL_PINS;
	pm |= (1 << nr);
	iowrite32(pm, &chip->reg->pm);

	reg_val = ioread32(&chip->reg->po);
	if (val)
		reg_val |= (1 << nr);
	else
		reg_val &= ~(1 << nr);
	iowrite32(reg_val, &chip->reg->po);

	mutex_unlock(&chip->lock);

	return 0;
}

static int pch_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
{
	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
	u32 pm;

	mutex_lock(&chip->lock);
	pm = ioread32(&chip->reg->pm) & PCH_GPIO_ALL_PINS; /*bits 0-11*/
	pm &= ~(1 << nr);
	iowrite32(pm, &chip->reg->pm);
	mutex_unlock(&chip->lock);

	return 0;
}

/*
 * Save register configuration and disable interrupts.
 */
static void pch_gpio_save_reg_conf(struct pch_gpio *chip)
{
	chip->pch_gpio_reg.po_reg = ioread32(&chip->reg->po);
	chip->pch_gpio_reg.pm_reg = ioread32(&chip->reg->pm);
}

/*
 * This function restores the register configuration of the GPIO device.
 */
static void pch_gpio_restore_reg_conf(struct pch_gpio *chip)
{
	/* to store contents of PO register */
	iowrite32(chip->pch_gpio_reg.po_reg, &chip->reg->po);
	/* to store contents of PM register */
	iowrite32(chip->pch_gpio_reg.pm_reg, &chip->reg->pm);
}

static int pch_gpio_to_irq(struct gpio_chip *gpio, unsigned offset)
{
	struct pch_gpio *chip = container_of(gpio, struct pch_gpio, gpio);
	return chip->irq_base + offset;
}

static void pch_gpio_setup(struct pch_gpio *chip)
{
	struct gpio_chip *gpio = &chip->gpio;

	gpio->label = dev_name(chip->dev);
	gpio->owner = THIS_MODULE;
	gpio->direction_input = pch_gpio_direction_input;
	gpio->get = pch_gpio_get;
	gpio->direction_output = pch_gpio_direction_output;
	gpio->set = pch_gpio_set;
	gpio->dbg_show = NULL;
	gpio->base = -1;
	gpio->ngpio = GPIO_NUM_PINS;
	gpio->can_sleep = 0;
	gpio->to_irq = pch_gpio_to_irq;
}

static int pch_irq_type(struct irq_data *d, unsigned int type)
{
	u32 im;
	u32 *im_reg;
	u32 ien;
	u32 im_pos;
	int ch;
	unsigned long flags;
	u32 val;
	int irq = d->irq;
	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
	struct pch_gpio *chip = gc->private;

	ch = irq - chip->irq_base;
	if (irq <= chip->irq_base + 7) {
		im_reg = &chip->reg->im0;
		im_pos = ch;
	} else {
		im_reg = &chip->reg->im1;
		im_pos = ch - 8;
	}
	dev_dbg(chip->dev, "%s:irq=%d type=%d ch=%d pos=%d\n",
		__func__, irq, type, ch, im_pos);

	spin_lock_irqsave(&chip->spinlock, flags);

	switch (type) {
	case IRQ_TYPE_EDGE_RISING:
		val = PCH_EDGE_RISING;
		break;
	case IRQ_TYPE_EDGE_FALLING:
		val = PCH_EDGE_FALLING;
		break;
	case IRQ_TYPE_EDGE_BOTH:
		val = PCH_EDGE_BOTH;
		break;
	case IRQ_TYPE_LEVEL_HIGH:
		val = PCH_LEVEL_H;
		break;
	case IRQ_TYPE_LEVEL_LOW:
		val = PCH_LEVEL_L;
		break;
	case IRQ_TYPE_PROBE:
		goto end;
	default:
		dev_warn(chip->dev, "%s: unknown type(%dd)",
			__func__, type);
		goto end;
	}

	/* Set interrupt mode */
	im = ioread32(im_reg) & ~(PCH_IM_MASK << (im_pos * 4));
	iowrite32(im | (val << (im_pos * 4)), im_reg);

	/* iclr */
	iowrite32(BIT(ch), &chip->reg->iclr);

	/* IMASKCLR */
	iowrite32(BIT(ch), &chip->reg->imaskclr);

	/* Enable interrupt */
	ien = ioread32(&chip->reg->ien);
	iowrite32(ien | BIT(ch), &chip->reg->ien);
end:
	spin_unlock_irqrestore(&chip->spinlock, flags);

	return 0;
}

static void pch_irq_unmask(struct irq_data *d)
{
	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
	struct pch_gpio *chip = gc->private;

	iowrite32(1 << (d->irq - chip->irq_base), &chip->reg->imaskclr);
}

static void pch_irq_mask(struct irq_data *d)
{
	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
	struct pch_gpio *chip = gc->private;

	iowrite32(1 << (d->irq - chip->irq_base), &chip->reg->imask);
}

static irqreturn_t pch_gpio_handler(int irq, void *dev_id)
{
	struct pch_gpio *chip = dev_id;
	u32 reg_val = ioread32(&chip->reg->istatus);
	int i;
	int ret = IRQ_NONE;

	for (i = 0; i < GPIO_NUM_PINS; i++) {
		if (reg_val & BIT(i)) {
			dev_dbg(chip->dev, "%s:[%d]:irq=%d  status=0x%x\n",
				__func__, i, irq, reg_val);
			iowrite32(BIT(i), &chip->reg->iclr);
			generic_handle_irq(chip->irq_base + i);
			ret = IRQ_HANDLED;
		}
	}
	return ret;
}

static __devinit void pch_gpio_alloc_generic_chip(struct pch_gpio *chip,
				unsigned int irq_start, unsigned int num)
{
	struct irq_chip_generic *gc;
	struct irq_chip_type *ct;

	gc = irq_alloc_generic_chip("pch_gpio", 1, irq_start, chip->base,
				    handle_simple_irq);
	gc->private = chip;
	ct = gc->chip_types;

	ct->chip.irq_mask = pch_irq_mask;
	ct->chip.irq_unmask = pch_irq_unmask;
	ct->chip.irq_set_type = pch_irq_type;

	irq_setup_generic_chip(gc, IRQ_MSK(num), IRQ_GC_INIT_MASK_CACHE,
			       IRQ_NOREQUEST | IRQ_NOPROBE, 0);
}

static int __devinit pch_gpio_probe(struct pci_dev *pdev,
				    const struct pci_device_id *id)
{
	s32 ret;
	struct pch_gpio *chip;
	int irq_base;
printk("%s: 1\n", __func__);
	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
	if (chip == NULL)
		return -ENOMEM;

	chip->dev = &pdev->dev;
	ret = pci_enable_device(pdev);
	if (ret) {
		dev_err(&pdev->dev, "%s : pci_enable_device FAILED", __func__);
		goto err_pci_enable;
	}

printk("%s: 2\n", __func__);
	ret = pci_request_regions(pdev, KBUILD_MODNAME);
	if (ret) {
		dev_err(&pdev->dev, "pci_request_regions FAILED-%d", ret);
		goto err_request_regions;
	}

	chip->base = pci_iomap(pdev, 1, 0);
	if (chip->base == 0) {
		dev_err(&pdev->dev, "%s : pci_iomap FAILED", __func__);
		ret = -ENOMEM;
		goto err_iomap;
	}

printk("%s: 3\n", __func__);
	chip->reg = chip->base;
	pci_set_drvdata(pdev, chip);
	mutex_init(&chip->lock);
	pch_gpio_setup(chip);
	ret = gpiochip_add(&chip->gpio);
	if (ret) {
		dev_err(&pdev->dev, "PCH gpio: Failed to register GPIO\n");
		goto err_gpiochip_add;
	}

	//irq_base = irq_alloc_descs(-1, PCH_IRQ_BASE, GPIO_NUM_PINS, GFP_KERNEL);
	
printk("%s: 4\n", __func__);
	irq_base = irq_alloc_descs(-1, 0, GPIO_NUM_PINS, GFP_KERNEL);
	if (irq_base < 0) {
		dev_err(&pdev->dev, "PCH gpio: Failed to get IRQ base num\n");
		goto err_irq_alloc_descs;
	}
	printk("irq_base=%d\n", irq_base);
	chip->irq_base = irq_base;

	ret = request_irq(pdev->irq, pch_gpio_handler,
			     IRQF_SHARED, KBUILD_MODNAME, chip);
	if (ret != 0) {
		dev_err(&pdev->dev,
			"%s request_irq failed\n", __func__);
		goto err_request_irq;
	}

printk("%s: 5\n", __func__);
	pch_gpio_alloc_generic_chip(chip, irq_base, GPIO_NUM_PINS);

	/* Initialize interrupt ien register */
	iowrite32(0, &chip->reg->ien);

printk("%s: 6\n", __func__);
	return 0;

err_request_irq:
	irq_free_descs(irq_base, GPIO_NUM_PINS);

err_irq_alloc_descs:
	ret = gpiochip_remove(&chip->gpio);
	if (ret)
		dev_err(&pdev->dev, "%s gpiochip_remove failed\n", __func__);

err_gpiochip_add:
	pci_iounmap(pdev, chip->base);

err_iomap:
	pci_release_regions(pdev);

err_request_regions:
	pci_disable_device(pdev);

err_pci_enable:
	kfree(chip);
	dev_err(&pdev->dev, "%s Failed returns %d\n", __func__, ret);
	return ret;
}

static void __devexit pch_gpio_remove(struct pci_dev *pdev)
{
	int err;
	struct pch_gpio *chip = pci_get_drvdata(pdev);

	free_irq(pdev->irq, chip);

	irq_free_descs(chip->irq_base, GPIO_NUM_PINS);

	err = gpiochip_remove(&chip->gpio);
	if (err)
		dev_err(&pdev->dev, "Failed gpiochip_remove\n");

	pci_iounmap(pdev, chip->base);
	pci_release_regions(pdev);
	pci_disable_device(pdev);
	kfree(chip);
}

#ifdef CONFIG_PM
static int pch_gpio_suspend(struct pci_dev *pdev, pm_message_t state)
{
	s32 ret;
	struct pch_gpio *chip = pci_get_drvdata(pdev);

	pch_gpio_save_reg_conf(chip);
	pch_gpio_restore_reg_conf(chip);

	ret = pci_save_state(pdev);
	if (ret) {
		dev_err(&pdev->dev, "pci_save_state Failed-%d\n", ret);
		return ret;
	}
	pci_disable_device(pdev);
	pci_set_power_state(pdev, PCI_D0);
	ret = pci_enable_wake(pdev, PCI_D0, 1);
	if (ret)
		dev_err(&pdev->dev, "pci_enable_wake Failed -%d\n", ret);

	return 0;
}

static int pch_gpio_resume(struct pci_dev *pdev)
{
	s32 ret;
	struct pch_gpio *chip = pci_get_drvdata(pdev);

	ret = pci_enable_wake(pdev, PCI_D0, 0);

	pci_set_power_state(pdev, PCI_D0);
	ret = pci_enable_device(pdev);
	if (ret) {
		dev_err(&pdev->dev, "pci_enable_device Failed-%d ", ret);
		return ret;
	}
	pci_restore_state(pdev);

	iowrite32(0x01, &chip->reg->reset);
	iowrite32(0x00, &chip->reg->reset);
	pch_gpio_restore_reg_conf(chip);

	return 0;
}
#else
#define pch_gpio_suspend NULL
#define pch_gpio_resume NULL
#endif

#define PCI_VENDOR_ID_ROHM             0x10DB
static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8014) },
	{ 0, }
};
MODULE_DEVICE_TABLE(pci, pch_gpio_pcidev_id);

static struct pci_driver pch_gpio_driver = {
	.name = "pch_gpio",
	.id_table = pch_gpio_pcidev_id,
	.probe = pch_gpio_probe,
	.remove = __devexit_p(pch_gpio_remove),
	.suspend = pch_gpio_suspend,
	.resume = pch_gpio_resume
};

static int __init pch_gpio_pci_init(void)
{
	return pci_register_driver(&pch_gpio_driver);
}
module_init(pch_gpio_pci_init);

static void __exit pch_gpio_pci_exit(void)
{
	pci_unregister_driver(&pch_gpio_driver);
}
module_exit(pch_gpio_pci_exit);

MODULE_DESCRIPTION("PCH GPIO PCI Driver");
MODULE_LICENSE("GPL");

--------------060809070202000403020703--
