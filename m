Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178Ab0LTUo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 15:44:26 -0500
Received: from void.printf.net ([89.145.121.20]:40290 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933077Ab0LTUoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 15:44:22 -0500
From: Chris Ball <cjb@laptop.org>
To: x86@kernel.org
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        linux-kernel@vger.kernel.org
Subject: Microcode update taking >5 mins in next-20101220
Date: Mon, 20 Dec 2010 15:50:23 -0500
Message-ID: <m3hbe8dv8w.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Hi,

Sorry if this has already been reported -- between next-20101202 and
next-20101220, microcode updating on my Core i7 laptop has started to
take 60 seconds per core:

[   10.602245] microcode: CPU0 sig=0x106e5, pf=0x10, revision=0x3
[   10.609630] microcode: CPU1 sig=0x106e5, pf=0x10, revision=0x3
[   71.118766] microcode: CPU2 sig=0x106e5, pf=0x10, revision=0x3
[  131.989437] microcode: CPU3 sig=0x106e5, pf=0x10, revision=0x3
[  192.859936] microcode: CPU4 sig=0x106e5, pf=0x10, revision=0x3
[  253.986252] microcode: CPU5 sig=0x106e5, pf=0x10, revision=0x3
[  314.856982] microcode: CPU6 sig=0x106e5, pf=0x10, revision=0x3
[  375.727604] microcode: CPU7 sig=0x106e5, pf=0x10, revision=0x3
[  436.598180] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet. co.uk>, Peter Oruba

Full dmesg and .config attached.  Thanks,

--=-=-=
Content-Disposition: attachment; filename=microcode-dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-rc6-next-20101220 (cjb@octavius) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #5 SMP Mon Dec 20 12:04:35 PST 2010
[    0.000000] Command line: ro root=/dev/sda2 LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us selinux=0 nouveau.perflvl_wr=7777 nouveau.perflvl=0 nouveau.noaccel=1 loglevel=9 kgdboc=kms,kdb
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c3a7c000 (usable)
[    0.000000]  BIOS-e820: 00000000c3a7c000 - 00000000c3a82000 (reserved)
[    0.000000]  BIOS-e820: 00000000c3a82000 - 00000000c3b49000 (usable)
[    0.000000]  BIOS-e820: 00000000c3b49000 - 00000000c3b5c000 (reserved)
[    0.000000]  BIOS-e820: 00000000c3b5c000 - 00000000c3bdd000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c3bdd000 - 00000000c3c0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000c3c0f000 - 00000000c3c5d000 (usable)
[    0.000000]  BIOS-e820: 00000000c3c5d000 - 00000000c3e68000 (reserved)
[    0.000000]  BIOS-e820: 00000000c3e68000 - 00000000c3ee8000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c3ee8000 - 00000000c3f0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000c3f0f000 - 00000000c3f17000 (usable)
[    0.000000]  BIOS-e820: 00000000c3f17000 - 00000000c3f1f000 (reserved)
[    0.000000]  BIOS-e820: 00000000c3f1f000 - 00000000c3f6f000 (usable)
[    0.000000]  BIOS-e820: 00000000c3f6f000 - 00000000c3f7b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c3f7b000 - 00000000c3f7e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c3f7e000 - 00000000c3f8b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c3f8b000 - 00000000c3f8c000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c3f8c000 - 00000000c3f9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c3f9f000 - 00000000c3fff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c3fff000 - 00000000c4000000 (usable)
[    0.000000]  BIOS-e820: 00000000c4000000 - 00000000c6000000 (reserved)
[    0.000000]  BIOS-e820: 00000000c7800000 - 00000000c8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000feaff000 - 00000000feb00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000238000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: 4391BS6/4391BS6, BIOS 6NET54WW (1.17 ) 04/19/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x238000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C4000000 mask FFE000000 uncachable
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FF8000000 write-back
[    0.000000]   4 base 100000000 mask F00000000 write-back
[    0.000000]   5 base 200000000 mask FE0000000 write-back
[    0.000000]   6 base 220000000 mask FF0000000 write-back
[    0.000000]   7 base 230000000 mask FF8000000 write-back
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 3136MB, range: 32MB, type UC
[    0.000000] reg 1, base: 0GB, range: 2GB, type WB
[    0.000000] reg 2, base: 2GB, range: 1GB, type WB
[    0.000000] reg 3, base: 3GB, range: 128MB, type WB
[    0.000000] reg 4, base: 4GB, range: 4GB, type WB
[    0.000000] reg 5, base: 8GB, range: 512MB, type WB
[    0.000000] reg 6, base: 8704MB, range: 256MB, type WB
[    0.000000] reg 7, base: 8960MB, range: 128MB, type WB
[    0.000000] total RAM covered: 8160M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 64MB, type WB
[    0.000000] reg 3, base: 3168MB, range: 32MB, type WB
[    0.000000] reg 4, base: 4GB, range: 4GB, type WB
[    0.000000] reg 5, base: 8GB, range: 1GB, type WB
[    0.000000] reg 6, base: 9088MB, range: 128MB, type UC
[    0.000000] e820 update range: 00000000c4000000 - 00000000c6000000 (usable) ==> (reserved)
[    0.000000] e820 update range: 00000000c8000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xc4000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f68c0] f68c0
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000c4000000
[    0.000000]  0000000000 - 00c4000000 page 2M
[    0.000000] kernel direct mapping tables up to c4000000 @ 1fffb000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000238000000
[    0.000000]  0100000000 - 0238000000 page 2M
[    0.000000] kernel direct mapping tables up to 238000000 @ c3f65000-c3f6f000
[    0.000000] ACPI: RSDP 00000000000f6890 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000c3ff1af3 00094 (v01 LENOVO TP-6N    00001170  LTP 00000000)
[    0.000000] ACPI: FACP 00000000c3ff1c00 000F4 (v04 LENOVO TP-6N    00001170 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000c3ff1e9b 0CC73 (v01 LENOVO TP-6N    00001170 MSFT 03000001)
[    0.000000] ACPI: FACS 00000000c3ee7000 00040
[    0.000000] ACPI: SSDT 00000000c3ff1db4 000E7 (v01 LENOVO TP-6N    00001170 MSFT 03000001)
[    0.000000] ACPI: ECDT 00000000c3ffeb0e 00052 (v01 LENOVO TP-6N    00001170 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000c3ffeb60 000BC (v01 LENOVO TP-6N    00001170 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000c3ffec1c 0003C (v01 LENOVO TP-6N    00001170 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000c3ffec58 00038 (v01 LENOVO TP-6N    00001170 LNVO 00000001)
[    0.000000] ACPI: ASF! 00000000c3ffedbe 000A4 (v16 LENOVO TP-6N    00001170 PTL  00000001)
[    0.000000] ACPI: SLIC 00000000c3ffee62 00176 (v01 LENOVO TP-6N    00001170  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000c3ffefd8 00028 (v01 LENOVO TP-6N    00001170  LTP 00000001)
[    0.000000] ACPI: SSDT 00000000c3ee591a 0084B (v01 LENOVO TP-6N    00001170 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000c3f8b000 00032 (v02    PTL  CRESTLN 06040000      00005A52)
[    0.000000] ACPI: SSDT 00000000c3f7d000 009F1 (v01  PmRef    CpuPm 00003000 INTL 20050513)
[    0.000000] ACPI: SSDT 00000000c3f7c000 00259 (v01  PmRef  Cpu0Tst 00003000 INTL 20050513)
[    0.000000] ACPI: SSDT 00000000c3f7b000 0049F (v01  PmRef    ApTst 00003000 INTL 20050513)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000238000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000238000000
[    0.000000]   NODE_DATA [0000000237fec000 - 0000000237ffffff]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff88022fe00000-ffff880236ffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00238000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[8] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000c3a7c
[    0.000000]     0: 0x000c3a82 -> 0x000c3b49
[    0.000000]     0: 0x000c3c0f -> 0x000c3c5d
[    0.000000]     0: 0x000c3f0f -> 0x000c3f17
[    0.000000]     0: 0x000c3f1f -> 0x000c3f6f
[    0.000000]     0: 0x000c3fff -> 0x000c4000
[    0.000000]     0: 0x00100000 -> 0x00238000
[    0.000000] On node 0 totalpages: 2079608
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 783394 pages, LIFO batch:31
[    0.000000]   Normal zone: 17472 pages used for memmap
[    0.000000]   Normal zone: 1260480 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000c3a7c000 - 00000000c3a82000
[    0.000000] PM: Registered nosave memory: 00000000c3b49000 - 00000000c3b5c000
[    0.000000] PM: Registered nosave memory: 00000000c3b5c000 - 00000000c3bdd000
[    0.000000] PM: Registered nosave memory: 00000000c3bdd000 - 00000000c3c0f000
[    0.000000] PM: Registered nosave memory: 00000000c3c5d000 - 00000000c3e68000
[    0.000000] PM: Registered nosave memory: 00000000c3e68000 - 00000000c3ee8000
[    0.000000] PM: Registered nosave memory: 00000000c3ee8000 - 00000000c3f0f000
[    0.000000] PM: Registered nosave memory: 00000000c3f17000 - 00000000c3f1f000
[    0.000000] PM: Registered nosave memory: 00000000c3f6f000 - 00000000c3f7b000
[    0.000000] PM: Registered nosave memory: 00000000c3f7b000 - 00000000c3f7e000
[    0.000000] PM: Registered nosave memory: 00000000c3f7e000 - 00000000c3f8b000
[    0.000000] PM: Registered nosave memory: 00000000c3f8b000 - 00000000c3f8c000
[    0.000000] PM: Registered nosave memory: 00000000c3f8c000 - 00000000c3f9f000
[    0.000000] PM: Registered nosave memory: 00000000c3f9f000 - 00000000c3fff000
[    0.000000] PM: Registered nosave memory: 00000000c4000000 - 00000000c6000000
[    0.000000] PM: Registered nosave memory: 00000000c6000000 - 00000000c7800000
[    0.000000] PM: Registered nosave memory: 00000000c7800000 - 00000000c8000000
[    0.000000] PM: Registered nosave memory: 00000000c8000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000feaff000
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
[    0.000000] Allocating PCI resources starting at c8000000 (gap: c8000000:18000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff8800c3800000 s83200 r8192 d23296 u262144
[    0.000000] pcpu-alloc: s83200 r8192 d23296 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2047794
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: ro root=/dev/sda2 LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us selinux=0 nouveau.perflvl_wr=7777 nouveau.perflvl=0 nouveau.noaccel=1 loglevel=9 kgdboc=kms,kdb
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8120364k/9306112k available (4551k kernel code, 987680k absent, 198068k reserved, 6964k data, 936k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:16640 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 83886080 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 1596.175 MHz processor.
[    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 3192.35 BogoMIPS (lpj=1596175)
[    0.000869] pid_max: default: 32768 minimum: 301
[    0.001335] Security Framework initialized
[    0.001779] SELinux:  Disabled at boot.
[    0.003493] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.006985] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.008398] Mount-cache hash table entries: 256
[    0.008996] Initializing cgroup subsys ns
[    0.009423] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.010196] Initializing cgroup subsys cpuacct
[    0.010625] Initializing cgroup subsys memory
[    0.011085] Initializing cgroup subsys devices
[    0.011513] Initializing cgroup subsys freezer
[    0.011946] Initializing cgroup subsys net_cls
[    0.012377] Initializing cgroup subsys blkio
[    0.012856] CPU: Physical Processor ID: 0
[    0.013283] CPU: Processor Core ID: 0
[    0.013720] mce: CPU supports 9 MCE banks
[    0.014158] CPU0: Thermal monitoring enabled (TM1)
[    0.014587] using mwait in idle threads.
[    0.015510] ACPI: Core revision 20101013
[    0.037836] ftrace: allocating 24206 entries in 95 pages
[    0.048382] Setting APIC routing to flat
[    0.049229] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.059676] CPU0: Intel(R) Core(TM) i7 CPU       Q 720  @ 1.60GHz stepping 05
[    0.161510] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
[    0.162295] ... version:                3
[    0.162742] ... bit width:              48
[    0.163187] ... generic registers:      4
[    0.163634] ... value mask:             0000ffffffffffff
[    0.164081] ... max period:             000000007fffffff
[    0.164529] ... fixed-purpose events:   3
[    0.164974] ... event mask:             000000070000000f
[    0.167252] NMI watchdog enabled, takes one hw-pmu counter.
[    0.167824] Booting Node   0, Processors  #1
[    0.258555] NMI watchdog enabled, takes one hw-pmu counter.
[    0.259572]  #2
[    0.350476] NMI watchdog enabled, takes one hw-pmu counter.
[    0.351486]  #3
[    0.442293] NMI watchdog enabled, takes one hw-pmu counter.
[    0.443293]  #4
[    0.534197] NMI watchdog enabled, takes one hw-pmu counter.
[    0.535202]  #5
[    0.626112] NMI watchdog enabled, takes one hw-pmu counter.
[    0.627115]  #6
[    0.718028] NMI watchdog enabled, takes one hw-pmu counter.
[    0.719032]  #7 Ok.
[    0.809879] NMI watchdog enabled, takes one hw-pmu counter.
[    0.810367] Brought up 8 CPUs
[    0.810811] Total of 8 processors activated (25532.55 BogoMIPS).
[    0.816004] devtmpfs: initialized
[    0.824248] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.824718] Time: 20:23:26  Date: 12/20/10
[    0.825211] NET: Registered protocol family 16
[    0.825894] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.826674] ACPI: bus type pci registered
[    0.827229] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.828018] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.909524] PCI: Using configuration type 1 for base access
[    0.911552] bio: create slab <bio-0> at 0
[    0.914536] ACPI: EC: EC description table is found, configuring boot EC
[    0.923967] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.028196] ACPI: SSDT 00000000c3f1ac18 00377 (v01  PmRef  Cpu0Ist 00003000 INTL 20050513)
[    1.029787] ACPI: Dynamic OEM Table Load:
[    1.030455] ACPI: SSDT           (null) 00377 (v01  PmRef  Cpu0Ist 00003000 INTL 20050513)
[    1.031700] ACPI: SSDT 00000000c3f18718 006B2 (v01  PmRef  Cpu0Cst 00003001 INTL 20050513)
[    1.033329] ACPI: Dynamic OEM Table Load:
[    1.034002] ACPI: SSDT           (null) 006B2 (v01  PmRef  Cpu0Cst 00003001 INTL 20050513)
[    1.041088] ACPI: SSDT 00000000c3f19a98 00303 (v01  PmRef    ApIst 00003000 INTL 20050513)
[    1.042791] ACPI: Dynamic OEM Table Load:
[    1.043460] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20050513)
[    1.046829] ACPI: SSDT 00000000c3f17d98 00119 (v01  PmRef    ApCst 00003000 INTL 20050513)
[    1.048446] ACPI: Dynamic OEM Table Load:
[    1.049119] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20050513)
[    1.056312] ACPI: Interpreter enabled
[    1.056764] ACPI: (supports S0 S3 S4 S5)
[    1.057690] ACPI: Using IOAPIC for interrupt routing
[    1.070647] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[    1.071349] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[    1.074643] ACPI: Power Resource [PUBS] (on)
[    1.080664] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[    1.093710] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    1.098336] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    1.098794] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.099594] ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
[    1.100116] pci 0000:ff:00.0: [8086:2c52] type 0 class 0x000600
[    1.100596] pci 0000:ff:00.1: [8086:2c81] type 0 class 0x000600
[    1.101078] pci 0000:ff:02.0: [8086:2c90] type 0 class 0x000600
[    1.101549] pci 0000:ff:02.1: [8086:2c91] type 0 class 0x000600
[    1.102025] pci 0000:ff:03.0: [8086:2c98] type 0 class 0x000600
[    1.102496] pci 0000:ff:03.1: [8086:2c99] type 0 class 0x000600
[    1.102974] pci 0000:ff:03.4: [8086:2c9c] type 0 class 0x000600
[    1.103446] pci 0000:ff:04.0: [8086:2ca0] type 0 class 0x000600
[    1.103922] pci 0000:ff:04.1: [8086:2ca1] type 0 class 0x000600
[    1.104393] pci 0000:ff:04.2: [8086:2ca2] type 0 class 0x000600
[    1.104869] pci 0000:ff:04.3: [8086:2ca3] type 0 class 0x000600
[    1.105341] pci 0000:ff:05.0: [8086:2ca8] type 0 class 0x000600
[    1.105818] pci 0000:ff:05.1: [8086:2ca9] type 0 class 0x000600
[    1.106284] pci 0000:ff:05.2: [8086:2caa] type 0 class 0x000600
[    1.106761] pci 0000:ff:05.3: [8086:2cab] type 0 class 0x000600
[    1.108230] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    1.108773] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.109225] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.109681] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.119662] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    1.120442] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    1.121227] pci_root PNP0A08:00: host bridge window [mem 0xc8000000-0xfebfffff]
[    1.122025] pci 0000:00:00.0: [8086:d132] type 0 class 0x000600
[    1.122533] pci 0000:00:03.0: [8086:d138] type 1 class 0x000604
[    1.123040] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.123494] pci 0000:00:03.0: PME# disabled
[    1.123978] pci 0000:00:08.0: [8086:d155] type 0 class 0x000880
[    1.124489] pci 0000:00:08.1: [8086:d156] type 0 class 0x000880
[    1.125005] pci 0000:00:08.2: [8086:d157] type 0 class 0x000880
[    1.125512] pci 0000:00:08.3: [8086:d158] type 0 class 0x000880
[    1.126035] pci 0000:00:10.0: [8086:d150] type 0 class 0x000880
[    1.126534] pci 0000:00:10.1: [8086:d151] type 0 class 0x000880
[    1.127068] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
[    1.127545] pci 0000:00:16.0: reg 10: [mem 0xf2627800-0xf262780f 64bit]
[    1.128066] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.128519] pci 0000:00:16.0: PME# disabled
[    1.129007] pci 0000:00:16.3: [8086:3b67] type 0 class 0x000700
[    1.129476] pci 0000:00:16.3: reg 10: [io  0x1800-0x1807]
[    1.129943] pci 0000:00:16.3: reg 14: [mem 0xf2624000-0xf2624fff]
[    1.130494] pci 0000:00:19.0: [8086:10ea] type 0 class 0x000200
[    1.130976] pci 0000:00:19.0: reg 10: [mem 0xf2600000-0xf261ffff]
[    1.131436] pci 0000:00:19.0: reg 14: [mem 0xf2625000-0xf2625fff]
[    1.131903] pci 0000:00:19.0: reg 18: [io  0x1820-0x183f]
[    1.132408] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.132870] pci 0000:00:19.0: PME# disabled
[    1.133355] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    1.133840] pci 0000:00:1a.0: reg 10: [mem 0xf2628000-0xf26283ff]
[    1.134373] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.134835] pci 0000:00:1a.0: PME# disabled
[    1.135323] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    1.135802] pci 0000:00:1b.0: reg 10: [mem 0xf2620000-0xf2623fff 64bit]
[    1.136316] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.136777] pci 0000:00:1b.0: PME# disabled
[    1.137256] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    1.137788] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.138241] pci 0000:00:1c.0: PME# disabled
[    1.138741] pci 0000:00:1c.1: [8086:3b44] type 1 class 0x000604
[    1.139265] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.139728] pci 0000:00:1c.1: PME# disabled
[    1.140214] pci 0000:00:1c.3: [8086:3b48] type 1 class 0x000604
[    1.140749] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.141200] pci 0000:00:1c.3: PME# disabled
[    1.141690] pci 0000:00:1c.4: [8086:3b4a] type 1 class 0x000604
[    1.142211] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.142672] pci 0000:00:1c.4: PME# disabled
[    1.143162] pci 0000:00:1c.6: [8086:3b4e] type 1 class 0x000604
[    1.143696] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    1.144148] pci 0000:00:1c.6: PME# disabled
[    1.144639] pci 0000:00:1c.7: [8086:3b50] type 1 class 0x000604
[    1.145164] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    1.145623] pci 0000:00:1c.7: PME# disabled
[    1.146114] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    1.146597] pci 0000:00:1d.0: reg 10: [mem 0xf2628400-0xf26287ff]
[    1.147128] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.147587] pci 0000:00:1d.0: PME# disabled
[    1.148074] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    1.148607] pci 0000:00:1f.0: [8086:3b07] type 0 class 0x000601
[    1.149200] pci 0000:00:1f.2: [8086:3b2f] type 0 class 0x000106
[    1.149676] pci 0000:00:1f.2: reg 10: [io  0x1818-0x181f]
[    1.150134] pci 0000:00:1f.2: reg 14: [io  0x180c-0x180f]
[    1.150596] pci 0000:00:1f.2: reg 18: [io  0x1810-0x1817]
[    1.151054] pci 0000:00:1f.2: reg 1c: [io  0x1808-0x180b]
[    1.151510] pci 0000:00:1f.2: reg 20: [io  0x1840-0x185f]
[    1.151974] pci 0000:00:1f.2: reg 24: [mem 0xf2627000-0xf26277ff]
[    1.152465] pci 0000:00:1f.2: PME# supported from D3hot
[    1.152924] pci 0000:00:1f.2: PME# disabled
[    1.153400] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    1.153879] pci 0000:00:1f.3: reg 10: [mem 0xf2628800-0xf26288ff 64bit]
[    1.154350] pci 0000:00:1f.3: reg 20: [io  0x1860-0x187f]
[    1.154874] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
[    1.155353] pci 0000:00:1f.6: reg 10: [mem 0xf2626000-0xf2626fff 64bit]
[    1.155949] pci 0000:01:00.0: [10de:0a3c] type 0 class 0x000300
[    1.156411] pci 0000:01:00.0: reg 10: [mem 0xcc000000-0xccffffff]
[    1.156880] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.157345] pci 0000:01:00.0: reg 1c: [mem 0xce000000-0xcfffffff 64bit pref]
[    1.157808] pci 0000:01:00.0: reg 24: [io  0x2000-0x207f]
[    1.158265] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    1.158789] pci 0000:01:00.1: [10de:0be2] type 0 class 0x000403
[    1.159249] pci 0000:01:00.1: reg 10: [mem 0xcdefc000-0xcdefffff]
[    1.159817] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    1.160177] pci 0000:00:03.0:   bridge window [io  0x2000-0x2fff]
[    1.160540] pci 0000:00:03.0:   bridge window [mem 0xcc000000-0xcdefffff]
[    1.160905] pci 0000:00:03.0:   bridge window [mem 0xce000000-0xdfffffff 64bit pref]
[    1.161573] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.161933] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.162293] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.162911] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.163839] pci 0000:03:00.0: [8086:4238] type 0 class 0x000280
[    1.164568] pci 0000:03:00.0: reg 10: [mem 0xf2000000-0xf2001fff 64bit]
[    1.166298] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.166715] pci 0000:03:00.0: PME# disabled
[    1.167463] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.167831] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    1.168195] pci 0000:00:1c.1:   bridge window [mem 0xf2000000-0xf20fffff]
[    1.168566] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.169225] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    1.169593] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    1.169953] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    1.170316] pci 0000:00:1c.3:   bridge window [mem 0xf2700000-0xf27fffff 64bit pref]
[    1.171053] pci 0000:0d:00.0: [1180:e822] type 0 class 0x000805
[    1.171484] pci 0000:0d:00.0: reg 10: [mem 0xf2100000-0xf21000ff]
[    1.172015] pci 0000:0d:00.0: supports D1 D2
[    1.172369] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.172792] pci 0000:0d:00.0: PME# disabled
[    1.173244] pci 0000:0d:00.1: [1180:e230] type 0 class 0x000880
[    1.173682] pci 0000:0d:00.1: reg 10: [mem 0xf2100400-0xf21004ff]
[    1.174207] pci 0000:0d:00.1: supports D1 D2
[    1.174567] pci 0000:0d:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.174982] pci 0000:0d:00.1: PME# disabled
[    1.175438] pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
[    1.175805] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disabled)
[    1.176168] pci 0000:00:1c.4:   bridge window [mem 0xf2100000-0xf21fffff]
[    1.176538] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.177225] pci 0000:0f:00.0: [1033:0194] type 0 class 0x000c03
[    1.177640] pci 0000:0f:00.0: reg 10: [mem 0xf2200000-0xf2201fff 64bit]
[    1.178132] pci 0000:0f:00.0: PME# supported from D0 D3hot D3cold
[    1.178495] pci 0000:0f:00.0: PME# disabled
[    1.178907] pci 0000:00:1c.6: PCI bridge to [bus 0f-16]
[    1.179265] pci 0000:00:1c.6:   bridge window [io  0xf000-0x0000] (disabled)
[    1.179636] pci 0000:00:1c.6:   bridge window [mem 0xf2200000-0xf22fffff]
[    1.179999] pci 0000:00:1c.6:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.180739] pci 0000:17:00.0: [1180:e822] type 0 class 0x000805
[    1.181167] pci 0000:17:00.0: reg 10: [mem 0xf2300000-0xf23000ff]
[    1.181694] pci 0000:17:00.0: supports D1 D2
[    1.182052] pci 0000:17:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.182465] pci 0000:17:00.0: PME# disabled
[    1.182930] pci 0000:17:00.3: [1180:e832] type 0 class 0x000c00
[    1.183355] pci 0000:17:00.3: reg 10: [mem 0xf2300800-0xf2300fff]
[    1.183886] pci 0000:17:00.3: supports D1 D2
[    1.184242] pci 0000:17:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    1.184660] pci 0000:17:00.3: PME# disabled
[    1.185109] pci 0000:00:1c.7: PCI bridge to [bus 17-1e]
[    1.185466] pci 0000:00:1c.7:   bridge window [io  0xf000-0x0000] (disabled)
[    1.185834] pci 0000:00:1c.7:   bridge window [mem 0xf2300000-0xf23fffff]
[    1.186201] pci 0000:00:1c.7:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.186896] pci 0000:00:1e.0: PCI bridge to [bus 1f-1f] (subtractive decode)
[    1.187258] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.187630] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.188241] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.188850] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.189461] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.190071] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.190682] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    1.191288] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    1.191897] pci 0000:00:1e.0:   bridge window [mem 0xc8000000-0xfebfffff] (subtractive decode)
[    1.192551] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.193100] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG_._PRT]
[    1.193512] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    1.193928] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    1.194335] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    1.194751] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    1.195154] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP7._PRT]
[    1.195567] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP8._PRT]
[    1.204229] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    1.205734] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    1.207234] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    1.208738] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    1.210239] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    1.211742] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    1.219044] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    1.220570] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    1.222015] HEST: Table is not found!
[    1.222503] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.223116] vgaarb: loaded
[    1.223568] SCSI subsystem initialized
[    1.223978] libata version 3.00 loaded.
[    1.224398] usbcore: registered new interface driver usbfs
[    1.224779] usbcore: registered new interface driver hub
[    1.225170] usbcore: registered new device driver usb
[    1.225624] PCI: Using ACPI for IRQ routing
[    1.225983] PCI: pci_cache_line_size set to 64 bytes
[    1.226681] reserve RAM buffer: 000000000009e800 - 000000000009ffff 
[    1.226798] reserve RAM buffer: 00000000c3a7c000 - 00000000c3ffffff 
[    1.227264] reserve RAM buffer: 00000000c3b49000 - 00000000c3ffffff 
[    1.227735] reserve RAM buffer: 00000000c3c5d000 - 00000000c3ffffff 
[    1.228201] reserve RAM buffer: 00000000c3f17000 - 00000000c3ffffff 
[    1.228669] reserve RAM buffer: 00000000c3f6f000 - 00000000c3ffffff 
[    1.229253] NetLabel: Initializing
[    1.229955] NetLabel:  domain hash size = 128
[    1.230307] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.230681] NetLabel:  unlabeled traffic allowed by default
[    1.231121] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
[    1.231499] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 40, 41, 42, 43, 44, 0
[    1.232791] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.235503] hpet: hpet2 irq 40 for MSI
[    1.236661] hpet: hpet3 irq 41 for MSI
[    1.237703] hpet: hpet4 irq 42 for MSI
[    1.238645] hpet: hpet5 irq 43 for MSI
[    1.239669] hpet: hpet6 irq 44 for MSI
[    1.242706] Switching to clocksource hpet
[    1.251567] pnp: PnP ACPI init
[    1.251944] ACPI: bus type pnp registered
[    1.253936] pnp 01:00: [mem 0x00000000-0x0009ffff]
[    1.254311] pnp 01:00: [mem 0x000c0000-0x000c3fff]
[    1.254668] pnp 01:00: [mem 0x000c4000-0x000c7fff]
[    1.255022] pnp 01:00: [mem 0x000c8000-0x000cbfff]
[    1.255394] pnp 01:00: [mem 0x000cc000-0x000cffff]
[    1.255750] pnp 01:00: [mem 0x000d0000-0x000d3fff]
[    1.256110] pnp 01:00: [mem 0x000d4000-0x000d3fff disabled]
[    1.256480] pnp 01:00: [mem 0x000d8000-0x000d7fff disabled]
[    1.256842] pnp 01:00: [mem 0x000dc000-0x000dffff]
[    1.257199] pnp 01:00: [mem 0x000e0000-0x000e3fff]
[    1.257573] pnp 01:00: [mem 0x000e4000-0x000e7fff]
[    1.257927] pnp 01:00: [mem 0x000e8000-0x000ebfff]
[    1.258299] pnp 01:00: [mem 0x000ec000-0x000effff]
[    1.258654] pnp 01:00: [mem 0x000f0000-0x000fffff]
[    1.259012] pnp 01:00: [mem 0x00100000-0xc7ffffff]
[    1.259382] pnp 01:00: [mem 0xfec00000-0xfed3ffff]
[    1.259738] pnp 01:00: [mem 0xfed4c000-0xffffffff]
[    1.260207] system 01:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.260587] system 01:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    1.260943] system 01:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    1.261319] system 01:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    1.261680] system 01:00: [mem 0x000cc000-0x000cffff] has been reserved
[    1.262042] system 01:00: [mem 0x000d0000-0x000d3fff] could not be reserved
[    1.262417] system 01:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    1.262782] system 01:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    1.263143] system 01:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    1.263520] system 01:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    1.263879] system 01:00: [mem 0x000ec000-0x000effff] could not be reserved
[    1.264255] system 01:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    1.264619] system 01:00: [mem 0x00100000-0xc7ffffff] could not be reserved
[    1.264981] system 01:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    1.265358] system 01:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    1.265722] system 01:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.266097] pnp 01:01: [bus ff]
[    1.266529] pnp 01:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.266910] pnp 01:02: [bus 00-fe]
[    1.267282] pnp 01:02: [io  0x0cf8-0x0cff]
[    1.267639] pnp 01:02: [io  0x0000-0x0cf7 window]
[    1.267996] pnp 01:02: [io  0x0d00-0xffff window]
[    1.268368] pnp 01:02: [mem 0x000a0000-0x000bffff window]
[    1.268724] pnp 01:02: [mem 0x000c0000-0x000c3fff window]
[    1.269083] pnp 01:02: [mem 0x000c4000-0x000c7fff window]
[    1.269455] pnp 01:02: [mem 0x000c8000-0x000cbfff window]
[    1.269812] pnp 01:02: [mem 0x000cc000-0x000cffff window]
[    1.270167] pnp 01:02: [mem 0x000d0000-0x000d3fff window]
[    1.270540] pnp 01:02: [mem 0x000d4000-0x000d7fff window]
[    1.270898] pnp 01:02: [mem 0x000d8000-0x000dbfff window]
[    1.271274] pnp 01:02: [mem 0x000dc000-0x000dffff window]
[    1.271631] pnp 01:02: [mem 0x000e0000-0x000e3fff window]
[    1.271988] pnp 01:02: [mem 0x000e4000-0x000e7fff window]
[    1.272361] pnp 01:02: [mem 0x000e8000-0x000ebfff window]
[    1.272719] pnp 01:02: [mem 0x000ec000-0x000effff window]
[    1.273076] pnp 01:02: [mem 0xc8000000-0xfebfffff window]
[    1.273449] pnp 01:02: [mem 0xfed40000-0xfed4bfff window]
[    1.273861] pnp 01:02: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.274809] pnp 01:03: [io  0x0010-0x001f]
[    1.275166] pnp 01:03: [io  0x0090-0x009f]
[    1.275540] pnp 01:03: [io  0x0024-0x0025]
[    1.275892] pnp 01:03: [io  0x0028-0x0029]
[    1.276261] pnp 01:03: [io  0x002c-0x002d]
[    1.276615] pnp 01:03: [io  0x0030-0x0031]
[    1.276971] pnp 01:03: [io  0x0034-0x0035]
[    1.277343] pnp 01:03: [io  0x0038-0x0039]
[    1.277697] pnp 01:03: [io  0x003c-0x003d]
[    1.278051] pnp 01:03: [io  0x00a4-0x00a5]
[    1.278422] pnp 01:03: [io  0x00a8-0x00a9]
[    1.278777] pnp 01:03: [io  0x00ac-0x00ad]
[    1.279133] pnp 01:03: [io  0x00b0-0x00b5]
[    1.279506] pnp 01:03: [io  0x00b8-0x00b9]
[    1.279860] pnp 01:03: [io  0x00bc-0x00bd]
[    1.280233] pnp 01:03: [io  0x0050-0x0053]
[    1.280586] pnp 01:03: [io  0x0072-0x0077]
[    1.280942] pnp 01:03: [io  0x164e-0x164f]
[    1.281312] pnp 01:03: [io  0x002e-0x002f]
[    1.281669] pnp 01:03: [io  0x1000-0x107f]
[    1.282024] pnp 01:03: [io  0x1180-0x11ff]
[    1.282393] pnp 01:03: [io  0x0800-0x080f]
[    1.282748] pnp 01:03: [io  0x15e0-0x15ef]
[    1.283102] pnp 01:03: [io  0x1600-0x1641]
[    1.283473] pnp 01:03: [io  0x1644-0x167f]
[    1.283829] pnp 01:03: [mem 0xe0000000-0xefffffff]
[    1.284186] pnp 01:03: [mem 0x00000000-0x00000fff]
[    1.284557] pnp 01:03: [mem 0x00000000-0x00000fff]
[    1.284913] pnp 01:03: [mem 0xfed1c000-0xfed1ffff]
[    1.285287] pnp 01:03: [mem 0xfed10000-0xfed13fff]
[    1.285641] pnp 01:03: [mem 0xfed18000-0xfed18fff]
[    1.285997] pnp 01:03: [mem 0xfed19000-0xfed19fff]
[    1.286368] pnp 01:03: [mem 0xfed45000-0xfed4bfff]
[    1.286793] pnp 01:03: disabling [mem 0x00000000-0x00000fff] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x0007ffff pref]
[    1.287424] pnp 01:03: disabling [mem 0x00000000-0x00000fff] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x0007ffff pref]
[    1.288096] system 01:03: [io  0x164e-0x164f] has been reserved
[    1.288474] system 01:03: [io  0x1000-0x107f] has been reserved
[    1.288832] system 01:03: [io  0x1180-0x11ff] has been reserved
[    1.289210] system 01:03: [io  0x0800-0x080f] has been reserved
[    1.289569] system 01:03: [io  0x15e0-0x15ef] has been reserved
[    1.289931] system 01:03: [io  0x1600-0x1641] has been reserved
[    1.290304] system 01:03: [io  0x1644-0x167f] could not be reserved
[    1.290665] system 01:03: [mem 0xe0000000-0xefffffff] has been reserved
[    1.291026] system 01:03: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.291404] system 01:03: [mem 0xfed10000-0xfed13fff] has been reserved
[    1.291764] system 01:03: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.292126] system 01:03: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.292501] system 01:03: [mem 0xfed45000-0xfed4bfff] has been reserved
[    1.292863] system 01:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.293281] pnp 01:04: [mem 0xfed00000-0xfed003ff]
[    1.293676] pnp 01:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.294047] pnp 01:05: [io  0x0000-0x000f]
[    1.294420] pnp 01:05: [io  0x0080-0x008f]
[    1.294774] pnp 01:05: [io  0x00c0-0x00df]
[    1.295130] pnp 01:05: [dma 4]
[    1.295535] pnp 01:05: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.295905] pnp 01:06: [io  0x0061]
[    1.296316] pnp 01:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.296684] pnp 01:07: [io  0x00f0]
[    1.297049] pnp 01:07: [irq 13]
[    1.297461] pnp 01:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.297831] pnp 01:08: [io  0x0070-0x0071]
[    1.298211] pnp 01:08: [irq 8]
[    1.298603] pnp 01:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.298973] pnp 01:09: [io  0x0060]
[    1.299345] pnp 01:09: [io  0x0064]
[    1.299709] pnp 01:09: [irq 1]
[    1.300101] pnp 01:09: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.300494] pnp 01:0a: [irq 12]
[    1.300887] pnp 01:0a: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
[    1.301885] pnp 01:0b: [mem 0xfed40000-0xfed44fff]
[    1.302307] pnp 01:0b: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    1.306484] pnp: PnP ACPI: found 12 devices
[    1.306841] ACPI: ACPI bus type pnp unregistered
[    1.314406] pci 0000:01:00.0: BAR 6: assigned [mem 0xcd000000-0xcd07ffff pref]
[    1.315008] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    1.315385] pci 0000:00:03.0:   bridge window [io  0x2000-0x2fff]
[    1.315744] pci 0000:00:03.0:   bridge window [mem 0xcc000000-0xcdefffff]
[    1.316107] pci 0000:00:03.0:   bridge window [mem 0xce000000-0xdfffffff 64bit pref]
[    1.316727] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.317082] pci 0000:00:1c.0:   bridge window [io  disabled]
[    1.317460] pci 0000:00:1c.0:   bridge window [mem disabled]
[    1.317820] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    1.318202] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.324402] pci 0000:00:1c.1:   bridge window [io  disabled]
[    1.324762] pci 0000:00:1c.1:   bridge window [mem 0xf2000000-0xf20fffff]
[    1.325123] pci 0000:00:1c.1:   bridge window [mem pref disabled]
[    1.325505] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    1.325866] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    1.326245] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    1.326608] pci 0000:00:1c.3:   bridge window [mem 0xf2700000-0xf27fffff 64bit pref]
[    1.327235] pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
[    1.327591] pci 0000:00:1c.4:   bridge window [io  disabled]
[    1.327955] pci 0000:00:1c.4:   bridge window [mem 0xf2100000-0xf21fffff]
[    1.328335] pci 0000:00:1c.4:   bridge window [mem pref disabled]
[    1.328698] pci 0000:00:1c.6: PCI bridge to [bus 0f-16]
[    1.329052] pci 0000:00:1c.6:   bridge window [io  disabled]
[    1.329434] pci 0000:00:1c.6:   bridge window [mem 0xf2200000-0xf22fffff]
[    1.329793] pci 0000:00:1c.6:   bridge window [mem pref disabled]
[    1.330176] pci 0000:00:1c.7: PCI bridge to [bus 17-1e]
[    1.330530] pci 0000:00:1c.7:   bridge window [io  disabled]
[    1.330892] pci 0000:00:1c.7:   bridge window [mem 0xf2300000-0xf23fffff]
[    1.331273] pci 0000:00:1c.7:   bridge window [mem pref disabled]
[    1.331638] pci 0000:00:1e.0: PCI bridge to [bus 1f-1f]
[    1.331994] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.332370] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.332725] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.333099] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.333479] pci 0000:00:03.0: setting latency timer to 64
[    1.333853] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.334236] pci 0000:00:1c.0: setting latency timer to 64
[    1.334609] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.334974] pci 0000:00:1c.1: setting latency timer to 64
[    1.335365] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.335733] pci 0000:00:1c.3: setting latency timer to 64
[    1.336098] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.336482] pci 0000:00:1c.4: setting latency timer to 64
[    1.336851] pci 0000:00:1c.6: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    1.337233] pci 0000:00:1c.6: setting latency timer to 64
[    1.337599] pci 0000:00:1c.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.337962] pci 0000:00:1c.7: setting latency timer to 64
[    1.338348] pci 0000:00:1e.0: setting latency timer to 64
[    1.338705] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.339064] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.339441] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.339802] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.340177] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.340536] pci_bus 0000:00: resource 9 [mem 0xc8000000-0xfebfffff]
[    1.340893] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    1.341265] pci_bus 0000:01: resource 1 [mem 0xcc000000-0xcdefffff]
[    1.341624] pci_bus 0000:01: resource 2 [mem 0xce000000-0xdfffffff 64bit pref]
[    1.342246] pci_bus 0000:03: resource 1 [mem 0xf2000000-0xf20fffff]
[    1.342606] pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
[    1.342963] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    1.343339] pci_bus 0000:05: resource 2 [mem 0xf2700000-0xf27fffff 64bit pref]
[    1.343943] pci_bus 0000:0d: resource 1 [mem 0xf2100000-0xf21fffff]
[    1.344317] pci_bus 0000:0f: resource 1 [mem 0xf2200000-0xf22fffff]
[    1.344678] pci_bus 0000:17: resource 1 [mem 0xf2300000-0xf23fffff]
[    1.345036] pci_bus 0000:1f: resource 4 [io  0x0000-0x0cf7]
[    1.345411] pci_bus 0000:1f: resource 5 [io  0x0d00-0xffff]
[    1.345764] pci_bus 0000:1f: resource 6 [mem 0x000a0000-0x000bffff]
[    1.346123] pci_bus 0000:1f: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.346493] pci_bus 0000:1f: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.346852] pci_bus 0000:1f: resource 9 [mem 0xc8000000-0xfebfffff]
[    1.347250] NET: Registered protocol family 2
[    1.347927] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.350034] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.354321] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.355108] TCP: Hash tables configured (established 524288 bind 65536)
[    1.355488] TCP reno registered
[    1.355862] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    1.356333] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    1.356875] NET: Registered protocol family 1
[    1.357532] pci 0000:01:00.0: Boot video device
[    1.358004] PCI: CLS 64 bytes, default 64
[    1.358431] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.358791] Placing 64MB software IO TLB between ffff8800bf800000 - ffff8800c3800000
[    1.359412] software IO TLB at phys 0xbf800000 - 0xc3800000
[    1.359809] Simple Boot Flag at 0x35 set to 0x1
[    1.361648] audit: initializing netlink socket (disabled)
[    1.362012] type=2000 audit(1292876606.056:1): initialized
[    1.379486] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.382499] VFS: Disk quotas dquot_6.5.2
[    1.382914] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.384010] msgmni has been set to 15860
[    1.384815] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.385443] io scheduler noop registered
[    1.385797] io scheduler deadline registered
[    1.386217] io scheduler cfq registered (default)
[    1.386574] list_sort_test: start testing list_sort()
[    1.389731] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.390141] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.390501] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.391137] acpiphp: Slot [1] registered
[    1.391661] intel_idle: MWAIT substates: 0x1120
[    1.392017] intel_idle: v0.4 model 0x1E
[    1.392389] intel_idle: lapic_timer_reliable_states 0x2
[    1.400166] ACPI: AC Adapter [AC] (on-line)
[    1.400642] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    1.406171] ACPI: Lid Switch [LID]
[    1.406603] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    1.407242] ACPI: Sleep Button [SLPB]
[    1.407668] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.408307] ACPI: Power Button [PWRF]
[    1.408861] ACPI: acpi_idle yielding to intel_idle
[    1.433176] thermal LNXTHERM:00: registered as thermal_zone0
[    1.433531] ACPI: Thermal Zone [THM0] (49 C)
[    1.433900] ERST: Table is not found!
[    1.434545] Non-volatile memory driver v1.3
[    1.434902] Linux agpgart interface v0.103
[    1.435489] tpm_tis 01:0b: 1.2 TPM (device-id 0x0, rev-id 78)
[    1.465115] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.527203] serial 0000:00:16.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.547895] 0000:00:16.3: ttyS0 at I/O 0x1800 (irq = 17) is a 16550A
[    1.564664] brd: module loaded
[    1.565843] loop: module loaded
[    1.566302] ahci 0000:00:1f.2: version 3.0
[    1.566673] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.567091] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    1.567522] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
[    1.568146] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ems sxs apst 
[    1.568759] ahci 0000:00:1f.2: setting latency timer to 64
[    1.575870] scsi0 : ahci
[    1.576371] scsi1 : ahci
[    1.576832] scsi2 : ahci
[    1.577306] scsi3 : ahci
[    1.577763] scsi4 : ahci
[    1.578246] scsi5 : ahci
[    1.579326] ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 45
[    1.579964] ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 45
[    1.580567] ata3: DUMMY
[    1.580929] ata4: DUMMY
[    1.581288] ata5: SATA max UDMA/133 abar m2048@0xf2627000 port 0xf2627300 irq 45
[    1.581892] ata6: SATA max UDMA/133 abar m2048@0xf2627000 port 0xf2627380 irq 45
[    1.582614] Fixed MDIO Bus: probed
[    1.583008] Virtual Ethernet: Copyright (C) 2009 Novell, Gregory Haskins
[    1.583370] VENET: Using 256/256 queue depth
[    1.583787] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.584182] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    1.584540] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    1.584905] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.585306] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.585681] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    1.586128] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.591007] ehci_hcd 0000:00:1a.0: debug port 2
[    1.595277] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    1.595657] ehci_hcd 0000:00:1a.0: irq 23, io mem 0xf2628000
[    1.605926] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.606325] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.606686] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.607306] usb usb1: Product: EHCI Host Controller
[    1.607661] usb usb1: Manufacturer: Linux 2.6.37-rc6-next-20101220 ehci_hcd
[    1.608036] usb usb1: SerialNumber: 0000:00:1a.0
[    1.608518] hub 1-0:1.0: USB hub found
[    1.608873] hub 1-0:1.0: 3 ports detected
[    1.609369] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    1.609732] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    1.610121] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.610501] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.610865] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    1.611315] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.616978] ehci_hcd 0000:00:1d.0: debug port 2
[    1.621253] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    1.621644] ehci_hcd 0000:00:1d.0: irq 19, io mem 0xf2628400
[    1.631898] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.638111] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.638473] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.639096] usb usb2: Product: EHCI Host Controller
[    1.639453] usb usb2: Manufacturer: Linux 2.6.37-rc6-next-20101220 ehci_hcd
[    1.639814] usb usb2: SerialNumber: 0000:00:1d.0
[    1.640302] hub 2-0:1.0: USB hub found
[    1.640659] hub 2-0:1.0: 3 ports detected
[    1.641151] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.641524] uhci_hcd: USB Universal Host Controller Interface driver
[    1.642022] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.647640] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.648016] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.648496] mousedev: PS/2 mouse device common for all mice
[    1.649096] rtc_cmos 01:08: RTC can wake from S4
[    1.652355] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.655950] rtc_cmos 01:08: rtc core: registered rtc_cmos as rtc0
[    1.656346] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.656830] device-mapper: uevent: version 1.0.3
[    1.657356] device-mapper: ioctl: 4.19.0-ioctl (2010-10-14) initialised: dm-devel@redhat.com
[    1.658390] cpuidle: using governor ladder
[    1.660643] cpuidle: using governor menu
[    1.661262] usbcore: registered new interface driver usbhid
[    1.661617] usbhid: USB HID core driver
[    1.662032] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.662565] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.662953] TCP cubic registered
[    1.663306] Initializing XFRM netlink socket
[    1.663675] NET: Registered protocol family 17
[    1.664061] Registering the dns_resolver key type
[    1.664541] PM: Hibernation image not present or could not be loaded.
[    1.664933] registered taskstats version 1
[    1.670918] IMA: No TPM chip found, activating TPM-bypass!
[    1.671916]   Magic number: 6:485:397
[    1.672290] mem random: hash matches
[    1.672730] rtc_cmos 01:08: setting system clock to 2010-12-20 20:23:27 UTC (1292876607)
[    1.673578] Initalizing network drop monitor service
[    1.783043] ACPI: Battery Slot [BAT0] (battery present)
[    1.886728] ata5: SATA link down (SStatus 0 SControl 300)
[    1.887734] ata6: SATA link down (SStatus 0 SControl 300)
[    1.910784] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    2.025249] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    2.025632] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.026292] hub 1-1:1.0: USB hub found
[    2.026874] hub 1-1:1.0: 6 ports detected
[    2.129567] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    2.243921] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    2.244317] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.245121] hub 2-1:1.0: USB hub found
[    2.245657] hub 2-1:1.0: 8 ports detected
[    2.320618] usb 1-1.3: new full speed USB device using ehci_hcd and address 3
[    2.361357] Refined TSC clocksource calibration: 1595.999 MHz.
[    2.361731] Switching to clocksource tsc
[    2.396977] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
[    2.397353] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.397962] usb 1-1.3: Product: Biometric Coprocessor
[    2.398328] usb 1-1.3: Manufacturer: UPEK
[    2.459208] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.459619] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.466187] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.466577] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.467237] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.470475] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.472511] usb 1-1.4: new full speed USB device using ehci_hcd and address 4
[    2.473447] ata1.00: ATA-8: OCZ-VERTEX2, 1.22, max UDMA/133
[    2.473809] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.475967] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.478127] ata2.00: ATAPI: Optiarc DVD RW AD-7700H, 1.FA, max UDMA/100
[    2.483582] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.484102] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.484684] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.493438] ata1.00: configured for UDMA/133
[    2.494448] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    2.495720] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd047b1/0xb40000/0xa0000
[    2.496352] serio: Synaptics pass-through port at isa0060/serio1/input0
[    2.499930] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    2.502121] ata2.00: configured for UDMA/100
[    2.513416] ata1.00: configured for UDMA/133
[    2.513794] ata1: EH complete
[    2.514445] scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX2      1.22 PQ: 0 ANSI: 5
[    2.515502] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.515515] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[    2.515670] sd 0:0:0:0: [sda] Write Protect is off
[    2.515676] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.515725] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.516400]  sda: sda1 sda2 sda3
[    2.518666] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.529258] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7700H  1.FA PQ: 0 ANSI: 5
[    2.546807] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.547440] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.548074] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.548625] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.549186] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input4
[    2.562509] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=217f
[    2.562874] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.563498] usb 1-1.4: Product: Broadcom Bluetooth Device
[    2.563858] usb 1-1.4: Manufacturer: Broadcom Corp
[    2.564288] usb 1-1.4: SerialNumber: 70F39533F18A
[    2.628319] usb 2-1.5: new full speed USB device using ehci_hcd and address 3
[    2.709347] usb 2-1.5: New USB device found, idVendor=17ef, idProduct=1003
[    2.709710] usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.710346] usb 2-1.5: Product: Integrated Smart Card Reader
[    2.710709] usb 2-1.5: Manufacturer: Lenovo
[    9.569089] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    9.844578] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input5
[    9.948425] md: Waiting for all devices to be available before autodetect
[    9.948807] md: If you don't use raid, use raid=noautodetect
[    9.949507] md: Autodetecting RAID arrays.
[    9.949879] md: Scanned 0 and added 0 devices.
[    9.950264] md: autorun ...
[    9.950633] md: ... autorun DONE.
[    9.951443] EXT3-fs (sda2): error: couldn't mount because of unsupported optional features (240)
[    9.956188] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    9.957097] VFS: Mounted root (ext2 filesystem) readonly on device 8:2.
[    9.958628] devtmpfs: mounted
[    9.966319] Freeing unused kernel memory: 936k freed
[    9.966919] Write protecting the kernel read-only data: 10240k
[    9.989613] Freeing unused kernel memory: 1576k freed
[   10.014733] Freeing unused kernel memory: 1764k freed
[   10.128151] readahead-collector: starting
[   10.255693] udev[129]: starting version 161
[   10.306174] wmi: Mapper loaded
[   10.345776] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   10.346173] thinkpad_acpi: http://ibm-acpi.sf.net/
[   10.346548] thinkpad_acpi: ThinkPad BIOS 6NET54WW (1.17 ), EC 6MHT35WW-1.10
[   10.346947] thinkpad_acpi: Lenovo ThinkPad W510, model 4391BS6
[   10.348483] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   10.352772] thinkpad_acpi: radio switch found; radios are enabled
[   10.375834] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[   10.390732] Registered led device: tpacpi::thinklight
[   10.391198] Registered led device: tpacpi::power
[   10.391619] Registered led device: tpacpi::standby
[   10.392112] Registered led device: tpacpi::thinkvantage
[   10.427775] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   10.434821] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
[   10.450492] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   10.462477] WARNING! power/level is deprecated; use power/control instead
[   10.472733] iTCO_vendor_support: vendor-support=0
[   10.490920] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-k2
[   10.491307] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[   10.491758] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   10.492162] e1000e 0000:00:19.0: setting latency timer to 64
[   10.492811] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   10.531480] hrtimer: interrupt took 13286 ns
[   10.533137] cfg80211: Calling CRDA to update world regulatory domain
[   10.533638] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[   10.540018] iTCO_wdt: Found a QM57 TCO device (Version=2, TCOBASE=0x1060)
[   10.540519] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   10.561703] EDAC MC: Ver: 2.1.0 Dec 20 2010
[   10.583629] Bluetooth: Core ver 2.15
[   10.584034] NET: Registered protocol family 31
[   10.584405] Bluetooth: HCI device and connection manager initialized
[   10.584799] Bluetooth: HCI socket layer initialized
[   10.601590] sdhci: Secure Digital Host Controller Interface driver
[   10.601919] sdhci: Copyright(c) Pierre Ossman
[   10.602245] microcode: CPU0 sig=0x106e5, pf=0x10, revision=0x3
[   10.609294] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   10.609630] microcode: CPU1 sig=0x106e5, pf=0x10, revision=0x3
[   10.613285] usbcore: registered new interface driver btusb
[   10.627986] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e822] (rev 1)
[   10.628610] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.628727] cfg80211: World regulatory domain updated:
[   10.628731] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   10.628737] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   10.628742] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   10.628747] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   10.628752] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   10.628757] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   10.633512] sdhci-pci 0000:0d:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[   10.634120] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[   10.634716] Registered led device: mmc0::
[   10.635172] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[   10.635536] sdhci-pci 0000:17:00.0: SDHCI controller found [1180:e822] (rev 1)
[   10.636134] sdhci-pci 0000:17:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   10.636758] sdhci-pci 0000:17:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[   10.637348] sdhci-pci 0000:17:00.0: setting latency timer to 64
[   10.637743] Registered led device: mmc1::
[   10.638148] mmc1: SDHCI controller on PCI [0000:17:00.0] using DMA
[   10.669728] EDAC MC0: Giving out device to 'i7core_edac.c' 'i7 core #0': DEV 0000:ff:03.0
[   10.670386] EDAC PCI0: Giving out device to module 'i7core_edac' controller 'EDAC PCI controller': DEV '0000:ff:03.0' (POLLED)
[   10.671033] EDAC i7core: Driver loaded, 1 memory controller(s) found.
[   10.679165] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 5c:ff:35:05:94:7a
[   10.679800] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   10.680265] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: A002FF-0FF
[   10.680872] intel ips 0000:00:1f.6: Non-IPS CPU detected.
[   10.681242] intel ips 0000:00:1f.6: IPS not supported on this CPU
[   10.695944] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[   10.696565] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   10.697035] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   10.697426] iwlagn 0000:03:00.0: setting latency timer to 64
[   10.697894] iwlagn 0000:03:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
[   10.698509] xhci_hcd 0000:0f:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   10.698891] xhci_hcd 0000:0f:00.0: setting latency timer to 64
[   10.699408] xhci_hcd 0000:0f:00.0: xHCI Host Controller
[   10.699967] xhci_hcd 0000:0f:00.0: new USB bus registered, assigned bus number 3
[   10.706089] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   10.724789] iwlagn 0000:03:00.0: device EEPROM VER=0x436, CALIB=0x6
[   10.725170] iwlagn 0000:03:00.0: Device SKU: 0Xb
[   10.725557] iwlagn 0000:03:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
[   10.725980] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   10.726778] iwlagn 0000:03:00.0: irq 47 for MSI/MSI-X
[   10.733274] iwlagn 0000:03:00.0: loaded firmware version 9.221.4.1 build 25532
[   10.734115] audit: name_count maxed, losing inode data: dev=00:07, inode=7305
[   10.734675] audit: name_count maxed, losing inode data: dev=00:07, inode=7305
[   10.735053] audit: name_count maxed, losing inode data: dev=00:07, inode=7305
[   10.735471] audit: name_count maxed, losing inode data: dev=00:07, inode=7297
[   10.735877] audit: name_count maxed, losing inode data: dev=00:07, inode=7310
[   10.736171] xhci_hcd 0000:0f:00.0: irq 18, io mem 0xf2200000
[   10.736671] audit: name_count maxed, losing inode data: dev=00:07, inode=7310
[   10.736677] xhci_hcd 0000:0f:00.0: irq 48 for MSI/MSI-X
[   10.736685] xhci_hcd 0000:0f:00.0: irq 49 for MSI/MSI-X
[   10.736693] xhci_hcd 0000:0f:00.0: irq 50 for MSI/MSI-X
[   10.736700] xhci_hcd 0000:0f:00.0: irq 51 for MSI/MSI-X
[   10.736708] xhci_hcd 0000:0f:00.0: irq 52 for MSI/MSI-X
[   10.736715] xhci_hcd 0000:0f:00.0: irq 53 for MSI/MSI-X
[   10.736724] xhci_hcd 0000:0f:00.0: irq 54 for MSI/MSI-X
[   10.736732] xhci_hcd 0000:0f:00.0: irq 55 for MSI/MSI-X
[   10.739277] usb usb3: No SuperSpeed endpoint companion for config 1  interface 0 altsetting 0 ep 129: using minimum values
[   10.739304] usb usb3: New USB device found, idVendor=1d6b, idProduct=0003
[   10.739309] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.739313] usb usb3: Product: xHCI Host Controller
[   10.739316] usb usb3: Manufacturer: Linux 2.6.37-rc6-next-20101220 xhci_hcd
[   10.739320] usb usb3: SerialNumber: 0000:0f:00.0
[   10.739484] xHCI xhci_add_endpoint called for root hub
[   10.739487] xHCI xhci_check_bandwidth called for root hub
[   10.739549] hub 3-0:1.0: USB hub found
[   10.739557] hub 3-0:1.0: 4 ports detected
[   10.744530] audit: name_count maxed, losing inode data: dev=00:07, inode=7310
[   10.744902] audit: name_count maxed, losing inode data: dev=00:07, inode=7310
[   10.745364] audit: name_count maxed, losing inode data: dev=00:07, inode=1
[   10.745747] [drm] Initialized drm 1.1.0 20060810
[   10.745854] firewire_ohci 0000:17:00.3: PCI INT D -> GSI 18 (level, low) -> IRQ 18
[   10.745871] firewire_ohci 0000:17:00.3: setting latency timer to 64
[   10.751841] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   10.766972] cfg80211: Calling CRDA for country: US
[   10.772021] cfg80211: Regulatory domain changed to country: US
[   10.772405] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   10.773045] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[   10.773697] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[   10.774325] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   10.774942] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   10.775541] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   10.776155] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[   10.799460] firewire_ohci 0000:17:00.3: irq 56 for MSI/MSI-X
[   10.799945] firewire_ohci: Added fw-ohci device 0000:17:00.3, OHCI v1.10, 4 IR + 4 IT contexts, quirks 0x1
[   10.872394] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   10.873126] HDA Intel 0000:00:1b.0: irq 57 for MSI/MSI-X
[   10.873536] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   10.874673] nouveau 0000:01:00.0: power state changed by ACPI to D0
[   10.875029] nouveau 0000:01:00.0: power state changed by ACPI to D0
[   10.875445] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.875805] nouveau 0000:01:00.0: setting latency timer to 64
[   10.877940] audit: name_count maxed, losing inode data: dev=00:07, inode=5114
[   10.878327] audit: name_count maxed, losing inode data: dev=00:07, inode=5114
[   10.878676] audit: name_count maxed, losing inode data: dev=00:07, inode=5114
[   10.879059] audit: name_count maxed, losing inode data: dev=00:05, inode=3
[   10.879467] audit: name_count maxed, losing inode data: dev=00:05, inode=3
[   10.879824] audit: name_count maxed, losing inode data: dev=00:05, inode=12295
[   10.880459] audit: name_count maxed, losing inode data: dev=00:05, inode=12295
[   10.881097] audit: name_count maxed, losing inode data: dev=00:07, inode=7315
[   10.881549] audit: name_count maxed, losing inode data: dev=00:07, inode=12297
[   10.882287] audit: name_count maxed, losing inode data: dev=00:07, inode=12297
[   10.882936] audit: name_count maxed, losing inode data: dev=00:07, inode=12297
[   10.883646] audit: name_count maxed, losing inode data: dev=00:07, inode=12297
[   10.884454] audit: name_count maxed, losing inode data: dev=00:07, inode=12297
[   10.885245] audit: name_count maxed, losing inode data: dev=00:07, inode=12297
[   10.885851] audit: name_count maxed, losing inode data: dev=00:07, inode=12297
[   10.886534] audit: name_count maxed, losing inode data: dev=00:07, inode=12297
[   10.887222] audit: name_count maxed, losing inode data: dev=00:07, inode=12297
[   10.887829] audit: name_count maxed, losing inode data: dev=00:07, inode=12297
[   10.888516] audit: name_count maxed, losing inode data: dev=00:07, inode=12297
[   10.889123] audit: name_count maxed, losing inode data: dev=00:07, inode=12297
[   10.889813] audit: name_count maxed, losing inode data: dev=00:05, inode=12295
[   10.890431] audit: name_count maxed, losing inode data: dev=00:05, inode=12295
[   10.893271] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x0a5e00a2)
[   10.905474] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[   11.002668] [drm] nouveau 0000:01:00.0: ... appears to be valid
[   11.003023] [drm] nouveau 0000:01:00.0: BIT BIOS found
[   11.003435] [drm] nouveau 0000:01:00.0: Bios version 70.16.5f.00
[   11.003790] [drm] nouveau 0000:01:00.0: Pointer to BIT loadval table invalid
[   11.004178] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[   11.004534] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[   11.005151] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 01800323 00010034
[   11.005505] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02811300 00000000
[   11.005856] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 028223a6 0f220010
[   11.006257] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 02822362 00020010
[   11.006615] [drm] nouveau 0000:01:00.0: Raw DCB entry 4: 048333b6 0f220010
[   11.006968] [drm] nouveau 0000:01:00.0: Raw DCB entry 5: 04833372 00020010
[   11.007364] [drm] nouveau 0000:01:00.0: Raw DCB entry 6: 088443c6 0f220010
[   11.007717] [drm] nouveau 0000:01:00.0: Raw DCB entry 7: 08844382 00020010
[   11.008138] [drm] nouveau 0000:01:00.0: Raw DCB entry 8: 0000000e 00000000
[   11.008501] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 16 4
[   11.008856] [drm] nouveau 0000:01:00.0:   0: 0x00000040: type 0x40 idx 0 tag 0xff
[   11.009485] [drm] nouveau 0000:01:00.0:   1: 0x00000100: type 0x00 idx 1 tag 0xff
[   11.010175] [drm] nouveau 0000:01:00.0:   2: 0x00101246: type 0x46 idx 2 tag 0x07
[   11.010779] [drm] nouveau 0000:01:00.0:   3: 0x00202346: type 0x46 idx 3 tag 0x08
[   11.011401] [drm] nouveau 0000:01:00.0:   4: 0x00410446: type 0x46 idx 4 tag 0x51
[   11.011992] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xE7FF
[   11.085040] [drm] nouveau 0000:01:00.0: 0xEAB9: Condition still not met after 20ms, skipping following opcodes
[   11.106070] [drm] nouveau 0000:01:00.0: 0xEABD: Condition still not met after 20ms, skipping following opcodes
[   11.127050] [drm] nouveau 0000:01:00.0: 0xEC6A: Condition still not met after 20ms, skipping following opcodes
[   11.127670] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xEC97
[   11.138977] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xFB97
[   11.139592] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xFBB9
[   11.183499] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xFD1B
[   11.184137] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xFD80
[   11.204969] [drm] nouveau 0000:01:00.0: 0xE67F: Condition still not met after 20ms, skipping following opcodes
[   11.224438] [drm] nouveau 0000:01:00.0: 3 available performance level(s)
[   11.224795] [drm] nouveau 0000:01:00.0: 0: memory 135MHz core 135MHz shader 270MHz voltage 800mV
[   11.225396] [drm] nouveau 0000:01:00.0: 1: memory 324MHz core 405MHz shader 810MHz voltage 850mV
[   11.225995] [drm] nouveau 0000:01:00.0: 3: memory 790MHz core 550MHz shader 1210MHz voltage 930mV
[   11.226600] [drm] nouveau 0000:01:00.0: c: memory 950MHz core 550MHz shader 200MHz
[   11.227196] [drm] nouveau 0000:01:00.0: setting performance level: 0
[   11.227756] [TTM] Zone  kernel: Available graphics memory: 4062320 kiB.
[   11.228178] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[   11.228533] [TTM] Initializing pool allocator.
[   11.228902] [drm] nouveau 0000:01:00.0: Detected 1024MiB VRAM
[   11.276424] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[   11.300951] firewire_core: created device fw0: GUID 5cff35ff05947aff, S400
[   11.358736] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   11.359094] [drm] No driver support for vblank timestamp query.
[   11.667278] [drm] nouveau 0000:01:00.0: allocated 1920x1080 fb: 0x60000000, bo ffff88022668a800
[   11.667898] audit: name_count maxed, losing inode data: dev=00:05, inode=3
[   11.668250] audit: name_count maxed, losing inode data: dev=00:05, inode=3
[   11.668648] fbcon: nouveaufb (fb0) is primary device
[   11.679710] Console: switching to colour frame buffer device 240x67
[   11.684430] fb0: nouveaufb frame buffer device
[   11.684461] drm: registered panic notifier
[   11.684495] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[   11.684551] HDA Intel 0000:01:00.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   11.684596] hda_intel: Disable MSI for Nvidia chipset
[   11.684717] HDA Intel 0000:01:00.1: setting latency timer to 64
[   12.023467] audit: name_count maxed, losing inode data: dev=00:05, inode=9455
[   12.023600] audit: name_count maxed, losing inode data: dev=00:05, inode=6585
[   12.023686] audit: name_count maxed, losing inode data: dev=00:05, inode=6585
[   12.023848] audit: name_count maxed, losing inode data: dev=00:05, inode=6585
[   12.023933] audit: name_count maxed, losing inode data: dev=00:05, inode=6585
[   12.024088] audit: name_count maxed, losing inode data: dev=00:05, inode=6585
[   12.024193] audit: name_count maxed, losing inode data: dev=00:05, inode=6585
[   12.024350] audit: name_count maxed, losing inode data: dev=00:05, inode=6585
[   12.024439] audit: name_count maxed, losing inode data: dev=00:05, inode=6585
[   12.024597] audit: name_count maxed, losing inode data: dev=00:05, inode=6585
[   12.024686] audit: name_count maxed, losing inode data: dev=00:05, inode=6585
[   12.024951] audit: name_count maxed, losing inode data: dev=00:05, inode=6585
[   12.025036] audit: name_count maxed, losing inode data: dev=00:05, inode=6585
[   25.491691] SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-tasks(W) dump-ftrace-buffer(Z) 
[   71.118766] microcode: CPU2 sig=0x106e5, pf=0x10, revision=0x3
[  131.989437] microcode: CPU3 sig=0x106e5, pf=0x10, revision=0x3
[  190.284548] audit: name_count maxed, losing inode data: dev=00:07, inode=6783
[  190.284643] audit: name_count maxed, losing inode data: dev=00:07, inode=6783
[  190.284729] audit: name_count maxed, losing inode data: dev=00:07, inode=6783
[  190.284815] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.284900] audit: name_count maxed, losing inode data: dev=00:07, inode=6788
[  190.284984] audit: name_count maxed, losing inode data: dev=00:07, inode=6788
[  190.285100] audit: name_count maxed, losing inode data: dev=00:07, inode=6788
[  190.285183] audit: name_count maxed, losing inode data: dev=00:07, inode=6788
[  190.285265] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.285347] audit: name_count maxed, losing inode data: dev=00:07, inode=6793
[  190.285428] audit: name_count maxed, losing inode data: dev=00:07, inode=6793
[  190.285511] audit: name_count maxed, losing inode data: dev=00:07, inode=6793
[  190.285592] audit: name_count maxed, losing inode data: dev=00:07, inode=6793
[  190.285675] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.285759] audit: name_count maxed, losing inode data: dev=00:07, inode=6798
[  190.288906] audit: name_count maxed, losing inode data: dev=00:07, inode=6798
[  190.292119] audit: name_count maxed, losing inode data: dev=00:07, inode=6798
[  190.295215] audit: name_count maxed, losing inode data: dev=00:07, inode=6798
[  190.298233] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.301220] audit: name_count maxed, losing inode data: dev=00:07, inode=6803
[  190.304130] audit: name_count maxed, losing inode data: dev=00:07, inode=6803
[  190.306955] audit: name_count maxed, losing inode data: dev=00:07, inode=6803
[  190.309624] audit: name_count maxed, losing inode data: dev=00:07, inode=6803
[  190.312316] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.314942] audit: name_count maxed, losing inode data: dev=00:07, inode=6808
[  190.317517] audit: name_count maxed, losing inode data: dev=00:07, inode=6808
[  190.320052] audit: name_count maxed, losing inode data: dev=00:07, inode=6808
[  190.322567] audit: name_count maxed, losing inode data: dev=00:07, inode=6808
[  190.325041] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.327485] audit: name_count maxed, losing inode data: dev=00:07, inode=6813
[  190.329914] audit: name_count maxed, losing inode data: dev=00:07, inode=6813
[  190.332291] audit: name_count maxed, losing inode data: dev=00:07, inode=6813
[  190.334534] audit: name_count maxed, losing inode data: dev=00:07, inode=6813
[  190.336804] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.339018] audit: name_count maxed, losing inode data: dev=00:07, inode=6818
[  190.341177] audit: name_count maxed, losing inode data: dev=00:07, inode=6818
[  190.343276] audit: name_count maxed, losing inode data: dev=00:07, inode=6818
[  190.345316] audit: name_count maxed, losing inode data: dev=00:07, inode=6818
[  190.347365] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.349374] audit: name_count maxed, losing inode data: dev=00:07, inode=6823
[  190.351346] audit: name_count maxed, losing inode data: dev=00:07, inode=6823
[  190.353294] audit: name_count maxed, losing inode data: dev=00:07, inode=6823
[  190.355135] audit: name_count maxed, losing inode data: dev=00:07, inode=6823
[  190.356967] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.358745] audit: name_count maxed, losing inode data: dev=00:07, inode=6828
[  190.360486] audit: name_count maxed, losing inode data: dev=00:07, inode=6828
[  190.362176] audit: name_count maxed, losing inode data: dev=00:07, inode=6828
[  190.363834] audit: name_count maxed, losing inode data: dev=00:07, inode=6828
[  190.365397] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367153] audit: name_count maxed, losing inode data: dev=00:07, inode=6833
[  190.367164] audit: name_count maxed, losing inode data: dev=00:07, inode=6833
[  190.367183] audit: name_count maxed, losing inode data: dev=00:07, inode=6833
[  190.367193] audit: name_count maxed, losing inode data: dev=00:07, inode=6833
[  190.367206] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367217] audit: name_count maxed, losing inode data: dev=00:07, inode=6838
[  190.367227] audit: name_count maxed, losing inode data: dev=00:07, inode=6838
[  190.367243] audit: name_count maxed, losing inode data: dev=00:07, inode=6838
[  190.367258] audit: name_count maxed, losing inode data: dev=00:07, inode=6838
[  190.367271] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367281] audit: name_count maxed, losing inode data: dev=00:07, inode=6843
[  190.367291] audit: name_count maxed, losing inode data: dev=00:07, inode=6843
[  190.367311] audit: name_count maxed, losing inode data: dev=00:07, inode=6843
[  190.367315] audit: name_count maxed, losing inode data: dev=00:07, inode=6843
[  190.367319] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367323] audit: name_count maxed, losing inode data: dev=00:07, inode=6848
[  190.367326] audit: name_count maxed, losing inode data: dev=00:07, inode=6848
[  190.367333] audit: name_count maxed, losing inode data: dev=00:07, inode=6848
[  190.367337] audit: name_count maxed, losing inode data: dev=00:07, inode=6848
[  190.367342] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367346] audit: name_count maxed, losing inode data: dev=00:07, inode=6853
[  190.367349] audit: name_count maxed, losing inode data: dev=00:07, inode=6853
[  190.367364] audit: name_count maxed, losing inode data: dev=00:07, inode=6853
[  190.367367] audit: name_count maxed, losing inode data: dev=00:07, inode=6853
[  190.367371] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367376] audit: name_count maxed, losing inode data: dev=00:07, inode=6858
[  190.367379] audit: name_count maxed, losing inode data: dev=00:07, inode=6858
[  190.367389] audit: name_count maxed, losing inode data: dev=00:07, inode=6858
[  190.367393] audit: name_count maxed, losing inode data: dev=00:07, inode=6858
[  190.367398] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367402] audit: name_count maxed, losing inode data: dev=00:07, inode=6863
[  190.367405] audit: name_count maxed, losing inode data: dev=00:07, inode=6863
[  190.367412] audit: name_count maxed, losing inode data: dev=00:07, inode=6863
[  190.367416] audit: name_count maxed, losing inode data: dev=00:07, inode=6863
[  190.367420] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367423] audit: name_count maxed, losing inode data: dev=00:07, inode=6868
[  190.367427] audit: name_count maxed, losing inode data: dev=00:07, inode=6868
[  190.367435] audit: name_count maxed, losing inode data: dev=00:07, inode=6868
[  190.367438] audit: name_count maxed, losing inode data: dev=00:07, inode=6868
[  190.367442] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367447] audit: name_count maxed, losing inode data: dev=00:07, inode=6873
[  190.367450] audit: name_count maxed, losing inode data: dev=00:07, inode=6873
[  190.367458] audit: name_count maxed, losing inode data: dev=00:07, inode=6873
[  190.367461] audit: name_count maxed, losing inode data: dev=00:07, inode=6873
[  190.367466] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367469] audit: name_count maxed, losing inode data: dev=00:07, inode=6878
[  190.367473] audit: name_count maxed, losing inode data: dev=00:07, inode=6878
[  190.367480] audit: name_count maxed, losing inode data: dev=00:07, inode=6878
[  190.367484] audit: name_count maxed, losing inode data: dev=00:07, inode=6878
[  190.367488] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367493] audit: name_count maxed, losing inode data: dev=00:07, inode=6883
[  190.367497] audit: name_count maxed, losing inode data: dev=00:07, inode=6883
[  190.367503] audit: name_count maxed, losing inode data: dev=00:07, inode=6883
[  190.367507] audit: name_count maxed, losing inode data: dev=00:07, inode=6883
[  190.367511] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367521] audit: name_count maxed, losing inode data: dev=00:07, inode=6888
[  190.367524] audit: name_count maxed, losing inode data: dev=00:07, inode=6888
[  190.367529] audit: name_count maxed, losing inode data: dev=00:07, inode=6888
[  190.367533] audit: name_count maxed, losing inode data: dev=00:07, inode=6888
[  190.367537] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367541] audit: name_count maxed, losing inode data: dev=00:07, inode=6893
[  190.367544] audit: name_count maxed, losing inode data: dev=00:07, inode=6893
[  190.367551] audit: name_count maxed, losing inode data: dev=00:07, inode=6893
[  190.367555] audit: name_count maxed, losing inode data: dev=00:07, inode=6893
[  190.367559] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367562] audit: name_count maxed, losing inode data: dev=00:07, inode=6898
[  190.367566] audit: name_count maxed, losing inode data: dev=00:07, inode=6898
[  190.367571] audit: name_count maxed, losing inode data: dev=00:07, inode=6898
[  190.367575] audit: name_count maxed, losing inode data: dev=00:07, inode=6898
[  190.367579] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367583] audit: name_count maxed, losing inode data: dev=00:07, inode=6903
[  190.367588] audit: name_count maxed, losing inode data: dev=00:07, inode=6903
[  190.367594] audit: name_count maxed, losing inode data: dev=00:07, inode=6903
[  190.367598] audit: name_count maxed, losing inode data: dev=00:07, inode=6903
[  190.367602] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367605] audit: name_count maxed, losing inode data: dev=00:07, inode=6908
[  190.367609] audit: name_count maxed, losing inode data: dev=00:07, inode=6908
[  190.367614] audit: name_count maxed, losing inode data: dev=00:07, inode=6908
[  190.367617] audit: name_count maxed, losing inode data: dev=00:07, inode=6908
[  190.367622] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367625] audit: name_count maxed, losing inode data: dev=00:07, inode=6913
[  190.367628] audit: name_count maxed, losing inode data: dev=00:07, inode=6913
[  190.367634] audit: name_count maxed, losing inode data: dev=00:07, inode=6913
[  190.367644] audit: name_count maxed, losing inode data: dev=00:07, inode=6913
[  190.367648] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367652] audit: name_count maxed, losing inode data: dev=00:07, inode=6918
[  190.367657] audit: name_count maxed, losing inode data: dev=00:07, inode=6918
[  190.367663] audit: name_count maxed, losing inode data: dev=00:07, inode=6918
[  190.367667] audit: name_count maxed, losing inode data: dev=00:07, inode=6918
[  190.367672] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367675] audit: name_count maxed, losing inode data: dev=00:07, inode=6923
[  190.367679] audit: name_count maxed, losing inode data: dev=00:07, inode=6923
[  190.367689] audit: name_count maxed, losing inode data: dev=00:07, inode=6923
[  190.367693] audit: name_count maxed, losing inode data: dev=00:07, inode=6923
[  190.367698] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367701] audit: name_count maxed, losing inode data: dev=00:07, inode=6928
[  190.367705] audit: name_count maxed, losing inode data: dev=00:07, inode=6928
[  190.367711] audit: name_count maxed, losing inode data: dev=00:07, inode=6928
[  190.367716] audit: name_count maxed, losing inode data: dev=00:07, inode=6928
[  190.367721] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367725] audit: name_count maxed, losing inode data: dev=00:07, inode=6933
[  190.367729] audit: name_count maxed, losing inode data: dev=00:07, inode=6933
[  190.367736] audit: name_count maxed, losing inode data: dev=00:07, inode=6933
[  190.367739] audit: name_count maxed, losing inode data: dev=00:07, inode=6933
[  190.367744] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367747] audit: name_count maxed, losing inode data: dev=00:07, inode=6938
[  190.367750] audit: name_count maxed, losing inode data: dev=00:07, inode=6938
[  190.367757] audit: name_count maxed, losing inode data: dev=00:07, inode=6938
[  190.367760] audit: name_count maxed, losing inode data: dev=00:07, inode=6938
[  190.367764] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367768] audit: name_count maxed, losing inode data: dev=00:07, inode=6943
[  190.367779] audit: name_count maxed, losing inode data: dev=00:07, inode=6943
[  190.367787] audit: name_count maxed, losing inode data: dev=00:07, inode=6943
[  190.367791] audit: name_count maxed, losing inode data: dev=00:07, inode=6943
[  190.367797] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367802] audit: name_count maxed, losing inode data: dev=00:07, inode=6948
[  190.367806] audit: name_count maxed, losing inode data: dev=00:07, inode=6948
[  190.367813] audit: name_count maxed, losing inode data: dev=00:07, inode=6948
[  190.367817] audit: name_count maxed, losing inode data: dev=00:07, inode=6948
[  190.367821] audit: name_count maxed, losing inode data: dev=00:07, inode=6775
[  190.367825] audit: name_count maxed, losing inode data: dev=00:07, inode=6953
[  190.367828] audit: name_count maxed, losing inode data: dev=00:07, inode=6953
[  190.367833] audit: name_count maxed, losing inode data: dev=00:07, inode=6953
[  190.367837] audit: name_count maxed, losing inode data: dev=00:07, inode=6953
[  190.367844] audit: name_count maxed, losing inode data: dev=00:07, inode=154
[  190.367848] audit: name_count maxed, losing inode data: dev=00:07, inode=6958
[  190.367852] audit: name_count maxed, losing inode data: dev=00:07, inode=6958
[  190.367856] audit: name_count maxed, losing inode data: dev=00:07, inode=6958
[  190.367859] audit: name_count maxed, losing inode data: dev=00:07, inode=6961
[  190.367863] audit: name_count maxed, losing inode data: dev=00:07, inode=6961
[  190.367868] audit: name_count maxed, losing inode data: dev=00:07, inode=6961
[  190.367872] audit: name_count maxed, losing inode data: dev=00:07, inode=6961
[  190.367878] audit: name_count maxed, losing inode data: dev=00:07, inode=6958
[  190.367883] audit: name_count maxed, losing inode data: dev=00:07, inode=6966
[  190.367891] audit: name_count maxed, losing inode data: dev=00:07, inode=6966
[  190.367897] audit: name_count maxed, losing inode data: dev=00:07, inode=6966
[  190.367900] audit: name_count maxed, losing inode data: dev=00:07, inode=6966
[  190.367904] audit: name_count maxed, losing inode data: dev=00:07, inode=6958
[  190.367924] audit: name_count maxed, losing inode data: dev=00:07, inode=6971
[  190.367935] audit: name_count maxed, losing inode data: dev=00:07, inode=6971
[  190.367940] audit: name_count maxed, losing inode data: dev=00:07, inode=6971
[  190.367943] audit: name_count maxed, losing inode data: dev=00:07, inode=6971
[  190.367947] audit: name_count maxed, losing inode data: dev=00:07, inode=6958
[  190.367953] audit: name_count maxed, losing inode data: dev=00:07, inode=6976
[  190.367957] audit: name_count maxed, losing inode data: dev=00:07, inode=6976
[  190.367960] audit: name_count maxed, losing inode data: dev=00:07, inode=6976
[  190.367964] audit: name_count maxed, losing inode data: dev=00:07, inode=6976
[  190.367969] audit: name_count maxed, losing inode data: dev=00:07, inode=6958
[  190.367974] audit: name_count maxed, losing inode data: dev=00:07, inode=6981
[  190.367977] audit: name_count maxed, losing inode data: dev=00:07, inode=6981
[  190.367985] audit: name_count maxed, losing inode data: dev=00:07, inode=6981
[  190.367988] audit: name_count maxed, losing inode data: dev=00:07, inode=6981
[  190.367993] audit: name_count maxed, losing inode data: dev=00:07, inode=6958
[  190.367998] audit: name_count maxed, losing inode data: dev=00:07, inode=6986
[  190.368001] audit: name_count maxed, losing inode data: dev=00:07, inode=6986
[  190.368008] audit: name_count maxed, losing inode data: dev=00:07, inode=6986
[  190.368012] audit: name_count maxed, losing inode data: dev=00:07, inode=6986
[  190.368017] audit: name_count maxed, losing inode data: dev=00:07, inode=6958
[  190.368022] audit: name_count maxed, losing inode data: dev=00:07, inode=6991
[  190.368025] audit: name_count maxed, losing inode data: dev=00:07, inode=6991
[  190.368030] audit: name_count maxed, losing inode data: dev=00:07, inode=6991
[  190.368034] audit: name_count maxed, losing inode data: dev=00:07, inode=6991
[  190.368039] audit: name_count maxed, losing inode data: dev=00:07, inode=6958
[  190.368043] audit: name_count maxed, losing inode data: dev=00:07, inode=6996
[  190.368047] audit: name_count maxed, losing inode data: dev=00:07, inode=6996
[  190.368050] audit: name_count maxed, losing inode data: dev=00:07, inode=6996
[  190.368054] audit: name_count maxed, losing inode data: dev=00:07, inode=6996
[  190.368068] audit: name_count maxed, losing inode data: dev=00:07, inode=6958
[  190.368072] audit: name_count maxed, losing inode data: dev=00:07, inode=7001
[  190.368076] audit: name_count maxed, losing inode data: dev=00:07, inode=7001
[  190.368081] audit: name_count maxed, losing inode data: dev=00:07, inode=7001
[  190.368085] audit: name_count maxed, losing inode data: dev=00:07, inode=7001
[  190.368092] audit: name_count maxed, losing inode data: dev=00:07, inode=6958
[  190.368095] audit: name_count maxed, losing inode data: dev=00:07, inode=7006
[  190.368099] audit: name_count maxed, losing inode data: dev=00:07, inode=7006
[  190.368105] audit: name_count maxed, losing inode data: dev=00:07, inode=7006
[  190.368112] audit: name_count maxed, losing inode data: dev=00:07, inode=7006
[  192.859936] microcode: CPU4 sig=0x106e5, pf=0x10, revision=0x3
[  253.986252] microcode: CPU5 sig=0x106e5, pf=0x10, revision=0x3
[  309.950472] type=1305 audit(1292876916.067:11045): auid=4294967295 ses=4294967295 op="remove rule" key=(null) list=4 res=1
[  309.951783] type=1305 audit(1292876916.067:11046): audit_enabled=0 old=1 auid=4294967295 ses=4294967295 res=1
[  314.856982] microcode: CPU6 sig=0x106e5, pf=0x10, revision=0x3
[  375.727604] microcode: CPU7 sig=0x106e5, pf=0x10, revision=0x3
[  436.598180] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[  436.598669] audit: name_count maxed, losing inode data: dev=00:07, inode=7032
[  436.598676] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598682] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598688] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598694] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598700] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598705] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598712] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598718] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598724] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598784] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598791] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598798] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598804] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598810] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598815] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598821] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598827] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598833] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598840] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598845] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598851] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598858] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598864] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.598870] audit: name_count maxed, losing inode data: dev=00:07, inode=7024
[  436.663757] microcode: CPU0 updated to revision 0x4, date = 2010-04-05
[  436.665271] microcode: CPU1 updated to revision 0x4, date = 2010-04-05
[  436.667885] microcode: CPU2 updated to revision 0x4, date = 2010-04-05
[  436.671595] microcode: CPU3 updated to revision 0x4, date = 2010-04-05
[  436.675570] microcode: CPU4 updated to revision 0x4, date = 2010-04-05
[  436.678756] microcode: CPU5 updated to revision 0x4, date = 2010-04-05
[  436.681723] microcode: CPU6 updated to revision 0x4, date = 2010-04-05
[  436.683694] microcode: CPU7 updated to revision 0x4, date = 2010-04-05
[  436.777924] EXT4-fs (sda2): re-mounted. Opts: discard
[  436.847787] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[  437.955282] Adding 1048572k swap on /swapfile.  Priority:-1 extents:3 across:1064956k SS
[  438.277272] auditd (755): /proc/755/oom_adj is deprecated, please use /proc/755/oom_score_adj instead.
[  438.823426] NET: Registered protocol family 10
[  438.824972] lo: Disabled Privacy Extensions
[  439.219844] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[  439.273538] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[  439.278274] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  439.480631] RPC: Registered udp transport module.
[  439.482792] RPC: Registered tcp transport module.
[  439.485393] RPC: Registered tcp NFSv4.1 backchannel transport module.
[  439.612092] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  441.840088] Bluetooth: L2CAP ver 2.15
[  441.843227] Bluetooth: L2CAP socket layer initialized
[  441.895398] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[  441.898410] Bluetooth: BNEP filters: protocol multicast
[  441.924102] Bluetooth: SCO (Voice Link) ver 0.6
[  441.925664] Bluetooth: SCO socket layer initialized
[  442.076928] Bluetooth: RFCOMM TTY layer initialized
[  442.079025] Bluetooth: RFCOMM socket layer initialized
[  442.081000] Bluetooth: RFCOMM ver 1.11
[  442.585433] Bridge firewalling registered
[  442.849386] Ebtables v2.0 registered
[  442.868186] ip6_tables: (C) 2000-2006 Netfilter Core Team
[  443.003697] lo: Disabled Privacy Extensions
[  447.356610] hda-intel: IRQ timing workaround is activated for card #1. Suggest a bigger bdl_pos_adj.
[  452.986402] fuse init (API version 7.16)
[  457.552452] wlan0: deauthenticating from 68:7f:74:53:b8:4e by local choice (reason=3)
[  457.621523] wlan0: authenticate with 68:7f:74:53:b8:4e (try 1)
[  457.623418] wlan0: authenticated
[  457.692619] wlan0: associate with 68:7f:74:53:b8:4e (try 1)
[  457.696559] wlan0: RX AssocResp from 68:7f:74:53:b8:4e (capab=0x411 status=0 aid=2)
[  457.696568] wlan0: associated
[  457.706307] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  468.155579] wlan0: no IPv6 routers present
[  498.802667] iwlagn 0000:03:00.0: Aggregation not enabled for tid 0 because load = 1
[  567.005684] iwlagn 0000:03:00.0: Aggregation not enabled for tid 0 because load = 0
[  590.069253] iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra = 68:7f:74:53:b8:4e tid = 0
[  605.886288] iwlagn 0000:03:00.0: Aggregation not enabled for tid 6 because load = 0
[  615.556740] lo: Disabled Privacy Extensions
[  616.928149] iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra = 68:7f:74:53:b8:4e tid = 0
[  668.092590] CE: hpet3 increased min_delta_ns to 7500 nsec
[  668.092613] CE: hpet3 increased min_delta_ns to 11250 nsec

