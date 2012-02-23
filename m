Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2BWSP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:15:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756538Ab2BWSP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:15:26 -0500
Date: Thu, 23 Feb 2012 13:14:39 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: 3.3-rc4 slub debug / rcu slowness, traces.
Message-ID: <20120223181438.GC26722@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just dug out an laptop, updated it to the latest Fedora 15 updates, and
put the current git kernel as of 45196cee28a5bcfb6ddbe2bffa4270cbed66ae4b
onto it.  It took 20 minutes to boot. (Look at the timestamps in the dmesg below)

If I boot with slub_debug=- then it's reasonable again.
This laptop used to have no problems running with slub debug turned on
all the time, so something seems to have gotten a lot worse there.

Between 526s and 1126s, I got an emergency shell, but things weren't
very interactive.  I ran top, and saw modprobe running at 99% for minutes.
So it was making progress, albeit slowly.

Then I ran perf, and got a bunch of RCU spew.  Paul, does this look
like the stuff your patchset queued for 3.4 fixes ?
Could the RCU stuff explain why slub got so much slower ?

Once the machine finally boots, I can run X etc at a speed that
I would expect from this machine with debug turned on.

	Dave

[
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0-rc4+ (davej@vaio) (gcc version 4.6.1 20110908 (Red Hat 4.6.1-9) (GCC) ) #1 SMP PREEMPT Wed Feb 22 19:59:54 EST 2012
[    0.000000] Command line: ro root=/dev/mapper/vg_vaio-lv_root rd_LVM_LV=vg_vaio/lv_root rd_LVM_LV=vg_vaio/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us console=ttyUSB0,115200 console=tty0 rdshell reboot=a
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000ba0de000 (usable)
[    0.000000]  BIOS-e820: 00000000ba0de000 - 00000000ba0e1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ba0e1000 - 00000000bb90b000 (usable)
[    0.000000]  BIOS-e820: 00000000bb90b000 - 00000000bba3c000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bba3c000 - 00000000bbb6c000 (usable)
[    0.000000]  BIOS-e820: 00000000bbb6c000 - 00000000bbbbf000 (reserved)
[    0.000000]  BIOS-e820: 00000000bbbbf000 - 00000000bbc73000 (usable)
[    0.000000]  BIOS-e820: 00000000bbc73000 - 00000000bbcbf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bbcbf000 - 00000000bbce9000 (usable)
[    0.000000]  BIOS-e820: 00000000bbce9000 - 00000000bbcff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bbcff000 - 00000000bbd00000 (usable)
[    0.000000]  BIOS-e820: 00000000bbd00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe80000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Sony Corporation VGN-Z540N/VAIO, BIOS R1280M3 07/15/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0xbbd00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   3 base 0BBE00000 mask FFFE00000 uncachable
[    0.000000]   4 base 0BBD00000 mask FFFF00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3008MB, range: 64MB, type UC
[    0.000000] reg 3, base: 3006MB, range: 2MB, type UC
[    0.000000] reg 4, base: 3005MB, range: 1MB, type UC
[    0.000000] total RAM covered: 3005M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 5  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3005MB, range: 1MB, type UC
[    0.000000] reg 3, base: 3006MB, range: 2MB, type UC
[    0.000000] reg 4, base: 3008MB, range: 64MB, type UC
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bbd00000
[    0.000000]  0000000000 - 00bbc00000 page 2M
[    0.000000]  00bbc00000 - 00bbd00000 page 4k
[    0.000000] kernel direct mapping tables up to bbd00000 @ 1fffb000-20000000
[    0.000000] RAMDISK: 3681e000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02   Sony)
[    0.000000] ACPI: XSDT 00000000bbcfe120 0006C (v01   Sony     VAIO 20080715      01000013)
[    0.000000] ACPI: FACP 00000000bbcfd000 000F4 (v04   Sony     VAIO 20080715 MSFT 01000013)
[    0.000000] ACPI: DSDT 00000000bbcec000 0B00C (v01   Sony     VAIO 20080715 MSFT 01000013)
[    0.000000] ACPI: FACS 00000000bbc92000 00040
[    0.000000] ACPI: HPET 00000000bbcfc000 00038 (v01   Sony     VAIO 20080715 MSFT 01000013)
[    0.000000] ACPI: APIC 00000000bbcfb000 0006C (v01   Sony     VAIO 20080715 MSFT 01000013)
[    0.000000] ACPI: MCFG 00000000bbcfa000 0003C (v01   Sony     VAIO 20080715 MSFT 01000013)
[    0.000000] ACPI: SLIC 00000000bbcf9000 00176 (v01   Sony     VAIO 20080715 MSFT 01000013)
[    0.000000] ACPI: ASF! 00000000bbcf8000 000A5 (v32   Sony     VAIO 20080715 MSFT 01000013)
[    0.000000] ACPI: BOOT 00000000bbceb000 00028 (v01   Sony     VAIO 20080715 MSFT 01000013)
[    0.000000] ACPI: DBGP 00000000bbcea000 00034 (v01   Sony     VAIO 20080715 MSFT 01000013)
[    0.000000] ACPI: SSDT 00000000bbce9000 00655 (v01   Sony     VAIO 20080715 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000000bbd00000
[    0.000000] Initmem setup node 0 0000000000000000-00000000bbd00000
[    0.000000]   NODE_DATA [00000000bbcd4000 - 00000000bbce8fff]
[    0.000000]  [ffffea0000000000-ffffea0002ffffff] PMD -> [ffff8800b7000000-ffff8800b9ffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000ba0de
[    0.000000]     0: 0x000ba0e1 -> 0x000bb90b
[    0.000000]     0: 0x000bba3c -> 0x000bbb6c
[    0.000000]     0: 0x000bbbbf -> 0x000bbc73
[    0.000000]     0: 0x000bbcbf -> 0x000bbce9
[    0.000000]     0: 0x000bbcff -> 0x000bbd00
[    0.000000] On node 0 totalpages: 768678
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3914 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11956 pages used for memmap
[    0.000000]   DMA32 zone: 752739 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000ba0de000 - 00000000ba0e1000
[    0.000000] PM: Registered nosave memory: 00000000bb90b000 - 00000000bba3c000
[    0.000000] PM: Registered nosave memory: 00000000bbb6c000 - 00000000bbbbf000
[    0.000000] PM: Registered nosave memory: 00000000bbc73000 - 00000000bbcbf000
[    0.000000] PM: Registered nosave memory: 00000000bbce9000 - 00000000bbcff000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:38000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 477 pages/cpu @ffff8800bb000000 s1921216 r8192 d24384 u2097152
[    0.000000] pcpu-alloc: s1921216 r8192 d24384 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 756653
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: ro root=/dev/mapper/vg_vaio-lv_root rd_LVM_LV=vg_vaio/lv_root rd_LVM_LV=vg_vaio/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us console=ttyUSB0,115200 console=tty0 rdshell reboot=a
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 2964236k/3077120k available (6823k kernel code, 2408k absent, 110476k reserved, 6483k data, 2808k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 12582912 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ODEBUG: 18 of 18 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2393.906 MHz processor.
[    0.001004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.81 BogoMIPS (lpj=2393906)
[    0.001148] pid_max: default: 32768 minimum: 301
[    0.002017] Security Framework initialized
[    0.002096] SELinux:  Initializing.
[    0.002272] SELinux:  Starting in permissive mode
[    0.003265] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.005683] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.007047] Mount-cache hash table entries: 256
[    0.010364] Initializing cgroup subsys cpuacct
[    0.010438] Initializing cgroup subsys memory
[    0.010703] Initializing cgroup subsys devices
[    0.010789] Initializing cgroup subsys freezer
[    0.010867] Initializing cgroup subsys net_cls
[    0.010946] Initializing cgroup subsys blkio
[    0.011098] Initializing cgroup subsys perf_event
[    0.011481] CPU: Physical Processor ID: 0
[    0.011552] CPU: Processor Core ID: 0
[    0.011622] mce: CPU supports 6 MCE banks
[    0.011704] CPU0: Thermal monitoring handled by SMI
[    0.011713] using mwait in idle threads.
[    0.013667] ACPI: Core revision 20120111
[    0.243029] ftrace: allocating 22543 entries in 89 pages
[    0.250494] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.260578] CPU0: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz stepping 06
[    0.260969] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.260969] ... version:                2
[    0.260969] ... bit width:              40
[    0.260969] ... generic registers:      2
[    0.260969] ... value mask:             000000ffffffffff
[    0.260969] ... max period:             000000007fffffff
[    0.260969] ... fixed-purpose events:   3
[    0.260969] ... event mask:             0000000700000003
[    0.268950] NMI watchdog enabled, takes one hw-pmu counter.
[    0.275080] lockdep: fixing up alternatives.
[    0.277240] Booting Node   0, Processors  #1
[    0.277319] smpboot cpu 1: start_ip = 9a000
[    0.001999] CPU1: Thermal monitoring handled by SMI
[    0.289157] NMI watchdog enabled, takes one hw-pmu counter.
[    0.290980] Brought up 2 CPUs
[    0.291049] Total of 2 processors activated (9575.62 BogoMIPS).
[    0.295175] devtmpfs: initialized
[    0.306423] PM: Registering ACPI NVS region at ba0de000 (12288 bytes)
[    0.306423] PM: Registering ACPI NVS region at bb90b000 (1249280 bytes)
[    0.308462] PM: Registering ACPI NVS region at bbc73000 (311296 bytes)
[    0.310131] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.310382] RTC time: 12:40:13, date: 02/23/12
[    0.314828] ACPI: bus type pci registered
[    0.315764] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.315869] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.343745] PCI: Using configuration type 1 for base access
[    0.367267] bio: create slab <bio-0> at 0
[    0.368372] ACPI: Added _OSI(Module Device)
[    0.368456] ACPI: Added _OSI(Processor Device)
[    0.368538] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.368979] ACPI: Added _OSI(Processor Aggregator Device)
[    0.384920] ACPI: EC: Look up EC in DSDT
[    0.404705] ACPI: Executed 1 blocks of module-level executable AML code
[    0.473129] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.093637] ACPI: SSDT 00000000bbb6fc18 00265 (v01   Sony     VAIO 20080715 INTL 20051117)
[    1.099495] ACPI: Dynamic OEM Table Load:
[    1.099637] ACPI: SSDT           (null) 00265 (v01   Sony     VAIO 20080715 INTL 20051117)
[    1.105914] ACPI: SSDT 00000000bbb6d618 005B8 (v01   Sony     VAIO 20080715 INTL 20051117)
[    1.110505] ACPI: Dynamic OEM Table Load:
[    1.110648] ACPI: SSDT           (null) 005B8 (v01   Sony     VAIO 20080715 INTL 20051117)
[    1.126630] ACPI: SSDT 00000000bbb6ee18 001CF (v01   Sony     VAIO 20080715 INTL 20051117)
[    1.134201] ACPI: Dynamic OEM Table Load:
[    1.134344] ACPI: SSDT           (null) 001CF (v01   Sony     VAIO 20080715 INTL 20051117)
[    1.140260] ACPI: SSDT 00000000bbb6ff18 0008D (v01   Sony     VAIO 20080715 INTL 20051117)
[    1.145741] ACPI: Dynamic OEM Table Load:
[    1.145838] ACPI: SSDT           (null) 0008D (v01   Sony     VAIO 20080715 INTL 20051117)
[    1.355433] ACPI: Interpreter enabled
[    1.355505] ACPI: (supports S0 S3 S4 S5)
[    1.356359] ACPI: Using IOAPIC for interrupt routing
[    1.384435] ACPI: Power Resource [MGPR] (on)
[    1.400666] ACPI: Power Resource [DGPR] (on)
[    1.553885] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    1.571901] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    1.571977] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.593556] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.629988] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.630063] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.630137] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.630239] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    1.630340] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    1.631573] PCI host bridge to bus 0000:00
[    1.631646] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.631719] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.631764] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.631838] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
[    1.631912] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    1.632048] pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
[    1.632160] DMAR: Forcing write-buffer flush capability
[    1.632231] DMAR: Disabling IOMMU for graphics on this chipset
[    1.632394] pci 0000:00:01.0: [8086:2a41] type 1 class 0x000604
[    1.632542] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.632652] pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
[    1.632684] pci 0000:00:02.0: reg 10: [mem 0xe8400000-0xe87fffff 64bit]
[    1.632703] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.632716] pci 0000:00:02.0: reg 20: [io  0x8130-0x8137]
[    1.632950] pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
[    1.632988] pci 0000:00:19.0: reg 10: [mem 0xee900000-0xee91ffff]
[    1.633005] pci 0000:00:19.0: reg 14: [mem 0xee924000-0xee924fff]
[    1.633021] pci 0000:00:19.0: reg 18: [io  0x8100-0x811f]
[    1.633179] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.633241] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    1.633335] pci 0000:00:1a.0: reg 20: [io  0x80e0-0x80ff]
[    1.633496] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    1.633601] pci 0000:00:1a.1: reg 20: [io  0x80c0-0x80df]
[    1.633759] pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
[    1.633851] pci 0000:00:1a.2: reg 20: [io  0x80a0-0x80bf]
[    1.634035] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    1.635763] pci 0000:00:1a.7: reg 10: [mem 0xee925c00-0xee925fff]
[    1.647870] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.647943] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    1.647974] pci 0000:00:1b.0: reg 10: [mem 0xee920000-0xee923fff 64bit]
[    1.648155] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.648235] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    1.648418] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.648486] pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
[    1.648669] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.648764] pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
[    1.648948] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.649027] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    1.649121] pci 0000:00:1d.0: reg 20: [io  0x8080-0x809f]
[    1.649281] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    1.649389] pci 0000:00:1d.1: reg 20: [io  0x8060-0x807f]
[    1.649545] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    1.649640] pci 0000:00:1d.2: reg 20: [io  0x8040-0x805f]
[    1.649817] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    1.651761] pci 0000:00:1d.7: reg 10: [mem 0xee925800-0xee925bff]
[    1.663865] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.663940] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    1.664114] pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
[    1.665016] pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
[    1.665056] pci 0000:00:1f.2: reg 10: [io  0x8128-0x812f]
[    1.665072] pci 0000:00:1f.2: reg 14: [io  0x813c-0x813f]
[    1.665088] pci 0000:00:1f.2: reg 18: [io  0x8120-0x8127]
[    1.665104] pci 0000:00:1f.2: reg 1c: [io  0x8138-0x813b]
[    1.665120] pci 0000:00:1f.2: reg 20: [io  0x8020-0x803f]
[    1.665136] pci 0000:00:1f.2: reg 24: [mem 0xee925000-0xee9257ff]
[    1.665261] pci 0000:00:1f.2: PME# supported from D3hot
[    1.665317] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    1.665348] pci 0000:00:1f.3: reg 10: [mem 0xee926000-0xee9260ff 64bit]
[    1.665392] pci 0000:00:1f.3: reg 20: [io  0x8000-0x801f]
[    1.665686] pci 0000:01:00.0: [10de:06e5] type 0 class 0x000300
[    1.665767] pci 0000:01:00.0: reg 10: [mem 0xe4000000-0xe4ffffff]
[    1.665864] pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
[    1.665960] pci 0000:01:00.0: reg 1c: [mem 0xe2000000-0xe3ffffff 64bit]
[    1.666022] pci 0000:01:00.0: reg 24: [io  0x7000-0x707f]
[    1.666084] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    1.667823] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.667900] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
[    1.667906] pci 0000:00:01.0:   bridge window [mem 0xe2000000-0xe4ffffff]
[    1.667914] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    1.668028] pci 0000:00:1c.0: PCI bridge to [bus 02-05]
[    1.668105] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    1.668112] pci 0000:00:1c.0:   bridge window [mem 0xed900000-0xee8fffff]
[    1.668123] pci 0000:00:1c.0:   bridge window [mem 0xe8800000-0xe97fffff 64bit pref]
[    1.668400] pci 0000:06:00.0: [8086:4232] type 0 class 0x000280
[    1.668543] pci 0000:06:00.0: reg 10: [mem 0xec800000-0xec801fff 64bit]
[    1.669263] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    1.669536] pci 0000:00:1c.1: PCI bridge to [bus 06-06]
[    1.669612] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    1.669619] pci 0000:00:1c.1:   bridge window [mem 0xec800000-0xed8fffff]
[    1.669630] pci 0000:00:1c.1:   bridge window [mem 0xe9800000-0xea7fffff 64bit pref]
[    1.669736] pci 0000:00:1c.3: PCI bridge to [bus 08-08]
[    1.669763] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    1.669769] pci 0000:00:1c.3:   bridge window [mem 0xeb800000-0xec7fffff]
[    1.669780] pci 0000:00:1c.3:   bridge window [mem 0xea800000-0xeb7fffff 64bit pref]
[    1.669895] pci 0000:0b:04.0: [1180:0476] type 2 class 0x000607
[    1.669930] pci 0000:0b:04.0: reg 10: [mem 0xe8000000-0xe8000fff]
[    1.670011] pci 0000:0b:04.0: supports D1 D2
[    1.670014] pci 0000:0b:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.670086] pci 0000:0b:04.1: [1180:0832] type 0 class 0x000c00
[    1.670120] pci 0000:0b:04.1: reg 10: [mem 0xe8001000-0xe80017ff]
[    1.670298] pci 0000:0b:04.1: PME# supported from D0 D3hot D3cold
[    1.670363] pci 0000:0b:04.2: [1180:0822] type 0 class 0x000805
[    1.670397] pci 0000:0b:04.2: reg 10: [mem 0xe8001900-0xe80019ff]
[    1.670575] pci 0000:0b:04.2: supports D1 D2
[    1.670577] pci 0000:0b:04.2: PME# supported from D0 D1 D2 D3hot D3cold
[    1.670638] pci 0000:0b:04.4: [1180:0592] type 0 class 0x000880
[    1.670672] pci 0000:0b:04.4: reg 10: [mem 0xe8001800-0xe80018ff]
[    1.670904] pci 0000:0b:04.4: supports D1 D2
[    1.670907] pci 0000:0b:04.4: PME# supported from D0 D1 D2 D3hot D3cold
[    1.671016] pci 0000:00:1e.0: PCI bridge to [bus 0b-0c] (subtractive decode)
[    1.671096] pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
[    1.671103] pci 0000:00:1e.0:   bridge window [mem 0xe6000000-0xe80fffff]
[    1.671114] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe1ffffff 64bit pref]
[    1.671127] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.671140] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.671152] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.671164] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    1.671177] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    1.671270] pci_bus 0000:0c: [bus 0c-0f] partially hidden behind transparent bridge 0000:0b [bus 0b-0c]
[    1.671450] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.685406] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    1.687182] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    1.691466] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    1.694504] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    1.696365] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    1.702073]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.705835]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x00
[    1.705938] ACPI _OSC control for PCIe not granted, disabling ASPM
[    2.147658] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 *10 11 12)
[    2.150399] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
[    2.153153] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12)
[    2.155925] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 *10 11 12)
[    2.158707] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 *10 11 12)
[    2.161480] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
[    2.164246] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 *10 11 12)
[    2.167002] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 *10 11 12)
[    2.169035] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.169704] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    2.169880] vgaarb: loaded
[    2.169948] vgaarb: bridge control possible 0000:01:00.0
[    2.170019] vgaarb: no bridge control possible 0000:00:02.0
[    2.171987] SCSI subsystem initialized
[    2.172236] libata version 3.00 loaded.
[    2.173018] usbcore: registered new interface driver usbfs
[    2.173315] usbcore: registered new interface driver hub
[    2.173786] usbcore: registered new device driver usb
[    2.174532] PCI: Using ACPI for IRQ routing
[    2.177046] PCI: pci_cache_line_size set to 64 bytes
[    2.177969] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    2.177998] reserve RAM buffer: 00000000ba0de000 - 00000000bbffffff 
[    2.178160] reserve RAM buffer: 00000000bb90b000 - 00000000bbffffff 
[    2.178288] reserve RAM buffer: 00000000bbb6c000 - 00000000bbffffff 
[    2.178384] reserve RAM buffer: 00000000bbc73000 - 00000000bbffffff 
[    2.178451] reserve RAM buffer: 00000000bbce9000 - 00000000bbffffff 
[    2.178491] reserve RAM buffer: 00000000bbd00000 - 00000000bbffffff 
[    2.180411] NetLabel: Initializing
[    2.180481] NetLabel:  domain hash size = 128
[    2.180550] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.180823] NetLabel:  unlabeled traffic allowed by default
[    2.181005] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    2.181090] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    2.181340] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    2.187030] Switching to clocksource hpet
[    2.394518] pnp: PnP ACPI init
[    2.394797] ACPI: bus type pnp registered
[    2.419933] pnp 00:00: [bus 00-ff]
[    2.419945] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.419955] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.419966] pnp 00:00: [io  0x0d00-0xffff window]
[    2.419976] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.419986] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    2.419996] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    2.420006] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    2.420032] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    2.420042] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    2.420052] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    2.420062] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    2.420072] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    2.420088] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    2.420099] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    2.420109] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    2.420120] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    2.420130] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    2.420141] pnp 00:00: [mem 0xc0000000-0xfebfffff window]
[    2.420151] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    2.420739] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    2.428252] pnp 00:01: [io  0x002e-0x002f]
[    2.428263] pnp 00:01: [io  0x004e-0x004f]
[    2.428273] pnp 00:01: [io  0x164e-0x164f]
[    2.428283] pnp 00:01: [io  0x0061]
[    2.428293] pnp 00:01: [io  0x0070]
[    2.428302] pnp 00:01: [io  0x0080]
[    2.428312] pnp 00:01: [io  0x0092]
[    2.428321] pnp 00:01: [io  0x00b2-0x00b3]
[    2.428331] pnp 00:01: [io  0x0063]
[    2.428340] pnp 00:01: [io  0x0065]
[    2.428350] pnp 00:01: [io  0x0067]
[    2.428369] pnp 00:01: [io  0x0600-0x060f]
[    2.428379] pnp 00:01: [io  0x0610]
[    2.428390] pnp 00:01: [io  0x0800-0x080f]
[    2.428400] pnp 00:01: [io  0x0810-0x0817]
[    2.428410] pnp 00:01: [io  0x0820-0x0823]
[    2.428420] pnp 00:01: [io  0x0400-0x047f]
[    2.428430] pnp 00:01: [io  0x0500-0x053f]
[    2.428440] pnp 00:01: [io  0x2000]
[    2.428449] pnp 00:01: [io  0x2004]
[    2.428459] pnp 00:01: [mem 0xf8000000-0xfbffffff]
[    2.428469] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    2.428479] pnp 00:01: [mem 0xfed10000-0xfed13fff]
[    2.428489] pnp 00:01: [mem 0xfed18000-0xfed18fff]
[    2.428499] pnp 00:01: [mem 0xfed19000-0xfed19fff]
[    2.428508] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    2.428518] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    2.428527] pnp 00:01: [mem 0xfed45000-0xfed8ffff]
[    2.428537] pnp 00:01: [mem 0xfee00000-0xfee00fff]
[    2.429566] system 00:01: [io  0x164e-0x164f] has been reserved
[    2.429662] system 00:01: [io  0x0600-0x060f] has been reserved
[    2.429763] system 00:01: [io  0x0610] has been reserved
[    2.429855] system 00:01: [io  0x0800-0x080f] has been reserved
[    2.429948] system 00:01: [io  0x0810-0x0817] has been reserved
[    2.430056] system 00:01: [io  0x0820-0x0823] has been reserved
[    2.430149] system 00:01: [io  0x0400-0x047f] has been reserved
[    2.430242] system 00:01: [io  0x0500-0x053f] has been reserved
[    2.430334] system 00:01: [io  0x2000] has been reserved
[    2.430425] system 00:01: [io  0x2004] has been reserved
[    2.430518] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
[    2.430611] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.430704] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    2.430797] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    2.430890] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    2.431002] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    2.431112] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    2.431204] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    2.431306] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    2.431386] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.431587] pnp 00:02: [io  0x0000-0x001f]
[    2.431598] pnp 00:02: [io  0x0081-0x0091]
[    2.431608] pnp 00:02: [io  0x0093-0x009f]
[    2.431618] pnp 00:02: [io  0x00c0-0x00df]
[    2.431629] pnp 00:02: [dma 4]
[    2.432075] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.432487] pnp 00:03: [io  0x0070-0x0077]
[    2.432515] pnp 00:03: [irq 8]
[    2.432963] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.435584] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    2.436043] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.436277] pnp 00:05: [io  0x00f0]
[    2.436297] pnp 00:05: [irq 13]
[    2.436733] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.436966] pnp 00:06: [mem 0xff800000-0xffffffff]
[    2.437441] pnp 00:06: Plug and Play ACPI device, IDs INT0800 (active)
[    2.437857] pnp 00:07: [io  0x0060]
[    2.437867] pnp 00:07: [io  0x0064]
[    2.437887] pnp 00:07: [irq 1]
[    2.438348] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.438754] pnp 00:08: [irq 12]
[    2.439251] pnp 00:08: Plug and Play ACPI device, IDs SNY9001 PNP0f13 (active)
[    2.440514] pnp 00:09: Plug and Play ACPI device, IDs SNY6001 (disabled)
[    2.441173] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    2.441629] pnp 00:0a: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    2.444170] pnp: PnP ACPI: found 11 devices
[    2.444242] ACPI: ACPI bus type pnp unregistered
[    2.480699] pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    2.480880] PCI: max bus depth: 2 pci_try_num: 3
[    2.480997] pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x20000)
[    2.481093] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.481166] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
[    2.481243] pci 0000:00:01.0:   bridge window [mem 0xe2000000-0xe4ffffff]
[    2.481320] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    2.481428] pci 0000:00:1c.0: PCI bridge to [bus 02-05]
[    2.481500] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    2.481578] pci 0000:00:1c.0:   bridge window [mem 0xed900000-0xee8fffff]
[    2.481655] pci 0000:00:1c.0:   bridge window [mem 0xe8800000-0xe97fffff 64bit pref]
[    2.481766] pci 0000:00:1c.1: PCI bridge to [bus 06-06]
[    2.481838] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    2.481916] pci 0000:00:1c.1:   bridge window [mem 0xec800000-0xed8fffff]
[    2.481993] pci 0000:00:1c.1:   bridge window [mem 0xe9800000-0xea7fffff 64bit pref]
[    2.482118] pci 0000:00:1c.3: PCI bridge to [bus 08-08]
[    2.482191] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    2.482270] pci 0000:00:1c.3:   bridge window [mem 0xeb800000-0xec7fffff]
[    2.482349] pci 0000:00:1c.3:   bridge window [mem 0xea800000-0xeb7fffff 64bit pref]
[    2.482505] pci 0000:0b:04.0: BAR 16: assigned [mem 0xf0000000-0xf3ffffff]
[    2.482593] pci 0000:0b:04.0: BAR 15: assigned [mem 0xf4000000-0xf7ffffff pref]
[    2.482707] pci 0000:0b:04.0: BAR 14: assigned [io  0x3000-0x30ff]
[    2.482789] pci 0000:0b:04.0: BAR 13: assigned [io  0x3400-0x34ff]
[    2.482894] pci 0000:0b:04.0: CardBus bridge to [bus 0c-0f]
[    2.482967] pci 0000:0b:04.0:   bridge window [io  0x3400-0x34ff]
[    2.483059] pci 0000:0b:04.0:   bridge window [io  0x3000-0x30ff]
[    2.483138] pci 0000:0b:04.0:   bridge window [mem 0xf4000000-0xf7ffffff pref]
[    2.483246] pci 0000:0b:04.0:   bridge window [mem 0xf0000000-0xf3ffffff]
[    2.483323] pci 0000:00:1e.0: PCI bridge to [bus 0b-0c]
[    2.483397] pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
[    2.483474] pci 0000:00:1e.0:   bridge window [mem 0xe6000000-0xe80fffff]
[    2.483551] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe1ffffff 64bit pref]
[    2.483726] pci 0000:00:1c.0: enabling device (0000 -> 0003)
[    2.483861] pci 0000:00:1c.3: enabling device (0000 -> 0003)
[    2.483986] pci 0000:00:1e.0: setting latency timer to 64
[    2.484071] pci 0000:0b:04.0: setting latency timer to 64
[    2.484077] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.484079] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.484082] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.484085] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfebfffff]
[    2.484087] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    2.484090] pci_bus 0000:01: resource 0 [io  0x7000-0x7fff]
[    2.484093] pci_bus 0000:01: resource 1 [mem 0xe2000000-0xe4ffffff]
[    2.484096] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
[    2.484099] pci_bus 0000:02: resource 0 [io  0x6000-0x6fff]
[    2.484101] pci_bus 0000:02: resource 1 [mem 0xed900000-0xee8fffff]
[    2.484104] pci_bus 0000:02: resource 2 [mem 0xe8800000-0xe97fffff 64bit pref]
[    2.484106] pci_bus 0000:06: resource 0 [io  0x5000-0x5fff]
[    2.484109] pci_bus 0000:06: resource 1 [mem 0xec800000-0xed8fffff]
[    2.484111] pci_bus 0000:06: resource 2 [mem 0xe9800000-0xea7fffff 64bit pref]
[    2.484114] pci_bus 0000:08: resource 0 [io  0x4000-0x4fff]
[    2.484117] pci_bus 0000:08: resource 1 [mem 0xeb800000-0xec7fffff]
[    2.484119] pci_bus 0000:08: resource 2 [mem 0xea800000-0xeb7fffff 64bit pref]
[    2.484122] pci_bus 0000:0b: resource 0 [io  0x3000-0x3fff]
[    2.484125] pci_bus 0000:0b: resource 1 [mem 0xe6000000-0xe80fffff]
[    2.484127] pci_bus 0000:0b: resource 2 [mem 0xe0000000-0xe1ffffff 64bit pref]
[    2.484130] pci_bus 0000:0b: resource 4 [io  0x0000-0x0cf7]
[    2.484132] pci_bus 0000:0b: resource 5 [io  0x0d00-0xffff]
[    2.484135] pci_bus 0000:0b: resource 6 [mem 0x000a0000-0x000bffff]
[    2.484137] pci_bus 0000:0b: resource 7 [mem 0xc0000000-0xfebfffff]
[    2.484140] pci_bus 0000:0b: resource 8 [mem 0xfed40000-0xfed44fff]
[    2.484143] pci_bus 0000:0c: resource 0 [io  0x3400-0x34ff]
[    2.484145] pci_bus 0000:0c: resource 1 [io  0x3000-0x30ff]
[    2.484148] pci_bus 0000:0c: resource 2 [mem 0xf4000000-0xf7ffffff pref]
[    2.484150] pci_bus 0000:0c: resource 3 [mem 0xf0000000-0xf3ffffff]
[    2.485037] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.488360] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.493449] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    2.498282] TCP: Hash tables configured (established 524288 bind 65536)
[    2.498427] TCP reno registered
[    2.498615] UDP hash table entries: 2048 (order: 6, 393216 bytes)
[    2.499094] UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
[    2.500526] pci 0000:00:02.0: Boot video device
[    2.526432] PCI: CLS 64 bytes, default 64
[    2.527204] Unpacking initramfs...
[    3.166686] Freeing initrd memory: 24392k freed
[    3.375510] DMA-API: preallocated 32768 debug entries
[    3.375587] DMA-API: debugging enabled by kernel config
[    3.375689] Simple Boot Flag value 0x5 read from CMOS RAM was invalid
[    3.375762] Simple Boot Flag at 0x44 set to 0x1
[    3.381492] Intel AES-NI instructions are not detected.
[    3.381530] cryptomgr_test used greatest stack depth: 6048 bytes left
[    3.383569] audit: initializing netlink socket (disabled)
[    3.383772] type=2000 audit(1330000815.382:1): initialized
[    3.399046] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.448269] VFS: Disk quotas dquot_6.5.2
[    3.448882] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.457147] msgmni has been set to 5837
[    3.458191] SELinux:  Registering netfilter hooks
[    3.461124] cryptomgr_test used greatest stack depth: 5536 bytes left
[    3.462407] cryptomgr_test used greatest stack depth: 5392 bytes left
[    3.462569] alg: No test for stdrng (krng)
[    3.463249] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.463654] io scheduler noop registered
[    3.463726] io scheduler deadline registered
[    3.464590] io scheduler cfq registered (default)
[    3.465227] start plist test
[    3.466406] end plist test
[    3.466474] list_sort_test: start testing list_sort()
[    3.474977] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    3.475703] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    3.476349] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
[    3.476963] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    3.477860] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.478342] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.478417] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    3.484727] acpiphp: Slot [1] registered
[    3.492270] acpiphp: Slot [4] registered
[    3.494609] intel_idle: MWAIT substates: 0x3122220
[    3.494612] intel_idle: does not run on family 6 model 23
[    3.505056] ACPI: AC Adapter [AC] (on-line)
[    3.505988] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    3.506199] ACPI: Power Button [PWRB]
[    3.507100] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    3.513223] ACPI: Lid Switch [LID0]
[    3.532257] Monitor-Mwait will be used to enter C-1 state
[    3.532514] Monitor-Mwait will be used to enter C-2 state
[    3.532551] Marking TSC unstable due to TSC halts in idle
[    3.532693] ACPI: acpi_idle registered with cpuidle
[    3.632274] thermal LNXTHERM:00: registered as thermal_zone0
[    3.632348] ACPI: Thermal Zone [ATF0] (64 C)
[    3.632672] GHES: HEST is not enabled!
[    3.633504] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.690039] Non-volatile memory driver v1.3
[    3.690112] Linux agpgart interface v0.103
[    3.691450] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    3.691845] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    3.693709] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    3.694643] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    3.696635] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
[    3.737829] ACPI: Battery Slot [BAT0] (battery present)
[    5.781149] tpm_tis 00:0a: Adjusting TPM timeout parameters.
[    6.543118] tpm_tis 00:0a: A TPM error (7) occurred attempting to read a pcr value
[    6.543283] tpm_tis 00:0a: TPM is disabled/deactivated (0x7)
[    6.557221] loop: module loaded
[    6.558578] ahci 0000:00:1f.2: version 3.0
[    6.558886] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    6.559501] ahci: SSS flag set, parallel bus scan disabled
[    6.559609] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    6.559712] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems 
[    6.559819] ahci 0000:00:1f.2: setting latency timer to 64
[    6.578663] scsi0 : ahci
[    6.581291] scsi1 : ahci
[    6.582573] scsi2 : ahci
[    6.583861] scsi3 : ahci
[    6.585331] scsi4 : ahci
[    6.586732] scsi5 : ahci
[    6.612827] ata1: SATA max UDMA/133 abar m2048@0xee925000 port 0xee925100 irq 44
[    6.612930] ata2: SATA max UDMA/133 abar m2048@0xee925000 port 0xee925180 irq 44
[    6.613046] ata3: DUMMY
[    6.613114] ata4: DUMMY
[    6.613183] ata5: SATA max UDMA/133 abar m2048@0xee925000 port 0xee925300 irq 44
[    6.613284] ata6: SATA max UDMA/133 abar m2048@0xee925000 port 0xee925380 irq 44
[    6.615306] Fixed MDIO Bus: probed
[    6.616213] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.616540] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    6.616546] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    6.618391] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    6.618761] ehci_hcd 0000:00:1a.7: debug port 1
[    6.622728] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    6.622988] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xee925c00
[    6.629102] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.629816] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.629892] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.629993] usb usb1: Product: EHCI Host Controller
[    6.630082] usb usb1: Manufacturer: Linux 3.3.0-rc4+ ehci_hcd
[    6.630155] usb usb1: SerialNumber: 0000:00:1a.7
[    6.632398] hub 1-0:1.0: USB hub found
[    6.632688] hub 1-0:1.0: 6 ports detected
[    6.635117] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.635122] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.636021] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    6.636323] ehci_hcd 0000:00:1d.7: debug port 1
[    6.640276] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    6.640523] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xee925800
[    6.646089] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.646711] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    6.646787] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.646888] usb usb2: Product: EHCI Host Controller
[    6.646959] usb usb2: Manufacturer: Linux 3.3.0-rc4+ ehci_hcd
[    6.647048] usb usb2: SerialNumber: 0000:00:1d.7
[    6.648807] hub 2-0:1.0: USB hub found
[    6.649073] hub 2-0:1.0: 6 ports detected
[    6.651185] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.651396] uhci_hcd: USB Universal Host Controller Interface driver
[    6.652004] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.652025] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    6.652894] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    6.653122] uhci_hcd 0000:00:1a.0: irq 23, io base 0x000080e0
[    6.653820] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.653895] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.653996] usb usb3: Product: UHCI Host Controller
[    6.654083] usb usb3: Manufacturer: Linux 3.3.0-rc4+ uhci_hcd
[    6.654155] usb usb3: SerialNumber: 0000:00:1a.0
[    6.655930] hub 3-0:1.0: USB hub found
[    6.656198] hub 3-0:1.0: 2 ports detected
[    6.658005] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    6.658025] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    6.658892] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    6.659110] uhci_hcd 0000:00:1a.1: irq 23, io base 0x000080c0
[    6.659773] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.659848] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.659949] usb usb4: Product: UHCI Host Controller
[    6.660036] usb usb4: Manufacturer: Linux 3.3.0-rc4+ uhci_hcd
[    6.660109] usb usb4: SerialNumber: 0000:00:1a.1
[    6.661845] hub 4-0:1.0: USB hub found
[    6.662120] hub 4-0:1.0: 2 ports detected
[    6.663960] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    6.663965] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    6.664895] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    6.665122] uhci_hcd 0000:00:1a.2: irq 23, io base 0x000080a0
[    6.665806] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    6.665881] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.665982] usb usb5: Product: UHCI Host Controller
[    6.666069] usb usb5: Manufacturer: Linux 3.3.0-rc4+ uhci_hcd
[    6.666142] usb usb5: SerialNumber: 0000:00:1a.2
[    6.667884] hub 5-0:1.0: USB hub found
[    6.668151] hub 5-0:1.0: 2 ports detected
[    6.669962] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.669967] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.670850] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    6.671083] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00008080
[    6.671765] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    6.671840] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.671941] usb usb6: Product: UHCI Host Controller
[    6.672028] usb usb6: Manufacturer: Linux 3.3.0-rc4+ uhci_hcd
[    6.672101] usb usb6: SerialNumber: 0000:00:1d.0
[    6.674171] hub 6-0:1.0: USB hub found
[    6.674404] hub 6-0:1.0: 2 ports detected
[    6.676233] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.676238] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.677139] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    6.677350] uhci_hcd 0000:00:1d.1: irq 20, io base 0x00008060
[    6.678087] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    6.678163] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.678264] usb usb7: Product: UHCI Host Controller
[    6.678335] usb usb7: Manufacturer: Linux 3.3.0-rc4+ uhci_hcd
[    6.678408] usb usb7: SerialNumber: 0000:00:1d.1
[    6.680180] hub 7-0:1.0: USB hub found
[    6.680413] hub 7-0:1.0: 2 ports detected
[    6.682246] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.682251] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.683118] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    6.683319] uhci_hcd 0000:00:1d.2: irq 20, io base 0x00008040
[    6.684006] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    6.684097] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.684199] usb usb8: Product: UHCI Host Controller
[    6.684270] usb usb8: Manufacturer: Linux 3.3.0-rc4+ uhci_hcd
[    6.684343] usb usb8: SerialNumber: 0000:00:1d.2
[    6.686128] hub 8-0:1.0: USB hub found
[    6.686364] hub 8-0:1.0: 2 ports detected
[    6.688858] usbcore: registered new interface driver usbserial
[    6.689181] USB Serial support registered for generic
[    6.689435] usbcore: registered new interface driver usbserial_generic
[    6.689510] usbserial: USB Serial Driver core
[    6.689905] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUE] at 0x60,0x64 irq 1,12
[    6.693086] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.693903] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.694994] mousedev: PS/2 mouse device common for all mice
[    6.697228] rtc_cmos 00:03: RTC can wake from S4
[    6.698485] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    6.698648] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    6.700827] device-mapper: uevent: version 1.0.3
[    6.702289] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    6.703047] cpuidle: using governor ladder
[    6.704550] cpuidle: using governor menu
[    6.707458] EFI Variables Facility v0.08 2004-May-17
[    6.709626] usbcore: registered new interface driver usbhid
[    6.709698] usbhid: USB HID core driver
[    6.711243] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    6.711823] ip_tables: (C) 2000-2006 Netfilter Core Team
[    6.712033] TCP cubic registered
[    6.712104] Initializing XFRM netlink socket
[    6.720513] Mobile IPv6
[    6.720614] Registering the dns_resolver key type
[    6.722386] PM: Hibernation image not present or could not be loaded.
[    6.722530] registered taskstats version 1
[    6.747109] tpm_tis 00:0a: A TPM error (7) occurred attempting to read a pcr value
[    6.747217] IMA: No TPM chip found, activating TPM-bypass!
[    6.755446]   Magic number: 0:109:684
[    6.755589] mem full: hash matches
[    6.755766] rtc_cmos 00:03: setting system clock to 2012-02-23 12:40:19 UTC (1330000819)
[    6.771174] Initializing network drop monitor service
[    6.918178] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.926073] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    6.926831] ata1.00: ATA-8: Hitachi HTS722020K9SA00, DC4OC58P, max UDMA/133
[    6.926945] ata1.00: 390721968 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    6.934885] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    6.935639] ata1.00: configured for UDMA/133
[    6.950579] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS72202 DC4O PQ: 0 ANSI: 5
[    6.956354] sd 0:0:0:0: [sda] 390721968 512-byte logical blocks: (200 GB/186 GiB)
[    6.957382] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.957475] sd 0:0:0:0: [sda] Write Protect is off
[    6.957550] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.957971] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.980117]  sda: sda1 sda2
[    6.984618] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.038205] usb 1-2: new high-speed USB device number 3 using ehci_hcd
[    7.157689] usb 1-2: New USB device found, idVendor=05ca, idProduct=18b0
[    7.157804] usb 1-2: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[    7.157916] usb 1-2: Manufacturer: Ricoh co. Ltd.
[    7.387489] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input3
[    7.409245] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input4
[    7.477284] usb 3-1: new full-speed USB device number 2 using uhci_hcd
[    7.640545] usb 3-1: New USB device found, idVendor=147e, idProduct=1000
[    7.640659] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.640770] usb 3-1: Product: Fingerprint Sensor   
[    7.640872] usb 3-1: Manufacturer: TouchStrip        
[    7.858281] usb 8-2: new full-speed USB device number 2 using uhci_hcd
[    8.013718] usb 8-2: New USB device found, idVendor=044e, idProduct=3017
[    8.013831] usb 8-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    8.013941] usb 8-2: Product: BCM2046 Bluetooth Device
[    8.014148] usb 8-2: Manufacturer: Broadcom Corp
[    8.014250] usb 8-2: SerialNumber: 001E3DF70F2C
[   12.312175] ata2: link is slow to respond, please be patient (ready=0)
[   17.004157] ata2: COMRESET failed (errno=-16)
[   17.309187] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   17.326634] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[   17.326755] ata2.00: ATAPI: MATSHITADVD-RAM UJ862AS, 1.21, max UDMA/33
[   17.335847] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[   17.335968] ata2.00: configured for UDMA/33
[   17.340519] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AS  1.21 PQ: 0 ANSI: 5
[   17.344266] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   17.344384] cdrom: Uniform CD-ROM driver Revision: 3.20
[   17.352393] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   17.354982] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   17.661173] ata5: SATA link down (SStatus 0 SControl 300)
[   17.966178] ata6: SATA link down (SStatus 0 SControl 300)
[   17.977273] Freeing unused kernel memory: 2808k freed
[   17.978667] Write protecting the kernel read-only data: 12288k
[   17.983522] Freeing unused kernel memory: 1348k freed
[   17.989062] Freeing unused kernel memory: 1364k freed
[   17.999350] mknod used greatest stack depth: 4936 bytes left
[   18.016223] mount used greatest stack depth: 4760 bytes left
[   18.182912] dracut: dracut-009-12.fc15
[   18.269166] udev[121]: starting version 167
[   18.269266] udevd used greatest stack depth: 4696 bytes left
[   18.467536] wmi: Mapper loaded
[   18.580565] [drm] Initialized drm 1.1.0 20060810
[   18.683938] console_init used greatest stack depth: 4584 bytes left
[   18.750468] i915 0000:00:02.0: power state changed by ACPI to D0
[   18.750593] i915 0000:00:02.0: power state changed by ACPI to D0
[   18.750693] i915 0000:00:02.0: setting latency timer to 64
[   18.794592] MXM: GUID detected in BIOS
[   18.804081] VGA switcheroo: detected DSM switching method \_SB_.PCI0.PEGP.DGPU handle
[   18.804186] VGA switcheroo: detected Optimus DSM method \_SB_.PCI0.PEGP.DGPU handle
[   18.804556] nouveau 0000:01:00.0: power state changed by ACPI to D0
[   18.804669] nouveau 0000:01:00.0: power state changed by ACPI to D0
[   18.804761] nouveau 0000:01:00.0: enabling device (0000 -> 0003)
[   18.907303] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[   18.907593] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   18.907670] [drm] Driver supports precise vblank timestamp query.
[   18.910947] [drm:intel_dsm_pci_probe] *ERROR* failed to get supported _DSM functions
[   18.914810] [drm:intel_dsm_pci_probe] *ERROR* failed to get supported _DSM functions
[   18.915573] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   18.915732] vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
[   19.474432] fbcon: inteldrmfb (fb0) is primary device
[   19.478064] [drm] Changing LVDS panel from (+hsync, +vsync) to (-hsync, -vsync)
[   19.996513] Console: switching to colour frame buffer device 170x48
[   20.004965] fb0: inteldrmfb frame buffer device
[   20.004990] drm: registered panic notifier
[   20.076301] acpi device:01: registered as cooling_device2
[   20.085499] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input5
[   20.087187] ACPI: Video Device [OVGA] (multi-head: yes  rom: no  post: no)
[   20.099609] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:06/LNXVIDEO:01/input/input6
[   20.101171] ACPI: Video Device [DGPU] (multi-head: yes  rom: yes  post: no)
[   20.102645] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   20.111837] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x298280a2)
[   20.117866] modprobe used greatest stack depth: 2248 bytes left
[   20.128689] vga_switcheroo: enabled
[   20.128931] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[   20.128983] [drm] nouveau 0000:01:00.0: ... BIOS signature not found
[   20.129056] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PROM
[   20.129112] [drm] nouveau 0000:01:00.0: ... BIOS signature not found
[   20.129148] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PCIROM
[   20.129188] [drm] nouveau 0000:01:00.0: ... BIOS signature not found
[   20.129224] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from ACPI
[   48.455481] dracut: 
[   48.455759] dracut: udevadm settle - timeout of 30 seconds reached, the event queue contains:
[   48.456026] dracut: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0 (903)
[   48.456299] dracut: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/controlD65 (1043)
[   48.457324] dracut: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1 (1044)
[   48.469278] dracut: Starting plymouth daemon
[   56.965409] yenta_cardbus 0000:0b:04.0: CardBus bridge found [104d:9025]
[   57.004840] sdhci: Secure Digital Host Controller Interface driver
[   57.009031] sdhci: Copyright(c) Pierre Ossman
[   57.091004] yenta_cardbus 0000:0b:04.0: ISA IRQ mask 0x00b8, PCI irq 20
[   57.091940] yenta_cardbus 0000:0b:04.0: Socket status: 30000006
[   57.092850] pci_bus 0000:0b: Raising subordinate bus# of parent bus (#0b) from #0c to #0f
[   57.094101] yenta_cardbus 0000:0b:04.0: pcmcia: parent PCI bridge window: [io  0x3000-0x3fff]
[   57.095100] yenta_cardbus 0000:0b:04.0: pcmcia: parent PCI bridge window: [mem 0xe6000000-0xe80fffff]
[   57.096109] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe6000000-0xe80fffff: excluding 0xe7ef0000-0xe80fffff
[   57.103096] yenta_cardbus 0000:0b:04.0: pcmcia: parent PCI bridge window: [mem 0xe0000000-0xe1ffffff 64bit pref]
[   57.105229] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe0000000-0xe1ffffff: excluding 0xe0000000-0xe1ffffff
[   57.124224] sdhci-pci 0000:0b:04.2: SDHCI controller found [1180:0822] (rev 21)
[   57.126181] sdhci-pci 0000:0b:04.2: Will use DMA mode even though HW doesn't fully claim to support it.
[   57.127380] sdhci-pci 0000:0b:04.2: setting latency timer to 64
[   57.129790] Registered led device: mmc0::
[   57.133415] mmc0: SDHCI controller on PCI [0000:0b:04.2] using DMA
[   57.134860] firewire_ohci 0000:0b:04.1: setting latency timer to 64
[   57.188732] firewire_ohci: Added fw-ohci device 0000:0b:04.1, OHCI v1.0, 4 IR + 4 IT contexts, quirks 0x11
[   57.690635] firewire_core: created device fw0: GUID 0800460302af3026, S400
[  236.708356] dracut: Scanning devices sda2  for LVM logical volumes vg_vaio/lv_root vg_vaio/lv_swap
[  236.757105] dracut: inactive '/dev/vg_vaio/lv_swap' [4.88 GiB] inherit
[  236.758728] dracut: inactive '/dev/vg_vaio/lv_home' [130.94 GiB] inherit
[  236.760217] dracut: inactive '/dev/vg_vaio/lv_root' [50.00 GiB] inherit
[  237.597724] EXT4-fs (dm-1): INFO: recovery required on readonly filesystem
[  237.599025] EXT4-fs (dm-1): write access will be enabled during recovery
[  238.434214] EXT4-fs (dm-1): recovery complete
[  238.436994] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[  238.553635] dracut: Checking filesystems
[  238.555292] dracut: fsck -T -t noopts=_netdev -A -a
[  238.808887] dracut: /dev/mapper/vg_vaio-lv_root: Superblock last mount time is in the future. (by less than a day, probably due to the hardware clock being incorrectly set) FIXED. /dev/mapper/vg_vaio-lv_root: clean, 192535/3276800 files, 2673298/13107200 blocks
[  238.813315] dracut: Remounting /dev/mapper/vg_vaio-lv_root with -o ro,
[  238.834817] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[  238.862272] dracut: Mounted root filesystem /dev/mapper/vg_vaio-lv_root
[  239.192582] dracut: Switching root
[  239.785764] type=1404 audit(1330001052.529:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[  240.337058] SELinux: 2048 avtab hash slots, 227352 rules.
[  243.134375] SELinux: 2048 avtab hash slots, 227352 rules.
[  245.461638] [drm] nouveau 0000:01:00.0: ... BIOS checksum invalid
[  245.463077] [drm] nouveau 0000:01:00.0: Using BIOS image from ACPI
[  251.607069] SELinux:  9 users, 13 roles, 3672 types, 195 bools, 1 sens, 1024 cats
[  251.607075] SELinux:  81 classes, 227352 rules
[  251.868801] SELinux:  Completing initialization.
[  251.868806] SELinux:  Setting up existing superblocks.
[  251.869041] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[  251.869171] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[  251.869327] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[  251.869410] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[  251.869648] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[  251.869835] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[  251.872414] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[  251.872525] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[  251.885158] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[  251.885305] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[  251.885401] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[  251.885596] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[  251.885733] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[  251.885845] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[  251.886087] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[  251.886228] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[  251.886314] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[  251.892317] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[  251.892360] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[  251.893956] SELinux: initialized (dev dm-1, type ext4), uses xattr
[  251.972154] type=1403 audit(1330001064.715:3): policy loaded auid=4294967295 ses=4294967295
[  252.563921] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[  252.704977] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[  253.138068] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[  253.454666] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[  253.704625] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[  253.955044] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[  254.204521] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[  254.454550] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[  254.704578] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[  254.955414] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[  255.204426] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[  255.564285] systemd[1]: systemd 26 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)
[  255.602530] systemd[1]: Set hostname to <vaio>.
[  256.889121] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[  256.893725] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[  256.900087] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[  256.945820] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[  256.948551] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[  262.459587] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[  262.816094] EXT4-fs (dm-1): re-mounted. Opts: (null)
[  263.094382] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[  263.593482] udev[406]: starting version 167
[  284.302552] sony_laptop: Sony Programmable IO Control Driver v0.6
[  284.366263] sony_laptop: detected Type3 model
[  284.859769] WARNING! power/level is deprecated; use power/control instead
[  284.985647] iTCO_vendor_support: vendor-support=0
[  285.091435] udevd-work[423]: error opening ATTR{/sys/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/power/level} for writing: No such file or directory
[  285.234939] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[  285.332984] ACPI Warning: 
[  285.335294] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[  285.362456] input: PC Speaker as /devices/platform/pcspkr/input/input7
[  285.371766] 0x0000000000008000-0x000000000000801f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120111/utaddress-251)
[  285.417399] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[  285.443765] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[  285.500121] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[  285.575799] e1000e 0000:00:19.0: setting latency timer to 64
[  285.579219] microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
[  285.597070] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[  285.850917] Linux media interface: v0.10
[  285.857455] r592 0000:0b:04.4: setting latency timer to 64
[  285.924081] r592: driver successfully loaded
[  286.313366] cfg80211: Calling CRDA to update world regulatory domain
[  286.447503] Linux video capture interface: v2.00
[  286.723873] Bluetooth: Core ver 2.16
[  286.849273] Bluetooth: HCI device and connection manager initialized
[  286.949193] Bluetooth: HCI socket layer initialized
[  286.950272] Bluetooth: L2CAP socket layer initialized
[  287.074203] Bluetooth: SCO socket layer initialized
[  287.368820] usbcore: registered new interface driver btusb
[  287.389882] uvcvideo: Found UVC 1.00 device <unnamed> (05ca:18b0)
[  287.555021] microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
[  287.564846] input: UVC Camera (05ca:18b0) as /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2:1.0/input/input8
[  287.586317] microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
[  287.587772] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1a:80:d6:73:22
[  287.604197] usbcore: registered new interface driver uvcvideo
[  287.606659] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[  287.619856] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: FFFFFF-0FF
[  287.623241] USB Video Class driver (1.1.1)
[  287.736082] microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
[  287.786326] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[  287.838961] cfg80211: World regulatory domain updated:
[  287.850926] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  287.889632] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  287.916471] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  287.917934] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  287.926928] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  287.928315] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  288.336352] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[  288.373868] Adding 5111804k swap on /dev/mapper/vg_vaio-lv_swap.  Priority:0 extents:1 across:5111804k 
[  288.404203] udev[421]: renamed network interface eth0 to em1
[  288.521187] hda_codec: ALC262: SKU not ready 0x411111f0
[  288.522933] ALSA sound/pci/hda/hda_codec.c:4923 autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[  288.522938] ALSA sound/pci/hda/hda_codec.c:4927    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[  288.522941] ALSA sound/pci/hda/hda_codec.c:4931    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[  288.522944] ALSA sound/pci/hda/hda_codec.c:4932    mono: mono_out=0x0
[  288.522946] ALSA sound/pci/hda/hda_codec.c:4935    dig-out=0x1e/0x0
[  288.522949] ALSA sound/pci/hda/hda_codec.c:4936    inputs:
[  288.522952] ALSA sound/pci/hda/hda_codec.c:4940  Internal Mic=0x12
[  288.522955] ALSA sound/pci/hda/hda_codec.c:4940  Mic=0x18
[  288.522957] ALSA sound/pci/hda/hda_codec.c:4942 
[  288.528929] ALSA sound/pci/hda/patch_realtek.c:1314 realtek: No valid SSID, checking pincfg 0x411111f0 for NID 0x1d
[  288.528933] ALSA sound/pci/hda/patch_realtek.c:1397 realtek: Enable default setup for auto mode as fallback
[  288.597903] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[  288.602054] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[  288.746362] systemd-fsck[611]: /dev/sda1: recovering journal
[  288.894351] systemd-fsck[611]: /dev/sda1: clean, 65/128016 files, 175331/512000 blocks
[  289.123215] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[  289.137237] SELinux: initialized (dev sda1, type ext4), uses xattr
[  289.450388] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[  289.451954] Copyright(c) 2003-2011 Intel Corporation
[  289.454071] iwlwifi 0000:06:00.0: pci_resource_len = 0x00002000
[  289.455572] iwlwifi 0000:06:00.0: pci_resource_base = ffffc9000560c000
[  289.457013] iwlwifi 0000:06:00.0: HW Revision ID = 0x0
[  289.458976] iwlwifi 0000:06:00.0: irq 48 for MSI/MSI-X
[  289.459451] iwlwifi 0000:06:00.0: CONFIG_IWLWIFI_DEBUG enabled
[  289.460843] iwlwifi 0000:06:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
[  289.462216] iwlwifi 0000:06:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[  289.463581] iwlwifi 0000:06:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
[  289.464938] iwlwifi 0000:06:00.0: CONFIG_IWLWIFI_P2P disabled
[  289.466301] iwlwifi 0000:06:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[  289.468169] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[  289.492636] iwlwifi 0000:06:00.0: device EEPROM VER=0x11f, CALIB=0x4
[  289.493991] iwlwifi 0000:06:00.0: Device SKU: 0xF0
[  289.495389] iwlwifi 0000:06:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[  289.522088] iwlwifi 0000:06:00.0: loaded firmware version 8.83.5.1 build 33692
[  289.524128] Registered led device: phy0-led
[  289.590505] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[  289.705689] cfg80211: Calling CRDA for country: US
[  289.732269] cfg80211: Regulatory domain changed to country: US
[  289.733630] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  289.734965] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  289.736336] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[  289.737647] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  289.738918] cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  289.740167] cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  289.741397] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[  341.035878] input: Sony Vaio Keys as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0d/SNY6001:00/input/input11
[  341.043307] input: Sony Vaio Jogdial as /devices/virtual/input/input12
[  341.059000] sony_laptop: device allocated minor is 58
[  346.552430] systemd[1]: Job dev-mapper-vg_vaio\x2dlv_home.device/start timed out.
[  346.552481] systemd[1]: Job fedora-autorelabel-mark.service/start failed with result 'dependency'.
[  346.552529] systemd[1]: Job fedora-autorelabel.service/start failed with result 'dependency'.
[  346.552577] systemd[1]: Job local-fs.target/start failed with result 'dependency'.
[  346.552626] systemd[1]: Triggering OnFailure= dependencies of local-fs.target.
[  346.552674] systemd[1]: Job remote-fs.target/start failed with result 'dependency'.
[  346.556945] systemd[1]: Job home.mount/start failed with result 'dependency'.
[  346.557102] systemd[1]: Job dev-mapper-vg_vaio\x2dlv_home.device/start failed with result 'timeout'.
[  436.750717] systemd[1]: udev.service stopping timed out (2). Killing.
[  462.413372] sony_laptop: Sony Notebook Control Driver v0.6
[  526.751860] systemd[1]: udev.service still around after SIGKILL (2). Entering failed mode.
[  526.753054] systemd[1]: Unit udev.service entered failed state.
[  526.759301] systemd[1]: Startup finished in 18s 21ms 666us (kernel) + 3min 57s 623ms 250us (initrd) + 4min 31s 113ms 934us (userspace) = 8min 46s 758ms 850us.
[ 1126.872549] [drm] nouveau 0000:01:00.0: BIT BIOS found
[ 1126.873191] [drm] nouveau 0000:01:00.0: Bios version 62.98.3c.00
[ 1126.873818] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[ 1126.919197] [drm] nouveau 0000:01:00.0: MXM: no VBIOS data, nothing to do
[ 1126.919851] [drm] nouveau 0000:01:00.0: DCB version 4.0
[ 1126.920526] [drm] nouveau 0000:01:00.0: DCB outp 00: 010001f3 00010015
[ 1126.921221] [drm] nouveau 0000:01:00.0: DCB outp 01: 02011200 00000028
[ 1126.921896] [drm] nouveau 0000:01:00.0: DCB outp 02: 04022232 00000010
[ 1126.922594] [drm] nouveau 0000:01:00.0: DCB outp 03: 02033242 00020010
[ 1126.923299] [drm] nouveau 0000:01:00.0: DCB conn 00: 00000040
[ 1126.923991] [drm] nouveau 0000:01:00.0: DCB conn 01: 00000100
[ 1126.924708] [drm] nouveau 0000:01:00.0: DCB conn 02: 00000231
[ 1126.925420] [drm] nouveau 0000:01:00.0: DCB conn 03: 00002361
[ 1126.926143] [drm] nouveau 0000:01:00.0: Adaptor not initialised, running VBIOS init tables.
[ 1126.926861] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xD751
[ 1126.953354] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xDB03
[ 1126.961030] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xE2C9
[ 1126.961795] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xE3BB
[ 1126.963650] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xE5C7
[ 1126.964391] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xE62C
[ 1126.985382] [drm] nouveau 0000:01:00.0: BIOS FP mode: 1600x900 (99930kHz pixel clock)
[ 1126.987276] [drm] nouveau 0000:01:00.0: 4 available performance level(s)
[ 1126.988061] [drm] nouveau 0000:01:00.0: 0: core 169MHz shader 338MHz memory 100MHz timing 4 voltage 900mV fanspeed 100%
[ 1126.988853] [drm] nouveau 0000:01:00.0: 1: core 275MHz shader 550MHz memory 301MHz timing 1 voltage 900mV fanspeed 100%
[ 1126.989654] [drm] nouveau 0000:01:00.0: 2: core 500MHz shader 1000MHz memory 450MHz timing 2 voltage 1090mV fanspeed 100%
[ 1126.990468] [drm] nouveau 0000:01:00.0: 3: core 580MHz shader 1450MHz memory 702MHz timing 3 voltage 1170mV fanspeed 100%
[ 1126.991365] [drm] nouveau 0000:01:00.0: c: core 275MHz shader 550MHz memory 300MHz voltage 900mV
[ 1127.021916] [TTM] Zone  kernel: Available graphics memory: 1497074 kiB.
[ 1127.022779] [TTM] Initializing pool allocator.
[ 1127.024897] [TTM] Initializing DMA pool allocator.
[ 1127.027987] [drm] nouveau 0000:01:00.0: Detected 128MiB VRAM
[ 1127.030865] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[ 1127.112578] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[ 1127.113485] [drm] No driver support for vblank timestamp query.
[ 1127.114441] [drm] nouveau 0000:01:00.0: ACPI backlight interface available, not registering our own
[ 1127.441154] sony_laptop: brightness ignored, must be controlled by ACPI video driver
[ 1127.587167] [drm] nouveau 0000:01:00.0: allocated 1600x900 fb: 0x310000, bo ffff8800aeb93a18
[ 1127.595407] fb1: nouveaufb frame buffer device
[ 1127.596511] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 1
[ 1203.762747] 
[ 1203.762762] ------------[ cut here ]------------
[ 1203.762771] WARNING: at include/linux/rcupdate.h:242 __atomic_notifier_call_chain+0xd7/0x110()
[ 1203.762773] Hardware name: VGN-Z540N
[ 1203.762774] Modules linked in: cpufreq_stats arc4 iwlwifi mac80211 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm uvcvideo btusb videobuf2_core bluetooth videodev snd_timer media cfg80211 r592 v4l2_compat_ioctl32 microcode videobuf2_vmalloc joydev memstick snd videobuf2_memops e1000e i2c_i801 pcspkr iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc sony_laptop tpm_infineon rfkill firewire_ohci firewire_core sdhci_pci sdhci crc_itu_t mmc_core yenta_socket nouveau i915 ttm drm_kms_helper drm mxm_wmi i2c_algo_bit i2c_core wmi video
[ 1203.762828] Pid: 0, comm: swapper/1 Not tainted 3.3.0-rc4+ #1
[ 1203.762830] Call Trace:
[ 1203.762835]  [<ffffffff8106428f>] warn_slowpath_common+0x7f/0xc0
[ 1203.762838]  [<ffffffff810642ea>] warn_slowpath_null+0x1a/0x20
[ 1203.762841]  [<ffffffff816a1e47>] __atomic_notifier_call_chain+0xd7/0x110
[ 1203.762849]  [<ffffffff81372b64>] ? fbcon_cursor+0x124/0x1b0
[ 1203.762851]  [<ffffffff81376640>] ? bit_update_start+0x60/0x60
[ 1203.762854]  [<ffffffff816a1e96>] atomic_notifier_call_chain+0x16/0x20
[ 1203.762860]  [<ffffffff813e90b9>] notify_write+0x29/0x30
[ 1203.762863]  [<ffffffff813e9e28>] vt_console_print+0x178/0x3c0
[ 1203.762866]  [<ffffffff810646c9>] __call_console_drivers+0x89/0xb0
[ 1203.762869]  [<ffffffff81064919>] _call_console_drivers+0x49/0x70
[ 1203.762872]  [<ffffffff81064a54>] console_unlock+0x114/0x290
[ 1203.762874]  [<ffffffff81064e1e>] vprintk+0x24e/0x600
[ 1203.762880]  [<ffffffff810a6868>] ? sched_clock_cpu+0xb8/0x130
[ 1203.762884]  [<ffffffff81691ce0>] printk+0x51/0x53
[ 1203.762892]  [<ffffffff810cc6d3>] lockdep_rcu_suspicious+0x53/0x100
[ 1203.762899]  [<ffffffff81518286>] cpuidle_idle_call+0x566/0x620
[ 1203.762905]  [<ffffffff81019235>] cpu_idle+0xd5/0x140
[ 1203.762910]  [<ffffffff816873be>] start_secondary+0x294/0x29b
[ 1203.762913] ---[ end trace ce6975b4869f849e ]---
[ 1203.762915] ------------[ cut here ]------------
[ 1203.762917] WARNING: at include/linux/rcupdate.h:248 __atomic_notifier_call_chain+0xfd/0x110()
[ 1203.762919] Hardware name: VGN-Z540N
[ 1203.762920] Modules linked in: cpufreq_stats arc4 iwlwifi mac80211 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm uvcvideo btusb videobuf2_core bluetooth videodev snd_timer media cfg80211 r592 v4l2_compat_ioctl32 microcode videobuf2_vmalloc joydev memstick snd videobuf2_memops e1000e i2c_i801 pcspkr iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc sony_laptop tpm_infineon rfkill firewire_ohci firewire_core sdhci_pci sdhci crc_itu_t mmc_core yenta_socket nouveau i915 ttm drm_kms_helper drm mxm_wmi i2c_algo_bit i2c_core wmi video
[ 1203.762948] Pid: 0, comm: swapper/1 Tainted: G        W    3.3.0-rc4+ #1
[ 1203.762950] Call Trace:
[ 1203.762952]  [<ffffffff8106428f>] warn_slowpath_common+0x7f/0xc0
[ 1203.762955]  [<ffffffff810642ea>] warn_slowpath_null+0x1a/0x20
[ 1203.762958]  [<ffffffff816a1e6d>] __atomic_notifier_call_chain+0xfd/0x110
[ 1203.762960]  [<ffffffff816a1dae>] ? __atomic_notifier_call_chain+0x3e/0x110
[ 1203.762963]  [<ffffffff81372b64>] ? fbcon_cursor+0x124/0x1b0
[ 1203.762966]  [<ffffffff81376640>] ? bit_update_start+0x60/0x60
[ 1203.762968]  [<ffffffff816a1e96>] atomic_notifier_call_chain+0x16/0x20
[ 1203.762971]  [<ffffffff813e90b9>] notify_write+0x29/0x30
[ 1203.762973]  [<ffffffff813e9e28>] vt_console_print+0x178/0x3c0
[ 1203.762976]  [<ffffffff810646c9>] __call_console_drivers+0x89/0xb0
[ 1203.762979]  [<ffffffff81064919>] _call_console_drivers+0x49/0x70
[ 1203.762982]  [<ffffffff81064a54>] console_unlock+0x114/0x290
[ 1203.762985]  [<ffffffff81064e1e>] vprintk+0x24e/0x600
[ 1203.762988]  [<ffffffff810a6868>] ? sched_clock_cpu+0xb8/0x130
[ 1203.762991]  [<ffffffff81691ce0>] printk+0x51/0x53
[ 1203.762994]  [<ffffffff810cc6d3>] lockdep_rcu_suspicious+0x53/0x100
[ 1203.762997]  [<ffffffff81518286>] cpuidle_idle_call+0x566/0x620
[ 1203.763000]  [<ffffffff81019235>] cpu_idle+0xd5/0x140
[ 1203.763002]  [<ffffffff816873be>] start_secondary+0x294/0x29b
[ 1203.763005] ---[ end trace ce6975b4869f849f ]---
[ 1203.763720] ===============================
[ 1203.763720] [ INFO: suspicious RCU usage. ]
[ 1203.763720] 3.3.0-rc4+ #1 Tainted: G        W   
[ 1203.763720] -------------------------------
[ 1203.763720] include/trace/events/power.h:102 suspicious rcu_dereference_check() usage!
[ 1203.763720] 
[ 1203.763720] other info that might help us debug this:
[ 1203.763720] 
[ 1203.763720] 
[ 1203.763720] rcu_scheduler_active = 1, debug_locks = 0
[ 1203.763720] RCU used illegally from extended quiescent state!
[ 1203.763720] no locks held by swapper/1/0.
[ 1203.763720] 
[ 1203.763720] stack backtrace:
[ 1203.763720] Pid: 0, comm: swapper/1 Tainted: G        W    3.3.0-rc4+ #1
[ 1203.763720] Call Trace:
[ 1203.763720]  [<ffffffff810cc765>] lockdep_rcu_suspicious+0xe5/0x100
[ 1203.763720]  [<ffffffff81518286>] cpuidle_idle_call+0x566/0x620
[ 1203.763720]  [<ffffffff81019235>] cpu_idle+0xd5/0x140
[ 1203.763720]  [<ffffffff816873be>] start_secondary+0x294/0x29b
[ 1203.846262] ------------[ cut here ]------------
[ 1203.847256] WARNING: at include/linux/rcupdate.h:242 rcu_lock_acquire+0x58/0x70()
[ 1203.847256] Hardware name: VGN-Z540N
[ 1203.847256] Modules linked in: cpufreq_stats arc4 iwlwifi mac80211 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm uvcvideo btusb videobuf2_core bluetooth videodev snd_timer media cfg80211 r592 v4l2_compat_ioctl32 microcode videobuf2_vmalloc joydev memstick snd videobuf2_memops e1000e i2c_i801 pcspkr iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc sony_laptop tpm_infineon rfkill firewire_ohci firewire_core sdhci_pci sdhci crc_itu_t mmc_core yenta_socket nouveau i915 ttm drm_kms_helper drm mxm_wmi i2c_algo_bit i2c_core wmi video
[ 1203.847256] Pid: 0, comm: swapper/1 Tainted: G        W    3.3.0-rc4+ #1
[ 1203.847256] Call Trace:
[ 1203.847256]  [<ffffffff8106428f>] warn_slowpath_common+0x7f/0xc0
[ 1203.847256]  [<ffffffff810642ea>] warn_slowpath_null+0x1a/0x20
[ 1203.847256]  [<ffffffff81142dd8>] rcu_lock_acquire+0x58/0x70
[ 1203.847256]  [<ffffffff816873be>] ? start_secondary+0x294/0x29b
[ 1203.847256]  [<ffffffff8114aae1>] __perf_event_overflow+0x141/0x290
[ 1203.847256]  [<ffffffff810c8081>] ? tick_broadcast_oneshot_control+0x81/0x130
[ 1203.847256]  [<ffffffff8114acd9>] perf_swevent_overflow+0xa9/0xc0
[ 1203.847256]  [<ffffffff8114ad5f>] perf_swevent_event+0x6f/0x90
[ 1203.847256]  [<ffffffff8114adf6>] perf_tp_event+0x76/0xf0
[ 1203.847256]  [<ffffffff8169dd8a>] ? _raw_spin_unlock_irqrestore+0x4a/0x90
[ 1203.847256]  [<ffffffff811414e2>] perf_trace_power+0xd2/0xf0
[ 1203.847256]  [<ffffffff8151806d>] ? cpuidle_idle_call+0x34d/0x620
[ 1203.847256]  [<ffffffff8151806d>] cpuidle_idle_call+0x34d/0x620
[ 1203.847256]  [<ffffffff816a1dae>] ? __atomic_notifier_call_chain+0x3e/0x110
[ 1203.847256]  [<ffffffff81019235>] cpu_idle+0xd5/0x140
[ 1203.847256]  [<ffffffff816873be>] start_secondary+0x294/0x29b
[ 1203.847256] ---[ end trace ce6975b4869f84a0 ]---
[ 1203.847256] ------------[ cut here ]------------
[ 1203.847256] WARNING: at include/linux/rcupdate.h:242 perf_output_begin+0x326/0x360()
[ 1203.847256] Hardware name: VGN-Z540N
[ 1203.847256] Modules linked in: cpufreq_stats arc4 iwlwifi mac80211 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm uvcvideo btusb videobuf2_core bluetooth videodev snd_timer media cfg80211 r592 v4l2_compat_ioctl32 microcode videobuf2_vmalloc joydev memstick snd videobuf2_memops e1000e i2c_i801 pcspkr iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc sony_laptop tpm_infineon rfkill firewire_ohci firewire_core sdhci_pci sdhci crc_itu_t mmc_core yenta_socket nouveau i915 ttm drm_kms_helper drm mxm_wmi i2c_algo_bit i2c_core wmi video
[ 1203.847256] Pid: 0, comm: swapper/1 Tainted: G        W    3.3.0-rc4+ #1
[ 1203.847256] Call Trace:
[ 1203.847256]  [<ffffffff8106428f>] warn_slowpath_common+0x7f/0xc0
[ 1203.847256]  [<ffffffff810642ea>] warn_slowpath_null+0x1a/0x20
[ 1203.847256]  [<ffffffff8114e1e6>] perf_output_begin+0x326/0x360
[ 1203.847256]  [<ffffffff810a6868>] ? sched_clock_cpu+0xb8/0x130
[ 1203.847256]  [<ffffffff810cad6d>] ? trace_hardirqs_off+0xd/0x10
[ 1203.847256]  [<ffffffff810a694f>] ? local_clock+0x6f/0x80
[ 1203.847256]  [<ffffffff811434cd>] ? __perf_event_header__init_id+0xad/0xf0
[ 1203.847256]  [<ffffffff8114a8f3>] ? perf_prepare_sample+0x63/0x110
[ 1203.847256]  [<ffffffff8114ab03>] __perf_event_overflow+0x163/0x290
[ 1203.847256]  [<ffffffff810c8081>] ? tick_broadcast_oneshot_control+0x81/0x130
[ 1203.847256]  [<ffffffff8114acd9>] perf_swevent_overflow+0xa9/0xc0
[ 1203.847256]  [<ffffffff8114ad5f>] perf_swevent_event+0x6f/0x90
[ 1203.847256]  [<ffffffff8114adf6>] perf_tp_event+0x76/0xf0
[ 1203.847256]  [<ffffffff811414e2>] perf_trace_power+0xd2/0xf0
[ 1203.847256]  [<ffffffff8151806d>] ? cpuidle_idle_call+0x34d/0x620
[ 1203.847256]  [<ffffffff8151806d>] cpuidle_idle_call+0x34d/0x620
[ 1203.847256]  [<ffffffff816a1dae>] ? __atomic_notifier_call_chain+0x3e/0x110
[ 1203.847256]  [<ffffffff81019235>] cpu_idle+0xd5/0x140
[ 1203.847256]  [<ffffffff816873be>] start_secondary+0x294/0x29b
[ 1203.847256] ---[ end trace ce6975b4869f84a1 ]---
[ 1203.847256] ------------[ cut here ]------------
[ 1203.847256] WARNING: at include/linux/rcupdate.h:248 perf_output_end+0x50/0x60()
[ 1203.847256] Hardware name: VGN-Z540N
[ 1203.847256] Modules linked in: cpufreq_stats arc4 iwlwifi mac80211 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm uvcvideo btusb videobuf2_core bluetooth videodev snd_timer media cfg80211 r592 v4l2_compat_ioctl32 microcode videobuf2_vmalloc joydev memstick snd videobuf2_memops e1000e i2c_i801 pcspkr iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc sony_laptop tpm_infineon rfkill firewire_ohci firewire_core sdhci_pci sdhci crc_itu_t mmc_core yenta_socket nouveau i915 ttm drm_kms_helper drm mxm_wmi i2c_algo_bit i2c_core wmi video
[ 1203.847256] Pid: 0, comm: swapper/1 Tainted: G        W    3.3.0-rc4+ #1
[ 1203.847256] Call Trace:
[ 1203.847256]  [<ffffffff8106428f>] warn_slowpath_common+0x7f/0xc0
[ 1203.847256]  [<ffffffff810642ea>] warn_slowpath_null+0x1a/0x20
[ 1203.847256]  [<ffffffff8114e270>] perf_output_end+0x50/0x60
[ 1203.847256]  [<ffffffff8114abbc>] __perf_event_overflow+0x21c/0x290
[ 1203.847256]  [<ffffffff8114acd9>] perf_swevent_overflow+0xa9/0xc0
[ 1203.847256]  [<ffffffff8114ad5f>] perf_swevent_event+0x6f/0x90
[ 1203.847256]  [<ffffffff8114adf6>] perf_tp_event+0x76/0xf0
[ 1203.847256]  [<ffffffff811414e2>] perf_trace_power+0xd2/0xf0
[ 1203.847256]  [<ffffffff8151806d>] ? cpuidle_idle_call+0x34d/0x620
[ 1203.847256]  [<ffffffff8151806d>] cpuidle_idle_call+0x34d/0x620
[ 1203.847256]  [<ffffffff816a1dae>] ? __atomic_notifier_call_chain+0x3e/0x110
[ 1203.847256]  [<ffffffff81019235>] cpu_idle+0xd5/0x140
[ 1203.847256]  [<ffffffff816873be>] start_secondary+0x294/0x29b
[ 1203.847256] ---[ end trace ce6975b4869f84a2 ]---
[ 1203.847256] ------------[ cut here ]------------
[ 1203.847256] WARNING: at include/linux/rcupdate.h:248 __perf_event_overflow+0x27c/0x290()
[ 1203.847256] Hardware name: VGN-Z540N
[ 1203.847256] Modules linked in: cpufreq_stats arc4 iwlwifi mac80211 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm uvcvideo btusb videobuf2_core bluetooth videodev snd_timer media cfg80211 r592 v4l2_compat_ioctl32 microcode videobuf2_vmalloc joydev memstick snd videobuf2_memops e1000e i2c_i801 pcspkr iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc sony_laptop tpm_infineon rfkill firewire_ohci firewire_core sdhci_pci sdhci crc_itu_t mmc_core yenta_socket nouveau i915 ttm drm_kms_helper drm mxm_wmi i2c_algo_bit i2c_core wmi video
[ 1203.847256] Pid: 0, comm: swapper/1 Tainted: G        W    3.3.0-rc4+ #1
[ 1203.847256] Call Trace:
[ 1203.847256]  [<ffffffff8106428f>] warn_slowpath_common+0x7f/0xc0
[ 1203.847256]  [<ffffffff810642ea>] warn_slowpath_null+0x1a/0x20
[ 1203.847256]  [<ffffffff8114ac1c>] __perf_event_overflow+0x27c/0x290
[ 1203.847256]  [<ffffffff8114acd9>] perf_swevent_overflow+0xa9/0xc0
[ 1203.847256]  [<ffffffff8114ad5f>] perf_swevent_event+0x6f/0x90
[ 1203.847256]  [<ffffffff8114adf6>] perf_tp_event+0x76/0xf0
[ 1203.847256]  [<ffffffff811414e2>] perf_trace_power+0xd2/0xf0
[ 1203.847256]  [<ffffffff8151806d>] ? cpuidle_idle_call+0x34d/0x620
[ 1203.847256]  [<ffffffff8151806d>] cpuidle_idle_call+0x34d/0x620
[ 1203.847256]  [<ffffffff816a1dae>] ? __atomic_notifier_call_chain+0x3e/0x110
[ 1203.847256]  [<ffffffff81019235>] cpu_idle+0xd5/0x140
[ 1203.847256]  [<ffffffff816873be>] start_secondary+0x294/0x29b
[ 1203.847256] ---[ end trace ce6975b4869f84a3 ]---

