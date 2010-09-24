Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab0IXTMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:12:22 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57531 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757522Ab0IXTMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:12:14 -0400
Date: Fri, 24 Sep 2010 12:12:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
Cc: Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.36-rc5 backtrace] NMI watchdog detects rcu_sched_state
 stall
Message-ID: <20100924191202.GI2375@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <courier.4C98F124.00000CF9@fs.uni-ruse.bg>
 <20100922154010.GJ26290@redhat.com>
 <4C9AFF73.2060401@fs.uni-ruse.bg>
 <4C9B2049.1070500@fs.uni-ruse.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9B2049.1070500@fs.uni-ruse.bg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 12:39:21PM +0300, Plamen Petrov wrote:
> Hello again, Don!
> 
> Here is what I've got this time, and now it is dmesg + kernel .config:
> 
> >[  413.009603] XFS mounting filesystem md1
> >[  413.159227] Ending clean XFS mount for filesystem: md1
> >[ 3786.389501] IN=eth0 OUT= MAC=00:0e:2e:5c:27:ef:00:0e:2e:5c:27:b2:08:00 SRC=112.90.146.2 DST=192.168.1.2 LEN=48 TOS=0x00 PREC=0x00 TTL=115 ID=14727 PROTO=TCP SPT=40708 DPT=22 WINDOW=65535 RES=0x00 SYN URGP=0
> >[ 3789.079725] IN=eth0 OUT= MAC=00:0e:2e:5c:27:ef:00:0e:2e:5c:27:b2:08:00 SRC=112.90.146.2 DST=192.168.1.2 LEN=48 TOS=0x00 PREC=0x00 TTL=115 ID=1948 PROTO=TCP SPT=1116 DPT=22 WINDOW=65535 RES=0x00 SYN URGP=0
> >[ 3791.679944] IN=eth0 OUT= MAC=00:0e:2e:5c:27:ef:00:0e:2e:5c:27:b2:08:00 SRC=112.90.146.2 DST=192.168.1.2 LEN=48 TOS=0x00 PREC=0x00 TTL=115 ID=4706 PROTO=TCP SPT=1117 DPT=22 WINDOW=65535 RES=0x00 SYN URGP=0
> >[ 3794.280165] IN=eth0 OUT= MAC=00:0e:2e:5c:27:ef:00:0e:2e:5c:27:b2:08:00 SRC=112.90.146.2 DST=192.168.1.2 LEN=48 TOS=0x00 PREC=0x00 TTL=115 ID=18833 PROTO=TCP SPT=1118 DPT=22 WINDOW=65535 RES=0x00 SYN URGP=0
> >[ 3796.880371] IN=eth0 OUT= MAC=00:0e
> >[ 3797.260001] INFO: rcu_sched_state detected stall on CPU 0 (t=1000 jiffies)
> >[ 3797.260001] sending NMI to all CPUs:
> >[ 3807.480225] :2e:5c:27:ef:00:0e:2e:5c:27:b2:08:00 SRC=112.90.146.2 DST=192.168.1.2 LEN=48 TOS=0x00 PREC=0x00 TTL=115 ID=2624 PROTO=TCP SPT=1119 DPT=22 WINDOW=65535 RES=0x00 SYN URGP=0
> 
> For the record, I have setup the machine to log and drop all attempts to
> connect to the world exposed port 22, and as you can see, we've got a
> rcu_sched_state stall during such a print...

Interesting -- no stack trace.  Or did the stack traces appear later?
The usual cause of an rcu_sched stall is an infinite loop with either
preemption, bh, or irqs disabled.  The stack traces should help narrow
down where the problem lies, particularly if you get repeated stall
warnings.

See Documentation/RCU/stallwarn.txt for more information on tracking
these down.

							Thanx, Paul

> Plamen