--=-=-=
Content-Disposition: attachment; filename=microcode-config

#
# Automatically generated make config: don't edit
# Linux/x86_64 2.6.37-rc6 Kernel Configuration
# Mon Dec 20 12:00:11 2010
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
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
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
CONFIG_HAVE_INTEL_TXT=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
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
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
# CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED is not set
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
# CONFIG_AUTO_IRQ_AFFINITY is not set
# CONFIG_IRQ_PER_CPU is not set
# CONFIG_HARDIRQS_SW_RESEND is not set
CONFIG_SPARSE_IRQ=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_SRCU_SYNCHRONIZE_DELAY=10
CONFIG_IKCONFIG=m
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
# CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
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

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_PERF_COUNTERS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y

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
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_INLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=y
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=y
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=y
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
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
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_UV is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=128
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
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=7
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
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
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_STATS=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=256
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=9
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
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
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
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
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_CLEANCACHE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
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
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_SLEEP_ADVANCED_DEBUG is not set
CONFIG_SUSPEND_NVS=y
CONFIG_SUSPEND=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_RUNTIME=y
CONFIG_PM_OPS=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_POWER_METER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_INTR_REMAP=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_STUB=y
CONFIG_XEN_PCIDEV_FRONTEND=y
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m
CONFIG_VBUS_PROXY=y
CONFIG_VBUS_PCIBRIDGE=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
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
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
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
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_CUBIC=y
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
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set
# CONFIG_NETFILTER_XT_CONNMARK is not set

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_CONNSECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
# CONFIG_NETFILTER_XT_TARGET_LED is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_HL is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_ADDRTYPE is not set
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_TTL is not set
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
# CONFIG_IP_NF_TARGET_LOG is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
# CONFIG_IP_NF_TARGET_NETMAP is not set
# CONFIG_IP_NF_TARGET_REDIRECT is not set
# CONFIG_NF_NAT_SNMP_BASIC is not set
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_SECURITY is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
# CONFIG_NF_CONNTRACK_IPV6 is not set
# CONFIG_IP6_NF_QUEUE is not set
CONFIG_IP6_NF_IPTABLES=m
# CONFIG_IP6_NF_MATCH_AH is not set
# CONFIG_IP6_NF_MATCH_EUI64 is not set
# CONFIG_IP6_NF_MATCH_FRAG is not set
# CONFIG_IP6_NF_MATCH_OPTS is not set
# CONFIG_IP6_NF_MATCH_HL is not set
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
# CONFIG_IP6_NF_MATCH_MH is not set
# CONFIG_IP6_NF_MATCH_RT is not set
# CONFIG_IP6_NF_TARGET_LOG is not set
CONFIG_IP6_NF_FILTER=m
# CONFIG_IP6_NF_TARGET_REJECT is not set
# CONFIG_IP6_NF_MANGLE is not set
# CONFIG_IP6_NF_RAW is not set
# CONFIG_IP6_NF_SECURITY is not set
CONFIG_BRIDGE_NF_EBTABLES=m
# CONFIG_BRIDGE_EBT_BROUTE is not set
# CONFIG_BRIDGE_EBT_T_FILTER is not set
CONFIG_BRIDGE_EBT_T_NAT=m
# CONFIG_BRIDGE_EBT_802_3 is not set
# CONFIG_BRIDGE_EBT_AMONG is not set
# CONFIG_BRIDGE_EBT_ARP is not set
# CONFIG_BRIDGE_EBT_IP is not set
# CONFIG_BRIDGE_EBT_IP6 is not set
# CONFIG_BRIDGE_EBT_LIMIT is not set
# CONFIG_BRIDGE_EBT_MARK is not set
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
# CONFIG_BRIDGE_EBT_STP is not set
# CONFIG_BRIDGE_EBT_VLAN is not set
# CONFIG_BRIDGE_EBT_ARPREPLY is not set
# CONFIG_BRIDGE_EBT_DNAT is not set
# CONFIG_BRIDGE_EBT_MARK_T is not set
# CONFIG_BRIDGE_EBT_REDIRECT is not set
# CONFIG_BRIDGE_EBT_SNAT is not set
# CONFIG_BRIDGE_EBT_LOG is not set
# CONFIG_BRIDGE_EBT_ULOG is not set
# CONFIG_BRIDGE_EBT_NFLOG is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_RPS=y
CONFIG_XPS=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
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
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
# CONFIG_AF_RXRPC is not set
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
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set

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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
CONFIG_SYS_HYPERVISOR=y
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=m
# CONFIG_MTD_DEBUG is not set
# CONFIG_MTD_TESTS is not set
# CONFIG_MTD_CONCAT is not set
CONFIG_MTD_PARTITIONS=y
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
# CONFIG_MTD_BLKDEVS is not set
# CONFIG_MTD_BLOCK is not set
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_PCMCIA is not set
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
# CONFIG_MTD_UBI_GLUEBI is not set

