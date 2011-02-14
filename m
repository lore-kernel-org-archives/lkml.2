Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab1BNPho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:37:44 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:48345 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab1BNPhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:37:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Riesen <raa.lkml@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<m1hbce46fw.fsf@fess.ebiederm.org>
	<AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
	<m1bp2ly41q.fsf@fess.ebiederm.org>
	<AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
	<AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
	<AANLkTinjsimbe6-YgcSK0-zqDuoZ=8xCReHnKZoG4GU9@mail.gmail.com>
	<m14o87wev8.fsf@fess.ebiederm.org>
	<AANLkTimO3h80Wk44OhpfkjzxpzdDKnf6emj2fNObn_jD@mail.gmail.com>
	<m1r5bbthan.fsf@fess.ebiederm.org> <m1fwrrtc0m.fsf@fess.ebiederm.org>
Date: Mon, 14 Feb 2011 07:37:29 -0800
In-Reply-To: <m1fwrrtc0m.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Sun, 13 Feb 2011 21:34:33 -0800")
Message-ID: <m139nqsk3q.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19KONt62tbPT54XJlrLSx5DJ9Y8iMNl+Ak=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Message bigger than SAmaxbody (256000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=


795abaf1e4e188c4171e3cd3dbb11a9fcacaf505  is not fairing too well.

The Bad PMDs may be happening more frequently but the oops that killed
me was a NULL pointer dereference in acct_collect this time.  Ugh.

My last two reboot records from last.
reboot   system boot  2.6.38-rc4-35764 Mon Feb 14 04:38 - 07:25  (02:47)    
reboot   system boot  2.6.38-rc4-35764 Sun Feb 13 21:27 - 07:25  (09:58)    
What was that 5 hours the kernel lasted before it died?

The entire dmesg is attached.

I am going to attempt to enable some debugging and see if that flushes
anything out.

Eric


--=-=-=
Content-Disposition: inline;
 filename*=us-ascii''dmesg-bs38-2011-02-14-12%3a26%3a46

<6>Initializing cgroup subsys cpuset
<6>Initializing cgroup subsys cpu
<5>Linux version 2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 (arastra@local19.aristanetworks.com) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #1 SMP Sun Feb 13 18:25:40 PST 2011
<6>Command line: ro root=LABEL=/ rhgb quiet crashkernel=128M rd_NO_PLYMOUTH console=tty0 console=ttyS0,9600 LANG=en_US.UTF-8
<6>BIOS-provided physical RAM map:
<6> BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
<6> BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
<6> BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
<6> BIOS-e820: 0000000000100000 - 00000000cfef0000 (usable)
<6> BIOS-e820: 00000000cfef0000 - 00000000cff04000 (ACPI data)
<6> BIOS-e820: 00000000cff04000 - 00000000cff05000 (ACPI NVS)
<6> BIOS-e820: 00000000cff05000 - 00000000d0000000 (reserved)
<6> BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
<6> BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
<6> BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
<6> BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
<6> BIOS-e820: 0000000100000000 - 00000002b0000000 (usable)
<6>NX (Execute Disable) protection: active
<6>DMI present.
<7>DMI: X7DWU/X7DWU, BIOS  1.2 11/04/2008
<7>e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
<7>e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
<6>No AGP bridge found
<6>last_pfn = 0x2b0000 max_arch_pfn = 0x400000000
<7>MTRR default type: uncachable
<7>MTRR fixed ranges enabled:
<7>  00000-9FFFF write-back
<7>  A0000-BFFFF uncachable
<7>  C0000-CFFFF write-protect
<7>  D0000-E3FFF uncachable
<7>  E4000-FFFFF write-protect
<7>MTRR variable ranges enabled:
<7>  0 base 00D0000000 mask 3FF0000000 uncachable
<7>  1 base 00E0000000 mask 3FE0000000 uncachable
<7>  2 base 0000000000 mask 3E00000000 write-back
<7>  3 base 0200000000 mask 3F80000000 write-back
<7>  4 base 0280000000 mask 3FE0000000 write-back
<7>  5 base 02A0000000 mask 3FF0000000 write-back
<7>  6 base 00CFF80000 mask 3FFFF80000 uncachable
<7>  7 disabled
<6>x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
<7>e820 update range: 00000000cff80000 - 0000000100000000 (usable) ==> (reserved)
<6>last_pfn = 0xcfef0 max_arch_pfn = 0x400000000
<6>found SMP MP-table at [ffff8800000f68b0] f68b0
<7>initial memory mapped : 0 - 20000000
<6>init_memory_mapping: 0000000000000000-00000000cfef0000
<7> 0000000000 - 00cfe00000 page 2M
<7> 00cfe00000 - 00cfef0000 page 4k
<7>kernel direct mapping tables up to cfef0000 @ 1fffa000-20000000
<6>init_memory_mapping: 0000000100000000-00000002b0000000
<7> 0100000000 - 02b0000000 page 2M
<7>kernel direct mapping tables up to 2b0000000 @ cfee4000-cfef0000
<6>RAMDISK: 36e6f000 - 37ff0000
<6>Reserving 128MB of memory at 736MB for crashkernel (System RAM: 11008MB)
<4>ACPI: RSDP 00000000000f6880 00024 (v02 PTLTD )
<4>ACPI: XSDT 00000000cfefcef6 000D4 (v01 PTLTD  ? XSDT   06040000  LTP 00000000)
<4>ACPI: FACP 00000000cff033a8 000F4 (v03 INTEL  STOAKLEY 06040000 PTL  00000003)
<4>ACPI: DSDT 00000000cfefeab8 0487C (v01  Intel SEABURG  06040000 MSFT 03000001)
<4>ACPI: FACS 00000000cff04fc0 00040
<4>ACPI: _MAR 00000000cff0349c 00030 (v01 Intel  OEMDMAR  06040000 LOHR 00000001)
<4>ACPI: TCPA 00000000cff034cc 00032 (v01 Intel  STOAKLEY 06040000 LOHR 0000005A)
<4>ACPI: APIC 00000000cff034fe 000C8 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
<4>ACPI: MCFG 00000000cff035c6 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
<4>ACPI: HPET 00000000cff03602 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
<4>ACPI: BOOT 00000000cff0363a 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
<4>ACPI: SPCR 00000000cff03662 00050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
<4>ACPI: ERST 00000000cff036b2 00590 (v01 SMCI   ERSTTBL  06040000 SMCI 00000001)
<4>ACPI: HEST 00000000cff03c42 000A8 (v01 SMCI   HESTTBL  06040000 SMCI 00000001)
<4>ACPI: BERT 00000000cff03cea 00030 (v01 SMCI   BERTTBL  06040000 SMCI 00000001)
<4>ACPI: EINJ 00000000cff03d1a 00170 (v01 SMCI   EINJTBL  06040000 SMCI 00000001)
<4>ACPI: SLIC 00000000cff03e8a 00176 (v01 OEM_ID OEMTABLE 06040000  LTP 00000000)
<4>ACPI: SSDT 00000000cfefe859 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050228)
<4>ACPI: SSDT 00000000cfefe7b3 000A6 (v01  PmRef  Cpu7Tst 00003000 INTL 20050228)
<4>ACPI: SSDT 00000000cfefe70d 000A6 (v01  PmRef  Cpu6Tst 00003000 INTL 20050228)
<4>ACPI: SSDT 00000000cfefe667 000A6 (v01  PmRef  Cpu5Tst 00003000 INTL 20050228)
<4>ACPI: SSDT 00000000cfefe5c1 000A6 (v01  PmRef  Cpu4Tst 00003000 INTL 20050228)
<4>ACPI: SSDT 00000000cfefe51b 000A6 (v01  PmRef  Cpu3Tst 00003000 INTL 20050228)
<4>ACPI: SSDT 00000000cfefe475 000A6 (v01  PmRef  Cpu2Tst 00003000 INTL 20050228)
<4>ACPI: SSDT 00000000cfefe3cf 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050228)
<4>ACPI: SSDT 00000000cfefcfca 01405 (v01  PmRef    CpuPm 00003000 INTL 20050228)
<7>ACPI: Local APIC address 0xfee00000
<6>No NUMA configuration found
<6>Faking a node at 0000000000000000-00000002b0000000
<6>Initmem setup node 0 0000000000000000-00000002b0000000
<6>  NODE_DATA [00000002affec000 - 00000002afffffff]
<7> [ffffea0000000000-ffffea00097fffff] PMD -> [ffff8802a5e00000-ffff8802aebfffff] on node 0
<4>Zone PFN ranges:
<4>  DMA      0x00000010 -> 0x00001000
<4>  DMA32    0x00001000 -> 0x00100000
<4>  Normal   0x00100000 -> 0x002b0000
<4>Movable zone start PFN for each node
<4>early_node_map[3] active PFN ranges
<4>    0: 0x00000010 -> 0x0000009d
<4>    0: 0x00000100 -> 0x000cfef0
<4>    0: 0x00100000 -> 0x002b0000
<7>On node 0 totalpages: 2621053
<7>  DMA zone: 56 pages used for memmap
<7>  DMA zone: 6 pages reserved
<7>  DMA zone: 3919 pages, LIFO batch:0
<7>  DMA32 zone: 14280 pages used for memmap
<7>  DMA32 zone: 833320 pages, LIFO batch:31
<7>  Normal zone: 24192 pages used for memmap
<7>  Normal zone: 1745280 pages, LIFO batch:31
<6>ACPI: PM-Timer IO Port: 0x1008
<7>ACPI: Local APIC address 0xfee00000
<6>ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<6>ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
<6>ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
<6>ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
<6>ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
<6>ACPI: LAPIC (acpi_id[0x05] lapic_id[0x06] enabled)
<6>ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
<6>ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
<6>ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
<6>ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
<6>ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
<6>ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
<6>ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
<6>ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
<6>ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
<6>ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
<6>ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
<6>IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
<6>ACPI: IOAPIC (id[0x09] address[0xfec89000] gsi_base[24])
<6>IOAPIC[1]: apic_id 9, version 32, address 0xfec89000, GSI 24-47
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<7>ACPI: IRQ0 used by override.
<7>ACPI: IRQ2 used by override.
<7>ACPI: IRQ9 used by override.
<6>Using ACPI (MADT) for SMP configuration information
<6>ACPI: HPET id: 0x8086a201 base: 0xfed00000
<6>SMP: Allowing 8 CPUs, 0 hotplug CPUs
<7>nr_irqs_gsi: 64
<6>PM: Registered nosave memory: 000000000009d000 - 000000000009e000
<6>PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
<6>PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
<6>PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
<6>PM: Registered nosave memory: 00000000cfef0000 - 00000000cff04000
<6>PM: Registered nosave memory: 00000000cff04000 - 00000000cff05000
<6>PM: Registered nosave memory: 00000000cff05000 - 00000000d0000000
<6>PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
<6>PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
<6>PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
<6>PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
<6>PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
<6>PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
<6>PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
<6>PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
<6>Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
<6>Booting paravirtualized kernel on bare hardware
<6>setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
<6>PERCPU: Embedded 26 pages/cpu @ffff8800cfc00000 s74944 r8192 d23360 u262144
<7>pcpu-alloc: s74944 r8192 d23360 u262144 alloc=1*2097152
<7>pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
<4>Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2582519
<4>Policy zone: Normal
<5>Kernel command line: ro root=LABEL=/ rhgb quiet crashkernel=128M rd_NO_PLYMOUTH console=tty0 console=ttyS0,9600 LANG=en_US.UTF-8
<6>PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>Checking aperture...
<6>No AGP bridge found
<7>Calgary: detecting Calgary via BIOS EBDA area
<7>Calgary: Unable to locate Rio Grande table in EBDA - bailing!
<6>Memory: 10109856k/11272192k available (3940k kernel code, 787980k absent, 374356k reserved, 4719k data, 1276k init)
<6>SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
<6>Hierarchical RCU implementation.
<6>	RCU-based detection of stalled CPUs is disabled.
<6>NR_IRQS:4352 nr_irqs:1152 16
<6>Extended CMOS year: 2000
<4>Console: colour VGA+ 80x25
<6>console [tty0] enabled
<6>console [ttyS0] enabled
<6>allocated 104857600 bytes of page_cgroup
<6>please try 'cgroup_disable=memory' option if you don't want memory cgroups
<7>hpet clockevent registered
<4>Fast TSC calibration using PIT
<4>Detected 2500.305 MHz processor.
<6>Calibrating delay loop (skipped), value calculated using timer frequency.. 5000.61 BogoMIPS (lpj=10001220)
<6>pid_max: default: 32768 minimum: 301
<6>Security Framework initialized
<6>Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
<6>Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
<4>Mount-cache hash table entries: 256
<6>Initializing cgroup subsys cpuacct
<6>Initializing cgroup subsys memory
<6>Initializing cgroup subsys devices
<6>Initializing cgroup subsys freezer
<6>Initializing cgroup subsys blkio
<6>CPU: Physical Processor ID: 0
<6>CPU: Processor Core ID: 0
<6>mce: CPU supports 6 MCE banks
<6>CPU0: Thermal monitoring enabled (TM2)
<6>using mwait in idle threads.
<6>ACPI: Core revision 20110112
<6>Setting APIC routing to flat
<6>..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>CPU0: Intel(R) Xeon(R) CPU           E5420  @ 2.50GHz stepping 06
<6>Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
<6>... version:                2
<6>... bit width:              40
<6>... generic registers:      2
<6>... value mask:             000000ffffffffff
<6>... max period:             000000007fffffff
<6>... fixed-purpose events:   3
<6>... event mask:             0000000700000003
<6>NMI watchdog enabled, takes one hw-pmu counter.
<6>Booting Node   0, Processors  #1
<6>NMI watchdog enabled, takes one hw-pmu counter.
<4> #2
<6>NMI watchdog enabled, takes one hw-pmu counter.
<4> #3
<6>NMI watchdog enabled, takes one hw-pmu counter.
<4> #4
<6>NMI watchdog enabled, takes one hw-pmu counter.
<4> #5
<6>NMI watchdog enabled, takes one hw-pmu counter.
<4> #6
<6>NMI watchdog enabled, takes one hw-pmu counter.
<4> #7 Ok.
<6>NMI watchdog enabled, takes one hw-pmu counter.
<6>Brought up 8 CPUs
<6>Total of 8 processors activated (40002.02 BogoMIPS).
<6>NET: Registered protocol family 16
<6>ACPI: bus type pci registered
<6>PCI: MMCONFIG for domain 0000 [bus 00-09] at [mem 0xe0000000-0xe09fffff] (base 0xe0000000)
<6>PCI: MMCONFIG at [mem 0xe0000000-0xe09fffff] reserved in E820
<6>PCI: Using configuration type 1 for base access
<4>bio: create slab <bio-0> at 0
<7>ACPI: EC: Look up EC in DSDT
<7>\_SB_:_OSC evaluation returned wrong type
<7>_OSC request data:1 7 
<6>ACPI: Interpreter enabled
<6>ACPI: (supports S0 S1 S4 S5)
<6>ACPI: Using IOAPIC for interrupt routing
<6>ACPI: No dock devices found.
<6>HEST: Table parsing has been initialized.
<6>PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
<6>ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
<6>pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
<6>pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
<6>pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
<6>pci_root PNP0A03:00: host bridge window [mem 0x000cc000-0x000cffff]
<6>pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000d3fff]
<6>pci_root PNP0A03:00: host bridge window [mem 0x000d4000-0x000d7fff]
<6>pci_root PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff]
<6>pci_root PNP0A03:00: host bridge window [mem 0x000dc000-0x000dffff]
<6>pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xfebfffff]
<7>pci 0000:00:00.0: [8086:4003] type 0 class 0x000600
<7>pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
<7>pci 0000:00:00.0: PME# disabled
<7>pci 0000:00:01.0: [8086:4021] type 1 class 0x000604
<7>pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
<7>pci 0000:00:01.0: PME# disabled
<7>pci 0000:00:03.0: [8086:4023] type 1 class 0x000604
<7>pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
<7>pci 0000:00:03.0: PME# disabled
<7>pci 0000:00:05.0: [8086:4025] type 1 class 0x000604
<7>pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
<7>pci 0000:00:05.0: PME# disabled
<7>pci 0000:00:07.0: [8086:4027] type 1 class 0x000604
<7>pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
<7>pci 0000:00:07.0: PME# disabled
<7>pci 0000:00:09.0: [8086:4029] type 1 class 0x000604
<7>pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
<7>pci 0000:00:09.0: PME# disabled
<7>pci 0000:00:0f.0: [8086:402f] type 0 class 0x000880
<7>pci 0000:00:0f.0: reg 10: [mem 0xfe700000-0xfe703fff 64bit]
<7>pci 0000:00:10.0: [8086:4030] type 0 class 0x000600
<7>pci 0000:00:10.1: [8086:4030] type 0 class 0x000600
<7>pci 0000:00:10.2: [8086:4030] type 0 class 0x000600
<7>pci 0000:00:10.3: [8086:4030] type 0 class 0x000600
<7>pci 0000:00:10.4: [8086:4030] type 0 class 0x000600
<7>pci 0000:00:11.0: [8086:4031] type 0 class 0x000600
<7>pci 0000:00:15.0: [8086:4035] type 0 class 0x000600
<7>pci 0000:00:15.1: [8086:4035] type 0 class 0x000600
<7>pci 0000:00:16.0: [8086:4036] type 0 class 0x000600
<7>pci 0000:00:16.1: [8086:4036] type 0 class 0x000600
<7>pci 0000:00:1d.0: [8086:2688] type 0 class 0x000c03
<7>pci 0000:00:1d.0: reg 20: [io  0x1800-0x181f]
<7>pci 0000:00:1d.1: [8086:2689] type 0 class 0x000c03
<7>pci 0000:00:1d.1: reg 20: [io  0x1820-0x183f]
<7>pci 0000:00:1d.2: [8086:268a] type 0 class 0x000c03
<7>pci 0000:00:1d.2: reg 20: [io  0x1840-0x185f]
<7>pci 0000:00:1d.3: [8086:268b] type 0 class 0x000c03
<7>pci 0000:00:1d.3: reg 20: [io  0x1860-0x187f]
<7>pci 0000:00:1d.7: [8086:268c] type 0 class 0x000c03
<7>pci 0000:00:1d.7: reg 10: [mem 0xdc904000-0xdc9043ff]
<7>pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
<7>pci 0000:00:1d.7: PME# disabled
<7>pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
<7>pci 0000:00:1f.0: [8086:2670] type 0 class 0x000601
<7>pci 0000:00:1f.1: [8086:269e] type 0 class 0x000101
<7>pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
<7>pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
<7>pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
<7>pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
<7>pci 0000:00:1f.1: reg 20: [io  0x1880-0x188f]
<7>pci 0000:00:1f.2: [8086:2680] type 0 class 0x000101
<7>pci 0000:00:1f.2: reg 10: [io  0x18c0-0x18c7]
<7>pci 0000:00:1f.2: reg 14: [io  0x18b8-0x18bb]
<7>pci 0000:00:1f.2: reg 18: [io  0x18b0-0x18b7]
<7>pci 0000:00:1f.2: reg 1c: [io  0x1894-0x1897]
<7>pci 0000:00:1f.2: reg 20: [io  0x18a0-0x18af]
<7>pci 0000:00:1f.2: reg 24: [mem 0xdc904400-0xdc9047ff]
<7>pci 0000:00:1f.2: PME# supported from D3hot
<7>pci 0000:00:1f.2: PME# disabled
<7>pci 0000:00:1f.3: [8086:269b] type 0 class 0x000c05
<7>pci 0000:00:1f.3: reg 20: [io  0x1100-0x111f]
<6>pci 0000:00:01.0: PCI bridge to [bus 01-01]
<7>pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
<7>pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
<7>pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<7>pci 0000:02:00.0: [8086:3500] type 1 class 0x000604
<7>pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
<7>pci 0000:02:00.0: PME# disabled
<7>pci 0000:02:00.3: [8086:350c] type 1 class 0x000604
<7>pci 0000:02:00.3: PME# supported from D0 D3hot D3cold
<7>pci 0000:02:00.3: PME# disabled
<6>pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
<6>pci 0000:00:03.0: PCI bridge to [bus 02-05]
<7>pci 0000:00:03.0:   bridge window [io  0xf000-0x0000] (disabled)
<7>pci 0000:00:03.0:   bridge window [mem 0xdc500000-0xdc5fffff]
<7>pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<7>pci 0000:03:00.0: [8086:3510] type 1 class 0x000604
<7>pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
<7>pci 0000:03:00.0: PME# disabled
<6>pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
<6>pci 0000:02:00.0: PCI bridge to [bus 03-04]
<7>pci 0000:02:00.0:   bridge window [io  0xf000-0x0000] (disabled)
<7>pci 0000:02:00.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
<7>pci 0000:02:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<6>pci 0000:03:00.0: PCI bridge to [bus 04-04]
<7>pci 0000:03:00.0:   bridge window [io  0xf000-0x0000] (disabled)
<7>pci 0000:03:00.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
<7>pci 0000:03:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<6>pci 0000:02:00.3: PCI bridge to [bus 05-05]
<7>pci 0000:02:00.3:   bridge window [io  0xf000-0x0000] (disabled)
<7>pci 0000:02:00.3:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
<7>pci 0000:02:00.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<7>pci 0000:06:00.0: [4040:0100] type 0 class 0x000200
<7>pci 0000:06:00.0: reg 10: [mem 0xdc000000-0xdc1fffff 64bit]
<7>pci 0000:06:00.0: reg 20: [mem 0xd8000000-0xd9ffffff 64bit]
<7>pci 0000:06:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
<7>pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
<7>pci 0000:06:00.0: PME# disabled
<7>pci 0000:06:00.1: [4040:0100] type 0 class 0x000200
<7>pci 0000:06:00.1: reg 10: [mem 0xdc200000-0xdc3fffff 64bit]
<7>pci 0000:06:00.1: reg 20: [mem 0xda000000-0xdbffffff 64bit]
<7>pci 0000:06:00.1: PME# supported from D0 D3hot D3cold
<7>pci 0000:06:00.1: PME# disabled
<6>pci 0000:00:05.0: PCI bridge to [bus 06-06]
<7>pci 0000:00:05.0:   bridge window [io  0xf000-0x0000] (disabled)
<7>pci 0000:00:05.0:   bridge window [mem 0xd8000000-0xdc3fffff]
<7>pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<6>pci 0000:00:07.0: PCI bridge to [bus 07-07]
<7>pci 0000:00:07.0:   bridge window [io  0xf000-0x0000] (disabled)
<7>pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
<7>pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<7>pci 0000:08:00.0: [8086:10a7] type 0 class 0x000200
<7>pci 0000:08:00.0: reg 10: [mem 0xdc420000-0xdc43ffff]
<7>pci 0000:08:00.0: reg 14: [mem 0xdc400000-0xdc41ffff]
<7>pci 0000:08:00.0: reg 18: [io  0x2000-0x201f]
<7>pci 0000:08:00.0: reg 1c: [mem 0xdc480000-0xdc483fff]
<7>pci 0000:08:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
<7>pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
<7>pci 0000:08:00.0: PME# disabled
<7>pci 0000:08:00.1: [8086:10a7] type 0 class 0x000200
<7>pci 0000:08:00.1: reg 10: [mem 0xdc460000-0xdc47ffff]
<7>pci 0000:08:00.1: reg 14: [mem 0xdc440000-0xdc45ffff]
<7>pci 0000:08:00.1: reg 18: [io  0x2020-0x203f]
<7>pci 0000:08:00.1: reg 1c: [mem 0xdc484000-0xdc487fff]
<7>pci 0000:08:00.1: reg 30: [mem 0x00000000-0x0001ffff pref]
<7>pci 0000:08:00.1: PME# supported from D0 D3hot D3cold
<7>pci 0000:08:00.1: PME# disabled
<6>pci 0000:00:09.0: PCI bridge to [bus 08-08]
<7>pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
<7>pci 0000:00:09.0:   bridge window [mem 0xdc400000-0xdc4fffff]
<7>pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<7>pci 0000:09:01.0: [1002:515e] type 0 class 0x000300
<7>pci 0000:09:01.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
<7>pci 0000:09:01.0: reg 14: [io  0x3000-0x30ff]
<7>pci 0000:09:01.0: reg 18: [mem 0xdc600000-0xdc60ffff]
<7>pci 0000:09:01.0: reg 30: [mem 0x00000000-0x0001ffff pref]
<7>pci 0000:09:01.0: supports D1 D2
<6>pci 0000:00:1e.0: PCI bridge to [bus 09-09] (subtractive decode)
<7>pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
<7>pci 0000:00:1e.0:   bridge window [mem 0xdc600000-0xdc6fffff]
<7>pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
<7>pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
<7>pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
<7>pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
<7>pci 0000:00:1e.0:   bridge window [mem 0x000cc000-0x000cffff] (subtractive decode)
<7>pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
<7>pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
<7>pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
<7>pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
<7>pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xfebfffff] (subtractive decode)
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3.BMF0._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3.BMF0.BPD0._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
<6> pci0000:00: Requesting ACPI _OSC control (0x1d)
<6>ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 14 15)
<6>ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 14 15)
<6>ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 14 15)
<6>ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
<6>ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 14 15)
<6>ACPI: PCI Interrupt Link [LNKF] (IRQs 4 *5 6 7 10 11 14 15)
<6>ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 14 15)
<6>ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 *11 14 15)
<6>vgaarb: device added: PCI:0000:09:01.0,decodes=io+mem,owns=io+mem,locks=none
<6>vgaarb: loaded
<5>SCSI subsystem initialized
<7>libata version 3.00 loaded.
<6>usbcore: registered new interface driver usbfs
<6>usbcore: registered new interface driver hub
<6>usbcore: registered new device driver usb
<6>PCI: Using ACPI for IRQ routing
<7>PCI: pci_cache_line_size set to 64 bytes
<7>reserve RAM buffer: 000000000009dc00 - 000000000009ffff 
<7>reserve RAM buffer: 00000000cfef0000 - 00000000cfffffff 
<6>NetLabel: Initializing
<6>NetLabel:  domain hash size = 128
<6>NetLabel:  protocols = UNLABELED CIPSOv4
<6>NetLabel:  unlabeled traffic allowed by default
<6>HPET: 3 timers in total, 0 timers will be used for per-cpu timer
<6>hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
<6>hpet0: 3 comparators, 64-bit 14.318180 MHz counter
<6>Switching to clocksource hpet
<6>pnp: PnP ACPI init
<6>ACPI: bus type pnp registered
<7>pnp 00:00: [bus 00-ff]
<7>pnp 00:00: [io  0x0000-0x0cf7 window]
<7>pnp 00:00: [io  0x0cf8-0x0cff]
<7>pnp 00:00: [io  0x0d00-0xffff window]
<7>pnp 00:00: [mem 0x000a0000-0x000bffff window]
<7>pnp 00:00: [mem 0x000c0000-0x000c3fff window]
<7>pnp 00:00: [mem 0x000c4000-0x000c7fff window]
<7>pnp 00:00: [mem 0x000c8000-0x000cbfff window]
<7>pnp 00:00: [mem 0x000cc000-0x000cffff window]
<7>pnp 00:00: [mem 0x000d0000-0x000d3fff window]
<7>pnp 00:00: [mem 0x000d4000-0x000d7fff window]
<7>pnp 00:00: [mem 0x000d8000-0x000dbfff window]
<7>pnp 00:00: [mem 0x000dc000-0x000dffff window]
<7>pnp 00:00: [mem 0x000e0000-0x000e3fff window]
<7>pnp 00:00: [mem 0x000e4000-0x000e7fff window]
<7>pnp 00:00: [mem 0x000e8000-0x000ebfff window]
<7>pnp 00:00: [mem 0x000ec000-0x000effff window]
<7>pnp 00:00: [mem 0xd0000000-0xfebfffff window]
<7>pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
<7>pnp 00:01: [io  0x0010-0x001f]
<7>pnp 00:01: [io  0x0024-0x0025]
<7>pnp 00:01: [io  0x0028-0x0029]
<7>pnp 00:01: [io  0x002c-0x002d]
<7>pnp 00:01: [io  0x002e-0x002f]
<7>pnp 00:01: [io  0x0030-0x0031]
<7>pnp 00:01: [io  0x0034-0x0035]
<7>pnp 00:01: [io  0x0038-0x0039]
<7>pnp 00:01: [io  0x003c-0x003d]
<7>pnp 00:01: [io  0x004e-0x004f]
<7>pnp 00:01: [io  0x0050-0x0053]
<7>pnp 00:01: [io  0x0063]
<7>pnp 00:01: [io  0x0065]
<7>pnp 00:01: [io  0x0067]
<7>pnp 00:01: [io  0x0072-0x0077]
<7>pnp 00:01: [io  0x0080]
<7>pnp 00:01: [io  0x0090-0x009f]
<7>pnp 00:01: [io  0x00a4-0x00a5]
<7>pnp 00:01: [io  0x00a8-0x00a9]
<7>pnp 00:01: [io  0x00ac-0x00ad]
<7>pnp 00:01: [io  0x00b0-0x00b5]
<7>pnp 00:01: [io  0x00b8-0x00b9]
<7>pnp 00:01: [io  0x00bc-0x00bd]
<7>pnp 00:01: [io  0x04d0-0x04d1]
<7>pnp 00:01: [io  0x0295-0x0296]
<7>pnp 00:01: [io  0x0ca2-0x0ca3]
<7>pnp 00:01: [io  0x0ca8-0x0caf]
<7>pnp 00:01: [io  0x0800-0x080f]
<7>pnp 00:01: [io  0x1000-0x107f]
<7>pnp 00:01: [io  0x1180-0x11bf]
<7>pnp 00:01: [io  0xfe00]
<7>pnp 00:01: [mem 0xe0000000-0xefffffff]
<7>pnp 00:01: [mem 0xfee00000-0xfee0ffff]
<7>pnp 00:01: [mem 0xfec89000-0xfec89fff]
<7>pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
<7>pnp 00:01: [mem 0xfe000000-0xfe01ffff]
<7>pnp 00:01: [mem 0xfe600000-0xfe6fffff]
<7>pnp 00:01: [mem 0xfed20000-0xfed44fff]
<7>pnp 00:01: [mem 0xfed45000-0xfed8ffff]
<6>system 00:01: [io  0x04d0-0x04d1] has been reserved
<6>system 00:01: [io  0x0295-0x0296] has been reserved
<6>system 00:01: [io  0x0ca2-0x0ca3] has been reserved
<6>system 00:01: [io  0x0ca8-0x0caf] has been reserved
<6>system 00:01: [io  0x0800-0x080f] has been reserved
<6>system 00:01: [io  0x1000-0x107f] has been reserved
<6>system 00:01: [io  0x1180-0x11bf] has been reserved
<6>system 00:01: [io  0xfe00] has been reserved
<6>system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
<6>system 00:01: [mem 0xfee00000-0xfee0ffff] could not be reserved
<6>system 00:01: [mem 0xfec89000-0xfec89fff] could not be reserved
<6>system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
<6>system 00:01: [mem 0xfe000000-0xfe01ffff] has been reserved
<6>system 00:01: [mem 0xfe600000-0xfe6fffff] has been reserved
<6>system 00:01: [mem 0xfed20000-0xfed44fff] has been reserved
<6>system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
<7>system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>pnp 00:02: [io  0x0000-0x001f]
<7>pnp 00:02: [io  0x0081-0x0091]
<7>pnp 00:02: [io  0x0093-0x009f]
<7>pnp 00:02: [io  0x00c0-0x00df]
<7>pnp 00:02: [dma 4]
<7>pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
<7>pnp 00:03: [io  0x00f0-0x00fe]
<7>pnp 00:03: [irq 13]
<7>pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
<7>pnp 00:04: [irq 0 disabled]
<7>pnp 00:04: [irq 8]
<7>pnp 00:04: [mem 0xfed00000-0xfed003ff]
<7>pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
<7>pnp 00:05: [io  0x0070-0x0071]
<7>pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
<7>pnp 00:06: [io  0x0061]
<7>pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
<7>pnp 00:07: [mem 0xff000000-0xffffffff]
<7>pnp 00:07: Plug and Play ACPI device, IDs INT0800 (active)
<7>pnp 00:08: [io  0x0060]
<7>pnp 00:08: [io  0x0064]
<7>pnp 00:08: [irq 1]
<7>pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
<7>pnp 00:09: [irq 12]
<7>pnp 00:09: Plug and Play ACPI device, IDs PNP0f13 (active)
<6>Switched to NOHz mode on CPU #0
<6>Switched to NOHz mode on CPU #1
<6>Switched to NOHz mode on CPU #3
<6>Switched to NOHz mode on CPU #4
<7>pnp 00:0a: [io  0x03f8-0x03ff]
<7>pnp 00:0a: [irq 4]
<6>Switched to NOHz mode on CPU #2
<6>Switched to NOHz mode on CPU #5
<6>Switched to NOHz mode on CPU #6
<6>Switched to NOHz mode on CPU #7
<7>pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
<7>pnp 00:0b: [io  0x02f8-0x02ff]
<7>pnp 00:0b: [irq 3]
<7>pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
<6>pnp: PnP ACPI: found 12 devices
<6>ACPI: ACPI bus type pnp unregistered
<6>pci 0000:00:05.0: BAR 15: assigned [mem 0xdc700000-0xdc7fffff pref]
<6>pci 0000:00:09.0: BAR 15: assigned [mem 0xdc800000-0xdc8fffff pref]
<6>pci 0000:00:01.0: PCI bridge to [bus 01-01]
<6>pci 0000:00:01.0:   bridge window [io  disabled]
<6>pci 0000:00:01.0:   bridge window [mem disabled]
<6>pci 0000:00:01.0:   bridge window [mem pref disabled]
<6>pci 0000:03:00.0: PCI bridge to [bus 04-04]
<6>pci 0000:03:00.0:   bridge window [io  disabled]
<6>pci 0000:03:00.0:   bridge window [mem disabled]
<6>pci 0000:03:00.0:   bridge window [mem pref disabled]
<6>pci 0000:02:00.0: PCI bridge to [bus 03-04]
<6>pci 0000:02:00.0:   bridge window [io  disabled]
<6>pci 0000:02:00.0:   bridge window [mem disabled]
<6>pci 0000:02:00.0:   bridge window [mem pref disabled]
<6>pci 0000:02:00.3: PCI bridge to [bus 05-05]
<6>pci 0000:02:00.3:   bridge window [io  disabled]
<6>pci 0000:02:00.3:   bridge window [mem disabled]
<6>pci 0000:02:00.3:   bridge window [mem pref disabled]
<6>pci 0000:00:03.0: PCI bridge to [bus 02-05]
<6>pci 0000:00:03.0:   bridge window [io  disabled]
<6>pci 0000:00:03.0:   bridge window [mem 0xdc500000-0xdc5fffff]
<6>pci 0000:00:03.0:   bridge window [mem pref disabled]
<6>pci 0000:06:00.0: BAR 6: assigned [mem 0xdc700000-0xdc70ffff pref]
<6>pci 0000:00:05.0: PCI bridge to [bus 06-06]
<6>pci 0000:00:05.0:   bridge window [io  disabled]
<6>pci 0000:00:05.0:   bridge window [mem 0xd8000000-0xdc3fffff]
<6>pci 0000:00:05.0:   bridge window [mem 0xdc700000-0xdc7fffff pref]
<6>pci 0000:00:07.0: PCI bridge to [bus 07-07]
<6>pci 0000:00:07.0:   bridge window [io  disabled]
<6>pci 0000:00:07.0:   bridge window [mem disabled]
<6>pci 0000:00:07.0:   bridge window [mem pref disabled]
<6>pci 0000:08:00.0: BAR 6: assigned [mem 0xdc800000-0xdc81ffff pref]
<6>pci 0000:08:00.1: BAR 6: assigned [mem 0xdc820000-0xdc83ffff pref]
<6>pci 0000:00:09.0: PCI bridge to [bus 08-08]
<6>pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
<6>pci 0000:00:09.0:   bridge window [mem 0xdc400000-0xdc4fffff]
<6>pci 0000:00:09.0:   bridge window [mem 0xdc800000-0xdc8fffff pref]
<6>pci 0000:09:01.0: BAR 6: assigned [mem 0xdc620000-0xdc63ffff pref]
<6>pci 0000:00:1e.0: PCI bridge to [bus 09-09]
<6>pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
<6>pci 0000:00:1e.0:   bridge window [mem 0xdc600000-0xdc6fffff]
<6>pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
<6>pci 0000:00:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
<7>pci 0000:00:01.0: setting latency timer to 64
<6>pci 0000:00:03.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
<7>pci 0000:00:03.0: setting latency timer to 64
<6>pci 0000:02:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
<7>pci 0000:02:00.0: setting latency timer to 64
<6>pci 0000:03:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
<7>pci 0000:03:00.0: setting latency timer to 64
<7>pci 0000:02:00.3: setting latency timer to 64
<6>pci 0000:00:05.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
<7>pci 0000:00:05.0: setting latency timer to 64
<6>pci 0000:00:07.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
<7>pci 0000:00:07.0: setting latency timer to 64
<6>pci 0000:00:09.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
<7>pci 0000:00:09.0: setting latency timer to 64
<7>pci 0000:00:1e.0: setting latency timer to 64
<7>pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
<7>pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
<7>pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
<7>pci_bus 0000:00: resource 7 [mem 0x000cc000-0x000cffff]
<7>pci_bus 0000:00: resource 8 [mem 0x000d0000-0x000d3fff]
<7>pci_bus 0000:00: resource 9 [mem 0x000d4000-0x000d7fff]
<7>pci_bus 0000:00: resource 10 [mem 0x000d8000-0x000dbfff]
<7>pci_bus 0000:00: resource 11 [mem 0x000dc000-0x000dffff]
<7>pci_bus 0000:00: resource 12 [mem 0xd0000000-0xfebfffff]
<7>pci_bus 0000:02: resource 1 [mem 0xdc500000-0xdc5fffff]
<7>pci_bus 0000:06: resource 1 [mem 0xd8000000-0xdc3fffff]
<7>pci_bus 0000:06: resource 2 [mem 0xdc700000-0xdc7fffff pref]
<7>pci_bus 0000:08: resource 0 [io  0x2000-0x2fff]
<7>pci_bus 0000:08: resource 1 [mem 0xdc400000-0xdc4fffff]
<7>pci_bus 0000:08: resource 2 [mem 0xdc800000-0xdc8fffff pref]
<7>pci_bus 0000:09: resource 0 [io  0x3000-0x3fff]
<7>pci_bus 0000:09: resource 1 [mem 0xdc600000-0xdc6fffff]
<7>pci_bus 0000:09: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
<7>pci_bus 0000:09: resource 4 [io  0x0000-0x0cf7]
<7>pci_bus 0000:09: resource 5 [io  0x0d00-0xffff]
<7>pci_bus 0000:09: resource 6 [mem 0x000a0000-0x000bffff]
<7>pci_bus 0000:09: resource 7 [mem 0x000cc000-0x000cffff]
<7>pci_bus 0000:09: resource 8 [mem 0x000d0000-0x000d3fff]
<7>pci_bus 0000:09: resource 9 [mem 0x000d4000-0x000d7fff]
<7>pci_bus 0000:09: resource 10 [mem 0x000d8000-0x000dbfff]
<7>pci_bus 0000:09: resource 11 [mem 0x000dc000-0x000dffff]
<7>pci_bus 0000:09: resource 12 [mem 0xd0000000-0xfebfffff]
<6>NET: Registered protocol family 2
<6>IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
<6>TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
<6>TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
<6>TCP: Hash tables configured (established 524288 bind 65536)
<6>TCP reno registered
<6>UDP hash table entries: 8192 (order: 6, 262144 bytes)
<6>UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
<6>NET: Registered protocol family 1
<7>pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x1030
<7>pci 0000:00:1d.0: Performing full reset
<7>pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
<7>pci 0000:00:1d.1: Performing full reset
<7>pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
<7>pci 0000:00:1d.2: Performing full reset
<7>pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x0010
<7>pci 0000:00:1d.3: Performing full reset
<7>PCI: CLS mismatch (32 != 64), using 64 bytes
<6>pci 0000:08:00.0: Disabling L0s
<6>pci 0000:08:00.1: Disabling L0s
<7>pci 0000:09:01.0: Boot video device
<6>Trying to unpack rootfs image as initramfs...
<6>Freeing initrd memory: 17924k freed
<6>PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
<6>Placing 64MB software IO TLB between ffff8800cbc00000 - ffff8800cfc00000
<6>software IO TLB at phys 0xcbc00000 - 0xcfc00000
<6>Simple Boot Flag at 0x41 set to 0x80
<6>audit: initializing netlink socket (disabled)
<5>type=2000 audit(1297661245.160:1): initialized
<6>HugeTLB registered 2 MB page size, pre-allocated 0 pages
<5>VFS: Disk quotas dquot_6.5.2
<4>Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>squashfs: version 4.0 (2009/01/31) Phillip Lougher
<6>msgmni has been set to 19780
<4>cryptomgr_test used greatest stack depth: 7112 bytes left
<4>cryptomgr_test used greatest stack depth: 6856 bytes left
<6>Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
<6>io scheduler noop registered
<6>io scheduler deadline registered
<6>io scheduler cfq registered (default)
<6>pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<7>intel_idle: MWAIT substates: 0x2220
<7>intel_idle: does not run on family 6 model 23
<6>input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0A03:00/PNP0C0C:00/input/input0
<6>ACPI: Power Button [PWRB]
<6>input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
<6>ACPI: Power Button [PWRF]
<7>ACPI: acpi_idle registered with cpuidle
<6>ERST: Error Record Serialization Table (ERST) support is initialized.
<6>Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
<6>serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
<6>00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
<6>Non-volatile memory driver v1.3
<6>Linux agpgart interface v0.103
<6>brd: module loaded
<7>ata_piix 0000:00:1f.1: version 2.13
<6>ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<7>ata_piix 0000:00:1f.1: setting latency timer to 64
<6>scsi0 : ata_piix
<6>scsi1 : ata_piix
<6>ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1880 irq 14
<6>ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1888 irq 15
<6>ata_piix 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
<6>ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
<7>ata2: port disabled. ignoring.
<6>Refined TSC clocksource calibration: 2500.088 MHz.
<6>Switching to clocksource tsc
<7>ata_piix 0000:00:1f.2: setting latency timer to 64
<6>scsi2 : ata_piix
<6>scsi3 : ata_piix
<6>ata3: SATA max UDMA/133 cmd 0x18c0 ctl 0x18b8 bmdma 0x18a0 irq 17
<6>ata4: SATA max UDMA/133 cmd 0x18b0 ctl 0x1894 bmdma 0x18a8 irq 17
<6>ata1.01: ATAPI: DVD-ROM UJDA780, 1.50, max UDMA/33
<6>i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
<6>ata1.01: configured for UDMA/33
<5>scsi 0:0:1:0: CD-ROM            MATSHITA DVD-ROM UJDA780  1.50 PQ: 0 ANSI: 5
<6>ata3.00: ATA-7: WDC WD2500JS-60NCB2, 10.02E03, max UDMA/100
<6>ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
<6>ata3.00: configured for UDMA/100
<5>scsi 2:0:0:0: Direct-Access     ATA      WDC WD2500JS-60N 10.0 PQ: 0 ANSI: 5
<5>sd 2:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
<5>sd 2:0:0:0: [sda] Write Protect is off
<7>sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<6> sda: sda1 sda2 sda3
<5>sd 2:0:0:0: [sda] Attached SCSI disk
<6>serio: i8042 KBD port at 0x60,0x64 irq 1
<6>mousedev: PS/2 mouse device common for all mice
<6>rtc_cmos 00:05: RTC can wake from S4
<6>rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
<6>rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
<6>cpuidle: using governor ladder
<6>cpuidle: using governor menu
<6>usbcore: registered new interface driver usbhid
<6>usbhid: USB HID core driver
<6>TCP cubic registered
<6>Initializing XFRM netlink socket
<6>NET: Registered protocol family 17
<5>Registering the dns_resolver key type
<7>PM: Hibernation image not present or could not be loaded.
<4>registered taskstats version 1
<6>Freeing unused kernel memory: 1276k freed
<6>Write protecting the kernel read-only data: 8192k
<6>Freeing unused kernel memory: 140k freed
<6>Freeing unused kernel memory: 2008k freed
<4>mknod used greatest stack depth: 5728 bytes left
<4>modprobe used greatest stack depth: 5504 bytes left
<6>dracut: dracut-006-6.fc14
<6>device-mapper: uevent: version 1.0.3
<6>device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
<6>udev[122]: starting version 161
<4>modprobe used greatest stack depth: 5088 bytes left
<6>uhci_hcd: USB Universal Host Controller Interface driver
<6>uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
<7>uhci_hcd 0000:00:1d.0: setting latency timer to 64
<6>uhci_hcd 0000:00:1d.0: UHCI Host Controller
<7>drivers/usb/core/inode.c: creating file 'devices'
<7>drivers/usb/core/inode.c: creating file '001'
<6>uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
<6>ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<4>Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
<7>ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
<6>QLogic/NetXen Network Driver v4.0.75
<4>netxen_nic: chip revisions between 0x30-0x41 will not be enabled.
<4>netxen_nic: chip revisions between 0x30-0x41 will not be enabled.
<6>Intel(R) Gigabit Ethernet Network Driver - version 2.1.0-k2
<6>Copyright (c) 2007-2009 Intel Corporation.
<6>igb 0000:08:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
<7>igb 0000:08:00.0: setting latency timer to 64
<7>igb 0000:08:00.0: irq 64 for MSI/MSI-X
<7>igb 0000:08:00.0: irq 65 for MSI/MSI-X
<7>igb 0000:08:00.0: irq 66 for MSI/MSI-X
<7>igb 0000:08:00.0: irq 67 for MSI/MSI-X
<7>igb 0000:08:00.0: irq 68 for MSI/MSI-X
<7>igb 0000:08:00.0: irq 69 for MSI/MSI-X
<7>igb 0000:08:00.0: irq 70 for MSI/MSI-X
<7>igb 0000:08:00.0: irq 71 for MSI/MSI-X
<7>igb 0000:08:00.0: irq 72 for MSI/MSI-X
<4>sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
<6>cdrom: Uniform CD-ROM driver Revision: 3.20
<7>sr 0:0:1:0: Attached scsi CD-ROM sr0
<6>uhci_hcd 0000:00:1d.0: detected 2 ports
<7>uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
<7>uhci_hcd 0000:00:1d.0: Performing full reset
<7>uhci_hcd 0000:00:1d.0: supports USB remote wakeup
<6>uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001800
<7>usb usb1: default language 0x0409
<7>usb usb1: udev 1, busnum 1, minor = 0
<6>usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
<6>usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb1: Product: UHCI Host Controller
<6>usb usb1: Manufacturer: Linux 2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 uhci_hcd
<6>usb usb1: SerialNumber: 0000:00:1d.0
<7>usb usb1: usb_probe_device
<7>usb usb1: configuration #1 chosen from 1 choice
<7>usb usb1: adding 1-0:1.0 (config #1, interface 0)
<7>hub 1-0:1.0: usb_probe_interface
<7>hub 1-0:1.0: usb_probe_interface - got id
<6>hub 1-0:1.0: USB hub found
<6>hub 1-0:1.0: 2 ports detected
<7>hub 1-0:1.0: standalone hub
<7>hub 1-0:1.0: no power switching (usb 1.0)
<7>hub 1-0:1.0: individual port over-current protection
<7>hub 1-0:1.0: power on to power good time: 2ms
<7>hub 1-0:1.0: local power source is good
<7>hub 1-0:1.0: trying to enable port power on non-switchable hub
<7>drivers/usb/core/inode.c: creating file '001'
<6>uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
<7>uhci_hcd 0000:00:1d.1: setting latency timer to 64
<6>uhci_hcd 0000:00:1d.1: UHCI Host Controller
<7>drivers/usb/core/inode.c: creating file '002'
<6>uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
<4>cdrom_id used greatest stack depth: 4720 bytes left
<6>[drm] Initialized drm 1.1.0 20060810
<6>[drm] radeon defaulting to kernel modesetting.
<6>[drm] radeon kernel modesetting enabled.
<6>radeon 0000:09:01.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
<6>[drm] initializing kernel modesetting (RV100 0x1002:0x515E).
<6>[drm] register mmio base: 0xDC600000
<6>[drm] register mmio size: 65536
<6>radeon 0000:09:01.0: VRAM: 128M 0x00000000D0000000 - 0x00000000D7FFFFFF (32M used)
<6>radeon 0000:09:01.0: GTT: 512M 0x00000000B0000000 - 0x00000000CFFFFFFF
<6>[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
<6>[drm] Driver supports precise vblank timestamp query.
<6>[drm] radeon: irq initialized.
<4>mtrr: type mismatch for d0000000,8000000 old: write-back new: write-combining
<6>[drm] Detected VRAM RAM=128M, BAR=128M
<6>[drm] RAM width 16bits DDR
<6>[TTM] Zone  kernel: Available graphics memory: 5065602 kiB.
<6>[TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
<6>[TTM] Initializing pool allocator.
<6>[drm] radeon: 32M of VRAM memory ready
<6>[drm] radeon: 512M of GTT memory ready.
<6>[drm] GART: num cpu pages 131072, num gpu pages 131072
<6>uhci_hcd 0000:00:1d.1: detected 2 ports
<7>uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
<7>uhci_hcd 0000:00:1d.1: Performing full reset
<7>uhci_hcd 0000:00:1d.1: supports USB remote wakeup
<6>uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001820
<7>usb usb2: default language 0x0409
<7>usb usb2: udev 1, busnum 2, minor = 128
<6>usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
<6>usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb2: Product: UHCI Host Controller
<6>usb usb2: Manufacturer: Linux 2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 uhci_hcd
<6>usb usb2: SerialNumber: 0000:00:1d.1
<7>usb usb2: usb_probe_device
<7>usb usb2: configuration #1 chosen from 1 choice
<7>usb usb2: adding 2-0:1.0 (config #1, interface 0)
<7>hub 2-0:1.0: usb_probe_interface
<7>hub 2-0:1.0: usb_probe_interface - got id
<6>hub 2-0:1.0: USB hub found
<6>hub 2-0:1.0: 2 ports detected
<7>hub 2-0:1.0: standalone hub
<7>hub 2-0:1.0: no power switching (usb 1.0)
<7>hub 2-0:1.0: individual port over-current protection
<7>hub 2-0:1.0: power on to power good time: 2ms
<7>hub 2-0:1.0: local power source is good
<7>hub 2-0:1.0: trying to enable port power on non-switchable hub
<7>drivers/usb/core/inode.c: creating file '001'
<6>uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
<7>uhci_hcd 0000:00:1d.2: setting latency timer to 64
<6>uhci_hcd 0000:00:1d.2: UHCI Host Controller
<7>drivers/usb/core/inode.c: creating file '003'
<6>uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
<6>radeon 0000:09:01.0: WB enabled
<6>[drm] Loading R100 Microcode
<6>[drm] radeon: ring at 0x00000000B0001000
<6>[drm] ring test succeeded in 3 usecs
<6>[drm] radeon: ib pool ready.
<6>[drm] ib test succeeded in 0 usecs
<6>[drm] No TV DAC info found in BIOS
<6>[drm] No valid Ext TMDS info found in BIOS
<6>[drm] Radeon Display Connectors
<6>[drm] Connector 0:
<6>[drm]   VGA
<6>[drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
<6>[drm]   Encoders:
<6>[drm]     CRT1: INTERNAL_DAC1
<6>[drm] Connector 1:
<6>[drm]   DVI-I
<6>[drm]   HPD2
<6>[drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
<6>[drm]   Encoders:
<6>[drm]     CRT2: INTERNAL_DAC2
<6>[drm]     DFP2: INTERNAL_DVO1
<6>uhci_hcd 0000:00:1d.2: detected 2 ports
<7>uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
<7>uhci_hcd 0000:00:1d.2: Performing full reset
<7>uhci_hcd 0000:00:1d.2: supports USB remote wakeup
<6>uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001840
<7>usb usb3: default language 0x0409
<7>usb usb3: udev 1, busnum 3, minor = 256
<6>usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
<6>usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb3: Product: UHCI Host Controller
<6>usb usb3: Manufacturer: Linux 2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 uhci_hcd
<6>usb usb3: SerialNumber: 0000:00:1d.2
<7>usb usb3: usb_probe_device
<7>usb usb3: configuration #1 chosen from 1 choice
<7>usb usb3: adding 3-0:1.0 (config #1, interface 0)
<7>hub 3-0:1.0: usb_probe_interface
<7>hub 3-0:1.0: usb_probe_interface - got id
<6>hub 3-0:1.0: USB hub found
<6>hub 3-0:1.0: 2 ports detected
<7>hub 3-0:1.0: standalone hub
<7>hub 3-0:1.0: no power switching (usb 1.0)
<7>hub 3-0:1.0: individual port over-current protection
<7>hub 3-0:1.0: power on to power good time: 2ms
<7>hub 3-0:1.0: local power source is good
<7>hub 3-0:1.0: trying to enable port power on non-switchable hub
<7>drivers/usb/core/inode.c: creating file '001'
<6>uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
<7>uhci_hcd 0000:00:1d.3: setting latency timer to 64
<6>uhci_hcd 0000:00:1d.3: UHCI Host Controller
<7>drivers/usb/core/inode.c: creating file '004'
<6>uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
<7>hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
<6>[drm] fb mappable at 0xD0040000
<6>[drm] vram apper at 0xD0000000
<6>[drm] size 786432
<6>[drm] fb depth is 8
<6>[drm]    pitch is 1024
<6>fbcon: radeondrmfb (fb0) is primary device
<7>hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
<7>hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
<6>igb 0000:08:00.0: Intel(R) Gigabit Ethernet Network Connection
<6>igb 0000:08:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:30:48:64:a0:bc
<6>igb 0000:08:00.0: eth0: PBA No: FFFFFF-0FF
<6>igb 0000:08:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
<6>igb 0000:08:00.1: PCI INT B -> GSI 46 (level, low) -> IRQ 46
<7>igb 0000:08:00.1: setting latency timer to 64
<7>igb 0000:08:00.1: irq 73 for MSI/MSI-X
<7>igb 0000:08:00.1: irq 74 for MSI/MSI-X
<7>igb 0000:08:00.1: irq 75 for MSI/MSI-X
<7>igb 0000:08:00.1: irq 76 for MSI/MSI-X
<7>igb 0000:08:00.1: irq 77 for MSI/MSI-X
<7>igb 0000:08:00.1: irq 78 for MSI/MSI-X
<7>igb 0000:08:00.1: irq 79 for MSI/MSI-X
<7>igb 0000:08:00.1: irq 80 for MSI/MSI-X
<7>igb 0000:08:00.1: irq 81 for MSI/MSI-X
<4>Console: switching to colour frame buffer device 128x48
<6>fb0: radeondrmfb frame buffer device
<6>drm: registered panic notifier
<6>[drm] Initialized radeon 2.8.0 20080528 for 0000:09:01.0 on minor 0
<4>modprobe used greatest stack depth: 4288 bytes left
<6>uhci_hcd 0000:00:1d.3: detected 2 ports
<7>uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
<7>uhci_hcd 0000:00:1d.3: Performing full reset
<6>uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001860
<7>usb usb4: default language 0x0409
<7>usb usb4: udev 1, busnum 4, minor = 384
<6>usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
<6>usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb4: Product: UHCI Host Controller
<6>usb usb4: Manufacturer: Linux 2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 uhci_hcd
<6>usb usb4: SerialNumber: 0000:00:1d.3
<7>usb usb4: usb_probe_device
<7>usb usb4: configuration #1 chosen from 1 choice
<7>usb usb4: adding 4-0:1.0 (config #1, interface 0)
<7>hub 4-0:1.0: usb_probe_interface
<7>hub 4-0:1.0: usb_probe_interface - got id
<6>hub 4-0:1.0: USB hub found
<6>hub 4-0:1.0: 2 ports detected
<7>hub 4-0:1.0: standalone hub
<7>hub 4-0:1.0: no power switching (usb 1.0)
<7>hub 4-0:1.0: individual port over-current protection
<7>hub 4-0:1.0: power on to power good time: 2ms
<7>hub 4-0:1.0: local power source is good
<7>hub 4-0:1.0: trying to enable port power on non-switchable hub
<7>drivers/usb/core/inode.c: creating file '001'
<6>ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
<7>ehci_hcd 0000:00:1d.7: setting latency timer to 64
<6>ehci_hcd 0000:00:1d.7: EHCI Host Controller
<7>drivers/usb/core/inode.c: creating file '005'
<6>ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
<7>ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
<7>ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
<6>ehci_hcd 0000:00:1d.7: debug port 1
<7>ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
<7>ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
<7>ehci_hcd 0000:00:1d.7: supports USB remote wakeup
<6>ehci_hcd 0000:00:1d.7: irq 23, io mem 0xdc904000
<7>ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
<7>ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
<6>ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
<7>usb usb5: default language 0x0409
<7>usb usb5: udev 1, busnum 5, minor = 512
<6>usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
<6>usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb5: Product: EHCI Host Controller
<6>usb usb5: Manufacturer: Linux 2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 ehci_hcd
<6>usb usb5: SerialNumber: 0000:00:1d.7
<7>usb usb5: usb_probe_device
<7>usb usb5: configuration #1 chosen from 1 choice
<7>usb usb5: adding 5-0:1.0 (config #1, interface 0)
<7>hub 5-0:1.0: usb_probe_interface
<7>hub 5-0:1.0: usb_probe_interface - got id
<6>hub 5-0:1.0: USB hub found
<6>hub 5-0:1.0: 8 ports detected
<7>hub 5-0:1.0: standalone hub
<7>hub 5-0:1.0: no power switching (usb 1.0)
<7>hub 5-0:1.0: individual port over-current protection
<7>hub 5-0:1.0: power on to power good time: 20ms
<7>hub 5-0:1.0: local power source is good
<7>hub 5-0:1.0: trying to enable port power on non-switchable hub
<7>drivers/usb/core/inode.c: creating file '001'
<7>ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
<7>ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
<7>ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
<7>ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.3
<7>hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
<7>hub 5-0:1.0: state 7 ports 8 chg 0000 evt 0000
<6>igb 0000:08:00.1: Intel(R) Gigabit Ethernet Network Connection
<6>igb 0000:08:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:64:a0:bd
<6>igb 0000:08:00.1: eth1: PBA No: FFFFFF-0FF
<6>igb 0000:08:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
<6>EXT3-fs (sda1): recovery required on readonly filesystem
<6>EXT3-fs (sda1): write access will be enabled during recovery
<6>EXT3-fs: barriers not enabled
<7>usb usb1: suspend_rh (auto-stop)
<7>usb usb2: suspend_rh (auto-stop)
<7>usb usb3: suspend_rh (auto-stop)
<7>usb usb4: suspend_rh (auto-stop)
<7>hub 1-0:1.0: hub_suspend
<7>usb usb1: bus auto-suspend
<7>usb usb1: suspend_rh
<7>hub 2-0:1.0: hub_suspend
<7>usb usb2: bus auto-suspend
<7>usb usb2: suspend_rh
<7>hub 3-0:1.0: hub_suspend
<7>usb usb3: bus auto-suspend
<7>usb usb3: suspend_rh
<7>hub 4-0:1.0: hub_suspend
<7>usb usb4: bus auto-suspend
<7>usb usb4: suspend_rh
<7>hub 5-0:1.0: hub_suspend
<7>usb usb5: bus auto-suspend
<7>ehci_hcd 0000:00:1d.7: suspend root hub
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3-fs (sda1): recovery complete
<6>EXT3-fs (sda1): mounted filesystem with ordered data mode
<6>dracut: Mounted root filesystem /dev/sda1
<6>dracut: Loading SELinux policy
<4>load_policy used greatest stack depth: 3872 bytes left
<6>dracut: /sbin/load_policy: Can't load policy: No such device
<6>dracut: Switching root
<6>udev[345]: starting version 161
<4>modprobe used greatest stack depth: 3664 bytes left
<5>sr 0:0:1:0: Attached scsi generic sg0 type 5
<5>sd 2:0:0:0: Attached scsi generic sg1 type 0
<6>microcode: CPU0 sig=0x10676, pf=0x40, revision=0x60b
<6>input: PC Speaker as /devices/platform/pcspkr/input/input2
<6>shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
<5>intel_rng: FWH not detected
<6>dca service started, version 1.12.1
<6>microcode: CPU1 sig=0x10676, pf=0x40, revision=0x60b
<6>microcode: CPU2 sig=0x10676, pf=0x40, revision=0x60b
<6>microcode: CPU3 sig=0x10676, pf=0x40, revision=0x60b
<6>microcode: CPU4 sig=0x10676, pf=0x40, revision=0x60b
<6>microcode: CPU5 sig=0x10676, pf=0x40, revision=0x60b
<6>microcode: CPU6 sig=0x10676, pf=0x40, revision=0x60b
<6>microcode: CPU7 sig=0x10676, pf=0x40, revision=0x60b
<6>microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
<6>ioatdma: Intel(R) QuickData Technology Driver 4.00
<6>ioatdma 0000:00:0f.0: PCI INT A -> GSI 33 (level, low) -> IRQ 33
<7>ioatdma 0000:00:0f.0: setting latency timer to 64
<3>ioatdma 0000:00:0f.0: channel enumeration error
<4>hpet1: lost 1 rtc interrupts
<6>EDAC MC: Ver: 2.1.0 Feb 13 2011
<3>ioatdma 0000:00:0f.0: Intel(R) I/OAT DMA Engine init failed
<6>ioatdma 0000:00:0f.0: PCI INT A disabled
<6>i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
<6>iTCO_vendor_support: vendor-support=0
<6>iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
<6>iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0x1060)
<6>iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
<6>EDAC MC0: Giving out device to 'i5400_edac.c' 'I5400': DEV 0000:00:10.0
<6>EDAC PCI0: Giving out device to module 'i5400_edac' controller 'EDAC PCI controller': DEV '0000:00:10.0' (POLLED)
<6>microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
<6>microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
<6>microcode: CPU2 updated to revision 0x60f, date = 2010-09-29
<6>microcode: CPU3 updated to revision 0x60f, date = 2010-09-29
<6>microcode: CPU4 updated to revision 0x60f, date = 2010-09-29
<6>microcode: CPU5 updated to revision 0x60f, date = 2010-09-29
<6>microcode: CPU6 updated to revision 0x60f, date = 2010-09-29
<6>microcode: CPU7 updated to revision 0x60f, date = 2010-09-29
<6>802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
<6>All bugs added by David S. Miller <davem@redhat.com>
<6>tun: Universal TUN/TAP device driver, 1.6
<6>tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
<6>nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
<6>ip_tables: (C) 2000-2006 Netfilter Core Team
<6>fuse init (API version 7.16)
<6>has_svm: not amd
<3>kvm: no hardware support
<6>NET: Registered protocol family 10
<6>bonding: Ethernet Channel Bonding Driver: v3.7.0 (June 2, 2010)
<6>bonding: MII link monitoring set to 100 ms
<6>EXT3-fs (sda1): using internal journal
<4>EXT4-fs (sda3): Ignoring deprecated nobh option
<6>EXT4-fs (sda3): mounted filesystem with writeback data mode. Opts: data=writeback,nobh
<6>Adding 1951892k swap on /dev/sda2.  Priority:-1 extents:1 across:1951892k 
<6>8021q: adding VLAN 0 to HW filter on device bond0
<6>ADDRCONF(NETDEV_UP): bond0: link is not ready
<6>bonding: bond0: Adding slave eth0.
<6>8021q: adding VLAN 0 to HW filter on device eth0
<6>bonding: bond0: enslaving eth0 as a backup interface with a down link.
<6>bonding: bond0: Adding slave eth1.
<6>8021q: adding VLAN 0 to HW filter on device eth1
<6>bonding: bond0: enslaving eth1 as a backup interface with a down link.
<6>igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
<6>bonding: bond0: link status definitely up for interface eth0, 1000 Mbps full duplex.
<6>ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
<7>bond0: no IPv6 routers present
<6>RPC: Registered udp transport module.
<6>RPC: Registered tcp transport module.
<6>RPC: Registered tcp NFSv4.1 backchannel transport module.
<6>Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
<4>NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
<6>NFSD: starting 90-second grace period
<4>sshd (5792): /proc/5792/oom_adj is deprecated, please use /proc/5792/oom_score_adj instead.
<6>device bond0 entered promiscuous mode
<6>device eth0 entered promiscuous mode
<6>device eth1 entered promiscuous mode
<7>qnet0: no IPv6 routers present
<7>qnet1: no IPv6 routers present
<7>qnet0: no IPv6 routers present
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth4: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth4: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
<6>lt-LinkQueueTes[27642]: segfault at 5 ip 00000000f76dd26a sp 00000000ff8a3038 error 4 in libtacC.so.0.0.0[f76c1000+41000]
<6>lt-HashMapItera[28691]: segfault at 0 ip 00000000f770c4c7 sp 00000000fffad654 error 4 in libtacC.so.0.0.0[f76f0000+41000]
<6>lt-HashMapItera[28692]: segfault at 0 ip 00000000f770c731 sp 00000000fffad660 error 4 in libtacC.so.0.0.0[f76f0000+41000]
<6>lt-LinkQueueIte[30373]: segfault at 0 ip 00000000f7770814 sp 00000000ffa64f2c error 4 in libtacC.so.0.0.0[f7755000+41000]
<6>lt-LinkQueueIte[30374]: segfault at 0 ip 00000000f777082d sp 00000000ffa64f2c error 4 in libtacC.so.0.0.0[f7755000+41000]
<6>device rtnmTest entered promiscuous mode
<6>device rtnmTest left promiscuous mode
<7>tap2690-2: no IPv6 routers present
<7>tap2690-1: no IPv6 routers present
<6>Linux Tulip driver version 1.1.15 (Feb 27, 2007)
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>lt-LinkQueueTes[5781]: segfault at 5 ip 00000000f778426a sp 00000000ffe2d618 error 4 in libtacC.so.0.0.0[f7768000+41000]
<6>lt-HashMapItera[6723]: segfault at 0 ip 00000000f77824c7 sp 00000000ffc3b004 error 4 in libtacC.so.0.0.0[f7766000+41000]
<6>lt-HashMapItera[6725]: segfault at 0 ip 00000000f7782731 sp 00000000ffc3b010 error 4 in libtacC.so.0.0.0[f7766000+41000]
<6>lt-LinkQueueIte[6822]: segfault at 0 ip 00000000f76f0814 sp 00000000ffee588c error 4 in libtacC.so.0.0.0[f76d5000+41000]
<6>lt-LinkQueueIte[6824]: segfault at 0 ip 00000000f76f082d sp 00000000ffee588c error 4 in libtacC.so.0.0.0[f76d5000+41000]
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>ADDRCONF(NETDEV_UP): v1a: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): v1a: link becomes ready
<6>ADDRCONF(NETDEV_UP): v2a: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): v2a: link becomes ready
<6>ADDRCONF(NETDEV_CHANGE): v1a: link becomes ready
<6>ADDRCONF(NETDEV_UP): v1a: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): v1a: link becomes ready
<6>ADDRCONF(NETDEV_UP): v2a: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): v2a: link becomes ready
<6>ADDRCONF(NETDEV_CHANGE): v1a: link becomes ready
<7>v2b: no IPv6 routers present
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth4: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth4: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth5: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth5: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth4: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth4: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth5: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth5: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth4: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth4: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth5: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth5: link becomes ready
<6>ADDRCONF(NETDEV_UP): e12: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): e12: link becomes ready
<6>ADDRCONF(NETDEV_UP): e1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): e1: link becomes ready
<6>lt-LinkQueueTes[26385]: segfault at 5 ip 00000000f777f26a sp 00000000ffc82228 error 4 in libtacC.so.0.0.0[f7763000+41000]
<6>lt-HashMapItera[26766]: segfault at 0 ip 00000000f76ca4c7 sp 00000000ffd1c034 error 4 in libtacC.so.0.0.0[f76ae000+41000]
<6>lt-HashMapItera[26769]: segfault at 0 ip 00000000f76ca731 sp 00000000ffd1c040 error 4 in libtacC.so.0.0.0[f76ae000+41000]
<6>lt-LinkQueueIte[26832]: segfault at 0 ip 00000000f776a814 sp 00000000ff98c18c error 4 in libtacC.so.0.0.0[f774f000+41000]
<6>lt-LinkQueueIte[26835]: segfault at 0 ip 00000000f776a82d sp 00000000ff98c18c error 4 in libtacC.so.0.0.0[f774f000+41000]
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<6>device lo entered promiscuous mode
<6>device lo left promiscuous mode
<4>modprobe used greatest stack depth: 3648 bytes left
<6>device etba1-et8 entered promiscuous mode
<6>device etba1-et9 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>device etba1-et6 entered promiscuous mode
<6>device etba1-et7 entered promiscuous mode
<6>device etba1-et4 entered promiscuous mode
<6>device etba1-et5 entered promiscuous mode
<6>device etba1-et21 entered promiscuous mode
<6>device etba1-et15 entered promiscuous mode
<6>device etba1-et16 entered promiscuous mode
<6>device etba1-et22 entered promiscuous mode
<6>device etba1-et24 entered promiscuous mode
<6>device etba1-et18 entered promiscuous mode
<6>device etba1-et19 entered promiscuous mode
<6>device etba1-et14 entered promiscuous mode
<6>device etba1-et20 entered promiscuous mode
<6>device etba1-et23 entered promiscuous mode
<6>device etba1-et17 entered promiscuous mode
<6>device etba1-et10 entered promiscuous mode
<6>device etba1-et11 entered promiscuous mode
<6>device etba1-et12 entered promiscuous mode
<6>device etba1-et13 entered promiscuous mode
<6>device etba1-et8 left promiscuous mode
<6>device etba1-et9 left promiscuous mode
<6>device etba1-et2 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device etba1-et1 left promiscuous mode
<6>device etba1-et6 left promiscuous mode
<6>device etba1-et7 left promiscuous mode
<6>device etba1-et4 left promiscuous mode
<6>device etba1-et5 left promiscuous mode
<6>device etba1-et14 left promiscuous mode
<6>device etba1-et15 left promiscuous mode
<6>device etba1-et23 left promiscuous mode
<6>device etba1-et17 left promiscuous mode
<6>device etba1-et24 left promiscuous mode
<6>device etba1-et18 left promiscuous mode
<6>device etba1-et19 left promiscuous mode
<6>device etba1-et21 left promiscuous mode
<6>device etba1-et20 left promiscuous mode
<6>device etba1-et16 left promiscuous mode
<6>device etba1-et22 left promiscuous mode
<6>device etba1-et10 left promiscuous mode
<6>device etba1-et11 left promiscuous mode
<6>device etba1-et12 left promiscuous mode
<6>device etba1-et13 left promiscuous mode
<6>device etba1-et8 entered promiscuous mode
<6>device etba1-et9 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>device etba1-et6 entered promiscuous mode
<6>device etba1-et7 entered promiscuous mode
<6>device etba1-et4 entered promiscuous mode
<6>device etba1-et5 entered promiscuous mode
<6>device etba1-et21 entered promiscuous mode
<6>device etba1-et15 entered promiscuous mode
<6>device etba1-et16 entered promiscuous mode
<6>device etba1-et22 entered promiscuous mode
<6>device etba1-et24 entered promiscuous mode
<6>device etba1-et18 entered promiscuous mode
<6>device etba1-et19 entered promiscuous mode
<6>device etba1-et14 entered promiscuous mode
<6>device etba1-et20 entered promiscuous mode
<6>device etba1-et23 entered promiscuous mode
<6>device etba1-et17 entered promiscuous mode
<6>device etba1-et10 entered promiscuous mode
<6>device etba1-et11 entered promiscuous mode
<6>device etba1-et12 entered promiscuous mode
<6>device etba1-et13 entered promiscuous mode
<6>device etba1-et8 left promiscuous mode
<6>device etba1-et9 left promiscuous mode
<6>device etba1-et2 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device etba1-et1 left promiscuous mode
<6>device etba1-et6 left promiscuous mode
<6>device etba1-et7 left promiscuous mode
<6>device etba1-et4 left promiscuous mode
<6>device etba1-et5 left promiscuous mode
<6>device etba1-et14 left promiscuous mode
<6>device etba1-et15 left promiscuous mode
<6>device etba1-et23 left promiscuous mode
<6>device etba1-et17 left promiscuous mode
<6>device etba1-et24 left promiscuous mode
<6>device etba1-et18 left promiscuous mode
<6>device etba1-et19 left promiscuous mode
<6>device etba1-et21 left promiscuous mode
<6>device etba1-et20 left promiscuous mode
<6>device etba1-et16 left promiscuous mode
<6>device etba1-et22 left promiscuous mode
<6>device etba1-et10 left promiscuous mode
<6>device etba1-et11 left promiscuous mode
<6>device etba1-et12 left promiscuous mode
<6>device etba1-et13 left promiscuous mode
<6>device tap1260-1 entered promiscuous mode
<6>device tap1260-1 left promiscuous mode
<6>device etba1-et8 entered promiscuous mode
<6>device etba1-et9 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>device etba1-et6 entered promiscuous mode
<6>device etba1-et7 entered promiscuous mode
<6>device etba1-et4 entered promiscuous mode
<6>device etba1-et5 entered promiscuous mode
<6>device etba1-et21 entered promiscuous mode
<6>device etba1-et15 entered promiscuous mode
<6>device etba1-et16 entered promiscuous mode
<6>device etba1-et22 entered promiscuous mode
<6>device etba1-et24 entered promiscuous mode
<6>device etba1-et18 entered promiscuous mode
<6>device etba1-et19 entered promiscuous mode
<6>device etba1-et14 entered promiscuous mode
<6>device etba1-et20 entered promiscuous mode
<6>device etba1-et23 entered promiscuous mode
<6>device etba1-et17 entered promiscuous mode
<6>device etba1-et10 entered promiscuous mode
<6>device etba1-et11 entered promiscuous mode
<6>device etba1-et12 entered promiscuous mode
<6>device etba1-et13 entered promiscuous mode
<6>device etba1-et8 left promiscuous mode
<6>device etba1-et9 left promiscuous mode
<6>device etba1-et2 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device etba1-et1 left promiscuous mode
<6>device etba1-et6 left promiscuous mode
<6>device etba1-et7 left promiscuous mode
<6>device etba1-et4 left promiscuous mode
<6>device etba1-et5 left promiscuous mode
<6>device etba1-et14 left promiscuous mode
<6>device etba1-et15 left promiscuous mode
<6>device etba1-et23 left promiscuous mode
<6>device etba1-et17 left promiscuous mode
<6>device etba1-et24 left promiscuous mode
<6>device etba1-et18 left promiscuous mode
<6>device etba1-et19 left promiscuous mode
<6>device etba1-et21 left promiscuous mode
<6>device etba1-et20 left promiscuous mode
<6>device etba1-et16 left promiscuous mode
<6>device etba1-et22 left promiscuous mode
<6>device etba1-et10 left promiscuous mode
<6>device etba1-et11 left promiscuous mode
<6>device etba1-et12 left promiscuous mode
<6>device etba1-et13 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>device host2-e0 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device etba1-et8 entered promiscuous mode
<6>device etba1-et9 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>device etba1-et6 entered promiscuous mode
<6>device etba1-et7 entered promiscuous mode
<6>device etba1-et4 entered promiscuous mode
<6>device etba1-et5 entered promiscuous mode
<6>device etba1-et21 entered promiscuous mode
<6>device etba1-et15 entered promiscuous mode
<6>device etba1-et16 entered promiscuous mode
<6>device etba1-et22 entered promiscuous mode
<6>device etba1-et24 entered promiscuous mode
<6>device etba1-et18 entered promiscuous mode
<6>device etba1-et19 entered promiscuous mode
<6>device etba1-et14 entered promiscuous mode
<6>device etba1-et20 entered promiscuous mode
<6>device etba1-et23 entered promiscuous mode
<6>device etba1-et17 entered promiscuous mode
<6>device etba1-et10 entered promiscuous mode
<6>device etba1-et11 entered promiscuous mode
<6>device etba1-et12 entered promiscuous mode
<6>device etba1-et13 entered promiscuous mode
<6>device etba1-et8 left promiscuous mode
<6>device etba1-et9 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device etba1-et1 left promiscuous mode
<6>device etba1-et4 left promiscuous mode
<6>device etba1-et5 left promiscuous mode
<6>device etba1-et14 left promiscuous mode
<6>device etba1-et15 left promiscuous mode
<6>device etba1-et23 left promiscuous mode
<6>device etba1-et17 left promiscuous mode
<6>device etba1-et24 left promiscuous mode
<6>device etba1-et18 left promiscuous mode
<6>device etba1-et19 left promiscuous mode
<6>device etba1-et21 left promiscuous mode
<6>device etba1-et20 left promiscuous mode
<6>device etba1-et16 left promiscuous mode
<6>device etba1-et10 left promiscuous mode
<6>device etba1-et11 left promiscuous mode
<6>device etba1-et12 left promiscuous mode
<6>device etba1-et13 left promiscuous mode
<6>device etba1-et8 entered promiscuous mode
<6>device etba1-et9 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>device etba1-et6 entered promiscuous mode
<6>device etba1-et7 entered promiscuous mode
<6>device etba1-et4 entered promiscuous mode
<6>device etba1-et5 entered promiscuous mode
<6>device etba1-et21 entered promiscuous mode
<6>device etba1-et15 entered promiscuous mode
<6>device etba1-et16 entered promiscuous mode
<6>device etba1-et22 entered promiscuous mode
<6>device etba1-et24 entered promiscuous mode
<6>device etba1-et18 entered promiscuous mode
<6>device etba1-et19 entered promiscuous mode
<6>device etba1-et14 entered promiscuous mode
<6>device etba1-et20 entered promiscuous mode
<6>device etba1-et23 entered promiscuous mode
<6>device etba1-et17 entered promiscuous mode
<6>device etba1-et10 entered promiscuous mode
<6>device etba1-et11 entered promiscuous mode
<6>device etba1-et12 entered promiscuous mode
<6>device etba1-et13 entered promiscuous mode
<7>lacpreconverge1: no IPv6 routers present
<7>lacpreconverge2: no IPv6 routers present
<6>device etba1-et8 entered promiscuous mode
<6>device etba1-et9 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>device etba1-et6 entered promiscuous mode
<6>device etba1-et7 entered promiscuous mode
<6>device etba1-et4 entered promiscuous mode
<6>device etba1-et5 entered promiscuous mode
<6>device etba1-et21 entered promiscuous mode
<6>device etba1-et15 entered promiscuous mode
<6>device etba1-et16 entered promiscuous mode
<6>device etba1-et22 entered promiscuous mode
<6>device etba1-et24 entered promiscuous mode
<6>device etba1-et18 entered promiscuous mode
<6>device etba1-et19 entered promiscuous mode
<6>device etba1-et14 entered promiscuous mode
<6>device etba1-et20 entered promiscuous mode
<6>device etba1-et23 entered promiscuous mode
<6>device etba1-et17 entered promiscuous mode
<6>device etba1-et10 entered promiscuous mode
<6>device etba1-et11 entered promiscuous mode
<6>device etba1-et12 entered promiscuous mode
<6>device etba1-et13 entered promiscuous mode
<6>device etba1-et8 left promiscuous mode
<6>device etba1-et9 left promiscuous mode
<6>device etba1-et2 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device etba1-et1 left promiscuous mode
<6>device etba1-et7 left promiscuous mode
<6>device etba1-et4 left promiscuous mode
<6>device etba1-et5 left promiscuous mode
<6>device etba1-et14 left promiscuous mode
<6>device etba1-et23 left promiscuous mode
<6>device etba1-et17 left promiscuous mode
<6>device etba1-et18 left promiscuous mode
<6>device etba1-et19 left promiscuous mode
<6>device etba1-et21 left promiscuous mode
<6>device etba1-et20 left promiscuous mode
<6>device etba1-et16 left promiscuous mode
<6>device etba1-et22 left promiscuous mode
<6>device etba1-et10 left promiscuous mode
<6>device etba1-et11 left promiscuous mode
<6>device etba1-et12 left promiscuous mode
<6>device etba1-et8 entered promiscuous mode
<6>device etba1-et9 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>device etba1-et6 entered promiscuous mode
<6>device etba1-et7 entered promiscuous mode
<6>device etba1-et4 entered promiscuous mode
<6>device etba1-et5 entered promiscuous mode
<6>device etba1-et21 entered promiscuous mode
<6>device etba1-et15 entered promiscuous mode
<6>device etba1-et16 entered promiscuous mode
<6>device etba1-et22 entered promiscuous mode
<6>device etba1-et24 entered promiscuous mode
<6>device etba1-et18 entered promiscuous mode
<6>device etba1-et19 entered promiscuous mode
<6>device etba1-et14 entered promiscuous mode
<6>device etba1-et20 entered promiscuous mode
<6>device etba1-et23 entered promiscuous mode
<6>device etba1-et17 entered promiscuous mode
<6>device etba1-et10 entered promiscuous mode
<6>device etba1-et11 entered promiscuous mode
<6>device etba1-et12 entered promiscuous mode
<6>device etba1-et13 entered promiscuous mode
<6>device acl1-et8 entered promiscuous mode
<6>device acl1-et9 entered promiscuous mode
<6>device acl1-et2 entered promiscuous mode
<6>device acl1-et3 entered promiscuous mode
<6>device acl1-et1 entered promiscuous mode
<6>device acl1-et6 entered promiscuous mode
<6>device acl1-et7 entered promiscuous mode
<6>device acl1-et4 entered promiscuous mode
<6>device acl1-et5 entered promiscuous mode
<6>device acl1-et21 entered promiscuous mode
<6>device acl1-et15 entered promiscuous mode
<6>device acl1-et16 entered promiscuous mode
<6>device acl1-et22 entered promiscuous mode
<6>device acl1-et24 entered promiscuous mode
<6>device acl1-et18 entered promiscuous mode
<6>device acl1-et19 entered promiscuous mode
<6>device acl1-et14 entered promiscuous mode
<6>device acl1-et20 entered promiscuous mode
<6>device acl1-et23 entered promiscuous mode
<6>device acl1-et17 entered promiscuous mode
<6>device acl1-et10 entered promiscuous mode
<6>device acl1-et11 entered promiscuous mode
<6>device acl1-et12 entered promiscuous mode
<6>device acl1-et13 entered promiscuous mode
<6>device acl1-et8 entered promiscuous mode
<6>device acl1-et9 entered promiscuous mode
<6>device acl1-et2 entered promiscuous mode
<6>device acl1-et3 entered promiscuous mode
<6>device acl1-et1 entered promiscuous mode
<6>device acl1-et6 entered promiscuous mode
<6>device acl1-et7 entered promiscuous mode
<6>device acl1-et4 entered promiscuous mode
<6>device acl1-et5 entered promiscuous mode
<6>device acl1-et21 entered promiscuous mode
<6>device acl1-et15 entered promiscuous mode
<6>device acl1-et16 entered promiscuous mode
<6>device acl1-et22 entered promiscuous mode
<6>device acl1-et24 entered promiscuous mode
<6>device acl1-et18 entered promiscuous mode
<6>device acl1-et19 entered promiscuous mode
<6>device acl1-et14 entered promiscuous mode
<6>device acl1-et20 entered promiscuous mode
<6>device acl1-et23 entered promiscuous mode
<6>device acl1-et17 entered promiscuous mode
<6>device acl1-et10 entered promiscuous mode
<6>device acl1-et11 entered promiscuous mode
<6>device acl1-et12 entered promiscuous mode
<6>device acl1-et13 entered promiscuous mode
<6>device acl1-et8 left promiscuous mode
<6>device acl1-et9 left promiscuous mode
<6>device acl1-et2 left promiscuous mode
<6>device acl1-et3 left promiscuous mode
<6>device acl1-et1 left promiscuous mode
<6>device acl1-et6 left promiscuous mode
<6>device acl1-et7 left promiscuous mode
<6>device acl1-et4 left promiscuous mode
<6>device acl1-et5 left promiscuous mode
<6>device acl1-et14 left promiscuous mode
<6>device acl1-et15 left promiscuous mode
<6>device acl1-et23 left promiscuous mode
<6>device acl1-et17 left promiscuous mode
<6>device acl1-et24 left promiscuous mode
<6>device acl1-et18 left promiscuous mode
<6>device acl1-et19 left promiscuous mode
<6>device acl1-et21 left promiscuous mode
<6>device acl1-et20 left promiscuous mode
<6>device acl1-et16 left promiscuous mode
<6>device acl1-et22 left promiscuous mode
<6>device acl1-et10 left promiscuous mode
<6>device acl1-et11 left promiscuous mode
<6>device acl1-et12 left promiscuous mode
<6>device acl1-et13 left promiscuous mode
<6>device acl1-et8 left promiscuous mode
<6>device acl1-et9 left promiscuous mode
<6>device acl1-et2 left promiscuous mode
<6>device acl1-et3 left promiscuous mode
<6>device acl1-et1 left promiscuous mode
<6>device acl1-et6 left promiscuous mode
<6>device acl1-et7 left promiscuous mode
<6>device acl1-et4 left promiscuous mode
<6>device acl1-et5 left promiscuous mode
<6>device acl1-et14 left promiscuous mode
<6>device acl1-et15 left promiscuous mode
<6>device acl1-et23 left promiscuous mode
<6>device acl1-et17 left promiscuous mode
<6>device acl1-et24 left promiscuous mode
<6>device acl1-et18 left promiscuous mode
<6>device acl1-et19 left promiscuous mode
<6>device acl1-et21 left promiscuous mode
<6>device acl1-et20 left promiscuous mode
<6>device acl1-et16 left promiscuous mode
<6>device acl1-et22 left promiscuous mode
<6>device acl1-et10 left promiscuous mode
<6>device acl1-et11 left promiscuous mode
<6>device acl1-et12 left promiscuous mode
<6>device acl1-et13 left promiscuous mode
<6>device acl1-et8 entered promiscuous mode
<6>device acl1-et9 entered promiscuous mode
<6>device acl1-et2 entered promiscuous mode
<6>device acl1-et3 entered promiscuous mode
<6>device acl1-et1 entered promiscuous mode
<6>device acl1-et6 entered promiscuous mode
<6>device acl1-et7 entered promiscuous mode
<6>device acl1-et4 entered promiscuous mode
<6>device acl1-et5 entered promiscuous mode
<6>device acl1-et21 entered promiscuous mode
<6>device acl1-et15 entered promiscuous mode
<6>device acl1-et16 entered promiscuous mode
<6>device acl1-et22 entered promiscuous mode
<6>device acl1-et24 entered promiscuous mode
<6>device acl1-et18 entered promiscuous mode
<6>device acl1-et19 entered promiscuous mode
<6>device acl1-et14 entered promiscuous mode
<6>device acl1-et20 entered promiscuous mode
<6>device acl1-et23 entered promiscuous mode
<6>device acl1-et17 entered promiscuous mode
<6>device acl1-et10 entered promiscuous mode
<6>device acl1-et11 entered promiscuous mode
<6>device acl1-et12 entered promiscuous mode
<6>device acl1-et13 entered promiscuous mode
<6>device acl1-et8 left promiscuous mode
<6>device acl1-et9 left promiscuous mode
<6>device acl1-et2 left promiscuous mode
<6>device acl1-et3 left promiscuous mode
<6>device acl1-et1 left promiscuous mode
<6>device acl1-et6 left promiscuous mode
<6>device acl1-et7 left promiscuous mode
<6>device acl1-et4 left promiscuous mode
<6>device acl1-et5 left promiscuous mode
<6>device acl1-et14 left promiscuous mode
<6>device acl1-et15 left promiscuous mode
<6>device acl1-et23 left promiscuous mode
<6>device acl1-et17 left promiscuous mode
<6>device acl1-et24 left promiscuous mode
<6>device acl1-et18 left promiscuous mode
<6>device acl1-et19 left promiscuous mode
<6>device acl1-et21 left promiscuous mode
<6>device acl1-et20 left promiscuous mode
<6>device acl1-et16 left promiscuous mode
<6>device acl1-et22 left promiscuous mode
<6>device acl1-et10 left promiscuous mode
<6>device acl1-et11 left promiscuous mode
<6>device acl1-et12 left promiscuous mode
<6>device acl1-et13 left promiscuous mode
<6>device acl1-et8 entered promiscuous mode
<6>device acl1-et9 entered promiscuous mode
<6>device acl1-et2 entered promiscuous mode
<6>device acl1-et3 entered promiscuous mode
<6>device acl1-et1 entered promiscuous mode
<6>device acl1-et6 entered promiscuous mode
<6>device acl1-et7 entered promiscuous mode
<6>device acl1-et4 entered promiscuous mode
<6>device acl1-et5 entered promiscuous mode
<6>device acl1-et21 entered promiscuous mode
<6>device acl1-et15 entered promiscuous mode
<6>device acl1-et16 entered promiscuous mode
<6>device acl1-et22 entered promiscuous mode
<6>device acl1-et24 entered promiscuous mode
<6>device acl1-et18 entered promiscuous mode
<6>device acl1-et19 entered promiscuous mode
<6>device acl1-et14 entered promiscuous mode
<6>device acl1-et20 entered promiscuous mode
<6>device acl1-et23 entered promiscuous mode
<6>device acl1-et17 entered promiscuous mode
<6>device acl1-et10 entered promiscuous mode
<6>device acl1-et11 entered promiscuous mode
<6>device acl1-et12 entered promiscuous mode
<6>device acl1-et13 entered promiscuous mode
<6>device acl1-et8 entered promiscuous mode
<6>device acl1-et9 entered promiscuous mode
<6>device acl1-et2 entered promiscuous mode
<6>device acl1-et3 entered promiscuous mode
<6>device acl1-et1 entered promiscuous mode
<6>device acl1-et6 entered promiscuous mode
<6>device acl1-et7 entered promiscuous mode
<6>device acl1-et4 entered promiscuous mode
<6>device acl1-et5 entered promiscuous mode
<6>device acl1-et21 entered promiscuous mode
<6>device acl1-et15 entered promiscuous mode
<6>device acl1-et16 entered promiscuous mode
<6>device acl1-et22 entered promiscuous mode
<6>device acl1-et24 entered promiscuous mode
<6>device acl1-et18 entered promiscuous mode
<6>device acl1-et19 entered promiscuous mode
<6>device acl1-et14 entered promiscuous mode
<6>device acl1-et20 entered promiscuous mode
<6>device acl1-et23 entered promiscuous mode
<6>device acl1-et17 entered promiscuous mode
<6>device acl1-et10 entered promiscuous mode
<6>device acl1-et11 entered promiscuous mode
<6>device acl1-et12 entered promiscuous mode
<6>device acl1-et13 entered promiscuous mode
<6>device acl1-et8 left promiscuous mode
<6>device acl1-et9 left promiscuous mode
<6>device acl1-et2 left promiscuous mode
<6>device acl1-et3 left promiscuous mode
<6>device acl1-et1 left promiscuous mode
<6>device acl1-et6 left promiscuous mode
<6>device acl1-et7 left promiscuous mode
<6>device acl1-et4 left promiscuous mode
<6>device acl1-et5 left promiscuous mode
<6>device acl1-et14 left promiscuous mode
<6>device acl1-et15 left promiscuous mode
<6>device acl1-et23 left promiscuous mode
<6>device acl1-et17 left promiscuous mode
<6>device acl1-et24 left promiscuous mode
<6>device acl1-et18 left promiscuous mode
<6>device acl1-et19 left promiscuous mode
<6>device acl1-et21 left promiscuous mode
<6>device acl1-et20 left promiscuous mode
<6>device acl1-et16 left promiscuous mode
<6>device acl1-et22 left promiscuous mode
<6>device acl1-et10 left promiscuous mode
<6>device acl1-et11 left promiscuous mode
<6>device acl1-et12 left promiscuous mode
<6>device acl1-et13 left promiscuous mode
<6>device acl1-et8 left promiscuous mode
<6>device acl1-et9 left promiscuous mode
<6>device acl1-et2 left promiscuous mode
<6>device acl1-et3 left promiscuous mode
<6>device acl1-et1 left promiscuous mode
<6>device acl1-et6 left promiscuous mode
<6>device acl1-et7 left promiscuous mode
<6>device acl1-et4 left promiscuous mode
<6>device acl1-et5 left promiscuous mode
<6>device acl1-et14 left promiscuous mode
<6>device acl1-et15 left promiscuous mode
<6>device acl1-et23 left promiscuous mode
<6>device acl1-et17 left promiscuous mode
<6>device acl1-et24 left promiscuous mode
<6>device acl1-et18 left promiscuous mode
<6>device acl1-et19 left promiscuous mode
<6>device acl1-et21 left promiscuous mode
<6>device acl1-et20 left promiscuous mode
<6>device acl1-et16 left promiscuous mode
<6>device acl1-et22 left promiscuous mode
<6>device acl1-et10 left promiscuous mode
<6>device acl1-et11 left promiscuous mode
<6>device acl1-et12 left promiscuous mode
<6>device acl1-et13 left promiscuous mode
<6>device acl1-et8 entered promiscuous mode
<6>device acl1-et9 entered promiscuous mode
<6>device acl1-et2 entered promiscuous mode
<6>device acl1-et3 entered promiscuous mode
<6>device acl1-et1 entered promiscuous mode
<6>device acl1-et6 entered promiscuous mode
<6>device acl1-et7 entered promiscuous mode
<6>device acl1-et4 entered promiscuous mode
<6>device acl1-et5 entered promiscuous mode
<6>device acl1-et21 entered promiscuous mode
<6>device acl1-et15 entered promiscuous mode
<6>device acl1-et16 entered promiscuous mode
<6>device acl1-et22 entered promiscuous mode
<6>device acl1-et24 entered promiscuous mode
<6>device acl1-et18 entered promiscuous mode
<6>device acl1-et19 entered promiscuous mode
<6>device acl1-et14 entered promiscuous mode
<6>device acl1-et20 entered promiscuous mode
<6>device acl1-et23 entered promiscuous mode
<6>device acl1-et17 entered promiscuous mode
<6>device acl1-et10 entered promiscuous mode
<6>device acl1-et11 entered promiscuous mode
<6>device acl1-et12 entered promiscuous mode
<6>device acl1-et13 entered promiscuous mode
<6>device acl1-et8 entered promiscuous mode
<6>device acl1-et9 entered promiscuous mode
<6>device acl1-et2 entered promiscuous mode
<6>device acl1-et3 entered promiscuous mode
<6>device acl1-et1 entered promiscuous mode
<6>device acl1-et6 entered promiscuous mode
<6>device acl1-et7 entered promiscuous mode
<6>device acl1-et4 entered promiscuous mode
<6>device acl1-et5 entered promiscuous mode
<6>device acl1-et21 entered promiscuous mode
<6>device acl1-et15 entered promiscuous mode
<6>device acl1-et16 entered promiscuous mode
<6>device acl1-et22 entered promiscuous mode
<6>device acl1-et24 entered promiscuous mode
<6>device acl1-et18 entered promiscuous mode
<6>device acl1-et19 entered promiscuous mode
<6>device acl1-et14 entered promiscuous mode
<6>device acl1-et20 entered promiscuous mode
<6>device acl1-et23 entered promiscuous mode
<6>device acl1-et17 entered promiscuous mode
<6>device acl1-et10 entered promiscuous mode
<6>device acl1-et11 entered promiscuous mode
<6>device acl1-et12 entered promiscuous mode
<6>device acl1-et13 entered promiscuous mode
<6>device acl1-et8 left promiscuous mode
<6>device acl1-et9 left promiscuous mode
<6>device acl1-et2 left promiscuous mode
<6>device acl1-et3 left promiscuous mode
<6>device acl1-et1 left promiscuous mode
<6>device acl1-et6 left promiscuous mode
<6>device acl1-et7 left promiscuous mode
<6>device acl1-et4 left promiscuous mode
<6>device acl1-et5 left promiscuous mode
<6>device acl1-et14 left promiscuous mode
<6>device acl1-et15 left promiscuous mode
<6>device acl1-et23 left promiscuous mode
<6>device acl1-et17 left promiscuous mode
<6>device acl1-et24 left promiscuous mode
<6>device acl1-et18 left promiscuous mode
<6>device acl1-et19 left promiscuous mode
<6>device acl1-et21 left promiscuous mode
<6>device acl1-et20 left promiscuous mode
<6>device acl1-et16 left promiscuous mode
<6>device acl1-et22 left promiscuous mode
<6>device acl1-et10 left promiscuous mode
<6>device acl1-et11 left promiscuous mode
<6>device acl1-et12 left promiscuous mode
<6>device acl1-et13 left promiscuous mode
<6>device acl1-et8 left promiscuous mode
<6>device acl1-et9 left promiscuous mode
<6>device acl1-et2 left promiscuous mode
<6>device acl1-et3 left promiscuous mode
<6>device acl1-et1 left promiscuous mode
<6>device acl1-et6 left promiscuous mode
<6>device acl1-et7 left promiscuous mode
<6>device acl1-et4 left promiscuous mode
<6>device acl1-et5 left promiscuous mode
<6>device acl1-et14 left promiscuous mode
<6>device acl1-et15 left promiscuous mode
<6>device acl1-et23 left promiscuous mode
<6>device acl1-et17 left promiscuous mode
<6>device acl1-et24 left promiscuous mode
<6>device acl1-et18 left promiscuous mode
<6>device acl1-et19 left promiscuous mode
<6>device acl1-et21 left promiscuous mode
<6>device acl1-et20 left promiscuous mode
<6>device acl1-et16 left promiscuous mode
<6>device acl1-et22 left promiscuous mode
<6>device acl1-et10 left promiscuous mode
<6>device acl1-et11 left promiscuous mode
<6>device acl1-et12 left promiscuous mode
<6>device acl1-et13 left promiscuous mode
<6>device acl1-et8 entered promiscuous mode
<6>device acl1-et9 entered promiscuous mode
<6>device acl1-et2 entered promiscuous mode
<6>device acl1-et3 entered promiscuous mode
<6>device acl1-et1 entered promiscuous mode
<6>device acl1-et6 entered promiscuous mode
<6>device acl1-et7 entered promiscuous mode
<6>device acl1-et4 entered promiscuous mode
<6>device acl1-et5 entered promiscuous mode
<6>device acl1-et21 entered promiscuous mode
<6>device acl1-et15 entered promiscuous mode
<6>device acl1-et16 entered promiscuous mode
<6>device acl1-et22 entered promiscuous mode
<6>device acl1-et24 entered promiscuous mode
<6>device acl1-et18 entered promiscuous mode
<6>device acl1-et19 entered promiscuous mode
<6>device acl1-et14 entered promiscuous mode
<6>device acl1-et20 entered promiscuous mode
<6>device acl1-et23 entered promiscuous mode
<6>device acl1-et17 entered promiscuous mode
<6>device acl1-et10 entered promiscuous mode
<6>device acl1-et11 entered promiscuous mode
<6>device acl1-et12 entered promiscuous mode
<6>device acl1-et13 entered promiscuous mode
<6>device etba1-et9 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device etba1-et6 left promiscuous mode
<6>device etba1-et7 left promiscuous mode
<6>device etba1-et4 left promiscuous mode
<6>device etba1-et5 left promiscuous mode
<6>device etba1-et14 left promiscuous mode
<6>device etba1-et15 left promiscuous mode
<6>device etba1-et23 left promiscuous mode
<6>device etba1-et17 left promiscuous mode
<6>device etba1-et24 left promiscuous mode
<6>device etba1-et18 left promiscuous mode
<6>device etba1-et19 left promiscuous mode
<6>device etba1-et21 left promiscuous mode
<6>device etba1-et20 left promiscuous mode
<6>device etba1-et22 left promiscuous mode
<6>device etba1-et10 left promiscuous mode
<6>device etba1-et11 left promiscuous mode
<6>device etba1-et12 left promiscuous mode
<6>device etba1-et13 left promiscuous mode
<6>device acl1-et8 left promiscuous mode
<6>device acl1-et9 left promiscuous mode
<6>device acl1-et2 left promiscuous mode
<6>device acl1-et3 left promiscuous mode
<6>device acl1-et1 left promiscuous mode
<6>device acl1-et6 left promiscuous mode
<6>device acl1-et7 left promiscuous mode
<6>device acl1-et4 left promiscuous mode
<6>device acl1-et5 left promiscuous mode
<6>device acl1-et14 left promiscuous mode
<6>device acl1-et15 left promiscuous mode
<6>device acl1-et23 left promiscuous mode
<6>device acl1-et17 left promiscuous mode
<6>device acl1-et24 left promiscuous mode
<6>device acl1-et18 left promiscuous mode
<6>device acl1-et19 left promiscuous mode
<6>device acl1-et21 left promiscuous mode
<6>device acl1-et20 left promiscuous mode
<6>device acl1-et16 left promiscuous mode
<6>device acl1-et22 left promiscuous mode
<6>device acl1-et10 left promiscuous mode
<6>device acl1-et11 left promiscuous mode
<6>device acl1-et12 left promiscuous mode
<6>device acl1-et13 left promiscuous mode
<6>device acl1-et8 entered promiscuous mode
<6>device acl1-et9 entered promiscuous mode
<6>device acl1-et2 entered promiscuous mode
<6>device acl1-et3 entered promiscuous mode
<6>device acl1-et1 entered promiscuous mode
<6>device acl1-et6 entered promiscuous mode
<6>device acl1-et7 entered promiscuous mode
<6>device acl1-et4 entered promiscuous mode
<6>device acl1-et5 entered promiscuous mode
<6>device acl1-et21 entered promiscuous mode
<6>device acl1-et15 entered promiscuous mode
<6>device acl1-et16 entered promiscuous mode
<6>device acl1-et22 entered promiscuous mode
<6>device acl1-et24 entered promiscuous mode
<6>device acl1-et18 entered promiscuous mode
<6>device acl1-et19 entered promiscuous mode
<6>device acl1-et14 entered promiscuous mode
<6>device acl1-et20 entered promiscuous mode
<6>device acl1-et23 entered promiscuous mode
<6>device acl1-et17 entered promiscuous mode
<6>device acl1-et10 entered promiscuous mode
<6>device acl1-et11 entered promiscuous mode
<6>device acl1-et12 entered promiscuous mode
<6>device acl1-et13 entered promiscuous mode
<6>device acl1-et8 left promiscuous mode
<6>device acl1-et9 left promiscuous mode
<6>device acl1-et2 left promiscuous mode
<6>device acl1-et3 left promiscuous mode
<6>device acl1-et1 left promiscuous mode
<6>device acl1-et6 left promiscuous mode
<6>device acl1-et7 left promiscuous mode
<6>device acl1-et4 left promiscuous mode
<6>device acl1-et5 left promiscuous mode
<6>device acl1-et14 left promiscuous mode
<6>device acl1-et15 left promiscuous mode
<6>device acl1-et23 left promiscuous mode
<6>device acl1-et17 left promiscuous mode
<6>device acl1-et24 left promiscuous mode
<6>device acl1-et18 left promiscuous mode
<6>device acl1-et19 left promiscuous mode
<6>device acl1-et21 left promiscuous mode
<6>device acl1-et20 left promiscuous mode
<6>device acl1-et16 left promiscuous mode
<6>device acl1-et22 left promiscuous mode
<6>device acl1-et10 left promiscuous mode
<6>device acl1-et11 left promiscuous mode
<6>device acl1-et12 left promiscuous mode
<6>device acl1-et13 left promiscuous mode
<7>rstpeleventap1: no IPv6 routers present
<7>rstpeleventap2: no IPv6 routers present
<7>rstpeleventap4: no IPv6 routers present
<7>rstpeleventap3: no IPv6 routers present
<7>tap30-1: no IPv6 routers present
<7>tap30-3: no IPv6 routers present
<7>tap30-2: no IPv6 routers present
<7>tap30-3: no IPv6 routers present
<7>tap30-4: no IPv6 routers present
<7>tap30-2: no IPv6 routers present
<7>tap30-1: no IPv6 routers present
<7>tap30-2: no IPv6 routers present
<7>tap30-1: no IPv6 routers present
<7>tap30-3: no IPv6 routers present
<7>tap30-4: no IPv6 routers present
<6>device etba1-et8 entered promiscuous mode
<6>device etba1-et9 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>device etba1-et6 entered promiscuous mode
<6>device etba1-et7 entered promiscuous mode
<6>device etba1-et4 entered promiscuous mode
<6>device etba1-et5 entered promiscuous mode
<6>device etba1-et21 entered promiscuous mode
<6>device etba1-et15 entered promiscuous mode
<6>device etba1-et16 entered promiscuous mode
<6>device etba1-et22 entered promiscuous mode
<6>device etba1-et24 entered promiscuous mode
<6>device etba1-et18 entered promiscuous mode
<6>device etba1-et19 entered promiscuous mode
<6>device etba1-et14 entered promiscuous mode
<6>device etba1-et20 entered promiscuous mode
<6>device etba1-et23 entered promiscuous mode
<6>device etba1-et17 entered promiscuous mode
<6>device etba1-et10 entered promiscuous mode
<6>device etba1-et11 entered promiscuous mode
<6>device etba1-et12 entered promiscuous mode
<6>device etba1-et13 entered promiscuous mode
<6>device etba1-et8 entered promiscuous mode
<6>device etba1-et9 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>device etba1-et6 entered promiscuous mode
<6>device etba1-et7 entered promiscuous mode
<6>device etba1-et4 entered promiscuous mode
<6>device etba1-et5 entered promiscuous mode
<6>device etba1-et21 entered promiscuous mode
<6>device etba1-et15 entered promiscuous mode
<6>device etba1-et16 entered promiscuous mode
<6>device etba1-et22 entered promiscuous mode
<6>device etba1-et24 entered promiscuous mode
<6>device etba1-et18 entered promiscuous mode
<6>device etba1-et19 entered promiscuous mode
<6>device etba1-et14 entered promiscuous mode
<6>device etba1-et20 entered promiscuous mode
<6>device etba1-et23 entered promiscuous mode
<6>device etba1-et17 entered promiscuous mode
<6>device etba1-et10 entered promiscuous mode
<6>device etba1-et11 entered promiscuous mode
<6>device etba1-et12 entered promiscuous mode
<6>device etba1-et13 entered promiscuous mode
<4>python used greatest stack depth: 3472 bytes left
<6>device etba1-et8 left promiscuous mode
<6>device etba1-et9 left promiscuous mode
<6>device etba1-et2 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device etba1-et1 left promiscuous mode
<6>device etba1-et6 left promiscuous mode
<6>device etba1-et7 left promiscuous mode
<6>device etba1-et4 left promiscuous mode
<6>device etba1-et5 left promiscuous mode
<6>device etba1-et14 left promiscuous mode
<6>device etba1-et15 left promiscuous mode
<6>device etba1-et23 left promiscuous mode
<6>device etba1-et17 left promiscuous mode
<6>device etba1-et24 left promiscuous mode
<6>device etba1-et18 left promiscuous mode
<6>device etba1-et19 left promiscuous mode
<6>device etba1-et21 left promiscuous mode
<6>device etba1-et20 left promiscuous mode
<6>device etba1-et16 left promiscuous mode
<6>device etba1-et22 left promiscuous mode
<6>device etba1-et10 left promiscuous mode
<6>device etba1-et11 left promiscuous mode
<6>device etba1-et12 left promiscuous mode
<6>device etba1-et13 left promiscuous mode
<6>device etba1-et8 entered promiscuous mode
<6>device etba1-et9 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>device etba1-et6 entered promiscuous mode
<6>device etba1-et7 entered promiscuous mode
<6>device etba1-et4 entered promiscuous mode
<6>device etba1-et5 entered promiscuous mode
<6>device etba1-et21 entered promiscuous mode
<6>device etba1-et15 entered promiscuous mode
<6>device etba1-et16 entered promiscuous mode
<6>device etba1-et22 entered promiscuous mode
<6>device etba1-et24 entered promiscuous mode
<6>device etba1-et18 entered promiscuous mode
<6>device etba1-et19 entered promiscuous mode
<6>device etba1-et14 entered promiscuous mode
<6>device etba1-et20 entered promiscuous mode
<6>device etba1-et23 entered promiscuous mode
<6>device etba1-et17 entered promiscuous mode
<6>device etba1-et10 entered promiscuous mode
<6>device etba1-et11 entered promiscuous mode
<6>device etba1-et12 entered promiscuous mode
<6>device etba1-et13 entered promiscuous mode
<6>device etba1-et8 left promiscuous mode
<6>device etba1-et9 left promiscuous mode
<6>device etba1-et2 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device etba1-et1 left promiscuous mode
<6>device etba1-et6 left promiscuous mode
<6>device etba1-et7 left promiscuous mode
<6>device etba1-et4 left promiscuous mode
<6>device etba1-et5 left promiscuous mode
<6>device etba1-et14 left promiscuous mode
<6>device etba1-et15 left promiscuous mode
<6>device etba1-et23 left promiscuous mode
<6>device etba1-et17 left promiscuous mode
<6>device etba1-et24 left promiscuous mode
<6>device etba1-et18 left promiscuous mode
<6>device etba1-et19 left promiscuous mode
<6>device etba1-et21 left promiscuous mode
<6>device etba1-et20 left promiscuous mode
<6>device etba1-et16 left promiscuous mode
<6>device etba1-et22 left promiscuous mode
<6>device etba1-et10 left promiscuous mode
<6>device etba1-et11 left promiscuous mode
<6>device etba1-et12 left promiscuous mode
<6>device etba1-et13 left promiscuous mode
<6>device etba1-et8 left promiscuous mode
<6>device etba1-et9 left promiscuous mode
<6>device etba1-et2 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device etba1-et1 left promiscuous mode
<6>device etba1-et6 left promiscuous mode
<6>device etba1-et7 left promiscuous mode
<6>device etba1-et4 left promiscuous mode
<6>device etba1-et5 left promiscuous mode
<6>device etba1-et14 left promiscuous mode
<6>device etba1-et15 left promiscuous mode
<6>device etba1-et23 left promiscuous mode
<6>device etba1-et17 left promiscuous mode
<6>device etba1-et24 left promiscuous mode
<6>device etba1-et18 left promiscuous mode
<6>device etba1-et19 left promiscuous mode
<6>device etba1-et21 left promiscuous mode
<6>device etba1-et20 left promiscuous mode
<6>device etba1-et16 left promiscuous mode
<6>device etba1-et22 left promiscuous mode
<6>device etba1-et10 left promiscuous mode
<6>device etba1-et11 left promiscuous mode
<6>device etba1-et12 left promiscuous mode
<6>device etba1-et13 left promiscuous mode
<6>device etba1-et8 entered promiscuous mode
<6>device etba1-et9 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>device etba1-et6 entered promiscuous mode
<6>device etba1-et7 entered promiscuous mode
<6>device etba1-et4 entered promiscuous mode
<6>device etba1-et5 entered promiscuous mode
<6>device etba1-et21 entered promiscuous mode
<6>device etba1-et15 entered promiscuous mode
<6>device etba1-et16 entered promiscuous mode
<6>device etba1-et22 entered promiscuous mode
<6>device etba1-et24 entered promiscuous mode
<6>device etba1-et18 entered promiscuous mode
<6>device etba1-et19 entered promiscuous mode
<6>device etba1-et14 entered promiscuous mode
<6>device etba1-et20 entered promiscuous mode
<6>device etba1-et23 entered promiscuous mode
<6>device etba1-et17 entered promiscuous mode
<6>device etba1-et10 entered promiscuous mode
<6>device etba1-et11 entered promiscuous mode
<6>device etba1-et12 entered promiscuous mode
<6>device etba1-et13 entered promiscuous mode
<6>device etba1-et8 entered promiscuous mode
<6>device etba1-et9 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>device etba1-et6 entered promiscuous mode
<6>device etba1-et7 entered promiscuous mode
<6>device etba1-et4 entered promiscuous mode
<6>device etba1-et5 entered promiscuous mode
<6>device etba1-et21 entered promiscuous mode
<6>device etba1-et15 entered promiscuous mode
<6>device etba1-et16 entered promiscuous mode
<6>device etba1-et22 entered promiscuous mode
<6>device etba1-et24 entered promiscuous mode
<6>device etba1-et18 entered promiscuous mode
<6>device etba1-et19 entered promiscuous mode
<6>device etba1-et14 entered promiscuous mode
<6>device etba1-et20 entered promiscuous mode
<6>device etba1-et23 entered promiscuous mode
<6>device etba1-et17 entered promiscuous mode
<6>device etba1-et10 entered promiscuous mode
<6>device etba1-et11 entered promiscuous mode
<6>device etba1-et12 entered promiscuous mode
<6>device etba1-et13 entered promiscuous mode
<6>device etba1-et8 left promiscuous mode
<6>device etba1-et9 left promiscuous mode
<6>device etba1-et2 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device etba1-et1 left promiscuous mode
<6>device etba1-et6 left promiscuous mode
<6>device etba1-et7 left promiscuous mode
<6>device etba1-et4 left promiscuous mode
<6>device etba1-et5 left promiscuous mode
<6>device etba1-et14 left promiscuous mode
<6>device etba1-et15 left promiscuous mode
<6>device etba1-et23 left promiscuous mode
<6>device etba1-et17 left promiscuous mode
<6>device etba1-et24 left promiscuous mode
<6>device etba1-et18 left promiscuous mode
<6>device etba1-et19 left promiscuous mode
<6>device etba1-et21 left promiscuous mode
<6>device etba1-et20 left promiscuous mode
<6>device etba1-et16 left promiscuous mode
<6>device etba1-et22 left promiscuous mode
<6>device etba1-et10 left promiscuous mode
<6>device etba1-et11 left promiscuous mode
<6>device etba1-et12 left promiscuous mode
<6>device etba1-et13 left promiscuous mode
<6>device etba1-et8 entered promiscuous mode
<6>device etba1-et9 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>device etba1-et6 entered promiscuous mode
<6>device etba1-et7 entered promiscuous mode
<6>device etba1-et4 entered promiscuous mode
<6>device etba1-et5 entered promiscuous mode
<6>device etba1-et21 entered promiscuous mode
<6>device etba1-et15 entered promiscuous mode
<6>device etba1-et16 entered promiscuous mode
<6>device etba1-et22 entered promiscuous mode
<6>device etba1-et24 entered promiscuous mode
<6>device etba1-et18 entered promiscuous mode
<6>device etba1-et19 entered promiscuous mode
<6>device etba1-et14 entered promiscuous mode
<6>device etba1-et20 entered promiscuous mode
<6>device etba1-et23 entered promiscuous mode
<6>device etba1-et17 entered promiscuous mode
<6>device etba1-et10 entered promiscuous mode
<6>device etba1-et11 entered promiscuous mode
<6>device etba1-et12 entered promiscuous mode
<6>device etba1-et13 entered promiscuous mode
<6>device etba1-et8 left promiscuous mode
<6>device etba1-et9 left promiscuous mode
<6>device etba1-et2 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device etba1-et1 left promiscuous mode
<6>device etba1-et6 left promiscuous mode
<6>device etba1-et7 left promiscuous mode
<6>device etba1-et4 left promiscuous mode
<6>device etba1-et5 left promiscuous mode
<6>device etba1-et14 left promiscuous mode
<6>device etba1-et15 left promiscuous mode
<6>device etba1-et23 left promiscuous mode
<6>device etba1-et17 left promiscuous mode
<6>device etba1-et24 left promiscuous mode
<6>device etba1-et18 left promiscuous mode
<6>device etba1-et19 left promiscuous mode
<6>device etba1-et21 left promiscuous mode
<6>device etba1-et20 left promiscuous mode
<6>device etba1-et16 left promiscuous mode
<6>device etba1-et22 left promiscuous mode
<6>device etba1-et10 left promiscuous mode
<6>device etba1-et11 left promiscuous mode
<6>device etba1-et12 left promiscuous mode
<6>device etba1-et13 left promiscuous mode
<6>device etba1-et8 left promiscuous mode
<6>device etba1-et9 left promiscuous mode
<6>device etba1-et2 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device etba1-et1 left promiscuous mode
<6>device etba1-et6 left promiscuous mode
<6>device etba1-et7 left promiscuous mode
<6>device etba1-et4 left promiscuous mode
<6>device etba1-et5 left promiscuous mode
<6>device etba1-et14 left promiscuous mode
<6>device etba1-et15 left promiscuous mode
<6>device etba1-et23 left promiscuous mode
<6>device etba1-et17 left promiscuous mode
<6>device etba1-et24 left promiscuous mode
<6>device etba1-et18 left promiscuous mode
<6>device etba1-et19 left promiscuous mode
<6>device etba1-et21 left promiscuous mode
<6>device etba1-et20 left promiscuous mode
<6>device etba1-et16 left promiscuous mode
<6>device etba1-et22 left promiscuous mode
<6>device etba1-et10 left promiscuous mode
<6>device etba1-et11 left promiscuous mode
<6>device etba1-et12 left promiscuous mode
<6>device etba1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host3-e0 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device host3-e0 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device host3-e0 entered promiscuous mode
<6>device host3-e1 entered promiscuous mode
<6>device host3-e1 left promiscuous mode
<6>device host3-e1 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host4-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device host5-e0 entered promiscuous mode
<6>device host5-e1 entered promiscuous mode
<6>device host5-e1 left promiscuous mode
<6>device host5-e1 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device host3-e1 left promiscuous mode
<6>device host4-e0 left promiscuous mode
<6>device host5-e1 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device host3-e0 entered promiscuous mode
<6>device host3-e1 entered promiscuous mode
<6>device host3-e1 left promiscuous mode
<6>device host3-e1 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host4-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device host5-e0 entered promiscuous mode
<6>device host5-e1 entered promiscuous mode
<6>device host5-e1 left promiscuous mode
<6>device host5-e1 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device host3-e1 left promiscuous mode
<6>device host4-e0 left promiscuous mode
<6>device host5-e1 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host3-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host4-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host5-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device host6-e0 entered promiscuous mode
<6>device host6-e1 entered promiscuous mode
<6>device host6-e1 left promiscuous mode
<6>device host6-e1 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device host7-e0 entered promiscuous mode
<6>device host7-e1 entered promiscuous mode
<6>device host7-e1 left promiscuous mode
<6>device host7-e1 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth4: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth4: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth5: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth5: link becomes ready
<6>device host8-e0 entered promiscuous mode
<6>device host8-e1 entered promiscuous mode
<6>device host8-e2 entered promiscuous mode
<6>device host8-e3 entered promiscuous mode
<6>device host8-e4 entered promiscuous mode
<6>device host8-e5 entered promiscuous mode
<6>device host8-e5 left promiscuous mode
<6>device host8-e4 left promiscuous mode
<6>device host8-e3 left promiscuous mode
<6>device host8-e2 left promiscuous mode
<6>device host8-e1 left promiscuous mode
<6>device host8-e1 entered promiscuous mode
<6>device host8-e2 entered promiscuous mode
<6>device host8-e3 entered promiscuous mode
<6>device host8-e4 entered promiscuous mode
<6>device host8-e5 entered promiscuous mode
<6>device host8-e5 left promiscuous mode
<6>device host8-e4 left promiscuous mode
<6>device host8-e3 left promiscuous mode
<6>device host8-e2 left promiscuous mode
<6>device host8-e2 entered promiscuous mode
<6>device host8-e3 entered promiscuous mode
<6>device host8-e4 entered promiscuous mode
<6>device host8-e5 entered promiscuous mode
<6>device host8-e5 left promiscuous mode
<6>device host8-e4 left promiscuous mode
<6>device host8-e3 left promiscuous mode
<6>device host8-e3 entered promiscuous mode
<6>device host8-e4 entered promiscuous mode
<6>device host8-e5 entered promiscuous mode
<6>device host8-e5 left promiscuous mode
<6>device host8-e4 left promiscuous mode
<6>device host8-e4 entered promiscuous mode
<6>device host8-e5 entered promiscuous mode
<6>device host8-e5 left promiscuous mode
<6>device host8-e5 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device host3-e0 left promiscuous mode
<6>device host4-e0 left promiscuous mode
<6>device host5-e0 left promiscuous mode
<6>device host6-e1 left promiscuous mode
<6>device host7-e1 left promiscuous mode
<6>device host8-e5 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device host3-e0 entered promiscuous mode
<6>device host3-e1 entered promiscuous mode
<6>device host3-e1 left promiscuous mode
<6>device host3-e1 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device host3-e1 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device vlan1999 entered promiscuous mode
<6>device fabric entered promiscuous mode
<6>device vlan1999 left promiscuous mode
<6>device fabric left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr2-et8 entered promiscuous mode
<6>device rtr2-et9 entered promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device rtr2-et3 entered promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr2-et6 entered promiscuous mode
<6>device rtr2-et7 entered promiscuous mode
<6>device rtr2-et4 entered promiscuous mode
<6>device rtr2-et5 entered promiscuous mode
<6>device rtr2-et21 entered promiscuous mode
<6>device rtr2-et15 entered promiscuous mode
<6>device rtr2-et16 entered promiscuous mode
<6>device rtr2-et22 entered promiscuous mode
<6>device rtr2-et24 entered promiscuous mode
<6>device rtr2-et18 entered promiscuous mode
<6>device rtr2-et19 entered promiscuous mode
<6>device rtr2-et14 entered promiscuous mode
<6>device rtr2-et20 entered promiscuous mode
<6>device rtr2-et23 entered promiscuous mode
<6>device rtr2-et17 entered promiscuous mode
<6>device rtr2-et10 entered promiscuous mode
<6>device rtr2-et11 entered promiscuous mode
<6>device rtr2-et12 entered promiscuous mode
<6>device rtr2-et13 entered promiscuous mode
<6>device rtr3-et1 entered promiscuous mode
<6>device rtr3-et1 left promiscuous mode
<6>device rtr2-et1 left promiscuous mode
<6>device rtr2-et2 left promiscuous mode
<6>device rtr2-et3 left promiscuous mode
<6>device rtr2-et4 left promiscuous mode
<6>device rtr2-et5 left promiscuous mode
<6>device rtr2-et6 left promiscuous mode
<6>device rtr2-et7 left promiscuous mode
<6>device rtr2-et8 left promiscuous mode
<6>device rtr2-et10 left promiscuous mode
<6>device rtr2-et11 left promiscuous mode
<6>device rtr2-et12 left promiscuous mode
<6>device rtr2-et13 left promiscuous mode
<6>device rtr2-et14 left promiscuous mode
<6>device rtr2-et15 left promiscuous mode
<6>device rtr2-et16 left promiscuous mode
<6>device rtr2-et17 left promiscuous mode
<6>device rtr2-et18 left promiscuous mode
<6>device rtr2-et19 left promiscuous mode
<6>device rtr2-et20 left promiscuous mode
<6>device rtr2-et21 left promiscuous mode
<6>device rtr2-et22 left promiscuous mode
<6>device rtr2-et23 left promiscuous mode
<6>device rtr2-et24 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth4: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth4: link becomes ready
<6>ADDRCONF(NETDEV_CHANGE): host1-e0: link becomes ready
<6>ADDRCONF(NETDEV_CHANGE): host1-e1: link becomes ready
<6>ADDRCONF(NETDEV_CHANGE): host1-e2: link becomes ready
<6>ADDRCONF(NETDEV_CHANGE): host1-e3: link becomes ready
<7>host1-e4: no IPv6 routers present
<6>device etba1-et8 entered promiscuous mode
<6>device etba1-et9 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>device etba1-et6 entered promiscuous mode
<6>device etba1-et7 entered promiscuous mode
<6>device etba1-et4 entered promiscuous mode
<6>device etba1-et5 entered promiscuous mode
<6>device etba1-et21 entered promiscuous mode
<6>device etba1-et15 entered promiscuous mode
<6>device etba1-et16 entered promiscuous mode
<6>device etba1-et22 entered promiscuous mode
<6>device etba1-et24 entered promiscuous mode
<6>device etba1-et18 entered promiscuous mode
<6>device etba1-et19 entered promiscuous mode
<6>device etba1-et14 entered promiscuous mode
<6>device etba1-et20 entered promiscuous mode
<6>device etba1-et23 entered promiscuous mode
<6>device etba1-et17 entered promiscuous mode
<6>device etba1-et10 entered promiscuous mode
<6>device etba1-et11 entered promiscuous mode
<6>device etba1-et12 entered promiscuous mode
<6>device etba1-et13 entered promiscuous mode
<6>device etba1-et8 left promiscuous mode
<6>device etba1-et9 left promiscuous mode
<6>device etba1-et2 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device etba1-et1 left promiscuous mode
<6>device etba1-et6 left promiscuous mode
<6>device etba1-et7 left promiscuous mode
<6>device etba1-et4 left promiscuous mode
<6>device etba1-et5 left promiscuous mode
<6>device etba1-et14 left promiscuous mode
<6>device etba1-et15 left promiscuous mode
<6>device etba1-et23 left promiscuous mode
<6>device etba1-et17 left promiscuous mode
<6>device etba1-et24 left promiscuous mode
<6>device etba1-et18 left promiscuous mode
<6>device etba1-et19 left promiscuous mode
<6>device etba1-et21 left promiscuous mode
<6>device etba1-et20 left promiscuous mode
<6>device etba1-et16 left promiscuous mode
<6>device etba1-et22 left promiscuous mode
<6>device etba1-et10 left promiscuous mode
<6>device etba1-et11 left promiscuous mode
<6>device etba1-et12 left promiscuous mode
<6>device etba1-et13 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>perl[32550]: segfault at 0 ip 00000000f757b7a6 sp 00000000ffa57c70 error 4 in libperl.so[f7433000+25f000]
<6>perl[32552]: segfault at 0 ip 00000000f76147a6 sp 00000000ffe10710 error 4 in libperl.so[f74cc000+25f000]
<6>perl[32554]: segfault at 0 ip 00000000f75cd7a6 sp 00000000ff85ab50 error 4 in libperl.so[f7485000+25f000]
<6>perl[32556]: segfault at 0 ip 00000000f76367a6 sp 00000000ff948f10 error 4 in libperl.so[f74ee000+25f000]
<6>perl[32561]: segfault at 0 ip 00000000f75f17a6 sp 00000000ffa2ef80 error 4 in libperl.so[f74a9000+25f000]
<6>perl[32572]: segfault at 0 ip 00000000f75aa7a6 sp 00000000ffa2dd00 error 4 in libperl.so[f7462000+25f000]
<6>perl[32574]: segfault at 0 ip 00000000f75747a6 sp 00000000ffe85cc0 error 4 in libperl.so[f742c000+25f000]
<6>perl[32576]: segfault at 0 ip 00000000f761b7a6 sp 00000000ffcdc100 error 4 in libperl.so[f74d3000+25f000]
<6>perl[32578]: segfault at 0 ip 00000000f756b7a6 sp 00000000fffe3660 error 4 in libperl.so[f7423000+25f000]
<6>perl[32580]: segfault at 0 ip 00000000f757f7a6 sp 00000000ffa3fe10 error 4 in libperl.so[f7437000+25f000]
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<4>show_signal_msg: 24 callbacks suppressed
<6>perl[921]: segfault at 0 ip 00000000f75687a6 sp 00000000ffd21ce0 error 4 in libperl.so[f7420000+25f000]
<6>perl[923]: segfault at 0 ip 00000000f75bf7a6 sp 00000000ff8467a0 error 4 in libperl.so[f7477000+25f000]
<6>perl[925]: segfault at 0 ip 00000000f759c7a6 sp 00000000ffca8240 error 4 in libperl.so[f7454000+25f000]
<6>perl[927]: segfault at 0 ip 00000000f75a97a6 sp 00000000ff7fc7a0 error 4 in libperl.so[f7461000+25f000]
<6>perl[944]: segfault at 0 ip 00000000f75ae7a6 sp 00000000ffdf9480 error 4 in libperl.so[f7466000+25f000]
<6>perl[949]: segfault at 0 ip 00000000f75a37a6 sp 00000000ff845e50 error 4 in libperl.so[f745b000+25f000]
<6>perl[951]: segfault at 0 ip 00000000f75e77a6 sp 00000000fff2ffb0 error 4 in libperl.so[f749f000+25f000]
<6>perl[953]: segfault at 0 ip 00000000f76437a6 sp 00000000ffc42e90 error 4 in libperl.so[f74fb000+25f000]
<6>perl[955]: segfault at 0 ip 00000000f761e7a6 sp 00000000ffa76760 error 4 in libperl.so[f74d6000+25f000]
<6>perl[957]: segfault at 0 ip 00000000f759b7a6 sp 00000000ff9fd9c0 error 4 in libperl.so[f7453000+25f000]
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>udev: starting version 145
<6>udev: starting version 145
<6>device fabric entered promiscuous mode
<6>device fabric left promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): RO-i0-961: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): RO-i0-961: link becomes ready
<4>show_signal_msg: 24 callbacks suppressed
<6>cliribd[2542]: segfault at 5f ip 000000000805a61c sp 00000000ff9d22f0 error 4 in cliribd[8048000+ef000]
<6>perl[2586]: segfault at 0 ip 00000000f75b77a6 sp 00000000ffc02130 error 4 in libperl.so[f746f000+25f000]
<6>perl[2597]: segfault at 0 ip 00000000f75e07a6 sp 00000000ffd3a3f0 error 4 in libperl.so[f7498000+25f000]
<6>device rtr1-et8 entered promiscuous mode
<6>perl[2606]: segfault at 0 ip 00000000f75a87a6 sp 00000000ffd4a930 error 4 in libperl.so[f7460000+25f000]
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>perl[2612]: segfault at 0 ip 00000000f75787a6 sp 00000000ff8ef510 error 4 in libperl.so[f7430000+25f000]
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>perl[2614]: segfault at 0 ip 00000000f757d7a6 sp 00000000ff95ac50 error 4 in libperl.so[f7435000+25f000]
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>perl[2628]: segfault at 0 ip 00000000f762b7a6 sp 00000000ff920700 error 4 in libperl.so[f74e3000+25f000]
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>perl[2630]: segfault at 0 ip 00000000f761a7a6 sp 00000000ff840800 error 4 in libperl.so[f74d2000+25f000]
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et26 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>perl[2634]: segfault at 0 ip 00000000f75947a6 sp 00000000ffddc0b0 error 4 in libperl.so[f744c000+25f000]
<6>device rtr1-et27 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>perl[2636]: segfault at 0 ip 00000000f76357a6 sp 00000000ffff2570 error 4 in libperl.so[f74ed000+25f000]
<6>device rtr1-et25 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et28 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr2-et8 entered promiscuous mode
<6>device rtr2-et9 entered promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device rtr2-et3 entered promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr2-et6 entered promiscuous mode
<6>device rtr2-et7 entered promiscuous mode
<6>device rtr2-et4 entered promiscuous mode
<6>device rtr2-et5 entered promiscuous mode
<6>device rtr2-et21 entered promiscuous mode
<6>device rtr2-et26 entered promiscuous mode
<6>device rtr2-et15 entered promiscuous mode
<6>device rtr2-et23 entered promiscuous mode
<6>device rtr2-et27 entered promiscuous mode
<6>device rtr2-et17 entered promiscuous mode
<6>device rtr2-et25 entered promiscuous mode
<6>device rtr2-et24 entered promiscuous mode
<6>device rtr2-et28 entered promiscuous mode
<6>device rtr2-et18 entered promiscuous mode
<6>device rtr2-et19 entered promiscuous mode
<6>device rtr2-et14 entered promiscuous mode
<6>device rtr2-et20 entered promiscuous mode
<6>device rtr2-et16 entered promiscuous mode
<6>device rtr2-et22 entered promiscuous mode
<6>device rtr2-et10 entered promiscuous mode
<6>device rtr2-et11 entered promiscuous mode
<6>device rtr2-et12 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device rtr2-et13 entered promiscuous mode
<6>device host1-e0 entered promiscuous mode
<6>udev: starting version 145
<6>device fabric entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device fabric left promiscuous mode
<6>device rtr2-et4 left promiscuous mode
<6>device rtr2-et7 left promiscuous mode
<6>device rtr2-et11 left promiscuous mode
<6>device rtr2-et15 left promiscuous mode
<6>device rtr2-et16 left promiscuous mode
<6>device rtr2-et18 left promiscuous mode
<6>device rtr2-et19 left promiscuous mode
<6>device rtr2-et22 left promiscuous mode
<6>device rtr2-et26 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et26 left promiscuous mode
<6>device rtr1-et28 left promiscuous mode
<6>device fabric entered promiscuous mode
<6>device fabric left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device fabric entered promiscuous mode
<6>device fabric left promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr2-et8 entered promiscuous mode
<6>device rtr2-et9 entered promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device rtr2-et3 entered promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr2-et6 entered promiscuous mode
<6>device rtr2-et7 entered promiscuous mode
<6>device rtr2-et4 entered promiscuous mode
<6>device rtr2-et5 entered promiscuous mode
<4>show_signal_msg: 23 callbacks suppressed
<6>perl[7946]: segfault at 0 ip 00000000f76507a6 sp 00000000fff350b0 error 4 in libperl.so[f7508000+25f000]
<6>perl[7955]: segfault at 0 ip 00000000f75c17a6 sp 00000000ffa1f730 error 4 in libperl.so[f7479000+25f000]
<6>perl[7959]: segfault at 0 ip 00000000f75db7a6 sp 00000000ffe375a0 error 4 in libperl.so[f7493000+25f000]
<6>perl[7974]: segfault at 0 ip 00000000f763b7a6 sp 00000000ffa1e8c0 error 4 in libperl.so[f74f3000+25f000]
<6>perl[7976]: segfault at 0 ip 00000000f75df7a6 sp 00000000fffadde0 error 4 in libperl.so[f7497000+25f000]
<6>perl[7980]: segfault at 0 ip 00000000f76557a6 sp 00000000ffd77220 error 4 in libperl.so[f750d000+25f000]
<6>perl[7982]: segfault at 0 ip 00000000f755d7a6 sp 00000000ffeac960 error 4 in libperl.so[f7415000+25f000]
<6>perl[7986]: segfault at 0 ip 00000000f76367a6 sp 00000000ffd06970 error 4 in libperl.so[f74ee000+25f000]
<6>perl[7988]: segfault at 0 ip 00000000f76017a6 sp 00000000ffb42180 error 4 in libperl.so[f74b9000+25f000]
<6>perl[7990]: segfault at 0 ip 00000000f75707a6 sp 00000000ff8f9540 error 4 in libperl.so[f7428000+25f000]
<6>device rtr2-et1 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>udev: starting version 145
<6>device fabric entered promiscuous mode
<6>device fabric left promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device rtr3-et1 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<4>show_signal_msg: 20 callbacks suppressed
<6>perl[9209]: segfault at 0 ip 00000000f75c47a6 sp 00000000ff908510 error 4 in libperl.so[f747c000+25f000]
<6>perl[9214]: segfault at 0 ip 00000000f75977a6 sp 00000000ffcee430 error 4 in libperl.so[f744f000+25f000]
<6>perl[9216]: segfault at 0 ip 00000000f758c7a6 sp 00000000ff8a3590 error 4 in libperl.so[f7444000+25f000]
<6>perl[9218]: segfault at ff267ffc ip 00000000f75b8dcc sp 00000000ff268000 error 6 in libperl.so[f74b5000+25f000]
<6>perl[9232]: segfault at 0 ip 00000000f75b27a6 sp 00000000ffb8af50 error 4 in libperl.so[f746a000+25f000]
<6>perl[9241]: segfault at 0 ip 00000000f75e47a6 sp 00000000ffdb9bc0 error 4 in libperl.so[f749c000+25f000]
<6>perl[9243]: segfault at 0 ip 00000000f75d37a6 sp 00000000ffa9fdc0 error 4 in libperl.so[f748b000+25f000]
<6>perl[9246]: segfault at 0 ip 00000000f75cd7a6 sp 00000000ff8fd8c0 error 4 in libperl.so[f7485000+25f000]
<6>perl[9248]: segfault at 0 ip 00000000f75f27a6 sp 00000000ff9c45f0 error 4 in libperl.so[f74aa000+25f000]
<6>perl[9251]: segfault at 0 ip 00000000f75c17a6 sp 00000000ff88a250 error 4 in libperl.so[f7479000+25f000]
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr2-et1 left promiscuous mode
<6>device rtr2-et2 left promiscuous mode
<6>device rtr2-et3 left promiscuous mode
<6>device rtr2-et5 left promiscuous mode
<6>device rtr2-et6 left promiscuous mode
<6>device rtr2-et7 left promiscuous mode
<6>device rtr2-et8 left promiscuous mode
<6>device rtr2-et9 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>device rtr2-et1 left promiscuous mode
<6>device rtr3-et1 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host3-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host4-e0 entered promiscuous mode
<6>udev: starting version 145
<6>device fabric entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device fabric left promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device host3-e0 left promiscuous mode
<6>device host4-e0 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): Rib-i0-121: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): Rib-i0-121: link becomes ready
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et26 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et27 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et25 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et28 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr2-et8 entered promiscuous mode
<6>device rtr2-et9 entered promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device rtr2-et3 entered promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr2-et6 entered promiscuous mode
<6>device rtr2-et7 entered promiscuous mode
<6>device rtr2-et4 entered promiscuous mode
<6>device rtr2-et5 entered promiscuous mode
<6>device rtr2-et21 entered promiscuous mode
<6>device rtr2-et26 entered promiscuous mode
<6>device rtr2-et15 entered promiscuous mode
<6>device rtr2-et23 entered promiscuous mode
<6>device rtr2-et27 entered promiscuous mode
<6>device rtr2-et17 entered promiscuous mode
<6>device rtr2-et25 entered promiscuous mode
<6>device rtr2-et24 entered promiscuous mode
<6>device rtr2-et28 entered promiscuous mode
<6>device rtr2-et18 entered promiscuous mode
<6>device rtr2-et19 entered promiscuous mode
<6>device rtr2-et14 entered promiscuous mode
<6>device rtr2-et20 entered promiscuous mode
<6>device rtr2-et16 entered promiscuous mode
<6>device rtr2-et22 entered promiscuous mode
<6>device rtr2-et10 entered promiscuous mode
<6>device rtr2-et11 entered promiscuous mode
<6>device rtr2-et12 entered promiscuous mode
<6>device rtr2-et13 entered promiscuous mode
<6>device rtr3-et1 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr2-et1 left promiscuous mode
<6>device rtr3-et1 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<7>ribd1-e1: no IPv6 routers present
<7>ribd1-e0: no IPv6 routers present
<7>ribd2-e1: no IPv6 routers present
<7>ribd2-e0: no IPv6 routers present
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr2-et1 left promiscuous mode
<6>device rtr2-et2 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr2-et13 left promiscuous mode
<6>device rtr2-et3 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr2-et12 left promiscuous mode
<6>device rtr2-et4 left promiscuous mode
<6>device rtr2-et5 left promiscuous mode
<6>device rtr2-et11 left promiscuous mode
<6>device rtr2-et6 left promiscuous mode
<6>device rtr2-et7 left promiscuous mode
<6>device rtr2-et8 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr2-et10 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr2-et9 left promiscuous mode
<6>device rtr2-et22 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr2-et16 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr2-et20 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr2-et15 left promiscuous mode
<6>device rtr2-et17 left promiscuous mode
<6>device rtr2-et18 left promiscuous mode
<6>device rtr2-et19 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr2-et21 left promiscuous mode
<6>device rtr2-et23 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr2-et24 left promiscuous mode
<6>device rtr2-et28 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr2-et25 left promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr2-et26 left promiscuous mode
<6>device rtr2-et27 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device rtr1-et25 left promiscuous mode
<6>device rtr1-et26 left promiscuous mode
<6>device rtr1-et27 left promiscuous mode
<6>device rtr1-et28 left promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr2-et8 entered promiscuous mode
<6>device rtr2-et9 entered promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device rtr2-et3 entered promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr2-et6 entered promiscuous mode
<6>device rtr2-et7 entered promiscuous mode
<6>device rtr2-et4 entered promiscuous mode
<6>device rtr2-et5 entered promiscuous mode
<6>device rtr2-et14 entered promiscuous mode
<6>device rtr2-et15 entered promiscuous mode
<6>device rtr2-et10 entered promiscuous mode
<6>device rtr2-et11 entered promiscuous mode
<6>device rtr2-et12 entered promiscuous mode
<6>device rtr2-et13 entered promiscuous mode
<6>device rtr3-et1 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): RibBgp-i0-1108: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): RibBgp-i0-1108: link becomes ready
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr2-et1 left promiscuous mode
<6>device rtr3-et1 left promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host3-e0 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device ribd2-e0 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device ribd2-e1 entered promiscuous mode
<6>device ribd2-e1 left promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device ribd2-e1 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device host3-e0 left promiscuous mode
<6>device ribd2-e1 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host3-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device host3-e0 left promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host3-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device host3-e0 left promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr2-et1 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host3-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host3-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device ribd2-e0 entered promiscuous mode
<6>device ribd2-e1 entered promiscuous mode
<6>device ribd2-e1 left promiscuous mode
<6>device ribd2-e1 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host4-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device ribd3-e0 entered promiscuous mode
<6>device ribd3-e1 entered promiscuous mode
<6>device ribd3-e1 left promiscuous mode
<6>device ribd3-e1 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device host3-e0 left promiscuous mode
<6>device ribd2-e1 left promiscuous mode
<6>device host4-e0 left promiscuous mode
<6>device ribd3-e1 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device host3-e0 left promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr2-et13 left promiscuous mode
<6>device rtr2-et4 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr2-et7 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device rtr2-et3 entered promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr2-et6 entered promiscuous mode
<6>device rtr2-et4 entered promiscuous mode
<6>device rtr2-et5 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): e12: link is not ready
<6>ADDRCONF(NETDEV_UP): e23: link is not ready
<6>ADDRCONF(NETDEV_UP): e1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): e1: link becomes ready
<6>ADDRCONF(NETDEV_UP): e2: link is not ready
<6>ADDRCONF(NETDEV_UP): e3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): e3: link becomes ready
<6>ADDRCONF(NETDEV_CHANGE): e12: link becomes ready
<6>ADDRCONF(NETDEV_CHANGE): e2: link becomes ready
<6>ADDRCONF(NETDEV_CHANGE): e23: link becomes ready
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr2-et1 left promiscuous mode
<6>device rtr2-et2 left promiscuous mode
<6>device rtr2-et3 left promiscuous mode
<6>device rtr2-et4 left promiscuous mode
<6>device rtr2-et5 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<1>BUG: Bad page map in process [manager]  pte:ffff880282177748 pmd:282177067
<1>addr:00000000f50e9000 vm_flags:08000075 anon_vma:          (null) mapping:ffff8801ec94dcf8 index:128
<1>vma->vm_ops->fault: filemap_fault+0x0/0x351
<1>vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x4f
<4>Pid: 20778, comm: [manager] Not tainted 2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<4>Disabling lock debugging due to kernel taint
<1>BUG: Bad page map in process [manager]  pte:ffff880282177748 pmd:282177067
<1>addr:00000000f50ea000 vm_flags:08000075 anon_vma:          (null) mapping:ffff8801ec94dcf8 index:129
<1>vma->vm_ops->fault: filemap_fault+0x0/0x351
<1>vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x4f
<4>Pid: 20778, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<1>BUG: Bad page map in process [manager]  pte:ffff880192d85748 pmd:192d85067
<1>addr:00000000f66e9000 vm_flags:08000075 anon_vma:          (null) mapping:ffff880220316af8 index:e4
<1>vma->vm_ops->fault: filemap_fault+0x0/0x351
<1>vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x4f
<4>Pid: 20778, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<1>BUG: Bad page map in process [manager]  pte:ffff880192d85748 pmd:192d85067
<1>addr:00000000f66ea000 vm_flags:08000075 anon_vma:          (null) mapping:ffff880220316af8 index:e5
<1>vma->vm_ops->fault: filemap_fault+0x0/0x351
<1>vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x4f
<4>Pid: 20778, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device ribd2-e0 entered promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device rtr2-et3 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>device rtr2-et1 entered promiscuous mode
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device rtr2-et6 entered promiscuous mode
<6>device rtr2-et4 entered promiscuous mode
<6>device ribd3-e0 entered promiscuous mode
<6>device rtr2-et5 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e0 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device rtr1-et2 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
<6>device rtr1-et6 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth4: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth4: link becomes ready
<6>device rtr1-et7 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth5: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth5: link becomes ready
<6>device rtr1-et4 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth6: link is not ready
<6>device rtr1-et5 entered promiscuous mode
<6>ADDRCONF(NETDEV_CHANGE): eth6: link becomes ready
<6>device rtr1-et21 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth7: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth7: link becomes ready
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth8: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth8: link becomes ready
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth9: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth9: link becomes ready
<6>device rtr1-et18 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth10: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth10: link becomes ready
<6>device rtr1-et19 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth11: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth11: link becomes ready
<6>device rtr1-et14 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth12: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth12: link becomes ready
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth13: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth13: link becomes ready
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth14: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth14: link becomes ready
<6>device rtr1-et11 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth15: link is not ready
<6>device rtr1-et12 entered promiscuous mode
<6>ADDRCONF(NETDEV_CHANGE): eth15: link becomes ready
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth16: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth16: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth17: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth17: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth18: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth18: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth19: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth19: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth20: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth20: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth21: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth21: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth22: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth22: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth23: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth23: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth24: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth24: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth25: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth25: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth26: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth26: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth27: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth27: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth28: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth28: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth29: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth29: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth30: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth30: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth31: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth31: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth32: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth32: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth33: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth33: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth34: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth34: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth35: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth35: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth36: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth36: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth37: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth37: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth38: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth38: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth39: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth39: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth40: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth40: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth41: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth41: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth42: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth42: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth43: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth43: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth44: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth44: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth45: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth45: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth46: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth46: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth47: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth47: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth48: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth48: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth49: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth49: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth50: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth50: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth51: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth51: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth52: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth52: link becomes ready
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth53: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth53: link becomes ready
<6>device rtr1-et2 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth54: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth54: link becomes ready
<6>device rtr1-et3 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth55: link is not ready
<6>device rtr1-et1 entered promiscuous mode
<6>ADDRCONF(NETDEV_CHANGE): eth55: link becomes ready
<6>device rtr1-et6 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth56: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth56: link becomes ready
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth57: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth57: link becomes ready
<6>device rtr1-et5 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth58: link is not ready
<6>device rtr1-et21 entered promiscuous mode
<6>ADDRCONF(NETDEV_CHANGE): eth58: link becomes ready
<6>device rtr1-et15 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth59: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth59: link becomes ready
<6>device rtr1-et16 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth60: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth60: link becomes ready
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth61: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth61: link becomes ready
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth62: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth62: link becomes ready
<6>device rtr1-et14 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth63: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth63: link becomes ready
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<7>ribd1-e2: no IPv6 routers present
<7>ribd1-e3: no IPv6 routers present
<7>ribd1-e0: no IPv6 routers present
<7>ribd1-e1: no IPv6 routers present
<7>ribd1-e4: no IPv6 routers present
<7>ribd1-e7: no IPv6 routers present
<7>ribd1-e5: no IPv6 routers present
<7>ribd1-e6: no IPv6 routers present
<7>ribd1-e12: no IPv6 routers present
<7>ribd1-e10: no IPv6 routers present
<7>ribd1-e13: no IPv6 routers present
<7>ribd1-e8: no IPv6 routers present
<7>ribd1-e9: no IPv6 routers present
<7>ribd1-e17: no IPv6 routers present
<7>ribd1-e14: no IPv6 routers present
<7>ribd1-e16: no IPv6 routers present
<7>ribd1-e15: no IPv6 routers present
<7>ribd1-e11: no IPv6 routers present
<7>ribd1-e21: no IPv6 routers present
<7>ribd1-e22: no IPv6 routers present
<7>ribd1-e20: no IPv6 routers present
<7>ribd1-e23: no IPv6 routers present
<7>ribd1-e18: no IPv6 routers present
<7>ribd1-e24: no IPv6 routers present
<7>ribd1-e19: no IPv6 routers present
<7>ribd1-e25: no IPv6 routers present
<7>ribd1-e31: no IPv6 routers present
<7>ribd1-e28: no IPv6 routers present
<7>ribd1-e27: no IPv6 routers present
<7>ribd1-e26: no IPv6 routers present
<7>ribd1-e33: no IPv6 routers present
<7>ribd1-e30: no IPv6 routers present
<7>ribd1-e29: no IPv6 routers present
<7>ribd1-e32: no IPv6 routers present
<7>ribd1-e37: no IPv6 routers present
<7>ribd1-e35: no IPv6 routers present
<7>ribd1-e34: no IPv6 routers present
<7>ribd1-e39: no IPv6 routers present
<7>ribd1-e38: no IPv6 routers present
<7>ribd1-e36: no IPv6 routers present
<7>ribd1-e40: no IPv6 routers present
<7>ribd1-e45: no IPv6 routers present
<6>device rtr2-et1 left promiscuous mode
<7>ribd1-e43: no IPv6 routers present
<7>ribd1-e46: no IPv6 routers present
<6>device rtr2-et2 left promiscuous mode
<7>ribd1-e42: no IPv6 routers present
<7>ribd1-e44: no IPv6 routers present
<7>ribd1-e41: no IPv6 routers present
<6>device rtr2-et3 left promiscuous mode
<6>device rtr2-et4 left promiscuous mode
<7>ribd1-e52: no IPv6 routers present
<6>device rtr2-et6 left promiscuous mode
<7>ribd1-e51: no IPv6 routers present
<7>ribd1-e50: no IPv6 routers present
<7>ribd1-e53: no IPv6 routers present
<7>ribd1-e47: no IPv6 routers present
<7>ribd1-e48: no IPv6 routers present
<7>ribd1-e49: no IPv6 routers present
<7>ribd1-e54: no IPv6 routers present
<6>device rtr1-et1 left promiscuous mode
<7>ribd1-e57: no IPv6 routers present
<6>device rtr1-et2 left promiscuous mode
<7>ribd1-e55: no IPv6 routers present
<7>ribd1-e56: no IPv6 routers present
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<7>ribd1-e59: no IPv6 routers present
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<7>ribd1-e61: no IPv6 routers present
<7>ribd1-e60: no IPv6 routers present
<7>ribd1-e62: no IPv6 routers present
<7>ribd1-e58: no IPv6 routers present
<7>ribd1-e63: no IPv6 routers present
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e0 left promiscuous mode
<6>device ribd2-e0 left promiscuous mode
<6>device ribd3-e0 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr3-et2 entered promiscuous mode
<6>device rtr3-et1 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr2-et8 entered promiscuous mode
<6>device rtr2-et9 entered promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device rtr2-et3 entered promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr2-et6 entered promiscuous mode
<6>device rtr2-et7 entered promiscuous mode
<6>device rtr2-et4 entered promiscuous mode
<6>device rtr2-et5 entered promiscuous mode
<6>device rtr2-et10 entered promiscuous mode
<6>device rtr2-et11 entered promiscuous mode
<6>device rtr2-et12 entered promiscuous mode
<6>device rtr2-et13 entered promiscuous mode
<6>device rtr2-et1 left promiscuous mode
<6>device rtr2-et2 left promiscuous mode
<6>device rtr3-et1 left promiscuous mode
<6>device rtr3-et2 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
<7>ribd1-e0: no IPv6 routers present
<7>ribd1-e2: no IPv6 routers present
<7>ribd1-e3: no IPv6 routers present
<7>ribd1-e1: no IPv6 routers present
<7>ribd2-e1: no IPv6 routers present
<7>ribd2-e2: no IPv6 routers present
<7>ribd2-e3: no IPv6 routers present
<7>ribd2-e0: no IPv6 routers present
<7>ribd3-e0: no IPv6 routers present
<7>ribd3-e1: no IPv6 routers present
<7>ribd3-e3: no IPv6 routers present
<7>ribd3-e2: no IPv6 routers present
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device rtr1-et11 entered promiscuous mode
<6>device ribd1-e0 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device ribd2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device ribd3-e0 entered promiscuous mode
<6>device ribd1-e0 left promiscuous mode
<6>device rtr2-et9 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device ribd2-e0 left promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device ribd3-e0 left promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et30 entered promiscuous mode
<6>device rtr1-et31 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et32 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et29 entered promiscuous mode
<6>device rtr1-et28 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et25 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et27 entered promiscuous mode
<6>device rtr1-et26 entered promiscuous mode
<6>device rtr2-et8 entered promiscuous mode
<6>device rtr2-et9 entered promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device rtr2-et3 entered promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr2-et6 entered promiscuous mode
<6>device rtr2-et7 entered promiscuous mode
<6>device rtr2-et4 entered promiscuous mode
<6>device rtr2-et5 entered promiscuous mode
<6>device rtr2-et18 entered promiscuous mode
<6>device rtr2-et19 entered promiscuous mode
<6>device rtr2-et14 entered promiscuous mode
<6>device rtr2-et15 entered promiscuous mode
<6>device rtr2-et30 entered promiscuous mode
<6>device rtr2-et31 entered promiscuous mode
<6>device rtr2-et10 entered promiscuous mode
<6>device rtr2-et11 entered promiscuous mode
<6>device rtr2-et12 entered promiscuous mode
<6>device rtr2-et13 entered promiscuous mode
<6>device rtr2-et32 entered promiscuous mode
<6>device rtr2-et16 entered promiscuous mode
<6>device rtr2-et17 entered promiscuous mode
<6>device rtr2-et29 entered promiscuous mode
<6>device rtr2-et28 entered promiscuous mode
<6>device rtr2-et21 entered promiscuous mode
<6>device rtr2-et20 entered promiscuous mode
<6>device rtr2-et23 entered promiscuous mode
<6>device rtr2-et22 entered promiscuous mode
<6>device rtr2-et25 entered promiscuous mode
<6>device rtr2-et24 entered promiscuous mode
<6>device rtr2-et27 entered promiscuous mode
<6>device rtr2-et26 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth4: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth4: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device ribd1-e3 entered promiscuous mode
<6>device ribd1-e4 entered promiscuous mode
<6>device ribd1-e4 left promiscuous mode
<6>device ribd1-e3 left promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device ribd1-e3 entered promiscuous mode
<6>device ribd1-e4 entered promiscuous mode
<6>device ribd1-e4 left promiscuous mode
<6>device ribd1-e3 left promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device ribd1-e3 entered promiscuous mode
<6>device ribd1-e4 entered promiscuous mode
<6>device ribd1-e4 left promiscuous mode
<6>device ribd1-e3 left promiscuous mode
<6>device ribd1-e3 entered promiscuous mode
<6>device ribd1-e4 entered promiscuous mode
<6>device ribd1-e4 left promiscuous mode
<6>device ribd1-e4 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth4: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth4: link becomes ready
<6>device ribd2-e0 entered promiscuous mode
<6>device ribd2-e1 entered promiscuous mode
<6>device ribd2-e2 entered promiscuous mode
<6>device ribd2-e3 entered promiscuous mode
<6>device ribd2-e4 entered promiscuous mode
<6>device ribd2-e4 left promiscuous mode
<6>device ribd2-e3 left promiscuous mode
<6>device ribd2-e2 left promiscuous mode
<6>device ribd2-e1 left promiscuous mode
<6>device ribd2-e1 entered promiscuous mode
<6>device ribd2-e2 entered promiscuous mode
<6>device ribd2-e3 entered promiscuous mode
<6>device ribd2-e4 entered promiscuous mode
<6>device ribd2-e4 left promiscuous mode
<6>device ribd2-e3 left promiscuous mode
<6>device ribd2-e2 left promiscuous mode
<6>device ribd2-e2 entered promiscuous mode
<6>device ribd2-e3 entered promiscuous mode
<6>device ribd2-e4 entered promiscuous mode
<6>device ribd2-e4 left promiscuous mode
<6>device ribd2-e3 left promiscuous mode
<6>device ribd2-e3 entered promiscuous mode
<6>device ribd2-e4 entered promiscuous mode
<6>device ribd2-e4 left promiscuous mode
<6>device ribd2-e4 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth4: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth4: link becomes ready
<6>device ribd3-e0 entered promiscuous mode
<6>device ribd3-e1 entered promiscuous mode
<6>device ribd3-e2 entered promiscuous mode
<6>device ribd3-e3 entered promiscuous mode
<6>device ribd3-e4 entered promiscuous mode
<6>device ribd3-e4 left promiscuous mode
<6>device ribd3-e3 left promiscuous mode
<6>device ribd3-e2 left promiscuous mode
<6>device ribd3-e1 left promiscuous mode
<6>device ribd3-e1 entered promiscuous mode
<6>device ribd3-e2 entered promiscuous mode
<6>device ribd3-e3 entered promiscuous mode
<6>device ribd3-e4 entered promiscuous mode
<6>device ribd3-e4 left promiscuous mode
<6>device ribd3-e3 left promiscuous mode
<6>device ribd3-e2 left promiscuous mode
<6>device ribd3-e2 entered promiscuous mode
<6>device ribd3-e3 entered promiscuous mode
<6>device ribd3-e4 entered promiscuous mode
<6>device ribd3-e4 left promiscuous mode
<6>device ribd3-e3 left promiscuous mode
<6>device ribd3-e3 entered promiscuous mode
<6>device ribd3-e4 entered promiscuous mode
<6>device ribd3-e4 left promiscuous mode
<6>device ribd3-e4 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>device ribd4-e0 entered promiscuous mode
<6>device ribd4-e1 entered promiscuous mode
<6>device ribd4-e2 entered promiscuous mode
<6>device ribd4-e2 left promiscuous mode
<6>device ribd4-e1 left promiscuous mode
<6>device ribd4-e1 entered promiscuous mode
<6>device ribd4-e2 entered promiscuous mode
<6>device ribd4-e2 left promiscuous mode
<6>device ribd4-e2 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>device ribd5-e0 entered promiscuous mode
<6>device ribd5-e1 entered promiscuous mode
<6>device ribd5-e2 entered promiscuous mode
<6>device ribd5-e2 left promiscuous mode
<6>device ribd5-e1 left promiscuous mode
<6>device ribd5-e1 entered promiscuous mode
<6>device ribd5-e2 entered promiscuous mode
<6>device ribd5-e2 left promiscuous mode
<6>device ribd5-e2 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>device ribd6-e0 entered promiscuous mode
<6>device ribd6-e1 entered promiscuous mode
<6>device ribd6-e2 entered promiscuous mode
<6>device ribd6-e2 left promiscuous mode
<6>device ribd6-e1 left promiscuous mode
<6>device ribd6-e1 entered promiscuous mode
<6>device ribd6-e2 entered promiscuous mode
<6>device ribd6-e2 left promiscuous mode
<6>device ribd6-e2 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>device ribd7-e0 entered promiscuous mode
<6>device ribd7-e1 entered promiscuous mode
<6>device ribd7-e2 entered promiscuous mode
<6>device ribd7-e2 left promiscuous mode
<6>device ribd7-e1 left promiscuous mode
<6>device ribd7-e1 entered promiscuous mode
<6>device ribd7-e2 entered promiscuous mode
<6>device ribd7-e2 left promiscuous mode
<6>device ribd7-e2 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host3-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host4-e0 entered promiscuous mode
<4>modprobe used greatest stack depth: 3440 bytes left
<6>device rtr1-et22 left promiscuous mode
<6>device rtr2-et30 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host3-e0 entered promiscuous mode
<7>UDP: short packet: From 171.64.90.1:12589 12850/512 to 10.10.1.2:25972
<7>UDP: short packet: From 171.64.90.1:12332 12332/512 to 10.10.1.0:12332
<7>UDP: short packet: From 171.64.90.1:12332 12332/512 to 10.10.1.1:12332
<7>UDP: short packet: From 171.64.90.1:12332 12332/512 to 10.10.1.255:12332
<7>UDP: short packet: From 171.64.90.1:29300 18895/512 to 10.10.3.2:29233
<7>UDP: short packet: From 171.64.90.1:40152 0/512 to 10.10.3.2:19209
<7>UDP: short packet: From 171.64.90.1:0 0/512 to 10.10.1.2:0
<7>UDP: short packet: From 171.64.90.1:22644 40152/900 to 10.10.1.2:34314
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device host3-e0 left promiscuous mode
<6>device ribd1-e4 left promiscuous mode
<6>device ribd2-e4 left promiscuous mode
<6>device ribd3-e4 left promiscuous mode
<6>device ribd4-e2 left promiscuous mode
<6>device ribd5-e2 left promiscuous mode
<6>device ribd6-e2 left promiscuous mode
<6>device ribd7-e2 left promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device host3-e0 left promiscuous mode
<6>device host4-e0 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device ribd1-e3 entered promiscuous mode
<6>device ribd1-e3 left promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device ribd1-e3 entered promiscuous mode
<6>device ribd1-e3 left promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device ribd1-e3 entered promiscuous mode
<6>device ribd1-e3 left promiscuous mode
<6>device ribd1-e3 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>device ribd2-e0 entered promiscuous mode
<6>device ribd2-e1 entered promiscuous mode
<6>device ribd2-e2 entered promiscuous mode
<6>device ribd2-e2 left promiscuous mode
<6>device ribd2-e1 left promiscuous mode
<6>device ribd2-e1 entered promiscuous mode
<6>device ribd2-e2 entered promiscuous mode
<6>device ribd2-e2 left promiscuous mode
<6>device ribd2-e2 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>device ribd3-e0 entered promiscuous mode
<6>device ribd3-e1 entered promiscuous mode
<6>device ribd3-e2 entered promiscuous mode
<6>device ribd3-e2 left promiscuous mode
<6>device ribd3-e1 left promiscuous mode
<6>device ribd3-e1 entered promiscuous mode
<6>device ribd3-e2 entered promiscuous mode
<6>device ribd3-e2 left promiscuous mode
<6>device ribd3-e2 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host3-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device host4-e0 entered promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host3-e0 entered promiscuous mode
<6>device rtr2-et1 left promiscuous mode
<4>Sysdb used greatest stack depth: 3216 bytes left
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device ribd1-e3 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et26 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et27 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et25 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et28 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device ribd2-e2 left promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr2-et8 entered promiscuous mode
<6>device rtr2-et9 entered promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device ribd3-e2 left promiscuous mode
<6>device rtr2-et3 entered promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device rtr2-et6 entered promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device rtr2-et7 entered promiscuous mode
<6>device host3-e0 left promiscuous mode
<6>device rtr2-et4 entered promiscuous mode
<6>device host4-e0 left promiscuous mode
<6>device rtr2-et5 entered promiscuous mode
<6>device rtr2-et21 entered promiscuous mode
<6>device rtr2-et26 entered promiscuous mode
<6>device rtr2-et15 entered promiscuous mode
<6>device rtr2-et23 entered promiscuous mode
<6>device rtr2-et27 entered promiscuous mode
<6>device rtr2-et17 entered promiscuous mode
<6>device rtr2-et25 entered promiscuous mode
<6>device rtr2-et24 entered promiscuous mode
<6>device rtr2-et28 entered promiscuous mode
<6>device rtr2-et18 entered promiscuous mode
<6>device rtr2-et19 entered promiscuous mode
<6>device rtr2-et14 entered promiscuous mode
<6>device rtr2-et20 entered promiscuous mode
<6>device rtr2-et16 entered promiscuous mode
<6>device rtr2-et22 entered promiscuous mode
<6>device rtr2-et10 entered promiscuous mode
<6>device rtr2-et11 entered promiscuous mode
<6>device rtr2-et12 entered promiscuous mode
<6>device rtr2-et13 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<4>IgmpSnooping used greatest stack depth: 3184 bytes left
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et26 left promiscuous mode
<6>device rtr2-et10 left promiscuous mode
<6>device rtr2-et22 left promiscuous mode
<6>device rtr2-et21 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
<6>ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
<6>device ribd1-e0 entered promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device ribd1-e1 entered promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>device ribd1-e2 entered promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device rtr2-et3 entered promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr2-et4 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host3-e0 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device rtr2-et3 entered promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr2-et6 entered promiscuous mode
<6>device rtr2-et4 entered promiscuous mode
<6>device rtr2-et5 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device ribd1-e1 left promiscuous mode
<6>device host3-e0 left promiscuous mode
<6>device etba1-et1 left promiscuous mode
<6>device etba1-et2 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device rtr2-et1 left promiscuous mode
<6>device rtr2-et2 left promiscuous mode
<6>device rtr2-et3 left promiscuous mode
<6>device rtr2-et5 left promiscuous mode
<6>device rtr2-et6 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>ADDRCONF(NETDEV_UP): RO-i0-961: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): RO-i0-961: link becomes ready
<4>show_signal_msg: 24 callbacks suppressed
<6>cliribd[29539]: segfault at 5f ip 000000000805a61c sp 00000000ffe2c710 error 4 in cliribd[8048000+ef000]
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device ribd1-e2 left promiscuous mode
<6>device rtr2-et1 left promiscuous mode
<6>device rtr2-et2 left promiscuous mode
<6>device rtr2-et3 left promiscuous mode
<6>device rtr2-et4 left promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device host1-e0 left promiscuous mode
<6>device host2-e0 left promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device host3-e0 left promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr2-et3 entered promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr2-et6 entered promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr2-et4 entered promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr2-et5 entered promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device etba1-et8 entered promiscuous mode
<6>device etba1-et9 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>device etba1-et6 entered promiscuous mode
<6>device etba1-et7 entered promiscuous mode
<6>device etba1-et4 entered promiscuous mode
<6>device etba1-et5 entered promiscuous mode
<6>device etba1-et21 entered promiscuous mode
<6>device etba1-et15 entered promiscuous mode
<6>device etba1-et16 entered promiscuous mode
<6>device etba1-et22 entered promiscuous mode
<6>device etba1-et24 entered promiscuous mode
<6>device etba1-et18 entered promiscuous mode
<6>device etba1-et19 entered promiscuous mode
<6>device etba1-et14 entered promiscuous mode
<6>device etba1-et20 entered promiscuous mode
<6>device etba1-et23 entered promiscuous mode
<6>device etba1-et17 entered promiscuous mode
<6>device etba1-et10 entered promiscuous mode
<6>device etba1-et11 entered promiscuous mode
<6>device etba1-et12 entered promiscuous mode
<6>device etba1-et13 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr2-et2 left promiscuous mode
<6>device rtr2-et3 left promiscuous mode
<6>device rtr2-et4 left promiscuous mode
<6>device rtr2-et5 left promiscuous mode
<6>device rtr2-et6 left promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device etba1-et8 left promiscuous mode
<6>device etba1-et9 left promiscuous mode
<6>device etba1-et2 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device etba1-et1 left promiscuous mode
<6>device etba1-et6 left promiscuous mode
<6>device etba1-et7 left promiscuous mode
<6>device etba1-et4 left promiscuous mode
<6>device etba1-et5 left promiscuous mode
<6>device etba1-et14 left promiscuous mode
<6>device etba1-et15 left promiscuous mode
<6>device etba1-et23 left promiscuous mode
<6>device etba1-et17 left promiscuous mode
<6>device etba1-et24 left promiscuous mode
<6>device etba1-et18 left promiscuous mode
<6>device etba1-et19 left promiscuous mode
<6>device etba1-et21 left promiscuous mode
<6>device etba1-et20 left promiscuous mode
<6>device etba1-et16 left promiscuous mode
<6>device etba1-et22 left promiscuous mode
<6>device etba1-et10 left promiscuous mode
<6>device etba1-et11 left promiscuous mode
<6>device etba1-et12 left promiscuous mode
<6>device etba1-et13 left promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device etba1-et2 entered promiscuous mode
<6>device etba1-et3 entered promiscuous mode
<6>device etba1-et1 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<1>BUG: Bad page map in process cc1plus  pte:ffff88000af0f748 pmd:0af0f067
<1>addr:00000000c2ce9000 vm_flags:00100073 anon_vma:ffff8800a88ec0c8 mapping:          (null) index:c2ce9
<4>Pid: 30109, comm: cc1plus Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<1>BUG: Bad page map in process cc1plus  pte:ffff88000af0f748 pmd:0af0f067
<1>addr:00000000c2cea000 vm_flags:00100073 anon_vma:ffff8800a88ec0c8 mapping:          (null) index:c2cea
<4>Pid: 30109, comm: cc1plus Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<6>device rtr2-et1 left promiscuous mode
<1>BUG: Bad page map in process [manager]  pte:ffff8801e50ef748 pmd:1e50ef067
<1>addr:00000000f50e9000 vm_flags:08000075 anon_vma:          (null) mapping:ffff8801ec94bd78 index:41
<1>vma->vm_ops->fault: filemap_fault+0x0/0x351
<1>vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x4f
<4>Pid: 32145, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<1>BUG: Bad page map in process [manager]  pte:ffff8801e50ef748 pmd:1e50ef067
<1>addr:00000000f50ea000 vm_flags:08000075 anon_vma:          (null) mapping:ffff8801ec94bd78 index:42
<1>vma->vm_ops->fault: filemap_fault+0x0/0x351
<1>vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x4f
<4>Pid: 32145, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<4>httpd used greatest stack depth: 2624 bytes left
<6>device etba1-et1 left promiscuous mode
<6>device etba1-et2 left promiscuous mode
<6>device etba1-et3 left promiscuous mode
<6>device host1-e0 left promiscuous mode
<1>BUG: Bad page map in process [manager]  pte:ffff88000af0d748 pmd:0af0d067
<1>addr:00000000f04e9000 vm_flags:020000fb anon_vma:          (null) mapping:ffff8800218fe978 index:182
<1>vma->vm_ops->fault: 0x0
<1>vma->vm_file->f_op->mmap: sock_mmap+0x0/0x1a
<4>Pid: 32332, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<1>BUG: Bad page map in process [manager]  pte:ffff88000af0d748 pmd:0af0d067
<1>addr:00000000f04ea000 vm_flags:020000fb anon_vma:          (null) mapping:ffff8800218fe978 index:183
<1>vma->vm_ops->fault: 0x0
<1>vma->vm_file->f_op->mmap: sock_mmap+0x0/0x1a
<4>Pid: 32332, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<1>BUG: Bad page map in process [manager]  pte:ffff88000aea5748 pmd:0aea5067
<1>addr:00000000f42e9000 vm_flags:00100073 anon_vma:ffff8801a55ac578 mapping:          (null) index:f42e9
<4>Pid: 32332, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<1>BUG: Bad page map in process [manager]  pte:ffff88000aea5748 pmd:0aea5067
<1>addr:00000000f42ea000 vm_flags:00100073 anon_vma:ffff8801a55ac578 mapping:          (null) index:f42ea
<4>Pid: 32332, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<6>device host2-e0 left promiscuous mode
<1>BUG: Bad page map in process [manager]  pte:ffff8801178f5748 pmd:1178f5067
<1>addr:00000000eeae9000 vm_flags:020000fb anon_vma:          (null) mapping:ffff880286abe1f8 index:182
<1>vma->vm_ops->fault: 0x0
<1>vma->vm_file->f_op->mmap: sock_mmap+0x0/0x1a
<4>Pid: 32384, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<1>BUG: Bad page map in process [manager]  pte:ffff8801178f5748 pmd:1178f5067
<1>addr:00000000eeaea000 vm_flags:020000fb anon_vma:          (null) mapping:ffff880286abe1f8 index:183
<1>vma->vm_ops->fault: 0x0
<1>vma->vm_file->f_op->mmap: sock_mmap+0x0/0x1a
<4>Pid: 32384, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<1>BUG: Bad page map in process [manager]  pte:ffff8801e07a9748 pmd:1e07a9067
<1>addr:00000000ef4e9000 vm_flags:020000fb anon_vma:          (null) mapping:ffff8800218fc8f8 index:1c2
<1>vma->vm_ops->fault: 0x0
<1>vma->vm_file->f_op->mmap: sock_mmap+0x0/0x1a
<4>Pid: 32447, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<1>BUG: Bad page map in process [manager]  pte:ffff8801e07a9748 pmd:1e07a9067
<1>addr:00000000ef4ea000 vm_flags:020000fb anon_vma:          (null) mapping:ffff8800218fc8f8 index:1c3
<1>vma->vm_ops->fault: 0x0
<1>vma->vm_file->f_op->mmap: sock_mmap+0x0/0x1a
<4>Pid: 32447, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): e12: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): e12: link becomes ready
<6>ADDRCONF(NETDEV_UP): e23: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): e23: link becomes ready
<6>ADDRCONF(NETDEV_UP): e1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): e1: link becomes ready
<6>ADDRCONF(NETDEV_UP): e2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): e2: link becomes ready
<6>ADDRCONF(NETDEV_UP): e3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): e3: link becomes ready
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr1-et8 entered promiscuous mode
<6>device rtr1-et9 entered promiscuous mode
<6>device rtr1-et2 entered promiscuous mode
<6>device rtr1-et3 entered promiscuous mode
<6>device rtr1-et1 entered promiscuous mode
<6>device rtr1-et6 entered promiscuous mode
<6>device rtr1-et7 entered promiscuous mode
<6>device rtr1-et4 entered promiscuous mode
<6>device rtr1-et5 entered promiscuous mode
<6>device rtr1-et21 entered promiscuous mode
<6>device rtr1-et26 entered promiscuous mode
<6>device rtr1-et15 entered promiscuous mode
<6>device rtr1-et23 entered promiscuous mode
<6>device rtr1-et27 entered promiscuous mode
<6>device rtr1-et17 entered promiscuous mode
<6>device rtr1-et25 entered promiscuous mode
<6>device rtr1-et24 entered promiscuous mode
<6>device rtr1-et28 entered promiscuous mode
<6>device rtr1-et18 entered promiscuous mode
<6>device rtr1-et19 entered promiscuous mode
<6>device rtr1-et14 entered promiscuous mode
<6>device rtr1-et20 entered promiscuous mode
<6>device rtr1-et16 entered promiscuous mode
<6>device rtr1-et22 entered promiscuous mode
<6>device rtr1-et10 entered promiscuous mode
<6>device rtr1-et11 entered promiscuous mode
<6>device rtr1-et12 entered promiscuous mode
<6>device rtr1-et13 entered promiscuous mode
<6>device rtr2-et8 entered promiscuous mode
<6>device rtr2-et9 entered promiscuous mode
<6>device rtr2-et2 entered promiscuous mode
<6>device rtr2-et3 entered promiscuous mode
<6>device rtr2-et1 entered promiscuous mode
<6>device rtr2-et6 entered promiscuous mode
<6>device rtr2-et7 entered promiscuous mode
<6>device rtr2-et4 entered promiscuous mode
<6>device rtr2-et5 entered promiscuous mode
<6>device rtr2-et21 entered promiscuous mode
<6>device rtr2-et26 entered promiscuous mode
<6>device rtr2-et15 entered promiscuous mode
<6>device rtr2-et23 entered promiscuous mode
<6>device rtr2-et27 entered promiscuous mode
<6>device rtr2-et17 entered promiscuous mode
<6>device rtr2-et25 entered promiscuous mode
<6>device rtr2-et24 entered promiscuous mode
<6>device rtr2-et28 entered promiscuous mode
<6>device rtr2-et18 entered promiscuous mode
<6>device rtr2-et19 entered promiscuous mode
<6>device rtr2-et14 entered promiscuous mode
<6>device rtr2-et20 entered promiscuous mode
<6>device rtr2-et16 entered promiscuous mode
<6>device rtr2-et22 entered promiscuous mode
<6>device rtr2-et10 entered promiscuous mode
<6>device rtr2-et11 entered promiscuous mode
<6>device rtr2-et12 entered promiscuous mode
<6>device rtr2-et13 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): e12: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): e12: link becomes ready
<6>ADDRCONF(NETDEV_UP): e23: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): e23: link becomes ready
<6>ADDRCONF(NETDEV_UP): e1: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): e1: link becomes ready
<6>ADDRCONF(NETDEV_UP): e2: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): e2: link becomes ready
<6>ADDRCONF(NETDEV_UP): e3: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): e3: link becomes ready
<6>device rtr3-et2 entered promiscuous mode
<6>device rtr3-et1 entered promiscuous mode
<6>device rtr3-et1 entered promiscuous mode
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268126 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268126 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268126 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268126 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<4>126 free blocks as per group info. But got 128 blocks
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host1-e0 entered promiscuous mode
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host2-e0 entered promiscuous mode
<6>ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>device host3-e0 entered promiscuous mode
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268126 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268126 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268126 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268126 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268126 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268126 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268126 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268124 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268124 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268124 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268124 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268124 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268124 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<4>124 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268122 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268122 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268122 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268122 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268122 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268120 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268118 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268116 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268116 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268114 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268114 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268114 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268114 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268114 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268112 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268112 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268112 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268110 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<4>108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268108 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268106 free blocks as per group info. But got 128 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126842 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126842 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126842 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126862 free blocks as per group info. But got 84 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126862 free blocks as per group info. But got 84 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126850 free blocks as per group info. But got 72 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126850 free blocks as per group info. But got 72 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126850 free blocks as per group info. But got 72 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126850 free blocks as per group info. But got 72 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126850 free blocks as per group info. But got 72 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126842 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126842 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126842 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126842 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126834 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126832 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126832 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126832 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126832 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126832 free blocks as per group info. But got 64 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 126815 free blocks as per group info. But got 47 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682 free blocks as per group info. But got 4 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682 free blocks as per group info. But got 36 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682046 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682046 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682046 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682046 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682046 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682046 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682046 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682046 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682046 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682046 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682046 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682046 free blocks as per group info. But got 2048 blocks
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682046 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682046 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682044 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682038 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682038 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682038 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682034 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682034 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682034 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682032 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682030 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682030 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682030 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682030 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682030 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682030 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682030 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682030 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682028 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682028 free blocks as per group info. But got 2048 blocks
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<4>2026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<1>BUG: Bad page map in process [manager]  pte:ffff8800aeb67748 pmd:aeb67067
<1>addr:000000000bae9000 vm_flags:00100073 anon_vma:ffff880037bca140 mapping:          (null) index:bae9
<4>Pid: 6421, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff810f0769>] ? vfs_write+0xcb/0xfa
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<1>BUG: Bad page map in process [manager]  pte:ffff8800aeb67748 pmd:aeb67067
<1>addr:000000000baea000 vm_flags:00100073 anon_vma:ffff880037bca140 mapping:          (null) index:baea
<4>Pid: 6421, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff810f0769>] ? vfs_write+0xcb/0xfa
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff81042448>] ? sys_exit_group+0x12/0x16
<4> [<ffffffff8102cd90>] ? sysenter_dispatch+0x7/0x2e
<6>device rtr2-et1 left promiscuous mode
<1>BUG: Bad page map in process ribd  pte:ffff88001dae1748 pmd:1dae1067
<1>addr:00000000082e9000 vm_flags:08001875 anon_vma:          (null) mapping:ffff880002d96078 index:2a1
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682026 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682014 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682014 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682014 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682014 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682010 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682010 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682010 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682010 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682010 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682010 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682010 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682006 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682006 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682006 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682006 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682006 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682006 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682006 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 12682006 free blocks as per group info. But got 2048 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268974 free blocks as per group info. But got 1024 blocks
<4>JBD: Spotted dirty metadata buffer (dev = sda3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268972 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268972 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268972 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268972 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268972 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268972 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268972 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268972 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268970 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268970 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268964 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268964 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268964 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268964 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268964 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268964 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268964 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268964 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268964 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268964 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268964 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268964 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268962 free blocks as per group info. But got 1024 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268460 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268460 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268460 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268460 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268460 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268460 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268460 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268460 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268460 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268460 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268460 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268456 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268456 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268460 free blocks as per group info. But got 512 blocks
<4>Clocksource tsc unstable (delta = -8589933024 ns)
<1>vma->vm_ops->fault: filemap_fault+0x0/0x351
<1>vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x4f
<4>Pid: 12104, comm: ribd Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff810fe77b>] ? pollwake+0x0/0x4f
<4> [<ffffffff8104cd46>] ? recalc_sigpending_tsk+0x35/0x3c
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff8104e891>] ? get_signal_to_deliver+0x337/0x35d
<4> [<ffffffff81001e95>] ? do_signal+0x6d/0x65e
<4> [<ffffffff810088fe>] ? read_tsc+0x9/0x19
<4> [<ffffffff8105f9f5>] ? timekeeping_get_ns+0x16/0x38
<4> [<ffffffff8105fdc8>] ? ktime_get_ts+0x80/0x89
<4> [<ffffffff8112635d>] ? poll_select_copy_remaining+0xc5/0xe9
<4> [<ffffffff810024c1>] ? do_notify_resume+0x27/0x69
<4> [<ffffffff81002c60>] ? int_signal+0x12/0x17
<1>BUG: Bad page map in process ribd  pte:ffff88001dae1748 pmd:1dae1067
<1>addr:00000000082ea000 vm_flags:08001875 anon_vma:          (null) mapping:ffff880002d96078 index:2a2
<1>vma->vm_ops->fault: filemap_fault+0x0/0x351
<1>vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x4f
<4>Pid: 12104, comm: ribd Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff810fe77b>] ? pollwake+0x0/0x4f
<4> [<ffffffff8104cd46>] ? recalc_sigpending_tsk+0x35/0x3c
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff8104e891>] ? get_signal_to_deliver+0x337/0x35d
<4> [<ffffffff81001e95>] ? do_signal+0x6d/0x65e
<4> [<ffffffff810088fe>] ? read_tsc+0x9/0x19
<4> [<ffffffff8105f9f5>] ? timekeeping_get_ns+0x16/0x38
<4> [<ffffffff8105fdc8>] ? ktime_get_ts+0x80/0x89
<4> [<ffffffff8112635d>] ? poll_select_copy_remaining+0xc5/0xe9
<4> [<ffffffff810024c1>] ? do_notify_resume+0x27/0x69
<4> [<ffffffff81002c60>] ? int_signal+0x12/0x17
<6>Switching to clocksource hpet
<6>device rtr3-et1 left promiscuous mode
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268476 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268476 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268476 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268476 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268476 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268476 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268472 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268472 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268472 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268472 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268472 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268472 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268472 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268470 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268470 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268468 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268468 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268468 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268466 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268466 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268466 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268466 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268460 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268460 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268448 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268448 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268448 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268448 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268448 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268442 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268432 free blocks as per group info. But got 512 blocks
<2>EXT4-fs error (device sda3): ext4_mb_complex_scan_group:1897: group 1268432 free blocks as per group info. But got 512 blocks
<6>device rtr1-et8 left promiscuous mode
<6>device rtr1-et9 left promiscuous mode
<6>device rtr1-et2 left promiscuous mode
<6>device rtr1-et3 left promiscuous mode
<6>device rtr1-et1 left promiscuous mode
<6>device rtr1-et6 left promiscuous mode
<6>device rtr1-et7 left promiscuous mode
<6>device rtr1-et4 left promiscuous mode
<6>device rtr1-et5 left promiscuous mode
<6>device rtr1-et14 left promiscuous mode
<6>device rtr1-et15 left promiscuous mode
<6>device rtr1-et23 left promiscuous mode
<6>device rtr1-et17 left promiscuous mode
<6>device rtr1-et24 left promiscuous mode
<6>device rtr1-et18 left promiscuous mode
<6>device rtr1-et19 left promiscuous mode
<6>device rtr1-et21 left promiscuous mode
<6>device rtr1-et20 left promiscuous mode
<6>device rtr1-et16 left promiscuous mode
<6>device rtr1-et22 left promiscuous mode
<6>device rtr1-et10 left promiscuous mode
<6>device rtr1-et11 left promiscuous mode
<6>device rtr1-et12 left promiscuous mode
<6>device rtr1-et13 left promiscuous mode
<1>BUG: Bad page map in process Ira  pte:ffff88004b41f748 pmd:4b41f067
<1>addr:00000000f3ce9000 vm_flags:00100073 anon_vma:ffff880093281848 mapping:          (null) index:f3ce9
<4>Pid: 5428, comm: Ira Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1
<4>Call Trace:
<4> [<ffffffff810c92c0>] ? print_bad_pte+0x19e/0x1b7
<4> [<ffffffff810ca056>] ? vm_normal_page+0x4b/0x82
<4> [<ffffffff810cacca>] ? unmap_vmas+0x39f/0x75e
<4> [<ffffffff810d0239>] ? exit_mmap+0x9d/0x114
<4> [<ffffffff8103c4a6>] ? mmput+0x43/0xe6
<4> [<ffffffff810419e4>] ? exit_mm+0x134/0x141
<4> [<ffffffff813d0dbc>] ? _raw_spin_lock_irq+0x1a/0x1c
<4> [<ffffffff81041c1d>] ? do_exit+0x22c/0x7a6
<4> [<ffffffff8104cd46>] ? recalc_sigpending_tsk+0x35/0x3c
<4> [<ffffffff8104240e>] ? do_group_exit+0x74/0x9c
<4> [<ffffffff8104e891>] ? get_signal_to_deliver+0x337/0x35d
<4> [<ffffffff81001e95>] ? do_signal+0x6d/0x65e
<4> [<ffffffff8105f9f5>] ? timekeeping_get_ns+0x16/0x38
<4> [<ffffffff8105fdc8>] ? ktime_get_ts+0x80/0x89
<4> [<ffffffff8112635d>] ? poll_select_copy_remaining+0xc5/0xe9
<4> [<ffffffff810024c1>] ? do_notify_resume+0x27/0x69
<4> [<ffffffff81002c60>] ? int_signal+0x12/0x17
<1>BUG: Bad page map in process Ira  pte:ffff88004b41f748 pmd:4b41f067
<1>addr:00000000f3cea000 vm_flags:00100073 anon_vma:ffff880093281848 mapping:          (null) index:f3cea
<1>BUG: unable to handle kernel paging request at 0000000008000085
<1>IP: [<ffffffff8107401b>] acct_collect+0x54/0x181
<4>PGD 4acff067 PUD a8948067 PMD 941ef067 PTE 0
<0>Oops: 0000 [#1] SMP 
<0>last sysfs file: /sys/devices/virtual/net/bond0/bonding/slaves
<4>CPU 2 
<4>Modules linked in: macvtap ipt_LOG xt_limit ipt_REJECT xt_hl xt_state dummy tulip xt_tcpudp iptable_filter inet_diag veth macvlan nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc dm_mirror dm_region_hash dm_log uinput bonding ipv6 kvm_intel kvm fuse xt_multiport iptable_nat ip_tables nf_nat x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 tun 8021q i5k_amb i5400_edac iTCO_wdt iTCO_vendor_support i2c_i801 edac_core ioatdma dca shpchp serio_raw pcspkr microcode ghes hed sg radeon ttm drm_kms_helper drm hwmon i2c_algo_bit i2c_core sr_mod cdrom igb netxen_nic ehci_hcd uhci_hcd dm_mod [last unloaded: mperf]
<4>
<4>Pid: 6460, comm: [manager] Tainted: G    B       2.6.38-rc4-357643.2010AroraKernelBeta.fc14.x86_64 #1 X7DWU/X7DWU
<4>RIP: 0010:[<ffffffff8107401b>]  [<ffffffff8107401b>] acct_collect+0x54/0x181
<4>RSP: 0018:ffff8800174bfc98  EFLAGS: 00210202
<4>RAX: 0000000008000075 RBX: 0000000000000009 RCX: ffff88001750cc70
<4>RDX: 0000000000002577 RSI: 0000000000000001 RDI: ffff88007d1ce960
<4>RBP: ffff8800174bfcc8 R08: 0000000000000000 R09: ffff88001750cc00
<4>R10: 00007ffffffff000 R11: ffff88028ed62000 R12: ffff88001750cc00
<4>R13: 000077ff8e6d58dd R14: ffff8801e51d14a0 R15: 0000000000000001
<4>FS:  0000000000000000(0000) GS:ffff8800cfc80000(0063) knlGS:00000000f73f1940
<4>CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
<4>CR2: 0000000008000085 CR3: 00000000108a6000 CR4: 00000000000006e0
<4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>Process [manager] (pid: 6460, threadinfo ffff8800174be000, task ffff8801e51d14a0)
<0>Stack:
<4> ffff8800174bfcc8 ffff8801e51d14a0 0000000000000009 ffff88007d1ce900
<4> ffff88001750cc00 0000000000000001 ffff8800174bfd48 ffffffff81041be7
<4> 0000000000000088 0000000000002573 ffff8800174bfcf8 00000000000001e5
<0>Call Trace:
<4> [<ffffffff81041be7>] do_exit+0x1f6/0x7a6
<4> [<ffffffff8104128e>] ? wait_consider_task+0x904/0x911
<4> [<ffffffff8104cd46>] ? recalc_sigpending_tsk+0x35/0x3c
<4> [<ffffffff8104240e>] do_group_exit+0x74/0x9c
<4> [<ffffffff8104e891>] get_signal_to_deliver+0x337/0x35d
<4> [<ffffffff81001e95>] do_signal+0x6d/0x65e
<4> [<ffffffff8104037b>] ? child_wait_callback+0x0/0x53
<4> [<ffffffff8105f9f5>] ? timekeeping_get_ns+0x16/0x38
<4> [<ffffffff8105fdc8>] ? ktime_get_ts+0x80/0x89
<4> [<ffffffff8112635d>] ? poll_select_copy_remaining+0xc5/0xe9
<4> [<ffffffff810024c1>] do_notify_resume+0x27/0x69
<4> [<ffffffff81002c60>] int_signal+0x12/0x17
<0>Code: 04 00 00 74 50 49 83 be 58 01 00 00 00 74 46 49 8b be 58 01 00 00 48 83 c7 60 e8 75 c6 35 00 49 8b 86 58 01 00 00 48 8b 00 eb 0c <4c> 03 68 10 4c 2b 68 08 48 8b 40 18 48 85 c0 75 ef 65 48 8b 04 
<1>RIP  [<ffffffff8107401b>] acct_collect+0x54/0x181
<4> RSP <ffff8800174bfc98>
<0>CR2: 0000000008000085

--=-=-=--