> [    0.000000] Linux version 2.6.36-rc5-FS-00049-gc79bd89 (root@crux) (gcc version 4.4.4 (CRUX) (GCC) ) #1 SMP Thu Sep 23 09:37:01 EEST 2010
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000001fe7cc00 (usable)
> [    0.000000]  BIOS-e820: 000000001fe7cc00 - 000000001fe7ec00 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000001fe7ec00 - 000000001fe80c00 (ACPI data)
> [    0.000000]  BIOS-e820: 000000001fe80c00 - 0000000020000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.3 present.
> [    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> [    0.000000] last_pfn = 0x1fe7c max_arch_pfn = 0x1000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CBFFF write-protect
> [    0.000000]   CC000-EFFFF uncachable
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask 000000000 write-back
> [    0.000000]   1 base 01FF00000 mask FFFF00000 uncachable
> [    0.000000]   2 base 020000000 mask FE0000000 uncachable
> [    0.000000]   3 base 040000000 mask FC0000000 uncachable
> [    0.000000]   4 base 080000000 mask F80000000 uncachable
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] original variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 64GB, type WB
> [    0.000000] reg 1, base: 511MB, range: 1MB, type UC
> [    0.000000] reg 2, base: 512MB, range: 512MB, type UC
> [    0.000000] reg 3, base: 1GB, range: 1GB, type UC
> [    0.000000] reg 4, base: 2GB, range: 2GB, type UC
> [    0.000000] total RAM covered: 61951M
> [    0.000000] Found optimal setting for mtrr clean up
> [    0.000000]  gran_size: 64K 	chunk_size: 2M 	num_reg: 6  	lose cover RAM: 0G
> [    0.000000] New variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 512MB, type WB
> [    0.000000] reg 1, base: 511MB, range: 1MB, type UC
> [    0.000000] reg 2, base: 4GB, range: 4GB, type WB
> [    0.000000] reg 3, base: 8GB, range: 8GB, type WB
> [    0.000000] reg 4, base: 16GB, range: 16GB, type WB
> [    0.000000] reg 5, base: 32GB, range: 32GB, type WB
> [    0.000000] e820 update range: 000000001ff00000 - 0000000100000000 (usable) ==> (reserved)
> [    0.000000] initial memory mapped : 0 - 01a00000
> [    0.000000] init_memory_mapping: 0000000000000000-000000001fe7c000
> [    0.000000]  0000000000 - 0000200000 page 4k
> [    0.000000]  0000200000 - 001fe00000 page 2M
> [    0.000000]  001fe00000 - 001fe7c000 page 4k
> [    0.000000] kernel direct mapping tables up to 1fe7c000 @ 7000-c000
> [    0.000000] ACPI: RSDP 000febf0 00024 (v02 DELL  )
> [    0.000000] ACPI: XSDT 000fd1f2 0005C (v01 DELL    B8K     00000014 ASL  00000061)
> [    0.000000] ACPI: FACP 000fd30a 000F4 (v03 DELL    B8K     00000014 ASL  00000061)
> [    0.000000] ACPI: DSDT fffcf763 02D58 (v01   DELL    dt_ex 00001000 INTL 20050624)
> [    0.000000] ACPI: FACS 1fe7cc00 00040
> [    0.000000] ACPI: SSDT fffd2688 00088 (v01   DELL    st_ex 00001000 INTL 20050624)
> [    0.000000] ACPI: APIC 000fd3fe 00092 (v01 DELL    B8K     00000014 ASL  00000061)
> [    0.000000] ACPI: BOOT 000fd490 00028 (v01 DELL    B8K     00000014 ASL  00000061)
> [    0.000000] ACPI: ASF! 000fd4b8 00067 (v16 DELL    B8K     00000014 ASL  00000061)
> [    0.000000] ACPI: MCFG 000fd51f 0003E (v01 DELL    B8K     00000014 ASL  00000061)
> [    0.000000] ACPI: HPET 000fd55d 00038 (v01 DELL    B8K     00000014 ASL  00000061)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] 510MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 1fe7c000
> [    0.000000]   low ram: 0 - 1fe7c000
> [    0.000000]   node 0 low ram: 00000000 - 1fe7c000
> [    0.000000]   node 0 bootmap 00003000 - 00006fd0
> [    0.000000] (7/32 early reservations) ==> bootmem [0000000000 - 001fe7c000]
> [    0.000000]   #0 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
> [    0.000000]   #1 [0001000000 - 0001663838]    TEXT DATA BSS ==> [0001000000 - 0001663838]
> [    0.000000]   #2 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
> [    0.000000]   #3 [0001664000 - 0001671168]              BRK ==> [0001664000 - 0001671168]
> [    0.000000]   #4 [0000002000 - 0000003000]       TRAMPOLINE ==> [0000002000 - 0000003000]
> [    0.000000]   #5 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
> [    0.000000]   #6 [0000003000 - 0000007000]          BOOTMAP ==> [0000003000 - 0000007000]
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000001 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x0001fe7c
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[2] active PFN ranges
> [    0.000000]     0: 0x00000001 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x0001fe7c
> [    0.000000] On node 0 totalpages: 130586
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3966 pages, LIFO batch:0
> [    0.000000]   Normal zone: 989 pages used for memmap
> [    0.000000]   Normal zone: 125599 pages, LIFO batch:31
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x01] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x02] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x03] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] Allocating PCI resources starting at 20000000 (gap: 20000000:d0000000)
> [    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 11 pages/cpu @c1c00000 s31744 r0 d13312 u1048576
> [    0.000000] pcpu-alloc: s31744 r0 d13312 u1048576 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129565
> [    0.000000] Kernel command line: ro root=/dev/md5 vga=6 nmi_watchdog=1
> [    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Enabling fast FPU save and restore... done.
> [    0.000000] Enabling unmasked SIMD FPU exception support... done.
> [    0.000000] Initializing CPU#0
> [    0.000000] Memory: 511128k/522736k available (3749k kernel code, 11216k reserved, 1876k data, 496k init, 0k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xfff67000 - 0xfffff000   ( 608 kB)
> [    0.000000]     vmalloc : 0xe067c000 - 0xfff65000   ( 504 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xdfe7c000   ( 510 MB)
> [    0.000000]       .init : 0xc157f000 - 0xc15fb000   ( 496 kB)
> [    0.000000]       .data : 0xc13a9529 - 0xc157e78c   (1876 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc13a9529   (3749 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] SLUB: Genslabs=13, HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	Verbose stalled-CPUs detection is disabled.
> [    0.000000] NR_IRQS:384
> [    0.000000] Console: colour VGA+ 80x60
> [    0.000000] console [tty0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2992.440 MHz processor.
> [    0.010005] Calibrating delay loop (skipped), value calculated using timer frequency.. 5984.88 BogoMIPS (lpj=29924400)
> [    0.010214] pid_max: default: 32768 minimum: 301
> [    0.010340] Mount-cache hash table entries: 512
> [    0.010587] CPU: Physical Processor ID: 0
> [    0.010689] CPU: Processor Core ID: 0
> [    0.010791] mce: CPU supports 4 MCE banks
> [    0.010901] CPU0: Thermal monitoring enabled (TM1)
> [    0.011006] using mwait in idle threads.
> [    0.011113] Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
> [    0.011264] ... version:                0
> [    0.011365] ... bit width:              40
> [    0.011466] ... generic registers:      18
> [    0.011568] ... value mask:             000000ffffffffff
> [    0.011671] ... max period:             0000007fffffffff
> [    0.011776] ... fixed-purpose events:   0
> [    0.011877] ... event mask:             000000000003ffff
> [    0.012729] Freeing SMP alternatives: 20k freed
> [    0.012843] ACPI: Core revision 20100702
> [    0.087214] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.087638] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.187757] CPU0: Intel(R) Pentium(R) D CPU 3.00GHz stepping 05
> [    0.190000] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.190000] Booting Node   0, Processors  #1 Ok.
> [    0.020000] Initializing CPU#1
> [    0.350029] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.350262] Brought up 2 CPUs
> [    0.350364] Total of 2 processors activated (11970.14 BogoMIPS).
> [    0.351073] xor: automatically using best checksumming function: pIII_sse
> [    0.400004]    pIII_sse  :  4786.400 MB/sec
> [    0.400107] xor: using function: pIII_sse (4786.400 MB/sec)
> [    0.400249] NET: Registered protocol family 16
> [    0.400377] EISA bus registered
> [    0.400377] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> [    0.400377] ACPI: bus type pci registered
> [    0.400427] dca service started, version 1.12.1
> [    0.400427] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
> [    0.400427] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
> [    0.400427] PCI: Using MMCONFIG for extended config space
> [    0.400427] PCI: Using configuration type 1 for base access
> [    0.400575] bio: create slab <bio-0> at 0
> [    0.570034] raid6: int32x1    784 MB/s
> [    0.740022] raid6: int32x2    731 MB/s
> [    0.910035] raid6: int32x4    759 MB/s
> [    1.080025] raid6: int32x8    547 MB/s
> [    1.250005] raid6: mmxx1     1820 MB/s
> [    1.420011] raid6: mmxx2     2141 MB/s
> [    1.590048] raid6: sse1x1    1085 MB/s
> [    1.760034] raid6: sse1x2    1893 MB/s
> [    1.930012] raid6: sse2x1    2225 MB/s
> [    2.100016] raid6: sse2x2    3125 MB/s
> [    2.100118] raid6: using algorithm sse2x2 (3125 MB/s)
> [    2.100997] ACPI: EC: Look up EC in DSDT
> [    2.119281] ACPI: BIOS _OSI(Linux) query ignored
> [    2.129487] ACPI: Interpreter enabled
> [    2.129589] ACPI: (supports S0 S5)
> [    2.129742] ACPI: Using IOAPIC for interrupt routing
> [    2.183318] ACPI: No dock devices found.
> [    2.183318] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
> [    2.191037] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    2.197174] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
> [    2.197179] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
> [    2.197183] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
> [    2.197187] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff] (ignored)
> [    2.197191] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff] (ignored)
> [    2.197194] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xefffffff] (ignored)
> [    2.197198] pci_root PNP0A03:00: host bridge window [mem 0xf4000000-0xfebfffff] (ignored)
> [    2.197202] pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff] (ignored)
> [    2.197205] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff] (ignored)
> [    2.197310] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    2.197315] pci 0000:00:01.0: PME# disabled
> [    2.197427] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    2.197432] pci 0000:00:1c.0: PME# disabled
> [    2.197521] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    2.197526] pci 0000:00:1c.4: PME# disabled
> [    2.197612] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
> [    2.197617] pci 0000:00:1c.5: PME# disabled
> [    2.197685] pci 0000:00:1d.0: reg 20: [io  0xff80-0xff9f]
> [    2.197762] pci 0000:00:1d.1: reg 20: [io  0xff60-0xff7f]
> [    2.197842] pci 0000:00:1d.2: reg 20: [io  0xff40-0xff5f]
> [    2.197907] pci 0000:00:1d.7: reg 10: [mem 0xff980800-0xff980bff]
> [    2.197986] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    2.197992] pci 0000:00:1d.7: PME# disabled
> [    2.198159] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
> [    2.198344] pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by ICH6 GPIO
> [    2.198454] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (mask 007f)
> [    2.198637] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0 (mask 0007)
> [    2.200052] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
> [    2.200064] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
> [    2.200075] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
> [    2.200087] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
> [    2.200098] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
> [    2.200151] pci 0000:00:1f.2: reg 10: [io  0xfe00-0xfe07]
> [    2.200161] pci 0000:00:1f.2: reg 14: [io  0xfe10-0xfe13]
> [    2.200171] pci 0000:00:1f.2: reg 18: [io  0xfe20-0xfe27]
> [    2.200182] pci 0000:00:1f.2: reg 1c: [io  0xfe30-0xfe33]
> [    2.200192] pci 0000:00:1f.2: reg 20: [io  0xfec0-0xfecf]
> [    2.200202] pci 0000:00:1f.2: reg 24: [mem 0xeffffc00-0xefffffff]
> [    2.200229] pci 0000:00:1f.2: PME# supported from D3hot
> [    2.200234] pci 0000:00:1f.2: PME# disabled
> [    2.200304] pci 0000:00:1f.3: reg 20: [io  0xece0-0xecff]
> [    2.200377] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> [    2.200484] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
> [    2.200489] pci 0000:00:01.0:   bridge window [mem 0xefe00000-0xefefffff]
> [    2.200496] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
> [    2.200544] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
> [    2.205015] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
> [    2.205020] pci 0000:00:1c.0:   bridge window [mem 0xefd00000-0xefdfffff]
> [    2.205028] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
> [    2.205077] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
> [    2.205184] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disabled)
> [    2.205189] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
> [    2.205197] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
> [    2.205296] pci 0000:04:00.0: reg 10: [mem 0xefcf0000-0xefcfffff 64bit]
> [    2.205406] pci 0000:04:00.0: PME# supported from D3hot D3cold
> [    2.205412] pci 0000:04:00.0: PME# disabled
> [    2.205432] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
> [    2.205540] pci 0000:00:1c.5:   bridge window [io  0xf000-0x0000] (disabled)
> [    2.205546] pci 0000:00:1c.5:   bridge window [mem 0xefc00000-0xefcfffff]
> [    2.205553] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
> [    2.205613] pci 0000:05:02.0: reg 10: [io  0xd400-0xd4ff]
> [    2.205626] pci 0000:05:02.0: reg 14: [mem 0xefaefe00-0xefaefeff]
> [    2.205693] pci 0000:05:02.0: supports D1 D2
> [    2.205696] pci 0000:05:02.0: PME# supported from D1 D2 D3hot D3cold
> [    2.205702] pci 0000:05:02.0: PME# disabled
> [    2.205741] pci 0000:05:04.0: reg 10: [io  0xd800-0xd8ff]
> [    2.205754] pci 0000:05:04.0: reg 14: [mem 0xefaeff00-0xefaeffff]
> [    2.205821] pci 0000:05:04.0: supports D1 D2
> [    2.205824] pci 0000:05:04.0: PME# supported from D1 D2 D3hot D3cold
> [    2.205829] pci 0000:05:04.0: PME# disabled
> [    2.205871] pci 0000:05:07.0: reg 10: [mem 0xe0000000-0xe7ffffff pref]
> [    2.205883] pci 0000:05:07.0: reg 14: [io  0xdc00-0xdcff]
> [    2.205896] pci 0000:05:07.0: reg 18: [mem 0xefaf0000-0xefafffff]
> [    2.205936] pci 0000:05:07.0: reg 30: [mem 0xefb00000-0xefb1ffff pref]
> [    2.205959] pci 0000:05:07.0: supports D1 D2
> [    2.206002] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
> [    2.206113] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
> [    2.206118] pci 0000:00:1e.0:   bridge window [mem 0xefa00000-0xefbfffff]
> [    2.206126] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe7ffffff 64bit pref]
> [    2.206130] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
> [    2.206133] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffffffffffff] (subtractive decode)
> [    2.206159] pci_bus 0000:00: on NUMA node 0
> [    2.206164] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    2.206655] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
> [    2.207143] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
> [    2.207455] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
> [    2.207734] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI5._PRT]
> [    2.207983] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI6._PRT]
> [    2.730157] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
> [    2.730976] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
> [    2.731743] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 7 9 10 11 12 15)
> [    2.732532] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 15)
> [    2.733320] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 9 10 11 12 15)
> [    2.734086] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 15)
> [    2.734896] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 15)
> [    2.735677] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
> [    2.736277] vgaarb: device added: PCI:0000:05:07.0,decodes=io+mem,owns=io+mem,locks=none
> [    2.736277] vgaarb: loaded
> [    2.736277] SCSI subsystem initialized
> [    2.736277] libata version 3.00 loaded.
> [    2.736277] usbcore: registered new interface driver usbfs
> [    2.736277] usbcore: registered new interface driver hub
> [    2.736277] usbcore: registered new device driver usb
> [    2.736277] PCI: Using ACPI for IRQ routing
> [    2.736277] PCI: pci_cache_line_size set to 64 bytes
> [    2.736277] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
> [    2.736277] reserve RAM buffer: 000000001fe7cc00 - 000000001fffffff 
> [    2.736277] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    2.736277] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    2.736277] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> [    2.750050] Switching to clocksource tsc
> [    2.750158] pnp: PnP ACPI init
> [    2.750265] ACPI: bus type pnp registered
> [    2.756561] pnp 00:01: disabling [io  0x0800-0x085f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x0800-0x087f]
> [    2.756750] pnp 00:01: disabling [io  0x0860-0x08ff] because it overlaps 0000:00:1f.0 BAR 7 [io  0x0800-0x087f]
> [    2.777265] pnp: PnP ACPI: found 8 devices
> [    2.777368] ACPI: ACPI bus type pnp unregistered
> [    2.777482] system 00:01: [io  0x0c00-0x0c7f] has been reserved
> [    2.777602] system 00:06: [mem 0x00000000-0x0009ffff] could not be reserved
> [    2.777711] system 00:06: [mem 0x00100000-0x00ffffff] could not be reserved
> [    2.777820] system 00:06: [mem 0x01000000-0x1fe7cbff] could not be reserved
> [    2.777928] system 00:06: [mem 0x000f0000-0x000fffff] could not be reserved
> [    2.778036] system 00:06: [mem 0x000c0000-0x000cbfff] could not be reserved
> [    2.778145] system 00:06: [mem 0xfec00000-0xfecfffff] could not be reserved
> [    2.778253] system 00:06: [mem 0xfee00000-0xfeefffff] has been reserved
> [    2.778361] system 00:06: [mem 0xffb00000-0xffbfffff] has been reserved
> [    2.778468] system 00:06: [mem 0xffc00000-0xffffffff] has been reserved
> [    2.778578] system 00:07: [mem 0xf0000000-0xf3ffffff] has been reserved
> [    2.778686] system 00:07: [mem 0xfeda0000-0xfedacfff] has been reserved
> [    2.818091] pci 0000:00:1c.0: BAR 9: assigned [mem 0x20000000-0x201fffff 64bit pref]
> [    2.818276] pci 0000:00:1c.4: BAR 8: assigned [mem 0x20200000-0x203fffff]
> [    2.818384] pci 0000:00:1c.4: BAR 9: assigned [mem 0x20400000-0x205fffff 64bit pref]
> [    2.818567] pci 0000:00:1c.5: BAR 9: assigned [mem 0x20600000-0x207fffff 64bit pref]
> [    2.818751] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
> [    2.818859] pci 0000:00:1c.4: BAR 7: assigned [io  0x2000-0x2fff]
> [    2.818966] pci 0000:00:1c.5: BAR 7: assigned [io  0x3000-0x3fff]
> [    2.819073] pci 0000:00:01.0: PCI bridge to [bus 01-01]
> [    2.819176] pci 0000:00:01.0:   bridge window [io  disabled]
> [    2.819284] pci 0000:00:01.0:   bridge window [mem 0xefe00000-0xefefffff]
> [    2.819392] pci 0000:00:01.0:   bridge window [mem pref disabled]
> [    2.819501] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
> [    2.819606] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
> [    2.819715] pci 0000:00:1c.0:   bridge window [mem 0xefd00000-0xefdfffff]
> [    2.819825] pci 0000:00:1c.0:   bridge window [mem 0x20000000-0x201fffff 64bit pref]
> [    2.820021] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
> [    2.820126] pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
> [    2.820236] pci 0000:00:1c.4:   bridge window [mem 0x20200000-0x203fffff]
> [    2.820345] pci 0000:00:1c.4:   bridge window [mem 0x20400000-0x205fffff 64bit pref]
> [    2.820531] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
> [    2.820636] pci 0000:00:1c.5:   bridge window [io  0x3000-0x3fff]
> [    2.820745] pci 0000:00:1c.5:   bridge window [mem 0xefc00000-0xefcfffff]
> [    2.820854] pci 0000:00:1c.5:   bridge window [mem 0x20600000-0x207fffff 64bit pref]
> [    2.821041] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
> [    2.821146] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
> [    2.821254] pci 0000:00:1e.0:   bridge window [mem 0xefa00000-0xefbfffff]
> [    2.821364] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe7ffffff 64bit pref]
> [    2.821561] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    2.821670] pci 0000:00:01.0: setting latency timer to 64
> [    2.821681] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    2.821791] pci 0000:00:1c.0: setting latency timer to 64
> [    2.821802] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    2.821911] pci 0000:00:1c.4: setting latency timer to 64
> [    2.821922] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    2.822031] pci 0000:00:1c.5: setting latency timer to 64
> [    2.822040] pci 0000:00:1e.0: setting latency timer to 64
> [    2.822045] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
> [    2.822049] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
> [    2.822053] pci_bus 0000:01: resource 1 [mem 0xefe00000-0xefefffff]
> [    2.822057] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
> [    2.822060] pci_bus 0000:02: resource 1 [mem 0xefd00000-0xefdfffff]
> [    2.822064] pci_bus 0000:02: resource 2 [mem 0x20000000-0x201fffff 64bit pref]
> [    2.822067] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
> [    2.822071] pci_bus 0000:03: resource 1 [mem 0x20200000-0x203fffff]
> [    2.822074] pci_bus 0000:03: resource 2 [mem 0x20400000-0x205fffff 64bit pref]
> [    2.822078] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
> [    2.822081] pci_bus 0000:04: resource 1 [mem 0xefc00000-0xefcfffff]
> [    2.822085] pci_bus 0000:04: resource 2 [mem 0x20600000-0x207fffff 64bit pref]
> [    2.822089] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
> [    2.822092] pci_bus 0000:05: resource 1 [mem 0xefa00000-0xefbfffff]
> [    2.822096] pci_bus 0000:05: resource 2 [mem 0xe0000000-0xe7ffffff 64bit pref]
> [    2.822099] pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
> [    2.822103] pci_bus 0000:05: resource 5 [mem 0x00000000-0xffffffffffffffff]
> [    2.822139] NET: Registered protocol family 2
> [    2.822307] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
> [    2.822621] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
> [    2.822876] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
> [    2.823055] TCP: Hash tables configured (established 16384 bind 16384)
> [    2.823161] TCP reno registered
> [    2.823262] UDP hash table entries: 256 (order: 1, 8192 bytes)
> [    2.823371] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
> [    2.823546] NET: Registered protocol family 1
> [    2.823768] pci 0000:05:07.0: Boot video device
> [    2.823774] PCI: CLS 64 bytes, default 64
> [    2.823890] Simple Boot Flag at 0x7a set to 0x1
> [    2.829296] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
> [    2.830285] SGI XFS Quota Management subsystem
> [    2.830403] msgmni has been set to 998
> [    2.831150] async_tx: api initialized (async)
> [    2.831317] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    2.831506] io scheduler noop registered (default)
> [    2.832173] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
> [    2.832360] ACPI: Power Button [VBTN]
> [    2.832562] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [    2.832746] ACPI: Power Button [PWRF]
> [    2.833664] ACPI: acpi_idle registered with cpuidle
> [    2.869161] intel_rng: Firmware space is locked read-only. If you can't or
> [    2.869164] intel_rng: don't want to disable this in firmware setup, and if
> [    2.869165] intel_rng: you are certain that your system has a functional
> [    2.869167] intel_rng: RNG, try using the 'no_fwh_detect' option.
> [    2.869604] Linux agpgart interface v0.103
> [    2.869707] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    2.869889] Hangcheck: Using getrawmonotonic().
> [    2.869994] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    2.872571] loop: module loaded
> [    2.872849] nbd: registered device at major 43
> [    2.875803] ata_piix 0000:00:1f.1: version 2.13
> [    2.875820] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    2.875975] ata_piix 0000:00:1f.1: setting latency timer to 64
> [    2.876059] scsi0 : ata_piix
> [    2.876347] scsi1 : ata_piix
> [    2.876581] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
> [    2.876694] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
> [    2.876828] ata_piix 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
> [    2.876858] ata1: port disabled. ignoring.
> [    2.876923] ata2: port disabled. ignoring.
> [    2.876956] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
> [    2.877198] ata_piix 0000:00:1f.2: setting latency timer to 64
> [    2.877263] scsi2 : ata_piix
> [    2.877505] scsi3 : ata_piix
> [    2.877727] ata3: SATA max UDMA/133 cmd 0xfe00 ctl 0xfe10 bmdma 0xfec0 irq 20
> [    2.877842] ata4: SATA max UDMA/133 cmd 0xfe20 ctl 0xfe30 bmdma 0xfec8 irq 20
> [    2.879387] tg3.c:v3.113 (August 2, 2010)
> [    2.879501] tg3 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    2.879613] tg3 0000:04:00.0: setting latency timer to 64
> [    2.915179] tg3 0000:04:00.0: eth0: Tigon3 [partno(BCM95754) rev b002] (PCI Express) MAC address 00:1a:a0:38:8a:1b
> [    2.915368] tg3 0000:04:00.0: eth0: attached PHY is 5787 (10/100/1000Base-T Ethernet) (WireSpeed[1])
> [    2.915554] tg3 0000:04:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
> [    2.915736] tg3 0000:04:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
> [    2.915914] 8139too: 8139too Fast Ethernet driver 0.9.28
> [    2.916034] 8139too 0000:05:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [    2.916792] 8139too 0000:05:02.0: eth1: RealTek RTL8139 at 0xe0692e00, 00:0e:2e:5c:27:ef, IRQ 18
> [    2.916992] 8139too 0000:05:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    2.917748] 8139too 0000:05:04.0: eth2: RealTek RTL8139 at 0xe0696f00, 00:0e:2e:5c:27:e6, IRQ 16
> [    2.922380] tun: Universal TUN/TAP device driver, 1.6
> [    2.922484] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    2.922695] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    2.922822] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> [    2.922941] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    2.922946] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    2.923072] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
> [    2.923268] ehci_hcd 0000:00:1d.7: using broken periodic workaround
> [    2.923383] ehci_hcd 0000:00:1d.7: debug port 1
> [    2.927359] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
> [    2.927377] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xff980800
> [    2.950014] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    2.950360] hub 1-0:1.0: USB hub found
> [    2.950466] hub 1-0:1.0: 6 ports detected
> [    2.950744] uhci_hcd: USB Universal Host Controller Interface driver
> [    2.950876] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> [    2.950991] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    2.950995] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    2.951106] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    2.951310] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000ff80
> [    2.951638] hub 2-0:1.0: USB hub found
> [    2.951744] hub 2-0:1.0: 2 ports detected
> [    2.951964] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
> [    2.952076] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    2.952081] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    2.952191] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> [    2.952403] uhci_hcd 0000:00:1d.1: irq 22, io base 0x0000ff60
> [    2.952729] hub 3-0:1.0: USB hub found
> [    2.952835] hub 3-0:1.0: 2 ports detected
> [    2.953052] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    2.953165] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    2.953169] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    2.953283] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> [    2.953496] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
> [    2.953822] hub 4-0:1.0: USB hub found
> [    2.953928] hub 4-0:1.0: 2 ports detected
> [    2.954440] PNP: No PS/2 controller found. Probing ports directly.
> [    2.957285] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    2.957393] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    2.957733] mice: PS/2 mouse device common for all mice
> [    2.957915] I2O subsystem v1.325
> [    2.958026] i2o: max drivers = 8
> [    2.958330] I2O Configuration OSM v1.323
> [    2.958567] I2O Bus Adapter OSM v1.317
> [    2.958726] I2O Block Device OSM v1.325
> [    2.959016] I2O SCSI Peripheral OSM v1.316
> [    2.959169] I2O ProcFS OSM v1.316
> [    2.959360] rtc_cmos 00:05: RTC can wake from S4
> [    2.959563] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
> [    2.959695] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
> [    2.959853] i2c /dev entries driver
> [    2.960078] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    3.050229] ata3.00: ATA-8: WDC WD6400AAKS-65A7B2, 01.03B01, max UDMA/133
> [    3.050347] ata3.00: 1250263728 sectors, multi 8: LBA48 NCQ (depth 0/32)
> [    3.050687] ata4.00: ATA-8: WDC WD6400AAKS-65A7B2, 01.03B01, max UDMA/133
> [    3.050795] ata4.00: 1250263728 sectors, multi 8: LBA48 NCQ (depth 0/32)
> [    3.090261] ata4.00: configured for UDMA/133
> [    3.090379] ata3.00: configured for UDMA/133
> [    3.090600] scsi 2:0:0:0: Direct-Access     ATA      WDC WD6400AAKS-6 01.0 PQ: 0 ANSI: 5
> [    3.091081] sd 2:0:0:0: [sda] 1250263728 512-byte logical blocks: (640 GB/596 GiB)
> [    3.091173] sd 2:0:0:0: Attached scsi generic sg0 type 0
> [    3.091329] scsi 3:0:0:0: Direct-Access     ATA      WDC WD6400AAKS-6 01.0 PQ: 0 ANSI: 5
> [    3.091538] sd 3:0:0:0: [sdb] 1250263728 512-byte logical blocks: (640 GB/596 GiB)
> [    3.091607] sd 3:0:0:0: [sdb] Write Protect is off
> [    3.091611] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    3.091641] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    3.091970] sd 3:0:0:0: Attached scsi generic sg1 type 0
> [    3.092213] sd 2:0:0:0: [sda] Write Protect is off
> [    3.092318] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.092348] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    3.194874]  sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 sdb11 sdb12 >
> [    3.196078] sd 3:0:0:0: [sdb] Attached SCSI disk
> [    3.199602]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 >
> [    3.200957] sd 2:0:0:0: [sda] Attached SCSI disk
> [    3.440081] coretemp: CPU (model=0x6) has no thermal sensor.
> [    3.440194] coretemp: CPU (model=0x6) has no thermal sensor.
> [    3.490015] usb 2-2: new low speed USB device using uhci_hcd and address 2
> [    5.080025] pc87360: PC8736x not detected, module not inserted.
> [    5.240017] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
> [    5.240283] iTCO_wdt: unable to reset NO_REBOOT flag, platform may have disabled it
> [    5.240481] iTCO_vendor_support: vendor-support=0
> [    5.240664] Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=60 sec (nowayout= 0)
> [    5.240849] md: linear personality registered for level -1
> [    5.240953] md: raid0 personality registered for level 0
> [    5.241057] md: raid1 personality registered for level 1
> [    5.241161] md: raid6 personality registered for level 6
> [    5.241264] md: raid5 personality registered for level 5
> [    5.241368] md: raid4 personality registered for level 4
> [    5.241472] EDAC MC: Ver: 2.1.0 Sep 23 2010
> [    5.241920] EDAC MC0: Giving out device to 'i3000_edac' 'i3000': DEV 0000:00:00.0
> [    5.242219] EDAC PCI0: Giving out device to module 'i3000_edac' controller 'EDAC PCI controller': DEV '0000:00:00.0' (POLLED)
> [    5.242596] EISA: Probing bus 0 at eisa.0
> [    5.242759] cpuidle: using governor ladder
> [    5.242868] cpuidle: using governor menu
> [    5.242970] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [    5.259246] input: KYE Systems Corp. Wireless Keyboard & Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input2
> [    5.259446] generic-usb 0003:0458:0063.0001: input: USB HID v1.10 Keyboard [KYE Systems Corp. Wireless Keyboard & Mouse] on usb-0000:00:1d.0-2/input0
> [    5.284788] input: KYE Systems Corp. Wireless Keyboard & Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input3
> [    5.285076] generic-usb 0003:0458:0063.0002: input: USB HID v1.10 Mouse [KYE Systems Corp. Wireless Keyboard & Mouse] on usb-0000:00:1d.0-2/input1
> [    5.285327] usbcore: registered new interface driver usbhid
> [    5.285439] usbhid: USB HID core driver
> [    5.285555] Netfilter messages via NETLINK v0.30.
> [    5.285683] nf_conntrack version 0.5.0 (7986 buckets, 31944 max)
> [    5.286067] ctnetlink v0.93: registering with nfnetlink.
> [    5.286695] IPv4 over IPv4 tunneling driver
> [    5.287239] GRE over IPv4 tunneling driver
> [    5.288187] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    5.288332] arp_tables: (C) 2002 David S. Miller
> [    5.288452] TCP bic registered
> [    5.288553] TCP cubic registered
> [    5.288652] TCP westwood registered
> [    5.288752] TCP highspeed registered
> [    5.288853] TCP hybla registered
> [    5.288952] TCP htcp registered
> [    5.289052] TCP vegas registered
> [    5.289151] TCP scalable registered
> [    5.289251] Initializing XFRM netlink socket
> [    5.289708] NET: Registered protocol family 10
> [    5.290476] lo: Disabled Privacy Extensions
> [    5.292172] tunl0: Disabled Privacy Extensions
> [    5.293397] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [    5.293596] IPv6 over IPv4 tunneling driver
> [    5.294326] sit0: Disabled Privacy Extensions
> [    5.295604] ip6tnl0: Disabled Privacy Extensions
> [    5.296269] NET: Registered protocol family 17
> [    5.296377] L2TP core driver, V2.0
> [    5.296477] L2TP IP encapsulation support (L2TPv3)
> [    5.296588] L2TP netlink interface
> [    5.296695] L2TP ethernet pseudowire support (L2TPv3)
> [    5.296802] Using IPI Shortcut mode
> [    5.297444] rtc_cmos 00:05: setting system clock to 2010-09-23 11:13:49 UTC (1285240429)
> [    5.302105] md: Waiting for all devices to be available before autodetect
> [    5.302212] md: If you don't use raid, use raid=noautodetect
> [    5.302536] md: Autodetecting RAID arrays.
> [    5.541746] md: Scanned 20 and added 20 devices.
> [    5.541856] md: autorun ...
> [    5.541957] md: considering sda12 ...
> [    5.542061] md:  adding sda12 ...
> [    5.542165] md: sda11 has different UUID to sda12
> [    5.542270] md: sda10 has different UUID to sda12
> [    5.542374] md: sda9 has different UUID to sda12
> [    5.542479] md: sda8 has different UUID to sda12
> [    5.542584] md: sda7 has different UUID to sda12
> [    5.542688] md: sda6 has different UUID to sda12
> [    5.542793] md: sda5 has different UUID to sda12
> [    5.542897] md: sda2 has different UUID to sda12
> [    5.543002] md: sda1 has different UUID to sda12
> [    5.543108] md:  adding sdb12 ...
> [    5.543210] md: sdb11 has different UUID to sda12
> [    5.543315] md: sdb10 has different UUID to sda12
> [    5.543420] md: sdb9 has different UUID to sda12
> [    5.543525] md: sdb8 has different UUID to sda12
> [    5.543630] md: sdb7 has different UUID to sda12
> [    5.543734] md: sdb6 has different UUID to sda12
> [    5.543839] md: sdb5 has different UUID to sda12
> [    5.543943] md: sdb2 has different UUID to sda12
> [    5.544048] md: sdb1 has different UUID to sda12
> [    5.544342] md: created md12
> [    5.544444] md: bind<sdb12>
> [    5.544553] md: bind<sda12>
> [    5.544661] md: running: <sda12><sdb12>
> [    5.544835] md/raid0:md12: looking at sda12
> [    5.544938] md/raid0:md12:   comparing sda12(120712192) with sda12(120712192)
> [    5.545066] md/raid0:md12:   END
> [    5.545166] md/raid0:md12:   ==> UNIQUE
> [    5.545266] md/raid0:md12: 1 zones
> [    5.545367] md/raid0:md12: looking at sdb12
> [    5.545468] md/raid0:md12:   comparing sdb12(37543680) with sda12(120712192)
> [    5.545596] md/raid0:md12:   NOT EQUAL
> [    5.545697] md/raid0:md12:   comparing sdb12(37543680) with sdb12(37543680)
> [    5.545825] md/raid0:md12:   END
> [    5.545924] md/raid0:md12:   ==> UNIQUE
> [    5.546025] md/raid0:md12: 2 zones
> [    5.546125] md/raid0:md12: FINAL 2 zones
> [    5.546228] md/raid0:md12: zone 1
> [    5.546329] md/raid0:md12: checking sda12 ... contained as device 0
> [    5.546455] md/raid0:md12:  (120712192) is smallest!.
> [    5.546558] md/raid0:md12: checking sdb12 ... nope.
> [    5.546682] md/raid0:md12: zone->nb_dev: 1, sectors: 83168512
> [    5.546786] md/raid0:md12: current zone start: 120712192
> [    5.546889] md/raid0:md12: done.
> [    5.546989] md/raid0:md12: md_size is 158255872 sectors.
> [    5.547093] ******* md12 configuration *********
> [    5.547195] zone0=[sda12/sdb12/]
> [    5.547357]         zone offset=0kb device offset=0kb size=37543680kb
> [    5.547462] zone1=[sda12/]
> [    5.547602]         zone offset=37543680kb device offset=18771840kb size=41584256kb
> [    5.547782] **********************************
> [    5.547783] 
> [    5.547988] md12: detected capacity change from 0 to 81027006464
> [    5.548154] md: considering sda11 ...
> [    5.548260] md:  adding sda11 ...
> [    5.548362] md: sda10 has different UUID to sda11
> [    5.548467] md: sda9 has different UUID to sda11
> [    5.548572] md: sda8 has different UUID to sda11
> [    5.548676] md: sda7 has different UUID to sda11
> [    5.548781] md: sda6 has different UUID to sda11
> [    5.548885] md: sda5 has different UUID to sda11
> [    5.548990] md: sda2 has different UUID to sda11
> [    5.549095] md: sda1 has different UUID to sda11
> [    5.549201] md:  adding sdb11 ...
> [    5.549303] md: sdb10 has different UUID to sda11
> [    5.549407] md: sdb9 has different UUID to sda11
> [    5.549512] md: sdb8 has different UUID to sda11
> [    5.549617] md: sdb7 has different UUID to sda11
> [    5.549721] md: sdb6 has different UUID to sda11
> [    5.549826] md: sdb5 has different UUID to sda11
> [    5.549931] md: sdb2 has different UUID to sda11
> [    5.550044] md: sdb1 has different UUID to sda11
> [    5.550333] md: created md11
> [    5.550434] md: bind<sdb11>
> [    5.550542] md: bind<sda11>
> [    5.550649] md: running: <sda11><sdb11>
> [    5.550917] md/raid1:md11: active with 2 out of 2 mirrors
> [    5.551047] md11: detected capacity change from 0 to 30005723136
> [    5.551211] md: considering sda10 ...
> [    5.551323] md:  adding sda10 ...
> [    5.551426] md: sda9 has different UUID to sda10
> [    5.551531] md: sda8 has different UUID to sda10
> [    5.551636] md: sda7 has different UUID to sda10
> [    5.551740] md: sda6 has different UUID to sda10
> [    5.551845] md: sda5 has different UUID to sda10
> [    5.551950] md: sda2 has different UUID to sda10
> [    5.552055] md: sda1 has different UUID to sda10
> [    5.552162] md:  adding sdb10 ...
> [    5.552264] md: sdb9 has different UUID to sda10
> [    5.552368] md: sdb8 has different UUID to sda10
> [    5.552473] md: sdb7 has different UUID to sda10
> [    5.552578] md: sdb6 has different UUID to sda10
> [    5.552682] md: sdb5 has different UUID to sda10
> [    5.552787] md: sdb2 has different UUID to sda10
> [    5.552892] md: sdb1 has different UUID to sda10
> [    5.553180] md: created md10
> [    5.553281] md: bind<sdb10>
> [    5.553391] md: bind<sda10>
> [    5.553498] md: running: <sda10><sdb10>
> [    5.553757] md/raid1:md10: active with 2 out of 2 mirrors
> [    5.553885] md10: detected capacity change from 0 to 400011689984
> [    5.554046] md: considering sda9 ...
> [    5.554158] md:  adding sda9 ...
> [    5.554260] md: sda8 has different UUID to sda9
> [    5.554364] md: sda7 has different UUID to sda9
> [    5.554469] md: sda6 has different UUID to sda9
> [    5.554574] md: sda5 has different UUID to sda9
> [    5.554678] md: sda2 has different UUID to sda9
> [    5.554782] md: sda1 has different UUID to sda9
> [    5.554888] md:  adding sdb9 ...
> [    5.554990] md: sdb8 has different UUID to sda9
> [    5.555094] md: sdb7 has different UUID to sda9
> [    5.555198] md: sdb6 has different UUID to sda9
> [    5.555303] md: sdb5 has different UUID to sda9
> [    5.555407] md: sdb2 has different UUID to sda9
> [    5.555512] md: sdb1 has different UUID to sda9
> [    5.555798] md: created md9
> [    5.555899] md: bind<sdb9>
> [    5.556006] md: bind<sda9>
> [    5.556113] md: running: <sda9><sdb9>
> [    5.556372] md/raid1:md9: active with 2 out of 2 mirrors
> [    5.556500] md9: detected capacity change from 0 to 20012007424
> [    5.556661] md: considering sda8 ...
> [    5.556773] md:  adding sda8 ...
> [    5.556875] md: sda7 has different UUID to sda8
> [    5.556980] md: sda6 has different UUID to sda8
> [    5.557085] md: sda5 has different UUID to sda8
> [    5.557189] md: sda2 has different UUID to sda8
> [    5.557294] md: sda1 has different UUID to sda8
> [    5.557400] md:  adding sdb8 ...
> [    5.557502] md: sdb7 has different UUID to sda8
> [    5.557607] md: sdb6 has different UUID to sda8
> [    5.557711] md: sdb5 has different UUID to sda8
> [    5.557816] md: sdb2 has different UUID to sda8
> [    5.557920] md: sdb1 has different UUID to sda8
> [    5.558207] md: created md8
> [    5.558307] md: bind<sdb8>
> [    5.562802] md: bind<sda8>
> [    5.562911] md: running: <sda8><sdb8>
> [    5.563169] md/raid1:md8: active with 2 out of 2 mirrors
> [    5.563297] md8: detected capacity change from 0 to 70005227520
> [    5.563458] md: considering sda7 ...
> [    5.563570] md:  adding sda7 ...
> [    5.563673] md: sda6 has different UUID to sda7
> [    5.563777] md: sda5 has different UUID to sda7
> [    5.563882] md: sda2 has different UUID to sda7
> [    5.563987] md: sda1 has different UUID to sda7
> [    5.564093] md:  adding sdb7 ...
> [    5.564196] md: sdb6 has different UUID to sda7
> [    5.564300] md: sdb5 has different UUID to sda7
> [    5.564404] md: sdb2 has different UUID to sda7
> [    5.564509] md: sdb1 has different UUID to sda7
> [    5.564797] md: created md7
> [    5.564897] md: bind<sdb7>
> [    5.565005] md: bind<sda7>
> [    5.565113] md: running: <sda7><sdb7>
> [    5.565371] md/raid1:md7: active with 2 out of 3 mirrors
> [    5.565499] md7: detected capacity change from 0 to 20012007424
> [    5.565659] md: considering sda6 ...
> [    5.565771] md:  adding sda6 ...
> [    5.565874] md: sda5 has different UUID to sda6
> [    5.565979] md: sda2 has different UUID to sda6
> [    5.566084] md: sda1 has different UUID to sda6
> [    5.566192] md:  adding sdb6 ...
> [    5.566294] md: sdb5 has different UUID to sda6
> [    5.566398] md: sdb2 has different UUID to sda6
> [    5.566502] md: sdb1 has different UUID to sda6
> [    5.566795] md: created md6
> [    5.566896] md: bind<sdb6>
> [    5.567004] md: bind<sda6>
> [    5.567111] md: running: <sda6><sdb6>
> [    5.567368] md/raid1:md6: active with 2 out of 3 mirrors
> [    5.567495] md6: detected capacity change from 0 to 20012007424
> [    5.567658] md: considering sda5 ...
> [    5.567770] md:  adding sda5 ...
> [    5.567874] md: sda2 has different UUID to sda5
> [    5.567979] md: sda1 has different UUID to sda5
> [    5.568086] md:  adding sdb5 ...
> [    5.568189] md: sdb2 has different UUID to sda5
> [    5.568294] md: sdb1 has different UUID to sda5
> [    5.568580] md: created md5
> [    5.568681] md: bind<sdb5>
> [    5.568789] md: bind<sda5>
> [    5.568896] md: running: <sda5><sdb5>
> [    5.569153] md/raid1:md5: active with 2 out of 3 mirrors
> [    5.569279] md5: detected capacity change from 0 to 16006250496
> [    5.569439] md: considering sda2 ...
> [    5.569552] md:  adding sda2 ...
> [    5.569655] md: sda1 has different UUID to sda2
> [    5.569761] md:  adding sdb2 ...
> [    5.569863] md: sdb1 has different UUID to sda2
> [    5.570155] md: created md2
> [    5.570255] md: bind<sdb2>
> [    5.570363] md: bind<sda2>
> [    5.570470] md: running: <sda2><sdb2>
> [    5.570729] md/raid1:md2: active with 2 out of 3 mirrors
> [    5.570858] md2: detected capacity change from 0 to 2056192000
> [    5.571020] md: considering sda1 ...
> [    5.571130] md:  adding sda1 ...
> [    5.571233] md:  adding sdb1 ...
> [    5.571519] md: created md1
> [    5.571620] md: bind<sdb1>
> [    5.571729] md: bind<sda1>
> [    5.571836] md: running: <sda1><sdb1>
> [    5.572095] md/raid1:md1: active with 2 out of 3 mirrors
> [    5.572222] md1: detected capacity change from 0 to 205520896
> [    5.572381] md: ... autorun DONE.
> [    5.572535] md5: detected capacity change from 0 to 16006250496
> [    5.591970]  md5: unknown partition table
> [    5.653619] XFS mounting filesystem md5
> [    5.709620] Ending clean XFS mount for filesystem: md5
> [    5.709663] VFS: Mounted root (xfs filesystem) readonly on device 9:5.
> [    5.709810] Freeing unused kernel memory: 496k freed
> [    5.710226] Write protecting the kernel text: 3752k
> [    5.710404] Write protecting the kernel read-only data: 1560k
> [    6.314170] udevd (1265): /proc/1265/oom_adj is deprecated, please use /proc/1265/oom_score_adj instead.
> [    7.609567] md2: detected capacity change from 0 to 2056192000
> [    7.619164]  md2: unknown partition table
> [    7.619518] Adding 2007996k swap on /dev/md2.  Priority:-1 extents:1 across:2007996k 
> [   11.238506] md1: detected capacity change from 0 to 205520896
> [   11.244792]  md1: unknown partition table
> [   11.244911] XFS: unknown mount option [ralatime].
> [   11.245708] md6: detected capacity change from 0 to 20012007424
> [   11.253001]  md6: unknown partition table
> [   11.305328] XFS mounting filesystem md6
> [   11.371031] Ending clean XFS mount for filesystem: md6
> [   11.387673] md7: detected capacity change from 0 to 20012007424
> [   11.406398]  md7: unknown partition table
> [   11.461216] XFS mounting filesystem md7
> [   11.513732] Ending clean XFS mount for filesystem: md7
> [   11.514123] md10: detected capacity change from 0 to 400011689984
> [   11.530706]  md10: unknown partition table
> [   11.663431] XFS mounting filesystem md10
> [   11.797698] Ending clean XFS mount for filesystem: md10
> [   11.844039] md8: detected capacity change from 0 to 70005227520
> [   11.854645]  md8: unknown partition table
> [   11.927253] XFS mounting filesystem md8
> [   11.968924] Ending clean XFS mount for filesystem: md8
> [   11.982269] md9: detected capacity change from 0 to 20012007424
> [   11.995347]  md9: unknown partition table
> [   12.104492] XFS mounting filesystem md9
> [   12.167726] Ending clean XFS mount for filesystem: md9
> [   12.238157] md11: detected capacity change from 0 to 30005723136
> [   12.251118]  md11: unknown partition table
> [   12.323829] XFS mounting filesystem md11
> [   12.598011] Ending clean XFS mount for filesystem: md11
> [   12.617421] md12: detected capacity change from 0 to 81027006464
> [   12.634035]  md12: unknown partition table
> [   12.686758] XFS mounting filesystem md12
> [   12.854418] Ending clean XFS mount for filesystem: md12
> [   13.677683] eth2: link up, 100Mbps, full-duplex, lpa 0x45E1
> [   13.762583] eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
> [   13.772281] tg3 0000:04:00.0: irq 40 for MSI/MSI-X
> [   13.803901] ADDRCONF(NETDEV_UP): eth1: link is not ready
> [   13.965739] sixxs_t: Disabled Privacy Extensions
> [   16.879730] tg3 0000:04:00.0: eth1: Link is up at 1000 Mbps, full duplex
> [   16.879735] tg3 0000:04:00.0: eth1: Flow control is on for TX and on for RX
> [   16.879791] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> [   17.534899] tun0: Disabled Privacy Extensions
> [  344.210233] XFS: unknown mount option [ralatime].
> [  370.040177] XFS: unknown mount option [relatime].
> [  412.870189] Enabling EXPERIMENTAL delayed logging feature - use at your own risk.
> [  413.009603] XFS mounting filesystem md1
> [  413.159227] Ending clean XFS mount for filesystem: md1
> [ 3786.389501] IN=eth0 OUT= MAC=00:0e:2e:5c:27:ef:00:0e:2e:5c:27:b2:08:00 SRC=112.90.146.2 DST=192.168.1.2 LEN=48 TOS=0x00 PREC=0x00 TTL=115 ID=14727 PROTO=TCP SPT=40708 DPT=22 WINDOW=65535 RES=0x00 SYN URGP=0 
> [ 3789.079725] IN=eth0 OUT= MAC=00:0e:2e:5c:27:ef:00:0e:2e:5c:27:b2:08:00 SRC=112.90.146.2 DST=192.168.1.2 LEN=48 TOS=0x00 PREC=0x00 TTL=115 ID=1948 PROTO=TCP SPT=1116 DPT=22 WINDOW=65535 RES=0x00 SYN URGP=0 
> [ 3791.679944] IN=eth0 OUT= MAC=00:0e:2e:5c:27:ef:00:0e:2e:5c:27:b2:08:00 SRC=112.90.146.2 DST=192.168.1.2 LEN=48 TOS=0x00 PREC=0x00 TTL=115 ID=4706 PROTO=TCP SPT=1117 DPT=22 WINDOW=65535 RES=0x00 SYN URGP=0 
> [ 3794.280165] IN=eth0 OUT= MAC=00:0e:2e:5c:27:ef:00:0e:2e:5c:27:b2:08:00 SRC=112.90.146.2 DST=192.168.1.2 LEN=48 TOS=0x00 PREC=0x00 TTL=115 ID=18833 PROTO=TCP SPT=1118 DPT=22 WINDOW=65535 RES=0x00 SYN URGP=0 
> [ 3796.880371] IN=eth0 OUT= MAC=00:0e
> [ 3797.260001] INFO: rcu_sched_state detected stall on CPU 0 (t=1000 jiffies)
> [ 3797.260001] sending NMI to all CPUs:
> [ 3807.480225] :2e:5c:27:ef:00:0e:2e:5c:27:b2:08:00 SRC=112.90.146.2 DST=192.168.1.2 LEN=48 TOS=0x00 PREC=0x00 TTL=115 ID=2624 PROTO=TCP SPT=1119 DPT=22 WINDOW=65535 RES=0x00 SYN URGP=0 
> [ 3809.680406] IN=eth0 OUT= MAC=00:0e:2e:5c:27:ef:00:0e:2e:5c:27:b2:08:00 SRC=112.90.146.2 DST=192.168.1.2 LEN=48 TOS=0x00 PREC=0x00 TTL=115 ID=26429 PROTO=TCP SPT=1120 DPT=22 WINDOW=65535 RES=0x00 SYN URGP=0 
> [ 3812.280621] IN=eth0 OUT= MAC=00:0e:2e:5c:27:ef:00:0e:2e:5c:27:b2:08:00 SRC=112.90.146.2 DST=192.168.1.2 LEN=48 TOS=0x00 PREC=0x00 TTL=115 ID=63728 PROTO=TCP SPT=1121 DPT=22 WINDOW=65535 RES=0x00 SYN URGP=0 
> [ 3814.880839] IN=eth0 OUT= MAC=00:0e:2e:5c:27:ef:00:0e:2e:5c:27:b2:08:00 SRC=112.90.146.2 DST=192.168.1.2 LEN=48 TOS=0x00 PREC=0x00 TTL=115 ID=6929 PROTO=TCP SPT=1122 DPT=22 WINDOW=65535 RES=0x00 SYN URGP=0 

> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.36-rc5
> # Thu Sep 23 09:31:38 2010
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> # CONFIG_X86_64 is not set
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf32-i386"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> # CONFIG_NEED_DMA_MAP_STATE is not set
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> # CONFIG_RWSEM_GENERIC_SPINLOCK is not set
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> # CONFIG_GENERIC_TIME_VSYSCALL is not set
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_DEFAULT_IDLE=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> # CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> # CONFIG_ZONE_DMA32 is not set
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_HAVE_EARLY_RES=y
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_USE_GENERIC_SMP_HELPERS=y
> CONFIG_X86_32_SMP=y
> CONFIG_X86_HT=y
> CONFIG_X86_TRAMPOLINE=y
> CONFIG_X86_32_LAZY_GS=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
> CONFIG_KTIME_SCALAR=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_CONSTRUCTORS=y
> 
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_LOCK_KERNEL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_LOCALVERSION="-FS"
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_LZO=y
> # CONFIG_KERNEL_GZIP is not set
> # CONFIG_KERNEL_BZIP2 is not set
> CONFIG_KERNEL_LZMA=y
> # CONFIG_KERNEL_LZO is not set
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> CONFIG_BSD_PROCESS_ACCT=y
> CONFIG_BSD_PROCESS_ACCT_V3=y
> # CONFIG_TASKSTATS is not set
> # CONFIG_AUDIT is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_RCU=y
> # CONFIG_RCU_TRACE is not set
> CONFIG_RCU_FANOUT=32
> # CONFIG_RCU_FANOUT_EXACT is not set
> # CONFIG_RCU_FAST_NO_HZ is not set
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=18
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> # CONFIG_CGROUPS is not set
> # CONFIG_SYSFS_DEPRECATED_V2 is not set
> # CONFIG_RELAY is not set
> CONFIG_NAMESPACES=y
> # CONFIG_UTS_NS is not set
> # CONFIG_IPC_NS is not set
> # CONFIG_USER_NS is not set
> # CONFIG_PID_NS is not set
> # CONFIG_NET_NS is not set
> # CONFIG_BLK_DEV_INITRD is not set
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> # CONFIG_EMBEDDED is not set
> CONFIG_UID16=y
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_KALLSYMS=y
> # CONFIG_KALLSYMS_ALL is not set
> # CONFIG_KALLSYMS_EXTRA_PASS is not set
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_PERF_COUNTERS is not set
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_PCI_QUIRKS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_COMPAT_BRK is not set
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_PROFILING is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> 
> #
> # GCOV-based kernel profiling
> #
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> # CONFIG_MODULES is not set
> CONFIG_BLOCK=y
> CONFIG_LBDAF=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_INTEGRITY=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> # CONFIG_IOSCHED_DEADLINE is not set
> # CONFIG_IOSCHED_CFQ is not set
> CONFIG_DEFAULT_NOOP=y
> CONFIG_DEFAULT_IOSCHED="noop"
> # CONFIG_INLINE_SPIN_TRYLOCK is not set
> # CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK is not set
> # CONFIG_INLINE_SPIN_LOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
> CONFIG_INLINE_SPIN_UNLOCK=y
> # CONFIG_INLINE_SPIN_UNLOCK_BH is not set
> CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
> # CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_READ_TRYLOCK is not set
> # CONFIG_INLINE_READ_LOCK is not set
> # CONFIG_INLINE_READ_LOCK_BH is not set
> # CONFIG_INLINE_READ_LOCK_IRQ is not set
> # CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
> CONFIG_INLINE_READ_UNLOCK=y
> # CONFIG_INLINE_READ_UNLOCK_BH is not set
> CONFIG_INLINE_READ_UNLOCK_IRQ=y
> # CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_WRITE_TRYLOCK is not set
> # CONFIG_INLINE_WRITE_LOCK is not set
> # CONFIG_INLINE_WRITE_LOCK_BH is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
> CONFIG_INLINE_WRITE_UNLOCK=y
> # CONFIG_INLINE_WRITE_UNLOCK_BH is not set
> CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
> # CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
> CONFIG_MUTEX_SPIN_ON_OWNER=y
> # CONFIG_FREEZER is not set
> 
> #
> # Processor type and features
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_SMP=y
> # CONFIG_SPARSE_IRQ is not set
> # CONFIG_X86_MPPARSE is not set
> # CONFIG_X86_BIGSMP is not set
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> CONFIG_SCHED_OMIT_FRAME_POINTER=y
> # CONFIG_PARAVIRT_GUEST is not set
> # CONFIG_NO_BOOTMEM is not set
> # CONFIG_MEMTEST is not set
> # CONFIG_M386 is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> CONFIG_MPENTIUM4=y
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> # CONFIG_X86_GENERIC is not set
> CONFIG_X86_CPU=y
> CONFIG_X86_INTERNODE_CACHE_SHIFT=7
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=7
> CONFIG_X86_XADD=y
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INVLPG=y
> CONFIG_X86_BSWAP=y
> CONFIG_X86_POPAD_OK=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=5
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_CYRIX_32=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_CPU_SUP_TRANSMETA_32=y
> CONFIG_CPU_SUP_UMC_32=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> # CONFIG_IOMMU_HELPER is not set
> # CONFIG_IOMMU_API is not set
> CONFIG_NR_CPUS=4
> # CONFIG_SCHED_SMT is not set
> CONFIG_SCHED_MC=y
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> CONFIG_X86_MCE_AMD=y
> # CONFIG_X86_ANCIENT_MCE is not set
> CONFIG_X86_MCE_THRESHOLD=y
> # CONFIG_X86_MCE_INJECT is not set
> CONFIG_X86_THERMAL_VECTOR=y
> CONFIG_VM86=y
> # CONFIG_TOSHIBA is not set
> # CONFIG_I8K is not set
> # CONFIG_X86_REBOOTFIXUPS is not set
> # CONFIG_MICROCODE is not set
> CONFIG_X86_MSR=y
> CONFIG_X86_CPUID=y
> CONFIG_NOHIGHMEM=y
> # CONFIG_HIGHMEM4G is not set
> # CONFIG_HIGHMEM64G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_X86_PAE=y
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_NEED_NODE_MEMMAP_SIZE=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_SELECT_MEMORY_MODEL=y
> # CONFIG_FLATMEM_MANUAL is not set
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_X86_RESERVE_LOW_64K=y
> CONFIG_MATH_EMULATION=y
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> # CONFIG_CC_STACKPROTECTOR is not set
> CONFIG_HZ_100=y
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=100
> CONFIG_SCHED_HRTICK=y
> # CONFIG_KEXEC is not set
> CONFIG_PHYSICAL_START=0x1000000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x100000
> # CONFIG_HOTPLUG_CPU is not set
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> 
> #
> # Power management and ACPI options
> #
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> # CONFIG_SUSPEND is not set
> # CONFIG_HIBERNATION is not set
> # CONFIG_PM_RUNTIME is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_PROCFS=y
> CONFIG_ACPI_PROCFS_POWER=y
> # CONFIG_ACPI_POWER_METER is not set
> CONFIG_ACPI_SYSFS_POWER=y
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_PROC_EVENT=y
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_FAN=y
> CONFIG_ACPI_DOCK=y
> CONFIG_ACPI_PROCESSOR=y
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> CONFIG_ACPI_DEBUG=y
> # CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
> CONFIG_ACPI_PCI_SLOT=y
> CONFIG_X86_PM_TIMER=y
> # CONFIG_ACPI_CONTAINER is not set
> CONFIG_ACPI_SBS=y
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_APEI is not set
> # CONFIG_SFI is not set
> 
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_INTEL_IDLE is not set
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_DOMAINS=y
> # CONFIG_PCI_CNB20LE_QUIRK is not set
> # CONFIG_DMAR is not set
> CONFIG_PCIEPORTBUS=y
> CONFIG_PCIEAER=y
> # CONFIG_PCIE_ECRC is not set
> # CONFIG_PCIEAER_INJECT is not set
> CONFIG_PCIEASPM=y
> # CONFIG_PCIEASPM_DEBUG is not set
> CONFIG_ARCH_SUPPORTS_MSI=y
> CONFIG_PCI_MSI=y
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_STUB is not set
> CONFIG_HT_IRQ=y
> # CONFIG_PCI_IOV is not set
> CONFIG_PCI_IOAPIC=y
> CONFIG_ISA_DMA_API=y
> CONFIG_ISA=y
> CONFIG_EISA=y
> # CONFIG_EISA_VLB_PRIMING is not set
> CONFIG_EISA_PCI_EISA=y
> CONFIG_EISA_VIRTUAL_ROOT=y
> CONFIG_EISA_NAMES=y
> # CONFIG_MCA is not set
> # CONFIG_SCx200 is not set
> # CONFIG_OLPC is not set
> CONFIG_K8_NB=y
> # CONFIG_PCCARD is not set
> # CONFIG_HOTPLUG_PCI is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
> CONFIG_HAVE_AOUT=y
> CONFIG_BINFMT_AOUT=y
> CONFIG_BINFMT_MISC=y
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_UNIX=y
> CONFIG_XFRM=y
> CONFIG_XFRM_USER=y
> # CONFIG_XFRM_SUB_POLICY is not set
> # CONFIG_XFRM_MIGRATE is not set
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_XFRM_IPCOMP=y
> # CONFIG_NET_KEY is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_ASK_IP_FIB_HASH=y
> # CONFIG_IP_FIB_TRIE is not set
> CONFIG_IP_FIB_HASH=y
> CONFIG_IP_MULTIPLE_TABLES=y
> CONFIG_IP_ROUTE_MULTIPATH=y
> CONFIG_IP_ROUTE_VERBOSE=y
> # CONFIG_IP_PNP is not set
> CONFIG_NET_IPIP=y
> CONFIG_NET_IPGRE=y
> CONFIG_NET_IPGRE_BROADCAST=y
> CONFIG_IP_MROUTE=y
> # CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
> CONFIG_IP_PIMSM_V1=y
> CONFIG_IP_PIMSM_V2=y
> # CONFIG_ARPD is not set
> CONFIG_SYN_COOKIES=y
> CONFIG_INET_AH=y
> CONFIG_INET_ESP=y
> CONFIG_INET_IPCOMP=y
> CONFIG_INET_XFRM_TUNNEL=y
> CONFIG_INET_TUNNEL=y
> CONFIG_INET_XFRM_MODE_TRANSPORT=y
> CONFIG_INET_XFRM_MODE_TUNNEL=y
> CONFIG_INET_XFRM_MODE_BEET=y
> CONFIG_INET_LRO=y
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> CONFIG_TCP_CONG_ADVANCED=y
> CONFIG_TCP_CONG_BIC=y
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_TCP_CONG_WESTWOOD=y
> CONFIG_TCP_CONG_HTCP=y
> CONFIG_TCP_CONG_HSTCP=y
> CONFIG_TCP_CONG_HYBLA=y
> CONFIG_TCP_CONG_VEGAS=y
> CONFIG_TCP_CONG_SCALABLE=y
> # CONFIG_TCP_CONG_LP is not set
> # CONFIG_TCP_CONG_VENO is not set
> # CONFIG_TCP_CONG_YEAH is not set
> # CONFIG_TCP_CONG_ILLINOIS is not set
> CONFIG_DEFAULT_BIC=y
> # CONFIG_DEFAULT_CUBIC is not set
> # CONFIG_DEFAULT_HTCP is not set
> # CONFIG_DEFAULT_HYBLA is not set
> # CONFIG_DEFAULT_VEGAS is not set
> # CONFIG_DEFAULT_WESTWOOD is not set
> # CONFIG_DEFAULT_RENO is not set
> CONFIG_DEFAULT_TCP_CONG="bic"
> CONFIG_TCP_MD5SIG=y
> CONFIG_IPV6=y
> CONFIG_IPV6_PRIVACY=y
> CONFIG_IPV6_ROUTER_PREF=y
> CONFIG_IPV6_ROUTE_INFO=y
> # CONFIG_IPV6_OPTIMISTIC_DAD is not set
> CONFIG_INET6_AH=y
> CONFIG_INET6_ESP=y
> CONFIG_INET6_IPCOMP=y
> # CONFIG_IPV6_MIP6 is not set
> CONFIG_INET6_XFRM_TUNNEL=y
> CONFIG_INET6_TUNNEL=y
> CONFIG_INET6_XFRM_MODE_TRANSPORT=y
> CONFIG_INET6_XFRM_MODE_TUNNEL=y
> CONFIG_INET6_XFRM_MODE_BEET=y
> CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
> CONFIG_IPV6_SIT=y
> # CONFIG_IPV6_SIT_6RD is not set
> CONFIG_IPV6_NDISC_NODETYPE=y
> CONFIG_IPV6_TUNNEL=y
> # CONFIG_IPV6_MULTIPLE_TABLES is not set
> # CONFIG_IPV6_MROUTE is not set
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_NETFILTER_ADVANCED=y
> 
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=y
> CONFIG_NETFILTER_NETLINK_QUEUE=y
> CONFIG_NETFILTER_NETLINK_LOG=y
> CONFIG_NF_CONNTRACK=y
> CONFIG_NF_CONNTRACK_MARK=y
> # CONFIG_NF_CONNTRACK_EVENTS is not set
> # CONFIG_NF_CT_PROTO_DCCP is not set
> CONFIG_NF_CT_PROTO_GRE=y
> CONFIG_NF_CT_PROTO_SCTP=y
> # CONFIG_NF_CT_PROTO_UDPLITE is not set
> CONFIG_NF_CONNTRACK_AMANDA=y
> CONFIG_NF_CONNTRACK_FTP=y
> CONFIG_NF_CONNTRACK_H323=y
> CONFIG_NF_CONNTRACK_IRC=y
> # CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
> CONFIG_NF_CONNTRACK_PPTP=y
> CONFIG_NF_CONNTRACK_SANE=y
> CONFIG_NF_CONNTRACK_SIP=y
> CONFIG_NF_CONNTRACK_TFTP=y
> CONFIG_NF_CT_NETLINK=y
> # CONFIG_NETFILTER_TPROXY is not set
> CONFIG_NETFILTER_XTABLES=y
> 
> #
> # Xtables combined modules
> #
> CONFIG_NETFILTER_XT_MARK=y
> CONFIG_NETFILTER_XT_CONNMARK=y
> 
> #
> # Xtables targets
> #
> # CONFIG_NETFILTER_XT_TARGET_CHECKSUM is not set
> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
> CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
> # CONFIG_NETFILTER_XT_TARGET_CT is not set
> CONFIG_NETFILTER_XT_TARGET_DSCP=y
> CONFIG_NETFILTER_XT_TARGET_HL=y
> # CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
> CONFIG_NETFILTER_XT_TARGET_MARK=y
> CONFIG_NETFILTER_XT_TARGET_NFLOG=y
> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
> CONFIG_NETFILTER_XT_TARGET_NOTRACK=y
> CONFIG_NETFILTER_XT_TARGET_RATEEST=y
> # CONFIG_NETFILTER_XT_TARGET_TEE is not set
> CONFIG_NETFILTER_XT_TARGET_TRACE=y
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
> CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=y
> 
> #
> # Xtables matches
> #
> # CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
> CONFIG_NETFILTER_XT_MATCH_COMMENT=y
> CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
> CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
> CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
> # CONFIG_NETFILTER_XT_MATCH_CPU is not set
> CONFIG_NETFILTER_XT_MATCH_DCCP=y
> CONFIG_NETFILTER_XT_MATCH_DSCP=y
> CONFIG_NETFILTER_XT_MATCH_ESP=y
> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
> CONFIG_NETFILTER_XT_MATCH_HELPER=y
> CONFIG_NETFILTER_XT_MATCH_HL=y
> CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
> CONFIG_NETFILTER_XT_MATCH_LENGTH=y
> CONFIG_NETFILTER_XT_MATCH_LIMIT=y
> CONFIG_NETFILTER_XT_MATCH_MAC=y
> CONFIG_NETFILTER_XT_MATCH_MARK=y
> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
> # CONFIG_NETFILTER_XT_MATCH_OSF is not set
> CONFIG_NETFILTER_XT_MATCH_OWNER=y
> CONFIG_NETFILTER_XT_MATCH_POLICY=y
> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
> CONFIG_NETFILTER_XT_MATCH_QUOTA=y
> CONFIG_NETFILTER_XT_MATCH_RATEEST=y
> CONFIG_NETFILTER_XT_MATCH_REALM=y
> # CONFIG_NETFILTER_XT_MATCH_RECENT is not set
> CONFIG_NETFILTER_XT_MATCH_SCTP=y
> CONFIG_NETFILTER_XT_MATCH_STATE=y
> CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
> CONFIG_NETFILTER_XT_MATCH_STRING=y
> CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
> # CONFIG_NETFILTER_XT_MATCH_TIME is not set
> CONFIG_NETFILTER_XT_MATCH_U32=y
> # CONFIG_IP_VS is not set
> 
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV4=y
> CONFIG_NF_CONNTRACK_IPV4=y
> CONFIG_NF_CONNTRACK_PROC_COMPAT=y
> # CONFIG_IP_NF_QUEUE is not set
> CONFIG_IP_NF_IPTABLES=y
> CONFIG_IP_NF_MATCH_ADDRTYPE=y
> CONFIG_IP_NF_MATCH_AH=y
> CONFIG_IP_NF_MATCH_ECN=y
> CONFIG_IP_NF_MATCH_TTL=y
> CONFIG_IP_NF_FILTER=y
> CONFIG_IP_NF_TARGET_REJECT=y
> CONFIG_IP_NF_TARGET_LOG=y
> # CONFIG_IP_NF_TARGET_ULOG is not set
> CONFIG_NF_NAT=y
> CONFIG_NF_NAT_NEEDED=y
> # CONFIG_IP_NF_TARGET_MASQUERADE is not set
> CONFIG_IP_NF_TARGET_NETMAP=y
> CONFIG_IP_NF_TARGET_REDIRECT=y
> CONFIG_NF_NAT_SNMP_BASIC=y
> CONFIG_NF_NAT_PROTO_GRE=y
> CONFIG_NF_NAT_PROTO_SCTP=y
> CONFIG_NF_NAT_FTP=y
> CONFIG_NF_NAT_IRC=y
> CONFIG_NF_NAT_TFTP=y
> CONFIG_NF_NAT_AMANDA=y
> CONFIG_NF_NAT_PPTP=y
> CONFIG_NF_NAT_H323=y
> CONFIG_NF_NAT_SIP=y
> CONFIG_IP_NF_MANGLE=y
> # CONFIG_IP_NF_TARGET_CLUSTERIP is not set
> CONFIG_IP_NF_TARGET_ECN=y
> CONFIG_IP_NF_TARGET_TTL=y
> CONFIG_IP_NF_RAW=y
> CONFIG_IP_NF_ARPTABLES=y
> CONFIG_IP_NF_ARPFILTER=y
> CONFIG_IP_NF_ARP_MANGLE=y
> 
> #
> # IPv6: Netfilter Configuration
> #
> CONFIG_NF_CONNTRACK_IPV6=y
> # CONFIG_IP6_NF_QUEUE is not set
> CONFIG_IP6_NF_IPTABLES=y
> CONFIG_IP6_NF_MATCH_AH=y
> CONFIG_IP6_NF_MATCH_EUI64=y
> CONFIG_IP6_NF_MATCH_FRAG=y
> CONFIG_IP6_NF_MATCH_OPTS=y
> CONFIG_IP6_NF_MATCH_HL=y
> CONFIG_IP6_NF_MATCH_IPV6HEADER=y
> CONFIG_IP6_NF_MATCH_MH=y
> CONFIG_IP6_NF_MATCH_RT=y
> CONFIG_IP6_NF_TARGET_HL=y
> CONFIG_IP6_NF_TARGET_LOG=y
> CONFIG_IP6_NF_FILTER=y
> CONFIG_IP6_NF_TARGET_REJECT=y
> CONFIG_IP6_NF_MANGLE=y
> CONFIG_IP6_NF_RAW=y
> # CONFIG_IP_DCCP is not set
> # CONFIG_IP_SCTP is not set
> # CONFIG_RDS is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> CONFIG_L2TP=y
> CONFIG_L2TP_V3=y
> CONFIG_L2TP_IP=y
> CONFIG_L2TP_ETH=y
> # CONFIG_BRIDGE is not set
> # CONFIG_NET_DSA is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
> # CONFIG_PHONET is not set
> # CONFIG_IEEE802154 is not set
> # CONFIG_NET_SCHED is not set
> CONFIG_NET_CLS_ROUTE=y
> # CONFIG_DCB is not set
> CONFIG_RPS=y
> 
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> # CONFIG_AF_RXRPC is not set
> CONFIG_FIB_RULES=y
> # CONFIG_WIRELESS is not set
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> # CONFIG_DEVTMPFS is not set
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
> # CONFIG_PARPORT is not set
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
> 
> #
> # Protocols
> #
> # CONFIG_ISAPNP is not set
> # CONFIG_PNPBIOS is not set
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_BLK_DEV_XD is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> 
> #
> # DRBD disabled because PROC_FS, INET or CONNECTOR not selected
> #
> CONFIG_BLK_DEV_NBD=y
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_UB is not set
> # CONFIG_BLK_DEV_RAM is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_BLK_DEV_HD is not set
> # CONFIG_MISC_DEVICES is not set
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_TGT is not set
> # CONFIG_SCSI_NETLINK is not set
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> # CONFIG_BLK_DEV_SR is not set
> CONFIG_CHR_DEV_SG=y
> # CONFIG_CHR_DEV_SCH is not set
> # CONFIG_SCSI_MULTI_LUN is not set
> # CONFIG_SCSI_CONSTANTS is not set
> # CONFIG_SCSI_LOGGING is not set
> # CONFIG_SCSI_SCAN_ASYNC is not set
> 
> #
> # SCSI Transports
> #
> # CONFIG_SCSI_SPI_ATTRS is not set
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> # CONFIG_SCSI_SAS_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> # CONFIG_SCSI_LOWLEVEL is not set
> # CONFIG_SCSI_DH is not set
> # CONFIG_SCSI_OSD_INITIATOR is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_ATA_ACPI=y
> CONFIG_SATA_PMP=y
> 
> #
> # Controllers with non-SFF native interface
> #
> CONFIG_SATA_AHCI=y
> # CONFIG_SATA_AHCI_PLATFORM is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_SATA_SIL24 is not set
> CONFIG_ATA_SFF=y
> 
> #
> # SFF controllers with custom DMA interface
> #
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_SX4 is not set
> CONFIG_ATA_BMDMA=y
> 
> #
> # SATA SFF controllers with BMDMA
> #
> CONFIG_ATA_PIIX=y
> # CONFIG_SATA_MV is not set
> # CONFIG_SATA_NV is not set
> # CONFIG_SATA_PROMISE is not set
> # CONFIG_SATA_SIL is not set
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_SVW is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
> 
> #
> # PATA SFF controllers with BMDMA
> #
> # CONFIG_PATA_ALI is not set
> CONFIG_PATA_AMD=y
> # CONFIG_PATA_ARTOP is not set
> CONFIG_PATA_ATIIXP=y
> # CONFIG_PATA_ATP867X is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CS5535 is not set
> # CONFIG_PATA_CS5536 is not set
> # CONFIG_PATA_CYPRESS is not set
> # CONFIG_PATA_EFAR is not set
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT8213 is not set
> # CONFIG_PATA_IT821X is not set
> # CONFIG_PATA_JMICRON is not set
> # CONFIG_PATA_MARVELL is not set
> # CONFIG_PATA_NETCELL is not set
> # CONFIG_PATA_NINJA32 is not set
> # CONFIG_PATA_NS87415 is not set
> CONFIG_PATA_OLDPIIX=y
> # CONFIG_PATA_OPTIDMA is not set
> # CONFIG_PATA_PDC2027X is not set
> # CONFIG_PATA_PDC_OLD is not set
> # CONFIG_PATA_RADISYS is not set
> # CONFIG_PATA_RDC is not set
> # CONFIG_PATA_SC1200 is not set
> # CONFIG_PATA_SCH is not set
> # CONFIG_PATA_SERVERWORKS is not set
> # CONFIG_PATA_SIL680 is not set
> # CONFIG_PATA_SIS is not set
> # CONFIG_PATA_TOSHIBA is not set
> # CONFIG_PATA_TRIFLEX is not set
> CONFIG_PATA_VIA=y
> # CONFIG_PATA_WINBOND is not set
> 
> #
> # PIO-only SFF controllers
> #
> # CONFIG_PATA_CMD640_PCI is not set
> CONFIG_PATA_MPIIX=y
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_OPTI is not set
> # CONFIG_PATA_QDI is not set
> # CONFIG_PATA_RZ1000 is not set
> # CONFIG_PATA_WINBOND_VLB is not set
> 
> #
> # Generic fallback / legacy drivers
> #
> # CONFIG_PATA_ACPI is not set
> CONFIG_ATA_GENERIC=y
> # CONFIG_PATA_LEGACY is not set
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=y
> CONFIG_MD_AUTODETECT=y
> CONFIG_MD_LINEAR=y
> CONFIG_MD_RAID0=y
> CONFIG_MD_RAID1=y
> # CONFIG_MD_RAID10 is not set
> CONFIG_MD_RAID456=y
> # CONFIG_MULTICORE_RAID456 is not set
> # CONFIG_MD_MULTIPATH is not set
> # CONFIG_MD_FAULTY is not set
> # CONFIG_BLK_DEV_DM is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> 
> #
> # You can enable one or both FireWire driver stacks.
> #
> 
> #
> # The newer stack is recommended.
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_IEEE1394 is not set
> # CONFIG_FIREWIRE_NOSY is not set
> CONFIG_I2O=y
> CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
> CONFIG_I2O_EXT_ADAPTEC=y
> CONFIG_I2O_CONFIG=y
> CONFIG_I2O_CONFIG_OLD_IOCTL=y
> CONFIG_I2O_BUS=y
> CONFIG_I2O_BLOCK=y
> CONFIG_I2O_SCSI=y
> CONFIG_I2O_PROC=y
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> # CONFIG_DUMMY is not set
> # CONFIG_BONDING is not set
> # CONFIG_MACVLAN is not set
> # CONFIG_EQUALIZER is not set
> CONFIG_TUN=y
> CONFIG_VETH=y
> # CONFIG_NET_SB1000 is not set
> # CONFIG_ARCNET is not set
> CONFIG_PHYLIB=y
> 
> #
> # MII PHY device drivers
> #
> # CONFIG_MARVELL_PHY is not set
> # CONFIG_DAVICOM_PHY is not set
> # CONFIG_QSEMI_PHY is not set
> CONFIG_LXT_PHY=y
> # CONFIG_CICADA_PHY is not set
> # CONFIG_VITESSE_PHY is not set
> # CONFIG_SMSC_PHY is not set
> CONFIG_BROADCOM_PHY=y
> # CONFIG_ICPLUS_PHY is not set
> CONFIG_REALTEK_PHY=y
> # CONFIG_NATIONAL_PHY is not set
> # CONFIG_STE10XP is not set
> # CONFIG_LSI_ET1011C_PHY is not set
> # CONFIG_MICREL_PHY is not set
> # CONFIG_FIXED_PHY is not set
> # CONFIG_MDIO_BITBANG is not set
> CONFIG_NET_ETHERNET=y
> CONFIG_MII=y
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> # CONFIG_NET_VENDOR_3COM is not set
> # CONFIG_LANCE is not set
> # CONFIG_NET_VENDOR_SMC is not set
> # CONFIG_ETHOC is not set
> # CONFIG_NET_VENDOR_RACAL is not set
> # CONFIG_DNET is not set
> # CONFIG_NET_TULIP is not set
> # CONFIG_AT1700 is not set
> # CONFIG_DEPCA is not set
> # CONFIG_HP100 is not set
> # CONFIG_NET_ISA is not set
> # CONFIG_IBM_NEW_EMAC_ZMII is not set
> # CONFIG_IBM_NEW_EMAC_RGMII is not set
> # CONFIG_IBM_NEW_EMAC_TAH is not set
> # CONFIG_IBM_NEW_EMAC_EMAC4 is not set
> # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
> # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
> # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
> CONFIG_NET_PCI=y
> # CONFIG_PCNET32 is not set
> # CONFIG_AMD8111_ETH is not set
> # CONFIG_ADAPTEC_STARFIRE is not set
> # CONFIG_AC3200 is not set
> # CONFIG_KSZ884X_PCI is not set
> # CONFIG_APRICOT is not set
> # CONFIG_B44 is not set
> # CONFIG_FORCEDETH is not set
> # CONFIG_CS89x0 is not set
> # CONFIG_E100 is not set
> # CONFIG_LNE390 is not set
> # CONFIG_FEALNX is not set
> # CONFIG_NATSEMI is not set
> # CONFIG_NE2K_PCI is not set
> # CONFIG_NE3210 is not set
> # CONFIG_ES3210 is not set
> # CONFIG_8139CP is not set
> CONFIG_8139TOO=y
> # CONFIG_8139TOO_PIO is not set
> # CONFIG_8139TOO_TUNE_TWISTER is not set
> # CONFIG_8139TOO_8129 is not set
> # CONFIG_8139_OLD_RX_RESET is not set
> # CONFIG_R6040 is not set
> # CONFIG_SIS900 is not set
> # CONFIG_EPIC100 is not set
> # CONFIG_SMSC9420 is not set
> # CONFIG_SUNDANCE is not set
> # CONFIG_TLAN is not set
> # CONFIG_KS8842 is not set
> # CONFIG_KS8851_MLL is not set
> # CONFIG_VIA_RHINE is not set
> # CONFIG_SC92031 is not set
> # CONFIG_ATL2 is not set
> CONFIG_NETDEV_1000=y
> # CONFIG_ACENIC is not set
> # CONFIG_DL2K is not set
> # CONFIG_E1000 is not set
> # CONFIG_E1000E is not set
> # CONFIG_IP1000 is not set
> # CONFIG_IGB is not set
> # CONFIG_IGBVF is not set
> # CONFIG_NS83820 is not set
> # CONFIG_HAMACHI is not set
> # CONFIG_YELLOWFIN is not set
> # CONFIG_R8169 is not set
> # CONFIG_SIS190 is not set
> # CONFIG_SKGE is not set
> # CONFIG_SKY2 is not set
> # CONFIG_VIA_VELOCITY is not set
> CONFIG_TIGON3=y
> # CONFIG_BNX2 is not set
> # CONFIG_CNIC is not set
> # CONFIG_QLA3XXX is not set
> # CONFIG_ATL1 is not set
> # CONFIG_ATL1E is not set
> # CONFIG_ATL1C is not set
> # CONFIG_JME is not set
> # CONFIG_NETDEV_10000 is not set
> # CONFIG_TR is not set
> # CONFIG_WLAN is not set
> 
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
> 
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_RTL8150 is not set
> # CONFIG_USB_USBNET is not set
> # CONFIG_USB_IPHETH is not set
> # CONFIG_WAN is not set
> 
> #
> # CAIF transport drivers
> #
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_PPP is not set
> # CONFIG_SLIP is not set
> # CONFIG_NET_FC is not set
> # CONFIG_NETCONSOLE is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> # CONFIG_VMXNET3 is not set
> # CONFIG_ISDN is not set
> # CONFIG_PHONE is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> # CONFIG_INPUT_POLLDEV is not set
> # CONFIG_INPUT_SPARSEKMAP is not set
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> # CONFIG_INPUT_JOYDEV is not set
> # CONFIG_INPUT_EVDEV is not set
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> # CONFIG_KEYBOARD_ADP5588 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT2160 is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_INPUT_MOUSE is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> # CONFIG_INPUT_MISC is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> # CONFIG_SERIO_SERPORT is not set
> # CONFIG_SERIO_CT82C710 is not set
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> # CONFIG_SERIO_ALTERA_PS2 is not set
> # CONFIG_GAMEPORT is not set
> 
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> # CONFIG_DEVKMEM is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_N_GSM is not set
> # CONFIG_NOZOMI is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> # CONFIG_SERIAL_8250_CONSOLE is not set
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> # CONFIG_SERIAL_8250_MANY_PORTS is not set
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> # CONFIG_SERIAL_8250_RSA is not set
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MFD_HSU is not set
> CONFIG_SERIAL_CORE=y
> # CONFIG_SERIAL_JSM is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=192
> # CONFIG_IPMI_HANDLER is not set
> CONFIG_HW_RANDOM=y
> # CONFIG_HW_RANDOM_TIMERIOMEM is not set
> CONFIG_HW_RANDOM_INTEL=y
> # CONFIG_HW_RANDOM_AMD is not set
> CONFIG_HW_RANDOM_GEODE=y
> CONFIG_HW_RANDOM_VIA=y
> # CONFIG_NVRAM is not set
> # CONFIG_DTLK is not set
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_SONYPI is not set
> # CONFIG_MWAVE is not set
> # CONFIG_PC8736x_GPIO is not set
> # CONFIG_NSC_GPIO is not set
> # CONFIG_CS5535_GPIO is not set
> # CONFIG_RAW_DRIVER is not set
> CONFIG_HPET=y
> CONFIG_HPET_MMAP=y
> CONFIG_HANGCHECK_TIMER=y
> # CONFIG_TCG_TPM is not set
> # CONFIG_TELCLOCK is not set
> CONFIG_DEVPORT=y
> # CONFIG_RAMOOPS is not set
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> CONFIG_I2C_CHARDEV=y
> # CONFIG_I2C_MUX is not set
> CONFIG_I2C_HELPER_AUTO=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> CONFIG_I2C_I801=y
> CONFIG_I2C_ISCH=y
> CONFIG_I2C_PIIX4=y
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
> # CONFIG_I2C_VIAPRO is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_I2C_SCMI is not set
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_OCORES=y
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_SIMTEC is not set
> # CONFIG_I2C_XILINX is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_TAOS_EVM is not set
> # CONFIG_I2C_TINY_USB is not set
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_PCA_ISA is not set
> # CONFIG_SCx200_ACB is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_SPI is not set
> 
> #
> # PPS support
> #
> # CONFIG_PPS is not set
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> # CONFIG_GPIOLIB is not set
> # CONFIG_W1 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_TEST_POWER is not set
> # CONFIG_BATTERY_DS2760 is not set
> # CONFIG_BATTERY_DS2782 is not set
> # CONFIG_BATTERY_BQ27x00 is not set
> # CONFIG_BATTERY_MAX17040 is not set
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> # CONFIG_SENSORS_ABITUGURU is not set
> # CONFIG_SENSORS_ABITUGURU3 is not set
> # CONFIG_SENSORS_AD7414 is not set
> # CONFIG_SENSORS_AD7418 is not set
> # CONFIG_SENSORS_ADM1021 is not set
> # CONFIG_SENSORS_ADM1025 is not set
> # CONFIG_SENSORS_ADM1026 is not set
> # CONFIG_SENSORS_ADM1029 is not set
> # CONFIG_SENSORS_ADM1031 is not set
> # CONFIG_SENSORS_ADM9240 is not set
> # CONFIG_SENSORS_ADT7411 is not set
> # CONFIG_SENSORS_ADT7462 is not set
> # CONFIG_SENSORS_ADT7470 is not set
> # CONFIG_SENSORS_ADT7475 is not set
> # CONFIG_SENSORS_ASC7621 is not set
> # CONFIG_SENSORS_K8TEMP is not set
> # CONFIG_SENSORS_K10TEMP is not set
> # CONFIG_SENSORS_ASB100 is not set
> # CONFIG_SENSORS_ATXP1 is not set
> # CONFIG_SENSORS_DS1621 is not set
> # CONFIG_SENSORS_I5K_AMB is not set
> # CONFIG_SENSORS_F71805F is not set
> # CONFIG_SENSORS_F71882FG is not set
> # CONFIG_SENSORS_F75375S is not set
> # CONFIG_SENSORS_FSCHMD is not set
> # CONFIG_SENSORS_G760A is not set
> CONFIG_SENSORS_GL518SM=y
> CONFIG_SENSORS_GL520SM=y
> CONFIG_SENSORS_CORETEMP=y
> CONFIG_SENSORS_PKGTEMP=y
> CONFIG_SENSORS_IT87=y
> # CONFIG_SENSORS_JC42 is not set
> CONFIG_SENSORS_LM63=y
> # CONFIG_SENSORS_LM73 is not set
> CONFIG_SENSORS_LM75=y
> CONFIG_SENSORS_LM77=y
> CONFIG_SENSORS_LM78=y
> CONFIG_SENSORS_LM80=y
> CONFIG_SENSORS_LM83=y
> CONFIG_SENSORS_LM85=y
> CONFIG_SENSORS_LM87=y
> CONFIG_SENSORS_LM90=y
> CONFIG_SENSORS_LM92=y
> CONFIG_SENSORS_LM93=y
> # CONFIG_SENSORS_LTC4215 is not set
> # CONFIG_SENSORS_LTC4245 is not set
> # CONFIG_SENSORS_LM95241 is not set
> CONFIG_SENSORS_MAX1619=y
> CONFIG_SENSORS_MAX6650=y
> CONFIG_SENSORS_PC87360=y
> CONFIG_SENSORS_PC87427=y
> # CONFIG_SENSORS_PCF8591 is not set
> CONFIG_SENSORS_SIS5595=y
> # CONFIG_SENSORS_SMM665 is not set
> CONFIG_SENSORS_DME1737=y
> # CONFIG_SENSORS_EMC1403 is not set
> # CONFIG_SENSORS_EMC2103 is not set
> CONFIG_SENSORS_SMSC47M1=y
> CONFIG_SENSORS_SMSC47M192=y
> CONFIG_SENSORS_SMSC47B397=y
> CONFIG_SENSORS_ADS7828=y
> # CONFIG_SENSORS_AMC6821 is not set
> CONFIG_SENSORS_THMC50=y
> # CONFIG_SENSORS_TMP102 is not set
> # CONFIG_SENSORS_TMP401 is not set
> # CONFIG_SENSORS_TMP421 is not set
> # CONFIG_SENSORS_VIA_CPUTEMP is not set
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_VT8231 is not set
> CONFIG_SENSORS_W83781D=y
> CONFIG_SENSORS_W83791D=y
> CONFIG_SENSORS_W83792D=y
> CONFIG_SENSORS_W83793=y
> CONFIG_SENSORS_W83L785TS=y
> CONFIG_SENSORS_W83L786NG=y
> CONFIG_SENSORS_W83627HF=y
> CONFIG_SENSORS_W83627EHF=y
> # CONFIG_SENSORS_HDAPS is not set
> # CONFIG_SENSORS_LIS3_I2C is not set
> # CONFIG_SENSORS_APPLESMC is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ATK0110 is not set
> # CONFIG_SENSORS_LIS3LV02D is not set
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> CONFIG_WATCHDOG=y
> # CONFIG_WATCHDOG_NOWAYOUT is not set
> 
> #
> # Watchdog Device Drivers
> #
> CONFIG_SOFT_WATCHDOG=y
> # CONFIG_ACQUIRE_WDT is not set
> # CONFIG_ADVANTECH_WDT is not set
> # CONFIG_ALIM1535_WDT is not set
> # CONFIG_ALIM7101_WDT is not set
> # CONFIG_F71808E_WDT is not set
> # CONFIG_SC520_WDT is not set
> # CONFIG_SBC_FITPC2_WATCHDOG is not set
> # CONFIG_EUROTECH_WDT is not set
> # CONFIG_IB700_WDT is not set
> # CONFIG_IBMASR is not set
> # CONFIG_WAFER_WDT is not set
> # CONFIG_I6300ESB_WDT is not set
> CONFIG_ITCO_WDT=y
> CONFIG_ITCO_VENDOR_SUPPORT=y
> # CONFIG_IT8712F_WDT is not set
> # CONFIG_IT87_WDT is not set
> # CONFIG_HP_WATCHDOG is not set
> # CONFIG_SC1200_WDT is not set
> # CONFIG_PC87413_WDT is not set
> # CONFIG_60XX_WDT is not set
> # CONFIG_SBC8360_WDT is not set
> # CONFIG_SBC7240_WDT is not set
> # CONFIG_CPU5_WDT is not set
> # CONFIG_SMSC_SCH311X_WDT is not set
> # CONFIG_SMSC37B787_WDT is not set
> # CONFIG_W83627HF_WDT is not set
> # CONFIG_W83697HF_WDT is not set
> # CONFIG_W83697UG_WDT is not set
> # CONFIG_W83877F_WDT is not set
> # CONFIG_W83977F_WDT is not set
> # CONFIG_MACHZ_WDT is not set
> # CONFIG_SBC_EPX_C3_WATCHDOG is not set
> 
> #
> # ISA-based Watchdog Cards
> #
> # CONFIG_PCWATCHDOG is not set
> # CONFIG_MIXCOMWD is not set
> # CONFIG_WDT is not set
> 
> #
> # PCI-based Watchdog Cards
> #
> # CONFIG_PCIPCWATCHDOG is not set
> # CONFIG_WDTPCI is not set
> 
> #
> # USB-based Watchdog Cards
> #
> # CONFIG_USBPCWATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> # CONFIG_SSB is not set
> # CONFIG_MFD_SUPPORT is not set
> CONFIG_MFD_CORE=y
> CONFIG_LPC_SCH=y
> # CONFIG_REGULATOR is not set
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> CONFIG_AGP=y
> # CONFIG_AGP_ALI is not set
> # CONFIG_AGP_ATI is not set
> # CONFIG_AGP_AMD is not set
> # CONFIG_AGP_AMD64 is not set
> # CONFIG_AGP_INTEL is not set
> # CONFIG_AGP_NVIDIA is not set
> # CONFIG_AGP_SIS is not set
> # CONFIG_AGP_SWORKS is not set
> # CONFIG_AGP_VIA is not set
> # CONFIG_AGP_EFFICEON is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> # CONFIG_DRM is not set
> # CONFIG_VGASTATE is not set
> # CONFIG_VIDEO_OUTPUT_CONTROL is not set
> # CONFIG_FB is not set
> # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
> 
> #
> # Display device support
> #
> # CONFIG_DISPLAY_SUPPORT is not set
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=256
> # CONFIG_MDA_CONSOLE is not set
> CONFIG_DUMMY_CONSOLE=y
> # CONFIG_SOUND is not set
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=y
> # CONFIG_HIDRAW is not set
> 
> #
> # USB Input Devices
> #
> CONFIG_USB_HID=y
> # CONFIG_HID_PID is not set
> # CONFIG_USB_HIDDEV is not set
> 
> #
> # Special HID drivers
> #
> # CONFIG_HID_3M_PCT is not set
> CONFIG_HID_A4TECH=y
> # CONFIG_HID_ACRUX_FF is not set
> CONFIG_HID_APPLE=y
> CONFIG_HID_BELKIN=y
> # CONFIG_HID_CANDO is not set
> CONFIG_HID_CHERRY=y
> CONFIG_HID_CHICONY=y
> CONFIG_HID_CYPRESS=y
> # CONFIG_HID_DRAGONRISE is not set
> # CONFIG_HID_EGALAX is not set
> CONFIG_HID_EZKEY=y
> CONFIG_HID_KYE=y
> # CONFIG_HID_GYRATION is not set
> # CONFIG_HID_TWINHAN is not set
> CONFIG_HID_KENSINGTON=y
> CONFIG_HID_LOGITECH=y
> # CONFIG_LOGITECH_FF is not set
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> # CONFIG_LOGIG940_FF is not set
> CONFIG_HID_MICROSOFT=y
> # CONFIG_HID_MOSART is not set
> CONFIG_HID_MONTEREY=y
> # CONFIG_HID_NTRIG is not set
> # CONFIG_HID_ORTEK is not set
> # CONFIG_HID_PANTHERLORD is not set
> # CONFIG_HID_PETALYNX is not set
> # CONFIG_HID_PICOLCD is not set
> # CONFIG_HID_QUANTA is not set
> # CONFIG_HID_ROCCAT is not set
> # CONFIG_HID_ROCCAT_KONE is not set
> # CONFIG_HID_SAMSUNG is not set
> # CONFIG_HID_SONY is not set
> # CONFIG_HID_STANTUM is not set
> # CONFIG_HID_SUNPLUS is not set
> # CONFIG_HID_GREENASIA is not set
> # CONFIG_HID_SMARTJOYPLUS is not set
> # CONFIG_HID_TOPSEED is not set
> # CONFIG_HID_THRUSTMASTER is not set
> # CONFIG_HID_ZEROPLUS is not set
> # CONFIG_HID_ZYDACRON is not set
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB=y
> # CONFIG_USB_DEBUG is not set
> # CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=y
> CONFIG_USB_DEVICE_CLASS=y
> # CONFIG_USB_DYNAMIC_MINORS is not set
> # CONFIG_USB_MON is not set
> # CONFIG_USB_WUSB is not set
> # CONFIG_USB_WUSB_CBAF is not set
> 
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> # CONFIG_USB_XHCI_HCD is not set
> CONFIG_USB_EHCI_HCD=y
> # CONFIG_USB_EHCI_ROOT_HUB_TT is not set
> # CONFIG_USB_EHCI_TT_NEWSCHED is not set
> # CONFIG_USB_OXU210HP_HCD is not set
> # CONFIG_USB_ISP116X_HCD is not set
> # CONFIG_USB_ISP1760_HCD is not set
> # CONFIG_USB_ISP1362_HCD is not set
> # CONFIG_USB_OHCI_HCD is not set
> CONFIG_USB_UHCI_HCD=y
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> # CONFIG_USB_WHCI_HCD is not set
> # CONFIG_USB_HWA_HCD is not set
> 
> #
> # USB Device Class drivers
> #
> # CONFIG_USB_ACM is not set
> # CONFIG_USB_PRINTER is not set
> # CONFIG_USB_WDM is not set
> # CONFIG_USB_TMC is not set
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> # CONFIG_USB_STORAGE is not set
> # CONFIG_USB_LIBUSUAL is not set
> 
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
> 
> #
> # USB port drivers
> #
> # CONFIG_USB_SERIAL is not set
> 
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> # CONFIG_USB_ADUTUX is not set
> # CONFIG_USB_SEVSEG is not set
> # CONFIG_USB_RIO500 is not set
> # CONFIG_USB_LEGOTOWER is not set
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_LED is not set
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> # CONFIG_USB_IDMOUSE is not set
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> # CONFIG_USB_SISUSBVGA is not set
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> # CONFIG_USB_TEST is not set
> # CONFIG_USB_ISIGHTFW is not set
> # CONFIG_USB_GADGET is not set
> 
> #
> # OTG and related infrastructure
> #
> # CONFIG_NOP_USB_XCEIV is not set
> # CONFIG_UWB is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> # CONFIG_NEW_LEDS is not set
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> CONFIG_EDAC=y
> 
> #
> # Reporting subsystems
> #
> # CONFIG_EDAC_DEBUG is not set
> CONFIG_EDAC_DECODE_MCE=y
> CONFIG_EDAC_MM_EDAC=y
> # CONFIG_EDAC_AMD76X is not set
> # CONFIG_EDAC_E7XXX is not set
> # CONFIG_EDAC_E752X is not set
> # CONFIG_EDAC_I82875P is not set
> # CONFIG_EDAC_I82975X is not set
> CONFIG_EDAC_I3000=y
> # CONFIG_EDAC_I3200 is not set
> # CONFIG_EDAC_X38 is not set
> # CONFIG_EDAC_I5400 is not set
> # CONFIG_EDAC_I7CORE is not set
> # CONFIG_EDAC_I82860 is not set
> # CONFIG_EDAC_R82600 is not set
> # CONFIG_EDAC_I5000 is not set
> # CONFIG_EDAC_I5100 is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> CONFIG_RTC_INTF_DEV_UIE_EMUL=y
> # CONFIG_RTC_DRV_TEST is not set
> 
> #
> # I2C RTC drivers
> #
> # CONFIG_RTC_DRV_DS1307 is not set
> # CONFIG_RTC_DRV_DS1374 is not set
> # CONFIG_RTC_DRV_DS1672 is not set
> # CONFIG_RTC_DRV_DS3232 is not set
> # CONFIG_RTC_DRV_MAX6900 is not set
> # CONFIG_RTC_DRV_RS5C372 is not set
> # CONFIG_RTC_DRV_ISL1208 is not set
> # CONFIG_RTC_DRV_ISL12022 is not set
> # CONFIG_RTC_DRV_X1205 is not set
> # CONFIG_RTC_DRV_PCF8563 is not set
> # CONFIG_RTC_DRV_PCF8583 is not set
> # CONFIG_RTC_DRV_M41T80 is not set
> # CONFIG_RTC_DRV_BQ32K is not set
> # CONFIG_RTC_DRV_S35390A is not set
> # CONFIG_RTC_DRV_FM3130 is not set
> # CONFIG_RTC_DRV_RX8581 is not set
> # CONFIG_RTC_DRV_RX8025 is not set
> 
> #
> # SPI RTC drivers
> #
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> # CONFIG_RTC_DRV_DS1286 is not set
> # CONFIG_RTC_DRV_DS1511 is not set
> # CONFIG_RTC_DRV_DS1553 is not set
> # CONFIG_RTC_DRV_DS1742 is not set
> # CONFIG_RTC_DRV_STK17TA8 is not set
> # CONFIG_RTC_DRV_M48T86 is not set
> # CONFIG_RTC_DRV_M48T35 is not set
> # CONFIG_RTC_DRV_M48T59 is not set
> # CONFIG_RTC_DRV_MSM6242 is not set
> # CONFIG_RTC_DRV_BQ4802 is not set
> # CONFIG_RTC_DRV_RP5C01 is not set
> # CONFIG_RTC_DRV_V3020 is not set
> 
> #
> # on-CPU RTC drivers
> #
> CONFIG_DMADEVICES=y
> # CONFIG_DMADEVICES_DEBUG is not set
> 
> #
> # DMA Devices
> #
> # CONFIG_INTEL_MID_DMAC is not set
> CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y
> CONFIG_INTEL_IOATDMA=y
> # CONFIG_TIMB_DMA is not set
> # CONFIG_PCH_DMA is not set
> CONFIG_DMA_ENGINE=y
> 
> #
> # DMA Clients
> #
> CONFIG_NET_DMA=y
> # CONFIG_ASYNC_TX_DMA is not set
> # CONFIG_DMATEST is not set
> CONFIG_DCA=y
> # CONFIG_AUXDISPLAY is not set
> # CONFIG_UIO is not set
> # CONFIG_STAGING is not set
> # CONFIG_X86_PLATFORM_DEVICES is not set
> 
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> CONFIG_FIRMWARE_MEMMAP=y
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> # CONFIG_DMIID is not set
> # CONFIG_ISCSI_IBFT_FIND is not set
> 
> #
> # File systems
> #
> # CONFIG_EXT2_FS is not set
> # CONFIG_EXT3_FS is not set
> # CONFIG_EXT4_FS is not set
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_XFS_FS=y
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> # CONFIG_XFS_DEBUG is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_OCFS2_FS is not set
> # CONFIG_BTRFS_FS is not set
> # CONFIG_NILFS2_FS is not set
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_FANOTIFY is not set
> # CONFIG_QUOTA is not set
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> CONFIG_QUOTACTL=y
> # CONFIG_AUTOFS_FS is not set
> # CONFIG_AUTOFS4_FS is not set
> # CONFIG_FUSE_FS is not set
> CONFIG_GENERIC_ACL=y
> 
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> # CONFIG_ISO9660_FS is not set
> # CONFIG_UDF_FS is not set
> 
> #
> # DOS/FAT/NT Filesystems
> #
> # CONFIG_MSDOS_FS is not set
> # CONFIG_VFAT_FS is not set
> # CONFIG_NTFS_FS is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> # CONFIG_PROC_KCORE is not set
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> CONFIG_CONFIGFS_FS=y
> # CONFIG_MISC_FILESYSTEMS is not set
> # CONFIG_NETWORK_FILESYSTEMS is not set
> CONFIG_EXPORTFS=y
> 
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="utf8"
> CONFIG_NLS_CODEPAGE_437=y
> CONFIG_NLS_CODEPAGE_737=y
> CONFIG_NLS_CODEPAGE_775=y
> CONFIG_NLS_CODEPAGE_850=y
> CONFIG_NLS_CODEPAGE_852=y
> CONFIG_NLS_CODEPAGE_855=y
> CONFIG_NLS_CODEPAGE_857=y
> CONFIG_NLS_CODEPAGE_860=y
> CONFIG_NLS_CODEPAGE_861=y
> CONFIG_NLS_CODEPAGE_862=y
> CONFIG_NLS_CODEPAGE_863=y
> CONFIG_NLS_CODEPAGE_864=y
> CONFIG_NLS_CODEPAGE_865=y
> CONFIG_NLS_CODEPAGE_866=y
> CONFIG_NLS_CODEPAGE_869=y
> CONFIG_NLS_CODEPAGE_936=y
> CONFIG_NLS_CODEPAGE_950=y
> CONFIG_NLS_CODEPAGE_932=y
> CONFIG_NLS_CODEPAGE_949=y
> CONFIG_NLS_CODEPAGE_874=y
> CONFIG_NLS_ISO8859_8=y
> CONFIG_NLS_CODEPAGE_1250=y
> CONFIG_NLS_CODEPAGE_1251=y
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> CONFIG_NLS_ISO8859_2=y
> CONFIG_NLS_ISO8859_3=y
> CONFIG_NLS_ISO8859_4=y
> CONFIG_NLS_ISO8859_5=y
> CONFIG_NLS_ISO8859_6=y
> CONFIG_NLS_ISO8859_7=y
> CONFIG_NLS_ISO8859_9=y
> CONFIG_NLS_ISO8859_13=y
> CONFIG_NLS_ISO8859_14=y
> CONFIG_NLS_ISO8859_15=y
> CONFIG_NLS_KOI8_R=y
> CONFIG_NLS_KOI8_U=y
> CONFIG_NLS_UTF8=y
> # CONFIG_DLM is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_PRINTK_TIME=y
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> CONFIG_MAGIC_SYSRQ=y
> # CONFIG_STRIP_ASM_SYMS is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> # CONFIG_DEBUG_FS is not set
> # CONFIG_HEADERS_CHECK is not set
> CONFIG_DEBUG_KERNEL=y
> # CONFIG_DEBUG_SHIRQ is not set
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
> CONFIG_DETECT_HUNG_TASK=y
> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
> # CONFIG_SCHED_DEBUG is not set
> # CONFIG_SCHEDSTATS is not set
> # CONFIG_TIMER_STATS is not set
> # CONFIG_DEBUG_OBJECTS is not set
> # CONFIG_SLUB_DEBUG_ON is not set
> # CONFIG_SLUB_STATS is not set
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_LOCK_STAT is not set
> # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_INFO is not set
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_VIRTUAL is not set
> # CONFIG_DEBUG_WRITECOUNT is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_DETECTOR=y
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> # CONFIG_FAULT_INJECTION is not set
> # CONFIG_LATENCYTOP is not set
> CONFIG_SYSCTL_SYSCALL_CHECK=y
> # CONFIG_DEBUG_PAGEALLOC is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_TRACING_SUPPORT=y
> # CONFIG_FTRACE is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_KMEMCHECK is not set
> CONFIG_STRICT_DEVMEM=y
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_PER_CPU_MAPS is not set
> # CONFIG_X86_PTDUMP is not set
> CONFIG_DEBUG_RODATA=y
> CONFIG_DEBUG_RODATA_TEST=y
> # CONFIG_4KSTACKS is not set
> CONFIG_DOUBLEFAULT=y
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> CONFIG_IO_DELAY_NONE=y
> CONFIG_DEFAULT_IO_DELAY_TYPE=3
> # CONFIG_CPA_DEBUG is not set
> CONFIG_OPTIMIZE_INLINING=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> 
> #
> # Security options
> #
> # CONFIG_KEYS is not set
> # CONFIG_SECURITY is not set
> # CONFIG_SECURITYFS is not set
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_XOR_BLOCKS=y
> CONFIG_ASYNC_CORE=y
> CONFIG_ASYNC_MEMCPY=y
> CONFIG_ASYNC_XOR=y
> CONFIG_ASYNC_PQ=y
> CONFIG_ASYNC_RAID6_RECOV=y
> # CONFIG_ASYNC_RAID6_TEST is not set
> CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
> CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> # CONFIG_CRYPTO_FIPS is not set
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> # CONFIG_CRYPTO_GF128MUL is not set
> # CONFIG_CRYPTO_NULL is not set
> # CONFIG_CRYPTO_PCRYPT is not set
> CONFIG_CRYPTO_WORKQUEUE=y
> # CONFIG_CRYPTO_CRYPTD is not set
> CONFIG_CRYPTO_AUTHENC=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> # CONFIG_CRYPTO_GCM is not set
> # CONFIG_CRYPTO_SEQIV is not set
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> # CONFIG_CRYPTO_CTR is not set
> # CONFIG_CRYPTO_CTS is not set
> # CONFIG_CRYPTO_ECB is not set
> # CONFIG_CRYPTO_LRW is not set
> # CONFIG_CRYPTO_PCBC is not set
> # CONFIG_CRYPTO_XTS is not set
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_HMAC=y
> # CONFIG_CRYPTO_XCBC is not set
> # CONFIG_CRYPTO_VMAC is not set
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> # CONFIG_CRYPTO_CRC32C_INTEL is not set
> # CONFIG_CRYPTO_GHASH is not set
> # CONFIG_CRYPTO_MD4 is not set
> CONFIG_CRYPTO_MD5=y
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> # CONFIG_CRYPTO_RMD128 is not set
> # CONFIG_CRYPTO_RMD160 is not set
> # CONFIG_CRYPTO_RMD256 is not set
> # CONFIG_CRYPTO_RMD320 is not set
> CONFIG_CRYPTO_SHA1=y
> # CONFIG_CRYPTO_SHA256 is not set
> # CONFIG_CRYPTO_SHA512 is not set
> # CONFIG_CRYPTO_TGR192 is not set
> # CONFIG_CRYPTO_WP512 is not set
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_586=y
> # CONFIG_CRYPTO_ANUBIS is not set
> # CONFIG_CRYPTO_ARC4 is not set
> # CONFIG_CRYPTO_BLOWFISH is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_SALSA20 is not set
> # CONFIG_CRYPTO_SALSA20_586 is not set
> # CONFIG_CRYPTO_SEED is not set
> # CONFIG_CRYPTO_SERPENT is not set
> # CONFIG_CRYPTO_TEA is not set
> CONFIG_CRYPTO_TWOFISH=y
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> CONFIG_CRYPTO_TWOFISH_586=y
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_ZLIB=y
> CONFIG_CRYPTO_LZO=y
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=y
> # CONFIG_CRYPTO_HW is not set
> CONFIG_HAVE_KVM=y
> # CONFIG_VIRTUALIZATION is not set
> # CONFIG_BINARY_PRINTF is not set
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=y
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_FIND_NEXT_BIT=y
> CONFIG_GENERIC_FIND_LAST_BIT=y
> # CONFIG_CRC_CCITT is not set
> # CONFIG_CRC16 is not set
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> # CONFIG_CRC7 is not set
> CONFIG_LIBCRC32C=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=y
> CONFIG_TEXTSEARCH_BM=y
> CONFIG_TEXTSEARCH_FSM=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_NLATTR=y