#
# UBI debugging options
#
# CONFIG_MTD_UBI_DEBUG is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_XEN_BLKDEV_FRONTEND is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085 is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
# CONFIG_IWMC3200TOP is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
CONFIG_SCSI_BNX2_ISCSI=m
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_PCMCIA_AHA152X is not set
# CONFIG_PCMCIA_FDOMAIN is not set
# CONFIG_PCMCIA_QLOGIC is not set
# CONFIG_PCMCIA_SYM53C500 is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
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
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
# CONFIG_FIREWIRE_SBP2 is not set
# CONFIG_FIREWIRE_NET is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_MII is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM63XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_PCMCIA_XIRCOM is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_KSZ884X_PCI is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=m
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
CONFIG_BNX2=m
CONFIG_CNIC=m
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_STMMAC_ETH is not set
# CONFIG_PCH_GBE is not set
CONFIG_NETDEV_10000=y
CONFIG_MDIO=m
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3_DEPENDS=y
# CONFIG_CHELSIO_T3 is not set
CONFIG_CHELSIO_T4_DEPENDS=y
# CONFIG_CHELSIO_T4 is not set
CONFIG_CHELSIO_T4VF_DEPENDS=y
# CONFIG_CHELSIO_T4VF is not set
# CONFIG_ENIC is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_BNA is not set
CONFIG_SFC=m
CONFIG_SFC_MTD=y
# CONFIG_BE2NET is not set
# CONFIG_TR is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
CONFIG_AIRO=m
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_AIRO_CS=m
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_ATH_COMMON is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
# CONFIG_HOSTAP_CS is not set
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
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEBUGFS=y
# CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
CONFIG_IWLAGN=m
CONFIG_IWL4965=y
CONFIG_IWL5000=y
# CONFIG_IWL3945 is not set
# CONFIG_IWM is not set
# CONFIG_LIBERTAS is not set
CONFIG_HERMES=m
# CONFIG_HERMES_PRISM is not set
CONFIG_HERMES_CACHE_FW_ON_INIT=y
# CONFIG_PLX_HERMES is not set
# CONFIG_TMD_HERMES is not set
# CONFIG_NORTEL_HERMES is not set
# CONFIG_PCMCIA_HERMES is not set
# CONFIG_PCMCIA_SPECTRUM is not set
# CONFIG_ORINOCO_USB is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
CONFIG_RTL8192CE=m
CONFIG_RTLWIFI=m
# CONFIG_WL1251 is not set
# CONFIG_WL12XX_MENU is not set
# CONFIG_ZD1211RW is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_IPHETH is not set
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_WAN is not set

#
# CAIF transport drivers
#
# CONFIG_XEN_NETDEV_FRONTEND is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_MPPE=m
# CONFIG_PPPOE is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m
CONFIG_NET_FC=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_VMXNET3 is not set
CONFIG_VBUS_ENET=y
# CONFIG_VBUS_ENET_DEBUG is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
# CONFIG_ISDN_CAPI is not set
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_HYSDN is not set
# CONFIG_MISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set
CONFIG_XEN_KBDDEV_FRONTEND=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_QT602240 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_STALDRV is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=y
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
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
# CONFIG_I2C_EG20T is not set

#
# External I2C/SMBus adapter drivers
#
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
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO expanders:
#
# CONFIG_GPIO_BASIC_MMIO is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ20Z75 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_CHARGER_GPIO is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_PKGTEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_LIS3_I2C is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
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
# CONFIG_SSB is not set
CONFIG_MFD_SUPPORT=y
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_RC_CORE=m
CONFIG_LIRC=m
# CONFIG_RC_MAP is not set
# CONFIG_IR_NEC_DECODER is not set
# CONFIG_IR_RC5_DECODER is not set
# CONFIG_IR_RC6_DECODER is not set
# CONFIG_IR_JVC_DECODER is not set
# CONFIG_IR_SONY_DECODER is not set
CONFIG_IR_RC5_SZ_DECODER=m
# CONFIG_IR_LIRC_CODEC is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_RC_LOOPBACK is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMISE=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
# CONFIG_MEDIA_TUNER_TDA8290 is not set
# CONFIG_MEDIA_TUNER_TDA827X is not set
# CONFIG_MEDIA_TUNER_TDA18271 is not set
# CONFIG_MEDIA_TUNER_TDA9887 is not set
# CONFIG_MEDIA_TUNER_TEA5761 is not set
# CONFIG_MEDIA_TUNER_TEA5767 is not set
# CONFIG_MEDIA_TUNER_MT20XX is not set
# CONFIG_MEDIA_TUNER_MT2060 is not set
# CONFIG_MEDIA_TUNER_MT2266 is not set
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
# CONFIG_MEDIA_TUNER_XC2028 is not set
# CONFIG_MEDIA_TUNER_XC5000 is not set
# CONFIG_MEDIA_TUNER_MXL5005S is not set
# CONFIG_MEDIA_TUNER_MXL5007T is not set
# CONFIG_MEDIA_TUNER_MC44S803 is not set
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TDA9875 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
# CONFIG_VIDEO_TLV320AIC23B is not set
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
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_TCM825X is not set
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
# CONFIG_VIDEO_SAA7191 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_CX25840=m

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_THS7303 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_AK881X is not set

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_ZORAN is not set
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_RC=y
# CONFIG_VIDEO_SAA7134_DVB is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_TIMBERDALE is not set
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
# CONFIG_VIDEO_CX88_BLACKBIRD is not set
# CONFIG_VIDEO_CX88_DVB is not set
CONFIG_VIDEO_CX23885=m
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_IVTV=m
# CONFIG_VIDEO_FB_IVTV is not set
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CX18_ALSA=m
CONFIG_VIDEO_SAA7164=m
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_VIA_CAMERA is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
# CONFIG_USB_GSPCA is not set
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
# CONFIG_VIDEO_EM28XX is not set
CONFIG_VIDEO_TLG2300=m
CONFIG_VIDEO_CX231XX=m
# CONFIG_VIDEO_CX231XX_RC is not set
CONFIG_VIDEO_CX231XX_ALSA=m
# CONFIG_VIDEO_CX231XX_DVB is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
# CONFIG_VIDEO_MEM2MEM_TESTDEV is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_GEMTEK_PCI is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
# CONFIG_I2C_SI4713 is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_DSBR is not set
CONFIG_RADIO_SI470X=y
# CONFIG_USB_SI470X is not set
# CONFIG_I2C_SI470X is not set
# CONFIG_USB_MR800 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_TTPCI_EEPROM is not set
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_SMS_SIANO_MDTV is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

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
# CONFIG_DVB_DM1105 is not set
# CONFIG_DVB_FIREDTV is not set

#
# Supported Earthsoft PT1 Adapters
#
# CONFIG_DVB_PT1 is not set

#
# Supported Mantis Adapters
#
# CONFIG_MANTIS_CORE is not set

#
# Supported nGene Adapters
#
# CONFIG_DVB_NGENE is not set

#
# Supported DVB Frontends
#
CONFIG_DVB_FE_CUSTOMISE=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
# CONFIG_DVB_STB0899 is not set
# CONFIG_DVB_STB6100 is not set
# CONFIG_DVB_STV090x is not set
# CONFIG_DVB_STV6110x is not set

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
# CONFIG_DVB_CX24123 is not set
# CONFIG_DVB_MT312 is not set
# CONFIG_DVB_ZL10036 is not set
# CONFIG_DVB_ZL10039 is not set
# CONFIG_DVB_S5H1420 is not set
# CONFIG_DVB_STV0288 is not set
# CONFIG_DVB_STB6000 is not set
# CONFIG_DVB_STV0299 is not set
# CONFIG_DVB_STV6110 is not set
# CONFIG_DVB_STV0900 is not set
# CONFIG_DVB_TDA8083 is not set
# CONFIG_DVB_TDA10086 is not set
# CONFIG_DVB_TDA8261 is not set
# CONFIG_DVB_VES1X93 is not set
# CONFIG_DVB_TUNER_ITD1000 is not set
# CONFIG_DVB_TUNER_CX24113 is not set
# CONFIG_DVB_TDA826X is not set
# CONFIG_DVB_TUA6100 is not set
# CONFIG_DVB_CX24116 is not set
# CONFIG_DVB_SI21XX is not set
# CONFIG_DVB_DS3000 is not set
# CONFIG_DVB_MB86A16 is not set

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
# CONFIG_DVB_CX22700 is not set
# CONFIG_DVB_CX22702 is not set
CONFIG_DVB_S5H1432=m
# CONFIG_DVB_DRX397XD is not set
# CONFIG_DVB_L64781 is not set
CONFIG_DVB_TDA1004X=m
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
# CONFIG_DVB_ZL10353 is not set
# CONFIG_DVB_DIB3000MB is not set
# CONFIG_DVB_DIB3000MC is not set
# CONFIG_DVB_DIB7000M is not set
# CONFIG_DVB_DIB7000P is not set
# CONFIG_DVB_TDA10048 is not set
# CONFIG_DVB_AF9013 is not set
# CONFIG_DVB_EC100 is not set

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
# CONFIG_DVB_TDA10021 is not set
# CONFIG_DVB_TDA10023 is not set
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
# CONFIG_DVB_OR51211 is not set
# CONFIG_DVB_OR51132 is not set
# CONFIG_DVB_BCM3510 is not set
# CONFIG_DVB_LGDT330X is not set
# CONFIG_DVB_LGDT3305 is not set
# CONFIG_DVB_S5H1409 is not set
# CONFIG_DVB_AU8522 is not set
# CONFIG_DVB_S5H1411 is not set

#
# ISDB-T (terrestrial) frontends
#
# CONFIG_DVB_S921 is not set
# CONFIG_DVB_DIB8000 is not set
# CONFIG_DVB_MB86A20S is not set

#
# Digital terrestrial only tuners/PLL
#
# CONFIG_DVB_PLL is not set
# CONFIG_DVB_TUNER_DIB0070 is not set
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_LNBP21 is not set
# CONFIG_DVB_ISL6405 is not set
# CONFIG_DVB_ISL6421 is not set
# CONFIG_DVB_ISL6423 is not set
# CONFIG_DVB_LGS8GL5 is not set
# CONFIG_DVB_LGS8GXX is not set
# CONFIG_DVB_ATBM8830 is not set
# CONFIG_DVB_TDA665x is not set
# CONFIG_DVB_IX2505V is not set

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set
CONFIG_DAB=y
# CONFIG_USB_DABUSB is not set

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
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_TTM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_KMS=y
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_STUB_POULSBO is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
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
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
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
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
# CONFIG_FB_MATROX_MAVEN is not set
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
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_XEN_FBDEV_FRONTEND=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
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
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_PCM_XRUN_DEBUG=y
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
# CONFIG_SND_ALOOP is not set
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=m
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
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_FM801=m
CONFIG_SND_FM801_TEA575X_BOOL=y
CONFIG_SND_FM801_TEA575X=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=0
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
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
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
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
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=m
CONFIG_SND_PDAUDIOCF=m
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_3M_PCT=y
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
# CONFIG_HID_CANDO is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_EGALAX is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWII_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MOSART=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_QUANTA=y
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_ROCCAT_KONEPLUS is not set
# CONFIG_HID_ROCCAT_PYRA is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
CONFIG_HID_STANTUM=y
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
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
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_UAS is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_UWB=m
# CONFIG_UWB_HWA is not set
# CONFIG_UWB_WHCI is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SDRICOH_CS=m
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_USHC=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_DECODE_MCE is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_MCE=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I7CORE=m
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
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
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
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

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
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
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SCRUB_PAGES=y
# CONFIG_XEN_DEV_EVTCHN is not set
CONFIG_XEN_BACKEND=y
# CONFIG_XEN_PCIDEV_BACKEND is not set
# CONFIG_XENFS is not set
CONFIG_XEN_SYS_HYPERVISOR=y
# CONFIG_XEN_GNTDEV is not set
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_PLATFORM_PCI is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_STAGING=y
# CONFIG_STAGING_EXCLUDE_BUILD is not set
CONFIG_BKL=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_VIDEO_GO7007 is not set
# CONFIG_VIDEO_CX25821 is not set
# CONFIG_VIDEO_TM6000 is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_USB_IP_COMMON is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_BRCM80211 is not set
# CONFIG_RT2860 is not set
# CONFIG_RT2870 is not set
# CONFIG_COMEDI is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTL8192E is not set
# CONFIG_R8712U is not set
# CONFIG_TRANZPORT is not set
# CONFIG_POHMELFS is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_LINE6_USB is not set
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_NOUVEAU=m
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_NOUVEAU_DEBUG=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_UDL is not set
# CONFIG_HYPERV is not set
# CONFIG_VME_BUS is not set
# CONFIG_DX_SEP is not set
# CONFIG_IIO is not set
# CONFIG_ZRAM is not set
# CONFIG_WLAGS49_H2 is not set
# CONFIG_WLAGS49_H25 is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_VIDEO_DT3155 is not set
# CONFIG_CRYSTALHD is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_ST_BT is not set
# CONFIG_FB_XGI is not set
CONFIG_LIRC_STAGING=y
# CONFIG_LIRC_BT829 is not set
# CONFIG_LIRC_I2C is not set
# CONFIG_LIRC_IGORPLUGUSB is not set
# CONFIG_LIRC_IMON is not set
# CONFIG_LIRC_IT87 is not set
# CONFIG_LIRC_ITE8709 is not set
# CONFIG_LIRC_SASEM is not set
# CONFIG_LIRC_SERIAL is not set
# CONFIG_LIRC_SIR is not set
# CONFIG_LIRC_TTUSBIR is not set
# CONFIG_LIRC_ZILOG is not set
# CONFIG_SMB_FS is not set
# CONFIG_EASYCAP is not set
# CONFIG_SOLO6X10 is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_MACH_NO_WESTBRIDGE=y
# CONFIG_ATH6K_LEGACY is not set
# CONFIG_USB_ENESTORAGE is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_EEEPC_WMI is not set
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=m
# CONFIG_IBM_RTL is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_EXPORTFS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

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
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=m
CONFIG_UBIFS_FS_XATTR=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_UBIFS_FS_DEBUG is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
CONFIG_PNFS_FILE_LAYOUT=m
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
CONFIG_NFSD=m
CONFIG_NFSD_DEPRECATED=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_CEPH_FS=m
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
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
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
CONFIG_KGDB_LOW_LEVEL_TRAP=y
CONFIG_KGDB_KDB=y
CONFIG_KDB_KEYBOARD=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
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
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_IMA_LSM_RULES=y
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
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
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
# CONFIG_VHOST_NET is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y
CONFIG_AVERAGE=y
CONFIG_SHM_SIGNAL=y
CONFIG_IOQ=y

--=-=-=

-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child

--=-=-=--
